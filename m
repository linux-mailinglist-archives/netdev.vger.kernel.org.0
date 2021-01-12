Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F96B2F35E8
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbhALQiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:38:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbhALQiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 11:38:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62DAF22EBE;
        Tue, 12 Jan 2021 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610469449;
        bh=4dILiRIa/q+BvPi0PjtzWn+Gsf5ipM3L9ekH29s9ItQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MkpnS9Uv+rHz/4Vb+nLLkJHW+cP+brLLOgt5Aj3TLu25l04jtjTqS+gtmwePLgqEq
         1EfDENZB52YjJo3ZO72XWOI0eJtmdwBWhZmtNYE6Xi5/qN10QKkPXRfZDJod1j2Tef
         Kt/c1OsXVo0r0Smnvr7Kp0Zui9g+5jGIK2VIqXcDJGTa5W19QsphhLQekjkkrS+T5F
         rfre4HQI/pIjT6CsyirF5Fn+cJi370GEK5IGminq6DqqxgGs1PuoXK3yF1SY8UzRwM
         +MHjBESLvgSilEECAEW5siuHo+PqhRdqmYtTSvcDE0rLOjOVhiyYz4YzFUGvdYu6NX
         JtFUqglAEeD+A==
Date:   Tue, 12 Jan 2021 17:37:24 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH net-next v14 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112173724.0ed8e1ec@kernel.org>
In-Reply-To: <20210112162909.GD1551@shell.armlinux.org.uk>
References: <20210111012156.27799-1-kabel@kernel.org>
        <20210111012156.27799-6-kabel@kernel.org>
        <20210112111139.hp56x5nzgadqlthw@skbuf>
        <20210112170226.3f2009bd@kernel.org>
        <20210112162909.GD1551@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 16:29:09 +0000
Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:

> On Tue, Jan 12, 2021 at 05:02:26PM +0100, Marek Beh=C3=BAn wrote:
> > > > +static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chi=
p, int port,
> > > > +					unsigned long *mask,
> > > > +					struct phylink_link_state *state)
> > > > +{
> > > > +	if (port =3D=3D 0 || port =3D=3D 9 || port =3D=3D 10) {
> > > > +		phylink_set(mask, 10000baseT_Full);
> > > > +		phylink_set(mask, 10000baseKR_Full);   =20
> > >=20
> > > I think I understand the reason for declaring 10GBase-KR support in
> > > phylink_validate, in case the PHY supports that link mode on the media
> > > side, but... =20
> >=20
> > Hmm, yes, maybe KR shouldn't be here, but then why is it in
> > mv88e6390x_phylink_validate? =20
>=20
> I'm seriously thinking about changing the phylink_validate() interface
> such that the question of which link _modes_ are supported no longer
> comes up with MAC drivers, but instead MAC drivers say what interface
> modes, speeds for each interface mode, duplexes for each speed are
> supported.

Russell, I would be happy to help with such endeavour.
