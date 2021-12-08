Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFE646CDF8
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244353AbhLHHEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:04:01 -0500
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:33888
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244348AbhLHHEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 02:04:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=McJak/Kgiqup8HrOLFI9xTSCD0uqDl/qJQDX1hM8M6C3egkfjReLE7chyKivtznNsHEof4fbykRFJUbeAbbDK5IpOTO9DV0QDVSUn6y2bHRjfMwkCmeKRqnhm71/MrlfXoMQKAt98oMvCxiItmrbCKpGqqTb5YQKT4O+YMJCDfyfOolCnkx0K+5IMnBB19xxzut+YVhRZiuwUzBaOSBy8SeKTuWAWr/jv6XtcFwm8xbrV9jPS7WubW2TaZ/embJzkPCnOS/0jiu3P6/LkwWC4o0oaOKx8Sg1qb60tgw7EaGuYwBap05jOoAQGRDmInhK8wlIvPM2e8eV8HA9Cv/ZKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mRpiD9iEwdPEee1w9/LeEXVE6/M32STaor+Nb38Q464=;
 b=fKHTQqnOIRPigbuPkRZTTVi8tpdSEPaUQImAhVudJhSi3mvpmEPBSoC5ipIw3nl2UVj8WOFiMLzSV82jmAxUXjb+t8iPk01hPhkq941XJxQDQLS/EWT51YE4uHT7NGjWM5Uki3YhWHbXK4rANuggn8ltG1j4D8g7FNxumc8y6kcNlNqLSFFdV+pwfiI96Xqs/xS7sBHvrLD2hvDHxDB1iNKP35Os1eG9xNoOH3beA2m1PAuHhIAqiaSddG3fIRHoCjnmRCWlkRRAJixE5KdNDszO74XrK4EkCC1RJitYeb/Med0AC13TKZpw/v73zXH2ewkgZIVGkcZFNhMK0OW+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mRpiD9iEwdPEee1w9/LeEXVE6/M32STaor+Nb38Q464=;
 b=SERJWBaDvETiMkCDDzQG73K3ieFGiuJsraIjiH5d9ftTCb+fPAmR5Ne1oV3hGdT+obczjbQhpmUKTCxfJ2lWWM0yMKkXAsemQikdBKxhnE48nt6KnuF/ZpCNMghFjD7kf6LY1ao8BXSGPh4Tk3SVOQBfpRVOJktUTzgSST2YXtd0iLD98KhNjsIP+5/gv/e51ik1n765u3/fJO0tX1sS6kKdVF/k03KtXpfHvTfkc6A4KSpFmxu/HPFRA6T3lExhyoGva4q5MMMO7zjJ6xRwuHBLoEZlcPdGJmy4EzUOrNQEeIXYjJYFs5fXfXWFespr862NKOkatfLa2zEg5f72Mg==
Received: from DM5PR11CA0011.namprd11.prod.outlook.com (2603:10b6:3:115::21)
 by MN2PR12MB3824.namprd12.prod.outlook.com (2603:10b6:208:16a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Wed, 8 Dec
 2021 07:00:27 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::f4) by DM5PR11CA0011.outlook.office365.com
 (2603:10b6:3:115::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Wed, 8 Dec 2021 07:00:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 07:00:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 07:00:20 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 7 Dec 2021 23:00:16 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next v2 0/6] net/mlx5: Memory optimizations
Date:   Wed, 8 Dec 2021 09:00:00 +0200
Message-ID: <20211208070006.13100-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c06a730-3b08-41dc-be64-08d9ba186a6a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3824:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3824CD9F6EB64B57B0199CE9CF6F9@MN2PR12MB3824.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ic2kf/Lt1ksKobbezHgycgMM/vtDj8cVnizePWgCqlSOT3CXcBGVR4TF3GFA6+gWNOLkHkQiTkLsNbvi+U7K3SIsE/XDoBdEpcD2MD6SQYVlyyQnMAqB1JN8Ofd4mUoRlKuIguGwEv0mt4ydUOKzToJUd68fSyojS+gN2E76XkRAHxUm3HwtiIS6G787yODiSJOynLKKlUgYYjTbbXF5YIa9PuH7cJrqWxN73oMPwJIde300AQWkRn0C8H5MimNRLD1DCedS8/ww+JdA5DZ6Og0eKEfWKyKQNlTwTEz3UAz2QhnkKhEIKsTxxZhKh7XbXQkF4tmigjMuupY9qlzcsfin/lIJHTEIdOzlvdb8IqLYBGE5kQfZ8TSLQdWlZy8kHEB5Q3ihmgmQHQJ+Qq7C8FSf56/OTqiugeArvdbbbSh4RmMY3puuqshpuRWFKUF+uLIrCM4nBEDABTwjr4k8fK1B0UgO5/xU6LZhxSye8am6X6tI+QlEwVeyIeJYSKXw6KRAJb9e/Ov1S8wPhDwBVw7LYk+h01NV/EPiWg2dvEeRHoamwFQj56TPD39c0IIra11quvVNganvQnjp5PymExD2yYiwdHoyQmXCIFjXSktg1y0+j5vPpyR6IAB0ATvySgM2SAnZdnFoPh+/1i+JjyVYQCJtA/oUZhHocI2Tlooyf77/3if9YppFLy0+46ao89jAVhifkIv45qcYUmarCCm/q+JGOe6ldBuNos+5gcy5IyLEw45y8P2FqNWzUD52N282o32Bgh/F2aY0RQ4TlqxMMZjfpAMLHbyV9dkMtnw=
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(356005)(70586007)(426003)(2906002)(336012)(186003)(16526019)(1076003)(70206006)(7636003)(2616005)(110136005)(83380400001)(54906003)(86362001)(6666004)(8676002)(36860700001)(82310400004)(26005)(34070700002)(508600001)(36756003)(4326008)(5660300002)(40460700001)(107886003)(8936002)(316002)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 07:00:27.2466
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c06a730-3b08-41dc-be64-08d9ba186a6a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3824
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides knobs which will enable users to
minimize memory consumption of mlx5 Functions (PF/VF/SF).
mlx5 exposes two new generic devlink params for EQ size
configuration and uses devlink generic param max_macs.

Patches summary:
 - Patches-1-2 Provides I/O EQ size param which enables to save
   up to 128KB.
 - Patches-3-4 Provides event EQ size param which enables to save
   up to 512KB.
 - Patch-5 Clarify max_macs param.
 - Patch-6 Provides max_macs param which enables to save up to 70KB

In total, this series can save up to 700KB per Function.

---
changelog:
v1->v2:
- convert io_eq_size and event_eq_size from devlink_resources to
  generic devlink_params

Shay Drory (6):
  devlink: Add new "io_eq_size" generic device param
  net/mlx5: Let user configure io_eq_size param
  devlink: Add new "event_eq_size" generic device param
  net/mlx5: Let user configure event_eq_size param
  devlink: Clarifies max_macs generic devlink param
  net/mlx5: Let user configure max_macs generic param

 .../networking/devlink/devlink-params.rst     | 12 ++-
 Documentation/networking/devlink/mlx5.rst     | 10 +++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 88 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 34 ++++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 18 ++++
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 include/net/devlink.h                         |  8 ++
 net/core/devlink.c                            | 10 +++
 8 files changed, 177 insertions(+), 5 deletions(-)

-- 
2.21.3

