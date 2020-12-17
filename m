Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BA62DD2FB
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 15:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgLQOZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 09:25:01 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13728 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgLQOY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 09:24:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdb6a120001>; Thu, 17 Dec 2020 06:24:18 -0800
Received: from [172.27.13.82] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Dec
 2020 14:24:05 +0000
Subject: Re: [PATCH net-next v2 2/4] sch_htb: Hierarchical QoS hardware
 offload
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
References: <20201211152649.12123-1-maximmi@mellanox.com>
 <20201211152649.12123-3-maximmi@mellanox.com>
 <CAM_iQpUS_71R7wujqhUnF41dtVtNj=5kXcdAHea1euhESbeJrg@mail.gmail.com>
 <7f4b1039-b1be-b8a4-2659-a2b848120f67@nvidia.com>
 <CAM_iQpVrQAT2frpiVYj4eevSO4jFPY8v2moJdorCe3apF7p6mA@mail.gmail.com>
 <bee0d31e-bd3e-b96a-dd98-7b7bf5b087dc@nvidia.com>
 <CAM_iQpW+vqXn6WV6DxBaC5EC0ciSBWtzvXCC57PcDrO2=mFEkg@mail.gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <0bdb1540-5712-0176-c187-e7ff80aa704d@nvidia.com>
Date:   Thu, 17 Dec 2020 16:24:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpW+vqXn6WV6DxBaC5EC0ciSBWtzvXCC57PcDrO2=mFEkg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608215058; bh=OhvYyrJFk6JGp1bqizCLhfb9qHdSQ45pxG6b5viZ2ek=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=P+j3zbHMMj0Ud1CtuvLXnyI8RHdyzRI+n6qFgJvL/5OmO9U8UwXcfRrhxz3IDCTzn
         3zDJ8OUbHj42DJJLEqbDzvD2OzBJMO71DcbfIkYEM/JHEzypWhLBtAnRs3tv1+gKxb
         FuiQtYTxCj8wL62iIFi9YAM9TwZz2lSIvNgy4B15maKdK8nxYlOqEcZTcqJVcFF3iF
         bYzgl4RW/67aaDTMgQGj5QDNSCy+mNLatpvyuflR+zepUOiIz13SDoh2W65Mtef19k
         PKc3llL98IjZHmzzT5RTLLA1471K8pOG5s+11z5GcTBWFaoiTq7ihbUEc7ZHBwO3KX
         PTLtVQFKLZbqw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-16 21:01, Cong Wang wrote:
> On Mon, Dec 14, 2020 at 12:30 PM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>> On 2020-12-14 21:35, Cong Wang wrote:
>>> On Mon, Dec 14, 2020 at 7:13 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>>>
>>>> On 2020-12-11 21:16, Cong Wang wrote:
>>>>> On Fri, Dec 11, 2020 at 7:26 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>>>>>>
>>>>>> HTB doesn't scale well because of contention on a single lock, and it
>>>>>> also consumes CPU. This patch adds support for offloading HTB to
>>>>>> hardware that supports hierarchical rate limiting.
>>>>>>
>>>>>> This solution addresses two main problems of scaling HTB:
>>>>>>
>>>>>> 1. Contention by flow classification. Currently the filters are attached
>>>>>> to the HTB instance as follows:
>>>>>
>>>>> I do not think this is the reason, tcf_classify() has been called with RCU
>>>>> only on the ingress side for a rather long time. What contentions are you
>>>>> talking about here?
>>>>
>>>> When one attaches filters to HTB, tcf_classify is called from
>>>> htb_classify, which is called from htb_enqueue, which is called with the
>>>> root spinlock of the qdisc taken.
>>>
>>> So it has nothing to do with tcf_classify() itself... :-/
>>>
>>> [...]
>>>
>>>>> And doesn't TBF already work with mq? I mean you can attach it as
>>>>> a leaf to each mq so that the tree lock will not be shared either, but you'd
>>>>> lose the benefits of a global rate limit too.
>>>>
>>>> Yes, I'd lose not only the global rate limit, but also multi-level
>>>> hierarchical limits, which are all provided by this HTB offload - that's
>>>> why TBF is not really a replacement for this feature.
>>>
>>> Interesting, please explain how your HTB offload still has a global rate
>>> limit and borrowing across queues?
>>
>> Sure, I will explain that.
>>
>>> I simply can't see it, all I can see
>>> is you offload HTB into each queue in ->attach(),
>>
>> In the non-offload mode, the same HTB instance would be attached to all
>> queues. In the offload mode, HTB behaves like MQ: there is a root
>> instance of HTB, but each queue gets a separate simple qdisc (pfifo).
>> Only the root qdisc (HTB) gets offloaded, and when that happens, the NIC
>> creates an object for the QoS root.
> 
> Please add this to your changelog.

The similar information is already in the commit message (the paragraph 
under point 2.), but I can rephrase it and elaborate on this, focusing 
on the interaction between HTB, driver and hardware.

> And why is the offloaded root qdisc not visible to software? All you add to
> root HTB are pointers of direct qdisc's and a boolean, this is what I meant
> by "not reflected". I expect the hardware parameters/stats are exposed to
> software too, but I can't find any.

Hardware parameters are rate and ceil, there are no extra parameters 
that exist only in the offload mode. In the future, we may add the 
number of queues to reserve for a class - that will be configured and 
reflected in tc.

Regarding stats, unfortunately, the hardware doesn't expose any 
low-level stats like numbers of tokens, etc. Basic stats like packets 
and bytes are supported and exposed in tc, but they are calculated in 
software (by per-queue qdiscs) - similarly to how we calculate 
per-TX-queue packets and bytes in software.

> 
>>
>> Then all configuration changes are sent to the driver, and it issues the
>> corresponding firmware commands to replicate the whole hierarchy in the
>> NIC. Leaf classes correspond to queue groups (in this implementation
>> queue groups contain only one queue, but it can be extended), and inner
>> classes correspond to entities called TSARs.
>>
>> The information about rate limits is stored inside TSARs and queue
>> groups. Queues know what groups they belong to, and groups and TSARs
>> know what TSAR is their parent. A queue is picked in ndo_select_queue by
>> looking at the classification result of clsact. So, when a packet is put
>> onto a queue, the NIC can track the whole hierarchy and do the HTB
>> algorithm.
> 
> Glad to know hardware still keeps HTB as a hierarchy.
> 
> Please also add this either to source code as comments or in your
> changelog, it is very important to understand what is done by hardware.

OK, as I said above in this letter, I can rephrase the commit message, 
focusing on details about interaction between HTB <-> driver <-> NIC and 
what happens in the NIC. It should look better if I put it in a 
dedicated paragraph, instead of mentioning it under the contention problem.

Thanks,
Max

> Thanks.
> 

