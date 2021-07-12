Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71413C60BA
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 18:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhGLQpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 12:45:41 -0400
Received: from sender11-of-o51.zoho.eu ([31.186.226.237]:21157 "EHLO
        sender11-of-o51.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbhGLQpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 12:45:40 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1626108152; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OiyN8AT3gFUIZPpAR1MwLEct414LfHqIW/4aXrjzWkBIq9yGaRHE+EDI4lg2nTxpLxr/gosVJermMfiTDBUwgbITKjjVptd1Yd0GPP6P0vt+ZxaJcHTGderg4yU7+2Wq0BrukoSfdaGAe37MC2/fvWx4fxPMIyU6Tgm0uHKU9Vc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626108152; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=i4JUEsnAfnugqN0zK6qzeoUgo7pjx+t7m+YVy6WV2Uo=; 
        b=CI2aceqYEtR4X+NrngcLNvU4Jh1tH9Oz35aVm9hmtYmPT0gOi0ZFYYGYjJNw6kZpV3BFPSKWUAHuzqZP77iJcaEvFqWPQzKueCEV3vVyQx8hWrAW6SVtXr3sTlRVdvRQkkY5evh/RK0S9icG3COuQGYj95a6MFcuVOQKZsT9hno=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1626108152;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=i4JUEsnAfnugqN0zK6qzeoUgo7pjx+t7m+YVy6WV2Uo=;
        b=RVMmOJ1yeDCUWvRDT+ogBx55iQmTqbVX8L1z+A9l6uy6YgPC4UOQjrswX8gX2HGK
        aLLsYT9tzEIISsgesiQl7m0v3dEz5Wzzk30JK2wDPbxTzUunwPKN9GAIYRWCJpHUkYx
        Q5eyQJNlpyWXQnXbIlKxcL4Z4TPIsKDV9UWeZwNU=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1626108145732269.68846825748335; Mon, 12 Jul 2021 18:42:25 +0200 (CEST)
Date:   Mon, 12 Jul 2021 18:42:25 +0200
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        =?UTF-8?Q?=22Maciej_=C5=BBenczykowski=22?= <maze@google.com>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>
Cc:     "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "David Ahern" <dsahern@gmail.com>,
        "Joel Scherpelz" <jscherpelz@google.com>
Message-ID: <17a9b993042.b90afa5f896079.1270339649529299106@shytyi.net>
In-Reply-To: <17a9af1ae30.d78790a8882744.2052315169455447705@shytyi.net>
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
 <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net> <20201218180323.625dc293@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CANP3RGfG=7nLFdL0wMUCS3W2qnD5e-m3CbV5kNyg_X2go1=MzQ@mail.gmail.com> <17a9af1ae30.d78790a8882744.2052315169455447705@shytyi.net>
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

Hello Jakub, Maciej, Yoshfuji and others,

After discussion with co-authors about this particular point "Internet Draf=
t/RFC" we think the following:=20
Indeed RFC status shows large agreement among IETF members. And that is the=
 best indicator of a maturity level.
And that is the best to implement the feature in a stable mainline kernel.

At this time VSLAAC is an individual proposal Internet Draft reflecting the=
 opinion of all authors.
It is not adopted by any IETF working group. At the same time we consider s=
ubmission to 3GPP.

The features in the kernel have optionally "Y/N/M" and status "EXPERIMENTAL=
/STABLE".
One possibility could be VSLAAC as "N", "EXPERIMENTAL" on the linux-next br=
anch.

Could you consider this possibility more?

If you doubt VSLAAC introducing non-64 bits IID lengths, then one might won=
der whether linux supports IIDs of _arbitrary length_,
as specified in the RFC 7217 with maturity level "Standards Track"?

Best regards,
Dmytro Shytyi et al.

---- On Mon, 12 Jul 2021 15:39:27 +0200 Dmytro Shytyi <dmytro@shytyi.net> w=
rote ----

 > Hello Maciej,=20
 > =20
 > =20
 > ---- On Sat, 19 Dec 2020 03:40:50 +0100 Maciej =C5=BBenczykowski <maze@g=
oogle.com> wrote ----=20
 > =20
 >  > On Fri, Dec 18, 2020 at 6:03 PM Jakub Kicinski <kuba@kernel.org> wrot=
e:=20
 >  > >=20
 >  > > It'd be great if someone more familiar with our IPv6 code could tak=
e a=20
 >  > > look. Adding some folks to the CC.=20
 >  > >=20
 >  > > On Wed, 16 Dec 2020 23:01:29 +0100 Dmytro Shytyi wrote:=20
 >  > > > Variable SLAAC [Can be activated via sysctl]:=20
 >  > > > SLAAC with prefixes of arbitrary length in PIO (randomly=20
 >  > > > generated hostID or stable privacy + privacy extensions).=20
 >  > > > The main problem is that SLAAC RA or PD allocates a /64 by the Wi=
reless=20
 >  > > > carrier 4G, 5G to a mobile hotspot, however segmentation of the /=
64 via=20
 >  > > > SLAAC is required so that downstream interfaces can be further su=
bnetted.=20
 >  > > > Example: uCPE device (4G + WI-FI enabled) receives /64 via Wirele=
ss, and=20
 >  > > > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to Load-Balancer=20
 >  > > > and /72 to wired connected devices.=20
 >  > > > IETF document that defines problem statement:=20
 >  > > > draft-mishra-v6ops-variable-slaac-problem-stmt=20
 >  > > > IETF document that specifies variable slaac:=20
 >  > > > draft-mishra-6man-variable-slaac=20
 >  > > >=20
 >  > > > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>=20
 >  > >=20
 > =20
 >  > IMHO acceptance of this should *definitely* wait for the RFC to be=20
 >  > accepted/published/standardized (whatever is the right term).=20
 > =20
 > [Dmytro]:=20
 > There is an implementation of Variable SLAAC in the OpenBSD Operating Sy=
stem.=20
 > =20
 >  > I'm not at all convinced that will happen - this still seems like a=
=20
 >  > very fresh *draft* of an rfc,=20
 >  > and I'm *sure* it will be argued about.=20
 > =20
 >  [Dmytro]=20
 > By default, VSLAAC is disabled, so there are _*no*_ impact on network be=
havior by default.=20
 > =20
 >  > This sort of functionality will not be particularly useful without=20
 >  > widespread industry=20
 > =20
 > [Dmytro]:=20
 > There are use-cases that can profit from radvd-like software and VSLAAC =
directly.=20
 > =20
 >  > adoption across *all* major operating systems (Windows, Mac/iOS,=20
 >  > Linux/Android, FreeBSD, etc.)=20
 > =20
 > [Dmytro]:=20
 > It should be considered to provide users an _*opportunity*_ to get the r=
equired feature.=20
 > Solution (as an option) present in linux is better, than _no solution_ i=
n linux.=20
 > =20
 >  > An implementation that is incompatible with the published RFC will=20
 >  > hurt us more then help us.=20
 > =20
 >  [Dmytro]:=20
 > Compatible implementation follows the recent version of document: https:=
//datatracker.ietf.org/doc/draft-mishra-6man-variable-slaac/ The sysctl usa=
ge described in the document is used in the implementation to activate/deac=
tivate VSLAAC. By default it is disabled, so there is _*no*_ impact on netw=
ork behavior by default.=20
 > =20
 >  > Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google=20
 >  >=20
 > =20
 > Take care,=20
 > Dmytro.=20
 >=20

