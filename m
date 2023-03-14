Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF006B8929
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 04:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCNDtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 23:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCNDte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 23:49:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40CE6042C
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 20:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678765726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ptwZll8h87dgHJIgfhW5kVetp/8YFoTfo6N7J2gOEM=;
        b=fiPObVDvB1HVf/MpxmO3VIxVH6x99CgprdksVMm5QHXthGriIQY+7HUWsUcqhQpl4yv03a
        9F4rDIg2J8ERaD/0BSD8+MgujtgPEEhlbLgOH7+I0ce20CkQYCN862FHNU0X8ON2lQ2pSZ
        HoNNlsXuyVXXbOV1cZNULIyUBQW5rTU=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-ZcUeYg0WMFO5dyeZgafj_Q-1; Mon, 13 Mar 2023 23:48:44 -0400
X-MC-Unique: ZcUeYg0WMFO5dyeZgafj_Q-1
Received: by mail-oo1-f70.google.com with SMTP id c9-20020a4a4f09000000b005178610a793so3966320oob.3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 20:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678765724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ptwZll8h87dgHJIgfhW5kVetp/8YFoTfo6N7J2gOEM=;
        b=K7X7f3GMsQNwrgl+S9u1xIv1a1bIhMYcsGSAwRiDyNJga4BQE4jZfMFYnJ1w1rAEa9
         kKilgnHdoUu0rnec5F3rQd9JXsxfqIU5dH7JiKWs/UEEmv2MXKz6lPH6NcH1fg2DAjb/
         9wTTMBk4KF3V3GtDjaqv8dspvHiuvBT/mjhZZDFGMMcHlaxpUK74R3bmhPl8g30G1hOX
         llvzI3NomTssARUDr1sqDvuhXr0L8L/g/zLtwVlBvmk8tAkBalgMDM8tiA59V2rS8xca
         vAERXqx3VxfUUZTM/DiLSut2WpG+0mdtmTeD6eTczFd+SLrKvuuEvMRmSFQrvV68th1A
         ohjg==
X-Gm-Message-State: AO0yUKW+hwnqvhmQsX+iVOKyi3LsGWsHckpd+GP93RJw/9LlYqCXXYoN
        TcFO0H9P/8Wvzwv+coqYFht8debPj3oBgsDUd6B2WwVqRUQnjhRw0Jvp4v1bqyM10R93Fz/FRmy
        vmiZbpmDrXlB7IifwTenPb+y4ROLIaAOU
X-Received: by 2002:a05:6870:1110:b0:17a:adbe:2ba4 with SMTP id 16-20020a056870111000b0017aadbe2ba4mr117865oaf.9.1678765724090;
        Mon, 13 Mar 2023 20:48:44 -0700 (PDT)
X-Google-Smtp-Source: AK7set8/3QKP0un3qOoea6zpjo8vUIQsfQbqXMn5cSBIhnA44wMHNQck4apXmRGrPe4GAOAB9DE3FgX6b6IEjtSp9QQ=
X-Received: by 2002:a05:6870:1110:b0:17a:adbe:2ba4 with SMTP id
 16-20020a056870111000b0017aadbe2ba4mr117853oaf.9.1678765723868; Mon, 13 Mar
 2023 20:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230302113421.174582-1-sgarzare@redhat.com> <20230302113421.174582-3-sgarzare@redhat.com>
In-Reply-To: <20230302113421.174582-3-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Mar 2023 11:48:33 +0800
Message-ID: <CACGkMEttgd82xOxV8WLdSFdfhRLZn68tSaV4APSDh8qXxf4OEw@mail.gmail.com>
Subject: Re: [PATCH v2 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 2, 2023 at 7:34=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
com> wrote:
>
> When the user call VHOST_SET_OWNER ioctl and the vDPA device
> has `use_va` set to true, let's call the bind_mm callback.
> In this way we can bind the device to the user address space
> and directly use the user VA.
>
> The unbind_mm callback is called during the release after
> stopping the device.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> Notes:
>     v2:
>     - call the new unbind_mm callback during the release [Jason]
>     - avoid to call bind_mm callback after the reset, since the device
>       is not detaching it now during the reset
>
>  drivers/vhost/vdpa.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index dc12dbd5b43b..1ab89fccd825 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>         return vdpa_reset(vdpa);
>  }
>
> +static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       if (!vdpa->use_va || !ops->bind_mm)
> +               return 0;
> +
> +       return ops->bind_mm(vdpa, v->vdev.mm);
> +}
> +
> +static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
> +{
> +       struct vdpa_device *vdpa =3D v->vdpa;
> +       const struct vdpa_config_ops *ops =3D vdpa->config;
> +
> +       if (!vdpa->use_va || !ops->unbind_mm)
> +               return;
> +
> +       ops->unbind_mm(vdpa);
> +}
> +
>  static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *ar=
gp)
>  {
>         struct vdpa_device *vdpa =3D v->vdpa;
> @@ -711,6 +733,13 @@ static long vhost_vdpa_unlocked_ioctl(struct file *f=
ilep,
>                 break;
>         default:
>                 r =3D vhost_dev_ioctl(&v->vdev, cmd, argp);
> +               if (!r && cmd =3D=3D VHOST_SET_OWNER) {
> +                       r =3D vhost_vdpa_bind_mm(v);
> +                       if (r) {
> +                               vhost_dev_reset_owner(&v->vdev, NULL);
> +                               break;
> +                       }
> +               }

Nit: is it better to have a new condition/switch branch instead of
putting them under default? (as what vring_ioctl did).

Thanks

>                 if (r =3D=3D -ENOIOCTLCMD)
>                         r =3D vhost_vdpa_vring_ioctl(v, cmd, argp);
>                 break;
> @@ -1285,6 +1314,7 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>         vhost_vdpa_clean_irq(v);
>         vhost_vdpa_reset(v);
>         vhost_dev_stop(&v->vdev);
> +       vhost_vdpa_unbind_mm(v);
>         vhost_vdpa_free_domain(v);
>         vhost_vdpa_config_put(v);
>         vhost_vdpa_cleanup(v);
> --
> 2.39.2
>

