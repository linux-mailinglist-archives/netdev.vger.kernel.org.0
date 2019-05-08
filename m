Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD9F17B08
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfEHNuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:50:24 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37693 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfEHNuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 09:50:24 -0400
Received: by mail-qt1-f196.google.com with SMTP id o7so1145199qtp.4;
        Wed, 08 May 2019 06:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xit8RhNDbpVA/1R0v4T+Cbs1iILUhOMfaqih7cktU/I=;
        b=K72XMU1ZJFD/RFIn2ydus/nDNl7fhJ4NEB01jDZlqF5AeoQNle5HceTWUkWdM5KVU1
         yTJi73XiWzYJN5YW+KcUYFNc9x8n0SYZXbqedrmCWsvA2ZlxSqjGtDC3i+YjPwSeJZyr
         ESB3Huezw+e7zh8H1Ba8lPYR7YU+08k3G+f5xg0ruderVkahWBMzevYc8bkpVSimCH/x
         3fwHZgnBczITgp9T/odkOsLslVnwaY2PNPsQnvlUqGkpeAFB+le0j9JJV7/p8jnzbVJs
         Iu3V8LXG/yb8zELbe6aa3DYUu4MpeLinRuptHB2BaTTSrsKbmyFZZ391NkIckHpofr2L
         SaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xit8RhNDbpVA/1R0v4T+Cbs1iILUhOMfaqih7cktU/I=;
        b=kBoFmShrnqzeNtwFaMAZGRyluv5m6IwJBJRfoWzwDraPNiEeogQnNQ3E4A+7h/8lf7
         IyWkS9p8IP005sFN3K9jr9WX0ITcvLjwnV5MtORzT5gl3S8Zk/aNmjzgwv6sW7MkNQBV
         R53VovS0iZmMxfwhZLlF/C9ZaZ6vwEIQqRaCVsOtpyELF4/kAKFgMG1SRyB0P3Gt5Utr
         S6e0ghSPuW/xZen+QY7dmeDVrg1ESHRaBVCUQKIqIvNQ8ytJBMk9w1wLgQLJot386xN9
         9mQe1j1TXMWbajVYsnkftdp5vbkR0KiUYu0rmrs9holeOlr6lqG4vMYXEmjhSqH3jeko
         nfrg==
X-Gm-Message-State: APjAAAW4qhSk1MoRPRUe01bTjX8NRy7JHuueXi7mi2skHhQeaKpUpQwO
        KEYyX0UU5MWKi7+cGUzvgSQYGLP/fcY=
X-Google-Smtp-Source: APXvYqzOu0rm4zfj8/1U1nF+YQnH9VMSJ1Qwn0tFfDJSG1v9b1zbNd0ejPP9CThAeN8FhoyLgJIYiw==
X-Received: by 2002:ac8:2413:: with SMTP id c19mr31632961qtc.348.1557323423263;
        Wed, 08 May 2019 06:50:23 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.3])
        by smtp.gmail.com with ESMTPSA id v66sm5693784qkd.62.2019.05.08.06.50.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 May 2019 06:50:22 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D7803180C25; Wed,  8 May 2019 10:50:19 -0300 (-03)
Date:   Wed, 8 May 2019 10:50:19 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        netdev@vger.kernel.org, Tom Deseyn <tdeseyn@redhat.com>,
        Richard Haines <richard_c_haines@btinternet.com>
Subject: Re: [PATCH net] selinux: do not report error on connect(AF_UNSPEC)
Message-ID: <20190508135019.GJ10916@localhost.localdomain>
References: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7301017039d68c920cb9120c035a1a0df3e6b30d.1557322358.git.pabeni@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 03:32:51PM +0200, Paolo Abeni wrote:
> calling connect(AF_UNSPEC) on an already connected TCP socket is an
> established way to disconnect() such socket. After commit 68741a8adab9
> ("selinux: Fix ltp test connect-syscall failure") it no longer works
> and, in the above scenario connect() fails with EAFNOSUPPORT.
> 
> Fix the above falling back to the generic/old code when the address family
> is not AF_INET{4,6}, but leave the SCTP code path untouched, as it has
> specific constraints.
> 
> Fixes: 68741a8adab9 ("selinux: Fix ltp test connect-syscall failure")
> Reported-by: Tom Deseyn <tdeseyn@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  security/selinux/hooks.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c61787b15f27..d82b87c16b0a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -4649,7 +4649,7 @@ static int selinux_socket_connect_helper(struct socket *sock,
>  		struct lsm_network_audit net = {0,};
>  		struct sockaddr_in *addr4 = NULL;
>  		struct sockaddr_in6 *addr6 = NULL;
> -		unsigned short snum;
> +		unsigned short snum = 0;
>  		u32 sid, perm;
>  
>  		/* sctp_connectx(3) calls via selinux_sctp_bind_connect()
> @@ -4674,12 +4674,12 @@ static int selinux_socket_connect_helper(struct socket *sock,
>  			break;
>  		default:
>  			/* Note that SCTP services expect -EINVAL, whereas
> -			 * others expect -EAFNOSUPPORT.
> +			 * others must handle this at the protocol level:
> +			 * connect(AF_UNSPEC) on a connected socket is
> +			 * a documented way disconnect the socket.
>  			 */
>  			if (sksec->sclass == SECCLASS_SCTP_SOCKET)
>  				return -EINVAL;
> -			else
> -				return -EAFNOSUPPORT;
>  		}
>  
>  		err = sel_netport_sid(sk->sk_protocol, snum, &sid);
> -- 
> 2.20.1
> 
