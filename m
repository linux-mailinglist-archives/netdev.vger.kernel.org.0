Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E56337BA7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCKSEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:07 -0500
Received: from mail-eopbgr750074.outbound.protection.outlook.com ([40.107.75.74]:41157
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229942AbhCKSEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+Sd7VzoCUejWAyb0VnmAvfKFeNZXHKmB5U7a6xCapJGFJR+9Q5jTIfFYTMkLeynHLl2ZYJ2XhxHwE7l2+OXH9qfNILAWcWtb69qdp6eeTsgDlX3d1N+VBAn+vDdV7B1FOvTXrDJVldlKxCJDqpZn3M5GuAHIfepyW270lfi2TFbEOj91cjOv0+KJTxDGDQmsZKwUAt0Q9/fs1gxOdKNE7LbtHI68/QLEJLpnQfTIZrmXkIY3SOhIfQPSE6i/nRSKe833WjGFZXqgtg40cdm+2hQ8gwOtIIQ84i5J/IwuzN83v9sg/rLPCdUjCsh/MfvV59uqMG5ID0cbnULbm7ywQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFgq2Ky8ZlHp9x9luqt/0eIqnWbVAIvZjS+sKwDDeqI=;
 b=Noy/gqUg2IbI5rHPosNcAhW8GInAe8bWhpSd31Q5lMxrX3oL1byllFbi5g7i7QR9WVX87bGxViQhVwJSVjQjPEZjq91xexU/eYcPlVl8gksnkIMN0r9rYrRBDtrYzx51d8LK+iW/QpqaFmNX5YWv6uaS8sKIs1BSacxOKQKoIswm75E09q+YBKkdwd/8YFCVPh4LODasVvYaEZNhvc+zSL7jQtBMmuFiAIVkabCRmIz4hVjFEP7RSnGEKEGHxSl5nTSz9KdAS2rUURci7M6ebmeWoG/FylnLZWh5/2kvPkFtL2QgkpGvGGToKMBPIuM8tXsVPyoVkfybagudXzotSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFgq2Ky8ZlHp9x9luqt/0eIqnWbVAIvZjS+sKwDDeqI=;
 b=EdMIWbbakMWx7g0OuzKhuU5bc9xIy31jxsCDKiHzyM06PlfjRHbySuzr8XtgC+IgnbCXM6hwKL2NiBEKu20IBS2ZntoiFo6C9odOSbTw6HzUwNSH6aIqLFCMadybaQOpz7cQbmEsPsBgc+ee2Se4OIFn4aFB+BqjPVfkKcDhvU5WtIIeTh7jNjK+7aPdMksP2sZv/bke0+mwvpgvQFySJ9hUhCp/RvMTCwzFksLQepRIwmCrfQXC9++xgjSDKjlEUVuRiPY/FTxZL2UPOdbT6ugAMaL5MEPgERy8kgFhgpNHiNH2RhYFkC1M4U0qlP5j6w+In+T6waAidi9vQzcLSg==
Received: from BN1PR10CA0019.namprd10.prod.outlook.com (2603:10b6:408:e0::24)
 by BL0PR12MB2340.namprd12.prod.outlook.com (2603:10b6:207:4d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Thu, 11 Mar
 2021 18:03:58 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::a5) by BN1PR10CA0019.outlook.office365.com
 (2603:10b6:408:e0::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 18:03:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:03:57 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:03:54 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 01/14] nexthop: Pass nh_config to replace_nexthop()
Date:   Thu, 11 Mar 2021 19:03:12 +0100
Message-ID: <aa25e90d3064804db172ab5ed04c2e207ec82f58.1615485052.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615485052.git.petrm@nvidia.com>
References: <cover.1615485052.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a385d4f-d856-44eb-40d7-08d8e4b80aee
X-MS-TrafficTypeDiagnostic: BL0PR12MB2340:
X-Microsoft-Antispam-PRVS: <BL0PR12MB234057025BBD728081B63696D6909@BL0PR12MB2340.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oFCVHcBwEukJ5qrcnoqTrWhr9x2DKsXWFnHpRxHAlBjq6SPrnJwDuzMPDCdcXgq4CavuLBnlBt6gjX/nNQrE+IEt7c49MAZV71UgmCWCfTEqsp+xHyjHUUGjqaxB4l5WnKvUTA1FHukkmRY8h8+Ia6szCBN4ZtB3l5lzLGHG+XJdFGL/Juw5lm2n0/OvE47eiV22vTKs1p7qkO5ZMgdmfUiKGhy3CsKNb83TPOIH+lqFNYfboqcbiOoW4sAYVpQua5/EJWQIpC/wAzoFm5eExrEM6K5ejvxj1HPgA7swx+lQQRoQPhH+KqokNUw8BguXju+3FbAk+O2++dm967iCxQfuis8AWUnfVOjIpm6EtiMCEFoB++Mj0II9urnGZ4nP/I/n+B2NfWbujbSDgjnsHaRlaXB4O6T8vCQBSV6LUCdNolEUDGU6MDPV7i7r8vwg16MWwxPaEQnOUXohS6itroUiZhJLSNOks11lhHfabFMI1S6agEK9BaHvzZ6lh6qqdOtXg9CsWDz02LKs9T5FIYu4Ry5mtjuOk7FPna8XZsRfT2j8i2q0cWZxfyCPfVVQ7nV33qij5eqqJWsclPXoKCM3LCyV2PMIJ5a1Mua+WVH5MwKLOmLvOvafODqJCrAB3aQy7XoKV2tkTHXiIXjxmEjIimlhnZloOlzDavtZD35SAmd5riLlr065uVRhileT
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(39860400002)(46966006)(36840700001)(16526019)(186003)(36906005)(82310400003)(107886003)(7636003)(86362001)(26005)(316002)(54906003)(83380400001)(70586007)(8676002)(2906002)(47076005)(82740400003)(6666004)(70206006)(5660300002)(36860700001)(8936002)(356005)(4326008)(34020700004)(336012)(36756003)(426003)(2616005)(478600001)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:03:57.9867
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a385d4f-d856-44eb-40d7-08d8e4b80aee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2340
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, replace assumes that the new group that is given is a
fully-formed object. But mpath groups really only have one attribute, and
that is the constituent next hop configuration. This may not be universally
true. From the usability perspective, it is desirable to allow the replace
operation to adjust just the constituent next hop configuration and leave
the group attributes as such intact.

But the object that keeps track of whether an attribute was or was not
given is the nh_config object, not the next hop or next-hop group. To allow
(selective) attribute updates during NH group replacement, propagate `cfg'
to replace_nexthop() and further to replace_nexthop_grp().

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/nexthop.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 743777bce179..f723dc97dcd3 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1107,7 +1107,7 @@ static void nh_rt_cache_flush(struct net *net, struct nexthop *nh)
 }
 
 static int replace_nexthop_grp(struct net *net, struct nexthop *old,
-			       struct nexthop *new,
+			       struct nexthop *new, const struct nh_config *cfg,
 			       struct netlink_ext_ack *extack)
 {
 	struct nh_group *oldg, *newg;
@@ -1276,7 +1276,8 @@ static void nexthop_replace_notify(struct net *net, struct nexthop *nh,
 }
 
 static int replace_nexthop(struct net *net, struct nexthop *old,
-			   struct nexthop *new, struct netlink_ext_ack *extack)
+			   struct nexthop *new, const struct nh_config *cfg,
+			   struct netlink_ext_ack *extack)
 {
 	bool new_is_reject = false;
 	struct nh_grp_entry *nhge;
@@ -1319,7 +1320,7 @@ static int replace_nexthop(struct net *net, struct nexthop *old,
 	}
 
 	if (old->is_group)
-		err = replace_nexthop_grp(net, old, new, extack);
+		err = replace_nexthop_grp(net, old, new, cfg, extack);
 	else
 		err = replace_nexthop_single(net, old, new, extack);
 
@@ -1361,7 +1362,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 		} else if (new_id > nh->id) {
 			pp = &next->rb_right;
 		} else if (replace) {
-			rc = replace_nexthop(net, nh, new_nh, extack);
+			rc = replace_nexthop(net, nh, new_nh, cfg, extack);
 			if (!rc) {
 				new_nh = nh; /* send notification with old nh */
 				replace_notify = 1;
-- 
2.26.2

