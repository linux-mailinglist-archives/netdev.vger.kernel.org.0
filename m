Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168921E8344
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgE2QKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2QKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:10:22 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415C7C03E969;
        Fri, 29 May 2020 09:10:22 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id c12so2303364qtq.11;
        Fri, 29 May 2020 09:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y+4rgbyVFdpWdnFfPGEMNo5bmNIxGC5yE0lzC9sLPDI=;
        b=He6U0kOOqDx77apNaftx5iqXRCDUN/Q0QfmkJGZh0UUkTo6DoVWVYfdVm0xV7GhS54
         paGRE7yOH2nkcx/QmMeoozsSehWhqDWlsRZb7upJbRD2cnjdkR9XOJoGQVTTT1m4r+Q6
         Vsqx5aoEd8LY0sZIGDHtWZfkZ9noCBXKEiz7DH1TB6ZhNPu+FXVwRoD3bvnMZJc9GXp7
         +puTBeFtuw54e8+uXT2kZoD+EuuH3SXs/o2Vgb2aSrBWuEaM21t6EV35fFvTAeX8P9Fy
         hoR0YPt+cG5imBcraVSGgle5EhazdJSU4n6jKIpG53l/0qetDLvQ2VVPXbE05oh29DK2
         DY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y+4rgbyVFdpWdnFfPGEMNo5bmNIxGC5yE0lzC9sLPDI=;
        b=U1QRvmu44BDyXhHZnZnszlMbf702tC5y2lDECFCrrFuIG8QdKvmXijGudQN6pZ+Ze8
         ZCRbsuwoE1QuwlPWVe8sRggukNwwd8Pg+tmlHmtrG+3n5Qx3cT6hF9BrUYkN+HwB7fdV
         TyrXGSqoupPIoUEcKDuYVLd/gBuP4A2DwhogU8iNNgwrKM2l273jMAspwJpjvpXAERQq
         9geGkzw0ZivrRD8o8ljP7kK8W66KMmgv5KfD9Fk26uvplo2tIvI2lwlvVzydYzQncfrR
         ISy7xI85CZFX0PT5wRcQh+6wT3NGQM7NyQP5W/nQkU4y2RLJgE38sGD5+eCdyvKc1IqJ
         vtxA==
X-Gm-Message-State: AOAM531pIFVPIZLyoqyU/w8cyxTNvyjIUxZIVuDBmcAjLEcEGksHx9ih
        3ap5zF7VqwPC60i/YI846DQ=
X-Google-Smtp-Source: ABdhPJwymhddx06bqmGhYsTfxrNsNdKqxYLST86rY0HaDO5CDiSL28xMj8JFIw+ygnudI/qKx7P/NQ==
X-Received: by 2002:ac8:7ca1:: with SMTP id z1mr8885022qtv.334.1590768621466;
        Fri, 29 May 2020 09:10:21 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:516d:2604:bfa5:7157:afa1])
        by smtp.gmail.com with ESMTPSA id c83sm7579257qkb.103.2020.05.29.09.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:10:20 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6C60EC1B84; Fri, 29 May 2020 13:10:18 -0300 (-03)
Date:   Fri, 29 May 2020 13:10:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Laight <David.Laight@aculab.com>,
        linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] net: remove kernel_setsockopt
Message-ID: <20200529161018.GK2491@localhost.localdomain>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529120943.101454-5-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:09:43PM +0200, Christoph Hellwig wrote:
> No users left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks.

> ---
>  include/linux/net.h |  2 --
>  net/socket.c        | 31 -------------------------------
>  2 files changed, 33 deletions(-)
> 
> diff --git a/include/linux/net.h b/include/linux/net.h
> index 74ef5d7315f70..e10f378194a59 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -303,8 +303,6 @@ int kernel_connect(struct socket *sock, struct sockaddr *addr, int addrlen,
>  		   int flags);
>  int kernel_getsockname(struct socket *sock, struct sockaddr *addr);
>  int kernel_getpeername(struct socket *sock, struct sockaddr *addr);
> -int kernel_setsockopt(struct socket *sock, int level, int optname, char *optval,
> -		      unsigned int optlen);
>  int kernel_sendpage(struct socket *sock, struct page *page, int offset,
>  		    size_t size, int flags);
>  int kernel_sendpage_locked(struct sock *sk, struct page *page, int offset,
> diff --git a/net/socket.c b/net/socket.c
> index 81a98b6cbd087..976426d03f099 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -3624,37 +3624,6 @@ int kernel_getpeername(struct socket *sock, struct sockaddr *addr)
>  }
>  EXPORT_SYMBOL(kernel_getpeername);
>  
> -/**
> - *	kernel_setsockopt - set a socket option (kernel space)
> - *	@sock: socket
> - *	@level: API level (SOL_SOCKET, ...)
> - *	@optname: option tag
> - *	@optval: option value
> - *	@optlen: option length
> - *
> - *	Returns 0 or an error.
> - */
> -
> -int kernel_setsockopt(struct socket *sock, int level, int optname,
> -			char *optval, unsigned int optlen)
> -{
> -	mm_segment_t oldfs = get_fs();
> -	char __user *uoptval;
> -	int err;
> -
> -	uoptval = (char __user __force *) optval;
> -
> -	set_fs(KERNEL_DS);
> -	if (level == SOL_SOCKET)
> -		err = sock_setsockopt(sock, level, optname, uoptval, optlen);
> -	else
> -		err = sock->ops->setsockopt(sock, level, optname, uoptval,
> -					    optlen);
> -	set_fs(oldfs);
> -	return err;
> -}
> -EXPORT_SYMBOL(kernel_setsockopt);
> -
>  /**
>   *	kernel_sendpage - send a &page through a socket (kernel space)
>   *	@sock: socket
> -- 
> 2.26.2
> 
