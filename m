Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44BC558DFF
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 00:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfF0Wcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 18:32:41 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34634 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0Wcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 18:32:41 -0400
Received: by mail-qt1-f196.google.com with SMTP id m29so4309876qtu.1;
        Thu, 27 Jun 2019 15:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SUoGq6G5riyuNtCg/1PVUHtszoC+IVC1IorIgPy3qn0=;
        b=D3NuZZn6NOfQEQYYO9YWglmDFXBRm4PBQz648NF2PAKqOggIkAjDEIGMl5FU45ou9q
         UgdIGtde9tCNcMJlXk5l3kqDpp2v1yPRqeL/wZyzcB6UzTf9Qn63BDb5T2jtKObjjwot
         lJyJondLUbepfltpPVMi1cqKg3VToHsBwjVZ+A/36BA4bKL3xhyrb4hL5xw6/QnsmHZW
         ga/gHK2KBchJzL526jJaVc2raoAwpe00DAbqjMr4qEmea8pBYCE/qI1aq9LHK3CMUelw
         Vxw2TPQypkmPleDjvm21hdt9dq4sxp9T522gaHEqi6hKU6EziHX/3jIbC0TxolXn/fZ7
         iLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SUoGq6G5riyuNtCg/1PVUHtszoC+IVC1IorIgPy3qn0=;
        b=XW1g5jMT9hfCeaARhbkPAgwwOSnl1zlyNn/4TYTkFxrENJTUsz6tGxH+UhIoaYnW/t
         8g3dH/f20CLw5Bkw97LLqMr1OCGoFHUKYZPppZrAPQgvnMJbYDxkhvACRQnX5ZnJxXo4
         tv+KQ2/lp18/SryRp9nn78Fo9a7fUqB5viEOkugGTanNjbsED1q6Urg7+18LTGOhAd+j
         BFSXdeqsoZZkGm3AQrdVn9YtWpE9rFZOvblITTWLPmtflcmkHCUbdRw+54qprPlVCUgd
         zG7j+BsvGDYzvdeolC/2gfkyp4OootkOrPcJ7DR9Q4tzREmMUzkP4f9QH6ES3bReBBGd
         dilA==
X-Gm-Message-State: APjAAAU5LqsQ8DV6qjLcOsAVlV52LyPmDvvAtim2NFM8Hd7aCxZ5gnAV
        Ss3rS7r4WlTK4RQRE+RQdoY=
X-Google-Smtp-Source: APXvYqzsvErsY4jPiohcWOGdIIily/IXJlA5CNsDhwwQf/5M3KFK4tiS44ZJCk8XepmSH2OLtu/QCw==
X-Received: by 2002:a0c:8b54:: with SMTP id d20mr5362334qvc.1.1561674760179;
        Thu, 27 Jun 2019 15:32:40 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:1699:3b71:f1f7:949e:f780])
        by smtp.gmail.com with ESMTPSA id k123sm206991qkf.13.2019.06.27.15.32.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 15:32:39 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CA7BBC3B91; Thu, 27 Jun 2019 19:32:36 -0300 (-03)
Date:   Thu, 27 Jun 2019 19:32:36 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: not bind the socket in sctp_connect
Message-ID: <20190627223236.GB2747@localhost.localdomain>
References: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 04:31:39PM +0800, Xin Long wrote:
> Now when sctp_connect() is called with a wrong sa_family, it binds
> to a port but doesn't set bp->port, then sctp_get_af_specific will
> return NULL and sctp_connect() returns -EINVAL.
> 
> Then if sctp_bind() is called to bind to another port, the last
> port it has bound will leak due to bp->port is NULL by then.
> 
> sctp_connect() doesn't need to bind ports, as later __sctp_connect
> will do it if bp->port is NULL. So remove it from sctp_connect().
> While at it, remove the unnecessary sockaddr.sa_family len check
> as it's already done in sctp_inet_connect.
> 
> Fixes: 644fbdeacf1d ("sctp: fix the issue that flags are ignored when using kernel_connect")
> Reported-by: syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 24 +++---------------------
>  1 file changed, 3 insertions(+), 21 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 39ea0a3..f33aa9e 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -4816,35 +4816,17 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
>  static int sctp_connect(struct sock *sk, struct sockaddr *addr,
>  			int addr_len, int flags)
>  {
> -	struct inet_sock *inet = inet_sk(sk);
>  	struct sctp_af *af;
> -	int err = 0;
> +	int err = -EINVAL;
>  
>  	lock_sock(sk);
> -
>  	pr_debug("%s: sk:%p, sockaddr:%p, addr_len:%d\n", __func__, sk,
>  		 addr, addr_len);
>  
> -	/* We may need to bind the socket. */
> -	if (!inet->inet_num) {
> -		if (sk->sk_prot->get_port(sk, 0)) {
> -			release_sock(sk);
> -			return -EAGAIN;
> -		}
> -		inet->inet_sport = htons(inet->inet_num);
> -	}
> -
>  	/* Validate addr_len before calling common connect/connectx routine. */
> -	af = addr_len < offsetofend(struct sockaddr, sa_family) ? NULL :
> -		sctp_get_af_specific(addr->sa_family);
> -	if (!af || addr_len < af->sockaddr_len) {
> -		err = -EINVAL;
> -	} else {
> -		/* Pass correct addr len to common routine (so it knows there
> -		 * is only one address being passed.
> -		 */
> +	af = sctp_get_af_specific(addr->sa_family);
> +	if (af && addr_len >= af->sockaddr_len)
>  		err = __sctp_connect(sk, addr, af->sockaddr_len, flags, NULL);
> -	}
>  
>  	release_sock(sk);
>  	return err;
> -- 
> 2.1.0
> 
