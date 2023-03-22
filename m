Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F40E6C553B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjCVT4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCVT4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:56:04 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2088.outbound.protection.outlook.com [40.107.6.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708B25A6CD;
        Wed, 22 Mar 2023 12:56:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNqnDq50324T2dxqjGLoJ22Of6Xc1IPxaJvbIxNLCM1soSoJ/hRAXPbYh5vlGJ4o5s/8pKwVXppXuvOj6KP5+G07SnDMJvzn4fwi8vnwZmgqqnIW+MRzjo0iaArL5q299z4P9tQRiT7CXbLvCTRqkAVsvO9TYHIxqzkDvQn4zsWwV78BUbDVtBxiT/39Uff5T7AILumnmvEKYG2748ot/byRvPqYEgS9dUhNt1LRrKMPluMB3M7ZNamMHilC8er3dTltmk8lRIasuL1v8gV2UBKzZP4nvT7DTf1m43/DZEcoSSc0U0e9Jk6lzP2X+ZMVtBMggHOb+Tzg76sC+CkOOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DVK0AewQLk9Y0DgQEvYYg2VSdAyMVdWAIOdXhv45ELI=;
 b=UnSj3qHnH+46btXbhddY823ylkyaAvY970l4csBUVLEZo7JU6s6+BciGjpCo/jrZ9iNp8duHqcrpoRVxprNpRtVfQV3Mfov0PQrg1aAKbJHTQI6lA6PWQ0wRAbsGuY1vmBSDH2TFk5IleIvpRQd1t6U4kCDw9t/VXVCX+V8rVMu38JtsPHbNX5t728f0i3sAYclhx5Kp9czcMfIMPqDbO4Y4ad6In+PFr9TvXTWYc0K4w1JCdjDpUQZMQLKSGzl5Gvm9ky9gvjtrt5iNj/OwXG0zPACraYfpelTVt1HuT+t0GPRFK64rUeEMhP92Xxo8ErOVNh2+u0zH+ZgolEY3Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DVK0AewQLk9Y0DgQEvYYg2VSdAyMVdWAIOdXhv45ELI=;
 b=Jl/BMLm1y02+aOid0YbW7GYKH3dg+EXYEF8D23K/Y3fGSbid9EP+xW7X34ifdlY88HNbhUHSlvjRXKqU/Hj2jHJLcKVlVQSWhW4yseBHHAy0UCWJmSKcC3w0CBrm+l4Jyr/0gNQ9J6AGjo26n6iDu1eAN/TpCpgqaQVZUsywlg0=
Received: from AM0PR04MB6289.eurprd04.prod.outlook.com (2603:10a6:208:145::23)
 by AS8PR04MB8417.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:55:57 +0000
Received: from AM0PR04MB6289.eurprd04.prod.outlook.com
 ([fe80::8516:ebc7:c128:e69d]) by AM0PR04MB6289.eurprd04.prod.outlook.com
 ([fe80::8516:ebc7:c128:e69d%6]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 19:55:57 +0000
From:   Leo Li <leoyang.li@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        David Bauer <mail@david-bauer.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viorel Suman <viorel.suman@nxp.com>,
        Wei Fang <wei.fang@nxp.com>
Subject: RE: [PATCH RESEND v2 1/2] net: phy: at803x: fix the wol setting
 functions
Thread-Topic: [PATCH RESEND v2 1/2] net: phy: at803x: fix the wol setting
 functions
Thread-Index: AQHZS+oraZhWfsrNC0eCkD8ptv8rDq7p2YCAgB1+16A=
Date:   Wed, 22 Mar 2023 19:55:56 +0000
Message-ID: <AM0PR04MB6289A4E1DA8BEAA065714B328F869@AM0PR04MB6289.eurprd04.prod.outlook.com>
References: <20230301030126.18494-1-leoyang.li@nxp.com>
 <20230303172847.202fa96e@kernel.org>
In-Reply-To: <20230303172847.202fa96e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB6289:EE_|AS8PR04MB8417:EE_
x-ms-office365-filtering-correlation-id: af0513af-bd41-4eae-06a1-08db2b0f73b9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YwdLq8vRl3FMr4mLzSWizeWlGSzStnQ7zKxRglOM227ycXicnevwcSlBQ6D+3auyeJS9u7i1ALtGHTiPV5H8lJ8khD6JMWvwew75VxDJDyDqZHBA9YjHZ1BLCe+cwjioQi4wc5vzAl1SU5N4CvLKUVTqn8Bm7Z8578bKDtdNISoBITA/w4O0gSKVYz0lcvuYBDimmrldbhlZjH5K6d8+O7MJqzlv7lUdC8Np1tGY4/jzvabtjhRsRgGuk1mRnacyA7okPSS3YGN28q230fy5VV65oSGhx48mwuRUt+xdCLMSRRJkYx7rflnah0klhyt2343/olA6V2Kz3gvqfJAJfKdQCIrNPfdrW/l9vJWqjcq2RE7eZi59MwuDqOzPgjN9AAQ6eIyVkhbXP6DBsOGPfcyUyeEl2G3XCqLj3moOqy7IQ1ySGb85LEEFEYs5turMiZa6r4hben0yO884xp268Ne9e18QknTfvahXVM/89FA3zH3A2ES5ofdOnK9rHtA1IJicPLYxD/81yqwwbuBmJGgT9hBeCo338UfaoyqR0kIB987ogdAgfSFmxejoLXs4QBYjfnVjyWZQYD+jWo7ezTW4Dv0bS+SDodtZiAXYelznVdk1WruoefHtMtAbLOt+LxG8297IFGF+FbaSKfH/Khz8PYf59dHrTtJtV4Kmg7KLi4qGhxv2RVvaUv7R8Qk07Rk/kXpxwi5ALGyuvX7QPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6289.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199018)(7696005)(54906003)(55016003)(86362001)(38070700005)(71200400001)(38100700002)(122000001)(26005)(8936002)(66476007)(66556008)(64756008)(8676002)(2906002)(66446008)(4326008)(6916009)(66946007)(52536014)(41300700001)(76116006)(5660300002)(33656002)(9686003)(55236004)(478600001)(316002)(6506007)(53546011)(186003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NOHjnuSocx92WF56coeQA6v6mxFPBJKq2RcOnIIiQUuTjpIBloyok1uNBts8?=
 =?us-ascii?Q?xvvykIBR3BQ6EAdDmcE5tcCBPXUCXeDEkd2lfQRDgP44OrpnskmAfvEOe6aI?=
 =?us-ascii?Q?TjPx0Pl3tfafWPVwyCiLICMp7PQPIOxIsKPtHLBOfZpOnh0T3wUiw4LzJ8Wb?=
 =?us-ascii?Q?FlM46X80pUn1QbCuvUIFslCCYyM+0CS/V6tKjl8Ro7ENNJZFRjeG9iEiQj6J?=
 =?us-ascii?Q?TbB7Z1g09uXdFntUiBKIMWil75eyxHOBmX1jKFYQJ8+SJhfopIqYN/3Zcnyd?=
 =?us-ascii?Q?+b5HTaPsYVaJESHULQqY8BN8ZeKdnTG8TrUqvl3FrNLb/rTzi83DP+uiKE9O?=
 =?us-ascii?Q?AlMA5LmxfsN+fWNEmG2mhQ5blGnMJKpE23s69W11L3MGGgZ12YagKmvr0F0w?=
 =?us-ascii?Q?sKf3oIN4cHRVCoTeKLbwhaIjhMrm0UyNDAaV46mOOu2qSHFw/VPMZ8RgaAHU?=
 =?us-ascii?Q?Yg/2q123iqkm4F9ST4PzWJqc4EJlF/M+hiHAN90ZdY7zmn9+x1jMrofaKW7Y?=
 =?us-ascii?Q?FNKYkgrKnVwT1adB7Ak1xVDqsENQvGxqo2rIxX8z6OL7xTKYn7brlkp/Iafr?=
 =?us-ascii?Q?L9avt48fVmpMrBuRwIt6xifw73u1tZXgQrTTJB9L8uLkuL34HBGXwAwNtCWW?=
 =?us-ascii?Q?iUoHeiSERQ9rQZbLXeWwCnFxHZ7NwP3jIXIk1diozTFEc8MriZTaBmpaN/iK?=
 =?us-ascii?Q?hDWVp4NXSFJ7YQWSustNT4pRsf1gU+5OKWMYENucTqpPYm5189xa10qhnIoy?=
 =?us-ascii?Q?68H354gHL9QEXpi6BD60iwoCpLInSQ8gH9lIwi9eRUJV5i5b6rYi5DzCfykP?=
 =?us-ascii?Q?7jsjBVt5Q38XCWd4FnqEBjqoLOoMEutd+YcR7Fws4518xI96ukF6pVr0ScH9?=
 =?us-ascii?Q?ze77Zh7XQ2eO/xN6nbdAmoz9E0yK72uQhdmGlYlIWskjjy9MoShQLMBpWjvG?=
 =?us-ascii?Q?pSONnvwGl3lRomcVQsZRIaiwt0CntGtzAHup5HZ5Sq6rj4KEthDuDZIgFC1b?=
 =?us-ascii?Q?tH1k/NWbr4OHsG+aIU85pGH27yICqTjEk0I+r9D6EhT1/fIPafRESirtzISE?=
 =?us-ascii?Q?t/rywsuXT+bhln/xyh/F7H8MIUiEvcKLrceTtbDWHdemMXIwAZqtJMrPExn1?=
 =?us-ascii?Q?w8t/7WdKYjqtMQbYYjXfiVdmLHzBVn8rqI11l5zwSVFbcj2FzaKFRiw4IN+w?=
 =?us-ascii?Q?U0l+h9c96ZLedBljfeR81ewYRu7Sverlh2aF+cht2WeDl7l6JYRN2+u9vMHq?=
 =?us-ascii?Q?B99pXHznSqKvGJKn6HM9OUolTcCVRmbQiVblJ4qIuc3T3cRPQdAbo/wl2Efp?=
 =?us-ascii?Q?96UeWZozRNN8ndyuUpHA2vR/nkW+kCec0GuHfuXoUBpkRWvDUWFwPC3ESBbr?=
 =?us-ascii?Q?dDSmoVtlPMjgsKj+THQuGsZpUXGAxXPyfdLDIeGfzqBtwlnKAZEAlXThMY3w?=
 =?us-ascii?Q?pCd9OmZT77QHLAtbi8S+vGZDdeZJT9Te9CiFzuCKslGEDqWMpezbOSxwlPkb?=
 =?us-ascii?Q?QXp0zR2vODUE9FnkBWqveGXIBocA8FHoq5YFXIy7mYhn6tHn1gPCKiXW2Ssx?=
 =?us-ascii?Q?nmk2s/RTFJtGNPxg6pN6hTZDt2bt12PVInfXOirA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6289.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af0513af-bd41-4eae-06a1-08db2b0f73b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 19:55:56.8441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/bXaJpSscwa4bqb6XJRLaI9/6J4Y77w67sVK6qFmEA0BTNB61PJ6FdrFb00lv2OAg3AxITzH9LJ5gLQ8Mv6hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8417
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, March 3, 2023 7:29 PM
> To: Leo Li <leoyang.li@nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit
> <hkallweit1@gmail.com>; Russell King <linux@armlinux.org.uk>; David S .
> Miller <davem@davemloft.net>; David Bauer <mail@david-bauer.net>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Viorel Suman
> <viorel.suman@nxp.com>; Wei Fang <wei.fang@nxp.com>
> Subject: Re: [PATCH RESEND v2 1/2] net: phy: at803x: fix the wol setting
> functions
>=20
> On Tue, 28 Feb 2023 21:01:25 -0600 Li Yang wrote:
> > In 7beecaf7d507 ("net: phy: at803x: improve the WOL feature"), it
> > seems not correct to use a wol_en bit in a 1588 Control Register which
> > is only available on AR8031/AR8033(share the same phy_id) to determine
> > if WoL is enabled.  Change it back to use AT803X_INTR_ENABLE_WOL for
> > determining the WoL status which is applicable on all chips supporting
> > wol. Also update the at803x_set_wol() function to only update the 1588
> > register on chips having it.  After this change, disabling wol at
> > probe from d7cd5e06c9dd ("net: phy: at803x: disable WOL at probe") is
> > no longer needed.  So that part is removed.
> >
> > Fixes: 7beecaf7d507b ("net: phy: at803x: improve the WOL feature")
>=20
> Given the fixes tag Luo Jie <luoj@codeaurora.org> should be CCed.

Sorry for the late response, I missed this email.  I tried to cc him, but t=
he email bounced.

>=20
> > Signed-off-by: Li Yang <leoyang.li@nxp.com>
> > Reviewed-by: Viorel Suman <viorel.suman@nxp.com>
> > Reviewed-by: Wei Fang <wei.fang@nxp.com>
> > ---
> >  drivers/net/phy/at803x.c | 40
> > ++++++++++++++++------------------------
> >  1 file changed, 16 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c index
> > 22f4458274aa..2102279b3964 100644
> > --- a/drivers/net/phy/at803x.c
> > +++ b/drivers/net/phy/at803x.c
> > @@ -461,21 +461,25 @@ static int at803x_set_wol(struct phy_device
> *phydev,
> >  			phy_write_mmd(phydev, MDIO_MMD_PCS,
> offsets[i],
> >  				      mac[(i * 2) + 1] | (mac[(i * 2)] << 8));
> >
> > -		/* Enable WOL function */
> > -		ret =3D phy_modify_mmd(phydev, MDIO_MMD_PCS,
> AT803X_PHY_MMD3_WOL_CTRL,
> > -				0, AT803X_WOL_EN);
> > -		if (ret)
> > -			return ret;
> > +		/* Enable WOL function for 1588 */
> > +		if (phydev->drv->phy_id =3D=3D ATH8031_PHY_ID) {
> > +			ret =3D phy_modify_mmd(phydev, MDIO_MMD_PCS,
> > +AT803X_PHY_MMD3_WOL_CTRL,
>=20
> This line is now too long, unless there is a good reason please stick to =
the 80
> char maximum.
>=20
> > +					0, AT803X_WOL_EN);
>=20
> while at it please fix the alignment, the continuation line should start =
under
> phydev (checkpatch will tell you)
>=20
> > +			if (ret)
> > +				return ret;
> > +		}
> >  		/* Enable WOL interrupt */
> >  		ret =3D phy_modify(phydev, AT803X_INTR_ENABLE, 0,
> AT803X_INTR_ENABLE_WOL);
> >  		if (ret)
> >  			return ret;
> >  	} else {
> > -		/* Disable WoL function */
> > -		ret =3D phy_modify_mmd(phydev, MDIO_MMD_PCS,
> AT803X_PHY_MMD3_WOL_CTRL,
> > -				AT803X_WOL_EN, 0);
> > -		if (ret)
> > -			return ret;
> > +		/* Disable WoL function for 1588 */
> > +		if (phydev->drv->phy_id =3D=3D ATH8031_PHY_ID) {
> > +			ret =3D phy_modify_mmd(phydev, MDIO_MMD_PCS,
> AT803X_PHY_MMD3_WOL_CTRL,
> > +					AT803X_WOL_EN, 0);
>=20
> same comments as above
>=20
> > +			if (ret)
> > +				return ret;
> > +		}
> >  		/* Disable WOL interrupt */
> >  		ret =3D phy_modify(phydev, AT803X_INTR_ENABLE,
> AT803X_INTR_ENABLE_WOL, 0);
> >  		if (ret)
> > @@ -510,11 +514,8 @@ static void at803x_get_wol(struct phy_device
> *phydev,
> >  	wol->supported =3D WAKE_MAGIC;
> >  	wol->wolopts =3D 0;
> >
> > -	value =3D phy_read_mmd(phydev, MDIO_MMD_PCS,
> AT803X_PHY_MMD3_WOL_CTRL);
> > -	if (value < 0)
> > -		return;
> > -
> > -	if (value & AT803X_WOL_EN)
> > +	value =3D phy_read(phydev, AT803X_INTR_ENABLE);
>=20
> Does phy_read() never fail? Why remove the error checking?
>=20
> > +	if (value & AT803X_INTR_ENABLE_WOL)
> >  		wol->wolopts |=3D WAKE_MAGIC;
> >  }
> >

