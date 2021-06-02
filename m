Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0495398376
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhFBHsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:48:01 -0400
Received: from mail-dm6nam08on2059.outbound.protection.outlook.com ([40.107.102.59]:1248
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232102AbhFBHr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 03:47:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3B+6XpjKkSLohUx8ytU7bam2XZCq4WmOVrIroFTPwtMH+BvimNjEJFedwscmYiSIeGvUYgnsiqay98ErWfllxV3bUusyDVD7UeV1xStTBflLMyxYUi+SS37mO77+Q9mgeq3iE7jC7IHF6s6WcfCsQWN2O29RW3gz/fZVkBwpC11V4ckFrDomVYRlEm5CxOhKhRjde6jfvyfJyc6octDfPB7FIrH1YVEGOdOd9N6Q7DuGN9TgKcjgBGWxXrwvh8fXGDarU9yjf2NYTiu8t2o60UnU313YT/BGBMuEYDKOzvrXlcyIKwm98+23fhREAeBHrGhDzbETsQL235NxzhmhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOa9tnayFoa0X3mG3GeCPb7mF93+2eu0af2grQz6Ztc=;
 b=ZB8JSE6j4gZ/PAraDei92LglaGztTdW3iDPBYOlUIc8AQk3gXQmXV5d5v/cP0iHhP7jxZob3Ic6XfQsql3kQXExgHSj2j60LTMWzsGi3KZVk52jCKOD5I081K5dNceZkok/jCcG6W9K7xxCyku6mVfD7sXSu1ieIJsYwQFJILUwipnJ7KdAw7BSwThzB+k2I2Rja5DlykeebUJD/PpDViQ+ahCOBTLreEpvF9k/jbAyyVRwg3kcjUQtRJ3531iR1ev/piFhIAGj3KWKa0E6tUtBp7sZCrm9iJPgHFNiL9YvFnWwu8HEIw5j3RXiEG16xhrd3NWAaSt0zmM5Ty/XsyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOa9tnayFoa0X3mG3GeCPb7mF93+2eu0af2grQz6Ztc=;
 b=CYpJNStdZpk8wdZkUDX/fQMsywcXImcMGVYuoxbGyOKj8PKjRBT3kASSfqKZGa/JXkPdLt0MIuo1lYdwlzqC/VQPzNkPjHyT8X7UYDTWCQaP4yboE8QpALJE61XBoEOdefqCjgEGyrJZQ3EBfYt1zKHklbSckeqy6t07WahSLhtGR8StWFADCFFGyetv6s3OibjSgoAv6wIcBAXGbRSrhdlA6Ufu/N4ZJSE8uk77YtCOexkHj80WpK2tMgyMmMqERBBfk42LgenqazSPiEPHkKPbhjy4pYyLk5nR1kJFmuVHdTTmj2g7tAVUeGCaSxLvVBCz6f7HGLhhSd9hszBvxQ==
Received: from DM5PR06CA0036.namprd06.prod.outlook.com (2603:10b6:3:5d::22) by
 MW3PR12MB4364.namprd12.prod.outlook.com (2603:10b6:303:5c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.22; Wed, 2 Jun 2021 07:46:15 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::a7) by DM5PR06CA0036.outlook.office365.com
 (2603:10b6:3:5d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 07:46:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 07:46:14 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 2 Jun 2021 07:46:11 +0000
Date:   Wed, 2 Jun 2021 10:46:06 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <eli@mellanox.com>
Subject: Re: [PATCH V2 RESEND 2/4] virtio-pci library: introduce
 vp_modern_get_driver_features()
Message-ID: <20210602074606.GF12498@mtl-vdi-166.wap.labs.mlnx>
References: <20210602021536.39525-1-jasowang@redhat.com>
 <20210602021536.39525-3-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210602021536.39525-3-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90501594-6f1c-4da6-6f2d-08d9259a7fcd
X-MS-TrafficTypeDiagnostic: MW3PR12MB4364:
X-Microsoft-Antispam-PRVS: <MW3PR12MB4364580EE4FB3423986AC931AB3D9@MW3PR12MB4364.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I4ZtxTOWc68S0bumemq34uGMY4tJnb2yZBCKcDC8t/06mmdEdVYkc9IG6o+XYi90Ua5tZdwzKYNr3/PoP6Wne8JY9MzPUE+7cj0+V9d8UIw4to4xnXqrv3VTQ/R8wm9dr8kFYmq6QdgqReeMW22Gzex1G9BQ4WhCq2usYjDq7HmY58MXZ7CW2N4ZoDqiv90M2pO9dfUDGoGmFiaLpvfg/OgVb/JFiNLOv0PW0qUcDCfwONjARL8S3PNdxf65V9qVPQFkNO/JNceWG3yn7Hfpl/T0qzDjpCgEEc3qzyLUhZNEvf+9bKKKRtT5Rs78qkg/vSbsV/tqytVUxuSyd03Q3zjcQtx1ndncZi1W/9g3TYyeQgChbEIhNpQz2tb0g2bBL5OYaeXejm4DfLEKcVmNGZW6qLIa8gliNWGa+ZvNIzJSq88vIgiQbfFf/UMSfcaTNPIwX/DevYRIecgEpT3DjniDkjvqSTPhXHxqFoSsn65P4+0yYTaREgcsyPodjEB3DihbWouBFjVGcD84cxNKMS6pNbogn4em/2jk7xHmeO3jV5E4CWb9ossDhowZAw9XbHUVmGZo6/vpOjn/86gm14+jiPMO7Poq9zyJPb7i5nxbv11K0mTYPUZwo7qPrkLIIGQCG6EIrahF3w9IwhqsiGgTg6BuMSX/F4tyIuHiV0c=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(346002)(46966006)(36840700001)(316002)(36906005)(5660300002)(54906003)(2906002)(1076003)(9686003)(186003)(26005)(336012)(107886003)(55016002)(70206006)(478600001)(36860700001)(86362001)(426003)(4326008)(7696005)(47076005)(8936002)(82310400003)(82740400003)(356005)(7636003)(6666004)(83380400001)(8676002)(6916009)(33656002)(70586007)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 07:46:14.7797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90501594-6f1c-4da6-6f2d-08d9259a7fcd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:15:34AM +0800, Jason Wang wrote:
> This patch introduce a helper to get driver/guest features from the
> device.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
> ---
>  drivers/virtio/virtio_pci_modern_dev.c | 21 +++++++++++++++++++++
>  include/linux/virtio_pci_modern.h      |  1 +
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> index 54f297028586..e11ed748e661 100644
> --- a/drivers/virtio/virtio_pci_modern_dev.c
> +++ b/drivers/virtio/virtio_pci_modern_dev.c
> @@ -383,6 +383,27 @@ u64 vp_modern_get_features(struct virtio_pci_modern_device *mdev)
>  }
>  EXPORT_SYMBOL_GPL(vp_modern_get_features);
>  
> +/*
> + * vp_modern_get_driver_features - get driver features from device
> + * @mdev: the modern virtio-pci device
> + *
> + * Returns the driver features read from the device
> + */
> +u64 vp_modern_get_driver_features(struct virtio_pci_modern_device *mdev)
> +{
> +	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
> +
> +	u64 features;
> +
> +	vp_iowrite32(0, &cfg->guest_feature_select);
> +	features = vp_ioread32(&cfg->guest_feature);
> +	vp_iowrite32(1, &cfg->guest_feature_select);
> +	features |= ((u64)vp_ioread32(&cfg->guest_feature) << 32);
> +
> +	return features;
> +}
> +EXPORT_SYMBOL_GPL(vp_modern_get_driver_features);
> +
>  /*
>   * vp_modern_set_features - set features to device
>   * @mdev: the modern virtio-pci device
> diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> index 6a95b58fd0f4..eb2bd9b4077d 100644
> --- a/include/linux/virtio_pci_modern.h
> +++ b/include/linux/virtio_pci_modern.h
> @@ -79,6 +79,7 @@ static inline void vp_iowrite64_twopart(u64 val,
>  }
>  
>  u64 vp_modern_get_features(struct virtio_pci_modern_device *mdev);
> +u64 vp_modern_get_driver_features(struct virtio_pci_modern_device *mdev);
>  void vp_modern_set_features(struct virtio_pci_modern_device *mdev,
>  		     u64 features);
>  u32 vp_modern_generation(struct virtio_pci_modern_device *mdev);
> -- 
> 2.25.1
> 
