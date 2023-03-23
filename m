Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B6D6C6D25
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjCWQQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbjCWQQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:16:08 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02olkn2023.outbound.protection.outlook.com [40.92.44.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8FD35EFA;
        Thu, 23 Mar 2023 09:15:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J/xYRAje7cGTdwuamZi4I5DcX0rsNKJB7mq4vJL3dBndDwmYwOtVGDGRHsPyt9gREoWJ/lQhpoC3xXFqwSle/6zCxWKVqsl0d3yeNUNLGxN+gB2IoFQwyuRj9BeeTzoEAXdCJ4TcYY7RfqzZ4zulLwjvErk4yME24/k/OqEA1yYSNCChOgrgIIO4q5LNRPKYP2iY0tyhLzvuOtEqtna85ZGFmB+20uVB0Ggv4BBUgPXhKEhZkb7O6ilUao+SPXv7wDWOpip9FtxMrB3Z/3BtcovoTrq3Alv1S6jiqwqERSuJGhCE1Qus6mHa1IOGcFTuBF5e78omzsbuy+WsYuQ44Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8j/cvE/2Rg9eLXUNvx1sGUDGiusEFHh/Ydcnu8PI0Jc=;
 b=MfWQhSuTp3XLMF6rEGRxA/NeY7Pdkj1A2a/O2+ZR9EiowRu/QXdIrtIHPeKq5n/NSSUykrmQY70lQgbSGUPupdZaB4AljKMmNcRfrr6hS3NuFYB+CGRrWjCKJ1wt7srUvjXGT3L8bgDu6wN+L/mUQS6haH+Ofbzw+AFsC3dX9l5dESi3EuCevDYssnKvudyQCZWBD/Lc5ycy4y+CaREc8esHLjuItUmHOs1gR1GUnAlFV85vugo3ZYcWRy/bwaVfiY8Lsa1NpxKW+l3IbJ4h6sAgZpUWfw6q+A3ZRt1inf+qdEkn0/PBDtAlPSk3bmNqGnWn9jQZkpmjZigHLTKN3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8j/cvE/2Rg9eLXUNvx1sGUDGiusEFHh/Ydcnu8PI0Jc=;
 b=ovcYKojvHR9TlhfIj1xXmbMR0FvzNOt5MgLS9w5rOw04OPb6VmHngi0qqNtEnenA1EtJF3rPVUwNbluNU7Q9yl1r+Pm4+yK7h1P4KK8pmSC8SQ5W3k7N+s6OK1tHXVP/3C+Hyng9yJf50tXo410YzsR9fRLKFxwwODHVq2To3abfuBAOSDczkUxTnE+Tpg5aUQxBgBxMAuib+2icBEdBATSR+htSR0W4BoufvyV2V8VhVIW36lPEeQfC+KDg118iZKXd7dZk1kZLbsjvYPQprFJHzVaKASNR/VhUKe50EtKSSksLD9qPiaKUX0XsGehtsmALUpRsvIGEs1Mmrdz9/w==
Received: from MW5PR03MB6932.namprd03.prod.outlook.com (2603:10b6:303:1cd::22)
 by BY5PR03MB5313.namprd03.prod.outlook.com (2603:10b6:a03:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 16:15:38 +0000
Received: from MW5PR03MB6932.namprd03.prod.outlook.com
 ([fe80::191c:ca4e:23a0:274f]) by MW5PR03MB6932.namprd03.prod.outlook.com
 ([fe80::191c:ca4e:23a0:274f%8]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 16:15:38 +0000
From:   Min Li <lnimi@hotmail.com>
To:     richardcochran@gmail.com, lee@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH mfd-n 2/2] mfd: rsmu: support 32-bit address space
Date:   Thu, 23 Mar 2023 12:15:18 -0400
Message-ID: <MW5PR03MB69320CC31AB6206419DFF2C9A0879@MW5PR03MB6932.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323161518.14907-1-lnimi@hotmail.com>
References: <20230323161518.14907-1-lnimi@hotmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [M//MW5crvytnmDQIHaWth10juy25nni1]
X-ClientProxiedBy: YQBPR0101CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::27) To MW5PR03MB6932.namprd03.prod.outlook.com
 (2603:10b6:303:1cd::22)
X-Microsoft-Original-Message-ID: <20230323161518.14907-2-lnimi@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR03MB6932:EE_|BY5PR03MB5313:EE_
X-MS-Office365-Filtering-Correlation-Id: 97d13117-777b-4c08-59ee-08db2bb9d70c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WHnDYkDJ6+1oB3UZV52BQINikA3hq86uufO4Xr8RXDgWbKkExiUSkXoFFK0pekmKM9OCRKiqeDsXy9SaKVlZUZ5qHloWOBRS7yHybLLoGlQkjqDMS4EVgyB6qaK8+x++u1Ae7mTQvbZ6XM9YHCYaz+CVovmWo5/tRnNYMEdD0WyU+RClDqbZbNURDa2cwA7Fnx+lGngsy8MmBWAlcs4FyJsRcI2M0uAxHklSwJPoz9JAtxWYcnDhFa2p32K8+zxf3tl3MBAgqnWnzlicsY8kLUzPuoSwNWq5VqG/1+gdOOHyBJIHP+uWfsj6t6GSD+KeCHBDLT8B+tzUxAkOkUH+gTJae+jZMeVHORzynLHboq4bzepqlT0Pl6X//vLh7h62MJI+RyEIl3zpe66xTAuovp2Kyw1eviqAJoPNOfatqHvDlbLx79kNHVP+iSue8MH4EOmMgsRzN0ouQxkEbFMXhKokiAs0L2WEKvRS+uWgjs9nOQ1122YhpXW/IPXFJUy9kOAJ9V2XoDexcMDbxiHHAM/ApTNIW3hhZn7s+MBvXEQqGV7/CxFc3VklIK7f57XY30P/iNi2y9CWbEq919ITq0o9wQ1KN9JxZgfFHFxHEyw=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?44RnbxNqa07vXg3IbLskdkBkBWTCQ+szIccI1U5gscyXK5U6FjEUG6Md85LV?=
 =?us-ascii?Q?AKqaG9IsVOmt5VBhhK1a2cZTFf28LbmE8qC7tuqhbmLgfnpYXl5j/p+p8MBz?=
 =?us-ascii?Q?lPkLX8PrWbrO3dw2btbMt8/c22XAtTskaSfzO/oNvaF5VlpkI9X1YK9rLtWo?=
 =?us-ascii?Q?CEEvpBzVRCFaluMA+mI8WASeHtVzZNYj0ylR4oc0m6AdMzUVU43B+jQ6XdfI?=
 =?us-ascii?Q?zgaH/RqRdl3ABbiCJnM2sHu7YIjDjuq6sLVonIdbIQjpPhl1+qAWFfyd9C5G?=
 =?us-ascii?Q?0zaBfJbYDkQx3CVO+S+EkrD9GQ0n1Q59LmyDM45GrNNFw62VfcTMTqBQ2Bbs?=
 =?us-ascii?Q?Ckiwbli5oGxC+RjEq+weq0kRuTUTvrmBV6mxU2HqXW8nasQXylc5Z7IwYCt/?=
 =?us-ascii?Q?NzmWS4PnmHpkCqEOURMKd8lbP+kQXkyofYDMKj/AoIItTPykoflN9HNvFhQ1?=
 =?us-ascii?Q?7PudUCVOVXj9+VpUBC1ItULqIKymjY2CE+QA4MPTcRYAKNRTu4CMJJhWv/q/?=
 =?us-ascii?Q?eq2paTAFUTIDJfz5gLsy7R+EYuGRZRkNgbQjd16SKncmlR3e29rOV7pDY5yA?=
 =?us-ascii?Q?dEhbNpDOOM/demz0FsxrXmPLrGY/fC/0pcrQCxUEbYdunx840Y18ZADUGwLZ?=
 =?us-ascii?Q?DbbMX7yeMoDwpER3qDTpAkYVJmkXa+wqsdPSHDQqrG9rF/iUQKW/O7K19Cpw?=
 =?us-ascii?Q?ZuoDwu2Avnb11uqY8AaA/gOX3NFCFXF3snpW2p6F/9l6Exuk7CCQqiTn70Ms?=
 =?us-ascii?Q?MZXo+hQWXUvxTP+pogOEhLthFBW1ysrl8CCVfmcc1Tf46FF45hkgx3zfsACf?=
 =?us-ascii?Q?WonSkz8lX4Z8J3TsqwR+YA7P/2IzIqJOL5ZXj3RylgrFtlHlvnUWrAwjSvex?=
 =?us-ascii?Q?7agI2Om0CHBGemvi7dCO9cY3iu0ZyUCxs+7ZKinAzcuNAAbYpmHwhmXbndxe?=
 =?us-ascii?Q?jmaoQrvxuNkGjQ3bQhBuQSfBU5QGgC4WeAq8Gk0LSXETtF0Vi9tnLsP6To76?=
 =?us-ascii?Q?8osKTImeCNsV/dwSiFBP15tnu6a46LAuN/U2yI73L5YgNKJ0zPVa0HAPhoxX?=
 =?us-ascii?Q?BXT4IWfEiZVCTT9raWNS1L17nWKXVt6PTOnktm8fxNS612fXPOyEJ+h5D4lf?=
 =?us-ascii?Q?Z/trGEJQIMmG6MywP6VhGIP/BN5d0ZrWwSnESXr57CKHDWAIy4E9MwSnGcw7?=
 =?us-ascii?Q?o/eUDmPhqSK/b3w3mo6+o+2T7vwNh/eS24YEiR7Fw9YIotqdYMCERBfMcyhw?=
 =?us-ascii?Q?IC86qXOFzloZEWR5EEGnNxMadhRYNrpgBaHMS9GP5A=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-685f7.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 97d13117-777b-4c08-59ee-08db2bb9d70c
X-MS-Exchange-CrossTenant-AuthSource: MW5PR03MB6932.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:15:38.4911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5313
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

We used to assume 0x2010xxxx address. Now that we
need to access 0x2011xxxx address, we need to
support read/write the whole 32-bit address space.

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
Change log
- Have to re-write regmap code for clockmatrix since regmap_range_cfg can't
  handle offset register after 32-bit address is considered

 drivers/mfd/rsmu.h       |   2 +
 drivers/mfd/rsmu_i2c.c   | 172 +++++++++++++++++++++++++++++++--------
 drivers/mfd/rsmu_spi.c   |  52 +++++++-----
 include/linux/mfd/rsmu.h |   5 +-
 4 files changed, 175 insertions(+), 56 deletions(-)

diff --git a/drivers/mfd/rsmu.h b/drivers/mfd/rsmu.h
index bb88597d189f..1bb04cafa45d 100644
--- a/drivers/mfd/rsmu.h
+++ b/drivers/mfd/rsmu.h
@@ -10,6 +10,8 @@
 
 #include <linux/mfd/rsmu.h>
 
+#define RSMU_CM_SCSR_BASE		0x20100000
+
 int rsmu_core_init(struct rsmu_ddata *rsmu);
 void rsmu_core_exit(struct rsmu_ddata *rsmu);
 
diff --git a/drivers/mfd/rsmu_i2c.c b/drivers/mfd/rsmu_i2c.c
index 15d25b081434..171b0544b778 100644
--- a/drivers/mfd/rsmu_i2c.c
+++ b/drivers/mfd/rsmu_i2c.c
@@ -18,11 +18,12 @@
 #include "rsmu.h"
 
 /*
- * 16-bit register address: the lower 8 bits of the register address come
- * from the offset addr byte and the upper 8 bits come from the page register.
+ * 32-bit register address: the lower 8 bits of the register address come
+ * from the offset addr byte and the upper 24 bits come from the page register.
  */
-#define	RSMU_CM_PAGE_ADDR		0xFD
-#define	RSMU_CM_PAGE_WINDOW		256
+#define	RSMU_CM_PAGE_ADDR		0xFC
+#define RSMU_CM_PAGE_MASK		0xFFFFFF00
+#define RSMU_CM_ADDRESS_MASK		0x000000FF
 
 /*
  * 15-bit register address: the lower 7 bits of the register address come
@@ -31,18 +32,6 @@
 #define	RSMU_SABRE_PAGE_ADDR		0x7F
 #define	RSMU_SABRE_PAGE_WINDOW		128
 
-static const struct regmap_range_cfg rsmu_cm_range_cfg[] = {
-	{
-		.range_min = 0,
-		.range_max = 0xD000,
-		.selector_reg = RSMU_CM_PAGE_ADDR,
-		.selector_mask = 0xFF,
-		.selector_shift = 0,
-		.window_start = 0,
-		.window_len = RSMU_CM_PAGE_WINDOW,
-	}
-};
-
 static const struct regmap_range_cfg rsmu_sabre_range_cfg[] = {
 	{
 		.range_min = 0,
@@ -55,35 +44,142 @@ static const struct regmap_range_cfg rsmu_sabre_range_cfg[] = {
 	}
 };
 
-static bool rsmu_cm_volatile_reg(struct device *dev, unsigned int reg)
+static bool rsmu_sabre_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
-	case RSMU_CM_PAGE_ADDR:
+	case RSMU_SABRE_PAGE_ADDR:
 		return false;
 	default:
 		return true;
 	}
 }
 
-static bool rsmu_sabre_volatile_reg(struct device *dev, unsigned int reg)
+static int rsmu_read_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes)
 {
-	switch (reg) {
-	case RSMU_SABRE_PAGE_ADDR:
-		return false;
-	default:
-		return true;
+	struct i2c_client *client = to_i2c_client(rsmu->dev);
+	struct i2c_msg msg[2];
+	int cnt;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = &reg;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = bytes;
+	msg[1].buf = buf;
+
+	cnt = i2c_transfer(client->adapter, msg, 2);
+
+	if (cnt < 0) {
+		dev_err(rsmu->dev, "i2c_transfer failed at addr: %04x!", reg);
+		return cnt;
+	} else if (cnt != 2) {
+		dev_err(rsmu->dev,
+			"i2c_transfer sent only %d of 2 messages", cnt);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int rsmu_write_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes)
+{
+	struct i2c_client *client = to_i2c_client(rsmu->dev);
+	/* we add 1 byte for device register */
+	u8 msg[RSMU_MAX_WRITE_COUNT + 1];
+	int cnt;
+
+	if (bytes > RSMU_MAX_WRITE_COUNT)
+		return -EINVAL;
+
+	msg[0] = reg;
+	memcpy(&msg[1], buf, bytes);
+
+	cnt = i2c_master_send(client, msg, bytes + 1);
+
+	if (cnt < 0) {
+		dev_err(&client->dev,
+			"i2c_master_send failed at addr: %04x!", reg);
+		return cnt;
 	}
+
+	return 0;
+}
+
+static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u32 reg)
+{
+	u32 page = reg & RSMU_CM_PAGE_MASK;
+	u8 buf[4];
+	int err;
+
+	/* Do not modify offset register for none-scsr registers */
+	if (reg < RSMU_CM_SCSR_BASE)
+		return 0;
+
+	/* Simply return if we are on the same page */
+	if (rsmu->page == page)
+		return 0;
+
+	buf[0] = 0x0;
+	buf[1] = (u8)((page >> 8) & 0xFF);
+	buf[2] = (u8)((page >> 16) & 0xFF);
+	buf[3] = (u8)((page >> 24) & 0xFF);
+
+	err = rsmu_write_device(rsmu, RSMU_CM_PAGE_ADDR, buf, sizeof(buf));
+	if (err)
+		dev_err(rsmu->dev, "Failed to set page offset 0x%x\n", page);
+	else
+		/* Remember the last page */
+		rsmu->page = page;
+
+	return err;
+}
+
+static int rsmu_reg_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct rsmu_ddata *rsmu = i2c_get_clientdata((struct i2c_client *)context);
+	u8 addr = (u8)(reg & RSMU_CM_ADDRESS_MASK);
+	int err;
+
+	err = rsmu_write_page_register(rsmu, reg);
+	if (err)
+		return err;
+
+	err = rsmu_read_device(rsmu, addr, (u8 *)val, 1);
+	if (err)
+		dev_err(rsmu->dev, "Failed to read offset address 0x%x\n", addr);
+
+	return err;
+}
+
+static int rsmu_reg_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct rsmu_ddata *rsmu = i2c_get_clientdata((struct i2c_client *)context);
+	u8 addr = (u8)(reg & RSMU_CM_ADDRESS_MASK);
+	u8 data = (u8)val;
+	int err;
+
+	err = rsmu_write_page_register(rsmu, reg);
+	if (err)
+		return err;
+
+	err = rsmu_write_device(rsmu, addr, &data, 1);
+	if (err)
+		dev_err(rsmu->dev,
+			"Failed to write offset address 0x%x\n", addr);
+
+	return err;
 }
 
 static const struct regmap_config rsmu_cm_regmap_config = {
-	.reg_bits = 8,
+	.reg_bits = 32,
 	.val_bits = 8,
-	.max_register = 0xD000,
-	.ranges = rsmu_cm_range_cfg,
-	.num_ranges = ARRAY_SIZE(rsmu_cm_range_cfg),
-	.volatile_reg = rsmu_cm_volatile_reg,
-	.cache_type = REGCACHE_RBTREE,
-	.can_multi_write = true,
+	.max_register = 0x20120000,
+	.reg_read = rsmu_reg_read,
+	.reg_write = rsmu_reg_write,
+	.cache_type = REGCACHE_NONE,
 };
 
 static const struct regmap_config rsmu_sabre_regmap_config = {
@@ -101,14 +197,14 @@ static const struct regmap_config rsmu_sl_regmap_config = {
 	.reg_bits = 16,
 	.val_bits = 8,
 	.reg_format_endian = REGMAP_ENDIAN_BIG,
-	.max_register = 0x339,
+	.max_register = 0x340,
 	.cache_type = REGCACHE_NONE,
 	.can_multi_write = true,
 };
 
-static int rsmu_i2c_probe(struct i2c_client *client)
+static int rsmu_i2c_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
 {
-	const struct i2c_device_id *id = i2c_client_get_device_id(client);
 	const struct regmap_config *cfg;
 	struct rsmu_ddata *rsmu;
 	int ret;
@@ -136,7 +232,11 @@ static int rsmu_i2c_probe(struct i2c_client *client)
 		dev_err(rsmu->dev, "Unsupported RSMU device type: %d\n", rsmu->type);
 		return -ENODEV;
 	}
-	rsmu->regmap = devm_regmap_init_i2c(client, cfg);
+
+	if (rsmu->type == RSMU_CM)
+		rsmu->regmap = devm_regmap_init(&client->dev, NULL, client, cfg);
+	else
+		rsmu->regmap = devm_regmap_init_i2c(client, cfg);
 	if (IS_ERR(rsmu->regmap)) {
 		ret = PTR_ERR(rsmu->regmap);
 		dev_err(rsmu->dev, "Failed to allocate register map: %d\n", ret);
@@ -180,7 +280,7 @@ static struct i2c_driver rsmu_i2c_driver = {
 		.name = "rsmu-i2c",
 		.of_match_table = of_match_ptr(rsmu_i2c_of_match),
 	},
-	.probe_new = rsmu_i2c_probe,
+	.probe = rsmu_i2c_probe,
 	.remove	= rsmu_i2c_remove,
 	.id_table = rsmu_i2c_id,
 };
diff --git a/drivers/mfd/rsmu_spi.c b/drivers/mfd/rsmu_spi.c
index 2428aaa9aaed..a4a595bb8d0d 100644
--- a/drivers/mfd/rsmu_spi.c
+++ b/drivers/mfd/rsmu_spi.c
@@ -19,19 +19,21 @@
 
 #define	RSMU_CM_PAGE_ADDR		0x7C
 #define	RSMU_SABRE_PAGE_ADDR		0x7F
-#define	RSMU_HIGHER_ADDR_MASK		0xFF80
-#define	RSMU_HIGHER_ADDR_SHIFT		7
-#define	RSMU_LOWER_ADDR_MASK		0x7F
+#define	RSMU_PAGE_MASK			0xFFFFFF80
+#define	RSMU_ADDR_MASK			0x7F
 
 static int rsmu_read_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes)
 {
 	struct spi_device *client = to_spi_device(rsmu->dev);
 	struct spi_transfer xfer = {0};
 	struct spi_message msg;
-	u8 cmd[256] = {0};
-	u8 rsp[256] = {0};
+	u8 cmd[RSMU_MAX_READ_COUNT + 1] = {0};
+	u8 rsp[RSMU_MAX_READ_COUNT + 1] = {0};
 	int ret;
 
+	if (bytes > RSMU_MAX_READ_COUNT)
+		return -EINVAL;
+
 	cmd[0] = reg | 0x80;
 	xfer.rx_buf = rsp;
 	xfer.len = bytes + 1;
@@ -66,7 +68,10 @@ static int rsmu_write_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes
 	struct spi_device *client = to_spi_device(rsmu->dev);
 	struct spi_transfer xfer = {0};
 	struct spi_message msg;
-	u8 cmd[256] = {0};
+	u8 cmd[RSMU_MAX_WRITE_COUNT + 1] = {0};
+
+	if (bytes > RSMU_MAX_WRITE_COUNT)
+		return -EINVAL;
 
 	cmd[0] = reg;
 	memcpy(&cmd[1], buf, bytes);
@@ -86,26 +91,35 @@ static int rsmu_write_device(struct rsmu_ddata *rsmu, u8 reg, u8 *buf, u16 bytes
  * 16-bit register address: the lower 7 bits of the register address come
  * from the offset addr byte and the upper 9 bits come from the page register.
  */
-static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u16 reg)
+static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u32 reg)
 {
 	u8 page_reg;
-	u8 buf[2];
+	u8 buf[4];
 	u16 bytes;
-	u16 page;
+	u32 page;
 	int err;
 
 	switch (rsmu->type) {
 	case RSMU_CM:
+		/* Do not modify page register for none-scsr registers */
+		if (reg < RSMU_CM_SCSR_BASE)
+			return 0;
 		page_reg = RSMU_CM_PAGE_ADDR;
-		page = reg & RSMU_HIGHER_ADDR_MASK;
+		page = reg & RSMU_PAGE_MASK;
 		buf[0] = (u8)(page & 0xff);
 		buf[1] = (u8)((page >> 8) & 0xff);
-		bytes = 2;
+		buf[2] = (u8)((page >> 16) & 0xff);
+		buf[3] = (u8)((page >> 24) & 0xff);
+		bytes = 4;
 		break;
 	case RSMU_SABRE:
+		/* Do not modify page register if reg is page register itself */
+		if ((reg & RSMU_ADDR_MASK) == RSMU_ADDR_MASK)
+			return 0;
 		page_reg = RSMU_SABRE_PAGE_ADDR;
-		page = reg >> RSMU_HIGHER_ADDR_SHIFT;
-		buf[0] = (u8)(page & 0xff);
+		page = reg & RSMU_PAGE_MASK;
+		/* The three page bits are located in the single Page Register */
+		buf[0] = (u8)((page >> 7) & 0x7);
 		bytes = 1;
 		break;
 	default:
@@ -129,8 +143,8 @@ static int rsmu_write_page_register(struct rsmu_ddata *rsmu, u16 reg)
 
 static int rsmu_reg_read(void *context, unsigned int reg, unsigned int *val)
 {
-	struct rsmu_ddata *rsmu = spi_get_drvdata(context);
-	u8 addr = (u8)(reg & RSMU_LOWER_ADDR_MASK);
+	struct rsmu_ddata *rsmu = spi_get_drvdata((struct spi_device *)context);
+	u8 addr = (u8)(reg & RSMU_ADDR_MASK);
 	int err;
 
 	err = rsmu_write_page_register(rsmu, reg);
@@ -146,8 +160,8 @@ static int rsmu_reg_read(void *context, unsigned int reg, unsigned int *val)
 
 static int rsmu_reg_write(void *context, unsigned int reg, unsigned int val)
 {
-	struct rsmu_ddata *rsmu = spi_get_drvdata(context);
-	u8 addr = (u8)(reg & RSMU_LOWER_ADDR_MASK);
+	struct rsmu_ddata *rsmu = spi_get_drvdata((struct spi_device *)context);
+	u8 addr = (u8)(reg & RSMU_ADDR_MASK);
 	u8 data = (u8)val;
 	int err;
 
@@ -164,9 +178,9 @@ static int rsmu_reg_write(void *context, unsigned int reg, unsigned int val)
 }
 
 static const struct regmap_config rsmu_cm_regmap_config = {
-	.reg_bits = 16,
+	.reg_bits = 32,
 	.val_bits = 8,
-	.max_register = 0xD000,
+	.max_register = 0x20120000,
 	.reg_read = rsmu_reg_read,
 	.reg_write = rsmu_reg_write,
 	.cache_type = REGCACHE_NONE,
diff --git a/include/linux/mfd/rsmu.h b/include/linux/mfd/rsmu.h
index 6870de608233..0379aa207428 100644
--- a/include/linux/mfd/rsmu.h
+++ b/include/linux/mfd/rsmu.h
@@ -8,6 +8,9 @@
 #ifndef __LINUX_MFD_RSMU_H
 #define __LINUX_MFD_RSMU_H
 
+#define RSMU_MAX_WRITE_COUNT	(255)
+#define RSMU_MAX_READ_COUNT	(255)
+
 /* The supported devices are ClockMatrix, Sabre and SnowLotus */
 enum rsmu_type {
 	RSMU_CM		= 0x34000,
@@ -31,6 +34,6 @@ struct rsmu_ddata {
 	struct regmap *regmap;
 	struct mutex lock;
 	enum rsmu_type type;
-	u16 page;
+	u32 page;
 };
 #endif /*  __LINUX_MFD_RSMU_H */
-- 
2.39.2

