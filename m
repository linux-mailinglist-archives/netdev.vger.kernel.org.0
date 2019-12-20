Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09AB127F3B
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfLTP1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:27:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51442 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfLTP1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:27:01 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so9341991wmd.1
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 07:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Yy3HegVgn8cm7bdIX7Hul7/Ock9KRtzXM9CGrgiAv+M=;
        b=eSyFDFse/V1rr42rrsKDksxmY5WiBznZWfFvlbwrrIE5HnqPjilyMbqyqcSUsic22f
         HJOZpKdl12pmp0C4iULBraC6o8Inh5Pm+T6HEOMwoqpuP6ZJi0fT/C+wKS2sGDXD99M6
         kxqkxkBUnK/hfpFSWzXsXIlwbPRx600xusiBUa+1UboZmk6WTYeETGZEKBoQP1CJph8K
         3MFX5q6z5+76HEBpP3NvSAxU5FdnpkWuaxGMmgtAqWIdyksQNL6BNRvnRvkuXUGWz+33
         qk8njys0rHrGFy8ncEo2u/KrcDs9z2wdD/vSZa0DIyl/vg/OlDp9qHIsce1INcNFZN1T
         kwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yy3HegVgn8cm7bdIX7Hul7/Ock9KRtzXM9CGrgiAv+M=;
        b=o60+2/bTIm+NVLp4p/Adzpt6rn12xIXOHPbgKT8SeBu6e2s0f87hItjEOp+wB+OOKw
         NspE/08JB3mRLkSrTf2O5Fil0MSJwKaiKc5S7fuapCa6A/V1PpoeqGHzVxGFd3FFVRms
         b9DFXJS2y7UEgqbVMJuki9TBxOC09hE+NGMmsv6fsKsLOaacmcX9y9Oa2cjfTXRkt92x
         jG4R2CDaCe6yHiBU8EMa6LKpLgZu8enbqhR1dihFyyz7sxW7kHVl2W+zRjG/IRJ37xex
         GfjNBiKfutft41oTZJ6qzVO9+zkP8QTg7hzEfN1d/mrCowqWOwmrA+nt1V+VJM/+02IS
         fimw==
X-Gm-Message-State: APjAAAXwNoZVbhTk9+MCvU/SH1HSNs48PMiCbqq5OvHWnfTtU2KvBfXI
        uMzz8cWzp6gLfOoM+ejGL+M=
X-Google-Smtp-Source: APXvYqw2UD1IPwgJ1of3NhzY6aVEXNUhH9u/AmBnzSPGuXuvxJ1swCD68jogVM/TqwhGQgJa7qHybA==
X-Received: by 2002:a7b:c318:: with SMTP id k24mr17687003wmj.54.1576855619626;
        Fri, 20 Dec 2019 07:26:59 -0800 (PST)
Received: from [192.168.8.147] (72.173.185.81.rev.sfr.net. [81.185.173.72])
        by smtp.gmail.com with ESMTPSA id z83sm10395921wmg.2.2019.12.20.07.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2019 07:26:59 -0800 (PST)
Subject: Re: [PATCH net-next v5 05/11] tcp, ulp: Add clone operation to
 tcp_ulp_ops
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
 <20191219223434.19722-6-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <de3e37b0-f3ff-c5d0-9a38-890ce04916c7@gmail.com>
Date:   Fri, 20 Dec 2019 07:26:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191219223434.19722-6-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/19 2:34 PM, Mat Martineau wrote:
> If ULP is used on a listening socket, icsk_ulp_ops and icsk_ulp_data are
> copied when the listener is cloned. Sometimes the clone is immediately
> deleted, which will invoke the release op on the clone and likely
> corrupt the listening socket's icsk_ulp_data.
> 
> The clone operation is invoked immediately after the clone is copied and
> gives the ULP type an opportunity to set up the clone socket and its
> icsk_ulp_data.
> 

Since the method is void, this means no error can happen.

For example we do not intend to attempt a memory allocation ?

> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  include/net/tcp.h               |  5 +++++
>  net/ipv4/inet_connection_sock.c |  2 ++
>  net/ipv4/tcp_ulp.c              | 12 ++++++++++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index d4b6bf2c5d3c..c82b2f75d024 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2145,6 +2145,9 @@ struct tcp_ulp_ops {
>  	/* diagnostic */
>  	int (*get_info)(const struct sock *sk, struct sk_buff *skb);
>  	size_t (*get_info_size)(const struct sock *sk);
> +	/* clone ulp */
> +	void (*clone)(const struct request_sock *req, struct sock *newsk,
> +		      const gfp_t priority);
>  
>  	char		name[TCP_ULP_NAME_MAX];
>  	struct module	*owner;
> @@ -2155,6 +2158,8 @@ int tcp_set_ulp(struct sock *sk, const char *name);
>  void tcp_get_available_ulp(char *buf, size_t len);
>  void tcp_cleanup_ulp(struct sock *sk);
>  void tcp_update_ulp(struct sock *sk, struct proto *p);
> +void tcp_clone_ulp(const struct request_sock *req,
> +		   struct sock *newsk, const gfp_t priority);
>  
>  #define MODULE_ALIAS_TCP_ULP(name)				\
>  	__MODULE_INFO(alias, alias_userspace, name);		\
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index e4c6e8b40490..d667f2569f8e 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -810,6 +810,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
>  		/* Deinitialize accept_queue to trap illegal accesses. */
>  		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
>  
> +		tcp_clone_ulp(req, newsk, priority);
> +
>  		security_inet_csk_clone(newsk, req);
>  	}
>  	return newsk;
> diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
> index 12ab5db2b71c..e7a2589d69ee 100644
> --- a/net/ipv4/tcp_ulp.c
> +++ b/net/ipv4/tcp_ulp.c
> @@ -130,6 +130,18 @@ void tcp_cleanup_ulp(struct sock *sk)
>  	icsk->icsk_ulp_ops = NULL;
>  }
>  
> +void tcp_clone_ulp(const struct request_sock *req, struct sock *newsk,
> +		   const gfp_t priority)
> +{
> +	struct inet_connection_sock *icsk = inet_csk(newsk);
> +
> +	if (!icsk->icsk_ulp_ops)
> +		return;
> +
> +	if (icsk->icsk_ulp_ops->clone)
> +		icsk->icsk_ulp_ops->clone(req, newsk, priority);
> +}
> +
>  static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
>  {
>  	struct inet_connection_sock *icsk = inet_csk(sk);
> 
