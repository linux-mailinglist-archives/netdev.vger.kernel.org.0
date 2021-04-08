Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B763584E7
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhDHNkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:40:14 -0400
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:26816
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231765AbhDHNkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:40:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wq+2qBH9Kj1ev6Awf+/O4AWIn7YLiy8Zpi1Xt9GxWkOHuc5V95BrXB1s3qmSHtUKL8k+lIaBxVkIk6caa3fK3KNYlRRdjbxe+PxMnaIt+Dle3ej5GqRNnAMwrZJJrRBUTSxtwo0y5xx4MB2Bkw9glOb/rpPvFJPN8gnyWpAzuAbISEgF/VL5yLP7LVzl9pTpgFuUcXXPoD9ERsNDi2NAXwgJXsbrbg6AVzzu+e/iM/aewzCdllhDhELAnxcCNWY3lopGe2KM+Fvpsp1Oip9Sq6qj2r1fa2tNdAVimGV2ldVQ8QzwKl1XJfrGEj3VBBsWdbTp3dDS/g+61hRcp/D4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n44fdZ1pttfQWhuy4c3KI2VhfuQZkvMOeKftof3cSfg=;
 b=A3Q6qK7+iEVhDPpZS0kUbyzidWHZoO1By4LDHEiK9d23SlDUmnvs3qW0UW/vcFTa3RpC/G48wgnmhmnPD36JyiUoCibNmIvx4qlQ09GAWKCRxinOIMODHpM5HhuqBdiYs1RBoTSdgJjZAIMJLnAFo4YoiiFul7QdGFtnfM8wBW8zYTd7YMHPVOvxvo6TaMmTki9PiTknTjgVaA2tLTSAcVY0WuTZw29C7yg6IarKw/g96fMz6J9aBPJ/ho+uxVguGvm9Osw9L3g6b/Dwcf4Lj8BrV2JrPc1qdde4cRNCip4kFIU05Koza0sf9m2eEzOg6YsD09t1qfw/04kzCij6kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n44fdZ1pttfQWhuy4c3KI2VhfuQZkvMOeKftof3cSfg=;
 b=XmgaP7Trozqmoic31VWU9G5lAg7VNm5C9tm2fnOf3OO81yugnTsLT7RxwsAai0t9rzU7NR2/IQef94Ctuj2u5AqLl4u52RfbVAaNbCurdQs+iLaKHSR15YqBVatvhRpGhMOYOucH5CkP9RRFqqHfMyprPh8PR1IPYJF87rZmgDWqMHQlTSxhJVZ0iDZuQqAmSGAFfK+5X/8QZpit3moYLjlQWOlPPgIzswNhVey2kQ9jqGIRWzEt5V+bGgoLT+cqfv/71N8m2AGEjRX/OcGQ6rcK+c0zAzrL6sxja+0dE5M3SeM/7ZPIeF2Rous7659YB6LBk6DwzS4et4ELbKxWBQ==
Received: from BN6PR11CA0002.namprd11.prod.outlook.com (2603:10b6:405:2::12)
 by DM6PR12MB3580.namprd12.prod.outlook.com (2603:10b6:5:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 13:40:00 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:2:cafe::fb) by BN6PR11CA0002.outlook.office365.com
 (2603:10b6:405:2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 13:40:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:39:59 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 13:39:56 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 2/7] net: sched: Make the action trap_fwd offloadable
Date:   Thu, 8 Apr 2021 15:38:24 +0200
Message-ID: <20210408133829.2135103-3-petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210408133829.2135103-1-petrm@nvidia.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 572ba4ea-c8ee-4c94-357e-08d8fa93ce4b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3580:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3580561F2506D1B91158E7FFD6749@DM6PR12MB3580.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QB0Ik3mFvuWbd3o5fRiG4zL3kiIYEQy0+42hE4alKt8Y5GOfhOzZH27shsjweoQlYacD/yrLQBHzg9F1om/+gIpF+JQxUi+SndpRxquqozCXR8a5qQ1mozS837Dh7U9tU07Tc7GfiEDdqPBhLksjCUxNhEoe5aIHS/tXB/GwClqVQjuDGpV/xkakIF/JfgAk2HhJLKeCONcg5lAk/mvIPzB0wsyhK2+n2xwI8q4Ssw4q5DdpNSU/FAnQIBtmoBk9n/Xywr4Z8eGQYYbIMe9cSRnTQPZZFScUtugNuDd4v1G56rJABhNoctvtWfaPwnnXtOa3dSocpT3LqbnmZiDjGJD6Cy8LB+IXAWiEZdhsH5oI+6ve867hqTdE7PVyEDYgWr85GexH+Akmf9wtNXJRFI5VzEYdfSN3XJ75VmfmOXHpmWmDUJvO1z/9JiXVmb+CI46qTGzYr+Aiznabx3UH/VWjGBzZPHL4y7Vi28X4eZx/AimzBbcjBi6cEmEeCpn8rZXQNaaIeIlsjPWnb0JjaSubzcLi3AKncleFwS1tQGX1i9SKzv7eXjHyieA8UT2kPfu4AKyLva7bBVn1/dCbAoeFBfw3Slrs/YxMPqSQShFGRti89/cUFhiS9eaCExFRcyNp6nKLcNG0u6ESMF8Ubg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(36840700001)(46966006)(26005)(16526019)(336012)(54906003)(36756003)(70206006)(70586007)(186003)(2906002)(36860700001)(316002)(4326008)(5660300002)(47076005)(36906005)(356005)(478600001)(8676002)(86362001)(2616005)(82310400003)(7636003)(8936002)(1076003)(6666004)(82740400003)(6916009)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:39:59.9308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 572ba4ea-c8ee-4c94-357e-08d8fa93ce4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3580
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the new flow action and related support so that drivers can offload the
trap_fwd action.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/flow_offload.h   | 1 +
 include/net/tc_act/tc_gact.h | 5 +++++
 net/sched/cls_api.c          | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index dc5c1e69cd9f..5f35523f12b5 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -121,6 +121,7 @@ enum flow_action_id {
 	FLOW_ACTION_ACCEPT		= 0,
 	FLOW_ACTION_DROP,
 	FLOW_ACTION_TRAP,
+	FLOW_ACTION_TRAP_FWD,
 	FLOW_ACTION_GOTO,
 	FLOW_ACTION_REDIRECT,
 	FLOW_ACTION_MIRRED,
diff --git a/include/net/tc_act/tc_gact.h b/include/net/tc_act/tc_gact.h
index eb8f01c819e6..df9e0a19c826 100644
--- a/include/net/tc_act/tc_gact.h
+++ b/include/net/tc_act/tc_gact.h
@@ -49,6 +49,11 @@ static inline bool is_tcf_gact_trap(const struct tc_action *a)
 	return __is_tcf_gact_act(a, TC_ACT_TRAP, false);
 }
 
+static inline bool is_tcf_gact_trap_fwd(const struct tc_action *a)
+{
+	return __is_tcf_gact_act(a, TC_ACT_TRAP_FWD, false);
+}
+
 static inline bool is_tcf_gact_goto_chain(const struct tc_action *a)
 {
 	return __is_tcf_gact_act(a, TC_ACT_GOTO_CHAIN, true);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d3db70865d66..95e37eb50173 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3582,6 +3582,8 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->id = FLOW_ACTION_DROP;
 		} else if (is_tcf_gact_trap(act)) {
 			entry->id = FLOW_ACTION_TRAP;
+		} else if (is_tcf_gact_trap_fwd(act)) {
+			entry->id = FLOW_ACTION_TRAP_FWD;
 		} else if (is_tcf_gact_goto_chain(act)) {
 			entry->id = FLOW_ACTION_GOTO;
 			entry->chain_index = tcf_gact_goto_chain_index(act);
-- 
2.26.2

