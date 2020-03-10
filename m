Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3ED180662
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgCJSbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:31:21 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42311 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgCJSbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:31:21 -0400
Received: by mail-ot1-f67.google.com with SMTP id 66so14145050otd.9;
        Tue, 10 Mar 2020 11:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7jfISf3OEyvEx0oLvSI1273sxi5HaeHIy5eXl6CUYSk=;
        b=UentoJdJ5VZTR83/ZDu/HfKaS1HpoOPI7RSJ5ng4nDGd6z+It18K+I5lb69vMdjwZB
         RAlTIyIAqPckJXVCAcHAWLsYR18MRy/aeNKfIDm2nWuBxTwmxlTjBytrqu1q6vdccnX4
         3ZqnwYu1DBkRUI0vM7MVfVJSAPlNI7Z1QHc1VLCuUFeYfo5/ePMR/LO3bbpn0X6DS6WT
         CloXkMQVj47l8Bbl2rY57GwdvhxrHWHSzyAf0sF08hC0yHqlD7s9EKtqOSnnzGsgb6Wo
         h66sSAyU4R9se6wV+0bGaqba/HhjK24MiN/HTcWHgeDxPZI44/ep+ktlyI2PG6ewb/I7
         wXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7jfISf3OEyvEx0oLvSI1273sxi5HaeHIy5eXl6CUYSk=;
        b=mzhMJftzzb7qx7tRLQYspSXC9UpDVbwh/DkEQpsWfite5jqa6Z1lySamGg69DZrx3e
         XrJl4p0HQ4kZLZ1vvwKsYh/osW/LFg3XTLspYwCDHIZRDvgE7ny70px6026c0hhjRQjo
         peJ6FcTbXb07oVV0pN9rlAY7xvfGtg4piZVNzZwRc6/j7YQgNwXywutElm9M5CqdVA9N
         8CrIJAef6w7CHe875IZQhnPSs7WXCpSf89C4rroxeFIKpISw+4mLNgrMU5nRXwn/S8VV
         J9oKYiVa97NmYu/cU+QkpVEgZtM4MEaeiCZxxvJqoTPzr8+JATPuUY3546evMLLbbjDr
         oEcA==
X-Gm-Message-State: ANhLgQ0y1Ve8/KQFaS4WSnnREVgMM6vJD/SFFiP86tO9vJG7wA5aJ3aZ
        7S+qPhXA6Vn/2kxKji4RJFVutoqh4IuTdRRgmuc=
X-Google-Smtp-Source: ADFU+vtLCDX3KJyCLZbj2vhkUc2Ppo+C8h1OD95k0wYeGtls5yyv4Hrsbmya39rogJUAvqAiID5smIyai2nRPF5neOw=
X-Received: by 2002:a9d:4702:: with SMTP id a2mr17569197otf.319.1583865079547;
 Tue, 10 Mar 2020 11:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000490abd05a05fa060@google.com>
In-Reply-To: <000000000000490abd05a05fa060@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 10 Mar 2020 11:31:06 -0700
Message-ID: <CAM_iQpXrLCmQGXr8C9iw0+QxsP6DtQqoRqG18aegPhpjcpXdhQ@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Write in tcindex_set_parms
To:     syzbot <syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 8, 2020 at 3:44 PM syzbot
<syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    425c075d Merge branch 'tun-debug'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=134d2ae3e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=598678fc6e800071
> dashboard link: https://syzkaller.appspot.com/bug?extid=c72da7b9ed57cde6fca2
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122ed70de00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=116689fde00000
>
> The bug was bisected to:
>
> commit 599be01ee567b61f4471ee8078870847d0a11e8e
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Mon Feb 3 05:14:35 2020 +0000
>
>     net_sched: fix an OOB access in cls_tcindex
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=150a7d53e00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=170a7d53e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=130a7d53e00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com
> Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
>
> IPVS: ftp: loaded support on port[0] = 21
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in tcindex_set_parms+0x17fd/0x1a00 net/sched/cls_tcindex.c:455
> Write of size 16 at addr ffff8880a219e6b8 by task syz-executor508/9705
>
> CPU: 1 PID: 9705 Comm: syz-executor508 Not tainted 5.6.0-rc3-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:374
>  __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:506
>  kasan_report+0xe/0x20 mm/kasan/common.c:641
>  tcindex_set_parms+0x17fd/0x1a00 net/sched/cls_tcindex.c:455


I think we probably don't check the boundary of 'handle' properly.

397         if (cp->perfect || valid_perfect_hash(cp))
398                 if (handle >= cp->alloc_hash)
399                         goto errout_alloc;

I will think more about it.

Thanks.
