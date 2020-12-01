Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB292CAE65
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgLAVar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgLAVar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:30:47 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26D7C0613CF;
        Tue,  1 Dec 2020 13:30:06 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id t22so5649461ljk.0;
        Tue, 01 Dec 2020 13:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GMEsoYlC7PiNCFGAkFeSpfOnTPS5rlzJQecbyfXlbKw=;
        b=B7Ef7HQUGkWavNlzi6UOzn83OsvhKdp3eR998TQs8frOdRMDMfnG7+5bx2pzh69gr9
         q/M2l3U/u+Mpl9Xr0m6SnHNnmSn6i0evvykEORM5u47VCUyAFnjHZmzKXFo1M0+wRZz3
         kWXOv6Kmt8ra0dmkc+IvZJeMhXAGVNcn9lG6lNRxB85TZ+U7sDOYnG4vnq6MNvFF6lHu
         qy/PV9/5iqIVHeyL7HfxWgDkJWUBRTw5lyL2/9+Y6SPNrShv5YnPqoahsA8yrErCghS7
         BoNiIoap3VAQnRaH+lAsCKa7YCmQYJzzTylHE2CG+zz6ImG/CP3oRr63vXT6iMJF499I
         sSAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GMEsoYlC7PiNCFGAkFeSpfOnTPS5rlzJQecbyfXlbKw=;
        b=AVrgJDBAmCBx/l2ydArQ87boeM90DgovbbI+XAsmAlCc/PN0o4EZZ9RMfxt7oLH2O4
         kCcQv7XW4I2bJl76GTQ0p6ARczjHRNGrLkkVs+WHFE0DWLMvBBKVcbwvz39C2MbowTwY
         WZBbtvadeCl6LsJS/cOvNQgqMRHxnovr/gwJOEjARtokmqQj+zBoxz47mbMHz/PCJbtd
         4rcEYx0nS/DrIGXGPhkU/5TQ58uOs9C8AGDvERd1CEerLLmiQZmK6ElS7y0GBm1b7Ny1
         NRfeBcMoMQywZNPCdsI/HIqXkVv312ddq4CuE83aJsoZQkg/q97/qDRWfrn1oXiXK00I
         yeKg==
X-Gm-Message-State: AOAM533OnS1YCMHXbATlfqxpkpIsBgLe9LoRvoJllwTnZglUvfRjukX+
        BAapqkefC6MLvnmpVQw+ja7bxUVjJERssC8lbcw=
X-Google-Smtp-Source: ABdhPJxxC5g3IA2VjePVTXedGqoH9L0rS2z/CtU+pNl1zB+Hsk82YrYsTuk6dMjDtAYwBDBLQ/DoPXw/0tulq2x02AI=
X-Received: by 2002:a2e:9086:: with SMTP id l6mr2154888ljg.91.1606858205184;
 Tue, 01 Dec 2020 13:30:05 -0800 (PST)
MIME-Version: 1.0
References: <20201201034709.2918694-1-andrii@kernel.org>
In-Reply-To: <20201201034709.2918694-1-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 1 Dec 2020 13:29:53 -0800
Message-ID: <CAADnVQLCrXZtrHKCZgLpDvy1F-Q1gubJuhiiHs6a1Z5ZPM9CwQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/7] libbpf: add support for kernel module BTF
 CO-RE relocations
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 7:49 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Implement libbpf support for performing CO-RE relocations against types in
> kernel module BTFs, in addition to existing vmlinux BTF support.
>
> This is a first step towards fully supporting kernel module BTFs. Subsequent
> patch sets will expand kernel and libbpf sides to allow using other
> BTF-powered capabilities (fentry/fexit, struct_ops, ksym externs, etc). For
> CO-RE relocations support, though, no extra kernel changes are necessary.
>
> This patch set also sets up a convenient and fully-controlled custom kernel
> module (called "bpf_testmod"), that is a predictable playground for all the
> BPF selftests, that rely on module BTFs.
>
> v2->v3:
>   - fix subtle uninitialized variable use in BTF ID iteration code;

While testing this patch I've hit this:
#111 test_bpffs:OK
[  222.418122] 9pnet_virtio: no channels available for device hostshare0
[  222.688972] sysfs: cannot create duplicate filename '/kernel/btf/bpf_preload'
[  222.689811] CPU: 0 PID: 2485 Comm: modprobe Tainted: G           O
    5.10.0-rc3-00874-gfe521960f79f #3078
[  222.690813] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.0-2.el7 04/01/2014
[  222.691681] Call Trace:
[  222.691937]  dump_stack+0x9a/0xcc
[  222.692303]  sysfs_warn_dup.cold+0x17/0x24
[  222.692714]  sysfs_add_file_mode_ns+0x38c/0x560
[  222.693200]  sysfs_create_bin_file+0xf8/0x150
[  222.693635]  ? sysfs_add_file_to_group+0x150/0x150
[  222.694140]  ? __kasan_kmalloc.constprop.0+0xc2/0xd0
[  222.694648]  btf_module_notify+0x6ac/0xd30
[  222.695111]  notifier_call_chain_robust+0xa6/0x1a0
[  222.695658]  blocking_notifier_call_chain_robust+0x61/0x90
[  222.696251]  load_module+0x62da/0x9f40
[  222.696627]  ? rcu_read_lock_sched_held+0x81/0xb0
[  222.697156]  ? module_frob_arch_sections+0x20/0x20
[  222.697632]  ? ima_read_file+0x140/0x140
[  222.698027]  ? security_kernel_post_read_file+0x68/0xb0
[  222.698643]  ? __do_sys_finit_module+0xf7/0x150
[  222.699126]  __do_sys_finit_module+0xf7/0x150
[  222.699588]  ? __ia32_sys_init_module+0xa0/0xa0
[  222.700049]  ? bpf_prog_32007c34f7726d29_bpf_prog1+0x198/0x7ec
[  222.700690]  ? rcu_read_lock_bh_held+0x90/0x90
[  222.701161]  ? __bpf_trace_sys_enter+0x4f/0x60
[  222.701601]  ? syscall_trace_enter.isra.0+0x174/0x230
[  222.702123]  do_syscall_64+0x2d/0x40
[  222.702483]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  222.703002] RIP: 0033:0x7fd909d727f9
[  222.703385] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 57 76 2b 00 f7 d8 64 89
01 48
[  222.705258] RSP: 002b:00007ffeecdb8e28 EFLAGS: 00000206 ORIG_RAX:
0000000000000139
[  222.706010] RAX: ffffffffffffffda RBX: 0000000000625380 RCX: 00007fd909d727f9
[  222.706778] RDX: 0000000000000000 RSI: 000000000041a213 RDI: 0000000000000000
[  222.707522] RBP: 000000000041a213 R08: 0000000000000000 R09: 00000000006242a0
[  222.708241] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
[  222.708932] R13: 0000000000625530 R14: 0000000000040000 R15: 0000000000625380
[  222.709715] failed to register module [bpf_preload] BTF in sysfs: -17
[  222.892778] sysfs: cannot create duplicate filename '/kernel/btf/bpf_testmod'
[  222.893609] CPU: 2 PID: 2493 Comm: test_progs Tainted: G
O      5.10.0-rc3-00874-gfe521960f79f #3078
[  222.894622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.0-2.el7 04/01/2014
[  222.895498] Call Trace:
[  222.895768]  dump_stack+0x9a/0xcc
[  222.896128]  sysfs_warn_dup.cold+0x17/0x24
[  222.896573]  sysfs_add_file_mode_ns+0x38c/0x560
[  222.897047]  sysfs_create_bin_file+0xf8/0x150
[  222.897506]  ? sysfs_add_file_to_group+0x150/0x150
[  222.898004]  ? __kasan_kmalloc.constprop.0+0xc2/0xd0
[  222.898524]  btf_module_notify+0x6ac/0xd30
[  222.898968]  notifier_call_chain_robust+0xa6/0x1a0
[  222.899477]  blocking_notifier_call_chain_robust+0x61/0x90
[  222.900040]  load_module+0x62da/0x9f40
[  222.900434]  ? rcu_read_lock_sched_held+0x81/0xb0
[  222.900951]  ? module_frob_arch_sections+0x20/0x20
[  222.901474]  ? ima_read_file+0x140/0x140
[  222.901881]  ? security_kernel_post_read_file+0x68/0xb0
[  222.902450]  ? __do_sys_finit_module+0xf7/0x150
[  222.902937]  __do_sys_finit_module+0xf7/0x150
[  222.903401]  ? __ia32_sys_init_module+0xa0/0xa0
[  222.903867]  ? bpf_prog_32007c34f7726d29_bpf_prog1+0x198/0x7ec
[  222.904480]  ? rcu_read_lock_bh_held+0x90/0x90
[  222.904935]  ? __bpf_trace_sys_enter+0x4f/0x60
[  222.905401]  ? syscall_trace_enter.isra.0+0x174/0x230
[  222.905925]  do_syscall_64+0x2d/0x40
[  222.906304]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  222.906818] RIP: 0033:0x7fd58327e7f9
[  222.907193] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40
00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 57 76 2b 00 f7 d8 64 89
01 48
[  222.909049] RSP: 002b:00007ffce1e96fe8 EFLAGS: 00000246 ORIG_RAX:
0000000000000139
[  222.909823] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fd58327e7f9
[  222.910541] RDX: 0000000000000000 RSI: 000000000165481f RDI: 0000000000000004
[  222.911260] RBP: 0000000000000004 R08: 00007ffce1e97230 R09: 0000000000000000
[  222.911995] R10: 0000000000002011 R11: 0000000000000246 R12: 0000000000000000
[  222.912710] R13: 00007ffce1e97230 R14: 0000000000000000 R15: 0000000000000000
[  222.913503] failed to register module [bpf_testmod] BTF in sysfs: -17
