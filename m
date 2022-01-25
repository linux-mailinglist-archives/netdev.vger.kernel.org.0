Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA2C49B3C7
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444842AbiAYMR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 07:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355169AbiAYMOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 07:14:47 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAA6C061753;
        Tue, 25 Jan 2022 04:14:45 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B3150100011;
        Tue, 25 Jan 2022 12:14:42 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan v3 5/6] net: ieee802154: Return meaningful error codes from the netlink helpers
Date:   Tue, 25 Jan 2022 13:14:25 +0100
Message-Id: <20220125121426.848337-6-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220125121426.848337-1-miquel.raynal@bootlin.com>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Returning -1 does not indicate anything useful.

Use a standard and meaningful error code instead.

Fixes: a26c5fd7622d ("nl802154: add support for security layer")
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

