Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA18654770D
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 20:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiFKSNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 14:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiFKSNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 14:13:17 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130072.outbound.protection.outlook.com [40.107.13.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E260C22518
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 11:13:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDBfwo05OZSrPvR7o6NR7Eqbd5gnnmYkBcXmEal/ME6JcfUijJS2DiupqBmnYE9CnXOuKK/74V2vE4z23sc43k/m40+R+om/4dUabysF2O/3FuuOF5y8dLneuX2YbndPzHCmLWpeaF8mS41TpyYmlVa5YAl3u/Nq2W8xCvMTzDZtcTXB+3TuojUNhgegmCEWQsUTIfWmfoWAy63B1dsm6yQYuYdEs00OGGl90TdMjoyjmyprU/8N11tm+7a3e7N3l80EpoOmYaBo4LqoLzsQmudYj3dmd/26a99tV1a6PEcSA5XFrVIvll03bqXNDtw6JeJP7r01W0+XXzSfh64qNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RC261YBYzP3QOQ/MDSoQ9NnnF1G1nKnR5dLrkdw6Us=;
 b=jbKUieSF6UVQ0uqG7EcS1MjEgWsIvPHSqEFTadd9nppmnroval7P7G2BFd6bPfukmfqBfJIRyCBijLM2QsbK+C1Ryb0TDdS7E6ncTSczguLHm9UWUQktUpMen4nhPo5Hoe0UngarGsXrmcn+Pk640etMfo7VtQtIOirwUB1Pj19Fs9ASZ/e15nBTYoeooPuJ4H2IzQKQSpgXbJZsvmSNTsetch8V8fauGcD7L2ArphuuDqK/rwGcPh4MqJd3rI5KC7EfC++TkQFYCf9gzGpOoQ7a4Rcqpc19DI+yoAsZgIQtcANiNxaBl0SDeCr+WaTP+/OM79YwFhfHykeZ2ViMXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RC261YBYzP3QOQ/MDSoQ9NnnF1G1nKnR5dLrkdw6Us=;
 b=ZSBsdjBQexlIipk8IwBxCsWr9TSSvu8dIw27FbMLXesnqwQSSHWrz93iMdLSI2jbc1GiBy1PGjVMxaJT6G84k06/MUS5z3Fzy/OIxAzoRS42lCu30FlSD4pnZYikHZ58wQ/EVpZ5JjVeICqZcblputSc8tnTbP1/NEhAOy/4Stw=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by DU2PR04MB8981.eurprd04.prod.outlook.com (2603:10a6:10:2e0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Sat, 11 Jun
 2022 18:13:13 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::4865:22f8:b72a:2cd1%6]) with mapi id 15.20.5332.017; Sat, 11 Jun 2022
 18:13:12 +0000
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
Thread-Index: AQHYfKXSil1P6dug1U26HZopRldC861KTn+AgAAtI7A=
Date:   Sat, 11 Jun 2022 18:13:12 +0000
Message-ID: <AM9PR04MB8397DF04A87E32E6B7E690E096A99@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20220610084037.7625-1-claudiu.manoil@nxp.com>
 <YqSt5Rysq110xpA3@lunn.ch>
In-Reply-To: <YqSt5Rysq110xpA3@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6815950b-39a4-4ba3-db0e-08da4bd60c38
x-ms-traffictypediagnostic: DU2PR04MB8981:EE_
x-microsoft-antispam-prvs: <DU2PR04MB898159C5B71E18335F281C2B96A99@DU2PR04MB8981.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WrIzfMeddWpOvioMmK3AEW1TkYjtTufWyLFM3aESm1b3B0gIIJXqsGYBd6QdPt88s1E62aKvER4eWwpaLHaJjyv1ymQhiX17mMlPy234VHejZ3QI4am23r38tvbbDUoT5i3S6mleTjfXiZn9QcGhAdcsrF0tubROst94jrk8YAwp4Iqjd//IfgEfF1qeA0MhOVSUdRAiwJjW0lG317ohRjuv2bgj2XijfqaBGq2c86Bi8QJ3UwJEyRdF9XTMaIYHyTFf7qxFOvUuWvzACaNQaFBTJls1s7p730YfMOCfz8+DRvwhlT3aGcvYOwNVmGdMaeFx+zUxL9L/6GMJMmYb31dhkKIoNWkgwukFxaIwfxiJSATI+GKU1LZCyDl7BPYokqJ88FTIh6+Bmjf0S1e2DPmg+c5AVv6RrhAganxjZoxNk9UrEYw14Es6uglqCfdyX/d4dqjyOov1zHzUaoThOMgpnQf2ktUlP7Vxe0+kDhvxEZap28UE3eRKjULLVkqCF9Xki04wHwm/fG412IV2gAdSG8cnJDrC/iwRd5euYUq4wApaRk71FoGJSkLkPebo2aBkvzN6IcFMJUcwR7JTxIrnV4LMm2GROd8MZFTf6L3OXtAXPL6mEycGDCKL0/y90zwL7A0bmy/bHiVGe7/mBWAFJh3IPMW5R2Jd8mrRYkXdpysRtCMyKRJsXv23oL6QG3rg4YqSqlWKbBpuQqaYUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(33656002)(26005)(9686003)(54906003)(6916009)(186003)(38100700002)(316002)(55236004)(53546011)(2906002)(7696005)(6506007)(44832011)(55016003)(83380400001)(86362001)(5660300002)(122000001)(66556008)(66446008)(8676002)(66946007)(76116006)(64756008)(4326008)(8936002)(52536014)(66476007)(71200400001)(38070700005)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cHru56lBimNKdy3b5M839FeyN+Dq/vfXX2pb8xCt1NJA2RF21iqRKCACcuW4?=
 =?us-ascii?Q?S7Px6V5js7l44LsQZ5l+WWMAKZcgpQ4HT64hKrNoDqiSSjZTW1D3k4MceVw1?=
 =?us-ascii?Q?7kCiGwWoSKNBzqFcNnsctXl2AUkgYDlgPxN085LHVywwJ3Wyv893enbki9/K?=
 =?us-ascii?Q?WLu2r4Uh64zUh5D9CAEL60o070IBStsyTUrGUW2ynhvWL8qy7FgCY/53+QTV?=
 =?us-ascii?Q?/Y4FGRa44BmaRxrDz1/2x9ouhR42sSF9cPKocOVYS2hIN82aLn9zedO/29E+?=
 =?us-ascii?Q?4GjqS1Y1XRf5f8ecEzCmp8vmYp6wfkYEFSw6wA6kmICTLZUoHg4ZqarqNtTj?=
 =?us-ascii?Q?ZlIkV4fvLO9iBNUNe4g3C20Eb7SGCjwhYIt/aWU2VZuGtkvy9bswaABOeyt2?=
 =?us-ascii?Q?3WBXx8lDzn2wLDzyWbX9u++ShYO+924ttu1PBlclpZ3A0WhPAIXN2+/D8kIT?=
 =?us-ascii?Q?yO6mcb93ltgNo+xQtpqyNFzDbk9ilK9lLrliNAv3X6CaxGErTDJu3GlsduyU?=
 =?us-ascii?Q?pFS9jAe8DIejLpwsN5ou8B+D2/Ejh7RJbNfTHfxOSj96/BN9VAI82/xfQrCg?=
 =?us-ascii?Q?PRh6K4111JNdaUk7X454rDyvaoEa8kmSdSe8skYMZtREN/f8v/1YfprY70LT?=
 =?us-ascii?Q?ueiFMWPVLxud0ynIlJptjbIQxqJpx6sIadKQybkDc0RfF/NZmCKZYnd1CZlj?=
 =?us-ascii?Q?X4orNN0ernlAXxAUWkBOXySgUFvsF2qeMIeiRbqjfRxBC29hb/JqwcCR3CDG?=
 =?us-ascii?Q?Uf6y8r4wTEGef3yudx0eQmHIV1rwBJe75BJIyv3tCg0pLCZo3HBaU425XLQg?=
 =?us-ascii?Q?J2AmKY6yxnllEfWHkBqXygIU0Y4uIeFns6447yPedL8neLYVw9X6ND4euBnz?=
 =?us-ascii?Q?4EcR9C4NDkUQkS9E4uCeYsEWMAWKnEHkPHve9XHWHVSVZ/zgShYPLfYym/Qk?=
 =?us-ascii?Q?31hBG/CHLwV5UWuzJiFwvZYbYowwPSFEjNGQOUan8qolsxmGYKoWsCUHLhx3?=
 =?us-ascii?Q?/l7wld3d2fFqRumu/GAPbfi2h9UgLJdAyC9EDHxfaJaKoSdNlwKqerqL+B31?=
 =?us-ascii?Q?FyPVRJyT0TpCQJhGhLPfqtEjomjmQ9jbm4x+9HFvALY1Hxw1MyEaDEkTVPr9?=
 =?us-ascii?Q?KZAZ/AhV3ZF3BhysDndmiJH7qUS7iF+VixSNnYCfpBOGjE/bJMq+Nh5h0Uzb?=
 =?us-ascii?Q?/WmySYgXL7xfQfp8CLDrAzsFBCneMxGAUqKYtswVD1hbBR4+b7+ghVqZB6dB?=
 =?us-ascii?Q?Int7pl/gsIjmBBjRMynKU+1SX0q+4moiIOiEQf9Ai6EUvwAXCXlLJjmloZlf?=
 =?us-ascii?Q?/WUspxRJHN0RaRrEZtUV1NhdUUdIqJnZ2CXznfnYK3GlcILcGWzrHzIgcsNj?=
 =?us-ascii?Q?nNBhNq+cF8rcai33KioD9MidxIjldMRpAX32iSPC8PSmSe06Omp24dXAx5xi?=
 =?us-ascii?Q?EMnbHtkG7TNbvvKISMrxs4cVeK1CcWeWzcIAXYM3WyqgrmzEkUHYFTMGSV/2?=
 =?us-ascii?Q?z0QsH5J18tq6HXPjGmHAy1ryGuH1JIb/v+vpi8c9f8/5tD7tAczmz9U1CFT1?=
 =?us-ascii?Q?nVCs7lU4hoFNhobcDUTknheua76hu266wpQsr+Wn1ZlUtTn06cCNIuVuTQGj?=
 =?us-ascii?Q?h8D9xOjISEvMXuQxT2NQdPb3YrfzwrO8BZQs6SfvkjEiKrnCnKnry1iQeueb?=
 =?us-ascii?Q?esQ8s+vFEogLMggBD6ssk3Kt8p4SBAcAFp4Mp3/DHTGiVL44fGeZdcBo5wzM?=
 =?us-ascii?Q?GWO6vGMgEw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6815950b-39a4-4ba3-db0e-08da4bd60c38
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2022 18:13:12.6015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 87iAfw/yPjJUziSAGdADji1w9m2IE6vklvYC3b0idTzA1anvNcJwl5Uy9ynXNgCvvD02jBfwM/GpOU2+NI75XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8981
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
> Sent: Saturday, June 11, 2022 6:00 PM
[...]
> Subject: Re: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1=
G are
> not advertised
>=20
> On Fri, Jun 10, 2022 at 11:40:37AM +0300, Claudiu Manoil wrote:
> > Even when the eth port is resticted to work with speeds not higher than=
 1G,
> > and so the eth driver is requesting the phy (via phylink) to advertise =
up
> > to 1000BASET support, the aquantia phy device is still advertising for =
2.5G
> > and 5G speeds.
> > Clear these advertising defaults when requested.
>=20
> Hi Claudiu
>=20
> genphy_c45_an_config_aneg(phydev) is called in aqr_config_aneg, which
> should set/clear MDIO_AN_10GBT_CTRL_ADV5G and
> MDIO_AN_10GBT_CTRL_ADV2_5G. Does the aQuantia PHY not have these bits?
>=20

Hi Andrew,

Apparently it's not enough to clear the 7.20h register (aka MDIO_AN_10GBT_C=
TRL)
to stop AQR advertising for higher speeds, otherwise I wouldn't have bother=
ed with
the patch.

We have AQR113c and AQR107 phys on 3 board types, 2 firmware versions for t=
he phys,
but for every instance the AQR phys auto-negotiate at 2.5G when phydev->adv=
ertising
is set to 1G, or even 5G when phydev->advertising is set to 2.5G (for the p=
ort that supports
2.5G).

Do you have any board with any AQR phy (I think they are called AQrate Gen3=
 PHYs)?
Have you tried to restrict phydev->advertising to 1G and connect to a link =
partner that
has 2.5G capability?
At least in our case the link is always resolved to 2.5G unless we set the =
7.C400h register
as shown in this patch.

Thanks.
Claudiu =20




