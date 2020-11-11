Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C272AF1C9
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgKKNNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKKNN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:13:27 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0890EC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:13:27 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id g15so1157744qtq.13
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=EkvM6WarRV6rhr4BQ6Yo0kzyiUzqNtolNOUPsaZ+HZs=;
        b=qQXmbuIijBsliV18NggUJ3ZwxlOjabXZdq2wlEi11EqByc+IDaq+mquklrZZbplpe5
         LNKudNoxtpl/cBU3+ZsXle59EFxfqjDq6Y+6ASjgvHpX2/lGHqrEi2oiPB6TF3cW7avz
         zxhAl3oRDRMz5jFYyZY4C1TBwBepvr64Lq9XAHZuKN+UdhTlubIaCW6BVJLrDPPsM6e8
         oq4sfXGxK7niqcAbf7ZQ+B4QZEVkOnlH0dDEa32cf1qDAm1WW9Ahd/vIINV0TXq2DF5o
         IJYnbr5NwfxQkAwPBx8uuK0EI++hyCSjYepAYBFqdqgEDuexY3QErIy6sAwT62y5csoe
         v/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=EkvM6WarRV6rhr4BQ6Yo0kzyiUzqNtolNOUPsaZ+HZs=;
        b=td4/d00V2kOywGaIWC0RBC+3ZeQIhUV75/URoo17HXukpT05MzfdA7T/oWwKHySS0R
         8IRzjVC7RWCWj5FxAhRgjsqeFzfYr+Fh3vHmeT5rVaSfarNFt3JqyhQn9KaQECajrf3x
         SjGWtp9YfQYEV7huElwYUovQhWQmSIccnIaTe6A1y8jtZBBx9GdVdR0leEADX951D7SE
         Pn0ttmGasXmEV6X6RopviFbXL8mJ1SlU2ZhiYUukPjSHPRQqX6acWNdlkhQ34RMUrskF
         Fu9Yu8Exh0kdmd4ocwcHJthLpUvygIOswNtZ84eT3ZhPHYrau8eUTQO483lTGBqoN9Kk
         7jmg==
X-Gm-Message-State: AOAM533BimzT4T/6zs3E/9HQUWFOy7S+Iioz4ij5OgK7SA9N0IyEEwda
        7EfVe3gkF5q/jLPui2Pc0XRJMYaitXQp9W5xe0YZGA==
X-Google-Smtp-Source: ABdhPJyYyCRc1qxpYmbd0NeyUfpxprmRQzjpT0XnyEc3toDaZaXHMTtUhOrofbutr85cyGRuy16b4seItd49FidaFIg=
X-Received: by 2002:aed:2744:: with SMTP id n62mr24073841qtd.67.1605100406017;
 Wed, 11 Nov 2020 05:13:26 -0800 (PST)
MIME-Version: 1.0
References: <0000000000006601b005a08774fd@google.com> <000000000000c3b0f205a4652f38@google.com>
In-Reply-To: <000000000000c3b0f205a4652f38@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 11 Nov 2020 14:13:15 +0100
Message-ID: <CACT4Y+Yr5FD9nmmB3YX3=k4zyGshfDLdG_CPc-d80xtacdKkPg@mail.gmail.com>
Subject: Re: general protection fault in tcf_action_destroy (2)
To:     syzbot <syzbot+92a80fff3b3af6c4464e@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 5:03 AM syzbot
<syzbot+92a80fff3b3af6c4464e@syzkaller.appspotmail.com> wrote:
>
> syzbot suspects this bug was fixed by commit:
>
> commit 0d1c3530e1bd38382edef72591b78e877e0edcd3
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Thu Mar 12 05:42:28 2020 +0000
>
>     net_sched: keep alloc_hash updated after hash allocation
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e74154100000
> start commit:   67d584e3 Merge tag 'for-5.6-rc6-tag' of git://git.kernel.o..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
> dashboard link: https://syzkaller.appspot.com/bug?extid=92a80fff3b3af6c4464e
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160c3223e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f790ade00000
>
> If the result looks correct, please mark the bug fixed by replying with:
>
> #syz fix: net_sched: keep alloc_hash updated after hash allocation
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: net_sched: keep alloc_hash updated after hash allocation
