Return-Path: <netdev+bounces-8816-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA34725DE1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5AD22812CD
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF3233CA1;
	Wed,  7 Jun 2023 11:58:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734A67488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:58:57 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9FB1BFB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=N2nTmqNGwMWGzJNM0Dewi4A1UPfxyq2EXhFIVh+vr8g=; b=MA7n8IV+gPElE2i7+KvKkm2iHj
	KYWtD/Y+RjGfRNspMeBffTeh+i2OH3KVfdV6n+CBf8gFR7SNb4GMHS/alIY270bg0rC35Us68EFoj
	c6h5v+OJPa85AEQaYkRP25hkw4f8YS57Req+4xtrfHoS0T2wfyqHmP1ayl/5vCgAVJ8BP9/1FMGiB
	bKTUGXlSbzlHuuUIM2BMf8BooN2jwXWlzve9S50JHfOBL/1pcrjdaDr1F+P0VND+YFkejGcBDebjC
	hjLsvZW0kdfxLZWHaiKVAGFaOLWTbRRzCZOpPZgRKe5YZsqhJqjjStCSzVsysqygr3SphUZ/VxZYT
	Y0+0MhmA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44814 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q6roA-0007Lh-TW; Wed, 07 Jun 2023 12:58:34 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q6roA-00CfaU-9F; Wed, 07 Jun 2023 12:58:34 +0100
In-Reply-To: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
References: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Madalin Bucur <madalin.bucur@nxp.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 05/11] net: dpaa2-mac: use
 lynx_pcs_create_fwnode()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q6roA-00CfaU-9F@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 07 Jun 2023 12:58:34 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use lynx_pcs_create_fwnode() to create a lynx PCS from a fwnode handle.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c   | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c0f7dd3b4ac1..38e6208f9e1a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -247,8 +247,8 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 			    struct fwnode_handle *dpmac_node,
 			    int id)
 {
-	struct mdio_device *mdiodev;
 	struct fwnode_handle *node;
+	struct phylink_pcs *pcs;
 
 	node = fwnode_find_reference(dpmac_node, "pcs-handle", 0);
 	if (IS_ERR(node)) {
@@ -263,20 +263,22 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 		return -ENODEV;
 	}
 
-	mdiodev = fwnode_mdio_find_device(node);
+	pcs = lynx_pcs_create_fwnode(node);
 	fwnode_handle_put(node);
-	if (!mdiodev) {
+
+	if (pcs == ERR_PTR(-EPROBE_DEFER)) {
 		netdev_dbg(mac->net_dev, "missing PCS device\n");
 		return -EPROBE_DEFER;
 	}
 
-	mac->pcs = lynx_pcs_create(mdiodev);
-	mdio_device_put(mdiodev);
-	if (!mac->pcs) {
-		netdev_err(mac->net_dev, "lynx_pcs_create() failed\n");
-		return -ENOMEM;
+	if (IS_ERR(pcs)) {
+		netdev_err(mac->net_dev,
+			   "lynx_pcs_create_fwnode() failed: %pe\n", pcs);
+		return PTR_ERR(pcs);
 	}
 
+	mac->pcs = pcs;
+
 	return 0;
 }
 
-- 
2.30.2


