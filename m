Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCF54629D8
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhK3Bi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 20:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236601AbhK3Bi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 20:38:29 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7E9C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:35:10 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id q25so38243825oiw.0
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=M1NXGmRJ2IsdoQuz5hBrEXRZYE5coMqFTOc5SIHqtl4=;
        b=niBnUvVzkEfJ73tEgZaxQbIfsVXfbscEk+J9NYxIANIQttcYA28hvY2golz1SdNMjx
         lWeKPoprSDzJOGdg5uJoDaY9JrYnU3tGNAk5cupNydo+C1g+n02w81JX6Rp2Y7QV06xR
         Bx6Kj22M0CXAUzGIQs5KXtBokyY26uP0K3CZ5+OhegZxf7yCEBZdug5j2f2ph6AVeJBj
         IZ42s1pDVse2GoBUNb0HHg1/m+BC2jTSoS6BKAt2fLZmSzDfMTdWIwUY/txuxrfGEcox
         V/lEIR3HSb9pRR3O46ar27RIM9+cWdjUzddRkPvzAg9LUiDYgSzDwyJf4aoq+2rozJrC
         iRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=M1NXGmRJ2IsdoQuz5hBrEXRZYE5coMqFTOc5SIHqtl4=;
        b=N44fQma+3BXWH7D6W8800RFqaxjjTXwdhT00T70e77AaGLoVLq1V+KX2X14sdzZFKY
         wEfzI1z7aBTs9Gdt9oRV5/Mpiz7R86XP9RysWW188cEVM06fzp4cjl7iRrShi7XTPVo+
         IV1nHZeO4B9iFXjKEoTmthkGAVx7E7e6NgzWctlZFd1z2jB0UvO257rtkFULTy1v2khO
         Q6URjJ+GYIEDyLPfvFzcuxuf2SSi37wCfM5nElfERas4gGE0q7/f6Q0DiCKW65OMYV01
         iuB5QQSvFTTJUX7R9w0jnw3P9TilQDgoRABsj93oJYF0zr+ntNOwBiJaJbrLK7P0s3bu
         sNxA==
X-Gm-Message-State: AOAM533sTj7tDLgOQ9UF3Vd63LMSIDt0rfr15WlyqZ+iNSaZt/cIFNyQ
        dXnXd+9xhc6NkTO1n6zlYlQ=
X-Google-Smtp-Source: ABdhPJxSbPYEASNnxQ7LqEIqK74vNRir/5z5NdlMTy34r2zdPQPnNxCkSuu28ehi9EQEXzo9DOBa5w==
X-Received: by 2002:a05:6808:284:: with SMTP id z4mr1610531oic.60.1638236110367;
        Mon, 29 Nov 2021 17:35:10 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id c3sm3491257oiw.8.2021.11.29.17.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 17:35:10 -0800 (PST)
Message-ID: <87b2b35e-11b0-4ff8-f65c-9bbef0ab6588@gmail.com>
Date:   Mon, 29 Nov 2021 18:35:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next v2] net: ipv6: use the new fib6_nh_release_dsts
 helper in fib6_nh_release
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <8f11307c-9acf-2d83-a7f4-675c46966ede@nvidia.com>
 <20211129154411.561783-1-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211129154411.561783-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/21 8:44 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> We can remove a bit of code duplication by reusing the new
> fib6_nh_release_dsts helper in fib6_nh_release. Their only difference is
> that fib6_nh_release's version doesn't use atomic operation to swap the
> pointers because it assumes the fib6_nh is no longer visible, while
> fib6_nh_release_dsts can be used anywhere.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
> v2: no need to check for NULL rt6i_pcpu before calling free_percpu
> 
>  net/ipv6/route.c | 20 ++------------------
>  1 file changed, 2 insertions(+), 18 deletions(-)
> 



Reviewed-by: David Ahern <dsahern@kernel.org>
