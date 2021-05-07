Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4160C376D7E
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 01:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhEGXwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 19:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhEGXwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 19:52:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEB7C061574;
        Fri,  7 May 2021 16:51:30 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n84so6112075wma.0;
        Fri, 07 May 2021 16:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7lVXSAj+hX9zk03LgsIMs6yxVeKScziSr3n1M5BEuEM=;
        b=fd6Ip474EzPy06x9xC7FQfUxwtoPdS5GcI1iW9MG82HHsr45tEFa2mcE1O6KA+QOjS
         EujZ663a1HZYUL6eKTGaVzCZuhsR63zkFgQv535s7Eubkzz7SsN8+ecigD9lnbhBOthR
         WyyHqFlI+AwdqeN+jRxCooJoqdiMuKTdNXsVgVKzhpGa9hMMiZF2LQAXSbUKjj35h6Lz
         ibmHUK5PNMgceYS7LXPnPqJy10UJ7pIoXUQAKkJ3WYN8m+tpdwurbuua7U6VZeaVoS8T
         M4bELm4vP+B1V8oe3L7vJPwN9XeLO6h3a0aFksXgif7OU657Lfeg85r6htSQgSYmkwzZ
         ZSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7lVXSAj+hX9zk03LgsIMs6yxVeKScziSr3n1M5BEuEM=;
        b=UX4ysbJJIc+/2ordNjo47s2F/fGdrHvlsR8w7EfD1y7iJ8cMf8/k4RnCpQ1x86wv/5
         Rh3YAz6Xk8mOEG6ERgDrOd4lmEAUeJjhfSMx4LpVhposeXa8H+5xBF1aRNVJBytE4NlM
         9CxuMWoIpZTWUqQjTORwnsb0dMZ8/VIzUcsD5Qc4kzlNE3kXkdm1I1eM4/FXN1jQofmS
         s2aRa5el7wHD4V8Pg0WESb75L2le2f8TIsCohHLnK26M+LZd/dGT48Iw35jSeMajmlT/
         r6gDiafpRWby5g9w8inyXYS+g1YO6Dym7A5TYjD6has5kUNIfrQn5QWL7bDebxpWX9/o
         pxuQ==
X-Gm-Message-State: AOAM532aUi47GQKWzt8kg2hKtaMB+L+YMBCtmyQRlOP1V+kcFD+17rBx
        EGxUGwTuA1cNX2XPe7r+C84=
X-Google-Smtp-Source: ABdhPJzCvy+qKlCAdbxyYkwUhERvLwURHe5/XDYNzuaonjsAoez/t15MmbPW3t/9vLrMycxHCWAOeA==
X-Received: by 2002:a05:600c:4fd0:: with SMTP id o16mr23967215wmq.137.1620431488695;
        Fri, 07 May 2021 16:51:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.gmail.com with ESMTPSA id i13sm9805712wrs.12.2021.05.07.16.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 16:51:28 -0700 (PDT)
Date:   Sat, 8 May 2021 01:51:08 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
Message-ID: <YJXSbGzL040gnugV@Ansuel-xps.localdomain>
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

The problem here was find a way to pass data from the dsa driver to the
phy driver. In this specific case the phy driver is an internal phy
present in the switch so it won't appear on anything else. Aside from
this I agree that it seems wrong that random values are used without
some type of rules or definition but I think that try to address this
problem is too much for this already large series. In theory this should
be safe to use as this driver would only be used by qca8k dsa driver.

> As I mentioned in direct reply to your patch, there was discussions
> about this back in February, but they seem to have stalled.
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
