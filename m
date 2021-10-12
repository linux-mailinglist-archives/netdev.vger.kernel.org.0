Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F9A42A748
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhJLOex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:34:53 -0400
Received: from mail-dm3nam07on2076.outbound.protection.outlook.com ([40.107.95.76]:40576
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235294AbhJLOew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 10:34:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsZpVYWDXIGnPtKe3rcAxbF03GAJsfbM1pus0+wmQ6kG6ehFFGdMcVkT7hEbdGSTS6D6uNNRLY8LLf7sW4NsbDGCwjUl9cglSLIK0zeYkooTzpVARJOYPADSneeFqXTeHVnKoSo20hbrvAH0QppalprnDcq3gTSY7pTwqoa5sARjLJKKsRMoG237qkiVPjfHS1wabRlJRkPP09M227Z0HjtqWBqwVZoaNb3rBgtoNBuEt+0DzeAmHurvu/Zlsg+xKErhVS19veXkZPiBLeVJSORge/Ew99u7dhtRfoq9q642di3xtbacjV6oifpIUeo+sJopC/apFIeY23fjcRpaoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLVjg/lnz1LdqBGGYvGDsTRj026Shqs5Rcl6kTmFcFM=;
 b=Sx/pf3ZMMs40B8gaRdPiaECxZDVkraiq5wiAoRR1RdbH204+Cx8/AL8Nf3BdWrsFFCYl40OBXIosgpawKKsKuInaOSjJ6nYU/bXuoRqwMFLaAGG76FzWGZxG/1NytDb+/o6l5vYOi5pQ2QQXiAUnWkWGyPHHwBJdK7cTEFAd4fYZ0RXveg1ZAYED6da3Q5xF81Zil4z5UAnc932ib8If2/jTLmR6TpU20Ss1s9iSAB0xkx2tlbJ8AGVAtIUrWmqrr18MkKPVilnw/9kdnPt6T+lv3HyzJwlNWOdldWn1uJXQlt6T5ruE8ExTgWzqrbVe94BVVSJCkgcf/RVdQtEAnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLVjg/lnz1LdqBGGYvGDsTRj026Shqs5Rcl6kTmFcFM=;
 b=KObpfEXmpnS6OT7FmyC4Ql4k3vstIYI3Mt72BAev3I2O5Gpmhu0lJAIitbAaIU4fyNTj/ZMvoFIXTZq5vHVqFZqqlPcKKlo/ADw8aFrE++mDeTBdIJlToDmbrm9SHOEgVy/UUI+DRO0an6AahltixgtXwXRSeqS95XAidym6FpkhFqkrfZzYWvDFtXxThYXhl61McBikwffsTk9k8ek+BuQ1FnZB8IEu+42bnMwZ4n6573SmpGE3s7LK+uuoaE+ZNu6ZfCI6WZeDHRVhYrqgj9HyB3ydtth5bK4tK6iM0XWLMiFDNKBfl5q4Iv/KwUZxa5GrFNk2cTUs8EiDx8ibFQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 14:32:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.014; Tue, 12 Oct 2021
 14:32:45 +0000
Date:   Tue, 12 Oct 2021 11:32:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 1/7] RDMA/mlx5: Don't set esc_size in user mr
Message-ID: <20211012143244.GW2744544@nvidia.com>
References: <cover.1634033956.git.leonro@nvidia.com>
 <f60a002566ae19014659afe94d7fcb7a10cfb353.1634033956.git.leonro@nvidia.com>
 <20211012125234.GU2744544@nvidia.com>
 <fdae8091-337d-a21d-d31d-5270e5029bb8@nvidia.com>
 <20211012140433.GV2744544@nvidia.com>
 <YWWYPCHv6moPv5pW@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWWYPCHv6moPv5pW@unreal>
X-ClientProxiedBy: BL1PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0075.namprd13.prod.outlook.com (2603:10b6:208:2b8::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.5 via Frontend Transport; Tue, 12 Oct 2021 14:32:45 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1maIpg-00E3gf-Sq; Tue, 12 Oct 2021 11:32:44 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 445d50ee-3b2c-4d06-7134-08d98d8d2856
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51118DA54FD7589241233D11C2B69@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fpeNWlnXT4ALLefB+shHc+YI5dRSjn30Uo3YhQ3iFlxw7oakqIIm0m+5e+Pge8cFB6Uu6OKq0xD2od8eWyR/0J1HqftYKgiWapWGkLKuSWI/jlYSjJZJKk8nhZPkeuejdEkd6qLjchqS9NnhBdP0YoNjDkez6XucNlu0xMEbjkEdZscdaCMcsBp1i/cLM8zyYFGJROZNxAy7dvvAWI5Gn6LPHzml+/u8/+ga0jxHoclDxYmWqG/Il+plw3KSWnTVrusk4rjpxxYrzXsqiZSfTP4ykOelFUBSj88UdMozO6NvnnMxFHdrDWTyEIoNdRLWdXfvUlJ+puFwN7/8tC7EKCerc29I4aMGlWCsUt3ZAcIcoPYHyfi2Abh6xZXKxc2GOuE3NJdid86CubeNJyfqizdkZQgi11rrLNR2/pS8OWxK8bbBPx8edRoDxUW/rAQup9/60syOS4VX4vYCKJdcRMBo+0kWwRtKwA0Hhm7MDgjWl9LFy6Cve8TvXrNLcSpsjKyycfTS4E2zyobPSyxM26UMKbbzd2DX7SsxGlbap0j6thHdTv6O/nFZ7M2wvt3oPIwzF25dy48BY906Yeml0ebRSN/fI8dfpbVODsJ3LYQbXrkh+6YwBRAXDXVuff7li00843gwq/XM2oCvXO6n1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(9746002)(7416002)(9786002)(66946007)(8936002)(53546011)(186003)(26005)(38100700002)(36756003)(1076003)(86362001)(8676002)(66556008)(66476007)(4326008)(54906003)(2906002)(316002)(6916009)(33656002)(5660300002)(508600001)(2616005)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5kRKcaoDDE+tnKyjywSq10EXKa087Mx7XXFoQyJIt41UmOH54IQh/moRT0W9?=
 =?us-ascii?Q?DKrS3x0uSenXZURqm4ol0LDQ8BaaVuqkHLlhRPOD9xohb0xBkkEVgSNiPh6s?=
 =?us-ascii?Q?eHQaKQ51zWYt5Nv7kZtbQqa8pcNeGsZcEz+3+VojKP4glw/SKtH262bAwZo2?=
 =?us-ascii?Q?3bL9zcxXhvAEXHDkHjr7B+xwnDscIr1zGyrkA8HlC7PMG3r9dQpUTrqEg1IJ?=
 =?us-ascii?Q?9mxbeHqKAroDjj6+piq/Q/7RQOTXSez0+S4ou2KpFh+QO3gj9zG2SCvKFkB3?=
 =?us-ascii?Q?+Nss5OB+N7tEd6iTZLXCPc8EjUOiqh2hDmKNC+PFMyH5ThCH4Wa+O9JopbZ/?=
 =?us-ascii?Q?GqrsgP5OjapmqZT619bgAuVr0+iag7p4K3Pl5r55TdsN21aXlHnqZtU8bvqb?=
 =?us-ascii?Q?kc/yL5I2DZzS95MfjdOfSv3Cu0rXdpz9Ou38AeqRDxXW68PIYCGea4Towzgp?=
 =?us-ascii?Q?jbkIHcGO2OKnZeLZD8RDA9gN6slfAMPLCJPyMgDQNckLywoCkK4eAXm0idvV?=
 =?us-ascii?Q?W/vFC9geQhcZ0daZ+F7jqpOcojnrAudUQEIVZjEa7fQY6puurBVWx9GWbIUH?=
 =?us-ascii?Q?LRh0OKYOSJDK/sUugwNZCVVhKnnMSo72r3J1gdeGxD8BSTHDaeXo5cuJh/TV?=
 =?us-ascii?Q?BPkigUTIlCzDJdSNr/jnSIyv0SEpgGY6vgObmVUSlyA2pfHWYwuj03772jUv?=
 =?us-ascii?Q?PPJdARHMtby4bw3vAiGj3jgM85V/IEYSio2aR1S4X/uEERknRAEzht4AwVyS?=
 =?us-ascii?Q?RXAfk71aGiFRip7jxqxyMi3Fh7vMkAJFdnGb4FWw033PAqQT4rINFBRi61es?=
 =?us-ascii?Q?VQX9RCDlxp1Szwq4p5igQFtK20jYzqu4nt9OfGaQ2wwe/94iOsH2H//pKGpO?=
 =?us-ascii?Q?OqGNpLmMPNWTi4UpBov5YHVdYFxIVY9Y8Wot4izWU1rkH6mWlswwpwe9hQcc?=
 =?us-ascii?Q?Zvp09LGSUpl0CW/IVNHJSSkw5wKXegqDnjOrqgnvVXfNjgbff6wDASpWAzzp?=
 =?us-ascii?Q?pPx5XHC9HzF0aNVloun4U/KPyiSBrREt9R+jPuY4xvsAcJvS+YvJY6YDv/Wh?=
 =?us-ascii?Q?QjD972MTklL6TejNYSgpwGxLOHB0dDzvUAJ/EFa/TibbzByahfoekr6ntQdC?=
 =?us-ascii?Q?vK+7Wv6AlKD7AyV0W3RB0KLEkVZCwcEO8bB0pnz5TEMvTW4fQAseWyMi7Dw/?=
 =?us-ascii?Q?DiSfOnJXWZZc5IuXXenQM25QM65QAwAbxnFSorbShXpw6fq8WzrX+knjFNqj?=
 =?us-ascii?Q?dzT7zgs/eeovzr8xrhgFSVARcwuiLA9o4OSJRWVpJspxXsf+O5w5KrBCGsAk?=
 =?us-ascii?Q?otAoVg8Sxnn7rPEY6KvgKeT+l7d1E1QyZ6o6XQliqtYrEw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445d50ee-3b2c-4d06-7134-08d98d8d2856
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 14:32:45.7927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4Q45Fxd1nhWsfbqsrLcb0jVfZ+a9efFseGg2yynQPW3IF4rpuwabYlTOkIDaCOe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 05:14:20PM +0300, Leon Romanovsky wrote:
> On Tue, Oct 12, 2021 at 11:04:33AM -0300, Jason Gunthorpe wrote:
> > On Tue, Oct 12, 2021 at 04:57:16PM +0300, Aharon Landau wrote:
> > > 
> > > On 10/12/2021 3:52 PM, Jason Gunthorpe wrote:
> > > > On Tue, Oct 12, 2021 at 01:26:29PM +0300, Leon Romanovsky wrote:
> > > > > From: Aharon Landau <aharonl@nvidia.com>
> > > > > 
> > > > > reg_create() is used for user MRs only and should not set desc_size at
> > > > > all. Attempt to set it causes to the following trace:
> > > > > 
> > > > > BUG: unable to handle page fault for address: 0000000800000000
> > > > > PGD 0 P4D 0
> > > > > Oops: 0000 [#1] SMP PTI
> > > > > CPU: 5 PID: 890 Comm: ib_write_bw Not tainted 5.15.0-rc4+ #47
> > > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> > > > > RIP: 0010:mlx5_ib_dereg_mr+0x14/0x3b0 [mlx5_ib]
> > > > > Code: 48 63 cd 4c 89 f7 48 89 0c 24 e8 37 30 03 e1 48 8b 0c 24 eb a0 90 0f 1f 44 00 00 41 56 41 55 41 54 55 53 48 89 fb 48 83 ec 30 <48> 8b 2f 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 8b 87 c8
> > > > > RSP: 0018:ffff88811afa3a60 EFLAGS: 00010286
> > > > > RAX: 000000000000001c RBX: 0000000800000000 RCX: 0000000000000000
> > > > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000800000000
> > > > > RBP: 0000000800000000 R08: 0000000000000000 R09: c0000000fffff7ff
> > > > > R10: ffff88811afa38f8 R11: ffff88811afa38f0 R12: ffffffffa02c7ac0
> > > > > R13: 0000000000000000 R14: ffff88811afa3cd8 R15: ffff88810772fa00
> > > > > FS:  00007f47b9080740(0000) GS:ffff88852cd40000(0000) knlGS:0000000000000000
> > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > CR2: 0000000800000000 CR3: 000000010761e003 CR4: 0000000000370ea0
> > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > > Call Trace:
> > > > >   mlx5_ib_free_odp_mr+0x95/0xc0 [mlx5_ib]
> > > > >   mlx5_ib_dereg_mr+0x128/0x3b0 [mlx5_ib]
> > > > >   ib_dereg_mr_user+0x45/0xb0 [ib_core]
> > > > >   ? xas_load+0x8/0x80
> > > > >   destroy_hw_idr_uobject+0x1a/0x50 [ib_uverbs]
> > > > >   uverbs_destroy_uobject+0x2f/0x150 [ib_uverbs]
> > > > >   uobj_destroy+0x3c/0x70 [ib_uverbs]
> > > > >   ib_uverbs_cmd_verbs+0x467/0xb00 [ib_uverbs]
> > > > >   ? uverbs_finalize_object+0x60/0x60 [ib_uverbs]
> > > > >   ? ttwu_queue_wakelist+0xa9/0xe0
> > > > >   ? pty_write+0x85/0x90
> > > > >   ? file_tty_write.isra.33+0x214/0x330
> > > > >   ? process_echoes+0x60/0x60
> > > > >   ib_uverbs_ioctl+0xa7/0x110 [ib_uverbs]
> > > > >   __x64_sys_ioctl+0x10d/0x8e0
> > > > >   ? vfs_write+0x17f/0x260
> > > > >   do_syscall_64+0x3c/0x80
> > > > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > > > 
> > > > > Fixes: a639e66703ee ("RDMA/mlx5: Zero out ODP related items in the mlx5_ib_mr")
> > > > Can you explain why this is crashing?
> > > > 
> > > > reg_create isn't used on the ODP implicit children path.
> > > > 
> > > > Jason
> > > It is not implicit ODP flow, therefore, mr->implicit_children shouldn't be
> > > set.
> > 
> > It should always be initialized. That seems to be the bug here, add the
> > missing xa_init as well as delete the extra desc_size set:
> 
> I would expect such change in mlx5_ib_init_odp_mr().

It is too late

Jason
