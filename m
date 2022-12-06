Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F446643CB1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiLFFbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbiLFFbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:31:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A5922B13
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 21:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670304606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UrdaxmIkU9R3lSKqzN+skDpzAUuGekW0ctr0930cr/A=;
        b=MCOotMH1rHxzlY9olc1r9Xm0gPP4SSkIBdL3vLsPX8MUgh+9mygdIVfKBpanZI8qZZob2G
        RwsE6foU9RueSLTbRmxeL6KMlCWHT3M5s52M9ShdOCCfnExzYqkREWEgzdGKCK1mlLfufi
        hUr5km/Zbp3aVnPS/+O/F2x9LgHv2Pw=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-263-vZs1rzONNUiwVwXxrnOgFg-1; Tue, 06 Dec 2022 00:29:53 -0500
X-MC-Unique: vZs1rzONNUiwVwXxrnOgFg-1
Received: by mail-ot1-f71.google.com with SMTP id bm9-20020a056830374900b0066e7ffcb95dso6522217otb.2
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 21:29:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UrdaxmIkU9R3lSKqzN+skDpzAUuGekW0ctr0930cr/A=;
        b=T+YKephol/7hazZ0L5Ebyu8/QLVHpMwTJE2BxxV4dMHi4hDv42dk7FPXPwJoFWEQiP
         +wH0PWN8LZvzHT21zXCEurEx+SsVMJYxlkoCwX3iZpj4hjq/AyOQJXNmTy/nGYEyfMKG
         U/8u+08NAE9texhxkPiADl2IaAYq9I3XMe/LSfQMeh9VpqvwVRCFFJ/BVTyQ6zB+US7d
         BHMXfZPI66gT75ZVz+t9r1Z75VsMdcUvqss2iQ6zz2W/aZUex5gNfoJkCoeKzTWE1Utm
         yvNQcypw0pdTJkZarZgn7tGL6O9hSTBuKvoKupJqqDM7OANcWs5XoFzIMMWBmXn562aF
         NJnQ==
X-Gm-Message-State: ANoB5pn64d3z+lpLb7R8VglXT6LuMJA0v+5bSaxY9FUL31/mVVjLl6Ne
        h7eCG15Kk9/Ro/7NEr2m10nnAJVwQ1tN3Im6b5AGsFCUFq+nbe06+W51OjTkqwpOeAEnsadjJrH
        sSusqwv0xjOaruy20H+YVaG8hiLhaiDua
X-Received: by 2002:aca:1a12:0:b0:35c:303d:fe37 with SMTP id a18-20020aca1a12000000b0035c303dfe37mr4032016oia.35.1670304593137;
        Mon, 05 Dec 2022 21:29:53 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6l9v2aYuxnEBGmCEsIj8zQk1K2aSin0sjamhXhP/Yt985bXk8FjhcMHR1OvJvvG6gC8ksK1A2vuriXQ64EZrw=
X-Received: by 2002:aca:1a12:0:b0:35c:303d:fe37 with SMTP id
 a18-20020aca1a12000000b0035c303dfe37mr4032006oia.35.1670304592948; Mon, 05
 Dec 2022 21:29:52 -0800 (PST)
MIME-Version: 1.0
References: <20221122074348.88601-1-hengqi@linux.alibaba.com> <20221122074348.88601-3-hengqi@linux.alibaba.com>
In-Reply-To: <20221122074348.88601-3-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 6 Dec 2022 13:29:42 +0800
Message-ID: <CACGkMEsaU1Ogytfmy4rVYx6U2Rkd3HcLMjuULZPvR-JJHeRkgA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] virtio_net: set up xdp for multi buffer packets
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 3:44 PM Heng Qi <hengqi@linux.alibaba.com> wrote:
>
> When the xdp program sets xdp.frags, which means it can process
> multi-buffer packets, so we continue to open xdp support when
> features such as GRO_HW are negotiated.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c5046d21b281..8f7d207d58d6 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3080,14 +3080,21 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>         u16 xdp_qp = 0, curr_qp;
>         int i, err;
>
> -       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)
> -           && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> -               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> -               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
> -               virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
> -               NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
> -               return -EOPNOTSUPP;
> +       if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> +               if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM)) {
> +                       NL_SET_ERR_MSG_MOD(extack, "Can't set XDP without frags while guest is implementing GUEST_CSUM");
> +                       return -EOPNOTSUPP;
> +               }
> +
> +               if (prog && !prog->aux->xdp_has_frags) {
> +                       if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> +                           virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> +                           virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> +                           virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO)) {
> +                               NL_SET_ERR_MSG_MOD(extack, "Can't set XDP without frags while guest is implementing GUEST_GRO_HW");
> +                               return -EOPNOTSUPP;
> +                       }
> +               }
>         }
>
>         if (vi->mergeable_rx_bufs && !vi->any_header_sg) {
> @@ -3095,8 +3102,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>                 return -EINVAL;
>         }
>
> -       if (dev->mtu > max_sz) {
> -               NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
> +       if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
> +               NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP without frags");
>                 netdev_warn(dev, "XDP requires MTU less than %lu\n", max_sz);
>                 return -EINVAL;
>         }
> @@ -3218,9 +3225,6 @@ static int virtnet_set_features(struct net_device *dev,
>         int err;
>
>         if ((dev->features ^ features) & NETIF_F_GRO_HW) {
> -               if (vi->xdp_enabled)
> -                       return -EBUSY;

This seems suspicious, GRO_HW could be re-enabled accidentally even if
it was disabled when attaching an XDP program that is not capable of
doing multi-buffer XDP?

Thanks

> -
>                 if (features & NETIF_F_GRO_HW)
>                         offloads = vi->guest_offloads_capable;
>                 else
> --
> 2.19.1.6.gb485710b
>

