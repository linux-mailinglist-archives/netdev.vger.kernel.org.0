Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 609243C0E8
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 03:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390353AbfFKB2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 21:28:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43677 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388845AbfFKB2W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 21:28:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45NC7R2qylz9sBp;
        Tue, 11 Jun 2019 11:28:19 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560216499;
        bh=fa85krKLmtX9pSn2zzY2yce4JRXwulxnG6YN9Bj9k78=;
        h=Date:From:To:Cc:Subject:From;
        b=Smur2bTHdyBtZD3YQsIZJz8YKfdu6d/mT7lvkdkL1OO0Iu+vJ0lGn3ZhEpalLFXtw
         lL5MloqkXytp7uE3pCuNtup4tTdQSoJXPh5S+m83z4JY/qf8jY8X9RG4PpSIA2i93M
         JUchFaijoAbPkUYVQX+HTJ8XAgembCEjnqDiVmg9WNuiq/70wgAkktz93E3TxYIYRm
         Bb31KpOXARojwF7ITN7LTRuajGuAHw3MstDxlmL7zUfIeu3/MHRYlao07Dg+dafkfO
         HVVyFhLfBIk6f1Oa1JIHjwpsG0H0qwiEfbKYbYB2O6H9H/cYvM1IQNfAQczIdQBciq
         iyJHaZezCx/ng==
Date:   Tue, 11 Jun 2019 11:28:16 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190611112816.01562368@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4SGn3oMy8KB80YP_bK18Pi1"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4SGn3oMy8KB80YP_bK18Pi1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mellanox/mlx5/core/cmd.c

between commit:

  6a6fabbfa3e8 ("net/mlx5: Update pci error handler entries and command tra=
nslation")

from the net tree and commit:

  cd56f929e6a5 ("net/mlx5: E-Switch, Replace host_params event with functio=
ns_changed event")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index e94686c42000,30f7dffb5b1b..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@@ -632,11 -628,7 +632,11 @@@ const char *mlx5_command_str(int comman
  	MLX5_COMMAND_STR_CASE(QUERY_MODIFY_HEADER_CONTEXT);
  	MLX5_COMMAND_STR_CASE(ALLOC_MEMIC);
  	MLX5_COMMAND_STR_CASE(DEALLOC_MEMIC);
- 	MLX5_COMMAND_STR_CASE(QUERY_HOST_PARAMS);
+ 	MLX5_COMMAND_STR_CASE(QUERY_ESW_FUNCTIONS);
 +	MLX5_COMMAND_STR_CASE(CREATE_UCTX);
 +	MLX5_COMMAND_STR_CASE(DESTROY_UCTX);
 +	MLX5_COMMAND_STR_CASE(CREATE_UMEM);
 +	MLX5_COMMAND_STR_CASE(DESTROY_UMEM);
  	default: return "unknown command opcode";
  	}
  }

--Sig_/4SGn3oMy8KB80YP_bK18Pi1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlz/A7AACgkQAVBC80lX
0GzMugf/W+RmBBvyZFmk1Hjq8KtSmsS7RQKc6BzuruTc8BCz45+JFgUGp2B7/ZYJ
UYgoZjTtbGcIsFB34eP3DqWh+/XW9lyqbk0Msf1tc+sUIDKg1+aQuw80CESbwL2E
dRM8oUr2At1L3nBwSXX8kaVEs5a6Ag3YQKrrk4j8XpZGlbqiFUYiw5e/PvkVaeIH
HVXqodkZejoZkbXR6cREeuWbPiZkyMGEcrjjhRnmOXAZwlJRAYNKLiemOveD6Xpy
4RaaK7yuP/ovQ1ZQ13yvRN3yQ6dfChityUAGXbRFJg3grqCnT3ndLKLy7c5EaUnT
/ERXTD5ogHHGHsnXiKPFef4FtjTEVw==
=Wuwh
-----END PGP SIGNATURE-----

--Sig_/4SGn3oMy8KB80YP_bK18Pi1--
