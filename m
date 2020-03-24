Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FFA190E15
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbgCXMum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:50:42 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:46999 "EHLO
        script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCXMul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:50:41 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2017-10-25 mail.cs.helsinki.fi Tue, 24 Mar 2020 14:50:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.helsinki.fi;
         h=date:from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=dkim20130528; bh=Z2ri6rjpfKtC276u5
        bnzrDNMd0JHQPOFxb9/ZlRHrFI=; b=MuvgQwf7POCcsvGIt5h6Y4vbVqG4AwwZO
        aYp67Qi2zJU9DloK9bK7p3wHkAzyXARbTxZ+YmuRsm9aWSBx2FjzeaNkkdFTN6Az
        NLN/vRJdakWsVKZMSU/evIDaglnJPNfPoj2qedLRzaAy3hdULqQmX6DHTtVDKA+H
        oMFkclNhMY=
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
  (TLS: TLSv1/SSLv3,256bits,AES256-GCM-SHA384)
  by mail.cs.helsinki.fi with ESMTPS; Tue, 24 Mar 2020 14:50:33 +0200
  id 00000000005A0146.000000005E7A0219.0000638C
Date:   Tue, 24 Mar 2020 14:50:32 +0200 (EET)
From:   "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@cs.helsinki.fi>
X-X-Sender: ijjarvin@whs-18.cs.helsinki.fi
To:     Yuchung Cheng <ycheng@google.com>
cc:     Dave Taht <dave.taht@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: Re: [RFC PATCH 28/28] tcp: AccECN sysctl documentation
In-Reply-To: <CAK6E8=cBiTo+3M4y6Jn8mEtfwjGBRLNF0-CqXZtqcSNwUE6FGw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.2003241449310.14439@whs-18.cs.helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi> <CAA93jw7_YG-KMns8UP-aTPHNjPG+A_rwWUWbt1+8i4+UNhALnA@mail.gmail.com> <alpine.DEB.2.20.2003202348250.21767@whs-18.cs.helsinki.fi>
 <CAK6E8=f=tB1Dw-ns5hOysvSbQ1VGJJ1-nLQXtxC6rfZbr5Tnww@mail.gmail.com> <alpine.DEB.2.20.2003231528460.32422@whs-18.cs.helsinki.fi> <CAK6E8=cBiTo+3M4y6Jn8mEtfwjGBRLNF0-CqXZtqcSNwUE6FGw@mail.gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=_script-25508-1585054233-0001-2"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_script-25508-1585054233-0001-2
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Mar 2020, Yuchung Cheng wrote:

> On Mon, Mar 23, 2020 at 6:34 AM Ilpo J=E4rvinen
> <ilpo.jarvinen@cs.helsinki.fi> wrote:
> >
> > On Fri, 20 Mar 2020, Yuchung Cheng wrote:
> >
> > > On Fri, Mar 20, 2020 at 3:40 PM Ilpo J=E4rvinen
> > > <ilpo.jarvinen@cs.helsinki.fi> wrote:
> > > >
> > > > On Thu, 19 Mar 2020, Dave Taht wrote:
> > > >
> > > > > On Wed, Mar 18, 2020 at 2:44 AM Ilpo J=E4rvinen <ilpo.jarvinen@=
helsinki.fi> wrote:
> > > > > >
> > > > > > From: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > > > > >
> > > > > > Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > > > > > ---
> > > > > >  Documentation/networking/ip-sysctl.txt | 12 +++++++++---
> > > > > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/Documentation/networking/ip-sysctl.txt b/Documen=
tation/networking/ip-sysctl.txt
> > > > > > index 5f53faff4e25..ecca6e1d6bea 100644
> > > > > > --- a/Documentation/networking/ip-sysctl.txt
> > > > > > +++ b/Documentation/networking/ip-sysctl.txt
> > > > > > @@ -301,15 +301,21 @@ tcp_ecn - INTEGER
> > > > > >                 0 Disable ECN.  Neither initiate nor accept E=
CN.
> > > > > >                 1 Enable ECN when requested by incoming conne=
ctions and
> > > > > >                   also request ECN on outgoing connection att=
empts.
> > > > > > -               2 Enable ECN when requested by incoming conne=
ctions
> > > > > > +               2 Enable ECN or AccECN when requested by inco=
ming connections
> > > > > >                   but do not request ECN on outgoing connecti=
ons.
> > > > >
> > > > > Changing existing user-behavior for this default seems to be ov=
erly
> > > > > optimistic. Useful for testing, but...
> > > >
> > > > I disagree.
> > > >
> > > > The kernel default on ECN is/has been "do nothing" like forever. =
Yet,
> > > > passively allowing ECN on servers is a low risk operation because =
nothing
> > > > will change before client actively asks for it. However, it was o=
bvious
> > > > that the servers didn't do that. The servers could have set tcp_e=
cn to 1
> > > > (before 2 was there) which is low risk for _servers_ (unlike for =
clients)
> > > > but only very very few did. I don't believe servers would now
> > > > intentionally pick 2 when they clearly didn't pick 1 earlier eith=
er.
> > > >
> > > > Adding 2 is/was an attempt to side-step the need for both ends to =
make
> > > > conscious decision by setting the sysctl (which servers didn't wa=
nt to
> > > > do). That is, 2 gives decision on what to do into the hands of th=
e client
> > > > side which was the true intent of 2 (in case you don't know, I ma=
de that
> > > > change).
> > > What can a server configure to process only RFC3168 ECN if it prefe=
rs to?
> >
> > That's why I suggested the flag-based approach?
>=20
> That's assuming an admin that has control of sysctls can also change
> individual applications (easily). In reality it often is not the case.
> The default sysctl choices in this patch seem risky to me.
>=20
> > > > If "full control" is the way to go, I think it should be made usi=
ng flags
> > > > instead, along these lines:
> > > >
> > > > 1: Enable RFC 3168 ECN in+out
> > > > 2: Enable RFC 3168 ECN in (default on)
> > > > 4: Enable Accurate ECN in (default on)
> > > > 8: Enable Accurate ECN in+out
> > > >
> > > > Note that I intentionally reversed the in and in/out order for 4&=
8
> > > > (something that couldn't be done with 1&2 to preserve meaning of =
1).
> >
> > It should address any except "out" but no "in" (the meaning of 1 cann=
ot
> > be changed I think). But out w/o in doesn't sound very useful.

So you mean you'd want to have control that is finer-grained than what th=
e
sysctls offer?


--=20
 i.
--=_script-25508-1585054233-0001-2--
