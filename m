Return-Path: <netdev+bounces-12243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA62736E19
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FBD81C2081C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6793A171AE;
	Tue, 20 Jun 2023 13:57:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556BD171AD
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:02 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CDDD3;
	Tue, 20 Jun 2023 06:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJrAmLPfpm7bXTkFBjRbWWdNIr27wc9BZNr7pZIfeQtngulm71lIJlAHrK1g7gZ6QV0JduQgUS0rcNlZlBfRkK3D2xpTkIBiBHJQpvPBpb25oRYuVSnXFcgDgjyWUdEX+uf0ZJQM/0Iw7aHUDl6nZTDsQ5DkeKKt5YtFHHIwHjLAAkVQXmR262sieZmMC4CIykBZhG6hlqql1Swp8hBImi9w2n+j2k2RBGTC5x6t9JKkJyoKJR/2QOi9qjWNnO0BUugFo8wtS3jSZ7OrCHbQ2fqHdcgZo+JQzoWwtso1eDrJQ5hPs306+ap/9Or5bxJSgRLfewh3zyRWXqkVq3dboA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVD+Himn3jxE+9Z5FakfaoQYgmgYX+OPfhpual5AgZw=;
 b=OBfl35wLrYcPGAChVdBE7eZn1QwRI0gY0AdL4f5q6gRs/hmYaTpu1nrgvEw13wNIEhBlIEJxgV/lpjkIlLGetmbMDB3J0jxvFBa0aNairLR7FPc0t6hmV+2D9O+cyaMQsyFOjT5gXOq2IhNP/C3CuqbxbVO25OgL92qkv/nD2urBQeCz2fxbenG0lZLh4wvhCMWaH1ciNFYA6fYTJdQdmcV3W8A5zoSiCXt/FHNYtPrCu3zZTadUObynUTOcNBLrgqFXTxeDqwhq99DNTpnaTvKOwS+8DSsEQiKeWdsVJHYa78K7j/u5WPSJqaWwJC3zxqibazxyGQw/4SwZ2+Uj5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVD+Himn3jxE+9Z5FakfaoQYgmgYX+OPfhpual5AgZw=;
 b=BX21g3917lIcuo1HJjgABCPjRKn50XXYPLBhw8FZRgaBG6yHq1UVr8AmnSXbNITLxEoFNkxCOY302fSBl42CpLS3bcTezq/tiHgkWfGCoHpdkg9jWyQ6TKKBltMCd7a+4cpbYlYaYml9hjIvAkeQNyJ/oWGfR9T7JN43fJyQUf5pstZmUVjhybP7Sm0u7/UrAJaXjIPq3OGN0w4SxT5M/ZnbcXDqj/bPYimkFFWlpWORVBRQmRxFeZKMzTL6gemG/Eba6hESxkiRbJQTnrtG+Q51bVN3IVOOezrwMSj33QsWukIE9KUe9Fu2JBqLVMY+YHYTPtcbM/zpDfRnWm2DmQ==
Received: from BN8PR16CA0014.namprd16.prod.outlook.com (2603:10b6:408:4c::27)
 by PH7PR12MB6420.namprd12.prod.outlook.com (2603:10b6:510:1fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:56:57 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::63) by BN8PR16CA0014.outlook.office365.com
 (2603:10b6:408:4c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:56:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:56:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:49 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:45 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 06/16] selftests: forwarding: mirror_gre_*: Use port MAC for bridge address
Date: Tue, 20 Jun 2023 15:55:52 +0200
Message-ID: <9f76a2fd0f89db7ee6e857c2c072db577acc98a9.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT048:EE_|PH7PR12MB6420:EE_
X-MS-Office365-Filtering-Correlation-Id: 08549f67-f05c-4cf0-83ed-08db71963660
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HhSWb+fRp7/bYYcFJ3x3G+Bc94Z7hzj+36nS2YQ2pPqM09CH9eEwnvJGz8Mi8tatPIHfEWsW6iJXWi1qS4OsPHv3X/syXVzteopfg3W4qdKXBn75M3TGkdhsQl8rmOeAMb1busVvnUxjHDbZu7lAO5o8bDNVJcOi6BcbBKS+4hPo2SDEDHMArOIFUmdkIaREsjnC7sXqOXugcgtIpnBeMpXb8xL1koqyU9gf5ioX0CvCRw3GYjmqb0GJYv1FnyU0rVg7pJh2NTfFs/U5w8/ubWCpbCc6afv+5QUChxg2zdds0AXaaRupHfrAOBergOWlwd/63frCe+kAbtyItInEi7nXTelHy1yaZI1gsgKeDX/y5FIUb4V3eWuB7/VtVXJfnPIcugsrcZqpDR7O5MQRZnHdlOEFkiNiRnGZr+BWbS1Yz6S40X82+6vrVylkD7tbtyhAv8qo31rs1QyPiT0v2T3o4DIovrB5XyU70AyqS45pYJB+QW2djgVUCMiDpH9RmqrIDom7lcgudJmXrvFTkfMclHPYRVrynjnsKXRKQdYYS4cshLQeDJM0HoBfLtWAqEVFGSS1mXJJ6t2CCFxUJKgoEPRt4SMxiZVEAoRhCyzG6rEcsjKm4H0T/N736fdM1IePUfGEOUAoRNc3Av/1PMoP/S5TTBzUJ1XMRIzn5twW/Fvq2Ddd3y4bYLXzjtBuWYiJNGC4OzbMVD9Nwv0ID1oq/jMg85/VbUXo25erDlY=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(46966006)(40470700004)(36840700001)(70206006)(70586007)(40460700003)(426003)(83380400001)(47076005)(6666004)(336012)(86362001)(36860700001)(82310400005)(4326008)(7696005)(186003)(16526019)(316002)(107886003)(26005)(8936002)(41300700001)(2616005)(36756003)(8676002)(40480700001)(356005)(110136005)(5660300002)(7636003)(54906003)(82740400003)(2906002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:56:57.2354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08549f67-f05c-4cf0-83ed-08db71963660
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6420
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

The bridge eventually inherits MAC address from its first member, after the
enslavement is acked. A number of (mainly VXLAN) selftests already work
around the problem by setting the MAC address to whatever it will
eventually be anyway. Do the same for several mirror_gre selftests.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh | 3 ++-
 .../selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh      | 3 ++-
 .../selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh       | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
index aec752a22e9e..04fd14b0a9b7 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
@@ -65,7 +65,8 @@ setup_prepare()
 	vrf_prepare
 	mirror_gre_topo_create
 
-	ip link add name br2 type bridge vlan_filtering 0
+	ip link add name br2 address $(mac_get $swp3) \
+		type bridge vlan_filtering 0
 	ip link set dev br2 up
 
 	ip link set dev $swp3 master br2
diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
index 1b27f2b0f196..f35313c76fac 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
@@ -35,7 +35,8 @@ setup_prepare()
 	vrf_prepare
 	mirror_gre_topo_create
 
-	ip link add name br2 type bridge vlan_filtering 0
+	ip link add name br2 address $(mac_get $swp3) \
+		type bridge vlan_filtering 0
 	ip link set dev br2 up
 
 	vlan_create $swp3 555
diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
index 91e431cd919e..c53148b1dc63 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q_lag.sh
@@ -140,7 +140,8 @@ switch_create()
 	ip link set dev $swp3 up
 	ip link set dev $swp4 up
 
-	ip link add name br1 type bridge vlan_filtering 1
+	ip link add name br1 address $(mac_get $swp3) \
+		type bridge vlan_filtering 1
 
 	team_create lag loadbalance $swp3 $swp4
 	ip link set dev lag master br1
-- 
2.40.1


