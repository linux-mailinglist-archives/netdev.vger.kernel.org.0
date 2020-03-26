Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A8F194BD2
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 23:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbgCZWy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 18:54:59 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:19209 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgCZWy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 18:54:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585263298; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=IoLIrlXsOISidVHXZwSqy2RqmHNG97uCKmI4Rf/piE4=; b=uADoUJt9BoNrwgLMA+wV1+35WU9n/7ixGvyf/YueFF4L3HghppnjfCoFbt9bmFx1qHIT6esD
 t2vQUEvkmpal7l5fcltaqeiOu7FU5IBetUySUYTH1C4tfA89du2c9Oqo++cL/GDfQgg0bN/O
 rUc4vH0sf2WNby46UXgnx3cjHZg=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7d32b5.7f4ccf7f9f10-smtp-out-n05;
 Thu, 26 Mar 2020 22:54:45 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 996BDC44788; Thu, 26 Mar 2020 22:54:45 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.142.6] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: clew)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 92F8DC433BA;
        Thu, 26 Mar 2020 22:54:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 92F8DC433BA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=clew@codeaurora.org
Subject: Re: [PATCH v3 6/7] net: qrtr: Add MHI transport layer
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     gregkh@linuxfoundation.org, davem@davemloft.net,
        smohanad@codeaurora.org, jhugo@codeaurora.org,
        kvalo@codeaurora.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200324061050.14845-1-manivannan.sadhasivam@linaro.org>
 <20200324061050.14845-7-manivannan.sadhasivam@linaro.org>
 <20200324203952.GC119913@minitux> <20200325103758.GA7216@Mani-XPS-13-9360>
From:   Chris Lew <clew@codeaurora.org>
Message-ID: <89f3c60c-70fb-23d3-d50f-98d1982b84b9@codeaurora.org>
Date:   Thu, 26 Mar 2020 15:54:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325103758.GA7216@Mani-XPS-13-9360>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 3:37 AM, Manivannan Sadhasivam wrote:
> Hi Bjorn,
> 
> + Chris Lew
> 
> On Tue, Mar 24, 2020 at 01:39:52PM -0700, Bjorn Andersson wrote:
>> On Mon 23 Mar 23:10 PDT 2020, Manivannan Sadhasivam wrote:
>>
>>> MHI is the transport layer used for communicating to the external modems.
>>> Hence, this commit adds MHI transport layer support to QRTR for
>>> transferring the QMI messages over IPC Router.
>>>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: netdev@vger.kernel.org
>>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>>> ---
>>>   net/qrtr/Kconfig  |   7 ++
>>>   net/qrtr/Makefile |   2 +
>>>   net/qrtr/mhi.c    | 208 ++++++++++++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 217 insertions(+)
>>>   create mode 100644 net/qrtr/mhi.c
>>>
>>> diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
>>> index 63f89cc6e82c..8eb876471564 100644
>>> --- a/net/qrtr/Kconfig
>>> +++ b/net/qrtr/Kconfig
>>> @@ -29,4 +29,11 @@ config QRTR_TUN
>>>   	  implement endpoints of QRTR, for purpose of tunneling data to other
>>>   	  hosts or testing purposes.
>>>   
>>> +config QRTR_MHI
>>> +	tristate "MHI IPC Router channels"
>>> +	depends on MHI_BUS
>>> +	help
>>> +	  Say Y here to support MHI based ipcrouter channels. MHI is the
>>> +	  transport used for communicating to external modems.
>>> +
>>>   endif # QRTR
>>> diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
>>> index 1c6d6c120fb7..3dc0a7c9d455 100644
>>> --- a/net/qrtr/Makefile
>>> +++ b/net/qrtr/Makefile
>>> @@ -5,3 +5,5 @@ obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
>>>   qrtr-smd-y	:= smd.o
>>>   obj-$(CONFIG_QRTR_TUN) += qrtr-tun.o
>>>   qrtr-tun-y	:= tun.o
>>> +obj-$(CONFIG_QRTR_MHI) += qrtr-mhi.o
>>> +qrtr-mhi-y	:= mhi.o
>>> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
>>> new file mode 100644
>>> index 000000000000..90af208f34c1
>>> --- /dev/null
>>> +++ b/net/qrtr/mhi.c
>>> @@ -0,0 +1,208 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (c) 2018-2020, The Linux Foundation. All rights reserved.
>>> + */
>>> +
>>> +#include <linux/mhi.h>
>>> +#include <linux/mod_devicetable.h>
>>> +#include <linux/module.h>
>>> +#include <linux/skbuff.h>
>>> +#include <net/sock.h>
>>> +
>>> +#include "qrtr.h"
>>> +
>>> +struct qrtr_mhi_dev {
>>> +	struct qrtr_endpoint ep;
>>> +	struct mhi_device *mhi_dev;
>>> +	struct device *dev;
>>> +	spinlock_t ul_lock;		/* lock to protect ul_pkts */
>>> +	struct list_head ul_pkts;
>>> +	atomic_t in_reset;
>>> +};
>>> +
>>> +struct qrtr_mhi_pkt {
>>> +	struct list_head node;
>>> +	struct sk_buff *skb;
>>> +	struct kref refcount;
>>> +	struct completion done;
>>> +};
>>> +
>>> +static void qrtr_mhi_pkt_release(struct kref *ref)
>>> +{
>>> +	struct qrtr_mhi_pkt *pkt = container_of(ref, struct qrtr_mhi_pkt,
>>> +						refcount);
>>> +	struct sock *sk = pkt->skb->sk;
>>> +
>>> +	consume_skb(pkt->skb);
>>> +	if (sk)
>>> +		sock_put(sk);
>>> +
>>> +	kfree(pkt);
>>> +}
>>> +
>>> +/* From MHI to QRTR */
>>> +static void qcom_mhi_qrtr_dl_callback(struct mhi_device *mhi_dev,
>>> +				      struct mhi_result *mhi_res)
>>> +{
>>> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
>>> +	int rc;
>>> +
>>> +	if (!qdev || mhi_res->transaction_status)
>>> +		return;
>>> +
>>> +	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
>>> +				mhi_res->bytes_xferd);
>>> +	if (rc == -EINVAL)
>>> +		dev_err(qdev->dev, "invalid ipcrouter packet\n");
>>
>> Perhaps this should be a debug print, perhaps rate limited. But either
>> way it's relevant for any transport, so I think you should skip it here
>> - and potentially move it into qrtr_endpoint_post() in some form.
>>
> 
> I agree with moving this to qrtr_endpoint_post() but I don't think it is a
> good idea to make it as a debug print. It is an error log and should stay
> as it is. Only in this MHI transport driver, the return value is not getting
> used but in others it is.
> 

This print has been useful for catching transport errors. Only issue I 
see with moving this to qrtr_endpoint_post() is that there are multiple 
points of failure in qrtr_endpoint_post() and logging it here makes it 
easier.

>>> +}
>>> +
>>> +/* From QRTR to MHI */
>>> +static void qcom_mhi_qrtr_ul_callback(struct mhi_device *mhi_dev,
>>> +				      struct mhi_result *mhi_res)
>>> +{
>>> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
>>> +	struct qrtr_mhi_pkt *pkt;
>>> +	unsigned long flags;
>>> +
>>> +	spin_lock_irqsave(&qdev->ul_lock, flags);
>>> +	pkt = list_first_entry(&qdev->ul_pkts, struct qrtr_mhi_pkt, node);
>>> +	list_del(&pkt->node);
>>> +	complete_all(&pkt->done);
>>
>> You should be able to release the lock after popping the item off the
>> list, then complete and refcount it.
>>
> 
> Okay.
> 
>>> +
>>> +	kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
>>> +	spin_unlock_irqrestore(&qdev->ul_lock, flags);
>>> +}
>>> +
>>> +static void qcom_mhi_qrtr_status_callback(struct mhi_device *mhi_dev,
>>> +					  enum mhi_callback mhi_cb)
>>> +{
>>> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
>>> +	struct qrtr_mhi_pkt *pkt;
>>> +	unsigned long flags;
>>> +
>>> +	if (mhi_cb != MHI_CB_FATAL_ERROR)
>>> +		return;
>>> +
>>> +	atomic_inc(&qdev->in_reset);
>>
>> You have ul_lock close at hand in both places where you access in_reset,
>> so I think it would be better to just use that, instead of an atomic.
>>
> 
> Okay.
> 

Does this version of MHI give the MHI_CB_FATAL_ERROR as a status 
callback? We added this as an early notifier workaround. The in_reset 
code probably isn't required with the current feature set.

>>> +	spin_lock_irqsave(&qdev->ul_lock, flags);
>>> +	list_for_each_entry(pkt, &qdev->ul_pkts, node)
>>> +		complete_all(&pkt->done);
> 
> Chris, shouldn't we require list_del(&pkt->node) here?
>

No this isn't a full cleanup, with the "early notifier" we just 
unblocked any threads waiting for the ul_callback. Those threads will 
wake, check in_reset, return an error back to the caller. Any list 
cleanup will be done in the ul_callbacks that the mhi bus will do for 
each queued packet right before device remove.

Again to simplify the code, we can probable remove the in_reset handling 
since it's not required with the current feature set.

>>> +	spin_unlock_irqrestore(&qdev->ul_lock, flags);
>>> +}
>>> +
>>> +/* Send data over MHI */
>>> +static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
>>> +{
>>> +	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
>>> +	struct qrtr_mhi_pkt *pkt;
>>> +	int rc;
>>> +
>>> +	rc = skb_linearize(skb);
>>> +	if (rc) {
>>> +		kfree_skb(skb);
>>> +		return rc;
>>> +	}
>>> +
>>> +	pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
>>> +	if (!pkt) {
>>> +		kfree_skb(skb);
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	init_completion(&pkt->done);
>>> +	kref_init(&pkt->refcount);
>>> +	kref_get(&pkt->refcount);
>>> +	pkt->skb = skb;
>>> +
>>> +	spin_lock_bh(&qdev->ul_lock);
>>> +	list_add_tail(&pkt->node, &qdev->ul_pkts);
>>> +	rc = mhi_queue_skb(qdev->mhi_dev, DMA_TO_DEVICE, skb, skb->len,
>>> +			   MHI_EOT);
>>
>> Do you want to continue doing this when qdev->in_reset? Wouldn't it be
>> better to bail early if the remote end is dying?
>>
> 
> Now I'm thinking why we are not decrementing in_reset anywhere! Incase of
> SYS_ERR, the status_cb will get processed and in_reset will be set but
> it will stay so even when after MHI gets reset.
> 
> Chris, can you please clarify?
> 

Early notify of reset, if we do get SYS_ERR, we expect remove to be 
called *soon*.

>>> +	if (rc) {
>>> +		list_del(&pkt->node);
>>> +		/* Reference count needs to be dropped 2 times */
>>> +		kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
>>> +		kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
>>> +		kfree_skb(skb);
>>> +		spin_unlock_bh(&qdev->ul_lock);
>>> +		return rc;
>>> +	}
>>> +
>>> +	spin_unlock_bh(&qdev->ul_lock);
>>> +	if (skb->sk)
>>> +		sock_hold(skb->sk);
>>> +
>>> +	rc = wait_for_completion_interruptible_timeout(&pkt->done, HZ * 5);
>>> +	if (atomic_read(&qdev->in_reset))
>>> +		rc = -ECONNRESET;
>>> +	else if (rc == 0)
>>> +		rc = -ETIMEDOUT;
>>
>> Is this recoverable? The message will remain on the list and may be
>> delivered at a later point(?), but qrtr and the app will learn that the
>> message was lost - which is presumably considered fatal.
>>
>> Is it guaranteed that qcom_mhi_qrtr_ul_callback() will happen later and
>> find the head of the list?
>>
> 
> There are 2 scenarios:
> 
> 1. If the completion interrupt happens after timeout, ul_callback()
> will be called. But it will only try to fetch the current head of ul_pkts.
> In most cases, we can hope that the completion interrupt will happen before
> next queue_skb().
> 
> 2. If we don't get completion interrupt, timeout will happen and at the final
> stage (during mhi_driver_remove()), MHI stack will go over the pending TREs
> for all channels in queue and call ul_callback() with -ENOTCONN. But in the
> callback, we don't have any idea of the pkt which was not successfully
> transferred to the device and currently just fetching first entry.
> 
> Now I'm seeing some issue here which I missed earlier. If the completion
> interrupt never happens then the corresponding pkt will never get freed and
> therefore we have a leak. Eventhough the ul_callback() will get called during
> mhi_driver_remove() for pending TREs, we don't exactly fetch the right pkt.
> 
> Chris, our assumption of the ul_callback() gets called irrespective of
> transfer status is wrong. I think this code needs a bit of rework.
> 
>>
>> The reason for my question is that without this you have one of two
>> scenarios;
>> 1) the message is put on the list, decremented in
>> qcom_mhi_qrtr_ul_callback() then we get back here and decrement it
>> again.
>> 2) the message is put on the list, then qcom_mhi_qrtr_status_callback()
>> happens and all messages are released - presumably then
>> qcom_mhi_qrtr_ul_callback() won't happen.
>>
>>
>> So if the third case (where we return here and then later
>> qcom_mhi_qrtr_ul_callback() must find this particular packet at the
>> front of the queue) can't happen, then you can just skip the entire
>> refcounting.
>>
>> Further more, you could carry qrtr_mhi_pkt on the stack.
>>
>>
>> ...or to flip this around, is there a reason to wait here at all? What
>> would happen if you just return immediately after calling
>> mhi_queue_skb()? Wouldn't that provide you better throughput?
>>
> 
> Chris would be best person to answer this question.
> 

Yea - after working with MHI for a bit now, I think we can definitely 
return after queueing the skb.

The IPC-Router Protocol, wasn't really designed with the ability to 
recover from dropped packets since SMD/GLINK are "Lossless". I figured 
it would be better for the client to definitely know that the packet 
reached the other side which is why it blocks until ul callback.

I thought having the client get an error on timeout and resend the 
packet would be better than silently dropping it. In practice, we've 
really only seen the timeout or ul_callback errors on unrecoverable 
errors so I think the timeout handling can definitely be redone.

Thanks,
Chris

>>> +	else if (rc > 0)
>>> +		rc = 0;
>>> +
>>> +	kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
>>> +
>>> +	return rc;
>>> +}
>>> +
>>> +static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>>> +			       const struct mhi_device_id *id)
>>> +{
>>> +	struct qrtr_mhi_dev *qdev;
>>> +	u32 net_id;
>>> +	int rc;
>>> +
>>> +	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
>>> +	if (!qdev)
>>> +		return -ENOMEM;
>>> +
>>> +	qdev->mhi_dev = mhi_dev;
>>> +	qdev->dev = &mhi_dev->dev;
>>> +	qdev->ep.xmit = qcom_mhi_qrtr_send;
>>> +	atomic_set(&qdev->in_reset, 0);
>>> +
>>> +	net_id = QRTR_EP_NID_AUTO;
>>
>> Just pass QRTR_EP_NID_AUTO directly in the function call below.
>>
> 
> Okay.
> 
> Thanks,
> Mani
> 
>> Regards,
>> Bjorn
>>
>>> +
>>> +	INIT_LIST_HEAD(&qdev->ul_pkts);
>>> +	spin_lock_init(&qdev->ul_lock);
>>> +
>>> +	dev_set_drvdata(&mhi_dev->dev, qdev);
>>> +	rc = qrtr_endpoint_register(&qdev->ep, net_id);
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void qcom_mhi_qrtr_remove(struct mhi_device *mhi_dev)
>>> +{
>>> +	struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
>>> +
>>> +	qrtr_endpoint_unregister(&qdev->ep);
>>> +	dev_set_drvdata(&mhi_dev->dev, NULL);
>>> +}
>>> +
>>> +static const struct mhi_device_id qcom_mhi_qrtr_id_table[] = {
>>> +	{ .chan = "IPCR" },
>>> +	{}
>>> +};
>>> +MODULE_DEVICE_TABLE(mhi, qcom_mhi_qrtr_id_table);
>>> +
>>> +static struct mhi_driver qcom_mhi_qrtr_driver = {
>>> +	.probe = qcom_mhi_qrtr_probe,
>>> +	.remove = qcom_mhi_qrtr_remove,
>>> +	.dl_xfer_cb = qcom_mhi_qrtr_dl_callback,
>>> +	.ul_xfer_cb = qcom_mhi_qrtr_ul_callback,
>>> +	.status_cb = qcom_mhi_qrtr_status_callback,
>>> +	.id_table = qcom_mhi_qrtr_id_table,
>>> +	.driver = {
>>> +		.name = "qcom_mhi_qrtr",
>>> +	},
>>> +};
>>> +
>>> +module_mhi_driver(qcom_mhi_qrtr_driver);
>>> +
>>> +MODULE_DESCRIPTION("Qualcomm IPC-Router MHI interface driver");
>>> +MODULE_LICENSE("GPL v2");
>>> -- 
>>> 2.17.1
>>>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
