Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2BE06C5EAA
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCWFTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjCWFTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:19:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64F91F4A7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679548712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9pa8I6uMPs5BO05vLsVIFV0T990dC+krQvICt00FYL8=;
        b=U+lt58kHO+DFAFtTlRlzgqnKsv3W21nKS6Lh24P4DCPr+jy6BaLSo58MamO++nVBiEWPXt
        O8mLVtfsrbyQcdxibPx9XZ/mY1jcXHJDFelnKgN2eQplJWe9J9VPDFuBp42g0pJLSXls/L
        CvxQl5qLHViNnm9tli9VTReO6hDTSuQ=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-isgndrnSNse6coAII3dmfA-1; Thu, 23 Mar 2023 01:18:31 -0400
X-MC-Unique: isgndrnSNse6coAII3dmfA-1
Received: by mail-ot1-f71.google.com with SMTP id f14-20020a9d5f0e000000b0069d8d0ff799so9102499oti.6
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679548710;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9pa8I6uMPs5BO05vLsVIFV0T990dC+krQvICt00FYL8=;
        b=UAA/eLARcMXFIcX42lTkD09X1As4OXnu/VSvmhTnq05g+YKwfVwk3Dp8DCgObtltQX
         JXnQaI4p830xNUj7gDcg/BfNOk+A6JDGya6nyPzNXSf4KFoSLuulE7Vs4AyvMZ1lUAC4
         r7vF8ybldXa/4Jz8bRvR0mTr4zHJwRaBw4nGFGert9qUSKY/OTKlnNN5UW7ytVCwVdDP
         Bf7yw58TQyPkSCn/PoWmJMd8SlwOQCf7L8NgyYbG52ugmz52kGOla1zE/lKAhf+rYQuG
         NqMnOn08haUYCBtkU5i4zSZwN3pWvNtjDyDDStzivS+D5SENogRcdiICDlCgWgXTQaqa
         HoiA==
X-Gm-Message-State: AO0yUKXgCpbm/XdYns1wjr4uM6YUWP8YIe8ah9jNH6kFssz1oPI2jIGn
        kChTmFphtnH+OM4WgO+yxT3dqn0GQDDhIg0TUTDDaq5wsrO2HeABumtV5BnnpA3r/xBRka2/rok
        OyJ8LgemLBCW9p7Ats0ZLK5tw02CxPPXx
X-Received: by 2002:a54:438b:0:b0:37f:a2ad:6718 with SMTP id u11-20020a54438b000000b0037fa2ad6718mr1984893oiv.3.1679548710412;
        Wed, 22 Mar 2023 22:18:30 -0700 (PDT)
X-Google-Smtp-Source: AK7set95jbJXhhqB31gIQpV+J3ITukaVY6VeIsQ56Mdi1D6yzlxWUbfhwzdbdxSM8UguVGMj3rRBa3SmTOHJdnj2ZgQ=
X-Received: by 2002:a54:438b:0:b0:37f:a2ad:6718 with SMTP id
 u11-20020a54438b000000b0037fa2ad6718mr1984890oiv.3.1679548710160; Wed, 22 Mar
 2023 22:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230322191038.44037-1-shannon.nelson@amd.com> <20230322191038.44037-7-shannon.nelson@amd.com>
In-Reply-To: <20230322191038.44037-7-shannon.nelson@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 23 Mar 2023 13:18:18 +0800
Message-ID: <CACGkMEvacgachSZK8J4zpSXAYaCBkyJrqp8_rYV7-k1O7arC7Q@mail.gmail.com>
Subject: Re: [PATCH v3 virtio 6/8] pds_vdpa: add support for vdpa and vdpamgmt interfaces
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
> This is the vDPA device support, where we advertise that we can
> support the virtio queues and deal with the configuration work
> through the pds_core's adminq.
>
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/vdpa/pds/aux_drv.c  |  15 +
>  drivers/vdpa/pds/aux_drv.h  |   1 +
>  drivers/vdpa/pds/debugfs.c  | 260 +++++++++++++++++
>  drivers/vdpa/pds/debugfs.h  |  10 +
>  drivers/vdpa/pds/vdpa_dev.c | 560 +++++++++++++++++++++++++++++++++++-
>  5 files changed, 845 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> index 8f3ae3326885..e54f0371c60e 100644
> --- a/drivers/vdpa/pds/aux_drv.c
> +++ b/drivers/vdpa/pds/aux_drv.c

[...]

> +
> +static struct vdpa_notification_area
> +pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
> +{
> +       struct pds_vdpa_device *pdsv =3D vdpa_to_pdsv(vdpa_dev);
> +       struct virtio_pci_modern_device *vd_mdev;
> +       struct vdpa_notification_area area;
> +
> +       area.addr =3D pdsv->vqs[qid].notify_pa;
> +
> +       vd_mdev =3D &pdsv->vdpa_aux->vd_mdev;
> +       if (!vd_mdev->notify_offset_multiplier)
> +               area.size =3D PDS_PAGE_SIZE;

This hasn't been defined so far? Others look good.

Thanks

