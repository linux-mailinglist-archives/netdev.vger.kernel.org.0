Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8DA453BBB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhKPVin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhKPVim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 16:38:42 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9BAC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 13:35:45 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id t30so417437wra.10
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 13:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AsMA/wRGdRPrFgo/hshBasWTQf226jxmIo/bqu4LkW0=;
        b=iGfrB/7Yg9ZZdiNX/g6H2jDU4Q893eo750OocGWEBIfgnmAxyMn/6EwW1v+2HO+X/0
         aFGXk+Fw64tS9LEtgOKd2zmr0cf0u4XCeb3bPHzugKDSlBIahye1ANa4QeplChJQfFDz
         FvxBnlXlj/F9vi5PeDW9AFcHHkOMAJDETMhkwhn4ytQpwnj7fw+Fc3SP33K5e9utwYjz
         GsM6/0w6AvQkbo8iVJ0Xwm2tNKTVAHFsADm0cy0E+SvXoua9maaB4/dFJG2MeZCJ8/Aj
         Ma257qNSHdOfIjRGRnmlsfuN0TJyUbRdRB0ZqoyOw0w06zMWQ18pKOfx1Ehe4/2vUtTg
         9HEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AsMA/wRGdRPrFgo/hshBasWTQf226jxmIo/bqu4LkW0=;
        b=tXzcyrSjG+9O33Bp0DS1RdL29BrS96o+pQNGdigJJ5uImjV3pCT3W/dPRl1JNMsz07
         8UiztGZ6ejSxLkspsvqlMPGodFTXqhIwAtpK/+PnlVbk9ntGgZ6Io1CoV8XRATAV7Cw/
         6yf65POLqwTW9oM2fifY0J25aupSSnQ1ARvTwAfQoRPINurq27hfoA1Hss/daNOZTbgn
         SbuDXNAB3df0aRKbCk7spYxQ+oN4ITxZOWCFQGTH0v/otnXFtppjCxAft2HGJqZtJJl6
         gH4IfhrhiB4wJ72likkQPeASI+Psn6yww0rKEgcMCsjGTE+eZSaeXGyxmzoV50B/fnqt
         HTlQ==
X-Gm-Message-State: AOAM530UkK/eB422V2P3KpNnSY0hmwXB3IcDmZfVGQlhT8d5Z9H4V5gx
        9+M0ouNrvc338sGGfu8psdZMQNtiJNt8Th1MwPhUwQ==
X-Google-Smtp-Source: ABdhPJxZ2ynL0OZ63PicgBixgcakve/pyVwrmOimNwUEFaTQYf54u2xqETxXW4GkPvm9sTxpy+rGAn4nV/12u0ig4Bc=
X-Received: by 2002:a05:6000:1548:: with SMTP id 8mr13922827wry.279.1637098543247;
 Tue, 16 Nov 2021 13:35:43 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <20211115190249.3936899-18-eric.dumazet@gmail.com> <20211116062732.60260cd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJL=pGQDgqqKDrL5scxs_S5yMP013ch3-5zwSkMqfMn3A@mail.gmail.com>
 <CANn89iJ5kWdq+agqif+72mrvkBSyHovphrHOUxb2rj-vg5EL8w@mail.gmail.com>
 <20211116072735.68c104ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJb7s-JoCCfn=eoxZ_tX_2RaeEPZKO1aHyHtgHxLXsd2A@mail.gmail.com> <c0ad5909-85ba-3c15-ba5f-c5e257069f8b@gmail.com>
In-Reply-To: <c0ad5909-85ba-3c15-ba5f-c5e257069f8b@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 16 Nov 2021 13:35:31 -0800
Message-ID: <CANn89iJz5ExMC6zGwYWQnJDehWsNwfF4xy2T9tiWodM99FnVyA@mail.gmail.com>
Subject: Re: [PATCH net-next 17/20] tcp: defer skb freeing after socket lock
 is released
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 12:45 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/16/21 9:46 AM, Eric Dumazet wrote:
> > On Tue, Nov 16, 2021 at 7:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Tue, 16 Nov 2021 07:22:02 -0800 Eric Dumazet wrote:
> >>> Here is the perf top profile on cpu used by user thread doing the
> >>> recvmsg(), at 96 Gbit/s
> >>>
> >>> We no longer see skb freeing related costs, but we still see costs of
> >>> having to process the backlog.
> >>>
> >>>    81.06%  [kernel]       [k] copy_user_enhanced_fast_string
> >>>      2.50%  [kernel]       [k] __skb_datagram_iter
> >>>      2.25%  [kernel]       [k] _copy_to_iter
> >>>      1.45%  [kernel]       [k] tcp_recvmsg_locked
> >>>      1.39%  [kernel]       [k] tcp_rcv_established
> >>
> >> Huh, somehow I assumed your 4k MTU numbers were with zero-copy :o
>
> I thought the same. :-)
>
> >>
> >> Out of curiosity - what's the softirq load with 4k? Do you have an
> >> idea what the load is on the CPU consuming the data vs the softirq
> >> processing with 1500B ?
> >
> > On my testing host,
> >
> > 4K MTU : processing ~2,600.000 packets per second in GRO and other parts
> > use about 60% of the core in BH.
>
> 4kB or 4kB+hdr MTU? I ask because there is a subtle difference in the
> size of the GRO packet which affects overall efficiency.
>
> e.g., at 1500 MTU, 1448 MSS, a GRO packet has at most 45 segments for a
> GRO size of 65212. At 4000 MTU, 3948 MSS, a GRO packet has at most 16
> segments for a GRO packet size of 63220. I have noticed that 3300 MTU is
> a bit of sweet spot with MLX5/ConnectX-5 at least - 20 segments and
> 65012 GRO packet without triggering nonlinear mode.

We are using 4096 bytes of payload, to enable TCP RX zero copy if
receiver wants it.
(even if in this case I was using TCP_STREAM which does a standard recvmsg())

Yes, the TSO/GRO standard limit in this case is 15*4K = 61440, but also remember
we are working on BIG TCP packets, so we do not have to find a 'sweet spot' :)

With BIG TCP enabled, I am sending/receiving TSO/GRO packets with 45
4K segments, (184320 bytes of payload).
(But the results I gave in this thread were with standard TSO/GRO limits)

>
>
> > (Some of this cost comes from a clang issue, and the csum_partial() one
> > I was working on last week)
> > NIC RX interrupts are firing about 25,000 times per second in this setup.
> >
> > 1500 MTU : processing ~ 5,800,000 packets per second uses one core in
> > BH (and also one core in recvmsg()),
> > We stay in NAPI mode (no IRQ rearming)
> > (That was with a TCP_STREAM run sustaining 70Gbit)
> >
> > BH numbers also depend on IRQ coalescing parameters.
> >
>
> What NIC do you use for testing?

Google proprietary NIC.
