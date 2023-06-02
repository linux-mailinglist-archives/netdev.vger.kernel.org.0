Return-Path: <netdev+bounces-7496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C1672077B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF5E5281AB8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC991DDE2;
	Fri,  2 Jun 2023 16:22:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E231C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:22:30 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E7DE55;
	Fri,  2 Jun 2023 09:22:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFPKddFdVkpmm+Ad1vROGPv9A4PoGEW9VMNURshy8ckUglmXiWtv0mCeZY/MOtpbpF1v/X+nZ9vvTWTSwxyFAvU+5QyvIoESofVUf5vM4a5vxwbE+9KUAhZDwpa+8iDB2Y/PTvGo7Kkc1x0Kalz6qD/ZX2doO//LrN0GFswxQ/4mPTjwFZ2nYm47Jt5U2MtUvtMnL+poS8HJbd/Mbgy4B8kaUN1Y7oIBocoD4QnYpj/2z7Sd/swx55zJGFU2lrVHGfeGmJPUwYaPdLeGk7TP3uwWUixuYu8HDIn3BHQWTmqyBPl6k4soZYgayOWy3z+PfFJP+jvoH4Z6mf9e/PBHXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3lsimMA0ii/AP2+R03TRG7R10RPbyRiOm+fJHshXt0=;
 b=HcGSdS0qiVS/xoPnDDRDtYIJlXb0ugXE6yYRzMsqURtvXvqqofHrNnQroNZaUwO1xzOqKNTs+SGA3C9KDxBqNOolt1iSNfslUfrwbapeJmnfkPKMjXC/8Z8RHreoy8HP5Sn+JR8hv7tgnHwSlz4RS6YGjLazdogrPdwNV9bjmUVzLE0NZZ9X9fTxEec3eCpRShq6u/rD3MJ6aF6rNtOmrNJv7sBNlycl9vMW9D0FzFPX/LUQ5krt38YFwF0K6sv9/pzCfEh4wgsbjX57P5caTpARi5yNWTc2bN898dLS1Z/AZXQ3lF+mviFYDAkgZl9aBmmBHr0Pz8Y/xnX5AMDCkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3lsimMA0ii/AP2+R03TRG7R10RPbyRiOm+fJHshXt0=;
 b=DYayi3fld+EpQfqyxD1PJJFyyHThNBw1E2pCwWd6UBJtDp/o7RqeAl+cQ+PflfhVLEOEcFgTKaW4896D7jcmTeW9zlhgx3cd7poQVfuHckWrVDLRFdVIBN0urChHe/P29STevQqOIlPfLI5RBpVeFzJb+eb8MDnJ7aXBwH5pQy3wGdTeCett5Pbu3Rx6Pw/Xa6Sbcozug37X/C55k0bFPP5Nbz9cVywTeSNAMAGjEOQNCLPqI07Ns3BoMUmr0R1+sIz2Lz4EnjqXDoTNjt4buMo1YzCwLUHWJEt8wUJgOFZSqcbr2bMZ+Exa0/A6fBYf0EXRTgAxlwuKJbe7VcstDg==
Received: from DS7PR06CA0020.namprd06.prod.outlook.com (2603:10b6:8:2a::21) by
 CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.22; Fri, 2 Jun 2023 16:21:08 +0000
Received: from DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::e2) by DS7PR06CA0020.outlook.office365.com
 (2603:10b6:8:2a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26 via Frontend
 Transport; Fri, 2 Jun 2023 16:21:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT085.mail.protection.outlook.com (10.13.172.236) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.24 via Frontend Transport; Fri, 2 Jun 2023 16:21:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:49 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:46 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 8/8] selftests: router_bridge_vlan: Set vlan_default_pvid 0 on the bridge
Date: Fri, 2 Jun 2023 18:20:12 +0200
Message-ID: <fe6ab58d0c666ec0c557217098322a7dbd55ab35.1685720841.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685720841.git.petrm@nvidia.com>
References: <cover.1685720841.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT085:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: e9a36647-1b60-4587-65dc-08db63855e40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8OcyxdsAFyfMQ+L0fMXi5U4AX7meWa5dz+y+VYyyaaT5gvBnqlA/I/dj3wrFUkpMrIjtooErN0mBVJAeFStqoc+MB+l0NrJcRSRx3yZOKt1YCMjmmQmWZTnDb2ca8DO6CC142F3XIVyA+PYdfI8DkxMAB7lW/vN2IdkKodteh8L4NmWpVb1edDmDIoy5oLwKPbRRZasshKhaGyRMqNSrztWFTauylHwNnZZXbnphPLIfjFwq1CWmzsi2yQ3BFupBJ3aA1aGUYWBmm9GZKswx851HbkhmD0rNli89ooGY98L271BxstTMSrbKZEnzUZJVLHWyJkpJaF3GQoPGkMck6WOI/23hTn4bD60mjNCEgf8RElQbC4VneghVwszuIGVaOzA9FFHo4YPOY00fAnoyhE6nbJ0Q6KaOmz4uzVGEJh2MSuoytXC8N3W+5BldyST73pWIVjGI6pS6SgGTAug9GPnye2ujJgHuam0i9yRjWUnLrEZLkFSqLoVZU5FOIEmiuCDmt2iLFx9wNRsJjqEJLg2BWh96V4mnicCuhz0Wq6IvVxOzlufXokdg8Z6RWI6arrSSroGFRxK3dv744CLz4mWqTeGnUD7RIcpCFe6Ry3NfAUflmKDEQCVE/Vj7UpX+pBheHD3JvMOiC9ocje8OYW+wtmlI34Eo1XBZD7zLwGqLezb/XBNKk+l2cnX1ycVuKeIJqHNHtJFAuxj1qUsjnVHRu1r5OYRHorYNDR4naYU=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(186003)(40480700001)(6666004)(16526019)(40460700003)(107886003)(26005)(316002)(70206006)(4326008)(70586007)(82310400005)(86362001)(8676002)(8936002)(5660300002)(82740400003)(7636003)(356005)(426003)(41300700001)(47076005)(36756003)(83380400001)(66574015)(54906003)(36860700001)(110136005)(478600001)(336012)(2616005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:21:06.4729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9a36647-1b60-4587-65dc-08db63855e40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When everything is configured, VLAN membership on the bridge in this
selftest are as follows:

    # bridge vlan show
    port              vlan-id
    swp2              1 PVID Egress Untagged
                      555
    br1               1 Egress Untagged
                      555 PVID Egress Untagged

Note that it is possible for untagged traffic to just flow through as VLAN
1, instead of using VLAN 555 as intended by the test. This configuration
seems too close to "works by accident", and it would be better to just shut
out VLAN 1 altogether.

To that end, configure vlan_default_pvid of 0:

    # bridge vlan show
    port              vlan-id
    swp2              555
    br1               555 PVID Egress Untagged

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 tools/testing/selftests/net/forwarding/router_bridge_vlan.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh b/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
index 695ef1f12e56..de2b2d5480dd 100755
--- a/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
@@ -63,7 +63,7 @@ h2_destroy()
 
 router_create()
 {
-	ip link add name br1 type bridge vlan_filtering 1
+	ip link add name br1 type bridge vlan_filtering 1 vlan_default_pvid 0
 	ip link set dev br1 up
 
 	ip link set dev $swp1 master br1
-- 
2.40.1


