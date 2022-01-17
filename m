Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F584907C3
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239276AbiAQL4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:56:03 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:33961 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239348AbiAQLzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:40 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A3399200018;
        Mon, 17 Jan 2022 11:55:37 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 30/41] net: ieee802154: Define a beacon frame header
Date:   Mon, 17 Jan 2022 12:54:29 +0100
Message-Id: <20220117115440.60296-31-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This definition will be used when adding support for scanning and defines
the content of a beacon frame header as in the 802.15.4 specification.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/ieee802154_netdev.h | 36 +++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c3294b..fb6ac354a7b6 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -22,6 +22,42 @@
 
 #include <net/cfg802154.h>
 
+struct ieee802154_beacon_hdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	u16 beacon_order:4,
+	    superframe_order:4,
+	    final_cap_slot:4,
+	    battery_life_ext:1,
+	    reserved0:1,
+	    pan_coordinator:1,
+	    assoc_permit:1;
+	u8  gts_count:3,
+	    gts_reserved:4,
+	    gts_permit:1;
+	u8  pend_short_addr_count:3,
+	    reserved1:1,
+	    pend_ext_addr_count:3,
+	    reserved2:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	u16 assoc_permit:1,
+	    pan_coordinator:1,
+	    reserved0:1,
+	    battery_life_ext:1,
+	    final_cap_slot:4,
+	    superframe_order:4,
+	    beacon_order:4;
+	u8  gts_permit:1,
+	    gts_reserved:4,
+	    gts_count:3;
+	u8  reserved2:1,
+	    pend_ext_addr_count:3,
+	    reserved1:1,
+	    pend_short_addr_count:3;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+} __packed;
+
 struct ieee802154_sechdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	u8 level:3,
-- 
2.27.0

