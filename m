Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B106B8E41
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCNJMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjCNJMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:12:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65550984CB
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678785105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T7LMCjgV3148z08653yeBgRUZqj0U6BVbsGsCqJdIQw=;
        b=iJg1a6wbTzSY37Tw1t/o1R3GxIGZo9QhcULAg+rZuTnkaZ7nNHCdZ1cdQTXVJ4u+CeCD64
        68k6LQs43f91lJ/vhwrDETX6lvh9K2E/AH1bkc+Ft2g0Gsnw02DwCB6P8r/s+9N6W0uhAG
        K2Z2LhN1UGfUtcpfmmu0gP4ZTkr78sk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-XybK3PGbMMeEF-QJqT5cUA-1; Tue, 14 Mar 2023 05:11:43 -0400
X-MC-Unique: XybK3PGbMMeEF-QJqT5cUA-1
Received: by mail-ed1-f69.google.com with SMTP id m8-20020a056402430800b004cdaaa4f428so21058152edc.20
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 02:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678785099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7LMCjgV3148z08653yeBgRUZqj0U6BVbsGsCqJdIQw=;
        b=6O7JXMNscnEmmGLEgQTMYq+TRRZtWtRbhwBMDLP+KgZE/BepVTz2Ub91pARmV6YqVJ
         w4lWlu+CKtVRstZ+d+G2KdkaXmubHCgCbC7joG/GuRgVrdc+ZAgev2b+48sMMhILPY4r
         feBGdJi6xPxDflEgY/2JaJGBxujpBS9SWZdMSCR2CPHK7SP94yuswUPCUynVmLett9C8
         YlengyiiQkItcye3BpZOejpJSjTwEdwNy8/YG6C4x1tGV4+PZJqRhQNMpGo3A5B134Fw
         Vt9X0kYYYiZZveXRsPnBbK4TAMxnH5strtiM0GsTWpekobGmpifci7MxtXgDX+gkQ3Fz
         49oA==
X-Gm-Message-State: AO0yUKUmu3fDNBojJlKfK5kIfntbJAOt1CUIooJl4uPtFkDRgKL+/FC8
        7h3u3AGF1cXwlgqWiJsJSjP2AhRQIxTLNQW8u1LMpB8dfjcrA4avkZkBHI9p8yNqbIPv/4UGXmO
        tv+Ca1SVZvo/KECqZ
X-Received: by 2002:a17:907:746:b0:92b:ae6c:23e7 with SMTP id xc6-20020a170907074600b0092bae6c23e7mr1868562ejb.56.1678785099433;
        Tue, 14 Mar 2023 02:11:39 -0700 (PDT)
X-Google-Smtp-Source: AK7set+bdi1ysk/4yWOK0bSSOg12ZBcLDKbIuHqp5BWiooRh0XX2E3g6+Wpi5yzgkrXZjiEs1t2Sbg==
X-Received: by 2002:a17:907:746:b0:92b:ae6c:23e7 with SMTP id xc6-20020a170907074600b0092bae6c23e7mr1868546ejb.56.1678785099140;
        Tue, 14 Mar 2023 02:11:39 -0700 (PDT)
Received: from redhat.com ([2a02:14f:1f7:4129:3ef9:ea05:f0ca:6b81])
        by smtp.gmail.com with ESMTPSA id hd31-20020a170907969f00b0092d58e24e11sm356116ejc.137.2023.03.14.02.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 02:11:38 -0700 (PDT)
Date:   Tue, 14 Mar 2023 05:11:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Heng Qi <hengqi@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net 2/2] virtio_net: free xdp shinfo frags when
 build_skb_from_xdp_buff() fails
Message-ID: <20230314051049-mutt-send-email-mst@kernel.org>
References: <20230314083901.40521-1-xuanzhuo@linux.alibaba.com>
 <20230314083901.40521-3-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314083901.40521-3-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:39:01PM +0800, Xuan Zhuo wrote:
> build_skb_from_xdp_buff() may return NULL, on this
> scene we need to free the frags of xdp shinfo.

s/on this scene/in this case/

> 
> Fixes: fab89bafa95b ("virtio-net: support multi-buffer xdp")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8ecf7a341d54..d36183be0481 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1273,9 +1273,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  
>  		switch (act) {
>  		case XDP_PASS:
> +			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> +			if (!head_skb)
> +				goto err_xdp_frags;
> +
>  			if (unlikely(xdp_page != page))
>  				put_page(page);
> -			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
>  			rcu_read_unlock();
>  			return head_skb;
>  		case XDP_TX:
> -- 
> 2.32.0.3.g01195cf9f

