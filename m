Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA7C3E4463
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 13:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhHILGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 07:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbhHILGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 07:06:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2535C0613D3;
        Mon,  9 Aug 2021 04:06:29 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id cf5so23936337edb.2;
        Mon, 09 Aug 2021 04:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rqeeHdFchIP+lwGA3HCPDFYMIAiS+hDBXIwLFpK/6FQ=;
        b=LysAVhcZN4VamA6w0Bt5EA0pSwuLmjl6mFBc/WjwCp/VqGiUwNjWfZf+MhmKZtOETw
         NXGKJAz5m9eVz6OiSPVACZT+rT+XxT9zEdF0EriCtD5gm4a7GEetlFWQzj6UN3PMeWhh
         l1IyPQJ3D/iQnXzP1kKr0QKGoRrvNXSD5HbPlxM7xaLiVVRvzguIV7MJbEJihqnXezPW
         o1FIsieBqIKuaJR/QkjKApmwu3qm69u5ETCRQEs5TTE9ynCckJn9tr2guVVeNzIj43sy
         uBlbv947wJyiIOT6HeEehYqivl79V7Fj1IkWNV5LeGz6N9ZG91KxXwIfspe8YayhpTht
         giUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rqeeHdFchIP+lwGA3HCPDFYMIAiS+hDBXIwLFpK/6FQ=;
        b=W/OEE6ZlJX5p7OSwRIEyWsUDjMikChUR+77Uec6BC+eYYkM8zbS7b2XLHrcaQ+8Gl5
         BSNzk0rIwpqSAjEmxIENkdLBTvWF+NWKXoC84NN2AqQCMxFXVZycUunruAa4dqvzXePD
         zG9RSivircYc63J2K0i7lfPFT4ltoje1ib7WFeRGvwVenxTb0A+eWxqOw9y24X492qwN
         Ro/73/Vs4dMH6DlYjnMzjNqhy/5BuJm1tk2TDSHgTJ+te7MGeT6zjBcBQ1f+g24WNHpB
         tVldWUbOq8RKtUGniNEm/0rGpQkkRaWhvXfBNug7x5unZezYn+izKUjVsXkFxPTkVhHp
         ilOw==
X-Gm-Message-State: AOAM530mLWHU/742ffs49BNnTnbTOtZ5ezU8Nt/AUcWsnjbnpxsSjrN3
        CHC1n7rHKOYjqZg7sPrCMH4=
X-Google-Smtp-Source: ABdhPJyH0j2dqKqb+c+DaZqSChnn1pBcE8AI4Vi7lk9pC1/kUS7xkWpuQsFpG0Z1NuGIataB+B6pYg==
X-Received: by 2002:a50:fc96:: with SMTP id f22mr6964806edq.367.1628507188420;
        Mon, 09 Aug 2021 04:06:28 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id y23sm5794648ejp.115.2021.08.09.04.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 04:06:28 -0700 (PDT)
Date:   Mon, 9 Aug 2021 14:06:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: enable skip xPCS soft reset
Message-ID: <20210809110626.4kfkegwixiualq2x@skbuf>
References: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
 <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi VK,

On Mon, Aug 09, 2021 at 06:22:28PM +0800, Wong Vee Khee wrote:
> diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
> index 63fda3fc40aa..c7a3aa862079 100644
> --- a/drivers/net/pcs/pcs-xpcs.c
> +++ b/drivers/net/pcs/pcs-xpcs.c
> @@ -1081,7 +1081,8 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
>  };
>  
>  struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
> -			    phy_interface_t interface)
> +			    phy_interface_t interface,
> +			    bool skip_reset)
>  {
>  	struct dw_xpcs *xpcs;
>  	u32 xpcs_id;
> @@ -1113,9 +1114,16 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
>  		xpcs->pcs.ops = &xpcs_phylink_ops;
>  		xpcs->pcs.poll = true;
>  
> -		ret = xpcs_soft_reset(xpcs, compat);
> -		if (ret)
> -			goto out;
> +		if (!skip_reset) {
> +			dev_info(&xpcs->mdiodev->dev, "%s: xPCS soft reset\n",
> +				 __func__);
> +			ret = xpcs_soft_reset(xpcs, compat);
> +			if (ret)
> +				goto out;
> +		} else {
> +			dev_info(&xpcs->mdiodev->dev,
> +				 "%s: skip xpcs soft reset\n", __func__);
> +		}

I don't feel like the prints are really necessary.

>  
>  		return xpcs;
>  	}
> diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
> index add077a81b21..0c05a63f3446 100644
> --- a/include/linux/pcs/pcs-xpcs.h
> +++ b/include/linux/pcs/pcs-xpcs.h
> @@ -36,7 +36,8 @@ void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
>  int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
>  		    int enable);
>  struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
> -			    phy_interface_t interface);
> +			    phy_interface_t interface,
> +			    bool xpcs_reset);
>  void xpcs_destroy(struct dw_xpcs *xpcs);
>  

How about exporting the reset functionality as a separate function, and
the Intel Alder Lake stmmac shim just won't call it? Like this:

-----------------------------[ cut here ]-----------------------------
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 19aea8fb76f6..5acf6742da4d 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -437,13 +437,17 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 			goto out_pcs_free;
 		}
 
-		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
+		xpcs = xpcs_create(mdiodev);
 		if (IS_ERR(xpcs)) {
 			rc = PTR_ERR(xpcs);
 			goto out_pcs_free;
 		}
 
 		priv->xpcs[port] = xpcs;
+
+		rc = xpcs_reset(xpcs, priv->phy_mode[port]);
+		if (rc)
+			goto out_pcs_free;
 	}
 
 	priv->mdio_pcs = bus;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index a5d150c5f3d8..81a145009488 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -401,12 +401,15 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 {
 	struct net_device *ndev = bus->priv;
 	struct mdio_device *mdiodev;
+	bool skip_xpcs_soft_reset;
 	struct stmmac_priv *priv;
 	struct dw_xpcs *xpcs;
 	int mode, addr;
+	int err;
 
 	priv = netdev_priv(ndev);
 	mode = priv->plat->phy_interface;
+	skip_xpcs_soft_reset = priv->plat->skip_xpcs_soft_reset;
 
 	/* Try to probe the XPCS by scanning all addresses. */
 	for (addr = 0; addr < PHY_MAX_ADDR; addr++) {
@@ -414,12 +417,21 @@ int stmmac_xpcs_setup(struct mii_bus *bus)
 		if (IS_ERR(mdiodev))
 			continue;
 
-		xpcs = xpcs_create(mdiodev, mode);
+		xpcs = xpcs_create(mdiodev);
 		if (IS_ERR_OR_NULL(xpcs)) {
 			mdio_device_free(mdiodev);
 			continue;
 		}
 
+		if (!skip_xpcs_soft_reset) {
+			err = xpcs_reset(xpcs, mode);
+			if (err) {
+				xpcs_destroy(xpcs);
+				mdio_device_free(mdiodev);
+				continue;
+			}
+		}
+
 		priv->hw->xpcs = xpcs;
 		break;
 	}
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 63fda3fc40aa..2e721e57bee4 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -248,6 +248,18 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 	return xpcs_poll_reset(xpcs, dev);
 }
 
+int xpcs_reset(struct dw_xpcs *xpcs, phy_interface_t interface)
+{
+	const struct xpcs_compat *compat;
+
+	compat = xpcs_find_compat(xpcs->id, interface);
+	if (!compat)
+		return -ENODEV;
+
+	return xpcs_soft_reset(xpcs, compat);
+}
+EXPORT_SYMBOL_GPL(xpcs_reset);
+
 #define xpcs_warn(__xpcs, __state, __args...) \
 ({ \
 	if ((__state)->link) \
@@ -1080,12 +1092,11 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_link_up = xpcs_link_up,
 };
 
-struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-			    phy_interface_t interface)
+struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev)
 {
 	struct dw_xpcs *xpcs;
 	u32 xpcs_id;
-	int i, ret;
+	int i;
 
 	xpcs = kzalloc(sizeof(*xpcs), GFP_KERNEL);
 	if (!xpcs)
@@ -1097,35 +1108,18 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 
 	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
 		const struct xpcs_id *entry = &xpcs_id_list[i];
-		const struct xpcs_compat *compat;
 
 		if ((xpcs_id & entry->mask) != entry->id)
 			continue;
 
 		xpcs->id = entry;
-
-		compat = xpcs_find_compat(entry, interface);
-		if (!compat) {
-			ret = -ENODEV;
-			goto out;
-		}
-
 		xpcs->pcs.ops = &xpcs_phylink_ops;
 		xpcs->pcs.poll = true;
 
-		ret = xpcs_soft_reset(xpcs, compat);
-		if (ret)
-			goto out;
-
 		return xpcs;
 	}
 
-	ret = -ENODEV;
-
-out:
-	kfree(xpcs);
-
-	return ERR_PTR(ret);
+	return ERR_PTR(-ENODEV);
 }
 EXPORT_SYMBOL_GPL(xpcs_create);
 
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index add077a81b21..d841f55f12cc 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -35,8 +35,8 @@ void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 		   struct phylink_link_state *state);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-			    phy_interface_t interface);
+int xpcs_reset(struct dw_xpcs *xpcs, phy_interface_t interface);
+struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev);
 void xpcs_destroy(struct dw_xpcs *xpcs);
 
 #endif /* __LINUX_PCS_XPCS_H */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a6f03b36fc4f..0f901773c5e4 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -268,5 +268,6 @@ struct plat_stmmacenet_data {
 	int msi_rx_base_vec;
 	int msi_tx_base_vec;
 	bool use_phy_wol;
+	bool skip_xpcs_soft_reset;
 };
 #endif
-----------------------------[ cut here ]-----------------------------

I also gave this patch a run on sja1105 and it still works.
