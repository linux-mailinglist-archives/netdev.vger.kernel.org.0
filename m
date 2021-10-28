Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF0B43E0F0
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhJ1M1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:27:41 -0400
Received: from mail-dm6nam11on2050.outbound.protection.outlook.com ([40.107.223.50]:20320
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230478AbhJ1M1j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:27:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXY964BytgG2Ou18s7KeoEfUW8Uq5coKYrUQhFISetIvGC1LMEJfwqmx9+hrnQcMhccurplozDJrSfkj7rB0Lq4SgaCGv2Lr8UwjFNjtbKSoEe0OM8DlKHUnY9Bc87m2AnpeGt87dShuuhuoglcbiHLpHpdUQMKQmrNrvKl2DyyKpLFTY8QlNcGkVOnxm0Iy5+dhLt6YO+A0POs2c/v+Q5PUzJSi254seu4hBcj4h7wo+Z4oqmm6NhtbhjY7d6xhqB9VAg6eEwtkFr4eTwCwWRMLFxiKwnm5mfbKLzHDTGbSiv4/0tTQnu6GF6g5CHqGUCozWR2xGAYPljyBvwib9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/gZDhH5cx6iGk/HHwDPsHxpPcBTqgCARL/MXxhkqu4=;
 b=ip0j3GrMq5zCEVr7lx2W/OydccmchF7Gz2wsUhbOBijnj/hUjm/vff7rJnzIKN6bvULhfKf2RTLVhYw2BFSRem9/yLBhavYmvdUa/cjls5PfIgZVr7fdZHljdbh8fAl1aiH4C2WNG/DoUT6tMlxGcqcjvUIyAOWFoUAbf8QH71o9gni2DsNsIKKscETIEN/h2Y3x+l7rllKoYPcvzbae96BmbTo8WwendDSZFbonu5cm2JGw2jvKnAQz7Xoa32Ab6x0uQKbsHaABmZRpOK3EnSy/Mj2Jlqgx6BDegxna6GSJmfZZt/ewP3zEboRquYaZHHrG2grXiuonm6RZ3TJgQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/gZDhH5cx6iGk/HHwDPsHxpPcBTqgCARL/MXxhkqu4=;
 b=KKMZG25yuH7/rMhfmi+SbXTYPNASkBB3eqooIVmC26ogIXhIdFtpnadDXqQA/WNkOVjihEtnRBpal7MnES3IK6n+c7Zo6erMO60ePdj7bybDFna+WQWi30zI+VKCLL3IH/Sx/HvV4/GMYelNRDo0Jwvg7mN1hGDSDDwj/R98tM3NMC3Q+cxtP+yxZY9CFjggAMGlJl9/aZQtHk9dDo0UHd3KxAc/nfL1f82wvPVrqf6cgYMWOLhnS5PCL0Sl3QcQLFU1sR71ug8CuyijGfBtV4vi/7erYAZ+52hKeT+zek/QdfrsF/Dp4NRFqFcSY8jbpSx0fIFF2sDDo+e2ur1IBw==
Received: from DM5PR05CA0001.namprd05.prod.outlook.com (2603:10b6:3:d4::11) by
 DM5PR12MB1483.namprd12.prod.outlook.com (2603:10b6:4:d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.20; Thu, 28 Oct 2021 12:25:10 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::41) by DM5PR05CA0001.outlook.office365.com
 (2603:10b6:3:d4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4 via Frontend
 Transport; Thu, 28 Oct 2021 12:25:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Thu, 28 Oct 2021 12:25:10 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 28 Oct
 2021 12:24:46 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 28 Oct 2021 12:24:43 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net-next] sch_htb: Add extack messages for EOPNOTSUPP errors
Date:   Thu, 28 Oct 2021 15:24:36 +0300
Message-ID: <20211028122436.4089238-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91c49398-67f6-4ce8-3fdd-08d99a0dfbe8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1483:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1483F64EF99EEEB4710CF43CDC869@DM5PR12MB1483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sa6+SdN4ps4uenN8B4UCMi8S91wWHlEXFlkfxRyYCu7KatfjA32Mj6NFesnA389tUV5SyLVNkweQb6jbhX8j13sEb6CXpk4GyiZnLnJbTEf/8h0sKTbHu0n2aHOGpYy0KKgFKXuy2nxc0KO4JsXhg8V/p35hUe8n8FQMwTgi0RqUOfqiFj1UXOS1z+GpWob1KxvEtjEbaqqh4LNLrWNHp7w48pI1lf9cmEOhIAKLPCCCwsAzbJf3dp3PJmErG0/8X4Vb2u8XSwSEsUucG1srrdqMYv/2/y8XNps5b0yMYQK3GbslG8ss7AhUzPcYrKrVAtti6b0wv4a7k+h7ur/wbmkVrKGeuEnC1O4/XJIkzT/XLPtV6glsElA6WcuL0U0+UNulaapsYZMtOpWbI7HS+GFVGlblXsvViDJD3U3mH/K7Um6M128xDULd047zOS+ahp7RSGAYz1DLTAYOHX8pTTo+CKn9Y53cpVkzxcAYGg4xjqVpBg21uJM37Bz1gO+n09V5XMiMO0FXw7gkcSDcmwniyLeqiL173J3rHzpg/UzFIKrFe2+/D8EkFc8WVpeNe0jke3LDcQKHaT+MCU3gZdunUSMTEVBKPB8V9uayZNxVq0InWk4kZK+OxEjQFe6Ru/3I3MWmcU49ppdowEw2k8z8iXAzgCf39oFJqFIMDgIhpU7pagWP5dUZe8svB78H8APixqvtJvbDlhNYlsywhg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(1076003)(508600001)(15650500001)(7696005)(36906005)(186003)(7636003)(54906003)(70206006)(4326008)(70586007)(6666004)(36756003)(86362001)(316002)(356005)(8676002)(36860700001)(2616005)(107886003)(2906002)(83380400001)(26005)(110136005)(8936002)(426003)(5660300002)(336012)(47076005)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 12:25:10.0130
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c49398-67f6-4ce8-3fdd-08d99a0dfbe8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1483
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to make the "Operation not supported" message clearer to the
user, add extack messages explaining why exactly adding offloaded HTB
could be not supported in each case.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/sched/sch_htb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index cf1d45db4e84..9267922ea9c3 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1084,11 +1084,15 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
 
 	if (offload) {
-		if (sch->parent != TC_H_ROOT)
+		if (sch->parent != TC_H_ROOT) {
+			NL_SET_ERR_MSG(extack, "HTB must be the root qdisc to use offload");
 			return -EOPNOTSUPP;
+		}
 
-		if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
+		if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc) {
+			NL_SET_ERR_MSG(extack, "hw-tc-offload ethtool feature flag must be on");
 			return -EOPNOTSUPP;
+		}
 
 		q->num_direct_qdiscs = dev->real_num_tx_queues;
 		q->direct_qdiscs = kcalloc(q->num_direct_qdiscs,
-- 
2.25.1

