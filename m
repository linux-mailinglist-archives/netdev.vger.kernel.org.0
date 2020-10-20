Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A0629361C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405506AbgJTHxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:53:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:53677 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405495AbgJTHxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 03:53:15 -0400
Received: by mail-io1-f71.google.com with SMTP id m23so1027785ioj.20
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 00:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xyw59o8B/DKvkeikFlmFHxYKEdrbDE7kQ7mI3nwGAWg=;
        b=RV7wCM0sqZj7y3lUWshCShH90LmYR3FUtShcQnhD7sNtsL7uG1RQatLLBNHtPzc2a9
         94GallqzCTI1b+cLLYDC478iGzF1QKHy2BeD1yq7jczG61Vvae8QoifKUbihOlet8t+b
         0HB437cyh8+Av2nk6TGg70P5JcMCCLEVXbT/nzPNPU7fQkfCV2jIKBoKAD0voNaMtytm
         urjweIgFKA5tfyNhMzvR5no1FOsRQ/BzBuTqS8fGULzZWwTC4dPOY9fl1USIDcd+Oo1N
         a59M3H5vwggPnO4u41xXi9C7jaopyV64AmLv/q/RTRLXVz8BgkGvyKmKtiT9f8SbwmGk
         IWEg==
X-Gm-Message-State: AOAM532u/JIO1hOf1GUjFDVn3BZScnNxWkyBFIiVCExA7Nin0vtgg8Gh
        3BzvKFi8uGRBv/OnU7owD+UkG5f5I2TDZwZhKizlpu5IaWe6
X-Google-Smtp-Source: ABdhPJxOniZHPYknoZBPTZBelEQsogFWRtmZuo8NP8odPRH7sHaBioSiXdDt2p7Cuwps9zr7aDdufHk03lChZ2/ZeQvkp5wdf9EX
MIME-Version: 1.0
X-Received: by 2002:a05:6638:f03:: with SMTP id h3mr1103706jas.36.1603180396490;
 Tue, 20 Oct 2020 00:53:16 -0700 (PDT)
Date:   Tue, 20 Oct 2020 00:53:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b33ab05b2158654@google.com>
Subject: KMSAN: uninit-value in radix_tree_lookup
From:   syzbot <syzbot+bcc3c6bd745b87e32d3e@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        manivannan.sadhasivam@linaro.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e67f4ba8 kmsan_hooks: do not enter/exit runtime on ioremap
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16f3ce94500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cac9da432bb698f3
dashboard link: https://syzkaller.appspot.com/bug?extid=bcc3c6bd745b87e32d3e
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10051a30500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17223907900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bcc3c6bd745b87e32d3e@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __radix_tree_lookup lib/radix-tree.c:758 [inline]
BUG: KMSAN: uninit-value in radix_tree_lookup+0x409/0x420 lib/radix-tree.c:818
CPU: 1 PID: 8484 Comm: syz-executor663 Not tainted 5.9.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:122
 __msan_warning+0x55/0x90 mm/kmsan/kmsan_instr.c:201
 __radix_tree_lookup lib/radix-tree.c:758 [inline]
 radix_tree_lookup+0x409/0x420 lib/radix-tree.c:818
 qrtr_tx_resume net/qrtr/qrtr.c:224 [inline]
 qrtr_endpoint_post+0x1172/0x1700 net/qrtr/qrtr.c:498
 qrtr_tun_write_iter+0x216/0x370 net/qrtr/tun.c:92
 call_write_iter include/linux/fs.h:1882 [inline]
 new_sync_write fs/read_write.c:503 [inline]
 vfs_write+0xfba/0x1870 fs/read_write.c:586
 ksys_write+0x2af/0x4d0 fs/read_write.c:639
 __do_sys_write fs/read_write.c:651 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:648
 __x64_sys_write+0x4a/0x70 fs/read_write.c:648
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441239
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdad6a3b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441239
RDX: 00000000000000e4 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000401fe0
R13: 0000000000402070 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:143
 kmsan_alloc_page+0xce/0x1d0 mm/kmsan/kmsan_shadow.c:278
 __alloc_pages_nodemask+0x84e/0x1040 mm/page_alloc.c:4938
 __alloc_pages include/linux/gfp.h:509 [inline]
 __alloc_pages_node include/linux/gfp.h:522 [inline]
 alloc_pages_node include/linux/gfp.h:536 [inline]
 __page_frag_cache_refill mm/page_alloc.c:5011 [inline]
 page_frag_alloc+0x35b/0x890 mm/page_alloc.c:5041
 __napi_alloc_skb+0x1c0/0xab0 net/core/skbuff.c:519
 napi_alloc_skb include/linux/skbuff.h:2865 [inline]
 page_to_skb+0x142/0x1640 drivers/net/virtio_net.c:384
 receive_mergeable+0xedd/0x5cd0 drivers/net/virtio_net.c:944
 receive_buf+0x2db/0x2ba0 drivers/net/virtio_net.c:1054
 virtnet_receive drivers/net/virtio_net.c:1346 [inline]
 virtnet_poll+0xa51/0x1d10 drivers/net/virtio_net.c:1451
 napi_poll+0x4aa/0x1090 net/core/dev.c:6688
 net_rx_action+0x35c/0xd40 net/core/dev.c:6758
 __do_softirq+0x1b9/0x7ed kernel/softirq.c:299
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
