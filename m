Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A071024C978
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 03:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgHUBLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 21:11:20 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45735 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgHUBLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 21:11:17 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BXk412qZhz9sTT;
        Fri, 21 Aug 2020 11:11:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1597972273;
        bh=UBg7kOl51N6Tb2Tsu+7IDQRJF0Nd7kkVtqrn3TJ16DE=;
        h=Date:From:To:Cc:Subject:From;
        b=j9+RjCb/5QjPMqhiYSe9CIMa1Ms98eMLyX6Ew8TMUc+YY+LQIcJI2HPVuAZbj7Tm7
         lE3M8FeD4I/JiqO9bGOYjzYHLgb4/NevgzsKJjCkXC8SpSoQ0I/5ZN1y0f7az6aEI9
         x2Jyfg7QUtY5iE1kr235gvkRGg2svxkEyx/F3/TDLwkijeevBjzwuHm8CXlr/VUShn
         YlppQGNc1H5vR9ippku7OxtFtd3rP36JNiY8OtD7mV3LEtclvR8UuvKG342NN8dq/R
         eagjh5/gB+Z6rdXu3j1SjurMEYEOV4sh4uJyLZSv7w34GWBwfzwmfL2sjowKDpX3hk
         JIhUCzFeCxeRw==
Date:   Fri, 21 Aug 2020 11:11:11 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20200821111111.6c04acd6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/NlhOx9ZdzMqp_qgERtfT_zZ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/NlhOx9ZdzMqp_qgERtfT_zZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

Auto-detecting system features:
...                        libelf: [ =1B[31mOFF=1B[m ]
...                          zlib: [ =1B[31mOFF=1B[m ]
...                           bpf: [ =1B[32mon=1B[m  ]

No libelf found
make[5]: *** [Makefile:284: elfdep] Error 1

Caused by commit

  d71fa5c9763c ("bpf: Add kernel module with user mode driver that populate=
s bpffs.")

[For a start, can we please *not* add this verbose feature detection
output to the nrormal build?]

This is a PowerPC hosted cross build.

I have marked BPF_PRELOAD as BROKEN for now.

--=20
Cheers,
Stephen Rothwell

--Sig_/NlhOx9ZdzMqp_qgERtfT_zZ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8/Hy8ACgkQAVBC80lX
0Gxf/Af/UDlTubmlwjHakfa6/ViNgOwKc/F4XWOraZX417ps1BIHa/gRvcJpOkPQ
rZ5l9IL0yVe5S3brl6hNzLFEpUWhLj0f5XQPWhwMiPVy3YnWNORH+WuOD2dFQQMf
nCYDpqtd3ay9rBYUCVJ7BdoLldMDsMFoufFL+LTEv9gqnHphExC6r4R2USGuOckv
gNbwqTr/AdkSS9s9mnHfDVP3sbzBmvzpZNEG9jrFgxiOwAiLxV/5Zza15m0TpIZo
468QUuo3jADd5GW1dFhfjquPU2g4ia/vdqi4Zz5yN7nSt0A9J4lpvxyKYTKQrhFv
cOEY0K3F631xhDpmAxjI4ECnJ6m4/g==
=Yshc
-----END PGP SIGNATURE-----

--Sig_/NlhOx9ZdzMqp_qgERtfT_zZ--
