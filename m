Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E671EA291
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgFALS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 07:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFALS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 07:18:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1B0C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 04:18:25 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g10so2696374wmh.4
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 04:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g0VCdWKmiQwqzeZ1145Q+jD/a6zqNIWdbNoYho8IUD0=;
        b=FJP0TzjycG35j8tltdqEefozgArLWxJRNm/8pejgk3vi+YrzWYohveIo+Wv32u9RyO
         ZM81uVxshoCGVU+k2TohNajLp6bVNA2XU23gRT9SZOTgTTbAt2+A+iMYZcjvWWJ8mzlQ
         zfNvKWd2clOWM8C3xpLHdyLROXd0Q8POb8TqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g0VCdWKmiQwqzeZ1145Q+jD/a6zqNIWdbNoYho8IUD0=;
        b=WnVjZOOkiCgtA63alaNVeJck0/+vamPCqMd+fKwz5TJErKiEpUW4iQ4aWgBy5P0Z7D
         ZKBrMMDx/NmEjU2wogO5eAckMBeB/Ck6HI2SmMR3YoVvQj6NQqBZDuzXfuvuMJb3Djzn
         Oe7qQIvJCufEZURGXftEVEJV2u+pvPs0RsWLaq3FXyzO9G4WQKQup0/CLicp5ZklCCqq
         5g7SogC6vtj3q0ovlhXotogYf7PjZq5bq011Gr6gqyjPqd27ctpuJ3LNogf3QqqtzMCd
         J+sk725elYHzPxEDep1G4ip2eqIe1OjLrOwb8LWk3B6r75LAnj1wWiT6C/l3AOaTFYvI
         9XtQ==
X-Gm-Message-State: AOAM532X9guYXi9XRVMxCr8P1rLn7yKOLSr2nISA8ulY3gWjrbOBADEr
        4igEwpCSaBpc8QbYHv2lKXSsqw==
X-Google-Smtp-Source: ABdhPJwdYJu0zMaWhn84ZbnLMJkV5ivwehiW6NRByLBq2FJYb+LNL4BsdrTKY6NK2+rut3Dk64b2Qg==
X-Received: by 2002:a1c:6244:: with SMTP id w65mr19535960wmb.82.1591010304464;
        Mon, 01 Jun 2020 04:18:24 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a1sm13861812wmd.28.2020.06.01.04.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 04:18:23 -0700 (PDT)
Subject: Re: [PATCH] ipv4: nexthop: Fix deadcode issue by performing a proper
 NULL check
To:     patrickeigensatz@gmail.com, David Ahern <dsahern@kernel.org>
Cc:     Coverity <scan-admin@coverity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <a4fc3fdc-48c2-3af9-95fc-342c1e87ed62@cumulusnetworks.com>
Date:   Mon, 1 Jun 2020 14:18:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200601111201.64124-1-patrick.eigensatz@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2020 14:12, patrickeigensatz@gmail.com wrote:
> From: Patrick Eigensatz <patrickeigensatz@gmail.com>
> 
> After allocating the spare nexthop group it should be tested for kzalloc()
> returning NULL, instead the already used nexthop group (which cannot be
> NULL at this point) had been tested so far.
> 
> Additionally, if kzalloc() fails, return ERR_PTR(-ENOMEM) instead of NULL.
> 
> Coverity-id: 1463885
> Reported-by: Coverity <scan-admin@coverity.com>
> Signed-off-by: Patrick Eigensatz <patrickeigensatz@gmail.com>
> ---
>  net/ipv4/nexthop.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 563f71bcb2d7..cb9412cd5e4b 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1118,10 +1118,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
>  
>  	/* spare group used for removals */
>  	nhg->spare = nexthop_grp_alloc(num_nh);
> -	if (!nhg) {
> +	if (!nhg->spare) {
>  		kfree(nhg);
>  		kfree(nh);
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  	nhg->spare->spare = nhg;
>  
> 

As Colin's similar patch[1] was rejected recently, this one also fixes the issue.
This is targeted at -net.

Fixes: 90f33bffa382 ("nexthops: don't modify published nexthop groups")
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Thanks!

[1] https://lkml.org/lkml/2020/5/28/909
