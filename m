Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA9116E99E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbgBYPJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:09:14 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:41834 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730866AbgBYPJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 10:09:13 -0500
Received: by mail-qv1-f65.google.com with SMTP id s7so5830270qvn.8
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 07:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfJPS0aSSmWSxrS1z6hdTyQpH7CN51v0RStp/ll4t7o=;
        b=EuHICkRJTvkHvHmdiItNxQmplfi8eYk+gJ1lsh3yb6qmiy50HtAcW4+6j+Mq7L4S85
         1Mx2+Xg9Bd/Fg9ATFMej1fO+dpJMo9f24wCo4wzJ0r+xUCzzrioU6ebC2QnfYRvz+h7N
         0iV6DkwnkxWArUeqWGI26iIDWnkxJ7VYi5YoAnqZl+y1SbyY7eK8rTtO0vGzupfISbV6
         LcVjw0KL+tiFPRVvoKt9i+kgWphbLlJ+vSNr49lvhFRDJeF5yV4PON4VEypMp1KOWQ8u
         2aovX5x4le7186emQ53Svd69x3ngLPPEVkyUAzhtjafAfodoZ6pZjS62OEmAa5Y0dki1
         7NMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfJPS0aSSmWSxrS1z6hdTyQpH7CN51v0RStp/ll4t7o=;
        b=tso66pt717RAisdilKjA7sfT2ztP3cp8DvB0bBW6lo0kp+1Pd1hFmr5fOf6aL/f89M
         fvQPqF02HywwyPG6w2eP0BhYqZm26bgthIILYvz3AkIVu9kT6/BUmSlTLRFGZkOEdXes
         rij/pyecu5eV6KROZdqzjUzALw6QLFKOLpfmK7IF/dCaxjuq4I3diWttf5n5urMVfRv8
         jPHhmv4Obj4yUXl2ebh5+HqiLsOMJpfGB0SMCvUGkNuFiqdZhIHdzSFjlvfrNzLfr9IP
         KfC84lKy6pVE4q/+erZ7VefBpo3KGxZO9Rp5AUuY+OwXd5IvQ8rqUGaP09mfLyxO5IPM
         MRfw==
X-Gm-Message-State: APjAAAVE/cOeqvP352E99IAIHg7diVRXXiQonqRXTvT2SiTpmyH428fE
        WQSnXZMM66XD4Qar50riZFO4KLVwMgPj+gsOyOojcg==
X-Google-Smtp-Source: APXvYqyM4ugTOOU3/Yh4aSow5D9jJTB19rycM3Nqj6TBmlDHljnuFLqRTOLoo/f+9kfOyY6wAHJ5n4n8pCpjxGIRRyQ=
X-Received: by 2002:ad4:4e50:: with SMTP id eb16mr50742796qvb.34.1582643352427;
 Tue, 25 Feb 2020 07:09:12 -0800 (PST)
MIME-Version: 1.0
References: <000000000000a719a9059f62246e@google.com> <CAHC9VhTh6s1m7YBZp-3XO3q2EcjtMKUTcXwRzDTj_LSJd+cHTA@mail.gmail.com>
 <CACT4Y+Y3QN9=c5JvJkecCtdQGTxHYRXMhS4f1itwU5JEZmcYtA@mail.gmail.com> <db643ed6efb6fa04fe5753af68d13f1b2ffcf821.camel@redhat.com>
In-Reply-To: <db643ed6efb6fa04fe5753af68d13f1b2ffcf821.camel@redhat.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 25 Feb 2020 16:09:01 +0100
Message-ID: <CACT4Y+a6Lp=YGYrxDubwrXiMKc5R5WhehR+Q5E1jEu452d0tfA@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in cipso_v4_sock_setattr
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        syzbot <syzbot+f4dfece964792d80b139@syzkaller.appspotmail.com>,
        cpaasch@apple.com, David Miller <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>,
        Florian Westphal <fw@strlen.de>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        matthieu.baerts@tessares.net, netdev <netdev@vger.kernel.org>,
        peter.krystad@linux.intel.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 3:46 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2020-02-25 at 15:27 +0100, Dmitry Vyukov wrote:
> > On Tue, Feb 25, 2020 at 3:20 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Tue, Feb 25, 2020 at 3:19 AM syzbot
> > > <syzbot+f4dfece964792d80b139@syzkaller.appspotmail.com> wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > > > HEAD commit:    ca7e1fd1 Merge tag 'linux-kselftest-5.6-rc3' of git://git...
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=179f0931e00000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=a61f2164c515c07f
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=f4dfece964792d80b139
> > > > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fdfdede00000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17667de9e00000
> > > >
> > > > The bug was bisected to:
> > > >
> > > > commit 2303f994b3e187091fd08148066688b08f837efc
> > > > Author: Peter Krystad <peter.krystad@linux.intel.com>
> > > > Date:   Wed Jan 22 00:56:17 2020 +0000
> > > >
> > > >     mptcp: Associate MPTCP context with TCP socket
> > > >
> > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14fbec81e00000
> > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=16fbec81e00000
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=12fbec81e00000
> > > >
> > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > Reported-by: syzbot+f4dfece964792d80b139@syzkaller.appspotmail.com
> > > > Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
> > > >
> > > > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > > > #PF: supervisor instruction fetch in kernel mode
> > > > #PF: error_code(0x0010) - not-present page
> > > > PGD 8e171067 P4D 8e171067 PUD 93fa2067 PMD 0
> > > > Oops: 0010 [#1] PREEMPT SMP KASAN
> > > > CPU: 0 PID: 8984 Comm: syz-executor066 Not tainted 5.6.0-rc2-syzkaller #0
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > > RIP: 0010:0x0
> > > > Code: Bad RIP value.
> > > > RSP: 0018:ffffc900020b7b80 EFLAGS: 00010246
> > > > RAX: 1ffff110124ba600 RBX: 0000000000000000 RCX: ffff88809fefa600
> > > > RDX: ffff8880994cdb18 RSI: 0000000000000000 RDI: ffff8880925d3140
> > > > RBP: ffffc900020b7bd8 R08: ffffffff870225be R09: fffffbfff140652a
> > > > R10: fffffbfff140652a R11: 0000000000000000 R12: ffff8880925d35d0
> > > > R13: ffff8880925d3140 R14: dffffc0000000000 R15: 1ffff110124ba6ba
> > > > FS:  0000000001a0b880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: ffffffffffffffd6 CR3: 00000000a6d6f000 CR4: 00000000001406f0
> > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > Call Trace:
> > > >  cipso_v4_sock_setattr+0x34b/0x470 net/ipv4/cipso_ipv4.c:1888
> > > >  netlbl_sock_setattr+0x2a7/0x310 net/netlabel/netlabel_kapi.c:989
> > > >  smack_netlabel security/smack/smack_lsm.c:2425 [inline]
> > > >  smack_inode_setsecurity+0x3da/0x4a0 security/smack/smack_lsm.c:2716
> > > >  security_inode_setsecurity+0xb2/0x140 security/security.c:1364
> > > >  __vfs_setxattr_noperm+0x16f/0x3e0 fs/xattr.c:197
> > > >  vfs_setxattr fs/xattr.c:224 [inline]
> > > >  setxattr+0x335/0x430 fs/xattr.c:451
> > > >  __do_sys_fsetxattr fs/xattr.c:506 [inline]
> > > >  __se_sys_fsetxattr+0x130/0x1b0 fs/xattr.c:495
> > > >  __x64_sys_fsetxattr+0xbf/0xd0 fs/xattr.c:495
> > > >  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
> > > >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >
> > > Netdev folks, I'm not very familiar with the multipath TCP code so I
> > > was wondering if you might help me out a bit with this report.  Based
> > > on the stack trace above it looks like for a given AF_INET sock "sk",
> > > inet_sk(sk)->is_icsk is true but inet_csk(sk) is NULL; should this be
> > > possible under normal conditions or is there an issue somewhere?
> >
> > Paolo has submitted some patch for testing for this bug, not sure if
> > you have seen it, just in case:
> > https://groups.google.com/forum/#!msg/syzkaller-bugs/dqwnTBh-MQw/LhgSZYGsBgAJ
>
> I sent the patch to the syzbot ML only, for testing before posting on
> netdev, so Paul likely have not seen it yet, sorry.
>
> @Dmitry: I did not get any reply yet from syzbot, are there any
> problems or is this the usual time-frame?

The testing is queued after bisection of this guy:
https://syzkaller.appspot.com/bug?id=c0a75a31c5fa84e6e5d3131fd98a5b56e2141b9a
which has been running since 6pm yesterday...
