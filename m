Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCFF62796E
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiKNJtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236368AbiKNJs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:48:56 -0500
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1049962E2
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:48:53 -0800 (PST)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-13b23e29e36so11896951fac.8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6irsbmfk+V0npVVee3jQo/E+g1bW94YLyBFGezbqQUk=;
        b=DrdWUilX1YDvJCjZ1WeHWLZaoAWRz3fyeQql7g9ET3ivaD3jsc8UHOUC88kr3Zwoq7
         iUpxmqnBzu+cD2GP+X5RUsC9CO1ZrFvFYDyTuB8Mwq3LOSvNqfKbXI0V0LobKIsAe+8k
         KKdjmF/VO+rYL/xBfkNBetciCPH+6RZuA2y7LN/OPpXTR5p5gEbXi+UrR3vU8V5SdE8u
         zYrrdCM6AsVweP/oHFQGg/KpRMwIHTTc6OhyeDciubm2pqjfKzHKTTzcS3KObKOlyQzw
         IW3TNBuzrzXmBq7WXdF9d2EuiF4Ie0/JiACY6mwZasqphg4fSadl3gW5GFuRzQGO012f
         GMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6irsbmfk+V0npVVee3jQo/E+g1bW94YLyBFGezbqQUk=;
        b=k4n5wD2gpA81OaImvT2MNxhhcUz1Go36/t6kyrJQVvs8RqzLpAK5FKw/wv+b2ksSXE
         KafGzVwSeEoxs4XFiwMnEvXe4qRtkkP/55b17SuAazvFk1RgG4GmK22O+mGmVcp4yF13
         EwNQAeLmaZ6FffEcpDRlOwdrkz8bbEVanD5EFc+Ep+0RnFZfmXSG8K7zpBksWTtoBSR3
         FwhP+GsOh81cUZ5QPX9pj4cZbUQ2DaVJa5TYJ3ikaV72/nfA5NEyN18yap6V8ZvBINVK
         vN5yUvymsRdKhvWvxQniEhsu7AbW78euhYy5f7O3dd2OZ7wdYX2Bftp+iCM58+/brLG/
         Vtzw==
X-Gm-Message-State: ANoB5pnOwAcBpXyodfTeD0X5dimN+q2DlVQ6j4nPs7xLVA3yMOo07OcN
        Mgx9WH9CEP7y204oO++gOz4aJP4MW9lQgG2KCgz/2Q==
X-Google-Smtp-Source: AA0mqf6tN6eywsS5DEi92Tj2fkeTCYxLnmqMBW43Ktkfa45WRiTi0FGWKJFPFB/dX83W7HDLvyWQUcdRN8T9eYN5rik=
X-Received: by 2002:a05:6870:bf0b:b0:13c:7d1c:5108 with SMTP id
 qh11-20020a056870bf0b00b0013c7d1c5108mr6312271oab.282.1668419332195; Mon, 14
 Nov 2022 01:48:52 -0800 (PST)
MIME-Version: 1.0
References: <000000000000cceef005ed659943@google.com>
In-Reply-To: <000000000000cceef005ed659943@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 14 Nov 2022 10:48:41 +0100
Message-ID: <CACT4Y+abV9E6wAwxeTD+DUG0-VknM-CPMZW_p3SXstiqwRH=tQ@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in virtual_nci_close
To:     syzbot <syzbot+8040d16d30c215f821de@syzkaller.appspotmail.com>
Cc:     bongsu.jeon@samsung.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 at 04:11, syzbot
<syzbot+8040d16d30c215f821de@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    af7a05689189 Merge tag 'mips-fixes_6.1_1' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13d30249880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9d1d2dd6d424a076
> dashboard link: https://syzkaller.appspot.com/bug?extid=8040d16d30c215f821de
> compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+8040d16d30c215f821de@syzkaller.appspotmail.com

This should be fixed by the following commit when/if it's merged. The
commit removes nci_mutex.

nfc: Allow to create multiple virtual nci devices
https://lore.kernel.org/all/20221104170422.979558-1-dvyukov@google.com/


> nci: __nci_request: wait_for_completion_interruptible_timeout failed 0
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.1.0-rc4-syzkaller-00372-gaf7a05689189 #0 Not tainted
> ------------------------------------------------------
> syz-executor.1/8551 is trying to acquire lock:
> ffff80000e6854c8 (nci_mutex){+.+.}-{3:3}, at: virtual_nci_close+0x2c/0x60 drivers/nfc/virtual_ncidev.c:44
>
> but task is already holding lock:
> ffff000030115350 (&ndev->req_lock){+.+.}-{3:3}, at: nci_close_device+0x5c/0x360 net/nfc/nci/core.c:560
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #3 (&ndev->req_lock){+.+.}-{3:3}:
>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>        __mutex_lock+0x124/0x83c kernel/locking/mutex.c:747
>        mutex_lock_nested+0x2c/0x40 kernel/locking/mutex.c:799
>        nci_request net/nfc/nci/core.c:148 [inline]
>        nci_set_local_general_bytes net/nfc/nci/core.c:774 [inline]
>        nci_start_poll+0x36c/0x624 net/nfc/nci/core.c:838
>        nfc_start_poll+0x114/0x270 net/nfc/core.c:225
>        nfc_genl_start_poll+0x154/0x3b0 net/nfc/netlink.c:828
>        genl_family_rcv_msg_doit+0x1b8/0x2a0 net/netlink/genetlink.c:756
>        genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
>        genl_rcv_msg+0x2f8/0x594 net/netlink/genetlink.c:850
>        netlink_rcv_skb+0x180/0x330 net/netlink/af_netlink.c:2540
>        genl_rcv+0x38/0x50 net/netlink/genetlink.c:861
>        netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>        netlink_unicast+0x3ec/0x684 net/netlink/af_netlink.c:1345
>        netlink_sendmsg+0x690/0xb1c net/netlink/af_netlink.c:1921
>        sock_sendmsg_nosec net/socket.c:714 [inline]
>        sock_sendmsg+0xc0/0xf4 net/socket.c:734
>        ____sys_sendmsg+0x534/0x6b0 net/socket.c:2482
>        ___sys_sendmsg+0xf0/0x174 net/socket.c:2536
>        __sys_sendmsg+0xc4/0x154 net/socket.c:2565
>        __do_sys_sendmsg net/socket.c:2574 [inline]
>        __se_sys_sendmsg net/socket.c:2572 [inline]
>        __arm64_sys_sendmsg+0x70/0xa0 net/socket.c:2572
>        __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>        invoke_syscall+0x6c/0x260 arch/arm64/kernel/syscall.c:52
>        el0_svc_common.constprop.0+0xc4/0x254 arch/arm64/kernel/syscall.c:142
>        do_el0_svc+0x50/0x14c arch/arm64/kernel/syscall.c:206
>        el0_svc+0x54/0x140 arch/arm64/kernel/entry-common.c:637
>        el0t_64_sync_handler+0xb8/0xc0 arch/arm64/kernel/entry-common.c:655
>        el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
>
> -> #2 (&genl_data->genl_data_mutex){+.+.}-{3:3}:
>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>        __mutex_lock+0x124/0x83c kernel/locking/mutex.c:747
>        mutex_lock_nested+0x2c/0x40 kernel/locking/mutex.c:799
>        nfc_urelease_event_work+0x118/0x270 net/nfc/netlink.c:1811
>        process_one_work+0x780/0x184c kernel/workqueue.c:2289
>        worker_thread+0x3cc/0xc40 kernel/workqueue.c:2436
>        kthread+0x23c/0x2a0 kernel/kthread.c:376
>        ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860
>
> -> #1 (nfc_devlist_mutex){+.+.}-{3:3}:
>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>        __mutex_lock+0x124/0x83c kernel/locking/mutex.c:747
>        mutex_lock_nested+0x2c/0x40 kernel/locking/mutex.c:799
>        nfc_register_device+0x34/0x320 net/nfc/core.c:1116
>        nci_register_device+0x604/0x8c0 net/nfc/nci/core.c:1256
>        virtual_ncidev_open+0x64/0xe0 drivers/nfc/virtual_ncidev.c:146
>        misc_open+0x294/0x394 drivers/char/misc.c:143
>        chrdev_open+0x1c0/0x54c fs/char_dev.c:414
>        do_dentry_open+0x3c4/0xf40 fs/open.c:882
>        vfs_open+0x90/0xd0 fs/open.c:1013
>        do_open fs/namei.c:3557 [inline]
>        path_openat+0x1030/0x1fe0 fs/namei.c:3713
>        do_filp_open+0x154/0x330 fs/namei.c:3740
>        do_sys_openat2+0x124/0x390 fs/open.c:1310
>        do_sys_open fs/open.c:1326 [inline]
>        __do_sys_openat fs/open.c:1342 [inline]
>        __se_sys_openat fs/open.c:1337 [inline]
>        __arm64_sys_openat+0x130/0x1c0 fs/open.c:1337
>        __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>        invoke_syscall+0x6c/0x260 arch/arm64/kernel/syscall.c:52
>        el0_svc_common.constprop.0+0xc4/0x254 arch/arm64/kernel/syscall.c:142
>        do_el0_svc+0x50/0x14c arch/arm64/kernel/syscall.c:206
>        el0_svc+0x54/0x140 arch/arm64/kernel/entry-common.c:637
>        el0t_64_sync_handler+0xb8/0xc0 arch/arm64/kernel/entry-common.c:655
>        el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
>
> -> #0 (nci_mutex){+.+.}-{3:3}:
>        check_prev_add kernel/locking/lockdep.c:3097 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3216 [inline]
>        validate_chain kernel/locking/lockdep.c:3831 [inline]
>        __lock_acquire+0x2788/0x56d0 kernel/locking/lockdep.c:5055
>        lock_acquire kernel/locking/lockdep.c:5668 [inline]
>        lock_acquire+0x58c/0x9a0 kernel/locking/lockdep.c:5633
>        __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>        __mutex_lock+0x124/0x83c kernel/locking/mutex.c:747
>        mutex_lock_nested+0x2c/0x40 kernel/locking/mutex.c:799
>        virtual_nci_close+0x2c/0x60 drivers/nfc/virtual_ncidev.c:44
>        nci_close_device+0x200/0x360 net/nfc/nci/core.c:592
>        nci_unregister_device+0x40/0x280 net/nfc/nci/core.c:1291
>        virtual_ncidev_close+0x70/0x90 drivers/nfc/virtual_ncidev.c:166
>        __fput+0x1ac/0x860 fs/file_table.c:320
>        ____fput+0x10/0x1c fs/file_table.c:348
>        task_work_run+0x12c/0x220 kernel/task_work.c:179
>        resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>        do_notify_resume+0x920/0x2840 arch/arm64/kernel/signal.c:1127
>        prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
>        exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
>        el0_svc+0x11c/0x140 arch/arm64/kernel/entry-common.c:638
>        el0t_64_sync_handler+0xb8/0xc0 arch/arm64/kernel/entry-common.c:655
>        el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
>
> other info that might help us debug this:
>
> Chain exists of:
>   nci_mutex --> &genl_data->genl_data_mutex --> &ndev->req_lock
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ndev->req_lock);
>                                lock(&genl_data->genl_data_mutex);
>                                lock(&ndev->req_lock);
>   lock(nci_mutex);
>
>  *** DEADLOCK ***
>
> 1 lock held by syz-executor.1/8551:
>  #0: ffff000030115350 (&ndev->req_lock){+.+.}-{3:3}, at: nci_close_device+0x5c/0x360 net/nfc/nci/core.c:560
>
> stack backtrace:
> CPU: 1 PID: 8551 Comm: syz-executor.1 Not tainted 6.1.0-rc4-syzkaller-00372-gaf7a05689189 #0
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  dump_backtrace+0xe0/0x140 arch/arm64/kernel/stacktrace.c:156
>  show_stack+0x18/0x40 arch/arm64/kernel/stacktrace.c:163
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x9c/0xd8 lib/dump_stack.c:106
>  dump_stack+0x1c/0x38 lib/dump_stack.c:113
>  print_circular_bug+0x2d4/0x2ec kernel/locking/lockdep.c:2055
>  check_noncircular+0x26c/0x2e0 kernel/locking/lockdep.c:2177
>  check_prev_add kernel/locking/lockdep.c:3097 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3216 [inline]
>  validate_chain kernel/locking/lockdep.c:3831 [inline]
>  __lock_acquire+0x2788/0x56d0 kernel/locking/lockdep.c:5055
>  lock_acquire kernel/locking/lockdep.c:5668 [inline]
>  lock_acquire+0x58c/0x9a0 kernel/locking/lockdep.c:5633
>  __mutex_lock_common kernel/locking/mutex.c:603 [inline]
>  __mutex_lock+0x124/0x83c kernel/locking/mutex.c:747
>  mutex_lock_nested+0x2c/0x40 kernel/locking/mutex.c:799
>  virtual_nci_close+0x2c/0x60 drivers/nfc/virtual_ncidev.c:44
>  nci_close_device+0x200/0x360 net/nfc/nci/core.c:592
>  nci_unregister_device+0x40/0x280 net/nfc/nci/core.c:1291
>  virtual_ncidev_close+0x70/0x90 drivers/nfc/virtual_ncidev.c:166
>  __fput+0x1ac/0x860 fs/file_table.c:320
>  ____fput+0x10/0x1c fs/file_table.c:348
>  task_work_run+0x12c/0x220 kernel/task_work.c:179
>  resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
>  do_notify_resume+0x920/0x2840 arch/arm64/kernel/signal.c:1127
>  prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
>  exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
>  el0_svc+0x11c/0x140 arch/arm64/kernel/entry-common.c:638
>  el0t_64_sync_handler+0xb8/0xc0 arch/arm64/kernel/entry-common.c:655
>  el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000cceef005ed659943%40google.com.
