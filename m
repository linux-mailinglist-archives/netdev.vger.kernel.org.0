Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA3A316FFB
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 20:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhBJTTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 14:19:48 -0500
Received: from so15.mailgun.net ([198.61.254.15]:49442 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233391AbhBJTTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 14:19:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612984752; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=u/4NyRB5sHrXSITg9F7fX/oYuypKI2hCs0G7fYJFvf8=; b=FtRlYxOMKYMHSogVRei/Ss0pAkLMbKJX7/9EYHv7SwKWdFFbtckIWNUlYX5oPUDz/7i+g6x6
 y1WBRGRTrsQ9MBQqf9YqnZopMunWUawzYzOOXsOyflN48op5/ODJJurDk3F6v4pu4s4+AiRV
 P9lm7fcW+je4vP+vd4Vq/GHW4CU=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 60243191e4842e912867e75d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Feb 2021 19:18:41
 GMT
Sender: jhugo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 620BDC43464; Wed, 10 Feb 2021 19:18:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from [10.226.59.216] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jhugo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A47D5C433ED;
        Wed, 10 Feb 2021 19:18:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A47D5C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=jhugo@codeaurora.org
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
To:     Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Aleksander Morgado <aleksander@aleksander.es>,
        Loic Poulain <loic.poulain@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
References: <YBfi573Bdfxy0GBt@kroah.com> <20210201121322.GC108653@thinkpad>
 <20210202042208.GB840@work>
 <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
 <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
 <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
 <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210210062531.GA13668@work>
 <20210210104128.2166e506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jeffrey Hugo <jhugo@codeaurora.org>
Message-ID: <4067f57b-f229-24c7-5a92-030fb67bd785@codeaurora.org>
Date:   Wed, 10 Feb 2021 12:18:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210210104128.2166e506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/2021 11:41 AM, Jakub Kicinski wrote:
> On Wed, 10 Feb 2021 11:55:31 +0530 Manivannan Sadhasivam wrote:
>> On Tue, Feb 09, 2021 at 08:17:44AM -0800, Jakub Kicinski wrote:
>>> On Tue, 9 Feb 2021 10:20:30 +0100 Aleksander Morgado wrote:
>>>> This may be a stupid suggestion, but would the integration look less a
>>>> backdoor if it would have been named "mhi_wwan" and it exposed already
>>>> all the AT+DIAG+QMI+MBIM+NMEA possible channels as chardevs, not just
>>>> QMI?
>>>
>>> What's DIAG? Who's going to remember that this is a backdoor driver
>>> a year from now when Qualcomm sends a one liner patches which just
>>> adds a single ID to open another channel?
>>
>> I really appreciate your feedback on this driver eventhough I'm not
>> inclined with you calling this driver a "backdoor interface". But can
>> you please propose a solution on how to make this driver a good one as
>> per your thoughts?
>>
>> I really don't know what bothers you even if the userspace tools making
>> use of these chardevs are available openly (you can do the audit and see
>> if anything wrong we are doing).
> 
> What bothers me is maintaining shim drivers which just shuttle opaque
> messages between user space and firmware. One of which definitely is,
> and the other may well be, proprietary. This is an open source project,
> users are supposed to be able to meaningfully change the behavior of
> the system.

Interesting.  So, based on that, the TCP/IP stack is going to be ripped 
out of Linux?  I can write a proprietary userspace application which 
uses the TCP/IP stack to shuttle opaque messages through the kernel to a 
remote system, which could be running Windows (a proprietary OS with 
typically proprietary applications).  I've infact done that in another 
life.  Proprietary talking to proprietary with the Linux kernel in the 
middle.  I suspect you'll have an aggressively different opinion, but at 
this simplified level, it's really no different from the proposed 
mhi_uci driver here, or any of the numerous other examples provided.

The Linux kernel does not get to say everything must be open.  There is 
an explicit license stating that - 
LICENSES/exceptions/Linux-syscall-note  Yes, it's ideal if things are 
open, but it seems contradictory to espouse wanting choice, but then 
denying certain choices.
Frankly, folks have pointed out open source applications that wish to 
use this, so no, it's not all closed.

Put another way, you keep going in circles (I know you've argued the 
same for others in the discussion) - why is this specifically different 
from the other "shim drivers" which "shuttle proprietary messages" which 
already exist and are maintained in Linus' tree today?  All I'm seeing 
is "I don't like it" which is not a technical reason, and "proprietary 
is bad" which frankly, I think the horses were let out of the barn back 
in 1991 when Linus first created Linux.

> 
> What bothers me is that we have 3 WWAN vendors all doing their own
> thing and no common Linux API for WWAN. It may have been fine 10 years
> ago, but WWAN is increasingly complex and important.
> 
>> And exposing the raw access to the
>> hardware is not a new thing in kernel. There are several existing
>> subsystems/drivers does this as pointed out by Bjorn. Moreover we don't
>> have in-kernel APIs for the functionalities exposed by this driver and
>> creating one is not feasible as explained by many.
>>
>> So please let us know the path forward on this series. We are open to
>> any suggestions but you haven't provided one till now.
> 
> Well. You sure know how to aggravate people. I said clearly that you
> can move forward on purpose build drivers (e.g. for WWAN). There is no
> way forward on this common shim driver as far as I'm concerned.
> 


-- 
Jeffrey Hugo
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
