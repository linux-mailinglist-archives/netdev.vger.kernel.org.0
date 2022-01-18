Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AC649250A
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 12:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbiARLhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 06:37:54 -0500
Received: from mail-co1nam11on2041.outbound.protection.outlook.com ([40.107.220.41]:28576
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232711AbiARLhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 06:37:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RdRLq1RzvQ0ZnjaAs5AysdT5QCi1yXX6mndJpCf1Yy1W1AiNEZFZfzCV4aD4TlJPNp+2q31AY6CT9BxOn4PA2JJ7ADoMKxUCm+rNtrHSIhzJxO43cC6BGoXwkch0XHHoXLVV5UkqUCHfiYcRTuGZGSK0g0nlGrBhdV0kYUvkFgaBQ1Tf1M/79UBQfxkNXvDqkJp+35HrU1pszC9XiD9use4gxGn58ipdm4d8c+Wth1ZJD0lNU8ABngUQpHK9JSYYZHwGVLpBMbELxUnrIa9h97tlZkLCjnLeeeLzp3hdEMdCsebXySzOCmo5zzLi+Y84zzWY8VkslJgWfy8Q7lhlxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/LCRg3pAKcrRxc9K5xUaTzbw/ggBoD8YQb9bPqYOEwM=;
 b=ixUDSPNC5F38HH9be/6wt36Esb78m16O54J/oZMJwTTacxenkE+pegYM2bTx8aPr6jWRjLaheNnR782zXR3hwuvh12N1BQNaVryYXbL4qBMdJ7QdBOiyUTT28ViTxDe3IxN2yPiiDM6m2JBwsvkJ/Ys6E5VG2tqac6TOPvk+JDW/ZZjvN4CrIIUkaRcwHm6SEqItS/4c3GYCmkG+gqRgd3G4IPheZ7VQemQN/vMeugn3jyr9eXN0Y156NemPSky16UsNwFlyT5lUbd8JUvkBOiDHUJwgGudGgMap+RYpe4eL/ztcH0MQvInuGuNcnlkUBBZDwD/HVzbu9QmU8IlkPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/LCRg3pAKcrRxc9K5xUaTzbw/ggBoD8YQb9bPqYOEwM=;
 b=RM2IccO5nMmmswmEiokHe2v8gBOKf/UfaH6WMT7yjr+kmnLgo+UpKvywHk5ubGKwBg+KMjPJs2fuQGxDO0bU6It092lZsox/5V7TkgcQIcHvLcTQW6bfooS53Ass5BRvAFpQ2BjdqB9upYgi0OcbUYazup7Ho6HhuTki99NYnXLVB7Kb4fVCMF6f9pzm4RnCaeOTxsQtRWKLsNdf89d1Z/GrAoGcfzfXPJ7VueDPpNE2tCVDKgcF0Ar3L3uis05aHRcp1KCxMjnjr+UcmgLZmsoISm6T2rgt99bBDGGihgsaDhwxrJgwnzyPTu5EU/bTOH9+jx5c/HVZLhbq7xX6DA==
Received: from MW4PR04CA0225.namprd04.prod.outlook.com (2603:10b6:303:87::20)
 by SN6PR12MB2621.namprd12.prod.outlook.com (2603:10b6:805:73::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Tue, 18 Jan
 2022 11:37:51 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::62) by MW4PR04CA0225.outlook.office365.com
 (2603:10b6:303:87::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Tue, 18 Jan 2022 11:37:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Tue, 18 Jan 2022 11:37:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 18 Jan
 2022 11:37:50 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 18 Jan 2022 03:37:48 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>,
        "Maksym Yaremchuk" <maksymy@nvidia.com>
Subject: [PATCH iproute2] dcb: app: Add missing "dcb app show dev X default-prio"
Date:   Tue, 18 Jan 2022 12:36:44 +0100
Message-ID: <f6e07ca31e33a673f641c9282e81ee9c3be03d3c.1642505737.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1edaecf-c9a3-435d-aeb2-08d9da76f597
X-MS-TrafficTypeDiagnostic: SN6PR12MB2621:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB26217675EC7BEE52D12886B8D6589@SN6PR12MB2621.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +pu06U0TEBc1tpZOgkeVp7yT+JOUdyeT2QZ0NVzaW2yooGQrp9Cg0Y/FG5+99PXVstX8QHCvrObAecDaiTfOoCelh1fox7XNUeL9o5bwt2wydQ+DQQG4cPoYIvOqu0kn7C/Zsl5LKOU3cGkd2agm0NAY0y5Vt03HCaClkB2BuRwDZ3vzLxGjKGTLAPheftwhC4eRuNbOuiCGmOzB7n0dn9iHNM71yvNU6GxISTXqQrxTTnbsKQ6XihKvvFUZi3PMlQjjOEMLfpZf1Fww3a95eJvBz+0vaOt1YePzaXvERAkYCT753Ye7KhlZtBI3lYJzyfURJ9vZ4CzLABHv/pQfcznh477a/qLpYNSaRg7EL0VU0v1LU/z3I6gYbW6k4yRwSrwZWgLJUUMH+R1O2a9XYsS8P2a+cLfFMYj3SdFPUK9lopg6T2zvcXb+e9dVOnQUQJzP2bta5MNqkSP6hIAHWFmRyyOH5E40xxO5NfT2q8xtZ9sCZ0DPzooHqA7Fw+UzIVx6Kq4Xpd5vXJmb4eH5wbs5AI1SZiRDTXiaQ+2nH2a2MELhJUF3kSTS05P/fDx3txW2NjE/y8JJZ+o6y4gW5EBdKtPIsof8zMHSrbJXHAM9/jeRB3VVDoTaSgvONW7z5QGO2xseFyWuco9lxVYtp2iQNSm1pTvjA0/oBuS719YRe7xPsS3SQ3Pi8mlb/7CMd30TfYLOrCH5w/xlCn7dAXS6Yv2BU5jBiXVoX0S0ChRP1gw9xMuxB8nGS1qCAwzAJMDqK4Xm9AJP/NTgBSoP0ONpLfq2yiGTxp2LK++xYoE=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(426003)(5660300002)(2616005)(47076005)(36756003)(508600001)(186003)(16526019)(356005)(4744005)(8676002)(316002)(54906003)(86362001)(7696005)(2906002)(26005)(6916009)(81166007)(336012)(6666004)(107886003)(70206006)(70586007)(40460700001)(8936002)(36860700001)(4326008)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 11:37:50.9896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1edaecf-c9a3-435d-aeb2-08d9da76f597
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2621
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the actual code exists, but we neglect to recognize "default-prio" as a
CLI key for selection of what to show.

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Tested-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 dcb/dcb_app.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 28f40614..54a95a07 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -646,6 +646,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
 			goto out;
 		} else if (matches(*argv, "ethtype-prio") == 0) {
 			dcb_app_print_ethtype_prio(&tab);
+		} else if (matches(*argv, "default-prio") == 0) {
+			dcb_app_print_default_prio(&tab);
 		} else if (matches(*argv, "dscp-prio") == 0) {
 			dcb_app_print_dscp_prio(dcb, &tab);
 		} else if (matches(*argv, "stream-port-prio") == 0) {
-- 
2.31.1

