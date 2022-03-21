Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC534E248D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346444AbiCUKoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346441AbiCUKoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:44:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2132.outbound.protection.outlook.com [40.107.243.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7207A14A900
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:42:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcTTKh4l/1BC9b8XRr9x3YfUc4cJekuPvICcgPJbpdFsF0Ia4REe2cxjkZDnwg4zIqtn7Sk6WdNOZfHYjlE+Gzz7tS38p5sT28ub7qKBaAO4cf0J7qUeu79kUPpMwIZw4m04OJiAcA55pLkht54XaBavK7hKY77XlFrHReNyTm3iWL2W3kNXwieh3XcLc6yiaE+d8RCrhJlCUwvrYCwL17Pmp8/n5zXgOrLcl5W/WMBUzrQDT4w7Vb/rg3kMBbj2hK7TzgE+OqJASY0iwFxuHgQeuWIXXYeX26kJzv+GGnH3CfSRvTkqQGSK2qnDkiSZaA5sz1zVdI+jWmVKh/xj1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+ESlUUxlHG0lg+nzcCtNuhuEB4rq/Xgfl8TDsmkiL8=;
 b=FHTLB2vyicLCiZIwfSh0YIbwGQ32yg9+thEeYKNmhsFOYZpzxbFyrjvRSBxFJHwEPHDhQO86T0kk1jZud3YFiC97VTwoQ5Bo4Br9D5K28W56LQ/QQ+L4olZqdR2R811RvT2Rp66aTdkr/Xz35nv/eomSLDXArwrFyj4EM2V92NQfXsUKxCLCI85YBFprkdDyphTq89RR2axPCaN6b05d1ys2JMreSYzqTwYfxkQbI3JBioZJ0uZEu3mNA0PQprC/1R39KjE68MZJ74oUdqo2QlFI5M+HPMUCrMGYAInLkjPVYjrVDyNhZh3AfqlFxcYRSyByo0MLPYn/64uInkbdRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+ESlUUxlHG0lg+nzcCtNuhuEB4rq/Xgfl8TDsmkiL8=;
 b=PEby+dezxg54EzVXGIrryzPF/a6Ok8HPZ1rbbDboep5SuLG6WAgfu1HP4kk2CI/iysYy8VOiSq5WhRVmK+wdbbtWG/lVxwIUz1vluMBiM1irBuSnRtotn/ew2fDd+vOqJOVknzbIWSFbied8YUxDOnEgM2WPnMvFyyCrbZOIhc8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1512.namprd13.prod.outlook.com (2603:10b6:903:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.15; Mon, 21 Mar
 2022 10:42:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7077:d057:db6b:3113%4]) with mapi id 15.20.5102.015; Mon, 21 Mar 2022
 10:42:37 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net-next v2 08/10] nfp: choose data path based on version
Date:   Mon, 21 Mar 2022 11:42:07 +0100
Message-Id: <20220321104209.273535-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321104209.273535-1-simon.horman@corigine.com>
References: <20220321104209.273535-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0001.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52399ce6-b458-4d31-ff4f-08da0b2783dc
X-MS-TrafficTypeDiagnostic: CY4PR13MB1512:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB15125D7523561B383B3EA077E8169@CY4PR13MB1512.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bNjMEpurBpB4IrqiJPi3pyeNYPGBjRq3vI571K0xabz/LFzEDLgv0SCWP0uh1BohiTxconiB/K7MyResNZZJ2swzF+Tes8XSp+oS6OMPiBHgDYPuVvHkoCqhfvbCBDmkblzUloXyHs+y33MD3HpHcGABbNgA645xF9QlAH5Gg/ICJFqV+80jxDIaEJr51bHgxHfTvgGYNH6u5BneSZzaBm43poa3AsbHJC8JqhhqvAzGIpydLrQmgCgM+N5Q6rkPbVkupuB2ax9g+Xac8w3bAAFcgLn+Luea/828uS4MgCs3c2zzKt6Ep96ylVTi35JKgoER4fl0m/MxRRf384o8mUl+cz2MMRc+UTyjI2My3KaBS8KTqTdzL6EsP+gwggDjMLPrX0nFIvtA6pGP3uzAeXo256lZXJw9+TPs8YUvn8v+wT01i6wlXmZgO6dlIylduX4cwMlLChELELyb6eMzp6gsVU5h1JLutsZ0wOigsJe50uUa9mgHVShNRbpH/+GGsecqVLsDo7EfNJa1IsQsWJzqI04HkI8yQmyk46QqHmZ9gXvUdbc1jYWF9ZzWsOwz/y11MSVoRsJO5a0MnZMCCBNf8sHV05fzfVPkQmnzdv1STnhUWEmWtkYe1qat/kRmZTwOyoNxrzbA4Yvl3Pc4xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(396003)(376002)(366004)(346002)(8936002)(186003)(1076003)(6512007)(110136005)(6506007)(2906002)(8676002)(5660300002)(86362001)(52116002)(107886003)(6666004)(6486002)(44832011)(66946007)(4326008)(38100700002)(66556008)(2616005)(66476007)(316002)(83380400001)(508600001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ofDeTycd3GgYnHAaMED5uZWp1OwdVxnXdITio/aaLyYRI8bOMcYb8oScx3Yd?=
 =?us-ascii?Q?5Y6IHnAQeyGr642CCptYHO8/v+KAj8p//iM9qA546YOFKVl0IUJnPXrfgak1?=
 =?us-ascii?Q?2fJvq5vGFNTXZeCAeRoAnyUoP4xm+iuO7lHDWzDXTw76wNPpTnZTq5MWxEeq?=
 =?us-ascii?Q?vcIQotM6Q3DfMSNvESqHjr8cxFYi2M5VB7agyJDu+TtYdf2YcTFr9VdlkRL5?=
 =?us-ascii?Q?boGBJk6wjOsnRaQIjB3XQprJHTKph9WChqEPJT91R4/CRZwQAxSGkZsypHsd?=
 =?us-ascii?Q?QmUCkn4m+rPhlnkKOKJGV4SNap+p7pvH7nXCXTxLwXazgpKV/gH8UjzRPN1B?=
 =?us-ascii?Q?XtIOolkFBilVFeAuBkpfHHTFP50mbGt0cQWJ+Ku4bAVomv9XSfNIU8TWTcVy?=
 =?us-ascii?Q?1GpZddkcW8sNXrGRH1TdSti247VBhAPYTAyu0Mxg5L3bXLufVCiCgpVygLHZ?=
 =?us-ascii?Q?kIrZFxaXyk+MMAfS5wBWeDwuwBIxlQi1No08aTAFKrtA4ABgZlV+Ti66hB35?=
 =?us-ascii?Q?a55DKERGj2seGQ46EpIZTi35ZOceRs0ykYK3zYhV+Vlfe9axX8s9qRgGY355?=
 =?us-ascii?Q?mLvyRqw2z90FXkAlABrMPynTXMVkXVo6Tf3RumSY1fKNqr5ZI+aJbx9j9sfE?=
 =?us-ascii?Q?OYrxgAr4aKhlcFcD/ROv22TX+vn2m/lI5fJkAjzqs+f/PLT2JHTFUOfIu5HU?=
 =?us-ascii?Q?IM0gPrsaT4RpNAR4lBZ2+8pF0jc1ITNdxbcL9N88WvMKx7qEgkidUB1dXczS?=
 =?us-ascii?Q?VjQnZmTL5YxJK9YA7vs1IiP5Z53OR8gvpDGmNfAgY3BbNnKo8kskZZBzT9it?=
 =?us-ascii?Q?VvN3LRmuaHRgeVW1ICCSwXbpQJuiDK0wNpP2tgAm5/LsLISsCnc4ROJixL2J?=
 =?us-ascii?Q?RzdDgpIKRKVwOBr3VkRdHKfwuXCo2tgb3lvG1qB4iPe4fo3Yo1MDJd1JFKRV?=
 =?us-ascii?Q?FbXzoBipBCRQMAMG+oToqaLBgNs8+XXeI9M9BvbsZl3G04AqWjVYOAxruhu/?=
 =?us-ascii?Q?Bc2C7tJMSjLrJlyXJuZST1KIpBsm3s4vky3Mp5nElaTdyWNnxJ5LjRC0XY8K?=
 =?us-ascii?Q?RLBKV1Ko5C9GQCxHtbDisnZU2V3ASguz8qmCNVnpDJehIymHvvrECOZqyr8W?=
 =?us-ascii?Q?cqdEBf9v/jN20zhgkMaNImFZ/k8FeG2Rn8PgYY6SydgkeVQYPEeB/h7yzI6o?=
 =?us-ascii?Q?+q+mHv4yVWaro9M9AsZemQzwa9SsiX0hrIbYDCnJTvq1+7++J9B8H1CG9q09?=
 =?us-ascii?Q?K88h4PoUbC9rbkCQ9quf7MfKHnavodY9hAmbcyb+mTPdXML/wJ1d/0qe6qAd?=
 =?us-ascii?Q?bPvse0lQR8JixCaYC2MN+Q89X13ZIPklAFuEYBmkegIJQMMXKZh2usqY7lZC?=
 =?us-ascii?Q?K4L1g+tUlgeSOTnV1ul01HqX8vhsvEFjgJZ8QqlqMbX6DWBwNhk4pj55JWaw?=
 =?us-ascii?Q?jGrTIpE5qWEnV9SMAOSNuerg5z08SArjO/3xxyKiZo4mXQSZ6nMxhmuaQQWX?=
 =?us-ascii?Q?bLxYF8pla9Oxtx+wZTEDEHuf4jD3lfWdcd3g0pXhhOXOKyj/0ONriD9KmQ?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52399ce6-b458-4d31-ff4f-08da0b2783dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 10:42:37.1212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/jY3IpGbCCL+MeAk2PLkgZ2q6wQPgq/L0bYFSaejfJc9vxQxPI2Fqulg6HGf6ibjA8/zGuiGHVg6qnhFUPwkdhYInrgAklwZQ17iGgUjqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Prepare for choosing data path based on the firmware version field.
Exploit one bit from the reserved byte in the firmware version field
as the data path type.  We need the firmware version right after
vNIC is allocated, so it has to be read inside nfp_net_alloc(),
callers don't have to set it afterwards.

Following patches will bring the implementation of the second data
path.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h  | 14 +++++++-----
 .../ethernet/netronome/nfp/nfp_net_common.c   | 22 +++++++++++++++----
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  4 +++-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  9 ++++----
 .../ethernet/netronome/nfp/nfp_netvf_main.c   |  9 ++++----
 6 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 3c386972f69a..e7646377de37 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -411,13 +411,17 @@ struct nfp_net_fw_version {
 	u8 minor;
 	u8 major;
 	u8 class;
-	u8 resv;
+
+	/* This byte can be exploited for more use, currently,
+	 * BIT0: dp type, BIT[7:1]: reserved
+	 */
+	u8 extend;
 } __packed;
 
 static inline bool nfp_net_fw_ver_eq(struct nfp_net_fw_version *fw_ver,
-				     u8 resv, u8 class, u8 major, u8 minor)
+				     u8 extend, u8 class, u8 major, u8 minor)
 {
-	return fw_ver->resv == resv &&
+	return fw_ver->extend == extend &&
 	       fw_ver->class == class &&
 	       fw_ver->major == major &&
 	       fw_ver->minor == minor;
@@ -855,11 +859,11 @@ static inline void nn_ctrl_bar_unlock(struct nfp_net *nn)
 /* Globals */
 extern const char nfp_driver_version[];
 
-extern const struct net_device_ops nfp_net_netdev_ops;
+extern const struct net_device_ops nfp_nfd3_netdev_ops;
 
 static inline bool nfp_netdev_is_nfp_net(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &nfp_net_netdev_ops;
+	return netdev->netdev_ops == &nfp_nfd3_netdev_ops;
 }
 
 static inline int nfp_net_coalesce_para_check(u32 usecs, u32 pkts)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 331253149f50..0aa91065a7cb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1892,7 +1892,7 @@ static int nfp_net_set_mac_address(struct net_device *netdev, void *addr)
 	return 0;
 }
 
-const struct net_device_ops nfp_net_netdev_ops = {
+const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_init		= nfp_app_ndo_init,
 	.ndo_uninit		= nfp_app_ndo_uninit,
 	.ndo_open		= nfp_net_netdev_open,
@@ -1962,7 +1962,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->dp.num_tx_rings, nn->max_tx_rings,
 		nn->dp.num_rx_rings, nn->max_rx_rings);
 	nn_info(nn, "VER: %d.%d.%d.%d, Maximum supported MTU: %d\n",
-		nn->fw_ver.resv, nn->fw_ver.class,
+		nn->fw_ver.extend, nn->fw_ver.class,
 		nn->fw_ver.major, nn->fw_ver.minor,
 		nn->max_mtu);
 	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
@@ -2036,7 +2036,16 @@ nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
 	nn->dp.ctrl_bar = ctrl_bar;
 	nn->dev_info = dev_info;
 	nn->pdev = pdev;
-	nn->dp.ops = &nfp_nfd3_ops;
+	nfp_net_get_fw_version(&nn->fw_ver, ctrl_bar);
+
+	switch (FIELD_GET(NFP_NET_CFG_VERSION_DP_MASK, nn->fw_ver.extend)) {
+	case NFP_NET_CFG_VERSION_DP_NFD3:
+		nn->dp.ops = &nfp_nfd3_ops;
+		break;
+	default:
+		err = -EINVAL;
+		goto err_free_nn;
+	}
 
 	nn->max_tx_rings = max_tx_rings;
 	nn->max_rx_rings = max_rx_rings;
@@ -2255,7 +2264,12 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_LSO_ANY;
 
 	/* Finalise the netdev setup */
-	netdev->netdev_ops = &nfp_net_netdev_ops;
+	switch (nn->dp.ops->version) {
+	case NFP_NFD_VER_NFD3:
+		netdev->netdev_ops = &nfp_nfd3_netdev_ops;
+		break;
+	}
+
 	netdev->watchdog_timeo = msecs_to_jiffies(5 * 1000);
 
 	/* MTU range: 68 - hw-specific max */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 33fd32478905..7f04a5275a2d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -149,7 +149,9 @@
  * - define more STS bits
  */
 #define NFP_NET_CFG_VERSION		0x0030
-#define   NFP_NET_CFG_VERSION_RESERVED_MASK	(0xff << 24)
+#define   NFP_NET_CFG_VERSION_RESERVED_MASK	(0xfe << 24)
+#define   NFP_NET_CFG_VERSION_DP_NFD3		0
+#define   NFP_NET_CFG_VERSION_DP_MASK		1
 #define   NFP_NET_CFG_VERSION_CLASS_MASK  (0xff << 16)
 #define   NFP_NET_CFG_VERSION_CLASS(x)	  (((x) & 0xff) << 16)
 #define   NFP_NET_CFG_VERSION_CLASS_GENERIC	0
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 7d7150600485..61c8b450aafb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -219,7 +219,7 @@ nfp_net_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	snprintf(vnic_version, sizeof(vnic_version), "%d.%d.%d.%d",
-		 nn->fw_ver.resv, nn->fw_ver.class,
+		 nn->fw_ver.extend, nn->fw_ver.class,
 		 nn->fw_ver.major, nn->fw_ver.minor);
 	strlcpy(drvinfo->bus_info, pci_name(nn->pdev),
 		sizeof(drvinfo->bus_info));
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 09a0a2076c6e..ca4e05650fe6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -123,7 +123,6 @@ nfp_net_pf_alloc_vnic(struct nfp_pf *pf, bool needs_netdev,
 		return nn;
 
 	nn->app = pf->app;
-	nfp_net_get_fw_version(&nn->fw_ver, ctrl_bar);
 	nn->tx_bar = qc_bar + tx_base * NFP_QCP_QUEUE_ADDR_SZ;
 	nn->rx_bar = qc_bar + rx_base * NFP_QCP_QUEUE_ADDR_SZ;
 	nn->dp.is_vf = 0;
@@ -679,9 +678,11 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	}
 
 	nfp_net_get_fw_version(&fw_ver, ctrl_bar);
-	if (fw_ver.resv || fw_ver.class != NFP_NET_CFG_VERSION_CLASS_GENERIC) {
+	if (fw_ver.extend & NFP_NET_CFG_VERSION_RESERVED_MASK ||
+	    fw_ver.class != NFP_NET_CFG_VERSION_CLASS_GENERIC) {
 		nfp_err(pf->cpp, "Unknown Firmware ABI %d.%d.%d.%d\n",
-			fw_ver.resv, fw_ver.class, fw_ver.major, fw_ver.minor);
+			fw_ver.extend, fw_ver.class,
+			fw_ver.major, fw_ver.minor);
 		err = -EINVAL;
 		goto err_unmap;
 	}
@@ -697,7 +698,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 			break;
 		default:
 			nfp_err(pf->cpp, "Unsupported Firmware ABI %d.%d.%d.%d\n",
-				fw_ver.resv, fw_ver.class,
+				fw_ver.extend, fw_ver.class,
 				fw_ver.major, fw_ver.minor);
 			err = -EINVAL;
 			goto err_unmap;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index 9ef226c6706e..a51eb26dd977 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -122,9 +122,11 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	}
 
 	nfp_net_get_fw_version(&fw_ver, ctrl_bar);
-	if (fw_ver.resv || fw_ver.class != NFP_NET_CFG_VERSION_CLASS_GENERIC) {
+	if (fw_ver.extend & NFP_NET_CFG_VERSION_RESERVED_MASK ||
+	    fw_ver.class != NFP_NET_CFG_VERSION_CLASS_GENERIC) {
 		dev_err(&pdev->dev, "Unknown Firmware ABI %d.%d.%d.%d\n",
-			fw_ver.resv, fw_ver.class, fw_ver.major, fw_ver.minor);
+			fw_ver.extend, fw_ver.class,
+			fw_ver.major, fw_ver.minor);
 		err = -EINVAL;
 		goto err_ctrl_unmap;
 	}
@@ -144,7 +146,7 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 			break;
 		default:
 			dev_err(&pdev->dev, "Unsupported Firmware ABI %d.%d.%d.%d\n",
-				fw_ver.resv, fw_ver.class,
+				fw_ver.extend, fw_ver.class,
 				fw_ver.major, fw_ver.minor);
 			err = -EINVAL;
 			goto err_ctrl_unmap;
@@ -186,7 +188,6 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	}
 	vf->nn = nn;
 
-	nn->fw_ver = fw_ver;
 	nn->dp.is_vf = 1;
 	nn->stride_tx = stride;
 	nn->stride_rx = stride;
-- 
2.30.2

