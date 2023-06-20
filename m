Return-Path: <netdev+bounces-12245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28227736E1F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7BB32812DB
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B17E016432;
	Tue, 20 Jun 2023 13:57:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50EC171D5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:15 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA52A2;
	Tue, 20 Jun 2023 06:57:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GElS7jY+XFkE7mn5FDtM00W2BBDhjZbju2EcqnnGGTLObVZYVTkDuS1NUePOW7eM0EkTHRzfBAatYBGNryE44FuhfTcYiuw59zw1kCE+keZA5AIsHsYXnE0884JzadnVp1aDG8SajdFv4Kk7w7YEb0SdQaTVy3HTlJBwN5xwyXGLD2RCWV4mNhIM6xB1lm0hymJhVBUwpC2vBPoiSG6/GRAToMoRnFP6SstSCREZv/pecVK36a/Jr3oF9MCmeTehNRydXY+OcRXj3iEBkGkkD0YT1cZ0ULGyR1kwDN5a0n9bs0n2Jlh3BK48g6xjlH9XTBKqJK0m63UlZ3nXhE829w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77kIKvy+UbrIOpvL33Kv7RIfoeIFrzBQkzWjZsF26L0=;
 b=OHjVuGQC2BOIemdNB37NTAAv7SQhsQrlF51LGGcrh4VCK7ufx/e3Ivtu7PZuadHyupVp9UB/NiIlcnB2U8CZED+2L6oANEPQH+B0pappIbqg89Ssom+nyzx5wBRBywTxi+KFB1QktzcV4c4+XZqGufeLltd+vCzVWunKYqqoBIoWjOAEmFdpBbtW6fY4PZHhrBJU8SdEycX6CHGS1PrQrSRm7xO1L2h94JlblbuRxS6+Ep/MJSh3CpL7eZnGVIve/eJ1I2/s2BM8lY0hsBPKhVTRGgVeDV+J1P28YIRVJdLjH8Tvm3E8sPzmva+UD3SMJmvU3Y9g67BYj0p0bGQUgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77kIKvy+UbrIOpvL33Kv7RIfoeIFrzBQkzWjZsF26L0=;
 b=PMn6ibgKsFcVZ2CxuUoF3cw8pmI9fYyAvraagHe2SbBmna3QmzCLpCcR4ctSCBnszj21L2w7Pf4pg2s7dSotQ/uelG7rT/LHNaXRdteRNttnr7nZkw+zWTNQC1Rxa44CSsydh5/OaO4XgvLQBihqxP4Qnyi2otWrYH1nu8gVL6pkjAipP1UoEipZ8efaQO6FaLsgpVCskslliZkxQwfBWF9awmnyjKOR18wiYkStQxW6Qefxdg0fsK6WWALCbjwn9j7guzVBks8f6xmonG3uBurFIdjOywePKWyExXylY6HT8kT3JM0lfgpfeT01+oerjkCpRRnNb5Pujr5qPE4ASg==
Received: from BN0PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:e8::20)
 by SA1PR12MB6970.namprd12.prod.outlook.com (2603:10b6:806:24d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Tue, 20 Jun
 2023 13:57:10 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::5a) by BN0PR04CA0045.outlook.office365.com
 (2603:10b6:408:e8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.38 via Frontend Transport; Tue, 20 Jun 2023 13:57:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:58 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:54 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 08/16] selftests: mlxsw: q_in_q_veto: Disable IPv6 autogen on bridges
Date: Tue, 20 Jun 2023 15:55:54 +0200
Message-ID: <7ff597df6c315e4cc6cfb50f9cc399f173475239.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT004:EE_|SA1PR12MB6970:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b80b091-0c1c-4a89-537f-08db71963dcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GSHEGdbwIXJpPJGL2cL/k9LGwixOE7TzCJa0ksfvTPK+XdEaDqwemAh0CdtslIckN0biTd9RP5ytjb+IvI2/HYm+NXxNDqQgdXkH27qaFaw7+JCEU/r9v2UKNQfJq0BrHO4U7QCb0FR+7i1m1dnE0IMFNkLXO3Bl1+Py3whjZD6nln3kgv+NHtG3W1ZQmuVmWd52zo+7xkJX0DdVgCE4ODY0vAvFK6T+CV0uUMzjPqxfMH0PXrMiQ9d659uqDRJKulz60OkfXVoxBF3EYwlq41BMyBGRLjawfzE/6i1m3rBp5fu6JC1MrsJWVne0YmsSD/GWWDttV//37OuABDhPao+ddue+pZ239b+CpgeOOeCjEyQTzUmrbDmK+13T5m88EBX2pJKZ4N9euSGIDfV6EgCpy5l8WDmtNTBSApi+xCIylZHTn0/zIcM6klAjRzhaPALQBw5UFB5aNXVQMn8N/keDSdNeD5J46CdVIL2pNsSWkMw+0GEfzt9SUCQ3GJukWSk54W4iYisPccsn3VIobJnhDJ8fKE3GlK1e2orn/LaEEUFepuhYtI4v+Kt0uh0mH7Rsv0J7mTfXro55vAlYLJdiK9DNQjACQ/Sq4NG0yq2tX7/St+mlGz1aWPF82329bNLbiclFKePX66o6RAHZJVR+kCiaJZRIk0q2FiAyMegtYBH4J0DaJQPWq0ggIE9hF3jHPULHdOS0smF5ILupndvTPVy/OXu6eBGfF+YtWEE3mz1oeA1tuoku5h8VPNlh
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199021)(36840700001)(46966006)(40470700004)(2906002)(40460700003)(5660300002)(8936002)(82310400005)(36756003)(40480700001)(8676002)(41300700001)(86362001)(107886003)(478600001)(26005)(54906003)(186003)(110136005)(16526019)(7696005)(70586007)(70206006)(36860700001)(66574015)(47076005)(7636003)(356005)(4326008)(316002)(426003)(336012)(2616005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:09.6794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b80b091-0c1c-4a89-537f-08db71963dcb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6970
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

The swp enslavement to the 802.1ad bridge is not allowed, because RIFs are
not allowed to be created for 802.1ad bridges, but the address indicates
one needs to be created. Thus the veto selftests fail already during the
port enslavement. Then the attempt to create a VLAN on top of the same
bridge is not vetoed, because the bridge is not related to mlxsw, and the
selftest fails.

Fix by disabling automatic IPv6 address generation for the bridges in this
selftest, thus exempting them from the mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/q_in_q_veto.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/q_in_q_veto.sh b/tools/testing/selftests/drivers/net/mlxsw/q_in_q_veto.sh
index 7edaed8eb86a..00d55b0e98c1 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/q_in_q_veto.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/q_in_q_veto.sh
@@ -48,6 +48,7 @@ create_vlan_upper_on_top_of_bridge()
 
 	ip link add dev br0 type bridge vlan_filtering 1 \
 		vlan_protocol $bridge_proto vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 
 	ip link set dev br0 up
 	ip link set dev $swp1 master br0
@@ -88,6 +89,7 @@ create_8021ad_vlan_upper_on_top_bridge_port()
 
 	ip link add dev br0 type bridge vlan_filtering 1 \
 		vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 
 	ip link set dev $swp1 master br0
 	ip link set dev br0 up
@@ -155,6 +157,7 @@ create_vlan_upper_on_top_front_panel_enslaved_to_8021ad_bridge()
 
 	ip link add dev br0 type bridge vlan_filtering 1 \
 		vlan_protocol 802.1ad vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 	ip link set dev br0 up
 
 	ip link set dev $swp1 master br0
@@ -177,6 +180,7 @@ create_vlan_upper_on_top_lag_enslaved_to_8021ad_bridge()
 
 	ip link add dev br0 type bridge vlan_filtering 1 \
 		vlan_protocol 802.1ad vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 	ip link set dev br0 up
 
 	ip link add name bond1 type bond mode 802.3ad
@@ -203,6 +207,7 @@ enslave_front_panel_with_vlan_upper_to_8021ad_bridge()
 
 	ip link add dev br0 type bridge vlan_filtering 1 \
 		vlan_protocol 802.1ad vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 	ip link set dev br0 up
 
 	ip link add name $swp1.100 link $swp1 type vlan id 100
@@ -225,6 +230,7 @@ enslave_lag_with_vlan_upper_to_8021ad_bridge()
 
 	ip link add dev br0 type bridge vlan_filtering 1 \
 		vlan_protocol 802.1ad vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 	ip link set dev br0 up
 
 	ip link add name bond1 type bond mode 802.3ad
@@ -252,6 +258,7 @@ add_ip_address_to_8021ad_bridge()
 
 	ip link add dev br0 type bridge vlan_filtering 1 \
 		vlan_protocol 802.1ad vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 
 	ip link set dev br0 up
 	ip link set dev $swp1 master br0
@@ -273,6 +280,7 @@ switch_bridge_protocol_from_8021q_to_8021ad()
 
 	ip link add dev br0 type bridge vlan_filtering 1 \
 		vlan_protocol 802.1ad vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br0 addrgenmode none
 
 	ip link set dev br0 up
 	ip link set dev $swp1 master br0
-- 
2.40.1


