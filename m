Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E1E4A75F6
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiBBQck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235145AbiBBQcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:32:39 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FCFC06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 08:32:39 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id e79so26116883iof.13
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 08:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=L6uHa25soSNU4QOKbFsIhaKgXpD/9sEmsvqnDiDY4jY=;
        b=ox1En8z+HRfXrZBQnNK7kpzeZTH3LhJl2TH/KvrKCEs9vWilkD/wB5JNtaaujNnWHY
         /IF0eyEKjjg+OQzZeXb6zh5rHZEoQzngy+WmdIg3Fik44DWMMkOs9nohAN+Jng0AXh7n
         Aq9uZmhM7UBliaJspW/pkpVEsEZo9o7dB5itZZ93N2ycMa2EeHWmFBlmkOXN5nTnxfxW
         5t1Zf4BOGjp/twNW3zeJxqIRvauW4axaSpW8t8NKJgkcJb/qHLSXKhb2svGXjHDQx0vy
         M4FfWs7a3t2YPwJsmFLfYnIDPnrXjWDWa9dvPmcZJ8V3AxgR6hYJHAG4h3TySq2UENI/
         0+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L6uHa25soSNU4QOKbFsIhaKgXpD/9sEmsvqnDiDY4jY=;
        b=HnPYjeDsaoSGIKGjdpy15l/hNIDp+d0VYiR+EJu78JKnJkh1aXyxMM59CDgb9jYiu4
         2L5fq/Z/2JIdr27Gxz8+48dtQVNtgJh7P4d3sgkhVx07eQvogbOc+qv8CrPPSR3bh0t9
         KHvVoBR0xzFKRB1STKAgtHp8OwH2yhHzO3+5NqO6N3MJfD92CBgLixh/HG0+2wdXqE3t
         g+qWO+BP20VFYn9cZBjzhYu8ZC0lmTESSFanuEhbu45j+2O7YqL9u0W/tFFa3bcL+bGC
         nFpUZ30z1LPCZwRXPpwdNMSCtzwIkLq5mvxxBMiB6DaRhYeU2VGrEkCUuaAAt4Zy46WD
         eg6g==
X-Gm-Message-State: AOAM531pJ1sZp56pyrZw7G7aIacE4ZkiT5w5B0UvB89m5pLV7YuJxOzk
        5qv6y1dcmMH4+TohljwN6lw=
X-Google-Smtp-Source: ABdhPJxJmqLepHR3NbGdGyNKFYt7HeeCFk77jOlaZOCtUEKJKyuhJfVE28uc/vOvhWXLAurWpg9uIA==
X-Received: by 2002:a05:6638:687:: with SMTP id i7mr16271793jab.222.1643819558745;
        Wed, 02 Feb 2022 08:32:38 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id j12sm2748942ilk.21.2022.02.02.08.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 08:32:38 -0800 (PST)
Message-ID: <dcdce9ce-6c04-b340-18e8-0ab5c6879022@gmail.com>
Date:   Wed, 2 Feb 2022 09:32:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net] net, neigh: Do not trigger immediate probes on
 NUD_FAILED from neigh_managed_work
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net
Cc:     kuba@kernel.org, roopa@nvidia.com, edumazet@google.com,
        dsahern@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org,
        syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com
References: <20220201193942.5055-1-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220201193942.5055-1-daniel@iogearbox.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/22 12:39 PM, Daniel Borkmann wrote:
> syzkaller was able to trigger a deadlock for NTF_MANAGED entries [0]:
> 
>   kworker/0:16/14617 is trying to acquire lock:
>   ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652
>   [...]
>   but task is already holding lock:
>   ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572
> 
> The neighbor entry turned to NUD_FAILED state, where __neigh_event_send()
> triggered an immediate probe as per commit cd28ca0a3dd1 ("neigh: reduce
> arp latency") via neigh_probe() given table lock was held.
> 
> One option to fix this situation is to defer the neigh_probe() back to
> the neigh_timer_handler() similarly as pre cd28ca0a3dd1. For the case
> of NTF_MANAGED, this deferral is acceptable given this only happens on
> actual failure state and regular / expected state is NUD_VALID with the
> entry already present.
> 
> The fix adds a parameter to __neigh_event_send() in order to communicate
> whether immediate probe is allowed or disallowed. Existing call-sites
> of neigh_event_send() default as-is to immediate probe. However, the
> neigh_managed_work() disables it via use of neigh_event_send_probe().
> 

...

> 
> Fixes: 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
> Reported-by: syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> ---
>  include/net/neighbour.h | 18 +++++++++++++-----
>  net/core/neighbour.c    | 18 ++++++++++++------
>  2 files changed, 25 insertions(+), 11 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>


