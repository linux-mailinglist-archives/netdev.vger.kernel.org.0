Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FC5535D9F
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350694AbiE0Juy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350685AbiE0Jux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:50:53 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70074.outbound.protection.outlook.com [40.107.7.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B81106556;
        Fri, 27 May 2022 02:50:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+09WAVApdVwz+3RqaQtVp+wRZpikcRTrszhBhQ+LnRGdrbwKStlsUieDzVhnTprHdXE+WG803geU8Gb74/KRpZfgyFM2yoV/MMnRmg3cL/npoSE/rsvZlfoTy5P1fllvuRuz9ifni0v7zW3C0T9AqrcnwUswG5ODnj0hPZA7+Pw6lJoCABFW2xdxFl0Z0q4g9a6+SKX8IQwEwAAh//wG2tZyZVwaAZsPfLx+FYu1YzlWEUV1Nfnn4x1aDdbRUXRvwywRk8g94lIlrEsEisIjb6DbTVG5W9XpynN7n4o/hFRl6tCubic02T4EoaHdqBkRJyuTyZ9p6VdpPpP6Sy8fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gOphPAZCwWiXSq5cKMPdC9JSXvlavE2E/EDwI7P0rBk=;
 b=BGP11ADA+q7/kahMmI97CwYmzz4nkUadK0bhRPebVpoxWFCpUHeV7HsEPkBcVWg4etdrELpCncVIPq4haqt7TmbmXAy1zTvhMxQTbWNTbFr5/2STF2/0O+NNT99qfWg5eXHCh4rQ+7SnL2jmnuiSwUPVa6qLFTSvmK5XCqpAknJlgbXl3ugDS/QkwX5zwWQhxOLdod54/Eg2K20PicoqXnhAXtYswJOeK6wy/ccr/gn/CMXC6T0LTALcNdjhQK1VHdFeY/2Hkc19iOBTyFlFHUvCF52fqHNjaD+6ifR9oIesw7pXLY2X3OSxN/Njp9RSWzxV2e7SXiBhTQCj3w2wDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOphPAZCwWiXSq5cKMPdC9JSXvlavE2E/EDwI7P0rBk=;
 b=H7Se7HxM69NG+JxQmsA+CTtayNldoLDnlNQDu2Ev8XTeamjloOnEiiuVM3e1PJ2e3b4lhq4jNfwu0rqMSIZAgl+xh24feEr7zs3ZiYrJby31AQQ/JU3n5X0kIydwAEmJhKWbMs7PTKKpwM8XOTH01iztRvPs8c/AEhRt/YD85TI=
Received: from VI1PR04MB5005.eurprd04.prod.outlook.com (2603:10a6:803:57::30)
 by DB6PR0401MB2677.eurprd04.prod.outlook.com (2603:10a6:4:38::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Fri, 27 May
 2022 09:50:47 +0000
Received: from VI1PR04MB5005.eurprd04.prod.outlook.com
 ([fe80::b116:46f0:f42b:cf19]) by VI1PR04MB5005.eurprd04.prod.outlook.com
 ([fe80::b116:46f0:f42b:cf19%3]) with mapi id 15.20.5293.013; Fri, 27 May 2022
 09:50:47 +0000
From:   Viorel Suman <viorel.suman@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Viorel Suman (OSS)" <viorel.suman@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Luo Jie <luoj@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: phy: at803x: disable WOL at probe
Thread-Topic: [PATCH] net: phy: at803x: disable WOL at probe
Thread-Index: AQHYcCNkafabLQYWvUiOZDbREa7myq0yHGYAgABhzAA=
Date:   Fri, 27 May 2022 09:50:47 +0000
Message-ID: <20220527094939.qgtl3s7frlgx3yvf@localhost.localdomain>
References: <20220525103657.22384-1-viorel.suman@oss.nxp.com>
 <20220526210044.638128f6@kernel.org>
In-Reply-To: <20220526210044.638128f6@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c46db1e-522e-4842-ae6e-08da3fc65fef
x-ms-traffictypediagnostic: DB6PR0401MB2677:EE_
x-microsoft-antispam-prvs: <DB6PR0401MB2677EC303ED9ABBDDE76073192D89@DB6PR0401MB2677.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 47uAsBJXeJuGHHTsgx6Vu7gA0k548/5CJ5+5r5arXW56D/UPfc8a+FpdG59WiBC5pzfeHBT0zkKXmmDxlcj1cvpk139SqRLZFbEXQBKL6bBuqBu+HxxfJl2jZ9ES2FPlulrKXBhn9BbX6QcXIPdjOUu4U1IY+laCrrTsitShpPvy2osi3YzIN8UCzyLRbBeeSSaAxT8YKl1tqamJqWfRK+WFTCQJ0Znqpj2xiJpZ6Mi9df3YWlZUKGz6IlM0nJ1Z9bVTvyCk3hTQqR4v9sOAtnbic+TtIfovC2+l++mBpqk4zRskIwiP+iZ0qqef+RYUuReqCwwJB1++S8qnnvrllkbMhNnqKamnTTqrnjtNWNRSD6zPFN43uUQZnadSRoKOF9v1sXHv7E1E0ZxaWQuLStDmi7Mo3vfd0viKPAky2GRctuCFFDzQW27fHi5yNzCTxUHgFA2ldvll1gvFo2Cg1ICkL0rFhbigZHCTkmr3Fhg5lsCrRpirpNy54URbZ69i4Si9jsnpCRTR2B5eKTQDfywsbzB+FhKpL+HLZ3FTdMvCfI47WJwUqOsxP7pe0SkT1Dp0dZCn1gLeqXUav+B/jepvxgYb4GmQb+2yVe1R1hJoTMpJpr8r+gcgXCWhTExWDolOUWVmOsm99wNLgnb0QE0GWcnARn+bqlzeZdhHj475NxEryQcOzN2NWyh37+RFvAUJm+hgpKyhvdIDhrrRVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5005.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(71200400001)(38100700002)(8676002)(66446008)(76116006)(66556008)(66946007)(64756008)(66476007)(91956017)(4326008)(508600001)(44832011)(2906002)(7416002)(53546011)(6486002)(6506007)(8936002)(122000001)(186003)(1076003)(26005)(9686003)(6512007)(316002)(86362001)(38070700005)(54906003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?whypKfI+UEIQ3ICO6LiG5ic3sX8m7CyKlZWiQQ5OstnfN7bYiT6jFvzVbVLG?=
 =?us-ascii?Q?3jNnT1ho9rf/QHMRhG9+2zQ8MYtQW/u00CkmoG0rOoT/NJk0Jy3jfDtAvgSo?=
 =?us-ascii?Q?KyW8TgbiyWR8pwcnEQI9CJDaymWezeZFGTwTq7AlkauQufsZwSyz26OqpLgH?=
 =?us-ascii?Q?oHLF0oeDCoYDvhlS/yifEyGTPrZxHKMZvY6r2VUwyAtH3Uqw6+EMWS/iiuK9?=
 =?us-ascii?Q?3i22jwobzGwqOuRIkVqt0kAKYr0l/KIxbEb5GM8jh/NzuQYrrq/YwFu5Bueg?=
 =?us-ascii?Q?zFWr5YpgvPOqvIZ9l5DxbcVJTGb5SZBn1GleHZH0jKExD2Au4EcpsqofmFP8?=
 =?us-ascii?Q?z+Txzhow/4acFHfFbooGnthx6JMQAYT7svDv688q/AQ/0li/5pDFvWsSQtuf?=
 =?us-ascii?Q?1xi0dhGrqy6RSDZAzTCNMlSxaJHmUJGSXFsWSArx4ieoF0bTCD+j7cai0hJn?=
 =?us-ascii?Q?+1U8wc2gQCN/lhxdE0SgGM7MfDTwY5rOIRJukp/XOhocJC9cmB7cjgDUhogS?=
 =?us-ascii?Q?ucRTKM3rM1CuEIM7SE7tM/i4Z4UaE8CHRrKTYaagrNQFM6hjeoJz24yUHK/q?=
 =?us-ascii?Q?roCfOqpiXpMh5t5P6fUwvMbGNktQq6ZB2gemA22R45V+SAf0dsEftW0sSICn?=
 =?us-ascii?Q?lM5qMFPnNTiTrtr4xgIkgVdD4IXjJd3wDcf0wPaNYjhzSx+2XsV+xHDGtq/Z?=
 =?us-ascii?Q?2bsioHjsWRXWA7dPYXRgQkygdImw/8UfIZ9HWKzd9VQB1HjlhO1h2jRVdcNZ?=
 =?us-ascii?Q?3WA4PRk7Ma1dxA3q8IyERe/FAbFweoxwuKm5aNJP9Hkrh0aoFdENT8MglSqo?=
 =?us-ascii?Q?mAM8CgKYXIY7qtA+xkXDSQeHnLFTLgkingw+ATVwMKNKmYJ5cMf8lOzBSE4U?=
 =?us-ascii?Q?NJV6qAsGaFXZad0LR79NIPmf17f0uM4Lv9oA2P0/NV9ObBmjsKxf4Lt71CFE?=
 =?us-ascii?Q?HazN9YEKTBbpc17Qa9zu+RIwQoFYtUVq3TwWW+pWE+LAL2dL6gQfNdN8DSpb?=
 =?us-ascii?Q?ewqP46lwp7FEu2FlxsQnP9lCc5WivTKgDQVaKoRP5uSeD5c97FPveedZBwyW?=
 =?us-ascii?Q?6iMY6ksWaHJpD9jqFOKxhZCR0yM1GucjepUC5cdqNI6sZk0+o+BSuIPYDLb7?=
 =?us-ascii?Q?NB2H55cKgLMUYlb66m86XYFeGOdPYTAT4UyBQJeJewYAeWtS/Nk1B1Y1ItlO?=
 =?us-ascii?Q?KvfwI1MJzn/E4W7ZEkYWMXYg8jj9HXji3EFnYecvRIFVvSvbv02OnkSWkNtr?=
 =?us-ascii?Q?gEe5uebUSki/N5yYEXyNSyzwwDyxSiPL7W+DON2EOCLPf0RioNbb97yVZK+H?=
 =?us-ascii?Q?u+u+107VGiWMUUt8FJGZcxfg9X4JrpE4H1iMzl6LVOuMgS3iVVjElFKbA1wM?=
 =?us-ascii?Q?8otCt7kdrYkOA3G5nuKzCFLClGXNQmTwz/xVVbHPaiMVyrz5d26NnT6XDJ3+?=
 =?us-ascii?Q?MQwgoeDnb4UzPb9k/HXUB7rwfwUqRcrwci0sABGuM1FFbBGcc6XRdqdSvort?=
 =?us-ascii?Q?8dmoO0UUNRkgcuwTmdrWxLPOtAC9JsczNa42UqpahvopBbnwMmHCDnyAwNwy?=
 =?us-ascii?Q?BIGTnwPUaBEJjDgLVjAYwh8qBlyg248zXkXIRnwwxO+xynb0CR+neGUtwY3q?=
 =?us-ascii?Q?WzgnwDYgXJ23CPIRR6kJ0zsQ5QEhFtryJ3mK6kVXrhhcoh3UgiAj6RWyEBvj?=
 =?us-ascii?Q?n20wphxsr0XhYI9ZH6eotds94DLU5s0JhOVWNqBNxPRvvcYzAF+JTTIGQB1g?=
 =?us-ascii?Q?MVbvftu7FvwT7t7lxx9bU/f72V9vX+4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <448B1B9533984D4D87C12BF5055224D9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5005.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c46db1e-522e-4842-ae6e-08da3fc65fef
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2022 09:50:47.1495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFuesg9ZZ4PENHJdAPlpqfTBuLRW8FhkXYbhrj6Yf5l9ctcAtTV5BXDE/V079a2ItjLZuALw/f+2BlayN/VRlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2677
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22-05-26 21:00:44, Jakub Kicinski wrote:
> On Wed, 25 May 2022 13:36:57 +0300 Viorel Suman (OSS) wrote:
> > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > index 73926006d319..6277d1b1d814 100644
> > --- a/drivers/net/phy/at803x.c
> > +++ b/drivers/net/phy/at803x.c
> > @@ -443,10 +443,10 @@ static int at803x_set_wol(struct phy_device *phyd=
ev,
> >  		AT803X_LOC_MAC_ADDR_0_15_OFFSET,
> >  	};
> > =20
> > -	if (!ndev)
> > -		return -ENODEV;
> > -
> >  	if (wol->wolopts & WAKE_MAGIC) {
> > +		if (!ndev)
> > +			return -ENODEV;
>=20
> Please move the ndev variable into the scope.
> It'll make it clear that it can't be used elsewhere
> in this function.

Thank you for review, done in v2.

>=20
> >  		mac =3D (const u8 *) ndev->dev_addr;
> > =20
> >  		if (!is_valid_ether_addr(mac))
> > @@ -857,6 +857,9 @@ static int at803x_probe(struct phy_device *phydev)
> >  	if (phydev->drv->phy_id =3D=3D ATH8031_PHY_ID) {
> >  		int ccr =3D phy_read(phydev, AT803X_REG_CHIP_CONFIG);
> >  		int mode_cfg;
> > +		struct ethtool_wolinfo wol =3D {
> > +			.wolopts =3D 0,
> > +		};
> > =20
> >  		if (ccr < 0)
> >  			goto err;
> > @@ -872,6 +875,13 @@ static int at803x_probe(struct phy_device *phydev)
> >  			priv->is_fiber =3D true;
> >  			break;
> >  		}
> > +
> > +		/* Disable WOL by default */
> > +		ret =3D at803x_set_wol(phydev, &wol);
> > +		if (ret < 0) {
> > +			phydev_err(phydev, "failed to disable WOL on probe: %d\n", ret);
> > +			return ret;
>=20
> Don't you need to goto err; here?

Missed err section indeed, thanks. Fixed in v2.

>=20
> > +		}
> >  	}
> > =20
> >  	return 0;=
