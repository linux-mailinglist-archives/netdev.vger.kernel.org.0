Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6A7D47DFA2
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346874AbhLWHd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:33:29 -0500
Received: from mail-mw2nam08on2051.outbound.protection.outlook.com ([40.107.101.51]:5327
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346855AbhLWHd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:33:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/h/oDPzPIhaLoiMFk7L9xfX4Z3kovDM5VgEznx6DWnS9OYPS4/26dofMMCkMmpVJwXeD3gzcjxAtD55oFfIOyELHOXxUOPDHojHrio09BBw3fsyAtf3960vQLU/HnQf+HvnN3RGfxfOE6Tp231viR/InLNMuq1gsGeUF+3J2Tehb+ML/VTHQkLrYbZqMA8xPWH+Z40hpZvaqIGN7WHvrMUFmJg3OWl0PZufA8bPEBy0BenTJH3TMYbql92R7SmhYqjN7bmgnowQE1nBO5V97j0JGJODc/nLVIMY+wyq10GAMFwDPFvJWH+kT/MPOgkLedaXDoGdJdEprdaYgSllIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9j6xo15DsBJJ4fH50Lo87bLbb+cis3WQBZg7EFQsYBY=;
 b=h088R2krp2VmmDmizv5isWEpE2jqxE+85QSF7vUD3b7AD8TOhCpTChmqJ8vBULH95x2WrRmWcqrm4ydruxceEfcpAFVgKPqsBclWSAl43O6zYyilvI3PfVWKfpaq7wj7tmEnzwSzhKmO/yKSrIV8ysIgXZwO8q+Arm91ecGMgRPxVZLLMd5IYeIOJxbdUJfzO7fVyo5BcCYeWWf4eny9YW2FsmL7vDUqi4B6P7zT/eH7TuP23KVpKWR8BVaQ25WJCMSrcaUoMeQK8Sl1VQC+wTIy+EQds9HttjrWDxlTMQ4bGfst9n3SASVVr0e8qRj/i8NsQWdNfrKxhsfSCFI00g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9j6xo15DsBJJ4fH50Lo87bLbb+cis3WQBZg7EFQsYBY=;
 b=uSiIir1n0dNN0EBUvGxXs9LG8ulAZIr1bGo/kEura/AbSpVst0SamPiDz1GwQ8F2/SapylOg5AKp/oHj7/5INfo7yTrlWtzywBW7pqg/MmuRgPUmaamxTF7raJFUK54vzduH0Y23hCdP6mqSjAguPErE4WMfJbSz4Zc0rsi57eGgL+iwg4CFh81sa3fNoNMBMDZM7kJBnRdephOPgr+Me9uS391LDdQASbN3InRuQ9lxVGsaZic4I9IkJLq0veGhrH4km6Uvb30rp/3us1mQH6vVRw7rJmIeZp6EFYDQTJdT3FlWdMVWL2JYyYK5Z683q4xfe8kU41sU77hLAZDQ3w==
Received: from MWHPR02CA0006.namprd02.prod.outlook.com (2603:10b6:300:4b::16)
 by BY5PR12MB5544.namprd12.prod.outlook.com (2603:10b6:a03:1d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 07:33:24 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:4b:cafe::c1) by MWHPR02CA0006.outlook.office365.com
 (2603:10b6:300:4b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16 via Frontend
 Transport; Thu, 23 Dec 2021 07:33:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:33:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:33:22 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:33:20 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 8/8] selftests: mlxsw: devlink_trap_tunnel_vxlan: Fix 'decap_error' case
Date:   Thu, 23 Dec 2021 09:30:02 +0200
Message-ID: <20211223073002.3733510-9-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223073002.3733510-1-amcohen@nvidia.com>
References: <20211223073002.3733510-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56c03ef8-6bcc-456a-573d-08d9c5e68100
X-MS-TrafficTypeDiagnostic: BY5PR12MB5544:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB5544D17C393F2CC7889D82C8CB7E9@BY5PR12MB5544.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xooLryuIVeCfLfG5iwJybqM4xXrmNgaJ2nS3MyB4nojnVSaEFbCbJMl/UrgS/F3JJHhWuntRZ9JlKh/vzwhNUj2ng1NebfgkFesBm5y/dXSEudcF74cjGT131BXOsfX9mO8NYg5FxjbOWlVYmPjGCllHTvLNxHQUeTPP92vQ9IuTQshMzAuwaBvFPrgEixxjqdNTyS2GQgrhAc0SRvJ+Y1uRUmttB64x9n1rmzf0m9vX3sA7bCCrcffhXSj2zrAlt4rz5INp13bjNdDdSYifJJfthFfzbY6s+d59j0VjGUpwlGfffpu18NQDe12sTReh6VZg7H9/pPdYcWy8UFO10lGN3j37H56inETaSRa1++uiPbnPOmqdbSsIjjtnoiIazJOcuawsP5KEwG6L4/Mm+XesYfWSEEcVT/b2CnjSBSEKEX1y+jGnXOvoxMtQyp7NmSCuuQRMI9fxVgIk6Zqg04ILzNL0B5IbV2iv4xCXx2ms2G4+N49GvByjYzf+K1OqIbicDZuSYKK4zSjgl/Kr3dlxigS6NplA97umSxsyhI6erdkKON3CeYeEd7Wh9tbwX/rMNTIbup5hhCXUQoTilmsKMceKyK/SnoIZ52+e/DKHY2hBnljkQ3W1lObgAucR/YH3z4z1WFE6JBlOCrMqfi0nhIDGUAnd2II7LtlTENjmVqUNT/5+ADv4Bs68fjtJYMnM586Bmy7hbXmWpfnIwqVS3Yh+QmyRtlWIm6wR8EgkNNclIG0vpxxpq0QrbaqFOsZX+6qc5ScU29IZmjGAUY44xQxj3ecRLH35fv0v1Nw=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(36860700001)(2906002)(5660300002)(316002)(40460700001)(336012)(16526019)(186003)(1076003)(54906003)(81166007)(82310400004)(70586007)(2616005)(47076005)(36756003)(6666004)(426003)(8676002)(83380400001)(107886003)(8936002)(6916009)(70206006)(356005)(86362001)(508600001)(26005)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:33:24.5975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c03ef8-6bcc-456a-573d-08d9c5e68100
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5544
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the case that sends packets with "too short inner packet" to
include part of ethernet header, to make the trap to be triggered due to
the correct reason.

According to ASIC arch, the trap is triggered if overlay packet length is
less than 18B, and the minimum inner packet should include source MAC and
destination MAC.

Till now the case passed because one of the reserved bits in VxLAN
header was used. This issue was found while adding an equivalent test
for IPv6.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh         | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
index 10e0f3dbc930..5f6eb965cfd1 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh
@@ -217,9 +217,11 @@ short_payload_get()
         dest_mac=$(mac_get $h1)
         p=$(:
 		)"08:"$(                      : VXLAN flags
-		)"01:00:00:"$(                : VXLAN reserved
+		)"00:00:00:"$(                : VXLAN reserved
 		)"00:03:e8:"$(                : VXLAN VNI : 1000
 		)"00:"$(                      : VXLAN reserved
+		)"$dest_mac:"$(               : ETH daddr
+		)"00:00:00:00:00:00:"$(       : ETH saddr
 		)
         echo $p
 }
@@ -263,7 +265,8 @@ decap_error_test()
 
 	corrupted_packet_test "Decap error: Reserved bits in use" \
 		"reserved_bits_payload_get"
-	corrupted_packet_test "Decap error: No L2 header" "short_payload_get"
+	corrupted_packet_test "Decap error: Too short inner packet" \
+		"short_payload_get"
 }
 
 mc_smac_payload_get()
-- 
2.31.1

