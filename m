Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF550D961
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 08:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiDYGZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 02:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiDYGZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 02:25:10 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF893D1F3
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 23:22:06 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d15so10308395plh.2
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 23:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D2vHRbKU83FDdxIr2wThti/Jzife/Zg94mt0wK6kucU=;
        b=HI/qlRcukuoPFUHvIds29zjaJxgjbciChYE6qBesoE7mZndS1evUUKWs1+L0YXe98d
         WAeY2RgTouWWOSvUY15fQvdk17D/ZGsyzVMcOyZ3uezFfG+rPyPcHJwawH2O25g0bNe8
         KQGRIuVyA1Q9bdgKsJWWhgQsXK+Nn0rtk7DF0PSMRoAgViNbtUGR6UvRJGdd6AX+6o8+
         cDVAJoQk13nZovnF0gW89a7SRHmlR9nyBQgw0+/ZmbkP9Fa8Fb4rQ6yrCRVwbJ+ChYP+
         0mkuxsrnuEI6GHj3MIWQAOMcbcWaTz9mHZVa4lTu37loekf7njBxrqyQbi5cieV5mS+2
         ZqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D2vHRbKU83FDdxIr2wThti/Jzife/Zg94mt0wK6kucU=;
        b=FRzYVeD6ScMNowV7b07Lni8MaVH/vMJtoCHPiFgeVvwEXu/VwjZanMyoEpyI8kualh
         V1WYl2ifhoVD0/UnJN6pwO38ldBdLNUMBCLPcKlmExdRP+tZsWYJEd7UvH/Ly5YlVDvG
         37ttpVIOfgDVmDXOg7htS8N/wotLRuAio7I66ge7HAi9oMyryI9KU6W3TPlq96A/El3H
         qAIQKjvuijVsQsV4y6ilkaedDf8bTNvN0yjyTW+rpJiMYgoEawAG0hgUByfjoDjOqwEP
         5CV3rv1Xfs3Uzky7u2hXHv5Dj3bwLANGoeAhun0mNKjElkBzpJucPsabmcHIcLWL4HMC
         AeJw==
X-Gm-Message-State: AOAM53123bT6HzoTz5RgItZYtsBW5RFpbt9G9P+0z0fMrMZA7fEOLfJ7
        nVZS1rqLaz7a8IsenElpDIX5/D7BhwE=
X-Google-Smtp-Source: ABdhPJzXgiekNuywSfVfQ4zrv93nOBylKKPOmbrd5ZyqggFnC4sFHEn/lVRu5Nhvj/Jcqi+qU4H4Og==
X-Received: by 2002:a17:902:f605:b0:14d:9e11:c864 with SMTP id n5-20020a170902f60500b0014d9e11c864mr16456741plg.54.1650867726097;
        Sun, 24 Apr 2022 23:22:06 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y126-20020a62ce84000000b0050d223013b6sm6538772pfg.11.2022.04.24.23.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 23:22:05 -0700 (PDT)
Date:   Mon, 25 Apr 2022 14:21:58 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCHv2 net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
Message-ID: <YmY+BoBGnzwMiEba@Laptop-X1>
References: <20220425014502.985464-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425014502.985464-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cc Willem as I didn't format the address correctly.

On Mon, Apr 25, 2022 at 09:45:02AM +0800, Hangbin Liu wrote:
> Currently, the kernel drops GSO VLAN tagged packet if it's created with
> socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
> 
> The reason is AF_PACKET doesn't adjust the skb network header if there is
> a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
> will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
> is dropped as network header position is invalid.
> 
> Let's handle VLAN packets by adjusting network header position in
> packet_parse_headers(). The adjustment is safe and does not affect the
> later xmit as tap device also did that.
> 
> In packet_snd(), packet_parse_headers() need to be moved before calling
> virtio_net_hdr_set_proto(), so we can set correct skb->protocol and
> network header first.
> 
> There is no need to update tpacket_snd() as it calls packet_parse_headers()
> in tpacket_fill_skb(), which is already before calling virtio_net_hdr_*
> functions.
> 
> skb->no_fcs setting is also moved upper to make all skb settings together
> and keep consistency with function packet_sendmsg_spkt().
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> 
> v2: Rewrite commit description, no code update.
> ---
>  net/packet/af_packet.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 243566129784..fd31334cf688 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -1924,12 +1924,20 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
>  
>  static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
>  {
> +	int depth;
> +
>  	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
>  	    sock->type == SOCK_RAW) {
>  		skb_reset_mac_header(skb);
>  		skb->protocol = dev_parse_header_protocol(skb);
>  	}
>  
> +	/* Move network header to the right position for VLAN tagged packets */
> +	if (likely(skb->dev->type == ARPHRD_ETHER) &&
> +	    eth_type_vlan(skb->protocol) &&
> +	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
> +		skb_set_network_header(skb, depth);
> +
>  	skb_probe_transport_header(skb);
>  }
>  
> @@ -3047,6 +3055,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  	skb->mark = sockc.mark;
>  	skb->tstamp = sockc.transmit_time;
>  
> +	if (unlikely(extra_len == 4))
> +		skb->no_fcs = 1;
> +
> +	packet_parse_headers(skb, sock);
> +
>  	if (has_vnet_hdr) {
>  		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>  		if (err)
> @@ -3055,11 +3068,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>  		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>  	}
>  
> -	packet_parse_headers(skb, sock);
> -
> -	if (unlikely(extra_len == 4))
> -		skb->no_fcs = 1;
> -
>  	err = po->xmit(skb);
>  	if (unlikely(err != 0)) {
>  		if (err > 0)
> -- 
> 2.35.1
> 
