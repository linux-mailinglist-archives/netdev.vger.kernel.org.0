Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F1646E651
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhLIKN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:13:27 -0500
Received: from mail-dm6nam10on2066.outbound.protection.outlook.com ([40.107.93.66]:34784
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229753AbhLIKN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:13:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8OwMv4UZUFWd5kGFuZw3gOU7cY71XqBBts8U3IXfOs5eVCO+j8l/ksln3YctbkbcvjYC2FFN0gpWZpFzxmjm8w5dHNSxW6GcSmG0ztDbvrY3K/3vwxjargNkrbIkkxpyBXNjUXuK9DQMZauT+o6oZBE7LqjcwfqTWhUDaVBOQgY0mN2Pk0oGvdBhP30IK+FT4aZT6XFu9Yks2bGA4nC7CGIvamDWZrYQlhoY+8EbgsP/AyTZsFTqerP3WIbRYyznK0LKiZ/mwMJGTcZK8lVfUtzuX5kUZ5pT4mygWZbR/F9uHyA0gM7EF7ch/BpVXIiAAiGjlH3RAzrh1S4NU/x7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hke1PFUzA5hTQ3947jviALJGOP20+afFFi7KkKAEn7o=;
 b=i2qx+hjNMQvgDH6MmK/56XT440Nu9pcJdOcrrf17gKOFecjJcm5ddGb9ESXFqR6jv0b5H/R2X3qPnhF0f/xvQZurSvgnpOZRLxQKWsFEL4F/ioFE89OCPkTSaOjebVd659ZR4bNT3uq2K3DLVbiGiGGj84OZ2jJqxFT0dcO1YXXZkTEPJeX9P8D3+O4KUBJHcnOpaRIRTEPvsjggEatDXOxEDXzbWs51hySE0cmjfaDiLGs2c/oPRZWhBskmBlQSAEOrdapNKRKg7xxb0Qlnx4EonWO9d289OfHEJKmmZOtj6ir05RTnOJzTCONlhPpWW1trQHNgrKUyMyGI5fKCYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hke1PFUzA5hTQ3947jviALJGOP20+afFFi7KkKAEn7o=;
 b=nk3oyAkpf2bErJKUPFBJvD8k390QgOHFq4aUu5ePyU64P3FKLamsaiegW4qcBHmsEcDHMMAodrmlA8NisMlLB8LiE1NmrBHhPyj6KkrSI6qZWa1Uuo8ElxhCV2SNqBqAaQL+1nS+mD4lBvgj0RS4Y/m0ee/SAkDhOP30N+IlaTElfvePWExzMYACdGOBUi1uyRKogjvCdLBkdwW+6FbvXPApZ5lryzb7wiAV1UdxypOxeq9l/CSdl0zJ1SMNWORe3jIc/ItRdUMFokSKAHnF/Su43tYC4N729vxuSLrgrwXNj1wvx5PJRZT3yQG7lCXjHtHTimzUKu30/f2ZNVVq9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 10:09:53 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:09:53 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next v4 0/7] net/mlx5: Memory optimizations
Date:   Thu,  9 Dec 2021 12:09:22 +0200
Message-Id: <20211209100929.28115-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0076.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::17) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM6P193CA0076.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 10:09:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd0ff04d-5aaf-4b09-7af2-08d9bafc0af7
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB53110F3CE1732E7D5FD5F9C0CF709@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N7+5rEz4kYnDeploBoYbf56PfsPUGXkXCJHNEC0OusVsqeBaS4mw2OmwEHGsOD5mALTINMwuuoKSkh1yGMyUINc5Je9Y/MA3enCnChyIummqoetknzM5l7m4qKsGxIJwscKlYZmf71+43bdd8LZm/TvTHXgqF1g9myxcb7mm7Dc8DhaSpicuMl/wWoPGF2qm3/gOSf7J1dWXYUT0sMdNc71rel26OeCkjUO6ABEr2UcsFiUxtxx6vLGf0fox6oqgwpQ2KNiMaG+D4jgAJulceuHbjus3dR/lwBHFHN9JpkNwNIWjnVRi9FPwxIG0csgTX3A6FZ3Wq6kbTK+CXWHm5VZ8I5z8CoUdUbFr8ysB0yfABeAYivQ72Ct2wspWs2sE27NWbJJEF3QgbeHASH6AZ7y4AWzdTRBobs8AIa1GZbfJhvfD1cJPzATCJ0pOG2TpWVpBpyqDi8pVHpIpK0iQsgIGXqdYUKPqzBbPs174uWXLE/u2a87IT1iUA+5EEjHDG8MIrECnkMLX6NuHLfS+OigNwK2W8jEst2PW0jgG7Ep6bN72eSHJf+jAHB9Vu34m+csSJ5C8uU7KtOVMntbkssrhP9oL5rndKw+QdvPOcu4Fn1Q761dTMd+7NxEfg9+zz99pHX1uUbvGuUSzUwPVJCR9j3LW1LoNocctgJux/nUgD9SNvsrW08OYjVIqRn+2nQcp4POLnUcP0ow7hKKvxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(956004)(38100700002)(38350700002)(2616005)(508600001)(6666004)(26005)(6506007)(1076003)(4326008)(52116002)(5660300002)(316002)(8936002)(110136005)(107886003)(2906002)(8676002)(186003)(6512007)(36756003)(6486002)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sh07pnqeZAG7dHQ5cqoOa0fealRsRe993aG/KNv/CjtDGpwlGAxwrPFXk+pF?=
 =?us-ascii?Q?vTXH475/13iv17CfhVvi4qrp+9TN9/LphHrZyg/d/vnrTKITTXhVcYgLzc9a?=
 =?us-ascii?Q?PP7yULLw9chGSiBtFSCh30kT3/bEm8NjuwSUhkw0mvAjea82ZQNzeWBw+MRO?=
 =?us-ascii?Q?5U9x+n7PmvGUJT1bG/1uw6GkPZ8XZoRAwwUJKcU9JCLqsBoXYSfX2D9pR5+m?=
 =?us-ascii?Q?G18+a0HzVnkXKVtrql4PctZEGdj7P5BOl8u8rOwduLcWAcBXYZPsLBFRocGB?=
 =?us-ascii?Q?AlYTQfcSiGQaJEjx547F7biUR/UPlvuROFZWTCVCf5XVkBUu5Mr7zZB8yOJM?=
 =?us-ascii?Q?wY405fjIObJWJ6MxAJn8N6cWkDlOBJW14vGI2I8wlMzrgCx+2134769n+0jq?=
 =?us-ascii?Q?qZeY780A5tMQWWE4C7Vq5QyD1Hi4JwaDoj4gRSNv02Paw5TGjq8aJ8ORHRSv?=
 =?us-ascii?Q?ealw2BOD+y4Gbe93KHSCnc06zPqLzM48Sc6LRVA2l53JnENGLSR5KNSeC4Cn?=
 =?us-ascii?Q?uaeayen5AYU7a2F82E/XajPPo9N1+Az2N3j3rBuk+9cfdQbgV9ON4S6c1BkD?=
 =?us-ascii?Q?qP8tJnWQSVAkBgW8Pimbn6tFa3IU8xpbjrfjJSmb4dq3xRm4fyvqU/X9ahVU?=
 =?us-ascii?Q?pzo7KvOWu84eh+fl50YByp+qxLbtt2+dHs/NBZJ4wsNvqWzfm1NeLXU1Gdfi?=
 =?us-ascii?Q?hkB25IdBgX8nHVgqPXXl21hhoIjF8grHsufVmfyZfn9r55RT0yZ52QIquGD8?=
 =?us-ascii?Q?a3nW9U9/bF7ur4ItDipaFocP/M/HibKm5G8wvBaoP9+RK29vH3ec5AeWiVDT?=
 =?us-ascii?Q?7LLjSXiw+lkF+NHUH+h1jafmp3JyKlb4N/kEDZoixnMMxo42PrVR02OMTCGC?=
 =?us-ascii?Q?vlu5aA6kJ2dUCGXWRp6CK3mqKLiqRW1lO8w7MzauVzBl8ngkiCZe1wr7u7Jt?=
 =?us-ascii?Q?gUZ8vpGKK7dnfpjY/q2J2+cJ0rWZFJG4a+C6GURiErhoD1++DHR2S0mgZX5b?=
 =?us-ascii?Q?LOPc3+mqqDRLDjnRkHKFl2/b2G8jZoPd/Tid/m4/NLpchJ9AWJMQmtKaIqTN?=
 =?us-ascii?Q?YgP3fKWCzQ5bWjmR/GwsqEVQzXuKmi6S98uY+70rAlIhVhM87Ex5xKFwdUw+?=
 =?us-ascii?Q?zn/OyanA6iOsQHTZ7Pvn+jSv+V3IRwzEFu4337R+ZAy71E7d9SjzGNryTFFX?=
 =?us-ascii?Q?Mh8ZVo7A/cwaqtwQBUi4XZ+vARa78Kn23KvU1+dMQk+KWCGfSw876QkHoP47?=
 =?us-ascii?Q?LRJ3KOE67uBM3JceOmad/zTYqyVjutcEmh5FnBKfXTLo7GzMvBmsWFIDTNQg?=
 =?us-ascii?Q?/iDfmif4YDeBNj8pDYAFTJU2sAhj5v01jfgFCyJ92GAMr/zqqssLw98lz/2J?=
 =?us-ascii?Q?vOuB5N7wipdVzaWUwCd54d6yqkbj+0JqBmOoBHuEptWQ8Mb2GKcVdkCxVdcH?=
 =?us-ascii?Q?Ot7rZQSwLdFT5JB87Ct1VlVTRPnxpkWQLvoFLNZl1b892UDf/ktM2xgxIA3t?=
 =?us-ascii?Q?qy0PCuwkwD/yAmRKZTUxLe3CMZNdxj/+59cxVxaRm+chyYI7YZZmhK0/tENx?=
 =?us-ascii?Q?nOqq2+FULdrPvyQnlLwSb04QL8JPyK/oE6NKzjNSAWqK3JXUTr8IeDsmyxhu?=
 =?us-ascii?Q?0B/WD2VHy7aiMKDF9bKsWGA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd0ff04d-5aaf-4b09-7af2-08d9bafc0af7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:09:53.0192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uMbPV4i97nXZVjB6xcdLo+iyzeqMIxJjBbCXO3piWnAAopBr9h/3aSoU5JEsR6zsWZRUHVcH5ygIzPiu75dpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides knobs which will enable users to
minimize memory consumption of mlx5 Functions (PF/VF/SF).
mlx5 exposes two new generic devlink params for EQ size
configuration and uses devlink generic param max_macs.

Patches summary:
 - Patch-1 Introduce log_max_current_uc_list_wr_supported bit 
 - Patches-2-3 Provides I/O EQ size param which enables to save
   up to 128KB.
 - Patches-4-5 Provides event EQ size param which enables to save
   up to 512KB.
 - Patch-6 Clarify max_macs param.
 - Patch-7 Provides max_macs param which enables to save up to 70KB

In total, this series can save up to 700KB per Function.

---
changelog:
v3->v4:
- align devlink_param doc of EQ size params to u32.
v2->v3:
- change type of EQ size params to u32 per Jiri suggestion.
- separate ifc changes to new patch
v1->v2:
- convert io_eq_size and event_eq_size from devlink_resources to
  generic devlink_params

Shay Drory (7):
  net/mlx5: Introduce log_max_current_uc_list_wr_supported bit
  devlink: Add new "io_eq_size" generic device param
  net/mlx5: Let user configure io_eq_size param
  devlink: Add new "event_eq_size" generic device param
  net/mlx5: Let user configure event_eq_size param
  devlink: Clarifies max_macs generic devlink param
  net/mlx5: Let user configure max_macs generic param

 .../networking/devlink/devlink-params.rst     | 12 ++-
 Documentation/networking/devlink/mlx5.rst     | 10 +++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 88 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 34 ++++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 21 +++++
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 include/net/devlink.h                         |  8 ++
 net/core/devlink.c                            | 10 +++
 8 files changed, 180 insertions(+), 5 deletions(-)

-- 
2.21.3

