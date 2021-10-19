Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4F9433F74
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhJSTtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:49:35 -0400
Received: from mail-vi1eur05on2063.outbound.protection.outlook.com ([40.107.21.63]:18528
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231355AbhJSTte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 15:49:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDwG6oLwfde8I7rbyByJRWMrkuZFKgmSHnmZ7Z6KENzv6KJlahz1YMEdYPiFAt7A/F6oYIG8nFeWTOqwPXztmjCq5QYqJjfQKET0WU+YznLCnk/RAM58G0k6evRuv9Ch1EotTA9JaqxOfmZ6pBMdxRju8yuar/7goeMisubneXehn19f5htrW7pR4J+uzHQhEsVUmi0F5aEPHPs6w/lYzodw3j48Zui5UrVGAcfqFKaQNDordtaanP/iLe0nJfUdNAAAFgJztofs4BPYTDlrpCNzQpgey0bvcVSixvWnMx6BMuUSSWfxHgBaHluRGIpH8zsY7DyWeZreKHBw1d0TKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1H0wffXE+a3tckHIJAZX4w2vAFwDQ+6YTIMOKBTjKw=;
 b=DsVRBzozYR+dHGIkovsKpV6bP9StwEPM2JUcas16WGCxhdI2CTyQJUK6zR6wBvVvLAs5cn4ukKEmdrQJgOfK3RVJL125CuzRrKuHrEdeQk6ikBiRf63c/VVBWC9MFKcb3rQilYFVAicpUuTpeYZ1serb3s03XB9Tkr4I41wU8jJGR1W2auaKmqQbB4vpsdJpBac2em5xI5Q20XlXvH/sgWF/fQ3UWwS+oXnAYbJBGr74oef3U228i84bdh0AQJqSA10aWFHO48DYBFWWEiwH7YLbBnGTK/WAq6tUrrpOZeLOb6jKRSmsVpmi3O+aHoG3VpTtJOvjJJ1foelOjAO4xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1H0wffXE+a3tckHIJAZX4w2vAFwDQ+6YTIMOKBTjKw=;
 b=h8ke1U3HQ28Zd34djqJRAt+GZUfxExeG2vMlNx/AoIZd2Uuw1jyJLJ8vtwe2RGDxaolfMyhkkg8G9ESRUqMyDYyYgFVhuzlm3B/OJEXFTd4dEkBiTdbpVkuj178UAIHFsktq21m7kM96Ot2xC36kwGXvYdCh2W+Xz9Dm5kLA1iw=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB6882.eurprd04.prod.outlook.com (2603:10a6:208:184::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Tue, 19 Oct
 2021 19:47:17 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c%6]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 19:47:17 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Tim Gardner <tim.gardner@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: RE: [PATCH][linux-next] net: enetc: unmap DMA in enetc_send_cmd()
Thread-Topic: [PATCH][linux-next] net: enetc: unmap DMA in enetc_send_cmd()
Thread-Index: AQHXxRX2HOQt4hVU60OUTGpYMhBFe6vaskoQ
Date:   Tue, 19 Oct 2021 19:47:17 +0000
Message-ID: <AM9PR04MB8397F300DECD3C44D2EBD07796BD9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20211019181950.14679-1-tim.gardner@canonical.com>
In-Reply-To: <20211019181950.14679-1-tim.gardner@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6210f297-70c4-4776-2208-08d99339418e
x-ms-traffictypediagnostic: AM0PR04MB6882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB68829B8BF5A75BBC03E4104996BD9@AM0PR04MB6882.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xgze7u88ijxeHDU88zVPgd7/5KD5FQmueuTH6ElljRSRmY06VK5g+1ZpeB7Yq6TrUgxofpAPsp+qgzeFqW/C/BmOFV3+eUR75SYv/WU/0enjyVLUWOO29PDzmTRgpXIhBFYBfsafpfntkz/ll4b7BkIH+RY3Wze7UeYRgXaub7I4IUBtA7ZPUHB7kpoF2xKOIfxUmT8uDPhPEHyCJbvHu+g0DqvmPK3Mr/Ez4hWia7OfKswc7IlGbeAOD1w/u89ziMOBrV91bvDn73uGmD9I2mV6mi89+Ju4hrG4HqnE0HOZjE6a8GC5yYw6tqLGvrZhp/3frCpyd4vmaxD9cS9FUA6f+N+qqziJp4rJVcYGt+iXr6E+Z5AWaWW+zHDw6qcaFxWkkxke50Az0KGsrkL08YMnglSHT0CXzhI5kdUh+tMEa3pjCqBvYJLiIdhDvWAZvjRHNR4lgaOWWG0f7FEIJhbl6RoL//hBoYUrbq4gAHs0pFN8skTS7z+qGZK0g9hRHshUEVHW7Q+7IcJqXkKbkNigZWd/BSTcoiXfenscofdezCeX42X/T89C01BGZbCN5a55CJPJa6GHeQMSVPfl+HBKWFs4uOPhj+SV1mGbk6r7164WJL7FCKjIizSQWQfleuiGBezHAL6adfhvlUbJU8PTFlkHOpupkTlC2mQWwduXGaU7qk3xKCiHNFL5S8NIuyn3mj0XKp1P88LiK1O9mQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(66476007)(66446008)(76116006)(44832011)(83380400001)(316002)(6506007)(9686003)(38070700005)(53546011)(2906002)(71200400001)(5660300002)(86362001)(38100700002)(26005)(8936002)(33656002)(110136005)(8676002)(508600001)(64756008)(122000001)(54906003)(55016002)(4326008)(186003)(52536014)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HPF4NSEeTB++H6noUN7A+Vptse5uRFf3gh2n+O9lizamjqtAM03DmnlctcYR?=
 =?us-ascii?Q?QAS0MA33Og/5gX1Nh5xw+FZ3lwlRQbRzeFUVAD4hwMheFsM0oZMy1/RKP9yh?=
 =?us-ascii?Q?PAqxR7r6mSh+k6cnIZ+J49qZUfzsCHg0rYbDdBlmLpcXPhY2XPp/SoTALWjc?=
 =?us-ascii?Q?fbJ4CB8SNQHVm8JUb6MXq+3Ch0o8iKo2kC1uxK3v4HQp23UKGxjmyciFXevw?=
 =?us-ascii?Q?FA5UZZ0vkLEC5A4kkTzKgXPNFLKoqiNlKq3jMreLEycG3iLCcnrFH1VPYbF2?=
 =?us-ascii?Q?5kwaajaMGL9qHH2Tz1qVE8dR6Hf67Rni3fOuIOlcAmeu98RNKf9AMxN48EcO?=
 =?us-ascii?Q?EWzYKg19Tg1qiO19eqZnQf9qo/pz1b1PafVpu6yQE+7e85fwvnP731TTvCv1?=
 =?us-ascii?Q?NqFsfLN1ys79K8VayF3V+UIy7lBaPNd6Hx2f6yFuKOrx1SCmNM9L+GrmM4+O?=
 =?us-ascii?Q?qBE9RFNT9IfPLeeIX8HlQK63MIIpTBxjZjpbyxUDHLw7TO1taHpjjOF2cMix?=
 =?us-ascii?Q?HiumWHziNNQ7OJa5QA9jUNtMF8IepeqzFEQR23KZDOJTgbu73gH06IXeLXfW?=
 =?us-ascii?Q?sPXBYevJmU/saQeOT/L2sgfPCBqmkdy1DSHRP1NVe04PE4xMyVCXJuhkh7Wa?=
 =?us-ascii?Q?RfOq48mCeMpSTC8RIeQLS2rtOfit0w2sko+y+mZJ5A6elAfxVW9omEOn0bUs?=
 =?us-ascii?Q?AOqaCcvP6qYAuQ9Yyn1/PggHJqQGEryo8dfIBG/fNhKiLXElFaQDFDMwUOtb?=
 =?us-ascii?Q?dhOscdPU4ycoDvKV8KjpFGc3OfhyWRhv779mesA+/dlJOFu21NijX2zTVwyN?=
 =?us-ascii?Q?fNApbwyjk54OxmnVdFUYTIGUr5Fa3HnsjD93+CSN0hbi3rTS82qNlQ7jaaO2?=
 =?us-ascii?Q?ViG0/j0L0GVepSgKV1bpAeqIKgXmHRRjI62k022Vv6rVHBoNJ1a+KX9ZCMNt?=
 =?us-ascii?Q?/FnyNZj9Vi6uAdUXHKk9FhlFOpAizHg+h5VwJn+Ichw1h0I8qPYAxpDBTAhP?=
 =?us-ascii?Q?JKfIvCr42GbYBWlLeUeM2f2jwEWzXulPjK61NZAB56OcJBcdstwrOeGwQeJY?=
 =?us-ascii?Q?BpizcmtrQCJEFEFakk8esmtO5bVpfkA+XB9lIbHphDJCkukqNzuU44t/XBYj?=
 =?us-ascii?Q?S8G6AU6vmW5qv+bC48/z9EReY10kmussmdqTthvo2D+P+U2b5vl4WWig3ivC?=
 =?us-ascii?Q?K/T6jsdlspmF2FlY/F4E8PVYLmQNW4H8qdELsH+PFWJeaCFZZZSk7VtG4FXY?=
 =?us-ascii?Q?9Ddo35K5fLTTCpAtED33dWK42ej43+aTDo7FZ4oASaCZVei9U9JoCKY88oBJ?=
 =?us-ascii?Q?v42rBgj6pOh0wj4cFsGSKwtg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6210f297-70c4-4776-2208-08d99339418e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2021 19:47:17.0753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Kp6HnScyDc+sTBiGN2hiit426sWgDK/J7/+bpg7I/FVYmwDqAZn5FamjxA0GJOiBgjLtyQNN/CE0huX2Dglpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6882
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Tim Gardner <tim.gardner@canonical.com>
> Sent: Tuesday, October 19, 2021 9:20 PM
[...]
> Subject: [PATCH][linux-next] net: enetc: unmap DMA in enetc_send_cmd()
>=20
> Coverity complains of a possible dereference of a null return value.
>=20
>    	5. returned_null: kzalloc returns NULL. [show details]
>    	6. var_assigned: Assigning: si_data =3D NULL return value from kzallo=
c.
> 488        si_data =3D kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
> 489        cbd.length =3D cpu_to_le16(data_size);
> 490
> 491        dma =3D dma_map_single(&priv->si->pdev->dev, si_data,
> 492                             data_size, DMA_FROM_DEVICE);
>=20
> While this kzalloc() is unlikely to fail, I did notice that the function
> returned without unmapping si_data.
>=20
> Fix this by refactoring the error paths and checking for kzalloc()
> failure.
>=20
> Fixes: 888ae5a3952ba ("net: enetc: add tc flower psfp offload driver")
> Cc: Claudiu Manoil <claudiu.manoil@nxp.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org (open list)
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>=20
> I am curious why you do not need to call dma_sync_single_for_device()
> before enetc_send_cmd()
> in order to flush the contents of CPU cache to RAM. Is it because
> __GFP_DMA marks
> that page as uncached ? Or is it because of the SOC this runs on ?
>=20

Not sure how it works like this, but I think dma_alloc_coherent() should ha=
ve
been used here instead of the kmalloc + dma_map scheme. I don't have the
means to test this particular code path however.

Acked-by: Claudiu Manoil <claudiu.manoil@nxp.com>
