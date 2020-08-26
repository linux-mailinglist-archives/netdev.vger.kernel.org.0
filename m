Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF24252BA7
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 12:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgHZKt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 06:49:27 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:59355 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgHZKtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 06:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598438963; x=1629974963;
  h=from:to:cc:date:message-id:references:
   content-transfer-encoding:mime-version:subject;
  bh=V6dAAwigQ03rc8u07X1ltWscDVSMfjamafwTpWqkFr4=;
  b=G/r+PFza50IUJ80GocbdjfwJ+noSJISOSIl3jqGk7veO0DfebtJhIBhV
   tqe+cXxuMTA0R55AhYBxVuyCd9fOoOe9wjcw3xyQ5E7toPcRGqQn1txkp
   xpdH75qlKUrNvQEB/R/3uEiT42LKhHitFDKbBqkbB12OBEzxWiHPaZ5JP
   I=;
X-IronPort-AV: E=Sophos;i="5.76,355,1592870400"; 
   d="scan'208";a="69831133"
Subject: RE: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long for pointer
 arithmetics
Thread-Topic: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long for pointer
 arithmetics
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 26 Aug 2020 10:49:14 +0000
Received: from EX13D04EUB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 46101A1822;
        Wed, 26 Aug 2020 10:49:12 +0000 (UTC)
Received: from EX13D11EUB002.ant.amazon.com (10.43.166.13) by
 EX13D04EUB002.ant.amazon.com (10.43.166.51) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 10:49:11 +0000
Received: from EX13D11EUB002.ant.amazon.com ([10.43.166.13]) by
 EX13D11EUB002.ant.amazon.com ([10.43.166.13]) with mapi id 15.00.1497.006;
 Wed, 26 Aug 2020 10:49:11 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Thread-Index: AQHWdi7NzspiPY1+006P3nEMueihz6k/eoMAgAFjQKCACWIfwA==
Date:   Wed, 26 Aug 2020 10:48:47 +0000
Deferred-Delivery: Wed, 26 Aug 2020 10:47:26 +0000
Message-ID: <30dd4ec5a7624acb8de8ffde6fb5d39f@EX13D11EUB002.ant.amazon.com>
References: <20200819134349.22129-1-sameehj@amazon.com>
 <20200819134349.22129-2-sameehj@amazon.com>
 <20200819141716.GE2403519@lunn.ch> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.242]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jubran, Samih
> Sent: Thursday, August 20, 2020 3:13 PM
> To: 'Andrew Lunn' <andrew@lunn.ch>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Woodhouse, David
> <dwmw@amazon.co.uk>; Machulsky, Zorik <zorik@amazon.com>;
> Matushevsky, Alexander <matua@amazon.com>; Bshara, Saeed
> <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>; Liguori,
> Anthony <aliguori@amazon.com>; Bshara, Nafea <nafea@amazon.com>;
> Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
> <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
> Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>; Dagan, Noam <ndagan@amazon.com>
> Subject: RE: [EXTERNAL] [PATCH V2 net-next 1/4] net: ena: ethtool: use
> unsigned long for pointer arithmetics
>=20
>=20
>=20
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Wednesday, August 19, 2020 5:17 PM
> > To: Jubran, Samih <sameehj@amazon.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org; Woodhouse, David
> > <dwmw@amazon.co.uk>; Machulsky, Zorik <zorik@amazon.com>;
> Matushevsky,
> > Alexander <matua@amazon.com>; Bshara, Saeed
> <saeedb@amazon.com>;
> > Wilson, Matt <msw@amazon.com>; Liguori, Anthony
> <aliguori@amazon.com>;
> > Bshara, Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> > Belgazal, Netanel <netanel@amazon.com>; Saidi, Ali
> > <alisaidi@amazon.com>; Herrenschmidt, Benjamin <benh@amazon.com>;
> > Kiyanovski, Arthur <akiyano@amazon.com>; Dagan, Noam
> > <ndagan@amazon.com>
> > Subject: RE: [EXTERNAL] [PATCH V2 net-next 1/4] net: ena: ethtool: use
> > unsigned long for pointer arithmetics
> >
> > CAUTION: This email originated from outside of the organization. Do
> > not click links or open attachments unless you can confirm the sender
> > and know the content is safe.
> >
> >
> >
> > On Wed, Aug 19, 2020 at 01:43:46PM +0000, sameehj@amazon.com wrote:
> > > From: Sameeh Jubran <sameehj@amazon.com>
> > >
> > > unsigned long is the type for doing maths on pointers.
> >
> > Maths on pointers is perfectly valid. The real issue here is you have
> > all your types mixed up.
>=20
> The stat_offset field has the bytes from the start of the struct, the mat=
h is
> perfectly valid IMO=B8 I have also went for the extra step and tested it =
using
> prints.
>=20
> >
> > > -                     ptr =3D (u64 *)((uintptr_t)&ring->tx_stats +
> > > -                             (uintptr_t)ena_stats->stat_offset);
> > > +                     ptr =3D (u64 *)((unsigned long)&ring->tx_stats =
+
> > > +                             ena_stats->stat_offset);
> >
> > struct ena_ring {
> > ...
> >         union {
> >                 struct ena_stats_tx tx_stats;
> >                 struct ena_stats_rx rx_stats;
> >         };
> >
> > struct ena_stats_tx {
> >         u64 cnt;
> >         u64 bytes;
> >         u64 queue_stop;
> >         u64 prepare_ctx_err;
> >         u64 queue_wakeup;
> >         ...
> > }
> >
> > &ring->tx_stats will give you a struct *ena_stats_tx. Arithmetic on
> > that, adding 1 for example, takes you forward a full ena_stats_tx
> > structure. Not what you want.
> >
> > &ring->tx_stats.cnt however, will give you a u64 *. Adding 1 to that
> > will give you bytes, etc.
>=20
>=20
> If I understand you well, the alternative approach you are suggesting is:
>=20
> ptr =3D &ring->tx_stats.cnt + ena_stats->stat_offset;
>=20
> of course we need to convert the stat_offset field to be in 8 bytes resol=
ution
> instead.
>=20
> This approach has a potential bug hidden in it. If in the future someone
> decides to expand the "ena_stats_tx" struct and add a field preceding cnt=
,
> cnt will no longer be the beginning of the struct, which will cause a bug=
."
>=20
> Therefore, if you have another way to do this, please share it. Otherwise=
 I'd
> rather leave this code as it is for the sake of robustness.
>=20
> >
> >      Andrew


Ping.
