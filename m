Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48EE63D6BE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 14:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbiK3Nay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 08:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbiK3Nab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 08:30:31 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0A186A0D;
        Wed, 30 Nov 2022 05:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669815008; x=1701351008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WFdq3U0yW/+3gkKwBv5k1rgVGnA4EX8hYiO9CLomOCk=;
  b=Fbky42qX7iaFrBvFlIOdNyKyAktDgi/gvE4Q6i+UggLSPHa7C+w0ublT
   9mRJSAEt4LBr+YQ73FHoX/TMJGg7WQai5FIJB9JsHGTOopKPhESVyi8lZ
   bQ2sXOeSNFPetDEP57LoPeNf8XvFL05Lj9XJP1soIuWvekRidD/z3iAUR
   tRB2kGmdM/cnB7vL4xyNi2emEbJcmSZo7sQ3Zc8ECQNqO5KwkKz3BdWME
   fG3UiKrzIDh5plDyv/Y73wJq8FWFFJyAsQ6zAZReaAd2smgLfGEQS4nUn
   R0Nh6+43fZCnxfRwOwFO1JhFrk8UaKw4TBxJHbtBE/WO8dARvH/W0kPND
   g==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="125804059"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2022 06:30:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 30 Nov 2022 06:30:06 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 30 Nov 2022 06:30:03 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [RFC Patch net-next 5/5] net: dsa: microchip: remove num_alus variable
Date:   Wed, 30 Nov 2022 18:59:02 +0530
Message-ID: <20221130132902.2984580-6-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
References: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove num_alus variable from ksz_chip_data structure since
it is unused now.

Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 16 ----------------
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 0f3925d0c668..3e616f1e71b9 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1048,7 +1048,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8563_CHIP_ID,
 		.dev_name = "KSZ8563",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
@@ -1075,7 +1074,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8795_CHIP_ID,
 		.dev_name = "KSZ8795",
 		.num_vlans = 4096,
-		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
@@ -1113,7 +1111,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8794_CHIP_ID,
 		.dev_name = "KSZ8794",
 		.num_vlans = 4096,
-		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
@@ -1137,7 +1134,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8765_CHIP_ID,
 		.dev_name = "KSZ8765",
 		.num_vlans = 4096,
-		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total cpu and user ports */
@@ -1161,7 +1157,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ8830_CHIP_ID,
 		.dev_name = "KSZ8863/KSZ8873",
 		.num_vlans = 16,
-		.num_alus = 0,
 		.num_statics = 8,
 		.cpu_ports = 0x4,	/* can be configured as cpu port */
 		.port_cnt = 3,
@@ -1181,7 +1176,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9477_CHIP_ID,
 		.dev_name = "KSZ9477",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
@@ -1213,7 +1207,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9896_CHIP_ID,
 		.dev_name = "KSZ9896",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x3F,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
@@ -1245,7 +1238,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9897_CHIP_ID,
 		.dev_name = "KSZ9897",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
@@ -1275,7 +1267,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9893_CHIP_ID,
 		.dev_name = "KSZ9893",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
@@ -1300,7 +1291,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9563_CHIP_ID,
 		.dev_name = "KSZ9563",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x07,	/* can be configured as cpu port */
 		.port_cnt = 3,		/* total port count */
@@ -1325,7 +1315,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = KSZ9567_CHIP_ID,
 		.dev_name = "KSZ9567",
 		.num_vlans = 4096,
-		.num_alus = 4096,
 		.num_statics = 16,
 		.cpu_ports = 0x7F,	/* can be configured as cpu port */
 		.port_cnt = 7,		/* total physical port count */
@@ -1355,7 +1344,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9370_CHIP_ID,
 		.dev_name = "LAN9370",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x10,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
@@ -1379,7 +1367,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9371_CHIP_ID,
 		.dev_name = "LAN9371",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 6,		/* total physical port count */
@@ -1403,7 +1390,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9372_CHIP_ID,
 		.dev_name = "LAN9372",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
@@ -1431,7 +1417,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9373_CHIP_ID,
 		.dev_name = "LAN9373",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x38,	/* can be configured as cpu port */
 		.port_cnt = 5,		/* total physical port count */
@@ -1459,7 +1444,6 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.chip_id = LAN9374_CHIP_ID,
 		.dev_name = "LAN9374",
 		.num_vlans = 4096,
-		.num_alus = 1024,
 		.num_statics = 256,
 		.cpu_ports = 0x30,	/* can be configured as cpu port */
 		.port_cnt = 8,		/* total physical port count */
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index c253d761b62b..359148fb9097 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -41,7 +41,6 @@ struct ksz_chip_data {
 	u32 chip_id;
 	const char *dev_name;
 	int num_vlans;
-	int num_alus;
 	int num_statics;
 	int cpu_ports;
 	int port_cnt;
-- 
2.34.1

