Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7481132A26
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 16:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgAGPis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 10:38:48 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:41140 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgAGPis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 10:38:48 -0500
Received: by mail-io1-f65.google.com with SMTP id c16so49471354ioo.8
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 07:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=laL5Et/tnqXix8pcJeVj+Yi7gV6H+jg8d0q8BZyW6sw=;
        b=byjRWHUedO1d56yL89C+qYnBLeWmlk9rZAKENAnZ7ofPXjFzEaaMTrONJiRy7iKDWq
         b/qnkmiUHqo6rHWZTXiw5hs5OYzruQ94f7c/FW4E5UwsDnhaQhqjX6pjOGXhIE0YNqrZ
         g+w/aWPwVi9Z1031pAeVAFP1s+8gqg4Vgq+XdZsszEs5q6TXywxh79PSUYpzwiebo5Bg
         M/QhkzH8CBfazeRvMsOgHY8JVM7XPS3DzkZc9KsaJnGsXl7eyPIvEjtgIFZ2DggsHo7J
         LINMIJN6pViIjzcULNMfHW52SA/F9TFpy6xpJI2jEHp9XEN+s8lsXpNjUBOWl6gTaKqH
         tWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=laL5Et/tnqXix8pcJeVj+Yi7gV6H+jg8d0q8BZyW6sw=;
        b=C00ncEh3HdyX7f/TFWV6F78tF4wPYBUNFfGXx1oxMQhi5gbFcQU5MpLm5cETiS4HW1
         ppxc71pvAOUGras62/58snzIJ/HRZeh+0TKLSEAu9LJaKrEmEbkGiKbllJNlf9qN4lbW
         MD2p9PTIvykKjEhQddCPeJHzPnrNlFgzdVMo+zB7q3NmWD0dQBKvzT5R755S6sjyaBg1
         8yd4bFPR8GTXIAP4DF4wgEkWKjZMLaohcujnXkJNWeuDMdnR/8AVF4IJ1n10uUdMqxD5
         uVoEDhzlIdsYFQZ4eAjicYpXVT0cJTqDmFAyze1fDdHCl7yqFLVLxNeP1ubmdCG8NzPh
         DGeA==
X-Gm-Message-State: APjAAAWwl9ZmWf1VeX6RJFinKDNivwNkPZfGe0udEDXEIsD4Ei6bK3/d
        2KOEgZS8jZOG21LVP6VNDKM=
X-Google-Smtp-Source: APXvYqymLotY+/gPNktLMrtB/d/K6p+d2C3beMJEFGYeryo2ApRX619L5stfaXCjM96zFiRUSSvkzg==
X-Received: by 2002:a5d:9953:: with SMTP id v19mr73935774ios.118.1578411526991;
        Tue, 07 Jan 2020 07:38:46 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c3sm18002516ioc.63.2020.01.07.07.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 07:38:46 -0800 (PST)
Date:   Tue, 07 Jan 2020 07:38:38 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lingpeng Chen <forrest0579@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.or, Lingpeng Chen <forrest0579@gmail.com>
Message-ID: <5e14a5fe53ac8_67962afd051fc5c0ea@john-XPS-13-9370.notmuch>
In-Reply-To: <20200107042247.16614-1-forrest0579@gmail.com>
References: <20200107042247.16614-1-forrest0579@gmail.com>
Subject: RE: [PATCH] bpf/sockmap: read psock ingress_msg before
 sk_receive_queue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lingpeng Chen wrote:
> Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
> if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
> and there's also some data in psock->ingress_msg, the data in
> psock->ingress_msg will be purged. It is always happen when request to a
> HTTP1.0 server like python SimpleHTTPServer since the server send FIN
> packet after data is sent out.
> 
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>

Hi, Good timing I have a very similar patch I was just about to send out
on my queue as well. Also needs Fixes tag but see patch below

> ---
>  net/ipv4/tcp_bpf.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index e38705165ac9..cd4b699d3d0d 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -123,8 +123,6 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  
>  	if (unlikely(flags & MSG_ERRQUEUE))
>  		return inet_recv_error(sk, msg, len, addr_len);
> -	if (!skb_queue_empty(&sk->sk_receive_queue))
> -		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);

I agree with this part.

>  
>  	psock = sk_psock_get(sk);
>  	if (unlikely(!psock))
> @@ -139,7 +137,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>  		timeo = sock_rcvtimeo(sk, nonblock);
>  		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
>  		if (data) {
> -			if (skb_queue_empty(&sk->sk_receive_queue))
> +			if (!sk_psock_queue_empty(psock))

+1

>  				goto msg_bytes_ready;
>  			release_sock(sk);
>  			sk_psock_put(sk, psock);

I think it just misses one extra piece. We don't want to grab lock, call
__tcp_bpf_recvmsg(), call tcp_bpf_wait_data(), etc. when we know the
psock queue is empty. How about this patch I think it would solve your
case as well. If you think this also works go ahead and add your
Signed-off-by and send it. Or I'll send it later today with the upcoming
series I have with a couple syzbot fixes as well.

commit 40d1c0965cda3713f444c7c0b570364220b94a8a
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Thu Dec 19 17:18:42 2019 +0000

    bpf: bpf redirect should handle any received data before sk_receive_queue
    
    Arika reported that when SOCK_DONE occurs we handle sk_receive_queue before
    psock->ingress_msg so we may leave data in the ingress_msg queue. Resulting
    in a possible error on application side.
    
    Fix this by handling ingress_msg queue first so that data is not left in
    the insgress_msg queue.
    
    Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
    Reported-by: Arika Chen <eaglesora@gmail.com>
    Suggested-by: Arika Chen <eaglesora@gmail.com>
    Signed-off-by: John Fastabend <john.fastabend@gmail.com>

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index e38705165ac9..3b235c2cbc83 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -123,12 +123,14 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
        if (unlikely(flags & MSG_ERRQUEUE))
                return inet_recv_error(sk, msg, len, addr_len);
-       if (!skb_queue_empty(&sk->sk_receive_queue))
-               return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 
        psock = sk_psock_get(sk);
        if (unlikely(!psock))
                return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+
+       if (!skb_queue_empty(&sk->sk_receive_queue) && sk_psock_queue_empty(psock))
+               return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+
        lock_sock(sk);
 msg_bytes_ready:
        copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
@@ -139,7 +141,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
                timeo = sock_rcvtimeo(sk, nonblock);
                data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
                if (data) {
-                       if (skb_queue_empty(&sk->sk_receive_queue))
+                       if (!sk_psock_queue_empty(psock))
                                goto msg_bytes_ready;
                        release_sock(sk);
                        sk_psock_put(sk, psock);

