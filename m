Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C351125F5
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 09:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLDIw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 03:52:26 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36177 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfLDIw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 03:52:26 -0500
Received: by mail-qk1-f196.google.com with SMTP id v19so6410007qkv.3
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 00:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eFxpjE5vqC11Qb7kVYdyl3QjT2lQv9V/mzQLuWIL6ow=;
        b=qtzjdrFqUraz67iCJUJLMgk648tBILdd6AFOARTl4AbtEz6pGnUuLD28JHPtptGCpp
         hrSw77YmYLT0+uRXl94NZbBnkUTyKqA02oZGjzw4WOOrGByi2ONdhTmOBspy3JJOIb+6
         dq/sTGBjBsgjq19la6I+K/cumYUb5sX28XQg2UtQIWCuFCjpqVLv8Dirv0yIhQCEGNBk
         odLoCo2bIbzC1rzU3BbX2Lp83PkNvKEYKmAmK375sLYvQn2Gqy4XpUZDQXTC13e2MaY7
         3l2aZ1uEsnd3TOA7uBwo7eDG+OnomdzPuOC5hQD5tylegy4HtM903gQE3UyNJhCU+ynn
         kbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eFxpjE5vqC11Qb7kVYdyl3QjT2lQv9V/mzQLuWIL6ow=;
        b=Do2F2sqR6G3h/cpHAlWgNimZDjEGFir/VuoBy2H4GUDjutU/2c/M1nSzs9QrGr3P+P
         /JGcwNPJWBT1wUx0xdIuSBuVZygm4ApXmLI8SvkSf6e0cYplhSiJwGVt6loQG+pUco8Q
         2k7m9qohPe97iKJ+HEJjms1xE+kH7iNZ42f/jIAYW/z+FVoFrGatZOfSSiIHZudf+ad4
         teUZoOnaE7YwFTQ6o2JatwrlphOCAQVhyCNFHgGTdeNOMyb9R2beJsD0dZCChkBQpnPV
         lHkx8Khtug/QJEYakeYfs6b7OOidugIY+z4PgFRuSQyD7sreVsLbwG/+9KDbSMzAIAdB
         TmrA==
X-Gm-Message-State: APjAAAWd7tOoeZusqmUNYAvE0Iu1ZHMmB4idkZGuIdl+Sb4ElKrV7sR6
        UHe14iMFw+ZpvA16twqQch4sgbbTMdRolCOjkfgrjg==
X-Google-Smtp-Source: APXvYqzom2zVNmJsnqgeX6Zl7UU1aW7YcSnWZuVSvd+8o7mht/oFU7cWZhb+CIiGCNrQewvTP6CIAxhwhVpDXOGxL40=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr1747286qkc.256.1575449544636;
 Wed, 04 Dec 2019 00:52:24 -0800 (PST)
MIME-Version: 1.0
References: <001a114372a6074e6505642b7f72@google.com> <000000000000039751059891760e@google.com>
 <CACT4Y+Yrg8JxWABi4CJgBG7GpBSCmT0DHr_eZhQA-ikLH-X5Yw@mail.gmail.com>
 <20191202183912.GC377783@localhost.localdomain> <CACT4Y+ZpZVYgA-oiE_YYC49LRA2=iTQLxOaKTA3TEYBt8KjFbw@mail.gmail.com>
 <20191203115616.GA4707@hmswarspite.think-freely.org>
In-Reply-To: <20191203115616.GA4707@hmswarspite.think-freely.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 4 Dec 2019 09:52:13 +0100
Message-ID: <CACT4Y+aRwLG2nHfzmeN=KMY6f+ihj-c73v-pdznjgz0eDDQOZg@mail.gmail.com>
Subject: Re: kernel BUG at net/core/skbuff.c:LINE! (3)
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        syzbot <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>, mvohra@vmware.com,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        William Tu <u9012063@gmail.com>,
        Vladislav Yasevich <vyasevich@gmail.com>,
        websitedesignservices4u@gmail.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 3, 2019 at 12:56 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Tue, Dec 03, 2019 at 09:42:14AM +0100, Dmitry Vyukov wrote:
> > On Mon, Dec 2, 2019 at 7:39 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > >
> > > On Sat, Nov 30, 2019 at 04:37:56PM +0100, Dmitry Vyukov wrote:
> > > > On Sat, Nov 30, 2019 at 3:50 PM syzbot
> > > > <syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com> wrote:
> > > > >
> > > > > syzbot has bisected this bug to:
> > > > >
> > > > > commit 84e54fe0a5eaed696dee4019c396f8396f5a908b
> > > > > Author: William Tu <u9012063@gmail.com>
> > > > > Date:   Tue Aug 22 16:40:28 2017 +0000
> > > > >
> > > > >      gre: introduce native tunnel support for ERSPAN
> > > > >
> > > > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=158a2f86e00000
> > > > > start commit:   f9f1e414 Merge tag 'for-linus-4.16-rc1-tag' of git://git.k..
> > > > > git tree:       upstream
> > > > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=178a2f86e00000
> > > > > console output: https://syzkaller.appspot.com/x/log.txt?x=138a2f86e00000
> > > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=34a80ee1ac29767b
> > > > > dashboard link: https://syzkaller.appspot.com/bug?extid=b2bf2652983d23734c5c
> > > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=147bfebd800000
> > > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d8d543800000
> > > > >
> > > > > Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
> > > > > Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
> > > > >
> > > > > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > > >
> > > > Humm... the repro contains syz_emit_ethernet, wonder if it's
> > > > remote-triggerable...
> > >
> > > The call trace is still from the tx path. Packet never left the system
> > > in this case.
> >
> > My understanding is that this does not necessarily mean that the
> > remote side is not involved. There is enough state on the host for L4
> > protocols, so that the remote side can mess things and then the bad
> > thing will happen with local trigger. But that local trigger can be
> > just anything trivial that everybody does.
> >
> But thats not really helpful.  Unless you see an explicit path from the receive
> side to ip6_append_data, Theres no real way for a received packet to reach this
> code, so we can't really call it remotely triggerable.
>
> My guess is, since this is coming from the rawv6_sendmsg path, that the raw
> protocol is somehow not marshaling its data in a way that ip6_append_data
> expects.

If it's in the local send path and does not use any remotely
controllable data, then this should be good enough estimation of not
being a remote attack vector.
