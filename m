Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ED95BD33D
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 19:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiISRGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 13:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiISRFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 13:05:50 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B60D6C;
        Mon, 19 Sep 2022 10:04:35 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id g12so20657697qts.1;
        Mon, 19 Sep 2022 10:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=iEyMz2Wozz2W+do7kPYT7sIVAyZsPKWdkPIOnJdyvI0=;
        b=R2WC2pamBegIEF4Hpr5AnzBYE7u3l3T4fqQs2n5C6IFu0zmxqW9XB0y30spmI8/32f
         TFCK4CsMPxGP9WuYX1jCoRwx2RZArKFiJqacp8tHQKWIWQgNs8xMJCNa/pHkYXC/iNWn
         bi8S+v+eV1M4epkeM//EdEFzq2duoHSm24esrjkV5OnUbvxfdxIH2ub7dJKm72zjVmzm
         9RO5OY7UiGtsDQc8gkMX8AopszOUYHT+EPUCgWf/WntYtNc7Q6Jmh6DaUtmRl26NVlp4
         Escnfa+YYQ2ehICkm2A9V9lL0xwRIaeqiUgjwsFU+eSMJKl6HVaOGpf4fpYQa6/v6yzL
         C7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=iEyMz2Wozz2W+do7kPYT7sIVAyZsPKWdkPIOnJdyvI0=;
        b=y58q7GC1zAhMUHyH0xnYy26zyov8oVSsSVRhE9nPbYlV6VevCbcA6B3AI5cvEpdJIM
         D0WLIBeQVKOXdcN73kPdlgf6MwJTWInvuRAGhkE5dreXvnlxegLtXFnrdlppDl9HVY39
         EXcpY9tANxT/cMqoQWqp1V7PBNepOqbYuBd41qQ+Isv56t9qS6DTIRFewjGEuw0XFd9i
         y7NIaw4mQYYoZNsgql7dCkd5u4+XXWSS7ylAB/1ytQZzq19Jtno3eJzSNicuDBFiJm0V
         XP1iTgwOLEmB69ARWvbwyfZF6xBLS8VCfxdUTu2Az3QKSIduKA8o+oeMC+S39IXSleW7
         mp/w==
X-Gm-Message-State: ACrzQf1y+ajxbu4+rN6TWmKMZjFw7b6608v9v6k133l8hDO1/NE4vcgM
        vkfCQbZx/PyvyKuKZXf/e0k=
X-Google-Smtp-Source: AMsMyM5VnUwC0v+TvvrH4PujLC2xYieYeupwY9BTTXhM3EDdTXxRlmn/SIo/jG05T5Dmg3SzoeLDyA==
X-Received: by 2002:ac8:5b03:0:b0:35b:b179:9c91 with SMTP id m3-20020ac85b03000000b0035bb1799c91mr15546695qtw.608.1663607074391;
        Mon, 19 Sep 2022 10:04:34 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:e599:ec9f:997f:2930])
        by smtp.gmail.com with ESMTPSA id r21-20020a05620a299500b006ce5ba64e30sm13601954qkp.136.2022.09.19.10.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 10:04:33 -0700 (PDT)
Date:   Mon, 19 Sep 2022 10:04:32 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Peilin Ye <yepeilin.cs@gmail.com>,
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
Message-ID: <YyihIGsWtyQ9fS9q@pop-os.localdomain>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <cover.1661158173.git.peilin.ye@bytedance.com>
 <CANn89iJsOHK1qgudpfFW9poC4NRBZiob-ynTOuRBkuJTw6FaJw@mail.gmail.com>
 <CALOAHbDQJY-YeOHnLLrZxyR6Xv957qBe+JH4Mq4YQtBB9AM8zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbDQJY-YeOHnLLrZxyR6Xv957qBe+JH4Mq4YQtBB9AM8zQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 10:28:01AM +0800, Yafang Shao wrote:
> On Tue, Aug 23, 2022 at 1:02 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Aug 22, 2022 at 2:10 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> > >
> > > From: Peilin Ye <peilin.ye@bytedance.com>
> > >
> > > Hi all,
> > >
> > > Currently sockets (especially UDP ones) can drop a lot of packets at TC
> > > egress when rate limited by shaper Qdiscs like HTB.  This patchset series
> > > tries to solve this by introducing a Qdisc backpressure mechanism.
> > >
> > > RFC v1 [1] used a throttle & unthrottle approach, which introduced several
> > > issues, including a thundering herd problem and a socket reference count
> > > issue [2].  This RFC v2 uses a different approach to avoid those issues:
> > >
> > >   1. When a shaper Qdisc drops a packet that belongs to a local socket due
> > >      to TC egress congestion, we make part of the socket's sndbuf
> > >      temporarily unavailable, so it sends slower.
> > >
> > >   2. Later, when TC egress becomes idle again, we gradually recover the
> > >      socket's sndbuf back to normal.  Patch 2 implements this step using a
> > >      timer for UDP sockets.
> > >
> > > The thundering herd problem is avoided, since we no longer wake up all
> > > throttled sockets at the same time in qdisc_watchdog().  The socket
> > > reference count issue is also avoided, since we no longer maintain socket
> > > list on Qdisc.
> > >
> > > Performance is better than RFC v1.  There is one concern about fairness
> > > between flows for TBF Qdisc, which could be solved by using a SFQ inner
> > > Qdisc.
> > >
> > > Please see the individual patches for details and numbers.  Any comments,
> > > suggestions would be much appreciated.  Thanks!
> > >
> > > [1] https://lore.kernel.org/netdev/cover.1651800598.git.peilin.ye@bytedance.com/
> > > [2] https://lore.kernel.org/netdev/20220506133111.1d4bebf3@hermes.local/
> > >
> > > Peilin Ye (5):
> > >   net: Introduce Qdisc backpressure infrastructure
> > >   net/udp: Implement Qdisc backpressure algorithm
> > >   net/sched: sch_tbf: Use Qdisc backpressure infrastructure
> > >   net/sched: sch_htb: Use Qdisc backpressure infrastructure
> > >   net/sched: sch_cbq: Use Qdisc backpressure infrastructure
> > >
> >
> > I think the whole idea is wrong.
> >
> > Packet schedulers can be remote (offloaded, or on another box)
> >
> > The idea of going back to socket level from a packet scheduler should
> > really be a last resort.
> >
> > Issue of having UDP sockets being able to flood a network is tough, I
> > am not sure the core networking stack
> > should pretend it can solve the issue.
> >
> > Note that FQ based packet schedulers can also help already.
> 
> We encounter a similar issue when using (fq + edt-bpf) to limit UDP
> packet, because of the qdisc buffer limit.
> If the qdisc buffer limit is too small, the UDP packet will be dropped
> in the qdisc layer. But the sender doesn't know that the packets has
> been dropped, so it will continue to send packets, and thus more and
> more packets will be dropped there.  IOW, the qdisc will be a
> bottleneck before the bandwidth limit is reached.
> We workaround this issue by enlarging the buffer limit and flow_limit
> (the proper values can be calculated from net.ipv4.udp_mem and
> net.core.wmem_default).
> But obviously this is not a perfect solution, because
> net.ipv4.udp_mem or net.core.wmem_default may be changed dynamically.
> We also think about a solution to build a connection between udp
> memory and qdisc limit, but not sure if it is a good idea neither.

This is literally what this patchset does. Although this patchset does
not touch any TCP (as TCP has TSQ), I think this is a better approach
than TSQ, because TSQ has no idea about Qdisc limit.

Thanks.
