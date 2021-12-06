Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0939846A967
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 22:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350363AbhLFVRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240452AbhLFVRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:17:21 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7F3C061D60
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 13:13:46 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v1so48449606edx.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 13:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4h7gsxWmRJBE+VtEGYSSaY5WMzsgw3Sxy5Ss4w0Ehso=;
        b=i11jejfyAT6YzTo6KRXS2N+KeglO81KyQDS3++BMxFR63I7hpoYHTwvImsJwoXAIY7
         ijI+bZmh+f8g39rySveqJOBtGLI4x6bajfMRdEN9XQPsmGu2Qt+l4PuVfO/m1QsZ/AEF
         oU6AyMOk0a837vHW8TKvZx5pFVVddPWA7qtjWOI9FyE40r/Ztip9UDRwfuWIokYfu/Dz
         +BrErXFrLte5kv9+VuQosDVBtGbtDQz1qqklFrPZZb3hdo8f5KXyYZq4FWIDIY/1PBpt
         v58S5eF6w9YnT4sRQ9LBTcBLlAJblGH6XaT3J5Lus4ceGYiPFu/Y3WE1iy0Vqr7Kh4OZ
         QIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4h7gsxWmRJBE+VtEGYSSaY5WMzsgw3Sxy5Ss4w0Ehso=;
        b=1BZKsBw0lEjDBevX2ssXSj8/kYp+eNnLL/S8S67hbuSYDiqgfRPF2ZaQ2FHPvN7jZs
         qFKPGkheYkVd0IAayieJVOoQG9sD+477+hPXSzFf+HARhDrb/cyOEHbgvIk5gVbJzb/4
         PM0a3vTUrvgpdM7UIdP7lbbxJLj/8ZdGHkWTX0pC23UWNhh6vtYmtgp2p4OnJ6JIvjJO
         qv/Ovi66R6g0xW2Bz43VT8z/YOKc0STdmV7lPA5f/EwmVHAUFAfEne/jyHnL6QcVF32c
         1S3lmu2RDu4GZn9LIp4zaDjmAzvnrp1raviV/MktHlIWw4NaGnth2wSWYWP0UDadUiTX
         Kmrw==
X-Gm-Message-State: AOAM531xysQ1a49ejrvPcxwrd1El0jtnIA9nDonA4QSmECEFh4WNv1rQ
        yz/vgnRIwSxhPQG30IJkw6c=
X-Google-Smtp-Source: ABdhPJyOJr7yL1duxmQqVI+bBnghaxtjmHIoUws57nvpaEpWHlB2XnAmW9/hQVboA8Y39tJa6WtTRQ==
X-Received: by 2002:a17:906:ad89:: with SMTP id la9mr47100572ejb.178.1638825225142;
        Mon, 06 Dec 2021 13:13:45 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id w22sm9244543edd.49.2021.12.06.13.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 13:13:42 -0800 (PST)
Date:   Mon, 6 Dec 2021 23:13:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206211341.ppllxa7ve2jdyzt4@skbuf>
References: <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 08:51:09PM +0000, Russell King (Oracle) wrote:
> On Mon, Dec 06, 2021 at 10:23:08PM +0200, Vladimir Oltean wrote:
> > On Mon, Dec 06, 2021 at 08:07:45PM +0000, Russell King (Oracle) wrote:
> > > My conclusion from having read this thread is the CPU port is using PPU
> > > polling, meaning that in mac_link_up():
> > > 
> > >         if ((!mv88e6xxx_phy_is_internal(ds, port) &&
> > >              !mv88e6xxx_port_ppu_updates(chip, port)) ||
> > >             mode == MLO_AN_FIXED) {
> > > 
> > > is false - because mv88e6xxx_port_ppu_updates() returns true, and
> > > consequently we never undo this force-down.
> > 
> > We know that
> > 1. A == mv88e6xxx_phy_is_internal(ds, port), B == mv88e6xxx_port_ppu_updates(chip, port), C == mode == MLO_AN_FIXED
> > 2. (!A && !B) || C == false. This is due to the effect we observe: link is not forced up
> > 2. C == false. This is due to the device tree.
> > 3. !A && !B == false. This is due to statement (2), plus the rule that if X || Y == false and Y == false, then X must also be false.
> > 4. We know that A is true, again due to device tree: port 4 < .num_internal_phys for MV88E6240 which is 5.
> > 5. !A is false, due to 4.
> > 
> > So we have:
> > 
> > false && !B == false.
> > 
> > Therefore "!B" is "don't care". In other words we don't know whether
> > mv88e6xxx_port_ppu_updates() is true or not.
> 
> With a bit of knowledge of how Marvell DSA switches work...
> 
> The "ppu" is the PHY polling unit. When the switch comes out of reset,
> the PPU probes the MDIO bus, and sets the bit in the port status
> register depending on whether it detects a PHY at the port address by
> way of the PHY ID values. This bit is used to enable polling of the
> PHY and is what mv88e6xxx_port_ppu_updates() reports. This bit will be
> set for all internal PHYs unless we explicitly turn it off (we don't.)
> Therefore, this is a reasonable assumption to make.
> 
> So, given that mv88e6xxx_port_ppu_updates() is most likely true as
> I stated, it is also true that mv88e6xxx_phy_is_internal() is
> "don't care".

And the reason why you bring the PPU into the discussion is because?
If the issue manifests itself with or without it, and you come up with a
proposal to set LINK_UNFORCED in mv88e6xxx_mac_config if the PPU is
used, doesn't that, logically speaking, still leave the issue unsolved
if the PPU is _not_ used for whatever reason?
The bug has nothing to do with the PPU. It can be solved by checking for
PPU in-band status as you say. Maybe. But I've got no idea why we don't
address the elephant in the room, which is in dsa_port_link_register_of()?
