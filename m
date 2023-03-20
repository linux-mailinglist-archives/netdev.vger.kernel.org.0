Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048B56C1438
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCTN7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCTN7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:59:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAD5132EB
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 06:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679320700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xluQCIRM9KUg+iS1ks5cvU7xSezg5DUOPbgJwMPELqs=;
        b=Sm9JlDfMdBi7ddhsh2/XN/JSHCDATjK/tsJpw7ocyuj4oRsQuoig/LpmpfmBc1tg6sWmzx
        c9hJ8/w8y7LEYEAmYRwCTG4pyA9lvuKQHv2QDOIc/10qhDkEcdHeNhQf7YBaeSqkeTJiA5
        OImKX+fnYFR7ZK29js7n4iHUrxeFamE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-w-4AVXInNXqBVSg9iW6i0g-1; Mon, 20 Mar 2023 09:58:18 -0400
X-MC-Unique: w-4AVXInNXqBVSg9iW6i0g-1
Received: by mail-wr1-f69.google.com with SMTP id m5-20020a056000024500b002ceaa6f78a0so1470470wrz.12
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 06:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679320698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xluQCIRM9KUg+iS1ks5cvU7xSezg5DUOPbgJwMPELqs=;
        b=WD0LScinoosslmS3kOsuSpgQEL7+9b+ck5GsnLZjOtHrvkHSotkhq2/zrC06RkD/OB
         8KYZiR9HizTkOoqazIidLsH77kV0PQg43C72zZ0ufLS7l7kxs9STsYTGZSXXJWeW2KZQ
         o5mg89bRRlAV74mykzN1S6GtMt5TbvmnctiKrdX6MKBVjvW+4eb4CUF3vfPTPZUFR9KM
         v6d6FMLXaC1K1foODkJGbQ/U9VDaenu2zZd1dD3aHZzVVdP+0n4uUMmJ/Q9ThcPXPDvj
         W3QbZHzgOijTUsB9LrHtdXlWRCuvZuLekMWLZVO63nBy/9bF2bxTbw3eeu0v6VDgLkrT
         wxUA==
X-Gm-Message-State: AO0yUKV2VzvsyYRYoMqGAofcOQB4A1ZcTipgCUTQj+GxSltYGIqy/t4t
        ffmb0u5zPrujqJYwALk59tF6CIOFQhqaURQ6mrDA4hQKndcnaxXaHKFTWCOZDrVeD/O0oz6b2Gs
        +x2YHwaKkhkHg7M7w
X-Received: by 2002:adf:ce11:0:b0:2c7:851:c0bf with SMTP id p17-20020adfce11000000b002c70851c0bfmr13818703wrn.0.1679320697841;
        Mon, 20 Mar 2023 06:58:17 -0700 (PDT)
X-Google-Smtp-Source: AK7set+FUDvH/psBKoCx/B613vRQOYlndcOrSX0ahkGfyMMplDZBRpmL9wOqCuvTHwUfmOLfiNDOAg==
X-Received: by 2002:adf:ce11:0:b0:2c7:851:c0bf with SMTP id p17-20020adfce11000000b002c70851c0bfmr13818684wrn.0.1679320697599;
        Mon, 20 Mar 2023 06:58:17 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id s13-20020a5d510d000000b002c794495f6fsm5977998wrt.117.2023.03.20.06.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 06:58:17 -0700 (PDT)
Date:   Mon, 20 Mar 2023 14:58:14 +0100
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
Subject: Re: [RFC PATCH v1] virtio/vsock: check transport before skb
 allocation
Message-ID: <20230320135814.jncpvznka56liu36@sgarzare-redhat>
References: <47a7dbf6-1c63-3338-5102-122766e6378d@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <47a7dbf6-1c63-3338-5102-122766e6378d@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:37:10PM +0300, Arseniy Krasnov wrote:
>Pointer to transport could be checked before allocation of skbuff, thus
>there is no need to free skbuff when this pointer is NULL.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)

LGTM, I think net-next is fine for this.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index cda587196475..607149259e8b 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -867,6 +867,9 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> 	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
> 		return 0;
>
>+	if (!t)
>+		return -ENOTCONN;
>+
> 	reply = virtio_transport_alloc_skb(&info, 0,
> 					   le64_to_cpu(hdr->dst_cid),
> 					   le32_to_cpu(hdr->dst_port),
>@@ -875,11 +878,6 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> 	if (!reply)
> 		return -ENOMEM;
>
>-	if (!t) {
>-		kfree_skb(reply);
>-		return -ENOTCONN;
>-	}
>-
> 	return t->send_pkt(reply);
> }
>
>-- 
>2.25.1
>

