Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E991443B7E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhKCCrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhKCCrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:47:07 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC69C061714;
        Tue,  2 Nov 2021 19:44:32 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id l15so1698032oie.8;
        Tue, 02 Nov 2021 19:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cL6u9895NSZTZOeZgFQofwNy409f1x1M+KuZz4xRj4U=;
        b=mxG1TktwRrsKRDbub3sFNRLnMExnCSubzzZ2/QIruPaEIwG9PdVLRov/5VNr6X8BD0
         Wr/OwRzSiSjRfmW5gwiX6x3RlgL2IhHZTNGnY4UesP7cbtLAkCzqpuGli2XdFkio2CTM
         A85yyX0R3LMsVdkawvt4BbZLDaUSMPV/vQ5sdvIrEKguEcztckHEZigOyualJ/W/1eTQ
         7wp7VRCEb/wgvpEMtz8t6Ow1Mws1Q/t37aZLHhUcANp/J+43I7NdQoWkXufOvHmPfKBe
         dhRKtd6VCVe4ixstfyia+BBKk2FWUonbW1JQgTzJXvspBNf7JsBoWerDjJ/x2kgtLdWx
         2c7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cL6u9895NSZTZOeZgFQofwNy409f1x1M+KuZz4xRj4U=;
        b=klZm5hyzfQfp3RYe73kUUQKU7GDMLp0ay6xqeKuwBMvzSlMqoXTkzcLUn8++nABliG
         2VzexC6NTley6qHIx+I8UTLhUwST0YJyex6CqeSWtbsu9rBmqkdHoOD0CL6aTSWP3h1X
         nWV9moFAhau5iNFzdwjC/svUo6xelpVDm2/b5qld9rCoQVW7H1GiQk2tXWyXUzSMAg2k
         70kiWQbjuPbc+NZmPd/ag/xO/Rk+vy0scYYapIgtu7q/kevb8bXsgvxfLcFJ5zh77/pA
         dNIXtPq1faJBm/lKPvsPKffwnPJe1Zpn3eI5+gjIBg47hmbQ4/2QqCrOJExq/IQ45roB
         gtXA==
X-Gm-Message-State: AOAM53219gGew0ufETlj8/PnTqFRBHktqjRxH4hsiFkA2VtnPNwYkypK
        BsBMzxDOP2DbtKPYP0fE0is=
X-Google-Smtp-Source: ABdhPJzISGebWubSHi3AkRuopPQ2C+KWhyezGClxf6GuEATRD33F95in2Di213SnjnQWU7PlWk1HSA==
X-Received: by 2002:aca:b9c5:: with SMTP id j188mr8298845oif.104.1635907471267;
        Tue, 02 Nov 2021 19:44:31 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id k26sm214615otp.42.2021.11.02.19.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 19:44:30 -0700 (PDT)
Message-ID: <37c1a2c7-3bfa-d36d-075f-a0065b8a05c1@gmail.com>
Date:   Tue, 2 Nov 2021 20:44:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 12/25] tcp: ipv6: Add AO signing for
 tcp_v6_send_response
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <f9ff27ecc4aabd8ed89d5dfe5195c9cda1e7dc9f.1635784253.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <f9ff27ecc4aabd8ed89d5dfe5195c9cda1e7dc9f.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:34 AM, Leonard Crestez wrote:
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 96a29caf56c7..68f9545e4347 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -902,13 +902,37 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
>  	struct sock *ctl_sk = net->ipv6.tcp_sk;
>  	unsigned int tot_len = sizeof(struct tcphdr);
>  	__be32 mrst = 0, *topt;
>  	struct dst_entry *dst;
>  	__u32 mark = 0;
> +#ifdef CONFIG_TCP_AUTHOPT
> +	struct tcp_authopt_info *authopt_info = NULL;
> +	struct tcp_authopt_key_info *authopt_key_info = NULL;
> +	u8 authopt_rnextkeyid;
> +#endif
>  
>  	if (tsecr)
>  		tot_len += TCPOLEN_TSTAMP_ALIGNED;
> +#ifdef CONFIG_TCP_AUTHOPT

I realize MD5 is done this way, but new code can always strive to be
better. Put this and the one below in helpers such that this logic is in
the authopt.h file and the intrusion here is a one liner that either
compiles in or out based on the config setting.

> +	/* Key lookup before SKB allocation */
> +	if (static_branch_unlikely(&tcp_authopt_needed) && sk) {
> +		if (sk->sk_state == TCP_TIME_WAIT)
> +			authopt_info = tcp_twsk(sk)->tw_authopt_info;
> +		else
> +			authopt_info = rcu_dereference(tcp_sk(sk)->authopt_info);
> +
> +		if (authopt_info) {
> +			authopt_key_info = __tcp_authopt_select_key(sk, authopt_info, sk,
> +								    &authopt_rnextkeyid);
> +			if (authopt_key_info) {
> +				tot_len += TCPOLEN_AUTHOPT_OUTPUT;
> +				/* Don't use MD5 */
> +				key = NULL;
> +			}
> +		}
> +	}
> +#endif
>  #ifdef CONFIG_TCP_MD5SIG
>  	if (key)
>  		tot_len += TCPOLEN_MD5SIG_ALIGNED;
>  #endif
>  
> @@ -961,10 +985,24 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
>  		tcp_v6_md5_hash_hdr((__u8 *)topt, key,
>  				    &ipv6_hdr(skb)->saddr,
>  				    &ipv6_hdr(skb)->daddr, t1);
>  	}
>  #endif
> +#ifdef CONFIG_TCP_AUTHOPT
> +	/* Compute the TCP-AO mac. Unlike in the ipv4 case we have a real SKB */
> +	if (static_branch_unlikely(&tcp_authopt_needed) && authopt_key_info) {
> +		*topt++ = htonl((TCPOPT_AUTHOPT << 24) |
> +				(TCPOLEN_AUTHOPT_OUTPUT << 16) |
> +				(authopt_key_info->send_id << 8) |
> +				(authopt_rnextkeyid));
> +		tcp_authopt_hash((char *)topt,
> +				 authopt_key_info,
> +				 authopt_info,
> +				 (struct sock *)sk,
> +				 buff);
> +	}
> +#endif
>  
>  	memset(&fl6, 0, sizeof(fl6));
>  	fl6.daddr = ipv6_hdr(skb)->saddr;
>  	fl6.saddr = ipv6_hdr(skb)->daddr;
>  	fl6.flowlabel = label;
> 

