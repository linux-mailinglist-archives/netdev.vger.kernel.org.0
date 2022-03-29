Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0393D4EB58F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 00:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbiC2WHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 18:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbiC2WHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 18:07:41 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4655AB91A7;
        Tue, 29 Mar 2022 15:05:56 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id BED6AC009; Wed, 30 Mar 2022 00:05:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648591551; bh=JcJk3NcTD//GtEmRNH6tsnNKdy80/1cNJm+0T/WWJ8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pOV3Gwq+eOiks8TWwwlwywD+gD20R4AbvcuzbhwJidUGyqanwA1Szjbm8NgvytQfu
         ej0/TTJw1e9oRoNxycVRY6SIXcir7efBWBABJbkTeMuIXSr6va9QnHgo3ZJwjoNcYo
         qWtvmMZbunPnB9X0n6wXrDBPxR6O9eyC1rOsxBPj6Krq5ISNXPHk/0cZzD7g/Es9ZH
         0gjgzSFrvMGZvxB4LsZU6Nc+MSwQhskUBwd+86793V5XWY5lJnGDM4jQyPs73ajjAm
         N0v/K2uJ+dKsHkp0MVGrCRwr8wamUd9Ix1/s4o8EYublcd2vRvSAzviMBgYY5fLBtj
         moS0cQ9NAFrDQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 35B23C009;
        Wed, 30 Mar 2022 00:05:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648591550; bh=JcJk3NcTD//GtEmRNH6tsnNKdy80/1cNJm+0T/WWJ8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FGPoWDZymW6j4tZG8qP9yEZVT7iCrkF6UEcCEVorRqoJI6bDk/IHQ0/GgVYlslC0z
         vq+IjwE3X1k1tB/IP2MewdtHgipfLOy8XTlxid8S8c/1uFHcA60qcevYGYR494WQ2r
         f43qACTF3gtUi+6SfOaImRF5ROBP22Zq0kzwUJH/rTmgvDSUb6hTMUhXXe4xJecj2Y
         Vp4WkzvzeYzNttGTlbegzcHDA2eU+TRMhJNdzWwA8o2zoveUKRPaGKRdmFiB6WObfJ
         qlKs9pDmrT7HCv8y1ojlgFCS6GUjvFALE2FPclFYL+M0mN1UaZS2aSWdpo86+Dzoub
         NZStCyIOfvpWQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 98330da0;
        Tue, 29 Mar 2022 22:05:43 +0000 (UTC)
Date:   Wed, 30 Mar 2022 07:05:28 +0900
From:   asmadeus@codewreck.org
To:     syzbot <syzbot+bde0f89deacca7c765b8@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, ericvh@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux_oss@crudebyte.com,
        lucho@ionkov.net, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] possible deadlock in p9_write_work
Message-ID: <YkOCqJ4WDObmaAcn@codewreck.org>
References: <0000000000009523b605db620972@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0000000000009523b605db620972@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot wrote on Tue, Mar 29, 2022 at 02:23:17PM -0700:
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.17.0-next-20220328-syzkaller #0 Not tainted
> ------------------------------------------------------
> kworker/1:1/26 is trying to acquire lock:
> ffff88807eece460 (sb_writers#3){.+.+}-{0:0}, at: p9_fd_write net/9p/trans_fd.c:428 [inline]
> ffff88807eece460 (sb_writers#3){.+.+}-{0:0}, at: p9_write_work+0x25e/0xca0 net/9p/trans_fd.c:479
> 
> but task is already holding lock:
> ffffc90000a1fda8 ((work_completion)(&m->wq)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #3 ((work_completion)(&m->wq)){+.+.}-{0:0}:
>        process_one_work+0x905/0x1610 kernel/workqueue.c:2265
>        worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>        kthread+0x2e9/0x3a0 kernel/kthread.c:376
>        ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
> 
> -> #2 ((wq_completion)events){+.+.}-{0:0}:
>        flush_workqueue+0x164/0x1440 kernel/workqueue.c:2831
>        flush_scheduled_work include/linux/workqueue.h:583 [inline]
>        ext4_put_super+0x99/0x1150 fs/ext4/super.c:1202
>        generic_shutdown_super+0x14c/0x400 fs/super.c:462
>        kill_block_super+0x97/0xf0 fs/super.c:1394
>        deactivate_locked_super+0x94/0x160 fs/super.c:332
>        deactivate_super+0xad/0xd0 fs/super.c:363
>        cleanup_mnt+0x3a2/0x540 fs/namespace.c:1186
>        task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>        resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>        exit_to_user_mode_loop kernel/entry/common.c:183 [inline]
>        exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:215
>        __syscall_exit_to_user_mode_work kernel/entry/common.c:297 [inline]
>        syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:308
>        do_syscall_64+0x42/0x80 arch/x86/entry/common.c:86
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> -> #1 (&type->s_umount_key#32){++++}-{3:3}:
>        down_read+0x98/0x440 kernel/locking/rwsem.c:1461
>        iterate_supers+0xdb/0x290 fs/super.c:692
>        drop_caches_sysctl_handler+0xdb/0x110 fs/drop_caches.c:62
>        proc_sys_call_handler+0x4a1/0x6e0 fs/proc/proc_sysctl.c:604
>        call_write_iter include/linux/fs.h:2080 [inline]
>        do_iter_readv_writev+0x3d1/0x640 fs/read_write.c:726
>        do_iter_write+0x182/0x700 fs/read_write.c:852
>        vfs_iter_write+0x70/0xa0 fs/read_write.c:893
>        iter_file_splice_write+0x723/0xc70 fs/splice.c:689
>        do_splice_from fs/splice.c:767 [inline]
>        direct_splice_actor+0x110/0x180 fs/splice.c:936
>        splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
>        do_splice_direct+0x1a7/0x270 fs/splice.c:979
>        do_sendfile+0xae0/0x1240 fs/read_write.c:1246
>        __do_sys_sendfile64 fs/read_write.c:1305 [inline]
>        __se_sys_sendfile64 fs/read_write.c:1297 [inline]
>        __x64_sys_sendfile64+0x149/0x210 fs/read_write.c:1297
>        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>        do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
>        entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> -> #0 (sb_writers#3){.+.+}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3096 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3219 [inline]
>        validate_chain kernel/locking/lockdep.c:3834 [inline]
>        __lock_acquire+0x2ac6/0x56c0 kernel/locking/lockdep.c:5060
>        lock_acquire kernel/locking/lockdep.c:5672 [inline]
>        lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5637
>        percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
>        __sb_start_write include/linux/fs.h:1728 [inline]
>        sb_start_write include/linux/fs.h:1798 [inline]
>        file_start_write include/linux/fs.h:2815 [inline]
>        kernel_write fs/read_write.c:564 [inline]
>        kernel_write+0x2ac/0x540 fs/read_write.c:555
>        p9_fd_write net/9p/trans_fd.c:428 [inline]
>        p9_write_work+0x25e/0xca0 net/9p/trans_fd.c:479
>        process_one_work+0x996/0x1610 kernel/workqueue.c:2289
>        worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>        kthread+0x2e9/0x3a0 kernel/kthread.c:376
>        ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298


So p9_write_work cannot write because there's.. a backing ext4 umount (I
assume it's been mounted with trans fd with an ext4 file) and a
drop_caches stuck in parallel, and we just got caught in the crossfire ?

I'm not sure why it got stuck there but that doesn't look like anything
we can do about it, using trans fd with filesystem backed files isn't a
usage we care about in the first place, maybe there's a way to refuse
these and only keep sockets but I don't really see the point of
artificially limiting the interface (unless using a 9p mount with a file
could have security implications I don't see)

wontfix/dontcare for me,
-- 
Dominique
