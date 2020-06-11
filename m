Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6C1F708F
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgFKWrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:47:41 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgFKWrk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:47:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9qGnaMRgMh3zZzwbbD/8A+6Xqu7/NXFuVGAaLVSI1TQcuADNmzlPpb4+PX/qwYQ0TleKjiv5fE4S4xvh+v4FN9gHD44iJAAizg5k0LFcXJu3UwFVnwC6xNauzWy98gLnIRzDib+8uKOoZdRkYbPZs59idJhHGJ60FWjv2w06ohXPd2dF6X2JuKhpQXC44JNJL6nc8YhzB4DShSREXBQGnb3LwTMmgr6eNZzzsq0P1NdqpXEPwYpEQiVXmqKT6F+lB60SDby3GFP97Gj/CcLaeNWIow0C65HR9ZgGfaMSHAdj9iiLEMyprdDBxG3mwepdswxhO/9S2ksoCf1aHHF/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlPRJiyHZBUiYljvwtyXdcKh1TmqYvKtwndz3M+iLA4=;
 b=eCLlizLR1narz8DMIVfqEHxym86rGp3xqQKkDN/hFlwHgVc6Se4JfJbaZuG69w9UDBqdpzO4XmiStKzKif8/8Q92bY1VCl25ZWcftn7Mpu8lSGY4Lx23Rf8FQqWZojrItjPiUUkZ6uKehZ0uPJ/X+j8Blb1tDuldr5dfjBt5AY+DWtUEr4gr5sSe7urPT+BrWQO272guodROVG9bEbdFiiV+7nuwtaDpUCKM5vZd8NK7bZV61G9GLJZCu3oY1WzD/7FpiRQnhq5311yRlAaf0mbwKyn54lK1eX+E05NatKGMr9HKfBQkHBOOgrgh6RM4Sjrewktg0GpU0ZW+A9Ke8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MlPRJiyHZBUiYljvwtyXdcKh1TmqYvKtwndz3M+iLA4=;
 b=JGEcc08BQJ4puwb5hYAPraqYKU7+w7kLdt6T1v/klO7+rS4gM9vuVJgdmgGAH2xcVyJUDvC80z3K+1oOL9UAh7M395oIQekFcZbcg2FsLlPuxihFyUhWktYrPvxgXxteNnAhs43tDicsotUPWHahZ8XzthVYgEOBJg0kG7iUyHg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/10] mlx5 fixes 2020-06-11
Date:   Thu, 11 Jun 2020 15:46:58 -0700
Message-Id: <20200611224708.235014-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:35 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ac75ca4-3c9f-4df2-dcee-08d80e596fd7
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4464ED3C78726BA2B3CCD286BE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /uAtPGqTkdgBRgNx/j2jV1srjCMVSTcaWz/fX2kp88byso6xW5dUbI4q7gvQzeCdTCEJ7oITj6fdeETm8za/0Vc/nt7cVVgSPfgqDkm4SCGpBFfn05/5aRkuGs943GzngwGtDneC1UJOwGYumzGazp52fpCAN8UIKsld+v0fct7BqXkbyeoqj3ny7YU0GEUnrjRfi3IvVjfVESS5IOYpkIrkh6oKonrd6nuyueyAlD2cLLkcPmHhW54saYQJV0f4dVjCskn+/j4KSbHoeNGgkdxX+xHO59HoMgvzKnD0CXbnlJaJoze2NucQDrEmy48uIUXut0ks24FN58DsCd8CmssZx+7N6sch3sE6bFiRsqo8K80Q9mNsHotc3iLzUyie
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oXlWnCZcSfX7AZQKdDYa6IyYQn5nxeQSRX2kt1jtS7TLRTjPhbuoBEVC94sciVPq8a6+OzbaYBVyxH53HdjR7mbaU7a29/zXgVv/YZh+f+VKnshgOQopPAhIW+ByEQpSNKDGxbd4bUHSwTb1mykgqBN2x8IanuwNA9jF82E/ryzuCtplrhNCjaNGpcZIZMMpz3I02hu3yMXiK0Saw30BbTOB011DbHN3xoZhyPZIgs6Do0FatxvS3CYcy5NfoUyZF4QQQqMKCEyIPhfcn7ETA58K2r5OzbonoRQzpj5D1sWDMCKS6HG+IDKx/9JFEL+ipbbBOThjoa+zM8+FL4TftgXMu/+79WOkmre+MLCyb+tBTCAiPvOM2O/U7UJFsdq0n/7vpKOF1EbLY1gNksOjqQHpzeNh5fDnGafMwTPObBfvLoo4GJG6Tb2L1lSV8uRdydVb6JiOYW8e2W9+QXJFF4mPHZHJqzO8ONFcLMLvVDw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac75ca4-3c9f-4df2-dcee-08d80e596fd7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:36.7829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBY20xznda2n8juJ4SrMNdPGoGXYImVv0kU7FbY3QBI6qw4J2H7So/HO/s0SZdupvkK8Lx/Q+4pu4plq2bwNiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

For -stable v5.2
  ('net/mlx5: drain health workqueue in case of driver load error')

For -stable v5.3
  ('net/mlx5e: Fix repeated XSK usage on one channel')
  ('net/mlx5: Fix fatal error handling during device load')

For -stable v5.5
 ('net/mlx5: Disable reload while removing the device')

For -stable v5.7
  ('net/mlx5e: CT: Fix ipv6 nat header rewrite actions')

Thanks,
Saeed.

---
The following changes since commit 9798278260e8f61d04415342544a8f701bc5ace7:

  tipc: fix NULL pointer dereference in tipc_disc_rcv() (2020-06-11 12:48:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-06-11

for you to fetch changes up to 09a9297574cb10b3d9fe722b2baa9a379b2d289c:

  net/mlx5: E-Switch, Fix some error pointer dereferences (2020-06-11 15:38:08 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-06-11

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Fix ethtool hfunc configuration change

Dan Carpenter (1):
      net/mlx5: E-Switch, Fix some error pointer dereferences

Denis Efremov (1):
      net/mlx5: DR, Fix freeing in dr_create_rc_qp()

Leon Romanovsky (1):
      net/mlx5: Don't fail driver on failure to create debugfs

Maxim Mikityanskiy (1):
      net/mlx5e: Fix repeated XSK usage on one channel

Oz Shlomo (1):
      net/mlx5e: CT: Fix ipv6 nat header rewrite actions

Parav Pandit (2):
      net/mlx5: Disable reload while removing the device
      net/mlx5: Fix devlink objects and devlink device unregister sequence

Shay Drory (2):
      net/mlx5: drain health workqueue in case of driver load error
      net/mlx5: Fix fatal error handling during device load

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 16 ++++-----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  4 +++
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 41 ++++++++++++----------
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |  6 ++--
 drivers/net/ethernet/mellanox/mlx5/core/health.c   | 14 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 40 ++++++++++-----------
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  2 +-
 8 files changed, 70 insertions(+), 55 deletions(-)
