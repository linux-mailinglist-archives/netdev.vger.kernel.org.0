Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC6D24BAA4
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbgHTMOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:14:46 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:23549 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgHTMNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 08:13:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1597925613; x=1629461613;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=r91ksqpCh5lHMylT7q4+0sKkFEQj64wOL26e+RpQWqI=;
  b=iI4U5g4inyvoEPcYxf6kmIins6Tpm2Zb2yuXg4FKjylRpNKcMdSyZU5R
   KEg0MOmd7qGbcz8+xx8oQnWv1/ofTosr8voolTP3ORhg8LXQXeqzakiGi
   Ek2kBVfNQjKqbJKUvxQqxbGdd9EILVvSV7s7/LsdTGB+ZXA2tROVs2/vZ
   0=;
X-IronPort-AV: E=Sophos;i="5.76,332,1592870400"; 
   d="scan'208";a="61259440"
Subject: RE: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long for pointer
 arithmetics
Thread-Topic: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long for pointer
 arithmetics
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 Aug 2020 12:13:24 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id CF76EC088B;
        Thu, 20 Aug 2020 12:13:23 +0000 (UTC)
Received: from EX13D04EUB004.ant.amazon.com (10.43.166.59) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Aug 2020 12:13:23 +0000
Received: from EX13D11EUB002.ant.amazon.com (10.43.166.13) by
 EX13D04EUB004.ant.amazon.com (10.43.166.59) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 20 Aug 2020 12:13:22 +0000
Received: from EX13D11EUB002.ant.amazon.com ([10.43.166.13]) by
 EX13D11EUB002.ant.amazon.com ([10.43.166.13]) with mapi id 15.00.1497.006;
 Thu, 20 Aug 2020 12:13:22 +0000
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
Thread-Index: AQHWdi7NzspiPY1+006P3nEMueihz6k/eoMAgAFjQKA=
Date:   Thu, 20 Aug 2020 12:13:15 +0000
Deferred-Delivery: Thu, 20 Aug 2020 12:12:41 +0000
Message-ID: <91c86d46b724411d9f788396816be30d@EX13D11EUB002.ant.amazon.com>
References: <20200819134349.22129-1-sameehj@amazon.com>
 <20200819134349.22129-2-sameehj@amazon.com>
 <20200819141716.GE2403519@lunn.ch>
In-Reply-To: <20200819141716.GE2403519@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.69]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, August 19, 2020 5:17 PM
> To: Jubran, Samih <sameehj@amazon.com>
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
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> On Wed, Aug 19, 2020 at 01:43:46PM +0000, sameehj@amazon.com wrote:
> > From: Sameeh Jubran <sameehj@amazon.com>
> >
> > unsigned long is the type for doing maths on pointers.
>=20
> Maths on pointers is perfectly valid. The real issue here is you have all=
 your
> types mixed up.

The stat_offset field has the bytes from the start of the struct, the math =
is perfectly valid IMO=B8
I have also went for the extra step and tested it using prints.

>=20
> > -                     ptr =3D (u64 *)((uintptr_t)&ring->tx_stats +
> > -                             (uintptr_t)ena_stats->stat_offset);
> > +                     ptr =3D (u64 *)((unsigned long)&ring->tx_stats +
> > +                             ena_stats->stat_offset);
>=20
> struct ena_ring {
> ...
>         union {
>                 struct ena_stats_tx tx_stats;
>                 struct ena_stats_rx rx_stats;
>         };
>=20
> struct ena_stats_tx {
>         u64 cnt;
>         u64 bytes;
>         u64 queue_stop;
>         u64 prepare_ctx_err;
>         u64 queue_wakeup;
>         ...
> }
>=20
> &ring->tx_stats will give you a struct *ena_stats_tx. Arithmetic on that,
> adding 1 for example, takes you forward a full ena_stats_tx structure. No=
t
> what you want.
>=20
> &ring->tx_stats.cnt however, will give you a u64 *. Adding 1 to that will=
 give
> you bytes, etc.


If I understand you well, the alternative approach you are suggesting is:

ptr =3D &ring->tx_stats.cnt + ena_stats->stat_offset;

of course we need to convert the stat_offset field to be in 8 bytes resolut=
ion instead.

This approach has a potential bug hidden in it. If in the future
someone decides to expand the "ena_stats_tx" struct and add a field precedi=
ng cnt,
cnt will no longer be the beginning of the struct, which will cause a bug."

Therefore, if you have another way to do this, please share it. Otherwise I=
'd
rather leave this code as it is for the sake of robustness.

>=20
>      Andrew
