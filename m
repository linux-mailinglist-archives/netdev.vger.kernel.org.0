Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ADF643BE2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 04:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiLFD2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 22:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiLFD2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 22:28:16 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F5A24F36;
        Mon,  5 Dec 2022 19:28:15 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so16809564pjp.1;
        Mon, 05 Dec 2022 19:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tSFBXsQz5kt69BB2/66rOZd+Kc+U9V6VbB9yZ0q0uPw=;
        b=fHhdCfxAz89x6uZ9ORXRFD5LBzYQKNiWpIGLL4/A1a1ClBbLGs/q0kSlbhpziQl82N
         gCSvKtIrBxqt6VrYbW6PpBahkUehWugn1qpNIczVgCcQK4soCPiCwPKey280gZEm1Uad
         iknAC5TAVJZlQyhaCpU3Z1NBJ6dGGMTpHgIbCnkQqDr28XOjfiJLkzvU1xE2zh2MadPD
         1qdM83CedGsvd6iidYsCnxtomQVVInYD5nb3XIuu+CIBmwOpxs0GJdFatK9009d//Thd
         VDak0DGsMmXYwD2agD5Y1ixtQvvAWbF4KJgPp3E0HkLJ6ExYxmaco2pQ/GvO4ZPI/3mQ
         Ha9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tSFBXsQz5kt69BB2/66rOZd+Kc+U9V6VbB9yZ0q0uPw=;
        b=T2JPwPOJ6GaIw0yv2fCtAQceKsani019E8q4fmrg+rHh+72D/q9xuu1U3ndylyfS2z
         +cUO6Ar0qgw3bFxhaIdcSF28oezD/lW36Kd7YQw5SJwPsb/ioNLyC2f9segb3DXud7xk
         1ro6L+zF+htgg24ryZW5n4aHmo3v3t6RlsUsUcbvZN2gMGezBOjxhDTeYrQQftpsAz0x
         eTDiXF0FtkIilpbhDydrA/W9BVdyfeBZh2jYiJjBz16ujKofW5YIa2AjXmb6Ch5mCAAn
         ZZHF02v0Q2E5i+T9edwGP5EnutPHFzjHVOm+1/9QEHRyel/pkRavmJZkaLhK6GbbMppk
         d0tA==
X-Gm-Message-State: ANoB5pkKFu2WG48GUUY+7dKL7jCeO8jBGg7/qHfqMry3rT2LDbvpO9If
        P4D2ylnYJk/tCz52ol/CVg97wwdxl49hsDqfGNHq6m/IRA==
X-Google-Smtp-Source: AA0mqf5wt9lTBk/Odwy+o9i6yDxX4NyK7Vx8uFEOvTbZ3nAnIK0tz2YBJ3NkjWe/QE3peABZdMdeZTuE46395iAqVYc=
X-Received: by 2002:a17:902:bb10:b0:189:6292:827e with SMTP id
 im16-20020a170902bb1000b001896292827emr55812042plb.97.1670297294708; Mon, 05
 Dec 2022 19:28:14 -0800 (PST)
MIME-Version: 1.0
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Tue, 6 Dec 2022 11:28:03 +0800
Message-ID: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
Subject: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following crash can be triggered with the BPF prog provided.
It seems the verifier passed some invalid progs. I will try to simplify
the C reproducer, for now, the following can reproduce this:

HEAD commit: ab0350c743d5 selftests/bpf: Fix conflicts with built-in
functions in bpf_iter_ksym
git tree: bpf-next
console log: https://pastebin.com/raw/87RCSnCs
kernel config: https://pastebin.com/raw/rZdWLcgK
Syz reproducer: https://pastebin.com/raw/4kbwhdEv
C reproducer: https://pastebin.com/raw/GFfDn2Gk

wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
BUG: unable to handle page fault for address: 000000000fe0840f
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 2ebe3067 P4D 2ebe3067 PUD 1dd9b067 PMD 0
Oops: 0002 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 7536 Comm: a.out Not tainted
6.1.0-rc7-01489-gab0350c743d5-dirty #118
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
1.16.1-1-1 04/01/2014
RIP: 0010:bpf_dispatcher_xdp+0x24/0x1000
Code: cc cc cc cc cc cc 48 81 fa e8 55 00 a0 0f 8f 63 00 00 00 48 81
fa d8 54 00 a0 7f 2a 48 81 fa 4c 53 00 a0 7f 11 48 81 fa 4c 53 <00> a0
0f 84 e0 0f 00 00 ff e2 66 90 48 81 fa d8 54 00 a0 0f 84 5b
RSP: 0018:ffffc900029df908 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc900028b9000 RCX: 0000000000000000
RDX: ffffffffa000534c RSI: ffffc900028b9048 RDI: ffffc900029dfb70
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000001 R14: ffffc900028b9030 R15: ffffc900029dfb50
FS:  00007ff249efc700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000fe0840f CR3: 000000002e0ba000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? __bpf_prog_run include/linux/filter.h:600 [inline]
 ? bpf_prog_run_xdp include/linux/filter.h:775 [inline]
 ? bpf_test_run+0x2ce/0x990 net/bpf/test_run.c:400
 ? bpf_test_timer_continue+0x3d0/0x3d0 net/bpf/test_run.c:79
 ? bpf_dispatcher_xdp+0x800/0x1000
 ? bpf_dispatcher_xdp+0x800/0x1000
 ? bpf_dispatcher_xdp+0x800/0x1000
 ? _copy_from_user+0x5f/0x180 lib/usercopy.c:21
 ? bpf_test_init.isra.0+0x111/0x150 net/bpf/test_run.c:772
 ? bpf_prog_test_run_xdp+0xbde/0x1400 net/bpf/test_run.c:1389
 ? bpf_prog_test_run_skb+0x1dd0/0x1dd0 include/linux/skbuff.h:2594
 ? rcu_lock_release include/linux/rcupdate.h:321 [inline]
 ? rcu_read_unlock include/linux/rcupdate.h:783 [inline]
 ? __fget_files+0x283/0x3e0 fs/file.c:914
 ? fput+0x30/0x1a0 fs/file_table.c:371
 ? ____bpf_prog_get kernel/bpf/syscall.c:2206 [inline]
 ? __bpf_prog_get+0x9a/0x2e0 kernel/bpf/syscall.c:2270
 ? bpf_prog_test_run_skb+0x1dd0/0x1dd0 include/linux/skbuff.h:2594
 ? bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
 ? __sys_bpf+0x1293/0x5840 kernel/bpf/syscall.c:4997
 ? futex_wait_setup+0x230/0x230 kernel/futex/waitwake.c:625
 ? bpf_perf_link_attach+0x520/0x520 kernel/bpf/syscall.c:2720
 ? instrument_atomic_read include/linux/instrumented.h:72 [inline]
 ? atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 ? queued_spin_is_locked include/asm-generic/qspinlock.h:57 [inline]
 ? debug_spin_unlock kernel/locking/spinlock_debug.c:100 [inline]
 ? do_raw_spin_unlock+0x53/0x230 kernel/locking/spinlock_debug.c:140
 ? futex_wake+0x15b/0x4a0 kernel/futex/waitwake.c:161
 ? do_futex+0x130/0x350 kernel/futex/syscalls.c:122
 ? __ia32_sys_get_robust_list+0x3b0/0x3b0 kernel/futex/syscalls.c:72
 ? __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
 ? __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
 ? __x64_sys_bpf+0x78/0xc0 kernel/bpf/syscall.c:5081
 ? syscall_enter_from_user_mode+0x26/0xb0 kernel/entry/common.c:111
 ? do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 ? do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
 ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>
Modules linked in:
Dumping ftrace buffer:
   (ftrace buffer empty)
CR2: 000000000fe0840f
---[ end trace 0000000000000000 ]---
RIP: 0010:bpf_dispatcher_xdp+0x24/0x1000
Code: cc cc cc cc cc cc 48 81 fa e8 55 00 a0 0f 8f 63 00 00 00 48 81
fa d8 54 00 a0 7f 2a 48 81 fa 4c 53 00 a0 7f 11 48 81 fa 4c 53 <00> a0
0f 84 e0 0f 00 00 ff e2 66 90 48 81 fa d8 54 00 a0 0f 84 5b
RSP: 0018:ffffc900029df908 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc900028b9000 RCX: 0000000000000000
RDX: ffffffffa000534c RSI: ffffc900028b9048 RDI: ffffc900029dfb70
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000001 R14: ffffc900028b9030 R15: ffffc900029dfb50
FS:  00007ff249efc700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000fe0840f CR3: 000000002e0ba000 CR4: 0000000000750ef0
PKRU: 55555554
