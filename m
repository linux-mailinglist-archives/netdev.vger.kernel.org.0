Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF8180EBE
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 04:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbgCKDri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 23:47:38 -0400
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:6072
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727659AbgCKDri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 23:47:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5MgLiqPdUqcZYxexYx4Ptn4xGEeACHuSvmiwMFXyu+RQhPbBZrdpZaGk2HwYBJVL+SuaWFg2G56FIa6S7tdQOu6T5UMcZrCuyP9fQmQjdWifB50tcqwwJD7AmkPbu0Qs4d29yeBMUevKmZ4ii9MZ7N5F2jG47Afg3U8DT2ZLh0jQqewIzuu70FQWIWZYqTs0W8/7AfVOmrsmUwKM/OdwSo61f7IiY5CRXfxgCNNHm0dGIOFtoE6kz6otm0a4J8X9ryRajzD9mHkNj2w2B5+MAQ6Q+NZ+jwXr6mmBQrXYZEfBZrWthyRyPbnK/M5EGg2q4xQak70x89rcLlH0zGtOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6Zh7EsAwPGfENw0su1cyndsjzosP1tqhPsJzrXxb3Q=;
 b=FjD6R0hpiQnqOYepeVQjWhGU+FaqDImbU+Lsp0E//0tOwS0WxK1Zhgto7ppzQjtUZvX8ITsrhqh/qmoyYU54syXy/tG6uUMojQj68iuBVZY2EnZwiV4WBWvO+R8VV0ojT9CeibkTOYYrIBk3yj8xjHlz//tnauv6OM5gVGg6fH8N+Bwxm5UnTajlIs91kuh5yJ8Dv5C4It8mT5rE5rRUc/OLaVa53dB51W1wqvCNqzcmv6S1Gckhbq3HC6fPCNLQbG2pLqO/J5Im+zFKnvtrdHC+VzkXajSJNdNKz8dNdhDJfhz8J27u4rood+BI7YusQG3PbHTLVEnlamYbFXV2bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6Zh7EsAwPGfENw0su1cyndsjzosP1tqhPsJzrXxb3Q=;
 b=UdxtxD/mvkNxs9VVJbSTjps1d6HcHJZMasNW8XbY5odFb4XocHisLa8CTjISgtFFt/mMrKirMJ3ULzNqGsgixyDBB1/XQuCkGY6eoaHdDmL8FCPvzetR+AcZcrew99CNvLHUMTDScIXRKyTZE/9CCXrBpxo9iTslVEtifuJKUpo=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3917.eurprd04.prod.outlook.com (52.134.19.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11; Wed, 11 Mar 2020 03:47:34 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 03:47:34 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Frank Li <frank.li@nxp.com>
Subject: RE: [EXT] [PATCH net] net: fec: validate the new settings in
 fec_enet_set_coalesce()
Thread-Topic: [EXT] [PATCH net] net: fec: validate the new settings in
 fec_enet_set_coalesce()
Thread-Index: AQHV91Y+qbFxFG4V2Um6AulixrkN6KhCwHeA
Date:   Wed, 11 Mar 2020 03:47:34 +0000
Message-ID: <VI1PR0402MB360000470873FAC497554AD2FFFC0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20200311033616.2103499-1-kuba@kernel.org>
In-Reply-To: <20200311033616.2103499-1-kuba@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2337dcfd-b044-4be6-2c3b-08d7c56eef4b
x-ms-traffictypediagnostic: VI1PR0402MB3917:|VI1PR0402MB3917:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3917EC0FD31F633971D99704FFFC0@VI1PR0402MB3917.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(199004)(76116006)(66476007)(71200400001)(7696005)(316002)(81166006)(66446008)(478600001)(6506007)(5660300002)(110136005)(81156014)(33656002)(64756008)(15650500001)(54906003)(8676002)(26005)(186003)(52536014)(66556008)(66946007)(4326008)(8936002)(55016002)(9686003)(86362001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3917;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jf5o8s1QFxVaRPEY/4mlcM1upTMvbmtE+RLgmcQF/f7V0kFbphPD+/E7ylgQv7lB4J1awqUEOEsYSh655rgMQpd8vImsAR/uMdPZfDtU0VhCs1WtLthvZJR/Dy6B+pZjHoVjlDCTu+KgoumYI12MZe724H98JkobCMNUa4R827WU4imFlobcuKv95HniByeh0Rnl8k85XCkxZZeQheb4871RvS2CwL1FkASQndzDsqWXKScomm+s+VSuxrrO11zpU/qQQdwCqjRFNHpJ1dstCG7xVkluQUkFkusI8m8XcAPQmlJ5W1/BaoKIJCgDXLr9qMezHz2JudYPl62QGFCVRW4bXX2AokMgOH+piD1f9AzH/i5VdadADOMrwBBbSNg2N15O6zHLjRFoyQ/181wndiAHZEJF3+5cVqZGbSg3GwmUnlrbEibx6bCLBSkG/nup
x-ms-exchange-antispam-messagedata: IosxAujZtjVeSKJemeWHHFNseu/9h5CbRD8EuYqp27b/yKEPBQL6xgflDJhwgMnGfJGkwreL6g0JaZz2d7L3evJaRu09fnF5HfsSt00DaECrJNBD6thvtcYmj6gz1vQ8zZBC9eIbnjl61gVeIXmYZA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2337dcfd-b044-4be6-2c3b-08d7c56eef4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 03:47:34.6680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ses5vkR8K09d7f+4T8QthGtK2tzEHqefCsMt+vzqnNc2EdBDcyhRxzmwgeZ7398oDggCuShZubeV8NlJM9HqMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3917
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On Behalf=
 Of Jakub Kicinski
> fec_enet_set_coalesce() validates the previously set params and if they a=
re
> within range proceeds to apply the new ones.
> The new ones, however, are not validated. This seems backwards, probably =
a
> copy-paste error?
>=20
> Compile tested only.
>=20
> Fixes: d851b47b22fc ("net: fec: add interrupt coalescence feature support=
")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Good catch, parameters range checking doesn't impact function, so it should=
 be copy-paste error.

Acked-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 4432a59904c7..23c5fef2f1ad 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2529,15 +2529,15 @@ fec_enet_set_coalesce(struct net_device *ndev,
> struct ethtool_coalesce *ec)
>                 return -EINVAL;
>         }
>=20
> -       cycle =3D fec_enet_us_to_itr_clock(ndev, fep->rx_time_itr);
> +       cycle =3D fec_enet_us_to_itr_clock(ndev, ec->rx_coalesce_usecs);
>         if (cycle > 0xFFFF) {
>                 dev_err(dev, "Rx coalesced usec exceed hardware
> limitation\n");
>                 return -EINVAL;
>         }
>=20
> -       cycle =3D fec_enet_us_to_itr_clock(ndev, fep->tx_time_itr);
> +       cycle =3D fec_enet_us_to_itr_clock(ndev, ec->tx_coalesce_usecs);
>         if (cycle > 0xFFFF) {
> -               dev_err(dev, "Rx coalesced usec exceed hardware
> limitation\n");
> +               dev_err(dev, "Tx coalesced usec exceed hardware
> + limitation\n");
>                 return -EINVAL;
>         }
>=20
> --
> 2.24.1

