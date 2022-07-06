Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A91568915
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiGFNNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiGFNNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:13:06 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130077.outbound.protection.outlook.com [40.107.13.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578DC20191;
        Wed,  6 Jul 2022 06:13:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8GYdFaxNF8SiN/nXYtiecn7TlTqyR+5WiEnggp8L08akNSPr3VFPUUVtq4V59JRa8UjaQyP2dO5hfDMNzlZ4nPDCmslG388zN11hIfr+le1i/gSDVF19wwLMjvui4gjrA7L6aEk+0hIzVmHhiWyqSaGAQYeWC7i8ivDV77zMQjUL+p6CGqLFFx7Ez7YJ98MJHwTynJkF1dgUdk3al4dxNiB+z9UI/+JZEzTYB3wbu4xB6hTniHzuCToLo9tagSRy0n1SlDaZ72PlIWAu5oMpnmEg7iXba18L2XTvx4U9RlPzKesHPxyJOs9StBTs/5au9gaNMoOBBe38XKk4PJc4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6JZEVygoiO9o+DDul2+6wZ//zFBfMx0TX8PROCf6z0=;
 b=UJX60vHXB9l+Skae4hY6TSFklHaw+ESNwolA9gX0RuM059cZPV1irsyb8JKWNOuw7U0k76z8UTROQQuGhusEk2u6KPbx0bsHn5ANiisZ4NTBOsyZ3+HCAvfuH0o553ML8MN1ebPGCWb7lscAvYk/QrVZk/6EFxQRN4UCdF6h5Pej34P/Yet6C3lAPWDpXHaGqbFmAhciGiXzHiosLQs0BMj2nsbYeolfVC9O9fwuE0QusOfhzO4NLSYcCLXcsiU5ubp6gLU6CCLXpmYt0eG+CZFiuSeM+c2CBkA6T2ek4vrVuMqYH+3vaqf1XwAtkfIIdhPtor2JHvvRnu0oIdHONQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6JZEVygoiO9o+DDul2+6wZ//zFBfMx0TX8PROCf6z0=;
 b=qq6Imn7P2VuaMeIAegQxrMvC2yuAQkvqtdvlII+qcirRxyGdBfqXOjHBD1xZmfFVHUhefKmOd0CIDFGOzsYOxi8y2K2P+hs3Ix1DfXpMYS7yedSSBy0ktsIYBJRTvaOVZ0Ityqk1TzzDmwHTregGnD8mzgT4pqENvvBASIQdOYo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8732.eurprd04.prod.outlook.com (2603:10a6:20b:43f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22; Wed, 6 Jul
 2022 13:13:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 13:13:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "clement.leger@bootlin.com" <clement.leger@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3] net: ocelot: fix wrong time_after usage
Thread-Topic: [PATCH v3] net: ocelot: fix wrong time_after usage
Thread-Index: AQHYkSZB/F5QO/XCnE66pe7u42qQSK1xUe4A
Date:   Wed, 6 Jul 2022 13:13:01 +0000
Message-ID: <20220706131300.uontjopbdf72pwxy@skbuf>
References: <20220706105044.8071-1-paskripkin@gmail.com>
In-Reply-To: <20220706105044.8071-1-paskripkin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87a29c08-4173-4d76-46e8-08da5f514136
x-ms-traffictypediagnostic: AM9PR04MB8732:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pg54oneiVGx9S08cF4Xn0xbTfKRcY4ckKoA+AikDKhDvD5gkC4OKTSXJq12y3Bhs8h65lF7YG+6H6+iGCenFf9Wh0QqF9UaVwLrYaeA4BJCuRqef9AiGc7jerCnxIrapYSDwPVolmLBvE3g+Ewsk9XIdjhu7QWRQmRJIQ7oKJykNkfeG8YwkcesELGZKc4Ui7aDCKuDVIhMPT2Trxv2xKltJl5KjEZHzxHBsBGI2sXe1p/IXagH0ognsOtqsVG9hqgrmhgmXYhKArDIIo7GYmo0S4PTvaQ9IWRHovB8lZEN8r2hob/c6kwpdQo3UbullD9Y2mSn53odMB9ZX9Dd8fQcN5aRgY/So3885QPs1wI7TDjUgycKLTD4GCPsHvFTY3Bt0Ppd7axZsyC+njgyxvslJ1545OcZjHgQsNbKbycyfNLs1mK/jxZc76XROIDlloD7TRVfmT8n4La+sNS99ikaSgNpGvN9F1+4lf0zgNrg70grgbsvNZPVEjt0Ru5D0NaKYBrHVETU3RDlOQoq6kczII3ewDyz28sxy5kARaYkrzRQc8B0x3DdNkdTr0ZVpMC7XdxcHfC4VaXBbg8OkopW60t8GCpgfUyysPoDUPZIP8j67SRIYOcWDEqUeV+kuzj7WaZ2yxnNYpSHB4R+dzVdP0ibhFUpHQeGmOg5VwuCXhq/LMOpPvxGMDM5ttxOO3kx3H3e8DoFtzeNRUp6j1tK/S/9Gi6hdSxqvInPp5ZppVCNDTWy6tILJug5YZOwL18pX9FIbbrzejTecGf8jAIRbm0A7FA66MoF1spmiZENw6hOcW7kmm+IbJEUid7Kz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(396003)(366004)(39860400002)(136003)(346002)(8936002)(478600001)(86362001)(5660300002)(7416002)(44832011)(6486002)(83380400001)(186003)(1076003)(316002)(54906003)(6916009)(9686003)(38070700005)(26005)(6506007)(38100700002)(6512007)(33716001)(122000001)(41300700001)(2906002)(66946007)(76116006)(4326008)(8676002)(64756008)(66556008)(66476007)(66446008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Z5eu70nnFNgxbbwqZWNVGbEKGnxXBC/mrHT68HSv6O2z8BauWBa7GOOmZKen?=
 =?us-ascii?Q?TMu7tmrH6rHfaSC891fBF+w385gKHFX0/M+lnjz/Oy/jYLD/JwBqFZ173MWw?=
 =?us-ascii?Q?TBRUydpQZY2JuDbZzmdEr0u4Ikj0ly8703P/fG73mw/cfyNUCtlI6Ane8rbH?=
 =?us-ascii?Q?YNbUBXZJmyfPVd1t4qGPSxll1u9y2BywSZ9YMwoDJ0rwEfRlRD+NNeaXk/Mn?=
 =?us-ascii?Q?WmDiK7AmzNmz1+1kk1gn8DKjfPLkidjZU8iFN/Ov8sIer3vVcgHWs6smia4s?=
 =?us-ascii?Q?eWmIxV/TLfl2iwM/gvg85A8AO5P+9NLzEuPWWx5jXeyrrcMEBZ8a8R1ktpPu?=
 =?us-ascii?Q?ndwQ9CYtnT6xxXIuZsdZ4JEaK1YCN7pluzFLUrD2MyQaFsYhNYTix8mNfyd0?=
 =?us-ascii?Q?M6ZEQkyLErXYAZ1lEYWt6MutX/3C+KZVWJwGy46Oco+kNKmF/1X3NiUmZJ2z?=
 =?us-ascii?Q?wfG4UZ1Fq9hmvoMGP2Z0omzsiRQeNnHaK/f5YzWBdYZtSl0/yhJghRb8OgQd?=
 =?us-ascii?Q?9b81RVtIXHzbwAmsbdrKeB3M8yZmXVDXUfuIN93OSewDaJyz0avO+3vVhO0v?=
 =?us-ascii?Q?jrNcm7CCs9XVEFpmaOPaeuDYLcZ5saNTEScq8aMjhWkni/CPGRajqd46BK8r?=
 =?us-ascii?Q?vnX55ge0MTxX3tF4SVe6BoM6pE4bsomR/Rf5YSRLBtQw/W6SvMF/HVzqLvCb?=
 =?us-ascii?Q?9xhloqDSOid4TS7cF/WMuureAj6cJ/Vu1WSotQMhNLwlIs5uXLtxq6/MjKre?=
 =?us-ascii?Q?OpDZL7ev9R2AuvQhyqMFa7F5bSeE9cWIjERBLWTdFOvY71ukuJ7+B2rUtzbq?=
 =?us-ascii?Q?7D/VCrIgAAPm8tg849ggItvbaUbPSE2W7LYSMvxd5FkjUVMH5OxM06Nc/YSe?=
 =?us-ascii?Q?ObNe+KqTwY50dMJdJIdIj1DR30QAbTMaIfsjSBPb+vUs40gaocCRSy5lGzm6?=
 =?us-ascii?Q?jdWpvSqBpUw0w0KJSXo8pHf+v0AZJ+NeIdyLzvRP6FQUX+xQNUZ1JONnLudS?=
 =?us-ascii?Q?SQoj4aVLqIXkM4zC/cHZ1qdxghEAlnym1i0VVM7XMwqXshLPCBUm7L9eFZkP?=
 =?us-ascii?Q?BzP9JiRaFKInkqKT1mjZ31lEFOKkm7BeU7QwNZkGbhs9SOg8dBsQEe4FpToi?=
 =?us-ascii?Q?/3BEcbPO4v/Ft4cq6bHLArH7FxLRydKurgeQgSN3QGiiqSBTZ22NUuAVqOQz?=
 =?us-ascii?Q?TgLBM5bntFdg+yfK4AlkNxkzfXklPKDtGzDAX/L7bBJuzBvp82hTAknbHrB9?=
 =?us-ascii?Q?nHBmPnFoa4xeyPDrRd0WSW4V2KOeNi1sMgwjSgIhK7ow+uG5gbsl/m3S/sos?=
 =?us-ascii?Q?5SNuxpqnXPhMs0ficpGjuBCMcUhwfCVcFwb1utK2gJb2edT6GZOeyPj5X7pf?=
 =?us-ascii?Q?yZ9/lo72QYSArGyvEOym5bGrzfrUAh3RcYvZ775L1LpYgms2NSy+5efT9g/w?=
 =?us-ascii?Q?e7L1t1gGw1aUT8m0xDVwyD/064m5jxfdw4umwdQNXLXFUHz8IRheO0ytU9eu?=
 =?us-ascii?Q?yOancX/56NsfGuks2MsJ4HJeHYB9yq6MSnsoODjV2MN0zbtxkQ/wCuR9NP4Q?=
 =?us-ascii?Q?DPpc+wSDPV0LZXf9o8aShGH9C8+4i9UHnXVUCSihJRHFK82498CUF7h6rTTB?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2B10E08D4A27824BB1241F8E704D7C89@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a29c08-4173-4d76-46e8-08da5f514136
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 13:13:01.6943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IIQYbq3hkZqZwgs6Vfou76kcxz/dVwXPZGxw8MTHxTtAlSSjGvXKpfc75QzL6SHRvKsl8PJVefSrhMWG6KYpvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8732
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

On Wed, Jul 06, 2022 at 01:50:44PM +0300, Pavel Skripkin wrote:
> Accidentally noticed, that this driver is the only user of
> while (time_after(jiffies...)).
>=20
> It looks like typo, because likely this while loop will finish after 1st
> iteration, because time_after() returns true when 1st argument _is after_
> 2nd one.
>=20
> There is one possible problem with this poll loop: the scheduler could pu=
t
> the thread to sleep, and it does not get woken up for
> OCELOT_FDMA_CH_SAFE_TIMEOUT_US. During that time, the hardware has done
> its thing, but you exit the while loop and return -ETIMEDOUT.
>=20
> Fix it by using sane poll API that avoids all problems described above
>=20
> Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>=20
> Changes since v2:
> 	- Use _atomic variant of readx_poll_timeout
>=20
> Changes since v1:
> 	- Fixed typos in title and commit message
> 	- Remove while loop and use readx_poll_timeout as suggested by
> 	  Andrew
>=20
> ---
>  drivers/net/ethernet/mscc/ocelot_fdma.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethern=
et/mscc/ocelot_fdma.c
> index 083fddd263ec..c93fba0a2a7d 100644
> --- a/drivers/net/ethernet/mscc/ocelot_fdma.c
> +++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
> @@ -94,19 +94,18 @@ static void ocelot_fdma_activate_chan(struct ocelot *=
ocelot, dma_addr_t dma,
>  	ocelot_fdma_writel(ocelot, MSCC_FDMA_CH_ACTIVATE, BIT(chan));
>  }
> =20
> +static u32 ocelot_fdma_read_ch_safe(struct ocelot *ocelot)
> +{
> +	return ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
> +}
> +
>  static int ocelot_fdma_wait_chan_safe(struct ocelot *ocelot, int chan)
>  {
> -	unsigned long timeout;
>  	u32 safe;
> =20
> -	timeout =3D jiffies + usecs_to_jiffies(OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
> -	do {
> -		safe =3D ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
> -		if (safe & BIT(chan))
> -			return 0;
> -	} while (time_after(jiffies, timeout));
> -
> -	return -ETIMEDOUT;
> +	return readx_poll_timeout_atomic(ocelot_fdma_read_ch_safe, ocelot, safe=
,
> +				  safe & BIT(chan), 0,
> +				  OCELOT_FDMA_CH_SAFE_TIMEOUT_US);

Can you please indent the arguments to the open bracket?

>  }
> =20
>  static void ocelot_fdma_dcb_set_data(struct ocelot_fdma_dcb *dcb,
> --=20
> 2.35.1
>=
