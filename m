Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6751DC295
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 01:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgETXAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 19:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbgETXAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 19:00:31 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E8FC061A0E;
        Wed, 20 May 2020 16:00:30 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id g185so5432220qke.7;
        Wed, 20 May 2020 16:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bxPhNLxEeIp1FyAEAyOXcpXoJGhcJI/9VkWQHjEBJu8=;
        b=ABmm/w5ZxLmgIKDfTHVrUH4+roya8bvoORLSIFi8ftfcLjr/+lUQIQg1vCqbqW2lg9
         Edg16ZlpvA+2Dlf7bVNlBaLPK1ZbW70B9d+eMKWgRWHc1obMDOhnkMACk5lCyH6afilN
         oBX31hIJND3KTy6XaW00DzljepVXjloOTwRxZRLvAQKsNjUgvnW+LRhTtQZ8hzDo3kC9
         nEaiPcTs5/ymUk2QJuXYVy0Cj6FQBr1kL/y4jcDd4Z/5qbXOnV8biHoU/FvLL+veSFMP
         /oXIdwd3BivEoo89WKHE8GPd4JLIstozB1RtSZSt9AsbvQu1QY701U/rpBAvWqVzLnB2
         HhPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bxPhNLxEeIp1FyAEAyOXcpXoJGhcJI/9VkWQHjEBJu8=;
        b=DPTNrEX9Paf6GhhsUzeFW8moIK4q0vqcsilRqDEDWukfuWkXCFRkDZTFS2zT4wSE2m
         e4LGi8g7eLVaICULAHzL6IOIbFGhctNhgYUUw0JhJgEJTyk2pe5ZnnaJ/tthUPzck8pY
         SoyOsFqQkAJPjUejKhn+Tyx9kisqYUqijc5n+C6PgBjc1v1/mJRQIQJ1irBy4lOSGS3m
         q/De2L7FodBOnil+UxiRjaVv4GbmOEnsH7wn3FHuoTiFEFPsO4qXZhkdCh9yjLQKJ3lP
         qnFhOR+9zoglz+6BrAKfH/ep4ddK2gN3iLXaXShxEbMj1LH1bLarTH0fOjVyojQ/B52n
         HqMw==
X-Gm-Message-State: AOAM533mXAv4/APXY6OpJ56TlwZn/dXJstukW4IiXyA19Nh18x4xuk33
        B0yZdBQASNlbr4EtUFtCEDU=
X-Google-Smtp-Source: ABdhPJz4+N4OAMnIZUpFPrMKKpxZ5ipr9THKmBgVoh+NUJRSoyJQeFfxBAyAvgR9uTfieJGBqFR7qw==
X-Received: by 2002:a37:b244:: with SMTP id b65mr7801054qkf.329.1590015629321;
        Wed, 20 May 2020 16:00:29 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id n68sm3102877qkb.58.2020.05.20.16.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 16:00:28 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 889A9C0DAC; Wed, 20 May 2020 20:00:25 -0300 (-03)
Date:   Wed, 20 May 2020 20:00:25 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 32/33] net: add a new bind_add method
Message-ID: <20200520230025.GT2491@localhost.localdomain>
References: <20200520195509.2215098-1-hch@lst.de>
 <20200520195509.2215098-33-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520195509.2215098-33-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 09:55:08PM +0200, Christoph Hellwig wrote:
> The SCTP protocol allows to bind multiple address to a socket.  That
> feature is currently only exposed as a socket option.  Add a bind_add
> method struct proto that allows to bind additional addresses, and
> switch the dlm code to use the method instead of going through the
> socket option from kernel space.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dlm/lowcomms.c  |  9 +++------
>  include/net/sock.h |  6 +++++-
>  net/core/sock.c    |  8 ++++++++
>  net/sctp/socket.c  | 23 +++++++++++++++++++++++
>  4 files changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
> index 9f1c3cdc9d653..3543a8fec9075 100644
> --- a/fs/dlm/lowcomms.c
> +++ b/fs/dlm/lowcomms.c
> @@ -882,6 +882,7 @@ static void writequeue_entry_complete(struct writequeue_entry *e, int completed)
>  static int sctp_bind_addrs(struct connection *con, uint16_t port)
>  {
>  	struct sockaddr_storage localaddr;
> +	struct sockaddr *addr = (struct sockaddr *)&localaddr;
>  	int i, addr_len, result = 0;
>  
>  	for (i = 0; i < dlm_local_count; i++) {
> @@ -889,13 +890,9 @@ static int sctp_bind_addrs(struct connection *con, uint16_t port)
>  		make_sockaddr(&localaddr, port, &addr_len);
>  
>  		if (!i)
> -			result = kernel_bind(con->sock,
> -					     (struct sockaddr *)&localaddr,
> -					     addr_len);
> +			result = kernel_bind(con->sock, addr, addr_len);
>  		else
> -			result = kernel_setsockopt(con->sock, SOL_SCTP,
> -						   SCTP_SOCKOPT_BINDX_ADD,
> -						   (char *)&localaddr, addr_len);
> +			result = sock_bind_add(con->sock->sk, addr, addr_len);
>  
>  		if (result < 0) {
>  			log_print("Can't bind to %d addr number %d, %d.\n",
> diff --git a/include/net/sock.h b/include/net/sock.h
> index d994daa418ec2..6e9f713a78607 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1156,7 +1156,9 @@ struct proto {
>  	int			(*sendpage)(struct sock *sk, struct page *page,
>  					int offset, size_t size, int flags);
>  	int			(*bind)(struct sock *sk,
> -					struct sockaddr *uaddr, int addr_len);
> +					struct sockaddr *addr, int addr_len);
> +	int			(*bind_add)(struct sock *sk,
> +					struct sockaddr *addr, int addr_len);
>  
>  	int			(*backlog_rcv) (struct sock *sk,
>  						struct sk_buff *skb);
> @@ -2698,4 +2700,6 @@ void sock_set_reuseaddr(struct sock *sk);
>  void sock_set_reuseport(struct sock *sk);
>  void sock_set_sndtimeo(struct sock *sk, s64 secs);
>  
> +int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
> +
>  #endif	/* _SOCK_H */
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 2ca3425b519c0..61ec573221a60 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3712,3 +3712,11 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
>  }
>  EXPORT_SYMBOL(sk_busy_loop_end);
>  #endif /* CONFIG_NET_RX_BUSY_POLL */
> +
> +int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len)
> +{
> +	if (!sk->sk_prot->bind_add)
> +		return -EOPNOTSUPP;
> +	return sk->sk_prot->bind_add(sk, addr, addr_len);
> +}
> +EXPORT_SYMBOL(sock_bind_add);
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 827a9903ee288..8a0b9258f65c0 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1057,6 +1057,27 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	return err;
>  }
>  
> +static int sctp_bind_add(struct sock *sk, struct sockaddr *addr,
> +		int addrlen)
> +{
> +	struct sctp_af *af = sctp_get_af_specific(addr->sa_family);
> +	int err;
> +
> +	if (!af || af->sockaddr_len > addrlen)
> +		return -EINVAL;
> +	err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_BINDX_ADD, addr,
> +			addrlen);

The security_ call above is done today within the sock lock.
I couldn't find any issue through a code review, though, so I'm fine
with leaving it as is. Just highlighting it..

> +	if (err)
> +		return err;
> +
> +	lock_sock(sk);
> +	err = sctp_do_bind(sk, (union sctp_addr *)addr, af->sockaddr_len);
> +	if (!err)
> +		err = sctp_send_asconf_add_ip(sk, addr, 1);

Some problems here.
- addr may contain a list of addresses
- the addresses, then, are not being validated
- sctp_do_bind may fail, on which it requires some undoing
  (like sctp_bindx_add does)
- code duplication with sctp_setsockopt_bindx.

This patch will conflict with David's one,
[PATCH net-next] sctp: Pull the user copies out of the individual sockopt functions.
(I'll finish reviewing it in the sequence)

AFAICT, this patch could reuse/build on his work in there. The goal is
pretty much the same and would avoid the issues above.

This patch could, then, point the new bind_add proto op to the updated
sctp_setsockopt_bindx almost directly.

Question then is: dlm never removes an addr from the bind list. Do we
want to add ops for both? Or one that handles both operations?
Anyhow, having the add operation but not the del seems very weird to
me.

> +	release_sock(sk);
> +	return err;
> +}
> +
>  static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
>  				 const union sctp_addr *daddr,
>  				 const struct sctp_initmsg *init,
> @@ -9625,6 +9646,7 @@ struct proto sctp_prot = {
>  	.sendmsg     =	sctp_sendmsg,
>  	.recvmsg     =	sctp_recvmsg,
>  	.bind        =	sctp_bind,
> +	.bind_add    =  sctp_bind_add,
>  	.backlog_rcv =	sctp_backlog_rcv,
>  	.hash        =	sctp_hash,
>  	.unhash      =	sctp_unhash,
> @@ -9667,6 +9689,7 @@ struct proto sctpv6_prot = {
>  	.sendmsg	= sctp_sendmsg,
>  	.recvmsg	= sctp_recvmsg,
>  	.bind		= sctp_bind,
> +	.bind_add	= sctp_bind_add,
>  	.backlog_rcv	= sctp_backlog_rcv,
>  	.hash		= sctp_hash,
>  	.unhash		= sctp_unhash,
> -- 
> 2.26.2
> 
