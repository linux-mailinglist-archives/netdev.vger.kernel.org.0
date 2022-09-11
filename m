Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BAE5B4B05
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 02:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIKAol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 20:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIKAok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 20:44:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2042.outbound.protection.outlook.com [40.107.22.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A267E11A0E
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 17:44:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=og9DSQQwfRPA1mAKmJkZVpbWXDenI4becWQmoqExELrO/YYqRZPvfG39hRsgGGzzEtxsXBNr879B3JdB1IxFajgtqQ7acKLpvU3rZBFqduyZhQDkT7GkOZexD5Aq8NHv+W55mdIKARcjizAh/bVo8uNLuBWJV0QhWLaz/qghb3Ryo1luQkF25RFrCAtJK3ttWLmCJMkO8hCSqk09QqfvvvhcGx8Mck67qu+rMEvDv5gkq5vDLy+51WSRXBqljnjoPiD4vkgYodpyfTKCelVRie8Qawc4kPQlzdoHNpobY6iKl9tPZSih1V/JJ+nMcNKNMfBaVOEriCalDuglX6zZuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVpw90McexNZQU4KalyomP1BuBEyBjBYpZMnBM/2oco=;
 b=Krtv9el4L45+rMTtbxWdN5NLNLUGhYbSCGDu9tNw4C+D+mMfPsTyNivXrCP8OKWrLKv0G8YjUTOGpeaVlXF7wUZAlbtllcYOEAmsl0Eb9giaa5Qg6z7DDF6Z+AhmMlAyqiJoTDrBzHluLRtQ69PBKHHPvZPnVAK8yrIGA3FDSsRcsDl+lzyvBEukjK1gRrkeXLlSvoiUKChHKsb35UFEUpxbnYfTQU1e3XqEjn54kVv5CFAa9svdALnJEsACD54MOVjliPq3OQAqwSYO2jvLsyh+wbCo6Z+EekLFDndsMouK8BuGDzOcxQm42CDUcLezLDWTkyab3DP3alA7EOSvMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVpw90McexNZQU4KalyomP1BuBEyBjBYpZMnBM/2oco=;
 b=pyHn/QowykQF9UaMDjm0ZvTxy8D5S28O20/D+Q5lnZwA90EpPJuKpja+ASGI+FcShRw9kJEF7FbJ/xVAPA/aEm7ijLpv4DHWLjfEl87KeJzURn73/QtHLiK+uhBcwcVkeevq1/RsA5+CQmGZbpHR7GCq8bUHcMlhTbW2z2PtKqY=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB8PR04MB6843.eurprd04.prod.outlook.com (2603:10a6:10:11b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 00:44:36 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 00:44:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Thread-Topic: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps
 capability
Thread-Index: AQHYYwz+Nv3GsOP+t02gQrIoyWAlJK0WWrEAgADnkAD//4yZgIAAfF6A//+LWQCAwVjIgIAB+eCA
Date:   Sun, 11 Sep 2022 00:44:36 +0000
Message-ID: <20220911004435.7wa2ir3gl6w5qanx@skbuf>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
 <20220508185313.2222956-16-colin.foster@in-advantage.com>
 <20220509103444.bg6g6wt6mxohi2vm@skbuf>
 <20220510002332.GF895@COLIN-DESKTOP1.localdomain>
 <20220509173029.xkwajrngvejkyjzs@skbuf>
 <20220510005537.GH895@COLIN-DESKTOP1.localdomain>
 <20220509175806.osytlqnrri6t3g6r@skbuf> <YxuHF4UrUEJBKmcu@euler>
In-Reply-To: <YxuHF4UrUEJBKmcu@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR04MB5121:EE_|DB8PR04MB6843:EE_
x-ms-office365-filtering-correlation-id: 72ec39ec-37e6-4dfd-8441-08da938ecd1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XCaEPqLje2v1YX12VSbvLrOJp+xKbT202kKWpDfIOb8JX7dsMX5kxvRqI5Ow+Q5AFuvusLnMRnHBu7HZjb1E6ECSE21Kw2k8vLgy50H2WYmZ1CjqyBndeprYqmYZpnR6u6hszTdo2ZIQnyMpBnY+BDKLMqN00H0+PAFU8q4B2asZBfdAKyLuIPZX507tIDCIgS7eoIvQOU94UAjUh/wLudTv11lHCWq6BTLwbnFpAt6Hplfnh3RmkKlbAjrlkTAAWJhXzx88V0G/UKB6QvxQjcGxHvA3SXRWL+PHzHpG14yE9xy6vSNU+IBmbmjGz0D1NPyc7QfOWtzev5na2SLFHUXp07TiUL2DZgXr6jARBBqZwkW/qeT//MwMcmUflvdMmsAbcTgpWQoKdJh0VCPudww+gmXMKzk846ALmYAvD85tB8H7ugtPW+LUkqtaoHCsolgrp0hJCmCg4DYCip3D0AW3qZM/wCx+X8yjHQlaYsCBPQNWOb6ybV67J1nx7Hc84xH/qK1USES9oMV63YtVdr5/dUt3F0DnpXvnNacH0qEGV0a6gRca6UrGtb/3Fa0jDq0IT0/I7JlyRcU1XNk/ULBL/xMtJx9yH7LAI+vi4Qnk1KLH89Mp9hOSpR13c+qd+ueXqRoX+m43FW8KKi8GXV7O91GFyfgZ1pK73RHnAhU/NTeNDpzWjIjs+HyCkvgwEzA1qeKUkj7uxnXJfGviRh/Nqzz6HWEMHHdQoRcx7Mo9CzlM62CItp4QosxeeiqCXKQ8f5RwEOUqgF0DeSIMJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(6506007)(38070700005)(26005)(9686003)(6512007)(86362001)(71200400001)(6486002)(478600001)(41300700001)(122000001)(1076003)(186003)(83380400001)(38100700002)(91956017)(7416002)(76116006)(5660300002)(66556008)(66476007)(8936002)(66946007)(54906003)(8676002)(33716001)(66446008)(4326008)(6916009)(64756008)(2906002)(44832011)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?URfHtNwbeUikiyt/r/2Q8qwnA1wAOlLxpmUde60pxRSk7Kf/GxD3ZqvhP97n?=
 =?us-ascii?Q?GZsDey3uxUIWzm0DFadYJVWWv30si0wRWXEQ/u3+6WCtN/tyObJaQtW0rxdX?=
 =?us-ascii?Q?Xzi1zeRIH00Uz968xj5gGocr5F4aUiB9MYd7XEKCmUzIS5KB3mjYKTQcon6Y?=
 =?us-ascii?Q?xjejM29RjFhodADkdJcvKExayyxgTU2vhoHxkrN4BIo4hfgEla/ZeeYPWq4S?=
 =?us-ascii?Q?Zxn9iKXnS0aqJNYB3MeRMQawwQVI67xIOYDaqNyYwfWuewUGPVmBRT5abYrw?=
 =?us-ascii?Q?lzHQFGTzsBNWFlDVxUFRIi40g/ZGE01+QEj6aTZp7oalhNKIKzJfLhEVl2Kz?=
 =?us-ascii?Q?8EfO+tRBsXzANqf35gFpKHmo+ywfdeXwPP0Qr54uka9KNnwo7JBeD3bb3hcv?=
 =?us-ascii?Q?HXiE8MhKOkstQ90xmVX6wUiUanm3nJl0TI7fy4iN1kyjUPbI6dcrfHR6y1tR?=
 =?us-ascii?Q?IZ2QYpYZELsak9wythIRZZb96hq7zhAxwJ7bom1Iu0rVVk8eo3GYwcAcTNPP?=
 =?us-ascii?Q?ZyyfZQKm7EbcIk3p+SwaNBsV3YFFHuv9BcEmY49k9A+y32T4XVgPq4Ld4PuZ?=
 =?us-ascii?Q?Cb8xX/fopeeMI3wt6AmI+I78I9SHDB9xTHsP2L62ilIiDoOQ9ixi54mlYj/a?=
 =?us-ascii?Q?oP0Kch3cqs66h0EZtBXV37t73u/Dx4OUkNhRQFpZZieDsjkhBUTJA3LutGjS?=
 =?us-ascii?Q?35L4u9TvHDLxrSqgxgzc519P0hq0+By8iaFuH37nggNu5SIlycFSRX0vzKHg?=
 =?us-ascii?Q?NLteQhoeZrjywuUXSzHZJmsuXAMzHGjr845ob0zblwuc3pUQnBGffYeGtOZZ?=
 =?us-ascii?Q?PYykABzVr45iyGmGBfzNAZwD1sF/z5esmDlbtvQXWbr3NhHAkd9iVdhftKi+?=
 =?us-ascii?Q?26jOVUQTjQ8PuoP9GEzfeBHmFLd/n39kafZZjKnVIPkqum8rssxtWKwgSkSG?=
 =?us-ascii?Q?REFGT2t8uqZFUda0lmzXLG7Fc1idwtLCrfO5sdBDsybYPI4a3eJ8aXl/B69F?=
 =?us-ascii?Q?oci4CP+oXS3x0RcQ4Nn9cxwws+ifak3q4IVswQ8cIVwlZloKlfzD5wM5SeQ1?=
 =?us-ascii?Q?S3GG32Sub9Uf449SgXJ4VEk7t+x5D+TqtjjqMkAMwlos/rH7a4g2uq05wqfk?=
 =?us-ascii?Q?bTVdYScH1etpEnQRQPu+DCOrH9Bwv+3NB7GjdscbeGFWhGytvmLpNDYHQKiN?=
 =?us-ascii?Q?ak37UQjY0Hk9G4bdCv6tYCGw9r+v3jcS32HjBSMQ7jY/9xkuQ4Tpqm2ydJ7A?=
 =?us-ascii?Q?olPoKz4KjHwsg/PvMi+X3fX9MocZzsTf33zvKeKW2SQ1ErK5KeQYDCboJsIp?=
 =?us-ascii?Q?scS+uhRdSLE92TidfYrn+wVGxuDa9xkvpAUx3AEcg2rutM9L7j8LyrPZrLsz?=
 =?us-ascii?Q?tY9ugsvRhCTOIhNUgIkHxxRgDxwo3K8cAYW8wMU+CElN2Ova0BJfFErcDJuG?=
 =?us-ascii?Q?z4Y+bH9mxAOSkm6SeWO+Pe2wEhmhUX1ZiOu+TBFGOCmSU8cO8/oLgRbBTon9?=
 =?us-ascii?Q?t3Jq+xHaCX5iaWZO+DsQpp/4Sv/VwlQH019y2HH2/oWdCIu4wkZ//vDGokwG?=
 =?us-ascii?Q?rX3HhY0XjCXwH/a7Tev/i/qjjogqkigPPjHIU+JhnCxAgwXRNTvD9polT+Cp?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2855DDC3ABB61A47A33341ED36AAF3AD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ec39ec-37e6-4dfd-8441-08da938ecd1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2022 00:44:36.1755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cpv97XVhj8hcW42kLQhi1CfMpmoAnZ+GreGl8+fs0y+gt/JuxmdBEeY/CUlTAtsYzMHXhAsmdTkyI48uYaPGfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6843
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 11:33:59AM -0700, Colin Foster wrote:
> Regarding felix_phylink_get_caps() - does it make sense that
> mac_capabilities would be the same for all ports? This is where I've
> currently landed, and I want to make sure it doesn't have adverse
> effects on vsc9959 or seville:
>=20
> static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
>                                    struct phylink_config *config)
> {
>         struct ocelot *ocelot =3D ds->priv;
>         struct felix *felix;
>         u32 modes;
>         int i;
>=20
>         felix =3D ocelot_to_felix(ocelot);
>         modes =3D felix->info->port_modes[port];
>=20
>         /* This driver does not make use of the speed, duplex, pause or
>          * the advertisement in its mac_config, so it is safe to mark
>          * this driver as non-legacy.
>          */
>         config->legacy_pre_march2020 =3D false;
>=20
>         for (i =3D 0; i < PHY_INTERFACE_MODE_MAX; i++)
>                 if (modes & felix_phy_match_table[i])
>                         __set_bit(i, config->supported_interfaces);

The current shape of the SERDES driver used with VSC9959 and VSC9953 is
such that dynamic changes to the SERDES protocol are not supported. So
at least for these 2 switches, please keep setting just the current
ocelot->ports[port]->phy_mode (i.e. what was set in the device tree).

>=20
>         config->mac_capabilities =3D MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC=
_10 |
>                                    MAC_100 | MAC_1000FD;
> }
>=20
> (this might be two patches - one for the match table and one for the
> mac_capabilities)
>=20
> Seemingly because net/dsa/port.c checks for phylink_validate before it
> checks for mac_capabilties, it won't make a difference there, but this
> seems ... wrong? Or maybe it isn't wrong until I implement the QSGMII
> port that supports 2500FD (as in drivers/net/ethernet/mscc/ocelot_net.c
> ocelot_port_phylink_create())

I don't think there is any QSGMII port that supports 2500FD in VSC7514.
In general, the frequency at which QSGMII operates would not be able to
support that data rate.

That must be an artefact of me copying and pasting code from Felix to
Ocelot in commit e6e12df625f2 ("net: mscc: ocelot: convert to phylink"),
later transformed by Russell in commit 7258aa5094db ("net: ocelot_net:
use phylink_generic_validate()").

How about you do the other way around: populate config->mac_capabilities
such that it unconditionally also includes MAC_2500FD. You may have
noticed that phylink_generic_validate() calls phylink_get_linkmodes(),
which contains a logical AND between the capabilities reported by the
MAC, and the plausible capabilities given by state->interface. So it
would be quite within the expectations of this API for phylink to
exclude MAC_2500FD from mac_capabilities if PHY_INTERFACE_MODE_QSGMII is
used.

On the other hand, VSC9959 and VSC9953 do support actual 2.5G on
internal interfaces (and on USXGMII, in the case of VSC9959). They don't
use the generic phylink validation method right now, but it would be
good, in case they get mechanically converted or something, to keep
reporting MAC_2500FD whatever code you add right now.=
