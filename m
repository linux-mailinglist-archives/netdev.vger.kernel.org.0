Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9EC31F89F
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhBSLuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 06:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBSLuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 06:50:15 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C856EC061756;
        Fri, 19 Feb 2021 03:49:34 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id n4so8012745wrx.1;
        Fri, 19 Feb 2021 03:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lxdNTkl+ucRRLsCAbxjBx99ffC/6HQIfXfLaqbYqRWY=;
        b=GSb36TUJAd/yO69uWc/Ff8phxLQcJnVIPE4h7/ZysT8FVKEuPy0T4kVu8JX0/x8UKM
         tq47OgTWpOpaDcpQ6NCCyn7p8TCzgaTXPx4Na6RUl3fOFMo5O/cG/5qRRDc1oJ6lqpdR
         3bvy/z5QBO/epGX1ZieMj60e80dj5XbnIInmjfOy6Iig5DUj1RWrBTkXAF4cYVNb4LXp
         O5crEILhvqVmbhs3Hb3wgpLPmVMzckdenBRnAlxDKnxN5NMjktbbKloMucfYkRQCpI2H
         J7o4dTMxGMaE13Yg2NNFBue1wSxlyOps63NIUZp6L443h8KoFYH5MLjuUMTh8Z7G0Wel
         FO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lxdNTkl+ucRRLsCAbxjBx99ffC/6HQIfXfLaqbYqRWY=;
        b=Cjyn3cA1+HDQb7jjBA+Oe1XCr9YOKJbBNjgchK5I7H1haPeBD0UAvKSJSOBdFYRWvF
         sH1YZhbKqYOsaw32fRpqO3nFxwiLqrGhjbaFtqMH/seaBkIXZtzxncSIzdsScU/L/X3P
         vZtYqImp7c4Nxjb1B3zhX/qhiiU8bjP84P4D36jYmvSJCjFX0fWrJiwUs4YsV7ozjUHy
         S+5QUjb0tzWIz65Fr4cXrpUX9L6UmvlzHGP7adbnvvlJsyxkkFv6v4CrfAyQYr8xT4KD
         MtRTWOzevEu67qgwUjxEVfheotOnu8tDELcvnD28d4g1AOiziTIcmwt8nsdUge6B34ZW
         UAUg==
X-Gm-Message-State: AOAM531o6jbKyWk/kgYWZef1YtAkDuIsmF6iW3qw8N/DnF4hc4yfp+Zn
        33UoYDPf6dHgCrRz8hhuL5Y=
X-Google-Smtp-Source: ABdhPJw514fqMDT7N//a1S6OcenC4CqhU8PFxOOpzHh7xoeKQ+Dzbr6eEBDI1Tc2q9KH3LJ32306aA==
X-Received: by 2002:adf:e4c3:: with SMTP id v3mr9061999wrm.210.1613735373566;
        Fri, 19 Feb 2021 03:49:33 -0800 (PST)
Received: from [192.168.1.101] ([37.170.232.180])
        by smtp.gmail.com with ESMTPSA id n16sm7472682wrm.23.2021.02.19.03.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 03:49:32 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 1/4] net: add SO_NETNS_COOKIE socket option
To:     Lorenz Bauer <lmb@cloudflare.com>, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
References: <20210219095149.50346-1-lmb@cloudflare.com>
 <20210219095149.50346-2-lmb@cloudflare.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <00f63863-34ae-aa25-6a36-376db62de510@gmail.com>
Date:   Fri, 19 Feb 2021 12:49:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210219095149.50346-2-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/19/21 10:51 AM, Lorenz Bauer wrote:
> We need to distinguish which network namespace a socket belongs to.
> BPF has the useful bpf_get_netns_cookie helper for this, but accessing
> it from user space isn't possible. Add a read-only socket option that
> returns the netns cookie, similar to SO_COOKIE. If network namespaces
> are disabled, SO_NETNS_COOKIE returns the cookie of init_net.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---


> diff --git a/net/core/sock.c b/net/core/sock.c
> index 0ed98f20448a..de4644aeb58d 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1614,6 +1614,17 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>  		v.val = sk->sk_bound_dev_if;
>  		break;
>  
> +	case SO_NETNS_COOKIE:
> +		lv = sizeof(u64);
> +		if (len < lv)
> +			return -EINVAL;

	if (len != lv)
		return -EINVAL;

(There is no reason to support bigger value before at least hundred years)

> +#ifdef CONFIG_NET_NS
> +		v.val64 = sock_net(sk)->net_cookie;
> +#else
> +		v.val64 = init_net.net_cookie;
> +#endif
> +		break;
> +

Why using this ugly #ifdef ?

The following should work just fine, even if CONFIG_NET_NS is not set.

v.val64 = sock_net(sk)->net_cookie;


	

>  	default:
>  		/* We implement the SO_SNDLOWAT etc to not be settable
>  		 * (1003.1g 7).
> 
