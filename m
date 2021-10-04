Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CB94209CF
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 13:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhJDLSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 07:18:14 -0400
Received: from mail-db8eur05on2073.outbound.protection.outlook.com ([40.107.20.73]:58561
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232891AbhJDLSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 07:18:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChvgXif5ztmp+8bXnVTVi97QtvJ3zwahukNC7psRQlKD1BHTUPhVZyiyhE0JabSg4fJVAbJu4YTQbWfO3ylT5GguM3X0eLkgCepbLYQGiAierfB0Xz7DkgnmZ+p61ibzgq6nL9J22g6xZhrWdBPBWsx9U5Re9iNJYEwZq0XtwziR3FwayIssWz4bm5v//5yMYhy5+hT1whpb4k0Ocbgo7Um4KgyYbawv36LAlaX0nEwHa9tuz08potmivHSanCNFy0IWhg6SCqJikG5YKWhSRui2zSYFrwpB8tklGJNmITN6yqIodC45pycC80VSDd/nWGHejF7d/pV/G/Tnp8VIcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOBAcc0e3TmuNaV4XmfI5M7K5O+7GkKngeBZuNL5JYc=;
 b=AQysRnooKI5SP02HFG+AhwtP4TN1r4RYax+99BCPlTz1NJjn+m5zJrCZpHo0xFxmSHValuhvd98oJCbrxBiJ6yoLoOz6PeSNg41pan3GoSvPjhfODGVZK4I2RA3PMnyhO3S6dekk4XmFHtWRkJPovzk+x1OKDcvflel80+VoBMIl+a7tOvbhhkfI8I3eBwyl7wJ2AivDcOtt1L2E8b8b4snj8D59VgnpBSnGJBxvgDPDk13u+Pr784hsYRk4yo6gzOjxXnci/gXkDbfwFO4stFmkKyo2DvJn4DFKc0vzc3TPY+UZTF14BrUGjubh5/tyN/rNyDfpfivGTbK3nBtuMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOBAcc0e3TmuNaV4XmfI5M7K5O+7GkKngeBZuNL5JYc=;
 b=kXUEatsVFhkctbnPX/ryiQYV0lktLN414giaKRouDLsoABnCCrIesBCN0KfVza/qu5gXpXojm0SfXKSX2xVhmADOLMBkr8dnpMN6NXTbND+k0vQyJd1ZbN5/BRNkd17QH7N4IiogbaYjjz5EpBm0NlKbROZ+v5M5XHR7YVY188U=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5855.eurprd04.prod.outlook.com (2603:10a6:803:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 11:16:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 11:16:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net 1/2] net: dsa: tag_dsa: send packets with TX fwd
 offload from VLAN-unaware bridges using VID 0
Thread-Topic: [PATCH net 1/2] net: dsa: tag_dsa: send packets with TX fwd
 offload from VLAN-unaware bridges using VID 0
Thread-Index: AQHXuKVN0g8c7qiGRUOKHtWHUYnlh6vCq2OAgAAF2AA=
Date:   Mon, 4 Oct 2021 11:16:22 +0000
Message-ID: <20211004111622.wgn3tssr2impfoys@skbuf>
References: <20211003222312.284175-1-vladimir.oltean@nxp.com>
 <20211003222312.284175-2-vladimir.oltean@nxp.com>
 <871r51m540.fsf@waldekranz.com>
In-Reply-To: <871r51m540.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12800de5-f067-4fe2-5efc-08d9872865e8
x-ms-traffictypediagnostic: VI1PR04MB5855:
x-microsoft-antispam-prvs: <VI1PR04MB5855CE999EC43EC815688BD4E0AE9@VI1PR04MB5855.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0fCIvSWZK5RNMH0fftKVNbCBN+HawrPzkEfzc7ls2CMI5fV/G0KhkoXBTMvYJgtbZCni/NPlYRRPqqm09z00sdoAZa5Npk7WhV4s9jMnheWe84uch6AMP8HvswbiX0ZkDw7UiRz2xgQnQJJsamDfm+c1iUSqZc5BkOZD31W8YeYqBF6yL261NqIDUw8JKO6StS2WnCVFebivYZ+i5fgZ4gJQlV8fnE0EUYRcOZEWIeEZ4Z/SvoZI7Y24R49KS4paVPYtZ3u8PT5c0agqmbgXS+abqCTmTyzMWnynF5/1Qpbz5JIOFt1B27KIzG7o5lXe5RTKQgE0DLCb+PO7di1tb/hiZRIgdu11/OdW3XftP9op8qX+BrHpAHpH2uE9AG3ncF2Q7kslcrprd5/gnQqol9HTnY3NNPEChNz5ufmeuoh9qgGCYuRB9vsJNIkr1Ag8fZGnHtPOpjuEmdYU5UrHxTCV0t4EyMbVq4J5QLP0JBOvOwDgJOksFR7Q9aKJUTA44OQRnymL5ZvR7qQOlNy55u9A66dFpSOMwXQgS2HKCM0gfD/pVTEQPmdVi+HwDfomXVnjp8HSSlqz+Ml3LD9NuUa1oWnI1wAUHl84SjaMVdIE7MWkH6dflOIcyQs1ZtrePP8QpXo/pJzrKUdT91WxybwoxgyRTmrDV+wsLncPkc+/mFSyMyoXCwwBsBIleNAHcnzaEjdkUgoanrgVlJOjVH/zp9qBoz36BTvZtRZ6STf71GoyKopcjztapm+09JG/uzhZ7O1P5x3m2nl4fVvA+otW+4liigpV6pFENfrkvnU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(86362001)(5660300002)(508600001)(83380400001)(122000001)(9686003)(6512007)(966005)(54906003)(316002)(71200400001)(33716001)(64756008)(66446008)(8936002)(186003)(38070700005)(66556008)(66476007)(2906002)(66946007)(76116006)(38100700002)(6506007)(44832011)(91956017)(8676002)(4326008)(26005)(6916009)(1076003)(6486002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UKqphudJSh2a6YS5nAw0JQ5g2kvLK+4jA74OqbCMil6cS0+3Jnsc+BvXad1H?=
 =?us-ascii?Q?FRdualObZSLU6KbkFq3V5l0iGYPUSl9XMHCE8uMczwQ586Unp9BwHz7hPJjh?=
 =?us-ascii?Q?ZCf2wtr+N1mczpUpmEz7lgtF7FWMctycAUQiRsMTkJO4ssNOOGDbPQTrHkg8?=
 =?us-ascii?Q?V69fRrW7N/ELYaTRBWxuZOf9P//4MheR8TfnQB5eKDCegn1Lsfk2ZD4Lrj8J?=
 =?us-ascii?Q?Xtv9EyeV4K71PXxFU8hsE2dXNSHUHz8kCjqH7nCKBotIJkNt7fdkaR1V6qEC?=
 =?us-ascii?Q?XHufvzmOvPb7pMhZwJP+6QNVlhufWm+VpSU+56LxHXyuJ5DLZN77KK4WevEI?=
 =?us-ascii?Q?gD1dXxFBU9IxY8BcC8lGb9YXRmxXDpytC8X5cdIdzUvqS2aEkJ1wyaT/Mwqq?=
 =?us-ascii?Q?GLsdrCEyi2PnxP3brB3GLZjS0ip4s7sevd9OPp/jaLwRQ6lXXDYKjUpKs92i?=
 =?us-ascii?Q?TndYq7W+t3ev6bJSsbzdc/ZWhCxa85/G5V1AVjYN3zzAu/QrXSDzMuvZCt5f?=
 =?us-ascii?Q?U5XKfbR2/oAu89S8r6ubVR6QMAERCcfPEhUry3dkyo2qFR9tYctcgDYpXbDQ?=
 =?us-ascii?Q?cyRkdtwo/sJojQVyEqf8HOM/4CUOMEdBPbi9H9V6fhObWyrQiX+yvzGolQRo?=
 =?us-ascii?Q?ycgYqnr2dE1bc7cJwomsT1jfsQGyihcvFcmiS7ri308/9bn1PrFNBicA6qQs?=
 =?us-ascii?Q?dyyt+liuRWRPSIfu3Y66bl46w6xPW7SM3kGXH25Azo5uMiABxwnh+KVgyx3N?=
 =?us-ascii?Q?G3yxPGK2Xw6wuOMgSD+NvF2UtuFjuTMvFja00bRw/5KQkPHpWbFqGcU58M4u?=
 =?us-ascii?Q?hiZ2BOWFWKDiEMLEIcVHOiyvQ9AZMQQT9fZWKDwsepeew71So/Inz9UzybSR?=
 =?us-ascii?Q?awkIHZGsaZv86v8o6OrSSSLkcYc6wLYX5SCD46ytbkkeTBF6atvgcToTpemM?=
 =?us-ascii?Q?bvS4oq/YCuPEJV3r8IydhwBEQpbfHGNtC8am31d7HQm1Ic6W+X9oBh2tXzw7?=
 =?us-ascii?Q?XrbvE39tcH+UkoLEdgBOiQ0omlyNC5NPqTREKUaKf0OgxZhRi3Y+tNcfYt0N?=
 =?us-ascii?Q?ESMTB0BiVZMvUSwCn6toSyjm/4d82ZRaGio2tsivPgQY4W4fB3bkxvc5IHlI?=
 =?us-ascii?Q?PCUXshbGnidbYJY1RWqfb71U1xYhCREGX+lpfwcUS7RbbHD7Qlf7oJC7bMpx?=
 =?us-ascii?Q?44N7e3316yipJ0jutwIgXVpz3Ns7eWboye2e8nUHUpofPF3y19Hn52oFFJvf?=
 =?us-ascii?Q?1hBRjDsZ1vSVBvXTdqimSXhx+towz5+vkjt/V8601edaYGlGXZ0Myd9xv0/O?=
 =?us-ascii?Q?ELVIrs2nCJmH96poDGVsZl2a?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6705EF79BC731F41B20700CF58068BA9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12800de5-f067-4fe2-5efc-08d9872865e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2021 11:16:22.7375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f3N4o8nDD+3N8tO+Xk4h3R4TVng9do3JzrzSSl8Hn/vA5DymeZj3Rh3IE1tVbs9K/ipbEUHT4N9a9K/6E+kWtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5855
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 12:55:27PM +0200, Tobias Waldekranz wrote:
> On Mon, Oct 04, 2021 at 01:23, Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> > The present code is structured this way due to an incomplete thought
> > process. In Documentation/networking/switchdev.rst we document that if =
a
> > bridge is VLAN-unaware, then the presence or lack of a pvid on a bridge
> > port (or on the bridge itself, for that matter) should not affect the
> > ability to receive and transmit tagged or untagged packets.
> >
> > If the bridge on behalf of which we are sending this packet is
> > VLAN-aware, then the TX forwarding offload API ensures that the skb wil=
l
> > be VLAN-tagged (if the packet was sent by user space as untagged, it
> > will get transmitted town to the driver as tagged with the bridge
> > device's pvid). But if the bridge is VLAN-unaware, it may or may not be
> > VLAN-tagged. In fact the logic to insert the bridge's PVID came from th=
e
> > idea that we should emulate what is being done in the VLAN-aware case.
> > But we shouldn't.
>=20
> IMO, the problem here stems from a discrepancy between LinkStreet
> devices and the bridge, in how PVID is interpreted. For the bridge, when
> VLAN filtering is disabled, ingressing traffic will be assigned to VID
> 0. This is true even if the port's PVID is set. A mv88e6xxx port who's
> QMode bits are set to 00 (802.1Q disabled) OTOH, will assign ingressing
> traffic to its PVID.
>=20
> So, in order to match the bridge's behavior, I think we need to rethink
> how mv88e6xxx deals with non-filtering bridges. At first, one might be
> tempted to simply leave the hardware PVID at 0. The PVT can then be used
> to create isolation barriers between different bridges. ATU isolation is
> really what kills this approach. Since there is no VLAN information in
> the tag, there is no way to separate flows from different bridges into
> different FIDs. This is the issue I discovered with the forward
> offloading series.
>=20
> > It appears that injecting packets using a VLAN ID of 0 serves the
> > purpose of forwarding the packets to the egress port with no VLAN tag
> > added or stripped by the hardware, and no filtering being performed.
> > So we can simply remove the superfluous logic.
>=20
> The problem with this patch is that return traffic from the CPU is sent
> asymmetrically over a different VLAN, which in turn means that it will
> perform the DA lookup in a different FID (0). The result is that traffic
> does flow, but for the wrong reason. CPU -> port traffic is now flooded
> as unknown unicast. An example:
>=20
> (:aa / 10.1)
>     br0
>    /   \
> sw0p1 sw0p2
> \         /
>  \       /
>   \     /
>     CPU
>      |
>   .--0--.
>   | sw0 |
>   '-1-2-'
>     | '-- sniffer
>     '---- host (:bb / 10.2)
>=20
> br0 is created using the default settings. sw0 will have (among others)
> static entries for the CPU:
>=20
>     fid:0 addr:aa type:static port:0
>     fid:1 addr:aa type:static port:0
>=20
> 1. host sends an ARP for 10.1.
>=20
> 2. sw0 will add this entry (since vlan_default_pvid is 1):
>=20
>     fid:1 addr:bb type:age-7 port:1

Well, that's precisely mv88e6xxx's problem, it should not make its
ports' pvid inherit that of the bridge if the bridge is not VLAN aware.
Other drivers inherit the bridge pvid only when VLAN filtering is turned
on. See sja1105, ocelot, mt7530 at the very least. So the entry should
have been learned in FID 0 here.

> 3. CPU replies with a FORWARD (VID 0).
>=20
> 4. sw0 will perform a DA lookup in FID 0, missing the entry learned in
>    step 2.
>=20
> 5. sw0 floods the frame as unknown unicast to both host and sniffer.
>=20
> Conversely, if flooding of unknown unicast is disabled on sw0p1:
>=20
>     $ bridge link set dev sw0p1 flood off
>=20
> host can no longer communicate with the CPU.
>=20
> As I alluded to in the forward offloading thread, I think we need to
> move a scheme where:
>=20
> 1. mv88e6xxx clears ds->configure_vlan_while_not_filtering.

No, that's the wrong answer, nobody should clear ds->configure_vlan_while_n=
ot_filtering.
mv88e6xxx should leave the pvid at zero* when joining a bridge that is
not VLAN-aware. It should inherit the bridge pvid when that bridge
becomes VLAN-aware, and it should reset the pvid to zero* when that
bridge becomes VLAN-unaware.

> 2. Assigns a free VID (and by extension a FID) in the VTU to each
>    non-filtering bridge.

*with the mention that the pvid of zero will only solve the first half
of the problem, the discrepancy between the VLAN classified on xmit and
the VLAN classified on rcv.

It will not solve the ATU (FDB) isolation problem. But to solve the FDB
isolation problem you need this:
https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-=
1-vladimir.oltean@nxp.com/

> With this in place, the tagger could use the VID associated with the
> egressing port's bridge in the tag.

So the patch is not incorrect, it is incomplete. And there's nothing
further I can add to the tagger logic to make it more complete, at least
not now.

That's one of the reasons why this is merely a "part 1".=
