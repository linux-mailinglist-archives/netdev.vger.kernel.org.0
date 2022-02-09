Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110D14AE5D9
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbiBIAVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbiBIAVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:21:49 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7880CC061576;
        Tue,  8 Feb 2022 16:21:48 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JtgXy2ywQz4xcp;
        Wed,  9 Feb 2022 11:21:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1644366098;
        bh=OAelZNQ28TFoQ+fesqVaaW/qWkf9ydcEeD63ov+iiic=;
        h=Date:From:To:Cc:Subject:From;
        b=XJjQlKELk/ORoICQBAZwCKz1+VQ/af51WYIGVZ6N78rwbgPl0HbULfJPPmSybkMfP
         C4mD0RV+8LMqzvmDK3QcmzhobB1uFowKPwDQhhA5a5GZRR0qW5sCrBrxfS4gF550yp
         MJplO0EqghXyhJZntMrYsRnlUAG2ITGCcMWidCOqnBQAdSQdktk73D6YY3R6D8Yxji
         UY782NN1EPn9j5GTIAVmA22qi26FfT2pir6fir3LZvjKylpW/fM778td7m/hHQx/1n
         aC0pvABXksJJJbcgtp3hp2FcU3FkIbTRNB+0ibUPoyoU9t3l6l0Eb0Dd8bRpCVcrHT
         RTgY6W6Caj/PQ==
Date:   Wed, 9 Feb 2022 11:21:35 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20220209112135.7fec872f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/K.I5wuzZ3aVsh8RZY5/KK/1";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/K.I5wuzZ3aVsh8RZY5/KK/1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/bpf/core.c:830:23: error: variably modified 'bitmap' at file scope
  830 |         unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
      |                       ^~~~~~

Caused by commit

  57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")

I have used the bpf-next tree from next-20220208 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/K.I5wuzZ3aVsh8RZY5/KK/1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIDCQ8ACgkQAVBC80lX
0GwjQAf8DYpys4P4GjraUETbZo4yF2ktnc45XHh4gcknKVcjDeW4OnOhTuWG2E6y
HAmHkJGTTZ+UHcT8WoRX3+likwzxSLnh2lzdqoV0uooFj7R9W7q+JBHwW4XWJLDY
WCBBrcFPB+mH/ALwMNvHWl6Qvl3vJGNKA6QFsi2fc55q1ilNO1dWn76HRRz0fm1/
twUfltkCrYOi+nlSTYL+1XoI3YM4ucN27Zk/IXQLHFhWANJEpKMAzmPI9oUam7X5
zYcGkCo/h44YDn1eSaIs1ELZA8R29cz/5sUuLkpfyqG/s7sPH0gwDYWxymw5Hb8f
CyB5QPU4XeWY6bAtTaYyZdht1Gqpkw==
=sshk
-----END PGP SIGNATURE-----

--Sig_/K.I5wuzZ3aVsh8RZY5/KK/1--
