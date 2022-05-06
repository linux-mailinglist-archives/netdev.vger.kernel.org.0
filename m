Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5F251D738
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbiEFMFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391609AbiEFMFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:05:41 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60061.outbound.protection.outlook.com [40.107.6.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E241E5BE41;
        Fri,  6 May 2022 05:01:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJHZqzVAgQJ3SEY7OcErjfC5AyxQaMvPnhO6/ZPyXe3JCLfi47dyhHr4PDNr+Mw/Hzlmij2ZeG1f45EeGUPiC9tAm56XuNiG/++KskRtbhSzh9TD11iV45df/QviQXKwImAzepuVb1DjmUHhOLH17I+DiLNUvsLi/iGNmRwD9QvmT3Jrz+W6ebkkPBm32scmf+OSk3TyvvBl70ycrw2CPU05rnVn86AJ+cNv2E/mrrMHXl0c2b3klgd7KUU1NaCj4PNXW4T0EcJtmHFSuY/E9hJb5GZu3hlOgtEm9VDGCtsIpcv3cey01Ae9Nc4jC7Z99eO1u+rDQqNTHBYSp7hrWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2u+ldtbJgys/dO7WcKd4CDL88aKTBzhxU/b08vHKM08=;
 b=L0yq66bFrK7eTwlMeHm8vOt+OKbbKPszq+Ch8K2KHSwx9kRLOjNGFKGOD6p4dK2fX1irdYdUTGatR61ettIM42AxQVcJpu6C95C4fgMgyLUDyfbF92fS7HbwOg6OKWe7MnAaRVNCINb0MPJuMZnbJbCvY0E0MhgBLjQIdWR0yE+fuNpuO0tYDUpnp8XEJWdocXP339iFnbPcgspwlCWqtddDYxFAcalwwN+eKyo8i2KgqbU7hoEvRE3RaeHPD5pdu70jKoobJ/BEFDxRb3C4Sc1+Eu/q96b5VJRWQoGkough8hw/aGAYr8cRbqTrCVEVoyGNQkP8cHgNoiOyAxlJLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2u+ldtbJgys/dO7WcKd4CDL88aKTBzhxU/b08vHKM08=;
 b=OCR2k0Vx3l7IvYXgPDgNRizCOY80gmK+rDzO4XpMwMpTko/0vj+C/37qxmdX+aZ/9lCQM/+i25JRQoF5BMPk6VMOHcafdnzDP1ntZyUdaSNfxamEDUH58Bn2El6qJAt5uXbLuiQcmcc30m/3MJYIAGLSo1ZWuSzwYfTmaavnVOw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9295.eurprd04.prod.outlook.com (2603:10a6:102:2a6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Fri, 6 May
 2022 12:01:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5227.018; Fri, 6 May 2022
 12:01:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Topic: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Index: AQHYXU7ReS+uKz5es0qSAulr7qr8960RgRAAgABGeIA=
Date:   Fri, 6 May 2022 12:01:54 +0000
Message-ID: <20220506120153.yfnnnwplumcilvoj@skbuf>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
 <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
In-Reply-To: <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0301b95b-9902-44fa-9f46-08da2f5836b8
x-ms-traffictypediagnostic: PA4PR04MB9295:EE_
x-microsoft-antispam-prvs: <PA4PR04MB9295FDD927F7ED8454636D90E0C59@PA4PR04MB9295.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ENsiWWQkGTMQtI9DJlJTXfjOV5+h6KDUs53fVoly6vO0BMPgqAcvKAE8+IUZaMsiMuad95I1goV8OvQHuXM0ohgRmENrWSZDJ7fwdMKvxJ3kAJYyj2BjHKhc9b6w4X+NYKQLMl4/0hLKd95Br4as5PjbQQBIszNZ4RHsajv8A+Sx7ZprYkTQharA9I/8ciNwwSOBfZFUQgB70RJipM1pskYsNcJvDrI4tTKCnUm8yT3D4TAzq1fJB2rVKFQE/DZNFgH3fNILdyiEo2ngA3zcvy55tZEcjRTcAZirIpCXCqFYh4QDm1QtQ2cNJJPf5ts5k6OAeBvkxX2zXuHl2B8Pgpfbs2JqayD1NarfSiaslpsuFKtV64z5xoa2UrWph9cvaG4745U91r3lOU5gNeMDqLp2XPq7HKWBSYeIKrMhlNXLrJgwnnzu8TEm5sCwocKdS32l9lNIK996eqngof8r8bLGp9g/MZgXO+RGdzRttWDzKeGAvr/lY/HvZ6KVUE6modvqHQjSb0ZT+HgZW+uE3T+hAr1QEEPFHTB0bNEEYcawVbzaaCAqgNtAjAF5ZxYb08B8+Dax8lpOrxDy5ePOwlH6hQmVw/bBCo6OSvBOMGNNugQPZqz/Nqmi3m+l3ovGpSYfc8f8di7zhcbrJAe6xYIayTWO99edPPEp9a2fkvkXApupXapOz5cFvDiLwem2S4R0w7t+4jh+KJmys/TqwxGBoCj24KURbx+jibmlQ2I5lnr82rmUyroX9JZnROMIBQ3cK9C9IBehNiNAetZAvzKeL06I7DFK7hk52EDseYU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38100700002)(38070700005)(508600001)(71200400001)(64756008)(66476007)(76116006)(6506007)(8936002)(66446008)(66556008)(8676002)(83380400001)(44832011)(7416002)(86362001)(66946007)(5660300002)(4326008)(3716004)(122000001)(2906002)(6486002)(966005)(1076003)(26005)(33716001)(316002)(6916009)(186003)(54906003)(9686003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VMeGY1TCsQWnTrS+OhmBvBLbzz+PZV2+yZgNw/LtefJFpeDDT34aVpvdIX59?=
 =?us-ascii?Q?EAS8tbyYZ1mSVSjeXxXvjrVImiHbCcVVaw+Z/dbA7CE/AICBQc05nKjoQd1H?=
 =?us-ascii?Q?Jq7o2zgtFAXP9OfTP8TlBWT2d3/YRDD2dIIbcUAyTYO48Miv2Mz2evy0s6A6?=
 =?us-ascii?Q?SiXUdB04feWaVafeBbaxqvuUyY1aU2q+B2uGgB2I8bS69dxSQ8dwDZV1zHa6?=
 =?us-ascii?Q?r3A0wSwEJu4649ELDmypihzqSorB4hj4Wqg3gkTCdiQi+T/hed7zjKGx3D3M?=
 =?us-ascii?Q?fIu+xG2ilhMuwSWERp0prZ0coHCTIMKzS6JIjlTxpx6RtLjLNHW58SBFeV+j?=
 =?us-ascii?Q?cspIUoyAm9fqJL3FmnZxhxbjFjjT5kVvGJ5phNEXX8sAlJzHDxED0XAurVeV?=
 =?us-ascii?Q?Mxd7GRe6fONBp8YfVRTwn5Bw3mxZgeTIZPl9USpFrA6Xt0vJSau8oLv93+2T?=
 =?us-ascii?Q?df8pxaLXSNT1VR0tERn2UKFUF3qKPBe2M2z96072T9L1ySesT2G3PYnw+iwO?=
 =?us-ascii?Q?q8gq32xHh5923vzeNfxCDe4g94TOz6+7HvGm3XgihSU4PtUWrUp+xbBEUgAR?=
 =?us-ascii?Q?EncF4PY87FIeerKhNWPIXulAoTI/zQVRzkQct+qFBVDHfDfZ4TZyvmMAiBeM?=
 =?us-ascii?Q?sAjttdeK6QdkKQSElc/s1PX34KFUyrHeoqoam71X5UMMc4FKqfGCVFqv2Oh8?=
 =?us-ascii?Q?4QUz7Rok4pkwLeXQeyt7XfD49rjiTbjt2rrQnhHOgKnWTt+mJn94eoTyuJZ3?=
 =?us-ascii?Q?SimAjV61ehTFM/mgm1TpkBhnclXH9gsdkELhw02/O8QjdJ1AdSrX0HnlHhop?=
 =?us-ascii?Q?cwC7/kDu47UTS0hlrIEOcT5Dbxdu5bT7F2Nm1W6IoJ0pb6NUzjf1Tn7D6p3l?=
 =?us-ascii?Q?S52KBS7PQrnt+FcdbLnHVC2eAeGlrJc51qrEC58obCT9uCui69QQPrxL920z?=
 =?us-ascii?Q?QNmMvPO47GrTja/Zf+VDvnFd+WmwOKec4HbcP7KUSHjT3cCYS9l+w31n5X9t?=
 =?us-ascii?Q?hhtqcrYxzMy839/d1EE9wkFejHf7u3KTl/DcZ3qfpHrDgxvh/zEiPrdnCuv6?=
 =?us-ascii?Q?T+2HGtmSGjciMLsljQCDc6kEQsF/tRjOzPbTMobEebXEBrBGjnfsipWx+WVA?=
 =?us-ascii?Q?WApE0wlBakqhdB7FOw4uUpbVr7icmHZUus4A0r3dxCgUFeyFJOh+I21aupVm?=
 =?us-ascii?Q?vQmMOkBkYkq58U/2TNU6nHAQjeT8G1zwWi7bDkrcPkRyQtvfIuOR0BfA/d02?=
 =?us-ascii?Q?jeSKWzff3lO4J4QfGiaIWRe45yhbgZqMUmd5OF8i3DpwUMcsBG4UI5HJusva?=
 =?us-ascii?Q?m6h60GKDufSwhZWySC/qziu2R7XqI9R+Wj8812ibQMdoGl2y1/T+qlNkjPPB?=
 =?us-ascii?Q?O7VksiJSgk+qeYhpiiqfmAR1JLASJMbAUyk1t9FX1hNAp8dO23+g9zsG63yq?=
 =?us-ascii?Q?g6b+0jCsl4BAsYKuu94qymle74hSNRmyUuIrP6uEZKP61ahikC3Fj/HETrYz?=
 =?us-ascii?Q?cBEitNuQeKUOHKTsskKfJRj1LzimI+Yl1cMDUgYB/FT/cJCTsViuht+RCdk9?=
 =?us-ascii?Q?YdLPgV0TbtfOxO3AyjpGmVtm8caU+Gm0v1LR8wEcY68i56XbVo7Dw2njrgZr?=
 =?us-ascii?Q?dmzN3IKQLzp5YwbEZeRkUiiDpge6bsvLqkpAOxJHG6ZDGTLJOtEmebbv6Qdi?=
 =?us-ascii?Q?u7jsG40bx7+ecL0UUdpsLlxmXkS3ObMDb9yhm2i91dwJ/ws16TNw9Tcu51DM?=
 =?us-ascii?Q?0y/HfJneWTbnQdv0HJNq8Xr4lZAqC6U=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7559AD6E279DFF40B1516F57CA29647E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0301b95b-9902-44fa-9f46-08da2f5836b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 12:01:54.7730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q8+dO/6XtRXgSrbQsovdtTcKB8Hpo/ihoogqYrixm6mzhW16n2syHhq4ZkkrDw0L89JArY6zvtut53N+Dr2JVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9295
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

On Fri, May 06, 2022 at 07:49:40AM +0000, Ferenc Fejes wrote:
> Hi!
> I know that might be little bit off-topic here, but the current
> implementation of the act_gate does nothing with the IPV value [0] even
> if the user set it to non -1.
> IMO this IPV value should be carried through in the tcf_gate struct [1]
> as something like a "current_ipv" member or so. Then this value can be
> applied in the tcf_gate_act function to the skb->priority.
>
> Background story: I tried to combine gate and taprio (802.1Qci and Qbv)
> to achieve 802.1Qch operation (which is really just a coordinated config
> of those two) but without the IPV (should by set by the ingress port) we
> have no way to carry the gating info to the taprio, and as a result its
> just sending every packet with the default priority, no matter how we
> open/close the gate at the ingress.
>
> [0]
> https://elixir.bootlin.com/linux/v5.18-rc5/source/include/net/tc_act/tc_g=
ate.h#L21
> [1]
> https://elixir.bootlin.com/linux/v5.18-rc5/source/include/net/tc_act/tc_g=
ate.h#L40
> [2]
> https://elixir.bootlin.com/linux/v5.18-rc5/source/net/sched/act_gate.c#L1=
17

This is correct. I have been testing only with the offloaded tc-gate
action so I did not notice that the software does not act upon the ipv.
Your proposal sounds straightforward enough. Care to send a bug fix patch?=
