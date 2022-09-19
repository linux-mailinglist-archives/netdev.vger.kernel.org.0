Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264205BD355
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 19:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiISRJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 13:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiISRIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 13:08:14 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A0B242ACC;
        Mon, 19 Sep 2022 10:06:17 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id z9so153803qvn.9;
        Mon, 19 Sep 2022 10:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ZumCCGDQusAQ3Mpp2cw6j3semFoJaYgTAu3RsB110TI=;
        b=oVPkUPSHVhU74v9Xs626/cMfInS7G0ZvAbJn8sC7OUx+ddkabpGlwnFqfyUt/PaWhN
         /bWP79W0I3mQokuSIPm3fTm1HE+44WoJ1iQzFqLBLAEHEg47GZuvOGVgbdWoOXfvHNSj
         GGtOlhJJ5GOYndxDpZEgR4fIm+vjvkiEEZu00KBeH99U25fE1M0+AePx5h5XVT+JAhYH
         udQBc6hD42tUTiNg1e0ki9G9+aclf6HjAbLDXMf8jlwot8ZURMXSc5P2ooILajg4A0oi
         zmwjCtPXv4cZO4MGtpqA8REhyLR+A525nZLeeMdeqZGW32ywEOe5mY09Nf8CnPR69XSd
         +cDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZumCCGDQusAQ3Mpp2cw6j3semFoJaYgTAu3RsB110TI=;
        b=2y4w5x9f/x6rQuxW33WbVVJUw0scbe3rIE3ao1/GQmsDKhjGYpfNVQ/8UfRV5qVvgi
         L8FRD7PSiMnZfPw1jbEkiyp50XKCr8M5gi/JAaXkOu2eo+M7mvllTfbrSi+Rs/dIZ54t
         p9GyPTxJ/3PCD97A5q+wT/glsj9jYywYzwuLBIeR30LwmsdTq/pdtjowgJHGaQBENChy
         OFElsnHY5ustSvEEus9+fLxg3bU+eXvGI9GAdjxclY1gpIPw705/Ae2ykf/mxNjqTR1f
         mb6CFDaAjwa9VdDaX9CZ0t5FHapRAKbppGvSQbxeDvXK+NBPHcamcgNF8XYT5O3Aj+iW
         Tc+A==
X-Gm-Message-State: ACrzQf0PEiomvDtGAaMtsZgJJbcXggQVvzCedzmc6iVqpF9WnGezIo/q
        Rzw54cAaqGoq1RgaDQrlfDo=
X-Google-Smtp-Source: AMsMyM4LXnZx2kXa150S3BIgRWySXgcH/voN5Xy5m34cHgeUt/ITmTBsX5rqlw1j6pZdBO/ssvJsjA==
X-Received: by 2002:a05:6214:2387:b0:496:c9db:82b0 with SMTP id fw7-20020a056214238700b00496c9db82b0mr15823610qvb.111.1663607176094;
        Mon, 19 Sep 2022 10:06:16 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:e599:ec9f:997f:2930])
        by smtp.gmail.com with ESMTPSA id c16-20020ac85a90000000b00341a807ed21sm10921840qtc.72.2022.09.19.10.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 10:06:15 -0700 (PDT)
Date:   Mon, 19 Sep 2022 10:06:13 -0700
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
Message-ID: <YyihhbCz4ObMf8yk@pop-os.localdomain>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <cover.1661158173.git.peilin.ye@bytedance.com>
 <CANn89iJsOHK1qgudpfFW9poC4NRBZiob-ynTOuRBkuJTw6FaJw@mail.gmail.com>
 <YwzthDleRuvyEsXC@pop-os.localdomain>
 <CANn89iJMBQ8--_hUihCcBEVawsZQLqL9x9V1=5pzrxTy+w8Z4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJMBQ8--_hUihCcBEVawsZQLqL9x9V1=5pzrxTy+w8Z4A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 09:53:43AM -0700, Eric Dumazet wrote:
> On Mon, Aug 29, 2022 at 9:47 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Mon, Aug 22, 2022 at 09:22:39AM -0700, Eric Dumazet wrote:
> > > On Mon, Aug 22, 2022 at 2:10 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> > > >
> > > > From: Peilin Ye <peilin.ye@bytedance.com>
> > > >
> > > > Hi all,
> > > >
> > > > Currently sockets (especially UDP ones) can drop a lot of packets at TC
> > > > egress when rate limited by shaper Qdiscs like HTB.  This patchset series
> > > > tries to solve this by introducing a Qdisc backpressure mechanism.
> > > >
> > > > RFC v1 [1] used a throttle & unthrottle approach, which introduced several
> > > > issues, including a thundering herd problem and a socket reference count
> > > > issue [2].  This RFC v2 uses a different approach to avoid those issues:
> > > >
> > > >   1. When a shaper Qdisc drops a packet that belongs to a local socket due
> > > >      to TC egress congestion, we make part of the socket's sndbuf
> > > >      temporarily unavailable, so it sends slower.
> > > >
> > > >   2. Later, when TC egress becomes idle again, we gradually recover the
> > > >      socket's sndbuf back to normal.  Patch 2 implements this step using a
> > > >      timer for UDP sockets.
> > > >
> > > > The thundering herd problem is avoided, since we no longer wake up all
> > > > throttled sockets at the same time in qdisc_watchdog().  The socket
> > > > reference count issue is also avoided, since we no longer maintain socket
> > > > list on Qdisc.
> > > >
> > > > Performance is better than RFC v1.  There is one concern about fairness
> > > > between flows for TBF Qdisc, which could be solved by using a SFQ inner
> > > > Qdisc.
> > > >
> > > > Please see the individual patches for details and numbers.  Any comments,
> > > > suggestions would be much appreciated.  Thanks!
> > > >
> > > > [1] https://lore.kernel.org/netdev/cover.1651800598.git.peilin.ye@bytedance.com/
> > > > [2] https://lore.kernel.org/netdev/20220506133111.1d4bebf3@hermes.local/
> > > >
> > > > Peilin Ye (5):
> > > >   net: Introduce Qdisc backpressure infrastructure
> > > >   net/udp: Implement Qdisc backpressure algorithm
> > > >   net/sched: sch_tbf: Use Qdisc backpressure infrastructure
> > > >   net/sched: sch_htb: Use Qdisc backpressure infrastructure
> > > >   net/sched: sch_cbq: Use Qdisc backpressure infrastructure
> > > >
> > >
> > > I think the whole idea is wrong.
> > >
> >
> > Be more specific?
> >
> > > Packet schedulers can be remote (offloaded, or on another box)
> >
> > This is not the case we are dealing with (yet).
> >
> > >
> > > The idea of going back to socket level from a packet scheduler should
> > > really be a last resort.
> >
> > I think it should be the first resort, as we should backpressure to the
> > source, rather than anything in the middle.
> >
> > >
> > > Issue of having UDP sockets being able to flood a network is tough, I
> > > am not sure the core networking stack
> > > should pretend it can solve the issue.
> >
> > It seems you misunderstand it here, we are not dealing with UDP on the
> > network, just on an end host. The backpressure we are dealing with is
> > from Qdisc to socket on _TX side_ and on one single host.
> >
> > >
> > > Note that FQ based packet schedulers can also help already.
> >
> > It only helps TCP pacing.
> 
> FQ : Fair Queue.
> 
> It definitely helps without the pacing part...

True. but the fair queuing part has nothing related to this patchset...
Only the pacing part is related to this topic, and it is merely about
TCP.

Thanks.
