Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFC557CD92
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiGUO0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiGUO0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:26:30 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150050.outbound.protection.outlook.com [40.107.15.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E2C72ED3;
        Thu, 21 Jul 2022 07:26:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXRN4adteelGRf+pNkX+5vRRziZZQhskVjzi6r2nqfYMr9We3BDBNCWwQdntnDV4jBNO3bxSfJjTDWO4sWXMx6wXgffe45TbR9+MSbuh1hOunUH14zQvFDinJBSN+Wr+wq3G/dRgdT+4MSDsaueW6Bg0Q5SDTnuBMw47OPuOyPt+ylhauQ6FeVfzhH/I1KXvNCLtvp/WWR9b7CgWsR4zAya5P1xSbZXBEfHyNfumnWFrwF6pwvsUot3K6KHgkEGnqvvlNAk79j9KjbUbogpqujTq0qvjjWHJuQwZLgzKGv7ihO/IUPujTl5UZHWN2ukIW4N3oHw1Hw7u+6ogPe9Oyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dbn0xb72kD9/HT5ympexUj2da69n66xsy+uGC6BMCrI=;
 b=nMoDjUT5/+C7tjL5h9tnjealDDH+Dh9ecQhSZvfVGh2sEHM5z8d6ouocZUEaFB4k8cwssYtkbe+CvpXiWHl8dOiWksi9QGk95m22BLZja+fIRBUyCAXvFTD1fuj3/NRN7hKl4q88PrUOdNlfVNDP4i5kmuiO8vcAql6ShlN7ZmVQLC7FeBZDE9ibEA2K6ea39GJ7LoGMOVRMX5lICb8zfKtpHGYl6XgpqRGRXU2nvpIstnbs65+h+wiaLUgXcwGgzz4sNe4o7BW2m5tjAmCemyXffPILm1vKE6rJgiD4KPVIBndsYzbA1c2s+ioZ5MOKtHAhoO5yKkH78OI8TEa2CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dbn0xb72kD9/HT5ympexUj2da69n66xsy+uGC6BMCrI=;
 b=jXoKoZcTdBJobKyyv3hHo9Tfj0w6dffGWeSqWIi+IWdcpi7++2R3QY/Kx1wCrW5B/KpBE3LZUwsRkNcLA2KG38COlwRlAOt1YKtKexW5TDekYQYk1voL2OxIk3XXXIDLZkxL2Pw6opTObPV2FmbdTfes3jm3hlqGSnopfCQPg/0=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by AM6PR04MB4999.eurprd04.prod.outlook.com (2603:10a6:20b:2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 14:26:25 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 14:26:25 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH net-next v3 00/47] [RFT] net: dpaa: Convert to phylink
Thread-Topic: [PATCH net-next v3 00/47] [RFT] net: dpaa: Convert to phylink
Thread-Index: AQHYmJZJ/hG18GH0IEKaWS+j6cSegK2I6SsQ
Date:   Thu, 21 Jul 2022 14:26:24 +0000
Message-ID: <VI1PR04MB5807612C5CD9C5976FC92C4EF2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cbdba59-ecb9-4164-0cfd-08da6b24fdff
x-ms-traffictypediagnostic: AM6PR04MB4999:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kB5xymA+THpYOdl8/TmJtCoF2Dyc3PGj9z6EHakDJuIOFDkFFC/wf4F6fI7w4sODWXEpDpdBpMqkBFHODawpu0tyejPLYIs1EsReLJXQGeRf1wCydzEUDTW3LFr6ZCn1dr9ZgUmKFNlVWbgSBobnpONX/NB2x40uOsk9qq9PTeZ8ZL+rK1hmAOdaSd3U8M3LIuY+xnkAsrT2PwY/+Vz8xsHzYmrpRLDror4zuSCWbU002SfcpcUGUcLNCkyxTABoeR7dUiEaiBolZwvWQmFp2kAz3MbBrHqHI2QyrQWrrwyjPUdBq7RMdoGTPB6Lq9YC4roemmLzfxIuRU//udnrmUT83HnGGbs0wnr4Q8AicWbJe227lcMaHiYPbNI0r8YQXICcIvSex/jDRV6G6t9gKj850DXg6a+85KVL/K+W7wU5oXi2kwADa2hU+NEUEx5wjVSJUVa7DAcafacGIZATbelWwNxu+wH2hY+lSUAladqYxzbB7IrNqYMCalGAXpARkIuE60iJwsEUtoe3dctLBuy7dfKCj9LQBNxIps5ncHyZ/bzHh2BadeZFqkTZM3s1DghUBB34ho1hSGavdPUZiLLF9iRbVDBrmaDQpDyk1uA9Q3Bh2GMF/4eRQxE6/ohUORMxqCS23mPCVuSqqZjl7QdaHy6+cvBbXDtDvUmadpg9IyitEpPXQ21ORqwzvOgdgJlkyTnGChZiryYcXBoV+bnKALLwTXVvqjcG1LyMLalQ4QHP0T352EnVP57kHUgYVWdEu+KBUdwvPZckOffEByVFwm0jDPjoCJjrcOLhJrWVQcOLKxyoL88hK85kNMg/ZT+Y7cj0f9mrhYl3cjzlUA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(71200400001)(38100700002)(478600001)(38070700005)(9686003)(6506007)(7696005)(55236004)(53546011)(966005)(41300700001)(316002)(186003)(26005)(110136005)(55016003)(54906003)(5660300002)(64756008)(66446008)(66556008)(30864003)(7416002)(8676002)(66476007)(66946007)(8936002)(76116006)(52536014)(83380400001)(2906002)(33656002)(122000001)(4326008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eKFdSUy5Rg1Rl19QP/0VqOxgVKUUYYrcnczlpd2b9NDH8qcXFUgPL4kGfDOG?=
 =?us-ascii?Q?LBDMA+1bDWjPuLHO4AVTsKzXssaqVC/26yAaEVNnC7J8yYhxVwXIF8XeLrhM?=
 =?us-ascii?Q?nYzIfAKS8Jo26ief0QI1KVUb49rHYEk8IRhOAu7t7N22Pz4gF++TmKmzjrHy?=
 =?us-ascii?Q?p4Vcc6y3m7mm34xMNFBlYj+I+504xkNJKr74IGpF0b1Xvy4dvn8nB6ZvpPSV?=
 =?us-ascii?Q?l14JHnd16IBQehUiRYGyLUS0kyWgjypJeacjy1WYhLMAHBDX/3pfbs37XVxY?=
 =?us-ascii?Q?lCNRNRD6KkJvF+JpNJ/Pyt4PTsBkX0OXRHrnaAEYdNRH6rhPS/qf7vSS/tKB?=
 =?us-ascii?Q?JpDAOtO1WwI9wzUEwkCjnw3HsAaq6P7TCgka576HNr897yALzw6ecqt17PXq?=
 =?us-ascii?Q?QwkrVD75sVtijR0vm5x/52dt/3zwl8QiRZoF0J9mwbhDHY0IpuS5sFnWn7oh?=
 =?us-ascii?Q?lYIis4M6lyD5vIoq101y/E8tjiDcJsGyKJuOAkcUjzkZTnkB2zRU1bqXqjHB?=
 =?us-ascii?Q?n84ShyNQomqzEXx02fmJ4NzMarBxPb3kl81oJsGtD0ggya3PJX953Xr7F5z8?=
 =?us-ascii?Q?YprxgNzDwbhTJzSfz93eMjhB60emdpbG4iqcvh+rZx2rL8KLjGwg8cR4XVRR?=
 =?us-ascii?Q?w5OeeKJjkbEJHm9HfBTIzKBCyoo46CMc34CSHksw6yKeNspP3Ua0GimhQ7fV?=
 =?us-ascii?Q?YCQTh7otWCfv0KMghLTDe5irN5X48Bu8lthYI2K0Va08+b6gHt52ONdqSysJ?=
 =?us-ascii?Q?K2u0mJh7R//0RRQsvp37CH+qrSglwv9Gax0K1nZ4Co2qWsSnbEOfX7dwumjE?=
 =?us-ascii?Q?s/mRajTuiiSS1GPMq9vBxkl7zk5zr3T1Bf1p6SVObQJIeCvF/w7tViu7Jm7p?=
 =?us-ascii?Q?0xEppNAcZk12aOyHmnviqomIESw1X2J0NCdab+VmIJ133WQHxsGvfGcYUu4x?=
 =?us-ascii?Q?xkiJ+ZuPDiuwErxWWRqgywRW3K5B+Ros+NgVsIMja09zk1FshV3II2kIc1dy?=
 =?us-ascii?Q?YCchIaPbFUr/HJgO78sapaNKz4Ct9HDGptwxZlOP7CusFvGzVUV+HPBFZVv0?=
 =?us-ascii?Q?wP/8kftruqhO5EA5VCKuJEuUyvGkXlENpGwoZBq1eR8d3l5Zgh4oDknnwfMV?=
 =?us-ascii?Q?98u2Le11BAIjh+79P0fuvZSVbfZtYWULcFQifSn8loyg7jvvJw6TbFl3DYyr?=
 =?us-ascii?Q?KHNqAC4NImMakHWMTkeCd6D2H4K8HphFwYumjaPdkvrI883Kdf0c+mID+cG4?=
 =?us-ascii?Q?ui85rDo13CKdJ+YU0LcyZ7p5QhDWmqBq24bbtx1g3l/mUpNtPirxre9hwWZz?=
 =?us-ascii?Q?LGmMWM6CLVVBrlw3vZW3F7rj95l5XzdRksGqOuOcdOs1jPJivqDviceuRr1v?=
 =?us-ascii?Q?0vjJdnXeZtLsxSe/0JU7INZcrJL/CGYLzaprkVuwoEDphlRxwwlR/4rEPU/P?=
 =?us-ascii?Q?jS4UO8+tHQxmvOF9PAcMekINOLRoeo8xyLv60cDacncL24t1RwT8NgcbwNmW?=
 =?us-ascii?Q?16TNr5JALNaOVxMgsr6t/tHEJwuvjIjKLaXJcSpWlJAFshS9AkdnGdyFsd1G?=
 =?us-ascii?Q?68W67ocj54aPfBX+hD69FTqrO78JihH/2t/OkDx2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbdba59-ecb9-4164-0cfd-08da6b24fdff
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2022 14:26:25.0379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SmcHPUiKi11wMEHPzRdsXSIcp0pJAfhK423q0eUv8SBdxu1NZwjOKaonh5z2VtJ8Pb1M898ivqQ6EyZ7C0+kDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4999
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Sean Anderson <sean.anderson@seco.com>
> Sent: Saturday, July 16, 2022 0:59
> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>;
> netdev@vger.kernel.org
> Cc: Paolo Abeni <pabeni@redhat.com>; Eric Dumazet
> <edumazet@google.com>; linux-arm-kernel@lists.infradead.org; Russell
> King <linux@armlinux.org.uk>; linux-kernel@vger.kernel.org; Sean Anderson
> <sean.anderson@seco.com>; Alexandru Marginean
> <alexandru.marginean@nxp.com>; Andrew Lunn <andrew@lunn.ch>;
> Benjamin Herrenschmidt <benh@kernel.crashing.org>; Heiner Kallweit
> <hkallweit1@gmail.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; Jonathan
> Corbet <corbet@lwn.net>; Kishon Vijay Abraham I <kishon@ti.com>;
> Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>; Leo Li
> <leoyang.li@nxp.com>; Michael Ellerman <mpe@ellerman.id.au>; Paul
> Mackerras <paulus@samba.org>; Rob Herring <robh+dt@kernel.org>;
> Shawn Guo <shawnguo@kernel.org>; Vinod Koul <vkoul@kernel.org>;
> Vladimir Oltean <olteanv@gmail.com>; devicetree@vger.kernel.org; linux-
> doc@vger.kernel.org; linux-phy@lists.infradead.org; linuxppc-
> dev@lists.ozlabs.org
> Subject: [PATCH net-next v3 00/47] [RFT] net: dpaa: Convert to phylink
>=20
> This series converts the DPAA driver to phylink. Additionally,
> it also adds a serdes driver to allow for dynamic reconfiguration
> between 1g and 10g interfaces (such as in an SFP+ slot). These changes
> are submitted together for this RFT, but they will eventually be
> submitted separately to the appropriate subsystem maintainers.
>=20
> I have tried to maintain backwards compatibility with existing device
> trees whereever possible. However, one area where I was unable to
> achieve this was with QSGMII. Please refer to patch 4 for details.
>=20
> All mac drivers have now been converted. I would greatly appreciate if
> anyone has QorIQ boards they can test/debug this series on. I only have a=
n
> LS1046ARDB. Everything but QSGMII should work without breakage; QSGMII
> needs patches 42 and 43.
>=20
> The serdes driver is mostly functional (except for XFI). This series
> only adds support for the LS1046ARDB SerDes (and untested LS1088ARDB),
> but it should be fairly straightforward to add support for other SoCs
> and boards (see Documentation/driver-api/phy/qoriq.rst).
>=20
> This is the last spin of this series with all patches included. After nex=
t
> week (depending on feedback) I will resend the patches broken up as
> follows:
> - 5: 1000BASE-KX support
> - 1, 6, 44, 45: Lynx 10G support
> - 7-10, 12-14: Phy rate adaptation support
> - 2-4, 15-43, 46, 47: DPAA phylink conversion

Please also send patches 15-38 separately from the DPAA1 SerDes and phylink=
 set for easier review

> Patches 15-19 were first submitted as [1].
>=20
> [1] https://lore.kernel.org/netdev/20220531195851.1592220-1-sean.anderson=
@seco.com/
>=20
> Changes in v3:
> - Manually expand yaml references
> - Add mode configuration to device tree
> - Expand pcs-handle to an array
> - Incorperate some minor changes into the first FMan binding commit
> - Add vendor prefix 'fsl,' to rgmii and mii properties.
> - Set maxItems for pcs-names
> - Remove phy-* properties from example because dt-schema complains and
> I
>   can't be bothered to figure out how to make it work.
> - Add pcs-handle as a preferred version of pcsphy-handle
> - Deprecate pcsphy-handle
> - Remove mii/rmii properties
> - Add 1000BASE-KX interface mode
> - Rename remaining references to QorIQ SerDes to Lynx 10G
> - Fix PLL enable sequence by waiting for our reset request to be cleared
>   before continuing. Do the same for the lock, even though it isn't as
>   critical. Because we will delay for 1.5ms on average, use prepare
>   instead of enable so we can sleep.
> - Document the status of each protocol
> - Fix offset of several bitfields in RECR0
> - Take into account PLLRST_B, SDRST_B, and SDEN when considering whether
>   a PLL is "enabled."
> - Only power off unused lanes.
> - Split mode lane mask into first/last lane (like group)
> - Read modes from device tree
> - Use caps to determine whether KX/KR are supported
> - Move modes to lynx_priv
> - Ensure that the protocol controller is not already in-use when we try
>   to configure a new mode. This should only occur if the device tree is
>   misconfigured (e.g. when QSGMII is selected on two lanes but there is
>   only one QSGMII controller).
> - Split PLL drivers off into their own file
> - Add clock for "ext_dly" instead of writing the bit directly (and
>   racing with any clock code).
> - Use kasprintf instead of open-coding the snprintf dance
> - Support 1000BASE-KX in lynx_lookup_proto. This still requires PCS
>   support, so nothing is truly "enabled" yet.
> - Add support for phy rate adaptation
> - Support differing link speeds and interface speeds
> - Adjust advertisement based on rate adaptation
> - Adjust link settings based on rate adaptation
> - Add support for CRS-based rate adaptation
> - Add support for AQR115
> - Add some additional phy interfaces
> - Add support for aquantia rate adaptation
> - Put the PCS mdiodev only after we are done with it (since the PCS
>   does not perform a get itself).
> - Remove _return label from memac_initialization in favor of returning
>   directly
> - Fix grabbing the default PCS not checking for -ENODATA from
>   of_property_match_string
> - Set DTSEC_ECNTRL_R100M in dtsec_link_up instead of dtsec_mac_config
> - Remove rmii/mii properties
> - Replace 1000Base... with 1000BASE... to match IEEE capitalization
> - Add compatibles for QSGMII PCSs
> - Split arm and powerpcs dts updates
> - Describe modes in device tree
> - ls1088a: Add serdes bindings
>=20
> Changes in v2:
> - Rename to fsl,lynx-10g.yaml
> - Refer to the device in the documentation, rather than the binding
> - Move compatible first
> - Document phy cells in the description
> - Allow a value of 1 for phy-cells. This allows for compatibility with
>   the similar (but according to Ioana Ciornei different enough) lynx-28g
>   binding.
> - Remove minItems
> - Use list for clock-names
> - Fix example binding having too many cells in regs
> - Add #clock-cells. This will allow using assigned-clocks* to configure
>   the PLLs.
> - Document the structure of the compatible strings
> - Convert FMan MAC bindings to yaml
> - Better document how we select which PCS to use in the default case
> - Rename driver to Lynx 10G (etc.)
> - Fix not clearing group->pll after disabling it
> - Support 1 and 2 phy-cells
> - Power off lanes during probe
> - Clear SGMIIaCR1_PCS_EN during probe
> - Rename LYNX_PROTO_UNKNOWN to LYNX_PROTO_NONE
> - Handle 1000BASE-KX in lynx_proto_mode_prep
> - Remove some unused variables
> - Fix prototype for dtsec_initialization
> - Fix warning if sizeof(void *) !=3D sizeof(resource_size_t)
> - Specify type of mac_dev for exception_cb
> - Add helper for sanity checking cgr ops
> - Add CGR update function
> - Adjust queue depth on rate change
> - Move PCS_LYNX dependency to fman Kconfig
> - Remove unused variable slow_10g_if
> - Restrict valid link modes based on the phy interface. This is easier
>   to set up, and mostly captures what I intended to do the first time.
>   We now have a custom validate which restricts half-duplex for some SoCs
>   for RGMII, but generally just uses the default phylink validate.
> - Configure the SerDes in enable/disable
> - Properly implement all ethtool ops and ioctls. These were mostly
>   stubbed out just enough to compile last time.
> - Convert 10GEC and dTSEC as well
> - Fix capitalization of mEMAC in commit messages
> - Add nodes for QSGMII PCSs
> - Add nodes for QSGMII PCSs
> - Use one phy cell for SerDes1, since no lanes can be grouped
> - Disable SerDes by default to prevent breaking boards inadvertently.
>=20
> Sean Anderson (47):
>   dt-bindings: phy: Add Lynx 10G phy binding
>   dt-bindings: net: Expand pcs-handle to an array
>   dt-bindings: net: Convert FMan MAC bindings to yaml
>   dt-bindings: net: fman: Add additional interface properties
>   net: phy: Add 1000BASE-KX interface mode
>   [RFT] phy: fsl: Add Lynx 10G SerDes driver
>   net: phy: Add support for rate adaptation
>   net: phylink: Support differing link speeds and interface speeds
>   net: phylink: Adjust advertisement based on rate adaptation
>   net: phylink: Adjust link settings based on rate adaptation
>   [RFC] net: phylink: Add support for CRS-based rate adaptation
>   net: phy: aquantia: Add support for AQR115
>   net: phy: aquantia: Add some additional phy interfaces
>   net: phy: aquantia: Add support for rate adaptation
>   net: fman: Convert to SPDX identifiers
>   net: fman: Don't pass comm_mode to enable/disable
>   net: fman: Store en/disable in mac_device instead of mac_priv_s
>   net: fman: dtsec: Always gracefully stop/start
>   net: fman: Get PCS node in per-mac init
>   net: fman: Store initialization function in match data
>   net: fman: Move struct dev to mac_device
>   net: fman: Configure fixed link in memac_initialization
>   net: fman: Export/rename some common functions
>   net: fman: memac: Use params instead of priv for max_speed
>   net: fman: Move initialization to mac-specific files
>   net: fman: Mark mac methods static
>   net: fman: Inline several functions into initialization
>   net: fman: Remove internal_phy_node from params
>   net: fman: Map the base address once
>   net: fman: Pass params directly to mac init
>   net: fman: Use mac_dev for some params
>   net: fman: Specify type of mac_dev for exception_cb
>   net: fman: Clean up error handling
>   net: fman: Change return type of disable to void
>   net: dpaa: Use mac_dev variable in dpaa_netdev_init
>   soc: fsl: qbman: Add helper for sanity checking cgr ops
>   soc: fsl: qbman: Add CGR update function
>   net: dpaa: Adjust queue depth on rate change
>   net: fman: memac: Add serdes support
>   net: fman: memac: Use lynx pcs driver
>   [RFT] net: dpaa: Convert to phylink
>   powerpc: dts: qoriq: Add nodes for QSGMII PCSs
>   arm64: dts: layerscape: Add nodes for QSGMII PCSs
>   arm64: dts: ls1046a: Add serdes bindings
>   arm64: dts: ls1088a: Add serdes bindings
>   arm64: dts: ls1046ardb: Add serdes bindings
>   [WIP] arm64: dts: ls1088ardb: Add serdes bindings
>=20
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  |    1 +
>  .../bindings/net/ethernet-controller.yaml     |   10 +-
>  .../bindings/net/fsl,fman-dtsec.yaml          |  172 +++
>  .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |    2 +-
>  .../devicetree/bindings/net/fsl-fman.txt      |  133 +-
>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml |  311 ++++
>  Documentation/driver-api/phy/index.rst        |    1 +
>  Documentation/driver-api/phy/lynx_10g.rst     |   73 +
>  MAINTAINERS                                   |    6 +
>  .../boot/dts/freescale/fsl-ls1043-post.dtsi   |   24 +
>  .../boot/dts/freescale/fsl-ls1046-post.dtsi   |   25 +
>  .../boot/dts/freescale/fsl-ls1046a-rdb.dts    |   34 +
>  .../arm64/boot/dts/freescale/fsl-ls1046a.dtsi |  179 +++
>  .../boot/dts/freescale/fsl-ls1088a-rdb.dts    |   87 ++
>  .../arm64/boot/dts/freescale/fsl-ls1088a.dtsi |   96 ++
>  .../fsl/qoriq-fman3-0-10g-0-best-effort.dtsi  |    3 +-
>  .../boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi     |   10 +-
>  .../fsl/qoriq-fman3-0-10g-1-best-effort.dtsi  |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi     |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi      |    3 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi      |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi      |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi      |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi      |    3 +-
>  .../boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi      |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi     |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi     |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi      |    3 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi      |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi      |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi      |   10 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi      |    3 +-
>  .../boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi      |   10 +-
>  drivers/net/ethernet/freescale/dpaa/Kconfig   |    4 +-
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  132 +-
>  .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  |    2 +-
>  .../ethernet/freescale/dpaa/dpaa_ethtool.c    |   90 +-
>  drivers/net/ethernet/freescale/fman/Kconfig   |    4 +-
>  drivers/net/ethernet/freescale/fman/fman.c    |   31 +-
>  drivers/net/ethernet/freescale/fman/fman.h    |   31 +-
>  .../net/ethernet/freescale/fman/fman_dtsec.c  |  674 ++++-----
>  .../net/ethernet/freescale/fman/fman_dtsec.h  |   58 +-
>  .../net/ethernet/freescale/fman/fman_keygen.c |   29 +-
>  .../net/ethernet/freescale/fman/fman_keygen.h |   29 +-
>  .../net/ethernet/freescale/fman/fman_mac.h    |   34 +-
>  .../net/ethernet/freescale/fman/fman_memac.c  |  864 +++++------
>  .../net/ethernet/freescale/fman/fman_memac.h  |   57 +-
>  .../net/ethernet/freescale/fman/fman_muram.c  |   31 +-
>  .../net/ethernet/freescale/fman/fman_muram.h  |   32 +-
>  .../net/ethernet/freescale/fman/fman_port.c   |   29 +-
>  .../net/ethernet/freescale/fman/fman_port.h   |   29 +-
>  drivers/net/ethernet/freescale/fman/fman_sp.c |   29 +-
>  drivers/net/ethernet/freescale/fman/fman_sp.h |   28 +-
>  .../net/ethernet/freescale/fman/fman_tgec.c   |  274 ++--
>  .../net/ethernet/freescale/fman/fman_tgec.h   |   54 +-
>  drivers/net/ethernet/freescale/fman/mac.c     |  653 +--------
>  drivers/net/ethernet/freescale/fman/mac.h     |   66 +-
>  drivers/net/phy/aquantia_main.c               |   86 +-
>  drivers/net/phy/phy.c                         |   21 +
>  drivers/net/phy/phylink.c                     |  161 +-
>  drivers/phy/freescale/Kconfig                 |   20 +
>  drivers/phy/freescale/Makefile                |    3 +
>  drivers/phy/freescale/lynx-10g.h              |   36 +
>  drivers/phy/freescale/phy-fsl-lynx-10g-clk.c  |  438 ++++++
>  drivers/phy/freescale/phy-fsl-lynx-10g.c      | 1297 +++++++++++++++++
>  drivers/soc/fsl/qbman/qman.c                  |   76 +-
>  include/linux/phy.h                           |   42 +
>  include/linux/phylink.h                       |   12 +-
>  include/soc/fsl/qman.h                        |    9 +
>  69 files changed, 4408 insertions(+), 2356 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-
> dtsec.yaml
>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-
> 10g.yaml
>  create mode 100644 Documentation/driver-api/phy/lynx_10g.rst
>  create mode 100644 drivers/phy/freescale/lynx-10g.h
>  create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g-clk.c
>  create mode 100644 drivers/phy/freescale/phy-fsl-lynx-10g.c
>=20
> --
> 2.35.1.1320.gc452695387.dirty

