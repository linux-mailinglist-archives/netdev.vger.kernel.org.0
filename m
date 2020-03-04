Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 272C717990D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 20:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCDT37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 14:29:59 -0500
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:56135
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727137AbgCDT36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 14:29:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O28yo6HF05cOsDBFSqz1xMDAtNrElXsrbcRnlYMGaj2kyYG4lQSelyzHTf8j+k7ZFPi61Xz+B0JDTn5V4o/w8UpVsrhHegKh2ibvYPw2iG5bc353ghz2hzsC6qtzsqhMj4qmh7dCCUrf9Bh8Nl52Kq8yHp1IrsfoYKERvWMixe24BgPyZXOMqEZ4x0u9XFPuiuZWt2BNe4mypSBT+v1BVNRzXlnNho+UyjJzGhPXadfuVTXny+j4kxUbuwCAsbaYto2QNkATYpDMoPTq/XoL7D2Fxsq3UkXOyoweyRR+Saq9aynNXs2cYQydhVf/ja4KoE1jmj9BOXAndFKnNnaw+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdAaCaeS6gH3f4tq2Jl1Gb8UTkCxekN4gIDIDC+Aqrg=;
 b=NPkj7Xw6JJhBzULl8qRtCh5SdrJhHVx1Ky7opqsmY3dXeFQ5yp4mPYKXdU3ztXqx1KAjO1CeYpL7sMx43iQ6FhDKNBWQdGWex4wUOGhPxbal9SNg1jP2/kmdx5dMpk4pj9NQPcHDnV9T+9vKlA5OpJ9IrevbxISiPF/RUThUcWcUzcil73wZJzJiGfVePm7h5/fltnaZ1yDCXj/IeRWRyCe6YtlZX0dApyno4cJVKzem/AX+3c894tHE8rL/eFtUuAkKas1O0SaS+wSBjbz7wgU4HSfjRZ146uNWrX5NHUWp+mTOtM8T56J+SdAR4OufOmQVFQ3lha48907Rw8Xqcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdAaCaeS6gH3f4tq2Jl1Gb8UTkCxekN4gIDIDC+Aqrg=;
 b=XdhUAXzgUWUmvJv97oAXj/MKjzreQtkMbpM5u2QjlMiqBcNAbPkXLpx1K4GfuDRmOrYDDgGPtRKjHVIWLLDQDD+TJf8JKRHRQIbjI4ghmlKmX0crc8EoXY6kxmx4E6rgvelsc25O9Y50WEv1fzvZ7gz/PElgvbFPbS8tF4DCsgk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5517.eurprd05.prod.outlook.com (20.177.63.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Wed, 4 Mar 2020 19:29:54 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 19:29:53 +0000
Date:   Wed, 4 Mar 2020 15:29:49 -0400
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
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com,
        gdawar@xilinx.com, saugatm@xilinx.com, vmireyno@marvell.com
Subject: Re: [PATCH V5 3/5] vDPA: introduce vDPA bus
Message-ID: <20200304192949.GR26318@mellanox.com>
References: <20200226060456.27275-1-jasowang@redhat.com>
 <20200226060456.27275-4-jasowang@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226060456.27275-4-jasowang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR10CA0033.namprd10.prod.outlook.com
 (2603:10b6:208:120::46) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR10CA0033.namprd10.prod.outlook.com (2603:10b6:208:120::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Wed, 4 Mar 2020 19:29:53 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j9ZiH-00049z-RF; Wed, 04 Mar 2020 15:29:49 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d98aec35-0972-4f40-4e0b-08d7c0726a09
X-MS-TrafficTypeDiagnostic: VI1PR05MB5517:|VI1PR05MB5517:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB55177CA4E470400BD227AFACCFE50@VI1PR05MB5517.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0332AACBC3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(189003)(199004)(5660300002)(66476007)(66556008)(1076003)(2906002)(186003)(26005)(66946007)(4744005)(2616005)(478600001)(4326008)(9786002)(86362001)(7416002)(9746002)(33656002)(316002)(52116002)(8936002)(6916009)(81156014)(36756003)(8676002)(81166006)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5517;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cs+Oqh1WVP0VX5f10uU7496uwqpHzFRQZ4St/l9G0+aHAHkA2m4poO6MRBAy8QDNkUHGmlh4tyNxDBYGal8BQq9DUvrKmoUs2fff6Js7+pS3dEMm5g+RFg6nDvx/GZfG7ppJffjFhFq5BsboG9ZQtY+b4CvkKmvyJrVw4WQ1sgyewj9iPdq29jMuT21bqCUc39Rf/etKlAgrESAj2LZO1++GLdCF0S9eRUG2KXlLn0z0zkkjew5qFSHJzpOC7PyT5CtQ4q8EvmHgn4qGq1N6Xty9EyME05XUV4qhOwymtvPE5Ol6kp5g72PIPUEO6uFEOjg5m490cQARg53YkgejufLAgB3+NGG0fAfBod1U+eFRuBZ2Z+ItF3g3SX7FnFgkLJNOyDYZ0PhE08QabNQMiljN/uCx31xdRKHsgRpArp2OZoi5+UTss2ZJ0XR9Xux2dy0wxIFgL/GfABVC7os2dopjgDpLNZZFsSFJLWXv3EFL1GZpDWj9eZFzM5FEEdce
X-MS-Exchange-AntiSpam-MessageData: G5bmvnIdH/p+8eBLKd/Pv2g3KSi+XqfhCywq5AL8n2zB8cW+S6JbYTF7KdzfKnEPuJ1RLvgKKCns1nRhSwbWgpvOdE/jfPkXdLZW6FP2R/OpHrv3R6PWJNkBvObHMyiM4dUTHSgc//c358DLdm+Hdg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98aec35-0972-4f40-4e0b-08d7c0726a09
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2020 19:29:53.7052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gm95soseglM49q+o7mL7+vmRjQK8qoTKXNbiKqcZ/f/ZYos7+evrQihzO6cBRFlQv4URKt3+4bsSiLOrxBlcDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5517
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 02:04:54PM +0800, Jason Wang wrote:
> +struct vdpa_device *vdpa_alloc_device(struct device *parent,
> +				      struct device *dma_dev,
> +				      const struct vdpa_config_ops *config)
> +{
> +	struct vdpa_device *vdev;
> +	int err = -ENOMEM;
> +
> +	if (!parent || !dma_dev || !config)
> +		goto err;
> +
> +	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> +	if (!vdev)
> +		goto err;
> +
> +	err = ida_simple_get(&vdpa_index_ida, 0, 0, GFP_KERNEL);
> +	if (err < 0)
> +		goto err_ida;
> +
> +	vdev->dev.bus = &vdpa_bus;
> +	vdev->dev.parent = parent;
> +	vdev->dev.release = vdpa_release_dev;
> +
> +	device_initialize(&vdev->dev);
> +
> +	vdev->index = err;
> +	vdev->dma_dev = dma_dev;
> +	vdev->config = config;
> +
> +	dev_set_name(&vdev->dev, "vdpa%u", vdev->index);

Probably shouldn't ignore the error for dev_set_name ?

err = dev_set_name()
if (err) {
   put_device(&vdev->dev);
   return ERR_PTR(err);
}

Jason
