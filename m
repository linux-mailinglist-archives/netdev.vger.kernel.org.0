Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BE231B02D
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 12:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhBNLK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 06:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhBNLK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 06:10:58 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60F2C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 03:10:17 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id l12so4910651edt.3
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 03:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OqHLoWEFtOhsddx1lsykVyu45/1co5LOTjHjQtE/VfU=;
        b=YBILQTJw9xV/cwPiFe8UT4HmMH/AoIGxGI8ybZO5Dq7GZvaSw8550vezBh2FFqY4Gi
         fmywNKDKCTY0fv7YQIQjUa0abOykbwhDJ8xGcus9j914OqDTMLtuLrQNr4PVZcg+tFd6
         HfMVDjTSB9vwZsO/KAx8aAl09gPiYWC3u1O9WqzDZ/sdOg0pn1ibl+FSXxqF5/4m6XOt
         rJC6QBgyJ4fCcYHvsCNfCsCru/o3JyhdJPHv4MxTHnx8j/lvXTv9BmuIOyX2Neq2gv+W
         ALuNg23WyU0sq1+op4iiIai9aTvynVb9csICjdtxHMu2e8vSn5KDF6Res2CSyaCW10um
         EzPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OqHLoWEFtOhsddx1lsykVyu45/1co5LOTjHjQtE/VfU=;
        b=UhrneYyVX/0w25vGXAdr13QI8UxmU8Weyfh6wGlVNJtsnGIYHkWocNXNo7mfvYrvcx
         rdY8PXOUe6knybpgJ4AwashkUOXNgFhpO1wzcfTe5BZPvmnzflM65J8nNoHwMLPZL9Lz
         uWNCUeg4WRo82A0fSReTnYxrxuSKRCNsi7sIz2vhJ8Y47qNv89pV+GvEDySZEms0a2Nv
         1pGnL9obYmB7a1lpo6iBqdxAPANSD0jCKf0YNdQsntGj0uTmCse2jI+WONGbfaYluqha
         aQnlZM9lp7Lb2LJtlAKJZQOHlyPz09Gfq8JsNZZBocywnOk6rKr4uu1wzFViaHr7ZnqH
         jQzg==
X-Gm-Message-State: AOAM530LGiBTqlBgvYstJXBsc3Y1KbO5eNen2k1xwU2Ab+UYvfIR4tzc
        VIZ00omwTzoZRwWmG5Wd5Do=
X-Google-Smtp-Source: ABdhPJw9+coMd7p6LzcE8i9+2wAspwNDnwrQZGpBe0hPUTplbkwKpdX2NJxLEs6CpPcRWopyJhnE+A==
X-Received: by 2002:a05:6402:1118:: with SMTP id u24mr11182914edv.386.1613301016172;
        Sun, 14 Feb 2021 03:10:16 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id r23sm8832690ejd.56.2021.02.14.03.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 03:10:15 -0800 (PST)
Date:   Sun, 14 Feb 2021 13:10:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
Message-ID: <20210214111014.edr7uqezqdzrrr7w@skbuf>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <20210214103529.GT1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210214103529.GT1463@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 10:35:29AM +0000, Russell King - ARM Linux admin wrote:
> > +	if (ret && ret != -EOPNOTSUPP) {
> > +		phylink_warn(pl, "failed to configure PHY in-band autoneg: %d\n",
> > +			     ret);
> 
> Please use %pe and ERR_PTR(ret) so we can get a symbolic errno value.

I didn't know that was possible, thanks for the hint.

> As mentioned in this thread, we have at least one PHY which is unable
> to provide the inband signalling in any mode (BCM84881). Currently,
> phylink detects this PHY on a SFP (in phylink_phy_no_inband()) and
> adjusts not to use inband mode. This would need to be addressed if we
> are creating an alterative way to discover whether the PHY supports
> inband mode or not.

So I haven't studied the SFP code path too deeply, but I think part of
the issue is the order in which things are done. It's almost as if there
should be a validation phase for PHY inband abilities too.

phylink_sfp_connect_phy
-> phylink_sfp_config:
   -> first this checks if phylink_phy_no_inband
   -> then this changes pl->link_config.interface and pl->cur_link_an_mode
-> phylink_bringup_phy:
   -> this is where I'm adding the new phy_config_inband_aneg function

If we were to use only my phy_config_inband_aneg function, it would need
to be moved upwards in the code path, to be precise where phylink_phy_no_inband
currently is. Then we'd have to try MLO_AN_INBAND first, with a fallback
to MLO_AN_PHY if that fails. I think this would unnecessarily complicate
the code.

Alternatively, I could create a second PHY driver method, simply for
validation of supported inband modes. The validation can be done in
place of the current phylink_phy_noinband(), and I can still have the
phy_config_inband_aneg() where I put it now, since we shouldn't have any
surprises w.r.t. supported operating mode, and there should be no reason
to repeat the attempt as there would be with a single PHY driver method.
Thoughts?

> Also, there needs to be consideration of PHYs that dynamically change
> their interface type, and whether they support inband signalling.
> For example, a PHY may support a mode where it dynamically selects
> between 10GBASE-R, 5GBASE-R, 2500BASE-X and SGMII, where the SGMII
> mode may have inband signalling enabled or disabled. This is not a
> theoretical case; we have a PHY like that supported in the kernel and
> boards use it. What would the semantics of your new call be for a PHY
> that performs this?
> 
> Should we also have a phydev->inband tristate, taking values "unknown,
> enabled, disabled" which the PHY driver is required to update in their
> read_status callback if they dynamically change their interface type?
> (Although then phylink will need to figure out how to deal with that.)

I don't have such PHY to test with, but I think the easiest way would be
to just call the validation method again, after we change the
phydev->interface value. The PHY driver can easily take phydev->interface
into consideration when answering the question "is inband aneg supported
or not". I don't think that making phydev->inband a stateful value is
going to be as useful as making it a function, since as you say, we will
be required to keep it up to date from generic PHY driver methods, but
only phylink will use it.
