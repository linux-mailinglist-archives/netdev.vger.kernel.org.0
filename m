Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07573485805
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242798AbiAESOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242792AbiAESOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:14:42 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED513C061245;
        Wed,  5 Jan 2022 10:14:41 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id s1so84793473wra.6;
        Wed, 05 Jan 2022 10:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8IjMW6kyewB7HLmt/uQqvKqK5mbucpa6D6MSyk1fHdQ=;
        b=gKE4UomKBFwRpUshG0snXgWNC/rxvjVyQ8jVCfO9j82EJZwmb/UcMTRrrQbgXq0hrF
         rTfFlCyhgANb2v7sdxl4Jin7ut5WN1WO44htt/gQJIupRLBZO+PTL6+bHiVoMePRGHBR
         EX228Bum6EoQAPa+1wnEjBJou/GyrQ5EDD/eROUQYiw/DryE685vocVXA3xysDiXy5kT
         fZrXKsqOc+QtW22/Ua86OONpG/tzAIjreZFDL2At7gvmadwou/RD1D1P8eexwGOOW3De
         cktCBuVV8ceC2SnmqXZFU8xKAnIq2ojSpgN2/qoRaBa0pIaf+f9d5x9eEUk9BTmrOqBy
         wVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8IjMW6kyewB7HLmt/uQqvKqK5mbucpa6D6MSyk1fHdQ=;
        b=WP7cdOl7JohOCkNwkSC7Rn6YK9E1rjHOH/mGY+oCj7V0YsPQ07yFHLBS/JqMAYfNEB
         eV+A4kyBvbvKQxJT1mqSSY/4THi69epOhCm0d2SCCu/OjSskVTZ821Bg1k+mhDuWvIxq
         V8TaNh7QEhEJ501PPf4DFwbvSZM6fvdl2KjoqqMhg2khCpiz/m2fEZdFkUO+fYyflRJQ
         IQ94nCGmCAwKUwpnRMmpOfS4w1GG4wfb2ihHXFVH+UxQuiiqi3O1nJLOMZfy9ZU8jgVs
         DUk9aBbjNtP62PC/UachaN783QKv2dM/kaG+tm67Nm5vwxy8N7KxELLdPRBpeO+VbS9I
         Uh7w==
X-Gm-Message-State: AOAM532IsG4Xt1u8Ci01JtrvYtKXbp34Z5s/txVCxdhDABnTjuir3YRn
        KauGtogBxVtA2ad5rjlFSKnri2g1uF0RWA==
X-Google-Smtp-Source: ABdhPJwV50tlWG5s4pF6cVKwOxhOo8WttB1QjSKihGp4jw4Pg8cviW/0sYraxqiJi76XO6Ft7KaHpg==
X-Received: by 2002:a5d:64aa:: with SMTP id m10mr49230327wrp.500.1641406480629;
        Wed, 05 Jan 2022 10:14:40 -0800 (PST)
Received: from [10.0.0.5] ([37.166.219.18])
        by smtp.gmail.com with ESMTPSA id 9sm53334440wrz.90.2022.01.05.10.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:14:40 -0800 (PST)
Message-ID: <425e92d0-4321-8f9d-fc75-bba29f172550@gmail.com>
Date:   Wed, 5 Jan 2022 10:14:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net 1/2] net: bridge: mcast: add and enforce query
 interval minimum
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, stable@vger.kernel.org,
        herbert@gondor.apana.org.au, roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, kuba@kernel.org
References: <20211227172116.320768-1-nikolay@nvidia.com>
 <20211227172116.320768-2-nikolay@nvidia.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20211227172116.320768-2-nikolay@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/27/21 09:21, Nikolay Aleksandrov wrote:
> As reported[1] if query interval is set too low and we have multiple
> bridges or even a single bridge with multiple querier vlans configured
> we can crash the machine. Add a 1 second minimum which must be enforced
> by overwriting the value if set lower (i.e. without returning an error) to
> avoid breaking user-space. If that happens a log message is emitted to let
> the administrator know that the interval has been set to the minimum.
> The issue has been present since these intervals could be user-controlled.
>
> [1] https://lore.kernel.org/netdev/e8b9ce41-57b9-b6e2-a46a-ff9c791cf0ba@gmail.com/
>
> Fixes: d902eee43f19 ("bridge: Add multicast count/interval sysfs entries")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---


Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !


