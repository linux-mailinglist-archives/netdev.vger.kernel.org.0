Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AF81A6CBB
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgDMTnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388035AbgDMTnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:43:00 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F284C0A3BDC
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 12:42:58 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id y4so3807664ljn.7
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 12:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=t09teWLIz8oBv6JKVPUJLthiHqeGdwmS4kNlrBcHMoQ=;
        b=hNXH1JLIdAvU1AbPEiG9eeKg62TJa+rosh3Omf4OZMb7dHBVDNj6q0eLQgvgvym4pn
         fGfesXeUTOzN8wvjmTghtS8yOENFFLzJ0SksIUtqH5ZBRn8jqHjU5RNuQPpsOmue+uFN
         RjucVcaiThYxMxbyaKumNk2BhfT+BIsbS95HTIElsvjOC7rgRcDqTocQ8KW3XW+QcsxL
         lZpWzFZfBsTQIGsBTRiIMsASLhEZvI4V0EiMpf/gHW03Nii43fVEuhYJMIiK+pW3BtB7
         knQCWb7JyhuK5bDD9MGVvzir4xzclqq1sC1yXruqVbEu0JAY9TSSfMobUV3kZHtlpu8l
         gBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=t09teWLIz8oBv6JKVPUJLthiHqeGdwmS4kNlrBcHMoQ=;
        b=eGwSPKRcH+cxCQXWLq6CO+NfMAY/McpqHqlXFxfMZEgupt4o0jkTod1s7wwwCaXZDr
         Vlgt3ifCEU/kBf0uPvZKUWWGdplCrXnt80pwHc0FqjM6nmzcebkRRwSMFVqt3YBex9er
         7gVjTzxfGtNRCjyopc1CzdHVD559cmZMxolg4bUmP9r17g3IY6Rm5sfhKgmqivaLsVT3
         +SF/HmwLeTOlJuq5tNh0ffDxb7yA+APQE0hQMMPIBMu7A4sP+UbneNHda05JTPYkvqNR
         KO6vhx95FXgBsdysGENRm6cyMXCpQi6TBubgnynuJ+Ikd9nvnxFcrIsHs/6bhqGpMqEH
         n3rw==
X-Gm-Message-State: AGi0PuabqRPYSzXb1YagfKCB86FEMPeD+JgNeGwk+Yz4kNSg/CZVHlcv
        C8mNm6Z6Gw9EnKQrBc5Es4ydcCF1BTGAyO436T9k3w==
X-Google-Smtp-Source: APiQypLusARjMGUJ1qC1L8fE1h58HeNOxpphTclAqEDlrZSYJRxlJkUWd7wNIkkTJQ0knmvlAh1Zol5i7ngMpvlwoFo=
X-Received: by 2002:a2e:6c05:: with SMTP id h5mr11151822ljc.217.1586806976503;
 Mon, 13 Apr 2020 12:42:56 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Apr 2020 01:12:45 +0530
Message-ID: <CA+G9fYv9buJmKJZUDDimfVn-cYYVak2ECx0Az35FgzAa=bi-mw@mail.gmail.com>
Subject: BUG: kernel NULL pointer dereference, address: 00000041 - EIP: kmem_cache_alloc_trace
To:     open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org, Shuah Khan <shuah@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Brendan Higgins <brendanhiggins@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running kselftest bpf tests the following kernel BUG (s) noticed on
i386 kernel running x86_64 device running maining 5.7.0 kernel.

The similar issue was reported a month back.
https://lore.kernel.org/linux-kselftest/CAFd5g46Bwd8HS9-xjHLh_rB59Nfw8iAnM6aFe0QPcveewDUT6g@mail.gmail.com/T/

steps to reproduce:
----------------------------
# cd /opt/kselftests/default-in-kernel/
# ./run_kselftest.sh

Test log:
-----------
[  337.393528] test_bpf: #3 DIV_MOD_KX
[  337.393535] BUG: kernel NULL pointer dereference, address: 00000041
[  337.404663] #PF: supervisor read access in kernel mode
[  337.409794] #PF: error_code(0x0000) - not-present page
[  337.414925] *pde = 00000000
[  337.417803] Oops: 0000 [#2] SMP
[  337.420940] CPU: 1 PID: 6931 Comm: modprobe Tainted: G      D W
    5.7.0-rc1 #1
[  337.428676] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  337.436152] EIP: __kmalloc_track_caller+0x9f/0x310
[  337.440941] Code: 9f 01 00 00 89 75 e0 8b 07 64 8b 50 04 64 03 05
d8 32 3a df 8b 08 85 c9 89 4d f0 0f 84 0a 02 00 00 8b 75 f0 8b 47 14
8d 4a 01 <8b> 1c 06 89 f0 8b 37 64 0f c7 0e 75 d0 8b 75 e0 8b 47 14 0f
18 04
[  337.459680] EAX: 00000040 EBX: 00002cc0 ECX: 000017fb EDX: 000017fa
[  337.465936] ESI: 00000001 EDI: f5403680 EBP: f26f3d2c ESP: f26f3d0c
[  337.472193] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  337.478972] CR0: 80050033 CR2: 00000041 CR3: 33db3000 CR4: 003406d0
[  337.485238] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  337.491494] DR6: fffe0ff0 DR7: 00000400
[  337.495324] Call Trace:
[  337.497771]  ? bpf_prepare_filter+0x2bd/0x5f0
[  337.502131]  kmemdup+0x1b/0x40
[  337.505189]  bpf_prepare_filter+0x2bd/0x5f0
[  337.509376]  bpf_prog_create+0x65/0xa0
[  337.513127]  test_bpf_init+0x1f8/0xd8f [test_bpf]
[  337.517832]  ? free_pcppages_bulk+0x4e0/0x550
[  337.522186]  ? build_test_skb+0x156/0x156 [test_bpf]
[  337.527150]  do_one_initcall+0x54/0x2e0
[  337.530990]  ? __might_sleep+0x33/0x80
[  337.534742]  ? _cond_resched+0x17/0x30
[  337.538493]  ? kmem_cache_alloc_trace+0x209/0x2b0
[  337.543191]  ? do_init_module+0x21/0x1f7
[  337.547108]  ? do_init_module+0x21/0x1f7
[  337.551024]  do_init_module+0x50/0x1f7
[  337.554771]  load_module+0x1e32/0x2540
[  337.558528]  __ia32_sys_finit_module+0x8f/0xe0
[  337.562982]  do_fast_syscall_32+0x7f/0x330
[  337.567076]  entry_SYSENTER_32+0xaa/0x102
[  337.571078] EIP: 0xb7f9dce1
[  337.573870] Code: 5e 5d c3 8d b6 00 00 00 00 b8 40 42 0f 00 eb c1
8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  337.592626] EAX: ffffffda EBX: 00000005 ECX: 0806233a EDX: 00000000
 #[
# Socket 1 6  337.598898] ESI: 0977f840 EDI: 0977f480 EBP: 0977f700
ESP: bf9e017c
[  337.606542] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
[  337.613323] Modules linked in: test_bpf(+) test_printf(+) cls_bpf
sch_fq 8021q sch_ingress veth algif_hash x86_pkg_temp_thermal fuse
[last unloaded: test_strscpy]
[  337.627829] CR2: 0000000000000041
[  337.631139] ---[ end trace 09f43fd7981266ca ]---
[  337.635750] EIP: ida_free+0x61/0x130
[  337.639319] Code: 00 c7 45 e8 00 00 00 00 c7 45 ec 00 00 00 00 0f
88 c4 00 00 00 89 d3 e8 0d 8e 87 00 89 c7 8d 45 d8 e8 93 1e 01 00 a8
01 75 3f <0f> a3 30 72 72 8b 45 d8 89 fa e8 e0 8f 87 00 53 68 08 ab fd
de e8
[  337.658058] EAX: 00000000 EBX: 00000000 ECX: e422d8c0 EDX: 00000000
[  337.664322] ESI: 00000000 EDI: 00000246 EBP: e5d63cdc ESP: e5d63cb0
[  337.670580] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010046
[  337.677358] CR0: 80050033 CR2: 00000041 CR3: 33db3000 CR4: 003406d0
[  337.683640] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  337.689897] DR6: fffe0ff0 DR7: 00000400
[  337.693728] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:49
[  337.703971] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid:
6931, name: modprobe
[  337.711962] INFO: lockdep is turned off.
[  337.715878] irq event stamp: 0
[  337.718930] hardirqs last  enabled at (0): [<00000000>] 0x0
[  337.724497] hardirqs last disabled at (0): [<ddeeddaa>]
copy_process+0x3ea/0x17d0
[  337.731974] softirqs last  enabled at (0): [<ddeeddaa>]
copy_process+0x3ea/0x17d0
[  337.739444] softirqs last disabled at (0): [<00000000>] 0x0
[  337.745010] CPU: 1 PID: 6931 Comm: modprobe Tainted: G      D W
    5.7.0-rc1 #1
[  337.752747] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  337.760218] Call Trace:
[  337.762675]  dump_stack+0x6e/0x96
[  337.765990]  ___might_sleep+0x14d/0x240
[  337.769822]  __might_sleep+0x33/0x80
[  337.773402]  exit_signals+0x2a/0x2d0
[  337.776980]  do_exit+0x8e/0xb40
[  337.780126]  rewind_stack_do_exit+0x11/0x13
[  337.784310] EIP: 0xb7f9dce1
[  337.787101] Code: 5e 5d c3 8d b6 00 00 00 00 b8 40 42 0f 00 eb c1
8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  337.805838] EAX: ffffffda EBX: 00000005 ECX: 0806233a EDX: 00000000
[  337.812097] ESI: 0977f840 EDI: 0977f480 EBP: 0977f700 ESP: bf9e017c
[  337.818354] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
<trim>
[  338.570731] BUG: kernel NULL pointer dereference, address: 00000041
[  338.577558] #PF: supervisor read access in kernel mode
[  338.582702] #PF: error_code(0x0000) - not-present page
[  338.587842] *pde = 00000000
[  338.590738] Oops: 0000 [#3] SMP
[  338.593894] CPU: 1 PID: 7032 Comm: ip Tainted: G      D W
5.7.0-rc1 #1
[  338.601119] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  338.608598] EIP: kmem_cache_alloc_trace+0x81/0x2b0
[  338.613389] Code: f5 01 00 00 89 75 e8 8b 07 64 8b 50 04 64 03 05
d8 32 3a df 8b 08 85 c9 89 4d f0 0f 84 b8 01 00 00 8b 75 f0 8b 47 14
8d 4a 01 <8b> 1c 06 89 f0 8b 37 64 0f c7 0e 75 d0 8b 75 e8 8b 47 14 0f
18 04
[  338.632133] EAX: 00000040 EBX: 00000dc0 ECX: 000017fb EDX: 000017fa
[  338.638391] ESI: 00000001 EDI: f5403680 EBP: f240def0 ESP: f240ded0
[  338.644649] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  338.651424] CR0: 80050033 CR2: 00000041 CR3: 25d76000 CR4: 003406d0
[  338.657683] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  338.663939] DR6: fffe0ff0 DR7: 00000400
[  338.667770] Call Trace:
[  338.670214]  ? alloc_mnt_ns+0x52/0x120
[  338.673959]  alloc_mnt_ns+0x52/0x120
[  338.677529]  copy_mnt_ns+0x49/0x2f0
[  338.681013]  ? kmem_cache_alloc+0x219/0x2c0
[  338.685190]  ? create_new_namespaces+0x29/0x290
[  338.689717]  create_new_namespaces+0x4f/0x290
[  338.694074]  unshare_nsproxy_namespaces+0x47/0xa0
[  338.698772]  ksys_unshare+0x19e/0x330
[  338.702429]  ? __might_fault+0x41/0x80
[  338.706174]  __ia32_sys_unshare+0xf/0x20
[  338.710097]  do_fast_syscall_32+0x7f/0x330
[  338.714191]  entry_SYSENTER_32+0xaa/0x102
[  338.718201] EIP: 0xb7f8fce1
[  338.720990] Code: 5e 5d c3 8d b6 00 00 00 00 b8 40 42 0f 00 eb c1
8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  338.739729] EAX: ffffffda EBX: 00020000 ECX: 40000000 EDX: 080e5000
[  338.745985] ESI: bf8fbc75 EDI: 00000005 EBP: bf8fae08 ESP: bf8f7bdc
[  338.752245] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[  338.759030] Modules linked in: test_bpf(+) test_printf(+) cls_bpf
sch_fq 8021q sch_ingress veth algif_hash x86_pkg_temp_thermal fuse
[last unloaded: test_blackhole_dev]
[  338.774049] CR2: 0000000000000041
[  338.777361] ---[ end trace 09f43fd7981266cb ]---
[  338.781978] EIP: ida_free+0x61/0x130
[  338.785550] Code: 00 c7 45 e8 00 00 00 00 c7 45 ec 00 00 00 00 0f
88 c4 00 00 00 89 d3 e8 0d 8e 87 00 89 c7 8d 45 d8 e8 93 1e 01 00 a8
01 75 3f <0f> a3 30 72 72 8b 45 d8 89 fa e8 e0 8f 87 00 53 68 08 ab fd
de e8
[  338.804285] EAX: 00000000 EBX: 00000000 ECX: e422d8c0 EDX: 00000000
[  338.810543] ESI: 00000000 EDI: 00000246 EBP: e5d63cdc ESP: e5d63cb0
[  338.816800] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010046
[  338.823579] CR0: 80050033 CR2: 00000041 CR3: 25d76000 CR4: 003406d0
[  338.829834] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  338.836091] DR6: fffe0ff0 DR7: 00000400
[  338.839922] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:49
[  338.850168] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid:
7032, name: ip
[  338.857647] INFO: lockdep is turned off.
[  338.861570] irq event stamp: 0
[  338.864623] hardirqs last  enabled at (0): [<00000000>] 0x0
[  338.870187] hardirqs last disabled at (0): [<ddeeddaa>]
copy_process+0x3ea/0x17d0
[  338.877657] softirqs last  enabled at (0): [<ddeeddaa>]
copy_process+0x3ea/0x17d0
[  338.885129] softirqs last disabled at (0): [<00000000>] 0x0
[  338.890700] CPU: 1 PID: 7032 Comm: ip Tainted: G      D W
5.7.0-rc1 #1
[  338.897911] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  338.905382] Call Trace:
[  338.907827]  dump_stack+0x6e/0x96
[  338.911146]  ___might_sleep+0x14d/0x240
[  338.914984]  __might_sleep+0x33/0x80
[  338.918557]  ? unshare_nsproxy_namespaces+0x47/0xa0
[  338.923435]  exit_signals+0x2a/0x2d0
[  338.927014]  do_exit+0x8e/0xb40
[  338.930150]  ? __ia32_sys_unshare+0xf/0x20
[  338.934244]  rewind_stack_do_exit+0x11/0x13
[  338.938425] EIP: 0xb7f8fce1
[  338.941218] Code: 5e 5d c3 8d b6 00 00 00 00 b8 40 42 0f 00 eb c1
8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  338.959955] EAX: ffffffda EBX: 00020000 ECX: 40000000 EDX: 080e5000
[  338.966211] ESI: bf8fbc75 EDI: 00000005 EBP: bf8fae08 ESP: bf8f7bdc
[  338.972469] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
<trim>
[  339.061988] BUG: kernel NULL pointer dereference, address: 00000041
[  339.068782] #PF: supervisor read access in kernel mode
[  339.073918] #PF: error_code(0x0000) - not-present page
[  339.079051] *pde = 00000000
[  339.081929] Oops: 0000 [#4] SMP
[  339.085075] CPU: 1 PID: 7064 Comm: ip Tainted: G      D W
5.7.0-rc1 #1
[  339.092284] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[  339.099756] EIP: __kmalloc+0xa2/0x310
[  339.103422] Code: 9c 01 00 00 89 75 e4 8b 07 64 8b 50 04 64 03 05
d8 32 3a df 8b 08 85 c9 89 4d f0 0f 84 07 02 00 00 8b 75 f0 8b 47 14
8d 4a 01 <8b> 1c 06 89 f0 8b 37 64 0f c7 0e 75 d0 8b 75 e4 8b 47 14 0f
18 04
[  339.122167] EAX: 00000040 EBX: 00000dc0 ECX: 000017fb EDX: 000017fa
[  339.128425] ESI: 00000001 EDI: f5403680 EBP: f394bf0c ESP: f394beec
[  339.134690] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  339.141467] CR0: 80050033 CR2: 00000041 CR3: 3305d000 CR4: 003406d0
[  339.147724] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  339.153982] DR6: fffe0ff0 DR7: 00000400
[  339.157811] Call Trace:
[  339.160257]  ? net_alloc_generic+0x1a/0x30
[  339.164356]  net_alloc_generic+0x1a/0x30
[  339.168272]  copy_net_ns+0x50/0x210
[  339.171758]  create_new_namespaces+0xf5/0x290
[  339.176117]  unshare_nsproxy_namespaces+0x47/0xa0
[  339.180824]  ksys_unshare+0x19e/0x330
[  339.184488]  ? __might_fault+0x41/0x80
[  339.188234]  __ia32_sys_unshare+0xf/0x20
[  339.192160]  do_fast_syscall_32+0x7f/0x330
[  339.196258]  entry_SYSENTER_32+0xaa/0x102
[  339.200261] EIP: 0xb7f61ce1
[  339.203051] Code: 5e 5d c3 8d b6 00 00 00 00 b8 40 42 0f 00 eb c1
8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  339.221790] EAX: ffffffda EBX: 40000000 ECX: 080a8b31 EDX: 00000000
[  339.228054] ESI: 00000001 EDI: bf8e9e70 EBP: bf8e7c00 ESP: bf8e7bbc
[  339.234313] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
[  339.241100] Modules linked in: test_bpf(+) test_printf(+) cls_bpf
sch_fq 8021q sch_ingress veth algif_hash x86_pkg_temp_thermal fuse
[last unloaded: test_blackhole_dev]
[  339.256116] CR2: 0000000000000041
[  339.259427] ---[ end trace 09f43fd7981266cc ]---
[  339.264040] EIP: ida_free+0x61/0x130
[  339.267618] Code: 00 c7 45 e8 00 00 00 00 c7 45 ec 00 00 00 00 0f
88 c4 00 00 00 89 d3 e8 0d 8e 87 00 89 c7 8d 45 d8 e8 93 1e 01 00 a8
01 75 3f <0f> a3 30 72 72 8b 45 d8 89 fa e8 e0 8f 87 00 53 68 08 ab fd
de e8
[  339.286363] EAX: 00000000 EBX: 00000000 ECX: e422d8c0 EDX: 00000000
[  339.292619] ESI: 00000000 EDI: 00000246 EBP: e5d63cdc ESP: e5d63cb0
[  339.298877] DS: 007b ES: 007b FS: 00d8 GS: 00e0 : 0068 EFLAGS: 00010046
[  339.305655] CR0: 80050033 CR2: 00000041 CR3: 3305d000 CR4: 003406d0
[  339.311913] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  339.318178] DR6: fffe0ff0 DR7: 00000400

Full test log,
https://lkft.validation.linaro.org/scheduler/job/1362555#L7962


metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-core2-32/lkft/linux-mainline/2611/config

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
