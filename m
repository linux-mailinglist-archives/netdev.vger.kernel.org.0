Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F22E579F9D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiGSN3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239580AbiGSN2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:28:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1323885D43
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658234680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nwoURb29VClO3NnOpfstDR3d53hCEYhJJWEs1w35jSE=;
        b=Lsr2t1MhPK7rsygzSoiCs7YiMfQrlv/MmxOOLM/xtwVHHJIlvzkaXUIGJqIFKJaApNkfeQ
        HvC1OMWj4v0bKQxuOAP8u3PNKclzWfS27LdHEIsSyuoUaP5R7m84NaeebAE4hjdFX679pJ
        0yx/MkKj+H6AeLMl7tpLJ/WYx9mdc9c=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-u0gcIinbPdqoNlp7XLA8nQ-1; Tue, 19 Jul 2022 08:44:38 -0400
X-MC-Unique: u0gcIinbPdqoNlp7XLA8nQ-1
Received: by mail-qv1-f69.google.com with SMTP id q4-20020a0ce9c4000000b00473004919ddso7316884qvo.16
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nwoURb29VClO3NnOpfstDR3d53hCEYhJJWEs1w35jSE=;
        b=uh9Z6ByCcKVtqWp7GnRa33DmNJgLbMU2LlDYshtPmHtB3cH/ZR7aFkdIJwEnkAZhLK
         3XgeghC1CrRamwgWoeVV8Xy7BOK5FxD1L3758peBFU0oBt7LVc/KuA7JCRtEKLFMsX3F
         srv6pNlfy2vBRUbQnbmyT74snDXXZc0HTuAE3uvDj7Tin9GmbSQ49Z0KocGTiB/3G3dE
         TlRN7ES29z/uSxrLJ0M1RR8KsSx6e59PdQv7P/j5KPuTgaD/WO+rqAp/ZMmBFD3Lafjb
         PwrkSk95XrvfchqShiiBr9N2UVXGa9ek49HcMn+ZMCjnP8xQjho3cn8i3gOA60QWHYLc
         ks4w==
X-Gm-Message-State: AJIora+KFfdTRdMZrG8ykiMTJ0tum9GmeIMx9VoJYFSq8gntVssOiLg1
        GsFDr3X2wDQdosamoPjNJEjtVZElUnKO83Xt4lGAWwHgT0o5+r+YVJakpsMqZKiphVqNB8gXCxv
        AEPE2yc+lrYjpbwb7
X-Received: by 2002:a05:620a:4409:b0:6b5:9563:2357 with SMTP id v9-20020a05620a440900b006b595632357mr20517120qkp.394.1658234678311;
        Tue, 19 Jul 2022 05:44:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vfYt5xMGWnPHxRK79lORLDfPCOEjuG06J02WcZOiurWkTLl4+3VDRo/4HLmjvxNof1xrPgsQ==
X-Received: by 2002:a05:620a:4409:b0:6b5:9563:2357 with SMTP id v9-20020a05620a440900b006b595632357mr20517108qkp.394.1658234678086;
        Tue, 19 Jul 2022 05:44:38 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id t13-20020a37ea0d000000b006af147d4876sm13363159qkj.30.2022.07.19.05.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:44:37 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:44:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 1/3] vsock: use sk_skrcvlowat to set
 POLLIN,POLLRDNORM, bits.
Message-ID: <20220719124429.3y5hi7itx4hdkqbz@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <637e945f-f28a-86d9-a242-1f4be85d9840@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <637e945f-f28a-86d9-a242-1f4be85d9840@sberdevices.ru>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 08:15:42AM +0000, Arseniy Krasnov wrote:
>Both bits indicate, that next data read call won't be blocked,
>but when sk_rcvlowat is not 1,these bits will be set by poll
>anyway,thus when user tries to dequeue data, it will wait until
>sk_rcvlowat bytes of data will be available.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f04abf662ec6..0225f3558e30 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1067,7 +1067,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 		    !(sk->sk_shutdown & RCV_SHUTDOWN)) {
> 			bool data_ready_now = false;
> 			int ret = transport->notify_poll_in(
>-					vsk, 1, &data_ready_now);
>+					vsk, sk->sk_rcvlowat, &data_ready_now);

In tcp_poll() we have the following:
     int target = sock_rcvlowat(sk, 0, INT_MAX);

Maybe we can do the same here.

Thanks,
Stefano

> 			if (ret < 0) {
> 				mask |= EPOLLERR;
> 			} else {
>-- 
>2.25.1

