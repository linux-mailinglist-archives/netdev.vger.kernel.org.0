Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D744364E007
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 18:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiLORyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 12:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLORya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 12:54:30 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A03425C61
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 09:54:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtXC9R5UO6yY/UUM6ZjiCjYSnWwxiSMF7vyASpTO6+tsPGtFKhDTX/mWM0wp0Ld+Ru2zcbP+2MXmCKz0cLpa92kIH4UR/eIOr4lA+VIkSSHfUmsKWPU03PHfD4jna6GH79BFelwd10LKTN7+frn4uNh4hYwlo6iMRr6r471JIc6IxhXRi5p/L7a/xIxQWOsmIVzNF7f67YOy52oEog7diyWUvmuNEvZbV40X53ZAHWiZ15LGt4n+OsEpxjRw61Gy9Ne5Dy8jJnQplQHYCM9AEIG7ERKMZAoaHgQngzkoMW3qwPhpvaPG1HetOJep2FCGrVWuQsDZ8EtvGs9344rFgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apx7P7Im6PZ0su3JI7J2Zo88kpsKJvdvFk24thMuMrI=;
 b=VuEXbw17MUoIqF9yaqbEfM2DOLP9sA/xjgRqGPx0r3GE+xoKhwUkTeumS2EhNUsBaecjBTGihr52SoGqEr0S9FE56MK84/vhpAyqnlxZgXUjKQk3UQ//RsMXNRkT6ZPilS0VNlDVKBj0JDZHXo4ZJPwij+0nXKiyjLJVm5xleVbFB+WQabVJzYzuWFxHzSSmujHFTuF08nl35iygJmgih7oAX+TsIxiLinfGBVPGEX/jUIlS4J0L5Nv4YAlRNY3CJuPF6ic6xGka4cngWU2Ayro8ifeAmdawDMgnic90SgXONG6Ima5QQDknlD0fCUDb/sVuPdSNE1B+nm9y+7cSlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apx7P7Im6PZ0su3JI7J2Zo88kpsKJvdvFk24thMuMrI=;
 b=VuSl4CiYI2pjYrVveJsDI6nGAxuJhaBvjCku8qabFDqB3HkLP8BKHOH/euRa8f0zuNTLgXNxvGTFdIeweJZ4v5bkO7spO67zdkrt7Newv4ZRhGlo59BhZ8xCnYYXnn7uyBQsQ01fev1UgVBuxKuT4DlQ0/h1aAJyHsWCsJHT3fcy3ETec0dmFRTaFNuSRRhm47nxFZM/k+M07BaQb6R9aMd0Kv1MBIuHUWXcr1Kl3SFAD7SxVzVP//wShPbWaj9IJc6aislyAS8zR9A6+tRwz+4pCjhPrETQTl/UnMADa5lZufCB/M6HwY0Y6r7WjBpPdrtcoJ0T90wx99o+2Ry0Gw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5673.namprd12.prod.outlook.com (2603:10b6:a03:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 17:54:27 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:54:26 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 0/6] bridge: mdb: Add support for new attributes
Date:   Thu, 15 Dec 2022 19:52:24 +0200
Message-Id: <20221215175230.1907938-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0150.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ0PR12MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: 95a3d8c8-a0fe-4a82-4212-08dadec5685a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MLO2wCWhBD5jz0C9+xN0I22P7x+NqvlwPRUUSAwPuwEppX9AROI3/twAXDgb1Hj3aQWCGN8pbMXz5psLn44E3GXHcQw2TI8NcINxpoeis6qVIVdG0yXLAYpawnDnuJ/yGpi63J1zSIe4uCxtZdW1ecWSqs3qivi6A5I3eNmB58STFMhptFy7WiWp7aaUkQsbBS7tJx5sAQRpfls7bf/XXMg5RsHAmhI6QMnsDd71AUEVO8Q5YzsIecXMVBJ/MRL9izrqV3IC2Z1s/OdNuKeAKjeYxyn1R0BxbtsvQiwS3K9aP+0G1xYZ9qH1Gm+QP6sqcOIatKYb3mlOO9McrZ4Kb8M+QE8kgbPIZn3pSJacdBd2+P0MU3dHLv0EApPJILBF90X3O9kLv2cbGTeKlYOlPgbUJVadQwP8iHU8/EtkMKzKcZmEPSCegBqqGljOPs4BAsWBx5LzCvd46Z0dsjYAnImrifqbs28OXeIkaL5aTNWxVIzCfCxefUvCJSyFRTFpIe1SKsxefcRcUgE/x4SB0es8ULNuhYflkP8Y0aij/LI1TH40PtMV4iKm5kOtMiSFK0GpDwnEWV+ClWhBcu+wBRVkIugtVfha4z+K3l3peybHSyxh0rCC9nL60o+xVQWbARO5gtRHW7MB57VgzLA4ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(136003)(346002)(396003)(451199015)(6486002)(316002)(6506007)(26005)(186003)(6512007)(38100700002)(478600001)(6916009)(107886003)(41300700001)(1076003)(8936002)(83380400001)(4744005)(5660300002)(2616005)(8676002)(66556008)(66946007)(2906002)(4326008)(36756003)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3/l09c12sHyDyE5NMFGGPalPDEJjr9LtAT9wZTifVEXI9EcexqxmhHls55DU?=
 =?us-ascii?Q?UEVV2D7sbT+BNJfay2+X2PY4fzbbyXzZkmdo2dLKFLdTIiW72Puv/lSGKoDu?=
 =?us-ascii?Q?lCLwxme9Ch5eckTajnCbibMSiLLQz1jn59dMCL3ejNvRNoNOi5BHdpCq5d6c?=
 =?us-ascii?Q?CFrva/AhqzkEURFFcWWKOa4qA+JWaGl+dWQ56XxibTSgb1cDdyps8h+ivMxk?=
 =?us-ascii?Q?qUOUsddS1q7Ab0MD5OoE7xvZuz4WcZCQHtdeJfGknqRNYIY8bqdLgO+Zeu2a?=
 =?us-ascii?Q?Jx1ASuSjWyNGn9CXEOnmvYAQ8jrnguCToBQxkEgLP5U1q86OZOG04zDV4yVh?=
 =?us-ascii?Q?sAnZ2rJrZ6FOMmyAqF7I6QGCAAATAEpSccwaOm57nhDFqOK1fp83a9ieGfk9?=
 =?us-ascii?Q?+HATVdehurW9mR1/jLn08WEvMNZk8MtWdtYKszC0af5VvMKuPmzBZ/45e32z?=
 =?us-ascii?Q?Jxy+Pfr6XeC8WEa0BOWsUnqlRlBKg3BMk2CwouZ43p+oN1xJ38ARSYLR9uN2?=
 =?us-ascii?Q?1HrVzNyVLNph1/FaIJiyV1UGtaox0EgvhB/z5aYXeqnjp6cB9W1xcJXKRGkb?=
 =?us-ascii?Q?NTRJzQmObEKd9YNu//gzqvUp5d13E/D3oUPsqGBOJ/YOuwY9z7ihzWcin6an?=
 =?us-ascii?Q?XmfbKMf6Af2zUVcevP8TYT+xKr1hdTmgeGB+Q4tLkKpz/KM5gDNwcxyACQKL?=
 =?us-ascii?Q?HXpaxCOyuZJ8vPHx5pP618QhDSezoEvYddtwDlm2mLcM3wffOWNeYi4vmZxY?=
 =?us-ascii?Q?MwuGlzve9fcH0soBgLnPDqMUv2ogbnfCvgJnHgsJh6xy7RGHn0CZsufNTggA?=
 =?us-ascii?Q?50N5PMXRc9yj9FL3k7e0BIugpgs1MRtarz10fF/ELTbGrVG0BcDUjhUiYSgb?=
 =?us-ascii?Q?MAF9SebW44tv9IWc08seY25s9pHH1t9Jm09XxcqqnFIEZgofC25MB9alVr+h?=
 =?us-ascii?Q?Wn2H6e2LvBeR3dL77zxZlzUTI3+F5YIhPO0ebdBC1BrGg8IAw9W/Dh7vthDd?=
 =?us-ascii?Q?1rVVTg904EotNWesaQyxlIgUvB/cN9DHbOsZB13SHi9P8Phy4j3a7Hw+rg5j?=
 =?us-ascii?Q?8jBip3dkSry4lDMHox71SsFUHd39iMB5j/NjZg9bIvC2OM3d7uuhxEewDbdd?=
 =?us-ascii?Q?UQUezFiyq2GgKyGZ0xwmwR/mDQ4iFNpgi8ZQc7zrRo9v3bWAjlsAiaNoZhGg?=
 =?us-ascii?Q?9hM3RZDIsPoz9WX6eT3KC7ooOqDdUM2Lh9aoGRdp8A44H77fzDmR81Em1HLe?=
 =?us-ascii?Q?eHyTaAv6GE2rAms7VPBFDauvN7mlvkHM3E/NZ0SW0fDqAkvziNvsPAVkZNFi?=
 =?us-ascii?Q?GPQfYCE9i1qSXldfB36FNzEqz72L4lOesK7vR0FaJYaPBl/BSKGXuRFVL/3l?=
 =?us-ascii?Q?+Xt1MojXiDi3a8lguZvtqnKu1Z9sZNRl1gcofY6Gul+Li749RvlmxBeN+2i7?=
 =?us-ascii?Q?Nt/7aCvX1lz834+ZqMANN2st3yyZj+ZBascOnPs/6OPZI6vtrXGmiJnQc3V8?=
 =?us-ascii?Q?o1T2hQAIPVXvTzLjeNW5q6/Xz17VkMQPAyn5kwfM4uEA9X7KApPtWRI3+n+4?=
 =?us-ascii?Q?w3ycV7+AH0NMSGOcPhvPkYU6k7ImCNrGZG2QQ7ak?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a3d8c8-a0fe-4a82-4212-08dadec5685a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 17:54:26.7953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6cFoA2NTfWufKHdLZh/KiyGgkrXgun1ReNvr/r/dbNle8XN2QBPr9IDAP3d0Iv2Xqx3Z30nSbcZMVmaFIMhc8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5673
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for new MDB attributes and replace command.

See kernel merge commit 8150f0cfb24f ("Merge branch
'bridge-mcast-extensions-for-evpn'") for background and motivation.

Patches #1-#2 are preparations.

Patches #3-#5 add support for new MDB attributes: Filter mode, source
list and routing protocol.

Patch #6 adds replace support.

See individual commits for example output.

Ido Schimmel (6):
  bridge: mdb: Use a boolean to indicate nest is required
  bridge: mdb: Split source parsing to a separate function
  bridge: mdb: Add filter mode support
  bridge: mdb: Add source list support
  bridge: mdb: Add routing protocol support
  bridge: mdb: Add replace support

 bridge/mdb.c      | 149 ++++++++++++++++++++++++++++++++++++++++++----
 man/man8/bridge.8 |  40 +++++++++++--
 2 files changed, 172 insertions(+), 17 deletions(-)

-- 
2.37.3

