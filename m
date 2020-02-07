Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F26154FA0
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 01:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBGAOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 19:14:37 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:28121 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgBGAOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 19:14:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581034476; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=ezlqKTtkLFhD5rxIgl8DkGkVjPshr5lxsw2CdrseDTQ=; b=AzxBL1VW6Or5QluFmPQAdCOpH9t4yYZy2Eo51MCvT3taGXzO8fSDyjC1KTXj3QDmbiiRLJ3k
 y+kVFaGNxE9C0Itby8HvPnC7l3t818ndBVRqTCxWcAEzurQowqrVlCg378c0Prl748NhCPPt
 Zz0KT/mQXVWSPg76AjTSisogjEY=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3cabde.7fa68b87a6c0-smtp-out-n01;
 Fri, 07 Feb 2020 00:14:22 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 00942C447A3; Fri,  7 Feb 2020 00:14:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from [192.168.142.6] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: clew)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CE35AC433CB;
        Fri,  7 Feb 2020 00:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CE35AC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=clew@codeaurora.org
Subject: Re: [PATCH v2 14/16] net: qrtr: Add MHI transport layer
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     gregkh@linuxfoundation.org, arnd@arndb.de, smohanad@codeaurora.org,
        jhugo@codeaurora.org, kvalo@codeaurora.org,
        bjorn.andersson@linaro.org, hemantk@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200131135009.31477-1-manivannan.sadhasivam@linaro.org>
 <20200131135009.31477-15-manivannan.sadhasivam@linaro.org>
 <20200203101225.43bd27bc@cakuba.hsd1.ca.comcast.net>
 <20200204081914.GB7452@Mani-XPS-13-9360>
From:   Chris Lew <clew@codeaurora.org>
Message-ID: <53018abf-4bc9-1ddb-0be5-a9a3b9871a33@codeaurora.org>
Date:   Thu, 6 Feb 2020 16:14:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200204081914.GB7452@Mani-XPS-13-9360>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/4/2020 12:19 AM, Manivannan Sadhasivam wrote:
> Hi Jakub,
>
> On Mon, Feb 03, 2020 at 10:12:25AM -0800, Jakub Kicinski wrote:
>> On Fri, 31 Jan 2020 19:20:07 +0530, Manivannan Sadhasivam wrote:
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
>>> +
>>> +	kref_put(&pkt->refcount, qrtr_mhi_pkt_release);
>> Which kref_get() does this pair with?
>>
>> Looks like qcom_mhi_qrtr_send() will release a reference after
>> completion, too.
>>
> Yikes, there is some issue here...
>
> Acutally the issue is not in what you referred above but the overall kref
> handling itself. Please see below.
>
> kref_put() should be present in qcom_mhi_qrtr_ul_callback() as it will
> decrement the refcount which got incremented in qcom_mhi_qrtr_send(). It
> should be noted that kref_init() will fix the refcount to 1 and kref_get() will
> increment to 2. So for properly releasing the refcount to 0, we need to call
> kref_put() twice.
>
> So if all goes well, the refcount will get decremented twice in
> qcom_mhi_qrtr_ul_callback() as well as in qcom_mhi_qrtr_send() and we are good.
>
> But, if the transfer has failed ie., when qcom_mhi_qrtr_ul_callback() doesn't
> get called, then we are leaking the refcount. I need to rework the kref handling
> code in next iteration.
>
> Thanks for triggering this!
>
> Regards,
> Mani
>
>>> +	spin_unlock_irqrestore(&qdev->ul_lock, flags);
>>> +}

Hi Mani,

I'm not sure if this was changed in your patches but MHI is supposed to give a
ul_callback() for any packet that is successfully queued. In the case of the
transfer failing, the ul_callback() should still be called so there should
be no refcount leaking. It is an essential assumption I made, if that no longer
holds true then the entire driver needs to be reworked.

Thanks,
Chris

-- 

Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
