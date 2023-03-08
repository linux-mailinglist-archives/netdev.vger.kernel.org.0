Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4C96B9AB9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCNQJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCNQJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:09:39 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F201C8A3B6;
        Tue, 14 Mar 2023 09:09:37 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v21so6991564ple.9;
        Tue, 14 Mar 2023 09:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PHG2A2z/4Oj4SnDq/oyTj5egn3bq4S4uIxyREc7Sqcs=;
        b=ELtuxAGZ/D+42k/mL+TfoGLOUZBMSjIJ9Cg1aC/bgIJehRDGODGn1q4MywD3penrwZ
         kriBG76fAF3m/1vKPirHSq84o8fBZLz3B9Wxo8iKSIf3QIWeUNR/a3sKLz5ZctbFib82
         punkL2TgtIJJtx5AU4Jql8ZJ7joSoLyrAbpUFMNZF/rSz6ySohvLG2bAme84AL/ElKCe
         YkSHzYs9rXHiaiApP374hH+3bUZyf9fI4ysI5qstAXSCY/0Jc03OQqVz+YKzQHXshUi6
         pDCXafGc0zuYr4pp/zKwMXG/5LzrlCcioAUdNoudc+3RRN3a2Ty8hY3H8qXMoYrDtwJd
         gVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHG2A2z/4Oj4SnDq/oyTj5egn3bq4S4uIxyREc7Sqcs=;
        b=emsQMIxw1NDMhooBbBAru5UfeyoGZv87vwgrffpk+e0z9EN5uVrBVOKlkdFA3Ptcrq
         WHmxm1P58fv18sN7WIVrp/6mryhyCPKca4XVBmywrjMyj23HnFEqNQBcffbxiD60tvtM
         q/qH4eeeTyFs2sAmM+NPjPd932mO39xJwUKHgncWgKnecgjH56IXddICfIIusm51Vr3O
         l13Px/QZFK1ucQ/wF3V3BJ2TNQbUOLigWztgm9HO7XDBkqpHblYO5coNM1cT2d4QrHn0
         exNhryCO9pDHdAPauRm3fT2XZZNgWWI0wVS+EQkUERBYVG1vyXKwH4VtHxebqcxAVNdb
         lpdQ==
X-Gm-Message-State: AO0yUKWKO26MEbDuCnpCmnQPKUrcFdKKKAPellX118f2f45HNf+tct8O
        gwNZGibp6rJj6O8B8alpCGY=
X-Google-Smtp-Source: AK7set9+kuow1O8WJUSgNlyuVnYRkAE6X72VZSuTzKTUfe9ea+55oImYUCzQnHhGFv7AIPFopt9mqw==
X-Received: by 2002:a05:6a20:3c87:b0:d0:e4b:29b3 with SMTP id b7-20020a056a203c8700b000d00e4b29b3mr34232766pzj.27.1678810177231;
        Tue, 14 Mar 2023 09:09:37 -0700 (PDT)
Received: from localhost (ec2-54-67-115-33.us-west-1.compute.amazonaws.com. [54.67.115.33])
        by smtp.gmail.com with ESMTPSA id z22-20020aa791d6000000b005ac8a51d591sm1802165pfa.21.2023.03.14.09.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:09:36 -0700 (PDT)
Date:   Wed, 8 Mar 2023 15:11:37 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH RESEND net v4 1/4] virtio/vsock: don't use skbuff state
 to account credit
Message-ID: <ZAilqWqzSgpFNLCy@bullseye>
References: <1bfcb7fd-bce3-30cf-8a58-8baa57b7345c@sberdevices.ru>
 <92bc3587-6994-e003-5ec5-252c1961d8ec@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92bc3587-6994-e003-5ec5-252c1961d8ec@sberdevices.ru>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:05:48PM +0300, Arseniy Krasnov wrote:
> 'skb->len' can vary when we partially read the data, this complicates the
> calculation of credit to be updated in 'virtio_transport_inc_rx_pkt()/
> virtio_transport_dec_rx_pkt()'.
> 
> Also in 'virtio_transport_dec_rx_pkt()' we were miscalculating the
> credit since 'skb->len' was redundant.
> 
> For these reasons, let's replace the use of skbuff state to calculate new
> 'rx_bytes'/'fwd_cnt' values with explicit value as input argument. This
> makes code more simple, because it is not needed to change skbuff state
> before each call to update 'rx_bytes'/'fwd_cnt'.
> 
> Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport_common.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index a1581c77cf84..618680fd9906 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -241,21 +241,18 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>  }
>  
>  static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
> -					struct sk_buff *skb)
> +					u32 len)
>  {
> -	if (vvs->rx_bytes + skb->len > vvs->buf_alloc)
> +	if (vvs->rx_bytes + len > vvs->buf_alloc)
>  		return false;
>  
> -	vvs->rx_bytes += skb->len;
> +	vvs->rx_bytes += len;
>  	return true;
>  }
>  
>  static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> -					struct sk_buff *skb)
> +					u32 len)
>  {
> -	int len;
> -
> -	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
>  	vvs->rx_bytes -= len;
>  	vvs->fwd_cnt += len;
>  }
> @@ -388,7 +385,9 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  		skb_pull(skb, bytes);
>  
>  		if (skb->len == 0) {
> -			virtio_transport_dec_rx_pkt(vvs, skb);
> +			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
> +
> +			virtio_transport_dec_rx_pkt(vvs, pkt_len);
>  			consume_skb(skb);
>  		} else {
>  			__skb_queue_head(&vvs->rx_queue, skb);
> @@ -437,17 +436,17 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>  
>  	while (!msg_ready) {
>  		struct virtio_vsock_hdr *hdr;
> +		size_t pkt_len;
>  
>  		skb = __skb_dequeue(&vvs->rx_queue);
>  		if (!skb)
>  			break;
>  		hdr = virtio_vsock_hdr(skb);
> +		pkt_len = (size_t)le32_to_cpu(hdr->len);
>  
>  		if (dequeued_len >= 0) {
> -			size_t pkt_len;
>  			size_t bytes_to_copy;
>  
> -			pkt_len = (size_t)le32_to_cpu(hdr->len);
>  			bytes_to_copy = min(user_buf_len, pkt_len);
>  
>  			if (bytes_to_copy) {
> @@ -484,7 +483,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>  				msg->msg_flags |= MSG_EOR;
>  		}
>  
> -		virtio_transport_dec_rx_pkt(vvs, skb);
> +		virtio_transport_dec_rx_pkt(vvs, pkt_len);
>  		kfree_skb(skb);
>  	}
>  
> @@ -1040,7 +1039,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>  
>  	spin_lock_bh(&vvs->rx_lock);
>  
> -	can_enqueue = virtio_transport_inc_rx_pkt(vvs, skb);
> +	can_enqueue = virtio_transport_inc_rx_pkt(vvs, len);
>  	if (!can_enqueue) {
>  		free_pkt = true;
>  		goto out;
> -- 
> 2.25.1

Acked-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
