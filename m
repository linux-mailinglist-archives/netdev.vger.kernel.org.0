Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABBB2DA8B7
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgLOHnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:43:25 -0500
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:14901
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726627AbgLOHnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 02:43:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiTS8uSuHlb9Mry1VoowP9VLffBgeSc1O3jrnQWrllQCND45F2tfwmed9/FPp5KxQtIyEws08iqR+XxhzS7tVBmFibswLUbaJuG7WgRS1FVmlFlQk4l9jHuqfVt+3aX0baGksroK6/SC9ICPy2etKomI1Ng+5lP0qD1w5iVzP1lvP4sudZFs/t6+QiFGY2MVO3jTz2qZX9rgbGgoZ76WiwBvEH9Dm38yPMVb7/qCP5Btg817kf9vw3UFV6mkinD66OxfnmC96tBeOu4Fn0Dr1YCgVYFDPklQjTaadORcpEkpkKbiBRkadVPJgseR2RqGagZynWXRPboM97CLC1xPKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWFGfAhAY14gROCaRBG/gzsOpBNj6qw8oYv87oF0iVo=;
 b=cRGjwVLBcsK2ODV7kFyLZBGYE9abvtscvVu6iEbrENU2wGDMpENecfWTVhd746Sm6MSfwuztElSY5fc54ZrCIjnIBNHzuC+YKUIQNvd3lG3WQB3eiz/bBAewtCbpeKIld1Sfn7xm/+HI7HcqUKZOnSyy3i2h0owGBMQ2h7fLAoJOOl2lzAnGj3VhRLsAd+73iWEIu4vGxRWXa6M0OS24FifdYV+KpEtUG2iqKYmQl9yFW6h8ZQu38EnCCfvezn23fV/WzJogEzPdxDgfn4qn7t6JXL5Pv3qXoNnZRsbYFDpE9iaW6+ANDzMDUzqQz00QnVB0AaknteODX72oxsz6qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWFGfAhAY14gROCaRBG/gzsOpBNj6qw8oYv87oF0iVo=;
 b=jKkMQgbyu2LsgkZ0lfEjO3dz84nlaxEsJ/ptm6JcxKVY3IcnQ9Rby46q/c1O0OgdBTzNHoWPjC7+leomK3gpIFaojBdyNVppbKGZ3+6W2F2/CTDNL6LigIEmuGFQDOc8SqidzIRus2fMTYIzUX3Lbc0hUFxBmE49dN0NfJtjSyo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
 by VI1PR0501MB2335.eurprd05.prod.outlook.com (2603:10a6:800:2e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Tue, 15 Dec
 2020 07:42:03 +0000
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2]) by VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2%5]) with mapi id 15.20.3654.015; Tue, 15 Dec 2020
 07:42:03 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net-next v3 0/4] HTB offload
Date:   Tue, 15 Dec 2020 09:42:09 +0200
Message-Id: <20201215074213.32652-2-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201215074213.32652-1-maximmi@mellanox.com>
References: <20201215074213.32652-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 07:42:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0decd834-4d6d-4c6b-1567-08d8a0ccea35
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2335:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0501MB233551A19A8DFE12B3CD65BDD1C60@VI1PR0501MB2335.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U0IkRzD5dt83u4RXbc9Pu/HCsuub0ACEoNUwQPCQQ3TMl+I3MlaoPnoGXcgVbtC6u1UsT6KWgw1acM107e/HQsCuPKFs7avoYtJN6yjiDmJxT+1H9+ZN7aSk0arheHdQEMwvTCiHm3b9guN8fTMN18Vv+zBXVjGsEFZ7k5Bar8Md/dlaRj9ZqZacHIX+ziYok38SSkKoF3sO2yOgw3yhCsfI0MsDbzpZfwBdBxnNNKdj6X82L64NUvZaOQpwGBQK0qqCoJ1gvmx7LS4c5AW2ER3G9zBj+oZQzTBSlR9cLI45oRFJI6a2S/VkLFwOkEZs/1uZlDuE992vvaoGn7mFnKUGvDbL+tYerBI2amH5xC5Qj716cBRn9pBKo+KCVeAYpv7T1hpHJaj8WlGYy9McZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5982.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(8676002)(52116002)(186003)(6486002)(16526019)(2906002)(66476007)(7416002)(66946007)(110136005)(6506007)(316002)(36756003)(5660300002)(66556008)(8936002)(54906003)(83380400001)(26005)(107886003)(1076003)(2616005)(86362001)(966005)(478600001)(6512007)(4326008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kuJQxPbg2lkWDNtqKp0XSMCl5xRhc9ub0wJyp1y8wJNBR2OPZR+dNLMuwLHR?=
 =?us-ascii?Q?+ndNTpSnsvBHY0IEH7g1DunP0x+KFQBayiKFpimX5nV6CWAIxJP8fuW0gAGU?=
 =?us-ascii?Q?A6mxRMJWuzWrXLRuGJxw6ORwMtkP7alnc9ksHYvSZYbwtj7rQMtVIjusJzt6?=
 =?us-ascii?Q?uwOnXt40ZSFsORKoPwQMatT5TMv29u1U1ijK7MrJJmZ5UI5m7P5WM9X5O/Vc?=
 =?us-ascii?Q?U0SyivsIkwfqWxMO8y1k35VjKhCRFAP7oTt7ydWLC1KZXb22XsBgTTtWoFEr?=
 =?us-ascii?Q?IGRXBTui/xv+gR8kx2eMRMqQ6/FfwcAfU09EVWAEO95Gw/jKDHyD2QtIo/Ov?=
 =?us-ascii?Q?6wT/CT5zGDfoWXwzu3q6s8UM8DioxR/xsI1XaM2ac1T9Gd2tM6Lah7muQfx+?=
 =?us-ascii?Q?mlEx9xEFZEQcwjMwf3a4NPKFNNlm5IdFglzojd11GQoNBUGqV/ggxtBsVvEd?=
 =?us-ascii?Q?qOEoBBhHk/s/ocWMdrWzsne1kch7y/SO5NDQj3nOweJw6/lf2V+JLjZURYqU?=
 =?us-ascii?Q?6P8Bko68pVWEc5xN6jz3sZzJrGEdcSCEmH3eq5rRW5Q4U+VQ6P+2eDYDgnyM?=
 =?us-ascii?Q?LGdjDK78XaGU8LdSzqDtJZjudNw7Yp4+anUiYpdSBVJ938ttBk4qjy71z33e?=
 =?us-ascii?Q?/7eCRhUZ/3GJZUQ3pUQs3nSBlkDQCDuZV4UtJ16xLPWfEfPVJNnX4vCvCtDr?=
 =?us-ascii?Q?l64oStyx3QZGV+G4E4353Xjxvk4dRpjpAPc10NofCTPd/MLn4rdNJORnLb2U?=
 =?us-ascii?Q?T2+MiJ5ZiBPClw+wTSHXpnqmnWmRLZInUldMHwB/VjsF8IrgEZBqC8wovlKN?=
 =?us-ascii?Q?RNdJuP3vx8yOSfUGfmv5+0B2ClzA4QFQKZ+MZkOL9FYcDa3uYXpzWC+l3wBs?=
 =?us-ascii?Q?DZmSMEbPfly+JwI3dYTaLuzH42WZL3iOLdqQEyeli3vKcBM+8CClrW1z1Yj1?=
 =?us-ascii?Q?2VLigYBuvrg2dI3c0LSAsiY7E882vdgNyXhCc+3v+/Qv2HoMeCd8rt49PKSc?=
 =?us-ascii?Q?k0EQ?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5982.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 07:42:03.5455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 0decd834-4d6d-4c6b-1567-08d8a0ccea35
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P7LydSiZmm3ZjDp4NLsvW45KqTRVP1c7YTNcW2pI0UxeRAOVHIG9aiI61kkakNrnTfm3KWczXqSAfRww717WsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for HTB offload to the HTB qdisc, and adds
usage to mlx5 driver.

The previous RFCs are available at [1], [2].

The feature is intended to solve the performance bottleneck caused by
the single lock of the HTB qdisc, which prevents it from scaling well.
The HTB algorithm itself is offloaded to the device, eliminating the
need to take the root lock of HTB on every packet. Classification part
is done in clsact (still in software) to avoid acquiring the lock, which
imposes a limitation that filters can target only leaf classes.

The speedup on Mellanox ConnectX-6 Dx was 14.2 times in the UDP
multi-stream test, compared to software HTB implementation (more details
in the mlx5 patch).

[1]: https://www.spinics.net/lists/netdev/msg628422.html
[2]: https://www.spinics.net/lists/netdev/msg663548.html

v2 changes:

Fixed sparse and smatch warnings. Formatted HTB patches to 80 chars per
line.

v3 changes:

Fixed the CI failure on parisc with 16-bit xchg by replacing it with
WRITE_ONCE. Fixed the capability bits in mlx5_ifc.h and the value of
MLX5E_QOS_MAX_LEAF_NODES.

Maxim Mikityanskiy (4):
  net: sched: Add multi-queue support to sch_tree_lock
  sch_htb: Hierarchical QoS hardware offload
  sch_htb: Stats for offloaded HTB
  net/mlx5e: Support HTB offload

 .../net/ethernet/mellanox/mlx5/core/Makefile  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  27 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 940 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.h  |  39 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  21 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 168 +++-
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 100 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  47 +-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c |  26 +
 drivers/net/ethernet/mellanox/mlx5/core/qos.c |  85 ++
 drivers/net/ethernet/mellanox/mlx5/core/qos.h |  28 +
 include/linux/mlx5/mlx5_ifc.h                 |  13 +-
 include/linux/netdevice.h                     |   1 +
 include/net/pkt_cls.h                         |  33 +
 include/net/sch_generic.h                     |  14 +-
 include/uapi/linux/pkt_sched.h                |   1 +
 net/sched/sch_htb.c                           | 532 +++++++++-
 tools/include/uapi/linux/pkt_sched.h          |   1 +
 21 files changed, 2007 insertions(+), 81 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.h

-- 
2.20.1

