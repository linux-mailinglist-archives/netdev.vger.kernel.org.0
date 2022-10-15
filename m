Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF145FFBE4
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 22:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiJOUTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 16:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiJOUT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 16:19:29 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F32617F
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 13:19:25 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id n74so9236417yba.11
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 13:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ciDhtiegpS4RkfVVGCrLfsFbeRo9HvHH63KoV4uVYpk=;
        b=kCJfb0RCuI4cWoyE5B39mlbFeQcvkywot86WKotv7zFnuMg0j4sIVLaZXXViHp6/tL
         fQn76Hv3JAyOGlwq7/E1UNwTmDZR2CAP4+c1iZjh9rBzdXd/crzGal9NptWTSlcldn3n
         5VQFx+CzuISy3hCU1abWVm76vyx5WZ3tS5SfdDyS/xEmfse1gKg/hYHP8jIjgrYppJdc
         jNXDA52oTWiycCaG/2K04XS0f/R74TlDh1om5rxW9Lz7wFrjSPsKR7K+rSK+E5XN9jWb
         d0z4Ji5Njz7cf3uXdig/EP2zA/5AvJFYFGMnygmxlFHY75e0X9JpMo6nwaQ9DhcMSdWB
         fWKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ciDhtiegpS4RkfVVGCrLfsFbeRo9HvHH63KoV4uVYpk=;
        b=fpQR6YY76953/n4XveA6S7A4ohtu5rw+Gmu2rstZOd/iTjLXhtYBI/FEhPsJZMpduN
         s3jSKW2235EtgZS+MBkrymgtPmQmgKIBZqCkFd7xNN3oB36avFptazsk88xM2HjghNm4
         eYBvOUv2k561WvA0rFdY6sFkVGWtg7d0k+6WhSOKBG94lcJUXONNteWMDpf1n7/6uprw
         ed3tXUqG0Mhmxjc1t0+Gf833sSc9oiUHo5cgRzCRBfoK9CgqTVTT+naX8O9Q7xWDEd4B
         NBsM6q+SHjenNy4XOLj4DWUl/TqntCbUkMN4cOdFCEngKkdMkjRXPPjYxTDTRRtwmUTc
         HvmQ==
X-Gm-Message-State: ACrzQf31N6YVVRz7L5nLr4dByQk1qQWKRN4tWthL/vWzhXCkRcJFjqI+
        W1AxfegqwbFKAKSS1LUWtrzMAn9kFgpb4CKyFbi2Qg==
X-Google-Smtp-Source: AMsMyM4qeGLFIva/WV2bBZ0li53264UVW4uyMPGP02QJIy8kmbxzJaQRiGPovmqyNL/7cBR7tUikN84391fkLxGDSK8=
X-Received: by 2002:a25:3187:0:b0:6c1:822b:eab1 with SMTP id
 x129-20020a253187000000b006c1822beab1mr3224115ybx.427.1665865164901; Sat, 15
 Oct 2022 13:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-7-eric.dumazet@gmail.com> <684c6220-9288-3838-a938-0792b57c5968@amd.com>
 <CANn89iKpaJsqeMDQYySmUr2=n8D+dyXKtK0u7hF_8kW10mMm1A@mail.gmail.com> <e9ad936f-a091-e3ed-3e18-335bc0ff009e@amd.com>
In-Reply-To: <e9ad936f-a091-e3ed-3e18-335bc0ff009e@amd.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 15 Oct 2022 13:19:13 -0700
Message-ID: <CANn89iJF2sWcxEJQF8SN4+VuAfVGUmP-s7qFXZEGYJH28iQLWQ@mail.gmail.com>
Subject: Re: [PATCH net-next 6/7] net: keep sk->sk_forward_alloc as small as possible
To:     K Prateek Nayak <kprateek.nayak@amd.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Gautham Shenoy <gautham.shenoy@amd.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chen Yu <yu.c.chen@intel.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Yicong Yang <yangyicong@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 1:30 AM K Prateek Nayak <kprateek.nayak@amd.com> wrote:
>
> Hello Eric,
...
>
> Following are the results:
>
> Clients:      good                 good + series         good  +series + larger wmem
>     1    574.93 (0.00 pct)       554.42 (-3.56 pct)      552.92 (-3.82 pct)
>     2    1135.60 (0.00 pct)      1034.76 (-8.87 pct)     1036.94 (-8.68 pct)
>     4    2117.29 (0.00 pct)      1796.97 (-15.12 pct)    1539.21 (-27.30 pct)
>     8    3799.57 (0.00 pct)      3020.87 (-20.49 pct)    2797.98 (-26.36 pct)
>    16    6129.79 (0.00 pct)      4536.99 (-25.98 pct)    4301.20 (-29.83 pct)
>    32    11630.67 (0.00 pct)     8674.74 (-25.41 pct)    8199.28 (-29.50 pct)
>    64    20895.77 (0.00 pct)     14417.26 (-31.00 pct)   14473.34 (-30.73 pct)
>   128    31989.55 (0.00 pct)     20611.47 (-35.56 pct)   19671.08 (-38.50 pct)
>   256    56388.57 (0.00 pct)     48822.72 (-13.41 pct)   48455.77 (-14.06 pct)
>   512    59326.33 (0.00 pct)     43960.03 (-25.90 pct)   43968.59 (-25.88 pct)
>  1024    58281.10 (0.00 pct)     41256.18 (-29.21 pct)   40550.97 (-30.42 pct)
>
> Given the message size is small, I think wmem size does not
> impact the benchmark results much.

Hmmm.

tldr; I can not really repro the issues (tested on AMD EPYC 7B12,
NPS1) with CONFIG_PREEMPT_NONE=y

sendmsg(256 bytes)
    grab 4096 bytes forward allocation from sk->sk_prot->per_cpu_fw_alloc
   send skb, softirq handler immediately sends ACK back, and queues
the packet into receiver socket (also grabbing bytes from
sk->sk_prot->per_cpu_fw_alloc)
     ACK releases the 4096 bytes to per-cpu
sk->sk_prot->per_cpu_fw_alloc on sender TCP socket

per_cpu_fw_alloc have a 1MB cushion (per cpu), not sure why it is not
enough in your case.
Worst case would be one dirtying of tcp_memory_allocated every ~256 messages,
but in more common cases we dirty this cache less often...

I wonder if NPS2/NPS4 could land per-cpu variables into the wrong NUMA
node maybe ?
(or on NPS1, incorrect NUMA information on your platform ?)
Or maybe the small changes are enough for your system to hit a cliff.
AMD systems are quite sensitive to mem-bw saturation.

 I ran the following on an AMD host (NPS1) with two physical cpu (256 HT total)

for i in 1 2 4 8 16 32 64 128 192 256; do echo -n $i: ;
./super_netperf $i -H ::1 -l 10 -- -m 256 -M 256; done

Before patch series ( 5c281b4e529c )
1:   6956
2:  14169
4:  28311
8:  56519
16: 113621
32: 225317
64: 341658
128: 475131
192: 304515
256: 181754

After patch series, to me this looks very close or even much better at
high number of threads.
1:   6963
2:  14166
4:  28095
8:  56878
16: 112723
32: 202417
64: 266744
128: 482031
192: 317876
256: 293169

And if we look at "ss -tm" while tests are running, it is clearly
visible that the old kernels were pretty bad in terms of memory
control.

Old kernel:
ESTAB        0              55040
[::1]:39474                                                [::1]:32891
skmem:(r0,rb540000,t0,tb10243584,f1167104,w57600,o0,bl0,d0)
ESTAB        36864          0
[::1]:37733                                                [::1]:54752
skmem:(r55040,rb8515000,t0,tb2626560,f1710336,w0,o0,bl0,d0)

These two sockets were holding 1167104+1710336 bytes of forward
allocations, just to 'be efficient'
Now think of servers with millions of TCP sockets :/

New kernel : No more extra forward allocations above 4096 bytes.
sk_forward_alloc only holds the reminder of allocations,
because memcg/tcp_memory_allocated granularity is in pages.

ESTAB   35328     0                             [::1]:36493
                           [::1]:41394
skmem:(r46848,rb7467000,t0,tb2626560,f2304,w0,o0,bl0,d0)
ESTAB   0         54272                         [::1]:58680
                           [::1]:47859
skmem:(r0,rb540000,t0,tb6829056,f512,w56832,o0,bl0,d0)

Only when enabling CONFIG_PREEMPT=y I had some kind of spinlock contention
in scheduler/rcu layers, making test results very flaky.
