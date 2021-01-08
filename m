Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FD32EEF20
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbhAHJIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbhAHJIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 04:08:19 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4CBC0612F6
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 01:07:38 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id u19so10518152edx.2
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 01:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XpEoQbxWtWJsFfdB5Doiub4VSWo7EKLolsqR3ejOC/s=;
        b=jEtQ0eWyIrhRj+KY1EZPEcTYFyKdJ+X9eqmFMOs6Q3y4VW1Ppbs4OQPOjmg7TieZAW
         /OITp8ee3EX2/2QQV7Cr0H2wJrMoQFChjZOAJVjlH5gKaDvUdoiYRdJ2/H8kEPO9/N55
         GuLPo2FbjVD3ShjPOePTaLea/nh9LxN9UfyRCVNxyJSrN3HspnlY1jmBgpRWxSoKDTAH
         X0+EoahwRL3WphJNZH4IumTdb3UU7jnaPNjboIBYg6nCSShxJM0RYtwlgLkgkbPfIlUY
         f+JOFUBZiQtiSUTXng8rdnE3gPa4FGt4RiHCr90nPwDpGbqdNXFwhcfw9f9NcybhWAW4
         T68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XpEoQbxWtWJsFfdB5Doiub4VSWo7EKLolsqR3ejOC/s=;
        b=IDHcmF4deZZxvfrDpyPUQb3wcKrDo0gIaP8SgEYSYs31C+t6Lxz2RltA6yKNF2Hh+1
         QHsXzk3GSGpdayxvoodEbiN4FEzMTcuTxDbcwAUx/cuHt8jTlWnLJmOZt+BEPI4h1pdO
         M+a4oKeCMWtCTFflwEunCjB1XpG8HPSrKhQoV0VSfebQBwe4tBVaAwYEj/VzQiJvJIfy
         zkUSIL+0L6h2zecJnZz/RMk9qhmPy0PGjwBszTyGzP7tU7ifYSJDafyMZlFOLkbVIg3y
         lkc4Hw0ePiHNpynM+t9Px3On8Q8b0mpiUZnhglpyt0ySlJ9rluiL2KIddFE6JQ0Ntt2W
         /suw==
X-Gm-Message-State: AOAM532THwqjUM5zFKhts/dinlfzqfFifQ7Wa6fqryAnlVcjC61LjPbY
        ID7pKdHxNPW9L+p8qD1na6s=
X-Google-Smtp-Source: ABdhPJwqTLq+d03HTlc9Vq4mfmAeO+oBPKY1M7oaHuupERPdj/ZfABnmI9iuo9IIj7rG/YQp7spcGQ==
X-Received: by 2002:a05:6402:229b:: with SMTP id cw27mr4536785edb.23.1610096857331;
        Fri, 08 Jan 2021 01:07:37 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k16sm3307132ejd.78.2021.01.08.01.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 01:07:36 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/6] dpaa2-mac: export MAC counters even when in TYPE_FIXED
Date:   Fri,  8 Jan 2021 11:07:23 +0200
Message-Id: <20210108090727.866283-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108090727.866283-1-ciorneiioana@gmail.com>
References: <20210108090727.866283-1-ciorneiioana@gmail.com>
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
Changes in v2:
 - none

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
index 50dd302abcf4..81b2822a7dc9 100644
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

