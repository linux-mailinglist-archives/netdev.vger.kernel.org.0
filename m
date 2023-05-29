Return-Path: <netdev+bounces-6056-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B94107148F7
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C73D1C209CC
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC666FB2;
	Mon, 29 May 2023 11:58:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFB96AB0
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 11:58:54 +0000 (UTC)
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3333DC9
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 04:58:52 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 41be03b00d2f7-53f6a6d3944so1010174a12.3
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 04:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685361531; x=1687953531;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DVUU/8MTlqkun0CdJoQ90yYJzG1uqvq8Y3tdJ1vCCh8=;
        b=dPmWgjQXae6LS5gcZkgt0C7BneH7B4v1QHs/meUjE6fT0mJnYsnwtzoF3AiWM1RrGo
         +C7UG7Ge3bQNSvm0cVmtj+ST2yFh1alt59mSxPLsPiXIjINokwQLVsFCqQI6c44cWlU1
         W+ZRW7c8/TTY62cl1VXrq3S/HkShohWCimJy4RWnFR646d3xRiZ5EsP2vHX4pDwtp7po
         FBJRfnB0WCWlbdBB4Wljc1QSKbiznicPUerUPNSJjChnq6a9s6/OBC8MP5EtMNnY1SUU
         vtkdTkOxfJM3mHKWSLp+9zdm7Fsevb0hllm1Ey0e6KT3Yr5mOym7MH8T/R9QlcD7ysfz
         ClsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685361531; x=1687953531;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DVUU/8MTlqkun0CdJoQ90yYJzG1uqvq8Y3tdJ1vCCh8=;
        b=MCxFs7Z1JEXb+OlhQdX9Q5g/1/h7B97IzW6jpyA2tMooeYxy/xfAWdkgSAVSjfmmA0
         5c2rpQpK2T+QQIgee3EHL1rjPJq+BhIOXoIcK00m7KRr/Rnfz6a/IbVjc+XevocsJ2Mz
         lPc2D6k5mO43ZBMtJURterdSquj1a2MPzjcO77N3CRxQ5+eKNCFKu571JZT/yLi4/yf2
         9WMXqc1LlgfQKEgMOSCAQ9fanGXDVxHvXiODM+BjJhoPMm2agfOtm6VMIhiziRAKz6gE
         Aw07NAsv0HOBbn3yo9zUJGB2L7Wni13/gSGWFlvJ8btLihOzyBJdjj9NCRViugyBMCbj
         Ywpg==
X-Gm-Message-State: AC+VfDwbPn0XwCxYgALIk8gDBvSHJm2sxGJvzkXkTa7rw5HunL7H8rcc
	wWcVqTksuc0+eai/i4PO9U7Jh1D+H6+TC0vxWFw=
X-Google-Smtp-Source: ACHHUZ7prsvyzTK5AyaMOYRDPP1hgY/k4VEWuhTNysi3CDUBHAke+4LlMM+IcDr0dp9HHHykOyKZWQ==
X-Received: by 2002:a17:90a:ea81:b0:256:6e9b:1398 with SMTP id h1-20020a17090aea8100b002566e9b1398mr3873579pjz.2.1685361531311;
        Mon, 29 May 2023 04:58:51 -0700 (PDT)
Received: from [10.94.58.170] ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090ab88e00b00252d960a8dfsm8654085pjr.16.2023.05.29.04.58.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 04:58:50 -0700 (PDT)
Message-ID: <73b1381e-6a59-26fe-c0b6-51ea3ebf60f8@bytedance.com>
Date: Mon, 29 May 2023 19:58:45 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: [PATCH v2 3/4] sock: Consider memcg pressure when raising sockmem
To: Shakeel Butt <shakeelb@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Glauber Costa <glommer@parallels.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
 <20230522070122.6727-4-wuyun.abel@bytedance.com>
 <20230525012259.qd6i6rtqvvae3or7@google.com>
Content-Language: en-US
In-Reply-To: <20230525012259.qd6i6rtqvvae3or7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Shakeel, thanks for reviewing! And sorry for replying so late,
I was on a vocation :)

On 5/25/23 9:22 AM, Shakeel Butt wrote:
> On Mon, May 22, 2023 at 03:01:21PM +0800, Abel Wu wrote:
>> For now __sk_mem_raise_allocated() mainly considers global socket
>> memory pressure and allows to raise if no global pressure observed,
>> including the sockets whose memcgs are in pressure, which might
>> result in longer memcg memstall.
>>
>> So take net-memcg's pressure into consideration when allocating
>> socket memory to alleviate long tail latencies.
>>
>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> 
> Hi Abel,
> 
> Have you seen any real world production issue which is fixed by this
> patch or is it more of a fix after reading code?

The latter. But we do observe one common case in the production env
that p2p service, which mainly downloads container images, running
inside a container with tight memory limit can easily be throttled and
keep memstalled for a long period of time and sometimes even be OOM-
killed. This service shows burst usage of TCP memory and I think it
indeed needs suppressing sockmem allocation if memcg is already under
pressure. The memcg pressure is usually caused by too many page caches
and the dirty ones starting to be wrote back to slow backends. So it
is insane to continuously receive net data to consume more memory.

> 
> This code is quite subtle and small changes can cause unintended
> behavior changes. At the moment the tcp memory accounting and memcg
> accounting is intermingled and I think we should decouple them.

My original intention to post this patchset is to clarify that:

   - proto pressure only considers sysctl_mem[] (patch 2)
   - memcg pressure only indicates the pressure inside itself
   - consider both whenever needs allocation or reclaim (patch 1,3)

In this way, the two kinds of pressure maintain purer semantics, and
socket core can react on both of them properly and consistently.

> 
>> ---
>>   net/core/sock.c | 23 ++++++++++++++++-------
>>   1 file changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index 801df091e37a..7641d64293af 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -2977,21 +2977,30 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>>   {
>>   	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
>>   	struct proto *prot = sk->sk_prot;
>> -	bool charged = true;
>> +	bool charged = true, pressured = false;
>>   	long allocated;
>>   
>>   	sk_memory_allocated_add(sk, amt);
>>   	allocated = sk_memory_allocated(sk);
>> -	if (memcg_charge &&
>> -	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
>> -						gfp_memcg_charge())))
>> -		goto suppress_allocation;
>> +
>> +	if (memcg_charge) {
>> +		charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
>> +						  gfp_memcg_charge());
>> +		if (!charged)
>> +			goto suppress_allocation;
>> +		if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
> 
> The memcg under pressure callback does a upward memcg tree walk, do
> please make sure you have tested the performance impact of this.

Yes, I have tested several benchmarks on a dual socket machine modeled
Intel Xeon(R) Platinum 8260 with SNC disabled, that is 2 NUMA nodes each
of which has 24C/48T. All the benchmarks are done inside a separate
cgroup in a clean host. Below shows the result of tbench4 and netperf:

tbench4 Throughput (misleading but traditional)
                             baseline               patchset
Hmean     1        377.62 (   0.00%)      375.06 *  -0.68%*
Hmean     2        753.99 (   0.00%)      753.21 *  -0.10%*
Hmean     4       1503.50 (   0.00%)     1493.07 *  -0.69%*
Hmean     8       2941.43 (   0.00%)     2925.18 *  -0.55%*
Hmean     16      5637.59 (   0.00%)     5603.64 *  -0.60%*
Hmean     32      9042.90 (   0.00%)     9022.53 *  -0.23%*
Hmean     64     10530.55 (   0.00%)    10554.89 *   0.23%*
Hmean     128    24230.20 (   0.00%)    24424.74 *   0.80%*
Hmean     256    23798.21 (   0.00%)    23941.24 *   0.60%*
Hmean     384    23620.63 (   0.00%)    23569.54 *  -0.22%*

netperf-udp
                                    baseline               patchset
Hmean     send-64         281.99 (   0.00%)      274.50 *  -2.65%*
Hmean     send-128        556.70 (   0.00%)      545.82 *  -1.96%*
Hmean     send-256       1102.60 (   0.00%)     1091.21 *  -1.03%*
Hmean     send-1024      4180.48 (   0.00%)     4073.87 *  -2.55%*
Hmean     send-2048      7837.61 (   0.00%)     7707.12 *  -1.66%*
Hmean     send-3312     12157.49 (   0.00%)    11845.03 *  -2.57%*
Hmean     send-4096     14512.64 (   0.00%)    14156.45 *  -2.45%*
Hmean     send-8192     24015.40 (   0.00%)    23920.94 (  -0.39%)
Hmean     send-16384    39875.21 (   0.00%)    39696.67 (  -0.45%)
Hmean     recv-64         281.99 (   0.00%)      274.50 *  -2.65%*
Hmean     recv-128        556.70 (   0.00%)      545.82 *  -1.96%*
Hmean     recv-256       1102.60 (   0.00%)     1091.21 *  -1.03%*
Hmean     recv-1024      4180.48 (   0.00%)     4073.76 *  -2.55%*
Hmean     recv-2048      7837.61 (   0.00%)     7707.11 *  -1.67%*
Hmean     recv-3312     12157.49 (   0.00%)    11845.03 *  -2.57%*
Hmean     recv-4096     14512.62 (   0.00%)    14156.45 *  -2.45%*
Hmean     recv-8192     24015.29 (   0.00%)    23920.88 (  -0.39%)
Hmean     recv-16384    39873.93 (   0.00%)    39696.02 (  -0.45%)

netperf-tcp
                               baseline               patchset
Hmean     64        1777.05 (   0.00%)     1793.04 (   0.90%)
Hmean     128       3364.25 (   0.00%)     3451.05 *   2.58%*
Hmean     256       6309.21 (   0.00%)     6506.84 *   3.13%*
Hmean     1024     19571.52 (   0.00%)    19606.65 (   0.18%)
Hmean     2048     26467.00 (   0.00%)    26658.12 (   0.72%)
Hmean     3312     31312.36 (   0.00%)    31403.54 (   0.29%)
Hmean     4096     33263.37 (   0.00%)    33278.77 (   0.05%)
Hmean     8192     39961.82 (   0.00%)    40149.77 (   0.47%)
Hmean     16384    46065.33 (   0.00%)    46683.67 (   1.34%)

Except slight regression in netperf-udp, no obvious performance win
or loss. But as you reminded me of the cost of hierarchical behavior,
I re-tested the cases in a 5-level depth cgroup (originally 2-level),
and the results are:

tbench4 Throughput (misleading but traditional)
                             baseline               patchset
Hmean     1        361.93 (   0.00%)      367.58 *   1.56%*
Hmean     2        734.39 (   0.00%)      730.33 *  -0.55%*
Hmean     4       1426.82 (   0.00%)     1440.81 *   0.98%*
Hmean     8       2848.86 (   0.00%)     2860.87 *   0.42%*
Hmean     16      5436.72 (   0.00%)     5491.72 *   1.01%*
Hmean     32      8743.34 (   0.00%)     8913.27 *   1.94%*
Hmean     64     10345.41 (   0.00%)    10436.92 *   0.88%*
Hmean     128    23390.36 (   0.00%)    23353.09 *  -0.16%*
Hmean     256    23823.20 (   0.00%)    23509.79 *  -1.32%*
Hmean     384    23268.09 (   0.00%)    23178.10 *  -0.39%*

netperf-udp
                                    baseline               patchset
Hmean     send-64         278.31 (   0.00%)      275.68 *  -0.94%*
Hmean     send-128        554.52 (   0.00%)      547.46 (  -1.27%)
Hmean     send-256       1106.64 (   0.00%)     1103.01 (  -0.33%)
Hmean     send-1024      4135.84 (   0.00%)     4057.47 *  -1.89%*
Hmean     send-2048      7816.13 (   0.00%)     7732.71 *  -1.07%*
Hmean     send-3312     12068.32 (   0.00%)    11895.94 *  -1.43%*
Hmean     send-4096     14358.02 (   0.00%)    14304.06 (  -0.38%)
Hmean     send-8192     24041.57 (   0.00%)    24061.70 (   0.08%)
Hmean     send-16384    39996.09 (   0.00%)    39936.08 (  -0.15%)
Hmean     recv-64         278.31 (   0.00%)      275.68 *  -0.94%*
Hmean     recv-128        554.52 (   0.00%)      547.46 (  -1.27%)
Hmean     recv-256       1106.64 (   0.00%)     1103.01 (  -0.33%)
Hmean     recv-1024      4135.84 (   0.00%)     4057.47 *  -1.89%*
Hmean     recv-2048      7816.13 (   0.00%)     7732.71 *  -1.07%*
Hmean     recv-3312     12068.32 (   0.00%)    11895.94 *  -1.43%*
Hmean     recv-4096     14357.99 (   0.00%)    14304.04 (  -0.38%)
Hmean     recv-8192     24041.43 (   0.00%)    24061.58 (   0.08%)
Hmean     recv-16384    39995.72 (   0.00%)    39935.68 (  -0.15%)

netperf-tcp
                               baseline               patchset
Hmean     64        1779.93 (   0.00%)     1784.75 (   0.27%)
Hmean     128       3380.32 (   0.00%)     3424.14 (   1.30%)
Hmean     256       6383.37 (   0.00%)     6504.97 *   1.90%*
Hmean     1024     19345.07 (   0.00%)    19604.06 *   1.34%*
Hmean     2048     26547.60 (   0.00%)    26743.94 *   0.74%*
Hmean     3312     30948.40 (   0.00%)    31419.11 *   1.52%*
Hmean     4096     32888.83 (   0.00%)    33125.01 *   0.72%*
Hmean     8192     40020.38 (   0.00%)    39949.53 (  -0.18%)
Hmean     16384    46084.48 (   0.00%)    46300.43 (   0.47%)

Still no obvious difference, and even the udp regression is reduced.

Thanks & Best,
	Abel

