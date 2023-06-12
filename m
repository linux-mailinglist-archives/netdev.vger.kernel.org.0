Return-Path: <netdev+bounces-10213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4603872CFAE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65ACC1C20BAC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE41B8BE8;
	Mon, 12 Jun 2023 19:36:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11F5523E
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 19:36:30 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79003B1;
	Mon, 12 Jun 2023 12:36:27 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-65292f79456so3682903b3a.2;
        Mon, 12 Jun 2023 12:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686598587; x=1689190587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ATjr4C/8Uv1pbaG1h8UEZbOuZsmm5ecLBn1cucGbnc=;
        b=CEs5UfI3t7x93WtKM5T2rgCq6xzNFXx9g7evrAOyC6LQnrh0eafc2WYF4fy1ZBHVGl
         eI4oKTRxzN8fErz3e+DzGn44Km28CKpq1AVcIN0n7WxKAIX7QOfuVe1BVZ/U/fYApsJK
         qz1DLI3gnxxSooqM+38/VhY0WWr9jOP0r2Oh1FULueqgWKumx4tRPB97qM5ZwldvG2Za
         QpRlt0KaI/qWsSWryIJpvpEcVFl8HZFhzgcYdxHeNcecKbe92sjcXWiaUeFB0FseyJBy
         Rb27u/tzBwAHbBcAX8pASpwkXybKP0YymehFb4yMKpDolvwg6E622c/eokintD2hV4Fe
         hZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686598587; x=1689190587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ATjr4C/8Uv1pbaG1h8UEZbOuZsmm5ecLBn1cucGbnc=;
        b=TeIla/0ghtcpYTDcOLnnc/FFSTMGG03zi2FqyyIbRUaHeaqi56G5rw4V6CE+dSyf8A
         BY1wO11t0kBdIdgiRcw36YGe38PyGSK7cVNO5P2OZJtyxxjiHuYt1lmW4jZmTy5rw+5S
         cPVfjehme+GcotaCs2PyGGIrYTRkK5l32miuxRXFpn6OXVplnfngoSvP1UPAS4eyoidW
         +SlROIpHEvqKxLwge2pd0AJt/gJScAuPkF6G99ikC4OqHVHRCoN0jHUlDLwlIquxXwQb
         Ig9Lipszg+19JJweci5XBmtmMaTluc7Sv1MY8xsURoKJCo+90/e0hJP1Sm88n6eVFYjW
         XEEg==
X-Gm-Message-State: AC+VfDyiBKtBNV1EPts+HcfGwrH1tX61t/8LDRST3BUDD6g4qkjkREAx
	LEz5cDb6i2IrPNvtK9j0lK4W/Fi85MHSw5C8
X-Google-Smtp-Source: ACHHUZ4e2pRliqlMynWct4Q9wIs3Fni40S+N2QH5jeVPRPLt4in0D+eeUCAC6ZJoWpxJNUptEmC18g==
X-Received: by 2002:a05:6a00:150f:b0:64c:9b56:6215 with SMTP id q15-20020a056a00150f00b0064c9b566215mr11928945pfu.25.1686598586630;
        Mon, 12 Jun 2023 12:36:26 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id p4-20020aa78604000000b0064d47cd117esm6386338pfn.39.2023.06.12.12.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 12:36:26 -0700 (PDT)
Date: Mon, 12 Jun 2023 17:43:56 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 01/17] vsock/virtio: read data from non-linear skb
Message-ID: <ZIdZXOhOaRNW4ATB@bullseye>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-2-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-2-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 03, 2023 at 11:49:23PM +0300, Arseniy Krasnov wrote:
> This is preparation patch for non-linear skbuff handling. It replaces
> direct calls of 'memcpy_to_msg()' with 'skb_copy_datagram_iter()'. Main
> advantage of the second one is that is can handle paged part of the skb
> by using 'kmap()' on each page, but if there are no pages in the skb,
> it behaves like simple copying to iov iterator. This patch also adds
> new field to the control block of skb - this value shows current offset
> in the skb to read next portion of data (it doesn't matter linear it or
> not). Idea is that 'skb_copy_datagram_iter()' handles both types of
> skb internally - it just needs an offset from which to copy data from
> the given skb. This offset is incremented on each read from skb. This
> approach allows to avoid special handling of non-linear skbs:
> 1) We can't call 'skb_pull()' on it, because it updates 'data' pointer.
> 2) We need to update 'data_len' also on each read from this skb.
> 
> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> ---
>  include/linux/virtio_vsock.h            |  1 +
>  net/vmw_vsock/virtio_transport_common.c | 26 +++++++++++++++++--------
>  2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
> index c58453699ee9..17dbb7176e37 100644
> --- a/include/linux/virtio_vsock.h
> +++ b/include/linux/virtio_vsock.h
> @@ -12,6 +12,7 @@
>  struct virtio_vsock_skb_cb {
>  	bool reply;
>  	bool tap_delivered;
> +	u32 frag_off;
>  };
>  
>  #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index b769fc258931..5819a9cd4515 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -355,7 +355,7 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
>  	spin_lock_bh(&vvs->rx_lock);
>  
>  	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
> -		off = 0;
> +		off = VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
>  
>  		if (total == len)
>  			break;
> @@ -370,7 +370,10 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
>  			 */
>  			spin_unlock_bh(&vvs->rx_lock);
>  
> -			err = memcpy_to_msg(msg, skb->data + off, bytes);
> +			err = skb_copy_datagram_iter(skb, off,
> +						     &msg->msg_iter,
> +						     bytes);
> +
>  			if (err)
>  				goto out;
>  
> @@ -414,24 +417,28 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>  		skb = skb_peek(&vvs->rx_queue);
>  
>  		bytes = len - total;
> -		if (bytes > skb->len)
> -			bytes = skb->len;
> +		if (bytes > skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off)
> +			bytes = skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
>  
>  		/* sk_lock is held by caller so no one else can dequeue.
>  		 * Unlock rx_lock since memcpy_to_msg() may sleep.
>  		 */
>  		spin_unlock_bh(&vvs->rx_lock);
>  
> -		err = memcpy_to_msg(msg, skb->data, bytes);
> +		err = skb_copy_datagram_iter(skb,
> +					     VIRTIO_VSOCK_SKB_CB(skb)->frag_off,
> +					     &msg->msg_iter, bytes);
> +
>  		if (err)
>  			goto out;
>  
>  		spin_lock_bh(&vvs->rx_lock);
>  
>  		total += bytes;
> -		skb_pull(skb, bytes);
>  
> -		if (skb->len == 0) {
> +		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += bytes;
> +
> +		if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->frag_off) {
>  			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
>  
>  			virtio_transport_dec_rx_pkt(vvs, pkt_len);
> @@ -503,7 +510,10 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>  				 */
>  				spin_unlock_bh(&vvs->rx_lock);
>  
> -				err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
> +				err = skb_copy_datagram_iter(skb, 0,
> +							     &msg->msg_iter,
> +							     bytes_to_copy);
> +
>  				if (err) {
>  					/* Copy of message failed. Rest of
>  					 * fragments will be freed without copy.
> -- 
> 2.25.1
> 

LGTM.

Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>

