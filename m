Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68890A19A1
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 14:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfH2MKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 08:10:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48805 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfH2MKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 08:10:08 -0400
Received: by mail-io1-f71.google.com with SMTP id 67so3725656iob.15
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 05:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=P1PYtGhR+nPJP5/MoLNmKeczOItoTzGhqMoW1iD5Ejg=;
        b=shjVrWB7f+EyeM+rIEBwc0ttBkpGUW8W/8JhthoCIXQZojAN0o3DusUF8SKO29YLU1
         av2/YIjz01NCkSicCqvNrsg5nxKLnDgTq5yaI33A+6xmDfQK3Z55Drpu+zAH+TlktTqq
         aPPnfMVL7+t7x9uiVlnyXCWEmu/p5bhEhphPKo+8K6A0YqCQcuiuMoZpRxQu56vSvrrt
         XZhS76jk4QzA45RZNfUMqbOVeqN5Rcd6MCFjEF8SRUq/TH7vopFfOqoo8apymarXnL1J
         Y/vnGHnkTGa7PrW41kkThEK88NJpYj/n2l8ltHSS9LR619fmprMqpRNVGiM71A0N3Asx
         l73g==
X-Gm-Message-State: APjAAAWVciPzG+UhqAkH353lL/sCKxzQnx79Yv8c5r6EzkJpaF1Cpj5w
        JZ0wzRn+WnIo6PaPgPhhJnzZfZtYoP7DNzU2PdfJL4o28QLs
X-Google-Smtp-Source: APXvYqwKU0LnZmIscAtx+UWMsJ2X0GkN2Gmiz6Fv5gvajQ/lXxMcFNyhnkq6T4Et/BCqZAl0Akxpp4e/5LYmXb+Ygua1x6iMp0Ju
MIME-Version: 1.0
X-Received: by 2002:a5d:81cc:: with SMTP id t12mr10935890iol.157.1567080608044;
 Thu, 29 Aug 2019 05:10:08 -0700 (PDT)
Date:   Thu, 29 Aug 2019 05:10:08 -0700
In-Reply-To: <000000000000e695c1058fb26925@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa1d4a0591406266@google.com>
Subject: Re: KASAN: use-after-free Read in rxrpc_send_keepalive
From:   syzbot <syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    ed2393ca Add linux-next specific files for 20190827
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=156adb1e600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2ef5940a07ed45f4
dashboard link: https://syzkaller.appspot.com/bug?extid=d850c266e3df14da1d31
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167ab582600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d850c266e3df14da1d31@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
==================================================================
BUG: KASAN: use-after-free in rxrpc_send_keepalive+0x8a2/0x940  
net/rxrpc/output.c:634
Read of size 8 at addr ffff888086b01218 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.3.0-rc6-next-20190827 #74
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_peer_keepalive_worker
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  rxrpc_send_keepalive+0x8a2/0x940 net/rxrpc/output.c:634
  rxrpc_peer_keepalive_dispatch net/rxrpc/peer_event.c:369 [inline]
  rxrpc_peer_keepalive_worker+0x7be/0xd02 net/rxrpc/peer_event.c:430
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 8741:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc_array include/linux/slab.h:614 [inline]
  kcalloc include/linux/slab.h:625 [inline]
  alloc_pipe_info+0x199/0x420 fs/pipe.c:676
  get_pipe_inode fs/pipe.c:738 [inline]
  create_pipe_files+0x8e/0x730 fs/pipe.c:770
  __do_pipe_flags+0x48/0x250 fs/pipe.c:807
  do_pipe2+0x84/0x160 fs/pipe.c:855
  __do_sys_pipe2 fs/pipe.c:873 [inline]
  __se_sys_pipe2 fs/pipe.c:871 [inline]
  __x64_sys_pipe2+0x54/0x80 fs/pipe.c:871
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8741:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  free_pipe_info+0x243/0x300 fs/pipe.c:709
  put_pipe_info+0xd0/0xf0 fs/pipe.c:582
  pipe_release+0x1e6/0x280 fs/pipe.c:603
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888086b01200
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 24 bytes inside of
  1024-byte region [ffff888086b01200, ffff888086b01600)
The buggy address belongs to the page:
page:ffffea00021ac000 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0xffff888086b00480 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00027b5588 ffffea00028e3808 ffff8880aa400c40
raw: ffff888086b00480 ffff888086b00000 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888086b01100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888086b01180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff888086b01200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                             ^
  ffff888086b01280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888086b01300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

