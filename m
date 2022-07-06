Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF01568F8C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiGFQqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbiGFQp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:45:58 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80083.outbound.protection.outlook.com [40.107.8.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B5228E3F
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:45:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wb4wTjfCeA4EpbacLuuEJynXlch23QR65la9nz7kqUlVK5ScqAb8NreRvrCqg8yAJskOi8AiwQXmQcXzGamJ6FGFSnhRbH3FDNQ7uBnSo95SxMs1wXgSnshsmB+TAePb283luuIO0sb0++RSX4bsNHJNkcDM9P6dvRqzPt3J5YTCggSi1YgIqM0hkGegbB8o+dUZc/x69/YQ4LtSfL5YrBEkRHSMnW+ohxd0XImDJXy3l0qL/bA0tItajS0w0wlhAcld3T3fM3sh2FlkoPvw+L6JDkIY51WpChKqJmW39DdGu/kkz40kUoVokC//wHUr07OsGH6D3nMXxiMN8Mx6rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcNgcG6Ot0K6hHs3oWCxdldWWQDH/AvHG7PuI+fuziw=;
 b=mx5T5HDSEaswqCLMl+XDA4CHrk1bcHOBSctUs31JSBCOChDITrT0XcpLr52p73QthJdEjYoRCfxRQ2cupIMmSt6hYWGMgKgfnn7OnI+WrSXV1YjzK1EBlVurkA16LtKcbS5Kp1hM6Tb9HKnzFy7vgeClcp4JEpi7sqmcx7QXd5zX6lFgrzx/L40TVtxxuTqhD/uLDSwKZwYoQab7Z0xjlEMJqk9L9qBCbG+Zlx4jTCk6D5RclH1esmU+L0OmCM9EjFKxdp0Mn+L1RIAT37gnz9OgcLEmTG/VJ22NXlyb2fTy3EVdVqeYz/jr2hKEcRNGjPVCne8aeKA6+Ya/yPvHoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rcNgcG6Ot0K6hHs3oWCxdldWWQDH/AvHG7PuI+fuziw=;
 b=qbD00qu/42bGtKzrPDLxPuFTGn+1P6UBLDpgOLNpyqCnBktg+26dBqP/PeCpDSf2p1oyj12pMtLLIzH1cP/BpuEoGZA2jew8/JUFGGvhUCGyGWw/RHWv4vnnsjm9i/7zhZGpkSf/wfQiYQy1FCV2Rdh9q42xp0H6XvV8CID+EXM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9125.eurprd04.prod.outlook.com (2603:10a6:20b:448::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 16:45:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 16:45:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwA=
Date:   Wed, 6 Jul 2022 16:45:53 +0000
Message-ID: <20220706164552.odxhoyupwbmgvtv3@skbuf>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com>
 <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
In-Reply-To: <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67b8ef26-46ff-4e4a-7cbd-08da5f6efdd3
x-ms-traffictypediagnostic: AS8PR04MB9125:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ThPsue+pigPp5GAks5bxaVJEnYGbTivypBbgqDzAvHsRf/CFjusRFyYc5qwgFY4xrgnAyBgjFfuXAAcM2peNhpuUaqG0JjvmzTwJvRtkNyzBuRu3sfnunG3eLi9lyTIPxEisG0kOgfBDgLa3MskB6LcmZf7NWkQYaPx0TiPzmnAW1/5dUOvnV9Pj4viFv8NW6y6R9VlHw/E0Ku/W2wA0w0RysFPJgYNRVBdPhyX+prb04k2M5Q+O062/TrzvSEuz1XRlo3Bn0w6O+/zdmhMi+32mkajSl4Inpk/w0o8fXf3WDY73yNizpif12mSNiSGkRZSdInGlw7rDdUhpapIA20FC67X27oQT9lAWe8JQoohbpFqKtExrSWXLYTML4/McqcRshjkJrToC+iPtHWy78p3G+qsgYGRUntGawIuDvjgHDsl6ejvzNg7FS57+h6bPZxTgJZD0SAmVZSrz/rs+JEFO/ZfBBc2YZ9dYsGs0DmVJHQvHveS6MscMh5ZY/NFzsOxed7vrBphpZvtEJVj1eicG6M//uSIwMgVQ3u3K9Rujn0rS4m+nDLtVkwQdKKsBM4WaX5tvwzzVCQ2pOCa2x+6O3FE1JeUC4b4e6lSav1T+Q8lwhqW4xFHvTXxW4Fsb7A0CEzT0nXspAuB848O0A593vU8xHC0cGuj0DYASoDGxEQkNh4iaoTO/t0c/PNYIwuKb8PBa2b3p6FlA7zMIicB9QEeTUe1a37S6/0asHG3gMW+vy94+ftAXoGcu6YVOKeu1e5ceiYx/zR3eVcEUxGdDQvciDRI3Sz9hdcVfyhehTnM3uVpasWECO7WutQj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(396003)(136003)(366004)(376002)(346002)(38100700002)(86362001)(9686003)(26005)(6512007)(6506007)(53546011)(41300700001)(5660300002)(33716001)(44832011)(8936002)(7416002)(2906002)(66446008)(1076003)(76116006)(64756008)(478600001)(8676002)(91956017)(122000001)(4326008)(66476007)(38070700005)(6486002)(71200400001)(83380400001)(66574015)(186003)(54906003)(6916009)(66556008)(66946007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gtjJeNvg+GTBiQtSkpNZ1gng+QaIbnezr4oADvADmVH6rH8WlwoGsLwEaazW?=
 =?us-ascii?Q?M3QJwTQNVkpHu81hjwrcL26J5T+ncgbT2w3lS6v1nCYLJ12zo51u01SrIJz0?=
 =?us-ascii?Q?m9JctQSWdW/KfJFKLJL4i/rZ5aiz27bjNYLxrsuv9IydCsP5E1vcpkncsSFi?=
 =?us-ascii?Q?SJpQVMGLtjvnIR4WOrv+yTVfUOrAa/ReILvGfe0x+SAuci232N2jpvBB+JpA?=
 =?us-ascii?Q?Ge5Mp+5traE8ZQbWISBhKC76kSTh8gULf5O+/zTPTziCpIYC26OGQpAsS2QX?=
 =?us-ascii?Q?gFP8pkkDz/2BggB7hERSW1ijlJHqaCz9uABhY1TTQkpaE/VwaAf7T3vf1oYv?=
 =?us-ascii?Q?JEVvt9lMvU8dslQ3vPtfq1kSCkVM6y56ckCihfWm3svlOjyuq9GkUogj0Bf/?=
 =?us-ascii?Q?9JM0Hh9dg/Mwc18ssvdIzM+wedkXF0qd0MgYXJFn/qajRSHda7mA+STFpTbb?=
 =?us-ascii?Q?jYmnGHeIyeDjZjRvvDdn6N2H3HToiHrlo/JdiFmPoKhRWIaZiHXdaNzyqbfj?=
 =?us-ascii?Q?IKin1HA/YEK5HYMTuSp9vL2QO3C5yx77u2Anh/Wg4877MBtMBDHvRSMKBc7O?=
 =?us-ascii?Q?SWR8qtPlFTqsa6ZHOQU6ner1HyPo57W7Fr1AXOIg8HGupkB9yjFzlz+I+Mbq?=
 =?us-ascii?Q?RY4NziPIl1c6LnDPJ343sUcTlKXQA45WEMoB3CiwsSL8hQ7XfF5GFbjGRVVw?=
 =?us-ascii?Q?yD8E+J9BQbG7FCHRiD/GqS9U4fmIbZ1jY8n25i5y5ABTBh5TIjXJ1bDSwiZ6?=
 =?us-ascii?Q?uW0VgmxFUUbd8/0Ad0FukD5avIPr9komUkHMgcFoea4XLIDPu5NuwEXVUhz4?=
 =?us-ascii?Q?fMl0BQETauyiR7WicTuwXJjvJgdJCU+xiGHsOfz2WuRdQeqRzABPEkoLglOi?=
 =?us-ascii?Q?alCy3xnnATuT4bdxipg8CH0Lr4cMk10I56q3w0JppoZAMfRa48kRHSfH3wrm?=
 =?us-ascii?Q?GmuQDzs8fgm3B74UxTgAPuUSSWCRPkhRzq2x2NZiR6ptgLxB7tZuPZrV6Oen?=
 =?us-ascii?Q?JPlsdqBAHw6C6q97C1NVEmI2G62tJGPKZIKadoV6QWlNdhE/uBtPEtp9HjN5?=
 =?us-ascii?Q?BsQDAPWXedThKI7kxgmRhya74APr3HZjjtKEj18dUcBYI1Fp/qURg4fvXoUB?=
 =?us-ascii?Q?xqHl0Vkv78aQLd8wNLeu7zZlQuoRvZEMy2ONVjSp0EzIJfwmAbkcA62rIOPF?=
 =?us-ascii?Q?TotKYCVBxA0rKpNUr+lPsKNWW0D57U38Nw4gttn3tPxO52xLw1UQYSb5x/XL?=
 =?us-ascii?Q?/uWZnsNOU0MHgFngATUWwfRHhKCpbcEHO3wnKONCZq3jiincpnVADu7T6Uib?=
 =?us-ascii?Q?kE8LvUx06gsriEe3FxN1HX+wcBKYXP78GTNVztrpaNK3jKTm8xBJbg7dggmD?=
 =?us-ascii?Q?K30abEMTiMvvt2SFnhAX32x60fP2L3i50tfNXGTi471hIA5SzvmHBcLyPCNF?=
 =?us-ascii?Q?FQfX72NYBDGanpuwqf1LMCURmZdJU0huDy9EL1Ht1cV1svCNrwiXljo9DkXL?=
 =?us-ascii?Q?MmOQ3kcmrLFXO551P3JlyKR5Xd4/60Jfsq/HX0VfJXLb2EEyV6ASq8HuyxP7?=
 =?us-ascii?Q?zq/HIH4DiEUxBkILuiQvLFHsqY8ZnpboGQMgWX3AR1PMkPl5D8eR4xM+G1uz?=
 =?us-ascii?Q?jQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B1442B3D25CBFB409A354C79EF7AAAF5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b8ef26-46ff-4e4a-7cbd-08da5f6efdd3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 16:45:53.5570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1sz6GhEjjtbn4ywPWGtF9xRujnhFEK8gvCod9AN3U+c9GibV3D2Z5xBzLuixnVZhq6axAQCSstYDtmmWFP/UVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9125
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

On Wed, Jul 06, 2022 at 06:33:18PM +0200, Martin Blumenstingl wrote:
> Hi Vladimir,
>=20
> On Tue, Jul 5, 2022 at 7:32 PM Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> >
> > Stop protecting DSA drivers from switchdev VLAN notifications emitted
> > while the bridge has vlan_filtering 0, by deleting the deprecated bool
> > ds->configure_vlan_while_not_filtering opt-in. Now all DSA drivers see
> > all notifications and should save the bridge PVID until they need to
> > commit it to hardware.
> >
> > The 2 remaining unconverted drivers are the gswip and the Microchip KSZ
> > family. They are both probably broken and would need changing as far as
> > I can see:
> >
> > - For lantiq_gswip, after the initial call path
> >   -> gswip_port_bridge_join
> >      -> gswip_vlan_add_unaware
> >         -> gswip_switch_w(priv, 0, GSWIP_PCE_DEFPVID(port));
> >   nobody seems to prevent a future call path
> >   -> gswip_port_vlan_add
> >      -> gswip_vlan_add_aware
> >         -> gswip_switch_w(priv, idx, GSWIP_PCE_DEFPVID(port));
> Thanks for bringing this to my attention!
>=20
> I tried to reproduce this issue with the selftest script you provided
> (patch #1 in this series).
> Unfortunately not even the ping_ipv4 and ping_ipv6 tests from
> bridge_vlan_unaware.sh are working for me, nor are the tests from
> router_bridge.sh.
> I suspect that this is an issue with OpenWrt: I already enabled bash,
> jq and the full ip package, vrf support in the kernel. OpenWrt's ping
> command doesn't like a ping interval of 0.1s so I replaced that with
> an 1s interval.
>=20
> I will try to get the selftests to work here but I think that
> shouldn't block this patch.

Thanks for the willingness to test!

Somehow we should do something to make sure that the OpenWRT devices are
able to run the selftests, because there's a large number of DSA switches
intended for that segment and we should all be onboard (easily).

I wonder, would it be possible to set up a debian chroot?=
