Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91BE65C91F
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 23:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbjACWFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 17:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233989AbjACWFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 17:05:49 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2070.outbound.protection.outlook.com [40.107.104.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1998690;
        Tue,  3 Jan 2023 14:05:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRQMWACc7cBp2bDkT0fWkMP0CEl6/yFtq9XGJQcP2yyNdY1T9jvHbZLSSapUeQGt8sYjAyzfFQOdhFbXb0ZSsbz2Q/UYdi8cbb4F57N5q0kV8LVzzYRfLSljNmV7zk4BMO5LLqf9c+3g4REUAtctrZEpNQTxcw+aTZNY5ddyDV+Pb54w9IetrXoG912B1i46uzReee2M0XWzTtKuzPgTwhh/XkJJS5kgWVNrZWTJhgN1tvm2L2321fwNkLcCTY8Zhvep6dOi+aFbtT50hTxkqldnSKfy7iXZyqBEJFvUyy8DLLRZG63uF3khgjz3SKKEcoWMYzMyG8CA3o6XAFQG4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MaM/lc8IHfnf6gwWWK15TNOSFWBfGk/Z1dMtGv56+tc=;
 b=LYSSE9l0vl9f9Ae8y5yOphR2pEPgA6QA8iJD8lYhP6xTAbYrGlQG4ukSHNgut/fIgNfCKP6OqLzLv08NQi/Wxi4TK1oXB62y3c0C58oRzZlJFKYD4AckGfJl0wSxJfAv3C8Q3H+gB8xFl3m4Nm8drIJJuOWKKSNHNxv3FSR5VOCE/s06TwZzqqAOPX5JJ2M9ZkAF8EsK7rPHCR9Fd0Cl1bu7snTaGqPoaDMiZpi2nvjbDsFuiHAvFRgS2tvD0G64bMJyEiVH1hCrFxh947nhkHvM0Oke2ACFecHSD1luJ8ycBlqk/lrTc5ctU/el6iExeys55760fduczD1Fn/a5mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaM/lc8IHfnf6gwWWK15TNOSFWBfGk/Z1dMtGv56+tc=;
 b=iP7fX9KnfD3VAv+/qSYI3ud5z1UMal4DE8xjSswZzaJ7fo8rSeuURtthYWqSrTQ6lr7ooamDztviSEkyCu5xDPMi30OxcCaa3dYA4h5QP5373hKhwL4HbGIDf4thMZd0uqaOlFFzbZYQnTD2SVbnS+WeqG+AmzJf4RVS67ZrHkB7P1b6PUl4nhX38twWq5hAnxmbuH3AKrEDL6/wvHvKlwI84Ybg2Th9p95sO//aG1Fx6Hde9u3yMMDGdzYmXt1MzTItU9/hMwjQrF+PVob6/VzoSMcCfMF7f6xAJlwCaLr6lwpFuNF2m7HyFS3dFnLyPV08xKiT3JanxHRVDfK5ZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by VI1PR03MB9900.eurprd03.prod.outlook.com (2603:10a6:800:1c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 22:05:44 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%8]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 22:05:44 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 2/4] phy: mdio: Reorganize defines
Date:   Tue,  3 Jan 2023 17:05:09 -0500
Message-Id: <20230103220511.3378316-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20230103220511.3378316-1-sean.anderson@seco.com>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0332.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::7) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|VI1PR03MB9900:EE_
X-MS-Office365-Filtering-Correlation-Id: 93e68c4e-dff7-4fc8-c806-08daedd6a939
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/1LxmL/fjClFCF2Lt8VZJVb55FsgtaJRIQbSF10TIn3hV89mQ7gg6UCd4zHRPW4oir7H/Fc0yc7VxrsQFO28Ec6uFZePuqyb3SaVj1lEQE3Pu5RLufe4c6jXK2wVyc4P9RlPhEYuzGrR1yXzJK/mu8fbiMR2bzBk7IoTp5gqGW0AWeikolu42B0gKgve4QTF3+2tcYnaMKCVAFUvCL8H5zHjhNvnWk81A6UWVHy/2Zw8T6bBul67yzDHhqecpYmky4Ia6N+IP/dXvM9uW4GszuqQuudS+aJkqz4E2iNTqCVYlLyTTn7eu8kEjQxKV2j7rwBo8DIPzSEQ2c/4WTwM73pstEqnf37hUYeVYmHwLk0xAlSMvaAj4+0XHDZnxsu2Opsaybay/9dHxw1keqlVMVUMh04Db78UOrrHmJB7pbEPn+XwAmXYyWWy1mQiSxVd3lnEwx5qOz8xxPIPoZkJto/C9zMqnM0WIs4GUIjCUhBxZKQwudtTIz2RBRFsvpeC1PCQ2p7csL0uvktMI+FgzdKTpexGbNAOGOQQY0GL0I5ipAf6sIe29yyaNkMKMHVtkynGVow/zKez4yuAQz5Xw98piZndvR5r38gwwR7R3tX35ZTd5RxeeDZg28g3Y8A4993rYPBf6mcVg9VdMzv8/IAU0k22MYwcYe3JVeQPaBBELwtOAeAYIAxwNH12dUYJh6OWQepKGWyHYIxGFFBGZIuNswjDvpDNB7hajKseUs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39840400004)(396003)(346002)(451199015)(110136005)(54906003)(26005)(186003)(52116002)(107886003)(6666004)(1076003)(2616005)(66476007)(6486002)(66556008)(66946007)(6512007)(478600001)(4326008)(83380400001)(8936002)(8676002)(30864003)(5660300002)(7416002)(41300700001)(44832011)(2906002)(316002)(38100700002)(38350700002)(86362001)(6506007)(36756003)(22166009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hK0DewAAApNUG0eX5n8b/8O9GZZ+vOj2Dz0iMYZxEQ5pHTZNzLWRYYLyFIzA?=
 =?us-ascii?Q?G7+XP/V72soOmXkDz25Y7BkwjkLfmnsMY+/DWWdOZCrMtJhsuQSa5NP089H+?=
 =?us-ascii?Q?DPfjZD7FuhuOAi0ATIXJRaI9Ut/NLzgHs1Ayfim9wI+nw2qz05Dl3hgudQSP?=
 =?us-ascii?Q?nHFi44ADxkmH3MjfWKIptv9ONJuSKexIcWM9dPVTTJZWK+aekQYVIW5ZbsSO?=
 =?us-ascii?Q?GCM+0loUnu0OUPUTFyzcQMaIW6VXrxkmZ5TEWEDGuOez5tXZNTdiB0fl42if?=
 =?us-ascii?Q?+q7034k1aiSr9M2pehs7LkZUdfIlxfJ0ooEBJ+2VIv0OH/5a1yYbGm4I6wvj?=
 =?us-ascii?Q?U5KaoJVpFhNB9ZARo7+vrnWs3oTSyEpqTe4NuV/Yt7mX+rNaGS5oZRCet2uT?=
 =?us-ascii?Q?6AxMKaHxjv5k80G1qIh994ddM4rtQGwk/H7vUYaeDMTzIP3p5XgqhaLp0Jq0?=
 =?us-ascii?Q?K0zb37UxI35GM6/zqxhiJ0aZuzSxtGCIk/WraZzJmflx0FmOr2j4VMk4IjHL?=
 =?us-ascii?Q?QdeaWjDchIiMtaAoshAy2BL54uFA0ReyUJg3Jqyaals6M1lpjP3X6gchakIv?=
 =?us-ascii?Q?Q1zj+sHk10/Ab0silPjFf8bFDcSjJf9yPozK/6jnmteOdDcMEVR6MgrEH7YC?=
 =?us-ascii?Q?P8YoOe/2SsZEqMGArf6JtJKpnUfvIryAsNsZvR7iPQYNUWuWysh5c5tTIc33?=
 =?us-ascii?Q?gSi/GSqrOFN9sbt+E7m4gcFal3QV2beU2lB8phGrh32+5lx8IPAdzBRAeTBK?=
 =?us-ascii?Q?1kXZACVHpJytGXnWaRZyYh5O36Zz5+W45gkGKc/VOqQzfOHhoG7GhZBvI5MY?=
 =?us-ascii?Q?l8P4aIN55vN8AcgcvAwPPO9lN0d9y9aexYI3QOg4A6ip7FU4N0/7yARF10OW?=
 =?us-ascii?Q?gwTv2qXKHybuUSVOHfahyYoxYpvnWu2R757WQCjXKjpGSf0KLP1/fAAClnEO?=
 =?us-ascii?Q?pb+BXmXKSUiI73TLyk0L8aYmCOJkuv9WDI7fdo17nAqvnxd1Ug6T6LlxfDe0?=
 =?us-ascii?Q?vXlBlKEY3VBQaVO+5p1mPQFvpHdC5+p4D3H6siyHc0u3951m3qvESzUp/7j4?=
 =?us-ascii?Q?Oo5chIZwLB5ZBEui0pBZRVNIQkjXhuAMCcsAPIuAly3AdwmtfGq6JHbSAkyx?=
 =?us-ascii?Q?+vNOtE8/qT83ZQxImG1updogfgfbQNPiljCcthIfeVmdpRtQeuIbv50dGSQP?=
 =?us-ascii?Q?51yFrCCUN2rrxcXEasZHvjMnpIBWTGMpEL02bbFEQQrc93l3TyCpF9GUJ6d4?=
 =?us-ascii?Q?ZCR+mWDSyQdsKGnFJrNtinKydKGKH+bC6kvSJSMAYf+JHb5zmdW67XR23SXp?=
 =?us-ascii?Q?Jt8hCxiZNG8Z2EehNiYngNV/IaAWj/Uh9iqHG/RdLHyEugu4CgmJ3Pbo/BvB?=
 =?us-ascii?Q?HJMnZJvAHbFZHruKga5emUqKzvPvD4H0p0saQLtxoYUPzn8YlxW9q9hr586H?=
 =?us-ascii?Q?ns0pZpwkATxM/VzG/ElNhG4KPSU/F8hUvM42MuXxBRyD+MWZGYOXTIagyS7Y?=
 =?us-ascii?Q?dTjYmccMR29SAdPkcb1pXnQ0eeqNOBLEfMrEOSyucv/yFesaON1+jNHKc3c0?=
 =?us-ascii?Q?LttRRkMfQW2ywlddqVr4iXnawYKrIPKbHqc+jpOWdhul36YL0iT6KGmamxZG?=
 =?us-ascii?Q?5A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e68c4e-dff7-4fc8-c806-08daedd6a939
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 22:05:44.6600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OjrtJ9g2kSoMWWy+HfAV4n9Au3lXCZ8QBLJwGjUMzGIDDvF1X+lbbAGD1bGDZ79usrDVFcuw/W2sWGBtkjFdew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB9900
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reorder all registers to be grouped by MMD. Groups fields in
similarly-named registers in the same way. This is especially useful for
registers which may have some bits in common, but interpret other bits
in different ways. The comments have been tweaked to more closely follow
802.3's naming.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v4)

Changes in v4:
- New

 include/uapi/linux/mdio.h | 102 ++++++++++++++++++++++++--------------
 1 file changed, 64 insertions(+), 38 deletions(-)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 75b7257a51e1..14b779a8577b 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -37,40 +37,47 @@
 #define MDIO_DEVS2		6
 #define MDIO_CTRL2		7	/* 10G control 2 */
 #define MDIO_STAT2		8	/* 10G status 2 */
+#define MDIO_PKGID1		14	/* Package identifier */
+#define MDIO_PKGID2		15
+
+/* PMA/PMD registers. */
 #define MDIO_PMA_TXDIS		9	/* 10G PMA/PMD transmit disable */
 #define MDIO_PMA_RXDET		10	/* 10G PMA/PMD receive signal detect */
 #define MDIO_PMA_EXTABLE	11	/* 10G PMA/PMD extended ability */
-#define MDIO_PKGID1		14	/* Package identifier */
-#define MDIO_PKGID2		15
-#define MDIO_AN_ADVERTISE	16	/* AN advertising (base page) */
-#define MDIO_AN_LPA		19	/* AN LP abilities (base page) */
-#define MDIO_PCS_EEE_ABLE	20	/* EEE Capability register */
-#define MDIO_PCS_EEE_ABLE2	21	/* EEE Capability register 2 */
+#define MDIO_PMA_PMD_BT1	18	/* BASE-T1 PMA/PMD extended ability */
 #define MDIO_PMA_NG_EXTABLE	21	/* 2.5G/5G PMA/PMD extended ability */
-#define MDIO_PCS_EEE_WK_ERR	22	/* EEE wake error counter */
-#define MDIO_PHYXS_LNSTAT	24	/* PHY XGXS lane state */
-#define MDIO_AN_EEE_ADV		60	/* EEE advertisement */
-#define MDIO_AN_EEE_LPABLE	61	/* EEE link partner ability */
-#define MDIO_AN_EEE_ADV2	62	/* EEE advertisement 2 */
-#define MDIO_AN_EEE_LPABLE2	63	/* EEE link partner ability 2 */
-#define MDIO_AN_CTRL2		64	/* AN THP bypass request control */
-
-/* Media-dependent registers. */
 #define MDIO_PMA_10GBT_SWAPPOL	130	/* 10GBASE-T pair swap & polarity */
 #define MDIO_PMA_10GBT_TXPWR	131	/* 10GBASE-T TX power control */
 #define MDIO_PMA_10GBT_SNR	133	/* 10GBASE-T SNR margin, lane A.
 					 * Lanes B-D are numbered 134-136. */
 #define MDIO_PMA_10GBR_FSRT_CSR	147	/* 10GBASE-R fast retrain status and control */
 #define MDIO_PMA_10GBR_FECABLE	170	/* 10GBASE-R FEC ability */
+#define MDIO_PMA_PMD_BT1_CTRL	2100	/* BASE-T1 PMA/PMD control register */
+#define MDIO_B10L_PMA_CTRL	2294	/* 10BASE-T1L PMA control */
+#define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
+
+/* PCS registers */
+#define MDIO_PCS_EEE_ABLE	20	/* EEE Capability register */
+#define MDIO_PCS_EEE_ABLE2	21	/* EEE Capability register 2 */
+#define MDIO_PCS_EEE_WK_ERR	22	/* EEE wake error counter */
 #define MDIO_PCS_10GBX_STAT1	24	/* 10GBASE-X PCS status 1 */
 #define MDIO_PCS_10GBRT_STAT1	32	/* 10GBASE-R/-T PCS status 1 */
 #define MDIO_PCS_10GBRT_STAT2	33	/* 10GBASE-R/-T PCS status 2 */
+#define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
+
+/* PHY XS registers */
+#define MDIO_PHYXS_LNSTAT	24	/* PHY XGXS lane state */
+
+/* Auto_negotiation registers */
+#define MDIO_AN_ADVERTISE	16	/* AN advertising (base page) */
+#define MDIO_AN_LPA		19	/* AN LP abilities (base page) */
 #define MDIO_AN_10GBT_CTRL	32	/* 10GBASE-T auto-negotiation control */
 #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
-#define MDIO_B10L_PMA_CTRL	2294	/* 10BASE-T1L PMA control */
-#define MDIO_PMA_10T1L_STAT	2295	/* 10BASE-T1L PMA status */
-#define MDIO_PCS_10T1L_CTRL	2278	/* 10BASE-T1L PCS control */
-#define MDIO_PMA_PMD_BT1	18	/* BASE-T1 PMA/PMD extended ability */
+#define MDIO_AN_EEE_ADV		60	/* EEE advertisement */
+#define MDIO_AN_EEE_LPABLE	61	/* EEE link partner ability */
+#define MDIO_AN_EEE_ADV2	62	/* EEE advertisement 2 */
+#define MDIO_AN_EEE_LPABLE2	63	/* EEE link partner ability 2 */
+#define MDIO_AN_CTRL2		64	/* AN THP bypass request control */
 #define MDIO_AN_T1_CTRL		512	/* BASE-T1 AN control */
 #define MDIO_AN_T1_STAT		513	/* BASE-T1 AN status */
 #define MDIO_AN_T1_ADV_L	514	/* BASE-T1 AN advertisement register [15:0] */
@@ -79,7 +86,6 @@
 #define MDIO_AN_T1_LP_L		517	/* BASE-T1 AN LP Base Page ability register [15:0] */
 #define MDIO_AN_T1_LP_M		518	/* BASE-T1 AN LP Base Page ability register [31:16] */
 #define MDIO_AN_T1_LP_H		519	/* BASE-T1 AN LP Base Page ability register [47:32] */
-#define MDIO_PMA_PMD_BT1_CTRL	2100	/* BASE-T1 PMA/PMD control register */
 
 /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
 #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
@@ -89,7 +95,7 @@
 #define MDIO_PMA_LASI_TXSTAT	0x9004	/* TX_ALARM status */
 #define MDIO_PMA_LASI_STAT	0x9005	/* LASI status */
 
-/* Control register 1. */
+/* Generic control 1 register. */
 /* Enable extended speed selection */
 #define MDIO_CTRL1_SPEEDSELEXT		(BMCR_SPEED1000 | BMCR_SPEED100)
 /* All speed selection bits */
@@ -97,15 +103,6 @@
 #define MDIO_CTRL1_FULLDPLX		BMCR_FULLDPLX
 #define MDIO_CTRL1_LPOWER		BMCR_PDOWN
 #define MDIO_CTRL1_RESET		BMCR_RESET
-#define MDIO_PMA_CTRL1_LOOPBACK		0x0001
-#define MDIO_PMA_CTRL1_SPEED1000	BMCR_SPEED1000
-#define MDIO_PMA_CTRL1_SPEED100		BMCR_SPEED100
-#define MDIO_PCS_CTRL1_LOOPBACK		BMCR_LOOPBACK
-#define MDIO_PHYXS_CTRL1_LOOPBACK	BMCR_LOOPBACK
-#define MDIO_AN_CTRL1_RESTART		BMCR_ANRESTART
-#define MDIO_AN_CTRL1_ENABLE		BMCR_ANENABLE
-#define MDIO_AN_CTRL1_XNP		0x2000	/* Enable extended next page */
-#define MDIO_PCS_CTRL1_CLKSTOP_EN	0x400	/* Stop the clock during LPI */
 
 /* 10 Gb/s */
 #define MDIO_CTRL1_SPEED10G		(MDIO_CTRL1_SPEEDSELEXT | 0x00)
@@ -116,10 +113,29 @@
 /* 5 Gb/s */
 #define MDIO_CTRL1_SPEED5G		(MDIO_CTRL1_SPEEDSELEXT | 0x1c)
 
-/* Status register 1. */
+/* PMA/PMD control 1 register. */
+#define MDIO_PMA_CTRL1_LOOPBACK		0x0001
+#define MDIO_PMA_CTRL1_SPEED1000	BMCR_SPEED1000
+#define MDIO_PMA_CTRL1_SPEED100		BMCR_SPEED100
+
+/* PCS control 1 register. */
+#define MDIO_PCS_CTRL1_LOOPBACK		BMCR_LOOPBACK
+#define MDIO_PCS_CTRL1_CLKSTOP_EN	0x400	/* Stop the clock during LPI */
+
+/* PHY XS control 1 register. */
+#define MDIO_PHYXS_CTRL1_LOOPBACK	BMCR_LOOPBACK
+
+/* AN control register. */
+#define MDIO_AN_CTRL1_RESTART		BMCR_ANRESTART
+#define MDIO_AN_CTRL1_ENABLE		BMCR_ANENABLE
+#define MDIO_AN_CTRL1_XNP		0x2000	/* Enable extended next page */
+
+/* Generic status 1 register. */
 #define MDIO_STAT1_LPOWERABLE		0x0002	/* Low-power ability */
 #define MDIO_STAT1_LSTATUS		BMSR_LSTATUS
 #define MDIO_STAT1_FAULT		0x0080	/* Fault */
+
+/* AN status register. */
 #define MDIO_AN_STAT1_LPABLE		0x0001	/* Link partner AN ability */
 #define MDIO_AN_STAT1_ABLE		BMSR_ANEGCAPABLE
 #define MDIO_AN_STAT1_RFAULT		BMSR_RFAULT
@@ -127,13 +143,17 @@
 #define MDIO_AN_STAT1_PAGE		0x0040	/* Page received */
 #define MDIO_AN_STAT1_XNP		0x0080	/* Extended next page status */
 
-/* Speed register. */
+/* Generic Speed register. */
 #define MDIO_SPEED_10G			0x0001	/* 10G capable */
+
+/* PMA/PMD Speed register. */
 #define MDIO_PMA_SPEED_2B		0x0002	/* 2BASE-TL capable */
 #define MDIO_PMA_SPEED_10P		0x0004	/* 10PASS-TS capable */
 #define MDIO_PMA_SPEED_1000		0x0010	/* 1000M capable */
 #define MDIO_PMA_SPEED_100		0x0020	/* 100M capable */
 #define MDIO_PMA_SPEED_10		0x0040	/* 10M capable */
+
+/* PCS et al. Speed register. */
 #define MDIO_PCS_SPEED_10P2B		0x0002	/* 10PASS-TS/2BASE-TL capable */
 #define MDIO_PCS_SPEED_2_5G		0x0040	/* 2.5G capable */
 #define MDIO_PCS_SPEED_5G		0x0080	/* 5G capable */
@@ -152,7 +172,7 @@
 #define MDIO_DEVS_VEND1			MDIO_DEVS_PRESENT(MDIO_MMD_VEND1)
 #define MDIO_DEVS_VEND2			MDIO_DEVS_PRESENT(MDIO_MMD_VEND2)
 
-/* Control register 2. */
+/* PMA/PMD control 2 register. */
 #define MDIO_PMA_CTRL2_TYPE		0x000f	/* PMA/PMD type selection */
 #define MDIO_PMA_CTRL2_10GBCX4		0x0000	/* 10GBASE-CX4 type */
 #define MDIO_PMA_CTRL2_10GBEW		0x0001	/* 10GBASE-EW type */
@@ -173,17 +193,21 @@
 #define MDIO_PMA_CTRL2_2_5GBT		0x0030  /* 2.5GBaseT type */
 #define MDIO_PMA_CTRL2_5GBT		0x0031  /* 5GBaseT type */
 #define MDIO_PMA_CTRL2_BASET1		0x003D  /* BASE-T1 type */
+
+/* PCS control 2 register. */
 #define MDIO_PCS_CTRL2_TYPE		0x0003	/* PCS type selection */
 #define MDIO_PCS_CTRL2_10GBR		0x0000	/* 10GBASE-R type */
 #define MDIO_PCS_CTRL2_10GBX		0x0001	/* 10GBASE-X type */
 #define MDIO_PCS_CTRL2_10GBW		0x0002	/* 10GBASE-W type */
 #define MDIO_PCS_CTRL2_10GBT		0x0003	/* 10GBASE-T type */
 
-/* Status register 2. */
+/* Generic status 2 register. */
 #define MDIO_STAT2_RXFAULT		0x0400	/* Receive fault */
 #define MDIO_STAT2_TXFAULT		0x0800	/* Transmit fault */
 #define MDIO_STAT2_DEVPRST		0xc000	/* Device present */
 #define MDIO_STAT2_DEVPRST_VAL		0x8000	/* Device present value */
+
+/* PMA/PMD status 2 register */
 #define MDIO_PMA_STAT2_LBABLE		0x0001	/* PMA loopback ability */
 #define MDIO_PMA_STAT2_10GBEW		0x0002	/* 10GBASE-EW ability */
 #define MDIO_PMA_STAT2_10GBLW		0x0004	/* 10GBASE-LW ability */
@@ -196,27 +220,29 @@
 #define MDIO_PMA_STAT2_EXTABLE		0x0200	/* Extended abilities */
 #define MDIO_PMA_STAT2_RXFLTABLE	0x1000	/* Receive fault ability */
 #define MDIO_PMA_STAT2_TXFLTABLE	0x2000	/* Transmit fault ability */
+
+/* PCS status 2 register */
 #define MDIO_PCS_STAT2_10GBR		0x0001	/* 10GBASE-R capable */
 #define MDIO_PCS_STAT2_10GBX		0x0002	/* 10GBASE-X capable */
 #define MDIO_PCS_STAT2_10GBW		0x0004	/* 10GBASE-W capable */
 #define MDIO_PCS_STAT2_RXFLTABLE	0x1000	/* Receive fault ability */
 #define MDIO_PCS_STAT2_TXFLTABLE	0x2000	/* Transmit fault ability */
 
-/* Transmit disable register. */
+/* PMD Transmit disable register. */
 #define MDIO_PMD_TXDIS_GLOBAL		0x0001	/* Global PMD TX disable */
 #define MDIO_PMD_TXDIS_0		0x0002	/* PMD TX disable 0 */
 #define MDIO_PMD_TXDIS_1		0x0004	/* PMD TX disable 1 */
 #define MDIO_PMD_TXDIS_2		0x0008	/* PMD TX disable 2 */
 #define MDIO_PMD_TXDIS_3		0x0010	/* PMD TX disable 3 */
 
-/* Receive signal detect register. */
+/* PMD receive signal detect register. */
 #define MDIO_PMD_RXDET_GLOBAL		0x0001	/* Global PMD RX signal detect */
 #define MDIO_PMD_RXDET_0		0x0002	/* PMD RX signal detect 0 */
 #define MDIO_PMD_RXDET_1		0x0004	/* PMD RX signal detect 1 */
 #define MDIO_PMD_RXDET_2		0x0008	/* PMD RX signal detect 2 */
 #define MDIO_PMD_RXDET_3		0x0010	/* PMD RX signal detect 3 */
 
-/* Extended abilities register. */
+/* PMA/PMD extended ability register. */
 #define MDIO_PMA_EXTABLE_10GCX4		0x0001	/* 10GBASE-CX4 ability */
 #define MDIO_PMA_EXTABLE_10GBLRM	0x0002	/* 10GBASE-LRM ability */
 #define MDIO_PMA_EXTABLE_10GBT		0x0004	/* 10GBASE-T ability */
@@ -229,7 +255,7 @@
 #define MDIO_PMA_EXTABLE_BT1		0x0800	/* BASE-T1 ability */
 #define MDIO_PMA_EXTABLE_NBT		0x4000  /* 2.5/5GBASE-T ability */
 
-/* PHY XGXS lane state register. */
+/* 10G PHY XGXS lane status register. */
 #define MDIO_PHYXS_LNSTAT_SYNC0		0x0001
 #define MDIO_PHYXS_LNSTAT_SYNC1		0x0002
 #define MDIO_PHYXS_LNSTAT_SYNC2		0x0004
-- 
2.35.1.1320.gc452695387.dirty

