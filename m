Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6F36B7B95
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388447AbfISOF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:05:56 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:47351 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388331AbfISOFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568901954; x=1600437954;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hmapruwZyNdRQkvjbciWnTNKBVCrKNJeWbwPC0wwJsw=;
  b=W5q6Anj4g4RLCYcTP6SsAEAaaDWsacNJxLL2+WA0dGJKVpfqEiFFZqwT
   qmGYP639q4Krjkbky+uwcnb2d6q/mSKfKX1uEKx9A+C2+qCgH8mv2FMVv
   qKNee3hTJq1QRdWsRdHTxvG9tQtKnkMPxkRpMfpPv/ZkpTshyKV/1NozY
   I=;
X-IronPort-AV: E=Sophos;i="5.64,523,1559520000"; 
   d="scan'208";a="834526043"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 19 Sep 2019 14:05:35 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id BB9B7A1D6D;
        Thu, 19 Sep 2019 14:05:34 +0000 (UTC)
Received: from EX13D08EUB002.ant.amazon.com (10.43.166.232) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 14:05:34 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D08EUB002.ant.amazon.com (10.43.166.232) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 14:05:33 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Thu, 19 Sep 2019 14:05:33 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
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
        "Kiyanovski, Arthur" <akiyano@amazon.com>
Subject: RE: [PATCH V1 net-next 2/5] net: ena: multiple queue creation related
 cleanups
Thread-Topic: [PATCH V1 net-next 2/5] net: ena: multiple queue creation
 related cleanups
Thread-Index: AQHVa9ocPyQgd6KkfkmwaolqL/2rKKcutqQAgARX1bA=
Date:   Thu, 19 Sep 2019 14:05:32 +0000
Message-ID: <ffbbb841d147426bb76a6c4e77d4c1f9@EX13D11EUB003.ant.amazon.com>
References: <20190915152722.8240-1-sameehj@amazon.com>
        <20190915152722.8240-3-sameehj@amazon.com>
 <20190916.214438.647698482843698023.davem@davemloft.net>
In-Reply-To: <20190916.214438.647698482843698023.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.196]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Monday, September 16, 2019 10:45 PM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: netdev@vger.kernel.org; Woodhouse, David <dwmw@amazon.co.uk>;
> Machulsky, Zorik <zorik@amazon.com>; Matushevsky, Alexander
> <matua@amazon.com>; Bshara, Saeed <saeedb@amazon.com>; Wilson,
> Matt <msw@amazon.com>; Liguori, Anthony <aliguori@amazon.com>;
> Bshara, Nafea <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> Belgazal, Netanel <netanel@amazon.com>; Saidi, Ali
> <alisaidi@amazon.com>; Herrenschmidt, Benjamin <benh@amazon.com>;
> Kiyanovski, Arthur <akiyano@amazon.com>
> Subject: Re: [PATCH V1 net-next 2/5] net: ena: multiple queue creation
> related cleanups
>=20
> From: <sameehj@amazon.com>
> Date: Sun, 15 Sep 2019 18:27:19 +0300
>=20
> > @@ -1885,6 +1885,13 @@ static int ena_up(struct ena_adapter *adapter)
> >  	if (rc)
> >  		goto err_req_irq;
> >
> > +	netif_info(adapter, ifup, adapter->netdev, "creating %d io queues.
> rx queue size: %d tx queue size. %d LLQ is %s\n",
> > +		   adapter->num_io_queues,
> > +		   adapter->requested_rx_ring_size,
> > +		   adapter->requested_tx_ring_size,
> > +		   (adapter->ena_dev->tx_mem_queue_type =3D=3D
> ENA_ADMIN_PLACEMENT_POLICY_DEV) ?
> > +		   "ENABLED" : "DISABLED");
>=20
> Please don't clog up the kernel log with stuff like this.
>=20
> Maybe netif_debug() at best, but I'd rather you remove this entirely.  It=
's so
> easy to make a device go up and down repeatedly multiple times in one
> second.
Dropped in v2.
