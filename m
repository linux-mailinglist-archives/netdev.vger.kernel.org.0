Return-Path: <netdev+bounces-12246-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C20B736E22
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:59:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C96A228130F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E970D16433;
	Tue, 20 Jun 2023 13:57:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9EF1641C
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:19 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8DFA4;
	Tue, 20 Jun 2023 06:57:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUWLNVMznOoNkFZm77+196hXScJFzUoEDPWR3mACNdaDLV64piZHJ7revdjjRH1fz/ZPkZF1BEkD0PDXKA7rrkTumvZnplVMuE5c1hvbYet6Sg4g1g0+Mmmd0tqVv99a6laq8NN8p4wL0jHZ5MZGBAUJihVUGQzGY7xaug5eHcE1una4h/FloQ0IS8k+dCGDDVGTUNQ9D41PxBvuPk4QSMGQkHg7ZuUitlPbXIL9gF/5Lb7Ya9koojQFhc6NILqPdNXJLn/ZAPlhSQiegbHFWAKlSjbzAfEfwWTZm2oX+1SqkbJ1UUn7iAOJCGuewYpel3r7vs1ebg9XLarwgi2XEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqY6FtefmJZsl1SSfKzYex4+g15uyN8t+rljVhvbGyU=;
 b=WPytzFM1amlb7yCZhzxZQEPaewGgZ7f2SXr4lnOstjMU0WXayfMsfjHK1LOpNN+cwvLLXnvBUkYT64FcQ9dqbZhe5cXAoiGhfiDuVo0X2D8aT1PAraB89zM4Mt0ygV/jtluFmWDtqY80+WIO/QVR9oMUQeO+jCaGIV+Bul7i90h4bv4Py9vESALVIs7ehcyn/T3/5Jt+1tUWuN9yfpLfenUC0GmwkNyuDY1jRgSYwzuRMAbKBPbbB16CdyvJrXt4WBtpySTNqgJw5DVeJvnLRLSNPwGUte+I4IQDK6x7vLdlwP4OLA2GuS8l/wzxite0rrvsR3RdJfJlkz3m60KQyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqY6FtefmJZsl1SSfKzYex4+g15uyN8t+rljVhvbGyU=;
 b=T70txCMS/b+UaGR2uc7R/7tJi19bP7eloNSSYYLjxbZmo0egw8vWpTCdehFePMs8RhSdIxe6o/umxzTMxGGT7quVuMNUWSTvp62/TPeH5Ru5GuKJ/J+Xmsjb7HYZxhJtRVySM5x9W4eqxzJgBFKEVCRoryAhnlZLlo5rhLyquoB/Qmm+I+tVjJGLkRt7w8msBA6dgmihukrQ+t5CnT0VfDfLUYidGInq23xA1pS7iQBku65zaD1K8W5LySBxTOzoXZKakyZYwQ8lBvKDUo8pEcLN4df40E7PZqgPdRpNDi2nrebSMIhEwSssY41M4838IDrt00RlSKBWibrfcvY0CA==
Received: from BN6PR17CA0032.namprd17.prod.outlook.com (2603:10b6:405:75::21)
 by SN7PR12MB7252.namprd12.prod.outlook.com (2603:10b6:806:2ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Tue, 20 Jun
 2023 13:57:15 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::e8) by BN6PR17CA0032.outlook.office365.com
 (2603:10b6:405:75::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:57:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:57:01 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:58 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 09/16] selftests: mlxsw: extack: Disable IPv6 autogen on bridges
Date: Tue, 20 Jun 2023 15:55:55 +0200
Message-ID: <c1403d9629ca94b18ee683d488550b7561a632e8.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT014:EE_|SN7PR12MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: 28299693-da52-44e1-5073-08db71964061
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c6zdAsGB1zNJWc/Ev3MWW7wU7dq9cFcAFMnPLe0/X4eFx8LmENCkb2DCFigr9PDSu55hDhDf1G2QCxFrfd+v2sT5MVHTNNvwcZpAp7jHE05frqdzA3xGx5JZWrLhhs+6ltZJYRcuf7ejXXiw14tI+4AXWwqqk3S0ASSXOWbt9Q17FeIPCjPnoaTZwuq3zchyGcsLf1V1vURVMzqicuateZB92aQDZyQwSnzXGCL5cMErDQQ+FwR+hQkE5nfVrU3XAixe7wbW4+LHk+wDfMPas7NNlioYo7F+c5G1nc0Guf3DNYT4gpW/LTHIl5UhyK7eUEkoDegyaBwRiAcd94jF3wwNTzUTugCiHUYaC8EeQvYbK33AsUn+JFhfGQWPcZApHkFRaZl253ysMH6z/d9Sb/JXXQ6hLvRK03U0YJx3m2F1VWkduZ8juow1gsKXGT8n1jQgJonxPy44x/O6KcwNbxnT5jK2A4y3XmFIWkUTrrDmli7/cwIHnzjYryeKE0TATZlBSsGzsKKl5xXyLP8p3d+Wq0c1Xh1nWpJidQpId3zv7arX0Gifwed5dPxCW87PgqCgADl0YeF42oAGYb2u/U0UYIf6PpgkXWFJHu3hV6oB6ZCAex3ZKtLIoMvcDw5u+WY6TEWxoeFMt6t+YaWy5CQCTnGxvj0gE4hGbl9673HQHDg4ePa4DCmX6m0+T00Pu3vjAVG7ytiBRPuMjYs6oHI7rK4VVoHzTvnm4ofb7NkFHRqBez11e0/eejmJ3YIw
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199021)(46966006)(36840700001)(40470700004)(4326008)(478600001)(54906003)(110136005)(7696005)(26005)(40460700003)(107886003)(16526019)(186003)(40480700001)(6666004)(2906002)(36756003)(8676002)(41300700001)(8936002)(70586007)(70206006)(316002)(5660300002)(82310400005)(83380400001)(426003)(47076005)(86362001)(336012)(66574015)(356005)(7636003)(36860700001)(2616005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:14.0178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28299693-da52-44e1-5073-08db71964061
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7252
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

At the time that the front panel port is enslaved to the bridge (this holds
for all bridges used here), the bridge MAC address does not have the same
prefix as other interfaces in the system. On Nvidia Spectrum-1 machines all
the RIFs have to have the same 38-bit MAC address prefix. Since the bridge
does not obey this limitation, the RIF cannot be created, and the
enslavement attempt is vetoed on the grounds of the configuration not being
offloadable.

The selftest itself however checks whether a different vetoed aspect of the
configuration provides an extack. The IP address or the RIF are irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridges in this selftest, thus exempting them from mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/extack.sh     | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/extack.sh b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
index 7a0a99c1d22f..6fd422d38fe8 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/extack.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/extack.sh
@@ -35,7 +35,9 @@ netdev_pre_up_test()
 {
 	RET=0
 
-	ip link add name br1 up type bridge vlan_filtering 0 mcast_snooping 0
+	ip link add name br1 type bridge vlan_filtering 0 mcast_snooping 0
+	ip link set dev br1 addrgenmode none
+	ip link set dev br1 up
 	ip link add name vx1 up type vxlan id 1000 \
 		local 192.0.2.17 remote 192.0.2.18 \
 		dstport 4789 nolearning noudpcsum tos inherit ttl 100
@@ -46,7 +48,9 @@ netdev_pre_up_test()
 	ip link set dev $swp1 master br1
 	check_err $?
 
-	ip link add name br2 up type bridge vlan_filtering 0 mcast_snooping 0
+	ip link add name br2 type bridge vlan_filtering 0 mcast_snooping 0
+	ip link set dev br2 addrgenmode none
+	ip link set dev br2 up
 	ip link add name vx2 up type vxlan id 2000 \
 		local 192.0.2.17 remote 192.0.2.18 \
 		dstport 4789 nolearning noudpcsum tos inherit ttl 100
@@ -81,7 +85,9 @@ vxlan_vlan_add_test()
 {
 	RET=0
 
-	ip link add name br1 up type bridge vlan_filtering 1 mcast_snooping 0
+	ip link add name br1 type bridge vlan_filtering 1 mcast_snooping 0
+	ip link set dev br1 addrgenmode none
+	ip link set dev br1 up
 
 	# Unsupported configuration: mlxsw demands VXLAN with "noudpcsum".
 	ip link add name vx1 up type vxlan id 1000 \
@@ -117,7 +123,9 @@ vxlan_bridge_create_test()
 		dstport 4789 tos inherit ttl 100
 
 	# Test with VLAN-aware bridge.
-	ip link add name br1 up type bridge vlan_filtering 1 mcast_snooping 0
+	ip link add name br1 type bridge vlan_filtering 1 mcast_snooping 0
+	ip link set dev br1 addrgenmode none
+	ip link set dev br1 up
 
 	ip link set dev vx1 master br1
 
@@ -142,8 +150,12 @@ bridge_create_test()
 {
 	RET=0
 
-	ip link add name br1 up type bridge vlan_filtering 1
-	ip link add name br2 up type bridge vlan_filtering 1
+	ip link add name br1 type bridge vlan_filtering 1
+	ip link set dev br1 addrgenmode none
+	ip link set dev br1 up
+	ip link add name br2 type bridge vlan_filtering 1
+	ip link set dev br2 addrgenmode none
+	ip link set dev br2 up
 
 	ip link set dev $swp1 master br1
 	check_err $?
-- 
2.40.1


