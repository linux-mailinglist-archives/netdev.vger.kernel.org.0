Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B003636F8
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 19:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhDRRSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 13:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhDRRSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 13:18:51 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC234C06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 10:18:22 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 5-20020a9d09050000b029029432d8d8c5so4489949otp.11
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 10:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jF9fBt2nov031f6xnBGBm3xWArwyDa+sNYURniHyNmY=;
        b=b59q34nfYRmN36FtH5k/GIPX9ePX5Qo0bGaqTPqQ87b8+HeIWTY5XqQpi3ywBgT1b9
         J3EYYWrvK3OowlKYA0t8l7LyK43RrVbUaOhFFHdbC0QhW5N/7qU2nM2wK2jyGrgOApMB
         ekyexPnPwhrhc0xkxE3V0TmBNghTrq38ZKP9OrxpzAk5TiSH0axvsAXl35a+Tzzoxrtj
         jLrFaCN1HtX53PDIg8k90dSNRqMAWK5VymsHxFYAAmA+DvnHXvc67Wsyvu4g8dHwb2+c
         djR+aK3PZKf0Rm3w1bW4HPcHT3wcgk/qsf8secDADr1+CQcTtI1llz5JC3LU0GfUCjUh
         Jc8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jF9fBt2nov031f6xnBGBm3xWArwyDa+sNYURniHyNmY=;
        b=l53GTMVpvPRGUiuw77gdpFcGyddQxZEBnl9BlgRqK/AZ+KF28UDITE7Us8gbL1wbIz
         22/w+CVl1krCe63yJHYEzllxqfTPj1W4bUq1zDdspKCNK13q3hSAcDaT8+LbV58y+Md2
         ir4QTMyZY7aRXG3ziO+z1CY0RbBtGfJclZgmKjbm10fzBfMd0oKXbXkEPMUzcwEb3oCp
         35HlUqVOesh7ryWWq68//914BaVjpChVEg+TcZPcG+q5uZ3UJKVJ7iPD4H4sJ3e/nyTZ
         zxaFg8x2BYTyQUSG9Z0LwYcZy1BEwmqybNMa3lxtpMskjcVuR6VVrJ0E5gRaW1kKIeOK
         dXew==
X-Gm-Message-State: AOAM531WEev+EF70GaOxXQlVzBsCL4rp/jLCMClkhxqhGxAs5DGhlwQa
        NxY3MxKVwnA+TglpkGzn1jqE0sIaR1Y=
X-Google-Smtp-Source: ABdhPJymnUo6Bq0pyGolilfwj6h3TP0bZSc402S82dqas7eiC3wODkqPOpvFTdzC8kO0YvxgB92L9g==
X-Received: by 2002:a9d:224f:: with SMTP id o73mr7362843ota.323.1618766302236;
        Sun, 18 Apr 2021 10:18:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.41.12])
        by smtp.googlemail.com with ESMTPSA id a18sm932155oop.28.2021.04.18.10.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 10:18:21 -0700 (PDT)
Subject: Re: [PATCH iproute2] ip: drop 2-char command assumption
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20210418034958.505267-1-Tony.Ambardar@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9008a711-be95-caf7-5c56-dad5450e8f5c@gmail.com>
Date:   Sun, 18 Apr 2021 10:18:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210418034958.505267-1-Tony.Ambardar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/21 8:49 PM, Tony Ambardar wrote:
> The 'ip' utility hardcodes the assumption of being a 2-char command, where
> any follow-on characters are passed as an argument:
> 
>   $ ./ip-full help
>   Object "-full" is unknown, try "ip help".
> 
> This confusing behaviour isn't seen with 'tc' for example, and was added in
> a 2005 commit without documentation. It was noticed during testing of 'ip'
> variants built/packaged with different feature sets (e.g. w/o BPF support).
> 
> Drop the related code.
> 
> Fixes: 351efcde4e62 ("Update header files to 2.6.14")
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
>  ip/ip.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/ip/ip.c b/ip/ip.c
> index 4cf09fc3..631ce903 100644
> --- a/ip/ip.c
> +++ b/ip/ip.c
> @@ -313,9 +313,6 @@ int main(int argc, char **argv)
>  
>  	rtnl_set_strict_dump(&rth);
>  
> -	if (strlen(basename) > 2)
> -		return do_cmd(basename+2, argc, argv);
> -
>  	if (argc > 1)
>  		return do_cmd(argv[1], argc-1, argv+1);
>  
> 

popular change request lately. As I responded to Matteo in January:

This has been around for too long to just remove it. How about adding an
option to do_cmd that this appears to be guess based on basename? If the
guess is wrong, fallback to the next do_cmd.

