Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40463A6911
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhFNOgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:36:07 -0400
Received: from mail-dm6nam11on2070.outbound.protection.outlook.com ([40.107.223.70]:51424
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232815AbhFNOgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 10:36:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjmEzTOZVbzcC4xoucjwpqXGW3BmT1BhidGOEU59QEp6dqL9AbHn7OJQh3RWU615VS9iPFyqyNIbUxafvTbbZ0QKk9Usoj1KBX+icIg3zNtt8OizUPBL6xZTp9GHhY6qzcFWSZ+6LpBULogUHFXd8n2il+iJl9i+9IL/9HqpXN9p1unXFpUsK2KDYlx9W1z1UVgA0Z2IhrnM9NFVWJwNIJSLC1BpvrfVGedf+v7DIxDOxIiLQn1iC1Vt7li6Ri/ej2MFZANBiRZuMDFBnmR/pPyOXPRvz8gMNx8EphCWkYKTaVxid4GDmTUea3cFPtniU92hFI6p/euZQl5z/IKpIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGKmpFa7AoziQZgck2OeBcQBhVFKj4jnR/jYm79VmKA=;
 b=dD9y7+KE4xcFq4vDuE2emmLqOb+NP4KoNtOZawSREBgej9KxhxYUILnbKbkotGgbwBMi9Dn9uiuPXiTGGR5GBoT0LDBQCfMljzvmpbN+/rBsObf30fhUfsL8wGMCmracBhrKqcxPomasBt5RrEge17vzbeJ5iNNYWjDvqZ4KKOIq5mqA19zSGMyruu1FGGAZ+BN+ew9Urz5x88up8wojD797escQ+UKsudIvfATaHI4DH1SQdRiahJRMQ0jSZ8vlzCEbYzxhIOYQ235M3f8AhkbsjsQ7A1vh8mVBlteDfZZ2yA+G4rBnJ9b5aVDl8xO2HNqG+MnVlVUT+6+8cmKNBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGKmpFa7AoziQZgck2OeBcQBhVFKj4jnR/jYm79VmKA=;
 b=ogwAU9gLBZ4z4T3Snw8/p7nZcFUzVL0Y7lOA0dUDBRR+HgiIkuLOGhNgWd0vk6QQVodZWzOVX/gplzFhgFpvPACCCLeFjQmpbb4xoXMf8gRZue4g+ILk0pBTuYKbA8aUiiA1fUaRXa1xsvpQHdS/MjWsd0xamEPIV3fhuf2Qj4KqkxGcETN2KVMREPUO1nVUl2+qwQ8W8u2DiIww0wFFnp03Zh9wNZMEC60bW5ctjxn5aEDLKcrdrlBBlUpqhVOvURZDc7vhKpJ+Mxz0yFr2qJCDZSmpZHrHyTvlFPnAnQIJkEyLX9quxPQZKh7x2SQO3PPMAkQze3vPcXFLkXJeMA==
Received: from CO2PR05CA0079.namprd05.prod.outlook.com (2603:10b6:102:2::47)
 by CH2PR12MB4873.namprd12.prod.outlook.com (2603:10b6:610:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Mon, 14 Jun
 2021 14:34:00 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::a) by CO2PR05CA0079.outlook.office365.com
 (2603:10b6:102:2::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Mon, 14 Jun 2021 14:34:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 14:34:00 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 14:33:59 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [PATCH net-next v5 0/3] Fix IPsec crypto offloads with vxlan tunnel
Date:   Mon, 14 Jun 2021 17:33:46 +0300
Message-ID: <20210614143349.74866-1-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 904796c6-8c0b-4b81-d506-08d92f417351
X-MS-TrafficTypeDiagnostic: CH2PR12MB4873:
X-Microsoft-Antispam-PRVS: <CH2PR12MB48736CBC59CD8961F2D564C4A2319@CH2PR12MB4873.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96G2bxQWbMchazilmPmeVo603IzDXF/Z0rslNY6IXEO0PN1agZyjN7bMwNmJdcvldwYgoQHjAoB6GS+JzTOt/0u03Lh7u0IflEUL260HeWWt/V4vuQgfW7+3FsXWQKydVL4b+9aah020t2ieyvzLJqWA1NKr/hN0tBIw6DYTVY87BAIuhWalpbv9PDY4dXHc+Tx//VvIi2Vx3/mkuwfJO2TA7gBU6gbW6c0hTHykqN1tVRdcoW/JCkwvnE9XLYcWrCXTfQYvOfyzwdVsbxJPleMENVTbkDIUxUtOMAf1sDpNPS2pQKrwwhIiHSvpIktTdM9TfRE8xcsm73efD718yrqclGz6rRxGqAhcjrLeio8K6XQRKDHs9LK6dGFhSnYYbG08MRFunLUgOWb8Bj+CC6BuQ7gUPj0YC4SzHTRrWF5esVUANWZXkvYd0UKrpPwPaETxB+endNz+3ATE/s/ABY34QIiNJvCkM7iXcucmfr4iAxY51CpqJZCjxbbDPcce991D8biNkKL89Qz/7FZFWiwXNxCejadaxbgTwB9i6C2Wlm4AVcYrLPYn/BX81uJrdqNsw2JxTts/uNCi+j9WlEfggsMvJlnn03R5+BYRpNiDEDP4mjN1LcwMPKzPwQwwFjVNZ9VM5VmIZPhj1OXcbCLBAgHMGPkdt2GHR7lidfI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(86362001)(498600001)(6916009)(36860700001)(8936002)(107886003)(7636003)(70206006)(82310400003)(356005)(54906003)(36906005)(83380400001)(1076003)(8676002)(2616005)(2906002)(426003)(186003)(70586007)(16526019)(26005)(5660300002)(336012)(4326008)(36756003)(6666004)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 14:34:00.2678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 904796c6-8c0b-4b81-d506-08d92f417351
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4873
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v4 -> v5:
  - Fix double initialization of xo in xfrm_get_inner_ipproto

v3 -> v4:
 - Check explicitly for skb->ecapsulation before calling xfrm_get_inner_ipproto.
 - Move patche set to net-next

v2 -> v3:
  - Fix bug in patch 003 when checking for xo null pointer in mlx5e_ipsec_feature_check
  - Fix bug of accidentally commenting out memset in patch 003

v1 -> v2:
  - Move inner_ipproto into xfrm_offload structure.
  - Fix static code analysis errors.
  - skip checking for skb->encapsulation to be more flexible for vendor

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
 net/xfrm/xfrm_output.c                        | 41 +++++++++++-
 5 files changed, 124 insertions(+), 28 deletions(-)

-- 
2.24.1

