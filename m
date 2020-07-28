Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F63231352
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgG1UAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:00:09 -0400
Received: from mail-eopbgr00050.outbound.protection.outlook.com ([40.107.0.50]:31031
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728310AbgG1UAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:00:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P10t8go1O1gBcuq/Zk17q+OFXfD+AnIl5WrZWP+GnfbHA3eG5hVEg+4Pa27E5MXxoLuKHyBAhKp7yAdsV93rQUf25tMmsL4ZvCTBO6O9+rBJ54d4azuB5sp57npVdQsqBubtLYxU+NsNZj4FP3QOkVNR7ntfdHMXJL7uJGUM78xGXppgBl4AdqYyF+DEP4zgLtZeE21PGULn7xTpMQifslrlmvtEQprCU0Hdo4JpP3hDlNptjnfxq3rp045+UxlaV3CWQS+9LOQDvH1cbtkOYZ7JzUz4QXQqVHlgrJ/Ss+FEOvXVXERWRVuUNDjbxRwddajCF4hu9NaBscV6v6npXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3SZboVZM1w12V9ao2ryAc9RZmQJr7y1S4NiU9tan7g=;
 b=Zy9tDQSJBACdsy5z5chOXe7rrvBzVmBmBIlepUYX2sdGJ7bfdGuDPjm3Ep6FotD6AG1g8YpFo4bPYtacMmsB1OAAPfBTLtZyomTi+ZQIMUDWiWRrMbKY1gJVjixFX0ydxEq9dO+9ax2+tVevNL7JZqhCwGieCImZWiEJVAXunKwwnQDFoDdEYlNdfxX9g5vplNJnvmczYX4XbaDaBY/HJdWiHjPtwPhbGkxGt4u12bECb3moRlFLvnoqEbPa6GUeZ7F2UX8OZ8WjiPXWv0nwd1cX0rVel/571L+LG5RNSSyhxL/sVI6H2arsd+wghU69a4xlbnogDVLr3EyYxgthSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3SZboVZM1w12V9ao2ryAc9RZmQJr7y1S4NiU9tan7g=;
 b=sNTjIXw6EECZd9MJ56WWPl/BsinHW6SaVDSvJAuKXST7AiNycYEFKYrrGxFj1DO4nzzllpqvfgVuiO8B1iTjIijM2BSWF5KPqHrlzXdpGotM32qHjTgaOd4k0HSBrD0os5ALTzZpQG9Gqkjmek5z1pplcXuhBER6V87PcdttJmI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2592.eurprd05.prod.outlook.com (2603:10a6:800:6f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 20:00:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 20:00:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net V2 00/11] mlx5 fixes-2020-07-28
Date:   Tue, 28 Jul 2020 12:59:24 -0700
Message-Id: <20200728195935.155604-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0058.namprd07.prod.outlook.com
 (2603:10b6:a03:60::35) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0058.namprd07.prod.outlook.com (2603:10b6:a03:60::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 19:59:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 029e71cd-8c90-481a-4020-08d83330cea1
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB25922CE60248BF4C4DD7FF4DBE730@VI1PR0501MB2592.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzqKCmucnkOKY00hvtfH6+ZHZfPfe/SGivkFDFhl0NCU1iHTc6BSv7jBSbWPG8Mmnx6xdKYIhIrLYU3NIbED1f6DUOwChs5JPVTHLa/IRDTOoU8M8Osjq33I02ehtTUB0T3+I3AASD7qAeDtel8HH2dDw/MgsFXfi6D/AZBos1TBe//5tQgayXIV8kekMridu+MJwtxPm0Vl/k5J9fLxlLSzE/RCekF8nqUiZY+OAr4C60I+YxWz611n0Yo60Y5kZJAYRj+jaRB8xoWWq+xgLPeG+mDqvm7RdAi3qusHV3oHjvkbJMhng1bKxpBiazBDvLKRyra+AHTRYIMXiATF5pHkRAbl25ozl0EIqVbMF4tAfANPtOE24c6G/XwuVrTz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(186003)(6486002)(8676002)(83380400001)(498600001)(6506007)(110136005)(107886003)(86362001)(36756003)(16526019)(26005)(1076003)(66556008)(52116002)(6666004)(66476007)(4326008)(66946007)(956004)(8936002)(2616005)(5660300002)(2906002)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3JrBkl7coBfLcXpEInlmd/Yd2eThY1K/1r2t8qoLcRqfqj9SwdnN2nKM4JiPci5HbeRvatbWZdQQbDQBDkouJlvu7H7XyYhG6il/mN+iIU9SD1fp0cIBxTTXSihfTFnYrkrhsSnfAkbcxEZnAxUx2XWvoqR44LedAtRpQ8oiwX/RJ5XlsBB1o9nwUnqTK161I/gs5kUJS2hncGvgSkXuhobZMcU1SltJylsYf8XT2dNdNQZXWT+cCvslokafh7rv+SIyLYkS/nrdAaZAFitbGzxwuKVFekFGgDo4GX6dYY+spD6FjST6OxK57OkkxKXGjXep5+35sGzvlzWqt8z46wUZZq/Eq0sg4euKkZy8Nt3IGB+PCUSIsbnnLioEm1gQx4NFPKp3ir+gtNniYqEPMbFiIF/xLcyuA8nDQ9mN7IkUiyuy93StEStCDi65vPaAKi3okv7PCXf5d0HCmLNpsW90d6SmrKjuZkiOzd1SYpY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 029e71cd-8c90-481a-4020-08d83330cea1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 20:00:04.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3+483aHCvlefarXZEzy9bhzeLK+qnwHyCChnWqXevrlDyqRELHYTtIfTgz796tnoLi3vMg9+V6UFfZnb0V2mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2592
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.
v1->v2:
 - Drop the "Hold reference on mirred devices" patch, until Or's
   comments are addressed.
 - Imporve "Modify uplink state" patch commit message per Or's request.

Please pull and let me know if there is any problem.

For -Stable:

For -stable v4.9
 ('net/mlx5e: Fix error path of device attach')

For -stable v4.15
 ('net/mlx5: Verify Hardware supports requested ptp function on a given
pin')

For -stable v5.3
 ('net/mlx5e: Modify uplink state on interface up/down')

For -stable v5.4
 ('net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev')
 ('net/mlx5: E-switch, Destroy TSAR when fail to enable the mode')

For -stable v5.5
 ('net/mlx5: E-switch, Destroy TSAR after reload interface')

For -stable v5.7
 ('net/mlx5: Fix a bug of using ptp channel index as pin index')


Thanks,
Saeed.

---
The following changes since commit 181964e619b76ae2e71bcdc6001cf977bec4cf6e:

  fix a braino in cmsghdr_from_user_compat_to_kern() (2020-07-27 13:25:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-07-28

for you to fetch changes up to 350a63249d270b1f5bd05c7e2a24cd8de0f9db20:

  net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev (2020-07-28 12:55:53 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-07-28

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5e: Fix kernel crash when setting vf VLANID on a VF dev

Aya Levin (1):
      net/mlx5e: Fix error path of device attach

Eran Ben Elisha (3):
      net/mlx5: Fix a bug of using ptp channel index as pin index
      net/mlx5: Verify Hardware supports requested ptp function on a given pin
      net/mlx5: Query PPS pin operational status before registering it

Maor Dickman (1):
      net/mlx5e: Fix missing cleanup of ethtool steering during rep rx cleanup

Maor Gottlieb (1):
      net/mlx5: Fix forward to next namespace

Parav Pandit (2):
      net/mlx5: E-switch, Destroy TSAR when fail to enable the mode
      net/mlx5: E-switch, Destroy TSAR after reload interface

Raed Salem (1):
      net/mlx5e: Fix slab-out-of-bounds in mlx5e_rep_is_lag_netdev

Ron Diskin (1):
      net/mlx5e: Modify uplink state on interface up/down

 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 27 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 27 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 28 ++------
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 78 ++++++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h                      |  1 +
 8 files changed, 121 insertions(+), 52 deletions(-)
