Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDDF2BA4EF
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgKTIm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:42:56 -0500
Received: from mailout06.rmx.de ([94.199.90.92]:59547 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKTIm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 03:42:56 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4Ccqn71kcvz9wpp;
        Fri, 20 Nov 2020 09:42:51 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CcqmD2pfTz2TTM3;
        Fri, 20 Nov 2020 09:42:04 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.143) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 20 Nov
 2020 09:41:58 +0100
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
Subject: [PATCH net-next v3 1/3] net: ptp: introduce common defines for PTP message types
Date:   Fri, 20 Nov 2020 09:41:04 +0100
Message-ID: <20201120084106.10046-2-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120084106.10046-1-ceggers@arri.de>
References: <20201120084106.10046-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.143]
X-RMX-ID: 20201120-094210-4CcqmD2pfTz2TTM3-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using PTP wide defines will obsolete different driver internal defines
and uses of magic numbers.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/ptp_classify.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 56b2d7d66177..cc0da0b134a4 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -31,6 +31,11 @@
 #define PTP_CLASS_V2_VLAN (PTP_CLASS_V2 | PTP_CLASS_VLAN)
 #define PTP_CLASS_L4      (PTP_CLASS_IPV4 | PTP_CLASS_IPV6)
 
+#define PTP_MSGTYPE_SYNC        0x0
+#define PTP_MSGTYPE_DELAY_REQ   0x1
+#define PTP_MSGTYPE_PDELAY_REQ  0x2
+#define PTP_MSGTYPE_PDELAY_RESP 0x3
+
 #define PTP_EV_PORT 319
 #define PTP_GEN_BIT 0x08 /* indicates general message, if set in message type */
 
@@ -138,7 +143,7 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
 	/* The return is meaningless. The stub function would not be
 	 * executed since no available header from ptp_parse_header.
 	 */
-	return 0;
+	return PTP_MSGTYPE_SYNC;
 }
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

