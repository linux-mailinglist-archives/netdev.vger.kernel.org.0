Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A224F8F17
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiDHHDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiDHHDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:03:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69A0710F7;
        Fri,  8 Apr 2022 00:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649401259; x=1680937259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OHrFyBYh7zOAExoP5vQt21N8TDpyzsvJW0IvSZrB/L0=;
  b=D5FgirEuc2WPRiX0q/Ggiqrfb25+Bvwoo9engmM28rIBHJqhosGr1FV4
   vmqKzcNEwVFdy3d4yyxSr3Ut4woeMEGYIkI+SLBpn1LGDZKnU4D9q1Oyu
   nQ10xZKFIecezGyOTLDL8dwNM8VrNfkMfPjBpxh8WJ52+mWEbJ7PK/3t3
   9lFn+PSekjkAC4vOvEJnUmLNg9NFzBdGbiGt3VzFXj1xCpzKB0zSZnvh5
   gvJdpNp/GZnwwM56XM16LvLTw5+ZxQpC3aewUu+r+BUR3kCw3saOsw3Y+
   iW/OcQaDgM+5As3o7eRxsBhZ8sar03I4ZwKjqW5jczY5JnCZV9oyWaISR
   g==;
X-IronPort-AV: E=Sophos;i="5.90,244,1643698800"; 
   d="scan'208";a="168914991"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Apr 2022 00:00:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Apr 2022 00:00:58 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 8 Apr 2022 00:00:56 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 2/4] net: lan966x: Expose functions that are needed by FDMA
Date:   Fri, 8 Apr 2022 09:03:55 +0200
Message-ID: <20220408070357.559899-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220408070357.559899-1-horatiu.vultur@microchip.com>
References: <20220408070357.559899-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose the following functions 'lan966x_hw_offload',
'lan966x_ifh_get_src_port' and 'lan966x_ifh_get_timestamp' in
lan966x_main.h so they can be accessed by FDMA.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 10 +++-------
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h |  8 ++++++++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 3e22bfcd4409..03f0d149a80b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -24,9 +24,6 @@
 #define XTR_NOT_READY			0x07000080U
 #define XTR_VALID_BYTES(x)		(4 - (((x) >> 24) & 3))
 
-#define READL_SLEEP_US			10
-#define READL_TIMEOUT_US		100000000
-
 #define IO_RANGES 2
 
 static const struct of_device_id lan966x_match[] = {
@@ -433,8 +430,7 @@ bool lan966x_netdevice_check(const struct net_device *dev)
 	return dev->netdev_ops == &lan966x_port_netdev_ops;
 }
 
-static bool lan966x_hw_offload(struct lan966x *lan966x, u32 port,
-			       struct sk_buff *skb)
+bool lan966x_hw_offload(struct lan966x *lan966x, u32 port, struct sk_buff *skb)
 {
 	u32 val;
 
@@ -515,7 +511,7 @@ static int lan966x_rx_frame_word(struct lan966x *lan966x, u8 grp, u32 *rval)
 	}
 }
 
-static void lan966x_ifh_get_src_port(void *ifh, u64 *src_port)
+void lan966x_ifh_get_src_port(void *ifh, u64 *src_port)
 {
 	packing(ifh, src_port, IFH_POS_SRCPORT + IFH_WID_SRCPORT - 1,
 		IFH_POS_SRCPORT, IFH_LEN * 4, UNPACK, 0);
@@ -527,7 +523,7 @@ static void lan966x_ifh_get_len(void *ifh, u64 *len)
 		IFH_POS_LEN, IFH_LEN * 4, UNPACK, 0);
 }
 
-static void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp)
+void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp)
 {
 	packing(ifh, timestamp, IFH_POS_TIMESTAMP + IFH_WID_TIMESTAMP - 1,
 		IFH_POS_TIMESTAMP, IFH_LEN * 4, UNPACK, 0);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index ae282da1da74..b692c612f235 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -17,6 +17,9 @@
 #define TABLE_UPDATE_SLEEP_US		10
 #define TABLE_UPDATE_TIMEOUT_US		100000
 
+#define READL_SLEEP_US			10
+#define READL_TIMEOUT_US		100000000
+
 #define LAN966X_BUFFER_CELL_SZ		64
 #define LAN966X_BUFFER_MEMORY		(160 * 1024)
 #define LAN966X_BUFFER_MIN_SZ		60
@@ -195,6 +198,11 @@ bool lan966x_netdevice_check(const struct net_device *dev);
 void lan966x_register_notifier_blocks(void);
 void lan966x_unregister_notifier_blocks(void);
 
+bool lan966x_hw_offload(struct lan966x *lan966x, u32 port, struct sk_buff *skb);
+
+void lan966x_ifh_get_src_port(void *ifh, u64 *src_port);
+void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp);
+
 void lan966x_stats_get(struct net_device *dev,
 		       struct rtnl_link_stats64 *stats);
 int lan966x_stats_init(struct lan966x *lan966x);
-- 
2.33.0

