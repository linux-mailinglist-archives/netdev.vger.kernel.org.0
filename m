Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B5A5BDA05
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 04:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiITCSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 22:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiITCSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 22:18:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395DE2A277
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 19:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663640296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FEUHTADoR8KlD4DD+fhNieYTMG22Ao1FKlWpqZYIFa0=;
        b=LzIQkrlrZHhLB1rM9je4hH12yvVa753tqqRFoHu0iAIxDrpWsmsAPJ6kaaKTaUYp+/ahHN
        0obqUKYTwIjt2BkP0d/bhLph6GkM0HutVlQWPgGMqAF67SQAOJB4eb6Fzcgc5XJKpQ4qee
        yH2WnjQRKyrDLUudtgWZlwnfi1fNgKc=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-435-eM7Ax-xMOHy4O89Gey0FHA-1; Mon, 19 Sep 2022 22:18:07 -0400
X-MC-Unique: eM7Ax-xMOHy4O89Gey0FHA-1
Received: by mail-vs1-f71.google.com with SMTP id 124-20020a670882000000b00388cd45f433so326363vsi.8
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 19:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=FEUHTADoR8KlD4DD+fhNieYTMG22Ao1FKlWpqZYIFa0=;
        b=8QUsVkzX4VZHaVjeAPUTdovV0JUs8gqTzbIZIjqCyG9+PPZ80iBxdVE/5MUt4EC8ut
         ZvL8pGekl2yaVT6bL2tJu8WndmiLA5YW+BPbzmJMFq+jBsAMSLu7YleDlpPnnErd+4k3
         buL4P0FefVKbSMMPbJ05nkugtzpGfgaMHmonEvZQ5bNVJSXayYgEvjksZBQ7mRv+USaL
         0lNAEsnUdXuZ1R8hPMKoeUhZV8MDQ124c/xi7Ez4Ni5hatRbrcB3UKqINn+9qrDO84kk
         OvNA+t91go2CnRE7ExRrLiIORehIwc4osXj3xgnaTjSLWRNsb0QEcLKCHhcwWkZVmyOK
         15vw==
X-Gm-Message-State: ACrzQf2cbRWoAFjxhMasMwa2MGNQBjTva7SrppMcZvb86eOq2OolWxIk
        z4RgMM2sSw0iZ059cfhdHIl9mIWwGHqv3O7bMl6+TzTcAmwWTFqSE3xhP7OUd3t2lAhyjyRfAFz
        D9Jc/4Q6k26f2J+PGXsNTafKa/lE+YxAC
X-Received: by 2002:a05:6102:1341:b0:398:889e:7f28 with SMTP id j1-20020a056102134100b00398889e7f28mr7927487vsl.21.1663640286471;
        Mon, 19 Sep 2022 19:18:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4aFZxat3rBDo+ydZBqX3GNyuERyeXan0fOqLbRyeIGO/Vie0sDsAXF13Gh5Xuw8CK/4MrpmzAl1kTy+h7rnkM=
X-Received: by 2002:a05:6102:1341:b0:398:889e:7f28 with SMTP id
 j1-20020a056102134100b00398889e7f28mr7927479vsl.21.1663640286262; Mon, 19 Sep
 2022 19:18:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com> <20220909085712.46006-5-lingshan.zhu@intel.com>
In-Reply-To: <20220909085712.46006-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 20 Sep 2022 10:17:55 +0800
Message-ID: <CACGkMEtqi4AZ8ZOv=U9TjswOwVpr32mbi2S7Z6DcayaUrfUeyg@mail.gmail.com>
Subject: Re: [PATCH 4/4] vDPA: Conditionally read MTU and MAC in dev cfg space
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
> The spec says:
> mtu only exists if VIRTIO_NET_F_MTU is set
> The mac address field always exists (though
> is only valid if VIRTIO_NET_F_MAC is set)
>
> So vdpa_dev_net_config_fill() should read MTU and MAC
> conditionally on the feature bits.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>  drivers/vdpa/vdpa.c | 37 +++++++++++++++++++++++++++++--------
>  1 file changed, 29 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index f8ff61232421..b332388d3375 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -815,6 +815,29 @@ static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>         return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>  }
>
> +static int vdpa_dev_net_mtu_config_fill(struct sk_buff *msg, u64 features,
> +                                       const struct virtio_net_config *config)
> +{
> +       u16 val_u16;
> +
> +       if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
> +               return 0;
> +
> +       val_u16 = __virtio16_to_cpu(true, config->mtu);
> +
> +       return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16);
> +}
> +
> +static int vdpa_dev_net_mac_config_fill(struct sk_buff *msg, u64 features,
> +                                       const struct virtio_net_config *config)
> +{
> +       if ((features & BIT_ULL(VIRTIO_NET_F_MAC)) == 0)
> +               return 0;
> +
> +       return  nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR,
> +                       sizeof(config->mac), config->mac);
> +}
> +
>  static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>  {
>         struct virtio_net_config config = {};
> @@ -824,18 +847,10 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>
>         vdev->config->get_config(vdev, 0, &config, sizeof(config));
>
> -       if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
> -                   config.mac))
> -               return -EMSGSIZE;
> -
>         val_u16 = __virtio16_to_cpu(true, config.status);
>         if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>                 return -EMSGSIZE;
>
> -       val_u16 = __virtio16_to_cpu(true, config.mtu);
> -       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> -               return -EMSGSIZE;
> -
>         /* only read driver features after the feature negotiation is done */
>         status = vdev->config->get_status(vdev);
>         if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
> @@ -852,6 +867,12 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>                               VDPA_ATTR_PAD))
>                 return -EMSGSIZE;
>
> +       if (vdpa_dev_net_mtu_config_fill(msg, features_device, &config))
> +               return -EMSGSIZE;
> +
> +       if (vdpa_dev_net_mac_config_fill(msg, features_device, &config))
> +               return -EMSGSIZE;
> +
>         return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>  }
>
> --
> 2.31.1
>

