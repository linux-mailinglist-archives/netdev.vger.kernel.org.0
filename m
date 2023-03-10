Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567656B39BF
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCJJL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjCJJLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:11:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB9E113891
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678439111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sSp+VIKj40Odq1TE8zG+B/+GmimzIKfK2Y2IeLufmS4=;
        b=DJ5NF9n3UQue5QgUgiVy493i5Fhv6ZqWidDkTJwysrSNhBdPKPffQKZRjMd6fN5AnZyLGB
        CCitkZB0cZBEk08/WpTPna1wO2nUZMavmxykRvj8fSMtUYxrUVnmhldMZnvZnc8usgKDQR
        8St1r8TJIxQ9acKJgbi/hMg2is56QTg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-GMo3c8zFObCen39l1tcUEw-1; Fri, 10 Mar 2023 04:05:09 -0500
X-MC-Unique: GMo3c8zFObCen39l1tcUEw-1
Received: by mail-wr1-f69.google.com with SMTP id bh3-20020a05600005c300b002c70d6e2014so924863wrb.10
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678439107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSp+VIKj40Odq1TE8zG+B/+GmimzIKfK2Y2IeLufmS4=;
        b=peFdo+FMtNz2vTKCdG6R6ei11MP5bEqGgxoFVpVCGafvpIq/+fEJv8ju79QvEsYG4I
         50ygTP+0SSJsWWEkEDeDhMakXepKouIA4dFmhSPArX4mO/AFgXI54MJwgm+QepVS+sfB
         Dkp/Vljj+rVfkSy1LKkaZRGFIrwhIiEuSObckmaEMRJhMZ6mpyXxS403nZmJXjO7QKsc
         1jk5AqMVz2gAleiLIOoCEBFbYrnM2hdHudOGkK4GZNukesbKY7srtwF73R2WR1B0PZdQ
         8iGRwGK91e2P+Q0f+hf64QTA2FuKk6Hbqwfjt/G9+TXtesLCTA2tjxpZwiAS6C2ku1CV
         6MPw==
X-Gm-Message-State: AO0yUKUqy/Npxc5wC0zGUAtBSsuxPf5xYIqQNg/iQCZabjknYbJICj4e
        ztHc/5fDFcdOaXTUh9ULHhbHqLJgao8rSeOTdNe5v8wGFZehmv6QcdhlL2Qc+fPSlyl35ZYIIZl
        ltUJ/+DxE0DJruqic
X-Received: by 2002:adf:dd49:0:b0:2c7:1aaa:750 with SMTP id u9-20020adfdd49000000b002c71aaa0750mr15972649wrm.66.1678439107741;
        Fri, 10 Mar 2023 01:05:07 -0800 (PST)
X-Google-Smtp-Source: AK7set9DduuuLAv+i3q26KYq40a81V24NkG6hIbjnT7zANoOAvamzKFyI9Hk66z6o3kwzE7qfxgfdg==
X-Received: by 2002:adf:dd49:0:b0:2c7:1aaa:750 with SMTP id u9-20020adfdd49000000b002c71aaa0750mr15972636wrm.66.1678439107465;
        Fri, 10 Mar 2023 01:05:07 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d5407000000b002c569acab1esm1590111wrv.73.2023.03.10.01.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:05:06 -0800 (PST)
Date:   Fri, 10 Mar 2023 10:05:04 +0100
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
Subject: Re: [RFC PATCH v4 2/4] virtio/vsock: remove redundant 'skb_pull()'
 call
Message-ID: <20230310090504.joeyn4l65pcd3anh@sgarzare-redhat>
References: <1804d100-1652-d463-8627-da93cb61144e@sberdevices.ru>
 <6260a6cc-bd69-72a6-8aa5-34ff68764287@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <6260a6cc-bd69-72a6-8aa5-34ff68764287@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 11:27:02PM +0300, Arseniy Krasnov wrote:
>Since we now no longer use 'skb->len' to update credit, there is no sense
>to update skbuff state, because it is used only once after dequeue to
>copy data and then will be released.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 1 -
> 1 file changed, 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 618680fd9906..9a411475e201 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -465,7 +465,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 					dequeued_len = err;
> 				} else {
> 					user_buf_len -= bytes_to_copy;
>-					skb_pull(skb, bytes_to_copy);
> 				}
>
> 				spin_lock_bh(&vvs->rx_lock);
>-- 
>2.25.1
>

