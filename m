Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C865D1D1CE8
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390105AbgEMSDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390004AbgEMSDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:03:07 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF22EC061A0C;
        Wed, 13 May 2020 11:03:06 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id l1so577082qtp.6;
        Wed, 13 May 2020 11:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3rJSQfC8qhqPgAdT7p7uqG4zYxw0cOP69JvDMu+AmoU=;
        b=rgheQSt1YItEgWJaK+D0bGz+/qHfNOAGsXjdVRWwUQiGqsFIGS1wvoYG+aGTafU+PV
         /Wam8diPaOgVXFRqoqZXtgZpq5ZoS7P+w+jAXFzuJRlWX6AXxlicjH1KtuahsCm7X1oB
         1KM/eHxvJqcmXNEYPF4b+olwDLqfGRmRJKuO8mBihqp1FZjIXqkKRuN4K2fkmkt1KR4y
         BY4TuAPJr9Fm34DqlaEou7vS5F0NmzH1lmiODzJGQ+/eBluPCt8Nwyn9o9iFlcChI8ne
         mr8KP8dnkN8R85f07cGwIMBpujRbjafuA86KSdBGJqLxAx2+yPjgt33/gw2dY8MXvXik
         E3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3rJSQfC8qhqPgAdT7p7uqG4zYxw0cOP69JvDMu+AmoU=;
        b=AL41WpjTzKYqMQaaAILJH7BYfajSEzOyfHxaPEF4CnDEXy/kxPXuWEjq/D9mQThxsY
         TIgLjPtWoSqCWOknNR7VDtW1t7On35WjZiA25mC8yKRoezaf4y2ClhMjE3PnMtQSbyKa
         LB757WRGI056kpd2w1hUMj9aziV6fO78R+87CmB3fgSUVI00ejadFvuPQjkqDkP50pZK
         hr18nETEOZBWwjx5BzZtycI2w/dbnFob37KY3Sra07zsFZCnCcDRWKDM7xWWTz4yPSDt
         uB8E+ZhDlsKuq9jR0ZH6LQBAxOjtNm2BUub3qj5DMjt+hi0J4XcZjji66ndHsLIE0PZ3
         y3bA==
X-Gm-Message-State: AOAM533Tcj/2BCeZkt8pfpcaHALVTC+JgZ8/tdCWDim+uta9d542dxad
        pBKRtoWJLqwLH74/pSgiy9g=
X-Google-Smtp-Source: ABdhPJxDn2Ym2XNFWojVR75lfnXVzFyakSG9ONLgdWGtZA79aHqlLy1IZQIR41clkG4iLZ4VQYg8Bg==
X-Received: by 2002:ac8:67cf:: with SMTP id r15mr355571qtp.258.1589392985891;
        Wed, 13 May 2020 11:03:05 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.228])
        by smtp.gmail.com with ESMTPSA id f68sm476350qke.74.2020.05.13.11.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 11:03:05 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8AE9BC08DA; Wed, 13 May 2020 15:03:02 -0300 (-03)
Date:   Wed, 13 May 2020 15:03:02 -0300
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
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 32/33] sctp: add sctp_sock_get_primary_addr
Message-ID: <20200513180302.GC2491@localhost.localdomain>
References: <20200513062649.2100053-1-hch@lst.de>
 <20200513062649.2100053-33-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513062649.2100053-33-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 08:26:47AM +0200, Christoph Hellwig wrote:
> Add a helper to directly get the SCTP_PRIMARY_ADDR sockopt from kernel
> space without going through a fake uaccess.

Same comment as on the other dlm/sctp patch.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dlm/lowcomms.c       | 11 +++-----
>  include/net/sctp/sctp.h |  1 +
>  net/sctp/socket.c       | 57 +++++++++++++++++++++++++----------------
>  3 files changed, 39 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
> index 6fa45365666a8..46d2d71b62c57 100644
> --- a/fs/dlm/lowcomms.c
> +++ b/fs/dlm/lowcomms.c
> @@ -855,10 +855,9 @@ static int tcp_accept_from_sock(struct connection *con)
>  static int sctp_accept_from_sock(struct connection *con)
>  {
>  	/* Check that the new node is in the lockspace */
> -	struct sctp_prim prim;
> +	struct sctp_prim prim = { };
>  	int nodeid;
> -	int prim_len, ret;
> -	int addr_len;
> +	int addr_len, ret;
>  	struct connection *newcon;
>  	struct connection *addcon;
>  	struct socket *newsock;
> @@ -876,11 +875,7 @@ static int sctp_accept_from_sock(struct connection *con)
>  	if (ret < 0)
>  		goto accept_err;
>  
> -	memset(&prim, 0, sizeof(struct sctp_prim));
> -	prim_len = sizeof(struct sctp_prim);
> -
> -	ret = kernel_getsockopt(newsock, IPPROTO_SCTP, SCTP_PRIMARY_ADDR,
> -				(char *)&prim, &prim_len);
> +	ret = sctp_sock_get_primary_addr(con->sock->sk, &prim);
>  	if (ret < 0) {
>  		log_print("getsockopt/sctp_primary_addr failed: %d", ret);
>  		goto accept_err;
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index b505fa082f254..c98b1d14db853 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -618,5 +618,6 @@ static inline bool sctp_newsk_ready(const struct sock *sk)
>  int sctp_setsockopt_bindx(struct sock *sk, struct sockaddr *kaddrs,
>  		int addrs_size, int op);
>  void sctp_sock_set_nodelay(struct sock *sk, bool val);
> +int sctp_sock_get_primary_addr(struct sock *sk, struct sctp_prim *prim);
>  
>  #endif /* __net_sctp_h__ */
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 64c395f7a86d5..39bf8090dbe1e 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -6411,6 +6411,35 @@ static int sctp_getsockopt_local_addrs(struct sock *sk, int len,
>  	return err;
>  }
>  
> +static int __sctp_sock_get_primary_addr(struct sock *sk, struct sctp_prim *prim)
> +{
> +	struct sctp_association *asoc;
> +
> +	asoc = sctp_id2assoc(sk, prim->ssp_assoc_id);
> +	if (!asoc)
> +		return -EINVAL;
> +	if (!asoc->peer.primary_path)
> +		return -ENOTCONN;
> +
> +	memcpy(&prim->ssp_addr, &asoc->peer.primary_path->ipaddr,
> +		asoc->peer.primary_path->af_specific->sockaddr_len);
> +
> +	sctp_get_pf_specific(sk->sk_family)->addr_to_user(sctp_sk(sk),
> +			(union sctp_addr *)&prim->ssp_addr);
> +	return 0;
> +}
> +
> +int sctp_sock_get_primary_addr(struct sock *sk, struct sctp_prim *prim)
> +{
> +	int ret;
> +
> +	lock_sock(sk);
> +	ret = __sctp_sock_get_primary_addr(sk, prim);
> +	release_sock(sk);
> +	return ret;
> +}
> +EXPORT_SYMBOL(sctp_sock_get_primary_addr);
> +
>  /* 7.1.10 Set Primary Address (SCTP_PRIMARY_ADDR)
>   *
>   * Requests that the local SCTP stack use the enclosed peer address as
> @@ -6421,35 +6450,19 @@ static int sctp_getsockopt_primary_addr(struct sock *sk, int len,
>  					char __user *optval, int __user *optlen)
>  {
>  	struct sctp_prim prim;
> -	struct sctp_association *asoc;
> -	struct sctp_sock *sp = sctp_sk(sk);
> +	int ret;
>  
>  	if (len < sizeof(struct sctp_prim))
>  		return -EINVAL;
> -
> -	len = sizeof(struct sctp_prim);
> -
> -	if (copy_from_user(&prim, optval, len))
> +	if (copy_from_user(&prim, optval, sizeof(struct sctp_prim)))
>  		return -EFAULT;
>  
> -	asoc = sctp_id2assoc(sk, prim.ssp_assoc_id);
> -	if (!asoc)
> -		return -EINVAL;
> -
> -	if (!asoc->peer.primary_path)
> -		return -ENOTCONN;
> -
> -	memcpy(&prim.ssp_addr, &asoc->peer.primary_path->ipaddr,
> -		asoc->peer.primary_path->af_specific->sockaddr_len);
> -
> -	sctp_get_pf_specific(sk->sk_family)->addr_to_user(sp,
> -			(union sctp_addr *)&prim.ssp_addr);
> +	ret = __sctp_sock_get_primary_addr(sk, &prim);
> +	if (ret)
> +		return ret;
>  
> -	if (put_user(len, optlen))
> +	if (put_user(len, optlen) || copy_to_user(optval, &prim, len))
>  		return -EFAULT;
> -	if (copy_to_user(optval, &prim, len))
> -		return -EFAULT;
> -
>  	return 0;
>  }
>  
> -- 
> 2.26.2
> 
