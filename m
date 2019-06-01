Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58D9F31887
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfFAACI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:02:08 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39856 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfFAACI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:02:08 -0400
Received: by mail-pl1-f196.google.com with SMTP id g9so4610736plm.6
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 17:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c64TTfxiPSDN6R+Cb8TzHsuYew+s7REVpoZojkuxXUU=;
        b=bT7r3WPcPuG1ERcZeb8FqUs/asPTjf5qnJMV1ykRal1W3Q5ZSz6Di/a1rdpgoIHVlA
         1s6KKuCeZnL2Kkf+h5Aucdy8EWSiz5qdciArC6dnvHn6YksJu6I1KtvoccTIInfFUDki
         FzrQOm8U86Rx7zZsVTD75fduJ9bOwuSQ/Fg6xUqcELAN/U9zY6ycZ4Y9Dq4Z42RVGgpe
         h3Sfzm73uMJxt6lmfJzNv1FLzj2Qs09apFJXDXJPsdwOVCcoq+fdz8piZDWBHN2TVais
         TbwUECuFaqGOVW5oxt9SY4va35pGquFTK38sVUtxnogRKMJMcA/nWb00khaeEj+9JJT9
         stJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c64TTfxiPSDN6R+Cb8TzHsuYew+s7REVpoZojkuxXUU=;
        b=JzJt9dY+1byNdGXCwQvZD0xWMOknWGka/mFCK86pikR3gX53e4RT05yBJTxdirbyZI
         HmKpHpI1aB2jA3QO/MPRI/AgTCZjV3zvtpvjk+3nVpnIMnsLet2S88zLHKuCsaGJIQsH
         wjq38gxwKHIHY92L3jW/TCLG3Yb9u/O25XyadgGJygYJFAOWKk2SvazQqN6YNn6lcvBd
         h8sn7R+BSSl6wFLpkD8O9QuzYDYC32c44IE9MItYunZrVqNnzY7ZDOwoQNLD9Y4re2BW
         FUWHsaY2GnjJHuOLRF/GSXjJRQq5C12rZzBS1jlivoHmEU1glydToBOxgIwgW//fKCGX
         wSCQ==
X-Gm-Message-State: APjAAAUMktZxWsiAs4yK3hwSvO40fILokn6aND3WsGtjTRBUDC+VHgGz
        Jy9a/qgb3wAZc50aXwkAtc0=
X-Google-Smtp-Source: APXvYqzWweNeXvPjTWL+LlbsrInZHHisg9kOtbrMtqYvX5BmmEb5WcJtPvscVlhjovckn5ilLkUMJw==
X-Received: by 2002:a17:902:6bcb:: with SMTP id m11mr12292514plt.318.1559347327440;
        Fri, 31 May 2019 17:02:07 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id u71sm6727287pjb.7.2019.05.31.17.02.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 17:02:06 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: use indirect calls helpers for ptype
 hook
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1556889691.git.pabeni@redhat.com>
 <e49a56bf6b08ec729f302aeeaba88ef7cd2a3a45.1556889691.git.pabeni@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fda17a73-2b3f-e1f9-170c-f8faa051fe34@gmail.com>
Date:   Fri, 31 May 2019 17:02:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <e49a56bf6b08ec729f302aeeaba88ef7cd2a3a45.1556889691.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/19 8:01 AM, Paolo Abeni wrote:
> This avoids an indirect call per RX IPv6/IPv4 packet.
> Note that we don't want to use the indirect calls helper for taps.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/core/dev.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 22f2640f559a..108ac8137b9b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4987,7 +4987,8 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
>  
>  	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
>  	if (pt_prev)
> -		ret = pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
> +		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
> +					 skb->dev, pt_prev, orig_dev);
>  	return ret;
>  }
>  
> @@ -5033,7 +5034,8 @@ static inline void __netif_receive_skb_list_ptype(struct list_head *head,
>  	else
>  		list_for_each_entry_safe(skb, next, head, list) {
>  			skb_list_del_init(skb);
> -			pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
> +			INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
> +					   skb->dev, pt_prev, orig_dev);

IPv4 has ip_list_rcv() and IPv6 has ipv6_list_rcv(),
so the code  invoking ->list_func() should run,
meaning this part of the patch was not needed.

if (pt_prev->list_func != NULL)
    pt_prev->list_func(head, pt_prev, orig_dev);

Maybe you want instead have INDIRECT_CALL_INET() for the list_func() calls.

