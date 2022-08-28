Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691485A3D41
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 13:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiH1LD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 07:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiH1LDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 07:03:24 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2079525EB0;
        Sun, 28 Aug 2022 04:03:23 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-33dce2d4bc8so135051587b3.4;
        Sun, 28 Aug 2022 04:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=r+ouzV7GsmVD4UNZJ+3dRD0EfUzhHcs91N7oxvmjX50=;
        b=YteknKlfPSvIVhQ72sQiWwgmuZsP8qxAyGghWV+8ScaxNYmkMw8cbHnQYCDEyKhAR+
         FIS8bDlWokTV3+YSChO1R/YaGKRLE2jltdwcr2V0oo1RXrTFcZLzM257wcWlAATSB0XZ
         prG9cVr1W5t0fShPhzlhq6rUZsAb0As/aK+57+2OFwlXrCcUHhnEwbff5aIelOVkKq6T
         ZCPX33tiqV82sucAm8MToFeMX7PpPak3Zv0Z5BruQ5kXf5gKrH0kJHpqipOgV+fMxn75
         9nx8SGdXplNCZh2mVwAZl2U50SVC2Nlqq+ktoS14p9qpbcgDnXGmKvghU4I/o6zv/m8D
         iUKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=r+ouzV7GsmVD4UNZJ+3dRD0EfUzhHcs91N7oxvmjX50=;
        b=GLlduRe6VUPNRTSwBQtWOzIwbFZUNzZ34Y3J3rlIZjSI6h6b9kV2dpGfGUh0BANxbF
         CY6lrKavPtQtcMzN3aRViBfo9aylHGHsBBtqAIj8E7orMcUNP8PjbCywjcpfN68lZVAb
         K9lKhV5eFLEAdXk6gtwV4a6A3QxIx9/yesOYZtZfG6JgmJM2OME/1qnR0r/WN4xUiwj+
         Mos4GSravci+F7QD61H4h90vM1jsO5Mh6eyqGYlYuu4s+3xboytNM7uy2k1MTaEVVwT3
         kY6P9/YnBIKDKJ6/rdwfANbVM89KrX7XzDF0JOgmPhUxlQphrsa2FWY322PDzBiRVcqF
         OGwA==
X-Gm-Message-State: ACgBeo0qeFW1LB6Qc2FZ3AHckockK8neZpe9EH9+xH2fa5bKIgFPUQJh
        +laq/DEXC8/zQJpTIkLPhgIr/MhwlCiu5Aa4PCaJQmYkRLhj4IaM
X-Google-Smtp-Source: AA6agR7z0W6+dzuqhcXgo25U/keFBs5uhWuoRjPhaWxGCWmNzBAMxP4DdKEFnv4K8m25vLE9fvD2Kwa2SS4WOPFODM4=
X-Received: by 2002:a0d:f2c6:0:b0:329:c117:c990 with SMTP id
 b189-20020a0df2c6000000b00329c117c990mr6472697ywf.464.1661684601900; Sun, 28
 Aug 2022 04:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAO4S-me4hoy0W6GASU3tOFF16+eaotxPbw+kqyc6vuxtxJyDZg@mail.gmail.com>
In-Reply-To: <CAO4S-me4hoy0W6GASU3tOFF16+eaotxPbw+kqyc6vuxtxJyDZg@mail.gmail.com>
From:   Jiacheng Xu <578001344xu@gmail.com>
Date:   Sun, 28 Aug 2022 19:03:07 +0800
Message-ID: <CAO4S-mfTNEKCs8ZQcT09wDzxX8MfidmbTVzaFMD3oG4i7Ytynw@mail.gmail.com>
Subject: Re: possible deadlock in rfcomm_sk_state_change
To:     linux-kernel@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, desmondcheongzx@gmail.com
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_STARTS_WITH_NUMS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I believe the deadlock is more than possible but actually real.
I got a poc that could stably trigger the deadlock.

poc: https://drive.google.com/file/d/1PjqvMtHsrrGM1MIRGKl_zJGR-teAMMQy/view?usp=sharing

Description/Root cause:
In rfcomm_sock_shutdown(), lock_sock() is called when releasing and
shutting down socket.
However, lock_sock() has to be called once more when the sk_state is
changed because the
lock is not always held when rfcomm_sk_state_change() is called. One
such call stack is:

  rfcomm_sock_shutdown():
    lock_sock();
    __rfcomm_sock_close():
      rfcomm_dlc_close():
        __rfcomm_dlc_close():
          rfcomm_dlc_lock();
          rfcomm_sk_state_change():
            lock_sock();

Besides the recursive deadlock, there is also an
issue of a lock hierarchy inversion between rfcomm_dlc_lock() and
lock_sock() if the socket is locked in rfcomm_sk_state_change().

Reference: https://lore.kernel.org/all/20211004180734.434511-1-desmondcheongzx@gmail.com/

On Sun, Aug 28, 2022 at 12:19 AM Jiacheng Xu <578001344xu@gmail.com> wrote:
>
> Hello,
>
> When using modified Syzkaller to fuzz the Linux kernel-5.19, the
> following crash was triggered.
> We would appreciate a CVE ID if this is a security issue.
>
> HEAD commit: 3d7cb6b04c3f Linux-5.19
> git tree: upstream
>
> console output:
> https://drive.google.com/file/d/1NmOGWcfPnY2kSrS0nOwvG1AZ923jFQ3p/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing
> syz repro: https://drive.google.com/file/d/16hUTEGw4IcPQA9CZvoF7I5la42TlU-Cx/view?usp=sharing
> C reproducer: https://drive.google.com/file/d/1YvgzTvV4qaSZPiD4D1IWGL4GuapzHD2w/view?usp=sharing
>
> Environment:
> Ubuntu 20.04 on Linux 5.4.0
> QEMU 4.2.1:
> qemu-system-x86_64 \
>   -m 2G \
>   -smp 2 \
>   -kernel /home/workdir/bzImage \
>   -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
>   -drive file=/home/workdir/stretch.img,format=raw \
>   -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
>   -net nic,model=e1000 \
>   -enable-kvm \
>   -nographic \
>   -pidfile vm.pid \
>   2>&1 | tee vm.log
>
> If you fix this issue, please add the following tag to the commit:
> Reported-by Jiacheng Xu<578001344xu@gmail.com>
>
> ============================================
> WARNING: possible recursive locking detected
> 5.19.0 #1 Not tainted
> --------------------------------------------
> syz-executor/9064 is trying to acquire lock:
> ffff888026b13130 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0},
> at: lock_sock include/net/sock.h:1677 [inline]
> ffff888026b13130 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0},
> at: rfcomm_sk_state_change+0x6e/0x3a0 net/bluetooth/rfcomm/sock.c:73
>
> but task is already holding lock:
> ffff888026b13130 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0},
> at: lock_sock include/net/sock.h:1677 [inline]
> ffff888026b13130 (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0},
> at: rfcomm_sock_shutdown+0x57/0x220 net/bluetooth/rfcomm/sock.c:902
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
>   lock(sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 4 locks held by syz-executor/9064:
>  #0: ffff888110dac410 (&sb->s_type->i_mutex_key#12){+.+.}-{3:3}, at:
> inode_lock include/linux/fs.h:741 [inline]
>  #0: ffff888110dac410 (&sb->s_type->i_mutex_key#12){+.+.}-{3:3}, at:
> __sock_release+0x86/0x280 net/socket.c:649
>  #1: ffff888026b13130
> (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at: lock_sock
> include/net/sock.h:1677 [inline]
>  #1: ffff888026b13130
> (sk_lock-AF_BLUETOOTH-BTPROTO_RFCOMM){+.+.}-{0:0}, at:
> rfcomm_sock_shutdown+0x57/0x220 net/bluetooth/rfcomm/sock.c:902
>  #2: ffffffff8d7d8428 (rfcomm_mutex){+.+.}-{3:3}, at:
> rfcomm_dlc_close+0x34/0x240 net/bluetooth/rfcomm/core.c:507
>  #3: ffff8880155d2d28 (&d->lock){+.+.}-{3:3}, at:
> __rfcomm_dlc_close+0x157/0x710 net/bluetooth/rfcomm/core.c:487
>
> stack backtrace:
> CPU: 0 PID: 9064 Comm: syz-executor Not tainted 5.19.0 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_deadlock_bug kernel/locking/lockdep.c:2988 [inline]
>  check_deadlock kernel/locking/lockdep.c:3031 [inline]
>  validate_chain kernel/locking/lockdep.c:3816 [inline]
>  __lock_acquire.cold+0x152/0x3ca kernel/locking/lockdep.c:5053
>  lock_acquire kernel/locking/lockdep.c:5665 [inline]
>  lock_acquire+0x1ab/0x580 kernel/locking/lockdep.c:5630
>  lock_sock_nested+0x36/0xf0 net/core/sock.c:3389
>  lock_sock include/net/sock.h:1677 [inline]
>  rfcomm_sk_state_change+0x6e/0x3a0 net/bluetooth/rfcomm/sock.c:73
>  __rfcomm_dlc_close+0x1ab/0x710 net/bluetooth/rfcomm/core.c:489
>  rfcomm_dlc_close+0x1ea/0x240 net/bluetooth/rfcomm/core.c:520
>  __rfcomm_sock_close+0xda/0x260 net/bluetooth/rfcomm/sock.c:220
>  rfcomm_sock_shutdown+0xf4/0x220 net/bluetooth/rfcomm/sock.c:905
>  rfcomm_sock_release+0x5f/0x140 net/bluetooth/rfcomm/sock.c:925
>  __sock_release+0xcd/0x280 net/socket.c:650
>  sock_close+0x18/0x20 net/socket.c:1365
>  __fput+0x277/0x9d0 fs/file_table.c:317
>  task_work_run+0xe0/0x1a0 kernel/task_work.c:177
>  exit_task_work include/linux/task_work.h:38 [inline]
>  do_exit+0xaf5/0x2da0 kernel/exit.c:795
>  do_group_exit+0xd2/0x2f0 kernel/exit.c:925
>  get_signal+0x2842/0x2870 kernel/signal.c:2857
>  arch_do_signal_or_restart+0x82/0x2270 arch/x86/kernel/signal.c:869
>  exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
>  exit_to_user_mode_prepare+0x174/0x260 kernel/entry/common.c:201
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
>  syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f26c3295dfd
> Code: Unable to access opcode bytes at RIP 0x7f26c3295dd3.
> RSP: 002b:00007f26c43fcc58 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: fffffffffffffffc RBX: 00007f26c33bc0a0 RCX: 00007f26c3295dfd
> RDX: 0000000000000080 RSI: 0000000020000000 RDI: 0000000000000004
> RBP: 00007f26c32ff4c1 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f26c33bc0a0
> R13: 00007ffc2c88f2df R14: 00007ffc2c88f480 R15: 00007f26c43fcdc0
>  </TASK>
