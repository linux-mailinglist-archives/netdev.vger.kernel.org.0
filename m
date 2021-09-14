Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6281540A29B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 03:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbhINBix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 21:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbhINBiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 21:38:52 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D3FC061574;
        Mon, 13 Sep 2021 18:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1631583453;
        bh=DzZV5rkp+a8vep9FVFtVy8CeJ6UVgl8gQjVw2rD/Fs8=;
        h=Date:From:To:Cc:Subject:From;
        b=nrhJSITC4ykFWuxJsatAF+ZGdGEvNgjceRhsLpSR4XqLU+cGrDcpA4uXuvBeJZEp0
         /QlwWfsib1qciywR1NlFeMy+67yAgUIbAumow4BZXMrIMzffRGLZEJqK9sAhq0BAB8
         0BaPpwb5xkv3ceo6IOnXr+3Fs1t1xLVb9VXAW3R8kHjrEWe6XfHmasycb51fYCR4zE
         ErXGGovGO3v8kMtFSRiX51DriHnRQDHPE1+WwKHj2WVKnpylZ9Cmbu4i8WS1hNlDeQ
         xSuyjlGS/Gu6tmzvUmF/pOYsFacaR6mqgjSdAm0q4ldTVY2llz79oRcaVLbuxd37Cl
         k2XBIFeR55SOw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4H7mDr5QR7z9t0Z;
        Tue, 14 Sep 2021 11:37:32 +1000 (AEST)
Date:   Tue, 14 Sep 2021 11:37:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20210914113730.74623156@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Ljt6f9KxeoK=CdtEGm_e9Fo";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Ljt6f9KxeoK=CdtEGm_e9Fo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (perf) failed
like this:

util/bpf-event.c: In function 'btf__load_from_kernel_by_id':
util/bpf-event.c:27:8: error: 'btf__get_from_id' is deprecated: libbpf v0.6=
+: use btf__load_from_kernel_by_id instead [-Werror=3Ddeprecated-declaratio=
ns]
   27 |        int err =3D btf__get_from_id(id, &btf);
      |        ^~~
In file included from util/bpf-event.c:5:
/home/sfr/next/next/tools/lib/bpf/btf.h:54:16: note: declared here
   54 | LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
      |                ^~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Caused by commit

  0b46b7550560 ("libbpf: Add LIBBPF_DEPRECATED_SINCE macro for scheduling A=
PI deprecations")

I have used the bpf-next tree from next-20210913 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/Ljt6f9KxeoK=CdtEGm_e9Fo
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmE//NoACgkQAVBC80lX
0GzcPwf+PViGcONJV39frBYvMQSz04U+bY6GPrqa+jkb1u2+xLE64kSPXJGn90Lk
5Dr8o5bSleZ/9PO/EpXj7Tn5x1nlhKd2B1h8Lu7YOkkhX5IMZXvpW3LnpxMc0Iar
Cs7ySEV2SzanWBQwWzfY15ekUsu20G4w3+RI0aSk/0xQ4dCvMbSrorFt4OMlokIg
SRkx1UwgDlhPLd5S4tWYHetQzU0yQnnDZMQJXF/EAhYvJuqUjlPVeeswFrV6fsz4
eOuLsWafDOIQUrzgLVgLFEuCtD+XCpA8jhT5uZzNfzaZGA5ykuLH97QW5wnOVBW8
mkq+9T0U7AGQZ3/bEKOT8L56+Y9ZFw==
=jleT
-----END PGP SIGNATURE-----

--Sig_/Ljt6f9KxeoK=CdtEGm_e9Fo--
