Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277341E8DC6
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgE3E0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:26:51 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725769AbgE3E0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:26:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1ci1PtVAufeDQdmuAxeWl+KYyGZiccY65KVsXifUwXY/ZlT9SATYQ9QL5s99uMB19yg6diG6RdsuKYZqRPsAkaYTNSUAgwymb4VY/oPFZgz8dIvyxd7WM9R+nN+bUsxPlkwwH/4fpHj0k/VD7tB5E5uuxarlR3sPCCy5P6yVMmVyM4SDBHXbdoNnTayZ1ODklZIW2i4viu+ahw4GefX657+91Uxo6O5Qxex15wlEOTfcQoaTAq8m2al8srYZpyOIbVDlq2WCt+ebRfFknKE8OHpsJ7ufZDQ8uOIEGUY8h4ls+ceTwfqt6waL6Ul9euK/Cxu3zI167kYyxKKALO1KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utVb0SxP8Z8GQAaKKF49ixsswDBNNlIVKDGh9aNrNTs=;
 b=cAFVg/E/HgVtqmVFAye+/d+PKsnqwQ95KEU8KsvH7eiu2vlO8+K7MnHQOJ7pumm0wLKj4N5ehuUu5J+/quo9WmYs9HXtD0GgU9Fsj2rWbW6ew8YyyR4BpDYLoPi1CQiw0s2rcyWsQ2/xBGlRjFf2x/lNJyF/IEi6AZynxberwtFb8tWu2yllCnupygnPJ/88WhYLy5Bst6qOMSUOGE81g2kvlQ0lKzZ8gsv9IPazeIlG00t6BeHijBfOMzMNtPBxmEgb7zdefdFNBsv88ldzjnQ7nR2P5m61EmvdGPQrctT658PEZSH3Q8J55lZeLA1ZkzlZkOnORLFuvFSKilVjLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=utVb0SxP8Z8GQAaKKF49ixsswDBNNlIVKDGh9aNrNTs=;
 b=CiF0+hBUjYsRVUo7MsZTZZb71P0GoQQ8tcbN6dp8eLVM8/4sTLVBBxddMTvviP3XSAzyxBN9hzZS9vhZy14XNhMurAmbxy6bYJcWFBBqj/O9jcpiLBY7PQC9bHp4KkuMjL145wv1bJIbN3RBQ9cV/SmPY/JSvvKXdfZTYQ7TJX4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:26:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:26:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/15] mlx5 cleanup 2020-05-29
Date:   Fri, 29 May 2020 21:26:11 -0700
Message-Id: <20200530042626.15837-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:26:45 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2e4b3250-3d10-426a-75b3-08d80451aa3e
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340844ECADF470036AB9A09FBE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:341;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sL/CnyRA++yjwjKZ2qhHXx0s/nFoX6+FU7K5kI4SLsXY9cYU3QSmLZIR5pME6PpQeeAs7U/bW8/0FlrDkS4wNv6WaT4NOB1qZWqPSruEoBhw2TFRw9jvzs+Bk56Yi/NZBaVGS6p64csS+4uGMQMGKN2L25gvvqbTfzdWfhOlopOSVkaMeA+OmGhbTK/iJOO0krxE7nBOQ60q3Rl3RgHp799Lj2oMA7yzF+HkuC+7Zk9yR4e2No7EOZXr8Llo+bjnFAXK0Nr69leIZTr8kPGAljNB9RGdnlpLqukxtRZmI3aEbewr/FcCa9WFRshebV/PwWcIcicgYfzaFDibOlslbfUYlANLXn688gkwb8RKi3kI3MRJxQreHgRUvBTl0TK/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 442ra23sOna2jMFBlnwXAiSJoelF2CBj8S5ObuuxJbaETX7noe7ONCVo87kX/dyX86GyDa3OicHiFNfyR37792PHTgzjnW6f5wa2K0b8+aHD253SKIpLTdHnqNXp8o113VZrm1jy2BJ56Qw7ul5iGYY2iR3AQaBUW7TF2IBvz2LP0cRKnMbqcsT3dg+BgWz1NDVaLGicufbPJ83Xj4zoDP2hyURa8ysJ82y3xsAbnlGX1y+ZkTQiaY7ppk4VJBpd6orNWbhHwxbnnZcybZYrD722bvQ4yV/BO+YyEUSwKbsetSL/LbtMGRbnJdt3iUXQNhDOoY3/jNf4V0s7pn6Uqh4xM21x021hq3tfdqFP7/Tx1WPvMXXhP798pBwF5908bTrd9RdE4h0VnsBR7rT6e9sIsWe3F9JHWWWc34Jt7B6bbh5ECdB/1Alz9pTyusNGylABr2F+fefg0ktZV0q0gK4z73P4OsxznxcJlqJ3khM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4b3250-3d10-426a-75b3-08d80451aa3e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:26:47.0545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ry5BNZwHsCxDjxufdTKNG3/cgzLqdjTC5erZZKEGDc/6KKPiXdpXsZzTJ0zhXQkVLzNr5BbC9hCQWfC2i5k6wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub,

While the TLS RX series is being discussed, If it is ok with you,
i would like to get this cleanup series merged into net-next.

This series provides some trivial fixes, cleanup and follow-up on
previous net-next submissions.

Highlights:
1) XDP data meta setup fix By Jesper.

2) Introduce mpls_entry_encode() in mpls.h as suggested by
Jakub and David Ahern.

3) sparse warnings cleanup. My build script had sparse disabled for a
while now and we've accumulated a number of build warnings.
Now all is clean and sparse is enabled in my build script, i will do my
best to keep the driver clean.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Have a great weekend!
Saeed.

---
The following changes since commit 971ae1ed0346658a70f5b411d59f528b94553009:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux (2020-05-29 14:38:57 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-cleanup-2020-05-29

for you to fetch changes up to eb24387183d37f2f4f456654ef92679b1556f8df:

  net/mlx5e: Make mlx5e_dcbnl_ops static (2020-05-29 21:20:23 -0700)

----------------------------------------------------------------
mlx5-cleanup-2020-05-29

Accumulated cleanup patches and sparse warning fixes for mlx5 driver.

1) sync with mlx5-next branch

2) Eli Cohen declares mpls_entry_encode() helper in mpls.h as suggested
by Jakub Kicinski and David Ahern, and use it in mlx5

3) Jesper Fixes xdp data_meta setup in mlx5

4) Many sparse and build warnings cleanup

----------------------------------------------------------------
Arnd Bergmann (1):
      net/mlx5: reduce stack usage in qp_read_field

Eli Cohen (2):
      net: Make mpls_entry_encode() available for generic users
      net/mlx5e: Use generic API to build MPLS label

Jesper Dangaard Brouer (1):
      mlx5: fix xdp data_meta setup in mlx5e_fill_xdp_buff

Nathan Chancellor (1):
      net/mlx5e: Don't use err uninitialized in mlx5e_attach_decap

Saeed Mahameed (10):
      net/mlx5: Kconfig: Fix spelling typo
      net/mlx5: DR: Fix incorrect type in argument
      net/mlx5: DR: Fix cast to restricted __be32
      net/mlx5: DR: Fix incorrect type in return expression
      net/mlx5: cmd: Fix memset with byte count warning
      net/mlx5: Accel: fpga tls fix cast to __be64 and incorrect argument types
      net/mlx5: IPSec: Fix incorrect type for spi
      net/mlx5e: en_tc: Fix incorrect type in initializer warnings
      net/mlx5e: en_tc: Fix cast to restricted __be32 warning
      net/mlx5e: Make mlx5e_dcbnl_ops static

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.c  |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/accel/tls.h  |  8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c        | 20 ++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c    | 14 ++++++++++----
 .../ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c | 20 +++-----------------
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fpga/tls.h   |  4 ++--
 .../ethernet/mellanox/mlx5/core/steering/dr_action.c |  2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c    |  4 ++--
 include/linux/mlx5/accel.h                           |  2 +-
 include/linux/mlx5/driver.h                          |  2 +-
 include/net/mpls.h                                   | 17 +++++++++++++++++
 net/mpls/internal.h                                  | 11 -----------
 18 files changed, 69 insertions(+), 63 deletions(-)
