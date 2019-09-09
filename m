Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50667AE0FB
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfIIWXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:23:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41184 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfIIWXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 18:23:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so10180043pfo.8;
        Mon, 09 Sep 2019 15:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vOphhoNfzWMZzHDOQQuW1poFUNZeqDatd/w1IZj/GC0=;
        b=RPdPTPGTTgo/F2lL5g119C+u+A3sDeld1Dd7b37Y4edSImc5bnLW26HBC49uVCnTer
         yvattJF9PUsn9wtfQCuQ7Tt7zKXH6EtORE/Q+WIw7AeGtu/tiRo7+TcELEHkfKhrVhfe
         1eNX6cPTjuSFRcMIJPfALR0NjZ2lQF1hR77x7I9qKSmTrAX+1qB09HlvJ/b/FV91GFlq
         gkelEUgTNQmwF4fRq8+WWAGdBWn9Sz5GZFSEspqEFh8jPBN3/DGgRwMKxOaX2rvLqRhI
         0ufIcZtcbOEcg13dMZ9WHVoLZNCFcR0bn9X0pVIVakpJ+l2xnTYLLYhgXLOj05ZCJlE/
         PHSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vOphhoNfzWMZzHDOQQuW1poFUNZeqDatd/w1IZj/GC0=;
        b=et01wz3lk+K6bclb5nEOG5t1kQ2gf7Xy8d9Cr3x8Qw8UegGwKoHkdVUBMwM2Hon/Np
         qtkLfgzc78v+FdlwE+Wl7fOnG1AiJta78VhERukRivyTnGeJAx0YHM8oIZADtuam6R32
         yOfaLuMvywy2+LP5gJHR9MZYoW1gMkXI5OHWRM8LLMzX117UcnFTFfnEmLZC+tUAPpHk
         jyNwxNnaqj0NW87E0WSbeVU/zKztIh1KJ8wa78stBdI5aGqX+/AC5vvfb1PMuJhluVYB
         yK3cndtXBHjZ7VGHMqmCg8mlQcRFTgn0noUdVqYZyA/mWKdB2Injj6/ZxirBwNcBpKHi
         j9Ag==
X-Gm-Message-State: APjAAAUJisQouFiuQJU2AromAmntG6nmC/vjiZ5lIf0l1mK+SEEYO2Co
        B3eX5fu+T1SKDV/X9zhf05YtQ7hZv4MVyIiL/38=
X-Google-Smtp-Source: APXvYqxTUE31bhTYkJ/aDJj+cTKPfsKtlfVi5Bz2nwWjPIUfWsCZgknHRNMjJyb7o3hLHGunux32XZ7Wkek2JRY6WWc=
X-Received: by 2002:aa7:8ac3:: with SMTP id b3mr11093751pfd.242.1568067820440;
 Mon, 09 Sep 2019 15:23:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190908072907.15220-1-hdanton@sina.com>
In-Reply-To: <20190908072907.15220-1-hdanton@sina.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 9 Sep 2019 15:23:28 -0700
Message-ID: <CAM_iQpU495Dg-6oeOvrBEu=hbh5Evjv_yYSdr6BxOC_okSo=Wg@mail.gmail.com>
Subject: Re: general protection fault in cbs_destroy
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+3a8d6a998cbb73bcf337@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 8, 2019 at 12:29 AM Hillf Danton <hdanton@sina.com> wrote:
>
>
> > syzbot found the following crash on Sat, 07 Sep 2019 23:08:08 -0700
> >
> > HEAD commit:    3b47fd5c Merge tag 'nfs-for-5.3-4' of git://git.linux-nfs...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14854e71600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=144488c6c6c6d2b6
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3a8d6a998cbb73bcf337
> > compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> > 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17998f9e600000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10421efa600000
> >
> > general protection fault: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 9249 Comm: syz-executor457 Not tainted 5.3.0-rc7+ #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > RIP: 0010:__list_del_entry_valid+0x6b/0x100 lib/list_debug.c:51
> > Code: 4c 89 f7 e8 97 d0 58 fe 48 ba 00 01 00 00 00 00 ad de 49 8b 1e 48 39
> > d3 74 54 48 83 c2 22 49 39 d7 74 5e 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00
> > 74 08 4c 89 ff e8 66 d0 58 fe 49 8b 17 4c 39 f2 75
> > RSP: 0018:ffff88809898f568 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
> > RDX: dead000000000122 RSI: 0000000000000004 RDI: ffff88809fb5a7e8
> > RBP: ffff88809898f588 R08: dffffc0000000000 R09: ffffed1013131ea8
> > R10: ffffed1013131ea8 R11: 0000000000000000 R12: dffffc0000000000
> > R13: ffff88809fb5a480 R14: ffff88809fb5a7e0 R15: 0000000000000000
> > FS:  00005555568cb880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020000610 CR3: 00000000a3968000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   __list_del_entry include/linux/list.h:131 [inline]
> >   list_del include/linux/list.h:139 [inline]
> >   cbs_destroy+0x85/0x3e0 net/sched/sch_cbs.c:435
> >   qdisc_create+0xff8/0x13e0 net/sched/sch_api.c:1302
> >   tc_modify_qdisc+0x989/0x1ea0 net/sched/sch_api.c:1652
> >   rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5223
> >   netlink_rcv_skb+0x19e/0x3d0 net/netlink/af_netlink.c:2477
> >   rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5241
> >   netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
> >   netlink_unicast+0x787/0x900 net/netlink/af_netlink.c:1328
> >   netlink_sendmsg+0x993/0xc50 net/netlink/af_netlink.c:1917
> >   sock_sendmsg_nosec net/socket.c:637 [inline]
> >   sock_sendmsg net/socket.c:657 [inline]
> >   ___sys_sendmsg+0x60d/0x910 net/socket.c:2311
> >   __sys_sendmsg net/socket.c:2356 [inline]
> >   __do_sys_sendmsg net/socket.c:2365 [inline]
> >   __se_sys_sendmsg net/socket.c:2363 [inline]
> >   __x64_sys_sendmsg+0x17c/0x200 net/socket.c:2363
> >   do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
> >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> --- a/net/sched/sch_cbs.c
> +++ b/net/sched/sch_cbs.c
> @@ -401,6 +401,7 @@ static int cbs_init(struct Qdisc *sch, s
>         if (!q->qdisc)
>                 return -ENOMEM;
>
> +       INIT_LIST_HEAD(&q->cbs_list);
>         qdisc_hash_add(q->qdisc, false);
>
>         q->queue = sch->dev_queue - netdev_get_tx_queue(dev, 0);

There is already a patch for the same bug:
http://patchwork.ozlabs.org/patch/1154697/

Vinicius, can you send V2 as David requested?

Thanks.
