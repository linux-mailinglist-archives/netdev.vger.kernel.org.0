Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DCF42A6B3
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237140AbhJLOGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:06:40 -0400
Received: from mail-co1nam11on2075.outbound.protection.outlook.com ([40.107.220.75]:29537
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237015AbhJLOGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 10:06:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JN2GiPWq+NpJRBITsK4drm7c5gftjp4QQyKn3kbHzGrsCnOB133MczoLyK7n2d6lKPU3AFDLucatvV2ypAOmKKRV5ZXxG5+jfp4lI4AQjACj7omDgyr2V3jX0XezqC2An/FgfwXhYIQ0299QMljV1ARPVCUfX4GO6qBScvxqITSXtRpzi6FpbHJD4Az4YwUwF3W86q3ke49FUenZL7VlD261JGuZDlge3v5Udewdc+AgKjKlxoGTvac6hqxuFlDbGxclFzo0af70jzspvu+E9Dp8PSNhkfdtglDbaGA4iG7ymaiWLhGsVsbAzSy8GwCE0UPHX110hXJk8+if2V7gtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e79K3IuCTxJH684CMW0wmzxzKmV7zQVd9JBwHvmmIYQ=;
 b=mpYNHrK09H3mdRY6duuChOHLDpdVFh6PcuIPFkoTAtKUOl5WUAWLw1SyWQS3Tq6r/uCHW8xHkgESzVYjwlPBJSzD6pxwhJjnIYzug5+d5lNwYEZvJwdcDynSgVKTYMBu5auj/KksbHeZm3E2Dl/uBSPueFaVpTvoGvpD8/SF5Y8O5BcfRIRl/E/Az1JGRMbzMc8d/ilWfmnEkEa5IQNKDicOSIyr4cH61yHt5FU3fagLJBrFwntbSivBqfI9yMvdLUDxZE/6MFT/BRdzRW1wHIg45S31HsRCuQDVJGYFpUvRpHSI4TyIucVUaiGF7eDlRgFbF7pO3mVnYXamd0DAKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e79K3IuCTxJH684CMW0wmzxzKmV7zQVd9JBwHvmmIYQ=;
 b=apd66kQUQKLu4Mm02k84S64ut5BRgDPyYY2syPjh5XRWZ4d6y66xqes2gfGmXh+Dfs/Trnn4tXoAco7bGjD5VGMWm1qnWgFEN1CNxFf6M22jHJd+P11lMugUJR42Z7zwcfeOmq9W6vWB8F0IlzdRVlje91NdD+L2Y4rknaYihUEG3BvHxlJmpR2gce6cmINdB7TFpnUOCl7M5iq6B3C/LgZesvZfr3wrySOmUkX3G1bmPucJF3rxhwJYJMXuNwcF0u8L8Jt1GDOLALSnoF4evS9Msp/FE6RYRm+6v1H30tgMQV7RQCypTAEsjj8FGU+5ZrfF2s9wuXKWWjAJnZtJ7Q==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Tue, 12 Oct
 2021 14:04:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.014; Tue, 12 Oct 2021
 14:04:35 +0000
Date:   Tue, 12 Oct 2021 11:04:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Aharon Landau <aharonl@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 1/7] RDMA/mlx5: Don't set esc_size in user mr
Message-ID: <20211012140433.GV2744544@nvidia.com>
References: <cover.1634033956.git.leonro@nvidia.com>
 <f60a002566ae19014659afe94d7fcb7a10cfb353.1634033956.git.leonro@nvidia.com>
 <20211012125234.GU2744544@nvidia.com>
 <fdae8091-337d-a21d-d31d-5270e5029bb8@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdae8091-337d-a21d-d31d-5270e5029bb8@nvidia.com>
X-ClientProxiedBy: BL0PR01CA0010.prod.exchangelabs.com (2603:10b6:208:71::23)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR01CA0010.prod.exchangelabs.com (2603:10b6:208:71::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 14:04:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1maIOP-00E3O0-Qd; Tue, 12 Oct 2021 11:04:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d4948aa-5eda-4111-1227-08d98d893888
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB533680197E2BB984F82C87D4C2B69@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kSxOTkDMN+OfXmgjIKk2/ciJaubkfirmmos/h0IuDrzjWrCTOomS08SH27IUwaWXcCJjWAKgSslO5Z6FNZxkEu5f00zW3tVrJWat+zwtMOa4330Q7rmuZBz9MuJrrhXWc3ODPca31ALgpkBVV3oAfXuxHiPZpeBFB3nU8mZ5G82PQh1UdRLEDkYALMueX1iv2MRpCrWHuy0NDvk56ITfh2XPA/IUaQjUCU9/5cgi0erU9N6TU6mnmpry6W25WYvTGpP/F0adlPaYsncEjGMaq68MggtuKDIBUC+dqGDmCSth263QJ5vBtp8/2Kc4+mpU/ddKJKc4lGisLZVTyGPmoHqb11JuFaQ3TYt73/NWTsivKOcIKZdjogukTUDww//w2V06UKL8UMrVAFCu4KWpGbB03xXbCfv0VKPNbh+oq2muLLvOXLRP49H0+dGRakgZEbu851Hn5AXdR8Y2246Z5p579BvrtR0YzOtbbXHWzoLdjkHJYQD5kQ0EVn7xcARM2njEDZVOuTaWtaGUimYrQrrvzF8xcoWTFlt4KhoM2kpxqExm0F5EY8g0EAG+HJK0oTRQGT9oo8i6KIWIlR1JRqA+AchhfzkpEqLK62rrtPyLQM84GnMDLvZpHuwFb4WmZqUfPsT9t8MzSSkXjxUcjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(5660300002)(1076003)(508600001)(2906002)(6636002)(38100700002)(66476007)(2616005)(186003)(36756003)(33656002)(83380400001)(9746002)(9786002)(316002)(8676002)(26005)(6862004)(53546011)(8936002)(54906003)(37006003)(426003)(4326008)(86362001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vr0F8b+Emw7HgMXgs1Z7p0d9U/A52GiSjG0QsCDGrtnWko7QMzJbf0lBayJd?=
 =?us-ascii?Q?9XvakV+cWeC6nVwD6g94zTtdG5DeDtiXBkytmaVg+g/q9RVw/bGalcPlppUg?=
 =?us-ascii?Q?vKPS6armjF/GOA3/2DYqQGJ5Hu3uJVVvGHTDUKQqcgXTBPfQZKuKMrQRCI+/?=
 =?us-ascii?Q?6sYyowIRXi7ssrx1ujfP/Q1G/mhEdGrl+6U9QMAT0CaC1YwJhyCVO2ITxrP9?=
 =?us-ascii?Q?bqighenvSj1AS19/n2SCF5412BkMcQWlSSQrAtCqssg1ViJzEWBLoJacvWbz?=
 =?us-ascii?Q?FfNXxza4LjZgNEz/0BTLNgu5/eepF/r1icQq0bhvD9dnkhK3l+R9+UmEaPck?=
 =?us-ascii?Q?PGXAwLrXFzKk8j5uTKDjZRgB2zDZmFsdCbzYwbvJ21mnw8qPa7HXhgrJPE1L?=
 =?us-ascii?Q?2KGFB7y883Fcr45BCgN1w9xbppDgcFpt6VUQGe/9VJznVXKPactfuQ1/ybmv?=
 =?us-ascii?Q?A8sYoF6OiPx/OR9rLARtyLRsspWdarpuuP/m3XoOVwNN+4tylo9wd/OBkgFg?=
 =?us-ascii?Q?d+RPhoj7MoFqpgx9Z4c+/SOsFaMgHPaKXnnzX53Rp3XVV5vCz7B05gdw/WKh?=
 =?us-ascii?Q?NsxeC1utHOW+2OpmVGfZ3A/PQWgj/dp05flrJ2S3goZ9Ntdz0utnTehEeMrL?=
 =?us-ascii?Q?3YXkGvnEq8ewQEDH1Azpc/croIAIXhInabsud45xtXw46zsgXHt+VleC3BWE?=
 =?us-ascii?Q?pUAWz//0Ole9t/JhQ+QHHJiN65wgcHE41CgNzBrn5VpP2H9Gfl8sp4mSNMoo?=
 =?us-ascii?Q?hy/m2HfxFqrwtb9BB6Eicazs5Yvwr824PYbznU0COr7LJ4HhCATPcQNWo4Gi?=
 =?us-ascii?Q?NIszIf1Lobe+wqBTteERsL5ZDupwlucWEiAJjCwFbdzjI0E+VCefe8oiQVJ1?=
 =?us-ascii?Q?LvjTUcRelNnyX05a8kcxMCHX2y0Samk/oa/0bp1NTB+0DmkxsnWF+kCEnRHO?=
 =?us-ascii?Q?YnXkkSfVakXgA7LnvD79ipbmoNjWNiW2yXVtOIoYTwJMQQzqXbT7+qi/foad?=
 =?us-ascii?Q?UKkW5uAtYrgU+0IxI2YtUKAoqtzaoNBPY2Lk8dGMi16AHP6jS8jk8izWfq5l?=
 =?us-ascii?Q?Em/CSoo/nuKd5NQGAoQZYwhRWA6BSZDfpfSgrteigP6BzoaGbeWu+/Qogfi0?=
 =?us-ascii?Q?JJ+H6qfZXtIcd7kLHEEgojW6jXDS7p9LyvMwZ1sBwydIyztmENatInQd5nCn?=
 =?us-ascii?Q?5NwNJYa0JNHGAgs7NQ3mHOIkIF+0zy11aSugGVTSmTMzQluOvRAYF8EJkei7?=
 =?us-ascii?Q?+EuBEgSK4wopwQ4UF0ejold1kfOfPsMqcj9tKGjn1s6Ju+7qEccuLANDz3h2?=
 =?us-ascii?Q?1u9YZ8t3NG+jWuJePETohu+n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d4948aa-5eda-4111-1227-08d98d893888
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 14:04:34.9786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 959eSVduXpNn08B9OVSRtrbKHVcDJlBHxQ0cwpShpmg/TKmNgMiiQk+mcGuRkF1k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 04:57:16PM +0300, Aharon Landau wrote:
> 
> On 10/12/2021 3:52 PM, Jason Gunthorpe wrote:
> > On Tue, Oct 12, 2021 at 01:26:29PM +0300, Leon Romanovsky wrote:
> > > From: Aharon Landau <aharonl@nvidia.com>
> > > 
> > > reg_create() is used for user MRs only and should not set desc_size at
> > > all. Attempt to set it causes to the following trace:
> > > 
> > > BUG: unable to handle page fault for address: 0000000800000000
> > > PGD 0 P4D 0
> > > Oops: 0000 [#1] SMP PTI
> > > CPU: 5 PID: 890 Comm: ib_write_bw Not tainted 5.15.0-rc4+ #47
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> > > RIP: 0010:mlx5_ib_dereg_mr+0x14/0x3b0 [mlx5_ib]
> > > Code: 48 63 cd 4c 89 f7 48 89 0c 24 e8 37 30 03 e1 48 8b 0c 24 eb a0 90 0f 1f 44 00 00 41 56 41 55 41 54 55 53 48 89 fb 48 83 ec 30 <48> 8b 2f 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 8b 87 c8
> > > RSP: 0018:ffff88811afa3a60 EFLAGS: 00010286
> > > RAX: 000000000000001c RBX: 0000000800000000 RCX: 0000000000000000
> > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000800000000
> > > RBP: 0000000800000000 R08: 0000000000000000 R09: c0000000fffff7ff
> > > R10: ffff88811afa38f8 R11: ffff88811afa38f0 R12: ffffffffa02c7ac0
> > > R13: 0000000000000000 R14: ffff88811afa3cd8 R15: ffff88810772fa00
> > > FS:  00007f47b9080740(0000) GS:ffff88852cd40000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000000800000000 CR3: 000000010761e003 CR4: 0000000000370ea0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >   mlx5_ib_free_odp_mr+0x95/0xc0 [mlx5_ib]
> > >   mlx5_ib_dereg_mr+0x128/0x3b0 [mlx5_ib]
> > >   ib_dereg_mr_user+0x45/0xb0 [ib_core]
> > >   ? xas_load+0x8/0x80
> > >   destroy_hw_idr_uobject+0x1a/0x50 [ib_uverbs]
> > >   uverbs_destroy_uobject+0x2f/0x150 [ib_uverbs]
> > >   uobj_destroy+0x3c/0x70 [ib_uverbs]
> > >   ib_uverbs_cmd_verbs+0x467/0xb00 [ib_uverbs]
> > >   ? uverbs_finalize_object+0x60/0x60 [ib_uverbs]
> > >   ? ttwu_queue_wakelist+0xa9/0xe0
> > >   ? pty_write+0x85/0x90
> > >   ? file_tty_write.isra.33+0x214/0x330
> > >   ? process_echoes+0x60/0x60
> > >   ib_uverbs_ioctl+0xa7/0x110 [ib_uverbs]
> > >   __x64_sys_ioctl+0x10d/0x8e0
> > >   ? vfs_write+0x17f/0x260
> > >   do_syscall_64+0x3c/0x80
> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > 
> > > Fixes: a639e66703ee ("RDMA/mlx5: Zero out ODP related items in the mlx5_ib_mr")
> > Can you explain why this is crashing?
> > 
> > reg_create isn't used on the ODP implicit children path.
> > 
> > Jason
> It is not implicit ODP flow, therefore, mr->implicit_children shouldn't be
> set.

It should always be initialized. That seems to be the bug here, add the
missing xa_init as well as delete the extra desc_size set:

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b4d2322e9ca564..46626e0fe08905 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1525,6 +1525,7 @@ static struct ib_mr *create_user_odp_mr(struct ib_pd *pd, u64 start, u64 length,
                ib_umem_release(&odp->umem);
                return ERR_CAST(mr);
        }
+       xa_init(&mr->implicit_children);
 
        odp->private = mr;
        err = mlx5r_store_odp_mkey(dev, &mr->mmkey);

Jason
