Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F211080DC
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKWVyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:54:31 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35739 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfKWVyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:54:31 -0500
Received: by mail-ed1-f66.google.com with SMTP id r16so9147714edq.2
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 13:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nx+NTZhTCLYxgGLVamdv8eGkC8vIdDFveuRrdSyH/ro=;
        b=iSsLcMpIzth+XU4BIKj5lKPuDQi2jds1bmuwMblfRurbBQCg1DcGmY5wXbizTK4pbT
         lcpUG+q1Wu1nsMbL4oXL3LImSBFR4vQbIEmQTE81YlOUkoooBNind8bDo5GbKl35i28r
         m+DCqCMGCeBWHiCAqrKj2Rdr+S+cUpAPHQKEijHaMsNl3H9h7UV1uAqocH9m69ACoC6P
         q5d+zymRr4Tc5vBCYr6iVvEmdo8PWcbiWyJA/lmA/ydihNNVbyPVaJFwT9nfY0WTAIrr
         kxOd491zvpHLhFvhUoVbTC3ZtrgQNyQLckx81WWqp/Vd8aNi+xwfcdzuTRqENlhpxohP
         XF+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nx+NTZhTCLYxgGLVamdv8eGkC8vIdDFveuRrdSyH/ro=;
        b=EOqggJX2OM1Ft+wtYJ+6IKKEmhw8Y/0tXn0o3xuLImV0COka2TexMSfFwQPnBQxwpr
         hCHYatquoEEO6wJsmE5owl5An7H5KJB4EV3+PmB2h39V6e4HAPb8EzXi0WEH14+jVhoH
         yuXxiW7/xT0kToj/wnY3fj6mLBMZ8rtqfglr+DSF8aG4PROB/tjsbsXvv1xY9m2tOyjt
         oVjX+DEPI70e0YL3DMUXITxZMI8L4TRJm1ZIWWlrGqixfkA6rG60t/OAtXBwqvzmrXw9
         0fU9rf/fQDKiKohfPubJcFhZAXDOxF32nmoNGHESXqL5EJKS6rqja1rnBPHIyZExVXOm
         e9FQ==
X-Gm-Message-State: APjAAAVdVk91KUvHRHUWQ3QbxcHS/PV1wSWWpTytA6kC/LiIvyHDYV3k
        Nj/KH4bDEohn9Qf4ZuZg9F6ETbH1PecLy2Tce8o=
X-Google-Smtp-Source: APXvYqxEyLw9q8U/LHvi+gJz8lTFHBjjEWE7Fcg1fuaIGkNdjwlVkdsO9jpe39JpFy0skkXSNRwf6H/nZ1Y+FTw4Me8=
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr28801172ejq.133.1574546068075;
 Sat, 23 Nov 2019 13:54:28 -0800 (PST)
MIME-Version: 1.0
References: <20191123194844.9508-1-olteanv@gmail.com> <20191123194844.9508-2-olteanv@gmail.com>
 <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com> <CA+h21hpcvGZavmSZK3KEjfKVDt6ySw2Fv42EVfp5HxbZoesSqg@mail.gmail.com>
 <9f344984-ef0c-fc57-d396-48d4c77e1954@gmail.com> <CA+h21hrjCs1Y4XAWhn3mWTMXy=3TE3E5YjpsB6acnTpA6L902A@mail.gmail.com>
 <fb158342-c2f5-f8d1-6987-1dbd79a11472@gmail.com>
In-Reply-To: <fb158342-c2f5-f8d1-6987-1dbd79a11472@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 23 Nov 2019 23:54:17 +0200
Message-ID: <CA+h21ho+UqUBY-T+Q=zzboyG1WbGofJ4pboY4_e-fx+0cb5SAg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 at 23:47, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 11/23/2019 1:29 PM, Vladimir Oltean wrote:
> > On Sat, 23 Nov 2019 at 23:14, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >> On 11/23/2019 12:46 PM, Vladimir Oltean wrote:

[snip]

> >>>> Another thing that I had not gotten around testing was making sure that
> >>>> when a slave_dev gets enslaved as a bridge port member, that bridge MTU
> >>>> normalization would kick in and make sure that if you have say: port 0
> >>>> configured with MTU 1500 and port 1 configured with MTU 9000, the bridge
> >>>> would normalize to MTU 1500 as you would expect.
> >>>>
> >>>
> >>> Nope, that doesn't happen by default, at least in my implementation.
> >>> Is there code in the bridge core for it?
> >>
> >> net/bridge/br_if.c::br_mtu_auto_adjust() takes care of adjusting the
> >> bridge master device's MTU based on the minimum MTU of all ports within
> >> the bridge, but what it seems to be missing is ensuring that if bridge
> >> ports are enslaved, and those bridge ports happen to be part of the same
> >> switch id (similar decision path to setting skb->fwd_offload_mark), then
> >> the bridge port's MTU should also be auto adjusted. mlxsw also supports
> >> changing the MTU, so I am surprised this is not something they fixed
> >> already.
> >>
> >
> > But then how would you even change a bridged interface's MTU? Delete
> > bridge, change MTU of all ports to same value, create bridge again?
>
> I am afraid so, given that the NETDEV_CHANGEMTU even for which
> br_device_event() listens to and processes with br_mtu_auto_adjust()
> would lead to selecting the lowest MTU again. Unfortunately, I don't
> really see a way to solve that other than walk all ports (which could be
> any network device driver) and ask them if they support the new MTU of
> that other port, and if so, commit, else rollback. Do you see another way?
> --
> Florian

Something like that would be preferable. I think it would be
frustrating for the bridge to restore the old MTU right after you
change it. I have no idea how hard it would be to prevent the bridge
from doing this. I'll poke it with a stick and see what happens.

-Vladimir
