Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2273738E0
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 12:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhEEK5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 06:57:11 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:55905
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231431AbhEEK5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 06:57:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIU2P5TI7gWIe+QWfZUsvoRHd9RtDWIHf03dYSeiqXfQmkcGhYodmP9gmGCoTn3fwfgjpYwikk7/L5VF8uLsy5k0HvYCfKbSKCIkTUgGB3JoYJDLBvKX1pVWDb8+d6RSSDlck7EhcnljSNx1MaMcgM18M1GonExuBy18YHoS67VlN0bFiizXHvDQGh5zuxk5N36QriKa7gRQ7xFmkRcj26TbKwLPEDhw13R32ILjBTvk2yYnk3kp7HZ9D1pptFTQe9S5lgMmLajbKbc8AIV5lXU1JTmogol60sb/1twe814aQ45bbbFbC0AC9PzrbljH9o3hMzyLJJcPOtXpAsH5sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brCNLR8tj41p5nVQfdUojEFCAyP6BO4MQz0HDlfuQH8=;
 b=UCPJVfocsKu6HVDFEDiLcGRlVdHWS1l+yBRxIeBWGMeACPRyYdD1z4d+ajDT0H/0JGLBF2kGatN5kDJKraYghLmDbTKpsiKC+FKVuffcyf7q/pepCjfKNW2gtuIYbpJaVo8DvTAn13BKtH866t81RTKsh+j5Fo8gFx3RkCkI0AHevVliQrpkVnBdfPRmAXqSqRRuVn+dvwxY2smtdcqmA110ai5ZfU3PsoIPhx7f/IsYP+IP3U9wqsGi2El1aJkpwbKLZ8HBC1oMcHBpVBkUMf0BsB2j9TyiBQSchNoOc1KJQ9vSF74MY2woxMDZqOYZE31PfuTs4sKUymXGMrB7NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brCNLR8tj41p5nVQfdUojEFCAyP6BO4MQz0HDlfuQH8=;
 b=smSdGGbWncDdYLBriePX4h1jgyVwZop7sRIlKhyjd0blTyCkl7jAx2jqwb/S0UABJ+8VqX9ngkxsfQum/kcmBKxH4GqpmD+1xwkaUGYJoM89vrnCIu7oA96jdbGZGhtvuXLbRrPYFhludz/MLX5C1S+7y0LQ97hjGKVVkXLjh/g+gSmEf28rH0RvRoQRzSBHaFbFf8ww6YPNNs5+Dw0BV8BrA6/7EgxiSi2e5jbQcHz46GM0paFtqjPdXgvuprVgh9R9X18S+2yqhPc5WPGd+twHxw9Qfhk6uQP9xzH3Tx2saPDYlBpe33m+Q/ZhA0YGD/vtEUji4y328dyTGRFJbw==
Received: from BN6PR1201CA0016.namprd12.prod.outlook.com
 (2603:10b6:405:4c::26) by BN7PR12MB2659.namprd12.prod.outlook.com
 (2603:10b6:408:27::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Wed, 5 May
 2021 10:56:12 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::8a) by BN6PR1201CA0016.outlook.office365.com
 (2603:10b6:405:4c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 5 May 2021 10:56:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 10:56:12 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 03:56:11 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.145.6) by
 mail.nvidia.com (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via
 Frontend Transport; Wed, 5 May 2021 03:56:08 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next] net/sched: act_ct: Offload connections with commit action
Date:   Wed, 5 May 2021 13:56:06 +0300
Message-ID: <1620212166-29031-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb40ac16-adb4-4421-ee2e-08d90fb465b1
X-MS-TrafficTypeDiagnostic: BN7PR12MB2659:
X-Microsoft-Antispam-PRVS: <BN7PR12MB265921B2DC8D792FC00B982CC2599@BN7PR12MB2659.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g05z4zLWkfrjlEzDiSyxkBE3TLyppPk3l2ZJI7H5JsoOQCiZdbim1598jBC9m0NC5t96UrXXhxJ3EEPHPu8mAUS6d07ar9ZGZRTNSGreyuakvM/wy4DP80yX3uOc3z/2BoFjtpo+Ek6HN057F+yqf5yQFBVFzJDQ3rsAVHjTNf18kbtqyeo5vHzQnOB2DStU/BRQxKHCEOV04Z3B7xoUBmREDXNJNdWmKhcyk9+NlkERwudY4NCHOASu7gyIFvTxf+fl6OU7zSsKq61PBGfUkCccOayFv0M92ktbalxup2diNI7P0N7O6crzSlAZKDNe0GTKghRjB9sV2v0iUB0DUhqsw8sS4JdBMXE2wQcZikwBwohux84mGyoyOTbQdLB1SWbYtFsaBBsMhBiiySF4rxITInKsSphmovyobWR5l67qDdUXd3fNAGyEbyVxn2nwT4NIqh+QFXwXC0oqzvsYFdvsIbqU+elwt7PmUXETNPIvGL6UTan3lR8Yl0BevxpOf11RddsEsvvNTT8pGmaQ7Le58RYsJM+5Y6m1QGMociLcSPe80lYw2aMWVkNErbonGTLsZdkloEpdc5RLWsFkBSPRtFK3CcTuX6ytQeXOwxmJu0ZqOGQItHTtv9oPgmobwQ8zlpA+8mZC7DPQjjqbXKUwww4nP142dgW9poVbhwY=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(46966006)(36840700001)(316002)(8676002)(47076005)(54906003)(186003)(82740400003)(2906002)(7636003)(110136005)(83380400001)(426003)(36756003)(356005)(26005)(82310400003)(70586007)(336012)(5660300002)(4326008)(36860700001)(86362001)(478600001)(2616005)(107886003)(70206006)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 10:56:12.2506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb40ac16-adb4-4421-ee2e-08d90fb465b1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2659
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently established connections are not offloaded if the filter has a
"ct commit" action. This behavior will not offload connections of the
following scenario:

$ tc_filter add dev $DEV ingress protocol ip prio 1 flower \
  ct_state -trk \
  action ct commit action goto chain 1

$ tc_filter add dev $DEV ingress protocol ip chain 1 prio 1 flower \
  action mirred egress redirect dev $DEV2

$ tc_filter add dev $DEV2 ingress protocol ip prio 1 flower \
  action ct commit action goto chain 1

$ tc_filter add dev $DEV2 ingress protocol ip prio 1 chain 1 flower \
  ct_state +trk+est \
  action mirred egress redirect dev $DEV

Offload established connections, regardless of the commit flag.

Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/sched/act_ct.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ec7a1c438df9..b1473a1aecdd 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -984,7 +984,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 */
 	cached = tcf_ct_skb_nfct_cached(net, skb, p->zone, force);
 	if (!cached) {
-		if (!commit && tcf_ct_flow_table_lookup(p, skb, family)) {
+		if (tcf_ct_flow_table_lookup(p, skb, family)) {
 			skip_add = true;
 			goto do_nat;
 		}
@@ -1022,10 +1022,11 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		 * even if the connection is already confirmed.
 		 */
 		nf_conntrack_confirm(skb);
-	} else if (!skip_add) {
-		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
 	}
 
+	if (!skip_add)
+		tcf_ct_flow_table_process_conn(p->ct_ft, ct, ctinfo);
+
 out_push:
 	skb_push_rcsum(skb, nh_ofs);
 
-- 
2.30.1

