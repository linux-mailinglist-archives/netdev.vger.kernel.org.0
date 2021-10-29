Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179834405E9
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 01:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhJ2Xzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 19:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhJ2Xzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 19:55:36 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250A4C061570;
        Fri, 29 Oct 2021 16:53:07 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id g125so15604180oif.9;
        Fri, 29 Oct 2021 16:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ut6pn5cliGqKJyxhLk39cGyPq9pAH/Drj266MOylggY=;
        b=QaB65rFyylww/otFLw4EZbF7r6sgxqFL1f9BsRxQVff5RCyCrDpCuO4ulCuDxw31ej
         piM95O/fr1PFSsz6yzMwtHX04tBY9gk+EiBjUOWGRBwgH3uIlEgfNtL20oBaXs3LtBrv
         fN5FWr5HqTVReG7b8+WaUpmBNPGmVZPBdNKZa2MVJiKwD3h+RtgKu9f1u3x986YF7yCy
         z0wkqzr4JJRb6y6vS7vXfjvkpYoH3oJk0ToM7RC1hyaR5q8NWdEmzRrKMpDzLfTRDF7s
         BxOpdBSn6uv9iW//u2iDPYbPdFVHqvVKG7S2dUus9z0BnU0kjzoZFUgyy2VvUIT5ZBBM
         Oyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ut6pn5cliGqKJyxhLk39cGyPq9pAH/Drj266MOylggY=;
        b=AC4LWqCkvt/2rcqMr2IBcpBPnAi24G4SmcO4JnBqfqMqV0pelTz4oSYVtw5wkjUPtM
         32KCni7xPovAoi5uYGZy53Y9OnUbnhwIxolpfNYa9qNkMpWcSCG9Qk8/FcrVu0e+td3U
         QDhMm9Uq4HIqKpwC5/U0oH+5pwua8u9jxmvEGH4Dx+fP+7WGubuXTBSCoK6nomRsmCxw
         YansCgJ1m3LLoA0/nPiRlJrZIWF72sljB/l2WjxZ+e6w3EsBm0WrhUk2DKsgW+QYoJ0K
         Okt4yvq2SersInUN0E6sKXl59AZ1c3mV1opFSXjB4vyu0hK24my6JeZtXrNodSiK2vDz
         dMTQ==
X-Gm-Message-State: AOAM532IA03LuugxvhhnqvH/FY53XuV7BuYIXG/tqcMSgfINaxxAQ8yH
        04SC/23nQwRYxlMvXNdybyA=
X-Google-Smtp-Source: ABdhPJxiqvaeNc1rLviXAkgYuYHSxPzhxNZZNX93sklb3OaJbFGO2MbM0uJQCW11DHJRWxkbA3RsaQ==
X-Received: by 2002:aca:31c9:: with SMTP id x192mr15849915oix.173.1635551586095;
        Fri, 29 Oct 2021 16:53:06 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id r131sm2386537oib.27.2021.10.29.16.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 16:53:05 -0700 (PDT)
Message-ID: <9015da81-689a-5ff6-c5ca-55c28dec1867@gmail.com>
Date:   Fri, 29 Oct 2021 17:53:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: Kernel leaks memory in ip6_dst_cache when suppress_prefix is
 present in ipv6 routing rules and a `fib` rule is present in ipv6 nftables
 rules
Content-Language: en-US
To:     msizanoen <msizanoen@qtmlabs.xyz>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <e022d597-302d-c061-0830-6ed20aa61e56@qtmlabs.xyz>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <e022d597-302d-c061-0830-6ed20aa61e56@qtmlabs.xyz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/21 8:24 AM, msizanoen wrote:
> The kernel leaks memory when a `fib` rule is present in ipv6 nftables
> firewall rules and a suppress_prefix rule
> is present in the IPv6 routing rules (used by certain tools such as
> wg-quick). In such scenarios, every incoming
> packet will leak an allocation in ip6_dst_cache slab cache.
> 
> After some hours of `bpftrace`-ing and source code reading, I tracked
> down the issue to this commit:
>     https://github.com/torvalds/linux/commit/ca7a03c4175366a92cee0ccc4fec0038c3266e26
> 
> 
> The problem with that patch is that the generic args->flags always have
> FIB_LOOKUP_NOREF set[1][2] but the
> ip6-specific flag RT6_LOOKUP_F_DST_NOREF might not be specified, leading
> to fib6_rule_suppress not
> decreasing the refcount when needed. This can be fixed by exposing the
> protocol-specific flags to the
> protocol specific `suppress` function, and check the protocol-specific
> `flags` argument for
> RT6_LOOKUP_F_DST_NOREF instead of the generic FIB_LOOKUP_NOREF when
> decreasing the refcount.
> 
> How to reproduce:
> - Add the following nftables rule to a prerouting chain: `meta nfproto
> ipv6 fib saddr . mark . iif oif missing drop`

exact command? I have not played with nftables. Do you have a stack
trace of where the dst reference is getting taken?


> - Run `sudo ip -6 rule add table main suppress_prefixlength 0`
> - Watch `sudo slabtop -o | grep ip6_dst_cache` memory usage increase
> with every incoming ipv6 packet
> 
> Example
> patch:https://gist.github.com/msizanoen1/36a2853467a9bd34fadc5bb3783fde0f
> 
> [1]:https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L71
> 
> [2]:https://github.com/torvalds/linux/blob/ca7a03c4175366a92cee0ccc4fec0038c3266e26/net/ipv6/fib6_rules.c#L99
> 
> 
> 

