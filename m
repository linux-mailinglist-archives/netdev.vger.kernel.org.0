Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927985BD9C9
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 04:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiITCC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 22:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiITCC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 22:02:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FCD57210
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 19:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663639371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=faCU162X+wI3VyF2nQiop7OG+mfYJ3C8OshE48krBU4=;
        b=dAFUvV2RlyKOopgHtCjvRaAbzSM+QQA7JfwxIPO3S1Uu8ux3VCY5pO4lyon/EELLnQrTIP
        l9Lmz9TSwclU+BtBD7S9QDRfnWZwTQb9QKUC5E1AKrvTtkM+p2q1CDwy9KWmhlKUjvjzo6
        VPDxdsh8gR3t1nNIhNw8n2hdk5XrXr0=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-503-kat27OgBMU2uFZT8GLh4JQ-1; Mon, 19 Sep 2022 22:02:50 -0400
X-MC-Unique: kat27OgBMU2uFZT8GLh4JQ-1
Received: by mail-vk1-f199.google.com with SMTP id d21-20020a1f9b15000000b003790f223621so333248vke.14
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 19:02:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=faCU162X+wI3VyF2nQiop7OG+mfYJ3C8OshE48krBU4=;
        b=v3uFMBrbY16c0S+1+6qIvw0p/P44Ga/XSBd2CQHQSTKp239p9Ym5gHt33ARdY/83on
         Nlm0t5sLiN0sxnSWwOPw7gLpm6k+qt9pdc/eoMpEhTwcYbBHmoBPsJfemD78Y1Igf5F0
         YJHjeYsHN1ddj8TgpqKoYsR8x4OVKeSIZxOJx2hzmrbz9GHV0wjn8OMkXdTXLfmAkCkC
         t1e1OaGQmS4f4hAfBt1gCQxZHZ8oMGasD/BIiTeGlgYc4nkK2UgzmD0Ia9ObmGZIiBZ1
         HYnYDoU++8zW/Dzae8cjGtaVn9x1mJLCh7IjfTvxR2UJ6zFMgqQxrNynSDKI0PnDIApv
         Ej0g==
X-Gm-Message-State: ACrzQf135mm/3xjPVT1BzxBOW4HHcRztj2otjtILv5xdJhCarhiGUxMO
        CNFuE/y0TIm4MB+FePreOhjhcb6X9+BGRIRN/e/SJ4jtSGzQ1c+RUqO1jjsCpoZy1LUZaV4+2rx
        qV0QvrS/gFMdEwzdKJkObMvZKpeVoUj4R
X-Received: by 2002:a05:6102:1341:b0:398:889e:7f28 with SMTP id j1-20020a056102134100b00398889e7f28mr7912782vsl.21.1663639369326;
        Mon, 19 Sep 2022 19:02:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7hWThMWApXIHlTE15FM2qB/Cbva+CwsqGmij2/DXcHfy6l4xVdBSPLV7e1pSscJ8wm1BTYnWg+1OnoMnHQnnc=
X-Received: by 2002:a05:6102:1341:b0:398:889e:7f28 with SMTP id
 j1-20020a056102134100b00398889e7f28mr7912778vsl.21.1663639369049; Mon, 19 Sep
 2022 19:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com> <20220909085712.46006-2-lingshan.zhu@intel.com>
In-Reply-To: <20220909085712.46006-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 20 Sep 2022 10:02:37 +0800
Message-ID: <CACGkMEsq+weeO7i8KtNNAPhXGwN=cTwWt3RWfTtML-Xwj3K5Qg@mail.gmail.com>
Subject: Re: [PATCH 1/4] vDPA: allow userspace to query features of a vDPA device
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> This commit adds a new vDPA netlink attribution
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
> features of vDPA devices through this new attr.
>
> This commit invokes vdpa_config_ops.get_config() than
> vdpa_get_config_unlocked() to read the device config
> spcae, so no raeces in vdpa_set_features_unlocked()
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

It's better to share the userspace code as well.

> ---
>  drivers/vdpa/vdpa.c       | 19 ++++++++++++++-----
>  include/uapi/linux/vdpa.h |  4 ++++
>  2 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index c06c02704461..798a02c7aa94 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -491,6 +491,8 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
>                 err = -EMSGSIZE;
>                 goto msg_err;
>         }
> +
> +       /* report features of a vDPA management device through VDPA_ATTR_DEV_SUPPORTED_FEATURES */

The code explains itself, there's no need for the comment.

>         if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>                               mdev->supported_features, VDPA_ATTR_PAD)) {
>                 err = -EMSGSIZE;
> @@ -815,10 +817,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>  {
>         struct virtio_net_config config = {};
> -       u64 features;
> +       u64 features_device, features_driver;
>         u16 val_u16;
>
> -       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> +       vdev->config->get_config(vdev, 0, &config, sizeof(config));
>
>         if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
>                     config.mac))
> @@ -832,12 +834,19 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>                 return -EMSGSIZE;
>
> -       features = vdev->config->get_driver_features(vdev);
> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
> +       features_driver = vdev->config->get_driver_features(vdev);
> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> +                             VDPA_ATTR_PAD))
> +               return -EMSGSIZE;
> +
> +       features_device = vdev->config->get_device_features(vdev);
> +
> +       /* report features of a vDPA device through VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES */
> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>                               VDPA_ATTR_PAD))
>                 return -EMSGSIZE;
>
> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
> +       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
>  }
>
>  static int
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> index 25c55cab3d7c..97531b52dcbe 100644
> --- a/include/uapi/linux/vdpa.h
> +++ b/include/uapi/linux/vdpa.h
> @@ -46,12 +46,16 @@ enum vdpa_attr {
>
>         VDPA_ATTR_DEV_NEGOTIATED_FEATURES,      /* u64 */
>         VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> +       /* features of a vDPA management device */
>         VDPA_ATTR_DEV_SUPPORTED_FEATURES,       /* u64 */
>
>         VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>         VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>         VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>
> +       /* features of a vDPA device, e.g., /dev/vhost-vdpa0 */
> +       VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,  /* u64 */

What's the difference between this and VDPA_ATTR_DEV_SUPPORTED_FEATURES?

Thanks

> +
>         /* new attributes must be added above here */
>         VDPA_ATTR_MAX,
>  };
> --
> 2.31.1
>

