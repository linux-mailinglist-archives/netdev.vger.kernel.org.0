Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4122F4BCF07
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243973AbiBTOG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243939AbiBTOGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:19 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC41A35DC8
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVR70UfzA/Zt0Zf9/dGMHbNjpTzwHbGdYJkGUdq1xp/XPtXKKAoPgzrfBx5mgUp88xlyya3N6zCEYZcEBuzvGnGRkG69J50I+X7CEc2jc7LTKik8y+6eM/n+oE/hrTJuOEXp2Lnn30fPAI0JgJh4kIy7e7WDHhZn9b0NuaKZPNDwBs2l0SjYzQwa1S3vWUgexRlYxXHGfaNXlzRDsA2NH6jwMe2snfoFN5OddpBHMJB3R/qC0wEZ26bNJiy8GaZLdEjFLf5RG1Za0Cba0fm6ToSRGkW7AkxPbvLr526AH9B02SQZVXFN7R65bFnuYLS1qycBPxTTw6zvMivmnWVLwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgIXhjTAOL/x7FJuAY7PxF4lkY7qFwMOxuE86ahpFGk=;
 b=Ie8eu9RuB1HAoPjdIjNPcMWX4Rmgd7gkssdgf8fc3A9doDYYiLZME6PcbmmV1Z12LHJujZ8lRSixU2x20rBWha8K4z1Boe3m3WXEmMjEJkClD0bUX8/ThIcdJyGgXDi5AhVkCDa6oigSddlxtWW4gg1JE+78dfIfaOsgmPSC1vlEpgXGWe50GO8zVQIJOx+aa/RtsI5oTxH1FKYGYvC+IrXPGlhCiofPX5ZFt+Cj94GNwO2t/S7Ux1LDFUFVsOiWiDRGTAj0+/wvmDpTnx9vf/Lc47aGessgUwdxlgDsx5uGgpcoWHvRxpk2f7NnQlVHLrHjY0YlT6w1aOfpHvEvAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgIXhjTAOL/x7FJuAY7PxF4lkY7qFwMOxuE86ahpFGk=;
 b=iuRpqN5xubkCiMni7FABuMtqQVycfoEv6rVnI9iDe+1bwo8xkqtUwo57lTC6HZvJNJIztwIDHvs/27MRwZXDjIuCiljdULjx3iq14OmFfCAA7WCoJlgJQdkwsnZkorM7nRghDnl0rQNOGZIRLOKkrFJGjXl1SAUzy7iBakSEmMXC6uo/ODQOjyWN6I0dRtthYf8lUbw2V5Vj7Ia5TlSaDSh2rN5RnTdm8VwKuByPBxW+ihTuY9Lw3cLxTqXBGVD2ttf6gQkbpiCfano4fIQpwD9KYbUMhTt24m66L1Egaz06k2PRxCfdZ4Cl3h7M8m1tYZc2JA/Zwi5YA1PogSqd9A==
Received: from DM5PR06CA0090.namprd06.prod.outlook.com (2603:10b6:3:4::28) by
 BN8PR12MB4626.namprd12.prod.outlook.com (2603:10b6:408:72::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Sun, 20 Feb 2022 14:05:46 +0000
Received: from DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::f6) by DM5PR06CA0090.outlook.office365.com
 (2603:10b6:3:4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT014.mail.protection.outlook.com (10.13.173.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:44 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:43 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 10/12] selinux: add support for RTM_NEWTUNNEL, RTM_DELTUNNEL, and RTM_GETTUNNEL
Date:   Sun, 20 Feb 2022 14:04:03 +0000
Message-ID: <20220220140405.1646839-11-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a2eb213-18bf-4590-281c-08d9f47a1762
X-MS-TrafficTypeDiagnostic: BN8PR12MB4626:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB4626EC9FC028DCCDA400C8F5CB399@BN8PR12MB4626.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lW2x2jiaCMcXD22E+IRFZGcAyrcQEZne+d8Vb2essegnN6Tsea2n69x/H7i+c7tiDNz/MhmHMyRdqvx6/6eik2CePeL5N+S3yHE/22u6GNx0UgVXwts8/HPMHHPqMGxNNDNvzI8vY+oTAgIlbeTwC12cldN5PXnsf7uKFkLoZ0g4lpv/q/Pqfbh7klNxPaEmsIOBPj52gWL4unz4ZglijKBk1G55479mkELuZ6VEuDt4FJ9iRhahg8aZoIooXF9GRacW47LOHFkSx5LcyXnl1Hm8qh7IifjH3yt/wd0n1unOjHTwnATl5fCYA9VG5K1sjUP1YwB4IsLWncsIVhLSW5nrTHWLz9nZf7cPM7pJMsjeKr5Di2e+yFuAjnJWshOR2zfKAYr29r/FcxeYmnaEV0MydmLBn2W6hGyg1B3sSx6QY0CePfFozhkuRQJ5DTjmALfVe9ckQo/4jX7qt6KBfr7/RdRK72+QOrQkVXLtKF6qwyvfiFFXRsKu8sDunHF5FANUN+WfmlsKcWBNItsFwEwBfNk9a4IS7ZnVeiQIZSJB+4HzlgYpq46vVEOlR+aDelzhviO2/SPrMvYJY44q9imF734i6Y4iOlLuDbuVIT0TBVHMyAFjQkwkpmmtou4F897xAHPGPlCDO08uZWMHvA8/LchKEe1SMiCcGULleG6m5bKxDk7iP5+UKwuQCWHjQI28eBqs89TVzrpWtKoO4A==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(508600001)(316002)(54906003)(36860700001)(6666004)(47076005)(40460700003)(36756003)(83380400001)(110136005)(86362001)(8676002)(4326008)(70586007)(70206006)(82310400004)(2906002)(26005)(186003)(336012)(426003)(1076003)(2616005)(8936002)(81166007)(5660300002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:46.3882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2eb213-18bf-4590-281c-08d9f47a1762
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB4626
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <bpoirier@nvidia.com>

This patch adds newly added RTM_*TUNNEL msgs to nlmsg_route_perms

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 security/selinux/nlmsgtab.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 94ea2a8b2bb7..6ad3ee02e023 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -91,6 +91,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_NEWTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -176,7 +179,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOPBUCKET + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_NEWTUNNEL + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.25.1

