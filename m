Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A13DB456B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 03:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391931AbfIQB6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 21:58:32 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44321 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbfIQB6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 21:58:32 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so1135514pfn.11;
        Mon, 16 Sep 2019 18:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FbKxLWX3JPFIIzFE77Ice2U9N6MP/oTE/0xanmBTVEM=;
        b=TWNBx+wRDX7/m460etv+xpVyxOwLEUNODbpxHigbl7vxU56KcKeXgJ5Tqz5xrOkNaw
         IwIVridSikx1MvI+8kT1x6tTG2jJBUX6RAMui/OOVgp5IDNy0zBKhoIUgQOR6PCJ0ME8
         oTxtRGXjHZ73CV+rX8Lvs1wXDZUbOozlvjiOgZF493W/Rdok2JNDSHMs69Neno6I16Sa
         T/QiNRoboMB0Y0TsDqDihzcRmkZQjQ6LfVV9hsZ33c5TGyayAPDw3WRLohohbua4g3/W
         7MHVYA8M+sEFZxFYQmu0/ZpI6aP8EqxvAQX3GQsDjz3BDK4jYYDEC7G7WUlNKEzld4q+
         65cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FbKxLWX3JPFIIzFE77Ice2U9N6MP/oTE/0xanmBTVEM=;
        b=Z4d8sP6mJZj8Lr4IHJNNZ/52b6mZMM+Gl8xAZlT8xvaMCo61tcnyD6IslmEk4/puFn
         WOqfKe+tA4ROBtA7U630wXBCXVDGnsDDlOZT1w326teco/YZz5QnW6JornWbRiIIYoT6
         k0F0C/YtBh/iXCKP7k3dsfK3u6x2BJ//jGu7WLt2gmP/ktzBxWwrxAhxSLtRFIzGDVys
         lSoBc59pJslDWXQWSWu+3WJe+JIU6cl6TFvHwB9hYUMSeXmK34Y1zj7UeXORBTZhPAJV
         uVPqpryocpIQi6kS3DM7AFnORL2I/SNtamEmBGELN7zATq/vL5kbKiNfdKBJrYs8CZdl
         peZQ==
X-Gm-Message-State: APjAAAV0ylD+Dh40nDmV0bBwjOzFC2YEaJxzIM5R7h7b9HIqgJgfdj1a
        qiFOWq45o9IiMHdlWXn+aEAGDYYjEd7mojFlYyw=
X-Google-Smtp-Source: APXvYqz+a4twHAYoY82TM+yGf6syqRRU+LiLyFVifT8j995xCuO9W18YBTswJAAa7Zi+c/xCIyeZ4usPHZKsinS1R6U=
X-Received: by 2002:a62:4d45:: with SMTP id a66mr1582183pfb.24.1568685510924;
 Mon, 16 Sep 2019 18:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000029a3a00592b41c48@google.com>
In-Reply-To: <00000000000029a3a00592b41c48@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 16 Sep 2019 18:58:19 -0700
Message-ID: <CAM_iQpX0FAvhcZgKjRd=3Rbp8cbfYiUqkF2KnmF9Pd0U4EkSDw@mail.gmail.com>
Subject: Re: BUG: sleeping function called from invalid context in tcf_chain0_head_change_cb_del
To:     syzbot <syzbot+ac54455281db908c581e@syzkaller.appspotmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, hawk@kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        petrm@mellanox.com, Roopa Prabhu <roopa@cumulusnetworks.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Buslov <vladbu@mellanox.com>, xdp-newbies@vger.kernel.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 4:39 PM syzbot
<syzbot+ac54455281db908c581e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    1609d760 Merge tag 'for-linus' of git://git.kernel.org/pub..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10236abe600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ed2b148cd67382ec
> dashboard link: https://syzkaller.appspot.com/bug?extid=ac54455281db908c581e
> compiler:       clang version 9.0.0 (/home/glider/llvm/clang
> 80fee25776c2fb61e74c1ecb1a523375c2500b69)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116c4b11600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ff270d600000
>
> The bug was bisected to:
>
> commit c266f64dbfa2a970a13b0574246c0ddfec492365
> Author: Vlad Buslov <vladbu@mellanox.com>
> Date:   Mon Feb 11 08:55:32 2019 +0000
>
>      net: sched: protect block state with mutex
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16e7ca65600000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=15e7ca65600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=11e7ca65600000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+ac54455281db908c581e@syzkaller.appspotmail.com
> Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
>
> BUG: sleeping function called from invalid context at
> kernel/locking/mutex.c:909
> in_atomic(): 1, irqs_disabled(): 0, pid: 9297, name: syz-executor942
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<ffffffff8604de24>] spin_lock_bh include/linux/spinlock.h:343 [inline]
> [<ffffffff8604de24>] sch_tree_lock include/net/sch_generic.h:570 [inline]
> [<ffffffff8604de24>] sfb_change+0x284/0xd30 net/sched/sch_sfb.c:519
> CPU: 0 PID: 9297 Comm: syz-executor942 Not tainted 5.3.0-rc8+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
>   ___might_sleep+0x3ff/0x530 kernel/sched/core.c:6608
>   __might_sleep+0x8f/0x100 kernel/sched/core.c:6561
>   __mutex_lock_common+0x4e/0x2820 kernel/locking/mutex.c:909
>   __mutex_lock kernel/locking/mutex.c:1077 [inline]
>   mutex_lock_nested+0x1b/0x30 kernel/locking/mutex.c:1092
>   tcf_chain0_head_change_cb_del+0x30/0x390 net/sched/cls_api.c:932
>   tcf_block_put_ext+0x3d/0x2a0 net/sched/cls_api.c:1502
>   tcf_block_put+0x6e/0x90 net/sched/cls_api.c:1515
>   sfb_destroy+0x47/0x70 net/sched/sch_sfb.c:467
>   qdisc_destroy+0x147/0x4d0 net/sched/sch_generic.c:968
>   qdisc_put+0x58/0x90 net/sched/sch_generic.c:992
>   sfb_change+0x52d/0xd30 net/sched/sch_sfb.c:522

I don't think we have to hold the qdisc tree lock when destroying
the old qdisc. Does the following change make sense?

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 1dff8506a715..726d0fa956b1 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -488,7 +488,7 @@ static int sfb_change(struct Qdisc *sch, struct nlattr *opt,
                      struct netlink_ext_ack *extack)
 {
        struct sfb_sched_data *q = qdisc_priv(sch);
-       struct Qdisc *child;
+       struct Qdisc *child, *tmp;
        struct nlattr *tb[TCA_SFB_MAX + 1];
        const struct tc_sfb_qopt *ctl = &sfb_default_ops;
        u32 limit;
@@ -519,7 +519,7 @@ static int sfb_change(struct Qdisc *sch, struct nlattr *opt,
        sch_tree_lock(sch);

        qdisc_tree_flush_backlog(q->qdisc);
-       qdisc_put(q->qdisc);
+       tmp = q->qdisc;
        q->qdisc = child;

        q->rehash_interval = msecs_to_jiffies(ctl->rehash_interval);
@@ -543,6 +543,7 @@ static int sfb_change(struct Qdisc *sch, struct nlattr *opt,

        sch_tree_unlock(sch);

+       qdisc_put(tmp);
        return 0;
 }


What do you think, Vlad?
