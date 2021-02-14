Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB5A31B0AB
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 15:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbhBNOLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 09:11:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31356 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229563AbhBNOLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 09:11:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11EE7WU4018929;
        Sun, 14 Feb 2021 06:10:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=HCK5RAnLDmd2tJcVUpzEpr1ipDIHUW9pOVlPjq5X3kM=;
 b=JPnuMVPq2Uz19/gOo+Ugc8ZWvnu3CKe7GK5c8TD/ShAYM5xifWmDto7LaPOobRfJGh8D
 EN8a1nNG4GXr5zF6tWY6cg7pfza4B6K6ySbf6qyqEhaniI8bF/EoJleUajE7z7FmGdgm
 zBMl5rB2Vtr1igFMCVemidI3y9hka1nwvxj4GN4hTXskeAOyVHLs1UFP934JeULzQ4gQ
 qEUGEmRye8s8kx608utp9xXVql+H04D8nT3LWicp3g6Rdrl9cRHUcZzUFh+www/4mtPG
 Ml6zHMAEZRZRYyD/5HR6lFt+rnS5R/A545xw60t+kP0EuPXPR/8CSwPTmUnRTgOh/QcR qQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36pf5tsrwn-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 14 Feb 2021 06:10:11 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Feb
 2021 06:10:09 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 14 Feb 2021 06:10:09 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id D4AA33F7051;
        Sun, 14 Feb 2021 06:10:06 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next] net: mvpp2: reduce tx-fifo for loopback port
Date:   Sun, 14 Feb 2021 16:10:03 +0200
Message-ID: <1613311803-17806-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-14_03:2021-02-12,2021-02-14 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

1KB is enough for loopback port, so 2KB can be distributed
between other ports.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      |  4 ++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 373ede3..8edba5e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -763,9 +763,9 @@
 #define MVPP2_RX_FIFO_PORT_MIN_PKT		0x80
 
 /* TX FIFO constants */
-#define MVPP22_TX_FIFO_DATA_SIZE_16KB		16
+#define MVPP22_TX_FIFO_DATA_SIZE_18KB		18
 #define MVPP22_TX_FIFO_DATA_SIZE_10KB		10
-#define MVPP22_TX_FIFO_DATA_SIZE_3KB		3
+#define MVPP22_TX_FIFO_DATA_SIZE_1KB		1
 #define MVPP2_TX_FIFO_THRESHOLD_MIN		256 /* Bytes */
 #define MVPP2_TX_FIFO_THRESHOLD(kb)	\
 		((kb) * 1024 - MVPP2_TX_FIFO_THRESHOLD_MIN)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9d56ea4..222e9a3 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7093,8 +7093,8 @@ static void mvpp22_tx_fifo_set_hw(struct mvpp2 *priv, int port, int size)
 }
 
 /* Initialize TX FIFO's: the total FIFO size is 19kB on PPv2.2 and PPv2.3.
- * 3kB fixed space must be assigned for the loopback port.
- * Redistribute remaining avialable 16kB space among all active ports.
+ * 1kB fixed space must be assigned for the loopback port.
+ * Redistribute remaining avialable 18kB space among all active ports.
  * The 10G interface should use 10kB (which is maximum possible size
  * per single port).
  */
@@ -7105,9 +7105,9 @@ static void mvpp22_tx_fifo_init(struct mvpp2 *priv)
 	int size_remainder;
 	int port, size;
 
-	/* The loopback requires fixed 3kB of the FIFO space assignment. */
+	/* The loopback requires fixed 1kB of the FIFO space assignment. */
 	mvpp22_tx_fifo_set_hw(priv, MVPP2_LOOPBACK_PORT_INDEX,
-			      MVPP22_TX_FIFO_DATA_SIZE_3KB);
+			      MVPP22_TX_FIFO_DATA_SIZE_1KB);
 	port_map = priv->port_map & ~BIT(MVPP2_LOOPBACK_PORT_INDEX);
 
 	/* Set TX FIFO size to 0 for inactive ports. */
@@ -7115,7 +7115,7 @@ static void mvpp22_tx_fifo_init(struct mvpp2 *priv)
 		mvpp22_tx_fifo_set_hw(priv, port, 0);
 
 	/* Assign remaining TX FIFO space among all active ports. */
-	size_remainder = MVPP22_TX_FIFO_DATA_SIZE_16KB;
+	size_remainder = MVPP22_TX_FIFO_DATA_SIZE_18KB;
 	remaining_ports_count = hweight_long(port_map);
 
 	for_each_set_bit(port, &port_map, MVPP2_LOOPBACK_PORT_INDEX) {
-- 
1.9.1

