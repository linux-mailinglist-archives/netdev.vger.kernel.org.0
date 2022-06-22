Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949E555443B
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 10:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352161AbiFVIGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 04:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351249AbiFVIGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 04:06:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9D3EBE32
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 01:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655885196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J5FesIEJNUAYWwzRo/YOZ1QtVKtqRp3mnHCOXbnUhhM=;
        b=E0erraqkkAc2E3Gmgfnh7TI6GNsM4b3PWvLsZbMiYuOKu2/pjO4rb3pcROi5lFuTiGT2uI
        ZXGDf9e0889RdWl9wI4M9bxuj6++v6gqjA+QtR6DCyt8RMB1VbLptY6a6uXbQHKBIUSJik
        Wqq/jxVnb11WwqKn2s9mwbv0duiA2i8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-YyMbeC4iPdaw-_IiA-64Xg-1; Wed, 22 Jun 2022 04:06:30 -0400
X-MC-Unique: YyMbeC4iPdaw-_IiA-64Xg-1
Received: by mail-lf1-f71.google.com with SMTP id c21-20020a056512105500b00479762353a4so8179182lfb.8
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 01:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J5FesIEJNUAYWwzRo/YOZ1QtVKtqRp3mnHCOXbnUhhM=;
        b=WEnb7HttGzVDDlb/ALJ3az4umtDoUqCOPBoyv0Sv6eY4Z1krsly/Uqs1B5ccHplCIZ
         +TfoRoP643VTPzXxMrwqitYvRxz98xay7ycL0/A70tRo9By9ryJqlfP8+2AypjyRmFu+
         Dhuqyel+WVvAbeiiqMORnPCVTTsDIQ5Vq01fPtUYBUMQtjiAqpksrCylKlyCBg/12JT4
         y/dq+PJpAJI9+gPUkVmx0WPGHzI5Dyrhgg7h4RLrL91fQxX5UOg9YNw5mmm9AFKg/yBC
         EBUj2kc6rcC9NIjthiN2QPmrGuLYkoD5pOIYBwKjF0pSKQuw8ykgEBN36K4PXucHAPDY
         RLmQ==
X-Gm-Message-State: AJIora/QL5sj+wOxP7KE+EmAolV/JeLON+FlL9pL8H11jKHT91RD+ocl
        jA/567jHG11nG6AuEeW5mmV3uXvS8aYFYpYXEASCZoxSrML4Aa7/z6K3K6z3h7coLTn3A86TGOt
        GzXS4KJ/VnuYfNHCEl+cHxMQpyTPTrmb2
X-Received: by 2002:a05:6512:13a5:b0:47d:c1d9:dea8 with SMTP id p37-20020a05651213a500b0047dc1d9dea8mr1420550lfa.442.1655885189243;
        Wed, 22 Jun 2022 01:06:29 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tkxcyuPKm08huxiqWuTWt7AWd6nEXg9wjIHlQsqNsaLpWQeLuiYvLUwu9t7gVY0n8kDnn3TbP+HM4y52lv6qk=
X-Received: by 2002:a05:6512:13a5:b0:47d:c1d9:dea8 with SMTP id
 p37-20020a05651213a500b0047dc1d9dea8mr1420532lfa.442.1655885188954; Wed, 22
 Jun 2022 01:06:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220621114845.3650258-1-stephan.gerhold@kernkonzept.com>
In-Reply-To: <20220621114845.3650258-1-stephan.gerhold@kernkonzept.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 22 Jun 2022 16:06:17 +0800
Message-ID: <CACGkMEskKF4O7_Dz5=JxB2noVV5qJQusN9DLLzUFc4d149kS7g@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: fix xdp_rxq_info bug after suspend/resume
To:     Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 7:50 PM Stephan Gerhold
<stephan.gerhold@kernkonzept.com> wrote:
>
> The following sequence currently causes a driver bug warning
> when using virtio_net:
>
>   # ip link set eth0 up
>   # echo mem > /sys/power/state (or e.g. # rtcwake -s 10 -m mem)
>   <resume>
>   # ip link set eth0 down
>
>   Missing register, driver bug
>   WARNING: CPU: 0 PID: 375 at net/core/xdp.c:138 xdp_rxq_info_unreg+0x58/0x60
>   Call trace:
>    xdp_rxq_info_unreg+0x58/0x60
>    virtnet_close+0x58/0xac
>    __dev_close_many+0xac/0x140
>    __dev_change_flags+0xd8/0x210
>    dev_change_flags+0x24/0x64
>    do_setlink+0x230/0xdd0
>    ...
>
> This happens because virtnet_freeze() frees the receive_queue
> completely (including struct xdp_rxq_info) but does not call
> xdp_rxq_info_unreg(). Similarly, virtnet_restore() sets up the
> receive_queue again but does not call xdp_rxq_info_reg().
>
> Actually, parts of virtnet_freeze_down() and virtnet_restore_up()
> are almost identical to virtnet_close() and virtnet_open(): only
> the calls to xdp_rxq_info_(un)reg() are missing. This means that
> we can fix this easily and avoid such problems in the future by
> just calling virtnet_close()/open() from the freeze/restore handlers.
>
> Aside from adding the missing xdp_rxq_info calls the only difference
> is that the refill work is only cancelled if netif_running(). However,
> this should not make any functional difference since the refill work
> should only be active if the network interface is actually up.
>
> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/net/virtio_net.c | 25 ++++++-------------------
>  1 file changed, 6 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index db05b5e930be..969a67970e71 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2768,7 +2768,6 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>  static void virtnet_freeze_down(struct virtio_device *vdev)
>  {
>         struct virtnet_info *vi = vdev->priv;
> -       int i;
>
>         /* Make sure no work handler is accessing the device */
>         flush_work(&vi->config_work);
> @@ -2776,14 +2775,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
>         netif_tx_lock_bh(vi->dev);
>         netif_device_detach(vi->dev);
>         netif_tx_unlock_bh(vi->dev);
> -       cancel_delayed_work_sync(&vi->refill);
> -
> -       if (netif_running(vi->dev)) {
> -               for (i = 0; i < vi->max_queue_pairs; i++) {
> -                       napi_disable(&vi->rq[i].napi);
> -                       virtnet_napi_tx_disable(&vi->sq[i].napi);
> -               }
> -       }
> +       if (netif_running(vi->dev))
> +               virtnet_close(vi->dev);
>  }
>
>  static int init_vqs(struct virtnet_info *vi);
> @@ -2791,7 +2784,7 @@ static int init_vqs(struct virtnet_info *vi);
>  static int virtnet_restore_up(struct virtio_device *vdev)
>  {
>         struct virtnet_info *vi = vdev->priv;
> -       int err, i;
> +       int err;
>
>         err = init_vqs(vi);
>         if (err)
> @@ -2800,15 +2793,9 @@ static int virtnet_restore_up(struct virtio_device *vdev)
>         virtio_device_ready(vdev);
>
>         if (netif_running(vi->dev)) {
> -               for (i = 0; i < vi->curr_queue_pairs; i++)
> -                       if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
> -                               schedule_delayed_work(&vi->refill, 0);
> -
> -               for (i = 0; i < vi->max_queue_pairs; i++) {
> -                       virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
> -                       virtnet_napi_tx_enable(vi, vi->sq[i].vq,
> -                                              &vi->sq[i].napi);
> -               }
> +               err = virtnet_open(vi->dev);
> +               if (err)
> +                       return err;
>         }
>
>         netif_tx_lock_bh(vi->dev);
> --
> 2.30.2
>

