Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B8447DF97
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbhLWHaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:30:21 -0500
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:3143
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229509AbhLWHaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:30:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RmYf8kzraoJuxfsvZjGA1KwrgSaQhU4Jrp/snL4yCyT/QOHnvb2dxBN/+VPljt2++/r+JgKVvK/R3JQEbALHLEznA1qKPY4CjSsuVSHGQza4xHwuP8qdI+iYDKbEuxfIPua/1yVABiRvh5qq0VXPQM2Z0Yzs+5SYlRgs+ZODAtB4h/90QTpdmivPqV5QMCeGURybciaPmXeSRD7IN84CYT6xs4+PCVfbX9BBFMzg7uFRrRtippkoZAFCxrwVUpKLsw2UjLSKH0Yjhyj+w+uTrI2Hjo77u+bpOV5Ti6oINvaDLVPb6lnFOnbRY905/mCsN5QXYrcSnQMa3bAxK4V4KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJHKmfnn/YIDIc6cgNb2Z8XTN4OTJggGObQ61L/fYVU=;
 b=Z2hx5ufckOTdHbRvi8l2ZQzgPGRJ/4ESnEbirQhfcRVi4+lOHeIDdU5rBQ/SE3VHDqFDBsusHKRBgAlR+eAPUMC47CkzE5Xdj5sZfofdCAEopeeB3Rl3zyB1R+yRRUKwYU3jOpAssH9IB/3aY0hTVlKzPWyTEhdQxTodOgGuAmIqvo8lqGr6wYfypIUSBcAHpgWFVeLKOHEs2BDzTFvfTTfsjZ8Vza8cAPYTYwCM+DjcQoUgD82+iemC5GxReaJNFdx4LPSI78vLenTLoBfuouxqIv5uRshOqZ6aYMUvxr0HsmJeThjJinFJdD9Rz4/V4G8ttzeBgyqghp/PiwCN/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJHKmfnn/YIDIc6cgNb2Z8XTN4OTJggGObQ61L/fYVU=;
 b=HTSw0UsST/8Ia/Th3iNibAhoQsjuGf/kHXORQwK/ClG6qCvhxYIv6+U5svSe/v3+yFIIR1A21XHdnLZ/jBMnqAkpPXKir4jhR7XqbS5PhTGhLBcnyGhYMz+oa+ylUfe6gb36qEI7Iyx9v9i2XJAusive0r9JMefGPnL+sV6zXQOAGf8qC7IybExFdWXt6OCcC8KCXF6rc7Gp3hf6Kzvv/qx/YVU/w8SKNFRssUU/ppQf8QS5WLOXNQZYfLRNEbPnTTSm0G3Lr8vyvSc12sAuRGkDpoz5vwk0obAfYFeJQZUrC88iHggT+vlqgOf9pqlE8a7ODJZ4rnzkyF7iYEhDyw==
Received: from DM5PR13CA0036.namprd13.prod.outlook.com (2603:10b6:3:7b::22) by
 DM6PR12MB4864.namprd12.prod.outlook.com (2603:10b6:5:209::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4823.19; Thu, 23 Dec 2021 07:30:19 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::d4) by DM5PR13CA0036.outlook.office365.com
 (2603:10b6:3:7b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.7 via Frontend
 Transport; Thu, 23 Dec 2021 07:30:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:30:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:30:18 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:30:15 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Add tests for VxLAN with IPv6 underlay
Date:   Thu, 23 Dec 2021 09:29:54 +0200
Message-ID: <20211223073002.3733510-1-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e163e629-f5fd-40f8-4d8e-08d9c5e61262
X-MS-TrafficTypeDiagnostic: DM6PR12MB4864:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB48645F669F947A32AD14992DCB7E9@DM6PR12MB4864.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0A3IY0WDH9AemDMXumKh4GS4D/+IrJ9yvVl0dx5AcuX3lXW6ZqMb34rYgZeNwG5J0/QXklKESPRL1t7LXQfOqEZdxLeeCQ7hW98CG2kgPr2mpN+JZMpWSpCFuWfvfsTBeQHJx2Ky+MfpcaV3bwgHdUzm//+WNwbmB2R8bl3Bi7qrIen6oLb30acDi48RsfNN8zkzf8VCro5S+CkMGkLDB3GS9/7HTAShIQ9l5r5MLpLBvM1q1L7/+Hdli3IYXfntp1tUJH147F367k0tTqORjy3FAxLdT81rdvXrZyhKPPU5wuwBk/U6SrJHP9WMqc9o1OrFQ/88HjSlppBkpUwbdBlVXqjP5WLqskP9lswhTmPrHIQBroE9aaORPvuVrQ/d+FU6WSpNViUXdFVpG5F7goJ/aHZsbSKQDYmbeOPUqJxzaIxJp4gZrb4/EihBB6gJ1NmHwaHxv26UqO2P6vvKoxEScEOrN4/ImxYPZR05zhutOlepFjTTES2JTUWiqenzq1esDTJ+LFMbGHAStmMUwcpAv/jhn+5ORsuiVN+B5VWcOo4zZckAXydnvUBDGkIz4QHrGq45vKqk+jtXsbU1YpAPAatfMBuJV6ztenWLQpPPMpl1Y8rijNsVZR/6C2nhuQF0mjnfE8D9pbOrLFeYhRl/GyiY38NRmblWJneS7WRAeQicsa+ZMcNuwk0g57Y+i210kRITRqwYoS0cFtDn47jL+Apkd1d72PgKWtMUnVEdGzjlMbD812qU5bzO1/O6NISP8UNY4UcKMnqba84WtBebUJRv1VVp3pOtl52H2g=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(8936002)(2906002)(36756003)(36860700001)(1076003)(70206006)(70586007)(8676002)(47076005)(82310400004)(40460700001)(107886003)(5660300002)(81166007)(186003)(6916009)(6666004)(316002)(508600001)(426003)(2616005)(26005)(54906003)(356005)(83380400001)(16526019)(86362001)(336012)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:30:18.9968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e163e629-f5fd-40f8-4d8e-08d9c5e61262
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4864
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlxsw driver lately added support for VxLAN with IPv6 underlay.
This set adds tests for IPv6, which are dedicated for mlxsw.

Patch set overview:
Patches #1-#2 make vxlan.sh test more flexible and extend it for IPv6
Patches #3-#4 make vxlan_fdb_veto.sh test more flexible and extend it
for IPv6
Patches #5-#6 add tests for VxLAN flooding for different ASICs
Patches #7-#8 add test for VxLAN related traps and align the existing
test

Amit Cohen (8):
  selftests: mlxsw: vxlan: Make the test more flexible for future use
  selftests: mlxsw: Add VxLAN configuration test for IPv6
  selftests: mlxsw: vxlan_fdb_veto: Make the test more flexible for
    future use
  selftests: mlxsw: Add VxLAN FDB veto test for IPv6
  selftests: mlxsw: spectrum: Add a test for VxLAN flooding with IPv6
  selftests: mlxsw: spectrum-2: Add a test for VxLAN flooding with IPv6
  selftests: mlxsw: Add test for VxLAN related traps for IPv6
  selftests: mlxsw: devlink_trap_tunnel_vxlan: Fix 'decap_error' case

 .../net/mlxsw/devlink_trap_tunnel_vxlan.sh    |   7 +-
 .../mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh   | 342 ++++++++++++++++++
 .../mlxsw/spectrum-2/vxlan_flooding_ipv6.sh   | 322 +++++++++++++++++
 .../net/mlxsw/spectrum/vxlan_flooding_ipv6.sh | 334 +++++++++++++++++
 .../selftests/drivers/net/mlxsw/vxlan.sh      | 224 +++++++-----
 .../drivers/net/mlxsw/vxlan_fdb_veto.sh       |  39 +-
 .../drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh  |  12 +
 .../selftests/drivers/net/mlxsw/vxlan_ipv6.sh |  65 ++++
 8 files changed, 1232 insertions(+), 113 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum/vxlan_flooding_ipv6.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/vxlan_ipv6.sh

-- 
2.31.1

