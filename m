Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2D450E26A
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbiDYN4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242261AbiDYN4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACF5665D2E
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650894794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nBg8jJRFE9H3jBPTzJSIhqUr6FVHcI4D/7txybv4HqI=;
        b=FbBwp6Kly7cWNf6OmelU8UaNxavaJq3Ppguq2HNqq9Q8/vSuoAU29LXvWJMjUTwd2XsAMW
        qNloZ1/wDRjfHet8EICOFqBITLUnmOFNzk2pr3Mn+89AEAmlQdAoPI8L98myfwrqxPh6NP
        ExLCggjaIHoCypQIh9LqQzGrkBxchtI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-IZ5K6SgNNEeCFVdoUflVAA-1; Mon, 25 Apr 2022 09:53:11 -0400
X-MC-Unique: IZ5K6SgNNEeCFVdoUflVAA-1
Received: by mail-wm1-f72.google.com with SMTP id bh11-20020a05600c3d0b00b003928fe7ba07so7172087wmb.6
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 06:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nBg8jJRFE9H3jBPTzJSIhqUr6FVHcI4D/7txybv4HqI=;
        b=hUMdNuAaDl+dCTDkbVU+75seQ57oqwosnNZzKytQE6XxP+GnWVl+6ZSu74JhtpGl0Z
         8fRD7Y8SudsAlgvMFo7DT87sI28QRa8N9hpjdaEicW8YzohhuvtEcvqAXFA499EZIwD8
         reloCKE5x26trl0CtmhWkKHkIz1/M8p8M9TRL/DwLvJabKugD6ygf7tOHbsbKwAM5i8o
         0KPkiriuObp3ixCZGLCvBdQ94IOVdHUj+gDCt9yp2+DyAeEpJ7wdie3/yPh+OKx9iiuq
         6ooBSdfwDPlqnDphro2eLS2KgqSFsJGZLyTn14yLEN9D8JEorpMmREcuQyKe5m/u6zYF
         JZQA==
X-Gm-Message-State: AOAM532EiDDR1ePiyHiTnoqx5usJAhCakyVKJuPI9VHvMSIXxRkcV/l1
        z3zP//yJjgQGgMDhTuYiJAOWaC70T34N7NCZ0y8gHAtOLeflNnoQvMUqJfy+T4234ePNvcU7L23
        NebW9trUb1orjyfOj
X-Received: by 2002:a5d:408d:0:b0:20a:ce37:1306 with SMTP id o13-20020a5d408d000000b0020ace371306mr11122261wrp.215.1650894779399;
        Mon, 25 Apr 2022 06:52:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7QvS5lAe+VnEesBy09cfUTt+ef8wKl5SoyngNz3EIjaYsxDXKLuJxAz4AJEwfyjB2A2im/w==
X-Received: by 2002:a5d:408d:0:b0:20a:ce37:1306 with SMTP id o13-20020a5d408d000000b0020ace371306mr11122241wrp.215.1650894779195;
        Mon, 25 Apr 2022 06:52:59 -0700 (PDT)
Received: from redhat.com ([2.53.22.137])
        by smtp.gmail.com with ESMTPSA id q128-20020a1c4386000000b003915e19d47asm11684311wma.32.2022.04.25.06.52.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 06:52:58 -0700 (PDT)
Date:   Mon, 25 Apr 2022 09:52:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Willem de Bruijn 
        <WillemdeBruijnwillemdebruijn.kernel@gmail.com>,
        Balazs Nemeth <bnemeth@redhat.com>,
        Mike Pattrick <mpattric@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCHv2 net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
Message-ID: <20220425095235-mutt-send-email-mst@kernel.org>
References: <20220425014502.985464-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425014502.985464-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Acked-by: Michael S. Tsirkin <mst@redhat.com>

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

