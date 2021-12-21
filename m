Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E43947C1E1
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhLUOuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:50:14 -0500
Received: from mail-mw2nam12on2071.outbound.protection.outlook.com ([40.107.244.71]:1280
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235636AbhLUOuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:50:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9p4kHcwOTiB/kX6iGT++KhWOCGVAH3t7UG1lg/cxckT6IFMlKisxehj87GQZ3uQsrn5khBdUl5VvkkQA7gTh1qcgfNtYZ/oESC3FjTqbjFqzt9v9e+jwXQ96cZH4xXPr2nGa3bqzpnKKB7gh9HM3bu9Wgu5B73+Do8SbRU/NqTxenai+XrQPlkEVbatJ/NWoY9GCx5Y7urZ6Rv/lHO+FyHAAph/GH7d+JLNH6nBsD8QJfK7kOfdRa7BfePFpkMI/gupl3v4HLfBb/1LyAuDYzWCsYtnPUZmeG7a3x+j1NJ8KPoRsF/5LdZY5eb6N/PfYXAIUaUcYDb3OHukXjTQBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=COGcSRFCJzJaMEm3LeN3Fxt0OesEHGnmbSwjIQzghIo=;
 b=bUMnv2i0OvOCxkAVZhkHtjmZx/1pkWo0xzBWFpIDrQRXoUrH9ZB72wxgCstWyNtl2RSykkDQKQ4P1O7F5JTtJuIcn1NfpI8NAsptsBqH5E9qkpZshFNKzzIj8PKUR14MUoecPLc0j2hlbOV94Phzxfm1RRy9G4VNj7ByK1O6+iMQswUrqFgOPv7kiGO/yzhwxI+8AhXf86Uy0Yfd+8uLqn6bZXiuLmkHqd6sC+0zCzSM5izZb3YLpDGE1tPt5ax+pGCKbgOXj+W4FN4EWJXBcUOUSC2Zgn9xIt3X5X+Y6Xmm2hDxRRE3xVDJIx1gGWHPoZA8IfbdEruDos6Si8bLDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COGcSRFCJzJaMEm3LeN3Fxt0OesEHGnmbSwjIQzghIo=;
 b=n8nm+LgtdESVX9gX8kfn1dKGRBx7twyoKGsbJijn1LHCkLwN/x1LKHxFqkIw8odxpiWdOCmEpb8ATXNiDAayqxcKnEhedxWvvOPW1ZIu+GLJLmMRr6cSTHFeQypWPVr8szAiTlIilNuyFtN3nT/IugP5FA1i8w8hSwohHpoqtPS006kRoEIswGXIIzAfekG03xEcE9+xXFbxe/gzyuuoRGF6fL8y2psWUkuPoeAxwRgKXVF2u5KX53VZWPn50OD8bJlSmqZRXOpgBVZZZtE+4Xo4ND3Ca76oPyoFS2gheapfDKoCa4Wd/7KW6p+iaS12DDwOlCXGs5rjQZPovbESsA==
Received: from CO1PR15CA0081.namprd15.prod.outlook.com (2603:10b6:101:20::25)
 by DM6PR12MB4986.namprd12.prod.outlook.com (2603:10b6:5:16f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Tue, 21 Dec
 2021 14:50:12 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:20:cafe::77) by CO1PR15CA0081.outlook.office365.com
 (2603:10b6:101:20::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14 via Frontend
 Transport; Tue, 21 Dec 2021 14:50:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:50:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:50:10 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:50:07 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum_flower: Make vlan_id limitation more specific
Date:   Tue, 21 Dec 2021 16:49:42 +0200
Message-ID: <20211221144949.2527545-2-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221144949.2527545-1-amcohen@nvidia.com>
References: <20211221144949.2527545-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1790afa4-aa40-4cce-6850-08d9c4913155
X-MS-TrafficTypeDiagnostic: DM6PR12MB4986:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB49864C5BAF64A2E186405A50CB7C9@DM6PR12MB4986.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jr6BglyjBAY/ol1Efmy83uMf1myKsk4/bMuk7YUM6j80esAm9Mwt9zII2WmmnWNY2ZCk23AK8Hos42jMC20p1WG/zvWEUt9yLXMXE46JHx0eIWE4QgUbxAfCoze9DFxSDvFgp6hCNDxWh0UgXdUy0dC0rW3TuoFxESus2DUWpfOkbQK/s8s1qdZMx5vd/zUc4J0CAcKfDIBEHIt+oqv4xt1tfodmNdMstlB08NYtw5iHYQVqiQqPGe7izz0CuZpqbV6q8kMsINrDYPnme4j5juIWj9GMduQgNHeP+IWUNBizGfHYHXRpe+RtGQM7MPoT36CrZyQmOL19iJLHqhIGTcysSoLEbrlTyU+9xCFOZVd8fjXMQo7HaB4eiOEJu0aeBa5w/zVnqYcOuTX1LyT12Bj4m81YJcX+vIra9PTLwETTZiBNT9oPX3W0uWdKhpr++q/HaA6CSpcD5jWu24ebG40CTNkagva3oC0xBa78YSbxHSHiUFvbkBSKOvDhoUYqfF7Ep3m1yrFP5SYz+abaLe+EtxklSWFYmgPWmgyRH61SZSZWwHEz5z5A7dEQ8xcF/bgKdO/Rem7hrrWbcGJ6b5FLZrOt8oVRNh4yQ3Jgk4ltR+v+7T3/76niR7yNDX9w5lsUCkZOeSfatk1PN1nW5oLsb7Q15ds1Wz/bcqljTyaj4oLWCcQsiW95GZptGs1Pe24mpMgdcNoqMH3Kg2KWoPOURD/pDr+sXtY33LHOEAIIHsi4g5u8R7p16NdkBm1e6yTMQLdhizhNIIJlbQ3JPtR2Wf1oUJqnbikiQ64QGSZ/30SrXoUf0TYjseh+mHNxz64+6/2vOtlizjiO9HLVRQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(36756003)(82310400004)(316002)(47076005)(6916009)(70206006)(2906002)(70586007)(8676002)(34020700004)(16526019)(2616005)(26005)(107886003)(83380400001)(36860700001)(6666004)(426003)(81166007)(186003)(8936002)(356005)(5660300002)(4326008)(40460700001)(1076003)(336012)(508600001)(54906003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:50:12.5405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1790afa4-aa40-4cce-6850-08d9c4913155
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4986
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spectrum ASICs do not support matching of VLAN ID at egress.
Currently, mlxsw driver forbids matching of all VLAN related fields at
egress, which is too strict check.

For example, the following filter is not supported by the driver:
$ tc filter add dev swpX egress protocol 802.1q pref 1 handle 101 flower
vlan_ethtype ipv4 src_ip .. dst_ip .. skip_sw action pass
Error: mlxsw_spectrum: vlan_id key is not supported on egress.
We have an error talking to the kernel

The filter above does not match on VLAN ID, but is bounced anyway.

Make the check more specific, forbid only matching of 'vlan_id' at egress.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 186c556f0de1..bb417db773b9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -508,7 +508,8 @@ static int mlxsw_sp_flower_parse(struct mlxsw_sp *mlxsw_sp,
 		struct flow_match_vlan match;
 
 		flow_rule_match_vlan(rule, &match);
-		if (mlxsw_sp_flow_block_is_egress_bound(block)) {
+		if (mlxsw_sp_flow_block_is_egress_bound(block) &&
+		    match.mask->vlan_id) {
 			NL_SET_ERR_MSG_MOD(f->common.extack, "vlan_id key is not supported on egress");
 			return -EOPNOTSUPP;
 		}
-- 
2.31.1

