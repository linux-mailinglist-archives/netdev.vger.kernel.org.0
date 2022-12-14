Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D272F64C406
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbiLNGra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbiLNGrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:47:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3E727DD9
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671000382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MWnsyB5sxeFYntkt0vIRWfG8T8fsCpIgSxnBoT/BNFI=;
        b=hgEB4BhmvcXU/T1nRrQFGPcLBVnatx7Q5zSsOM0uBfgLEW1MmcA+DW2KJxLL/Fo3XZLcxQ
        hoIWprjx0u9fdkjX2ILokI7wCKL6KXqHkCBDmCDvKyn/H1OdT96pxxVfYQTVMvZLeIwgLc
        rP+W2cMj/eZwkGO+klLp5bFM0CsGvR8=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-364-TwmrJfX5PTGb3HO4yOwkcQ-1; Wed, 14 Dec 2022 01:46:21 -0500
X-MC-Unique: TwmrJfX5PTGb3HO4yOwkcQ-1
Received: by mail-oo1-f72.google.com with SMTP id c8-20020a4a87c8000000b0049f149a83fdso6169293ooi.19
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MWnsyB5sxeFYntkt0vIRWfG8T8fsCpIgSxnBoT/BNFI=;
        b=3GqwdEz773Q93//v8y+vEuYE9LGAy2sGy476tGcr4CIX1YGWD58T2+PRgb9tGGwvdF
         yzZOq7mphZUyVvPwBSlyF1z6y2PyB5O4ebTCgVEj3ny4F++5UpPoo4CKaGlzheDZ9axj
         6sw7ibMCaPEepMFQc+HrzkcWt48Qi2IN+tnhTFUEnUADj//DWA0bgBcmA94XQTWYO1C4
         65pyxqlNrTo5djCqoKtP5ex6gm7gcpQYfJOZKE9SEKBQpxWLhoyv+1fhFtcXLVBXuiSK
         fsho1QFuGwdWyEiOR70KXall7ul8w5J2TZbszxarizsIQW//MtMDHL/5ghdb71r9No18
         DT/g==
X-Gm-Message-State: AFqh2kpja9uaSXLGft/a/MIIC/jcxM+RdMPhWzAkCsmWo8Bq9VSQP04R
        AHUkC3O2sVKJIk2ytW9LJbHCjfzcXxtJMfToU9JXo3eFEfcTI8ULfuPW9MVZi49vYePcoQ7tAD4
        5poARaBRi4Cw3NDI2jMY9TbY7PCzF2pfn
X-Received: by 2002:a05:6870:bb1a:b0:144:b22a:38d3 with SMTP id nw26-20020a056870bb1a00b00144b22a38d3mr128549oab.280.1671000380520;
        Tue, 13 Dec 2022 22:46:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsYblB9x5xwo/WTOwFjqPemdP2/m1+jY+4gWjkzKBPhp0Uz+IEw4heA0f7Fi09kLSTOOOq4JUizn1sm5Q6htc0=
X-Received: by 2002:a05:6870:bb1a:b0:144:b22a:38d3 with SMTP id
 nw26-20020a056870bb1a00b00144b22a38d3mr128540oab.280.1671000380257; Tue, 13
 Dec 2022 22:46:20 -0800 (PST)
MIME-Version: 1.0
References: <20221207145428.31544-1-gautam.dawar@amd.com> <20221207145428.31544-11-gautam.dawar@amd.com>
In-Reply-To: <20221207145428.31544-11-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 14 Dec 2022 14:46:09 +0800
Message-ID: <CACGkMEuMfcuUOCv_S62Y6Ju-HS7yqikEEYxy_h7+vkLrtnTg6A@mail.gmail.com>
Subject: Re: [PATCH net-next 10/11] sfc: implement vdpa config_ops for dma operations
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

On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>
> Although sfc uses the platform IOMMU but it still
> implements the DMA config operations to deal with
> possible IOVA overlap with the MCDI DMA buffer and
> relocates the latter if such overlap is detected.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.c     | 140 ++++++++++++++++++++++
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |   3 +
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 111 +++++++++++++++++
>  drivers/net/ethernet/sfc/net_driver.h     |  12 ++
>  4 files changed, 266 insertions(+)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
> index b9368eb1acd5..16681d164fd1 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -309,6 +309,140 @@ static int vdpa_update_domain(struct ef100_vdpa_nic *vdpa_nic)
>                                           vdpa_nic->geo_aper_end + 1, 0);
>  }
>
> +static int ef100_vdpa_alloc_buffer(struct efx_nic *efx, struct efx_buffer *buf)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic = efx->vdpa_nic;
> +       struct device *dev = &vdpa_nic->vdpa_dev.dev;
> +       int rc;
> +
> +       buf->addr = kzalloc(buf->len, GFP_KERNEL);
> +       if (!buf->addr)
> +               return -ENOMEM;
> +
> +       rc = iommu_map(vdpa_nic->domain, buf->dma_addr,
> +                      virt_to_phys(buf->addr), buf->len,
> +                      IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
> +       if (rc)
> +               dev_err(dev, "iommu_map failed, rc: %d\n", rc);
> +
> +       return rc;
> +}
> +
> +static void ef100_vdpa_free_buffer(struct ef100_vdpa_nic *vdpa_nic,
> +                                  struct efx_buffer *buf)
> +{
> +       struct device *dev = &vdpa_nic->vdpa_dev.dev;
> +       int rc;
> +
> +       rc = iommu_unmap(vdpa_nic->domain, buf->dma_addr, buf->len);
> +       if (rc < 0)
> +               dev_err(dev, "iommu_unmap failed, rc: %d\n", rc);
> +
> +       kfree(buf->addr);
> +}
> +
> +int ef100_setup_ef100_mcdi_buffer(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +       struct efx_nic *efx = vdpa_nic->efx;
> +       struct ef100_nic_data *nic_data;
> +       struct efx_mcdi_iface *mcdi;
> +       struct efx_buffer mcdi_buf;
> +       enum efx_mcdi_mode mode;
> +       struct device *dev;
> +       int rc;
> +
> +       /* Switch to poll mode MCDI mode */
> +       nic_data = efx->nic_data;
> +       dev = &vdpa_nic->vdpa_dev.dev;
> +       mcdi = efx_mcdi(efx);
> +       mode = mcdi->mode;
> +       efx_mcdi_mode_poll(efx);
> +       efx_mcdi_flush_async(efx);
> +
> +       /* First, allocate the MCDI buffer for EF100 mode */
> +       rc = efx_nic_alloc_buffer(efx, &mcdi_buf,
> +                                 MCDI_BUF_LEN, GFP_KERNEL);
> +       if (rc) {
> +               dev_err(dev, "nic alloc buf failed, rc: %d\n", rc);
> +               goto restore_mode;
> +       }
> +
> +       /* unmap and free the vDPA MCDI buffer now */
> +       ef100_vdpa_free_buffer(vdpa_nic, &nic_data->mcdi_buf);
> +       memcpy(&nic_data->mcdi_buf, &mcdi_buf, sizeof(struct efx_buffer));
> +       efx->mcdi_buf_mode = EFX_BUF_MODE_EF100;
> +
> +restore_mode:
> +       if (mode == MCDI_MODE_EVENTS)
> +               efx_mcdi_mode_event(efx);
> +
> +       return rc;
> +}
> +
> +int ef100_setup_vdpa_mcdi_buffer(struct efx_nic *efx, u64 mcdi_iova)
> +{
> +       struct ef100_nic_data *nic_data = efx->nic_data;
> +       struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
> +       enum efx_mcdi_mode mode = mcdi->mode;
> +       struct efx_buffer mcdi_buf;
> +       int rc;
> +
> +       efx_mcdi_mode_poll(efx);
> +       efx_mcdi_flush_async(efx);
> +
> +       /* First, prepare the MCDI buffer for vDPA mode */
> +       mcdi_buf.dma_addr = mcdi_iova;
> +       /* iommu_map requires page aligned memory */
> +       mcdi_buf.len = PAGE_ALIGN(MCDI_BUF_LEN);
> +       rc = ef100_vdpa_alloc_buffer(efx, &mcdi_buf);
> +       if (rc) {
> +               pci_err(efx->pci_dev, "alloc vdpa buf failed, rc: %d\n", rc);
> +               goto restore_mode;
> +       }
> +
> +       /* All set-up, free the EF100 MCDI buffer now */
> +       efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
> +       memcpy(&nic_data->mcdi_buf, &mcdi_buf, sizeof(struct efx_buffer));
> +       efx->mcdi_buf_mode = EFX_BUF_MODE_VDPA;
> +
> +restore_mode:
> +       if (mode == MCDI_MODE_EVENTS)
> +               efx_mcdi_mode_event(efx);
> +       return rc;
> +}
> +
> +int ef100_remap_vdpa_mcdi_buffer(struct efx_nic *efx, u64 mcdi_iova)
> +{
> +       struct ef100_nic_data *nic_data = efx->nic_data;
> +       struct ef100_vdpa_nic *vdpa_nic = efx->vdpa_nic;
> +       struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
> +       struct efx_buffer *mcdi_buf;
> +       int rc;
> +
> +       mcdi_buf = &nic_data->mcdi_buf;
> +       spin_lock_bh(&mcdi->iface_lock);
> +
> +       rc = iommu_unmap(vdpa_nic->domain, mcdi_buf->dma_addr, mcdi_buf->len);
> +       if (rc < 0) {
> +               pci_err(efx->pci_dev, "iommu_unmap failed, rc: %d\n", rc);
> +               goto out;
> +       }
> +
> +       rc = iommu_map(vdpa_nic->domain, mcdi_iova,
> +                      virt_to_phys(mcdi_buf->addr),
> +                      mcdi_buf->len,
> +                      IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE);
> +       if (rc) {
> +               pci_err(efx->pci_dev, "iommu_map failed, rc: %d\n", rc);
> +               goto out;
> +       }
> +
> +       mcdi_buf->dma_addr = mcdi_iova;
> +out:
> +       spin_unlock_bh(&mcdi->iface_lock);
> +       return rc;
> +}
> +
>  static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>                                                 const char *dev_name,
>                                                 enum ef100_vdpa_class dev_type,
> @@ -391,6 +525,12 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>                 goto err_put_device;
>         }
>
> +       rc = ef100_setup_vdpa_mcdi_buffer(efx, EF100_VDPA_IOVA_BASE_ADDR);
> +       if (rc) {
> +               pci_err(efx->pci_dev, "realloc mcdi failed, err: %d\n", rc);
> +               goto err_put_device;
> +       }
> +
>         rc = get_net_config(vdpa_nic);
>         if (rc)
>                 goto err_put_device;
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> index c3c77029973d..f15d8739dcde 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -202,6 +202,9 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>  int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
>  void ef100_vdpa_irq_vectors_free(void *data);
>  int ef100_vdpa_reset(struct vdpa_device *vdev);
> +int ef100_setup_ef100_mcdi_buffer(struct ef100_vdpa_nic *vdpa_nic);
> +int ef100_setup_vdpa_mcdi_buffer(struct efx_nic *efx, u64 mcdi_iova);
> +int ef100_remap_vdpa_mcdi_buffer(struct efx_nic *efx, u64 mcdi_iova);
>
>  static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>  {
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> index 8c198d949fdb..7c632f179bcf 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -12,6 +12,7 @@
>  #include "ef100_vdpa.h"
>  #include "ef100_iova.h"
>  #include "io.h"
> +#include "ef100_iova.h"
>  #include "mcdi_vdpa.h"
>
>  /* Get the queue's function-local index of the associated VI
> @@ -739,14 +740,121 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>         }
>  }
>
> +static bool is_iova_overlap(u64 iova1, u64 size1, u64 iova2, u64 size2)
> +{
> +       return max(iova1, iova2) < min(iova1 + size1, iova2 + size2);
> +}
> +
> +static int ef100_vdpa_dma_map(struct vdpa_device *vdev,
> +                             unsigned int asid,
> +                             u64 iova, u64 size,
> +                             u64 pa, u32 perm, void *opaque)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic;
> +       struct ef100_nic_data *nic_data;
> +       unsigned int mcdi_buf_len;
> +       dma_addr_t mcdi_buf_addr;
> +       u64 mcdi_iova = 0;
> +       int rc;
> +
> +       vdpa_nic = get_vdpa_nic(vdev);
> +       nic_data = vdpa_nic->efx->nic_data;
> +       mcdi_buf_addr = nic_data->mcdi_buf.dma_addr;
> +       mcdi_buf_len = nic_data->mcdi_buf.len;
> +
> +       /* Validate the iova range against geo aperture */
> +       if (iova < vdpa_nic->geo_aper_start ||
> +           ((iova + size - 1) > vdpa_nic->geo_aper_end)) {
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: iova range (%llx, %llx) not within geo aperture\n",
> +                       __func__, iova, (iova + size));
> +               return -EINVAL;

It might be helpful to advertise this geo via get_iova_range().

Thanks

