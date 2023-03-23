Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518C76C5E81
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCWFKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjCWFKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:10:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBE821C7D7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679548181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uKdCu7vNslqhtw2OfVSVuzsOCZ/WGqeOgRhTWBaqCpU=;
        b=PySr+O0ds4INPkmGIIkR5ghQys3HrYZlKXNpAiRR/Oh7tTAXcEsqZm9rrOsgPHrKcmMVXF
        B2iB/VTr/p9+dRFmedYM3ThpX8azQ4LqWXLOZnMLQGejqiIEotyWUOUGxK/xza3lbxC7yN
        TKUz8HsQQJf/MMAVs8ylj5rANRE4IeQ=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-IHBwO9GYOTWePmuLWuyR8w-1; Thu, 23 Mar 2023 01:09:39 -0400
X-MC-Unique: IHBwO9GYOTWePmuLWuyR8w-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-176347f3b28so10892666fac.23
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679548178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uKdCu7vNslqhtw2OfVSVuzsOCZ/WGqeOgRhTWBaqCpU=;
        b=3WCxQYBTqGV5Ba5+i3syWlOxA0wB/HAbXU19dLUxLJcniIAygmkw25dX6APjFlEYKv
         SjGxjLPu00wx9BQJRZCZb7bz2E+fWxlutIMfJNKpDbhr5OH98ukh5IKdHpvkEMGThmta
         EjGDPn2qSKyuqRPBU1naCFRBFsc2Sw/3+Ab8GW/VRny0eGHeUfrtYedumr+KgsowfDFT
         DIUYzx4Pv8bz+twB2/I7C4n14Nt+nlE5aRx24R/yOvzbwBhuJwPyTpWclrkZUF+5N1/b
         MfDWtROgiJxoCOpozl0Y8vUMRCEmKbf+QI1C2Wdkerth1aoEfTJ3BMu2/hiOHU85lUAL
         wnlg==
X-Gm-Message-State: AO0yUKWzUi/lWDx6/O2wvoFik0JrhnC8dL/ScwbnHds/RPtYKgrN+h5+
        QW7AckdrdBzhNVFF3pdynDKw9AMUbRWuGLyCl5tmrqJQw4lNFzQxXENpIM2ILV2n8b9+BH9vmUK
        FvtmcMGNyFOTmPe4ze7glt/5ek0w0lRgS
X-Received: by 2002:a05:6808:5ca:b0:386:9bb5:a786 with SMTP id d10-20020a05680805ca00b003869bb5a786mr1739483oij.9.1679548178053;
        Wed, 22 Mar 2023 22:09:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set9YjbGWoOe+akeG0iz8g3eCSGDwzzWeoAj7uBBbaFDyDcMzLpQqiuH9VUBNsv2Ec5+92Qto+k6QDb/LewPhfZ0=
X-Received: by 2002:a05:6808:5ca:b0:386:9bb5:a786 with SMTP id
 d10-20020a05680805ca00b003869bb5a786mr1739481oij.9.1679548177771; Wed, 22 Mar
 2023 22:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230322191038.44037-1-shannon.nelson@amd.com> <20230322191038.44037-4-shannon.nelson@amd.com>
In-Reply-To: <20230322191038.44037-4-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 13:09:26 +0800
Message-ID: <CACGkMEuvuD8DJrs4TH8FzRuU+EvC3Wz1T8g=RhkP6VNPCh5JFQ@mail.gmail.com>
Subject: Re: [PATCH v3 virtio 3/8] pds_vdpa: get vdpa management info
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
> Find the vDPA management information from the DSC in order to
> advertise it to the vdpa subsystem.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/pds/Makefile    |   3 +-
>  drivers/vdpa/pds/aux_drv.c   |  17 ++++++
>  drivers/vdpa/pds/aux_drv.h   |   7 +++
>  drivers/vdpa/pds/debugfs.c   |   2 +
>  drivers/vdpa/pds/vdpa_dev.c  | 114 +++++++++++++++++++++++++++++++++++
>  drivers/vdpa/pds/vdpa_dev.h  |  15 +++++
>  include/linux/pds/pds_vdpa.h |  90 +++++++++++++++++++++++++++
>  7 files changed, 247 insertions(+), 1 deletion(-)
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
> index 39c03f067b77..881acd869a9d 100644
> --- a/drivers/vdpa/pds/aux_drv.c
> +++ b/drivers/vdpa/pds/aux_drv.c
> @@ -3,6 +3,7 @@
>
>  #include <linux/auxiliary_bus.h>
>  #include <linux/pci.h>
> +#include <linux/vdpa.h>
>
>  #include <linux/pds/pds_common.h>
>  #include <linux/pds/pds_core_if.h>
> @@ -12,6 +13,7 @@
>
>  #include "aux_drv.h"
>  #include "debugfs.h"
> +#include "vdpa_dev.h"
>
>  static const struct auxiliary_device_id pds_vdpa_id_table[] =3D {
>         { .name =3D PDS_VDPA_DEV_NAME, },
> @@ -25,15 +27,28 @@ static int pds_vdpa_probe(struct auxiliary_device *au=
x_dev,
>         struct pds_auxiliary_dev *padev =3D
>                 container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
>         struct pds_vdpa_aux *vdpa_aux;
> +       int err;
>
>         vdpa_aux =3D kzalloc(sizeof(*vdpa_aux), GFP_KERNEL);
>         if (!vdpa_aux)
>                 return -ENOMEM;
>
>         vdpa_aux->padev =3D padev;
> +       vdpa_aux->vf_id =3D pci_iov_vf_id(padev->vf_pdev);
>         auxiliary_set_drvdata(aux_dev, vdpa_aux);
>
> +       /* Get device ident info and set up the vdpa_mgmt_dev */
> +       err =3D pds_vdpa_get_mgmt_info(vdpa_aux);
> +       if (err)
> +               goto err_free_mem;
> +
>         return 0;
> +
> +err_free_mem:
> +       kfree(vdpa_aux);
> +       auxiliary_set_drvdata(aux_dev, NULL);
> +
> +       return err;
>  }
>
>  static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
> @@ -41,6 +56,8 @@ static void pds_vdpa_remove(struct auxiliary_device *au=
x_dev)
>         struct pds_vdpa_aux *vdpa_aux =3D auxiliary_get_drvdata(aux_dev);
>         struct device *dev =3D &aux_dev->dev;
>
> +       pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
> +
>         kfree(vdpa_aux);
>         auxiliary_set_drvdata(aux_dev, NULL);
>
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
> index 12e844f96ccc..f4275fe667c3 100644
> --- a/drivers/vdpa/pds/debugfs.c
> +++ b/drivers/vdpa/pds/debugfs.c
> @@ -2,10 +2,12 @@
>  /* Copyright(c) 2023 Advanced Micro Devices, Inc */
>
>  #include <linux/pci.h>
> +#include <linux/vdpa.h>
>
>  #include <linux/pds/pds_common.h>
>  #include <linux/pds/pds_core_if.h>
>  #include <linux/pds/pds_adminq.h>
> +#include <linux/pds/pds_vdpa.h>
>  #include <linux/pds/pds_auxbus.h>
>
>  #include "aux_drv.h"
> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
> new file mode 100644
> index 000000000000..6345b3fa2440
> --- /dev/null
> +++ b/drivers/vdpa/pds/vdpa_dev.c
> @@ -0,0 +1,114 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/pci.h>
> +#include <linux/vdpa.h>
> +#include <uapi/linux/vdpa.h>
> +
> +#include <linux/pds/pds_common.h>
> +#include <linux/pds/pds_core_if.h>
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
> +       pdev =3D vdpa_aux->padev->vf_pdev;
> +       mgmt =3D &vdpa_aux->vdpa_mdev;
> +
> +       /* Get resource info through the PF's adminq.  It is a block of i=
nfo,
> +        * so we need to map some memory for PF to make available to the
> +        * firmware for writing the data.
> +        */
> +       pf_dev =3D &vdpa_aux->padev->pf_pdev->dev;
> +       ident_pa =3D dma_map_single(pf_dev, &vdpa_aux->ident,
> +                                 sizeof(vdpa_aux->ident), DMA_FROM_DEVIC=
E);
> +       if (dma_mapping_error(pf_dev, ident_pa)) {
> +               dev_err(dev, "Failed to map ident space\n");
> +               return -ENOMEM;
> +       }
> +
> +       ident_cmd.ident_pa =3D cpu_to_le64(ident_pa);
> +       ident_cmd.len =3D cpu_to_le32(sizeof(vdpa_aux->ident));
> +       err =3D vdpa_aux->padev->ops->adminq_cmd(vdpa_aux->padev,
> +                                              (union pds_core_adminq_cmd=
 *)&ident_cmd,
> +                                              sizeof(ident_cmd),
> +                                              (union pds_core_adminq_com=
p *)&ident_comp,
> +                                              0);
> +       dma_unmap_single(pf_dev, ident_pa,
> +                        sizeof(vdpa_aux->ident), DMA_FROM_DEVICE);
> +       if (err) {
> +               dev_err(dev, "Failed to ident hw, status %d: %pe\n",
> +                       ident_comp.status, ERR_PTR(err));
> +               return err;
> +       }
> +
> +       max_vqs =3D le16_to_cpu(vdpa_aux->ident.max_vqs);
> +       mgmt->max_supported_vqs =3D min_t(u16, PDS_VDPA_MAX_QUEUES, max_v=
qs);
> +       if (max_vqs > PDS_VDPA_MAX_QUEUES)
> +               dev_info(dev, "FYI - Device supports more vqs (%d) than d=
river (%d)\n",
> +                        max_vqs, PDS_VDPA_MAX_QUEUES);
> +
> +       mgmt->ops =3D &pds_vdpa_mgmt_dev_ops;
> +       mgmt->id_table =3D pds_vdpa_id_table;
> +       mgmt->device =3D dev;
> +       mgmt->supported_features =3D le64_to_cpu(vdpa_aux->ident.hw_featu=
res);
> +       mgmt->config_attr_mask =3D BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)=
;
> +       mgmt->config_attr_mask |=3D BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MAX_VQP=
);
> +
> +       /* Set up interrupts now that we know how many we might want
> +        * each gets one, than add another for a control queue if support=
ed
> +        */
> +       vdpa_aux->nintrs =3D mgmt->max_supported_vqs;
> +       if (mgmt->supported_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
> +               vdpa_aux->nintrs++;
> +
> +       err =3D pci_alloc_irq_vectors(pdev, vdpa_aux->nintrs, vdpa_aux->n=
intrs,
> +                                   PCI_IRQ_MSIX);
> +       if (err < 0) {
> +               dev_err(dev, "Couldn't get %d msix vectors: %pe\n",
> +                       vdpa_aux->nintrs, ERR_PTR(err));
> +               return err;
> +       }
> +       vdpa_aux->nintrs =3D err;
> +
> +       return 0;
> +}
> diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
> new file mode 100644
> index 000000000000..97fab833a0aa
> --- /dev/null
> +++ b/drivers/vdpa/pds/vdpa_dev.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#ifndef _VDPA_DEV_H_
> +#define _VDPA_DEV_H_
> +
> +#define PDS_VDPA_MAX_QUEUES    65
> +
> +struct pds_vdpa_device {
> +       struct vdpa_device vdpa_dev;
> +       struct pds_vdpa_aux *vdpa_aux;
> +};
> +
> +int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
> +#endif /* _VDPA_DEV_H_ */
> diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
> index d3414536985d..c1d6a3fe2d61 100644
> --- a/include/linux/pds/pds_vdpa.h
> +++ b/include/linux/pds/pds_vdpa.h
> @@ -7,4 +7,94 @@
>  #define PDS_DEV_TYPE_VDPA_STR  "vDPA"
>  #define PDS_VDPA_DEV_NAME      PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_S=
TR
>
> +/*
> + * enum pds_vdpa_cmd_opcode - vDPA Device commands
> + */
> +enum pds_vdpa_cmd_opcode {
> +       PDS_VDPA_CMD_INIT               =3D 48,
> +       PDS_VDPA_CMD_IDENT              =3D 49,
> +       PDS_VDPA_CMD_RESET              =3D 51,
> +       PDS_VDPA_CMD_VQ_RESET           =3D 52,
> +       PDS_VDPA_CMD_VQ_INIT            =3D 53,
> +       PDS_VDPA_CMD_STATUS_UPDATE      =3D 54,
> +       PDS_VDPA_CMD_SET_FEATURES       =3D 55,
> +       PDS_VDPA_CMD_SET_ATTR           =3D 56,
> +       PDS_VDPA_CMD_VQ_SET_STATE       =3D 57,
> +       PDS_VDPA_CMD_VQ_GET_STATE       =3D 58,
> +};
> +
> +/**
> + * struct pds_vdpa_cmd - generic command
> + * @opcode:    Opcode
> + * @vdpa_index:        Index for vdpa subdevice
> + * @vf_id:     VF id
> + */
> +struct pds_vdpa_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +};
> +
> +/**
> + * struct pds_vdpa_comp - generic command completion
> + * @status:    Status of the command (enum pds_core_status_code)
> + * @rsvd:      Word boundary padding
> + * @color:     Color bit
> + */
> +struct pds_vdpa_comp {
> +       u8 status;
> +       u8 rsvd[14];
> +       u8 color;
> +};
> +
> +/**
> + * struct pds_vdpa_init_cmd - INIT command
> + * @opcode:    Opcode PDS_VDPA_CMD_INIT
> + * @vdpa_index: Index for vdpa subdevice
> + * @vf_id:     VF id
> + * @len:       length of config info DMA space
> + * @config_pa: address for DMA of virtio config struct
> + */
> +struct pds_vdpa_init_cmd {
> +       u8     opcode;
> +       u8     vdpa_index;
> +       __le16 vf_id;
> +};
> +
> +/**
> + * struct pds_vdpa_ident - vDPA identification data
> + * @hw_features:       vDPA features supported by device
> + * @max_vqs:           max queues available (2 queues for a single queue=
pair)
> + * @max_qlen:          log(2) of maximum number of descriptors
> + * @min_qlen:          log(2) of minimum number of descriptors
> + *
> + * This struct is used in a DMA block that is set up for the PDS_VDPA_CM=
D_IDENT
> + * transaction.  Set up the DMA block and send the address in the IDENT =
cmd
> + * data, the DSC will write the ident information, then we can remove th=
e DMA
> + * block after reading the answer.  If the completion status is 0, then =
there
> + * is valid information, else there was an error and the data should be =
invalid.
> + */
> +struct pds_vdpa_ident {
> +       __le64 hw_features;
> +       __le16 max_vqs;
> +       __le16 max_qlen;
> +       __le16 min_qlen;
> +};
> +
> +/**
> + * struct pds_vdpa_ident_cmd - IDENT command
> + * @opcode:    Opcode PDS_VDPA_CMD_IDENT
> + * @rsvd:       Word boundary padding
> + * @vf_id:     VF id
> + * @len:       length of ident info DMA space
> + * @ident_pa:  address for DMA of ident info (struct pds_vdpa_ident)
> + *                     only used for this transaction, then forgotten by=
 DSC
> + */
> +struct pds_vdpa_ident_cmd {
> +       u8     opcode;
> +       u8     rsvd;
> +       __le16 vf_id;
> +       __le32 len;
> +       __le64 ident_pa;
> +};
>  #endif /* _PDS_VDPA_H_ */
> --
> 2.17.1
>

