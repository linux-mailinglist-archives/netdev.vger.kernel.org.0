Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4723AC779
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhFRJcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:32:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48514 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbhFRJb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:31:58 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BE89E1C0B76; Fri, 18 Jun 2021 11:29:48 +0200 (CEST)
Date:   Fri, 18 Jun 2021 11:29:48 +0200
From:   Pavel Machek <pavel@denx.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCHv2] cxgb4: fix wrong shift.
Message-ID: <20210618092948.GA19615@duo.ucw.cz>
References: <20210615095651.GA7479@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20210615095651.GA7479@duo.ucw.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

While fixing coverity warning, commit dd2c79677375 introduced typo in
shift value. Fix that.
   =20
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Fixes: dd2c79677375 ("cxgb4: Fix unintentional sign extension issues")

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/ne=
t/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 22c9ac922eba..6260b3bebd2b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -198,7 +198,7 @@ static void set_nat_params(struct adapter *adap, struct=
 filter_entry *f,
 				      WORD_MASK, f->fs.nat_lip[3] |
 				      f->fs.nat_lip[2] << 8 |
 				      f->fs.nat_lip[1] << 16 |
-				      (u64)f->fs.nat_lip[0] << 25, 1);
+				      (u64)f->fs.nat_lip[0] << 24, 1);
 		}
 	}
=20


--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYMxnjAAKCRAw5/Bqldv6
8vaQAJ0ZX60HsseRihtPMB4Aw5fuZGyQPwCgi+loUvWoHwd5I/qutMEFiXTONPw=
=Jl70
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
