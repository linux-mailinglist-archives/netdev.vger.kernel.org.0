Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19EB5061E8
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344201AbiDSB7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344215AbiDSB7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:59:08 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818F92F38A;
        Mon, 18 Apr 2022 18:56:23 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Kj6NP470rz4xXg;
        Tue, 19 Apr 2022 11:56:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1650333382;
        bh=bw6Epi7kuW+sVZpYiLUWJMDl+fXAaCRfWsUoFVrSnX8=;
        h=Date:From:To:Cc:Subject:From;
        b=r/db4BEzVG0xG1Hp5Y8cN760/sSionRdPY2dwIVhSA0krPSswRzzqIDOT/YOm6wkY
         iLSisNbtjveXuKKi2JVSY70ISbJSm7KaTvovkt0Gvx3gHYBqFxut3tALLTtDre4QIw
         oFhsfneweI0jkg7tr0BbLtPAR6Y7I5AYxN1Wo94fmiaszO8Jl4Sd/Vl2tjU+wbASnp
         A4o+Mx/Vaa/sCMajb8dc/yGC6uYZoc7KGpty6vS8IHt9AAbtqDa4moIrw5EAKpi3vA
         Zf7XqfLND2OO9Pru/tyb+v/j0aOSbRJdNzuZ1NMa8CDwNRYAig7j0qzLTGPJlFjh0a
         M0+/MaS6daaGA==
Date:   Tue, 19 Apr 2022 11:56:20 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20220419115620.65580586@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Qc7UYigfGCWV7g9H9dXqsEu";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Qc7UYigfGCWV7g9H9dXqsEu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build
(x86_64 allmodconfig) failed like this:

In file included from include/linux/compiler_types.h:73,
                 from <command-line>:
drivers/net/ethernet/intel/i40e/i40e_xsk.c: In function 'i40e_run_xdp_zc':
include/linux/compiler_attributes.h:222:41: error: attribute 'fallthrough' =
not preceding a case label or default label [-Werror]
  222 | # define fallthrough                    __attribute__((__fallthroug=
h__))
      |                                         ^~~~~~~~~~~~~
drivers/net/ethernet/intel/i40e/i40e_xsk.c:192:17: note: in expansion of ma=
cro 'fallthrough'
  192 |                 fallthrough; /* handle aborts by dropping packet */
      |                 ^~~~~~~~~~~
cc1: all warnings being treated as errors
In file included from include/linux/compiler_types.h:73,
                 from <command-line>:
drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c: In function 'ixgbe_run_xdp_zc=
':
include/linux/compiler_attributes.h:222:41: error: attribute 'fallthrough' =
not preceding a case label or default label [-Werror]
  222 | # define fallthrough                    __attribute__((__fallthroug=
h__))
      |                                         ^~~~~~~~~~~~~
drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c:147:17: note: in expansion of =
macro 'fallthrough'
  147 |                 fallthrough; /* handle aborts by dropping packet */
      |                 ^~~~~~~~~~~
cc1: all warnings being treated as errors

Caused by commits

  b8aef650e549 ("i40e, xsk: Terminate Rx side of NAPI when XSK Rx queue get=
s full")
  c7dd09fd4628 ("ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx queue ge=
ts full")

I have used the bpf-next tree from next-20220414 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/Qc7UYigfGCWV7g9H9dXqsEu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJeFsQACgkQAVBC80lX
0Gz5/gf8Ch542D+PbkaNqy0vZIQkDqVfngATjOow2qXLg/drPByTnYRlfP/A0Uc5
fTK0+bPkOyEsRwnfIoZ0RPYQLXWwBBsEqpUbtQXDxm8E8dKnsV67mIs1P7dgh9FI
4A1870zcNp4+RI8uTZHZ7xhGhivxEL+WPS0KdtgYo/2KGMdoVP604+imAZOfyRH7
ld+QwVetB3V36o/iIDCFy7RwwNrphZ123sNrUTiz/rimJIqnve90sxjrpEoPTJxD
LCnjfwqub0Tm0kWJYlWz+GwZHVzMt6DJu7NxyU63XBwZ0DEjv/HX9cnAVGEFa06Z
SNH3b5YEUV/wcgflI9C7QM+o9m/eXg==
=ie3L
-----END PGP SIGNATURE-----

--Sig_/Qc7UYigfGCWV7g9H9dXqsEu--
