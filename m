Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3D7C1C5D
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 09:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfI3HxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 03:53:02 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40006 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfI3HxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 03:53:01 -0400
Received: by mail-ot1-f67.google.com with SMTP id y39so7481882ota.7;
        Mon, 30 Sep 2019 00:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3e3QqLu/jia2qbnMtLkmoAcFP2xoXlNnz1hMB8EyJXA=;
        b=Qpr2ZNNIGre+/PA/AjXwm5lYpr0+dA+Qzv6pxORfrBHwOXM061iUzszbP4knO2XUYO
         eSxZMOqBtJHoEdQGFTCnCCbvzlVjzQHfw+DWRzl7mAE5lLf8EL9XfHjCw8xBp17IVTSe
         S1xwA+VdeNYqVkM7uQObppPnHD5Yi9KcNKaqOWSdXgMXSf9CSGOb5Vyrc5ORnYCZ1YkH
         rusAhx5nsZyZNjtMOqjMIUhJn0cIuGsIES3hr4awNhX3fLMxJl+wPtApcmvXldn6cWwX
         1zGkWfp1n2jJVx9mtHBW1lmbP1taRQiWd/9fo7vyn4CGi9NBVxjgS34PWMP76bnoq9GJ
         /Mwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3e3QqLu/jia2qbnMtLkmoAcFP2xoXlNnz1hMB8EyJXA=;
        b=bJk71XhDAqT40oRVfRuk4AOm8jlqCBVthXVam8AIjDHuij0q9O9Zi0kPLRiXNlxrR8
         pSF1M3zmrMjnS17zfIG+3+nJKYTbGp290DTHWL/4CuMdWAqi4q8ZvyBDzxanQbqPJTFp
         9zrUaLWjWnaXEjEMhsRgP/YbOvi/DZSTmf/wfzY6udiPc8DdE25ULoE6g3KWwVSOsI2d
         SrFrQa0i5ifLfm2pEAEd3uvO+2uhWgO4Qj11MlRC/3rcrkNLDKv20CERCzZlyLW/vj8o
         1VzD8LwKHFMje67PMRBEaFHWTsT2MMA8CP2lqzz5mWnR/HHGyUSvvObXsxCCIzZlhl36
         TsGA==
X-Gm-Message-State: APjAAAWqx6XRs/dcu2FY0put7Ge0lLtTrSGW+1iBoCWclroDtpwmNMO7
        HEDFdcF2M5DfhwTe5UqUfVrpVU0N7rCJOI9zVTU=
X-Google-Smtp-Source: APXvYqwJkciI3RP23y2G8dRh3HMk+rcZON/vcsnRtgr5mWDd+Njl5slYFv2RsowLKSAXR9N0qqZ7DR24R9MpyrkDwXM=
X-Received: by 2002:a05:6830:156:: with SMTP id j22mr13415041otp.196.1569829980268;
 Mon, 30 Sep 2019 00:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000084fb070593bff0fb@google.com>
In-Reply-To: <00000000000084fb070593bff0fb@google.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 30 Sep 2019 09:52:49 +0200
Message-ID: <CAJ8uoz0cX-wo8=MVMJVhwVdH3V7NO79EZNHaoNyCT6x018eABA@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in xsk_poll
To:     syzbot <syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, hawk@kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        linux-kernel@vger.kernel.org,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 9:17 AM syzbot
<syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:

Thank you Mr Syzcaller. I am on it.

/Magnus

> HEAD commit:    a3c0e7b1 Merge tag 'libnvdimm-fixes-5.4-rc1' of git://git...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14f05435600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6ffbfa7e4a36190f
> dashboard link: https://syzkaller.appspot.com/bug?extid=a5765ed8cdb1cca4d249
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1096d835600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129f15f3600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a5765ed8cdb1cca4d249@syzkaller.appspotmail.com
>
> IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
> 8021q: adding VLAN 0 to HW filter on device batadv0
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD 99226067 P4D 99226067 PUD 8fa47067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 8719 Comm: syz-executor502 Not tainted 5.3.0+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:0x0
> Code: Bad RIP value.
> RSP: 0018:ffff88809dd4f848 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88808c06d740 RCX: 1ffff1101180db7c
> RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88809a190b00
> RBP: ffff88809dd4f880 R08: ffff8880921924c0 R09: ffffed101180db31
> R10: ffffed101180db30 R11: ffff88808c06d987 R12: 0000000000000002
> R13: 0000000000000304 R14: ffff88809a190b00 R15: 0000000000000000
> FS:  0000000001b27880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000a307a000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   xsk_poll+0x1e7/0x5a0 net/xdp/xsk.c:430
>   sock_poll+0x15e/0x480 net/socket.c:1256
>   vfs_poll include/linux/poll.h:90 [inline]
>   do_pollfd fs/select.c:859 [inline]
>   do_poll fs/select.c:907 [inline]
>   do_sys_poll+0x63c/0xdd0 fs/select.c:1001
>   __do_sys_ppoll fs/select.c:1101 [inline]
>   __se_sys_ppoll fs/select.c:1081 [inline]
>   __x64_sys_ppoll+0x259/0x310 fs/select.c:1081
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x441bd9
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffd48824e98 EFLAGS: 00000246 ORIG_RAX: 000000000000010f
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441bd9
> RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000020000040
> RBP: 00007ffd48824eb0 R08: 0000000000000000 R09: 0000000001bbbbbb
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000403170 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace e262cafe88422aec ]---
> RIP: 0010:0x0
> Code: Bad RIP value.
> RSP: 0018:ffff88809dd4f848 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88808c06d740 RCX: 1ffff1101180db7c
> RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88809a190b00
> RBP: ffff88809dd4f880 R08: ffff8880921924c0 R09: ffffed101180db31
> R10: ffffed101180db30 R11: ffff88808c06d987 R12: 0000000000000002
> R13: 0000000000000304 R14: ffff88809a190b00 R15: 0000000000000000
> FS:  0000000001b27880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 00000000a307a000 CR4: 00000000001406f0
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
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
