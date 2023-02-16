Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB26699695
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjBPODe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjBPODd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:03:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0DD3CE11
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676556164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jLAlHrmg/N94k15P0ZdSVRRZ/25ME84tuyTznfQGswY=;
        b=iRE0RUNJumK0UiUp33RdE3tklvvERBq6LtaNMhj8wkrZvo2BpNQbFPti7Snts1so6Oa9K5
        IqhiLJK5w2MYFdYYxduQYEYCohMQdGf1ovjdNadw/JEjGa9ncpKHRLZjxgRjc+8YLWm0nr
        xYbVuyN2w2HClsu3TajDzuPFK3RbqmU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-47-Hmzyp601MBWP_TxhT08qyg-1; Thu, 16 Feb 2023 09:02:39 -0500
X-MC-Unique: Hmzyp601MBWP_TxhT08qyg-1
Received: by mail-qk1-f197.google.com with SMTP id a13-20020a05620a438d00b0073b88cae2f5so1226173qkp.8
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:02:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLAlHrmg/N94k15P0ZdSVRRZ/25ME84tuyTznfQGswY=;
        b=z67VB/vbT5H7mjViUzNTC7wRyH95IYKgABCbSC7n6SvUysQ+Oox20/4MW8Xp3C9f6h
         3/Bp9S6mvZOVpyrgrghMX573WJogQcZe+9McDPa8R0iWtOI7JcMPF5NdnLKgrmX0TRFP
         wW1LBr+NMWFelw80nWpIKROEjCzb5n8NiprRgTcJ1+Kr1pSlHvMKdQKHp6n7k2G+mV6Q
         GbHK/du+1DYcjQJmvc1lqfD7u7pNPXXTxalF7vDF4itbaNI4m3V6YnM2Mf8F6/5TsOPR
         W3w7Yt2IGOoGsdyKejv3+EGZLWRrM8S825OV2U34e1bKPYcvkPnUK5Aoc9xvp04zXp4o
         gwGw==
X-Gm-Message-State: AO0yUKXCLqkW6vYfM31upTMapRBHDjZ8SlPhVFuarI3+cxR5rSPusfpu
        sgstaJ8Ca9osJG4CX/5SVSYRsyX8I1qLxI0B65JFIqGmqZtfnVy29i5i5+qZnHySUWGiE1VJDZ5
        O6x7fvzrQV8gqSVUisz4h6w==
X-Received: by 2002:ad4:5cad:0:b0:56e:af4a:11f8 with SMTP id q13-20020ad45cad000000b0056eaf4a11f8mr11940065qvh.4.1676556157890;
        Thu, 16 Feb 2023 06:02:37 -0800 (PST)
X-Google-Smtp-Source: AK7set+9m6lSguHPttaA6t6O/ygFLCA9e+/4Kab1ifq4gqWCNbHN1aAIRLEgnyZQl/IvOoVqpE1rDw==
X-Received: by 2002:ad4:5cad:0:b0:56e:af4a:11f8 with SMTP id q13-20020ad45cad000000b0056eaf4a11f8mr11940021qvh.4.1676556157593;
        Thu, 16 Feb 2023 06:02:37 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id w3-20020a379403000000b006bb29d932e1sm1198761qkd.105.2023.02.16.06.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:02:37 -0800 (PST)
Date:   Thu, 16 Feb 2023 15:02:30 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 03/12] vsock: check for MSG_ZEROCOPY support
Message-ID: <20230216140230.3ee2362owceyflf3@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <d6c8c90f-bf0b-b310-2737-27d3741f2043@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d6c8c90f-bf0b-b310-2737-27d3741f2043@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:55:46AM +0000, Arseniy Krasnov wrote:
>This feature totally depends on transport, so if transport doesn't
>support it, return error.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/net/af_vsock.h   | 2 ++
> net/vmw_vsock/af_vsock.c | 7 +++++++
> 2 files changed, 9 insertions(+)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 568a87c5e0d0..96d829004c81 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -173,6 +173,8 @@ struct vsock_transport {
>
> 	/* Addressing. */
> 	u32 (*get_local_cid)(void);
>+

LGTM, just add comment here for a new section following what we did for
other callaback, e.g.:

         /* Zero-copy. */
>+	bool (*msgzerocopy_allow)(void);
> };
>
> /**** CORE ****/
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f752b30b71d6..fb0fcb390113 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1788,6 +1788,13 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 		goto out;
> 	}
>
>+	if (msg->msg_flags & MSG_ZEROCOPY &&
>+	    (!transport->msgzerocopy_allow ||
>+	     !transport->msgzerocopy_allow())) {
>+		err = -EOPNOTSUPP;
>+		goto out;
>+	}
>+
> 	/* Wait for room in the produce queue to enqueue our user's data. */
> 	timeout = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
>
>-- 
>2.25.1

