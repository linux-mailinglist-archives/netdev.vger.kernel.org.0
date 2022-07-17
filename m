Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1205778D8
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 01:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiGQXjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 19:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiGQXjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 19:39:45 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF2ADF51
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 16:39:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mnq/dcF8Diu68LT9pbWews5lAo+7BCdDNmjc8VPYmyEOlnQ9eOQ+5Z0zvX7diT2Zq+mteLFkhVzNB+QqJdRmeUYyImswnKlIdYnE+a8RXLYqmTTLSs8B5Jdf4/m52dTdK+blNGSqSqPlmiYyvkrBGq09ki6lPKPnYA3Jfc4nhkS1b4YdH/vhBvXKfXH4N75Xh7aZaNcL/n6UZ/SWy38cB+99YuWQ3d3ua8UewxwTC925vLM1/HR4VkOBiN3FOzWtoVvsEERKifnaKMTgJkHfOEmFaB1AryruPg5VoY4yMcnbjYpKSuWCm+L++bpbfnE5NtyGI5PWxadYY+VWbh0QjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AK2XFjfl3tTMPaCekpOiXWlB4W30RncW1ehl1hfkzo=;
 b=ngb9ogKkLTp4H+NAST5jzwNLkCbx9N6kCs+Z7rlsWWETaguO46U3GpJN/7a7pKVRb01kE1QAhvZDM7/c72lhcwwZWPHaCgBwbD28mP1528gVFXEM/xiMq1KaeghGEjU1Cbi5q1YzO5K0RdjOZbRnITbZ2wnkoPGAckNiLBLIeyipKa6G6xNQ+D0I2tFnAyKS0sb56VjBWD48k06TbyPbaES4chpwTLL3Fjfa2VO4470LtwGEyyNXMbFEQxOZYwzjZE+SKjtuLweohGfo2VKZ/QObPX/cCaAlNdTzJmUGBMeJ+tII2vdS3Neih051M06S36SJcqjT8ODgjyC5r3hmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AK2XFjfl3tTMPaCekpOiXWlB4W30RncW1ehl1hfkzo=;
 b=OjA1kR8wmSKG3D7SIb0aHUzdQkFdapISlkDzpN4V/a/GAPZ5l45r39Xf/3uNlg0CKTmR51A+iE4EPjYZY4s0hU+FRTN7EhTs/u3XwA7mEn40uFhSuLTvz6myU2sqRyjpGtXOrc66mUuKHwWbPhhM6YdtgO68uXGgLjwY6uGXL1A=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8929.eurprd04.prod.outlook.com (2603:10a6:20b:42c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Sun, 17 Jul
 2022 23:39:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5438.023; Sun, 17 Jul 2022
 23:39:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net 01/15] docs: net: dsa: update probing documentation
Thread-Topic: [PATCH net 01/15] docs: net: dsa: update probing documentation
Thread-Index: AQHYmUVnpueT+rUPHUS23IUAS8PrwK2CrUwAgACNIAA=
Date:   Sun, 17 Jul 2022 23:39:41 +0000
Message-ID: <20220717233940.dsiskh6etvr23ivl@skbuf>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-2-vladimir.oltean@nxp.com> <YtQnWsz/X6yGBo3g@lunn.ch>
In-Reply-To: <YtQnWsz/X6yGBo3g@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a620ce66-47bd-4a51-7ec6-08da684d9f00
x-ms-traffictypediagnostic: AS8PR04MB8929:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /jIvlDBJRcZWpAivNpSenmEpI5YKkzmOJBYlK/c3idijT3Qi7n24vOiET6mxAy06nZVKj8wmDpd4CkqYxY3CLq/Bw3ORmUDZrGDOd8Hn8HVg6xUb0YgLqrNnbawROK+C7pqmpJ5Cv7iXLuFL0/Ben+0JS/6b96zibx217jjB8ZyYrvhC1I1t+o/1Qy9rM7PvFUzKCEh/4OhHhTsiImAz2Bfmzi7GeF82wRhDtOh/IKUYR/JYCUfAt0NJkz9uJECW9KY1wwlP7S0JQQ1dZSOma2FF7aO5kggqNdnDbFqYWtFlAsInGPA2697+fR2vC+Fbu1WkRUlUWFWadgdRoiF+I1iVjMmna+lzcdi45jLGlr4r+U4hiYFiwqRZsbP3LxfKTNGXuMK4KoZFGWQgJS+yhT7Y3QSlEW+hxiOWRrnDikBCF60CMniqZPk+McmjAEznW7NtoncVttzw20pCbckJGTLt1QWYQzQwBeaF5XmO+ynntUPWcEP9xa7/nJnoroN4CHGYsi12g5cm8KTLrNAJclK+dxSdcWcPjvdXmW5M8ZCKjwWz0cjoC+ZIGihAaFMQcEAg6Z5bfAlk2jjDmz+Mpy2aa39lVTpojDzvfBiARwcHWaVoif+h1iVk10RdSyYI51TFY47OnqlPoUwzhN8+DVDuKZq1Y4Mvyy8eoQ5uRikPoIGgh6IEBmH9FgMpzJ8qd0V1DqAsL78wS2QfwoVdZX4+A2m4h3k6Ule+bSGZ4ke9BT5Rh6BIy3WONdr2tTlQ5RHQc1Joj7OmtDIgqGNeQEZOggH86RpBBW4OVFoEnF5K20ec29EB+HjyItYzbi8UqbC/7Zk4de00jnI2SSiABc/00OcbZD3kQZPds24zCiA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(366004)(376002)(346002)(136003)(39860400002)(41300700001)(26005)(122000001)(6512007)(9686003)(6506007)(38100700002)(2906002)(186003)(1076003)(33716001)(6486002)(6916009)(54906003)(316002)(8936002)(478600001)(71200400001)(86362001)(4326008)(8676002)(76116006)(91956017)(66946007)(64756008)(66446008)(66476007)(66556008)(44832011)(38070700005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P7Ll4aqmAqputjXT11csJGg7jhc4LTF7kfr0ICUseG8iMuT3DVuqijLI+1rh?=
 =?us-ascii?Q?uz+uDGY6H705E65SD7SdmMgWdCMK1RUnkD/tFFcLw4Q9zgZUDsngsRTkJZVQ?=
 =?us-ascii?Q?W85Dd5dKs0s7ptWpHuQ5imU7OMigrvUWKRLtkQXbgvazwjYYVC0A1QTkVxKq?=
 =?us-ascii?Q?ZGShntIR1SX1eNdACsQWasKvpJ92LeW/w9Jo8xE2CzHki+O34sY5irk/PR8w?=
 =?us-ascii?Q?fJiFOQB+J5i7pokAAfcesZOw4ALOeg7VQbAimVMN3YY2wwEQxWzEP89EiTfa?=
 =?us-ascii?Q?8onMw9BXOBWheFmvaxo4kTdctHLyDg9kGMbDe9HQVeCgP/2yQMMdK5FEsdKD?=
 =?us-ascii?Q?/ZuJRBYqEoPKAOF6me/z3fQ5Ta9ILWM1PoBbbGn1EToDwzJ2quSwgHX2T7Ru?=
 =?us-ascii?Q?TglkPcRWjXDXdgqoU57Y3C0wUZAZQ4DCsFIT8IXk43tutUArBMnRW/8nwJGD?=
 =?us-ascii?Q?Oi/zfJEKSBvHWhZHQhb/qf+B06hJ/u1Vlgx8YXjXiiO+5yvw80gARaRQnIWU?=
 =?us-ascii?Q?vbO9Nz5rNG7B0LsEy2cVY0+QFde9rnncuV5y0OawDgHEmayRVoEssAOp/YMS?=
 =?us-ascii?Q?NRG8pk6gtcPiQDcnPKAkRgQr847OhbRtvZivA+bZ924+6yiavE5rb6Xa4k/N?=
 =?us-ascii?Q?yiO7Bhs/XGN+YVvCREtryvPLNnHotxZq7jFKJjcadJzUgSmuUQUgdKnLJLLo?=
 =?us-ascii?Q?CyMx+R4WcqRrGKaHIsX81WgSTqnrSsjbH7yLb6wvXvdkgZcWK3YiSrsXcEhF?=
 =?us-ascii?Q?64Yer1raLwI08A2RYBVmpsmJxAzlpjW8ULfAKDUAwIEVgWdUtuomrN9Zxg1E?=
 =?us-ascii?Q?kAq27/IXVMKrMWAkaK0cWaYhKuocFDdWtOISNdZyYhKkw9KjtRxluP4Euw8v?=
 =?us-ascii?Q?J6SkUljwti113AUrffu+D8CfcNi3+TXgktSQ/2Z57J49g4LJflQKrEiSoTO5?=
 =?us-ascii?Q?iB5DyUmNDhszXTN1pN+hxnlQ8YHstv+aBHGrZF41sfMaolJpVWNgKf1YDMmB?=
 =?us-ascii?Q?XqzpKBEPw1WLRZYJfW8kkXD1wkAUR1RJ24/qX+c0RBiRzigtHfJ/dGmvMGyg?=
 =?us-ascii?Q?aygVQyle0H4EsVQUL3NRLXp7V7CayolB5kJvZc8eQ1OA0aJvyxDOZYKvw0F2?=
 =?us-ascii?Q?Ag3Sj0mSaLT+HKmVUbkzWWuMfgtRz73lZKihrjHAMbF5WEG0FG5WZs0anxHS?=
 =?us-ascii?Q?WEFCd75jbf0/6Z3zRCLOX96cqxF4gT4fzUR1DxYzj1c6d4if7uEY3LICdcvj?=
 =?us-ascii?Q?CYraLnTw9W1LDDd8IBglGI80TEjszR66KwU7jgAuNOgIqMa5mCvl7kUzrm4d?=
 =?us-ascii?Q?Ngs+yKdYOAL9Y1DHfseqLLDvNZ5i2Ykn71Sx6VyWh7E4sAaYk99l9tE5SroA?=
 =?us-ascii?Q?q4fMTyQbmh8DAgCR0YPFkCWgFVEDZnP4O2FRdmdqaZhlcUAI0mzAxoAtbN7Y?=
 =?us-ascii?Q?JRFhz7qw0HxkmN6Xi8oAiht2Wa4l8lXMM0HQynpGZ2+lh5upGDI3qQOqsx6r?=
 =?us-ascii?Q?7iGf9srrctndh03uXnzYoGdS/eR3ZmR0d8in14Ph75N46u5kqAu14LZlyHyx?=
 =?us-ascii?Q?J5zpvu3pwz53S02kJ71eHOC5H18em85bThcJ415WoTU/Am8jtGCOof5D/6B7?=
 =?us-ascii?Q?lQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C74E831B74A41F45873BBD6276B78658@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a620ce66-47bd-4a51-7ec6-08da684d9f00
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2022 23:39:41.5258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: URqxFmwwA3qjr6NkZ7RHVNsAm/FFc3ap5EtgxQHpjLR+ul6g9QhU6KdW8wn4ZBDQ3X+jmGhCk1Pc4YD6NTrnwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8929
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 05:14:34PM +0200, Andrew Lunn wrote:
> Hi Vladimir
>=20
> > +Switch registration from the perspective of a driver means passing a v=
alid
> > +``struct dsa_switch`` pointer to ``dsa_register_switch()``, usually fr=
om the
> > +switch driver's probing function. The following members must be valid =
in the
> > +provided structure:
>=20
> > +
> > +- ``ds->priv``: backpointer to a driver-private data structure which c=
an be
> > +  retrieved in all further DSA method callbacks.
>=20
> I'm not sure this is strictly true. The DSA core itself should not use
> ds->priv. And the driver could use other means, like
> dev_get_platdata(ds->dev->pdev) to get at is private data. But in

dev_get_platdata or dev_get_drvdata? I think platform_data is usually
for read-only information and thus not really appropriate as the
stateful private structure.

Also, "struct device" (ds->dev) doesn't have a "pdev" member.

> practice it is true.
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
>     Andrew

While it isn't strictly true technically speaking, I'd probably still
tell someone during review to do what everybody else does, if it comes
to it. It's also shorter to write "priv =3D ds->priv" than
"priv =3D dev_get_drvdata(ds->dev)", plus it goes through fewer pointers.

Worth changing or not worth changing all drivers from ds->priv to
dev_get_drvdata? If not worth changing, I guess it's not worth
mentioning either.=
