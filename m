Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FA637F0D7
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 03:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbhEMBMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 21:12:36 -0400
Received: from ozlabs.org ([203.11.71.1]:55617 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237612AbhEMBMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 21:12:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FgYWj3tzDz9sWM;
        Thu, 13 May 2021 11:11:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620868274;
        bh=FlilBHw+BALVakdHubZxYbaKAe6CCUEFxVUa18sEmcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nti1KmGx3u6c4TWKUL8nzpwoF9a3HPhJ04/7Yo9Eu2Byuy+rR1PINAG+++Dwcdv0X
         ut2/Mqh7OATdy9L33tqCX+LjkDPEtofNeEiCpn5Ow6ps+qJb/4bRZsatSqxySnpv8E
         mxRdhwTOqReh27sT42x2HOxnvoYRZcPeNG631kXSS9s+4K+R4ZCK8V3buDC7ockb8c
         XZsXE63R9wFvSJtGm+sd+nsEwZa5hSrRHmEpRvXYilWRu0q+tAaCZjHHtFqkPxMVHj
         fT0+bcyzDYR6aUpjkgesV7GSMknzMPt+cQvx68U33C5qnfd0r1qoqajWAm6AdZweHE
         onh+++r4gaEAA==
Date:   Thu, 13 May 2021 11:11:10 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210513111110.02e1caee@canb.auug.org.au>
In-Reply-To: <20210512095418.0ad4ea4a@canb.auug.org.au>
References: <20210512095201.09323cda@canb.auug.org.au>
        <20210512095418.0ad4ea4a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/VAQ3w9fzd1rupt4ug8HuIr5";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/VAQ3w9fzd1rupt4ug8HuIr5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 12 May 2021 09:54:18 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 12 May 2021 09:52:01 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the net-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/usb/class/cdc-wdm.c: In function 'wdm_wwan_port_stop':
> > drivers/usb/class/cdc-wdm.c:858:2: error: implicit declaration of funct=
ion 'kill_urbs' [-Werror=3Dimplicit-function-declaration]
> >   858 |  kill_urbs(desc);
> >       |  ^~~~~~~~~
> >=20
> > Caused by commit
> >=20
> >   cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")
> >=20
> > kill_urbs() was removed by commit
> >=20
> >   18abf8743674 ("cdc-wdm: untangle a circular dependency between callba=
ck and softint")
> >=20
> > Which is included in v5.13-rc1. =20
>=20
> Sorry, that commit is only in linux-next (from the usb.current tree).
> I will do a merge fix up tomorrow - unless someone provides one.
>=20
> > I have used the net-next tree from next-20210511 for today. =20

I have used the following merge fix patch for today.  I don't know if
this is sufficient (or even correct), but it does build.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 13 May 2021 11:04:09 +1000
Subject: [PATCH] usb: class: cdc-wdm: fix for kill_urbs() removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/class/cdc-wdm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index c88dcc4b6618..489b0e049402 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -855,7 +855,7 @@ static void wdm_wwan_port_stop(struct wwan_port *port)
 	struct wdm_device *desc =3D wwan_port_get_drvdata(port);
=20
 	/* Stop all transfers and disable WWAN mode */
-	kill_urbs(desc);
+	poison_urbs(desc);
 	desc->manage_power(desc->intf, 0);
 	clear_bit(WDM_READ, &desc->flags);
 	clear_bit(WDM_WWAN_IN_USE, &desc->flags);
--=20
2.30.2

--=20
Cheers,
Stephen Rothwell

--Sig_/VAQ3w9fzd1rupt4ug8HuIr5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCcfK4ACgkQAVBC80lX
0GzuRAf/Uf9VNeOmIKeR1BSE3mJtt2cnaeFkZTb4wpLemOCdpxIAz3JmtBhhWftP
NLxUyIOQ7qANroNEv1AIciIShQGX7T0YJioJQHzfsAHvOKUGtIWFxb+Khjnn6JNC
ROiTIkES7aJdTzK9k7ZCZwrgyB1BGcwJvmRGpJDBI+MWwpl+ht1Kkr8Cc0L5iluV
Kip7Yx4bjlrMk/zmmBxDZsMc+efYHrb/x7QeM1EGinCktwPfvMOC70C7O/7gu+bj
UdfRBhNpa7qEowu5DanOBTRh54Sybg/yQcSebHe+Cor0LdKDTvmUjrcKKxvNJn5Q
Lq2U5QT9q44L8mPSSDt5eDRCG7jdRA==
=u61s
-----END PGP SIGNATURE-----

--Sig_/VAQ3w9fzd1rupt4ug8HuIr5--
