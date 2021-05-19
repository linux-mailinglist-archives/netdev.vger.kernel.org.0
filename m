Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D03389785
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbhESULL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbhESULH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 16:11:07 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC65C06175F
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 13:09:47 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id c10so11099543qtx.10
        for <netdev@vger.kernel.org>; Wed, 19 May 2021 13:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KfkhZmx3Ws5Ze8v02ddLCR92udVHDSQf4VgG9lhW0vw=;
        b=dNK4Qcjo1GJlJUy6Vug24BkmQ4i+xHpuhrLhPuAfEydaD/NY3hhi9V6o1eZKG/09Fn
         j8fThsIkCYaaA61B3gnM/ULVXED8eDl7ZnY5JqO1Roou2tHoSuhwkRugUNlGZqIBx7Ae
         QDzYKjmOqukyxoiG5FtCKJa8XmVhOMPY/p8HmTNm/eOIv3uC/eezL1rZ9XWvCU7EyED9
         vFyPmbjuH8u/HHbJcGwxK7wTCwc50rlC6QVdHpFeyr/IpHrYUlKJsqmn0jC8+eJBujfx
         SboOrCUge/TWUaQyytqdNlUB7Vn1ZZ06DXAAqUpUcXFRFeWA4Wv+RI2qugOVZH0FlSEh
         I9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KfkhZmx3Ws5Ze8v02ddLCR92udVHDSQf4VgG9lhW0vw=;
        b=bSIfBy4NEOyhkaoZF1LEr1vCz5xJXgQk08vJ2976IXJDhy2FpxlQTm6FVvTg6uCAHo
         g61W3Wp58xNCUGoVrbQ+TTEIkaO0erJVqzCvxihn9nm0b0eoBCPso5yD4hn6SVkXadW6
         30oHLUa1lbQfszwacPdtTzrjUmiu0kfEpwlcxRYvlwiJpYmqNLx/ZnO2JAlwcOnWuxwv
         1fzfQ4ptxTwHKnvNVfd4nR7tjOfps6AlVfpA0FqKELvN8mhhhqI83q+IbnwIGbQ69uqB
         t+lQCLmsNngJAaz5riTgJ23DX5MS/o16TwPf/tcXp8bf6e8dzuJEb4qPOTlcebO90+uX
         fh0w==
X-Gm-Message-State: AOAM533emlL9KBeojeg5XPn+n8xGDbAVyrc+1PGYZ5Ea/iCiehxrh//2
        1YtIHm+MWmzqZO3h91nsKGWueokhz0Had8tos+BshQ==
X-Google-Smtp-Source: ABdhPJzSRnReeqqsbjlEhkp34XANq/j4yYeQgtNg3lCYkyDq7UDdpB98t1TcoHPQ4FK5FHJS1NbLR9a77X0dvlVirGk=
X-Received: by 2002:ac8:51d6:: with SMTP id d22mr1361146qtn.67.1621454986265;
 Wed, 19 May 2021 13:09:46 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000003687bd05c2b2401d@google.com> <CACT4Y+YJDGFN4q-aTPritnjjHEXiFovOm9eO6Ay4xC1YOa5z3w@mail.gmail.com>
 <c545268c-fe62-883c-4c46-974b3bb3cea1@infradead.org>
In-Reply-To: <c545268c-fe62-883c-4c46-974b3bb3cea1@infradead.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 19 May 2021 22:09:35 +0200
Message-ID: <CACT4Y+aEtYPAdrU7KkE303yDw__QiG7m1tWVJewV8C_Mt9=1qg@mail.gmail.com>
Subject: Re: [syzbot] BUG: MAX_LOCKDEP_KEYS too low! (2)
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     syzbot <syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 9:58 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 5/19/21 12:48 PM, Dmitry Vyukov wrote:
> > On Wed, May 19, 2021 at 7:35 PM syzbot
> > <syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com> wrote:
> >>
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    b81ac784 net: cdc_eem: fix URL to CDC EEM 1.0 spec
> >> git tree:       net
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=15a257c3d00000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=5b86a12e0d1933b5
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=a70a6358abd2c3f9550f
> >>
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com
> >>
> >> BUG: MAX_LOCKDEP_KEYS too low!
> >
>
> include/linux/lockdep.h
>
> #define MAX_LOCKDEP_KEYS_BITS           13
> #define MAX_LOCKDEP_KEYS                (1UL << MAX_LOCKDEP_KEYS_BITS)

Ouch, so it's not configurable yet :(
Unless, of course, we identify the offender that produced thousands of
lock classes in the log and fix it.


> Documentation/locking/lockdep-design.rst:
>
> Troubleshooting:
> ----------------
>
> The validator tracks a maximum of MAX_LOCKDEP_KEYS number of lock classes.
> Exceeding this number will trigger the following lockdep warning::
>
>         (DEBUG_LOCKS_WARN_ON(id >= MAX_LOCKDEP_KEYS))
>
> By default, MAX_LOCKDEP_KEYS is currently set to 8191, and typical
> desktop systems have less than 1,000 lock classes, so this warning
> normally results from lock-class leakage or failure to properly
> initialize locks.  These two problems are illustrated below:
>
> >
> > What config controls this? I don't see "MAX_LOCKDEP_KEYS too low" in
> > any of the config descriptions...
> > Here is what syzbot used:
> >
> > CONFIG_LOCKDEP=y
> > CONFIG_LOCKDEP_BITS=16
> > CONFIG_LOCKDEP_CHAINS_BITS=17
> > CONFIG_LOCKDEP_STACK_TRACE_BITS=20
> > CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
> > CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
> >
> > We already bumped most of these.
> > The log contains dump of the lockdep debug files, is there any offender?
> >
> > Also looking at the log I noticed a memory safety bug in lockdep implementation:
>
> ...
>
> --
> ~Randy
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/c545268c-fe62-883c-4c46-974b3bb3cea1%40infradead.org.
