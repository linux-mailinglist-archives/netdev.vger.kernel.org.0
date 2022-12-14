Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094AE64C3F2
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbiLNGo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbiLNGo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:44:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F129313FA1
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671000219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=06F13PV1Q+XbE2r7Hpn9vfYTLhRt3eqVckyiLWxuKf0=;
        b=ioebwZSsLFa4qI7FbjiLIHJg2+k+wVnFBqMdTCxv/kL7SbP7Awodu9DMjVYQDNoIEBl1AK
        1sYUvkHvfcSQdF3bI7W6sXghO+GZFdwFKcTDebIztd7NsZdmW3cvzr0+/at5lNVWCEbUKz
        8iSEF+vpDdXkyFu65JesIxc1c9Y1wSU=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-519-1e8XMEzkOJ2kF6mniRqvEQ-1; Wed, 14 Dec 2022 01:43:38 -0500
X-MC-Unique: 1e8XMEzkOJ2kF6mniRqvEQ-1
Received: by mail-oo1-f70.google.com with SMTP id f11-20020a4a920b000000b004a09a9f7095so6085392ooh.10
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:43:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=06F13PV1Q+XbE2r7Hpn9vfYTLhRt3eqVckyiLWxuKf0=;
        b=CkSaQ+C2syMqq4T1097un55Q1tRV0VLjBbpu00yStK8a6h1ZjYJD+eVLO3H2VYZUj5
         Fsgg4zw3bsgQZpk7ZA//FZoN+uhRD44R3u9n2/TEFx5EG/EdbFT/BDfimWLjMtlhFu2+
         0kVRwJ6gu16JeqFI6LFotfj+K/IsJly3oTvBwwijU9JHReCAMTAlYfpUXjZaJCD3OaIi
         qPn0/l1oU7ZKaI8lSA2hQu0WwgSAADD0dasp9KMTGp1BOv6qPlHoDzKV+5hOdSfEDLtn
         jliw9p0OKA4KGYDgDH1FISwjCRrSS5anaVzquTrd5xWz2DV6gFmYN9qnZKtvFDtywaqw
         K9zA==
X-Gm-Message-State: AFqh2kr6IsbwS8Pyi0eBR+iybRLnpKegnPtqbHd7aivtu5MHBh0ePo3/
        pioeqbi0j5Sj6o+kuOU2faEpsznKX3yfDSME5t5jndmCZU0soGFWReYXu5qsMkpVmQh2vE+Cy63
        ot+ptAzDblCaqSBOqYasNep0kOHfnmXBw
X-Received: by 2002:a05:6870:41c7:b0:144:a97b:1ae2 with SMTP id z7-20020a05687041c700b00144a97b1ae2mr107555oac.35.1671000217792;
        Tue, 13 Dec 2022 22:43:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv2vx3PItL1UAKiWzao7A90W2aYUgSozsuN2pc57Lnlp6tdYbaZUhK97+VFCCqDi1K8qx+ZEzOvTne9/uG8Dp8=
X-Received: by 2002:a05:6870:41c7:b0:144:a97b:1ae2 with SMTP id
 z7-20020a05687041c700b00144a97b1ae2mr107552oac.35.1671000217405; Tue, 13 Dec
 2022 22:43:37 -0800 (PST)
MIME-Version: 1.0
References: <20221207145428.31544-1-gautam.dawar@amd.com> <20221207145428.31544-3-gautam.dawar@amd.com>
In-Reply-To: <20221207145428.31544-3-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 14 Dec 2022 14:43:26 +0800
Message-ID: <CACGkMEuEJ9+wkFSiwUFGUi4RuQyJe2mc4fCNTwMw=S4SsSboiQ@mail.gmail.com>
Subject: Re: [PATCH net-next 02/11] sfc: implement MCDI interface for vDPA operations
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, netdev@vger.kernel.org,
        eperezma@redhat.com, tanuj.kamde@amd.com, Koushik.Dutta@amd.com,
        harpreet.anand@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 10:56 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>
> Implement functions to perform vDPA operations like creating and
> removing virtqueues, getting doorbell register offset etc. using
> the MCDI interface with FW.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/Kconfig      |   8 +
>  drivers/net/ethernet/sfc/Makefile     |   1 +
>  drivers/net/ethernet/sfc/ef100_vdpa.h |  32 +++
>  drivers/net/ethernet/sfc/mcdi.h       |   4 +
>  drivers/net/ethernet/sfc/mcdi_vdpa.c  | 268 ++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/mcdi_vdpa.h  |  84 ++++++++
>  6 files changed, 397 insertions(+)
>  create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
>  create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
>  create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h
>
> diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
> index 0950e6b0508f..1fa626c87d36 100644
> --- a/drivers/net/ethernet/sfc/Kconfig
> +++ b/drivers/net/ethernet/sfc/Kconfig
> @@ -63,6 +63,14 @@ config SFC_MCDI_LOGGING
>           Driver-Interface) commands and responses, allowing debugging of
>           driver/firmware interaction.  The tracing is actually enabled by
>           a sysfs file 'mcdi_logging' under the PCI device.
> +config SFC_VDPA
> +       bool "Solarflare EF100-family VDPA support"
> +       depends on SFC && VDPA && SFC_SRIOV
> +       default y
> +       help
> +         This enables support for the virtio data path acceleration (vDPA).
> +         vDPA device's datapath complies with the virtio specification,
> +         but control path is vendor specific.
>
>  source "drivers/net/ethernet/sfc/falcon/Kconfig"
>  source "drivers/net/ethernet/sfc/siena/Kconfig"
> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
> index 712a48d00069..059a0944e89a 100644
> --- a/drivers/net/ethernet/sfc/Makefile
> +++ b/drivers/net/ethernet/sfc/Makefile
> @@ -11,6 +11,7 @@ sfc-$(CONFIG_SFC_MTD) += mtd.o
>  sfc-$(CONFIG_SFC_SRIOV)        += sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>                             mae.o tc.o tc_bindings.o tc_counters.o
>
> +sfc-$(CONFIG_SFC_VDPA) += mcdi_vdpa.o
>  obj-$(CONFIG_SFC)      += sfc.o
>
>  obj-$(CONFIG_SFC_FALCON) += falcon/
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> new file mode 100644
> index 000000000000..f6564448d0c7
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Driver for Xilinx network controllers and boards
> + * Copyright (C) 2020-2022, Xilinx, Inc.
> + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#ifndef __EF100_VDPA_H__
> +#define __EF100_VDPA_H__
> +
> +#include <linux/vdpa.h>
> +#include <uapi/linux/virtio_net.h>
> +#include "net_driver.h"
> +#include "ef100_nic.h"
> +
> +#if defined(CONFIG_SFC_VDPA)
> +
> +enum ef100_vdpa_device_type {
> +       EF100_VDPA_DEVICE_TYPE_NET,
> +};
> +
> +enum ef100_vdpa_vq_type {
> +       EF100_VDPA_VQ_TYPE_NET_RXQ,
> +       EF100_VDPA_VQ_TYPE_NET_TXQ,
> +       EF100_VDPA_VQ_NTYPES
> +};
> +
> +#endif /* CONFIG_SFC_VDPA */
> +#endif /* __EF100_VDPA_H__ */
> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> index 7e35fec9da35..db4ca4975ada 100644
> --- a/drivers/net/ethernet/sfc/mcdi.h
> +++ b/drivers/net/ethernet/sfc/mcdi.h
> @@ -214,6 +214,10 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
>  #define _MCDI_STRUCT_DWORD(_buf, _field)                               \
>         ((_buf) + (_MCDI_CHECK_ALIGN(_field ## _OFST, 4) >> 2))
>
> +#define MCDI_SET_BYTE(_buf, _field, _value) do {                       \
> +       BUILD_BUG_ON(MC_CMD_ ## _field ## _LEN != 1);                   \
> +       *(u8 *)MCDI_PTR(_buf, _field) = _value;                         \
> +       } while (0)
>  #define MCDI_STRUCT_SET_BYTE(_buf, _field, _value) do {                        \
>         BUILD_BUG_ON(_field ## _LEN != 1);                              \
>         *(u8 *)MCDI_STRUCT_PTR(_buf, _field) = _value;                  \
> diff --git a/drivers/net/ethernet/sfc/mcdi_vdpa.c b/drivers/net/ethernet/sfc/mcdi_vdpa.c
> new file mode 100644
> index 000000000000..35f822170049
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/mcdi_vdpa.c
> @@ -0,0 +1,268 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Driver for Xilinx network controllers and boards
> + * Copyright (C) 2020-2022, Xilinx, Inc.
> + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#include <linux/vdpa.h>
> +#include "ef100_vdpa.h"
> +#include "efx.h"
> +#include "nic.h"
> +#include "mcdi_vdpa.h"
> +#include "mcdi_pcol.h"
> +
> +/* The value of target_vf in virtio MC commands like
> + * virtqueue create, delete and get doorbell offset should
> + * contain the VF index when the calling function is a PF
> + * and VF_NULL (0xFFFF) otherwise. As the vDPA driver invokes
> + * MC commands in context of the VF, it uses VF_NULL.
> + */
> +#define MC_CMD_VIRTIO_TARGET_VF_NULL 0xFFFF
> +
> +struct efx_vring_ctx *efx_vdpa_vring_init(struct efx_nic *efx,  u32 vi,
> +                                         enum ef100_vdpa_vq_type vring_type)
> +{
> +       struct efx_vring_ctx *vring_ctx;
> +       u32 queue_cmd;
> +
> +       vring_ctx = kzalloc(sizeof(*vring_ctx), GFP_KERNEL);
> +       if (!vring_ctx)
> +               return ERR_PTR(-ENOMEM);
> +
> +       switch (vring_type) {
> +       case EF100_VDPA_VQ_TYPE_NET_RXQ:
> +               queue_cmd = MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ;
> +               break;
> +       case EF100_VDPA_VQ_TYPE_NET_TXQ:
> +               queue_cmd = MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_TXQ;
> +               break;
> +       default:
> +               pci_err(efx->pci_dev,
> +                       "%s: Invalid Queue type %u\n", __func__, vring_type);
> +               kfree(vring_ctx);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +
> +       vring_ctx->efx = efx;
> +       vring_ctx->vf_index = MC_CMD_VIRTIO_TARGET_VF_NULL;
> +       vring_ctx->vi_index = vi;
> +       vring_ctx->mcdi_vring_type = queue_cmd;
> +       return vring_ctx;
> +}
> +
> +void efx_vdpa_vring_fini(struct efx_vring_ctx *vring_ctx)
> +{
> +       kfree(vring_ctx);
> +}
> +
> +int efx_vdpa_get_features(struct efx_nic *efx,
> +                         enum ef100_vdpa_device_type type,
> +                         u64 *features)
> +{
> +       MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_GET_FEATURES_OUT_LEN);
> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_GET_FEATURES_IN_LEN);
> +       u32 high_val, low_val;
> +       ssize_t outlen;
> +       u32 dev_type;
> +       int rc;
> +
> +       if (!efx) {
> +               pci_err(efx->pci_dev, "%s: Invalid NIC pointer\n", __func__);
> +               return -EINVAL;
> +       }
> +       switch (type) {
> +       case EF100_VDPA_DEVICE_TYPE_NET:
> +               dev_type = MC_CMD_VIRTIO_GET_FEATURES_IN_NET;
> +               break;
> +       default:
> +               pci_err(efx->pci_dev,
> +                       "%s: Device type %d not supported\n", __func__, type);
> +               return -EINVAL;
> +       }
> +       MCDI_SET_DWORD(inbuf, VIRTIO_GET_FEATURES_IN_DEVICE_ID, dev_type);
> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_GET_FEATURES, inbuf, sizeof(inbuf),
> +                         outbuf, sizeof(outbuf), &outlen);
> +       if (rc)
> +               return rc;
> +       if (outlen < MC_CMD_VIRTIO_GET_FEATURES_OUT_LEN)
> +               return -EIO;
> +       low_val = MCDI_DWORD(outbuf, VIRTIO_GET_FEATURES_OUT_FEATURES_LO);
> +       high_val = MCDI_DWORD(outbuf, VIRTIO_GET_FEATURES_OUT_FEATURES_HI);
> +       *features = ((u64)high_val << 32) | low_val;
> +       return 0;
> +}
> +
> +int efx_vdpa_verify_features(struct efx_nic *efx,
> +                            enum ef100_vdpa_device_type type, u64 features)
> +{
> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_TEST_FEATURES_IN_LEN);
> +       u32 dev_type;
> +       int rc;
> +
> +       BUILD_BUG_ON(MC_CMD_VIRTIO_TEST_FEATURES_OUT_LEN != 0);
> +       switch (type) {
> +       case EF100_VDPA_DEVICE_TYPE_NET:
> +               dev_type = MC_CMD_VIRTIO_GET_FEATURES_IN_NET;
> +               break;
> +       default:
> +               pci_err(efx->pci_dev,
> +                       "%s: Device type %d not supported\n", __func__, type);
> +               return -EINVAL;
> +       }
> +       MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_DEVICE_ID, dev_type);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_FEATURES_LO, features);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_TEST_FEATURES_IN_FEATURES_HI,
> +                      features >> 32);
> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_TEST_FEATURES, inbuf,
> +                         sizeof(inbuf), NULL, 0, NULL);
> +       return rc;
> +}
> +
> +int efx_vdpa_vring_create(struct efx_vring_ctx *vring_ctx,
> +                         struct efx_vring_cfg *vring_cfg,
> +                         struct efx_vring_dyn_cfg *vring_dyn_cfg)
> +{
> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_INIT_QUEUE_REQ_LEN);
> +       struct efx_nic *efx = vring_ctx->efx;
> +       int rc;
> +
> +       BUILD_BUG_ON(MC_CMD_VIRTIO_INIT_QUEUE_RESP_LEN != 0);
> +
> +       MCDI_SET_BYTE(inbuf, VIRTIO_INIT_QUEUE_REQ_QUEUE_TYPE,
> +                     vring_ctx->mcdi_vring_type);
> +       MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_TARGET_VF,
> +                     vring_ctx->vf_index);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INSTANCE,
> +                      vring_ctx->vi_index);
> +
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_SIZE, vring_cfg->size);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_LO,
> +                      vring_cfg->desc);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_DESC_TBL_ADDR_HI,
> +                      vring_cfg->desc >> 32);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_LO,
> +                      vring_cfg->avail);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_AVAIL_RING_ADDR_HI,
> +                      vring_cfg->avail >> 32);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_LO,
> +                      vring_cfg->used);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_USED_RING_ADDR_HI,
> +                      vring_cfg->used >> 32);
> +       MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_MSIX_VECTOR,
> +                     vring_cfg->msix_vector);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_FEATURES_LO,
> +                      vring_cfg->features);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_FEATURES_HI,
> +                      vring_cfg->features >> 32);
> +
> +       if (vring_dyn_cfg) {
> +               MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INITIAL_PIDX,
> +                              vring_dyn_cfg->avail_idx);
> +               MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INITIAL_CIDX,
> +                              vring_dyn_cfg->used_idx);
> +       }
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_MPORT_SELECTOR,
> +                      MAE_MPORT_SELECTOR_ASSIGNED);
> +
> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_INIT_QUEUE, inbuf, sizeof(inbuf),
> +                         NULL, 0, NULL);

It looks to me the mcdi_buffer belongs to the VF (allocated by the
calling of ef100_probe_vf()), I wonder how it is isolated from the DMA
that is initiated by userspace(guest)?

Thanks


> +       return rc;
> +}
> +
> +int efx_vdpa_vring_destroy(struct efx_vring_ctx *vring_ctx,
> +                          struct efx_vring_dyn_cfg *vring_dyn_cfg)
> +{
> +       MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_FINI_QUEUE_RESP_LEN);
> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_FINI_QUEUE_REQ_LEN);
> +       struct efx_nic *efx = vring_ctx->efx;
> +       ssize_t outlen;
> +       int rc;
> +
> +       MCDI_SET_BYTE(inbuf, VIRTIO_FINI_QUEUE_REQ_QUEUE_TYPE,
> +                     vring_ctx->mcdi_vring_type);
> +       MCDI_SET_WORD(inbuf, VIRTIO_INIT_QUEUE_REQ_TARGET_VF,
> +                     vring_ctx->vf_index);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_INIT_QUEUE_REQ_INSTANCE,
> +                      vring_ctx->vi_index);
> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_FINI_QUEUE, inbuf, sizeof(inbuf),
> +                         outbuf, sizeof(outbuf), &outlen);
> +
> +       if (rc)
> +               return rc;
> +
> +       if (outlen < MC_CMD_VIRTIO_FINI_QUEUE_RESP_LEN)
> +               return -EIO;
> +
> +       if (vring_dyn_cfg) {
> +               vring_dyn_cfg->avail_idx = MCDI_DWORD(outbuf,
> +                                                     VIRTIO_FINI_QUEUE_RESP_FINAL_PIDX);
> +               vring_dyn_cfg->used_idx = MCDI_DWORD(outbuf,
> +                                                    VIRTIO_FINI_QUEUE_RESP_FINAL_CIDX);
> +       }
> +
> +       return 0;
> +}
> +
> +int efx_vdpa_get_doorbell_offset(struct efx_vring_ctx *vring_ctx,
> +                                u32 *offset)
> +{
> +       MCDI_DECLARE_BUF(outbuf, MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_LEN);
> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_VIRTIO_GET_DOORBELL_OFFSET_REQ_LEN);
> +       struct efx_nic *efx = vring_ctx->efx;
> +       ssize_t outlen;
> +       int rc;
> +
> +       if (vring_ctx->mcdi_vring_type != MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ &&
> +           vring_ctx->mcdi_vring_type != MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_TXQ) {
> +               pci_err(efx->pci_dev,
> +                       "%s: Invalid Queue type %u\n",
> +                       __func__, vring_ctx->mcdi_vring_type);
> +               return -EINVAL;
> +       }
> +
> +       MCDI_SET_BYTE(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_DEVICE_ID,
> +                     MC_CMD_VIRTIO_GET_FEATURES_IN_NET);
> +       MCDI_SET_WORD(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_TARGET_VF,
> +                     vring_ctx->vf_index);
> +       MCDI_SET_DWORD(inbuf, VIRTIO_GET_DOORBELL_OFFSET_REQ_INSTANCE,
> +                      vring_ctx->vi_index);
> +
> +       rc = efx_mcdi_rpc(efx, MC_CMD_VIRTIO_GET_DOORBELL_OFFSET, inbuf,
> +                         sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
> +       if (rc)
> +               return rc;
> +
> +       if (outlen < MC_CMD_VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_LEN)
> +               return -EIO;
> +       if (vring_ctx->mcdi_vring_type == MC_CMD_VIRTIO_INIT_QUEUE_REQ_NET_RXQ)
> +               *offset = MCDI_DWORD(outbuf,
> +                                    VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_RX_DBL_OFFSET);
> +       else
> +               *offset = MCDI_DWORD(outbuf,
> +                                    VIRTIO_GET_NET_DOORBELL_OFFSET_RESP_TX_DBL_OFFSET);
> +
> +       return 0;
> +}
> +
> +int efx_vdpa_get_mtu(struct efx_nic *efx, u16 *mtu)
> +{
> +       MCDI_DECLARE_BUF(outbuf, MC_CMD_SET_MAC_V2_OUT_LEN);
> +       MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_MAC_EXT_IN_LEN);
> +       ssize_t outlen;
> +       int rc;
> +
> +       MCDI_SET_DWORD(inbuf, SET_MAC_EXT_IN_CONTROL, 0);
> +       rc =  efx_mcdi_rpc(efx, MC_CMD_SET_MAC, inbuf, sizeof(inbuf),
> +                          outbuf, sizeof(outbuf), &outlen);
> +       if (rc)
> +               return rc;
> +       if (outlen < MC_CMD_SET_MAC_V2_OUT_LEN)
> +               return -EIO;
> +
> +       *mtu = MCDI_DWORD(outbuf, SET_MAC_V2_OUT_MTU);
> +       return 0;
> +}
> diff --git a/drivers/net/ethernet/sfc/mcdi_vdpa.h b/drivers/net/ethernet/sfc/mcdi_vdpa.h
> new file mode 100644
> index 000000000000..2a0f7c647c44
> --- /dev/null
> +++ b/drivers/net/ethernet/sfc/mcdi_vdpa.h
> @@ -0,0 +1,84 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Driver for Xilinx network controllers and boards
> + * Copyright (C) 2020-2022, Xilinx, Inc.
> + * Copyright (C) 2022, Advanced Micro Devices, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation, incorporated herein by reference.
> + */
> +
> +#ifndef EFX_MCDI_VDPA_H
> +#define EFX_MCDI_VDPA_H
> +
> +#if defined(CONFIG_SFC_VDPA)
> +#include "mcdi.h"
> +
> +/**
> + * struct efx_vring_ctx: The vring context
> + *
> + * @efx: pointer of the VF's efx_nic object
> + * @vf_index: VF index of the vDPA VF
> + * @vi_index: vi index to be used for queue creation
> + * @mcdi_vring_type: corresponding MCDI vring type
> + */
> +struct efx_vring_ctx {
> +       struct efx_nic *efx;
> +       u32 vf_index;
> +       u32 vi_index;
> +       u32 mcdi_vring_type;
> +};
> +
> +/**
> + * struct efx_vring_cfg: Configuration for vring creation
> + *
> + * @desc: Descriptor area address of the vring
> + * @avail: Available area address of the vring
> + * @used: Device area address of the vring
> + * @size: Queue size, in entries. Must be a power of two
> + * @msix_vector: msix vector address for the queue
> + * @features: negotiated feature bits
> + */
> +struct efx_vring_cfg {
> +       u64 desc;
> +       u64 avail;
> +       u64 used;
> +       u32 size;
> +       u16 msix_vector;
> +       u64 features;
> +};
> +
> +/**
> + * struct efx_vring_dyn_cfg - dynamic vring configuration
> + *
> + * @avail_idx: last available index of the vring
> + * @used_idx: last used index of the vring
> + */
> +struct efx_vring_dyn_cfg {
> +       u32 avail_idx;
> +       u32 used_idx;
> +};
> +
> +int efx_vdpa_get_features(struct efx_nic *efx, enum ef100_vdpa_device_type type,
> +                         u64 *featuresp);
> +
> +int efx_vdpa_verify_features(struct efx_nic *efx,
> +                            enum ef100_vdpa_device_type type, u64 features);
> +
> +struct efx_vring_ctx *efx_vdpa_vring_init(struct efx_nic *efx, u32 vi,
> +                                         enum ef100_vdpa_vq_type vring_type);
> +
> +void efx_vdpa_vring_fini(struct efx_vring_ctx *vring_ctx);
> +
> +int efx_vdpa_vring_create(struct efx_vring_ctx *vring_ctx,
> +                         struct efx_vring_cfg *vring_cfg,
> +                         struct efx_vring_dyn_cfg *vring_dyn_cfg);
> +
> +int efx_vdpa_vring_destroy(struct efx_vring_ctx *vring_ctx,
> +                          struct efx_vring_dyn_cfg *vring_dyn_cfg);
> +
> +int efx_vdpa_get_doorbell_offset(struct efx_vring_ctx *vring_ctx,
> +                                u32 *offsetp);
> +int efx_vdpa_get_mtu(struct efx_nic *efx, u16 *mtu);
> +#endif
> +#endif
> --
> 2.30.1
>

