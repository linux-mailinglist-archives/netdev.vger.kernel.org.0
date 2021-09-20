Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007BA412BC7
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350689AbhIUChe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239821AbhIUB7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 21:59:14 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FD2C11F5CC
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:02:44 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v5so63434732edc.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 11:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T6lypA7SHhpjFcSeW2u6NvP8a2c878aO+hcgK385w0U=;
        b=C/YIhIPJBz0T2Acs1GxSuFkCQhbHhq4naXzanKzwOEuSoXscNL2WnvniVHVIxd/Jaa
         LUI4XEjLU0ECrtZOs+mj3rSwfm/ELtMUU62L3rQdQgkUo5k+tFrh2KfettyzPN1zI/mh
         taIo7CiZsIHCqm3pCHHcdo0e9t03ztY+wKDTsodWkLtW1g7qQF16r/1s2CCc+J4Qv0kr
         snMw5m8199m1eLdS/62EUUezmcgdc39uLGDTY1hS2q2gR6WkxhSLJGouTk2lW5c86NjN
         csCIkS0NNDqU/VplnsOa3tgnjm5B6hUtsLViUjxo+YWVxrgyCoQNJYU/N+hwx0DgCdQi
         AqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T6lypA7SHhpjFcSeW2u6NvP8a2c878aO+hcgK385w0U=;
        b=RJIxiMEpAJe+slKyXfy706dY6fN97DMMFlxmntETzM829chVhLBLZn2dGGENcUwGZQ
         vRAoRiMtQwK06REOGC4puCqlXGutT5C5qxqkXT3Qcv9o20qZCdJHHD566GN+7xS1LLuy
         oFKEytzeVka+TabiMyQButZCgm2NdYgCtaUc15jbw4mtbSMdBCA9+Qbk2pVdco2U0pAK
         fv76VkgngnO4CsXBPVJU+Xf7aj8xVKPz5f72yT9nQX1Yq2ZKUbA5eZzIIkGeFNllFqGI
         f/BZ5oU9pGg+cKTkSk2QpSYDpvtFq2Rz1kVbtaKQwUeZS39OzVbSfUipvm4PUTHCFsin
         KfYQ==
X-Gm-Message-State: AOAM533i29rQV/ChxLgwLX5jgNk0d6+6bkqL+e6m/NWdGrA3tMw3AIN6
        Do0FpNsPVzzkzWFv55mufFw/8PziEyo=
X-Google-Smtp-Source: ABdhPJzJlnfmaM8/a97eHX3WkT82OAn/uNqD2fpC50F1cReD47MXdxSPMQd6vA9cnTlAaGeK1pDc3A==
X-Received: by 2002:a17:906:68c2:: with SMTP id y2mr29893286ejr.18.1632160962229;
        Mon, 20 Sep 2021 11:02:42 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id d11sm6417907ejw.8.2021.09.20.11.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 11:02:41 -0700 (PDT)
Date:   Mon, 20 Sep 2021 21:02:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
Message-ID: <20210920180240.tyi6v3e647rx7dkm@skbuf>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
 <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
 <20210920174022.uc42krhj2on3afud@skbuf>
 <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25e4d46a-5aaf-1d69-162c-2746559b4487@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 10:46:31AM -0700, Florian Fainelli wrote:
> On 9/20/21 10:40 AM, Vladimir Oltean wrote:
> > On Mon, Sep 20, 2021 at 10:14:48AM -0700, Florian Fainelli wrote:
> >> The SPROM is a piece of NVRAM that is intended to describe in a set of
> >> key/value pairs various platform configuration details. There can be up
> >> to 3 GMACs on the SoC which you can connect in a variety of ways towards
> >> internal/external PHYs or internal/external Ethernet switches. The SPROM
> >> is used to describe whether you connect to a regular PHY (not at PHY
> >> address 30 decimal, so not the Broadcom pseudo-PHY) or an Ethernet
> >> switch pseudo-PHY via MDIO.
> >>
> >> What appears to be missing here is that we should not be executing this
> >> block of code for phyaddr == BGMAC_PHY_NOREGS because we will not have a
> >> PHY device proper to begin with and this collides with registering the
> >> b53_mdio driver.
> > 
> > Who provisions the SPROM exactly? It still seems pretty broken to me
> > that one of the GMACs has a bgmac->phyaddr pointing to a switch.
> 
> The OEMs are typically responsible for that. It is not "broken" per-se,
> and you will find additional key/value pairs that e.g.: describe the
> initial switch configuration something like:
> 
> vlan0ports="0 1 2 3 5t"
> vlan1ports="4 5t"
> 
> So this has been used as a dumping ground of "how I want the device to
> be configured eventually". 0x1e/30 is sort of "universally" within
> Broadcom's own universe that this designates an Ethernet switch
> pseudo-PHY MDIO bus address, and we all know that nobody in their right
> mind would design a Wi-Fi router with a discrete Ethernet switch that is
> not from Broadcom, right?
> 

But even so, what's a "pseudo PHY" exactly? I think that's at the bottom
of this issue. In the Linux device model, a device has a single driver.
In this case, the same MDIO device either has a switch driver, if you
accept it's a switch, or a PHY driver, if you accept it's a PHY.
I said it's "broken" because the expectation seems to be that it's a switch,
but it looks like it's treated otherwise. Simply put, the same device
can't be both a switch and a PHY.

The issue is really in bcma_phy_connect. That is what force-binds the
generic PHY driver. Since the bgmac-bcma driver does not support fixed
links, it tries to make do the way it can. This will not work with DSA.

> > Special-casing the Broadcom switch seems not enough, the same thing
> > could happen with a Marvell switch or others. How about looking up the
> > device tree whether the bgmac->mii_bus' OF node has any child with a
> > "reg" of bgmac->phyaddr, and if it does, whether of_mdiobus_child_is_phy
> > actually returns true for it?
> 
> We could do that, however I don't know whether this will break the
> arch/mips/bcm47xx devices which are still in active use by the OpenWrt
> community and for which there is no Device Tree (no technical
> limitation, just no motivation since devices are EOL'd), but maybe out
> of tree patches can be carried in the OpenWrt tree to revert anything
> that upstream came up with.

By OpenWRT do you mean swconfig or actual DSA?

I think Rafal is using device tree, so the check can be conditionally
made based on the presence of an OF node corresponding to the MDIO bus.
That would still work, unless the OpenWRT people want to use DSA without
device tree too...
