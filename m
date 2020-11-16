Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B331C2B53E9
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 22:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgKPVm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 16:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgKPVm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 16:42:29 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4C7C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 13:42:27 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id c129so17014126yba.8
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 13:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3O7r7vyTS6kgqOgddwZJ0Pm4IXuhAS0yg7gZom/Zqq0=;
        b=NTnzwFCqXCACEhiiSpYycLtaREitf0TUfDGC6AhS7BRle9g1jWJHG45QpLRVqsllJx
         X4Z914adD2T+H9GEMDJZ91R1wEwEET+Tmkv7VklNB+BU2O0st8r6yc4ES6OfRSCYnVZY
         683ZeXT87wVpO+vKywAh1Fx/k+pPe8RIysE4g71BmcqvxWN5SQJQC5TQczdnoco+vJ+y
         SbJPZ5+/K41p4vPqTGbDxcmdF+oXVKNu4Gcz1vr73aacs4i3qZ10DdeeoRuUdijXXRbJ
         2pTctgfts9c+V9T31Ufej9Q0h2v2nAoxA4jokXFv66zqzk/b3Pt7vKXyLoH2QODtKD/R
         1O2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3O7r7vyTS6kgqOgddwZJ0Pm4IXuhAS0yg7gZom/Zqq0=;
        b=BBSJk/Z+gIPNpKF7ksedKNxHmtE35ngL/ESUgtNVcK4gJ7EenJT4IFu4QvPLvVy9Yo
         KcmIzLo98NARTB185l+m8KwF288G1OAJ90qVEbQhkM5UhtJE2L7nqrAMwBTlPZqNCc5e
         ow1WT8g3Jyn8p4hBuR0YEed1ka9Z+7MiVx0xyOudUJGK82C42gy3uzUujHJXSClyzl7b
         w8c+ymDv5hBKx3ghIg9aWf3ghZO4StRoTd3y5cVo1g/QLqvPcXy9Uq712qwzxfVenuGj
         0TzpWMW8aax5iHk1Lb0DKnaro5Ey9bTiWRQ03MjZ/gdLp4rIGBDflFMLzDa4pd9q4J3r
         bc1w==
X-Gm-Message-State: AOAM533f7j7PqXqca8HnmnT9+t0dXSqKCGMEuzcy+Fm2Vk/ARYfhIjs7
        M4Cyh0Dpkj3nwAh/x0JuSIuRZAWPIdq19FMRZZZJWQ==
X-Google-Smtp-Source: ABdhPJz6N+pb9ayIYo4DXSzoDufNKBGuufctvjVgGCLpG5hujqCoBzQftszxiYBUmR0cb1aU/mU4yyNs6J7NwGmbjAo=
X-Received: by 2002:a25:6951:: with SMTP id e78mr24671448ybc.42.1605562946748;
 Mon, 16 Nov 2020 13:42:26 -0800 (PST)
MIME-Version: 1.0
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
 <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jgYgUa4DPVT8CSsbMs9HFjE5fn_U8-P=JuZeOecfiYt-g@mail.gmail.com>
 <20201116121711.1e7bb04c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF2d9jjs9WF9JXzBGxrHEgAiFhS1qyDya+5WRZBHoxosAu5F4A@mail.gmail.com> <20201116132051.4eef4247@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116132051.4eef4247@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 16 Nov 2020 13:42:10 -0800
Message-ID: <CAF2d9ji9bMtyC7Ldy6bUBfAVDy2yDH_SE10hDcfU6uN1iOeNWw@mail.gmail.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be controlled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jian Yang <jianyang.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        Jian Yang <jianyang@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 1:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 16 Nov 2020 12:50:22 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=
=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=
=A4=B0) wrote:
> > On Mon, Nov 16, 2020 at 12:17 PM Jakub Kicinski <kuba@kernel.org> wrote=
:
> > > On Mon, 16 Nov 2020 12:02:48 -0800 Mahesh Bandewar (=E0=A4=AE=E0=A4=
=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=
=BE=E0=A4=B0) wrote:
> > > > On Sat, Nov 14, 2020 at 10:17 AM Jakub Kicinski <kuba@kernel.org> w=
rote:
> > > > > On Wed, 11 Nov 2020 12:43:08 -0800 Jian Yang wrote:
> > > > > > From: Mahesh Bandewar <maheshb@google.com>
> > > > > >
> > > > > > Traditionally loopback devices comes up with initial state as D=
OWN for
> > > > > > any new network-namespace. This would mean that anyone needing =
this
> > > > > > device (which is mostly true except sandboxes where networking =
in not
> > > > > > needed at all), would have to bring this UP by issuing somethin=
g like
> > > > > > 'ip link set lo up' which can be avoided if the initial state c=
an be set
> > > > > > as UP. Also ICMP error propagation needs loopback to be UP.
> > > > > >
> > > > > > The default value for this sysctl is set to ZERO which will pre=
serve the
> > > > > > backward compatible behavior for the root-netns while changing =
the
> > > > > > sysctl will only alter the behavior of the newer network namesp=
aces.
> > > >
> > > > > Any reason why the new sysctl itself is not per netns?
> > > > >
> > > > Making it per netns would not be very useful since its effect is on=
ly
> > > > during netns creation.
> > >
> > > I must be confused. Are all namespaces spawned off init_net, not the
> > > current netns the process is in?
> > The namespace hierarchy is maintained in user-ns while we have per-ns
> > sysctls hanging off of a netns object and we don't have parent (netns)
> > reference when initializing newly created netns values. One can copy
> > the current value of the settings from root-ns but I don't think
> > that's a good practice since there is no clear way to affect those
> > values when the root-ns changes them. Also from the isolation
> > perspective (I think) it's better to have this behavior (sysctl
> > values) stand on it's own i.e. have default values and then alter
> > values on it's own without linking to any other netns values.
>
> To be clear, what I meant was just to make the sysctl per namespace.
> That way you can deploy a workload with this sysctl set appropriately
> without changing the system-global setting.
>
> Is your expectation that particular application stacks would take
> advantage of this, or that people would set this to 1 across the
> fleet?

Having loopback DOWN is useful to only a tiny fraction of netns use
cases where networking is not enabled but since that's how it had been
historically so breaking that (default) behavior is not right. But
apart from those cases, wherever networking is used inside netns (most
of the use cases), loopback is always required to be UP otherwise your
ICMP error delivery is affected. So workloads that always use
networking inside netns would set this value to be 1 always (Google's
use case) while those workloads where there is a mix of non-networking
as well as networking enabled netns-es can use the default behavior
that has been traditionally present (where the value set to 0).
