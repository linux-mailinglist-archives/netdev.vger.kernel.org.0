Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B6F2CC4AB
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgLBSLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgLBSLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:11:22 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42686C061A48
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 10:10:42 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p6so1562156plr.7
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 10:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sjP6zhBQ9x8FLMgkiOqnXVlN3V+8taP+rl9E7saVILU=;
        b=gFSiepcySA2QE8MS3Jb0SkCO2Jle+gLZ0r/r8MdXQyF0+O3XEV+HjM+iw4UH120Lq6
         WKIbFhndjP0SZn/FHQ6IOVV4bKNEE6B1I8EyqPtcFizxQezU4vfNQ7cwekTbmKqmAzsq
         bEWcAta+a5PyQ0QxelAAVagQ+eSmxm/3g0MtAm1/SFOehm1Ohh8QqM2JYa8dejwt/shc
         1a6p5h0KydyBHF63uiMuuE2R6pbBJVauJSV4iMV+JasU9vbGsBfH7SaZHbEV7Pzx9KQt
         /cRFDd02aKqcDKal/kZMhmfm2fKjjPPnzq+o32xwDnbxRb0N2KXi3rqFNCRTrlkaMjIg
         JVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sjP6zhBQ9x8FLMgkiOqnXVlN3V+8taP+rl9E7saVILU=;
        b=o42H7rD5I0N/6aifK+xkrJDJhhPZHLap5wBwdWfO619IIgaIGPQNfL68dXV4ifCn6J
         Ts5H+eRn8svuJxZWRwa8GwhDaMqYZHTxoURR10eIeco2Bq2skM4bu+VDh1k/VpWHijkN
         C9rVUBggAHqkLHvETkAB/gIr67SrGpdYIMubBWGN7AHOMfQc9MF2FNuLvg7bQwVZM+93
         eX23AD5aN4IgCaboemrdnR5lVFd677cSMsVPCB5dSYOhTDvOaLOhvBNSRfF76uqP5rcs
         iieREMv7L5xirFlZZrkvI1BxM06w2/xGd4hNLkzP6KlIxVeQyF8gqSxSgxNY0pfgWLwm
         RKOA==
X-Gm-Message-State: AOAM530lKhACOF+cus+NT40JTBN9Cr6os+++eqL1+8aBFCtau0R/V4eU
        7cl8ieVnEYQKRXxEEhcSY7saYWbAfi0=
X-Google-Smtp-Source: ABdhPJzKMxdVYazFFuCamdW0YZnqJWRs5Z4ENk9rilMmEebYpHhgysl23QJccgPfc3hODbvDK3r0XQ==
X-Received: by 2002:a17:902:8ec7:b029:d8:e603:304c with SMTP id x7-20020a1709028ec7b02900d8e603304cmr3695531plo.85.1606932640316;
        Wed, 02 Dec 2020 10:10:40 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g13sm475693pfo.19.2020.12.02.10.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 10:10:39 -0800 (PST)
To:     Grant Edwards <grant.b.edwards@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
Date:   Wed, 2 Dec 2020 10:10:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Andrew,

On 12/2/2020 9:50 AM, Grant Edwards wrote:
> On Thu, Sep 21, 2017 at 3:06 PM Florian Fainelli <f.fainelli@gmail.com
> <mailto:f.fainelli@gmail.com>> wrote:
> 
>     On 09/21/2017 12:59 PM, Grant Edwards wrote:
>     > Several years back (circa 2.6.33) I had to hack up macb.c to work on
>     > an at91 board that didn't have a PHY connected to the macb controller.
>     > [...] 
>     > It looks like the macb driver still can't handle boards that don't
>     > have a PHY.  Is that correct?
> 
>     Not since:
>     dacdbb4dfc1a1a1378df8ebc914d4fe82259ed46 ("net: macb: add fixed-link
>     node support")
> 
>     > What's the right way to deal with this?
> 
>     Declaring a fixed PHY that will present an emulated link UP, with a
>     fixed speed/duplex etc. is the way to go.
> 
> 
> I know this thread is a couple years old, but I finally got around to
> working with a newer kernel (5.4) that has the "fixed phy" support.
> Unfortunately, the existing "fixed phy" support is unusable for us. It
> doesn't just present a fake, fixed, PHY. It replaces the entire mii
> (mdio/mdc) bus with a fake bus. That means our code loses the ability to
> talk to the devices that /are/ attached to the macb's mdio management bus.

You did not indicate this was a requirement.

> 
> So, I ended up porting my hack from the 2.6.33 macb.c driver to the 5.4
> macb.c driver. It presents a fake PHY at one address on the mdio bus,
> but still allows normal communication with devices at other addresses on
> the bus. We use SIOC[SG]MIIREG ioctl() calls from userspace to talk to
> those "real" devices. Adding a fake PHY to the macb's mdio bus takes a
> total of about two dozen lines of code.

That should be unnecessary see below.

> 
> Was there some other way I should have done this with a 5.4 kernel that
> I was unable to discover?

You should be able to continue having the macb MDIO bus controller be
registered with no PHY/MDIO devices represented in Device Tree such that
user-space can continue to use it for ioctl() *and* you can point the
macb node to a fixed PHY for the purpose of having fixed link parameters.

There are various drivers that support exactly this mode of operation
where they use a fixed PHY for the Ethernet MAC link parameters, yet
their MDIO bus controller is used to interface with other devices such
as Ethernet switches over MDIO. Example of drivers supporting that are
stmmac, fec, mtk_star_emac and ag71xx. The way it ends up looking like
in Device Tree is the following:

&eth0 {
	fixed-link {
		speed = <1000>;
		full-duplex;
	};

	mdio {
		phy0: phy@0 {
			reg = <0>;
		};
	};
};

The key thing here is to support a "mdio" bus container node which is
optional and is used as a hint that you need to register the MACB MDIO
bus controller regardless of MII probing having found devices or not.
-- 
Florian
