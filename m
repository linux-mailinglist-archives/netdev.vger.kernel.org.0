Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8B9568980
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbiGFNbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiGFNa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:30:59 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B4023BDB;
        Wed,  6 Jul 2022 06:30:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S48zH0uwnr1iIS6gn3jmPgNZAY57ajMWs4ct21q8ZT8VsnHatcp7NIcQJmZm9T0ElwJf6fEPUGCFsk8tDHkTcPiYQr3t5h49WxFctHlUn1+gZC+CmLFURSO3Fxzik/xJueL++f8hfJsaZD++BM1/Go4V8H+dbDrCK0Eh/4wm1hOUXzY78arxGZUoDLNE11z8x8ociV0yQJK5q++fYCV+aLvI7O97hBV4hcIUBGn7yDRfHZRUzOcGt11SVmmjZW0NY7DsaEsNpiTFyviDTXCaUTE1tz2hRJsolBZJRnLvsV4HaJSI5/Duwe4JkeHGlbTDgUEhDaP3g5YZtzVnzBHK/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrnSgGT2CqGTDi8r8JNG2F95Ebw5062iqYZQ1GXYKNI=;
 b=GPgM0PvZkZRnJYclZZYSOM71u1g8tCDuxIefgMDO95Lcyrj21pZpXrlolCyG9JOg4HL+TCpUxKJ6Wk9e4lBoWkTxuqcq9JkSmgaKFHDmOmPPixkx/em5ian/4o18YoaVPAlSFLSsCUEY3hv8fWZYf2ete3UeUyPV8F8WXBRMX+ebJ30V3A12aLPLurzLFUCeZACy/7VFMyoY54ACNk8O3wt6+wXi68oLS3EUalpGfxhKVdJmu2IXWJ4s7mXJDSn1FgKiwkT0wt9boa26HXTne72oCIRcC/CJ2hfgheZ7Fb40BFF2LP401tQJUMIRG9XSZWUVhtTa4k20sCA3RbmQSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrnSgGT2CqGTDi8r8JNG2F95Ebw5062iqYZQ1GXYKNI=;
 b=rdT6YgFwNy862pkZpNsc8pMRCTSuVdciolzl3VoiHxKgYKdBEcfivoTs8Jskb+C/Omk7Q4d0ulVJznNaoSex4BLBgmcgKQsCH2BXPLa+W/aDC/3iZ/7k0cLSPoU9SYQrSB/NFtgfWo+rSotYiKIYPOzp2ne9SRh3p5+iFBFnM7Y=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7928.eurprd04.prod.outlook.com (2603:10a6:20b:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 13:30:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 13:30:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "clement.leger@bootlin.com" <clement.leger@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3] net: ocelot: fix wrong time_after usage
Thread-Topic: [PATCH v3] net: ocelot: fix wrong time_after usage
Thread-Index: AQHYkSZB/F5QO/XCnE66pe7u42qQSK1xUe4AgAAEroCAAABTAA==
Date:   Wed, 6 Jul 2022 13:30:54 +0000
Message-ID: <20220706133054.nmd62htnhkqhtjcg@skbuf>
References: <20220706105044.8071-1-paskripkin@gmail.com>
 <20220706131300.uontjopbdf72pwxy@skbuf>
 <12431b93-a614-0525-b581-01aa540748e6@gmail.com>
In-Reply-To: <12431b93-a614-0525-b581-01aa540748e6@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7eda23bf-76dc-4b02-d9ae-08da5f53c0c7
x-ms-traffictypediagnostic: AS8PR04MB7928:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XNG12YdrnyYz3d19vHckB8zwmT8G2Kjh3UqidF05C4MeDwyuepESZ7aK6ze9M5Kavv/e/mKGRRxhWlsd3AumrxiTLfiQG4/dGgSc8JFjdoIg5liGiyktf8fnc4ZoI4NHuPICp8dmy4D4WDCgdkYlf9AM1v72qVUbd39/h4VRCTIqxApxQEgTtAs5Hg3dqpwXnRTYubqas5TePDEFT2rVveoWBmTh+9Xj4UqN0zn7t1IIxF1GTPigzx41A95jdhPT+drYwy5aKzu4mRwK8q4KdVyISSv1mBy4IBA1FPcHfmSjpcS41PjsV2Fz14ufqYJ89v146QKVT7L5JN2t5rLtqOtDzo2Ob4/eC70yFt9Q8cSeSMMHazcod5dB9//fMlvwfddv1FZUyUYVE0+1aqFvqJzqWq2x7ovlX/OXoYnydYdkdx5foLRERM4reoXe6cx6tgN3zvCkMfTbltbzvcxmoqEK0YhCaGRBKXdK8FsM2PWRRylkS2xasEj45DDdKULNt128lD45GIN7k+VUdSv58+UIs1mvwB/EGHmTvNcvLDWHWDz3busW05mOeTdNgLV1F5DQ0u78J5Q8+VGR2wu48BDGr51SpOslyG6NkHBrcKvmW8Ameh0Ex6nuwH0PrIXuuNxlL1ShT7V4+xoAQJmcVoK3PxfmQu0m2diaap9oqnL3uj8jGOnXU11boLckN8b145FP9tQwUF2KpmWYox4Zl3r8kGlfEaB+xG2ETkF3Y2oH/8iRnoOQCB+ET/beeXyZWOf6bahIo5GMQhUBJDX4uL3M8TpSzI6CQud5ZbhHZSycUO7HCr7cGRpx6RDk43ru
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(346002)(136003)(366004)(376002)(396003)(1076003)(6506007)(91956017)(66556008)(66476007)(66446008)(64756008)(9686003)(8676002)(558084003)(76116006)(4326008)(7416002)(5660300002)(66946007)(38100700002)(8936002)(2906002)(38070700005)(44832011)(26005)(86362001)(122000001)(33716001)(478600001)(6486002)(41300700001)(6916009)(71200400001)(6512007)(54906003)(316002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AcBPC23s9wDKHmMYFRgXtn0HP9aMG1Fmfz7Wm63SUkaolaaz3aXmDdSz6Tmv?=
 =?us-ascii?Q?wwn8M+iFC4RQu60UfqT66YMMGneD1bLJlQWNt9GUEnecczubAjVyd5y+CqjG?=
 =?us-ascii?Q?w41h96COCIFj5v81ar1dMg69mmQ/UNWF/xZ/23Tna/GYaHck0AIg/1+U9zDM?=
 =?us-ascii?Q?64GOvcCZI6swxRwv4O/Lh+FAs8tyNbjIyvGwpfNX7qHxvSewGhNoUgWm9S7n?=
 =?us-ascii?Q?vThR3R2vK0D+Y5qgsbrMC9sVIrLMC7YykZWQQm6GM59dgAeIobLvPJXErYTO?=
 =?us-ascii?Q?eWRbjQmBa5F8JQ80/DJtiKvwXMB4/mCktdloOEONFMcvXGKER0wXpejBD42S?=
 =?us-ascii?Q?BTi6SWk9JhroZcB9f3ZNI3XM0q/K4DgHj4jS25GdejBCNiRHfRYW0uf/LiO1?=
 =?us-ascii?Q?4fCSNOuRJNbrg85xq05t8drV9InObB2INyc8G6BCX5kurEFZmHahUl2YSnvu?=
 =?us-ascii?Q?GgjImyffBk8DIt9TKBcDkB6IJjwe0nXdFZNDMg/HcoXIxNDsZugUqrIDsI+7?=
 =?us-ascii?Q?peGS7yXd3t00t2K48g9p86Fk6qWnbcQOq1MT1qlE4ciNWRAcinTHcGsbkNjX?=
 =?us-ascii?Q?+pGvI/BFMTHRDZKdkGVwEhQPAWX9w8MoGGBpUfDKFzEZzvWsRdXJtAhqKnxP?=
 =?us-ascii?Q?PjkZ/YL3XFMx49kdml1qoiZb/FtZK59RdlwagjgkYbmHH+KKuwT6zjKl4NOu?=
 =?us-ascii?Q?ewiFhKzAjygHmra+xi7HDj5zCQ/j6Jdh8+Cu78GA28CJfh3PowFj6uDPV7wG?=
 =?us-ascii?Q?RKPYaZzLsYv3T8fXHga4Ea4XHHt7Duu5lgeeajdFLnuEpVOm5cntu9yg0xjt?=
 =?us-ascii?Q?o55CeA3vdK5bXS1qzxcWCGUMgE0Cd3LAM+NDxS5pMmHfV3+1WQ8gmkvBwXlT?=
 =?us-ascii?Q?uqemUB+y3A0sSQtUjC/Wcch1UnM8BmTV/Urvk9LpSseWGhdCezbH3j/tRLAr?=
 =?us-ascii?Q?CmmUdx9t0prYnHtiA94bH+AfyuOOe4vXKYjyPwOg67koikY9mrmoB5p1VE1i?=
 =?us-ascii?Q?t/EzHSB0/l9yz5ECqV4zFncfhalPiTzX2b2MUP6uuefBLq3CPR61Sj1hfMnX?=
 =?us-ascii?Q?0252c1Cu3zIltrbXMWQvdj5jnadr96v+xIYjJ/SC5AcXMxXgOyZ1I3XeRUiN?=
 =?us-ascii?Q?2CdK1nKvsbeTJXx8pZfNMV7SpykeXDPQKpP5TaCgul7S1Us6zz0RLBv+BJAP?=
 =?us-ascii?Q?bDwH4lIrAbYjOuQ6hVDVb/YWc16RwZUP2Xw68s3mznNl8OgiinTi2pS1epXt?=
 =?us-ascii?Q?tIRwCcUVYgCGItsT13RzclM9kpwgGKoTj84t5rkyn6a079LXbQBvvzQFjcGr?=
 =?us-ascii?Q?bxiFU5K9t9Urb9PyD1i5r329AK4iBHv9MyuYC4vsvs0V14/qIPgkXujp4y6E?=
 =?us-ascii?Q?dFacQcU1ygQRmT0o52VfDUndUZoX9+8Q8gtNmX96GTKAJenrhbvLpyu0j8+6?=
 =?us-ascii?Q?f9wjgPx9UYe65HEYAhJ3jF/5VurKtIcTjnmve3oaLXyEZgs/NeGEN/gFd09d?=
 =?us-ascii?Q?g9llGCGvcf3etbdNMmS/KEtPlfEyjDusCQSmh9nJOU1YpRE8ZNU745QUIeif?=
 =?us-ascii?Q?lYXtNqJTBySCzYegnnXtlSXQAGPbRZdY4+WASFgJR9noBedYoLbwB8d+eJFV?=
 =?us-ascii?Q?Jw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <34E4D1F5337BFD4C847D5B815AC25B6A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eda23bf-76dc-4b02-d9ae-08da5f53c0c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 13:30:54.7437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Frz4KwXQaZe/PF34hCmkN27kPAv45/2GmuN0tCDEVp5AJAMN5DwnB9L4NdCMoyFanXIOPJxLv3fq9JIsVsikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7928
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 04:29:45PM +0300, Pavel Skripkin wrote:
> Hi Vladimir,
>=20
> Vladimir Oltean <vladimir.oltean@nxp.com> says:
> > Can you please indent the arguments to the open bracket?
> >=20
>=20
> Sure thing! I've just sent a v4.
>=20
> Thank you for review

And thank you for the patch!=
