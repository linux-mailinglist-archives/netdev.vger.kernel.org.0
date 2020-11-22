Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A332BC484
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 09:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgKVI20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 03:28:26 -0500
Received: from mailout07.rmx.de ([94.199.90.95]:34401 "EHLO mailout07.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727286AbgKVI20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Nov 2020 03:28:26 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout07.rmx.de (Postfix) with ESMTPS id 4Cf3MT3QH7zBwKq;
        Sun, 22 Nov 2020 09:28:21 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Cf3MB42HBz2TS5B;
        Sun, 22 Nov 2020 09:28:06 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.14) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sun, 22 Nov
 2020 09:27:27 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Christian Eggers" <ceggers@gmx.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 1/3] net: phy: dp83640: use new PTP_MSGTYPE_SYNC define
Date:   Sun, 22 Nov 2020 09:26:34 +0100
Message-ID: <20201122082636.12451-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201122082636.12451-1-ceggers@arri.de>
References: <20201122082636.12451-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.14]
X-RMX-ID: 20201122-092812-4Cf3MB42HBz2TS5B-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace use of magic number with recently introduced define.

Signed-off-by: Christian Eggers <ceggers@gmx.de>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/phy/dp83640.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index f2caccaf4408..9757ca0d9633 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -964,15 +964,12 @@ static void decode_status_frame(struct dp83640_private *dp83640,
 static int is_sync(struct sk_buff *skb, int type)
 {
 	struct ptp_header *hdr;
-	u8 msgtype;
 
 	hdr = ptp_parse_header(skb, type);
 	if (!hdr)
 		return 0;
 
-	msgtype = ptp_get_msgtype(hdr, type);
-
-	return (msgtype & 0xf) == 0;
+	return ptp_get_msgtype(hdr, type) == PTP_MSGTYPE_SYNC;
 }
 
 static void dp83640_free_clocks(void)
-- 
Christian Eggers
Embedded software developer

