Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3FA466729
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359192AbhLBPxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbhLBPxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:53:35 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC06BC06174A;
        Thu,  2 Dec 2021 07:50:12 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id u74so56307381oie.8;
        Thu, 02 Dec 2021 07:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3pO6rrZ4xWq0xlykjpJhXxJ0izgGHgLu0jZ+DW2sNFw=;
        b=Id9to7M5xU+zRQyD2qTsL2OTAoqPdLKDEs5wgxNgT87h6m9tJ4kNJUAnMStfpegZFe
         cqBnVa5TOCAv/4Ek8dBlzuzt8rV+ODHfUTsOti8BNxi+Wj9ygDSgLXVpCt3THqaUhclQ
         F9wF4gJ3yt2zIA2TKAa1YSK6GoiCzT2xVH/GNt5U9X0bjJqv5TT87To3aMRCGUdRjwiN
         bisaWuwMFqAV2EE52BdxWtnBBc8YMi8b1Q9AMykluwluIMovEWIyfYPQPkeimalsPf05
         6O7QQOGpYw48G0QPwkK5oavzJxt6NFLXPsabTIcCpIdd6nlUQZKZy3pbTii3u9EnY2tF
         2C2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3pO6rrZ4xWq0xlykjpJhXxJ0izgGHgLu0jZ+DW2sNFw=;
        b=LwVYO5p/2sP56NVeB823Wams4EMP5lVXg6RxPGBGB9qZIAqawoOcrW1qaAyAuuGNCJ
         KuWyvwFrFxvPdrg7O1lxNYJmBE8OeUyWic4vO69j1/FNkw3tezmxKOYkVBOWGb+7Qq6k
         vqSRB7Az7wjPOabCCnDMiQT4Ob1Ns9Xjpg6PKKxT5hEa0BDnhGbrY21s5qbyGuBJ3r24
         P9iPpVYhsVK1PLPlLZC+GMZy8pS0wj6a+UucLo3vWogeM4IwA9TqG9As7+URGWPZ0wFz
         mniCOCgj9yWi6f+LPITUcQdOTC3XNLCYz1cB+c+mImegrXmqbVrsK8kfHpRjtAR1BrcX
         IGVw==
X-Gm-Message-State: AOAM533Onjs08NSG2jtWrnf2aO1pD/Y9IjTgO/uZMChz+xx9NVdp7Ltd
        0+QZmLPJh6QEvYrTis3orYaj40iOqB4=
X-Google-Smtp-Source: ABdhPJzUVc/7Gbil7GWkt5KyYfFmb9Sm7d0frPHadYko6vNzeNOKQUW34WJQfnArFz4LZ5WnSKH/YA==
X-Received: by 2002:aca:ac8e:: with SMTP id v136mr4993090oie.19.1638460212277;
        Thu, 02 Dec 2021 07:50:12 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id m3sm100752otp.6.2021.12.02.07.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 07:50:11 -0800 (PST)
Message-ID: <45434eae-b598-df7d-d62a-711643305fca@gmail.com>
Date:   Thu, 2 Dec 2021 08:50:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net v3] selftests/fib_tests: Rework fib_rp_filter_test()
Content-Language: en-US
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211130004905.4146-1-yepeilin.cs@gmail.com>
 <20211201004720.6357-1-yepeilin.cs@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211201004720.6357-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 5:47 PM, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Currently rp_filter tests in fib_tests.sh:fib_rp_filter_test() are
> failing.  ping sockets are bound to dummy1 using the "-I" option
> (SO_BINDTODEVICE), but socket lookup is failing when receiving ping
> replies, since the routing table thinks they belong to dummy0.
> 
> For example, suppose ping is using a SOCK_RAW socket for ICMP messages.
> When receiving ping replies, in __raw_v4_lookup(), sk->sk_bound_dev_if
> is 3 (dummy1), but dif (skb_rtable(skb)->rt_iif) says 2 (dummy0), so the
> raw_sk_bound_dev_eq() check fails.  Similar things happen in
> ping_lookup() for SOCK_DGRAM sockets.
> 
> These tests used to pass due to a bug [1] in iputils, where "ping -I"
> actually did not bind ICMP message sockets to device.  The bug has been
> fixed by iputils commit f455fee41c07 ("ping: also bind the ICMP socket
> to the specific device") in 2016, which is why our rp_filter tests
> started to fail.  See [2] .
> 
> Fixing the tests while keeping everything in one netns turns out to be
> nontrivial.  Rework the tests and build the following topology:
> 
>  ┌─────────────────────────────┐    ┌─────────────────────────────┐
>  │  network namespace 1 (ns1)  │    │  network namespace 2 (ns2)  │
>  │                             │    │                             │
>  │  ┌────┐     ┌─────┐         │    │  ┌─────┐            ┌────┐  │
>  │  │ lo │<───>│veth1│<────────┼────┼─>│veth2│<──────────>│ lo │  │
>  │  └────┘     ├─────┴──────┐  │    │  ├─────┴──────┐     └────┘  │
>  │             │192.0.2.1/24│  │    │  │192.0.2.1/24│             │
>  │             └────────────┘  │    │  └────────────┘             │
>  └─────────────────────────────┘    └─────────────────────────────┘
> 
> Consider sending an ICMP_ECHO packet A in ns2.  Both source and
> destination IP addresses are 192.0.2.1, and we use strict mode rp_filter
> in both ns1 and ns2:
> 
>   1. A is routed to lo since its destination IP address is one of ns2's
>      local addresses (veth2);
>   2. A is redirected from lo's egress to veth2's egress using mirred;
>   3. A arrives at veth1's ingress in ns1;
>   4. A is redirected from veth1's ingress to lo's ingress, again, using
>      mirred;
>   5. In __fib_validate_source(), fib_info_nh_uses_dev() returns false,
>      since A was received on lo, but reverse path lookup says veth1;
>   6. However A is not dropped since we have relaxed this check for lo in
>      commit 66f8209547cc ("fib: relax source validation check for loopback
>      packets");
> 
> Making sure A is not dropped here in this corner case is the whole point
> of having this test.
> 
>   7. As A reaches the ICMP layer, an ICMP_ECHOREPLY packet, B, is
>      generated;
>   8. Similarly, B is redirected from lo's egress to veth1's egress (in
>      ns1), then redirected once again from veth2's ingress to lo's
>      ingress (in ns2), using mirred.
> 
> Also test "ping 127.0.0.1" from ns2.  It does not trigger the relaxed
> check in __fib_validate_source(), but just to make sure the topology
> works with loopback addresses.
> 
> Tested with ping from iputils 20210722-41-gf9fb573:
> 
> $ ./fib_tests.sh -t rp_filter
> 
> IPv4 rp_filter tests
>     TEST: rp_filter passes local packets		[ OK ]
>     TEST: rp_filter passes loopback packets		[ OK ]
> 
> [1] https://github.com/iputils/iputils/issues/55
> [2] https://github.com/iputils/iputils/commit/f455fee41c077d4b700a473b2f5b3487b8febc1d
> 
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Fixes: adb701d6cfa4 ("selftests: add a test case for rp_filter")
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> ---
> Change in v3:
>     - "ping -I dummy0 198.51.100.1" always work (David Ahern
>       <dsahern@gmail.com>); use a different approach instead
> 
> Change in v2:
>     - s/SOCK_ICMP/SOCK_DGRAM/ in commit message
> 
>  tools/testing/selftests/net/fib_tests.sh | 59 ++++++++++++++++++++----
>  1 file changed, 49 insertions(+), 10 deletions(-)
> 

Acked-by: David Ahern <dsahern@kernel.org>


