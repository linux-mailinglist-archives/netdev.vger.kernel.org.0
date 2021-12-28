Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A145480AD7
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 16:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhL1Pcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 10:32:47 -0500
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:15296
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232237AbhL1Pcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 10:32:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZItVpdLz3jr+zN1aE5iqDo3v19L+o2+i+hzGFVPnQ/x3/ns40TlqRCM6hHUkImzz3y1eSh6a/Q1UhdTMgEPdXMVsPEmZ7eOhWp5W/bpEWPPVlQb/Jq2zjDb6NrOaKICubP7tRZfMUFMycU4GCPLEzSoxHecQ/g5pMzkPe4wpveOIoCrogxRzoKaIrgDHw4r/BJNSiqhCsU+plT1a4DbYVEn6ZB2mj/C1LSNNeNRCCaVlG1CwNAlGz/JSwVDODkJ230bht5y5Fd7zCLsq50AQma7rN47YjzNw4sBcNx8vgERUeuDhCnyzMJKh0usl4TsKl8IwGmPO8KcH0u3IKe3Nng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6ZRcqzDnwrqWxQW1yfr4I3M5EOGrCjW647q0rmwcMY=;
 b=G7YC01PHlQV6izZhlgcCjbo8hWkCZWaaMVURaSD9Kf0dGCs6Bxy4SsroeVFNfqTVMy+Brw0utbnghu/zqfJjL3G4ZzlRBuqtI2JDBuexTqeAo7NHkGy4WOhnY9tnwUD6ehiuZlqAeCinBhFS+t5+96CFfO6uZbPLQuHTL9kGXJ3m4/dCHcrWbzH3YsgHpKiSb0Ykhcrr4l5ca4jg/d9gXoLwGJ/Joy3ItP/29jx7HrYXT7SkQYCI56J0/D4aX3whtCTMZh4Kp7SJhf4CMNxVC17ZnUos0s7YFa62Mkh/3jslsuaQLkJNnIb9lEB72ZPJAGq74A7FS3SWznC94Im5CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6ZRcqzDnwrqWxQW1yfr4I3M5EOGrCjW647q0rmwcMY=;
 b=svtwmBhMSgnfxNYsIerfcIdJCXNmAPSiF1VYQ5Ob8o9Wivrp6hiX2swL5eY2RyIC9cg96O8uPGTmSkb5PnCdCg/Pbhy0O/pXvLdsqNy/3utqtqpJtTzx6hM5U5HjxmgLO9/p2X5tYLizfXhRcd0E0UtAy4MRHbC0QHQUkNLhGiQBjIg0qw+AkAcPbwu6znSXXZqB78YDqNSDzgGnioMyH8q6x20qUmhfh9E/Vn2uzBsrseI8Izf/LjLwJgQWCUq3bk5vfTXSqJC81l9Xj/93W3ZDuQLOmuYHOPmuwb6l2qrBXnqk3PadOZGEQeODaqHkuOw7PAFLtxhKqa1cU+uduQ==
Received: from BN9PR03CA0527.namprd03.prod.outlook.com (2603:10b6:408:131::22)
 by DM6PR12MB4960.namprd12.prod.outlook.com (2603:10b6:5:1bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Tue, 28 Dec
 2021 15:32:43 +0000
Received: from BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::62) by BN9PR03CA0527.outlook.office365.com
 (2603:10b6:408:131::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.13 via Frontend
 Transport; Tue, 28 Dec 2021 15:32:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT067.mail.protection.outlook.com (10.13.177.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Tue, 28 Dec 2021 15:32:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 28 Dec
 2021 15:32:40 +0000
Received: from debil.mellanox.com (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Tue, 28 Dec 2021
 07:32:37 -0800
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <roopa@nvidia.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net v2] net: bridge: mcast: fix br_multicast_ctx_vlan_global_disabled helper
Date:   Tue, 28 Dec 2021 17:31:42 +0200
Message-ID: <20211228153142.536969-1-nikolay@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211228152811.534521-1-nikolay@nvidia.com>
References: <20211228152811.534521-1-nikolay@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e30fb29b-71b9-4eed-f544-08d9ca174974
X-MS-TrafficTypeDiagnostic: DM6PR12MB4960:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB496053AB8B19976E3D5D42C7DF439@DM6PR12MB4960.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qub5qy6nnZR0hQ0+g8oNHgwGeQr66g1o9NVDZpGU8NN+w6i9oRHEIBfMDKI7veongUFuQHvQi4C0eCg+97kVlMctS1HqNwg5obVOfZyxI3vlgIG5IJX5+YQZjDU+nkh16qpMr8AipBkhpYMm/c6tkfOt5tJPtk7Y6v/yUnQ4vrAg1ntc2rT5dqLaKTaSxbfYOzTW97ALzim0GCI/HjY36VEd0ibi/HxSK+uBU7oOHAqYGch+YQyxcfBOAsVa5PUu9A6IsGeT/D+y5Yr3214RD5dc0AarRxAGNtOXEtonX6rOar0OLRGV7Ejg/rGCi6A54g1u0Cg424p5/mvmbjo7dqo3pVxQmZrG9oiY8kFvhTgoTcU2jdsPuA1VEj+BpamuCv6ILHW65akcklvbSSJh7aAjrmUDf4cet4SoK0m+Y6D0nRg6251qcImz+bOGZ8db59bI7oQDzoWwRMezNHZiTLu0G2h11SYXsdhxQEmbDZ3i1ZZnbrYIXRryRqFe8IvDQ05my9dL6iMPstNrcf5amgf0h0LQ7hlqUDufrKJJFXGwCAp8JJK75/dYPX8rt7t+AHwDY91zFFWabeSXA79TFcPUAUdWxPwW2MOM8ydOamTyfAUmqum8wmRguRpfRwfrdIFawci7nV66e0S1XZGepW+ijF3ha8v0Ok5grkNVUByN8beAkoCWfEMnfviSfMjE0/igdJAWtcxhLTBhpOkREQJThetQj1vRZEDJHEGvX0aSDDvFy2PRH+HBhzh2BWpOoxCeMTwPjjrpYwnbT+kJ7mAsd4h4vd5B47EceWo4BL0=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(82310400004)(5660300002)(2906002)(47076005)(36860700001)(1076003)(4326008)(6916009)(107886003)(70586007)(336012)(186003)(26005)(8676002)(508600001)(54906003)(426003)(16526019)(70206006)(316002)(8936002)(6666004)(2616005)(36756003)(81166007)(86362001)(356005)(40460700001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Dec 2021 15:32:41.3377
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e30fb29b-71b9-4eed-f544-08d9ca174974
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4960
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to first check if the context is a vlan one, then we need to
check the global bridge multicast vlan snooping flag, and finally the
vlan's multicast flag, otherwise we will unnecessarily enable vlan mcast
processing (e.g. querier timers).

Fixes: 7b54aaaf53cb ("net: bridge: multicast: add vlan state initialization and control")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: fix indentation warning by checkpatch

 net/bridge/br_private.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2187a0c3fd22..e8c6ee322c71 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1153,9 +1153,9 @@ br_multicast_port_ctx_get_global(const struct net_bridge_mcast_port *pmctx)
 static inline bool
 br_multicast_ctx_vlan_global_disabled(const struct net_bridge_mcast *brmctx)
 {
-	return br_opt_get(brmctx->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED) &&
-	       br_multicast_ctx_is_vlan(brmctx) &&
-	       !(brmctx->vlan->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED);
+	return br_multicast_ctx_is_vlan(brmctx) &&
+	       (!br_opt_get(brmctx->br, BROPT_MCAST_VLAN_SNOOPING_ENABLED) ||
+		!(brmctx->vlan->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED));
 }
 
 static inline bool
-- 
2.33.1

