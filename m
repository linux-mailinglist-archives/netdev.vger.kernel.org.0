Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D742A126F
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgJaB0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:26:47 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:57593 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgJaB0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 21:26:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604107605; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=MteW9QHKC42Uof1/VdkQH9CpC6FFNx/EFf9DI/O6G5c=; b=uL9gHjf1Xu5wFRS/YqiLaxerxTM+pPZFGbeU50qREZ5nvnaNX0LRKNyjA5Kgph/okz5LLylM
 J0+GMGyeMkJqJmiXcifmnm0BRFc/gEmVdkOLuRogmSX+uICWWocfZ4P66kYenkj1tPM9sd+G
 1EQzJVsH2QX7Ch4qrav6hIIGglc=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5f9cbd506b237554e6f451c8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 31 Oct 2020 01:26:40
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 919E1C433C6; Sat, 31 Oct 2020 01:26:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.2 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 92B9DC433C8;
        Sat, 31 Oct 2020 01:26:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 92B9DC433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH v11 4/4] bus: mhi: Add userspace client interface driver
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     gregkh@linuxfoundation.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhugo@codeaurora.org,
        bbhatt@codeaurora.org, loic.poulain@linaro.org,
        netdev@vger.kernel.org
References: <1604025946-28288-1-git-send-email-hemantk@codeaurora.org>
 <1604025946-28288-5-git-send-email-hemantk@codeaurora.org>
 <20201030103410.GD3818@Mani-XPS-13-9360>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <5cfbcc14-5fd2-b1ae-8a3d-ac28d567a74d@codeaurora.org>
Date:   Fri, 30 Oct 2020 18:26:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030103410.GD3818@Mani-XPS-13-9360>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mani,

On 10/30/20 3:34 AM, Manivannan Sadhasivam wrote:
> Hi Hemant,
> 
> On Thu, Oct 29, 2020 at 07:45:46PM -0700, Hemant Kumar wrote:
>> This MHI client driver allows userspace clients to transfer
>> raw data between MHI device and host using standard file operations.
>> Driver instantiates UCI device object which is associated to device
>> file node. UCI device object instantiates UCI channel object when device
>> file node is opened. UCI channel object is used to manage MHI channels
>> by calling MHI core APIs for read and write operations. MHI channels
>> are started as part of device open(). MHI channels remain in start
>> state until last release() is called on UCI device file node. Device
>> file node is created with format
>>
>> /dev/mhi_<controller_name>_<mhi_device_name>
>>
>> Currently it supports LOOPBACK channel.
>>
>> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> 
> Thanks for continuously updating the series based on reviews, now the locking
> part looks a _lot_ cleaner than it used to be. I just have one query (inline)
> regarding the usage of refcount for uci_chan and uci_dev. Once you fix that,
> I think this is good to go in.
Thanks for reviewing my changes.

[..]

>> +#define DEVICE_NAME "mhi"
>> +#define MHI_UCI_DRIVER_NAME "mhi_uci"
>> +#define MAX_UCI_MINORS 128
> 
> Prefix MHI for these.
Done.

> 
>> +
>> +static DEFINE_IDR(uci_idr);
>> +static DEFINE_MUTEX(uci_drv_mutex);
>> +static struct class *uci_dev_class;
>> +static int uci_dev_major;
>> +
>> +/**
>> + * struct uci_chan - MHI channel for a UCI device
>> + * @udev: associated UCI device object
>> + * @ul_wq: wait queue for writer
>> + * @write_lock: mutex write lock for ul channel
>> + * @dl_wq: wait queue for reader
>> + * @read_lock: mutex read lock for dl channel
>> + * @dl_pending_lock: spin lock for dl_pending list
>> + * @dl_pending: list of dl buffers userspace is waiting to read
>> + * @cur_buf: current buffer userspace is reading
>> + * @dl_size: size of the current dl buffer userspace is reading
>> + * @ref_count: uci_chan reference count
>> + */
>> +struct uci_chan {
>> +	struct uci_dev *udev;
>> +	wait_queue_head_t ul_wq;
>> +
>> +	/* ul channel lock to synchronize multiple writes */
> 
> I asked you to move these comments to Kdoc in previous iteration.
There are multiple revisions of UCI pushed after i responded on this 
one. On V7 i responded to your comment  :)

"This was added because checkpatch --strict required to add a comment 
when lock is added to struct, after adding inline comment, checkpatch 
error was gone."

i was sticking to --strict option. Considering it is best to address 
what --strict is complaining for.
> 
>> +	struct mutex write_lock;
>> +
>> +	wait_queue_head_t dl_wq;
>> +
>> +	/* dl channel lock to synchronize multiple reads */
>> +	struct mutex read_lock;
>> +
>> +	/*
>> +	 * protects pending list in bh context, channel release, read and
>> +	 * poll
>> +	 */
>> +	spinlock_t dl_pending_lock;
>> +
>> +	struct list_head dl_pending;
>> +	struct uci_buf *cur_buf;
>> +	size_t dl_size;
>> +	struct kref ref_count;
> 
> I'm now thinking that instead of having two reference counts for uci_chan and
> uci_dev, why can't you club them together and just use uci_dev's refcount to
> handle the channel management also.
> 
> For instance in uci_open, you are incrementing the refcount for uci_dev before
> starting the channel and then doing the same for uci_chan in
> mhi_uci_dev_start_chan(). So why can't you just use a single refcount once the
> mhi_uci_dev_start_chan() succeeds? The UCI device is useless without a channel,
> isn't it?
Main idea is to have the uci driver probed (uci device object is 
instantiated) but it is possible that device node is not opened or if it 
was opened before and release() was called after that. So UCI channel is 
not active but device node would continue to exist. Which can be opened 
again and channel would move to start state. So we dont want to couple 
mhi driver probe with starting of channels. We start channels only when 
it is really needed. This would allow MHI device to go to lower power 
state when channels are disabled.

[..]

>> +
>> +static int mhi_queue_inbound(struct uci_dev *udev)
>> +{
>> +	struct mhi_device *mhi_dev = udev->mhi_dev;
>> +	struct device *dev = &mhi_dev->dev;
>> +	int nr_trbs, i, ret = -EIO;
> 
> s/nr_trbs/nr_desc
Done.
> 
>> +	size_t dl_buf_size;
>> +	void *buf;
>> +	struct uci_buf *ubuf;
>> +
>> +	/* dont queue if dl channel is not supported */
>> +	if (!udev->mhi_dev->dl_chan)
>> +		return 0;
> 
> Not returning an error?
Here we dont need to return error because when open is called it would 
call this function and if dl_chan is not supported we still want to 
return success for a uci device which only supports UL channel.
Keeping this check inside function looks clean so i am not adding this 
check in open().

[..]

>> +static __poll_t mhi_uci_poll(struct file *file, poll_table *wait)
>> +{
>> +	struct uci_dev *udev = file->private_data;
>> +	struct mhi_device *mhi_dev = udev->mhi_dev;
>> +	struct device *dev = &mhi_dev->dev;
>> +	struct uci_chan *uchan = udev->uchan;
>> +	__poll_t mask = 0;
>> +
>> +	poll_wait(file, &udev->uchan->ul_wq, wait);
>> +	poll_wait(file, &udev->uchan->dl_wq, wait);
>> +
>> +	if (!udev->enabled) {
>> +		mask = EPOLLERR;
>> +		goto done;
>> +	}
>> +
>> +	spin_lock_bh(&uchan->dl_pending_lock);
>> +	if (!list_empty(&uchan->dl_pending) || uchan->cur_buf) {
>> +		dev_dbg(dev, "Client can read from node\n");
> 
> Since you're printing the mask, no need of the debug statement here.
Done.
> 
>> +		mask |= EPOLLIN | EPOLLRDNORM;
>> +	}
>> +	spin_unlock_bh(&uchan->dl_pending_lock);
>> +
>> +	if (mhi_get_free_desc_count(mhi_dev, DMA_TO_DEVICE) > 0) {
>> +		dev_dbg(dev, "Client can write to node\n");
> 
> Same as above.
Done.
> 
>> +		mask |= EPOLLOUT | EPOLLWRNORM;
>> +	}
>> +
>> +	dev_dbg(dev, "Client attempted to poll, returning mask 0x%x\n", mask);
>> +
>> +done:
>> +	return mask;
>> +}
>> +
>> +static ssize_t mhi_uci_write(struct file *file,
>> +			     const char __user *buf,
>> +			     size_t count,
>> +			     loff_t *offp)
>> +{
>> +	struct uci_dev *udev = file->private_data;
>> +	struct mhi_device *mhi_dev = udev->mhi_dev;
>> +	struct device *dev = &mhi_dev->dev;
>> +	struct uci_chan *uchan = udev->uchan;
>> +	size_t bytes_xfered = 0;
>> +	int ret, nr_avail = 0;
> 
> s/nr_avail/nr_desc
Done.
> 
>> +
>> +	/* if ul channel is not supported return error */
>> +	if (!buf || !count || !mhi_dev->ul_chan)
> 
> Shouldn't we return ENOTSUPP for !mhi_dev->dl_chan?
make sense, i can add a separate if check for !mhi_dev->dl_chan.
> 
>> +		return -EINVAL;
>> +
>> +	dev_dbg(dev, "%s: to xfer: %zu bytes\n", __func__, count);
>> +
>> +	if (mutex_lock_interruptible(&uchan->write_lock))
>> +		return -EINTR;
>> +
>> +	while (count) {
>> +		size_t xfer_size;
>> +		void *kbuf;
>> +		enum mhi_flags flags;
>> +
>> +		/* wait for free descriptors */
>> +		ret = wait_event_interruptible(uchan->ul_wq,
>> +					       (!udev->enabled) ||
>> +				(nr_avail = mhi_get_free_desc_count(mhi_dev,
>> +					       DMA_TO_DEVICE)) > 0);
>> +
>> +		if (ret == -ERESTARTSYS) {
>> +			dev_dbg(dev, "Interrupted by a signal in %s, exiting\n",
>> +				__func__);
>> +			goto err_mtx_unlock;
>> +		}
>> +
>> +		if (!udev->enabled) {
>> +			ret = -ENODEV;
>> +			goto err_mtx_unlock;
>> +		}
>> +
>> +		xfer_size = min_t(size_t, count, udev->mtu);
>> +		kbuf = kmalloc(xfer_size, GFP_KERNEL);
>> +		if (!kbuf) {
>> +			ret = -ENOMEM;
>> +			goto err_mtx_unlock;
>> +		}
>> +
>> +		ret = copy_from_user(kbuf, buf, xfer_size);
>> +		if (ret) {
>> +			kfree(kbuf);
>> +			ret = -EFAULT;
>> +			goto err_mtx_unlock;
>> +		}
>> +
>> +		/* if ring is full after this force EOT */
>> +		if (nr_avail > 1 && (count - xfer_size))
>> +			flags = MHI_CHAIN;
>> +		else
>> +			flags = MHI_EOT;
>> +
>> +		ret = mhi_queue_buf(mhi_dev, DMA_TO_DEVICE, kbuf, xfer_size,
>> +				    flags);
>> +		if (ret) {
>> +			kfree(kbuf);
>> +			goto err_mtx_unlock;
>> +		}
>> +
>> +		bytes_xfered += xfer_size;
>> +		count -= xfer_size;
>> +		buf += xfer_size;
>> +	}
>> +
>> +	mutex_unlock(&uchan->write_lock);
>> +	dev_dbg(dev, "%s: bytes xferred: %zu\n", __func__, bytes_xfered);
>> +
>> +	return bytes_xfered;
>> +
>> +err_mtx_unlock:
>> +	mutex_unlock(&uchan->write_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static ssize_t mhi_uci_read(struct file *file,
>> +			    char __user *buf,
>> +			    size_t count,
>> +			    loff_t *ppos)
>> +{
>> +	struct uci_dev *udev = file->private_data;
>> +	struct mhi_device *mhi_dev = udev->mhi_dev;
>> +	struct uci_chan *uchan = udev->uchan;
>> +	struct device *dev = &mhi_dev->dev;
>> +	struct uci_buf *ubuf;
>> +	size_t rx_buf_size;
>> +	char *ptr;
>> +	size_t to_copy;
>> +	int ret = 0;
>> +
>> +	/* if dl channel is not supported return error */
>> +	if (!buf || !mhi_dev->dl_chan)
>> +		return -EINVAL;
> 
> Shouldn't we return ENOTSUPP for !mhi_dev->dl_chan?
Done.
> 
>> +
>> +	if (mutex_lock_interruptible(&uchan->read_lock))
>> +		return -EINTR;
>> +
>> +	spin_lock_bh(&uchan->dl_pending_lock);
>> +	/* No data available to read, wait */
>> +	if (!uchan->cur_buf && list_empty(&uchan->dl_pending)) {
>> +		dev_dbg(dev, "No data available to read, waiting\n");
>> +
>> +		spin_unlock_bh(&uchan->dl_pending_lock);
>> +		ret = wait_event_interruptible(uchan->dl_wq,
>> +					       (!udev->enabled ||
>> +					      !list_empty(&uchan->dl_pending)));
>> +
>> +		if (ret == -ERESTARTSYS) {
>> +			dev_dbg(dev, "Interrupted by a signal in %s, exiting\n",
>> +				__func__);
>> +			goto err_mtx_unlock;
>> +		}
>> +
>> +		if (!udev->enabled) {
>> +			ret = -ENODEV;
>> +			goto err_mtx_unlock;
>> +		}
>> +		spin_lock_bh(&uchan->dl_pending_lock);
>> +	}
>> +
>> +	/* new read, get the next descriptor from the list */
>> +	if (!uchan->cur_buf) {
>> +		ubuf = list_first_entry_or_null(&uchan->dl_pending,
>> +						struct uci_buf, node);
>> +		if (!ubuf) {
>> +			ret = -EIO;
>> +			goto err_spin_unlock;
>> +		}
>> +
>> +		list_del(&ubuf->node);
>> +		uchan->cur_buf = ubuf;
>> +		uchan->dl_size = ubuf->len;
>> +		dev_dbg(dev, "Got pkt of size: %zu\n", uchan->dl_size);
>> +	}
>> +	spin_unlock_bh(&uchan->dl_pending_lock);
>> +
>> +	ubuf = uchan->cur_buf;
>> +
>> +	/* Copy the buffer to user space */
>> +	to_copy = min_t(size_t, count, uchan->dl_size);
>> +	ptr = ubuf->data + (ubuf->len - uchan->dl_size);
>> +
>> +	ret = copy_to_user(buf, ptr, to_copy);
>> +	if (ret) {
>> +		ret = -EFAULT;
>> +		goto err_mtx_unlock;
>> +	}
>> +
>> +	dev_dbg(dev, "Copied %zu of %zu bytes\n", to_copy, uchan->dl_size);
>> +	uchan->dl_size -= to_copy;
>> +
>> +	/* we finished with this buffer, queue it back to hardware */
>> +	if (!uchan->dl_size) {
>> +		uchan->cur_buf = NULL;
>> +
>> +		rx_buf_size = udev->mtu - sizeof(*ubuf);
>> +		ret = mhi_queue_buf(mhi_dev, DMA_FROM_DEVICE, ubuf->data,
>> +				    rx_buf_size, MHI_EOT);
>> +		if (ret) {
>> +			dev_err(dev, "Failed to recycle element: %d\n", ret);
>> +			kfree(ubuf->data);
>> +			goto err_mtx_unlock;
>> +		}
>> +	}
>> +	mutex_unlock(&uchan->read_lock);
>> +
>> +	dev_dbg(dev, "%s: Returning %zu bytes\n", __func__, to_copy);
>> +
>> +	return to_copy;
>> +
>> +err_spin_unlock:
>> +	spin_unlock_bh(&uchan->dl_pending_lock);
>> +err_mtx_unlock:
>> +	mutex_unlock(&uchan->read_lock);
>> +	return ret;
>> +}
>> +
>> +static const struct file_operations mhidev_fops = {
>> +	.owner = THIS_MODULE,
>> +	.open = mhi_uci_open,
>> +	.release = mhi_uci_release,
>> +	.read = mhi_uci_read,
>> +	.write = mhi_uci_write,
>> +	.poll = mhi_uci_poll,
>> +};
>> +
>> +static void mhi_ul_xfer_cb(struct mhi_device *mhi_dev,
>> +			   struct mhi_result *mhi_result)
>> +{
>> +	struct uci_dev *udev = dev_get_drvdata(&mhi_dev->dev);
>> +	struct uci_chan *uchan = udev->uchan;
>> +	struct device *dev = &mhi_dev->dev;
>> +
>> +	dev_dbg(dev, "status: %d xfer_len: %zu\n",
>> +		mhi_result->transaction_status, mhi_result->bytes_xferd);
> 
> How this print is going to be useful alone? Atleast you should print the
> function name.
Done. will add __func__.
> 
>> +
>> +	kfree(mhi_result->buf_addr);
>> +
>> +	if (!mhi_result->transaction_status)
>> +		wake_up(&uchan->ul_wq);
>> +}
>> +
>> +static void mhi_dl_xfer_cb(struct mhi_device *mhi_dev,
>> +			   struct mhi_result *mhi_result)
>> +{
>> +	struct uci_dev *udev = dev_get_drvdata(&mhi_dev->dev);
>> +	struct uci_chan *uchan = udev->uchan;
>> +	struct device *dev = &mhi_dev->dev;
>> +	struct uci_buf *ubuf;
>> +	size_t dl_buf_size = udev->mtu - sizeof(*ubuf);
>> +
>> +	dev_dbg(dev, "status: %d receive_len: %zu\n",
>> +		mhi_result->transaction_status, mhi_result->bytes_xferd);
> 
> Same as above.
Done.
>

[..]

Thanks,
Hemant

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
