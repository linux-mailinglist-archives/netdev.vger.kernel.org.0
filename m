Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CEB6B35E7
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 06:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjCJFGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 00:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjCJFGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 00:06:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F238F0FF4
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 21:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678424716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j9kx14cOBeOwYfDhESSA0OePt79Hb99P01lR+fSR4n4=;
        b=JPdGxW7PUe96l3emxKcyLUe5cxxH/+4VcUU0xgiAsFb3YkrryWbaip+l5eCttd2n/j3bZZ
        hOte7+m5xhmwtYzZRI+wXZkBWITFvWwMOksBZTTHI2mKW/GVFr/e8Rbh0ucMpP3A/MxgaQ
        3V0yQnMT/V0i556VTpXOiaVDBMaEGM8=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-PZ6h4hDUM9u7cevOWHRUQQ-1; Fri, 10 Mar 2023 00:05:15 -0500
X-MC-Unique: PZ6h4hDUM9u7cevOWHRUQQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-17679dc6e16so2232507fac.7
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 21:05:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678424714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9kx14cOBeOwYfDhESSA0OePt79Hb99P01lR+fSR4n4=;
        b=LO850r/68ngDJ6HvFYANJlOHvclP+ry6f7nM2RzjyO/UR57w7QohhWbN96IchB9CEf
         2KNhLeZGGovw4PSnpCZ8GowFPCNwuhVcXM9VKvX/eaZziytDplLsvrxh3xZ6oFymz2EG
         5swjzt25P6bNrbou8iKQKa81QxEZ9F/9nKfu4zvyl1xmTXRZAJC/HloSyPqtPZanZ5LL
         BVe9nqaMP/yZ8GqVbeWQSsw8SDo2wBISmwsPHYoNoU27rnUMai4hawhN1upoRLirk5FU
         akbkhAzG9zosVg2EEClykit+cP80T2rB/Pm+HJK59fxf/RTGkr4btBFCdBCiJurWatry
         e3bg==
X-Gm-Message-State: AO0yUKVeBgUgOHa+7zTKf7H7sCPKTOssKe5/V2QrnIoMnTgAPvsL5A6r
        OQ9KStMh2jyX2qTISRy/yMNLCmneXRL9vgh3/yaNKsNLzwjma6SetRnC/aT3ZGhIlgNBlPVEdmZ
        axjxJuYGZ8R/i6NLw28Qjz4QPLiHlYpLM
X-Received: by 2002:a05:6808:45:b0:384:27f0:bd0a with SMTP id v5-20020a056808004500b0038427f0bd0amr7442279oic.9.1678424714385;
        Thu, 09 Mar 2023 21:05:14 -0800 (PST)
X-Google-Smtp-Source: AK7set/oE9nncWtTmpBXW9hMdJU3matvUyYuTnzMN/w12/txIETirBefSBIfAwdNFAcxHHOqAaaoEkc/BCo0xxWjRu0=
X-Received: by 2002:a05:6808:45:b0:384:27f0:bd0a with SMTP id
 v5-20020a056808004500b0038427f0bd0amr7442258oic.9.1678424713993; Thu, 09 Mar
 2023 21:05:13 -0800 (PST)
MIME-Version: 1.0
References: <20230307113621.64153-1-gautam.dawar@amd.com> <20230307113621.64153-10-gautam.dawar@amd.com>
In-Reply-To: <20230307113621.64153-10-gautam.dawar@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 10 Mar 2023 13:05:02 +0800
Message-ID: <CACGkMEvpK4P1TTAO2bZ+YMXuNFMk_hJHQBPszCwOTzbQX70s7w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 09/14] sfc: implement device status related
 vdpa config operations
To:     Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
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

On Tue, Mar 7, 2023 at 7:38=E2=80=AFPM Gautam Dawar <gautam.dawar@amd.com> =
wrote:
>
> vDPA config opertions to handle get/set device status and device
> reset have been implemented. Also .suspend config operation is
> implemented to support Live Migration.
>
> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> ---
>  drivers/net/ethernet/sfc/ef100_vdpa.c     |  16 +-
>  drivers/net/ethernet/sfc/ef100_vdpa.h     |   2 +
>  drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 367 ++++++++++++++++++++--
>  3 files changed, 355 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet=
/sfc/ef100_vdpa.c
> index c66e5aef69ea..4ba57827a6cd 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> @@ -68,9 +68,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsi=
gned int *allocated_vis)
>
>  static void ef100_vdpa_delete(struct efx_nic *efx)
>  {
> +       struct vdpa_device *vdpa_dev;
> +
>         if (efx->vdpa_nic) {
> +               vdpa_dev =3D &efx->vdpa_nic->vdpa_dev;
> +               ef100_vdpa_reset(vdpa_dev);
> +
>                 /* replace with _vdpa_unregister_device later */
> -               put_device(&efx->vdpa_nic->vdpa_dev.dev);
> +               put_device(&vdpa_dev->dev);
>         }
>         efx_mcdi_free_vis(efx);
>  }
> @@ -171,6 +176,15 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(stru=
ct efx_nic *efx,
>                 }
>         }
>
> +       rc =3D devm_add_action_or_reset(&efx->pci_dev->dev,
> +                                     ef100_vdpa_irq_vectors_free,
> +                                     efx->pci_dev);
> +       if (rc) {
> +               pci_err(efx->pci_dev,
> +                       "Failed adding devres for freeing irq vectors\n")=
;
> +               goto err_put_device;
> +       }
> +
>         rc =3D get_net_config(vdpa_nic);
>         if (rc)
>                 goto err_put_device;
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet=
/sfc/ef100_vdpa.h
> index 348ca8a7404b..58791402e454 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> @@ -149,6 +149,8 @@ int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>  void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>  void ef100_vdpa_irq_vectors_free(void *data);
>  int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
> +void ef100_vdpa_irq_vectors_free(void *data);
> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>
>  static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa=
_nic)
>  {
> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethe=
rnet/sfc/ef100_vdpa_ops.c
> index 0051c4c0e47c..95a2177f85a2 100644
> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> @@ -22,11 +22,6 @@ static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa=
_device *vdev)
>         return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>  }
>
> -void ef100_vdpa_irq_vectors_free(void *data)
> -{
> -       pci_free_irq_vectors(data);
> -}
> -
>  static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>  {
>         struct efx_vring_ctx *vring_ctx;
> @@ -52,14 +47,6 @@ static void delete_vring_ctx(struct ef100_vdpa_nic *vd=
pa_nic, u16 idx)
>         vdpa_nic->vring[idx].vring_ctx =3D NULL;
>  }
>
> -static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> -{
> -       vdpa_nic->vring[idx].vring_type =3D EF100_VDPA_VQ_NTYPES;
> -       vdpa_nic->vring[idx].vring_state =3D 0;
> -       vdpa_nic->vring[idx].last_avail_idx =3D 0;
> -       vdpa_nic->vring[idx].last_used_idx =3D 0;
> -}
> -
>  int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>  {
>         u32 offset;
> @@ -103,6 +90,236 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vd=
pa_nic, u16 idx,
>         return false;
>  }
>
> +static void irq_vring_fini(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       struct ef100_vdpa_vring_info *vring =3D &vdpa_nic->vring[idx];
> +       struct pci_dev *pci_dev =3D vdpa_nic->efx->pci_dev;
> +
> +       devm_free_irq(&pci_dev->dev, vring->irq, vring);
> +       vring->irq =3D -EINVAL;
> +}
> +
> +static irqreturn_t vring_intr_handler(int irq, void *arg)
> +{
> +       struct ef100_vdpa_vring_info *vring =3D arg;
> +
> +       if (vring->cb.callback)
> +               return vring->cb.callback(vring->cb.private);
> +
> +       return IRQ_NONE;
> +}
> +
> +static int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvq=
s)
> +{
> +       int rc;
> +
> +       rc =3D pci_alloc_irq_vectors(pci_dev, nvqs, nvqs, PCI_IRQ_MSIX);
> +       if (rc < 0)
> +               pci_err(pci_dev,
> +                       "Failed to alloc %d IRQ vectors, err:%d\n", nvqs,=
 rc);
> +       return rc;
> +}
> +
> +void ef100_vdpa_irq_vectors_free(void *data)
> +{
> +       pci_free_irq_vectors(data);
> +}
> +
> +static int irq_vring_init(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       struct ef100_vdpa_vring_info *vring =3D &vdpa_nic->vring[idx];
> +       struct pci_dev *pci_dev =3D vdpa_nic->efx->pci_dev;
> +       int irq;
> +       int rc;
> +
> +       snprintf(vring->msix_name, 256, "x_vdpa[%s]-%d\n",
> +                pci_name(pci_dev), idx);
> +       irq =3D pci_irq_vector(pci_dev, idx);
> +       rc =3D devm_request_irq(&pci_dev->dev, irq, vring_intr_handler, 0=
,
> +                             vring->msix_name, vring);
> +       if (rc)
> +               pci_err(pci_dev,
> +                       "devm_request_irq failed for vring %d, rc %d\n",
> +                       idx, rc);
> +       else
> +               vring->irq =3D irq;
> +
> +       return rc;
> +}
> +
> +static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
> +       int rc;
> +
> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
> +               return 0;
> +
> +       rc =3D efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
> +                                   &vring_dyn_cfg);
> +       if (rc)
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: delete vring failed index:%u, err:%d\n",
> +                       __func__, idx, rc);
> +       vdpa_nic->vring[idx].last_avail_idx =3D vring_dyn_cfg.avail_idx;
> +       vdpa_nic->vring[idx].last_used_idx =3D vring_dyn_cfg.used_idx;
> +       vdpa_nic->vring[idx].vring_state &=3D ~EF100_VRING_CREATED;
> +
> +       irq_vring_fini(vdpa_nic, idx);
> +
> +       return rc;
> +}
> +
> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       u32 idx_val;
> +
> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
> +               return;
> +
> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
> +               return;
> +
> +       idx_val =3D idx;
> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
> +                   vdpa_nic->vring[idx].doorbell_offset);
> +}
> +
> +static bool can_create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       if (vdpa_nic->vring[idx].vring_state =3D=3D EF100_VRING_CONFIGURE=
D &&
> +           vdpa_nic->status & VIRTIO_CONFIG_S_DRIVER_OK &&
> +           !(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
> +               return true;
> +
> +       return false;
> +}
> +
> +static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
> +       struct efx_vring_cfg vring_cfg;
> +       int rc;
> +
> +       rc =3D irq_vring_init(vdpa_nic, idx);
> +       if (rc) {
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: irq_vring_init failed. index:%u, err:%d\n",
> +                       __func__, idx, rc);
> +               return rc;
> +       }
> +       vring_cfg.desc =3D vdpa_nic->vring[idx].desc;
> +       vring_cfg.avail =3D vdpa_nic->vring[idx].avail;
> +       vring_cfg.used =3D vdpa_nic->vring[idx].used;
> +       vring_cfg.size =3D vdpa_nic->vring[idx].size;
> +       vring_cfg.features =3D vdpa_nic->features;
> +       vring_cfg.msix_vector =3D idx;
> +       vring_dyn_cfg.avail_idx =3D vdpa_nic->vring[idx].last_avail_idx;
> +       vring_dyn_cfg.used_idx =3D vdpa_nic->vring[idx].last_used_idx;
> +
> +       rc =3D efx_vdpa_vring_create(vdpa_nic->vring[idx].vring_ctx,
> +                                  &vring_cfg, &vring_dyn_cfg);
> +       if (rc) {
> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> +                       "%s: vring_create failed index:%u, err:%d\n",
> +                       __func__, idx, rc);
> +               goto err_vring_create;
> +       }
> +       vdpa_nic->vring[idx].vring_state |=3D EF100_VRING_CREATED;
> +
> +       /* A VQ kick allows the device to read the avail_idx, which will =
be
> +        * required at the destination after live migration.
> +        */
> +       ef100_vdpa_kick_vq(&vdpa_nic->vdpa_dev, idx);
> +
> +       return 0;
> +
> +err_vring_create:
> +       irq_vring_fini(vdpa_nic, idx);
> +       return rc;
> +}
> +
> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
> +{
> +       delete_vring(vdpa_nic, idx);
> +       vdpa_nic->vring[idx].vring_type =3D EF100_VDPA_VQ_NTYPES;
> +       vdpa_nic->vring[idx].vring_state =3D 0;
> +       vdpa_nic->vring[idx].last_avail_idx =3D 0;
> +       vdpa_nic->vring[idx].last_used_idx =3D 0;
> +}
> +
> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +       int i;
> +
> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
> +
> +       if (!vdpa_nic->status)
> +               return;
> +
> +       vdpa_nic->vdpa_state =3D EF100_VDPA_STATE_INITIALIZED;
> +       vdpa_nic->status =3D 0;
> +       vdpa_nic->features =3D 0;
> +       for (i =3D 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
> +               reset_vring(vdpa_nic, i);
> +       ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
> +}
> +
> +/* May be called under the rtnl lock */
> +int ef100_vdpa_reset(struct vdpa_device *vdev)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +
> +       /* vdpa device can be deleted anytime but the bar_config
> +        * could still be vdpa and hence efx->state would be STATE_VDPA.
> +        * Accordingly, ensure vdpa device exists before reset handling
> +        */
> +       if (!vdpa_nic)
> +               return -ENODEV;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       ef100_reset_vdpa_device(vdpa_nic);
> +       mutex_unlock(&vdpa_nic->lock);
> +       return 0;
> +}
> +
> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
> +{
> +       struct efx_nic *efx =3D vdpa_nic->efx;
> +       struct ef100_nic_data *nic_data;
> +       int i, j;
> +       int rc;
> +
> +       nic_data =3D efx->nic_data;
> +       rc =3D ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
> +                                         vdpa_nic->max_queue_pairs * 2);
> +       if (rc < 0) {
> +               pci_err(efx->pci_dev,
> +                       "vDPA IRQ alloc failed for vf: %u err:%d\n",
> +                       nic_data->vf_index, rc);
> +               return rc;
> +       }
> +
> +       for (i =3D 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
> +               if (can_create_vring(vdpa_nic, i)) {
> +                       rc =3D create_vring(vdpa_nic, i);
> +                       if (rc)
> +                               goto clear_vring;
> +               }
> +       }
> +
> +       vdpa_nic->vdpa_state =3D EF100_VDPA_STATE_STARTED;

It looks to me that this duplicates with the DRIVER_OK status bit.

> +       return 0;
> +
> +clear_vring:
> +       for (j =3D 0; j < i; j++)
> +               delete_vring(vdpa_nic, j);
> +
> +       ef100_vdpa_irq_vectors_free(efx->pci_dev);
> +       return rc;
> +}
> +
>  static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>                                      u16 idx, u64 desc_area, u64 driver_a=
rea,
>                                      u64 device_area)
> @@ -144,22 +361,6 @@ static void ef100_vdpa_set_vq_num(struct vdpa_device=
 *vdev, u16 idx, u32 num)
>         mutex_unlock(&vdpa_nic->lock);
>  }
>
> -static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
> -{
> -       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> -       u32 idx_val;
> -
> -       if (is_qid_invalid(vdpa_nic, idx, __func__))
> -               return;
> -
> -       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
> -               return;
> -
> -       idx_val =3D idx;
> -       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
> -                   vdpa_nic->vring[idx].doorbell_offset);
> -}
> -
>  static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>                                  struct vdpa_callback *cb)
>  {
> @@ -176,6 +377,7 @@ static void ef100_vdpa_set_vq_ready(struct vdpa_devic=
e *vdev, u16 idx,
>                                     bool ready)
>  {
>         struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       int rc;
>
>         if (is_qid_invalid(vdpa_nic, idx, __func__))
>                 return;
> @@ -184,9 +386,21 @@ static void ef100_vdpa_set_vq_ready(struct vdpa_devi=
ce *vdev, u16 idx,
>         if (ready) {
>                 vdpa_nic->vring[idx].vring_state |=3D
>                                         EF100_VRING_READY_CONFIGURED;
> +               if (vdpa_nic->vdpa_state =3D=3D EF100_VDPA_STATE_STARTED =
&&
> +                   can_create_vring(vdpa_nic, idx)) {
> +                       rc =3D create_vring(vdpa_nic, idx);
> +                       if (rc)
> +                               /* Rollback ready configuration
> +                                * So that the above layer driver
> +                                * can make another attempt to set ready
> +                                */
> +                               vdpa_nic->vring[idx].vring_state &=3D
> +                                       ~EF100_VRING_READY_CONFIGURED;
> +               }
>         } else {
>                 vdpa_nic->vring[idx].vring_state &=3D
>                                         ~EF100_VRING_READY_CONFIGURED;
> +               delete_vring(vdpa_nic, idx);
>         }
>         mutex_unlock(&vdpa_nic->lock);
>  }
> @@ -296,6 +510,12 @@ static u64 ef100_vdpa_get_device_features(struct vdp=
a_device *vdev)
>         }
>
>         features |=3D BIT_ULL(VIRTIO_NET_F_MAC);
> +       /* As QEMU SVQ doesn't implement the following features,
> +        * masking them off to allow Live Migration
> +        */
> +       features &=3D ~BIT_ULL(VIRTIO_F_IN_ORDER);
> +       features &=3D ~BIT_ULL(VIRTIO_F_ORDER_PLATFORM);

It's better not to work around userspace bugs in the kernel. We should
fix Qemu instead.

> +
>         return features;
>  }
>
> @@ -356,6 +576,77 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_devi=
ce *vdev)
>         return EF100_VDPA_VENDOR_ID;
>  }
>
> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       u8 status;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       status =3D vdpa_nic->status;
> +       mutex_unlock(&vdpa_nic->lock);
> +       return status;
> +}
> +
> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       u8 new_status;
> +       int rc;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       if (!status) {
> +               dev_info(&vdev->dev,
> +                        "%s: Status received is 0. Device reset being do=
ne\n",
> +                        __func__);

This is trigger-able by the userspace. It might be better to use
dev_dbg() instead.

> +               ef100_reset_vdpa_device(vdpa_nic);
> +               goto unlock_return;
> +       }
> +       new_status =3D status & ~vdpa_nic->status;
> +       if (new_status =3D=3D 0) {
> +               dev_info(&vdev->dev,
> +                        "%s: New status same as current status\n", __fun=
c__);

Same here.

> +               goto unlock_return;
> +       }
> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
> +               ef100_reset_vdpa_device(vdpa_nic);
> +               goto unlock_return;
> +       }
> +
> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE) {
> +               vdpa_nic->status |=3D VIRTIO_CONFIG_S_ACKNOWLEDGE;
> +               new_status &=3D ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
> +       }
> +       if (new_status & VIRTIO_CONFIG_S_DRIVER) {
> +               vdpa_nic->status |=3D VIRTIO_CONFIG_S_DRIVER;
> +               new_status &=3D ~VIRTIO_CONFIG_S_DRIVER;
> +       }
> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK) {
> +               vdpa_nic->status |=3D VIRTIO_CONFIG_S_FEATURES_OK;
> +               vdpa_nic->vdpa_state =3D EF100_VDPA_STATE_NEGOTIATED;

It might be better to explain the reason we need to track another
state in vdpa_state instead of simply using the device status.

> +               new_status &=3D ~VIRTIO_CONFIG_S_FEATURES_OK;
> +       }
> +       if (new_status & VIRTIO_CONFIG_S_DRIVER_OK &&
> +           vdpa_nic->vdpa_state =3D=3D EF100_VDPA_STATE_NEGOTIATED) {
> +               vdpa_nic->status |=3D VIRTIO_CONFIG_S_DRIVER_OK;
> +               rc =3D start_vdpa_device(vdpa_nic);
> +               if (rc) {
> +                       dev_err(&vdpa_nic->vdpa_dev.dev,
> +                               "%s: vDPA device failed:%d\n", __func__, =
rc);
> +                       vdpa_nic->status &=3D ~VIRTIO_CONFIG_S_DRIVER_OK;
> +                       goto unlock_return;
> +               }
> +               new_status &=3D ~VIRTIO_CONFIG_S_DRIVER_OK;
> +       }
> +       if (new_status) {
> +               dev_warn(&vdev->dev,
> +                        "%s: Mismatch Status: %x & State: %u\n",
> +                        __func__, new_status, vdpa_nic->vdpa_state);
> +       }
> +
> +unlock_return:
> +       mutex_unlock(&vdpa_nic->lock);
> +}
> +
>  static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
>  {
>         return sizeof(struct virtio_net_config);
> @@ -393,6 +684,20 @@ static void ef100_vdpa_set_config(struct vdpa_device=
 *vdev, unsigned int offset,
>                 vdpa_nic->mac_configured =3D true;
>  }
>
> +static int ef100_vdpa_suspend(struct vdpa_device *vdev)
> +{
> +       struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> +       int i, rc;
> +
> +       mutex_lock(&vdpa_nic->lock);
> +       for (i =3D 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
> +               rc =3D delete_vring(vdpa_nic, i);

Note that the suspension matters for the whole device. It means the
config space should not be changed. But the code here only suspends
the vring, is this intended?

Reset may have the same issue.

Thanks


> +               if (rc)
> +                       break;
> +       }
> +       mutex_unlock(&vdpa_nic->lock);
> +       return rc;
> +}
>  static void ef100_vdpa_free(struct vdpa_device *vdev)
>  {
>         struct ef100_vdpa_nic *vdpa_nic =3D get_vdpa_nic(vdev);
> @@ -428,9 +733,13 @@ const struct vdpa_config_ops ef100_vdpa_config_ops =
=3D {
>         .get_vq_num_max      =3D ef100_vdpa_get_vq_num_max,
>         .get_device_id       =3D ef100_vdpa_get_device_id,
>         .get_vendor_id       =3D ef100_vdpa_get_vendor_id,
> +       .get_status          =3D ef100_vdpa_get_status,
> +       .set_status          =3D ef100_vdpa_set_status,
> +       .reset               =3D ef100_vdpa_reset,
>         .get_config_size     =3D ef100_vdpa_get_config_size,
>         .get_config          =3D ef100_vdpa_get_config,
>         .set_config          =3D ef100_vdpa_set_config,
>         .get_generation      =3D NULL,
> +       .suspend             =3D ef100_vdpa_suspend,
>         .free                =3D ef100_vdpa_free,
>  };
> --
> 2.30.1
>

