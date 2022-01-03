Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B07483149
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 14:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiACNIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 08:08:40 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:6231 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiACNIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 08:08:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641215317; x=1672751317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8tv9TUYukugLAJJAqtTOv2fs0qWQ0pRAJtVYI/T6a/4=;
  b=hib+lQOtJ5cQ9hVqsw6LvgZWKn04f/rgDTTuYFOYe0rPecOqrZX8HIJ4
   uHTNq/ZMZDDSU4ZpShMzqXZhi1CTXWW0yAr5BA+MeGk/VpyDYRgBIQjpw
   RTE/zNvAAeY8gAUbrV6atDlM2fraU4Auq7Gpdggvy51pS0tVd/78oAdtb
   WQz/8jD3wUcsvCHtI7qzvtVXMZ36Ike+bZdpjL7Mg9s5qDqbnJiueC6hd
   uVaZ1a1qJ/crhvZs8vp4TSgqNWv0/1+c86AcVRWX+Fp6j0q1HLcT913oD
   7NTZLn5ExdMNEEOxEdi3IBo7Pu1hXaAsh44VLLus1sY0zOC2O/lzuI/pL
   g==;
IronPort-SDR: nI5jW+kWwjQLorj/TB0oRJ+MheeV8fHk042JpMwudchI44nWs9JsreHlLvH0INFupPZt4EAN/S
 mwdRuWoyyG5FJG6FzZbSTBS7f5ziraWVE35Qw0tmL4VtM6HkqT852aAXWjHmejNEj1UrIeT1Hd
 HAzn+DLOycXeff7w12a7D2KSehDEv6q3LLmmjdrkE5oFS1rYN8HrjcBEB7gGoLGzjxloLIJQT+
 1VbMT18gJHXp2z38zh0spOgXqJ8U3heIKmz/LesFa711kB/gyl/nr94ND9wmYelLNxI+DrmpgM
 fDSjTwKfYPjqXO1DNJAr6T23
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="141458450"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jan 2022 06:08:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 3 Jan 2022 06:08:36 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 3 Jan 2022 06:08:34 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/3] net: lan966x: Add PGID_FIRST and PGID_LAST
Date:   Mon, 3 Jan 2022 14:10:38 +0100
Message-ID: <20220103131039.3473876-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
References: <20220103131039.3473876-1-horatiu.vultur@microchip.com>
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
index a7a2a3537036..49ce6a04ca40 100644
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

