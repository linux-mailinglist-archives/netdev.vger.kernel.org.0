Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9261747832
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 04:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfFQCab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 22:30:31 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40888 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbfFQCaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 22:30:30 -0400
Received: by mail-lf1-f68.google.com with SMTP id a9so5307071lff.7
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 19:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=DGmSRiaozDL/dTempqHSPFFhsp5hMg0xq639rw6BjeY=;
        b=HQwUO17hmToC7W5MJWHwjEL3kKgwSpD9H94bMlM/Ta41otpJp+QAnmEbS3xNNMVyN9
         9z5rFGH7Vflg30fxYnokeMOG8wGGM7bxoS5sgNeSPRXHkxQ59ME3/CbJjSX4iVsgIuV8
         lZg7Fs7A+3bVyzWbqBP/oQQYUA2OHZeniUqWhaUKskMm3GUw/1kgzltMpQLiR0N2X6T3
         rSbtCWiw+m+AOG7pQz6D2X8IzJS8V9aKFi1PKuwSrKMdHKDhotsdup4n1JaZfdFB64em
         SNxuPeBBUA69FmE6YwOGW0qfSxYXv0qJjrCWiC7jz7sF8Jr4NEdBKG6Lz9doH5YaljeJ
         gaBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=DGmSRiaozDL/dTempqHSPFFhsp5hMg0xq639rw6BjeY=;
        b=aQqiihxBddGUf4ltzlhuoG/ZJLYOVBPQ4I2bcdvThCxt0SXUPaQ5bj8ldEULTbDX3O
         26uKH2yB6R5sFe6UIqRs855sYUrufs4UYvQ6o2IXEzcp7fD+0r7QLblgS80EkfY4QRh8
         Y14qlQIEtyAJtiKIZ48x/dg952r12SI5Sgf3Qd/i2tH2BqO8qgVTA/HjiBEph6efixfe
         UNkq3ZE0ToE2YC3+7CNE3hNzTThbGVWEDk8S+ph25reray10aw2TGYR8Il5lISup1+JO
         00mGzqE76ctQIk1K944omhpyW0F2Jxu6LfgIm/C4aFb6Thz+dh1kbqM+6CA4Rn9WXnX6
         i/pw==
X-Gm-Message-State: APjAAAXNNy5eQrxEYUm99LlJVq+6l4LgOwEPUW47uwc4wr53a9gOqs1f
        EjLiDNk1HuIwh0aOhcCWmAD2jjytw/BVH4WNXXkKUsL6LXg=
X-Google-Smtp-Source: APXvYqwFlpSmLZPWiJg2WPhlYlFtfj/+EcdKnMcnlOd66/vAgtevltcMhNg0YOTqz2tnYdteWzStXhs7/XBbhRqm7vQ=
X-Received: by 2002:ac2:482d:: with SMTP id 13mr10070457lft.132.1560738627381;
 Sun, 16 Jun 2019 19:30:27 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 17 Jun 2019 08:00:00 +0530
Message-ID: <CA+G9fYsr_YW7PSoP+ew60TfNOj885y6j-e2weuWBuU1ccKcAAg@mail.gmail.com>
Subject: kernel/workqueue.c:3030 __flush_work+0x2c2/0x2d0
To:     Netdev <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sgarzare@redhat.com,
        Daniel Borkmann <daniel@iogearbox.net>, kafai@fb.com,
        jakub@cloudflare.com, lkft-triage@lists.linaro.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel warning while running kernel selftest bpf test_sockmap test case on
x86_64 and arm64.
The kernel warning log pops up continuously.

Linux version 5.1.10-rc2

Steps to reproduce:
Boot stable rc 5.1.10-rc2 kernel on x86_64 or arm64
cd selftests/bpf
./test_sockmap

[   37.600406] WARNING: CPU: 3 PID: 57 at
/usr/src/kernel/kernel/workqueue.c:3030 __flush_work+0x2c2/0x2d0
[   37.610034] Modules linked in: x86_pkg_temp_thermal fuse
[   37.615371] CPU: 3 PID: 57 Comm: kworker/3:1 Not tainted 5.1.10-rc2 #1
[   37.615454] WARNING: CPU: 0 PID: 5 at
/usr/src/kernel/kernel/workqueue.c:3030 __flush_work+0x2c2/0x2d0
[   37.621892] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   37.621895] Workqueue: events sk_psock_destroy_deferred
[   37.631183] Modules linked in: x86_pkg_temp_thermal fuse
[   37.638654] RIP: 0010:__flush_work+0x2c2/0x2d0
[   37.638655] Code: c6 00 31 c0 e9 71 ff ff ff 41 8b 0c 24 49 8b 54
24 08 83 e1 08 49 0f ba 2c 24 03 80 c9 f0 e9 d2 fe ff ff 0f 0b e9 50
ff ff ff <0f> 0b 31 c0 e9 47 ff ff ff e8 90 9d fd ff 0f 1f 44 00 00 55
31 f6
[   37.643879] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.1.10-rc2 #1
[   37.643880] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[   37.649183] RSP: 0018:ffffb038c1a23ca0 EFLAGS: 00010246
[   37.653630] Workqueue: events sk_psock_destroy_deferred
[   37.672375] RAX: 0000000000000000 RBX: ffff9e73d9492068 RCX: 0000000000000006
[   37.672376] RDX: 0000000000000006 RSI: 0000000000000001 RDI: ffff9e73d9492068
[   37.678805] RIP: 0010:__flush_work+0x2c2/0x2d0
[   37.678807] Code: c6 00 31 c0 e9 71 ff ff ff 41 8b 0c 24 49 8b 54
24 08 83 e1 08 49 0f ba 2c 24 03 80 c9 f0 e9 d2 fe ff ff 0f 0b e9 50
ff ff ff <0f> 0b 31 c0 e9 47 ff ff ff e8 90 9d fd ff 0f 1f 44 00 00 55
31 f6
[   37.686274] RBP: ffffb038c1a23d68 R08: 0000000000000000 R09: 0000000000000000
[   37.686275] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9e73d9492068
[   37.691494] RSP: 0018:ffffb038c18fbca0 EFLAGS: 00010246
[   37.696720] R13: 0000000000000001 R14: ffffb038c1a23d98 R15: ffffffff9a490d40
[   37.696721] FS:  0000000000000000(0000) GS:ffff9e73dfb80000(0000)
knlGS:0000000000000000
[   37.703851] RAX: 0000000000000000 RBX: ffff9e73d9490868 RCX: 0000000000000006
[   37.703852] RDX: 0000000000000006 RSI: 0000000000000001 RDI: ffff9e73d9490868
[   37.710976] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.710977] CR2: 00007f38680ca8a0 CR3: 00000002ee614006 CR4: 00000000003606e0
[   37.715419] RBP: ffffb038c18fbd68 R08: 0000000000000000 R09: 0000000000000000
[   37.715420] R10: 0000000000000000 R11: 0000000000000000 R12: ffff9e73d9490868
[   37.734156] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   37.734157] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   37.741282] R13: 0000000000000001 R14: ffffb038c18fbd98 R15: ffffffff9a490d40
[   37.741283] FS:  0000000000000000(0000) GS:ffff9e73dfa00000(0000)
knlGS:0000000000000000
[   37.748405] Call Trace:
[   37.748410]  ? work_busy+0xc0/0xc0
[   37.753621] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.753622] CR2: 00007f38680c9788 CR3: 000000045454a004 CR4: 00000000003606f0
[   37.760746]  ? mark_held_locks+0x4d/0x80
[   37.768823] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   37.768824] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   37.775946]  ? __cancel_work_timer+0x11a/0x1d0
[   37.783071] Call Trace:
[   37.783075]  ? work_busy+0xc0/0xc0
[   37.788808]  ? cancel_delayed_work_sync+0x13/0x20
[   37.788810]  ? lockdep_hardirqs_on+0xf6/0x190
[   37.795934]  ? mark_held_locks+0x4d/0x80
[   37.803055]  ? __cancel_work_timer+0x11a/0x1d0
[   37.803057]  ? work_busy+0xc0/0xc0
[   37.810179]  ? __cancel_work_timer+0x11a/0x1d0
[   37.817303]  __cancel_work_timer+0x134/0x1d0
[   37.824453]  ? cancel_delayed_work_sync+0x13/0x20
[   37.824455]  ? lockdep_hardirqs_on+0xf6/0x190
[   37.831579]  cancel_delayed_work_sync+0x13/0x20
[   37.839654]  ? __cancel_work_timer+0x11a/0x1d0
[   37.839657]  ? work_busy+0xc0/0xc0
[   37.842100]  strp_done+0x1c/0x50
[   37.845497]  __cancel_work_timer+0x134/0x1d0
[   37.851242]  sk_psock_destroy_deferred+0x34/0x1c0
[   37.858372]  cancel_delayed_work_sync+0x13/0x20
[   37.862292]  process_one_work+0x281/0x610
[   37.869415]  strp_done+0x1c/0x50
[   37.876540]  worker_thread+0x3c/0x3f0
[   37.880975]  sk_psock_destroy_deferred+0x34/0x1c0
[   37.883419]  ? __kthread_parkme+0x61/0x90
[   37.886819]  process_one_work+0x281/0x610
[   37.891514]  kthread+0x12c/0x150
[   37.895868]  worker_thread+0x3c/0x3f0
[   37.899783]  ? process_one_work+0x610/0x610
[   37.904221]  kthread+0x12c/0x150
[   37.907615]  ? kthread_park+0x90/0x90
[   37.907618]  ret_from_fork+0x3a/0x50
[   37.912052]  ? process_one_work+0x610/0x610
[   37.916355] irq event stamp: 57860
[   37.921058]  ? kthread_park+0x90/0x90
[   37.921060]  ret_from_fork+0x3a/0x50
[   37.925407] hardirqs last  enabled at (57859): [<ffffffff9a4949ba>]
__cancel_work_timer+0x11a/0x1d0
[   37.925409] hardirqs last disabled at (57860): [<ffffffff9a401bab>]
trace_hardirqs_off_thunk+0x1a/0x1c
[   37.929944] irq event stamp: 47474
[   37.934378] softirqs last  enabled at (57812): [<ffffffff9add14d5>]
release_sock+0x85/0xb0
[   37.934379] softirqs last disabled at (57810): [<ffffffff9add140a>]
__release_sock+0xda/0x120
[   37.937773] hardirqs last  enabled at (47473): [<ffffffff9a4949ba>]
__cancel_work_timer+0x11a/0x1d0
[   37.937775] hardirqs last disabled at (47474): [<ffffffff9a401bab>]
trace_hardirqs_off_thunk+0x1a/0x1c
[   37.940998] ---[ end trace ae349dc9a55c8bc8 ]---
[   37.941056] WARNING: CPU: 3 PID: 57 at
/usr/src/kernel/kernel/workqueue.c:3030 __flush_work+0x2c2/0x2d0
[   37.945263] softirqs last  enabled at (47440): [<ffffffff9add14d5>]
release_sock+0x85/0xb0
[   37.945264] softirqs last disabled at (47438): [<ffffffff9add140a>]
__release_sock+0xda/0x120
[   37.949968] Modules linked in: x86_pkg_temp_thermal fuse
[   37.954493] ---[ end trace ae349dc9a55c8bc9 ]---
[   37.954522] WARNING: CPU: 0 PID: 5 at
/usr/src/kernel/kernel/workqueue.c:3030 __flush_work+0x2c2/0x2d0
[...]

metadata:
  git branch: linux-5.1.y
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git commit: b7eabc3862b8717f2bcc47f3f3830ec575423c8c
  git describe: v5.1.9-157-gb7eabc3862b8
  make_kernelversion: 5.1.10-rc2
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.1/33/config
  kernel-defconfig:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.1/33/defconfig
  build-url: https://ci.linaro.org/job/openembedded-lkft-linux-stable-rc-5.1/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-lkft/33/
  build-location:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-stable-rc-5.1/33
  toolchain: x86_64-linaro-linux 7.%
  series: lkft
  email-notification: ''
  kselftest__url: https://www.kernel.org/pub/linux/kernel/v5.x/linux-5.1.tar.xz
  kselftest__version: '5.1'
  kselftest__revision: '5.1'

Full test log,
https://lkft.validation.linaro.org/scheduler/job/775857#L1114

Best regards
Naresh Kamboju
