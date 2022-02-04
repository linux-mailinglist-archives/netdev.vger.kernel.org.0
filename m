Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02534A94B7
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 08:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354528AbiBDHof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 02:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbiBDHod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 02:44:33 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41EDC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 23:44:33 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id d10so16735631eje.10
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 23:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fWcU4NJu8/CFscO6kvoKFCu36729eop8ODjx47hLh0I=;
        b=jf2BHnguHJKtbGXsicak/Ns8SNZW6bTQYo/8PWO+9EzYvseJHr9VU+igwfllJ//nXA
         1qcs0mpv0oqFoad5NBT85lmDihZY/cVKTsyx6mR3/rM1hHBId4kSko/VZuJ7zY3iUe5U
         OzXgqVtw2z9OqTG4h/X3vBYmXMqaVCkcst02VBscflrwWvZWGbq0mgl6rE5mp/TXl02W
         22qcSpuHhe1LDryEfOzqrFsDk4OKvfz+Be8BmlttTggiTkbC41e+drtzZsAHVAMbTgPq
         KjhtKoL6vUSkKpDobuYXqyXtFItK8RhtvRDQY7TKklITVgIfX6zCQr40NkJxjv8qN3D9
         s6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fWcU4NJu8/CFscO6kvoKFCu36729eop8ODjx47hLh0I=;
        b=OxRCLK85uCRVQe2bYH17L/1I2qG5v+ys60Tme1JOc97KvERS8hmwwvLtsvgrSb2/jj
         0nY5uFpV+TSFQ8AiYFLLGQc2nIzyFTeqVeRRkIMz00+SArXE9VvOrZTM3ekDGX325q9t
         H/x8lVlo3gP20GJCeF+WCW38BNRedyDlxcCkN/UlAENeNXoKFs+9bsilEvsqSDAHU6hP
         SY0kNpuFWKhJs/xH7YCtCXUHM4+cbD0NN8ikeBJ8TR30imGLPLLQJc7Nr3uk9secU92j
         tWUZwckPEzffcLYEHreJGe//we5UWRwwplOGp+IJ8M4DawhN+T51aocPbcuVJUdkORWd
         O7XQ==
X-Gm-Message-State: AOAM5300JE3C2vLFlq6MMpD1nickokZ5QIgWxeUsIXCYB1g44t2ZkLK/
        9X1I+tJg+kSQyxLhUBeMzYcLig==
X-Google-Smtp-Source: ABdhPJxhVQFG1Hpi1BiYYFX5cysolkW3TSiMBc1DU+7cam03V9MPDQM8ohWe0vjfH//vJaly/ZP8Mg==
X-Received: by 2002:a17:906:9514:: with SMTP id u20mr1375336ejx.227.1643960672279;
        Thu, 03 Feb 2022 23:44:32 -0800 (PST)
Received: from hades (athedsl-4461669.home.otenet.gr. [94.71.4.85])
        by smtp.gmail.com with ESMTPSA id lm6sm377741ejb.46.2022.02.03.23.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 23:44:31 -0800 (PST)
Date:   Fri, 4 Feb 2022 09:44:29 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com,
        brouer@redhat.com
Subject: Re: [net-next v4 10/11] page_pool: Add a stat tracking waived pages
Message-ID: <YfzZXTyQ+BNss0ji@hades>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
 <1643933373-6590-11-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643933373-6590-11-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe, 

On Thu, Feb 03, 2022 at 04:09:32PM -0800, Joe Damato wrote:
> Track how often pages obtained from the ring cannot be added to the cache
> because of a NUMA mismatch.
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>  include/net/page_pool.h | 1 +
>  net/core/page_pool.c    | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 65cd0ca..bb87706 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -150,6 +150,7 @@ struct page_pool_stats {
>  			    * slow path allocation
>  			    */
>  		u64 refill; /* allocations via successful refill */
> +		u64 waive;  /* failed refills due to numa zone mismatch */
>  	} alloc;
>  };
>  #endif
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 4fe48ec..0bd084c 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -166,6 +166,7 @@ static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
>  			 * This limit stress on page buddy alloactor.
>  			 */
>  			page_pool_return_page(pool, page);
> +			this_cpu_inc_alloc_stat(pool, waive);
>  			page = NULL;
>  			break;
>  		}
> -- 
> 2.7.4
> 

Personally i'd find it easier to read if patches 1-10 were squashed in a
single commit. 

Regards
/Ilias
