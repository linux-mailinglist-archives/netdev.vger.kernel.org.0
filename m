Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D82C03E9
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 12:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgKWLPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 06:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbgKWLPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 06:15:15 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D15C061A4D
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 03:15:15 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id lv15so16866210ejb.12
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 03:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=dyYCallMA0sHn7SMbPcP+mI1CGwtuIyTQxNVWNuvxCQ=;
        b=Umk6EHfRD0y6tWGSwIFAg/3takDT1Vg7qC7LcXHtJubC0YE+Bt51VHu0VBuAvObX9S
         eS/WXxQjuXnqt5pWuDOQt6j/rhNQvUJZ9uRoSQciUBSLizV+S2O4Kg4gocglrK7DQy+2
         JHcYVh0HkIiM/Ke8LyjGsCRAt3iCORJC41cQ8v64IhBu+xT2Rd63d8FdmA4dzGJH+Yzb
         Gqm7Dyk8mnQtmfJ43zvcb7SHnuS0dhjgFUafeeOPVOsDc/RabRR3EamGO7dkn5g9xXZy
         24TGk/CK+ifxlUUFpwn7JGT+LPf3dkXGtgoA/FrG8xxi/4LLl6we0bSK9nEsh5foGLUQ
         twBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=dyYCallMA0sHn7SMbPcP+mI1CGwtuIyTQxNVWNuvxCQ=;
        b=H9qDv7GgdII5OOyitTWe/TfAgwdl5hoTktJR8jtDnpIcfEmGlyPoXL5QO5AoluQE69
         PQ0XSKJCS3yM3rNqRX6IZtfA3EKLgn5/+FrquC7eovXR4YDz0LBkZv4gAzMU08YNab2a
         zflbP6EnKkWQFP9v6zpz5TUlXsUAVVGWOIa5Heg1uObgc2l4wNcCrI+QgchAEZgL6y56
         dUaP1WpDqKvqm9AEbK5bCIqI4m9W0IIK+WDybsL/X3SbeLQV+giGUDNEkcPVh4RTfu/4
         NgW9TCZFU0EmGynyR2PineoO638q7NGzBXTle+hAjhHZvtM+Ojt7qGZHTd5KoLNJ4Xyb
         RjPQ==
X-Gm-Message-State: AOAM531KqCfPvbdXdFKD/CsmMT01rHq24GkUS39Ur4fNO/+Jdw5h9tmB
        KXc2KokIvalU7yfZBEfJnjskxyLuxNpKyEDyNKxH9bOaEt8Cj070
X-Google-Smtp-Source: ABdhPJxrw4qU00Wmkoi3whO4IWlXvv6qnxdJbo9/OoMOR0l3g5cbZJYtlc4uacWWpPSXeqeysLh7nUj0jOBQ/rFURC0=
X-Received: by 2002:a17:906:6987:: with SMTP id i7mr46504924ejr.18.1606130113591;
 Mon, 23 Nov 2020 03:15:13 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 23 Nov 2020 16:45:02 +0530
Message-ID: <CA+G9fYs9sg69JgmQNZhutQnbijb4GzcO03XF66EjkQ6CTpXXxA@mail.gmail.com>
Subject: [arm64] kernel BUG at kernel/seccomp.c:1309!
To:     open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
        yifeifz2@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While booting arm64 kernel the following kernel BUG noticed on several arm64
devices running linux next 20201123 tag kernel.


$ git log --oneline next-20201120..next-20201123 -- kernel/seccomp.c
5c5c5fa055ea Merge remote-tracking branch 'seccomp/for-next/seccomp'
bce6a8cba7bf Merge branch 'linus'
7ef95e3dbcee Merge branch 'for-linus/seccomp' into for-next/seccomp
fab686eb0307 seccomp: Remove bogus __user annotations
0d8315dddd28 seccomp/cache: Report cache data through /proc/pid/seccomp_cache
8e01b51a31a1 seccomp/cache: Add "emulator" to check if filter is constant allow
f9d480b6ffbe seccomp/cache: Lookup syscall allowlist bitmap for fast path
23d67a54857a seccomp: Migrate to use SYSCALL_WORK flag


Please find these easy steps to reproduce the kernel build and boot.

step to reproduce:
# please install tuxmake
# sudo pip3 install -U tuxmake
# cd linux-next
# tuxmake --runtime docker --target-arch arm --toolchain gcc-9
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1kgWN61pS5M35vjnVfDSvOOPd38/config

# Boot the arm64 on any arm64 devices.
# you will notice the below BUG

crash log details:
-----------------------
[    6.941012] ------------[ cut here ]------------
Found device  /dev/ttyAMA3.
[    6.947587] lima f4080000.gpu: mod rate = 500000000
[    6.955422] kernel BUG at kernel/seccomp.c:1309!
[    6.955430] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
[    6.955437] Modules linked in: cec rfkill wlcore_sdio(+) kirin_drm
dw_drm_dsi lima(+) drm_kms_helper gpu_sched drm fuse
[    6.955481] CPU: 2 PID: 291 Comm: systemd-udevd Not tainted
5.10.0-rc4-next-20201123 #2
[    6.955485] Hardware name: HiKey Development Board (DT)
[    6.955493] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
[    6.955510] pc : __secure_computing+0xe0/0xe8
[    6.958171] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 400000Hz, actual 400000HZ div = 31)
[    6.965975] [drm] Initialized lima 1.1.0 20191231 for f4080000.gpu on minor 0
[    6.970176] lr : syscall_trace_enter+0x1cc/0x218
[    6.970181] sp : ffff800012d8be10
[    6.970185] x29: ffff800012d8be10 x28: ffff00000092cb00
[    6.970195] x27: 0000000000000000 x26: 0000000000000000
[    6.970203] x25: 0000000000000000 x24: 0000000000000000
[    6.970210] x23: 0000000060000000 x22: 0000000000000202
[    7.011614] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[    7.016457]
[    7.016461] x21: 0000000000000200 x20: ffff00000092cb00
[    7.016470] x19: ffff800012d8bec0 x18: 0000000000000000
[    7.016478] x17: 0000000000000000 x16: 0000000000000000
[    7.016485] x15: 0000000000000000 x14: 0000000000000000
[    7.054116] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 400000Hz, actual 400000HZ div = 31)
[    7.056715]
[    7.103444] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[    7.105105] x13: 0000000000000000 x12: 0000000000000000
[    7.125849] x11: 0000000000000000 x10: 0000000000000000
[    7.125858] x9 : ffff80001001bcbc x8 : 0000000000000000
[    7.125865] x7 : 0000000000000000 x6 : 0000000000000000
[    7.125871] x5 : 0000000000000000 x4 : 0000000000000000
[    7.125879] x3 : 0000000000000000 x2 : ffff00000092cb00
[    7.125886] x1 : 0000000000000000 x0 : 0000000000000116
[    7.125896] Call trace:
] Found device /dev/ttyAMA2.
[    7.125908]  __secure_computing+0xe0/0xe8
[    7.125918]  syscall_trace_enter+0x1cc/0x218
[    7.125927]  el0_svc_common.constprop.0+0x19c/0x1b8
[    7.125933]  do_el0_svc+0x2c/0x98
[    7.125940]  el0_sync_handler+0x180/0x188
[    7.125946]  el0_sync+0x174/0x180
[    7.125958] Code: d2800121 97ffd9a9 d2800120 97fbf1a9 (d4210000)
[    7.199584] ---[ end trace 463debbc21f0c7b5 ]---
[    7.204205] note: systemd-udevd[291] exited with preempt_count 1
[    7.210733] ------------[ cut here ]------------
[    7.215451] WARNING: CPU: 2 PID: #
0 at kernel/rcu/tree.c:632 rcu_eqs_enter.isra.0+0x134/0x140
[    7.223927] Modules linked in: cec rfkill wlcore_sdio kirin_drm
dw_drm_dsi lima drm_kms_helper gpu_sched drm fuse
[    7.234295] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D
  5.10.0-rc4-next-20201123 #2
[    7.243252] Hardware name: HiKey Development Board (DT)
[    7.248561] pstate: 200003c5 (nzCv DAIF -PAN -UAO -TCO BTYPE=--)
[    7.254638] pc : rcu_eqs_enter.isra.0+0x134/0x140
[    7.259350] lr : rcu_idle_enter+0x18/0x28
[    7.263362] sp : ffff8000128e3e80
[    7.266678] x29: ffff8000128e3e80 x28: 0000000000000000
[    7.272001] x27: 0000000000000000 x26: ffff000001b79080
[    7.277321] x25: 0000000000000000 x24: 00000001adc9b310
[    7.282641] x23: 0000000000000000 x22: ffff000001b79080
[    7.287970] x21: ffff000077b24b00 x20: ffff000001b79098
[    7.287979] x19: ffff800011c7ab40 x18: 0000000000000010
[    7.287986] x17: 0000000000000000 x16: 0000000000000000
[    7.287993] x15: ffff00000092cf98 x14: 0720072007200720
[    7.288001] x13: 0720072007200720 x12: 00000000000003c6
[    7.288008] x11: 071c71c71c71c71c x10: 00000000000003c6
[    7.288016] x9 : ffff800010df267c x8 : 000000000000048c
[    7.288023] x7 : 0000000000000c6f x6 : 0000000000009c3f
[    7.288030] x5 : 00000000ffffffff x4 : 0000000000000015
[    7.288038] x3 : 000000000022b7f0 x2 : 4000000000000002
[    7.288046] x1 : 4000000000000000 x0 : ffff000077b26b40
[    7.288054] Call trace:
[    7.288064]  rcu_eqs_enter.isra.0+0x134/0x140
#
[    7.288069]  rcu_idle_enter+0x18/0x28
[    7.288078]  cpuidle_enter_state+0x34c/0x438
[    7.288084]  cpuidle_enter+0x40/0x58
[    7.288092]  call_cpuidle+0x24/0x50
Reached target Sockets.
[    7.288108]  do_idle+0x228/0x290
[    7.375468]  cpu_startup_entry+0x30/0x78
[    7.379397]  secondary_start_kernel+0x158/0x190
[    7.383930] ---[ end trace 463debbc21f0c7b6 ]---
[     OK      ] Reached target B#

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

full test log,
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201123/testrun/3478150/suite/linux-log-parser/test/check-kernel-bug-1968549/log
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201123/testrun/3478177/suite/linux-log-parser/test/check-kernel-bug-1968583/log
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201123/testrun/3478197/suite/linux-log-parser/test/check-kernel-bug-147858/log

metadata:
  git branch: master
  git repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
  git commit: 62918e6fd7b5751c1285c7f8c6cbd27eb6600c02
  git describe: next-20201123
  make_kernelversion: 5.10.0-rc4
  kernel-config: https://builds.tuxbuild.com/1kgWN61pS5M35vjnVfDSvOOPd38/config


-- 
Linaro LKFT
https://lkft.linaro.org
