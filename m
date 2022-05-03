Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7930F517CA1
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbiECEqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiECEqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:46:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD753E0ED
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:42:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKilBx7SE9PmHjMtyjdbYp2Zneh+/XMGa4FJAaRKIL1sczIBET/lIhg0untjySc3uec5D+jMr4jy5G4eJUfpqv2sbi4y8c6wC/DycK1m8adysewMZSIXe3M5Bwlhr4Oj078P7NnacZp90n7AuFji1nM4hZ0RXkBUmFsAWyzeRsYu+KXLAvTTVY9aIWP1Q7oti4qCF14ToG2wBLTTM72qgJCUW4iHe1XEf/cemJxaOZW5zuKEu7W28JaMfD64pT//G9oIHtBgoUsaKOaHc+IFBaTe3n543OZrWO9hRCdXiNaPYmc2ILd869qOUqB/5Gr7euAdWQeAemPvI3+ap2Iyhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gRtBf0QVilKSMF1eSlLCOjQ8ix9xqQW++B0QmTJuCpE=;
 b=Cg+9Q22dcqSbhY3pcqwcC3m0f7eKi+A8SlHC5QMeyqVTY6t+SUYJTRaheJpB5EM+uIPmYIBxcdj83jxKarcAXy6A6HC5DIsdmJn5vQXEFQ/FqlsrmiqDYGISfniqiRgVcXulIY3RtRQG/rWmtvDzwSAIJvu44hL7N5uusESBJZNDqkFggo/h15qb+vayGVLqH5UqHZc4FzC2oyFi5IUyjifmoj4635hp8Rft+wdk4fbgXQSNCLTk/B5J2yL9eYt1gU6fdKLA3+UrpUzleRmI4rRwkz8XZd2FOUpBO724L4Jn7ZF7n89HIHXf3ru1czrmUrPZHeUhAL0RgePsfoKZTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRtBf0QVilKSMF1eSlLCOjQ8ix9xqQW++B0QmTJuCpE=;
 b=I+WMPEE285uwCe560FTA0/ZhNWxkR8LfDg9rXoZCJ9PUjrOfhVVHR6ZX640JmbdupLsjMDOUiZ8oFsclhkNcmusarmTb0TYG3iG/X5xbO/Acj1DCgAGqi2CBoMn7GeAinHafKc2xH4xkeqFPyc1brAt5zi1mTZPLsZ2kTdDFoR4FQD4Hqt3tYL+Nfh1aimPysgV6xdffbnFKra1BM71JTENHMZmx041boiU5SpJIyh29FxkGmL2z0HwEWdplJiDbmNj+km8n3BhIkss+FQVMXwrtp0TEWmLLxCVdxw4ebtJxhl50MukNxjT5i+eXm9BGrVlCvoyRSYSlrvK57utuBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB5005.namprd12.prod.outlook.com (2603:10b6:5:1be::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 04:42:39 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:42:39 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-05-02
Date:   Mon,  2 May 2022 21:41:54 -0700
Message-Id: <20220503044209.622171-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0387.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::32) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2fab171-9aea-429a-4d5d-08da2cbf5a5a
X-MS-TrafficTypeDiagnostic: DM6PR12MB5005:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB5005FF87321A00F6A8CD1B1AB3C09@DM6PR12MB5005.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gMw5jKdkU4UTu3W5wW4WVhibLHr6eRNvUGua+ezt7fYVy96yJSOtmhxH2ANOR41NtY2mC9WbGUcKUH8kdwv2UBdXHTm5mWOItWbAs+zA7Q56c5PRqKpQkp3+m0MHtHmyb+0IleFBzLD3MM0m+hei8kONx0OTRMisNkWnAiEkbdxGqMMmeEN+SBW4+eR/js9vyDzkdHj+IIA32NQB5k/w6XIQ0Fv59bw9Tpk+BGhs6ll8gDJeNoVGu/jAaaQB5QlCUCtg79edXF49Xqd4vFSrY/id1fRM6I+b2y1pkzOmJuQQ3zFG0vF6Iu21aQy59ES3/EJbb4+cqTC13Qs9D7o+rBjbr4UMQke0CMJw8vGCAumiRzg7+AIh0/hlS3YIJclrTBAjr6Y1X+MTxup4ScNfTGbnNjLqS363dMtz/GjR0G0MypQtkXR91WrrBv7+JrsacbojO4+myH36pRRz/3kh2NL8IZnClkg0fpuydHDIAo56tCN7ZlR8yuZhPl3CZ7srmWZghhp9B9vvzrdv98732+nZuk6AwxPLL5ie87DJ41FPf/kyOyqyg5MKwdsrI2egGGaUN0c5STfgTKF/rEBcntHiDhomozyHxB/OoPa/2oy7R4yzSjLn2616PyIZhNAG7UDA/08n+NX+g75Nu8AeMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(186003)(1076003)(2616005)(107886003)(15650500001)(110136005)(316002)(38100700002)(508600001)(6486002)(66946007)(86362001)(66556008)(4326008)(66476007)(8676002)(6666004)(6506007)(6512007)(36756003)(2906002)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d5aT8JmYNK9WEDs91HPTk4GbhZ9RwBzNEI9KiQvOPbG+0su+cFqAwPQnvq5Y?=
 =?us-ascii?Q?IWudapOIkbmECs3tDXjFfpVCKpAKOl9XbDsZSOBhfP26+35GUfrmaMtq5NeJ?=
 =?us-ascii?Q?FfdTpP4tJnsVArBRzg1hBS0vTkwVfqaqd7zzysN2J6ZFb9IwdpA07GXDs5KN?=
 =?us-ascii?Q?bD+Abqwr+FIpOWCOmC8I957bKNZv3k8lZENIBsO8iOOtwQu0fcj2bAyIAOzw?=
 =?us-ascii?Q?TfOTapf6NAPUpJWjxi5OEfGR6CU9Z08kUkv+lB1mq7/7BKPtpGWsE/bJzfjm?=
 =?us-ascii?Q?SN89Q8weylelfTH5kLVS9mgDGoWJ34+NWVyvzREqWnBZ3+2DgmU99hzZJNMy?=
 =?us-ascii?Q?sXtVNanraUzHdq0Um4g+Mrv7L18k2JBnolAQ3h5mRHST1bvBpzAjyNfDBjKP?=
 =?us-ascii?Q?oSnjQrcaG0LZPQqrgfqRkkeB6BXkZ3d58NbBSjB/pjoD/m6xg5PT9tWmfR2u?=
 =?us-ascii?Q?2tIJ2bsOC+qtQGcris4XmqArLXSKmB6CluBy7TttxQc/+FdJw82TeGPVFjct?=
 =?us-ascii?Q?ffVRRksV8QhjDj8kqaabtqArYC2wBN1MGd4L6ljyYkcxqyx8rmeGQmjeQzj3?=
 =?us-ascii?Q?phGZMSXNLNDUyHLflmHFB+crMcQbOo9PxZZ7YHVHKSyZ8ZGxE6o1quZaXNfB?=
 =?us-ascii?Q?17X02lzs6+Ws6lhy1VTdnB+5mAq1rXQTNIAXKE/+srgnNsWpazNXgFX2lQBD?=
 =?us-ascii?Q?hCPnyccRCjBmxcmvz6RDX0sm47HaR4dZGnRKDGR0B+Kw+EH0Qfny00djbD+v?=
 =?us-ascii?Q?JQ6Q0xLsbC1Al/5dSCxMpz89hIURhH0jdqsWaqH8YcKM9cZ6oqwSLzS2HdVt?=
 =?us-ascii?Q?an6ykfLO9lxq6B6gcnxqNhUr96H1OSMqlKsjGmnTMQMH3+dilEipdOHpgcor?=
 =?us-ascii?Q?1cozNcRsVZROxT7IHYfCtrJrsHJieHXT9ODwEYVDPVPrtwciIiSzrEgCbfGa?=
 =?us-ascii?Q?TjDAS4fD+a4QoVe9jtWKjBjgdO1onmL8T9z0F/MDlo5+TURPZVmetXtFzKtx?=
 =?us-ascii?Q?rE6kTus3lsNN7QNgXR+MQZD5pn26uKB/JOLBO7q+oV5nZS3ku67xWqzAN9xf?=
 =?us-ascii?Q?pY5HFrGLJ4dVNEXk8DCUP6i/BFjsvgcm/yYEktfCUBJF/U0KjN+tj2pVnLpv?=
 =?us-ascii?Q?5UhW67k9FAZ/GKEHfIS33CPYxNKd1I5Xq9dyqBdDa26GAv+N8jdbRMQ5Jy0k?=
 =?us-ascii?Q?w3BKItri3hxin5ihmom6UOAx4+h1uG3xRIpxJCe2Umyitc7GiAk5LvDH5yZ9?=
 =?us-ascii?Q?oaBU8DL/jeXAsHbtrWIIroUHshIQjzm6dt/XWnoGWOU7dN5CFILMK0vw2OA0?=
 =?us-ascii?Q?qsUKxJA9HCGGPo2tBv/kjw2/wjazBs3SaO7OB6xXeGIPCN+w8naUivufraKU?=
 =?us-ascii?Q?iOkuLe5Sh3T3B7AkuLsjoAYMow9SA5OeojSMyAVj5dbG09pjwPFfwUvu6GZE?=
 =?us-ascii?Q?TAvi8WjDEaOIizjbxLPDhvSc2SsIyNmZyTWDzlxo7K2cD4LpWKH3iL8owUS9?=
 =?us-ascii?Q?3tK3FU20dHG4ByfA42ec55fYJf59bSUTyMjMrLjBOzW0F3Ussm9Eu6Z4dApt?=
 =?us-ascii?Q?ui18LPQWKuV5iS/szF0jTEkyurOMKan0PnwbWSMNxmvrpjKzluIwa70c75gn?=
 =?us-ascii?Q?9f4g35Iz7nOUttMzlpQxzj8z0lFBCqSIi+qjQf4fuC4tzBzzIxIjBjgd29wl?=
 =?us-ascii?Q?LPvOdSDyOe6usJCjkaHvsvO0GF+VfzF6d8jSJNbrKx0QoTZQUj9Whb0OznFm?=
 =?us-ascii?Q?vA2oP6qABvLn1OK1zAIVxlNlKXBncO0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2fab171-9aea-429a-4d5d-08da2cbf5a5a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:42:39.4620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XkS0s9mV2mJOB6QmZQgBZ3KSEgQRDCCnUj+cSc1r0a0uL6Qf9u4JYJ5f4PJ+KVDy+DBqW/JymvJNkkh4kpJu6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5005
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides some misc updates to mlx5 driver and a refactoring 
series for flow steering core logic.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 0530a683fc858aa641d88ad83315ea53c27bce10:

  Merge branch 'vsock-virtio-add-support-for-device-suspend-resume' (2022-05-02 16:04:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-05-02

for you to fetch changes up to 3a09fae035c879c7ae8e5e154d7b03ddf0de5f20:

  net/mlx5: fs, an FTE should have no dests when deleted (2022-05-02 21:21:16 -0700)

----------------------------------------------------------------
mlx5-updates-2022-05-02

1) Trivial Misc updates to mlx5 driver

2) From Mark Bloch: Flow steering, general steering refactoring/cleaning

An issue with flow steering deletion flow (when creating a rule without
dests) turned out to be easy to fix but during the fix some issue
with the flow steering creation/deletion flows have been found.

The following patch series tries to fix long standing issues with flow
steering code and hopefully preventing silly future bugs.

  A) Fix an issue where a proper dest type wasn't assigned.
  B) Refactor and fix dests enums values, refactor deletion
     function and do proper bookkeeping of dests.
  C) Change mlx5_del_flow_rules() to delete rules when there are no
     no more rules attached associated with an FTE.
  D) Don't call hard coded deletion function but use the node's
     defined one.
  E) Add a WARN_ON() to catch future bugs when an FTE with dests
     is deleted.

----------------------------------------------------------------
Gal Pressman (1):
      net/mlx5e: Remove unused mlx5e_dcbnl_build_rep_netdev function

Haowen Bai (1):
      net/mlx5: Remove useless kfree

Mark Bloch (9):
      net/mlx5e: TC, set proper dest type
      net/mlx5: fs, split software and IFC flow destination definitions
      net/mlx5: fs, refactor software deletion rule
      net/mlx5: fs, jump to exit point and don't fall through
      net/mlx5: fs, add unused destination type
      net/mlx5: fs, do proper bookkeeping for forward destinations
      net/mlx5: fs, delete the FTE when there are no rules attached to it
      net/mlx5: fs, call the deletion function of the node
      net/mlx5: fs, an FTE should have no dests when deleted

Maxim Mikityanskiy (1):
      net/mlx5e: Drop error CQE handling from the XSK RX handler

Shay Drory (2):
      net/mlx5: Delete redundant default assignment of runtime devlink params
      net/mlx5: Print initializing field in case of timeout

Ziyang Xuan (1):
      net/mlx5: use kvfree() for kvzalloc() in mlx5_ct_fs_smfs_matcher_create

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  | 20 ----------
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/dcbnl.h |  2 -
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |  6 ---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  9 -----
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 16 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   | 18 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 46 ++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 17 ++++----
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  | 21 +++++++---
 include/linux/mlx5/fs.h                            | 12 ++++++
 include/linux/mlx5/mlx5_ifc.h                      | 16 +++-----
 19 files changed, 109 insertions(+), 90 deletions(-)
