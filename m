Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB3B50B38C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445826AbiDVJGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 05:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359739AbiDVJGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:06:38 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2128.outbound.protection.outlook.com [40.107.23.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27D853712;
        Fri, 22 Apr 2022 02:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7tVaNWmi/LSMDSHYdRr6oQRRJGfaojbWmVUXsHHIPCnojleMsRnU7ZUnkvy1pnmDiwCAirZxj82qL8g7ffw77b6EpjS2nyMxRFn/gOp/BkcRq+xOR9/DA/d1drKgZn8CeXVw37TfaBUYW7AIU5u8nvwuXb8v+xIFL0B7RJlwStcWBFkjFFsczyGDxszHyAagZmqEvNP/6Mo/WG23DU9w3+A6nqceoJIHwfFInlPSd4Ut35G6NGnIfFSd7Nk88Rf0Y+ypbJSruq4wJ/u+CzOGmi83k7XqYOBmc6IokHuNX6YR+4LNdgt+AmFVCXQH79odyUlso65AQu1uiRIfTXixw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoZjLK97WI4aQlNkrx10mSm0M1CPn3sGa6ohjZnI1yk=;
 b=KuiLfrTddDRX15TCcXScsRMv8mwtuJduS5Bnx8cR3e2n0/9Pk3/egXe2h5qZLLH6ZatHJRLWhKfu8ZJ8PVZIEnC7fwzL0Q1aYCKRQPjsJpHIMclGvG2t4k/0gPJJqrw7kzB0v3dAuscgc6bvyUhkGEsstOkNiusFNWIDvh/9ZS0iK42c6hwOuQG+UhKBlfJCWpYVsViCWFlij+AL8vw+zRFm0IbhwMBZyb1ann8mkR/nse4uUColDyxDHj/YwitPnyXN8Ca/JkQRvQ5OmKs3ffm1rK63P8n3ONGlQ84suGozvPBvw3cW9hur//ytx0HrPm/10ZkNYtgXuIXtG3wrNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoZjLK97WI4aQlNkrx10mSm0M1CPn3sGa6ohjZnI1yk=;
 b=TfE2ZgRYqeAFihQbUbs8/efB7mjgXITxz9Ugr33yenez4vKPVXRXYJk2Dr5yncdom2AfCknOn6MhURK5FKcwOxjihIImMI6/zmuk/NobA+XZyEkoncBRfFcyZI6Kws+1tchd4mcmOgpeORXsAXhRuLHfVCSOq39b/9IzxhvVI2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:57::6) by
 ZR0P278MB0393.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 22 Apr 2022 09:03:41 +0000
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165]) by GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165%7]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 09:03:41 +0000
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
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/2] mwifiex: Select firmware based on strapping
Date:   Fri, 22 Apr 2022 11:03:12 +0200
Message-Id: <20220422090313.125857-2-andrejs.cainikovs@toradex.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422090313.125857-1-andrejs.cainikovs@toradex.com>
References: <20220422090313.125857-1-andrejs.cainikovs@toradex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR0P278CA0151.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::12) To GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:57::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd730d8f-22cd-46ad-6b47-08da243eff3c
X-MS-TrafficTypeDiagnostic: ZR0P278MB0393:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB0393CB1161A3F9F43A6185A7E2F79@ZR0P278MB0393.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: giSG7MwrSEDJJKI9w5gd7x0LHXmJx3Ir3+xW8m2IoBR1S0wyO16x+SEuiW0SRfTOWrvDFz9KL+Gv8YAKOtH4DW37p/ZQQKUdYgvXk40sNemW/GlfAX1AixH5nGO2latG3+Mz7To8xNuHLPSY1FiTx7yqYowIsa6zr9RvT1eYJQZWlW3iIftsORBCKEnzoAYLJn+eWK+OpHYkQsEHmLn6dCobZGoEnIIyQqEhPUg4SVyXIM6BweZsTmkC0oAMBu1WaAmzNUVVtJrzFWUdEQayB7cH2E+FE71UlqUjhYDU6ZnZW0fSjM8zTBvlPo716bQYXPTWep8vlxjzDedGhdpuw3V01scY/RefaRhdZ28oc0L4ncIYkEN7j6aV+5EgUU2VgVKc+dFjlu9ZO/vW/KRrWMkEU31toojcfcCpQX83AaDrPShgRfYWGiar1mzQLu5D4u85P5fmfz9Pc/YRCCU+W2OwBHFP/MnfJ8dzY/MgQ3V5vpEikf9PNJzFl4pl8qKpz4Ifj3ha0VOepjp6qLNMtgsBLw5scWo7TDwKeMLFDC911SEeoEiASldfeh8wUdkBn1G4i8to8RwoLGzlmdLU25Av0qmFZ4E9z0RquVBlliHh1W200coS4/2HoL6ScrNiZmIpJPCHwVSUa+8tcB7KU5a23RsHLBV1DWCJitsZffP3jl8RIhvpl+xZ9+D28apF/Y3aMnGXeftMCVq66RH5OmNSRnclLbtajlEfzMh1uwtl5adBCeJ5reUZigp2yp7mPuoX9iLC7a/la4jI2OsmCp65lT1sO7NautWUH9Db28Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(6506007)(2616005)(6512007)(86362001)(316002)(6666004)(44832011)(2906002)(5660300002)(7416002)(54906003)(26005)(1076003)(8936002)(110136005)(38100700002)(186003)(52116002)(508600001)(38350700002)(966005)(6486002)(36756003)(8676002)(4326008)(66574015)(66476007)(66556008)(66946007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjB5RmhoR1JFbG0yajZaN29id2d5RjdELzBaV2ZOc0Q4ZHhmNGFWaFVJYVZm?=
 =?utf-8?B?UjVxRGt3T0xzdS9nMjBwTGkvK1NqRGU5OHMzcGZWTFFqd3hsZFRqRzRKUys2?=
 =?utf-8?B?ZzdLbytSdzQvQ0w1TC9ZYXgydUxMbDBRQUM0NHJIOFBrdHlyZWV1QWNVdHJM?=
 =?utf-8?B?MzdUZjVMN1VCUk8vazJJbDZJelpKdStSU0Njd0NIaERxSlkyTWJRWU1QRVdW?=
 =?utf-8?B?SE5ielU3cmlQNjFtS1dSSXpndDZkODRBOGh3WWl3eTBKTnpDNnl4eU10MFl2?=
 =?utf-8?B?REtYZGlyREEvdDVWWFVVLzMvNnRCcTJaZ3Y3N21xVzZZRk13a1ZGakFiZExi?=
 =?utf-8?B?bFN5MWhWdWZsRXA4UjlicGRIcC8wajVocmZOUXRDTlNmeTIvbmVaZXc4dCt1?=
 =?utf-8?B?eXBKNkN6dEsxaExqU0M3MW80b2dXcS9BaTQzVTNTQ1ZXNUtvSEhpT1JRSU9i?=
 =?utf-8?B?QjE3VjdIWHUvMGx2Q0ZVY3p5MWp6RkRrc09vUlQ1MnhTMEcxWTI3WFlvVG9I?=
 =?utf-8?B?bmdSRWFhSTZIUytMc1FXM21iWlB5SDB2c0RaUVJua0xMTmJJNHpuSWt1T2Ny?=
 =?utf-8?B?WmZ0UnJIYTlUblBOcS8vTTZGMndGM0ZWakpFL0dSYUZMbmwrbkFwd2RBK2Nu?=
 =?utf-8?B?U2ZWRzgyR2JCMXhiRDlRN3M2REVvcWRONXZzVHJCdkVYTmVIcDRMVUdBMmFw?=
 =?utf-8?B?ZThVQ0VKdGI3UnY5Nmk1eEEvbDZTSEQvb3g1S2hxRUxEakR0bzZwL3FZUkN2?=
 =?utf-8?B?U3VubGE0YlFkbWNXRUpzVXNlZTlEQ3QrSG9oUERGcEpkdEVrQ1NwTVo5ODRx?=
 =?utf-8?B?N3VBOGN0L0swUTYyZjZMaDVmcE42MlV1TklVQUZRN25nckVlbFZtbzIxcWRL?=
 =?utf-8?B?bUorTDlwTEhZWkw1N01oTWJ0Y0tEcnMyNWJxZXNzcGVwRElXOXZ6SStzSkpV?=
 =?utf-8?B?SFlvdGM0T0gyU1BTK2FsZGtSMy9GL3dTR1lVeHZpRXB6OTRMZVRxSFB3TTdI?=
 =?utf-8?B?NGMxdnAyak9qK1FLb25NeWNJb1VxWlFVMUJyS1BGR1hsMTZuTzJ6Sm5GaG1X?=
 =?utf-8?B?TlNqLzB0STdmQUlsNlJUVEhXbk1rdjcvQ0JlRUZLZEZZc2NDcmpBYTFwRzYr?=
 =?utf-8?B?c3V3TkhpcG1OenZvbUhXbUFiK1hPOHZqWHo2ejFQTmhwNVMralh6UFVGSDVF?=
 =?utf-8?B?YmowNTFVV0hob2djN2x2TVByeHpROUZUM3FBM09tSjF3RGZiS1VMdmJVb3l6?=
 =?utf-8?B?MFUrSjVPc1VCUlhhbmtNRzN2NFI5bUUyYm1hU3MrdjBiS1BtS1VjMWV0MVFh?=
 =?utf-8?B?T3QzbHM1ZWVIeER2dGxtY1BJejk1TjNXQXFCUThrUTBpaFprcXluREl4QlhB?=
 =?utf-8?B?bWtkVWE3MzBCK0JXbzV1VExzelNrSWF4YTZrMkZZS0RjNy83K092M2FlZ2tn?=
 =?utf-8?B?TUF0REFNY09mNTByRmloWDJObVRROEx2NlhIbVdWZjJVSGpIRVRoUzV1RWhU?=
 =?utf-8?B?VTNTRlNNclhTK1c5dU9sdWJtQ05ReXpPakpVczluS2thZUEzd0pITXBkejVk?=
 =?utf-8?B?Y1BqZ0tsZ2NzK3FUTFJPUmhsSXBIWjV1YVJnWDF0S0MvMVc2M09sU0RPN2lD?=
 =?utf-8?B?aC9LSEphRExNZGN3Ukd5dEJnWm10VFlLL05RL1VLMWVFbHRnUmZGditZYWdu?=
 =?utf-8?B?RFNiM3piKzFCdU1pNkdXcVlQTmlPV1F0VTNZdlprY1N6dkE2VFJCc2hxYklQ?=
 =?utf-8?B?c2cvVTdMLytkTVlsU2RUZG4yZ1ZQTGp6VmI0Q08wNE5iNVZiS0l5aTM2cWxz?=
 =?utf-8?B?MitvYTdCZjQ0bmZ5VURKMi9xek9YYlBydkFVQXJ2Mmt5V2l1SUxpUjBxZTk5?=
 =?utf-8?B?Qnd5T2gvZk1JSVUyV2xVejhNUEVDN2paVzhrRm5SekRYbEhlMmZiZzlGVE9r?=
 =?utf-8?B?VVRZOUxpZElLM2tYVHBhUWkyYXhjaFR5MkxUUzNTcjJMRmxaTWRVVFRabnZs?=
 =?utf-8?B?TjEzNCtqdldnMWYzcVhrdmpCV3kvZmlaUzJFRFVNSUJuUVNucEh1RTRlSk1m?=
 =?utf-8?B?NGpVbmRCalBMNVdnNm1EYzlrSWp1NlVIRE0yL0QvUzFFTlhEa2Q0NEVJeHBE?=
 =?utf-8?B?blhFNG9iVG9aeGlubnFjOTc2TGQ4ZEp0NDAxLzF4S0s5L0Q5RDZxQTRqSTZI?=
 =?utf-8?B?T2ZKejBQVGJleFZUUjMrcjZGTGdiOTRYN3JqZDREL084eE5zMzdPcGI2Z3cv?=
 =?utf-8?B?bWtWZFgvUnpnRURiRE1FSW8yaCs4TjNUazdFMEQxSUZZWDdmOVBnMmdNSzVv?=
 =?utf-8?B?NjlscSttaWZ0NEErdkJ4RloxOHRVWnNuSHd3Zk1CdlZ2QzgvZWt0dlZzSmtI?=
 =?utf-8?Q?yrJRsrn+U9fZEcg0=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd730d8f-22cd-46ad-6b47-08da243eff3c
X-MS-Exchange-CrossTenant-AuthSource: GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 09:03:41.5849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vBhLL0MvdRlR03H8CtFFQJP3burn+xRsI6x2T1ckNyt9r9k5eJnVMD79PNBx0qoXiPZcO9pbwtxAAY8J19LknSxkXLWlS/CWnd77S0u6O6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0393
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 21 ++++++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/sdio.h |  5 +++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 4f3238d2a171..d26efd56be08 100644
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
@@ -283,6 +286,9 @@ static const struct mwifiex_sdio_card_reg mwifiex_reg_sd8987 = {
 	.host_int_rsr_reg = 0x4,
 	.host_int_status_reg = 0x0C,
 	.host_int_mask_reg = 0x08,
+	.host_strap_reg = 0xF4,
+	.host_strap_mask = 0x01,
+	.host_strap_value = 0x00,
 	.status_reg_0 = 0xE8,
 	.status_reg_1 = 0xE9,
 	.sdio_int_mask = 0xff,
@@ -536,6 +542,7 @@ mwifiex_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 		struct mwifiex_sdio_device *data = (void *)id->driver_data;
 
 		card->firmware = data->firmware;
+		card->firmware_sdiouart = data->firmware_sdiouart;
 		card->reg = data->reg;
 		card->max_ports = data->max_ports;
 		card->mp_agg_pkt_limit = data->mp_agg_pkt_limit;
@@ -2439,6 +2446,7 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 	int ret;
 	struct sdio_mmc_card *card = adapter->card;
 	struct sdio_func *func = card->func;
+	const char *firmware = card->firmware;
 
 	/* save adapter pointer in card */
 	card->adapter = adapter;
@@ -2455,7 +2463,18 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
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

