Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787D620A670
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404685AbgFYUNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:13:52 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:6061
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404386AbgFYUNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:13:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuBsHuLUgoPZGvdXt7d/kg9GyUDnJXwBmacjZIdjOvQUg4VTacPGoabqh68qgAN2HPP4SywtGCeGuHsN2exhuzMLEU59SVr3dYW0m6/2jsRuQ/K3o2XpSBXaoeQjcDuqK5joxEnhOGT7yVOTO4EFdwGmuFJ32FBtLlJ1kBa98w67UXe5ZxFRijcpzFBu/tyQ4RYHPSwaa6Q0jroHLMJbOyDdezwa+5SfR2Lokoag9qwRfRbIX7eObM+X1l1DcVuZrnUeNF7FXGGeuAHruaFfRQrZGyN3yrjfCP8xPmgLRRqemr5CesfW+UDFuFaBqZuJ9+iut74drHw2BA4bh3q/EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ymbmtiCcOaJbnJ64x5A13WRunfFFeb1fgYCFhgShBU=;
 b=TvS9S5yl8Yd4+HjAo82cqEVMwEzGkJK5+NyN1HU6eZ77UPhsSBQKAks4JqHvKgIMR/lFHVNvR14mcw6Kag75DcXMwhkKcXj9U+tdQjBDQ7hAerTbzkLYjHosXwIMBq6+UTxPhcQVm2CZMRf/lXxp3LPpYmUfMzAVKZx5kX2oQNLLuRymrxp93L5yu09QG8dlbt2aS2a3a9v/fUQYwf/4gsjT6UBz8UWETUSfi8YvP1UhD1cjeDpOmbhiLJrpn9Ix0po14ONZAY6eLvIDUg58vdWkKnVTIGSmrUw9wgeavmii1FjeAV5ZMPtjMizj2N0akiXaohATsLlRXl5kBun9vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ymbmtiCcOaJbnJ64x5A13WRunfFFeb1fgYCFhgShBU=;
 b=K+kt7IfRd9bE098n8uIHRuwg7rXoCvoBVFHl9Ztmzo+l4CYAjCOILLxz6+qMbj3yJfJJKkVwRBLncFlpBhwY+J7EjNjlvrPcR1xuGFwdWP+6pO+8bQqyTs4D9EvlvyB9tVIn4P2UgUTnGFAurYZtJ6yiT/N7g+5NeeBjBdoBkB8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:13:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:13:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V4 0/8] mlx5 updates 2020-06-23
Date:   Thu, 25 Jun 2020 13:13:21 -0700
Message-Id: <20200625201329.45679-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:13:45 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b867bafd-7acb-40f5-0749-08d81944446e
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2448A47A7522A788B30009C0BE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9iHMF7TFswJFTMSRRTnNd68xp2yxbKLrzF1EcQcYsQyf2UdxKYLPYPGuQIO8bWdnjuYB4P5wns0cKkrSlOHwmPqfuAALRk0a7qNhl15Pf7TKyuXDsZzVLyQDW4Dm66sBWSbs3CQbqTHLi17HAv4O5vgGHEb7PJ0G9qxmmqR0KgMeCpNmKmqn8z4ku+17jNVWvGGgEL4O3vMf30SDfRCxDeA6ndtISw6Euytd0QOZ8GU3uXpl88E8+2kG1G+TTJq0y5s94PebpgWf089YeeZDNg+rfqUvYMsN5FFO3dodve4IEWn/OzlmfSklREKlpaOJ01MeAp5Jwb6j4E63eBV681sUjqwjP2/WwruG7vnOX1U/uBVNMrTNdNVhOCDZ8FR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(4326008)(2616005)(6666004)(1076003)(316002)(956004)(66476007)(6506007)(15650500001)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HKU2r3JbQBANtJZZOKzd+/KK+nqst2cYRphcJR9VW9TMlqfsunVymtkJu36JdAtXjrrxPSJ0V127fEoAbkegrKAgUZOo54Z0jiPGIe5Jozy2Q/JfNF2INzy3ej6gf3htZ2xJqM80Y1HUxzZG+BpmJC9qiCh3oWZaDVHWjXvD1MrlGqvLlruZqrZ9bihQFWg5YIJyrpYGWJYIzAtqpMTT7apJqeQHEwkmB21jyj9WULKjRP7SoKwGDFKRNsK/elbTgGpPBnZiVkZZcPrmmbx9a7QQgb4QuK/GCfgivtUWTP4WsqF3xA/eLRLdyw/9ATd3c+XrmrzpFJx1wAvXzEkk2XqHsZrpWmteYGH3afSMcP2q3FhY6Apt8JY71BDCh8veMGJ1mWkXMFtG01viO3WWoxq7DWz6K9G9dCCjta0DfSIsC2ENKxTTAvJ1KS8ecolJGyeyi6KPevaOAwziOWXnkOonLuul0Pk/BalSOAfUzn8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b867bafd-7acb-40f5-0749-08d81944446e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:13:47.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IexgWlwjtrZy5CYgeqqXIO+ZDgm2P+mRk7XIzsL0TXXUh1SZCfUDZvSf9YHzJF8POfw62jSf/CDywJgA1adVrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub

This series adds misc cleanup and updates to mlx5 driver.

v1->v2:
 - Removed unnecessary Fixes Tags 

v2->v3:
 - Drop "macro undefine" patch, it has no value

v3->v4:
 - Drop the Relaxed ordering patch.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit d621d7703d510d222fa674254293ec48ca6ea709:

  net: enetc add tc flower offload flow metering policing action (2020-06-24 22:05:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-06-23

for you to fetch changes up to efbb974d8ead5106787144219cb240fdcebccc16:

  net/mlx5e: vxlan: Return bool instead of opaque ptr in port_lookup() (2020-06-25 12:41:46 -0700)

----------------------------------------------------------------
mlx5-updates-2020-06-23

1) Misc updates and cleanup
2) Use RCU instead of spinlock for vxlan table

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5e: Move including net/arp.h from en_rep.c to rep/neigh.c

Denis Efremov (1):
      net/mlx5: Use kfree(ft->g) in arfs_create_groups()

Hu Haowen (1):
      net/mlx5: FWTrace: Add missing space

Maxim Mikityanskiy (1):
      net/mlx5e: Remove unused mlx5e_xsk_first_unused_channel

Parav Pandit (1):
      net/mlx5: Avoid eswitch header inclusion in fs core layer

Saeed Mahameed (2):
      net/mlx5e: vxlan: Use RCU for vxlan table lookup
      net/mlx5e: vxlan: Return bool instead of opaque ptr in port_lookup()

Vlad Buslov (1):
      net/mlx5e: Move TC-specific function definitions into MLX5_CLS_ACT

 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  | 13 -----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |  2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    | 16 +++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  | 10 ----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 10 ++++
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    | 64 +++++++++-------------
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.h    |  5 +-
 12 files changed, 50 insertions(+), 77 deletions(-)
