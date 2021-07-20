Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610483CF4B4
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 08:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbhGTGFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 02:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbhGTGE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 02:04:59 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCB4C061574;
        Mon, 19 Jul 2021 23:45:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GTTk51m7tz9sWc;
        Tue, 20 Jul 2021 16:45:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626763534;
        bh=A3vTUNzLQ/dSKpV+4mS7Ecw8d5D8VBPyIwlPcuGY6+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tMhFlZygkcppI5W6KEnKyB6lFw641jqSfZD0w1visFPNGDCCnZH+xuDvviFVLAGcY
         dfr64gb2yfqGSQjZG8/U6FM4/VfctC7GZNvEaE+OmebHTYjGtkGwpHdDtUOmHUoQ3N
         CGCi/nu/+iHwquggcq2o3uRQjFNzLxzQKQNAR+AXFvg1hwhc7cILV0Xmx3YYeiHn3b
         lEqYp0EPAhEOu+ydjwkLCL4aNrgAhU9Qg2CDL/Ts6bL9oImd1KydXpFujIpQtdqiY1
         dwIzrodGVan6kLua+qxZWvAy5w+y0KVWKX1U8KFo7Iyac6Q4xwUSqGZRwt1Xnb1sBg
         dbg8fekdvDpbw==
Date:   Tue, 20 Jul 2021 16:45:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20210720164531.3f122a89@canb.auug.org.au>
In-Reply-To: <20210715095032.6897f1f6@canb.auug.org.au>
References: <20210715095032.6897f1f6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lT48fSUp7ookLJZB0iiHQ+E";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/lT48fSUp7ookLJZB0iiHQ+E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 15 Jul 2021 09:50:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> While compiling Linus' tree, a powerpc-allmodconfig build (and others)
> with gcc 4.9 failed like this:
>=20
> drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c: In function 'ifh_e=
ncode_bitfield':
> include/linux/compiler_types.h:328:38: error: call to '__compiletime_asse=
rt_431' declared with attribute error: Unsupported width, must be <=3D 40
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                       ^
> include/linux/compiler_types.h:309:4: note: in definition of macro '__com=
piletime_assert'
>     prefix ## suffix();    \
>     ^
> include/linux/compiler_types.h:328:2: note: in expansion of macro '_compi=
letime_assert'
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>   ^
> drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c:28:2: note: in expa=
nsion of macro 'compiletime_assert'
>   compiletime_assert(width <=3D 40, "Unsupported width, must be <=3D 40");
>   ^
>=20
> Caused by commit
>=20
>   f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
>=20
> I guess this is caused by the call to ifh_encode_bitfield() not being
> inlined.

I am still getting these failures.

--=20
Cheers,
Stephen Rothwell

--Sig_/lT48fSUp7ookLJZB0iiHQ+E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmD2cQsACgkQAVBC80lX
0Gy7cgf/XEQ1Z1IfJzG1mFqFnRZkSpqiX1sy7/P1OyK6W4Sa8SkIzBEBRcTQwGoc
0RGaqwRdhSocX1rZaaQ2sO1xjzceHeWM2HCMbt2Toy+xJl+tGvyJRf6/YMuII/hS
CX08QjZNxjNm5RnNWlY2vf9cjIkgi/tY5WNbf3GLnDWxKLlgnO3fTaNr0qZqeHqu
W4NwQYeUoPkyZMB5tTvc78pe+UE3l+DtfBWYx9BwIzuP5ahJqGj9yaEk5+vu+byh
DkFFuqN9ooKR4OXriIPxy/y//C0bGTxbMN/Ts1M7hVoujpHrTk9nl2w4Z0SqUcD0
j95bo38K3CVAaxlpJLYJ6m6TdCejQw==
=Etnj
-----END PGP SIGNATURE-----

--Sig_/lT48fSUp7ookLJZB0iiHQ+E--
