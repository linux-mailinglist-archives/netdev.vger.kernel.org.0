Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDEC67A893
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjAYCHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYCHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:07:40 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A61C113EE;
        Tue, 24 Jan 2023 18:07:38 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so564282pjb.5;
        Tue, 24 Jan 2023 18:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tgG0tdxTsh+d6lEqIG44Okj7P+Nk3pzBYjrDRr5cTnk=;
        b=biZXJZb+EkDdcCLa/R8QUYnh8fpYDc3i0BVqfi5WI/Sd8G++pte6KE+5xgN9BdUvu4
         w79P8qOVDgM2uhUQwUvJcGuTrwm4mRwQ8Mm4D7m+1+TsxVuvMq8SDmkk++3SuteBh2W1
         X75yLqkcnK7Y9YpGnZPty0U8JwAUgCl0q1xOrdLfzcxpuEjVbxE+m35vdG7rwbivVimN
         bTZOmr7TaVf1mzYSZTU1dBuyHjj5cQAFBW7IMLaijRdFj9Z6648FhPrD4o0xbTRjS6vX
         geoF6eK2ItitMZF5wClW6JMDpOfhU8X/DGC0pdTN0KAP+KM1U161y3DMgwDweUTUP8ku
         bdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tgG0tdxTsh+d6lEqIG44Okj7P+Nk3pzBYjrDRr5cTnk=;
        b=vKLWqXZzgX34GoU39JZgPy13tYkBIgektZ9mesH5c3RpJpF59qBeLlIl9aUGquQs36
         nSDgowMD74zHwMTY0rd6lxtUNnkhLaSRZRinA7e2/hyVe7ZZvVur0FEyJIaYW4leB/9i
         V23pw2mceyk1Vs0g7zzccWC18h1gWVVfohDas2J20dREKO9+5ItHg94M5B+8cOIk4mpC
         VfHyVM2RdAy6adSouIaprlyWxJ9rzWKfrsQn4sLQ7Zc9tueJrvqZdQ45ddRUjtjUFvrp
         +isHbaZu29RVv6bdT7QTS9BJbWApjUJYXv1xBPznoxEnOcWE5KKJOFf5Mjz/kRqqQ0XN
         46BQ==
X-Gm-Message-State: AO0yUKWqtyCwz3AutdtyFUPFXkwPiyJAkimq2NmC9zRZv3FJYCT1zX6P
        EluWAl/P6zZqfyarAHq87OW6W5qpVIE=
X-Google-Smtp-Source: AK7set+Dq+dhUdY2ftWCgFOoOU3Me+2H6Fu4mUKE53tzXARQLTE/95RpQccXDFSikgIlvulpa7r+rw==
X-Received: by 2002:a17:902:e747:b0:196:13cd:19a with SMTP id p7-20020a170902e74700b0019613cd019amr5529419plf.6.1674612457703;
        Tue, 24 Jan 2023 18:07:37 -0800 (PST)
Received: from [192.168.99.8] (i220-99-137-224.s42.a013.ap.plala.or.jp. [220.99.137.224])
        by smtp.googlemail.com with ESMTPSA id u2-20020a17090282c200b00192fc9e8552sm2387531plz.0.2023.01.24.18.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 18:07:37 -0800 (PST)
Message-ID: <19b18a7c-ed1c-1f9d-84d4-7046bffe46b9@gmail.com>
Date:   Wed, 25 Jan 2023 11:07:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: KASAN veth use after free in XDP_REDIRECT
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        Shawn Bohrer <sbohrer@cloudflare.com>
Cc:     makita.toshiaki@lab.ntt.co.jp, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <Y9BfknDG0LXmruDu@JNXK7M3> <87357znztf.fsf@toke.dk>
Content-Language: en-US
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <87357znztf.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/01/25 10:54, Toke Høiland-Jørgensen wrote:
> Shawn Bohrer <sbohrer@cloudflare.com> writes:
> 
>> Hello,
>>
>> We've seen the following KASAN report on our systems. When using
>> AF_XDP on a veth.
>>
>> KASAN report:
>>
>> BUG: KASAN: use-after-free in __xsk_rcv+0x18d/0x2c0
>> Read of size 78 at addr ffff888976250154 by task napi/iconduit-g/148640
>>
>> CPU: 5 PID: 148640 Comm: napi/iconduit-g Kdump: loaded Tainted: G           O       6.1.4-cloudflare-kasan-2023.1.2 #1
>> Hardware name: Quanta Computer Inc. QuantaPlex T41S-2U/S2S-MB, BIOS S2S_3B10.03 06/21/2018
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x34/0x48
>>   print_report+0x170/0x473
>>   ? __xsk_rcv+0x18d/0x2c0
>>   kasan_report+0xad/0x130
>>   ? __xsk_rcv+0x18d/0x2c0
>>   kasan_check_range+0x149/0x1a0
>>   memcpy+0x20/0x60
>>   __xsk_rcv+0x18d/0x2c0
>>   __xsk_map_redirect+0x1f3/0x490
>>   ? veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>>   xdp_do_redirect+0x5ca/0xd60
>>   veth_xdp_rcv_skb+0x935/0x1ba0 [veth]
>>   ? __netif_receive_skb_list_core+0x671/0x920
>>   ? veth_xdp+0x670/0x670 [veth]
>>   veth_xdp_rcv+0x304/0xa20 [veth]
>>   ? do_xdp_generic+0x150/0x150
>>   ? veth_xdp_rcv_one+0xde0/0xde0 [veth]
>>   ? _raw_spin_lock_bh+0xe0/0xe0
>>   ? newidle_balance+0x887/0xe30
>>   ? __perf_event_task_sched_in+0xdb/0x800
>>   veth_poll+0x139/0x571 [veth]
>>   ? veth_xdp_rcv+0xa20/0xa20 [veth]
>>   ? _raw_spin_unlock+0x39/0x70
>>   ? finish_task_switch.isra.0+0x17e/0x7d0
>>   ? __switch_to+0x5cf/0x1070
>>   ? __schedule+0x95b/0x2640
>>   ? io_schedule_timeout+0x160/0x160
>>   __napi_poll+0xa1/0x440
>>   napi_threaded_poll+0x3d1/0x460
>>   ? __napi_poll+0x440/0x440
>>   ? __kthread_parkme+0xc6/0x1f0
>>   ? __napi_poll+0x440/0x440
>>   kthread+0x2a2/0x340
>>   ? kthread_complete_and_exit+0x20/0x20
>>   ret_from_fork+0x22/0x30
>>   </TASK>
>>
>> Freed by task 148640:
>>   kasan_save_stack+0x23/0x50
>>   kasan_set_track+0x21/0x30
>>   kasan_save_free_info+0x2a/0x40
>>   ____kasan_slab_free+0x169/0x1d0
>>   slab_free_freelist_hook+0xd2/0x190
>>   __kmem_cache_free+0x1a1/0x2f0
>>   skb_release_data+0x449/0x600
>>   consume_skb+0x9f/0x1c0
>>   veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>>   veth_xdp_rcv+0x304/0xa20 [veth]
>>   veth_poll+0x139/0x571 [veth]
>>   __napi_poll+0xa1/0x440
>>   napi_threaded_poll+0x3d1/0x460
>>   kthread+0x2a2/0x340
>>   ret_from_fork+0x22/0x30
>>
>>
>> The buggy address belongs to the object at ffff888976250000
>>   which belongs to the cache kmalloc-2k of size 2048
>> The buggy address is located 340 bytes inside of
>>   2048-byte region [ffff888976250000, ffff888976250800)
>>
>> The buggy address belongs to the physical page:
>> page:00000000ae18262a refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x976250
>> head:00000000ae18262a order:3 compound_mapcount:0 compound_pincount:0
>> flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
>> raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004cf00
>> raw: 0000000000000000 0000000080080008 00000002ffffffff 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>   ffff888976250000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>   ffff888976250080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>> ffff888976250100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                                                   ^
>>   ffff888976250180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>   ffff888976250200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>
>>
>> If I understand the code correctly it looks like a xdp_buf is
>> constructed pointing to the memory backed by a skb but consume_skb()
>> is called while the xdp_buf() is still in use.
>>
>> ```
>> 	case XDP_REDIRECT:
>> 		veth_xdp_get(&xdp);
>> 		consume_skb(skb);
>> 		xdp.rxq->mem = rq->xdp_mem;
>> 		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
>> 			stats->rx_drops++;
>> 			goto err_xdp;
>> 		}
>> 		stats->xdp_redirect++;
>> 		rcu_read_unlock();
>> 		goto xdp_xmit;
>> ```
>>
>> It is worth noting that I think XDP_TX has the exact same problem.
>>
>> Again assuming I understand the problem one naive solution might be to
>> move the consum_skb() call after xdp_do_redirect().  I think this
>> might work for BPF_MAP_TYPE_XSKMAP, BPF_MAP_TYPE_DEVMAP, and
>> BPF_MAP_TYPE_DEVMAP_HASH since those all seem to copy the xdb_buf to
>> new memory.  The copy happens for XSKMAP in __xsk_rcv() and for the
>> DEVMAP cases happens in dev_map_enqueue_clone().
>>
>> However, it would appear that for BPF_MAP_TYPE_CPUMAP that memory can
>> live much longer, possibly even after xdp_do_flush().  If I'm correct,
>> I'm not really sure where it would be safe to call consume_skb().
> 
> So the idea is that veth_xdp_get() does a
> get_page(virt_to_page(xdp->data)), where xdp->data in this case points
> to skb->head. This should keep the data page alive even if the skb
> surrounding it is freed by the call to consume_skb().
> 
> However, because the skb->head in this case was allocated from a slab
> allocator, taking a page refcount is not enough to prevent it from being
> freed.

Not sure why skb->head is kmallocked here.
skb_head_is_locked() check in veth_convert_skb_to_xdp_buff() should ensure that
skb head is a page fragment.

Toshiaki Makita
