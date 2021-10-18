Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B84430F5A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 06:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhJRExe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 00:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhJRExd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 00:53:33 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91FBC06161C;
        Sun, 17 Oct 2021 21:51:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HXkwh29Rbz4xbT;
        Mon, 18 Oct 2021 15:51:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634532680;
        bh=6zAiMGt9lN3fX/YpWxecPHWsTqnDTeNDIYa0BPeLy5s=;
        h=Date:From:To:Cc:Subject:From;
        b=fW4c7a4S/JgodkeUS5uKVtw8Q4E3ao37mrDmKYENGIKvDmHGQey+1kYSbznxuC2jN
         +R1BbKYoCf20pZgPrc3++8oCq3NIEf+fKQjdkNNKuV/0iciMqpO/H4xCXXt6aySG6E
         lgblEFmvcyvR2s9cWE625J+uCGyfWrLYAdH+XaX3cQrZX0jUPc76JkTeizvxmYXR8M
         ec+oxNixp4voipZj1qrECGmfKnu5hiviVUT8EKuuFr4/nf656dnyBAiwXfo8cfIgqo
         P+s2sBOceoCxGgieQO4uTfaiLGoKAYxRitm/VByYu0zH2Wf4mpjvBQH/EEPmYzHeAM
         +VTaOnI3aknoA==
Date:   Mon, 18 Oct 2021 15:51:13 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Adam Bratschi-Kaye <ark.email@gmail.com>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Ayaan Zaidi <zaidi.ayaan@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Boris-Chengbiao Zhou <bobo1239@web.de>,
        Douglas Su <d0u9.su@outlook.com>, Finn Behrens <me@kloenk.de>,
        Fox Chen <foxhlchen@gmail.com>, Gary Guo <gary@garyguo.net>,
        Geoffrey Thomas <geofft@ldpreload.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Miguel Ojeda <ojeda@kernel.org>,
        Sumera Priyadarsini <sylphrenadin@gmail.com>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Wedson Almeida Filho <wedsonaf@google.com>,
        Yuki Okushi <jtitor@2k36.org>
Subject: linux-next: manual merge of the rust tree with the bpf-next tree
Message-ID: <20211018155113.1303fa5e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/czlDD6Zf2uoH0zh=yDxuLMx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/czlDD6Zf2uoH0zh=yDxuLMx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the rust tree got a conflict in:

  scripts/Makefile.modfinal

between commit:

  0e32dfc80bae ("bpf: Enable TCP congestion control kfunc from modules")

from the bpf-next tree and commit:

  c862c7fee526 ("Kbuild: add Rust support")

from the rust tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc scripts/Makefile.modfinal
index 1fb45b011e4b,c0842e999a75..000000000000
--- a/scripts/Makefile.modfinal
+++ b/scripts/Makefile.modfinal
@@@ -39,11 -39,12 +39,13 @@@ quiet_cmd_ld_ko_o =3D LD [M]  $
 =20
  quiet_cmd_btf_ko =3D BTF [M] $@
        cmd_btf_ko =3D 							\
- 	if [ -f vmlinux ]; then						\
+ 	if [ ! -f vmlinux ]; then					\
+ 		printf "Skipping BTF generation for %s due to unavailability of vmlinux=
\n" $@ 1>&2; \
+ 	elif $(srctree)/scripts/is_rust_module.sh $@; then 		\
+ 		printf "Skipping BTF generation for %s because it's a Rust module\n" $@=
 1>&2; \
+ 	else								\
  		LLVM_OBJCOPY=3D"$(OBJCOPY)" $(PAHOLE) -J --btf_base vmlinux $@; \
 +		$(RESOLVE_BTFIDS) -b vmlinux $@; 			\
- 	else								\
- 		printf "Skipping BTF generation for %s due to unavailability of vmlinux=
\n" $@ 1>&2; \
  	fi;
 =20
  # Same as newer-prereqs, but allows to exclude specified extra dependenci=
es

--Sig_/czlDD6Zf2uoH0zh=yDxuLMx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFs/UIACgkQAVBC80lX
0GxNKgf+OIlNISH1VEOt5ZFH7WDK6buIRBYIG2BHwHx1dUiyJMiMHktLCMlDJ36L
Z8J8FubHOY7GCUz5OC3UBISL5xq6kBvKi8/Hw0synGDkIeKXl17KP+AbBfwxwOWo
leeUZg7rXERwRjJymxwluVtqexBGkOJVN7iADHDrxPpbgHjBgsAkVi4MtgT4AQPG
RdXRE/ody2JDMd86XFJY+0gao4ruhK6EDjtFUjtmqFG969aSILrE2AzUJNypY6SD
d35lCGJwsxVQ9xhCoyQIziOfaNicJJoKe5I8dlvnGH5Vh6hE1+5qD/20QPwIZArq
mIWpExST/gS8FYz1iTuvDxgO0Vnn5Q==
=KBES
-----END PGP SIGNATURE-----

--Sig_/czlDD6Zf2uoH0zh=yDxuLMx--
