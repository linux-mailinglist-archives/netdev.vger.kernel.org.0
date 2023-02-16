Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E848A69966E
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBPN4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjBPN4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:56:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F3A3B3EB
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676555736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hii/hEJ9PZyd5sM9pg8DiE74V3lS3n6PlgGZ2jOvQQA=;
        b=hqHZ2K7N1FEyU91dO0tSTZrKz+YpIas6Zmlfz7ppDkaHrDrygBo6UDLy87TDkuCFYSrVzu
        YBeihVyE622TS1K1w70j8le1hS/hai53YeLlacQnbIJpqq2ZD6PMe/J1AB8aNzb3fUbwQf
        zZxDi7bYAD2jH6wvgn97u9tzi1+L1Qg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-631-gKm2DBtkOFmQ5ZWT6HZaig-1; Thu, 16 Feb 2023 08:55:35 -0500
X-MC-Unique: gKm2DBtkOFmQ5ZWT6HZaig-1
Received: by mail-qv1-f72.google.com with SMTP id t5-20020a0cef45000000b0056ecf4b8f5cso1085946qvs.19
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:55:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hii/hEJ9PZyd5sM9pg8DiE74V3lS3n6PlgGZ2jOvQQA=;
        b=G40bIpWthAqkh39jstCfy27plCmHpVY7KWa3tgm2kJLn965SZoL0MiDihmayWgm7IE
         5ufOf7+pvAAg5ARv6vTQ01HkeIhYtdNgRh5x/m9jP9ZpWbEIJ4VxIrfeh8rAtR5cY/xX
         urQVdwH+dh4xczQn4CEz4bDRzc4sGDsuzLog/3x8FA1/AhJmI8tgH/SiqSYEJbtD8qJn
         RxFoZcSUyaWC0Ak+FbNsYhDqmXj5EFFFyTLHD61/VGomdKL6qb9U1OLi8KCmCo9RZDjj
         yJvyeGEVT1T3JHrN6MHdd6ByuHmGbgDI6tnMq/dOxyGCnuJebVOTM3EqSW1YFvY6Ui7B
         GGpw==
X-Gm-Message-State: AO0yUKVW3ROk7Uyzv6G4gsQWVQ93nEWsw/jC17hVqEo0W3eNL6VaPeRY
        nqenAitssZHeNTcZBWi2i24NCBXZTu4C8vWKBYlcaOCIds3LYilUeb42oefLM5ls5yrC1M/bCuO
        g6lg3DBEReMqSc3HzPWqRyw==
X-Received: by 2002:ac8:5bd5:0:b0:3bb:8f10:6029 with SMTP id b21-20020ac85bd5000000b003bb8f106029mr10792531qtb.50.1676555734661;
        Thu, 16 Feb 2023 05:55:34 -0800 (PST)
X-Google-Smtp-Source: AK7set+JnPrAuwzQGhfHNhTBc/+z66FBbT4aDZCX6sfMD4/mj4mAXZ+i5dm9S21S3kppDEVaj0vlBQ==
X-Received: by 2002:ac8:5bd5:0:b0:3bb:8f10:6029 with SMTP id b21-20020ac85bd5000000b003bb8f106029mr10792507qtb.50.1676555734312;
        Thu, 16 Feb 2023 05:55:34 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id r188-20020a37a8c5000000b00729a26e836esm1206352qke.84.2023.02.16.05.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:55:33 -0800 (PST)
Date:   Thu, 16 Feb 2023 14:55:28 +0100
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
Subject: Re: [RFC PATCH v1 02/12] vsock: read from socket's error queue
Message-ID: <20230216135528.ge4otfhfv22p3htc@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <7b2f00ce-296c-3f59-9861-468c6340300e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7b2f00ce-296c-3f59-9861-468c6340300e@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:54:51AM +0000, Arseniy Krasnov wrote:
>This adds handling of MSG_ERRQUEUE input flag for receive call, thus
>skb from socket's error queue is read.

A general tip, add a little more description in the commit messages,
especially to explain why these changes are necessary.
Otherwise, even review becomes difficult because one has to look at all
the patches to understand what the previous ones are for.
I know it's boring, but it's very useful for those who review and even
then if we have to bisect ;-)

Thanks,
Stefano

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/linux/socket.h   |  1 +
> net/vmw_vsock/af_vsock.c | 26 ++++++++++++++++++++++++++
> 2 files changed, 27 insertions(+)
>
>diff --git a/include/linux/socket.h b/include/linux/socket.h
>index 13c3a237b9c9..19a6f39fa014 100644
>--- a/include/linux/socket.h
>+++ b/include/linux/socket.h
>@@ -379,6 +379,7 @@ struct ucred {
> #define SOL_MPTCP	284
> #define SOL_MCTP	285
> #define SOL_SMC		286
>+#define SOL_VSOCK	287
>
> /* IPX options */
> #define IPX_TYPE	1
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index b5e51ef4a74c..f752b30b71d6 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -110,6 +110,7 @@
> #include <linux/workqueue.h>
> #include <net/sock.h>
> #include <net/af_vsock.h>
>+#include <linux/errqueue.h>
>
> static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> static void vsock_sk_destruct(struct sock *sk);
>@@ -2086,6 +2087,27 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
> 	return err;
> }
>
>+static int vsock_err_recvmsg(struct sock *sk, struct msghdr *msg)
>+{
>+	struct sock_extended_err *ee;
>+	struct sk_buff *skb;
>+	int err;
>+
>+	lock_sock(sk);
>+	skb = sock_dequeue_err_skb(sk);
>+	release_sock(sk);
>+
>+	if (!skb)
>+		return -EAGAIN;
>+
>+	ee = &SKB_EXT_ERR(skb)->ee;
>+	err = put_cmsg(msg, SOL_VSOCK, 0, sizeof(*ee), ee);
>+	msg->msg_flags |= MSG_ERRQUEUE;
>+	consume_skb(skb);
>+
>+	return err;
>+}
>+
> static int
> vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 			  int flags)
>@@ -2096,6 +2118,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	int err;
>
> 	sk = sock->sk;
>+
>+	if (unlikely(flags & MSG_ERRQUEUE))
>+		return vsock_err_recvmsg(sk, msg);
>+
> 	vsk = vsock_sk(sk);
> 	err = 0;
>
>-- 
>2.25.1

