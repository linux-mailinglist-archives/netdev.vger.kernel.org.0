Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FEF134716
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgAHQE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:04:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33478 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgAHQE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:04:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id b6so4025071wrq.0
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 08:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=J/wg0132HAIWEd8xCm6xyI6YddAdAENvsL9uYGE4WaU=;
        b=unHtZYE3YDCGUTDMZDS44ZDsOWNlH2ut2N9MvbMazovaN4RuZIl6V62PQiKMeP2AU8
         C75g2iDgeWWeZJgX5RmJirufgO7kwVWrJ8tobkXdy4nkASGmgv5spd+OdpUG3dShj1ZV
         B4YHvLpLWtx6GhfE0NXpz/tlGF2Tjz+PDjCMu/SQnqrVcwqYLkbUqCrvjrN/yivSaAN/
         uviSf3L2u8DmR49pUb/JnV2dDsyKyapfoBaY6K9Pp8BlO3NlD4ou0Kjaybp+hRBMSNOU
         /As501D79MKUKRCGNPr74oZ0aLs06Ie2PTCQaHPkybmir6Y4lHKP6lUy/bYs3yiDLv0I
         XKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J/wg0132HAIWEd8xCm6xyI6YddAdAENvsL9uYGE4WaU=;
        b=mLTH7YiP2onygMBaEZ4uV91kWjIPbS0dTOeZH0f/jZ7ZaD6bRWuuEIj5MoxgeCcx/b
         tlWJRBQHGBHtzhCfAUs/aFHKcRDjc/9uazo4W3jXXfbAiLJU3JeukdUWoOVp2MAIJMMq
         bBVGcrpPuwEZx0fcAnOxcUggGUUaizhYl49zoxvL8ky3NFRpbIDFKfGxkh39DrXZHFEo
         5RDtZBSG8ppUOm7wsQeNJZgDzfjBOS3SsGDSiQdqqXyTO9uWCoYlMFIV26P3m3H5G93O
         xWP3VVJjSRy9+XchZEkWv8+cgu/iLDb+qDV4vAme1kPpmR8EofUi0rkdXWJNHwO195xz
         8lGQ==
X-Gm-Message-State: APjAAAVHxuHnubQUKEb30aK0ct84r5K98bBq3TtgTcM90SG+V4MZkDIr
        opAgSZPMH+j+z93rLkU3mDoFs32u
X-Google-Smtp-Source: APXvYqxPU8oFFyKVTcei/Tb2QJmf3yCOBNL5n5ysDp5Z0fLK1JZvwiLstnHKkVpgQU2PhVSN1CSLhA==
X-Received: by 2002:a5d:6551:: with SMTP id z17mr5692623wrv.269.1578499495679;
        Wed, 08 Jan 2020 08:04:55 -0800 (PST)
Received: from [192.168.8.147] (102.164.185.81.rev.sfr.net. [81.185.164.102])
        by smtp.gmail.com with ESMTPSA id v83sm4307954wmg.16.2020.01.08.08.04.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 08:04:54 -0800 (PST)
Subject: Re: [PATCH net-next v6 05/11] tcp, ulp: Add clone operation to
 tcp_ulp_ops
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
References: <20200108011921.28942-1-mathew.j.martineau@linux.intel.com>
 <20200108011921.28942-6-mathew.j.martineau@linux.intel.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7df4cdc2-37fe-e724-a2e8-829b6920e9c6@gmail.com>
Date:   Wed, 8 Jan 2020 08:04:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200108011921.28942-6-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/20 5:19 PM, Mat Martineau wrote:
> If ULP is used on a listening socket, icsk_ulp_ops and icsk_ulp_data are
> copied when the listener is cloned. Sometimes the clone is immediately
> deleted, which will invoke the release op on the clone and likely
> corrupt the listening socket's icsk_ulp_data.
> 
> The clone operation is invoked immediately after the clone is copied and
> gives the ULP type an opportunity to set up the clone socket and its
> icsk_ulp_data.
> 
> The MPTCP ULP clone will silently fallback to plain TCP on allocation
> failure, so 'clone()' does not need to return an error code.
> 
> v5 -> v6:
>  - clarified MPTCP clone usage in commit message
> 
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
>  include/net/tcp.h               |  5 +++++
>  net/ipv4/inet_connection_sock.c |  2 ++
>  net/ipv4/tcp_ulp.c              | 12 ++++++++++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 85f1d7ff6e8b..82879718d35a 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2154,6 +2154,9 @@ struct tcp_ulp_ops {
>  	/* diagnostic */
>  	int (*get_info)(const struct sock *sk, struct sk_buff *skb);
>  	size_t (*get_info_size)(const struct sock *sk);
> +	/* clone ulp */
> +	void (*clone)(const struct request_sock *req, struct sock *newsk,
> +		      const gfp_t priority);
>  
>  	char		name[TCP_ULP_NAME_MAX];
>  	struct module	*owner;
> @@ -2164,6 +2167,8 @@ int tcp_set_ulp(struct sock *sk, const char *name);
>  void tcp_get_available_ulp(char *buf, size_t len);
>  void tcp_cleanup_ulp(struct sock *sk);
>  void tcp_update_ulp(struct sock *sk, struct proto *p);
> +void tcp_clone_ulp(const struct request_sock *req,
> +		   struct sock *newsk, const gfp_t priority);


Maybe not needed, see below.

>  
>  #define MODULE_ALIAS_TCP_ULP(name)				\
>  	__MODULE_INFO(alias, alias_userspace, name);		\
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 18c0d5bffe12..bf53a722923a 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -810,6 +810,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
>  		/* Deinitialize accept_queue to trap illegal accesses. */
>  		memset(&newicsk->icsk_accept_queue, 0, sizeof(newicsk->icsk_accept_queue));
>  
> +		tcp_clone_ulp(req, newsk, priority);

Since inet_csk_clone_lock() is also used by dccp, I would suggest renaming
this helper to inet_clone_ulp() ?

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

Unless I am mistaken, this is only used from  inet_csk_clone_lock()

So I would move this function in net/ipv4/inet_connection_sock.c, make it static
so that compiler can inline it cleanly.


