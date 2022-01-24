Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4199549A4A9
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 03:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2375381AbiAYAUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 19:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385568AbiAXXsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 18:48:46 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B090C0419C8;
        Mon, 24 Jan 2022 13:44:00 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JjNlv5dl4z4yHs;
        Tue, 25 Jan 2022 08:43:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1643060636;
        bh=ZkOTg+PQZOto/jxd0gHdYNssTz91wrZxO1zggumS00Q=;
        h=Date:From:To:Cc:Subject:From;
        b=aln8qIoFF8b8KzHXY4Ci3oIfL6C1CflWgj/Rd1bbUyjAYboOiMCqSt1iMZNIgY9Mb
         2zacFBL0uPBLgFcOiLMlqUt2BkwpYgnv3Ma6eY9zdrOkRzIl2Lca4qfgff8B63wPRX
         HKxJkqTKuWGuKesruP490b6DNV6bPCulmf954D2m1UpaljwTlDbSSZ4uVLVwGKrpof
         LoRkIP7CR7mB5Wne52fRbW+FjF+mXDgHgqJn1ag8JGuqNR6QDPut905gBJvLTy9cQG
         PXd3EPgxjiyghPVMWF1h+C2AvwY1o6SX+RJ0cmNTrn4AqQnfsKLKE5te05vvbSKOLn
         cfiRVxW7Zh3Dw==
Date:   Tue, 25 Jan 2022 08:43:53 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with Linus' tree
Message-ID: <20220125084353.5fc682d9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xJqTwuSaouszgSpnNlM3wk0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/xJqTwuSaouszgSpnNlM3wk0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  include/linux/bpf_verifier.h

between commit:

  be80a1d3f9db ("bpf: Generalize check_ctx_reg for reuse with other types")

from Linus' tree and commit:

  d583691c47dc ("bpf: Introduce mem, size argument pair support for kfunc")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/bpf_verifier.h
index e9993172f892,ac4797155412..000000000000
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@@ -519,8 -519,10 +519,10 @@@ bpf_prog_offload_replace_insn(struct bp
  void
  bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 =
cnt);
 =20
 -int check_ctx_reg(struct bpf_verifier_env *env,
 -		  const struct bpf_reg_state *reg, int regno);
 +int check_ptr_off_reg(struct bpf_verifier_env *env,
 +		      const struct bpf_reg_state *reg, int regno);
+ int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg=
_state *reg,
+ 			     u32 regno);
  int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
  		   u32 regno, u32 mem_size);
 =20

--Sig_/xJqTwuSaouszgSpnNlM3wk0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHvHZoACgkQAVBC80lX
0GyjPAf/afQFcqFrWODtd6LIcDAuOpFlLbPE4b//f8oTwsJZvWIMmE8i50CFSf5u
UnAgolVEivNANlUmGfGF98sYvv06b9q0VIE63u1B2suV9J9OsFtzTtmCF9Sw8Gsi
zY8Gq8mShYOETKpwEf3deRDx6JC7sp5M7kQtg9W+75RNZfvvUvu2r0DAErxJsvhg
mR91JCR2o6QrJhRN7MsYVs506632Gc00sPx3gk32aRyEhEwmxXEGG0wbTNqcykz4
X79YDv90iopGuwofTvUPEAbDhOyyeajDgJLxALleROKh/dg6MZ9oI+0yENnJyjHR
t7GtJbtQUV+NkWJUi6q9oJ1p+Hi4lg==
=HokY
-----END PGP SIGNATURE-----

--Sig_/xJqTwuSaouszgSpnNlM3wk0--
