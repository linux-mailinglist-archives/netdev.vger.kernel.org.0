Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC40A212F67
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGBWUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:20:36 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725915AbgGBWUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:20:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6qCmaxnvyErVbSBzPO4w17d299Ergemz1kDxJpUntOxgYqFDRITX12Tnin86Q5iL5dk/aV8dENltyveJ88wdu+EJKQz/uwV3UJ8kIHYh76LNCOP8Vt9kI3cx7M+fuFlpznGl5wB0bSWDyfJBk1mW9k7FZlwA2PnOGC6NK5HFMN1BVwkRsyJUerdf1bka3b1RD+vbLrw2i+zzdViSr7OiGE5TqcS5KW+kLXsRRPURHXDVaW4Tqy0cYN5ZDvu9yyS9EDQW8QGUAdHZyzcoLke/QPgg/KjOx3paYSUEjZFfh+/L/768ENjikITIt2PbdzkEBqkVTeBPygsRfM3/BTEuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4aBQsyuhF9SKgnG9hqw32zRZwQUmcbu6yvR9QUXT2w=;
 b=S4Cccyps4nP3c8qkkoQ6PuHSttjxndn4aalyRRlogfR38DFYv/1EUNzf8JqI4H4s+el6nOcXjB/3fT+bFB2zceCzlZZWXZPPJgTBgMJhbYYrOAaqTYL5xvjxzfzTNkIzyx+ix4QouFyi1k+lT7xFJXzFqjZYgF4Ozdd7ldYK+N8golI+XPqjtvT6AHfWZIXx4GKh9FOyDqzmNAuqond+nkZKnJoaQZ5ER9kV5f345VPtgEQJsGmm9R8eCETjq8ShrHzEi3MjLj4d6NWQfsfz2FZ8izWW+RINkNcQrNQioCGGsAeCe90lRSp2GTXJYOovj16xP/7bCuPLjOXA7/IclQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4aBQsyuhF9SKgnG9hqw32zRZwQUmcbu6yvR9QUXT2w=;
 b=Lp2HWjn+DXJHCbGDHAD8/8JkIV85NfO44/R3W6JS0n3/20/CqzgaQT0bhSvvAp1w4sad4CMAtv2jA4IoNAJn9fEXiIaih9ZRzxDY6e1D1iCP3T1Xq3g1lYaLL7OjbMhixYV5m0loZyCF5NYxMCLofP9Aonr1Uoc6/5FIlqqutE8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/11] mlx5 fixes 2020-07-02
Date:   Thu,  2 Jul 2020 15:19:12 -0700
Message-Id: <20200702221923.650779-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:29 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ebd301d5-d5c0-4693-3fda-08d81ed621ac
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB61092B341C2899A1FD002621BE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:353;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Yh4JPPNUcmz85fQew7zdNLEBVIa7EQEoI6nLKa0fxpelbygqXsCWUPwPkEXiuM2AFJtCg9JTQELJSza8GoLH5X0kZ6Oq/ngBpJu3Cpv2OQjfl2jksqix3NjdMHkfa7VXtBkyrZuV8iMy3m8PYrWeR5vnVfbz9AGGNNLyNAk1nRFNcJeYzrrBwljuuoV1xzjSoP0hJhbOv8aK7s8/4O58+6P2wZZ2zn7VD5XkaNStHWN6If2sWNLNfi900WZ3GS3AYvH2tZ+kSepn2RHypRgeIk+z7HMKvC5Nq6gZukTvQKDVlHo5mknNNFasKZjWKHVA4E6wXUzOhETie3thMmpuoekwEPw5C/pvQ9msfGcIwZx2mGmIxOjgA6fEBF4AWdt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zm+aRhQMW91U6FJ5ld/4IcNaNXgChzB8l9JXmw9AdaYVG/QuPUc1ZCMfikQLiAn9O3E7atwGoik0y5nJiy4i82azNpvt9fxq+5z4S11Mq+VQ5RmaanrUuXr72BV92XT/Yt727w+Za3hZouZVazjBXunLOosOUeDkdZgi/lGEkELbM6sv6HYKOjkzEbQ5lm6wsYjAlzcWc6QTbQL3uGgKOUMcoHtj24lS38ya2H4xDQdd/XTV6GlF563DBTlghyde3ZSu07E037CtbutpY/3OpRBCC0p4DAK8wJYH9HHvkuSKxwMMfr8oWrOkGSEZdLO2EXKFPN/89xsTEsywgtshSYs3M6X63Rq7D8Y3evmwInvAxvM245L6wmhYEJtNkkCCCaLR7CQTgxmTFeHHGAx4QBtiZMSD1cpvMGqMkggHWcUeoh0IRbvcNWAWjoxFad02pLu8hMScEjAzt6nua1DlpK8hgkphNrxOTMDfGPGhOVE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd301d5-d5c0-4693-3fda-08d81ed621ac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:31.2624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGiuzfO7QT/CNgiBlAhXa5V0K7ppc6RQfsohAC3oUJ6/yVdNoSxHlCevkO+xKh08aH/hHRO5+UF3LHMlXE0pPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v5.1
 ('net/mlx5e: Hold reference on mirred devices while accessing them')

For -stable v5.2
 ('net/mlx5: Fix eeprom support for SFP module')

For -stable v5.4
 ('net/mlx5e: Fix multicast counter not up-to-date in "ip -s"')
 ('net/mlx5e: Fix 50G per lane indication')

For -stable v5.5
 ('net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash')
 ('net/mlx5e: Fix VXLAN configuration restore after function reload')

For -stable v5.7
 ('net/mlx5e: CT: Fix memory leak in cleanup')

Thanks,
Saeed.

---
The following changes since commit ad4e2b64839710e3b6e17a11b2684ceaaeae795e:

  MAINTAINERS: net: macb: add Claudiu as co-maintainer (2020-07-02 14:33:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-07-02

for you to fetch changes up to c422d24e732c1dd73033f821c3a91e6021a62e19:

  net/mlx5e: CT: Fix memory leak in cleanup (2020-07-02 15:12:37 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-07-02

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Fix VXLAN configuration restore after function reload
      net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash
      net/mlx5e: Fix 50G per lane indication

Eli Britstein (1):
      net/mlx5e: CT: Fix memory leak in cleanup

Eli Cohen (1):
      net/mlx5e: Hold reference on mirred devices while accessing them

Eran Ben Elisha (2):
      net/mlx5: Fix eeprom support for SFP module
      net/mlx5e: Fix port buffers cell size value

Ron Diskin (1):
      net/mlx5e: Fix multicast counter not up-to-date in "ip -s"

Vlad Buslov (2):
      net/mxl5e: Verify that rpriv is not NULL
      net/mlx5e: Fix usage of rcu-protected pointer

Vu Pham (1):
      net/mlx5: E-Switch, Fix vlan or qos setting in legacy mode

 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  | 21 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   | 53 ++++++------
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 19 +++++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 23 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  6 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  6 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 22 +++--
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/port.c     | 93 ++++++++++++++++++----
 include/linux/mlx5/driver.h                        |  1 +
 include/linux/mlx5/mlx5_ifc.h                      | 28 +++++++
 18 files changed, 224 insertions(+), 71 deletions(-)
