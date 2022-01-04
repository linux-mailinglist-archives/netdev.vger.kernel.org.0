Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CE3483FB0
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 11:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiADKQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 05:16:48 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:21184 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiADKQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 05:16:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641291406; x=1672827406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dRYARUHei31enuqRahGGzA296fgpHte2654n07syC9c=;
  b=TfJwUmvOlXaoUoZsOXSZ2LRUP7DtXVFgY68nbO3irlTdQxyUIb1a3l3B
   mUQ1uHz9kuSgfpQ79Oab6wyiWrJ4JfYzRJtv4St8T4sSboM2/4ooL8DJY
   aTMEMrKQ0JpHSK7NJR3ufWboRkYu914mwvXwOO1f//W252hgGeSXAorEX
   tPPU8pP/wTC8CufGvm7tcNwRpQRwdLcHI1pBY+QyffZi0/R1n4Wn/PvF3
   hc5y6vxMZPKn+qRv1wTcRIO/KHZFeSrCvUIyEYg/h1ad/dMGB51s7baaF
   7iNsUn4xMqTyzMXx2Kn9YKNeO8X268wmiW/gjGUT1b9m0aIAuKFfSV2YD
   g==;
IronPort-SDR: WV7FbLTctoC4rsP0sV5iDoVPeTv2QMQ2g+Kw4dh7RexAQ/eHE1zWk9w2FtceYxVpwxuxRvtQUP
 EJtrP+vucaJPTVknF/FVUJiC+E3XYmLWdOFTLzT4RcpaDu+1NhoUNihRdrUlFGXKRLfg9ls1+s
 fs/ogaA50An6cq7T/6QJqn/Axydp0tGXTKeWJihyCNO64pAS3ytkzjpjTzq3L+v1t+yMtNYvlD
 QEz/CtqwKZRi/t+D/2GhON+pM4Pty7A2nP48e0NzAxQVARpZEMnBM3pJCB0BfcgPAOuY0bRrvz
 hwYmQKzyFF7B4fSAaS3qAGEB
X-IronPort-AV: E=Sophos;i="5.88,260,1635231600"; 
   d="scan'208";a="141568088"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 03:16:46 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 03:16:46 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 4 Jan 2022 03:16:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/3] net: lan966x: Add PGID_FIRST and PGID_LAST
Date:   Tue, 4 Jan 2022 11:18:48 +0100
Message-ID: <20220104101849.229195-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104101849.229195-1-horatiu.vultur@microchip.com>
References: <20220104101849.229195-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first entries in the PGID table are used by the front ports while
the last entries are used for different purposes like flooding mask,
copy to CPU, etc. So add these macros to define which entries can be
used for general purpose.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index f70e54526f53..190d62ced3fd 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -30,7 +30,11 @@
 /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
 #define QSYS_Q_RSRV			95
 
+#define CPU_PORT			8
+
 /* Reserved PGIDs */
+#define PGID_FIRST			(CPU_PORT + 1)
+#define PGID_LAST			PGID_CPU
 #define PGID_CPU			(PGID_AGGR - 6)
 #define PGID_UC				(PGID_AGGR - 5)
 #define PGID_BC				(PGID_AGGR - 4)
@@ -44,8 +48,6 @@
 #define LAN966X_SPEED_100		2
 #define LAN966X_SPEED_10		3
 
-#define CPU_PORT			8
-
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
-- 
2.33.0

