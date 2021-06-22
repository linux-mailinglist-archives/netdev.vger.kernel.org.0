Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4783AFA94
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 03:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFVB0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 21:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhFVB0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 21:26:03 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2747BC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 18:23:48 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id h9so9507144oih.4
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 18:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lhZYntEEuYqUA133fAaedO2k+Cwq0lDVg5QX0PUDcEM=;
        b=NT/dbl6v2tLR2lbFI8TRniJXb7LoCHkNZqbRr4t6woGYuBdJKt8U5AWtDj5RL2jfuv
         ioqegbFnAZRZl89vSUbAw6WTqtd/Ou/Q+LlG9xbvzCspqgdcTdnnmLEzMx+bJl0C4DI1
         0GRh68k3rNgpIXCLFRdjcpLjmydFGTJWBO+eV+20kMAqRXBAL3cs9S18EK3vJZdlmN4E
         xV3zRniZWh8dqzEmNI1qa+L4oWVqh6Tq00nAF77/B6BMueeH8ES3rUtXS8tH31Pmi/Rs
         GbArTs/g3MNdMEZpaXMOHQNUQsmkedvUwstHYVfp6PU7tFDKq5004+Idl4808yb/I8X8
         +RBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lhZYntEEuYqUA133fAaedO2k+Cwq0lDVg5QX0PUDcEM=;
        b=ZZo0C8CIxMoh/hmgqGgHjqyThmRx7ORzvkzWAvPP9hP0//9JQw7HX6GaSfhAQpW3nT
         mVHqnv/efSDVaGy1lkU+iX9CH1YVM6fQARYXb9cZe5I2TRZPl8jMLcF4/rLWv8w7Eh1Y
         sC/zp4YLnNIEOO45HAGLeGZ0AiETFIK86z/pv4HdOwukx3zvdzL8FM4+eRv+oUoxArvc
         pJfCQA7Vbwz1K9WTO66ZRgehu98vYYvqH6o8dLp0QLFBWoRbonKh6IidTFEnk/SDGXSy
         mmf1bIs9Sv5MsofiwmBBiYtz7hbasPHB6jHPyKD8BE/a1IK/kUC6ekvuf6HFT0sbwxw0
         Penw==
X-Gm-Message-State: AOAM530z1zRuHJwtHqlUL0mwVdbiRJsMoAVd9umXfqBWbCWcD03mpKw+
        IU9Fu9mBW3eG4zxpGwLvUdZFLAUemaQ=
X-Google-Smtp-Source: ABdhPJz200JtJaWBFj+GXiR1QeIaainz8Va2TuayVLaalcrKO1neMJzLrsAohX+U7a+t5Nj7UBUUJg==
X-Received: by 2002:aca:b343:: with SMTP id c64mr1134993oif.137.1624325027410;
        Mon, 21 Jun 2021 18:23:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id w69sm3997167oia.22.2021.06.21.18.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 18:23:47 -0700 (PDT)
Subject: Re: [PATCH] net/ipv4: swap flow ports when validating source
To:     Wang Shanker <shankerwangmiao@gmail.com>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
References: <1B652E0A-2749-4B75-BC6D-2DAE2A4555A8@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a08932fe-789d-3b38-3d92-e00225a8cf9f@gmail.com>
Date:   Mon, 21 Jun 2021 19:23:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1B652E0A-2749-4B75-BC6D-2DAE2A4555A8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/21 9:17 AM, Wang Shanker wrote:
> When doing source address validation, the flowi4 struct used for
> fib_lookup should be in the reverse direction to the given skb.
> fl4_dport and fl4_sport returned by fib4_rules_early_flow_dissect
> should thus be swapped.
> 
> Fixes: 5a847a6 ("net/ipv4: Initialize proto and ports in flow struct")

I believe the hash should be 12 chars: 5a847a6e1477

> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
> ---
>  net/ipv4/fib_frontend.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 84bb707bd88d..647bceab56c2 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -371,6 +371,8 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>  		fl4.flowi4_proto = 0;
>  		fl4.fl4_sport = 0;
>  		fl4.fl4_dport = 0;
> +	} else {
> +		swap(fl4.fl4_sport, fl4.fl4_dport);
>  	}
>  
>  	if (fib_lookup(net, &fl4, &res, 0))
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
