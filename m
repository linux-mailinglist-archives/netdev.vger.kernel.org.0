Return-Path: <netdev+bounces-12241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D0C8736E17
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 739881C20C09
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BE3168AF;
	Tue, 20 Jun 2023 13:56:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAB8168AE
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:56:56 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85DAA2;
	Tue, 20 Jun 2023 06:56:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvG9X27QwoKQ9uMBwMtjE8CG0RpfaCOOos1yubyoAheqqEiVMjrr7gX46HNXgE/o+SFg861jjf7C2tYfRIXR+IZV2ltKNHnx5osJtE8THDrfXqjoPM7M436lQzSBNkdM5lVrUbNXRCOGaqnfJK/y24jrSUrLnO9fy29zzPhhiCyF42lMVe5OHF60F5IgeoEaTq7hDVSXkrLun+BeLVZKMGvLEXajZugULJ35fG0thNSUMAR7YqayGAc0OgQpqUeK347oXzhwrsTgvFV6J3HxCsJWJxUOKvIqKH1R8M18Kwi1Ao21nTMwMgVKjJsPp8Ne/vPE1lNrAmhkc8laZGjOgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOtLzkHKEYIkJimtmtyRMLdi9C3Ing9qiUFXKrWAMvs=;
 b=bRtN/g8yI7KYKUYxTt6RSXp2DVlypK/g50x68f59NwcD8FNkU9bbDlm1KhQiEbAk/cHltcMEIl3G8jpUxfRM2ew8KercaHEVjvut9RNd/L94sGyCA9+LyFnwBIS6fhgU3QGGm6PV30CznHmVQNw8MHroa0zugLwu57Pb4hQL6rBC84uvISTRtB6lW58tICEMmE6Bd8EGoebQCtE5rnY/g6tGPvc1/MzqfF5JGxTCMbwM0Zn2rVUx+tGfW4Xj3VeqLVldb7kjz2no4IydTyuEnCskTf4iPigN+DPJUNagZzsn1oJQJvhOUjR6ZptZOBmGFMNaPx+CBUg+boM1vGz+HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOtLzkHKEYIkJimtmtyRMLdi9C3Ing9qiUFXKrWAMvs=;
 b=DYCOHGmWnRYmnq8AFWf1r/cPRWd+y5+8Z3kP+1lhVbxXk2CaLXUzgz6Vapl5BIyHA4rs582Q3KIj/oJ0KYCfuVVcw6KWEMvTOQmVFNCghpfXeWzr8euB6TJn6ir2UXsRUzS/VVdDxP17HoZrBeBJilTrVlwnp7kM9jOPhLJ/eoEOQCHQQWL0m7bLlA7IvqfhpmI3CmcPi2q3DsH99Ri67uLKoinayhJL82okwh25Z7zj53PoUYIm01DoQK3QEH3ItcsS+J3tGGCKf9T2a6lWkRvGMlUvELMg8pfxeOBIgtGSELL1OWdglTpmdEo1c9HbIFug3sivyRhrQ1tzNGPgIg==
Received: from BN0PR04CA0097.namprd04.prod.outlook.com (2603:10b6:408:ec::12)
 by CH2PR12MB5514.namprd12.prod.outlook.com (2603:10b6:610:62::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:56:53 +0000
Received: from BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::a1) by BN0PR04CA0097.outlook.office365.com
 (2603:10b6:408:ec::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:56:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT090.mail.protection.outlook.com (10.13.177.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:56:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:36 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:32 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 03/16] selftests: forwarding: skbedit_priority: Disable IPv6 autogen on a bridge
Date: Tue, 20 Jun 2023 15:55:49 +0200
Message-ID: <cdca66f7671fd876d197161ee69e13303c416969.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT090:EE_|CH2PR12MB5514:EE_
X-MS-Office365-Filtering-Correlation-Id: a4b31586-8979-4898-d067-08db719633eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IYIL1XHMSyQjNTUcHls71iwOPL3XOWJX315dz+1o/uTBIj9Vh73tlwM82gGVjJxYn4Of+P6YihQr6zSI+p5GeyEddAAuvSLSFvWb9GJRZjiw1LrtlvZ2GjIySXVEHhp2PPYQIt3F+NWx9FZjWHN4Y51chTC09oIb54r0HcYk45NKoL2NBnvtyImoiAvn+vZY9EtR7aMwRG7J36BO55HKCJKgwLApIi4bQbA9dIUA34uiKZtS/58n7D2r++4VTVTo8w0n37LAfyNA8NtAHUG8NBlXxKHKD5k0q8YRTEwbm44kFlvynbXfX6H/YfNXDXmhAoyWOF0yX+EaqokOuc3M0+MZIz0bp8LC4xKa5yxkcndQCG7Ys2yjsD8H6ElPlPcbh9/hmCE6H4CbpfBvrK49tvVbKQ/XuesBRXFvEreOFo+auLUePiVFSvA2wVvVSgBXXH56Y/mN1c3opoHl6W1yVho5ZdopvC3cjRUBx9Fd0KI4FgZh4lZMNqzyln8MM07rtHqRPAmpJLQ3UkMz/c/DJR4aaJkCWveNKW0MwQ6T/VflCtriFg3fS6VzkvUwQWFNGBrwkx6AMHUy4M0xH6+DPbdYz8MEKsuhNPB2JbVMt1FxX4P3RXRu25lPzxdJhVL0w+YtC1Oy8tfRFUufUXWyNCPsn7B/M9tfnmKWyxD0aKoc+zsh9WN/zrYlQFxxg1sj0KwwoqkjgBrvAYLCojTncBAcDhhXK7LCYsMazRM03sVUzPbzfQGgY2kZJfrVNLd5
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(5660300002)(8676002)(8936002)(82310400005)(70206006)(70586007)(4326008)(316002)(41300700001)(40480700001)(86362001)(40460700003)(2906002)(36756003)(7696005)(6666004)(336012)(426003)(16526019)(186003)(26005)(2616005)(107886003)(356005)(36860700001)(7636003)(83380400001)(478600001)(54906003)(110136005)(82740400003)(47076005)(66574015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:56:53.1151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b31586-8979-4898-d067-08db719633eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5514
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

The selftest itself however checks operation of pedit on IPv4 and IPv6
dsfield and its parts. The bridge thus does not need to participate in
routing traffic and the IP address or the RIF are irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridge in this selftest, thus exempting it from mlxsw router attention.
Since the bridge is only used for L2 forwarding, this change should not
hinder usefulness of this selftest for testing SW datapath or HW datapaths
in other devices.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/net/forwarding/pedit_dsfield.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
index 64fbd211d907..af008fbf2725 100755
--- a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
@@ -60,7 +60,9 @@ h2_destroy()
 
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


