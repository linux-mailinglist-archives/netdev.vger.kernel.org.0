Return-Path: <netdev+bounces-4950-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3FAA70F56E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 194781C20BA6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B20417AA3;
	Wed, 24 May 2023 11:38:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871E9C8E9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:38:23 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E34E1A8;
	Wed, 24 May 2023 04:38:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FruPLZ3Z4cae2bpbsj/T0mu+HHQr3rE32uw65HQfk6NxaIeaEiNbT9/BQ3ukI32OllMv83lT9JblcPfXlWJ/tn8dB0PEMIl+swCloy5gdc0CSJVUOqz/G5LC/aIyZCChUCLpR3ih7VIMUHsZCv2UwbF/94qWDwGV6b1KwFsNy8qWUuIaa4/ZWQJmIlCbkHVkrV9yPi66xUOMVFbAcsgGNgUyhZWTD4u3qs/IxXq1K3utsdOsenGZIIGqJqHFsFL1sUOjRYhZLbrXD1T0l4xSW/ipMRdR6WqBBbCaW8vknHng4XGAju75gAj/FcZAAU/bqA3hfzw6k6iK5s7toV0ckw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRVMcsq0bGgV1Iizo/kzpHJr9EWXXBMR0VGEgHK9ip0=;
 b=id1SNC9gnB64Ot6ngoabJCWA6oFvM/sjxY2B5iT6XTPF+dH1GtRYAq849tG1g2qydig+QVkf2knvfqAuaXiUdlMdIW/RBo8PXDX0OqDxbSn8gyhPi3/l6NxLOeKfaj9+o0RVFxreSU7oOYvUaw+Xn0YqQH3WKlAVfNtZeta5E1nKIiGM0neF5+D8Acp8FlF170JGlHH7ifc5yUqUVUIYpOOCtrudvh9vyQv9kuR6yekXGBj5DLB3MUVfDB2X9TToGfhanJ4cG84CkVQ3/xkiIkou3mIu3HSaYgmjFoiy+ef00eGVtCUuBRMD1c4FH/5SC25OKexSG9UtJs9XpFAs6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRVMcsq0bGgV1Iizo/kzpHJr9EWXXBMR0VGEgHK9ip0=;
 b=xk8uiIkYzwyJLan5nIgDIBgjK2Aff2N4OdIR7r81v54Ud8hLcS81+PyytCPlq+WKuAw2Ysb2rNVvYoRuu7qDr8SA3TxmZ3arZZtztX926zf6vAFwzdJQqJ5h7iZ5m611HgcYGcX9ggpuE0vjEK7GMsRMvzlMzNlt1gTaVnNTDl8=
Received: from MN2PR12MB4781.namprd12.prod.outlook.com (2603:10b6:208:38::24)
 by SN7PR12MB6691.namprd12.prod.outlook.com (2603:10b6:806:271::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 11:38:15 +0000
Received: from MN2PR12MB4781.namprd12.prod.outlook.com
 ([fe80::1768:40c5:be30:9251]) by MN2PR12MB4781.namprd12.prod.outlook.com
 ([fe80::1768:40c5:be30:9251%7]) with mapi id 15.20.6411.027; Wed, 24 May 2023
 11:38:15 +0000
From: "Katakam, Harini" <harini.katakam@amd.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
CC: "andrew@lunn.ch" <andrew@lunn.ch>, "hkallweit1@gmail.com"
	<hkallweit1@gmail.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "edumazet@google.com" <edumazet@google.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "wsa+renesas@sang-engineering.com"
	<wsa+renesas@sang-engineering.com>, "simon.horman@corigine.com"
	<simon.horman@corigine.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "harinikatakamlinux@gmail.com"
	<harinikatakamlinux@gmail.com>, "Simek, Michal" <michal.simek@amd.com>,
	"Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Subject: RE: [PATCH net-next v4 2/2] phy: mscc: Add support for RGMII delay
 configuration
Thread-Topic: [PATCH net-next v4 2/2] phy: mscc: Add support for RGMII delay
 configuration
Thread-Index: AQHZjKj6qC3EOHXHPEKjq/WQg7n0bq9pNmCXgAARoQA=
Date: Wed, 24 May 2023 11:38:15 +0000
Message-ID:
 <MN2PR12MB4781FA4BAF177F9969D712309E419@MN2PR12MB4781.namprd12.prod.outlook.com>
References: <20230522122829.24945-1-harini.katakam@amd.com>
 <20230522122829.24945-1-harini.katakam@amd.com>
 <20230522122829.24945-3-harini.katakam@amd.com>
 <20230522122829.24945-3-harini.katakam@amd.com>
 <20230524100924.ty37zfndvh2nlgj3@skbuf>
In-Reply-To: <20230524100924.ty37zfndvh2nlgj3@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4781:EE_|SN7PR12MB6691:EE_
x-ms-office365-filtering-correlation-id: a02c2f11-6007-4ae0-483b-08db5c4b5cec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 bagMpiAPbRjxs/wTG3tYHl9AQ7uaV9jSqADSzFUgWkNyDuxmm6Z3Qwhg1LqffLE6Dc/1Gb6SQ2O1RPgRwgybBs3pll39aPpDG5aAciES4rW/TrJW1F0G2xl11x2eKysJqj8yhnVDPSM4aAwZvt779OM3AzUSbDdxdrFWqlJL30G+CA8fNGQuCy1uIsZ99ETuqpNMW1qam7jqYVsApvWv6qJUzWMSMfOIYgI7w3HS7t/dDGKXR4j5v8WhFOr1kzCDb8vdZP+sVl7U5TxssyEPJzr9ijqjyiK4/hO4R3gAt3kxzI7klI8zRaR713vcmDQ7tqJOIFypExTs/vaCt+lpTwKkc+DcZU6fjtkwLT6MREseidNpaxA4rHQsVgc4L+VDGLEo0LsLNrmTJo4+iPoJL5VxmxCCqxhimSGY5vEkMV8mDJXXgj1OiJ7mJaWYlGggCdvDq6mxJb8vgT+rdnNzs1IUy3EtwST4fTPdf7pxmXEvhOKhZ4Uqb0M5y1AyAKeA/LbGILh1w1AwEKWe9Vkakk5BtTBbO5S9xNZ43pJeQJb5u0sTuCpTrLNgmyQRfjlXXo/8xgqBxH/d2FMHaTJk3jZN1rrtFjjyX5NOpIkICNP8ZkoSAlyUtB+Srg45e4RS
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4781.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199021)(38100700002)(54906003)(41300700001)(7696005)(478600001)(71200400001)(316002)(4326008)(6916009)(76116006)(86362001)(64756008)(66946007)(66556008)(66476007)(66446008)(52536014)(5660300002)(38070700005)(8936002)(8676002)(2906002)(26005)(6506007)(122000001)(40140700001)(33656002)(186003)(9686003)(53546011)(7416002)(83380400001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?fdWiQknG2U4vuL433qwdnK6YxMyvB4eTD/mS7FHo6ckhED95vIzBhDHUxCuF?=
 =?us-ascii?Q?I3zSLufWjfJbvKINxiYthrqj1TJpXu96TLrv4OYyDhK7pMrF1CB0ktlb05QE?=
 =?us-ascii?Q?i42gbIuctXzQkSBj5ERmkchMBCmF9opj1u4OiW0X4yFE66qhkNupxP+VC3B5?=
 =?us-ascii?Q?CUv5ScFH1CouqJLk4VCWl0X1hChdIWMvB70D+Jo53T15hdS66h51jcqkwb6l?=
 =?us-ascii?Q?v29Zid3dKPvNt3JemGsPiBSSmUpkAu2HPFdwTkNHrsQrgt2UU+W+7zo7NwI/?=
 =?us-ascii?Q?SI8W1ZTjHdUjf5IV7vACau17HdG/zbDuqxzNvlo0taqpP0waY2CnobNhAovx?=
 =?us-ascii?Q?sOSD8Z0fl81ustRApAGsVdgJfNMapxnKYbmmM1HgxO1FpJ7kHw5IDMjz6Bke?=
 =?us-ascii?Q?TdNRIkHrszjhw9KGRBonjgju/8fN9Nzh7Kn25mOJLeb4Qx434qPSO0amXa+r?=
 =?us-ascii?Q?LkRcAuyNKGAqAE4v8dPl1MNQQYsLKI3gnKj1+nW70Mm0vUjRq9UiNeXxggmU?=
 =?us-ascii?Q?GaQqMPCP+PuIIaMUIXFOgeeiAxHBSHtUT9f426nq+VqAhWNA51bK7WLspKvm?=
 =?us-ascii?Q?khldybCiG1ncckX68Hr2cgrmEEdYm9R0WWPighFvQNOgkAoIaVbfi5z9fM/o?=
 =?us-ascii?Q?BPoGzNChutBV3f8cHkT4bIN5sEEn/8alzUCmAsCGKsj5pEdkRThvjzeMz2mG?=
 =?us-ascii?Q?fxVQwfm4c+tPVwLSi61+Re59KGNjvyPjSaGcfx4ecGxSPvsyey5gAWzIiROq?=
 =?us-ascii?Q?4CaiMVsk0MRlq9WHxkn14uS2De8tO2fMQzIVhzOeyzhTreP4Gq7vR1ZvGo/i?=
 =?us-ascii?Q?bjawq/xF+sQZPCKlFq67Zez7DkmCQ8zVXhp9zW3h1pYC+N66vYJM5VBcRrn2?=
 =?us-ascii?Q?oRyXYm3VOrNMatLSTbgKdL74t0bmeCqAv2HdmjIXgeSG3lBj1rjL54f68Hno?=
 =?us-ascii?Q?lX97w0kUhuzFpyIK8VixDRDV9GPrDJ2JHwGYFUmGtE4Mdbs/6CpJkVJ3Gn01?=
 =?us-ascii?Q?/lBMW0yQFwTjwpssVZEcQivisHBnvKAOFnriSE3pPzMF/BdKBWTDYGk8vmwq?=
 =?us-ascii?Q?HzAmBcCiak3cpnPoYsTa44erNKdyqfzzoKwcXtg+9ophM7/PoiJrXMm94MIC?=
 =?us-ascii?Q?5HqvDegC6CSFaIPzfWr0YvaUPtODS3SZUrIZfpV9XBZ+QwTaHyZqGSgoXEY8?=
 =?us-ascii?Q?6YKxsMqbHyTZ1ezd4FJiT9zEjOAnFsiFkbFYcBS9k2lLmxVLUKyopiImhWQX?=
 =?us-ascii?Q?tY5Dp3MPYfhoUrXsklWsAwJp+Qoz3O5fZ/qxDrCbECF79h6WtJOqbv5UFr6W?=
 =?us-ascii?Q?pNrpHSCnhLd6IQgqCt+3/XBSp64Qdfw3lAIAHw3uV2AZtbSqAGNN9fB/DVHq?=
 =?us-ascii?Q?FCc8qKxtsm2luAVeJsgJZFcDsU4Sz1wz1ZVrh2RcpvlpAxe0dHUMw+f+aGbP?=
 =?us-ascii?Q?J+5J1v5nHx/01qg/NQLmIMtFNCe96AJIiPl2c+GsMhnyVGH/WE/WzG3ykRLT?=
 =?us-ascii?Q?D+48EyhhtxE3tX3VzsCDx8OmcxBOi1tzMqxtZRR3VVf4m+iCHwLjjYu/qWzW?=
 =?us-ascii?Q?o8JUPLJ2Xr8RG5R/N5A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4781.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02c2f11-6007-4ae0-483b-08db5c4b5cec
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 11:38:15.4326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IxjVNGEOUsWQ8920NHN2G+bSJi6M06bkxcf/hmKgn/AFAgmK8TYukMzUtFe9uU6F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6691
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Vladimir,

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Wednesday, May 24, 2023 3:39 PM
> To: Katakam, Harini <harini.katakam@amd.com>
> Cc: andrew@lunn.ch; hkallweit1@gmail.com; linux@armlinux.org.uk;
> davem@davemloft.net; kuba@kernel.org; edumazet@google.com;
> pabeni@redhat.com; wsa+renesas@sang-engineering.com;
> simon.horman@corigine.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; harinikatakamlinux@gmail.com; Simek, Michal
> <michal.simek@amd.com>; Pandey, Radhey Shyam
> <radhey.shyam.pandey@amd.com>
> Subject: Re: [PATCH net-next v4 2/2] phy: mscc: Add support for RGMII del=
ay
> configuration
>=20
> On Mon, May 22, 2023 at 05:58:29PM +0530, Harini Katakam wrote:
> > diff --git a/drivers/net/phy/mscc/mscc_main.c
> b/drivers/net/phy/mscc/mscc_main.c
> > index 91010524e03d..9e856231e464 100644
> > --- a/drivers/net/phy/mscc/mscc_main.c
> > +++ b/drivers/net/phy/mscc/mscc_main.c
> > @@ -525,17 +525,14 @@ static int vsc85xx_rgmii_set_skews(struct
> phy_device *phydev, u32 rgmii_cntl,
> >  {
> >  	u16 rgmii_rx_delay_pos =3D ffs(rgmii_rx_delay_mask) - 1;
> >  	u16 rgmii_tx_delay_pos =3D ffs(rgmii_tx_delay_mask) - 1;
> > +	struct vsc8531_private *vsc8531 =3D phydev->priv;
> >  	u16 reg_val =3D 0;
> >  	int rc;
> >
> >  	mutex_lock(&phydev->lock);
> >
> > -	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
> > -	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
> > -		reg_val |=3D RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
> > -	if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID ||
> > -	    phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
> > -		reg_val |=3D RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;
> > +	reg_val |=3D vsc8531->rx_delay << rgmii_rx_delay_pos;
> > +	reg_val |=3D vsc8531->tx_delay << rgmii_tx_delay_pos;
>=20
> What about vsc8584_config_init() -> vsc85xx_rgmii_set_skews()? Who will
> have configured rx_delay and tx_delay for that call path?

In my current series "rx_delay" and "tx_delay" would end up 0 and a
delay of 0.2 ns will be programmed (default for that field).
I guess if the phy-mode is RGMII/-ID on VSC8584, 2ns will not be programmed=
.
This will be a problem for any device not using vsc85xx_config_init

>=20
> Isn't it better to absorb the device tree parsing logic into
> vsc85xx_rgmii_set_skews(), I wonder?

Yes, that is possible, let me respin. That will ensure existing values are =
not broken
for any VSC85xx user, if they do not have delay properties in the DT.

>=20
> And if we do that, is it still necessary to use struct vsc8531_private
> as temporary storage space from vsc85xx_config_init() to
> vsc85xx_rgmii_set_skews(),
> or will two local variables (rx_delay, tx_delay) serve that purpose just =
fine?

No need of the structure member, local variables will do.

>=20
> >
> >  	rc =3D phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
> >  			      rgmii_cntl,
> > @@ -1808,10 +1805,34 @@ static irqreturn_t
> vsc8584_handle_interrupt(struct phy_device *phydev)
> >  	return IRQ_HANDLED;
> >  }
> >
> > +static const int vsc8531_internal_delay[] =3D {200, 800, 1100, 1700, 2=
000,
> 2300,
> > +					     2600, 3400};
>=20
> Could you please avoid intermingling this with the function code, and
> move it at the top of mscc_main.c?
>=20
> Also, vsc8531_internal_delay[] or vsc85xx_internal_delay[]? The values
> are also good for VSC8572, the other caller of vsc85xx_rgmii_set_skews().

vsc85xx_internal_delay is more appropriate, will change.

Thanks for the review.

Regards,
Harini

