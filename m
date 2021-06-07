Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D6739E618
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhFGSDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:03:17 -0400
Received: from mail-dm6nam12on2083.outbound.protection.outlook.com ([40.107.243.83]:58103
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230421AbhFGSDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 14:03:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gB4PRx1w6m/+YspNFwB044KeAYhk6YVatTYWOcIYa+NqQURi4YZTm9eOQ2oH0c5MVARgNxyrPeBMYbmXzvWbtMyzk+C5+QPwB6sTQV3tdmm7a75l6ERgMaUXpGe7K0VJ6NmV60gJpMkvkxeeKEcsCZGdPoDLwJl+ooEwsUI881kjEGfpIHqGRUoQI0bKBj73QA26ZQtaIHI2FOG1sbsS+JqVLNGNqdbE/EjuUBjN3AAj7wu+lYiyeiqE++TevfhOjBVlPOGymXyv1lpqrqlrX4aiMHu2wmo9dAlQ8jW1ujzPpFgvN3/mHRRdG4UYVS/S82G1++UJ/7DrwO/PaJCHGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89535AIlhFry1AebK/tN2Fw+g+SyJ/io1sT41c2eaPY=;
 b=ilsdJkliCPw1CcGwRAKpgXp3AM4AkbMERvpTKUnCafDWpu8UQVpUAooiS2B3InfkC+U+ZJG7jSkuxkemgvVtEXj/Zr2Qb7x5okbAWEFMpinGxiY6xP4n7ULSsuswTKNuMY9u+FetXcmVcBUmGCikPs+aBRy0LqAIv2RqmIHLakc0dG3V5Ib6WWr4zdEhwnjwD2NqYW9+5Ntvhcyt6IIGGVwI0HN/jxq87+13v407/jbcmbmY/P+GOSQrE03YyHqJRYdKEI6wR9b5xwNUgFT4wgm5sPKHoA9GhGYNK2fjtamZWJEndBfW4vbhaWqNyROINRGoBmLVSCHoBDLJvdjUyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89535AIlhFry1AebK/tN2Fw+g+SyJ/io1sT41c2eaPY=;
 b=g1ivb/LSfaMeVVrFGccGKGypKR+7E0YiNYtML4+3SsiaxrVRwFL7j0UHqIsyUrusukCNEUOlMnC9UXiXd3UefcILByLwDH6XWJSC+007ADOWuWbeKhfl9MYloftyieThBIoqkxJr+O54+4eN9qHvYx/NLJJvbScBRi8BUFY4x96E2jXV3MTXGGtrnXzFu2mPsGWEpJg6pNKEQasoz5WsFKee3wAfAGT8TF6kQMbxgwktWm+bAIcRDURUDIVKWDdKH3UdE0dUbZwf+fnfRNmQK+sYTH6JONs4cl4O91L5eFr4k26pir6+LVrDWcqCTK3MWvKyOG2oDOE2LhfHo9bcYg==
Received: from DM5PR21CA0037.namprd21.prod.outlook.com (2603:10b6:3:ed::23) by
 BN9PR12MB5051.namprd12.prod.outlook.com (2603:10b6:408:134::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 18:01:24 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::23) by DM5PR21CA0037.outlook.office365.com
 (2603:10b6:3:ed::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.4 via Frontend
 Transport; Mon, 7 Jun 2021 18:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 18:01:24 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 18:00:57 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [PATCH net-next v4 0/3] Fix IPsec crypto offloads with vxlan tunnel
Date:   Mon, 7 Jun 2021 21:00:43 +0300
Message-ID: <20210607180046.13212-1-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33575324-b456-41f7-d02a-08d929de4394
X-MS-TrafficTypeDiagnostic: BN9PR12MB5051:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5051DFA9716E3B90346B0D35A2389@BN9PR12MB5051.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VN7hlb27GV6M+j0mBtl9w0HqfHLcRVOz/tTWXMyi+vbXE0+0ZF12rH/lGDSOzq1bcRLNlBdcgEbWwOmV7q87lEucaz6YTim17QzlJqIQV6u2FavNp4I5CcKYhIhJ7bx+BX0NtaX2O6TziKZzbt9Pbu5uj289TIjHlcGM/8+DI/kiTmvIN2Ws83D6rzfB21z8+gHBFvl4+T/5Zrsb3KwU2/Ge16t10kByc0CkNvTZlqw4ZY/qnOkMoVIcypNkmoyMpkiH1Qq4qVU+XPkK3qeFqJ//C1rRo88m8quwysuXUj/ASfOTSWKtkD/ByiAA6EIdn6Iw/ac43Oo3xhlqJNy6C1UUlQarn6OsWIpZjp0ypHFtAbJ1EOo2Wcz+miPIJ6wl7Bv0HPJXjVqyiKXnDhwVyJ4hyMG1vLza2Es9ZXcuNpbt3QEfz1s40s05wVyfgRng/v+YZMs5ZlXvtF4yvQ5bHICA2Uu4Y8CFH4X4QUWGp3X8I36n9chdTk4oQ4cwS8P8o1DRfbvZSCyaaCgZf+NlFNMjYQTtV1AcxZsXiV48lchXPvDP8Drnp3ih9TUfw++PLHUoEbqaMPZM93QB4orcEGGCB8UEU2DNS0/cO0vEBEnyUHp5LAG6dV6PKELdhTjYxa5EgwJr+3+zcZ0XeiMcXvjt/zhmtbE/aW+4X36KBjI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(46966006)(36840700001)(107886003)(6916009)(356005)(1076003)(4326008)(83380400001)(47076005)(36906005)(5660300002)(82740400003)(86362001)(7636003)(426003)(70586007)(70206006)(8676002)(186003)(2616005)(26005)(16526019)(478600001)(6666004)(54906003)(82310400003)(2906002)(316002)(8936002)(36756003)(4744005)(336012)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 18:01:24.1971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33575324-b456-41f7-d02a-08d929de4394
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5051
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

v3 -> v4:
  - Check explicitly for skb->ecapsulation before calling xfrm_get_inner_ipproto.
  - Move patche set to net-next

Huy Nguyen (3):
  net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
  net/xfrm: Add inner_ipproto into sec_path
  net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload

 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 65 ++++++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 37 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 ++-
 include/net/xfrm.h                            |  1 +
 net/xfrm/xfrm_output.c                        | 42 +++++++++++-
 5 files changed, 125 insertions(+), 28 deletions(-)

-- 
2.24.1

