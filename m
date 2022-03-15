Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDB4D9279
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 03:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbiCOCPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 22:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiCOCPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 22:15:04 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405B3344DF;
        Mon, 14 Mar 2022 19:13:52 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KHcQj6TQxz4xRB;
        Tue, 15 Mar 2022 13:13:49 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1647310430;
        bh=84nN59giJb6Wk9aHfEP/HVHFE7QFPITweDKcNwA7Qtg=;
        h=Date:From:To:Cc:Subject:From;
        b=DKx1irAU2KXTgOeiHVael5I9JdsvauZ+Lh5IeD9w42hbzxZXnF8Dk0VF09lag5hP9
         jCUkn9oUN+tH0ysPWmDrNFwG7tJ9t/OyFaau+BkizmM7p+tseNFDOAWbFvm7N6BHQM
         vyQSxfI3yP+hoQNVY04odqtCFu0ysGksl9jQuCJq3hiWu1VElKgRCP4X5wk5SRFzQG
         bGMBnycj/nDkQS0X1g0YOjWpMjhzRPSNpYELry+dwL2zRVGVpJc8K8mxwsbi00jGKC
         V8aKAysfTUn0Fe6z4IthGHLap/t9tif0rIatGqvYwVMDf9jQZFaoLyULqEI42vIQYG
         MAtWkfKryPn2Q==
Date:   Tue, 15 Mar 2022 13:13:48 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>
Subject: linux-next: manual merge of the tip tree with the net-next tree
Message-ID: <20220315131348.421dd6c7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KKKTz22ycwZs9Me/cI9EQnc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KKKTz22ycwZs9Me/cI9EQnc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in:

  arch/x86/net/bpf_jit_comp.c

between commit:

  1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")

from the net-next tree and commit:

  9e1db76f44de ("x86,bpf: Fix bpf_arch_text_poke()")

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
index 6b8de13faf83,b1c736be6545..000000000000
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@@ -380,7 -395,14 +391,14 @@@ int bpf_arch_text_poke(void *ip, enum b
  		/* BPF poking in modules is not supported */
  		return -EINVAL;
 =20
+ 	/*
+ 	 * See emit_prologue(), for IBT builds the trampoline hook is preceded
+ 	 * with an ENDBR instruction.
+ 	 */
+ 	if (is_endbr(*(u32 *)ip))
+ 		ip +=3D ENDBR_INSN_SIZE;
+=20
 -	return __bpf_arch_text_poke(ip, t, old_addr, new_addr, true);
 +	return __bpf_arch_text_poke(ip, t, old_addr, new_addr);
  }
 =20
  #define EMIT_LFENCE()	EMIT3(0x0F, 0xAE, 0xE8)

--Sig_/KKKTz22ycwZs9Me/cI9EQnc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIv9lwACgkQAVBC80lX
0Gwwlwf+K5/ogSwfGTxRP3k/yF3BJBKuDcidTyc05arl3e2zsrueHLHifN/2Krtx
DZNISDDCoWR3xoaYiuVUw38Y63+c4Z6XS6Cm4UfQIlYzOEMDO3DoHt2QCQM8Ov3H
dJL5DbNZX/JUur1CyihRmidIVkMU8k72TQzPf2/z8I9FxIadRuJoXl71jUjK3jon
U0SNqEYePcIYzt5BM23HDSzO8G+RXdAmShCvqaXQhdH6hh3kMAfshAlungwvC+j6
opjnsB3PZ480crwi/Oy3vok3tp7Zt2+NF6+R6v7p+MdUq8ezGTDC9M+zCTY8VKp4
nU8A+YX2XOdusWGwpD6X+/7MybJnUw==
=nwU1
-----END PGP SIGNATURE-----

--Sig_/KKKTz22ycwZs9Me/cI9EQnc--
