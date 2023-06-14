Return-Path: <netdev+bounces-10879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EAEB97309D5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE26E1C20DB7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0A3134B2;
	Wed, 14 Jun 2023 21:31:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DD02EC3F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 21:31:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC0A2101
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686778268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WKqEIHnlxf6mwzhgDSRr508DxiYghyosbbxoYepRPGM=;
	b=HvETx1SpIawZwOhjC6TF+HBbjhwWgNbVsbtZEaFkA4WPZCzz1gtxpxxeNeNTEkeTkavsOe
	cvBeC8UiQ8i9oYz68Iv4RQ7+VdnIZw+qaNdfjiAcpd808idHVn8ffr11qwpv23+RqdQ8CL
	gbT2E2/awkZUdZV+l9B3rwjbFyGTIcg=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-0IF0KvGPNiCl53lqxNJoxw-1; Wed, 14 Jun 2023 17:31:05 -0400
X-MC-Unique: 0IF0KvGPNiCl53lqxNJoxw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7773997237cso767425239f.1
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686778265; x=1689370265;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WKqEIHnlxf6mwzhgDSRr508DxiYghyosbbxoYepRPGM=;
        b=Jov4ygF+P9BuZzR9kmUGehrUnYJ7wrR7rQKuoBRevmL6/7Lk7EOy2gVXxkaK9dPEeK
         Zf8uEYKRXjOGM3CkAXzvE0llxqVaq0FPVOOIrjIyzOwPMuuejdZz8kDQfGOacrl+/CuA
         Lm4x9SGf+/erUZYdzTWJFcs5kTxh6Y4dcI8VwmnwrgBQufWjoyjUpTPjth8MvwAHDfFh
         6kKQg/6fG8PYCyCNZzuAOFhs9iHX+RE09PDE0KDE/rJoKt6xKopFvhApPSwrACFo2rbS
         xFf6wkDjGMhU/jVQ4q4Yox9Bae6hv+MWpSzo1T5WqYpjMDiiukAH6xmraLKldGglZJSb
         my3Q==
X-Gm-Message-State: AC+VfDyToQHA62vcYvR9AmFc8N+2nKiu6QQtAXZ5oCxsAKPtRF+ukWRF
	5DO1ntW/f6KF6YNeoclGPVeYmZxEk6RojPZ+gsWPLn+E5FLJk9bWKkQBsEbYnqhVBWd32Hl39JY
	W4vLzLJmk8z8Uy1u3
X-Received: by 2002:a5e:da0a:0:b0:776:f992:78cf with SMTP id x10-20020a5eda0a000000b00776f99278cfmr14423816ioj.12.1686778264999;
        Wed, 14 Jun 2023 14:31:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7uiMpXdoX0C+7KK/CRCXj6bO8OX1uxwSsvmcuhnlcQTkcoN2CjjS23CivsgSBqyVM9D5u/Tw==
X-Received: by 2002:a5e:da0a:0:b0:776:f992:78cf with SMTP id x10-20020a5eda0a000000b00776f99278cfmr14423804ioj.12.1686778264742;
        Wed, 14 Jun 2023 14:31:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m28-20020a02cddc000000b004210512e4b5sm3710351jap.174.2023.06.14.14.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 14:31:04 -0700 (PDT)
Date: Wed, 14 Jun 2023 15:31:02 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <jgg@nvidia.com>,
 <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
 <kevin.tian@intel.com>, <shannon.nelson@amd.com>
Subject: Re: [PATCH v10 vfio 2/7] vfio/pds: Initial support for pds_vfio
 VFIO driver
Message-ID: <20230614153102.54e82fe2.alex.williamson@redhat.com>
In-Reply-To: <20230602220318.15323-3-brett.creeley@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
	<20230602220318.15323-3-brett.creeley@amd.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2 Jun 2023 15:03:13 -0700
Brett Creeley <brett.creeley@amd.com> wrote:

> This is the initial framework for the new pds_vfio device driver. This
> does the very basics of registering the PDS PCI device and configuring
> it as a VFIO PCI device.
> 
> With this change, the VF device can be bound to the pds_vfio driver on
> the host and presented to the VM as the VF's device type.
> 
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vfio/pci/Makefile       |  2 +
>  drivers/vfio/pci/pds/Makefile   |  8 ++++
>  drivers/vfio/pci/pds/pci_drv.c  | 69 +++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/vfio_dev.c | 72 +++++++++++++++++++++++++++++++++
>  drivers/vfio/pci/pds/vfio_dev.h | 20 +++++++++
>  5 files changed, 171 insertions(+)
>  create mode 100644 drivers/vfio/pci/pds/Makefile
>  create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>  create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>  create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
> 
> diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
> index 24c524224da5..45167be462d8 100644
> --- a/drivers/vfio/pci/Makefile
> +++ b/drivers/vfio/pci/Makefile
> @@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
>  obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
>  
>  obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
> +
> +obj-$(CONFIG_PDS_VFIO_PCI) += pds/
> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
> new file mode 100644
> index 000000000000..e1a55ae0f079
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 Advanced Micro Devices, Inc.
> +
> +obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o

Given the existing drivers:

obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisi-acc-vfio-pci.o

Does it make sense to name this one pds-vfio-pci?

> +
> +pds_vfio-y := \
> +	pci_drv.o	\
> +	vfio_dev.o
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
> new file mode 100644
> index 000000000000..0e84249069d4
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/types.h>
> +#include <linux/vfio.h>
> +
> +#include <linux/pds/pds_core_if.h>
> +
> +#include "vfio_dev.h"
> +
> +#define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
> +#define PCI_VENDOR_ID_PENSANDO		0x1dd8

Isn't this a duplicate from the above include:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/pds/pds_core_if.h#n7

I also find it defined in ionic.h, which means that it now satisfies
pci_ids.h requirement that the identifier is shared between multiple
drivers.  A trivial follow-up after this series might combine them
there.

> +
> +static int pds_vfio_pci_probe(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	struct pds_vfio_pci_device *pds_vfio;
> +	int err;
> +
> +	pds_vfio = vfio_alloc_device(pds_vfio_pci_device, vfio_coredev.vdev,
> +				     &pdev->dev, pds_vfio_ops_info());
> +	if (IS_ERR(pds_vfio))
> +		return PTR_ERR(pds_vfio);
> +
> +	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
> +
> +	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
> +	if (err)
> +		goto out_put_vdev;
> +
> +	return 0;
> +
> +out_put_vdev:
> +	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
> +	return err;
> +}
> +
> +static void pds_vfio_pci_remove(struct pci_dev *pdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
> +
> +	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
> +	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
> +}
> +
> +static const struct pci_device_id
> +pds_vfio_pci_table[] = {
> +	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_PENSANDO, 0x1003) }, /* Ethernet VF */
> +	{ 0, }
> +};
> +MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
> +
> +static struct pci_driver pds_vfio_pci_driver = {
> +	.name = KBUILD_MODNAME,
> +	.id_table = pds_vfio_pci_table,
> +	.probe = pds_vfio_pci_probe,
> +	.remove = pds_vfio_pci_remove,
> +	.driver_managed_dma = true,
> +};
> +
> +module_pci_driver(pds_vfio_pci_driver);
> +
> +MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
> +MODULE_AUTHOR("Advanced Micro Devices, Inc.");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> new file mode 100644
> index 000000000000..4038dac90a97
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -0,0 +1,72 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#include <linux/vfio.h>
> +#include <linux/vfio_pci_core.h>
> +
> +#include "vfio_dev.h"
> +
> +struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
> +{
> +	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
> +
> +	return container_of(core_device, struct pds_vfio_pci_device,
> +			    vfio_coredev);
> +}
> +
> +static int pds_vfio_init_device(struct vfio_device *vdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +	struct pci_dev *pdev = to_pci_dev(vdev->dev);
> +	int err;
> +
> +	err = vfio_pci_core_init_dev(vdev);
> +	if (err)
> +		return err;
> +
> +	pds_vfio->vf_id = pci_iov_vf_id(pdev);
> +	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);

We only ever end up using pci_id for a debug print here that could use
a local variable and a slow path client registration that has access to
pdev to do a lookup on demand.  Why do we bother caching it on the
pds_vfio_pci_device?  Thanks,

Alex

> +
> +	return 0;
> +}
> +
> +static int pds_vfio_open_device(struct vfio_device *vdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +	int err;
> +
> +	err = vfio_pci_core_enable(&pds_vfio->vfio_coredev);
> +	if (err)
> +		return err;
> +
> +	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
> +
> +	return 0;
> +}
> +
> +static const struct vfio_device_ops pds_vfio_ops = {
> +	.name = "pds-vfio",
> +	.init = pds_vfio_init_device,
> +	.release = vfio_pci_core_release_dev,
> +	.open_device = pds_vfio_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.device_feature = vfio_pci_core_ioctl_feature,
> +	.read = vfio_pci_core_read,
> +	.write = vfio_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +};
> +
> +const struct vfio_device_ops *pds_vfio_ops_info(void)
> +{
> +	return &pds_vfio_ops;
> +}
> diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
> new file mode 100644
> index 000000000000..66cfcab5b5bf
> --- /dev/null
> +++ b/drivers/vfio/pci/pds/vfio_dev.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> +
> +#ifndef _VFIO_DEV_H_
> +#define _VFIO_DEV_H_
> +
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +
> +struct pds_vfio_pci_device {
> +	struct vfio_pci_core_device vfio_coredev;
> +
> +	int vf_id;
> +	int pci_id;
> +};
> +
> +const struct vfio_device_ops *pds_vfio_ops_info(void);
> +struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
> +
> +#endif /* _VFIO_DEV_H_ */


