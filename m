Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BBA2C4732
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732934AbgKYSBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:01:55 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:39750 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731836AbgKYSBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 13:01:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606327312; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=7LPkOcaw/p1knQ5KtExLHuxB75BuhzPxHs8gh80hyuw=; b=Hfr9rcRpw2v4Tybcbmj3PAxRw57Dwx7wBAmJFAAELTgaJ0kCEC3bWMLo16FSCoEnvo6TB5Sn
 acYU0gdEkfQoG3bIbQ7OZ2nL9SGSvvGAnZ8kz/LfFCz4F1vFDn5INpc4oG9pSg5QyZ/ENYhx
 V0vqtw0bsLjdiwaaZPz82tMOYtc=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fbe9be6e9b7088622a3b235 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 18:01:10
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 38A88C43463; Wed, 25 Nov 2020 18:01:09 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF425C433ED;
        Wed, 25 Nov 2020 18:01:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF425C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH] net: qrtr: Unprepare MHI channels during remove
To:     bbhatt@codeaurora.org
Cc:     Loic Poulain <loic.poulain@linaro.org>, ath11k@lists.infradead.org,
        cjhuang@codeaurora.org, clew@codeaurora.org,
        hemantk@codeaurora.org, kvalo@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, jhugo=codeaurora.org@codeaurora.org
References: <1605723625-11206-1-git-send-email-bbhatt@codeaurora.org>
 <5e94c0be-9402-7309-5d65-857a27d1f491@codeaurora.org>
 <CAMZdPi_b0=qFNGi1yUke3Dip2bi-zW4ULTg8W4nbyPyEsE3D4w@mail.gmail.com>
 <2019fe3c-55c5-61fe-758c-1e9952e1cb33@codeaurora.org>
 <647d1520d0bcefa7ff02d2ef5ee81bd1@codeaurora.org>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <e8eb7b2b-bb25-cba9-f487-1a0889d8cd93@codeaurora.org>
Date:   Wed, 25 Nov 2020 11:01:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <647d1520d0bcefa7ff02d2ef5ee81bd1@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/2020 12:02 PM, Bhaumik Bhatt wrote:
> On 2020-11-18 11:34 AM, Jeffrey Hugo wrote:
>> On 11/18/2020 12:14 PM, Loic Poulain wrote:
>>>
>>>
>>> Le mer. 18 nov. 2020 à 19:34, Jeffrey Hugo <jhugo@codeaurora.org 
>>> <mailto:jhugo@codeaurora.org>> a écrit :
>>>
>>>     On 11/18/2020 11:20 AM, Bhaumik Bhatt wrote:
>>>      > Reset MHI device channels when driver remove is called due to
>>>      > module unload or any crash scenario. This will make sure that
>>>      > MHI channels no longer remain enabled for transfers since the
>>>      > MHI stack does not take care of this anymore after the auto-start
>>>      > channels feature was removed.
>>>      >
>>>      > Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org
>>>     <mailto:bbhatt@codeaurora.org>>
>>>      > ---
>>>      >   net/qrtr/mhi.c | 1 +
>>>      >   1 file changed, 1 insertion(+)
>>>      >
>>>      > diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
>>>      > index 7100f0b..2bf2b19 100644
>>>      > --- a/net/qrtr/mhi.c
>>>      > +++ b/net/qrtr/mhi.c
>>>      > @@ -104,6 +104,7 @@ static void qcom_mhi_qrtr_remove(struct
>>>     mhi_device *mhi_dev)
>>>      >       struct qrtr_mhi_dev *qdev = dev_get_drvdata(&mhi_dev->dev);
>>>      >
>>>      >       qrtr_endpoint_unregister(&qdev->ep);
>>>      > +     mhi_unprepare_from_transfer(mhi_dev);
>>>      >       dev_set_drvdata(&mhi_dev->dev, NULL);
>>>      >   }
>>>      >
>>>      >
>>>
>>>     I admit, I didn't pay much attention to the auto-start being 
>>> removed,
>>>     but this seems odd to me.
>>>
>>>     As a client, the MHI device is being removed, likely because of some
>>>     factor outside of my control, but I still need to clean it up? This
>>>     really feels like something MHI should be handling.
>>>
>>>
>>> I think this is just about balancing operations, what is done in 
>>> probe should be undone in remove, so here channels are started in 
>>> probe and stopped/reset in remove.
>>
>> I understand that perspective, but that doesn't quite match what is
>> going on here.  Regardless of if the channel was started (prepared) in
>> probe, it now needs to be stopped in remove.  That not balanced in all
>> cases
>>
>> Lets assume, in response to probe(), my client driver goes and creates
>> some other object, maybe a socket.  In response to that socket being
>> opened/activated by the client of my driver, I go and start the mhi
>> channel.  Now, normally, when the socket is closed/deactivated, I stop
>> the MHI channel.  In this case, stopping the MHI channel in remove()
>> is unbalanced with respect to probe(), but is now a requirement.
>>
>> Now you may argue, I should close the object in response to remove,
>> which will then trigger the stop on the channel.  That doesn't apply
>> to everything.  For example, you cannot close an open file in the
>> kernel. You need to wait for userspace to close it.  By the time that
>> happens, the mhi_dev is long gone I expect.
>>
>> So if, somehow, the client driver is the one causing the remove to
>> occur, then yes it should probably be the one doing the stop, but
>> that's a narrow set of conditions, and I think having that requirement
>> for all scenarios is limiting.
> It should be the client's responsibility to perform a clean-up though.
> 
> We cannot assume that the remove() call was due to factors outside of the
> client's control at all times. You may not know if the remove() was due to
> device actually crashing or just an unbind/module unload. So, it would be
> better if you call it as the device should ideally not be left with a stale
> channel context. >
> We had an issue where a client was issuing a driver unbind without 
> unpreparing
> the MHI channels and without Loic's patch [1], we would not issue a channel
> RESET to the device resulting in incoming data to the host on those 
> channels
> after host clean-up and an unmapped memory access and kernel panic.

So the client drivers have to do the right thing, otherwise the kernel 
could crash?  Sounds like you are choosing to not do defensive coding in 
MHI and making your problems the client's problems.

Before releasing the resources, why haven't you issued a MHI_RESET of 
the state machine, and ensured the device has ack'd the reset?

> If MHI dev will be gone that NULL/status check must be present in 
> something that
> userspace could potentially use.
> 
> [1] 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/drivers/bus/mhi?h=next-20201119&id=a7f422f2f89e7d48aa66e6488444a4c7f01269d5 
> 
> 
> Thanks,
> Bhaumik
> ---
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project


-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
