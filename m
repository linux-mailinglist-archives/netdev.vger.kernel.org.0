Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82B1445E21
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 03:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbhKEC6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 22:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhKEC6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 22:58:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D019C061714;
        Thu,  4 Nov 2021 19:55:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y1so10200846plk.10;
        Thu, 04 Nov 2021 19:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=45+llUOgil6QGWh/6zA+LlVuyM/uPXKNATalzsb9kFc=;
        b=pv6QeQ8U3fe0uYwo3nvn2NBkmImxld1nouO0U2Bb2SB1oS2VTJbyGPSSAtN8RnPoXi
         /R/lG1B4IZQBMUNiaRcR45Y9dqiYj0ldw+xaOEzVNZkKQ0ImUkzvHi/a880GXPyrF0CE
         eBvJiRHzu3FH4DsaGxGPkj4EbLyb4TC9PCWe1iIsHv0HW3KrxVTporL7plYx1KYmYi1B
         6VCceV3gO4MbPbc2241SCb7DjjQLSVVASXK7weqsOODJlMd2oU8wKUZKYFFG2+XeCeJB
         c4Ton1OLqxRyWtSizv14JjFLMLIeo99g1WKLtNOL0A4W3n3EYNE7OmdBygf9ISi0ZjVf
         tKOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=45+llUOgil6QGWh/6zA+LlVuyM/uPXKNATalzsb9kFc=;
        b=hWlTMz0s3/11fZKJYtanQiAdDVTlK+zobj/OE86uuzay58aji+8zXVahIXOaGQatwC
         v+YzZG1hIPoWy2I5k9r3ggRLZyd9yC/lEJ5ROxvM2HsAjxNL4vuG+O80oXGbhJ/iwuGC
         qOhLrFn1X5h444ix0wya8kA4/BH0CxzgBHfJcgSHKnsmTPaarBmDPrlpq/spzfmnM+0r
         K9Ov1K07Z5CGzlhav8xtaZ5TlrSQNNhHzSnTyhArA9aEdbD3/bxhYdX6GQSSx0qYZV1j
         L/MjyWibL9Rc8YMv3BiYrwllra7ASqvaQwpiVaW9Ngu61k3X2ynciOF0aAFZPnYPplqt
         DD7g==
X-Gm-Message-State: AOAM530egzn+WJY0eKqBG4GeGkfptBpCIl9kmfo2GLY9s2T0Vh+bXH3e
        6p4X6zR5oq36ohDqItN6ThhXPsllbz4=
X-Google-Smtp-Source: ABdhPJzitAh5fVbBpk8AOP9CIVqZherI1eQpadhUmMFN6+//TTEVSLvgjHeSK48MWE+Y4SoSMlRE1w==
X-Received: by 2002:a17:90b:1b04:: with SMTP id nu4mr26949131pjb.72.1636080921439;
        Thu, 04 Nov 2021 19:55:21 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d2sm6417300pfj.42.2021.11.04.19.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 19:55:20 -0700 (PDT)
Subject: Re: [PATCH 1/5] tcp/md5: Don't BUG_ON() failed kmemdup()
To:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
References: <20211105014953.972946-1-dima@arista.com>
 <20211105014953.972946-2-dima@arista.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <15c0469e-9433-0a8d-50f0-de6517365464@gmail.com>
Date:   Thu, 4 Nov 2021 19:55:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211105014953.972946-2-dima@arista.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 6:49 PM, Dmitry Safonov wrote:
> static_branch_unlikely(&tcp_md5_needed) is enabled by
> tcp_alloc_md5sig_pool(), so as long as the code doesn't change
> tcp_md5sig_pool has been already populated if this code is being
> executed.
> 
> In case tcptw->tw_md5_key allocaion failed - no reason to crash kernel:
> tcp_{v4,v6}_send_ack() will send unsigned segment, the connection won't be
> established, which is bad enough, but in OOM situation totally
> acceptable and better than kernel crash.
> 
> Introduce tcp_md5sig_pool_ready() helper.
> tcp_alloc_md5sig_pool() usage is intentionally avoided here as it's
> fast-path here and it's check for sanity rather than point of actual
> pool allocation. That will allow to have generic slow-path allocator
> for tcp crypto pool.
> 
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  include/net/tcp.h        | 1 +
>  net/ipv4/tcp.c           | 5 +++++
>  net/ipv4/tcp_minisocks.c | 5 +++--
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 4da22b41bde6..3e5423a10a74 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1672,6 +1672,7 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
>  #endif
>  
>  bool tcp_alloc_md5sig_pool(void);
> +bool tcp_md5sig_pool_ready(void);
>  
>  struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
>  static inline void tcp_put_md5sig_pool(void)
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index b7796b4cf0a0..c0856a6af9f5 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4314,6 +4314,11 @@ bool tcp_alloc_md5sig_pool(void)
>  }
>  EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
>  
> +bool tcp_md5sig_pool_ready(void)
> +{
> +	return tcp_md5sig_pool_populated;
> +}
> +EXPORT_SYMBOL(tcp_md5sig_pool_ready);
>  
>  /**
>   *	tcp_get_md5sig_pool - get md5sig_pool for this user
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index cf913a66df17..c99cdb529902 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -293,11 +293,12 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
>  			tcptw->tw_md5_key = NULL;
>  			if (static_branch_unlikely(&tcp_md5_needed)) {
>  				struct tcp_md5sig_key *key;
> +				bool err = WARN_ON(!tcp_md5sig_pool_ready());
>  
>  				key = tp->af_specific->md5_lookup(sk, sk);
> -				if (key) {
> +				if (key && !err) {
>  					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
> -					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
> +					WARN_ON_ONCE(tcptw->tw_md5_key == NULL);
>  				}
>  			}
>  		} while (0);
> 

Hmmm.... how this BUG_ON() could trigger exactly ?

tcp_md5_needed can only be enabled after __tcp_alloc_md5sig_pool has succeeded.

This patch, sent during merge-window, is a distraction, sorry.

About renaming : It looks nice, but is a disaster for backports
done for stable releases. Please refrain from doing this.
