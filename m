Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5361B21AD15
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgGJCaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:30:55 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbgGJCax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:30:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmSU3mfqehrd+NSPKPRumoT7VbpkRwdTWCb8xAaIQgX99N9dhsiWVFmJxhxaWMd8VKdyLL1SCK0n3+xdMthQN0o3pm6pXxzenlSeUJ9xqi8lgfnOIbb4Zk0Zzljfr/9xtH41sRT8I0a/Ip1oWMCXOobe42nMZqZjZAGAuqMRN9reMikQUgifu7KmeqyXUj3VcRiFdJ8NSvP7/pq3zS28EVONYTlVOX5LljXmyW8KkDDjd4GYz86zKppCZnE/jvkYzIVudNXarK89q9aUOpsB0VHu9/KV4zN1orV9MlJxlJV+WGaGCzTTUqITZScf27u4TTa5kp5BbaXw16tQiu4t4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhrD3/hwNSGXjxoTAZhEfTYe7MzVdQmaR0kzPEyFaDc=;
 b=WVSFcH5zhPN7JeC3UsIIhv4Gf9+Q6+OdzWOeUCZlt643BShNwXIodtodz7F6FtbzB9S+moFvb1ksCTIz5VoFk3w6tJl6y/GxajcSiyUT6VwKL8K2Uv+uyzeBBj6v22oz6pHZK30TQBRZ4VqbZXzHXnbQs4YCqofh4k+VIZWlNPXPZNwZiPnApNATvnX55qZXG6Uf/WYk2JwMID8qNpfSzII+WbViPWMtGpp+vp1PvOy6+DlJpVx20EadPuxQ0JzTv/hSxJVPIM3xNzvOCjemciss3NfkM3ZBeXoIrhaEWZad52vu3aSEm1+AsizqlTOSaU/OiS/sc35BwZPsOFWdUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FhrD3/hwNSGXjxoTAZhEfTYe7MzVdQmaR0kzPEyFaDc=;
 b=iJLvm0W2igzE+ipFcxRhOBAYuRdyLEYSfQTIc4cpbPjfJidA/DWWR+9eMS7AiZ+B0iQ62ivcL1E3IzwIALu2Y8KWDyfUB+YTL1aW9ef6xH5/cVJ3p1YT8LUoY2Y18+Zob208lhVuUSN//4WNLky6jQspmJsUjTplqaK0WlZacO4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:30:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:30:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net V2 0/9] mlx5 fixes 2020-07-02
Date:   Thu,  9 Jul 2020 19:30:09 -0700
Message-Id: <20200710023018.31905-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:30:46 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 213dbf1a-7f66-4cdb-e8d9-08d824794169
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB71207E5472477BE4BD735315BE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDBSvA7JYZ79gIWEGjAwmUqDeZJ01UElH+GQ90GHaMiw9gGAJA2R2W1jUgBTgXsyZ/xQ25sR14floYuZ68AeRbCMt8zNOX+J1nKvLUyI0Iezk0OiQa1nelstCTf6BulasvSfm9Ps0rxLN25MmOy+s9VJ+cEdx7tm3mDXV7/zA0U6ZqqwfRR/pa/ZUuPNnMnfiv1AS4xWhc5BD8zf5HrXTSfb642jRgS83WZXwlHJEHfiE4rD8Uw/uLDpSsmdTeloW9Dx8Z6Oobvd94s2dX2gln27S8ZNL16f2sehUkZG06Nj+7Zx5E/xyiNf8enuxyP1qe1609ui3Pw3JSTpz1dCqjWU+4oz/BmbgivtRuP/ylu7VLbnVjYiryrHJKWiHc1z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C0NsHF4noGkTjxBxEmhJ17LQbe97x7gfk8jVnXcrO1saWPIHDlysuNgzEh2QIuhUSLP0A/00i8/XSpA9AxaRvkRia621rKUJ9JE2Lf1pfJZjzQwt8uQMMfc5EFHRPCbER08GItMdvfm59ciPwZyfx+EiAKnRVUZrNRNupl1JXzFtSZ77v2kQk5TZVRyBMrRcRXfS0+9H+wlOgK2m5reaVWAjnJfy6rMevdk+FhvumVd99IeDsjwcb4Hnh36bBC6H/+3HGpoDO6Th59U7UB7ZLDi/pXrUbCiBfmXlIu6GRhWKwIX6lF2+m82VHMv1t3UZHAmRCCZfU7Gq0uyfhfR2QZhquCCSmocmMabwzjJ8wvYBZHn9h3XtYwU+ojzf8JTxgCI+VkKzc2ONK/QaaL+gVu+Uup73b5PtM4MLGO34AOw3v6lI71KTzQs+49YoW6h5da4NBy7laxrH8Sy4EXDiT4a0WKrAteH1sZzrFbY9o70=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 213dbf1a-7f66-4cdb-e8d9-08d824794169
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:30:48.2556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUk42hPe4SM5jNevL73rYlXOIaP2/bYCbjeU6/sgXAxw9ZzV4U5GZHInqteG6Y0byN6iOnX4w4n3s2IzESAVaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

V1->v2:
 - Drop "ip -s" patch and mirred device hold reference patch.
 - Will revise them in a later submission.

Please pull and let me know if there is any problem.

For -stable v5.2
 ('net/mlx5: Fix eeprom support for SFP module')

For -stable v5.4
 ('net/mlx5e: Fix 50G per lane indication')

For -stable v5.5
 ('net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash')
 ('net/mlx5e: Fix VXLAN configuration restore after function reload')

For -stable v5.7
 ('net/mlx5e: CT: Fix memory leak in cleanup')

---
The following changes since commit ce69e563b325f620863830c246a8698ccea52048:

  tcp: make sure listeners don't initialize congestion-control state (2020-07-09 13:07:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-07-02

for you to fetch changes up to eb32b3f53d283e8d68b6d86c3a6ed859b24dacae:

  net/mlx5e: CT: Fix memory leak in cleanup (2020-07-09 19:27:07 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-07-02

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Fix VXLAN configuration restore after function reload
      net/mlx5e: Fix CPU mapping after function reload to avoid aRFS RX crash
      net/mlx5e: Fix 50G per lane indication

Eli Britstein (1):
      net/mlx5e: CT: Fix memory leak in cleanup

Eran Ben Elisha (2):
      net/mlx5: Fix eeprom support for SFP module
      net/mlx5e: Fix port buffers cell size value

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
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 19 +++++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 15 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 14 ++--
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/port.c     | 93 ++++++++++++++++++----
 include/linux/mlx5/driver.h                        |  1 +
 include/linux/mlx5/mlx5_ifc.h                      | 28 +++++++
 14 files changed, 196 insertions(+), 62 deletions(-)
