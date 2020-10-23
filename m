Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BFA297367
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751437AbgJWQTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:19:50 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:37322 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751432AbgJWQTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 12:19:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603469988; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Np2z36pVrJFtIYoaOo04mONohKb4HMfgGDx6cRuOgyA=; b=fmXx1pugVhxbMyYFQcSO64ti+K7uyuCxweojo6IQ14HEE0DSvxHJqHa+YF/GXJmhr9XA3kZR
 /SFk574mapHBaaZX0ZpA70+PoUK2wTAkntCKwT26uh1HL+oz+RXZ0pVveUlqqqsq7mtJ/i8+
 LMJ8UagilJFX2k4UkGplDiljArU=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f9302a23d9da80170beb185 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 23 Oct 2020 16:19:46
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BB614C433C9; Fri, 23 Oct 2020 16:19:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 452B1C433C9;
        Fri, 23 Oct 2020 16:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 452B1C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [PATCH v6 1/2] bus: mhi: Add mhi_queue_is_full function
To:     Jakub Kicinski <kuba@kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        netdev@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        eric.dumazet@gmail.com, Bhaumik Bhatt <bbhatt@codeaurora.org>
References: <1602840007-27140-1-git-send-email-loic.poulain@linaro.org>
 <8c384f6a-df21-1a39-f586-6077da373c04@codeaurora.org>
 <20201023084425.22bbf069@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <a03293b6-71bb-50f7-870c-2db463e6499e@codeaurora.org>
Date:   Fri, 23 Oct 2020 10:19:44 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201023084425.22bbf069@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/2020 9:44 AM, Jakub Kicinski wrote:
> On Thu, 22 Oct 2020 20:06:37 -0700 Hemant Kumar wrote:
>>> @@ -1173,6 +1173,17 @@ int mhi_queue_buf(struct mhi_device *mhi_dev, enum dma_data_direction dir,
>>>    }
>>>    EXPORT_SYMBOL_GPL(mhi_queue_buf);
>>>    
>>> +bool mhi_queue_is_full(struct mhi_device *mhi_dev, enum dma_data_direction dir)
>>> +{
>>> +	struct mhi_controller *mhi_cntrl = mhi_dev->mhi_cntrl;
>>> +	struct mhi_chan *mhi_chan = (dir == DMA_TO_DEVICE) ?
>>> +					mhi_dev->ul_chan : mhi_dev->dl_chan;
>>> +	struct mhi_ring *tre_ring = &mhi_chan->tre_ring;
>>> +
>>> +	return mhi_is_ring_full(mhi_cntrl, tre_ring);
>>> +}
>>> +EXPORT_SYMBOL_GPL(mhi_queue_is_full);
>>>    
>> i was wondering if you can make use of mhi_get_free_desc() API (pushed
>> as part of MHI UCI - User Control Interface driver) here?
> 
> Let me ask you one more time. Where is this MHI UCI code you're talking
> about?

https://lkml.org/lkml/2020/10/22/186

-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
