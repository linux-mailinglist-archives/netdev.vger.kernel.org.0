Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D7C19287F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgCYMeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:34:19 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:27877
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727177AbgCYMeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 08:34:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmSL7XX/4fm7v18l83qI19sdkmEglpntn/T8vD4aP0VctQAHUaPGOaY9gnNxEDfRwI71VI9rFxbpsK/8m1tF4a2dwaGJ4jdvwCtEQ/E8B3+eO3IaWgihtOCai8/NEKw3GXju0lazaKmjLL9j0+Ymopm/yjt9Jr/mtiHLWLJ0e9j3Iej608RcySRie+XIABLDTrQSuFmXaJ26BGgonUZo3mmyJOWJc6AT58IpOelaZMsbzfd3fNZDdHwOeIbwFEZkZox1LTHNgEP24Zx/r0w6fSsh0mr/dXlwPCvXdWrG3F4p9jR2QkzwQd3e0tp36hHGu/2fdWaUX/380RGycCaVwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FI7eGrlQfqdP7sV0V40+uL6p5OoU3H4Jmu3/6Lcj/HI=;
 b=Vszwzw2U62Ov4t+FFchl2YBDzOgoNdlgLvXMjQ+aUzloDeMlC6OntcBGT+JiOeNY8tFf3J90gVLJP+UjLWqg1HxEvXn13UbskQ9DuLKOERrAvP1acnTBkMzJsFra9AlSISHJZdYZiFBnBPyD4jyU+Q+Ykc61/B8rCweQ5AiPmCJFWPkyGEv0yf75LCgAqt3GBCu4efbMfRRp6+OcE64BPrLjVn5SIFWnrtjLu35wYVrBZ/w/kzKdVb0KJjaVhq1WQdMXkOQ5hEjHtZe27i5pJ0LJpvkH0n5xz42AE36Xrim3stUGciOoxXLMJYSDSQsDHmnvoDMCGmhZruqiFU6mUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FI7eGrlQfqdP7sV0V40+uL6p5OoU3H4Jmu3/6Lcj/HI=;
 b=HUIKenzcbUKHo0XluLYqn91QskhWyRMDrQclBaFfvM6c815ZB6I/P0MmQPIS1/0Erzy17qSYFxIVpw66/rL2Yn7Zof5QCnt901LI4QtQEZ8lEUo6IqVpZbbZ4cpwraWBnpHyavlM2Whlt9DCOIsMbw6WxJsu0fJ90h+IQymTP5o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5647.eurprd05.prod.outlook.com (20.178.123.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Wed, 25 Mar 2020 12:34:14 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::18d2:a9ea:519:add3%7]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 12:34:14 +0000
Date:   Wed, 25 Mar 2020 09:34:10 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
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
        Bie Tiwei <tiwei.bie@intel.com>
Subject: Re: [PATCH V8 9/9] virtio: Intel IFC VF driver for VDPA
Message-ID: <20200325123410.GX13183@mellanox.com>
References: <20200325082711.1107-1-jasowang@redhat.com>
 <20200325082711.1107-10-jasowang@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325082711.1107-10-jasowang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR08CA0030.namprd08.prod.outlook.com
 (2603:10b6:208:239::35) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR08CA0030.namprd08.prod.outlook.com (2603:10b6:208:239::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Wed, 25 Mar 2020 12:34:14 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jH5EY-0006Ia-Vg; Wed, 25 Mar 2020 09:34:10 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 44c12f09-3643-4f0d-2363-08d7d0b8d3d6
X-MS-TrafficTypeDiagnostic: VI1PR05MB5647:|VI1PR05MB5647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5647ADE3CAF07C864BC11D5BCFCE0@VI1PR05MB5647.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(33656002)(316002)(66476007)(66556008)(8936002)(66946007)(4326008)(36756003)(478600001)(2616005)(9746002)(9786002)(52116002)(7416002)(1076003)(6916009)(86362001)(2906002)(186003)(5660300002)(8676002)(26005)(81156014)(81166006)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5647;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ybKf6Z3KQZ6VntxikKaOtI+ajYFeWVFSpcC/q5F2gVnL2sF875DAmMluHzcbQ1qdAS3ssp163lacwlEvHnfj5FDpJeH9lfSpEZ0q1gwludtXCxaPb6qxnlSHRNBL/Xd7uO/HrY+uFeErP46CWD7K+mSP2KrHnD1nocrkJvYdx+oqdkpKmPv22e6KLtkW3g126wsfLHXlWjqPsTBOSw2drM5/VJP8wdS5dYZB9PY8L/eH35EBjH/h6Car1MeYM7Q49xGx+k8XH8nz5+dGG/JHzintdR7/NmZRXJF6vJd89f+GR4gtBeXoJPqwHt654KGXF6PFFoIAw1NpDw3eyunBZLYMdqMfTaSfotCPzqTUKbm9sLqONHVFnSP8D2Gn1JRuprMF+k5i2owHT+bXr3Mvi3ueQ83ImIksGcNLTOJhdZ43f+9qGNPyaOVkVYNCijTRCMNc1bD7lfnSYv7R01ne4etSx1SiDN4ojAJjW30traq9Z9ZzVa19SeQRtCq4tiYk
X-MS-Exchange-AntiSpam-MessageData: RWhEsZIZUk2SI43aiUTlC7YZTzlBKKJCe529lCWIMOJH1m/152nMMYicIqF9VuTZtQKGXXI0kt4uorl6Z1MkHgyfBokaNInCUEgAo7uzOC2W7FyUvf1MqcjxPL0MPiZdnThRvc9ozekjyi2RT8j+hA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c12f09-3643-4f0d-2363-08d7d0b8d3d6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 12:34:14.4209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wCkARV70o2SHHB1re16waChKCuzx2pb3HtcMgMafd8DtUdKSCcw6W+Gy5YjxbX2XKzDo1Y+m4oro7SNN2//Msg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5647
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 04:27:11PM +0800, Jason Wang wrote:
> +static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ifcvf_adapter *adapter;
> +	struct ifcvf_hw *vf;
> +	int ret, i;
> +
> +	ret = pci_enable_device(pdev);
> +	if (ret) {
> +		IFCVF_ERR(&pdev->dev, "Failed to enable device\n");
> +		goto err_enable;
> +	}
> +
> +	ret = pci_request_regions(pdev, IFCVF_DRIVER_NAME);
> +	if (ret) {
> +		IFCVF_ERR(&pdev->dev, "Failed to request MMIO region\n");
> +		goto err_regions;
> +	}
> +
> +	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> +				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
> +	if (ret < 0) {
> +		IFCVF_ERR(&pdev->dev, "Failed to alloc irq vectors\n");
> +		goto err_vectors;
> +	}
> +
> +	adapter = vdpa_alloc_device(ifcvf_adapter, vdpa, dev, &ifc_vdpa_ops);
> +	if (adapter == NULL) {
> +		IFCVF_ERR(&pdev->dev, "Failed to allocate vDPA structure");
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	adapter->dev = dev;
> +	pci_set_master(pdev);
> +	pci_set_drvdata(pdev, adapter);
> +
> +	ret = ifcvf_request_irq(adapter);
> +	if (ret) {
> +		IFCVF_ERR(&pdev->dev, "Failed to request MSI-X irq\n");
> +		goto err_msix;
> +	}
> +
> +	vf = &adapter->vf;
> +	for (i = 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
> +		vf->mem_resource[i].phys_addr = pci_resource_start(pdev, i);
> +		vf->mem_resource[i].len = pci_resource_len(pdev, i);
> +		if (!vf->mem_resource[i].len)
> +			continue;
> +
> +		vf->mem_resource[i].addr = pci_iomap_range(pdev, i, 0,
> +				vf->mem_resource[i].len);
> +		if (!vf->mem_resource[i].addr) {
> +			IFCVF_ERR(&pdev->dev,
> +				  "Failed to map IO resource %d\n", i);
> +			ret = -EINVAL;
> +			goto err_msix;
> +		}
> +	}
> +
> +	if (ifcvf_init_hw(vf, pdev) < 0) {
> +		ret = -EINVAL;
> +		goto err_msix;
> +	}
> +
> +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> +	if (ret)
> +		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +
> +	if (ret) {
> +		IFCVF_ERR(adapter->dev, "No usable DMA confiugration\n");
> +		ret = -EINVAL;
> +		goto err_msix;
> +	}
> +
> +	adapter->vdpa.dma_dev = dev;
> +	ret = vdpa_register_device(&adapter->vdpa);
> +	if (ret) {
> +		IFCVF_ERR(adapter->dev, "Failed to register ifcvf to vdpa bus");
> +		goto err_msix;
> +	}
> +
> +	return 0;
> +
> +err_msix:
> +	put_device(&adapter->vdpa.dev);
> +	return ret;
> +err_alloc:
> +	pci_free_irq_vectors(pdev);
> +err_vectors:
> +	pci_release_regions(pdev);
> +err_regions:
> +	pci_disable_device(pdev);
> +err_enable:
> +	return ret;
> +}

I personally don't like seeing goto unwinds with multiple returns, and
here I think it is actually a tiny bug.

All touches to the PCI device must stop before the driver core
remove() returns - so these pci function cannot be in the kref put
release function anyhow.

Suggest to use the devm versions of the above instead, and then you
can reorder things so the allocation is done first.

Jason
