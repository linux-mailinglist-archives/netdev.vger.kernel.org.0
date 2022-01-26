Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6E849CBC8
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241910AbiAZOE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235083AbiAZOE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 09:04:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC76C06161C;
        Wed, 26 Jan 2022 06:04:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4859861712;
        Wed, 26 Jan 2022 14:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE84C340E3;
        Wed, 26 Jan 2022 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643205897;
        bh=X1G3E5RC6nv0bQK2BP+o99wjZZHAFV42UYZ3LvifFZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xw7RyK0mOap0SyZfZvPgW/5xrTCaSBvVCNB5C5ShMH1wHernGvwntaPvspAfsGxK7
         f5s87JI3k2JKXrKPHG759wEnkE9KQPZ8Z6O5B6h0mUcXTLixU9Mqf8Q76Va0GL+9pe
         RtFyjihdeItsBX6KQUF3V0eELF3ect+MuzcEUKICO/5tL4RGg53hjgMdPmlGfJ9tCZ
         DU5FNz5yXmCPlbRN7/8qyBsTa5X9McWQkcHGMy4Ls3rq+QQpoAHSURBSnnSug49jP7
         XuygNRiTPRVOeZRw4BAw6OB7V6IK77syAZO7htuhm0qVFxUFlz6O1dOiXRkhIZa27I
         K9rGBIss4jrpw==
Date:   Wed, 26 Jan 2022 15:04:52 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, memxor@gmail.com,
        andrii.nakryiko@gmail.com
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Message-ID: <YfFVBOXiiIOmjihm@lore-desk>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <878rv558fy.fsf@toke.dk>
 <YfEzl0wL+51wa6z7@lore-desk>
 <87bkzy3dqr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eS83k1iMUBZMkfh2"
Content-Disposition: inline
In-Reply-To: <87bkzy3dqr.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eS83k1iMUBZMkfh2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> >> > +	rcu_read_lock();
> >>=20
> >> This is not needed when the function is only being called from XDP...
> >
> > don't we need it since we do not hold the rtnl here?
>=20
> No. XDP programs always run under local_bh_disable() which "counts" as
> an rcu_read_lock(); I did some cleanup around this a while ago, see this
> commit for a longer explanation:
>=20
> 782347b6bcad ("xdp: Add proper __rcu annotations to redirect map entries")

ack, right, I missed it. I will fix it.

Regards,
Lorenzo

>=20
> -Toke
>=20

--eS83k1iMUBZMkfh2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYfFVBAAKCRA6cBh0uS2t
rDPQAPwIppnaDCSAzjBrv/uKkdbsLrDMw4hdmvLJYm3QEhxhSQEAyKQkhOVbKud1
IYUoRVkqzN+0H1zSH6gVOnk9gkuzsQk=
=F67Y
-----END PGP SIGNATURE-----

--eS83k1iMUBZMkfh2--
