Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1880C443222
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 16:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbhKBP6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:58:50 -0400
Received: from mail-bn8nam12on2087.outbound.protection.outlook.com ([40.107.237.87]:45665
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231361AbhKBP6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 11:58:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITMbhIE00hfoQ/awovVpniZbGdkEIX7v9ybUp9HBF4KOFpE5uUPsKsGbk8TXLfGc6W8BnMY4Mtdye7/7/UgpjA7kV658GsfJgoNsHc74jZeSLOlDieP/ts24hE+2yuU8j9AFt6CFxF6ZR+J7eZ4C1zs+7nJDMZAzVqV/7Igcq3ynMcZ0Ayk1g2z9Fad3WdkVyOFXSHUehkilRRnFjIi6SqH76aaZJNXN0OZgmJxKTjqfIOIBlYfWTD3RL2kBFT4M5aBWvuVdajYm2wIzPQnPQMZaLZ9KK3arGwxniOcF9NDrcIxRwAoWTUnVgJXXAB/x9UoCoLPVkRAWIB72cSIHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6KoGp/hBHbfdFcbAEzVBZ9BGX0Di94+pkT1fjdjBa8=;
 b=GzvAe97JUvhSBJH8OoeqqdeLVEYOa1vCdaKb2nAz6ps6A7/uQTcU4i66tbvwe4RnBr9Wh95dUaSmZbbDfDfGwqAM3RFg9Z86/yYIuowjbJAQ54SP0bYdylnS3KbDh2E31F4/Sb8kivIPkbVwPKdsvLngk6TIUWtxPmuo32cEaSQhd+vM2G/sh3LxJpl9fzcW+v/y5g+lxea4Wf7Rp6bdMSh0pNp9XW1HmAb5WKDNJYNU1/hbzU8IiRFkZlCi9e9lTIj3DzpH0mBffpUPT9lKL0cugCVceBjJBfVSxF/t8yrYfuIwsoMorafENCghZ69tl1tTpKXNiw4e+y3eRCU+Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6KoGp/hBHbfdFcbAEzVBZ9BGX0Di94+pkT1fjdjBa8=;
 b=Oh6XzIcUEn9JhPqrXx5Pm/f3c3SIdxxuo6Yf35IupJiA+tJDZqhvS2TwaOhscgzXNAEZkUV5ndmrRfRYMUc8tLPK8doaZdqLV0Eg34BTA/15ABTeR3snI9m/kyJfBH737UIJ3MO3Hr1iU85NX/ErDR5Wztm0I9KZ3aNz7t0FMZv2Do87d6/CdUPH1YX36S6SzE04l7mpiaH1QvgQM1AHgQLrhsQRFNLBg7hDa7C2qfJ9QStZ8hh5qqtAhyNu3CSPijv22GuStd1BNCSYvE9zlNJ4YyCiBylUt2lUd8rsXIUlebW+FKzmPJZye2aWQvD4kfxILnjzlwlYSsRAOW52/Q==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5048.namprd12.prod.outlook.com (2603:10b6:208:30a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 2 Nov
 2021 15:56:12 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 15:56:12 +0000
Date:   Tue, 2 Nov 2021 12:56:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>, zhihong.wang@intel.com,
        rob.miller@broadcom.com, Xiao W Wang <xiao.w.wang@intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        eperezma <eperezma@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>, jiri@mellanox.com,
        shahafs@mellanox.com, Harpreet Singh Anand <hanand@xilinx.com>,
        mhabets@solarflare.com, Gautam Dawar <gdawar@xilinx.com>,
        Saugat Mitra <saugatm@xilinx.com>, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, Tiwei Bie <tiwei.bie@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [PATCH V9 7/9] vhost: introduce vDPA-based backend
Message-ID: <20211102155611.GL2744544@nvidia.com>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-8-jasowang@redhat.com>
 <20211101141133.GA1073864@nvidia.com>
 <CACGkMEtbs3u7J7krpkusfqczTU00+6o_YtZjD8htC=+Un9cNew@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtbs3u7J7krpkusfqczTU00+6o_YtZjD8htC=+Un9cNew@mail.gmail.com>
X-ClientProxiedBy: BL1P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Tue, 2 Nov 2021 15:56:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mhw8x-005A4d-0n; Tue, 02 Nov 2021 12:56:11 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c323e2b8-e9f8-41c9-4c6f-08d99e194adc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5048:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50486612D34EB9C04EA42D29C28B9@BL1PR12MB5048.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8o4bYjOAPa/gca6QDIzMqQf835BZ9+tiMwNjzvoHJAvi3HT/4m+HMrZOoy+9UAkmTlkMFM2NlaqZl3DV43GLxEk/8X+RsoU8LKvO+cHqkGF6ckloldMQuPmF93BFw0MKTF7az6PU2BmkrillKsi82t2YV9kur2W1EjN2GbLuwaTemGnEfARis8iPzZXY97+VDvzjgPWHD2u9MGy/fpdo5nOAaEo+Efos1z8f6taLIzEFdVVTkNhtO9cYvxprKE+wqMTHqIz+9GS27BzlT1sefjMb1+6KXOX7GP8xrJIeyr+7mIHNBvJ3WL6U1w51vB/2qWS2QoFuy8YlQlaFCq6YznmBoMOcMYqZ/iYHzF5gmcLT2hxnvcaQEKg2Z2bYTiTE4SZaC05U0H5xiG41s0iUWiNk3ZNaZMX0DoaxEOm9EaI+lmonVdEx6qPBfphoc68mPB8a2Jnra2LsWdYzy8XqGhSh7B9zVJdwkHmq1A8wt97ByTbXV6aT1Mug/z28SNsJ+T0T9w5TnT/23GzP+Uwh8WokiO/OMZMQt1CvzDyHuAMN+lB+oCScd3IPqOnLE841tZxBWHvpdtW7vPynhyw4C5602l3SAQoMrqNxV2M8xMhPDHJio7L0v1a4TVidX7DKuKgLa56E7z8/yQxxj3TZ5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(9786002)(6916009)(426003)(2906002)(53546011)(38100700002)(33656002)(7416002)(66556008)(66476007)(2616005)(8936002)(66946007)(83380400001)(9746002)(54906003)(5660300002)(186003)(86362001)(36756003)(8676002)(508600001)(26005)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qWpYtq6/4s2+sDXSL5zpD/reDVXYgKMkq5KQ9iLlyYHGTVhiknFir1tLQeg0?=
 =?us-ascii?Q?jPnr12uWGNcttQ+YdsN9yR0AYA/1udZviDMLAjQTEfVJ3505AUfWZzKuLFMn?=
 =?us-ascii?Q?wQ7lifUe+sjCr3CVCV+7RMwJ5+BVeIIrvNnVBTq9QNw5r0i0F6Poo5/HRR6C?=
 =?us-ascii?Q?Nb1hZtNa+0XvBtC+GEb9b8CURzYH5mzcdBdI5N2o7qfhBj+SkJXcIRnhVOhw?=
 =?us-ascii?Q?jwfsVzo7qmfmNsIDnrpvyQRzwusnuxgIHIq5cZTE+7JkbNjk845/W8+hTIbg?=
 =?us-ascii?Q?ZhEuwR2USTBzqh/4LJvAW9/8/01CQYS4eUJ9gVqfTzvhyuJh+CxQYBtA5rmj?=
 =?us-ascii?Q?P1lmtZBQn7TwYryuFMkp+2AYhoAsUq5DAVUIriCVjJoOo7E2ykX4a3MQAM3X?=
 =?us-ascii?Q?2qpfxPMuyFf70ZDMEQvREUYk/vvR6IFMP/pfIgPN5YCuE0DwVG2jnE+iUEtC?=
 =?us-ascii?Q?omiobs0r3GxoFF9HiTeTugL0LfIT3QvbmGFHKJ2q99h6Im+XwXCA5kzar1H7?=
 =?us-ascii?Q?iB6WSKNVrtDJcqSOWCVQhL4jIWOvg7zfmKI80wGMFrDHgCrN+xosqnpOO1d0?=
 =?us-ascii?Q?RX2HtHe36plyWMpQejQdyoJkkgDMfGCPc6JB9acY+SCVLFb1TQz1pNWsQVnc?=
 =?us-ascii?Q?t7IpBYpVtf+HRJ/cpj7GjTWiYs5Rl8NzLNgafex19xtLlt66nVDFcQFRUmmf?=
 =?us-ascii?Q?u6Fa+tqBCeoH2ETrEcyzA/uZ8ewfkT/U+DB94ShzAaGvD/73V1yHEV4B3E9a?=
 =?us-ascii?Q?bHm2NX3DE7//fvuO2W+qNP8mLkz5T+YAQLgXz1kI0Sh89T7FyRZuwts8rbqY?=
 =?us-ascii?Q?PBwNAtW5HTYy1Ww4OEjVgBKtA2maUDTwIfmM+uTv/EJ+2Vhyb4KjFje33QWO?=
 =?us-ascii?Q?apxexMFNoYYUAs/hVtk11zMARyuObUcCpZ1oQi/2FciY/pVbq2YaU+b94J11?=
 =?us-ascii?Q?ysjJ1hJDZt06T0hgMqFQvn5X7e8Jn1Go7JHAP9EIapSeU43I2IrThp/Y512+?=
 =?us-ascii?Q?/Ly+LDPmTDqYJsiGnfeE8bxOBxLivkSQ+Nha+lhsCuErNONtcC44fhfKZ1FI?=
 =?us-ascii?Q?61JKmfBprt+HOds4XMsMeTvEkCBJWWmEBuiDWxsPRexN5Es+HcqIIKkv3g1n?=
 =?us-ascii?Q?vhq+9MatCGB66q4b4yrC7ayKVHHMllBjpGbewGZNLK+ABJZlz4EtrIVzmtLD?=
 =?us-ascii?Q?BuM4Ki/5kKLr/NKjZQT02DqGRQUiVIlKnF+wLj3NuAOCISVmaQViYd/JOFhY?=
 =?us-ascii?Q?4oJJeHVgvlyro0+SKkJok+bVg9q8btxlB6swZaWzT2+cV73BQH4YOXBBZHd1?=
 =?us-ascii?Q?MDMy0TmMEFFP9oXlZb3dwDLO2fjqdYwpwVS5mdQT0zQp23tJRqLT9zgQEORI?=
 =?us-ascii?Q?f3qPpW4o3onGqYtXoA9pxA4z+Yn/lAbRvAYOprl9xkoaYpVh7su1w+iUDAY2?=
 =?us-ascii?Q?IoXBrkSLN0NvGRUyA4GDuXGasUbm/rtTHfvSaJhOypi76lnAJanAPvBnNmI8?=
 =?us-ascii?Q?yA6OcwUJIERJzG0t1/N+x+hOuQLGCZTQn8YaiZZpgDzy14vUn/8qzzvRvJ+P?=
 =?us-ascii?Q?2brzgt9Y2qrg1SvdAoI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c323e2b8-e9f8-41c9-4c6f-08d99e194adc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 15:56:11.9865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b79plKkiZN30Wh+tBRHRpPiCI0fM9Kelu4TE48Wey/RnLPLAxw6Nd7GdEmlaZkVZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 11:52:20AM +0800, Jason Wang wrote:
> On Mon, Nov 1, 2021 at 10:11 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Thu, Mar 26, 2020 at 10:01:23PM +0800, Jason Wang wrote:
> > > From: Tiwei Bie <tiwei.bie@intel.com>
> > >
> > > This patch introduces a vDPA-based vhost backend. This backend is
> > > built on top of the same interface defined in virtio-vDPA and provides
> > > a generic vhost interface for userspace to accelerate the virtio
> > > devices in guest.
> > >
> > > This backend is implemented as a vDPA device driver on top of the same
> > > ops used in virtio-vDPA. It will create char device entry named
> > > vhost-vdpa-$index for userspace to use. Userspace can use vhost ioctls
> > > on top of this char device to setup the backend.
> > >
> > > Vhost ioctls are extended to make it type agnostic and behave like a
> > > virtio device, this help to eliminate type specific API like what
> > > vhost_net/scsi/vsock did:
> > >
> > > - VHOST_VDPA_GET_DEVICE_ID: get the virtio device ID which is defined
> > >   by virtio specification to differ from different type of devices
> > > - VHOST_VDPA_GET_VRING_NUM: get the maximum size of virtqueue
> > >   supported by the vDPA device
> > > - VHSOT_VDPA_SET/GET_STATUS: set and get virtio status of vDPA device
> > > - VHOST_VDPA_SET/GET_CONFIG: access virtio config space
> > > - VHOST_VDPA_SET_VRING_ENABLE: enable a specific virtqueue
> > >
> > > For memory mapping, IOTLB API is mandated for vhost-vDPA which means
> > > userspace drivers are required to use
> > > VHOST_IOTLB_UPDATE/VHOST_IOTLB_INVALIDATE to add or remove mapping for
> > > a specific userspace memory region.
> > >
> > > The vhost-vDPA API is designed to be type agnostic, but it allows net
> > > device only in current stage. Due to the lacking of control virtqueue
> > > support, some features were filter out by vhost-vdpa.
> > >
> > > We will enable more features and devices in the near future.
> >
> > [..]
> >
> > > +static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
> > > +{
> > > +     struct vdpa_device *vdpa = v->vdpa;
> > > +     const struct vdpa_config_ops *ops = vdpa->config;
> > > +     struct device *dma_dev = vdpa_get_dma_dev(vdpa);
> > > +     struct bus_type *bus;
> > > +     int ret;
> > > +
> > > +     /* Device want to do DMA by itself */
> > > +     if (ops->set_map || ops->dma_map)
> > > +             return 0;
> > > +
> > > +     bus = dma_dev->bus;
> > > +     if (!bus)
> > > +             return -EFAULT;
> > > +
> > > +     if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> > > +             return -ENOTSUPP;
> > > +
> > > +     v->domain = iommu_domain_alloc(bus);
> > > +     if (!v->domain)
> > > +             return -EIO;
> > > +
> > > +     ret = iommu_attach_device(v->domain, dma_dev);
> > > +     if (ret)
> > > +             goto err_attach;
> > >
> >
> > I've been looking at the security of iommu_attach_device() users, and
> > I wonder if this is safe?
> >
> > The security question is if userspace is able to control the DMA
> > address the devices uses? Eg if any of the cpu to device ring's are in
> > userspace memory?
> >
> > For instance if userspace can tell the device to send a packet from an
> > arbitrary user controlled address.
> 
> The map is validated via pin_user_pages() which guarantees that the
> address is not arbitrary and must belong to userspace?

That controls what gets put into the IOMMU, it doesn't restrict what
DMA the device itself can issue.

Upon investigating more it seems the answer is that
iommu_attach_device() requires devices to be in singleton groups, so
there is no leakage from rouge DMA

Jason
