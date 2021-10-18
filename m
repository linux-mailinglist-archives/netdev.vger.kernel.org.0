Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE675432A1D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhJRXPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbhJRXPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 19:15:51 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F922C06161C;
        Mon, 18 Oct 2021 16:13:35 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HYCNX1vgPz4xd8;
        Tue, 19 Oct 2021 10:13:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634598814;
        bh=0JD4M3w968qMBzkNmzmzABvLfRCjiTJMb0zNLPTmqCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fsgTW2zSFYjdcdebjDF8Cjk1TnecVDhP5pwtLZQcegwoSSE/8zmjM4+8dXxv9eHsL
         3nV6dWfvW57syB5+e2K0tojDiIU3/AjWtalVS/uPG2SBAxtYTc9+kfUn7U5FZPOoFJ
         ynTzFPbQ2RYXHLCEl1mzYFwRuyQiSYBQlbmRiIjTce5g/iUBdF5Wfm19pUfZCWijB5
         CWx1ezrWDOvYBXSQCRhOasq4pHAyJSAeqPdANtv3BxoZ+eqiEuGPNvOx/l/HOOjNvS
         NMzqEwfOnLU4OQmL38IG10oZZMbv097ttyQ0IxbB9SdDZU8z2d7qFQhY3w8XiwdPtc
         bBsUuzyyVk0dg==
Date:   Tue, 19 Oct 2021 10:13:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the netfilter-next tree with the
 netfilter tree
Message-ID: <20211019101330.59790f64@canb.auug.org.au>
In-Reply-To: <20211015130022.51468c6d@canb.auug.org.au>
References: <20211015130022.51468c6d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TNrxAlFP+r_f.3.oxqd_ipx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/TNrxAlFP+r_f.3.oxqd_ipx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 15 Oct 2021 13:00:22 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the netfilter-next tree got a conflict in:
>=20
>   net/netfilter/ipvs/ip_vs_ctl.c
>=20
> between commit:
>=20
>   174c37627894 ("netfilter: ipvs: make global sysctl readonly in non-init=
 netns")
>=20
> from the netfilter tree and commit:
>=20
>   2232642ec3fb ("ipvs: add sysctl_run_estimation to support disable estim=
ation")
>=20
> from the netfilter-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc net/netfilter/ipvs/ip_vs_ctl.c
> index 29ec3ef63edc,cbea5a68afb5..000000000000
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@@ -4090,11 -4096,8 +4096,13 @@@ static int __net_init ip_vs_control_net
>   	tbl[idx++].data =3D &ipvs->sysctl_conn_reuse_mode;
>   	tbl[idx++].data =3D &ipvs->sysctl_schedule_icmp;
>   	tbl[idx++].data =3D &ipvs->sysctl_ignore_tunneled;
> + 	ipvs->sysctl_run_estimation =3D 1;
> + 	tbl[idx++].data =3D &ipvs->sysctl_run_estimation;
>  +#ifdef CONFIG_IP_VS_DEBUG
>  +	/* Global sysctls must be ro in non-init netns */
>  +	if (!net_eq(net, &init_net))
>  +		tbl[idx++].mode =3D 0444;
>  +#endif
>  =20
>   	ipvs->sysctl_hdr =3D register_net_sysctl(net, "net/ipv4/vs", tbl);
>   	if (ipvs->sysctl_hdr =3D=3D NULL) {

This is now a conflict between the net-next tree and the netfilter tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/TNrxAlFP+r_f.3.oxqd_ipx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFt/5oACgkQAVBC80lX
0GxLHQf/W9/BAOuvRDEH1LJ2CBoJ7+FZADcYmfCCFqYmIlTyLkvVo5gJOuZnd+A0
5pq/vZkS93qbBf5yfIQqeaQRg4ICq85r4LDTliQpdr8hjQMb+n6l0C+DQ5uHkHJ9
Ow1giWH8aiqzA4rUbOksZmmXtDDxDCsH7dxIDssVDTM5YhcWpLRAwZhewKfSnYta
YsLZXZB9iO4rcwq05PibIOwcw/7iBShDfLfGX2bAbKYKMVCXUbCmBEQc5wzSEbYl
6YLGDN+aEtNOA0AxA0ZLZOO5A1OaRgH47tYlHKidDCepKeZ0b2N7VY38wVllXynR
W/kqOHAB7OPoNY+C04/sY8Beu37etA==
=XEu3
-----END PGP SIGNATURE-----

--Sig_/TNrxAlFP+r_f.3.oxqd_ipx--
