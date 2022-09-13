Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCA45B7A7E
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiIMTFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbiIMTFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:05:07 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE8814019
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:05:03 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 2C74F7F458;
        Tue, 13 Sep 2022 21:04:57 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 152A834064;
        Tue, 13 Sep 2022 21:04:57 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF1E43405A;
        Tue, 13 Sep 2022 21:04:56 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Tue, 13 Sep 2022 21:04:56 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id BE2B97F458;
        Tue, 13 Sep 2022 21:04:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1663095896; bh=CXK1NU0uTJ816pExHuQRwtsgHKYbOOv4viCdd1NQlqs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lVhv5u5WswdnSkKMlOaz51rwqOqN3+zGl5y+c0rMy71byMkVGPxfJqimTP5WhIdD/
         D0wdfSPHktOYx4Ad4lfPTgER5PFeo2vXaJPmVwfj6hqB5Li3J7a+fpQLkA7nWcpTaf
         f5OSqiKNIlwR9yGC+PhBBNQi5mjT4MNl5t9MhrwrghTXCTfCWltEJH1NacfjJ8yEL1
         NFrOhFJMmgDs5afthzKr3Ts29Hgj68anQWJpBAD2Q6/rE4mIbjEv6rVgPR+IBlt1FM
         dSaMSuhkoJNPbHvwo7nFwd/SiEHqattdS4MHAFZGbv5SbutIXw4hcoZWiiiMOIime4
         KTE+xKKf42gLQ==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.12; Tue, 13 Sep 2022 21:04:56 +0200
Received: from atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7]) by
 atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7%11]) with mapi id
 15.01.2507.012; Tue, 13 Sep 2022 21:04:56 +0200
From:   =?iso-8859-2?Q?Cs=F3k=E1s_Bence?= <Csokas.Bence@prolan.hu>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        =?iso-8859-2?Q?Bence_Cs=F3k=E1s?= <bence98@sch.bme.hu>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guenter Roeck <linux@roeck-us.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] Revert "net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`"
Thread-Topic: [PATCH 1/2] Revert "net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`"
Thread-Index: AQHYxnY4XgOYoxJ+nEa6KfoL5bYaqq3beRcAgAI/OXA=
Date:   Tue, 13 Sep 2022 19:04:56 +0000
Message-ID: <3f2824bc776f4383b84e4137f6c740de@prolan.hu>
References: <20220912073106.2544207-1-bence98@sch.bme.hu>,<20220912103818.j2u6afz66tcxvnr6@pengutronix.de>
In-Reply-To: <20220912103818.j2u6afz66tcxvnr6@pengutronix.de>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [152.66.181.220]
x-esetresult: clean, is OK
x-esetid: 37303A29971EF4566D7765
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This is not a 100% revert.
>=20
> In b353b241f1eb ("net: fec: Use a spinlock to guard `fep->ptp_clk_on`")
> the "struct fec_enet_private *fep" was renamed to "struct
> fec_enet_private *adapter" for no apparent reason. The driver uses "fep"
> everywhere else. This revert doesn't restore the original state.

You got that backwards. b353b241f1eb renamed `adapter` to `fep` to align
it with the rest of the driver. I decided to amend the revert to keep this =
renaming.
`adapter` was introduced in 6605b73 when `fec_ptp.c` was created.

> This leads to the following diff against a 100% revert.
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ether=
net/freescale/fec_ptp.c
> index c99dff3c3422..c74d04f4b2fd 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -365,21 +365,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *p=
tp, s64 delta)
> =A0 */
> =A0static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec=
64 *ts)
> =A0{
> -=A0=A0=A0=A0=A0=A0 struct fec_enet_private *fep =3D
> +=A0=A0=A0=A0=A0=A0 struct fec_enet_private *adapter =3D

Here you can clearly see the nature of my amend. I thought I added this to =
the commit message,
but it seems I have forgot.

Bence=
