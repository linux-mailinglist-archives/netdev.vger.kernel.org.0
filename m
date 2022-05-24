Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3E153205B
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 03:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiEXBsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 21:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiEXBsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 21:48:03 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04177093F;
        Mon, 23 May 2022 18:48:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6cXY58Kpz4xXg;
        Tue, 24 May 2022 11:47:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1653356880;
        bh=K1+revtH/yv0Qrw2WEGJdkSco7dLfoks/ykFPLpkllA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VdzKFCZzKZYHAMW/GlIgod3jp04n1EdFzULjxFha9Yr3cCMoPn8uE6POS/ZhIw12L
         Iu8moSpWKqx3uTjGIc+QtwJfA9dzcdNKLNm6R+OeWuaq+ze+DCYcHkokMUI2JqTKyg
         vfz7WsfEHvEKJXPEs1TqnonZmiTx2dxHCvfOIoiL6Z7xK/0umxkxzQAmJJ6HHoVjbH
         ddw9Plx2Hza9grT+R9FvnKY3f4t1rHrTIsFKexngOoGuus3mscu19GieaEb+/NIn7k
         OJEyK+L3en2dC++/SOcG3+YkKnwwXOMMhTWn3LXv8N5RMG+h2p8a6qt3UjM7gKIrW5
         3lQOxWYhze5+Q==
Date:   Tue, 24 May 2022 11:47:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Yan Zhu <zhuyan34@huawei.com>,
        tangmeng <tangmeng@uniontech.com>
Subject: Re: linux-next: manual merge of the tip tree with the bpf-next,
 sysctl trees
Message-ID: <20220524114756.7cf12f51@canb.auug.org.au>
In-Reply-To: <20220414112812.652190b5@canb.auug.org.au>
References: <20220414112812.652190b5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.jZxa_kqH6=AjqA_rdVtqsZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.jZxa_kqH6=AjqA_rdVtqsZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 14 Apr 2022 11:29:05 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the tip tree got a conflict in:
>=20
>   kernel/sysctl.c
>=20
> between commit:
>=20
>   2900005ea287 ("bpf: Move BPF sysctls from kernel/sysctl.c to BPF core")
>=20
> from the bpf-next, sysctl trees and commit:
>=20
>   efaa0227f6c6 ("timers: Move timer sysctl into the timer code")
>=20
> from the tip tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc kernel/sysctl.c
> index 47139877f62d,5b7b1a82ae6a..000000000000
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@@ -2227,17 -2288,24 +2227,6 @@@ static struct ctl_table kern_table[] =
=3D=20
>   		.extra1		=3D SYSCTL_ZERO,
>   		.extra2		=3D SYSCTL_ONE,
>   	},
> - #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ_COMMON)
>  -#ifdef CONFIG_BPF_SYSCALL
> --	{
> - 		.procname	=3D "timer_migration",
> - 		.data		=3D &sysctl_timer_migration,
> - 		.maxlen		=3D sizeof(unsigned int),
>  -		.procname	=3D "unprivileged_bpf_disabled",
>  -		.data		=3D &sysctl_unprivileged_bpf_disabled,
>  -		.maxlen		=3D sizeof(sysctl_unprivileged_bpf_disabled),
> --		.mode		=3D 0644,
> - 		.proc_handler	=3D timer_migration_handler,
>  -		.proc_handler	=3D bpf_unpriv_handler,
> --		.extra1		=3D SYSCTL_ZERO,
> - 		.extra2		=3D SYSCTL_ONE,
>  -		.extra2		=3D SYSCTL_TWO,
>  -	},
>  -	{
>  -		.procname	=3D "bpf_stats_enabled",
>  -		.data		=3D &bpf_stats_enabled_key.key,
>  -		.maxlen		=3D sizeof(bpf_stats_enabled_key),
>  -		.mode		=3D 0644,
>  -		.proc_handler	=3D bpf_stats_handler,
> --	},
> --#endif
>   #if defined(CONFIG_TREE_RCU)
>   	{
>   		.procname	=3D "panic_on_rcu_stall",

This is now a conflict between the tip tree and the net-next and sysctl tre=
es.

--=20
Cheers,
Stephen Rothwell

--Sig_/.jZxa_kqH6=AjqA_rdVtqsZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKMOUwACgkQAVBC80lX
0GxKdAf/VCapTkpdl2TaeRrxWy6kUnx1mUsopvgKxcTGlBtnTkjj4IjJxpxpzV2K
06qL9ivblASgnykiDHGdf3viUrVdkqVIxQahO2PO6BW9ZFAcWo4y7odNTPDViQUM
wqbGX3JtiJ98CAcMzZHbTYu29MFjMVmBOe1fpC4zsC/iDZoVCn3rNnxSf+lppsvo
n9zdrCafsonn2Q1NC3GfpikS3YvZESgeOteHtP/9MMLHw+o6cDVlgqMD7SNvZQrM
sFpiZO2TQ1PQunZ6W1ikN8DQPHlckXT4xRkv6BDgHKqW/FNf0rsLvZGouM7QpjVJ
nMqaakNeTv15xhlxO/SXx1SM32YUgw==
=+mp5
-----END PGP SIGNATURE-----

--Sig_/.jZxa_kqH6=AjqA_rdVtqsZ--
