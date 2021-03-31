Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9015350453
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbhCaQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhCaQRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 12:17:31 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5304FC061574;
        Wed, 31 Mar 2021 09:17:31 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k8so20263524wrc.3;
        Wed, 31 Mar 2021 09:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+LUmV3vHkxiR9TrSqFPXgZ/3haa7mVuzoeyXiIzlD/Q=;
        b=ovrd3VFqc8rvz+5dxr735rvsgWHJzDItSqV9k+xNbrZhCW7vWWTLrdfzV7WfjIgfuL
         PN6P/kEUSWNECjQXzYsDaQXiSenRgeEHwn38FcbZXyyF7QW9BSmd7GgHaF2cRCYhlfMW
         QVROuNQHqT6dlxPcCB5JOwNKsOSgRM63++G2cxBYTJu8xppgvl1GqLVFZMmz8qIGr/aL
         J670eO545rzqtycws6Fw7zbpr68dsN0tsHMljVRK07eNUqvyc4zz7QZk+T9Gwaa0XBLb
         TqBa/OzZFMDH5fllVO14NB0mnFw9cvnyWqQOOvIxGMiVtuK9p4x7bhLunOJ0VlBprn7r
         J2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+LUmV3vHkxiR9TrSqFPXgZ/3haa7mVuzoeyXiIzlD/Q=;
        b=pFJVFiAOGamnbN7QLJ/0svHi9fPrWT7MEZl8kDM33SNkJ0KMSYd8A9hXpKNEhCwM5D
         m5Gg1nHrax8zlY5VRpnxTDI4T9VweSaPsj9uCwzGDwsJ8uYW5SHJ+dJC/Kp2YL6Uqpbj
         idvS6Xgdg+SNA7HYpOTML7JYYnRinavQ+mqVC2A0TAMuoE+3/GzAzmvxtPI+5lS6IqgZ
         DIQC+3trMzviVXypCPodZACvyptIqDhYjoDxYybgvxK5SoJy4fTax0OMDSO6FsUA48rp
         tV/IBVO+NlUUzzNRxef4lQ8xQxV/99mGBkUIdFF69ZmijB0OwNlnLEtwTDvA5bHXrlQt
         FiCQ==
X-Gm-Message-State: AOAM5311lkT7vIdHTnE+pKgY3MrTlxOwLqfGwJFGCJpunrtMtmL1XeH1
        O0OpRZWvPBzm5j0RBw0q0vaoc0fdRbY=
X-Google-Smtp-Source: ABdhPJzTCspDm2cy4Z3LxFOSjp9owGYeUOfwlhWKdsHMJzWHexc9oB5dTjb5l7fk4gKsSdlHGgmbow==
X-Received: by 2002:a05:6000:18f:: with SMTP id p15mr4661255wrx.23.1617207449817;
        Wed, 31 Mar 2021 09:17:29 -0700 (PDT)
Received: from [192.168.1.101] ([37.172.182.222])
        by smtp.gmail.com with ESMTPSA id w131sm5137657wmb.8.2021.03.31.09.17.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 09:17:29 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.11 10/38] net: correct sk_acceptq_is_full()
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     liuyacan <yacanliu@163.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210329222133.2382393-1-sashal@kernel.org>
 <20210329222133.2382393-10-sashal@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e08f40b5-7f5b-0714-dfab-f24ed7f348fc@gmail.com>
Date:   Wed, 31 Mar 2021 18:17:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210329222133.2382393-10-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/30/21 12:21 AM, Sasha Levin wrote:
> From: liuyacan <yacanliu@163.com>
> 
> [ Upstream commit f211ac154577ec9ccf07c15f18a6abf0d9bdb4ab ]
> 
> The "backlog" argument in listen() specifies
> the maximom length of pending connections,
> so the accept queue should be considered full
> if there are exactly "backlog" elements.
> 
> Signed-off-by: liuyacan <yacanliu@163.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  include/net/sock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 129d200bccb4..a95f38a4b8c6 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -936,7 +936,7 @@ static inline void sk_acceptq_added(struct sock *sk)
>  
>  static inline bool sk_acceptq_is_full(const struct sock *sk)
>  {
> -	return READ_ONCE(sk->sk_ack_backlog) > READ_ONCE(sk->sk_max_ack_backlog);
> +	return READ_ONCE(sk->sk_ack_backlog) >= READ_ONCE(sk->sk_max_ack_backlog);
>  }
>  
>  /*
> 


????

I have not seen this patch going in our trees.

First, there was no Fixes: tag, so this is quite unfortunate.

Second, we already had such wrong patches in the past.

Please look at commits
64a146513f8f12ba204b7bf5cb7e9505594ead42 [NET]: Revert incorrect accept queue backlog changes.
8488df894d05d6fa41c2bd298c335f944bb0e401 [NET]: Fix bugs in "Whether sock accept queue is full" checking

Please revert  this patch, thanks !

