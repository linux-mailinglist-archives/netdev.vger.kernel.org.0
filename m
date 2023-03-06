Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7276AB518
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 04:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCFDku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 22:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjCFDkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 22:40:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084CBEF9A
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 19:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678073997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2raSa3hUXrD0UxgB5JD2asiwlzXPJgZKFQwSYhV7VHo=;
        b=GZLPMUkF7RK2EVnIUJl/lBkRYfTjx3jxOdqfrFG9ml2iCFna7eyfNcARulr7obBZ3iPjNI
        5AqnHrWUBYVz5h0lquFwHNdnX2x5zqeoV1Ugf3yavJBReZrNMgDiyjooZz5sEED14e+zmY
        S4QhTJB06Tvvf4ybZMOPL0mbsGnzCMA=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-IdqXuZ6LMXqcVcucj6CAww-1; Sun, 05 Mar 2023 22:39:56 -0500
X-MC-Unique: IdqXuZ6LMXqcVcucj6CAww-1
Received: by mail-ot1-f71.google.com with SMTP id k5-20020a056830168500b00690d1e0d27dso3817965otr.0
        for <netdev@vger.kernel.org>; Sun, 05 Mar 2023 19:39:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678073995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2raSa3hUXrD0UxgB5JD2asiwlzXPJgZKFQwSYhV7VHo=;
        b=z/wVRoQxtJXlQOF6MWy8Xbh/RaXy1/2/FifoVwKgnRZnOKN8/L1QGOsOB2z4ugI9Qn
         65xZ7oT3eHU80RHzrZs2UHR4KFVY5LGvvZE6pKj/Xk2cNaum5OW5SrvxtnBdtc2OZ/9u
         y+vnVjmiVDb8cHEtT6cW4v5aLMiV66GPz2FUob1ESC8sQqF9T1Nkjxt6B2rds6R3HSXq
         ZdWVWRuY3VsU96uskE7o7dpo9r7zGsIYwGvjN2izhBhtECCMewmV+JrGDi+nbtQYE0rO
         IfCJX3oRcoXS+Utgk57d1dlkAjJ646Xct3+vxyRV2pvcn/3VNsxsCrkXG9yd3E/5Oe3m
         m45A==
X-Gm-Message-State: AO0yUKVw5sGaAioLxwaTNgez+sFjsGusvUh6OXGJlrIUOiiNfL88dlyj
        +3f67RAomUHXbrYBrB5QDeohOywlzQvkRRnq48ej/3Jr3z5qn65nJuKhX5H7RsVCodkO9DgSoWJ
        mBd0oBncLmiN1EW+m/zv3yOV3jBvAxdv6
X-Received: by 2002:a05:6808:143:b0:383:fef9:6cac with SMTP id h3-20020a056808014300b00383fef96cacmr3010761oie.9.1678073995469;
        Sun, 05 Mar 2023 19:39:55 -0800 (PST)
X-Google-Smtp-Source: AK7set+NvN/Yhk2koNFmx2bScLZ46uREUzaqxEZnnpvOmqWcUrK4gI747FAPVMXfQqCfUURXUHiB+nsMAQFXT0Pcw/w=
X-Received: by 2002:a05:6808:143:b0:383:fef9:6cac with SMTP id
 h3-20020a056808014300b00383fef96cacmr3010754oie.9.1678073995222; Sun, 05 Mar
 2023 19:39:55 -0800 (PST)
MIME-Version: 1.0
References: <20230305154942.1770925-1-alvaro.karsz@solid-run.com>
In-Reply-To: <20230305154942.1770925-1-alvaro.karsz@solid-run.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 6 Mar 2023 11:39:44 +0800
Message-ID: <CACGkMEuc_MtVpM2bJH20dmXC30Po8Fbd2Y-xv-Q=O13=pLSLpA@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: unify notifications coalescing structs
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 5, 2023 at 11:49=E2=80=AFPM Alvaro Karsz <alvaro.karsz@solid-ru=
n.com> wrote:
>
> Unify virtio_net_ctrl_coal_tx and virtio_net_ctrl_coal_rx structs into a
> single struct, virtio_net_ctrl_coal, as they are identical.
>
> This patch follows the VirtIO spec patch:
> https://lists.oasis-open.org/archives/virtio-comment/202302/msg00431.html
>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
>  drivers/net/virtio_net.c        | 15 +++++++--------
>  include/uapi/linux/virtio_net.h | 24 +++++++-----------------
>  2 files changed, 14 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index fb5e68ed3ec..86b6b3e0257 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2883,12 +2883,11 @@ static int virtnet_send_notf_coal_cmds(struct vir=
tnet_info *vi,
>                                        struct ethtool_coalesce *ec)
>  {
>         struct scatterlist sgs_tx, sgs_rx;
> -       struct virtio_net_ctrl_coal_tx coal_tx;
> -       struct virtio_net_ctrl_coal_rx coal_rx;
> +       struct virtio_net_ctrl_coal coal_params;
>
> -       coal_tx.tx_usecs =3D cpu_to_le32(ec->tx_coalesce_usecs);
> -       coal_tx.tx_max_packets =3D cpu_to_le32(ec->tx_max_coalesced_frame=
s);
> -       sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> +       coal_params.max_usecs =3D cpu_to_le32(ec->tx_coalesce_usecs);
> +       coal_params.max_packets =3D cpu_to_le32(ec->tx_max_coalesced_fram=
es);
> +       sg_init_one(&sgs_tx, &coal_params, sizeof(coal_params));
>
>         if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
>                                   VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> @@ -2899,9 +2898,9 @@ static int virtnet_send_notf_coal_cmds(struct virtn=
et_info *vi,
>         vi->tx_usecs =3D ec->tx_coalesce_usecs;
>         vi->tx_max_packets =3D ec->tx_max_coalesced_frames;
>
> -       coal_rx.rx_usecs =3D cpu_to_le32(ec->rx_coalesce_usecs);
> -       coal_rx.rx_max_packets =3D cpu_to_le32(ec->rx_max_coalesced_frame=
s);
> -       sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> +       coal_params.max_usecs =3D cpu_to_le32(ec->rx_coalesce_usecs);
> +       coal_params.max_packets =3D cpu_to_le32(ec->rx_max_coalesced_fram=
es);
> +       sg_init_one(&sgs_rx, &coal_params, sizeof(coal_params));
>
>         if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
>                                   VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_=
net.h
> index b4062bed186..ce044260e02 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -367,28 +367,18 @@ struct virtio_net_hash_config {
>   * Available with the VIRTIO_NET_F_NOTF_COAL feature bit.
>   */
>  #define VIRTIO_NET_CTRL_NOTF_COAL              6
> -/*
> - * Set the tx-usecs/tx-max-packets parameters.
> - */
> -struct virtio_net_ctrl_coal_tx {
> -       /* Maximum number of packets to send before a TX notification */
> -       __le32 tx_max_packets;
> -       /* Maximum number of usecs to delay a TX notification */
> -       __le32 tx_usecs;
> -};

Is this too late to be changed?

Thanks

> -
> -#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET               0
>
>  /*
> - * Set the rx-usecs/rx-max-packets parameters.
> + * Set the max_usecs/max_packets coalescing parameters for all transmit/=
receive virtqueues.
>   */
> -struct virtio_net_ctrl_coal_rx {
> -       /* Maximum number of packets to receive before a RX notification =
*/
> -       __le32 rx_max_packets;
> -       /* Maximum number of usecs to delay a RX notification */
> -       __le32 rx_usecs;
> +struct virtio_net_ctrl_coal {
> +       /* Maximum number of packets to send/receive before a TX/RX notif=
ication */
> +       __le32 max_packets;
> +       /* Maximum number of microseconds to delay a TX/RX notification *=
/
> +       __le32 max_usecs;
>  };
>
> +#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET               0
>  #define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET               1
>
>  #endif /* _UAPI_LINUX_VIRTIO_NET_H */
> --
> 2.34.1
>

