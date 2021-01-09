Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6E02EFDC2
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 05:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAIEiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 23:38:15 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:30702 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbhAIEiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 23:38:14 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610167068; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=fVMhHfukr4MbW/iGJeYB9CwktC1bSUBCY7Ede2q6IGQ=; b=rA1J7H354o2rNnzk3VCLXEnZYQbT6qUsXHtyInnQdHOEOmzfEs1gqTwDbmWDYfVE6lk8kYF6
 /NSk29q7Ul484VX+6un2WNfIA5hc4k3Em5fSk3ERbfDRAA+m+cGUA6kg1hC1CoZp/snaqjPa
 okd8HmslZ1Eldceeo+0siDdKLe8=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5ff933038fb3cda82fcbab5c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 09 Jan 2021 04:37:23
 GMT
Sender: hemantk=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3AB1DC433C6; Sat,  9 Jan 2021 04:37:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from [10.46.162.249] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: hemantk)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1DCF8C433CA;
        Sat,  9 Jan 2021 04:37:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1DCF8C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=hemantk@codeaurora.org
Subject: Re: [PATCH] bus: mhi: Add inbound buffers allocation flag
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <1609940623-8864-1-git-send-email-loic.poulain@linaro.org>
 <20210108134425.GA32678@work>
 <CAMZdPi9tUUzf0hLwLUBqB=+eGQS-eNP8NtnMF-iS1ZqUfautuw@mail.gmail.com>
 <20210108153032.GC32678@work>
From:   Hemant Kumar <hemantk@codeaurora.org>
Message-ID: <6e812726-d7e2-412a-940c-53cdd361c5aa@codeaurora.org>
Date:   Fri, 8 Jan 2021 20:37:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210108153032.GC32678@work>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 7:30 AM, Manivannan Sadhasivam wrote:
> On Fri, Jan 08, 2021 at 03:01:59PM +0100, Loic Poulain wrote:
>> Hi Mani,
>>
>> On Fri, 8 Jan 2021 at 14:44, Manivannan Sadhasivam <
>> manivannan.sadhasivam@linaro.org> wrote:
>>
>>> On Wed, Jan 06, 2021 at 02:43:43PM +0100, Loic Poulain wrote:
>>>> Currently, the MHI controller driver defines which channels should
>>>> have their inbound buffers allocated and queued. But ideally, this is
>>>> something that should be decided by the MHI device driver instead,
>>>
>>> We call them, "MHI client drivers"
>>>
>>
>> I'll fix that.
>>
>>
>>>> which actually deals with that buffers.
>>>>
>>>> Add a flag parameter to mhi_prepare_for_transfer allowing to specify
>>>> if buffers have to be allocated and queued by the MHI stack.
>>>>
>>>> Keep auto_queue flag for now, but should be removed at some point.
>>>>
>>>> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
>>>> ---
>>>>   drivers/bus/mhi/core/internal.h |  2 +-
>>>>   drivers/bus/mhi/core/main.c     | 11 ++++++++---
>>>>   drivers/net/mhi_net.c           |  2 +-
>>>>   include/linux/mhi.h             | 12 +++++++++++-
>>>>   net/qrtr/mhi.c                  |  2 +-
>>>>   5 files changed, 22 insertions(+), 7 deletions(-)
>>>>
>>>
>>> [...]
>>>
>>>> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
>>>> index fa41d8c..b7f7f2e 100644
>>>> --- a/drivers/net/mhi_net.c
>>>> +++ b/drivers/net/mhi_net.c
>>>> @@ -265,7 +265,7 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>>>>        u64_stats_init(&mhi_netdev->stats.tx_syncp);
>>>>
>>>>        /* Start MHI channels */
>>>> -     err = mhi_prepare_for_transfer(mhi_dev);
>>>> +     err = mhi_prepare_for_transfer(mhi_dev, 0);
>>>
>>> Eventhough I'd like Hemant to comment on this patch, AFAIU this looks to
>>> me a controller dependent behaviour. The controller should have the
>>> information whether a particular channel can auto queue or not then the
>>> client driver can be agnostic.

I am fine with his change, and agree that MHI client driver should be 
able to make the decision.
Having said that, can we merge this on top of UCI :).
[..]

Thanks,
Hemant
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
