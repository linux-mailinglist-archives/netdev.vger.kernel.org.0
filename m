Return-Path: <netdev+bounces-7442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD3B7204C6
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A1FA1C20B26
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E316217748;
	Fri,  2 Jun 2023 14:44:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D823D258F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:44:16 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8DCE40
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TzEFG9VUzalqvzjJM83RdiA6mmFlFJwQ+b4SCk+h1ak=; b=unG9KSAozuIlnbedAt9r8sWkoN
	8n+j1fqMyHMNXn7RA1ezfmWHKn2qe5ElC4ocNWJSmCkpxwdn0Ns9C9z3XAoAAGrfOE6DAnlf2/fss
	+hgfktwuERd09qT3k3yQm/mDi+sdrCwSpZg4TRcOgsa413loIDOR0D6nzZkhUedkCwEsrqK4Q1xPF
	UH8OEHztdrFk57gsNcZOUlLT29T03XrZrelT0O2egkMXrg8JWshhsofqgjmi4LPpjaHR+ETh8Sf4u
	/eDou3rKRD4zWDGv1jY80BXtN8dDvsD/3M7BBKiHdwx8kxzAf5/MOPke9W3m6aB0YqdWAD3N2OgVo
	NpoVZbww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58352)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q560f-00089N-9J; Fri, 02 Jun 2023 15:44:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q560c-00032I-U1; Fri, 02 Jun 2023 15:44:06 +0100
Date: Fri, 2 Jun 2023 15:44:06 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Vladimir Oltean <olteanv@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/3] net: dsa: sja1105: allow XPCS to handle
 mdiodev lifetime
Message-ID: <ZHoANo3QkjLC9xoq@shell.armlinux.org.uk>
References: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
 <E1q55IZ-00Bp4w-6V@rmk-PC.armlinux.org.uk>
 <20230602143020.w7czsg5ldqpkqhep@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602143020.w7czsg5ldqpkqhep@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 05:30:20PM +0300, Vladimir Oltean wrote:
> On Fri, Jun 02, 2023 at 02:58:35PM +0100, Russell King (Oracle) wrote:
> > Put the mdiodev after xpcs_create() so that the XPCS driver can manage
> > the lifetime of the mdiodev its using.
> 
> nitpick: "it's using"
> 
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/dsa/sja1105/sja1105_mdio.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
> > index 01f1cb719042..166fe747f70a 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_mdio.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
> > @@ -417,6 +417,7 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
> >  		}
> >  
> >  		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
> > +		mdio_device_put(mdiodev);
> >  		if (IS_ERR(xpcs)) {
> >  			rc = PTR_ERR(xpcs);
> >  			goto out_pcs_free;
> > @@ -434,7 +435,6 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
> >  		if (!priv->xpcs[port])
> >  			continue;
> >  
> > -		mdio_device_free(priv->xpcs[port]->mdiodev);
> >  		xpcs_destroy(priv->xpcs[port]);
> >  		priv->xpcs[port] = NULL;
> >  	}
> > @@ -457,7 +457,6 @@ static void sja1105_mdiobus_pcs_unregister(struct sja1105_private *priv)
> >  		if (!priv->xpcs[port])
> >  			continue;
> >  
> > -		mdio_device_free(priv->xpcs[port]->mdiodev);
> >  		xpcs_destroy(priv->xpcs[port]);
> >  		priv->xpcs[port] = NULL;
> >  	}
> > -- 
> > 2.30.2
> > 
> 
> So before this patch, sja1105 was using xpcs with an mdiodev refcount
> of 2 (a transition phase after commit 9a5d500cffdb ("net: pcs: xpcs: add
> xpcs_create_mdiodev()")), and now it's back to using it with a refcount
> of 1? okay.

Absolutely correct, but the key thing is the owners of the refcount(s)
on the object have changed.

> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

