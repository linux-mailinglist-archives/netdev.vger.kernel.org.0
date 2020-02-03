Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9462F1507DB
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 14:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgBCN7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 08:59:52 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:33559 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgBCN7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 08:59:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580738391; x=1612274391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gexhy55vQcPM4ayqoWA/XA8iSSvx6fDhT/0GuvPgK+g=;
  b=aYb/MiyLGeE50zdmTbwR0/o/3eLRUVtgmHMHaHB5gTec7ZCr1+BaDbEV
   GYyMeTbytyhDXUm2OFGMsSSiMR/dOBZbF2CZ1f9K43gxDeMIHtYaXUIjc
   u0LCxeVqv0+wnKIsMvjh85ugg6upTDh/mkVnOTPDrC9apW687l2KJSns8
   Y=;
IronPort-SDR: 6qBHkzLct34T6aGcoYMovYKDOSxAtrpnQsedCHqlfJqKxJnHLVDoNDLjbVmSup9qYBrNF4B2By
 XyFXik75Oxrw==
X-IronPort-AV: E=Sophos;i="5.70,398,1574121600"; 
   d="scan'208";a="15423882"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Feb 2020 13:59:49 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 4B689221A6E;
        Mon,  3 Feb 2020 13:59:48 +0000 (UTC)
Received: from EX13D17EUB001.ant.amazon.com (10.43.166.85) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 3 Feb 2020 13:59:48 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D17EUB001.ant.amazon.com (10.43.166.85) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Feb 2020 13:59:47 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Mon, 3 Feb 2020 13:59:46 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: RE: [PATCH V1 net 04/11] net: ena: fix incorrect default RSS key
Thread-Topic: [PATCH V1 net 04/11] net: ena: fix incorrect default RSS key
Thread-Index: AQHV1q0EaTBNsOgvfUeL9rNDZ7eHoqgBzduAgAe4QaA=
Date:   Mon, 3 Feb 2020 13:59:35 +0000
Deferred-Delivery: Mon, 3 Feb 2020 13:58:46 +0000
Message-ID: <1bfd6d262bcb4200b1c454c14749794b@EX13D11EUB003.ant.amazon.com>
References: <20200129140422.20166-1-sameehj@amazon.com>
        <20200129140422.20166-5-sameehj@amazon.com> <20200129080311.0bc5af60@cakuba>
In-Reply-To: <20200129080311.0bc5af60@cakuba>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.146]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, January 29, 2020 6:03 PM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Kiyanovski, Arthur
> <akiyano@amazon.com>; Woodhouse, David <dwmw@amazon.co.uk>;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Wilson,
> Matt <msw@amazon.com>; Liguori, Anthony <aliguori@amazon.com>;
> Bshara, Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> Belgazal, Netanel <netanel@amazon.com>; Saidi, Ali
> <alisaidi@amazon.com>; Herrenschmidt, Benjamin <benh@amazon.com>;
> Dagan, Noam <ndagan@amazon.com>
> Subject: Re: [PATCH V1 net 04/11] net: ena: fix incorrect default RSS key
>=20
> On Wed, 29 Jan 2020 14:04:15 +0000, Sameeh Jubran wrote:
> > From: Arthur Kiyanovski <akiyano@amazon.com>
> >
> > Bug description:
> > When running "ethtool -x <if_name>" the key shows up as all zeros.
> >
> > When we use "ethtool -X <if_name> hfunc toeplitz hkey
> > <some:random:key>" to set the key and then try to retrieve it using
> > "ethtool -x <if_name>" then we return the correct key because we return
> the one we saved.
> >
> > Bug cause:
> > We don't fetch the key from the device but instead return the key that
> > we have saved internally which is by default set to zero upon
> > allocation.
> >
> > Fix:
> > This commit fixes the issue by initializing the key to the default key
> > that is used by the device.
> >
> > Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic
> > Network Adapters (ENA)")
> > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>=20
> So is the device actually using that key by default?
>=20
> Hard coding a default RSS key makes it trivial for DDoS attackers to targ=
et
> specific queues, doesn't it?
>=20
> Please follow the best practice of initializing your key with
> netdev_rss_key_fill() and configuring the device with it at startup.
>=20
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c
> > b/drivers/net/ethernet/amazon/ena/ena_com.c
> > index e54c44fdc..769339043 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_com.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_com.c
> > @@ -64,6 +64,15 @@
> >
> >  #define ENA_POLL_MS	5
> >
> > +/* Default Microsoft RSS key, used for HRSS. */ static const u8
> > +rss_hash_key[ENA_HASH_KEY_SIZE] =3D {
> > +		0x6d, 0x5a, 0x56, 0xda, 0x25, 0x5b, 0x0e, 0xc2,
> > +		0x41, 0x67, 0x25, 0x3d, 0x43, 0xa3, 0x8f, 0xb0,
> > +		0xd0, 0xca, 0x2b, 0xcb, 0xae, 0x7b, 0x30, 0xb4,
> > +		0x77, 0xcb, 0x2d, 0xa3, 0x80, 0x30, 0xf2, 0x0c,
> > +		0x6a, 0x42, 0xb7, 0x3b, 0xbe, 0xac, 0x01, 0xfa
>=20
> You also have an extra tab here for no reason.
>=20
> > +};
> > +
> >
> >
> /**********************************************************
> ***********
> > ********/
> >
> /**********************************************************
> ***********
> > ********/
> >
> /**********************************************************
> ***********
> > ********/

Hi Jakub,

Thanks for your comments,
Will fix ASAP and send v2.
