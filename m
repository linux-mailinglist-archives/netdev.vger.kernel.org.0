Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA9941CFD9
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347525AbhI2XXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346731AbhI2XXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 19:23:09 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E3EC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 16:21:28 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id n18so4281048pgm.12
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 16:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5HZvqMny1HHoTj78F3G70yZeBT/9G2GP61aS3k52V4I=;
        b=ozSG5qbyb/C0JeZYrXFd2UQYCX0yoWGMjqt0nn+fqs5X6rvOz17HOIVGzm+KfooEOv
         IO/7s7me7BZNuk3o3QwlMijLYpRwnbbeuI2gYnkY4G4JemCM15sgoVofb7ksKlB2oYdt
         Y+UHyou2GnzSI/drPPvDMsMD+37nWcoN6B3jGao8VeF1J4DfaTL0bjpmB9EnHkDr35fQ
         nQHWMeugpz2T48IUZRB+keDBZFJ6LqJYHHolnqfkPDGdLck9SRmD+7hTrmrwOglA2uLV
         LApOJTJMkPc0QWjcbfE29q/+FysRLF7rHdVzuAvt3VMR6Ja4QOHOvky0/UR5r0ZhHTnT
         TSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5HZvqMny1HHoTj78F3G70yZeBT/9G2GP61aS3k52V4I=;
        b=IGC7d3xqG4L2SRprgo5V+EKRj2XyQ07eUWi6ZedXHl2JPEvQE4edj5yynprZXOyPAH
         3D002DKCjNfAC3WgejMnvO9aLkoQOruKIGcW+yzgE2c5J9ORlpsWNqmi+yy2+fif2UL3
         MjYC9ueMKu+qowijMO0lcQbc+HyIg78iqbu/X8ygDJ8Y4oN+jSp+o1A0KmHF1KDtV+wT
         YV2i+hbKzQFq+DegE5Psf71WJ5mbqE/URuhEDa3waJ9WhfBwRUvqasbgfuVoDDouVbnz
         GuvWu3uO4WzuNivVtoZGUD5QI3rNN7BE4sjwrKC4YthyNB5ti6Fi3Jd3ddN3WxPIX9B6
         sBaw==
X-Gm-Message-State: AOAM531U+ZZF495dA/2pxgVYcb3FBxI2VaBcKCKEQvOql11NodfwdZul
        a2/25EHtzQYaWsW3O49dpQZGOim2Uns=
X-Google-Smtp-Source: ABdhPJwwj1VPvXQ6KWNX4bEuHMs8p3xGa7ltAcsjHi+fGxBeEVUg650cTGmZA5D7kdWVnj/U4wLE9w==
X-Received: by 2002:a63:7404:: with SMTP id p4mr2123991pgc.222.1632957687577;
        Wed, 29 Sep 2021 16:21:27 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k190sm679578pgc.11.2021.09.29.16.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 16:21:27 -0700 (PDT)
Subject: Re: 5.15-rc3+ crash in fq-codel?
To:     Ben Greear <greearb@candelatech.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
References: <dfa032f3-18f2-22a3-80bf-f0f570892478@candelatech.com>
 <b6e8155e-7fae-16b0-59f0-2a2e6f5142de@gmail.com>
 <00e495ba-391e-6ad8-94a2-930fbc826a37@candelatech.com>
 <296232ac-e7ed-6e3c-36b9-ed430a21f632@candelatech.com>
 <7e87883e-42f5-2341-ab67-9f1614fb8b86@candelatech.com>
 <7f1d67f1-3a2c-2e74-bb86-c02a56370526@gmail.com>
 <88bc8a03-da44-fc15-f032-fe5cb592958b@candelatech.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b537053d-498d-928b-8ca0-e9daf5909128@gmail.com>
Date:   Wed, 29 Sep 2021 16:21:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <88bc8a03-da44-fc15-f032-fe5cb592958b@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/21 12:07 PM, Ben Greear wrote:
> On 9/28/21 4:25 PM, Eric Dumazet wrote:
>>
>>
>> On 9/28/21 3:00 PM, Ben Greear wrote:
>>> On 9/27/21 5:16 PM, Ben Greear wrote:
>>>> On 9/27/21 5:04 PM, Ben Greear wrote:
>>>>> On 9/27/21 4:49 PM, Eric Dumazet wrote:
>>>>>>
>>>>>>
>>>>>> On 9/27/21 4:30 PM, Ben Greear wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> In a hacked upon kernel, I'm getting crashes in fq-codel when doing bi-directional
>>>>>>> pktgen traffic on top of mac-vlans.  Unfortunately for me, I've made big changes to
>>>>>>> pktgen so I cannot easily run this test on stock kernels, and there is some chance
>>>>>>> some of my hackings have caused this issue.
>>>>>>>
>>>>>>> But, in case others have seen similar, please let me know.  I shall go digging
>>>>>>> in the meantime...
>>>>>>>
>>>>>>> Looks to me like 'skb' is NULL in line 120 below.
>>>>>>
>>>>>>
>>>>>> pktgen must not be used in a mode where a single skb
>>>>>> is cloned and reused, if packet needs to be stored in a qdisc.
>>>>>>
>>>>>> qdisc of all sorts assume skb->next/prev can be used as
>>>>>> anchor in their list.
>>>>>>
>>>>>> If the same skb is queued multiple times, lists are corrupted.
>>>>>>
>>>>>> Please double check your clone_skb pktgen setup.
>>>>>>
>>>>>> I thought we had IFF_TX_SKB_SHARING for this, and that macvlan was properly clearing this bit.
>>>>>
>>>>> My pktgen config was not using any duplicated queueing in this case.
>>>>>
>>>>> I changed to pfifo fast and so far it is stable for ~10 minutes, where before it would crash
>>>>> within a minute.  I'll let it bake overnight....
>>>>
>>>> Still running stable.  I also notice we have been using fq-codel for a while and haven't noticed
>>>> this problem (next most recent kernel we might have run similar test on would be 5.13-ish).
>>>>
>>>> I'll duplicate this test on our older kernels tomorrow to see if it looks like a regression or
>>>> if we just haven't actually done this exact test in a while...
>>>
>>> We can reproduce this crash as far back as 5.4 using fq-codel, with our pktgen driving mac-vlans.
>>> We did not try any kernels older than 5.4.
>>> We cannot reproduce with pfifo on 5.15-rc3 on an overnight run.
>>> We cannot produce with user-space UDP traffic on any kernel/qdisc combination.
>>> Our pktgen is configured for multi-skb of 0 (no multiple submits of the same skb)
>>>
>>> While looking briefly at fq-codel, I didn't notice any locking in the code that crashed.
>>> Any chance that it makes assumptions that would be incorrect with pktgen running multiple
>>> threads (one thread per mac-vlan) on top of a single qdisc belonging to the underlying NIC?
>>>
>>
>>
>> qdisc are protected by a qdisc spinlock.
>>
>> fq-codel does not have to lock anything in its enqueue() and dequeue() methods.
>>
>> I guess your local changes to pktgen might be to blame.
>>
>> pfifo is much simpler than fq-codel, it uses less fields from skb.
> 
> I looked through my pktgen, and the skb creation and setup code looks pretty
> similar to upstream pktgen.
> 
> I also added this debugging code:
> 
> [greearb@ben-dt4 linux-5.15.dev.y]$ git diff
> diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
> index bb0cd6d3d2c2..56e22106e19d 100644
> --- a/net/sched/sch_fq_codel.c
> +++ b/net/sched/sch_fq_codel.c
> @@ -165,6 +165,11 @@ static unsigned int fq_codel_drop(struct Qdisc *sch, unsigned int max_packets,
>         len = 0;
>         i = 0;
>         do {
> +               if (!flow->head) {
> +                       pr_err("fq-codel-drop: idx: %d maxbacklog: %d  threshold: %d max_packets: %d len: %d i: %d\n",
> +                              idx, maxbacklog, threshold, max_packets, len, i);
> +                       BUG_ON(1);
> +               }
>                 skb = dequeue_head(flow);
>                 len += qdisc_pkt_len(skb);
>                 mem += get_codel_cb(skb)->mem_usage;
> 
> The printout I see when this hits is:
> 
> 
> fq-codel-drop: idx: 955 maxbacklog: 7756222  threshold: 3878111 max_packets: 64 len: 93868 i: 62
> kernel BUG at net/sched/sch_fq_codel.c:171!
> .....
> 
> So, I guess this means that the backlog byte counter is out of sync with the packet queue somehow?
> 
> Any suggestions for what kinds of issues in pktgen could cause this?

Modifications to skbs after they were queued to the qdisc.

qdisc_pkt_len(skb) uses skb->cb[] storage. Make sure to not use it.


