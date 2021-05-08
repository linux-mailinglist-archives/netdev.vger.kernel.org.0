Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D332637739F
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhEHS10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhEHS1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 14:27:25 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C31C061574;
        Sat,  8 May 2021 11:26:23 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g65so6922628wmg.2;
        Sat, 08 May 2021 11:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ne8aH4/eXbpZtGpkIYMFMh7EBbFTZc1EdyyVLUni2P8=;
        b=lQasIBeB2/SBHovuOv7uzAeZSCUPmizTKL8pY7gC5N5SmMgpy197pwSwXGxnYdg9v/
         jmE5L6cSGAypb3LeuZs24SM2hYFOhjei/zhNduHh8Ilv7j9EWaCuye0MUpQXkqzGLvFN
         EquE65Bel1INpEW5lGwo5FGRwGl8AdT7PvM5f6c4xRiMYvFMV8mJaW8BoT2JLOeImV/C
         jW1VuJWw3owfSfrGvoEf4Omk1vRk/dUihpdZwsU82G8W31N2jthAuda6et1ilcowZRKa
         SpHFuUrEyj5bAKRe7WFuhAp6N/a0GSvEUT4yH6lHmdT7BeWHTdJEN3KsW3l/ktsJCpMo
         JOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ne8aH4/eXbpZtGpkIYMFMh7EBbFTZc1EdyyVLUni2P8=;
        b=dhuk/dU8NrMhDWE2X8DRorf0rC5dYRgA06tm72/OMWerwtOD+s9fq/ty8/Tp41cA5X
         eRn+otELZWX37b4qf+Cvw3Qh5L1MiG/4FTVoD655bTVbfKPQ9XuBrFmJdF2YEN6icliS
         8/vl05977O4+5Ki89MLRnuxKxz5Or1PkT1VOrdSJ2/tZUDTSL0Www4GkRiZOuy5eF2T8
         opNWb2Vr1R1HXT1fDC6HfBA5dlmHejNIpzC31/0khQjS4KUsYQvGnPIRGhHFCfkPzzlg
         0fJUdfKaij40yGfkqOWSqKfYh4OGWMHQJPI/UIxX5emIGypOHYMU5hCAgYwt6TgheFmu
         fTMA==
X-Gm-Message-State: AOAM5336/vk/rZ7eFnlk7vxE+cr5Csus7C7CIaO7mqV8K63f7nv6Vtyc
        zEa/fAnEtyZSedx7NujRnlwqqr6qz4I=
X-Google-Smtp-Source: ABdhPJw1zD8w/eIaQ/iba8WMijTswsdUTxDT3mehqlLPwIc8nW4DC0mnq/+4Amu4HaFCkarVrD/7Uw==
X-Received: by 2002:a7b:c006:: with SMTP id c6mr16817178wmb.129.1620498382172;
        Sat, 08 May 2021 11:26:22 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id p1sm6839126wrs.50.2021.05.08.11.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 11:26:21 -0700 (PDT)
Date:   Sat, 8 May 2021 21:26:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
Message-ID: <20210508182620.vmzjvmqhexutj7p3@skbuf>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-19-ansuelsmth@gmail.com>
 <20210506112458.yhgbpifebusc2eal@skbuf>
 <YJXMit3YfBXKM98j@Ansuel-xps.localdomain>
 <20210507233353.GE1336@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507233353.GE1336@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 12:33:53AM +0100, Russell King - ARM Linux admin wrote:
> On Sat, May 08, 2021 at 01:26:02AM +0200, Ansuel Smith wrote:
> > On Thu, May 06, 2021 at 02:24:58PM +0300, Vladimir Oltean wrote:
> > > On Wed, May 05, 2021 at 12:29:13AM +0200, Ansuel Smith wrote:
> > > > Define get_phy_flags to pass switch_Revision needed to tweak the
> > > > internal PHY with debug values based on the revision.
> > > > 
> > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > ---
> > > >  drivers/net/dsa/qca8k.c | 19 +++++++++++++++++++
> > > >  1 file changed, 19 insertions(+)
> > > > 
> > > > diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> > > > index b4cd891ad35d..237e09bb1425 100644
> > > > --- a/drivers/net/dsa/qca8k.c
> > > > +++ b/drivers/net/dsa/qca8k.c
> > > > @@ -1654,6 +1654,24 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
> > > >  	return ret;
> > > >  }
> > > >  
> > > > +static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
> > > > +{
> > > > +	struct qca8k_priv *priv = ds->priv;
> > > > +
> > > > +	pr_info("revision from phy %d", priv->switch_revision);
> > > 
> > > Log spam.
> > > 
> > > > +	/* Communicate to the phy internal driver the switch revision.
> > > > +	 * Based on the switch revision different values needs to be
> > > > +	 * set to the dbg and mmd reg on the phy.
> > > > +	 * The first 2 bit are used to communicate the switch revision
> > > > +	 * to the phy driver.
> > > > +	 */
> > > > +	if (port > 0 && port < 6)
> > > > +		return priv->switch_revision;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  static enum dsa_tag_protocol
> > > >  qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
> > > >  		       enum dsa_tag_protocol mp)
> > > > @@ -1687,6 +1705,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
> > > >  	.phylink_mac_config	= qca8k_phylink_mac_config,
> > > >  	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
> > > >  	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
> > > > +	.get_phy_flags		= qca8k_get_phy_flags,
> > > >  };
> > > >  
> > > >  static int qca8k_read_switch_id(struct qca8k_priv *priv)
> > > > -- 
> > > > 2.30.2
> > > > 
> > > 
> > > Florian, I think at one point you said that a correct user of
> > > phydev->dev_flags should first check the PHY revision and not apply
> > > dev_flags in blind, since they are namespaced to each PHY driver?
> > > It sounds a bit circular to pass the PHY revision to the PHY through
> > > phydev->dev_flags, either that or I'm missing some piece.
> > 
> > Just to make sure. This is the SWITCH revision not the PHY revision. It
> > was pointed out in old version that I should get this value from the PHY
> > regs but they are different values. This is why the dsa driver needs to
> > use the dev_flags to pass the SWITCH revision to the phy driver. Am I
> > implementing this in the wrong way and I should declare something to
> > pass this value in a more standard way? (anyway i'm pushing v4 so i
> > don't know if we should continue that there)
> 
> Vladimir is confused - it is not PHY revision at all, but the PHY
> identifiers.
> 
> What was actually suggested was checking the PHY identifiers before
> passing PHY-driver specific flags, so that we didn't end up setting
> driver private flags that are intending for one driver, but end up
> actually binding a different driver, and mis-interpreting the flags.
> 
> This is one of the problems of the current scheme: it's just a
> meaningless opaque u32 variable with no defined structure to it that
> the various PHY drivers themselves use in whatever way they see fit.
> That is only fine to use _if_ you know for certain which driver is
> going to bind ahead of time.
> 
> As I mentioned in direct reply to your patch, there was discussions
> about this back in February, but they seem to have stalled.

Yes, I was indeed confused. My problem was mixing up the PHY OUI/device ID
and revision concepts in one big fuzzy notion. I remembered Heiner's
suggestion to do something similar to mv88e6xxx_mdio_read from here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210423014741.11858-12-ansuelsmth@gmail.com/
(where the problem is that some internal PHYs are lacking a device
identifier) and thought that the problem here is the same.

Nonetheless, now it is clear to me that with care (don't set dev_flags
except for internal PHYs which are statically known), it is possible for
the PHY driver to have a larger identifier (PHY ID concatenated with
switch revision passed through dev_flags) based on which it can
configure the hardware.

Sorry.
