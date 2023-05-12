Return-Path: <netdev+bounces-2231-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB36A700D83
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 18:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CFAF281A09
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 16:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB65200BD;
	Fri, 12 May 2023 16:58:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42085A32
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 16:58:47 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029B99ED6
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hfyDtQjOE6Y2QG8MZgO1rttagmSW/tPrY0LH/rQoBJM=; b=UiWZqji1jHCcoF+ZUpVS5F6tXQ
	JKAvGCED5Da8jN2JBY7CwKx+zQRcFS7oEABCcbLIu3RFqQMCXv8s1ZWvm3MltDAvlb8yOBIjmKugU
	WnYY37dIfZBdHT5qXLz8Nie/qSq8vglxTXIAceHfParI4gckGCaLdiwjuZ1I8PBPcDNWaySiheiW9
	kxMfmmM41zvSdrL5j/aSOgOKayzvQAKwCvlJF6+T+cMWzWBjTyfkI+jXRLOuY+oJoVD5zc/+mnKh7
	uOZpcyjNUtlW0zXlhAsqn45VNqn8zMhWoDnq3NyusGF2YMkoAruGoVjuvyRNbS6WNBeM4oLeE9Jyv
	PCe+ZdKg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51764 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxW6I-0000BE-K3; Fri, 12 May 2023 17:58:38 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxW6H-002QFs-SG; Fri, 12 May 2023 17:58:37 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: phylink: constify fwnode arguments
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxW6H-002QFs-SG@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 12 May 2023 17:58:37 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Both phylink_create() and phylink_fwnode_phy_connect() do not modify
the fwnode argument that they are passed, so lets constify these.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 11 ++++++-----
 include/linux/phylink.h   |  9 +++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a4111f1be375..cf53096047e6 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -708,7 +708,7 @@ static int phylink_validate(struct phylink *pl, unsigned long *supported,
 }
 
 static int phylink_parse_fixedlink(struct phylink *pl,
-				   struct fwnode_handle *fwnode)
+				   const struct fwnode_handle *fwnode)
 {
 	struct fwnode_handle *fixed_node;
 	bool pause, asym_pause, autoneg;
@@ -819,7 +819,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 	return 0;
 }
 
-static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
+static int phylink_parse_mode(struct phylink *pl,
+			      const struct fwnode_handle *fwnode)
 {
 	struct fwnode_handle *dn;
 	const char *managed;
@@ -1441,7 +1442,7 @@ static void phylink_fixed_poll(struct timer_list *t)
 static const struct sfp_upstream_ops sfp_phylink_ops;
 
 static int phylink_register_sfp(struct phylink *pl,
-				struct fwnode_handle *fwnode)
+				const struct fwnode_handle *fwnode)
 {
 	struct sfp_bus *bus;
 	int ret;
@@ -1480,7 +1481,7 @@ static int phylink_register_sfp(struct phylink *pl,
  * must use IS_ERR() to check for errors from this function.
  */
 struct phylink *phylink_create(struct phylink_config *config,
-			       struct fwnode_handle *fwnode,
+			       const struct fwnode_handle *fwnode,
 			       phy_interface_t iface,
 			       const struct phylink_mac_ops *mac_ops)
 {
@@ -1809,7 +1810,7 @@ EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
  * Returns 0 on success or a negative errno.
  */
 int phylink_fwnode_phy_connect(struct phylink *pl,
-			       struct fwnode_handle *fwnode,
+			       const struct fwnode_handle *fwnode,
 			       u32 flags)
 {
 	struct fwnode_handle *phy_fwnode;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 71755c66c162..bb782f05ad08 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -568,16 +568,17 @@ void phylink_generic_validate(struct phylink_config *config,
 			      unsigned long *supported,
 			      struct phylink_link_state *state);
 
-struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
-			       phy_interface_t iface,
-			       const struct phylink_mac_ops *mac_ops);
+struct phylink *phylink_create(struct phylink_config *,
+			       const struct fwnode_handle *,
+			       phy_interface_t,
+			       const struct phylink_mac_ops *);
 void phylink_destroy(struct phylink *);
 bool phylink_expects_phy(struct phylink *pl);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
 int phylink_fwnode_phy_connect(struct phylink *pl,
-			       struct fwnode_handle *fwnode,
+			       const struct fwnode_handle *fwnode,
 			       u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 
-- 
2.30.2


