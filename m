Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B76344BB5F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 06:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhKJFrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 00:47:47 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:41890 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhKJFrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 00:47:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636523098; h=Content-Type: MIME-Version: Message-ID:
 Subject: Cc: To: From: Date: Sender;
 bh=UBsGKr9qTjj3+fXAK0+x6b8+lNaQ3CQRoH+UTEDPZi4=; b=TeN2LM32F9jDrlqp33f1H6Ej6WbQGniBRWUxLXElVEOlbtZErcfjw0A4u1weM0BwQmkU/6TD
 UVhMrwlHZNTkBaoaj4TyrqBDPt0lIRQ6bQBTfKGBX+hZmefq10hFWsI/Erwrri+8xZ/cRlg+
 Njgy2pz0HOTo4no5zcVL3tq/gvk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 618b5c59facd20d795b63189 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Nov 2021 05:44:57
 GMT
Sender: kapandey=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9E887C4338F; Wed, 10 Nov 2021 05:44:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from kapandey-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kapandey)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B31BBC4338F;
        Wed, 10 Nov 2021 05:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B31BBC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Date:   Wed, 10 Nov 2021 11:14:44 +0530
From:   Kaustubh Pandey <kapandey@codeaurora.org>
To:     netdev@vger.kernel.org, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, davem@davemloft.net
Cc:     sharathv@codeaurora.org
Subject: Kernel Panic observed in tcp_v4_early_demux
Message-ID: <20211110054440.GA3831@kapandey-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Everyone,

I  observed panic in tcp_v4_early_demux with below data:

Testcase details:
	No concrete steps to reproduce this.
	Observed this with and without KASAN.
	Overall testcase involves data transfer and basic multimedia usecases.

Kernel Version: v5.4

Can you pls help on how this can be resolved?

dmesg:
[406822.185272]  (5) ==================================================================
[406822.185318]  (5) BUG: KASAN: use-after-free in tcp_v4_early_demux+0x1b8/0x254
[406822.185339]  (5) Read of size 2 at addr ffffff801e66db3a by task rx_thr_0/23872
[406822.185349]  (5)
[406822.185366]  (5) CPU: 5 PID: 23872 Comm: rx_thr_0 Tainted: G S W  O      5.4.86-qgki-g5eb04aadbc80 #1
[406822.185383]  (5) Call trace:
[406822.185397]  (5)  dump_backtrace+0x0/0x1d0
[406822.185406]  (5)  show_stack+0x18/0x24
[406822.185419]  (5)  dump_stack+0xe0/0x150
[406822.185434]  (5)  print_address_description+0x88/0x578
[406822.185444]  (5)  __kasan_report+0x1c4/0x1e0
[406822.185454]  (5)  kasan_report+0x14/0x20
[406822.185463]  (5)  __asan_load2+0x94/0x98
[406822.185473]  (5)  tcp_v4_early_demux+0x1b8/0x254
[406822.185484]  (5)  ip_rcv_finish_core+0x490/0x594
[406822.185492]  (5)  ip_rcv+0x10c/0x17c
[406822.185506]  (5)  __netif_receive_skb_core+0xd4c/0x1270
[406822.185516]  (5)  __netif_receive_skb_list_core+0x13c/0x400
[406822.185525]  (5)  __netif_receive_skb_list+0x1b8/0x220
[406822.185535]  (5)  netif_receive_skb_list_internal+0x1e0/0x314
[406822.185545]  (5)  netif_receive_skb_list+0x170/0x290
[406822.188506]  (5)
[406822.188524]  (5) Allocated by task 23872:
[406822.188541]  (5)  __kasan_kmalloc+0x100/0x1c0
[406822.188550]  (5)  kasan_slab_alloc+0x18/0x24
[406822.188559]  (5)  kmem_cache_alloc+0x2c4/0x344
[406822.188569]  (5)  dst_alloc+0xa8/0x100
[406822.188580]  (5)  ip_route_input_rcu+0xa14/0xda4
[406822.188590]  (5)  ip_route_input_noref+0x70/0xb0
[406822.188599]  (5)  ip_rcv_finish_core+0xfc/0x594
[406822.188607]  (5)  ip_rcv+0x10c/0x17c
[406822.188618]  (5)  __netif_receive_skb_core+0xd4c/0x1270
[406822.188627]  (5)  __netif_receive_skb_list_core+0x13c/0x400
[406822.188637]  (5)  __netif_receive_skb_list+0x1b8/0x220
[406822.188646]  (5)  netif_receive_skb_list_internal+0x1e0/0x314
[406822.188655]  (5)  netif_receive_skb_list+0x170/0x290
[406822.191579]  (5)
[406822.191592]  (5) Freed by task 23:
[406822.191606]  (5)  __kasan_slab_free+0x164/0x234
[406822.191616]  (5)  kasan_slab_free+0x14/0x24
[406822.191625]  (5)  slab_free_freelist_hook+0xe0/0x164
[406822.191633]  (5)  kmem_cache_free+0xfc/0x354
[406822.191643]  (5)  dst_destroy+0x170/0x1cc
[406822.191652]  (5)  dst_destroy_rcu+0x14/0x20
[406822.191663]  (5)  rcu_do_batch+0x29c/0x518
[406822.191672]  (5)  nocb_cb_wait+0xfc/0x854
[406822.191682]  (5)  rcu_nocb_cb_kthread+0x24/0x48
[406822.191691]  (5)  kthread+0x228/0x240
[406822.191700]  (5)  ret_from_fork+0x10/0x18
[406822.191707]  (5)
[406822.191720]  (5) The buggy address belongs to the object at ffffff801e66db00
[406822.191720]  which belongs to the cache ip_dst_cache of size 176
[406822.191733]  (5) The buggy address is located 58 bytes inside of
[406822.191733]  176-byte region [ffffff801e66db00, ffffff801e66dbb0)
[406822.191744]  (5) The buggy address belongs to the page:
[406822.191759]  (5) page:ffffffff00599b00 refcount:1 mapcount:0 mapping:ffffff806c567480 index:0xffffff801e66cd00 compound_mapcount: 0
[406822.191769]  (5) flags: 0x10200(slab|head)
[406822.191783]  (5) raw: 0000000000010200 ffffffff06b16c00 0000000400000004 ffffff806c567480
[406822.191794]  (5) raw: ffffff801e66cd00 0000000080200008 00000001ffffffff 0000000000000000
[406822.191801]  (5) page dumped because: kasan: bad access detected
[406822.191808]  (5)
[406822.191817]  (5) Memory state around the buggy address:
[406822.191829]  (5)  ffffff801e66da00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[406822.191841]  (5)  ffffff801e66da80: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
[406822.191852]  (5) >ffffff801e66db00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[406822.191861]  (5)                                         ^
[406822.191872]  (5)  ffffff801e66db80: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
[406822.191882]  (5)  ffffff801e66dc00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[406822.191892]  (5)
==================================================================
[406822.191902]  (5) Disabling lock debugging due to kernel taint
[406822.192721]  (5) Kernel panic - not syncing: panic_on_warn set ...
[406822.192788]  (5) CPU: 5 PID: 23872 Comm: rx_thr_0 Tainted: G S  B W  O      5.4.86-qgki-g5eb04aadbc80 #1
[406822.192808]  (5) Call trace:
[406822.192820]  (5)  dump_backtrace+0x0/0x1d0
[406822.192831]  (5)  show_stack+0x18/0x24
[406822.192844]  (5)  dump_stack+0xe0/0x150
[406822.192855]  (5)  panic+0x210/0x410
[406822.192867]  (5)  __kasan_report+0x0/0x1e0
[406822.192878]  (5)  tokenize_frame_descr+0x0/0x124
[406822.192889]  (5)  kasan_report+0x14/0x20
[406822.192900]  (5)  __asan_load2+0x94/0x98
[406822.192912]  (5)  tcp_v4_early_demux+0x1b8/0x254
[406822.192924]  (5)  ip_rcv_finish_core+0x490/0x594
[406822.192934]  (5)  ip_rcv+0x10c/0x17c
[406822.192946]  (5)  __netif_receive_skb_core+0xd4c/0x1270
[406822.192958]  (5)  __netif_receive_skb_list_core+0x13c/0x400
[406822.192969]  (5)  __netif_receive_skb_list+0x1b8/0x220
[406822.192981]  (5)  netif_receive_skb_list_internal+0x1e0/0x314
[406822.192991]  (5)  netif_receive_skb_list+0x170/0x290

Thanks,
Kaustubh
