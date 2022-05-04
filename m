Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2CC5197CD
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345172AbiEDHHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345193AbiEDHG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:06:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2D322B1C
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+Wqu7m4kv/352P2VRLRhQ2O60rMg73XGFEdfIBjA27ZfsCd02OP1saEPnPzqcHp8o6AgktlimK2A3rmAj9rFcu4zIPp1Lgf3e+rEVYp819w4oWyYBSS6MuZFobT/Wnkmi5aDpopQlQ/j7s84JmYImUBJ2Au+lp1NO3EICpzRl4VvBZCuZKTZajDqIAdeUVwVqSw9w3Wtv4oWVxlpjbOBRcY1nUWu9/Wlad7fseWnCZOrJZy4TEpOVDHezgQ559lRqfTyqVRf+hs252r29MftOASw9VfPp2dyB3T4eqlqwzf6p8oIhFzeZByq0XlQYK6QFtr6DA2JoLExKY9GpGNDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yq51gB3+ATp08R7tmpnjXXsTpSTrbpia7dZ5Nhyonvs=;
 b=jO1O8HKSBrp4zo4Vs0AGa0uoO7OZGnux/Rh0YJ3Nq9AoGbgieuuFWApq2OhPpPZYVqUPSnSptqJj4D7C5WIfdEQoOCYorbRjnsgdp75jY8kLEmdLCCsDCKY8PnqLc0+Vq9fKbtdq+OzC7Futdm/pvEQkB8CFoTlb+86t+pQMcy8qZn5/NJQyAih9v0VZgIE/MadHWQ08jYb2BCZIEvQlMMkd3oH+EIBWLO9+pNJpYnO3NCY4BnVhjHTOKi3uqAddxpbo1TU3zumUtR/QP62AzxlmFzkUXydZO8m1ld4l6vN5uIwPjuGCjiUHBLkBjXFKKGhMRl9lBk5/vBcncTQogQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yq51gB3+ATp08R7tmpnjXXsTpSTrbpia7dZ5Nhyonvs=;
 b=ncdULSWwE/UT/jDemfkVpqxOu6fYOtnHkLh+WtCS7ytNSQuMBS1/gyaf/XsmPZ9dw/3EqbWLCnrygb7lywJZ61u4X5BviKIt6VVVaktEeVtk7R8xlSuIuhwO1hSr+ZrZ6g2kDW32FsUPyrGNp6uQztRnOdp4SHWbrA8qPWVaMy1CRG+z6wLV/EojiuVRLeelHfldxI+Mocd07JCA1e9tZSVUo7XQKjcBLcP4lthBQJCvUDLJMbJ0L4dFMb30Gz0W8u4P9FU02QKjarLjdvSn9TFB+w0AUWs0zuE7PpnGmvB08Rg2amSEd2efCQ56ybtHo9CH4SKNLkbcji4xEfZfRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Wed, 4 May
 2022 07:03:17 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:17 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/15] net/mlx5e: Lag, Fix use-after-free in fib event handler
Date:   Wed,  4 May 2022 00:02:46 -0700
Message-Id: <20220504070256.694458-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0013.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::26) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df1256ec-e6c3-40f5-e947-08da2d9c2a55
X-MS-TrafficTypeDiagnostic: PH7PR12MB6586:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB65862BD1638674C2631FDF76B3C39@PH7PR12MB6586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lYBIW30JCX23DD687U4/kEtynaCrK5hdORcMR6zolpgTQEGJtvLyXMf7BtW+D7br35KsVEqhe7z1x35cfs0U12ByNYq0NZLDPtef6C97nLZSB/RwN0fEcFyitkAgXyXqVesHOgdyVUCuCn+A/dKlDz0nCy5v/4JQ02YHrfyvQTxl6mcRacxjANtBQpwKJbSSnQjyl1mwqqW5FBOBgaWeO288q9BMWwt46s6iS59Omi5AKX9fdgLgvEXbwq+xRHpaq9/TZnsqjfP4uyGsiXELnKbcDdbKZ6ejnsh0Xqnn1nyiHvYS9EUwLcCLi/1Foi/e1oNlsSk144i/hPi3Az8GDHJU3mC7PGd39GraaEu/nLBNqqBrJWVbbtr8jtvsJxwTyICCLU8aY0j+m2ehZbwkif8+cdcXp5eNMajFuArst8qXOTY2T0zSbDvhOna0syiFC9tQsunSRZY5w4il63oBs7cuQcXQuNvMKCTAUqzdvhbE2BZToyoXVlaPX8MnXJI7hfRssZ+1r+aC4LMmlndtYT39or7sNem5q1VUrPauaOvJ7cF16dhNB/3npKiTJQsgeThYnRvOydGqado/Uv3/lFx+Amf56VOIxPmjW2vKCZkFEOJKqMhqyb2lfH1rtQVGB9USUZ6zLYE1Hlciy8rUGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(36756003)(1076003)(107886003)(186003)(66556008)(66946007)(4326008)(66476007)(8676002)(2616005)(2906002)(8936002)(6512007)(6486002)(38100700002)(5660300002)(110136005)(54906003)(6506007)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4hSu5E3UGKSpB4BJv4INEn4Pz8DylLWFlo3jyGiIjarcE62mIjtzLBN1ZT59?=
 =?us-ascii?Q?yp5A9s6Tj4EaZlPRycZyq9a8KX+mvgeZHtBm57H3sP+zClFhwt2trDmAdyRx?=
 =?us-ascii?Q?cNqchhyu3YRKie9BMT0h+PoIr4AajrTofAzq5XIRAbSvrzGvkzZM0GdgIQgm?=
 =?us-ascii?Q?MJi6D8CII/pnrmkgVr1wX5k4avCcj4kSnT+hPvrg1tfsqZLSqEqj4LijXYjs?=
 =?us-ascii?Q?qyDmVVk8KrSsH4ASVGQekvQR5zWAv/Aa16oLiy3UKZlB8IIS+x+NYH8NITIe?=
 =?us-ascii?Q?qQXKRiZgFa5L04MzOlMq6Nxx383b8iVmJagzZnwYCSwqqEG3WgAOnT3/+Jud?=
 =?us-ascii?Q?GFLYNrLA3Fhvr5MNnmqF/dD7S/5oRmftv/AF0QZ63pznZxnXxGdHvHNrDxN0?=
 =?us-ascii?Q?pybU0c0p2WdvB7EmsKX5gfnhqe2LvVKC/nNpfpf3BuTvTIOEunwFf5huTBSm?=
 =?us-ascii?Q?Rm6K/mjlBCinH+owz8BLWoLJsU38P27Y9zCoLgKrw6kkv3AAGN29AL8FZ9TZ?=
 =?us-ascii?Q?5a8vTRvgAjdf8W92fklSPlH2rEaujcamzcbpdOXUeZyStKLgW2dMfGIDaTlH?=
 =?us-ascii?Q?Iy7sYzLLBJXCwNPd1rhuKgnBdvr8HBmL0eid/guDrdfsZQ2Vmr0iulI1ThHy?=
 =?us-ascii?Q?QthglHI7A4mE3/LGdURmY6rHgVAnO3GspdzrEbg8i8+YKd9Q0A1L0m3YxFGQ?=
 =?us-ascii?Q?rCW7JYqH/mn5g0UTHpMsjT8XyJTJ7iPTetd1K4dDRdt1QRXBMAQdTbQvJWTS?=
 =?us-ascii?Q?pcC8UjbHzQpMv9S8ZvnZ52NrN/W02yFoFiO3eogAo6R+dhQlZDLNMJoAAb/a?=
 =?us-ascii?Q?VSdHKBEMCTOf4qAKbop4ozLe+kx3NLCs0FmtODWYk5pu400zAXe3HRl5XkYI?=
 =?us-ascii?Q?KxpqUB0DuG6BJ+/5TCwR4wGG/XZa0LLmm//okKL55bzUL6kWlH3TzbkvKUFY?=
 =?us-ascii?Q?s/XkMF87JCC7CUEHIlMDMGp2zhxuzd+v0q61lM/gvXVp5juSjE6Nv3UZMDQS?=
 =?us-ascii?Q?xFg/Uwprw92ytQjnBmzDx8XxQKcDrVsgbZrVTzVyBsM6aoy5Crcn3Nffq/gY?=
 =?us-ascii?Q?RpuZtElUBcvsWOhMCt+zZsBk53WqXlAkI3iR2sxnaa1RdHNXcbw20UzrTeXe?=
 =?us-ascii?Q?rnm/dFyuzov84T8V83ksw01g/Oe19LsB9VbnjepwVu/60/zZeo8Pbb1CF77T?=
 =?us-ascii?Q?hfTmn1nChh1pKpVU8dU65Jr9a/tlg5UPoRWXOxPZ4fQi7gcouleJu0qtaMVS?=
 =?us-ascii?Q?MZdD332OeaT1o4/80fm9v7p2Q59U/zLc4/ia3XZ39N2zCNoPCeq1oujpENVj?=
 =?us-ascii?Q?i/HYVS6ygko2pUfl6XnbqKcgdHqNbn+tMnaZeb7MAgGFaKLQDYXJZOegL0kk?=
 =?us-ascii?Q?i2UZ3Zru2Rd5ePfxS2GMsvH2+3vGjIpLqKqDQD6ApoYfzBqqhvDAYLLT4MpI?=
 =?us-ascii?Q?ZKajdSbUTvuOOyWuMo9H25dBsvW0aRTQ3N5YxFE95/owb2vF7LfxBEPVjNn5?=
 =?us-ascii?Q?/dm3GJ6GrYWWbZ7jmr6w9rSKj4Qm3dEjv26ZWPLOBKmJQQ9NnmX7fmaqQ1BM?=
 =?us-ascii?Q?NuCEXwO99jbG/fvNJlNvTiY2wr7Itl6EqeuOn0vZG2pHswAuUuMQxbIWff2X?=
 =?us-ascii?Q?IbdJYCwUMDzQk6vEhAOXascLjPm8TBtB/U116VmPHIYSbCWn1JakUtpNXShe?=
 =?us-ascii?Q?fO2zhRKSQo6y6Eqo2iTn2NuNU6TqCcfGcFolILb/HDWtY6NEtOwJCKvP0laH?=
 =?us-ascii?Q?YZ6cJuMExansYtLUZhT2GOjdtUjI6by1DWcjB/Rc+C0NGo0tmPS7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1256ec-e6c3-40f5-e947-08da2d9c2a55
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:17.6186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jarBp0DjiFBjmPdSTlafumeMZO8tJh6hLhf0HWybf1v2PVfDsvpHFxbYnqvVIRB5pdubjeLpZUnT7aFXf7Swiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Recent commit that modified fib route event handler to handle events
according to their priority introduced use-after-free[0] in mp->mfi pointer
usage. The pointer now is not just cached in order to be compared to
following fib_info instances, but is also dereferenced to obtain
fib_priority. However, since mlx5 lag code doesn't hold the reference to
fin_info during whole mp->mfi lifetime, it could be used after fib_info
instance has already been freed be kernel infrastructure code.

Don't ever dereference mp->mfi pointer. Refactor it to be 'const void*'
type and cache fib_info priority in dedicated integer. Group
fib_info-related data into dedicated 'fib' structure that will be further
extended by following patches in the series.

[0]:

[  203.588029] ==================================================================
[  203.590161] BUG: KASAN: use-after-free in mlx5_lag_fib_update+0xabd/0xd60 [mlx5_core]
[  203.592386] Read of size 4 at addr ffff888144df2050 by task kworker/u20:4/138

[  203.594766] CPU: 3 PID: 138 Comm: kworker/u20:4 Tainted: G    B             5.17.0-rc7+ #6
[  203.596751] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  203.598813] Workqueue: mlx5_lag_mp mlx5_lag_fib_update [mlx5_core]
[  203.600053] Call Trace:
[  203.600608]  <TASK>
[  203.601110]  dump_stack_lvl+0x48/0x5e
[  203.601860]  print_address_description.constprop.0+0x1f/0x160
[  203.602950]  ? mlx5_lag_fib_update+0xabd/0xd60 [mlx5_core]
[  203.604073]  ? mlx5_lag_fib_update+0xabd/0xd60 [mlx5_core]
[  203.605177]  kasan_report.cold+0x83/0xdf
[  203.605969]  ? mlx5_lag_fib_update+0xabd/0xd60 [mlx5_core]
[  203.607102]  mlx5_lag_fib_update+0xabd/0xd60 [mlx5_core]
[  203.608199]  ? mlx5_lag_init_fib_work+0x1c0/0x1c0 [mlx5_core]
[  203.609382]  ? read_word_at_a_time+0xe/0x20
[  203.610463]  ? strscpy+0xa0/0x2a0
[  203.611463]  process_one_work+0x722/0x1270
[  203.612344]  worker_thread+0x540/0x11e0
[  203.613136]  ? rescuer_thread+0xd50/0xd50
[  203.613949]  kthread+0x26e/0x300
[  203.614627]  ? kthread_complete_and_exit+0x20/0x20
[  203.615542]  ret_from_fork+0x1f/0x30
[  203.616273]  </TASK>

[  203.617174] Allocated by task 3746:
[  203.617874]  kasan_save_stack+0x1e/0x40
[  203.618644]  __kasan_kmalloc+0x81/0xa0
[  203.619394]  fib_create_info+0xb41/0x3c50
[  203.620213]  fib_table_insert+0x190/0x1ff0
[  203.621020]  fib_magic.isra.0+0x246/0x2e0
[  203.621803]  fib_add_ifaddr+0x19f/0x670
[  203.622563]  fib_inetaddr_event+0x13f/0x270
[  203.623377]  blocking_notifier_call_chain+0xd4/0x130
[  203.624355]  __inet_insert_ifa+0x641/0xb20
[  203.625185]  inet_rtm_newaddr+0xc3d/0x16a0
[  203.626009]  rtnetlink_rcv_msg+0x309/0x880
[  203.626826]  netlink_rcv_skb+0x11d/0x340
[  203.627626]  netlink_unicast+0x4cc/0x790
[  203.628430]  netlink_sendmsg+0x762/0xc00
[  203.629230]  sock_sendmsg+0xb2/0xe0
[  203.629955]  ____sys_sendmsg+0x58a/0x770
[  203.630756]  ___sys_sendmsg+0xd8/0x160
[  203.631523]  __sys_sendmsg+0xb7/0x140
[  203.632294]  do_syscall_64+0x35/0x80
[  203.633045]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[  203.634427] Freed by task 0:
[  203.635063]  kasan_save_stack+0x1e/0x40
[  203.635844]  kasan_set_track+0x21/0x30
[  203.636618]  kasan_set_free_info+0x20/0x30
[  203.637450]  __kasan_slab_free+0xfc/0x140
[  203.638271]  kfree+0x94/0x3b0
[  203.638903]  rcu_core+0x5e4/0x1990
[  203.639640]  __do_softirq+0x1ba/0x5d3

[  203.640828] Last potentially related work creation:
[  203.641785]  kasan_save_stack+0x1e/0x40
[  203.642571]  __kasan_record_aux_stack+0x9f/0xb0
[  203.643478]  call_rcu+0x88/0x9c0
[  203.644178]  fib_release_info+0x539/0x750
[  203.644997]  fib_table_delete+0x659/0xb80
[  203.645809]  fib_magic.isra.0+0x1a3/0x2e0
[  203.646617]  fib_del_ifaddr+0x93f/0x1300
[  203.647415]  fib_inetaddr_event+0x9f/0x270
[  203.648251]  blocking_notifier_call_chain+0xd4/0x130
[  203.649225]  __inet_del_ifa+0x474/0xc10
[  203.650016]  devinet_ioctl+0x781/0x17f0
[  203.650788]  inet_ioctl+0x1ad/0x290
[  203.651533]  sock_do_ioctl+0xce/0x1c0
[  203.652315]  sock_ioctl+0x27b/0x4f0
[  203.653058]  __x64_sys_ioctl+0x124/0x190
[  203.653850]  do_syscall_64+0x35/0x80
[  203.654608]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[  203.666952] The buggy address belongs to the object at ffff888144df2000
                which belongs to the cache kmalloc-256 of size 256
[  203.669250] The buggy address is located 80 bytes inside of
                256-byte region [ffff888144df2000, ffff888144df2100)
[  203.671332] The buggy address belongs to the page:
[  203.672273] page:00000000bf6c9314 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x144df0
[  203.674009] head:00000000bf6c9314 order:2 compound_mapcount:0 compound_pincount:0
[  203.675422] flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
[  203.676819] raw: 002ffff800010200 0000000000000000 dead000000000122 ffff888100042b40
[  203.678384] raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
[  203.679928] page dumped because: kasan: bad access detected

[  203.681455] Memory state around the buggy address:
[  203.682421]  ffff888144df1f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  203.683863]  ffff888144df1f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  203.685310] >ffff888144df2000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  203.686701]                                                  ^
[  203.687820]  ffff888144df2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  203.689226]  ffff888144df2100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  203.690620] ==================================================================

Fixes: ad11c4f1d8fd ("net/mlx5e: Lag, Only handle events from highest priority multipath entry")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  | 26 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/lag/mp.h  |  5 +++-
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 4a6ec15ef046..bc77aba97ac1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -100,6 +100,12 @@ static void mlx5_lag_fib_event_flush(struct notifier_block *nb)
 	flush_workqueue(mp->wq);
 }
 
+static void mlx5_lag_fib_set(struct lag_mp *mp, struct fib_info *fi)
+{
+	mp->fib.mfi = fi;
+	mp->fib.priority = fi->fib_priority;
+}
+
 struct mlx5_fib_event_work {
 	struct work_struct work;
 	struct mlx5_lag *ldev;
@@ -121,13 +127,13 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 	/* Handle delete event */
 	if (event == FIB_EVENT_ENTRY_DEL) {
 		/* stop track */
-		if (mp->mfi == fi)
-			mp->mfi = NULL;
+		if (mp->fib.mfi == fi)
+			mp->fib.mfi = NULL;
 		return;
 	}
 
 	/* Handle multipath entry with lower priority value */
-	if (mp->mfi && mp->mfi != fi && fi->fib_priority >= mp->mfi->fib_priority)
+	if (mp->fib.mfi && mp->fib.mfi != fi && fi->fib_priority >= mp->fib.priority)
 		return;
 
 	/* Handle add/replace event */
@@ -145,7 +151,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 			mlx5_lag_set_port_affinity(ldev, i);
 		}
 
-		mp->mfi = fi;
+		mlx5_lag_fib_set(mp, fi);
 		return;
 	}
 
@@ -165,7 +171,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 	}
 
 	/* First time we see multipath route */
-	if (!mp->mfi && !__mlx5_lag_is_active(ldev)) {
+	if (!mp->fib.mfi && !__mlx5_lag_is_active(ldev)) {
 		struct lag_tracker tracker;
 
 		tracker = ldev->tracker;
@@ -173,7 +179,7 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev,
 	}
 
 	mlx5_lag_set_port_affinity(ldev, MLX5_LAG_NORMAL_AFFINITY);
-	mp->mfi = fi;
+	mlx5_lag_fib_set(mp, fi);
 }
 
 static void mlx5_lag_fib_nexthop_event(struct mlx5_lag *ldev,
@@ -184,7 +190,7 @@ static void mlx5_lag_fib_nexthop_event(struct mlx5_lag *ldev,
 	struct lag_mp *mp = &ldev->lag_mp;
 
 	/* Check the nh event is related to the route */
-	if (!mp->mfi || mp->mfi != fi)
+	if (!mp->fib.mfi || mp->fib.mfi != fi)
 		return;
 
 	/* nh added/removed */
@@ -313,7 +319,7 @@ void mlx5_lag_mp_reset(struct mlx5_lag *ldev)
 	/* Clear mfi, as it might become stale when a route delete event
 	 * has been missed, see mlx5_lag_fib_route_event().
 	 */
-	ldev->lag_mp.mfi = NULL;
+	ldev->lag_mp.fib.mfi = NULL;
 }
 
 int mlx5_lag_mp_init(struct mlx5_lag *ldev)
@@ -324,7 +330,7 @@ int mlx5_lag_mp_init(struct mlx5_lag *ldev)
 	/* always clear mfi, as it might become stale when a route delete event
 	 * has been missed
 	 */
-	mp->mfi = NULL;
+	mp->fib.mfi = NULL;
 
 	if (mp->fib_nb.notifier_call)
 		return 0;
@@ -354,5 +360,5 @@ void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev)
 	unregister_fib_notifier(&init_net, &mp->fib_nb);
 	destroy_workqueue(mp->wq);
 	mp->fib_nb.notifier_call = NULL;
-	mp->mfi = NULL;
+	mp->fib.mfi = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
index 57af962cad29..143226753c3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
@@ -15,7 +15,10 @@ enum mlx5_lag_port_affinity {
 
 struct lag_mp {
 	struct notifier_block     fib_nb;
-	struct fib_info           *mfi; /* used in tracking fib events */
+	struct {
+		const void        *mfi; /* used in tracking fib events */
+		u32               priority;
+	} fib;
 	struct workqueue_struct   *wq;
 };
 
-- 
2.35.1

