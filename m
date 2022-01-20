Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079F64944FF
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357942AbiATAoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:44:06 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:34809 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345503AbiATAn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:43:57 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2525A20008;
        Thu, 20 Jan 2022 00:43:55 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 3/4] net: ieee802154: Move the address structure earlier
Date:   Thu, 20 Jan 2022 01:43:49 +0100
Message-Id: <20220120004350.308866-4-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220120004350.308866-1-miquel.raynal@bootlin.com>
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

Move the address structure earlier in the cfg802154.h header in order to
use it in subsequent additions. There is no functional change here.

Signed-off-by: David Girault <david.girault@qorvo.com>
[miquel.raynal@bootlin.com: Isolate this change from a bigger commit]
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/cfg802154.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 4491e2724ff2..4193c242d96e 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -29,6 +29,15 @@ struct ieee802154_llsec_key_id;
 struct ieee802154_llsec_key;
 #endif /* CONFIG_IEEE802154_NL802154_EXPERIMENTAL */
 
+struct ieee802154_addr {
+	u8 mode;
+	__le16 pan_id;
+	union {
+		__le16 short_addr;
+		__le64 extended_addr;
+	};
+};
+
 struct cfg802154_ops {
 	struct net_device * (*add_virtual_intf_deprecated)(struct wpan_phy *wpan_phy,
 							   const char *name,
@@ -277,15 +286,6 @@ static inline void wpan_phy_net_set(struct wpan_phy *wpan_phy, struct net *net)
 	write_pnet(&wpan_phy->_net, net);
 }
 
-struct ieee802154_addr {
-	u8 mode;
-	__le16 pan_id;
-	union {
-		__le16 short_addr;
-		__le64 extended_addr;
-	};
-};
-
 struct ieee802154_llsec_key_id {
 	u8 mode;
 	u8 id;
-- 
2.27.0

