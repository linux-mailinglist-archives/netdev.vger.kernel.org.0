Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9F04F8FDF
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiDHHxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiDHHxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:53:17 -0400
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2128.outbound.protection.outlook.com [40.107.24.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112AE207A1F;
        Fri,  8 Apr 2022 00:51:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=godgRYMuvcaY9HCpO/XP2mmK5mR+CCxgV8r/vKFUHfAeuwjEybBDIM1aOqzjbGVz6iwH1cVjLGFikOPD9MTf1ROtqvIIxtWAfwHuu0DXqj1+S6GFUganCIrhXGAaK6269OAXPFWY6BCyOUnXtMjPH5zJlRfHCc2P0a9XErLGFYTs3tHkcpsOeNTY5tDSwoPuMJxV1EaHu9K5qfc+ydwY0eK9bfOQkcanmBuc49gAVQ0zZeGbixYyX8hZOEe00OIjFNrcOwhV7jS7NFIjl8+z+t3HI9NbH1grHMS1p6apoSnt+f2OiRm6CbcBFsOKiaxaZV6Ai8uVpEi/F6PL5aKNXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vntxKgwio3P3xduTLf1P78GGZRL6VL+vCGbzJahz1Dk=;
 b=iJZ4LyvPeCd5MUment+dLcuScSCaIjyIVyj5Y/GV5d0ygqow65dFny05rCSlBWcrMp6TN1SXb7Eq9YrQpB9qJJWOWgmgtSRgmG2uSxmMMZGZVGn84zpa2GieOXm63Bok7bAsmN/6x0DZpI2lQm9EHyGLJIoUwv2qMc0iuFr6QXB3R66YXcaKmKk71pw3aa9V48iUInl4naQ/eeZM8yZP8U1R0hh25fVfhlWHbz5dYyKrPPwe7LrvB9xQfjnCbclYPG02Jk1rH91xkg9teAYbglmYUOtBJBWQ1LYtFXtQ9FGkBCpBnTmxGop6Jm+mDF/qqUCGlE1lzaGWKWFCQ2sysQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vntxKgwio3P3xduTLf1P78GGZRL6VL+vCGbzJahz1Dk=;
 b=FrkhZlam8Eua/0ySF+neMesQOZSYojZkElVLWHbHC2rrykR/A9aesUYTW0P+AshTh2l67SnySRL93GTIP62mN9UD0ajIqZ9KgubjFtc8MymBoA3mlBr7FcjgiIgs0NB5Ct8CukUsK5CmSKnK+IVUPUHFu8Ec2w6sjZMRYscV3Es=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:57::6) by
 ZRAP278MB0562.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Fri, 8 Apr 2022 07:51:11 +0000
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165]) by GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 07:51:11 +0000
From:   Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
To:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] mwifiex: Select firmware based on strapping
Date:   Fri,  8 Apr 2022 09:50:59 +0200
Message-Id: <20220408075100.10458-2-andrejs.cainikovs@toradex.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408075100.10458-1-andrejs.cainikovs@toradex.com>
References: <20220408075100.10458-1-andrejs.cainikovs@toradex.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0193.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::23) To GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:57::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 488b28cc-0752-4b77-b045-08da19348c94
X-MS-TrafficTypeDiagnostic: ZRAP278MB0562:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB0562A9EABD7499EA1E7536ADE2E99@ZRAP278MB0562.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: evRqny/wrLIbnXehbj0NruDMK9mmuyFnayzBJR+qmq+EoWOg4GaelPuYnrbTEz1cYM91HiVpKpqPyttW2RhOlegznHWjCjFwVUC6dY8gr2pfYiIMnUcVFktc5xe2WNIoQQTtjGi7uW+Sw2erVFuWrupsJc6V6io9vqeOV5lgfg+YQUjA1eriZOYESVQoRp6rJoRpChVYlTwGQK5Nj+dRPaHdsJfvCeybdEkSki/kf/iRL3VrTDz81psji41/b4TpNBe7tJoKalAJpT8Xq9iqPlmvTxuQJHAKk2pL9wMiPIgCLh/nQjRRLNmgBWVZhHZdNYtSH4OFxwEjZIYKNZggzqapjMWJzz7c/Of2qnnc5XOHngSJn1ZINKqcEntdOAKJy2WTZO0pq9HHjxjCRhwYRWYMnw/afQywyt0hLpfFHMmhT/nuGSNWJsjhDZyFURCoYFIpDC3odCBLaaJTHaOObW6plATHFWce3NrhkRufpKL1K9SvNjwhzOoOeu8ED/3NSIcdr0uiDdYEMLNH0mywpDqA6L3deOYGknRW9xCJgMqVHY7aYViv9onVDKYsJZ6305HBEqZDsPZm+EgXb3o24DHSJtNi/whPVPlVhRTCbyIQi9dtahn6Ay74LbDKSTmGxKXafkrEJx/l+MjO3dxxQLA1iiDNTNja7MGoj4jz+gyMkjQ5boGTtvUGAsDL9SLMz7cwrox9U7zQMob1pTHUYEBz8k8+jZz0WJt/Xw9iuLc03NG4EmSf0qmMF0sPJFgHRUpuBJcFJ3+lXYt1x0JhLVJ9GZyp8nBWbFT/4FpzLZg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(396003)(136003)(376002)(39850400004)(346002)(366004)(54906003)(6666004)(316002)(66556008)(6506007)(66946007)(66476007)(52116002)(110136005)(5660300002)(1076003)(186003)(508600001)(4326008)(6512007)(26005)(2906002)(2616005)(36756003)(966005)(8936002)(83380400001)(6486002)(7416002)(86362001)(8676002)(44832011)(38350700002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CRE8xf3ucIaWfDJjUb9fBj2ZNSqNt/2paSzFLvYFDLZj3NxLZMBW/X+EW2Vh?=
 =?us-ascii?Q?oTRWARY3pfrNB7ahc09rQhMv7UrGRBGCy18YadiY8VQiGV9iQ33ULRoJVmZO?=
 =?us-ascii?Q?XuqyIMqWievWdwAVF9nr98yoxjLhSX/FHk7Hgp5364sDaLLjoNAkN2UzYBTv?=
 =?us-ascii?Q?MJtCeUfgZDgICh+2omDHsSU0wnSRG6k5QL5s+rsvoBVN9WtUzUdSbLORVPL/?=
 =?us-ascii?Q?B/6RwyhV2ZP7xDczLR2jg+s6GGgcrTfjeWV/TEtx/Brg/02oycUYzkFz4u/o?=
 =?us-ascii?Q?uYDdnH9WZzLVsCpgNgQBS21tDuTqaldw0r8Z7/FGgedNeGTcwkJIJGUW88Z8?=
 =?us-ascii?Q?Jtx2NBgjcxoFuGNLX5hkOk0WdspnOI03QsahblDgDXGXlAg6vtnEWuMT6RSO?=
 =?us-ascii?Q?TpXl/N/VwH86ExhMjIywrQ6i14Cig6LssKv5SmoLHeB02rWXlkcOo9jCwOIx?=
 =?us-ascii?Q?3Hq1MZi+FtVhVhBSKn6Kw/dgK883QKU45NG498r8jkyDVF7VM3FfUbCFmvrQ?=
 =?us-ascii?Q?dImUHks+2PvKbHm4s3svCcTTnJc3hfvYKqGDhn/ySSImWMnR3XOqKBWF97dr?=
 =?us-ascii?Q?XLKt1HBhyeu3EVHkNRnkIrDoda2byq5UObo3us8dg1FXJ/ZETAbUbzR9nhwg?=
 =?us-ascii?Q?KSv/taQpq+jz/CB2ylGqAEIu+fp394WuazcGbeBsgocyVcBKmiamFskIAAg/?=
 =?us-ascii?Q?0MBGz/Z/0JnU4H/PGM+5NJKjutnB/RQ5ZMPVp6hdaWWMZDwZ1pwiafgTYZZB?=
 =?us-ascii?Q?0UfQ4czNYKW2/nOMel6TyyuD+Sc2lnmBvVzbOONhOGk3HPlxVozEJGLrkKxQ?=
 =?us-ascii?Q?JDt06OZXpwLpYZkqJPNzaHLf1pWJYpnHQ/NSQkng5HsVQTZiqhp/8qVFMZSw?=
 =?us-ascii?Q?QhKRSTVtm0xVZ0yv8nQrVTzESQ7MUaH6qz7QXVaY1cjCqTcxUIanlUziraGh?=
 =?us-ascii?Q?8QoN4GNLa79WAeU9uznFeHUXYwjZ/1QulRpwtK4bZZPRMw0uM/f5OCMr0XEo?=
 =?us-ascii?Q?OlIH2g8YXxFYbYE8A1K6Xgeu5AWyrNxEumVoDPFBl9rxj3p6gmpMzh9KdGKr?=
 =?us-ascii?Q?M3we0opZEhngoYyVrLoSNBakltpwfBXlHvZA1st485ACeAvCCmTx+OkyDfb4?=
 =?us-ascii?Q?fsSDyksXrRz81fqkUG/g5QEW9crDnn0PEE/aUejpRFntQOuLoS/Qn4tETUml?=
 =?us-ascii?Q?POfT9Cra3oCfFH9Bom86R1ilNhZkUHmW+cFG6JcMb/jqQqURkZg78a/wNDJ/?=
 =?us-ascii?Q?4/BJY3SXTxMc/C8vZLO6FfRNq+70SfvFv3Z4681Hc9muNnGw/ath/hS0vdRU?=
 =?us-ascii?Q?Cisyt13O0rp+U5FeLDuVwmutR+JH6Rfhl5NIk1RJz4UYuzM0o4D73kdReEsm?=
 =?us-ascii?Q?Jhr5V3johIFiE/jXPsbmbqk5wDx6nwiQUO2klcGs8yYzn+tqUTHd0rvMCujw?=
 =?us-ascii?Q?qPT0ua1seLfMdptrZ7WPxeSHWE/HR0oJMrbScC7Snh3CKYVG3TEyrQVuHamZ?=
 =?us-ascii?Q?X9V9AC7KC5Ai678AP9iH8rzT6Xh/4lDVON8fQ4jmRHRTiiGp3ypHjH/DjEmf?=
 =?us-ascii?Q?soKXrk2/DPQ/2qGCke00Wf2Zid6F4qa02ieZwSVzBjHGdUcrmJXDDIEE7Iyb?=
 =?us-ascii?Q?/W6mzdIHMMsGDfZ8UGYn5NwfapTghqhIkvFrerBCX0YvIzecs8h7ezfe4VrZ?=
 =?us-ascii?Q?JYaOnG7Nz7Z/O17ty0H3trF75Vlu51RbGI7BUYjbyOs0XitdCgIsyuAXhScF?=
 =?us-ascii?Q?8mj6e0bNBcrF4An8hvoUM/h6QL+SO6E=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 488b28cc-0752-4b77-b045-08da19348c94
X-MS-Exchange-CrossTenant-AuthSource: GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 07:51:11.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EciaBbuO89zon6OGgv5KsbPIErwGLSu//iWySoRLCxGZg/i6Hpe8xYo4jSSIdMUcS02ELe9LP5LNcD2FtSdlJsnoriwiIj6UJH7CGG2prg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0562
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some WiFi/Bluetooth modules might have different host connection
options, allowing to either use SDIO for both WiFi and Bluetooth,
or SDIO for WiFi and UART for Bluetooth. It is possible to detect
whether a module has SDIO-SDIO or SDIO-UART connection by reading
its host strap register.

This change introduces a way to automatically select appropriate
firmware depending of the connection method, and removes a need
of symlinking or overwriting the original firmware file with a
required one.

Host strap register used in this commit comes from the NXP driver [1]
hosted at Code Aurora.

[1] https://source.codeaurora.org/external/imx/linux-imx/tree/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/mlinux/moal_sdio_mmc.c?h=rel_imx_5.4.70_2.3.2&id=688b67b2c7220b01521ffe560da7eee33042c7bd#n1274

Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 18 +++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/sdio.h |  5 +++++
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index bde9e4bbfffe..23160d179485 100644
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
@@ -536,6 +539,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		struct mwifiex_sdio_device *data = (void *)id->driver_data;
 
 		card->firmware = data->firmware;
+		card->firmware_sdiouart = data->firmware_sdiouart;
 		card->reg = data->reg;
 		card->max_ports = data->max_ports;
 		card->mp_agg_pkt_limit = data->mp_agg_pkt_limit;
@@ -2439,6 +2443,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	int ret;
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
+	const char *firmware = card->firmware;
 
 	/* save adapter pointer in card */
 	card->adapter = adapter;
@@ -2455,7 +2460,18 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 
-	strcpy(adapter->fw_name, card->firmware);
+	/* Select correct firmware (sdsd or sdiouart) firmware based on the strapping
+	 * option
+	 */
+	if (card->firmware_sdiouart) {
+		u8 val;
+
+		mwifiex_read_reg(adapter, card->reg->host_strap_reg, &val);
+		if ((val & card->reg->host_strap_mask) == card->reg->host_strap_value)
+			firmware = card->firmware_sdiouart;
+	}
+	strcpy(adapter->fw_name, firmware);
+
 	if (card->fw_dump_enh) {
 		adapter->mem_type_mapping_tbl = generic_mem_type_map;
 		adapter->num_mem_types = 1;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 5648512c9300..ad2c28cbb630 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -196,6 +196,9 @@ struct mwifiex_sdio_card_reg {
 	u8 host_int_rsr_reg;
 	u8 host_int_status_reg;
 	u8 host_int_mask_reg;
+	u8 host_strap_reg;
+	u8 host_strap_mask;
+	u8 host_strap_value;
 	u8 status_reg_0;
 	u8 status_reg_1;
 	u8 sdio_int_mask;
@@ -241,6 +244,7 @@ struct sdio_mmc_card {
 
 	struct completion fw_done;
 	const char *firmware;
+	const char *firmware_sdiouart;
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
@@ -274,6 +278,7 @@ struct sdio_mmc_card {
 
 struct mwifiex_sdio_device {
 	const char *firmware;
+	const char *firmware_sdiouart;
 	const struct mwifiex_sdio_card_reg *reg;
 	u8 max_ports;
 	u8 mp_agg_pkt_limit;
-- 
2.25.1

