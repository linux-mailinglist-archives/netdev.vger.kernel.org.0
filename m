Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9496435F8
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 21:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiLEUp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 15:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiLEUpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 15:45:55 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1E9EE3B
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 12:45:54 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id v206so16051035ybv.7
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 12:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l4xAPtVmwk3XYoPBoLRQxV0H2Bk5gdlYy9hmz9+0VII=;
        b=jBPSYkr5PKpjefjF0xhRaZbdF1kOo1cGo1K3NdLm/9zrWDQ5R0NUh449EfLQsgNIcu
         BIidjvLeNX3ekDyuVQb/o7oJRlj6BR9F2ak2JcNObzchUaW2y6Wwm/sMyqZdk+sqo/NJ
         3Bek8/RQqz8n9bhVwOo6rK3kaiSKpwF1x9+stoyBCQSQNXjV00R2T+UcE9NDNZK6HtLF
         j3C1V7v2ziOglROsQn62M2GCseIoSYab8k6bzbBN8cXHu/eajpZeh77mJNpdew7NKV/n
         nHB4a+GI2QBa0P8RySi2jck5lERIJg/+dCwDN9ynQyGiuX9IQHEvllJ9xGls/0mHtIi5
         4Fhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l4xAPtVmwk3XYoPBoLRQxV0H2Bk5gdlYy9hmz9+0VII=;
        b=HqS9EzZGmlJ2+N1MeHtMy6fEhi2gxyXjnaWXL3pMjWHw0/jSf3hG254O86cASmz9cz
         QlVfOvV3v73FBObE4E+V/SMRP+Sh15y8msPGzIDXfAX5DA0wOZCC93AmnHYXv/Os/KUN
         s36MNkZhxYR9Ire6noXjlv4PJlHBavOA02cXintd9djNEr2zSKkqaOkAZNu6Obx6ydT+
         qwYfRluGlFvKQGcySDkrcN1yDkvvjgGZ0iyiOKcZQdqEitfrVhOxMympiQmfDBhEicZo
         MhOvSwAOMBSbSKll3DzujZ0BiZJhfg3zlN53v//XMBVTjQsLMB/XxukMGlmJUEx1/s4+
         +P5g==
X-Gm-Message-State: ANoB5plZK6nHf6kpdCdFz/LpCMP8Caw/iOMWV4hIXauIT/ceLT3M5oSZ
        1Kcnt8bA/+f5mb0fNA7EzjtOs6IlGzkDW1Yxkas7JjEyMRRjXg==
X-Google-Smtp-Source: AA0mqf4OSafkRUYR2VG1wMZvtuaVp3rMCtLQHpL1OB9md1CL4M4uw89t/dN+lJlMfkNmrvmY7j7CwuKhUP+UBPrYngo=
X-Received: by 2002:a05:6902:1004:b0:6fe:d784:282a with SMTP id
 w4-20020a056902100400b006fed784282amr10715581ybt.598.1670273153063; Mon, 05
 Dec 2022 12:45:53 -0800 (PST)
MIME-Version: 1.0
References: <20221205153557.28549-1-justin.iurman@uliege.be>
 <CANn89iLjGnyh0GgW_5kkMQJBCi-KfgwyvZwT1ou2FMY4ZDcMXw@mail.gmail.com>
 <CANn89iK3hMpJQ1w4peg2g35W+Oi3t499C5rUv7rcwzYtxDGBuw@mail.gmail.com>
 <a8dcb88c-16be-058b-b890-5d479d22c8a8@uliege.be> <CANn89iKgeVFRAstW3QRwOdn8SV_EbHqcKYqmoWT6m5nGQwPWUg@mail.gmail.com>
 <d579c817-50c7-5bd5-4b28-f044daabf7f6@uliege.be>
In-Reply-To: <d579c817-50c7-5bd5-4b28-f044daabf7f6@uliege.be>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 5 Dec 2022 21:45:41 +0100
Message-ID: <CANn89iKa2wU_MLquaZbvnO1jKeaTkui2axR8oVrB2LRKDNC7GA@mail.gmail.com>
Subject: Re: [RFC net] Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue
 depth data field")
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, pabeni@redhat.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 5, 2022 at 9:44 PM Justin Iurman <justin.iurman@uliege.be> wrote:
>
> On 12/5/22 19:34, Eric Dumazet wrote:
> > On Mon, Dec 5, 2022 at 7:24 PM Justin Iurman <justin.iurman@uliege.be> wrote:
> >>
> >> On 12/5/22 17:50, Eric Dumazet wrote:
> >>> On Mon, Dec 5, 2022 at 5:30 PM Eric Dumazet <edumazet@google.com> wrote:
> >>>>
> >>>> Patch title seems
> >>>>
> >>>> On Mon, Dec 5, 2022 at 4:36 PM Justin Iurman <justin.iurman@uliege.be> wrote:
> >>>>>
> >>>>> This patch fixes a NULL qdisc pointer when retrieving the TX queue depth
> >>>>> for IOAM.
> >>>>>
> >>>>> IMPORTANT: I suspect this fix is local only and the bug goes deeper (see
> >>>>> reasoning below).
> >>>>>
> >>>>> Kernel panic:
> >>>>> [...]
> >>>>> RIP: 0010:ioam6_fill_trace_data+0x54f/0x5b0
> >>>>> [...]
> >>>>>
> >>>>> ...which basically points to the call to qdisc_qstats_qlen_backlog
> >>>>> inside net/ipv6/ioam6.c.
> >>>>>
> >>>>>   From there, I directly thought of a NULL pointer (queue->qdisc). To make
> >>>>> sure, I added some printk's to know exactly *why* and *when* it happens.
> >>>>> Here is the (summarized by queue) output:
> >>>>>
> >>>>> skb for TX queue 1, qdisc is ffff8b375eee9800, qdisc_sleeping is ffff8b375eee9800
> >>>>> skb for TX queue 2, qdisc is ffff8b375eeefc00, qdisc_sleeping is ffff8b375eeefc00
> >>>>> skb for TX queue 3, qdisc is ffff8b375eeef800, qdisc_sleeping is ffff8b375eeef800
> >>>>> skb for TX queue 4, qdisc is ffff8b375eeec800, qdisc_sleeping is ffff8b375eeec800
> >>>>> skb for TX queue 5, qdisc is ffff8b375eeea400, qdisc_sleeping is ffff8b375eeea400
> >>>>> skb for TX queue 6, qdisc is ffff8b375eeee000, qdisc_sleeping is ffff8b375eeee000
> >>>>> skb for TX queue 7, qdisc is ffff8b375eee8800, qdisc_sleeping is ffff8b375eee8800
> >>>>> skb for TX queue 8, qdisc is ffff8b375eeedc00, qdisc_sleeping is ffff8b375eeedc00
> >>>>> skb for TX queue 9, qdisc is ffff8b375eee9400, qdisc_sleeping is ffff8b375eee9400
> >>>>> skb for TX queue 10, qdisc is ffff8b375eee8000, qdisc_sleeping is ffff8b375eee8000
> >>>>> skb for TX queue 11, qdisc is ffff8b375eeed400, qdisc_sleeping is ffff8b375eeed400
> >>>>> skb for TX queue 12, qdisc is ffff8b375eeea800, qdisc_sleeping is ffff8b375eeea800
> >>>>> skb for TX queue 13, qdisc is ffff8b375eee8c00, qdisc_sleeping is ffff8b375eee8c00
> >>>>> skb for TX queue 14, qdisc is ffff8b375eeea000, qdisc_sleeping is ffff8b375eeea000
> >>>>> skb for TX queue 15, qdisc is ffff8b375eeeb800, qdisc_sleeping is ffff8b375eeeb800
> >>>>> skb for TX queue 16, qdisc is NULL, qdisc_sleeping is NULL
> >>>>>
> >>>>> What the hell? So, not sure why queue #16 would *never* have a qdisc
> >>>>> attached. Is it something expected I'm not aware of? As an FYI, here is
> >>>>> the output of "tc qdisc list dev xxx":
> >>>>>
> >>>>> qdisc mq 0: root
> >>>>> qdisc fq_codel 0: parent :10 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :f limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :e limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :d limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :c limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :b limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :a limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :9 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :8 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :7 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :6 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :5 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>> qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> >>>>>
> >>>>> By the way, the NIC is an Intel XL710 40GbE QSFP+ (i40e driver, firmware
> >>>>> version 8.50 0x8000b6c7 1.3082.0) and it was tested on latest "net"
> >>>>> version (6.1.0-rc7+). Is this a bug in the i40e driver?
> >>>>>
> >>>>
> >>>>> Cc: stable@vger.kernel.org
> >>>>
> >>>> Patch title is mangled. The Fixes: tag should appear here, not in the title.
> >>>>
> >>>>
> >>>> Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue depth data field")
> >>>>
> >>>>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> >>>>> ---
> >>>>>    net/ipv6/ioam6.c | 11 +++++++----
> >>>>>    1 file changed, 7 insertions(+), 4 deletions(-)
> >>>>>
> >>>>> diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
> >>>>> index 571f0e4d9cf3..2472a8a043c4 100644
> >>>>> --- a/net/ipv6/ioam6.c
> >>>>> +++ b/net/ipv6/ioam6.c
> >>>>> @@ -727,10 +727,13 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
> >>>>>                           *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> >>>>>                   } else {
> >>>>>                           queue = skb_get_tx_queue(skb_dst(skb)->dev, skb);
> >>>>
> >>>> Are you sure skb_dst(skb)->dev is correct at this stage, what about
> >>>> stacked devices ?
> >>>>
> >>>>> -                       qdisc = rcu_dereference(queue->qdisc);
> >>>>> -                       qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
> >>>>> -
> >>>>> -                       *(__be32 *)data = cpu_to_be32(backlog);
> >>>>> +                       if (!queue->qdisc) {
> >>>>
> >>>> This is racy.
> >>>>
> >>>>> +                               *(__be32 *)data = cpu_to_be32(IOAM6_U32_UNAVAILABLE);
> >>>>> +                       } else {
> >>>>> +                               qdisc = rcu_dereference(queue->qdisc);
> >>>>> +                               qdisc_qstats_qlen_backlog(qdisc, &qlen, &backlog);
> >>>>> +                               *(__be32 *)data = cpu_to_be32(backlog);
> >>>>> +                       }
> >>>>>                   }
> >>>>>                   data += sizeof(__be32);
> >>>>>           }
> >>>>> --
> >>>>> 2.25.1
> >>>>>
> >>>>
> >>>> Quite frankly I suggest to revert b63c5478e9cb completely.
> >>>>
> >>>> The notion of Queue depth can not be properly gathered in Linux with a
> >>>> multi queue model,
> >>>> so why trying to get a wrong value ?
> >>>
> >>> Additional reason for a revert is that qdisc_qstats_qlen_backlog() is
> >>> reserved for net/sched
> >>
> >> If by "reserved" you mean "only used by at the moment", then yes (with
> >> the only exception being IOAM). But some other functions are defined as
> >> well, and some are used elsewhere than the "net/sched" context. So I
> >> don't think it's really an issue to use this function "from somewhere else".
> >>
> >>> code, I think it needs the qdisc lock to be held.
> >>
> >> Good point. But is it really needed when called with rcu_read_lock?
> >
> > It is needed.
>
> So I guess I could just submit a patch to wrap that part with:
>
> spin_lock(qdisc_lock(qdisc));
> [...]
> spin_unlock(qdisc_lock(qdisc));
>
> Anyway, there'd still be that queue-without-qdisc bug out there that I'd
> like to discuss but which seems to be avoided in the conversation somehow.
>
> > Please revert this patch.
> >
> > Many people use FQ qdisc, where packets are waiting for their Earliest
> > Departure Time to be released.
>
> The IOAM queue depth is a very important value and is already used. Just
> reverting the patch is not really an option. Besides, if IOAM is not
> used, then what you described above would not be a problem (probably
> most of the time as IOAM is enabled on limited domains). Not to mention
> that you probably don't need the queue depth in every packet.
>
> > Also, the draft says:
> >
> > 5.4.2.7.  queue depth
> >
> >     The "queue depth" field is a 4-octet unsigned integer field.  This
> >     field indicates the current length of the egress interface queue of
> >     the interface from where the packet is forwarded out.  The queue
> >     depth is expressed as the current amount of memory buffers used by
> >     the queue (a packet could consume one or more memory buffers,
> >     depending on its size).
> >
> >      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
> >     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >     |                       queue depth                             |
> >     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> >
> >
> > It is relatively clear that the egress interface is the aggregate
> > egress interface,
> > not a subset of the interface.
>
> Correct, even though the definition of an interface in RFC 9197 is quite
> abstract (see the end of section 4.4.2.2: "[...] could represent a
> physical interface, a virtual or logical interface, or even a queue").
>
> > If you have 32 TX queues on a NIC, all of them being backlogged (line rate),
> > sensing the queue length of one of the queues would give a 97% error
> > on the measure.
>
> Why would it? Not sure I get your idea based on that example.
>
> > To properly implement that 'Queue depth' metric, you would need to use
> > the backlog of the MQ qdisc.
> > That would be very expensive.
>
> Could be a solution, thanks for the suggestion. But if it's too
> expensive, I'd rather have the current solution (with locks) than
> nothing at all. At least it has provided an acceptable solution so far.

I will let other maintainers decide.

I gave my feedback, I won't change it.
