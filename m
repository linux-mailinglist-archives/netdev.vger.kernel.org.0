Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D933FAF55
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 02:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbhH3AlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 20:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbhH3AlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 20:41:07 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAED8C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 17:40:13 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id x4so11865193pgh.1
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 17:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VApzl8Gy8EZZu+NRj+DtopuMmiOJ4iwp2mZKPDcSa7g=;
        b=cGj4SFOKAY6Z4qZZQwQWXaWDQApjw05z5gIDozMAl0Lx6BqDmr3zTOXRp2Jw4rrxlC
         lH6aeFEkHlnkra4M4n6qXYbJCBz7f6SgsgkERi17f2yLQQ+4vSln81+KkuNglPbqLM0h
         f8HBCxb0cmUOVoXlt5qfQ8RJZ1l5HxAL3X9AdU9gUmCd0bWESiW+Vad7T8nc2ICzNn0K
         IcErlrkMNyC/rEZyruztgnjU7MNDBbvILQCFKRwi0gmw6e/azWDpn4bR0eFXsxOpjl7x
         mO7wT0tY3eGiw8p+NLQU+ewc1GL1Li7FUYB9m5qU8QzRyhcIvpqx+7OZRcO2SwHvny7j
         0CpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VApzl8Gy8EZZu+NRj+DtopuMmiOJ4iwp2mZKPDcSa7g=;
        b=NtLCTVVLY9LIX1ZVCm1htgsr0aaFqun8IBtihu/Oc0vR1fz0IKPKBFDWaFV18Elh7w
         Urp3z00k0LGxItk1eqmX1CEUhSq3smUhUKey0w/vOTDBgkUMGtJsAV7uh0txOagf1lQ3
         dJeTyVTZKikhDC++/alnOh3S8ti6rGXIfMoyfjmSb2DHjbCb58ujoWyWHZ3jQ+RECdZG
         z524/JVMegNTCGMD6malvBn1FvssKAPJd3UiDOvG/3atWi7Lp1hnQzFrLNSvRjXz4fkk
         UeZ9DFSJ/hT96UpalbvpSk6VXfmBSBuL1osSf8zEdFDIDkZ6K+WgjsenpDtlPWxiqvpH
         tqGg==
X-Gm-Message-State: AOAM533ckTHHIvD7IJWjqZungZxLvsZyfXj4yosIsSo4HK5GX8mgh6V0
        XxIcS9UyL0h65bwZG/OmJYCm3jbl27o=
X-Google-Smtp-Source: ABdhPJxt1G5N1irwveNunfZc0IScyQr3yiOLJpm9O0/a7fJkO4wh1BtAS0fNdc6OLJG+nSJ5wYxRSA==
X-Received: by 2002:a62:483:0:b0:3e2:8b7:8208 with SMTP id 125-20020a620483000000b003e208b78208mr20554728pfe.42.1630284013261;
        Sun, 29 Aug 2021 17:40:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id j12sm12604462pfj.54.2021.08.29.17.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Aug 2021 17:40:12 -0700 (PDT)
Subject: Re: [PATCH net 2/2] ipv4: make exception cache less predictible
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Keyu Man <kman001@ucr.edu>, David Ahern <dsahern@kernel.org>
References: <20210829221615.2057201-1-eric.dumazet@gmail.com>
 <20210829221615.2057201-3-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <85cbe227-5eb8-bc32-7707-fe5e76aa7476@gmail.com>
Date:   Sun, 29 Aug 2021 17:40:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210829221615.2057201-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/21 3:16 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Even after commit 6457378fe796 ("ipv4: use siphash instead of Jenkins in
> fnhe_hashfun()"), an attacker can still use brute force to learn
> some secrets from a victim linux host.
> 
> One way to defeat these attacks is to make the max depth of the hash
> table bucket a random value.
> 
> Before this patch, each bucket of the hash table used to store exceptions
> could contain 6 items under attack.
> 
> After the patch, each bucket would contains a random number of items,
> between 6 and 10. The attacker can no longer infer secrets.
> 
> This is slightly increasing memory size used by the hash table,
> by 50% in average, we do not expect this to be a problem.
> 
> This patch is more complex than the prior one (IPv6 equivalent),
> because IPv4 was reusing the oldest entry.
> Since we need to be able to evict more than one entry per
> update_or_create_fnhe() call, I had to replace
> fnhe_oldest() with fnhe_remove_oldest().
> 
> Also note that we will queue extra kfree_rcu() calls under stress,
> which hopefully wont be a too big issue.
> 
> Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Keyu Man <kman001@ucr.edu>
> Cc: Willy Tarreau <w@1wt.eu>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/ipv4/route.c | 44 +++++++++++++++++++++++++++++---------------
>  1 file changed, 29 insertions(+), 15 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
Tested-by: David Ahern <dsahern@kernel.org>


