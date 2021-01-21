Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAAC2FDE4A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733145AbhAUA6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 19:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:32920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391502AbhAUAaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 19:30:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A78E23718;
        Thu, 21 Jan 2021 00:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611188942;
        bh=YviS6wcD8qodEVL7bcQvnfWIRloA0ZO1RwusiRPlszI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=at9Gl7Duyq6qDuy9SYM34EL334Nab8vvyKn6y2t/lQI85AIw0CWblxPwby/AiBmLR
         H0ghZFZgCaqG3m5gcTI0ovxqPJUfsAk/fh561O6rviqpn7pYVtJL8Qg7EzBXnfwOMZ
         M/VImkOrnl12MMbXc7kA6O3AkVUnsAlofcm7fc3/5dyZM3uo+U1aNQbLaj1NvI8d5B
         Fo3rIl4az8DSnZgcwupdhDq/xcofqCmmJrnOiWN3tMNofebeewSevItfn4h6nG0xPN
         MR/kXIm9lafi0mmWB6UVwDNzjBk42iRhIF2ltEfsUCirhAizwp0/fI8uL5qzDRWaR7
         YTUv8jHxeViUg==
Date:   Wed, 20 Jan 2021 16:29:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Giacinto Cifelli <gciofono@gmail.com>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Reinhard Speyerer <rspmn@t-online.de>, netdev@vger.kernel.org,
        rspmn@arcor.de
Subject: Re: [PATCH] net: usb: qmi_wwan: added support for Thales Cinterion
 PLSx3 modem family
Message-ID: <20210120162901.694388de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKSBH7ENRJCbkuq2HviDc-RiH8qh9u+oU5c=uNWoNKofCgs95A@mail.gmail.com>
References: <20210118054611.15439-1-gciofono@gmail.com>
        <20210118115250.GA1428@t-online.de>
        <87a6t6j6vn.fsf@miraculix.mork.no>
        <CAKSBH7HbaVxyZJRuZPv+t2uBipZAkAYTcyJwRDy-UTB_sD4SJA@mail.gmail.com>
        <87mtx3agza.fsf@miraculix.mork.no>
        <CAKSBH7ENRJCbkuq2HviDc-RiH8qh9u+oU5c=uNWoNKofCgs95A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 15:37:59 +0100 Giacinto Cifelli wrote:
> On Wed, Jan 20, 2021 at 2:13 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
> > Giacinto Cifelli <gciofono@gmail.com> writes:
> > > Hi Bj=C3=B8rn,
> > > I have fixed and resent, but from your comment I might not have
> > > selected the right line from maintaner.pl?
> > > what I have is this:
> > > $ ./scripts/get_maintainer.pl --file drivers/net/usb/qmi_wwan.c

I always run it on the patch file formatted by git format-patch.
That way it will also make sure to list people relevant to Fixes=20
tags etc.

> > > "Bj=C3=B8rn Mork" <bjorn@mork.no> (maintainer:USB QMI WWAN NETWORK DR=
IVER)
> > > "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVER=
S)
> > > Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
> > > netdev@vger.kernel.org (open list:USB QMI WWAN NETWORK DRIVER)
> > > <<<< this seems the right one
> > > linux-usb@vger.kernel.org (open list:USB NETWORKING DRIVERS)
> > > linux-kernel@vger.kernel.org (open list)
> > >
> > > I have at the same time sent a patch for another enumeration of the
> > > same product, for cdc_ether.  In that case, I have picked the
> > > following line, which also looked the best fit:
> > >   linux-usb@vger.kernel.org (open list:USB CDC ETHERNET DRIVER)
> > >
> > > Did I misinterpret the results of the script? =20
> >
> > Yes, but I'll be the first to admit that it isn't easy.
> >
> > netdev is definitely correct, and the most important one.
> >
> > But in theory you are supposed to use all the listed addresses.  Except
> > that I don't think you need to CC David (and Jakub?) since they probably
> > read everything in netdev anyway. =20

That's fair, I've even said in the past that folks can skip CCing me.
That said with vger being flaky lately maybe it's not a bad idea after
all to CC maintainers - in case someone objects to the patch, and we
don't see it because some email deity decided to hold onto the message..

> > And I believe many (most?) people
> > leave out the linux-kernel catch-all, since it doesn't provide any extra
> > coverage for networking. At least I do.

Same, I wish get_maintainers didn't list it :/

> > Then there's the two remaining addresses.  The linux-usb list is
> > traditionally CCed on patches touching USB drivers, since the USB
> > experts are there and not necessarily in netdev.  And I'd like a copy
> > because that's the only way I'll be able to catch these patches.  I
> > don't read any of the lists regularily.
> >
> > This is my interpretation only.  I am sure there are other opinions. But
> > as usual, you cannot do anything wrong. The worst that can ever happen
> > is that you have to resend a patch or miss my review of it ;-)
> > =20
>=20
> looks like "welcome to the maze" :D
>=20
> So, the letter of the instructions would be send all, but up to you to
> leave some of them out.
> Got it.
> I am going to wait a couple of days on the off chance that my patches
> are reviewed, then I will resend.
>=20
> Thank you and regards,
> Giacinto

