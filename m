Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033D610E54
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfEAVBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:01:09 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:39906 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfEAVBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 17:01:09 -0400
Received: by mail-yw1-f65.google.com with SMTP id x204so38458ywg.6
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 14:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WY2UkJMPUQsPCSRV13XlYsKmUHw++n8zo9rb55A79Zg=;
        b=Qkgd372IVN6eGOLmznGc7LatwyeLtI3GRbIb1e61n3S4GgwqW2XqyUICi4evbm5Y7M
         /MY90ehwdmYLzata7aQsJnTe2r+hAgqGRNGXo1RQZxl9gomw7njrgZ5p+8i59uasXKAm
         HS7zuYJ67qxC3WXzftwZpFnXFTSwFk0kn4/EO9KnhSH2BxSVy+g9QQN8QCBhxWhIHvjs
         UYlxGfqbGMzoInM/zQcf7egag+hBAGBYgeEFv/BjZk5rNRphC/oNCx99JZw9jN1iODF+
         UjC2p/TP9TXvt+lz3D4UynS5E7CkvtcDZz+2Upkxp5Mw1tAOMrKG+GNvpbN5s0JMIPjQ
         V3bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WY2UkJMPUQsPCSRV13XlYsKmUHw++n8zo9rb55A79Zg=;
        b=Fx3vFq+sOz9gYkbCuc/RM2WSRTMWNCp0G9eXUlkvvUs27wAULAej3Pyu73clVLaSRL
         rVsGVtDVcbt5Fl6Ae8Wm3cvwmSX954oCi++z+zQgd0PHlVpm6WK70WQyvG987F8XujNG
         QKCAFSc44zof+lE0PouD9KDmcmugflulwiKRQLoiHIwH34+0chRjBWDwtJzMNi22OfOI
         CZ4VZdegc2IKku4lCib3A6ZF7kWHjvrFqLm0bu72a/8dbZVmnNpvxhD+gpbvI1r7kmeU
         +8n7YJgD22SLz6qnFO7BQC5FRBMV9/lyWFleaK9ZIucw0Yds/FQxwU0OhOdEhj53xUOo
         DOBA==
X-Gm-Message-State: APjAAAVZIezgI5M8K8bVkf6VFgqXCg83D4N+0cZKhFjQObTKOQ5sPB14
        0Ov+v7Dc3d4O7OIq/oJKiuA=
X-Google-Smtp-Source: APXvYqzqccSAP7zhzSTXfgDixD6HG8w/OUv3x5yGgVCjs56sMbvZ9rEnQsmeuzZzFpKxPR3wbqsXpw==
X-Received: by 2002:a81:3d06:: with SMTP id k6mr14275046ywa.282.1556744468345;
        Wed, 01 May 2019 14:01:08 -0700 (PDT)
Received: from [172.20.0.54] (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id f2sm5590418ywb.79.2019.05.01.14.01.06
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 14:01:06 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: A few fixes on dereferencing rt->from
To:     Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <bsd@fb.com>, kernel-team@fb.com,
        Wei Wang <weiwan@google.com>
References: <20190430174512.3898413-1-kafai@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <04d904dc-b64a-a6b7-9f0e-40c3d9a2e6a3@gmail.com>
Date:   Wed, 1 May 2019 17:01:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190430174512.3898413-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/19 10:45 AM, Martin KaFai Lau wrote:
> It is a followup after the fix in
> commit 9c69a1320515 ("route: Avoid crash from dereferencing NULL rt->from")
> 
> rt6_do_redirect():
> 1. NULL checking is needed on rt->from because a parallel
>    fib6_info delete could happen that sets rt->from to NULL.
>    (e.g. rt6_remove_exception() and fib6_drop_pcpu_from()).
> 
> 2. fib6_info_hold() is not enough.  Same reason as (1).
>    Meaning, holding dst->__refcnt cannot ensure
>    rt->from is not NULL or rt->from->fib6_ref is not 0.
> 
>    Instead of using fib6_info_hold_safe() which ip6_rt_cache_alloc()
>    is already doing, this patch chooses to extend the rcu section
>    to keep "from" dereference-able after checking for NULL.
> 
> inet6_rtm_getroute():
> 1. NULL checking is also needed on rt->from for a similar reason.
>    Note that inet6_rtm_getroute() is using RTNL_FLAG_DOIT_UNLOCKED.
> 
> Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>


