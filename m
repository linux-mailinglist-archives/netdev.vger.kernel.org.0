Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826EF6B2B09
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjCIQmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCIQlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:41:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF07100811
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678379430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZBLRuHkI1YAXHhp9FH7h8P44ZeZyI6cLn1n7/g70EHY=;
        b=f22Tvw5OCMFZjBsoPg8FcEBQxODMr+bJtlpc+rFlap2Y9jfIwRysSmj0DfKMll7VGXXnK6
        kMgUGXyy9TWpwDq4Agzgk7jhczin0CMCHWkSTVUmiRv5NumY1tsdCGRsLlUbhmJ041yEvX
        BkDmgVHMgB3MyzY7zoOle154JdLTCfI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-4Qc1Y_Q5OIWvEZ3gAga_hg-1; Thu, 09 Mar 2023 11:30:21 -0500
X-MC-Unique: 4Qc1Y_Q5OIWvEZ3gAga_hg-1
Received: by mail-qt1-f198.google.com with SMTP id b7-20020ac85407000000b003bfb9cff263so1336909qtq.6
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 08:30:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678379420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBLRuHkI1YAXHhp9FH7h8P44ZeZyI6cLn1n7/g70EHY=;
        b=B6Vri5vcW8dtonknBhMlkJ7TwhXj2ZwvNJiVMsvDWhap6Ve/+fOiThX5eIobzXfVaD
         +TrYiDDf06Wq31a34tI81qHooPuIGWp3ceb0jNZyyItCMwGFviPWiz+VSaFgyU7M16c8
         PN4XBwkjSq/ShdNTkNJ/vGaotGWi4zHyvMk3ARdCCei4kEhUoYRaRJ211Zgv6R9CiWLr
         JwzrUNLTjZZLbz8SsVXvPMxt5xDhbKJW2gSQ0wWDiOOwcPh6jU31XOVJr7eOLoWe1oux
         LeCXTctIAraocv04qJXa5TytYj3e65aPQJFpNsU3gXis8D6g2DyLuWP5Qc4xp9Q5rIMZ
         +6GQ==
X-Gm-Message-State: AO0yUKXojSKVUf5kBMP3eDI03jexVQLVhbjKMtPHflwEThWA3gQfJVCZ
        7eLRTf+5KTE2mCr7in8TOgCQu78UtFVFvUp2iUxxa1i/wtWZlGZ1kibM4GVDJPadvEGFqmFOCDO
        sumwsRSY4tvq2l1ha
X-Received: by 2002:a05:622a:2c2:b0:3bd:140c:91ed with SMTP id a2-20020a05622a02c200b003bd140c91edmr31398136qtx.52.1678379419975;
        Thu, 09 Mar 2023 08:30:19 -0800 (PST)
X-Google-Smtp-Source: AK7set+2F5YD7K/oepsMoEBVn/ZxPDtpNxoaMpPiPeM3V37KrU7smzm/aTYuFBcKJvHFaue9aD1htw==
X-Received: by 2002:a05:622a:2c2:b0:3bd:140c:91ed with SMTP id a2-20020a05622a02c200b003bd140c91edmr31398103qtx.52.1678379419700;
        Thu, 09 Mar 2023 08:30:19 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id d199-20020ae9efd0000000b007423e52f9d2sm13770583qkg.71.2023.03.09.08.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:30:19 -0800 (PST)
Date:   Thu, 9 Mar 2023 17:30:14 +0100
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
Subject: Re: [RFC PATCH v3 3/4] virtio/vsock: don't drop skbuff on copy
 failure
Message-ID: <20230309163014.kqpmucbksiqwblbg@sgarzare-redhat>
References: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
 <d140f8c3-d7d9-89b3-94ce-207c1f7990da@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d140f8c3-d7d9-89b3-94ce-207c1f7990da@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:13:51PM +0300, Arseniy Krasnov wrote:
>This returns behaviour of SOCK_STREAM read as before skbuff usage. When

So we need the Fixes tag:
Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")

The patch LGTM!

Stefano

>copying to user fails current skbuff won't be dropped, but returned to
>sockets's queue. Technically instead of 'skb_dequeue()', 'skb_peek()' is
>called and when skbuff becomes empty, it is removed from queue by
>'__skb_unlink()'.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 9a411475e201..6564192e7f20 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -364,7 +364,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>
> 	spin_lock_bh(&vvs->rx_lock);
> 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
>-		skb = __skb_dequeue(&vvs->rx_queue);
>+		skb = skb_peek(&vvs->rx_queue);
>
> 		bytes = len - total;
> 		if (bytes > skb->len)
>@@ -388,9 +388,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
>
> 			virtio_transport_dec_rx_pkt(vvs, pkt_len);
>+			__skb_unlink(skb, &vvs->rx_queue);
> 			consume_skb(skb);
>-		} else {
>-			__skb_queue_head(&vvs->rx_queue, skb);
> 		}
> 	}
>
>-- 
>2.25.1
>

