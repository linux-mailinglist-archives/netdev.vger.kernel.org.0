Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB471398B53
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 16:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFBOEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 10:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhFBOEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 10:04:20 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2563DC061574
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 07:02:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id c10so3982801eja.11
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 07:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=foNbLT24R0gQucihiHmItQCgRZ5dWvIDD2Zm50oJuTo=;
        b=U4FmiJn/Xyt9u4dpZtKTLHngxscXRmox3h6xWkwRqZBAAwLiu5ab4awcIetu87LOIV
         4z3pJ3z+VO/wrtOXidRsJwnJlK17WywWgV6YoWqpMeBsSRQps8ZOetQ9KpoI8btuGtYq
         z3bjnKuyWVQjH3N29Q61tDyf+V2FHre2/HBN6MqN3PA/JMu6tGPri79uv5PC0MzHRCoJ
         Rc6xeI/Ukv9BR8vPlww4mMTJhtKDR63K/oMnW8pBrONB28aNnW27+nfHQtb3GUI5MNAU
         uFSgxbZqeoNt2YFi/b526FxQWS/u5+Duf0YE8CnBetsAr80lc1e4cF25QF/7REJKCUp1
         v14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=foNbLT24R0gQucihiHmItQCgRZ5dWvIDD2Zm50oJuTo=;
        b=ptQI2Kod5iszinnuHK+pqhKGS1Bb51KIyT0MXbzgi7JdILm9FmEOI5QHF1XaLJ/eV7
         8PXv4J858JzMHNZ/lDxn4yc2sAUfkUJShZf8/1tUBWwv1gQYxGGKFtwZvg4rMs9CU8de
         9AfwgCLWKTRCOkJiU9Ebax4jTqlWiARYEMnX+rCPBKMOH+BEu1C+8zEscqIhcwMpWfjt
         Hzi36qn9RnAleGmIxuuzTTKm8nA+HUPivVBtT32UHF2YOUqEEwEJ9B7f42+SEmRjVmjd
         wV6TpUSyA7hprXVc37bhCD2+H5smCDPgysncg8LXo5dlmECzkuEyaGPQeeCwX07UcU1G
         ZSIQ==
X-Gm-Message-State: AOAM530CK9qyGSuR3JFzE9wn3k39BeddpeyDoNNrpvL6K+N8HwwtNSQW
        RZNsaxe8Vu3mBIQxtMr6ZoS36jpe/Mw=
X-Google-Smtp-Source: ABdhPJwl2kXuZNWpBq53I6Yts1FHD3V0EchcuFHn582GPvBxo/dOtisdwjFimyybtrW2UUA9iLjGpA==
X-Received: by 2002:a17:906:c1ca:: with SMTP id bw10mr35137921ejb.512.1622642554745;
        Wed, 02 Jun 2021 07:02:34 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di16sm5302edb.62.2021.06.02.07.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 07:02:34 -0700 (PDT)
Date:   Wed, 2 Jun 2021 17:02:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 9/9] net: pcs: xpcs: convert to
 phylink_pcs_ops
Message-ID: <20210602140233.3zk6mtr7turmza2r@skbuf>
References: <20210601003325.1631980-1-olteanv@gmail.com>
 <20210601003325.1631980-10-olteanv@gmail.com>
 <20210601121032.GV30436@shell.armlinux.org.uk>
 <20210602134321.ppvusilvmmybodtx@skbuf>
 <20210602134749.GL30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602134749.GL30436@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 02:47:49PM +0100, Russell King (Oracle) wrote:
> On Wed, Jun 02, 2021 at 04:43:21PM +0300, Vladimir Oltean wrote:
> > On Tue, Jun 01, 2021 at 01:10:33PM +0100, Russell King (Oracle) wrote:
> > > On Tue, Jun 01, 2021 at 03:33:25AM +0300, Vladimir Oltean wrote:
> > > >  static const struct phylink_mac_ops stmmac_phylink_mac_ops = {
> > > >  	.validate = stmmac_validate,
> > > > -	.mac_pcs_get_state = stmmac_mac_pcs_get_state,
> > > > -	.mac_config = stmmac_mac_config,
> > > 
> > > mac_config is still a required function.
> > 
> > This is correct, thanks.
> > 
> > VK, would you mind testing again with this extra patch added to the mix?
> > If it works, I will add it to the series in v3, ordered properly.
> > 
> > -----------------------------[ cut here]-----------------------------
> > From a79863027998451c73d5bbfaf1b77cf6097a110c Mon Sep 17 00:00:00 2001
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Date: Wed, 2 Jun 2021 16:35:55 +0300
> > Subject: [PATCH] net: phylink: allow the mac_config method to be missing if
> >  pcs_ops are provided
> > 
> > The pcs_config method from struct phylink_pcs_ops does everything that
> > the mac_config method from struct phylink_mac_ops used to do in the
> > legacy approach of driving a MAC PCS. So allow drivers to not implement
> > the mac_config method if there is nothing to do. Keep the method
> > required for setups that do not provide pcs_ops.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/phy/phylink.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 96d8e88b4e46..a8842c6ce3a2 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -415,6 +415,9 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
> >  static void phylink_mac_config(struct phylink *pl,
> >  			       const struct phylink_link_state *state)
> >  {
> > +	if (!pl->mac_ops->mac_config)
> > +		return;
> > +
> >  	phylink_dbg(pl,
> >  		    "%s: mode=%s/%s/%s/%s adv=%*pb pause=%02x link=%u an=%u\n",
> >  		    __func__, phylink_an_mode_str(pl->cur_link_an_mode),
> > @@ -1192,6 +1195,12 @@ void phylink_start(struct phylink *pl)
> >  
> >  	ASSERT_RTNL();
> >  
> > +	/* The mac_ops::mac_config method may be absent only if the
> > +	 * pcs_ops are present.
> > +	 */
> > +	if (WARN_ON_ONCE(!pl->mac_ops->mac_config && !pl->pcs_ops))
> > +		return;
> > +
> >  	phylink_info(pl, "configuring for %s/%s link mode\n",
> >  		     phylink_an_mode_str(pl->cur_link_an_mode),
> >  		     phy_modes(pl->link_config.interface));
> 
> I would rather we didn't do that - I suspect your case is not the
> common scenario, so please add a dummy function to stmmac instead.

Ok, in that case the only delta to be applied should be:

-----------------------------[ cut here]-----------------------------
From 998569108392befc591f790e46fe5dcd1d0b6278 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 2 Jun 2021 17:00:12 +0300
Subject: [PATCH] fixup! net: pcs: xpcs: convert to phylink_pcs_ops

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d5685a74f3b7..704aa91b145a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1000,6 +1000,12 @@ static void stmmac_validate(struct phylink_config *config,
 		xpcs_validate(priv->hw->xpcs, supported, state);
 }
 
+static void stmmac_mac_config(struct phylink_config *config, unsigned int mode,
+			      const struct phylink_link_state *state)
+{
+	/* Nothing to do, xpcs_config() handles everything */
+}
+
 static void stmmac_fpe_link_state_handle(struct stmmac_priv *priv, bool is_up)
 {
 	struct stmmac_fpe_cfg *fpe_cfg = priv->plat->fpe_cfg;
-----------------------------[ cut here]-----------------------------
