Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC1747D487
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343879AbhLVP6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:02 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49907 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343825AbhLVP55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:57:57 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 76E896000C;
        Wed, 22 Dec 2021 15:57:55 +0000 (UTC)
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
Subject: [net-next 07/18] net: ieee802154: Return meaningful error codes from the netlink helpers
Date:   Wed, 22 Dec 2021 16:57:32 +0100
Message-Id: <20211222155743.256280-8-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Returning -1 does not indicate anything useful.

Use a standard and meaningful error code instead.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/nl802154.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 277124f206e0..e0b072aecf0f 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1441,7 +1441,7 @@ static int nl802154_send_key(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1634,7 +1634,7 @@ static int nl802154_send_device(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1812,7 +1812,7 @@ static int nl802154_send_devkey(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1988,7 +1988,7 @@ static int nl802154_send_seclevel(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
-- 
2.27.0

