Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B238280A92
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgJAWx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgJAWx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 18:53:28 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C639AC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 15:53:26 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id z46so95286uac.13
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 15:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KGd9h/uTrr1lS+rBn8mk/6DxPwxgJ3tFvU+26ir+cPY=;
        b=oITKcHNPNJCFU4MQL4YvJ1KZUIJUUkPsQk4Y9ZE7JujtgnXO6B6L9MXdjZOmNi67PA
         9Pd2tZf7EaGrHDoxB8dLqlb0dO4DJxalr5jOhkEVmmTDDfWKL8ILCCp5H8OfF3o4UZEs
         ENr8vY8wKh2oRTvCEoQ2VGnfxQQXT8lHxD00A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KGd9h/uTrr1lS+rBn8mk/6DxPwxgJ3tFvU+26ir+cPY=;
        b=HlKMKn3vCQZSqD6WAVAfKzk5O11TZgEI7CWGPNTU6v/x//5oYkx65Ab9YguDj7BE7h
         uUKawmEYSGF8U/9ohlt8D0KtwyNWbedYtNW6GhADFAsES3s3XWYiMhwueeXSBdUXuhiI
         uXhm78Bkp+aX9zs4XrFOtndahH6sBmCttSOE5/o9+ifAGw+mb8xLHoWD3EJIZ3J7jSoQ
         DBzwAamVbJBT1v3eek1tK83XwGQvsNVubhgHftqAXkfSyKrlT3XFKPdlSgDxOs4DJWOO
         Quz81Fq6t6OmBx06Gvkd6wWFsoTTc3NdX0jgXDwLY9EZw3YDbZgTa/ttF/A4bQaToJPO
         B2Gw==
X-Gm-Message-State: AOAM533Nlmv+FbcA5glrQIXdnRFdZsY1e3iQKXMFFuNK9eUURTYglVRU
        fAZociU6DvWUjxRD74u+fLYwTJ5+r9nqcA==
X-Google-Smtp-Source: ABdhPJyU6MuAfWqmKEE3iJ8Je0XMWDK6ulDzOOkKfGt1t+iEbKftIYLrEASKLxY10NzjVYcPfMEaqQ==
X-Received: by 2002:ab0:1102:: with SMTP id e2mr7435990uab.133.1601592805696;
        Thu, 01 Oct 2020 15:53:25 -0700 (PDT)
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com. [209.85.221.169])
        by smtp.gmail.com with ESMTPSA id a195sm995459vka.42.2020.10.01.15.53.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 15:53:24 -0700 (PDT)
Received: by mail-vk1-f169.google.com with SMTP id c63so91053vkb.7
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 15:53:24 -0700 (PDT)
X-Received: by 2002:a1f:d986:: with SMTP id q128mr6981367vkg.7.1601592804151;
 Thu, 01 Oct 2020 15:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200926165625.11660-1-manivannan.sadhasivam@linaro.org> <20200928.155603.134441435973191115.davem@davemloft.net>
In-Reply-To: <20200928.155603.134441435973191115.davem@davemloft.net>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 1 Oct 2020 15:53:12 -0700
X-Gmail-Original-Message-ID: <CAD=FV=VZ8QEP7MU8M9G5odLs+A0RAHfKR5bUJh2n6my7JRtaVg@mail.gmail.com>
Message-ID: <CAD=FV=VZ8QEP7MU8M9G5odLs+A0RAHfKR5bUJh2n6my7JRtaVg@mail.gmail.com>
Subject: Re: [PATCH] net: qrtr: ns: Protect radix_tree_deref_slot() using rcu
 read locks
To:     David Miller <davem@davemloft.net>
Cc:     manivannan.sadhasivam@linaro.org, Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Sep 28, 2020 at 4:15 PM David Miller <davem@davemloft.net> wrote:
>
> From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Date: Sat, 26 Sep 2020 22:26:25 +0530
>
> > The rcu read locks are needed to avoid potential race condition while
> > dereferencing radix tree from multiple threads. The issue was identified
> > by syzbot. Below is the crash report:
>  ...
> > Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> > Reported-and-tested-by: syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>
> Applied and queued up for -stable, thank you.

The cure is worse than the disease.  I tested by picking back to a
5.4-based kernel and got this crash.  I expect the crash would also be
present on mainline:

 BUG: sleeping function called from invalid context at net/core/sock.c:3000
 in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 7, name: kworker/u16:0
 3 locks held by kworker/u16:0/7:
  #0: ffffff81b65a7b28 ((wq_completion)qrtr_ns_handler){+.+.}, at:
process_one_work+0x1bc/0x614
  #1: ffffff81b6edfd58 ((work_completion)(&qrtr_ns.work)){+.+.}, at:
process_one_work+0x1e4/0x614
  #2: ffffffd01144c328 (rcu_read_lock){....}, at: rcu_lock_acquire+0x8/0x38
 CPU: 6 PID: 7 Comm: kworker/u16:0 Not tainted 5.4.68 #33
 Hardware name: Google Lazor (rev0) with LTE (DT)
 Workqueue: qrtr_ns_handler qrtr_ns_worker
 Call trace:
  dump_backtrace+0x0/0x158
  show_stack+0x20/0x2c
  dump_stack+0xdc/0x180
  ___might_sleep+0x1c0/0x1d0
  __might_sleep+0x50/0x88
  lock_sock_nested+0x34/0x94
  qrtr_sendmsg+0x7c/0x260
  sock_sendmsg+0x44/0x5c
  kernel_sendmsg+0x50/0x64
  lookup_notify+0xa8/0x118
  qrtr_ns_worker+0x8d8/0x1050
  process_one_work+0x338/0x614
  worker_thread+0x29c/0x46c
  kthread+0x150/0x160
  ret_from_fork+0x10/0x18

I'll give the stack crawl from kgdb too since inlining makes things
less obvious with the above...

(gdb) bt
#0  arch_kgdb_breakpoint ()
    at .../arch/arm64/include/asm/kgdb.h:21
#1  kgdb_breakpoint ()
    at .../kernel/debug/debug_core.c:1183
#2  0xffffffd010131058 in ___might_sleep (
    file=file@entry=0xffffffd010efec42 "net/core/sock.c",
    line=line@entry=3000, preempt_offset=preempt_offset@entry=0)
    at .../kernel/sched/core.c:7994
#3  0xffffffd010130ee0 in __might_sleep (
    file=0xffffffd010efec42 "net/core/sock.c", line=3000,
    preempt_offset=0)
    at .../kernel/sched/core.c:7965
#4  0xffffffd01094d1c8 in lock_sock_nested (
    sk=sk@entry=0xffffff8147e457c0, subclass=0)
    at .../net/core/sock.c:3000
#5  0xffffffd010b26028 in lock_sock (sk=0xffffff8147e457c0)
    at .../include/net/sock.h:1536
#6  qrtr_sendmsg (sock=0xffffff8148c4b240, msg=0xffffff81422afab8,
    len=20)
    at .../net/qrtr/qrtr.c:891
#7  0xffffffd01093f8f4 in sock_sendmsg_nosec (
    sock=0xffffff8148c4b240, msg=0xffffff81422afab8)
    at .../net/socket.c:638
#8  sock_sendmsg (sock=sock@entry=0xffffff8148c4b240,
    msg=msg@entry=0xffffff81422afab8)
    at .../net/socket.c:658
#9  0xffffffd01093f95c in kernel_sendmsg (sock=0x1,
    msg=msg@entry=0xffffff81422afab8, vec=<optimized out>,
    vec@entry=0xffffff81422afaa8, num=<optimized out>, num@entry=1,
    size=<optimized out>, size@entry=20)
    at .../net/socket.c:678
#10 0xffffffd010b28be0 in service_announce_new (
    dest=dest@entry=0xffffff81422afc20,
    srv=srv@entry=0xffffff81370f6380)
    at .../net/qrtr/ns.c:127
#11 0xffffffd010b279f4 in announce_servers (sq=0xffffff81422afc20)
    at .../net/qrtr/ns.c:207
#12 ctrl_cmd_hello (sq=0xffffff81422afc20)
    at .../net/qrtr/ns.c:328
#13 qrtr_ns_worker (work=<optimized out>)
    at .../net/qrtr/ns.c:661
#14 0xffffffd010119a94 in process_one_work (
    worker=worker@entry=0xffffff8142267900,
    work=0xffffffd0128ddaf8 <qrtr_ns+48>)
    at .../kernel/workqueue.c:2272
#15 0xffffffd01011a16c in worker_thread (
    __worker=__worker@entry=0xffffff8142267900)
    at .../kernel/workqueue.c:2418
#16 0xffffffd01011fb78 in kthread (_create=0xffffff8142269200)
    at .../kernel/kthread.c:268
#17 0xffffffd01008645c in ret_from_fork ()
    at .../arch/arm64/kernel/entry.S:1169


-Doug
