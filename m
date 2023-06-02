Return-Path: <netdev+bounces-7427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 491FA7203DB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:59:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA8A91C20F42
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:59:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1153B19534;
	Fri,  2 Jun 2023 13:58:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CB91952B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:58:50 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998D513E
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 06:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=aGxsm21D6K1Zy50D0wkE9hJtggCpp3rkdAtm9ZIgPbU=; b=Gv+NFE0KlEcTCysb+gjDDM9O2P
	YvBv8bUzmDHa6vztvVvVVFjajOLyLM4CEOljVoXbnNVylDCZyVqbaekYysD/pDhfVmbIH62h4P3j0
	LsZCPo9ELYsC9IZKXUdD0J5ZsyhUujT9qfdRFqNcia2NCtSfNQVc0imOOCkpcPHJhWJ3Vm8m1OMZd
	Gwsc31NRwuNgWjqPLrwBcY0WJgzLgJOmfz/52pTW4QTkxlh2lUtzo4b4PRPlyBhkCsfZt99s0kTZO
	SQhp3Oa6Jqm48zHRmHBfrAlXOe73aKzjRqGf+uF8Zxi/l0PnDB8oLGfClmJBJ1GU/kCnPOwffJkyc
	IFCCOlNg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44270 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q55Ik-00086s-0U; Fri, 02 Jun 2023 14:58:46 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q55Ij-00Bp58-DW; Fri, 02 Jun 2023 14:58:45 +0100
In-Reply-To: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
References: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/3] net: pcs: xpcs: remove xpcs_create() from public
 view
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q55Ij-00Bp58-DW@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 02 Jun 2023 14:58:45 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There are now no callers of xpcs_create(), so let's remove it from
public view to discourage future direct usage.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-xpcs.c   | 5 ++---
 include/linux/pcs/pcs-xpcs.h | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 1ba214429e01..23223f0f8cad 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1224,8 +1224,8 @@ static const struct phylink_pcs_ops xpcs_phylink_ops = {
 	.pcs_link_up = xpcs_link_up,
 };
 
-struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-			    phy_interface_t interface)
+static struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
+				   phy_interface_t interface)
 {
 	struct dw_xpcs *xpcs;
 	u32 xpcs_id;
@@ -1273,7 +1273,6 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 
 	return ERR_PTR(ret);
 }
-EXPORT_SYMBOL_GPL(xpcs_create);
 
 void xpcs_destroy(struct dw_xpcs *xpcs)
 {
diff --git a/include/linux/pcs/pcs-xpcs.h b/include/linux/pcs/pcs-xpcs.h
index a99972a6d046..914e387d5387 100644
--- a/include/linux/pcs/pcs-xpcs.h
+++ b/include/linux/pcs/pcs-xpcs.h
@@ -35,8 +35,6 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 void xpcs_get_interfaces(struct dw_xpcs *xpcs, unsigned long *interfaces);
 int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns,
 		    int enable);
-struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
-			    phy_interface_t interface);
 struct dw_xpcs *xpcs_create_mdiodev(struct mii_bus *bus, int addr,
 				    phy_interface_t interface);
 void xpcs_destroy(struct dw_xpcs *xpcs);
-- 
2.30.2


