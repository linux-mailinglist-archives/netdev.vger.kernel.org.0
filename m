Return-Path: <netdev+bounces-10164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D097A72CA21
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:31:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B4D0280AB4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C56C1DDCC;
	Mon, 12 Jun 2023 15:31:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1ED1C757
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:31:44 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE3619B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:31:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgaA8nCyaxggSFeEj3PRzkdW1RsK2BKZ5zZHrSQAIYzzWf9LbbI51Ea7W10sOLUbHDSElD0mgxXXmebhH9U0YlhWC11c5CKact5s7uJKTxEhbGQKnhgxNSlouhtGGmzf1LvbVcLsUL7SFUOIqlT5CFo8nJbKD5ye8RCC8jGjb1RqigUdLJnv5Dwf4QsfYvDtUpyjygS7kiVHE8cFnXbeY8k3aWFJXtOIaoTQx4kC5JBpO2KNbxqOigLEfi73nwYks7O06vsXshL5HXZYK9qdh8HLpYRFziRvXN1tJ33IJUrbL3+/+Q/yYMeJAQ+ivoEjkivfgXh+RtZRIYqknyRBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t8kIVLEXWoVd6ZbrbXkOZ3QxSGW1EbxUQBzbqa8eeRM=;
 b=F0jpZDlCs3dQyNajzY5pbDAyo//FaX42Erl2FtsxU5E5uqSVX/TMx+bUpTtDAY2FGBvLJK57+cYX989EfKAeQ9zOO1j+sqkolfp3AWoRR7lGSPq07i8QECSTCA1sV5cWt1+ItXQoABNsCvhqDeggDR7cLP/L3kyhPWwG4killDha52o4ts7KBgKaLU3yahN4uXqDbEeMDMSpGsIi5uJHk9hLjj4BTb8GS26y8IzMrNDkZybOvjwx99llZcjAgmlkmE9c+1Y1oBsou0oDvepcNAxeLFw6UqEWPV1Y8dsOrPWYmQGAJgQLKyW0b6VPP9Cge3nDhC1lQ2r25V+IuIBxWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8kIVLEXWoVd6ZbrbXkOZ3QxSGW1EbxUQBzbqa8eeRM=;
 b=o65pLzmteLxZtzu2WNNtOLsLO2LGDUbJU/V4DYBdCY01Ui9ugocSQQTpLSsICQ90GvzlsqZKK1OPkdMOsnd7CPg5nKxoi76DLa+pPzdloo4MLe/fs3s7weM4eCh1njp1k5NkG6lUMsHp5EqGrC+r8jhAoOp+kOBJWuOmphUrLZs7ZFcGoAw7okNfWhVTr31brefYgp7NCx2f6UcAOkxgQhKXr93ZkgeNIRR6sc1BCPtWGMXHPF1KhS3ZAF5g8vbzV3VIlo/h/MEmA3oR5Id6Hw9sbXG5aOCl+w9uXY6TwEpC7FLEoeEszsNi+ishjO6Pi3sI1wt/DUQrZtSWW5xd8A==
Received: from BN8PR03CA0019.namprd03.prod.outlook.com (2603:10b6:408:94::32)
 by BN9PR12MB5225.namprd12.prod.outlook.com (2603:10b6:408:11e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Mon, 12 Jun
 2023 15:31:40 +0000
Received: from BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::3c) by BN8PR03CA0019.outlook.office365.com
 (2603:10b6:408:94::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:31:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT097.mail.protection.outlook.com (10.13.176.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.21 via Frontend Transport; Mon, 12 Jun 2023 15:31:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:23 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:21 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Preparations for out-of-order-operations patches
Date: Mon, 12 Jun 2023 17:30:59 +0200
Message-ID: <cover.1686581444.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT097:EE_|BN9PR12MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 5165ade8-b0e3-4f6b-f6a2-08db6b5a1e28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UK2ASDBTPHVMVsH9f6JYhUp4TL6E+kYIkpq+Ved2AiQ/XtQ7mV2y451qiG+XxRkjd1E90t//2BS8xqSOVvY96PDDKf3Xtyd6pORXVu+qp3YGFTe9XVd1TAUvYUOemE0Y1X0bORerAgEfxa8mEKoU9EEMSTyEKN7UvMZScqUhHq7xpPJpk41qBf8NZp8xOiuF1zBWjxFxKC9suCSugNvLtWYFFKBxKurhQTbdDvMyvwHTQ2s4WbTn7SICvrItncoMNY3wAB/KQe8UCPRnxpi2IamFPijRkfyJhJf84oIgiVHMTJRiKeynxtuCt/6hbb1LElZCRTdN88VkDqiiOJD6FlnxcFhi/zibXIlmkuTCtmk1B8Xru0x/4darh46DjVwa5gvU10zEEimWKVejvIw+pRn5wRtSbKHBt/jfk2UQma/75oWshJgTVTTOvzbBrZSbNGFhqr9Jt8Vnwd3knmhZfCChIbAbs0gZGa3bm3+sExQTbU42pRG2FGjTzw+DCPe1B119orskSO9MVzcxMd4urHp0jLnKAFsoaeiRaZuTk0bkqxhsaCLbCuDd3cSSU7BS0mQhvefwgYPi9eyb4AYTU4LahsV5kHdnM5aR6CWSu7YEbiMPSm/Y1cSTwUK9k2Gik5FOdQqjYYqk9B/WPRCLkv8CQ/yd5sOg0uZWKpPpbz4PRjlnSIdGq/0yfd3IHMDSSAvItLW8qOdZCF2ORxs//idHG5iXHVlCJj27XxvT5G8O7wGOBN6wGMuH+eCy29pk
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199021)(46966006)(40470700004)(36840700001)(316002)(41300700001)(8936002)(8676002)(4326008)(2906002)(5660300002)(54906003)(110136005)(66899021)(70206006)(70586007)(36860700001)(40460700003)(6666004)(82740400003)(478600001)(7696005)(7636003)(40480700001)(356005)(107886003)(26005)(16526019)(426003)(336012)(36756003)(83380400001)(186003)(47076005)(66574015)(2616005)(82310400005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:31:39.8255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5165ade8-b0e3-4f6b-f6a2-08db6b5a1e28
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5225
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The mlxsw driver currently makes the assumption that the user applies
configuration in a bottom-up manner. Thus netdevices need to be added to
the bridge before IP addresses are configured on that bridge or SVI added
on top of it. Enslaving a netdevice to another netdevice that already has
uppers is in fact forbidden by mlxsw for this reason. Despite this safety,
it is rather easy to get into situations where the offloaded configuration
is just plain wrong.

As an example, take a front panel port, configure an IP address: it gets a
RIF. Now enslave the port to a bridge, and the RIF is gone. Remove the
port from the bridge again, but the RIF never comes back. There is a number
of similar situations, where changing the configuration there and back
utterly breaks the offload.

Over the course of the following several patchsets, mlxsw code is going to
be adjusted to diminish the space of wrongly offloaded configurations.
Ideally the offload state will reflect the actual state, regardless of the
sequence of operation used to construct that state.

No functional changes are intended in this patchset yet. Rather the patches
prepare the codebase for easier introduction of functional changes in later
patchsets.

- In patch #1, extract a helper to join a RIF of a given port, if there is
  one. In patch #2, use it in a newly-added helper to join a LAG interface.

- In patches #3, #4 and #5, add helpers that abstract away the rif->dev
  access. This will make it simpler in the future to change the way the
  deduction is done. In patch #6, do this for deduction from nexthop group
  info to RIF.

- In patch #7, add a helper to destroy a RIF. So far RIF was destroyed
  simply by kfree'ing it.

- In patch #8, add a helper to check if any IP addresses are configured on
  a netdevice. This helper will be useful later.

- In patch #9, add a helper to migrate a RIF. This will be a convenient
  place to put extensions later on.

- Patch #10 move IPIP initialization up to make ipip_ops_arr available
  earlier.

Petr Machata (10):
  mlxsw: spectrum_router: Extract a helper from
    mlxsw_sp_port_vlan_router_join()
  mlxsw: spectrum_router: Add a helper specifically for joining a LAG
  mlxsw: spectrum_router: Access rif->dev through a helper
  mlxsw: spectrum_router: Access rif->dev from params in
    mlxsw_sp_rif_create()
  mlxsw: spectrum_router: Access nh->rif->dev through a helper
  mlxsw: spectrum_router: Access nhgi->rif through a helper
  mlxsw: spectrum_router: Extract a helper to free a RIF
  mlxsw: spectrum_router: Add a helper to check if netdev has addresses
  mlxsw: spectrum_router: Extract a helper for RIF migration
  mlxsw: spectrum_router: Move IPIP init up

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 -
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 311 ++++++++++++------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   3 +
 4 files changed, 212 insertions(+), 110 deletions(-)

-- 
2.40.1


