Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFC56E3EFD
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 07:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjDQFfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 01:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDQFfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 01:35:37 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6383AAF
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 22:35:16 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4ec816c9d03so1168454e87.2
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 22:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681709712; x=1684301712;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zyyAvuW/pOY8jPhiXRm2ACIKthV+mmOLRNiYf8O659s=;
        b=BvMcypFFc/03aEor9OrCqiJSdASWSsAckH7U4ze+vUSXdxzFbxXCl7ZURDS+RWv4/U
         PYKlj+YfKjcByVj9P5XzkGwvTko7iYJGW7u8N/B92Yi9vKwNqOMP96h+bNb+xwPTK/E3
         EDmPx/ib9LVKi2qX04V8sQz6w/DY2Fpa4fYmfu39LnirMRxEXGNIS9LG6kNp67PmcbuF
         A+kj/4OU4JReYrHfpWmVYxGbUHfQ59M0v+gfkXV/oyzSZ8fBf/kU75rqgDxZXM5ZT9VB
         aSbLgxsrOPJ5LtvtSclz5vXXql0Fb+JtjQD/qSjqZCC+tHF8G3aAGu8hWepFoFQrpbiX
         YRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681709712; x=1684301712;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zyyAvuW/pOY8jPhiXRm2ACIKthV+mmOLRNiYf8O659s=;
        b=dxhlFcQun59G3tM2pFlzBiCISjlyANc4JeD5SaTDUKCAMlwBqzLeEcNh0Z9RTRD8fS
         pr9efYwGMWg/8rlWl/9r5yrYpZWkk1DRTwaUjr6dsjtlkc3mP8W2PHk1pU/2sdFB0uw6
         T+neyZ6QJFEdl+baHtuudwBeYF+3IqA1NObHgMuSwBNDC7gY0hWeq3F6IYnwtjqB5kAC
         wj69El1f1JKK9a5uvyL2h2XqlSwNRtGjLJ1da2loSIIGUkD1QsiXRoy2vRGv7ehkbleM
         0CbDRCLQXsw3SrACZHpAzM+h/jiLVU7ylOU/QtUJMZdtHC5xR2dSxpeNQL0ImIaVWtFK
         NHDQ==
X-Gm-Message-State: AAQBX9cJsrRBU6nf04PrHOwgX9r2JUchlYQdcLo2p2X+tYTjbdO3z4uo
        p+1fEPFh+Ck+SY4toRM1TYUsnCx9ODX/AwuG+2LUCA==
X-Google-Smtp-Source: AKy350Z5ECMvRkWIvE7F95LlZtfJhA+x9x8GVV6fkpUC9OmmafnMj3yfsH4O3koHyJ4alQ+5IVMGwnwXntVRNMsSYoo=
X-Received: by 2002:a05:6512:408:b0:4ec:90b2:b514 with SMTP id
 u8-20020a056512040800b004ec90b2b514mr1794111lfk.6.1681709711628; Sun, 16 Apr
 2023 22:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000894f5f05f95e9f4d@google.com>
In-Reply-To: <000000000000894f5f05f95e9f4d@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 17 Apr 2023 07:34:59 +0200
Message-ID: <CACT4Y+a9S4dwxAnD0AMcYDKfrZ7JxYcAaYM3QtccNGdpGd7g_Q@mail.gmail.com>
Subject: Re: [syzbot] [bluetooth?] WARNING: bad unlock balance in l2cap_recv_frame
To:     syzbot <syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Apr 2023 at 13:54, syzbot
<syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    95abc817ab3a Merge tag 'acpi-6.3-rc7' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13c85123c80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c21559e740385326
> dashboard link: https://syzkaller.appspot.com/bug?extid=9519d6b5b79cf7787cf3
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/87e400f90ed9/disk-95abc817.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cf7aa6546e50/vmlinux-95abc817.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a44d83ac79a7/bzImage-95abc817.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com
>
> =====================================
> WARNING: bad unlock balance detected!
> 6.3.0-rc6-syzkaller-00168-g95abc817ab3a #0 Not tainted
> -------------------------------------
> kworker/u5:7/5124 is trying to release lock (&conn->chan_lock) at:
> [<ffffffff89148e14>] l2cap_disconnect_rsp net/bluetooth/l2cap_core.c:4697 [inline]
> [<ffffffff89148e14>] l2cap_le_sig_cmd net/bluetooth/l2cap_core.c:6426 [inline]
> [<ffffffff89148e14>] l2cap_le_sig_channel net/bluetooth/l2cap_core.c:6464 [inline]
> [<ffffffff89148e14>] l2cap_recv_frame+0x85a4/0x9390 net/bluetooth/l2cap_core.c:7796
> but there are no more locks to release!
>
> other info that might help us debug this:
> 2 locks held by kworker/u5:7/5124:
>  #0: ffff88801ecca938 ((wq_completion)hci1#2){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: ffff88801ecca938 ((wq_completion)hci1#2){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
>  #0: ffff88801ecca938 ((wq_completion)hci1#2){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
>  #0: ffff88801ecca938 ((wq_completion)hci1#2){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:639 [inline]
>  #0: ffff88801ecca938 ((wq_completion)hci1#2){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:666 [inline]
>  #0: ffff88801ecca938 ((wq_completion)hci1#2){+.+.}-{0:0}, at: process_one_work+0x87a/0x15c0 kernel/workqueue.c:2361
>  #1: ffffc9000468fda8 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x15c0 kernel/workqueue.c:2365
>
> stack backtrace:
> CPU: 1 PID: 5124 Comm: kworker/u5:7 Not tainted 6.3.0-rc6-syzkaller-00168-g95abc817ab3a #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
> Workqueue: hci1 hci_rx_work
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
>  __lock_release kernel/locking/lockdep.c:5346 [inline]
>  lock_release+0x4f1/0x670 kernel/locking/lockdep.c:5689
>  __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:907
>  l2cap_disconnect_rsp net/bluetooth/l2cap_core.c:4697 [inline]
>  l2cap_le_sig_cmd net/bluetooth/l2cap_core.c:6426 [inline]
>  l2cap_le_sig_channel net/bluetooth/l2cap_core.c:6464 [inline]
>  l2cap_recv_frame+0x85a4/0x9390 net/bluetooth/l2cap_core.c:7796
>  l2cap_recv_acldata+0xa80/0xbf0 net/bluetooth/l2cap_core.c:8504
>  hci_acldata_packet net/bluetooth/hci_core.c:3828 [inline]
>  hci_rx_work+0x709/0x1340 net/bluetooth/hci_core.c:4063

/\/\/\/\/\/\/\/\

This is on the receiving path. Can this be triggered remotely?

>  process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
>  worker_thread+0x669/0x1090 kernel/workqueue.c:2537
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
