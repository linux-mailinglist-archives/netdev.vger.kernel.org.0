Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821F947D486
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343866AbhLVP6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:00 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60701 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343791AbhLVP5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:57:54 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A9C7860015;
        Wed, 22 Dec 2021 15:57:51 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [net-next 05/18] net: ieee802154: Move the address structure earlier
Date:   Wed, 22 Dec 2021 16:57:30 +0100
Message-Id: <20211222155743.256280-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
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
index 6ed07844eb24..9f57bafeb3bb 100644
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
@@ -227,15 +236,6 @@ static inline void wpan_phy_net_set(struct wpan_phy *wpan_phy, struct net *net)
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

