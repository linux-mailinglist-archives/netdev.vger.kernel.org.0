Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D81A6E9263
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjDTLZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjDTLZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:25:04 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20724.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::724])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4AFFA
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 04:24:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GyYzaXIK+ppskIPob+xtV10uJkYpSBYwKDiuyp+5P52uTtRa8R6N3FURk3aX/+8hdxZsKunZ5wSTBnSFz17RXSTWu6xxcdTqH3cx9n520EwWX+WpLHdTL1muH+wrG/2oRPOJEcGlHq8Q4xbgJfzSSu/tt2pUjr1mMcyEZQjzw4KyxMs6MEQd/D9rbP3lR3gZYtwKXl6b+DeRFl4Y1/Xwp9qqgiu+XdJxzcG/ripp1AMNV45dZh3N64ZTwcwTUVB1NxB+R9J/jMtizviHlmrXAdMOlTQKTy70NuCoFWNILPf2FtEX0BLOv7NS57HnzJt/zpjgRkN2dSssUQpb7dDHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVWz+ssMEag9j8sJ610nWIwfdzwVvGTD4F9hOW+3MJE=;
 b=Uk2rLbFs6nG6BkR/4dc//YALj5k9UnREAJyANgBIk3Sb+m6b3IaGYkMP5gWAzx+EsFgPICCkOJaiqrMS+wPB9cepMWkuVZxpoPdCvtxvd55tlUV8/yoX4vBNOB79qmkP788pWQl9EeK4tBBTbyO4v2HSm4I6Sd/kgj9guGHAPljiN9Fx29AWQhMmnm2jcLOnP4Yn+5coyntpyRpzbkK6NJU5mQcTkL08sWGWhcIPrvqnpiXD4sRtQgZI9dwhZ0XSaP8FNsxMf0kzycZrV9KHluTnPehEyTYhDDE3QOPkYqN6ZsBOmBA/XFJzsDklfknRoONxVANGtEG8eokxKt7utg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVWz+ssMEag9j8sJ610nWIwfdzwVvGTD4F9hOW+3MJE=;
 b=HZ+neDzQGNT8aREV9lzFFv98SEP1raTBUJxQ8yH/Hj5SQ/RbYU8sPJsP9JvFF2y7fdF0m44ijeOkIzIy/6bJ2mnKNpULJzDt6FELwshQCOgnqlcHNEA9HdGpIT7S0EunbPB3huA6kPrtwZK4Yw+5NtvFZRlNDdA7AhWDxDdz5oM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3634.namprd13.prod.outlook.com (2603:10b6:a03:226::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 11:24:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 11:24:01 +0000
Date:   Thu, 20 Apr 2023 13:23:53 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net-next 4/5] net/mlx5e: Properly release work data
 structure
Message-ID: <ZEEgyYU6GK15Ap6Z@corigine.com>
References: <cover.1681976818.git.leon@kernel.org>
 <f6c4092e54ab1e3c88a172ae08eab86297f9a9b3.1681976818.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6c4092e54ab1e3c88a172ae08eab86297f9a9b3.1681976818.git.leon@kernel.org>
X-ClientProxiedBy: AM0PR02CA0214.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3634:EE_
X-MS-Office365-Filtering-Correlation-Id: bdee4f64-8d3a-444a-2b4c-08db4191bd96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUrZV3xrw4Zkhncp6p7QtWlQ/vKcJHdwtZn1lZ/LRSyCE8t40Dg9CRLwn83/IDhjgxEPR/jnwtKffOAmhr1PV/FyQxFMo80WIk0rwcWufTch+LfmvEqwaMUMj3QhY9Hv72YuYTAHYDCdYyn+c1cVXvNXLqo09Rt9r/webNqPjsDYIRioGq6PGzzuO66OvOBJgARWyHqk8iKAF331yNO8ZWMmQSJ3TTSwx5zAvQQtE+0OJlMAcUAINYIh9Ze0lSL3iMtwJA3YoGO5CD6FWIize/YT6ndzxqbA8/qTE1slYMtqwTvashc+/JnnyeGjuDUT4ONH6UrlQMIiAFQdVt2Cwuk7ibzOaxum181NSjSrTpoZS2IiS7zl6cJ/Ach6soXSGxgtxjfzymwCWDepM1xgiHTBni8AqcoeryyE4QPQJUT+sXyLkXken02MhAcMyh67PFn4k8f9l1mswOYBPZXEVCiMHpK32flTkFwrsDOZK1VRLacucOcgAZsDghhXZIZ569SZ2Mk9HeDoAhikNnRpJcm72dR/zqE6f7wpd9M6RUi7VqEzHrG70/rCnPovIR/m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(346002)(396003)(39830400003)(451199021)(45080400002)(54906003)(83380400001)(478600001)(2616005)(6506007)(6486002)(6512007)(6666004)(66476007)(66556008)(6916009)(41300700001)(66946007)(4326008)(316002)(186003)(7416002)(5660300002)(44832011)(38100700002)(8676002)(2906002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yR9hz0k9ZJ4mrnlTJ3GhCidA5bLmJ165L/bhGIWgs5t3x7HuZotCOt1CCZMv?=
 =?us-ascii?Q?2eD/q9p6OglHi9ZyWAxD8WjOyM/TYNHoFKIl96V8EsTMBZEFNbnnHbMDXo2Z?=
 =?us-ascii?Q?thKYSLvZwnzHAI+r1rNiBZY/UnGE+G2YNq1OlbAgEitc0yA3E8e9V2/1s3q9?=
 =?us-ascii?Q?6W4L2+MtdfKCoKXCfCGinn6LRtxe/2PPB5KCgyifiRnwa+RRNWVC0OSYjuZH?=
 =?us-ascii?Q?I4spjUP7mJBc5smD4TIwsoCXAH2bQQL2m6Y3LA+VOpAOHPiMyzQET7oNLmya?=
 =?us-ascii?Q?Fd5uZ6Yb+32qhppwSSKrJ2s5bVSEToIkOL2bWAJGVwzVheo282vN4bsMxLGL?=
 =?us-ascii?Q?hCty5JKgyYjWltHuF34re0VEsliphMaIa2TbJyv7uS/TJruTR/9tcaXMjYoY?=
 =?us-ascii?Q?8jD4vYCFGaw/h4eovRb6ftCgQofNtxGMkalv7X+/10MFbSwTyhO/7Yp81paf?=
 =?us-ascii?Q?OLgNj/ASo5jLWGhCO4146HwLQA04qVVGbpD1Ls+z8LPm+GaZtWZ7A33gqTnA?=
 =?us-ascii?Q?MLhudi+jAHjrCM7bOwcjwmZvlIGjAIHwSQIJLKK9PUL3JFTtxaCV1rl3ClY0?=
 =?us-ascii?Q?X8gtynXoEEUo/EdPCxEzeR0lJSSE6zDOCGqw5mIQpdbMbTcVLXPcFXn0ITQo?=
 =?us-ascii?Q?/Fb/EWhQWFc9M7BSh7yFQS1pmSVD4XvUGjhaN5lgCMUlVHWke2zZngUzJad+?=
 =?us-ascii?Q?sTfYfNh4qIDKBHe1emPLYcRpdyaEJWoifUF4PFbMRYa20fu6yXUiBh/LI/6z?=
 =?us-ascii?Q?VkIO8FLG4ZO/OR0NDOQEwWWizTIJf8B5YFVgp6lphuQwqv8uyN5mFHgGnn3C?=
 =?us-ascii?Q?pBD53o9sOrfNSBgM1K6aCSWTTbZ3Sq2OApIztSTdoCrOLnk4UA5lXnxHJyMR?=
 =?us-ascii?Q?TaU57nT4y8BeW7JRzSmLZ25ILpOhUpboOquJXPNoGLTJy6yTgxadpbyfKXKU?=
 =?us-ascii?Q?Dfu+7UOsnIg5azwnnZ5O15qAzkPFy9oHXfZcac7zrqHnDsM/QXCqYUBFUzoc?=
 =?us-ascii?Q?19bgNbvNFCcXFF0371kqCg4pkbgtg+RvgiFP6d8vkoHCGCVTKFq9au8QgCbc?=
 =?us-ascii?Q?UqRy4HZIE/3KAGs3isHr1CUWDBmkWUw5UtEcqgNIP/tshY+pPMgWqchm+Wbn?=
 =?us-ascii?Q?iWp0l4xYMZbjWLWk8yb4/qu9GHPN7R/FBlBpixC23FsP9W2qLaUypFBrB4Tp?=
 =?us-ascii?Q?oI/TK/2rlDF2R4dzroYYRO2UXptfgtVw9Qun3S5n0tQuOotcRCeYOZPlEw4P?=
 =?us-ascii?Q?Z4d0GK9erjtEI0b4C6RP/thQs0K6hQyFKkru2c7YyvTi3FglpYgeCDBt2IHE?=
 =?us-ascii?Q?tQPSL6j0zh/rJvEs1+KRl9q3xfVM9v3qhQETMAM0TUz5/1zuDNAnly0GdnuQ?=
 =?us-ascii?Q?J0opdh+w62MBbkMtJJy0al5Pmk+wA4UVqhbQPSOv2TxECzIX038ibiooxPH9?=
 =?us-ascii?Q?UVzXLwD75dpwOEZTMbkb2eoEO5VP6406p4khUJRBAPjCDUff5XiVGaDrfNsb?=
 =?us-ascii?Q?kv+1wniJHYmWwIouWNYdVvLK/cUDyr7Db4ZvCvVAdHdQ4mrII2towAImhWMz?=
 =?us-ascii?Q?saU7sSEsRTLVbprUEJSZZtCXyDtmqp1wAyr3LJAO/v0xJPx9O+Y/iNyfAdi3?=
 =?us-ascii?Q?yI5i/C6ADI59L1YGszy1VHivozzqRL3bGYcIEGjgAQCILqbmfVa9uNAp6HVR?=
 =?us-ascii?Q?OZppeQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdee4f64-8d3a-444a-2b4c-08db4191bd96
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 11:24:01.1501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqYFG8etSrgyxfYns7yU4MC0D4wFMep5raGEMJXwER/NWQ6K9WbqfOovN8MOvxQ3SVrfAB8UJZ4AlUMcyKDF6br7RroZ8qcU3ps+BElQEDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3634
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 11:02:50AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> There are some flows in which work structure is not allocated at all
> and it is needed to be checked prior release of data structure.
> 
>  general protection fault, probably for non-canonical address 0xdffffc000000000a: 0000 [#1] SMP KASAN
>  KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
>  CPU: 6 PID: 3486 Comm: kworker/6:0 Not tainted 6.3.0-rc5_for_upstream_debug_2023_04_06_11_01 #1
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>  Workqueue: events xfrm_state_gc_task
>  RIP: 0010:mlx5e_xfrm_free_state+0x177/0x260 [mlx5_core]
>  Code: c1 ea 03 80 3c 02 00 0f 85 f5 00 00 00 4c 8b a5 08 01 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 50 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 b7 00 00 00 49 8b 7c 24 50 e8 85 7c 09 e0 4c 89
>  RSP: 0018:ffff888137a8fc50 EFLAGS: 00010206
>  RAX: dffffc0000000000 RBX: ffff888180398000 RCX: 0000000000000000
>  RDX: 000000000000000a RSI: ffffffffa1878227 RDI: 0000000000000050
>  RBP: ffff88812a0c8000 R08: ffff888137a8fb60 R09: 0000000000000000
>  R10: fffffbfff09aba0c R11: 0000000000000001 R12: 0000000000000000
>  R13: ffff88812a0c8108 R14: ffffffff84c63480 R15: ffff8881acb63118
>  FS:  0000000000000000(0000) GS:ffff88881eb00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f667e8bc000 CR3: 0000000004693006 CR4: 0000000000370ea0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>  Call Trace:
> 
>   ___xfrm_state_destroy+0x3c8/0x5e0
>   xfrm_state_gc_task+0xf6/0x140
>   ? ___xfrm_state_destroy+0x5e0/0x5e0
>   process_one_work+0x7c2/0x1340
>   ? lockdep_hardirqs_on_prepare+0x3f0/0x3f0
>   ? pwq_dec_nr_in_flight+0x230/0x230
>   ? spin_bug+0x1d0/0x1d0
>   worker_thread+0x59d/0xec0
>   ? __kthread_parkme+0xd9/0x1d0
>   ? process_one_work+0x1340/0x1340
>   kthread+0x28f/0x330
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork+0x1f/0x30
> 
>  Modules linked in: sch_ingress openvswitch nsh mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_umad ib_ipoib ib_cm ib_uverbs ib_core vfio_pci vfio_pci_core vfio_iommu_type1 vfio cuse overlay zram zsmalloc fuse [last unloaded: mlx5_core]
>  ---[ end trace 0000000000000000 ]---
> 
> Fixes: 4562116f8a56 ("net/mlx5e: Generalize IPsec work structs")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

