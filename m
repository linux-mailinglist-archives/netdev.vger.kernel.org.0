Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D3548449B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiADPbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:31:37 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:30990 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiADPbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641310293; x=1672846293;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U5lz8us5Ygxz68APJ50OwqcXLWn3xmngC1VcdgzSAnM=;
  b=FjHBdqUte1ouevvmEPinIHOxsQcYhRk1splOmcIUbNSobx2JkHf7QFdJ
   Vy2fwWYDzMJWAxL9pn3vvckTHQEYVDdVtFis0dxtTEkMCOba5asBklTUq
   RD1SUpAZLYbkE8dM7TJOzMa2x2X9qD/ssZWv3KES2buBpAcS13uTClSNp
   dsg843M0c+wyfozNNC5PY7pyLwDgGxkkWFIpHxTku4ZfNJVWCfurTh5QD
   cppkyRZ6RUCgyx+cbRfT8urAW0om/NVkVnGA8VPvYOHPgOT8Hl0ApHsgU
   juIP8Kp0BjrFV4ZJ8oUgFiHgS2PRaTPP4kMyhfsHn3pLgQK5awjEzWs7U
   Q==;
IronPort-SDR: sJfI3ZDobdAr7tp0UmbLwCCvYAV7Ke4R+GRQraRSi++vLwST1i0ZocTgtzzXwBBXCMQ25Bffok
 vv11iLO6d/s5AM9gFPqx77+9Iwn1hu6TagT57kVL2wshGaPfCwliU+jyPEtV0RXpG7v8RaRfgN
 VHdYXGoMtaZgdY1q+B/ujBmwD8eYBGafMrJZvd0Tune/S3Jh/VGHMB14YSesxo0QGpAbivnbTX
 Y322cGe4EQUQMEp1gjbPFUi608hZ+49Gb1ZbloofKqj952a6n9/Hxc+mZ4aD5rzrJD0IqiJBHq
 i7hkDWrzQTgJLFU2+9QHKJ1Y
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="149079352"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 08:31:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 08:31:32 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 4 Jan 2022 08:31:30 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 2/3] net: lan966x: Add PGID_GP_START and PGID_GP_END
Date:   Tue, 4 Jan 2022 16:33:37 +0100
Message-ID: <20220104153338.425250-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104153338.425250-1-horatiu.vultur@microchip.com>
References: <20220104153338.425250-1-horatiu.vultur@microchip.com>
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
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index f70e54526f53..367c2afe84a6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -30,6 +30,8 @@
 /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
 #define QSYS_Q_RSRV			95
 
+#define CPU_PORT			8
+
 /* Reserved PGIDs */
 #define PGID_CPU			(PGID_AGGR - 6)
 #define PGID_UC				(PGID_AGGR - 5)
@@ -38,14 +40,16 @@
 #define PGID_MCIPV4			(PGID_AGGR - 2)
 #define PGID_MCIPV6			(PGID_AGGR - 1)
 
+/* Non-reserved PGIDs, used for general purpose */
+#define PGID_GP_START			(CPU_PORT + 1)
+#define PGID_GP_END			PGID_CPU
+
 #define LAN966X_SPEED_NONE		0
 #define LAN966X_SPEED_2500		1
 #define LAN966X_SPEED_1000		1
 #define LAN966X_SPEED_100		2
 #define LAN966X_SPEED_10		3
 
-#define CPU_PORT			8
-
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
-- 
2.33.0

