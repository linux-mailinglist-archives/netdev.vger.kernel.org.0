Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23394D6AB7
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiCKWsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiCKWsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:48:13 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409092AA4D4;
        Fri, 11 Mar 2022 14:23:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGaZT0QKWWc4t3cZ7N8/PMy7NQZcemTmQeKSdrKQDZ7FLiwqnl/wsrp+NJnqXtOPoelp6Uz+qZhjQeSHEs/a8TkwUZRtCmwOWweXwF9nAlFffmE0Z0lo5ZaTpQ+dQqEGAOHrL9sSO5TEvX/ruxigNJ4c747IIZxl+u2oEKzpEIB7l/iTjeyV8o3hrNbDVqQ6giMS7HhzrAbWDrOVgVu5DAOFFb7pFEN0VHEPzV5oGM2ITMPc2UdYJ5PPSeUaWXTUx5Wqixb1xb+nbsYwWXNcWyLXwl/L575KrfZqznYrZMjjOQEPy/CTdrkAuuJZFGqwDKzX2UxXC3Z095jy6loIkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/C9vDYlyxiXLunj+BA32e5b36kCBxKXOVS7RQXOZWrQ=;
 b=Gxzd+M7Yd4agD3QnYdl2JRDVayf5qoJ6ZYzI/QpA29YwXtWOGGzqHM4r4Z9rp10YmyuPmKI2F2aimSrSMreUmPC0qc/bYfBijeMEp0jk9PiJ+fXtQVFdgmv9wPM8Kt5zkyvzoKvenfgLz+TuMTI3j+SFQNxKXIb+1LmAy71JLxrgHFFFQsPfX5ff/uoWPjGYRAcGg/mAFiivabO88FFLbzCcvbEaZzK5bcxLhzz7Ak0tMO/46RXORsiNZXcMAvAv7kKh1nEQAZ1Cooo3WT9ZDb5FNyzwAE4cmHiIn6nCyLETFQ/TIY78cDf0MlYutiE/WPMtjAU3eDy37/jSiGC68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/C9vDYlyxiXLunj+BA32e5b36kCBxKXOVS7RQXOZWrQ=;
 b=aMkKOR5UiNRwIRtZR9/dXxciexJ8PluqmERtf+xKyLQXjhoxWeHxJ5tl4rYHIp9oPgHGR+NHHI6kRNj/yCUTfd3JYtRt2zgVKkXxQwnGTleWi1qI32bRiNl/MkFlPkevh0mxjzhmeRIamoL7r1eEt10WE0ix7RXELWFVK430GuQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DB7PR04MB4713.eurprd04.prod.outlook.com (2603:10a6:10:17::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 21:23:36 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5061.025; Fri, 11 Mar 2022
 21:23:36 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 6/8] dpaa2-mac: move setting up supported_interfaces into a function
Date:   Fri, 11 Mar 2022 23:22:26 +0200
Message-Id: <20220311212228.3918494-7-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 41bac1be-912a-4ef1-f58e-08da03a5675c
X-MS-TrafficTypeDiagnostic: DB7PR04MB4713:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB47131E3C850381D63C4A24CCE00C9@DB7PR04MB4713.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9kWIDTINq1y+hDw0A2OrMFD2tUwxBSjh6ef8NVyYBlaF8S1/aIxSUTKmIsbJJAxP0xFFhzSIl4JFyQ4w177c41AjRKn1YsuvJsk835L2Jo3KyXz2jFdMpLD/mZNTXxsGKRiureUyJoKJwYkUjHG0n2eQu7CNn0bTxE066cDMtA/g4Rl78cPbmpnZua1uB+0oBnoKNN1Iyb1cTaEWsBIBFPMWDcvbKoisyOB3s7E/frpsxTek1qNvW1l18IitKcDhswey4VjtI52L3yjzYKJsK1WgETzm2OBtMOeDNFeK+QyZudes5y3DEsbVoiK4+yUpdXmyr5DCIlliT6mY5G0wv5XghjhXIHu6n9GJqSd8dueZ6fYO02g4WF+yIWxdwYfh3mvsyXKz/AJ/zGg/llRyGIp3L+BXSq54tVmdB0xs/tPFJpOuKkvq60TpId4HLL/bUw0tu/jb1A81frnMOKcwvYN+0caenOO1epllnSd99HN6boBfwy9tX4FXd4YXz3rUR4K6znsuZ9rN3de7nkZi+JgGJQef5PLebdypcAhj2ugnWeXNFQxaTXz9IOeJzg7FDTlkMd6Q+Pw13EhtjQHDci4YNGm6/PYEs+pbrqv0gABNQYcgC2ftHypNNFfH1bw0v1AramTHlm3Yd5XTT1hNlqcKXBJ477P3fHB5bTXQXQTaYHsfpBXS1WQGl/k3AoI32ZkvWcYRY+rSChcpgWwig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(8936002)(7416002)(38350700002)(44832011)(8676002)(6666004)(66556008)(38100700002)(5660300002)(4326008)(66946007)(36756003)(6512007)(6506007)(52116002)(186003)(2906002)(2616005)(26005)(6486002)(86362001)(498600001)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rIeuSxq5wnxJ/DvhU8GqHkTtE98BAv3hhhtbEFq+ww7SPIwrtruD6gxEjfPB?=
 =?us-ascii?Q?kj2IRcJnvH9oXguq0UZUsc6It72Rww0DjKW9V8XlGWsMVp4KFqmE0CEpuriZ?=
 =?us-ascii?Q?Zr5TLfYBrihGlR4Ow2wFK6SsPFG6IeQQcWkGJqpMcpTaBN2PybsF1mOu2/Qt?=
 =?us-ascii?Q?JYg6qgUnxMG/HOvhAc8nZH098C0uIWSXo4/Z2p5bZsUiI6V6Jwr+qOrTAIAc?=
 =?us-ascii?Q?VD35rCC65X3Rfg0LO2Lkwh0f62bHo0bnPJsF6RrVN4Df4i0ISGC4FUY5evoc?=
 =?us-ascii?Q?7FzP0Lf/1rizzwop3+NTejyL0hpNf9xB7HELbR9qWP70htsQyXm11EukDjx6?=
 =?us-ascii?Q?KpBl+vmx3DMu2hkNiv3NKVamnX8q0okJrkfe0tk/NOlNWIoBbIIvPapdz263?=
 =?us-ascii?Q?0x9vHMVoJX5Q2+G/D2EVjTkuiXHC3qN76lb2EkrTaD4nBcc+V1yQxnZpVQmH?=
 =?us-ascii?Q?FdXPkiF7UMab31GKZl9B81qTf36bN3Oe2Co3jVR4FemWCkNnepBNaQYsLXYO?=
 =?us-ascii?Q?sDUHy0uX31RNfan++fdhyod7wTplaCdUaK5XR5Exu6jJhFWy9dBdljChdJiU?=
 =?us-ascii?Q?MOFh/nMOvkwqFsKP/i/E76BNLBkrsRtPTRBrdxMoS62dqA6yeYWZhsAkrujt?=
 =?us-ascii?Q?1xwnj13pd9S/HHU7i62+yWXERiE0kJeAPk+4yNfF3HTE26z0mD4xniSfiwGW?=
 =?us-ascii?Q?iop99Mj6dxueHCRIl9EwFwW9f4h2/KL3FovVZEs1aBjciKss4vDPotK9wiws?=
 =?us-ascii?Q?Eo07cu3TJV8N/c48TfIxEW4bYUO0pJ3ryqGcESdqwFO11WmX5Agfawj0RtdN?=
 =?us-ascii?Q?5i8BokjVijup81Xz/rS56qx+VDX85nS9erjmyGUDPCFY6kzUUYfaS3BQ8Oj/?=
 =?us-ascii?Q?6OzADTJaGIllGu36vMBF+KCYOu36YHD4SDroSZ6oAHu0NvWTatMFLhnKOTnK?=
 =?us-ascii?Q?dZaUHghbcOH9qrI0hQmtkBCH/neyePtlkkfd2Mvu5uJJfgeWOUQ2baLh2M/d?=
 =?us-ascii?Q?M1Wvi8gA7hUKBQverUnCMLoSLhm4vM18dA9sM8Q1DrVxdbN10ay/0nYjC4q8?=
 =?us-ascii?Q?7Bw4k4nsFLeDr7HaLoffJC9GTc/fOPYm+n0yrHnW0XExHQtLZD4BROPG1sOk?=
 =?us-ascii?Q?TsevQ2vEq93jUWlf+p6QgseKnxxXhB06PAag1+RC7pulKlmSBc5DRjFQ5jiW?=
 =?us-ascii?Q?6PXb+mORD5/jZImpwhHTqXim7dYQZ+nm39+9lz4ipn4a7Lj4UfzjMC3DfDE9?=
 =?us-ascii?Q?fLDFtsFc4pCpK5rvf5s0QUc4RfNLSK+7TMtvuGdRMSYP6Xwb0dGrAUG3RyOL?=
 =?us-ascii?Q?16j7Q0MO8GwBlA7W8AYzSNIckyRL+/EfxFYg9uz+1q6+BjO88ICnaTjATimd?=
 =?us-ascii?Q?0hf64Behnsgge8jy346qAa0K1bYgb7LXMCk4WCw2kLwrSBepvVuX8bvez/VZ?=
 =?us-ascii?Q?kZndlMcSJqyGHT6qI2mKBQL5jeno8g4xyLYIVfRtFPG1zgM0amXllQ+kaR+o?=
 =?us-ascii?Q?XD0r/zzduyZ9sxFQDP8yjKqKpa7fEV52mL8+bru2IpCbbxz9g1HcaXnFuzn9?=
 =?us-ascii?Q?dkonK4mIhAz0BSLKUBd1ML/nDjXSszk1TYNqnTEWeG67pXFBa+a737pabeVp?=
 =?us-ascii?Q?cq+LnIa4MGOBMDycP1V3OiE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41bac1be-912a-4ef1-f58e-08da03a5675c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:23:36.6385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmVTVZXAgB/94TOYb3hKVe9vaXKC6yC1aDYHyELJRFl75iSvAfe98hNwD8pZMggXKekdwR5WtMsi2dI2+Is4MA==
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

The logic to setup the supported interfaces will get annotated based on
what the configuration of the SerDes PLLs supports. Move the current
setup into a separate function just to try to keep it clean.

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

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 43 +++++++++++--------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c4a49bf10156..e6e758eaafea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -257,6 +257,29 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 	}
 }
 
+static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
+{
+	/* We support the current interface mode, and if we have a PCS
+	 * similar interface modes that do not require the SerDes lane to be
+	 * reconfigured.
+	 */
+	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
+	if (mac->pcs) {
+		switch (mac->if_mode) {
+		case PHY_INTERFACE_MODE_1000BASEX:
+		case PHY_INTERFACE_MODE_SGMII:
+			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
+				  mac->phylink_config.supported_interfaces);
+			__set_bit(PHY_INTERFACE_MODE_SGMII,
+				  mac->phylink_config.supported_interfaces);
+			break;
+
+		default:
+			break;
+		}
+	}
+}
+
 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
 	struct net_device *net_dev = mac->net_dev;
@@ -305,25 +328,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		MAC_10FD | MAC_100FD | MAC_1000FD | MAC_2500FD | MAC_5000FD |
 		MAC_10000FD;
 
-	/* We support the current interface mode, and if we have a PCS
-	 * similar interface modes that do not require the PLLs to be
-	 * reconfigured.
-	 */
-	__set_bit(mac->if_mode, mac->phylink_config.supported_interfaces);
-	if (mac->pcs) {
-		switch (mac->if_mode) {
-		case PHY_INTERFACE_MODE_1000BASEX:
-		case PHY_INTERFACE_MODE_SGMII:
-			__set_bit(PHY_INTERFACE_MODE_1000BASEX,
-				  mac->phylink_config.supported_interfaces);
-			__set_bit(PHY_INTERFACE_MODE_SGMII,
-				  mac->phylink_config.supported_interfaces);
-			break;
-
-		default:
-			break;
-		}
-	}
+	dpaa2_mac_set_supported_interfaces(mac);
 
 	phylink = phylink_create(&mac->phylink_config,
 				 dpmac_node, mac->if_mode,
-- 
2.33.1

