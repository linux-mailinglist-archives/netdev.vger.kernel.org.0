Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A7273399
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbfGXQWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:22:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34157 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfGXQWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:22:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so15255859pgc.1;
        Wed, 24 Jul 2019 09:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=8HMIhpVktcQhLcnMlnSaMxrwzTT+wDaUZPtys8u8fmw=;
        b=Nb+QKuyfZCPgjcPcKYb70rJP06rSomXYL96XBqGn5uwG+aPhQOUW7JWY+ULGJSxE4c
         NI3ItO2Y9gXpAQK0whGKfKhodO1Iz+bnSeIixWjDbzJwNo1f264USDdHmE/g034mNcUe
         Le9IOlBtvAykhqNIZeC3VigzQBzk+VHJZDHZr2E3rI9pL4iwvxexiMfVrAs99zMQZgFY
         MfncWSTWtjEUVs5K3FBLnhcPIxe/BprBx2BbAZvVh8wkhzK5ivmICs08vuvpnqKaGhgA
         O6+icuuP33Hlu1OHPvh8+kHqExvi57GSYzoO2dSODYlwt5J/4RJVaX7IiOlxYvb588D+
         8ihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=8HMIhpVktcQhLcnMlnSaMxrwzTT+wDaUZPtys8u8fmw=;
        b=qcvSd5hMAVzHl87hxdcdxnKlfimcDImOB1NNPm1gYlJVxPeEKSI+s2KBvFVJ3Oh3M9
         zvwNXd1fcZPmb0Mvk6exQ1TBqLb189D5pzcjrxHVHm217l3FMlCMJ5lW3F3ItZcdGXey
         P8tu2HVPwKZ91ZkRzI5AoU04a//GnYU7e7a4YMKy5/GvPM1Ygl5aU53HENwJM8SaSOJu
         oDDKsGpi1mfIZKRJ+Xm1D7clvL72q31Vl/F3A+Mn+qrbL7FuIcbiWYyNLEi0Eesyl3Y0
         FFkkAFn424uEK4ESKX0KhfCF2+jUZBhH74r+ggItFieVtUAXGy7Ux+xRL8KMarOBAylH
         KWMw==
X-Gm-Message-State: APjAAAXtv/vsVPhcsfvf/QLYffLCgcbfzUWPAMUckQiERTb11X/JwU+g
        IMpx+nyCvW3MmYC+aP0GuWg=
X-Google-Smtp-Source: APXvYqws5GAAL0AstDH8/4fyQ3x/GSONd0VZXKS14G9KUgQ4IflPjwyD4xUKd8HXv4SFO3MhmvN10A==
X-Received: by 2002:a63:8c0e:: with SMTP id m14mr66910923pgd.219.1563985355520;
        Wed, 24 Jul 2019 09:22:35 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b3sm61556650pfp.65.2019.07.24.09.22.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 09:22:34 -0700 (PDT)
Date:   Wed, 24 Jul 2019 09:22:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Dmitry Vyukov <dvyukov@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     syzbot <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com>,
        bpf <bpf@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        alexander.deucher@amd.com, amd-gfx@lists.freedesktop.org,
        Alexei Starovoitov <ast@kernel.org>, christian.koenig@amd.com,
        Daniel Borkmann <daniel@iogearbox.net>, david1.zhou@amd.com,
        DRI <dri-devel@lists.freedesktop.org>, leo.liu@amd.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Marco Elver <elver@google.com>
Message-ID: <5d3885c2e2e20_73c32aebc43b65c08@john-XPS-13-9370.notmuch>
In-Reply-To: <CACT4Y+ZbPmRB9T9ZzhE79VnKKD3+ieHeLpaDGRkcQ72nADKH_g@mail.gmail.com>
References: <0000000000001a51c4058ddcb1b6@google.com>
 <CACT4Y+ZGwKP+f4esJdx60AywO9b3Y5Bxb4zLtH6EEkaHpP6Zag@mail.gmail.com>
 <5d37433a832d_3aba2ae4f6ec05bc3a@john-XPS-13-9370.notmuch>
 <CACT4Y+ZbPmRB9T9ZzhE79VnKKD3+ieHeLpaDGRkcQ72nADKH_g@mail.gmail.com>
Subject: Re: kernel panic: stack is corrupted in pointer
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Vyukov wrote:
> On Tue, Jul 23, 2019 at 7:26 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Dmitry Vyukov wrote:
> > > On Wed, Jul 17, 2019 at 10:58 AM syzbot
> > > <syzbot+79f5f028005a77ecb6bb@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following crash on:
> > > >
> > > > HEAD commit:    1438cde7 Add linux-next specific files for 20190716
> > > > git tree:       linux-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=13988058600000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3430a151e1452331
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=79f5f028005a77ecb6bb
> > > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111fc8afa00000
> > >
> > > From the repro it looks like the same bpf stack overflow bug. +John
> > > We need to dup them onto some canonical report for this bug, or this
> > > becomes unmanageable.
> >
> > Fixes in bpf tree should fix this. Hopefully, we will squash this once fixes
> > percolate up.
> >
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
> 
> Cool! What is the fix?

It took a series of patches here,

https://www.spinics.net/lists/netdev/msg586986.html

The fix commits from bpf tree are,

(git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git) 

318892ac068397f40ff81d9155898da01493b1d2
ac78fc148d8249dbf382c2127456dd08ec5b161c
f87e62d45e51b12d48d2cb46b5cde8f83b866bc4
313ab004805cf52a42673b15852b3842474ccd87
32857cf57f920cdc03b5095f08febec94cf9c36b
45a4521dcbd92e71c9e53031b40e34211d3b4feb
2bb90e5cc90e1d09f631aeab041a9cf913a5bbe5
0e858739c2d2eedeeac1d35bfa0ec3cc2a7190d8
95fa145479fbc0a0c1fd3274ceb42ec03c042a4a

The last commit fixes this paticular syzbot issue,

commit 95fa145479fbc0a0c1fd3274ceb42ec03c042a4a
Author: John Fastabend <john.fastabend@gmail.com>
Date:   Fri Jul 19 10:29:22 2019 -0700

    bpf: sockmap/tls, close can race with map free

The other commits address some other issues found while testing.

> We don't need to wait for the fix to percolate up (and then down
> too!). syzbot gracefully handles when a patch is not yet present
> everywhere (it happens all the time).

Great. By the way the above should fix many of the outstanding
reports against bpf sockmap and tls side. I'll have to walk through
each one individually to double check though. I guess we can mark
them as dup reports and syzbot should sort it out?

> 
> Btw, this was due to a stack overflow, right? Or something else?

Right, stack overflow due to race in updating sock ops where build a
circular call chain.

> We are trying to make KASAN configuration detect stack overflows too,
> so that it does not cause havoc next time. But it turns out to be
> non-trivial and our current attempt seems to fail:
> https://groups.google.com/forum/#!topic/kasan-dev/IhYv7QYhLfY
> 
> 
