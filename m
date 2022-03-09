Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AECD4D37B4
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237115AbiCIR31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237119AbiCIR3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:29:15 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3968933D;
        Wed,  9 Mar 2022 09:28:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUxR30WEs6d1pBWipjvJ2rO2TnAyatt0CVFr8kjGSOwvdM0B/iltGsl+JpQR/3bmcPuPFfuHXoGOvfrufuNMcGvrqMnnJgaX3EAta/EqtnDPmyWyWMJ+72Kb3nN8fPrewgdQtEPrOPTnHJ0XMDannw73Pvz4pXPgoQ44HphNbhEqH34KCwjKz3pSFhmyeKMBwN5JIGcVsm5xGc04H168s+QHGfEpnWFZRFV5kLCbwKkzWS8hsEBSnaXHgLpPg4dQt2slS+pe4CCXj7boOTE8FPbLiHNkFQPFkiDt5ukzvX8GjogYqQqOCPY/oWdCrGOmlAY/ig+08SoBizdAeWkqIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iw6H1oq8NBU1T86z6PJXqDg4QgGdGR3GK7d3DGjptc=;
 b=OuQCdzspZJ2qZwACXYPAhQx3TwDi2qt+ynAkgclKJyOvEeXr8xvu9T7pVTCkvRRRG5Uk6XU2oohahCD2RP23A6abgMylI7hq016wHNdF8nFAPKHseq/3hxSTfJrhNhy3K+7sO298M1Ch3cnljIhdIg5cUcWkkLjsbzU8RFZG5P2LgXxTxOVu+huiKNS31p2lvI5QTPwB1nhhWrGQhnwMj9SKgwJvXVQy1KnRPlgDNqB6oGuo25r+NArSjOICJm5lhUsOFNBylEnmXMQeZWKk4jb59VZUEQts+u8v+3NQKwENwDHRfirA/B4FIjwLAFd+S80kqOnsdM0jeWxE/7lYQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iw6H1oq8NBU1T86z6PJXqDg4QgGdGR3GK7d3DGjptc=;
 b=GjTrUGqLp32nfWLwihHI7buNRLrvn8gC6fx4gB2faBfgLOxM0u6mG3KwmCbIviu3aeAoEY0VdhF4yvwTfNs9UvCWf5TISyh/z5INld4GddyyDQBbHc/9xf0acZMd82eVHq94h3i7W2DeDnrX/sge/QvKWQdbVv/FhsLxhenyejI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by GV1PR04MB9101.eurprd04.prod.outlook.com (2603:10a6:150:20::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.25; Wed, 9 Mar
 2022 17:28:12 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:28:12 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 5/8] dpaa2-mac: retrieve API version and detect features
Date:   Wed,  9 Mar 2022 19:27:45 +0200
Message-Id: <20220309172748.3460862-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
References: <20220309172748.3460862-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f551cb7f-b39e-42f3-4951-08da01f22fe5
X-MS-TrafficTypeDiagnostic: GV1PR04MB9101:EE_
X-Microsoft-Antispam-PRVS: <GV1PR04MB9101FEFD39D780B8386B3F19E00A9@GV1PR04MB9101.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQWrtwdwaIGrrrXZljC8DjeJ5s3IEBDjzGM3CVPA4ZSW4PoJNmLSHIrHa4rZ3OBQfDPQRJdzeFRLYV4PyCco356yChG1EtrHuhKgf1nnZ6DWZ1Qjve7h7gNBxIY/DPUhywuGHiCH1+NiHIGFOTRYp95KJhcgrZhxxLyIgwExZOuxdA/V6mIQoSLU4DT3mJUQPQyWKbABv4C8vIynoZrGRr4XiFXhRZWiv0oUFFNEOHM/BQ7lskkMJerdnls878+3nE4IS8GIgYQx6OVVafshBFsIcUpBW6Nn2CqXOWMTCVLAKBp8onen+hgpdFi2wnXYFDzac8koccgtzVqFBYlHN5YN9o1qXT3dMZgUTOsXVpQi+qgSm0STNTq8QEG5gaE9g99Wqn800WFtrsebAo0hhqQ1e3cov3nJbnRpNBttksXrntYxPdySmzEE/QPSk/wid8ySvIBpL/XzwJb7skXrfC6ZqYa+C7j7K+nwia10a4GxTtf9ZWJODwsnwAdz4pYc/5UgvmbSd2G5pDCKAMWmxV56WFFRZ7tS19tRD+3pz0br8VUo5nAaHnulUMZLuUH1Izz/OHFhjhPPq5Sb33eKwGxiFxdyoH789VtZfWI+K5BmrfWOAbksr8hDEom+4+09KORZvdMJ27ChE7vIeAjX0yyULb0beQzzFc25p/PJaw/ezMr4HcbYIkvrpJ2ILuZSB2y9ASsHTYhAyKzV71w4+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(5660300002)(36756003)(6512007)(52116002)(8936002)(498600001)(83380400001)(44832011)(2906002)(6486002)(7416002)(38350700002)(38100700002)(1076003)(4326008)(66556008)(8676002)(26005)(66476007)(186003)(2616005)(6666004)(86362001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Etd6F8Nn0wBxlyQOiAenFn/0Y7p2VyiBrrlvpJVJNjNZ0PQ3Vh7eGSqu9F+s?=
 =?us-ascii?Q?C7ZOoVSksebRrUhCwKiRF3SV3lIIKjsgw7zeJNWrQvbIJOR1kLIKLzU88Ldx?=
 =?us-ascii?Q?vMgRBa4SdO3bMBbzLpcusWDMm0yEYXAuhlaNipDwksAnbBD3yO/982CHfaEg?=
 =?us-ascii?Q?qGQPyZYemlYzE55nRLsSscRBUb5ZelHB8QoTJaokLJwk13oB1A9mCpmlooLc?=
 =?us-ascii?Q?8agQ5Lz5GfMLeXv2HRWk5iFxrlWGVhKx35b3ZxxzxRp29Rp7JytGaPrA8/Ms?=
 =?us-ascii?Q?fCQwjY56xEbNzk2sSbeTBtwUXrxy9zxsUQf/v9uL6SCGMZYlkU3EorYHmhtT?=
 =?us-ascii?Q?ml/R5crmTPJ5VDii+k/tXRCC02byrmkgdNPWNbuEiKeMBrsjyI/IX4OIxnnF?=
 =?us-ascii?Q?OYiyA3ipAzMaZyBOKp5iSrWxpWz4rdOix1whcVzd0DEwA80NYiuZeLPIEqTG?=
 =?us-ascii?Q?qHAyJmr9awlVW5kX625YyYZ0u9wzrePn+BfKXxL+AIhjaW+beiaamUVgm5n9?=
 =?us-ascii?Q?ApPqdSXv9LEAgltW2HEy9PVcZ3fknoUSWAEp7kh+VSd1sW4fYjvMdT2EY1kn?=
 =?us-ascii?Q?5GqA5+RSqqEDJFIvDkuQurGGovhCFQvGfo60GG8un/GGWe9H3Irh6cJ4W/p7?=
 =?us-ascii?Q?3XwRPDmHRHzm6rE+hKvR4vmVBgSFhCA3cGFKZ3h1RE/3+xuaCuVvAGEab+PQ?=
 =?us-ascii?Q?x7bP5YDMKOmZPYOTjzaPjp6J9J5ChcKxRT4qNBLaDBclu/yYT/DGuyO+J6L7?=
 =?us-ascii?Q?FV//rAyUmKdZNpAYqt1ywOQnD68/CHZVIreuhiUcfnR64c70mBLlh9CWAirv?=
 =?us-ascii?Q?O5FQYDkNlcmmszhZNTGJE4TseuTDTAqALrNUg3DUeu80203NXm3qedGgT3Wi?=
 =?us-ascii?Q?Sfx2bwcw/Z0kWOODJrQFtiObUPGu+eyydOXhAE3b44NLVkM45Xc3AoGeyTJi?=
 =?us-ascii?Q?TJFqNTYn6QCuNkFqalVeIb8xsjC2IURvMX3twvy924+wOgDNz2Wh3kmOSry5?=
 =?us-ascii?Q?zNgTLRyufUpw6uT9ks8+oEhxv2mmVsnyg5RTu964Nsq1MicLMecVAzcEg0pR?=
 =?us-ascii?Q?tooZ5CI1IBlNUWjhtUW8MKzECmZisrBhNcuhQr725PIpfeNTue7JgMu07yeH?=
 =?us-ascii?Q?X6PwnQBFcv/dJYe/h2wxssaqZ/GD3iPz7/05e0QdXVT9mRUc2Pt/2xsY0gZk?=
 =?us-ascii?Q?LAIZXq9cKWeWj3ZkMy2a92JbE2zguIAA0vcMn4V/N2ratMWUOSLoPDHqgE/Q?=
 =?us-ascii?Q?/8YTJDCTmZaq8QBlo7FtY4wk+kJdaSZwkxKG1mMFDMxY8OdS8/H4KEb9n+SM?=
 =?us-ascii?Q?tgYfuoafPh9TUYiW5Ref2Le2ZquUp3OVZRola558fUyasRavrpt/ja6YEkCi?=
 =?us-ascii?Q?ec+cSjrKgRztok3jLatYh6l9BYz5Vok52G65dCjEazwnAK6RHoZ1RkBSKCmK?=
 =?us-ascii?Q?7i773xfvgJwyKw2L141IVnqPruvN1KoCtaYb82f05iD4CwRjvRHdQfS9klQ4?=
 =?us-ascii?Q?X2o1dTsjfstzZkRZt4KAj8wlmjV98kpkx43c5PTlTw8+BTxtrdfzwBvFsE7y?=
 =?us-ascii?Q?kyErjaeriTKRtwASLWlTIQtyQ8dK03C/vUzTCCrfAbMU3/MWcpYumtwUAbws?=
 =?us-ascii?Q?wP0lwpzlV5GnfiUAc9qGPZg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f551cb7f-b39e-42f3-4951-08da01f22fe5
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 17:28:12.4865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /D9zuNYQN+zbBQ6jjX/7jnXQfRFZy2+evp4EDwxBfOcAkaG8DDzuQ0LmMc8Mh8y5Kz279VTAbVw5USE+BwBMYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9101
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

