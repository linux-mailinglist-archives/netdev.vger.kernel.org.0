Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7F452F584
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353792AbiETWMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237117AbiETWMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:12:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1BE1994A9;
        Fri, 20 May 2022 15:12:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxePF30dRLZwjtaIvObpKV3fOJQcyIy6C1qCHs/Nprm04HIv0uVRhhIWbBXKaBtVEfCbDVVnj/QEIWPeLvT8jGWHqbSHuOPfCbI8sg/UPh0Goctk246LhsviEeOlTbBPq5kiFJQNH6KB9YQmZHLanpVh5KQv3V2hw6Dvn7S5InR+nWCjy5qI+J6U8uPSatKEmoafY0GutjS9FeChNWhuzQZtUrelR4pkWNdJIrET7h02slsfjWxrO/1o/6AZPVRsUuu/63S3eFCyOYDUwx83W/q2LGr4pWpJJOQkaPrdc74fD+vusPkdmwLEdiTezSyRh4pMnjozIfxqPtxf80AhBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TK4mIdRmLldCgehempqYJzYIzj/+HjHTMSRgx4T+z6E=;
 b=VhVsaqpZogiMuy1BmdCbQhIQLoCpPCCz9jiMIpeGgFQcwmYXk3asEWMkAaQDxGA8ngCzitzeZazAePDbyCfhm877VU3TE5rCIhY5JsxlOjGhg7B94tQ33DtxjFIy+AGvF7FTsYONPpPXsfXVj/kjmvxlQ/5R9fY/40AiuU4lZ3X/7/Sdid7OvPfB3ja4gZryJZ+flgrXDWx65RVgUIJiclA331N9CZ0DeWY4VE/ZhymabETQzpp3LeNTvwvoq/qAfWg/kq2eI0F8RJ8eK2i+BoVpqsgrBt2E7CA7Y5NJqSC+218W5Retsm1tac5B9bxj1NPOX573LzZwLlkv0HrMkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK4mIdRmLldCgehempqYJzYIzj/+HjHTMSRgx4T+z6E=;
 b=Zf+7XHhiee30t040ZgvmEmKQefK07flisYveNVRbDyYqVT8giFzQHhBSDNhJR+fzBoK5O6cKyrMVSaLO+Ie9kbUJ27tyEXO1r8Yv7LoQdP/Io1qyT15/6ym5qcroLfTryJEjyHfHKO0Vf7ZOd7ScIfoQeVTps42+NLTajjQKD5SAVUbaXKk3bhelNn1Ne6uRi+ycMDJC3sVm1NM3YKqhu3jjUzJn5+FgF3c6ZeH9cYl/N2ViAaRN2T/2rx2GeiZhN4gq5PTssV/tD5jtPxONioCrnPQDoJq01cHwjJlwvdpfDJ8PTQP9UyHgWd6VzlGWnYRIrYe1kB5c9Q/Veu1TIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM5PR12MB1178.namprd12.prod.outlook.com (2603:10b6:3:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 22:12:47 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5273.015; Fri, 20 May 2022
 22:12:46 +0000
Date:   Fri, 20 May 2022 15:12:45 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Guan Jing <guanjing6@huawei.com>
Cc:     davem@davemloft.net, leon@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net/mlx5: Fix build error of multiple definition
Message-ID: <20220520221245.bsf3abwo566l3yzs@sx1>
References: <20220520073423.35556-1-guanjing6@huawei.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220520073423.35556-1-guanjing6@huawei.com>
X-ClientProxiedBy: SJ0PR05CA0192.namprd05.prod.outlook.com
 (2603:10b6:a03:330::17) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4f0f0b5-ed24-43ae-6bf9-08da3aaddeb4
X-MS-TrafficTypeDiagnostic: DM5PR12MB1178:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1178F214D4BDC6EDD570674CB3D39@DM5PR12MB1178.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOKrtZ8jY1TPGBkPb2yJdZniB6/lfd38AhWjm9tpT0Uhx7EO9Vu1kKsP0DzlW1Q+9gwLEVniDGk8wHqKYgELjhgT8W6ihqR4HTZWf2pZJzP1HjsZJr3IqaG3YZtAlxmsA4bAH9Y1TlFIThfWaGxegO2Qj1RlCaPqrrqqgnbgX4YPFaOB5euaQeFfBLzmeg11cOJ6xDmqGlegYY40lfFJPyd4xFHpKNo0wdJpY8K9iMIEcVqTaBzDrmIpYMlXBBKpAO8d4bGakutCSCv3cqpRIGzfG+zJ3/PQ8IwbVCGvRu8LK5M5bChXiXmHpL1q+6yZN4l7ZrtLe1SQsFI/W+IIr3LBZtv4Lbl6l4giKBxellFizJwOpUHbS7GJo2v6QOHc3J7Z24wwIWLpE2h/DrbtfI5sNRcrn8aIpChKwgruUw4hZZiahhQBxlUrb8OyQ/FGQvmjyhWT3MyJu0EfDSiqAN2/eE1pg8QuLun0CrnYVYC71nvOPHOvStGK9ieBZbZKyNB5871Z0MZlWcQ1K0CnKHOBv2nsdT35zjgh3NTDV8Dqjv+QyjfF0rZlMtkK31RmX5Et+v+atGLZeObqzTE09NnrEMSSLDL8JmVX47pPNJKIi0p+BYOXIsk63rgOmezpzYkQzNmg5RYcELfBKdCX/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(9686003)(33716001)(4744005)(1076003)(6486002)(508600001)(6512007)(8936002)(5660300002)(38100700002)(86362001)(66946007)(66476007)(66556008)(2906002)(6506007)(186003)(316002)(6916009)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LZepl6KdLUelwrjGb75X8POoTTfRLXEU3DaS8cMy1SdgF0SokiuZAwsUsUyw?=
 =?us-ascii?Q?rbbSUzmvxORu0E6Ed+B43uCMfaOG1qOCJvJJmqrJZiiBaaY7z1I3GjAzjYfn?=
 =?us-ascii?Q?RuCAlVuRtzIcMlT01trBrl/W5GFOtMrcZ9gUW3OF468d97R1gdgoDYyqgQ9I?=
 =?us-ascii?Q?TJzjrNXUKvQqZ7ivKepIeHjTvTBBrWPvZ9heDY23ua1jzIvQc93dCwLWYqDS?=
 =?us-ascii?Q?/SSgTygM6YWRMJwAkLiKwc14Grgona9izSwtaGL1NsjvZiJ8eFRkX3CVE9tj?=
 =?us-ascii?Q?Xrp2kr+QOlnyRiaZ1wiqzwGdgTCPh4ty1k1xkbEVKwEXjGjVHXws3Bw63bZf?=
 =?us-ascii?Q?GckkfdvStPlNdJG3Fl8NK+39vg85dARztwBe74yGY60qBAmmYXK+ZS5L2a7N?=
 =?us-ascii?Q?YPpMpU8gHAg0kxiqXGXTKaRZPdPTPRd2BhfI+7zNMnosDQsjoJ9StPKittrS?=
 =?us-ascii?Q?Yg/b+JxjINJKUHDHxZbGAdyq+/X9abLUz7NRt/b3CyW1a/Bn+kwNx3da8XPl?=
 =?us-ascii?Q?IKUKYugSMLsCQ+SKdLcT004MRODNAiPN9aM/LsBEot8fuV89oiDa8Bdp69I4?=
 =?us-ascii?Q?bG9XSVwcsq4a6nvMGtqUTlVmPfTCsfvGRrFE2JHy/atJLAmoCh5Qp4ejaAX5?=
 =?us-ascii?Q?uAuk09Sb3Vq5PzR6Z5hSSYPQVufjhYJ7QOYD4Yxa5ceRcCtWv20BOGSjMUsQ?=
 =?us-ascii?Q?SL+P8giTDvBSEiKPl+zUzRWQuvCrchSxFDeqk+QosSIdV+BFS+GLaom2OTPH?=
 =?us-ascii?Q?HRvJiKVcyijGhkWW8PJfLw0mj4TjrQTpqRy/L/WlTtAi7eJ5TumcIwgxWhFF?=
 =?us-ascii?Q?NdIkFTQJufxA4Ml+EUjcxFNkDTNC4NWoxPghW3mFdojORPAprcphi7kGTXCv?=
 =?us-ascii?Q?GDwRd1w/cFHtIipRtOkwGLRf31MVd604+bg+Hqs71/g0mYuC9ZjVEtXGLWYX?=
 =?us-ascii?Q?enaGlV4gIzCMnF2xX4EC+cORxHYg5/YBX8F5pqLHolmyHJ85jWmkXpen5g7T?=
 =?us-ascii?Q?OZuPOKWhIDfURBlj7qCu8jSy9UkTvTy4f44ViLCaVpDJrs/WOXoH8M5r08bO?=
 =?us-ascii?Q?5zqcX0I+IRniwzS7BotBzwmUpxFk7MXkbLYNJ4zJrXYRkVjR39zAAbfXNXJK?=
 =?us-ascii?Q?PFFSqS1/5ck9yVIwohfVojY8u8Gq/8i08sP5YTUoSXFYgH4Zotwyahq3006h?=
 =?us-ascii?Q?cYU7QefyetAaGr2TzPgmq5b2o9rzgANRlg+GqI4I2NP1hTYutI114zJVY0RM?=
 =?us-ascii?Q?xJW/t3Klj3FMXq1wvCa6XKiiglYKlfefJfwekRWugaNh45J/Lw2fBXkUX/JB?=
 =?us-ascii?Q?snIMinDYz315tk3rNPj7ouy7lhSLS5xDwf/t8Cemim4f+x3V8n7iVMiQrkIr?=
 =?us-ascii?Q?p0F3r4K1MJ6FrQHLx4xpUIPA2MIipbFAPqSQdMDaHBtzSGGwNc8/Ha4BItWP?=
 =?us-ascii?Q?B7kqLrEPVvsuqIKHYuONWSDVNOltcPEkUYuF+QbvRxbXrPYt32QW1mWG1sco?=
 =?us-ascii?Q?aM7B+8FSzU/A4lFr48vFTS/gHE19c34+qmhWfEbV5tsHGqRFEC/8LsRGf44h?=
 =?us-ascii?Q?JbLt5TVeFMb7kppOUhz1VA6qVVQvCLx0/6nwAcry4uKHPn2K+mYBnZ+fSYso?=
 =?us-ascii?Q?ZZBCYD1PVqVHq80Y8uvbEgafP2WZby07eAMp4zrdgHmYGq16yjqrUvomgOga?=
 =?us-ascii?Q?ZiGyEfpSUtJ0OodzAeziuw6AkhUFF7OHYqKkXiBVxaPMa/aJUEQ/P7LDGxU9?=
 =?us-ascii?Q?pP4ZSgIcpRUpokKTUpjOmwOE6KL5pUEvkhFLcHqDdv05h80pYE6G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f0f0b5-ed24-43ae-6bf9-08da3aaddeb4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 22:12:46.8965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPkv0KIg+Ihszl1+zZdGc9u9r093OlSRKvAzyCi5okryQEZ8qiZNz4id8q1/n9luacEA79wLSOMnwcLxrEiS5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1178
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20 May 15:34, Guan Jing wrote:
>There are some errors like:
>
>drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o:
>In function `mlx5_lag_mpesw_init':
>lag.c:(.text+0xb70): multiple definition of `mlx5_lag_mpesw_init'
>drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.o:debugfs.c:(.text+0x440):
>first defined here
>drivers/net/ethernet/mellanox/mlx5/core/lag/lag.o: In function `mlx5_lag_mpesw_cleanup':
>lag.c:(.text+0xb80): multiple definition of `mlx5_lag_mpesw_cleanup'
>drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.o:debugfs.c:(.text+0x450):
>first defined here
>
>So, add 'static inline' on the defineation of these functions.
Already fixed by:
commit d935053a62fa11d06c757c1725782e46e7e823db
Author: Jakub Kicinski <kuba@kernel.org>
Date:   Wed May 18 11:30:22 2022 -0700

     net/mlx5: fix multiple definitions of mlx5_lag_mpesw_init / mlx5_lag_mpesw_cleanup


Thanks.

