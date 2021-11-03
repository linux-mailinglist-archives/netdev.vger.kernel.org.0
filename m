Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53714442A4
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 14:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhKCNxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 09:53:14 -0400
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:1632
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230213AbhKCNxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 09:53:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNlWEqQMx+z4m5RyZeS1wPux5iWXrgweFlUKDXe8dtWgT40+QpjluJjMTg7Pf9lZTQTHCqmgIJB/i00d715Upmm4Y7SED2fKFcua2waVMV3N3z+LVveP86fEC3Gdd1MNyXtk1d0PaWuA7IXcKIVXykGjSSS6q62k+A2zpjoK9dN6n3G9iYneCfGTWLMdrkxsvag99nxJ1VSFGzvllJnW77tMjkFtiViDOZNseVVWOvkLAssF34Vco6emcV4u0nFOB4pDRnZZR/VyaVrAuqVOhEu8S4BT+fTfRFf4HlxU7WGWvPET5sBcJyHCWPZiR+0/O8XI/3S3uqw8LsKsfrmf6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mupIFXEBwFVzCwd6cniSSK023vRGtqMXuFb4gS2t9fg=;
 b=Rwo17wSSewEF3JyrH/D2pu+lvnL5cZRKD84pJdMcFk/ORD9W8lFocsztCAtiw/oV7z3rn8eIAyEVI4OM2Z9A/7Pamc5/aVmqmEOGXEiJ8yK/34YrWUSo2EIWOlAksDnUWjuSsd4LiDOnR2HdMpkOeH/O5A27K0T5I1Nzw6KXuWD+x5sfBW77JVAqPx3rhFKqsu1z++HBwWt90Cbs7ocOKJRfuOBwqZ2C1fFTsuus+jNDar2dStiF+I9H7sQ3CTudsLdLrajVjz51K/rWsyamdHwZ4F+r7W5zG64uCgfGGB3ys/IBeEkMknNO9f025pnBLAmwAc3r/QQYcobG2XVrPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mupIFXEBwFVzCwd6cniSSK023vRGtqMXuFb4gS2t9fg=;
 b=JQAPcltSwGtMeLOB1TKexWdr93y5MiHE/8T1xQzqbTv4u8ToiqIKNXOGH6yDecYnRSwjiUTp3wqMgHYODgpb1HZC1yX2HyPPY+gk56a0kpIxfB6n7uXL4tDpJJIu775NjuhPCd2l6E62CKWYL2l1RSLcChPyQPzVRHGw0l2w61pJTtTwFdGhvr/dA4+TicV/S6qy3qOz61m5E3qvBszkHjwDg2p+QolrUNcoCli+Lzv6pGMQU2miGn0hijtjCWGQA3rll6aarI/zXLtGCDDvNZt1DHr7n5y9xulH33LDfWThdQ7I/SVPC/OBXE5Q4+siKOCEeRPZTJN91/wc9xaUGw==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM8PR12MB5397.namprd12.prod.outlook.com (2603:10b6:8:38::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.14; Wed, 3 Nov 2021 13:50:36 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::8817:6826:b654:6944%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 13:50:36 +0000
Date:   Wed, 3 Nov 2021 10:50:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211103135034.GP2744544@nvidia.com>
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102021218.955277-1-william.xuanziyang@huawei.com>
X-ClientProxiedBy: MN2PR20CA0065.namprd20.prod.outlook.com
 (2603:10b6:208:235::34) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR20CA0065.namprd20.prod.outlook.com (2603:10b6:208:235::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 3 Nov 2021 13:50:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1miGew-005e7T-Lp; Wed, 03 Nov 2021 10:50:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73e6de8a-760f-4444-95b9-08d99ed0e9ad
X-MS-TrafficTypeDiagnostic: DM8PR12MB5397:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5397A816BDB8E1F0A6592D6BC28C9@DM8PR12MB5397.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JTMCBDc46FDtTNd9RIzYzXebl0Wu81IsDbIWJ2l/IGasnnPTiLRWAZrMWinH9/Rtl0szO1JOOigNzYQvuwSwNoFXC2OOXExp3druC0VQ9ct6+39UsZhrx5VZ3WCy628D/76UB2dXGzGf4nsbjaARdILtKUdaEFz2WIUX5KPQbd4UAa5fYuSOynmSdqFB6wtKg0ZDKNtbJ/aOx5GUazMGI64/exmRtoaDnaFo3jvHajVY03YXxvfdG+22qeoVKw7KRI7ZRVk1+uHg+XEDkVV/qSP6BCmhkIDc2UOw/kAQBaPEQIkbI8wJhGRTGGwpTJRoqvIe0dOFt1+vE64q+U38jfLW8xjo1XPWLmkWWM6G8a+/WtVupFhX/s2W1WPoEefYx8vycH7PymneahsWg6Zk7jOK1B303nF/VvcFAbCpEgzmwpq7ZNx/8vu7FK29U6Qodufc1Oj9QJtuK9sazCYlTrm4kv2nu+L8cvMWqizWEVjZOmgIHm36rYjCfoCiCLDLGDKh53yWgklHzwh0iv5HFgGs5D1bLDGOasLqwcl5ljXdhh8Uz4y0FNNSP6QcQarayCixj7fI+/r2L33vDGdqsmAuDHoWWvx6/Rgg3U1yyW6L+CxhPsedFEMeXmwPh64vn5h+2E2+K4rICl0ALFYI9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(26005)(4326008)(66946007)(2906002)(9786002)(1076003)(38100700002)(9746002)(508600001)(83380400001)(186003)(8676002)(86362001)(2616005)(5660300002)(33656002)(316002)(6916009)(426003)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y0PxJDl4bU2l709sLszryBO0z6gEEYzSx1XFX2WgpcBuC4ktCPgmqFHfe9GE?=
 =?us-ascii?Q?EUDxGCYfHHa24C0maeo9f3fj2fELCblaXBII9mdb8yWngOlaFvNwVSyEnFqr?=
 =?us-ascii?Q?z3lJpUZ69g4+Gja4noRpWCXewxRd/tkPcDIu4jB99ZzWG7t8JLgHGD9RqYor?=
 =?us-ascii?Q?MjrxCe0I4KJhd1Hxi7azUuahszsHST4xeV7IFMDVGOZZSyoUGIVw78ZKKNhe?=
 =?us-ascii?Q?Zj4n1Sxras46hYB709TxzrspTqamtlzxbGts9gQok0krcn89d9rpDS31ISvU?=
 =?us-ascii?Q?E4TfVH4HqfFW2yPXkTEFnmZODTPegdcfJSM2zwtfR9tzLtPnNN45/Sm4z/ai?=
 =?us-ascii?Q?NZS4SQI+hFriLnysSR6Rxq6mJ9VhjOt15t37wdpEiSvi/4gLee+Uyc0TfBlQ?=
 =?us-ascii?Q?4aYA3vzSNaqn4jNmk0gi8WoEcblmCJBgPHp+R2Nzs0RqLNc66EJoEhCk07XW?=
 =?us-ascii?Q?HHK4Kd/zuY7zmd8gyKfyu6/hhjqWJ57zW6Ill5BYgBPp3UySIokmy7omU3I8?=
 =?us-ascii?Q?LAQ7XULqBg/YFbNtznScl46m4ATETaXoFtfl2nm//aid7qHD0JrOodr2Hjdc?=
 =?us-ascii?Q?luOWyU7AaTvVqplwcGdw1adhdylWLx5sGnLiFz2GZr1TXj38mrOCdqpjN98G?=
 =?us-ascii?Q?5KklcAMtE6SPDN+W8Y3PlgLniUPrUe9R0HJAvnN4cTlEVUrVzQ7g+EZWXXp/?=
 =?us-ascii?Q?2DI+9ZA3h0xZvyrdFONWKat/PtTs5UwAMod5fM3rV0/6CbOY1oMM26rCE8np?=
 =?us-ascii?Q?IWjCXP2j4PdahkKRKHJLcS4fnWHaTJfa6KKV+H2G0Ap2jhC9LkINS1WwKNF7?=
 =?us-ascii?Q?FfHknQVOmGARWQUBPFbwnXTQKdl1zi9jqX6xmJb20QIhIKu2+WEaOuv0I+80?=
 =?us-ascii?Q?z7Ror5jdX5CD9lxekX1RkK2/W3MtKOnTTmfPLjIefGBm0RGo+nJF9echvCqF?=
 =?us-ascii?Q?G2th01VvM8ASVzA1B5+flgwb1TxC/hvqOQvfhF8GZlCeqcw1nvJN7CaAuQ3i?=
 =?us-ascii?Q?5x80Xac9IovAs5pQEROKJcgRh8VAYksfuYzqiwQIy7+YJJSV1K81A2nEP8cg?=
 =?us-ascii?Q?R2ICXzeXeSa7l+CSe48eJ6pp2jAiqGBfKZC5j0Rhi1AlQpgW08vopYDdSYRB?=
 =?us-ascii?Q?M4WOCHBf1JuQo9KneQl4KqvxOWM+kqRk2oYz7teYd7jrHiw6UWBIXbEcffj3?=
 =?us-ascii?Q?I/9IH7mShhWz8L6VnqLydPdJ8Snw+eZlZq9pR3k4KrVD9t0aginjdMWCLu4r?=
 =?us-ascii?Q?YG79orfPqbB2zzL5iYBasTffGYDO1oUe9mjuw8S3ZNASGOr2fXQi71g0Qu+G?=
 =?us-ascii?Q?5xBohsmHBTQtqAZQxXTV6iRoTvJ8nUp/CAm8gyul7TxlR1HN5fcbl03AGpyM?=
 =?us-ascii?Q?M6AGZV+m45ptXwB509ZF+CubqXuArvSNSupuzvAmnyiIapnWaVfnUScrgi7y?=
 =?us-ascii?Q?f7ZQrpLlCy8C4ZyNMSCiajzLm/k9599N/POsK1S0Xiws6XjHP6edb8rxwHP/?=
 =?us-ascii?Q?1VwKE4Q/fb5MD1E8c/hOHPOqc1ZP9nGQnLPCEte7b8ZkOSEqo8YZ6zyfQhcG?=
 =?us-ascii?Q?gV1ZH7+8TDqa2ctOm4o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73e6de8a-760f-4444-95b9-08d99ed0e9ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 13:50:36.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vuwsXz7d1iqga+y4HCNGI92RAumwFLTGakb6D4bLHHJRS2bPZo6bnTTqVEKD0OBZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5397
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 10:12:18AM +0800, Ziyang Xuan wrote:
> The real_dev of a vlan net_device may be freed after
> unregister_vlan_dev(). Access the real_dev continually by
> vlan_dev_real_dev() will trigger the UAF problem for the
> real_dev like following:
> 
> ==================================================================
> BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120
> Call Trace:
>  kasan_report.cold+0x83/0xdf
>  vlan_dev_real_dev+0xf9/0x120
>  is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0
>  is_eth_port_of_netdev_filter+0x28/0x40
>  ib_enum_roce_netdev+0x1a3/0x300
>  ib_enum_all_roce_netdevs+0xc7/0x140
>  netdevice_event_work_handler+0x9d/0x210
> ...
> 
> Freed by task 9288:
>  kasan_save_stack+0x1b/0x40
>  kasan_set_track+0x1c/0x30
>  kasan_set_free_info+0x20/0x30
>  __kasan_slab_free+0xfc/0x130
>  slab_free_freelist_hook+0xdd/0x240
>  kfree+0xe4/0x690
>  kvfree+0x42/0x50
>  device_release+0x9f/0x240
>  kobject_put+0x1c8/0x530
>  put_device+0x1b/0x30
>  free_netdev+0x370/0x540
>  ppp_destroy_interface+0x313/0x3d0
> ...
> 
> Move the put_device(real_dev) to vlan_dev_free(). Ensure
> real_dev not be freed before vlan_dev unregistered.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/8021q/vlan.c     | 3 ---
>  net/8021q/vlan_dev.c | 3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

(though I can't tell either if there is a possiblecircular dep problem
in some oddball case)

Jason
