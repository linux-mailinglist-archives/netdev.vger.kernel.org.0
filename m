Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D37321A38
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 15:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBVOWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 09:22:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231585AbhBVOTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 09:19:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614003496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4dczqn3yvtGdaJ4ItxeNsO6mMvqpqPNPelEeJ/DM0z8=;
        b=D9Znyra/izg0Sf6vTn0ntrFK/QjbOjknZ/jkWrXBqnohcuFlRHO7c0Z8QJZUYzPVB1YQMs
        jvUBIjr1BV5f784uJ9r+JY7wi5gTi0uq3NrLDKtBqr8C17mInUAabBwq6y1B5Fxogeiy27
        ZbMBp91dVOhbrnKAo/AxXk3eWF8jBFo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-lzLlVOLmP72J8gVETRdFBA-1; Mon, 22 Feb 2021 09:18:14 -0500
X-MC-Unique: lzLlVOLmP72J8gVETRdFBA-1
Received: by mail-wr1-f69.google.com with SMTP id v1so6165325wru.2
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 06:18:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4dczqn3yvtGdaJ4ItxeNsO6mMvqpqPNPelEeJ/DM0z8=;
        b=GHYGSz5vA42XzXe4EMrjqQ7Ei2+SpAF2VTmQAZzV38x6M/RPRsubzUaN15QIg4jqJy
         1bOi6u/Nt32zgnh9acV5MeMNHaZ9JN8WD1xOcEV9fq1Ej7DnvuPCzLJZSCnMUYV5xvxI
         HQf4UOtF1Qocitt4Dj5aiZ4Br8J9yda4gbfDY2Ccc3KaUgzTgErw2UITyLfOjGioRWyV
         AQPjuidZdTY7IaSUDVpX2GlEO1gEgT7EL6bgQC/uvQSODAb4MCUhmqYEJhxkQoldl1gt
         oYivnbSI1gJYqncTZUxt10LUtrV0dnlIHmse/xv7tllQAMUCUqAgEXjOnX0i0naNbLfg
         3yNA==
X-Gm-Message-State: AOAM533ScrVrkvIuppOa+CZ8/YAtWzSygU5t6qOSAV3H5mmVP6Sw/lNS
        ibxOj7y0EOvUfDBm96Dy+zV2NW88siP0nrdfLU5w29bs/+VYUyTW2Be2A6eFVjg8tLljTDvhqEV
        PEO58ltjaRmMSLpsK
X-Received: by 2002:adf:9031:: with SMTP id h46mr22072608wrh.19.1614003493370;
        Mon, 22 Feb 2021 06:18:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx3ZEW5m0LD2K3iKZRRGxx+XdzwaUrxqdU5eFOuJolpSBSUTb9lIA0xW6yKMdbESnoC8aNNjw==
X-Received: by 2002:adf:9031:: with SMTP id h46mr22072591wrh.19.1614003493149;
        Mon, 22 Feb 2021 06:18:13 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id q25sm20813231wmq.15.2021.02.22.06.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 06:18:12 -0800 (PST)
Date:   Mon, 22 Feb 2021 15:18:09 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v5 08/19] af_vsock: update comments for stream sockets
Message-ID: <20210222141809.6wcvglet4cpmcjlg@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053852.1067811-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210218053852.1067811-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 08:38:48AM +0300, Arseny Krasnov wrote:
>This replaces 'stream' to 'connect oriented' in comments as SEQPACKET is
                             ^ connection

You forgot to update the commit message :-)

With that fixed:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>also connect oriented.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 31 +++++++++++++++++--------------
> 1 file changed, 17 insertions(+), 14 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f4b02c6d35d1..f1bf6a5ad15e 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -415,8 +415,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
>
> /* Assign a transport to a socket and call the .init transport callback.
>  *
>- * Note: for stream socket this must be called when vsk->remote_addr is set
>- * (e.g. during the connect() or when a connection request on a listener
>+ * Note: for connection oriented socket this must be called when vsk->remote_addr
>+ * is set (e.g. during the connect() or when a connection request on a listener
>  * socket is received).
>  * The vsk->remote_addr is used to decide which transport to use:
>  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
>@@ -470,10 +470,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
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
>@@ -658,9 +658,10 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>
> 	vsock_addr_init(&vsk->local_addr, new_addr.svm_cid, new_addr.svm_port);
>
>-	/* Remove stream sockets from the unbound list and add them to the hash
>-	 * table for easy lookup by its address.  The unbound list is simply an
>-	 * extra entry at the end of the hash table, a trick used by AF_UNIX.
>+	/* Remove connection oriented sockets from the unbound list and add them
>+	 * to the hash table for easy lookup by its address.  The unbound list
>+	 * is simply an extra entry at the end of the hash table, a trick used
>+	 * by AF_UNIX.
> 	 */
> 	__vsock_remove_bound(vsk);
> 	__vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
>@@ -951,10 +952,10 @@ static int vsock_shutdown(struct socket *sock, int mode)
> 	if ((mode & ~SHUTDOWN_MASK) || !mode)
> 		return -EINVAL;
>
>-	/* If this is a STREAM socket and it is not connected then bail out
>-	 * immediately.  If it is a DGRAM socket then we must first kick the
>-	 * socket so that it wakes up from any sleeping calls, for example
>-	 * recv(), and then afterwards return the error.
>+	/* If this is a connection oriented socket and it is not connected then
>+	 * bail out immediately.  If it is a DGRAM socket then we must first
>+	 * kick the socket so that it wakes up from any sleeping calls, for
>+	 * example recv(), and then afterwards return the error.
> 	 */
>
> 	sk = sock->sk;
>@@ -1783,7 +1784,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>
> 	transport = vsk->transport;
>
>-	/* Callers should not provide a destination with stream sockets. */
>+	/* Callers should not provide a destination with connection oriented
>+	 * sockets.
>+	 */
> 	if (msg->msg_namelen) {
> 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
> 		goto out;
>-- 
>2.25.1
>

