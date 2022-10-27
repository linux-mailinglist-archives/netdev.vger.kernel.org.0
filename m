Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D2760ECD4
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 02:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiJ0AHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 20:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233561AbiJ0AHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 20:07:10 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BEB56B82;
        Wed, 26 Oct 2022 17:07:07 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MyQw55XbCz4x1V;
        Thu, 27 Oct 2022 11:07:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1666829223;
        bh=4QLpjDwz9lbeON7XUEXcSe5KN/9yirIHZlEgdXPZBD8=;
        h=Date:From:To:Cc:Subject:From;
        b=EgNJ8GpfX1rKI52H2eFRT4bGosFA3zxRujm3ps+HCtB1yQkMFG+7+OAt/Cx4xma9m
         IMnSAWo0khEKCc7ufsvBbDi/jeWY0U7oOTtoDV/0mTiTyTaXgzwCDqqo/IHyxgtxbl
         RLpKEnwSGY/fLtiY6HgpW9Uaeh0gsporRZ0f0FMhUkZJ2VSpq6hf8gJAypW+gJmaW7
         fRK4S/XCH3PHlVtYvHeONZCxj1OPWZG/ZfBEP69aEB4LEfK5zCjD0kYiGb3NEFnSgp
         64d5g7o8Rsj6WEM82T9pgH2X/7YtX/hYzpLss4YRYx3f0Mo1YUCKBVMegyGik4KhW2
         1izZzaWfqBApA==
Date:   Thu, 27 Oct 2022 11:07:00 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
Subject: linux-next: manual merge of the tip tree with the bpf-next tree
Message-ID: <20221027110700.110214a9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/knOGfgQCZ2MjfFsf6J2hAw+";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/knOGfgQCZ2MjfFsf6J2hAw+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in:

  arch/x86/net/bpf_jit_comp.c

between commit:

  271de525e1d7 ("bpf: Remove prog->active check for bpf_lsm and bpf_iter")

from the bpf-next tree and commit:

  b2e9dfe54be4 ("x86/bpf: Emit call depth accounting if required")

from the tip tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/x86/net/bpf_jit_comp.c
index cec5195602bc,f46b62029d91..000000000000
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@@ -11,8 -11,8 +11,9 @@@
  #include <linux/bpf.h>
  #include <linux/memory.h>
  #include <linux/sort.h>
 +#include <linux/init.h>
  #include <asm/extable.h>
+ #include <asm/ftrace.h>
  #include <asm/set_memory.h>
  #include <asm/nospec-branch.h>
  #include <asm/text-patching.h>
@@@ -1930,7 -1869,7 +1948,7 @@@ static int invoke_bpf_prog(const struc
  	/* arg2: lea rsi, [rbp - ctx_cookie_off] */
  	EMIT4(0x48, 0x8D, 0x75, -run_ctx_off);
 =20
- 	if (emit_call(&prog, bpf_trampoline_enter(p), prog))
 -	if (emit_rsb_call(&prog, enter, prog))
++	if (emit_rsb_call(&prog, bpf_trampoline_enter(p), prog))
  		return -EINVAL;
  	/* remember prog start time returned by __bpf_prog_enter */
  	emit_mov_reg(&prog, true, BPF_REG_6, BPF_REG_0);
@@@ -1975,7 -1914,7 +1993,7 @@@
  	emit_mov_reg(&prog, true, BPF_REG_2, BPF_REG_6);
  	/* arg3: lea rdx, [rbp - run_ctx_off] */
  	EMIT4(0x48, 0x8D, 0x55, -run_ctx_off);
- 	if (emit_call(&prog, bpf_trampoline_exit(p), prog))
 -	if (emit_rsb_call(&prog, exit, prog))
++	if (emit_rsb_call(&prog, bpf_trampoline_exit(p), prog))
  		return -EINVAL;
 =20
  	*pprog =3D prog;

--Sig_/knOGfgQCZ2MjfFsf6J2hAw+
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNZy6QACgkQAVBC80lX
0Gxevwf8CHIR8+j2ijmBofaIwzb1hGRLnPeHCMnC2SOJBOp1I3urnq1yLvpgiZ3y
fU1/tILbfeYBK/p1m0zx9lGORzoRp+fiCummqi+Cq14Pl+kbapW281p29A6IpRsK
ztYSNG2K21XIxLx8AT4DpS1Pv54OxgelReIzp95nkZY+k3cBCCHbZVBzI1uQ/E2Q
ssPOuAvnRTaPzmUsJSxWN/tHeMEjbvSeJBzhqjxOQ72q+ZEilCPPps92A3UycARy
0an9nXQgpBYIKtMhqcusB6ko5045oQIuAyf882xhOAVCSpr2QEuzc8RIlw9JfaeL
hEomNmxJUasby0Ww6rr6dNz5w3wmtQ==
=5vz9
-----END PGP SIGNATURE-----

--Sig_/knOGfgQCZ2MjfFsf6J2hAw+--
