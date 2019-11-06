Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDC6F1E5C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbfKFTNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:13:54 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:63890 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfKFTNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 14:13:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1573067633; x=1604603633;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uwz+kUHlRIMj2gNUDtFR43G3VvcUzNZtmp1FKBtrdD0=;
  b=l0jC5eUNgAjb5wjLZrgP7AEyv5oHSb4jEyuuCIwin3Udw7kCqZQd+nhi
   9UrAHsHy/j4UpFWDVtiYbGwqr+n2tBrUeEMdcaQ8c31Cq1C44nkbsR9ov
   0403tZdr+z+GUByZB09HGEnzhR+uggHnMxP43xqXkT/uWMTAqFPSJnPQK
   c=;
IronPort-SDR: XMM7Uac77algBK8e+BH7vVsWvtCsxEIvPRlsu3jWVFANhFqxf8wcsS5xuvSYP6SFhEHYuh0KXT
 Ld1l7q5ffh1w==
X-IronPort-AV: E=Sophos;i="5.68,275,1569283200"; 
   d="scan'208";a="2522890"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 06 Nov 2019 19:13:43 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 27CDEA2277;
        Wed,  6 Nov 2019 19:13:42 +0000 (UTC)
Received: from EX13D04EUA002.ant.amazon.com (10.43.165.75) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 6 Nov 2019 19:13:41 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D04EUA002.ant.amazon.com (10.43.165.75) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 6 Nov 2019 19:13:40 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1367.000;
 Wed, 6 Nov 2019 19:13:40 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Subject: RE: [PATCH V1 net 2/2] net: ena: fix too long default tx interrupt
 moderation interval
Thread-Topic: [PATCH V1 net 2/2] net: ena: fix too long default tx interrupt
 moderation interval
Thread-Index: AQHVkwdBzI+QaDLoGECikvAWG9JP5Kd7Y1QAgAMiL0A=
Date:   Wed, 6 Nov 2019 19:13:06 +0000
Deferred-Delivery: Wed, 6 Nov 2019 19:12:49 +0000
Message-ID: <081dc70c42bb4c638f8d2fcb669941cd@EX13D22EUA004.ant.amazon.com>
References: <1572868728-5211-1-git-send-email-akiyano@amazon.com>
        <1572868728-5211-3-git-send-email-akiyano@amazon.com>
 <20191104.111852.941272299166797826.davem@davemloft.net>
In-Reply-To: <20191104.111852.941272299166797826.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Monday, November 4, 2019 9:19 PM
> To: Kiyanovski, Arthur <akiyano@amazon.com>
> Cc: netdev@vger.kernel.org; Woodhouse, David <dwmw@amazon.co.uk>;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Wilson,
> Matt <msw@amazon.com>; Liguori, Anthony <aliguori@amazon.com>;
> Bshara, Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> Belgazal, Netanel <netanel@amazon.com>; Saidi, Ali
> <alisaidi@amazon.com>; Herrenschmidt, Benjamin <benh@amazon.com>;
> Dagan, Noam <ndagan@amazon.com>; Agroskin, Shay
> <shayagr@amazon.com>
> Subject: Re: [PATCH V1 net 2/2] net: ena: fix too long default tx interru=
pt
> moderation interval
>=20
> From: <akiyano@amazon.com>
> Date: Mon, 4 Nov 2019 13:58:48 +0200
>=20
> > From: Arthur Kiyanovski <akiyano@amazon.com>
> >
> > Current default non-adaptive tx interrupt moderation interval is 196 us=
.
> > This commit sets it to 0, which is much more sensible as a default valu=
e.
> > It can be modified using ethtool -C.
> >
> > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>=20
> I do not agree that turning TX interrupt moderation off completely is a m=
ore
> sensible default value.
>=20
> Maybe a much smaller value, but turning off the coalescing delay complete=
ly
> is a bit much.

David,
Up until now, the ENA device did not support interrupt moderation, so effec=
tively the default tx interrupt moderation interval was 0.
You are probably right that 0 is not an optimal value.
However until we research and find such an optimal value, in order to avoid=
 a degradation in default performance, we want the default value in the new=
 driver to be (effectively) the same as in the old driver.

