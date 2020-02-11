Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF3A15906B
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 14:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgBKNxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 08:53:04 -0500
Received: from mail-eopbgr70083.outbound.protection.outlook.com ([40.107.7.83]:44190
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728667AbgBKNxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EshxchXTKH3ds93rmGnQKXGCvqr8gweZKE0IQ3GJXObAQoxICUSgHR/p8I4wjO9Alr/VQyFJ/wKDB9ByXlOJue8Qj4E+Ql4cDKKG9xriUnuO0eocQNs7W9o0eoasj5L3ZMKXkYr9RtG7wAetgXxpU4ftzlZowEjtkq8DNs1JRzxMREvgh/LppAGUv+Ogtlsvh7z7nv2zv6GUFWhlpSN9ISBzghZRVDckkMOItO4k75ZcGjsyRkki9rabBnf5SdJ2PHZs6rkFyU8TwGfdDraeAtmw74UXVkky7ZEUKt8KwUIMfAZSzcP3UG6lAFT9C1zYWxFwVOPlQ4iSkp7tHC7F8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xekAfWSUqKcsRF4SHFOZ9dF34JQif76dyAouZKEWRM=;
 b=FOCe9L4Ud492pV841PQXpIo27vYx8VAr6ZrNXId8J4JFHvu3RiNqzTzAOBe2eyCI4KhmHWr0wKCPUB2nxV0cUpcUJSq8pRrpe/B6uYuDiLIhamNWb7QnnKRnT8kUiT4MKYXxs1PmyazyjnZdMfiAna1sym65ct6NlrTjdFAGd7WRda6fC8sGzEhkpRF3JLjPp9zFTZNkrPpO/c0YKPcEAe5wd4ZGRGk1HIpSnbB6VteNm6T/OQmj6qEmplYDPehDe8YyFAcHrU2Ge+FgVfAGdxbxetzeS9TRNlwJOh1oPdSPtdLlgCCMTNyrYfWG/T6ZXo0WQbu5rHJCdtW3pDHTBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xekAfWSUqKcsRF4SHFOZ9dF34JQif76dyAouZKEWRM=;
 b=kqdtvxhhxDAbb0+bPDOCTAJamF7zZmePfhyzFhQeoNIgqfHNTuicAhj/lQOt0xY7Kb+GXqd4fCcX1OJBfqj5KEIwF9+kynAXxsX7BlMzxkjyVLg2MNcGMq0Celp+VhCCPWy/SNjVJdaLF/csP19JJ00dQ/5T4XmLzvKe538ezlU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5743.eurprd05.prod.outlook.com (20.178.121.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.25; Tue, 11 Feb 2020 13:52:59 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 13:52:59 +0000
Date:   Tue, 11 Feb 2020 09:52:54 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
Subject: Re: [PATCH V2 5/5] vdpasim: vDPA device simulator
Message-ID: <20200211135254.GJ4271@mellanox.com>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-6-jasowang@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210035608.10002-6-jasowang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BL0PR0102CA0047.prod.exchangelabs.com
 (2603:10b6:208:25::24) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by BL0PR0102CA0047.prod.exchangelabs.com (2603:10b6:208:25::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.24 via Frontend Transport; Tue, 11 Feb 2020 13:52:58 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j1VyA-0005R4-Dz; Tue, 11 Feb 2020 09:52:54 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fbcf6dbb-8488-44d3-617a-08d7aef9b3b5
X-MS-TrafficTypeDiagnostic: VI1PR05MB5743:|VI1PR05MB5743:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB57432D71BE187D1882B9883DCF180@VI1PR05MB5743.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(189003)(199004)(26005)(478600001)(86362001)(186003)(81166006)(8936002)(8676002)(81156014)(9786002)(9746002)(2906002)(4326008)(36756003)(2616005)(66946007)(1076003)(66556008)(33656002)(6916009)(316002)(52116002)(7416002)(5660300002)(66476007)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5743;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yczaXlOIs4IEaACaqiO2BNAAn0vQy8qUxi2Cr+452NUypT7nzmxIIEdwz9GGN69asD2esvqvtwOOy8rcogRBP7PDqVgircu0jylmCh62VlVLVaZQrfulJKnfFl0n3tfzMpQPyv1Mx/7Hp+qFeSPx36VZQfa4NlG9NSJONEWTpRTW8895dv6KTz662niPDdgvn7aEpN9feIleyGiCSei11xKNNORNkhw5k5aYRizc1uTwhqdt5syJ6ZWn7K/VmAJJoFAWI7MsEldDVlMIenk7Glz4/heatg08RO8zBpo2u+aADasyX+scLEjqZVpvzN0PZ12SAONvqx9gmdoH44aNe88sYzq9dRv6PZTR5vpnMFAEUxvPne444HixNFrS8T79kEWgrVFdBiW0+b0uAcwZf/zHe9K3KBOH2OIWMZzMcLxWhDub+OcOVdT5DUl6l1yWCmrvtCWYE87VGtZ6NbdnSC61F7l/UEammNN/PCepfxykxWTQv/Q1snSjOWcWeBb/
X-MS-Exchange-AntiSpam-MessageData: kGFw4FR6jwbjhYs8rOTGWFz/Lf/0rSpOB/RJ2d5UqXuYEyvajMn+6ePKGfCIr2wEKMztruDWAYq2gvGjd/Drvgo9bRK/RPKAMIgVePCOZkkrc+AI9OaNb0XpGxzG5C3khw/xz+TxKBOhPGT9/HtdUg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbcf6dbb-8488-44d3-617a-08d7aef9b3b5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 13:52:59.1077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: te/Ask29lgHgyp91igJGRk12hf9VkzuNF0BdCmHkG/64rzMkUuM/APy53eiQK0PN9FDVseKB/yemjVb8/wzIhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5743
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 11:56:08AM +0800, Jason Wang wrote:
> +
> +static struct vdpasim *vdpasim_create(void)
> +{
> +	struct vdpasim *vdpasim;
> +	struct virtio_net_config *config;
> +	struct vdpa_device *vdpa;
> +	struct device *dev;
> +	int ret = -ENOMEM;
> +
> +	vdpasim = kzalloc(sizeof(*vdpasim), GFP_KERNEL);
> +	if (!vdpasim)
> +		goto err_vdpa_alloc;
> +
> +	vdpasim->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (!vdpasim->buffer)
> +		goto err_buffer_alloc;
> +
> +	vdpasim->iommu = vhost_iotlb_alloc(2048, 0);
> +	if (!vdpasim->iommu)
> +		goto err_iotlb;
> +
> +	config = &vdpasim->config;
> +	config->mtu = 1500;
> +	config->status = VIRTIO_NET_S_LINK_UP;
> +	eth_random_addr(config->mac);
> +
> +	INIT_WORK(&vdpasim->work, vdpasim_work);
> +	spin_lock_init(&vdpasim->lock);
> +
> +	vdpa = &vdpasim->vdpa;
> +	vdpa->dev.release = vdpasim_release_dev;

The driver should not provide the release function.

Again the safest model is 'vdpa_alloc_device' which combines the
kzalloc and the vdpa_init_device() and returns something that is
error unwound with put_device()

The subsystem owns the release and does the kfree and other cleanup
like releasing the IDA.

> +	vringh_set_iotlb(&vdpasim->vqs[0].vring, vdpasim->iommu);
> +	vringh_set_iotlb(&vdpasim->vqs[1].vring, vdpasim->iommu);
> +
> +	dev = &vdpa->dev;
> +	dev->coherent_dma_mask = DMA_BIT_MASK(64);
> +	set_dma_ops(dev, &vdpasim_dma_ops);
> +
> +	ret = vdpa_init_device(vdpa, &vdpasim_dev->dev, dev,
> +			       &vdpasim_net_config_ops);
> +	if (ret)
> +		goto err_init;
> +
> +	ret = vdpa_register_device(vdpa);
> +	if (ret)
> +		goto err_register;

See? This error unwind is now all wrong:

> +
> +	return vdpasim;
> +
> +err_register:
> +	put_device(&vdpa->dev);

Double put_device

> +err_init:
> +	vhost_iotlb_free(vdpasim->iommu);
> +err_iotlb:
> +	kfree(vdpasim->buffer);
> +err_buffer_alloc:
> +	kfree(vdpasim);

kfree after vdpa_init_device() is incorrect, as the put_device now
does kfree via release

> +static int __init vdpasim_dev_init(void)
> +{
> +	struct device *dev;
> +	int ret = 0;
> +
> +	vdpasim_dev = kzalloc(sizeof(*vdpasim_dev), GFP_KERNEL);
> +	if (!vdpasim_dev)
> +		return -ENOMEM;
> +
> +	dev = &vdpasim_dev->dev;
> +	dev->release = vdpasim_device_release;
> +	dev_set_name(dev, "%s", VDPASIM_NAME);
> +
> +	ret = device_register(&vdpasim_dev->dev);
> +	if (ret)
> +		goto err_register;
> +
> +	if (!vdpasim_create())
> +		goto err_register;

Wrong error unwind here too

> +	return 0;
> +
> +err_register:
> +	kfree(vdpasim_dev);
> +	vdpasim_dev = NULL;
> +	return ret;
> +}

Jason
