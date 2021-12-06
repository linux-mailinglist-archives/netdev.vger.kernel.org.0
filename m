Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B9646A676
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245559AbhLFUEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343591AbhLFUEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:04:43 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB34C061359
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 12:01:14 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id l25so47492930eda.11
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 12:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eb64jXo0phB9enT8aZUE2HHRZjBuIRYgZwzlPHXBFVA=;
        b=g9b0PEsJxS0jeQmCGThJ0WuLs1fPtbvO17lT+Oxmub5nLr5wA1qVxMJp4TwqPAvXlw
         YdHh+uELBD8ysy5GEtc2ow9XmoysR0NW3PsD4qXR7y7NNZraTTS2a0Ri0a8puH3frfv3
         1xyzLKDHPfyYVCpN5Bex9sDNCH6wQ8tHXhWc8DHyVeRyVVbyQNUg1YG2h9JM/6S/4aX4
         2LOQ+7rxmveiYBPwtR1AQSMzf0fzSRkj95e+Ip2eL/B+Pkcnxg1PUjc+aXgPA6kmXlHI
         VUkeEQUEVKm2y7ZbcDRL+3YkbAvc/I2xnBnVB1LPW+UOIM1xMBykVQLuZdIsI5Fjctb9
         BUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eb64jXo0phB9enT8aZUE2HHRZjBuIRYgZwzlPHXBFVA=;
        b=KpYaT+R4GmO2xYwOHEcXnGUoIrioFzxl4+YFcT5O1aWnr2YoiQ7LfUKsQzAX7SQQje
         ffLd6wsn70tyjfx7TIyIe5yFMAJ7up8CYh58ZCOuOfoyv//Z9OElqc9MWSjCQI3OA/ZB
         2VffIBv/H7RRnYEtsOYmzIlVKvPtlEfPEkMhvV6qmqLNttBHJV383bVc5onOZXqhgoMZ
         aYgCRUv1X7zIvXuiTYP/seA+bMIf1HAtHJFbZck4sOmUw6Qg6huP/9j02NYfBhXi39uQ
         1o3r374sW1XTOl/SHzF9Jq3LHDc4/YvMqrR825AM/yuBqA0AabClQ3O4DG07Xzn3BD65
         taHw==
X-Gm-Message-State: AOAM530NY7oSDHB5yWBHYJolQFccSIScMUZtmdK3rcIhBag6oHWD6UEL
        VEUS2X8UBs6QGgEmc3R2VdN8ZiSLL8c=
X-Google-Smtp-Source: ABdhPJzdXa4B4x3OnwurV4ntCknevW9ebmpBpvtdzM5SqNc1tSOJgYLR9sfcduUpaCI5kIoZuAHmMg==
X-Received: by 2002:a05:6402:440f:: with SMTP id y15mr1934285eda.22.1638820872692;
        Mon, 06 Dec 2021 12:01:12 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id o8sm9137523edc.25.2021.12.06.12.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:01:12 -0800 (PST)
Date:   Mon, 6 Dec 2021 22:01:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <20211206200111.3n4mtfz25fglhw4y@skbuf>
References: <b98043f66e8c6f1fd75d11af7b28c55018c58d79.camel@collabora.com>
 <YapE3I0K4s1Vzs3w@lunn.ch>
 <b0643124f372db5e579b11237b65336430a71474.camel@collabora.com>
 <fb6370266a71fdd855d6cf4d147780e0f9e1f5e4.camel@collabora.com>
 <20211206183147.km7nxcsadtdenfnp@skbuf>
 <339f76b66c063d5d3bed5c6827c44307da2e5b9f.camel@collabora.com>
 <20211206185008.7ei67jborz7tx5va@skbuf>
 <3d6c6226e47374cf92d604bc6c711e59d76e3175.camel@collabora.com>
 <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5qSoNhJRiSif/U@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ya5qSoNhJRiSif/U@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 08:53:46PM +0100, Andrew Lunn wrote:
> > > > Just out of curiosity, can you try this change? It looks like a
> > > > simple
> > > > case of mismatched conditions inside the mv88e6xxx driver between
> > > > what
> > > > is supposed to force the link down and what is supposed to force it
> > > > up:
> > > > 
> > > > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > > > index 20f183213cbc..d235270babf7 100644
> > > > --- a/net/dsa/port.c
> > > > +++ b/net/dsa/port.c
> > > > @@ -1221,7 +1221,7 @@ int dsa_port_link_register_of(struct dsa_port
> > > > *dp)
> > > >                 if (of_phy_is_fixed_link(dp->dn) || phy_np) {
> > > >                         if (ds->ops->phylink_mac_link_down)
> > > >                                 ds->ops->phylink_mac_link_down(ds, port,
> > > > -                                       MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
> > > > +                                       MLO_AN_PHY, PHY_INTERFACE_MODE_NA);
> > > >                         return dsa_port_phylink_register(dp);
> > > >                 }
> > > >                 return 0;
> > > 
> > > Yes, that appears to also make it work.
> > > 
> > > Martyn
> > 
> > Well, I just pointed out what the problem is, I don't know how to solve
> > it, honest! :)
> > 
> > It's clear that the code is wrong, because it's in an "if" block that
> > checks for "of_phy_is_fixed_link(dp->dn) || phy_np" but then it omits
> > the "phy_np" part of it. On the other hand we can't just go ahead and
> > say "if (phy_np) mode = MLO_AN_PHY; else mode = MLO_AN_FIXED;" because
> > MLO_AN_INBAND is also a valid option that we may be omitting. So we'd
> > have to duplicate part of the logic from phylink_parse_mode(), which
> > does not appear ideal at all. What would be ideal is if this fabricated
> > phylink call would not be done at all, but I don't know enough about the
> > systems that need it, I expect Andrew knows more.
> 
> phylink assumes interfaces start in the down state. It will then
> configure them and bring them up as needed. This is not always true
> with mv88e6xxx, the interface can already by up, and then the hardware
> and phylink have different state information. So this call was added
> to force the link down before phylink took control of it.
> 
> So i suspect something is missing when phylink sometime later does
> bring the interface up. It is not fully undoing what this down
> does. Maybe enable the dev_dbg() in mv88e6xxx_port_set_link() and see
> what value it has in both the good and bad case?

Andrew, here is mv88e6xxx_mac_link_down():

	if (((!mv88e6xxx_phy_is_internal(ds, port) &&
	      !mv88e6xxx_port_ppu_updates(chip, port)) ||
	     mode == MLO_AN_FIXED) && ops->port_sync_link)
		err = ops->port_sync_link(chip, port, mode, false);

and here is mv88e6xxx_mac_link_up():

	if ((!mv88e6xxx_phy_is_internal(ds, port) &&
	     !mv88e6xxx_port_ppu_updates(chip, port)) ||
	    mode == MLO_AN_FIXED) {
		(...)
		if (ops->port_sync_link)
			err = ops->port_sync_link(chip, port, mode, true);

This is the CPU port from Martyn's device tree:

	port@4 {
		reg = <4>;
		label = "cpu";
		ethernet = <&switch_nic>;
		phy-handle = <&switchphy4>;
	};

It has an internal PHY, so mv88e6xxx_phy_is_internal() will return true.
True negated is false, so the AND with the other PPU condition is always
false. BUT: the logic is: "force the link IF it doesn't have an internal
PHY OR it is a fixed link".

DSA fabricates a mv88e6xxx_mac_link_down call with MLO_AN_FIXED. So
->port_sync_link is called with false even if the PHY is internal, due
to the right hand operand to the || operator.

Then the real phylink, not the impersonator, comes along and calls
mv88e6xxx_mac_link_up with MLO_AN_PHY. The same check is now not
satisfied, because the input data has changed!

If we're going to impersonate phylink we could at least provide the same
arguments as phylink will.
