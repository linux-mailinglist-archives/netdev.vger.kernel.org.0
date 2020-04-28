Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5925F1BB788
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgD1HbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:31:00 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:12185 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgD1HbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588059060; x=1619595060;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=2HjLZWHOaVF7NHiqDMc/jh6mSztneNaJ8cvr+FXkqRk=;
  b=Zom1g2cpxGDmV65lbCH2okV21yfqF59nTAoEoG4SLsphjOGmI2AXxgK/
   L3TVT5IBtd8Om7RdHp7B/DHApkXOxo/8SDz6hB0MzK8/Hdg2zNKJvPWy8
   AoU3Xm7HwuxJ14ryx9KLHfbIiOaO/zga0eXtWBgDrssRzjuBUMGGXrZXS
   0=;
IronPort-SDR: xE0MMxLT4d9d/K0Zn6QfVoxWjHooUtfTxPhOvodLkC4XbHfWc5ASomA1fDvmZerW8qPK1ofOde
 +QoC0YPeEfZw==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="31563569"
Subject: RE: [PATCH V1 net-next 08/13] net: ena: add support for reporting of packet
 drops
Thread-Topic: [PATCH V1 net-next 08/13] net: ena: add support for reporting of packet drops
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Apr 2020 07:30:59 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id D1334A1D15;
        Tue, 28 Apr 2020 07:30:57 +0000 (UTC)
Received: from EX13D17EUC001.ant.amazon.com (10.43.164.233) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:30:55 +0000
Received: from EX13D11EUC003.ant.amazon.com (10.43.164.153) by
 EX13D17EUC001.ant.amazon.com (10.43.164.233) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:30:53 +0000
Received: from EX13D11EUC003.ant.amazon.com ([10.43.164.153]) by
 EX13D11EUC003.ant.amazon.com ([10.43.164.153]) with mapi id 15.00.1497.006;
 Tue, 28 Apr 2020 07:30:54 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
        "Dagan, Noam" <ndagan@amazon.com>,
        "Chauskin, Igor" <igorch@amazon.com>
Thread-Index: AQHWGH5V48df1KqU/EuT5Cj12GhQ7aiF4IuAgAhLmmA=
Date:   Tue, 28 Apr 2020 07:30:47 +0000
Deferred-Delivery: Tue, 28 Apr 2020 07:29:36 +0000
Message-ID: <66b28156efe94d04ae379458bfe3529c@EX13D11EUC003.ant.amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
        <20200422081628.8103-9-sameehj@amazon.com>
 <20200422174729.19fae03f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200422174729.19fae03f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 23, 2020 3:47 AM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Woodhouse, David
> <dwmw@amazon.co.uk>; Machulsky, Zorik <zorik@amazon.com>;
> Matushevsky, Alexander <matua@amazon.com>; Bshara, Saeed
> <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>; Liguori,
> Anthony <aliguori@amazon.com>; Bshara, Nafea <nafea@amazon.com>;
> Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
> <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
> Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>; Dagan, Noam <ndagan@amazon.com>; Chauskin,
> Igor <igorch@amazon.com>
> Subject: RE: [EXTERNAL] [PATCH V1 net-next 08/13] net: ena: add support f=
or
> reporting of packet drops
>=20
>=20
> On Wed, 22 Apr 2020 08:16:23 +0000 sameehj@amazon.com wrote:
> > From: Sameeh Jubran <sameehj@amazon.com>
> >
> > 1. Add support for getting tx drops from the device and saving them in
> > the driver.
> > 2. Report tx and rx drops via ethtool.
> > 3. Report tx via netdev stats.
>=20
> Please don't duplicate what's already reported in standard stats in ethto=
ol -S.
Dropped from ethtool in v2.
