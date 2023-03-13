Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AE06B7780
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCMMa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCMMa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:30:56 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A534109F
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:30:48 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id u32so4875244ybi.6
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 05:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678710647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhBPwWSqwICLNYvvKIsFYodaKJz1yYijaHek0r6/xc8=;
        b=BoadWKNF3DdiM9tlZdu1HPZpcVuj7fcum6FlaPxjgB3MQxaVmXu7eiytS4Lj4caoOE
         WTqZhEcd3LMco9UmYjZdANIb215S0Eka4/0Q7lkiG3pHfYzpKDvZyOVo8M5CekVMpQ56
         x/mXdAMaSPWoMnx2BdaIeMtgbFHdqMy9Hxzb7vCGSw1y81nPYQz4l+J4nEXLw9MRAlk3
         DIdul104g8zB/+QX9CpEXWAvqu4tY2d8f6Wpof66PeW8ynrYJC9J17eFYsjbf9cPaA9A
         tZRej8LSK85wam/4HixRUy8WIvFd0b7K25WU4hWWFsmnSp/bYEjRZTUIYP7tiBVWrhW+
         j3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678710647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fhBPwWSqwICLNYvvKIsFYodaKJz1yYijaHek0r6/xc8=;
        b=NmJk+OzmVExIJQE7DFXwqCnHfTig/mhl5dnx8W8ehM2Sxwf6PTaJI/E3df+Z7xmlsz
         joFO/Ef9cRjiCSkxdxHmjJ6tliAqff9jdEyyYQ5pUgVbhP9T7hgpN5RIjVZDBxRbF741
         2BsL9Cqyx62nEGlVWtoMaZe3zDvF6MiaFU/fKKCW43D7ZivzjDdYq5Y42JMDSLAw/paW
         6wFA+yxbyORVi8UTw07YilETghRZhIxVDGeOrxj3f5B/tOGHIegroCzYp3mwyT5st22w
         pTdP1jcPRsYsjtQRZCQxSp+lkJ1mvhj0ZdcLI18QHKDA/9FQZK2auCYNRglPiJnkW7pv
         1qUw==
X-Gm-Message-State: AO0yUKX/CRUzQMKFmWmKsDETupXr6lgUOGHaTVZJNVSz25hT2J954puM
        bU/FSQGf5CIaoIvz97uMpOivahj/syH4BqoxMy1A5/5Dv7yFgnCQcQM0RA==
X-Google-Smtp-Source: AK7set8v6S33AGoyAqC+0PFI0CnjRy0elGX5c7b3G7ovBt5cLZaoVw5ZoP9fI6Ub/K8h7klZxBLdKwGc1rmn8N7zWKY=
X-Received: by 2002:a05:6902:151:b0:afa:d8b5:8e82 with SMTP id
 p17-20020a056902015100b00afad8b58e82mr18848733ybh.6.1678710647348; Mon, 13
 Mar 2023 05:30:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAL87dS0sSsKQOcf22gcHuHu7PjG_j1uiOx-AfRKdT7rznVfJ6Q@mail.gmail.com>
 <20230310213804.26304-1-kuniyu@amazon.com> <CAL87dS3Brkkbi-j-_W3LYORWJ+VOXockpiBwNZQ84rWk+o8SXw@mail.gmail.com>
In-Reply-To: <CAL87dS3Brkkbi-j-_W3LYORWJ+VOXockpiBwNZQ84rWk+o8SXw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Mar 2023 05:30:36 -0700
Message-ID: <CANn89iK4+SoBG3QwvumauH+X8GOxWZyd8S7YC_bFC-3AW8H-aA@mail.gmail.com>
Subject: Re: [ISSUE]soft lockup in __inet_lookup_established() function which
 one sock exist in two hash buckets(tcp_hashinfo.ehash)
To:     mingkun bian <bianmingkun@gmail.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, kerneljasonxing@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 10:46=E2=80=AFPM mingkun bian <bianmingkun@gmail.co=
m> wrote:
>
> Hi,
>
>     I am sorry that a newer kernel is not available to us for a period
> of time for other reasons, this issue is still found in 4.19 of arm,
> maybe this issue has nothing to do with kernel version, please tell me
> if you find any patch about this issue.
>

The 'maybe' question needs to be answered by you...

4.19 is too vague.

Also you mention arm, but your crash output refers to x86_64.

What exact kernel version have you tried ?


> Thanks.
>
> On Sat, 11 Mar 2023 at 05:38, Kuniyuki Iwashima <kuniyu@amazon.com> wrote=
:
> >
> > From:   mingkun bian <bianmingkun@gmail.com>
> > Date:   Fri, 10 Mar 2023 22:51:31 +0800
> > > Hi,
> > >
> > >     I am sorry to submit the same post, because the format of the
> > > previous post is wrong.
> > >
> > >     I have encountered the same issue which causes loop in
> > > __inet_lookup_established for 22 seconds, then kernel crash,
> > > similarly, we have thousands of devices with heavy network traffic,
> > > but only a few of them crash every day due to this reason.
> > >
> > >  https://lore.kernel.org/lkml/CAL+tcoDAY=3DQ5pohEPgkBTNghxTb0AhmbQD58=
dPDghyxmrcWMRQ@mail.gmail.com/T/#mb7b613de68d86c9a302ccf227292ac273cbe7f7c
> > >
> > >     Kernel version is 4.18.0, I analyzed the vmcore and find the poin=
t
> >
> > Thanks for the report, but you should not use 4.18.0 at least, which
> > is no longer supported.  Could you try reproducing it on the net-next
> > tree or another stable versions listed below ?
> >
> > https://www.kernel.org/category/releases.html
> >
> > Thanks,
> > Kuniyuki
> >
> >
> > > of infinite loop is that one sock1 pointers exist in two hash
> > > buckets(tcp_hashinfo.ehash),
> > >
> > >     tcp_hashinfo.ehash is as following:
> > >     buckets0:
> > >     buckets1:->sock1*->0x31(sock1->sk_nulls_node.next =3D 0x31, which
> > > means that sock1* is the end of buckets1), sock1* should not be here
> > > at buckets1,the real vmcore also has only one sock* in buckets1.
> > >     buckets2:
> > >     buckets3:->sock1*->0x31, sock1* is in the correct position at buc=
kets3
> > >     buckets4:->sock2*
> > >     ...
> > >     buckets:N->sockn*
> > >
> > >     then a skb(inet_ehashfn=3D0x1) came, it matched to buckets1, and =
the
> > > condition validation(sk->sk_hash !=3D hash) failed, then entered
> > > condition validation(get_nulls_value(node) !=3D slot) ,
> > >     get_nulls_value(node) =3D 3
> > >     slot =3D 1
> > >     finally, go to begin, and infinite loop.
> > >
> > >     begin:
> > >     sk_nulls_for_each_rcu(sk, node, &head->chain) {
> > >     if (sk->sk_hash !=3D hash)
> > >         continue;
> > >     }
> > >     ...
> > >     if (get_nulls_value(node) !=3D slot)
> > >         goto begin;
> > >
> > >    why does sock1 can exist in two hash buckets, are there some
> > > scenarios where the sock is not deleted from the tcp_hashinfo.ehash
> > > before sk_free?
> > >
> > >
> > >   The detailed three vmcore information is as follow=EF=BC=9A
> > >   vmcore1' info:
> > >   1. print the skb, skb is 0xffff94824975e000 which stored in stack.
> > >
> > >    crash> p *(struct tcphdr *)(((struct
> > > sk_buff*)0xffff94824975e000)->head + ((struct
> > > sk_buff*)0xffff94824975e000)->transport_header)
> > >   $4 =3D {
> > >   source =3D 24125,
> > >   dest =3D 47873,
> > >   seq =3D 4005063716,
> > >   ack_seq =3D 1814397867,
> > >   res1 =3D 0,
> > >   doff =3D 8,
> > >   fin =3D 0,
> > >   syn =3D 0,
> > >   rst =3D 0,
> > >   psh =3D 1,
> > >   ack =3D 1,
> > >   urg =3D 0,
> > >   ece =3D 0,
> > >   cwr =3D 0,
> > >   window =3D 33036,
> > >   check =3D 19975,
> > >   urg_ptr =3D 0
> > > }
> > >
> > > 2. print the sock1, tcp is in TIME_WAIT,the detailed analysis process
> > > is as follows:
> > > a. R14 is 0xffffad2e0dc8a210, which is &hashinfo->ehash[slot].
> > >
> > > crash> p *((struct inet_ehash_bucket*)0xffffad2e0dc8a210)
> > > $14 =3D {
> > >   chain =3D {
> > >     first =3D 0xffff9483ba400f48
> > >   }
> > > }
> > >
> > > b. sock* =3D 0xffff9483ba400f48 - offset(sock, sk_nulls_node) =3D 0xf=
fff9483ba400ee0
> > >
> > > we can see sock->sk_nulls_node is:
> > >   skc_nulls_node =3D {
> > >         next =3D 0x4efbf,
> > >         pprev =3D 0xffffad2e0dd2cef8
> > >       }
> > >
> > > c. skb inet_ehashfn is 0x13242 which is in R15.
> > >
> > > sock->skc_node is 0x4efbf, then its real slot is 0x4efbf >> 1 =3D 0x2=
77df
> > > then bukets[0x277df] is (0x277df - 0x13242) * 8 + 0xffffad2e0dc8a210 =
=3D
> > > 0xFFFFAD2E0DD2CEF8
> > >
> > > d. print bukets[0x277df], find 0xffff9483ba400f48 is the same  as
> > > bukets[0x13242]
> > >
> > > crash> p *((struct inet_ehash_bucket*)0xFFFFAD2E0DD2CEF8)
> > > $32 =3D {
> > >   chain =3D {
> > >     first =3D 0xffff9483ba400f48
> > >   }
> > > }
> > >
> > > crash> p *((struct inet_timewait_sock*)0xffff9483ba400ee0)
> > > $5 =3D {
> > >   __tw_common =3D {
> > >     {
> > >       skc_addrpair =3D 1901830485687183552,
> > >       {
> > >         skc_daddr =3D 442804416,
> > >         skc_rcv_saddr =3D 442804416
> > >       }
> > >     },
> > >     {
> > >       skc_hash =3D 2667739103,
> > >       skc_u16hashes =3D {30687, 40706}
> > >     },
> > >     {
> > >       skc_portpair =3D 3817294857,
> > >       {
> > >         skc_dport =3D 19465,
> > >         skc_num =3D 58247
> > >       }
> > >     },
> > >     skc_family =3D 2,
> > >     skc_state =3D 6 '\006',
> > >     skc_reuse =3D 0 '\000',
> > >     skc_reuseport =3D 0 '\000',
> > >     skc_ipv6only =3D 0 '\000',
> > >     skc_net_refcnt =3D 0 '\000',
> > >     skc_bound_dev_if =3D 0,
> > >     {
> > >       skc_bind_node =3D {
> > >         next =3D 0x0,
> > >         pprev =3D 0xffff9492a8950538
> > >       },
> > >       skc_portaddr_node =3D {
> > >         next =3D 0x0,
> > >         pprev =3D 0xffff9492a8950538
> > >       }
> > >     },
> > >     skc_prot =3D 0xffffffff9b9a9840,
> > >     skc_net =3D {
> > >       net =3D 0xffffffff9b9951c0
> > >     },
> > >     skc_v6_daddr =3D {
> > >       in6_u =3D {
> > >         u6_addr8 =3D
> > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > >         u6_addr32 =3D {0, 0, 0, 0}
> > >       }
> > >     },
> > >     skc_v6_rcv_saddr =3D {
> > >       in6_u =3D {
> > >         u6_addr8 =3D
> > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > >         u6_addr32 =3D {0, 0, 0, 0}
> > >       }
> > >     },
> > >     skc_cookie =3D {
> > >       counter =3D 0
> > >     },
> > >     {
> > >       skc_flags =3D 18446744072025102208,
> > >       skc_listener =3D 0xffffffff9b995780,
> > >       skc_tw_dr =3D 0xffffffff9b995780
> > >     },
> > >     skc_dontcopy_begin =3D 0xffff9483ba400f48,
> > >     {
> > >       skc_node =3D {
> > >         next =3D 0x4efbf,
> > >         pprev =3D 0xffffad2e0dd2cef8
> > >       },
> > >       skc_nulls_node =3D {
> > >         next =3D 0x4efbf,
> > >         pprev =3D 0xffffad2e0dd2cef8
> > >       }
> > >     },
> > >     skc_tx_queue_mapping =3D 0,
> > >     skc_rx_queue_mapping =3D 0,
> > >     {
> > >       skc_incoming_cpu =3D -1680142171,
> > >       skc_rcv_wnd =3D 2614825125,
> > >       skc_tw_rcv_nxt =3D 2614825125
> > >     },
> > >     skc_refcnt =3D {
> > >       refs =3D {
> > >         counter =3D 3
> > >       }
> > >     },
> > >     skc_dontcopy_end =3D 0xffff9483ba400f64,
> > >     {
> > >       skc_rxhash =3D 320497927,
> > >       skc_window_clamp =3D 320497927,
> > >       skc_tw_snd_nxt =3D 320497927
> > >     }
> > >   },
> > >   tw_mark =3D 0,
> > >   tw_substate =3D 6 '\006',
> > >   tw_rcv_wscale =3D 10 '\n',
> > >   tw_sport =3D 34787,
> > >   tw_kill =3D 0,
> > >   tw_transparent =3D 0,
> > >   tw_flowlabel =3D 0,
> > >   tw_pad =3D 0,
> > >   tw_tos =3D 0,
> > >   tw_timer =3D {
> > >     entry =3D {
> > >       next =3D 0xffff9483ba401d48,
> > >       pprev =3D 0xffff9481680177f8
> > >     },
> > >     expires =3D 52552264960,
> > >     function =3D 0xffffffff9ad67ba0,
> > >     flags =3D 1339031587,
> > >     rh_reserved1 =3D 0,
> > >     rh_reserved2 =3D 0,
> > >     rh_reserved3 =3D 0,
> > >     rh_reserved4 =3D 0
> > >   },
> > >   tw_tb =3D 0xffff9492a8950500
> > > }
> > > 3.call stack
> > > [48256841.222682]  panic+0xe8/0x25c
> > > [48256841.222766]  ? secondary_startup_64+0xb6/0xc0
> > > [48256841.222853]  watchdog_timer_fn+0x209/0x210
> > > [48256841.222939]  ? watchdog+0x30/0x30
> > > [48256841.223027]  __hrtimer_run_queues+0xe5/0x260
> > > [48256841.223117]  hrtimer_interrupt+0x122/0x270
> > > [48256841.223209]  ? sched_clock+0x5/0x10
> > > [48256841.223296]  smp_apic_timer_interrupt+0x6a/0x140
> > > [48256841.223384]  apic_timer_interrupt+0xf/0x20
> > > [48256841.223471] RIP: 0010:__inet_lookup_established+0xe9/0x170
> > > [48256841.223562] Code: f6 74 33 44 3b 62 a4 75 3d 48 3b 6a 98 75 37
> > > 8b 42 ac 85 c0 75 24 4c 3b 6a c8 75 2a 5b 5d 41 5c 41 5d 41 5e 48 89
> > > f8 41 5f c3 <48> d1 ea 49 39 d7 0f 85 5a ff ff ff 31 ff eb e2 39 44 2=
4
> > > 38 74 d6
> > > [48256841.224242] RSP: 0018:ffff9497e0e83bf8 EFLAGS: 00000202
> > > ORIG_RAX: ffffffffffffff13
> > > [48256841.224904] RAX: ffffad2e0dbf1000 RBX: 0000000088993242 RCX:
> > > 0000000034d20a82
> > > [48256841.225576] RDX: 000000000004efbf RSI: 00000000527c6da0 RDI:
> > > 0000000000000000
> > > [48256841.226268] RBP: 1e31b4763470e11b R08: 0000000001bb5e3d R09:
> > > 00000000000001bb
> > > [48256841.226969] R10: 0000000000005429 R11: 0000000000000000 R12:
> > > 0000000001bb5e3d
> > > [48256841.227646] R13: ffffffff9b9951c0 R14: ffffad2e0dc8a210 R15:
> > > 0000000000013242
> > > [48256841.228330]  ? apic_timer_interrupt+0xa/0x20
> > > [48256841.228714]  ? __inet_lookup_established+0x3f/0x170
> > > [48256841.229097]  tcp_v4_early_demux+0xb0/0x170
> > > [48256841.229487]  ip_rcv_finish+0x17c/0x430
> > > [48256841.229865]  ip_rcv+0x27c/0x380
> > > [48256841.230242]  __netif_receive_skb_core+0x9e9/0xac0
> > > [48256841.230623]  ? inet_gro_receive+0x21b/0x2d0
> > > [48256841.230999]  ? recalibrate_cpu_khz+0x10/0x10
> > > [48256841.231378]  netif_receive_skb_internal+0x42/0xf0
> > > [48256841.231777]  napi_gro_receive+0xbf/0xe0
> > >
> > >
> > > vmcore2' info:
> > >  1. print the skb
> > > crash> p *(struct tcphdr *)(((struct
> > > sk_buff*)0xffff9d60c008b500)->head + ((struct
> > > sk_buff*)0xffff9d60c008b500)->transport_header)
> > > $28 =3D {
> > >   source =3D 35911,
> > >   dest =3D 20480,
> > >   seq =3D 1534560442,
> > >   ack_seq =3D 0,
> > >   res1 =3D 0,
> > >   doff =3D 10,
> > >   fin =3D 0,
> > >   syn =3D 1,
> > >   rst =3D 0,
> > >   psh =3D 0,
> > >   ack =3D 0,
> > >   urg =3D 0,
> > >   ece =3D 0,
> > >   cwr =3D 0,
> > >   window =3D 65535,
> > >   check =3D 56947,
> > >   urg_ptr =3D 0
> > > }
> > > 2. print the sock1, tcp is in TIME_WAIT, but the sock is ipv4, I do
> > > not know why skc_v6_daddr and rh_reserved is not zero, maybe memory
> > > out of bounds?
> > > crash> p *((struct inet_timewait_sock*)0xFFFF9D6F1997D540)
> > > $29 =3D {
> > >   __tw_common =3D {
> > >     {
> > >       skc_addrpair =3D 388621010873919680,
> > >       {
> > >         skc_daddr =3D 426027200,
> > >         skc_rcv_saddr =3D 90482880
> > >       }
> > >     },
> > >     {
> > >       skc_hash =3D 884720419,
> > >       skc_u16hashes =3D {49955, 13499}
> > >     },
> > >     {
> > >       skc_portpair =3D 156018620,
> > >       {
> > >         skc_dport =3D 42940,
> > >         skc_num =3D 2380
> > >       }
> > >     },
> > >     skc_family =3D 2,
> > >     skc_state =3D 6 '\006',
> > >     skc_reuse =3D 1 '\001',
> > >     skc_reuseport =3D 0 '\000',
> > >     skc_ipv6only =3D 0 '\000',
> > >     skc_net_refcnt =3D 0 '\000',
> > >     skc_bound_dev_if =3D 0,
> > >     {
> > >       skc_bind_node =3D {
> > >         next =3D 0xffff9d8993851448,
> > >         pprev =3D 0xffff9d89c3510458
> > >       },
> > >       skc_portaddr_node =3D {
> > >         next =3D 0xffff9d8993851448,
> > >         pprev =3D 0xffff9d89c3510458
> > >       }
> > >     },
> > >     skc_prot =3D 0xffffffff9c7a9840,
> > >     skc_net =3D {
> > >       net =3D 0xffffffff9c7951c0
> > >     },
> > >     skc_v6_daddr =3D {
> > >       in6_u =3D {
> > >         u6_addr8 =3D "$P=EE=A4=86\325\001\354M\213D\021p\323\337\n",
> > >         u6_addr16 =3D {20516, 42222, 54662, 60417, 35661, 4420, 54128=
, 2783},
> > >         u6_addr32 =3D {2767081508, 3959543174, 289704781, 182440816}
> > >       }
> > >     },
> > >     skc_v6_rcv_saddr =3D {
> > >       in6_u =3D {
> > >         u6_addr8 =3D "=CB=B2\231=C2=AA\212*pzf\212\277\325\065=D8=84"=
,
> > >         u6_addr16 =3D {45771, 49817, 35498, 28714, 26234, 49034, 1378=
1, 34008},
> > >         u6_addr32 =3D {3264852683, 1881836202, 3213518458, 2228762069=
}
> > >       }
> > >     },
> > >     skc_cookie =3D {
> > >       counter =3D 0
> > >     },
> > >     {
> > >       skc_flags =3D 18446744072039782272,
> > >       skc_listener =3D 0xffffffff9c795780,
> > >       skc_tw_dr =3D 0xffffffff9c795780
> > >     },
> > >     skc_dontcopy_begin =3D 0xffff9d6f1997d5a8,
> > >     {
> > >       skc_node =3D {
> > >         next =3D 0x78647,
> > >         pprev =3D 0xffffb341cddea918
> > >       },
> > >       skc_nulls_node =3D {
> > >         next =3D 0x78647,
> > >         pprev =3D 0xffffb341cddea918
> > >       }
> > >     },
> > >     skc_tx_queue_mapping =3D 51317,
> > >     skc_rx_queue_mapping =3D 9071,
> > >     {
> > >       skc_incoming_cpu =3D -720721118,
> > >       skc_rcv_wnd =3D 3574246178,
> > >       skc_tw_rcv_nxt =3D 3574246178
> > >     },
> > >     skc_refcnt =3D {
> > >       refs =3D {
> > >         counter =3D 3
> > >       }
> > >     },
> > >     skc_dontcopy_end =3D 0xffff9d6f1997d5c4,
> > >     {
> > >       skc_rxhash =3D 2663156681,
> > >       skc_window_clamp =3D 2663156681,
> > >       skc_tw_snd_nxt =3D 2663156681
> > >     }
> > >   },
> > >   tw_mark =3D 0,
> > >   tw_substate =3D 6 '\006',
> > >   tw_rcv_wscale =3D 10 '\n',
> > >   tw_sport =3D 19465,
> > >   tw_kill =3D 0,
> > >   tw_transparent =3D 0,
> > >   tw_flowlabel =3D 201048,
> > >   tw_pad =3D 1,
> > >   tw_tos =3D 0,
> > >   tw_timer =3D {
> > >     entry =3D {
> > >       next =3D 0xffff9d6f1997d4c8,
> > >       pprev =3D 0xffff9d6f1997c6f8
> > >     },
> > >     expires =3D 52813074277,
> > >     function =3D 0xffffffff9bb67ba0,
> > >     flags =3D 1313865770,
> > >     rh_reserved1 =3D 14775289730400096190,
> > >     rh_reserved2 =3D 10703603942626563734,
> > >     rh_reserved3 =3D 17306812468345150807,
> > >     rh_reserved4 =3D 9531906593543422642
> > >   },
> > >   tw_tb =3D 0xffff9d897232a500
> > > }
> > >
> > > vmcore3' info:
> > > 1. print the skbcrash> p *(struct tcphdr *)(((struct
> > > sk_buff*)0xffffa039e93aaf00)->head + ((struct
> > > sk_buff*)0xffffa039e93aaf00)->transport_header)
> > > $6 =3D {
> > >   source =3D 9269,
> > >   dest =3D 47873,
> > >   seq =3D 147768854,
> > >   ack_seq =3D 1282978926,
> > >   res1 =3D 0,
> > >   doff =3D 5,
> > >   fin =3D 0,
> > >   syn =3D 0,
> > >   rst =3D 0,
> > >   psh =3D 0,
> > >   ack =3D 1,
> > >   urg =3D 0,
> > >   ece =3D 0,
> > >   cwr =3D 0,
> > >   window =3D 47146,
> > >   check =3D 55446,
> > >   urg_ptr =3D 0
> > > }
> > > 2. print the sock1, tcp is in TIME_WAIT
> > > crash> p *((struct inet_timewait_sock*)0xFFFFA0444BAADBA0)
> > > $7 =3D {
> > >   __tw_common =3D {
> > >     {
> > >       skc_addrpair =3D 2262118455826491584,
> > >       {
> > >         skc_daddr =3D 392472768,
> > >         skc_rcv_saddr =3D 526690496
> > >       }
> > >     },
> > >     {
> > >       skc_hash =3D 382525308,
> > >       skc_u16hashes =3D {57212, 5836}
> > >     },
> > >     {
> > >       skc_portpair =3D 1169509385,
> > >       {
> > >         skc_dport =3D 19465,
> > >         skc_num =3D 17845
> > >       }
> > >     },
> > >     skc_family =3D 2,
> > >     skc_state =3D 6 '\006',
> > >     skc_reuse =3D 0 '\000',
> > >     skc_reuseport =3D 0 '\000',
> > >     skc_ipv6only =3D 0 '\000',
> > >     skc_net_refcnt =3D 0 '\000',
> > >     skc_bound_dev_if =3D 0,
> > >     {
> > >       skc_bind_node =3D {
> > >         next =3D 0x0,
> > >         pprev =3D 0xffffa0528fefba98
> > >       },
> > >       skc_portaddr_node =3D {
> > >         next =3D 0x0,
> > >         pprev =3D 0xffffa0528fefba98
> > >       }
> > >     },
> > >     skc_prot =3D 0xffffffffa33a9840,
> > >     skc_net =3D {
> > >       net =3D 0xffffffffa33951c0
> > >     },
> > >     skc_v6_daddr =3D {
> > >       in6_u =3D {
> > >         u6_addr8 =3D
> > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > >         u6_addr32 =3D {0, 0, 0, 0}
> > >       }
> > >     },
> > >     skc_v6_rcv_saddr =3D {
> > >       in6_u =3D {
> > >         u6_addr8 =3D
> > > "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000",
> > >         u6_addr16 =3D {0, 0, 0, 0, 0, 0, 0, 0},
> > >         u6_addr32 =3D {0, 0, 0, 0}
> > >       }
> > >     },
> > >     skc_cookie =3D {
> > >       counter =3D 20818915981
> > >     },
> > >     {
> > >       skc_flags =3D 18446744072153028480,
> > >       skc_listener =3D 0xffffffffa3395780,
> > >       skc_tw_dr =3D 0xffffffffa3395780
> > >     },
> > >     skc_dontcopy_begin =3D 0xffffa0444baadc08,
> > >     {
> > >       skc_node =3D {
> > >         next =3D 0x9bef9,
> > >         pprev =3D 0xffffb36fcde60be0
> > >       },
> > >       skc_nulls_node =3D {
> > >         next =3D 0x9bef9,
> > >         pprev =3D 0xffffb36fcde60be0
> > >       }
> > >     },
> > >     skc_tx_queue_mapping =3D 0,
> > >     skc_rx_queue_mapping =3D 0,
> > >     {
> > >       skc_incoming_cpu =3D -2041214926,
> > >       skc_rcv_wnd =3D 2253752370,
> > >       skc_tw_rcv_nxt =3D 2253752370
> > >     },
> > >     skc_refcnt =3D {
> > >       refs =3D {
> > >         counter =3D 3
> > >       }
> > >     },
> > >     skc_dontcopy_end =3D 0xffffa0444baadc24,
> > >     {
> > >       skc_rxhash =3D 653578381,
> > >       skc_window_clamp =3D 653578381,
> > >       skc_tw_snd_nxt =3D 653578381
> > >     }
> > >   },
> > >   tw_mark =3D 0,
> > >   tw_substate =3D 6 '\006',
> > >   tw_rcv_wscale =3D 10 '\n',
> > >   tw_sport =3D 46405,
> > >   tw_kill =3D 0,
> > >   tw_transparent =3D 0,
> > >   tw_flowlabel =3D 0,
> > >   tw_pad =3D 0,
> > >   tw_tos =3D 0,
> > >   tw_timer =3D {
> > >     entry =3D {
> > >       next =3D 0xffffa0444baac808,
> > >       pprev =3D 0xffffa0388b5477f8
> > >     },
> > >     expires =3D 33384532933,
> > >     function =3D 0xffffffffa2767ba0,
> > >     flags =3D 1313865761,
> > >     rh_reserved1 =3D 0,
> > >     rh_reserved2 =3D 0,
> > >     rh_reserved3 =3D 0,
> > >     rh_reserved4 =3D 0
> > >   },
> > >   tw_tb =3D 0xffffa05cc8322d40
> > > }
