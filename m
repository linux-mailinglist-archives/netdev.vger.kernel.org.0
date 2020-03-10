Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001C4180514
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgCJRnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:43:10 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45075 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgCJRnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:43:10 -0400
Received: by mail-qk1-f193.google.com with SMTP id c145so7762670qke.12
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pe3/JvHbo7Zx1xKecHG7ANdwmDduLLxjtXBzh6H6Tqc=;
        b=YGqwDo2KOrOV6oFw6zwV+QCDD51r1/LmR53jZ5pDgBoSlyptLr/KNgCZgujh8B0xMt
         ExLeZWaj15Mz1LDE9CrtN/lBS6mMedAJFbhJzCgGUyB5JQ5SYxMaQRtHv01tPbDSMF0t
         QucX65b/i40jdsRLXgxHtHSThK7HAzqGHo/C+gYMrXTPB8W9b+O1hde6zsaBGjCun9SX
         l3oRNSZFE2B8SiXJKdywzhY9SIXFqx64UfOhd8WLiOGsREljsg1JN6ETMCGoSeG9SYSm
         SwKYy6TNEoIHgBAzsAyIAfUEEXf2Tim0RKrhj02bKxGCdbXpvBWzvgg/GH39ZkQVPREl
         2AXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pe3/JvHbo7Zx1xKecHG7ANdwmDduLLxjtXBzh6H6Tqc=;
        b=BB52VAn4e9VFJEcGYQiXlj6ldoYcOvYHeoO4C58sRzZ5M/bVt4FQoHumll+ND5AXUn
         nvw/aCYGi8sEniFa0AWdc0EBGimtXIxy+2EPIWrkNaKBP5FmVr2ZGLu1sgB9hPHcq7C7
         EdWAJm7H13aqaJPWKornkk/mnf/22/N1rwXkRqjywFzDLdPmuPayl6m34b4Cd9joD2b7
         gNQOsrbx+n5xiw2B/hWPuOWNRTHaJ5y/Tv+9g5zVbY0v5rGOHfA5H2R9+Ww2g64rc6RK
         H3SQp+zjPEScclpwMqohuGYPnXagicF+g0tkNE+T978bQaL6L29HwX4+PIdK053x3vi5
         BKgg==
X-Gm-Message-State: ANhLgQ0uprqkft/Zmc2bxXNNg+QKAVqdmOCfF+f2uuAI1hFRf/jXx3wf
        u7Ta4JEkER7z5a6WNZDfC7Kh6LJQ
X-Google-Smtp-Source: ADFU+vvKMklmg4ZB2Kapx84fXZXMOFqFA6AQeBkxgGtRvKixPkvrJqOQD0tmhqbVsjYfgLhg9wtrFQ==
X-Received: by 2002:a37:a68e:: with SMTP id p136mr21188010qke.7.1583862189417;
        Tue, 10 Mar 2020 10:43:09 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b876:5d04:c7e4:4480? ([2601:282:803:7700:b876:5d04:c7e4:4480])
        by smtp.googlemail.com with ESMTPSA id z18sm200034qtz.77.2020.03.10.10.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 10:43:08 -0700 (PDT)
Subject: Re: [PATCH iproute2] nexthop: fix error reporting in filter dump
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <07545342394d8a8477f81ecbc1909079bfeeb78e.1583842365.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1865ee5b-2339-da2a-7c33-7cf3cac98213@gmail.com>
Date:   Tue, 10 Mar 2020 11:43:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <07545342394d8a8477f81ecbc1909079bfeeb78e.1583842365.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/20 6:15 AM, Andrea Claudi wrote:
> nh_dump_filter is missing a return value check in two cases.
> Fix this simply adding an assignment to the proper variable.
> 
> Fixes: 63df8e8543b03 ("Add support for nexthop objects")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  ip/ipnexthop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index 9f860c8cea251..99f89630ed189 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -59,13 +59,13 @@ static int nh_dump_filter(struct nlmsghdr *nlh, int reqlen)
>  	}
>  
>  	if (filter.groups) {
> -		addattr_l(nlh, reqlen, NHA_GROUPS, NULL, 0);
> +		err = addattr_l(nlh, reqlen, NHA_GROUPS, NULL, 0);
>  		if (err)
>  			return err;
>  	}
>  
>  	if (filter.master) {
> -		addattr32(nlh, reqlen, NHA_MASTER, filter.master);
> +		err = addattr32(nlh, reqlen, NHA_MASTER, filter.master);
>  		if (err)
>  			return err;
>  	}
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
