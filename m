Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5262F5A5215
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiH2QrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiH2QrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:47:04 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3923A7FE7A;
        Mon, 29 Aug 2022 09:47:04 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id e28so6589615qts.1;
        Mon, 29 Aug 2022 09:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=mg3yPVsPGOhfl9KMQx8tsgwQDpIzz9xWYJXonPMJUFs=;
        b=o6TmM7CHCBSDjCcnKBG4eTEjzl9WVs4/ZzwhpaLRdsaO/STEKItW+KoP+rvl6S3Fds
         s6T4QM5w33Ds50owu6eyxbC0sdAYvBj1Tw3T+5OWJ6arRJ+wXD8pdMhg3NoEhOKBB7za
         pllnYaCJSwwHUjIJAYrTy4TxPeRh7ckYiKp+kNjrAMuLizjHzt2W0mc1W0WTMjz8aFfJ
         SkZ4lpZScSiamdQx0wYszmChvMEfdbr33ZpmqTzJ3EgbBBUt+HX7wHqt8+iQC0Rv8xJn
         g2iIn/8buX2AXWxEdB3Ep8bbwj/Or8I6puvWOuKcQMXJGsxZCToPjO33KvSOBqx14Z1a
         cnAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=mg3yPVsPGOhfl9KMQx8tsgwQDpIzz9xWYJXonPMJUFs=;
        b=WlcH7IREeBR90DFEMqLS81Fn3kY+FpEJYXJvq0IAVN8Tyb/QQHZymRxv9pdXj9avDw
         p/K+iSjaXWh5muk7CI4badqQgZA38BpnnqtklP/GNPlFnjvXAmTb8zPLYLIEFzZYkA/l
         XDozkCuejiBtC9GTLAzThHJ6+R6YMe8uWjB3FTmpfLdSn1liO5pkkgCYW2aRwgWJUZst
         1YtNk+nEElmmWPDp2U8AF8fQzSNUVc+sDyW0m5ELVqGTIn1xgVBTEeArIwpsy+UvgxBU
         0KXQcttLXfe4vyKakfcEn9m75w6dlO69QGoeBmwXcpYAn3sZsSmHd5YTauyVe01KYUNs
         /ICQ==
X-Gm-Message-State: ACgBeo02Jng6CPo3wcNFkU5815dy8G5P1bQg/XzoZtlrJeCIWzVlCQAZ
        KwAQa7qbRdeROPh0GSBONK1tq+fDuEw=
X-Google-Smtp-Source: AA6agR59SHEDezFzi8GE2jq6kZcQxO/Y370HQYjuJl5dH8YcX2/gMY9qp8J6bQkCKQ8zq+wjjjcbzg==
X-Received: by 2002:ac8:5a01:0:b0:344:6aef:9a8d with SMTP id n1-20020ac85a01000000b003446aef9a8dmr10903344qta.131.1661791623337;
        Mon, 29 Aug 2022 09:47:03 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:8fb6:8017:fac7:922b])
        by smtp.gmail.com with ESMTPSA id bj15-20020a05620a190f00b006bbc3724affsm5881045qkb.45.2022.08.29.09.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 09:47:02 -0700 (PDT)
Date:   Mon, 29 Aug 2022 09:47:00 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH RFC v2 net-next 0/5] net: Qdisc backpressure
 infrastructure
Message-ID: <YwzthDleRuvyEsXC@pop-os.localdomain>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <cover.1661158173.git.peilin.ye@bytedance.com>
 <CANn89iJsOHK1qgudpfFW9poC4NRBZiob-ynTOuRBkuJTw6FaJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJsOHK1qgudpfFW9poC4NRBZiob-ynTOuRBkuJTw6FaJw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 09:22:39AM -0700, Eric Dumazet wrote:
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

Be more specific?

> Packet schedulers can be remote (offloaded, or on another box)

This is not the case we are dealing with (yet).

> 
> The idea of going back to socket level from a packet scheduler should
> really be a last resort.

I think it should be the first resort, as we should backpressure to the
source, rather than anything in the middle.

> 
> Issue of having UDP sockets being able to flood a network is tough, I
> am not sure the core networking stack
> should pretend it can solve the issue.

It seems you misunderstand it here, we are not dealing with UDP on the
network, just on an end host. The backpressure we are dealing with is
from Qdisc to socket on _TX side_ and on one single host.

> 
> Note that FQ based packet schedulers can also help already.

It only helps TCP pacing.

Thanks.
