Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2EF643D47
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 07:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbiLFGrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 01:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiLFGq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 01:46:57 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815E321E3E;
        Mon,  5 Dec 2022 22:46:55 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 21so13686222pfw.4;
        Mon, 05 Dec 2022 22:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yc9LquVMnmUlyJv08o6ohM1bOO793lGhS39y0qki6yw=;
        b=lv7u0qd99DE6beopwiYlll/RAGkiHjxwzOtQZSIaus87Wm3d7rS/yqz8IRzVkt6bCm
         LCB1/TvDXGfhedb81TOQnSXSOkKl+1Dhe/xmDhk9sKQEDxFmbmoIabEG69UAk6KBJeTb
         gmYI5qTIy2UPFrWhhnwt1xcmR3a/01941J4oLkrCXyt8z+lDo4dejBstY4TochV+NR4J
         AhTz0+C8bXh2FfTvApBnBCYsTw8OfzFrU3RLfV+OE2iJSBNk93sFbObAyMYVoKFADnlA
         cfw0W9kESwz4MyBwAX2pqvP1KSjiiOsdswo3NriJtAxnwGVc13Wd1tDHO7HnG2pbEhT5
         sPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yc9LquVMnmUlyJv08o6ohM1bOO793lGhS39y0qki6yw=;
        b=0GNmYsLuL9emUoH0B9EYcNmpK+REYjCO/W88QVv8LD5+nBKVtcoF2io1CJoANHDD7D
         6KUX3J5mc++5O0C14xNtQ1cbn3wSfQn+FcMkwPFcxnbXHK4iOWUm460XZlpI370p+rQ9
         i0oevcwBZ7XZuKFPM9+w93AxGji14/J7F/qdk7VI062dPeoY+GelgQQMBg+JxsJ+rMWk
         9HnWw+cwgNCnpVmvq6DHkVg7OX4PtYfsYJONl3Yzn8b7QbmKSTSOh9pcCboHbxGrx3rH
         8huU/Et/HA5ZWIfw/lM8E2fNyo5TzImocRMneAtj9Gwqcivc6e4Do5RUAD3CeQWS9v7L
         THIQ==
X-Gm-Message-State: ANoB5plK8+/znkyUf2oCO5PY/TMv9zwZb01frYO2BT0x9LvtRdth7saf
        1TF4epQ36xkwap6zQQzDVMxJaTfeArHl9Ri7xCm7nrsMWg==
X-Google-Smtp-Source: AA0mqf6ne6mMhw170Myl24RIUGU+Jd/FKILKJoX3W1kLw4cp5iD4p3awUf81rQc93rIErbAd6X2bRCBonFmqaaqNEaA=
X-Received: by 2002:a63:6ce:0:b0:478:99ce:9f2b with SMTP id
 197-20020a6306ce000000b0047899ce9f2bmr12826906pgg.203.1670309214566; Mon, 05
 Dec 2022 22:46:54 -0800 (PST)
MIME-Version: 1.0
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
In-Reply-To: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
From:   Hao Sun <sunhao.th@gmail.com>
Date:   Tue, 6 Dec 2022 14:46:43 +0800
Message-ID: <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hao Sun <sunhao.th@gmail.com> =E4=BA=8E2022=E5=B9=B412=E6=9C=886=E6=97=A5=
=E5=91=A8=E4=BA=8C 11:28=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> The following crash can be triggered with the BPF prog provided.
> It seems the verifier passed some invalid progs. I will try to simplify
> the C reproducer, for now, the following can reproduce this:
>
> HEAD commit: ab0350c743d5 selftests/bpf: Fix conflicts with built-in
> functions in bpf_iter_ksym
> git tree: bpf-next
> console log: https://pastebin.com/raw/87RCSnCs
> kernel config: https://pastebin.com/raw/rZdWLcgK
> Syz reproducer: https://pastebin.com/raw/4kbwhdEv
> C reproducer: https://pastebin.com/raw/GFfDn2Gk
>

Simplified C reproducer: https://pastebin.com/raw/aZgLcPvW

Only two syscalls are required to reproduce this, seems it's an issue
in XDP test run. Essentially, the reproducer just loads a very simple
prog and tests run repeatedly and concurrently:

r0 =3D bpf$PROG_LOAD(0x5, &(0x7f0000000640)=3D@base=3D{0x6, 0xb,
&(0x7f0000000500)}, 0x80)
bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000140)=3D{r0, 0x0, 0x0, 0x0, 0x0,
0x0, 0xffffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x48)

Loaded prog:
   0: (18) r0 =3D 0x0
   2: (18) r6 =3D 0x0
   4: (18) r7 =3D 0x0
   6: (18) r8 =3D 0x0
   8: (18) r9 =3D 0x0
  10: (95) exit

> wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
> IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
> wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
> IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> BUG: unable to handle page fault for address: 000000000fe0840f
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 2ebe3067 P4D 2ebe3067 PUD 1dd9b067 PMD 0
> Oops: 0002 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 7536 Comm: a.out Not tainted
> 6.1.0-rc7-01489-gab0350c743d5-dirty #118
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
> 1.16.1-1-1 04/01/2014
> RIP: 0010:bpf_dispatcher_xdp+0x24/0x1000
> Code: cc cc cc cc cc cc 48 81 fa e8 55 00 a0 0f 8f 63 00 00 00 48 81
> fa d8 54 00 a0 7f 2a 48 81 fa 4c 53 00 a0 7f 11 48 81 fa 4c 53 <00> a0
> 0f 84 e0 0f 00 00 ff e2 66 90 48 81 fa d8 54 00 a0 0f 84 5b
> RSP: 0018:ffffc900029df908 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc900028b9000 RCX: 0000000000000000
> RDX: ffffffffa000534c RSI: ffffc900028b9048 RDI: ffffc900029dfb70
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
> R13: 0000000000000001 R14: ffffc900028b9030 R15: ffffc900029dfb50
> FS:  00007ff249efc700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000fe0840f CR3: 000000002e0ba000 CR4: 0000000000750ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  ? __bpf_prog_run include/linux/filter.h:600 [inline]
>  ? bpf_prog_run_xdp include/linux/filter.h:775 [inline]
>  ? bpf_test_run+0x2ce/0x990 net/bpf/test_run.c:400
>  ? bpf_test_timer_continue+0x3d0/0x3d0 net/bpf/test_run.c:79
>  ? bpf_dispatcher_xdp+0x800/0x1000
>  ? bpf_dispatcher_xdp+0x800/0x1000
>  ? bpf_dispatcher_xdp+0x800/0x1000
>  ? _copy_from_user+0x5f/0x180 lib/usercopy.c:21
>  ? bpf_test_init.isra.0+0x111/0x150 net/bpf/test_run.c:772
>  ? bpf_prog_test_run_xdp+0xbde/0x1400 net/bpf/test_run.c:1389
>  ? bpf_prog_test_run_skb+0x1dd0/0x1dd0 include/linux/skbuff.h:2594
>  ? rcu_lock_release include/linux/rcupdate.h:321 [inline]
>  ? rcu_read_unlock include/linux/rcupdate.h:783 [inline]
>  ? __fget_files+0x283/0x3e0 fs/file.c:914
>  ? fput+0x30/0x1a0 fs/file_table.c:371
>  ? ____bpf_prog_get kernel/bpf/syscall.c:2206 [inline]
>  ? __bpf_prog_get+0x9a/0x2e0 kernel/bpf/syscall.c:2270
>  ? bpf_prog_test_run_skb+0x1dd0/0x1dd0 include/linux/skbuff.h:2594
>  ? bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
>  ? __sys_bpf+0x1293/0x5840 kernel/bpf/syscall.c:4997
>  ? futex_wait_setup+0x230/0x230 kernel/futex/waitwake.c:625
>  ? bpf_perf_link_attach+0x520/0x520 kernel/bpf/syscall.c:2720
>  ? instrument_atomic_read include/linux/instrumented.h:72 [inline]
>  ? atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
>  ? queued_spin_is_locked include/asm-generic/qspinlock.h:57 [inline]
>  ? debug_spin_unlock kernel/locking/spinlock_debug.c:100 [inline]
>  ? do_raw_spin_unlock+0x53/0x230 kernel/locking/spinlock_debug.c:140
>  ? futex_wake+0x15b/0x4a0 kernel/futex/waitwake.c:161
>  ? do_futex+0x130/0x350 kernel/futex/syscalls.c:122
>  ? __ia32_sys_get_robust_list+0x3b0/0x3b0 kernel/futex/syscalls.c:72
>  ? __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
>  ? __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
>  ? __x64_sys_bpf+0x78/0xc0 kernel/bpf/syscall.c:5081
>  ? syscall_enter_from_user_mode+0x26/0xb0 kernel/entry/common.c:111
>  ? do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  ? do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
>  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  </TASK>
> Modules linked in:
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> CR2: 000000000fe0840f
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bpf_dispatcher_xdp+0x24/0x1000
> Code: cc cc cc cc cc cc 48 81 fa e8 55 00 a0 0f 8f 63 00 00 00 48 81
> fa d8 54 00 a0 7f 2a 48 81 fa 4c 53 00 a0 7f 11 48 81 fa 4c 53 <00> a0
> 0f 84 e0 0f 00 00 ff e2 66 90 48 81 fa d8 54 00 a0 0f 84 5b
> RSP: 0018:ffffc900029df908 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc900028b9000 RCX: 0000000000000000
> RDX: ffffffffa000534c RSI: ffffc900028b9048 RDI: ffffc900029dfb70
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
> R13: 0000000000000001 R14: ffffc900028b9030 R15: ffffc900029dfb50
> FS:  00007ff249efc700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000fe0840f CR3: 000000002e0ba000 CR4: 0000000000750ef0
> PKRU: 55555554
