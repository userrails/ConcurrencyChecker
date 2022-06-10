## Service class for simple multithreading
class MultithreadService
  def initialize(obj, accept_key, reject_key)
    @obj = obj
    @accept_key = accept_key
    @reject_key = reject_key
  end

  def run
    approval_url = "http://localhost:4000/articles/#{@obj}/review?approve=#{@accept_key}"
    rejection_url = "http://localhost:4000/articles/#{@obj}/review?deny=#{@reject_key}"

    Thread.new {
      HTTParty.get(approval_url, headers: {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36"
      })
    }

    Thread.new {
      HTTParty.get(rejection_url, headers: {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36"
      })
    }
  end
end

## Example Test Data
obj = Article.find(1212)
first_child = obj.discussions.first
sec_child = obj.discussions.second
third_child = obj.discussions.third

AutoApprovalRejection.new(obj.id, first_child.accept_key, first_child.reject_key).run
AutoApprovalRejection.new(obj.id, sec_child.accept_key, sec_child.reject_key).run
AutoApprovalRejection.new(obj.id, third_child.accept_key, third_child.reject_key).run
