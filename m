Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5321650A0
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 05:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfGKD2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 23:28:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33101 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfGKD17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 23:27:59 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45khMb6z4nz9s4Y;
        Thu, 11 Jul 2019 13:27:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562815676;
        bh=AF1YyH/59p2PdlXj1kEV8rgQSQxkXM7X3NhUx89uKKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pvQMD/53hY2AX4+FL71jwT8Uu6vSWUw/M8GGAHSPsV2idIaXU+F3+mo6cqkwdDmnq
         pz3kAQEqUqo7TKxv57QF6l5fJX7IPbLcdmPmBsRapK0+HqfHVTaw7M+GD5plYC5NEV
         IvjAuSDwPmdDb1VcKBqmB/FW8GDTkQrGXv3jzGzm9B+Qh6S3bwoAUL6fxbPRT+jEZT
         38iP1dviDC/A5OWYovbvXwCNGxu3xEmkTMeTPa365Dsxb+rIf8Zs4IKAcZSjcuO+1v
         Fy8on1JRF4o0axnQZIyIj5XasAn++nWcshew+ogRMk30VHYi7OLwwb8GCFajwKQdMv
         wixzonvTEPm1Q==
Date:   Thu, 11 Jul 2019 13:27:55 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190711132755.0d4f45c9@canb.auug.org.au>
In-Reply-To: <20190711131603.6b11b831@canb.auug.org.au>
References: <20190709135636.4d36e19f@canb.auug.org.au>
        <20190709064346.GF7034@mtr-leonro.mtl.com>
        <20190710175212.GM2887@mellanox.com>
        <20190711115054.7d7f468c@canb.auug.org.au>
        <20190711015854.GC22409@mellanox.com>
        <20190711131344.452fc064@canb.auug.org.au>
        <20190711131603.6b11b831@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lgR/euJAAvPcdiADQ4kmX/m"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/lgR/euJAAvPcdiADQ4kmX/m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 11 Jul 2019 13:16:03 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> On Thu, 11 Jul 2019 13:13:44 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > On Thu, 11 Jul 2019 02:26:27 +0000 Jason Gunthorpe <jgg@mellanox.com> w=
rote: =20
> > >
> > > On Thu, Jul 11, 2019 at 11:50:54AM +1000, Stephen Rothwell wrote:
> > >    =20
> > > > So today this failed to build after I merged the rdma tree (previou=
sly
> > > > it didn;t until after the net-next tree was merged (I assume a
> > > > dependency changed).  It failed because in_dev_for_each_ifa_rcu (and
> > > > in_dev_for_each_ifa_rtnl) is only defined in a commit in the net-ne=
xt
> > > > tree :-(     =20
> > >=20
> > > ? I'm confused..=20
> > >=20
> > > rdma.git builds fine stand alone (I hope!)   =20
> >=20
> > I have "Fixup to build SIW issue" from Leon (which switches to using
> > in_dev_for_each_ifa_rcu) included in the rmda tree merge commit because
> > without that the rdma tree would not build for me.  Are you saying that
> > I don't need that at all, now? =20
>=20
> Actually , I get it now, "Fixup to build SIW issue" is really just a
> fixup for the net-next and rdma trees merge ... OK, I will fix that up
> tomorrow.  Sorry for my confusion.

Actually, I have rewound my tree and am starting from the merge of the
rdma tree again, so hopefully it should all be good today.

--=20
Cheers,
Stephen Rothwell

--Sig_/lgR/euJAAvPcdiADQ4kmX/m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0mrLsACgkQAVBC80lX
0GzMigf+IwlW8eRSZ9yFVzhO+0aH3niLMNP7eUgPB4yVpdDGlbu/l7g3BXSDTSHC
pYNkeiuycHgr8F5K7xUDwuPtOR/8NL4PxGywtwP56cJxDj0WxIDj4aFbSbdjWK5m
AlTFbV+C2Pwcr8sSwgx4aX0u+FWSYjjWHtKnqi9MaAvQouAJR2y2+Rb7rwSp9mlw
2V3SC+hZxjKMeJ8bAwyrgCH5tZxHfTldZ6wMzIWIAJFooP3zJaGp3xY4Trau6Znb
y+tpS/Cqz/QPEUOzKVBCX/xuDE+BGojRcDFgw72RYMPFtOKCh9buXnw1SgbE7Z1W
Py2d8jKfKMvG0AYPyk/T2kT3ZQeTDA==
=gNA9
-----END PGP SIGNATURE-----

--Sig_/lgR/euJAAvPcdiADQ4kmX/m--
