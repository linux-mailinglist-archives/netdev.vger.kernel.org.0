Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A4F6C5DD3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 05:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCWENE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 00:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjCWEND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 00:13:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DDE10CA
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 21:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679544735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P/rEURdgh4BDr+hLgWS6iVZmhSJ0z8sziCYrloAoZJ8=;
        b=WPj7tYN9lEgIu2k8PfUzhRfPAABiJX4iVTHUvrdpdBzqbUumK4SFfIB5CGGRILquRnSF0S
        ProzeVTEJ3YiMtE625c63kj5d680+NXN2/52zHYWwb2NgbO0IaYAaPyyUuAFqA0vrK1F9v
        o3+sMqQZEmYA9foRKGTeFF9FXwY2mKQ=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-aFYW7DG2OjepeftRy5UJaw-1; Thu, 23 Mar 2023 00:12:14 -0400
X-MC-Unique: aFYW7DG2OjepeftRy5UJaw-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-17ab1d11480so10870754fac.13
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 21:12:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679544732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P/rEURdgh4BDr+hLgWS6iVZmhSJ0z8sziCYrloAoZJ8=;
        b=OcpR1t8VkGLEP+n1PVpTO1Dz0WOjWiHR0G52nwzlcfi8zKmSuoe7hMJV1K9+aU0r8z
         JPSgul2rCCl6kn1PvXy+1/rNoWjrW7Benyf5BgRSCBMFD22AfFttatnzOlYzzCsDuAqf
         TjLOU9yoM6EhINR3jaS8vQ/g2qSYRpZpG0fYiwvluj3MJzVMtW/GrAfbcQeOm9TgB0WT
         dO8wS12Q1YtDGs25jVKpB7B9hhBOganPVhq2sjSrRnk0WgzL6ejM3hMGIOvKTE36Vx6L
         RRNXOQTCEV8lMgH9xJaleOqbfcl/23p1ubajNqleLeRnMEWN7O2DImdNXxcfYJseQKwT
         OB/Q==
X-Gm-Message-State: AO0yUKUfMAPcDEHe4mXsrLndwjg/4oeHQJqxlignZZMTsfJeSjqi1kXp
        Y0EJwbuMEFj7qcST8qVBfMj6g2eS7V6lx0pALiLbRuGsNLw/OoHZ8/3A9Z53k1uM/9QzxV8XcwI
        6etav8qYTot45H3ut/rZVN7gIIEvh5i4B
X-Received: by 2002:a54:4189:0:b0:384:c4a:1b49 with SMTP id 9-20020a544189000000b003840c4a1b49mr1677808oiy.9.1679544732684;
        Wed, 22 Mar 2023 21:12:12 -0700 (PDT)
X-Google-Smtp-Source: AK7set9dXESIokZypKTeU6rPDw1zCB9t6hzb9iX9sruRgTHNecmX/0775oZf2BKRn+7pZSFebEG235WB2+zaqAN/QPY=
X-Received: by 2002:a54:4189:0:b0:384:c4a:1b49 with SMTP id
 9-20020a544189000000b003840c4a1b49mr1677801oiy.9.1679544732468; Wed, 22 Mar
 2023 21:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230322191038.44037-1-shannon.nelson@amd.com> <20230322191038.44037-3-shannon.nelson@amd.com>
In-Reply-To: <20230322191038.44037-3-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 12:12:01 +0800
Message-ID: <CACGkMEvRr968H1_e+bdK-r4ApvJg8g+PTeShNS1tp6Ju_5sP8g@mail.gmail.com>
Subject: Re: [PATCH v3 virtio 2/8] pds_vdpa: Add new vDPA driver for
 AMD/Pensando DSC
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 3:11=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.=
com> wrote:
>
> This is the initial auxiliary driver framework for a new vDPA
> device driver, an auxiliary_bus client of the pds_core driver.
> The pds_core driver supplies the PCI services for the VF device
> and for accessing the adminq in the PF device.
>
> This patch adds the very basics of registering for the auxiliary
> device and setting up debugfs entries.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/Makefile        |  1 +
>  drivers/vdpa/pds/Makefile    |  8 ++++
>  drivers/vdpa/pds/aux_drv.c   | 84 ++++++++++++++++++++++++++++++++++++
>  drivers/vdpa/pds/aux_drv.h   | 15 +++++++
>  drivers/vdpa/pds/debugfs.c   | 29 +++++++++++++
>  drivers/vdpa/pds/debugfs.h   | 18 ++++++++
>  include/linux/pds/pds_vdpa.h | 10 +++++
>  7 files changed, 165 insertions(+)
>  create mode 100644 drivers/vdpa/pds/Makefile
>  create mode 100644 drivers/vdpa/pds/aux_drv.c
>  create mode 100644 drivers/vdpa/pds/aux_drv.h
>  create mode 100644 drivers/vdpa/pds/debugfs.c
>  create mode 100644 drivers/vdpa/pds/debugfs.h
>  create mode 100644 include/linux/pds/pds_vdpa.h
>
> diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
> index 59396ff2a318..8f53c6f3cca7 100644
> --- a/drivers/vdpa/Makefile
> +++ b/drivers/vdpa/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_MLX5_VDPA) +=3D mlx5/
>  obj-$(CONFIG_VP_VDPA)    +=3D virtio_pci/
>  obj-$(CONFIG_ALIBABA_ENI_VDPA) +=3D alibaba/
>  obj-$(CONFIG_SNET_VDPA) +=3D solidrun/
> +obj-$(CONFIG_PDS_VDPA) +=3D pds/
> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> new file mode 100644
> index 000000000000..a9cd2f450ae1
> --- /dev/null
> +++ b/drivers/vdpa/pds/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +# Copyright(c) 2023 Advanced Micro Devices, Inc
> +
> +obj-$(CONFIG_PDS_VDPA) :=3D pds_vdpa.o
> +
> +pds_vdpa-y :=3D aux_drv.o
> +
> +pds_vdpa-$(CONFIG_DEBUG_FS) +=3D debugfs.o
> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> new file mode 100644
> index 000000000000..39c03f067b77
> --- /dev/null
> +++ b/drivers/vdpa/pds/aux_drv.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/auxiliary_bus.h>
> +#include <linux/pci.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
> +#include <linux/pds/pds_auxbus.h>
> +#include <linux/pds/pds_vdpa.h>
> +
> +#include "aux_drv.h"
> +#include "debugfs.h"
> +
> +static const struct auxiliary_device_id pds_vdpa_id_table[] =3D {
> +       { .name =3D PDS_VDPA_DEV_NAME, },
> +       {},
> +};
> +
> +static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
> +                         const struct auxiliary_device_id *id)
> +
> +{
> +       struct pds_auxiliary_dev *padev =3D
> +               container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
> +       struct pds_vdpa_aux *vdpa_aux;
> +
> +       vdpa_aux =3D kzalloc(sizeof(*vdpa_aux), GFP_KERNEL);
> +       if (!vdpa_aux)
> +               return -ENOMEM;
> +
> +       vdpa_aux->padev =3D padev;
> +       auxiliary_set_drvdata(aux_dev, vdpa_aux);
> +
> +       return 0;
> +}
> +
> +static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
> +{
> +       struct pds_vdpa_aux *vdpa_aux =3D auxiliary_get_drvdata(aux_dev);
> +       struct device *dev =3D &aux_dev->dev;
> +
> +       kfree(vdpa_aux);
> +       auxiliary_set_drvdata(aux_dev, NULL);
> +
> +       dev_info(dev, "Removed\n");
> +}
> +
> +static struct auxiliary_driver pds_vdpa_driver =3D {
> +       .name =3D PDS_DEV_TYPE_VDPA_STR,
> +       .probe =3D pds_vdpa_probe,
> +       .remove =3D pds_vdpa_remove,
> +       .id_table =3D pds_vdpa_id_table,
> +};
> +
> +static void __exit pds_vdpa_cleanup(void)
> +{
> +       auxiliary_driver_unregister(&pds_vdpa_driver);
> +
> +       pds_vdpa_debugfs_destroy();
> +}
> +module_exit(pds_vdpa_cleanup);
> +
> +static int __init pds_vdpa_init(void)
> +{
> +       int err;
> +
> +       pds_vdpa_debugfs_create();
> +
> +       err =3D auxiliary_driver_register(&pds_vdpa_driver);
> +       if (err) {
> +               pr_err("%s: aux driver register failed: %pe\n",
> +                      PDS_VDPA_DRV_NAME, ERR_PTR(err));
> +               pds_vdpa_debugfs_destroy();
> +       }
> +
> +       return err;
> +}
> +module_init(pds_vdpa_init);
> +
> +MODULE_DESCRIPTION(PDS_VDPA_DRV_DESCRIPTION);
> +MODULE_AUTHOR("Advanced Micro Devices, Inc");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
> new file mode 100644
> index 000000000000..14e465944dfd
> --- /dev/null
> +++ b/drivers/vdpa/pds/aux_drv.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifndef _AUX_DRV_H_
> +#define _AUX_DRV_H_
> +
> +#define PDS_VDPA_DRV_DESCRIPTION    "AMD/Pensando vDPA VF Device Driver"
> +#define PDS_VDPA_DRV_NAME           "pds_vdpa"
> +
> +struct pds_vdpa_aux {
> +       struct pds_auxiliary_dev *padev;
> +
> +       struct dentry *dentry;
> +};
> +#endif /* _AUX_DRV_H_ */
> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
> new file mode 100644
> index 000000000000..12e844f96ccc
> --- /dev/null
> +++ b/drivers/vdpa/pds/debugfs.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/pci.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
> +#include <linux/pds/pds_adminq.h>
> +#include <linux/pds/pds_auxbus.h>
> +
> +#include "aux_drv.h"
> +#include "debugfs.h"
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +static struct dentry *dbfs_dir;
> +
> +void pds_vdpa_debugfs_create(void)
> +{
> +       dbfs_dir =3D debugfs_create_dir(PDS_VDPA_DRV_NAME, NULL);
> +}
> +
> +void pds_vdpa_debugfs_destroy(void)
> +{
> +       debugfs_remove_recursive(dbfs_dir);
> +       dbfs_dir =3D NULL;
> +}
> +
> +#endif /* CONFIG_DEBUG_FS */
> diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
> new file mode 100644
> index 000000000000..fff078a869e5
> --- /dev/null
> +++ b/drivers/vdpa/pds/debugfs.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifndef _PDS_VDPA_DEBUGFS_H_
> +#define _PDS_VDPA_DEBUGFS_H_
> +
> +#include <linux/debugfs.h>
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +void pds_vdpa_debugfs_create(void);
> +void pds_vdpa_debugfs_destroy(void);
> +#else
> +static inline void pds_vdpa_debugfs_create(void) { }
> +static inline void pds_vdpa_debugfs_destroy(void) { }
> +#endif
> +
> +#endif /* _PDS_VDPA_DEBUGFS_H_ */
> diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
> new file mode 100644
> index 000000000000..d3414536985d
> --- /dev/null
> +++ b/include/linux/pds/pds_vdpa.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifndef _PDS_VDPA_H_
> +#define _PDS_VDPA_H_
> +
> +#define PDS_DEV_TYPE_VDPA_STR  "vDPA"
> +#define PDS_VDPA_DEV_NAME      PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_S=
TR
> +
> +#endif /* _PDS_VDPA_H_ */
> --
> 2.17.1
>

