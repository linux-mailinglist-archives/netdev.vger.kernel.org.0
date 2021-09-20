Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46870412BCF
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 04:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhIUCiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 22:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245504AbhIUCKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:10:33 -0400
Received: from wp441.webpack.hosteurope.de (wp441.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:85d2::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45810C14D205;
        Mon, 20 Sep 2021 11:26:11 -0700 (PDT)
Received: from [2a03:7846:b79f:101:21c:c4ff:fe1f:fd93] (helo=valdese.nms.ulrich-teichert.org); authenticated
        by wp441.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mSNzM-00027j-Q1; Mon, 20 Sep 2021 20:26:00 +0200
Received: from valdese.nms.ulrich-teichert.org (localhost [127.0.0.1])
        by valdese.nms.ulrich-teichert.org (8.15.2/8.15.2/Debian-8+deb9u1) with ESMTPS id 18KIPwvw026068
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 20:25:58 +0200
Received: (from ut@localhost)
        by valdese.nms.ulrich-teichert.org (8.15.2/8.15.2/Submit) id 18KIPsV4026066;
        Mon, 20 Sep 2021 20:25:54 +0200
Message-Id: <202109201825.18KIPsV4026066@valdese.nms.ulrich-teichert.org>
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     torvalds@linux-foundation.org (Linus Torvalds)
Date:   Mon, 20 Sep 2021 20:25:54 +0200 (CEST)
Cc:     krypton@ulrich-teichert.org (Ulrich Teichert),
        mcree@orcon.net.nz (Michael Cree),
        linux@roeck-us.net (Guenter Roeck),
        rth@twiddle.net (Richard Henderson),
        ink@jurassic.park.msu.ru (Ivan Kokshaysky),
        mattst88@gmail.com (Matt Turner),
        James.Bottomley@hansenpartnership.com (James E . J . Bottomley),
        deller@gmx.de (Helge Deller),
        davem@davemloft.net (David S . Miller),
        kuba@kernel.org (Jakub Kicinski),
        linux-alpha@vger.kernel.org (alpha),
        geert@linux-m68k.org (Geert Uytterhoeven),
        linux-kernel@vger.kernel.org (Linux Kernel Mailing List),
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org (Netdev),
        linux-sparse@vger.kernel.org (Sparse Mailing-list)
In-Reply-To: <CAHk-=wh-=tMO9iCA4v+WgPSd+Gbowe5kptwo+okahihnO2fAOA@mail.gmail.com>
From:   Ulrich Teichert <krypton@ulrich-teichert.org>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;ut@ulrich-teichert.org;1632162371;b2cd99ed;
X-HE-SMSGID: 1mSNzM-00027j-Q1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

[sorry for the late answer, I was sick yesterday with digestive
system trouble, but nothing serious, just painful....]
> On Sat, Sep 18, 2021 at 1:26 PM Ulrich Teichert
> <krypton@ulrich-teichert.org> wrote:
> >
> > I was just tinkering with it to get it compiled without warning,
> > I certainly didn't get the big picture :-/
> 
> Ok, you shamed me into some tinkering too, and I fixed a couple of
> issues with the alpha build.
> 
> The whole "pci_iounmap()" mess is not something I solved (you were
> cc'd on the email I sent out about that), but I did test a few
> different Jensen configurations and fixed a couple of uglies.
> 
> So at least _some_ Jensen configurations build cleanly once more, and
> I re-enabled JENSEN as a valid machine target.

Yes, I was able to build a minimal Jensen config without any warning
after pulling today, thanks! I think investing a bit in cleaning up
non-PCI configurations may help as soon as PCIe will be obsoleted
by the next bus system ;-)

> But if it doesn't boot, it's all fairly moot. And those things are a
> pain to debug, and if the last booting kernel was years and years ago,
> I don't think it realistically will necessarily ever be fixed.

The main trouble is that my system has only 64MB of memory and the smallest
kernel image with all drivers I need was about 105MB big. According
to: http://users.bart.nl/~geerten/FAQ-9.html
the Jensen can take up to 128MB of RAM and the required PS/2 SIMMs
with partity are still available on ebay, so I just bought 4x32 MB SIMMs.
After setting CONFIG_CC_OPTIMIZE_FOR_SIZE the kernel image was still
93MB big, but with 128MB I should be able to boot it. Let's see....

> Oh well. I have an odd love-hate relationship with alpha.
> 
> I think it's one of the worst architectures ever designed (memory
> ordering is completely broken, and the lack of byte operations in the
> original specs were a big reason for the initial problems and eventual
> failure).

I didn't had the money for an Alpha at that time, but as soon as
cheap systems were available on ebay, I took the opportunity. At the
time I bought them, I considered the Miatas (the "Personal Workstations"
from DEC) as quite fast - that must have been around 2004/2006.

> But at the same time, I really did enjoy it back in the day, and it
> _was_ the first port I did, and the first truly integrated kernel
> architecture (the original Linux m68k port that preceded it was a
> "hack up and replace" job rather than "integrate")

My experience is that each port is good for code quality, but I can
only state that for user space applications, not having done much kernel
work,

CU,
Uli
-- 
Dipl. Inf. Ulrich Teichert|e-mail: Ulrich.Teichert@gmx.de | Listening to:
Stormweg 24               |Eat Lipstick: Dirty Little Secret, The Baboon Show:
24539 Neumuenster, Germany|Work Work Work, The Bellrays: Bad Reaction
