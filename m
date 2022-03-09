Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642594D3118
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiCIOjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiCIOja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:39:30 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBD9124C32;
        Wed,  9 Mar 2022 06:38:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Owbpe5/FqH7oPmAra0N5Vf3YwLslSTRCBNqKX3e6LlkEMuNeJU8ttbgNSngXIFlJQ7PEWcnpwC70Ou8Z+3fyIn1ezpCMG5/ZNT7GqqthNQ33g/q8rzds2KcMVgfDxB2htzjNapSkfCjlmIgv8GsBiuysJlHf6ewC+LYJ9c/HCx/tVTYqhS9iVRUtD7PjRpcOVe/jeYYQjYY44S+a1khtVw2JgHKhC1NZrmmYMZMYD9jKWMEaGWlvht7YT47wf7hk1hgRV7O9d6HBPw7/EIbxREFEtsu26GDIjlw+KjgHUO4h4EgLTl8h1yb3Q38/Q0R6MD3g6UFMb4Xc2e0CztrW6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8KAOoskIsZHU92TeE8ybyMh//n3srX1ri3s42vsitg=;
 b=K5knUig1CDeg4qmba/aTkyCTgjRZIxNi7NIi7QrOfSfHIocnpV02Nz7VjeBcvfpcyhqgzCclV2fKZgxfyFiZJbMIpJxWwV5j4Ij4JtD8C5KCNf6deYYfNkJCg5DXjtmp3aftnJIGJqQtwQpdlVGauSW8a0b6KoZKbwgsPfzhxbfTXnHIElIqjBWf/6ryd86gHCmbM2XSZ3hlw8C9+9paK7IjmCc8HXTmfWKcfFmLK8ac/zBBmn8qMVqVcy6JXvYDjM+HeZhaxRrRocsfCEI9UmqB3IXnpTZR2DoLOy21jq79B3pFcdZ5J1PvG39OmAg+fuuBERuJ0zapf9ZDv4wD8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8KAOoskIsZHU92TeE8ybyMh//n3srX1ri3s42vsitg=;
 b=b2TfTemLLEnzQRFBswLcfQTdowcD6G9z/qHQ3Koqy8V44LSxadhFHfVzub23tCRIbuska4lbCZSt6IbjwIYswmcSLnyFA1dANlrhlVU7s2q80bFuG8yws8GoGk9NE8+IwuFr46tHbKBJG8jS9podGDBKFgMsFCdkSSd0kgrPlQk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB6094.eurprd04.prod.outlook.com (2603:10a6:803:f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Wed, 9 Mar
 2022 14:38:22 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 14:38:22 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 5/8] dpaa2-mac: retrieve API version and detect features
Date:   Wed,  9 Mar 2022 16:37:48 +0200
Message-Id: <20220309143751.3362678-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
References: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c04da0e-2bd7-4ed6-9664-08da01da75ec
X-MS-TrafficTypeDiagnostic: VI1PR04MB6094:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6094B8C5E36702114D80BE20E00A9@VI1PR04MB6094.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8X3hlA0WkD0Cn1pnyfW++0ePzPea/x0ivX7kY71C1mxCnL84IbnYfNTLvIfBVZROPaWR4sMY58YqcC1tA28IDm2Y59QHczkGFLsnN/E+Gu2hVYrzfGXgbj8kzr+yFheusSpOT5kgnyiUeDcA17ile8BQXX2mR+PezTYVT9iyT1KcQ3PeGhO1TANLW8ErMPbwA3qkT+CoAI8QaHtgIpGi9aMPV+4UX0AcMVAz1jleNCrRSoylqw3msG9XNSK09MP8HJTGKTgyCAXm7l3GEeR0/lFyxZm7XKd8iKwN9XRZRJDi1eO+xxOkKJy/SHrClj0mAyJze8XI3wZQokzItwug7kNUUcQzdWfObE7mzMtDxIQzOJH63jthqJW0jNPoVjPF3bgcanEleyTBvs8Gm9ME2qBIw1b2FSE5+JoN8poTDh7PQckmw4whUX0/HA4ZKxqjVMUdpHFhhPTaW7tpjJRN9r1MyT5esOLZlIJPEv75nueUfopmsQaRlGsHRjNUJIWXwTZ9sDdoQ+wf5GQsosbGBJSw+XQudITJWS3GFXED3WgKqjGVIx/ibPjX3euFxar4qYj65//eGh3LgxMgZV2Rle6/DjLd5BtEDH+4zuDiEZRJcPz37MQOX1ecbzkKODtEEdwLna3Rs8WjgtadyjlSGk/C3yJCasHYh4Zy0/0Bdc+suW7Jr5aYow0Vbn6BoLI2k9uXlfmyGJcWze2bSbjVvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6506007)(6512007)(8676002)(6486002)(2906002)(66946007)(186003)(4326008)(86362001)(66476007)(66556008)(38350700002)(38100700002)(36756003)(316002)(8936002)(26005)(1076003)(2616005)(44832011)(5660300002)(83380400001)(52116002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dDCOKDf3XRjAyZnDFinfNT/yGX144iSa7h+CmBJcu/jqfYLcAFgbFBONWYUX?=
 =?us-ascii?Q?v/S+lcETaa9ObnHUaK8uL4F7r4NtAuwp1zSixpmtYYJhsPmOdTvrmRApjSW3?=
 =?us-ascii?Q?0oUdl/eM/ZwXaDSjdQWT1SZHe23SZWc0CJOVAnHSkDssWl0B76R62jGpTosl?=
 =?us-ascii?Q?BqVlAzTOW+i23sOxGLB3Wp3MUNq0ebKWjrJ+maLGC/gcmyHAif4bbzCGxTKe?=
 =?us-ascii?Q?4Imk7Uy+SppCR8OUl2pNRFl7KTaX/Rkt+NNM656H9gRwh7b0tF39hhjFe82J?=
 =?us-ascii?Q?ECWGXqGZfMD2ruEixr4aKTr36h2sG+/jNjCbT+nfGuTi3AOZVlG9/n44cf1S?=
 =?us-ascii?Q?UKuKhbhwC7kmv3bNB8QiSsLuqHNuaNs06VfTzRZQfO987RTvplCMSha/13Pb?=
 =?us-ascii?Q?2Mhi1U4QeY5i5hotNBEl1shZzP4hqwiMPcWjJZ7GTN/S6qZLlrqfi5CTlIuj?=
 =?us-ascii?Q?PW11bFvSPDAhz2rlfzRdYY4LHUSx5wrcCJmyOVzmsFQq3CCXY1X2nV1gfM1v?=
 =?us-ascii?Q?LJmRonb9AmoaDyQc8iTiinpMOvexlpLwi8XB9u60KDTsbsNsErHlSSy+GWKV?=
 =?us-ascii?Q?ifU5Ed36Wi+sIQ5XP700lKSqDhnOumNdMXIfBI2T+DU8/fzYVrEfXFSz4xrQ?=
 =?us-ascii?Q?TxAbDG0gUNyIy8CJNFOpnqi7HVpiYIban4HEFkVc+K9hSlSZZ8T2mOlIe7AQ?=
 =?us-ascii?Q?PcVxOzt3tJUmTzSCeM0PvOJ2ZHEZYuzsJrlkZFV+GjqHCIIeoQFcyil64cuI?=
 =?us-ascii?Q?KxnNvCzvV0J6Ls+AEzOI+ThUmS3r/2gsHYejRKeKTgRZSPdwbPdUpyQg95Rq?=
 =?us-ascii?Q?fvOtiLlTeR84xmUnaivirLq1Wj2awz5TeULSypLPFs8eY4e1eBOk1Ruo231S?=
 =?us-ascii?Q?i7auO51BDYDNwVRDOmoA76eDz20xjJkQYPdjMekzSLTaCJ+WS4q9tfO3Fke7?=
 =?us-ascii?Q?l+3muz/R0CNiZWLGc/m0256/9Yw0zp3Rw2YMfxT7NWQO4RUMDCSlrqSq2a1S?=
 =?us-ascii?Q?uVkvBtKJtTDa1/W2eQ+WQqCfqw9DgEAfAq0ri2gcCqYtoXrsIuip63Nr9BZL?=
 =?us-ascii?Q?klJFCmKivaz5yWjUQLlI/r5B3DIbCrpcGygU61WSgKXagrZkZK8ARcqJnwmI?=
 =?us-ascii?Q?l5mgil0HBQwWSe/PE1/smVlvTOPMR0bqxdfJ6H+sAFxNhl+CFHwkG+b/wzHx?=
 =?us-ascii?Q?SCkQriJtq40RfDVQr8tslURrowWlzkHHNRNr4PtDQsjmTQ2ktE53Ya8ZQeXm?=
 =?us-ascii?Q?qD4fqvj2OSR/LkTjy+f0flNxCJ6Wo63jBlNNBBjxXxxn9JnrMh22TAnl6Oc1?=
 =?us-ascii?Q?HRQ40nQWrLw6wa/WROB4cG53QOFZnsKcMLk7IFQ4Z6zREsn3FCwBOHWtq1LN?=
 =?us-ascii?Q?ivjavrH4/UUmfF3C3JF3d2k+/BfX66/OTYdnAIigae8WNfQ5fhcDQEsd+MAl?=
 =?us-ascii?Q?rV4pyT6gu6s4o7peLa/r4MyzcC6n/MagK37cjYU5wKT0WAnjbB6bGg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c04da0e-2bd7-4ed6-9664-08da01da75ec
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 14:38:22.0377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzQeZ/+7QSDtYQM/LKFvSdn+eWB0fLhqtUxDmAFoTV+SVRHTT2Abg0dxwDyMnNOywkbyCcoIqYxaxavmqdnlIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6094
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

