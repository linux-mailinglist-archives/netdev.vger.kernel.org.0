Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C986C7076
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjCWSrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCWSrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:47:10 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DED026872
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 11:47:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JazRpcMW3a5GdMbxDJhrGJGm5eClZ+0zvDXodd0JiRzmd7Z8RLeMNZoDBQCCxy05wEsSzfa437dN1RNPX0Xi2FGzwyB28zG3arZ4gHIRrO//iF+L3VSO2jyWH8NER/xVzBJlXVzxrlTzJfPEqxcCpXxlmoT+fOuHbKO9AmrOYkFTTHVtOR/3/NGIQ+ISDK+2q8lHhWCHco8rfA+5WsUhSJjrS2AL/sNPUI4rpDyVHhVgdSveaZWFLJNamwXl1rrtVgVeLGV4ss1qfC9W6+Kq1JTCyC46iZ83pR7YjcAzf+tqI54r/JwpNMYw5TPmBIKENxSbjA5xouzGRcYcMx8Kmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kA2nhv87wK6Hx5RzOkLL50rXioSvtEKXSjs2zxHPkrA=;
 b=epNGYYWOtWaPd7xJ3tZVqP5qysycFp2B7i1OELSJglkxr41PYjPPXOmS0t3hB3WQs0MXUVduCPzVfajNEQZF65QIqj3P1UoU4FxJWyADzS7iGTLpCy1e7tE2d/RWoF3GbDkwfrFYbTJWMGfQlLd3LrsHZzwHcTml/45VWClV+0mjHnbV8xrpcEd+jMn5iohW7FVZ2rATXo7sgWAUOWC3a1tZFtsgS3yk/ObQqzUSM26T1Cg0/bb4Z6xUhQHg2byhGFhDwuKAgwJWXqSasVWtIpR/0lQkO+yz0u+6HGjE6HPPy7VK+087ZUTOm1eBNCF/SnjFbdSXfwKLxNSdNejyTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kA2nhv87wK6Hx5RzOkLL50rXioSvtEKXSjs2zxHPkrA=;
 b=bbGmU4qmJwNudLRS/spCldeK7lvlqelptkB6gdrt6BI5dVmb0AKdHkVNBEDDDt1ErlamlX02JYKJnA3VhFC26Q1RVTxJ/qCTOG8UkG3xds0Zy0Z2ICxKSfCRGNdSNkUvMVfCZXIfD9kaCbL42cSwdr+3XVcKm/HIOi91vlnvO+0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB9703.eurprd04.prod.outlook.com (2603:10a6:10:302::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 18:47:05 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 18:47:04 +0000
Date:   Thu, 23 Mar 2023 20:47:01 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: Re: Invalid wait context in qman_update_cgr()
Message-ID: <20230323184701.4awirfstyx2xllnz@skbuf>
References: <20230323153935.nofnjucqjqnz34ej@skbuf>
 <1c7aeddb-da26-f7c0-0e7b-620d2eb089b9@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c7aeddb-da26-f7c0-0e7b-620d2eb089b9@seco.com>
X-ClientProxiedBy: AM0P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB9703:EE_
X-MS-Office365-Filtering-Correlation-Id: 441d5342-268a-4681-89a5-08db2bceff26
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRCZz/u55vl6bhv2PzYzw5I7YKQkujtTg7Per9GZL5v2scnP9iM3MA8LNOYl4cqlzUklZU7LlCnJSmJSyUJ6xTteC1f7o2eZyfdPr3HZFWfmSIfUr17i1+gUPhdKJKBKgDH2j6quoI4AGfYSF9JOf+gXoOijVjApz2PR31DgTgkWkY/Bf1Zjz9wc6aBglsAYT6Y8NvGWKDdi3TWwu6po10a2Wb/QHqK6Aj0z3P+oG8pEN5iWEWax2XNkiR+TtsziipfoHmwNQacaWK0LveGu2BUx2DAHYgeyAvG8nWaw+eeSTzHcjLdajIc8ulhcvw8dZVYFy8Z2dvt7qag3WvauBBCs5jASoi9WYow1zYd85F0nuLwlmBI8q5+O3ODoh0MDowj6Bj0F+nBz/luosPOgWN7T6P8FOSi34Op6855CyddbB2tB6GvK7KTE9QY/ccio8tlM0E782ByUAdINh1Wn4q3Ji+OUfXrKye1iM+hWkFUxAqylPRqmQ/BKc6Kh3X4HM4qnmxcB5il+ODnBzbU856R6YQxrvlxEnWVG4AW2Rl7IFmWP1gYy2IZKU0L+Nr6Vdi+R75jKCMXgraa2QgZ+RxtS9QV8JfODGvYWt2A26trPSBZPTD5k02onGJfBy5VCFMLKsO8N/ZO3ycsWKIM5mw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199018)(478600001)(8936002)(5660300002)(66946007)(54906003)(41300700001)(66556008)(66476007)(44832011)(8676002)(6916009)(4326008)(86362001)(186003)(6666004)(6486002)(9686003)(6512007)(6506007)(1076003)(26005)(38100700002)(83380400001)(316002)(2906002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nNIpTCgnBxw1wcV7OcTNgPQnBdp26eKq3DS1ovEWzB0xmwztQqH7MSFBSNX0?=
 =?us-ascii?Q?s1AOyGpwjT/C8V8wdJUl9DsNhDBR2bZYA8WGE89k5QERTHWcnhURnTm5NUJr?=
 =?us-ascii?Q?i8r6hiJcCALgfI3ho3W29BVH1f3KIwQUXNWxSmeWbFQBtg1wVQfdtCHo6VF0?=
 =?us-ascii?Q?08UtYlYcmIjzrAeSKfifByRDJZRInviiut7qjvMLcEuRCm/n/rYZU7KGBKvX?=
 =?us-ascii?Q?8DjgiedGEhWb0gT9nmYaptxsK/t0c82nPa1LIcKkXcAKeMge8NZNBNXm2pW0?=
 =?us-ascii?Q?pPhaq0cArZTkg4GfXmeFnAVuHDCPwbr5J4HC1k9FkEn8gJlNQBjPPHVUwsqV?=
 =?us-ascii?Q?Da2P8ylqICOLh93uwoHGnPRnWN1/9LolkWcVZIDUvTdMFkvAPj87TRYw8zu2?=
 =?us-ascii?Q?LO3xgjdpFzovuxEK721P5+FFfwp87/v7Oqcn2JyNjCNLsqDFgIRkr6dhRgRG?=
 =?us-ascii?Q?qSJIm5KxiYOVzZ9ZAmRXZcvs01iQr4NR4C+s5VLdADZc9M2rm4pYNkAJbdgi?=
 =?us-ascii?Q?23vG95zEqTix/WSLO/YH+gRCIMP2Fc1Y710vnrQ4f3zAc/5z/qSvQzuhgEHF?=
 =?us-ascii?Q?Z3JNORvOssh9VbUH6l69Dinh0L7zIkG5CVqc0xn4S6AVjcOTGm+9OXGyQLmU?=
 =?us-ascii?Q?TpsKjZw4pKvOxPsxcHJkGX1ktwHM0LSETUErRxbvfDuUDdP+Fc9M5TcovqRt?=
 =?us-ascii?Q?WRvUwqACbcT/aD6u/Fm/KnfAeZBYzAfCw67QQm0nEeUJdkeZK711rY19//bJ?=
 =?us-ascii?Q?rx6xo5iIr9rvEOMSXLvC+qeOQKn6xKYpsYLCHWKY0QhWumD0oD6sRb1DJJA9?=
 =?us-ascii?Q?yP/7J0xQBXg3pOgNNOHVf10n+alYaTWdscUV+WgS3/qwEuM3pcLUqJcVNfS9?=
 =?us-ascii?Q?mfhLwrMGCwZwF8G8C+iAr16+PS6FkZI5elD6qfe4aoIggWHuchMAYsR2ezmM?=
 =?us-ascii?Q?5URzNai/iDvKPreffRgujNjYBIkNoZHnPPrvXiCK+srEIEYHPiYL9wcHfwAr?=
 =?us-ascii?Q?CyknCtCg8li/y91dttPQtA9LNqUfRVj5Wim/oZjBPfxpRjNFWtmg+Lew0ovA?=
 =?us-ascii?Q?9PJbT6cu+uJtciL2lEhKG0Ad/cs7miRs7Z/wQwl5/VLRM2hqYRgLApeJnjPe?=
 =?us-ascii?Q?Ld0FXf7XTEXbOin3oRL/+qKumBL6t3/Nne3ln71ADF0Kk3QYXF0bpBYgdIiZ?=
 =?us-ascii?Q?JPRGh/cA3JOqDxj3KSyE8mpw79tBp507woNY4KFuo3P3R+SSS4kSt4tolSWI?=
 =?us-ascii?Q?r3O4uHO5n5aHy8mHiwNcbvijI0EluTp03BYYZfEwebhhvsJ7P43k+0fBWxHa?=
 =?us-ascii?Q?FZk1u6blYdmnxioOt4zAS4kEIdNBA6ndQMdIluQLfQ+3qRj4ygDBNNb1qd4e?=
 =?us-ascii?Q?MzIRxsUUE6OfdXX4X5lje2/JDlur+HpgAKNeDJdPeADEykupt3BeF9zmO+P4?=
 =?us-ascii?Q?DnSINsv0NQCF4ME7/bOqjx7OT6OL7WkMFUQ5fIZtuEGeORHk90R+tFKPn+8C?=
 =?us-ascii?Q?PzNZgHTyXYXdvQZgmaF3XSsHm4kJdOdUiFru83+XJqnsDYpo+WdiW3BKeu6w?=
 =?us-ascii?Q?BEmTd+xONoCIAzt5fom43yDUPH77xXkWm2lTqQelJDMjB25JSi6kWN1504qV?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 441d5342-268a-4681-89a5-08db2bceff26
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 18:47:04.8748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTZn6Ep2KvgvxZ4XjllbJFLMk0xxyLJPMnl0meTpVBChvkJsyOKI5e8BQ74/71GkOzj56mF+c4i8dmoWBKJLJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9703
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:58:00AM -0400, Sean Anderson wrote:
> > Do you have any clues what is wrong?
>
> Do you have PREEMPT_RT+PROVE_RAW_LOCK_NESTING enabled?

No, just CONFIG_PROVE_RAW_LOCK_NESTING.

> If so, the problem seems to be that we're in unthreaded hardirq context
> (LD_WAIT_SPIN), but the lock is LD_WAIT_CONFIG. Maybe we should be
> using some other smp_call function? Maybe we should be using
> spin_lock (like qman_create_cgr) and not spin_lock_irqsave (like
> qman_delete_cgr)?

Plain spin_lock() has the same wait context as spin_lock_irqsave(),
and so, by itself, would not help. Maybe you mean raw_spin_lock() which
always has a wait context compatible with LD_WAIT_SPIN here.

Note - I'm not suggesting that replacing with a raw spinlock is the
correct solution here.

FWIW, a straight conversion from spinlocks to raw spinlocks produces
this other stack trace. It would be good if you could take a look too.
The lockdep usage tracker is clean prior to commit 914f8b228ede ("soc:
fsl: qbman: Add CGR update function").

[   56.650501] ================================
[   56.654782] WARNING: inconsistent lock state
[   56.659063] 6.3.0-rc2-00993-gdadb180cb16f-dirty #2028 Not tainted
[   56.665170] --------------------------------
[   56.669449] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[   56.675467] swapper/2/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[   56.680625] ffff1dc165e124e0 (&portal->cgr_lock){?.+.}-{2:2}, at: qman_update_cgr+0x60/0xfc
[   56.689054] {HARDIRQ-ON-W} state was registered at:
[   56.693943]   lock_acquire+0x1e4/0x2fc
[   56.697720]   _raw_spin_lock+0x5c/0xc0
[   56.701494]   qman_create_cgr+0xbc/0x2b4
[   56.705440]   dpaa_eth_cgr_init+0xc0/0x160
[   56.709560]   dpaa_eth_probe+0x6a8/0xf44
[   56.713506]   platform_probe+0x68/0xdc
[   56.717282]   really_probe+0x148/0x2ac
[   56.721053]   __driver_probe_device+0x78/0xe0
[   56.725432]   driver_probe_device+0xd8/0x160
[   56.729724]   __driver_attach+0x9c/0x1ac
[   56.733668]   bus_for_each_dev+0x74/0xd4
[   56.737612]   driver_attach+0x24/0x30
[   56.741294]   bus_add_driver+0xe4/0x1e8
[   56.745151]   driver_register+0x60/0x128
[   56.749096]   __platform_driver_register+0x28/0x34
[   56.753911]   dpaa_load+0x34/0x74
[   56.757250]   do_one_initcall+0x74/0x2f0
[   56.761192]   kernel_init_freeable+0x2ac/0x510
[   56.765660]   kernel_init+0x24/0x1dc
[   56.769261]   ret_from_fork+0x10/0x20
[   56.772943] irq event stamp: 274366
[   56.776441] hardirqs last  enabled at (274365): [<ffffdc95dfdae554>] cpuidle_enter_state+0x158/0x540
[   56.785601] hardirqs last disabled at (274366): [<ffffdc95dfdac1b0>] el1_interrupt+0x24/0x64
[   56.794063] softirqs last  enabled at (274330): [<ffffdc95de6104d8>] __do_softirq+0x438/0x4ec
[   56.802609] softirqs last disabled at (274323): [<ffffdc95de616610>] ____do_softirq+0x10/0x1c
[   56.811156]
[   56.811156] other info that might help us debug this:
[   56.817692]  Possible unsafe locking scenario:
[   56.817692]
[   56.823620]        CPU0
[   56.826075]        ----
[   56.828530]   lock(&portal->cgr_lock);
[   56.832306]   <Interrupt>
[   56.834934]     lock(&portal->cgr_lock);
[   56.838883]
[   56.838883]  *** DEADLOCK ***
[   56.838883]
[   56.844811] no locks held by swapper/2/0.
[   56.848832]
[   56.848832] stack backtrace:
[   56.853199] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 6.3.0-rc2-00993-gdadb180cb16f-dirty #2028
[   56.861917] Hardware name: LS1043A RDB Board (DT)
[   56.866634] Call trace:
[   56.869090]  dump_backtrace+0x9c/0xf8
[   56.872772]  show_stack+0x18/0x24
[   56.876104]  dump_stack_lvl+0x60/0xac
[   56.879788]  dump_stack+0x18/0x24
[   56.883123]  print_usage_bug.part.0+0x290/0x348
[   56.887678]  mark_lock+0x77c/0x960
[   56.891102]  __lock_acquire+0xa54/0x1f90
[   56.895046]  lock_acquire+0x1e4/0x2fc
[   56.898731]  _raw_spin_lock_irqsave+0x6c/0xdc
[   56.903112]  qman_update_cgr+0x60/0xfc
[   56.906885]  qman_update_cgr_smp_call+0x1c/0x30
[   56.911440]  __flush_smp_call_function_queue+0x15c/0x2f4
[   56.916775]  generic_smp_call_function_single_interrupt+0x14/0x20
[   56.922891]  ipi_handler+0xb4/0x304
[   56.926404]  handle_percpu_devid_irq+0x8c/0x144
[   56.930959]  generic_handle_domain_irq+0x2c/0x44
[   56.935596]  gic_handle_irq+0x44/0xc4
[   56.939281]  call_on_irq_stack+0x24/0x4c
[   56.943225]  do_interrupt_handler+0x80/0x84
[   56.947431]  el1_interrupt+0x34/0x64
[   56.951030]  el1h_64_irq_handler+0x18/0x24
[   56.955151]  el1h_64_irq+0x64/0x68
[   56.958570]  cpuidle_enter_state+0x15c/0x540
[   56.962865]  cpuidle_enter+0x38/0x50
[   56.966467]  do_idle+0x218/0x2a0
[   56.969714]  cpu_startup_entry+0x28/0x2c
[   56.973654]  secondary_start_kernel+0x138/0x15c
[   56.978209]  __secondary_switched+0xb8/0xbc
