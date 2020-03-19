Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC36218A9A9
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgCSAMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:12:02 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:49299 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727321AbgCSALE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:11:04 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48jS4626w6z9sPk;
        Thu, 19 Mar 2020 11:11:02 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1584576662;
        bh=4NeHfuenkCF6u/+kEoesLWlSHw3XkaaPyGQc98hjRGQ=;
        h=Date:From:To:Cc:Subject:From;
        b=WDWvPg/wLRHG3UHvKXOZH8kDol+lSTsMmw0hkBGJaT742jX2qdWR8r8HEpRfKiGeU
         wJdjcRBuTUam5RpR3JdszpnZYzYIlSqleCh0qLceAxD6Mey+RIetnjxEUHDrBelurR
         F8+zRbC5VcOOhlTksTbrCF1U61NLlQRHlpLMiWsEuOhsqZhBO6mn0S79y/RCc64cdf
         ohc6P+D10KTCjwkzEsCgay0Jux/CzM13FaXu6cwAeE+s/+WKErUTVfptVc5CecLk0I
         gD3guZfOcG13qtkc9GYDg33SyBuckEHfSdjQiGfKICPCooc+WDupeoVVdJQbK7hrox
         w+kIk6MIQZi6Q==
Date:   Thu, 19 Mar 2020 11:10:53 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200319111053.597bd4d1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/5vHI_Q_c2A6E/.8i+PNP8Go";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/5vHI_Q_c2A6E/.8i+PNP8Go
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/amazon/ena/ena_netdev.c

between commit:

  dfdde1345bc1 ("net: ena: fix continuous keep-alive resets")

from the net tree and commit:

  1a63443afd70 ("net/amazon: Ensure that driver version is aligned to the l=
inux kernel")

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

diff --cc drivers/net/ethernet/amazon/ena/ena_netdev.c
index 4647d7656761,555c7273d712..000000000000
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@@ -3486,10 -3473,7 +3483,8 @@@ static int ena_restore_device(struct en
  		netif_carrier_on(adapter->netdev);
 =20
  	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
 +	adapter->last_keep_alive_jiffies =3D jiffies;
- 	dev_err(&pdev->dev,
- 		"Device reset completed successfully, Driver info: %s\n",
- 		version);
+ 	dev_err(&pdev->dev, "Device reset completed successfully\n");
 =20
  	return rc;
  err_disable_msix:

--Sig_/5vHI_Q_c2A6E/.8i+PNP8Go
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5yuI0ACgkQAVBC80lX
0GxwDQf/Uho6IaGCmfwvaMFtSKnQW6lVYzKQ9v6sVtTjaTch6Vnj4DOGZDMUPN/G
KaGHYNehY4s4L/jicSCImhMkY7Lm5aFmnDsCLhhjBt93EypyW0KDvNGg9CbwYfjY
dYr7Ii3RQnhJCxgocnF5HQNxtg2Ssns9m1Ynj2LxTYxN065b9ELGOI56zEUI2bp4
+rxlXgJuG1SeZMXNYj2+FZIpgZM2P8D/CXcgQuhr7Q038YmKQFscdTEoh1Jj6yio
GH2kNEjMpMjmSnzR+E4So8gTMVyGGEXe6kqtzGgqQq73mM3pfI3x1FCZP/bl62KO
6LvklCycRNGSyv7JmuMsJYjYEp72NQ==
=/Xxx
-----END PGP SIGNATURE-----

--Sig_/5vHI_Q_c2A6E/.8i+PNP8Go--
