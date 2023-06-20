Return-Path: <netdev+bounces-12239-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A113736E0C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEECD2812C5
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C33971641C;
	Tue, 20 Jun 2023 13:56:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B0F1640C
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:56:52 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8732DA2;
	Tue, 20 Jun 2023 06:56:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XF42j/VjsTkd5jiORnGggVhkv8045kKJckvJLIVex2tjiI6u7I6o0ZKDc92ctGGvNqnkEz0tuXanzHlyyzh6LdaLppKZ+yUzuVdITYU9ETxQsdmTaDDZqg1/TX1aLr8zs5bKYi/C9tmQwN0g5UZg6LGIhdB97b3NAaqjPVH9LZ2XLvkc7fa9w9T6PyWBbr9Xl8B7u2pTTp/hjAc2q1xuxzQLPnNrAbUqcHzEMxpRTq53AeJmrQedeEpItCGuYAoW3Ci+xVj9SV9XzyRIpsLiJgagecaECWDX3f9uDxN+9xgZlhypJmy/lbc3wmVa0l7WGjBPfWT7aRvzS1WBWwW2kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QbIkZBZ1ilkaoKN/V8acfhsJ7LM1HVj4j4+snS+ul1o=;
 b=KqLPyKM7t/sYN1Q7fbAj7ZUY1urcVze5XPl45Db6Dd0ShyBpDj3r4XxYjW6Jh1wfmKXOSxyOlBq5l3pBcGAPFVUruipPVEJyLmVDOiMbOEPr0Qy1RZy9yj3l7WJSb0dcQ4Xlbty2iOxHKO1Aq7vQc1nOX0Akr+ZvRMYrnv1l3v6yAlA9C2xxBHpB50anl7RW0mObgh3sZEDlVg4cHMHfpnGXpyoE/3qDCJ3QrCghFy0LgQwzWu3DqMaKe5pS9xO+sAXNvW5N7R7oKZIAL+ouDs3ULSI8TKz3DaOwmgiBflMNaNU84zzekAEDRSUBB3N8ttqpugkZ9ioEkAL/+iIPIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QbIkZBZ1ilkaoKN/V8acfhsJ7LM1HVj4j4+snS+ul1o=;
 b=ivq4umzxajZVslQHJ72PRFYAiJ6ybYqU7Ks+PjBKose0vuIfynaYQIn7MMj3RaUR8KAUGVXoP+iIPLT1zybBUPw85GMw8HSXPzPEyRa0jsgpTIGrMAUqRSkrGq7AE8BuMPT7RzuVyIOICbm4GupcqnVc4ZJsFcp5GoYgV4V6nQrzf7A8QBBa9utdKeGOH0bIJRGI55VTq9VFPM04d/GC65tWglVevBS67sdxs4P5K/cKsCojj/l7t1/vwbHlDuWTAhJLSRm66eXRlSX3HZqCmDmYhNRyY75wQLL7vFa8Kqx8EbwgvQ9/baMxvPRg/9h37ZpPFV1vyqau/RlySanAHQ==
Received: from BN9P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::13)
 by MN2PR12MB4390.namprd12.prod.outlook.com (2603:10b6:208:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:56:48 +0000
Received: from BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::dd) by BN9P221CA0010.outlook.office365.com
 (2603:10b6:408:10a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:56:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT077.mail.protection.outlook.com (10.13.177.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29 via Frontend Transport; Tue, 20 Jun 2023 13:56:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:32 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:26 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 02/16] selftests: forwarding: dual_vxlan_bridge: Disable IPv6 autogen on bridges
Date: Tue, 20 Jun 2023 15:55:48 +0200
Message-ID: <d79a51602a4ebde0cefc104c3f799229c7d6f0bd.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT077:EE_|MN2PR12MB4390:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eac0015-12da-4b4f-b392-08db7196311b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WRfmb2IyXkpnVth1s6ZlHVio35VXIR/HiIm9iN3GRSlZUKwiZIOokJtnq62fi2xYCkRRUty2ojE+1HpEo2KduLMD4ABrC1gDDtL3H93J32WGOy1xNM76GisKYkv/3TW+n8vWU+b3lzTXCq22FyzAN4sJdI35pGyqH143y6u+5zW5TLG9xH7Cp9gAiTdJtL8u+AzG/z8NKlXlby1inovVJNW1VeOyPGTxDo4vx34TvBue0cWdnRtIP5uaY+mGdK/L+yd3Ei8JzKRi3n9SKWKjf6GNVsUBdaXcqlnXgKMIDi9trxkkd+gCxn76Hr/RGu0hqrObYd37mYQhNcSfw6XkYwUfpkdvMAS5LX/LdrD4gEnVLAv8xx7PgsXInw0Ss04xSnmER7ghlIRWNiPlZGj0qHmR7E5udKO15mzGe9yxxOXHTDHNj8CTjWM6lMlP7jIrnHRyIS+/DfqVtt9+OEWeE8Hgw+PD+MjV0PHr3SBqepTy+z8hjchqV30DIECYCeDKT+5HNNIWBlaLGSPchGLRHQ3Zez/Pteej5tE6VdFo7kIfOcHCEa8m/N+ApehrV+8+yxFFNXA0zRX2YABf2Aggu23vj4oB5rba3Q37MjkEORuVipLBJIUD88F+Fm/gSSoTUnqWRqP3El0NIUXQdlDcJ5nSNPH/Dq5FHcJ/iacdyGYCyFA86x4WlDE2VNnhQdJ3jEDQHp/I8kbz0vaZcEgyw8/HbiIQ4vigtnv5/gHP89WXiI7xKrmvDS9xJk+RGSnq
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(7696005)(6666004)(478600001)(66574015)(47076005)(26005)(16526019)(186003)(107886003)(336012)(426003)(2616005)(36756003)(82310400005)(86362001)(82740400003)(356005)(7636003)(40480700001)(36860700001)(8936002)(41300700001)(8676002)(5660300002)(316002)(4326008)(2906002)(70586007)(70206006)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:56:48.4114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eac0015-12da-4b4f-b392-08db7196311b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4390
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

This will cause this selftest to fail spuriously. The swp enslavement to
the 802.1ad bridge is not allowed, because RIFs are not allowed to be
created for 802.1ad bridges, but the address indicates one needs to be
created.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridge in this selftest, thus exempting it from mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 tools/testing/selftests/net/forwarding/dual_vxlan_bridge.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/forwarding/dual_vxlan_bridge.sh b/tools/testing/selftests/net/forwarding/dual_vxlan_bridge.sh
index 5148d97a5df8..68ee92df3e07 100755
--- a/tools/testing/selftests/net/forwarding/dual_vxlan_bridge.sh
+++ b/tools/testing/selftests/net/forwarding/dual_vxlan_bridge.sh
@@ -132,6 +132,7 @@ switch_create()
 	#### BR1 ####
 	ip link add name br1 type bridge vlan_filtering 1 \
 		vlan_protocol 802.1ad vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br1 addrgenmode none
 	# Make sure the bridge uses the MAC address of the local port and not
 	# that of the VxLAN's device.
 	ip link set dev br1 address $(mac_get $swp1)
-- 
2.40.1


