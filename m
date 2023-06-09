Return-Path: <netdev+bounces-9633-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1F472A143
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8FA42819C6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C3D1D2BE;
	Fri,  9 Jun 2023 17:33:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BD619E52
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:02 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D812EE4E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZSZ3ne6iTnrT9k2Lrhlq4pruJTGB3UgSpdJw3srrzPGuYIZmlg8jUhnFCyFZxHXXjaxXpVV8ePQU3xoQ4sTLalvhS930jd6Fhji+3znHslT/WtC37jD/7oAjvjEiP16Mcz2WWkmhqHAY8YQk5OFx6KKDQYOo/qpuEIkq36nhDQ3jLcUiVJSO/hJsLTo2vhP9G9QEnGeZIHqaHIwPVlSD8eHlaESekOALX2EpBe1aBt9VmcvVc6BQrytmtKhtSrqk/SHaAGubl2W2mOdXakI1+gb1lHh+uXya6kRG9k/uWBbreFyYxr653N1+T3WZAX+p5d7NHZir7rAmAHPBr7exQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NhuKfyTt8tU1PqInX8nPourkDNNowskeLnt1mVmINJ8=;
 b=SVTBUm4mS8uYln38ApnAJhlABqv3vvuD+VLouzMXfNf0Yg/SDlwy7F2w0VACiUCU0zCW/VJoIGc6Ik1SnpX5wlAuj1N9e5/ayuEmLFz05S1jO68Sp+v0lLkhTRr9uH9fn1S/BwIH7Z0YEYltZts2U5vTvRsDK2g5LWtpdw5hqlos9yGUBMhrhEZtSjwDcSnRoHqOugLmAyRoF9+nAI304pdUdHzDDs3OXcPJU6Ifhe3gKB6dx99N0m/5Cbg3e8v6rhiCXq9cm0ifzNgts3ff/kedX11stbOl6Jwy8V52AROGA7P4EY85V3gYEXB90xaGGPr6XTbHiX5VTy4E9JS86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhuKfyTt8tU1PqInX8nPourkDNNowskeLnt1mVmINJ8=;
 b=aN2y5rM5DlaYto45gIuMFVfYEHU1Q89YFpA4UO9ywyZo/KlQ2u53yDUrjSm2J9wbIGTw5GLfx+cY7JNRsLK3Z1TvA2WiyIIej5J0mvOJj6A3THvBuMitRKmOmBp1GrWSACta+xOPeJp6tWBRyhwFd6RXgaQca+sP+Z6tVzSXSVuDnV/yfibnhlVjsgaVh+Tl9dwoTIpd7oFyAP8ctiW1co3nP8BmNd3LNpFaROYRI27adfagi7n+vng64H58x5JQV0W7VUNvrwR8QgBwDic+DgTv+qr3nNpjzau07BeEGcsWYekNrULuC5Ax4EEapYVmZ9cWHYz0SjR8BqVAo8XQ8g==
Received: from DM5PR08CA0031.namprd08.prod.outlook.com (2603:10b6:4:60::20) by
 SJ0PR12MB7005.namprd12.prod.outlook.com (2603:10b6:a03:486::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Fri, 9 Jun
 2023 17:32:58 +0000
Received: from CY4PEPF0000E9D9.namprd05.prod.outlook.com
 (2603:10b6:4:60:cafe::59) by DM5PR08CA0031.outlook.office365.com
 (2603:10b6:4:60::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.26 via Frontend
 Transport; Fri, 9 Jun 2023 17:32:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D9.mail.protection.outlook.com (10.167.241.77) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:32:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:32:41 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:38 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Cleanups in router code
Date: Fri, 9 Jun 2023 19:32:05 +0200
Message-ID: <cover.1686330238.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D9:EE_|SJ0PR12MB7005:EE_
X-MS-Office365-Filtering-Correlation-Id: a40a7f49-32ea-45b4-b146-08db690f90df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uc9wcf6PKvOaChWk3fgyHN49OGcGEEshmZ4z9GTib6wmFwcYSo9677LcnzUqBof/tkS+nhr6dZ7ZOt7uBGSReU4jetUwpERfGeLFyXtbMIXrA0RpmFxSQO+K2y3yAkWiu/0EBo5iLy/ExYcF7ZGXGQ4LcWp019B32YDtsZ+voFC3tE1VpabnObeqH+8QtjQ5YLDohJiX19qfKfkQnI8L4IJMQ5VbVDFNGHbv/kHhyA8Bnf32HLxhK/S3sjdENs2fy1s38UMAL+mCGfPfj/FBQVRz/OrOvBzTm8iItz9jto0gNIcoISlLmFbsXgu2Ns7VKXRX4wBl9AlVQTWCdgUbh71PexBKBf3RrahMfp0En11ONV3puNnnGwkEqGdsmKz3tDiSI+Mmnks469ZMQQuLLYQL9GDrMy1TDNLs9c8EajO/TUjNPPoxaCFrJGzT3+OKyZkF0gELgHH0FFfUSsM2GNJAbHhq+Fqx5qtvG5+MN3UIWXsRDwUSeFNZgqqngxd/d1XjkXbvmZeKp++a+db8DYqo1Xu35RFK8t/bSLRRBiY87E/aopKpsFXeYVG+rInUAPa9rC96wGZumdX8YrkpQhPZ/DNhyNcVWliZwwi/u/faftc1KuYQ8aPf/MmADnuxOzwv9k4LFY7k6ObDXG8HvX6TZ6cnrcZpfbIB3PlR1WNNGir1b/QnpSqwD8s0X5FD6A1guehz/6krX4TZl7aO9Wdt+EzJEdywzoVPW7yQ1ZuYpvI5Sea3WAlIzEjKYEEK
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(36756003)(86362001)(110136005)(478600001)(4326008)(54906003)(70586007)(70206006)(316002)(107886003)(40480700001)(356005)(8936002)(8676002)(41300700001)(2906002)(5660300002)(82310400005)(82740400003)(7636003)(2616005)(36860700001)(426003)(336012)(26005)(186003)(16526019)(47076005)(83380400001)(66574015)(6666004)(7696005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:32:57.7968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a40a7f49-32ea-45b4-b146-08db690f90df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7005
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patchset moves some router-related code from spectrum.c to
spectrum_router.c where it should be. It also simplifies handlers of
netevent notifications.

- Patch #1 caches router pointer in a dedicated variable. This obviates the
  need to access the same as mlxsw_sp->router, making lines shorter, and
  permitting a future patch to add code that fits within 80 character
  limit.

- Patch #2 moves IP / IPv6 validation notifier blocks from spectrum.c
  to spectrum_router, where the handlers are anyway.

- In patch #3, pass router pointer to scheduler of deferred work directly,
  instead of having it deduce it on its own.

- This makes the router pointer available in the handler function
  mlxsw_sp_router_netevent_event(), so in patch #4, use it directly,
  instead of finding it through mlxsw_sp_port.

- In patch #5, extend mlxsw_sp_router_schedule_work() so that the
  NETEVENT_NEIGH_UPDATE handler can use it directly instead of inlining
  equivalent code.

- In patches #6 and #7, add helpers for two common operations involving
  a backing netdev of a RIF. This makes it unnecessary for the function
  mlxsw_sp_rif_dev() to be visible outside of the router module, so in
  patch #8, hide it.

Petr Machata (8):
  mlxsw: spectrum_router: mlxsw_sp_router_fini(): Extract a helper
    variable
  mlxsw: spectrum_router: Move here inetaddr validator notifiers
  mlxsw: spectrum_router: Pass router to mlxsw_sp_router_schedule_work()
    directly
  mlxsw: spectrum_router: Use the available router pointer for netevent
    handling
  mlxsw: spectrum_router: Reuse work neighbor initialization in work
    scheduler
  mlxsw: Convert RIF-has-netdevice queries to a dedicated helper
  mlxsw: Convert does-RIF-have-this-netdev queries to a dedicated helper
  mlxsw: spectrum_router: Privatize mlxsw_sp_rif_dev()

 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  18 +--
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 -
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |   2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_mr.c |  19 ++-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 123 +++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   6 +-
 6 files changed, 90 insertions(+), 82 deletions(-)

-- 
2.40.1


