Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5E835D971
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbhDMH5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238461AbhDMH5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 03:57:11 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F97AC06138C
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:56:52 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id iu14so7654700qvb.4
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 00:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mxKFk1aTW36YnbK1RqIfQPFwaADMV0ipjdR5vf2QzKU=;
        b=JoalcQ0j1ayXXRh+TUmTIETow33d/Czs2cXjD5gEct0Y6z8t04a31V1TS2JNwHLPNy
         0d1UM4KCSBh+AAySFkSNu/qbsighr3D5EeEWXjzGRUm0iCEcxYO4EOgf7JVep+wer3bs
         Oohd7YtrnB/9AmqLU1AcXbx0QLep0spwaYND9DyQVzICEMbwaXsRMkJnbtZr2OhijpMT
         mFY+zOzI/oe1VsisFu4gjVOmfNedO8Nt6bzj6CltY0z7NtwOxC3/QkiFihZFPb2H/Udm
         CW6NPcMRU/r9aWuTcT8fqL7doMHc1sm8dvuyRWXtSEayBYqs6BcZgT7Yj2y29x7r5CDz
         8pLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mxKFk1aTW36YnbK1RqIfQPFwaADMV0ipjdR5vf2QzKU=;
        b=h4hZ7qgK01H3qWT1EyBqCfXbqcwoMrL+bXK2afeO/suvZxvVRYfAKfnmovw+d+boLZ
         TQTZoKcS8BjzJU5FOdV9/H9YprIeAt3kCaTgMpWb6a0yFs6BqF3bL7SdyqHdvFQocTPD
         EDJR/9UxH7KOVoVizp7XLf6Cw5mGZQtGIb9WG2BUq/3havEQhD/NbtN3S+6HZP3/HiE5
         5FLdatPNLK8AlIIhG/CIU3y0tdMds1mxY+lMkqc9bwfT/2GECYgzwM0qE00LtASQ/XAd
         Fa8f3mV5sKdsDSJuJ+HlRG01SdmHyt1X6F7tMXy/fOZbAuvGhEPUrQBM+qQsE0NE3x3c
         rMmQ==
X-Gm-Message-State: AOAM533rV1CmZcBU7gNeL8/0e08t8iP9IYU99SIoMlt1MZJAZNbGDOzZ
        w1bJgE36jZ+a4CgTLkIZ9eNOweqx76AwC91l/q245g==
X-Google-Smtp-Source: ABdhPJzMBGRjaIpG6PgZxs+ZJeW9IreRa2ouM6Qm5gDee285sjYCDoMDd3rvf7cu2++u4/R5cGcmgqipoKimcP9sT6Y=
X-Received: by 2002:a0c:e3d1:: with SMTP id e17mr80225qvl.37.1618300611130;
 Tue, 13 Apr 2021 00:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d9fefa05bee78afd@google.com> <97b5573f-9fcc-c195-f765-5b1ed84a95bd@fb.com>
 <d947c28c-6ede-5950-87e7-f56b8403535a@fb.com>
In-Reply-To: <d947c28c-6ede-5950-87e7-f56b8403535a@fb.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 13 Apr 2021 09:56:40 +0200
Message-ID: <CACT4Y+ZYEVsycyzDW9+tXYw-5feZS8otgMWGGZRUCLR=czWtqQ@mail.gmail.com>
Subject: Re: [syzbot] WARNING in bpf_test_run
To:     Yonghong Song <yhs@fb.com>
Cc:     syzbot <syzbot+774c590240616eaa3423@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Borislav Petkov <bp@alien8.de>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Joerg Roedel <joro@8bytes.org>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, masahiroy@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        rafael.j.wysocki@intel.com, Steven Rostedt <rostedt@goodmis.org>,
        Sean Christopherson <seanjc@google.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 2, 2021 at 2:41 AM 'Yonghong Song' via syzkaller-bugs
<syzkaller-bugs@googlegroups.com> wrote:
> > On 4/1/21 4:29 AM, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    36e79851 libbpf: Preserve empty DATASEC BTFs during
> >> static..
> >> git tree:       bpf-next
> >> console output:
> >> https://syzkaller.appspot.com/x/log.txt?x=1569bb06d00000
> >> kernel config:
> >> https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
> >> dashboard link:
> >> https://syzkaller.appspot.com/bug?extid=774c590240616eaa3423
> >> syz repro:
> >> https://syzkaller.appspot.com/x/repro.syz?x=17556b7cd00000
> >> C reproducer:
> >> https://syzkaller.appspot.com/x/repro.c?x=1772be26d00000
> >>
> >> The issue was bisected to:
> >>
> >> commit 997acaf6b4b59c6a9c259740312a69ea549cc684
> >> Author: Mark Rutland <mark.rutland@arm.com>
> >> Date:   Mon Jan 11 15:37:07 2021 +0000
> >>
> >>      lockdep: report broken irq restoration
> >>
> >> bisection log:
> >> https://syzkaller.appspot.com/x/bisect.txt?x=10197016d00000
> >> final oops:
> >> https://syzkaller.appspot.com/x/report.txt?x=12197016d00000
> >> console output:
> >> https://syzkaller.appspot.com/x/log.txt?x=14197016d00000
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the
> >> commit:
> >> Reported-by: syzbot+774c590240616eaa3423@syzkaller.appspotmail.com
> >> Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")
> >>
> >> ------------[ cut here ]------------
> >> WARNING: CPU: 0 PID: 8725 at include/linux/bpf-cgroup.h:193
> >> bpf_cgroup_storage_set include/linux/bpf-cgroup.h:193 [inline]
> >> WARNING: CPU: 0 PID: 8725 at include/linux/bpf-cgroup.h:193
> >> bpf_test_run+0x65e/0xaa0 net/bpf/test_run.c:109
> >
> > I will look at this issue. Thanks!
> >
> >> Modules linked in:
> >> CPU: 0 PID: 8725 Comm: syz-executor927 Not tainted
> >> 5.12.0-rc4-syzkaller #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine,
> >> BIOS Google 01/01/2011
> >> RIP: 0010:bpf_cgroup_storage_set include/linux/bpf-cgroup.h:193 [inline]
> >> RIP: 0010:bpf_test_run+0x65e/0xaa0 net/bpf/test_run.c:109
> >> Code: e9 29 fe ff ff e8 b2 9d 3a fa 41 83 c6 01 bf 08 00 00 00 44 89
> >> f6 e8 51 a5 3a fa 41 83 fe 08 0f 85 74 fc ff ff e8 92 9d 3a fa <0f> 0b
> >> bd f0 ffff ff e9 5c fd ff ff e8 81 9d 3a fa 83 c5 01 bf 08
> >> RSP: 0018:ffffc900017bfaf0 EFLAGS: 00010293
> >> RAX: 0000000000000000 RBX: ffffc90000f29000 RCX: 0000000000000000
> >> RDX: ffff88801bc68000 RSI: ffffffff8739543e RDI: 0000000000000003
> >> RBP: 0000000000000007 R08: 0000000000000008 R09: 0000000000000001
> >> R10: ffffffff8739542f R11: 0000000000000000 R12: dffffc0000000000
> >> R13: ffff888021dd54c0 R14: 0000000000000008 R15: 0000000000000000
> >> FS:  00007f00157d7700(0000) GS:ffff8880b9c00000(0000)
> >> knlGS:0000000000000000
> >> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> CR2: 00007f0015795718 CR3: 00000000157ae000 CR4: 00000000001506f0
> >> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >> Call Trace:
> >>   bpf_prog_test_run_skb+0xabc/0x1c70 net/bpf/test_run.c:628
> >>   bpf_prog_test_run kernel/bpf/syscall.c:3132 [inline]
> >>   __do_sys_bpf+0x218b/0x4f40 kernel/bpf/syscall.c:4411
> >>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>
> Run on my qemu (4 cpus) with C reproducer and I cannot reproduce the
> result. It already ran 30 minutes and still running. Checked the code,
> it is just doing a lot of parallel bpf_prog_test_run's.
>
> The failure is in the below WARN_ON_ONCE code:
>
> 175 static inline int bpf_cgroup_storage_set(struct bpf_cgroup_storage
> 176
> *storage[MAX_BPF_CGROUP_STORAGE_TYPE])
> 177 {
> 178         enum bpf_cgroup_storage_type stype;
> 179         int i, err = 0;
> 180
> 181         preempt_disable();
> 182         for (i = 0; i < BPF_CGROUP_STORAGE_NEST_MAX; i++) {
> 183                 if
> (unlikely(this_cpu_read(bpf_cgroup_storage_info[i].task) != NULL))
> 184                         continue;
> 185
> 186                 this_cpu_write(bpf_cgroup_storage_info[i].task,
> current);
> 187                 for_each_cgroup_storage_type(stype)
> 188
> this_cpu_write(bpf_cgroup_storage_info[i].storage[stype],
> 189                                        storage[stype]);
> 190                 goto out;
> 191         }
> 192         err = -EBUSY;
> 193         WARN_ON_ONCE(1);
> 194
> 195 out:
> 196         preempt_enable();
> 197         return err;
> 198 }
>
> Basically it shows the stress test triggered a warning due to
> limited kernel resource.

Hi Yonghong,

Thanks for looking into this.
If this is not a kernel bug, then it must not use WARN_ON[_ONCE]. It
makes the kernel untestable for both automated systems and humans:

https://lwn.net/Articles/769365/

<quote>
Greg Kroah-Hartman raised the problem of core kernel API code that
will use WARN_ON_ONCE() to complain about bad usage; that will not
generate the desired result if WARN_ON_ONCE() is configured to crash
the machine. He was told that the code should just call pr_warn()
instead, and that the called function should return an error in such
situations. It was generally agreed that any WARN_ON() or
WARN_ON_ONCE() calls that can be triggered from user space need to be
fixed.
</quote>



> >>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >> RIP: 0033:0x446199
> >> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48
> >> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> >> 01 f0 ffff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> >> RSP: 002b:00007f00157d72f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> >> RAX: ffffffffffffffda RBX: 00000000004cb440 RCX: 0000000000446199
> >> RDX: 0000000000000028 RSI: 0000000020000080 RDI: 000000000000000a
> >> RBP: 000000000049b074 R08: 0000000000000000 R09: 0000000000000000
> >> R10: 0000000000000000 R11: 0000000000000246 R12: f9abde7200f522cd
> >> R13: 3952ddf3af240c07 R14: 1631e0d82d3fa99d R15: 00000000004cb448
> >>
> >>
> >> ---
> >> This report is generated by a bot. It may contain errors.
> >> See
> >> https://goo.gl/tpsmEJ
> >> for more information about syzbot.
> >> syzbot engineers can be reached at syzkaller@googlegroups.com.
> >>
> >> syzbot will keep track of this issue. See:
> >> https://goo.gl/tpsmEJ#status
> >> for how to communicate with syzbot.
> >> For information about bisection process see:
> >> https://goo.gl/tpsmEJ#bisection
> >> syzbot can test patches for this issue, for details see:
> >> https://goo.gl/tpsmEJ#testing-patches
