Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C89383D8
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 07:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfFGFpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 01:45:05 -0400
Received: from ozlabs.org ([203.11.71.1]:59843 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbfFGFpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 01:45:04 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Ks1S5t7cz9sNR;
        Fri,  7 Jun 2019 15:45:00 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1559886302;
        bh=GAGMgYjIWuiKhXW3w1n2VB9jKa7NfmJVlq1R6jocYU8=;
        h=Date:From:To:Cc:Subject:From;
        b=oy6hzqhxH085Tppczq94Ui+wkrZJcyfUy3iUwU32aVvDQ1xd3c9Cz1HLS1WPUGdwj
         OYj7xHdUd0+MAQo8eMUWFVLH+QeN9FYhqJE+Kuyow0FQRK2Wvfpf80Ou00vwcTZWEh
         QhVU7XnijqmH6z3wcOLFpAbHWsg9i7n2buCnoRC+voemquVDfSwLeQrzCTOkQmL39u
         aQkF0+le0Dfff3vbGYLthkLdDXVxF8Pa8S6WyqfRXGLSdUqdtmFFVItqmyI2TmW8jl
         ZRYz8RZVw1FRAUFeIWUJfgls3rfMSMDaF97XzrmQeTwBtBRrP7CXAHrrVf36P3+Il4
         zTMEEeKjOlxwQ==
Date:   Fri, 7 Jun 2019 15:44:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Matteo Croce <mcroce@redhat.com>
Subject: linux-next: manual merge of the akpm-current tree with the net-next
 tree
Message-ID: <20190607154456.3144c3b6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vY/C/WhtbazlgG87bXzoBWJ"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vY/C/WhtbazlgG87bXzoBWJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  net/ipv6/sysctl_net_ipv6.c

between commit:

  323a53c41292 ("ipv6: tcp: enable flowlabel reflection in some RST packets=
")

from the net-next tree and commit:

  f4e7c821eda5 ("proc/sysctl: add shared variables for range check")

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

diff --cc net/ipv6/sysctl_net_ipv6.c
index 6d86fac472e7,4c6adfccc3d2..000000000000
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@@ -21,9 -21,6 +21,7 @@@
  #include <net/calipso.h>
  #endif
 =20
- static int zero;
- static int one =3D 1;
 +static int three =3D 3;
  static int auto_flowlabels_min;
  static int auto_flowlabels_max =3D IP6_AUTO_FLOW_LABEL_MAX;
 =20
@@@ -115,8 -112,6 +113,8 @@@ static struct ctl_table ipv6_table_temp
  		.maxlen		=3D sizeof(int),
  		.mode		=3D 0644,
  		.proc_handler	=3D proc_dointvec,
- 		.extra1		=3D &zero,
++		.extra1		=3D SYSCTL_ZERO,
 +		.extra2		=3D &three,
  	},
  	{
  		.procname	=3D "max_dst_opts_number",

--Sig_/vY/C/WhtbazlgG87bXzoBWJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlz5+dgACgkQAVBC80lX
0Gwhigf/ddyGgNh8MCJKkemu1Ktq9IQyksaJqGxLM7ur8Uj8FoomtsBWRpkwPyr/
gPAvDWLfCejmmaC5FEGe+hvy7QFxKuyjKsmnGc5Ue1mGuF/0cKtYXtWfi8HffCKO
Qy3SmjrMTH2RKwEqE/H3iWtMLOmlOawty6NZ2wXbpR/pxVeTG1lKbS342t8hZSuu
O/Cp00GGH4OrfkWeWueOYHuVTljZH22KS+DKNMLKgDFT+4lgL2GrvZovPNvf+Zzm
Wp/je5DZcMTdintUXWQXfVmXeofKJmOm4Q/Tb3rIaNnojX8Cb8cWGvJyTaxY4MfB
EzGAz4KQ/1d0knHr8RGlnGMvAjLnrA==
=ZGIN
-----END PGP SIGNATURE-----

--Sig_/vY/C/WhtbazlgG87bXzoBWJ--
