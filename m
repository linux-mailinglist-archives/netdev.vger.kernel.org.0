Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E536C355CCE
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 22:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245256AbhDFUTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 16:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhDFUTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 16:19:23 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF54C06174A;
        Tue,  6 Apr 2021 13:19:15 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d8so8128110plh.11;
        Tue, 06 Apr 2021 13:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rxGs5zULjcirUWPWFIh26VgiWnlwmvSjrLs+AL4Pbvw=;
        b=vDy4WsqcwKoVR+XP/vAjgZHbu4LXaj8DaNflf2t3PhAFwPk+k9PebxLwOZOzJ3BE3o
         siO2k41JIDYDCU3zxIhtGy9pJyopYIVw9dafHjKsmdjZ+yLLHYAId0yTH4PVEmo9L4Ag
         eeCmrgVsb59vhPyg6ewAC0FbTSkdzhLfF3U4vn0oOHGTPIC1PXVYPcpWGKB4xPvJH+iG
         61OFTnnpd9uCU5t10qxihJ+dmYqGcJ9PzPeJ5iuXna32Z6r+ygVN9zNBFzYQNT5H8Dyv
         r7M4g7niIBxQXv1+b46WRi8F86tCKQ5KdXiAR3uDtyCmN8VQO0C6d7TNPiyOtdMeNY4L
         vztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rxGs5zULjcirUWPWFIh26VgiWnlwmvSjrLs+AL4Pbvw=;
        b=mdRXfRj/zxtZ/0fkNEc7kRXkw0bIG4d1MYBno9EZACKLl4S5NFI2LvJvH9Xi/MKLN0
         3/ebMTalnvncoxxUz49XKf1vAKqgqVce+Tb5OHlQ4hTxWCLpZOeoD7L6814CLgcZ4O+s
         Uhf8gKxwSIUNUhNnO+P5gLG7bXpzEoVphGvoPBU0dl9m62SFNWBImb+zVTbx8MfYjfMH
         dCkbFbT7gNaFJCv8MdpbMbbTyDR92aXvv2m9syV+LiVGhwaPNQO2Nklr1cetJMrfh3Ov
         oV/usziwQGUNjN99DSgoSINUR/Rvrnfr3qboeJbmeWNlSJPqdYcMRhLC/nhJYz6BVuJd
         8S0Q==
X-Gm-Message-State: AOAM531DUPkLo7bnr5b34hyE1tlzRalaechUbjtuFDhxQV2E4c8zfmW9
        gPTlY/4LyDClzcyENJFCp8X3We8k+wo9Md82HUY=
X-Google-Smtp-Source: ABdhPJw1YOt7aCE8xGpRZIkndllPQVURuvgF3KF2Vfn/8/jearuglCVS7JPsh9oY8hj1AAnSPs9BKBoH2g8ouPKYB+A=
X-Received: by 2002:a17:90a:9f0b:: with SMTP id n11mr5992029pjp.56.1617740354734;
 Tue, 06 Apr 2021 13:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f560e805bf453804@google.com>
In-Reply-To: <000000000000f560e805bf453804@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 6 Apr 2021 13:19:03 -0700
Message-ID: <CAM_iQpW6js5R02vWuR7iRfGGkeSj=BprinY6ZEBCtbm7QG=+Xw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in sk_psock_stop
To:     syzbot <syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Borislav Petkov <bp@alien8.de>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, jmattson@google.com,
        John Fastabend <john.fastabend@gmail.com>,
        Joerg Roedel <joro@8bytes.org>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Mark Rutland <mark.rutland@arm.com>, masahiroy@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        pbonzini@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, seanjc@google.com,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, vkuznets@redhat.com,
        wanpengli@tencent.com, Will Deacon <will@kernel.org>,
        x86 <x86@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 6:01 AM syzbot
<syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com> wrote:
> ==================================================================
> BUG: KASAN: use-after-free in __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
> Read of size 8 at addr ffff888024f66238 by task syz-executor.1/14202
>
> CPU: 0 PID: 14202 Comm: syz-executor.1 Not tainted 5.12.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
>  __kasan_report mm/kasan/report.c:399 [inline]
>  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
>  __lock_acquire+0x3e6f/0x54c0 kernel/locking/lockdep.c:4770
>  lock_acquire kernel/locking/lockdep.c:5510 [inline]
>  lock_acquire+0x1ab/0x740 kernel/locking/lockdep.c:5475
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
>  _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
>  spin_lock_bh include/linux/spinlock.h:359 [inline]
>  sk_psock_stop+0x2f/0x4d0 net/core/skmsg.c:750
>  sock_map_close+0x172/0x390 net/core/sock_map.c:1534
>  inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
>  __sock_release+0xcd/0x280 net/socket.c:599
>  sock_close+0x18/0x20 net/socket.c:1258
>  __fput+0x288/0x920 fs/file_table.c:280
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:140
>  tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
>  exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x466459
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1bde3a3188 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 000000000056bf60 RCX: 0000000000466459
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
> RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
> R13: 00007ffe6eb13bbf R14: 00007f1bde3a3300 R15: 0000000000022000
[...]
> Second to last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  __call_rcu kernel/rcu/tree.c:3039 [inline]
>  call_rcu+0xb1/0x740 kernel/rcu/tree.c:3114
>  queue_rcu_work+0x82/0xa0 kernel/workqueue.c:1753
>  sk_psock_put include/linux/skmsg.h:446 [inline]
>  sock_map_unref+0x109/0x190 net/core/sock_map.c:182
>  sock_hash_delete_from_link net/core/sock_map.c:918 [inline]
>  sock_map_unlink net/core/sock_map.c:1480 [inline]
>  sock_map_remove_links+0x389/0x530 net/core/sock_map.c:1492
>  sock_map_close+0x12f/0x390 net/core/sock_map.c:1532

Looks like the last refcnt can be gone before sk_psock_stop().

Technically, we can call sk_psock_stop() before
sock_map_remove_links(), the only barrier is the RCU read lock
there. Let me see if we can get rid of that RCU read lock.

Thanks.
