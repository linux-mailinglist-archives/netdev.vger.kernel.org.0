Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65A7301DE3
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbhAXR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 12:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbhAXR1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 12:27:35 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF2C061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:26:55 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id g69so11448813oib.12
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dgLDmXp70iNQKKUTna+wkUgVQQhcTluo+11lcvqoR08=;
        b=gEdprt1Usu6DFEiDv5xn8upAd0WtkWD3ORYHH82Fun9He3uEoB9CSOFjdhp6M0OIM0
         45RQ/OCLP64EGZJLzpkdAPYgyFip9MFXcDq2ok4xJX71khtvl5emedcQvdB37hVi5xEX
         9yTkx3B1h27rH8LqrvlMIhJteuiOU0VYyFfrcJqdkL3fhziVp8aEB6+ieG5Jf6pc5OlV
         l9XMA7UsbWSfWB2wgLT0wqb1Wv4BOSGFpxit2Tdt5YAi/o9hcN2qWrBHNzgYAUntTEKX
         E9rg3pS+UcaTJjN1rbzXPVx4JKwBC29DVOy97jVjTVUYGH/k9SPEusloW4PjMQQRfSU1
         HYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dgLDmXp70iNQKKUTna+wkUgVQQhcTluo+11lcvqoR08=;
        b=Rj4/avP/8Ak6durRXAdCDwLq7pNSXx6DT3t+T3PHTkvRD9P2wOk/yERqo9zIqg9mnL
         SM9dCiW19thb8fNyYap4L/oWA+d8sa0b7kvCnln1o7aJTX9DOMkmB6DGOD2odd0Qp6Vr
         mNL4hiXfNX25K/1ogyBpM8umbvie8YvfLOp/iq8ofY5y6YewakqRJ3nrMbhk/3ZCMLau
         nRrH8bx+3FKZXooNaatnJPHb285mYebBYYz0QRvkzlxfl4ZEJv+9uFSB1hVk5Y0j9f7X
         xw3My5S0ymw+ldkgGluF7HAwdXv8WXQnviMxofjBV1ronsgKLVLjrcoZjVAb7t4+eYGh
         p5WQ==
X-Gm-Message-State: AOAM5334Jl1H2/GPB/C+sZH06lJCdktGxPwbiFy7Bul7iPnlbqky7A59
        VNsJac8PJobMbzq5Kd46nWWhJzr8KuE=
X-Google-Smtp-Source: ABdhPJwmfBtuZMbLY0/pe1I7o7yB08NOrubLYuY6zVZ035ixvjaLOpHZ2Xf4o6CoX9fZEglFLYhzEw==
X-Received: by 2002:aca:d7c6:: with SMTP id o189mr104926oig.144.1611509214303;
        Sun, 24 Jan 2021 09:26:54 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id j17sm2975026otj.52.2021.01.24.09.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 09:26:53 -0800 (PST)
Subject: Re: [PATCH iproute2] iproute get: force rtm_dst_len to 32/128
To:     Luca Boccassi <bluca@debian.org>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210124155347.61959-1-bluca@debian.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5a165b08-9394-6c64-efe7-2f141b498b76@gmail.com>
Date:   Sun, 24 Jan 2021 10:26:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210124155347.61959-1-bluca@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/21 8:53 AM, Luca Boccassi wrote:
> Since NETLINK_GET_STRICT_CHK was enabled, the kernel rejects commands
> that pass a prefix length, eg:
> 
>  ip route get `1.0.0.0/1
>   Error: ipv4: Invalid values in header for route get request.
>  ip route get 0.0.0.0/0
>   Error: ipv4: rtm_src_len and rtm_dst_len must be 32 for IPv4

Those are not the best responses from the kernel for the mask setting. I
should have been clearer about src and dst masks.

> 
> Since there's no point in setting a rtm_dst_len that we know is going
> to be rejected, just force it to the right value if it's passed on
> the command line.
> 
> Bug-Debian: https://bugs.debian.org/944730
> Reported-By: Clément 'wxcafé' Hertling <wxcafe@wxcafe.net>
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
> As mentioned by David on:
> 
> https://www.spinics.net/lists/netdev/msg624125.html
> 
>  ip/iproute.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/ip/iproute.c b/ip/iproute.c
> index ebb5f160..3646d531 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -2069,7 +2069,12 @@ static int iproute_get(int argc, char **argv)
>  			if (addr.bytelen)
>  				addattr_l(&req.n, sizeof(req),
>  					  RTA_DST, &addr.data, addr.bytelen);
> -			req.r.rtm_dst_len = addr.bitlen;
> +			if (req.r.rtm_family == AF_INET)
> +				req.r.rtm_dst_len = 32;
> +			else if (req.r.rtm_family == AF_INET6)
> +				req.r.rtm_dst_len = 128;
> +			else
> +				req.r.rtm_dst_len = addr.bitlen;
>  			address_found = true;
>  		}
>  		argc--; argv++;
> 

Since the kernel used to blindly ignore the mask, having iproute2 fix it
up seems acceptable.

I think it would be good to educate the user about invalid settings as
well - get them to fix scripts and mind set.

