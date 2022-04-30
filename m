Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3565160ED
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 01:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiD3XPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 19:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiD3XPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 19:15:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2109.outbound.protection.outlook.com [40.107.92.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFF22CE25
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 16:12:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqq06SpzhNSUHCYnj33w+qkVojtlN9nQ9mMTYygctpv9VcGXm+PcVskXxF600HIL4Z0qIA0niEmFqVuG2sl+pSeThwoyhz77HA/hhrOzFTd6rj6njs4V39HBQN3wCs8+2zvipHCh0Dc370mjOUpI4QjpjhdYQO8MC31AFCzKtJILMQpRX5uQMog9rccyDhACa9ELrSiWdKyvXw562shRq4URpsn40wnKVdPEkSqPKwTTCuDoEeE22rdd6SHfOs96PnXhkbcT0piPmzmFCyc6MWgRuNN7I/gxX54imuDC3T9AI1lu1ZVndF8e6G2KpWSFZccj/ee35JD3GFcLFd4uTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Go1jUj/jchySeeQj7v4FhxdA0QxQrIKhxn7S4dHAgKY=;
 b=c1ubmHQ4ahTIw77fVeC3HwACRrAAhvCBuRBlLOoBIRHwZTxUpyTTHipNL2LwH6ASZ37bUMd/4lJatyWNszshLLArxXQMJ0C6ZdR/FRuK8G5GUB64g8IbQFRsFyB01t3tEf3Cqigt8wkGc4wh+GI6g6kYRuAEtD82m79W095JTXILC6l2M4NbIdGE9OIZgmJbi8dPk3yDYheJsks0ZYoCOnB5UwHtTGPSJK0uhQu8/JS2g2hizF5qpz8cQdvOIfpiqR0Nd5tEAnln6Oa52TWyC3QTeFSyPQ/twl3JQwhQ0P5Tt3YPz7qBfNSUcROtfKJNMngnFgJyT94n+3CsJ5UW7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Go1jUj/jchySeeQj7v4FhxdA0QxQrIKhxn7S4dHAgKY=;
 b=ldwCb/Sd4gx0E9tSFNm1kVIM6X7CcNTvmjIbt4aLLxthPft3N71f6zZuzKtu/kxUwGZdY6ri7uqRFxaw/wAZHI+cOsIheTLUWY80WCSYJ+0s5BNDYtY2EIgN1d1bFuQbFMe0RdO2V4P5VSKrn3rG7u6rMma2vZxU0nwsuYhoy5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1191.namprd13.prod.outlook.com (2603:10b6:903:43::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Sat, 30 Apr
 2022 23:12:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Sat, 30 Apr 2022
 23:12:08 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH] nfp: support VxLAN inner TSO with GSO_PARTIAL offload
Date:   Sun,  1 May 2022 08:11:50 +0900
Message-Id: <20220430231150.175270-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: OS0PR01CA0048.jpnprd01.prod.outlook.com
 (2603:1096:604:98::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c71a654c-fc2b-4f36-a067-08da2afed963
X-MS-TrafficTypeDiagnostic: CY4PR13MB1191:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1191DF15B53580BA3C150510E8FF9@CY4PR13MB1191.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: olmbhsj/TQzKt2cklQbUokV8D2O6Lq2rDZFlfjiR2US9MkGRruTEpa0pyaPRal7zGXY823xV4+KlwR4grsjZCP57AKunNeE4y7FZIGctgZmy82sui17Hx8mQ2LALNw+VZYuqiWYTfqYG1Y3DXY5C86F8I+q1SECeS8mq6XGzrDAVGGcBuO7WhX88kIShdCZkCAVfUgES0UKlU6o84pgkXpgR/ParjThOym6kNaBcXkQxz0tXHLKA102ZScAK2Q/lFsetoCgOWrs7k05LvHVDzu+gsUG5QewsP+YSHIfnaB58GLjFnCJgF8pAtycyw5t5fllQO+Gmvgc1oqxll72IV3zB0175g9OYDhB2U+Usfbzq3utJJufLC+dJTsvb6OSUHysV177MaHkLfRQ32pZGSjMeY9nWRW1z+ZmThdyhpyO+tp4D3/2Px8/fIf+a5A+qesI/1jin9rjh6Llbv+2iGkeYbgxFZZfHRKQgOtkhcDKvNvOkq/dFWyR0oKbANCU/SJJhdyjwCNZZ2itpuvFNsNZKOJqPCoDBsMsMfnF2RYoxq2iweFx/2Ghgbt8/yEyCRSyzlQvZ9FaErLTiVom2VvIRLTo9HSE87zxjijvCIWmO45N3OchUTnRKxevWd2yFjSNJ0Vz0wUnP7YJVY9guurRKvJyS0FcIUumWQrVOBsjXefEIom1WyRHVUwFsCjdrEwHuNBkr0AX3XhV1Vf/qMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(396003)(39830400003)(376002)(346002)(316002)(86362001)(6486002)(2616005)(8676002)(4326008)(508600001)(38100700002)(38350700002)(66556008)(66476007)(66946007)(110136005)(6512007)(83380400001)(26005)(6666004)(44832011)(36756003)(52116002)(6506007)(8936002)(2906002)(107886003)(1076003)(5660300002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MFW+saMVKELHZ1Swf+mIVtHPpMnpJ0+C0uXmRlQ5kQQspqa2tMdUEBEtTn4w?=
 =?us-ascii?Q?nc37tXxFFkL9J9F4BFmHLBCxjbNnscBJqmJWxDPGzqJEPprHOiMxQ7OJ7w7U?=
 =?us-ascii?Q?+fl8OWJRp7jkVnzPB23sRddcwPb5CHm9JiaVY6YXTw4xz1nPCSXA3Fha8Llh?=
 =?us-ascii?Q?j3a9b7nIj02BY6IniSVsGwyUPxdoQ3BP5+ZGuAE5Hgk4ggHfWY+tILPj7EU0?=
 =?us-ascii?Q?LvaRbFc40ig+mt8OPicJS2B7D8TL8eucFdZX3n2Y39BzfKS9NKliz7hMDEux?=
 =?us-ascii?Q?ZDhBegce6xQzf5WPXp7oMIRwZHrfrbw4bCYuAAy947jyGFT7OWW3+Cjca5Um?=
 =?us-ascii?Q?aQAFlRBQZFb6ii9gLs1ZE268tOqvVIxVXapk3oUoBLz3xk3ENc7RhVRU9xpw?=
 =?us-ascii?Q?wxgNHhld301/lXuzG2ZEfjodm8kJIrrqBoyen9kAQrBzycYd6HFX8W5J6bCX?=
 =?us-ascii?Q?TXmr7IahQbGujMB8iQF7AI3jPelhkAQKVCN8LnRdSoS4Yd2MeYIUbJ9OnZNi?=
 =?us-ascii?Q?VWc6RjXaO8Mq6vzUK/PdJ9uWb+sfM0V373TOgcqC6PufbgorXVdS9/yimvoP?=
 =?us-ascii?Q?jlsc3XRI9+T/gMRGTTw50WTofeblSplaefzQTmvCggbmaJ5buU5g8TDSEVpi?=
 =?us-ascii?Q?gGCxhXzGIesImJPpFrKcJHOGhXyl/tpX+5OzunItKv7U95hjHV+V4oh4zJE8?=
 =?us-ascii?Q?RyVR1Zmjcv0AJsq6vvKJMFyJR6a0mnUjiPQ4j2/3/sQXoXrvf3aIYvBPL1Yp?=
 =?us-ascii?Q?j7QVcPvRPjbABhyXczR+g9SIX9eZVcDf4/P+4Vg2ShM2fcztYK9WrrYSXDkW?=
 =?us-ascii?Q?BU1AsIdb6apw7lMJx72+WXPcvxOPfHEsbtLg8a4S6EJBER7unnsphbrmZzpE?=
 =?us-ascii?Q?LH2whOXcC5YxIRHppNvqdOOJOoyTSNBbF4QEg3YHgRwX8ZaYjIeC1TnarQQL?=
 =?us-ascii?Q?vMkhQI8eWgIwv30Xcwgw78kVO+25SHEHSnfVMHaos/cKjN0JA6UOCoQbuz88?=
 =?us-ascii?Q?gT+/v7dHynlqVpXyNJ6psp5W2V3VrAVY1WeWiwl80oh/8M2wx6eJu09X/bwi?=
 =?us-ascii?Q?bYOLiyyteCw/xCQwOI658rGzguBOUxP1EyyC8gdu9zZEMhoK5JpOyeC5cY0K?=
 =?us-ascii?Q?qG48CG9AJqL0bY8QQqTwOx9nNuOB+xgMd/UjmPJi1vkEXnLsleuoTH8q0EYt?=
 =?us-ascii?Q?A4+opcCNO72pY8DVizAi5uJSJ6lyjMz5ApmM+xuQ5H1MJfPOVgEU4zV2mUTn?=
 =?us-ascii?Q?dcdSHr/HOWVcIGFKqv/ZJGSzkUbPWWd5I9Bh6b5ziWeX2wHEXrzjvbNqWS/X?=
 =?us-ascii?Q?vD9iiT3i1kTCPV8X/7nq6P/28zUkTiFFqffG2HBd+FuOKFsXW+fGdRd/lrV+?=
 =?us-ascii?Q?gfm99UPsETDBWoURq6RTyPZTTA+ZfpNDWaTgue694uN7xgyEAowqWXJJ0hiK?=
 =?us-ascii?Q?vjVBFnWwkpq0D3btJtsL+MmG9Uj7z3LBKaaBwrdOmGmpXWUa0AQA8Ul7znUU?=
 =?us-ascii?Q?1rmxCxu5olToOdCrcba15tK43Gn+oyKWsfkfG8pRd5W1LfxeI7gHdOVaGMUv?=
 =?us-ascii?Q?T7T5WAVebiYDDwXTK5aZpWIWuLmDCpnukMbOEfoIxna5MqXoSXby6ZLqrrDc?=
 =?us-ascii?Q?7KHWq/iNGqAiB6dd9P4+a0zI9zJmVW8zFeDTBjTohLMCnUTLnB4Sur2Ywjae?=
 =?us-ascii?Q?BsZk1C63YPCQHTFvflf4BdvUAHXuiRGfb1RE7npXr+afG5fykXAEYPt8vrNY?=
 =?us-ascii?Q?v9uMBSVVpF0nmDte/2DxCjLtxBfk5FU=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c71a654c-fc2b-4f36-a067-08da2afed963
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 23:12:08.6090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YANBx38ITqYfSjrjY7SiAvLL8jnlA3kueZGQ4dIMG8zU6RxUNjOU6jnycDwD9l2QFY5bdrk2mkJqf7IjjjqWly2axxS7WCBGGRipKZoM/RA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1191
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fei Qin <fei.qin@corigine.com>

VxLAN belongs to UDP-based encapsulation protocol. Inner TSO for VxLAN
packet with udpcsum requires offloading of outer header csum.

The device doesn't support outer header csum offload. However, inner TSO
for VxLAN with udpcsum can still work with GSO_PARTIAL offload, which
means outer udp csum computed by stack and inner tcp segmentation finished
by hardware. Thus, the patch enable features "NETIF_F_GSO_UDP_TUNNEL_CSUM"
and "NETIF_F_GSO_PARTIAL" and set gso_partial_features.

Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b412670d89b2..5528d12d1f48 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2259,8 +2259,12 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	if (nn->cap & NFP_NET_CFG_CTRL_RSS_ANY)
 		netdev->hw_features |= NETIF_F_RXHASH;
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
-		if (nn->cap & NFP_NET_CFG_CTRL_LSO)
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+		if (nn->cap & NFP_NET_CFG_CTRL_LSO) {
+			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM |
+					       NETIF_F_GSO_PARTIAL;
+			netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		}
 		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_VXLAN;
 	}
-- 
2.30.2

