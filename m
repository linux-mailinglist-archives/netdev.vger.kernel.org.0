Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2344318BF4
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhBKNXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 08:23:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231408AbhBKNUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 08:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613049550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hmk14exEuAu1KNsA1eN9M3YU73ik9B3Wqe10eKOKhmo=;
        b=eH7uNJNTrHC/2bUAM5UTu2sM0WL4Zb9uF6dBNwE/fKDKXspPXbZJ1s3HVPybNgRfGzcdP4
        F9lzOhUTcrFUY81g9gfOyeW4U9JzfMKVm91Mm/tRTI66Z/FzyHStow1pZhUbv6fK+5W9za
        yH0Yk53JhDLB43xLDH24Bo3zKy66KW0=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-Cq2LfBN7MiK0oj-DsN1eRw-1; Thu, 11 Feb 2021 08:19:08 -0500
X-MC-Unique: Cq2LfBN7MiK0oj-DsN1eRw-1
Received: by mail-ej1-f72.google.com with SMTP id yh28so4829475ejb.11
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 05:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hmk14exEuAu1KNsA1eN9M3YU73ik9B3Wqe10eKOKhmo=;
        b=PEUjwBZPYyXzN8DjYc1dNkwTpbaiBSupB1NmzUm8lYvGaziczdMhOTH/HZEgzZcBOd
         JBRcvkxZ1Szc6R4UnMaGBaFNLIGXvRCGtHYdBp3gcdOTHf+C2DCevF0onOOZBYbhKA1W
         cZYdZ8VEGF2GHUlY1/1+Gf2k/IlG2f/+jwq/K2oE0wdB6ex0Cqpfla1rTZbcJ3gUnRj5
         hKEEIA+ymFZFEnkTuQSeYJbrarMc1FC/GJ872spQPVrzK1svsiDJFRrWZBL7H0AYsaKo
         vgPGIoD7YwAP4dkLjzJORbgDqpD8gyls4akQLIJAx1eNLDJkp4bls5zKXX2h7Azsg2/V
         Ka6g==
X-Gm-Message-State: AOAM532hFLbf5GLckvwfPLqe2syWMqy9fHJ5iVxDxeHB4nmMVLg++alz
        c1B53+3eX82VYFcOniDM/NA/j6y+af/YhbkP09nqAgoNmYkxtnuaKLnVKAvO5GIZIEhkKBeTcxw
        JVUdq3VwiIIcif0j3
X-Received: by 2002:a17:907:210d:: with SMTP id qn13mr8293110ejb.377.1613049547482;
        Thu, 11 Feb 2021 05:19:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxJgriiJCTazbhHBmTN5Qv/1jX0/Iyqy0dukmtptWSTg97rk7GMZLbA0+lOCu+wbSRGVi5hg==
X-Received: by 2002:a17:907:210d:: with SMTP id qn13mr8293081ejb.377.1613049547302;
        Thu, 11 Feb 2021 05:19:07 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id g22sm4356281ejw.31.2021.02.11.05.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 05:19:06 -0800 (PST)
Date:   Thu, 11 Feb 2021 14:19:04 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 08/17] af_vsock: update comments for stream sockets
Message-ID: <20210211131904.ejkq3gltlqcffduq@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151632.805240-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151632.805240-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:16:29PM +0300, Arseny Krasnov wrote:
>This replaces 'stream' to 'connect oriented' in comments as SEQPACKET is
>also connect oriented.

I'm not a native speaker but maybe is better 'connection oriented' or 
looking at socket(2) man page 'connection-based' is also fine.

Thanks,
Stefano

>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 31 +++++++++++++++++--------------
> 1 file changed, 17 insertions(+), 14 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index c77998a14018..6e5e192cb703 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -415,8 +415,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
>
> /* Assign a transport to a socket and call the .init transport callback.
>  *
>- * Note: for stream socket this must be called when vsk->remote_addr is set
>- * (e.g. during the connect() or when a connection request on a listener
>+ * Note: for connect oriented socket this must be called when vsk->remote_addr
>+ * is set (e.g. during the connect() or when a connection request on a listener
>  * socket is received).
>  * The vsk->remote_addr is used to decide which transport to use:
>  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
>@@ -479,10 +479,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 			return 0;
>
> 		/* transport->release() must be called with sock lock acquired.
>-		 * This path can only be taken during vsock_stream_connect(),
>-		 * where we have already held the sock lock.
>-		 * In the other cases, this function is called on a new socket
>-		 * which is not assigned to any transport.
>+		 * This path can only be taken during vsock_connect(), where we
>+		 * have already held the sock lock. In the other cases, this
>+		 * function is called on a new socket which is not assigned to
>+		 * any transport.
> 		 */
> 		vsk->transport->release(vsk);
> 		vsock_deassign_transport(vsk);
>@@ -659,9 +659,10 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>
> 	vsock_addr_init(&vsk->local_addr, new_addr.svm_cid, new_addr.svm_port);
>
>-	/* Remove stream sockets from the unbound list and add them to the hash
>-	 * table for easy lookup by its address.  The unbound list is simply an
>-	 * extra entry at the end of the hash table, a trick used by AF_UNIX.
>+	/* Remove connect oriented sockets from the unbound list and add them
>+	 * to the hash table for easy lookup by its address.  The unbound list
>+	 * is simply an extra entry at the end of the hash table, a trick used
>+	 * by AF_UNIX.
> 	 */
> 	__vsock_remove_bound(vsk);
> 	__vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
>@@ -952,10 +953,10 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 	if ((mode & ~SHUTDOWN_MASK) || !mode)
> 		return -EINVAL;
>
>-	/* If this is a STREAM socket and it is not connected then bail out
>-	 * immediately.  If it is a DGRAM socket then we must first kick the
>-	 * socket so that it wakes up from any sleeping calls, for example
>-	 * recv(), and then afterwards return the error.
>+	/* If this is a connect oriented socket and it is not connected then
>+	 * bail out immediately.  If it is a DGRAM socket then we must first
>+	 * kick the socket so that it wakes up from any sleeping calls, for
>+	 * example recv(), and then afterwards return the error.
> 	 */
>
> 	sk = sock->sk;
>@@ -1786,7 +1787,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>
> 	transport = vsk->transport;
>
>-	/* Callers should not provide a destination with stream sockets. */
>+	/* Callers should not provide a destination with connect oriented
>+	 * sockets.
>+	 */
> 	if (msg->msg_namelen) {
> 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
> 		goto out;
>-- 
>2.25.1
>

