Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF84A46BC28
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbhLGNK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhLGNK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 08:10:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36493C061574;
        Tue,  7 Dec 2021 05:06:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8160FCE1AA5;
        Tue,  7 Dec 2021 13:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DEEC341C3;
        Tue,  7 Dec 2021 13:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638882412;
        bh=FB4u9uEQYxXzQGT/WU6wZVuIeyO4n5dE1JxOD6X7obw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AReKIX+3b9w7AwPSPFfM9XmwumGjZrRv/sBHpdn1CeZ3zYaet7iRZ3Ux72GD+ip9B
         XNYfXaRnyJfV0RmNjz0z4s2TB9LLk4mCLNIVZ8poPeg2lG2A/vRv0sDReievDpwFlH
         VNbY9UDs5qUp8ngwwFkfUkhQgAAGnZNWRRnAdTgQ2pmvehK3A/Fqqx8BMHdzSyudr1
         HLT4Dmk/Wh67FPXV16pmoMP91ryvQ4saCp7FN14SMrjNobF09wmeyCy/zFbFg1Vh5e
         bgkQV0grRKC5Ktue0Z4/FmwPR5GkL3CFlLecgn4x3a9icYB9+snIhu9WmkfBfdy2aq
         MZEd7PslqaMNA==
Date:   Tue, 7 Dec 2021 14:06:47 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ameer Hamza <amhamza.mgc@gmail.com>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: initialize return variable on
 declaration
Message-ID: <20211207140647.6926a3e7@thinkpad>
In-Reply-To: <20211206162510.35b85e74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211206113219.17640-1-amhamza.mgc@gmail.com>
        <Ya4OP+jQYd/UwiQK@lunn.ch>
        <20211206232953.065c0dc9@thinkpad>
        <20211206162510.35b85e74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 16:25:10 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Mon, 6 Dec 2021 23:29:53 +0100 Marek Beh=C3=BAn wrote:
> > On Mon, 6 Dec 2021 14:21:03 +0100
> > Andrew Lunn <andrew@lunn.ch> wrote:
> >  =20
> > > On Mon, Dec 06, 2021 at 04:32:19PM +0500, Ameer Hamza wrote:   =20
> > > > Uninitialized err variable defined in mv88e6393x_serdes_power
> > > > function may cause undefined behaviour if it is called from
> > > > mv88e6xxx_serdes_power_down context.
> > > >=20
> > > > Addresses-Coverity: 1494644 ("Uninitialized scalar variable")
> > > >=20
> > > > Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> > > > ---
> > > >  drivers/net/dsa/mv88e6xxx/serdes.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/m=
v88e6xxx/serdes.c
> > > > index 55273013bfb5..33727439724a 100644
> > > > --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> > > > +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> > > > @@ -1507,7 +1507,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_=
chip *chip, int port, int lane,
> > > >  			    bool on)
> > > >  {
> > > >  	u8 cmode =3D chip->ports[port].cmode;
> > > > -	int err;
> > > > +	int err =3D 0;
> > > > =20
> > > >  	if (port !=3D 0 && port !=3D 9 && port !=3D 10)
> > > >  		return -EOPNOTSUPP;     =20
> > >=20
> > > Hi Marek
> > >=20
> > > This warning likely comes from cmode not being a SERDES mode, and that
> > > is not handles in the switch statementing. Do we want an
> > >=20
> > > default:
> > > 	err =3D EINVAL;
> > >=20
> > > ? =20
> >=20
> > currently all the .serdes_power() methods return 0 for non-serdes ports.
> > This is because the way it is written, these methods are not called if
> > there is not a serdes lane for a given port.
> >=20
> > For this issue with err variable undefined, to fix it we should simply
> > set int err=3D0 at the beginning of mv88e6393x_serdes_power(), to make =
it
> > behave like other serdes_power() methods do in serdes.c. =20
>=20
> Any objections to using a default case in the switch statement, tho?
> I agree with Andrew that default statement would make the reasoning
> clearer than just setting the variable at the start of the function.

No objection, just that it should be done for all the serdes_power()
methods in serdes.c.

Marek
