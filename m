Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 269C22150FD
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 03:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgGFBn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 21:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbgGFBnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 21:43:25 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB7FC061794;
        Sun,  5 Jul 2020 18:43:24 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B0SyH0ln5z9sDX;
        Mon,  6 Jul 2020 11:43:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1593999800;
        bh=1G1w5foTPLzMSqkizEB3dQQHU9BJDlBNIyWwFvDqBAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rzpt9LG7+GqSloMm8kCKK+WEro1KxFTa4K848rXPwc+NR6l0vC2E+xv5nmTErtOf3
         jCH/UEqf5SsgmbczNWS34KWzyCGqJIAlqae4MUb68fHBbZwm4edHRUe0SIb3piVUBz
         Wyk3AaTWP7eoO1Fm0vuZQP9wpEnDUDD78bbHYRGSWkmhiNm433p7bylRX5U/4mWaTE
         IVkBTejGm52v7VvYDlQwexAatfZPy/Pnszz8kIBsq1y0bwuxh3AqmSRJGdxDWuYzvt
         GgDG6s3hFkRV/iurCq7H3WTy04JlYxr10OgvB1Ayq+hvF8TxxW2oXEhV8j2sUn2Mvw
         wBbGayX+G+RZA==
Date:   Mon, 6 Jul 2020 11:43:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20200706114316.400be49e@canb.auug.org.au>
In-Reply-To: <20200626100527.4dad8695@canb.auug.org.au>
References: <20200626100527.4dad8695@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/23I18qynHUoHQ.hO=eYNg5E";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/23I18qynHUoHQ.hO=eYNg5E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 26 Jun 2020 10:05:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
>=20
> between commits:
>=20
>   9c82a63cf370 ("libbpf: Fix CO-RE relocs against .text section")
>   647b502e3d54 ("selftests/bpf: Refactor some net macros to bpf_tracing_n=
et.h")
>=20
> from the bpf tree and commit:
>=20
>   84544f5637ff ("selftests/bpf: Move newer bpf_iter_* type redefining to =
a new header file")
>=20
> from the bpf-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> index 75ecf956a2df,cec82a419800..000000000000
> --- a/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
> @@@ -11,21 -7,7 +7,7 @@@
>  =20
>   char _license[] SEC("license") =3D "GPL";
>  =20
> - #define sk_rmem_alloc	sk_backlog.rmem_alloc
> - #define sk_refcnt	__sk_common.skc_refcnt
> -=20
> - struct bpf_iter_meta {
> - 	struct seq_file *seq;
> - 	__u64 session_id;
> - 	__u64 seq_num;
> - } __attribute__((preserve_access_index));
> -=20
> - struct bpf_iter__netlink {
> - 	struct bpf_iter_meta *meta;
> - 	struct netlink_sock *sk;
> - } __attribute__((preserve_access_index));
> -=20
>  -static inline struct inode *SOCK_INODE(struct socket *socket)
>  +static __attribute__((noinline)) struct inode *SOCK_INODE(struct socket=
 *socket)
>   {
>   	return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
>   }

This is now a conflict between net-next tree and the net tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/23I18qynHUoHQ.hO=eYNg5E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8CgbQACgkQAVBC80lX
0GwXaAf/WSMHGgauwreog5bZWHBRaI8CKhxEYFjH80ugpyBm2n9o168kfOIjw3u/
JNFCWFAaSl3eM1ry6r9bl8PShzyHMdEpuYXr1DUTn+6UQvuYXD7JpLR8NAm8Snha
ik2AOAkPWe4soJ9XbuooNuLDEeozXLgNsIkgBO+1/lHHu5EgGskoPexGaMvLyAlu
YDsIQ9iv8kcjXXxJiA+wXy4XhTbL3Yl/IYXiWenvWy3lkIDc+7VDV248o5V4vXKb
sWSQzxz2EDEEq6cdgqHcnQ0HUAk4f4j8u0ppnZ11kjH1UE1qAE4+6MDhOWF+Qi9o
ht9wzCNyje1AVKE46szGqt6t1A8RSQ==
=JZE7
-----END PGP SIGNATURE-----

--Sig_/23I18qynHUoHQ.hO=eYNg5E--
