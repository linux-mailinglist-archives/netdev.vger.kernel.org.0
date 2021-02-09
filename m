Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE203159C0
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhBIWym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbhBIWas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:30:48 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3883C061756
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 11:09:53 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id f26so2193498oog.5
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 11:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3toi4HBzT5nWlKSRkfX0VIFAVE1lRZnGEwSiQ1V00hY=;
        b=o6o3cvZD9d1DKx3OGZrbVIqmXz27kI88+qti+AdCDNvYaXtK4OYphn9TQmjBdTE781
         n5K1G4LexSAE9KC9OWrH8/5LlHT+LHx4EJBvqiMRb5GJWVW/umUO+d0R12Td34b4Exjc
         4+vtF8j4YFbw+/XT/SdhVFvLaNko3FuqzcEX6MAbcrEPRDodsK1D9KIzi6f5vp7TgrVt
         8XDrf81YWprPS8rFcj1XXndXekLsOo38UJr7zxa+WsqTuagoSxPPgDe1Kda6ty6A3x4Z
         oqC3clJJWMswQiPVYpV2SoAEhztvAMUOWLWsk94+rLZzKtCuDGG72dlVpg7lrzGI3wq0
         D9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3toi4HBzT5nWlKSRkfX0VIFAVE1lRZnGEwSiQ1V00hY=;
        b=m2OWrYG2ix5ED1/VMMWV25QoFz7v8xyohG44K27/njNOG7Kdftyq4cVqUxG7tgSQTh
         uYas/R8EPNY5NRhey1EarPpxUSkVw5e/oWR5w+1qW/iTH1jhcNbsUcDT3Auv4Qgzyxn7
         o9Q0xOsTOQ7bpk8msF8KiPcoguTUymKAaxVNX6BcHVMALDK9Hs/gllbQgLzYrIDIJGVT
         Ez7uRpop+Rym480y00fxWKptjuNbQkRnOFi+whLjdzdJaIZxumbik6ybHGmTZ8QJqC6n
         M1oc3sUIbPmXZF8iMToZV3rIuAMuw6etssbbHG4vbu3oXKU99zjAr8WmBYO6PWKY7CFu
         hKIw==
X-Gm-Message-State: AOAM531P5xKDrqRjXOAQZPc5jMTQ5HlmVytyGiCq7uK0ZBR4bO+c5Y0P
        0p3rTu9k41IWmKxr16ou2pa0QFQv4YBuv/KF4Q==
X-Google-Smtp-Source: ABdhPJzScuxW+6upWiNoOyHwYtt6YvkLkXYnXbUCyQhX/o+Z1FEwd5SgEHOY2AQGx4GjYGPo2SKIhsttUNJ/a2nnVnw=
X-Received: by 2002:a4a:3407:: with SMTP id b7mr7780462ooa.43.1612897793058;
 Tue, 09 Feb 2021 11:09:53 -0800 (PST)
MIME-Version: 1.0
References: <20210204215926.64377-1-george.mccollister@gmail.com>
 <20210204215926.64377-4-george.mccollister@gmail.com> <20210206232931.pbdvtx3gyluw2s4u@skbuf>
 <CAFSKS=MbXJ5VOL1aPWsNyxZfhOUh9XJ7taGMrNnNv5F2OQPJzA@mail.gmail.com>
 <20210209172024.qlpomxk6siiz5tbr@skbuf> <CAFSKS=OZqpO8=XgZOf8AGFbqPjKu1FryR-1+Qefdt7ku9PSU0w@mail.gmail.com>
 <20210209185119.a4zptdw2xxufzkxp@skbuf>
In-Reply-To: <20210209185119.a4zptdw2xxufzkxp@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 9 Feb 2021 13:09:40 -0600
Message-ID: <CAFSKS=Nv-jObY1X8oCUSGoyYWP3csvNPyE-wUn6DAsDBWmKx5Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/4] net: dsa: add support for offloading HSR
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 12:51 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Feb 09, 2021 at 12:37:38PM -0600, George McCollister wrote:
> > On Tue, Feb 9, 2021 at 11:20 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Mon, Feb 08, 2021 at 11:21:26AM -0600, George McCollister wrote:
> > > > > If you return zero, the software fallback is never going to kick in.
> > > >
> > > > For join and leave? How is this not a problem for the bridge and lag
> > > > functions? They work the same way don't they? I figured it would be
> > > > safe to follow what they were doing.
> > >
> > > I didn't say that the bridge and LAG offloading logic does the right
> > > thing, but it is on its way there...
> > >
> > > Those "XXX not offloaded" messages were tested with cases where the
> > > .port_lag_join callback _is_ present, but fails (due to things like
> > > incompatible xmit hashing policy). They were not tested with the case
> > > where the driver does not implement .port_lag_join at all.
> > >
> > > Doesn't mean you shouldn't do the right thing. I'll send some patches
> > > soon, hopefully, fixing that for LAG and the bridge, you can concentrate
> > > on HSR. For the non-offload scenario where the port is basically
> > > standalone, we also need to disable the other bridge functions such as
> > > address learning, otherwise it won't work properly, and that's where
> > > I've been focusing my attention lately. You can't offload the bridge in
> > > software, or a LAG, if you have address learning enabled. For HSR it's
> > > even more interesting, you need to have address learning disabled even
> > > when you offload the DANH/DANP.
> >
> > Do I just return -EOPNOTSUPP instead of 0 in dsa_switch_hsr_join and
> > dsa_switch_hsr_leave?
>
> Yes, return -EOPNOTSUPP if the callbacks are not implemented please.

Will do.

>
> > I'm not sure exactly what you're saying needs to be done wrt to
> > address learning with HSR. The switch does address learning
> > internally. Are you saying the DSA address learning needs to be
> > disabled?
>
> I'm saying that when you're doing any sort of redundancy protocol, the
> switch will get confused by address learning if it performs it at
> physical port level, because it will see the same source MAC address
> coming in from 2 (or more) different physical ports. And when it sees a
> packet coming in through a port that it had already learned it should be
> the destination for the MAC address because an earlier packet came
> having that MAC address as source, it will think it should do
> hairpinning which it's configured not to => it'll drop the packet.
>
> Now, your switch might have some sort of concept of address learning at
> logical port level, where the "logical port" would roughly correspond to
> the hsr0 upper (I haven't opened the XRS700x manual to know if it does
> this, sorry). Basically if you support RedBox I expect that the switch
> is able to learn at the level of "this MAC address came from the HSR
> ring, aka from one or both of the individual ring ports". But for
> configuring that in Linux, you'd need something like:

Yup, the switch has provisions to deal with this.

>
> ip link set hsr0 master br0
> ip link set hsr0 type bridge_slave learning on
>
> and then catch from DSA the switchdev notification emitted for hsr0, and
> use that to configure learning on the logical port of your switch
> corresponding to hsr0, instead of learning on the physical ports that
> offload it.
>
> There are similar issues related to address learning for everything
> except a bridge port, basically.
>
> > If that's something I need for this patch some tips on what
> > to do would be appreciated because I'm a bit lost.
>
> I didn't say you need to change something related to learning for this
> series, because you can't anyway - DSA doesn't give you the knobs to
> configure address learning yet. The series where I try to add those are
> here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210209151936.97382-1-olteanv@gmail.com/
>
> The take-away is that with those changes, a DSA driver should start its
> ports in standalone mode with learning disabled and flooding of all
> kinds enabled, and then treat the .port_bridge_flags callback which
> should do the right thing and enable/disable address learning only when
> necessary.
>
> All I said is that address learning remaining enabled has been an issue
> that prevented the non-offload scenarios from really working, but you
> shouldn't be too hung up on that, and still return -EOPNOTSUPP, thereby
> allowing the software fallback to kick in, even if it doesn't work.

Thanks for clearing that up and explaining how this will work in the future.
