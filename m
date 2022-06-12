Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBFA547B94
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 20:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiFLSsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 14:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233918AbiFLSrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 14:47:51 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCAE396A7
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 11:47:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExjV6sWX2zYLMi76+oqznwNvFVTbOcUMxLayKO1xqCJWhlqyMZRuJSpbuT1Bw/f0FpA0hrblgNBuhElu+PNGEUpzdP0wJp0zRZKvoUsw0N2zWTcOXJ1qbjCSPzTod5huv3N2n0Boc/To/jpj9/rIrFFQrSZmG9wgk59+d0UQwRi4mbRUnw5xzNlyTQZRoIQDknPQhC/FVx0oYXzqRiQYKFpsKnw6eK8jksqKArnYIE0sHMmns0pAp0v9mBmKo8IofFS5buvln3QgSzZv1oUV/WHk5JuNndZMdXZIs5JVBcqY6hYUNTgt6wnQ0EOvBNE1kVG/FDHTGpvIeZcMmhnykQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W1PlEQ13rv/BsiCT3/ti+U/5TtiZc+h307lBfPyhBsM=;
 b=EJlP+21grvxeOewKuw/VLrqFd3zRPkJan6zzuIZAtHfabCABJm7jXG0rmK2MQgofEfWEqTsl2fvzrVP9kh29jRAJu6/tc6RS4YeDqtl7U+MK4+ainLjwcckB7Wy9x7OwOQMv/sLJIQeCeZquHOc6wa7bwralyScvFms28+Hsz1lPTdZbB4vogxq9oocwLRKBDoif/A4zznH4a3fiCVhBJFeE3FL7Y5MkNPH67782lSnHabxyBwKo8P4Yhf2xiYpEA+q6NOeYxeDPW3NA0jbU7ATdvNtIF0lKGm+G3MrDn+wqtFvkkWXSb6cqFQTQh9N0Dus3rMd7hlpG2EyIcc4XWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1PlEQ13rv/BsiCT3/ti+U/5TtiZc+h307lBfPyhBsM=;
 b=ReATT9Vau2GVxSxzXJlcXY3SYXXsoR3mC34nPfnou7sIILFNFFa4Q6d3zybW9HwGca/WmXUTHLzfqtgHW3sKVmpIOTb9Rd43kbWpVOJS9Hbi3iZHpwbKBurBUdWgXDmqZm54XIBBBewB+0PSb5hXk4XW42X6ukxL5/bBAC6AhR0=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by HE1PR0401MB2394.eurprd04.prod.outlook.com (2603:10a6:3:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19; Sun, 12 Jun
 2022 18:47:45 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1%6]) with mapi id 15.20.5332.020; Sun, 12 Jun 2022
 18:47:45 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ondrej Spacek <ondrej.spacek@nxp.com>
Subject: RE: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G are
 not advertised
Thread-Topic: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G
 are not advertised
Thread-Index: AQHYfKXSil1P6dug1U26HZopRldC861KTn+AgAAtI7CAAF7XgIABPoUg
Date:   Sun, 12 Jun 2022 18:47:45 +0000
Message-ID: <AM9PR04MB8397DE1463E47F5AF8574A5F96A89@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220610084037.7625-1-claudiu.manoil@nxp.com>
 <YqSt5Rysq110xpA3@lunn.ch>
 <AM9PR04MB8397DF04A87E32E6B7E690E096A99@AM9PR04MB8397.eurprd04.prod.outlook.com>
 <YqUjUQLOHUo55egO@lunn.ch>
In-Reply-To: <YqUjUQLOHUo55egO@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aae8edb4-4f68-4ac7-01a2-08da4ca409ed
x-ms-traffictypediagnostic: HE1PR0401MB2394:EE_
x-microsoft-antispam-prvs: <HE1PR0401MB2394EC6877AB6BC2013B3B0696A89@HE1PR0401MB2394.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mkg8OrWD0PPmRgEGbyaEWN28RbsvOuOy6o3w0j+Coxi9C3zNz7yIGNuiQHiV6GTx/E3iqPdjUIGzlsEwm4Kw5M8pN3H8ohDIA0pdbllNKBwpioneJhYSn5H0Ei5Mhuyn2eRZSPZVGMFWVS0VHGWGgdjYes3JJX4f9c9+x2VC0BVsN616VhEjjz9rEIjacPiB8XZ4W0KUWTURBRrasjTJBubXkyFfx+dzxzL75vWKxDaNxPCV7EhkS2lsrPFgFOqB2tMRf/A6ZBOtUGwfitzgNEVoSJyM2YEq17kzDFrNugeYwNa6WfMx5Bzy6dxEGD5brv4z7n94ngFgK4hv0/4VzNJYGqPJEk36Mkjec4wK9eV5RQA9ByAKDFU/zvK/Q83sQJs5UDYNAVLGEE9kH41MV7BV52C5eH5T/C9yLJS4EcLXexqvemv8uC46WD0lOppjIw6oZTEXjC0fm0yx7apWcfLYKDzO3AaByYxDTr7GQVCZSa5vO3XFsLIxwDWOIJkS5vAXvIuFSsnvQ0KIM34+EdneUFk/AgKLztW8Ahw9HWt/gXxbo5HegeeJ9G8iOxTI39q8zd46nEisfKxE6+dYzNn11UXdK7aAHeMXZX/kvgtlwCzLrbVp8urNkI8rqBN4IPPNTQ79gBOZ3r20Fh15auLNX1jnOZGUXtoeqOWivMvpREMHGFCH4ZzUlPeZ205ih/HEIdKyNwzRSoETP6XsNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(8676002)(38100700002)(122000001)(6506007)(52536014)(9686003)(26005)(8936002)(66446008)(64756008)(38070700005)(66476007)(76116006)(54906003)(66946007)(66556008)(316002)(6916009)(7696005)(83380400001)(71200400001)(33656002)(186003)(55236004)(508600001)(53546011)(4326008)(2906002)(55016003)(86362001)(5660300002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lTQBQVxrlHTjjyBqoexN4R1GxHK3CXT4zApuAgS9af7gu0djdPYyNyaLTdhs?=
 =?us-ascii?Q?yTDnLDnTlD7HiwhbNiTWY4WwCoizUqWHPQ6PSboKaHBtHab3gfBvlsS8vlEP?=
 =?us-ascii?Q?x7QlAchQCNtFjtqyBAy+XHgsi7J9msxa6avdmwjZZEstS7txA48EtjI7s+QG?=
 =?us-ascii?Q?wu/LCTUjl9bvQl6V1NfSAV0S+nrPRpgXBNF+2sCIhS/jKUyy/nT2x4Rs1DYW?=
 =?us-ascii?Q?mN2Ee/F3e5U0MiY7/5ktcEWFNk1KMHFJ5aUd2xG0RUAcHy70TQM4lMDZP+9p?=
 =?us-ascii?Q?8jjV0SRNLgHUt+9bD7jR+QzXTEZl8GxqawtWnV6RmVL2vtBlu1Ot2eUQtScf?=
 =?us-ascii?Q?FrxHVci5otZXcCla3N2DDL4TMS7JbmQIHDCFpIcvZx83QZH1PhKJ1c+JZgfd?=
 =?us-ascii?Q?Z/Fs/VIbEskuKxhFv6HI48LhUi3Xr+wMiQ6wdRyxhAqX+VXb8Le1OH7Ccdub?=
 =?us-ascii?Q?c5L13gohWYkwff1evtwMeozSk1jDxwFKUWrC1P0H6yeLL2nimezPmdYorU6o?=
 =?us-ascii?Q?EWBXZzacXVp/nFrmt9KhviU2M2gd1sps8SISOAODwGFpoYkmQYH35VvzT+x2?=
 =?us-ascii?Q?wZLKmeCmuT/ngM8W/ndneqkkFmLMyMGDsJhLxhn4DlzXOpeAiSHRCwL+ks7s?=
 =?us-ascii?Q?E6VOzCV1NFld2l/O3PqmUpP/uy3eiWZeO4gFzGTJ8xiezO6oHL7VUt5oStO5?=
 =?us-ascii?Q?7BNfL3/4rHKRhzxBGr8m+2GWaZ14vENSxjz4JOkXpf+8DQpX2Dd2pSvkqOQg?=
 =?us-ascii?Q?2wHtvpWl3iro128U+LTFHycM6Qfb5TLlLO4vIdw6vcQsFD2/B7q1yxiasE5O?=
 =?us-ascii?Q?qzkxtvtvvXS//plqgRi46iIz7zPBrQ3I/epMhsSlM2S/3TWet3M4q+5/3B4m?=
 =?us-ascii?Q?8HszXR1c0Lbn2YDzvE4IDoFv1z179grRM+d+SG4Dniq8DH0CB6RSrvlavEbi?=
 =?us-ascii?Q?SSMv/Gmaflfsq+R/bybp7uRecy6wh5SZ9znekFw7+wv0jHWSdGOX8qU8BcWd?=
 =?us-ascii?Q?TRTO8eTT20DpN69AJOHf1M51ybqQWh3V1Kpc+07i4CE2wT7o0/ufADfQxDv1?=
 =?us-ascii?Q?uuo+4OtMNwtiA3muqb7LXV4NK1fLaX2+gfwxOX7qmQAcoY83o7566//XgLnf?=
 =?us-ascii?Q?5dXHSUoZfTsLsNhm57+O6jU3HihKdszLj73vomy9w7hGikOyPKpP2oo64Ax3?=
 =?us-ascii?Q?TVPA16FByqEpmB/0YI01MUl37xv0CETv1mXIvdd29E4n7MsMu7Uw/iFczKSs?=
 =?us-ascii?Q?pdS5Hl0FrMhEhzDdtHr7qB86cjYqAhzs5NNLJ5lM4rFhhnGTNC/9rJ+McdYE?=
 =?us-ascii?Q?jvCAJzCK6RGIge+78yl9BAFJpV1ofmBOr574Gc12aKNLCVkXOLzWTJP1giVY?=
 =?us-ascii?Q?42KKksP5fRC6tXNEtFmGM78P9cA9LT1Wo3lMuD4vwchboMCVRRw6psryO2oS?=
 =?us-ascii?Q?A2iODkn/kvCKDoPvz960g/8IRJbq224l4uN9jsI4bdp73A/leXuQK7s0yPUe?=
 =?us-ascii?Q?wwxaR3WQ38xKcPKTMh9Zgt1khrwpOjjxqUml6EgcAv5o2qdoc9j78VhOZrEB?=
 =?us-ascii?Q?qIq34pK1hiS6+owcmlCSSgqwzhwK0eGn42RdFg6xImFdmpi05NsMpbbTxvkZ?=
 =?us-ascii?Q?iIRi4BD4PJienC57L0J6PZqx632sF6eCGp1koL3bf3y2Xyailm9bNe2HmZA9?=
 =?us-ascii?Q?BXf19t3Ls1A8FnA4fc6zzHhUeQnhzIikSzlotWCrzw8fVJC3cQhy/R3DJT7g?=
 =?us-ascii?Q?nWoIH3yO/w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aae8edb4-4f68-4ac7-01a2-08da4ca409ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2022 18:47:45.0908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KS9p9G1G0AzNB4ahzR5fZO/h5To4otnpV1rIEpEQM2HYWsyuZ+pD8xiTfrq0ajgATuMLQ7Sf9Nfxalf2VX5E7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0401MB2394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, June 12, 2022 2:21 AM
> To: Claudiu Manoil <claudiu.manoil@nxp.com>
[...]
> Subject: Re: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1=
G are
> not advertised
>=20
> On Sat, Jun 11, 2022 at 06:13:12PM +0000, Claudiu Manoil wrote:
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Saturday, June 11, 2022 6:00 PM
> > [...]
> > > Subject: Re: [PATCH, net] phy: aquantia: Fix AN when higher speeds th=
an 1G are
> > > not advertised
> > >
> > > On Fri, Jun 10, 2022 at 11:40:37AM +0300, Claudiu Manoil wrote:
> > > > Even when the eth port is resticted to work with speeds not higher =
than 1G,
> > > > and so the eth driver is requesting the phy (via phylink) to advert=
ise up
> > > > to 1000BASET support, the aquantia phy device is still advertising =
for 2.5G
> > > > and 5G speeds.
> > > > Clear these advertising defaults when requested.
> > >
> > > Hi Claudiu
> > >
> > > genphy_c45_an_config_aneg(phydev) is called in aqr_config_aneg, which
> > > should set/clear MDIO_AN_10GBT_CTRL_ADV5G and
> > > MDIO_AN_10GBT_CTRL_ADV2_5G. Does the aQuantia PHY not have these bits=
?
> > >
> >
> > Hi Andrew,
> >
> > Apparently it's not enough to clear the 7.20h register (aka MDIO_AN_10G=
BT_CTRL)
> > to stop AQR advertising for higher speeds, otherwise I wouldn't have bo=
thered with
> > the patch.
>=20
> I'm just trying to ensure we are not papering over a crack. I wanted
> to eliminate the possibility of a bug in that code which is changing
> 7.20h. If the datasheet for the aquantia states those bits are not
> used, then this patch is fine. If on the other hand the datasheet says
> 7.20 can be used to change the advertisement, we should investigate
> further what is really going on.
>=20

I understand the situation is not ideal. What I could do is to provide some
logs showing that writing the correct configuration to 7.20h does not yield
the desired result, to have some sort of detailed evidence about the issue.
But I cannot do that until Tuesday at the earliest.
As for documentation, there's an App Note about configuring advertising
via the vendor specific 0xC400 reg but I don't think it's public. Not sure =
if
we can use that.
Meanwhile, it would be great if you or someone else could confirm the
issue on a different platform.

Thanks.
