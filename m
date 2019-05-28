Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34572CED2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfE1SmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:42:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42750 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727235AbfE1SmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:42:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id go2so8684556plb.9
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=U2ewQAuwCBDkySUUybTppwFKk1nFEG38Blr8JkptJdw=;
        b=aJidNVVStZXqRBi7wEJmwe+/I6qoe5jouoQvnc+mtFqv/GMizmVfPN8MKUsSig2I/d
         W5AKC/TClFaeqHSeJiB6s371V6gJLAhJb+EDiEG2egFbLv5RPxmVQpYDevXojyKLh8Ru
         aDqPFa9aTAYtzG8MoYkaMDLpcYbjFGQqmLNcXsqmsxJMs2lkiTMrzEi7Zax/T/gm/lkR
         WGMGOYNITZvZ8iUx002FOONS8jSyAqkVoqf2G9MgtD88gf07Xh+Cr2Ep3CSmy1kHrg0s
         Flf4+ZCSSu/6Tv1vXCP1sDsnPvISv8oWd1WLdFWbk2mXUu0fLdPac6UKJ4nH3WIk7oVv
         rK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U2ewQAuwCBDkySUUybTppwFKk1nFEG38Blr8JkptJdw=;
        b=B36R9tOVSAoPDUhl0lHQUqGlNDQvctqiCZW7KhQX30c2UfTN004E64RULDpOLI2ff4
         DNlnA/5OVgW8lVT+glZVeDwfCdOZJ4S2ml4JFJ6XU9/qC7CUwepglRNtxGgi/tXTNhdX
         oF+Qea+qgBCjzn/TwUvR2fpnj4gjL9TU2OUfFfd7Z7geOGirh4/EKO6zwKvSRgOYeKuJ
         b10sSJJiyW5RKFdSxQPYhKIVdsCfWqUwCDyKWxxqRpYyXEp7JsP4qt7igp4ouPgrZ66l
         iHPm7X0TA4BdSdysESUWGVyq/pFClSc+kYSRUXt6XDuubq4N7eog2vhBOPE0wZoHCiH/
         /Qbw==
X-Gm-Message-State: APjAAAUBC4gwZkyLCeJfdKHUy92yFV58LBIEWjG+bOieDGeA95V4WgsY
        48E/3+fSjWAzZtaxtM3CJg5Uyq90
X-Google-Smtp-Source: APXvYqzyw2bXA2MiHfIdTuEDeypjXzS14WKuDJVYbnL+lP2nJQ1olAPDg/MMyhBFZa/QO7wrX/VJCw==
X-Received: by 2002:a17:902:ab90:: with SMTP id f16mr27022455plr.262.1559068935410;
        Tue, 28 May 2019 11:42:15 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id r4sm3343428pjd.28.2019.05.28.11.42.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:42:14 -0700 (PDT)
Subject: Re: [PATCH] v3.19.8: tcp: re-enable high throughput for low pacing
 rate
To:     Sergej Benilov <sergej.benilov@googlemail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
References: <20190528183425.31691-1-sergej.benilov@googlemail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a1f47ea3-5f6f-f2b5-f077-139d7ac3a67b@gmail.com>
Date:   Tue, 28 May 2019 11:42:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528183425.31691-1-sergej.benilov@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/19 11:34 AM, Sergej Benilov wrote:
> Since commit 605ad7f184b60cfaacbc038aa6c55ee68dee3c89 "tcp: refine TSO autosizing",
> the TSQ limit is computed as the smaller of
> sysctl_tcp_limit_output_bytes and max(2 * skb->truesize, sk->sk_pacing_rate >> 10).
> For low pacing rates, this approach sets a low limit, reducing throughput dramatically.

...

> 
> Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
> ---
>  net/ipv4/tcp_output.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index e625be56..71efca72 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2054,7 +2054,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
>  		 * One example is wifi aggregation (802.11 AMPDU)
>  		 */
>  		limit = max(2 * skb->truesize, sk->sk_pacing_rate >> 10);
> -		limit = min_t(u32, limit, sysctl_tcp_limit_output_bytes);
> +		limit = max_t(u32, limit, sysctl_tcp_limit_output_bytes);
>  
>  		if (atomic_read(&sk->sk_wmem_alloc) > limit) {
>  			set_bit(TSQ_THROTTLED, &tp->tsq_flags);
> 

NACK again, for the same reasons.

