Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A8456AEC1
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbiGGWyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiGGWyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:54:35 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2057.outbound.protection.outlook.com [40.107.22.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067F360698
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 15:54:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXpInrpu811CjoYVDf+QpY0wCRiH2r6BuvJZTbu/QG3by/5tDW49Ylx8AGKmHNOIB5LHf/cWpxW3+Nu5GJghxmaOI1aY6ATfP6E+bNKCffXEcy/kB08U0pVIzNBzLbUDMF6cRuOeWNX76co4UDCg1BI1uFb4VHl4omNg87x5BLI3WJefVe2SYrLBxvrCbAAbd1catSYAUD8aj0UGomowAJV+Gd5miImOVkL/AA/1wWlRGWq6kvOrpCMCBgXvO9TyLEag83fbfiR9FmBLTyOXGS1le+kSQCfg0wHy4vdtmq4jg8HS8Ry131F5rgetT+4/EAgVRGWDF5Aiw1vfB7Q34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ipz6i6MmIeGHqTtPLZs0ZtjpAFB/edAOu11yw5aWD/w=;
 b=kKbscsbwhtyYNv5D2lIH7uQXSJx48ttQXLekpzAxVVRCx8EwUYzBKWVR6XQYxIJoD6owGQ0gLkMwNa+vwCIE1vOej1a9yt9uWUT3sEmT/uFio7Ye0hdfF95gmecLhgETpSaKuHDaIA3DnwtZ9nvRj2aM7C+8gOfm6fsJzNExTQU0/4kkjPlO9O8F7nqwY95iMHBW1LD8cZf9NMIPNNHXfDAvNcnk48qM8Ycv7TQaIL17l65ucX0C9AyV03RfzIM0eG73vi0H7M0y6mO5YyDCm5aJGXRk+SuHsOPa+KwpoITdZZaNDLVAlGmeRvhfF5WzcRcBO/AJPYGrWa5ycyiBdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ipz6i6MmIeGHqTtPLZs0ZtjpAFB/edAOu11yw5aWD/w=;
 b=pGJCcTIY4UNdknb1rOKnqx+BMn6w3Ymmsw+H5UIgnqhjCQ+Qn+Ug+XJprDnoe6Ho0fmqjVXZaBxzd3i4EeXRUFVUzz5dFDCZQKVRJLosGXc5bam5fwMwWnaLlHKu46edE4C+V/36VWhfZXLiCaAZQwTTHX5Sc6RwR4GdgSPIzVI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8842.eurprd04.prod.outlook.com (2603:10a6:20b:409::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 22:54:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 22:54:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>
CC:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADdygIABweIA
Date:   Thu, 7 Jul 2022 22:54:31 +0000
Message-ID: <20220707225430.v3ojrwy3bwe3rkzl@skbuf>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com>
 <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf>
 <172da611-2997-e900-bcbd-6227102f494e@hauke-m.de>
In-Reply-To: <172da611-2997-e900-bcbd-6227102f494e@hauke-m.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e25e8f59-b874-490a-7ef4-08da606ba7b4
x-ms-traffictypediagnostic: AM9PR04MB8842:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +f6lvOLwn7bN9NJmE9wzVwGEQFwJU2nug4hjXpo20dUb39H/iLuGFIyhSriGe3nz24l8rLL1V+nxOWkAnvroX2WtfQjLEDpp6XOuNNwT/dt1WRVD7NEWa3K468RzcvS2Rcnn11m77kYSgIOv2HDITQOeTpQ7FrpEmEGB/3NPq+RZF+6F0inpR7WIpV/qVaQy+dR+0uuNqnWoO3IX+W9t+FgMS/ptdvcjrP0xtsrXRGOK4Vab4B/bpp6xZs5l+vYNLYuffhDJzfUsSfNhQDylL5ixB67Qj6JnvSGU3t101qnYf/Z9ffDg8VXvKo+yWzoQNI7Xqh7jRypptQDSjV8mJWcj6KdhYsLxfnusDmQP7B2RSrN0YWczV2FjYDvtZNMxnHCS9nmJveV/LZiY4iiL+kZc7WXQUmQv6iGJqoX+Fa7eAbmN2HmMPm/Fwz7B11DXCZsJ6SoGI4p1x+JFtUqPb21CqO/nBhTHSUl0jHqkd5VUu2aPFxrbe8h6SYdrt+BEZizjWpDZKoned/aSJ4mcj3sZwKwKaVkY0YNzEHO5d2fnwY3kyBexnsL719DflhhmizLxKLZ2mbabbOboaPavJLC2qMtgLp1KNQzDwx9/1P75vXFLDLtKpJTkl8MFXvj5lkjcorzuov2pO3u7NbY6pQoO9OHixPL7/w+JPrM2u9E6TYm4nEqVEti6gtHtx73JrD5+lLqIO46tV7FgxDuABGJA3x2N/O2/EAOQQ115gxFoNwXhRlsrCDLW3sSSgTIco2p51HSSf5MdwpsH9L2UjN6ykFAwMBJvZ8B6JI/JzF/rD4Mi/eZYZYaGl2AxUBZZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(5660300002)(8936002)(7416002)(44832011)(2906002)(33716001)(38070700005)(83380400001)(478600001)(66946007)(76116006)(6506007)(122000001)(71200400001)(66574015)(91956017)(66446008)(54906003)(6486002)(66556008)(4326008)(64756008)(316002)(38100700002)(86362001)(1076003)(6512007)(9686003)(41300700001)(26005)(8676002)(66476007)(6916009)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pjop0Fl0OVSl+uvKUiwZTCDrpAIpGgDVCCd7kz3JNWQqUUxbwdhTgaPB+kAi?=
 =?us-ascii?Q?+icF9fx3Ye6J6+6S7eiGzETBteg0Z8+kLr7vVmcr4pfLl73ADqH29giFUR5V?=
 =?us-ascii?Q?e+11Kcz93/K4iMMVuzvNTUQ0p2UFP5yLzGMqVBbbCLOIEmGtbq6JabGGGz+v?=
 =?us-ascii?Q?+YAqdIROW8gJ3aT/83Lg446/4qy53AqeHfAc/Fuv4Rr31I/X17r7n5067KRz?=
 =?us-ascii?Q?qbmNiYjYhAi8EMP1DDDSWdekc1tqg666K51V5O6Im5+PJiFa54P9oCy7hF8y?=
 =?us-ascii?Q?rY9mXyYHLzPvEYWXPrOnkFP4qdAxovy6DP+nZDH/iodBovoHOKmZH4MsM1Pv?=
 =?us-ascii?Q?hyjyGF0WiCkys8hwOFbG4KmayhJUdRRKqbGbQehNnzheSePeFq+umSM4UfO+?=
 =?us-ascii?Q?Y9x1aI034ue/M2ml2bhviaPj+KIZ6LYisS9bOm5IKujZpxWL+KMJqsNecH8U?=
 =?us-ascii?Q?3PQZdqB+yThAqJarghSY/7AoNaQ4uv1kKQCNScvAebZD5viB/PO0d7fLUq7U?=
 =?us-ascii?Q?Prsjygp4HCNPQ1DZHf+l/DRMoomw76JcI5FgTgD98/oSI9PCqkjv9H/V4NDl?=
 =?us-ascii?Q?ElmfTB7FrMiGeZOaKZLpujNxLK6istHu6wJ9eb+PaD6NjoSuyyAGh0IX8jy8?=
 =?us-ascii?Q?z/umGwF68SUi4giV3+bqIlbwOr78ZbAmvFzzjs30FsuaIyt5L+lV/DIwwQHp?=
 =?us-ascii?Q?ihx32k+d7gSQC/OWhbH9GYrTT2o+/rTKVvDnxlxETKjTBP2HwcCJ1E04hZd9?=
 =?us-ascii?Q?Vo84qMPPh6RGzGk3mwJVzXq/wveUOoFX9Px8pWP42mvpbOuG4gCvblC1/JOw?=
 =?us-ascii?Q?R+XIvqbHR21gO00LS1UMzajqI4tJ6u7YhYc+IVDMYdKDz5s0I2R85AyGZBI2?=
 =?us-ascii?Q?mG5pyFuKXH4JmBcgvCLng6DoQ5YOA6ix/VZz58LvhAdMKGe76DllvocXaKiq?=
 =?us-ascii?Q?JQKwrM1rLf9A9jLHSSXYwGIQBouZuePzyx39Ta23Y8fWtCOZnmsyCf6yyWBE?=
 =?us-ascii?Q?uniJ4a2tcroa3oYXr9fYJeRmuy6vnJtXs1ARIYOYuyC7ieFF1VbNqd65lg/+?=
 =?us-ascii?Q?0a96THVh3HQZgF8Tems8CenxvqQikbokyN/0TiMg3YI4B+Z3RA4rev1j8cBL?=
 =?us-ascii?Q?Af8Z960mBF5yE/5MVxcCkyrJBvXxD3YwBDAoDsnz1TPAYkf+OUSdPb4GiMW8?=
 =?us-ascii?Q?/PfMfTrR1nAcFhMWEUSJ2+YIuZhiU9JCq6kYlpr9cszPb8fteiUSPPlPHjwv?=
 =?us-ascii?Q?Xbq0v/LiM1lZQy8Ylnxdlw4xuCaco6RAcSVFwxNbMlrEqUTJGzAE6Oid1rfU?=
 =?us-ascii?Q?KktPWUv9xfj2vCkQBIbYWrtfNX+o1vdgYzO91B219wjFzOJQ9E63N1xg/Gju?=
 =?us-ascii?Q?3snrV4HOxAJeLoEXgbyVEAhCivrp/2Nedpc6TdkRumDP/rIQoVseUpKaE7x3?=
 =?us-ascii?Q?C3VU9wWw5EuPpgFoUweCST24W9V7E0fIg9pryT/Y+HkqMx096to7z1LO/zXH?=
 =?us-ascii?Q?f46ryw4qINQhx7mzUE6OXx51BjS5DJGOmhOb17ViNq0ushPJcLcbB8YXSH8P?=
 =?us-ascii?Q?vpe5O0o6Gh0OIb8OB2nx7SDZPyBNVtpi6+GlBOYnYf6OLr3xqaXgUncjpMoH?=
 =?us-ascii?Q?Ww=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3053A5036A17BA42BEDB6FC9372318E3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e25e8f59-b874-490a-7ef4-08da606ba7b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 22:54:31.7581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M6QWyKQ2WqqPsWQUu7EcacrW63VP7MGPpWuM6CY/EqlHLo7qqYFtGScYspUnyAxcgbWT1ds8PC7SfSP+FlFn3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8842
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hauke,

On Wed, Jul 06, 2022 at 10:04:19PM +0200, Hauke Mehrtens wrote:
> OpenWrt takes many packages like ping from busybox, but OpenWrt can also
> install the full versions. Adding a package which packs the self tests fr=
om
> the kernel and has the needed applications as dependencies would be nice.=
 It
> would be nice to have such a thing in the OpenWrt package feed then we ca=
n
> easily test switches.

I didn't want to insist on that because I know that OpenWrt devices are
generally strapped for storage. Also, I never managed to build an OpenWrt
by myself, plus my only OpenWrt device is helping me send this email, so
I can't be of very much help on that front, I'm afraid. But I'm happy to
see Martin take the initiative, and the encouragement from you.

> A debian chroot should be possible, but Debian supports MIPS32 BE only ti=
ll
> Debian 10, I do not know if this recent enough. The GSWIP driver only wor=
ks
> on SoCs with a MIPS32 BE CPU, I think this is similar for some other
> switches too. There are some old manuals in the Internet on how to run
> Debian on such systems.

I was definitely suggesting this as the easy way out, as you can put
Debian on an ext4 formatted USB stick. Debian 10 should definitely be
enough, as these selftests don't use the latest and greatest features
added to iproute2 IIRC, but it's concerning on the other hand that
maintainership for the debian-mips port was dropped. Are you closely
involved with the topic, do you know what's blocking the upgrade?=
