Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597893C76AE
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 20:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhGMSuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 14:50:21 -0400
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21193 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhGMSuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 14:50:20 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626202033; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=jKLgsdzdkrds9CFEjXlddrPos1eRJ1B5Tm70UC0DZc8JNGTyZlX3XwZx31m/+gvPqTkyn3jfM/1fxfuIsb/1oB9nsjDQ57/gn/OZNyFCc+H/4D3hyDs+dK0JpcnugS4jo04f2+a3R+BdjIx3aEtBVEobRpseY80beAA404WjweA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626202033; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=pubkS4lXcpnfD3AAbXTRbuUCqafekmVPU/mJgKNOASk=; 
        b=WcqCESSJE530gxm4vLNJCu2hid2AV68KweAKWQVfJNqKKkI4aPKJxLmPKx3JTvctU4/AtSFFywemhHrfjLDykeex7KFgS8nJWbe0T9oXQuXBwQjbtw1EXp3TURZALb84n7YavporLJ/k6z8Ok3yxIrXbL9zfkxkDx+/2gacYJls=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1626202033;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=pubkS4lXcpnfD3AAbXTRbuUCqafekmVPU/mJgKNOASk=;
        b=YpoaXS6thLUywAn67S/HP0ts5bnrfODRwk9Q6XYnuAbCoFYThYnmcuq/mr4waA4N
        waE1WuD05uxVKVL3rrO7dG+68NM45k1IT5ksd3pWiNoRHUqjSoHucjq1tBK6kn9nh+8
        Ij+W/Jx5CnsFihBDSFqCEaOKpIMubJSc1lsn1Fzs=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 16262020266901019.786509400593; Tue, 13 Jul 2021 20:47:06 +0200 (CEST)
Date:   Tue, 13 Jul 2021 20:47:06 +0200
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Erik Kline" <ek@google.com>
Cc:     "Jakub Kicinski" <kuba@kernel.org>,
        =?UTF-8?Q?=22Maciej_=C5=BBenczykowski=22?= <maze@google.com>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "David Ahern" <dsahern@gmail.com>,
        "Joel Scherpelz" <jscherpelz@google.com>
Message-ID: <17aa131b2c0.ce91fad8967683.2218404148220256363@shytyi.net>
In-Reply-To: <CAAedzxr75CQTPCxf4uq0CcpiOpxQ_rS3-GQRxX=5ApPojSf2wQ@mail.gmail.com>
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
 <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net>
 <20201218180323.625dc293@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANP3RGfG=7nLFdL0wMUCS3W2qnD5e-m3CbV5kNyg_X2go1=MzQ@mail.gmail.com>
 <17a9af1ae30.d78790a8882744.2052315169455447705@shytyi.net> <17a9b993042.b90afa5f896079.1270339649529299106@shytyi.net> <CAAedzxr75CQTPCxf4uq0CcpiOpxQ_rS3-GQRxX=5ApPojSf2wQ@mail.gmail.com>
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

In this case, there is another possibility as well: in order to avoid
opening a race to the bottom condition, the VSLAAC code could be
modified to not permit IIDs of length shorter than 64.

What do you think about this possibility?
 =20
________________
Dmytro SHYTYI

---- On Mon, 12 Jul 2021 19:51:19 +0200 Erik Kline <ek@google.com> wrote --=
--

 > VSLAAC is indeed quite contentious in the IETF, in large part because=20
 > it enables a race to the bottom problem for which there is no solution=
=20
 > in sight.=20
 > =20
 > I don't think this should be accepted.  It's not in the same category=20
 > of some other Y/N/M things where there are issues of kernel size,=20
 > absence of some underlying physical support or not, etc.=20
 > =20
 > =20
 > On Mon, Jul 12, 2021 at 9:42 AM Dmytro Shytyi <dmytro@shytyi.net> wrote:=
=20
 > >=20
 > > Hello Jakub, Maciej, Yoshfuji and others,=20
 > >=20
 > > After discussion with co-authors about this particular point "Internet=
 Draft/RFC" we think the following:=20
 > > Indeed RFC status shows large agreement among IETF members. And that i=
s the best indicator of a maturity level.=20
 > > And that is the best to implement the feature in a stable mainline ker=
nel.=20
 > >=20
 > > At this time VSLAAC is an individual proposal Internet Draft reflectin=
g the opinion of all authors.=20
 > > It is not adopted by any IETF working group. At the same time we consi=
der submission to 3GPP.=20
 > >=20
 > > The features in the kernel have optionally "Y/N/M" and status "EXPERIM=
ENTAL/STABLE".=20
 > > One possibility could be VSLAAC as "N", "EXPERIMENTAL" on the linux-ne=
xt branch.=20
 > >=20
 > > Could you consider this possibility more?=20
 > >=20
 > > If you doubt VSLAAC introducing non-64 bits IID lengths, then one migh=
t wonder whether linux supports IIDs of _arbitrary length_,=20
 > > as specified in the RFC 7217 with maturity level "Standards Track"?=20
 > >=20
 > > Best regards,=20
 > > Dmytro Shytyi et al.=20
 > >=20
 > > ---- On Mon, 12 Jul 2021 15:39:27 +0200 Dmytro Shytyi <dmytro@shytyi.n=
et> wrote ----=20
 > >=20
 > >  > Hello Maciej,=20
 > >  >=20
 > >  >=20
 > >  > ---- On Sat, 19 Dec 2020 03:40:50 +0100 Maciej =C5=BBenczykowski <m=
aze@google.com> wrote ----=20
 > >  >=20
 > >  >  > On Fri, Dec 18, 2020 at 6:03 PM Jakub Kicinski <kuba@kernel.org>=
 wrote:=20
 > >  >  > >=20
 > >  >  > > It'd be great if someone more familiar with our IPv6 code coul=
d take a=20
 > >  >  > > look. Adding some folks to the CC.=20
 > >  >  > >=20
 > >  >  > > On Wed, 16 Dec 2020 23:01:29 +0100 Dmytro Shytyi wrote:=20
 > >  >  > > > Variable SLAAC [Can be activated via sysctl]:=20
 > >  >  > > > SLAAC with prefixes of arbitrary length in PIO (randomly=20
 > >  >  > > > generated hostID or stable privacy + privacy extensions).=20
 > >  >  > > > The main problem is that SLAAC RA or PD allocates a /64 by t=
he Wireless=20
 > >  >  > > > carrier 4G, 5G to a mobile hotspot, however segmentation of =
the /64 via=20
 > >  >  > > > SLAAC is required so that downstream interfaces can be furth=
er subnetted.=20
 > >  >  > > > Example: uCPE device (4G + WI-FI enabled) receives /64 via W=
ireless, and=20
 > >  >  > > > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to Load-Balanc=
er=20
 > >  >  > > > and /72 to wired connected devices.=20
 > >  >  > > > IETF document that defines problem statement:=20
 > >  >  > > > draft-mishra-v6ops-variable-slaac-problem-stmt=20
 > >  >  > > > IETF document that specifies variable slaac:=20
 > >  >  > > > draft-mishra-6man-variable-slaac=20
 > >  >  > > >=20
 > >  >  > > > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>=20
 > >  >  > >=20
 > >  >=20
 > >  >  > IMHO acceptance of this should *definitely* wait for the RFC to =
be=20
 > >  >  > accepted/published/standardized (whatever is the right term).=20
 > >  >=20
 > >  > [Dmytro]:=20
 > >  > There is an implementation of Variable SLAAC in the OpenBSD Operati=
ng System.=20
 > >  >=20
 > >  >  > I'm not at all convinced that will happen - this still seems lik=
e a=20
 > >  >  > very fresh *draft* of an rfc,=20
 > >  >  > and I'm *sure* it will be argued about.=20
 > >  >=20
 > >  >  [Dmytro]=20
 > >  > By default, VSLAAC is disabled, so there are _*no*_ impact on netwo=
rk behavior by default.=20
 > >  >=20
 > >  >  > This sort of functionality will not be particularly useful witho=
ut=20
 > >  >  > widespread industry=20
 > >  >=20
 > >  > [Dmytro]:=20
 > >  > There are use-cases that can profit from radvd-like software and VS=
LAAC directly.=20
 > >  >=20
 > >  >  > adoption across *all* major operating systems (Windows, Mac/iOS,=
=20
 > >  >  > Linux/Android, FreeBSD, etc.)=20
 > >  >=20
 > >  > [Dmytro]:=20
 > >  > It should be considered to provide users an _*opportunity*_ to get =
the required feature.=20
 > >  > Solution (as an option) present in linux is better, than _no soluti=
on_ in linux.=20
 > >  >=20
 > >  >  > An implementation that is incompatible with the published RFC wi=
ll=20
 > >  >  > hurt us more then help us.=20
 > >  >=20
 > >  >  [Dmytro]:=20
 > >  > Compatible implementation follows the recent version of document: h=
ttps://datatracker.ietf.org/doc/draft-mishra-6man-variable-slaac/ The sysct=
l usage described in the document is used in the implementation to activate=
/deactivate VSLAAC. By default it is disabled, so there is _*no*_ impact on=
 network behavior by default.=20
 > >  >=20
 > >  >  > Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google=
=20
 > >  >  >=20
 > >  >=20
 > >  > Take care,=20
 > >  > Dmytro.=20
 > >  >=20
 > >=20
 >=20

