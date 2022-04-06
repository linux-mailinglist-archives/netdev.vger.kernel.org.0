Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77F44F6E76
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 01:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiDFXV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 19:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiDFXV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 19:21:58 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5708910242F
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 16:20:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSZCLyMfC2JlgF59M794UNWf1OKMIXLz18AX/u6Q1B4Xw4Fp9FeWhoFgHBCZi8WoEcFeQ2clK2pVFCySwXiz3wVfdf4+AB2m9i0DiQqS0Xd17QbXCub8DiHYcOCjX1A1pSl+4asEPMU5lSx+NCoLikSwwsSZ6c1fusNPucCu4qIsZ2HlFsScMutdmhYsfREuywRQAl/zR5xvxiS9gVA7oKVeEduxJnrL5n1cnyZs/RSUwfgFkhZqjn0aVhjlBpwO3bSQ0UT6alSCjP6CYXp9IZ1yNfzLjN/agk3yDHbSzJnMXER+jhdhmNXrx04R6W7cnqeL0Iw9/oaksElR12BFfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9DEYE8rvEHNndHOHqjbcLuMfsm9OT2LNQMuf0nYYEE=;
 b=GTWiEaCeK2Jm+UFJ7gpZl4iLc+vZfUPwBLCvZ9CUNLXPZK67AqLlpwGhee/FAoklqQt/pEfH2DldBf81x+BLKVenxZlB48hLcH69Ku/J91/38+mexGxJcLa2vAJl/bIZZ8dKjiMAm48IrjYNgWsTBAmonZGhlY03l8DKx9dsdkvgHISLClNgAzntmB2SuvleKAdXvH6KYser6SXvchDDZ5B3LI/mdvFOT+O1b9SgvfiKNPGWggS2PxmuTJ9Ui4FhnPg+w0Gz51Wv91QZ1YwIVjGb0D17q7uKQGlrnkVxzjnyVXuvLvaioSyUxli6ZsV0kN6ynXA6LyV2VY7n29gwfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9DEYE8rvEHNndHOHqjbcLuMfsm9OT2LNQMuf0nYYEE=;
 b=hX46UQiaDZtj2Mg++nd+2TTrk6nswrp2eWUOlgbZS2pFu2MIYWuVtoeezjXHULIlKgMGPf8JKBug/EGGZI9l8vfGOdmH89hls32mbuXlqyAqjrOB5gUI2AVVVgAKlw9k8iJB0kp4snT66cPhFqeyBh2zwwfwRrHbqvHidS1XC9k=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7788.eurprd04.prod.outlook.com (2603:10a6:10:1e4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Wed, 6 Apr
 2022 23:19:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 23:19:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Thread-Topic: [PATCH net] net: mdio: don't defer probe forever if PHY IRQ
 provider is missing
Thread-Index: AQHYSfQxEB9U8NullkeQc0MhFO2VcqzjeRyAgAAMowA=
Date:   Wed, 6 Apr 2022 23:19:57 +0000
Message-ID: <20220406231956.nwe6kb6vgli2chln@skbuf>
References: <20220406202323.3390405-1-vladimir.oltean@nxp.com>
 <20220406153443.51ad52f8@kernel.org>
In-Reply-To: <20220406153443.51ad52f8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7ed5e54-d579-4117-4db8-08da1823f737
x-ms-traffictypediagnostic: DBBPR04MB7788:EE_
x-microsoft-antispam-prvs: <DBBPR04MB7788F7153F2E1F8EF2D43998E0E79@DBBPR04MB7788.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J7cbLMXbWHALECpxJCswNq2XF+g/thJjW4mP4KAEMEEXxQK5N+ti2kQyA3RwYxqoeS+Lhz1OssRtJDjxWMfTQnx6j+idvarMb3LC2yZa+X7PTgKi/LflxPTO8XVybaVpXmpF8BRpUfPyyNaIHJqpGnLD6k+8PLVLX2yW3Jy+Wiq6GfunGjyvTnbUwiL6UymYPGaWBUdOFet2HKggJ+ewqJ8ng6BCnOB010nRvNlDIjPVjwS8Zo/6jOplA258lDMcXlP3ZpZjOTmutid71LGH7ujO8yHDJ03xazWpYbE0PSCI4KzzfYOh0KHihi8Sk6kaYbG9jDzDxaI0wF5ew2srwjSnp7VerxKDDcOyqMffaIM46mXHOPBXy9jfBqv7VskXWhc7FB+HP6SYOu3TY7uvVKVdXtI0FafQBlDVWJ78jKD4DPPB+4ORHSFwjo7dNql8HQeqtOVeM1u99ImShvNiwCklNe8uDANsOfTJz85JvEnYZ09pU6oF1VBZ0ostBTnfDQ9yZMK77b7ovFVL0AZNzlHphzEV2BbKno0Sk1XPaprYJvcgU1YzWLOMeOlj20Vw1BsWjEr2fA6RtuYRS3IlpYwgItvGF5F8jnGDvsf9CWiH+ve8Y2vxjU7erkS7bD6k5Yt98WdZsDvx94k+YbpNfYD+8vSlmrYutWmcyyHhgPCP9atLgmAM0YQCH7qI1L5ItHmZ4UhTs3alMLKDkEItcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(2906002)(8936002)(6486002)(7416002)(71200400001)(44832011)(38070700005)(5660300002)(1076003)(54906003)(26005)(9686003)(6512007)(6506007)(8676002)(91956017)(316002)(6916009)(186003)(86362001)(66556008)(66476007)(83380400001)(66446008)(66946007)(64756008)(38100700002)(4744005)(508600001)(122000001)(4326008)(33716001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2Rr2gw0CeXpqVGw7GFkI88LLjo/hjljB8KpcFZupCwop05PeiN3gX227GtGV?=
 =?us-ascii?Q?8HV32LAxU4JVrHGCX3B7mUL8nelwS1MeGZtQbbk9K6/B/kz9ng9B4pRBMQs5?=
 =?us-ascii?Q?e5sbgh1fD+8L+zWp14fEAmFkiW7Ut1N5ztCscKnOrD5tP+4r2E8dwVWwxgxF?=
 =?us-ascii?Q?3shnlpMbkbDJaOo9YpeEp09Unuku780KCOwloGUtPvR64PrJT35SRTU9bLVW?=
 =?us-ascii?Q?/Bgqql9Yke/NgWREC1sUoMkgehctL061G4kPQT/bkHcYGQUDYifJ54zRDyX7?=
 =?us-ascii?Q?LZqLVk/W/tqv+FOEnYeGdVJYR9gwaPWpahJQgI9JWrI/6AG8+HvAKyWIZq18?=
 =?us-ascii?Q?wHKJXtRKLTyHfgbevxmt9fDt9SyOagjeQUeQuPmPIUYFM9Gy0I+Xb0O6GEtR?=
 =?us-ascii?Q?nCmH1lxdQ2tv8s2sO/DNTax7WyH9+7Ru7S8lTaym7P9v1XlO5DX26hbkTPbe?=
 =?us-ascii?Q?uX0I3O6N3xdD6vCVU3zFNOkfWDV44x86p273/20c5Yhbrl/8YLkG56X/y7f2?=
 =?us-ascii?Q?fA3Jmk7HoYbAlfDMex0K31Zo9KXXj2VxkHbBEjvQV3Lr8sKOhGtt9eJjpJox?=
 =?us-ascii?Q?mr3hYo2Sit9nBRoajV6M4zIotpuNDpPOgmj6RQNFahRlWkQqGWQu9nXxb+Pq?=
 =?us-ascii?Q?wCsbf1cLHj6ZhszGgo6OQHLyLKJczMRWbNuCEBUH95jx4F83k5GyPezaZoDb?=
 =?us-ascii?Q?EhZThqOZy9EOrUi8ih2IUc3l6lJqE0GbTf1GTa+9z+xt0lyWOw8HOnGUcikX?=
 =?us-ascii?Q?acWuow6mBsQUM88JjCVsXisrlnOJlkRkD6g/E6666r4Wc2udMQd/w6Q9LE3l?=
 =?us-ascii?Q?1U2GoYtszjvkt8X8N7CDs+xhKn+qNIdLpaKcC8XryRJzzjnZTEv1BgxKjBwG?=
 =?us-ascii?Q?CithhW/UNDQv1KZE31NVxv4ZtwbleJQXm//zyQCB2vntSmLpejI4buq9c9SX?=
 =?us-ascii?Q?DZUD48ivlA4/rWKRIhdHRHm67J3ky1hBdB4mtuhFkq+iSro0P3P4MoQA98fj?=
 =?us-ascii?Q?fQYR7mosa6mnR+dxqSXLha9t8YqjQtaM4idIWIyQaBjoobhubgwORJw/9Y+o?=
 =?us-ascii?Q?vrTZWKoP8SQGmrdtydgyIj6nxyAVQbRMnQV7mpHTqwTuJfBXvcU99sGV9y50?=
 =?us-ascii?Q?8ITvctMKUR04fxivUd1WPwXWMsRNqhrXMY1USFImx7xefZBzruUZ+sSkN1Kd?=
 =?us-ascii?Q?gtkWSMl/dHZYwex59NgnMMuJHfZfYj8XW28LzYKssVCM/S2N/SizGEMDgaEo?=
 =?us-ascii?Q?Ov3pnVrOKzUSDH7jiopaDpGStB44qTBorX4jLfFKU/u3XM3D59KSH7qiThQf?=
 =?us-ascii?Q?8jszpQUElQ7IOD2XBmel6RrJUpF03U10g5q6GBrZxURJqR990wruHSzXojfQ?=
 =?us-ascii?Q?LhuK/qdyyvEYaQR/BZey+l6Hie75HwYCSSRYiqMlz/sLYRgrjEDfzKKUgET0?=
 =?us-ascii?Q?0EnYl9A01Y69bV6psLGY9vG9UiQrG/VvVU5qH+oyJEQOOdHGOW2imfnxCUfJ?=
 =?us-ascii?Q?rBphPEEQEjeRf+JGlxWPoYQpColKf5acB06em55u7ZduUXSJxnlSrHtyhz5F?=
 =?us-ascii?Q?+/1OkpG0JQa5T1TtYWnRnZAsEJWmMQzN9iY8xCjJuXHcRVuE/7OE/WJpGgEo?=
 =?us-ascii?Q?U/HdYUXDTBs5YL+a8OJdHGCMFKeP6+BUXtEIVbv4o/SiAnv6O0iEZfH8Nyb3?=
 =?us-ascii?Q?eRzNiH/moQjFcV1ppkAc7pusRszVAso2Pm8UwQ5advbF7um7iq6MPwCuJjTq?=
 =?us-ascii?Q?LFdDgF0Ej6nO47ysMOtFXBKD0/+rY0w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E13E037E4C4FDF46BA2E4F1F0964DD76@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ed5e54-d579-4117-4db8-08da1823f737
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 23:19:57.6240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /DWY8r+v6XGxfhoW0wUvAuk+Dg+T/xo83Z9RJvuNBpEJgGOkbEaBLSIQpYgl+26EkcGIEhqLKG5lkxhUlQ4oEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7788
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 03:34:43PM -0700, Jakub Kicinski wrote:
> On Wed,  6 Apr 2022 23:23:23 +0300 Vladimir Oltean wrote:
> > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_m=
dio.c
> > index 1becb1a731f6..1c1584fca632 100644
> > --- a/drivers/net/mdio/fwnode_mdio.c
> > +++ b/drivers/net/mdio/fwnode_mdio.c
> > @@ -43,6 +43,11 @@ int fwnode_mdiobus_phy_device_register(struct mii_bu=
s *mdio,
> >  	int rc;
> > =20
> >  	rc =3D fwnode_irq_get(child, 0);
> > +	/* Don't wait forever if the IRQ provider doesn't become available,
> > +	 * just fall back to poll mode
> > +	 */
> > +	if (rc =3D=3D -EPROBE_DEFER)
> > +		rc =3D driver_deferred_probe_check_state(&phy->mdio.dev);
>=20
> This one's not exported, allmodconfig build fails.

Oops, I didn't realize that all its callers except for FWNODE_MDIO are buil=
t-in.

Do you prefer me exporting the symbol as part of the same patch or a differ=
ent one?=
