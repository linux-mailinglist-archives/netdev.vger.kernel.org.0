Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8322608E6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgIHDIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:08:49 -0400
Received: from ozlabs.org ([203.11.71.1]:58529 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728241AbgIHDIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:08:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BlqqG3Nkjz9sT6;
        Tue,  8 Sep 2020 13:08:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1599534522;
        bh=ZR9wZ/taI/ANXKFzUcL1I23XkZtFH+PchbQ6gdX4XAk=;
        h=Date:From:To:Cc:Subject:From;
        b=nzKO7XEYJgC4rFcpwit82xayFpTQ2XuvjK880wvJgio4gkDvQpP6iO6A/TspIwbsD
         YNuU6l6amOpZ9vyUXY7HPS8Kln2uQntJgkQ7FfDSj3Ow2ECoXEPesqH4Und3dswl0B
         x4pD+UDrplQ5u326ROkrF+fhNtyN1DSaNxgOF7U2fqsqRdVu/hnvkYHT0VUAIiJtz6
         CJ566Q4ic9k+nTsnvhBN1cerboa6GatlTSeZWDAtibJcyhbO55tSObbuPuM3gP0qKN
         p7U+JIyYSuOEpsQTiDKNMV3xAtzWTzBNi3TFlG0hp8vSTvGphZUVXPntY/P2sV9cvx
         MyoOl0O/9gbKw==
Date:   Tue, 8 Sep 2020 13:08:41 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20200908130841.21980cd9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EVnkw0V8cQxuqowQN4un1cS";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EVnkw0V8cQxuqowQN4un1cS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpcle perf)
failed like this:

util/bpf-loader.c: In function 'config_bpf_program':
util/bpf-loader.c:331:2: error: 'bpf_program__title' is deprecated: BPF pro=
gram title is confusing term; please use bpf_program__section_name() instea=
d [-Werror=3Ddeprecated-declarations]
  331 |  config_str =3D bpf_program__title(prog, false);
      |  ^~~~~~~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:203:13: note: declared here
  203 | const char *bpf_program__title(const struct bpf_program *prog, bool=
 needs_copy);
      |             ^~~~~~~~~~~~~~~~~~
util/bpf-loader.c: In function 'preproc_gen_prologue':
util/bpf-loader.c:457:3: error: 'bpf_program__title' is deprecated: BPF pro=
gram title is confusing term; please use bpf_program__section_name() instea=
d [-Werror=3Ddeprecated-declarations]
  457 |   title =3D bpf_program__title(prog, false);
      |   ^~~~~
In file included from util/bpf-loader.c:10:
tools/lib/bpf/libbpf.h:203:13: note: declared here
  203 | const char *bpf_program__title(const struct bpf_program *prog, bool=
 needs_copy);
      |             ^~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

Caused or exposed by commit

  521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor o=
f "section name"")

I have used the bpf-next tree from next-20200903 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/EVnkw0V8cQxuqowQN4un1cS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9W9bkACgkQAVBC80lX
0Gzh1gf+PJd9XLf10ut0GPKVjjxhbx9z/2qDaZLqToFE7l54BFaQt6ZfSQdK1PCh
VY9Ng1ddhUTti0rcs61HnsIZFSb14E74xQknxZk9M+cLx6LZ371w+gt8CQxd3ZDx
fqkx6Ryt/ZRwGjmtGclmzeCLydf39eq0vnPMejen+wHa+lrgsDh7aF1YY8nzLv3r
elEKZ0P9onFePvxHPVGxusjh9bBnJdQVDifyNOcktw9TL1tIQ4kEKFH8gkHluKh/
iJ7DXgebBYEsDYzfQekHsaFt6HcB6YigHoF3tn/fxRgLfdcf3iHhAAE0dHXmeLV+
yPjmSaNqArjW2zTqEej6qA0YqBmFJA==
=b3ET
-----END PGP SIGNATURE-----

--Sig_/EVnkw0V8cQxuqowQN4un1cS--
