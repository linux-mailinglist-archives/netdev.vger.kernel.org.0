Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CFA6C1629
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbjCTPCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjCTPCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:02:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDC0222FA
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 07:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679324246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OQtFmm4KZTwh3zjk0Ct7Wnh43xep01cq4SPytfY48TY=;
        b=EeL6ij6N0TObiZ9G+j16TtpgIdYV2KHi3MEVsCyhARlpVNvUW4as1U0dtbiluNB8c9SiYO
        T72UohG+LiQe2tp7GTQBE+hIY3C1vXgVXFJUubAT4r7Mfad7IpyFOa3FNwtG8Y2SnL4RiP
        G/kxUuJ7rFwMckuqUwZKSRtmK595080=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-qtjm_Aw3OSGGpFJKeYoFaA-1; Mon, 20 Mar 2023 10:57:25 -0400
X-MC-Unique: qtjm_Aw3OSGGpFJKeYoFaA-1
Received: by mail-wm1-f70.google.com with SMTP id v8-20020a05600c470800b003ed3b575374so5648882wmo.7
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 07:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679324244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQtFmm4KZTwh3zjk0Ct7Wnh43xep01cq4SPytfY48TY=;
        b=DmPEDqw8/KZDWVKDfMRX7CyhYWI634li/x2ZlH0/+qdekYCHyxSs3lgMsBO5+a5yQr
         pYkV9/IHx9Lz3L265G5TNl2SqIC0RP7AVKRyrhghCQtycAc+Qelhxd58QkNN9mvx6v1j
         o1CC5sLgmerVrkr2LXvsuq6S59u6rhweSPHwm5ghXqKAVxSF5m8dbtflhdUthcOnSI5O
         rQmPLPBIZbuo79bZwFTjyQCtDD6cpB4cc8VU32TFaNgCgkRYY1VpSLcZ5mwsKrbUkJZq
         h4N/3kqGHIfko/DXBxIcVYt2LccS9OjQ49pZRRVZIMBq1fkXHaYrulKrfVi9Eb03VvIt
         UAzA==
X-Gm-Message-State: AO0yUKVTFgNxVH3+CZYh+LQZ6vscKakJ2VmU8FNbShai1TBwYjlX9vth
        rVqs184moO/CsRZdGw6sc5qZE4+0gRSM2NZXzY2CvREPngew/Hb9Dt5WI8/e9VVfv9/R5aYZCsg
        SGE5RVqx8VncxZcUC
X-Received: by 2002:a05:600c:350f:b0:3eb:3843:9f31 with SMTP id h15-20020a05600c350f00b003eb38439f31mr32779753wmq.10.1679324244393;
        Mon, 20 Mar 2023 07:57:24 -0700 (PDT)
X-Google-Smtp-Source: AK7set+H3q9948VZ11zwy3FuyhsaXEplz4rpzcboLvqOLEhb7JocoduN7nI4hrj2vQBstLG8pNpEyw==
X-Received: by 2002:a05:600c:350f:b0:3eb:3843:9f31 with SMTP id h15-20020a05600c350f00b003eb38439f31mr32779734wmq.10.1679324244157;
        Mon, 20 Mar 2023 07:57:24 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id bg5-20020a05600c3c8500b003e7f1086660sm16977466wmb.15.2023.03.20.07.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:57:23 -0700 (PDT)
Date:   Mon, 20 Mar 2023 15:57:18 +0100
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
Subject: Re: [RFC PATCH v1 1/3] virtio/vsock: fix header length on skb merging
Message-ID: <20230320145718.5gytg6t5pcz5rpnm@sgarzare-redhat>
References: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
 <63445f2f-a0bb-153c-0e15-74a09ea26dc1@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <63445f2f-a0bb-153c-0e15-74a09ea26dc1@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 09:51:06PM +0300, Arseniy Krasnov wrote:
>This fixes header length calculation of skbuff during data appending to
>it. When such skbuff is processed in dequeue callbacks, e.g. 'skb_pull()'
>is called on it, 'skb->len' is dynamic value, so it is impossible to use
>it in header, because value from header must be permanent for valid
>credit calculation ('rx_bytes'/'fwd_cnt').
>
>Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")

I don't understand how this commit introduced this problem, can you
explain it better?

Is it related more to the credit than to the size in the header itself?

Anyway, the patch LGTM, but we should explain better the issue.

Thanks,
Stefano

>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 6d15cd4d090a..3c75986e16c2 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1091,7 +1091,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 			memcpy(skb_put(last_skb, skb->len), skb->data, skb->len);
> 			free_pkt = true;
> 			last_hdr->flags |= hdr->flags;
>-			last_hdr->len = cpu_to_le32(last_skb->len);
>+			le32_add_cpu(&last_hdr->len, len);
> 			goto out;
> 		}
> 	}
>-- 
>2.25.1
>

