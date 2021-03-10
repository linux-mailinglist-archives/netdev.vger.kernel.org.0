Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC9333473B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhCJSyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbhCJSyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 13:54:07 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11E9C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 10:54:07 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id d11so13820522qtx.9
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 10:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vLXAkAskiQcQ1LGOy8c4iMFazBShIBbsgNpMAGpqQ4c=;
        b=ZuSIP/eNepj/rQzXVsX2ED06gVSKBiUOIYtuJZqyh6bBg/meWNhS3uDaqTxOhhOfp1
         bu0ZN+1Y0NhncPI+mdAV92Z5lxeHf1uXQD4umfdqGUX9RYpKA58TSR+3HZvjjn8dXigB
         B4vSKM1L7AojEUrjbKVX6KL0MBAqQ+uUpw/v1Cj/Nx//AMeFWuBOl7QLr54lmmuOujyd
         qBSaxOUE0W+vcWp3K2qFFaoyn4hZjSNsVMf0x0IVXKUPhklrcUHAUlQdrAIl7Vx8WjRO
         bq3bKqGL18LWzf4ANxQ4VljxaTw2rPzWEGjFgQaIiweVTc/iCHuC+nDSNJayJILLX/NN
         P1TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vLXAkAskiQcQ1LGOy8c4iMFazBShIBbsgNpMAGpqQ4c=;
        b=MQJGFphkWcycIBm8IwLQjpmbKh6VpYWeKeAkkoSqUVjHHB/7lkQ17k/a1iZqKXT0/8
         nby4sftWn34/3HE+7QYnuY9Cl5e67TMbyCS8Jj1dB4sjWo0GShBZXrBik1We6kDKm57v
         2MUdl+T364XNNHI1FXg2h7A+kPcN4fZWoUw7OIkHkdEq2Erd6B0UWxNOl65RCUaYGLge
         1YFV5jO4Gad7e4Csd4s2jpCaiIfYPl96/XfD6zWvuDEryQzczN5EaRNWpgVBmOtuxztH
         CgVngQ5lnPmNzq94u03jvzycOmdsS5C4o3E7zBzUQsuEp2mh8DR+SP0SlFTuMa6okvRY
         bp/w==
X-Gm-Message-State: AOAM533R+GuES5aqNzZBlIefLW55NwV21eB6cJ6aW2tLa9HWJaSOkxnt
        +9SX2ll0e7Uyt047Gotc42NqYCZ/vnYdalNYQ1+S8w==
X-Google-Smtp-Source: ABdhPJyM9qnpbKqhCRB40B0yeUnOBOcSPvPcrAs7e98U0YztJpyjwaEfa6Bmu6KrOPIe04vN06dWWBKZgCJLhO+r/tY=
X-Received: by 2002:ac8:5847:: with SMTP id h7mr3945605qth.43.1615402446649;
 Wed, 10 Mar 2021 10:54:06 -0800 (PST)
MIME-Version: 1.0
References: <00000000000096cdaa05bd32d46f@google.com>
In-Reply-To: <00000000000096cdaa05bd32d46f@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 10 Mar 2021 19:53:55 +0100
Message-ID: <CACT4Y+ZjdOaX_X530p+vPbG4mbtUuFsJ1v-gD24T4DnFUqcudA@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel access to user memory in sock_ioctl
To:     syzbot <syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv <linux-riscv@lists.infradead.org>
Cc:     andrii@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 7:28 PM syzbot
<syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0d7588ab riscv: process: Fix no prototype for arch_dup_tas..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
> console output: https://syzkaller.appspot.com/x/log.txt?x=122c343ad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e3c595255fb2d136
> dashboard link: https://syzkaller.appspot.com/bug?extid=c23c5421600e9b454849
> userspace arch: riscv64
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c23c5421600e9b454849@syzkaller.appspotmail.com

+riscv maintainers

Another case of put_user crashing.

> Unable to handle kernel access to user memory without uaccess routines at virtual address 0000000020000300
> Oops [#1]
> Modules linked in:
> CPU: 1 PID: 4488 Comm: syz-executor.0 Not tainted 5.12.0-rc2-syzkaller-00467-g0d7588ab9ef9 #0
> Hardware name: riscv-virtio,qemu (DT)
> epc : sock_ioctl+0x424/0x6ac net/socket.c:1124
>  ra : sock_ioctl+0x424/0x6ac net/socket.c:1124
> epc : ffffffe002aeeb3e ra : ffffffe002aeeb3e sp : ffffffe023867da0
>  gp : ffffffe005d25378 tp : ffffffe007e116c0 t0 : 0000000000000000
>  t1 : 0000000000000001 t2 : 0000003fb8035e44 s0 : ffffffe023867e30
>  s1 : 0000000000040000 a0 : 0000000000000000 a1 : 0000000000000007
>  a2 : 1ffffffc00fc22d8 a3 : ffffffe003bc1d02 a4 : 0000000000000000
>  a5 : 0000000000000000 a6 : 0000000000f00000 a7 : ffffffe000082eba
>  s2 : 0000000000000000 s3 : 0000000000008902 s4 : 0000000020000300
>  s5 : ffffffe005d2b0d0 s6 : ffffffe010facfc0 s7 : ffffffe008e00000
>  s8 : 0000000000008903 s9 : ffffffe010fad080 s10: 0000000000000000
>  s11: 0000000000020000 t3 : 982de389919f6300 t4 : ffffffc401175688
>  t5 : ffffffc401175691 t6 : 0000000000000007
> status: 0000000000000120 badaddr: 0000000020000300 cause: 000000000000000f
> Call Trace:
> [<ffffffe002aeeb3e>] sock_ioctl+0x424/0x6ac net/socket.c:1124
> [<ffffffe0003fdb6a>] vfs_ioctl fs/ioctl.c:48 [inline]
> [<ffffffe0003fdb6a>] __do_sys_ioctl fs/ioctl.c:753 [inline]
> [<ffffffe0003fdb6a>] sys_ioctl+0x5c2/0xd56 fs/ioctl.c:739
> [<ffffffe000005562>] ret_from_syscall+0x0/0x2
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> ---[ end trace a5f91e70f37b907b ]---
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/00000000000096cdaa05bd32d46f%40google.com.
