Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB332C1F17
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 08:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbgKXHpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 02:45:54 -0500
Received: from mailout10.rmx.de ([94.199.88.75]:34081 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgKXHpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 02:45:54 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4CgGKV2Khqz34yZ;
        Tue, 24 Nov 2020 08:45:50 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CgGJb3jVCz2xGL;
        Tue, 24 Nov 2020 08:45:03 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.100) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 24 Nov
 2020 08:44:57 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>,
        "Kurt Kanzenbach" <kurt@linutronix.de>
Subject: [PATCH net-next v2 1/3] net: phy: dp83640: use new PTP_MSGTYPE_SYNC define
Date:   Tue, 24 Nov 2020 08:44:16 +0100
Message-ID: <20201124074418.2609-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124074418.2609-1-ceggers@arri.de>
References: <20201124074418.2609-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.100]
X-RMX-ID: 20201124-084509-4CgGJb3jVCz2xGL-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace use of magic number with recently introduced define.

Signed-off-by: Christian Eggers <ceggers@arri.de>
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

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

