Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D026D631900
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 04:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiKUDnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 22:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiKUDnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 22:43:50 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5975175AB
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 19:43:49 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id g4-20020a92cda4000000b00301ff06da14so7844490ild.11
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 19:43:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I8ymfyddKbS8oyuAsgyHKgSZR0unnve/LUS0JRIR+YI=;
        b=RK8T/JyOWlbQLhg1CBKi4FEIAjVGPBcU5MxUva8gaaf3p7Djtx+D7C6RT3fFp5b324
         EBeXT0aSoBXVfhOvckyWRvIrSj7hPTXpn0vf0eUA561hpAFG3jVwCCUbprBs6kLyyeh4
         VvIy/EAGNXK9kzHkmbQ4H60g558wfEgYE6Ch40p/hqS0xf+OdpNV5zCmnXyCNTcEGvs2
         j8276zft+lLJIWrjIf48rHu+/ULrvezPHZib1akM9ireGxfWBB7h96C+Z9qhMTz4Vd1Q
         0fE2j2lJKGHzbqKrl1Crcp/AV88k+H1mcRQH+HFoHKXza0CVZzSjiRkLJii2o7YzkOBP
         qE5g==
X-Gm-Message-State: ANoB5pnRepseqN164HIEGZl13NoD0ODB6KK1wsb3WsaxhICvnUFEJ6LN
        fyZ4WxUxCV1B3OE0ahHxCYVouIIo2wOTVl8V0D6jjIM8Itd1
X-Google-Smtp-Source: AA0mqf7TBhw4gaewC3AL67IzLA5JcsVHLDEepE8sluUII2UrK5EisrtQDF9GEMugpSbvAmX1HgXO9zYNwIrwtDQ4UbT2FPiOIYEK
MIME-Version: 1.0
X-Received: by 2002:a02:16c7:0:b0:375:1b48:1e61 with SMTP id
 a190-20020a0216c7000000b003751b481e61mr527080jaa.269.1669002229278; Sun, 20
 Nov 2022 19:43:49 -0800 (PST)
Date:   Sun, 20 Nov 2022 19:43:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000170e305edf2dd92@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in rhltable_lookup
From:   syzbot <syzbot+fa4fe30392e9e8fd16a3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9500fc6e9e60 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=173f6c21880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b25c9f218686dd5e
dashboard link: https://syzkaller.appspot.com/bug?extid=fa4fe30392e9e8fd16a3
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1139042d880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111806b5880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1363e60652f7/disk-9500fc6e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fcc4da811bb6/vmlinux-9500fc6e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b554298f1fa/Image-9500fc6e.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa4fe30392e9e8fd16a3@syzkaller.appspotmail.com

Unable to handle kernel paging request at virtual address ffff000308e88118
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000005
  CM = 0, WnR = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001c5508000
[ffff000308e88118] pgd=180000023fff8003, p4d=180000023fff8003, pud=0000000000000000
Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 3086 Comm: kworker/0:6 Not tainted 6.1.0-rc5-syzkaller-32269-g9500fc6e9e60 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Workqueue: mld mld_ifc_work
pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : rht_ptr_rcu include/linux/rhashtable.h:369 [inline]
pc : __rhashtable_lookup include/linux/rhashtable.h:599 [inline]
pc : rhltable_lookup+0xd4/0x398 include/linux/rhashtable.h:688
lr : rht_bucket include/linux/rhashtable.h:290 [inline]
lr : __rhashtable_lookup include/linux/rhashtable.h:597 [inline]
lr : rhltable_lookup+0xc8/0x398 include/linux/rhashtable.h:688
sp : ffff800008003d60
x29: ffff800008003d80 x28: ffff80000d98f000 x27: 0000000000000000
x26: 0000000000000002 x25: 0000000000000000 x24: ffff000308e88118
x23: ffff80000d98f000 x22: ffff000308e88119 x21: ffff0000cb7aa400
x20: ffff0000ce7c17b0 x19: ffff0000cae1f834 x18: 00000000000000c0
x17: ffff80000ddda198 x16: 0000000000000101 x15: 0000000000000100
x14: 0000000000000000 x13: 000000000000000c x12: ffff80000d690450
x11: ff8080000bd03d04 x10: 0000000000000000 x9 : ffff80000bd03d04
x8 : ffff000308e88098 x7 : ffff80000bcfd720 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000002
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000000000
Call trace:
 rhltable_lookup+0xd4/0x398 include/linux/rhashtable.h:688
 sta_info_hash_lookup net/mac80211/sta_info.c:195 [inline]
 sta_info_get_by_addrs+0x64/0xf8 net/mac80211/sta_info.c:320
 ieee80211_tx_status+0xd8/0x1ac net/mac80211/status.c:1096
 ieee80211_tasklet_handler+0x5c/0x110 net/mac80211/main.c:319
 tasklet_action_common+0x1d4/0x248
 tasklet_action+0x30/0x3c kernel/softirq.c:818
 _stext+0x168/0x37c
 ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:79
 call_on_irq_stack+0x2c/0x54 arch/arm64/kernel/entry.S:892
 do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:84
 do_softirq+0xac/0x108 kernel/softirq.c:472
 __local_bh_enable_ip+0x18c/0x1a4 kernel/softirq.c:396
 local_bh_enable+0x28/0x34 include/linux/bottom_half.h:33
 rcu_read_unlock_bh include/linux/rcupdate.h:808 [inline]
 ip6_finish_output2+0xa1c/0xbec net/ipv6/ip6_output.c:135
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x448/0x4c4 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip6_output+0x180/0x2dc net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:445 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 mld_sendpack+0x514/0x924 net/ipv6/mcast.c:1820
 mld_send_cr+0x4e8/0x5a8 net/ipv6/mcast.c:2121
 mld_ifc_work+0x38/0x290 net/ipv6/mcast.c:2653
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
Code: 97168d0a 8b384ea8 91020118 b2400316 (f940031a) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	97168d0a 	bl	0xfffffffffc5a3428
   4:	8b384ea8 	add	x8, x21, w24, uxtw #3
   8:	91020118 	add	x24, x8, #0x80
   c:	b2400316 	orr	x22, x24, #0x1
* 10:	f940031a 	ldr	x26, [x24] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
