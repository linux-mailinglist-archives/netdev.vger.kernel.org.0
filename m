Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA2D483B25
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiADDoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:44:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37991 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231218AbiADDoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:44:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641267864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U3bRp9PDw2PtdlQN7RsHKxoF/g+6HtYTrwOQVxpYpkg=;
        b=ewJoEVH/asVTt1uuHPZuNvkintjY7r3X64UHDyxis0Y4qICDXE/MaFi1oUS6iMNgf2yx9n
        2L0JGW/QlGFw0Dpy/2zUBwmH9Jw1u2Nxd1BhPONTIBTwR5bFcH7dbO0tvTv+gO4rTrtymp
        oZjojhIoy0X4fCVfa2padaL5W4ppxvg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-eYR-_xs1OYyc0pzXCPwUhw-1; Mon, 03 Jan 2022 22:44:22 -0500
X-MC-Unique: eYR-_xs1OYyc0pzXCPwUhw-1
Received: by mail-lj1-f200.google.com with SMTP id j15-20020a2e6e0f000000b0022db2724332so9236561ljc.3
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 19:44:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U3bRp9PDw2PtdlQN7RsHKxoF/g+6HtYTrwOQVxpYpkg=;
        b=fztnQSJcbdeSYO6UJk8o4Usg/OSZlNuxzW7Nk1j/O5SUnp5HanN74wrh2ACt6hsWMF
         NWdYC9TVGlkcWHGv1LrrVl/LNq7v+BP5A2VL9HH6fDg4BIzpHJvih4FRV5RNGRtOiLPn
         WnC8Uusv9mQKg9mgnH61BWk7NpJyLtZVZsack7Ish1VRBOHIwRfzVR/XHIBmz4KCbiWk
         KI1rQ2oM1DttxUqWF4XX3A2xZDdzE8P+cTSuVXhkxPWF3W28zO6qdtUPe2yT7OoIHnce
         DRe4EBC0ilQBZGp0FVBPv0gspT435OkOv/ug9QgQkGcehijmojZEl3X6hfvXmXpOSy/G
         raXg==
X-Gm-Message-State: AOAM531kQ3Y1A4tmHWoSBvhgL/2VVvza+cQxBCjchDI/lGckt+K73Po9
        d5NoMx9Jdh0b3xiv9/tVT9jMXBxZi3y/NeG6sUeB0FgkGJiHkEy+UImFynUFyTH7udA5qRoq7RB
        7j5ktYhxg8NeR8Gb7evOlMQSjdr89WxTn
X-Received: by 2002:a05:6512:22d6:: with SMTP id g22mr42525580lfu.199.1641267861377;
        Mon, 03 Jan 2022 19:44:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPfKa8UYDWk8yXRh/Tynib8SG3CWPXUC55CynDHAaf3IrbQwAAOOMAqfKLA5ICJGqVqiZgR88MAce8maqcssc=
X-Received: by 2002:a05:6512:22d6:: with SMTP id g22mr42525557lfu.199.1641267861109;
 Mon, 03 Jan 2022 19:44:21 -0800 (PST)
MIME-Version: 1.0
References: <20211224070404.54840-1-wang.yi59@zte.com.cn>
In-Reply-To: <20211224070404.54840-1-wang.yi59@zte.com.cn>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 4 Jan 2022 11:44:10 +0800
Message-ID: <CACGkMEvdKATVvLVQtfPfSeev83Ajskg4gFoHDhWT7wrWEQ3FEA@mail.gmail.com>
Subject: Re: [PATCH v2] vdpa: regist vhost-vdpa dev class
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     mst <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        xue.zhihong@zte.com.cn, wang.liang82@zte.com.cn,
        Zhang Min <zhang.min9@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 24, 2021 at 3:13 PM Yi Wang <wang.yi59@zte.com.cn> wrote:
>
> From: Zhang Min <zhang.min9@zte.com.cn>
>
> Some applications like kata-containers need to acquire MAJOR/MINOR/DEVNAME
> for devInfo [1], so regist vhost-vdpa dev class to expose uevent.

Hi:

I think we need to be more verbose here e.g:

1) why can't we get major/minor with the current interface
2) what kind of the uevent is required and not supported currently

Thanks

>
> 1. https://github.com/kata-containers/kata-containers/blob/main/src/runtime/virtcontainers/device/config/config.go
>
> Signed-off-by: Zhang Min <zhang.min9@zte.com.cn>
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> ---
> v2: remove redundant vhost_vdpa_class reset and pr_warn, adjust location
>     of *vhost_vdpa_class impl and class_destroy.
>
>  drivers/vhost/vdpa.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index e3c4f059b21a..55e966c508c8 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -53,6 +53,7 @@ struct vhost_vdpa {
>  static DEFINE_IDA(vhost_vdpa_ida);
>
>  static dev_t vhost_vdpa_major;
> +static struct class *vhost_vdpa_class;
>
>  static void handle_vq_kick(struct vhost_work *work)
>  {
> @@ -1140,6 +1141,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>         v->dev.release = vhost_vdpa_release_dev;
>         v->dev.parent = &vdpa->dev;
>         v->dev.devt = MKDEV(MAJOR(vhost_vdpa_major), minor);
> +       v->dev.class = vhost_vdpa_class;
>         v->vqs = kmalloc_array(v->nvqs, sizeof(struct vhost_virtqueue),
>                                GFP_KERNEL);
>         if (!v->vqs) {
> @@ -1197,6 +1199,10 @@ static int __init vhost_vdpa_init(void)
>  {
>         int r;
>
> +       vhost_vdpa_class = class_create(THIS_MODULE, "vhost-vdpa");
> +       if (IS_ERR(vhost_vdpa_class))
> +               return PTR_ERR(vhost_vdpa_class);
> +
>         r = alloc_chrdev_region(&vhost_vdpa_major, 0, VHOST_VDPA_DEV_MAX,
>                                 "vhost-vdpa");
>         if (r)
> @@ -1211,6 +1217,7 @@ static int __init vhost_vdpa_init(void)
>  err_vdpa_register_driver:
>         unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
>  err_alloc_chrdev:
> +       class_destroy(vhost_vdpa_class);
>         return r;
>  }
>  module_init(vhost_vdpa_init);
> @@ -1219,6 +1226,7 @@ static void __exit vhost_vdpa_exit(void)
>  {
>         vdpa_unregister_driver(&vhost_vdpa_driver);
>         unregister_chrdev_region(vhost_vdpa_major, VHOST_VDPA_DEV_MAX);
> +       class_destroy(vhost_vdpa_class);
>  }
>  module_exit(vhost_vdpa_exit);
>
> --
> 2.27.0
>

