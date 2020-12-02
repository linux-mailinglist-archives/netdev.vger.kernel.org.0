Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202D62CC83C
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731193AbgLBUpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730320AbgLBUpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:45:21 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AD5C0613D6;
        Wed,  2 Dec 2020 12:44:40 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id k14so5536453wrn.1;
        Wed, 02 Dec 2020 12:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=siQ+4u2fls2vEOT6ZxwPBa9lneCi2Mme+Eia6lpJ7BQ=;
        b=ff/jONCPyYNtT7wZNpkzBrSui707VdITkSzfNCVKgvKl83E5+k05JM/FdNCPCKuLJH
         pwkzeDSnx/ayzlTKl2i0LbP+upz6bGjN/510Tt/HXknDck64aS29AiE4Rz0cTLSNDnT2
         T1Q5wDBX20wlODh0ZH4jIewKT/aMcWVjDNAq5iLdf3XsyALVysfDP4+rmKAzo/5hbVdL
         uSBaclSqGiPM4/D4u3V5vJHspfEtJtWgZCqum3LuopPYt8xIZToDm9Ynbn8xRyY1VaDT
         iZFLqd9EOBRyr8hpvBaeOtwigUiueI5zgJd2kuFNPMaJqpfDsDRTRBtL7jXzFEBYxp1c
         Ogww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=siQ+4u2fls2vEOT6ZxwPBa9lneCi2Mme+Eia6lpJ7BQ=;
        b=ExStukkw2tpQxQvY29RaxhahWd+134IHyIz1Ic7bUWC1VnFFdmnzfgfF3ibPL9pVVU
         iVGT8TDRwoMnylN5jnm6tDCe/7uaxEantm/WbHg+yxeuqrzD/QU2rkb+So/C6Cf5tHQ7
         hPiItRNgNb5gXf1YhLpSGOnDGQAcFyXn9e2qjZxSXTKQxLP3QzQsb8WFolzeHXAdzoeW
         dBwUVcLM3jhuRMt/L8S/6PXYmRskm82LXspVH7PcuiF5dME8tIP3GRvvwGg6ysBOcOMS
         +ZqMqZs7S5ZcGJR/d/0zLltncbCrL5StcGyQDiwpY91Nj0V9bLvjLU3+Hadiw8biiBxz
         fCmQ==
X-Gm-Message-State: AOAM532jeFNCni7SjBWt6ut/tlKu7HKUjnBMotOkyK/ng7d7LTyznmHu
        vHyNj/6QK6Prvt5xZINcAYifvJCIiNY=
X-Google-Smtp-Source: ABdhPJwFO74letTtAQieILhE5jr+JcdK02zDH06mdNzgh08vM6Mm/wBEkU1NzvXPbvtx/J5RQ3ebMw==
X-Received: by 2002:a5d:550f:: with SMTP id b15mr5618656wrv.112.1606941879182;
        Wed, 02 Dec 2020 12:44:39 -0800 (PST)
Received: from [192.168.8.116] ([37.164.23.254])
        by smtp.gmail.com with ESMTPSA id 34sm3362694wrh.78.2020.12.02.12.44.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 12:44:38 -0800 (PST)
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: Adds support for setting window
 clamp
To:     Prankur gupta <prankgup@fb.com>, bpf@vger.kernel.org
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
References: <20201202202925.165803-1-prankgup@fb.com>
 <20201202202925.165803-2-prankgup@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <14fc7e89-29ae-0657-d626-e0417f2043e4@gmail.com>
Date:   Wed, 2 Dec 2020 21:44:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201202202925.165803-2-prankgup@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/20 9:29 PM, Prankur gupta wrote:
> Adds a new bpf_setsockopt for TCP sockets, TCP_BPF_WINDOW_CLAMP,
> which sets the maximum receiver window size. It will be useful for
> limiting receiver window based on RTT.
> 
> Signed-off-by: Prankur gupta <prankgup@fb.com>
> ---
>  include/net/tcp.h |  1 +
>  net/core/filter.c |  3 +++
>  net/ipv4/tcp.c    | 23 ++++++++++++++---------
>  3 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 4aba0f069b05..39ced5882fe3 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -406,6 +406,7 @@ void tcp_syn_ack_timeout(const struct request_sock *req);
>  int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
>  		int flags, int *addr_len);
>  int tcp_set_rcvlowat(struct sock *sk, int val);
> +int tcp_set_window_clamp(struct sock *sk, struct tcp_sock *tp, int val);
>  void tcp_data_ready(struct sock *sk);
>  #ifdef CONFIG_MMU
>  int tcp_mmap(struct file *file, struct socket *sock,
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2ca5eecebacf..d6225842cfb1 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4910,6 +4910,9 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
>  				tp->notsent_lowat = val;
>  				sk->sk_write_space(sk);
>  				break;
> +			case TCP_WINDOW_CLAMP:
> +				ret = tcp_set_window_clamp(sk, tp, val);
> +				break;
>  			default:
>  				ret = -EINVAL;
>  			}
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index b2bc3d7fe9e8..312feb8fcae5 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3022,6 +3022,19 @@ int tcp_sock_set_keepcnt(struct sock *sk, int val)
>  }
>  EXPORT_SYMBOL(tcp_sock_set_keepcnt);
>  
> +int tcp_set_window_clamp(struct sock *sk, struct tcp_sock *tp, int val)

No TCP function pass both sk and tp (which are identical values)

Prefer :

int tcp_set_window_clamp(struct sock *sk, int val)
{
        struct tcp_sock *tp = tcp_sk(sk);
        ...

This will allow optimal code generation.

> +{
> +	if (!val) {
> +		if (sk->sk_state != TCP_CLOSE)
> +			return -EINVAL;
> +		tp->window_clamp = 0;
> +	} else {
> +		tp->window_clamp = val < SOCK_MIN_RCVBUF / 2 ?
> +			SOCK_MIN_RCVBUF / 2 : val;
> +	}
> +	return 0;
> +}
> +
>  /*
>   *	Socket option code for TCP.
>   */
> @@ -3235,15 +3248,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>  		break;
>  
>  	case TCP_WINDOW_CLAMP:
> -		if (!val) {
> -			if (sk->sk_state != TCP_CLOSE) {
> -				err = -EINVAL;
> -				break;
> -			}
> -			tp->window_clamp = 0;
> -		} else
> -			tp->window_clamp = val < SOCK_MIN_RCVBUF / 2 ?
> -						SOCK_MIN_RCVBUF / 2 : val;
> +		err = tcp_set_window_clamp(sk, tp, val);
>  		break;
>  
>  	case TCP_QUICKACK:
> 
