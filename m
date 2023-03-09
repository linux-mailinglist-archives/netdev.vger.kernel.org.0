Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE1A66B2AEE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjCIQi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCIQh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:37:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58806FC22A
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678379258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lxt5/Bn7cdaTgX2DWKCr4A5WUfM36Gr/gY5+wUSWUT8=;
        b=DR6HkWniyavZWhuO/64ujnRKzcoPypI8jbrHAFKrXDyyNmUu5OmMmL1Df/iQ/xrEQFSQYj
        1rfHdYlbtEG7hatg534iU6OuvDz7pTnebzekQDDhWEQ3fYclJfcAZr0crFFYNcaAbcZB6B
        2YxjNHClTGiZK9bFyUvseFiHG/XvbLo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-42-G9eiyjn2ONq7nIS-IR2Tdg-1; Thu, 09 Mar 2023 11:27:37 -0500
X-MC-Unique: G9eiyjn2ONq7nIS-IR2Tdg-1
Received: by mail-qk1-f198.google.com with SMTP id d4-20020a05620a166400b00742859d0d4fso1462475qko.15
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 08:27:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678379256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxt5/Bn7cdaTgX2DWKCr4A5WUfM36Gr/gY5+wUSWUT8=;
        b=XPCOjnpGByNSoAr3KNI63KfO4zat20rxPDrO+Yc7//opEEo5mFGex8iFdiMnBQX1lG
         UfNr/Za5BWQQ0kPVOumTXehgCTPjx7jfRYmmFV2lski2poGqOulUYR+h7Do73zMFLLEP
         k9CnLSzskX2Vn05+2l8vo/AaqN23A61r2IXio4TtNHUW8vV5Dxyc7NqLaaDg67XdOrUU
         EkU8wqIhLrdKNcR6p8d68Wj7Z7vvkmLRUyDHVx1N60BtcqRYP2HyEEfs7aVlDqQopLhw
         jBRQL5VxTORxhoTGe91oFerNbyq0l54IFDTGx+/uub5vPe8ij9/1IlS25+QfIEAYoAgw
         7zLg==
X-Gm-Message-State: AO0yUKUw3uqkJi0r8opKclN7KCtAKsPSHp7BxDeCqWZERB4k3DVqH5Xy
        bbuCVgxPKwS5Luu1QbT8Ud7uB89E4tyUDcUCP5A2aYE7eV5HI+fjYdA9cfHDlOpX0tivZBVnJts
        qEDu/uSYQKRZ/ojuf
X-Received: by 2002:ac8:4e8f:0:b0:3b8:ca58:ee4c with SMTP id 15-20020ac84e8f000000b003b8ca58ee4cmr37414143qtp.2.1678379256609;
        Thu, 09 Mar 2023 08:27:36 -0800 (PST)
X-Google-Smtp-Source: AK7set+MCqXSR1PGob1I4pk09gGcs+URcwUiCZ4YjiXliMTVJKdjLHjJ73m9gwkInj/O5e3oS12kjQ==
X-Received: by 2002:ac8:4e8f:0:b0:3b8:ca58:ee4c with SMTP id 15-20020ac84e8f000000b003b8ca58ee4cmr37414110qtp.2.1678379256342;
        Thu, 09 Mar 2023 08:27:36 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id 6-20020a05620a040600b006f9ddaaf01esm13666192qkp.102.2023.03.09.08.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:27:35 -0800 (PST)
Date:   Thu, 9 Mar 2023 17:27:26 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 1/4] virtio/vsock: don't use skbuff state to
 account credit
Message-ID: <20230309162726.lzkacyg3lfow4cfg@sgarzare-redhat>
References: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
 <453d77fd-8344-26d8-bb44-7ed829b7de47@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <453d77fd-8344-26d8-bb44-7ed829b7de47@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:11:46PM +0300, Arseniy Krasnov wrote:
>This replaces use of skbuff state to calculate new 'rx_bytes'/'fwd_cnt'
>values with explicit value as input argument. This makes code more
>simple, because it is not needed to change skbuff state before each
>call to update 'rx_bytes'/'fwd_cnt'.

I think we should also describe the issues you found that we are fixinig
now, for example the wrong calculation in virtio_transport_dec_rx_pkt().

Something like this:

   `skb->len` can vary when we partially read the data, this complicates
   the calculation of credit to be updated in
   virtio_transport_inc_rx_pkt()/virtio_transport_dec_rx_pkt().

   Also in virtio_transport_dec_rx_pkt() we were miscalculating the
   credit since `skb->len` was redundant.

   For these reasons, let's replace the use ...
   (continue with what is written in this commit message)

And we should add the Fixes tag:

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 23 +++++++++++------------
> 1 file changed, 11 insertions(+), 12 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index a1581c77cf84..618680fd9906 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -241,21 +241,18 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> }
>
> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>-					struct sk_buff *skb)
>+					u32 len)
> {
>-	if (vvs->rx_bytes + skb->len > vvs->buf_alloc)
>+	if (vvs->rx_bytes + len > vvs->buf_alloc)
> 		return false;
>
>-	vvs->rx_bytes += skb->len;
>+	vvs->rx_bytes += len;
> 	return true;
> }
>
> static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
>-					struct sk_buff *skb)
>+					u32 len)
> {
>-	int len;
>-
>-	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
> 	vvs->rx_bytes -= len;
> 	vvs->fwd_cnt += len;
> }
>@@ -388,7 +385,9 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 		skb_pull(skb, bytes);
>
> 		if (skb->len == 0) {
>-			virtio_transport_dec_rx_pkt(vvs, skb);
>+			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);

Good catch! In my proposal I used `bytes` wrongly!

The rest LGTM!

Stefano

>+
>+			virtio_transport_dec_rx_pkt(vvs, pkt_len);
> 			consume_skb(skb);
> 		} else {
> 			__skb_queue_head(&vvs->rx_queue, skb);
>@@ -437,17 +436,17 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>
> 	while (!msg_ready) {
> 		struct virtio_vsock_hdr *hdr;
>+		size_t pkt_len;
>
> 		skb = __skb_dequeue(&vvs->rx_queue);
> 		if (!skb)
> 			break;
> 		hdr = virtio_vsock_hdr(skb);
>+		pkt_len = (size_t)le32_to_cpu(hdr->len);
>
> 		if (dequeued_len >= 0) {
>-			size_t pkt_len;
> 			size_t bytes_to_copy;
>
>-			pkt_len = (size_t)le32_to_cpu(hdr->len);
> 			bytes_to_copy = min(user_buf_len, pkt_len);
>
> 			if (bytes_to_copy) {
>@@ -484,7 +483,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 				msg->msg_flags |= MSG_EOR;
> 		}
>
>-		virtio_transport_dec_rx_pkt(vvs, skb);
>+		virtio_transport_dec_rx_pkt(vvs, pkt_len);
> 		kfree_skb(skb);
> 	}
>
>@@ -1040,7 +1039,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>
> 	spin_lock_bh(&vvs->rx_lock);
>
>-	can_enqueue = virtio_transport_inc_rx_pkt(vvs, skb);
>+	can_enqueue = virtio_transport_inc_rx_pkt(vvs, len);
> 	if (!can_enqueue) {
> 		free_pkt = true;
> 		goto out;
>-- 
>2.25.1
>

