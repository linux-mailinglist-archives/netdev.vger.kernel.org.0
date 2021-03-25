Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAAA348C30
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhCYJHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 05:07:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229669AbhCYJGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 05:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616663199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yTJfubzS7O7K/IVv79ceaGJUkFP1xXgqWQXScYQW8Qg=;
        b=KPMgKeHe1M4rNt90kQPeg92UwjzdRDdECWr4SfV3d/gt7U2WJjChz7H21XGkJyeKNsXewa
        iAveY1X/ApWWC/T0/Uci/PPXGuuI6F3Ktbg0rTNSX2lzLloqgls5Jvvi+73OrlPLS9PXRE
        s6c97C5uizL7xkifrhgzuJvs+rJWREk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-w2T9xXwPNgKFM5YSRBn6YQ-1; Thu, 25 Mar 2021 05:06:37 -0400
X-MC-Unique: w2T9xXwPNgKFM5YSRBn6YQ-1
Received: by mail-wr1-f72.google.com with SMTP id p15so2328992wre.13
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 02:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yTJfubzS7O7K/IVv79ceaGJUkFP1xXgqWQXScYQW8Qg=;
        b=d/A2Sm3R4WbgswymEb+kLO6wlBlwkLs95JAae/GKyn6ef7KtbNj3D4NtDg2lbGHX8g
         quyn81K1TRnz3u3+JKJdu2Jdhim+PAcFT6HQVN5nDe9Z83/wvVgYibyzepj7PnRCNMyW
         u9whtJtSUoWKl3lcAYvJte9vCbtlBXhT1aPzypVxQolnWw4xfz0eA2ihpG9doZJPrRMX
         gtDEiZud+d2oGo4VVukB8swqGg1T5Eb1xSTUOn57deYUYrSOmQPexC9suSJdPTp3jyiA
         AMvO35hlHXBtaN/wecfwSu8uJKO9S2wwBCTo6ds3G3Xj4vyZyg+ITYsfPepxItPNNjEG
         om/A==
X-Gm-Message-State: AOAM530r6tLuiEFpppgvG+BmYb2TCaVEYxL6Djl+3mcUgMNRG9zp1ibk
        aKjFmDnKuR44wEN3Lqayye/Ly/D8PutCKeX6PI4b9uonVUJpqfG/mZDgu09Yx0zBvV71TPp3hQo
        kLQfQpVJKIbx197RL
X-Received: by 2002:a05:600c:4f8e:: with SMTP id n14mr6987777wmq.34.1616663195629;
        Thu, 25 Mar 2021 02:06:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxor6DwX21nVsRBJYaahvDSiYmgc/i+EkrFRyebbt+hCSZ3Fo4Ng/+V2eKVoZdbnmON15WOqQ==
X-Received: by 2002:a05:600c:4f8e:: with SMTP id n14mr6987710wmq.34.1616663194922;
        Thu, 25 Mar 2021 02:06:34 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id 81sm5626680wmc.11.2021.03.25.02.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 02:06:34 -0700 (PDT)
Date:   Thu, 25 Mar 2021 10:06:31 +0100
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
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 03/22] af_vsock: separate receive data loop
Message-ID: <20210325090631.4o5lc2kgyb4uzslh@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323130939.2459901-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323130939.2459901-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 04:09:36PM +0300, Arseny Krasnov wrote:
>Move STREAM specific data receive logic to '__vsock_stream_recvmsg()'
>dedicated function, while checks, that will be same for both STREAM
>and SEQPACKET sockets, stays in 'vsock_connectible_recvmsg()' shared
>functions.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/af_vsock.c | 116 ++++++++++++++++++++++-----------------
> 1 file changed, 67 insertions(+), 49 deletions(-)

I had already reviewed this in v5 and in v6 you reported the R-b tag.

Usually the tag gets removed if you make changes to the patch or the 
reviewer is no longer happy. But this doesn't seem to be the case.

So please keep the tags between versions :-)


Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 421c0303b26f..0bc661e54262 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1895,65 +1895,22 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
> 	return data;
> }
>
>-static int
>-vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>-			  int flags)
>+static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
>+				  size_t len, int flags)
> {
>-	struct sock *sk;
>-	struct vsock_sock *vsk;
>+	struct vsock_transport_recv_notify_data recv_data;
> 	const struct vsock_transport *transport;
>-	int err;
>-	size_t target;
>+	struct vsock_sock *vsk;
> 	ssize_t copied;
>+	size_t target;
> 	long timeout;
>-	struct vsock_transport_recv_notify_data recv_data;
>+	int err;
>
> 	DEFINE_WAIT(wait);
>
>-	sk = sock->sk;
> 	vsk = vsock_sk(sk);
>-	err = 0;
>-
>-	lock_sock(sk);
>-
> 	transport = vsk->transport;
>
>-	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
>-		/* Recvmsg is supposed to return 0 if a peer performs an
>-		 * orderly shutdown. Differentiate between that case and when a
>-		 * peer has not connected or a local shutdown occured with the
>-		 * SOCK_DONE flag.
>-		 */
>-		if (sock_flag(sk, SOCK_DONE))
>-			err = 0;
>-		else
>-			err = -ENOTCONN;
>-
>-		goto out;
>-	}
>-
>-	if (flags & MSG_OOB) {
>-		err = -EOPNOTSUPP;
>-		goto out;
>-	}
>-
>-	/* We don't check peer_shutdown flag here since peer may actually shut
>-	 * down, but there can be data in the queue that a local socket can
>-	 * receive.
>-	 */
>-	if (sk->sk_shutdown & RCV_SHUTDOWN) {
>-		err = 0;
>-		goto out;
>-	}
>-
>-	/* It is valid on Linux to pass in a zero-length receive buffer.  This
>-	 * is not an error.  We may as well bail out now.
>-	 */
>-	if (!len) {
>-		err = 0;
>-		goto out;
>-	}
>-
> 	/* We must not copy less than target bytes into the user's buffer
> 	 * before returning successfully, so we wait for the consume queue to
> 	 * have that much data to consume before dequeueing.  Note that this
>@@ -2012,6 +1969,67 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	if (copied > 0)
> 		err = copied;
>
>+out:
>+	return err;
>+}
>+
>+static int
>+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>+			  int flags)
>+{
>+	struct sock *sk;
>+	struct vsock_sock *vsk;
>+	const struct vsock_transport *transport;
>+	int err;
>+
>+	DEFINE_WAIT(wait);
>+
>+	sk = sock->sk;
>+	vsk = vsock_sk(sk);
>+	err = 0;
>+
>+	lock_sock(sk);
>+
>+	transport = vsk->transport;
>+
>+	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
>+		/* Recvmsg is supposed to return 0 if a peer performs an
>+		 * orderly shutdown. Differentiate between that case and when a
>+		 * peer has not connected or a local shutdown occurred with the
>+		 * SOCK_DONE flag.
>+		 */
>+		if (sock_flag(sk, SOCK_DONE))
>+			err = 0;
>+		else
>+			err = -ENOTCONN;
>+
>+		goto out;
>+	}
>+
>+	if (flags & MSG_OOB) {
>+		err = -EOPNOTSUPP;
>+		goto out;
>+	}
>+
>+	/* We don't check peer_shutdown flag here since peer may actually shut
>+	 * down, but there can be data in the queue that a local socket can
>+	 * receive.
>+	 */
>+	if (sk->sk_shutdown & RCV_SHUTDOWN) {
>+		err = 0;
>+		goto out;
>+	}
>+
>+	/* It is valid on Linux to pass in a zero-length receive buffer.  This
>+	 * is not an error.  We may as well bail out now.
>+	 */
>+	if (!len) {
>+		err = 0;
>+		goto out;
>+	}
>+
>+	err = __vsock_stream_recvmsg(sk, msg, len, flags);
>+
> out:
> 	release_sock(sk);
> 	return err;
>-- 
>2.25.1
>

