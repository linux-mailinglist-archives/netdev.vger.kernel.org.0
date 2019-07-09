Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFD062F1A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfGID4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:56:41 -0400
Received: from ozlabs.org ([203.11.71.1]:44651 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGID4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:56:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45jT5d1nkvz9s7T;
        Tue,  9 Jul 2019 13:56:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562644597;
        bh=UqZEZcZKy1f8rwwEkckMs23H6FKxwqNSg8du442vxJs=;
        h=Date:From:To:Cc:Subject:From;
        b=IP26mwXgUBuIHF8m8ouNsD+YNkYnbV2mzs7DfI8zZpvLdjOWK4b93F6aDkFJ8LLee
         FdgWRukjvbllteIjSZUM5Fs5hyg1qsTkST9t9434tHTKzsvCGIazI4WkpccLofsbeb
         j9UUTorA/q2tlKS1PrF6rNHOfKAsSXA876NzaxSH5pdp5JUR0C4GM8tzB6Xw4LJK1g
         eBwkyBQTxIla5IR5CutWnt66KVAXMQHR8j8Y591P3TuoPfWfta4WgASPg07aSz5Ed1
         mxnqQwMQnmYazgIa8zPin687oKa4Kqp+B+BM+cOjlubAvB9x84BJINk+EVU12p0WUp
         wv6m4+/0iJE/w==
Date:   Tue, 9 Jul 2019 13:56:36 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20190709135636.4d36e19f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/t_yr42Ckp5lLUP9oC59bwsp"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/t_yr42Ckp5lLUP9oC59bwsp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/infiniband/sw/siw/siw_cm.c: In function 'siw_create_listen':
drivers/infiniband/sw/siw/siw_cm.c:1978:3: error: implicit declaration of f=
unction 'for_ifa'; did you mean 'fork_idle'? [-Werror=3Dimplicit-function-d=
eclaration]
   for_ifa(in_dev)
   ^~~~~~~
   fork_idle
drivers/infiniband/sw/siw/siw_cm.c:1978:18: error: expected ';' before '{' =
token
   for_ifa(in_dev)
                  ^
                  ;
   {
   ~

Caused by commit

  6c52fdc244b5 ("rdma/siw: connection management")

from the rdma tree.  I don't know why this didn't fail after I mereged
that tree.

I have marked that driver as depending on BROKEN for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/t_yr42Ckp5lLUP9oC59bwsp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0kEHQACgkQAVBC80lX
0GxFawgAhsIcbHAnRtR3Osl3H6dREHj5GcJ/XV7LAFJ9XwRz6mPVNxy+GdROU5Hb
cxp5LmmKPZmUD95kQ0SLET7hsW6OKEgNk1lxH8veN4IGIsX+7DPSCQdRXbhtNCSY
zKQAb8oCu3S2qfQchWzKbelqegBwXvB1oEWFavi+0rZqZVx4lKlDZsxCutAeZSqL
XQHQqLTGVYhDWNtdIi4HK6F25URZ+H5G5Nlhph+RPRXhGetxELyxB8v8K6xrn2iC
o9qlFV61ox0+QO4LERGnwqwo4FsXy8W0PKFsjZvvCNdRt7M1NAAqyAVyWnLJw8Sx
XkCdOtQIjLte/LEEYxuC7rNXTHS6fg==
=LdNM
-----END PGP SIGNATURE-----

--Sig_/t_yr42Ckp5lLUP9oC59bwsp--
