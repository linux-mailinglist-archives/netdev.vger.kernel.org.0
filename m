Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA72509458
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383425AbiDUAez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383417AbiDUAew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:34:52 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE04C19001;
        Wed, 20 Apr 2022 17:32:03 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KkJQ94Vv4z4xPw;
        Thu, 21 Apr 2022 10:32:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1650501122;
        bh=Hm6KZ3K5osDijgENlnBn7zUyQFG9ayBp+YN8rXKdnGQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=obn/uPWery0cOe2i78JESoY7ZrSyJ0O5qr2hxOGcBXAPjD2/hwp4qVHts2kmwCNuC
         RlDKGKfSrare2OXEG1RIVSPQSPgEAu6eOYQL7YCGgxV1BGNwyySj1tjpHYlRh5eKeO
         CF5C9oS3e7g+HpHaZIGpCxKPImyzeFlrv+T3fFVo33SFFlNSCECopCNYcLmq+MXA2B
         05PjE81HKNWC+6E4yAoGoz+I/ODJvOsoMAqciu4yls0qLlCQ8vnWKJKPvAuTZ6bfog
         hqq/+Vil6I9hyVQ7aVSm3t3ua/PRZ/os17axsPONcayXOYje7QR5NgbhHDH/P8tEUi
         4X7FMyRL5HRSw==
Date:   Thu, 21 Apr 2022 10:32:00 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20220421103200.2b4e8424@canb.auug.org.au>
In-Reply-To: <20220419115620.65580586@canb.auug.org.au>
References: <20220419115620.65580586@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/cuJo37G2y069ugpaAE+5dQs";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/cuJo37G2y069ugpaAE+5dQs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 19 Apr 2022 11:56:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the bpf-next tree, today's linux-next build
> (x86_64 allmodconfig) failed like this:
>=20
> In file included from include/linux/compiler_types.h:73,
>                  from <command-line>:
> drivers/net/ethernet/intel/i40e/i40e_xsk.c: In function 'i40e_run_xdp_zc':
> include/linux/compiler_attributes.h:222:41: error: attribute 'fallthrough=
' not preceding a case label or default label [-Werror]
>   222 | # define fallthrough                    __attribute__((__fallthro=
ugh__))
>       |                                         ^~~~~~~~~~~~~
> drivers/net/ethernet/intel/i40e/i40e_xsk.c:192:17: note: in expansion of =
macro 'fallthrough'
>   192 |                 fallthrough; /* handle aborts by dropping packet =
*/
>       |                 ^~~~~~~~~~~
> cc1: all warnings being treated as errors
> In file included from include/linux/compiler_types.h:73,
>                  from <command-line>:
> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c: In function 'ixgbe_run_xdp_=
zc':
> include/linux/compiler_attributes.h:222:41: error: attribute 'fallthrough=
' not preceding a case label or default label [-Werror]
>   222 | # define fallthrough                    __attribute__((__fallthro=
ugh__))
>       |                                         ^~~~~~~~~~~~~
> drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c:147:17: note: in expansion o=
f macro 'fallthrough'
>   147 |                 fallthrough; /* handle aborts by dropping packet =
*/
>       |                 ^~~~~~~~~~~
> cc1: all warnings being treated as errors
>=20
> Caused by commits
>=20
>   b8aef650e549 ("i40e, xsk: Terminate Rx side of NAPI when XSK Rx queue g=
ets full")
>   c7dd09fd4628 ("ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx queue =
gets full")
>=20
> I have used the bpf-next tree from next-20220414 for today.

I am still getting these failures ...

--=20
Cheers,
Stephen Rothwell

--Sig_/cuJo37G2y069ugpaAE+5dQs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJgpgAACgkQAVBC80lX
0GxxWAf+JnWmPn19kjBUxAdcW83uuTu2QDff0kqKvK6gO9EShxfcxLKmtyjJs+nX
vULA8e3A93RvxmnzJiSql16YJraVRqfBk63TNE+hUIzWdQy9F3drBoX7BuiqqBSF
65lsmUy5mZ2z9S1dLSc4JI/rhabfUXG2Nv9fyNPfTmCl5UTzw+sLqt+SyO98IkPA
1agCoF3jv5pvQQgPpiIDzeAnWhf2oZy8VUQxNKvUav73o8+f+6R5Nrdex0yQUpix
B8jbyvlyEv2SOGMfR2SGFhwUw+EkPzpJaKHyWFDpURje4WMKMTnz04F1V4mQ2F8o
WWVmsPz8AovUnAWI3xbFgVKusbalLQ==
=5Gxf
-----END PGP SIGNATURE-----

--Sig_/cuJo37G2y069ugpaAE+5dQs--
