Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E546C2CECC
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfE1SkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:40:12 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45741 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfE1SkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:40:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id w34so6831251pga.12
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ugwqTNmHZBVSjKOVpQCavQwAWvHNJ2wgnH55QWXypp0=;
        b=B6a2upfZPI5xNbjrWqMlrTfupLk7g6Uoi2Leipbz1Qlyf1NE6515szYdl285a8wvUv
         hTsQ3s3wVyVu76FYr0GnYdarjEw25/dbsoT76dGLwaymXPZo3yJpAalzXVUk6jOy8r/g
         dU5cidC3oCzafuW8wKCpUx9aVjIr418iDufLDa58lUliShQQFg1MTjKBkj4+zXruDha/
         9m+X8YtE01HatnUuey3lJppQqKWiKofow2mrySlMvC5Uo1BoP4IwuNIzfhgMA5F1PBX7
         liUNBkxUGSN2P+7qfVl2G3jMMRa2EbSn+9eyzoDcD+8L7GOn0++vQLLVB+y5MsUUV1Vp
         M/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ugwqTNmHZBVSjKOVpQCavQwAWvHNJ2wgnH55QWXypp0=;
        b=Ew8bcgt/k4SjuDX9EOFumIOM+buIwTEr1w/yvwq7KAfLJ2zzVM8QTVeiz6aAXrLSU0
         RJ+m7RIOk0cpBchrXG7FbzwmpDXvDiXQvCeJQara4zevXAZy06XmDF+qhYmi944yfGoe
         5oTbbrARLiWSCRM4NsXluScL9wjIS/SasW2TIuKuOyxfooHTu2VpN0W4lAy8toAHkQGP
         Hz1SVepEp+aTwWr9ZiUVRHXfr1j2Gyh37ulyZVKEQLnKvEuNCScsrFgfsZzurqYU1/kF
         mT9to622VjSImEcsTEj2U4hbmA1CIXRLHDvXkCON2rWwj1FlrnhoZY3d4qvq2t/sC0bU
         p13g==
X-Gm-Message-State: APjAAAXBtps4iMlbbQ3PLu8fedOGCWa/7EfsGvxspHWQWH8G0tFn4KFK
        2rEUKeuDLiQCsumpDAUe/Bb8zvo5
X-Google-Smtp-Source: APXvYqyA+jF3bK3taEDTrNDgc7NpvcC/ofkeuBSi90Ecx4daenci/UXw2rCJ9StBcJZB8BIFbpGQDQ==
X-Received: by 2002:a17:90a:7147:: with SMTP id g7mr7663789pjs.42.1559068810745;
        Tue, 28 May 2019 11:40:10 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id d85sm17725898pfd.94.2019.05.28.11.40.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:40:09 -0700 (PDT)
Subject: Re: [PATCH] tcp: re-enable high throughput for low pacing rate
To:     Sergej Benilov <sergej.benilov@googlemail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
References: <20190528182826.31500-1-sergej.benilov@googlemail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <91867050-ff41-55ff-6ffc-00d48a1b50fd@gmail.com>
Date:   Tue, 28 May 2019 11:40:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528182826.31500-1-sergej.benilov@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/19 11:28 AM, Sergej Benilov wrote:
> Since commit 605ad7f184b60cfaacbc038aa6c55ee68dee3c89 "tcp: refine TSO autosizing",
> the TSQ limit is computed as the smaller of
> sysctl_tcp_limit_output_bytes and max(2 * skb->truesize, sk->sk_pacing_rate >> 10).
> For low pacing rates, this approach sets a low limit, reducing throughput dramatically.
> 
> Compute the limit as the greater of sysctl_tcp_limit_output_bytes and max(2 * skb->truesize, sk->sk_pacing_rate >> 10).
> 
> Test:
> netperf -H remote -l -2000000 -- -s 1000000
> 
> before patch:
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380 327680 327680    250.17      0.06
> 
> after patch:
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380 327680 327680    1.29       12.54
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

NACK to this patch, based on some old linux kernel versions.

The min_t() is here is really what was intended.

You might have an issue on the driver you are using.

Some wifi drivers are now setting a hint, check for sk_pacing_shift_update()

bufferbloat prevention is hard, please do not mess badly with it.
