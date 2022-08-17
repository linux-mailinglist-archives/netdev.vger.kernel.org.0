Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358C0597534
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbiHQRhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiHQRhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:37:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE1BA1A7C
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:37:23 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id z187so12617554pfb.12
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=oHpVPbvxrCLs+hDQJtokFiFQV5w1hhX8KPbSuFBFMus=;
        b=rkXX2+3DhpH5kPN0GuvNmEMmFMRAP3sHQ5WYgRJMM5myi3cBvZ/q4NRNEF46zlU1Y8
         HYoLtM0bC6bV4iLJRtxfb3xwC8HfysVffnCg64kw188YZn0qe2H8IXB5kUfhGnNdQovY
         Unc/T855gSBad+woJ0nWXAwLgEr4SADSozNIaI1T/Qjxrm7glwGhxJalJc6808Pb1Fio
         zoNIgdU6LaIyKRXJX/GLgVSubRgeBqoW5ma75upr6jzK6HIXYBsM88owEvuHA/ox3nMH
         5SRBEVum7KWTxcNgcl4amFHXe2oy6hVJ2ShckQGxQuta/LIJyBBbL2tyv7JO+sWMDmuJ
         DWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=oHpVPbvxrCLs+hDQJtokFiFQV5w1hhX8KPbSuFBFMus=;
        b=7/a8bS9WNNIGq74byB8nInU/yxIJQNmx0nlpeKNip4wdSNDgp3Kt839uGmdm/2SWNN
         NU383HljLEHUW+2cczLzKbCbEu9Md0lxCWlT7rZaackuaVaS38rTCI9W09K/ASeIBera
         xyx1/Ru5FuUnIzODE48pKY61MyQYZl4ObYxvtb8/5ZBWaIOMx+5VL2dwLeKgGJogp+mY
         4rF5FTLXrjpSaZAu8raqToK8+cwgvxUH6mzMhRQnU/QD7Ugfr10Cfw//GP1TNh+4DOrq
         vXTlK/eBtLQ4gRF503iWuCg+YmFHdXXB7e+CdrvjBt7A35DpgHeROuVrcUqbyqsHU8Ym
         ZUEg==
X-Gm-Message-State: ACgBeo2KJPHLnF3zXvEnwFL89JLKsQ5lqFQq/YtdvsxR3jyaSB8Es+MG
        9pI3FEQs+reQvkn7Wc7lJMwXOY1RPP9rrWSiD5HXNQ==
X-Google-Smtp-Source: AA6agR7RM8hrx5k1uS+mUtIXdZYFeE1DilOpajIypSCuyaPr/6V8tDnU7J/6WG+v5atkr8lrNrO/QsL57Rc0ItJv19c=
X-Received: by 2002:a63:5f8e:0:b0:429:c286:4ef7 with SMTP id
 t136-20020a635f8e000000b00429c2864ef7mr4419598pgb.166.1660757842439; Wed, 17
 Aug 2022 10:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <CANOLnON11vzvVdyJfW+QJ36siWR4-s=HJ2aRKpRy7CP=aRPoSw@mail.gmail.com>
 <CANOLnOPeOi0gxYwd5+ybdv5w=RZEh5JakJPE9xgrSL1cecZHbw@mail.gmail.com> <Yv0h1PFxmK7rVWpy@cmpxchg.org>
In-Reply-To: <Yv0h1PFxmK7rVWpy@cmpxchg.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 17 Aug 2022 10:37:11 -0700
Message-ID: <CALvZod5_LVkOkF+gmefnctmx+bRjykSARm2JA9eqKJx85NYBGQ@mail.gmail.com>
Subject: Re: UDP rx packet loss in a cgroup with a memory limit
To:     Johannes Weiner <hannes@cmpxchg.org>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Cc:     =?UTF-8?Q?Gra=C5=BEvydas_Ignotas?= <notasas@gmail.com>,
        Wei Wang <weiwan@google.com>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Eric and netdev

On Wed, Aug 17, 2022 at 10:13 AM Johannes Weiner <hannes@cmpxchg.org> wrote=
:
>
> On Wed, Aug 17, 2022 at 07:50:13PM +0300, Gra=C5=BEvydas Ignotas wrote:
> > On Tue, Aug 16, 2022 at 9:52 PM Gra=C5=BEvydas Ignotas <notasas@gmail.c=
om> wrote:
> > > Basically, when there is git activity in the container with a memory
> > > limit, other processes in the same container start to suffer (very)
> > > occasional network issues (mostly DNS lookup failures).
> >
> > ok I've traced this and it's failing in try_charge_memcg(), which
> > doesn't seem to be trying too hard because it's called from irq
> > context.
> >
> > Here is the backtrace:
> >  <IRQ>
> >  ? fib_validate_source+0xb4/0x100
> >  ? ip_route_input_slow+0xa11/0xb70
> >  mem_cgroup_charge_skmem+0x4b/0xf0
> >  __sk_mem_raise_allocated+0x17f/0x3e0
> >  __udp_enqueue_schedule_skb+0x220/0x270
> >  udp_queue_rcv_one_skb+0x330/0x5e0
> >  udp_unicast_rcv_skb+0x75/0x90
> >  __udp4_lib_rcv+0x1ba/0xca0
> >  ? ip_rcv_finish_core.constprop.0+0x63/0x490
> >  ip_protocol_deliver_rcu+0xd6/0x230
> >  ip_local_deliver_finish+0x73/0xa0
> >  __netif_receive_skb_one_core+0x8b/0xa0
> >  process_backlog+0x8e/0x120
> >  __napi_poll+0x2c/0x160
> >  net_rx_action+0x2a2/0x360
> >  ? rebalance_domains+0xeb/0x3b0
> >  __do_softirq+0xeb/0x2eb
> >  __irq_exit_rcu+0xb9/0x110
> >  sysvec_apic_timer_interrupt+0xa2/0xd0
> >  </IRQ>
> >
> > Calling mem_cgroup_print_oom_meminfo() in such a case reveals:
> >
> > memory: usage 7812476kB, limit 7812500kB, failcnt 775198
> > swap: usage 0kB, limit 0kB, failcnt 0
> > Memory cgroup stats for
> > /kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podb8f4f0e9=
_fb95_4f2d_8443_e6a78f235c9a.slice/docker-9e7cad93b2e0774d49148474989b41fe6=
d67a5985d059d08d9d64495f1539a81.scope:
> > anon 348016640
> > file 7502163968
> > kernel 146997248
> > kernel_stack 327680
> > pagetables 2224128
> > percpu 0
> > sock 4096
> > vmalloc 0
> > shmem 0
> > zswap 0
> > zswapped 0
> > file_mapped 112041984
> > file_dirty 1181028352
> > file_writeback 2686976
> > swapcached 0
> > anon_thp 44040192
> > file_thp 0
> > shmem_thp 0
> > inactive_anon 350756864
> > active_anon 36864
> > inactive_file 3614003200
> > active_file 3888070656
> > unevictable 0
> > slab_reclaimable 143692600
> > slab_unreclaimable 545120
> > slab 144237720
> > workingset_refault_anon 0
> > workingset_refault_file 2318
> > workingset_activate_anon 0
> > workingset_activate_file 2318
> > workingset_restore_anon 0
> > workingset_restore_file 0
> > workingset_nodereclaim 0
> > pgfault 334152
> > pgmajfault 1238
> > pgrefill 3400
> > pgscan 819608
> > pgsteal 791005
> > pgactivate 949122
> > pgdeactivate 1694
> > pglazyfree 0
> > pglazyfreed 0
> > zswpin 0
> > zswpout 0
> > thp_fault_alloc 709
> > thp_collapse_alloc 0
> >
> > So it basically renders UDP inoperable because of disk cache. I hope
> > this is not the intended behavior. Naturally booting with
> > cgroup.memory=3Dnosocket solves this issue.
>
> This is most likely a regression caused by this patch:
>
> commit 4b1327be9fe57443295ae86fe0fcf24a18469e9f
> Author: Wei Wang <weiwan@google.com>
> Date:   Tue Aug 17 12:40:03 2021 -0700
>
>     net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
>
>     Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
>     to give more control to the networking stack and enable it to change
>     memcg charging behavior. In the future, the networking stack may deci=
de
>     to avoid oom-kills when fallbacks are more appropriate.
>
>     One behavior change in mem_cgroup_charge_skmem() by this patch is to
>     avoid force charging by default and let the caller decide when and if
>     force charging is needed through the presence or absence of
>     __GFP_NOFAIL.
>
>     Signed-off-by: Wei Wang <weiwan@google.com>
>     Reviewed-by: Shakeel Butt <shakeelb@google.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> We never used to fail these allocations. Cgroups don't have a
> kswapd-style watermark reclaimer, so the network relied on
> force-charging and leaving reclaim to allocations that can block.
> Now it seems network packets could just fail indefinitely.
>
> The changelog is a bit terse given how drastic the behavior change
> is. Wei, Shakeel, can you fill in why this was changed? Can we revert
> this for the time being?

Does reverting the patch fix the issue? However I don't think it will.

Please note that we still have the force charging as before this
patch. Previously when mem_cgroup_charge_skmem() force charges, it
returns false and __sk_mem_raise_allocated takes suppress_allocation
code path. Based on some heuristics, it may allow it or it may
uncharge and return failure.

The given patch has not changed any heuristic. It has only changed
when forced charging happens. After the path the initial call
mem_cgroup_charge_skmem() can fail and we take suppress_allocation
code path and if heuristics allow, we force charge with __GFP_NOFAIL.
