Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BF34F1569
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348721AbiDDNGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348653AbiDDNF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:05:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32423E0DC;
        Mon,  4 Apr 2022 06:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649077442; x=1680613442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OHrFyBYh7zOAExoP5vQt21N8TDpyzsvJW0IvSZrB/L0=;
  b=ZofAfXrONJf4+J4sUDjYeTFpJM2AtYwfvJoNigcSsXQ1S+tWQD43J8Xj
   pBL2xYFSJ10WocJphweISoOYOqjOOXY9sg3aLVGqaLa6r4E/Ny1+BphoQ
   nwT5S9AsaUgbqyZ+CfQpNiwmAKvyYELOnWfmPglh+U8/AbNowRMYzn0Rh
   Ei2lTNmmQhTk+8SDriWq/uxdd41qSxySWs4zhO3ffLVOMo7xj5SjJQmYM
   VrfheA1mY6rzj8y7+YW0pnZ4iUqYtje1vuYKGG4YhFGsz6nU93FHQbEOL
   iIUTwqSosGgERm5hYQGku9DCyISiIKp1nQm04hchNkpNsREgJYJbcAvOF
   A==;
X-IronPort-AV: E=Sophos;i="5.90,234,1643698800"; 
   d="scan'208";a="91142287"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Apr 2022 06:04:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 4 Apr 2022 06:04:01 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 4 Apr 2022 06:03:59 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 2/4] net: lan966x: Expose functions that are needed by FDMA
Date:   Mon, 4 Apr 2022 15:06:53 +0200
Message-ID: <20220404130655.4004204-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
References: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

