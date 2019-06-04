Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0FE34908
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbfFDNjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:39:10 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:56063 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbfFDNjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:39:09 -0400
Received: by mail-it1-f193.google.com with SMTP id i21so118843ita.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0WXKUmTeUweiz7SeHm408/knTOSg6CffX96W9GMM7rU=;
        b=XytfCuMILvLVI45yAPNZX96DXz4ti9+BE4oM0Muu3+GREgDyZyDTxk4FhVgvYjIBfP
         7qzvTa7TWbI5E6s9AG6I2URL+X4C24YhlYfkgqW/Cfyn0Sg8WuAIJXcWsX92OPHR3avq
         UmCFv3nHwVg56SzVRbutp8EawbqREPdrl8q70fwpfni4QkCmdsQpRp23dkr/Vpwrq/EH
         8LroSVjFm74k9DI9PMj94TPyyLFFCjyJ0025t0zwXnGje9W8QMKy4dxm9FbOTUFIhAkE
         CTSBEMwjs1+ZLPh/7Xx7ZuKKAa7QGxE5OrcPUVhzmdm0uMw5bZOKQSSMufelj8t5meIq
         JINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0WXKUmTeUweiz7SeHm408/knTOSg6CffX96W9GMM7rU=;
        b=alZP14C0Qc1ZSFe9k2fVrQMxbnXXbk+o6+XK8IAcmim/xPVx4s4nz0bJsU4mqeQGjS
         e/y0Jjy1rx7jYm9wNKKLn12VWxl0YHj+fYbSX6L97jmX5XegNaZhgzLxvJihEipfWJvF
         kLS0NRJ+pmknsbTFlbf6s/0BYAMVeC2KADLCO2pygK4ZtX1wBVN45Zodc89CjvstHV5M
         w8FS4r3BmKDErrK81AS31ttCqP684By1Jaf8Lso9pCmj8XQ2BlMjEGQR5BlrMQoqKQfE
         fHlygRY0P5L+tCvULd6k312FzwzsbxsECwvz4SShWsxrZR9ksk+gSMwppFUFPhcmeGBu
         5PKg==
X-Gm-Message-State: APjAAAXQXwIdMC7hUqhipW65RGvOTmsiSgLnhqzLfM64Hg+aDlEnWvGn
        K5XLpt1WaMOm2ELD1g72k4O6jQXOPOPZTA5F2XIqBA==
X-Google-Smtp-Source: APXvYqzcwYyc0wSdFsD3NvylL2MCFhat2V6f6NqZ3xFCR7HfDXDzQtYsTU7r7vcS4r2QiPzp+dQE9gTEJRqFhoSC2lQ=
X-Received: by 2002:a24:9083:: with SMTP id x125mr14800222itd.76.1559655548187;
 Tue, 04 Jun 2019 06:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f122ab058a303d94@google.com> <CADvbK_evGyJZaUQZa6U26tJSQCNW4jb3uqLWGQGF_7HJgv-Sog@mail.gmail.com>
In-Reply-To: <CADvbK_evGyJZaUQZa6U26tJSQCNW4jb3uqLWGQGF_7HJgv-Sog@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 4 Jun 2019 15:38:55 +0200
Message-ID: <CACT4Y+aGjg_JTL-OPMSi1wS4=Zy4xFAizWW5fa8_KMOFpfMeXg@mail.gmail.com>
Subject: Re: memory leak in sctp_stream_init_ext
To:     Xin Long <lucien.xin@gmail.com>
Cc:     syzbot <syzbot+7f3b6b106be8dcdcdeec@syzkaller.appspotmail.com>,
        davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 3:37 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Fri, May 31, 2019 at 10:59 PM syzbot
> <syzbot+7f3b6b106be8dcdcdeec@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    bec7550c Merge tag 'docs-5.2-fixes2' of git://git.lwn.net/..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=152a0916a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=64479170dcaf0e11
> > dashboard link: https://syzkaller.appspot.com/bug?extid=7f3b6b106be8dcdcdeec
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1142cd4ca00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f81d72a00000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+7f3b6b106be8dcdcdeec@syzkaller.appspotmail.com
> >
> > executing program
> > executing program
> > executing program
> > executing program
> > executing program
> > BUG: memory leak
> > unreferenced object 0xffff8881114f5d80 (size 96):
> >    comm "syz-executor934", pid 7160, jiffies 4294993058 (age 31.950s)
> >    hex dump (first 32 bytes):
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >    backtrace:
> >      [<00000000ce7a1326>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:55 [inline]
> >      [<00000000ce7a1326>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >      [<00000000ce7a1326>] slab_alloc mm/slab.c:3326 [inline]
> >      [<00000000ce7a1326>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
> >      [<000000007abb7ac9>] kmalloc include/linux/slab.h:547 [inline]
> >      [<000000007abb7ac9>] kzalloc include/linux/slab.h:742 [inline]
> >      [<000000007abb7ac9>] sctp_stream_init_ext+0x2b/0xa0
> > net/sctp/stream.c:157
> >      [<0000000048ecb9c1>] sctp_sendmsg_to_asoc+0x946/0xa00
> > net/sctp/socket.c:1882
>
> is this possible to be a false positive?

https://goo.gl/tpsmEJ#memory-leaks

> As in my testing, I tracked the objects allocated by
> "sctp_sendmsg_to_asoc () -> sctp_stream_init_ext()."
> all of them got freed properly in sctp_stream_free(),
> while this warning was still triggered.
>
> >      [<000000004483ca2b>] sctp_sendmsg+0x2a8/0x990 net/sctp/socket.c:2102
> >      [<0000000094bdc32e>] inet_sendmsg+0x64/0x120 net/ipv4/af_inet.c:802
> >      [<0000000022d1c2a5>] sock_sendmsg_nosec net/socket.c:652 [inline]
> >      [<0000000022d1c2a5>] sock_sendmsg+0x54/0x70 net/socket.c:671
> >      [<000000006ab53119>] sock_write_iter+0xb6/0x130 net/socket.c:1000
> >      [<00000000973772ef>] call_write_iter include/linux/fs.h:1872 [inline]
> >      [<00000000973772ef>] new_sync_write+0x1ad/0x260 fs/read_write.c:483
> >      [<0000000033f2491b>] __vfs_write+0x87/0xa0 fs/read_write.c:496
> >      [<00000000372fbd56>] vfs_write fs/read_write.c:558 [inline]
> >      [<00000000372fbd56>] vfs_write+0xee/0x210 fs/read_write.c:542
> >      [<000000007ccb2ea5>] ksys_write+0x7c/0x130 fs/read_write.c:611
> >      [<000000001c29b8c7>] __do_sys_write fs/read_write.c:623 [inline]
> >      [<000000001c29b8c7>] __se_sys_write fs/read_write.c:620 [inline]
> >      [<000000001c29b8c7>] __x64_sys_write+0x1e/0x30 fs/read_write.c:620
> >      [<0000000014d9243b>] do_syscall_64+0x76/0x1a0
> > arch/x86/entry/common.c:301
> >      [<0000000059f6e9a8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > BUG: memory leak
> > unreferenced object 0xffff8881114f5d80 (size 96):
> >    comm "syz-executor934", pid 7160, jiffies 4294993058 (age 33.160s)
> >    hex dump (first 32 bytes):
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >    backtrace:
> >      [<00000000ce7a1326>] kmemleak_alloc_recursive
> > include/linux/kmemleak.h:55 [inline]
> >      [<00000000ce7a1326>] slab_post_alloc_hook mm/slab.h:439 [inline]
> >      [<00000000ce7a1326>] slab_alloc mm/slab.c:3326 [inline]
> >      [<00000000ce7a1326>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
> >      [<000000007abb7ac9>] kmalloc include/linux/slab.h:547 [inline]
> >      [<000000007abb7ac9>] kzalloc include/linux/slab.h:742 [inline]
> >      [<000000007abb7ac9>] sctp_stream_init_ext+0x2b/0xa0
> > net/sctp/stream.c:157
> >      [<0000000048ecb9c1>] sctp_sendmsg_to_asoc+0x946/0xa00
> > net/sctp/socket.c:1882
> >      [<000000004483ca2b>] sctp_sendmsg+0x2a8/0x990 net/sctp/socket.c:2102
> >      [<0000000094bdc32e>] inet_sendmsg+0x64/0x120 net/ipv4/af_inet.c:802
> >      [<0000000022d1c2a5>] sock_sendmsg_nosec net/socket.c:652 [inline]
> >      [<0000000022d1c2a5>] sock_sendmsg+0x54/0x70 net/socket.c:671
> >      [<000000006ab53119>] sock_write_iter+0xb6/0x130 net/socket.c:1000
> >      [<00000000973772ef>] call_write_iter include/linux/fs.h:1872 [inline]
> >      [<00000000973772ef>] new_sync_write+0x1ad/0x260 fs/read_write.c:483
> >      [<0000000033f2491b>] __vfs_write+0x87/0xa0 fs/read_write.c:496
> >      [<00000000372fbd56>] vfs_write fs/read_write.c:558 [inline]
> >      [<00000000372fbd56>] vfs_write+0xee/0x210 fs/read_write.c:542
> >      [<000000007ccb2ea5>] ksys_write+0x7c/0x130 fs/read_write.c:611
> >      [<000000001c29b8c7>] __do_sys_write fs/read_write.c:623 [inline]
> >      [<000000001c29b8c7>] __se_sys_write fs/read_write.c:620 [inline]
> >      [<000000001c29b8c7>] __x64_sys_write+0x1e/0x30 fs/read_write.c:620
> >      [<0000000014d9243b>] do_syscall_64+0x76/0x1a0
> > arch/x86/entry/common.c:301
> >      [<0000000059f6e9a8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > executing program
> > executing program
> > executing program
> > executing program
> > executing program
> > executing program
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CADvbK_evGyJZaUQZa6U26tJSQCNW4jb3uqLWGQGF_7HJgv-Sog%40mail.gmail.com.
> For more options, visit https://groups.google.com/d/optout.
