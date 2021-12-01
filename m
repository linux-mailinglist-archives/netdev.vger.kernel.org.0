Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F0C46549E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351955AbhLASD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244442AbhLASDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:03:54 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0C6C06175A;
        Wed,  1 Dec 2021 10:00:28 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso36330463otf.12;
        Wed, 01 Dec 2021 10:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nNVvEOq93JWamao+YcMq3xOX4iABQzAW3EEbbTihUNM=;
        b=VH7t2cbohM97lC3HGUQUJ817xIGaAfG2iELCzfbTbuOqaz/TmthSdNbW4quNai1twf
         w7m+dj7tn2ct3BM3wBi84n3EnKJoxy67iFmsfLE2nHRs+FHPBpa2rpQd0btc759YeglG
         J9FAkCoiQgSOIyFU5tGV7Qh68U4KcLsseGxCG3XBpN31Stj/J9i7OTgMTfmVzEqUdqHR
         MI4SzLH18Ad+QAZuYwup5gNIlorvUK4rjfT+m8ipl2igcJ+yN6iJ3mbLcgvXnDu9iD5u
         +61xMmkN9dSjqzdpXjOSErGIDURdGldKNcV12ZU6OppNYVGXOHtINTHmaPMl4+4e5gei
         BEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nNVvEOq93JWamao+YcMq3xOX4iABQzAW3EEbbTihUNM=;
        b=P5A+weGNE4Y6cXY5i2pflWoYyuCxzyjdwBNG5MXArnzA7k61BhFN+b131Qrrgcodqx
         j9J0SZQ0y3Ov/VIKEcBCi10VMrKRl3yNTNEJNQAgjBpqkYvUE7pMrjpuiXY1In5QM/JJ
         ZefDcim02yJVN8rOp8WiN8bS4NuOdwkM8hVTfmkwR6kf7FAFKT6gFHkYHFaeH0BYnAQn
         35nT4Q/a+uAAH0+cDWwb62c+N6O0geFHHmDA5DP6YguOiHcY0W39nBSCN/dIv2DNCva+
         x2nHbeFM7BX8cBECVAQ7lGL/8avlC5LjJ3/mLnKwP2qx78XDO1iCz0FYjBd1w2XjEdIv
         Ro/w==
X-Gm-Message-State: AOAM533b689KbneUw89CfsR7UJPT8raG4KSgvrmvMWtnAeib8iw93MsR
        nalfN7tVtSLLqXo9G+KZYL0=
X-Google-Smtp-Source: ABdhPJz9EYrKK0WLxoTC42FdvhUK7xBT4nj/WMOlpSca1NcyLdWBMq2Qi93lN43PUxYRX2w7EER9cg==
X-Received: by 2002:a9d:2243:: with SMTP id o61mr7032643ota.126.1638381628140;
        Wed, 01 Dec 2021 10:00:28 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id j10sm139420ooq.5.2021.12.01.10.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 10:00:27 -0800 (PST)
Message-ID: <42b5ebde-2a36-3956-d6dd-bd50e18ff6dc@gmail.com>
Date:   Wed, 1 Dec 2021 11:00:26 -0700
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
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
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

if the intention of the tests is to validate that rp_filter = 1 works as
designed, then I suggest a simpler test. 2 namespaces, 2 veth pairs.
Request goes through one interface, and the response comes in the other
via routing in ns2. ns1 would see the response coming in the 'wrong'
interface and drops it.
