Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED1E441C4D
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhKAOOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:14:12 -0400
Received: from mail-mw2nam08on2078.outbound.protection.outlook.com ([40.107.101.78]:19373
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232487AbhKAOOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 10:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wjh5WRVLYV0YmRD4vA051mvgRSmdBgsuJoV5OuA3wIwFSsSEEJna5BhIJV314eZqtLi53Ok4Yz34Ojbpx85n7bQOPDkHFhNEde6rAlGjIkoeF8A4Tci5/ELvKqtQlak/WquWmEbWQEyHYmwI0M3Wl5FK3Ee87gjyE7xgYPws6Uf0tWOXdnBbbzvU8iKAJu3jyv2DXwdcIigO5cTkvVwpeMkklJNTY9zGSYDcCefUobPvYDJ27ejz7DgcB40Jpdp/V5tZK5/SFq9U4RFQf/rt5oo88OEp8oV2eGAMMP4VOw5/rV1rQzVux0xbTrKNpURUXIEQLLkv6vuolxAe6Uio1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dIIx1P1taO7wpxY1v8HK+pEl0vZ1v1m1fnd2lJzGstA=;
 b=kMK2op5Dx1Wqz8iPzlRwso5G0UjNPegZDVCxZDxpb2QMXjhplds05oQPH1/2qe94C/WsISmMhrLsVb/47u4hQkK4Tj1dDKUnBXARUAu9/RRO5WTU03uHirtm6DqEWUta9KlGbZLBeCTQt+Bf+05pwzhwlGzapyzqmeflKvnumpQayaIu4PR/U1KUCHmudECyLUEZ7d4c8nBtx9bfA/9OMKSiVO5s+yt/Tpw0oPcimnF8BZMqkYAIhTB5QNCPbAUYenv7qFVa43RhY8WJu9lvOc8UfN3TOCHkuQ+kL+NLLZpDkqZw+pdry28j3WO8OT6L6uoyTauSZf0IUfBtDjZyEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIIx1P1taO7wpxY1v8HK+pEl0vZ1v1m1fnd2lJzGstA=;
 b=n3lPikvfE+FgGb81cysB8FHTJ4h9OXNf3lVqk6JOEs0t+wiyUISdKejvlPtDCoepWi1PaMEV0AfA70zJ1UmV3V/gYpCss/HWYNksFB+od5MKU9ELcQOi1G/TB5AvAHrfwhhx1tngigTdeKr5+7npvG5JiJDnZzNobyJD+u8D6hC39/j60Xo5I/qpp1AxakD6TgNM4CMlGyJubgRVw7BTkWG9S+ubLDeiQjotW0DEbIUnHNr4lyoMa/dAjZpODim+38Sp++Qx3oQahCJ+fmBABS6WePpk4KvPjY8GerC6Z9wO9IEr2yFxiafxVuUvPCqnoVt4xmpncjvap6HbYdpTtg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Mon, 1 Nov
 2021 14:11:35 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 14:11:35 +0000
Date:   Mon, 1 Nov 2021 11:11:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, Tiwei Bie <tiwei.bie@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH V9 7/9] vhost: introduce vDPA-based backend
Message-ID: <20211101141133.GA1073864@nvidia.com>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-8-jasowang@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326140125.19794-8-jasowang@redhat.com>
X-ClientProxiedBy: MN2PR16CA0002.namprd16.prod.outlook.com
 (2603:10b6:208:134::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:208:134::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Mon, 1 Nov 2021 14:11:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mhY29-004Vh4-HI; Mon, 01 Nov 2021 11:11:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 685db139-32ab-4d73-c148-08d99d4182fe
X-MS-TrafficTypeDiagnostic: BL1PR12MB5285:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5285B8D76A64AB2551F1D2A0C28A9@BL1PR12MB5285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ClL4yZMwnteRcgjFF2G2eq/UHVaW7+/kUAbXR/GUTgweJptXbxi5U4lcZgtvfatMTSVWLgRjxGu9+q1X1DpfqeOQ8Kek6BPRrd3K3Wr3FmdHoeYu6hEoWzG9haCos3scj0GIsCxzKNYe7LUsKyFY//8MHg/nB2H24busktczmr/zSMNB4Jp7/jby8Kl7VvfTfIS8KenKMK+qoBijh4W+dATIE6Fpbtg/YNyWP/9RTdh0e/vvDA1HXTKPI4bwJyo9wDBJCbayque28EVsb1Aa4f3scvpeLXXvwTae+uBCcm+KhMwlUKojmaZrMuWQ9HZcCOXn4Qxn7PA6BR0oORbyfAhFWimdC9CQMszE5fqw/5rGo9g5rhLi9dQa8jGCCL/iDtciOZiFQ8AXlPsaidNXmfQkEcawGymf13BD+RhMkwOYA6AleZQYFmlCdwj+DGmvqpCfPwNSmD6oSa0m+6xuyZFVOtVCFfvMtdWXJBDU0kCxOXPLqsczWpIUqi/1i/FDMw5d3yxt3XCK0TAosOc48K6xlPt4SblDYqjrTNdb/udo4VyIMjYOg6X1JdU6bhrA1dBKtDhpqOqSVHJgS1K2LFmKV8Q9cmjiX5d/oWxS0EDMP0J/8Z4yyuP4dw1ltm9H8vV25dl+CoPVhh0c+peCQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9786002)(38100700002)(9746002)(36756003)(4326008)(2906002)(86362001)(6916009)(508600001)(316002)(26005)(2616005)(8936002)(8676002)(33656002)(5660300002)(1076003)(186003)(426003)(7416002)(83380400001)(66946007)(54906003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XEdDIz28RaBdwPs43TVJMoPsuZjKCxg12b9GzB1BT8YvJQo4LNQ/SDeT+QPG?=
 =?us-ascii?Q?YocNhsiH0jE2an9p3syXfRNMp/JB0ThwMGTf+rvlZHcQ6a45nAVKIVLvE3vU?=
 =?us-ascii?Q?ZyjV+1M+BM0wcQHAen5NPzrPloqk6E2ELCmioIe6SSDIEKfhIW1C2k0CpeTz?=
 =?us-ascii?Q?cBEiabOEmRZovTB2Ky01Rmr8MkkmSuRdisjj4KeuTH2O/BWoPR4V7PbP+/9o?=
 =?us-ascii?Q?dw3s7sOJulqr5kouP0Nry1vMULf51DjEC6Pi3FFjQUH99Nh6MyklUr9XiPZN?=
 =?us-ascii?Q?3MAfAr3Rd8FIC6o6opqHDoKD/xqm+RLbl6dn3Dk8eNUGp68zFnihFCphJThV?=
 =?us-ascii?Q?9/xHequer0gj6vT6H6QWV9lmhN7vCHEsP8/97fdOs+rFMH/SFLY/55T6T5xt?=
 =?us-ascii?Q?tdgruXcub03ZpWWms2AHeExr9kqGGFFMPgcglzSg/n2Awi8CYbCm2arp9Z7W?=
 =?us-ascii?Q?NJuXK6VSgu7+yR8PATC75TA1b7sq6H3i1UFaIrvEzPZ0hwSTbi8+u+va1cj3?=
 =?us-ascii?Q?D3WI4hTHdyFeMK2qQM+DqNI3N0Aw6i1YyzksYkCljS3SxQnOKlosHkvNumqp?=
 =?us-ascii?Q?LgLqHSL0R8PIqX/4iCmMEx0HRWPO7rawf1Nkzp8jEr+NTsVWyNT8pU2nP9XK?=
 =?us-ascii?Q?zLoxW2VTGFxugW9Q0yYtb/24X/jcNUUJeZ0jp0H5Y4I2/SS+hZYFPdaGFce6?=
 =?us-ascii?Q?pTM9FkdyKRZ2dKCrvQm7YpBpsa6bVSTkefLliPNtlrPT1fdpAXowxKV+4umM?=
 =?us-ascii?Q?Gj4JPdFbpLeb6okVz4h5tgMDKSZDKpPUlRZO4p5EJ8PeNkpnyUkDWJ3I+LPd?=
 =?us-ascii?Q?AePpEZQhDpcSSIt7ax6IHvtK2ha7UKFqsQFFcJ9qpsKUGfZ7EtPkXzuEt4/7?=
 =?us-ascii?Q?bmjT7yBIH//3EBuF9u1Vibd9WgnDVjuyEvPTkFqaBoeeJnm6/rU3lBWr60rH?=
 =?us-ascii?Q?lCoAvrCO1YUMd5MHca7z2tlWOGy3H36hVXuQQFzrCL6q9UxImabzDUYLJ8Qn?=
 =?us-ascii?Q?ZzGx6MTdqUsNX2Uh0VfksIm6GUbGd6y4YND3uai2H30cKQf5ATBEud+1mpoX?=
 =?us-ascii?Q?Pek0L72cGgjYamveu+NNXKoGSd5lHAhfTEGfdFH1fl8HP3raJfliAiUQqIHs?=
 =?us-ascii?Q?HWjS9LZzYm5A8IMTvKAkPh73vE9NZ2HuEImvirakN6Bs/dnbNqCv0D3sXjfN?=
 =?us-ascii?Q?yFJKXQHoGTCpuoRDf7k5FHmXadtpaugxlzaF2ynBMl+t69Aqv/wGN2cc+UXE?=
 =?us-ascii?Q?0dwtQZ4khBoOK8vnr124nngVl+kWaM62WHU+yJ/yg7JCdszo+twnWNtZZwUi?=
 =?us-ascii?Q?3UkGG/j1KBHXd44ucsVHr8ga4HElURkOYrB5oXJNSheDieRW6kfG0Fk+gDMV?=
 =?us-ascii?Q?rAK9EfedKcauXgAwLh67ZVSrNUq0pyXzvigy4gN2E9BpoWwc+DxRItecag3H?=
 =?us-ascii?Q?LdqYZyZ0NIh07Jyw8ATt+mitvtECBKgALV3kz86UvUP5gbLsdBxB5eRuW/WZ?=
 =?us-ascii?Q?SwYYbfV7RYM08ckfeFmBXtt7XpomaK0ujLSMcJfk6Q6y51w27rHEzAiciZqI?=
 =?us-ascii?Q?QYxvzazcHpmFqAVNFGM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 685db139-32ab-4d73-c148-08d99d4182fe
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 14:11:34.9130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kKF/JRC2CxCyRE+Tnsv9g8jT4aQJb/TxJJIO94jE7c8pjEDIhqM1ZA0jJS6Vwpl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 10:01:23PM +0800, Jason Wang wrote:
> From: Tiwei Bie <tiwei.bie@intel.com>
> 
> This patch introduces a vDPA-based vhost backend. This backend is
> built on top of the same interface defined in virtio-vDPA and provides
> a generic vhost interface for userspace to accelerate the virtio
> devices in guest.
> 
> This backend is implemented as a vDPA device driver on top of the same
> ops used in virtio-vDPA. It will create char device entry named
> vhost-vdpa-$index for userspace to use. Userspace can use vhost ioctls
> on top of this char device to setup the backend.
> 
> Vhost ioctls are extended to make it type agnostic and behave like a
> virtio device, this help to eliminate type specific API like what
> vhost_net/scsi/vsock did:
> 
> - VHOST_VDPA_GET_DEVICE_ID: get the virtio device ID which is defined
>   by virtio specification to differ from different type of devices
> - VHOST_VDPA_GET_VRING_NUM: get the maximum size of virtqueue
>   supported by the vDPA device
> - VHSOT_VDPA_SET/GET_STATUS: set and get virtio status of vDPA device
> - VHOST_VDPA_SET/GET_CONFIG: access virtio config space
> - VHOST_VDPA_SET_VRING_ENABLE: enable a specific virtqueue
> 
> For memory mapping, IOTLB API is mandated for vhost-vDPA which means
> userspace drivers are required to use
> VHOST_IOTLB_UPDATE/VHOST_IOTLB_INVALIDATE to add or remove mapping for
> a specific userspace memory region.
> 
> The vhost-vDPA API is designed to be type agnostic, but it allows net
> device only in current stage. Due to the lacking of control virtqueue
> support, some features were filter out by vhost-vdpa.
> 
> We will enable more features and devices in the near future.

[..]

> +static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
> +{
> +	struct vdpa_device *vdpa = v->vdpa;
> +	const struct vdpa_config_ops *ops = vdpa->config;
> +	struct device *dma_dev = vdpa_get_dma_dev(vdpa);
> +	struct bus_type *bus;
> +	int ret;
> +
> +	/* Device want to do DMA by itself */
> +	if (ops->set_map || ops->dma_map)
> +		return 0;
> +
> +	bus = dma_dev->bus;
> +	if (!bus)
> +		return -EFAULT;
> +
> +	if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> +		return -ENOTSUPP;
> +
> +	v->domain = iommu_domain_alloc(bus);
> +	if (!v->domain)
> +		return -EIO;
> +
> +	ret = iommu_attach_device(v->domain, dma_dev);
> +	if (ret)
> +		goto err_attach;
> 

I've been looking at the security of iommu_attach_device() users, and
I wonder if this is safe?

The security question is if userspace is able to control the DMA
address the devices uses? Eg if any of the cpu to device ring's are in
userspace memory?

For instance if userspace can tell the device to send a packet from an
arbitrary user controlled address.

Thanks,
Jason
