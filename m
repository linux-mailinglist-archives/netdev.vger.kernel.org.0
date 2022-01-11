Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D7C48B90A
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 21:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbiAKU5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 15:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiAKU45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 15:56:57 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507E6C06173F;
        Tue, 11 Jan 2022 12:56:57 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id k18so448765wrg.11;
        Tue, 11 Jan 2022 12:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I//pyM+0NfxLPjUaJ8ZXZZdYGI++moJMA1nJi8tZH+o=;
        b=Ok/PDzMkTw6P44/G4KrU3iGJ/ZsVyhMol3icu9sBF2ttwdbfdMZszVGko3SE50eScw
         uw8uvKOiyHRTuPhOhos5LW/3H+wW3rwkhPMvMBc9TdBiqtBsThFQGX3KATp6p3qWD79B
         HMhXLpT1Osld5SYKApulNPuAY+RjqoI0shSxK2n8jbWomm5EnI1nUcoAd2vj0RN1io8o
         4OLUCju+PGbH6ic1a2pCIBTKqiCTtRMl50SzkPhjdOUKMiq5rmaSHvN2/0z6Lwag/7Ll
         voDWK3bEeS+Z6igwrXf5jpppxPKaGldGTsTw33DqTZC4uTJ6CDg9e9trczDFsOL7tSdB
         txmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I//pyM+0NfxLPjUaJ8ZXZZdYGI++moJMA1nJi8tZH+o=;
        b=X3WRcLFgqBYY4OQ0BRPumj4ycw+nt/edr4sPEWJCFVwfw54utoV7jHwkOwlhuXvlQe
         OpKioSb+QAeTNf9ZVwMhblN1PMjRzANeYeLLEF1p/n1+i7ILGDUimEg+crg26F6YnCO2
         q9jmgOmZ2vsmNYQxVHuKGvL/BFYv6/hlav7sR8sXC7hhJsikLzE5wiiKyE3+2jbMY3XN
         /AYXsV6NwZsFvq7JiWiglBHiaYEKe/h0yZl7tAWQlxADzTA4UsTSrtXPN9c+oQJtbFbE
         IiRzNLLJE+xYcCmqmB6JOft6sqiDa4HBYqJBnYp4BaVHRW3S1DHZ44f9wgye9B+fAUxk
         H+Vg==
X-Gm-Message-State: AOAM532wv6cb6T5hBBDv0EHrJ8OzjvSA4FZXMiVjTLVuDx+b/eYI8yp7
        3kWGeBmkfB5WqTvbawFIkqU=
X-Google-Smtp-Source: ABdhPJxxb1qosTjfS/y2jzeRxVQ+Ua9yI/MiwUJ/4dxtGKEClOpwQ+qltJCgazwxXUsOKsEi/wEuiQ==
X-Received: by 2002:a5d:60c7:: with SMTP id x7mr5202136wrt.456.1641934615972;
        Tue, 11 Jan 2022 12:56:55 -0800 (PST)
Received: from [10.0.0.5] ([37.165.158.36])
        by smtp.gmail.com with ESMTPSA id c8sm3236172wmq.34.2022.01.11.12.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 12:56:55 -0800 (PST)
Message-ID: <f35292c0-621f-3f07-87ed-2533bfd1496e@gmail.com>
Date:   Tue, 11 Jan 2022 12:56:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] ax25: use after free in ax25_connect
Content-Language: en-US
To:     Hangyu Hua <hbh25y@gmail.com>, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111042048.43532-1-hbh25y@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220111042048.43532-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/10/22 20:20, Hangyu Hua wrote:
> sk_to_ax25(sk) needs to be called after lock_sock(sk) to avoid UAF
> caused by a race condition.

Can you describe what race condition you have found exactly ?

sk pointer can not change.


> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>   net/ax25/af_ax25.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index cfca99e295b8..c5d62420a2a8 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -1127,7 +1127,7 @@ static int __must_check ax25_connect(struct socket *sock,
>   	struct sockaddr *uaddr, int addr_len, int flags)
>   {
>   	struct sock *sk = sock->sk;
> -	ax25_cb *ax25 = sk_to_ax25(sk), *ax25t;
> +	ax25_cb *ax25, *ax25t;
>   	struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)uaddr;
>   	ax25_digi *digi = NULL;
>   	int ct = 0, err = 0;
> @@ -1155,6 +1155,8 @@ static int __must_check ax25_connect(struct socket *sock,
>   
>   	lock_sock(sk);
>   
> +	ax25 = sk_to_ax25(sk);
> +
>   	/* deal with restarts */
>   	if (sock->state == SS_CONNECTING) {
>   		switch (sk->sk_state) {
