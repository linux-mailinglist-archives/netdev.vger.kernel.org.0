Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5581549330D
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 03:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348789AbiASCmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 21:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344650AbiASCmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 21:42:14 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDAACC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:42:13 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id r16so946709ile.8
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T1Oh3Xkv/O3MoCF/GDqGhJzFmJNlVREBKg7oTz3MHeg=;
        b=B6QjKwHsjaQdmenARHhOuneIJGKivClxbLjzS1yaZFUx93rEQ3Dso2nrQwfZbcJKvg
         oWeizxQR0WRh1Ii5bk/eX+NgjjvmA0XDLlrMdrxMAlVA+OmbKEG4SpcMKQZn/+7uwgUF
         7h9ZemqHiBicRDn7umwilUapY7q35aPg0yiZrVUtpYaxzslpLzXsaJqhZ3f5kj1o59dy
         QMVb4dHQZbhjEca+qyQRrbIM12A6dlIDjEdEPSQzmtX9j7RrjrRvxsgt2enLyLXAZogT
         nKe9/barnvKYy8GEVzBwZvfd+TqTfBvPi0LkC//K/y6HgdFG0s3+snrgdv849ZYgCpto
         ufvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T1Oh3Xkv/O3MoCF/GDqGhJzFmJNlVREBKg7oTz3MHeg=;
        b=xEgdoHFzC4I/aYiwprjlz40EU6Xckx2j4wwn3luA7RlofYLJgOkw9WqQp08czEQvyV
         Px/+7xHdzsbzp1WmtzUWxkdG6EQAVSQlElaRPMPHYDiUXkmCjZZhUN7ckz3r8jHZ/FJO
         fAA+orbuQS0iKMBpBbJtLo8cJp/QwtxWQz5VhdHzfqVtR2dFzzIze7bC8z0osEhLrzDI
         OYEj9beqaCkFeumnXno6JB3nOyesrRno4qzIz4005RS8U620U5xYjxFBrFr2xXaiR+qm
         ebmbJHEhnS8J1aKfmGdbANtKPbmGB5P97UqYpZfoAunpH8rRnFXaX+nmdX4uCS9zwyyt
         N+gw==
X-Gm-Message-State: AOAM531nxoQim5+tZnfzYlrGJAmvHRZ4gWwU4PCx2AzWaG2oWiAs+CMx
        YCMTZ1tOU8ooGmkSnS0Sc5HmUcefwGQ=
X-Google-Smtp-Source: ABdhPJy5nswxS0UqEQId4fYFfCxYnZN4CvUpsI6v8DjmKwn8N51YHVgN63YtAaJEB1uo2sPN4xkgMA==
X-Received: by 2002:a05:6e02:b2f:: with SMTP id e15mr15618396ilu.110.1642560133413;
        Tue, 18 Jan 2022 18:42:13 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id x16sm8124508iol.33.2022.01.18.18.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 18:42:12 -0800 (PST)
Message-ID: <1d570c92-8acc-fd82-ce8b-f23b2ce47a9f@gmail.com>
Date:   Tue, 18 Jan 2022 19:42:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH net 2/2] ipv4: add net_hash_mix() dispersion to
 fib_info_laddrhash keys
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220118204646.3977185-1-eric.dumazet@gmail.com>
 <20220118204646.3977185-3-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220118204646.3977185-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 1:46 PM, Eric Dumazet wrote:
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 9813949da10493de36b9db797b6a5d94fd9bd3b1..7971889fc0fe3690e47931c39e6a8f8e0fb1d31f 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -52,6 +52,7 @@ static DEFINE_SPINLOCK(fib_info_lock);
>  static struct hlist_head *fib_info_hash;
>  static struct hlist_head *fib_info_laddrhash;
>  static unsigned int fib_info_hash_size;
> +static unsigned int fib_info_hash_bits;
>  static unsigned int fib_info_cnt;
>  
>  #define DEVINDEX_HASHBITS 8
> @@ -1247,13 +1248,9 @@ int fib_check_nh(struct net *net, struct fib_nh *nh, u32 table, u8 scope,
>  	return err;
>  }
>  
> -static inline unsigned int fib_laddr_hashfn(__be32 val)
> +static inline unsigned int fib_laddr_hashfn(const struct net *net, __be32 val)
>  {
> -	unsigned int mask = (fib_info_hash_size - 1);
> -
> -	return ((__force u32)val ^
> -		((__force u32)val >> 7) ^
> -		((__force u32)val >> 14)) & mask;
> +	return hash_32(net_hash_mix(net) ^ (__force u32)val, fib_info_hash_bits);
>  }
>  
>  static struct hlist_head *fib_info_hash_alloc(int bytes)

for consistency, make this hashfn and bucket lookup similar to
fib_devindex_hashfn and fib_info_devhash_bucket.


