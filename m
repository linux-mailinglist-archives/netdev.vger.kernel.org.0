Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D82637F953
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhEMOD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:03:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234333AbhEMODH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620914517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dzzbRMtR/ux/HKuN2b3P0GhQTxIlq9su8CHUI1jg3KU=;
        b=Y+/NjYVxriVMEgHdollIs0X5qa0spvcGG/+6d0RSH43Njn/RYkB8mzRHuiRQ8rc/sXEEbn
        zC+3DUHSGj73mCOlzbhPvYO+IT7/xGTyYUtRXp+07bAuy25UBWmYn7CJDQw4a25YiDJE+n
        IQ3WKpzDG/DANcGoF9kqtyI4GaTg860=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-SpFxmKWeMbqO2My-AAtclQ-1; Thu, 13 May 2021 10:01:55 -0400
X-MC-Unique: SpFxmKWeMbqO2My-AAtclQ-1
Received: by mail-ed1-f71.google.com with SMTP id p8-20020aa7c8880000b029038ce714c8d6so346502eds.10
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 07:01:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dzzbRMtR/ux/HKuN2b3P0GhQTxIlq9su8CHUI1jg3KU=;
        b=tQR8Sb6nrJS4rqluAWM5NVCVVeqewC6uK5sSqleMC81SAlULHQZp0JVkkpwqcnMMlX
         8Mo0inqZhKrGzKSbuv08HZ2L4xftiNaN1wkGgwid1T75NpqYf6F3krcoNiqYSX75ml38
         OSimLhIw2HTmjhFmLIvIdG4MKG2eFeRep4OCISXrq+kJ91V0nSPUPJ6tMOwdaD0YJxHD
         NDTLXBIET+GJ4/+yiU+u3yNdDlrH+C8vD6i3x8UrFsATBStGhJJpqJPobIbyniVQnOHW
         nW662RYnwsjmP0ZJBTLmdT+E6SvdfEc9b9a9vbWKR/TGOAmp90bA7wLmkOvn2XEsDsaK
         JRPg==
X-Gm-Message-State: AOAM531uYuFeMLd4t6xGFpp5Z2rT0BmnN1f4UWMaVSIFdgmobXdUuOQv
        XS9M1PwlJRut2A64Hucp9m8GSwloJHtzuzcsn3yqvP1TgqKNKjKDEjrepW+jtVEYHyXeHT/t9hJ
        vA6sYB8pWpmkpRrzY
X-Received: by 2002:a17:906:dc8:: with SMTP id p8mr43396598eji.75.1620914513353;
        Thu, 13 May 2021 07:01:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw39IWhXvW7OgV46gQBGVCcCQQk3NNZ/aEpvFouiESvkXXJwhBo18CCtS6V20sKwwrVlEsIFQ==
X-Received: by 2002:a17:906:dc8:: with SMTP id p8mr43396565eji.75.1620914513141;
        Thu, 13 May 2021 07:01:53 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id x7sm1820591ejc.116.2021.05.13.07.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 07:01:52 -0700 (PDT)
Date:   Thu, 13 May 2021 16:01:50 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 19/19] af_vsock: serialize writes to shared socket
Message-ID: <20210513140150.ugw6foy742fxan4w@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163738.3432975-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163738.3432975-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 08, 2021 at 07:37:35PM +0300, Arseny Krasnov wrote:
>This add logic, that serializes write access to single socket
>by multiple threads. It is implemented be adding field with TID
>of current writer. When writer tries to send something, it checks
>that field is -1(free), else it sleep in the same way as waiting
>for free space at peers' side.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 10 +++++++++-
> 2 files changed, 10 insertions(+), 1 deletion(-)

I think you forgot to move this patch at the beginning of the series.
It's important because in this way we can backport to stable branches 
easily.

About the implementation, can't we just add a mutex that we hold until 
we have sent all the payload?

I need to check other implementations like TCP.

>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 1747c0b564ef..413343f18e99 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -69,6 +69,7 @@ struct vsock_sock {
> 	u64 buffer_size;
> 	u64 buffer_min_size;
> 	u64 buffer_max_size;
>+	pid_t tid_owner;
>
> 	/* Private to transport. */
> 	void *trans;
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 7790728465f4..1fb4a1860f6d 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -757,6 +757,7 @@ static struct sock *__vsock_create(struct net *net,
> 	vsk->peer_shutdown = 0;
> 	INIT_DELAYED_WORK(&vsk->connect_work, vsock_connect_timeout);
> 	INIT_DELAYED_WORK(&vsk->pending_work, vsock_pending_work);
>+	vsk->tid_owner = -1;
>
> 	psk = parent ? vsock_sk(parent) : NULL;
> 	if (parent) {
>@@ -1765,7 +1766,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 		ssize_t written;
>
> 		add_wait_queue(sk_sleep(sk), &wait);
>-		while (vsock_stream_has_space(vsk) == 0 &&
>+		while ((vsock_stream_has_space(vsk) == 0 ||
>+			(vsk->tid_owner != current->pid &&
>+			 vsk->tid_owner != -1)) &&
> 		       sk->sk_err == 0 &&
> 		       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
> 		       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
>@@ -1796,6 +1799,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 				goto out_err;
> 			}
> 		}
>+
>+		vsk->tid_owner = current->pid;
> 		remove_wait_queue(sk_sleep(sk), &wait);
>
> 		/* These checks occur both as part of and after the loop
>@@ -1852,7 +1857,10 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 			err = total_written;
> 	}
> out:
>+	vsk->tid_owner = -1;
> 	release_sock(sk);
>+	sk->sk_write_space(sk);
>+

Is this change related? Can you explain in the commit message why it is 
needed?

> 	return err;
> }
>
>-- 
>2.25.1
>

