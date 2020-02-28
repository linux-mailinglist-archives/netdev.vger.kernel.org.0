Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC851172CD7
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgB1AO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:14:28 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42958 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbgB1AO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 19:14:28 -0500
Received: by mail-ed1-f65.google.com with SMTP id n18so1211544edw.9
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 16:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ib8VWwHjJvggYN18BEOwzhOZqnlM4YEYxegYLVlKSo=;
        b=Cetq1zeYMvA3/xQUwFFjv1v7a1bjQAjSwdUaiPi9JjojBXivvTLHJkO6+ll4GT8Ghc
         m4/MgSddbFsriGMMZ+avMc7K0HlBlyJU+uKEFXcLh6wkVNKc+wbLmWlfpl8+R5NF3I8M
         takyOyT3ZosZd4ERE+TMDmzCgp5XOHnLqRZPkuRa6Pmf4jg/17k5EkKPa53ec1Z9UWcI
         w3lbneT1IyeYjJRqrnUip3m4xn7zIumvSMkIoi6SMw1LXOXXpvjBxB3gemdqq80RmB7L
         jSvf/J/cTa1+8ehW41M0doB+D6RKJNZjebMAQCJqk5m8s9qW+Db1BQyqzuC/mMBPky46
         MgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ib8VWwHjJvggYN18BEOwzhOZqnlM4YEYxegYLVlKSo=;
        b=ABNx3w21c3aIGDMjmy+2Jx6AN7/9/wr0AtCWsHXoVRlhaNIMGZTqBEBMHjnxc8b4UF
         8nPWr0wwdToO5Eom1xOhn/X3FRwjHaEH3MRfLbPio6xhJyZau1BKx26P+z5+AIzL+imB
         RjbgWI1QAuGwqqZFgb0YA6Dyi6RsTtoesNCEB1B5jW6kSHsG4VKhFyGn9RRVzYEuJrui
         eAL5BT+uCAlWb+H2rhBBEnhW6l7+DXq/YiS2NW32wLCdpfeWe7258qLPGD0zv0FdT2Kl
         Iyd4qOdLAm2pNbeI0c1HPAsb3UoTWQn/aTeeJu/B4tngiiH2d31ABePAQ2GPKP6TIXtR
         vf6g==
X-Gm-Message-State: APjAAAUWLN5Zfr4SmrPKCplbm1jSpZv8U5SQDmD/AOJBGXL88V87JKPZ
        IiFEp1UbRztHs+iaGa7mbOeZU0oQIamnHMkqfNda
X-Google-Smtp-Source: APXvYqzIh7t+mGR5KHWmesjgjSlqpj0MLXTGXcf7rY8aVOBQpqG6xj9+VllvTVXsLbvgWVt9QS8HOh37KIMIXqFAaUs=
X-Received: by 2002:a50:a7a5:: with SMTP id i34mr1145928edc.128.1582848866078;
 Thu, 27 Feb 2020 16:14:26 -0800 (PST)
MIME-Version: 1.0
References: <0000000000003cbb40059f4e0346@google.com> <CAHC9VhQVXk5ucd3=7OC=BxEkZGGLfXv9bESX67Mr-TRmTwxjEg@mail.gmail.com>
 <17916d0509978e14d9a5e9eb52d760fa57460542.camel@redhat.com>
 <CAHC9VhQnbdJprbdTa_XcgUJaiwhzbnGMWJqHczU54UMk0AFCtw@mail.gmail.com> <CACT4Y+azQXLcPqtJG9zbj8hxqw4jE3dcwUj5T06bdL3uMaZk+Q@mail.gmail.com>
In-Reply-To: <CACT4Y+azQXLcPqtJG9zbj8hxqw4jE3dcwUj5T06bdL3uMaZk+Q@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 27 Feb 2020 19:14:15 -0500
Message-ID: <CAHC9VhRRDJzyene2_40nhnxRV_ufgyaU=RrFxYGsnxR4Z_AWWw@mail.gmail.com>
Subject: Re: kernel panic: audit: backlog limit exceeded
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Paris <eparis@redhat.com>,
        syzbot <syzbot+9a5e789e4725b9ef1316@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Miller <davem@davemloft.net>, fzago@cray.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        john.hammond@intel.com, linux-audit@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev <netdev@vger.kernel.org>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 10:40 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> On Mon, Feb 24, 2020 at 11:47 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Mon, Feb 24, 2020 at 5:43 PM Eric Paris <eparis@redhat.com> wrote:
> > > https://syzkaller.appspot.com/x/repro.syz?x=151b1109e00000 (the
> > > reproducer listed) looks like it is literally fuzzing the AUDIT_SET.
> > > Which seems like this is working as designed if it is setting the
> > > failure mode to 2.
> >
> > So it is, good catch :)  I saw the panic and instinctively chalked
> > that up to a mistaken config, not expecting that it was what was being
> > tested.
>
> Yes, this audit failure mode is quite unpleasant for fuzzing. And
> since this is not a top-level syscall argument value, it's effectively
> impossible to filter out in the fuzzer. Maybe another use case for the
> "fuzer lockdown" feature +Tetsuo proposed.
> With the current state of the things, I think we only have an option
> to disable fuzzing of audit. Which is pity because it has found 5 or
> so real bugs in audit too.
> But this happened anyway because audit is only reachable from init pid
> namespace and syzkaller always unshares pid namespace for sandboxing
> reasons, that was removed accidentally and that's how it managed to
> find the bugs. But the unshare is restored now:
> https://github.com/google/syzkaller/commit/5e0e1d1450d7c3497338082fc28912fdd7f93a3c
>
> As a side effect all other real bugs in audit will be auto-obsoleted
> in future if not fixed because they will stop happening.

On the plus side, I did submit fixes for the other real audit bugs
that syzbot found recently and Linus pulled them into the tree today
so at least we have that small victory.

We could consider adding a fuzz-friendly build time config which would
disable the panic failsafe, but it probably isn't worth it at the
moment considering the syzbot's pid namespace limitations.

-- 
paul moore
www.paul-moore.com
