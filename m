Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F87BA4DC4
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 05:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbfIBDcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 23:32:03 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42715 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbfIBDcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 23:32:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id t12so14249440qtp.9
        for <netdev@vger.kernel.org>; Sun, 01 Sep 2019 20:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D3eEAJRNuM73t6UGy+rqWo2ZMxDf5SIzk32fNYrqO0s=;
        b=lR084Au0lZ6fKz7VAekiDZXtbLlXKOGYzVS3iBew7iqtjfbT3L+uNiQ/HnrzDH0vTJ
         +3VrqlBfyg3SVEMkVcm8KSRSehOY7QR6EK45wJiTGNhfxJz3M42PqqbbFDFErD6VNb29
         aHZRkcdxMLzAnP6YVdYio8mPw+W/cnSITsbOmw4s7b0K2e4L52AGGVng31fy3b0x0b9K
         KHEX9G27nhVb26JtA+G9anOHm5QH7JO2gWfT4uJHA0Mtn+ljZbu6Uis0Gf5N2hRhPwbr
         TR7jt0BORftYSUKyqDLMp0CwLUFZ7I+fk1xq62jEO5HOSJ70+O0KwZsC73LBriEJ8KwB
         EY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D3eEAJRNuM73t6UGy+rqWo2ZMxDf5SIzk32fNYrqO0s=;
        b=LoJDCD+GDBrgKcpEMCCXyvnECtr1Q/PyTSO2h/LNEsyhRKqJbZQqK9opp+pQ1Gg5h4
         Kuwb2+xWr1mzlE+Zga2/MLlafpWv7p7skzG/+nWhM58k2iIb+eXcb2br3pYZOWdhUlqk
         8OYxYBZV5NNpX8HZ25C7RtjKwEyfiv3Ocyy02M0patdBHzvwaMpMKWX0O6I+Bd9GMtrZ
         o8JzSQstUykxpHrTzTZNz5/TT+lMfC9tBHGqaGs3CCJWvo8kAQYBP5V4Cx9Ib15ku2WD
         bGf3xgUgC40Wad6uWiTtC4upYDeiFv+s0oaNtEdEb8PNXufj1MKcgKRmkI8ebDOKFiYO
         LDlQ==
X-Gm-Message-State: APjAAAVhUpjWECjk1Ta5VPvQwiPip1lbStrBnaxifmtMQk1sYgs7O00g
        3BXOOEcmtcvyO1ngHeWFOYJ991uqXkfN+wNhqATyMQ==
X-Google-Smtp-Source: APXvYqwYFvrXy5NdZnsFss4k+WmRnTUEwkHF1lUSbMzXGsini36kkaO/WVs4hR0aHTT7X/h3pLmNDetR8DfU40qdTrk=
X-Received: by 2002:ac8:45d6:: with SMTP id e22mr21953894qto.380.1567395119566;
 Sun, 01 Sep 2019 20:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000cd5fdf0588fed11c@google.com>
In-Reply-To: <000000000000cd5fdf0588fed11c@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 1 Sep 2019 20:31:47 -0700
Message-ID: <CACT4Y+ZEgcU=R6jeW8dtNO+oVJczQgZuFh6dbRSnLsUyzS_GSA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Write in __xfrm_policy_unlink (2)
To:     syzbot <syzbot+0025447b4cb6f208558f@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 3:35 AM syzbot
<syzbot+0025447b4cb6f208558f@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    3b0f31f2 genetlink: make policy common to family
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12a319df200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f05902bca21d8935
> dashboard link: https://syzkaller.appspot.com/bug?extid=0025447b4cb6f208558f
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0025447b4cb6f208558f@syzkaller.appspotmail.com

This looks like what has been fixed by:

#syz fix:
xfrm: policy: Fix out-of-bound array accesses in __xfrm_policy_unlink


> ==================================================================
> BUG: KASAN: use-after-free in __write_once_size
> include/linux/compiler.h:220 [inline]
> BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:713 [inline]
> BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455
> [inline]
> BUG: KASAN: use-after-free in __xfrm_policy_unlink+0x4b1/0x5c0
> net/xfrm/xfrm_policy.c:2212
> Write of size 8 at addr ffff8880a55a9e80 by task kworker/u4:6/7431
>
> CPU: 1 PID: 7431 Comm: kworker/u4:6 Not tainted 5.0.0+ #106
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: netns cleanup_net
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>   print_address_description.cold+0x7c/0x20d mm/kasan/report.c:187
>   kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
>   __asan_report_store8_noabort+0x17/0x20 mm/kasan/generic_report.c:137
>   __write_once_size include/linux/compiler.h:220 [inline]
>   __hlist_del include/linux/list.h:713 [inline]
>   hlist_del_rcu include/linux/rculist.h:455 [inline]
>   __xfrm_policy_unlink+0x4b1/0x5c0 net/xfrm/xfrm_policy.c:2212
>   xfrm_policy_flush+0x331/0x460 net/xfrm/xfrm_policy.c:1789
>   xfrm_policy_fini+0x49/0x3a0 net/xfrm/xfrm_policy.c:3871
>   xfrm_net_exit+0x1d/0x70 net/xfrm/xfrm_policy.c:3933
>   ops_exit_list.isra.0+0xb0/0x160 net/core/net_namespace.c:153
>   cleanup_net+0x3fb/0x960 net/core/net_namespace.c:551
>   process_one_work+0x98e/0x1790 kernel/workqueue.c:2269
>   worker_thread+0x98/0xe40 kernel/workqueue.c:2415
>   kthread+0x357/0x430 kernel/kthread.c:253
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
>
> Allocated by task 7242:
>   save_stack+0x45/0xd0 mm/kasan/common.c:75
>   set_track mm/kasan/common.c:87 [inline]
>   __kasan_kmalloc mm/kasan/common.c:497 [inline]
>   __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:470
>   kasan_kmalloc+0x9/0x10 mm/kasan/common.c:511
>   __do_kmalloc mm/slab.c:3726 [inline]
>   __kmalloc+0x15c/0x740 mm/slab.c:3735
>   kmalloc include/linux/slab.h:550 [inline]
>   kzalloc include/linux/slab.h:740 [inline]
>   ext4_htree_store_dirent+0x8a/0x650 fs/ext4/dir.c:450
>   htree_dirblock_to_tree+0x4fe/0x910 fs/ext4/namei.c:1021
>   ext4_htree_fill_tree+0x252/0xa50 fs/ext4/namei.c:1098
>   ext4_dx_readdir fs/ext4/dir.c:574 [inline]
>   ext4_readdir+0x1999/0x3490 fs/ext4/dir.c:121
>   iterate_dir+0x489/0x5f0 fs/readdir.c:51
>   __do_sys_getdents fs/readdir.c:231 [inline]
>   __se_sys_getdents fs/readdir.c:212 [inline]
>   __x64_sys_getdents+0x1dd/0x370 fs/readdir.c:212
>   do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Freed by task 7242:
>   save_stack+0x45/0xd0 mm/kasan/common.c:75
>   set_track mm/kasan/common.c:87 [inline]
>   __kasan_slab_free+0x102/0x150 mm/kasan/common.c:459
>   kasan_slab_free+0xe/0x10 mm/kasan/common.c:467
>   __cache_free mm/slab.c:3498 [inline]
>   kfree+0xcf/0x230 mm/slab.c:3821
>   free_rb_tree_fname+0x87/0xe0 fs/ext4/dir.c:402
>   ext4_htree_free_dir_info fs/ext4/dir.c:424 [inline]
>   ext4_release_dir+0x46/0x70 fs/ext4/dir.c:622
>   __fput+0x2e5/0x8d0 fs/file_table.c:278
>   ____fput+0x16/0x20 fs/file_table.c:309
>   task_work_run+0x14a/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>   exit_to_usermode_loop+0x273/0x2c0 arch/x86/entry/common.c:166
>   prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
>   do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8880a55a9e80
>   which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 0 bytes inside of
>   64-byte region [ffff8880a55a9e80, ffff8880a55a9ec0)
> The buggy address belongs to the page:
> page:ffffea0002956a40 count:1 mapcount:0 mapping:ffff88812c3f0340 index:0x0
> flags: 0x1fffc0000000200(slab)
> raw: 01fffc0000000200 ffffea0002a0d748 ffffea00018af1c8 ffff88812c3f0340
> raw: 0000000000000000 ffff8880a55a9000 0000000100000020 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8880a55a9d80: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
>   ffff8880a55a9e00: 00 00 00 00 04 fc fc fc fc fc fc fc fc fc fc fc
> > ffff8880a55a9e80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>                     ^
>   ffff8880a55a9f00: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>   ffff8880a55a9f80: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000cd5fdf0588fed11c%40google.com.
> For more options, visit https://groups.google.com/d/optout.
