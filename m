Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068042ED3A1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 16:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbhAGPi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 10:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbhAGPiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 10:38:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AFBC0612F8
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 07:37:43 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id b9so10367472ejy.0
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 07:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pYFCj7djd4A2BSCjdkVtuoc6GbJOOFxQ9dbNv6jIJgw=;
        b=ZFGLbRirF7S+JFTV7PeT9eg5YtSHkZEeVHWeavYK2TzDuwJvpMbdASpPlojSneK52j
         hp+mE0smqYnz3G3ZfO3r0ipBAdigjGaWIDnNrARS568dNiGcasNTY/3Ten0Erx6w/ioe
         OXFPv5rI/IkYikf0FuvMub+uZgEbqoL8liujMGIh66pXBTB6tdFOzHSB1LA/TpLxlJYx
         bTF758Bbyss4Cq6QI0nZmtFXT0JXaZdh3tNpIg2lVwd1kg6y+o52YnetDz9P1XtlJi7O
         mM+YUJAyQAuh5wnIvqyEOyP8rcLTtzkHqBBHdIJkfjtLmYRBOOx7HQovxXIjYRR0r5dm
         lPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pYFCj7djd4A2BSCjdkVtuoc6GbJOOFxQ9dbNv6jIJgw=;
        b=hTcWtehqNb5FsdNjEpunE81C0cqpe+Y2SXdHMEuwdhCCF8evFdMsXGChJsQpYe2oJS
         hWvcps1D9Gvys5y8WTfD8UEMwLoGEHWdiVjBs1CUQtVPWBSqRiGAbSdJ893RuebZwq04
         Mx6aNrjdaSdDEiukBV/XM30RqlgaX6tDKVX2lWqV1OB/z0zhSmwxF9dlc17LqJKReNkk
         FMSWMWxYI+5NevQ3mUfxZLIBVSCdv9c+a3a8BYVQxVgzFPviL4JoyXB5jc70Ukm0s0uS
         wXjCOs3bqzjHfefh2sJizaOC9szGdvcr5k6qP8x31e+gHkapJoLv9nl54WY6FDgIpL1r
         fwBw==
X-Gm-Message-State: AOAM530VtHxjAfcbOa5lIgDQnvSy5096zQKmnhK7/2qcbV6vNvDxRz1/
        sk49E1tBKnJbXsvnoiu/XM0=
X-Google-Smtp-Source: ABdhPJyNXPMN9SBtcoA/9gjj4eY76Azf89BykhinX7FNsTu9aIuqNJ3i36BhOM1XxdpMe6CIQ6yg7A==
X-Received: by 2002:a17:906:f8d4:: with SMTP id lh20mr6837673ejb.442.1610033862314;
        Thu, 07 Jan 2021 07:37:42 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z9sm2574898eju.123.2021.01.07.07.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 07:37:41 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 2/6] dpaa2-mac: export MAC counters even when in TYPE_FIXED
Date:   Thu,  7 Jan 2021 17:36:34 +0200
Message-Id: <20210107153638.753942-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107153638.753942-1-ciorneiioana@gmail.com>
References: <20210107153638.753942-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

If the network interface object is connected to a MAC of TYPE_FIXED, the
link status management is handled exclusively by the firmware. This does
not mean that the driver cannot access the MAC counters and export them
in ethtool.

For this to happen, we open the attached dpmac device and keep a pointer
to it in priv->mac. Because of this, all the checks in the driver of the
following form 'if (priv->mac)' have to be updated to actually check
the dpmac attribute and not rely on the presence of a non-NULL value.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 37 +++++++++----------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 13 +++++++
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 16 ++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 26 -------------
 4 files changed, 39 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 61385894e8c7..f3f53e36aa00 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1691,7 +1691,7 @@ static int dpaa2_eth_link_state_update(struct dpaa2_eth_priv *priv)
 	/* When we manage the MAC/PHY using phylink there is no need
 	 * to manually update the netif_carrier.
 	 */
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		goto out;
 
 	/* Chech link state; speed / duplex changes are not treated yet */
@@ -1730,7 +1730,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 			   priv->dpbp_dev->obj_desc.id, priv->bpid);
 	}
 
-	if (!priv->mac) {
+	if (!dpaa2_eth_is_type_phy(priv)) {
 		/* We'll only start the txqs when the link is actually ready;
 		 * make sure we don't race against the link up notification,
 		 * which may come immediately after dpni_enable();
@@ -1752,7 +1752,7 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 		goto enable_err;
 	}
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		phylink_start(priv->mac->phylink);
 
 	return 0;
@@ -1826,11 +1826,11 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	int dpni_enabled = 0;
 	int retries = 10;
 
-	if (!priv->mac) {
+	if (dpaa2_eth_is_type_phy(priv)) {
+		phylink_stop(priv->mac->phylink);
+	} else {
 		netif_tx_stop_all_queues(net_dev);
 		netif_carrier_off(net_dev);
-	} else {
-		phylink_stop(priv->mac->phylink);
 	}
 
 	/* On dpni_disable(), the MC firmware will:
@@ -2115,7 +2115,7 @@ static int dpaa2_eth_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	if (cmd == SIOCSHWTSTAMP)
 		return dpaa2_eth_ts_ioctl(dev, rq, cmd);
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		return phylink_mii_ioctl(priv->mac->phylink, rq, cmd);
 
 	return -EOPNOTSUPP;
@@ -4045,9 +4045,6 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
 		return 0;
 
-	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))
-		return 0;
-
 	mac = kzalloc(sizeof(struct dpaa2_mac), GFP_KERNEL);
 	if (!mac)
 		return -ENOMEM;
@@ -4059,18 +4056,21 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 	err = dpaa2_mac_open(mac);
 	if (err)
 		goto err_free_mac;
+	priv->mac = mac;
 
-	err = dpaa2_mac_connect(mac);
-	if (err) {
-		netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
-		goto err_close_mac;
+	if (dpaa2_eth_is_type_phy(priv)) {
+		err = dpaa2_mac_connect(mac);
+		if (err) {
+			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
+			goto err_close_mac;
+		}
 	}
-	priv->mac = mac;
 
 	return 0;
 
 err_close_mac:
 	dpaa2_mac_close(mac);
+	priv->mac = NULL;
 err_free_mac:
 	kfree(mac);
 	return err;
@@ -4078,10 +4078,9 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 static void dpaa2_eth_disconnect_mac(struct dpaa2_eth_priv *priv)
 {
-	if (!priv->mac)
-		return;
+	if (dpaa2_eth_is_type_phy(priv))
+		dpaa2_mac_disconnect(priv->mac);
 
-	dpaa2_mac_disconnect(priv->mac);
 	dpaa2_mac_close(priv->mac);
 	kfree(priv->mac);
 	priv->mac = NULL;
@@ -4111,7 +4110,7 @@ static irqreturn_t dpni_irq0_handler_thread(int irq_num, void *arg)
 		dpaa2_eth_update_tx_fqids(priv);
 
 		rtnl_lock();
-		if (priv->mac)
+		if (dpaa2_eth_has_mac(priv))
 			dpaa2_eth_disconnect_mac(priv);
 		else
 			dpaa2_eth_connect_mac(priv);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index d236b8695c39..c3d456c45102 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -693,6 +693,19 @@ static inline unsigned int dpaa2_eth_rx_head_room(struct dpaa2_eth_priv *priv)
 	return priv->tx_data_offset - DPAA2_ETH_RX_HWA_SIZE;
 }
 
+static inline bool dpaa2_eth_is_type_phy(struct dpaa2_eth_priv *priv)
+{
+	if (priv->mac && priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY)
+		return true;
+
+	return false;
+}
+
+static inline bool dpaa2_eth_has_mac(struct dpaa2_eth_priv *priv)
+{
+	return priv->mac ? true : false;
+}
+
 int dpaa2_eth_set_hash(struct net_device *net_dev, u64 flags);
 int dpaa2_eth_set_cls(struct net_device *net_dev, u64 key);
 int dpaa2_eth_cls_key_size(u64 key);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index f981a523e13a..bf59708b869e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -85,7 +85,7 @@ static int dpaa2_eth_nway_reset(struct net_device *net_dev)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		return phylink_ethtool_nway_reset(priv->mac->phylink);
 
 	return -EOPNOTSUPP;
@@ -97,7 +97,7 @@ dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		return phylink_ethtool_ksettings_get(priv->mac->phylink,
 						     link_settings);
 
@@ -115,7 +115,7 @@ dpaa2_eth_set_link_ksettings(struct net_device *net_dev,
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	if (!priv->mac)
+	if (!dpaa2_eth_is_type_phy(priv))
 		return -ENOTSUPP;
 
 	return phylink_ethtool_ksettings_set(priv->mac->phylink, link_settings);
@@ -127,7 +127,7 @@ static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	u64 link_options = priv->link_state.options;
 
-	if (priv->mac) {
+	if (dpaa2_eth_is_type_phy(priv)) {
 		phylink_ethtool_get_pauseparam(priv->mac->phylink, pause);
 		return;
 	}
@@ -150,7 +150,7 @@ static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
 		return -EOPNOTSUPP;
 	}
 
-	if (priv->mac)
+	if (dpaa2_eth_is_type_phy(priv))
 		return phylink_ethtool_set_pauseparam(priv->mac->phylink,
 						      pause);
 	if (pause->autoneg)
@@ -198,7 +198,7 @@ static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 			strlcpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
-		if (priv->mac)
+		if (dpaa2_eth_has_mac(priv))
 			dpaa2_mac_get_strings(p);
 		break;
 	}
@@ -211,7 +211,7 @@ static int dpaa2_eth_get_sset_count(struct net_device *net_dev, int sset)
 
 	switch (sset) {
 	case ETH_SS_STATS: /* ethtool_get_stats(), ethtool_get_drvinfo() */
-		if (priv->mac)
+		if (dpaa2_eth_has_mac(priv))
 			num_ss_stats += dpaa2_mac_get_sset_count();
 		return num_ss_stats;
 	default:
@@ -313,7 +313,7 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 	}
 	*(data + i++) = buf_cnt;
 
-	if (priv->mac)
+	if (dpaa2_eth_has_mac(priv))
 		dpaa2_mac_get_ethtool_stats(priv->mac, data + i);
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index b97a219878c0..666bc88c178f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -228,32 +228,6 @@ static const struct phylink_mac_ops dpaa2_mac_phylink_ops = {
 	.mac_link_down = dpaa2_mac_link_down,
 };
 
-bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-			     struct fsl_mc_io *mc_io)
-{
-	struct dpmac_attr attr;
-	bool fixed = false;
-	u16 mc_handle = 0;
-	int err;
-
-	err = dpmac_open(mc_io, 0, dpmac_dev->obj_desc.id,
-			 &mc_handle);
-	if (err || !mc_handle)
-		return false;
-
-	err = dpmac_get_attributes(mc_io, 0, mc_handle, &attr);
-	if (err)
-		goto out;
-
-	if (attr.link_type == DPMAC_LINK_TYPE_FIXED)
-		fixed = true;
-
-out:
-	dpmac_close(mc_io, 0, mc_handle);
-
-	return fixed;
-}
-
 static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 			    struct device_node *dpmac_node, int id)
 {
-- 
2.29.2

