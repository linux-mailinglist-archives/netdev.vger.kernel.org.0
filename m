Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C86367B5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 01:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFEXOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 19:14:08 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35486 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFEXOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 19:14:07 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so594053qto.2
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 16:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LIAHeZZ3YBveAzjt6IYo5okl7d9OCweBrPfpual66ns=;
        b=UP3fT7jHA9KAz8dPOFMarqwl+LYRYAaZzCYzFwo7oJ6hq8UPgsMQO5HHTQXU4lmmIk
         TP4IJIT2y3SDanKIpvLCLwQ3qjRAosGSMlfo8v2j6z0wDXw4GRvQcneXuilTkZTC1fZq
         PyjLACmG9M0OA4cSd2JYUsMHt+sH8fN9E3XUtuo9tD+Trv4JGR1OwSuY+GIHOD7rDFBT
         rF1m1tcm1GFNaqaUbWXZ7/wpi15CyiqNRiJ/Da9IjJXQa7BnuvEh3nn/e9cu4/64CHOp
         0ZV7vItW6T7UP3D+04b7NZRch5yOP6ozbln/8w+jmQfq9ZeKZAB1BM2FVhi+YWmxjyJ/
         boKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LIAHeZZ3YBveAzjt6IYo5okl7d9OCweBrPfpual66ns=;
        b=OUtJlgppb1dsZvspROJcESGYdd3ZNOkQlD/5OUwD5IDW1S+JEVyMmfiqmyLVyuifu0
         2yC+IWosfokkbCjpKvnIdh5OX8CjKCvIcsR3V7fy+d8iF0djJ4fzH/ifveMDUsNAVNyu
         vcZaQTWQmvHwxDyq2KGOZxjrGASmzRir0f2JKdVvxJdB1JgPXn6eeth6ePOI+plt+8s5
         i3GpFaqigPgOeDqA/hdmHzf1GJZVnjDrS3WbFXLo4ga9AJSHQURJ+BbLpVjigtm0p6ct
         DFI22YGE9nyebUfbYqtZoZuBpCSlE9FmoYdKg5UMG7d5ikxU1amgE/h0jh1YYzDCCMhX
         c3kg==
X-Gm-Message-State: APjAAAXAhn2ae1io3VVaJCQEBVWMI9o0My7N/2+cKLXm8ekjf6tfY/yf
        bKD9tkPDJvq571qh9t1zBbzx2A==
X-Google-Smtp-Source: APXvYqyqzPs//2zqhBUmDvL2u+8ygp1eP/zwz1ByeM8zJIUgBbXDLYgzmCckNUqW0zOxY+ba1b19VQ==
X-Received: by 2002:ac8:644:: with SMTP id e4mr29406455qth.173.1559776446219;
        Wed, 05 Jun 2019 16:14:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e5sm6970qkg.81.2019.06.05.16.14.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 16:14:05 -0700 (PDT)
Date:   Wed, 5 Jun 2019 16:14:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/2] tcp: ulp: add functions to dump
 ulp-specific information
Message-ID: <20190605161400.6c87d173@cakuba.netronome.com>
In-Reply-To: <a1feba1a1c03a331047d3a7a3a7acefdbee51735.1559747691.git.dcaratti@redhat.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
        <a1feba1a1c03a331047d3a7a3a7acefdbee51735.1559747691.git.dcaratti@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jun 2019 17:39:22 +0200, Davide Caratti wrote:
> currently, only getsockopt(TCP_ULP) can be invoked to know if a ULP is on
> top of a TCP socket. Extend idiag_get_aux() and idiag_get_aux_size(),
> introduced by commit b37e88407c1d ("inet_diag: allow protocols to provide
> additional data"), to report the ULP name and other information that can
> be made available by the ULP through optional functions.
> 
> Users having CAP_NET_ADMIN privileges will then be able to retrieve this
> information through inet_diag_handler, if they specify INET_DIAG_INFO in
> the request.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/net/tcp.h              |  3 +++
>  include/uapi/linux/inet_diag.h |  8 ++++++++
>  net/ipv4/tcp_diag.c            | 34 ++++++++++++++++++++++++++++++++--
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 0083a14fb64f..94431562c4b4 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2108,6 +2108,9 @@ struct tcp_ulp_ops {
>  	int (*init)(struct sock *sk);
>  	/* cleanup ulp */
>  	void (*release)(struct sock *sk);
> +	/* diagnostic */
> +	int (*get_info)(struct sock *sk, struct sk_buff *skb);
> +	size_t (*get_info_size)(struct sock *sk);
>  
>  	char		name[TCP_ULP_NAME_MAX];
>  	struct module	*owner;
> diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
> index e8baca85bac6..844133de3212 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -153,11 +153,19 @@ enum {
>  	INET_DIAG_BBRINFO,	/* request as INET_DIAG_VEGASINFO */
>  	INET_DIAG_CLASS_ID,	/* request as INET_DIAG_TCLASS */
>  	INET_DIAG_MD5SIG,
> +	INET_DIAG_ULP_INFO,
>  	__INET_DIAG_MAX,
>  };
>  
>  #define INET_DIAG_MAX (__INET_DIAG_MAX - 1)
>  
> +enum {

Value of 0 is commonly defined as UNSPEC (or NONE), so:

	ULP_UNSPEC,

here.  Also perhaps INET_ULP_..?

> +	ULP_INFO_NAME,
> +	__ULP_INFO_MAX,
> +};
> +
> +#define ULP_INFO_MAX (__ULP_INFO_MAX - 1)
> +
>  /* INET_DIAG_MEM */
>  
>  struct inet_diag_meminfo {
> diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
> index 81148f7a2323..de2e9e75b8e0 100644
> --- a/net/ipv4/tcp_diag.c
> +++ b/net/ipv4/tcp_diag.c
> @@ -88,10 +88,12 @@ static int tcp_diag_put_md5sig(struct sk_buff *skb,
>  static int tcp_diag_get_aux(struct sock *sk, bool net_admin,
>  			    struct sk_buff *skb)
>  {
> +	struct inet_connection_sock *icsk = inet_csk(sk);
> +	int err = 0;
> +
>  #ifdef CONFIG_TCP_MD5SIG
>  	if (net_admin) {
>  		struct tcp_md5sig_info *md5sig;
> -		int err = 0;
>  
>  		rcu_read_lock();
>  		md5sig = rcu_dereference(tcp_sk(sk)->md5sig_info);
> @@ -103,11 +105,33 @@ static int tcp_diag_get_aux(struct sock *sk, bool net_admin,
>  	}
>  #endif
>  
> -	return 0;
> +	if (net_admin && icsk->icsk_ulp_ops) {
> +		struct nlattr *nest;
> +
> +		nest = nla_nest_start_noflag(skb, INET_DIAG_ULP_INFO);
> +		if (!nest) {
> +			err = -EMSGSIZE;
> +			goto nla_failure;
> +		}
> +		err = nla_put_string(skb, ULP_INFO_NAME,
> +				     icsk->icsk_ulp_ops->name);
> +		if (err < 0)

nit: nla_put_string() does not return positive non-zero codes

> +			goto nla_failure;
> +		if (icsk->icsk_ulp_ops->get_info)
> +			err = icsk->icsk_ulp_ops->get_info(sk, skb);

And neither should this, probably.

> +		if (err < 0) {
> +nla_failure:
> +			nla_nest_cancel(skb, nest);
> +			return err;
> +		}
> +		nla_nest_end(skb, nest);
> +	}
> +	return err;

So just return 0 here.

>  }
>  
>  static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
>  {
> +	struct inet_connection_sock *icsk = inet_csk(sk);
>  	size_t size = 0;
>  
>  #ifdef CONFIG_TCP_MD5SIG
> @@ -128,6 +152,12 @@ static size_t tcp_diag_get_aux_size(struct sock *sk, bool net_admin)
>  	}
>  #endif
>  
> +	if (net_admin && icsk->icsk_ulp_ops) {
> +		size +=   nla_total_size(0) /* INET_DIAG_ULP_INFO */

                       ^^^ not sure we want those multiple spaces here.

> +			+ nla_total_size(TCP_ULP_NAME_MAX); /* ULP_INFO_NAME */

+ usually goes at the end of previous line

> +		if (icsk->icsk_ulp_ops->get_info_size)
> +			size += icsk->icsk_ulp_ops->get_info_size(sk);

I don't know the diag code, is the socket locked at this point?

> +	}
>  	return size;
>  }
>  
