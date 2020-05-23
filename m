Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34C21DF38F
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbgEWAlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:11 -0400
Received: from mail-eopbgr70075.outbound.protection.outlook.com ([40.107.7.75]:1415
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731169AbgEWAlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcvC0Y48fZ0K+ub0vO8oLABUoLdOy5yxvEahZvO1ih0bhwrrU8KJFyiDJ7tBY9ess+PVDwrIFZV2XCYFchyIm5FVQP7gM0EFTciyMLe/zGfFk4OdRg1T1+blvO05DUm+mZdd3dH4KoQyJMu8g9J4r6mAE9oSLTQSaRnzIDMjpvNdSlVpVys8oGdrK2qTngVG4AZ3f2Zoaq64YplH3gxWuYzg3qI+EtHcVimwBC+vWf6xC28aCSzwHpXJW2Zzv44D+3d8wM2ahKBOh2g3OGUwRLqfl7xohYRj2YxNKhJbR9MUHEhQyZnxPzv+wB44n0YBqPkcQNTNaByIYUD4Sup6lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vstTgevk0aeBzeyZqiXwJ01Aag6TaItI6420hQJMsc=;
 b=f5zuZs98D+I45tO7+zkCH5Os+skZLyZuAuLPbvLzkP17a8T5eBVsnoBIkoZPh7IACcYTToCjKnDr8M+OI6SevKhuykXPQOnBi6jy0WkeKLgVCQX65K7ecQJi3R9vNhMBE34E+xTcyBkWPm+zi5zrUIJPWe0Vuh5pmGnXf+mPcpuG1FfZXiHiPRbF7xg6WevISu2jT74cNjzQvxq1aCOAqT99JXQBNV4GFPhF3wjLLlmTLLeN0i3Kx1OsWUtWCZFrmHcR0T8V+igVdqsFxTNsSi569e9sq0FMScX2hqy3YPjMOqYgoCUtFzL06uv8LYkci+vcfCVZPjI1MBKZEjkQZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vstTgevk0aeBzeyZqiXwJ01Aag6TaItI6420hQJMsc=;
 b=OsNGM27qgnJhgh0D4XsFn6XDEjM0C/HMzgjPG5yYdWi5f0X2pulFQx4hgH/NjbM6XVmJ9/xHQqRjMA7X+NZCGl842mW2xNDXxV+gbHry18KDNdlbhRwqUOf++OS365t4JjIap9OinDASs7sw1CXi3IF32boi9xh0YN/A4c6L9J8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 00/13] mlx5 fixes 2020-05-22
Date:   Fri, 22 May 2020 17:40:36 -0700
Message-Id: <20200523004049.34832-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:04 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5d919d11-0f4d-4f95-5ae3-08d7feb1f9f8
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB539104131F8A0C518FE044CABEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:800;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wzEi4vcQVJMTLihZz58UYrqIQfsFsO5ojrKSkHIHI8O4eEbw4db4v190C7HZ7EYItlzC9iWByud2c3XFR2GtNP+kKXaoX5kvj2ucM7bDJ5/LWNc6ZG+rJJvN7NTocE7QhqG9JX9i2bo057bTZ88rCZBKXeBy8b/ye+D5nIlzx8y8jtWhXxXPryKxrJUwAAvP6hfE8oQITrNjulfsgR8k8e0tvmbmCCq9YKWC6cA9NyE7/IaFMUtZlHqU40iKji5g5pnQeoLxProbFM5r8Itg39hnInu8up613ztWyMXX5AzlKLdj2GcJPLKU3UcOnzhjAq5UPu6JnXlbyOJ8PhlDQE1Xd3WeSOW1GtoFPzv+ASgOqHOJH+G9orZSrYKBqZWh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: A3L2ShcoQyu3tBbrRAvY5ED2vsydaIn+ahWLZ/YEa+tv0m1e8G7lRtSPHB8c8o/Ile+JJs9zMTPO7OzVYiTwGO0IE5pmSQckqRpQOZ3vd9zDBHTtSQHlf1D2+EQ4a13f+5hA/12g/k3+K5O/7uGWWksLqKB/USeS3T3cza/giGCPFrwUgE6les1HbIdDFiR0Q11FtaOIEgT2mCNYCQy1WQBdvQ9jZIU4SDk+HnKjXvjfgLTemAdb/Goi+Bz1esBV6mAv86XgF2b4pCsEZuPZlNnG+PG1QrLOynhb6zNfDfWy+SrNx7ahhFYHT0wOkh6f41pXkojr2D1dH3Din5Df9im1yRrF1uS/0Ja2o2A0VTQinKRl0MkJ2fLi87cVihpLP2HLhu4Z93p/KknOYkwuaovnbeAJgVueqwB54caXmyMUbTjRFHYsJNeytas54s4phyD1/9ntv6wnENrK7B7yWf4TOvu/RiOgG68jjqQjRvU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d919d11-0f4d-4f95-5ae3-08d7feb1f9f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:05.9060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JTJcYU5agXG5Cw8BvjcHJA0cczm1U3MRDJ5wQLCH6kWXg84IiywB+l1+IiWG/h8nikcQtMk4tvwKfJ9yCqs03g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v4.13
   ('net/mlx5: Add command entry handling completion')

For -stable v5.2
   ('net/mlx5: Fix error flow in case of function_setup failure')
   ('net/mlx5: Fix memory leak in mlx5_events_init')

For -stable v5.3
   ('net/mlx5e: Update netdev txq on completions during closure')
   ('net/mlx5e: kTLS, Destroy key object after destroying the TIS')
   ('net/mlx5e: Fix inner tirs handling')

For -stable v5.6
   ('net/mlx5: Fix cleaning unmanaged flow tables')
   ('net/mlx5: Fix a race when moving command interface to events mode')

Thanks,
Saeed.

---
The following changes since commit 5a730153984dd13f82ffae93d7170d76eba204e9:

  net: sun: fix missing release regions in cas_init_one(). (2020-05-22 16:19:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-05-22

for you to fetch changes up to 4f7400d5cbaef676e00cdffb0565bf731c6bb09e:

  net/mlx5: Fix error flow in case of function_setup failure (2020-05-22 17:28:58 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-05-22

----------------------------------------------------------------
Eran Ben Elisha (2):
      net/mlx5: Fix a race when moving command interface to events mode
      net/mlx5: Avoid processing commands before cmdif is ready

Maor Dickman (1):
      net/mlx5e: Fix allowed tc redirect merged eswitch offload cases

Moshe Shemesh (3):
      net/mlx5: Add command entry handling completion
      net/mlx5: Fix memory leak in mlx5_events_init
      net/mlx5e: Update netdev txq on completions during closure

Roi Dayan (5):
      net/mlx5e: Fix inner tirs handling
      net/mlx5: Fix cleaning unmanaged flow tables
      net/mlx5: Don't maintain a case of del_sw_func being null
      net/mlx5: Annotate mutex destroy for root ns
      net/mlx5e: CT: Correctly get flow rule

Shay Drory (1):
      net/mlx5: Fix error flow in case of function_setup failure

Tariq Toukan (1):
      net/mlx5e: kTLS, Destroy key object after destroying the TIS

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 59 ++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 12 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 12 ++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  7 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 40 ++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  9 ++--
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 30 +++++++----
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  7 ++-
 include/linux/mlx5/driver.h                        | 16 ++++++
 16 files changed, 168 insertions(+), 48 deletions(-)
