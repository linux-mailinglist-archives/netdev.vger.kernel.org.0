Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AE244E905
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 15:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbhKLOgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 09:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235106AbhKLOgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 09:36:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0149860F42;
        Fri, 12 Nov 2021 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636727636;
        bh=w0k16iULftrqfQDFh2ntgIt+KT+4y7wRk4QXhBGnW4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DZR4KNTszdd/N92rPjcmeQYmPn0pL4zfRDpRwFfDEoIjRWRmEUFCGd5oTzlc1tWEl
         UZv1gyxQpVb5AKNtBFRaCTv5dGBvJoZ2R26wDjbheaZi2gX9jpxsbq3u+89OeR2qYw
         tLcHDFh+9vbyFY1yugnjX+YBZAB476UhujRB/sTK3YmRAdiSVKKJDlbZMlaDZFfKog
         Lj/e1rEWfCthQYoJNkrpetLkhIV7xVEcnopWUtKrb9pzpOPUQUI5mHAtDY2kD70CuP
         O2Oq/WAe5GmqWoTJlmeLgbwnPIa1bwiJf2TBdIQ7sxrboZA1Tzf8TOOkcEXy6A88SD
         LEHpZL/ObOW7A==
Date:   Fri, 12 Nov 2021 06:33:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        linux-can@vger.kernel.org
Subject: Re: 32bit x86 build broken (was: Re: [GIT PULL] Networking for
 5.16-rc1)
Message-ID: <20211112063355.16cb9d3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHk-=wiNEdrLirAbHwJvmp_s2Kjjd5eV680hTZnbBT2gXK4QbQ@mail.gmail.com>
References: <20211111163301.1930617-1-kuba@kernel.org>
        <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
        <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAHk-=wiNEdrLirAbHwJvmp_s2Kjjd5eV680hTZnbBT2gXK4QbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 18:48:43 -0800 Linus Torvalds wrote:
> On Thu, Nov 11, 2021 at 5:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Rafael, Srinivas, we're getting 32 bit build failures after pulling back
> > from Linus today.
> >
> > make[1]: *** [/home/nipa/net/Makefile:1850: drivers] Error 2
> > make: *** [Makefile:219: __sub-make] Error 2
> > ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c: In f=
unction =E2=80=98send_mbox_cmd=E2=80=99:
> > ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:79:37=
: error: implicit declaration of function =E2=80=98readq=E2=80=99; did you =
mean =E2=80=98readl=E2=80=99? [-Werror=3Dimplicit-function-declaration]
> >    79 |                         *cmd_resp =3D readq((void __iomem *) (p=
roc_priv->mmio_base + MBOX_OFFSET_DATA));
> >       |                                     ^~~~~
> >       |                                     readl =20
>=20
> Gaah.
>=20
> The trivial fix is *probably* just a simple

To be sure - are you planning to wait for the fix to come via=20
the usual path?  We can hold applying new patches to net on the=20
off chance that you'd apply the fix directly and we can fast=20
forward again :)=20

Not that 32bit x86 matters all that much in practice, it's just=20
for preventing new errors (64b divs, mostly) from sneaking in.

I'm guessing Rafeal may be AFK for the independence day weekend.
