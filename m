Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C292A024F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 11:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgJ3KJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 06:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgJ3KJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 06:09:28 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B543C0613D5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 03:09:27 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id h12so3651273qtc.9
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 03:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HKjKG8xLf4hl4KGL08wOz97Uf/Uq5FWc5fG42s+qDsY=;
        b=TM5Bw6PAIXOz+nTtr9excRpuvtiVbOKmoM/ZeNWT5OhVP0dd5hqlhFOupj+2xCEgRN
         JeTxtgoWs+jeudgZ9IA8jtZiSnAw9Ipf8F4oNo4DhZotD2GG46YCALurZc48vpamdnDH
         bDAYZYY0UDMQ4U+tcY/twD+X67yMUxY6dRKbYjO+3b0g5XaelEVxkUzLkp1zB392AI2K
         2m1MttwmSo88t9aQ6aoIM2VaCRsaWaHkFa8ns2v0yZP3BySGZxcpF1apImCJxqUoZIbo
         UqwzELNBZTiNLFtr5GfmkHii7LfNU4pXAIlwrARUL93aTJZAiyuWQgCHMSlSVdrG3j69
         IX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKjKG8xLf4hl4KGL08wOz97Uf/Uq5FWc5fG42s+qDsY=;
        b=RL2H3lDibO2CrlQpoGK/+DZfe36qhonZwse/o2BCVO4Kg8nXZDlEy0lYM4oUAV+fED
         cmch8LiZQJkDsWzla9DgGhWodfWVT/fVxw7FqAX68Ppwm6kbpJgenvNZ7P/+GJJ7vGIv
         +Y3a9sgPzkncxfpELnPGWhS9RkNUNUjZQkBvBGUd+Fo+I4pSWAlZhOPiMMbLlTP5G+Kz
         2Kx3j1nFkGEiDYpL1Rh8bDXmKmH0Nrdf9Ep7qjtXbsOC0BZOddZ6L2QHn4I79KzR3HrX
         +nHJeAhC244msHGIa04cK42TrfgFBDIDE78Zj6TvCuxv2nKSgyieqz3cSzYwzpHZCpXH
         YKGQ==
X-Gm-Message-State: AOAM5327fH58KIFXBwqkIwFCy7KC5+0Mcj3Ro55uLYU7Iw5C53lErExK
        p5oQ2y2pSqCAyrBwX/8DizjFVxBrUQwegtfYwdDR9A==
X-Google-Smtp-Source: ABdhPJyT07TAhVCTLBh3geO1R4D7Y/mZhb7Bp9lH2jDEIbAYWD4tuFn+d8WZdEQUt+YDaRTSu12xKZ/EE1zqHUQncd8=
X-Received: by 2002:ac8:44ae:: with SMTP id a14mr1318678qto.67.1604052566546;
 Fri, 30 Oct 2020 03:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c82fe505aef233c6@google.com> <CAEf4BzbuUDEktVCYZAonUTM6iYBcAOPjKho2gMRD+9Q=N5cYxQ@mail.gmail.com>
In-Reply-To: <CAEf4BzbuUDEktVCYZAonUTM6iYBcAOPjKho2gMRD+9Q=N5cYxQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 30 Oct 2020 11:09:15 +0100
Message-ID: <CACT4Y+aCTgfd1DXQENpxpsC=9WmJcg7CvY+NcXZOCAF6t4Cp3Q@mail.gmail.com>
Subject: Re: WARNING in bpf_raw_tp_link_fill_link_info
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     syzbot <syzbot+976d5ecfab0c7eb43ac3@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 12:01 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Sep 10, 2020 at 2:31 AM syzbot
> <syzbot+976d5ecfab0c7eb43ac3@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    7fb5eefd selftests/bpf: Fix test_sysctl_loop{1, 2} failure..
> > git tree:       bpf-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1424fdb3900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=b6856d16f78d8fa9
> > dashboard link: https://syzkaller.appspot.com/bug?extid=976d5ecfab0c7eb43ac3
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a1f411900000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10929c11900000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+976d5ecfab0c7eb43ac3@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 6854 at include/linux/thread_info.h:150 check_copy_size include/linux/thread_info.h:150 [inline]
> > WARNING: CPU: 0 PID: 6854 at include/linux/thread_info.h:150 copy_to_user include/linux/uaccess.h:167 [inline]
> > WARNING: CPU: 0 PID: 6854 at include/linux/thread_info.h:150 bpf_raw_tp_link_fill_link_info+0x306/0x350 kernel/bpf/syscall.c:2661
> > Kernel panic - not syncing: panic_on_warn set ...
> > CPU: 0 PID: 6854 Comm: syz-executor574 Not tainted 5.9.0-rc1-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x18f/0x20d lib/dump_stack.c:118
> >  panic+0x2e3/0x75c kernel/panic.c:231
> >  __warn.cold+0x20/0x4a kernel/panic.c:600
> >  report_bug+0x1bd/0x210 lib/bug.c:198
> >  handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
> >  exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
> >  asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
> > RIP: 0010:check_copy_size include/linux/thread_info.h:150 [inline]
> > RIP: 0010:copy_to_user include/linux/uaccess.h:167 [inline]
> > RIP: 0010:bpf_raw_tp_link_fill_link_info+0x306/0x350 kernel/bpf/syscall.c:2661
> > Code: 41 bc ea ff ff ff e9 35 ff ff ff 4c 89 ff e8 41 66 33 00 e9 d0 fd ff ff 4c 89 ff e8 a4 66 33 00 e9 06 ff ff ff e8 ca ed f2 ff <0f> 0b eb 94 48 89 ef e8 2e 66 33 00 e9 65 fd ff ff e8 24 66 33 00
> > RSP: 0018:ffffc900051c7bd0 EFLAGS: 00010293
> > RAX: 0000000000000000 RBX: ffffc900051c7c60 RCX: ffffffff818179d6
> > RDX: ffff88808b490000 RSI: ffffffff81817a96 RDI: 0000000000000006
> > RBP: 0000000000000019 R08: 0000000000000000 R09: ffffc900051c7c7f
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000019
> > R13: 0000000000001265 R14: ffffffff8986ecc0 R15: ffffc900051c7c78
> >  bpf_link_get_info_by_fd kernel/bpf/syscall.c:3626 [inline]
> >  bpf_obj_get_info_by_fd+0x43a/0xc40 kernel/bpf/syscall.c:3664
> >  __do_sys_bpf+0x1906/0x4b30 kernel/bpf/syscall.c:4237
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > RIP: 0033:0x4405f9
> > Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007fff47155808 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> > RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004405f9
> > RDX: 0000000000000010 RSI: 00000000200000c0 RDI: 000000000000000f
> > RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
> > R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401e00
> > R13: 0000000000401e90 R14: 0000000000000000 R15: 0000000000000000
> > Kernel Offset: disabled
> > Rebooting in 86400 seconds..
> >
>
> #syz fix: b474959d5afd ("bpf: Fix a buffer out-of-bound access when
> filling raw_tp link_info")

Complete patch title:

#syz fix:
bpf: Fix a buffer out-of-bound access when filling raw_tp link_info
