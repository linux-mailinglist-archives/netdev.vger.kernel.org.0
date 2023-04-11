Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3656DE021
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjDKP5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjDKP5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:57:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF71DE7B;
        Tue, 11 Apr 2023 08:57:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B3E462807;
        Tue, 11 Apr 2023 15:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8E7C433EF;
        Tue, 11 Apr 2023 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681228663;
        bh=Hdp/O4sWkXQQLjlMeKKnQiGPMpZXSJyElbG/I6uZC2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BP4XJv5U6an713Mb8FIiRbB0lxcHDfKTYmY2jXC1shtmLoRge1Irdgy/ptNV98a8I
         lFk9PJOaHivyyxrhbUbZgAVVHoppaSYiAay6XIHSpztneMBBbsRs7GOPiCJCpkQc2H
         Y7qzqz7QVqWRykxy/ASiaq1srPlLvPz5XoaEJxIYfaVTnwiY7+IKi7nm6m6q+2REKI
         brselQs96d9XAyH9c6t+vlfjHNyExql4aDekp77MKxJfJtX0AEQWkQkejaabyrmqjR
         69aeeSxO2SffZyGW7iUcKG/nJ1jfVe1cJPRi7KUkEyhkOkcRH1lb9aSLE6RS/p5dpw
         2kxqmOdYbZjvA==
Date:   Tue, 11 Apr 2023 17:57:31 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] net: core: add getsockopt SO_PEERPIDFD
Message-ID: <20230411-pantoffeln-voreilig-208e37ba62bb@brauner>
References: <20230411104231.160837-1-aleksandr.mikhalitsyn@canonical.com>
 <20230411104231.160837-4-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411104231.160837-4-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 12:42:30PM +0200, Alexander Mikhalitsyn wrote:
> Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> This thing is direct analog of SO_PEERCRED which allows to get plain PID.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: Luca Boccassi <bluca@debian.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Tested-by: Luca Boccassi <bluca@debian.org>
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
> v3:
> 	- fixed possible fd leak (thanks to Christian Brauner)
> v2:
> 	According to review comments from Kuniyuki Iwashima and Christian Brauner:
> 	- use pidfd_create(..) retval as a result
> 	- whitespace change
> ---
>  arch/alpha/include/uapi/asm/socket.h    |  1 +
>  arch/mips/include/uapi/asm/socket.h     |  1 +
>  arch/parisc/include/uapi/asm/socket.h   |  1 +
>  arch/sparc/include/uapi/asm/socket.h    |  1 +
>  include/uapi/asm-generic/socket.h       |  1 +
>  net/core/sock.c                         | 33 +++++++++++++++++++++++++
>  net/socket.c                            |  7 ++++++
>  tools/include/uapi/asm-generic/socket.h |  1 +
>  8 files changed, 46 insertions(+)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index ff310613ae64..e94f621903fe 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -138,6 +138,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 762dcb80e4ec..60ebaed28a4c 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -149,6 +149,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index df16a3e16d64..be264c2b1a11 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -130,6 +130,7 @@
>  #define SO_RCVMARK		0x4049
>  
>  #define SO_PASSPIDFD		0x404A
> +#define SO_PEERPIDFD		0x404B
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 6e2847804fea..682da3714686 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -131,6 +131,7 @@
>  #define SO_RCVMARK               0x0054
>  
>  #define SO_PASSPIDFD             0x0055
> +#define SO_PEERPIDFD             0x0056
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index b76169fdb80b..8ce8a39a1e5f 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -133,6 +133,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 3f974246ba3e..2b040a69e355 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1763,6 +1763,39 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
>  		goto lenout;
>  	}
>  
> +	case SO_PEERPIDFD:
> +	{
> +		struct pid *peer_pid;
> +		struct file *pidfd_file = NULL;
> +		int pidfd;
> +
> +		if (len > sizeof(pidfd))
> +			len = sizeof(pidfd);
> +
> +		spin_lock(&sk->sk_peer_lock);
> +		peer_pid = get_pid(sk->sk_peer_pid);
> +		spin_unlock(&sk->sk_peer_lock);
> +
> +		pidfd = pidfd_prepare(peer_pid, 0, &pidfd_file);
> +
> +		put_pid(peer_pid);

Would be a bit nicer if this would be:

	pidfd = pidfd_prepare(peer_pid, 0, &pidfd_file);
	put_pid(peer_pid);
	if (pidfd < 0)
		return pidfd;
	if (copy_to_sockptr(optval, &pidfd, len) ||
	    copy_to_sockptr(optlen, &len, sizeof(int)))
		return -EFAULT;
	
	fd_install(pidfd, pidfd_file);
	return 0;

Otherwise seems good enough to me.

> +
> +		if (copy_to_sockptr(optval, &pidfd, len) ||
> +		    copy_to_sockptr(optlen, &len, sizeof(int))) {
> +			if (pidfd >= 0) {
> +				put_unused_fd(pidfd);
> +				fput(pidfd_file);
> +			}
> +
> +			return -EFAULT;
> +		}
> +
> +		if (pidfd_file)
> +			fd_install(pidfd, pidfd_file);
> +
> +		return 0;
> +	}
> +
>  	case SO_PEERGROUPS:
>  	{
>  		const struct cred *cred;
> diff --git a/net/socket.c b/net/socket.c
> index 9c1ef11de23f..505b85489354 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -2248,6 +2248,13 @@ static bool sockopt_installs_fd(int level, int optname)
>  		default:
>  			return false;
>  		}
> +	} else if (level == SOL_SOCKET) {
> +		switch (optname) {
> +		case SO_PEERPIDFD:
> +			return true;
> +		default:
> +			return false;
> +		}
>  	}
>  
>  	return false;
> diff --git a/tools/include/uapi/asm-generic/socket.h b/tools/include/uapi/asm-generic/socket.h
> index fbbc4bf53ee3..54d9c8bf7c55 100644
> --- a/tools/include/uapi/asm-generic/socket.h
> +++ b/tools/include/uapi/asm-generic/socket.h
> @@ -122,6 +122,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> -- 
> 2.34.1
> 
