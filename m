Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FC63CC537
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 20:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhGQSQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 14:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhGQSQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 14:16:19 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC6DC061762;
        Sat, 17 Jul 2021 11:13:21 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id w13so7722553wmc.3;
        Sat, 17 Jul 2021 11:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SFW5+8IVRaN6QKVYyFybd4wsXXH9Z/XHllM3YBvGkpk=;
        b=PAznuyr5G7O+qwWyy66A1IXqkYSee36kZqqMWHMCcKo59G+4SGE6Qsp5sXNK7qLTgb
         HGnrDjIBSPeOd75JC+bqQFO5ZtfNp1oVX6hoqcmUh7RVBolx7/sEWJgpvtbBwSkZGPhn
         S46aonJYnvDmHohujqg/LyIqRE5k93T+PfXTqR459Jj0UlYgJdshGKRqzanI4pZ+ibJp
         zWAZcQUgLP1AE1iMuGLfKzKvuYiygxKdotTPvteEa5VkstHIjTM2a8o12N1MQkhpPcIP
         yfnRBz1IW1+3JY+qdtL9YjGhYnlAPqikix7dV/ZfRV5Eix8RXz247EtpXsQrg0h9gyYk
         YM1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SFW5+8IVRaN6QKVYyFybd4wsXXH9Z/XHllM3YBvGkpk=;
        b=tD8qxFVo+2daC1/qN+hDopHI3KyanuCXRXBLRrCB6qvoHIX050Y5Qc6Lgf9O73Etlb
         W27Z+DrzOCfGAARQ0XcbrktzEK04+8dyzIFh+ttGtEuYSWBQVxOAwm3YqvxTHg5N1JIr
         8cxC1EFRFDLetWsWsv/f+ozUyAsVd6C8hKoDNsjLK4Qwcz3M+MhJsV0eTp8BqnX6dqW9
         AJk1fQBECR4v9rfISxi1DMBqoFV3b4nGDEEsNBMzkOwT3r1QKiqUZ4K2GLAnMCs81RgJ
         9ExsFgY938vtmCOl+T8m+0x+mJTnc5Z7+oFgo8o10QEySbTR/BmSEbsHkhdALIApL5EJ
         KHhA==
X-Gm-Message-State: AOAM5334I9OmspSwYg6BIfid7x1sNzGHrXeJmQm2K//SoAALCnxgIvTA
        pJNwh9xcYkj1L+2X9eCtEqCbOVmZ0z/yqVfv/vY=
X-Google-Smtp-Source: ABdhPJwiITOOxw/27NA8CwIZrPzDuY70VcCdjUQ+9+H/wBTi+nDuhq3o/jZJufyivHQVC9evGFevFTY3V+Et4Lgr670=
X-Received: by 2002:a1c:7402:: with SMTP id p2mr23192765wmc.88.1626545600282;
 Sat, 17 Jul 2021 11:13:20 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a0982305c6e5c9f5@google.com> <CADvbK_cRwJNgCpYtsCR6Ljymbqh7eQfGTWBAp7SZqzBvdViDbg@mail.gmail.com>
 <20210717045654.1082-1-hdanton@sina.com>
In-Reply-To: <20210717045654.1082-1-hdanton@sina.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 17 Jul 2021 14:13:10 -0400
Message-ID: <CADvbK_cwfzgM-bFW3fNX2Ckh4UWGeEpSvM4NQ-=08=BWHfTNdg@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in sctp_auth_shkey_hold
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+b774577370208727d12b@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        sctp <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 12:57 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Fri, 16 Jul 2021 16:01:01 -0400 Xin Long wrote:
> >On Mon, Jul 12, 2021 at 12:46 AM syzbot wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    5e437416 Merge branch 'dsa-mv88e6xxx-topaz-fixes'
> >> git tree:       net-next
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=14503bac300000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=4cb84363d46e9fc3
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=b774577370208727d12b
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+b774577370208727d12b@syzkaller.appspotmail.com
> >>
> >> ==================================================================
> >> BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
> >> BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:111 [inline]
> >> BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
> >> BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
> >> BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
> >> BUG: KASAN: use-after-free in sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
> >> Write of size 4 at addr ffff88802053ad58 by task syz-executor.1/31590
> >>
> >> CPU: 0 PID: 31590 Comm: syz-executor.1 Not tainted 5.13.0-syzkaller #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> >> Call Trace:
> >>  __dump_stack lib/dump_stack.c:79 [inline]
> >>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
> >>  print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
> >>  __kasan_report mm/kasan/report.c:419 [inline]
> >>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
> >>  check_region_inline mm/kasan/generic.c:183 [inline]
> >>  kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
> >>  instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
> >>  atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:111 [inline]
> >>  __refcount_add include/linux/refcount.h:193 [inline]
> >>  __refcount_inc include/linux/refcount.h:250 [inline]
> >>  refcount_inc include/linux/refcount.h:267 [inline]
> >>  sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
> >>  sctp_set_owner_w net/sctp/socket.c:131 [inline]
>
> 1)      datamsg = sctp_datamsg_from_user(asoc, sinfo, &msg->msg_iter);
>
> Chunks are built with sock lock held(lock_sock(sk);).
>
> >>  sctp_sendmsg_to_asoc+0x152e/0x2180 net/sctp/socket.c:1865
> >>  sctp_sendmsg+0x103b/0x1d30 net/sctp/socket.c:2027
> >>  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
> >>  sock_sendmsg_nosec net/socket.c:702 [inline]
> >>  sock_sendmsg+0xcf/0x120 net/socket.c:722
> >>  ____sys_sendmsg+0x331/0x810 net/socket.c:2385
> >>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2439
> >>  __sys_sendmmsg+0x195/0x470 net/socket.c:2525
> >>  __do_sys_sendmmsg net/socket.c:2554 [inline]
> >>  __se_sys_sendmmsg net/socket.c:2551 [inline]
> >>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2551
> >>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >> RIP: 0033:0x4665d9
> >> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> >> RSP: 002b:00007f679ad9b188 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> >> RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
> >> RDX: 0000000000000002 RSI: 0000000020002340 RDI: 0000000000000003
> >> RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
> >> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
> >> R13: 00007ffc95431f0f R14: 00007f679ad9b300 R15: 0000000000022000
> >>
> >> Allocated by task 31590:
> >>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
> >>  kasan_set_track mm/kasan/common.c:46 [inline]
> >>  set_alloc_info mm/kasan/common.c:434 [inline]
> >>  ____kasan_kmalloc mm/kasan/common.c:513 [inline]
> >>  ____kasan_kmalloc mm/kasan/common.c:472 [inline]
> >>  __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
> >>  kmalloc include/linux/slab.h:591 [inline]
> >>  kzalloc include/linux/slab.h:721 [inline]
> >>  sctp_auth_shkey_create+0x85/0x1f0 net/sctp/auth.c:84
> >>  sctp_auth_asoc_copy_shkeys+0x1e8/0x350 net/sctp/auth.c:363
> >>  sctp_association_init net/sctp/associola.c:257 [inline]
> >>  sctp_association_new+0x1829/0x2250 net/sctp/associola.c:298
> >>  sctp_connect_new_asoc+0x1ac/0x770 net/sctp/socket.c:1088
> >>  __sctp_connect+0x3d0/0xc30 net/sctp/socket.c:1194
> >>  sctp_connect net/sctp/socket.c:4804 [inline]
> >>  sctp_inet_connect+0x15e/0x200 net/sctp/socket.c:4819
> >>  __sys_connect_file+0x155/0x1a0 net/socket.c:1872
> >>  __sys_connect+0x161/0x190 net/socket.c:1889
> >>  __do_sys_connect net/socket.c:1899 [inline]
> >>  __se_sys_connect net/socket.c:1896 [inline]
> >>  __x64_sys_connect+0x6f/0xb0 net/socket.c:1896
> >>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>
> >> Freed by task 31590:
> >>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
> >>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
> >>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
> >>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
> >>  ____kasan_slab_free mm/kasan/common.c:328 [inline]
> >>  __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
> >>  kasan_slab_free include/linux/kasan.h:229 [inline]
> >>  slab_free_hook mm/slub.c:1639 [inline]
> >>  slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1664
> >>  slab_free mm/slub.c:3224 [inline]
> >>  kfree+0xeb/0x670 mm/slub.c:4268
> >>  sctp_auth_shkey_destroy net/sctp/auth.c:101 [inline]
> >>  sctp_auth_shkey_release+0x100/0x160 net/sctp/auth.c:107
> >>  sctp_auth_set_key+0x508/0x6d0 net/sctp/auth.c:862
> >>
> >It seems caused by not updating asoc->shkey when the old key is being deleted:
>
> Nope, see 1) and 2).
It's not about lock protection.

asoc->shkey became invalid after 'shkey' (== asoc->shkey)  is released
in sctp_auth_set_key() and all chunks freed its shkey.
the crash is triggered by this invalid asoc->shkey used.

We should fix it by updating asoc->shkey when it's being released,
more accurately:

@@ -860,6 +860,8 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
        if (replace) {
                list_del_init(&shkey->key_list);
                sctp_auth_shkey_release(shkey);
+               if (asoc && asoc->active_key_id == auth_key->sca_keynumber)
+                       sctp_auth_asoc_init_active_key(asoc, GFP_KERNEL);
        }

>
> >
> >diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> >index 6f8319b..d095247 100644
> >--- a/net/sctp/auth.c
> >+++ b/net/sctp/auth.c
> >@@ -858,6 +858,8 @@ int sctp_auth_set_key(struct sctp_endpoint *ep,
> >        cur_key->key = key;
> >
> >        if (replace) {
> >+               if (asoc && asoc->shkey == shkey)
> >+                       asoc->shkey = cur_key;
> >                list_del_init(&shkey->key_list);
> >                sctp_auth_shkey_release(shkey);
> >        }
> >
> >>  sctp_setsockopt_auth_key net/sctp/socket.c:3643 [inline]
>
> 2)  lock_sock(sk);
>
> >>  sctp_setsockopt+0x4919/0xa5e0 net/sctp/socket.c:4682
> >>  __sys_setsockopt+0x2db/0x610 net/socket.c:2152
> >>  __do_sys_setsockopt net/socket.c:2163 [inline]
> >>  __se_sys_setsockopt net/socket.c:2160 [inline]
> >>  __x64_sys_setsockopt+0xba/0x150 net/socket.c:2160
> >>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >>  entry_SYSCALL_64_after_hwframe+0x44/0xae
