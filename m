Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B86C3A03
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjCUTMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCUTMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:12:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10olkn2042.outbound.protection.outlook.com [40.92.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9533A231FD;
        Tue, 21 Mar 2023 12:11:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QVFdK1ADLQ2OhBjDLgHQTV1bDfkejWHMRo0qHwP3e4l1Lx7VIgvL5U9vuS+vSVu0FZyF/SmNt3q2cGZQAGsEubXPtzCEnKKdearBTQEwRFTQUpVtSg2wubF5zCt9OCfRAYDsSfQbRaZfGG2yE2tkJyzO5wJvbnpX5qPmS+NdK68FjgkkeheRglGHgm802Nbgc+zHutszJiSLpWM1uK/5nXqVG9u3tdYTHhqZpoNOiLxxRAN+Jg0XGJSpHNaWvJD/OKzcrJgajXMlVR5ynKcKCpK0fXH1K0Ooy+8CAT2aFHDru8EiLQg4Nw7oddlscGhll1xDPDnk1ODgsbxZsHCrPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ideqNgFchE4fuoLuna+RGs8mDggJ5xgi7BBDVsNfA88=;
 b=QLKTidwlTYDdRE492jFizb8bIdWJJC7UW1+65JkuIX2VS8t2CJ8JUdrUvIieZ0yJmsgFNMqSSpGVIibWz5R0HHVdCw6Jl0jhM9Ojxi/C1uq6ONjz6RKVGQQKtt1nhmox6RhbkeFVuA7cRr5QhR9DaE5y8Drpt4e8Wi+4MgRIsEL7MhopHkmeq32njlH4wFPeGRydLxRmujOLo98vPufeIoUQBXWsfV56BfJfGy93bwqic6zUHD2saXgJxp9LEvcr9U6Mfo3xUcsOftcjYo1hRg7tGTVNAhzwymQqXDgBqXDmMuYVvUZ56fEp7Eg6KPopnCz7Kh0fNyO/sQJG4daLvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ideqNgFchE4fuoLuna+RGs8mDggJ5xgi7BBDVsNfA88=;
 b=IF3YmACW464GIckJxaXRrdt8SNCPcVihZth1uSCpzO0doy69fIqOW6Lo2agKJLefJ4WgFf46mtzTzdv/3WiqfRMeszQDPhsS8vfhqtgD1jmbMKfPIXMsQPjlhjSPX1tz0Z7c5v6qjCraUDrBXJDqntnmhyPATW3KM3sRM36TTBCRvtwlxMMSMoLEHTTWAxvh8NEmxPcQcdUm6jW6cj+660FB11Ox4EqtHiodrjSHuBrdbPr3Oz29kphYoeLjmfcGr9pFykT7OGKoIzuPsGrrq/oKxM3QQ5gMcp5z7C62hJDHlxsk4Gc/wnyubOYeZ4Vqef39rxf3sUXzGpl0hME6bQ==
Received: from MW5PR03MB6932.namprd03.prod.outlook.com (2603:10b6:303:1cd::22)
 by MN2PR03MB5104.namprd03.prod.outlook.com (2603:10b6:208:1a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 19:10:35 +0000
Received: from MW5PR03MB6932.namprd03.prod.outlook.com
 ([fe80::191c:ca4e:23a0:274f]) by MW5PR03MB6932.namprd03.prod.outlook.com
 ([fe80::191c:ca4e:23a0:274f%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 19:10:35 +0000
From:   Min Li <lnimi@hotmail.com>
To:     richardcochran@gmail.com, lee@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH mfd 1/1] mfd/ptp: clockmatrix: support 32-bit address space
Date:   Tue, 21 Mar 2023 15:10:06 -0400
Message-ID: <MW5PR03MB69323E281F1360A4F6C92838A0819@MW5PR03MB6932.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [ARIQLgVpjOlUP41vf8caVx+BO2BQR6aT]
X-ClientProxiedBy: SN6PR01CA0006.prod.exchangelabs.com (2603:10b6:805:b6::19)
 To MW5PR03MB6932.namprd03.prod.outlook.com (2603:10b6:303:1cd::22)
X-Microsoft-Original-Message-ID: <20230321191006.29497-1-lnimi@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR03MB6932:EE_|MN2PR03MB5104:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a6c4fc-c2ca-4ad1-b642-08db2a3ff2ae
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aeuYFQ6jB+dUzsEnSIJErv1tX6MGJ5I5yq3xhh0WxLEMC9Pt3ThhD8CiaMuMFHTh2Dmm8dlOB87hRHf8StLVKD4aHRBxW8EFKwqFBuI0jJ1JC7r8seftOgtBK6fqZZIjhWTCBokDEuhxwEYlksAZu5lY+5U71FGJG59VyG7lHikAvjavaqHFn3eQla52thdq0NsoexpXAnFJaqJoJZgmXAy5xTjhegOUEL4XSaxEtDNPgWMWD7djd8xKjgVDPle55aknsQ0JIAoxOWpBJ2CZebBBXH5xoUEsxn4LjncmNGK3dQwP6TboqsrYQiJoSNovAqljng7nuFf23B2cBzZGO4NeCA/BMkWj+JfkmKIG4Dn8IigNCeUx7m2Nh9KmGEP0H1RZ8wYmmWVH/3430V1lH6lOb0xnWYrggjdhKNx6dgXjpaoYBt6aoE+9qOW9+GXR8UV8md4h4wl/ZoIoVxYSQoofKquDXk2OXDovB4gREVTS7rc4OFefnV48dYLdPPjOWR8D0Jvp1QE58BKw9N3ZXCB3woYbWRfx+tGL0YxUM+BcTPSTO2cl/ensqfutwq95+PL4Xy7MQipbQcpwjChM5SZFe7XBwMQBqY80HlWy6j4=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LU7ktfu7pQJk32rC+ID1jn6wW7dBcdSWPY6jjzL/GEr+EG02dX6qU++jfLlW?=
 =?us-ascii?Q?fXwKPGjy7MpKh7TGW+rh2GEazCIRVoF+37ZGmzFEfoNvhRlVESoICQO0qCp9?=
 =?us-ascii?Q?+M0ebtFw5BKkcsA1SIHYNCMZ94phOrokKLlYCe1U+8JInSYO8G2uebnWM4iG?=
 =?us-ascii?Q?ZFRLNRklh0rgJOwKEN9A1oC4Dng9/r5gQdEfE2otplzY/Pf/ZqmuaiZKskUO?=
 =?us-ascii?Q?zXqJ7SfNFPF4SmVYSPrkYeKjSjpP4nB8Esv+sLJmD2Gvfz/PeQ4FJ+m7ar+2?=
 =?us-ascii?Q?T/+brq3NS0jkYQwUUpfkekx62YAp3MGPazeFtSlDtVtPjRMKQwOknrbTaZf5?=
 =?us-ascii?Q?cp+s3wWB8+Uprc964tFdWjJenyoCi9V6xN1+XPVHWJNyJ4TOx9F+1mgFAKol?=
 =?us-ascii?Q?JjDcobL/wejsxncfPA3s7khGEQdLGylDN+gVR+cPQc5v1UA80wBb1AQh9l4B?=
 =?us-ascii?Q?TNGX14a/V9AINRErtg42bwc0ckF/k9antEJBYNkGG0etbbHNbmMSJxAzvXJe?=
 =?us-ascii?Q?iIyO2KY1EWQ3QY0G4IWsCWcn551TCARdp2NvZBlmqy66lnkos0IDMVjEQ9Tv?=
 =?us-ascii?Q?3tiVUEpf9gmDt3Z1dixY1NjNd0ZWypWVWjr+eeS0mKnn/Vjv68P2mpnN5Q5P?=
 =?us-ascii?Q?g8t5CVTi6XFQUaHkyHUCEIepMhNFC3cDh1Z09buy6UhCOcxAJbOB5As+vt5d?=
 =?us-ascii?Q?8ZdZLCaHIuJmmye7A6cFF5Ur1EcddbKNH/39zNQg2Gy7YKRafht8yZmi2BMP?=
 =?us-ascii?Q?5L/xu05KtmooJhvgqU8BN+hsfIsuurrBCc37Oj/CXRTY+1cXqEcJJimHyU/5?=
 =?us-ascii?Q?DHs6CBg78/JksAEZZ/tCDYFPeOEcXmSvPd7IRXDY4w5B4/tVzNM4qWVaFiKF?=
 =?us-ascii?Q?OzRZZdRWjwIxztLCMN8WryBqCCtm0J1pdf6Ph42b0PPV4xhHZyzHjXsQu6Yx?=
 =?us-ascii?Q?pcCAO3f7Q+f9lOrpl+BUMWJZdFUpRy9NUc+ztSwOJL5clk41c9cqwNTwjIdc?=
 =?us-ascii?Q?aTK23tqX6MOMvityokg/WKAZzJsl07IjaWMeTmVfGvkhk1ZJtRrCUUAijGZJ?=
 =?us-ascii?Q?GFJrHlbLLyQZkmWP1yPCrJtLtW+dzOfrE/bzzHwU4iT8723FIkJuxSSHPiqX?=
 =?us-ascii?Q?jYtnLYSTrZ2j8v0ihiYlQWx3Ye01xDSuOAG5aPn9XMYY60bT/zFZ/057vY2n?=
 =?us-ascii?Q?axVCspymSC4lT4WZkAEU/CL7F4uDB2AX2XwVKua6tdlY6ygLyeQ2kTUSfLAi?=
 =?us-ascii?Q?M8F608M/bz7iTgdMkXKPJefh9+lTl/S3oe8R4CXKyA=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-685f7.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a6c4fc-c2ca-4ad1-b642-08db2a3ff2ae
X-MS-Exchange-CrossTenant-AuthSource: MW5PR03MB6932.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 19:10:35.3866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB5104
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
1) Have to re-write regmap code for clockmatrix since regmap_range_cfg can't
handle offset register after 32-bit address is considered
2) Huge change to idt8a340_reg.h is due to address change from 16-bit to 32-bit
3) Have to change ptp_clockmatrix all together otherwise it would be broken

 drivers/mfd/rsmu.h               |   2 +
 drivers/mfd/rsmu_i2c.c           | 172 +++++++---
 drivers/mfd/rsmu_spi.c           |  56 ++--
 drivers/ptp/ptp_clockmatrix.c    |  37 +--
 drivers/ptp/ptp_clockmatrix.h    |  22 +-
 include/linux/mfd/idt8a340_reg.h | 532 ++++++++++++++++---------------
 include/linux/mfd/rsmu.h         |   5 +-
 7 files changed, 473 insertions(+), 353 deletions(-)

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
index 2428aaa9aaed..efece6f764a9 100644
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
-		buf[0] = (u8)(page & 0xff);
-		buf[1] = (u8)((page >> 8) & 0xff);
-		bytes = 2;
+		page = reg & RSMU_PAGE_MASK;
+		buf[0] = (u8)(page & 0xFF);
+		buf[1] = (u8)((page >> 8) & 0xFF);
+		buf[2] = (u8)((page >> 16) & 0xFF);
+		buf[3] = (u8)((page >> 24) & 0xFF);
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
diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index c9d451bf89e2..1cef3099be17 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -41,7 +41,7 @@ module_param(firmware, charp, 0);
 static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm);
 
 static inline int idtcm_read(struct idtcm *idtcm,
-			     u16 module,
+			     u32 module,
 			     u16 regaddr,
 			     u8 *buf,
 			     u16 count)
@@ -50,7 +50,7 @@ static inline int idtcm_read(struct idtcm *idtcm,
 }
 
 static inline int idtcm_write(struct idtcm *idtcm,
-			      u16 module,
+			      u32 module,
 			      u16 regaddr,
 			      u8 *buf,
 			      u16 count)
@@ -62,7 +62,8 @@ static int contains_full_configuration(struct idtcm *idtcm,
 				       const struct firmware *fw)
 {
 	struct idtcm_fwrc *rec = (struct idtcm_fwrc *)fw->data;
-	u16 scratch = IDTCM_FW_REG(idtcm->fw_ver, V520, SCRATCH);
+	u16 scratch = SCSR_ADDR(IDTCM_FW_REG(idtcm->fw_ver, V520, SCRATCH));
+	u16 gpio_control = SCSR_ADDR(GPIO_USER_CONTROL);
 	s32 full_count;
 	s32 count = 0;
 	u16 regaddr;
@@ -70,8 +71,8 @@ static int contains_full_configuration(struct idtcm *idtcm,
 	s32 len;
 
 	/* 4 bytes skipped every 0x80 */
-	full_count = (scratch - GPIO_USER_CONTROL) -
-		     ((scratch >> 7) - (GPIO_USER_CONTROL >> 7)) * 4;
+	full_count = (scratch - gpio_control) -
+		     ((scratch >> 7) - (gpio_control >> 7)) * 4;
 
 	/* If the firmware contains 'full configuration' SM_RESET can be used
 	 * to ensure proper configuration.
@@ -88,7 +89,7 @@ static int contains_full_configuration(struct idtcm *idtcm,
 		rec++;
 
 		/* Top (status registers) and bottom are read-only */
-		if (regaddr < GPIO_USER_CONTROL || regaddr >= scratch)
+		if (regaddr < gpio_control || regaddr >= scratch)
 			continue;
 
 		/* Page size 128, last 4 bytes of page skipped */
@@ -506,8 +507,8 @@ static int _sync_pll_output(struct idtcm *idtcm,
 {
 	int err;
 	u8 val;
-	u16 sync_ctrl0;
-	u16 sync_ctrl1;
+	u32 sync_ctrl0;
+	u32 sync_ctrl1;
 	u8 temp;
 
 	if (qn == 0 && qn_plus_1 == 0)
@@ -576,21 +577,21 @@ static int _sync_pll_output(struct idtcm *idtcm,
 
 	/* PLL5 can have OUT8 as second additional output. */
 	if (pll == 5 && qn_plus_1 != 0) {
-		err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
+		err = idtcm_read(idtcm, HW_Q8_CTRL_SPARE, 0,
 				 &temp, sizeof(temp));
 		if (err)
 			return err;
 
 		temp &= ~(Q9_TO_Q8_SYNC_TRIG);
 
-		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
+		err = idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
 				  &temp, sizeof(temp));
 		if (err)
 			return err;
 
 		temp |= Q9_TO_Q8_SYNC_TRIG;
 
-		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
+		err = idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
 				  &temp, sizeof(temp));
 		if (err)
 			return err;
@@ -598,21 +599,21 @@ static int _sync_pll_output(struct idtcm *idtcm,
 
 	/* PLL6 can have OUT11 as second additional output. */
 	if (pll == 6 && qn_plus_1 != 0) {
-		err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
+		err = idtcm_read(idtcm, HW_Q11_CTRL_SPARE, 0,
 				 &temp, sizeof(temp));
 		if (err)
 			return err;
 
 		temp &= ~(Q10_TO_Q11_SYNC_TRIG);
 
-		err = idtcm_write(idtcm, 0, HW_Q11_CTRL_SPARE,
+		err = idtcm_write(idtcm, HW_Q11_CTRL_SPARE, 0,
 				  &temp, sizeof(temp));
 		if (err)
 			return err;
 
 		temp |= Q10_TO_Q11_SYNC_TRIG;
 
-		err = idtcm_write(idtcm, 0, HW_Q11_CTRL_SPARE,
+		err = idtcm_write(idtcm, HW_Q11_CTRL_SPARE, 0,
 				  &temp, sizeof(temp));
 		if (err)
 			return err;
@@ -637,7 +638,7 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 	u8 temp;
 	u16 output_mask = channel->output_mask;
 
-	err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
+	err = idtcm_read(idtcm, HW_Q8_CTRL_SPARE, 0,
 			 &temp, sizeof(temp));
 	if (err)
 		return err;
@@ -646,7 +647,7 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 	    Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
 		out8_mux = 1;
 
-	err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
+	err = idtcm_read(idtcm, HW_Q11_CTRL_SPARE, 0,
 			 &temp, sizeof(temp));
 	if (err)
 		return err;
@@ -1303,14 +1304,14 @@ static int idtcm_load_firmware(struct idtcm *idtcm,
 			err = 0;
 
 			/* Top (status registers) and bottom are read-only */
-			if (regaddr < GPIO_USER_CONTROL || regaddr >= scratch)
+			if (regaddr < SCSR_ADDR(GPIO_USER_CONTROL) || regaddr >= scratch)
 				continue;
 
 			/* Page size 128, last 4 bytes of page skipped */
 			if ((loaddr > 0x7b && loaddr <= 0x7f) || loaddr > 0xfb)
 				continue;
 
-			err = idtcm_write(idtcm, regaddr, 0, &val, sizeof(val));
+			err = idtcm_write(idtcm, SCSR_BASE, regaddr, &val, sizeof(val));
 		}
 
 		if (err)
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index bf1e49409844..cea871f3d5db 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -54,8 +54,6 @@
 #define LOCK_TIMEOUT_MS			(2000)
 #define LOCK_POLL_INTERVAL_MS		(10)
 
-#define IDTCM_MAX_WRITE_COUNT		(512)
-
 #define PHASE_PULL_IN_MAX_PPB		(144000)
 #define PHASE_PULL_IN_MIN_THRESHOLD_NS	(2)
 
@@ -84,16 +82,16 @@ struct idtcm_channel {
 	struct ptp_clock_info	caps;
 	struct ptp_clock	*ptp_clock;
 	struct idtcm		*idtcm;
-	u16			dpll_phase;
-	u16			dpll_freq;
-	u16			dpll_n;
-	u16			dpll_ctrl_n;
-	u16			dpll_phase_pull_in;
-	u16			tod_read_primary;
-	u16			tod_read_secondary;
-	u16			tod_write;
-	u16			tod_n;
-	u16			hw_dpll_n;
+	u32			dpll_phase;
+	u32			dpll_freq;
+	u32			dpll_n;
+	u32			dpll_ctrl_n;
+	u32			dpll_phase_pull_in;
+	u32			tod_read_primary;
+	u32			tod_read_secondary;
+	u32			tod_write;
+	u32			tod_n;
+	u32			hw_dpll_n;
 	u8			sync_src;
 	enum ptp_pll_mode	mode;
 	int			(*configure_write_frequency)(struct idtcm_channel *channel);
diff --git a/include/linux/mfd/idt8a340_reg.h b/include/linux/mfd/idt8a340_reg.h
index 0c706085c205..ab32ebc6f459 100644
--- a/include/linux/mfd/idt8a340_reg.h
+++ b/include/linux/mfd/idt8a340_reg.h
@@ -7,20 +7,20 @@
 #ifndef HAVE_IDT8A340_REG
 #define HAVE_IDT8A340_REG
 
-#define PAGE_ADDR_BASE                    0x0000
-#define PAGE_ADDR                         0x00fc
+#define SCSR_BASE			  0x20100000
+#define SCSR_ADDR(x)			  ((x) & 0xffff)
 
-#define HW_REVISION                       0x8180
+#define HW_REVISION                       0x20108180
 #define REV_ID                            0x007a
 
-#define HW_DPLL_0                         (0x8a00)
-#define HW_DPLL_1                         (0x8b00)
-#define HW_DPLL_2                         (0x8c00)
-#define HW_DPLL_3                         (0x8d00)
-#define HW_DPLL_4                         (0x8e00)
-#define HW_DPLL_5                         (0x8f00)
-#define HW_DPLL_6                         (0x9000)
-#define HW_DPLL_7                         (0x9100)
+#define HW_DPLL_0                         (0x20108a00)
+#define HW_DPLL_1                         (0x20108b00)
+#define HW_DPLL_2                         (0x20108c00)
+#define HW_DPLL_3                         (0x20108d00)
+#define HW_DPLL_4                         (0x20108e00)
+#define HW_DPLL_5                         (0x20108f00)
+#define HW_DPLL_6                         (0x20109000)
+#define HW_DPLL_7                         (0x20109100)
 
 #define HW_DPLL_TOD_SW_TRIG_ADDR__0       (0x080)
 #define HW_DPLL_TOD_CTRL_1                (0x089)
@@ -28,22 +28,22 @@
 #define HW_DPLL_TOD_OVR__0                (0x098)
 #define HW_DPLL_TOD_OUT_0__0              (0x0B0)
 
-#define HW_Q0_Q1_CH_SYNC_CTRL_0           (0xa740)
-#define HW_Q0_Q1_CH_SYNC_CTRL_1           (0xa741)
-#define HW_Q2_Q3_CH_SYNC_CTRL_0           (0xa742)
-#define HW_Q2_Q3_CH_SYNC_CTRL_1           (0xa743)
-#define HW_Q4_Q5_CH_SYNC_CTRL_0           (0xa744)
-#define HW_Q4_Q5_CH_SYNC_CTRL_1           (0xa745)
-#define HW_Q6_Q7_CH_SYNC_CTRL_0           (0xa746)
-#define HW_Q6_Q7_CH_SYNC_CTRL_1           (0xa747)
-#define HW_Q8_CH_SYNC_CTRL_0              (0xa748)
-#define HW_Q8_CH_SYNC_CTRL_1              (0xa749)
-#define HW_Q9_CH_SYNC_CTRL_0              (0xa74a)
-#define HW_Q9_CH_SYNC_CTRL_1              (0xa74b)
-#define HW_Q10_CH_SYNC_CTRL_0             (0xa74c)
-#define HW_Q10_CH_SYNC_CTRL_1             (0xa74d)
-#define HW_Q11_CH_SYNC_CTRL_0             (0xa74e)
-#define HW_Q11_CH_SYNC_CTRL_1             (0xa74f)
+#define HW_Q0_Q1_CH_SYNC_CTRL_0           (0x2010a740)
+#define HW_Q0_Q1_CH_SYNC_CTRL_1           (0x2010a741)
+#define HW_Q2_Q3_CH_SYNC_CTRL_0           (0x2010a742)
+#define HW_Q2_Q3_CH_SYNC_CTRL_1           (0x2010a743)
+#define HW_Q4_Q5_CH_SYNC_CTRL_0           (0x2010a744)
+#define HW_Q4_Q5_CH_SYNC_CTRL_1           (0x2010a745)
+#define HW_Q6_Q7_CH_SYNC_CTRL_0           (0x2010a746)
+#define HW_Q6_Q7_CH_SYNC_CTRL_1           (0x2010a747)
+#define HW_Q8_CH_SYNC_CTRL_0              (0x2010a748)
+#define HW_Q8_CH_SYNC_CTRL_1              (0x2010a749)
+#define HW_Q9_CH_SYNC_CTRL_0              (0x2010a74a)
+#define HW_Q9_CH_SYNC_CTRL_1              (0x2010a74b)
+#define HW_Q10_CH_SYNC_CTRL_0             (0x2010a74c)
+#define HW_Q10_CH_SYNC_CTRL_1             (0x2010a74d)
+#define HW_Q11_CH_SYNC_CTRL_0             (0x2010a74e)
+#define HW_Q11_CH_SYNC_CTRL_1             (0x2010a74f)
 
 #define SYNC_SOURCE_DPLL0_TOD_PPS	0x14
 #define SYNC_SOURCE_DPLL1_TOD_PPS	0x15
@@ -58,8 +58,8 @@
 #define SYNCTRL1_Q1_DIV_SYNC_TRIG	BIT(1)
 #define SYNCTRL1_Q0_DIV_SYNC_TRIG	BIT(0)
 
-#define HW_Q8_CTRL_SPARE  (0xa7d4)
-#define HW_Q11_CTRL_SPARE (0xa7ec)
+#define HW_Q8_CTRL_SPARE  (0x2010a7d4)
+#define HW_Q11_CTRL_SPARE (0x2010a7ec)
 
 /**
  * Select FOD5 as sync_trigger for Q8 divider.
@@ -95,12 +95,12 @@
  */
 #define Q10_TO_Q11_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK  (BIT(0) | BIT(2))
 
-#define RESET_CTRL                        0xc000
+#define RESET_CTRL                        0x2010c000
 #define SM_RESET                          0x0012
 #define SM_RESET_V520                     0x0013
 #define SM_RESET_CMD                      0x5A
 
-#define GENERAL_STATUS                    0xc014
+#define GENERAL_STATUS                    0x2010c014
 #define BOOT_STATUS                       0x0000
 #define HW_REV_ID                         0x000A
 #define BOND_ID                           0x000B
@@ -115,7 +115,7 @@
 #define PRODUCT_ID                        0x001e
 #define OTP_SCSR_CONFIG_SELECT            0x0022
 
-#define STATUS                            0xc03c
+#define STATUS                            0x2010c03c
 #define DPLL0_STATUS			  0x0018
 #define DPLL1_STATUS			  0x0019
 #define DPLL2_STATUS			  0x001a
@@ -138,60 +138,62 @@
 #define USER_GPIO0_TO_7_STATUS            0x008a
 #define USER_GPIO8_TO_15_STATUS           0x008b
 
-#define GPIO_USER_CONTROL                 0xc160
+#define GPIO_USER_CONTROL                 0x2010c160
 #define GPIO0_TO_7_OUT                    0x0000
 #define GPIO8_TO_15_OUT                   0x0001
 #define GPIO0_TO_7_OUT_V520               0x0002
 #define GPIO8_TO_15_OUT_V520              0x0003
 
-#define STICKY_STATUS_CLEAR               0xc164
-
-#define GPIO_TOD_NOTIFICATION_CLEAR       0xc16c
-
-#define ALERT_CFG                         0xc188
-
-#define SYS_DPLL_XO                       0xc194
-
-#define SYS_APLL                          0xc19c
-
-#define INPUT_0                           0xc1b0
-#define INPUT_1                           0xc1c0
-#define INPUT_2                           0xc1d0
-#define INPUT_3                           0xc200
-#define INPUT_4                           0xc210
-#define INPUT_5                           0xc220
-#define INPUT_6                           0xc230
-#define INPUT_7                           0xc240
-#define INPUT_8                           0xc250
-#define INPUT_9                           0xc260
-#define INPUT_10                          0xc280
-#define INPUT_11                          0xc290
-#define INPUT_12                          0xc2a0
-#define INPUT_13                          0xc2b0
-#define INPUT_14                          0xc2c0
-#define INPUT_15                          0xc2d0
-
-#define REF_MON_0                         0xc2e0
-#define REF_MON_1                         0xc2ec
-#define REF_MON_2                         0xc300
-#define REF_MON_3                         0xc30c
-#define REF_MON_4                         0xc318
-#define REF_MON_5                         0xc324
-#define REF_MON_6                         0xc330
-#define REF_MON_7                         0xc33c
-#define REF_MON_8                         0xc348
-#define REF_MON_9                         0xc354
-#define REF_MON_10                        0xc360
-#define REF_MON_11                        0xc36c
-#define REF_MON_12                        0xc380
-#define REF_MON_13                        0xc38c
-#define REF_MON_14                        0xc398
-#define REF_MON_15                        0xc3a4
-
-#define DPLL_0                            0xc3b0
+#define STICKY_STATUS_CLEAR               0x2010c164
+
+#define GPIO_TOD_NOTIFICATION_CLEAR       0x2010c16c
+
+#define ALERT_CFG                         0x2010c188
+
+#define SYS_DPLL_XO                       0x2010c194
+
+#define SYS_APLL                          0x2010c19c
+
+#define INPUT_0                           0x2010c1b0
+#define INPUT_1                           0x2010c1c0
+#define INPUT_2                           0x2010c1d0
+#define INPUT_3                           0x2010c200
+#define INPUT_4                           0x2010c210
+#define INPUT_5                           0x2010c220
+#define INPUT_6                           0x2010c230
+#define INPUT_7                           0x2010c240
+#define INPUT_8                           0x2010c250
+#define INPUT_9                           0x2010c260
+#define INPUT_10                          0x2010c280
+#define INPUT_11                          0x2010c290
+#define INPUT_12                          0x2010c2a0
+#define INPUT_13                          0x2010c2b0
+#define INPUT_14                          0x2010c2c0
+#define INPUT_15                          0x2010c2d0
+
+#define REF_MON_0                         0x2010c2e0
+#define REF_MON_1                         0x2010c2ec
+#define REF_MON_2                         0x2010c300
+#define REF_MON_3                         0x2010c30c
+#define REF_MON_4                         0x2010c318
+#define REF_MON_5                         0x2010c324
+#define REF_MON_6                         0x2010c330
+#define REF_MON_7                         0x2010c33c
+#define REF_MON_8                         0x2010c348
+#define REF_MON_9                         0x2010c354
+#define REF_MON_10                        0x2010c360
+#define REF_MON_11                        0x2010c36c
+#define REF_MON_12                        0x2010c380
+#define REF_MON_13                        0x2010c38c
+#define REF_MON_14                        0x2010c398
+#define REF_MON_15                        0x2010c3a4
+
+#define DPLL_0                            0x2010c3b0
 #define DPLL_CTRL_REG_0                   0x0002
 #define DPLL_CTRL_REG_1                   0x0003
 #define DPLL_CTRL_REG_2                   0x0004
+#define DPLL_WF_TIMER                     0x002c
+#define DPLL_WP_TIMER                     0x002e
 #define DPLL_TOD_SYNC_CFG                 0x0031
 #define DPLL_COMBO_SLAVE_CFG_0            0x0032
 #define DPLL_COMBO_SLAVE_CFG_1            0x0033
@@ -200,69 +202,69 @@
 #define DPLL_PHASE_MEASUREMENT_CFG        0x0036
 #define DPLL_MODE                         0x0037
 #define DPLL_MODE_V520                    0x003B
-#define DPLL_1                            0xc400
-#define DPLL_2                            0xc438
-#define DPLL_2_V520                       0xc43c
-#define DPLL_3                            0xc480
-#define DPLL_4                            0xc4b8
-#define DPLL_4_V520                       0xc4bc
-#define DPLL_5                            0xc500
-#define DPLL_6                            0xc538
-#define DPLL_6_V520                       0xc53c
-#define DPLL_7                            0xc580
-#define SYS_DPLL                          0xc5b8
-#define SYS_DPLL_V520                     0xc5bc
-
-#define DPLL_CTRL_0                       0xc600
+#define DPLL_1                            0x2010c400
+#define DPLL_2                            0x2010c438
+#define DPLL_2_V520                       0x2010c43c
+#define DPLL_3                            0x2010c480
+#define DPLL_4                            0x2010c4b8
+#define DPLL_4_V520                       0x2010c4bc
+#define DPLL_5                            0x2010c500
+#define DPLL_6                            0x2010c538
+#define DPLL_6_V520                       0x2010c53c
+#define DPLL_7                            0x2010c580
+#define SYS_DPLL                          0x2010c5b8
+#define SYS_DPLL_V520                     0x2010c5bc
+
+#define DPLL_CTRL_0                       0x2010c600
 #define DPLL_CTRL_DPLL_MANU_REF_CFG       0x0001
 #define DPLL_CTRL_DPLL_FOD_FREQ           0x001c
 #define DPLL_CTRL_COMBO_MASTER_CFG        0x003a
-#define DPLL_CTRL_1                       0xc63c
-#define DPLL_CTRL_2                       0xc680
-#define DPLL_CTRL_3                       0xc6bc
-#define DPLL_CTRL_4                       0xc700
-#define DPLL_CTRL_5                       0xc73c
-#define DPLL_CTRL_6                       0xc780
-#define DPLL_CTRL_7                       0xc7bc
-#define SYS_DPLL_CTRL                     0xc800
-
-#define DPLL_PHASE_0                      0xc818
+#define DPLL_CTRL_1                       0x2010c63c
+#define DPLL_CTRL_2                       0x2010c680
+#define DPLL_CTRL_3                       0x2010c6bc
+#define DPLL_CTRL_4                       0x2010c700
+#define DPLL_CTRL_5                       0x2010c73c
+#define DPLL_CTRL_6                       0x2010c780
+#define DPLL_CTRL_7                       0x2010c7bc
+#define SYS_DPLL_CTRL                     0x2010c800
+
+#define DPLL_PHASE_0                      0x2010c818
 /* Signed 42-bit FFO in units of 2^(-53) */
 #define DPLL_WR_PHASE                     0x0000
-#define DPLL_PHASE_1                      0xc81c
-#define DPLL_PHASE_2                      0xc820
-#define DPLL_PHASE_3                      0xc824
-#define DPLL_PHASE_4                      0xc828
-#define DPLL_PHASE_5                      0xc82c
-#define DPLL_PHASE_6                      0xc830
-#define DPLL_PHASE_7                      0xc834
-
-#define DPLL_FREQ_0                       0xc838
+#define DPLL_PHASE_1                      0x2010c81c
+#define DPLL_PHASE_2                      0x2010c820
+#define DPLL_PHASE_3                      0x2010c824
+#define DPLL_PHASE_4                      0x2010c828
+#define DPLL_PHASE_5                      0x2010c82c
+#define DPLL_PHASE_6                      0x2010c830
+#define DPLL_PHASE_7                      0x2010c834
+
+#define DPLL_FREQ_0                       0x2010c838
 /* Signed 42-bit FFO in units of 2^(-53) */
 #define DPLL_WR_FREQ                      0x0000
-#define DPLL_FREQ_1                       0xc840
-#define DPLL_FREQ_2                       0xc848
-#define DPLL_FREQ_3                       0xc850
-#define DPLL_FREQ_4                       0xc858
-#define DPLL_FREQ_5                       0xc860
-#define DPLL_FREQ_6                       0xc868
-#define DPLL_FREQ_7                       0xc870
-
-#define DPLL_PHASE_PULL_IN_0              0xc880
+#define DPLL_FREQ_1                       0x2010c840
+#define DPLL_FREQ_2                       0x2010c848
+#define DPLL_FREQ_3                       0x2010c850
+#define DPLL_FREQ_4                       0x2010c858
+#define DPLL_FREQ_5                       0x2010c860
+#define DPLL_FREQ_6                       0x2010c868
+#define DPLL_FREQ_7                       0x2010c870
+
+#define DPLL_PHASE_PULL_IN_0              0x2010c880
 #define PULL_IN_OFFSET                    0x0000 /* Signed 32 bit */
 #define PULL_IN_SLOPE_LIMIT               0x0004 /* Unsigned 24 bit */
 #define PULL_IN_CTRL                      0x0007
-#define DPLL_PHASE_PULL_IN_1              0xc888
-#define DPLL_PHASE_PULL_IN_2              0xc890
-#define DPLL_PHASE_PULL_IN_3              0xc898
-#define DPLL_PHASE_PULL_IN_4              0xc8a0
-#define DPLL_PHASE_PULL_IN_5              0xc8a8
-#define DPLL_PHASE_PULL_IN_6              0xc8b0
-#define DPLL_PHASE_PULL_IN_7              0xc8b8
-
-#define GPIO_CFG                          0xc8c0
+#define DPLL_PHASE_PULL_IN_1              0x2010c888
+#define DPLL_PHASE_PULL_IN_2              0x2010c890
+#define DPLL_PHASE_PULL_IN_3              0x2010c898
+#define DPLL_PHASE_PULL_IN_4              0x2010c8a0
+#define DPLL_PHASE_PULL_IN_5              0x2010c8a8
+#define DPLL_PHASE_PULL_IN_6              0x2010c8b0
+#define DPLL_PHASE_PULL_IN_7              0x2010c8b8
+
+#define GPIO_CFG                          0x2010c8c0
 #define GPIO_CFG_GBL                      0x0000
-#define GPIO_0                            0xc8c2
+#define GPIO_0                            0x2010c8c2
 #define GPIO_DCO_INC_DEC                  0x0000
 #define GPIO_OUT_CTRL_0                   0x0001
 #define GPIO_OUT_CTRL_1                   0x0002
@@ -281,25 +283,25 @@
 #define GPIO_TOD_NOTIFICATION_CFG         0x000f
 #define GPIO_CTRL                         0x0010
 #define GPIO_CTRL_V520                    0x0011
-#define GPIO_1                            0xc8d4
-#define GPIO_2                            0xc8e6
-#define GPIO_3                            0xc900
-#define GPIO_4                            0xc912
-#define GPIO_5                            0xc924
-#define GPIO_6                            0xc936
-#define GPIO_7                            0xc948
-#define GPIO_8                            0xc95a
-#define GPIO_9                            0xc980
-#define GPIO_10                           0xc992
-#define GPIO_11                           0xc9a4
-#define GPIO_12                           0xc9b6
-#define GPIO_13                           0xc9c8
-#define GPIO_14                           0xc9da
-#define GPIO_15                           0xca00
-
-#define OUT_DIV_MUX                       0xca12
-#define OUTPUT_0                          0xca14
-#define OUTPUT_0_V520                     0xca20
+#define GPIO_1                            0x2010c8d4
+#define GPIO_2                            0x2010c8e6
+#define GPIO_3                            0x2010c900
+#define GPIO_4                            0x2010c912
+#define GPIO_5                            0x2010c924
+#define GPIO_6                            0x2010c936
+#define GPIO_7                            0x2010c948
+#define GPIO_8                            0x2010c95a
+#define GPIO_9                            0x2010c980
+#define GPIO_10                           0x2010c992
+#define GPIO_11                           0x2010c9a4
+#define GPIO_12                           0x2010c9b6
+#define GPIO_13                           0x2010c9c8
+#define GPIO_14                           0x2010c9da
+#define GPIO_15                           0x2010ca00
+
+#define OUT_DIV_MUX                       0x2010ca12
+#define OUTPUT_0                          0x2010ca14
+#define OUTPUT_0_V520                     0x2010ca20
 /* FOD frequency output divider value */
 #define OUT_DIV                           0x0000
 #define OUT_DUTY_CYCLE_HIGH               0x0004
@@ -307,88 +309,88 @@
 #define OUT_CTRL_1                        0x0009
 /* Phase adjustment in FOD cycles */
 #define OUT_PHASE_ADJ                     0x000c
-#define OUTPUT_1                          0xca24
-#define OUTPUT_1_V520                     0xca30
-#define OUTPUT_2                          0xca34
-#define OUTPUT_2_V520                     0xca40
-#define OUTPUT_3                          0xca44
-#define OUTPUT_3_V520                     0xca50
-#define OUTPUT_4                          0xca54
-#define OUTPUT_4_V520                     0xca60
-#define OUTPUT_5                          0xca64
-#define OUTPUT_5_V520                     0xca80
-#define OUTPUT_6                          0xca80
-#define OUTPUT_6_V520                     0xca90
-#define OUTPUT_7                          0xca90
-#define OUTPUT_7_V520                     0xcaa0
-#define OUTPUT_8                          0xcaa0
-#define OUTPUT_8_V520                     0xcab0
-#define OUTPUT_9                          0xcab0
-#define OUTPUT_9_V520                     0xcac0
-#define OUTPUT_10                         0xcac0
-#define OUTPUT_10_V520                     0xcad0
-#define OUTPUT_11                         0xcad0
-#define OUTPUT_11_V520                    0xcae0
-
-#define SERIAL                            0xcae0
-#define SERIAL_V520                       0xcaf0
-
-#define PWM_ENCODER_0                     0xcb00
-#define PWM_ENCODER_1                     0xcb08
-#define PWM_ENCODER_2                     0xcb10
-#define PWM_ENCODER_3                     0xcb18
-#define PWM_ENCODER_4                     0xcb20
-#define PWM_ENCODER_5                     0xcb28
-#define PWM_ENCODER_6                     0xcb30
-#define PWM_ENCODER_7                     0xcb38
-#define PWM_DECODER_0                     0xcb40
-#define PWM_DECODER_1                     0xcb48
-#define PWM_DECODER_1_V520                0xcb4a
-#define PWM_DECODER_2                     0xcb50
-#define PWM_DECODER_2_V520                0xcb54
-#define PWM_DECODER_3                     0xcb58
-#define PWM_DECODER_3_V520                0xcb5e
-#define PWM_DECODER_4                     0xcb60
-#define PWM_DECODER_4_V520                0xcb68
-#define PWM_DECODER_5                     0xcb68
-#define PWM_DECODER_5_V520                0xcb80
-#define PWM_DECODER_6                     0xcb70
-#define PWM_DECODER_6_V520                0xcb8a
-#define PWM_DECODER_7                     0xcb80
-#define PWM_DECODER_7_V520                0xcb94
-#define PWM_DECODER_8                     0xcb88
-#define PWM_DECODER_8_V520                0xcb9e
-#define PWM_DECODER_9                     0xcb90
-#define PWM_DECODER_9_V520                0xcba8
-#define PWM_DECODER_10                    0xcb98
-#define PWM_DECODER_10_V520               0xcbb2
-#define PWM_DECODER_11                    0xcba0
-#define PWM_DECODER_11_V520               0xcbbc
-#define PWM_DECODER_12                    0xcba8
-#define PWM_DECODER_12_V520               0xcbc6
-#define PWM_DECODER_13                    0xcbb0
-#define PWM_DECODER_13_V520               0xcbd0
-#define PWM_DECODER_14                    0xcbb8
-#define PWM_DECODER_14_V520               0xcbda
-#define PWM_DECODER_15                    0xcbc0
-#define PWM_DECODER_15_V520               0xcbe4
-#define PWM_USER_DATA                     0xcbc8
-#define PWM_USER_DATA_V520                0xcbf0
-
-#define TOD_0                             0xcbcc
-#define TOD_0_V520                        0xcc00
+#define OUTPUT_1                          0x2010ca24
+#define OUTPUT_1_V520                     0x2010ca30
+#define OUTPUT_2                          0x2010ca34
+#define OUTPUT_2_V520                     0x2010ca40
+#define OUTPUT_3                          0x2010ca44
+#define OUTPUT_3_V520                     0x2010ca50
+#define OUTPUT_4                          0x2010ca54
+#define OUTPUT_4_V520                     0x2010ca60
+#define OUTPUT_5                          0x2010ca64
+#define OUTPUT_5_V520                     0x2010ca80
+#define OUTPUT_6                          0x2010ca80
+#define OUTPUT_6_V520                     0x2010ca90
+#define OUTPUT_7                          0x2010ca90
+#define OUTPUT_7_V520                     0x2010caa0
+#define OUTPUT_8                          0x2010caa0
+#define OUTPUT_8_V520                     0x2010cab0
+#define OUTPUT_9                          0x2010cab0
+#define OUTPUT_9_V520                     0x2010cac0
+#define OUTPUT_10                         0x2010cac0
+#define OUTPUT_10_V520                    0x2010cad0
+#define OUTPUT_11                         0x2010cad0
+#define OUTPUT_11_V520                    0x2010cae0
+
+#define SERIAL                            0x2010cae0
+#define SERIAL_V520                       0x2010caf0
+
+#define PWM_ENCODER_0                     0x2010cb00
+#define PWM_ENCODER_1                     0x2010cb08
+#define PWM_ENCODER_2                     0x2010cb10
+#define PWM_ENCODER_3                     0x2010cb18
+#define PWM_ENCODER_4                     0x2010cb20
+#define PWM_ENCODER_5                     0x2010cb28
+#define PWM_ENCODER_6                     0x2010cb30
+#define PWM_ENCODER_7                     0x2010cb38
+#define PWM_DECODER_0                     0x2010cb40
+#define PWM_DECODER_1                     0x2010cb48
+#define PWM_DECODER_1_V520                0x2010cb4a
+#define PWM_DECODER_2                     0x2010cb50
+#define PWM_DECODER_2_V520                0x2010cb54
+#define PWM_DECODER_3                     0x2010cb58
+#define PWM_DECODER_3_V520                0x2010cb5e
+#define PWM_DECODER_4                     0x2010cb60
+#define PWM_DECODER_4_V520                0x2010cb68
+#define PWM_DECODER_5                     0x2010cb68
+#define PWM_DECODER_5_V520                0x2010cb80
+#define PWM_DECODER_6                     0x2010cb70
+#define PWM_DECODER_6_V520                0x2010cb8a
+#define PWM_DECODER_7                     0x2010cb80
+#define PWM_DECODER_7_V520                0x2010cb94
+#define PWM_DECODER_8                     0x2010cb88
+#define PWM_DECODER_8_V520                0x2010cb9e
+#define PWM_DECODER_9                     0x2010cb90
+#define PWM_DECODER_9_V520                0x2010cba8
+#define PWM_DECODER_10                    0x2010cb98
+#define PWM_DECODER_10_V520               0x2010cbb2
+#define PWM_DECODER_11                    0x2010cba0
+#define PWM_DECODER_11_V520               0x2010cbbc
+#define PWM_DECODER_12                    0x2010cba8
+#define PWM_DECODER_12_V520               0x2010cbc6
+#define PWM_DECODER_13                    0x2010cbb0
+#define PWM_DECODER_13_V520               0x2010cbd0
+#define PWM_DECODER_14                    0x2010cbb8
+#define PWM_DECODER_14_V520               0x2010cbda
+#define PWM_DECODER_15                    0x2010cbc0
+#define PWM_DECODER_15_V520               0x2010cbe4
+#define PWM_USER_DATA                     0x2010cbc8
+#define PWM_USER_DATA_V520                0x2010cbf0
+
+#define TOD_0                             0x2010cbcc
+#define TOD_0_V520                        0x2010cc00
 /* Enable TOD counter, output channel sync and even-PPS mode */
 #define TOD_CFG                           0x0000
 #define TOD_CFG_V520                      0x0001
-#define TOD_1                             0xcbce
-#define TOD_1_V520                        0xcc02
-#define TOD_2                             0xcbd0
-#define TOD_2_V520                        0xcc04
-#define TOD_3                             0xcbd2
-#define TOD_3_V520                        0xcc06
-
-#define TOD_WRITE_0                       0xcc00
-#define TOD_WRITE_0_V520                  0xcc10
+#define TOD_1                             0x2010cbce
+#define TOD_1_V520                        0x2010cc02
+#define TOD_2                             0x2010cbd0
+#define TOD_2_V520                        0x2010cc04
+#define TOD_3                             0x2010cbd2
+#define TOD_3_V520                        0x2010cc06
+
+#define TOD_WRITE_0                       0x2010cc00
+#define TOD_WRITE_0_V520                  0x2010cc10
 /* 8-bit subns, 32-bit ns, 48-bit seconds */
 #define TOD_WRITE                         0x0000
 /* Counter increments after TOD write is completed */
@@ -397,15 +399,15 @@
 #define TOD_WRITE_SELECT_CFG_0            0x000d
 /* TOD write trigger selection */
 #define TOD_WRITE_CMD                     0x000f
-#define TOD_WRITE_1                       0xcc10
-#define TOD_WRITE_1_V520                  0xcc20
-#define TOD_WRITE_2                       0xcc20
-#define TOD_WRITE_2_V520                  0xcc30
-#define TOD_WRITE_3                       0xcc30
-#define TOD_WRITE_3_V520                  0xcc40
-
-#define TOD_READ_PRIMARY_0                0xcc40
-#define TOD_READ_PRIMARY_0_V520           0xcc50
+#define TOD_WRITE_1                       0x2010cc10
+#define TOD_WRITE_1_V520                  0x2010cc20
+#define TOD_WRITE_2                       0x2010cc20
+#define TOD_WRITE_2_V520                  0x2010cc30
+#define TOD_WRITE_3                       0x2010cc30
+#define TOD_WRITE_3_V520                  0x2010cc40
+
+#define TOD_READ_PRIMARY_0                0x2010cc40
+#define TOD_READ_PRIMARY_0_V520           0x2010cc50
 /* 8-bit subns, 32-bit ns, 48-bit seconds */
 #define TOD_READ_PRIMARY_BASE             0x0000
 /* Counter increments after TOD write is completed */
@@ -415,15 +417,15 @@
 /* Read trigger selection */
 #define TOD_READ_PRIMARY_CMD              0x000e
 #define TOD_READ_PRIMARY_CMD_V520         0x000f
-#define TOD_READ_PRIMARY_1                0xcc50
-#define TOD_READ_PRIMARY_1_V520           0xcc60
-#define TOD_READ_PRIMARY_2                0xcc60
-#define TOD_READ_PRIMARY_2_V520           0xcc80
-#define TOD_READ_PRIMARY_3                0xcc80
-#define TOD_READ_PRIMARY_3_V520           0xcc90
-
-#define TOD_READ_SECONDARY_0              0xcc90
-#define TOD_READ_SECONDARY_0_V520         0xcca0
+#define TOD_READ_PRIMARY_1                0x2010cc50
+#define TOD_READ_PRIMARY_1_V520           0x2010cc60
+#define TOD_READ_PRIMARY_2                0x2010cc60
+#define TOD_READ_PRIMARY_2_V520           0x2010cc80
+#define TOD_READ_PRIMARY_3                0x2010cc80
+#define TOD_READ_PRIMARY_3_V520           0x2010cc90
+
+#define TOD_READ_SECONDARY_0              0x2010cc90
+#define TOD_READ_SECONDARY_0_V520         0x2010cca0
 /* 8-bit subns, 32-bit ns, 48-bit seconds */
 #define TOD_READ_SECONDARY_BASE           0x0000
 /* Counter increments after TOD write is completed */
@@ -434,30 +436,30 @@
 #define TOD_READ_SECONDARY_CMD            0x000e
 #define TOD_READ_SECONDARY_CMD_V520       0x000f
 
-#define TOD_READ_SECONDARY_1              0xcca0
-#define TOD_READ_SECONDARY_1_V520         0xccb0
-#define TOD_READ_SECONDARY_2              0xccb0
-#define TOD_READ_SECONDARY_2_V520         0xccc0
-#define TOD_READ_SECONDARY_3              0xccc0
-#define TOD_READ_SECONDARY_3_V520         0xccd0
+#define TOD_READ_SECONDARY_1              0x2010cca0
+#define TOD_READ_SECONDARY_1_V520         0x2010ccb0
+#define TOD_READ_SECONDARY_2              0x2010ccb0
+#define TOD_READ_SECONDARY_2_V520         0x2010ccc0
+#define TOD_READ_SECONDARY_3              0x2010ccc0
+#define TOD_READ_SECONDARY_3_V520         0x2010ccd0
 
-#define OUTPUT_TDC_CFG                    0xccd0
-#define OUTPUT_TDC_CFG_V520               0xcce0
-#define OUTPUT_TDC_0                      0xcd00
-#define OUTPUT_TDC_1                      0xcd08
-#define OUTPUT_TDC_2                      0xcd10
-#define OUTPUT_TDC_3                      0xcd18
-#define INPUT_TDC                         0xcd20
+#define OUTPUT_TDC_CFG                    0x2010ccd0
+#define OUTPUT_TDC_CFG_V520               0x2010cce0
+#define OUTPUT_TDC_0                      0x2010cd00
+#define OUTPUT_TDC_1                      0x2010cd08
+#define OUTPUT_TDC_2                      0x2010cd10
+#define OUTPUT_TDC_3                      0x2010cd18
+#define INPUT_TDC                         0x2010cd20
 
-#define SCRATCH                           0xcf50
-#define SCRATCH_V520                      0xcf4c
+#define SCRATCH                           0x2010cf50
+#define SCRATCH_V520                      0x2010cf4c
 
-#define EEPROM                            0xcf68
-#define EEPROM_V520                       0xcf64
+#define EEPROM                            0x2010cf68
+#define EEPROM_V520                       0x2010cf64
 
-#define OTP                               0xcf70
+#define OTP                               0x2010cf70
 
-#define BYTE                              0xcf80
+#define BYTE                              0x2010cf80
 
 /* Bit definitions for the MAJ_REL register */
 #define MAJOR_SHIFT                       (1)
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

