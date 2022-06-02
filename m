Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1B053B45C
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 09:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiFBHch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 03:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiFBHce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 03:32:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E43AC3879D
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 00:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654155147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L39d6PlclTccAa5+peBdlcEs7zVdEw6CEB2ogF1cL00=;
        b=fv7+gMYVSGIvtSYVaOPg9Vz5u8TSNg4YZqrlUQe2m4sr2lKq2sLuaX1msBJHQGUt84WOBf
        Ubw7v8E0EaFNIpMBfbbtbv+w8ZsFI7hzHw+jVEIJMX1Bvtxn+L/nyILDZ9Ap2pWdYkjXJN
        hTelNL5NyD7o4UmKdTHPgl0CQfvX09M=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-14iKA4H0Nz6dUi3t1--w6g-1; Thu, 02 Jun 2022 03:32:20 -0400
X-MC-Unique: 14iKA4H0Nz6dUi3t1--w6g-1
Received: by mail-yb1-f200.google.com with SMTP id i17-20020a259d11000000b0064cd3084085so3480943ybp.9
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 00:32:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L39d6PlclTccAa5+peBdlcEs7zVdEw6CEB2ogF1cL00=;
        b=jqK+NbIVqe2mDuXhy0f50ZArLL0DvvecUrDFD91jxk3YoDrs+Kpj3X6C2wSh9+WznG
         PzOXNGHVt5YDbWLuZQwe1S0rB5MO8mfDMbGmcjOypozs1FkQhN/or4Gr1uq0HqSJdva8
         sRq8aGvlnCjWpH+5pig/7uMDwnAoPrVBVqX679IiwXTuLkVKGgSamX4dxh1xj+2H1eWF
         u/qQxJTPEi/D518Ekkrtybioxuq2ZcyIbXxzPlp7AQhx2DIch3HrUKu2iBLpM5oMFrIG
         QYkKqPZiEzMrNwjYKWX42jD1N4x0htTbN4JovQoIPxzp1G1Bf742z5U52U7YLBLqqG3R
         biNA==
X-Gm-Message-State: AOAM5301NuiM0ylRjmKZugCmwNxxK2UpRp/DKEJ177c2ac1PTJiJ+bHk
        QQ550IYgBVJBvRJffR/slC4RXuc2uv/ImUAxjQjAnNMkJmIWYxbEGzMBmSCryPAnQ7+cjeAyvra
        Zuy+5HSGPrDwNA2kc5/jMaK7/rj7diFd/
X-Received: by 2002:a81:980c:0:b0:2f8:be8d:5100 with SMTP id p12-20020a81980c000000b002f8be8d5100mr4053294ywg.52.1654155140421;
        Thu, 02 Jun 2022 00:32:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnmWA3pQQTaG73FhzWf8q7To1mpHUSTp/3C1yHN8ExI89iHTx7nUJpLVL1Rjj16C3YeSiWiIYVSWvIUTzTdQ8=
X-Received: by 2002:a81:980c:0:b0:2f8:be8d:5100 with SMTP id
 p12-20020a81980c000000b002f8be8d5100mr4053284ywg.52.1654155140203; Thu, 02
 Jun 2022 00:32:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220602023845.2596397-1-lingshan.zhu@intel.com> <20220602023845.2596397-4-lingshan.zhu@intel.com>
In-Reply-To: <20220602023845.2596397-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 2 Jun 2022 15:32:09 +0800
Message-ID: <CACGkMEv9Vhe0+8DTotmGU1_9DseixTqA4CaYC1sXiNy0XYkBQw@mail.gmail.com>
Subject: Re: [PATCH 3/6] vDPA/ifcvf: support userspace to query device feature bits
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, Eli Cohen <elic@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This commit supports userspace to query device feature bits
> by filling the relevant netlink attribute.
>
> There are two types of netlink attributes:
> VDPA_ATTR_DEV_XXXX work for virtio devices config space, and
> VDPA_ATTR_MGMTDEV_XXXX work for the management devices.
>
> This commit fixes a misuse of VDPA_ATTR_DEV_SUPPORTED_FEATURES,
> this attr is for a virtio device, not management devices.
>
> Thus VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES is introduced for
> reporting management device features, and VDPA_ATTR_DEV_SUPPORTED_FEATURES
> for virtio devices feature bits.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/vdpa.c       | 15 ++++++++++-----
>  include/uapi/linux/vdpa.h |  1 +
>  2 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 2b75c00b1005..c820dd2b0307 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -508,7 +508,7 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
>                 err = -EMSGSIZE;
>                 goto msg_err;
>         }
> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES,

Adding Eli and Parav.

If I understand correctly, we can't provision virtio features right
now. This means, the vDPA instance should have the same features as
its parent (management device).

And it seems to me if we can do things like this, we need first allow
the features to be provisioned. (And this change breaks uABI)

Thanks


>                               mdev->supported_features, VDPA_ATTR_PAD)) {
>                 err = -EMSGSIZE;
>                 goto msg_err;
> @@ -827,7 +827,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>  {
>         struct virtio_net_config config = {};
> -       u64 features;
> +       u64 features_device, features_driver;
>         u16 val_u16;
>
>         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> @@ -844,12 +844,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>                 return -EMSGSIZE;
>
> -       features = vdev->config->get_driver_features(vdev);
> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
> +       features_driver = vdev->config->get_driver_features(vdev);
> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>                               VDPA_ATTR_PAD))
>                 return -EMSGSIZE;
>
> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
> +       features_device = vdev->config->get_device_features(vdev);
> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES, features_device,
> +                             VDPA_ATTR_PAD))
> +               return -EMSGSIZE;
> +
> +       return vdpa_dev_net_mq_config_fill(vdev, msg, features_device, &config);
>  }
>
>  static int
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> index 1061d8d2d09d..70a3672c288f 100644
> --- a/include/uapi/linux/vdpa.h
> +++ b/include/uapi/linux/vdpa.h
> @@ -30,6 +30,7 @@ enum vdpa_attr {
>         VDPA_ATTR_MGMTDEV_BUS_NAME,             /* string */
>         VDPA_ATTR_MGMTDEV_DEV_NAME,             /* string */
>         VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,    /* u64 */
> +       VDPA_ATTR_MGMTDEV_SUPPORTED_FEATURES,   /* u64 */
>
>         VDPA_ATTR_DEV_NAME,                     /* string */
>         VDPA_ATTR_DEV_ID,                       /* u32 */
> --
> 2.31.1
>

