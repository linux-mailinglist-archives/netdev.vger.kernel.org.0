Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DA344BB82
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhKJGBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 01:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhKJGBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 01:01:06 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B0EC061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 21:58:19 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 200so1300518pga.1
        for <netdev@vger.kernel.org>; Tue, 09 Nov 2021 21:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A72S/UptfeDonbxOVS0mM/qwNuERLEnD8OFZHZyrPgQ=;
        b=hr4SFz2FJqrFCT5ltVmv7DW46aqp+vnufCS6mhN+1L3KHElUmH+tB8gHKo3/sGVRJ7
         1B7uRMixQBrCVfHc+0+vw3R+jNkXza70fwZ+EJHYSj/In4gVVQ7CktdiTiGbv4t1tInv
         mxcPrWoP3DuCkl+FMoXsIH9tGxRX1aH916nbUoFaONg6KluCUXUF7TlvGvbLaZHyuPD8
         2rERbyQsmg3Nc/awFJ37aHaMjnhMmEHtXAIvuDPjY5TUDcTuVhycc30bSNHALMrLt0H5
         BUC1b3q2PM1uSAOSOMY2KhE5RnOD9+tsPhWe7e6RKsosL49ILaqVS/kt8TduTxEHFoVc
         G/5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A72S/UptfeDonbxOVS0mM/qwNuERLEnD8OFZHZyrPgQ=;
        b=d4r1W7MwhYAAL7a/ufQcDPkTNKu7tXNPPb6UEimuSB8d6qI6Tr+AAqk+c61OPNxV4g
         4wUAIjhfjSQDyeKR+DDZW7j/Pm5G6Jmeirg7f/R51m+parV2N/a6T1uLGHjL7yz12o4h
         ToOqsEi6NXGHi1ZcVOA2E2ho7T/0//sToA0rixW5LPjRmcHgaVV8Zw5dk9qJ0BiZEKnR
         8pa9GMku59YjkKi7fhv56jbehvSEyjYhav05DFME0n2SfCV2Z65UTTHjyygpYr5mwXK1
         ZJGBIkRet8ntECXwXzdHWpdSldhZD8ZK8X2r7kYRr9uTd27XNFDmJHdXRQ0BRaaCvASL
         pLLw==
X-Gm-Message-State: AOAM530Ku8Vipbw7V0WHSoqLsZHH3HMvafAfq4oo5fOxqU0HEME++LhV
        0MqfUSYAXSu+UQZn5eBvM28ZeSPAj54=
X-Google-Smtp-Source: ABdhPJy8Y/M1i4A64Ni12GCNcyJVjti2xzQ8ZKlMI6P4ztc7/vzCfKTFgvBspTxC1Hw9/icNB+2N5w==
X-Received: by 2002:a63:584a:: with SMTP id i10mr1543942pgm.0.1636523899139;
        Tue, 09 Nov 2021 21:58:19 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h4sm4474698pjm.14.2021.11.09.21.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 21:58:18 -0800 (PST)
Subject: Re: Kernel Panic observed in tcp_v4_early_demux
To:     Kaustubh Pandey <kapandey@codeaurora.org>, netdev@vger.kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        davem@davemloft.net
Cc:     sharathv@codeaurora.org
References: <20211110054440.GA3831@kapandey-linux.qualcomm.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0709f93e-35fa-1428-ef3f-5c8b81833fe6@gmail.com>
Date:   Tue, 9 Nov 2021 21:58:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211110054440.GA3831@kapandey-linux.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/21 9:44 PM, Kaustubh Pandey wrote:
> Hi Everyone,
> 
> I  observed panic in tcp_v4_early_demux with below data:
> 
> Testcase details:
> 	No concrete steps to reproduce this.
> 	Observed this with and without KASAN.
> 	Overall testcase involves data transfer and basic multimedia usecases.
> 
> Kernel Version: v5.4

Please use recent kernel for KASAN games.

Thanks !

> 
> Can you pls help on how this can be resolved?
> 
> dmesg:
> [406822.185272]  (5) ==================================================================
> [406822.185318]  (5) BUG: KASAN: use-after-free in tcp_v4_early_demux+0x1b8/0x254
> [406822.185339]  (5) Read of size 2 at addr ffffff801e66db3a by task rx_thr_0/23872
> [406822.185349]  (5)
> [406822.185366]  (5) CPU: 5 PID: 23872 Comm: rx_thr_0 Tainted: G S W  O      5.4.86-qgki-g5eb04aadbc80 #1
> [406822.185383]  (5) Call trace:
> [406822.185397]  (5)  dump_backtrace+0x0/0x1d0
> [406822.185406]  (5)  show_stack+0x18/0x24
> [406822.185419]  (5)  dump_stack+0xe0/0x150
> [406822.185434]  (5)  print_address_description+0x88/0x578
> [406822.185444]  (5)  __kasan_report+0x1c4/0x1e0
> [406822.185454]  (5)  kasan_report+0x14/0x20
> [406822.185463]  (5)  __asan_load2+0x94/0x98
> [406822.185473]  (5)  tcp_v4_early_demux+0x1b8/0x254
> [406822.185484]  (5)  ip_rcv_finish_core+0x490/0x594
> [406822.185492]  (5)  ip_rcv+0x10c/0x17c
> [406822.185506]  (5)  __netif_receive_skb_core+0xd4c/0x1270
> [406822.185516]  (5)  __netif_receive_skb_list_core+0x13c/0x400
> [406822.185525]  (5)  __netif_receive_skb_list+0x1b8/0x220
> [406822.185535]  (5)  netif_receive_skb_list_internal+0x1e0/0x314
> [406822.185545]  (5)  netif_receive_skb_list+0x170/0x290
> [406822.188506]  (5)
> [406822.188524]  (5) Allocated by task 23872:
> [406822.188541]  (5)  __kasan_kmalloc+0x100/0x1c0
> [406822.188550]  (5)  kasan_slab_alloc+0x18/0x24
> [406822.188559]  (5)  kmem_cache_alloc+0x2c4/0x344
> [406822.188569]  (5)  dst_alloc+0xa8/0x100
> [406822.188580]  (5)  ip_route_input_rcu+0xa14/0xda4
> [406822.188590]  (5)  ip_route_input_noref+0x70/0xb0
> [406822.188599]  (5)  ip_rcv_finish_core+0xfc/0x594
> [406822.188607]  (5)  ip_rcv+0x10c/0x17c
> [406822.188618]  (5)  __netif_receive_skb_core+0xd4c/0x1270
> [406822.188627]  (5)  __netif_receive_skb_list_core+0x13c/0x400
> [406822.188637]  (5)  __netif_receive_skb_list+0x1b8/0x220
> [406822.188646]  (5)  netif_receive_skb_list_internal+0x1e0/0x314
> [406822.188655]  (5)  netif_receive_skb_list+0x170/0x290
> [406822.191579]  (5)
> [406822.191592]  (5) Freed by task 23:
> [406822.191606]  (5)  __kasan_slab_free+0x164/0x234
> [406822.191616]  (5)  kasan_slab_free+0x14/0x24
> [406822.191625]  (5)  slab_free_freelist_hook+0xe0/0x164
> [406822.191633]  (5)  kmem_cache_free+0xfc/0x354
> [406822.191643]  (5)  dst_destroy+0x170/0x1cc
> [406822.191652]  (5)  dst_destroy_rcu+0x14/0x20
> [406822.191663]  (5)  rcu_do_batch+0x29c/0x518
> [406822.191672]  (5)  nocb_cb_wait+0xfc/0x854
> [406822.191682]  (5)  rcu_nocb_cb_kthread+0x24/0x48
> [406822.191691]  (5)  kthread+0x228/0x240
> [406822.191700]  (5)  ret_from_fork+0x10/0x18
> [406822.191707]  (5)
> [406822.191720]  (5) The buggy address belongs to the object at ffffff801e66db00
> [406822.191720]  which belongs to the cache ip_dst_cache of size 176
> [406822.191733]  (5) The buggy address is located 58 bytes inside of
> [406822.191733]  176-byte region [ffffff801e66db00, ffffff801e66dbb0)
> [406822.191744]  (5) The buggy address belongs to the page:
> [406822.191759]  (5) page:ffffffff00599b00 refcount:1 mapcount:0 mapping:ffffff806c567480 index:0xffffff801e66cd00 compound_mapcount: 0
> [406822.191769]  (5) flags: 0x10200(slab|head)
> [406822.191783]  (5) raw: 0000000000010200 ffffffff06b16c00 0000000400000004 ffffff806c567480
> [406822.191794]  (5) raw: ffffff801e66cd00 0000000080200008 00000001ffffffff 0000000000000000
> [406822.191801]  (5) page dumped because: kasan: bad access detected
> [406822.191808]  (5)
> [406822.191817]  (5) Memory state around the buggy address:
> [406822.191829]  (5)  ffffff801e66da00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [406822.191841]  (5)  ffffff801e66da80: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
> [406822.191852]  (5) >ffffff801e66db00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [406822.191861]  (5)                                         ^
> [406822.191872]  (5)  ffffff801e66db80: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
> [406822.191882]  (5)  ffffff801e66dc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [406822.191892]  (5)
> ==================================================================
> [406822.191902]  (5) Disabling lock debugging due to kernel taint
> [406822.192721]  (5) Kernel panic - not syncing: panic_on_warn set ...
> [406822.192788]  (5) CPU: 5 PID: 23872 Comm: rx_thr_0 Tainted: G S  B W  O      5.4.86-qgki-g5eb04aadbc80 #1
> [406822.192808]  (5) Call trace:
> [406822.192820]  (5)  dump_backtrace+0x0/0x1d0
> [406822.192831]  (5)  show_stack+0x18/0x24
> [406822.192844]  (5)  dump_stack+0xe0/0x150
> [406822.192855]  (5)  panic+0x210/0x410
> [406822.192867]  (5)  __kasan_report+0x0/0x1e0
> [406822.192878]  (5)  tokenize_frame_descr+0x0/0x124
> [406822.192889]  (5)  kasan_report+0x14/0x20
> [406822.192900]  (5)  __asan_load2+0x94/0x98
> [406822.192912]  (5)  tcp_v4_early_demux+0x1b8/0x254
> [406822.192924]  (5)  ip_rcv_finish_core+0x490/0x594
> [406822.192934]  (5)  ip_rcv+0x10c/0x17c
> [406822.192946]  (5)  __netif_receive_skb_core+0xd4c/0x1270
> [406822.192958]  (5)  __netif_receive_skb_list_core+0x13c/0x400
> [406822.192969]  (5)  __netif_receive_skb_list+0x1b8/0x220
> [406822.192981]  (5)  netif_receive_skb_list_internal+0x1e0/0x314
> [406822.192991]  (5)  netif_receive_skb_list+0x170/0x290
> 
> Thanks,
> Kaustubh
> 
