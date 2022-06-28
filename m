Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1928555EACA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbiF1RPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbiF1RPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:15:11 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158422CDCC;
        Tue, 28 Jun 2022 10:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656436506; x=1687972506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jYglTYx+V76PBeSF7A9l6QurvfJiN1mDanoG8IpvadQ=;
  b=DXR9d3b4/L58u9FUGQYe9Du33fFP0ThJDKp4hhVkh0deMhZgBPsJZLVq
   d6OUgxQuUil9f6ULw+N5WR3CSVmH8gHqSqo6oDLDbyaDev9LT+BIjnNXC
   g5FlQCIZJHLtSV0+QsdWnExwHoQ5HaLf8wS0u5Mg9mAqCbepmLstFUYp1
   nYB9qxuFnuVJJHBGDA5cqIanCaQd+DFK9EUrIq7sn35oZAMlX20+joGak
   ijR+zJgsgeuVErsuG1N5yhosswMRAbRaWEI0Z4dQUvouh3oBXc0v0xTZR
   3mmLpH5/zNN5IIz7AhsyQyLmZalEWhToywG63sUkkCpDhsLLtIskey5yt
   w==;
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="162447853"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jun 2022 10:15:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 28 Jun 2022 10:15:03 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 28 Jun 2022 10:14:51 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch net-next 5/7] net: dsa: microchip: change the size of reg from u8 to u16
Date:   Tue, 28 Jun 2022 22:43:27 +0530
Message-ID: <20220628171329.25503-6-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628171329.25503-1-arun.ramadoss@microchip.com>
References: <20220628171329.25503-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The register size for the ksz8 switches is u8 and for ksz9477 series is
u16.  To have common struct for ksz series switches the size of reg is
increased from u8 to u16.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    | 22 +++++++++++-----------
 drivers/net/dsa/microchip/ksz_common.c |  4 ++--
 drivers/net/dsa/microchip/ksz_common.h |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 2b3db33c32ce..264c960f715d 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -45,7 +45,7 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 
 static int ksz8_ind_write8(struct ksz_device *dev, u8 table, u16 addr, u8 data)
 {
-	const u8 *regs;
+	const u16 *regs;
 	u16 ctrl_addr;
 	int ret = 0;
 
@@ -117,7 +117,7 @@ static void ksz8795_set_prio_queue(struct ksz_device *dev, int port, int queue)
 void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 {
 	const u32 *masks;
-	const u8 *regs;
+	const u16 *regs;
 	u16 ctrl_addr;
 	u32 data;
 	u8 check;
@@ -153,7 +153,7 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			      u64 *dropped, u64 *cnt)
 {
 	const u32 *masks;
-	const u8 *regs;
+	const u16 *regs;
 	u16 ctrl_addr;
 	u32 data;
 	u8 check;
@@ -205,7 +205,7 @@ static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 			      u64 *dropped, u64 *cnt)
 {
 	u32 *last = (u32 *)dropped;
-	const u8 *regs;
+	const u16 *regs;
 	u16 ctrl_addr;
 	u32 data;
 	u32 cur;
@@ -292,7 +292,7 @@ void ksz8_port_init_cnt(struct ksz_device *dev, int port)
 
 static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 {
-	const u8 *regs;
+	const u16 *regs;
 	u16 ctrl_addr;
 
 	regs = dev->info->regs;
@@ -307,7 +307,7 @@ static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 
 static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
 {
-	const u8 *regs;
+	const u16 *regs;
 	u16 ctrl_addr;
 
 	regs = dev->info->regs;
@@ -324,7 +324,7 @@ static int ksz8_valid_dyn_entry(struct ksz_device *dev, u8 *data)
 {
 	int timeout = 100;
 	const u32 *masks;
-	const u8 *regs;
+	const u16 *regs;
 
 	masks = dev->info->masks;
 	regs = dev->info->regs;
@@ -354,7 +354,7 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 	u32 data_hi, data_lo;
 	const u8 *shifts;
 	const u32 *masks;
-	const u8 *regs;
+	const u16 *regs;
 	u16 ctrl_addr;
 	u8 data;
 	int rc;
@@ -561,7 +561,7 @@ void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
 	u8 restart, speed, ctrl, link;
 	int processed = true;
-	const u8 *regs;
+	const u16 *regs;
 	u8 val1, val2;
 	u16 data = 0;
 	u8 p = phy;
@@ -684,7 +684,7 @@ void ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
 	u8 restart, speed, ctrl, data;
-	const u8 *regs;
+	const u16 *regs;
 	u8 p = phy;
 
 	regs = dev->info->regs;
@@ -1199,7 +1199,7 @@ void ksz8_config_cpu_port(struct dsa_switch *ds)
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p;
 	const u32 *masks;
-	const u8 *regs;
+	const u16 *regs;
 	u8 remote;
 	int i;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index fa66bd14f66a..4992fea208b1 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -201,7 +201,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.exit = ksz9477_switch_exit,
 };
 
-static const u8 ksz8795_regs[] = {
+static const u16 ksz8795_regs[] = {
 	[REG_IND_CTRL_0]		= 0x6E,
 	[REG_IND_DATA_8]		= 0x70,
 	[REG_IND_DATA_CHECK]		= 0x72,
@@ -252,7 +252,7 @@ static const u8 ksz8795_shifts[] = {
 	[DYNAMIC_MAC_SRC_PORT]		= 24,
 };
 
-static const u8 ksz8863_regs[] = {
+static const u16 ksz8863_regs[] = {
 	[REG_IND_CTRL_0]		= 0x79,
 	[REG_IND_DATA_8]		= 0x7B,
 	[REG_IND_DATA_CHECK]		= 0x7B,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c11adf67757d..18794f571687 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -47,7 +47,7 @@ struct ksz_chip_data {
 	const struct ksz_mib_names *mib_names;
 	int mib_cnt;
 	u8 reg_mib_cnt;
-	const u8 *regs;
+	const u16 *regs;
 	const u32 *masks;
 	const u8 *shifts;
 	int stp_ctrl_reg;
-- 
2.36.1

