Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7863312C8
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhCHQCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:02:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhCHQCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:02:18 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374E1C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 08:02:18 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jt13so21475896ejb.0
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 08:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NxiEy8ngZSokddcTCYt4nwbLH8RmaBWtr4TL2Y05SAk=;
        b=saj2O1QdxK6slYJFU1OOFaCUnduRugIlRrckll+J7guPfb2NP8uN3xVMlAJuW8kE/1
         yOxLpDxeUqurKTGsL9bh9pHi9R3GYLFqJgW+GttJ9QaaepqCydx35O57yyeqv/WZ7A86
         G0k8y6bzsEm9SYx1NGh66aoWZAw/79OvaV7AOaGrLpifMFgHZciNwEDKGg17t2Pjmy87
         IX5p+k1sYcLPuRW2PC9eXIP2JRoVUn3lf8l/w/5rn5QJMXYofAuDp1f7QUhDMxX5e/hP
         Ne8Tply/7orVzVAgwypbC2CvEn35RLbdRZ5fNtw08EIjS0ka+n0+UG+livh+IApV52XN
         vssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NxiEy8ngZSokddcTCYt4nwbLH8RmaBWtr4TL2Y05SAk=;
        b=kKyXkNJyyLOBsIVibBSto/BTN04iSkx4iPebMJfTt5MnsWA1+Ip9Xn6XHnyRQ3hhgc
         YtiOftqE2Rqx/AD9Mm3JopE/fA6zEEj+bFN5rfMqzh7K5EfpITIn2FEUTzREpj8fOtgv
         +jNOmVw9YhFnRCzpvnKvGmaEqFMXDaEJ2NJPccz0O2yB8OOXQzz5vIP9L2RUzur7dC6S
         IGv2KRfgaS1Zw1KOxzUaHLz9kX3aLzG0HDmBORug+RMb0mcgoiYqsKkK2yLt1ePbnPll
         hVXn94orGMD5aC9xMNHX3SOelp4biaPt8oO6x4KC9rPp58Cra4kNnOllDhgl4m66P75F
         pX9Q==
X-Gm-Message-State: AOAM533gQspb4aR6l2+YCbsIUJ9oq6fB0LRVldEqY8MNRN+PP6E1UQuu
        OwVzIu+HeGF8Lvm6RuH1VBmXyVlkLqA=
X-Google-Smtp-Source: ABdhPJxhUUvnw+B8IiVdVcGlIrX87OhaiMf9cMsOJIy3Zm9H9Dpdu9RLU1LqZtKSF/umSEyC4MCB2g==
X-Received: by 2002:a17:906:7c48:: with SMTP id g8mr15927532ejp.138.1615219336581;
        Mon, 08 Mar 2021 08:02:16 -0800 (PST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id h15sm4713882edb.74.2021.03.08.08.02.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 08:02:15 -0800 (PST)
Received: by mail-wm1-f53.google.com with SMTP id 124-20020a1c00820000b029010b871409cfso4108043wma.4
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 08:02:14 -0800 (PST)
X-Received: by 2002:a05:600c:198c:: with SMTP id t12mr22392924wmq.183.1615219334650;
 Mon, 08 Mar 2021 08:02:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1615199056.git.bnemeth@redhat.com> <8f2cb8f8614d86bba02df73c1a0665179583f1c3.1615199056.git.bnemeth@redhat.com>
In-Reply-To: <8f2cb8f8614d86bba02df73c1a0665179583f1c3.1615199056.git.bnemeth@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 8 Mar 2021 11:01:35 -0500
X-Gmail-Original-Message-ID: <CA+FuTSduKqeLB8wcLxiZXHgQF6y596F-nt+UwzUZngdTWwZ_rA@mail.gmail.com>
Message-ID: <CA+FuTSduKqeLB8wcLxiZXHgQF6y596F-nt+UwzUZngdTWwZ_rA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] net: check if protocol extracted by
 virtio_net_hdr_set_proto is correct
To:     Balazs Nemeth <bnemeth@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 5:32 AM Balazs Nemeth <bnemeth@redhat.com> wrote:
>
> For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
> set) based on the type in the virtio net hdr, but the skb could contain
> anything since it could come from packet_snd through a raw socket. If
> there is a mismatch between what virtio_net_hdr_set_proto sets and
> the actual protocol, then the skb could be handled incorrectly later
> on.
>
> An example where this poses an issue is with the subsequent call to
> skb_flow_dissect_flow_keys_basic which relies on skb->protocol being set
> correctly. A specially crafted packet could fool
> skb_flow_dissect_flow_keys_basic preventing EINVAL to be returned.
>
> Avoid blindly trusting the information provided by the virtio net header
> by checking that the protocol in the packet actually matches the
> protocol set by virtio_net_hdr_set_proto. Note that since the protocol
> is only checked if skb->dev implements header_ops->parse_protocol,
> packets from devices without the implementation are not checked at this
> stage.
>
> Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
> Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>

Going forward, please mark your the patch as targeting the net tree
using [PATCH net]

> ---
>  include/linux/virtio_net.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index e8a924eeea3d..6c478eee0452 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -79,8 +79,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                 if (gso_type && skb->network_header) {
>                         struct flow_keys_basic keys;
>
> -                       if (!skb->protocol)
> +                       if (!skb->protocol) {
> +                               const struct ethhdr *eth = skb_eth_hdr(skb);

eth is no longer used.

> +                               __be16 etype = dev_parse_header_protocol(skb);

nit: customary to call this protocol. etype, I guess short for
EtherType, makes sense, but is not commonly used in the kernel.

> +
>                                 virtio_net_hdr_set_proto(skb, hdr);
> +                               if (etype && etype != skb->protocol)
> +                                       return -EINVAL;
> +                       }
>  retry:
>                         if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>                                                               NULL, 0, 0, 0,
> --
> 2.29.2
>
