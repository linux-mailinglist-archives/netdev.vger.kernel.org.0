Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB28E3AFDB
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 09:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbfFJHqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 03:46:13 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:9267 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387781AbfFJHqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 03:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560152772; x=1591688772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8koXHAg1VjqHAto11B8cKapKPBgE8XlxoiCfoeRQijU=;
  b=LL27DSDlJjEJ7u4t6hnw9hnHav1S1XWe6gaWPbsIUJclZUTcNuj/U2P7
   ZixNClsFd+Gz3f+F7VOrpFTrHCgAnJbNEHlVoR/cvQ21cOexD6HXz/7wr
   x2nub7HM1cVXzviPHxgkbSpzNQqj+sU+yVfySq/djdFSiU6eaFQBi54g/
   U=;
X-IronPort-AV: E=Sophos;i="5.60,573,1549929600"; 
   d="scan'208";a="405718555"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Jun 2019 07:46:11 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id E368AC05FF;
        Mon, 10 Jun 2019 07:46:10 +0000 (UTC)
Received: from EX13D22EUB001.ant.amazon.com (10.43.166.145) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 07:46:10 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D22EUB001.ant.amazon.com (10.43.166.145) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 10 Jun 2019 07:46:09 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Mon, 10 Jun 2019 07:46:08 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
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
Subject: RE: [PATCH V1 net-next 5/6] net: ena: add ethtool function for
 changing io queue sizes
Thread-Topic: [PATCH V1 net-next 5/6] net: ena: add ethtool function for
 changing io queue sizes
Thread-Index: AQHVHF7IiJgkSzvEv0W2cZfiTCX6A6aOtQyAgAXSqfA=
Date:   Mon, 10 Jun 2019 07:46:08 +0000
Message-ID: <45419c297d5241d9a7768b4d9af7d9f6@EX13D11EUB003.ant.amazon.com>
References: <20190606115520.20394-1-sameehj@amazon.com>
 <20190606115520.20394-6-sameehj@amazon.com>
 <20190606144825.GB21536@unicorn.suse.cz>
In-Reply-To: <20190606144825.GB21536@unicorn.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Thursday, June 6, 2019 5:48 PM
> To: netdev@vger.kernel.org
> Cc: Jubran, Samih <sameehj@amazon.com>; davem@davemloft.net;
> Woodhouse, David <dwmw@amazon.co.uk>; Machulsky, Zorik
> <zorik@amazon.com>; Matushevsky, Alexander <matua@amazon.com>;
> Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>;
> Liguori, Anthony <aliguori@amazon.com>; Bshara, Nafea
> <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal,
> Netanel <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>;
> Herrenschmidt, Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> <akiyano@amazon.com>
> Subject: Re: [PATCH V1 net-next 5/6] net: ena: add ethtool function for
> changing io queue sizes
>=20
> On Thu, Jun 06, 2019 at 02:55:19PM +0300, sameehj@amazon.com wrote:
> > From: Sameeh Jubran <sameehj@amazon.com>
> >
> > Implement the set_ringparam() function of the ethtool interface to
> > enable the changing of io queue sizes.
> >
> > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> > ---
> >  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 25
> > +++++++++++++++++++
> drivers/net/ethernet/amazon/ena/ena_netdev.c  |
> > 14 +++++++++++  drivers/net/ethernet/amazon/ena/ena_netdev.h  |  5
> > +++-
> >  3 files changed, 43 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > index 101d93f16..33e28ad71 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > @@ -495,6 +495,30 @@ static void ena_get_ringparam(struct net_device
> *netdev,
> >  	ring->rx_pending =3D adapter->rx_ring[0].ring_size;  }
> >
> > +static int ena_set_ringparam(struct net_device *netdev,
> > +			     struct ethtool_ringparam *ring) {
> > +	struct ena_adapter *adapter =3D netdev_priv(netdev);
> > +	u32 new_tx_size, new_rx_size;
> > +
> > +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> > +		return -EINVAL;
>=20
> This check is superfluous as ethtool_set_ringparam() checks supplied valu=
es
> against maximum returned by ->get_ringparam() which will be 0 in this cas=
e.
>=20
> > +
> > +	new_tx_size =3D clamp_val(ring->tx_pending, ENA_MIN_RING_SIZE,
> > +				adapter->max_tx_ring_size);
> > +	new_tx_size =3D rounddown_pow_of_two(new_tx_size);
> > +
> > +	new_rx_size =3D clamp_val(ring->rx_pending, ENA_MIN_RING_SIZE,
> > +				adapter->max_rx_ring_size);
> > +	new_rx_size =3D rounddown_pow_of_two(new_rx_size);
>=20
> For the same reason, clamping from below would suffice here.
>=20
> Michal Kubecek
>=20
> > +
> > +	if (new_tx_size =3D=3D adapter->requested_tx_ring_size &&
> > +	    new_rx_size =3D=3D adapter->requested_rx_ring_size)
> > +		return 0;
> > +
> > +	return ena_update_queue_sizes(adapter, new_tx_size,
> new_rx_size); }

You are right with both arguments the way the code is written now, however,=
 in the future the code might change and we prefer to be extra cautious.
