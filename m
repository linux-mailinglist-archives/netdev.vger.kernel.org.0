Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC824517D43
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 08:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiECGYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 02:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiECGYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 02:24:54 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E608037029
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 23:21:22 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id j6-20020a5d93c6000000b0064fbbf9566bso12134913ioo.12
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 23:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ebMvU965Rx6jnEyB4WcWSwsIYiNVXS7MY8ZncDhxzOs=;
        b=oy13K4X2Qr0KKpKDNi7G2N+/nvM1y4L45p2thn501C8+ofBdA5hLxSovAt/CauJnCY
         EH6wHNBQ5PIiJsnoc4Lq2o2M0tSAS6CPOVeEBtJZ75hTNvG5ePTZZ5gKjlTiL2phAhvd
         c+aVzql97PEO84ZFt1uoR6lj4srS9fqbrW0Fb9uXSiN1TIyXuJdcwO6IeUdJxMUjoVkE
         pyRQhUkvYVbQrP2XuTOjn/l8DF+b2F5trQNxBMCqh2WaQC/1auVU9Fa6A3NFjR3eVHLO
         x41yoEOr78D/Ikiu2rqSRO2oaxY2T6oJiPwWgM9qnXlMAmOohTBndrrJRWHkC6Fobgdm
         XOJg==
X-Gm-Message-State: AOAM533H0AH1crHs25w8e0f0/fViw4DcgthXUxmVMz8wQTFwY4jd+IW7
        3QarfVZNHEkp49Qe/vaUPYZ5/GH7pTKyYfTX2WAsRCz+atoq
X-Google-Smtp-Source: ABdhPJycecFAwz+gCI4BE4PnLWmzJEWTyTPiMc3rZqlzbd0rc5XssJ2oSXwor3h0t0SWFiBOJDbgT3GWuuMphv4YIOx4+KWTfZrH
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4089:b0:32b:b4d:7726 with SMTP id
 m9-20020a056638408900b0032b0b4d7726mr6325242jam.107.1651558882343; Mon, 02
 May 2022 23:21:22 -0700 (PDT)
Date:   Mon, 02 May 2022 23:21:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000082033405de15849d@google.com>
Subject: [syzbot] KASAN: use-after-free Read in tipc_named_reinit (2)
From:   syzbot <syzbot+47af19f3307fc9c5c82e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jmaloy@redhat.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    17d49e6e8012 Merge branch 'remove-NAPI_POLL_WEIGHT-copies'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15a8a926f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f67580b287bc88d
dashboard link: https://syzkaller.appspot.com/bug?extid=47af19f3307fc9c5c82e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+47af19f3307fc9c5c82e@syzkaller.appspotmail.com

tipc: Node number set to 1
==================================================================
BUG: KASAN: use-after-free in tipc_named_reinit+0x94f/0x9b0 net/tipc/name_distr.c:413
Read of size 8 at addr ffff88805299a000 by task kworker/1:9/23764

CPU: 1 PID: 23764 Comm: kworker/1:9 Not tainted 5.18.0-rc4-syzkaller-00878-g17d49e6e8012 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events tipc_net_finalize_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 tipc_named_reinit+0x94f/0x9b0 net/tipc/name_distr.c:413
 tipc_net_finalize+0x234/0x3d0 net/tipc/net.c:138
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

The buggy address belongs to the physical page:
page:ffffea00014a6680 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5299a
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 2, migratetype Unmovable, gfp_mask 0x140dc0(GFP_USER|__GFP_COMP|__GFP_ZERO), pid 32268, tgid 32268 (syz-executor.0), ts 2019363271552, free_ts 2022187878511
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 kmalloc_order+0x34/0xf0 mm/slab_common.c:953
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:969
 kmalloc_large include/linux/slab.h:510 [inline]
 kmalloc include/linux/slab.h:574 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 tipc_nametbl_init+0x145/0x480 net/tipc/name_table.c:891
 tipc_init_net+0x408/0x660 net/tipc/core.c:80
 ops_init+0xaf/0x470 net/core/net_namespace.c:134
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:325
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:471
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3132
 __do_sys_unshare kernel/fork.c:3203 [inline]
 __se_sys_unshare kernel/fork.c:3201 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3201
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 tipc_exit_net+0x132/0x560 net/tipc/core.c:117
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:162
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Memory state around the buggy address:
 ffff888052999f00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888052999f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88805299a000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88805299a080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88805299a100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
