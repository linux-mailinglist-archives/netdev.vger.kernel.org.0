Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D07424E69
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 09:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbhJGIB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:01:27 -0400
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:14213
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232502AbhJGIBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 04:01:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNS9CdnCdws6TGypsfG5CJ2IHImcQF2ztFT1slW0SrNwJTZkH6Cv3e/QLuI2NY8CtZxFY8luQZHokwDdd1J1S/Iitr5cEBoIMv3htd76fnn5+LqhcdxIMvH0zH46u/A7t/Fh5djAQDHG8QkqKo6/5fx6M5MtoYSwTsDijpinqA8FN1M5/kV9fvgixJ+9pb0YWIjnQOurFoDuNyjVsv7DbtbAEzjv1ad4Dqz+u/AoNYFMFJ6hgF/ucJg7jc+mlD+llbEUEZwpxNzJGLNi9g1lWfsGV4xcpcOlV4qdRp0nutuVhcxrhi5GUrpWMyY9mRDVKzGCrFRJbjBDgybK15tJTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTvW+pM/k4NqYbfpUuXt9mJTjE4WWDvqJ1vQwvKXN2U=;
 b=JSnpPWIbznRKDg20b6dsHtxCTrHUjprN7ZdQ/Q5bECzTAVgh6ra2X0Ai4fMWE/FTScJsapzkHzhRLMXf3AYfGLtxIkmoNw6OgEj/equDx1j0BolCzp4RDJaXr/hodoeXi4/LWXQajWhxBrQ9XoxtRxiCVgFRT6r0OnQp2mrWtpnHbEznPVn5hSSUEtjSoVNQ1Sn+5U0wBhc+9AQYwghPMdFpDPzLFt2i/7YfNoB/zfQb2nAI4W+ixTtt6+69sB9ii5uvl8fttVrqvKTJ+h3QTAZOXsvGaponmQ80sG65tiWX2MkTEkmmDLDqfpWzirX4Fzo0Dl7ZAQNBO0x2DXdG0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTvW+pM/k4NqYbfpUuXt9mJTjE4WWDvqJ1vQwvKXN2U=;
 b=Hc7iTJUCcEMLHP5rH8NlI6nrCtbSzWo4Tzxm+54eYDKBge/9nHi7fa5J2z+HauXrvbRkFBXdn4Y0cXfNcQqGqk/TzicTjHDfocizWYOdCxN5n4AUeb6wjWXH81qhly8QdAqoPC0cVo/BT8QZATUmNB6sIwCIuiTXC3pi1L/ymRE=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB6739.eurprd04.prod.outlook.com (2603:10a6:208:173::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 07:59:26 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c%6]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 07:59:26 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Topic: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Index: AQHXuu66y32LWmROBUCgcDqaC5R/VqvHKlPw
Date:   Thu, 7 Oct 2021 07:59:25 +0000
Message-ID: <AM9PR04MB83979C1C47471719E6688B0F96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
 <20211006201308.2492890-3-ioana.ciornei@nxp.com>
In-Reply-To: <20211006201308.2492890-3-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d046cb50-ba21-4d66-13b7-08d9896861d0
x-ms-traffictypediagnostic: AM0PR04MB6739:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB673969046AD3E46BCC3F76A196B19@AM0PR04MB6739.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1LtbyDp1o/ryOg4YpieUPADHrzQo/zssuGcnQlcN8hVdUDBYOO61KsSZPAk2E8PZhCjpfRmNc1qcapGUaIt4mznQgkyitRhoAm7r1IS1PFFRWoi6I0GL3sPlGmtR5nsbAthgeXzGcrBs6EK7y3PJAcOoYXEDIcYw+XLAccrYfeS510kaAqAyZDGHHpxZsveVAZIssJfupwzSqsxOejLhqkJ9NRph+DwpCCO/KGf/OmskKIUB4ExmxkfV8irC19MWIDDvQXE+ZzfFCm9+10lrSMnKjZYhw81ZUzwo0fCgLFukIy28Ar3dOofS2S9wYFRZDbNJgsp6sccYQQTT/qInyxJkmaejwZaniHO/sfno1KoDzaVhp0GPEhiIS2fiWLjElaKf/Mcy9wpGxdFmgDhAz/Z4eYwMHI4qpU3MT7SD9mbQXn3a4VUW9IwisFj4QP2z2y6xjoYWc/XY/818icviAB7C8F3ESABYj/4Nq2rN3Vx8OuXZR5kVAOFmrUjmhDAdUqsSklxcoFUILq/2ugpPRHzcMGDmBSokknLxu5oyDEN2YFDwmd7LotMwm9ScCTb9+lJRnP4ZwtVOpt2m86NJuNOmAPn0xwV89yTQ0ZljxBm8rAqs91J71A0oIu+anlSad3FzE8mzeCK67cJOcmqMdIzc1S4igrO6mgHETDu8xcAlmvQMf9dWoSd18SFg4iPQgdLjJH5ToGwyShzmbQ/9hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(316002)(33656002)(54906003)(110136005)(4326008)(71200400001)(5660300002)(38070700005)(38100700002)(66946007)(6506007)(9686003)(64756008)(66556008)(66446008)(66476007)(76116006)(8936002)(186003)(52536014)(2906002)(26005)(44832011)(55016002)(86362001)(122000001)(4744005)(508600001)(83380400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LUOgwzxxdLrIpd5NlmPVHM20HvA4FnB88LdMQPjGyeFrgFBRad3u7GkoVeTY?=
 =?us-ascii?Q?VMTkvCAfn/RoR7MlhtKOl36YgkRDm4uhQsy4/M6GjKfPpkMhp/00b59nEEAo?=
 =?us-ascii?Q?rTuoHWVAQY3uPrMCmvHKxjZcIBpssZmqXeY+u+uu6yNjZGzNhJQtxqmNUJVz?=
 =?us-ascii?Q?egpcS0y9SWfU23AqN3ZeOa6MkPoJDTJRKVU4rw9d2F4lYxp/aEuKPhkmmIlb?=
 =?us-ascii?Q?3o3V7rSOTc+X/2FzSGzlmA0qbZBhkwVv3XpKj20eYPe5xrIVKOADlfNEA6RJ?=
 =?us-ascii?Q?KyT8S3ZMoTfWBBLhErs11mLCL7kRUBXAM5nyUdfublh5jlaCg9Srv/1ZQFbP?=
 =?us-ascii?Q?YZIzTPG2X7T/9BnRdHX89h5tRhu6SGtrJ29i40H+V0meZJz/bRxls8HYHU2R?=
 =?us-ascii?Q?OEYS7w6luOcHI9dDVTfagchuFRPj0pFQPNMgoWViOTzLFzheuC0i6ooAypUI?=
 =?us-ascii?Q?ccXGWrjhMxPwaPA90l4Ua7PyocnM0kuJGHzzIFBF/TOdSnoOBs3uo4wcr9mB?=
 =?us-ascii?Q?LMusYN8c6D0dZQzIqLo7K5NmXBWGsbPvI7WwDJcLYpsx8ZaWYvI8j4t4sQgF?=
 =?us-ascii?Q?mT7YwYZjlI9+AEouBV4o7Z8YbFJdYoKT2lTEqYZlKeOavsvragDqllFdIG4L?=
 =?us-ascii?Q?G0LnC8/ymlYBFhdGBAaUN5VjYdvm8lHD5yg+1RNrf0bFMZT6UMi3J2vS/awe?=
 =?us-ascii?Q?q/7cijSKENtLyODGAGw880m5CI6Rp963w1EOnxzHSunphdm1tIxPDxAW3qi/?=
 =?us-ascii?Q?Sf0qbRYVrkkflzqvBk8lJuwkk7d3t8wHvaudOBddJR0OpuoxujgH/8oGeMGS?=
 =?us-ascii?Q?xxiEc3VrCsS48jQEjRTAdq8ya54rEFwb/kblmqutWKcAiSuuzBmcMg8gohV/?=
 =?us-ascii?Q?PjqwO8Ph9UZRCLvabMk8Vc1rcoX/jMrGu7PYLYMfJDsWfeSSSFgU+E4+YB+4?=
 =?us-ascii?Q?fgVJlb4JNP4gbFmswvgCU/7y28wliptVZNDFMM0FrLtPPlNlLIciAqGWjoMV?=
 =?us-ascii?Q?S8LzKh9QctSgS4qfLYKJWHsbjFzJiRLxGmel6Crwe1yWQxvqi2FoNB/ITXp7?=
 =?us-ascii?Q?tz5+i/WpA7u8rIVxs8WBo4QJLDlYgbGJQSLxFUGljSSD/7I2HDpJzzsXzBgr?=
 =?us-ascii?Q?VhOtW5qJNLv82PFSGVytnTIbzC8aVg1WE8LPPlpsN5SHhr2RySiZdxOi0J5h?=
 =?us-ascii?Q?ZTLgsDvQ9NCBoFaT+rPWkh3Fe7roiZF4gyvJZBkxJ7ThhZ+GCqo6inzLaTVb?=
 =?us-ascii?Q?Kxtxb6iKKlgi6Qun06REg9FiZSvMhsvzvoUFqXlIVkoazR/w9f13k5LOumMT?=
 =?us-ascii?Q?MAE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d046cb50-ba21-4d66-13b7-08d9896861d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 07:59:25.8882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mps853sBET7wZHpsrrpP1Juzqr6Vhvi2hNNmshgDUH2EoRObSVJwyf/waxykb/1NtTNTktEUk3T1sMdX0gZTfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6739
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Sent: Wednesday, October 6, 2021 11:13 PM
[...]
> +static int enetc_map_tx_tso_buffs(struct enetc_bdr *tx_ring, struct
> sk_buff *skb)
> +{
> +	int hdr_len, total_len, data_len;
> +	struct enetc_tx_swbd *tx_swbd;
> +	union enetc_tx_bd *txbd;
> +	struct tso_t tso;
> +	__wsum csum, csum2;
> +	int count =3D 0, pos;
> +	int err, i;
> +
> +	/* Check that we have enough BDs for this skb */
> +	if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
> +		if (net_ratelimit())
> +			netdev_err(tx_ring->ndev, "Not enough BDs for TSO!\n");
> +		return 0;
> +	}
> +

On this path, in case the interface is congested, you will drop the packet =
in the driver,
and the stack will think transmission was successful and will continue to d=
eliver skbs
to the driver. Is this the right thing to do?

