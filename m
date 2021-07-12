Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C0F3C5D7A
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbhGLNmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:42:38 -0400
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21113 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhGLNmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:42:37 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626097174; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=lf1e7ZrWt/HvBjWeDRXODquH8/k0SGNRPdHLPAvjosifJIPpePVOwbtCHNbzzA0MxaRNNS+3NC3HBOz1sktUBIGOklp65Tzv2mX7hh0FMgaHSKEMkmNvsUU8wYVGaJXZTepwE+HLfprTap/jNjup5T0njIwTPfJIRePeJOn/UUY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626097174; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=sO3+p2BiGNH+cys2rCSTML7KR45CWImHmNmSCcfmub8=; 
        b=lO1j4n3qNwFAe3uKxhIkKc3DRH78xXBVZHnUG4lgEiYBRKFQm78csFHUacwlQl2TTMhirqtzB6PibzRBSgJHBzsEqkUY7USlz6NxHsgVpwwSM8CvrCOOgQyqBk96B0+6QvntDvzA1o89RgEEQ9j8ehUKTXES0UkZDdzd9YgUBRs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1626097174;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=sO3+p2BiGNH+cys2rCSTML7KR45CWImHmNmSCcfmub8=;
        b=V0NYFYyFWYvVn6pU5TNQOVx/2V4NkE8QY2pYqid9fIvqpPnY0fy412gRS+x0irKn
        g2CPeZLkQie/dF22Y2Js9r3HVCycr5ofJCq7jqUfouI1PHUdDyD85a83PGtkdJy+Zy0
        wzujPA6SVSDmmzoG4gP2mgkvb94+EY3gK/gr+zg8=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1626097167924249.12009919347702; Mon, 12 Jul 2021 15:39:27 +0200 (CEST)
Date:   Mon, 12 Jul 2021 15:39:27 +0200
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     =?UTF-8?Q?=22Maciej_=C5=BBenczykowski=22?= <maze@google.com>
Cc:     "Jakub Kicinski" <kuba@kernel.org>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "David Ahern" <dsahern@gmail.com>,
        "Joel Scherpelz" <jscherpelz@google.com>
Message-ID: <17a9af1ae30.d78790a8882744.2052315169455447705@shytyi.net>
In-Reply-To: <CANP3RGfG=7nLFdL0wMUCS3W2qnD5e-m3CbV5kNyg_X2go1=MzQ@mail.gmail.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
 <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
 <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
 <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
 <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
 <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
 <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
 <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net> <20201218180323.625dc293@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANP3RGfG=7nLFdL0wMUCS3W2qnD5e-m3CbV5kNyg_X2go1=MzQ@mail.gmail.com>
Subject: Re: [PATCH net-next V9] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Maciej,


---- On Sat, 19 Dec 2020 03:40:50 +0100 Maciej =C5=BBenczykowski <maze@goog=
le.com> wrote ----

 > On Fri, Dec 18, 2020 at 6:03 PM Jakub Kicinski <kuba@kernel.org> wrote:=
=20
 > >=20
 > > It'd be great if someone more familiar with our IPv6 code could take a=
=20
 > > look. Adding some folks to the CC.=20
 > >=20
 > > On Wed, 16 Dec 2020 23:01:29 +0100 Dmytro Shytyi wrote:=20
 > > > Variable SLAAC [Can be activated via sysctl]:=20
 > > > SLAAC with prefixes of arbitrary length in PIO (randomly=20
 > > > generated hostID or stable privacy + privacy extensions).=20
 > > > The main problem is that SLAAC RA or PD allocates a /64 by the Wirel=
ess=20
 > > > carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 =
via=20
 > > > SLAAC is required so that downstream interfaces can be further subne=
tted.=20
 > > > Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless,=
 and=20
 > > > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to Load-Balancer=20
 > > > and /72 to wired connected devices.=20
 > > > IETF document that defines problem statement:=20
 > > > draft-mishra-v6ops-variable-slaac-problem-stmt=20
 > > > IETF document that specifies variable slaac:=20
 > > > draft-mishra-6man-variable-slaac=20
 > > >=20
 > > > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>=20
 > >=20

 > IMHO acceptance of this should *definitely* wait for the RFC to be=20
 > accepted/published/standardized (whatever is the right term).=20

[Dmytro]:
There is an implementation of Variable SLAAC in the OpenBSD Operating Syste=
m.
=20
 > I'm not at all convinced that will happen - this still seems like a=20
 > very fresh *draft* of an rfc,=20
 > and I'm *sure* it will be argued about.=20

 [Dmytro]
By default, VSLAAC is disabled, so there are _*no*_ impact on network behav=
ior by default.

 > This sort of functionality will not be particularly useful without=20
 > widespread industry=20

[Dmytro]:
There are use-cases that can profit from radvd-like software and VSLAAC dir=
ectly.=20

 > adoption across *all* major operating systems (Windows, Mac/iOS,=20
 > Linux/Android, FreeBSD, etc.)=20

[Dmytro]:
It should be considered to provide users an _*opportunity*_ to get the requ=
ired feature.
Solution (as an option) present in linux is better, than _no solution_ in l=
inux.=20

 > An implementation that is incompatible with the published RFC will=20
 > hurt us more then help us.=20

 [Dmytro]:
Compatible implementation follows the recent version of document: https://d=
atatracker.ietf.org/doc/draft-mishra-6man-variable-slaac/ The sysctl usage =
described in the document is used in the implementation to activate/deactiv=
ate VSLAAC. By default it is disabled, so there is _*no*_ impact on network=
 behavior by default.=20

 > Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google=20
 >=20

Take care,
Dmytro.
