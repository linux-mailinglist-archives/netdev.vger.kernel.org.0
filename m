Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4EB31F737
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 11:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhBSKQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 05:16:55 -0500
Received: from mail-db8eur05on2071.outbound.protection.outlook.com ([40.107.20.71]:10912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230395AbhBSKPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 05:15:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFCFKOUQnjcQxGevy1gNunPUPxGI1q3+mVIZsd9+jkVY3elqmPnY/qASkI8FYmgNv/lZFJPOabnPFYzSYR+hyVfNozZW499s/pLd3s9L9hXNO7D2ODNy28gvn9j3srnbYC6dIbaCCseNIngWFXnQQLzf8C1OHZBTTT00tAKhGWCSvRGQo+0LnCZZ5LJbOdlF5Ne0Uj/B5KyubrfriHtUt6ffrAeVTDFL7hbq0nLkbRtItUNcVLtCTcz6KnbvXRcU1nRf/yYd1zcqW/XtgNi+3RXJsElAMokbXjx64BJg6ZRIMqj9imypcbYTjP3J62GGSx6PEd+kblaOhshdoy9j8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiRP3GjIeVzq09CYnBpyWxr4wTwN/cZ8ZSzkyv0tNUQ=;
 b=cqeg4+OjX82Lm1GN7Biu4IA8GFJdeO7LvBaE9vdJCloBivasWUJFgIlYzdLY1ZXhfMZUginw9y9NK+GySDf3bLwo0jD2GM1VTLaWMyQMOzJMTsCWx0MhmN3m3FsN6++e1+hUQIvWI/tdDZQ07kEnQ1ILdGYo12mP/396o1m/Vfo1QgpNtk2XVhCE9GwDBmkNwV70KFPVrBM1DRsztwfO9LlefwcwhOZxiY1NVlE4II42Q42POpTZcARsH+g7+DOH1ME+SAOc1puDUeMaJqY+aVJ2rg2sJufjKdiJ+/9RHWAJOde+3sr50E3Nq6KrbCEkNVmjfkQp4vykk7wRhU0l5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IiRP3GjIeVzq09CYnBpyWxr4wTwN/cZ8ZSzkyv0tNUQ=;
 b=cy4reXUhk9xK10ooJQHjnZHc1D5PSc2RiiG5mIAZQWz1CS74NJKbtms1XJWYArOPeTjWidSkBO9f8s3uYZjDdUOhca//zPulAW+McfRMjTvAa4TLUMdMV+8V1RJxGZSB9gabaMRRnbCw/XwPSm9isrhP6LrW522GlpCncRkRb08=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM7PR04MB6773.eurprd04.prod.outlook.com (2603:10a6:20b:dc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Fri, 19 Feb
 2021 10:14:46 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::4891:3a13:c2f5:6527]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::4891:3a13:c2f5:6527%7]) with mapi id 15.20.3846.044; Fri, 19 Feb 2021
 10:14:46 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "brouer@redhat.com" <brouer@redhat.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] dpaa_eth: fix the access method for the
 dpaa_napi_portal
Thread-Topic: [PATCH net] dpaa_eth: fix the access method for the
 dpaa_napi_portal
Thread-Index: AQHXBiLgrUj4UObRO0yGOujJs4pLEapfQ6Zg
Date:   Fri, 19 Feb 2021 10:14:45 +0000
Message-ID: <AM6PR04MB3976150FC8E94B63F3907467EC849@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20210218182106.22613-1-camelia.groza@nxp.com>
In-Reply-To: <20210218182106.22613-1-camelia.groza@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.196.28.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 11de4daf-b55d-451e-afa2-08d8d4bf2eb7
x-ms-traffictypediagnostic: AM7PR04MB6773:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB6773820A81D46394A38BDDD8AD849@AM7PR04MB6773.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xw38IGejoerObWhU0yfT+xceI1U72uS6TdG1/6qzhyyQy8RTSM41LTT/5Pw6LmQnVtpXqMvlqmailrQu45zAv4yi5e4FWdgHLw0iZoGUNVas/r9FuC1iU+c/CNfLHVb5iVOGZUAsxQyvhypsTDir6Tv5hKJOyLBUcLV2OJO4jNBG9TtHtPaEWKQoDaq0EQXtzcpndF1t77kwK9FgWlpY3S6+JbnQK/YGtXQPBT+gUUPOjprJG7EPdElzJiOINsEQSSF0hjVpTQstvmrZ2L5jaQjIgF88mas9B9XtQCJi4lpOEk7cF2PzpMjY0QZzpBgKBZ5ey36nvFWwgKLKVu2Z35iowEOhfSyFVsEC55xpxO+sio2ayZb1pl3OiSzdcSrGMCnMTMNqlOPvFXPTrnMi83Au+/ZS6VcdOdJkotmE1LWE2xFFjxVIPohk2PiYxtBImhx4cxxfshNkHcPOnskCe+xGl3pFbf+pF6TVqcM+tNBjIYbdhzRM5a24Ns4ORCs85GIl4bDg9TF84oUsy1U5ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(478600001)(54906003)(83380400001)(64756008)(5660300002)(4326008)(76116006)(7696005)(66476007)(316002)(110136005)(66556008)(66946007)(52536014)(66446008)(71200400001)(2906002)(8676002)(33656002)(86362001)(8936002)(6506007)(53546011)(26005)(9686003)(55016002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?w0Jb4QKx0Ntc81v8UufkbZgX7D3gi1VFz/vvau9TY00HJIHeeQOjE2yJf30v?=
 =?us-ascii?Q?VKKAyYLV4Bs8gMAgR58YbvQg8XfyWzAsko14IXUEu8/kFRjGJJz4MepQDg6A?=
 =?us-ascii?Q?Tx7zHlJfHdTGkMOeWXp3f5As9Bv39Fpc5hrhMbrq2MQUGGyjSeCHPr0Ka7wp?=
 =?us-ascii?Q?BV66+D3oTOUDK+G/yIiW8sSPzIG+Jk3hf3w0J0ltiS65cqeq9AN2ey/7xYic?=
 =?us-ascii?Q?NsjP3V4k/8GwzvojqzKNelCEFc6UpD3j0b6ir78iUB7kA5UpWr3gTlglDseG?=
 =?us-ascii?Q?fBKn3l5zDKAPD/nqU1fHxV4vrzVD8LEdoLsJw53Vjl6DWDqp9q/SqKLCQczb?=
 =?us-ascii?Q?FfqmQkFWjeo2CS9KTLOc1VV5LnFMujJJCwCJE+nEaVbAUMU3a8M8hb6WA0eY?=
 =?us-ascii?Q?Ku9IiH8KPulP3C64Njnc7TP/IX/6eeMVMOgLmU+vTdzcaboFtrkiLHtKDGub?=
 =?us-ascii?Q?WT6YMOlomDN7/8ohyp/9R4XdVf1qTl++RXwJfMyj544Z3ePdIFBqmmO77S0e?=
 =?us-ascii?Q?bXWj7KCRtlyasi/HDvYqEP6oIW6K9E9mckbutbR1pNcnaylyVEi8Hmi0kJ+2?=
 =?us-ascii?Q?Ld4DOHYOtzOQJXQz+/ijooGkQ+FGK7+cO5BqPNoyzqPS1vfZZ26VueVLEtHO?=
 =?us-ascii?Q?4LmlNKcyQwCdMwqESIH5rAO6zFetVxZcRCXb5YKqhVnfSXUWlcZ0H+NRufav?=
 =?us-ascii?Q?JWBu8/en5DpDdMcGmSDO31XgjpMW2GTOVauyvlw6VEsX9bBwma0tm9JLO/kB?=
 =?us-ascii?Q?q0sgtH7tlUItYxexltEDZCl5X/gXIQMOdGVOIvC1gWmUvKdjtdfUdempGAms?=
 =?us-ascii?Q?68tzDGEYN82bpUKrQc82riLtzFomE3s13Q0bLo8/EwjqIJ+UHaovnqkMFoVI?=
 =?us-ascii?Q?EFYRLwiKUVTcJRVcKGhsefzOQxWPuAKrgwEVDdGb7A1SqpURf9hv/VzWgbgY?=
 =?us-ascii?Q?eBeJ6noEZtOu9P7HLsgzfiEuJwZNQ+9fSK2pHjPhHAt5NaSEMCRkUKRNfNKr?=
 =?us-ascii?Q?SYXKIpcBa8qqjeJJwwHrGvEaJNAU2ep9rZJpNgCFE5aMGq42iuZatikreo0R?=
 =?us-ascii?Q?1y5IrPCjZSunMpSm9PuZds6eV9kTevBwCY6CU+yNDtUuB9FFWz/0+sJrgy+M?=
 =?us-ascii?Q?YYnBLfjA4qBjeCukwlb2vndQwgN/pEyH8OQ6BIeZvaeJCylpVFzQ6+JUqmrC?=
 =?us-ascii?Q?MBfDGD+rUoDE37q7NGfi4A7O62qrK3EzeZoXZjgVswrEws9zcu3a2FIImeTe?=
 =?us-ascii?Q?5DBLC2lXQBxXkbq4A6KwK9kvXLR5+g5ZcRm2pQ15E30ygnCJ898O9T4Gx+i7?=
 =?us-ascii?Q?uwHmSkExCsns8CcJL27LpLpT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11de4daf-b55d-451e-afa2-08d8d4bf2eb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2021 10:14:45.9028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJ3oKGQxKbirenLaGI2Xk+oHCvujCaZqZgYO36iF7PE5TUKhBLcX9QL9CBPbbvelHBOLws2+5ku/TXumjP7YLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6773
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Sent: 18 February 2021 20:21
> To: kuba@kernel.org; davem@davemloft.net; s.hauer@pengutronix.de
> Cc: brouer@redhat.com; Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> netdev@vger.kernel.org; Camelia Alexandra Groza <camelia.groza@nxp.com>
> Subject: [PATCH net] dpaa_eth: fix the access method for the
> dpaa_napi_portal
>=20
> The current use of container_of is flawed and unnecessary. Obtain
> the dpaa_napi_portal reference from the private percpu data instead.
>=20
> Fixes: a1e031ffb422 ("dpaa_eth: add XDP_REDIRECT support")
> Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 6faa20bed488..9905caeaeee3 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2672,7 +2672,6 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
>  	u32 hash;
>  	u64 ns;
>=20
> -	np =3D container_of(&portal, struct dpaa_napi_portal, p);
>  	dpaa_fq =3D container_of(fq, struct dpaa_fq, fq_base);
>  	fd_status =3D be32_to_cpu(fd->status);
>  	fd_format =3D qm_fd_get_format(fd);
> @@ -2687,6 +2686,7 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
>=20
>  	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
>  	percpu_stats =3D &percpu_priv->stats;
> +	np =3D &percpu_priv->np;
>=20
>  	if (unlikely(dpaa_eth_napi_schedule(percpu_priv, portal,
> sched_napi)))
>  		return qman_cb_dqrr_stop;
> --
> 2.17.1

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
