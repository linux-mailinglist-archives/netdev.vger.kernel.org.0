Return-Path: <netdev+bounces-11966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DC6C73575C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:52:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 149FB28113C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5920410794;
	Mon, 19 Jun 2023 12:52:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46586D50B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 12:52:11 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3B11BF9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 05:51:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZO7ARc5iNXZjMFVm3jR842C64q3vSuIq2U3mc+I/0Waoacn8pngjsINVHX6WgzDYjRfCTEBaOdNFDTkZNceKdmJd5FO8+2rpt69U7LCiVvkw/DVvCRtjQ2j+P7YwcM3HA4cetMHe9tjz+DHxpJ5QFLp8Qn9h7tYYa8tGy2h8ssGm2stO7cJr1Tyf3KGlp2fW8JA6umFAv+MbAu4TgnbqVKurcCLx5HCIEF+bb3pllG735ven1+gbBtLbemKhTRpgR/vw3/tUzs5euHdeW/u4OvJipix0y7g7SFnCVKzWjtjQR0DTbbGDxB3v3TEh1eS4hxPDc5ta5bccBMDI2FeFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WT//6oO2VBevhNbTkf2A1KXdr1Dp+tz7Zfxyph3w1Fs=;
 b=LJJv7tOuNG07Z0YUYayzAF7MYnnhujGFhdP3eNWJBztrjm+/HjCCPgRrbhZ6K/IfzLYKbeFVx8erKKwRytqoMfAilgs86QBBnOova6NyCFA7pFjqBNBZJFB0YC0wLu8j2vtY1R6TV/NvzUULcn8hV3aIp7QJumEDrmm2wAjzpDaGx99YvjgCIkYg6dwV2iFp9nKX7T/CFyWOOpqOQ/ZesCxOrRL2sfxvw0pdAuJ6bKRQ0pyT/GvivHmP3bjU0szD3iBvDc4NP3DPLx1zsuj9it4rKYxrc3IJ8duK8kCqOIDQcYHRDlGcZhXBkoVDgoZi0QAP2GH2GYpISwk3f5xZaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT//6oO2VBevhNbTkf2A1KXdr1Dp+tz7Zfxyph3w1Fs=;
 b=KeTIrS+OWMGueoNOy9bNMpgyiqTVII0yppvesyf95aCzdCSDqZne/MaG8BjS7geY14ayNhujTJ50+Lf26LCfmpzic4uGtV7Hsc2kILfwTcb1jWreUU5bCnqfgmVRXskopZgv1tqsl5K4D87TArseZGvm3Qe/aj2pgtY/SHXYfGiKzq4yka6GTNG8wa970JlSWy3YoxZc5S5PZvoPnvV4ARN91jFu7UzS50fkmX6lA16iHEsSvP3tpOD4ry740+hbQJoIxMM/FCzSGI/2yMk6sZ0y7cd7ZSYognxfsymR9LbTaw1MiPrHs70D2xq/yUFixYVRILAyrPf6yaaxpugQAw==
Received: from BN9PR03CA0990.namprd03.prod.outlook.com (2603:10b6:408:109::35)
 by SJ1PR12MB6145.namprd12.prod.outlook.com (2603:10b6:a03:45c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 12:50:57 +0000
Received: from BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::92) by BN9PR03CA0990.outlook.office365.com
 (2603:10b6:408:109::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36 via Frontend
 Transport; Mon, 19 Jun 2023 12:50:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT070.mail.protection.outlook.com (10.13.177.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.35 via Frontend Transport; Mon, 19 Jun 2023 12:50:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 19 Jun 2023
 05:50:41 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 19 Jun 2023 05:50:38 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <jiri@resnulli.us>, <petrm@nvidia.com>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [RFC PATCH net-next 0/2] devlink: Acquire device lock during reload
Date: Mon, 19 Jun 2023 15:50:13 +0300
Message-ID: <20230619125015.1541143-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT070:EE_|SJ1PR12MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: be7ebba7-b1b2-4255-e5fe-08db70c3d2ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WZPuz1Gk9Lj5dQoenXv8OzW7YPQDkidNGz7WzQqVbv3EbsrldeFft45NrafbnqJjlKb5tToHP+ciLmtFMqocrCn6q48B0gm73O9qlNZCzYnzCO9HzygsV6cVxml7mutu77294XVw1F2p1IsSNUFlIZ9gAr8VMvr6MMIHrsUid8bLAv5BKtj0KIJgkhAJK84qy/kk9ziZzz8B6mXLQ7Dyw4k/wiv1N4+uA6Fs/2Bkjmupm9FBLkD5OH+WeE9ts/m8Pn+hgQPhTebjahtmyLk+V/WXu/0usGYz6vI3VN/6VL8SUjfS85RdShpQQHbG5wmKcXXp6hif1odOvI4xVkNMID+dCJlWtImgQY6VdHONCqiiEst/uTfWN+Qhoj97pD0/z0sovOlA5r9FFKbrVQdg5KUnyxQFxTSuiMzPV0v1g2GMzZARn6B63V//dfpe25FQdBbexZ+OFK5YX581iHJI8C0KdqpvtYRERpVjjxYWFHLkaEA6Jnl78NZWdFZ88qkqWicsZwqEbKzvhE7c1jmK0pV6OdsrDIF1oBuuheryofKMJQp9cdQ4+H8uhw9DMTvFmVe3tC+bZ1HDnnBTwSY4jLaShL36vEU68pLx/cF+k8iywvJ4eXmO9tqOrQQS5FZ79dils8ME0pbUIOK9bi81kFZJUy/YUJ2yQf5ZWSTTngc3V3h6kDxm4AIQlIccIBSZXTQJ0E8ZGtofMTsSuStiKoIL9QhQsahf0Ba24xW8A7YMnBrDHTPmi3neHDJXcUTn
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199021)(46966006)(36840700001)(40470700004)(186003)(82310400005)(8936002)(70206006)(8676002)(16526019)(70586007)(82740400003)(5660300002)(54906003)(40460700003)(4326008)(6666004)(316002)(478600001)(41300700001)(36756003)(26005)(1076003)(6916009)(40480700001)(107886003)(336012)(426003)(356005)(47076005)(7636003)(86362001)(2906002)(83380400001)(4744005)(36860700001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 12:50:56.1946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be7ebba7-b1b2-4255-e5fe-08db70c3d2ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6145
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

These two patches change devlink to acquire the device lock during
reload. This is needed by device drivers that need to invoke a PCI reset
via PCI core during devlink reload, as PCI core requires the device lock
to be held. See detailed explanation in the second patch.

As a preparation for this change, devlink needs to hold a reference on
the underlying device since reload can be invoked asynchronously as part
of netns dismantle. Unfortunately, this change results in a crash which
I'm not sure how to solve. Detailed description and reproducer are
provided in the first patch.

Ido Schimmel (2):
  devlink: Hold a reference on parent device
  devlink: Acquire device lock during reload

 net/devlink/core.c          |  7 +++++--
 net/devlink/dev.c           |  8 ++++++++
 net/devlink/devl_internal.h | 19 ++++++++++++++++++-
 net/devlink/health.c        |  3 ++-
 net/devlink/leftover.c      |  4 +++-
 net/devlink/netlink.c       | 18 ++++++++++++------
 6 files changed, 48 insertions(+), 11 deletions(-)

-- 
2.40.1


