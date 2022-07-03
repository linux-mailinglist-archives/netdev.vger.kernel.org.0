Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8758D564795
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 15:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiGCNxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 09:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbiGCNxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 09:53:38 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01C92AC4;
        Sun,  3 Jul 2022 06:53:36 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l6so6383175plg.11;
        Sun, 03 Jul 2022 06:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=RssbEV4CX6Uzagd5o32pWqmjmfYNXHia67FI2mX+P8U=;
        b=HYGSv9AF2xVDgQ2prTeWC4aKR/7jaeTynnWbVWFguPHZOsWTNDNneUg+PtOkB6EMp0
         MsO6zEKsWcFhsi868t7X56htnDz9Lt03cQrNPbQBNResPlf49fmLsUf+VXAlS/s3BgEa
         D2yqskCIOuOqLuLdDgCSQJElN4kEEvWZVmMQBdkFCz+r3rraCctOcoPLy45CpqbvFwg3
         6SvFK3oCjOZP0CzqMLBr8ID2PAjiv87TFPIfL9JfaPB/IcSWopvvEkypkhfmcL2k+34L
         9kNY8MpxFMsGfyaYdwCYhVYBzq67OjZiDBxsQB5eR88UiwMMQFvFwK8jworOoJgK2yWw
         LQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RssbEV4CX6Uzagd5o32pWqmjmfYNXHia67FI2mX+P8U=;
        b=ICt+sYEMtFfe9DEcnx9TrXpcAlPQ+fS7R5ylCn5FG/uQBFIPMRXkgl28/tS7fFUcQ/
         Yv33BOStRddZKhf+ZgxuT5/Y7WTH/gxIrbYd1G6m1qU02fJK9+4SgDyViWiWlUnSPS//
         ybqGRBsCx84v3Zh9tFQiaLm5E8422Zb6xFyt9KqkOV5ViiV8P+29XV6QmsYDUSkBWcjJ
         y5eXf7V9S0WSLY3JVaH3YK6+PsUDhB2diVMAadf0K0pbSpuOhwbZ7tyrHKxF0Q8pEYeN
         D8pBDgi1imUErp0wn63vtr6LplhO/s+0uqHH9K9/p9sQH3kXr2VC9gxeUp5PDXKgvy0g
         nNyw==
X-Gm-Message-State: AJIora87nC5e4+23VWJJU2TXFfXP4SfCvXKjvbACDmXkjUw13yx1ceXo
        NLe3gpDOAPdC9+vSh6GXx73GVkXEkLo=
X-Google-Smtp-Source: AGRyM1uHnxh+ZIBl/RdXhLtONTroXwyBV+Fq5ZNGyOKvJOWsr0IX6ORbpMrIrIQEtSHoG2kcWEM7Vw==
X-Received: by 2002:a17:90b:1d84:b0:1ed:5918:74e3 with SMTP id pf4-20020a17090b1d8400b001ed591874e3mr28165239pjb.173.1656856416335;
        Sun, 03 Jul 2022 06:53:36 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id b27-20020aa78edb000000b005284b70fb21sm2995297pfr.177.2022.07.03.06.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 06:53:35 -0700 (PDT)
Message-ID: <895785b0-6e64-5f3d-367d-aaa2621f49bb@gmail.com>
Date:   Sun, 3 Jul 2022 22:53:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in ip6_mc_hdr
Content-Language: en-US
To:     syzbot <syzbot+a7f5cbe0f4682a059a8e@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <0000000000005ddbc405e2e133e7@google.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <0000000000005ddbc405e2e133e7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/3/22 16:02, syzbot wrote:
 > Hello,
 >
 > syzbot found the following issue on:
 >
 > HEAD commit:    d521bc0a0f7c Merge branch 
'mlxsw-unified-bridge-conversion..
 > git tree:       net-next
 > console output: https://syzkaller.appspot.com/x/log.txt?x=119c8ae0080000
 > kernel config: 
https://syzkaller.appspot.com/x/.config?x=3822ec9aaf800dfb
 > dashboard link: 
https://syzkaller.appspot.com/bug?extid=a7f5cbe0f4682a059a8e
 > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU 
Binutils for Debian) 2.35.2
 > syz repro: 
https://syzkaller.appspot.com/x/repro.syz?x=14c34c18080000
 > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16fac6c0080000
 >
 > Bisection is inconclusive: the issue happens on the oldest tested 
release.
 >
 > bisection log: 
https://syzkaller.appspot.com/x/bisect.txt?x=11e69790080000
 > final oops: 
https://syzkaller.appspot.com/x/report.txt?x=13e69790080000
 > console output: https://syzkaller.appspot.com/x/log.txt?x=15e69790080000
 >
 > IMPORTANT: if you fix the issue, please add the following tag to the 
commit:
 > Reported-by: syzbot+a7f5cbe0f4682a059a8e@syzkaller.appspotmail.com
 >
 > ==================================================================
 > BUG: KASAN: slab-out-of-bounds in ip6_flow_hdr 
include/net/ipv6.h:1007 [inline]
 > BUG: KASAN: slab-out-of-bounds in ip6_mc_hdr.constprop.0+0x4ec/0x5c0 
net/ipv6/mcast.c:1715
 > Write of size 4 at addr ffff888023d32fe0 by task kworker/1:3/2939
 >
 > CPU: 1 PID: 2939 Comm: kworker/1:3 Not tainted 
5.19.0-rc3-syzkaller-00644-gd521bc0a0f7c #0
 > Hardware name: Google Google Compute Engine/Google Compute Engine, 
BIOS Google 01/01/2011
 > Workqueue: mld mld_ifc_work
 > Call Trace:
 >   <TASK>
 >   __dump_stack lib/dump_stack.c:88 [inline]
 >   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 >   print_address_description.constprop.0.cold+0xeb/0x495 
mm/kasan/report.c:313
 >   print_report mm/kasan/report.c:429 [inline]
 >   kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 >   ip6_flow_hdr include/net/ipv6.h:1007 [inline]
 >   ip6_mc_hdr.constprop.0+0x4ec/0x5c0 net/ipv6/mcast.c:1715
 >   mld_newpack.isra.0+0x3c0/0x770 net/ipv6/mcast.c:1763
 >   add_grhead+0x295/0x340 net/ipv6/mcast.c:1849
 >   add_grec+0x1082/0x1560 net/ipv6/mcast.c:1987
 >   mld_send_cr net/ipv6/mcast.c:2113 [inline]
 >   mld_ifc_work+0x452/0xdc0 net/ipv6/mcast.c:2651
 >   process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 >   worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 >   kthread+0x2e9/0x3a0 kernel/kthread.c:376
 >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 >   </TASK>
 >
 > Allocated by task 2991:
 >   kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 >   kasan_set_track mm/kasan/common.c:45 [inline]
 >   set_alloc_info mm/kasan/common.c:436 [inline]
 >   ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 >   ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 >   __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
 >   kmalloc include/linux/slab.h:605 [inline]
 >   kzalloc include/linux/slab.h:733 [inline]
 >   tomoyo_encode2.part.0+0xe9/0x3a0 security/tomoyo/realpath.c:45
 >   tomoyo_encode2 security/tomoyo/realpath.c:31 [inline]
 >   tomoyo_encode+0x28/0x50 security/tomoyo/realpath.c:80
 >   tomoyo_realpath_from_path+0x186/0x620 security/tomoyo/realpath.c:288
 >   tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 >   tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 >   security_inode_getattr+0xcf/0x140 security/security.c:1344
 >   vfs_getattr fs/stat.c:157 [inline]
 >   vfs_statx+0x16a/0x390 fs/stat.c:232
 >   vfs_fstatat+0x8c/0xb0 fs/stat.c:255
 >   __do_sys_newfstatat+0x91/0x110 fs/stat.c:425
 >   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 >   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 >   entry_SYSCALL_64_after_hwframe+0x46/0xb0
 >
 > The buggy address belongs to the object at ffff888023d32f80
 >   which belongs to the cache kmalloc-64 of size 64
 > The buggy address is located 32 bytes to the right of
 >   64-byte region [ffff888023d32f80, ffff888023d32fc0)
 >
 > The buggy address belongs to the physical page:
 > page:ffffea00008f4c80 refcount:1 mapcount:0 mapping:0000000000000000 
index:0x0 pfn:0x23d32
 > flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
 > raw: 00fff00000000200 ffffea000097dec0 dead000000000003 ffff888011841640
 > raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
 > page dumped because: kasan: bad access detected
 > page_owner tracks the page as allocated
 > page last allocated via order 0, migratetype Unmovable, gfp_mask 
0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 47, tgid 47 
(kworker/u4:3), ts 9452910565, free_ts 9450274699
 >   prep_new_page mm/page_alloc.c:2456 [inline]
 >   get_page_from_freelist+0x1290/0x3b70 mm/page_alloc.c:4198
 >   __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5426
 >   alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 >   alloc_slab_page mm/slub.c:1824 [inline]
 >   allocate_slab+0x26c/0x3c0 mm/slub.c:1969
 >   new_slab mm/slub.c:2029 [inline]
 >   ___slab_alloc+0x9c4/0xe20 mm/slub.c:3031
 >   __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
 >   slab_alloc_node mm/slub.c:3209 [inline]
 >   __kmalloc_node+0x2cb/0x390 mm/slub.c:4490
 >   kmalloc_node include/linux/slab.h:623 [inline]
 >   __vmalloc_area_node mm/vmalloc.c:2981 [inline]
 >   __vmalloc_node_range+0xa40/0x13e0 mm/vmalloc.c:3165
 >   alloc_thread_stack_node kernel/fork.c:312 [inline]
 >   dup_task_struct kernel/fork.c:977 [inline]
 >   copy_process+0x156e/0x7020 kernel/fork.c:2071
 >   kernel_clone+0xe7/0xab0 kernel/fork.c:2655
 >   user_mode_thread+0xad/0xe0 kernel/fork.c:2724
 >   call_usermodehelper_exec_work kernel/umh.c:174 [inline]
 >   call_usermodehelper_exec_work+0xcc/0x180 kernel/umh.c:160
 >   process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 >   worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 >   kthread+0x2e9/0x3a0 kernel/kthread.c:376
 >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 > page last free stack trace:
 >   reset_page_owner include/linux/page_owner.h:24 [inline]
 >   free_pages_prepare mm/page_alloc.c:1371 [inline]
 >   free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1421
 >   free_unref_page_prepare mm/page_alloc.c:3343 [inline]
 >   free_unref_page+0x19/0x6a0 mm/page_alloc.c:3438
 >   __vunmap+0x85d/0xd30 mm/vmalloc.c:2665
 >   free_work+0x58/0x70 mm/vmalloc.c:97
 >   process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 >   worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 >   kthread+0x2e9/0x3a0 kernel/kthread.c:376
 >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 >
 > Memory state around the buggy address:
 >   ffff888023d32e80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 >   ffff888023d32f00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 >> ffff888023d32f80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 >                                                         ^
 >   ffff888023d33000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 >   ffff888023d33080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 > ==================================================================
 >
 >
 > ---
 > This report is generated by a bot. It may contain errors.
 > See https://goo.gl/tpsmEJ for more information about syzbot.
 > syzbot engineers can be reached at syzkaller@googlegroups.com.
 >
 > syzbot will keep track of this issue. See:
 > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
 > For information about bisection process see: 
https://goo.gl/tpsmEJ#bisection
 > syzbot can test patches for this issue, for details see:
 > https://goo.gl/tpsmEJ#testing-patches

I think this bug is similar to(or same) 
https://syzkaller.appspot.com/bug?id=21bae888144b4cc906971b7651bf7511e25910a2.
We can reproduce these problems with the reproducer, which the syzbot 
provided.

I'm suspecting this bug is from the net->ipv6.igmp_sk.
When mld worker is using igmp_sk, it is possibly already freed even if 
it calls in6_dev_hold() before using igmp_sk.

In order to test, I add the sock_{hold | put}() to around in6_dev_{hold 
| put}() like follows.

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7f695c39d9a8..4b68f46f013a 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -744,6 +744,7 @@ static void mld_add_delrec(struct inet6_dev *idev, 
struct ifmcaddr6 *im)
                 return;

         pmc->idev = im->idev;
+       sock_hold(dev_net(idev->dev)->ipv6.igmp_sk);
         in6_dev_hold(idev);
         pmc->mca_addr = im->mca_addr;
         pmc->mca_crcount = idev->mc_qrv;
@@ -803,6 +804,7 @@ static void mld_del_delrec(struct inet6_dev *idev, 
struct ifmcaddr6 *im)
                 } else {
                         im->mca_crcount = idev->mc_qrv;
                 }
+               sock_put(dev_net(pmc->idev->dev)->ipv6.igmp_sk);
                 in6_dev_put(pmc->idev);
                 ip6_mc_clear_src(pmc);
                 kfree_rcu(pmc, rcu);
...

I tested again for 30 minutes, there is no problem.
Anyway, I'm going to look into this more.

Thanks,
Taehee Yoo
