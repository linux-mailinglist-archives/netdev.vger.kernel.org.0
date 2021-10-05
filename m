Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D2D422A97
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 16:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbhJEOPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 10:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236530AbhJEOPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 10:15:09 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D48C0617BD
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 07:12:30 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id n63so1067030oif.7
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 07:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aBBN7qqUrcyjGDZpTsmnzdTjBRLP6HzQ12u2GYdg6iM=;
        b=Q31ck09gUx3R3m0pjgUPrVFt6mg1sZyx3vt+FHeJ3zw1EtymO/8ao7UlLVr0FSfram
         d8o8BEmpfxqMosANHpMKwAkFrDc2v8rI3HPsfaLIxAtw63o+JLZFMZvEPWgPDJiGbi/E
         tcmye/ZIetv6Zp5QnEsrc3Wka+R2cyLfm7XoDSq0Rausrkzpp1VOuSuEfXVvlgMEiF28
         312iXdiyUKjjMhQjAKs41OTuy1o2m3TZ42cbIfIPaZvIjiWmw66encYs4J41EBwk8XkS
         6VyYe+2kQ3bm6wstNrpYrVjZuQGdJnjbbVga7FkBhnFQr/rL5ItfdmYZAU7G8cDVou5G
         T0ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aBBN7qqUrcyjGDZpTsmnzdTjBRLP6HzQ12u2GYdg6iM=;
        b=Byrwb1BBC2b2xAMMuXkog973OgdVHBMYQg0HsuDW0tzzYxDcHxmyDYxIKvykG6zews
         0ltEUnyFkibp+/l9ZtqkV0GHCuEhBLQPtxvXgGP3gSslcGQ1Oxh30EYy4AfT33h4hsGQ
         gCx2lNnDneSgZXsrVHnUIC5VD6boKA+70XxUtDBI4W5yIPfkioFghCH0ne70SaU23I6b
         mPgsWNjvtpHl4mkANjaexmsDA7Pgk9qhxDDmQu2b0JY71dw71kps48z6yhMoKTwgZv8N
         rEbRE2kSc+YH0504GQTYDQFJmc+2BahJZdbOzAjKRKefAMVHja/k5sQ6N22lNabkrcEw
         MhbQ==
X-Gm-Message-State: AOAM531evbUK2+SZaWJ0kb8GbQCMEY5gkDGyNSkflh3yKGESHFwIGZHc
        d+ICc3odt4r4ANGuT6A6W5FZrMTrzKp/dQ==
X-Google-Smtp-Source: ABdhPJxKfqJCGkanFrw5BSasj9y6xQSsfSA+tQ0ukMXLEGoUffhtxHzVpoIcC4UVGzCK7wRV43wIZA==
X-Received: by 2002:aca:bec2:: with SMTP id o185mr2725094oif.30.1633443148680;
        Tue, 05 Oct 2021 07:12:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id i25sm3586327oto.26.2021.10.05.07.12.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 07:12:28 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/2] Add support for IOAM encap modes
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, stephen@networkplumber.org
References: <20211004130651.13571-1-justin.iurman@uliege.be>
 <20211004130651.13571-2-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a80c8fba-bf66-93ef-c54e-6648b3522e28@gmail.com>
Date:   Tue, 5 Oct 2021 08:12:27 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004130651.13571-2-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 7:06 AM, Justin Iurman wrote:
> diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
> index 218d5086..3641f9ef 100644
> --- a/ip/iproute_lwtunnel.c
> +++ b/ip/iproute_lwtunnel.c
> @@ -210,16 +210,54 @@ static void print_encap_rpl(FILE *fp, struct rtattr *encap)
>  	print_rpl_srh(fp, srh);
>  }
>  
> +static const char *ioam6_mode_types[] = {

I think you want to declare this of size IOAM6_IPTUNNEL_MODE_MAX + 1

> +	[IOAM6_IPTUNNEL_MODE_INLINE]	= "inline",
> +	[IOAM6_IPTUNNEL_MODE_ENCAP]	= "encap",
> +	[IOAM6_IPTUNNEL_MODE_AUTO]	= "auto",
> +};
> +
> +static const char *format_ioam6mode_type(int mode)
> +{
> +	if (mode < IOAM6_IPTUNNEL_MODE_MIN ||
> +	    mode > IOAM6_IPTUNNEL_MODE_MAX ||
> +	    !ioam6_mode_types[mode])

otherwise this check is not sufficient.

> +		return "<unknown>";
> +
> +	return ioam6_mode_types[mode];
> +}
> +

