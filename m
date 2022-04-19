Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAD7506CBC
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 14:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241509AbiDSMuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 08:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiDSMuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 08:50:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2130.outbound.protection.outlook.com [40.107.244.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3801637003
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 05:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gN96/ob3uIaogE/GS9vYCAi10cyLw5EaI+48EKtBVS0Ipnr+Uuq/lAgwsx1DdXcMfGv2pH2s7P3FaIjAcgZkURBLXUbngcO31tTZeq089fl7jTNXfdvJMMMyzW4hsWK8CxHs1aoP7Af0LGsz26lRz88XhF0+4iSkH3Zyts5vWQpC+bM7SwXrcGgmvvSIo0yhtz0yd1UrKvHqCUC4USQWX4T1iEnIxo2wCYe7sk3OFDSZwsnw07ui8cc+E+f0M9ByTLQD74qDJkJtpJuSAeIIm7y2VfAcuRurARwJUunpGStEkxiexi6IPoCzczA9rkwwiVMsHSOCAg/HhyNVbmaHPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfasSXuQ5+8hqUek4TeiFPdzXIugj6FzGcn07nJVAfM=;
 b=ZduDgCiuG22qP2QUgpWG/JAhy8zlFrLOXLs85pm6/aMRCAp1NJ0OgZ/Jq5ppRa4AKLhy2283cKRSXug3Zws9C5m3TtCiYouij+y/GFyNsGHKrSC7iSCAOpDAthuyamVl1C4r4yr/mMcH2qdyK8ITTF6l9D/MpKdX79Ry1G4ZfLPQnjCqmF83M299uFTu3BWZrmHzZ/uMCNRTCUlyXaOsw1buCJcdYvyHBuDuVVeQSHWXqIRsklhaiBBrljCYeSLaLhyoxaNgorEAec46mcbwCV7uQCeFK3umsy2otWdk+IkPsKTPAb2SbIkAaZYVgTtUQRgBZ7C3cpffCyvPUvSWgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfasSXuQ5+8hqUek4TeiFPdzXIugj6FzGcn07nJVAfM=;
 b=SNTV9Uy20fl/+AeTZRjcrzLo6yd07LQC0fyiXNhLJN6+M56ssNpLIgAh4rJWMKSXj0xBQmUjoywV0Wjoy5EmWVdGiS399fKKWH8TWAsTev3dco6rfziFTWIlKb2PN1F2R9h9LzyTUySrAXoCO5QPAiwd34+Yo99b7M9Tz2zPgyA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3560.namprd13.prod.outlook.com (2603:10b6:610:24::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 19 Apr
 2022 12:47:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8c8a:96b7:33a6:4da5]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8c8a:96b7:33a6:4da5%7]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 12:47:17 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next] nfp: support 802.1ad VLAN assingment to VF
Date:   Tue, 19 Apr 2022 14:44:43 +0200
Message-Id: <20220419124443.271047-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P195CA0021.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 310345d3-edbb-4143-a4f9-08da2202bc91
X-MS-TrafficTypeDiagnostic: CH2PR13MB3560:EE_
X-Microsoft-Antispam-PRVS: <CH2PR13MB3560CAA879548AFDA1FE297AE8F29@CH2PR13MB3560.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IOgq92p9ahntV1gzzN91vEMK+4IzbAujs/1J5/ucWiucN0SDznSVD2BEOgyAjTkFa3xAeiZILlvRRq0CbCXOuwHUbkmyGd17pr7f3p73jJcmy4qBXtcwRwxIFl4nxYJSds06nZLIlngkmrS50d2q/UjJjTwhj/R6ST4D9ce5uOURJZYrn8aR1p0WQjnYhhfW/A+BVif/o8OoXcw/jyb7OA8t8xGeYFyoe1Y42tWaGGUquL7qj0LqUrV3DX0WBUWk0npmBbQc+TFymheHdxYDoJ0t+JOd5lcQPM/SMcxQVdokUC/LiH6WobNyfvmGdLTs7KeHe89+RnpVDJfyADkYdKgaQajnSkFacCTGLE2CJWaCiai2WfgtS/RBV7AyOrt8ijb6CUFRBnUNodcNxsAli/tz7WimNbUN4JB+YmTQUAuvuxZ+/+YYTg6Q1nfVqmltenSrvrTqaUrE4lHe5QKIT6QkOnZj3e8vV4DSkw9goYeszknboCMvjztNUZsm3H5o223Z2j+ehfCeT2OJYpSHQMLPb9Up9Lb3uBt0r/2CMT9o0T5zoSC9R1uNQ8mNKGLw+QQSGwdSxbIt8Fg8mA9AzMzi9F1UYYKOazvBLfhxRqOv54n61i7q67gLwX8cW1QrXebZWspJ6NL6aJun/eY0OBBxrdTbJxaz6vBM+pEtnudb1Gb6MiowTWuUzZ3Ot1m7Wyb2Mv69iIjFvfNKfM8uAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(376002)(136003)(39840400004)(346002)(366004)(186003)(44832011)(8936002)(2616005)(83380400001)(107886003)(52116002)(36756003)(66946007)(6512007)(8676002)(4326008)(66556008)(66476007)(1076003)(6506007)(316002)(6666004)(508600001)(5660300002)(6486002)(2906002)(110136005)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W2izYVUz0N9cvO20Q/ka6r8aLxbEQLY2I+TrUXGLmH84a7bqHgL3li6E84Gj?=
 =?us-ascii?Q?5HW8Gyabdu1jeUzYn3eVMIFRIOYwi1FaBTrdzpjWuJRTPC/2++m1eqaNTmlI?=
 =?us-ascii?Q?Zs188eCHVplijfEu7YE9xhKs1JnyvaJ/lp3yp1YCI1wR3+Cf+bJCH9xrq7/B?=
 =?us-ascii?Q?PzBqZb/kiyTvvdIjHTobhFeP/Bv4/I9hFx+uBJyYr2tzl2WKtDvmNnbVBBKx?=
 =?us-ascii?Q?A1411hJ7n+9ZpahsrhPdFFMdu++gOnLkjlH3StDyMRCo4DoDkmvnE0t3Rf0p?=
 =?us-ascii?Q?+tpIZ/AsI8m4xmFQ/il1HYXHcnkdA6D2nNNG7dK6dN/7FHwo6gUbROqfC1bW?=
 =?us-ascii?Q?jKyqnPkT3HOKUIY/3XFEC1AwWxkyMZJMwCbTHvwAmIdKGnOqq5pFKgN/3yXe?=
 =?us-ascii?Q?epLD0RXWdYLpdAwdRVJyNpCruchGgm/ZcKXpST1jOc0RNiYHmRbmXqsKXdFh?=
 =?us-ascii?Q?Y5Q6/eD9bAgSUMa5y14dCGqDCjoViFBFFcL2hV0TfHhVm9LN5XQsksf9y+qb?=
 =?us-ascii?Q?9rQHzXR6alrHEhY34+3sX3mXxeiPUUpPUqmBmyQAsBw+NPoFFOEfBQG+NFs+?=
 =?us-ascii?Q?oUQbIA5wpqVo8fihgDD6Q1ktEvrMfyhgfeRUJErfHDU74zXdYKhWCi+7WSf8?=
 =?us-ascii?Q?WQl18BkPMcsF69LkvAn/EeRZ8Ru1bYzoos8zIMdpLx6wx87usWjbl/eNaH34?=
 =?us-ascii?Q?G5tvbgc3lT0vYP5p/lzRYtam3R5yIj56k08n3E2saWYge5rVv9cc7pSchM03?=
 =?us-ascii?Q?4s9dNhKbDBpKxQ8BG4Y420zyQZi/ruBSg9Cf1bCm0YXXTmyW02Pb9PI8St6F?=
 =?us-ascii?Q?4WUKisvi8rsZrBMvDiBODg6A+35NZL/6vEY60acjvWqbd7PLp8UwhWa7/3MP?=
 =?us-ascii?Q?a8CBGFIi7mhQVUPERv4Ax0X0SN+KSOSDJbocYTjIWV+eQXRhnRV1jglbbooI?=
 =?us-ascii?Q?yqoky64GSrbY8gXmHRUQMbVydr/6LlAiTPPg5nn6f0U1AB8x1p68Yp5zwbBh?=
 =?us-ascii?Q?mG3KmelSMCKqsUbXs2Lq6n9QL5sgB3e+MDijMPJ/RL1lwDrunfGihuRKZfOS?=
 =?us-ascii?Q?yVrmbqI22j5D5l/Xg6BpGj4H7HlPuDsG2E0BYtIEGcVxT7gv+J/ubGe2mrVY?=
 =?us-ascii?Q?8kYn741foIOukpae+YxTQd0rQrcrsOClfQHPT+Gs986kQX0qHVpz9Wy0vvNn?=
 =?us-ascii?Q?Ob2UMgZ+WJ1IAweDqRYQz+qBEnXyFe2y+RnzFPR8RAx/RHkgiWVsltbRsEc/?=
 =?us-ascii?Q?XExRGJce4REngZNQlszWdlgurG8FRWkHX/dgb32XRpJBDKBBq5mUfmrKmCfE?=
 =?us-ascii?Q?QaeNDLNrHBlmKgRoCnasDGh3yvqK0xE6MzI6oUGVjooeHG5IlpA1YDczbymV?=
 =?us-ascii?Q?gXyb8RkTlGOcRqDkt1eYMk766yw7jNuwYn7qbaFbcw/Hx7GHWgvbttn78lAo?=
 =?us-ascii?Q?uwfFhru1qfUgWDYcAR7KyM6XpBl4Re8ZU5vN+OqEIEwv+H9zUidwgv0IA4C/?=
 =?us-ascii?Q?ZGHgi82Cbfmt6gMukfk7MBncTmOPFrt0b6XPHLGzlLHslwJ/tCJqDdM+X9Nu?=
 =?us-ascii?Q?1sC8qxZnuBJxsyEIVetSfp6Vv3Ps1ZtjM5y9I3Xg4YzgOfHsJpBwFKBMHmag?=
 =?us-ascii?Q?RZ3x40DKFGbw+pZFylm6Eje5BRf9vpAXtJSw69RdOtzLG6j5k2lT0V17hpul?=
 =?us-ascii?Q?ZSAsEy1AI9MThGY4H8XkjBtUMu+2/roaaAkRp+tk0QIEZn4pwmf6YwIzdmwU?=
 =?us-ascii?Q?EI+yVZxVOkX10q5AIIO/fNWMROdvsKsYjHDU17uVDlAfsU+PGuV7luzFyG4K?=
X-MS-Exchange-AntiSpam-MessageData-1: ZN4Q/U44rotcZBZMmCP8+ptEv54wWGenMYM=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 310345d3-edbb-4143-a4f9-08da2202bc91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 12:47:17.6380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atFBXie7BzIMIKPUHOKT3cRVWHdr3hPuhgtb4Xk0B4/wOKyMNEN7aQJA6CUt9muEFXmiqGxlxNqmh14+K2fZBr2y6HZDo0T04taINQhaaOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3560
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

The NFP driver already supports assignment of 802.1Q VLANs to VFs

e.g.
 # ip link set $DEV vf $VF_NUM vlan $VLAN_ID [proto 802.1Q]

This patch enhances the NFP driver to also allow assingment of
802.1ad VLANs to VFs.

e.g.
 # ip link set $DEV vf $VF_NUM vlan $VLAN_ID proto 802.1ad

Signed-off-by: Bin Chen <bin.chen@corigine.com>
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Yinjun Zhang <yunjin.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 43 ++++++++++++++-----
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |  3 ++
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
index 3fdaaf8ed2ba..4627715a5e32 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
@@ -95,15 +95,17 @@ int nfp_app_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 			__be16 vlan_proto)
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
+	u16 update = NFP_NET_VF_CFG_MB_UPD_VLAN;
+	bool is_proto_sup = true;
 	unsigned int vf_offset;
-	u16 vlan_tci;
+	u32 vlan_tag;
 	int err;
 
 	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN, "vlan");
 	if (err)
 		return err;
 
-	if (vlan_proto != htons(ETH_P_8021Q))
+	if (!eth_type_vlan(vlan_proto))
 		return -EOPNOTSUPP;
 
 	if (vlan > 4095 || qos > 7) {
@@ -112,14 +114,32 @@ int nfp_app_set_vf_vlan(struct net_device *netdev, int vf, u16 vlan, u8 qos,
 		return -EINVAL;
 	}
 
+	/* Check if fw supports or not */
+	err = nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO, "vlan_proto");
+	if (err)
+		is_proto_sup = false;
+
+	if (vlan_proto != htons(ETH_P_8021Q)) {
+		if (!is_proto_sup)
+			return -EOPNOTSUPP;
+		update |= NFP_NET_VF_CFG_MB_UPD_VLAN_PROTO;
+	}
+
 	/* Write VLAN tag to VF entry in VF config symbol */
-	vlan_tci = FIELD_PREP(NFP_NET_VF_CFG_VLAN_VID, vlan) |
+	vlan_tag = FIELD_PREP(NFP_NET_VF_CFG_VLAN_VID, vlan) |
 		FIELD_PREP(NFP_NET_VF_CFG_VLAN_QOS, qos);
+
+	/* vlan_tag of 0 means that the configuration should be cleared and in
+	 * such circumstances setting the TPID has no meaning when
+	 * configuring firmware.
+	 */
+	if (vlan_tag && is_proto_sup)
+		vlan_tag |= FIELD_PREP(NFP_NET_VF_CFG_VLAN_PROT, ntohs(vlan_proto));
+
 	vf_offset = NFP_NET_VF_CFG_MB_SZ + vf * NFP_NET_VF_CFG_SZ;
-	writew(vlan_tci, app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_VLAN);
+	writel(vlan_tag, app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_VLAN);
 
-	return nfp_net_sriov_update(app, vf, NFP_NET_VF_CFG_MB_UPD_VLAN,
-				    "vlan");
+	return nfp_net_sriov_update(app, vf, update, "vlan");
 }
 
 int nfp_app_set_vf_spoofchk(struct net_device *netdev, int vf, bool enable)
@@ -209,7 +229,7 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 {
 	struct nfp_app *app = nfp_app_from_netdev(netdev);
 	unsigned int vf_offset;
-	u16 vlan_tci;
+	u32 vlan_tag;
 	u32 mac_hi;
 	u16 mac_lo;
 	u8 flags;
@@ -225,7 +245,7 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 	mac_lo = readw(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_MAC_LO);
 
 	flags = readb(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_CTRL);
-	vlan_tci = readw(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_VLAN);
+	vlan_tag = readl(app->pf->vfcfg_tbl2 + vf_offset + NFP_NET_VF_CFG_VLAN);
 
 	memset(ivi, 0, sizeof(*ivi));
 	ivi->vf = vf;
@@ -233,9 +253,10 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 	put_unaligned_be32(mac_hi, &ivi->mac[0]);
 	put_unaligned_be16(mac_lo, &ivi->mac[4]);
 
-	ivi->vlan = FIELD_GET(NFP_NET_VF_CFG_VLAN_VID, vlan_tci);
-	ivi->qos = FIELD_GET(NFP_NET_VF_CFG_VLAN_QOS, vlan_tci);
-
+	ivi->vlan = FIELD_GET(NFP_NET_VF_CFG_VLAN_VID, vlan_tag);
+	ivi->qos = FIELD_GET(NFP_NET_VF_CFG_VLAN_QOS, vlan_tag);
+	if (!nfp_net_sriov_check(app, vf, NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO, "vlan_proto"))
+		ivi->vlan_proto = htons(FIELD_GET(NFP_NET_VF_CFG_VLAN_PROT, vlan_tag));
 	ivi->spoofchk = FIELD_GET(NFP_NET_VF_CFG_CTRL_SPOOF, flags);
 	ivi->trusted = FIELD_GET(NFP_NET_VF_CFG_CTRL_TRUST, flags);
 	ivi->linkstate = FIELD_GET(NFP_NET_VF_CFG_CTRL_LINK_STATE, flags);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
index 786be58a907e..7b72cc083476 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
@@ -19,6 +19,7 @@
 #define   NFP_NET_VF_CFG_MB_CAP_SPOOF			  (0x1 << 2)
 #define   NFP_NET_VF_CFG_MB_CAP_LINK_STATE		  (0x1 << 3)
 #define   NFP_NET_VF_CFG_MB_CAP_TRUST			  (0x1 << 4)
+#define   NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO		  (0x1 << 5)
 #define NFP_NET_VF_CFG_MB_RET				0x2
 #define NFP_NET_VF_CFG_MB_UPD				0x4
 #define   NFP_NET_VF_CFG_MB_UPD_MAC			  (0x1 << 0)
@@ -26,6 +27,7 @@
 #define   NFP_NET_VF_CFG_MB_UPD_SPOOF			  (0x1 << 2)
 #define   NFP_NET_VF_CFG_MB_UPD_LINK_STATE		  (0x1 << 3)
 #define   NFP_NET_VF_CFG_MB_UPD_TRUST			  (0x1 << 4)
+#define   NFP_NET_VF_CFG_MB_UPD_VLAN_PROTO		  (0x1 << 5)
 #define NFP_NET_VF_CFG_MB_VF_NUM			0x7
 
 /* VF config entry
@@ -43,6 +45,7 @@
 #define     NFP_NET_VF_CFG_LS_MODE_ENABLE		    1
 #define     NFP_NET_VF_CFG_LS_MODE_DISABLE		    2
 #define NFP_NET_VF_CFG_VLAN				0x8
+#define   NFP_NET_VF_CFG_VLAN_PROT			  0xffff0000
 #define   NFP_NET_VF_CFG_VLAN_QOS			  0xe000
 #define   NFP_NET_VF_CFG_VLAN_VID			  0x0fff
 
-- 
2.30.2

