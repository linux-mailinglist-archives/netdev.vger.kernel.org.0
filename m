Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7085D65336F
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbiLUPeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbiLUPeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:34:04 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFAD28750
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:29:52 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id e13so22472888edj.7
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G358wRf9EyBfoMdEyDn26+olHWZSK7nNyZKMZTlc+WE=;
        b=f4tY3PcxVnoX7wlDZ2jbH9dRS+z6HEgdhAwTfeLNUhiFScmKKCPs1KlFIUkwuXo2u/
         OFbVicyjsYTDRRWM9hhZGL7VTDH3/maTgaso44idIAYIkeVq0VYtFHpmg83qEPXsk645
         hq5Jr3sq7FCgr+cCMiFgLT/7Ka6pKZkT+N5AKt5sZjqFNdSQ2tUCiIhXsu924Yvn/NFT
         XhXE5AxqB+sLZV6q+Wvn0dnT0TSFTd7CxxzM8R0tg5n1Ecrf/SFtoTmAtZjXakHd/Lkc
         78ldx4yDWHC30CR1a0L57cUF04vhF06oSmI1Q/DIycR500HxmxMGRzwYk6bkc9eLSXSA
         4sFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G358wRf9EyBfoMdEyDn26+olHWZSK7nNyZKMZTlc+WE=;
        b=IZ+x4O5PbayZpMmWRqlK9J/QIFsnpPJpm6w/fG7R7X6bEmvos6/KlZlAq91vOwOar/
         TpYaiqtp81UOCXngz0X8ZaxR7v0HKzp3SpAVUctQoDKttsH6jJY/9G8HIhLfT3pb7DKh
         o7VGy39UyNdgRU75hVa9QZjKbM7QSwwQI6c74s4/8uZiAR+GJM3PCotzsMMJb5d+ARZI
         BztFlU3qmR/zV6DXUggg7VW77WscWPMRpn1EeRcY7lhH5LSCFMxwfekZfaYAAbKZXihN
         cVe4XNnJZXpk8VJ/nxTIhc095YAeholJvK1KuhRbbGmNPQGkQjN3uZwy0AH2BkYwUrIZ
         /NcA==
X-Gm-Message-State: AFqh2kqGNgJ6LN1+SPOTS+JRk4vEebDKGc/u3J24gat7Gmlez0a1r+GZ
        i395KnaFgi0wKIwvJ/N9LzINpuefMjI4Y+JY0u8=
X-Google-Smtp-Source: AMrXdXuFImdCjHo/UFnufQtHgyjyPXGXWaiSximzKOvD3PJQf0G9i4xrnrauYzMC8U14y94XNeLRR0UmUQy5A9Lqx0s=
X-Received: by 2002:aa7:d69a:0:b0:47c:3ba2:17ca with SMTP id
 d26-20020aa7d69a000000b0047c3ba217camr243819edr.385.1671636574438; Wed, 21
 Dec 2022 07:29:34 -0800 (PST)
MIME-Version: 1.0
References: <20221205093359.49350-1-dnlplm@gmail.com> <20221205093359.49350-3-dnlplm@gmail.com>
 <ad410abb19bdbcdac617878d14a4e37228f1157b.camel@redhat.com>
 <CAGRyCJFL5VmeserfoTMY4bR+EWKSEWrdhSTSY8UQsAZphg8PWw@mail.gmail.com>
 <CAGRyCJEzg2gFCf3svgKGSv5+W4QRsVhbYQ+KZoEfvw_=2Rb+Zg@mail.gmail.com> <3bf0ab2e58acbb203fa36fbdb0cc41de4d9ad6dc.camel@redhat.com>
In-Reply-To: <3bf0ab2e58acbb203fa36fbdb0cc41de4d9ad6dc.camel@redhat.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Wed, 21 Dec 2022 16:22:34 +0100
Message-ID: <CAGRyCJGHSPO+i_xKHGbNg+Hki5tQC3_6Kc8RNcHWN6pxQdjODw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Paolo,

Il giorno mar 20 dic 2022 alle ore 16:28 Paolo Abeni
<pabeni@redhat.com> ha scritto:
>
> On Tue, 2022-12-20 at 15:28 +0100, Daniele Palmas wrote:
> > Hello Paolo,
> >
> > Il giorno ven 9 dic 2022 alle ore 08:38 Daniele Palmas
> > <dnlplm@gmail.com> ha scritto:
> > >
> > > Il giorno mer 7 dic 2022 alle ore 13:46 Paolo Abeni
> > > <pabeni@redhat.com> ha scritto:
> > > > > +static enum hrtimer_restart rmnet_map_flush_tx_packet_queue(struct hrtimer *t)
> > > > > +{
> > > > > +     struct rmnet_port *port;
> > > > > +
> > > > > +     port = container_of(t, struct rmnet_port, hrtimer);
> > > > > +
> > > > > +     schedule_work(&port->agg_wq);
> > > >
> > > > Why you need to schedule a work and you can't instead call the core of
> > > > rmnet_map_flush_tx_packet_work() here? it looks like the latter does
> > > > not need process context...
> > > >
> > >
> > > Ack.
> > >
> >
> > looks like removing the work is not as straightforward as I thought.
> >
> > Now the timer cb has become:
> >
> > static enum hrtimer_restart rmnet_map_flush_tx_packet_cb(struct hrtimer *t)
> > {
> >     struct sk_buff *skb = NULL;
> >     struct rmnet_port *port;
> >
> >     port = container_of(t, struct rmnet_port, hrtimer);
> >
> >     spin_lock_bh(&port->agg_lock);
> >     if (likely(port->agg_state == -EINPROGRESS)) {
> >         /* Buffer may have already been shipped out */
> >         if (likely(port->skbagg_head)) {
> >             skb = port->skbagg_head;
> >             reset_aggr_params(port);
> >         }
> >         port->agg_state = 0;
> >     }
> >     spin_unlock_bh(&port->agg_lock);
> >
> >     if (skb)
> >         rmnet_send_skb(port, skb);
> >
> >     return HRTIMER_NORESTART;
> > }
> >
> > but this is causing the following warning:
> >
> > [ 3106.701296] WARNING: CPU: 15 PID: 0 at kernel/softirq.c:375
> > __local_bh_enable_ip+0x54/0x70
> > ...
> > [ 3106.701537] CPU: 15 PID: 0 Comm: swapper/15 Tainted: G           OE
> >      6.1.0-rc5-rmnet-v4-warn #1
> > [ 3106.701543] Hardware name: LENOVO 30DH00H2IX/1048, BIOS S08KT40A 08/23/2021
> > [ 3106.701546] RIP: 0010:__local_bh_enable_ip+0x54/0x70
> > [ 3106.701554] Code: a9 00 ff ff 00 74 27 65 ff 0d 08 bb 75 61 65 8b
> > 05 01 bb 75 61 85 c0 74 06 5d c3 cc cc cc cc 0f 1f 44 00 00 5d c3 cc
> > cc cc cc <0f> 0b eb bf 65 66 8b 05 e0 ca 76 61 66 85 c0 74 cc e8 e6 fd
> > ff ff
> > [ 3106.701559] RSP: 0018:ffffb8aa80510ec8 EFLAGS: 00010006
> > [ 3106.701564] RAX: 0000000080010202 RBX: ffff932d7b687868 RCX: 0000000000000000
> > [ 3106.701569] RDX: 0000000000000001 RSI: 0000000000000201 RDI: ffffffffc0bd5f7c
> > [ 3106.701573] RBP: ffffb8aa80510ec8 R08: ffff933bdc3e31a0 R09: 000002d355c2f99d
> > [ 3106.701576] R10: 0000000000000000 R11: ffffb8aa80510ff8 R12: ffff932d7b687828
> > [ 3106.701580] R13: ffff932d7b687000 R14: ffff932cc1a76400 R15: ffff933bdc3e3180
> > [ 3106.701584] FS:  0000000000000000(0000) GS:ffff933bdc3c0000(0000)
> > knlGS:0000000000000000
> > [ 3106.701589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 3106.701593] CR2: 00007ffc26dae080 CR3: 0000000209f04003 CR4: 00000000007706e0
> > [ 3106.701597] PKRU: 55555554
> > [ 3106.701599] Call Trace:
> > [ 3106.701602]  <IRQ>
> > [ 3106.701608]  _raw_spin_unlock_bh+0x1d/0x30
> > [ 3106.701623]  rmnet_map_flush_tx_packet_cb+0x4c/0x90 [rmnet]
> > [ 3106.701640]  ? rmnet_send_skb+0x90/0x90 [rmnet]
> > [ 3106.701655]  __hrtimer_run_queues+0x106/0x260
> > [ 3106.701664]  hrtimer_interrupt+0x101/0x220
> > [ 3106.701671]  __sysvec_apic_timer_interrupt+0x61/0x110
> > [ 3106.701677]  sysvec_apic_timer_interrupt+0x7b/0x90
> > [ 3106.701685]  </IRQ>
> > [ 3106.701687]  <TASK>
> > [ 3106.701689]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
> > [ 3106.701694] RIP: 0010:cpuidle_enter_state+0xde/0x6e0
> > [ 3106.701704] Code: eb d6 60 e8 74 01 68 ff 8b 53 04 49 89 c7 0f 1f
> > 44 00 00 31 ff e8 b2 23 67 ff 80 7d d0 00 0f 85 da 00 00 00 fb 0f 1f
> > 44 00 00 <45> 85 f6 0f 88 01 02 00 00 4d 63 ee 49 83 fd 09 0f 87 b6 04
> > 00 00
> > [ 3106.701709] RSP: 0018:ffffb8aa801dbe38 EFLAGS: 00000246
> > [ 3106.701713] RAX: ffff933bdc3f1380 RBX: ffffd8aa7fbc0700 RCX: 000000000000001f
> > [ 3106.701717] RDX: 000000000000000f RSI: 0000000000000002 RDI: 0000000000000000
> > [ 3106.701720] RBP: ffffb8aa801dbe88 R08: 000002d355d34146 R09: 000000000006e988
> > [ 3106.701723] R10: 0000000000000004 R11: 071c71c71c71c71c R12: ffffffffa04ba5c0
> > [ 3106.701727] R13: 0000000000000001 R14: 0000000000000001 R15: 000002d355d34146
> > [ 3106.701735]  ? cpuidle_enter_state+0xce/0x6e0
> > [ 3106.701744]  cpuidle_enter+0x2e/0x50
> > [ 3106.701751]  do_idle+0x204/0x290
> > [ 3106.701758]  cpu_startup_entry+0x20/0x30
> > [ 3106.701763]  start_secondary+0x122/0x160
> > [ 3106.701773]  secondary_startup_64_no_verify+0xe5/0xeb
> > [ 3106.701784]  </TASK>
> >
> > The reason is not obvious to me, so I need to dig further...
>
> It happens because __hrtimer_run_queues runs in hard-IRQ context.
>
> To address the above you need to replace all the
>
> spin_lock_bh(&port->agg_lock);
>
> instances with the spin_lock_irqsave() variant. With one exception: in
> rmnet_map_flush_tx_packet_cb() you can use simply spin_lock() as such
> fuction is already in hard-irq context.
>

Thanks for your hints and I apologize in advance if I'm making naive mistakes.

I've modified the spin related locking according to your advice,
bringing to a different warning:

[ 5403.446269] WARNING: CPU: 1 PID: 0 at kernel/softirq.c:321
__local_bh_disable_ip+0x67/0x80
...
[ 5403.446349] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W  OE
   6.1.0-rc5-rmnet-v4-warn-debug #1
[ 5403.446352] Hardware name: LENOVO 30DH00H2IX/1048, BIOS S08KT40A 08/23/2021
[ 5403.446353] RIP: 0010:__local_bh_disable_ip+0x67/0x80
[ 5403.446355] Code: 00 74 20 9c 58 0f 1f 40 00 f6 c4 02 75 20 80 e7
02 74 06 fb 0f 1f 44 00 00 48 8b 5d f8 c9 c3 cc cc cc cc e8 db e2 08
00 eb d9 <0f> 0b eb ad e8 a0 4b eb 00 eb d9 66 66 2e 0f 1f 84 00 00 00
00 00
[ 5403.446357] RSP: 0018:ffffb8e700238df8 EFLAGS: 00010006
[ 5403.446359] RAX: 0000000080010001 RBX: ffff92d209a248a0 RCX: 0000000000000000
[ 5403.446361] RDX: ffff92d21adf0000 RSI: 0000000000000200 RDI: ffffffffa7de4e22
[ 5403.446362] RBP: ffffb8e700238e00 R08: 0000000000000001 R09: 0000000000000000
[ 5403.446363] R10: ffffb8e700238ec0 R11: 0000000000000000 R12: 0000000000000000
[ 5403.446364] R13: ffff92d209a24000 R14: ffff92d209e7a000 R15: ffff92d203232400
[ 5403.446366] FS:  0000000000000000(0000) GS:ffff92e11bc80000(0000)
knlGS:0000000000000000
[ 5403.446367] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5403.446369] CR2: 00007ffe4db2e080 CR3: 000000017f1dc006 CR4: 00000000007706e0
[ 5403.446370] PKRU: 55555554
[ 5403.446371] Call Trace:
[ 5403.446372]  <IRQ>
[ 5403.446376]  __dev_queue_xmit+0x83/0x11d0
[ 5403.446379]  ? slab_free_freelist_hook.constprop.0+0x8f/0x180
[ 5403.446383]  ? lock_acquire+0x1a9/0x310
[ 5403.446385]  ? rcu_read_lock_sched_held+0x16/0x90
[ 5403.446389]  rmnet_send_skb+0x56/0x90 [rmnet]
[ 5403.446394]  ? rmnet_send_skb+0x56/0x90 [rmnet]
[ 5403.446397]  rmnet_map_flush_tx_packet_cb+0x57/0x90 [rmnet]
[ 5403.446401]  ? rmnet_send_skb+0x90/0x90 [rmnet]
[ 5403.446405]  __hrtimer_run_queues+0x19f/0x3b0
[ 5403.446408]  hrtimer_interrupt+0x101/0x220
[ 5403.446410]  __sysvec_apic_timer_interrupt+0x78/0x230
[ 5403.446412]  sysvec_apic_timer_interrupt+0x7b/0x90
[ 5403.446415]  </IRQ>
[ 5403.446416]  <TASK>
[ 5403.446417]  asm_sysvec_apic_timer_interrupt+0x1b/0x20
[ 5403.446420] RIP: 0010:cpuidle_enter_state+0xeb/0x5e0
[ 5403.446423] Code: 04 bf ff ff ff ff 49 89 c7 e8 21 f6 ff ff 31 ff
e8 4a 48 5c ff 80 7d d0 00 0f 85 db 00 00 00 e8 fb 99 6d ff fb 0f 1f
44 00 00 <45> 85 f6 0f 88 64 01 00 00 4d 63 ee 49 83 fd 09 0f 87 ed 03
00 00
[ 5403.446424] RSP: 0018:ffffb8e70016be40 EFLAGS: 00000246
[ 5403.446426] RAX: ffffb8e70016be88 RBX: ffffd8e6ff483500 RCX: 000000000000001f
[ 5403.446427] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa7d6f7d5
[ 5403.446428] RBP: ffffb8e70016be88 R08: 0000000000000000 R09: 0000000000000000
[ 5403.446429] R10: 0000000000000004 R11: 071c71c71c71c71c R12: ffffffffa8f4de40
[ 5403.446430] R13: 0000000000000002 R14: 0000000000000002 R15: 000004ea167ea79d
[ 5403.446432]  ? cpuidle_enter_state+0xe5/0x5e0
[ 5403.446436]  cpuidle_enter+0x2e/0x50
[ 5403.446439]  do_idle+0x21e/0x2b0
[ 5403.446441]  ? raw_spin_rq_unlock+0x10/0x40
[ 5403.446445]  cpu_startup_entry+0x20/0x30
[ 5403.446447]  start_secondary+0x127/0x160
[ 5403.446450]  secondary_startup_64_no_verify+0xe5/0xeb
[ 5403.446454]  </TASK>
[ 5403.446455] irq event stamp: 94314
[ 5403.446456] hardirqs last  enabled at (94313): [<ffffffffa73c0f97>]
tick_nohz_idle_enter+0x67/0xa0
[ 5403.446460] hardirqs last disabled at (94314): [<ffffffffa733418c>]
do_idle+0xbc/0x2b0
[ 5403.446462] softirqs last  enabled at (93926): [<ffffffffa72cc923>]
__irq_exit_rcu+0xa3/0xd0
[ 5403.446463] softirqs last disabled at (93921): [<ffffffffa72cc923>]
__irq_exit_rcu+0xa3/0xd0
[ 5403.446465] ---[ end trace 0000000000000000 ]---

And gdb says:

(gdb) l* __dev_queue_xmit+0x83
0xffffffff81be4e33 is in __dev_queue_xmit (./include/linux/rcupdate.h:316).
311
312     #ifdef CONFIG_DEBUG_LOCK_ALLOC
313
314     static inline void rcu_lock_acquire(struct lockdep_map *map)
315     {
316             lock_acquire(map, 0, 0, 2, 0, NULL, _THIS_IP_);
317     }
318
319     static inline void rcu_lock_release(struct lockdep_map *map)
320     {

(gdb) l* __local_bh_disable_ip+0x67
0xffffffff810cc447 is in __local_bh_disable_ip (kernel/softirq.c:321).
316     #ifdef CONFIG_TRACE_IRQFLAGS
317     void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
318     {
319             unsigned long flags;
320
321             WARN_ON_ONCE(in_hardirq());
322
323             raw_local_irq_save(flags);
324             /*
325              * The preempt tracer hooks into preempt_count_add and
will break

Does this mean that __dev_queue_xmit can't be called in such a scenario?

Thanks,
Daniele
