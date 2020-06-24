Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAF2206A02
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388160AbgFXCVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:12 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387794AbgFXCVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QetAAXbcKNcAY0HNbzcoA+Xi0/PoJnCoKi7qWvZpsDXFVjl54j97ESZM8iV/AUV8hMdmjZ6gxrlMDB4HGG+oO0HLGQmlTeoYmO0g3J7DdkZNxR2dTVA/b0piOjHQ1lGRUR6t6ydOva1+TgTQyCuQxALgKT18+x8mAru0a4CzYQkbYZqqYf2ErVJvcV35XxhWcMWKKdbYRqQN52evhtDaiEMlbzgYkWxb8oscMfB2UyS8pXsnhkkv1uZpmsiztEczyMmzka4CqwOZKLM//r9ljfgPy4FSpp0jCTf0Sch50Nfdejb52CoXQpcG5v7Z8ryCDiER4xoAw4kBQ/yOvDeLsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNaIVJao4pWO2w3ZASvulvY8XkOMHOiCRRsGAsqT4UU=;
 b=mG7zxrYYPbniNRzlRK5TEY4GDc2YQFQ6qQMekEP62afMuNUx+nIJArjddY/3nXQ8RZkd0oKJxs2hnTL5gN9yBM6WiBMzG2yEm69WcyiwVb8Yev750PHzbDCSv+bVhzrEFqO9iwnreyubHf/Mxw8FYUJLyiyVS7RScB3EtjklUlVzeF4bovzkOgLJk+ukIDubpxpzBssP7rd+JMYPAk1+OXR0EwIX8ROJxtwD8661trWRwKuugAT1aRbdmSMczxNGDCPOkZVIZFB1yUm6YTvbPEKa//vNIvP30wJbQq5d1pIcY5UzazFlmawQZhGXdRvpDnyvaHLhaWKY8qX+4fKU0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNaIVJao4pWO2w3ZASvulvY8XkOMHOiCRRsGAsqT4UU=;
 b=KEQJY/YdVNWzYRcL173vq+CMqTkBwEBCCcDGEPti9cycbHOFyLmo+WIjvYXa1bQnenkl3kNVNesS2UdWA7Cve+eC1kbSADh2kXLLUtJ1tK7araoerqIhtEkPNc/CEecg3eWvDid0ogYx9sETuOMPYOmk5qpn2+Li2y51CIE7raE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V2 00/10] mlx5 updates 2020-06-23
Date:   Tue, 23 Jun 2020 19:18:15 -0700
Message-Id: <20200624021825.53707-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:05 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 62df8746-9077-49e9-89cd-08d817e5409f
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7022682D823007BA0C87FE8EBE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9XuUYPDX3get097muJ3VQo87oU8XRJKzpWkpy1tl79xYa6sDF624D4Tz+nAmcfoW6vetDvCJqnXTkBHAkvBsz31YvXOlDAjq5sl2/I9MsYWwmjxER+Y9uK/PnbHnIOFJ1rGOGMEqUBcS5oNO4BU4Ru/LKTC2TNVovlYXBII0ez67taUqFx9JglKJZaxq0SSE2kd2Zr8HVzjE5gmuIBbir1vRRcke2RluEhg7iI/KtXEvKTaso0KMeHJgzrbSxCGx79hoDJghsXouccW18nMaogRhZE4kH13oF5jHukkANl15x9EOiSHIiWkJHpKBqMEsTrXowIBrif4ZpvjGZfNG67L7XrIIAqogwP1q1tQ0JEo22ivs708VqsZ6tfJOguVd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(6666004)(186003)(1076003)(26005)(15650500001)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gDMzNtZANK6ax1WHknMNaEDtfoZaGHiXBxK/VO5TQEdQatyRqMGSj9cbGML2vJSeDaPI953ElrTFSHEJnDU43oGnWhWu156cM4gWCsqTW3rxZxMGu78+WaYqNDxemqQJk/ErecnBrHdPst+Y8Fzy0wqG3hesTpmAqlpJKnj1SJSAEJuh1vGdsA77h2ctFwMNvSROFfCZkLFB6d95bKlVKV9OEketG/D1cjnhv3TqVEw5744Ac92OcUizPY6vF2T+vmVrsAweLb0wlioLftQSDflGR3gRoO4lJb7xHYrvzg0d5hG8/ctV/w0E97r1qm3Plv9Nd6hvqw9ovC7GLo8JraeY1blqEUGhIQu0MaTD7jo93Cg/BtckYy/i59Z2E0Kk0I7Ai3smp+A4tFrYvXsqqxrmF/wMrjmN1B2wJHFVeXRgLzYuCQps1M5TjoO8s1rJWbJNEsW9hcp5hw13/5Nw7x6Noix4VGW8ZTM78M5u+Zs=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62df8746-9077-49e9-89cd-08d817e5409f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:07.5300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KV+SGbWLM/+mP1QZI/x4ah7h4cJFxGWZbAUB3HxXi1H966XKvXRRzCMWKf0yC9ZeBUfwj8Xxw4quhvpqnEkygg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub

This series adds misc updates and one small feature, Relaxed ordering, 
to mlx5 driver.

v1->v2:
 - Removed unnecessary Fixes Tags 

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 8af7b4525acf5012b2f111a8b168b8647f2c8d60:

  Merge branch 'net-atlantic-additional-A2-features' (2020-06-22 21:10:22 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-06-23

for you to fetch changes up to 8eebb7650754670f5a03e994ff1a754eaa5bfc2d:

  net/mlx5e: Add support for PCI relaxed ordering (2020-06-23 19:15:34 -0700)

----------------------------------------------------------------
mlx5-updates-2020-06-23

1) Misc updates and cleanup
2) Use RCU instead of spinlock for vxlan table
3) Support for PCI relaxed ordering
    On some systems, especially ARM and AMD systems, with relaxed
    ordering set, traffic on the remote-numa is at the same
    level as when on the local numa. Running TCP single stream over
    ConnectX-4 LX, ARM CPU on remote-numa has 300% improvement in the
    bandwidth.
    With relaxed ordering turned off: BW:10 [GB/s]
    With relaxed ordering turned on:  BW:40 [GB/s]

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5e: Move including net/arp.h from en_rep.c to rep/neigh.c

Aya Levin (1):
      net/mlx5e: Add support for PCI relaxed ordering

Denis Efremov (1):
      net/mlx5: Use kfree(ft->g) in arfs_create_groups()

Hu Haowen (2):
      net/mlx5: FWTrace: Add missing space
      net/mlx5: Add a missing macro undefinition

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
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  3 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  | 13 -----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |  2 -
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    | 67 ++++++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 46 +++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 29 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    | 16 +++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  | 10 ----
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  | 10 ++++
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    | 64 +++++++++------------
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.h    |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  2 +
 include/linux/mlx5/driver.h                        | 10 +++-
 18 files changed, 195 insertions(+), 89 deletions(-)
