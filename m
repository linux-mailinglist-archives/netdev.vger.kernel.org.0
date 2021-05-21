Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08CFA38CF25
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 22:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhEUUh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 16:37:59 -0400
Received: from mail-eopbgr150043.outbound.protection.outlook.com ([40.107.15.43]:47034
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229534AbhEUUh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 16:37:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2aYhmbPrYAQNPX9u72hFAyeVKb4beRF8icUEV4urOhp0zMom+QhEEL4ZiFvgH4iDPqdhr8/fXN5doymYqrH47QPG1B398WXD+U462cjQ2UoWsUL9N3ueeuqw5NTK04uB2obLNaK6dOLhfyVAOZD0ND77f6XrqX+L5JyCCwEfVF+aI/GCgYu/DQHUGMLRzKiI1/6ujUuatVcktHf0Uu4625QfmxHTrIpTLOV4mhGVB6OJoPDE9daCe4Xz00fWbi/5WTHXqJlzkqBdkS//LE2PxVVqwtnY9KBNKphWgeXX2u7QMTNljiXqj5XXfgdHshJCcSKUkxtwcDlfc3Wt4/3rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YpU39j07S3QtHkkRqKQIgRPn3/7g6oUdD15stFOdng=;
 b=jCV6tatMLb/Fq/usUPkrPErd7xewmwL1aXLuoBKX/pySBJpqtjcgraXyNgQflZ2ukGmO5pnBVRCd8zWd/t2B0cyJ29sbgOVem3OpNVBsDfMu5JpioFhRZ9IZcF/hcSO9smtyJce5VqDp/8uTsZ2TSAGHLTATOeETjKVAjlJB/vq0+0Lx0jqwAdkOjGOsMWoXryPi1WP9czJtiObC6g5ld9Eov6gUJUgSbKkvNhMEGKmHtcayfTdOQ60Bh5aOklKTiImPkPhs9LIRF2Nmv0Lh7cWm41StafyONnvyffAnPhbdp21FFmQzprnI4mE+JkePhGuT+7l8BVlV21Sqam7Ghw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7YpU39j07S3QtHkkRqKQIgRPn3/7g6oUdD15stFOdng=;
 b=jP69uSZCX/XAixT04orCImqpu+4+bEPZx8fANbiIsPUTaqJkM7U4+nslrGf9hxSj1iBhHNn7JJkI+En5ElZZT99pClOlbyNRVpKmW9wwF0WU6ue+v2aJJP3y1qKF4RgQCIV5GMNfw/JrZI13ZEDjTBfzZYegrupWsdgZYpFuuRY=
Received: from AS8PR04MB8721.eurprd04.prod.outlook.com (2603:10a6:20b:428::10)
 by AS8PR04MB8579.eurprd04.prod.outlook.com (2603:10a6:20b:426::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 20:36:33 +0000
Received: from AS8PR04MB8721.eurprd04.prod.outlook.com
 ([fe80::98b5:e46a:7722:7406]) by AS8PR04MB8721.eurprd04.prod.outlook.com
 ([fe80::98b5:e46a:7722:7406%3]) with mapi id 15.20.4150.026; Fri, 21 May 2021
 20:36:33 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] dpaa2-eth: don't print error from
 dpaa2_mac_connect if that's EPROBE_DEFER
Thread-Topic: [PATCH net-next] dpaa2-eth: don't print error from
 dpaa2_mac_connect if that's EPROBE_DEFER
Thread-Index: AQHXTktWZs2SlqPjj0KyVWku2lhar6ruZWEA
Date:   Fri, 21 May 2021 20:36:33 +0000
Message-ID: <20210521203632.75x2jykmdtdsa2d4@skbuf>
References: <20210521141220.4057221-1-olteanv@gmail.com>
In-Reply-To: <20210521141220.4057221-1-olteanv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 797b0ea0-34b8-41c9-702e-08d91c981f5f
x-ms-traffictypediagnostic: AS8PR04MB8579:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AS8PR04MB85795D7C10C0FAD233BB5E0AE0299@AS8PR04MB8579.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gPqkXGg7qy6yeomwX+TB/4pGJ5BrvQUkR8oZ1XP7Fb1RCO8R8b8NS2ydYZV2CJBZjO1og2K6CtUfeDqbsi6BWxTJhIr4VjXDXiBRqYbRjdRz5UeQnUIDgRdGnT4vltsDj9ytQtZgc+0YvuDPdQ2tTBNla14LHefYHbrRm4kkkfPapiIit3WjdyX+ySiSWTYNcxNt+xfGcL+l5I6GwbingRD3JBHAddQyr65GJkKGA+ZwJKmmu+3W2ZUJS6s2Fe/N21zqglD3sssJw15RVe0wAHl3E9JutuLlzYeuXRTg0aYpL+M3FfUKgfWabJXFFUHvDUuBE589pCNYnscL1IzuscE4yME3K18v5g+v6mkBgWkTq9IMVhmALlfmOGw+eEQR/9Mj9ZTsUYFU6UwjaKtZqDW4fvUzcnwCPsTIiSoeBVI1C9nCD3ldNxrYMsIfrrScfj1KMEXRUb6Ls+b/nicTEntpIbKdDh+OcC2mmSZMsa1brHKXLi3IirRxYr52p9ItNzy/WwMS557C0UVjGgLuto3Q9KpBIhNO/PdlvCoBR/CVz9vfeLnRzfBrqTVXenN8Q2ShmJVkcOntryenEhGP5NftZACSIa9BO26x2NhGl54=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8721.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(38100700002)(44832011)(8936002)(4326008)(26005)(2906002)(1076003)(71200400001)(5660300002)(8676002)(6486002)(122000001)(316002)(54906003)(478600001)(6512007)(66556008)(66476007)(9686003)(86362001)(33716001)(186003)(6916009)(91956017)(6506007)(64756008)(76116006)(83380400001)(66446008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TO2n+tp9QrfGSiKdh8fiK9L7ILjvAJcn6BpJHeb5HUKRlffRwj65/LeBMFJs?=
 =?us-ascii?Q?WTgGAUeVAgc7Xg1TzPuvqRmz0BkEdQAAAiR5hB1G/TveRxwyc3hC3hlPRwOU?=
 =?us-ascii?Q?Muw0ECTeE/SzpDuRbwtG1kEDIRTHliAZuTgANDLezSNU8u+9tPCl0o4C0gVw?=
 =?us-ascii?Q?7WVars+EH2UotSyMQk55cUqWoaduq5eQtjJEblJVamO2XtbpEVUvBsV0oao5?=
 =?us-ascii?Q?BtNwBQDJSw7W30o37hfYNz7d2aow5RyiQzoM9+IqfCUEitp3VEXMLLwB6ex1?=
 =?us-ascii?Q?YxAkDgcxC2UR3fGm2RH3s29ipgNdbuCvc8bsC5lH3OGd9z2xuRsg7Vf9Kfj9?=
 =?us-ascii?Q?YFkecMzr2b2eQ0WAcCBQW8XuxJgcTeGVjfbKyj9mThag5+N7qUKj4UwB3oqS?=
 =?us-ascii?Q?6EpNb2AejnCBvG3dKPKekcM60M2CpXuvU2ab7Eliq/P2f1TbgPQnNHk5sKpQ?=
 =?us-ascii?Q?HO6wns2Tw+kHz6SZ9MTrOgDGSYda8MkSLcVKH0IGEyC8GM3NPJoXdSqpRuUS?=
 =?us-ascii?Q?1VaZAnMoofUeEAyqM8mNgCQaesbY/E5uelgkuav+nWZMevkDzLuWF0mwKlRk?=
 =?us-ascii?Q?ZXVr5CqlZC2ZTxl3hgEh99tX7XcgmIsXiFG3GrgZorvwyL3wYF27bgVWuGFs?=
 =?us-ascii?Q?b1DrdXrPua+TGuXq5fb3IZ2WqqGeZohv2NsASsxtUMQIHeQ53GosJnYOFAs2?=
 =?us-ascii?Q?tOvl+GL2uQcqzLFXac0CPzUsjgX+nG7YnGe6UkpcdpHeWfAnr8xuJ9PYHYSi?=
 =?us-ascii?Q?ShfSJzwcwBtDbUJw6NHHcJ4PUgy0H3oJWNCs63WXZ1GxylrAx9jE1yvLb3+Y?=
 =?us-ascii?Q?QeXvoAKgKWlZnCwsYPcCuCEtnWNASjXp4S8BGlviklOGktAHfUs/jwfF9M2V?=
 =?us-ascii?Q?9cP8wS4fmOFxcfKOjZxgkOYqrOB0z5V7wd2zI1RWe1ZWXkXmzLhw8A8CXkpD?=
 =?us-ascii?Q?jL8fWJg28q+e+kGm2oIlXp5DTfe3Tcc+KRl5Uw6IurDzCtV7ApX4PgeBkjZy?=
 =?us-ascii?Q?LCASgOWMlvdnqMu7og+wDkOQdBHDtwOJA0SzQCps8ry7pcZ21J9YJ0w54xuw?=
 =?us-ascii?Q?U787CKTOFnXCeDqwSN7BBMU8Hm/yXREXy2rCEMVaFtn6ajH/whV0ajej5+Xx?=
 =?us-ascii?Q?TRjefvYT3j8tK2g5v7ziO9/Dn5oh6Ob513Q6nGFrUZFVqB8NxG3rrolWORVU?=
 =?us-ascii?Q?PppevG/v1nNuiMu0witPfWcmmh48yHC/fF0TczCZnegWErlcPtXgJ46P4ubQ?=
 =?us-ascii?Q?zf7z3ZV7lIbhVY+yy/IVeI8X9RAqFkJhIZj2o/V3vj3cegRd0SFOw4XR1HLR?=
 =?us-ascii?Q?EEvwaSkS16KQVh0QZAtkxzYF?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <493E5F4A533CF4458F255672CDB7EE4B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8721.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 797b0ea0-34b8-41c9-702e-08d91c981f5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 20:36:33.5406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IN2VUYtJxt5Gl0EN7tHUY80syvmVPOpucN3r8Aq0MPbSoKE2d+kP1DK+NVS65HGOPyRV4Q71QFS7Qg2aVX310g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8579
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 05:12:20PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> When booting a board with DPAA2 interfaces defined statically via DPL
> (as opposed to creating them dynamically using restool), the driver will
> print an unspecific error message.
>=20
> This change adds the error code to the message, and avoids printing
> altogether if the error code is EPROBE_DEFER, because that is not a
> cause of alarm.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/n=
et/ethernet/freescale/dpaa2/dpaa2-eth.c
> index e0c3c58e2ac7..8433aa730c42 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -4164,10 +4164,11 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth=
_priv *priv)
> =20
>  	if (dpaa2_eth_is_type_phy(priv)) {
>  		err =3D dpaa2_mac_connect(mac);
> -		if (err) {
> -			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint\n");
> +		if (err && err !=3D -EPROBE_DEFER)
> +			netdev_err(priv->net_dev, "Error connecting to the MAC endpoint: %pe"=
,
> +				   ERR_PTR(err));
> +		if (err)
>  			goto err_close_mac;
> -		}
>  	}
> =20
>  	return 0;
> --=20
> 2.25.1
> =
