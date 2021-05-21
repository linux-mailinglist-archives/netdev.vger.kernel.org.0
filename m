Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999B838C7F4
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhEUN1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbhEUN1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:27:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AE2C06138E
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:25:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o5so14334381edc.5
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PX+OIm7ET3s3uJ1YsFWVKtdH8FyQzMYXj7SnRc32D7w=;
        b=jFSu7AwBgenDc+5bgvrideN6VXGIMRn0bX2FpTzjuDBpE3i/IcwtRwon1bIymqF0Fe
         IlSsNa7tg62tgLY17F8u5dkAHYjKp0UqiysL9c0wsU10L2yFy/I2msuFND2V9b7B01al
         RjwI9K7l3gdUaBVHxhqyCGrzwIhaszotWzYbi4BhqKxCrsgKONZ3/A+IkwGgKybp/vST
         3NXgVcVHVFJs9qGXpJvhARZZTDuIadXqXtWFFVY7jr6JH4pNHgvOBF8gjPqeJ9yO7ug2
         O2GsQI2t+kkeX41fg0vrVOtIkkA30jYfoH9nbyPMIT5elJe+yoE34p5055IKwceKLKRk
         LKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PX+OIm7ET3s3uJ1YsFWVKtdH8FyQzMYXj7SnRc32D7w=;
        b=OnUCexP8wM6+iAJdEUf/VNsKcewXw1y93c7G4/vU9vQvzCwWCPoTVphBDLaFpE8icR
         wrDBpRC4O1S6z93amf/0bJ5VBw9pMjxMB0O8tNYDVbIvmtB9cwpUMFH5Hm4IlX0oOAP+
         7Xs+R38BN7VDJlXJcolOUp/RJ+1o/OyLm9OzgoBMcZKAgbYZk+/egfEPdJTyta20Le9y
         htEyly0njzq1XLgLh5fwV8mKhw7pCPQubZabnUpFV8RQ0fLCneaJ3/Es6Mhv9SMlhtll
         K9qv6lfxXn/D4u0QGMyhlwGF4gkZgh1x1RWiY6oPAXI/aozNBx5DGyRHG5lvo//cht9x
         T0KA==
X-Gm-Message-State: AOAM532e/oF/rWpmCezjTn4BltYEi88u8XhK5qVcR6YYFJiKzjU4sZCM
        /Ldf1kHyhqbu5ez1qmBQjsTFmh5xdFI=
X-Google-Smtp-Source: ABdhPJz6eEwynZhu5P486r2NzHPxliKaxDce2ZNO/YigTbe5+bUp9N8ELAd0Xlp6CDOeNIc2YSMuVQ==
X-Received: by 2002:aa7:d0d7:: with SMTP id u23mr11387914edo.147.1621603552393;
        Fri, 21 May 2021 06:25:52 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id s21sm3950439edy.23.2021.05.21.06.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 06:25:52 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/2] dpaa2-eth: setup the of_node field of the device
Date:   Fri, 21 May 2021 16:25:29 +0300
Message-Id: <20210521132530.2784829-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521132530.2784829-1-ciorneiioana@gmail.com>
References: <20210521132530.2784829-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

When the DPNI object is connected to a DPMAC, setup the of_node to point
to the DTS device node of that specific MAC. This enables other drivers,
for example the DSA subsystem, to find the net_device by its device
node.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 25 ++++++++++---------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  1 +
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ccaf7e35abeb..4dfadf2b70d6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -289,17 +289,15 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 	mac->if_link_type = mac->attr.link_type;
 
-	dpmac_node = dpaa2_mac_get_node(mac->attr.id);
+	dpmac_node = mac->of_node;
 	if (!dpmac_node) {
 		netdev_err(net_dev, "No dpmac@%d node found.\n", mac->attr.id);
 		return -ENODEV;
 	}
 
 	err = dpaa2_mac_get_if_mode(dpmac_node, mac->attr);
-	if (err < 0) {
-		err = -EINVAL;
-		goto err_put_node;
-	}
+	if (err < 0)
+		return -EINVAL;
 	mac->if_mode = err;
 
 	/* The MAC does not have the capability to add RGMII delays so
@@ -311,8 +309,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
 	     mac->if_mode == PHY_INTERFACE_MODE_RGMII_TXID)) {
 		netdev_err(net_dev, "RGMII delay not supported\n");
-		err = -EINVAL;
-		goto err_put_node;
+		return -EINVAL;
 	}
 
 	if ((mac->attr.link_type == DPMAC_LINK_TYPE_PHY &&
@@ -320,7 +317,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	    mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE) {
 		err = dpaa2_pcs_create(mac, dpmac_node, mac->attr.id);
 		if (err)
-			goto err_put_node;
+			return err;
 	}
 
 	mac->phylink_config.dev = &net_dev->dev;
@@ -344,16 +341,12 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		goto err_phylink_destroy;
 	}
 
-	of_node_put(dpmac_node);
-
 	return 0;
 
 err_phylink_destroy:
 	phylink_destroy(mac->phylink);
 err_pcs_destroy:
 	dpaa2_pcs_destroy(mac);
-err_put_node:
-	of_node_put(dpmac_node);
 
 	return err;
 }
@@ -388,6 +381,12 @@ int dpaa2_mac_open(struct dpaa2_mac *mac)
 		goto err_close_dpmac;
 	}
 
+	/* Find the device node representing the MAC device and link the device
+	 * behind the associated netdev to it.
+	 */
+	mac->of_node = dpaa2_mac_get_node(mac->attr.id);
+	net_dev->dev.of_node = mac->of_node;
+
 	return 0;
 
 err_close_dpmac:
@@ -400,6 +399,8 @@ void dpaa2_mac_close(struct dpaa2_mac *mac)
 	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
 
 	dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
+	if (mac->of_node)
+		of_node_put(mac->of_node);
 }
 
 static char dpaa2_mac_ethtool_stats[][ETH_GSTRING_LEN] = {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 13d42dd58ec9..8ebcb3420d02 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -24,6 +24,7 @@ struct dpaa2_mac {
 	phy_interface_t if_mode;
 	enum dpmac_link_type if_link_type;
 	struct lynx_pcs *pcs;
+	struct device_node *of_node;
 };
 
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
-- 
2.31.1

