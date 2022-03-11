Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229104D6A53
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiCKWsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiCKWsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:48:43 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4030722C8F4;
        Fri, 11 Mar 2022 14:23:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGZgzkhcg0BaRSJ14c0KCJlCymw+ZSZQT9PtJtH6pylmlZEAslI7ZbUYJFcl9MYJaZXkGydSEKM9egphFUz0s+DSqUc/B0aHidaXhR5I8brwz/az7QX3VmuAqCcu3eat8vYFBFWJAJ/AYV3SIJ6B19MTfzK2ZJVuZ25zeZTbWTkUHU0JM3IjsmRXo/U4joYfNBoLAnhYyiQILW+tK7JEUalE0MBjCquKOY010VtNfZ0/VgfEH/a9H/uf/f40QXPh+zcUVT/dNaQmts36HtNhBi7A62FqCICP92/vdILxzLdRN+D2ufewP6uBv2IQdXaUC7p+N5QhhXhgRhCztRv3gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZsTzLfq9p6WATF/Yp7OzkfFECir4hSjzAczMCBxzSI=;
 b=WsPUGgGlB9jfTbfTNg7fJSI+A9yH+Yk2VqP2h3tqPz/qCesh1f1k9sxKp83AB3UQ3XHUhw+m74lxJfnZzou4cGpcr7GKIRlkEqPqPiXmgiSK5cLv3maev3rGTB9oqpu/KyHrTzEXJsV2G4eVb/AcqAh1rZZY0+XcKYiBM2HQM7ovH+E942M0lOHZ6W0dIEOgBz4+aYTS+4hvdfWaLexRfwbjenrgjt6CRUK1SZQACOxjz3NXVSnypnRdZxy1phpecWMXU289IXtJ4mCX6HyEHDIcJ/DZDIJAb31Nd41hrjJFNOh1jE0tzc4G063vmUAiGgLuJZMJyg5gSR9oGPCD8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ZsTzLfq9p6WATF/Yp7OzkfFECir4hSjzAczMCBxzSI=;
 b=Uyc7yxi83EkE//PI4mSgkKaijlx/bmY2RDWG0MEBeYoVKGWJS9Aj1kcD1jaM6PJ5tA7GYpz1vGmM5B9SAJ/Z0EdOB3MoQVbGm44aKgjVO58BrS2117dq0+199V42kjH+1MEQ9HPvO4q04165gu0XWWd7t79uNYqamcmJsHaYfXY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DB7PR04MB4713.eurprd04.prod.outlook.com (2603:10a6:10:17::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 21:23:35 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5061.025; Fri, 11 Mar 2022
 21:23:35 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 5/8] dpaa2-mac: retrieve API version and detect features
Date:   Fri, 11 Mar 2022 23:22:25 +0200
Message-Id: <20220311212228.3918494-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
References: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0057.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::34) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c59e054-04ac-42f3-3987-08da03a566a5
X-MS-TrafficTypeDiagnostic: DB7PR04MB4713:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB47131109177790979FBD4265E00C9@DB7PR04MB4713.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bB1z0YgV38FOH3/W383ojeR3hnfsfqS1RZgJSv32LFqI0b+Pj9sicjKMb4DOTBHaVV7r/hfUJNQNqErssojw7bpodhKrkr4DZuX/2U8NvgEJ5UiR0CGXaeVYoLCO+QXa28se7L9AAE4HmE1N+mjGXo/GQRFdCiOACo3owc3uiMOICTtrYD7rzo3nJ5WRGLqgnm9fvxxHwYrTKN1f9i76km7NbaSdkeNpP04vxQEEs/R6Am5rSxePKFREoytmBDgbYyBpjFCxuWaCfcewnjHIrDzO6/jJATzJo4k1EbAtwXX5pvzW7FbVl3S/RhSDuD5qqfpEypXulXEEABqn/ry7JI0QpTLliUSw6syI4pGPzIlnU/v43tGv7JgUH0fgYv22iYKrsc4S9UYumbqceBsuAnE2MlQ+/yIFIajPqrtnk8oyM+FFpsjJEd6ZUJWPBD1Faky0FaK60fxMgdvL4FHQb8wKw3BF0ImD2VKYwCw73io3F/MTMIuefSBoeJEnObTAXPgLQabPEUt5ZCNccF3SkqkJPvBfBWJuv8jOGNahsq8WYwVMtUOm9zmbqYy93OhCGRTK6zzGlhqmdeSimoVMX65gFy7MHUzKjEcvsIDxHkKwtSUm7D57w8Kt4kPXkKHP08dQy6MH2l8THPYWkn5XVRuoAnd4kWwfvvfFSvBmVtCjPXJJ9ibfZx7xpjAH3wQCr6KymSiqcZMbyoFr1I/L3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(8936002)(7416002)(38350700002)(44832011)(8676002)(6666004)(66556008)(38100700002)(5660300002)(4326008)(66946007)(36756003)(6512007)(6506007)(52116002)(186003)(2906002)(2616005)(26005)(6486002)(86362001)(498600001)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ay0yIheaR3wtEJSKdY/Scj9iRRCxyKyL2nFQcuKFiCoqa96/yIEchPYQUAIk?=
 =?us-ascii?Q?4KC7gZ49ftjxDxOzH7gX/f0HTvo76xOocrCG3M7R4hj2604Niy/TAJg/uQKW?=
 =?us-ascii?Q?IhvMtZuUG+daHpwFqd2sQkuwIOyfFUkpACXMm6Gk6GCxUjAm2lieLobFAZ6H?=
 =?us-ascii?Q?heXXbQimh+HiK/+P6Vcueiu9E7wHXK4OlSsabuhLsrBMiRsiwu4M+2fEp3zA?=
 =?us-ascii?Q?o2KoGtkytK3C0/iTBBdYGvlx1J1iifUHlfFQ/G990R+NhH02ka7hyz93dsyR?=
 =?us-ascii?Q?JP5RhkPUVLOJYLBHHJ4Z2wmpCCeSID4XX7VW9uW838ARm0L2p/R4Y4/wKkjK?=
 =?us-ascii?Q?+Mwa+5QNlcWBDjxy28jExqCcO3gOJag9AC5voPxXGAJxcYRsWaON2XPe6r/s?=
 =?us-ascii?Q?54Rh7cGxX1azsT6sh4HeuDuurGGiJYT+qtv7hrXXcU5SBfEyHjjOkUcPtYKw?=
 =?us-ascii?Q?oRalPebXBIYQ5MY30pRo25D+5VUaQ/UYkUEO/cNHAd9qyxqCWk8zVOmBrUMF?=
 =?us-ascii?Q?H1iSFhhWAGWpFU4NXn6LsepLxrqi8w2RZAXU5TclTVBHGJ06BEc7W6pMTNPw?=
 =?us-ascii?Q?dxLBkJHt6tHiA+iPwp2d81ENv0LqydIoQfTpGzkAxs+AyfdEjlp3BzHPjVqd?=
 =?us-ascii?Q?a5XwLyyA78A7xUoTkBYABprxlveDlvhmy7DI+DylfTc8rcil21+Quohqjfjc?=
 =?us-ascii?Q?7Q1kE23XQI8zY0OkQzQI+3Z0ITf6YXY2J9LinXapg5JAYy0xGn30FpLpMVUL?=
 =?us-ascii?Q?hhJOs4kREdLFjDY2EH21/CjixW7S9rr/J6L/BrhDkqBlOcCSrBWL/Me35szN?=
 =?us-ascii?Q?mA2r/hXcqLLYH1qj+gEc+gJAsb+rmLfBM1PPSsGGz33bctx2WkyeoWbiF86c?=
 =?us-ascii?Q?p1/n21G28mF6Z2URhAFNnfcYio9NdmKsuGHbqKjTsnpOlOyd16qEc1N1rfeo?=
 =?us-ascii?Q?pz4gvoKkG94eGI+mTA94TkUVci8h+aDbOKye0n1G5OJGZj0zgUKjzusCiiIX?=
 =?us-ascii?Q?CDTinT8q1IVZeBM+GMm+Ud5nlYLtDwxUaFkyHbcMb95lTx8goG6ynUGmYw/L?=
 =?us-ascii?Q?e84sCz1gg7eT22iP8MMtCQmGKHEfb/WpWO5OhrpIy8QfJAEEGXZoaFJs1Wjp?=
 =?us-ascii?Q?JclM2wrv+zxrifuXQziaOUd0pwmcOydMHFRA2axYuDL3xwUeK46XIrn3LAh0?=
 =?us-ascii?Q?ai6/hIJoZtp8NHqtydwoBpmJlC4CDobqRIKGe72R284tXAdDUp3/CFsvzmN1?=
 =?us-ascii?Q?WxgzOjLTEGrpdh/rIvkxX7jG1FPWoCNPmNmrgJuWMbhfFdUka3tyAmPRA1KZ?=
 =?us-ascii?Q?NEZtxG5tBHSwHclG7rDDQa+X48/jdnOAgr50YDeyA4FSiQAZInaopfo7F5xM?=
 =?us-ascii?Q?VDlzjv0s/GxzkgnrToAQ+GcclNGwnP3WYfaJpZVcwWxpLsruo8Q/nVtucGCG?=
 =?us-ascii?Q?/0mVQDSsmUsW6Zh1H8JuGEHPgaqnAYXbJbg8Y/5KEGHyPrXGFlkeTl9ebHq/?=
 =?us-ascii?Q?NnFlk3Ct+lN4rqccXEN90bC+4+BaXQ3K6/PTXjucEgqvQY9507sd/4kI3E44?=
 =?us-ascii?Q?RsBPLvTDJ6ezhwXLEVvcocPxWVAuqWGXBqwqVpGDrwejpxdGXHBbG57KjRe+?=
 =?us-ascii?Q?4oHUZY+Y1RkATrIGFXBJM58=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c59e054-04ac-42f3-3987-08da03a566a5
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:23:35.4656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rixfByF9c2DTahm2IIBriH8WFjUvCvBI63FNlL61f+ZiIr/AUGM2fS/nDuK0nbJi/RxfCSjYwLy2sJ4KeBIbfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4713
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Retrieve the API version running on the firmware and based on it detect
which features are available for usage.
The first one to be listed is the capability to change the MAC protocol
at runtime.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none
Changes in v4:
	- none
Changes in v5:
	- none

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 30 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 521f036d1c00..c4a49bf10156 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -11,6 +11,28 @@
 #define phylink_to_dpaa2_mac(config) \
 	container_of((config), struct dpaa2_mac, phylink_config)
 
+#define DPMAC_PROTOCOL_CHANGE_VER_MAJOR		4
+#define DPMAC_PROTOCOL_CHANGE_VER_MINOR		8
+
+#define DPAA2_MAC_FEATURE_PROTOCOL_CHANGE	BIT(0)
+
+static int dpaa2_mac_cmp_ver(struct dpaa2_mac *mac,
+			     u16 ver_major, u16 ver_minor)
+{
+	if (mac->ver_major == ver_major)
+		return mac->ver_minor - ver_minor;
+	return mac->ver_major - ver_major;
+}
+
+static void dpaa2_mac_detect_features(struct dpaa2_mac *mac)
+{
+	mac->features = 0;
+
+	if (dpaa2_mac_cmp_ver(mac, DPMAC_PROTOCOL_CHANGE_VER_MAJOR,
+			      DPMAC_PROTOCOL_CHANGE_VER_MINOR) >= 0)
+		mac->features |= DPAA2_MAC_FEATURE_PROTOCOL_CHANGE;
+}
+
 static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 {
 	*if_mode = PHY_INTERFACE_MODE_NA;
@@ -359,6 +381,14 @@ int dpaa2_mac_open(struct dpaa2_mac *mac)
 		goto err_close_dpmac;
 	}
 
+	err = dpmac_get_api_version(mac->mc_io, 0, &mac->ver_major, &mac->ver_minor);
+	if (err) {
+		netdev_err(net_dev, "dpmac_get_api_version() = %d\n", err);
+		goto err_close_dpmac;
+	}
+
+	dpaa2_mac_detect_features(mac);
+
 	/* Find the device node representing the MAC device and link the device
 	 * behind the associated netdev to it.
 	 */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 1331a8477fe4..d2e51d21c80c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -17,6 +17,8 @@ struct dpaa2_mac {
 	struct net_device *net_dev;
 	struct fsl_mc_io *mc_io;
 	struct dpmac_attr attr;
+	u16 ver_major, ver_minor;
+	unsigned long features;
 
 	struct phylink_config phylink_config;
 	struct phylink *phylink;
-- 
2.33.1

