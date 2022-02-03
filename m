Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6ACA4A7E78
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 04:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349239AbiBCDwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 22:52:36 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:60491 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbiBCDwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 22:52:35 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jq4W24fQDz4xcl;
        Thu,  3 Feb 2022 14:52:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1643860352;
        bh=/Pfql7CY6zwkVLAHshlAFb3ts0aQsbL6x17I166/5KI=;
        h=Date:From:To:Cc:Subject:From;
        b=syW/ju1lzaswpGav7Z30yj30jeTyhgODBXeyOd4SIZRlCJiF8rgJ8fvUchci6dYMV
         Opbi2pZpD3QULnz172fsHcGBUGp7Phea45IJwzxoe4zUL2JuQy36TTUuzwUIMisAkP
         uKGMleQCRpIqtJuAJW9LFOVcPVqIoLLxrwujMXBR+igD9ZiBMIn1GN747ebCPUaEUa
         jVKHUvIXQLH9WLugcvFAiRy1akoesXBDuZ7E+En2qchsTt4Jxbt23W4UUyD7Tl+0Jy
         RflXRPUhD3q5qkevJ9x68hGYN/okt6108or/UDLu4PdNGZJbO0DGLv8NRaeRlzzDfH
         4e4r3CYCeZbqQ==
Date:   Thu, 3 Feb 2022 14:52:29 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm-current tree with the bpf-next
 tree
Message-ID: <20220203145229.13dd25e9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Fs/cnTjeiqDNuK302s6W=T2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Fs/cnTjeiqDNuK302s6W=T2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  lib/Kconfig.debug

between commit:

  42d9b379e3e1 ("lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+")

from the bpf-next tree and commit:

  e11ef20106b7 ("Kconfig.debug: make DEBUG_INFO selectable from a choice")

from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc lib/Kconfig.debug
index f15dd96028b5,efc1a1908e04..000000000000
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@@ -317,6 -339,7 +339,7 @@@ config DEBUG_INFO_BT
  	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
  	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
  	depends on BPF_SYSCALL
 -	depends on !DEBUG_INFO_DWARF5
++	depends on !DEBUG_INFO_DWARF5 || PAHOLE_VERSION >=3D 121
  	help
  	  Generate deduplicated BTF type information from DWARF debug info.
  	  Turning this on expects presence of pahole tool, which will convert

--Sig_/Fs/cnTjeiqDNuK302s6W=T2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmH7UX0ACgkQAVBC80lX
0GyIbgf/VJOzAy08G7IWfqLcIuzm27iae0UGXbwUO1lYHVv2BQM+3OotO6Fsiz9H
VM87r6F/OHtBXF5ERbNQWjlocRuA9HTWp6kSHruhr9g3858A3akFySFOQzDzyKRU
FN5hQoIFML4QP/Cd3wi/T8vVuM2pGdFlpRYkHjk7N7xeXSNNAYPWt39RmK2nFUgW
WEIPyJhm30UxiVSOasCAK45UAvRzT+ZcMNWbSbP0sxPnHkIsuFMszAvNyotTqDVN
ZbU/MT61uQAdJ4jRfTk/6qMLWmF7Fw0Py3TVKmWb3LRKkZfTx0JX/MHw2ud0TsAb
mBB1dZBN4m5pzPOiIaU08EOyJXYTjQ==
=Nn+L
-----END PGP SIGNATURE-----

--Sig_/Fs/cnTjeiqDNuK302s6W=T2--
