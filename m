Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A7452C6A4
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiERWwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiERWwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:52:53 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D0E14C76D;
        Wed, 18 May 2022 15:52:52 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L3Stn61FBz4xYC;
        Thu, 19 May 2022 08:52:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1652914370;
        bh=hFcqQpeaD1yYwsfoGIgWqtytR6mHB/YbSEYYDRNxBbY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ae8tYABEbdx/ZRsoweomMO1gz+eVGAItH3mnegZu3mYzC51fd15I+I8oplGXHcL+q
         +PKQ9Tg9jalfTLLJCh6ixll00X7yd4cTj7Z4QPeGRdP1WaHWJCWrIryzcxYPD0BxUl
         /6q0a7syTpIWCm+tXjEnvsAT2Oo7xjQB5PR4sRjAwEsOTkxvWfPFxcfkzPgHOSAf2x
         ERYNftScW0eqKvzokGT8Sa/9c2omAtlN55D0pS8Of2HfI7t5Kaj0GX3o45M7bWjhLm
         SCCLv/dgvm0REEpmCCZDEy33c3BU7URpzjgcX1f5AAkfITPtSO+ocT8HPajOd1ViRo
         qE/mHsg/V2Q5g==
Date:   Thu, 19 May 2022 08:52:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Networking <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: linux-next: build warning after merge of the net-next tree
Message-ID: <20220519085247.4ba8284a@canb.auug.org.au>
In-Reply-To: <20220517112532.GE5118@breakpoint.cc>
References: <20220517110303.723a7148@canb.auug.org.au>
        <20220517190332.4506f7e8@canb.auug.org.au>
        <20220517112532.GE5118@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NB7+72UJCjrsjCKMy.NMG_j";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/NB7+72UJCjrsjCKMy.NMG_j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 17 May 2022 13:25:32 +0200 Florian Westphal <fw@strlen.de> wrote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >=20
> > On Tue, 17 May 2022 11:03:03 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote: =20
> > >
> > > After merging the net-next tree, today's linux-next build (powerpc
> > > ppc64_defconfig) produced this warning:
> > >=20
> > > net/netfilter/nf_conntrack_netlink.c:1717:12: warning: 'ctnetlink_dum=
p_one_entry' defined but not used [-Wunused-function]
> > >  1717 | static int ctnetlink_dump_one_entry(struct sk_buff *skb,
> > >       |            ^~~~~~~~~~~~~~~~~~~~~~~~
> > >=20
> > > Introduced by commit
> > >=20
> > >   8a75a2c17410 ("netfilter: conntrack: remove unconfirmed list") =20
> >=20
> > So for my i386 defconfig build this became on error, so I have applied
> > the following patch for today.
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Tue, 17 May 2022 18:58:43 +1000
> > Subject: [PATCH] fix up for "netfilter: conntrack: remove unconfirmed l=
ist"
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au> =20
>=20
> Thanks Stephen.
>=20
> Acked-by: Florian Westphal <fw@strlen.de>

This is still not fixed in the net-next (or the netfilter-next) tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/NB7+72UJCjrsjCKMy.NMG_j
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKFeL8ACgkQAVBC80lX
0Gxwswf/Vs9Kczh9t6wKs/dDv03h1zTg07abzK0nI7p3xkAnnS6YDpnSadcN8ZW1
aej/Aplu6w1ObQ6oSpxWiedVn1fk3M9q/FnrvzWauhD7SRkOerOqHkQ6Nj69+r4T
3vV3pEmZZXTHLH16CCtMFsXUtUdtb+29YqkdRhhT/eGaNSbK45CDT1snHoAFqGkY
7Qr8dYkYWMKq2EblmMBkxKoNvT6Yw3ffT38uVXwsUgeAcDgcB9Aa9m+SySQ8okf8
DSwl5V+fb8DRESPdT3L94Z6EjtcrqR5ix5ZSAVrxJqMD5BgCsNgUWASz3VHa4Jbc
QCct9hc7m2MgTmzL9TfjRVcXas9+Hw==
=bCvB
-----END PGP SIGNATURE-----

--Sig_/NB7+72UJCjrsjCKMy.NMG_j--
