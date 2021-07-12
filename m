Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA113C623D
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbhGLRyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232979AbhGLRyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 13:54:31 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DDAC0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 10:51:43 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id b13so30364569ybk.4
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 10:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OMC2kabsjisLxE5HZyyeVvkyZTi8tzCcXc3UVHHmK24=;
        b=FrsA4t1GW5lTydPzhp2O7Jg23vI8BXdpwU6YI3zLSb3yF4deq2pCPa5co7SZjT3Hv/
         dJCS1T1VkTazbnTRTS3xaTP13SmEBs2f1/XHmePZ34b0S6uo8DSPoQxYp/u42HJUdg0B
         3Y8/x10z+Wcy7is+Bw3E4+9lgYI7Tf5kx+kpQQpTNz+l9ucQWEUI+iBK21k5kcOpO5P/
         /RMu2Kfv1/NVAOPZTNPBVKkBqEU8135pRqVcOt1QkiSrdw0oVZqQ8ptOneMUXPHxxkHV
         x1USIgoZzyVG9lYuQ2s0dOPQZojDY3wGGjotwpcpkKpzq9vZs6e1dNwBPRn0/eVtFM7e
         meAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OMC2kabsjisLxE5HZyyeVvkyZTi8tzCcXc3UVHHmK24=;
        b=S2FpVCaHAzQSfF58HEU/gJRzsavM5YSI25RHjpAepc+hJr3/tsk/akEf9RtSUzYVy7
         olR+v32i+DQ6ZXGRvJsmQr2wPbByaS73lyP4d1VezJi9OuR4z5mrLmvGJnYjy8dWZSDa
         Lqn1Zxvdv/a83XmYOQcSP3H1wsYpyNr0nit2i1BGSCv3HKj3d++0d7bljxPECOQs0t7s
         iJD/8u5lYeGxkkW3y0VRiZGPB9JfX+H16kMU+tvtT/cPNlKoLPnhhlQEN5FmarOpi6J7
         Hvvx+15eK5o0BOV5sL9njog3pgTG3X8fmGbUe8xfCzFr+sh/CMALatBv9uattvC2q21W
         igBQ==
X-Gm-Message-State: AOAM531atdISaC8Kz+gmMyAqqVEFfoownxBEEpmi7zxicytWXa8W2BrT
        LStki0SsfqeZvRdDVvEUcATrFuPEuTm8xAUGKcxuBhjgIuU=
X-Google-Smtp-Source: ABdhPJxaPjWju60o8lrspk0nbUcpISGMptCOgmVM2sQfxuTH/NRCJDKlFMCQl6QRtL5sL8jOXlR1N+P+V64CWPodpZQ=
X-Received: by 2002:a5b:58e:: with SMTP id l14mr187913ybp.143.1626112302027;
 Mon, 12 Jul 2021 10:51:42 -0700 (PDT)
MIME-Version: 1.0
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
 <17a9af1ae30.d78790a8882744.2052315169455447705@shytyi.net> <17a9b993042.b90afa5f896079.1270339649529299106@shytyi.net>
In-Reply-To: <17a9b993042.b90afa5f896079.1270339649529299106@shytyi.net>
From:   Erik Kline <ek@google.com>
Date:   Mon, 12 Jul 2021 10:51:19 -0700
Message-ID: <CAAedzxr75CQTPCxf4uq0CcpiOpxQ_rS3-GQRxX=5ApPojSf2wQ@mail.gmail.com>
Subject: Re: [PATCH net-next V9] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Joel Scherpelz <jscherpelz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSLAAC is indeed quite contentious in the IETF, in large part because
it enables a race to the bottom problem for which there is no solution
in sight.

I don't think this should be accepted.  It's not in the same category
of some other Y/N/M things where there are issues of kernel size,
absence of some underlying physical support or not, etc.


On Mon, Jul 12, 2021 at 9:42 AM Dmytro Shytyi <dmytro@shytyi.net> wrote:
>
> Hello Jakub, Maciej, Yoshfuji and others,
>
> After discussion with co-authors about this particular point "Internet Dr=
aft/RFC" we think the following:
> Indeed RFC status shows large agreement among IETF members. And that is t=
he best indicator of a maturity level.
> And that is the best to implement the feature in a stable mainline kernel=
.
>
> At this time VSLAAC is an individual proposal Internet Draft reflecting t=
he opinion of all authors.
> It is not adopted by any IETF working group. At the same time we consider=
 submission to 3GPP.
>
> The features in the kernel have optionally "Y/N/M" and status "EXPERIMENT=
AL/STABLE".
> One possibility could be VSLAAC as "N", "EXPERIMENTAL" on the linux-next =
branch.
>
> Could you consider this possibility more?
>
> If you doubt VSLAAC introducing non-64 bits IID lengths, then one might w=
onder whether linux supports IIDs of _arbitrary length_,
> as specified in the RFC 7217 with maturity level "Standards Track"?
>
> Best regards,
> Dmytro Shytyi et al.
>
> ---- On Mon, 12 Jul 2021 15:39:27 +0200 Dmytro Shytyi <dmytro@shytyi.net>=
 wrote ----
>
>  > Hello Maciej,
>  >
>  >
>  > ---- On Sat, 19 Dec 2020 03:40:50 +0100 Maciej =C5=BBenczykowski <maze=
@google.com> wrote ----
>  >
>  >  > On Fri, Dec 18, 2020 at 6:03 PM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>  >  > >
>  >  > > It'd be great if someone more familiar with our IPv6 code could t=
ake a
>  >  > > look. Adding some folks to the CC.
>  >  > >
>  >  > > On Wed, 16 Dec 2020 23:01:29 +0100 Dmytro Shytyi wrote:
>  >  > > > Variable SLAAC [Can be activated via sysctl]:
>  >  > > > SLAAC with prefixes of arbitrary length in PIO (randomly
>  >  > > > generated hostID or stable privacy + privacy extensions).
>  >  > > > The main problem is that SLAAC RA or PD allocates a /64 by the =
Wireless
>  >  > > > carrier 4G, 5G to a mobile hotspot, however segmentation of the=
 /64 via
>  >  > > > SLAAC is required so that downstream interfaces can be further =
subnetted.
>  >  > > > Example: uCPE device (4G + WI-FI enabled) receives /64 via Wire=
less, and
>  >  > > > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to Load-Balancer
>  >  > > > and /72 to wired connected devices.
>  >  > > > IETF document that defines problem statement:
>  >  > > > draft-mishra-v6ops-variable-slaac-problem-stmt
>  >  > > > IETF document that specifies variable slaac:
>  >  > > > draft-mishra-6man-variable-slaac
>  >  > > >
>  >  > > > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
>  >  > >
>  >
>  >  > IMHO acceptance of this should *definitely* wait for the RFC to be
>  >  > accepted/published/standardized (whatever is the right term).
>  >
>  > [Dmytro]:
>  > There is an implementation of Variable SLAAC in the OpenBSD Operating =
System.
>  >
>  >  > I'm not at all convinced that will happen - this still seems like a
>  >  > very fresh *draft* of an rfc,
>  >  > and I'm *sure* it will be argued about.
>  >
>  >  [Dmytro]
>  > By default, VSLAAC is disabled, so there are _*no*_ impact on network =
behavior by default.
>  >
>  >  > This sort of functionality will not be particularly useful without
>  >  > widespread industry
>  >
>  > [Dmytro]:
>  > There are use-cases that can profit from radvd-like software and VSLAA=
C directly.
>  >
>  >  > adoption across *all* major operating systems (Windows, Mac/iOS,
>  >  > Linux/Android, FreeBSD, etc.)
>  >
>  > [Dmytro]:
>  > It should be considered to provide users an _*opportunity*_ to get the=
 required feature.
>  > Solution (as an option) present in linux is better, than _no solution_=
 in linux.
>  >
>  >  > An implementation that is incompatible with the published RFC will
>  >  > hurt us more then help us.
>  >
>  >  [Dmytro]:
>  > Compatible implementation follows the recent version of document: http=
s://datatracker.ietf.org/doc/draft-mishra-6man-variable-slaac/ The sysctl u=
sage described in the document is used in the implementation to activate/de=
activate VSLAAC. By default it is disabled, so there is _*no*_ impact on ne=
twork behavior by default.
>  >
>  >  > Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
>  >  >
>  >
>  > Take care,
>  > Dmytro.
>  >
>
