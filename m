Return-Path: <netdev+bounces-12251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B79736E31
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B8941C20C3D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359EB168A4;
	Tue, 20 Jun 2023 13:57:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2399E17724
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:40 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF311B0;
	Tue, 20 Jun 2023 06:57:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANU/xQK7n5LQeril7RSFkXwMuaVIhyMYChPtrr9BkD9mhjyGtGJ73R6Notf5RRC5pyG4+xVvzty3QLRd4ZEY+8goOWV0Ju6Z1V9Ex2TyNWOJzGrJ7x9Wy/2d6jDcLcdo8az3AhmG7mtKHOoCZyA6QSKfmimNkfIqI1PfqXfCYv0/W7ibbMx0f5qgOV249XS80rzpUij03Uss03I3CaoRjqr9Jtw76wzMVjDGgZJdZmYm2m25guNX/wRqutSEBiUW5J/C1p6GNXVBHeUjJwU8NULSUhwwfHaw/9bFNy1ws8zsVGeE0tnjOwNfEuyyLH4E84TlSeddQ9ybDuQwgqk2hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BunjBm0ZMEXE8evgBFdZVV8cTV1Mzmmze6LgCbfZ8yg=;
 b=GQZLHr3ut3meLlUf0Ew9o2qRSJN7sRA+eU0/YzWnUg2iglWquDacpHJQCGkYTeL0LKD8z+eroQ7IxYF9ZwitkUBXtzbaLufQ/kBbGMAUad5LueNjKTqUsLxLELo904PaM7b/KUsxRIgIWomaMvbXMDTAlNpnVNe1jKgRyTkzlOuSE1BATK6LkhuzuAnbkwTeUqO7YWPeMovmjkCoBBokev7+d5cMY1EZ1unbVMO/Y/ligUT0Up4UoEf/x7+d1cWlb7iDOjZjuR/j5x7a7poU8FWsASBLZ3tBkICZBF66DrBQVgyQ04pWcnKeKxOENGceALJHUHJmT846Hk8YQnGz5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BunjBm0ZMEXE8evgBFdZVV8cTV1Mzmmze6LgCbfZ8yg=;
 b=lZ6uDJ1QfJ4K1xnyQchhQvEbr9hHUzlMvFecYzYd/JVyjeYFPEYCgGfptzlFaUbyxdSlSxwVZZ1O5kVnqg6c1jznx8wGjeMEDV28qJvmB2J8LPtMn3r5qW8WJ6CFrDasqONsH9waHfTzFNjCA5dLdDj06UneWnXez1ILPqg2cpqwJ5xX1Pqtk90zYtGWj0nNvJoIULOJwowNl+Cl5+xg/9T94aO3I9rb1L78CR/ZqajtL9xbJ94YY335X1j+vfR626JSqY9dYyj7qXnXwSxcBtC7Yle/q/hToZmyor+dCMRHvUe2TMD2WmxYsMqq5+KpxCTr7nTtYAx5ldHPBKvSjw==
Received: from BN8PR15CA0025.namprd15.prod.outlook.com (2603:10b6:408:c0::38)
 by CH2PR12MB5002.namprd12.prod.outlook.com (2603:10b6:610:6d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:57:36 +0000
Received: from BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::1) by BN8PR15CA0025.outlook.office365.com
 (2603:10b6:408:c0::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT086.mail.protection.outlook.com (10.13.176.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:57:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:57:21 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:57:18 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 14/16] selftests: mlxsw: spectrum: q_in_vni_veto: Disable IPv6 autogen on a bridge
Date: Tue, 20 Jun 2023 15:56:00 +0200
Message-ID: <fe6bb1b8da9dfc275e63cd1516bb69344ee690ff.1687265905.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687265905.git.petrm@nvidia.com>
References: <cover.1687265905.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT086:EE_|CH2PR12MB5002:EE_
X-MS-Office365-Filtering-Correlation-Id: 995b2bb9-84a2-4659-2353-08db71964d5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0PPbY8lwoV9LMEAYtFbnz6b9Ceczwu7LLPDJZaZx3aBVRGyazCZ5EJth8iayPm6IaLO3X7dMgrurS1N+czLBaFDCcLLqt2GnZy/QmBNBIvpt+xaqEbdVTUZk8QCBFjw35klLYx2Z0BfG12+DYaKfWIrWyvtdYj1JG6rPfCKtFxyx/qgH3mr7HUXPY57lGqVRefL/duhSLQo1j9ntCRcxtKV/RjtosgPW7H/ZQmz9ncvuFCZtGqf0KIA5wQqmD05rMQzFJ/H79YWTjSqMj0u9UlTU/ck31hUJi+dCkikkHi6+2UTzOWzSi5XxZnwOuOUS+lVkZqy9+AIrn14+r6nlrLJMJp+GRiRJNUycjZT563UjiPwF3L8HztN4cKPfFFUmEumgK9X/GqaV6HWeca8YSgs2XZu9GWoTz3KMcPCgp/7wQsvs2MKTkKtmGllT6mryl2jM6cphwNTVWDvY5h26N77RMQaHqo218NIrQ8OMa4p3AbcXFu5xb/TbChvhdIQ64qqLJ1i646CBbLjbNuebpbxQnRqmHJGM3oCT9A3T7/yT+G9PN0lVoVYS4gYYTBoUUSjyZRFkncNpapBDVJ1zr2k9Uu7GuIgJJSu1/d0QBDCFC3CfBVFbrvY+yqbniCirkLXi3VyLvc0FrpIwBal9UUYT5o8omz3nP05SE8SOk2KVBFjA46c4162A71SoA7hevgIWJpoUN3Bbinogmat3HR/rLNChJbZAdOAuJKyKoR4=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(5660300002)(316002)(2906002)(4326008)(8936002)(8676002)(54906003)(41300700001)(110136005)(70586007)(70206006)(478600001)(7696005)(40460700003)(6666004)(356005)(7636003)(40480700001)(107886003)(16526019)(186003)(47076005)(2616005)(26005)(336012)(426003)(83380400001)(36860700001)(66574015)(82740400003)(36756003)(86362001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:35.7877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 995b2bb9-84a2-4659-2353-08db71964d5b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5002
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

At the time that the front panel port is enslaved to the bridge, the bridge
MAC address does not have the same prefix as other interfaces in the
system. On Nvidia Spectrum-1 machines all the RIFs have to have the same
38-bit MAC address prefix. Since the bridge does not obey this limitation,
the RIF cannot be created, and the enslavement attempt is vetoed on the
grounds of the configuration not being offloadable.

The selftest itself however checks vetoing of a different aspect of the
configuration and the bridge does not need to participate in routing
traffic. The IP address or the RIF are irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridge in this selftest, thus exempting it from mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh        | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh
index f0443b1b05b9..60753d46a2d4 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh
@@ -34,6 +34,7 @@ create_vxlan_on_top_of_8021ad_bridge()
 
 	ip link add dev br0 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
 		vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 	ip link set dev br0 up
 
 	ip link add name vx100 type vxlan id 1000 local 192.0.2.17 dstport \
-- 
2.40.1


