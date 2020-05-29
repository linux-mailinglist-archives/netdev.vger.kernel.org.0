Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5F51E830B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgE2QFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgE2QFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:05:18 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46262C03E969;
        Fri, 29 May 2020 09:05:18 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id v79so2624431qkb.10;
        Fri, 29 May 2020 09:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W/5acxUy0tPXC4WQ+gK2CfotTHafKGLmUlvwhNajW8E=;
        b=NoWmA8MpSBLdahAUVezrWHVrEaFOpI4cMtvhXAkBFnFv4FZumx7AzTsVXWu+vIYdmx
         BME+jyFSi2nggmmXadWablN+IRxyBf5eqmtqv0jen20DQR0bsujwyawiCLm587DeEyNW
         jd1G16dwhhWiqyRohMcAN0qEZYY9fzSDG2GbsxC2/vDY5sqylO7zp5JnvEFNhsCNIZNT
         Co0DtsJqykub1AfxSf1RqCeha78HQT9rWyXXynedy7uDePReadYXYhX7UwI4dg5i/SsL
         SRA703n/u9W1j8VR9H0gT1xT+ZnsEOL2Dya/OClnLY1zcKZsYHKPs9c79aw2XO6lmmOU
         d6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W/5acxUy0tPXC4WQ+gK2CfotTHafKGLmUlvwhNajW8E=;
        b=dtK2Yr0lzp9okOe1FYdtx37/DynIp254DXEXdwXt21f1sIDUm5AqcKCPebuImLaCPb
         jL35CBfpoOuSkDbq9ix/WICgbCzz8RghynNL2cz0wM0SGZ4CHRxUncsVeFrFRtsLYVJn
         9612iUJDJ2DUWyGPmyRadIISWqQmxRrpTNfbLWOkb601CXNCVa9IxPYITvU1G/wZy69l
         HN9v8IsE3BmLcHHT1+F+ZMcMTL92ACbclm213TvHYRzLH3sKfSQTKQsA92oBKuZMRYor
         YRg7D3ItqTF3ru4/VKehmGe9rSoVQQJsddxKzfpu5m+of0/Er9Gxz/gRpYJN5w7CP1Jg
         tTyw==
X-Gm-Message-State: AOAM530bSNs3dKKhfYk24Ui/Jq4JptYZfdEtW2cFpyURK9ax+82GxWqY
        l5yOvKevRxa53Ibnp7HsOfo=
X-Google-Smtp-Source: ABdhPJzdt/kXXfrBEfw95zber/esL31JmnLdUMJ2Vt2cDTVx9+/hBSM8jSEdo9tYgm9y29NG5QXSTw==
X-Received: by 2002:ae9:f40b:: with SMTP id y11mr8491950qkl.107.1590768317293;
        Fri, 29 May 2020 09:05:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:516d:2604:bfa5:7157:afa1])
        by smtp.gmail.com with ESMTPSA id i94sm8009525qtd.2.2020.05.29.09.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:05:16 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 33AE8C1B84; Fri, 29 May 2020 13:05:14 -0300 (-03)
Date:   Fri, 29 May 2020 13:05:14 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Laight <David.Laight@aculab.com>,
        linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] sctp: add sctp_sock_set_nodelay
Message-ID: <20200529160514.GH2491@localhost.localdomain>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529120943.101454-2-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:09:40PM +0200, Christoph Hellwig wrote:
> Add a helper to directly set the SCTP_NODELAY sockopt from kernel space
> without going through a fake uaccess.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

I'm taking the action item to make sctp_setsockopt_nodelay() use the
new helper. Will likely create a __ variant of it, due to sock lock.

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
>  #endif /* __net_sctp_h__ */
> -- 
> 2.26.2
> 
