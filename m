Return-Path: <netdev+bounces-2476-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2D3370229F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F4FD28109F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 03:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5FE1C26;
	Mon, 15 May 2023 03:51:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD101FAE
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:51:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A54F171D
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684122658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ug4lOczkCVIqRxzALymxlBcZQCDDkaOfinDuNkIF8Bg=;
	b=XH0/cDkuVSox5vqtm77Rbb/EFA3YWt9sWzZtFN/mh7ZVWfV+v3Usr/7myA9pYbxnDCNdgf
	ew3r6lJ3sK2E46dzTRTTD+0zTkrbRn+kTDUvndBwCGtLyfMHbg34X2W9QDHiVrEiBjm1SV
	wTNuS2EVHAjR9Q6Ere3Ii1+5r+rqaRY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-B2EUx_1ON6CsqgZxzDTkbw-1; Sun, 14 May 2023 23:50:57 -0400
X-MC-Unique: B2EUx_1ON6CsqgZxzDTkbw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ad819ab909so44310311fa.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684122655; x=1686714655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ug4lOczkCVIqRxzALymxlBcZQCDDkaOfinDuNkIF8Bg=;
        b=Gt6/DG9Ejuf28Q25xc8RrOI2CSVp1gm83gwZtk9Gk3Glov5wnRH0j91jXrFL3xCCJN
         4JbDBpnw/h/kcMAboQ9cYb6T5Jhf7wUCzcUP6tbiKRvGydAqaCGp+5RW0tguom5tBpw9
         tDLFfPock1RJM9KwS2VAiF4nwKmyM3Bu6WMq1tVC8G4B0vt3+gQ8kS1a0c5FsTBJPXa2
         raTtlVzXIs5QCvogQjkBXjgpmSGhYw1i2TqVxh11vu24LUiBZFWtbfdBbYjpGOgOfC5W
         LwAOiiq7P7wNLhgtuaSAXWefwHAORUC+i7T5Vbu6iSswDt1Mbpoe7pUr91Ok6sHSOos1
         wg2g==
X-Gm-Message-State: AC+VfDwc9cK/bx8KB4xSm0leTnZ6jotORQt3ge1KU+rcC3kTlo2L/0A+
	f9w111yRKz2S93PaYzcWtNNASuUwVj8GDF4OwJiHP9nWsqzpVM7Y2oD8fwPaEWAJaasim3+aFBU
	ZHxaF94CEumZdNHwZh9VNK4gowv8y5F/O8xh94DuWRocg2w==
X-Received: by 2002:a2e:984e:0:b0:298:ad8e:e65 with SMTP id e14-20020a2e984e000000b00298ad8e0e65mr6982121ljj.21.1684122655288;
        Sun, 14 May 2023 20:50:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6O/xEgaCMEOq33lgXSdrKWYLGsR3UXF2SvNMhY54xBDhrM4Eis+wInccl5RJLEz0xoou22llWe2dqCNpmkfTQ=
X-Received: by 2002:a2e:984e:0:b0:298:ad8e:e65 with SMTP id
 e14-20020a2e984e000000b00298ad8e0e65mr6982120ljj.21.1684122655078; Sun, 14
 May 2023 20:50:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230503181240.14009-1-shannon.nelson@amd.com> <20230503181240.14009-8-shannon.nelson@amd.com>
In-Reply-To: <20230503181240.14009-8-shannon.nelson@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 15 May 2023 11:50:44 +0800
Message-ID: <CACGkMEv_sz4-XVH3-QNZZ+xQCZaQK_pzOcFqHS4si38fifVbpg@mail.gmail.com>
Subject: Re: [PATCH v5 virtio 07/11] pds_vdpa: virtio bar setup for vdpa
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org, 
	brett.creeley@amd.com, netdev@vger.kernel.org, simon.horman@corigine.com, 
	drivers@pensando.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 2:13=E2=80=AFAM Shannon Nelson <shannon.nelson@amd.c=
om> wrote:
>
> Prep and use the "modern" virtio bar utilities to get our
> virtio config space ready.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/vdpa/pds/aux_drv.c | 25 +++++++++++++++++++++++++
>  drivers/vdpa/pds/aux_drv.h |  3 +++
>  2 files changed, 28 insertions(+)
>
> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> index aa748cf55d2b..0c4a135b1484 100644
> --- a/drivers/vdpa/pds/aux_drv.c
> +++ b/drivers/vdpa/pds/aux_drv.c
> @@ -4,6 +4,7 @@
>  #include <linux/auxiliary_bus.h>
>  #include <linux/pci.h>
>  #include <linux/vdpa.h>
> +#include <linux/virtio_pci_modern.h>
>
>  #include <linux/pds/pds_common.h>
>  #include <linux/pds/pds_core_if.h>
> @@ -19,12 +20,22 @@ static const struct auxiliary_device_id pds_vdpa_id_t=
able[] =3D {
>         {},
>  };
>
> +static int pds_vdpa_device_id_check(struct pci_dev *pdev)
> +{
> +       if (pdev->device !=3D PCI_DEVICE_ID_PENSANDO_VDPA_VF ||
> +           pdev->vendor !=3D PCI_VENDOR_ID_PENSANDO)
> +               return -ENODEV;
> +
> +       return PCI_DEVICE_ID_PENSANDO_VDPA_VF;
> +}
> +
>  static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
>                           const struct auxiliary_device_id *id)
>
>  {
>         struct pds_auxiliary_dev *padev =3D
>                 container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
> +       struct device *dev =3D &aux_dev->dev;
>         struct pds_vdpa_aux *vdpa_aux;
>         int err;
>
> @@ -41,8 +52,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux=
_dev,
>         if (err)
>                 goto err_free_mem;
>
> +       /* Find the virtio configuration */
> +       vdpa_aux->vd_mdev.pci_dev =3D padev->vf_pdev;
> +       vdpa_aux->vd_mdev.device_id_check =3D pds_vdpa_device_id_check;
> +       vdpa_aux->vd_mdev.dma_mask =3D DMA_BIT_MASK(PDS_CORE_ADDR_LEN);
> +       err =3D vp_modern_probe(&vdpa_aux->vd_mdev);
> +       if (err) {
> +               dev_err(dev, "Unable to probe for virtio configuration: %=
pe\n",
> +                       ERR_PTR(err));
> +               goto err_free_mgmt_info;
> +       }
> +
>         return 0;
>
> +err_free_mgmt_info:
> +       pci_free_irq_vectors(padev->vf_pdev);
>  err_free_mem:
>         kfree(vdpa_aux);
>         auxiliary_set_drvdata(aux_dev, NULL);
> @@ -55,6 +79,7 @@ static void pds_vdpa_remove(struct auxiliary_device *au=
x_dev)
>         struct pds_vdpa_aux *vdpa_aux =3D auxiliary_get_drvdata(aux_dev);
>         struct device *dev =3D &aux_dev->dev;
>
> +       vp_modern_remove(&vdpa_aux->vd_mdev);
>         pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
>
>         kfree(vdpa_aux);
> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
> index dcec782e79eb..99e0ff340bfa 100644
> --- a/drivers/vdpa/pds/aux_drv.h
> +++ b/drivers/vdpa/pds/aux_drv.h
> @@ -4,6 +4,8 @@
>  #ifndef _AUX_DRV_H_
>  #define _AUX_DRV_H_
>
> +#include <linux/virtio_pci_modern.h>
> +
>  #define PDS_VDPA_DRV_DESCRIPTION    "AMD/Pensando vDPA VF Device Driver"
>  #define PDS_VDPA_DRV_NAME           KBUILD_MODNAME
>
> @@ -16,6 +18,7 @@ struct pds_vdpa_aux {
>
>         int vf_id;
>         struct dentry *dentry;
> +       struct virtio_pci_modern_device vd_mdev;
>
>         int nintrs;
>  };
> --
> 2.17.1
>


