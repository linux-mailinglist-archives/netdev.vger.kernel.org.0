Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A05F317BB27
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 12:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCFLFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 06:05:42 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41740 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgCFLFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 06:05:39 -0500
Received: by mail-lf1-f68.google.com with SMTP id q10so817369lfo.8
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 03:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=z1++nVFGTuI4yzatq/XiQaAMDI3Yr8HfGAnBFDQYjxE=;
        b=yhHO63LGLvumz8zfcMSFQtWWI9++F1D9YMSXxR/ESnKu7b/fVSO/kPj6H6BHBiRKqP
         i1auvJ4T6nE9eSuluk16UYNh9+m2YsQxHBoGOXQ6yWJYm3DhUhTHbQB7LIiZlrdiQn+k
         BK21k/KfL/XpjM7uwL6NwbMop2ZtQ01MH7qsboNSuIAeVKV+B0Nc+BtxyEsYem1e5n6p
         bthbcWs9L1JVXRShfrDhxSPMConWHWPD11xzGJuhlpIrWKDITOhpHDwB58FVUPq872OA
         ChIV2VNAlWwxsISWGUQlRPMqNLFCvHXqAcs7TLY++jI3DGtlK/0FsP3DjIXrhl5drfn5
         1RQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=z1++nVFGTuI4yzatq/XiQaAMDI3Yr8HfGAnBFDQYjxE=;
        b=kDzd9yo8/tkbuP9BZadQvLJZCtEXzBN79BZw6ql0qs6Sg8nJOLkpw6xZohOW4Lzgjw
         aFDNwd6DOZOeL8+3ATAC3ipld5pDpwjRq/UllacIs7hr7pH6WWEt6rXpHrY9Y0DwCeJA
         S1nmoflG0NkrUdfJAwC91DmvGqJFbNH3SoFIMuecXVX4HtFi4kd+3/WSBpPibcTqASkc
         AxGST5aU5vRZKQ8gxI7LdWGQiYzQM+iWl8KV6cJvmnnlH3AT1fYaiAKFuEktx7kcgi8x
         y6QfHqwlWAPmFQpLLnoZQ1jlVQjHo250Fpsgt/VpBHSjnsJu9DUvkxwQAqGuPHmKqn+X
         2Jug==
X-Gm-Message-State: ANhLgQ3rnQ3oQQL3uSKgy1JxNW8rJp75D+/3Q6OQmYFEEAbmcMq+/wnM
        P/RggqCBpP7qAqmhI2m/JmrnpePkz1X+en1qxbcbZUUUn8j0Og==
X-Google-Smtp-Source: ADFU+vvEdrqidqw7zeBJMr22MkzExrfq8xo3qipCGVQTRrZpyDQOZAgJuCn9C4KHZCPaIlkOvD+ENrUHgfUs9g5TN88=
X-Received: by 2002:a05:6512:3ab:: with SMTP id v11mr1621059lfp.82.1583492734327;
 Fri, 06 Mar 2020 03:05:34 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 6 Mar 2020 16:35:22 +0530
Message-ID: <CA+G9fYvORFZm1s89OU9DV9ckSgk4rWj6tRdUTYh3WPrBnzeRgw@mail.gmail.com>
Subject: WARNING: kernel/bpf/verifier.c:8186 bpf_check+0x2332/0x30a4
To:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        lkft-triage@lists.linaro.org, Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an informative email report,

On linux-next while running kselftest bpf test_verifier, the following
kernel warning reported. But this seems to be NOT a kernel regression
after reading the commit log.

Started noticing from 5.6.0-rc3-next-20200226 and still happening on
5.6.0-rc4-next-20200306.

Suspecting patch,
commit id 94dacdbd5d2dfa2cffd308f128d78c99f855f5be
"
bpf: Tighten the requirements for preallocated hash maps
<>
So preallocation _must_ be enforced for all variants of intrusive
instrumentation.

Unfortunately immediate enforcement would break backwards compatibility, so
for now such programs still are allowed to run, but a one time warning is
emitted in dmesg and the verifier emits a warning in the verifier log as
well so developers are made aware about this and can fix their programs
before the enforcement becomes mandatory.

Link: https://lore.kernel.org/bpf/20200224145642.540542802@linutronix.de
"
steps to reproduce:
          steps:
          - cd /opt/kselftests/default-in-kernel/bpf
          - ./test_verifier || true


[    0.000000] Linux version 5.6.0-rc3-next-20200226 (oe-user@oe-host)
(gcc version 7.3.0 (GCC)) #1 SMP Wed Feb 26 04:46:18 UTC 2020
<Trim>
[   54.263845] trace type BPF program uses run-time allocation
[   54.269438] WARNING: CPU: 1 PID: 473 at
/usr/src/kernel/kernel/bpf/verifier.c:8186 bpf_check+0x2332/0x30a4
[   54.280445] Modules linked in: x86_pkg_temp_thermal fuse
[   54.285759] CPU: 1 PID: 473 Comm: test_verifier Not tainted
5.6.0-rc3-next-20200226 #1
[   54.293669] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[   54.301054] RIP: 0010:bpf_check+0x2332/0x30a4
[   54.305412] Code: ff ff 48 c7 c7 b8 91 5e a8 4c 89 85 10 ff ff ff
48 89 95 18 ff ff ff 48 89 85 20 ff ff ff c6 05 e1 54 98 01 01 e8 4e
16 ea ff <0f> 0b 4c 8b 85 10 ff ff ff 48 8b 95 18 ff ff ff 48 8b 85 20
ff ff
[   54.324149] RSP: 0018:ffffbf708061bc48 EFLAGS: 00010282
[   54.329365] RAX: 0000000000000000 RBX: ffffa0a66b5ad200 RCX: 0000000000000000
[   54.336489] RDX: 0000000000000001 RSI: ffffa0a66fa98d48 RDI: ffffa0a66fa98d48
[   54.343614] RBP: ffffbf708061bd48 R08: 0000000000000000 R09: 0000000000000000
[   54.350736] R10: 0000000000000000 R11: 0000000000000000 R12: ffffa0a667a90000
[   54.357863] R13: 0000000000000004 R14: 0000000000000000 R15: ffffbf7080069058
[   54.364993] FS:  00007fd8b7cd4740(0000) GS:ffffa0a66fa80000(0000)
knlGS:0000000000000000
[   54.373070] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   54.378807] CR2: 000000000098e65c CR3: 0000000231bf6001 CR4: 00000000003606e0
[   54.385931] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   54.393054] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   54.400180] Call Trace:
[   54.402633]  ? lockdep_hardirqs_on+0xf6/0x190
[   54.406993]  ? ktime_get_with_offset+0x7a/0x130
[   54.411525]  ? trace_hardirqs_on+0x4c/0x100
[   54.415714]  bpf_prog_load+0x57d/0x6f0
[   54.419466]  ? __might_fault+0x3e/0x90
[   54.423221]  ? selinux_bpf+0x5a/0x80
[   54.426806]  __do_sys_bpf+0xd69/0x1cd0
[   54.430565]  __x64_sys_bpf+0x1a/0x20
[   54.434146]  do_syscall_64+0x55/0x200
[   54.437812]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   54.442862] RIP: 0033:0x7fd8b6d9af59
[   54.446441] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 0f ff 2b 00 f7 d8 64 89
01 48
[   54.465179] RSP: 002b:00007ffd5bac5238 EFLAGS: 00000202 ORIG_RAX:
0000000000000141
[   54.472743] RAX: ffffffffffffffda RBX: 00007ffd5bac53ec RCX: 00007fd8b6d9af59
[   54.479867] RDX: 0000000000000078 RSI: 00007ffd5bac52b0 RDI: 0000000000000005
[   54.486991] RBP: 00007ffd5bac5250 R08: 00007ffd5bac53f8 R09: 00007ffd5bac52b0
[   54.494115] R10: 000000000098e638 R11: 0000000000000202 R12: 0000000000000005
[   54.501239] R13: 000000000098e630 R14: 0000000000000001 R15: 0000000000000000
[   54.508368] irq event stamp: 82014
[   54.511770] hardirqs last  enabled at (82013): [<ffffffffa6f775ed>]
console_unlock+0x45d/0x5c0
[   54.520374] hardirqs last disabled at (82014): [<ffffffffa6e01f3b>]
trace_hardirqs_off_thunk+0x1a/0x1c
[   54.529666] softirqs last  enabled at (82000): [<ffffffffa8000338>]
__do_softirq+0x338/0x43a
[   54.538096] softirqs last disabled at (81963): [<ffffffffa6f04588>]
irq_exit+0xb8/0xc0
[   54.545999] ---[ end trace 75d82c4cbb8fc047 ]---

metadata:
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git branch: master
  git describe: next-20200226
  make_kernelversion: 5.6.0-rc3
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-next/712/config

Full test log,
https://lkft.validation.linaro.org/scheduler/job/1251016#L1416
https://lkft.validation.linaro.org/scheduler/job/1269522#L1509
https://lkft.validation.linaro.org/scheduler/job/1269575#L1501

-- 
Linaro LKFT
https://lkft.linaro.org
