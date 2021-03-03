Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3A632C435
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382531AbhCDALs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:48 -0500
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:55015
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349859AbhCCLfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 06:35:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nM+BpWGWci1nRXaw7CtqXGDfcDqDN3ZTyILAwmlXkcj4fKb2r3AKiB2WJc64mBTfYkjH2cH8IkXrKcMloUpyYNRSrJDVVIhtFSyo3B7ENERZ9Ufq3MTVMD88qr8fuIVpeYcOeEpXlHW3ioOLnx1N0SA9XL8nXGHioXEk5Ee3KUffEsL9YtTV2ZbbyDQelwRLy62YBV+5WoLBvlUbgqa+kxv97GKc2AA4YUVp2BPU5CKodmLkmvOkU4x4duGoMvqP+cNi13t5d5Htz0XPNmafMyHHh3qKl35LUAYezq1CGQIL/XPzCjC+SIEATE+fCrVPGtDDrH7hwYOBje42ac6ETw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAwtc43SlYK4M74iEDjbof99YRtxQjizRpcKfDgFhv4=;
 b=Oz8RS/f2xX7zIj+TAV92tDRqSaz9/DNU7hC6m92hPghjXbqXmPN0hVi/kVrRnaKW238fci2ruDngL7bgHhczYN1KJ8rE4yalINufAu88BiPP5Nee3Gz5HPUvzmw0tE9e6WBeQ7NdryhQNxIXUnkVOglPHF2nAKFYbk/GgHM7VqJLpIDxJLV/FkagT8On1gVfD43Cp4lShwxLWtRaF0ExALtxHFoBUDld+R4Nsq8uc61X6WE6tG/kDZUtsx6YrKLzgKV3JRjuItBGUwzXjeixPI6k5fOhoBOn+jXdrew85ZNTUzIpeSBUwfITEX63DbsUEtQeq8hVxVT0rOHvZm8U3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nextfour.com; dmarc=pass action=none header.from=nextfour.com;
 dkim=pass header.d=nextfour.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NextfourGroupOy.onmicrosoft.com;
 s=selector2-NextfourGroupOy-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAwtc43SlYK4M74iEDjbof99YRtxQjizRpcKfDgFhv4=;
 b=hhXjqk5cCTj5zt8HucW3Ix9mhl2YHOXjvHZpmbWl6ndTXS0bp+2KVskFdk4LIikEETbwdVpOt5sxFbO7+Ge48i1kEqCz4zwuj8HBaZMdheuZc/RKdTubNU6+ETNK63dpV6c5xCD1ebWCFJegqjC9eklvj/XbF5oViu+RL1+0J4g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nextfour.com;
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com (2603:10a6:10:194::6)
 by DB6PR0302MB2598.eurprd03.prod.outlook.com (2603:10a6:4:ac::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Wed, 3 Mar
 2021 10:52:54 +0000
Received: from DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::708e:9058:61ae:cb9d]) by DBAPR03MB6630.eurprd03.prod.outlook.com
 ([fe80::708e:9058:61ae:cb9d%7]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 10:52:54 +0000
Subject: Re: [RFC v4 05/11] vdpa: Support transferring virtual addressing
 during DMA mapping
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, bob.liu@oracle.com, hch@infradead.org,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-6-xieyongji@bytedance.com>
From:   =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
Message-ID: <e2232e4a-d74a-63c9-1e75-b61e4a7aefed@nextfour.com>
Date:   Wed, 3 Mar 2021 12:52:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210223115048.435-6-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [194.215.55.162]
X-ClientProxiedBy: HE1PR05CA0192.eurprd05.prod.outlook.com
 (2603:10a6:3:f9::16) To DBAPR03MB6630.eurprd03.prod.outlook.com
 (2603:10a6:10:194::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.10.99.3] (194.215.55.162) by HE1PR05CA0192.eurprd05.prod.outlook.com (2603:10a6:3:f9::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 10:52:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68736ed3-86bd-4c96-e58e-08d8de327f9b
X-MS-TrafficTypeDiagnostic: DB6PR0302MB2598:
X-Microsoft-Antispam-PRVS: <DB6PR0302MB2598DC932BED26F5D4DF426083989@DB6PR0302MB2598.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tIf3Kxy4hvRAgqCNssNfC1A+wIuAsHy9eft/UBR/QR77LR1uuYeN/c0VsrlnnOf9NbouHHKe7tP4UwadVmE3Wdclcp2/USLrGRp8eZ6gsZ2EvbNbceXfWdBGLdJAkxQxWna0yn2mxTP9t1fhS+F3zCSItxv/NoZ+KTYtZrBpkaI5bgVXq8qL2WKaEuWNlFU37lGMKnjkHkxnUJZAgJh6kScVfL8ybZOFQT7JYh1BgPI0ua2X18DtvypMz5aGiEpci2ZEaEYTLeKZVujI3KGzbQhXxOI8QYekvavVe14aFHCPzQdCSJQV6g8I8qMQ0EBqu3dfUnIqfMgmJ35MOBjbGb8TuDlchkiDcf2ENDyvwdwoaqtTyzz4Mt8mGgdDVifMwhNjYBpftmwg/cloKh3vuXO4W2pMnz/FdB6rDpv+LUyvheMCWDzqmTY/9RZjn1mtxYUH8XEZtLeVkJj8BVlqXGFTbCWEsJdFku6fQiXv9FpVJbjvFUk8oRKFdCsBGBXh4rfIY5BpbABZS8WSVDWXEYzKqqp7/3ddCbxlInAEe1lMcx+0Jxs3EeBhEfT/OKbLhBs1huxJd+i/c6lKJcM35iN35N8rVm/Nwjgkj6t5Pm0hUpb/+X7I7UJ1sGxnEmS/eI5kJY4DOZJij9ChhWSvMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR03MB6630.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(366004)(396003)(376002)(136003)(2616005)(86362001)(52116002)(8936002)(36756003)(31686004)(66476007)(956004)(6486002)(30864003)(5660300002)(16576012)(921005)(83380400001)(8676002)(31696002)(16526019)(66556008)(4326008)(316002)(7416002)(478600001)(66946007)(26005)(2906002)(186003)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1FkU0s2azFxb1FiU2duUXNoZnlXdDkxaVlCbFEwbHZMTkJjd3RQYkN5ZXg0?=
 =?utf-8?B?Y2NjZEdXMU5wS2svMzZiWkxERWMxZ1NhaUpzSkl0dG80bjZqN282aXNSQ0pj?=
 =?utf-8?B?enNqcEZzY25QTWR2SG10R1hNYjBKTEJ3T0FmY0JrZjZ1eDhUVkc5aWtRN1Ju?=
 =?utf-8?B?NjRDdVZleGdVUWg4cnJZd3FRRitYSFl3ZHQ2UWZsTzdRVmZmdVQrTk41Rkk1?=
 =?utf-8?B?QnZBU2JDQVpPTkl5RW5qWmg4UnBBOUxVY2J3bktJY1Avakc0QXJDMm9iK1Bw?=
 =?utf-8?B?YVhQVTVpanlDd0xEZnlXUFJpTFBTTW5LUE9GUE01YXRRUnBJcmVvakMvUlRJ?=
 =?utf-8?B?NGxSbCtaZ3ZudDArNENTZjNOODlQQ253Y2tlc1FMSmhPOENXd25SMWo5RTR4?=
 =?utf-8?B?VG4wQUI1dmsyTzlHMC9PdFN6RHFsRmtLN1I2RVpmdTRPWllUTU1MMHVJWFNw?=
 =?utf-8?B?VW5qU3lxVVZRek1ZVENWb0pySjhpWEVjT1ozVm5hNnp1R2wvSy9QbitlcG1C?=
 =?utf-8?B?c1R5bzE5N3A4cEw4VGtDLzhWbVcva1lmRDBTUmtxcGdhS1hQa3RXOS9jbDZq?=
 =?utf-8?B?UFBTSUE5a0poL1FNNXhqaTN1aDJCS1NuTTQ4b29wN3U5b0liYkg1SEVCNFc4?=
 =?utf-8?B?MTBiU25PKzJzaTNwbWU2MlI5ZU5sWm13SDhMQWpNSGl4SDdWNDFWekpXVEFm?=
 =?utf-8?B?U3hpTEhZbmpvWUxBL3Z5elFaaWs5YnNUeXJQOEwrQklSZlc3ZFY5UmpSWUky?=
 =?utf-8?B?bVdXV1l2NkhOYnVUUUxjTjNGOWFzYmlWMjZvcm1Bb0pIclFPSHV6MW50RGNa?=
 =?utf-8?B?SlRVVzJORWthYTdIYzRYNkVBRTF5RnVGMkR3MzJqNmg0Wi92alU0d3ZWYU1Z?=
 =?utf-8?B?VWE3U3dqNUs4NkVPWHVYajFrY0NIZjAzcXVhbDA4cTJ1a2EwN1lSV0p4VXpF?=
 =?utf-8?B?U0NEa1JrV2VsUEVHenpRNFhJSzY1V2dIZ0Nla1pLK2VNazFCQWVTQjBQdUJu?=
 =?utf-8?B?U0ludytCSGJ3S0p4YldmQndmMk9qcjkvaWFaeGVRWStQUy95aDdoNGpxdHJ3?=
 =?utf-8?B?NDNXRXNRVkxzU0g3NlNnQXBNc1NBc3BPcGI4dXVSOVpFbEx0YnFOT2dnTjBE?=
 =?utf-8?B?dDR5QSt4am0zZHF4ZU5OdjhjbGlWSCsweGNyRnA5M3ZVQ3pQWFFCNkZFZWUz?=
 =?utf-8?B?NVU2UklKSW80ZlRPd1QvcHk4NE1FQnZBZ2Qra0JYM1pQNys1d21SQURJU0xG?=
 =?utf-8?B?M0F5bllKRE9DVnkyTWtYR2d3SWxlTXZoWWdQVFBBWkYxdjkvMlBaS0RUdlpM?=
 =?utf-8?B?dThLTnJZaEtKQ3FtOExmWHdXZWtkRVNpbkZpdzV1RUp0c0JhQ2J6QWIySkJY?=
 =?utf-8?B?c01TVm5ZajNYcVdHallnY3h1QUJudFd2N1Jnemt6RWdpancyaHNpTTRRcllP?=
 =?utf-8?B?bHNTYzd0T1BDOTVBOG9yZTA5NHF0MFJFV1BJRCtLZ0ZpaGpjeTZHeThsbklB?=
 =?utf-8?B?Rm5vUUl1VUcxaVdrU1h6VElWakQyZHBGOGFTWjlqWTE5eGd3bnpTalBlcURD?=
 =?utf-8?B?SFpWRmxzK3RrZDVZUk41THZuNW9TYklTZ21hUXhhbXFrSEhvZU1sTDBLUEJk?=
 =?utf-8?B?UjJJRVdhbjhLRlFiR1JDU2gxbnJ4Y2N6UDFiaXBqaFJERmxQSHBLb05zL3Vt?=
 =?utf-8?B?Y3hiamRTQ1VZMEFqcU4yTkFocExOaG9nRFJJU1FEZVZydUZsalpuVEUxR2pX?=
 =?utf-8?Q?XLWP/BkCPwQleJdFwo2Luqvs406WeJ1P1ze4Qx2?=
X-OriginatorOrg: nextfour.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68736ed3-86bd-4c96-e58e-08d8de327f9b
X-MS-Exchange-CrossTenant-AuthSource: DBAPR03MB6630.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 10:52:54.5471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 972e95c2-9290-4a02-8705-4014700ea294
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ne1/Kyt/6Hh3x2/IWEGmNtk2Xti2tFWO9QKFtbqHkQSAxMOfX8ZdP0ikCREmiUnTSCpTNuxaGiRNjfwyR5nGiG58I5XTZkcY1lGvFJUJ90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0302MB2598
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23.2.2021 13.50, Xie Yongji wrote:
> This patch introduces an attribute for vDPA device to indicate
> whether virtual address can be used. If vDPA device driver set
> it, vhost-vdpa bus driver will not pin user page and transfer
> userspace virtual address instead of physical address during
> DMA mapping. And corresponding vma->vm_file and offset will be
> also passed as an opaque pointer.

In the virtual addressing case, who is then responsible for the pinning 
or even mapping physical pages to the vaddr?


> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c   |   2 +-
>   drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
>   drivers/vdpa/vdpa.c               |   9 +++-
>   drivers/vdpa/vdpa_sim/vdpa_sim.c  |   2 +-
>   drivers/vhost/vdpa.c              | 104 +++++++++++++++++++++++++++++++-------
>   include/linux/vdpa.h              |  20 ++++++--
>   6 files changed, 113 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 7c8bbfcf6c3e..228b9f920fea 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -432,7 +432,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
>   				    dev, &ifc_vdpa_ops,
> -				    IFCVF_MAX_QUEUE_PAIRS * 2, NULL);
> +				    IFCVF_MAX_QUEUE_PAIRS * 2, NULL, false);
>   	if (adapter == NULL) {
>   		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>   		return -ENOMEM;
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 029822060017..54290438da28 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1964,7 +1964,7 @@ static int mlx5v_probe(struct auxiliary_device *adev,
>   	max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
>   
>   	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> -				 2 * mlx5_vdpa_max_qps(max_vqs), NULL);
> +				 2 * mlx5_vdpa_max_qps(max_vqs), NULL, false);
>   	if (IS_ERR(ndev))
>   		return PTR_ERR(ndev);
>   
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 9700a0adcca0..fafc0ee5eb05 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -72,6 +72,7 @@ static void vdpa_release_dev(struct device *d)
>    * @nvqs: number of virtqueues supported by this device
>    * @size: size of the parent structure that contains private data
>    * @name: name of the vdpa device; optional.
> + * @use_va: indicate whether virtual address can be used by this device
>    *
>    * Driver should use vdpa_alloc_device() wrapper macro instead of
>    * using this directly.
> @@ -81,7 +82,8 @@ static void vdpa_release_dev(struct device *d)
>    */
>   struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   					const struct vdpa_config_ops *config,
> -					int nvqs, size_t size, const char *name)
> +					int nvqs, size_t size, const char *name,
> +					bool use_va)
>   {
>   	struct vdpa_device *vdev;
>   	int err = -EINVAL;
> @@ -92,6 +94,10 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   	if (!!config->dma_map != !!config->dma_unmap)
>   		goto err;
>   
> +	/* It should only work for the device that use on-chip IOMMU */
> +	if (use_va && !(config->dma_map || config->set_map))
> +		goto err;
> +
>   	err = -ENOMEM;
>   	vdev = kzalloc(size, GFP_KERNEL);
>   	if (!vdev)
> @@ -108,6 +114,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   	vdev->config = config;
>   	vdev->features_valid = false;
>   	vdev->nvqs = nvqs;
> +	vdev->use_va = use_va;
>   
>   	if (name)
>   		err = dev_set_name(&vdev->dev, "%s", name);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 5cfc262ce055..3a9a2dd4e987 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>   		ops = &vdpasim_config_ops;
>   
>   	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> -				    dev_attr->nvqs, dev_attr->name);
> +				    dev_attr->nvqs, dev_attr->name, false);
>   	if (!vdpasim)
>   		goto err_alloc;
>   
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 70857fe3263c..93769ace34df 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -480,21 +480,31 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>   static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
>   {
>   	struct vhost_dev *dev = &v->vdev;
> +	struct vdpa_device *vdpa = v->vdpa;
>   	struct vhost_iotlb *iotlb = dev->iotlb;
>   	struct vhost_iotlb_map *map;
> +	struct vdpa_map_file *map_file;
>   	struct page *page;
>   	unsigned long pfn, pinned;
>   
>   	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
> -		pinned = map->size >> PAGE_SHIFT;
> -		for (pfn = map->addr >> PAGE_SHIFT;
> -		     pinned > 0; pfn++, pinned--) {
> -			page = pfn_to_page(pfn);
> -			if (map->perm & VHOST_ACCESS_WO)
> -				set_page_dirty_lock(page);
> -			unpin_user_page(page);
> +		if (!vdpa->use_va) {
> +			pinned = map->size >> PAGE_SHIFT;
> +			for (pfn = map->addr >> PAGE_SHIFT;
> +			     pinned > 0; pfn++, pinned--) {
> +				page = pfn_to_page(pfn);
> +				if (map->perm & VHOST_ACCESS_WO)
> +					set_page_dirty_lock(page);
> +				unpin_user_page(page);
> +			}
> +			atomic64_sub(map->size >> PAGE_SHIFT,
> +					&dev->mm->pinned_vm);
> +		} else {
> +			map_file = (struct vdpa_map_file *)map->opaque;
> +			if (map_file->file)
> +				fput(map_file->file);
> +			kfree(map_file);
>   		}
> -		atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
>   		vhost_iotlb_map_free(iotlb, map);
>   	}
>   }
> @@ -530,21 +540,21 @@ static int perm_to_iommu_flags(u32 perm)
>   	return flags | IOMMU_CACHE;
>   }
>   
> -static int vhost_vdpa_map(struct vhost_vdpa *v,
> -			  u64 iova, u64 size, u64 pa, u32 perm)
> +static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
> +			  u64 size, u64 pa, u32 perm, void *opaque)
>   {
>   	struct vhost_dev *dev = &v->vdev;
>   	struct vdpa_device *vdpa = v->vdpa;
>   	const struct vdpa_config_ops *ops = vdpa->config;
>   	int r = 0;
>   
> -	r = vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
> -				  pa, perm);
> +	r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
> +				      pa, perm, opaque);
>   	if (r)
>   		return r;
>   
>   	if (ops->dma_map) {
> -		r = ops->dma_map(vdpa, iova, size, pa, perm, NULL);
> +		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
>   	} else if (ops->set_map) {
>   		if (!v->in_batch)
>   			r = ops->set_map(vdpa, dev->iotlb);
> @@ -552,13 +562,15 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>   		r = iommu_map(v->domain, iova, pa, size,
>   			      perm_to_iommu_flags(perm));
>   	}
> -
> -	if (r)
> +	if (r) {
>   		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
> -	else
> +		return r;
> +	}
> +
> +	if (!vdpa->use_va)
>   		atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
>   
> -	return r;
> +	return 0;
>   }
>   
>   static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
> @@ -579,10 +591,60 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
>   	}
>   }
>   
> +static int vhost_vdpa_va_map(struct vhost_vdpa *v,
> +			     u64 iova, u64 size, u64 uaddr, u32 perm)
> +{
> +	struct vhost_dev *dev = &v->vdev;
> +	u64 offset, map_size, map_iova = iova;
> +	struct vdpa_map_file *map_file;
> +	struct vm_area_struct *vma;
> +	int ret;
> +
> +	mmap_read_lock(dev->mm);
> +
> +	while (size) {
> +		vma = find_vma(dev->mm, uaddr);
> +		if (!vma) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +		map_size = min(size, vma->vm_end - uaddr);
> +		offset = (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->vm_start;
> +		map_file = kzalloc(sizeof(*map_file), GFP_KERNEL);
> +		if (!map_file) {
> +			ret = -ENOMEM;
> +			goto err;
> +		}
> +		if (vma->vm_file && (vma->vm_flags & VM_SHARED) &&
> +			!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
> +			map_file->file = get_file(vma->vm_file);
> +			map_file->offset = offset;
> +		}
> +		ret = vhost_vdpa_map(v, map_iova, map_size, uaddr,
> +				     perm, map_file);
> +		if (ret) {
> +			if (map_file->file)
> +				fput(map_file->file);
> +			kfree(map_file);
> +			goto err;
> +		}
> +		size -= map_size;
> +		uaddr += map_size;
> +		map_iova += map_size;
> +	}
> +	mmap_read_unlock(dev->mm);
> +
> +	return 0;
> +err:
> +	vhost_vdpa_unmap(v, iova, map_iova - iova);
> +	return ret;
> +}
> +
>   static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   					   struct vhost_iotlb_msg *msg)
>   {
>   	struct vhost_dev *dev = &v->vdev;
> +	struct vdpa_device *vdpa = v->vdpa;
>   	struct vhost_iotlb *iotlb = dev->iotlb;
>   	struct page **page_list;
>   	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
> @@ -601,6 +663,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   				    msg->iova + msg->size - 1))
>   		return -EEXIST;
>   
> +	if (vdpa->use_va)
> +		return vhost_vdpa_va_map(v, msg->iova, msg->size,
> +					 msg->uaddr, msg->perm);
> +
>   	/* Limit the use of memory for bookkeeping */
>   	page_list = (struct page **) __get_free_page(GFP_KERNEL);
>   	if (!page_list)
> @@ -654,7 +720,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
>   				ret = vhost_vdpa_map(v, iova, csize,
>   						     map_pfn << PAGE_SHIFT,
> -						     msg->perm);
> +						     msg->perm, NULL);
>   				if (ret) {
>   					/*
>   					 * Unpin the pages that are left unmapped
> @@ -683,7 +749,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   
>   	/* Pin the rest chunk */
>   	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
> -			     map_pfn << PAGE_SHIFT, msg->perm);
> +			     map_pfn << PAGE_SHIFT, msg->perm, NULL);
>   out:
>   	if (ret) {
>   		if (nchunks) {
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 93dca2c328ae..bfae6d780c38 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -44,6 +44,7 @@ struct vdpa_mgmt_dev;
>    * @config: the configuration ops for this device.
>    * @index: device index
>    * @features_valid: were features initialized? for legacy guests
> + * @use_va: indicate whether virtual address can be used by this device
>    * @nvqs: maximum number of supported virtqueues
>    * @mdev: management device pointer; caller must setup when registering device as part
>    *	  of dev_add() mgmtdev ops callback before invoking _vdpa_register_device().
> @@ -54,6 +55,7 @@ struct vdpa_device {
>   	const struct vdpa_config_ops *config;
>   	unsigned int index;
>   	bool features_valid;
> +	bool use_va;
>   	int nvqs;
>   	struct vdpa_mgmt_dev *mdev;
>   };
> @@ -69,6 +71,16 @@ struct vdpa_iova_range {
>   };
>   
>   /**
> + * Corresponding file area for device memory mapping
> + * @file: vma->vm_file for the mapping
> + * @offset: mapping offset in the vm_file
> + */
> +struct vdpa_map_file {
> +	struct file *file;
> +	u64 offset;
> +};
> +
> +/**
>    * vDPA_config_ops - operations for configuring a vDPA device.
>    * Note: vDPA device drivers are required to implement all of the
>    * operations unless it is mentioned to be optional in the following
> @@ -250,14 +262,16 @@ struct vdpa_config_ops {
>   
>   struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   					const struct vdpa_config_ops *config,
> -					int nvqs, size_t size, const char *name);
> +					int nvqs, size_t size,
> +					const char *name, bool use_va);
>   
> -#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs, name)   \
> +#define vdpa_alloc_device(dev_struct, member, parent, config, \
> +			  nvqs, name, use_va) \
>   			  container_of(__vdpa_alloc_device( \
>   				       parent, config, nvqs, \
>   				       sizeof(dev_struct) + \
>   				       BUILD_BUG_ON_ZERO(offsetof( \
> -				       dev_struct, member)), name), \
> +				       dev_struct, member)), name, use_va), \
>   				       dev_struct, member)
>   
>   int vdpa_register_device(struct vdpa_device *vdev);

