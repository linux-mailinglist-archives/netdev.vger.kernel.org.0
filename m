Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DA318A205
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgCRR7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 13:59:17 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46426 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgCRR7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 13:59:17 -0400
Received: by mail-pg1-f196.google.com with SMTP id y30so14081341pga.13
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 10:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CnA7/Xu0NQs9NwBN2bst7DdL1jgo5t7ZKIEKv3j7WoU=;
        b=VDyR14u9nysz5rpF6+dXzVA0UGC1RLBSBHpCchPnsFZQ93pOGfLX5AgMLBbpfBwtLd
         7o9CgVC93O0tYIBHVYP/+2k63ECUxt5+L3Zoskazw+ESXka5vcSyd603DKQu91dTwTb6
         DOoAsJLwNcoQAuWzxmu2WrQ8u3etmmZ4iugBAsEI/ehgqp4andz2LDdlFtEbopXygNsL
         eO8lDFWymwYUThylWDC7nEX84LaaxqsMx4mbNHGb+As4UoO8J0n2aCNLzxkKLnbXezue
         kGv0IM3KsobHHZGdknsoOu56EDNciyWQN3bSJ0X120vN5VQHqZokax9ouyr7Par59nyJ
         2odg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CnA7/Xu0NQs9NwBN2bst7DdL1jgo5t7ZKIEKv3j7WoU=;
        b=bPufxJ5v8jSmiwwO4n8TaCchsryhT+KzdPICoIfctMLy3NFrrfWCn0SYknuGHdvNvm
         IxGd9r3TEK1Uq+Fq4GgIpjrMlzTzP5bUcmhGJQUby8PsOp8YVhjhhrytUGYX/Yq8Smgh
         +8gNbrWQ/6/DM/7Wy3//N0xc4uydrrgew0T9zY6nBkkXZFKhgiZiS0G3VC135I5+zXVq
         z1z4xrFuk6Gs/UDZMsmHjLHtJTmoGaJPVxx7anO89PHKOWiUp3ZXR5R6IVvE3xItMnmF
         3rh9LjRDnyWtqugZHW5gd/5F53JKOzlaZlHZ9vgsOxn18tXaTLntvcxdqVCWW5LvOZQQ
         zQGQ==
X-Gm-Message-State: ANhLgQ0r84T6MXARcrSlDIbNNtRPbz6TsRvf9/c5dLxpuXO5IWIZIkjD
        ChKr6ZKNfJ0VEVNmhLwhGtk=
X-Google-Smtp-Source: ADFU+vs/7REdz/pv4OTsW09i0jC69L9nJXIHnawVkzE+xNMIz3p/AS7tP2QPZKyLjrhHZEtCcONSNw==
X-Received: by 2002:aa7:848d:: with SMTP id u13mr5595365pfn.253.1584554355314;
        Wed, 18 Mar 2020 10:59:15 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id 9sm6579304pge.65.2020.03.18.10.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 10:59:14 -0700 (PDT)
Subject: Re: [RFC mptcp-next] tcp: mptcp: use mptcp receive buffer space to
 select rcv window
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
References: <20200318141917.2612-1-fw@strlen.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <48933c49-0889-5dba-29e2-62640e47797a@gmail.com>
Date:   Wed, 18 Mar 2020 10:59:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200318141917.2612-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/20 7:19 AM, Florian Westphal wrote:
> In MPTCP, the receive windo is shared across all subflows, because it
> refers to the mptcp-level sequence space.
> 
> This commit doesn't change choice of initial window for passive or active
> connections.
> While it would be possible to change those as well, this adds complexity
> (especially when handling MP_JOIN requests).
> 
> However, the MPTCP RFC specifically says that a MPTCP sender
> 'MUST NOT use the RCV.WND field of a TCP segment at the connection level if
> it does not also carry a DSS option with a Data ACK field.'
> 
> SYN/SYNACK packets do not carry a DSS option with a Data ACK field.
> 
> CC: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  This patch would add additional direct call in __tcp_select_window().
> 
>  I looked at mptcp option writing to check if it could be done there but
>  that seemed worse.
> 
>  include/net/mptcp.h   |  3 +++
>  net/ipv4/tcp_output.c |  5 +++++
>  net/mptcp/subflow.c   | 17 +++++++++++++++++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> index 7489f9267640..1ef4520f45c3 100644
> --- a/include/net/mptcp.h
> +++ b/include/net/mptcp.h
> @@ -66,6 +66,8 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
>  	return tcp_rsk(req)->is_mptcp;
>  }
>  
> +void mptcp_space(const struct sock *ssk, int *space, int *full_space);
> +
>  void mptcp_parse_option(const struct sk_buff *skb, const unsigned char *ptr,
>  			int opsize, struct tcp_options_received *opt_rx);
>  bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
> @@ -195,6 +197,7 @@ static inline bool mptcp_sk_is_subflow(const struct sock *sk)
>  	return false;
>  }
>  
> +static inline void mptcp_space(const struct sock *ssk, int *s, int *fs) { }
>  static inline void mptcp_seq_show(struct seq_file *seq) { }
>  #endif /* CONFIG_MPTCP */
>  
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 306e25d743e8..1a829536a115 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2771,6 +2771,11 @@ u32 __tcp_select_window(struct sock *sk)
>  	int full_space = min_t(int, tp->window_clamp, allowed_space);
>  	int window;
>  
> +	if (sk_is_mptcp(sk)) {
> +		mptcp_space(sk, &free_space, &allowed_space);
> +		full_space = min_t(int, tp->window_clamp, allowed_space);
> +	}

You could move the full_space = min_t(int, tp->window_clamp, allowed_space);
after this block factorize it.


> +
>  	if (unlikely(mss > full_space)) {
>  		mss = full_space;
>  		if (mss <= 0)
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 40ad7995b13b..aefcbb8bb737 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -745,6 +745,23 @@ bool mptcp_subflow_data_available(struct sock *sk)
>  	return subflow->data_avail;
>  }
>  
> +/* If ssk has an mptcp parent socket, use the mptcp rcvbuf occupancy,
> + * not the ssk one.
> + *
> + * In mptcp, rwin is about the mptcp-level connection data.
> + *
> + * Data that is still on the ssk rx queue can thus be ignored,
> + * as far as mptcp peer is concerened that data is still inflight.
> + */
> +void mptcp_space(const struct sock *ssk, int *space, int *full_space)
> +{
> +	const struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
> +	const struct sock *sk = READ_ONCE(subflow->conn);

What are the rules protecting subflow->conn lifetime ?

Why dereferencing sk after this line is safe ?

> +
> +	*space = tcp_space(sk);
> +	*full_space = tcp_full_space(sk);
> +}
> +
>  static void subflow_data_ready(struct sock *sk)
>  {
>  	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
> 
