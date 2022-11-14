Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB2F6282D3
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:39:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbiKNOi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiKNOil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:38:41 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2281C428
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:38:40 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id g62so11147547pfb.10
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IASNZHNwvbWHeDpezdCT15D5MRNvDyxMNfFoWg+ExSg=;
        b=hL9j3AtMy5bx0Y0uWWBzf6YyDwvcW0cIyaKhvEKjw1Mpw9qsrfIUeXOeZKDFChooe+
         /VDSgixJ5JujcKccehrW78bzG03/Bax8WVceod614StD5cj6MQft/TvLfSzEG1EtKviI
         1jNUpvAzsnO0I/gAAuovjtOCO6OopzD2QSp9ljD12Lpp06rx9d4eBr5A3CkllCWYK2Jg
         kJIizc+Gif2ywNknvPCwddiYPHRkz0AalVWhRWg3TI2jvYc6oCpbMUnCVojPjEBe64SO
         mITlgH6SDmS+hRKAcuUB0vO1rsg3PiHbRX7YLNPE9Qwy4+nuoBYkUv5JrVp9DQOL/b2Z
         utug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IASNZHNwvbWHeDpezdCT15D5MRNvDyxMNfFoWg+ExSg=;
        b=Hq0yhzjQF0dcdN4gIIiMv6CEVTf6w1z+M/ofmJbDvIobZm/qiAZEFmhErAq02aPWbR
         61AxO57+C3x5ke7Halu+mz5wRXMLv/gGY99xAI3qUioa7fdk9M9DJMio0S29//Wfp2ee
         a/Sw67pBVOQAyFi3YVGNp95o14f6zHmg9Cms8N6e3S++icgetAzJs+oJrVYuq4uWX7Ae
         K1P2p396LDpUuFT4eTaiAJ6ilmHgVVyLXhBuDbNs0W0YQYYqF1Gz05umhrUyEXbZaPXs
         QtYBrUIexgxDD9k29QBk/mmRSHb2JiNJ2VM1zRrxKtInkcvAPESaDtDBuITkhrsW/QfO
         qwHw==
X-Gm-Message-State: ANoB5pktM2MNJimhGCvMPdwJiC9mn/LQrNNSDzijx9JR0VtXBnCsCIrj
        Ez8/gvi2roPCGhWTVnI4RcJHow==
X-Google-Smtp-Source: AA0mqf6sFKJBnp73HD0eLFqrTm4SVnI6bm+urfRxkPBidbvGikwEw/HhGG/p8QhmxKGhSNbqYikEPQ==
X-Received: by 2002:a05:6a00:4199:b0:56b:bb06:7dd5 with SMTP id ca25-20020a056a00419900b0056bbb067dd5mr14360225pfb.3.1668436719615;
        Mon, 14 Nov 2022 06:38:39 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00000c00b0056bc742d21esm6977381pfk.176.2022.11.14.06.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:38:39 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v3 RESEND net-next 2/3] net: axienet: set mdio clock according to bus-frequency
Date:   Mon, 14 Nov 2022 22:37:54 +0800
Message-Id: <20221114143755.1241466-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221114143755.1241466-1-andy.chiu@sifive.com>
References: <20221114143755.1241466-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some FPGA platforms have 80KHz MDIO bus frequency constraint when
connecting Ethernet to its on-board external Marvell PHY. Thus, we may
have to set MDIO clock according to the DT. Otherwise, use the default
2.5 MHz, as specified by 802.3, if the entry is not present.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 46 +++++++++++++------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index e1f51a071888..5e1619ce8074 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -147,15 +147,18 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 /**
  * axienet_mdio_enable - MDIO hardware setup function
  * @lp:		Pointer to axienet local data structure.
+ * @np:		Pointer to mdio device tree node.
  *
  * Return:	0 on success, -ETIMEDOUT on a timeout.
  *
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
  * MDIO interface in hardware.
  **/
-static int axienet_mdio_enable(struct axienet_local *lp)
+static int axienet_mdio_enable(struct axienet_local *lp, struct device_node *np)
 {
+	u32 mdio_freq = MAX_MDIO_FREQ;
 	u32 host_clock;
+	u32 clk_div;
 
 	lp->mii_clk_div = 0;
 
@@ -184,6 +187,12 @@ static int axienet_mdio_enable(struct axienet_local *lp)
 			    host_clock);
 	}
 
+	if (np)
+		of_property_read_u32(np, "clock-frequency", &mdio_freq);
+	if (mdio_freq != MAX_MDIO_FREQ)
+		netdev_info(lp->ndev, "Setting non-standard mdio bus frequency to %u Hz\n",
+			    mdio_freq);
+
 	/* clk_div can be calculated by deriving it from the equation:
 	 * fMDIO = fHOST / ((1 + clk_div) * 2)
 	 *
@@ -209,13 +218,20 @@ static int axienet_mdio_enable(struct axienet_local *lp)
 	 * "clock-frequency" from the CPU
 	 */
 
-	lp->mii_clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
+	clk_div = (host_clock / (mdio_freq * 2)) - 1;
 	/* If there is any remainder from the division of
-	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
+	 * fHOST / (mdio_freq * 2), then we need to add
 	 * 1 to the clock divisor or we will surely be above 2.5 MHz
 	 */
-	if (host_clock % (MAX_MDIO_FREQ * 2))
-		lp->mii_clk_div++;
+	if (host_clock % (mdio_freq * 2))
+		clk_div++;
+
+	/* Check for overflow of mii_clk_div */
+	if (clk_div & ~XAE_MDIO_MC_CLOCK_DIVIDE_MAX) {
+		netdev_warn(lp->ndev, "MDIO clock divisor overflow\n");
+		return -EOVERFLOW;
+	}
+	lp->mii_clk_div = (u8)clk_div;
 
 	netdev_dbg(lp->ndev,
 		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
@@ -242,10 +258,6 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	struct mii_bus *bus;
 	int ret;
 
-	ret = axienet_mdio_enable(lp);
-	if (ret < 0)
-		return ret;
-
 	bus = mdiobus_alloc();
 	if (!bus)
 		return -ENOMEM;
@@ -261,15 +273,21 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	lp->mii_bus = bus;
 
 	mdio_node = of_get_child_by_name(lp->dev->of_node, "mdio");
+	ret = axienet_mdio_enable(lp, mdio_node);
+	if (ret < 0)
+		goto unregister;
 	ret = of_mdiobus_register(bus, mdio_node);
+	if (ret)
+		goto unregister;
 	of_node_put(mdio_node);
-	if (ret) {
-		mdiobus_free(bus);
-		lp->mii_bus = NULL;
-		return ret;
-	}
 	axienet_mdio_mdc_disable(lp);
 	return 0;
+
+unregister:
+	of_node_put(mdio_node);
+	mdiobus_free(bus);
+	lp->mii_bus = NULL;
+	return ret;
 }
 
 /**
-- 
2.36.0

