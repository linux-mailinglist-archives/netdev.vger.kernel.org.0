Return-Path: <netdev+bounces-8815-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B007725DE0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:59:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B97DB28133A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8B033C91;
	Wed,  7 Jun 2023 11:58:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E0C7488
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:58:52 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4716A1BD4
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NKzu6tScQTTd6dCbcW/kX4lXt8gMjeHVk3Ows3oQfiU=; b=nSVnQ39ZqantG7/gv4hoWbhuYb
	elrdkUorDsbO3/ogtkkRXyK88qxUpPlAjthXFUEo8nORsE3zuk8lhmAYvn/33y2fZGWSN++4o2iM4
	jLLNac26Bm82y8Vkz/LOuuD6iBJJpKJnT92JbET5l0BdxmwxqgxVwthKAuqRGUIDZToBbG9m+wxaJ
	Lpd5e4/fKNq54LAuiPRtHsEEPRvdQuhPjCSsLK6sD23ZKp8QYboUsK71j2cQmm38sloyNGw3WJIsB
	PdDsuWloihCDXD+EYSCUnjdnY8/jgROLZTInv+h49z6R+Vv7SD/GmqdCr44Dv/kwOG3t1lKsosRB6
	Cyrdpz9A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44798 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q6ro5-0007LR-Nn; Wed, 07 Jun 2023 12:58:29 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q6ro5-00CfaO-4y; Wed, 07 Jun 2023 12:58:29 +0100
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
Subject: [PATCH net-next v2 04/11] net: pcs: lynx: add
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
Message-Id: <E1q6ro5-00CfaO-4y@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 07 Jun 2023 12:58:29 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a helper to create a lynx PCS from a fwnode handle.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 29 +++++++++++++++++++++++++++++
 include/linux/pcs-lynx.h   |  1 +
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index a90f74172f49..b0907c67d469 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -353,6 +353,35 @@ struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr)
 }
 EXPORT_SYMBOL(lynx_pcs_create_mdiodev);
 
+struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node)
+{
+	struct mdio_device *mdio;
+	struct phylink_pcs *pcs;
+
+	mdio = fwnode_mdio_find_device(node);
+	if (!mdio)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	pcs = lynx_pcs_create(mdio);
+
+	/* Convert failure to create the PCS to an error pointer, so this
+	 * function has a consistent return value strategy.
+	 */
+	if (!pcs)
+		pcs = ERR_PTR(-ENOMEM);
+
+	/* lynx_create() has taken a refcount on the mdiodev if it was
+	 * successful. If lynx_create() fails, this will free the mdio
+	 * device here. In any case, we don't need to hold our reference
+	 * anymore, and putting it here will allow mdio_device_put() in
+	 * lynx_destroy() to automatically free the mdio device.
+	 */
+	mdio_device_put(mdio);
+
+	return pcs;
+}
+EXPORT_SYMBOL_GPL(lynx_pcs_create_fwnode);
+
 void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 25f68a096bfe..123e813df771 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -11,6 +11,7 @@
 
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr);
+struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node);
 
 void lynx_pcs_destroy(struct phylink_pcs *pcs);
 
-- 
2.30.2


