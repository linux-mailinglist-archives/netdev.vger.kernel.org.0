Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C698364EFBB
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiLPQtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiLPQtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:49:08 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2082.outbound.protection.outlook.com [40.107.7.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48B41C41C;
        Fri, 16 Dec 2022 08:49:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6xhqrp7N7KlDLW+rL+rVC7LYwer+F2AINnSavmSTl7hDb8SNdMxMUUGIc6m1OTUQtYJnzixRiLp1z8vr0zzTPA2nKWu1tKAzcTLC7vDYT/IjhGqaWg4/y0UCp7gWY1noZSReWED1tGZSygyHBi8nLvFjcXEQSPL2I3Y2N3hXOyCkLhBkA4cWSLvx2GV067Xi9JiklOk6u94BHSgXLdOe3mifbSYsNnnwzgb5CmMRY+geV6F2CVYzcdeF+8VHTpeyrFo6OvD4PD6YGxh6nE1iImszoemraHYmFEoUmfRpzDOj14JoBgm1a/7VoHZuAZdrWllofA1ruEX/WWTHzuaIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDgtRCIfD7OobxyMw5s/jnPaDVjohEEFfM+/mb0BVcg=;
 b=gF9KVjkNda9aseQylyTvlEYy2zfEaqrPmKgNPGywL0SPWeytHZSjGY/7YODnkmHgtBUN1e6q5ESjR8um33hJYmq8d/zR2jKg4zHJszEnQ93yiyKsT/J/pDMW/pti3yL2ddG0fVwUyO1I8pm4jZnuZkBaJ5HkJq1xJDYWuFDeXpg4mdLAk6fe+V5cFqArDs6qtHtMYFUH5CE5fCJJprAwb5m/jwjjClFLyto89fn+RA5r5qrM0YULJ2+OCqXkTJDf/EoHZCk/L0qa49uIHYCUQ+RLcwat462lb99ibSbjpH7Ew923rjC+C4vBlqslB8JiAvGNb/pSEz8Hu7tDVdcIMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gDgtRCIfD7OobxyMw5s/jnPaDVjohEEFfM+/mb0BVcg=;
 b=DD5jvZEjs8u/Snf/pvvlzLljwJJWSuM34GtixIP7SH1KCw/+2cT4tvUYueaxm4eD5ZuudKhvUcV/Fzy05d65oyWA3kCL7wrnz222lS738GKuk9lhmNku9mvvDFjILA2YXhg5wnMoGVK5Kxz/gcyn7vTk6KJ8Fs6DInNtZdJLtjON2ffA9T+uAoHYgrHQPwU8G1EJA9d6rb597CMJpTDN5Igh/Q7KBNWNpcoE3MI6xqNIj0ZJ4X5VAiBW0gtQcGJi1LWwHSxpN04PjGu+Kf2oXVQN9AAuN9zRO8+DGaGWSp5KWXRMrlt7qPIdG2lzItrmXu0359vSomGoDMLglF4pZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB8010.eurprd03.prod.outlook.com (2603:10a6:20b:43d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 16:49:04 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 16:49:04 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v4 2/4] phy: mdio: Reorganize defines
Date:   Fri, 16 Dec 2022 11:48:49 -0500
Message-Id: <20221216164851.2932043-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221216164851.2932043-1-sean.anderson@seco.com>
References: <20221216164851.2932043-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::35) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: e9545b9c-c683-4a62-38cb-08dadf8570c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qkMO18oCQrdFYoyp1KRwM8j/S86NDC1w5efqSY0d4FGlvtkLfyc4H1skuL/fJrjaz4+XIydBQJlM2m3xukffvhLSe3gwh3OuCNQw8aBtwKi00j7+vZ17XW+Vqo80/Q6t60mK3T//GQXBhgW1AiF1EMvVZbfuxsdAAATQmOOwNSgX70/SV1+YwkCeRiJ6UaYIXNg12WZ4VcGHLPdEt2wK09RBLUtzMVGRAMLuKBBMyoROIe7WEdG+tXMSG72qT3UX30UyUwJIG39lOt46SPfWtwOmVH8DFjcf506fcvyT+pglTdWTaOjzjmtYoxuzNREF0ve77wJXWJYRZo/byw5FyXdVBCwfvmU0yfpB92ZwViPkALDkvFRXYU/VkwI8re5yPnNMfaDsLQbMx/LQU66N/TQ1BGy+I2SVNQHEkDLeJcTEBtqMXuTYaR9tAnGhQvdgZPFGzq8JYSPc0Mi9G8ry39Y2lM+4GZQVZv8GPC6Zjkk5gY8724ztzsmXmIhO7SZ70knrxVzkkk9fjoIdqhnt/g2EYrwJnRvKlKDsZ5cJvfzrlzqVkSfjqo1sAyLp84Qs2US/R1ysi6DupAxd3WJ69CpwA75rAxzRMiHjh05gC7uDUWUWWnvbag3Boi/lseHhPMXOK/uBnHfn7eYwZOXjRG2AcpgRL20haM2woA8WwYmW+6kytSd8YAGWghpKyNqSg2GJOMMdmVHlY83T3f91NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(346002)(376002)(39850400004)(451199015)(2616005)(1076003)(86362001)(83380400001)(36756003)(38350700002)(44832011)(30864003)(38100700002)(316002)(41300700001)(2906002)(8936002)(66476007)(66556008)(66946007)(4326008)(5660300002)(8676002)(7416002)(186003)(52116002)(478600001)(107886003)(26005)(6486002)(6512007)(54906003)(6506007)(6666004)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jOp533UCv3Fyhqx4VExTnaGtvIM2AJAMwSbSH7UGN4xYKhMf76P2FUwxuEpn?=
 =?us-ascii?Q?g0r2yaPP0djQdOdNcOjAdjGYJGxxT08+DjWVfM37Tq/Mw9G6t4hRWLnJMFD6?=
 =?us-ascii?Q?PRbByoj+EzHOVakhOwC7U9uKraMt3E4cWjJw9pdVeDad3oXt3y2p0rh+ZM4t?=
 =?us-ascii?Q?d6veDQVAb+EAhmVex53uVJhG74UwQ3hpRgNkDfeeQlGI5Ausd+8cjvGlSaz9?=
 =?us-ascii?Q?oMqjJs+wJuq8JbbBXVuzN7rKpOteodJECYdcx/CfovCXBJJp14v8DEd7NQsU?=
 =?us-ascii?Q?AHSlfGJ6yfN8oi0nwQU0qPlsDIARxVupnDdjJer6B5DVf8n2tR+KtLZQWvIC?=
 =?us-ascii?Q?Egx9puXBbc3leJZFXcl4PcSY/ATZ28J71VBf4bLhLNQS9AjZaEHoT9Bl05h6?=
 =?us-ascii?Q?RK6Ezwp1CLAjOjtl5hWwbjd+ZHZi97w7ygMZnL1rNdMl0w6oWgNHaBFNoq+j?=
 =?us-ascii?Q?B1KtfK11TAUGayJJevhKd52EeKGU2lSqa2qVsQJ3QYW8ww3DBeS+O4cK8ktR?=
 =?us-ascii?Q?BDnkJJMZn2pYAY21oL1mgsLUtF14FCGSxaoSayYAKsxT9PcXwTL4N959fBPy?=
 =?us-ascii?Q?DXMTRDaGkTf9K5dzcsDYKnphb/8YUWAI9RuTMhlAC3qxB0xar/X1IS5T4IIF?=
 =?us-ascii?Q?Q1zxc+rOvkK03EcLjx7elj1/VDAvJhQso2TcMWq6EUg/t5tBipCfZPQd55fk?=
 =?us-ascii?Q?mBUmCjGDubxpdzno/4NxG/6TZg6+hY4pQAXT57Zkn+VUE0dzLh7nIRF9Ydw3?=
 =?us-ascii?Q?RLwtHXBPr0HMLmIdh9+KMYWaTiQF4SoMg1S2mQqXGQVfEzr9leZnngc1fuSj?=
 =?us-ascii?Q?GA6HlZOJPh2fbGUUbHy1fEMAgtat4IAKtSU3yBo6iK0XxjWVFBuj1FoptPnK?=
 =?us-ascii?Q?6N/E0YlUmwYHwY+0qfylDm7ksSF/mchqgb2IXgG0aMpynPHKM3p+RW8cTFdN?=
 =?us-ascii?Q?qamTYOPetQ5v+0XAhhtMIFU0+jv01oDL2rc4zwSyY0cFD2+Q8lfRCuOk/aY9?=
 =?us-ascii?Q?LHhLNaoDvI57HNju+vOMpapr9dv2L37h3AAHi66M0bpjfoN4gp0BIwsJk6wv?=
 =?us-ascii?Q?SKQmGbsYs4+qYWq8k2PvkXEWTWI/2uej88kO5XXYA8nkde7vfpmHWX8qfB6s?=
 =?us-ascii?Q?5Pm2eDZv+G1t7prnjVCkdauFiwwtqhhIg4WMmKDx+KPAZOFXCus3yne2T00s?=
 =?us-ascii?Q?D+OcH9ct1AFSeM9MNt+maJ/9r8uIIbLXuRk/66+mf5zeahSMqC3ASYQuWAJ/?=
 =?us-ascii?Q?AHGhFVLRTcW65UMfosewTfK1uo2JGgZ6ISmQtrzYCPyhxpFPjhst92Aex2Ay?=
 =?us-ascii?Q?P+cxIXyWWL6pHWDWPh15W1eGJZAb6gFltJe/+P2jBgynUJlKzn6vmTS/yYv3?=
 =?us-ascii?Q?XSfa3YpL4N0Rdr5PGt5uiPjm+ts9yXpPAL6SAN53mpWK/BkbnX/USeDvK14e?=
 =?us-ascii?Q?/8wHPSQ8ivbjsvSbLphIXgUv+nfoa+mPF2aNiTnx9JGAKYv904YtMoCPTjKd?=
 =?us-ascii?Q?IG1hfEMFTqNV6vQe+FqkaaUfACBDXBXGrrPi7Ba8e4cTs6fVF7pU+Sa8QDFB?=
 =?us-ascii?Q?KgbSHS2ovxtpzpZMqZQJD2o1IRtkFmg+ALuxeOgsdg+3+/4IZUjrcvoixUZH?=
 =?us-ascii?Q?oA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9545b9c-c683-4a62-38cb-08dadf8570c9
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 16:49:04.3475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPT7xeP6dIlo3t+0Jw7NnXp4pMTGw16S61d9SM9NCGa8kIaZhzbskCwjrLX1071hWeqgYmAGQM8b8xP3c8WFtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB8010
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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

