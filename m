Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9736A3433F2
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCURzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:55:22 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:64647 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhCURzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:55:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1616349305; x=1647885305;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=4HNoEkyknGviSeugId+Rs1Iff5i9zQ8AvBezxLDNACA=;
  b=J6lzZJ7PNjFo33m7RcnFDmvTtQdS3ozT/RlPajPMoS3LNYcKEBr0PtSW
   Dtd8kSCz7x1m8/9ILjO/I3srtVDuPSm68oowSUiEYqmh7TZ5bKieDIFxa
   ILNnPT0IJMIOpSYMFMT7T3X255KHTknB/ePfKW0ZikW73cLphHRTqi1fv
   M=;
X-IronPort-AV: E=Sophos;i="5.81,266,1610409600"; 
   d="scan'208";a="99371535"
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable ctrl-ring
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Mar 2021 17:54:57 +0000
Received: from EX13D12EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 8B10BA2000;
        Sun, 21 Mar 2021 17:54:55 +0000 (UTC)
Received: from 147dda3ee008.ant.amazon.com (10.43.165.62) by
 EX13D12EUA002.ant.amazon.com (10.43.165.103) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 21 Mar 2021 17:54:53 +0000
To:     Leon Romanovsky <leon@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <wei.liu@kernel.org>, <paul@xen.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <xen-devel@lists.xenproject.org>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch> <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch> <YE3foiFJ4sfiFex2@unreal>
 <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com> <YFI676dumSDJvTlV@unreal>
 <f3b76d9b-7c82-d3bd-7858-9e831198e33c@amazon.com> <YFeAzfJsHAqPvPuY@unreal>
From:   "Hsu, Chiahao" <andyhsu@amazon.com>
Message-ID: <12f643b5-7a35-d960-9b1f-22853aea4b4c@amazon.com>
Date:   Sun, 21 Mar 2021 18:54:52 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YFeAzfJsHAqPvPuY@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.165.62]
X-ClientProxiedBy: EX13D08EUB002.ant.amazon.com (10.43.166.232) To
 EX13D12EUA002.ant.amazon.com (10.43.165.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Leon Romanovsky 於 2021/3/21 18:22 寫道:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> On Sun, Mar 21, 2021 at 05:31:08PM +0100, Hsu, Chiahao wrote:
>>
>> Leon Romanovsky 於 2021/3/17 18:22 寫道:
>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>>
>>>
>>>
>>> On Tue, Mar 16, 2021 at 04:22:21PM +0100, Hsu, Chiahao wrote:
>>>> Leon Romanovsky 於 2021/3/14 11:04 寫道:
>>>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>>>>
>>>>>
>>>>>
>>>>> On Fri, Mar 12, 2021 at 09:36:59PM +0100, Andrew Lunn wrote:
>>>>>> On Fri, Mar 12, 2021 at 04:18:02PM +0100, Hsu, Chiahao wrote:
>>>>>>> Andrew Lunn 於 2021/3/12 15:52 寫道:
>>>>>>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On Thu, Mar 11, 2021 at 10:59:44PM +0000, ChiaHao Hsu wrote:
>>>>>>>>> In order to support live migration of guests between kernels
>>>>>>>>> that do and do not support 'feature-ctrl-ring', we add a
>>>>>>>>> module parameter that allows the feature to be disabled
>>>>>>>>> at run time, instead of using hardcode value.
>>>>>>>>> The default value is enable.
>>>>>>>> Hi ChiaHao
>>>>>>>>
>>>>>>>> There is a general dislike for module parameters. What other mechanisms
>>>>>>>> have you looked at? Would an ethtool private flag work?
>>>>>>>>
>>>>>>>>          Andrew
>>>>>>> Hi Andrew,
>>>>>>>
>>>>>>> I can survey other mechanisms, however before I start doing that,
>>>>>>>
>>>>>>> could you share more details about what the problem is with using module
>>>>>>> parameters? thanks.
>>>>>> It is not very user friendly. No two kernel modules use the same
>>>>>> module parameters. Often you see the same name, but different
>>>>>> meaning. There is poor documentation, you often need to read the
>>>>>> kernel sources it figure out what it does, etc.
>>>>> +1, It is also global parameter to whole system/devices that use this
>>>>> module, which is rarely what users want.
>>>>>
>>>>> Thanks
>>>> Hi,
>>>> I think I would say the current implementation(modparams) isappropriate
>>>> after reviewing it again.
>>>>
>>>> We are talking about 'feature leveling', a way to support live migrationof
>>>> guest
>>>> between kernels that do and do not support the features. So we want to
>>>> refrain
>>>> fromadding the features if guest would be migrated to the kernel which does
>>>> not support the feature. Everythingshould be done (in probe function) before
>>>> frontend connects, and this is why ethtool is not appropriate for this.
>>> It wouldn't be a surprise to you that feature discovery is not supposed
>>> to be done through module parameters. Instead of asking from user to
>>> randomly disable some feature, the system is expected to be backward
>>> compatible and robust enough to query the list of supported/needed
>>> features.
>>>
>>> Thanks
>>>
>>>> Thanks
>>>>
>>>>
>> Typically there should be one VM running netback on each host,
>> and having control over what interfaces or features it exposes is also
>> important for stability.
>> How about we create a 'feature flags' modparam, each bits is specified for
>> different new features?
> At the end, it will be more granular module parameter that user still
> will need to guess.
I believe users always need to know any parameter or any tool's flag 
before they use it.
For example, before user try to set/clear this ctrl_ring_enabled, they 
should already have basic knowledge about this feature,
or else they shouldn't use it (the default value is same as before), and 
that's also why we use the 'ctrl_ring_enabled' as parameter name.

Thanks
> Thanks
>

