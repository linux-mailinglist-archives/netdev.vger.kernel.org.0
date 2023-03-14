Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3D36B8C5F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjCNICx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbjCNICw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:02:52 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4353195BCE;
        Tue, 14 Mar 2023 01:02:46 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id d10so8357096pgt.12;
        Tue, 14 Mar 2023 01:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678780966;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mzo5Z5mHlwHCTY3Mamd2/czwyO3RTQPj9/hfxuY2xG8=;
        b=OkmdjhYBYPhCyp5bIPCegp9umzAZeHKgmiOXwvFY1lDawrv2GvqHkq/0N9SFoA9t2t
         trzOsPFPYiUxPYkwddCoUettrsg+FzL5BA2gcdXYtR02yhL893JBOCgems0rbKUs6Sje
         3J0SX8hGJwZvvniCSGMjl3FqqYg6eBmkkQYqVDLc8TqePBK9uLVk7cTbkQksmEmHxGRW
         uSt/Zl9LzV0iefnOIEjPvII2VzxFbBgnfgo7xwJWJEKw4Jei89YtecLabvqoXXAX6QIu
         FCnPBqc2FOP+P0XN6wa8kaGxQUJ6XoqslCgYUjx2SRXO5hq6lR1zbCzFpkDR9wv4nBMo
         0mwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678780966;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mzo5Z5mHlwHCTY3Mamd2/czwyO3RTQPj9/hfxuY2xG8=;
        b=uGyXvOwQE6YsFsFnaavN3e1r0E0FoO9KuFb1YPJ8va7GodufzgNTNsK5nuCS6vKcsv
         UcJeQrZzvmg+WXm+K0ThFp5RPcxW17rZomiftSSKRYWL/faZ4k3oZhvBNIpNKge9lb2j
         C+XGyGVGsskIeP6VSm/y5rRAVAxrFjxoEwB9VjW08AQPP42pBnpgflsyrtcuglJMNDOQ
         /nZVb/fTSlLKaRem+EdIa4JibWdQS98hik3X9gYvaw6xi5SNm7FMtAj/Us19Lxi7c1FA
         V4JJI/vs57WtpYAwSzEqpds7wFcqV26LNdFxWsL9EqQMoqDYPbpuJ5RYdq7Be8frJ0cI
         5dbA==
X-Gm-Message-State: AO0yUKV0pa0PYxWWrc3pas4/J2BOgCQVnFEx9qvobkaGlq+FpxluVNSm
        CW31u9F8uyjkVW3wB+vrXf8=
X-Google-Smtp-Source: AK7set8gfXbJiTfbRBSdZFW8pcQVWRu+oFO5QBgrV37TjePlRFK7rvDBQGy8hY7d2NZfINxRZtFabg==
X-Received: by 2002:aa7:9f44:0:b0:622:85e2:fb93 with SMTP id h4-20020aa79f44000000b0062285e2fb93mr9093657pfr.15.1678780966053;
        Tue, 14 Mar 2023 01:02:46 -0700 (PDT)
Received: from [192.168.99.21] (i114-182-247-24.s42.a013.ap.plala.or.jp. [114.182.247.24])
        by smtp.googlemail.com with ESMTPSA id e8-20020a654788000000b00476dc914262sm992561pgs.1.2023.03.14.01.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 01:02:45 -0700 (PDT)
Message-ID: <ea1ec50f-06ca-7771-f9f8-e45c13179733@gmail.com>
Date:   Tue, 14 Mar 2023 17:02:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: KASAN veth use after free in XDP_REDIRECT
To:     Shawn Bohrer <sbohrer@cloudflare.com>, lorenzo@kernel.org
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        makita.toshiaki@lab.ntt.co.jp, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
References: <Y9BfknDG0LXmruDu@JNXK7M3> <87357znztf.fsf@toke.dk>
 <19b18a7c-ed1c-1f9d-84d4-7046bffe46b9@gmail.com> <ZAkNABggOdKw6PwA@JNXK7M3>
Content-Language: en-US
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <ZAkNABggOdKw6PwA@JNXK7M3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/03/09 7:33, Shawn Bohrer wrote:
> On Wed, Jan 25, 2023 at 11:07:32AM +0900, Toshiaki Makita wrote:
>> On 2023/01/25 10:54, Toke Høiland-Jørgensen wrote:
>>> Shawn Bohrer <sbohrer@cloudflare.com> writes:
>>>
>>>> Hello,
>>>>
>>>> We've seen the following KASAN report on our systems. When using
>>>> AF_XDP on a veth.
>>>>
>>>> KASAN report:
>>>>
>>>> BUG: KASAN: use-after-free in __xsk_rcv+0x18d/0x2c0
>>>> Read of size 78 at addr ffff888976250154 by task napi/iconduit-g/148640
>>>>
>>>> CPU: 5 PID: 148640 Comm: napi/iconduit-g Kdump: loaded Tainted: G           O       6.1.4-cloudflare-kasan-2023.1.2 #1
>>>> Hardware name: Quanta Computer Inc. QuantaPlex T41S-2U/S2S-MB, BIOS S2S_3B10.03 06/21/2018
>>>> Call Trace:
>>>>    <TASK>
>>>>    dump_stack_lvl+0x34/0x48
>>>>    print_report+0x170/0x473
>>>>    ? __xsk_rcv+0x18d/0x2c0
>>>>    kasan_report+0xad/0x130
>>>>    ? __xsk_rcv+0x18d/0x2c0
>>>>    kasan_check_range+0x149/0x1a0
>>>>    memcpy+0x20/0x60
>>>>    __xsk_rcv+0x18d/0x2c0
>>>>    __xsk_map_redirect+0x1f3/0x490
>>>>    ? veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>>>>    xdp_do_redirect+0x5ca/0xd60
>>>>    veth_xdp_rcv_skb+0x935/0x1ba0 [veth]
>>>>    ? __netif_receive_skb_list_core+0x671/0x920
>>>>    ? veth_xdp+0x670/0x670 [veth]
>>>>    veth_xdp_rcv+0x304/0xa20 [veth]
>>>>    ? do_xdp_generic+0x150/0x150
>>>>    ? veth_xdp_rcv_one+0xde0/0xde0 [veth]
>>>>    ? _raw_spin_lock_bh+0xe0/0xe0
>>>>    ? newidle_balance+0x887/0xe30
>>>>    ? __perf_event_task_sched_in+0xdb/0x800
>>>>    veth_poll+0x139/0x571 [veth]
>>>>    ? veth_xdp_rcv+0xa20/0xa20 [veth]
>>>>    ? _raw_spin_unlock+0x39/0x70
>>>>    ? finish_task_switch.isra.0+0x17e/0x7d0
>>>>    ? __switch_to+0x5cf/0x1070
>>>>    ? __schedule+0x95b/0x2640
>>>>    ? io_schedule_timeout+0x160/0x160
>>>>    __napi_poll+0xa1/0x440
>>>>    napi_threaded_poll+0x3d1/0x460
>>>>    ? __napi_poll+0x440/0x440
>>>>    ? __kthread_parkme+0xc6/0x1f0
>>>>    ? __napi_poll+0x440/0x440
>>>>    kthread+0x2a2/0x340
>>>>    ? kthread_complete_and_exit+0x20/0x20
>>>>    ret_from_fork+0x22/0x30
>>>>    </TASK>
>>>>
>>>> Freed by task 148640:
>>>>    kasan_save_stack+0x23/0x50
>>>>    kasan_set_track+0x21/0x30
>>>>    kasan_save_free_info+0x2a/0x40
>>>>    ____kasan_slab_free+0x169/0x1d0
>>>>    slab_free_freelist_hook+0xd2/0x190
>>>>    __kmem_cache_free+0x1a1/0x2f0
>>>>    skb_release_data+0x449/0x600
>>>>    consume_skb+0x9f/0x1c0
>>>>    veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>>>>    veth_xdp_rcv+0x304/0xa20 [veth]
>>>>    veth_poll+0x139/0x571 [veth]
>>>>    __napi_poll+0xa1/0x440
>>>>    napi_threaded_poll+0x3d1/0x460
>>>>    kthread+0x2a2/0x340
>>>>    ret_from_fork+0x22/0x30
>>>>
>>>>
>>>> The buggy address belongs to the object at ffff888976250000
>>>>    which belongs to the cache kmalloc-2k of size 2048
>>>> The buggy address is located 340 bytes inside of
>>>>    2048-byte region [ffff888976250000, ffff888976250800)
>>>>
>>>> The buggy address belongs to the physical page:
>>>> page:00000000ae18262a refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x976250
>>>> head:00000000ae18262a order:3 compound_mapcount:0 compound_pincount:0
>>>> flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
>>>> raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004cf00
>>>> raw: 0000000000000000 0000000080080008 00000002ffffffff 0000000000000000
>>>> page dumped because: kasan: bad access detected
>>>>
>>>> Memory state around the buggy address:
>>>>    ffff888976250000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>    ffff888976250080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>> ffff888976250100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>                                                    ^
>>>>    ffff888976250180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>    ffff888976250200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>>
>>>>
>>>> If I understand the code correctly it looks like a xdp_buf is
>>>> constructed pointing to the memory backed by a skb but consume_skb()
>>>> is called while the xdp_buf() is still in use.
>>>>
>>>> ```
>>>> 	case XDP_REDIRECT:
>>>> 		veth_xdp_get(&xdp);
>>>> 		consume_skb(skb);
>>>> 		xdp.rxq->mem = rq->xdp_mem;
>>>> 		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
>>>> 			stats->rx_drops++;
>>>> 			goto err_xdp;
>>>> 		}
>>>> 		stats->xdp_redirect++;
>>>> 		rcu_read_unlock();
>>>> 		goto xdp_xmit;
>>>> ```
>>>>
>>>> It is worth noting that I think XDP_TX has the exact same problem.
>>>>
>>>> Again assuming I understand the problem one naive solution might be to
>>>> move the consum_skb() call after xdp_do_redirect().  I think this
>>>> might work for BPF_MAP_TYPE_XSKMAP, BPF_MAP_TYPE_DEVMAP, and
>>>> BPF_MAP_TYPE_DEVMAP_HASH since those all seem to copy the xdb_buf to
>>>> new memory.  The copy happens for XSKMAP in __xsk_rcv() and for the
>>>> DEVMAP cases happens in dev_map_enqueue_clone().
>>>>
>>>> However, it would appear that for BPF_MAP_TYPE_CPUMAP that memory can
>>>> live much longer, possibly even after xdp_do_flush().  If I'm correct,
>>>> I'm not really sure where it would be safe to call consume_skb().
>>>
>>> So the idea is that veth_xdp_get() does a
>>> get_page(virt_to_page(xdp->data)), where xdp->data in this case points
>>> to skb->head. This should keep the data page alive even if the skb
>>> surrounding it is freed by the call to consume_skb().
>>>
>>> However, because the skb->head in this case was allocated from a slab
>>> allocator, taking a page refcount is not enough to prevent it from being
>>> freed.
>>
>> Not sure why skb->head is kmallocked here.
>> skb_head_is_locked() check in veth_convert_skb_to_xdp_buff() should ensure that
>> skb head is a page fragment.
> 
> I have a few more details here.  We have some machines running 5.15
> kernels and some are running 6.1 kernels.  So far it appears this only
> happens on 6.1.  We also have a couple of different network cards but
> it appears that only the machines with Solarflare cards using the sfc
> driver hit the KASAN BUG.
> 
> 718a18a0c8a67f97781e40bdef7cdd055c430996 "veth: Rework
> veth_xdp_rcv_skb in order to accept non-linear skb" reworked and added
> the veth_convert_skb_to_xdp_buff() call you mentioned.  Importantly it
> also added a call to pskb_expand_head() which will kmalloc() the
> skb->head.  This looks like a path that could be causing the KASAN
> BUG, but I have not yet confirmed that is the path we are hitting.
> This change was also added in 5.18 so might explain why we don't see
> it on 5.15.

I think you made a valid point. It looks like pskb_expand_head() is incorrect here.
At least I did not expect kmallocked skb->data at this point when I introduced
veth XDP.

Also I looked into the discussion on the suspected patch,
https://patchwork.kernel.org/project/netdevbpf/list/?series=&submitter=&state=*&q=rework+veth_xdp_rcv_skb&archive=both&delegate=
But there was no discussion on pskb_expand_head() nor kmallocked data.

Lorenzo, what do you think?

Toshiaki Makita
