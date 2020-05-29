Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49BD1E8315
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 18:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgE2QFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 12:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgE2QFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 12:05:49 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7D7C03E969;
        Fri, 29 May 2020 09:05:48 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id c185so2649769qke.7;
        Fri, 29 May 2020 09:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pd5lAZmWnGQEg9my+K8yqiGBxQw7BvJ1dx+ybceAc+M=;
        b=flf93cj1reYDcbDT3u7JD+/ZI2FqlzB/yXOhGH80n/apv8aSl4OmFJJYYXdFEgD2iP
         7EDNqFo8yTsMG9L7vdQ/rgGVpF+nl6s1/jB+Ye3IwclwAtYW+efliy5blg2NQPOeXljc
         UFdv1WagT/12zf29orcGmGvr97Z3xAgsNSVcI3xi7RseAW6/IHd/fwGS8R0/Qnr/I1Hw
         KfsWN+hAQ7386ilUbrRmqYB9RSZzyB5+iwXW8PQaO6tCeWdtIJ1Ra4cCrZe10YliKu0t
         NcvjNT1sa/ciBXimf9ujpxK0OlH0tu/U1IpW/YI8eUcgoe8uuGfCvddDgim9cJ0yqv/n
         JXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pd5lAZmWnGQEg9my+K8yqiGBxQw7BvJ1dx+ybceAc+M=;
        b=SZJkDmGx47xBvgoUZ4aQidMUMpJF3iv/yhz8Es2yHB1JpM2v3eCdzDh5TGhS6txngI
         AFNqoao0GqhDKgY5CXxBnMF0QnT0aAA2yhbkFfjblmmNrrbdFY63r2fG7UfwqyBXCutO
         q8b0e+Kj7T+9vmh1cIDEhpbh0DUzwpAHge3pKcB4Ngdn4QXpYUB6D/tkfsQXruZGA0Ft
         1Koqwywbhyxc9fAisN+n+tUFLAuCgvsTIk+NtYJGGxHHZfn97qYoN6O+pf5B7YsOAhBP
         YGQ/wT/HY2rRCqkb7BpgZ23pFSMoogaQv7t/lQMsIOYZHHQ8fQNLEzTeabanm/I8ZAZW
         IWfQ==
X-Gm-Message-State: AOAM5336Pl7EIc5rx23WjYUNksltT0vCfyPcSmdw0lG4YI/YFqNoPyST
        hSqE3aF22cTM05/d4C+u8/E=
X-Google-Smtp-Source: ABdhPJzmHd7SDMPI2q+JYngCQ2RfZPvDlFDGRklGnRQrYU+7mGWuhiht9GIratK6mbSYxK77dID42g==
X-Received: by 2002:a37:b446:: with SMTP id d67mr1200068qkf.136.1590768347949;
        Fri, 29 May 2020 09:05:47 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:516d:2604:bfa5:7157:afa1])
        by smtp.gmail.com with ESMTPSA id p10sm6755496qkm.121.2020.05.29.09.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:05:47 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id D94A7C1B84; Fri, 29 May 2020 13:05:44 -0300 (-03)
Date:   Fri, 29 May 2020 13:05:44 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Laight <David.Laight@aculab.com>,
        linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] sctp: refactor sctp_setsockopt_bindx
Message-ID: <20200529160544.GI2491@localhost.localdomain>
References: <20200529120943.101454-1-hch@lst.de>
 <20200529120943.101454-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529120943.101454-3-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 02:09:41PM +0200, Christoph Hellwig wrote:
> Split out a sctp_setsockopt_bindx_kernel that takes a kernel pointer
> to the sockaddr and make sctp_setsockopt_bindx a small wrapper around
> it.  This prepares for adding a new bind_add proto op.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 61 ++++++++++++++++++++++-------------------------
>  1 file changed, 28 insertions(+), 33 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 827a9903ee288..6e745ac3c4a59 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -972,23 +972,22 @@ int sctp_asconf_mgmt(struct sctp_sock *sp, struct sctp_sockaddr_entry *addrw)
>   * it.
>   *
>   * sk        The sk of the socket
> - * addrs     The pointer to the addresses in user land
> + * addrs     The pointer to the addresses
>   * addrssize Size of the addrs buffer
>   * op        Operation to perform (add or remove, see the flags of
>   *           sctp_bindx)
>   *
>   * Returns 0 if ok, <0 errno code on error.
>   */
> -static int sctp_setsockopt_bindx(struct sock *sk,
> -				 struct sockaddr __user *addrs,
> -				 int addrs_size, int op)
> +static int sctp_setsockopt_bindx_kernel(struct sock *sk,
> +					struct sockaddr *addrs, int addrs_size,
> +					int op)
>  {
> -	struct sockaddr *kaddrs;
>  	int err;
>  	int addrcnt = 0;
>  	int walk_size = 0;
>  	struct sockaddr *sa_addr;
> -	void *addr_buf;
> +	void *addr_buf = addrs;
>  	struct sctp_af *af;
>  
>  	pr_debug("%s: sk:%p addrs:%p addrs_size:%d opt:%d\n",
> @@ -997,17 +996,10 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	if (unlikely(addrs_size <= 0))
>  		return -EINVAL;
>  
> -	kaddrs = memdup_user(addrs, addrs_size);
> -	if (IS_ERR(kaddrs))
> -		return PTR_ERR(kaddrs);
> -
>  	/* Walk through the addrs buffer and count the number of addresses. */
> -	addr_buf = kaddrs;
>  	while (walk_size < addrs_size) {
> -		if (walk_size + sizeof(sa_family_t) > addrs_size) {
> -			kfree(kaddrs);
> +		if (walk_size + sizeof(sa_family_t) > addrs_size)
>  			return -EINVAL;
> -		}
>  
>  		sa_addr = addr_buf;
>  		af = sctp_get_af_specific(sa_addr->sa_family);
> @@ -1015,10 +1007,8 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  		/* If the address family is not supported or if this address
>  		 * causes the address buffer to overflow return EINVAL.
>  		 */
> -		if (!af || (walk_size + af->sockaddr_len) > addrs_size) {
> -			kfree(kaddrs);
> +		if (!af || (walk_size + af->sockaddr_len) > addrs_size)
>  			return -EINVAL;
> -		}
>  		addrcnt++;
>  		addr_buf += af->sockaddr_len;
>  		walk_size += af->sockaddr_len;
> @@ -1029,31 +1019,36 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  	case SCTP_BINDX_ADD_ADDR:
>  		/* Allow security module to validate bindx addresses. */
>  		err = security_sctp_bind_connect(sk, SCTP_SOCKOPT_BINDX_ADD,
> -						 (struct sockaddr *)kaddrs,
> -						 addrs_size);
> +						 addrs, addrs_size);
>  		if (err)
> -			goto out;
> -		err = sctp_bindx_add(sk, kaddrs, addrcnt);
> +			return err;
> +		err = sctp_bindx_add(sk, addrs, addrcnt);
>  		if (err)
> -			goto out;
> -		err = sctp_send_asconf_add_ip(sk, kaddrs, addrcnt);
> -		break;
> -
> +			return err;
> +		return sctp_send_asconf_add_ip(sk, addrs, addrcnt);
>  	case SCTP_BINDX_REM_ADDR:
> -		err = sctp_bindx_rem(sk, kaddrs, addrcnt);
> +		err = sctp_bindx_rem(sk, addrs, addrcnt);
>  		if (err)
> -			goto out;
> -		err = sctp_send_asconf_del_ip(sk, kaddrs, addrcnt);
> -		break;
> +			return err;
> +		return sctp_send_asconf_del_ip(sk, addrs, addrcnt);
>  
>  	default:
> -		err = -EINVAL;
> -		break;
> +		return -EINVAL;
>  	}
> +}
>  
> -out:
> -	kfree(kaddrs);
> +static int sctp_setsockopt_bindx(struct sock *sk,
> +				 struct sockaddr __user *addrs,
> +				 int addrs_size, int op)
> +{
> +	struct sockaddr *kaddrs;
> +	int err;
>  
> +	kaddrs = memdup_user(addrs, addrs_size);
> +	if (IS_ERR(kaddrs))
> +		return PTR_ERR(kaddrs);
> +	err = sctp_setsockopt_bindx_kernel(sk, kaddrs, addrs_size, op);
> +	kfree(kaddrs);
>  	return err;
>  }
>  
> -- 
> 2.26.2
> 
