Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 073BF50A99
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 14:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbfFXMWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 08:22:13 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45481 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfFXMWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 08:22:13 -0400
Received: by mail-io1-f68.google.com with SMTP id e3so1064699ioc.12
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 05:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vr9+zBFJhANC96gECBOzHRo21YufsdtA1x+CuBd2xUI=;
        b=e6iLsIKq0kv4g1TfnQzLjijGX/HstIF513bDLSLdKvpHJa5t+8dbGNSnwYLFvb7bDs
         0PfyXtxYlPID4s2bL9i+uDqIck43CKVU6NOU2XrDF0FP0pxF2D8fv0c7iW5FtXiwiPrQ
         qBzhhlLCiLrEVDN+rPoS8bg1hnp8YeaUTNCc6HxHn8MXA8lfk2UONd60S5QPkfCRBhtJ
         GI8L+OQvy41nXdIcdJ1xEw6bPrrjhkno2jwrZyl4XeJ8ZnI+4gI11YvdrIHMqXDN6T12
         UJULZCL0PN2lvt/On2YZ42UDtw2U5kEnQPsGm2RJ97seAwxYhMiqqL/Nr5xQeZLGywy3
         1CXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vr9+zBFJhANC96gECBOzHRo21YufsdtA1x+CuBd2xUI=;
        b=fUrVeqv6IlP2Dc5+NJUaCXUC82Dhr10zJJjrtC/GtpzGJJwnKlFCFkB7mg0417K2AU
         jvA3U+562wf5P/D+ZN9Nzeq17R5qrvvF2AaldZ1DYOtS68IJAPnnRw8RQvV4hWZsQwCh
         5VNucr/ri44v5n/aB+kOwdYww2gJ0cMQtxUEQmHM5sd80AlXPDhu5XESpX9cHB6bUYIX
         gbDMrxDVZ37Isu2om6APas96CsxoXbgCA1d56OWLQJKF+ri1XeKZKoNjW1Cr40Y0azOL
         35h72vLE16H7XVzWd3y8FHCgQxU1OqaNRKk5r20unAdHTCz8cvZrJdVQQ5PxtssoSxo1
         zoCw==
X-Gm-Message-State: APjAAAV8BnwYSC6A6viRMzNNnh/+vWCvWt+XFtWdYiaQP6HR2bNdfzCd
        ffBCl7SagU2gYubgWrWz6SmWbSei7D+f1Ll1sJKaTg==
X-Google-Smtp-Source: APXvYqwu8tLfKRuo+e/fMDdCCwORFzVr8xWtQkFhdlSfUXuBhjGaNA2gKeHAvtc1b9Js8KzD3i+zLOW5Sp9cfy1iTxY=
X-Received: by 2002:a02:a07:: with SMTP id 7mr31931243jaw.65.1561378932524;
 Mon, 24 Jun 2019 05:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000d6a8ba058c0df076@google.com> <alpine.DEB.2.21.1906241130100.32342@nanos.tec.linutronix.de>
 <CACT4Y+Y_TadXGE_CVFa4fKqrbpAD4i5WGem9StgoyP_YAVraXw@mail.gmail.com> <da83da44-0088-3056-6bba-d028b6cbb218@gmail.com>
In-Reply-To: <da83da44-0088-3056-6bba-d028b6cbb218@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 24 Jun 2019 14:22:01 +0200
Message-ID: <CACT4Y+bk1h+CFVdbbKau490Wjis8zt_ia8gVctGZ+bs=7qPk=Q@mail.gmail.com>
Subject: Re: WARNING: ODEBUG bug in netdev_freemem (2)
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        syzbot <syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        amritha.nambiar@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ido Schimmel <idosch@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tyhicks@canonical.com, wanghai26@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 2:08 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 6/24/19 3:54 AM, Dmitry Vyukov wrote:
> > On Mon, Jun 24, 2019 at 11:34 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >> On Mon, 24 Jun 2019, syzbot wrote:
> >>
> >>> Hello,
> >>>
> >>> syzbot found the following crash on:
> >>>
> >>> HEAD commit:    fd6b99fa Merge branch 'akpm' (patches from Andrew)
> >>> git tree:       upstream
> >>> console output: https://syzkaller.appspot.com/x/log.txt?x=144de256a00000
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=fa9f7e1b6a8bb586
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=c4521ac872a4ccc3afec
> >>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >>>
> >>> Unfortunately, I don't have any reproducer for this crash yet.
> >>>
> >>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >>> Reported-by: syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com
> >>>
> >>> device hsr_slave_0 left promiscuous mode
> >>> team0 (unregistering): Port device team_slave_1 removed
> >>> team0 (unregistering): Port device team_slave_0 removed
> >>> bond0 (unregistering): Releasing backup interface bond_slave_1
> >>> bond0 (unregistering): Releasing backup interface bond_slave_0
> >>> bond0 (unregistering): Released>
>
> all slaves
> >>> ------------[ cut here ]------------
> >>> ODEBUG: free active (active state 0) object type: timer_list hint:
> >>> delayed_work_timer_fn+0x0/0x90 arch/x86/include/asm/paravirt.h:767
> >>
> >> One of the cleaned up devices has left an active timer which belongs to a
> >> delayed work. That's all I can decode out of that splat. :(
> >
> > Hi Thomas,
> >
> > If ODEBUG would memorize full stack traces for object allocation
> > (using lib/stackdepot.c), it would make this splat actionable, right?
> > I've fixed https://bugzilla.kernel.org/show_bug.cgi?id=203969 for this.
> >
>
> Not sure this would help in this case as some netdev are allocated through a generic helper.
>
> The driver specific portion might not show up in the stack trace.
>
> It would be nice here to get the work queue function pointer,
> so that it gives us a clue which driver needs a fix.

I see. But isn't the workqueue callback is cleanup_net in this case
and is in the stack?

  cleanup_net+0x3fb/0x960 net/core/net_namespace.c:553
  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
