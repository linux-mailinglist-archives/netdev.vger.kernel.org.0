Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1436A1539
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjBXDMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjBXDMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:12:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F5F5EEFD
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 19:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677208311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ce5tfl2n/EssbKt11AP0PiIJ95ywSk+f7JnIMaHI1Wk=;
        b=Bq2S3V4dzEu83xOgYWzZr+zlld+eFtAlNrMtccxw4QQSt9bTCR9/UYBTrJtlo6Ovau8sr2
        unWoMfbOYlDDU7vdejsOV5NCWe0akXUgtiaZMyNdjC1rAvqi8Y+NzNSGfMAq2bjGgv6SBe
        Sm3ArBiFSk5xiRE3i5PXBGjzPJD610Q=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-467-KnkBscS8Pc6kjGFXL6huOQ-1; Thu, 23 Feb 2023 22:11:49 -0500
X-MC-Unique: KnkBscS8Pc6kjGFXL6huOQ-1
Received: by mail-ot1-f70.google.com with SMTP id c12-20020a9d684c000000b00693d5c2d242so1268714oto.23
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 19:11:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ce5tfl2n/EssbKt11AP0PiIJ95ywSk+f7JnIMaHI1Wk=;
        b=lF8Ue8mswHsUO8p7QxJCy4sbqAoCh6mVaFliBRil/HNZJCIi8nSPanQ3HIFzOuPQ1A
         /QuGheJO4t+l8xW9+rpldVPx/sqRV3+LYD1kdyWc5vGc8toMl9+SO7T3uSXVmbTBAKgP
         1PGSpd7nAZVBeH+xw68LLLWArA1v5fx1ldz6WdkNNQIL+zdkuX1dSIXcm+KKVrjcBHQO
         Sb/8n5YioaR0UDcpik3isusQYedHp1lSs3QNgpw88Cuotb/lsoEfNG0i+rPb+nzZ1meN
         IcAYJbVz+O3fM7AEXpBZJyzPu28X+3lO/pFPsmKdLFdedZI/j8Ap41ssQJpYU280TYHP
         ItYw==
X-Gm-Message-State: AO0yUKXLtkay8euh09ZOAkfqyb2ODZGxuaF7cNIWeTio/wgeR+hftO4y
        j+LnWbatoLx5wjykxYN8kkqcu19V3S3gClu7u9XDTwZc37NgHKGJ2qRaK0Dky6QhoLgiIa/NveJ
        7Fr4WgJ/8HxFlzIdzZV7gHCdcXYUeg9sw
X-Received: by 2002:a05:6808:6c9:b0:383:c688:a8e0 with SMTP id m9-20020a05680806c900b00383c688a8e0mr725790oih.9.1677208309041;
        Thu, 23 Feb 2023 19:11:49 -0800 (PST)
X-Google-Smtp-Source: AK7set+gu9v2kcBbZccH/ZaJz3PndJ8R+g8ZrRudTxgfmD3x81zCiyAktZ0EKcq2Yuereo2Z41aHL/7pYEkRPXgsh0s=
X-Received: by 2002:a05:6808:6c9:b0:383:c688:a8e0 with SMTP id
 m9-20020a05680806c900b00383c688a8e0mr725779oih.9.1677208308153; Thu, 23 Feb
 2023 19:11:48 -0800 (PST)
MIME-Version: 1.0
References: <20230223-virtio-net-kvmtool-v2-1-8ec93511e67f@rivosinc.com>
In-Reply-To: <20230223-virtio-net-kvmtool-v2-1-8ec93511e67f@rivosinc.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 24 Feb 2023 11:11:37 +0800
Message-ID: <CACGkMEu8JtT9_0YcbmfWCGxbrB1GHnesnspFYgaeVrb2x3o3oQ@mail.gmail.com>
Subject: Re: [PATCH v2] virtio-net: Fix probe of virtio-net on kvmtool
To:     rbradford@rivosinc.com
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 3:38 AM Rob Bradford via B4 Relay
<devnull+rbradford.rivosinc.com@kernel.org> wrote:
>
> From: Rob Bradford <rbradford@rivosinc.com>
>
> kvmtool does not support the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature
> but does advertise the VIRTIO_NET_F_GUEST_TSO{4,6} features. Check that
> the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature is present before setting
> the NETIF_F_GRO_HW feature bit as otherwise an attempt will be made to
> program the virtio-net device using the ctrl queue which will fail.
>
> This resolves the following error when running on kvmtool:
>
> [    1.865992] net eth0: Fail to set guest offload.
> [    1.872491] virtio_net virtio2 eth0: set_features() failed (-22); wanted 0x0000000000134829, left 0x0080000000134829
>
> Signed-off-by: Rob Bradford <rbradford@rivosinc.com>
> ---
> Changes in v2:
> - Use parentheses to group logical OR of features
> - Link to v1:
>   https://lore.kernel.org/r/20230223-virtio-net-kvmtool-v1-1-fc23d29b9d7a@rivosinc.com
> ---
>  drivers/net/virtio_net.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 61e33e4dd0cd..f8341d1a4ccd 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3780,10 +3780,9 @@ static int virtnet_probe(struct virtio_device *vdev)
>         }
>         if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
>                 dev->features |= NETIF_F_RXCSUM;
> -       if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
> -               dev->features |= NETIF_F_GRO_HW;
> -       if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> +       if ((virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> +           virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6)) &&
> +           virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
>                 dev->hw_features |= NETIF_F_GRO_HW;

Does this mean we won't have NETIF_F_GRO_HW when only TSO4/TSO6 are
supported but not GUEST_OFFLOADS?

Is this intended?

Thanks

>
>         dev->vlan_features = dev->features;
>
> ---
> base-commit: c39cea6f38eefe356d64d0bc1e1f2267e282cdd3
> change-id: 20230223-virtio-net-kvmtool-87f37515be22
>
> Best regards,
> --
> Rob Bradford <rbradford@rivosinc.com>
>

