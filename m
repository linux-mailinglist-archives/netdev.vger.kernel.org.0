Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FAA5692AD
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 21:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiGFTiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 15:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiGFTiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 15:38:10 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1965D2A953
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 12:38:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d16so17112666wrv.10
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 12:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qETAhYUrK177HTD/DlF9wwCWDkKHRfE9hTjo/UTYyZo=;
        b=oyZE9vj5I9QHBWgQg6UuVzFbuB4AZv9urJptbprgrdPL/g+GErRw/wvNz+YXktKPkJ
         FG4TuPOoIGsbc6QKPMffQFEHO2j0+u6YCBb/rpU9/QLRhoixVPeqdbxPpRvrT+aDWr2+
         6ppPA0WyMzYWJQvqh2OD4IuXJbjOHpJRFj4u07tQvJJWgs87W3X+EcQekyo1NyB8yZ1o
         oIyoXSn93fc4nOKunsibMKa6/ZCnrSVAHpF3yzA0zJBW+2Fgt9hCN9N6KYuh9G20hJfl
         9jYwJUjh1BHCV26q+QzrRK+VnWihvytrOP7z0HkEntzzQtoih8vSS3pNDED7fSNNz25x
         kCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qETAhYUrK177HTD/DlF9wwCWDkKHRfE9hTjo/UTYyZo=;
        b=ocOftxEPCwLW8v9ipnXuuModVf9qqDGMxSvr/0r3OBGCUSLDSMc6Nr2oPilH9JEJd5
         T2K2vz4dse/TGNlQem7qBBJ6MCvtyeeRezivYjpT6ZoIBUPKs1PbTmn0EY8y0iicd+ou
         qzlK1SPpgmuZPMfVAGNA9+I3j7wcz4WPxVsTJEFMEiPv8GxW1cQA+0PPtNPlQLK9Mnxk
         8/LKEiyWtcvHId8895UkXIZxl+vajvyd2gVm/u6QO/Maivp/twR+b0Nb2PtPUcBOrPAi
         Zk5O6Iu8qTlpW2zrO3pedOiA2mYwnWE18WDDT7UzfaIHuGPi3deg3zWEwtE8McFh29L2
         q0YA==
X-Gm-Message-State: AJIora+ab5YOkZEfPGoSbJqzqBDJiJKcrA9D+XrxSkL9fLcTXMjnRXax
        sBK4dC2QHDsGzNRnxJsxgo8gOsZnmD64vRXFdFA=
X-Google-Smtp-Source: AGRyM1uLwIdS6ogpE3kh1a7hkkjNQG1j2BDgg9Z0idkFXrt2r7DjiAA6EpcAhHyR3+Gjyxi5y+Rp2A==
X-Received: by 2002:a05:6000:184f:b0:21c:ae47:9b45 with SMTP id c15-20020a056000184f00b0021cae479b45mr42296964wri.76.1657136286361;
        Wed, 06 Jul 2022 12:38:06 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id l2-20020a05600c2cc200b003a18e7a5af2sm20561033wmc.34.2022.07.06.12.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 12:38:05 -0700 (PDT)
Message-ID: <7cf30a3e-a562-d582-4391-072a2c98ab05@blackwall.org>
Date:   Wed, 6 Jul 2022 22:38:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
 <86zgj6oqa9.fsf@gmail.com>
 <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
 <86fskyggdo.fsf@gmail.com>
 <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org>
 <86v8tu7za3.fsf@gmail.com>
 <4bf1c80d-0f18-f444-3005-59a45797bcfd@blackwall.org>
 <20220706181316.r5l5rzjysxow2j7l@skbuf>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220706181316.r5l5rzjysxow2j7l@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2022 21:13, Vladimir Oltean wrote:
> Hi Nikolay,
> 
> On Wed, May 25, 2022 at 01:18:49PM +0300, Nikolay Aleksandrov wrote:
>>>>>>>> Hi Hans,
>>>>>>>> So this approach has a fundamental problem, f->dst is changed without any synchronization
>>>>>>>> you cannot rely on it and thus you cannot account for these entries properly. We must be very
>>>>>>>> careful if we try to add any new synchronization not to affect performance as well.
>>>>>>>> More below...
>>>>>>>>
>>>>>>>>> @@ -319,6 +326,9 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>>>>>>>  	if (test_bit(BR_FDB_STATIC, &f->flags))
>>>>>>>>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>>>>>>>>  
>>>>>>>>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &f->flags) && !test_bit(BR_FDB_OFFLOADED, &f->flags))
>>>>>>>>> +		atomic_dec(&f->dst->locked_entry_cnt);
>>>>>>>>
>>>>>>>> Sorry but you cannot do this for multiple reasons:
>>>>>>>>  - f->dst can be NULL
>>>>>>>>  - f->dst changes without any synchronization
>>>>>>>>  - there is no synchronization between fdb's flags and its ->dst
>>>>>>>>
>>>>>>>> Cheers,
>>>>>>>>  Nik
>>>>>>>
>>>>>>> Hi Nik,
>>>>>>>
>>>>>>> if a port is decoupled from the bridge, the locked entries would of
>>>>>>> course be invalid, so maybe if adding and removing a port is accounted
>>>>>>> for wrt locked entries and the count of locked entries, would that not
>>>>>>> work?
>>>>>>>
>>>>>>> Best,
>>>>>>> Hans
>>>>>>
>>>>>> Hi Hans,
>>>>>> Unfortunately you need the correct amount of locked entries per-port if you want
>>>>>> to limit their number per-port, instead of globally. So you need a
>>>>>> consistent
>>>>>
>>>>> Hi Nik,
>>>>> the used dst is a port structure, so it is per-port and not globally.
>>>>>
>>>>> Best,
>>>>> Hans
>>>>>
>>>>
>>>> Yeah, I know. :) That's why I wrote it, if the limit is not a feature requirement I'd suggest
>>>> dropping it altogether, it can be enforced externally (e.g. from user-space) if needed.
>>>>
>>>> By the way just fyi net-next is closed right now due to merge window. And one more
>>>> thing please include a short log of changes between versions when you send a new one.
>>>> I had to go look for v2 to find out what changed.
>>>>
>>>
>>> Okay, I will drop the limit in the bridge module, which is an easy thing
>>> to do. :) (It is mostly there to ensure against DOS attacks if someone
>>> bombards a locked port with random mac addresses.)
>>> I have a similar limitation in the driver, which should then probably be
>>> dropped too?
>>>
>>
>> That is up to you/driver, I'd try looking for similar problems in other switch drivers
>> and check how those were handled. There are people in the CC above that can
>> directly answer that. :)
> 
> Not sure whom you're referring to?

I meant people who have dealt with hardware resource management in the drivers.

> 
> In fact I was pretty sure that I didn't see any OOM protection in the
> source code of the Linux bridge driver itself either, so I wanted to
> check that for myself, so I wrote a small "killswitch" program that's
> supposed to, well, kill a switch. It took me a while to find a few free
> hours to do the test, sorry for that.
> 
> https://github.com/vladimiroltean/killswitch/blob/master/src/killswitch.c
> 
> Sure enough, I can kill a Marvell Armada 3720 device with 1GB of RAM
> within 3 minutes of running the test program.
> 

I don't think that is new or surprising, if there isn't anything to control the
device resources you'll get there. You don't really need to write any new programs
you can easily do it with mausezahn. I have tests that add over 10 million fdbs on
devices for a few seconds.

The point is it's not the bridge's task to limit memory consumption or to watch for resource
management. You can limit new entries from the device driver (in case of swdev learning) or
you can use a daemon to watch the number of entries and disable learning. There are many
different ways to avoid this. We've discussed it before and I don't mind adding a hard fdb
per-port limit in the bridge as long as it's done properly. We've also discussed LRU and similar
algorithms for fdb learning and eviction. But any hardcoded limits or limits that can break
current default use cases are unacceptable, they must be opt-in.

> [  273.864203] ksoftirqd/0: page allocation failure: order:0, mode:0x40a20(GFP_ATOMIC|__GFP_COMP), nodemask=(null),cpuset=/,mems_allowed=0
> [  273.876426] CPU: 0 PID: 12 Comm: ksoftirqd/0 Not tainted 5.18.7-rc1-00013-g52b92343db13 #74
> [  273.884775] Hardware name: CZ.NIC Turris Mox Board (DT)
> [  273.889994] Call trace:
> [  273.892437]  dump_backtrace.part.0+0xc8/0xd4
> [  273.896721]  show_stack+0x18/0x70
> [  273.900039]  dump_stack_lvl+0x68/0x84
> [  273.903703]  dump_stack+0x18/0x34
> [  273.907017]  warn_alloc+0x114/0x1a0
> [  273.910508]  __alloc_pages+0xbb0/0xbe0
> [  273.914257]  cache_grow_begin+0x60/0x300
> [  273.918183]  fallback_alloc+0x184/0x220
> [  273.922017]  ____cache_alloc_node+0x174/0x190
> [  273.926373]  kmem_cache_alloc+0x1a4/0x220
> [  273.930381]  fdb_create+0x40/0x430
> [  273.933784]  br_fdb_update+0x198/0x210
> [  273.937532]  br_handle_frame_finish+0x244/0x530
> [  273.942063]  br_handle_frame+0x1c0/0x270
> [  273.945986]  __netif_receive_skb_core.constprop.0+0x29c/0xd30
> [  273.951734]  __netif_receive_skb_list_core+0xe8/0x210
> [  273.956784]  netif_receive_skb_list_internal+0x180/0x29c
> [  273.962091]  napi_gro_receive+0x174/0x190
> [  273.966099]  mvneta_rx_swbm+0x6b8/0xb40
> [  273.969935]  mvneta_poll+0x684/0x900
> [  273.973506]  __napi_poll+0x38/0x18c
> [  273.976988]  net_rx_action+0xe8/0x280
> [  273.980643]  __do_softirq+0x124/0x2a0
> [  273.984299]  run_ksoftirqd+0x4c/0x60
> [  273.987871]  smpboot_thread_fn+0x23c/0x270
> [  273.991963]  kthread+0x10c/0x110
> [  273.995188]  ret_from_fork+0x10/0x20
> 
> (followed by lots upon lots of vomiting, followed by ...)
> 
> [  311.138590] Out of memory and no killable processes...
> [  311.143774] Kernel panic - not syncing: System is deadlocked on memory
> [  311.150295] CPU: 0 PID: 6 Comm: kworker/0:0 Not tainted 5.18.7-rc1-00013-g52b92343db13 #74
> [  311.158550] Hardware name: CZ.NIC Turris Mox Board (DT)
> [  311.163766] Workqueue: events rht_deferred_worker
> [  311.168477] Call trace:
> [  311.170916]  dump_backtrace.part.0+0xc8/0xd4
> [  311.175188]  show_stack+0x18/0x70
> [  311.178501]  dump_stack_lvl+0x68/0x84
> [  311.182159]  dump_stack+0x18/0x34
> [  311.185466]  panic+0x168/0x328
> [  311.188515]  out_of_memory+0x568/0x584
> [  311.192261]  __alloc_pages+0xb04/0xbe0
> [  311.196006]  __alloc_pages_bulk+0x15c/0x604
> [  311.200185]  alloc_pages_bulk_array_mempolicy+0xbc/0x24c
> [  311.205491]  __vmalloc_node_range+0x238/0x550
> [  311.209843]  __vmalloc_node_range+0x1c0/0x550
> [  311.214195]  kvmalloc_node+0xe0/0x124
> [  311.217856]  bucket_table_alloc.isra.0+0x40/0x150
> [  311.222554]  rhashtable_rehash_alloc.isra.0+0x20/0x8c
> [  311.227599]  rht_deferred_worker+0x7c/0x540
> [  311.231775]  process_one_work+0x1d0/0x320
> [  311.235779]  worker_thread+0x70/0x440
> [  311.239435]  kthread+0x10c/0x110
> [  311.242661]  ret_from_fork+0x10/0x20
> [  311.246238] SMP: stopping secondary CPUs
> [  311.250161] Kernel Offset: disabled
> [  311.253642] CPU features: 0x000,00020009,00001086
> [  311.258338] Memory Limit: none
> [  311.261390] ---[ end Kernel panic - not syncing: System is deadlocked on memory ]---
> 
> That can't be quite alright? Shouldn't we have some sort of protection
> in the bridge itself too, not just tell hardware driver writers to deal
> with it? Or is it somewhere, but it needs to be enabled/configured?

This is expected, if you'd like feel free to add a hard learning limit in the driver
and the bridge (again if implemented properly).
Nothing can save you if someone has L2 access to the device, they can poison any
table if learning is enabled.

