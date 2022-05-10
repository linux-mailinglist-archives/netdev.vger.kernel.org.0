Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6158E520B25
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiEJC2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiEJC16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:27:58 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DED92A8058;
        Mon,  9 May 2022 19:23:56 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id a76so12299550qkg.12;
        Mon, 09 May 2022 19:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oKlLxYSJQ12jeAEeOc1qpPaPdJSYUaGT8VpKDN2TBHA=;
        b=abroUBF7UPhuDpkUPmYiaDwMXsCGGv7YguScHd3WvsFhNQoGVskqkDTzKg8FvK2lhZ
         nPQlRAVy4jfJBIyszc1Eiy35e9O2BVf/S5+Rbn4jqgI90ihq4jTP4UomzULY35a4gtIs
         LUCi+qZxrioHp80p7ig96RNSbwpye6iuvW9N9nEuynPzHfnbZVezwWnxX4acggaiC5XK
         NJYvjnISlHcYWnHYHAZknfrhZzx93og67GF9+RQsHxT046bnequ12I7FiGPCCgE+myq1
         7QYSiIEyBciLmqn7rTynqvv9PPFibqmwpjt8rVXvcKUs8xCycY/NNGX9uTveByAb2MkO
         V6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oKlLxYSJQ12jeAEeOc1qpPaPdJSYUaGT8VpKDN2TBHA=;
        b=HJhUABaa0Xf3OMUiUFvzrHOVygCP8YAf0mdNepvqEEB0UTTWevD7wXxOGNNI7GHEly
         LYsjqFdAuclzfJ1SCWiJjZIZTp/DHRkp1lZL/bsYtDAwrlAqVhGOQYA0V/tD4ep7dNcd
         ed6X3idvNcKAXGT9zHAj3yuQmJmE34ZFmYRXs9ngLilM9AvzRIay7YgAi9uKlxAuYVOK
         o15zmzJF75nBQV9EC3+jBTfr6vR5mWaetvI/YafLFns6XcC+0IQo4fIfa/XXIsisb8+u
         7o6R51C5AO/v7uQ/t9++617uLSgRQuNbeJUd02l/QFD81yakuVG+hm/kNXJyXpq8V3Gf
         VRrg==
X-Gm-Message-State: AOAM5323dt67wOJWawAsumKUf0emW99ANdFHGg7IbT1DG8agfNexzwV1
        TZC7JlPrmY5A6NAB5/RJ5A==
X-Google-Smtp-Source: ABdhPJxuj9w4oKH7jesH2wEavL71pC0xMwMHJ2AIIUIQUkLJrKtbMlTt2iBU9Am66pViGZAF62anOA==
X-Received: by 2002:a37:5e04:0:b0:69f:5f20:4f3a with SMTP id s4-20020a375e04000000b0069f5f204f3amr14036818qkb.144.1652149435420;
        Mon, 09 May 2022 19:23:55 -0700 (PDT)
Received: from bytedance (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id a4-20020a05620a124400b0069fc13ce254sm7601374qkl.133.2022.05.09.19.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 19:23:54 -0700 (PDT)
Date:   Mon, 9 May 2022 19:23:50 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC v1 net-next 1/4] net: Introduce Qdisc backpressure
 infrastructure
Message-ID: <20220510022350.GA4619@bytedance>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <f4090d129b685df72070f708294550fbc513f888.1651800598.git.peilin.ye@bytedance.com>
 <CAA93jw4dFxwWCrhv98wwbPvM+UrAQKYRNbbSVp3UCp1zOnsD5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA93jw4dFxwWCrhv98wwbPvM+UrAQKYRNbbSVp3UCp1zOnsD5w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

On Mon, May 09, 2022 at 12:53:28AM -0700, Dave Taht wrote:
> I am very pleased to see this work.

Thanks!

> However,  my "vision" such as it was, and as misguided as it might be,
> was to implement a facility similar to tcp_notsent_lowat for udp
> packets, tracking the progress of the udp packet through the kernel,
> and supplying backpressure and providing better information about
> where when and why the packet was dropped in the stack back to the
> application.

By "a facility similar to tcp_notsent_lowat", do you mean a smaller
sk_sndbuf, or "UDP Small Queues"?

I don't fully understand the implications of using a smaller sk_sndbuf
yet, but I think it can work together with this RFC.

sk_sndbuf is a per-socket attribute, while this RFC tries to improve it
from Qdisc's perspective.  Using a smaller sk_sndbuf alone does not
prevent the "when UDP sends faster, TBF simply drops faster" issue
(described in [I] of the cover letter) from happening.  There's always a
point, that there're too many sockets, so TBF's queue cannot contain
"sk_sndbuf times number of sockets" (roughly speaking) bytes of skbs.
After that point, TBF will suddenly start to drop a lot.

For example, I used the default 212992 sk_sndbuf
(/proc/sys/net/core/wmem_default) in the test setup ([V] in the cover
letter).  Let's make it one tenth as large, 21299.  It works well for
the 2-client setup; zero packets dropped.  However, if we test it with
15 iperf2 clients:

[  3]  0.0-30.0 sec  46.4 MBytes  13.0 Mbits/sec   1.251 ms 89991/123091 (73%)
[  3]  0.0-30.0 sec  46.6 MBytes  13.0 Mbits/sec   2.033 ms 91204/124464 (73%)
[  3]  0.0-30.0 sec  46.5 MBytes  13.0 Mbits/sec   0.504 ms 89879/123054 (73%)
<...>                                                       ^^^^^^^^^^^^ ^^^^^

73% drop rate again.  Now apply this RFC:

[  3]  0.0-30.0 sec  46.3 MBytes  12.9 Mbits/sec   1.206 ms  807/33839 (2.4%)
[  3]  0.0-30.0 sec  45.5 MBytes  12.7 Mbits/sec   1.919 ms  839/33283 (2.5%)
[  3]  0.0-30.0 sec  45.8 MBytes  12.8 Mbits/sec   2.521 ms  837/33508 (2.5%)
<...>                                                        ^^^^^^^^^ ^^^^^^

Down to 3% again.

Next, same 21299 sk_sndbuf, 20 iperf2 clients, without RFC:

[  3]  0.0-30.0 sec  34.5 MBytes  9.66 Mbits/sec   1.054 ms 258703/283342 (91%)
[  3]  0.0-30.0 sec  34.5 MBytes  9.66 Mbits/sec   1.033 ms 257324/281964 (91%)
[  3]  0.0-30.0 sec  34.5 MBytes  9.66 Mbits/sec   1.116 ms 257858/282500 (91%)
<...>                                                       ^^^^^^^^^^^^^ ^^^^^

91% drop rate.  Finally, apply RFC:

[  3]  0.0-30.0 sec  34.4 MBytes  9.61 Mbits/sec   0.974 ms 7982/32503 (25%)
[  3]  0.0-30.0 sec  34.1 MBytes  9.54 Mbits/sec   1.381 ms 7394/31732 (23%)
[  3]  0.0-30.0 sec  34.3 MBytes  9.58 Mbits/sec   2.431 ms 8149/32583 (25%)
<...>                                                       ^^^^^^^^^^ ^^^^^

The thundering herd probelm ([III] in the cover letter) surfaces, but
still an improvement.

In conclusion, assuming we are going to use smaller sk_sndbuf or "UDP
Small Queues", I think it doesn't replace this RFC, and vice versa.

> I've been really impressed by the DROP_REASON work and had had no clue
> prior to seeing all that instrumentation, where else packets might be
> dropped in the kernel.
> 
> I'd be interested to see what happens with sch_cake.

Sure, I will cover sch_cake in v2.

Thanks,
Peilin Ye

