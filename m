Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA09318A55
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhBKMVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:21:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231838AbhBKMSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:18:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613045828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E1yuAMx44/76bqf49DYn2JPHR26BQBuYBzfgeTpXepM=;
        b=KWiWyuSznwEJ9pJGtsD9tGKV8TGI+4qn/cUyC/lvausgwslgVPE6aAOiqAvlkwZ673NLX+
        x7MAX2RBir7Ax0wgfP/pc/6B+12nm5/raX/fRppMSbJ6K5l5L7NrRKcBZzlZuViA4Jpsyw
        9cw5e3UdrhpPZnrNuvs9eSii0L6ugRM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-_2rn86xbPlWDyd7cIvyCkA-1; Thu, 11 Feb 2021 07:17:06 -0500
X-MC-Unique: _2rn86xbPlWDyd7cIvyCkA-1
Received: by mail-ej1-f69.google.com with SMTP id 7so4734617ejh.10
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 04:17:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E1yuAMx44/76bqf49DYn2JPHR26BQBuYBzfgeTpXepM=;
        b=NChsP62bLGGKkJ0Kpw4gcYkz/BWFJVE+c3fPMtRZ6g7eii4l/7GqESI1uJR5tjIDIB
         ceK7S1ax8+P6QYYjjPuexNJKE0NJ2L1LhZP1rbbNolmN60Q7gC6+J7URwyiD9W5nhaa2
         4NpM1zPDh3fAm6jZxkDylO0OXicZ5mb25zxwl4D7hsNwwXwp5z3jq7V/2vhuRzQ3FGHH
         XWqfheY7Xk+9eRwICZRgRBqFG8HWObky6T+W/QIFiYPjyJiYZY0nEtKdLkLK2R1wIFKj
         SQHB8l4fenD27+4T49Z/gJzEGigyubO776kYB22f3g8CnBEVBmkOiagFPn5OGv+GTWNA
         VZFg==
X-Gm-Message-State: AOAM531m3txRnKQwqL95LQQE3/rQ/Tai4AEWA8OP8fm7YstEuvKsLe9R
        ZT3M8od9tRvlIyXD/Z6WU0pNv6kF5YxYl/sHwiHch9tDn7ytfl+TiVgfvTe379HsL6nPBXIFV/O
        EP5wuVBjYAyqPTEPS
X-Received: by 2002:aa7:d6c2:: with SMTP id x2mr8057402edr.225.1613045825262;
        Thu, 11 Feb 2021 04:17:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxarfD0dC+o1lTaNaYi8iRDZFDf94i0xlVO9sO1P+pAXgRHpADAlujD3wU7pg5278zwtG18ww==
X-Received: by 2002:aa7:d6c2:: with SMTP id x2mr8057363edr.225.1613045825000;
        Thu, 11 Feb 2021 04:17:05 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id hr31sm4057322ejc.125.2021.02.11.04.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:17:04 -0800 (PST)
Date:   Thu, 11 Feb 2021 13:17:01 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 06/17] af_vsock: implement send logic for SEQPACKET
Message-ID: <20210211121701.4em23vgsqfdkdp5j@steredhat>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
 <20210207151600.804998-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210207151600.804998-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 06:15:57PM +0300, Arseny Krasnov wrote:
>This adds some logic to current stream enqueue function for SEQPACKET
>support:
>1) Send record's begin/end marker.
>2) Return value from enqueue function is whole record length or error
>   for SOCK_SEQPACKET.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> include/net/af_vsock.h   |  2 ++
> net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++--
> 2 files changed, 22 insertions(+), 2 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 19f6f22821ec..198d58c4c7ee 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -136,6 +136,8 @@ struct vsock_transport {
> 	bool (*stream_allow)(u32 cid, u32 port);
>
> 	/* SEQ_PACKET. */
>+	int (*seqpacket_seq_send_len)(struct vsock_sock *, size_t len, int flags);
>+	int (*seqpacket_seq_send_eor)(struct vsock_sock *, int flags);

As before, we could add the identifier of the parameters.

Other than that, the patch LGTM.

Stefano

> 	size_t (*seqpacket_seq_get_len)(struct vsock_sock *);
> 	int (*seqpacket_dequeue)(struct vsock_sock *, struct msghdr *,
> 				     int flags, bool *msg_ready);
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index ea99261e88ac..a033d3340ac4 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1806,6 +1806,12 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 	if (err < 0)
> 		goto out;
>
>+	if (sk->sk_type == SOCK_SEQPACKET) {
>+		err = transport->seqpacket_seq_send_len(vsk, len, msg->msg_flags);
>+		if (err < 0)
>+			goto out;
>+	}
>+
> 	while (total_written < len) {
> 		ssize_t written;
>
>@@ -1852,9 +1858,21 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
>
> 	}
>
>+	if (sk->sk_type == SOCK_SEQPACKET) {
>+		err = transport->seqpacket_seq_send_eor(vsk, msg->msg_flags);
>+		if (err < 0)
>+			goto out;
>+	}
>+
> out_err:
>-	if (total_written > 0)
>-		err = total_written;
>+	if (total_written > 0) {
>+		/* Return number of written bytes only if:
>+		 * 1) SOCK_STREAM socket.
>+		 * 2) SOCK_SEQPACKET socket when whole buffer is sent.
>+		 */
>+		if (sk->sk_type == SOCK_STREAM || total_written == len)
>+			err = total_written;
>+	}
> out:
> 	release_sock(sk);
> 	return err;
>-- 
>2.25.1
>

