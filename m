Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7B940065A
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 22:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350205AbhICUMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 16:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhICUMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 16:12:46 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF68C061575;
        Fri,  3 Sep 2021 13:11:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id j13so447079edv.13;
        Fri, 03 Sep 2021 13:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=70/ASws7s0mC8nBVuT9sifNNXBg9AhnH1ea1sVny9xw=;
        b=dGyOW6dJSFzUWYM+RsSA43OJwGqdFJ7Nj95U4h32FAlsfZrEh8fDW9pyKGUyWxWreL
         ae5JLriJWYVe4YynQz5VT+zDlvT/FzmY/OfBp39NEOLnsqjUx9jU0HlfYS6sqRdB4OtI
         p/YmnlhQNaReRrz60okMf9zdhO78nGxk7munGWbcz5oKregzy6M6tP7uiSooNIcSlE6N
         vmyg6bdJwqhMmCAJyeBG8EvBaRk9euRKGqHOLxB9U3mgzM3VT0tIMCLyp2NWgqv4MPMR
         8xR5vt+vWRwpKtG9w9nSXYFvUL9a4mCL5oKHLXuuwjS3NlwpQv5SF1pj2/EorI5YgvUf
         vEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=70/ASws7s0mC8nBVuT9sifNNXBg9AhnH1ea1sVny9xw=;
        b=RafFpZkaRtym+DSELo3hCyBhr4Bjg+qDYghNRrCnJQzGqGTZKtJETBOs7oB1rmuJ5J
         CVPOPz1/RToF5Ivp/lm9YAmnAwSrXnjOSscJQoANjHyfXbXWN6JeeA+nCvA1i3B5Rmit
         EUNwD1rtIBzeCtWvpMZSCZXJC4qsL0opdl3gWpqM2fWT/SBjeLZ2g+Uq7JCRZkIU2afj
         IMzKKaHaQsdlyQ7Cn5v/efZ7QZfTSzawqvUUAxu0W4Vwkt/hmThi+BX+EghD1Vasgkqu
         /JXK3zufrL3f9kXKrdOgS2i97CmBn4zJTo4lKC2BvxQFMxK1sn0r7Q+nQCX8mt5BVVHc
         v93A==
X-Gm-Message-State: AOAM532X0yqxj13wJ9XTBU8geQPFhmNhPrSAZD+M6IIgPCkVdyCsUWCf
        x6yZ4jYDpcGUvLG6/RS0gSQ=
X-Google-Smtp-Source: ABdhPJxCtr94rmk8p4aPwPVCgm08LIAcVZfPiO+kH33I1m9Wgix8rkF3hiCq6NEULcg7MGX8SuWK6g==
X-Received: by 2002:aa7:d8d5:: with SMTP id k21mr687712eds.261.1630699904383;
        Fri, 03 Sep 2021 13:11:44 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id r5sm181400edx.6.2021.09.03.13.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 13:11:44 -0700 (PDT)
Date:   Fri, 3 Sep 2021 23:11:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Message-ID: <20210903201143.xnfdbxtcurt56hfh@skbuf>
References: <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
 <20210902171033.4byfnu3g25ptnghg@skbuf>
 <20210902175043.GK22278@shell.armlinux.org.uk>
 <20210902190507.shcdmfi3v55l2zuj@skbuf>
 <20210902200301.GM22278@shell.armlinux.org.uk>
 <20210902202124.o5lcnukdzjkbft7l@skbuf>
 <20210902202905.GN22278@shell.armlinux.org.uk>
 <20210903162253.5utsa45zy6h4v76t@skbuf>
 <20210903185434.GX22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903185434.GX22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 03, 2021 at 07:54:34PM +0100, Russell King (Oracle) wrote:
> What do you do about the host CPU interface, which needs to be up
> before you can bring up any of the bridge ports?

I did something which was long overdue IMO, which is to make user space stop
being concerned about them, exactly because no other network managers
beyond systemd-networkd (with its BindCarrier option) had a good built-in
solution.

I've linked to those commits in this same thread already:

9d5ef190e561 ("net: dsa: automatically bring up DSA master when opening user port")
c0a8a9c27493 ("net: dsa: automatically bring user ports down when master goes down")

https://www.kernel.org/doc/html/latest/networking/dsa/configuration.html

| The slave interfaces depend on the master interface being up in order
| for them to send or receive traffic. Prior to kernel v5.12, the state of
| the master interface had to be managed explicitly by the user. Starting
| with kernel v5.12, the behavior is as follows:
| 
|     when a DSA slave interface is brought up, the master interface is automatically brought up.
| 
|     when the master interface is brought down, all DSA slave interfaces are automatically brought down.

> What does the useful "systemd-analyse plot" show? It seems a useful
> tool which I've only recently found to analyse what is going on at
> boot.

I don't know, I've torn down that setup with the sleepy modules already.

> I think I have an idea why it's happening here.
>
> eno1 is connected to the switch. Because eno1 needs to be up first,
> I did this:
>
> # eno1: Switch uplink
> auto eno1
> allow-hotplug eno1
> iface eno1 inet manual
> 	# custom hack to disable IPv6 addresses on this interface.
>         ipv6-disable 1
>         up ip link set $IFACE up
>         up ifup --allow=$IFACE -a || :
>         down ifdown --allow=$IFACE -a || :
>         down ip link set $IFACE down
>
> with:
>
> allow-eno1 brdsl
> iface brdsl inet manual
>         bridge-ports lan2 lan3 lan4 lan5
>         bridge-maxwait 0
>         pre-up sleep 1
>         up ip li set $IFACE type bridge vlan_filtering 1
>
> The effect of that is the "allow-hotplug eno1" causes the systemd
> unit ifup@eno1 to be triggered as soon as eno1 appears - this is
> _before_ DSA has loaded. Once eno1 is up, that then triggers brdsl
> to be configured - but DSA is still probing at that point.
>
> I think removing the "allow-hotplug eno1" should move all that forward
> to being started by networking.service, rather than all being triggered
> by ifup@eno1. I haven't tested that yet though.
>
> Sadly, this behaviour is not documented in the interfaces(5) man page.
>
> Systemd is too complex, not well documented, it's interactions aren't
> documented, it's too easy to non-obviously misconfigure, and it's
> sometimes way too clever. In case it's not obvious - I absolutely hate
> systemd.

I understand just about nothing from the "interfaces" syntax you've
posted here (and maybe it would have been wiser to post it in its
entirety since the first message you wrote about DSA breaking things).
I've looked up the man page, and "allow-CLASS" seems to be a thing
indeed, where CLASS is a sort of wildcard, not just "allow-hotplug",
so "allow-eno1 brdsl" seems to tell ifup to bring brdsl up as soon as
eno1 is brought up. So it behaves exactly as instructed, I guess.
Of course the switch ports are not guaranteed to be up when eno1 is
hotplugged. I'm not sure how much does systemd have to do with this,
other than being the glue between programs?!

As mentioned, with kernels v5.12 and later, you should need none of
these "custom hacks", or need to touch eno1 in any way at all.

I'm not saying it is not possible to set things up correctly using some
sort of obscure chaining of events in ifupdown, if for some reason this
is what you want. But I have no expertise in this area, and frankly, I
have a lot of other things to concentrate my attention on.

I wonder, though, if DSA has done anything in particular to break this
setup through my two commits. Though the scripts you've shared don't
appear particularly reliable, in the sense that they don't do what you
intend them to do, so I'm not sure how to test that assumption.
