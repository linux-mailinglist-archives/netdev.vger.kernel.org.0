Return-Path: <netdev+bounces-8251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6929A7234AF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 03:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4DDE1C20E01
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B73388;
	Tue,  6 Jun 2023 01:44:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4B87F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:44:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17820E8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686015859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h6c7qR5QQL6O5muxAxTGbpH+uE3aElnAVDLZ6FGcR/0=;
	b=ZHpOLWesA6x+vFxNHqH/mMTaat+8G9WiAqw6+fscur+VXTKKRbSwlQy625NDYo+FfRdqZf
	tZUtT/C7jE4k+rD9L4b4RiwHSfoWsq4wyJOi/kxBOC74xIwA7o0MxZHKaGi0R617i2PjKL
	68jSX3zn6dNqzsKd6lpwLH7knU5Mc38=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-dO-sIWfpOKuHpzSqW-GHfA-1; Mon, 05 Jun 2023 21:44:18 -0400
X-MC-Unique: dO-sIWfpOKuHpzSqW-GHfA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4f621c76606so1383647e87.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 18:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686015856; x=1688607856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6c7qR5QQL6O5muxAxTGbpH+uE3aElnAVDLZ6FGcR/0=;
        b=JSceSBsqkRegwbXhZpAFWHPIpFxSc4HOc29pAZ+Kf5DDYCBM+Mvk98CJyWrXmCkE/l
         rMCKBZLD0NnsWRvb4Iz2vzf7ZBhJ/oMxiO9EpmYj0g4D6a7CmL1LujN8qKlJ//iP99mJ
         dM4AvE2EWe1RZXpNooOe441IgTvYbRsZrTin/thVzsdMifkP+0fyqBivp2MJ1bYkcZ2D
         kO76kqOZnII+SBWq2XG78qoc+TM12smpLfWTktw3znhsJyjetTea+44C0jWc8ZXNbAVH
         jcfGKGLLmeM8fK4q9IlfHRgt2RjmAizDZZ0IjFpnK+V5hVAsBeFfNz+trV3qMweQWgse
         oSdg==
X-Gm-Message-State: AC+VfDwtDesMFKWOWOOQ6KOBV8GIWnoD88vdH5pU9GMlpplkNkToO70D
	myleDsCIi8pick64msiLOJa7zbDoj7DkBTydn6ti4RTn0F1KgrcuR9iiGb5dz/0mwkfQ7RCRY0P
	yOeySikekYUkAva1I5KdZYnp+weQMH83F
X-Received: by 2002:a19:f811:0:b0:4f6:392:6917 with SMTP id a17-20020a19f811000000b004f603926917mr409091lff.34.1686015856764;
        Mon, 05 Jun 2023 18:44:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4LdqhwRhX6mWyAhRtL4quj5OgTJ37m/xJNaUVO3cTyp8wh7GV96jSwFQyT4Y3Rw2vO3pQ6Kflt1z/JonqWEvw=
X-Received: by 2002:a19:f811:0:b0:4f6:392:6917 with SMTP id
 a17-20020a19f811000000b004f603926917mr409084lff.34.1686015856464; Mon, 05 Jun
 2023 18:44:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605195925.51625-1-brett.creeley@amd.com>
In-Reply-To: <20230605195925.51625-1-brett.creeley@amd.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 6 Jun 2023 09:44:05 +0800
Message-ID: <CACGkMEvbWLZHeGww5_39BDkuKE1_L5YGAF6Wxq0u1cXPgdgf5g@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: use control_buf for coalesce params
To: Brett Creeley <brett.creeley@amd.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, alvaro.karsz@solid-run.com, 
	pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net, 
	xuanzhuo@linux.alibaba.com, mst@redhat.com, shannon.nelson@amd.com, 
	allen.hubbe@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 3:59=E2=80=AFAM Brett Creeley <brett.creeley@amd.com=
> wrote:
>
> Commit 699b045a8e43 ("net: virtio_net: notifications coalescing
> support") added coalescing command support for virtio_net. However,
> the coalesce commands are using buffers on the stack, which is causing
> the device to see DMA errors. There should also be a complaint from
> check_for_stack() in debug_dma_map_xyz(). Fix this by adding and using
> coalesce params from the control_buf struct, which aligns with other
> commands.
>
> Fixes: 699b045a8e43 ("net: virtio_net: notifications coalescing support")
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
> Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> ---
>  drivers/net/virtio_net.c | 16 ++++++++--------

The patch is needed for -stable I think.

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 56ca1d270304..486b5849033d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -205,6 +205,8 @@ struct control_buf {
>         __virtio16 vid;
>         __virtio64 offloads;
>         struct virtio_net_ctrl_rss rss;
> +       struct virtio_net_ctrl_coal_tx coal_tx;
> +       struct virtio_net_ctrl_coal_rx coal_rx;
>  };
>
>  struct virtnet_info {
> @@ -2934,12 +2936,10 @@ static int virtnet_send_notf_coal_cmds(struct vir=
tnet_info *vi,
>                                        struct ethtool_coalesce *ec)
>  {
>         struct scatterlist sgs_tx, sgs_rx;
> -       struct virtio_net_ctrl_coal_tx coal_tx;
> -       struct virtio_net_ctrl_coal_rx coal_rx;
>
> -       coal_tx.tx_usecs =3D cpu_to_le32(ec->tx_coalesce_usecs);
> -       coal_tx.tx_max_packets =3D cpu_to_le32(ec->tx_max_coalesced_frame=
s);
> -       sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> +       vi->ctrl->coal_tx.tx_usecs =3D cpu_to_le32(ec->tx_coalesce_usecs)=
;
> +       vi->ctrl->coal_tx.tx_max_packets =3D cpu_to_le32(ec->tx_max_coale=
sced_frames);
> +       sg_init_one(&sgs_tx, &vi->ctrl->coal_tx, sizeof(vi->ctrl->coal_tx=
));
>
>         if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
>                                   VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> @@ -2950,9 +2950,9 @@ static int virtnet_send_notf_coal_cmds(struct virtn=
et_info *vi,
>         vi->tx_usecs =3D ec->tx_coalesce_usecs;
>         vi->tx_max_packets =3D ec->tx_max_coalesced_frames;
>
> -       coal_rx.rx_usecs =3D cpu_to_le32(ec->rx_coalesce_usecs);
> -       coal_rx.rx_max_packets =3D cpu_to_le32(ec->rx_max_coalesced_frame=
s);
> -       sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> +       vi->ctrl->coal_rx.rx_usecs =3D cpu_to_le32(ec->rx_coalesce_usecs)=
;
> +       vi->ctrl->coal_rx.rx_max_packets =3D cpu_to_le32(ec->rx_max_coale=
sced_frames);
> +       sg_init_one(&sgs_rx, &vi->ctrl->coal_rx, sizeof(vi->ctrl->coal_rx=
));
>
>         if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
>                                   VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> --
> 2.17.1
>


