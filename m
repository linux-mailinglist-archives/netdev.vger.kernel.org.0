Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9B041EABA
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 12:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353448AbhJAKOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 06:14:07 -0400
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:47214
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230241AbhJAKOH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 06:14:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJwjOvpnfXMscX8xwOiKnEjuRCwBTdMVuZ2I/3039gRbgq9nFypwUgFhuBfFk062WymnfL1DXBJ8lOvFe63KZRACZokT6aZRCxoxbPGqXl6O3hpxQGZynxcsMVlUYFu95+BLqI2rp1uagzMTvd7HL2X+pjgRBvT+TydegmbMdOhY2v4C3xETe5KqmvI+5pO6KKt1VNBa5Gq6d4SVL/pfRHot48M1lqNszpjTQgkRZMjvDyaqaefoq3haynSTXCWujpHrL+YHbuQoiuJr9ATrXNtoEMebOawHm5By5kxIqTT8tjwchvhLSj16Px2wfcup6mh4ru+3TBFuW5giKEdL1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2sEdsyZ6M19naueTd22maiSXWJFdwOYZ310UzXqQx8=;
 b=VK1eM4EsF/n8fhSKw6LMXCBOS6+g2XA1DdqcXmWcbGG1iwvDs7f8UDOSyaOysqFIVLhzdYpig/K9HWE8scId6MpUSIoheFD10yvIJqHM7Pb53vhePDAKK6lI6C1UWPG/YKpa8rizGylrbfCwJ1RnwwmEF409k/TgxgdkrdgOoqv3QmZoadmCl7c/QsNRQ4kf5lHyiIa4JEeh+ZLr7HAuh9kO1hk+MwC4iCRsJroKk6n6SjMq9PNZfA7Tw4QDr2+2VawY4peKWWNoK4gJfvs0RdC6hgfLLocRLVEFkkWmCTM2qUjAHausNmn5T0QXYTekv+5qI7HDmm/WFaXQIa2Fng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2sEdsyZ6M19naueTd22maiSXWJFdwOYZ310UzXqQx8=;
 b=Y3MSX9igCflyhrQDHfFgj1GYxUs7jEB5V6C7BD+jr5sYqo9KnrpU3Li8YKmk5812SaK6hp6uvFbmbKzZUwxa899Tnpt91BtmFNJ8Ubakd+4ad/Q6n+wHD5Swo20ASkvVTUtK3D/zg41uHbIVKwv58bBtSF+bUioqjKThIslaizs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Fri, 1 Oct
 2021 10:12:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 10:12:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: Re: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN sequence
Thread-Topic: [PATCH net v3 1/1] net: pcs: xpcs: fix incorrect CL37 AN
 sequence
Thread-Index: AQHXtbUKKyhIRXal/0mOmtJkI1WPdqu8TpGAgAD6HoCAAKFlAIAABCSA
Date:   Fri, 1 Oct 2021 10:12:20 +0000
Message-ID: <20211001101219.g5llt6biexzij7ev@skbuf>
References: <20210930044421.1309538-1-vee.khee.wong@linux.intel.com>
 <YVWCV1Vaq5SAJflX@shell.armlinux.org.uk>
 <20211001001951.erebmghjsewuk3lh@skbuf>
 <YVbbitGJDZhd6eW/@shell.armlinux.org.uk>
In-Reply-To: <YVbbitGJDZhd6eW/@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 892c746c-ecae-4e00-6076-08d984c3f455
x-ms-traffictypediagnostic: VI1PR0401MB2687:
x-microsoft-antispam-prvs: <VI1PR0401MB2687B834139CE02C94CA3D0EE0AB9@VI1PR0401MB2687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tdPeRI/NUSDoVPzAFTaP7litMKGuWo3rDKOz1AXF11UzI47awUfLJOwtPWcjjcatk/6LRbKgWEureD9r5dokHv35iEOTjQuQfat0BE1t/7DoP9T4+0MpvTaKaHpZKY3zARb+PDF0Ialv2+b630hR003J432tOH3WsUz8FoSkzflg7/1MgyXuuIPakGFGt1oW7NOZy1uXs123WLmiegOJuNwZkqsu2Y3Y68O8rMAfffIHPJjgK/1E0p0hXdfhqPoLmxOZOldraWRlJ2B8Gh7uHpxp3rCxuyMzfZC/ZFNOytUcQyh7vtD3Qx7FZExE3NLI8nuTNUkLlpfH7biuBowhfgJeTDCPPYVbY8wOv62ArjdUEGenqhKEDSQPh/Q6FdIHtX+VlIwwA16Qna5bACeQGokn5Bv3pTtyzTYGxt/eyiOQuSY1qwIe1Sb929/eo/Icu2N/uyhQvG7aw9gUPXObkVKXtu8MPyfpa1km5snfBktxgvNxN5nQfBYYG+QLmCmsX0YMg9kJftU0fE7ioQwSLJHdutCrrLo/qIIHOzkGC4IzygzJyWysJkQbNjiNk6GqWhD9ojp1vHeh24Q8U7LrCzp2f7somLcWRbEa87OCgUzqlIrBUTNKtdjl2JiXqubEc8wdh3qzsIa/Gpj/UGfJqTsNnZgbwKYoUuQB4uQ/P5pWCg47ZTV788xeiNug2hxkyiJAG4JU5h24XguoRMdHBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(76116006)(91956017)(4326008)(54906003)(66476007)(64756008)(8936002)(6486002)(86362001)(316002)(38100700002)(66446008)(2906002)(5660300002)(7416002)(66556008)(44832011)(83380400001)(8676002)(33716001)(1076003)(9686003)(6916009)(6512007)(38070700005)(122000001)(66946007)(71200400001)(508600001)(186003)(6506007)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5yUXYPQBmgXKeYCXsvgee5ax23Pi5GetPhQoCJrhLtIhDdZPBtxrBhTZ96IL?=
 =?us-ascii?Q?3bSi1e5ZvrrhrDFyTzrSJZ2hkkCu3n7LGcTVuvuXCzC+tQjHqCx8jt+W9diM?=
 =?us-ascii?Q?Hp1wAsJQOgd3sdf7UoLRcLSOzjaYfyQfB5m76ZotGrmh9hLuJJbuCEZ9dPd1?=
 =?us-ascii?Q?WGwMxBZ8aNN8G/nZVDDc8u3PdTodpKEppviPNX2tPrJZ2SPc8MniRBRkWuom?=
 =?us-ascii?Q?fK8+Dnfc61gYA0+6+N9EkUYQFi7QtR1nUlyrPE2XABJ2xxCbLrdRhhpkw5a3?=
 =?us-ascii?Q?JoTk7YoF/eFBf1u8P/HzC1/O478xRoiK45eFNnrPokqI84LfFOY538e0zVH8?=
 =?us-ascii?Q?nGExoV1YnDh014qxK4/K3Sw5qzapga+nOencsgkKoyRy9cRUSL/+3N71zRv9?=
 =?us-ascii?Q?VtrYJHfNKGqmmZrSiRb4Ak3JwJ50rmngTYvCJ38As/43ynqFH8W+uKc6uZJo?=
 =?us-ascii?Q?wpMg4FkIHD8noW12pxnNo6zPtmu1d18atGtQmXXTBQGAntDKVk5o3cUsalR5?=
 =?us-ascii?Q?Ee9G1QFa/C27yc0wWD71hTq7HL3XCjr6IOBddm2GtElUSjGNab16oN8aYtUc?=
 =?us-ascii?Q?dwQzt1xeyOSWRyAj6mg6KqHzXgyT3R8hc3juipdEKeaU9JX9c0ngv9GOC64O?=
 =?us-ascii?Q?KqJT1WhWHiLBVmV54GbIx2E/VV5ZHQ8u7GV57m/0fEVEJ3m8aXFlL7Z8LWcL?=
 =?us-ascii?Q?KrS3fQvOKPfPf2FbM3augpGV43FuIvwSxncUJ0i9hAtqZYWAExCUGPAt1fZi?=
 =?us-ascii?Q?ID+Nk0eLxeRqID7lA8tv/lRvYKp4vWxj+UaUjsfAGNqHCK5MRMdFb7ggcwO5?=
 =?us-ascii?Q?aQy9feOVPKgdYZVkRNRCd1K32ohayOZ1qIKX6GzD+qC2zpSUssvF9v58p+Ry?=
 =?us-ascii?Q?MNSM4Vjk2e09gxKZmVhogyz2I/Mft2ZsilCQWj0g3eZiI4AJ9ckdaCUw1n0C?=
 =?us-ascii?Q?iN1suoRE+9r5F4Qrb3rzzB5rC6ISwqeEYItkFtwJjPoFEk4FUs8VAkn0Sa3K?=
 =?us-ascii?Q?jLnZnaAdtUpBG3djxZkAvqzH9uXCO2hQUFj/EyDyhP/F0yx0PNUhgOLtgZtp?=
 =?us-ascii?Q?KVchYW6+OqVuoFJPwB+FeHfQZWGAPFCOJjZ1ZAjbxyv5fQowB5FHDCgndkbx?=
 =?us-ascii?Q?koZnbs0LqkpVKCzdz3LyLaeytjIvCi5gKaCAiJzTWf9hJIUWrXzuFSLCy1Dx?=
 =?us-ascii?Q?f57xCj2CcqipTUMRnJd7TgGAzt1Ue8iB7p5t1CoM/3wykTYNj3LPcLBrsaej?=
 =?us-ascii?Q?K+OMfo6WTehqIz5Au+4/URlKtSVh2jSC0+PePuOLCZAGrz6Ve8u2Y1OZVy/D?=
 =?us-ascii?Q?CPghB96KrEU2QhWtqXPWah2B?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C36FCA2DCF2E74A819066A53223510B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892c746c-ecae-4e00-6076-08d984c3f455
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 10:12:20.0791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ms8BpaoCmH6VALZ9zEcKzS+C0GHIPNFRvJfYPN/sdlGJApz8QTzEHW2W4IZlm6su5hUe3YhQ08mb4Ov/RgdH9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 10:57:30AM +0100, Russell King (Oracle) wrote:
> On Fri, Oct 01, 2021 at 12:19:52AM +0000, Vladimir Oltean wrote:
> > static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned in=
t mode)
> > {
> > 	int ret, mdio_ctrl1, old_an_ctrl, an_ctrl, old_dig_ctrl1, dig_ctrl1;
> >=20
> > 	/* Disable SGMII AN in case it is already enabled */
> > 	mdio_ctrl1 =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> > 	if (mdio_ctrl1 < 0)
> > 		return mdio_ctrl1;
> >=20
> > 	if (mdio_ctrl1 & AN_CL37_EN) {
> > 		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> > 				 mdio_ctrl1 & ~AN_CL37_EN);
> > 		if (ret < 0)
> > 			return ret;
> > 	}
>=20
> This is fine...
>=20
> > 	if (!(mdio_ctrl1 & AN_CL37_EN) && phylink_autoneg_inband(mode)) {
> > 		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
> > 				 mdio_ctrl1 | AN_CL37_EN);
> > 		if (ret)
> > 			return ret;
> > 	}
>=20
> This is not. If the control register had AN_CL37_EN set initially, then
> in the first test above, we clear the bit. However, mdio_ctrl1 will
> still contain the bit set. When we get here, we will skip setting the
> register bit back to one even if in-band mode was requested.
>=20
> As I said in a previous email, at this point there is no reason to check
> the previous state, because if it was set on entry, we will have cleared
> it, so the register state at this point has the bit clear no matter
> what. If we need to set it, then we /always/ need to write it here - it
> doesn't matter what the initial state was.

Correct, it should have been:

	if (phylink_autoneg_inband(mode)) {
		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
				 mdio_ctrl1 | AN_CL37_EN);
		if (ret)
			return ret;
	}

For the record, just in case this code gets copied anywhere, there's
another mistake in my placement of one of the comments.

	/* If using in-band autoneg, enable automatic speed/duplex mode change
	 * by HW after SGMII AN complete.
	 * 5) VR_MII_MMD_CTRL Bit(12) [AN_ENABLE] =3D 1b (Enable SGMII AN)        =
    <- this part of the comment
	 */
	old_dig_ctrl1 =3D xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1);
	if (old_dig_ctrl1 < 0)
		return old_dig_ctrl1;

really belongs here:

	/* If using SGMII AN, enable it here */
	if (phylink_autoneg_inband(mode)) {
		ret =3D xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL,
				 mdio_ctrl1 | AN_CL37_EN);
		if (ret)
			return ret;
	}=
