Return-Path: <netdev+bounces-12240-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3186736E11
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8B4E1C20C63
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA3DA1641F;
	Tue, 20 Jun 2023 13:56:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BB514AA3
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:56:55 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875A1CF;
	Tue, 20 Jun 2023 06:56:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQe4iEHqfFIJZYYKykows3EwcRySV5qo27vxTchP/mdf0HtYOwM2qLTb/KbyHGZsk3MYwAR3dTE41JZtTeMWU2Gw3CSyCs0sAooCf9CdlOZ5IVPNnogN5FgeODyyg8JmZ4sm6AqgisMUoq/rljny7e9eWBmtqYMs/R+Z1pme1mQ7Cwyh+DBMVH75ekytIHgS3h0KVcjM3EGklwwVDk+i795RW4cvNA8L62MUsp5RFP7+dlcLmKuCebfquIj71RUrY7Xw8+ofLA3t4FFtJ4F7T5ZQDnELz9z8vJIwXUEjeGdw2k5viyfEBV3Vi2UIRD1LfmUIib4TE43hfdZId20DTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qV5UJXrBf2eZAVglW/rxhIEfxoZDb/BHlLBWQjREYXU=;
 b=iSfvA0LDZWsLbTo1Fd52nfnVIj3J/AJ8X7fBGICQBmslg7PlIM3FdllDJe5FQBAKtyZ04+qwTWU25DefhoLCyzu7rTu/0nl0AtuRsPb3DY0VtDK2XrJ7iu1lP/BtqZgmlGZI+GIunkPHGpin3EOAq+3sdmGPCaWvM4iRG5EwknGZ9CmoDKkqHGOSAqv3fVZ33S/LRtWeifHDIrDa14LSWQGNiUlWlUpyr656n+L4tIsKYR/HL0pKVjkCmenmeiDnAgGQM5JPeiHJdyBPaoqeIZM9Puzg0x594cKVkUgm0LCaGQatx4dVApToRFfOttG5KOKbYK02AZIsoryuMV0mmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qV5UJXrBf2eZAVglW/rxhIEfxoZDb/BHlLBWQjREYXU=;
 b=MVXYOEOa5nLFMPQnUYd91opaou0+aTN1h6FwVmgkpccXbtIYznzbyBg/DzVVFr2/baO6mIg1d1n/A5YrNP+muMHY+b9jBuhfZcWYjkIpkYsd/kwGb2IVjbN1mzPn5wEwjUvgd177iPqrM7j+rjW+or/CAD2kvsvWWwxX64rUIPgWQucmpD/8pVMRuNJVI9558IFOT5KH9QYMuv+dMBKBJUu3zyLlpUUjsz+octOaGW760exQQEPdtPQkpyO5nfSYuxxJQh5/5wOvfKayAQbg8Yg53OLb2Em8LINdI9sedPT2dP4gRXOflSsgb5XsV2kwwh9VzPwjcOWxi6OPEAQmSQ==
Received: from BN8PR16CA0014.namprd16.prod.outlook.com (2603:10b6:408:4c::27)
 by MN0PR12MB5955.namprd12.prod.outlook.com (2603:10b6:208:37e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Tue, 20 Jun
 2023 13:56:51 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::33) by BN8PR16CA0014.outlook.office365.com
 (2603:10b6:408:4c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:56:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:56:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:40 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:36 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 04/16] selftests: forwarding: pedit_dsfield: Disable IPv6 autogen on a bridge
Date: Tue, 20 Jun 2023 15:55:50 +0200
Message-ID: <23dcd3264f6f93356e3ee1aa12287ba8ece9f2a3.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT048:EE_|MN0PR12MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c9f7e67-b52f-4bcf-87a5-08db71963285
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Y4Zn3aIWlfeqR9K1ftCGRs1jvHBYAV3LLuW5HlH7Zx3oUKDJgzVVN5oVFkBBcwm7qCQquT9UTJb/tXxGYLEOC3lGXt91hALVCxWezWmWRKEgyQnqmsjBS6buEYmFmu+/6g84crbHEwFguq4/FOlb48kW/MLuFKn0lU0ncbJPRV9KklJua3HdIbTTP55i0EZhckrW1aVTb+rUt3A89HeABp5gVaPkL2YT3PkDSUdu7+6y+WfrQtFRIiEt5/MDFwcNSgUtdw5pIX2/nXhhGTWR8Zwx1DqJVg/QZJHXe/j04912DhSU9hwlqCzluSWyOqZi1j8bJUVTn5rfUndGqlr8aGUcP64nvif8ALDAFF+xdelsPZ+q4wDaeh1KAawcP1vbwQRFq5FfX61sF+p8Du+lk9bSNy1s6hyFL0ROgI3S9DROeo9L9sjj78flQRqHrhdITn8eBI37Cg8T6M9vScrBxPWo41OzVEnmLdijUWSBN0yQvQq3m7NXo+YLrtw9cMJPLHc/zzkyg55nFGJKmP2YOKkIgxwZpTeZ58tzvmE69qEzJ48klnCTu2ooN5/GBb/cyq645kMZH9n8UAl61S4psrXkSVUIO0BMb+2xJEYX38yoLL99hUmaphueEL2KbS9V5rq9rJETHbFoNjfKUOfaJvhad/TkTRfXj/pYS0S2dug8SvBjU/j6YZUNNS5ST88H83FeGWWqPbIFNtCE/DRduJxFsJntTngTU0YV8q7wZZSwJNsCBUmFOy+AlYb5L/kP
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(5660300002)(8936002)(8676002)(4326008)(70586007)(70206006)(316002)(110136005)(41300700001)(2906002)(54906003)(36860700001)(6666004)(7696005)(40460700003)(478600001)(82740400003)(107886003)(40480700001)(26005)(186003)(16526019)(83380400001)(36756003)(426003)(336012)(66574015)(47076005)(7636003)(356005)(82310400005)(2616005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:56:50.7827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9f7e67-b52f-4bcf-87a5-08db71963285
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5955
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

The selftest itself however checks whether skbedit changes packet priority
as appropriate. The bridge thus does not need to participate in routing
traffic and the IP address or the RIF are irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridge in this selftest, thus exempting it from mlxsw router attention.
Since the bridge is only used for L2 forwarding, this change should not
hinder usefulness of this selftest for testing SW datapath or HW datapaths
in other devices.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/net/forwarding/skbedit_priority.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/skbedit_priority.sh b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
index bde11dc27873..3dd5fcbd3eaa 100755
--- a/tools/testing/selftests/net/forwarding/skbedit_priority.sh
+++ b/tools/testing/selftests/net/forwarding/skbedit_priority.sh
@@ -54,7 +54,9 @@ h2_destroy()
 
 switch_create()
 {
-	ip link add name br1 up type bridge vlan_filtering 1
+	ip link add name br1 type bridge vlan_filtering 1
+	ip link set dev br1 addrgenmode none
+	ip link set dev br1 up
 	ip link set dev $swp1 master br1
 	ip link set dev $swp1 up
 	ip link set dev $swp2 master br1
-- 
2.40.1


