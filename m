Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45934181176
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 08:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgCKHJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 03:09:28 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:12691 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKHJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 03:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583910566; x=1615446566;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=NwcQTHcDgtEoaIBKMzCOlNjokXCXk2+/tRnBfQljLhw=;
  b=e7CvU6REsPohfBvM6roahaeSJWT+jo7mmay6oXHqS4Lpdm4x9mqlDdVS
   C97gVrrZgplrMriVUDW1xycM2V+uaAfBa/1KsREB8qsMA1gCAO+G7atFm
   p4GgeZaxV8iRLN2cnzS7lIvPieDwu0TH5YsXnQiSAhshm1tH690zA/iHL
   s=;
IronPort-SDR: KCBytB5ZM+rcHQhpdjlWXv60XVH2HKQYf3fkNEEK4BQp/PSvHpbF/ky+EGk0Zw/pj9UrbJExQH
 Nufmtl2b3wbg==
X-IronPort-AV: E=Sophos;i="5.70,539,1574121600"; 
   d="scan'208";a="31902103"
Thread-Topic: [PATCH net-next 01/15] net: ena: reject unsupported coalescing params
Subject: RE: [PATCH net-next 01/15] net: ena: reject unsupported coalescing params
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 11 Mar 2020 07:09:22 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 323B2A1DD6;
        Wed, 11 Mar 2020 07:09:14 +0000 (UTC)
Received: from EX13D06EUA003.ant.amazon.com (10.43.165.206) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Wed, 11 Mar 2020 07:09:14 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D06EUA003.ant.amazon.com (10.43.165.206) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 11 Mar 2020 07:09:13 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1497.006;
 Wed, 11 Mar 2020 07:09:13 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "rmody@marvell.com" <rmody@marvell.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "skalluru@marvell.com" <skalluru@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "opendmb@gmail.com" <opendmb@gmail.com>,
        "siva.kallam@broadcom.com" <siva.kallam@broadcom.com>,
        "prashant@broadcom.com" <prashant@broadcom.com>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "leedom@chelsio.com" <leedom@chelsio.com>,
        "ulli.kroll@googlemail.com" <ulli.kroll@googlemail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Thread-Index: AQHV9oHdmKiU/eXD5kC766/hLjvYXKhB3f9ggABJTYCAACdL8IAAqMUAgAAC3JA=
Date:   Wed, 11 Mar 2020 07:09:00 +0000
Deferred-Delivery: Wed, 11 Mar 2020 07:07:56 +0000
Message-ID: <20f1889e73b34ebf95f1fe7526a8b19c@EX13D22EUA004.ant.amazon.com>
References: <20200310021512.1861626-1-kuba@kernel.org>
 <20200310021512.1861626-2-kuba@kernel.org>
 <ba82e88dd3ac45a5a8e4527531d385c0@EX13D22EUA004.ant.amazon.com>
 <20200310183147.GM242734@unreal>
 <4d4d26f2e1994d4bb22a8ab9d5f49491@EX13D22EUA004.ant.amazon.com>
 <20200311065628.GD4215@unreal>
In-Reply-To: <20200311065628.GD4215@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, March 11, 2020 8:56 AM
> To: Kiyanovski, Arthur <akiyano@amazon.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; davem@davemloft.net;
> netdev@vger.kernel.org; Belgazal, Netanel <netanel@amazon.com>; Tzalik,
> Guy <gtzalik@amazon.com>; irusskikh@marvell.com; f.fainelli@gmail.com;
> bcm-kernel-feedback-list@broadcom.com; rmody@marvell.com; GR-Linux-NIC-
> Dev@marvell.com; aelior@marvell.com; skalluru@marvell.com; GR-everest-
> linux-l2@marvell.com; opendmb@gmail.com; siva.kallam@broadcom.com;
> prashant@broadcom.com; mchan@broadcom.com; dchickles@marvell.com;
> sburla@marvell.com; fmanlunas@marvell.com; tariqt@mellanox.com;
> vishal@chelsio.com; leedom@chelsio.com; ulli.kroll@googlemail.com;
> linus.walleij@linaro.org
> Subject: RE: [EXTERNAL][PATCH net-next 01/15] net: ena: reject unsupporte=
d
> coalescing params
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> On Tue, Mar 10, 2020 at 08:55:33PM +0000, Kiyanovski, Arthur wrote:
> >
> >
> > > -----Original Message-----
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Tuesday, March 10, 2020 8:32 PM
> > > To: Kiyanovski, Arthur <akiyano@amazon.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>; davem@davemloft.net;
> > > netdev@vger.kernel.org; Belgazal, Netanel <netanel@amazon.com>;
> > > Tzalik, Guy <gtzalik@amazon.com>; irusskikh@marvell.com;
> > > f.fainelli@gmail.com; bcm-kernel-feedback-list@broadcom.com;
> > > rmody@marvell.com; GR-Linux-NIC- Dev@marvell.com;
> > > aelior@marvell.com; skalluru@marvell.com; GR-everest-
> > > linux-l2@marvell.com; opendmb@gmail.com; siva.kallam@broadcom.com;
> > > prashant@broadcom.com; mchan@broadcom.com;
> dchickles@marvell.com;
> > > sburla@marvell.com; fmanlunas@marvell.com; tariqt@mellanox.com;
> > > vishal@chelsio.com; leedom@chelsio.com; ulli.kroll@googlemail.com;
> > > linus.walleij@linaro.org
> > > Subject: RE: [EXTERNAL][PATCH net-next 01/15] net: ena: reject
> > > unsupported coalescing params
> > >
> > > CAUTION: This email originated from outside of the organization. Do
> > > not click links or open attachments unless you can confirm the
> > > sender and know the content is safe.
> > >
> > >
> > >
> > > On Tue, Mar 10, 2020 at 02:16:03PM +0000, Kiyanovski, Arthur wrote:
> > > > > -----Original Message-----
> > > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > > Sent: Tuesday, March 10, 2020 4:15 AM
> > > > > To: davem@davemloft.net
> > > > > Cc: netdev@vger.kernel.org; Kiyanovski, Arthur
> > > > > <akiyano@amazon.com>; Belgazal, Netanel <netanel@amazon.com>;
> > > > > Tzalik, Guy <gtzalik@amazon.com>; irusskikh@marvell.com;
> > > > > f.fainelli@gmail.com;
> > > > > bcm-kernel-feedback- list@broadcom.com; rmody@marvell.com;
> > > > > GR-Linux-NIC-Dev@marvell.com; aelior@marvell.com;
> > > > > skalluru@marvell.com; GR-everest-linux-l2@marvell.com;
> > > > > opendmb@gmail.com; siva.kallam@broadcom.com;
> > > prashant@broadcom.com;
> > > > > mchan@broadcom.com; dchickles@marvell.com; sburla@marvell.com;
> > > > > fmanlunas@marvell.com; tariqt@mellanox.com; vishal@chelsio.com;
> > > > > leedom@chelsio.com; ulli.kroll@googlemail.com;
> > > > > linus.walleij@linaro.org; Jakub Kicinski <kuba@kernel.org>
> > > > > Subject: [EXTERNAL][PATCH net-next 01/15] net: ena: reject
> > > > > unsupported coalescing params
> > > > >
> > > > > CAUTION: This email originated from outside of the organization.
> > > > > Do not click links or open attachments unless you can confirm
> > > > > the sender and know the content is safe.
> > > > >
> > > > >
> > > > >
> > > > > Set ethtool_ops->supported_coalesce_params to let the core
> > > > > reject unsupported coalescing parameters.
> > > > >
> > > > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > > > ---
> > > > >  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 2 ++
> > > > >  1 file changed, 2 insertions(+)
> > > > >
> > > > > diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > > > > b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > > > > index 868265a2ec00..552d4cbf6dbd 100644
> > > > > --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > > > > +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > > > > @@ -826,6 +826,8 @@ static int ena_set_tunable(struct net_device
> > > > > *netdev,  }
> > > > >
> > > > >  static const struct ethtool_ops ena_ethtool_ops =3D {
> > > > > +       .supported_coalesce_params =3D ETHTOOL_COALESCE_USECS |
> > > > > +
> > > > > + ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
> > > > >         .get_link_ksettings     =3D ena_get_link_ksettings,
> > > > >         .get_drvinfo            =3D ena_get_drvinfo,
> > > > >         .get_msglevel           =3D ena_get_msglevel,
> > > > > --
> > > > > 2.24.1
> > > >
> > > >
> > > > Acked-by: Sameeh Jubran <sameehj@amazon.com>
> > >
> > > FROM author of this reply and Acked-by doesn't look the same.
> > > Which one is correct?
> > >
> > > Thanks
> >
> > Sameeh did the check, I sent the email.
> > So the correct one is the one written in the email:
> > Acked-by: Sameeh Jubran <sameehj@amazon.com>
> >
> > Sorry for the confusion.
>=20
> It is important that the one who adds "-by" writes the email and uses sam=
e
> name, because get-lore-mbox.py (the new tool that used by many maintainer=
s
> to grab patches) performs strict check between From and tags to be on the=
 safe
> side.
>=20
> Thanks

Got it, thanks!
