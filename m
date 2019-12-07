Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809FD115B82
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 08:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfLGHXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 02:23:08 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44455 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfLGHXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 02:23:08 -0500
Received: by mail-qt1-f193.google.com with SMTP id g17so3651461qtp.11
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 23:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WKRU5pSG2PRY1i50C6ckRyYjlPu0mkUgyvtTtKKNwF4=;
        b=TSgkeFFjw9IXx/DReyCPlEeIMmu0k9IyhNUDT03zvwWvvnOt4VzeW6knY8j/T4K5zc
         JMzRL2mIa03FbkvOn3Wq+DnFMm1HZiqVi23oZL63A1ZKFBqOZ942cxk6h3ZDSTnP+6mb
         tJx2BEfefiTerW4vzKLvOLGzyU6N27A0nDi0mFMcMM5BJwmnGDf7DdbI1yg1NozpJxft
         Ven48GSQ08+cKs07SJsnB7OVl7W6S0QJhBBgsgZKtiqKZfNnd6W9v0Rf/3Y9s/dEDHRC
         khXrqNPdvJnIgOAV8r8/cTFE+mCQ/KGb4nkhTKqU3htoekizxTxrYC5GouMtlWrdWiPg
         5YrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WKRU5pSG2PRY1i50C6ckRyYjlPu0mkUgyvtTtKKNwF4=;
        b=mBpZTCC+Q5ktQikBTxru/3hIlcfaFTKWt/EzimNqQSD6vOm/8QAPxB9NLffN+ovacg
         O1/VZ2xTBvRrgfMDQLyWseQWFMT8vp+opS8ibmKAYl/Zd7he91tjbiaH9P+rb0IsrJ1b
         2/fsoDenOfkOI/LJMjPCJBVz7wtla+bWSu3G9rVeZo14g69AN74PnRx2nnK2JuuDCYRh
         rRGOaBFwN60WMn7y8RD2ww3I6hW4I5dUiTCZm/ft3hOn8D3Yg/hOdewtDf5EEGPI3xEW
         frJiQTwcmT5Jy73PSHqE31FtvMiYJdqHTqy7YZInlvXGrr0m/JvoWkpzHYReP3eV8PZg
         402g==
X-Gm-Message-State: APjAAAXBvgiuTM5HGm0JfMrV4tF7swGbsW/WPoX0GY+A5rjZMcs0+Z64
        9bJwNYniEE/8Cp6FXzhsIOz4Dzqy4GpM1f4LyALhxw==
X-Google-Smtp-Source: APXvYqzADYcdsyMtAGfTGhS9VBKWgLIVQ8HeiaaMSQTOXcfnjmm1OYt8/HHEC3dw5lwpNOgSzkdKcfJ7rQeL88sn7Ro=
X-Received: by 2002:ac8:3905:: with SMTP id s5mr16470924qtb.158.1575703386571;
 Fri, 06 Dec 2019 23:23:06 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e1d639059908223b@google.com> <000000000000fdd04105990b9c93@google.com>
In-Reply-To: <000000000000fdd04105990b9c93@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 7 Dec 2019 08:22:55 +0100
Message-ID: <CACT4Y+ahbULUDLhmNxqEffU1BbAiMuZ7Da6DurdX4XwUftROmg@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in soft_cursor
To:     syzbot <syzbot+cf43fb300aa142fb024b@syzkaller.appspotmail.com>
Cc:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        DRI <dri-devel@lists.freedesktop.org>, gwshan@linux.vnet.ibm.com,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Russell Currey <ruscur@russell.cc>, stewart@linux.vnet.ibm.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 6, 2019 at 5:34 PM syzbot
<syzbot+cf43fb300aa142fb024b@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 2de50e9674fc4ca3c6174b04477f69eb26b4ee31
> Author: Russell Currey <ruscur@russell.cc>
> Date:   Mon Feb 8 04:08:20 2016 +0000
>
>      powerpc/powernv: Remove support for p5ioc2

Another weird one, I must be missing something obvious about how git
bisect works... I keep adding these to:
https://github.com/google/syzkaller/issues/1527

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1512d1bce00000
> start commit:   b0d4beaa Merge branch 'next.autofs' of git://git.kernel.or..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1712d1bce00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1312d1bce00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f07a23020fd7d21a
> dashboard link: https://syzkaller.appspot.com/bug?extid=cf43fb300aa142fb024b
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1745a90ee00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1361042ae00000
>
> Reported-by: syzbot+cf43fb300aa142fb024b@syzkaller.appspotmail.com
> Fixes: 2de50e9674fc ("powerpc/powernv: Remove support for p5ioc2")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000fdd04105990b9c93%40google.com.
