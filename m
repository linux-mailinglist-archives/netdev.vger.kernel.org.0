Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF9125B32F
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 19:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgIBRup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 13:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBRup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 13:50:45 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5655C061244;
        Wed,  2 Sep 2020 10:50:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id s2so155691pjr.4;
        Wed, 02 Sep 2020 10:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gldkp7PW4j0DFMsRsIZxRE3Gipj4nAiWdiTeBWgOz50=;
        b=Nwd1UqVMyXf3mjIymnk+vD+DPirEUCHett1jNK87DprBGgW+CTZZpMM7pwqUG+5+eb
         ws8wMD7FIxnp55sJYoS8gYv7W+sGwQeOIPL9gr+WOCtSLv+r11aKmH2P5wixwMN7FWez
         DBuYjtncHi/O5Ds0hrNbJlq6sPJ/jOr7Pv/kXdWYI9+FEui3g+jihG6CaE1x+9M4KYlb
         Tw0HHU2nlWqVQfkF2Ka7C0P6ItecbxJnjB7Od4k4JkOLiB8HKdJUa8eoIQa82Sttb8xs
         SuD88I3aa8IInaBr4N9RWyvvKv/JN5JavJB2K0SUEG07WSzVVTvKlUKK47Ic8bJQMDeJ
         6D9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gldkp7PW4j0DFMsRsIZxRE3Gipj4nAiWdiTeBWgOz50=;
        b=Zct+ESSzVbdwl76rAOPQ3xSnWSZCsZOdI2zlLLFJC3TcmA1JsNZbe+xanqJY6FOYk6
         i8i/8sSfRPAA5Q82bDGxC9wSSZmqfHi6aeqRRP/hw7DhkSnbyyCLPms35gDdHxyOuX3T
         P0dJM/3ZW/f1D+brWtLhbgOTsGo0R5KHkp3wjbHwNfylEegOiwyvTr2Mlf7lWz0Qa89e
         iFe1zxwLVgNHetxh+wyZlGwv/+XkHtOeQmFwzqEOBq5YhlpjEGSGP6eNkOabtczRt3G3
         DWVGFZc+0WvzSoAfTm0QN6Uoxx2b5wiB6U28FvuZBBTvpe+pAjFfoMKbDilQrrMh97Z+
         ZEow==
X-Gm-Message-State: AOAM531QT5Pi047L7gdd8+Rn8zcd5lS7vuk2wOlHycftcwFCsvHJcYG0
        MXyn1HCU9qGHBbxyX31QUBdrGVvxCk8=
X-Google-Smtp-Source: ABdhPJyM6VawxkZVo+/zeLvKajvna+zRWmEiEWBof7ij8IV6Rs/NJnX43gYynQXgp6nZeG4j+70QUA==
X-Received: by 2002:a17:902:9a02:: with SMTP id v2mr3012615plp.151.1599069043990;
        Wed, 02 Sep 2020 10:50:43 -0700 (PDT)
Received: from [10.230.191.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p11sm6764408pgh.80.2020.09.02.10.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 10:50:43 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: fix mask check in bcmgenet_validate_flow()
To:     Denis Efremov <efremov@linux.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200902111845.9915-1-efremov@linux.com>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <74100a9f-5215-ed55-7077-a180a85f775a@gmail.com>
Date:   Wed, 2 Sep 2020 10:53:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200902111845.9915-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/2020 4:18 AM, Denis Efremov wrote:
> VALIDATE_MASK(eth_mask->h_source) is checked twice in a row in
> bcmgenet_validate_flow(). Add VALIDATE_MASK(eth_mask->h_dest)
> instead.
> 
> Fixes: 3e370952287c ("net: bcmgenet: add support for ethtool rxnfc flows")
> Cc: stable@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
> I'm not sure that h_dest check is required here, it's only my guess.
> Compile tested only.
> 
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 0ca8436d2e9d..be85dad2e3bc 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -1364,7 +1364,7 @@ static int bcmgenet_validate_flow(struct net_device *dev,
>  	case ETHER_FLOW:
>  		eth_mask = &cmd->fs.m_u.ether_spec;
>  		/* don't allow mask which isn't valid */
> -		if (VALIDATE_MASK(eth_mask->h_source) ||
> +		if (VALIDATE_MASK(eth_mask->h_dest) ||
>  		    VALIDATE_MASK(eth_mask->h_source) ||
>  		    VALIDATE_MASK(eth_mask->h_proto)) {
>  			netdev_err(dev, "rxnfc: Unsupported mask\n");
> 
Well spotted. Thanks!

Acked-by: Doug Berger <opendmb@gmail.com>
