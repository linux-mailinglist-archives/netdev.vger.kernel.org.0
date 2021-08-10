Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA75C3E5B72
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241474AbhHJNZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:26 -0400
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:1953
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241368AbhHJNZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBZdjPPfgow8/pY94SdSAE3SBhidaj7I5CV1WB0ZSxtlCIyfc45wzLQ9SdtllugSc5yl+IPWr4eJ/bGGScKmpECeFPWCrwrRzPaU+n3a4xbm3zjnKwYGq0/DOde2j4H+Kg8e55L3yJ8cveyG+fSrmkrqgM7lhXvSiCZxjARsvjWsXIbz3GAFpBbiVUOOqBif1vfEp8JLurp+rtbsEa274FcM356tJNWtrt57cNqJVn+YHsbD/snwDg1DseYQFz/meG+uVIISDKLHlDcSd7Xtc2fdcJmOn6xv4pG6Q+X4I83pRCIRfHi+oU0KX6gcSSO8gMdxoD9MfwMPSTlKjjDlow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXr1xJ9xsuCjzTyvW2827Y7vv2eBERDsEbuANeR9gAM=;
 b=Pm3onmCEh5QVojiK54VEdc0VegON62huV+aN8bXZLyYIsiBkcGCVoL0QPhOqO8O3c9Bndy8vbdXwGhtMlrpeiaSTgyTzrjA3XMp43Ma7Nu1RSoqLtP37/7vbH5QGW6m/Hts77kPypC1j0P2/H2Ax1HiasWGKWiTfiuQcBaEJyIJZeMQhTMSIqd0U58gCSYupndoYz/u8ja3gJkieB45IIxabv1jL0tFVH4ANGOKiycLEA+cUnf71n/ENs/LefCO8dy/7Qpb52BQx94Cdflg6ryQmGYLGKXZiP5i9i/bBEUp8KhdUX4deqhz7Gm8WwuGTG6rsfLrk82ETuprO9mPeZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXr1xJ9xsuCjzTyvW2827Y7vv2eBERDsEbuANeR9gAM=;
 b=h3zbk/k0F/32+3AhXtPPYI6yhEPLqGMVD8fusqfpgqZKu+FWF2ldwkJ6jjka+tytCMJ5fsi6NNdskdEyroqWX5oI+0vWh3lnTTbKWE3MOsfoW2c4gsHey9LDUZeHgBBN4jPKyirVMvWMx59HlzJy9PmM6N9qgR4vfPXv6Vhd4HX3q+w7917l+O0ITGwarHDKaeVbhhj23SpakKbp4wo2t3kuL/p1h3Pd63ULQJmDdKO5vW+UhvwjOXEdBIvsStCaM9iRrv5or4owSYOX978pcJCGuEqakR3N1YcT4epirOUGvPwMxiCHnkTS99+Y9M3qneXrn0zJgXRUgVqZYaQoAw==
Received: from MW4PR03CA0006.namprd03.prod.outlook.com (2603:10b6:303:8f::11)
 by MN2PR12MB3069.namprd12.prod.outlook.com (2603:10b6:208:c4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.22; Tue, 10 Aug
 2021 13:24:45 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::1d) by MW4PR03CA0006.outlook.office365.com
 (2603:10b6:303:8f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend
 Transport; Tue, 10 Aug 2021 13:24:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 13:24:45 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 13:24:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-rdma@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Leon Romanovsky" <leonro@nvidia.com>
Subject: [PATCH RESEND net-next 07/10] net/mlx5: Fix unpublish devlink parameters
Date:   Tue, 10 Aug 2021 16:24:21 +0300
Message-ID: <20210810132424.9129-8-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810132424.9129-1-parav@nvidia.com>
References: <20210810132424.9129-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1929131-8f2d-4c7e-a662-08d95c02385d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3069:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3069B710F2C40B2940BB5B2BDCF79@MN2PR12MB3069.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O3lAjaEKcnVZXqrfT2JkPllg1cHT69KjV2l0/z3h4B9UhfmfA4IqjTBMDvS9jPSRr+SJdxNSkPOF7oep/Uw2Drlyd/MnVa5r8vOStUIrwZpNMqtaVfhSji9UooYMTdKOSo5JhTURkAIsSkCKZXwcUb4gIpvapW98wmjUCLo3x9dq8M41KdJqgdGAMHDvvvYv0yyFXEYIXba4kdO74NuENe7akVcgz4WdjMagTaSIxPP3eqaYkl13a06XYkvGJPr8P7dr+b24Z5fjGcHg6dV0pTo8g2E/3Tp/mC2DCfmU802OE9mlGFSItF1uIJAwM4am/xc+mFf0V1bZ5iG8DJWvL9otrFUdv5gQMdmZCjsR7DA4yaqWsO4zox3VLGYwalhrqRSTnHTG7vjlXn1x9opJ5UTJZ+8iVn8Zl8/v9jMjMpXQJs8FmxmW5dixKzGMfGdsP9geZAiAs98CwRgALPcRdM9IkEJujHvSQU8I+1ZEmqWaLMYis7E00MFNLATCL0Pe+7iUOtVk+G2SNy4X+DkpSryVfVwKyyoNF4PjM71s+zrZeQY79NUMuY7wk1VPS5riDl4bbIqRoe5Dr9/LLIGeZwcNiN0lrLkAoLL/gsa3ZAs709zrK/LzUoE0zMktf093fjE2yUTOWzVcEnaJcSpw/qvcyuw2GMaVSAsWb6ZBhU0iQ4j6gsOsJKmk76K6BLvzdM7i2NfdwRiJ5Re/E9s/wA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(82310400003)(107886003)(86362001)(36906005)(110136005)(2616005)(316002)(54906003)(426003)(6666004)(36756003)(5660300002)(356005)(70586007)(70206006)(1076003)(36860700001)(2906002)(8936002)(508600001)(4326008)(16526019)(336012)(8676002)(47076005)(186003)(4744005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:24:45.3947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1929131-8f2d-4c7e-a662-08d95c02385d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cleanup routine missed to unpublish the parameters. Add it.

Fixes: e890acd5ff18 ("net/mlx5: Add devlink flow_steering_mode parameter")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index f38553ff538b..0ec446d0fd6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -671,6 +671,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_traps_unregister(devlink);
+	devlink_params_unpublish(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
-- 
2.26.2

