Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52EBF5A7432
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 04:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiHaC7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 22:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiHaC7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 22:59:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD52B5141;
        Tue, 30 Aug 2022 19:59:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTY2PMmTnf3qJ0mVLsOP+rWlswN7aXpyGSCtTp49el2AxqXIX9XUpngzQ7LEKWubM/tyKqAXyZzYMKwrYV364jVJjZqzgSqA2rCGZDIonD7F+lzqnzs0JXJ9hTrxiANKz0lC8qEPHEu79ub57sZKcR2GzaRJ9MfuRV3wb7Z9zQfHogFGvIjBHeP1PuR3Jd25IBwJPAakp4ogEvbsMmoWYODUfqkWxA9Qufg12fBiQYeD/DPH0CuEb+MWaSUCkQ8Jg7xWNoroqJcMlYStLsGjeKB6rfOxThg0r3SSxJDUEU9kPVtxK5urcX1Oi7Akn53SC1wCBGxK753G1FZSBUO3lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTjm3yOepII+qFbwZneDwfzcLuWFrd6Pwp7CnS4ki1s=;
 b=apJntQlJfG237rdjqoOy3egi1STX+QA3rYk7b945+lXzT4mNMr//L7z3BIB8cWhI+G2yJ4j06tzFd4248N3QSym38LFw/hsSCckFjR+eiB5krt1PuxEatcj0JAaWfMJkA4C6x1rhmB4pS2DimapeTdmpl5uAoCHEemM8AKS9DacBj2PIIcv8xOmIGd/6KITJqNIKC5Dn8ISgqd6Abky6JnKzylVUf/I4xysnuG+XXRYtYb/Ye1slgzBshTd1NgLa1C1Sh2rwhDkAw3hBHjwHFiHRi1kBcwHltu+JPcGwm2gTgEUq/sd6qDOVNpY8rjdgEelRCtEa/3OKGFyMqNqXdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTjm3yOepII+qFbwZneDwfzcLuWFrd6Pwp7CnS4ki1s=;
 b=MLrlSiqfeISwhEhq2oTUrxt+XqMbkNEvww6ATpZe9EOWEL6k86JDmzLqHXYweXFBDC72sW8PybPSj46HR76DtXgkQ7Rc5hGK3CYQthx/XyZxS2gMKnvLxbXbpQvnK1OWspB0LGsIp5uYMzKJoUQ9nacRLUCFnmbcxyyuAP0pH3N1Bdg/t67ILgpQqOCLJgdaPc8KwLmQsOlxEj4Dx5kjJNcw0HsC1UEnpC+b1StEZi2hZjg5Lv5GPx94F98OXKLA0hR2KZDYKHypwuq82mCtCIqNMK0FyGAfk3DRRkYJTsVpO6tCjjjYOlr2CR/9WQl+C1K9N3LCoZP/UCSk8y09DA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by CH0PR12MB5027.namprd12.prod.outlook.com (2603:10b6:610:e2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 02:59:04 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::51f3:15f4:a31a:7406%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 02:59:04 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Benjamin Poirier <bpoirier@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net 0/3] Unsync addresses from ports when stopping aggregated devices
Date:   Wed, 31 Aug 2022 11:58:33 +0900
Message-Id: <20220831025836.207070-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0075.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::15) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 224d6bd1-409e-4589-8e62-08da8afcc35c
X-MS-TrafficTypeDiagnostic: CH0PR12MB5027:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ks4xp/XgETzlln21Cu37hVTCoSTF4JQDhRry/11kM7Ky4DmNN0YpCWZaNgHNPe6HRPZyieJ4T+p9J42SehHGVYnnRocrJUAF+u24vX4KtOevY59EPp0Xqs7dYvJp3pY274kgRD07y4BZQHvjuKkeHu9I0rc9urhWC0cRXEBTNwW8Q2FmfewCv1Q90YNNZyQglQLQvQMixamaDmg2nVm77OxAX1u12TzwY7Udq9ohD8+DmUm6A8DfU1YJSsLf0oB5P9AGYZ/iUqa6rL4b9NlmAHlfuUbTSTGCHTsVl34ljhKM0RdE83QUIYqmwBQ5JUVnjhrBkZ4npGd+E05kRrJ7jUHFAlC2O4CpeaPXd8/QE4MXR92lhEoqyIpODJMpeoWI0cNF4721sVjBVkx8N6FME6zSTVE8B0vLg0A1sUL3fMRBDaFj3wel0nGFVNxMhdROtqIAcbyNTWSD5wfo7sRvQQlJYCUGQ5p+fnSNa47+5QrDlCQhB7/6sbDTjjr7MPDkGRJ8urQ+mmgSnjNKiLiEcLQxqx5ANcBToeErEhmp7njRuoUPx0lxoBNy5ZV7kR7YXHPnbi5v2x9Eby5V6aJr9svqa8fgQMt3VI6uyLPga6h9cmJgH+9/YesvL6Z39DHMp004e0Yd4HN/DPQ0q8OZgzqNbJaIZ68PbmGhtBka68LQ9Kg6j1dBfCiMChha/O4ArIN+z0kqBcc0VjanzFWSmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(186003)(38100700002)(2616005)(1076003)(26005)(2906002)(6512007)(6506007)(86362001)(83380400001)(66476007)(66946007)(66556008)(316002)(6486002)(8676002)(478600001)(4326008)(6916009)(54906003)(8936002)(6666004)(36756003)(7416002)(41300700001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IARUDUeakSEfLsY1pyMW6gUpbSHoAa43AhwkpyMm529VSfEloNi2PV1RgjPS?=
 =?us-ascii?Q?5ZrApH177JvdaDg18BRp9S3PI7USw+wG1BXljTQSrzDadzgyGXWn0DRfE9zt?=
 =?us-ascii?Q?6cKOhXCSgP91ri8dY40A9PLNBRHq6MkVIQKH84H5WdkOEVms2WUhMp1Qkism?=
 =?us-ascii?Q?hkSc92a6coPl2GPV5dOHMk76a86eYpuWshWCA3pwUk/2D8y5RFvMNsUp0h6C?=
 =?us-ascii?Q?KOXVNvaUeX1O3V17+ffnnna1jnB7xqys8Nfq9wVtd7X+ZUZRUGEGHA5GnXVh?=
 =?us-ascii?Q?WNV39ju+R571ue1tNFRa9dTap2FxD006Ssz7A8J7ZuOssiLsDyLmnjtycynH?=
 =?us-ascii?Q?8BSz3f04pcC/PppQU1mMO/3jACrj7fbL25mVc2WfFRdwYXvJAbocYwCGRdGp?=
 =?us-ascii?Q?4ir7YZjuj9gBjhggCdkZ3qWrj5uFak1CSZYcT8ZB6ZgPb6y3tUjxHjjyGoMW?=
 =?us-ascii?Q?+GUxuTtX/pT/WMN+TDdxX/4duFDRvTNhu508WGytSwXNmaRzYA18MsNU45ZS?=
 =?us-ascii?Q?eBJcYlekNi72xXUVj9y1XTn0ef4qsCulL9Bu3mG9F5q5aAAU9fgceWq27Zj6?=
 =?us-ascii?Q?pKGo03gxMfDPOLciFiSZdd3uX2V/UXNufSK9UwEKOaOXxuginCBS378qeU3a?=
 =?us-ascii?Q?iLURhgREPecP5a1BhBGVdrTLYvmKFLQ04c53Z4eTXWsj2xQeyFHweLSxLQxg?=
 =?us-ascii?Q?0uTwRuh/vNA2TFM7RMuEXytFMxlB8c595u6nwB0ILSIFKgRZE/qm5ZpeN6vn?=
 =?us-ascii?Q?NfGtIFBM5eIGQS3shlsRvib3hXCITaK/l7+XhlldXPyePngX4a9BBk8RMm4h?=
 =?us-ascii?Q?Ys/vy54kiQNwWZuXK1Pn76fbqB1UDhslV86H9E+U/DGFoWYlrotuS1LleWsX?=
 =?us-ascii?Q?6cC8OMJnlKRayloaI5EfoJuXmKhglnUxcxnJJL4eUdGbaAF+HJOvY80BzpZ0?=
 =?us-ascii?Q?2MWjkt6RR3WMSEEYUBkuL3XQiNAUMCc9YXyU9BNC3aWEoB2UY/tqvF8km5Zc?=
 =?us-ascii?Q?DhlWaHsBPxs5XG/naKHGzp7gBMI/wSlY0c9CZ5R1kC+DC/7skyAaitRQWv72?=
 =?us-ascii?Q?yT+P3EAcrRY368AidtadyvfewRuU2tITOm1ZSaQJSiH2yX+8FiNLyZ/8W2Cb?=
 =?us-ascii?Q?whckF1viRcS/h/IO8jO2ww4hQWMlSQOWlx3tFt5MA7QWEjx6yRaZKkGLFWoY?=
 =?us-ascii?Q?DdgVQOMsw9cb5WnRxiR5QqzXwKTG1HleY/6NpeXTkhNwZMc92UZz5eSPMaZk?=
 =?us-ascii?Q?r5SuBsGSXqrW9nKMrsCxBo8Epkghj0c6BKEmaga7nREAvRmC49Gk0/46I+aV?=
 =?us-ascii?Q?Rr5JELcApZBSUlrvIxWnNYFoSV52sjim8SwScLfvDmDlH/W1d7z/U98Y4FWu?=
 =?us-ascii?Q?8ZoCzDJNKkIJHzM7YqbYlsme7vlK8qAa6Vn2OV0AjS3ZyoVfO635T+fas1Xk?=
 =?us-ascii?Q?pXk4cu3JDadS1u7I6u39ZY0Z0+v2/CzrljO37h1q9ixW7W/Vmxg/DyXbFxw8?=
 =?us-ascii?Q?r8vRQRVGS512ylm2LskN1LMkMApL4QfWUnsylNjouvLC3d/JobcMNj7qaQ0a?=
 =?us-ascii?Q?BObyMDoTth1qiPp00NlYEFHnKBVEsLmXX3nhdc+b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 224d6bd1-409e-4589-8e62-08da8afcc35c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 02:59:04.1297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SW6obZZFmLtlexNEkzfgUCWZ5HXtGfW0PD5mx96f3FCNFoAfTakbmVj+I3kaHST6S6K/y2EFAEqjVAEOynZDJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5027
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes similar problems in the bonding and team drivers.

Because of missing dev_{uc,mc}_unsync() calls, addresses added to
underlying devices may be leftover after the aggregated device is deleted.
Add the missing calls and a few related tests.

Benjamin Poirier (3):
  net: bonding: Unsync device addresses on ndo_stop
  net: team: Unsync device addresses on ndo_stop
  net: Add tests for bonding and team address list management

 MAINTAINERS                                   |  1 +
 drivers/net/bonding/bond_main.c               | 31 ++++---
 drivers/net/team/team.c                       |  8 ++
 tools/testing/selftests/Makefile              |  1 +
 .../selftests/drivers/net/bonding/Makefile    |  3 +-
 .../selftests/drivers/net/bonding/config      |  1 +
 .../drivers/net/bonding/dev_addr_lists.sh     | 89 +++++++++++++++++++
 .../selftests/drivers/net/bonding/lag_lib.sh  | 63 +++++++++++++
 .../selftests/drivers/net/team/Makefile       |  6 ++
 .../testing/selftests/drivers/net/team/config |  3 +
 .../drivers/net/team/dev_addr_lists.sh        | 51 +++++++++++
 11 files changed, 246 insertions(+), 11 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/lag_lib.sh
 create mode 100644 tools/testing/selftests/drivers/net/team/Makefile
 create mode 100644 tools/testing/selftests/drivers/net/team/config
 create mode 100755 tools/testing/selftests/drivers/net/team/dev_addr_lists.sh

-- 
2.36.1

