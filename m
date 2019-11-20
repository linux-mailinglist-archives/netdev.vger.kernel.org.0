Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13411103971
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfKTMDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:03:19 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727192AbfKTMDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:03:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574251397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPLrgLaGuZaJcH9r1bYOExIf6a7HxnQs/VX4R6E/rqg=;
        b=DJgbtQCElSggYt2CzlQ9OiB/VFRNX05/VKWVT9kRsJVJ9gfxpGbTzBx3Qw2bu2VyCMRZkR
        4QXubxpDzvmVgKJfAliqbU08dF7i1M3ZzOLSSvcz0jshtHDJNidW2S1YtLf9Qu2lYGC9bh
        9fAeJ9bBLu02QbhgBN8CTEXCMDy9fvs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-B-GvTKtLMX-PV0YHBgAb4A-1; Wed, 20 Nov 2019 07:03:16 -0500
Received: by mail-wm1-f70.google.com with SMTP id o25so645227wmh.8
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 04:03:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FOyJ5t3F1d+Ww8VG/GvZOln/dLXZzdutGh+ZvZUhBto=;
        b=Ga6exLTaIB+jr9lJMK2FNtGGVMP4eFXVnTlRHeqEKOAJg7SfATrXPKYH3nL/yNdn0H
         xSV6+F6IAf3yg8l+1PuxAnamquYocvAsExRiWRuXvqO/sNUqWALyZ2/zd8klLmVwwTyV
         sTZK76BUci+IcnfN1yqrVOomf0PVhzqLs2P3+eqm8Ln30rTCnt8kre5LjhH4/iPMJhN7
         ZpVVxkxdOHAHPlD0/ArQwUnrNpEtbJDdtlnjPU6y5TcvApNjlFFiZ9gMNRRjLuKr/USn
         3eDHDnd5YmNUYvamOP1ftBnvfSTfEWFeznTC+szHvco7YW1xyX7dV+ET3Ete+XgxrJtJ
         yhkQ==
X-Gm-Message-State: APjAAAVCyDiBf/lECayELl1Nfws6Z0cZrdA6zeJ9A1xdCsxf3kh1qIdr
        pywFbWJlVf+I9GBoOVyk5/GrHgMsChjGwJG5DoGqTgrvHXvUrF888dVAHxf7r5hUYa1JCgDgDHT
        EUwtfUso3iCcCCx50
X-Received: by 2002:a5d:570a:: with SMTP id a10mr2756217wrv.107.1574251394216;
        Wed, 20 Nov 2019 04:03:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqz33Aj8kvQESisy7rMEIOYNw9KoxhpUBoSDqC6m1YCd6Hc66GXIFyZ9wQ8otMuTjyRfxiTwIg==
X-Received: by 2002:a5d:570a:: with SMTP id a10mr2756131wrv.107.1574251393545;
        Wed, 20 Nov 2019 04:03:13 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id 65sm35828136wrs.9.2019.11.20.04.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 04:03:12 -0800 (PST)
Date:   Wed, 20 Nov 2019 13:03:10 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     syzbot <syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        "David S. Miller" <davem@davemloft.net>, idosch@mellanox.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com, kafai@fb.com,
        kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        syzkaller-bugs@googlegroups.com, vadimp@mellanox.com,
        virtualization@lists.linux-foundation.org, yhs@fb.com
Subject: Re: general protection fault in virtio_transport_release
Message-ID: <CAGxU2F7qYQAFJ957bLxKGQrHApxomGQXbaFMDVc7r0bWv_M2Zw@mail.gmail.com>
References: <0000000000004ce83f0597b24bba@google.com>
MIME-Version: 1.0
In-Reply-To: <0000000000004ce83f0597b24bba@google.com>
X-MC-Unique: B-GvTKtLMX-PV0YHBgAb4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 1:35 PM syzbot <syzbot+e2e5c07bf353b2f79daa@syzkall=
er.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    1e8795b1 mscc.c: fix semicolon.cocci warnings
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D15d77406e0000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3De855e9c92c947=
4fe
> dashboard link: https://syzkaller.appspot.com/bug?extid=3De2e5c07bf353b2f=
79daa
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1537f46ae00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D11359c6ae0000=
0
>
> The bug was bisected to:
>
> commit f366cd2a2e510b155e18b21a2d149332aa08eb61
> Author: Vadim Pasternak <vadimp@mellanox.com>
> Date:   Mon Oct 21 10:30:30 2019 +0000
>
>      mlxsw: reg: Add macro for getting QSFP module EEPROM page number
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D148945aae0=
0000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=3D168945aae0=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D128945aae0000=
0
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit=
:
> Reported-by: syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com
> Fixes: f366cd2a2e51 ("mlxsw: reg: Add macro for getting QSFP module EEPRO=
M
> page number")

I'm working on this issue.

I think the problem is related to
ac03046ece2b "vsock/virtio: free packets during the socket release"

I'll send a patch ASAP.

Thanks,
Stefano

>
> RDX: 0000000000000010 RSI: 00000000200000c0 RDI: 0000000000000004
> RBP: 0000000000000005 R08: 0000000000000001 R09: 00007ffd5b250031
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401e00
> R13: 0000000000401e90 R14: 0000000000000000 R15: 0000000000000000
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 8862 Comm: syz-executor079 Not tainted 5.4.0-rc6+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:virtio_transport_release+0x13b/0xcb0
> net/vmw_vsock/virtio_transport_common.c:826
> Code: e8 aa e6 2b fa 66 41 83 fd 01 0f 84 34 02 00 00 e8 3a e5 2b fa 48 8=
b
> 95 30 ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f
> 85 22 0a 00 00 48 8b bb 98 00 00 00 48 b8 00 00 00
> RSP: 0018:ffff888092dbfaf0 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87474aa0
> RDX: 0000000000000013 RSI: ffffffff874747d6 RDI: 0000000000000001
> RBP: ffff888092dbfc00 R08: ffff88809245a380 R09: fffffbfff1555fe1
> R10: fffffbfff1555fe0 R11: 0000000000000003 R12: ffff888092dbfbd8
> R13: 0000000000000007 R14: 0000000000000007 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200000c4 CR3: 0000000008e6d000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   __vsock_release+0x80/0x2d0 net/vmw_vsock/af_vsock.c:733
>   vsock_release+0x35/0xa0 net/vmw_vsock/af_vsock.c:806
>   __sock_release+0xce/0x280 net/socket.c:590
>   sock_close+0x1e/0x30 net/socket.c:1268
>   __fput+0x2ff/0x890 fs/file_table.c:280
>   ____fput+0x16/0x20 fs/file_table.c:313
>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>   exit_task_work include/linux/task_work.h:22 [inline]
>   do_exit+0x904/0x2e60 kernel/exit.c:817
>   do_group_exit+0x135/0x360 kernel/exit.c:921
>   __do_sys_exit_group kernel/exit.c:932 [inline]
>   __se_sys_exit_group kernel/exit.c:930 [inline]
>   __x64_sys_exit_group+0x44/0x50 kernel/exit.c:930
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x43f1d8
> Code: Bad RIP value.
> RSP: 002b:00007ffd5b25f838 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043f1d8
> RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
> RBP: 00000000004befa8 R08: 00000000000000e7 R09: ffffffffffffffd0
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 4b9b883ea3ab661f ]---
> RIP: 0010:virtio_transport_release+0x13b/0xcb0
> net/vmw_vsock/virtio_transport_common.c:826
> Code: e8 aa e6 2b fa 66 41 83 fd 01 0f 84 34 02 00 00 e8 3a e5 2b fa 48 8=
b
> 95 30 ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f
> 85 22 0a 00 00 48 8b bb 98 00 00 00 48 b8 00 00 00
> RSP: 0018:ffff888092dbfaf0 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87474aa0
> RDX: 0000000000000013 RSI: ffffffff874747d6 RDI: 0000000000000001
> RBP: ffff888092dbfc00 R08: ffff88809245a380 R09: fffffbfff1555fe1
> R10: fffffbfff1555fe0 R11: 0000000000000003 R12: ffff888092dbfbd8
> R13: 0000000000000007 R14: 0000000000000007 R15: 0000000000000000
> FS:  00000000009db880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000043f1ae CR3: 0000000008e6d000 CR4: 00000000001406f0
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
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>

