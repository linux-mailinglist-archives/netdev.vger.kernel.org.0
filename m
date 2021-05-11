Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E85137AD56
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhEKRtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhEKRtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 13:49:13 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551A1C06174A
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 10:48:06 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id b25so30977564eju.5
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 10:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tXU/u/oI0c/X+zEdSbjxSjUwDdEq6XptIKJISi7rLG4=;
        b=MW+jnvnJIKnOGEtUwz3fsZFljt3ifuyz+WcJOv9QbqR3U2V0/NEvqymsIPF5umUnPa
         n33vPvd5/pV04hDrPogIfeHSHw3/5t/Tw18SowZjV5KRFhEqo53ycPeWzNXZJK0vrygI
         2vdof3xPopC/8A3cK/cyPI92FtKVLjcJgCgI92yRKI3fSL1MbWf7DXTC5nmlSh7k7bKT
         xKx/RDXI2UpE63LVp7qr+/fbudVqiymDhuwPb2LQOgahSE9OAOqxqh/qSlAecMo9Niyv
         flgWhOIljYicY1kR15yAy7mDnLQkVAaueQyvWsVLdf5nBNIQKWydzX3qygCukvXMZKnR
         i3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tXU/u/oI0c/X+zEdSbjxSjUwDdEq6XptIKJISi7rLG4=;
        b=UISXfx/WYnQ/EhOqmUAiH+6RaC+jmWeOZq3TSiMHnC7lQPuv4i0dO+lBWDettOBWe8
         X76VklJo/9i/Lb0IPMs7bqSptb4x4D3m4oey7djla5bvzgL0ZgPXXqRKLNelWqPa7mLz
         ull5W8ZsB25ajAvQ4xSnD0j7b3a+phRi5MUJykPZkvaYtAYH5O4KZVJndjHIkGxAecbD
         Nda+4QN+jikQ3nMEN7V3QVTwBUgnEhylUAA6tEI+lBg9f2uQwBWRWO32V22/yfUeoBUh
         tt+RWN7/+4Zpff3Wybf50KOW+H3iLw9Z4kGYtJj53vUjiAbzIeR82dDm4F6bSZZ/qWHH
         e5gg==
X-Gm-Message-State: AOAM531vvCmkYaZrcgMj2/YhP2W5Rni6w6Z5G15WqnPjjfZ9gYLI9cut
        qTGPyjxD34qT3h1hy/La/CofnscpzOs=
X-Google-Smtp-Source: ABdhPJzEXNTAYJMOhjwSGsefF0rCiTrZvFyQKqe82ECDxpZaFSfJcty8fb1qqM61+gMmrkYvqkB7cw==
X-Received: by 2002:a17:907:1c15:: with SMTP id nc21mr33652618ejc.49.1620755284458;
        Tue, 11 May 2021 10:48:04 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id g9sm12104466ejo.8.2021.05.11.10.48.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 10:48:03 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id s8so21008750wrw.10
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 10:48:03 -0700 (PDT)
X-Received: by 2002:a5d:6285:: with SMTP id k5mr4589508wru.50.1620755283209;
 Tue, 11 May 2021 10:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com> <20210511044253.469034-3-yuri.benditovich@daynix.com>
In-Reply-To: <20210511044253.469034-3-yuri.benditovich@daynix.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 11 May 2021 13:47:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdfA6sT68AJNpa=VPBdwRFHvEY+=C-B_mS=y=WMpTyc=Q@mail.gmail.com>
Message-ID: <CA+FuTSdfA6sT68AJNpa=VPBdwRFHvEY+=C-B_mS=y=WMpTyc=Q@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtio-net: add support of UDP segmentation (USO) on
 the host
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 12:43 AM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> Large UDP packet provided by the guest with GSO type set to
> VIRTIO_NET_HDR_GSO_UDP_L4 will be divided to several UDP
> packets according to the gso_size field.
>
> Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> ---
>  include/linux/virtio_net.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index b465f8f3e554..4ecf9a1ca912 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -51,6 +51,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                         ip_proto = IPPROTO_UDP;
>                         thlen = sizeof(struct udphdr);
>                         break;
> +               case VIRTIO_NET_HDR_GSO_UDP_L4:
> +                       gso_type = SKB_GSO_UDP_L4;
> +                       ip_proto = IPPROTO_UDP;
> +                       thlen = sizeof(struct udphdr);
> +                       break;

If adding a new VIRTIO_NET_HDR type I suggest adding separate IPv4 and
IPv6 variants, analogous to VIRTIO_NET_HDR_GSO_TCPV[46]. To avoid
having to infer protocol again, as for UDP fragmentation offload (the
retry case below this code).
