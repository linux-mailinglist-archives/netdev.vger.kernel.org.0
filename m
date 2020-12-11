Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A85B2D7940
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgLKP3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:29:07 -0500
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:50401
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731349AbgLKP2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 10:28:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHH7xRp9Q5BsC31L75Imd0FfBRa7wJptmcOJnlEaFiQg9TCf4LtRKWVoX8FjBueeZkMkkTxGIlK7RkWT2rjHGSqh64ggMy6eynMIsG9coQg+UcK98z4kBCzmaTDOi7OQd+7q9J50Q9W86YO/r8LxWiNAgwtDCexyZF6GjEuEUMve2FV78ceHjpFQ4F09QmHKzrtCJKUbTNb3qXF/8nzoZg/wz0S+ssXzDEH6OaMS5nZO5vpp6vUxK8AFk7t1oIU7B25WE9MOWk7qH3BuqwGxT2GtGIN2JLgYWZwAh7R8A6b2WhnlzOwYT0GPXoWSxPkUEXXi89uHOpLVhnMDn2hJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMsdg1iAttZHhLu8D/OGtp0TQB3FL8zaYGdsWGx49mM=;
 b=kYycTwAGQIGgQ1JOEPoHK5RQEXqth1jkbG7mH1RKFnAOIw/m4Y82li35NK5SjLy/xrDieRj2tZ8xeoP9vjABMRA2QUxEvNHXsov1sYYL2So9Q4dcybBuNtk8Qulq+uLL8IEtaSitMWS0KyQe74JQ/oQgsQNnK4OEn6Eqvu3C0Eh0iNkmHQJ7yYSm+11iSt5gOgCyreecG3Z18trzG9JhKIlUTrS5XMcAqbfE84IHv6qviMKOz6DWDwowr1vi0xSdIuVG6BZhYT+Res7p6RF1k6qRYdoagFnxKbLuwofv/73aqsh8gAwqzZStScRHZb0aENIchbtEMxPcddMSYNkQWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMsdg1iAttZHhLu8D/OGtp0TQB3FL8zaYGdsWGx49mM=;
 b=Ad4rAOIfj04ljy1ZVUNGD2vZIgTz+inAlZHG0sWXjuOdQnwm0HiSwfYsifkdO2WqjxYAm0r18KfQ9L37kICeaIUkd0wGMYt+Fpo7XSDOpxCLvhAPKSqzuhSLDAHk5CaNUH7FxZIGgHIC329GDzuXNYFd3dQjL9/LDsi1+Xfil5M=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM7PR05MB6725.eurprd05.prod.outlook.com (2603:10a6:20b:136::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 11 Dec
 2020 15:26:41 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::642a:6259:153:ab88%3]) with mapi id 15.20.3632.024; Fri, 11 Dec 2020
 15:26:41 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net-next v2 0/4] HTB offload
Date:   Fri, 11 Dec 2020 17:26:45 +0200
Message-Id: <20201211152649.12123-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20)
 To AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by FRYP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Fri, 11 Dec 2020 15:26:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ed545f7-2bd5-46fd-acda-08d89de928f9
X-MS-TrafficTypeDiagnostic: AM7PR05MB6725:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB67258EAD611D8ECC29C52826D1CA0@AM7PR05MB6725.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40YOVdyUHj/bwkXS+w91ZzKtLyB7SnobEwkIr+B+Lnopxz8O8tKvlXB7BZvbcLhbb6J7U7UyQBuD6Lf1SDW/a8H3CO0WxN0oI7hBlG60aA81mv1p/pw992m00rP+ISrCWZ1EX4eK4OAMvJCv3odN+Rdduj6JniXKwXjXZPZxAFuIYQp3laaL4nJmZEZBpdVQQ4e4alRIEuX8Tt6qDK11Aa09f5Gp7ynz4X8OrUbuMVeQN1l3O+CQZCbwF/EMpD+NWXXczRCoEM06KBKhs/bdrqviyTTqknbtWp1TkR1qRMt6IzQWbfwErSJaCarfCUS64UmjHlK6UFoLWcf1goomAZea7GGcNyOuDHwRDVrj4qc3jyeANlzQ5iPxMeEtaeOoJaSTjhmQgfXNBGC29M2PVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(66946007)(7416002)(186003)(6512007)(5660300002)(16526019)(4326008)(52116002)(107886003)(2906002)(6506007)(8936002)(66476007)(478600001)(54906003)(316002)(26005)(2616005)(8676002)(6666004)(83380400001)(36756003)(6486002)(956004)(110136005)(66556008)(86362001)(1076003)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?50BWLEKmHPFfVRPArrpYhNP4WvbzFhsVo507VrBWPkI16+QTnchQkcwouXxE?=
 =?us-ascii?Q?WCJIg6THGwVeiZR27RDvE8AYisMKXPZS+Kvd8l/Ak3oBR8BZND1N8RmW9aRT?=
 =?us-ascii?Q?Cp36pgFTS2gmsOXsrPapLXwJCMGkZtuwjxpC2/i3ZdQNZ9aVgKFBS82XEuvH?=
 =?us-ascii?Q?YULHZEpI9pcOazyswlJVf5LIZJTdFAlx10c/IvNBnVg4eM4CSYAGloaHn1bq?=
 =?us-ascii?Q?BUuhOVSyiIvXx+p5FuLekCK2hYvPxFCH4Rd62h+MFTdR6LTr8jMffwl1pkki?=
 =?us-ascii?Q?MKzu5x2VFrae2P3ujhdBRSRnEAUsFK4AATZW0TPemJszfx/3uAFwCTKN0Qdr?=
 =?us-ascii?Q?ERtECHxgJEgJxX2KmOerDsCYlcsFb+cy175nBW9uEusjhhzzbUaxwTGR9DJb?=
 =?us-ascii?Q?DYQYgxJ9/Av9Wa86PqMFZkemHJ4b5rfZOHhbrp9aYjUCQVGEA3czLXcfnqpO?=
 =?us-ascii?Q?P/mOpSGhHTp8DIfSdH6BU8uLVEm0k03+ifkOed2hOg6o2c4bk+UD28iAeKKq?=
 =?us-ascii?Q?RKU3UNgwBpmolRLNcHcXM14xUMEKAvBsRgHeJl05kr0HXjU9WG6mjhMCQ8pD?=
 =?us-ascii?Q?Wsn0gVdKd6d90T66isigIaSBezNSZOa9VM3hrrnYr311GZaSLVF045ZNmp7o?=
 =?us-ascii?Q?NLsv1VULv7rMa/2yvzBa6H0DmjJyH1K8HoGBf7S+lFl5IVoVzC2lVsJSAhk9?=
 =?us-ascii?Q?jb/M5blvypVnYhqvuUZmW9aA+Fk2fz+Zzgxz6do1TGtOLad8FP/BXQ2TVnJD?=
 =?us-ascii?Q?Q24uJLh/ypgUGPEu5a89dPTkWl6K7cYVlOoP4PCt3rYncjJFbdG0nlinG2yl?=
 =?us-ascii?Q?kc8udGt+xoypCF7zxbKm1iw1LTKdMAhbXOlieIsU5KtfVfXH6LISpGTvtgk5?=
 =?us-ascii?Q?VKQ7PWLOh0iQIHvT+3gCpgqMfJTpyj5roMGCnu7eEd+lofw9kflXowso/bpq?=
 =?us-ascii?Q?kcxqtKGuoyo7uaUk7egj67G9IcyDBkzPiIV2MauWNo4b7QvZIcM9uPT8vTtr?=
 =?us-ascii?Q?GxN4?=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 15:26:41.2357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed545f7-2bd5-46fd-acda-08d89de928f9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qCZcypkWUB7XfvxzxcRSquJyKxKL6jl1n0lEuFmGf7jv2Mx5uKsHSxkHdPCdbsqVvTf30O3wgogURRFt9uKNEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6725
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

Maxim Mikityanskiy (4):
  net: sched: Add multi-queue support to sch_tree_lock
  sch_htb: Hierarchical QoS hardware offload
  sch_htb: Stats for offloaded HTB
  net/mlx5e: Support HTB offload

 .../net/ethernet/mellanox/mlx5/core/Makefile  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  27 +-
 .../ethernet/mellanox/mlx5/core/en/params.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  | 936 ++++++++++++++++++
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
 21 files changed, 2002 insertions(+), 82 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/qos.h

-- 
2.20.1

