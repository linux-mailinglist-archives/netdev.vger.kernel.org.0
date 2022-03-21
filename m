Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674B34E2D77
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 17:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242728AbiCUQMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 12:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiCUQMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 12:12:17 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2120.outbound.protection.outlook.com [40.107.23.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFDD6C1CA;
        Mon, 21 Mar 2022 09:10:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdsRGyHNaVQmv3x0CIA6bWxtwCnpWqdTIZL3dCSGt4V8MWU/feUQ3Jz/joihIDcgX0xdR/IohQfV6Ich1/Jce/TL+ZgX365rS8T8FTRhNGvBU0NVcfPH20samcR+c1nYnCCch4K//i9Z8ykxf2DKNwXRAXRK/qBL4lwafGW7pLTAqEBSrEvvGdb3fnK+MoguWvuO1WsbFk0Sht3WrIwuBW81M3WUK0UMFb/CyHZB5ZOTG5dykYRIX0CV6Ps35EsipESheM9/2vxx1CfzCofq6VgIl2WgZmvrA48BDPFDiB4E0FKyFZ5Uuo42vG0mJOc09IeoSn3LVgTfhD0dOtfiYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKskZzkpTwMGsRMgJ1nM5HJHfwgawchScT+9Uj8+Jpk=;
 b=bLk24vXB+u9Pv893Mfcle1MP9ySQiQhAjkgtv6cXFvjwKIw/Ze3vtr/wguT1TsArElTSbaQJ10nc6tGkCrOTu2XUCR0cl1OUtmxSamrq8lVfEaiCBmYl7J0O2nRE3sjAtqMxr9bkY2vwlQUjQcB8Z7zM7ngLlkKHfzENMzCAxfy/FRxM9eJ4oPhH1b7Wv/db3FN/XofXhP6JekrduN2xXI2iE1bVFFhQTkUKhYw8OK/w97xrHUX8l9QVWFoq7LVS8j3iF+emnUpaoES3B88t5GaAyxiSStrKppjU20wdFiBSRMydLZvh46AMhcyT/BygJ8qvJFzRxqOGh9+Db+VzfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKskZzkpTwMGsRMgJ1nM5HJHfwgawchScT+9Uj8+Jpk=;
 b=lVhMDeypH9AQJoebl79EeSQTjsWDAHS+tMYCK2SFM7Cer4YFCKVXqCH0lbVqoUNR7Wpz9gRj5tWkBtvqIulObTjlyvQ4e+PqKa/h4H7n0y33WSft59egnzbVfknO3WpBqRRaJib+Ng1fbALDKFg0yqQ7FQDoF6+APokvU1JaPhQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from GV0P278MB0484.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:33::8) by
 ZRAP278MB0579.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3e::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Mon, 21 Mar 2022 16:10:34 +0000
Received: from GV0P278MB0484.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e071:a2dc:c5fe:31b0]) by GV0P278MB0484.CHEP278.PROD.OUTLOOK.COM
 ([fe80::e071:a2dc:c5fe:31b0%4]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 16:10:33 +0000
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
Cc:     Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: [RFC PATCH] mwifiex: Select firmware based on strapping
Date:   Mon, 21 Mar 2022 17:10:03 +0100
Message-Id: <20220321161003.39214-1-francesco.dolcini@toradex.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVAP278CA0003.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::13) To GV0P278MB0484.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:33::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd898167-910f-409f-26f9-08da0b555147
X-MS-TrafficTypeDiagnostic: ZRAP278MB0579:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0579AABA8CB420261F13EDEBE2169@ZRAP278MB0579.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3uBvu+J2G7SpSEtPbdwOA1+rOEqxra5kx7Eq/VzSs3BXpM8R5KBfDQCH4/UuoRsUN9It5HCkGrsvdg/IiZE05XrNjoIJ0o7bXyZvbQivO45dHLSAXXj0hMcTiRKid4UlOIRazvqRRqUUlnBd/eajU+7O3OkR3BC03P1d5NXGz1yv1/9kPTYw782qL/7o3i/PVKl1udebqZiENdhN6ZEjN0/VGWjTDhAYs6MOmdQNmUqMugKFJQVnwqGiJU/+BUsLvTrUoytubGkRd66MGxQuzpDoE5rt50491UDuNrFaROpxEvKEiIyCzZcnOL7hMhliUQKXD31YU44Ki8qU4wN/Duz5+C0+J5LymwSqptbcDNlaN97A4OyjR/re1HfSA5Ru3OgavKi6MCuwwM6dPSuTUdUliMkTaHGTn/xB2dB/A1HvBnoG07O9r+jB2SUfijpSIC+jgu0aQo3J13ZWlcndVdFpXgMtJMJRsQRQhXmCt81Y9HI2O6fPROrxFQ4puOxed5BMfG4S8TDz+1RxNzfzd8E84wH6OtpISwCz5EjlbptwrGClmbsWVPWYckzIYGubV6DZohH9/yVExRMf6rbtueMhBhZh0zuBZc0VlsYWxVKqOMb+wWDnTgP89UBQ/CPmMzqxT3kMsCyv8uuy/d5MfnB3LzgMjNZBpVdFXqrkHWDNpcHI8izeKma2Rf20RbCVHh+150DOv3qCo4UEDpm11pecXCMd6Ljs9y+URYhugidTnGO6GyeZj1Ai5kAD8sYLdu9NdEtLqtqVkCVGujcdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV0P278MB0484.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(366004)(186003)(26005)(8936002)(110136005)(54906003)(5660300002)(86362001)(7416002)(107886003)(2616005)(1076003)(36756003)(38100700002)(38350700002)(6666004)(52116002)(6486002)(966005)(83380400001)(44832011)(6512007)(66946007)(8676002)(66556008)(4326008)(66476007)(6506007)(2906002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y81W6Y9Cbhl6iBTleYcJFXNw/kY49VgnFmVzQvPN1BhQQmPXuxxqWE20fjA4?=
 =?us-ascii?Q?NQiPKjcxFgoHi8GtkLVJ/1Jn6Rxf4TtqsPTQ/PVYVsOzBhusKvsVmgTFzYYS?=
 =?us-ascii?Q?r3kSBktxdOT1HdvEtmvRAifpMeMUgBsOYFi6dgCTrSLrGx5AlOOzVMrMClHc?=
 =?us-ascii?Q?Ab30DImuu8N9dJJ5d9WYuR25gn8Eoi051oBT454HeDS2CSu3P4uO0U+YApCE?=
 =?us-ascii?Q?1rLsf8gtq4ax6HJBA4hVWRfpEpF5WHcKyBmGqHdqj6iyuYT5xydSeCwdcjb/?=
 =?us-ascii?Q?HNkD+UYAHIkoYDQv8ileNLIl+B2tinVr1Ch9SERtmRqsMHglhd9KfpDY+2ca?=
 =?us-ascii?Q?iW0JQt3NLolkuVGVF3ejBQ0KD9er+FQEomesEy3BF+etTKug0DMOAQcKYirU?=
 =?us-ascii?Q?4c5cp19Esvo3upvcSCapiFlRSO0Yhhr8uH8APu7ZE0dKh1eFu+9XBZt/R96v?=
 =?us-ascii?Q?nkN42LMJ/psVHuUwQcFlnEwMCQhfWWvgUsp7RP0aepx/euJb7nwJ0SmAtVhe?=
 =?us-ascii?Q?mioCe55ji1XEzvta9eRJe4Q2jwBxItvQkxp+MvcKg6MPS+Kt56LxwzPkk3Nn?=
 =?us-ascii?Q?QKEhd3NREB3s8hk4tF65QWWzyqFv1GjGd0xWYAq+JYdBOBXNc8cAAx9h2b4p?=
 =?us-ascii?Q?p+tCMRXbFE6FvxCxHMBzT2cdqS8xC+zWjTtsaHrrMDiCfh8uNjw8odpn3hrN?=
 =?us-ascii?Q?copK6ccdGxTuxJnbUsJO0ZOHxhBFN3RMyEC9PQYcsQEeGlwoXqFjZI7iebG5?=
 =?us-ascii?Q?63NP9VmUjDzZR/WKNzQHU4tXjpBVdjDLh75cOCRwJ1r5066PllCSCxKNPUwn?=
 =?us-ascii?Q?YrI8cOcaRkOY0ByocpUz7ijCKciqnK60XeJGZLhCRDIyiJtzZZi4E+bVID17?=
 =?us-ascii?Q?6JpGrnzk3+DxqcqhxPL8Vr9fmEZ08Fh0bL7SKmIJ1tsUWpQc17v6nq7WrOyb?=
 =?us-ascii?Q?FYwsVl8EAMpXLyHp3I/srBn36CqneXRieK2p06dQzEgTq0Mp+YJh9+dsdd5j?=
 =?us-ascii?Q?SdpacZrEScev0RgQUddfm4JWZwnX6CL+vJ3gkb+hR0Au+Y9nSTWJx/tGW1yt?=
 =?us-ascii?Q?ySpE37w084WNjWFpVteHpYgjQURho7synjvV8lx24Yg9T3Gab3tszTUVQWin?=
 =?us-ascii?Q?ax6AaybSmGvvO7WPQP7lSi7UWmc4pE1QdU8ObSsaqPGSfU8N1ihkGkrT2MyU?=
 =?us-ascii?Q?K8lj1ubKxRL3t35KzrIjH2SNRLQsDf1v/nHRMBLSm7w64lKaJFbIkz/V4GOy?=
 =?us-ascii?Q?JBgjZIbsDS8JRgkJetb9XKyutrljNDRKSH2fd0TUqsLnmfKTrCA8xb2n9x7d?=
 =?us-ascii?Q?0GhI8ib2OpY+Ivxa9EGW6JVP233vJ2lsgBqKVGpbhUpKRZ7pGmqnH36bxTKG?=
 =?us-ascii?Q?7FABoFy2xft0exWHZC+AK6C/1b794tKcTgZ9JZBiHHrNs0/v8wGWNne/mBJm?=
 =?us-ascii?Q?hFzIqlxHDmDbkpkt70rG/19Stm5k+yTLL9g/XqrXymb7icApP/1O6g=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd898167-910f-409f-26f9-08da0b555147
X-MS-Exchange-CrossTenant-AuthSource: GV0P278MB0484.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 16:10:33.4161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4MeMhSdzS9KeyjKL3qKu+jhwJjGOb8TvOIeOaanWclDWalIYzuHQCePMyqBSQcCFc76SKx/o+L7dcmGE2PsKuq0N6DG/FbFF7lar7Ilw0w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>

Some WiFi/Bluetooth modules might have different host connection
options, allowing to either use SDIO for both WiFi and Bluetooth,
or SDIO for WiFi and UART for Bluetooth. It is possible to detect
whether a module has SDIO-SDIO or SDIO-UART connection by reading
its host strap register.

This change introduces a way to automatically select appropriate
firmware depending of the connection method, and removes a need
of symlinking or overwriting the original firmware file with a
required one.

Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
Hi all,

Current mwifiex_sdio implementation does not have strapping detection, which
means there's no way system will automatically detect which firmware needs to
be picked depending of the strapping. SD8997, in particular, can be strapped
for sdiosdio (Wi-Fi over SDIO, Bluetooth over SDIO) or sdiouart (Wi-Fi over
SDIO, Bluetooth over UART). What we do now - simply replace the
original sdiosdio firmware file with the one supplied by NXP [1] for sdiouart.

Of course, this is not clean, and by submitting this patch I would like to
receive your comments regarding how it would be better to implement the
strapping detection.

[1] https://github.com/NXP/imx-firmware/blob/lf-5.10.52_2.1.0/nxp/FwImage_8997_SD/sdiouart8997_combo_v4.bin

Francesco & Andrejs

---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 17 ++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/sdio.h |  6 ++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index bde9e4bbfffe..8670ded74c27 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -182,6 +182,9 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8997 = {
 	.host_int_rsr_reg = 0x4,
 	.host_int_status_reg = 0x0C,
 	.host_int_mask_reg = 0x08,
+	.host_strap_reg = 0xF4,
+	.host_strap_mask = 0x01,
+	.host_strap_value = 0x00,
 	.status_reg_0 = 0xE8,
 	.status_reg_1 = 0xE9,
 	.sdio_int_mask = 0xff,
@@ -402,6 +405,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8977 = {
 
 static const struct mwifiex_sdio_device mwifiex_sdio_sd8997 = {
 	.firmware = SD8997_DEFAULT_FW_NAME,
+	.firmware_alt_strap = SD8997_SDIOUART_FW_NAME,
 	.reg = &mwifiex_reg_sd8997,
 	.max_ports = 32,
 	.mp_agg_pkt_limit = 16,
@@ -536,6 +540,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		struct mwifiex_sdio_device *data = (void *)id->driver_data;
 
 		card->firmware = data->firmware;
+		card->firmware_alt_strap = data->firmware_alt_strap;
 		card->reg = data->reg;
 		card->max_ports = data->max_ports;
 		card->mp_agg_pkt_limit = data->mp_agg_pkt_limit;
@@ -2439,6 +2444,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	int ret;
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
+	const char *firmware = card->firmware;
 
 	/* save adapter pointer in card */
 	card->adapter = adapter;
@@ -2455,7 +2461,15 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 
-	strcpy(adapter->fw_name, card->firmware);
+	/* Select alternative firmware based on the strapping options */
+	if (card->firmware_alt_strap) {
+		u8 val;
+		mwifiex_read_reg(adapter, card->reg->host_strap_reg, &val);
+		if ((val & card->reg->host_strap_mask) == card->reg->host_strap_value)
+			firmware = card->firmware_alt_strap;
+	}
+	strcpy(adapter->fw_name, firmware);
+
 	if (card->fw_dump_enh) {
 		adapter->mem_type_mapping_tbl = generic_mem_type_map;
 		adapter->num_mem_types = 1;
@@ -3157,3 +3171,4 @@ MODULE_FIRMWARE(SD8887_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8977_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8987_DEFAULT_FW_NAME);
 MODULE_FIRMWARE(SD8997_DEFAULT_FW_NAME);
+MODULE_FIRMWARE(SD8997_SDIOUART_FW_NAME);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 5648512c9300..bfea4d5998b7 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -39,6 +39,7 @@
 #define SD8977_DEFAULT_FW_NAME "mrvl/sdsd8977_combo_v2.bin"
 #define SD8987_DEFAULT_FW_NAME "mrvl/sd8987_uapsta.bin"
 #define SD8997_DEFAULT_FW_NAME "mrvl/sdsd8997_combo_v4.bin"
+#define SD8997_SDIOUART_FW_NAME "nxp/sdiouart8997_combo_v4.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
@@ -196,6 +197,9 @@ struct mwifiex_sdio_card_reg {
 	u8 host_int_rsr_reg;
 	u8 host_int_status_reg;
 	u8 host_int_mask_reg;
+	u8 host_strap_reg;
+	u8 host_strap_mask;
+	u8 host_strap_value;
 	u8 status_reg_0;
 	u8 status_reg_1;
 	u8 sdio_int_mask;
@@ -241,6 +245,7 @@ struct sdio_mmc_card {
 
 	struct completion fw_done;
 	const char *firmware;
+	const char *firmware_alt_strap;
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
@@ -274,6 +279,7 @@ struct sdio_mmc_card {
 
 struct mwifiex_sdio_device {
 	const char *firmware;
+	const char *firmware_alt_strap;
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
-- 
2.25.1

