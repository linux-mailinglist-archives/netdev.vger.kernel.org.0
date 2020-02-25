Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F404316BF71
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 12:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbgBYLSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 06:18:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25866 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729708AbgBYLSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 06:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582629492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dcSrZJ633LnILl4hKZiWeKSTIw0SGihk9tSKZPfdWUo=;
        b=QKjWlPRFKgalFHUhwfpHEy7wBA90menDufzv8s0sGI6GTY5zciFxXwBlJHFx8AtOO+U8PU
        r4dhlDs4X3w+aNJ7cAy2nTBbXgAEsOfKDTyuQTzm32wQAx08I3nGEcDLw1hVDsjmzb/4ig
        BHSWYS+bbt/c2JoTIfphAbihBMdhSSg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-L8FOchUkOZO0iPi433V_Cg-1; Tue, 25 Feb 2020 06:18:10 -0500
X-MC-Unique: L8FOchUkOZO0iPi433V_Cg-1
Received: by mail-qk1-f197.google.com with SMTP id i11so14506449qki.12
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 03:18:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dcSrZJ633LnILl4hKZiWeKSTIw0SGihk9tSKZPfdWUo=;
        b=e+9qQQ9XbNFH43cJM6OWqCF2C5QM9fLiW6EEzQuTZLqFJS4VpXtoR+izLVafqqJHeR
         dmNRvipHyfJ+Qm3iiICVHlJviZOtU8K/3X+rOEL4EWwwPcy60tPFpMghh+UrkBPciwip
         yNHNw+VOGJO85nTo7oJYDZR0GVAgRZXyGyIg4pdtwbPmcz8UtwqyzgbQVIp/Q/6ApMfy
         +D2yMnKEzaH91faBwzNHlEGHeCeYEwsgPGUGLEaMwiaIRrZEenON74X7Re24Ena4RzR7
         wfg1dGZ6hJsdQgr5ulmOiHMkv5xehqmg9djQKvTA9EadtUC9id9b6Cg/nC5dV5zNvp+N
         7EAQ==
X-Gm-Message-State: APjAAAWBpF1PYkW0wp3PI2dWyxKsAT7m5n2/AQuQyR07Rs9nBtWNOg2n
        yshkaG2caEu3h9nkFAZL8PkveVhwWer+OT6PoE3X7TMIuegba48pZ6ri1Q2Dc22anuw1FOpUxrU
        nbE6BbaCKNAD8CDF4
X-Received: by 2002:a37:4a46:: with SMTP id x67mr48067755qka.160.1582629490229;
        Tue, 25 Feb 2020 03:18:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqyhsafwxrmKzVs2GlO4jxoUvgmsXom8ElM3DBZS74WODQ6dFFsMn+QDBkv/j91R3JLvi5etkQ==
X-Received: by 2002:a37:4a46:: with SMTP id x67mr48067734qka.160.1582629489996;
        Tue, 25 Feb 2020 03:18:09 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id s19sm5973078qkj.88.2020.02.25.03.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 03:18:08 -0800 (PST)
Date:   Tue, 25 Feb 2020 06:18:01 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yuya Kusakabe <yuya.kusakabe@gmail.com>
Cc:     jasowang@redhat.com, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH bpf-next v6 1/2] virtio_net: keep vnet header zeroed if
 XDP is loaded for small buffer
Message-ID: <20200225061501-mutt-send-email-mst@kernel.org>
References: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
 <20200225033212.437563-1-yuya.kusakabe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225033212.437563-1-yuya.kusakabe@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 12:32:11PM +0900, Yuya Kusakabe wrote:
> We do not want to care about the vnet header in receive_small() if XDP
> is loaded, since we can not know whether or not the packet is modified
> by XDP.
> 
> Fixes: f6b10209b90d ("virtio-net: switch to use build_skb() for small buffer")
> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2fe7a3188282..f39d0218bdaa 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -735,10 +735,10 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  	}
>  	skb_reserve(skb, headroom - delta);
>  	skb_put(skb, len);
> -	if (!delta) {
> +	if (!xdp_prog) {
>  		buf += header_offset;
>  		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
> -	} /* keep zeroed vnet hdr since packet was changed by bpf */
> +	} /* keep zeroed vnet hdr since XDP is loaded */
>  
>  err:
>  	return skb;
> -- 
> 2.24.1

