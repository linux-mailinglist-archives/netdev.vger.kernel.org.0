Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 854AA17FFFC
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 15:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgCJORS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 10:17:18 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:62081 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgCJORR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 10:17:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1583849837; x=1615385837;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=VmpHv86wVS+RRiIxZ/OYQ9aDOuQfEbNWHlmubXhkiD4=;
  b=Qj/hHnBbwvk3ARqfUZLmws0cRoDFsIIaMEUtFak5qHTaX3c8s1Xm6Wdz
   WW6oFvkFUqv9WCsHSggw7nlAQtitLCuJjWJgaEP1ZVp04SEzxcn3/fkFW
   WAJlWgIljcAY1x+IvG7a57DH/M0kt0/ln5GSBVguOpdTx39K4TrCEdIYm
   0=;
IronPort-SDR: 1WCbZSZNgPtoNphPyx19vWhmQ8jtJxxK6hk0NQQEPvxTjBsQJiZu3RhXo3OAxuf3KdQsdO998j
 ERlznNhQEZ1g==
X-IronPort-AV: E=Sophos;i="5.70,537,1574121600"; 
   d="scan'208";a="30336787"
Thread-Topic: [PATCH net-next 01/15] net: ena: reject unsupported coalescing params
Subject: RE: [PATCH net-next 01/15] net: ena: reject unsupported coalescing params
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Mar 2020 14:17:14 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id CB7E5A03BF;
        Tue, 10 Mar 2020 14:17:12 +0000 (UTC)
Received: from EX13D06EUA003.ant.amazon.com (10.43.165.206) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 10 Mar 2020 14:17:11 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D06EUA003.ant.amazon.com (10.43.165.206) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 10 Mar 2020 14:17:10 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1497.006;
 Tue, 10 Mar 2020 14:17:10 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Thread-Index: AQHV9oHdmKiU/eXD5kC766/hLjvYXKhB3f9g
Date:   Tue, 10 Mar 2020 14:16:03 +0000
Deferred-Delivery: Tue, 10 Mar 2020 14:11:14 +0000
Message-ID: <ba82e88dd3ac45a5a8e4527531d385c0@EX13D22EUA004.ant.amazon.com>
References: <20200310021512.1861626-1-kuba@kernel.org>
 <20200310021512.1861626-2-kuba@kernel.org>
In-Reply-To: <20200310021512.1861626-2-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, March 10, 2020 4:15 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; Kiyanovski, Arthur <akiyano@amazon.com>;
> Belgazal, Netanel <netanel@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> irusskikh@marvell.com; f.fainelli@gmail.com; bcm-kernel-feedback-
> list@broadcom.com; rmody@marvell.com; GR-Linux-NIC-Dev@marvell.com;
> aelior@marvell.com; skalluru@marvell.com; GR-everest-linux-l2@marvell.com=
;
> opendmb@gmail.com; siva.kallam@broadcom.com; prashant@broadcom.com;
> mchan@broadcom.com; dchickles@marvell.com; sburla@marvell.com;
> fmanlunas@marvell.com; tariqt@mellanox.com; vishal@chelsio.com;
> leedom@chelsio.com; ulli.kroll@googlemail.com; linus.walleij@linaro.org;
> Jakub Kicinski <kuba@kernel.org>
> Subject: [EXTERNAL][PATCH net-next 01/15] net: ena: reject unsupported
> coalescing params
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> Set ethtool_ops->supported_coalesce_params to let the core reject
> unsupported coalescing parameters.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> index 868265a2ec00..552d4cbf6dbd 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> @@ -826,6 +826,8 @@ static int ena_set_tunable(struct net_device *netdev,=
  }
>=20
>  static const struct ethtool_ops ena_ethtool_ops =3D {
> +       .supported_coalesce_params =3D ETHTOOL_COALESCE_USECS |
> +                                    ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
>         .get_link_ksettings     =3D ena_get_link_ksettings,
>         .get_drvinfo            =3D ena_get_drvinfo,
>         .get_msglevel           =3D ena_get_msglevel,
> --
> 2.24.1


Acked-by: Sameeh Jubran <sameehj@amazon.com>
