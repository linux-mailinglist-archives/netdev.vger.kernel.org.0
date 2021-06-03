Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB6639A531
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhFCQCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:02:47 -0400
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:44705
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229576AbhFCQCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:02:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRHhXFTKS6efXOb6b5YYzCDVOcCmd2Huo13f8bP0mzhb/JkK28ZeroYXufhjPvpgILbWtNiKQLVAhMQ73XJg7c30You0sXl1//qDbIxiP0eHprUsZbOFOrG5Dh8KmpYHEv2y8T1zRbo15fXtPXb57lB7LVcKMOTjWpHdvAK5GRGijcaO2aTUpzjk2DSVzNuT2EMkJKU2iUMqcf5flbwBg/3st0DBcZV7uKFyvCeK4z/p0neuSEtqaSghEqe+Rc3+NQGKCbziHm6Yv633aKVC8yS1nXBhdGgb7f8QFi35kN/H/a0Av2aIPV+8YvKssVr9K8lmFPoedgMOxF8YeqnxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9SHKqW22odMtPcKSbqnqIAGjCh1UrhRBnWn0U4wwlY=;
 b=hwuOT7kiVzW2xuCo9de0ND3/A1xWVWs82fErctcjiMdyKSFKC1b2tVxTFHftoUOGmK0nu0aUJ6iVDsMlPtkmE16HZ1gHlmQsTyOOUAn1n9U848WY75rZosEYoI615avxpx7Zwh1tQn121tPcevMY/PqUQESrMRicwxI6W3xycjqY3z2Yvxo+nvG9M7Cm3IMawZgAIz4YcvcspJnyMveEG7YsIx2+aund0YuhDpn+Y9ksbUS8cTgq1nGoMf5YyIi19E/qIkhsE2DXMxSx9/tjh9cIDO8O5m1m+NFZYE7XuW5dOYSsHDLGbW/QzIcctAB+Vnlw/0uq93h9jmNkaur0Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9SHKqW22odMtPcKSbqnqIAGjCh1UrhRBnWn0U4wwlY=;
 b=QNEHBexUdJ4IdfukCtjp3O66H5OLiiZ/JDslDL57sTpp4DG5sjkQD3gNQwZoAyd+mgF+i+tTGcpyw2iZW6zCT5IhtL44gJ+LGksRkfsvKPs8ct/YJagArX7cTKJegpafYqx6M7idGLxEx0478GbU/GugMRLFf/jDi9z7/KCVNEoBT7zCi7uPmUfVLS3nPpfwXw3IBa9SWZ0mwzj+yW5tacG4s9VOxNrUF92q/fJNE2NLcrkxzH2IJXRWd5BPDTVHFIRdlNLCN9oIxv3bvY9q2POiQQ01t3Vixt3D/ZCoA4g2u4lzkqWZ165jNi3xiix1eGfPe7828EDYNnKjf4tXRw==
Received: from CO2PR04CA0199.namprd04.prod.outlook.com (2603:10b6:104:5::29)
 by BL0PR12MB2337.namprd12.prod.outlook.com (2603:10b6:207:45::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Thu, 3 Jun
 2021 16:01:00 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::b0) by CO2PR04CA0199.outlook.office365.com
 (2603:10b6:104:5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Thu, 3 Jun 2021 16:01:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:01:00 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:00:53 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [RESEND PATCH net v3 0/3] Fix IPsec crypto offloads with vxlan tunnel
Date:   Thu, 3 Jun 2021 19:00:42 +0300
Message-ID: <20210603160045.11805-1-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb1c09b4-a435-4485-f05b-08d926a8c855
X-MS-TrafficTypeDiagnostic: BL0PR12MB2337:
X-Microsoft-Antispam-PRVS: <BL0PR12MB23373CDC986B968555CA9133A23C9@BL0PR12MB2337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vEyK8m3KMbM/iET2s/WDcUpSldK7/OIHpTMh8CoAJNd8wgtj7EFWTRKMYGwt1r194x8lw9Yl655nBg8MJxY6JRUsCF+z2NPRIUiYEzElWZZWd7zMc5Kmv4lyErPHqTdbE4CkMJ2aOWvepiQJJ3VwS4p3+HxoxjUg2LZXhd5gaMyNefoaIJDTk945m8zuxKjvZByu/gF9oAscn8tL+Yy4uGo8LeMci0rBrZhqE5GKo4T92F6NQreP2MCJhB6ehl8B1IWekAVCTuUNA2oBdF/KHtbExtWOH6guhn4Neupyi0VIaa9BT8ihgpBtAPmV8dy/pVJlpkyODmJ2/wHGUiUScnOhX/2H3AOB3nfp8BJiCe1SmcUMzhpv7OQGyLnorPkZPUDi7+ecQzpb6ijHR5H+dW7pzGAuOELHDJt3bdXsjLGB8zcUoYKKmAGECStOEtg9PB34s6a8w+2wdTz5wk3+Br6coiU8aNLxCvcV+AAr1XkX0gUxBmts0mlgMKQLBBCNxosqVFMSzmQDb0KyrF9Dk48emkiXaFJrD5t8hg7s69aAvYq3RqLCLMgpv13m0TsQFv9+qFPoY7TrUwNtsin86dcmkczmy6ov/cmfEIHqffz1CMBaYzbV9HJtdCqbgPdnmwD13Ph2IzwMaHLgMOsK4PXJt6/OoUTeJEJQWXihkoU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(46966006)(36840700001)(5660300002)(8676002)(36756003)(26005)(6666004)(7636003)(426003)(107886003)(82310400003)(6916009)(36906005)(1076003)(16526019)(356005)(186003)(336012)(4326008)(316002)(47076005)(83380400001)(86362001)(82740400003)(2906002)(478600001)(8936002)(2616005)(36860700001)(70586007)(70206006)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:01:00.6022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1c09b4-a435-4485-f05b-08d926a8c855
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2337
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 -> v2:
  - Move inner_ipproto into xfrm_offload structure.
  - Fix static code analysis errors.
  - skip checking for skb->encapsulation to be more flexible for vendor

v2 -> v3:
  - Fix bug in patch 003 when checking for xo null pointer in mlx5e_ipsec_feature_check
  - Fix bug of accidentally commenting out memset in patch 003

This small series fixes ipsec TX offloads with vxlan overlay on top of
the offloaded ipsec packet, the driver (mlx5) was lacking such information
and the skb->encapsulation bit wasn't enough as indication to reach the
vxlan inner headers, as a solution we mark the tunnel in the offloaded
context of ipsec.

Huy Nguyen (3):
  net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
  net/xfrm: Add inner_ipproto into sec_path
  net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload

 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 65 ++++++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 37 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 ++-
 include/net/xfrm.h                            |  1 +
 net/xfrm/xfrm_output.c                        | 44 ++++++++++++-
 5 files changed, 127 insertions(+), 28 deletions(-)

-- 
2.24.1

