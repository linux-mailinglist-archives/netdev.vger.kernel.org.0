Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305F76D45C9
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 15:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjDCN2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 09:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbjDCN2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 09:28:37 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1D910C8;
        Mon,  3 Apr 2023 06:28:34 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A1D55C0158;
        Mon,  3 Apr 2023 09:28:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 03 Apr 2023 09:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680528514; x=1680614914; bh=GV
        ZLNMk9yfkflFDKKHQEkZLXaQmA6emVevRE2hyjhHo=; b=m7kXxVz2tw03wMCqqB
        0W/W2D8fxQrjtDCJ2Et7iWQVB6PvMBP1FtWbqsSYieax+ECJG4nIKXgBTYk45sSs
        hpRexyMd8DNvgYMlFImzvrVGc9/dVMy2J/wI6XFhuADm/s8fCJUlArUakqhpIGtw
        y3BN55RPplm+GbMsbL1KGSaRl7kSMYjTKojUCTlLhS9YzJ38i8Dr3jlZK2LkO3le
        43APf8jnVKtPoH50V8zwVq8HSjXdF6nunqxNr+Ow/4Bl7OoExLtkHUbV3IXLez8y
        /V2QlRpj4gkXtI1MTwd522Z5sH0KSJAg9HhsfZUpCMjj9Sc8Lo8LZKY3OFDKmiiT
        873g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680528514; x=1680614914; bh=GVZLNMk9yfkfl
        FDKKHQEkZLXaQmA6emVevRE2hyjhHo=; b=pho3isSX2NTGyyAtePzJPjuwAHlxf
        0X6vPb3k5Vj3T128mgywmzeSme0kMQehxhZcbNfUuJVHDFxRc6D2GhqwGZYfbxt1
        n01x8lbSMp1CqT32ngxyICPFN8DvnmITUyoP/O16wQV/sBowgLZt21reI0PSDk2f
        ehOBcAtcv9n8qZJFkVzxvKuOA1Re7fRBErSpQ2Rt1x+O6FDHZ/K1OympDrMmdHqz
        qcTZ7+0ZuqqBe4THeLvGO/w7SGCq+wubOGu8R2l4EVQ6PpBjeDMWMm1EGE4sPk5M
        +1zlxclugO3PQyXb0CjjWvjeW1uDHY6j0yXXMQjoC8H5x+TrcwJprVt1w==
X-ME-Sender: <xms:gdQqZOXATr_KMOQPy9XGXt5LpNR8KbFiHUMl_vX2okqNAPGpdc5QYQ>
    <xme:gdQqZKn75-bjTSYlFUlK7xO56VMMfQ2geBWlqp2aDoxDXYX_2YbcPCJyhoVcoUKHB
    gUOTUHGuGcENQ>
X-ME-Received: <xmr:gdQqZCZVDEKZEYgwN9LHx3_VeaiJWUuwUhe-dadIu4HK6Jl0W3hUuBt26xnNiFxBIekeZn5WeBmM6Gkbt6F9Gjfa8gaIDe0a0SOo1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeijedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:gdQqZFXRq-ukVqUg2HUSPzYBq525NjlncbwIjt9Zzv1A4fcTMwyYeA>
    <xmx:gdQqZIlD2qIikPlULzw2-bA3f-7gnUApzQF5HqjDFoVBkgo0BH5o-A>
    <xmx:gdQqZKdzzgDS_uy2JReme4hw3TyiSA97TmWJNnsMn9nUV_G8iCp3IA>
    <xmx:gtQqZHdHohY9Iif5ILdmrtY7xUQMivnpL37WK6GVjHAoV6Yu4HnmKA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Apr 2023 09:28:33 -0400 (EDT)
Date:   Mon, 3 Apr 2023 15:28:30 +0200
From:   Greg KH <greg@kroah.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stable@vger.kernel.org, vegard.nossum@oracle.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Kyle Zeng <zengyhkyle@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14.y] net: sched: cbq: dont intepret cls results when
 asked to drop
Message-ID: <2023040322-feel-woof-e49b@gregkh>
References: <20230324102816.3888235-1-harshit.m.mogalapalli@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324102816.3888235-1-harshit.m.mogalapalli@oracle.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 03:28:16AM -0700, Harshit Mogalapalli wrote:
> From: Jamal Hadi Salim <jhs@mojatatu.com>
> 
> [ Upstream commit caa4b35b4317d5147b3ab0fbdc9c075c7d2e9c12 ]
> 
> If asked to drop a packet via TC_ACT_SHOT it is unsafe to assume that
> res.class contains a valid pointer
> 
> Sample splat reported by Kyle Zeng
> 
> [    5.405624] 0: reclassify loop, rule prio 0, protocol 800
> [    5.406326] ==================================================================
> [    5.407240] BUG: KASAN: slab-out-of-bounds in cbq_enqueue+0x54b/0xea0
> [    5.407987] Read of size 1 at addr ffff88800e3122aa by task poc/299
> [    5.408731]
> [    5.408897] CPU: 0 PID: 299 Comm: poc Not tainted 5.10.155+ #15
> [    5.409516] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.15.0-1 04/01/2014
> [    5.410439] Call Trace:
> [    5.410764]  dump_stack+0x87/0xcd
> [    5.411153]  print_address_description+0x7a/0x6b0
> [    5.411687]  ? vprintk_func+0xb9/0xc0
> [    5.411905]  ? printk+0x76/0x96
> [    5.412110]  ? cbq_enqueue+0x54b/0xea0
> [    5.412323]  kasan_report+0x17d/0x220
> [    5.412591]  ? cbq_enqueue+0x54b/0xea0
> [    5.412803]  __asan_report_load1_noabort+0x10/0x20
> [    5.413119]  cbq_enqueue+0x54b/0xea0
> [    5.413400]  ? __kasan_check_write+0x10/0x20
> [    5.413679]  __dev_queue_xmit+0x9c0/0x1db0
> [    5.413922]  dev_queue_xmit+0xc/0x10
> [    5.414136]  ip_finish_output2+0x8bc/0xcd0
> [    5.414436]  __ip_finish_output+0x472/0x7a0
> [    5.414692]  ip_finish_output+0x5c/0x190
> [    5.414940]  ip_output+0x2d8/0x3c0
> [    5.415150]  ? ip_mc_finish_output+0x320/0x320
> [    5.415429]  __ip_queue_xmit+0x753/0x1760
> [    5.415664]  ip_queue_xmit+0x47/0x60
> [    5.415874]  __tcp_transmit_skb+0x1ef9/0x34c0
> [    5.416129]  tcp_connect+0x1f5e/0x4cb0
> [    5.416347]  tcp_v4_connect+0xc8d/0x18c0
> [    5.416577]  __inet_stream_connect+0x1ae/0xb40
> [    5.416836]  ? local_bh_enable+0x11/0x20
> [    5.417066]  ? lock_sock_nested+0x175/0x1d0
> [    5.417309]  inet_stream_connect+0x5d/0x90
> [    5.417548]  ? __inet_stream_connect+0xb40/0xb40
> [    5.417817]  __sys_connect+0x260/0x2b0
> [    5.418037]  __x64_sys_connect+0x76/0x80
> [    5.418267]  do_syscall_64+0x31/0x50
> [    5.418477]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> [    5.418770] RIP: 0033:0x473bb7
> [    5.418952] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00
> 00 00 90 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2a 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 18 89 54 24 0c 48 89 34
> 24 89
> [    5.420046] RSP: 002b:00007fffd20eb0f8 EFLAGS: 00000246 ORIG_RAX:
> 000000000000002a
> [    5.420472] RAX: ffffffffffffffda RBX: 00007fffd20eb578 RCX: 0000000000473bb7
> [    5.420872] RDX: 0000000000000010 RSI: 00007fffd20eb110 RDI: 0000000000000007
> [    5.421271] RBP: 00007fffd20eb150 R08: 0000000000000001 R09: 0000000000000004
> [    5.421671] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> [    5.422071] R13: 00007fffd20eb568 R14: 00000000004fc740 R15: 0000000000000002
> [    5.422471]
> [    5.422562] Allocated by task 299:
> [    5.422782]  __kasan_kmalloc+0x12d/0x160
> [    5.423007]  kasan_kmalloc+0x5/0x10
> [    5.423208]  kmem_cache_alloc_trace+0x201/0x2e0
> [    5.423492]  tcf_proto_create+0x65/0x290
> [    5.423721]  tc_new_tfilter+0x137e/0x1830
> [    5.423957]  rtnetlink_rcv_msg+0x730/0x9f0
> [    5.424197]  netlink_rcv_skb+0x166/0x300
> [    5.424428]  rtnetlink_rcv+0x11/0x20
> [    5.424639]  netlink_unicast+0x673/0x860
> [    5.424870]  netlink_sendmsg+0x6af/0x9f0
> [    5.425100]  __sys_sendto+0x58d/0x5a0
> [    5.425315]  __x64_sys_sendto+0xda/0xf0
> [    5.425539]  do_syscall_64+0x31/0x50
> [    5.425764]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> [    5.426065]
> [    5.426157] The buggy address belongs to the object at ffff88800e312200
> [    5.426157]  which belongs to the cache kmalloc-128 of size 128
> [    5.426955] The buggy address is located 42 bytes to the right of
> [    5.426955]  128-byte region [ffff88800e312200, ffff88800e312280)
> [    5.427688] The buggy address belongs to the page:
> [    5.427992] page:000000009875fabc refcount:1 mapcount:0
> mapping:0000000000000000 index:0x0 pfn:0xe312
> [    5.428562] flags: 0x100000000000200(slab)
> [    5.428812] raw: 0100000000000200 dead000000000100 dead000000000122
> ffff888007843680
> [    5.429325] raw: 0000000000000000 0000000000100010 00000001ffffffff
> ffff88800e312401
> [    5.429875] page dumped because: kasan: bad access detected
> [    5.430214] page->mem_cgroup:ffff88800e312401
> [    5.430471]
> [    5.430564] Memory state around the buggy address:
> [    5.430846]  ffff88800e312180: fc fc fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc
> [    5.431267]  ffff88800e312200: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 fc
> [    5.431705] >ffff88800e312280: fc fc fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc
> [    5.432123]                                   ^
> [    5.432391]  ffff88800e312300: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 fc
> [    5.432810]  ffff88800e312380: fc fc fc fc fc fc fc fc fc fc fc fc
> fc fc fc fc
> [    5.433229] ==================================================================
> [    5.433648] Disabling lock debugging due to kernel taint
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Kyle Zeng <zengyhkyle@gmail.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [Harshit: backport for 4.14.y]
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> Only compile and boot tested.
> This is marked as Fix for CVE-2023-23454.
> 
> Would be nice if any net developer review this before merging this to stable.

Both now queued up, thanks.

greg k-h
