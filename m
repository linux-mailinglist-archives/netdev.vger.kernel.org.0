Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3ECA617BBF
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiKCLjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiKCLje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:39:34 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACD212AAB
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 04:39:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CC/LiKdVZWvoq0Lz8U+LSIelXRMXK1VdBgRA4CAcX6rBEOd0G4hamv1lNPPojnYPoFAIzvPq+ZAGohaktHbT2OPxVls/cLG+/+i/99nZMGoUlCT09pS8heSSdlY4kQYYvMeW4gUQxMi3zTSuCjGLCnKCKlluS2esS9hoTMhR7kF8ABgcUwWa/fu0yTfucaYRGOQ3+V2wQ/djxwJJbEREHU2fcJ5XcFXt7Wb1RtYB26RaBTuufZ6Pr3T5yMjIB/VNm9eR1L/QfnRXWuJP1ku+W19F1wprRVl0ZnD5SlvWAIufsvYrnRBsIAdI3WRlJ6d7rLpBlTWCqwKZxyoBFSwyOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbWOd74o1V62nao2aVzCQyn236LRRl31D5Ev3CCYsVI=;
 b=IjMnU7E7DJql1+mQKIKZ2VjtFf0YDvAXlyS9Ia9IKJZ6tLfJoTc5He7lEKF6UL9XL7RzF32FWjCIFHypVIFZKAeri+80D2+dJsDQiX2X3Qnq0PTnu78R/53QtyyX2kInMIVlaLKL57P/F/d+04uXesS3pVrYjL5zxM0WZWGIiON/oZ8UfCE+l2S2W/gbsyLuOXrxDHLuovc30DNn+bBW58fd93wufnm5M0KNalD7pHIgoCAGm35X++/ctcaZJwcWvkVZsXbJji3sUNB2GkUqPoJ2J2ggD7HKsEIq5KOqHixKfBKIj8nX2LqvMUtoWSbtxao44pNvtNf/+j/iKHkV7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbWOd74o1V62nao2aVzCQyn236LRRl31D5Ev3CCYsVI=;
 b=cBFQubr9+wUhlQbnAfSSbMSF4MftOS4mC2mnQ9xFpTelQ92eUF422pGWBSgrO5eqriGym7BhQR0QPm5iflcbEITwp8cdlP00o0l5m6dIUDAyLjsG7TpVloh8KDYOo5VpGbEhOUGM7v/+WLZKRgoSPl49H9C4gEfaoii0A2px4AI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9244.eurprd04.prod.outlook.com (2603:10a6:20b:4e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 11:39:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Thu, 3 Nov 2022
 11:39:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/4] net: phy: aquantia: add AQR112 and AQR412
 PHY IDs
Thread-Topic: [PATCH net-next 1/4] net: phy: aquantia: add AQR112 and AQR412
 PHY IDs
Thread-Index: AQHY7efZqJAsyK95Xk+CdZ0qvDUg3a4qM5SAgALid4A=
Date:   Thu, 3 Nov 2022 11:39:28 +0000
Message-ID: <20221103113927.n3a5d7cll3ekazor@skbuf>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-2-vladimir.oltean@nxp.com>
 <b7683eb0-89af-33b3-f8ab-4bfbe0825cbe@seco.com>
In-Reply-To: <b7683eb0-89af-33b3-f8ab-4bfbe0825cbe@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9244:EE_
x-ms-office365-filtering-correlation-id: df3c8d47-4be7-49a2-8b02-08dabd901127
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MdM5BC4WRm2k/njE63FPfFHwiJw8hUSWoTGHW1Pgas9acCgDu8BgI6GZEgBAMXfnunV0SKn6CSd1c9fntVEULldepC90wpRhh2QlwCTBc7H95vMq3AwBM1444QqC10PgajNbMQKrtVpUd0WZiit26mNVpJGupVTxI1oP0w9qqfze2LE4F3NBRTkEkvGQBpY10IAtJUJCv/vczyq70ZtPwgj7dBKQhHNN1UuXBC1QNH4j32e88PgrKbtkfDgw9TunZ2WGLOWwc8Jg3B3dZSogpGXmrYt4Q9TMw0ktq4kjbAuzubdAOEjpq1fLzgh103HfEfmHeC6S/HqYnOMc1M6le586fTq2hN6W/5E6QJavj1NxYWY9qUpF/JM8T1BeEyQHPFLF7Vm0Mse1VUakOyglYNcJYAXj5r09pMerH5ILOaDc6vS7q7d/8yPbFPAgg7h5EVpALqIOCya8+nyTkyLgP0BRQK1owM62MKW1AKcBu4H/TUB4DAmu8mbCOapDj03HYiNHvLbFt3T/n7eFbhybljHTXY6Vg55eXQFdxPoA6eYVwn7ktMndui0fmffax9/wf6WkliGcV9/bN75GNO7wFAvmvdp7kVutFv+bfS0AHs9NDVyq62AJxGVmqbowrs0l0MyRB86UX8DFoW+4cQy3gxJPmVZV7nkfYbqiQh3NyU2vNUPWFoaubEZXCp5BjFGkKvYtvcTEnOfGKAYgxliPCoAk40hFDv5keJ0MdCjPn6vvAuYrP+TzrpaficNFSaU2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(86362001)(38100700002)(122000001)(38070700005)(41300700001)(316002)(7416002)(8936002)(5660300002)(66476007)(54906003)(66556008)(66446008)(64756008)(6916009)(66946007)(8676002)(76116006)(4326008)(91956017)(44832011)(2906002)(33716001)(186003)(1076003)(9686003)(83380400001)(6486002)(71200400001)(478600001)(53546011)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?DkKJe2RjPgYyoUqeE2uGIx/kySEHNx5DyCaY/kVNYGgw2KWs2ugKWRLDjM?=
 =?iso-8859-1?Q?kZh/bMCWDjMug4zNn0pv2hUslb6s/pSM0V5ejgfMqdbGHARfyGQ4L0M8rE?=
 =?iso-8859-1?Q?XnLmZfnUkV8DWaBPFmpDxzEYQMvALBOh86VrCJwBBEUtoNZDpbFfgqaP/Z?=
 =?iso-8859-1?Q?QJ5E2y3DSFEeuA5ZuhQPZxMvLALlCjfKCTT0QnRkwcoffapasafBnyUxfo?=
 =?iso-8859-1?Q?OxCsS4ZeLhIUrVFez3vs1K/WyyAZJ3bv7vNqB9hR1Q7o8XF5tl+WWZwS6R?=
 =?iso-8859-1?Q?Qmu+sWmEeywiQ8mPfTpeOF+T5kjB72z5vxuv2njaRIMl2gs8aTwPF4E3ZI?=
 =?iso-8859-1?Q?Y8Eq+ArsTI7e5Q5o4qCnZu8ZPglp3D6C9jxsV/w2HcE/RzGsgS4wj+seJ7?=
 =?iso-8859-1?Q?U94WSRgpCqrhxIc9Kk+j4XbGEdixHBZyc4UjcbfA/jEWC2doOoxDMuBon9?=
 =?iso-8859-1?Q?5+omtSZW/StLVDXKRQY04vh/SPslKxaMVYfZw4Iz8jpP2Db9gXgRnEVWLp?=
 =?iso-8859-1?Q?tyZ4whH4kQC1eLwTHqFBvYXhS3Ify2UDWgHu5wPpCwJu6TRzS7Ip9jYkmy?=
 =?iso-8859-1?Q?wrOghuyvb1/UAclts+6Jh+TEPJhaFxm/4os6r3J0XFlOh9wApQ+NH99oJM?=
 =?iso-8859-1?Q?w9Bn2q0ayolE6wPhSdGLTGoOY1GvQpcmGSjnXp+yZOXhVehr0//gK52Fh0?=
 =?iso-8859-1?Q?NElaDVuz8DJQY3FwoEGZWh1aFmQT5lCVVx1jUKUVChOhM3wqOUWVnJWPkA?=
 =?iso-8859-1?Q?ZOLhBoi09bgj5mUIBrWwsbnT5w/pRjXuGN5NCn9zHFfXNWfKaY9JBAWqlI?=
 =?iso-8859-1?Q?E2DL1UzPAIFQ/yQ/1hC8tyhWG8iQTGAiZqYZkkGyggtT7TmrvKdty4/mRN?=
 =?iso-8859-1?Q?ApCm2H536oE2sP8uyf+6EnnWlrsi606oW4YGnfOs/9k81vjiaygsAaG63r?=
 =?iso-8859-1?Q?BH8i9aN/j0A4zcLsrOIR0y5QPLbdlc/MeV2Yj1kYxL7wUCmLNb01ag4oWN?=
 =?iso-8859-1?Q?uVFUNZRkYJtJwP3fo6DMNs3w7nT7OHjgGdLYEITCnjqq3H6JyX3UXCGD8b?=
 =?iso-8859-1?Q?GEwthoLFCS6hTrIpIq0b8N2odGpPCetoBESnjEsvxAxTl/AAKdKRY+WiCA?=
 =?iso-8859-1?Q?JFkJWbPxj+xIP5beC3hypqPti9ZugOZZ9tw3zdcaGzs6anMA/SpVw98Zuw?=
 =?iso-8859-1?Q?LOrYGxTbYAsXnQxyD/+G9HweAP1R49f5BlALgrJ3CF5xkMgmj/Ezl45Fig?=
 =?iso-8859-1?Q?R+XD8l4uMwJ0aCKZuCYjWzB5lE4C4Jbh1fmXPw8OU0TDQxOq5PL5dI1mLT?=
 =?iso-8859-1?Q?jzyyg+V2Rg5R9hoOO4OrpQ0SZdcJ3x4oZTuIH3INSiWyVXXOE4LSQSZg85?=
 =?iso-8859-1?Q?4CLSNfRcLoe/hwPVO1H9YGlb3kpWRelwM2xthyRjuzQK38SvIDdfhucXfb?=
 =?iso-8859-1?Q?04syZEDcyJ9H1xBnZrIX/1BJdfve8U+Tznr5ZlkvvCmlxhPs786OjCYcQg?=
 =?iso-8859-1?Q?80AcE6Jif02wTtjruekLVbN+Tu9kig2brt+H90Wk4rfzDzHlA3D3tgNeUj?=
 =?iso-8859-1?Q?JXs/XwdeZxVRvLQyEgnLAO2UBIlRcDnyBvZ/gbEiZL6zUFz98TzZ0vgTly?=
 =?iso-8859-1?Q?SdPnNaQZDlZWhJnOICrEW0AcDA60S+b6hM3t/21ua3XraJxgxShHisfg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <966407491E8D8544954FE5B9DA6F696E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3c8d47-4be7-49a2-8b02-08dabd901127
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 11:39:28.6934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5LDk3m+1/39jdTwRFBULcA8M76syyaAt/2DzXEi8pQvBS0IA08R6WnvKHkpdCE6SHxG81lwezOq1ZvN088oWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9244
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

On Tue, Nov 01, 2022 at 11:36:23AM -0400, Sean Anderson wrote:
> On 11/1/22 07:48, Vladimir Oltean wrote:
> > These are Gen3 Aquantia N-BASET PHYs which support 5GBASE-T,
> > 2.5GBASE-T, 1000BASE-T and 100BASE-TX (not 10G); also EEE, Sync-E,
> > PTP, PoE.
> >=20
> > I am a bit unsure about the naming convention in the driver. Since
> > AQR107 is a Gen2 PHY, I assume all functions prefixed with "aqr107_"
> > rather than "aqr_" mean Gen2+ features. So I've reused this naming
> > convention.
>=20
> In Aquantia's BSP there are references to 6 generations of phys (where
> the "first" generation is the first 28nm phy; implicitly making the 40nm
> phys generation zero). As far as I can tell these are completely
> different from the generations of phys you refer to, which seem to me
> marketing names. Unfortunately, they don't have a mapping of phys to
> generations, so I'm not even sure which phys are which generations. The
> datasheets for all but the latest phys seem to have gone missing...
>=20
> In any case, if it works, then I think it's reasonable to use these
> functions.

Sorry, I admit I don't know either the lithography process in which the
PHYs are produced, or the way in which PHYs are referenced in Aquantia
BSPs. I only have access to product datasheets confidentially licensed
to NXP (with registers, packaging and so forth), and the fact that they
are Gen2 or Gen3 is mentioned in the first statement of that document.
I also googled "aqr412" and came up with a product brief on the Marvell
website titled "Marvell=AE AQRATE GEN3 Ethernet PHYs" which lists the 112
and 412.=
