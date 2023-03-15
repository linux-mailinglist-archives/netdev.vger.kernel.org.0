Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D336BA7AF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 07:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjCOGUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 02:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCOGUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 02:20:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA7332513;
        Tue, 14 Mar 2023 23:19:45 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id a2so18979768plm.4;
        Tue, 14 Mar 2023 23:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678861183;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n/OrkxmmE5cofD38xOKyNzOSC79HG80Mp2FvP2njW1E=;
        b=elz9SoI2z4hvoF0E7Fce9e9Uzt1L5mPVGUle0Z2GRL7GKHNdpR1WClOwsOMMfRcfLb
         Qm5bEwBZiurpqERUtTouZz2S3a36VBgLLIOMkqSKnMrMJ3b9P+G5KxjBKceLJ4Jicv7s
         aqU/qzrAvRBerY1tWopPtiFfLgq9YSrKIZfKiVjR5Lx0bKLX3MEmXpMvD8XJ47pRckMW
         LQ4T6E2i+sa9iJtFuLcFtfp3fuBE6GvUMHObkgYqPmPRqdbcxD2vnMKd9k6PCWBCr9Xh
         HbqSTBPM9NZhM8reWkzkGGo3SuKsntZM5rQSAyOjswwKoB2SvmOsohhR+Fbt2PA1h5Gk
         Z/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678861183;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n/OrkxmmE5cofD38xOKyNzOSC79HG80Mp2FvP2njW1E=;
        b=ybsT2yJobisenQJCb5wmp1SueOX4L3FAxesUPCUhyvvyu7HXhoPwXQO++NQ2Iy68Ek
         5nZSbLEQMaxxMVgyjkxNBGDekhi5nRLfNqPBkxml07edSmVL5Mf00xEalrPolakZLUER
         tKLv/MvnZPB8FXq4aokX3jglMGfpnMSVfwxzI/Ggjobwjvh+bryK5s0UjCmbOMTQhwZj
         Ln7umszArmamlIm2yq/CFwhblIPMdQGVOgssS3qXkwUBhzzl4REegjQfnetQHkf+PonI
         cjeJlxRQujdHZLQqD7kaj4LN1Ts+gjpJzgDiWKtJm4BjaoarlZsbRIL0ocgYP3el9+lP
         xGcQ==
X-Gm-Message-State: AO0yUKWVmbIWVlq7ogGT80cofI+RyjEypC0VPvUz+9nTp7U+sybx/UJo
        csIWWVc48aQciRw+sFETqbU=
X-Google-Smtp-Source: AK7set/LFAsj6/iIWE9gzOEUjb45Y4FkKnpHnR2Jt7wH+U+1xLYc1zBO5MBoiW9zydE2UyZR6mw5Sw==
X-Received: by 2002:a17:90b:688:b0:23d:4229:f7d7 with SMTP id m8-20020a17090b068800b0023d4229f7d7mr3465450pjz.38.1678861182899;
        Tue, 14 Mar 2023 23:19:42 -0700 (PDT)
Received: from [192.168.99.21] (i114-182-247-24.s42.a013.ap.plala.or.jp. [114.182.247.24])
        by smtp.googlemail.com with ESMTPSA id ko12-20020a17090307cc00b0019aaba5c90bsm2769732plb.84.2023.03.14.23.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 23:19:42 -0700 (PDT)
Message-ID: <6926d4f1-18d3-98e0-ac8a-8478d4020dab@gmail.com>
Date:   Wed, 15 Mar 2023 15:19:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] veth: Fix use after free in XDP_REDIRECT
To:     Shawn Bohrer <sbohrer@cloudflare.com>
Cc:     toke@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, lorenzo@kernel.org
References: <ZBCSAsUBeNvTPj/s@JNXK7M3>
 <20230314153351.2201328-1-sbohrer@cloudflare.com>
Content-Language: en-US
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <20230314153351.2201328-1-sbohrer@cloudflare.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/03/15 0:33, Shawn Bohrer wrote:
> 718a18a0c8a67f97781e40bdef7cdd055c430996 "veth: Rework veth_xdp_rcv_skb
> in order to accept non-linear skb" introduced a bug where it tried to
> use pskb_expand_head() if the headroom was less than
> XDP_PACKET_HEADROOM.  This however uses kmalloc to expand the head,
> which will later allow consume_skb() to free the skb while is it still
> in use by AF_XDP.
> 
> Previously if the headroom was less than XDP_PACKET_HEADROOM we
> continued on to allocate a new skb from pages so this restores that
> behavior.
> 
> BUG: KASAN: use-after-free in __xsk_rcv+0x18d/0x2c0
> Read of size 78 at addr ffff888976250154 by task napi/iconduit-g/148640
> 
> CPU: 5 PID: 148640 Comm: napi/iconduit-g Kdump: loaded Tainted: G           O       6.1.4-cloudflare-kasan-2023.1.2 #1
> Hardware name: Quanta Computer Inc. QuantaPlex T41S-2U/S2S-MB, BIOS S2S_3B10.03 06/21/2018
> Call Trace:
>    <TASK>
>    dump_stack_lvl+0x34/0x48
>    print_report+0x170/0x473
>    ? __xsk_rcv+0x18d/0x2c0
>    kasan_report+0xad/0x130
>    ? __xsk_rcv+0x18d/0x2c0
>    kasan_check_range+0x149/0x1a0
>    memcpy+0x20/0x60
>    __xsk_rcv+0x18d/0x2c0
>    __xsk_map_redirect+0x1f3/0x490
>    ? veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>    xdp_do_redirect+0x5ca/0xd60
>    veth_xdp_rcv_skb+0x935/0x1ba0 [veth]
>    ? __netif_receive_skb_list_core+0x671/0x920
>    ? veth_xdp+0x670/0x670 [veth]
>    veth_xdp_rcv+0x304/0xa20 [veth]
>    ? do_xdp_generic+0x150/0x150
>    ? veth_xdp_rcv_one+0xde0/0xde0 [veth]
>    ? _raw_spin_lock_bh+0xe0/0xe0
>    ? newidle_balance+0x887/0xe30
>    ? __perf_event_task_sched_in+0xdb/0x800
>    veth_poll+0x139/0x571 [veth]
>    ? veth_xdp_rcv+0xa20/0xa20 [veth]
>    ? _raw_spin_unlock+0x39/0x70
>    ? finish_task_switch.isra.0+0x17e/0x7d0
>    ? __switch_to+0x5cf/0x1070
>    ? __schedule+0x95b/0x2640
>    ? io_schedule_timeout+0x160/0x160
>    __napi_poll+0xa1/0x440
>    napi_threaded_poll+0x3d1/0x460
>    ? __napi_poll+0x440/0x440
>    ? __kthread_parkme+0xc6/0x1f0
>    ? __napi_poll+0x440/0x440
>    kthread+0x2a2/0x340
>    ? kthread_complete_and_exit+0x20/0x20
>    ret_from_fork+0x22/0x30
>    </TASK>
> 
> Freed by task 148640:
>    kasan_save_stack+0x23/0x50
>    kasan_set_track+0x21/0x30
>    kasan_save_free_info+0x2a/0x40
>    ____kasan_slab_free+0x169/0x1d0
>    slab_free_freelist_hook+0xd2/0x190
>    __kmem_cache_free+0x1a1/0x2f0
>    skb_release_data+0x449/0x600
>    consume_skb+0x9f/0x1c0
>    veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>    veth_xdp_rcv+0x304/0xa20 [veth]
>    veth_poll+0x139/0x571 [veth]
>    __napi_poll+0xa1/0x440
>    napi_threaded_poll+0x3d1/0x460
>    kthread+0x2a2/0x340
>    ret_from_fork+0x22/0x30
> 
> The buggy address belongs to the object at ffff888976250000
>    which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 340 bytes inside of
>    2048-byte region [ffff888976250000, ffff888976250800)
> 
> The buggy address belongs to the physical page:
> page:00000000ae18262a refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x976250
> head:00000000ae18262a order:3 compound_mapcount:0 compound_pincount:0
> flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
> raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004cf00
> raw: 0000000000000000 0000000080080008 00000002ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>    ffff888976250000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    ffff888976250080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff888976250100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                    ^
>    ffff888976250180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    ffff888976250200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 
> Fixes: 718a18a0c8a6 ("veth: Rework veth_xdp_rcv_skb in order to accept non-linear skb")
> Signed-off-by: Shawn Bohrer <sbohrer@cloudflare.com>

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
