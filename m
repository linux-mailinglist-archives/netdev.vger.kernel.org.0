Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E582D2038A
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 12:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfEPKfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 06:35:08 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:52082 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfEPKfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 06:35:07 -0400
Received: by mail-it1-f199.google.com with SMTP id f196so2815091itf.1
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 03:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=82cfYC0iXh2m4A7LP0hZLMJGBTbjemtRXio5Ti8f5Sg=;
        b=mg19dTo3Ij+O/aA5Z+c5HEQg7Ku8ldrkqq6Qx50+RmwimIEZ8TB4EF3Of/eVUPmrS0
         qLSeF06kl6DW/OntnO6q0rRxqIJF1jYfYioE2utoA4QXpf+e2FGMSLyY8/4p499LEd62
         1gV/6m5PTYQz6GdQuNK5yyHsmPOO+TbhFE9Ok3O2MoRTd9GQHx9/8rSOKC+xttgppzpf
         ivM0YssJHvqOf9YSCNtWyoBqBwvHux5VIQemmjT7SnlP+9eNI27JeJiBcS1TfLukXg+k
         WFvEG4MFuT+kio4remf1Nhmph1NJjI9KoszEt9I/NjXmlyBJaFwyFt8NrfiSZwrc44A4
         GQ5g==
X-Gm-Message-State: APjAAAXwOTHL7BJ3ypvST0VQzhgOqIXsXWmGVm+MSdsGn06zp13UbWOu
        w/6ipfr1f9c+h7WtpfcJSPhQtED1BMcci+AYmJkAktfv2TA3
X-Google-Smtp-Source: APXvYqxTpNYRSsHUD/mVbo7tWyoDBEUUP0ZGnG0WZkECoB628osM4ISNlLtQQSDRsUcEdU0LNGwEoec9pSZcOWzkUKLpgjwmQiPX
MIME-Version: 1.0
X-Received: by 2002:a24:d07:: with SMTP id 7mr11923395itx.172.1558002906519;
 Thu, 16 May 2019 03:35:06 -0700 (PDT)
Date:   Thu, 16 May 2019 03:35:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cd5fdf0588fed11c@google.com>
Subject: KASAN: use-after-free Write in __xfrm_policy_unlink (2)
From:   syzbot <syzbot+0025447b4cb6f208558f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3b0f31f2 genetlink: make policy common to family
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12a319df200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f05902bca21d8935
dashboard link: https://syzkaller.appspot.com/bug?extid=0025447b4cb6f208558f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0025447b4cb6f208558f@syzkaller.appspotmail.com

device hsr_slave_1 left promiscuous mode
device hsr_slave_0 left promiscuous mode
team0 (unregistering): Port device team_slave_1 removed
team0 (unregistering): Port device team_slave_0 removed
bond0 (unregistering): Releasing backup interface bond_slave_0
device bond_slave_0 left promiscuous mode
bond0 (unregistering): Released all slaves
==================================================================
BUG: KASAN: use-after-free in __write_once_size  
include/linux/compiler.h:220 [inline]
BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:713 [inline]
BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455  
[inline]
BUG: KASAN: use-after-free in __xfrm_policy_unlink+0x4b1/0x5c0  
net/xfrm/xfrm_policy.c:2212
Write of size 8 at addr ffff8880a55a9e80 by task kworker/u4:6/7431

CPU: 1 PID: 7431 Comm: kworker/u4:6 Not tainted 5.0.0+ #106
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
  kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  __asan_report_store8_noabort+0x17/0x20 mm/kasan/generic_report.c:137
  __write_once_size include/linux/compiler.h:220 [inline]
  __hlist_del include/linux/list.h:713 [inline]
  hlist_del_rcu include/linux/rculist.h:455 [inline]
  __xfrm_policy_unlink+0x4b1/0x5c0 net/xfrm/xfrm_policy.c:2212
  xfrm_policy_flush+0x331/0x460 net/xfrm/xfrm_policy.c:1789
  xfrm_policy_fini+0x49/0x3a0 net/xfrm/xfrm_policy.c:3871
  xfrm_net_exit+0x1d/0x70 net/xfrm/xfrm_policy.c:3933
  ops_exit_list.isra.0+0xb0/0x160 net/core/net_namespace.c:153
  cleanup_net+0x3fb/0x960 net/core/net_namespace.c:551
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x357/0x430 kernel/kthread.c:253
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Allocated by task 7242:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_kmalloc mm/kasan/common.c:497 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:470
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:511
  __do_kmalloc mm/slab.c:3726 [inline]
  __kmalloc+0x15c/0x740 mm/slab.c:3735
  kmalloc include/linux/slab.h:550 [inline]
  kzalloc include/linux/slab.h:740 [inline]
  ext4_htree_store_dirent+0x8a/0x650 fs/ext4/dir.c:450
  htree_dirblock_to_tree+0x4fe/0x910 fs/ext4/namei.c:1021
  ext4_htree_fill_tree+0x252/0xa50 fs/ext4/namei.c:1098
  ext4_dx_readdir fs/ext4/dir.c:574 [inline]
  ext4_readdir+0x1999/0x3490 fs/ext4/dir.c:121
  iterate_dir+0x489/0x5f0 fs/readdir.c:51
  __do_sys_getdents fs/readdir.c:231 [inline]
  __se_sys_getdents fs/readdir.c:212 [inline]
  __x64_sys_getdents+0x1dd/0x370 fs/readdir.c:212
  do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 7242:
  save_stack+0x45/0xd0 mm/kasan/common.c:75
  set_track mm/kasan/common.c:87 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:459
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:467
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xcf/0x230 mm/slab.c:3821
  free_rb_tree_fname+0x87/0xe0 fs/ext4/dir.c:402
  ext4_htree_free_dir_info fs/ext4/dir.c:424 [inline]
  ext4_release_dir+0x46/0x70 fs/ext4/dir.c:622
  __fput+0x2e5/0x8d0 fs/file_table.c:278
  ____fput+0x16/0x20 fs/file_table.c:309
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a55a9e80
  which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
  64-byte region [ffff8880a55a9e80, ffff8880a55a9ec0)
The buggy address belongs to the page:
page:ffffea0002956a40 count:1 mapcount:0 mapping:ffff88812c3f0340 index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002a0d748 ffffea00018af1c8 ffff88812c3f0340
raw: 0000000000000000 ffff8880a55a9000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a55a9d80: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
  ffff8880a55a9e00: 00 00 00 00 04 fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a55a9e80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                    ^
  ffff8880a55a9f00: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a55a9f80: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
