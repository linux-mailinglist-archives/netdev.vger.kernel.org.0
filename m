Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFFF57F57D
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 16:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiGXOWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 10:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiGXOWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 10:22:10 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140083.outbound.protection.outlook.com [40.107.14.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A75E028
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 07:22:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgiYeP4Hd3D0xlyEUcJWbsz2n51Gtg4k/7K48RfntHko+bQIcW6j2L2/rYDsPIBuPU4MLE21yFawdiTmVL2rL+PbeIh8qZIQcmB+YeGdxoC3ln2+a1IFdW5o6VlnnCfLiphZ6awMG4Lw+JhONbz0Mljvxhy7AxRV6olJpqrvFh0RYSJBTrfDf4zC6M5Txt0vVgldWy680FkG+QvGCqgtlHDoLf24DaBIxxSY9OFeqKRwU75N8/Offs8IPlQ86QVXoGKyrg3VIi6piK2fT/utsOWvJ3VuMD6yDVAP6kucw7hDBinuPkrEgy/YhmmZ4RJy6wPnNLe0HYttsEMa0fDh7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrQtuqVNxT+ceQ7WT9BBFPAYGVJSTwNl5qzr+UQ4ObE=;
 b=ILBF44sOBXafTTq9TPT3CdVHwchbR7wNpXRrSdgwjrX7XLR0jizk2Q/sk6ZdlfqpvW85MdEP/WmJQTzaUPsd6AGC1sUTMFvdos1oI98g0bQ/NStTSYe1G1cGvp6SU4+LMldYSa1gS7uy/G4N1A0zpGEqFiksrSeQw5NsTCB970/GNWRNIse78Wf1UHw2DHQbYqVFPC5Rxy4pUcznawkU95NMixmT4OdyT7A++cnhnAkI87Lq7LThz/yM6s3q2r3M/x/jBsed33Us8GhfPt/r7xjlrXhhyRKuHwLzTAi8elAlphyMNjAMUZYgtBkEFCY0RNEOspq13ytPnZX8z1t8qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrQtuqVNxT+ceQ7WT9BBFPAYGVJSTwNl5qzr+UQ4ObE=;
 b=HHyOfqQThI/NWUPe/JBeQoNTICNzi72SS/eM+dY0UMpYxZmfnHonehQOCmUKdPhar8RfQ5YkZ9NbT9R5eVBzCaKoKdDMArpiO5x9Wsvb+h59dmINmj9poD6dzc2/lMiiggb6y6X7PxV14/X5QmKfw7ewkjZlCdOvzuhta0f60QU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5757.eurprd04.prod.outlook.com (2603:10a6:803:e1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 14:21:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Sun, 24 Jul 2022
 14:21:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?Windows-1252?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared ports
 have the properties they need
Thread-Topic: [PATCH net-next] net: dsa: validate that DT nodes of shared
 ports have the properties they need
Thread-Index: AQHYnrPeu7wz7m6SPUqzAwm5CxekUa2MQVEAgAFSvgA=
Date:   Sun, 24 Jul 2022 14:21:59 +0000
Message-ID: <20220724142158.dsj7yytiwk7welcp@skbuf>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
 <Ytw5XrDYa4FQF+Uk@lunn.ch>
In-Reply-To: <Ytw5XrDYa4FQF+Uk@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d3ba02d-2a00-47fb-e913-08da6d7fdeda
x-ms-traffictypediagnostic: VI1PR04MB5757:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h+ZZrkFSsrXicxceWRTPLqGkJN3EfqD1nv9ZS1aw5mjPbNjyK+YKGekMsKxhVNKbAdnEhWyIWq+uD6bo7FFRDGm1IFciSf0aXmBzrPpC8jUcpkkB6yrkLtzNC05t6nTkX00tdQ6IUb+iYZFEb+gzL2xuuqxJx187TQxoWy7BW5jDyGPY23vYbJ+O0w+tS3nh3Ai5BKHfErjO8JaRMqgU5htlyZm+7MI0CCM2dkyzPec6xo7CusZ+VARgUPdrzFnLs/USTLPMB2CLcDfMRzRbClQf5+8t0hcTl7rwSbcLm9HIcuUVrrJBQQ+bvF+mdFnHYGzdGD7waBsrA6SgoD6Al7mkrxdAb0YOEZqi/FoFmwJJo4LhgB1d9qh/VqSwH/4tBU74xKIw9gthASFh5U6V51gBzbBT0/RkR3SleYiQbBk9cQ1c805315ocrna4LHl7wWhy8sE1gOYKHNIns2vAjPM/ASyUP4M2h1Vr2/Oy6QlNvUC99X91VBF9iJci+TaOqNilL8W7LcXoB9iPiH3u1iMW4b52DH5BXggYlOowkxYSrjqortKGZh+npa/vx8kReqIilswbL9omWDP7C+EFl5MnrJ1hdEcb+k0YFwB6haDWJvG9v1plwkFdae+0JtBu+3MVokSMSYPA2bZG9pl2Tz/ue3qFwGwdGiQijLAJAWQSpgqN91nl2XOkfy9awo38zZUWaA0YiIoJ4UzWyuv7IqEYzat30Xrh8MfGLjEQqn/GnxtcD59BHU+E0BaC/qDBBtPD6yMhneGW336DBalGuKdJFkjuHRr4Lfqwv51QLKs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(346002)(39850400004)(376002)(396003)(366004)(7406005)(26005)(9686003)(6506007)(91956017)(76116006)(6512007)(7416002)(54906003)(5660300002)(44832011)(122000001)(2906002)(41300700001)(478600001)(1076003)(71200400001)(186003)(8936002)(6486002)(15650500001)(6916009)(38100700002)(86362001)(8676002)(38070700005)(4326008)(33716001)(66946007)(66446008)(316002)(64756008)(66476007)(66556008)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?AsdJcoCmoCjAaC7ZBQuNCCJZ+qoR4EIl0FM2NeNldbe5/TdlzTeC+VdJ?=
 =?Windows-1252?Q?5UZlwk8YbVwTJ+llGdSM2GSDVFzg8s7IRpLOfjaRRGo3YD0DLzbvMjTW?=
 =?Windows-1252?Q?JEURReHLtxH5jN491nRnQaKjz/NyBSwuU6W4vwMz9sBd92L2uIeO6sfM?=
 =?Windows-1252?Q?gbwPlPMRF4kw7ySLlF+uHhZlLVgM5+QL5hYTcMCzevif1GUkylK2dokw?=
 =?Windows-1252?Q?a9cdIQAmZ08UT5bMaEkJykJTEb4ia8yX5x4VQ5poU7ls0SUqGqQqSILw?=
 =?Windows-1252?Q?5x4sPBFfDVoHKlvcl/RALgR5ia7cbLz+/RJsh+hIcdBcsQd9JpVJJDnJ?=
 =?Windows-1252?Q?XnBcXSK+da3W8JHQse2DGDKmiPL5DqdzkTJYYmFToToYlQoWWVHdQNAV?=
 =?Windows-1252?Q?QATbHpULey5YyZfMqcobmS5aMR89vzwNLOTMnlRK9GK3owAPEKLT7dqP?=
 =?Windows-1252?Q?Por1882V7hsAItNfRQdt6xGq/cPFc8Jy6ohqngueRTqtXAizk22P4r6z?=
 =?Windows-1252?Q?OzFYnVHlkS9LGsAfCkNa3X6GbTxrjk+eFGQG92l26H47K5J4Zonbq8Y7?=
 =?Windows-1252?Q?WWRW8p1oyKKniRA+jit6BMJ47Er6gfCn5Qd2JrsRPBldBrqXy7IV594l?=
 =?Windows-1252?Q?gc89mqsaHkdOhEIwFIorP231ISXXw0K8Q0s7bGGQ6mtYMgPF11MNa9Ty?=
 =?Windows-1252?Q?q1V4nM1lP6PNxdVo/E1mC7BEgRJXtBGdIkjq6nTypbYHj+uYxPi+xHna?=
 =?Windows-1252?Q?RsWhEyVjl6m2LPoAWtNMu7N7H0YznpsVoyLDpzlrs7wZPxfor5pjyMQL?=
 =?Windows-1252?Q?RJImgpclvM+DF3iDt0CLdQmJZk1wP4e5fgeHNU0kGOEwkahdTEWX498S?=
 =?Windows-1252?Q?QypK+Hi3jSLfcxtOXTV2FhRC2gtsqFFODviZw05Zqg5hh32ew+EkWYdy?=
 =?Windows-1252?Q?EXf7wCk0niEbX4XNgicGxy6oCIgIwTINWgdYKVjYaacHjpN6zMdA9/rd?=
 =?Windows-1252?Q?PIcNhI3qmycuNMCVuTaovhABD26YWwtFmcYrTV12Lq2hsiBgQJArOXUJ?=
 =?Windows-1252?Q?/oAN9q+MaHgcyvBUMECsZia+VfpHf9oX8uviWk+Ca4wTEAmSElO8ujNp?=
 =?Windows-1252?Q?t5OXr/vES4CTe9M5226TtcUujD3Q4J9RknC/xdI+QxO3xzGNkUYdMo9z?=
 =?Windows-1252?Q?V+8F4TOoI9ouGrRMNQ2yh/8OorTsgMp3jJd4mN0+etE4IjPSIG5In0Ru?=
 =?Windows-1252?Q?rEemcSVVFrzLcvtw3+lt7m1dSB2euULWZ/acwp0IS24i7mf1uegUJQe5?=
 =?Windows-1252?Q?XvTb1ElPNsrpGZ3DQ9kKwR0K/Egfu+VPNmKMP/GO7/LZf8+Ljc09/85g?=
 =?Windows-1252?Q?+hPUZFoYOZ3CyONdBIb/+wq25SG0n0YDWqxOpIVKw5+RatoeMce3psDq?=
 =?Windows-1252?Q?3BELPtRgbBJvVaZ/e5Nx7Aua34ejpXVGMQImlcF+qc8FZPJ2+7VdhTEB?=
 =?Windows-1252?Q?fSAUA7uIVxSbWQ/Klz0LeeXOWtPzJEIPVrr1LHqWkFLicm57L7TJ8q8y?=
 =?Windows-1252?Q?GiSVzn64W6Sjd5WyU/gdPC4SBc0/vbo634Q2ItyhanjFYmNECfoOMXTK?=
 =?Windows-1252?Q?g6uXeHctYKcHcms801R4PY3M1BztBzn2POMV35jojxwIvpFDT6CwNcwz?=
 =?Windows-1252?Q?1+f+hLLwjnw93XSyKTFFme9e4zJQqMcYm8GwBJufWiqON2AFNzo+Hg?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <B461C51F143B934DADF8F31C038F2B37@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d3ba02d-2a00-47fb-e913-08da6d7fdeda
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2022 14:21:59.3040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R+elCBXyV+2sxsyyg6nFpO+OVTmN2bezuviai9atHeACz+QamW+Q4n2a9hndZ8iQCccmhElZ6JWyQV4VeEv/iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5757
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 08:09:34PM +0200, Andrew Lunn wrote:
> Hi Vladimir
>=20
> I think this is a first good step.
>=20
> > +static const char * const dsa_switches_skipping_validation[] =3D {
>=20
> One thing to consider is do we want to go one step further and make
> this dsa_switches_dont_enforce_validation
>=20
> Meaning always run the validation, and report what is not valid, but
> don't enforce with an -EINVAL for switches on the list?

Can do. The question is what are our prospects of eventually getting rid
of incompletely specified DT blobs. If they're likely to stay around
forever, maybe printing with dev_err() doesn't sound like such a great
idea?

I know what's said in Documentation/devicetree/bindings/net/dsa/marvell.txt
about not putting a DT blob somewhere where you can't update it, but
will that be the case for everyone? Florian, I think some bcm_sf2 device
trees are pretty much permanent, based on some of your past commits?

> Maybe it is too early for that, we first need to submit patches to the
> mainline DT files to fixes those we can?
>=20
> Looking at the mv88e6xxx instances, adding fixed-links should not be
> too hard. What might be harder is the phy-mode, in particular, what
> RGMII delay should be specified.

Since DT blobs and kernels have essentially separate lifetimes, I'm
thinking it doesn't matter too much if we first fix the mainline DT
blobs or not; it's not like that would avoid users seeing errors.

Anyway I'm thinking it would be useful in general to verbally resolve
some of the incomplete DT descriptions I've pointed out here. This would
be a good indication whether we can add automatic logic that comes to
the same resolution at least for all known cases.=
