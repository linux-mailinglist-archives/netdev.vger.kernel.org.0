Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B036DD1E7
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 07:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjDKFlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 01:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjDKFlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 01:41:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC56A2D49
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681191619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2MfVoDEeLgaeGehPapEDG88NMDEyPAiMkTlV+QvLe4=;
        b=VZ+eKr61nP7ZhuRfbzJkxdX8OulKRnkCvzZBjiF8j2fSLeCI4mrHMzN/GbDGxRClvLHuek
        VlFYdM3BvP5G8aXtGVCYmGMzyab1p4mIKYTLqxJtOl3+oF9mJBAt7nDN5Oqu9YLa5JKQ5r
        gX6ZTbNW5tBFisHcVXt2oZys0OSPiAk=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-vaaiytpnNxG7VRHGf2voTA-1; Tue, 11 Apr 2023 01:40:19 -0400
X-MC-Unique: vaaiytpnNxG7VRHGf2voTA-1
Received: by mail-oo1-f69.google.com with SMTP id bw6-20020a056820020600b00541854cb12cso4494056oob.4
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681191618; x=1683783618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2MfVoDEeLgaeGehPapEDG88NMDEyPAiMkTlV+QvLe4=;
        b=sZ+i/kOMtwewUGcrEuiJv/M+eF9q/f/1JCeg89A7oSmBnn/61alOr5iyekJFNXnHVI
         A72B5+jDzK8ghEK1H6EGUdEQVNmzEr+FyZwFOAs8UK1hXxM2f1h1/8JM4Jsl32Ku3Hhl
         3eLfw5D2K9rGEcWqBOTW+NLHlqz22X7H3W1UXiltm+lqad4C8APQuVCsg8XruPZyBQLO
         hLSyqJ2VK1HHWuI9hg9ydeFI/Lp6kyAd67D/UM3S3cqX+w/XwyPBF9vRIPFzpBbRD0Lu
         qUc7KuiXPOwzP1ISAPOqGMQWkYPHKPJxgFZzuUYq1NDw/H+egg4+HaXDTV+ZF2Dhnbgm
         ad/w==
X-Gm-Message-State: AAQBX9fmPNxqT/0DiKuDJaKz29yb/xF+prVLkSZK0PZGF5fgvNqVpW3M
        0MvNDLFM3WoGrkwTYgtoj46Y7IKvSn3VjF3ifCY6bfdCQ0z3MYbupVs0r3dB+1M8SGtBJCa5dnU
        xPhQZjKGBdB79WCiBm0LD4VwJqLdCZgUZjy86S//tqGWS0A==
X-Received: by 2002:aca:2105:0:b0:37f:ab56:ff42 with SMTP id 5-20020aca2105000000b0037fab56ff42mr382712oiz.9.1681191617964;
        Mon, 10 Apr 2023 22:40:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350b86Y/QCGjnR1TfO/EgY70echaGQeoEIsSV/BF854H5Sew6uskMivEF98OtO13bWZNWxpr8cuxN3sYgnFz5lyY=
X-Received: by 2002:aca:2105:0:b0:37f:ab56:ff42 with SMTP id
 5-20020aca2105000000b0037fab56ff42mr382703oiz.9.1681191617729; Mon, 10 Apr
 2023 22:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230404131326.44403-1-sgarzare@redhat.com> <20230404131326.44403-3-sgarzare@redhat.com>
In-Reply-To: <20230404131326.44403-3-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 11 Apr 2023 13:40:06 +0800
Message-ID: <CACGkMEsuoZMW==JKd_VeW5TUh=KTZC+vDJWLHQ5hbfncAf387Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/9] vhost-vdpa: use bind_mm/unbind_mm device callbacks
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        stefanha@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
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

On Tue, Apr 4, 2023 at 9:14=E2=80=AFPM Stefano Garzarella <sgarzare@redhat.=
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

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>
> Notes:
>     v4:
>     - added new switch after vhost_dev_ioctl() [Jason]
>     v3:
>     - added `case VHOST_SET_OWNER` in vhost_vdpa_unlocked_ioctl() [Jason]
>     v2:
>     - call the new unbind_mm callback during the release [Jason]
>     - avoid to call bind_mm callback after the reset, since the device
>       is not detaching it now during the reset
>
>  drivers/vhost/vdpa.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 7be9d9d8f01c..3824c249612f 100644
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
> @@ -716,6 +738,17 @@ static long vhost_vdpa_unlocked_ioctl(struct file *f=
ilep,
>                 break;
>         }
>
> +       if (r)
> +               goto out;
> +
> +       switch (cmd) {
> +       case VHOST_SET_OWNER:
> +               r =3D vhost_vdpa_bind_mm(v);
> +               if (r)
> +                       vhost_dev_reset_owner(d, NULL);
> +               break;
> +       }
> +out:
>         mutex_unlock(&d->mutex);
>         return r;
>  }
> @@ -1287,6 +1320,7 @@ static int vhost_vdpa_release(struct inode *inode, =
struct file *filep)
>         vhost_vdpa_clean_irq(v);
>         vhost_vdpa_reset(v);
>         vhost_dev_stop(&v->vdev);
> +       vhost_vdpa_unbind_mm(v);
>         vhost_vdpa_config_put(v);
>         vhost_vdpa_cleanup(v);
>         mutex_unlock(&d->mutex);
> --
> 2.39.2
>

