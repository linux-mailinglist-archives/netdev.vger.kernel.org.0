Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946A4182932
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388022AbgCLGgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:36:25 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43494 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387786AbgCLGgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:36:24 -0400
Received: by mail-qv1-f68.google.com with SMTP id c28so2070412qvb.10
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 23:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OmYhfalyPE2n7mUASlF7MytGTjb9PigptAh2TuJXUpE=;
        b=F/tU8uxWlaEQwmS15OIZ8t9f/bwi+O0RYAClH6Ya3V9ThM9Fj7t0kPUQkf2DeIl79K
         5sTtCv85iaJZjF3C/gxxrDXU3PePY92Yd4v0piau45HmHGxBxQD0/OqkMcHregAXs3Gq
         74qgsVqO2G5zPcFbdbeqEKr5ujFRJaC/iWLXF4mcrcUK6iJT27uPVb5Ay+VRQG6Y0EOL
         WjNGE4prK/b5mfm7bPHHF1oZv3ZJyNwrPkJpwFrYxENTIYDCB5+G7iiHZ6VfZCW/+gRL
         RJhy2kHe9kP7C5QHffVntMz4To84/SsOpqGp/QpcFOmHn+12K2wmvlKIrUlyFNGJtqSe
         n9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OmYhfalyPE2n7mUASlF7MytGTjb9PigptAh2TuJXUpE=;
        b=Jd70GrTQeNMQfjIcVF3whyAq42mQXy/RTjKctlxLwxZCKyQue/YC3CKzXXDfhKJBbU
         UjyIiUXbmIPUajaQDJsjkujKk2QFusxCGMe0KzL8rAHM15ni8CsHyGsTywlW3LGdzlp+
         /OaqgSVwHwJDNZfBQ8AVvhlrCOZvzvvVvG5KqwddCiQG3Fg1J3QvvM4vyq11e7W/ffWQ
         Go0W1gTw4cDgKEHq4RUYW2EtI2Eyzb64B1WQCtim23BESBF68sU4WgJZBYBp5R6DpfkG
         fldRR4l9Htuk9eSQORbFGAgaEK5arvQVXlr50jGW70eUoAUZIM2lmTHz0OD8nOMPM+DW
         hGgw==
X-Gm-Message-State: ANhLgQ25PfQhF6zPEkTeWQMMwnpeDDpxVKdpPuH7/yJNNVrGGtYjAyVr
        VPr/NmG3adPVoc15CW1Be8d+0RfL5GWQK2IjrwPbOA==
X-Google-Smtp-Source: ADFU+vsiQ62PSVs7mnY7zbIq11G9sXjPw2OuaTBdc/4A/m4kB/gNXR64wwn9XGYT7pXUFc+eGf70egHroht4FWcQTuU=
X-Received: by 2002:a05:6214:11e6:: with SMTP id e6mr5755991qvu.22.1583994982157;
 Wed, 11 Mar 2020 23:36:22 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e8001905a07be9de@google.com> <20200311200400.a383230a33722d4c3a6886dd@linux-foundation.org>
In-Reply-To: <20200311200400.a383230a33722d4c3a6886dd@linux-foundation.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 12 Mar 2020 07:36:10 +0100
Message-ID: <CACT4Y+aSGNcnkW+zu5Fexe7j7E3GnM81YH_+mC_Hp_ToC0+RhA@mail.gmail.com>
Subject: Re: general protection fault in list_lru_del
To:     Andrew Morton <akpm@linux-foundation.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     syzbot <syzbot+34c3a8c021ca80c808b0@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 4:04 AM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 10 Mar 2020 01:29:09 -0700 syzbot <syzbot+34c3a8c021ca80c808b0@syzkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following crash on:
>
> Might be vfs, more likely networking, might be something else.  Cc's
> added.

My bet would be on RDS, +RDS maintainers as well.

> > HEAD commit:    63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1492da55e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
> > dashboard link: https://syzkaller.appspot.com/bug?extid=34c3a8c021ca80c808b0
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+34c3a8c021ca80c808b0@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> > CPU: 1 PID: 11205 Comm: kworker/u4:4 Not tainted 5.6.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue: krdsd rds_tcp_accept_worker
> > RIP: 0010:__list_del_entry_valid+0x85/0xf5 lib/list_debug.c:51
> > Code: 0f 84 e1 00 00 00 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 e2 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 53 49 8b 14 24 4c 39 f2 0f 85 99 00 00 00 49 8d 7d
> > RSP: 0018:ffffc90001b27af0 EFLAGS: 00010246
> > RAX: dffffc0000000000 RBX: ffff888020040c60 RCX: ffffffff81a1dda6
> > RDX: 0000000000000000 RSI: ffffffff81a1dba1 RDI: ffff888020040c68
> > RBP: ffffc90001b27b08 R08: ffff88809f18e280 R09: fffff52000364f51
> > R10: fffff52000364f50 R11: 0000000000000003 R12: 0000000000000000
> > R13: 0000000000000000 R14: ffff888020040c60 R15: ffff888020040c68
> > FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f78a44de000 CR3: 000000008c993000 CR4: 00000000001426e0
> > DR0: 0000000000000000 DR1: 0000000000006920 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  __list_del_entry include/linux/list.h:132 [inline]
> >  list_del_init include/linux/list.h:204 [inline]
> >  list_lru_del+0x11d/0x620 mm/list_lru.c:158
> >  inode_lru_list_del fs/inode.c:450 [inline]
> >  iput_final fs/inode.c:1568 [inline]
> >  iput+0x52c/0x900 fs/inode.c:1597
> >  __sock_release+0x20e/0x280 net/socket.c:617
> >  sock_release+0x18/0x20 net/socket.c:625
> >  rds_tcp_accept_one+0x5a9/0xc00 net/rds/tcp_listen.c:251
> >  rds_tcp_accept_worker+0x56/0x80 net/rds/tcp.c:525
> >  process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
> >  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
> >  kthread+0x361/0x430 kernel/kthread.c:255
> >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Modules linked in:
> > ---[ end trace 424f0561ef9bfe17 ]---
> > RIP: 0010:__list_del_entry_valid+0x85/0xf5 lib/list_debug.c:51
> > Code: 0f 84 e1 00 00 00 48 b8 22 01 00 00 00 00 ad de 49 39 c4 0f 84 e2 00 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 <80> 3c 02 00 75 53 49 8b 14 24 4c 39 f2 0f 85 99 00 00 00 49 8d 7d
> > RSP: 0018:ffffc90001b27af0 EFLAGS: 00010246
> > RAX: dffffc0000000000 RBX: ffff888020040c60 RCX: ffffffff81a1dda6
> > RDX: 0000000000000000 RSI: ffffffff81a1dba1 RDI: ffff888020040c68
> > RBP: ffffc90001b27b08 R08: ffff88809f18e280 R09: fffff52000364f51
> > R10: fffff52000364f50 R11: 0000000000000003 R12: 0000000000000000
> > R13: 0000000000000000 R14: ffff888020040c60 R15: ffff888020040c68
> > FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f78a44de000 CR3: 000000008c993000 CR4: 00000000001426e0
> > DR0: 0000000000000000 DR1: 0000000000006920 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
