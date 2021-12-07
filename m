Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F4246BABE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhLGMO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:14:56 -0500
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:26401
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231760AbhLGMOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 07:14:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYqfcjqC2Cdm98UL7ARNrzINZHtZW+HK+crbnrTpjDOfKQJRvhhyyJSCme0YgomVPl49N0B5Jer28AgWJ1ExxJKyxP49AZsZAMkRpHq9pTM6NCrDtWfQjUZg8VqPRGImeNfzIYul59YT17rzJiATDf2RbzMoZKJ3UmwJedTWF+Z9Zkp1ok2k4mrrp5xP1qn+Cs83e2Vzd2IkS78HauyYwFZZ91pJl6cHaTm0ZjJy55F69/DFcjWj2KEYyXYLExYtLsCOe/WkrDsSH9MQrgEhGczCDWebuX+pmhy2PK34Ll1uCoGdGEuPw0jPzsw3Kry6BSJn+c2Zpd3OxjhXQ5+B7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzx6OOHh/SEuPw3H/35kHhjjrPj0c4fVjwWukRDjHog=;
 b=jGnkupQyZOjQXgeDO3rqx/EtqCC3jiFxKX/f2uqD9c/LcJrLlZKjQwKFaWsTYAOxXoIoNmnu9/Lxy45lQctMZV+Tr4zVN8DgS3gl5CxHbEE8whb8ALad+ovIvRrCshaY2gRdWe31h0vwfOVL4jEVRqsP4laxTm3rICIjgP/3f2IrL2eQW6xK6KHqdXrM1Wxn8BaRxyaouxs7jCfCSB+9IMLXpUXXsP8hW6fINSNr/I4tM/uJc3nzFzlaCKm8l4kusQRp7/n3dFiuIfDiRHAg8EWoOnD147nWu6ZhHnxtRAmQHCIyXxgv4dw40X/J4Mrx5Hr0rlhnZoEjIVPZpT7mFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzx6OOHh/SEuPw3H/35kHhjjrPj0c4fVjwWukRDjHog=;
 b=mJC7Fe8Fxuwvwn7gXxr2WFaL+w0EVQWOt1wkwrgEEKBdz7USzIB6d1yVYfxAESOpKxte2gchG+c265EQyISFrAyD1dzkGp+NfjnfsPIoK5pl8oRkRb09zYccQkjcbvWu0mju1MwW7jfNZ8fzpKHvq8zIKmXcjpdKBi5ojeIAKqI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 12:11:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 12:11:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Thread-Topic: [PATCH v4 net-next 5/5] net: mscc: ocelot: expose ocelot wm
 functions
Thread-Index: AQHX6TzcVrh3MXhiPEioPLXtrf7S+6wmTGwAgACh6QCAAAZIgA==
Date:   Tue, 7 Dec 2021 12:11:22 +0000
Message-ID: <20211207121121.baoi23nxiitfshdk@skbuf>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
 <20211204182858.1052710-6-colin.foster@in-advantage.com>
 <20211206180922.1efe4e51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <Ya9KJAYEypSs6+dO@shell.armlinux.org.uk>
In-Reply-To: <Ya9KJAYEypSs6+dO@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d8f2144-f775-441d-10dd-08d9b97aaef2
x-ms-traffictypediagnostic: VI1PR0401MB2687:EE_
x-microsoft-antispam-prvs: <VI1PR0401MB2687F11BB0641E1D6F1181B8E06E9@VI1PR0401MB2687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gd1M06wcWNr0yLwHF6QAm6Rb2g3kAv/s5f4W/7YxiBknrwx5bQjsRcIDmC4w+8B/UKVMbSC0PakBvleu66Zy+qfbJZp/UF1tksBt3SdBIDY+N3p0NAxTXuZsdQ5sj/up5iRVuZHrC+uUnPbiq26IQ0fp8523Wixq4N6RsH6EZ3aj3bolnwad6hHktLvmebZatFvwMhwq7xcEBbm13hVPLp3QERqM7mB8ARH4+lWfv8DLTT2BRpOUoY1ug1B4bIfpHODtn5/rp0RhS9xPEMWpAb83+XRzyhVfUpDwxz0aIB4xA+PdXRs0MnEyVssBYgeTQnj5bvOdf8IOok//LsVXREA5QSdiaeZ8YO8j3N1sa3shlRVqEh5wnpckB2iVF0r7pAo41pIZBKR6BncxhPUBCyG2T9CCifydV9i4t4Dh5Z0LZqh21y1jFxF5XUeYs1sBBj+y0WhmKFxqgYi/T/LSDPcuVcqpegNkGbXiD4BIC7VEBkpfMkPieQeggYIg5Mo7gAWnA/FtyYP1Nl3Okj4VvP4XkAnJqALIn6kkV+j9JuZI0899aC8KXxDHYWGHVfdcxEus20myzOG1MNYL92+qNmtxuC2z/e8nsCRBiwklc900FNvW2nvpjQdwVSFlkW/dtZi2NMnxuIAcAUbfElqESetp9Ro8WzTAchLfw266iY1eUIlCjXPBHIstwvvphA0lPgvOpMBuyMzPuUeGlLFKXRZG9sj+gpY3XlUMqlb+avNbkQqHhDX27LJUz8bw5NaFbyvxR0+iG9SNHb6GTZjLPc7Pzs2cTbhHPzF4CAElLuc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(316002)(4326008)(8676002)(8936002)(66446008)(1076003)(66556008)(26005)(66946007)(66476007)(5660300002)(64756008)(54906003)(86362001)(44832011)(6506007)(91956017)(6486002)(9686003)(7416002)(508600001)(122000001)(2906002)(966005)(71200400001)(186003)(6916009)(38100700002)(6512007)(76116006)(33716001)(83380400001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9Sl3IILnwCjF3GF7aOtmyMtF/ODgckZH4yRQHp9s6HjsfVvbkcWp3USzuxxn?=
 =?us-ascii?Q?Ym0LYKv9vpoDl0J9vu2B1jCvjH7aVnmzI35dBq1jQdT5Sue6KMWI5vE5lcGV?=
 =?us-ascii?Q?+HfF0G0xF/PgCXVw5ni3xL/+vk2scZ8WeIjo1N8opS658RB53B+LO9b37pYL?=
 =?us-ascii?Q?4OGmLrGvfB5oTE01EuCPPWaMPgoniZcUT5nEnWgj6iz3Gphz1U8KjfFQ4III?=
 =?us-ascii?Q?PXm7nnrE5NjjC6usBt6CwE8dfMOcWypwJMXy+h1ADBqwBiGlGUJLjQKpbVvO?=
 =?us-ascii?Q?UnehOHoR5Jv9aBHipJOySGZfApGtmKyUfljBqHkJDywvul+fkePoAwZrXSpB?=
 =?us-ascii?Q?bJtJywOEErI3nJra5k8yteF0HCxHXEWd1YRf5OTws/WV0XqZrROiD8A933qT?=
 =?us-ascii?Q?h/pVTTv4PvkT1mmjK301sLYc+piUPFX7SAOEAccybyZ0gXU0Epf/R5mkcNnO?=
 =?us-ascii?Q?R8RBOeFV7w9haSFY+kqobV+AH5KZUKKegBAXDSaMmb5qoqi077wy/VRosQhh?=
 =?us-ascii?Q?aL0qTtzSDiUtrXgxcj0nWONNtJ4vIrJWzpVrE9unRsboj0PEzIQDrWEhXsH4?=
 =?us-ascii?Q?IDpHJu7uWr332DEFzTnT0WhZaYMH9rc0BZcdR3DfEoNZdlFHYy0i+XfG/Fo8?=
 =?us-ascii?Q?P0QFI2QUctm0ILnph0cRr/jOJIa+4MVO43EVkebuIQ3VFXLf9eAqOX8SpmYG?=
 =?us-ascii?Q?yxh0y6dDvfbXuzaSu1Rm8nVgQLT0tkr1F6UsmsxkWJm7HQiwEFPlWPjXtvzU?=
 =?us-ascii?Q?lm2zrxH2ZgEmrD9qGm/DdwCnATOISFLsX5/yvV86aOcy4EarV2bGNWqCbLRB?=
 =?us-ascii?Q?gC4iPQ7sPvvi+N2GgCmrkdKbU1O9ZoRfSARFTxiNfooaXoS8T80xwODVxYOn?=
 =?us-ascii?Q?3krxSNjAj9ptZk9gjgeQDBozIDAZtAq0WY4Fl93lPbh2cIqEqAgTlS5bFL2e?=
 =?us-ascii?Q?wOZR9wRO4+JU9p4W9bBuCo58zrRlOKOOhWXamSDpo/GK4vct6cf8lT0osIM0?=
 =?us-ascii?Q?h+26gLD2DzC4lQTTFX+NuDbsEcr5s93uNRnKCdMNAij4KYE0xFVLethXRAuF?=
 =?us-ascii?Q?4vp7bY5s1YM/toQrxdXCoD2lVD41bmaAYqqpMxqX4R+QaTzsoi3x6+TZN/92?=
 =?us-ascii?Q?1YHCYqj1U0Z6vpFyigyX2aC09QSKJzraVJOZjl2jhGrRCNeBoMF0SZAw6KKc?=
 =?us-ascii?Q?Xp2HNQjR/MLgsOvP+/JqU8xdeekjmMeEqaRUbINzZzmaaOix71MeSFHJBMrO?=
 =?us-ascii?Q?7oXbF7rQFfh78FmZmrEtfyWwtE5AWc/jXBRLYexzorTBGHiD8DNQpv+BOzg4?=
 =?us-ascii?Q?TZCviiPrs79drJ+cPRknnxggwB2g5e8zTrTAqgbTzdbf76OWHZ8p7Gw0pe0E?=
 =?us-ascii?Q?qh+0q7ur/y5tv+6AKJMPzWXL6CsTCTSJIARjNxmYHWl1a8JjLCzLVHna/M5D?=
 =?us-ascii?Q?Lmhc+4x6YIiXG6CEuE2Y08iAfLZj/SiQ9ZsnZj3O8FMSfggsNr2dZPkGTA+9?=
 =?us-ascii?Q?UCGJUgk9TtWcBB7eMhqF7sNti5rXl9dq6+iZjPW+ya0m13iW/j6J3Uw3sku7?=
 =?us-ascii?Q?DCmp3JuR+MfiWFGj0PWEqXnr4vA5I6XklJSaoPlYtg0ZyKNxWC5dO9i6iFq9?=
 =?us-ascii?Q?DqgzZO1LDfELOI41uYvw2II=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BC881BE16CBEFE43B5E1C75849B57D25@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8f2144-f775-441d-10dd-08d9b97aaef2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 12:11:22.0477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dN52YEQm5w4CmY9fZinlEl09F6Q1QZWwkGH2kKXyeGDNqn3nOW2itKNLs4F1CBLpGjKzjlPwKOb6stBNfzE5uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 11:48:52AM +0000, Russell King (Oracle) wrote:
> On Mon, Dec 06, 2021 at 06:09:22PM -0800, Jakub Kicinski wrote:
> > On Sat,  4 Dec 2021 10:28:58 -0800 Colin Foster wrote:
> > > Expose ocelot_wm functions so they can be shared with other drivers.
> > >=20
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >=20
> > Yeah.. but there are no in-tree users of these. What's the story?
> >=20
> > I see Vladimir reviewed this so presumably we trust that the users=20
> > will materialize rather quickly?
>=20
> Thank you for highlighting this.
>=20
> Vladimir told me recently over the phylink get_interfaces vs get_caps
> change for DSA, and I quote:
>=20
>   David who applied your patch can correct me, but my understanding from
>   the little time I've spent on netdev is that dead code isn't a candidat=
e
>   for getting accepted into the tree, even more so in the last few days
>   before the merge window, from where it got into v5.16-rc1.
>   ...
>   So yes, I take issue with that as a matter of principle, I very much
>   expect that a kernel developer of your experience does not set a
>   precedent and a pretext for people who submit various shady stuff to th=
e
>   kernel just to make their downstream life easier.
>=20
> This sounds very much like double-standards, especially as Vladimir
> reviewed this.
>=20
> I'm not going to be spiteful NAK these patches, because we all need to
> get along with each other. I realise that it is sometimes useful to get
> code merged that facilitates or aids further development - provided
> that development is submitted in a timely manner.

I'm not taking this as a spiteful comment either, it is a very fair point.
Colin had previously submitted this as part of a 23-patch series and it
was me who suggested that this change could go in as part of preparation
work right away:
https://patchwork.kernel.org/project/netdevbpf/cover/20211116062328.1949151=
-1-colin.foster@in-advantage.com/#24596529
I didn't realize that in doing so with this particular change, we would
end up having some symbols exported by the ocelot switch lib that aren't
yet in use by other drivers. So yes, this would have to go in at the
same time as the driver submission itself.=
