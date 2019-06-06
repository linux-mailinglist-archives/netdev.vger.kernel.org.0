Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 643E937F29
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfFFU5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 16:57:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39640 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbfFFU5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:57:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id 196so2024691pgc.6
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 13:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VQ87MFDn9RBZMdC4cOZjQx2W0h4MJ1rc16jvev5N5Uo=;
        b=samb4erRdSr/N95ks2k+xQtkZj+jnPshMaump2QbTNzmHIHMrwfBOy0K0AaUnTZwD2
         uh+XedFKm8byziW3YNdDVlnJgU/sWSL6S2cumcY+mDyy9acAv3Vyzh+iQrMsHgZrwhPT
         g/CmxUFfmEDuroymIP+KgPk6xi+MifSF81nv5k1oHbA0MyJpiMjDEOlw6RgopLMZAzOM
         WU8xFlrxQjkJ6/yWRR1rlncLyLK72RPyguya4e7DctHUMFcXSTopi71uJVQsKOu3Mx6V
         wLP0TPYn16sv43oXO9XMLHQJ7+TfmAs+X/n/1z4SARuPG4/Yd1FKK1RAoswwf3qC0B2h
         +03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VQ87MFDn9RBZMdC4cOZjQx2W0h4MJ1rc16jvev5N5Uo=;
        b=fwyCLNM7+k7Tx1HRpYJqYeevIP7JY6xNQOtPoycXYS6hGkdCSjpBJCJQncxq1rqBWh
         y4xXYl+DoFjPgLgWwOg0TeDZidwMZ7oBwQjpe+L4X3Ea8IncFqnOnrlfUkWkaaC7LKUx
         9ZJqEQIPlbmOP/cu535aqztrOeItuUnnolQWajafYGox2ORdg0xT5NDdyvA+LGFMBMZ5
         r5l5JX07lfeDFMR0q7UbIDVc+S9f9knz/Kf1YRV7wBXdXZCKJbX/3z/eJZT5dFckEUSr
         FUc6/3somZgYp0W4j/J3NFMWCIlkyY5vdofTN6f4WPqRgpNwLfkRNUkb5UVSClmeUbVe
         nWzQ==
X-Gm-Message-State: APjAAAXlwpTcdMiNnZPIZC4C2p15BaviXUyuudiEcD3AO1C2G6A1FjuM
        8z9N8vmLpiPUGtp3tpBAySkHT5QYHAY=
X-Google-Smtp-Source: APXvYqwIymi+5ZNRTXSH73m/L1Yr/bQGxZ3ygSEoE3VvbHNXfiFyCK+4Ej2TeCZ+MXKuFMxOv7b41A==
X-Received: by 2002:aa7:8b12:: with SMTP id f18mr54500712pfd.178.1559854656104;
        Thu, 06 Jun 2019 13:57:36 -0700 (PDT)
Received: from [172.27.227.242] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id g2sm57113pfb.95.2019.06.06.13.57.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 13:57:35 -0700 (PDT)
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fbe7cbf3-c298-48d5-ad1b-78690d4203b5@gmail.com>
Date:   Thu, 6 Jun 2019 14:57:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 2:13 PM, Stefano Brivio wrote:
> Since commit 2b760fcf5cfb ("ipv6: hook up exception table to store dst
> cache"), route exceptions reside in a separate hash table, and won't be
> found by walking the FIB, so they won't be dumped to userspace on a
> RTM_GETROUTE message.
> 
> This causes 'ip -6 route list cache' and 'ip -6 route flush cache' to
> have no function anymore:
> 
>  # ip -6 route get fc00:3::1
>  fc00:3::1 via fc00:1::2 dev veth_A-R1 src fc00:1::1 metric 1024 expires 539sec mtu 1400 pref medium
>  # ip -6 route get fc00:4::1
>  fc00:4::1 via fc00:2::2 dev veth_A-R2 src fc00:2::1 metric 1024 expires 536sec mtu 1500 pref medium
>  # ip -6 route list cache
>  # ip -6 route flush cache
>  # ip -6 route get fc00:3::1
>  fc00:3::1 via fc00:1::2 dev veth_A-R1 src fc00:1::1 metric 1024 expires 520sec mtu 1400 pref medium
>  # ip -6 route get fc00:4::1
>  fc00:4::1 via fc00:2::2 dev veth_A-R2 src fc00:2::1 metric 1024 expires 519sec mtu 1500 pref medium
> 
> because iproute2 lists cached routes using RTM_GETROUTE, and flushes them
> by listing all the routes, and deleting them with RTM_DELROUTE one by one.
> 
> Look up exceptions in the hash table associated with the current fib6_info
> in rt6_dump_route(), and, if present and not expired, add them to the
> dump.
> 
> Re-allow userspace to get FIB results by passing the RTM_F_CLONED flag as
> filter, by reverting commit 08e814c9e8eb ("net/ipv6: Bail early if user
> only wants cloned entries").
> 
> As we do this, we also have to honour this flag while filtering routes in
> rt6_dump_route() and, if this filter effectively causes some results to be
> discarded, by passing the NLM_F_DUMP_FILTERED flag back.
> 
> To flush cached routes, a procfs entry could be introduced instead: that's
> how it works for IPv4. We already have a rt6_flush_exception() function
> ready to be wired to it. However, this would not solve the issue for
> listing, and wouldn't fix the issue with current and previous versions of
> iproute2.
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 2b760fcf5cfb ("ipv6: hook up exception table to store dst cache")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> This will cause a non-trivial conflict with commit cc5c073a693f
> ("ipv6: Move exception bucket to fib6_nh") on net-next. I can submit
> an equivalent patch against net-next, if it helps.
> 

Thanks for doing this. It is on my to-do list.

Can you do the same for IPv4?

