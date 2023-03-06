Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0176ABEE5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjCFL6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCFL6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:58:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00AE29437
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 03:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678103847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pPpIjkKFXmzX5D1Lt9KnLFbKezSVbVCSbxUA3anhA3E=;
        b=CN+febEf7AbMMKfNJF3rO89UsUXVslqRBDXwRVtHJ9fiUirr2j7jc6QtkIlae/rwszx9Y3
        MIHswrUNOa93THO5oDz4ruEhmJZjJrCaNntoK2ULIcPXkJSqaE+nhlbyVLKkwgfIx1923q
        KQ+cJLkm9O7+vUSE1InUJZ0bu6A14PM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-ULXNSGr2MbCLDVCq2auh1g-1; Mon, 06 Mar 2023 06:57:25 -0500
X-MC-Unique: ULXNSGr2MbCLDVCq2auh1g-1
Received: by mail-qk1-f199.google.com with SMTP id ou5-20020a05620a620500b007423e532628so5209177qkn.5
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 03:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678103845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPpIjkKFXmzX5D1Lt9KnLFbKezSVbVCSbxUA3anhA3E=;
        b=QAQpYO07T7dUHKtroLK6+diw8wqNg7HKQiQia12q6hEQ9X57/bwN8nYwJtgpI7Cc6l
         euE6kdOTeB/v+wbG593LVPg5motyYF4UrZpPy+Mle0haX0qPcR0YYnckUjyQWRbKEK/g
         WFhFkYznK15XHWNVs54XJl/a2TrMcQekCbPRFu50kC0REuDqMi5yondLOqUve1GgBLkH
         06wqNhsiSHmjJIu+OXkwPFQLWCd+o6X0niuCkaCQyCz42B8NKXaryoF1+vqIopHnQUT8
         Oem5HmjTgCZzhJ6E/7H4XJJPxnJ48TxLKal/hZ4sjradQsv3PEHHrlqOLk51C721wgpe
         QfGg==
X-Gm-Message-State: AO0yUKXqsfTQs30zcFPSDL0d2+tAnRkcAmo0gQonAjH6MCgAMbMQKBB+
        74aQDgFJ5fKaAXTZTlPwrLtm+vLA6+Qujd3zuSvrfNgQrrr4DUJk6WaksxNU6nGTvr948YLq3pp
        vtiVZwNfGPs7mp8Nn
X-Received: by 2002:a05:6214:410d:b0:56e:b1e0:3ff2 with SMTP id kc13-20020a056214410d00b0056eb1e03ff2mr15201387qvb.9.1678103845430;
        Mon, 06 Mar 2023 03:57:25 -0800 (PST)
X-Google-Smtp-Source: AK7set9fZZTVv9FvGEcGdunZeC28/B+zMV+iRBJXM9Wbl6wp+Gpc50VQTGrmBz+6u9VcqXUQGM9WAg==
X-Received: by 2002:a05:6214:410d:b0:56e:b1e0:3ff2 with SMTP id kc13-20020a056214410d00b0056eb1e03ff2mr15201363qvb.9.1678103845151;
        Mon, 06 Mar 2023 03:57:25 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id j2-20020a37b902000000b0074231ac1723sm7398083qkf.28.2023.03.06.03.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 03:57:24 -0800 (PST)
Date:   Mon, 6 Mar 2023 12:57:18 +0100
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
Subject: Re: [RFC PATCH v2 1/4] virtio/vsock: fix 'rx_bytes'/'fwd_cnt'
 calculation
Message-ID: <20230306115718.2h7munjxd2royuzq@sgarzare-redhat>
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <4a3f3978-1093-4c0a-663f-28d77eeb0806@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4a3f3978-1093-4c0a-663f-28d77eeb0806@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 05, 2023 at 11:06:26PM +0300, Arseniy Krasnov wrote:
>Substraction of 'skb->len' is redundant here: 'skb_headroom()' is delta
>between 'data' and 'head' pointers, e.g. it is number of bytes returned
>to user (of course accounting size of header). 'skb->len' is number of
>bytes rest in buffer.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index a1581c77cf84..2e2a773df5c1 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -255,7 +255,7 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
> {
> 	int len;
>
>-	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
>+	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr);

IIUC virtio_transport_dec_rx_pkt() is always called after skb_pull(),
so skb_headroom() is returning the amount of space we removed.

Looking at the other patches in this series, I think maybe we should
change virtio_transport_dec_rx_pkt() and virtio_transport_inc_rx_pkt()
by passing the value to subtract or add directly.
Since some times we don't remove the whole payload, so it would be
better to call it with the value in hdr->len.

I mean something like this (untested):

index a1581c77cf84..9e69ae7a9a96 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -241,21 +241,18 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
  }

  static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
-                                       struct sk_buff *skb)
+                                       u32 len)
  {
-       if (vvs->rx_bytes + skb->len > vvs->buf_alloc)
+       if (vvs->rx_bytes + len > vvs->buf_alloc)
                 return false;

-       vvs->rx_bytes += skb->len;
+       vvs->rx_bytes += len;
         return true;
  }

  static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
-                                       struct sk_buff *skb)
+                                       u32 len)
  {
-       int len;
-
-       len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
         vvs->rx_bytes -= len;
         vvs->fwd_cnt += len;
  }
@@ -388,7 +385,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
                 skb_pull(skb, bytes);

                 if (skb->len == 0) {
-                       virtio_transport_dec_rx_pkt(vvs, skb);
+                       virtio_transport_dec_rx_pkt(vvs, bytes);
                         consume_skb(skb);
                 } else {
                         __skb_queue_head(&vvs->rx_queue, skb);
@@ -437,17 +434,17 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,

         while (!msg_ready) {
                 struct virtio_vsock_hdr *hdr;
+               size_t pkt_len;

                 skb = __skb_dequeue(&vvs->rx_queue);
                 if (!skb)
                         break;
                 hdr = virtio_vsock_hdr(skb);
+               pkt_len = (size_t)le32_to_cpu(hdr->len);

                 if (dequeued_len >= 0) {
-                       size_t pkt_len;
                         size_t bytes_to_copy;

-                       pkt_len = (size_t)le32_to_cpu(hdr->len);
                         bytes_to_copy = min(user_buf_len, pkt_len);

                         if (bytes_to_copy) {
@@ -484,7 +481,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
                                 msg->msg_flags |= MSG_EOR;
                 }

-               virtio_transport_dec_rx_pkt(vvs, skb);
+               virtio_transport_dec_rx_pkt(vvs, pkt_len);
                 kfree_skb(skb);
         }

@@ -1040,7 +1037,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,

         spin_lock_bh(&vvs->rx_lock);

-       can_enqueue = virtio_transport_inc_rx_pkt(vvs, skb);
+       can_enqueue = virtio_transport_inc_rx_pkt(vvs, len);
         if (!can_enqueue) {
                 free_pkt = true;
                 goto out;

When we used vsock_pkt, we were passing the structure because the `len`
field was immutable (and copied from the header), whereas with skb it
can change and so we introduced these errors.

What do you think?

Thanks,
Stefano

