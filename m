Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD235A596D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiH3C2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiH3C2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:28:43 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE689E8AB;
        Mon, 29 Aug 2022 19:28:38 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id k66so4555935vsc.11;
        Mon, 29 Aug 2022 19:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=QjrqdkL8EiHyS4Guqm609iRF1yaRNRzIlk5DKbamgo8=;
        b=mwa2PjStAL2PoYMIfVe51D5frUlZHWSS//ENBMptJb92tASbpJcZKvwQDvO6XWBf/0
         +5MeLtVVslLDgMPDnDcrVtSzDhio9vc+uX03u6cbzy6SVDfgnfGLEryQU9WRIwGf6/+O
         WH4zTPszcB7diuZCINwHdTmoP5PBgeXoqfc+CdDjyUoVNN8Rmn42M5+1JX0aUlkJ+NyX
         GdCmaH77/mhRBZKNObV0l1wVVh5tQpi9pELkAjZB/sInHcGEdAjyVgc63J5tK/Rzy53a
         vrQn4JyAjfYP3wBaOShM7cNu1zzwZR0/lGlnl9szZIkPRKY2xolJsn1B+TlGyxav30/m
         rLTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=QjrqdkL8EiHyS4Guqm609iRF1yaRNRzIlk5DKbamgo8=;
        b=h24R5uxJ4gGJgkJOHmGdwMn0noVHxYvgFgq8o3YaS/OqZ6qxwQEQPpilrAvz2L8DkI
         Xz9p+uMo/y1NMJNlHgp1qFf0bDN0b8G6oCxMyFSPr0Yr+l1Fwk/dfsoTzPy+n3pWPajT
         jgFWML+Gl1+zyBfTLPBxl0n020d9Jz8wJwGNU7GMBQbfccLqxqp2NuL7DBw0Qy6SUOoI
         Jt/ksHXFesH3BE2uT41JWtUkR5vXO1PtBoU6t2XEIvzs0xF6d+b1klXFiqfQfHKjoATg
         Mu/sjpUx1MHcgUpPOpBux3g82gWDbcXgw4g2WgQNUNmNHRvi3Pw2xOzzGEBgmd/YuG/Y
         tmwA==
X-Gm-Message-State: ACgBeo3L21S969tqS0aNxm6hsIpu96HzSP4x5rt3FMsXY/0GMoq+zVv0
        GaaOBZvFiopPdHxAsPu3jmZTF06NQjTCrJ8Kpf4=
X-Google-Smtp-Source: AA6agR7xHfa6WrErd9Bk/UWyjKlWX0wCPdyRk3T0VhyapOrfuWCgmK4HjQTqIvw9ODlq9MAc9vqEgE+rKsduq1gTxZU=
X-Received: by 2002:a67:b445:0:b0:391:92ef:464c with SMTP id
 c5-20020a67b445000000b0039192ef464cmr94682vsm.22.1661826517920; Mon, 29 Aug
 2022 19:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651800598.git.peilin.ye@bytedance.com> <cover.1661158173.git.peilin.ye@bytedance.com>
 <CANn89iJsOHK1qgudpfFW9poC4NRBZiob-ynTOuRBkuJTw6FaJw@mail.gmail.com>
In-Reply-To: <CANn89iJsOHK1qgudpfFW9poC4NRBZiob-ynTOuRBkuJTw6FaJw@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 30 Aug 2022 10:28:01 +0800
Message-ID: <CALOAHbDQJY-YeOHnLLrZxyR6Xv957qBe+JH4Mq4YQtBB9AM8zQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 net-next 0/5] net: Qdisc backpressure infrastructure
To:     Eric Dumazet <edumazet@google.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 1:02 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Aug 22, 2022 at 2:10 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> >
> > From: Peilin Ye <peilin.ye@bytedance.com>
> >
> > Hi all,
> >
> > Currently sockets (especially UDP ones) can drop a lot of packets at TC
> > egress when rate limited by shaper Qdiscs like HTB.  This patchset series
> > tries to solve this by introducing a Qdisc backpressure mechanism.
> >
> > RFC v1 [1] used a throttle & unthrottle approach, which introduced several
> > issues, including a thundering herd problem and a socket reference count
> > issue [2].  This RFC v2 uses a different approach to avoid those issues:
> >
> >   1. When a shaper Qdisc drops a packet that belongs to a local socket due
> >      to TC egress congestion, we make part of the socket's sndbuf
> >      temporarily unavailable, so it sends slower.
> >
> >   2. Later, when TC egress becomes idle again, we gradually recover the
> >      socket's sndbuf back to normal.  Patch 2 implements this step using a
> >      timer for UDP sockets.
> >
> > The thundering herd problem is avoided, since we no longer wake up all
> > throttled sockets at the same time in qdisc_watchdog().  The socket
> > reference count issue is also avoided, since we no longer maintain socket
> > list on Qdisc.
> >
> > Performance is better than RFC v1.  There is one concern about fairness
> > between flows for TBF Qdisc, which could be solved by using a SFQ inner
> > Qdisc.
> >
> > Please see the individual patches for details and numbers.  Any comments,
> > suggestions would be much appreciated.  Thanks!
> >
> > [1] https://lore.kernel.org/netdev/cover.1651800598.git.peilin.ye@bytedance.com/
> > [2] https://lore.kernel.org/netdev/20220506133111.1d4bebf3@hermes.local/
> >
> > Peilin Ye (5):
> >   net: Introduce Qdisc backpressure infrastructure
> >   net/udp: Implement Qdisc backpressure algorithm
> >   net/sched: sch_tbf: Use Qdisc backpressure infrastructure
> >   net/sched: sch_htb: Use Qdisc backpressure infrastructure
> >   net/sched: sch_cbq: Use Qdisc backpressure infrastructure
> >
>
> I think the whole idea is wrong.
>
> Packet schedulers can be remote (offloaded, or on another box)
>
> The idea of going back to socket level from a packet scheduler should
> really be a last resort.
>
> Issue of having UDP sockets being able to flood a network is tough, I
> am not sure the core networking stack
> should pretend it can solve the issue.
>
> Note that FQ based packet schedulers can also help already.

We encounter a similar issue when using (fq + edt-bpf) to limit UDP
packet, because of the qdisc buffer limit.
If the qdisc buffer limit is too small, the UDP packet will be dropped
in the qdisc layer. But the sender doesn't know that the packets has
been dropped, so it will continue to send packets, and thus more and
more packets will be dropped there.  IOW, the qdisc will be a
bottleneck before the bandwidth limit is reached.
We workaround this issue by enlarging the buffer limit and flow_limit
(the proper values can be calculated from net.ipv4.udp_mem and
net.core.wmem_default).
But obviously this is not a perfect solution, because
net.ipv4.udp_mem or net.core.wmem_default may be changed dynamically.
We also think about a solution to build a connection between udp
memory and qdisc limit, but not sure if it is a good idea neither.

-- 
Regards
Yafang
