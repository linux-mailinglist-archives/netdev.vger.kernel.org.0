Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C553F2E2A
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 16:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240892AbhHTOfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 10:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240840AbhHTOfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 10:35:44 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA842C061575;
        Fri, 20 Aug 2021 07:35:06 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so14081964otf.6;
        Fri, 20 Aug 2021 07:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GlxWmdbgAhgJmRKW2WBD70lKJAM5EQ+Q7/SVNHfXJYU=;
        b=MH3z1wlry27pAZBCB6uADj1RpQ9eHcxli/CH1/h+DWmo/X0bkAB7bose6q+9g9jK4Q
         lgqqOjiQ6PlaASw5RdSY3Op1WU7jtEr6tfEQ+Oz02JR9EXOhdlDx973EaufZZkNVM5fM
         zhiKqTVLbAwOyYHkEl7rKZ6y0ZnhMoVKUxzNrf5bsJZjLdLa3m/gejLsVk1cAUtxuc2j
         WSrqBUnRLVLuuKRLFOqXI0sS2P8mvlfdRFSKVNrafLaKAJjAetCvtuQol1hF1gd8DZMC
         6kC3yAlTZutQjrQzEbUSlvIyEzdbrAoPK50QrnIRAH3SnGHdTE1IPgmOgHBZIfjBxlgQ
         nt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GlxWmdbgAhgJmRKW2WBD70lKJAM5EQ+Q7/SVNHfXJYU=;
        b=LuWrEXEWqaffYuuJK4gotas4+PD3Yo7SudgKOB3wpI3MGZyyBwkyAi2vhGlO4lJD89
         p+d2vO1LlyhxPhrAF14nx44FBJiaxn22fQOEVTrha9B8l7szmUfYP0urfvEZvEPG5hgg
         CreQm+v5zqVO9DOCYhvJOQWiNHdG8onvosn3n+Nooi9qRzJFG9O/T2mNNZzx5xHcGbE7
         FJ0FpOf9xZDYuq2vIBS2HPf/xZsmXukKDvImnQYtGBitkTVDINg1FifOsl7AQjbBWbtk
         gBnR3STuqGAVGf/G/c+V3zGUiwl8inzRva7DFesdFqRYUgENu00mXQCZ2k5YWIwe1lWn
         lMOQ==
X-Gm-Message-State: AOAM53168PJRz2kIzlfF9sf2xO9MZLKJ4xukAQTF11C7tGnOd/Y86mny
        mF/9en2PSiWQWTnpv30NltE=
X-Google-Smtp-Source: ABdhPJy5GhP51GEmWb65Io7iCYS1QZeW+fh4dgAJI0cEJOwJ83rhUYR9Ek7Ophet7YupVlODkZdEbQ==
X-Received: by 2002:a05:6830:438d:: with SMTP id s13mr17380105otv.288.1629470105979;
        Fri, 20 Aug 2021 07:35:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id a6sm1454392oto.36.2021.08.20.07.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 07:35:05 -0700 (PDT)
Subject: Re: [PATCH RFC 0/7] add socket to netdev page frag recycling support
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     alexander.duyck@gmail.com, linux@armlinux.org.uk, mw@semihalf.com,
        linuxarm@openeuler.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, thomas.petazzoni@bootlin.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        willy@infradead.org, vbabka@suse.cz, fenghua.yu@intel.com,
        guro@fb.com, peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, yhs@fb.com, kpsingh@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, chenhao288@hisilicon.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, memxor@gmail.com,
        linux@rempel-privat.de, atenart@kernel.org, weiwan@google.com,
        ap420073@gmail.com, arnd@arndb.de,
        mathew.j.martineau@linux.intel.com, aahringo@redhat.com,
        ceggers@arri.de, yangbo.lu@nxp.com, fw@strlen.de,
        xiangxia.m.yue@gmail.com, linmiaohe@huawei.com
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
 <83b8bae8-d524-36a1-302e-59198410d9a9@gmail.com>
 <f0d935b9-45fe-4c51-46f0-1f526167877f@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <619b5ca5-a48b-49e9-2fef-a849811d62bb@gmail.com>
Date:   Fri, 20 Aug 2021 08:35:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <f0d935b9-45fe-4c51-46f0-1f526167877f@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/21 2:18 AM, Yunsheng Lin wrote:
> On 2021/8/19 6:05, David Ahern wrote:
>> On 8/17/21 9:32 PM, Yunsheng Lin wrote:
>>> This patchset adds the socket to netdev page frag recycling
>>> support based on the busy polling and page pool infrastructure.
>>>
>>> The profermance improve from 30Gbit to 41Gbit for one thread iperf
>>> tcp flow, and the CPU usages decreases about 20% for four threads
>>> iperf flow with 100Gb line speed in IOMMU strict mode.
>>>
>>> The profermance improve about 2.5% for one thread iperf tcp flow
>>> in IOMMU passthrough mode.
>>>
>>
>> Details about the test setup? cpu model, mtu, any other relevant changes
>> / settings.
> 
> CPU is arm64 Kunpeng 920, see:
> https://www.hisilicon.com/en/products/Kunpeng/Huawei-Kunpeng-920
> 
> mtu is 1500, the relevant changes/settings I can think of the iperf
> client runs on the same numa as the nic hw exists(which has one 100Gbit
> port), and the driver has the XPS enabled too.
> 
>>
>> How does that performance improvement compare with using the Tx ZC API?
>> At 1500 MTU I see a CPU drop on the Tx side from 80% to 20% with the ZC
>> API and ~10% increase in throughput. Bumping the MTU to 3300 and
>> performance with the ZC API is 2x the current model with 1/2 the cpu.
> 
> I added a sysctl node to decide whether pfrag pool is used:
> net.ipv4.tcp_use_pfrag_pool
> 
> and use msg_zerocopy to compare the result:
> Server uses cmd "./msg_zerocopy -4 -i eth4 -C 32 -S 192.168.100.2 -r tcp"
> Client uses cmd "./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -"
> 
> The zc does seem to improve the CPU usages significantly, but not for throughput
> with mtu 1500. And the result seems to be similar with mtu 3300.
> 
> the detail result is below:
> 
> (1) IOMMU strict mode + net.ipv4.tcp_use_pfrag_pool = 0:
> root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp
> tx=115317 (7196 MB) txc=0 zc=n
> 
>  Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp':
> 
>         4315472244      cycles
> 
>        4.199890190 seconds time elapsed
> 
>        0.084328000 seconds user
>        1.528714000 seconds sys
> root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z
> tx=90121 (5623 MB) txc=90121 zc=y
> 
>  Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z':
> 
>         1715892155      cycles
> 
>        4.243329050 seconds time elapsed
> 
>        0.083275000 seconds user
>        0.755355000 seconds sys
> 
> 
> (2)IOMMU strict mode + net.ipv4.tcp_use_pfrag_pool = 1:
> root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp
> tx=138932 (8669 MB) txc=0 zc=n
> 
>  Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp':
> 
>         4034016168      cycles
> 
>        4.199877510 seconds time elapsed
> 
>        0.058143000 seconds user
>        1.644480000 seconds sys
> root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z
> tx=93369 (5826 MB) txc=93369 zc=y
> 
>  Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z':
> 
>         1815300491      cycles
> 
>        4.243259530 seconds time elapsed
> 
>        0.051767000 seconds user
>        0.796610000 seconds sys
> 
> 
> (3)IOMMU passthrough + net.ipv4.tcp_use_pfrag_pool=0
> root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp
> tx=129927 (8107 MB) txc=0 zc=n
> 
>  Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp':
> 
>         3720131007      cycles
> 
>        4.200651840 seconds time elapsed
> 
>        0.038604000 seconds user
>        1.455521000 seconds sys
> root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z
> tx=135285 (8442 MB) txc=135285 zc=y
> 
>  Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z':
> 
>         1721949875      cycles
> 
>        4.242596800 seconds time elapsed
> 
>        0.024963000 seconds user
>        0.779391000 seconds sys
> 
> (4)IOMMU  passthrough + net.ipv4.tcp_use_pfrag_pool=1
> root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp
> tx=151844 (9475 MB) txc=0 zc=n
> 
>  Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp':
> 
>         3786216097      cycles
> 
>        4.200606520 seconds time elapsed
> 
>        0.028633000 seconds user
>        1.569736000 seconds sys
> 
> 
>>
>> Epyc 7502, ConnectX-6, IOMMU off.
>>
>> In short, it seems like improving the Tx ZC API is the better path
>> forward than per-socket page pools.
> 
> The main goal is to optimize the SMMU mapping/unmaping, if the cost of memcpy
> it higher than the SMMU mapping/unmaping + page pinning, then Tx ZC may be a
> better path, at leas it is not sure for small packet?
> 

It's a CPU bound problem - either Rx or Tx is cpu bound depending on the
test configuration. In my tests 3.3 to 3.5M pps is the limit (not using
LRO in the NIC - that's a different solution with its own problems).

At 1500 MTU lowering CPU usage on the Tx side does not accomplish much
on throughput since the Rx is 100% cpu.

At 3300 MTU you have ~47% the pps for the same throughput. Lower pps
reduces Rx processing and lower CPU to process the incoming stream. Then
using the Tx ZC API you lower the Tx overehad allowing a single stream
to faster - sending more data which in the end results in much higher
pps and throughput. At the limit you are CPU bound (both ends in my
testing as Rx side approaches the max pps, and Tx side as it continually
tries to send data).

Lowering CPU usage on Tx the side is a win regardless of whether there
is a big increase on the throughput at 1500 MTU since that configuration
is an Rx CPU bound problem. Hence, my point that we have a good start
point for lowering CPU usage on the Tx side; we should improve it rather
than add per-socket page pools.

You can stress the Tx side and emphasize its overhead by modifying the
receiver to drop the data on Rx rather than copy to userspace which is a
huge bottleneck (e.g., MSG_TRUNC on recv). This allows the single flow
stream to go faster and emphasize Tx bottlenecks as the pps at 3300
approaches the top pps at 1500. e.g., doing this with iperf3 shows the
spinlock overhead with tcp_sendmsg, overhead related to 'select' and
then gup_pgd_range.
