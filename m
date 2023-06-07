Return-Path: <netdev+bounces-8817-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 499E3725DE4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:00:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7DC91C20D9C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24CC33CA3;
	Wed,  7 Jun 2023 11:59:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85F47488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:59:02 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8971BE2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HQhW/Hts9r3Kh+Zsi5qaq9C+CeI+sWFaMco1KSADJRo=; b=qhHf+PzfW/Dl5xDfw52ESVigyO
	YpiTpw5DSP1aSKSrd2oubrCAybVdHfKx7JeM9HY19TJMWehtmgA/ihresw2P2AEUBF9PktzuMOr+s
	mvlsgl2Qwbl9dBuo3Z4WEwAlFCuAqTeAGPuoLtn6vIwlerK/SSdBY+9kZsCV0uev8DXY/pyg5YUNt
	78qJds1LfvEy8hO28GclXz8MwIYcqiLNx0tDcmGtK8bk7O3yJryPPPpQKqAotGrWgh+ROSP/iV4fg
	Ra0jY5/wik4b4P9uadkIt8jwGmZVRkbI0CHiI6w0KDab7qBCud/WLWMRDBrpEBNfq15tmct/RVHXA
	dSrj3E9A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55494 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q6roG-0007ME-0M; Wed, 07 Jun 2023 12:58:40 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q6roF-00Cfac-D1; Wed, 07 Jun 2023 12:58:39 +0100
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
Subject: [PATCH net-next v2 06/11] net: fman_memac: use
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
Message-Id: <E1q6roF-00Cfac-D1@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 07 Jun 2023 12:58:39 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use lynx_pcs_create_fwnode() to create a lynx PCS from a fwnode handle.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 8f45caf4af12..4fbdae996d05 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1039,19 +1039,14 @@ static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
 					    int index)
 {
 	struct device_node *node;
-	struct mdio_device *mdiodev = NULL;
 	struct phylink_pcs *pcs;
 
 	node = of_parse_phandle(mac_node, "pcsphy-handle", index);
-	if (node && of_device_is_available(node))
-		mdiodev = of_mdio_find_device(node);
-	of_node_put(node);
-
-	if (!mdiodev)
-		return ERR_PTR(-EPROBE_DEFER);
+	if (!node || !of_device_is_available(node))
+		return ERR_PTR(-ENODEV);
 
-	pcs = lynx_pcs_create(mdiodev);
-	mdio_device_put(mdiodev);
+	pcs = lynx_pcs_create_fwnode(of_fwnode_handle(node));
+	of_node_put(node);
 
 	return pcs;
 }
-- 
2.30.2


