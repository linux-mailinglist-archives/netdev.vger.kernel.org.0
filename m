Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC643F800B
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 03:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236803AbhHZBvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 21:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhHZBvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 21:51:48 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C89C061757;
        Wed, 25 Aug 2021 18:50:57 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gw5R247K5z9sWw;
        Thu, 26 Aug 2021 11:50:54 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629942654;
        bh=k5smgdEICQPus7zNUFtNhEf5uZslp3cctU0LteXWTyw=;
        h=Date:From:To:Cc:Subject:From;
        b=qXiqqO0MbPtjMQnEv2u8eHbWEfdNg2HJUSKS/jR3EanEpiQ4doAv55ljZc2TO4CIf
         Tkalo9MEeQtWjnTM53td9u3tgzrxDBSAwOfzPKrkttmuC6trA59qHP13LYu7hD5hOv
         ZotxIygHI3LRp2gkumruEGIzyPcliH/Mfc9Dl5rFShVOb5pgc4IAxXf0pBn0OpNX+U
         TroO4U/rPkIMq0ORx141RaHp9OjMpaEj0sjptLThAFlehDTKBZlSd+Joo91+x+a7Ce
         cj9NEyiwAfJigmOw0+Wze8FcBuJRAYLpfp6ECMz6MxCNXXkz0dXFAk9hpxpz7MpH/Y
         BGB7iiS/LmAUg==
Date:   Thu, 26 Aug 2021 11:50:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Daniel Xu <dxu@dxuuu.xyz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20210826115050.7612b9cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gfTRhjvh6OzaGsm.NFKy3Cx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gfTRhjvh6OzaGsm.NFKy3Cx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/trace/bpf_trace.c:717:47: error: expected ')' before 'struct'
  717 | BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
      |                                               ^~~~~~~
      |                                               )
kernel/trace/bpf_trace.c: In function 'bpf_tracing_func_proto':
kernel/trace/bpf_trace.c:1051:11: error: 'bpf_get_current_task_btf_proto' u=
ndeclared (first use in this function); did you mean 'bpf_get_current_task_=
proto'?
 1051 |   return &bpf_get_current_task_btf_proto;
      |           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |           bpf_get_current_task_proto

Caused by commit

  33c5cb36015a ("bpf: Consolidate task_struct BTF_ID declarations")

I have used the bpf-next tree from next-20210825 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/gfTRhjvh6OzaGsm.NFKy3Cx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEm83oACgkQAVBC80lX
0Gw1MQf/czYLimBca4jH7A3Q3SEw5vtpwL6ZzaAIR87GZ5+zepPhCF1Fmn27jBbB
BrtAoaSFxsOP/qNUdgew2TJLc+R0Jl/wceFHMVHUU1UJRISmyQgQ7FiHsYfsRO9h
GERiTRk/qV6sSbQDpYBK7CUYkR2yna8Ro/3c4AT6L/HPgvpGaaIWOXf1S0GXAjEi
QA26Yeg+oAB8n0J9qN/n3W4u2YA6Y4/Y26eXUjCkUpsDw3JDgt6ha9qOLs3yIto3
N1b5+oH7gJfx9YbrtLPBX33X98/yMhYDwuTooTqNDqPH0p69SNCV8oQ4DI7YEVgJ
erWd3Ab1QYvSriL9tMyIJpPBsQcsfw==
=9y7b
-----END PGP SIGNATURE-----

--Sig_/gfTRhjvh6OzaGsm.NFKy3Cx--
