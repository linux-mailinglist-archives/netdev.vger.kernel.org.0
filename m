Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982E93F6A16
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 21:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhHXTrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 15:47:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54186 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhHXTrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 15:47:48 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CCE2B200A1;
        Tue, 24 Aug 2021 19:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629834422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=loev05j6zy0h0p4VLp+RLb5XL0nV9yIkg0bNEhCEZbI=;
        b=ASWLXAhBXFT4Kxt+mj79OyTNSLtzpZ/AF5FioOZlhDuaVGz2jIYK+z6Wd9m4M+PnP+1M8x
        INp8jFkQch2Dw2cxHm+5MPCk6+hzIWt88icI6VNU8Wb/476XRBuGUlHQsrQVZqlDHCcgJn
        nHcroExBNFkdV52QzB1mTehBeRIEC+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629834422;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=loev05j6zy0h0p4VLp+RLb5XL0nV9yIkg0bNEhCEZbI=;
        b=Wuq2p/70vYSGkneS7o+OGgJi4+VDQ13Uh+Lbt3RxndGyJl7UnzQA48kxqkpUvA34uqsOAA
        Y+rr2pZ0C0NkkgAg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C24ADA3BBC;
        Tue, 24 Aug 2021 19:47:02 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A75D5603F6; Tue, 24 Aug 2021 21:46:59 +0200 (CEST)
Date:   Tue, 24 Aug 2021 21:46:59 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, dcavalca@fb.com,
        filbranden@fb.com, michel@fb.com
Subject: Re: [PATCH ethtool 2/3] ethtool: use dummy args[] entry for no-args
 case
Message-ID: <20210824194659.6qq3h4uk7ngrgk6a@lion.mk-sys.cz>
References: <20210813171938.1127891-1-kuba@kernel.org>
 <20210813171938.1127891-3-kuba@kernel.org>
 <20210824174123.h6iispbooeqrychw@lion.mk-sys.cz>
 <20210824104323.12dce041@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3363duy7eqmlxp7b"
Content-Disposition: inline
In-Reply-To: <20210824104323.12dce041@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3363duy7eqmlxp7b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 24, 2021 at 10:43:23AM -0700, Jakub Kicinski wrote:
> On Tue, 24 Aug 2021 19:41:23 +0200 Michal Kubecek wrote:
> > On Fri, Aug 13, 2021 at 10:19:37AM -0700, Jakub Kicinski wrote:
> > > Note that this patch adds a false-positive warning with GCC 11:
> > >=20
> > > ethtool.c: In function =E2=80=98find_option=E2=80=99:
> > > ethtool.c:6082:29: warning: offset =E2=80=981=E2=80=99 outside bounds=
 of constant string [-Warray-bounds]
> > >  6082 |                         opt +=3D len + 1;
> > >       |                         ~~~~^~~~~~~~~~
> > >=20
> > > we'll never get to that code if the string is empty. =20
> >=20
> > Unless I missed something, an easy workaround should be starting the
> > loop in find_option() from 1 rather than from 0. It would IMHO even make
> > more sense as there is little point comparing the first argument against
> > the dummy args[0] entry.
>=20
> SGTM, will you commit a patch or should I send one?

I'll commit it.

Michal

--3363duy7eqmlxp7b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmElTK4ACgkQ538sG/LR
dpUXXQf/fctCzoEd2K07bYTRGEF0Ka91p+Dr3F6yNEcV+ydUbb+tI4CEhZnk3FoC
C5cPjUCvoZRPEof0B75m5/MRFmq7Jkr3Njimop+bzbZJSSovRbo35CdFNZyo1dnd
GCR5DD9ujyxzfraT57bBO2S4DuYEv0yoO1y8cB4/b19Y+kiRstmhdzyHhE/k3edS
kSML278ZJtj+zXh/ituYjL6EX8sGnCh8IB4U9PjEN0ZMxtyja0hDdIT/EjWqT7FI
n1UH86SuAsBLuUtqhS9TTIzN36aoXukSvh3Xeg0BCQLPGCDJmqvoPdCTSo+TJYw2
Kwe09czp41QvwTiyVClaKRd6WXJvVA==
=ZBfx
-----END PGP SIGNATURE-----

--3363duy7eqmlxp7b--
