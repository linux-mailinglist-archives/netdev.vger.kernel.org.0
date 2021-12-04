Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F5C4683C3
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384533AbhLDJyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344936AbhLDJyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:54:24 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41F8C061359
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 01:50:58 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id r26so10944596oiw.5
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 01:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PWtuf7THffxb2Es2MbGam96iZCp8PZrhow4j8nKkn2I=;
        b=qCwONOHi/mWcgDGZzxk3CEBQ7bn33eptyIeHj0MQtbU8CfuJnOy2EoRpBvu0gZefxB
         D2N7xY45c5w/TIn0CEJZLZ71rP+t5v5rFFqJ9/6bU5/y5onp0ymLK9qOxd/DLgq7bV1Y
         bzWrUNC9Tcg3jsO5Rw6273N75GEx1yYZBtwOGG5Oo0oz4V72aTMh/eGKIR0Qp2daPmiI
         3NK7P+Of2NUkXefTW/qXCXESnerCkQn9RjmymSTR9e3nYSWmVYj3aQptegJnCqw/4qMv
         4Hon2M7qYOmy2Ndju9kig0yzXSN6ouSjgZN7lHChSGN6kjyUWTsjgLppNLOgEpGAw1KT
         pOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PWtuf7THffxb2Es2MbGam96iZCp8PZrhow4j8nKkn2I=;
        b=j2X56+4xVWgfWMSDBfM3pgg4V/YBzxdcqRjbaN43aRVXU5hNUJ2L5s16S8p4lSYaFu
         vKQF7NDbqy1tpr4pVJzM9WEf5Nmw4FfJFRNQgc+MiO7cfCJ45O6zjtsSzOGxyWKu0/s3
         BWk/wkiIcEAxV5nKLGFCrW0E+eLXyKvaIFWPKTTakRwph6TYezZ+1LHyZk4lTM9p6Iof
         Bs1uBOXpZtSYeQ86o4bpDNy0P8aSbFmqRUB5BkPla/CBdhfw1KI7YJuPFvFPFWN2+GP/
         WgVNOITqDsRLmohevQExxCLdZHTGopVPXxjft7sZqvCq9NVCDslikcWAYNNAI31A72qz
         Kk0Q==
X-Gm-Message-State: AOAM530sPsRQMC0MMu/lF7QF7mSqHg34VSEVsmvifBD/gSmFiu4NYLn6
        jQb5zSynJEVlTt33gThktGzbvHC7KM2r4daC0JqEWA==
X-Google-Smtp-Source: ABdhPJwwBH9zXdUYAnaJBWPnWbHiNbfLcB1X1AwG7D4qKSiW0nnK/miv4vVx+LXsXpfUUiKKAaBv8iBsc+pPdD/oPsA=
X-Received: by 2002:aca:b843:: with SMTP id i64mr14569342oif.109.1638611457909;
 Sat, 04 Dec 2021 01:50:57 -0800 (PST)
MIME-Version: 1.0
References: <00000000000069924b05c8cc3b84@google.com> <000000000000b7e3ee05d21bd19d@google.com>
 <20211201210938.GL641268@paulmck-ThinkPad-P17-Gen-1>
In-Reply-To: <20211201210938.GL641268@paulmck-ThinkPad-P17-Gen-1>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 4 Dec 2021 10:50:47 +0100
Message-ID: <CACT4Y+bLs5ycD1khkbMFDW=5UxMqxmbkXQoskyEz74H-u98pDw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in trc_read_check_handler
To:     paulmck@kernel.org
Cc:     syzbot <syzbot+fe9d8c955bd1d0f02dc1@syzkaller.appspotmail.com>,
        bigeasy@linutronix.de, jgross@suse.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
        mingo@kernel.org, namit@vmware.com, netdev@vger.kernel.org,
        peterz@infradead.org, rcu@vger.kernel.org, rdunlap@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 at 22:09, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Wed, Dec 01, 2021 at 12:50:07PM -0800, syzbot wrote:
> > syzbot suspects this issue was fixed by commit:
> >
> > commit 96017bf9039763a2e02dcc6adaa18592cd73a39d
> > Author: Paul E. McKenney <paulmck@kernel.org>
> > Date:   Wed Jul 28 17:53:41 2021 +0000
> >
> >     rcu-tasks: Simplify trc_read_check_handler() atomic operations
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1281d89db00000
> > start commit:   5319255b8df9 selftests/bpf: Skip verifier tests that fail ..
> > git tree:       bpf-next
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9290a409049988d4
> > dashboard link: https://syzkaller.appspot.com/bug?extid=fe9d8c955bd1d0f02dc1
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14990477300000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105ebd84b00000
> >
> > If the result looks correct, please mark the issue as fixed by replying with:
>
> #syz fix: rcu-tasks: Simplify trc_read_check_handler() atomic operations
>
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> Give or take.  There were quite a few related bugs, so some or all of
> the following commits might also have helped:
>
> cbe0d8d91415c rcu-tasks: Wait for trc_read_check_handler() IPIs
> 18f08e758f34e rcu-tasks: Add trc_inspect_reader() checks for exiting critical section
> 46aa886c483f5 rcu-tasks: Fix IPI failure handling in trc_wait_for_one_reader

Thanks for checking. If we don't have one exact fix, let's go with
what syzbot suggested. At this point it does not matter much since all
of them are in most trees I assume. We just need to close the bug with
something.

#syz fix: rcu-tasks: Simplify trc_read_check_handler() atomic operations

> Quibbles aside, it is nice to get an automated email about having fixed
> a bug as opposed to having added one.  ;-)

Yes, but one is not possible without the other :-)
