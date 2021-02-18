Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B11731ED70
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhBRRiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhBRPwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 10:52:37 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 133E3C061574
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 07:51:18 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g3so4895921edb.11
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 07:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vRWwBoukUWpf3kaTTQrlN4IVGff71cdIbdnfQeS/5Ko=;
        b=ZVoi+oDtUzlcdEftLSGeZhPJ2XfgGG18MLP6hZBH6xqL/SbYLgcIyQcpiW7B3eIVHg
         JTUcIBighF7XrK/6WhbfwshV0nZbSMWBiaUICBZhk3Zz6+RZ4mgQXDccbbV+Ow6Cca7x
         HPHX1sO/l0NCL0FBm5ZR3SVOcOtNa3KF4lq3tJX8OcmA4w7fxoo69WX2hWcOlOlwBIpV
         RM36Jnkn3ChZmluCRMIg0UHhZsykSrg5Uo4Ygwbd/nJYp9c3aBYyL544OtNbLVYi5oxD
         tlih6vyHpTm8EAkuDky1TDHxk5jpzgSpksejmXWGu07y959dgwi9LT3ZSSTET4WstBVK
         /stA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vRWwBoukUWpf3kaTTQrlN4IVGff71cdIbdnfQeS/5Ko=;
        b=P6jU6GPsgN1W+PjyhK02N5BoaC7azsdKuFWVgPFP5q+NfI0z8VJGU21YeRYUk2EmFY
         wFtDWeAyTX+b7M9QFXgVHVcGB26J3HBNr9bsjatBgqksPLVPLpqddbko59eMjECrKgBL
         w9PkNSx2uad74OmRYEzKZxntmXgDBVs0MX8DRBdtu5kFNupxvswZR1cq3TpCCRwQKoKm
         vvrRixhcpJB+E9js6BwFncwOGIVyB2st2upuVunWfm9Qsn7Vc0pE92gPJncdhsh6J3As
         FEfel7+NxBAeu1m1oe3W77AXBCMJYJZISOHBALvN+5+MDpy62Z5cRxBocg1SYYUFU/Eb
         zzPQ==
X-Gm-Message-State: AOAM5317e5xe7UMErXuKX3orvtM2qzKFhzSMXXgxE6QHGIxO1sE6AQaB
        2FivJ4k27o3uEQR1qXjacYQk9XjxTaM=
X-Google-Smtp-Source: ABdhPJxDUCOpP6yGHlkcKwmLgCfOcnmsPuj8eK1qAfxwu5MqhHznqD8Sl/QvRJJCVXh3x7kqOdli7A==
X-Received: by 2002:aa7:c0d4:: with SMTP id j20mr4774872edp.318.1613663476550;
        Thu, 18 Feb 2021 07:51:16 -0800 (PST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id v9sm2740414ejd.92.2021.02.18.07.51.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 07:51:15 -0800 (PST)
Received: by mail-wr1-f49.google.com with SMTP id a4so1285017wro.8
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 07:51:14 -0800 (PST)
X-Received: by 2002:a5d:4b84:: with SMTP id b4mr5020550wrt.50.1613663474248;
 Thu, 18 Feb 2021 07:51:14 -0800 (PST)
MIME-Version: 1.0
References: <5e910d11a14da17c41317417fc41d3a9d472c6e7.1613659844.git.bnemeth@redhat.com>
In-Reply-To: <5e910d11a14da17c41317417fc41d3a9d472c6e7.1613659844.git.bnemeth@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Feb 2021 10:50:37 -0500
X-Gmail-Original-Message-ID: <CA+FuTSe7srSBnAmFNFBFkDrLmPL5XtxhbXEs1mBytUBuuym2fg@mail.gmail.com>
Message-ID: <CA+FuTSe7srSBnAmFNFBFkDrLmPL5XtxhbXEs1mBytUBuuym2fg@mail.gmail.com>
Subject: Re: [PATCH] net: check if protocol extracted by virtio_net_hdr_set_proto
 is correct
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

On Thu, Feb 18, 2021 at 10:01 AM Balazs Nemeth <bnemeth@redhat.com> wrote:
>
> For gso packets, virtio_net_hdr_set_proto sets the protocol (if it isn't
> set) based on the type in the virtio net hdr, but the skb could contain
> anything since it could come from packet_snd through a raw socket. If
> there is a mismatch between what virtio_net_hdr_set_proto sets and
> the actual protocol, then the skb could be handled incorrectly later
> on by gso.
>
> The network header of gso packets starts at 14 bytes, but a specially
> crafted packet could fool the call to skb_flow_dissect_flow_keys_basic
> as the network header offset in the skb could be incorrect.
> Consequently, EINVAL is not returned.
>
> There are even packets that can cause an infinite loop. For example, a
> packet with ethernet type ETH_P_MPLS_UC (which is unnoticed by
> virtio_net_hdr_to_skb) that is sent to a geneve interface will be
> handled by geneve_build_skb. In turn, it calls
> udp_tunnel_handle_offloads which then calls skb_reset_inner_headers.
> After that, the packet gets passed to mpls_gso_segment. That function
> calculates the mpls header length by taking the difference between
> network_header and inner_network_header. Since the two are equal
> (due to the earlier call to skb_reset_inner_headers), it will calculate
> a header of length 0, and it will not pull any headers. Then, it will
> call skb_mac_gso_segment which will again call mpls_gso_segment, etc...
> This leads to the infinite loop.
>
> For that reason, address the root cause of the issue: don't blindly
> trust the information provided by the virtio net header. Instead,
> check if the protocol in the packet actually matches the protocol set by
> virtio_net_hdr_set_proto.
>
> Fixes: 9274124f023b ("net: stricter validation of untrusted gso packets")
> Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
> ---
>  include/linux/virtio_net.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index e8a924eeea3d..cf2c53563f22 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -79,8 +79,13 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>                 if (gso_type && skb->network_header) {
>                         struct flow_keys_basic keys;
>
> -                       if (!skb->protocol)
> +                       if (!skb->protocol) {
> +                               const struct ethhdr *eth = skb_eth_hdr(skb);
> +

Unfortunately, cannot assume that the device type is ARPHRD_ETHER.

The underlying approach is sound: packets that have a gso type set in
the virtio_net_hdr have to be IP packets.

>                                 virtio_net_hdr_set_proto(skb, hdr);
> +                               if (skb->protocol != eth->h_proto)
> +                                       return -EINVAL;
> +                       }
>  retry:
>                         if (!skb_flow_dissect_flow_keys_basic(NULL, skb, &keys,
>                                                               NULL, 0, 0, 0,
> --
> 2.29.2
>
