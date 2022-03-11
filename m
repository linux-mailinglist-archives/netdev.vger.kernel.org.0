Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DE34D61E3
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348691AbiCKM4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348678AbiCKM4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:56:12 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60079.outbound.protection.outlook.com [40.107.6.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9331BFDCB;
        Fri, 11 Mar 2022 04:55:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFFoSqhDmPNPvJj+lPyt0pyXCqr8Dirayf79q/15i7dNY+978UYbENPLW5+jXMGvaip5pIBwtrAIx7CAN05RuWTJNP5hY31JTqR4Y42hi0gmqj2KQj40RLXx2Np6MSZhbqQa14EeLFeCpbHxwgoodX+YZf8GeCs+9Q8zikK8qC/Kzy7+tNB2751JenFdF2qim2sLNA20W0OiCMhcxG+SwHO/T6uniVgLC+J4lnM3MVH1SdJxCcV+t/FhWJIxn42nR6Q3feCjbkG+po95Uh4JYUq8DBbg5v15PmQlcDphSuFqNk/FOzDlLmywXbxaGQtajBM4o718qWf6tLq57UDjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPm6jT54oslGsalXvOLA7AvwPpBLDeig2k74QYziVpA=;
 b=YykM7C9DNWAvG0SeBgNi9zKNWLLV2KOeo2l5WG/wRyIQ9/pKFJTA4gVjWFmmNPGIaqY5LqiZ6aMspOfMwGKBpYcuyr2+C31sXQ3ZvtzOto3f4cGWoc0Ttav53ktnWoYPIZWQ+s1dpbNUN+eE5Fp5s1uOGXw2WiUW89/1ebn+iY5qDET8stmXWHOVtFwfVIqYQDID/iDS+Muc/6q6+6DKxzuXnXM0TXwBVtzUecTuuBNFzvR0viiC/D90PWkruU6TfEkHlnMn8PWlXHkFdaJGAXBBTzyqBIcLLrBAzL2OLgvhaveb+Pew4A9cbZlNDIfSgkFiKamW9j73w7+xh943Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPm6jT54oslGsalXvOLA7AvwPpBLDeig2k74QYziVpA=;
 b=AwZ1Zq5O9J6Kw+0Gxsu6R7h5VNGTqf1+Ipbv9lA97GSKXF3DCpizD77mPAovwSB9qDduDoHWd+Aj+4nCGpPrQQKVAzWOOPH2pGxDDxg+GI4tA1lU51ReUxjJ+xPRN6eUyiCkQoD9PC5GjRSTlpECkfAzvjwf20EH2VwlqijVi/o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM6PR0402MB3431.eurprd04.prod.outlook.com (2603:10a6:209:e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Fri, 11 Mar
 2022 12:55:05 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 12:55:05 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 5/8] dpaa2-mac: retrieve API version and detect features
Date:   Fri, 11 Mar 2022 14:54:34 +0200
Message-Id: <20220311125437.3854483-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0402CA0014.eurprd04.prod.outlook.com
 (2603:10a6:203:90::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 316b5720-993b-4696-25c0-08da035e5d66
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3431:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB34317161E79F0D69584E0C4DE00C9@AM6PR0402MB3431.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9kOOivPZGaKXOhSLwXAXWHfalRDlVyfLWfl9u6jSvoBGtTGT7p5AhE7J0+5TI3fuuZLCN0+0geQUCFtMrqFbTKP6UJqWsLCZ9/7yLfgGdzdUTgSNT/FT4Lu4js7umLwspLBh4tdfSOsUyRGGN5uhnEGSCfuWxFR3ARP/qVhakc5uhkhLEofUnETbxqmavtGhqa7dNOToO1ReLi/hQtBQ9JX8e4b4IpLT3dWwGtt0cr/r53iY0jyFPdyUEAlu7LwsgZeP2tJ83gJG2aIVK+rc25OryrDupjF6sE0vSYbMdJCcT43gWjEt8AJegoGtDm9srBod9p6+A1whWz6kvZ49054s5UikcmJC9qIN2lZk/V5PPhrM364bG/oobF0EVpYlwY5hgfzn9+yc3aMFePfW2Q2ESCMQdNXJVd6+oZ3pUEPhxooRZr6u0cTBFE9M6pIT3nv9oQLB2BkXF5z3Qubzfzt3zUk4UgviED3p8JHUx8uBdG+fnCSypr+lJ5iW7qlmpRH86Djqqitl8rBtjSvfYO6KLlBrZlR9a4iTV/ZU0ajmrqrIZ+qeWUJQzywyCu5hxKzVGG9r7g8dAnhG5fQQw/KQNaUEm5MyAWbjy4GhNbGWJty+9naqxAy34XxIFa/+CPl6taLrWLByrgcS2Worz7wXGMZbb4Q8WT5vH7Ol7ZOpdkQ1Ern+0xp8/gVdgztIS9eh6kJm3Vbm+9oQj0z3kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66946007)(7416002)(5660300002)(6486002)(8936002)(44832011)(508600001)(66476007)(66556008)(316002)(4326008)(83380400001)(1076003)(2616005)(6512007)(52116002)(6666004)(6506007)(2906002)(26005)(186003)(86362001)(36756003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sJLgJCTEWTIO1707TcCSiXkGs+q6Iu5INbweocHKfLN5mvTsMZRvprjN8OWa?=
 =?us-ascii?Q?Fg1LsrfYl/6SUGjvYpzIkAewKu1NDyW+IwhtXm7qVtfWIKecnKbFNc6+HRWM?=
 =?us-ascii?Q?XCnCzx9EnwvTtLIRx2rLhITuY4ES1nOmzo9n7TkY1Xa2TMoEJZVUwlhiFAgz?=
 =?us-ascii?Q?ptTu5e7mDd/9g98rCZahmUSDUCOacr9B3pnrtVPdCM03/BfE3lATPND2zw+T?=
 =?us-ascii?Q?IzvdaZApX/qkj5mx84kLQz7pknhvlfPlhBWkAm0/wsH/IoHDTS4jhuE2ji4t?=
 =?us-ascii?Q?jlE68VWadEoP3KL+mJ+lBMemyiyYmwP9awkvU649bJhExsFDf9al0p+OpLGB?=
 =?us-ascii?Q?rMewR8OaIghKKc84L6Ocwy/mZyWfnTRpwjCssggIzzVndCuuB9rkz2xbliTu?=
 =?us-ascii?Q?09xXUPvt5L09woH6LO95XMak1xZvbvgh+uFydZyahSYtuRqDIkoKiRr91KSi?=
 =?us-ascii?Q?HrNfkMHNTVxKXjDjkBGuxs/fXYLl8+8z3dh3ncRbOYvx3NiFicKkiNNKZA3E?=
 =?us-ascii?Q?r5J2lxHGQLw0oY3DRJkhn2x6SRMprh8eU9T5ln46oeMdpYUjFmzycA1nXAJ3?=
 =?us-ascii?Q?Hq6yuZ3Oh8GoqMs15tVBFOYw5xfEdAG1RhdaPb8rUCaQ2zZWpyYAttJT3Epl?=
 =?us-ascii?Q?UXBi1mzLI4t+bLoQOiCJ0qyz0Nh6Dk4snb0xgwerFaqCQ081z5xt1FXtECXt?=
 =?us-ascii?Q?t/kJZ67jWwEuKJH4T2ZgCWscgGQPDfNK8zdh9YLShOkvy8dwL0PV6QyWGaCu?=
 =?us-ascii?Q?zstf7oLduZBo8WyXV6GvrWgriZ2eqDqE9wOIP2U4R7RkdPOmfIj7EdC81d19?=
 =?us-ascii?Q?RVv0rkWiQDMgD3Z0zH7LAj/2+NE+nRhhvPxhzKoiajcrByjC3CDuqJLQsOA1?=
 =?us-ascii?Q?GY13SVNRHOTpKMzC2L2qTiG5mF07ByPpq4m30Fb2oW+AZNXqhExt0uH5HLF4?=
 =?us-ascii?Q?OHGPBE78WPnSwoheL4McBxcNiuWkpVntZmnqcn6qHx6dC6l19o3XVuynpkSh?=
 =?us-ascii?Q?0+30daMyTOa3ZmCd+p3YuH8wq0NQtSQg3alkGXJQsfdQ1Y558GqG4+5f/j2Q?=
 =?us-ascii?Q?y+bq4BGqTY4RH9O52xZCk0zFox4ioZ9i3fdphZQpkVgH9M6clcRgLyzWJNH+?=
 =?us-ascii?Q?H9+1jMAfhxHFYe79nD5Ozsv4hOOB9hnVq+uHpnWBRvZ9zrUTazuy8yvHO+q6?=
 =?us-ascii?Q?4/FKqBO2npeMC4kObmHoI7c2OybFNTu5De6Ye5SoLRMQIEn26Wlcu6tdPnP4?=
 =?us-ascii?Q?o9xiAevE0EJXOTJH5W4g3lPeXirSlJyo6HgCYYgiB5yaja6ENeSN8AnAxg4O?=
 =?us-ascii?Q?cYRDDgipJnPddSei454XTCo+e3qJozj1X9dvvWx493a8YreUWV4eAOUr7g5p?=
 =?us-ascii?Q?k8WteTrLoCEzQ2Oshup05G3u7SJuRr/1Z+tzenRVs1pXlhBUNbm+sE8CUHxs?=
 =?us-ascii?Q?CCKqPcyAmZpnjFCWgI0LhwS4KK2aBBdxOG1+0LKM5Ab3JYUvsbtVXvCrHp2i?=
 =?us-ascii?Q?AWFEsGWOgrzmaQRWAoJZ8Pzj6SrI92yGEJPDkXxbepggAL5W/8fUpG+cTSPZ?=
 =?us-ascii?Q?9301+uF510BLrXl72XtsJjnbBH/Kabda2/aI/dVdkFaGlPUBY/1umB21woL9?=
 =?us-ascii?Q?oeuZXN7cBTZeUjTQnpYGYss=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 316b5720-993b-4696-25c0-08da035e5d66
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:55:05.7005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JETLV/zXchirmZpbLxEPZ0sYjwrH1atFiNyrxX37NXLdt70Egc3x2uYgUmEfvuwZuQkPEjddRnGfOLo0dKmCJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
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

