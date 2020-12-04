Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1192CEA17
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgLDIpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:45:18 -0500
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:49376
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbgLDIpR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 03:45:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhKJJt+0gcBBc+iNzmty8GZB1mVySWMg91NCIoiuc5yHP23WKpGC1otjc9R8Z0ah7QuFLD1Oqu3xl7etk3YDeiTk5vahvSgsjUb6h7qB+wb28Rtw1GRDcQ6k68MchUDB8goSQDdX2j+1yw05tZ4JV0hQgB5G+xMBu/u9cr1Q4uMrwGEutZEKxI5BSbPC+VS9QUKOevHxFiyuNe5YcaPVbvAGdRnFIGskikJ59hTMs9Gy3BRpY2VpWdMlZrt/7XvwoGK9Os9jv9GwgYDHOHopb5UcsdIo+z1IuP3t6c9pk12RTFgrVc6jgbqOWDG6J6AV/i9Skp+TG5ArXWoz9M7Jmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+308k4oPgP6xoMEjCHV2Dt0tQwy5K/hwOJwpmve3cf4=;
 b=ZBUK/2N0Yk2Q0EdgNw/5qH8I14QYQaUjGrmPXbVSw/OlXDMrmna4c/cziwHiJJsUMzEdctzXvQB/9dFyvNhmhlQ7euRInk6To3dq3fMh0Vz4WWzwIMJEHJAW5ALRckJMCAVp7Rkmkn99RZuKCb144zBVkmQO2Kfg0U06+KwrHkzp+nvmLcsdB+AS+Xm1m/wNRynFolS0CY1dnX6pt9raCBVViT5qcty/zUd49VW5y+f5UnvPEqaylO6RUFZMDpqEfbw1IKlZIgmUcc/+keVnNl0hXql5cogw1vcLU3CzTi29w99A1tVLGyRcvVKyJquGVu6++FddRodh74blkIOOgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+308k4oPgP6xoMEjCHV2Dt0tQwy5K/hwOJwpmve3cf4=;
 b=dGqbUjoB5ac/2/K4pjijLydFXdSmJFdTgL03FcxWDBjBVtB9DlDhBePHCmsOsTuCKX3M7N18ARZaUSHQ3N6rp0u2DV0jhn1tgPeZbPsFAZhzDtPBr7/EavyTjHYmBRPpqdnNURCEE8wQ8trgeCmEqHLid86RBVH7sTDqeljyKgU=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR0402MB3335.eurprd04.prod.outlook.com (2603:10a6:209:a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 08:44:27 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6c54:8278:771a:fc21]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::6c54:8278:771a:fc21%4]) with mapi id 15.20.3611.032; Fri, 4 Dec 2020
 08:44:27 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Arnd Bergmann <arnd@kernel.org>, Mark Einon <mark.einon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: RE: [PATCH] ethernet: select CONFIG_CRC32 as needed
Thread-Topic: [PATCH] ethernet: select CONFIG_CRC32 as needed
Thread-Index: AQHWycsDlpvRxDQs9UyyQRQXb8Q2Yanmn0JQ
Date:   Fri, 4 Dec 2020 08:44:26 +0000
Message-ID: <AM6PR04MB39765A704E30CA59039A6ECFECF10@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20201203232114.1485603-1-arnd@kernel.org>
In-Reply-To: <20201203232114.1485603-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.124.22.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a16de708-983b-47fe-9fcc-08d89830cee8
x-ms-traffictypediagnostic: AM6PR0402MB3335:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-microsoft-antispam-prvs: <AM6PR0402MB33355652FCEE32AC2165585DADF10@AM6PR0402MB3335.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sVIgnuKxTGCSuRt5fcezbKN+Dbbwn1wZHCAetwYLMr7iNxyEJ6n2pv1C7cjU9l2km7wIxBYeBqDYZhtp9963aI1IwZSBXGm+XhfnphM9SxgVeiaDQdD1CpzNU2In2DKxrnIwBlxPY8Y6SoSzIH6YrtXFvc1jIvgFdTqJSpkn3Pfc/si4OhIzZdqaZapv5/pLmj7DYY/P9OAwDzyyh7S8UPsmdNBOa5kHFg3YSN3x70jaNKQFHOTZptB+dfT35SzTeTyn4Co52Z6kzpQvjUvJbizvefI8OuDEgHB0zHjMm76K4ksMnw4uMHoAf6Yn23m3vn4mkw9sy1KZHx0xrQqgoAWj699V2G4mTw1oK3HwkSYE82B/o5HNlaRdvtpVwS8X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(4326008)(26005)(55016002)(66556008)(66446008)(7696005)(66476007)(53546011)(76116006)(9686003)(66946007)(33656002)(64756008)(8936002)(83380400001)(8676002)(2906002)(478600001)(921005)(110136005)(86362001)(54906003)(52536014)(316002)(5660300002)(7416002)(186003)(6506007)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZPsMg5phynbQJb8s8A2ic1sfs8JIWBt1rG3HCPR6UzsBfhKrZ0S9QNwf7jHz?=
 =?us-ascii?Q?oRQWaap0D66MiqY9LiZ9vwG/aLdqY/D0a7bzUlH6SASgHiarKPUrFSPeFF8G?=
 =?us-ascii?Q?vrMb5Hq5QDXDyWyGoOy7xXMllSbjTHxVi0VBXh65yUfUiigMwiYAMyjKeyOC?=
 =?us-ascii?Q?5CYonozOMGK8xJzJNG12QOFksHPzHSXzdRtcmorfKDWWKfUfv2amztz10g9J?=
 =?us-ascii?Q?OCue97MAesVu9ONu0qoC/04Zg+7XzNwHRe3Sc2l4fHCa9WtOd4oUCalD+MW3?=
 =?us-ascii?Q?hVhZ45sjnJdzDCbM1HphHSOT0S0SS4yP/0bpN8Kn9cKMhG3/6moXmUs6douF?=
 =?us-ascii?Q?BP3wCaMqUItarJXlK7AzgyPoPpLCfO15r2OdBKH6Ss0X5nx79aAG7Qlkac6k?=
 =?us-ascii?Q?egL9KdLN9kDH2WETQz23achwBDpm6Hrw8b8Jdrx2p/bw1ILWfnAsOPvkSrxF?=
 =?us-ascii?Q?yHfrdpKyh+JcaVPjlJUx+izNY9/xqh4bBr9hRB9Dx4l0OwEeJv2pCqIngG5T?=
 =?us-ascii?Q?rZ8UOTtM+dbt+BEOSJF0KGJgGI7OMF+jzWug2l2NaPjczB/uFPdsW/tqBMOw?=
 =?us-ascii?Q?edL99lHodSk6O1n6lpdquiMUT5LBPgZKFx34ykfh65R087NZvt+/4oChm7yy?=
 =?us-ascii?Q?lAH5DZ6KXBqSbyKCytMxPMttb22NPwuGrGwWY0rDul5Fhocd3cvJDsZ3Cfqu?=
 =?us-ascii?Q?8LgS7yRjLbOYhGzDWteiRbBJkjaacc+qzxEkO4Z9cJ+v38qtvlBmHfKMnWOt?=
 =?us-ascii?Q?cZx0N2MCaQpiRrcckrJ/tiAhXmAEihHYpHZnduaCq3d6Z2F7yv1PuIP4WP78?=
 =?us-ascii?Q?howNKJ/WeqJx9GAG/6DjfYSPobZ0GG6iij2d7qRkFvdNL4isRPijjiYmWqQT?=
 =?us-ascii?Q?sNjm/qO6GlmaoJF+pBKzEzCmU5T3Ez/+oAs311I4053vCBCfXPsOGvPFpHS2?=
 =?us-ascii?Q?JwtiCVPmgug0fJHEXRMF+haQKnjVh3USluWTVsgXLZA=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a16de708-983b-47fe-9fcc-08d89830cee8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 08:44:26.8480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5/nw90ZVMBGx2qYJZvMpIBTt4+lUkFybHYPZpaEbt8zeipw9i6BzVJT7VQA6ghbpmJJm6P9puvtYU1DLjkSolQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann <arnd@kernel.org>
> Sent: 04 December 2020 01:21
> To: Mark Einon <mark.einon@gmail.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Nicolas Ferre
> <nicolas.ferre@microchip.com>; Claudiu Beznea
> <claudiu.beznea@microchip.com>; Madalin Bucur <madalin.bucur@nxp.com>;
> Saeed Mahameed <saeedm@nvidia.com>; Leon Romanovsky <leon@kernel.org>;
> Simon Horman <simon.horman@netronome.com>; Jiri Pirko <jiri@resnulli.us>
> Cc: Arnd Bergmann <arnd@arndb.de>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; oss-
> drivers@netronome.com
> Subject: [PATCH] ethernet: select CONFIG_CRC32 as needed
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> A number of ethernet drivers require crc32 functionality to be
> avaialable in the kernel, causing a link error otherwise:
>=20
> arm-linux-gnueabi-ld: drivers/net/ethernet/agere/et131x.o: in function
> `et1310_setup_device_for_multicast':
> et131x.c:(.text+0x5918): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/cadence/macb_main.o: in
> function `macb_start_xmit':
> macb_main.c:(.text+0x4b88): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/faraday/ftgmac100.o: in
> function `ftgmac100_set_rx_mode':
> ftgmac100.c:(.text+0x2b38): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fec_main.o: in
> function `set_multicast_list':
> fec_main.c:(.text+0x6120): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/freescale/fman/fman_dtsec.o: i=
n
> function `dtsec_add_hash_mac_address':
> fman_dtsec.c:(.text+0x830): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/freescale/fman/fman_dtsec.o:fman_dtsec.c:(.text+0xb6=
8
> ): more undefined references to `crc32_le' follow
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/netronome/nfp/nfpcore/nfp_hwinfo.o: in function
> `nfp_hwinfo_read':
> nfp_hwinfo.c:(.text+0x250): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: nfp_hwinfo.c:(.text+0x288): undefined reference to
> `crc32_be'
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/netronome/nfp/nfpcore/nfp_resource.o: in function
> `nfp_resource_acquire':
> nfp_resource.c:(.text+0x144): undefined reference to `crc32_be'
> arm-linux-gnueabi-ld: nfp_resource.c:(.text+0x158): undefined reference t=
o
> `crc32_be'
> arm-linux-gnueabi-ld: drivers/net/ethernet/nxp/lpc_eth.o: in function
> `lpc_eth_set_multicast_list':
> lpc_eth.c:(.text+0x1934): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in
> function `ofdpa_flow_tbl_do':
> rocker_ofdpa.c:(.text+0x2e08): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in
> function `ofdpa_flow_tbl_del':
> rocker_ofdpa.c:(.text+0x3074): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/rocker/rocker_ofdpa.o: in
> function `ofdpa_port_fdb':
> arm-linux-gnueabi-ld:
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.o: in function
> `mlx5dr_ste_calc_hash_index':
> dr_ste.c:(.text+0x354): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/ethernet/microchip/lan743x_main.o: in
> function `lan743x_netdev_set_multicast':
> lan743x_main.c:(.text+0x5dc4): undefined reference to `crc32_le'
>=20
> Add the missing 'select CRC32' entries in Kconfig for each of them.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/agere/Kconfig              | 1 +
>  drivers/net/ethernet/cadence/Kconfig            | 1 +
>  drivers/net/ethernet/faraday/Kconfig            | 1 +
>  drivers/net/ethernet/freescale/Kconfig          | 1 +
>  drivers/net/ethernet/freescale/fman/Kconfig     | 1 +
>  drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
>  drivers/net/ethernet/microchip/Kconfig          | 1 +
>  drivers/net/ethernet/netronome/Kconfig          | 1 +
>  drivers/net/ethernet/nxp/Kconfig                | 1 +
>  drivers/net/ethernet/rocker/Kconfig             | 1 +
>  10 files changed, 10 insertions(+)

For the Freescale FMan driver:

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
