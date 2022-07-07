Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7C356AE75
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 00:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbiGGWbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 18:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiGGWbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 18:31:21 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80049.outbound.protection.outlook.com [40.107.8.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FA965D72
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 15:31:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hiAr7WMXZ8Y8salPCWcfYIeVrYzQo3VaX3xB1VjLzSDb+gJTsOikVo60KDW6dH39OlBywC4H1jRUfG0QqYRky5XqeaH/0hXYl39U8N+iqEe0/j6SXB1ItTO+wmIa9o6VaZ/3hPBco4H1iZGmlKhGyLcreqiadw1JArDh0GN8kRMi8JSLqXoBf1ElqwSw4tD/EntQAKOLLk6aNK5ARyytOE3EYUcxfff5CkQZj8GgMSElc0nyPpcyU6FBU/Oxq9xnhz5wI2y+GrI1zaBEjKqpD9tY/MZRw51XGMSfcIgmFNUu1l+BCxEOlqYrl7eyOylZ0PFLpFqfDDYSnyBR5gBKjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+qNaT7wIA2rgxneKZXzniAWpDebh26mzGBs9wCZU040=;
 b=YSzkkBBg8O73aVpphWSVk+t/DN2pXb5jOBAhJAHiln5WApyRyygpoiw/uH96KS2owkwcht3Eza8tLnH1iPE4I/dGDMat6v3cH06C0nDf2q1Ycvg74viLtwF5BRjDvkwbjIj1Q+VppJMe5l9y7rFRZGtGRB4gOyI8DcN674M1Np5TzRC9ZbIHm909AV59s3SOiuF3/AUYNzMsx9LaZxWRoAEk5I3FAzWmlxWmn33uHiMpZsWuz4xnNHapnykIwrLAUX2+Ci0bJZiynddyIYjIEJbHYVw5K2IzLnEX7hRQ3lnC+5P39jFJC0VesTvdhvL+MZZsUshBGcGNHfF9H1i9qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qNaT7wIA2rgxneKZXzniAWpDebh26mzGBs9wCZU040=;
 b=qSD9oAy8I52/7/B86SmKppt149Pcnn0mM8Qq982ojHL2FmQCdtDwYLP+ekb8vGOYrHGcTfMthPGIgpB90D+RkxPMKX7Tks2vIUpXCHqA4KSwpt+ngz2fL3rBe9rDYOyDuMecfM2PtSiWJJ7JevYkyQL+JQfsAE1/JZdsc6s1NqU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8390.eurprd04.prod.outlook.com (2603:10a6:102:1c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 7 Jul
 2022 22:31:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 22:31:17 +0000
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
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xiwcAgAADgwCAADWXAIABvT8A
Date:   Thu, 7 Jul 2022 22:31:17 +0000
Message-ID: <20220707223116.xc2ua4sznjhe6yqz@skbuf>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com>
 <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
 <20220706164552.odxhoyupwbmgvtv3@skbuf>
 <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
In-Reply-To: <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcb4a6a4-2f92-4ef0-03e2-08da606868e0
x-ms-traffictypediagnostic: PAXPR04MB8390:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: noNUyV+Xn6k/IK+NXpkz6yC2iBUCdgYtQN4fNmj2l4grV8FS3VCsF1UQhDo+0oMIsnSKDdft7G+Q2TxOUYx5qfnc8YoRCYRWIM/UhTQ/hriecqixxayvCCM+99hAGenSWeMkB6MrARbWMiiiXQeLlOBZ8zgKj0QaBKPS+CukCM8mSdL7VhP0b4af3Eaul5gfJMqHofxODoA/+7Kn+JJGYKRnvB3MZH8a28rbtV413sEV5IZBeDOb8UrXnPFqHvRSAiVLSP06NBsS7kbl1UrDNDRZsm3iUcpTvoi2LKOO+50rhc6Iy0j869lfNEeu6MeY/U0aPiFNhy82XyIEI3DWbJu5XHljx1CAavHYBOZvs29FZjy869emuMMmPNq8UILwASKSEtbf0BG96rgb5ryFEobpZxoTMl/Bktq+qAqjXG23LpqLSPSrf1yBBp19l275VuCw4ikNRtgMD5WarLallwAYE3vIvocbDQVI1mJTmvrRkleyPD9cpkqMbXHFUYYT0m5BNkeFkvZcZXKllFv31jYKqj1ofYkr13szGN9yMYDmA63xOgXyuVggpmcWaHssWz/CAi1+zKIDbkMD3yUe/PuzGPf6Xm0uNz+Uvf5Ja2mUuXMm3VONL89QFCO6FDJ4TGQEwq008KbCTA0k5qomwtBCEglhT8cGSIp4DGWqeqSyv9t2TOvhh0j/mOeed3X+CJZ31hDwU0Gj2pfdrQO04eAX5aiJD/onzigNMDQv7b7Rumou3StBq1RLwz2po7P7/hOtdd0IMT7tsR+yOCQ3ReygC30PLCFkiIkGpcKMIhWQVHgtf7MBJ/weFq0j/x/TMOr3gZo+Eesd7SAQGc2V9xRDguP6ooLizxQl0G5Lhms=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(91956017)(186003)(33716001)(1076003)(7416002)(71200400001)(5660300002)(66556008)(66446008)(66946007)(76116006)(66476007)(64756008)(44832011)(6506007)(6512007)(9686003)(8936002)(53546011)(83380400001)(478600001)(41300700001)(26005)(6486002)(966005)(122000001)(38070700005)(86362001)(316002)(8676002)(4326008)(38100700002)(6916009)(2906002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DUyJKSD3a6B6pcDtNXOw76z846IVTdeY0ri5BgjFWFjLFBxhEYkFTgImSdpZ?=
 =?us-ascii?Q?CkOIrVrPU61Qv8YvWYi/bs5LzlcEOec7TO0HLRZ+g11fmNXepBQiA996VrbV?=
 =?us-ascii?Q?I1okfOGP47l7auCi44TQdwDm0Mf/adJMASbfYkOVMSzJi2/pYbxjWplgKoNJ?=
 =?us-ascii?Q?uBfzlL8Th2JrODW1w07fTU9fvByJr6q2B8EOEWLfcZBXNEbf0hazCFwDhUnE?=
 =?us-ascii?Q?ho0YdZW9t9GRFVoqpQmfh2RJ688zwuPik8IcLVFcmTWbaCG/j7zaR/XfuCpH?=
 =?us-ascii?Q?70kz7Nco3eTujSvG4MEdNjxV8KUdQ44fRLvmwU3htxzTkRPkbtepyrO9Tp5o?=
 =?us-ascii?Q?wzWiJK58zSpVLDsQB1bUZA1OCT+KZtG+NirIzBvAzYryPmEOALyTPiywJXq1?=
 =?us-ascii?Q?tZXyjYuPES5v6xan+Sdd3WINtyxrMYbRFlIUSZjRgo4nnqV/lnZllIIAOQeS?=
 =?us-ascii?Q?4Z9JvRDTK2wwiB1XxowBc5goNT/HS4JBSqUxtoE+AN+OW0vQqkW8gwr+/IfP?=
 =?us-ascii?Q?+QncBHzzr18D42KNkgNXxm4ORdiR4CwerqxhfjH39kzVY5aC+dvCfxH2DOwj?=
 =?us-ascii?Q?2GNKfF75C0sKAxIp4QA0+dc4fkc3BXQePU9FM7kqofXuRDh2yT62QycY9Dmg?=
 =?us-ascii?Q?ZdtJHxpuTvdvXdaNR/P2/D23b9D+etlRunjuIRjT3sY0mLWIQfGQsO5mYUz4?=
 =?us-ascii?Q?kIaaRAUeDz7OQsP5TnvN6+eKUuEijJVB+5ZpBz6NRJbJa4iIxhMIgpyZ8NbF?=
 =?us-ascii?Q?DCNZGpHqAAn3z1LxYgBJ6w3Sf62wuIKTHCUGWqUGPW7Ffkrf2R4vpAY/2Uyo?=
 =?us-ascii?Q?AvM46VcUggGtO4x3v39yRqPIiq7hMVT+R8cvGhmK+9JOfK9Xxx1gXmYeZZej?=
 =?us-ascii?Q?lMsWXFIjT0F4iOPexI4l3syaPMQgcez3VRJxBgAonpr9fA/U5DJvH+JCxiWE?=
 =?us-ascii?Q?7tH5h2fokxX9hOq5reyclW1Sc3N09gGbldft4A08PMET4ihCbot6+JBcKWcm?=
 =?us-ascii?Q?HxjOfIkUYGPA95vhMCrEdJNZyB46lVLrCm4BdLLP3RAo/jhFvWTkKXSsytST?=
 =?us-ascii?Q?J7BfNX79BH+wQNnZi2i38ttiGAHC61lf27MSuLN5dyyiyOj54E1hGM6IB8RX?=
 =?us-ascii?Q?TBpQo8c6KkH3hNSgteRm+4YwgriIYR6KAFyOD/qk9DMQeR8Qi9P40+0yJ/kp?=
 =?us-ascii?Q?xvB7NDo1UghlJWCBwtIKEMbDF9Gihbo4aapSZ1uTJR9T6KQxHQf7X2XzEezd?=
 =?us-ascii?Q?TcwdtLObZW20bgwZIGwiN5N+8ejt3fMFHiA/4sq3WF4aPrqMFFt+7XR27EXu?=
 =?us-ascii?Q?VWG0Vconl5sf7hLKQW2Yn20eQTzcJABI0ugd8X1SzdIdaUPoD6tKeF52CqAA?=
 =?us-ascii?Q?u7Rbz7T0Y6QGXW9NCulYaFzBP7qHOcf1Gk7Ar2APUniu2V9lcLkci//28QFU?=
 =?us-ascii?Q?DwMWFjlOzvVC6KQxyWQbjUaIl449s+BN9H1d+3GnXQNtq+jBKsjl7sZScWHU?=
 =?us-ascii?Q?/Lz0Aqd3sxqCLPZIUkF/6+XdJjzkVI58lCLKcPFW9yyht3UG1vRB1GjWxCUY?=
 =?us-ascii?Q?xwAIy0vgWwVOekWcnpVkEb5c7GjgjqB+HXW9GPQfqa/39hq4Ftk4hdgYFGGy?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8C3CF9067BCBD24781CEFA968C418AFB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb4a6a4-2f92-4ef0-03e2-08da606868e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 22:31:17.8410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hWRnUZ1C1kia2qXan7vLwsu7TvOGlw9UxRRYUmF6+BMLZNkkA9IkPO/d2E8Pi+ykL1hqaA0ST4G7PSq/c0qjZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8390
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

On Wed, Jul 06, 2022 at 09:57:40PM +0200, Martin Blumenstingl wrote:
> Hi Vladimir,
>=20
> On Wed, Jul 6, 2022 at 6:45 PM Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> [...]
> > Somehow we should do something to make sure that the OpenWRT devices ar=
e
> > able to run the selftests, because there's a large number of DSA switch=
es
> > intended for that segment and we should all be onboard (easily).
>=20
> I could work on this on the OpenWrt side.
> But this would require me to get any test working at all...
>=20
> I am struggling with not seeing any ping responses.
> Instead of adding VLANs and others to the mix I started with seemingly
> simple commands while connecting an Ethernet cable between lan1 and
> lan2 and another cable between lan3 and lan4:
> 1) give each port a unique MAC address, which is not the default on my
> device under test
> ip link set dev lan1 address 6a:88:f1:99:e1:81
> ip link set dev lan2 address 6a:88:f1:99:e1:82
> ip link set dev lan3 address 6a:88:f1:99:e1:83
> ip link set dev lan4 address 6a:88:f1:99:e1:84
>=20
> 2) set up IP addresses on LAN1 and LAN2
> ip addr add 192.168.2.1/24 brd + dev lan1
> ip addr add 192.168.2.2/24 brd + dev lan2
>=20
> 3) bring up the interfaces
> ip link set up dev lan1
> ip link set up dev lan2
>=20
> 4) start tcpdump on LAN1
> tcpdump -i lan1 &
>=20
> 5) start ping from LAN2 to LAN1
> ping -I lan2 192.168.2.1
>=20
> result:
> PING 192.168.2.1 (192.168.2.1): 56 data bytes
> 20:02:01.522977 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length=
 46
> 20:02:02.569234 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length=
 46
> 20:02:03.609132 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length=
 46
> 20:02:05.524200 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length=
 46
> 20:02:06.569226 ARP, Request who-has 192.168.2.1 tell 192.168.2.2, length=
 46
> ...repeats...
>=20
> So LAN1 can see the ARP request from the ping on LAN2.
> But I am not seeing Linux trying to send a reply.

It won't reply, you either need a network namespace or a VRF to do
loopback IP networking. A VRF is a bit more complicated to do, here's a
netns setup:

ip netns add ns0
ip link set lan2 netns ns0
ip -n ns0 link set lan2 up
ip -n ns0 addr add 192.168.2.2/24 dev lan2
ip netns exec ns0 tcpdump -i lan2 -e -n
ping 192.168.2.2

> I already verified that nftables doesn't have any rules active (if it
> was I think it would rather result in tcpdump not seeing the who-has
> request):
> # nft list tables
> #
>=20
> # grep "" /proc/sys/net/ipv4/icmp_echo_ignore_*
> /proc/sys/net/ipv4/icmp_echo_ignore_all:0
> /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts:1
>=20
> # ps | grep netif
> 3014 root      1308 S    grep netif
> #
>=20
> To make things worse: if I let OpenWrt's netifd configure LAN1 and
> LAN2 as single ports with above IP addresses ping works.
> Something is odd and I am not sure how to find out what's wrong.

I'm not familiar with OpenWrt, sorry, I don't know what netifd does.
Also, it's curious that this works, are you sure that the ARP responses
and ICMP replies actually exit through the Ethernet port? ethtool -S
should show if the physical counters increment.

> > I wonder, would it be possible to set up a debian chroot?
>=20
> I'm thinking of packaging the selftests as OpenWrt package and also
> providing all needed dependencies as OpenWrt packages.
> I think (or I hope, not sure yet) the ping interval is just a matter
> of a busybox config option.

I think it depends on busybox version. At least the latest one
https://github.com/mirror/busybox/blob/master/networking/ping.c#L970
seems to support fractions of a second as intervals, I didn't see any
restriction to sub-second values. In any case, the iputils version
certainly does work.=
