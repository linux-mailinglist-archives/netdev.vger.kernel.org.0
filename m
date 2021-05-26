Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978D8391669
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhEZLpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:45:53 -0400
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:35859
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230499AbhEZLpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 07:45:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MybJq1/HSWnU3QyjZnr+Uyn990AFgnVu2IWjfXGNv0oAtTiCStnRs/HVr3vRK0rdancvx54R3FLTteiS8RwaE5EQ6yV1etIdaKwLyHkpsyI8hNckIMWcuIJkokL7Dr7HYMJLk/jyRIkL5s+phBap/eyy7cJYnK9hXv7X1cw/ltJq5JBA21bDdfiHlrZfeRSTqwh0FDQYMLwdNm4pejFuemXkmk7P5s4yryZ1Oi3pf/Ra09qvjwZqFnl/0z+qP0xlSsee+Pcg8fwsEfCO9PH5+iOCN7Q8MJIOQ8gTR9vHwR/+US4l+tI+WEDatMjGd4KXMhnKT4BgXLzL/O0j8i7qWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiafJ8DufxSI+YYQNcz5dhP1jhbgwZVNwDn2kBgZZfc=;
 b=k6xBpPc70NqISgvYwhpzqv++drqtjEQ0q2Le9PWo1l4ly6HqqIfbAa8zpZNiM30uB6rZRaCtA9brZh1AKwoWpt9njmjGSqxjJHAIQxnn2jrIRmgUnRwZC2iL0YwaXP/YdeEFdfXTRl6Y1xmOLSwHm+/GHkFBQxyhZKMBoaIGmZxIvpLixEMX9i3qbrZqTvRrXHEiC/KR4G5+H22bixm8aR+V0V12IY+/9MNHFNGIIyS+ZYiTWiO/Go2NFvFgRuYnzuYy8vwL8TW55gt3wjK1HH7N8umwc4B0KSG5cPp7DeR9S8dYlcHHIOCfsPulqOCVwjJjcIiTyIeVUD+rNl4Qog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiafJ8DufxSI+YYQNcz5dhP1jhbgwZVNwDn2kBgZZfc=;
 b=lgQ5SKg/3kqrpKNtWuYhudzNAZthW3MXmTcdkL2l6MlXzxOCH+Hi3b3f8QWO4JuFaHK8cZrAxU5Z08FeaNfPrhKbtzeQ8KZMlOIg3U9f453b2cVoqgeYyF7S52rCkMDm9oxe/Nv2HLrDSNDtcE0oPKqYJw2w47A0cp1yBmHsvQ0bzjb1fVOb4D7IYNE8ShnaH81oBOSyTzT53iz55xT3fWOg/R2gzgbj45XquHZaCGnvH6mOdIZuoDEG9eFPRM40mccivB+hvOJ0CgkqRm91IPW6VQ7deh27kvVOB4qI6cvL0WYQjSsBcnfEoRHlMQTlWzi5nVTV8Pf09BSZbdxwXg==
Received: from MWHPR04CA0046.namprd04.prod.outlook.com (2603:10b6:300:ee::32)
 by MW2PR12MB2460.namprd12.prod.outlook.com (2603:10b6:907:9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Wed, 26 May
 2021 11:44:18 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::b9) by MWHPR04CA0046.outlook.office365.com
 (2603:10b6:300:ee::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 11:44:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 11:44:18 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 11:44:17 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.145.6) by
 mail.nvidia.com (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via
 Frontend Transport; Wed, 26 May 2021 11:44:14 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] net/sched: act_ct: Offload connections with commit action
Date:   Wed, 26 May 2021 14:44:09 +0300
Message-ID: <1622029449-27060-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53585266-e3e5-4185-52ac-08d9203b9878
X-MS-TrafficTypeDiagnostic: MW2PR12MB2460:
X-Microsoft-Antispam-PRVS: <MW2PR12MB246024FF428FB42836F5C000C2249@MW2PR12MB2460.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /f6PhfybNT6Xgmpklv/XJBWlEfduP+moWdpQBLJomfYhQP5gGZuP7Bm/YhZUqA2eU/32bQa7Ysoqv2xUPII1lbST7CS4IfBcBBPCGCwurNTw4WbAILcoNBpjvXwMyFq6d134EHDR9otSxzUJ+qAEfBiozPG7uBCXs5yWvMvyaZQB2GeeLU5hT1CorIIrOoCjGPhDAbsY/JqpEsd+u73J5wUaVYgvASEnx49CithsxrckjAc0c1rsa3CpGYNTa8TQhcZMLa/CGx+yCW7gEArMDt3Qu9FC+LHGel4kA/A/YVFu6fSVvvOi87Fz9znPuqUxODvNe0Qp5owD4qeSvX/A37GgVbp99y6JzlM6te7mfJOvQOE2+WBt5FWPcwqGLC9ccCELCbs7lLxy5SVC2X1qMrwyY3iP+3Fg5bFk53kkzYaUeJR6NjTMp0OEttDEZJBiFozwfeW0mxTSAzSy3tgf6eMr1xSNKfQx2eHbe0J7EGIzPnU5uwJCfUQoWvEU/aqdx6JKt9dC04ip4QmGLwWZednlwROSlNHH8JvybjmSY4jwJQKgEAt6d/a871AXbR/wfJnU9MGBZIGDPzc1xUHH074/9ojT8fb068xq+cUSinMZpWEHEqdq7gpZ6RdpjXr6xww6afeQx8DYgNNU/wozAmh9jfitdHbJpxoJYKF4W0Y=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39840400004)(346002)(136003)(376002)(36840700001)(46966006)(107886003)(8936002)(6666004)(5660300002)(7636003)(2906002)(82310400003)(86362001)(36860700001)(4326008)(8676002)(83380400001)(70206006)(356005)(47076005)(54906003)(70586007)(36756003)(478600001)(26005)(186003)(336012)(426003)(110136005)(316002)(2616005)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 11:44:18.1708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53585266-e3e5-4185-52ac-08d9203b9878
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2460
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

Fixes: 46475bb20f4b ("net/sched: act_ct: Software offload of established flows")
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

