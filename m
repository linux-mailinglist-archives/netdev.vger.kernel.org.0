Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB4C464ED0
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 14:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349489AbhLANf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 08:35:26 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:27793
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349463AbhLANf0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 08:35:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOVX7FNsL3zqjGrB3JrfpB7xjUHvsJWyDqPEeSHhng6oWwTLsO5e1/E8nM2NjHbAZxv10wxDlSbFeFynuWjMM7kltZcF+YIdZmvquShpQ20j3p580libLovrEZzGiyb30a6fB8QPfCJjl5PZWklJRpGfM4PK3C3yTgTfgZ2Xxr8PyVQoEmEHX7qTA00HCeb0WJomQwkKm7mLMo0B/mZK6Hcl62QiRgpUhH530/BjZ7ecMRkWt0+hAQQvh23B/3lmYl1SiHtCJn2O5ZyF6/uWl/2Uw1rp3lNAFthXiT4P6xao0pv+GPJoVL7XMvISnrdZY5lWKvxmUoo0wkMPjGHVgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFeVR2r6GVVg5XAanPBtx4EK0/gWCLLrPuX66Ty2v+w=;
 b=X9Lqit2q0WNbp6yYRrOIis2ZL44TfO7I6D0IbxTU8IWlVu6ushi3JI30MASsc+W0SMo6osl05Uv7S1VIfyKTjN5Pxy2CnfZkEWerG6jPZxIR3t4TzNrbIsrK+tUExEQ1r/CiVsvKb8Ns7RLd0KfKnr9xkPEuTJzziec1xWycUE3pHMKzjDcDavdP+1GqYMasfE1RSIqg4FHdIx1P+v4a/Lfu9yDhNttmptOAhZNslffKnrr36EBBRZuWQcYX4P36vM5wTZPS2Hz1mX4ktqfoo08h2OpUK8RcrOT3Wkw6bREunoUAGqWaWcoiLzr11ghw/FLsgL6tUTXSeRYhLm2MKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nFeVR2r6GVVg5XAanPBtx4EK0/gWCLLrPuX66Ty2v+w=;
 b=RCYeiXBSQeiU6byTkWX2Tz33T6KN8mN1biT4Zh6Gtx0BOlFEKBJ2L9Iy79hyoC0ONn0l48dRt03xww168ema7+KeMQlg1OteWN1/HLDnduCO6NOCyhOEwEGYPaNLwlqLemrqEX9aevSZFrQy/VfXggLe5eWasGSnZzX/hyVoI4bcfIHN9Cqp8wiey32Po3eegRojq7E6VHxI10jJv6FsdieVpZreqTV2zP3o1XIKqTj8Q8gsO/RsvXn2qRUsdFZn4xhUUpgsxVRhUs9TYlz0xpbzXV8Oi+cEhVNKf0jGVxW1sMZD2NEicRRTaGFGJWKu0cjqLaQHrN9iKnV1I5WqeQ==
Received: from DM5PR15CA0036.namprd15.prod.outlook.com (2603:10b6:4:4b::22) by
 MN2PR12MB3551.namprd12.prod.outlook.com (2603:10b6:208:104::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Wed, 1 Dec
 2021 13:32:03 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4b:cafe::d5) by DM5PR15CA0036.outlook.office365.com
 (2603:10b6:4:4b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Wed, 1 Dec 2021 13:32:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 1 Dec 2021 13:32:03 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 1 Dec
 2021 13:31:58 +0000
Received: from c-237-155-20-023.mtl.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Wed, 1 Dec 2021 05:31:56 -0800
From:   Chris Mi <cmi@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <ozsh@nvidia.com>,
        <roid@nvidia.com>, <paulb@nvidia.com>, Chris Mi <cmi@nvidia.com>
Subject: [PATCH net-next] net/sched: act_ct: Offload only ASSURED connections
Date:   Wed, 1 Dec 2021 15:31:53 +0200
Message-ID: <20211201133153.17884-1-cmi@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37c13075-900a-4d2e-12b9-08d9b4cef637
X-MS-TrafficTypeDiagnostic: MN2PR12MB3551:
X-Microsoft-Antispam-PRVS: <MN2PR12MB355144C0F8CAE856915962CFCF689@MN2PR12MB3551.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Os6yT6g0Te50h0aQGlV6bfc/ZI6BSPhfbPFB3dFtKFZ8wN/a7efy9vJD4oYGGdHPPQ/0CZkHiH9D8JhYLfNdmWhhuyDUwd/Wzacc14OB/Ayp6gulNRVEBNWzqr0zX0rzpR8efRfwtOgzKCWm+T8KQ5rh1NzaHbkRtmf3Y/qCFhLtC0oDpNJWCbLBmzu3WEnqkI3yqZsVAgxBsgcUCtfzLU9aMCVw+ieTDrBMC+waWzgZirJF/OLST/lcUdqZcLg0+JD7UQwX1c/Xx9gyHr4fHytJNkNBNPT6gcyo8b/ZzVgv3HcUQDtmgxNJUIE+3vkX6vsPEGXIAh5OaSWB2QmmN/KDXKIbDCCQEF/mm+oWSHw3iKIu+N9ydGMc/05CxbBEC40aoHCFl4klJV90re46+V8xJ+8LRnVNGTDBJuXJrrq2Xnl7Dj/iekvVqCEQ2xd/7I5s5nscCdlgHNyHkQIod8X+3miYV0wCMpcPH3vzlAR8H+CaY3tRnjpLNt5qxVGCLK8cB+q0lOmvaUBypm4c8M7iDFexB5g0z7CxUH03Sr2ZpMWoFhZKz8JG3qvyUdHB+VXdwdtRz+AQKobB2ceDDMnBGtvErgSIPAvoO3VoYf3h1NtyHBq9fKq2MNp3U0FYocufw28fxK0bDlmIkfkrjQR7bglmk9wPr8Ci4YcbZuVaCy8/xMMByuSGCD8Wccq+mztYrlJZ18mtVjh8FK27FLPwTbq1TOm8SxBt4ROcIw3nt6/Rdazkn8376aF4HH4o+ML4zYGxNlYib3xF+ZgQg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(2616005)(316002)(36860700001)(5660300002)(186003)(4326008)(1076003)(54906003)(40460700001)(426003)(356005)(508600001)(86362001)(2906002)(26005)(336012)(7636003)(83380400001)(82310400004)(70206006)(70586007)(6916009)(6666004)(8936002)(47076005)(107886003)(8676002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 13:32:03.5560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c13075-900a-4d2e-12b9-08d9b4cef637
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Short-lived connections increase the insertion rate requirements,
fill the offload table and provide very limited offload value since
they process a very small amount of packets. The ct ASSURED flag is
designed to filter short-lived connections for early expiration.

Offload connections when they are ESTABLISHED and ASSURED.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 net/sched/act_ct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 90866ae45573..ab1810f2e660 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -393,7 +393,8 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
 {
 	bool tcp = false;
 
-	if (ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY)
+	if ((ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY) ||
+	    !test_bit(IPS_ASSURED_BIT, &ct->status))
 		return;
 
 	switch (nf_ct_protonum(ct)) {
-- 
2.21.0

