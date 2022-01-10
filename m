Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B15F489D60
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 17:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbiAJQUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 11:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237046AbiAJQUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 11:20:08 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03253C06173F;
        Mon, 10 Jan 2022 08:20:08 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id v186so30050301ybg.1;
        Mon, 10 Jan 2022 08:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B5R6HhUQzD32a3BA4W6jykulsKBq5b9LpAGVLbzAe70=;
        b=pQ9UciFn6DTD1mNsc45kgzbGK+rYKS2DQmFnxtj3oufX1YM6lpvmEMOEebEFO/MYlM
         pa9HLRTYLi2OVfwixj084xLZco/yqjqbS6a7QvwGfb3c7rpvcKKKzTWkK11MjhB18N3m
         bAboOF7lLIbHHK4RJrybvVYJLwQ/D8KKSA69/W+zlmpvSpBXEEq2M4L/iGAGrEIa9Mi5
         stf7wD1H7hraEgl4eyJD1vqT1DUp9UXVsJHlDlDTHW34Hi0jqJZRXg9h27PPQqljWnzl
         t+U55g3Ommsl5pELAsMIS/q5w9kHTsCOikIzYX9RAwf1O6tB6lPE7/Kg+zSPp9OZtVZD
         QjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B5R6HhUQzD32a3BA4W6jykulsKBq5b9LpAGVLbzAe70=;
        b=Coh2UPLQuI059yqM6vaf2m/XqHP+2YVJh2Ulzrb45gO4ZLIERRa3Sv4Acfg/NuF9bf
         Dmnn3qwpAflEjSylFjw9g4wj5gpOW31Pls5x2cilL14NhsadjKgGp311lFxtc9I2dcF6
         6GgH5DzKo4Tk1zdA3kU14rWsrZ8bnZb8TVWt7TcpkPO18FjBHbb5FDxhBwA5v5iWnI7L
         mnQlhrNQtasAV7sLVsNo97YipkGD+VSdu8vA+qfFCNiW+uihbJIy4r9VxVl7mdBHpefj
         InuJObjLc4O6GHuGj+lPqEZLQG2ZWRQykajrsKvC4q2llPBxkAJJGiJ5qkLbe8NmxcMY
         dDqQ==
X-Gm-Message-State: AOAM533K+T17oNhXJOocot538JG7c25EzA5Fdfl8H5l0E4Z0Ewr3BJib
        VFbu3iCOgLNj4gYlMhXk4vF6i4nYs0tefe2waIY=
X-Google-Smtp-Source: ABdhPJxRONNLotc8u11ADfFqdChcCGbT9iexoQ2cJyU5sRbkjjaLtYE8fg2B6+WdvkF2A8jgtWKHt4xB+RzH2VGKISs=
X-Received: by 2002:a25:4002:: with SMTP id n2mr378234yba.547.1641831607021;
 Mon, 10 Jan 2022 08:20:07 -0800 (PST)
MIME-Version: 1.0
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
 <20220109132038.38f8ae4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <a754b7d0-8a20-9730-c439-1660994005d0@leemhuis.info>
In-Reply-To: <a754b7d0-8a20-9730-c439-1660994005d0@leemhuis.info>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Mon, 10 Jan 2022 17:19:56 +0100
Message-ID: <CAKXUXMygcVJ2v5enu-KY9_2reC6+aAk8F9q5RiwwNp4wO-prug@mail.gmail.com>
Subject: Re: Observation of a memory leak with commit 314001f0bf92 ("af_unix:
 Add OOB support")
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Rao Shoaib <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 3:02 PM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
>
> On 09.01.22 22:20, Jakub Kicinski wrote:
> > On Fri, 7 Jan 2022 07:48:46 +0100 Lukas Bulwahn wrote:
> >> Dear Rao and David,
> >>
> >>
> >> In our syzkaller instance running on linux-next,
> >> https://elisa-builder-00.iol.unh.edu/syzkaller-next/, we have been
> >> observing a memory leak in prepare_creds,
> >> https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3,
> >> for quite some time.
> >>
> >> It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220104.
> >> So, it is in mainline, was released and has not been fixed in
> >> linux-next yet.
> >>
> >> As syzkaller also provides a reproducer, we bisected this memory leak
> >> to be introduced with  commit 314001f0bf92 ("af_unix: Add OOB
> >> support").
> >>
> >> We also tested that reverting this commit on torvalds' current tree
> >> made the memory leak with the reproducer go away.
> >>
> >> Could you please have a look how your commit introduces this memory
> >> leak? We will gladly support testing your fix in case help is needed.
> >
> > Let's test the regression/bug report tracking bot :)
> >
> > #regzbot introduced: 314001f0bf92
>
> Great, thx for trying, you only did a small mistake: it lacked a caret
> (^) before the "introduced", which would have told regzbot that the
> parent mail (the one you quoted) is the one containing the report (which
> later is linked in patch descriptions of fixes and allows rezgbot to
> connect things). That's why regzbot now thinks you reported the issue
> and looks out for patches and commits that link to your mail. :-/
>
> Don't worry, I just added it properly and now mark this as duplicate:
>
> #regzbot dup-of:
> https://lore.kernel.org/lkml/CAKXUXMzZkQvHJ35nwVhcJe%2BDrtEXGw%2BeKGVD04=xRJkVUC2sPA@mail.gmail.com/
>
> Thx again for trying.
>

Thorsten, Jakub, formally this may or may not be a "regression"---as
Thorsten defines it:

It's a regression if some application or practical use case running fine on one
Linux kernel works worse or not at all with a newer version compiled using a
similar configuration.

The af_unix functionality without oob support works before
314001f0bf92 ("af_unix: Add OOB support").
The af_unix functionality without oob support works after 314001f0bf92
("af_unix: Add OOB support").
The af_unix with oob support after the new feature with 314001f0bf92
("af_unix: Add OOB support") makes a memory leak visible; we do not
know if this feature even triggers it or just makes it visible.

Now, if we disable oob support we get a kernel without an observable
memory leak. However, oob support is added by default, and this makes
this memory leak visible. So, if oob support is turned into a
non-default option or nobody ever made use of the oob support before,
it really does not count as regression at all. The oob support did not
work before and now it works but just leaks a bit of memory---it is
potentially a bug, but not a regression. Of course, maybe oob support
is also just intended to make this memory leak observable, who knows?
Then, it is not even a bug, but a feature.

Thorsten's database is still quite empty, so let us keep tracking the
progress with regzbot. I guess we cannot mark "issues" in regzbot as a
true regression or as a bug (an issue that appears with a new
feature).

Also, this reproducer is automatically generated, so it barely
qualifies as "some application or practical use case", but at best as
some derived "stress test program" or "micro benchmark".

The syzbot CI and kernel CI database are also planning to track such
things (once all databases and all the interfaces all work smoothly),
so in the long term, such issues as this one would not qualify for
regzbot. For now, many things in these pipelines are still manual and
hence, triggering and investigation is manual effort, as well as
manually informing the involved developers, which also means that
tracking remains manual effort, for which regzbot is probably the
right new tool for now.

We will learn what should go into regzbot's tracker and what should
not---as we move on in the community: various information from other
systems (syzbot, kernel CI, kernel test robot etc.) and their reports
are also still difficult to add, find, track, bisect etc.

Lukas
