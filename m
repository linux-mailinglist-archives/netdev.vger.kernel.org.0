Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E2E18DB46
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 23:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgCTWkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 18:40:23 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:40574 "EHLO
        script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgCTWkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 18:40:23 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2017-10-25 mail.cs.helsinki.fi Sat, 21 Mar 2020 00:40:12 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.helsinki.fi;
         h=date:from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=dkim20130528; bh=mSv7hTmPlwjg04bnE
        weNPD/YjE+aPOJCMnq5wrHVaCQ=; b=hEQIgr/d/HPPgSfeL7d9oibpvLA3jgv77
        KjpgX/rrr/L17GNuKd7TU1aty7UAeAcB3WKCy3LhZBBZquvNFYeQN/e1EjRTcoi4
        UqzjzL90rK0C+Gsl29fzj/072ntKfg/frmfZ52kKDKa9XGNslb6SPRskbOHqlyCB
        AB5Px/sedY=
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
  (TLS: TLSv1/SSLv3,256bits,AES256-GCM-SHA384)
  by mail.cs.helsinki.fi with ESMTPS; Sat, 21 Mar 2020 00:40:12 +0200
  id 00000000005A1C77.000000005E75464C.00004771
Date:   Sat, 21 Mar 2020 00:40:12 +0200 (EET)
From:   "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@cs.helsinki.fi>
X-X-Sender: ijjarvin@whs-18.cs.helsinki.fi
To:     Dave Taht <dave.taht@gmail.com>
cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: Re: [RFC PATCH 28/28] tcp: AccECN sysctl documentation
In-Reply-To: <CAA93jw7_YG-KMns8UP-aTPHNjPG+A_rwWUWbt1+8i4+UNhALnA@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.2003202348250.21767@whs-18.cs.helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1584524612-24470-29-git-send-email-ilpo.jarvinen@helsinki.fi> <CAA93jw7_YG-KMns8UP-aTPHNjPG+A_rwWUWbt1+8i4+UNhALnA@mail.gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=_script-18340-1584744012-0001-2"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_script-18340-1584744012-0001-2
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Mar 2020, Dave Taht wrote:

> On Wed, Mar 18, 2020 at 2:44 AM Ilpo J=E4rvinen <ilpo.jarvinen@helsinki=
.fi> wrote:
> >
> > From: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> >
> > Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> > ---
> >  Documentation/networking/ip-sysctl.txt | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/n=
etworking/ip-sysctl.txt
> > index 5f53faff4e25..ecca6e1d6bea 100644
> > --- a/Documentation/networking/ip-sysctl.txt
> > +++ b/Documentation/networking/ip-sysctl.txt
> > @@ -301,15 +301,21 @@ tcp_ecn - INTEGER
> >                 0 Disable ECN.  Neither initiate nor accept ECN.
> >                 1 Enable ECN when requested by incoming connections a=
nd
> >                   also request ECN on outgoing connection attempts.
> > -               2 Enable ECN when requested by incoming connections
> > +               2 Enable ECN or AccECN when requested by incoming con=
nections
> >                   but do not request ECN on outgoing connections.
>=20
> Changing existing user-behavior for this default seems to be overly
> optimistic. Useful for testing, but...

I disagree.

The kernel default on ECN is/has been "do nothing" like forever. Yet,
passively allowing ECN on servers is a low risk operation because nothing
will change before client actively asks for it. However, it was obvious=20
that the servers didn't do that. The servers could have set tcp_ecn to 1=20
(before 2 was there) which is low risk for _servers_ (unlike for clients)=20
but only very very few did. I don't believe servers would now=20
intentionally pick 2 when they clearly didn't pick 1 earlier either.

Adding 2 is/was an attempt to side-step the need for both ends to make=20
conscious decision by setting the sysctl (which servers didn't want to=20
do). That is, 2 gives decision on what to do into the hands of the client=20
side which was the true intent of 2 (in case you don't know, I made that=20
change).

Allowing the client side to make the decision alone has proven successful=20
approach. We now have significant passive RFC3168 ECN server deployment.=20
It is wide-spread enough that Apple found it useful enough for their=20
client side, experimented with it and worked to fix the issues where they=20
discovered something in the network was incompatible with ECN. I don't=20
believe it would have happened without leaving the decision into the hand=
s=20
of the clients.

Similarly, passively allowing the client to decide to use AccECN is
low risk thing. ...As with RFC 3168 ECN, "do nothing" applies also for=20
Accurate ECN here unless the client asks for it.

> > +               3 Enable AccECN when requested by incoming connection=
s and
> > +                 also request AccECN on outgoing connection attempts=
.
> > +           0x102 Enable AccECN in optionless mode for incoming conne=
ctions.
> > +           0x103 Enable AccECN in optionless mode for incoming and o=
utgoing
> > +                 connections.
>=20
> In terms of the logic bits here, it might make more sense
>=20
> 0: disable ecn
> 1: enable std ecn on in or out
> 2: enable std ecn when requested on in (the default)
> 3: essentially unused
> 4: enable accecn when requested on in
> 5: enable std ecn and accecn on in or out
> 6: enable accecn and ecn on in but not out

If "full control" is the way to go, I think it should be made using flags=20
instead, along these lines:

1: Enable RFC 3168 ECN in+out
2: Enable RFC 3168 ECN in (default on)
4: Enable Accurate ECN in (default on)
8: Enable Accurate ECN in+out

Note that I intentionally reversed the in and in/out order for 4&8=20
(something that couldn't be done with 1&2 to preserve meaning of 1).

I think it's a bit complicated though but if this is what most people=20
want, I can of course change it to flags.

> Do we have any data on how often the tcp ns bit is a source of
> firewalling problems yet?
>=20
> 0x102 strikes me as a bit more magical than required

To me it compares to some fast open cookie things that are similarly usin=
g=20
higher order bits in flag like manner.

> and I don't know
> what optionless means in this context.

Do you mean that "optionless" is not a good word to use here? (I'm not
a native speaker but I can imagine it might sound like "futureless"?)
I meant that AccECN operates then w/o sending any AccECN option (rx side=20
still processes the options if the peer chooses to send them despite not=20
getting any back).

Thanks.

--=20
 i.
--=_script-18340-1584744012-0001-2--
