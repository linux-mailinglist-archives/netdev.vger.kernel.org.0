Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AB21DC2AA
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 01:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgETXKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 19:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728581AbgETXKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 19:10:06 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3748FC061A0E;
        Wed, 20 May 2020 16:10:05 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id a23so4090322qto.1;
        Wed, 20 May 2020 16:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/qygMQEHgAHnXXlcBf3bWz8hekZtO5JE6hUpY/E6MlI=;
        b=P6nrdRt7oaMJFGVn8tdcieLX1Y0jzSKCiVAEYNtArrwifpga+dN5v83cMRIKerr4lw
         S6tkBAkA2pzBZjc0nUkbiuQyYHvOajF4yI1Q6trOeI35JHSiPIaxzZCbG3Qtsy2IBEa3
         0u/0e0g7iT4mi/FhVlpzyBQ3hBLshkLlZGHWrVd+CnnFjHpAgBIE+8ymdFvfsvnw6oP1
         vrswReGAc6hPcqUAp+cE2FXwLqOAkzyS//X9yOiiedFgThmSWHlqXdSgAkTBcBgd7wGx
         VhCZmmEUAtG955eDuUNmBsKKkyJTq5OMaHqmy6az6aQ6f3SohaWpveT0RKHmFyEz+bny
         g7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/qygMQEHgAHnXXlcBf3bWz8hekZtO5JE6hUpY/E6MlI=;
        b=OEWa6tgj0BT4zb4FhTVujJ+azhQH/NcM9h8ChGqiCTg6Fg+aYQNJ/eyRifQGsCtYg6
         dCJ1ZIYaklm98lidg0XxKXOeA7kDbJNvRomQmJ3UAgmzZWLIRax1nHhRIiFpKldDom/A
         d2bNiTcXqgRazbzki5AzE+8XwNZ+aA6Q26S1217dORR8O2V79dRJWdQSl8+mZ9+vhPkU
         BzSqfw4x722NhDXetw4fzmLgsZKfPEGNSDpexY1N4wI3CzxyUpdd0s7sn7lmLohgHgCh
         J9h13bcKP2ZaygHhF0Fjgi1Y/MJOHQMA/JdElWNLY7XLjPXHHJf0EmgJ/o45HZe8l0Cj
         81vg==
X-Gm-Message-State: AOAM5317rKZC2jirEIix5DBVB0NNfPjYMpQ/ZUtyDsAeiRXuOroBvk4h
        xR+wirt+gO7ikCW7D2EOOOp7p3wR5RRiYA==
X-Google-Smtp-Source: ABdhPJwRWSgggkzxnJn0dwyU2QDiQnm5wTM+hCXxxx8a5qFL0yi0c7Z5VunfQVgq58oD4bmA7XAdrQ==
X-Received: by 2002:aed:3f7b:: with SMTP id q56mr7818149qtf.152.1590016204171;
        Wed, 20 May 2020 16:10:04 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:b7f5:289f:a703:e466:2a27])
        by smtp.gmail.com with ESMTPSA id e28sm3451287qkn.17.2020.05.20.16.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 16:10:03 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 2EE17C0DAC; Wed, 20 May 2020 20:10:01 -0300 (-03)
Date:   Wed, 20 May 2020 20:10:01 -0300
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
Subject: Re: [PATCH 31/33] sctp: add sctp_sock_set_nodelay
Message-ID: <20200520231001.GU2491@localhost.localdomain>
References: <20200520195509.2215098-1-hch@lst.de>
 <20200520195509.2215098-32-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520195509.2215098-32-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 09:55:07PM +0200, Christoph Hellwig wrote:
> Add a helper to directly set the SCTP_NODELAY sockopt from kernel space
> without going through a fake uaccess.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dlm/lowcomms.c       | 10 ++--------
>  include/net/sctp/sctp.h |  7 +++++++
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
> index 69333728d871b..9f1c3cdc9d653 100644
> --- a/fs/dlm/lowcomms.c
> +++ b/fs/dlm/lowcomms.c
> @@ -914,7 +914,6 @@ static int sctp_bind_addrs(struct connection *con, uint16_t port)
>  static void sctp_connect_to_sock(struct connection *con)
>  {
>  	struct sockaddr_storage daddr;
> -	int one = 1;
>  	int result;
>  	int addr_len;
>  	struct socket *sock;
> @@ -961,8 +960,7 @@ static void sctp_connect_to_sock(struct connection *con)
>  	log_print("connecting to %d", con->nodeid);
>  
>  	/* Turn off Nagle's algorithm */
> -	kernel_setsockopt(sock, SOL_SCTP, SCTP_NODELAY, (char *)&one,
> -			  sizeof(one));
> +	sctp_sock_set_nodelay(sock->sk);
>  
>  	/*
>  	 * Make sock->ops->connect() function return in specified time,
> @@ -1176,7 +1174,6 @@ static int sctp_listen_for_all(void)
>  	struct socket *sock = NULL;
>  	int result = -EINVAL;
>  	struct connection *con = nodeid2con(0, GFP_NOFS);
> -	int one = 1;
>  
>  	if (!con)
>  		return -ENOMEM;
> @@ -1191,10 +1188,7 @@ static int sctp_listen_for_all(void)
>  	}
>  
>  	sock_set_rcvbuf(sock->sk, NEEDED_RMEM);
> -	result = kernel_setsockopt(sock, SOL_SCTP, SCTP_NODELAY, (char *)&one,
> -				   sizeof(one));
> -	if (result < 0)
> -		log_print("Could not set SCTP NODELAY error %d\n", result);
> +	sctp_sock_set_nodelay(sock->sk);
>  
>  	write_lock_bh(&sock->sk->sk_callback_lock);
>  	/* Init con struct */
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index 3ab5c6bbb90bd..f8bcb75bb0448 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -615,4 +615,11 @@ static inline bool sctp_newsk_ready(const struct sock *sk)
>  	return sock_flag(sk, SOCK_DEAD) || sk->sk_socket;
>  }
>  
> +static inline void sctp_sock_set_nodelay(struct sock *sk)
> +{
> +	lock_sock(sk);
> +	sctp_sk(sk)->nodelay = true;
> +	release_sock(sk);
> +}
> +

The duplication with sctp_setsockopt_nodelay() is quite silly/bad.
Also, why have the 'true' hardcoded? It's what dlm uses, yes, but the
API could be a bit more complete than that.

Like for the other patch, this one could build on David's patch, do
the ternary check before calling sctp_setsockopt_nodelay and then move
sctp_setsockopt_nodelay to the header, or something like that.
