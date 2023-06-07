Return-Path: <netdev+bounces-8832-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEAE7725ECA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:20:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23736280E99
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5256434449;
	Wed,  7 Jun 2023 12:19:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A3713AD6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 12:19:56 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675681BDA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 05:19:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xo2oisM0Lvtyv0XLAG9fH3MDvvOyYTOAEYfEmBMrrbXlSaIcj40NB2V1Z8J+iVPhx6e9tKPd3T6h0TqdCi4WVIP8avxckwdBwJrd4ZEpceoYpxXoZFacdNIEnB7uwz9hf4pJqYtjvjDLclL53qpArPZ6N5CZl3t98Sh2YvDq2uCxLiJJO8LHcMdJuFhIyitKWp/CC8U+giYDSglSIh/M7Th2GMd7E//caPWGeEIP48iEaUmI7/3kFYu8pdEX8Jkf70mBi8wX1lJadom1sj9uBrN3OdFhyRwYdBHr+zIWuVWoWy1PaI2vVAao7Nuzp+WhtFprml+EiiChbIloiRjE0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epaZqlHTbNQRLV7YIGT2kn2vfMuaAR+HSdphXI3lvk4=;
 b=CaperRbtXKOf0OIgCqLTRQeUmggvo6eQ6KUjiuUEvZWALYbzwD6OHRNbmcud/76M8MFu9kkY+XHgR2UGRhusvzC+WBoEW5qwAfPHULhzoLMH8OlLAgXaUmWaAts84LP6xK2LVl5QpP1TNlzFfFt2gdqBYVpfwoKFuOsTaMS2Eyf3iq2RqA/dr/bJm+GD9NtmMOVQrnYnM405US67JncMeqZdhaTNlEd5pVWS4cnmeP2GB6XGuaVryawKEKAwGPSpONyco1cG/ktTKs4aG+YIWjAGtNZORmqZrgJIMCSBA3KK2k5D93aQKh1v3ZcuHJpYTZdCA+fFc2DNvc9EanGJsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epaZqlHTbNQRLV7YIGT2kn2vfMuaAR+HSdphXI3lvk4=;
 b=LfXZV+xqhlxirb/2GJWuO95+y8WmgZ7+IIDq8nkIt3biFteaEtv3r4TcYP6Rd30SgM8ehN1424Ny3WG5MUwdG0A0aeZyZsDojeyQb5jf7mC18CMdDO57nxSNo38Q5rPN95yL3vp2D+ZTyki/1QhhWbOELpjxQW2u3iW1f2JG2T/1UJ3kxdX4w0Tp/hwHpnb9Vwy9mu/GtSUndetyWFlO/Pl8NfVRw0IzJKpPUWE/UNcWKkhxdtQm7hXKeD9clg1zrlqN5x2ryv+MPTArDu+2zlMIritk0Rxdi4Z5wW1ZLD9dGds5hX8iDNTC0z/E8bMr1EFoBkeKaxJznAreUE9e0w==
Received: from BN6PR17CA0055.namprd17.prod.outlook.com (2603:10b6:405:75::44)
 by DS0PR12MB6655.namprd12.prod.outlook.com (2603:10b6:8:d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Wed, 7 Jun
 2023 12:19:52 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::f4) by BN6PR17CA0055.outlook.office365.com
 (2603:10b6:405:75::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Wed, 7 Jun 2023 12:19:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.24 via Frontend Transport; Wed, 7 Jun 2023 12:19:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 7 Jun 2023
 05:19:40 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 7 Jun 2023 05:19:38 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	Vladimir Nikishkin <vladimir@nikishkin.pw>, <mlxsw@nvidia.com>
Subject: [PATCH net-next] mlxsw: spectrum_nve_vxlan: Fix unsupported flag regression
Date: Wed, 7 Jun 2023 14:19:26 +0200
Message-ID: <5533e63643bf719bbe286fef60f749c9cad35005.1686139716.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|DS0PR12MB6655:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ced67f-8e3a-42e9-0ddd-08db67517e81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nhGtDmj9tjb/JsRjdMdJHtf4PxjVCYhYrhHlMJLvu+41PSArdKnKoylTqlIymYWPO7PpyJ+30zDvhFO8K46VY5rG8zv+jZgjBV8Qrz5p7Igw7++RIYDFWAXSFdQdTmEVcCLUF6RD9wVmjogKx9Y4iJ5hBE9qlEjniSlWPl/9VrdLJ6tlBSHsTmO3HbIrNsKLa04+fivuTvl7eJErOPGmIP+8Vg8Ni0TUYWared4/syfk2oscC+pKGlN8VwMYsmhIefRURz0QDCNC3Ys6zVCIw5QsG4VPlCJbvAFrRX3kGLExl30iIgBWd1MKxgJ5DI9bTJUxGpW48coqvzyj1Kbg46G1metB22BCloUowFvKhH28J2jCX/olubSBdESPUJVqtSqOZ253TynSOxwWMSnd+sCHjKvP2G+WeRyT8xdkhxf57ZZP9LcUb3f1LI4Nq+xTioyjzKLCA8wDtYjl6tigTzRFsmjbf1XzbrSeQlfp/Vvr1od8f8hsS4Onwleji5zwMEp3S6abRcRONZf/iiON/LMINkevJv5NHONga9MvS9+ztrqjRZ53fh2TTeoLiH9KrZg15CcniHuw0gixeoSVz++C3EOFhuWO/Ir7NB6EsIAeW7+NKxD/fnm+oAo7vApmLBzHRzbzWz1rDM0rXzZaI6Z9GrkQctziabkmpvWLtS9W1gw4BVjmfnNS7bky1TroYpqABKA+QIevI3XRQuGGpxjz+p5HLIiyZZCNc/U8FOGBATvWQj8z648CJVNfmN+U
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199021)(36840700001)(40470700004)(46966006)(36756003)(40480700001)(26005)(82310400005)(16526019)(41300700001)(186003)(107886003)(5660300002)(426003)(83380400001)(336012)(2616005)(8676002)(8936002)(110136005)(54906003)(478600001)(70586007)(70206006)(4326008)(316002)(6666004)(7696005)(7636003)(356005)(82740400003)(2906002)(86362001)(36860700001)(47076005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 12:19:51.3268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ced67f-8e3a-42e9-0ddd-08db67517e81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6655
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Ido Schimmel <idosch@nvidia.com>

The recently added 'VXLAN_F_LOCALBYPASS' flag is set by default on VXLAN
devices and denotes a behavior that is irrelevant for the hardware data
path. Add it to the lists of IPv4 and IPv6 supported flags to avoid
rejecting offload of VXLAN devices which have this flag set.

Fixes: 69474a8a5837 ("net: vxlan: Add nolocalbypass option to vxlan.")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index d309b77a0194..bb8eeb86edf7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -11,10 +11,12 @@
 #include "spectrum_nve.h"
 
 #define MLXSW_SP_NVE_VXLAN_IPV4_SUPPORTED_FLAGS (VXLAN_F_UDP_ZERO_CSUM_TX | \
-						 VXLAN_F_LEARN)
+						 VXLAN_F_LEARN | \
+						 VXLAN_F_LOCALBYPASS)
 #define MLXSW_SP_NVE_VXLAN_IPV6_SUPPORTED_FLAGS (VXLAN_F_IPV6 | \
 						 VXLAN_F_UDP_ZERO_CSUM6_TX | \
-						 VXLAN_F_UDP_ZERO_CSUM6_RX)
+						 VXLAN_F_UDP_ZERO_CSUM6_RX | \
+						 VXLAN_F_LOCALBYPASS)
 
 static bool mlxsw_sp_nve_vxlan_ipv4_flags_check(const struct vxlan_config *cfg,
 						struct netlink_ext_ack *extack)
-- 
2.40.1


