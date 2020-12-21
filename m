Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7909F2E0059
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 19:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgLUSrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 13:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727292AbgLUSrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 13:47:15 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F19C0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 10:46:35 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id x15so9822126ilq.1
        for <netdev@vger.kernel.org>; Mon, 21 Dec 2020 10:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oQlMY7Ul8k7FbzdUXl3Pub6yyYP2cIpbsmHjj4Nz3zE=;
        b=m/ey/KxGPQhILwRlm90zFXAlGgzYjSSp0FJ5D9J/C602R/cMvHKt1pDupV4UoWc4IK
         swaNSTp2o2Diz1SrUY4YFtLrxsYotbr6z2J9Lb+KrV8HMOWnc/CDegd60Q14lkmOMNli
         WWXc4dFfZBZGJTZ86CYBYxcHiEG2+9IqKvnydBeArdL3Bya4pxoUvBBt8tpQBzf0dWpC
         lKhHHlAnsWVs/YznGZKOj5ClAAA5lobw+SjGXBnKyABlsgZ/gRR9+rTd+EoP4SKvNxTD
         j8cI99Z/KAa0uEzXgpm6ClCc0HpGo8zqL/Q25mXT8LjBXi6njvXUT58SjJOE5oruWADj
         ssGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oQlMY7Ul8k7FbzdUXl3Pub6yyYP2cIpbsmHjj4Nz3zE=;
        b=ixpqqyEGocFVwT4aEYGiLoVYdI9ds5yQ+l9V/STexV+dy3BpjK+xNZ3BpakaH+4t1n
         Vy/O8ADd/9IVTLvP2AT8Ie+GlLQiYWfGOIBGC2Cue5/EtOMUw+GuDt7T3yJN+evTvc0v
         RTCFYSfjFJS9QtzaRKaB0c0PUuFCegi1HYqRcXArmv1c5+n2DliTdWxHQ1dTeG0aZb1e
         Ie5PrbwnrR6tvzSilUAA68ezS3m/IVdBAfzh7TiXYJV1nPJHWqZNC3N5JIKaMPyWNMxK
         t6781lWZoEdTiW5yi5lBUDEXMILPmv7T4m6SZqHWAHOoHv8YUdvMA2vIKcn6n0VzksZv
         ENTw==
X-Gm-Message-State: AOAM533jtIFav2sM14Jt7sSUFPdjzs9sbuKL2HbSjQkvQR9eAJYtaCdR
        lqp1WU0/cmlH/Pr/bbRH+8ayvqNnokAIrKGs6FbMYg==
X-Google-Smtp-Source: ABdhPJxDseSTYCxM2nXpwzFoufvE4jCMEaiWbtwjy4pVIFSvkEP45GAP4PvMBy+Eww/5AsduobZGLfhm2INJ8kZ82mc=
X-Received: by 2002:a92:9153:: with SMTP id t80mr17458669ild.216.1608576394428;
 Mon, 21 Dec 2020 10:46:34 -0800 (PST)
MIME-Version: 1.0
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
 <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com> <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
 <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com> <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
 <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com> <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
 <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com> <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9003ea3720a03b4bd1b8abf3d8f645563a58f953.camel@sipsolutions.net> <43a5b45c-955a-22d4-2bf9-dbab852dbb5f@candelatech.com>
In-Reply-To: <43a5b45c-955a-22d4-2bf9-dbab852dbb5f@candelatech.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Dec 2020 19:46:23 +0100
Message-ID: <CANn89iJBO13s9fOVRnDyfj5HXt9wjnRpbh2_f5SuyNkNAfjzJQ@mail.gmail.com>
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200 upload
To:     Ben Greear <greearb@candelatech.com>,
        Rainer Suhm <automat@posteo.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 19, 2020 at 5:55 PM Ben Greear <greearb@candelatech.com> wrote:
>
> On 12/19/20 7:18 AM, Johannes Berg wrote:
> > On Fri, 2020-12-18 at 12:16 -0800, Jakub Kicinski wrote:
> >> On Thu, 17 Dec 2020 12:40:26 -0800 Ben Greear wrote:
> >>> On 12/17/20 10:20 AM, Eric Dumazet wrote:
> >>>> On Thu, Dec 17, 2020 at 7:13 PM Ben Greear <greearb@candelatech.com> wrote:
> >>>>> It is the iwlwifi/mvm logic that supports ax200.
> >>>>
> >>>> Let me ask again :
> >>>>
> >>>> I see two different potential call points :
> >>>>
> >>>> drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1529:
> >>>> tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
> >>>> drivers/net/wireless/intel/iwlwifi/queue/tx.c:427:
> >>>> tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
> >>>>
> >>>> To the best of your knowledge, which one would be used in your case ?
> >>>>
> >>>> Both are horribly complex, I do not want to spend time studying two
> >>>> implementations.
> >>>
> >>> It is the queue/tx.c code that executes on my system, verified with
> >>> printk.
> >>
> >> Not sure why Intel's not on CC here.
> >
> > Heh :)
> >
> > Let's also add linux-wireless.
> >
> >> Luca, is the ax200 TSO performance regression with recent kernel on your
> >> radar?
> >
> > It wasn't on mine for sure, so far. But it's supposed to be Christmas
> > vacation, so haven't checked our bug tracker etc. I see Emmanuel was at
> > least looking at the bug report, but not sure what else happened yet.
>
> Not to bitch and moan too much, but even the most basic of testing would
> have shown this, how can testing be so poor on the ax200 driver?
>
> It even shows up with the out-of-tree ax200 driver.
>
> > Off the top of my head, I don't really see the issue. Does anyone have
> > the ability to capture the frames over the air (e.g. with another AX200
> > in monitor mode, load the driver with amsdu_size=3 module parameter to
> > properly capture A-MSDUs)?
>
> I can do that at some point, and likely it could be reproduced with an /n or /ac
> AP and those are a lot easier to sniff.
>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com

It seems the problem comes from some skbs reaching the driver with
gso_type == 0,
meaning skb_is_gso_tcp() is fuzzy. (net/core/tso.c is only one of the
skb_is_gso_tcp() users)

Local TCP stack should provide either SKB_GSO_TCPV4 or SKB_GSO_TCPV6
for GSO packets.

So maybe the issue is coming from traffic coming from a VM through a
tun device or something,
and our handling of GSO_ROBUST / DODGY never cared about setting
SKB_GSO_TCPV4 or SKB_GSO_TCPV6 if not already given by user space ?

Or a plain bug somewhere, possibly overwriting  gso_type with 0 or garbage...
