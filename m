Return-Path: <netdev+bounces-12237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A10736E01
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:56:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB1CE1C2084C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD64916412;
	Tue, 20 Jun 2023 13:56:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA392F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:56:38 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAFE10DC;
	Tue, 20 Jun 2023 06:56:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTNWQqssTDgBI6kdgVMPWfyGRQObSzRbFuwHVkJJwZHaBR2L9i4vjwBrSKWlnZRp74n/WbAWUN+3h9IUT6nfpNDCHXcvQtxQxbFu9MOQlLWJARxUdoLNxkxeg0k7DiA4m+1wmxC6tF5gkio3hts8NYvBBfgfgCCeTpuRBnJMZmi4nfXXyaBGKHf8m+vRk+8PA5e0wTiFLwvVf9YPWG6NA/S3sGp7r0l4kdq5XavSFNGA5fJb3enhrOqCQoIHMGpMyDsoU0yY46ieiuIkTLuhjjzswNEiQYFpdIuj6Ye39tAcLs3O+G84OCom5l9a/w9t68LCFAQGgYsr6r/OCTYCNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCGG7lGAwprHsBHgarZ7ZS6N9LaL6ev675HRDSZXNGs=;
 b=JUYOmQluHIUovZdbd64gaPv1c4+IzxYKjvGlXtjfUwee63AS2kqUwmY4idIwJkaSlSo9v3SrxzAgWkZHcozes4+IWBVExHjmAPYUUBJACHfJA4agQgj+NuB7L4R6uUuekk1vnRESn2HQGhUhLJR3PrUOWfEtuRCZSKHBZmczt4VSVIXI63nDEH7uKBI51PBQY9DxqHwIZCZ/EuVRvJdaZxXynbmZRaRST+kjrEFycKkgwl5kHIctD325yBnEMgrjkl31gaB9qeiqFZ+LM3K8HRfvQaBJ+e+kxuf953p6VkbkM336XwN9cSyjdrsKMggHllInC7thGqvIbgvP95YHOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCGG7lGAwprHsBHgarZ7ZS6N9LaL6ev675HRDSZXNGs=;
 b=qUQ886+jv/ag1ytEgTlsrAH8Kxp6QnhUdJbfLpy9ovHkXG8WLAuakmTa7faXroOHT/d2QaJdj7cqINPYaEaA9SzkYHK4AF/1tWqrEnIPTg1dpD604FDX+ZKQ7AuVsu1XXA9cdDpDnNbxp57zBnXeit3ljJ+64CVHQWpERYMnigDCtaz1JXihmATJr7cLOfb5KVTWicQXCIaTnGON6uNZbDXpXQjavuJRuV/5Te/5fiI5znqEUMcEauW7ubuxddHH10mufiE+zWy3HFNlHXo0wcPlTqvB/Vr7w3q/v7+R0mTWQhUE/AVmto51AlK1DZP//sk2jk12YfNMijzKwjs6XA==
Received: from DM6PR07CA0110.namprd07.prod.outlook.com (2603:10b6:5:330::26)
 by MN2PR12MB4581.namprd12.prod.outlook.com (2603:10b6:208:260::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:56:32 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::79) by DM6PR07CA0110.outlook.office365.com
 (2603:10b6:5:330::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:56:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:56:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:20 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:15 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 00/16] selftests: Preparations for out-of-order-operations patches in mlxsw
Date: Tue, 20 Jun 2023 15:55:46 +0200
Message-ID: <cover.1687265905.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT057:EE_|MN2PR12MB4581:EE_
X-MS-Office365-Filtering-Correlation-Id: ca74a200-4726-4e88-0895-08db71962718
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qEp0V7BUvyDyHPrLVMpxWD1R98vjKrEnt6aTo2lyA43SLn/zCmntA0jgNCE9cnnCiODyuExU/QhBJu1cVF5VpfIOwzlbqZt2c+St+O4YCQjuKTQqRzFyOdogutkNzrbIezq1T99xSLw99KOEksMzryJHh7te4QVDbS8jbww2HUXs9eCHN2ZhJgmN147ocSb/FXzMpVz5do3wluQ6WAJyvtDvakrcO+8TrfHVZ4/FiG2xVz0nwyIDWMP4LTepIJJoKpZG6wq5Gu45A1GXajFPaR5mNq+9duDkiOBFsYcXqbocpRQ28MXKDhqWUCIgk419LUn2Et6c175N9Q3Xntp7SNri9FLHScfqj0gHVb1knMFlMOsh/VkxouO2HzLKj0AEE41quMscEIEoogwidOos0aldF8AWy7CcRW6J6a1HMOMX+JH76iD/EKcW2Oj6VxIH2RqSIRGavd64uSLLxmvuAdqXIZ7hwb0InZDlpfsChWRNfwm5pu97lUfZZbMA7LJ1zZhTYojECaIFILGph61Mkufcz1LOEA44gixf5qpbt+AOUMOl0ezvsNHV6xvWIK7GI+49qfvjzgUC3f3vHznZv0drTVIWtRakrXPLQngs7EKYAmdEOQrWyoIv/Eh5jQoBrKKyyDBuyMsJpIdOmbkIs5Ulhpx6qgySEmv44ULo238iXCctF4W+NaMPeJ2RrKTVEm2XFtY3dymBD8Unrik+0poUm1qrSE/UM5nKIE8INrrQBLc7Gl0Mh0pctCqTixE34ZoG8LofDFT+XQjxNKo7QA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(46966006)(40470700004)(36840700001)(70586007)(40460700003)(70206006)(4326008)(16526019)(2616005)(356005)(7636003)(82310400005)(86362001)(107886003)(26005)(186003)(36860700001)(83380400001)(66574015)(47076005)(426003)(336012)(82740400003)(478600001)(36756003)(7696005)(110136005)(6666004)(54906003)(40480700001)(2906002)(41300700001)(5660300002)(8936002)(8676002)(66899021)(316002)(17423001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:56:31.6570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca74a200-4726-4e88-0895-08db71962718
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4581
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The mlxsw driver currently makes the assumption that the user applies
configuration in a bottom-up manner. Thus netdevices need to be added to
the bridge before IP addresses are configured on that bridge or SVI added
on top of it. Enslaving a netdevice to another netdevice that already has
uppers is in fact forbidden by mlxsw for this reason. Despite this safety,
it is rather easy to get into situations where the offloaded configuration
is just plain wrong.

Over the course of the following several patchsets, mlxsw code is going to
be adjusted to diminish the space of wrongly offloaded configurations.
Ideally the offload state will reflect the actual state, regardless of the
sequence of operation used to construct that state.

Several selftests build configurations that will not be offloadable in the
future on some systems. The reason is that what will get offloaded is the
actual configuration, not the configuration steps.

For example, when a port is added to a bridge that has an IP address, that
bridge will get a RIF, which it would not have with the current code. But
on Nvidia Spectrum-1 machines, MAC addresses of all RIFs need to have the
same prefix, which the bridge will violate. The RIF thus couldn't be
created, and the enslavement is therefore canceled, because it would lead
to an unoffloadable configuration. This breaks some selftests.

In this patchset, adjust selftests to avoid the configurations that mlxsw
would be incapable of offloading, while maintaining relevance with regards
to the feature that is being tested. There are generally two cases of
fixes:

- Disabling IPv6 autogen on bridges that do not participate in routing,
  either because of the abovementioned requirement to keep the same MAC
  prefix on all in-HW router interfaces, or, on 802.1ad bridges, because
  in-HW router interfaces are not supported at all.

- Setting the bridge MAC address to what it will become after the first
  member port is attached, so that the in-HW router interface is created
  with a supported MAC address.

The patchset is then split thus:

- Patches #1-#7 adjust generic selftests
- Patches #8-#16 adjust mlxsw-specific selftests

Petr Machata (16):
  selftests: forwarding: q_in_vni: Disable IPv6 autogen on bridges
  selftests: forwarding: dual_vxlan_bridge: Disable IPv6 autogen on
    bridges
  selftests: forwarding: skbedit_priority: Disable IPv6 autogen on a
    bridge
  selftests: forwarding: pedit_dsfield: Disable IPv6 autogen on a bridge
  selftests: forwarding: mirror_gre_*: Disable IPv6 autogen on bridges
  selftests: forwarding: mirror_gre_*: Use port MAC for bridge address
  selftests: forwarding: router_bridge: Use port MAC for bridge address
  selftests: mlxsw: q_in_q_veto: Disable IPv6 autogen on bridges
  selftests: mlxsw: extack: Disable IPv6 autogen on bridges
  selftests: mlxsw: mirror_gre_scale: Disable IPv6 autogen on a bridge
  selftests: mlxsw: qos_dscp_bridge: Disable IPv6 autogen on a bridge
  selftests: mlxsw: qos_ets_strict: Disable IPv6 autogen on bridges
  selftests: mlxsw: qos_mc_aware: Disable IPv6 autogen on bridges
  selftests: mlxsw: spectrum: q_in_vni_veto: Disable IPv6 autogen on a
    bridge
  selftests: mlxsw: vxlan: Disable IPv6 autogen on bridges
  selftests: mlxsw: one_armed_router: Use port MAC for bridge address

 .../selftests/drivers/net/mlxsw/extack.sh     | 24 ++++++++---
 .../drivers/net/mlxsw/mirror_gre_scale.sh     |  1 +
 .../drivers/net/mlxsw/one_armed_router.sh     |  3 +-
 .../drivers/net/mlxsw/q_in_q_veto.sh          |  8 ++++
 .../drivers/net/mlxsw/qos_dscp_bridge.sh      |  1 +
 .../drivers/net/mlxsw/qos_ets_strict.sh       |  8 +++-
 .../drivers/net/mlxsw/qos_mc_aware.sh         |  2 +
 .../net/mlxsw/spectrum/q_in_vni_veto.sh       |  1 +
 .../selftests/drivers/net/mlxsw/vxlan.sh      | 41 ++++++++++++++-----
 .../net/forwarding/dual_vxlan_bridge.sh       |  1 +
 .../net/forwarding/mirror_gre_bound.sh        |  1 +
 .../net/forwarding/mirror_gre_bridge_1d.sh    |  3 +-
 .../forwarding/mirror_gre_bridge_1d_vlan.sh   |  3 +-
 .../forwarding/mirror_gre_bridge_1q_lag.sh    |  3 +-
 .../net/forwarding/mirror_topo_lib.sh         |  1 +
 .../selftests/net/forwarding/pedit_dsfield.sh |  4 +-
 .../selftests/net/forwarding/q_in_vni.sh      |  1 +
 .../selftests/net/forwarding/router_bridge.sh |  3 +-
 .../net/forwarding/skbedit_priority.sh        |  4 +-
 19 files changed, 88 insertions(+), 25 deletions(-)

-- 
2.40.1


