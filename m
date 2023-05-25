Return-Path: <netdev+bounces-5259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11598710729
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC9F01C20E07
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9709C8F6;
	Thu, 25 May 2023 08:18:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2229C8DF
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:18:54 +0000 (UTC)
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C617F122;
	Thu, 25 May 2023 01:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1685002732; x=1716538732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nhKc0mAgAHG1uUzY5knTrGiokdmqHJnsDHjF/RXZ8pA=;
  b=M7j53JGXOqlxbqO0KMmksHJVRIAgO4LCcmUOoESMbllCo9RqaGdeXtQc
   jFROvrFgLMx08YS+tvros+cR24IxFmkCWuKQfcF7Cs9EoLdDpqBLcgUyi
   t0yapn31FjVThOq1CiLvsi/X3fv9GAtzA/Ti5s3rvUhnBDDnm9Xf+Aan1
   9A9GlsXyPHRF+5ZXSEbEGVh72Z2A68z352Wqdv0fEXDpxfbAoHpa7nvZn
   /VwuNSXWVgFDLoorBpNRI6rEv8CH+2NVakbSXkwS/c6OYVW5e0w/ZthqZ
   b2MACtixVGWSfzHcA42xn2oCepUY1ioW9CGFAa5H5I4BBiY94KMsChmJ5
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,190,1681164000"; 
   d="scan'208";a="31092978"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 25 May 2023 10:18:49 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 25 May 2023 10:18:49 +0200
X-PGP-Universal: processed;
	by tq-pgp-pr1.tq-net.de on Thu, 25 May 2023 10:18:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1685002729; x=1716538729;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nhKc0mAgAHG1uUzY5knTrGiokdmqHJnsDHjF/RXZ8pA=;
  b=VOK1z3/Gnea3Zf+C1yDOMmT+9IxdmOpoTtwCoimwlIjNbjQKsGB7WeCr
   xcw+tmJ4zYnCBXmqB3DL/gRon2ZwFKqNgdrr44zN/CsVoKb3j72aozK8Z
   jKWasdSAwik9LFIGVvwwNXfyaolNSBdqjRAJLFelOY7cZhwdXei0r6r5F
   jX3O7YHYca6OQdSPY15aI+IH3RKJesK5ydMHS4afDNEYsvAX8W9oGqGBI
   +3KmOdPidThpkaBFrMj0o7kqElmDrqDAUfGBDPT8v++b9S3ha0iYfF2OT
   28rfOz73G4dwuynRvvTwZYAvLsLAVwGxPoSXFV685jKqcitskmKWj3uVm
   w==;
X-IronPort-AV: E=Sophos;i="6.00,190,1681164000"; 
   d="scan'208";a="31092977"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 25 May 2023 10:18:49 +0200
Received: from steina-w.localnet (unknown [10.123.53.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 689C6280082;
	Thu, 25 May 2023 10:18:49 +0200 (CEST)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: Francesco Dolcini <francesco@dolcini.it>, Andrew Lunn <andrew@lunn.ch>
Cc: Praneeth Bajjuri <praneeth@ti.com>, Geet Modi <geet.modi@ti.com>, "David S. Miller" <davem@davemloft.net>, Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Grygorii Strashko <grygorii.strashko@ti.com>, Dan Murphy <dmurphy@ti.com>
Subject: Re: DP83867 ethernet PHY regression
Date: Thu, 25 May 2023 10:18:49 +0200
Message-ID: <1857120.tdWV9SEqCh@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <07037ce6-8d1c-4a1d-9fdd-2cd9e68c4594@lunn.ch>
References: <ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com> <ZGuLxSJwXbSE/Rbb@francesco-nb.int.toradex.com> <07037ce6-8d1c-4a1d-9fdd-2cd9e68c4594@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Am Montag, 22. Mai 2023, 18:15:56 CEST schrieb Andrew Lunn:
> On Mon, May 22, 2023 at 05:35:33PM +0200, Francesco Dolcini wrote:
> > On Mon, May 22, 2023 at 05:15:56PM +0200, Andrew Lunn wrote:
> > > On Mon, May 22, 2023 at 04:58:46PM +0200, Francesco Dolcini wrote:
> > > > Hello all,
> > > > commit da9ef50f545f ("net: phy: dp83867: perform soft reset and ret=
ain
> > > > established link") introduces a regression on my TI AM62 based boar=
d.
> > > >=20
> > > > I have a working DTS with Linux TI 5.10 downstream kernel branch,
> > > > while
> > > > testing the DTS with v6.4-rc in preparation of sending it to the
> > > > mailing
> > > > list I noticed that ethernet is working only on a cold poweron.
> > >=20
> > > Do you have more details about how it does not work.
> > >=20
> > > Please could you use:
> > >=20
> > > mii-tool -vvv ethX
> >=20
> > please see the attached files:
> >=20
> > working_da9ef50f545f_reverted.txt
> >=20
> >   this is on a v6.4-rc, with da9ef50f545f reverted
> >=20
> > not_working.txt
> >=20
> >   v6.4-rc not working
> >=20
> > working.txt
> >=20
> >   v6.4-rc working
> >=20
> > It looks like, even on cold boot, it's not working in a reliable way.
> > Not sure the exact difference when it's working and when it's not.
> >=20
> > Using SIOCGMIIPHY=3D0x8947
> > eth0: negotiated 1000baseT-FD flow-control, link ok
> >=20
> >   registers for MII PHY 0:
> >     1140 796d 2000 a231 05e1 c5e1 006f 2001
> >     5806 0200 3800 0000 0000 4007 0000 3000
> >     5048 ac02 ec10 0004 2bc7 0000 0000 0040
> >     6150 4444 0002 0000 0000 0000 0282 0000
> >    =20
> >     1140 796d 2000 a231 05e1 c5e1 006d 2001
> >     5806 0200 3800 0000 0000 4007 0000 3000
> >     5048 af02 ec10 0000 2bc7 0000 0000 0040
> >     6150 4444 0002 0000 0000 0000 0282 0000
>=20
> Register  6: 006f vs 006d
> Register 17: ac02 vs 1f02
> Register 19: 0004 vs 0000
>=20
> Register 6 is MII_EXPANSION. Bit 1 is
>=20
> #define EXPANSION_LCWP          0x0002  /* Got new RX page code word   */
>=20
> So that is probably not relevant here.
>=20
> Register 17 is MII_DP83867_PHYSTS, and bits 8 and 9 are not documented
> in the driver. Do you have the datasheet?

Bit 8 & 9 is indicating the MDI/MDIX resolution status for lines A/B and C/=
D.

> Register 19 is MII_DP83867_ISR. The interrupt bits are not documented
> in the driver either.

I guess that's the more interesting part. Bit 2 (0x4) indicates a xGMII=20
(RGMII/SGMII) error interrupt.

Best regards,
Alexander

> This driver also uses C45 registers, which are not shown here. At some
> point, we might need to look at those. But first it would be good to
> understand what these differences mean.
>=20
> 	Andrew


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/



