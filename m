Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353C0300BD5
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbhAVSv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:51:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730153AbhAVSum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:50:42 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505D8C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 10:50:27 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id w124so7092220oia.6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 10:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PwEeBbCyFmOxrkkCBI49Y/4lxi+bSno1aaI+WA0ku0g=;
        b=ukm4SVCj7SVjUlKheIMpZK3pB5MXYTDvxZLx/0vP9KJldWQJFTTwgzs9WkwwGo1cu0
         UJ/5y5bsJmrA8wjzwnNkLDBpT4puq6OmPTXEsZMKJM70OdG6sIfy6EBZ9pY1k1EitrP5
         /B00xK1gslowDrgtVG50qAw2+HedKq41/BxN5WljrJoP8bbHb0LkQQVaojCmC3qqVL6R
         8k2oTj1EzAIyJq0j2ySswqi8UEd6Q+wsabLCySI82XjgsaHK4IXHdg21gPr8x0UWfB8u
         +cn1BjtmsiRX2Bz6MK1CC2Xpfprzm+XpHExsinPRT6NATclM/zX+cm3zx3adfymScJJI
         WtEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PwEeBbCyFmOxrkkCBI49Y/4lxi+bSno1aaI+WA0ku0g=;
        b=ChFVENuCImkTPKGqZmH2DPe1noJgy9TIDrORHbTv59Rbf9jvqzaJhW5Oco4TrBZlUa
         mzacz3nVfDN/4hi1Dhwo6jQ8laTxvXtIaln0j3J0CJmT0a/kBBiPKNGUDOjQrDmlY1sd
         kQ2swFmrdJZba9ILmqsHLr/UlkYYepJB7oNmMvDqJSvfu8pRQ5PxygccBWU5R5sPVB+Q
         bOzfCW1ND75aHJyx+4ggDHhqlDIPiPRTc7NrG+kQx3qN11I7E5RKVIPbdCKeXnzbi6JS
         6Vln1OYrzZ+SGK0ERW85+XCo2az4YCAcDUDwW2JHqS5gcx6q/mlG+SweGGUc/Y4P2bUZ
         rArg==
X-Gm-Message-State: AOAM5301P/wNMaTOkOO0lL/06kky/34w+gDy3Zie9tXC8yvCv+RIeaYh
        11VB2Bu+zITk1PV416O3nfBrnPomDiOcoDkDfQ==
X-Google-Smtp-Source: ABdhPJzqR8xs+GhcjCcgvS7wQaTg0G25hofaknLRhOdTMD6g+3nHy7DX5SBqXUP026qZQo2NBzPB0DPvUk4RGEKN4JE=
X-Received: by 2002:aca:b145:: with SMTP id a66mr4311766oif.92.1611341426627;
 Fri, 22 Jan 2021 10:50:26 -0800 (PST)
MIME-Version: 1.0
References: <20210122155948.5573-1-george.mccollister@gmail.com>
 <20210122155948.5573-3-george.mccollister@gmail.com> <27b8f3f2-a295-6960-2df5-3ee5e457fea3@gmail.com>
In-Reply-To: <27b8f3f2-a295-6960-2df5-3ee5e457fea3@gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 22 Jan 2021 12:50:13 -0600
Message-ID: <CAFSKS=PCmmKiBvnnNzpUA4uO=Xbjrw5DWKFb6yaM3e1vORb4bg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/3] net: hsr: add DSA offloading support
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Murali Karicheri <m-karicheri2@ti.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 11:56 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 1/22/2021 7:59 AM, George McCollister wrote:
> > Add support for offloading of HSR/PRP (IEC 62439-3) tag insertion
> > tag removal, duplicate generation and forwarding on DSA switches.
> >
> > Use a new netdev_priv_flag IFF_HSR to indicate that a device is an HSR
> > device so DSA can tell them apart from other devices in
> > dsa_slave_changeupper.
> >
> > Add DSA_NOTIFIER_HSR_JOIN and DSA_NOTIFIER_HSR_LEAVE which trigger calls
> > to .port_hsr_join and .port_hsr_leave in the DSA driver for the switch.
> >
> > The DSA switch driver should then set netdev feature flags for the
> > HSR/PRP operation that it offloads.
> >     NETIF_F_HW_HSR_TAG_INS
> >     NETIF_F_HW_HSR_TAG_RM
> >     NETIF_F_HW_HSR_FWD
> >     NETIF_F_HW_HSR_DUP
> >
> > For HSR, insertion involves the switch adding a 6 byte HSR header after
> > the 14 byte Ethernet header. For PRP it adds a 6 byte trailer.
> >
> > Tag removal involves automatically stripping the HSR/PRP header/trailer
> > in the switch. This is possible when the switch also preforms auto
> > deduplication using the HSR/PRP header/trailer (making it no longer
> > required).
> >
> > Forwarding involves automatically forwarding between redundant ports in
> > an HSR. This is crucial because delay is accumulated as a frame passes
> > through each node in the ring.
> >
> > Duplication involves the switch automatically sending a single frame
> > from the CPU port to both redundant ports. This is required because the
> > inserted HSR/PRP header/trailer must contain the same sequence number
> > on the frames sent out both redundant ports.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
>
> This is just a high level overview for now, but I would split this into two:
>
> - a patch that adds HSR offload to the existing HSR stack and introduces
> the new netdev_features_t bits to support HSR offload, more on that below
>
> - a patch that does the plumbing between HSR and within the DSA framework

Okay. I think I could just move everything that touches DSA into a
second commit. I kind of pondered this to begin but settled on it
being unnecessary.

>
> > ---
>
> Do you think we can start with a hsr-hw-offload feature and create new
> bits to described how challenged a device may be with HSR offload? Is it
>  reasonable assumption that functional hardware should be able to
> offload all of these functions or none of them?

I'm fine with either way. I see the ksz9477 supports HSR (not sure
which version) and it looks like it doesn't do header insertion or
removal.

I expect the insertion and removal would always come as a pair but I
suppose someone could always do something weird and just do one.
Forwarding and duplication seem like a given for anything claiming
HSR/PRP hardware support.

Knowing this do you think I should go ahead and just change it to
hsr-hw-offload and if someone adds ksz9477 support or whatever later
they can add a new bit?

>
> It may be a good idea to know what the platform that Murali is working
> on or has worked on is capable of doing, too.

Yeah, I copied him but it bounced as did yours.

>
> [snip]
>
> >
> > +static inline bool netif_is_hsr_master(const struct net_device *dev)
> > +{
> > +     return dev->flags & IFF_MASTER && dev->priv_flags & IFF_HSR;
> > +}
> > +
> > +static inline bool netif_is_hsr_slave(const struct net_device *dev)
> > +{
> > +     return dev->flags & IFF_SLAVE && dev->priv_flags & IFF_HSR;
> > +}
>
> I believe the kernel community is now trying to eliminate the use of the
> terms master and slave, can you replace these with some HSR specific
> naming maybe?

Understood however these both already exist and are referenced in ~40
places. Are you saying I should create different macros that wrap them
or change everywhere they are used?

> --
> Florian
