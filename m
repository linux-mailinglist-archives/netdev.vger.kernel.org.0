Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49129454D56
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240155AbhKQSr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbhKQSr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 13:47:27 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55A2C061764
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 10:44:28 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so6003186pjb.2
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 10:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dVZWW8IHcxiTd3i29/2dfSiyATAogm0CRhuipFOmBTA=;
        b=enP7r8zlNZoY9If/M4CZ+yv9MWhOtTMFj3f4tLgUQmH+aPkfPttFJGk6XDL9Ajvje4
         ShBYWUoie/34jeWV4jPGABlMWqbRCIAY3UhmADodB7nj7RIdjvtY7t3OMTp5st1Z4tCS
         zA5NOEFzFj/w0sZhVTOfmhrNF1FToC/Nxfjmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dVZWW8IHcxiTd3i29/2dfSiyATAogm0CRhuipFOmBTA=;
        b=20rD4xkWHTueNqzPte4WG9goQ7hs3UDvw3z4LiECQ3FvSg3xxMQc4laiSjRsrJu+LG
         i7jFsZ4h+xWlu8pK3yM8Jlhuku3BLSnTqZD26ECWwHs2vQXGownwSXPRp75MNGgiUtil
         HaS6J/y8ebVF5S9hAPVcHmhHkxggPJnpSdI4t04EgsXbUnSJSnxavLd9RFgR2m1K5eLV
         NSC1/WsxLbNXNFK9m+fjcouDMLZpDZoeT2s4gvwsnQdwYWxFmiq7Vp4bi9GVj29e2oxG
         kIudes2sDcAc0i3Ip+jEb1XGd+3IBjoZLjqw+2uIhEKylBJo+9j7Pw8I5Ou7VvPeSyAz
         YXzw==
X-Gm-Message-State: AOAM530j4boBc2Wu2CFyGGs9EnttzdQ5QPMO7HVglzlPQ/VUxUtg3tF0
        9aCN02urWkEihUh/M8Y1+nDEvw==
X-Google-Smtp-Source: ABdhPJxumXrQGpapV90QA0V6JKTjm314bc3QZNjSunYYAQo/mqFgbCuznwmhN0qPV28ttVBJbP81aQ==
X-Received: by 2002:a17:902:e885:b0:142:1500:d2ba with SMTP id w5-20020a170902e88500b001421500d2bamr58138195plg.19.1637174668121;
        Wed, 17 Nov 2021 10:44:28 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id pi17sm6695718pjb.34.2021.11.17.10.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 10:44:27 -0800 (PST)
Date:   Wed, 17 Nov 2021 10:44:26 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jordy Zomer <jordy@pwning.systems>
Cc:     linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] ipv6: check return value of ipv6_skip_exthdr
Message-ID: <202111171038.195688CE@keescook>
References: <20211117181610.2731938-1-jordy@pwning.systems>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117181610.2731938-1-jordy@pwning.systems>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 07:16:10PM +0100, Jordy Zomer wrote:
> The offset value is used in pointer math on skb->data.
> Since ipv6_skip_exthdr may return -1 the pointer to uh and th
> may not point to the actual udp and tcp headers and potentially
> overwrite other stuff. This is why I think this should be checked.
> 
> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
> ---
>  net/ipv6/esp6.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
> index ed2f061b8768..dc4251655df9 100644
> --- a/net/ipv6/esp6.c
> +++ b/net/ipv6/esp6.c
> @@ -808,6 +808,11 @@ int esp6_input_done2(struct sk_buff *skb, int err)
>  		struct tcphdr *th;
>  
>  		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
> +
> +		if (offset < 0)
> +			err = -EINVAL;
> +			goto out;
> +

Ew. Yeah, it seems like ipv6_skip_exthdr() needs to be checked in a lot
of places. If this is part of protocol decoding, I'm surprised fuzzers
haven't found this? Is this state reachable?

I assume so, as there have been similar fixes in the past:
https://git.kernel.org/linus/92c6058024e87087cf1b99b0389d67c0a886360e

>  		uh = (void *)(skb->data + offset);
>  		th = (void *)(skb->data + offset);
>  		hdr_len += offset;
> -- 
> 2.27.0
> 

-- 
Kees Cook
