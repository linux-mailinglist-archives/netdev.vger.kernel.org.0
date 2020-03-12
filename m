Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5302B1829D6
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 08:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388152AbgCLHf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 03:35:27 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:47609
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387958AbgCLHf1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 03:35:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMWWWI25Z4mzvPRQGkHadvqKIyTBrH8oUie2HmhXXC6sqOGdiR9+x+ibgw+TGsHXLwPHQoRg4Aj3A2zqLF6LHkeu85TsOABH+JgjT6yrxWkn6i0jzaEOdeczZT6EolSBHvkIOwgjI9DQ1/YYMpRS8esgJojnM6KulcxEfXwVgjx52GfcOzGCxOVYGYMwutYcWQCY8XnTKdEfBNayJn81jCwLrwAiyHm+vepGMuEa9r8uuqVzpzpzL5O2dBLBlh5oUuSk+iPWqYBCR5BaJAAZXaRTKZCNdAIM0PMyJxEntLZrU1Ui9getJ9c8BfMjxW1HcHIJr2imnrBZlUaHq9wP9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucsnHtPFYXDSMe9ZA6t9YJ9N+Zldr/cT7oNBxw/RU7w=;
 b=AROG4r2zKZkUUQShZ0kZh1yt+1XpNPk1p8taiBXBPufLs/S89agQ/lP3N7V/UDXLWTR5uRVVTaKVTUEzMzgw04MyTJGlogTRs6koUrQihHuE8r5WhwoMwCpDt+J1vD7onafVn9os/zhEaVkW7+WBd0HUpryM1K+0ITIpivmvejTQpYn8wldiVI1thbPrQ/mXL3tFcAT9tLeVxRl8u6ukn+Zqi0RnqqW7NhB56CfOHLx6MM3/hf4DfkxtBV2XP+h0bLvRST0qzYKJ+LMGFcy6d8rDLi+cB9JdyaXgCIwZWezObPC218BGNjTwMT8Kc4jCrD9OUpTXOM34kfRGk2S2gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucsnHtPFYXDSMe9ZA6t9YJ9N+Zldr/cT7oNBxw/RU7w=;
 b=SdnJlrgq3xL0hJhqCGaBDuZ+ZC3jz5QLnQXzTeCxW1sCPdJ7gawz6PGZVcVGo5Lf5fWBcNQSTmYbz53Xn7BeIDMx6tmOAra5dtgYRFoqU1Bl+6V4Gti9KDbym67K0t/7B9Kl9H8OkxsLvavOS+dYsZ8MPqDNHC5waip1ZQMUUr8=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6377.eurprd04.prod.outlook.com (20.179.249.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 07:35:23 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2814.007; Thu, 12 Mar 2020
 07:35:23 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "sathya.perla@broadcom.com" <sathya.perla@broadcom.com>,
        "ajit.khaparde@broadcom.com" <ajit.khaparde@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "somnath.kotur@broadcom.com" <somnath.kotur@broadcom.com>,
        Andy Duan <fugang.duan@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>
Subject: RE: [PATCH net-next 02/15] net: dpaa: reject unsupported coalescing
 params
Thread-Topic: [PATCH net-next 02/15] net: dpaa: reject unsupported coalescing
 params
Thread-Index: AQHV9/UOAk2Fi/7/W0CEkm13RG+L8qhEkVug
Date:   Thu, 12 Mar 2020 07:35:23 +0000
Message-ID: <DB8PR04MB6985E63146F70829DDCD9280ECFD0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200311223302.2171564-1-kuba@kernel.org>
 <20200311223302.2171564-3-kuba@kernel.org>
In-Reply-To: <20200311223302.2171564-3-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.126.9.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b171f752-d965-4b45-d7d7-08d7c657ecf6
x-ms-traffictypediagnostic: DB8PR04MB6377:|DB8PR04MB6377:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6377B390A8BA7746CF878644ADFD0@DB8PR04MB6377.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:514;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(199004)(81156014)(110136005)(71200400001)(2906002)(86362001)(33656002)(4326008)(8936002)(8676002)(54906003)(81166006)(316002)(66446008)(26005)(7416002)(66556008)(64756008)(52536014)(186003)(66946007)(5660300002)(6506007)(7696005)(9686003)(53546011)(66476007)(478600001)(55016002)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6377;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6oxqM47vxny26Nd3QN6WfDOhGObIEYb7WmDNCbNnEQ3E4wGAF6hbVTaX5fSJQTceYat9xlWAU8SoOBODGYPOIQsv63E0adCU62Eg7ZunJq3AffpIzKw4XXcl5EgOlMfKsF9QZywd53h+DPd3Wqo0ZhJ1r8dpqLU8WbHw/gPP/+0qsbCyTiPLDiF5+aNlanALV3wMf5BfNoHknJ4Hb8x9z8cVCOpUp27eL8/l7c+9ScfS+JkIbr+MGSpPD2D3st0ez4HWaO8JxNkupOH4o5WnbHi+O7C62CKLFhCcfWeF3iOMnnQnO5SreCEiWGV10MqV7txMfIh5+ss1J4O5XAT2YUH8z8OQy7LfIzZGtCkLpUXsfGH0U/9IhTZoihcxo7Gr9q1CkoNhOVeHy1FFBxO/0n9FNiWG807emHxN480gXOb/JjyAhb6Yv8e6mqmqHnq7
x-ms-exchange-antispam-messagedata: vV856KSm+pkZQ4nY54VVzRE8EfxoPZ9o+5xakQ4Xsg03d4ZLTJr4n+FnbEh/riHlNqb3kBTpz1l23w3hcRTDJyMJYobb27r+38PJKihVSBJwcpKWYL7Oz2Lxl952nl3VjV4cT+7pUHwkKXytb8mU7A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b171f752-d965-4b45-d7d7-08d7c657ecf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2020 07:35:23.5014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8PgCTdELLXm73S2yXAe2brOiFoj6a8YWegCFIZ2t1OubNY74K9j5n8Pct+mxtheJso/JEp0DRdwwVnl4wmBFTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6377
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, March 12, 2020 12:33 AM
> To: davem@davemloft.net
> Subject: [PATCH net-next 02/15] net: dpaa: reject unsupported coalescing
> params
>=20
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
>=20
> This driver did not previously reject unsupported parameters
> (other than adaptive rx, which will now be rejected by core).
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>

> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
> index 6aa1fa22cd04..9db2a02fb531 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
> @@ -525,7 +525,6 @@ static int dpaa_get_coalesce(struct net_device *dev,
>=20
>  	c->rx_coalesce_usecs =3D period;
>  	c->rx_max_coalesced_frames =3D thresh;
> -	c->use_adaptive_rx_coalesce =3D false;
>=20
>  	return 0;
>  }
> @@ -540,9 +539,6 @@ static int dpaa_set_coalesce(struct net_device *dev,
>  	u8 thresh, prev_thresh;
>  	int cpu, res;
>=20
> -	if (c->use_adaptive_rx_coalesce)
> -		return -EINVAL;
> -
>  	period =3D c->rx_coalesce_usecs;
>  	thresh =3D c->rx_max_coalesced_frames;
>=20
> @@ -582,6 +578,8 @@ static int dpaa_set_coalesce(struct net_device *dev,
>  }
>=20
>  const struct ethtool_ops dpaa_ethtool_ops =3D {
> +	.supported_coalesce_params =3D ETHTOOL_COALESCE_RX_USECS |
> +				     ETHTOOL_COALESCE_RX_MAX_FRAMES,
>  	.get_drvinfo =3D dpaa_get_drvinfo,
>  	.get_msglevel =3D dpaa_get_msglevel,
>  	.set_msglevel =3D dpaa_set_msglevel,
> --
> 2.24.1

