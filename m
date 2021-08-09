Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27773E4D04
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhHITXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbhHITXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 15:23:12 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2014C0613D3;
        Mon,  9 Aug 2021 12:22:51 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p38so8667158lfa.0;
        Mon, 09 Aug 2021 12:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=w3tbBGNJpLHc/C3pq2pDHqNw7VDhxGZ5hPAvVRFbnWs=;
        b=qO6aqFDioMAtO1VlSxGzXJRyPuIEBIkeVFYK2YaU2/3MxajupOapNuZDHWyZH6k2J5
         7FS1TeMXUuMBALsIhDQAkAYnNuqw2/MwjkmOz+sOP5ux8rEplfBxqGcGgF1OnJVSwanB
         wresSVEvxTSxLcuuLcwNnqZTBpJ55bbBw/K6Q/ivdybjwmLtGOprBQH96mTnLqWNGhrI
         2LRb7OyTWxXV4AlP/umIyOMMrnW/tf55cDvylYvwmoJn+RN9+Mvfa4wZ35Pc/LD8U0LR
         pDz9fI8AR0J+4LSQkhA4abzEnfgDsskM5Mbkr/CGTbEHq0am8lla74KOeFsavE2zjVgc
         /cCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=w3tbBGNJpLHc/C3pq2pDHqNw7VDhxGZ5hPAvVRFbnWs=;
        b=NM+Ja0Ps0aCuROlcqjQdDrCxJVO0z1NfSyh+f3cffLP54YwcWNlYUOy+eJsPvQ/KwF
         3qvr8aVxC/8hOAP+onZuhvOzLtyeevUEP1SmoEb2aHH4xf4d/XmHR1mHMWcrPV1HT6OR
         lTbRR4U3y+rV10qwr17y5wKEic9XCkC98SqR/ZQ6tvNN6b1+5z6EFx4HTrwWDkuuLjIh
         yTTR8O1ibewbv2lJzKCzi3UkOrEyl2fm7Y228WARAqFrxc6PclNK4IEtdPVUevaRsEpf
         CivoSFvDFgHC2rLEDf8ccbhF00pHR+43X85FpG+Fa1AfHcJEmkXvyQ8vJCS5FqjnCb6r
         RuBA==
X-Gm-Message-State: AOAM5326L1VcCCz2DjrWJvkknnYUyYMy7Ej9j9oIEgqZHqpn20xNKXOO
        MP8czEnvlAEk/5yUff6g5Og=
X-Google-Smtp-Source: ABdhPJzmwcAERU9dZaauyZ2TtpN0yXv+TjXVqNoXKa0laJG+N+XKByztdntRLFEGY1r668dzNGhURQ==
X-Received: by 2002:a05:6512:2215:: with SMTP id h21mr18616628lfu.543.1628536970060;
        Mon, 09 Aug 2021 12:22:50 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id h9sm1243524ljq.92.2021.08.09.12.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 12:22:49 -0700 (PDT)
Subject: Re: [syzbot] KASAN: use-after-free Write in nft_ct_tmpl_put_pcpu
To:     syzbot <syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000b720b705c8f8599f@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
Message-ID: <cdb5f0c9-1ad9-dd9d-b24d-e127928ada98@gmail.com>
Date:   Mon, 9 Aug 2021 22:22:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <000000000000b720b705c8f8599f@google.com>
Content-Type: multipart/mixed;
 boundary="------------B2B9016DCAFA275198E2C6CE"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------B2B9016DCAFA275198E2C6CE
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/21 4:44 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    894d6f401b21 Merge tag 'spi-fix-v5.14-rc4' of git://git.ke..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17c622fa300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
> dashboard link: https://syzkaller.appspot.com/bug?extid=649e339fa6658ee623d3
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110319aa300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1142fac9d00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
> BUG: KASAN: use-after-free in atomic_dec_and_test include/asm-generic/atomic-instrumented.h:542 [inline]
> BUG: KASAN: use-after-free in nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:33 [inline]
> BUG: KASAN: use-after-free in nf_ct_put include/net/netfilter/nf_conntrack.h:176 [inline]
> BUG: KASAN: use-after-free in nft_ct_tmpl_put_pcpu+0x135/0x1e0 net/netfilter/nft_ct.c:356
> Write of size 4 at addr ffff88803d750400 by task syz-executor409/9789
> 
> CPU: 0 PID: 9789 Comm: syz-executor409 Not tainted 5.14.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>   print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
>   __kasan_report mm/kasan/report.c:419 [inline]
>   kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
>   check_region_inline mm/kasan/generic.c:183 [inline]
>   kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
>   instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>   atomic_dec_and_test include/asm-generic/atomic-instrumented.h:542 [inline]
>   nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:33 [inline]
>   nf_ct_put include/net/netfilter/nf_conntrack.h:176 [inline]
>   nft_ct_tmpl_put_pcpu+0x135/0x1e0 net/netfilter/nft_ct.c:356

(*)


>   __nft_ct_set_destroy net/netfilter/nft_ct.c:529 [inline]
>   __nft_ct_set_destroy net/netfilter/nft_ct.c:518 [inline]
>   nft_ct_set_init+0x41e/0x750 net/netfilter/nft_ct.c:614
>   nf_tables_newexpr net/netfilter/nf_tables_api.c:2742 [inline]
>   nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2780
>   nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5284
>   nf_tables_newset+0x208a/0x32f0 net/netfilter/nf_tables_api.c:4389
>   nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
>   nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
>   nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
>   netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>   netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>   sock_sendmsg_nosec net/socket.c:703 [inline]
>   sock_sendmsg+0xcf/0x120 net/socket.c:723
>   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
>   ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
>   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x444819

[snip]

> Freed by task 9788:
>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>   kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>   kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
>   ____kasan_slab_free mm/kasan/common.c:366 [inline]
>   ____kasan_slab_free mm/kasan/common.c:328 [inline]
>   __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
>   kasan_slab_free include/linux/kasan.h:230 [inline]
>   slab_free_hook mm/slub.c:1625 [inline]
>   slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1650
>   slab_free mm/slub.c:3210 [inline]
>   kfree+0xe4/0x530 mm/slub.c:4264
>   nf_ct_tmpl_free net/netfilter/nf_conntrack_core.c:590 [inline]
>   destroy_conntrack+0x222/0x2c0 net/netfilter/nf_conntrack_core.c:613
>   nf_conntrack_destroy+0xab/0x230 net/netfilter/core.c:677
>   nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:34 [inline]
>   nf_ct_put include/net/netfilter/nf_conntrack.h:176 [inline]
>   nft_ct_tmpl_put_pcpu+0x15e/0x1e0 net/netfilter/nft_ct.c:356

I think, there a missing lock in this function:

	for_each_possible_cpu(cpu) {
		ct = per_cpu(nft_ct_pcpu_template, cpu);
		if (!ct)
			break;
		nf_ct_put(ct);
		per_cpu(nft_ct_pcpu_template, cpu) = NULL;
		
	}

Syzbot hit a UAF in nft_ct_tmpl_put_pcpu() (*), but freed template 
should be NULL.

So I suspect following scenario:


CPU0:			CPU1:
= per_cpu()
			= per_cpu()

nf_ct_put
per_cpu = NULL
			nf_ct_put()
			* UAF *


#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master


With regards,
Pavel Skripkin

>   __nft_ct_set_destroy net/netfilter/nft_ct.c:529 [inline]
>   __nft_ct_set_destroy net/netfilter/nft_ct.c:518 [inline]
>   nft_ct_set_init+0x41e/0x750 net/netfilter/nft_ct.c:614
>   nf_tables_newexpr net/netfilter/nf_tables_api.c:2742 [inline]
>   nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2780
>   nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5284
>   nf_tables_newset+0x208a/0x32f0 net/netfilter/nf_tables_api.c:4389
>   nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
>   nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
>   nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
>   netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>   netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>   sock_sendmsg_nosec net/socket.c:703 [inline]
>   sock_sendmsg+0xcf/0x120 net/socket.c:723
>   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
>   ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
>   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The buggy address belongs to the object at ffff88803d750400
>   which belongs to the cache kmalloc-512 of size 512
> The buggy address is located 0 bytes inside of
>   512-byte region [ffff88803d750400, ffff88803d750600)
> The buggy address belongs to the page:
> page:ffffea0000f5d400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3d750
> head:ffffea0000f5d400 order:2 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010841c80
> raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9789, ts 226704064982, free_ts 0
>   prep_new_page mm/page_alloc.c:2436 [inline]
>   get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
>   __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
>   alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
>   alloc_slab_page mm/slub.c:1688 [inline]
>   allocate_slab+0x32e/0x4b0 mm/slub.c:1828
>   new_slab mm/slub.c:1891 [inline]
>   new_slab_objects mm/slub.c:2637 [inline]
>   ___slab_alloc+0x4ba/0x820 mm/slub.c:2800
>   __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2840
>   slab_alloc_node mm/slub.c:2922 [inline]
>   slab_alloc mm/slub.c:2964 [inline]
>   kmem_cache_alloc_trace+0x30f/0x3c0 mm/slub.c:2981
>   kmalloc include/linux/slab.h:591 [inline]
>   kzalloc include/linux/slab.h:721 [inline]
>   nf_ct_tmpl_alloc+0x8d/0x270 net/netfilter/nf_conntrack_core.c:569
>   nft_ct_tmpl_alloc_pcpu net/netfilter/nft_ct.c:371 [inline]
>   nft_ct_set_init+0x4d6/0x750 net/netfilter/nft_ct.c:567
>   nf_tables_newexpr net/netfilter/nf_tables_api.c:2742 [inline]
>   nft_expr_init+0x145/0x2d0 net/netfilter/nf_tables_api.c:2780
>   nft_set_elem_expr_alloc+0x27/0x280 net/netfilter/nf_tables_api.c:5284
>   nf_tables_newset+0x208a/0x32f0 net/netfilter/nf_tables_api.c:4389
>   nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
>   nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
>   nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
>   netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>   netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
>   ffff88803d750300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff88803d750380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>ffff88803d750400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                     ^
>   ffff88803d750480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff88803d750500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 

--------------B2B9016DCAFA275198E2C6CE
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-netfilter-add-mutex-to-protect-nft_ct_pcpu_template.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-netfilter-add-mutex-to-protect-nft_ct_pcpu_template.pat";
 filename*1="ch"

From 39275bfc1bac5758752ba2bf4df68e244590589b Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Mon, 9 Aug 2021 22:13:44 +0300
Subject: [PATCH] netfilter: add mutex to protect nft_ct_pcpu_template

/* ... */

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/netfilter/nft_ct.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 337e22d8b40b..09f03036e5c8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
+#include <linux/mutex.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
@@ -41,6 +42,7 @@ struct nft_ct_helper_obj  {
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 static DEFINE_PER_CPU(struct nf_conn *, nft_ct_pcpu_template);
 static unsigned int nft_ct_pcpu_template_refcnt __read_mostly;
+static DEFINE_MUTEX(nft_ct_pcpu_template_mutex);
 #endif
 
 static u64 nft_ct_get_eval_counter(const struct nf_conn_counter *c,
@@ -344,11 +346,13 @@ static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
 };
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-static void nft_ct_tmpl_put_pcpu(void)
+static void nft_ct_tmpl_put_pcpu(bool lock)
 {
 	struct nf_conn *ct;
 	int cpu;
 
+	if (lock)
+		mutex_lock(&nft_ct_pcpu_template_mutex);
 	for_each_possible_cpu(cpu) {
 		ct = per_cpu(nft_ct_pcpu_template, cpu);
 		if (!ct)
@@ -356,6 +360,8 @@ static void nft_ct_tmpl_put_pcpu(void)
 		nf_ct_put(ct);
 		per_cpu(nft_ct_pcpu_template, cpu) = NULL;
 	}
+	if (lock)
+		mutex_unlock(&nft_ct_pcpu_template_mutex);
 }
 
 static bool nft_ct_tmpl_alloc_pcpu(void)
@@ -367,16 +373,18 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
 	if (nft_ct_pcpu_template_refcnt)
 		return true;
 
+	mutex_lock(&nft_ct_pcpu_template_mutex);
 	for_each_possible_cpu(cpu) {
 		tmp = nf_ct_tmpl_alloc(&init_net, &zone, GFP_KERNEL);
 		if (!tmp) {
-			nft_ct_tmpl_put_pcpu();
+			nft_ct_tmpl_put_pcpu(false);
 			return false;
 		}
 
 		atomic_set(&tmp->ct_general.use, 1);
 		per_cpu(nft_ct_pcpu_template, cpu) = tmp;
 	}
+	mutex_unlock(&nft_ct_pcpu_template_mutex);
 
 	return true;
 }
@@ -526,7 +534,7 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
 		if (--nft_ct_pcpu_template_refcnt == 0)
-			nft_ct_tmpl_put_pcpu();
+			nft_ct_tmpl_put_pcpu(true);
 		break;
 #endif
 	default:
-- 
2.32.0


--------------B2B9016DCAFA275198E2C6CE--
