Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D77E6BA8B7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbjCOHGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjCOHGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:06:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C130A6A072
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678863931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1m9Bi27NroDgBkjwUUojDp5AK+Y/4RdJw5Soguqxzu8=;
        b=I1IfSfVhcZjKUhtHmWXihuOVlVTyMqWY6jkPao9yPZOAUhb622nWH56scGuM9cUjlyAWEE
        zW0IJYWcUnuVYSHrEENUCiz081zah87MRIIARHXAuRUtnPR2CbNg1yO72YwB7hBF3N5itE
        p3sEKrPVbdlhnQs6mlO7/Xr9N23t7j8=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-Vyp-Yl59PICmFS6qAz3Clg-1; Wed, 15 Mar 2023 03:05:27 -0400
X-MC-Unique: Vyp-Yl59PICmFS6qAz3Clg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-17270774b8fso10607391fac.3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:05:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678863926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1m9Bi27NroDgBkjwUUojDp5AK+Y/4RdJw5Soguqxzu8=;
        b=Zxxaav8ypBW6rnh1zeSygoKbKkyEWO4zJodPFsJkDRlHnA20WD2oh3DADfQ70821nK
         Lgv1oY2tAJBmAGMzy9/RM+giDeHntF1NRimBw/3gmt8NmP7FpZq5Jwazl1aU9K/bTmzT
         OjCAf7MmNNX1yM0PQDaF7f7GYpIOZtv7sxWvyp7+R4KLz7nK8Wbf4pKJrJByYXdmA2ty
         9BVlJe50lSlCe7GCuLYx9y9OGfYiUKn+bysbgAZGQLM02G3XnvpQVp3ysXnW5wdHK3dW
         bysP4z/YK9/nEq5p0Xq/WzgZeiflUTYCjbOwTiPwgpHGYboZrQhs+RLgn9G/hoEtXsOr
         50Vg==
X-Gm-Message-State: AO0yUKVYlGcLZRp/+kXrc12dTrMMuGIclDKmdlcQu6tHa4lQQTZi1vLy
        iMQ3SXdlkb0uHvzNec3+TGh8uCNO21mcgJ11GBD/G+L0SPKki0IwPU6VQ/zzctjxdjlL/G6dmAx
        VZQI7uAYkaBtjGyQENIX4lm8X14SYq6o/
X-Received: by 2002:a05:6808:4285:b0:383:fad3:d19 with SMTP id dq5-20020a056808428500b00383fad30d19mr548720oib.9.1678863926501;
        Wed, 15 Mar 2023 00:05:26 -0700 (PDT)
X-Google-Smtp-Source: AK7set/+rtGN0NeCS6hFSgOvllN0pfn+47+KEH4ofAgh/jjdRSoFwHB3Ounur3W0hk1J5lNoU4CBWNZ6kSN2nMR4WZc=
X-Received: by 2002:a05:6808:4285:b0:383:fad3:d19 with SMTP id
 dq5-20020a056808428500b00383fad30d19mr548714oib.9.1678863926277; Wed, 15 Mar
 2023 00:05:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com> <20230309013046.23523-3-shannon.nelson@amd.com>
In-Reply-To: <20230309013046.23523-3-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 15 Mar 2023 15:05:14 +0800
Message-ID: <CACGkMEumJLysw4Grd19fVF-LuUb+r201XWMaeCkT=kDqN41ZTg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 virtio 2/7] pds_vdpa: get vdpa management info
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 9:31=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> Find the vDPA management information from the DSC in order to
> advertise it to the vdpa subsystem.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vdpa/pds/Makefile    |   3 +-
>  drivers/vdpa/pds/aux_drv.c   |  13 ++++
>  drivers/vdpa/pds/aux_drv.h   |   7 +++
>  drivers/vdpa/pds/debugfs.c   |   3 +
>  drivers/vdpa/pds/vdpa_dev.c  | 113 +++++++++++++++++++++++++++++++++++
>  drivers/vdpa/pds/vdpa_dev.h  |  15 +++++
>  include/linux/pds/pds_vdpa.h |  92 ++++++++++++++++++++++++++++
>  7 files changed, 245 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/vdpa/pds/vdpa_dev.c
>  create mode 100644 drivers/vdpa/pds/vdpa_dev.h
>
> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> index a9cd2f450ae1..13b50394ec64 100644
> --- a/drivers/vdpa/pds/Makefile
> +++ b/drivers/vdpa/pds/Makefile
> @@ -3,6 +3,7 @@
>
>  obj-$(CONFIG_PDS_VDPA) :=3D pds_vdpa.o
>
> -pds_vdpa-y :=3D aux_drv.o
> +pds_vdpa-y :=3D aux_drv.o \
> +             vdpa_dev.o
>
>  pds_vdpa-$(CONFIG_DEBUG_FS) +=3D debugfs.o
> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> index b3f36170253c..63e40ae68211 100644
> --- a/drivers/vdpa/pds/aux_drv.c
> +++ b/drivers/vdpa/pds/aux_drv.c
> @@ -2,6 +2,8 @@
>  /* Copyright(c) 2023 Advanced Micro Devices, Inc */
>
>  #include <linux/auxiliary_bus.h>
> +#include <linux/pci.h>
> +#include <linux/vdpa.h>
>
>  #include <linux/pds/pds_core.h>
>  #include <linux/pds/pds_auxbus.h>
> @@ -9,6 +11,7 @@
>
>  #include "aux_drv.h"
>  #include "debugfs.h"
> +#include "vdpa_dev.h"
>
>  static const struct auxiliary_device_id pds_vdpa_id_table[] =3D {
>         { .name =3D PDS_VDPA_DEV_NAME, },
> @@ -30,6 +33,7 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_=
dev,
>                 return -ENOMEM;
>
>         vdpa_aux->padev =3D padev;
> +       vdpa_aux->vf_id =3D pci_iov_vf_id(padev->vf->pdev);
>         auxiliary_set_drvdata(aux_dev, vdpa_aux);
>
>         /* Register our PDS client with the pds_core */
> @@ -40,8 +44,15 @@ static int pds_vdpa_probe(struct auxiliary_device *aux=
_dev,
>                 goto err_free_mem;
>         }
>
> +       /* Get device ident info and set up the vdpa_mgmt_dev */
> +       err =3D pds_vdpa_get_mgmt_info(vdpa_aux);
> +       if (err)
> +               goto err_aux_unreg;
> +
>         return 0;
>
> +err_aux_unreg:
> +       padev->ops->unregister_client(padev);
>  err_free_mem:
>         kfree(vdpa_aux);
>         auxiliary_set_drvdata(aux_dev, NULL);
> @@ -54,6 +65,8 @@ static void pds_vdpa_remove(struct auxiliary_device *au=
x_dev)
>         struct pds_vdpa_aux *vdpa_aux =3D auxiliary_get_drvdata(aux_dev);
>         struct device *dev =3D &aux_dev->dev;
>
> +       pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
> +
>         vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
>
>         kfree(vdpa_aux);
> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
> index 14e465944dfd..94ba7abcaa43 100644
> --- a/drivers/vdpa/pds/aux_drv.h
> +++ b/drivers/vdpa/pds/aux_drv.h
> @@ -10,6 +10,13 @@
>  struct pds_vdpa_aux {
>         struct pds_auxiliary_dev *padev;
>
> +       struct vdpa_mgmt_dev vdpa_mdev;
> +
> +       struct pds_vdpa_ident ident;
> +
> +       int vf_id;
>         struct dentry *dentry;
> +
> +       int nintrs;
>  };
>  #endif /* _AUX_DRV_H_ */
> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
> index 3c163dc7b66f..7b7e90fd6578 100644
> --- a/drivers/vdpa/pds/debugfs.c
> +++ b/drivers/vdpa/pds/debugfs.c
> @@ -1,7 +1,10 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /* Copyright(c) 2023 Advanced Micro Devices, Inc */
>
> +#include <linux/vdpa.h>
> +
>  #include <linux/pds/pds_core.h>
> +#include <linux/pds/pds_vdpa.h>
>  #include <linux/pds/pds_auxbus.h>
>
>  #include "aux_drv.h"
> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
> new file mode 100644
> index 000000000000..bd840688503c
> --- /dev/null
> +++ b/drivers/vdpa/pds/vdpa_dev.c
> @@ -0,0 +1,113 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/pci.h>
> +#include <linux/vdpa.h>
> +#include <uapi/linux/vdpa.h>
> +
> +#include <linux/pds/pds_core.h>
> +#include <linux/pds/pds_adminq.h>
> +#include <linux/pds/pds_auxbus.h>
> +#include <linux/pds/pds_vdpa.h>
> +
> +#include "vdpa_dev.h"
> +#include "aux_drv.h"
> +
> +static struct virtio_device_id pds_vdpa_id_table[] =3D {
> +       {VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
> +       {0},
> +};
> +
> +static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name=
,
> +                           const struct vdpa_dev_set_config *add_config)
> +{
> +       return -EOPNOTSUPP;
> +}
> +
> +static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
> +                            struct vdpa_device *vdpa_dev)
> +{
> +}
> +
> +static const struct vdpa_mgmtdev_ops pds_vdpa_mgmt_dev_ops =3D {
> +       .dev_add =3D pds_vdpa_dev_add,
> +       .dev_del =3D pds_vdpa_dev_del
> +};
> +
> +int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux)
> +{
> +       struct pds_vdpa_ident_cmd ident_cmd =3D {
> +               .opcode =3D PDS_VDPA_CMD_IDENT,
> +               .vf_id =3D cpu_to_le16(vdpa_aux->vf_id),
> +       };
> +       struct pds_vdpa_comp ident_comp =3D {0};
> +       struct vdpa_mgmt_dev *mgmt;
> +       struct device *pf_dev;
> +       struct pci_dev *pdev;
> +       dma_addr_t ident_pa;
> +       struct device *dev;
> +       u16 max_vqs;
> +       int err;
> +
> +       dev =3D &vdpa_aux->padev->aux_dev.dev;
> +       pdev =3D vdpa_aux->padev->vf->pdev;
> +       mgmt =3D &vdpa_aux->vdpa_mdev;
> +
> +       /* Get resource info through the PF's adminq.  It is a block of i=
nfo,
> +        * so we need to map some memory for PF to make available to the
> +        * firmware for writing the data.
> +        */

It looks to me pds_vdpa_ident is not very large:

struct pds_vdpa_ident {
        __le64 hw_features;
        __le16 max_vqs;
        __le16 max_qlen;
        __le16 min_qlen;
};

Any reason it is not packed into some type of the comp structure of adminq?

Others look good.

Thanks

