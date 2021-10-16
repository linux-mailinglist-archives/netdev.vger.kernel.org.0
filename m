Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B52642FF67
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239294AbhJPAUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhJPAUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 20:20:46 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2718C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:18:39 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so216347otq.12
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 17:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H8q53TloCGiUd6RtkUcytB8p601kXgM502d2BwEyALM=;
        b=a13OWWUYDe3svmXW6mYFr9orp9l1md3XuFY56wRh7bzILcki7cxIpK2yMXcvOoHi63
         euleqsaU9n7HffJzaVqkrVph/i1YTQWKvVHsz34BEwDQe+w1Byf2UwjM45/DXPMCLpoh
         msqv1YHyPDURjlwk/GUKcGt1m2A1BmWgQtpmTHdFZX2rHeIofK4L5r+7d6RZ3OYoty2f
         SzuugQib4l5NwD53NTjdzoGqdpSowgOe5WwLbRLIqcJezka7nIblSs71j2v6qmM5Q45O
         Q7554p2FGmoSof8ioCktrO5Kx1RT6KqmX8juh1lp5RA579w3RRm3NiXrh81uSyz389RN
         b+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H8q53TloCGiUd6RtkUcytB8p601kXgM502d2BwEyALM=;
        b=PvJvIt1j5f19uFH3AW1vN69jhs5NBUgLLKNp8VdYQwxvtdvxzXx13oyrnQU02lMS9q
         7b9RTxQeXUWmfsm5SbWvhiHzwpQ0leo25gKxeiQT1nxn3l2Ur3E/iJWa37aFWywLcKmb
         skbZjOvl/dsXQQHTcgEkFuu6jiBVNra2LM09qgEIh91hwvP/ii05cJr7NEpjGyJ/s0yO
         3uWLzvKzhLPy/ULhWQwjwePF020h1IXSwrkqhB/lVuyeOklDc+OrQyR3kiMssBXYxdqo
         RYSTxaJpO4m//DIuN/JnomALOY5lmI5/mAlgo3CzO1eIVcrDqXGBfoaq1dFb3XN6XoIg
         5Jnw==
X-Gm-Message-State: AOAM53023jvxMv9O0Cf1nlgFCCG/pHE0aoU2m7lNc4Djau6QUutK8oG0
        mfxzazMesw81EGfYLEAx6kejkPCjfzW8mg==
X-Google-Smtp-Source: ABdhPJzNWc5ZFwDqWzMwy+xQB7+HDo2V9VI4vlxEVmbmM8c2EnNqTaw5OoGQuMpxk6hlxjLz+e81Dw==
X-Received: by 2002:a05:6830:57d:: with SMTP id f29mr10921661otc.285.1634343518944;
        Fri, 15 Oct 2021 17:18:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id l16sm1270724oou.7.2021.10.15.17.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 17:18:38 -0700 (PDT)
Subject: Re: [PATCH iproute2 -next 3/4] ip, neigh: Add missing NTF_USE support
To:     Daniel Borkmann <daniel@iogearbox.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
References: <20211015225319.2284-1-daniel@iogearbox.net>
 <20211015225319.2284-4-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4e842bc5-116b-66c6-b8dc-487b4b5d15ed@gmail.com>
Date:   Fri, 15 Oct 2021 18:18:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211015225319.2284-4-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 4:53 PM, Daniel Borkmann wrote:
> diff --git a/ip/ipneigh.c b/ip/ipneigh.c
> index 564e787c..9510e03e 100644
> --- a/ip/ipneigh.c
> +++ b/ip/ipneigh.c
> @@ -51,7 +51,7 @@ static void usage(void)
>  	fprintf(stderr,
>  		"Usage: ip neigh { add | del | change | replace }\n"
>  		"		{ ADDR [ lladdr LLADDR ] [ nud STATE ] proxy ADDR }\n"
> -		"		[ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
> +		"		[ dev DEV ] [ router ] [ use ] [ extern_learn ] [ protocol PROTO ]\n"
>  		"\n"
>  		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
>  		"				  [ vrf NAME ]\n"


does not apply to iproute2-next; looks like you made the change against
main branch.

