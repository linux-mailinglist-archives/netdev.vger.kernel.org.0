Return-Path: <netdev+bounces-7488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F084E720761
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:21:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB792281A05
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258C61C765;
	Fri,  2 Jun 2023 16:21:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DD81C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:21:37 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EE3E55;
	Fri,  2 Jun 2023 09:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KN2FwpI+EOqS9vAYMfS+F2ye2GR08/C5A6M4VUM95Y6xUsH8ao31FYON7GNGlRh4cpV27jHx5VLEzKJnonVt5rL2hen0GLzml5NeEG1m35Qpj57LO3l5CXKasOTt4HYQinEBSpfjSn2jKGw3SpSHKFy4rX5tA3KAU+XTMwfSugIZErptN3M/Ps00sIWL2u0Zo0+vPTxCLi4QpFwwOxqv2HNAFzyfUNCGvaL47TNoawHcW8HFKodpckpKd1NLnoateTXtjls3mdb+MG0mrZYFH84tQgB834DxL90eIaWnjbX0ISPp9k/m7qm6LZVvaYrghNvKvjeF9q4JJGeUIyvDDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=855/DLlKiFeNQS4YmjvpO65TksLfn0yaNoyWQZ7a/hY=;
 b=Yg+WGdrAu8quwdPG3d+5ehs0866D7xPsxmybsW2Xqsau39h+OF2k7ZOxWS5JW+eg9hM1Zd51gh1A1oRCvnLTPCdbOlIZMCt0KVvCZ87izk10BTixrWzERlecBxjQR9ZGHwMKafulSrvzIQ8y4AUAU1cfLLhBIKd7+Ebvobnhhf0ewYbbuFvR04w7LIPidpw7MSp9B/IG2hky5rohsaLRMnG25HTL2ehh6y2UhPN6vNLU+igeGCjFNxgLhUy+PXHvgCtlV35oKMcgJtgezQqDEhp2WNvjLjguYDdhFf2DhSI5Hk1yrHUB9xZ5lNqBoGmbJlxtYCcXCZXXUPP1jRXMFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=855/DLlKiFeNQS4YmjvpO65TksLfn0yaNoyWQZ7a/hY=;
 b=U0DY9SuN/rwGDUkVbNIboxNWRAW+XHJfrgezTbTd2xAEN6YxQtY3quXfLxCTf7uQLoaG0+YL3F3JRBAKKfkDGUJfW8Zm1K7wJvMIi8ePjZdESdFI9bBKaWbXReRqexm7ra/aa4hwPVCwW//yLnMfNrNZ0K+ErpA8HLnDRoLDl4mY5dJ1F7eYejVA5X44t7JeGlHdZlJz4DaTk4I+FkSK8GcutV2N8bho2GoyRpaiIuv59ZWN2qqtiMBSgv61GE9yacvGeQoyRmu5ebcvq9VPivb5Q5WD4It7ERKi6SzUr9aWdUsPpxtoE244BFIKj4YisqwRAvt02VhsYJgCq1DYPA==
Received: from BN9PR03CA0962.namprd03.prod.outlook.com (2603:10b6:408:109::7)
 by SJ2PR12MB8183.namprd12.prod.outlook.com (2603:10b6:a03:4f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Fri, 2 Jun
 2023 16:20:43 +0000
Received: from BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::db) by BN9PR03CA0962.outlook.office365.com
 (2603:10b6:408:109::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26 via Frontend
 Transport; Fri, 2 Jun 2023 16:20:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT071.mail.protection.outlook.com (10.13.177.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.24 via Frontend Transport; Fri, 2 Jun 2023 16:20:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:26 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:24 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw, selftests: Cleanups
Date: Fri, 2 Jun 2023 18:20:04 +0200
Message-ID: <cover.1685720841.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT071:EE_|SJ2PR12MB8183:EE_
X-MS-Office365-Filtering-Correlation-Id: 00b21503-61aa-4789-a052-08db6385503f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WcZdHfIwFFTVW2P5Wz+uCP51YawKOKpGH+8Y8KFpnP17V4P3Bn0D7kvDoFx0C+Rleww8zVDNMr38+xgN159jwGGkCblDmquLaFTKrW2QAGyfyoei/3v/GkSZzRNe0rbGvkg9zcQmgia6WpYb3r42ZECzE2W6+dAUYJOjxSgLUebVd0UtmG++jpuhZ7rf5CUaUiYNQuCKRyiTp2VtPWduFk3IeKpmMVNau6Ak4T5MfZJUAPr3mixGCxVjSiwyz23xz7aE+yH0gpEBuLVtjx7yZZPATJgNhW7DcN1NdCykY1/mVGL7tqF+7AiVw+9dwxnOrNCthnO+/cjMh+4+Pzihor+MFZ7Q1AWB8k3GcQOEjnRz7Sm8VPTjM+55xNiD9AuAAz5CmtlkSOet3qerXacS/d2PQuZu6c+fXG/Q5lvWaD0ldPk6BntpVlOdecM4+sKxU0u0EDkb2tenWQaCBWRgd5wVkFyr8Pq+h3XELXM8p+81mBI9QcpXucZRG2lm/eDQEEe25jjm2Z70Mx6wpylWWjDEdvrh7yJyoouzzXdk5sddOltm/45VGozHQlQfGVDap+0yXvSXgo9C5iUFxYQF/Q7mSnJbQ8QsndBbRDODUnxnC7d5BVdzFeQ9D2hxYfteR7THMSJmQC3V0UIOpjM3DarQjFm7QXfRc6sq/+VLJoLPZ1Kcpd6C4dWRdru53Qm/fZpo2ztTHLYd7uGPL5KBLsPT7eQLRo/+8rzf6DOtpbrZv3BX+y66V8WDGfeVJpjL
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(36840700001)(40470700004)(46966006)(54906003)(110136005)(8676002)(8936002)(4326008)(2906002)(70586007)(70206006)(478600001)(41300700001)(5660300002)(316002)(86362001)(107886003)(40460700003)(6666004)(26005)(356005)(40480700001)(186003)(16526019)(83380400001)(47076005)(336012)(36756003)(66574015)(7636003)(82740400003)(82310400005)(36860700001)(2616005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:20:42.9173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00b21503-61aa-4789-a052-08db6385503f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8183
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patchset consolidates a number of disparate items that can all be
considered cleanups. They are all related to mlxsw in that they are
directly in mlxsw code, or in selftests that mlxsw heavily uses.

- patch #1 fixes a comment, patch #2 propagates an extack

- patches #3 and #4 tweak several loops to query a resource once and cache
  in a local variable instead of querying on each iteration

- patches #5 and #6 fix selftest diagrams, and #7 adds a missing diagram
  into an existing test

- patch #8 disables a PVID on a bridge in a selftest that should not need
  said PVID

Petr Machata (8):
  mlxsw: spectrum_router: Clarify a comment
  mlxsw: spectrum_router: Use extack in
    mlxsw_sp~_rif_ipip_lb_configure()
  mlxsw: spectrum_router: Do not query MAX_RIFS on each iteration
  mlxsw: spectrum_router: Do not query MAX_VRS on each iteration
  selftests: mlxsw: ingress_rif_conf_1d: Fix the diagram
  selftests: mlxsw: egress_vid_classification: Fix the diagram
  selftests: router_bridge_vlan: Add a diagram
  selftests: router_bridge_vlan: Set vlan_default_pvid 0 on the bridge

 .../ethernet/mellanox/mlxsw/spectrum_router.c | 26 ++++++++++++-------
 .../net/mlxsw/egress_vid_classification.sh    |  5 ++--
 .../drivers/net/mlxsw/ingress_rif_conf_1d.sh  |  5 ++--
 .../net/forwarding/router_bridge_vlan.sh      | 24 ++++++++++++++++-
 4 files changed, 43 insertions(+), 17 deletions(-)

-- 
2.40.1


