Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24CE103DEC
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 16:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbfKTPEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 10:04:48 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:40300 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728864AbfKTPEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 10:04:47 -0500
Received: by mail-il1-f193.google.com with SMTP id d83so23672739ilk.7
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 07:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aISrEo5k+x1Q9mfuny3YeA/iQnEvA94/66p4yLR91t4=;
        b=laCJHFT/ZTA2dm5cmwW/ymKoAHfzgv3YMDt+DObllvbMtyDqg4g17Jdec7c6s4I2D6
         XG165SmxEN4yVXqduBhTOW1oTTHtup2xRYbe8rgTSugh1a9gVyuCVmu4jrbLEQMriNSW
         KEEpwFT5M3+hnNcobwJewefUsw8UEdHYNDGfuZHcsQMY79OgRdG43F99zSyO2yAo+iR0
         5LXs+riRd+6U4iV7fI0uA1LowQp1/fOWnAzoTamzNwsKYh5STcPWeMjuwiXKGjQNuvGt
         DWrNcXuzg8p053U7SjWfZTI43vmyPzkuvkEi+06mMQMUnzn0hBY3QTbB6JUdI+UQ01ON
         4mtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aISrEo5k+x1Q9mfuny3YeA/iQnEvA94/66p4yLR91t4=;
        b=LWguVKfL3h3DbdTDE7z3/fxSz29Mxy+Fepn8Z10rwlCLWDMtU9l2io9Swj8ZCGwS4x
         i2JymE2HBDImpCziH/gCsT5x/2/G2lxn9MEIoZvogFjCdQ33JnqJwJto9u98Xrca7Lkk
         RPqAbORnaLPqLrEWrPSmxTWLWPiXazbO2imZ8CVns7eqR/1407fIpyXfEaRawKBLgpfX
         U83Ycbu6A0qommozAHPkDopEVM4SlL1hxSP2aJAZYeeBxjZTX1ALrHpttMf8LseRWyWd
         p5JY4QIaxynUTwz7tpTyHCCRn10vhjHc6DR/f1qPas7MTuLBsfp4K/kE2UAZyEXbui0M
         hvGg==
X-Gm-Message-State: APjAAAWfRpSxF50Of6ovFM8G39AGNEf23/pLrk0uKMiIarMotrVac+Mj
        fuUqJ5+w0VE7zGkSpScCUns=
X-Google-Smtp-Source: APXvYqxP/giCVxyasnxe4mJi/RXxnpk5S7azM6RZ0lF32Ji3D6ZUmh+pvc61BZVtR7tcfFNvp5xieQ==
X-Received: by 2002:a92:dd0f:: with SMTP id n15mr3977407ilm.146.1574262286995;
        Wed, 20 Nov 2019 07:04:46 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:d52e:b788:c6dc:7675])
        by smtp.googlemail.com with ESMTPSA id r17sm6630681ill.19.2019.11.20.07.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 07:04:46 -0800 (PST)
Subject: Re: [PATCH net] ipv6/route: return if there is no fib_nh_gw_family
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
References: <20191120073906.15258-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7c2624e5-57f2-5aaf-0290-dad7cff244b4@gmail.com>
Date:   Wed, 20 Nov 2019 08:04:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191120073906.15258-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 12:39 AM, Hangbin Liu wrote:
> Previously we will return directly if (!rt || !rt->fib6_nh.fib_nh_gw_family)
> in function rt6_probe(), but after commit cc3a86c802f0
> ("ipv6: Change rt6_probe to take a fib6_nh"), the logic changed to
> return if there is fib_nh_gw_family.
> 
> Fixes: cc3a86c802f0 ("ipv6: Change rt6_probe to take a fib6_nh")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv6/route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index e60bf8e7dd1a..3f83ea851ebf 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -634,7 +634,7 @@ static void rt6_probe(struct fib6_nh *fib6_nh)
>  	 * Router Reachability Probe MUST be rate-limited
>  	 * to no more than one per minute.
>  	 */
> -	if (fib6_nh->fib_nh_gw_family)
> +	if (!fib6_nh->fib_nh_gw_family)
>  		return;
>  
>  	nh_gw = &fib6_nh->fib_nh_gw6;
> 

good catch. Thanks for the patch.

Reviewed-by: David Ahern <dsahern@gmail.com>
