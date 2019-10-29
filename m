Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B66E8371
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729892AbfJ2Inl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:43:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41959 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfJ2Ink (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:43:40 -0400
Received: by mail-qt1-f195.google.com with SMTP id o3so19021419qtj.8
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 01:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0g0Du9V18B2BnmtJffPeGYHtvEvcAUktxDamj7mndFo=;
        b=us4L92V3Z4UYWYUJ7x1tpnVXNVtA2nzgjn/k6T1nG/SoaSKxFfTQlv+cpmrN3x5HSr
         pnPNQPgUAsHFJVCcOchugJHN2IYQXym+2a0m7tx8vxenKbh+jAS+qMEvRWNeCkPyi1At
         66xyZhwBJmcWY9BJ9heJBA0zXX+pIAwIOx5tddir6IYv5xTSKhV6WDJFMZjFOYc15IZz
         m4/FE2n4+2F0eIUnXsTdgJCLuOw+VJyUmt39nUm17DIgouodQFzQzCDofoApRsXqZom9
         fZkplqve45Bf8msi5yuna4CMlESi7AD4gUcLzVwlwbsQRWu7A3F3Ec+IY4x31w+rUOp0
         /B/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0g0Du9V18B2BnmtJffPeGYHtvEvcAUktxDamj7mndFo=;
        b=sUvg0UR12s7pHj24oj5PoZJUtsR2+ldB4lJKf4Xh1kBItHVW3lX1+w43QQWJyVKXri
         57vkheXJ8PU42q+PelTyN/bVJUWo5biuvQb+W/faShq31xTUjAZqA37TkBm1gnmTkp3p
         KuBboXrenAzujksoLu+WHdHnmdNk+pjJYUEnDtJiGch6QxKXKWZJjJsnwopEdDN/CHgG
         F7Y6OKgDo3h0kMDtpmCEnkyCVBJckKT6X1RfnOoIlzUoeO1QjCNDcx2eNEFXX8Pmrbgw
         LaohpnSY+PqjoxFm0/YoDwf260zf6dmxJTy5A4P1aon+fSv1ObSN6tyXPUXtlH/rquZS
         P4Yg==
X-Gm-Message-State: APjAAAW6Nq8ev3GjHEJw6qXWGNnNX2cmDC0PpNHAs41mY4/vM8h/eOJn
        vLPv8atjj0tZy4r+WU7DERljcaN2bK7ZNkYSywS9pg==
X-Google-Smtp-Source: APXvYqxWtaShvBkXUUtJ4gV4H+4npCzmDtdqeW7XEhS+VvViHq0rflpvDI7ePk6xFinPfR7j4gy2WAcOi42wSLYJ0UM=
X-Received: by 2002:ac8:3a06:: with SMTP id w6mr3026957qte.380.1572338618873;
 Tue, 29 Oct 2019 01:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000001c46d5059608892f@google.com>
In-Reply-To: <0000000000001c46d5059608892f@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 29 Oct 2019 09:43:27 +0100
Message-ID: <CACT4Y+b7nkRO_Q6X3sTWbGU5Y6bGuZPmKzoPL2uoFpA4KCP2hw@mail.gmail.com>
Subject: Re: general protection fault in process_one_work
To:     syzbot <syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 9:38 AM syzbot
<syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    38207291 bpf: Prepare btf_ctx_access for non raw_tp use c=
ase
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D14173c0f60000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D41648156aa09b=
e10
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D9ed8f68ab30761f=
3678e
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com

+Ji=C5=99=C3=AD P=C3=ADrko, this seems to be related to netdevsim.

> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 9149 Comm: kworker/1:3 Not tainted 5.4.0-rc1+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: events nsim_dev_trap_report_work
> RIP: 0010:nsim_dev_trap_report_work+0xc4/0xaf0
> drivers/net/netdevsim/dev.c:409
> Code: 89 45 d0 0f 84 8b 07 00 00 49 bc 00 00 00 00 00 fc ff df e8 3e ae e=
f
> fc 48 8b 45 d0 48 05 68 01 00 00 48 89 45 90 48 c1 e8 03 <42> 80 3c 20 00
> 0f 85 b1 09 00 00 48 8b 45 d0 48 8b 98 68 01 00 00
> RSP: 0018:ffff88806c98fc90 EFLAGS: 00010a06
> RAX: 1bd5a0000000004d RBX: 0000000000000000 RCX: ffffffff84836e22
> RDX: 0000000000000000 RSI: ffffffff84836db2 RDI: 0000000000000001
> RBP: ffff88806c98fd30 R08: ffff88806c9863c0 R09: ffffed100d75f3d9
> R10: ffffed100d75f3d8 R11: ffff88806baf9ec7 R12: dffffc0000000000
> R13: ffff88806baf9ec0 R14: ffff8880a9a13900 R15: ffff8880ae934500
> FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007efdd0c9e000 CR3: 000000009cc1b000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
>   worker_thread+0x98/0xe40 kernel/workqueue.c:2415
>   kthread+0x361/0x430 kernel/kthread.c:255
>   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> Modules linked in:
> ---[ end trace ba29cd1c27f63d86 ]---
> RIP: 0010:nsim_dev_trap_report_work+0xc4/0xaf0
> drivers/net/netdevsim/dev.c:409
> Code: 89 45 d0 0f 84 8b 07 00 00 49 bc 00 00 00 00 00 fc ff df e8 3e ae e=
f
> fc 48 8b 45 d0 48 05 68 01 00 00 48 89 45 90 48 c1 e8 03 <42> 80 3c 20 00
> 0f 85 b1 09 00 00 48 8b 45 d0 48 8b 98 68 01 00 00
> RSP: 0018:ffff88806c98fc90 EFLAGS: 00010a06
> RAX: 1bd5a0000000004d RBX: 0000000000000000 RCX: ffffffff84836e22
> RDX: 0000000000000000 RSI: ffffffff84836db2 RDI: 0000000000000001
> RBP: ffff88806c98fd30 R08: ffff88806c9863c0 R09: ffffed100d75f3d9
> R10: ffffed100d75f3d8 R11: ffff88806baf9ec7 R12: dffffc0000000000
> R13: ffff88806baf9ec0 R14: ffff8880a9a13900 R15: ffff8880ae934500
> FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007efdd0c9e000 CR3: 000000009cc1b000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgi=
d/syzkaller-bugs/0000000000001c46d5059608892f%40google.com.
