Return-Path: <netdev+bounces-12253-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA0A736E33
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD158280DA4
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F1317746;
	Tue, 20 Jun 2023 13:57:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FC417745
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:47 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB0DD3;
	Tue, 20 Jun 2023 06:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIAzKJG/1W6WfUXFpQ6u1CBbAlbX197zfNd8LQ2I4VeZEgAMLvuyupE2MqBe9T+QjVcp+zC9iPHD3IU4KaCoZ7r6UA/odedKovke5pNhtakWQqYbNMBgj1qpT73DMAxd6AtiY1eEpKzIFueHVzIBufwXQdcTdHR4Sr/77IzGmmVlgBEbzZoH9k+RxvucsRfVz5gpR+yddU8apw8DR1hxZ8YnXOSE7suSk+9wOSAbqTL25AFmHJ9vqO54eY/D1xmaBAnyBRLrCMalwKt4OAU+dTqexWq3zEKDSp/q4GePRY475eVRCEhTKmJxXY+Cbypv/rAgV8HWmVm46AkQtGBUzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ek9e5xpA2I8s9r2TQOCr/DLkOs0t5tBCc+WtP5jYTnU=;
 b=b/zCe8KivxzELNpRhQmb7vjgDAyXRDYDYD/843E82qxU8cuZp699CIzsKn5I07U2lzi7VKKRvj3E6gik6tcCbYddkgEGH8uQOPGlGw9q4GclBSOLGLezFSc8l6c5Ln8bivndMwgKzdM7xuJgZR/sjDB5at323Hp+33VsYM6O2v3OXjSX4l5yFIqgvgAA2mqUgMox9lMxuNmVvzwV60H7C6v5ycFqCtmM6f6VYnfnjGcradS0mPlagd3hrgxOiENNwgX1zImPVW4WlXKhnlVJySpaIm27sdCdCHEmjpeE2FQxXHPVuGYUBYkUvadcmYvFfBgs2/Vg4+1YF1ikeIn+BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ek9e5xpA2I8s9r2TQOCr/DLkOs0t5tBCc+WtP5jYTnU=;
 b=acVNwG6h5WauXVimQzWF37NZGLkyCt2uMnLGHYrxfWTcmKgSVYCLVm+MtB4oorp2hFAa+60LKCm8+QNq/AE0W4rrEkjSkhxal9ntJq+JO4xXoctTveJf5uaRvmPTD2uXgFBdebTcp8h3D3Y4LL2HYt8hAWlCDIr3y/APmm2cLWSr+8JYC5tZekXfWg+uTnpE3Tq69Qr9FcRtH9h/cZqeuF9oS0yegb6PSIFrvIM/U/N21zLQmKwJZqLZT9PSNDySn+Q5z79w/6SUVF8QrYN9ogrv+I/kXiia4T2hIFdMHBBGarAPlapATArmtHErAAswYLhUYC8U7hzuy3hfv+T2hA==
Received: from BN0PR03CA0040.namprd03.prod.outlook.com (2603:10b6:408:e7::15)
 by SJ0PR12MB7459.namprd12.prod.outlook.com (2603:10b6:a03:48d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:57:42 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::93) by BN0PR03CA0040.outlook.office365.com
 (2603:10b6:408:e7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.38 via Frontend Transport; Tue, 20 Jun 2023 13:57:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:57:25 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:57:21 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 15/16] selftests: mlxsw: vxlan: Disable IPv6 autogen on bridges
Date: Tue, 20 Jun 2023 15:56:01 +0200
Message-ID: <640c9cb55a0f2eaa0054e4a86e2615c64d9909c8.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT045:EE_|SJ0PR12MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 76c09f5f-87f7-410b-a163-08db71965050
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dPp9HlZmPaWB/svvLldk/UuOVBNW+qRmaNOZcRDxA3vPtey2Hy2o3Dtn21jryKdippG+hartr7FFGoKgqKn4EqCXLLP9sYmAU1gHlVelkKoO5CZ10hWQGiQgANed543CW3wNSsm5lPvyK7VdWsJ1d7AP79YFgmk0ivtvavpozwLVultR5IL63Fyy1uO266n9vEaULIl3BNYS+FsgmO43IV0C54j+pfzpsbMbo4vCu0U/PNoJrN4XTUjryhT+dwY+Q8FSWHGdJPEtznrvO48wxjY7BEQEajfp5mrG30YeDObtJXzUUZWIVqyGs1Ro3XhnXGGcSy3clAe0NlEYZaeNeQMVoq6YOHDtZtgzU+nXjvq6ImFlS3ih0bCG4Ri7ZGYH9S+qI0ogfEHm0gi8UDfzj4aKuM2pDV+q5Qjjm1/+l6bdoK9VABB3R4IXF8u9T5xliFcRWrlijcMKvUB0mzwoK+2dqSaBAEI+TSI0HunvjJ3/c1NxE1VWvsQp2O9m0OxWY3FiXkRdKihWXflXuDm+TbLGfnjiKasXie9lzFJWJ2auwJO8hIJU4CJrhx4foDTaGqhZr2qDAvjilt3fT2l4VWJKMJf+Q+uy08jDlyVMORC5EjQH8H3l7aNsZr57K+WR0FlHrON5vRwUB4XQ5mRg9h6ZTqFTb9Tv+wxMcDLsZD/v0zOXJ0b93WX6rq70BbQj/k7KBAk4xFtejZBHWAmebWBYcnpMKvFpjy/1D4dIj2VjeT050k5ZSjmrC8/WlAi1
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199021)(36840700001)(46966006)(40470700004)(54906003)(110136005)(16526019)(186003)(26005)(6666004)(7696005)(41300700001)(478600001)(70206006)(70586007)(40460700003)(4326008)(316002)(40480700001)(36756003)(36860700001)(8936002)(5660300002)(107886003)(8676002)(66574015)(47076005)(2616005)(426003)(336012)(86362001)(2906002)(83380400001)(82310400005)(82740400003)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:40.7676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c09f5f-87f7-410b-a163-08db71965050
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7459
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

The selftest itself however checks various aspects of VXLAN offloading and
the bridges do not need to participate in routing traffic. The IP addresses
or the RIFs are irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridges in this selftest, thus exempting them from mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/vxlan.sh      | 41 ++++++++++++++-----
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
index 99a332b712f0..4687b0a7dffb 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan.sh
@@ -444,8 +444,12 @@ offload_indication_setup_create()
 {
 	# Create a simple setup with two bridges, each with a VxLAN device
 	# and one local port
-	ip link add name br0 up type bridge mcast_snooping 0
-	ip link add name br1 up type bridge mcast_snooping 0
+	ip link add name br0 type bridge mcast_snooping 0
+	ip link set dev br0 addrgenmode none
+	ip link set dev br0 up
+	ip link add name br1 type bridge mcast_snooping 0
+	ip link set dev br1 addrgenmode none
+	ip link set dev br1 up
 
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 master br1
@@ -646,8 +650,12 @@ offload_indication_decap_route_test()
 
 	RET=0
 
-	ip link add name br0 up type bridge mcast_snooping 0
-	ip link add name br1 up type bridge mcast_snooping 0
+	ip link add name br0 type bridge mcast_snooping 0
+	ip link set dev br0 addrgenmode none
+	ip link set dev br0 up
+	ip link add name br1 type bridge mcast_snooping 0
+	ip link set dev br1 addrgenmode none
+	ip link set dev br1 up
 	ip link set dev $swp1 master br0
 	ip link set dev $swp2 master br1
 	ip link set dev vxlan0 master br0
@@ -780,7 +788,9 @@ __offload_indication_join_vxlan_first()
 
 offload_indication_join_vxlan_first()
 {
-	ip link add dev br0 up type bridge mcast_snooping 0
+	ip link add dev br0 type bridge mcast_snooping 0
+	ip link set dev br0 addrgenmode none
+	ip link set dev br0 up
 	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
 		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
@@ -815,7 +825,9 @@ __offload_indication_join_vxlan_last()
 
 offload_indication_join_vxlan_last()
 {
-	ip link add dev br0 up type bridge mcast_snooping 0
+	ip link add dev br0 type bridge mcast_snooping 0
+	ip link set dev br0 addrgenmode none
+	ip link set dev br0 up
 	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
 		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
@@ -842,6 +854,7 @@ sanitization_vlan_aware_test()
 	RET=0
 
 	ip link add dev br0 type bridge mcast_snooping 0 vlan_filtering 1
+	ip link set dev br0 addrgenmode none
 
 	ip link add name vxlan10 up master br0 type vxlan id 10 nolearning \
 		$UDPCSUM_FLAFS ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
@@ -915,8 +928,10 @@ offload_indication_vlan_aware_setup_create()
 {
 	# Create a simple setup with two VxLAN devices and a single VLAN-aware
 	# bridge
-	ip link add name br0 up type bridge mcast_snooping 0 vlan_filtering 1 \
+	ip link add name br0 type bridge mcast_snooping 0 vlan_filtering 1 \
 		vlan_default_pvid 0
+	ip link set dev br0 addrgenmode none
+	ip link set dev br0 up
 
 	ip link set dev $swp1 master br0
 
@@ -1060,8 +1075,10 @@ offload_indication_vlan_aware_decap_route_test()
 
 offload_indication_vlan_aware_join_vxlan_first()
 {
-	ip link add dev br0 up type bridge mcast_snooping 0 \
+	ip link add dev br0 type bridge mcast_snooping 0 \
 		vlan_filtering 1 vlan_default_pvid 1
+	ip link set dev br0 addrgenmode none
+	ip link set dev br0 up
 	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
 		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
@@ -1073,8 +1090,10 @@ offload_indication_vlan_aware_join_vxlan_first()
 
 offload_indication_vlan_aware_join_vxlan_last()
 {
-	ip link add dev br0 up type bridge mcast_snooping 0 \
+	ip link add dev br0 type bridge mcast_snooping 0 \
 		vlan_filtering 1 vlan_default_pvid 1
+	ip link set dev br0 addrgenmode none
+	ip link set dev br0 up
 	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
 		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
@@ -1091,8 +1110,10 @@ offload_indication_vlan_aware_l3vni_test()
 	RET=0
 
 	sysctl_set net.ipv6.conf.default.disable_ipv6 1
-	ip link add dev br0 up type bridge mcast_snooping 0 \
+	ip link add dev br0 type bridge mcast_snooping 0 \
 		vlan_filtering 1 vlan_default_pvid 0
+	ip link set dev br0 addrgenmode none
+	ip link set dev br0 up
 	ip link add name vxlan0 up type vxlan id 10 nolearning $UDPCSUM_FLAFS \
 		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
 
-- 
2.40.1


