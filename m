Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D11422A65C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 06:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgGWEFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 00:05:16 -0400
Received: from mail-eopbgr40051.outbound.protection.outlook.com ([40.107.4.51]:56034
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726021AbgGWEFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 00:05:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ASgvWa3ciU76Xrv7WX+Za4dQyPSP7Ivw1yrWYTH3627Xr2uNkzttgO9BvyBmS5HtCs31Muyned1weMNccVdyRrDonYfOJcyTpSINy5+93EdH5Zf4/Iqcs0tek3gcqRjyRjBxHmd1Qq6OrqiWeavAK7hhoR+DOJn4jyHZiWKjDbLyHygy8cOp/U3xdnzwRfAnS+IYOtF3j/Z1NEifNAIMK7rye8QrqUhIsA6GFK6IsmnZx9DCJT1ZG+lWeIOZ526yegc7yVqLkRhd7XKfP3pPXUNv5A/EVZwAxlgh2iifITpCZc284H9vEoK4sr67UJrziizrW3akDuTo3oySWP3nRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLgrz+vVbYbxKYsbWQiZ5JMZjG0vYxlg3gSi6jQHneI=;
 b=RhuF+yYazDaixKOEEbaUFL0GHhdIZqWX5Jz/hthO3M4InxoTLho4ONPGqgKNvJk5Qk48rczYCqWeE6dnIxbDcBl4HJ3fLTEkHa4TtLuhkEsFEPVWF4fTBBFCXuRK5EerMVtm3nB1YanuKKR1/+uqd+Eb53emdgXsiRAS/XO3m39NEiEyG4RVNEbfObdFg5eT+dHA2RTYDTT98PFLqrQu2V0Ew3D1FarrFYov8G0YAeE1wsw38MMHAki68mmz7hUR4DSnMBOwJPngPuXRi3UcbOfkx4nk3pUXA21BmA1l/NIoGQlagHW9IlluX2b7kt5SEQJ3WA45B/KSRqkVsUdHBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLgrz+vVbYbxKYsbWQiZ5JMZjG0vYxlg3gSi6jQHneI=;
 b=CoDxPqqqtmSbOLv6rGstHnD9eBmMVSVBpaHeqEiWwu3qYJ4EZWJUoJvrE2M9oqQ0LZ4xfgrPX2AvoOmxnQP+oNgsNmMA4W9pv00xJBJ98r7GCoiuZRP+4FmTAkXzz5HGuEa3MfL4nB0YG4YSpc8f5VZ/y0hVft744vpsnd0YC38=
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5245.eurprd04.prod.outlook.com (2603:10a6:803:5a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Thu, 23 Jul
 2020 04:05:10 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3216.022; Thu, 23 Jul 2020
 04:05:10 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: RE: [EXT] Re: [PATCH v3 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Topic: [EXT] Re: [PATCH v3 2/2] net: dsa: ocelot: Add support for QinQ
 Operation
Thread-Index: AQHWYBLysSTEQPz7eU+nSm5YKzLQAakTjicAgAD0qUA=
Date:   Thu, 23 Jul 2020 04:05:10 +0000
Message-ID: <VI1PR04MB5103C716DBB73ABA72D8131EE1760@VI1PR04MB5103.eurprd04.prod.outlook.com>
References: <20200722103200.15395-1-hongbo.wang@nxp.com>
 <20200722103200.15395-3-hongbo.wang@nxp.com>
 <20200722125352.qbllow6pm6za5pq4@skbuf>
In-Reply-To: <20200722125352.qbllow6pm6za5pq4@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ee12ca6e-fc4f-4670-a42e-08d82ebd9806
x-ms-traffictypediagnostic: VI1PR04MB5245:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB52451F0C048E2FB246A78E11E1760@VI1PR04MB5245.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CkqKCYXqLF6u8LlfPakB0JKpoMTVNr/WgpJZ8CtANiUW6s3IXgq9Sr9YaMdj6RnqpG8kH01HazsAyo4uCY6qBNCD1PL1kdC7R/ZFnNeqVaAOrh67vlTzfLB9t+P9fCWJaWMu+L4G4Clp++/HA09FvuDt26zfnOxGlw7DtkEnGd+t6HGM5+Xn6DJDUq9JLxNW9XvtiedGM3+s5g2uOqkShUxURcspaaEprvAs/Fo4SvYGOfoJ2SaehPgM3EL9S590CM2j5NQpBtZOBcK0T+0WG5HjdshSN0u08G+HNFIbXrThRJAuuI+LFMroNApXn+glkNiHG5l4Q2zY73Edy+9/NA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(2906002)(7696005)(44832011)(26005)(7416002)(6506007)(33656002)(5660300002)(86362001)(9686003)(186003)(8676002)(478600001)(83380400001)(316002)(8936002)(55016002)(71200400001)(6916009)(66946007)(64756008)(66556008)(66476007)(66446008)(4326008)(76116006)(54906003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: m/EW9DtrbWnYqAVuZITkp16ybt4qikb4IXtkz7PBLDYj8Nfj7ohvjVwNlJ8RYmoDfcyOLVd+fjruUCz9wKoOpnmRArpquo2wysuPkwns1P3cdJMQsWU21BN04pO/JRtdSiHWfvkQLkf+TBL56WyDdZBB9KvmV85XgRfZhE0bt4a3UU8kOB55Spk96Iv3/iLgyO+p5tj/DdVJBhFVQBjrcoIjDhxWh5ts/iJsiaX8roX/BRByTFD0g1YEPE7g1hPHZlOsYAHEOEIbVlJzlp8oBEwCYrZW2LPMcI2gtsorsD9ocNfj7oKMALMjmp29MqiqDXNapMxt64V1hXmFA8HzC+EjaKZawQJBuV/z86+S8q5qSqzoGHRmB0g4G95055d7W3betNWq7qcImtCcrLM4vkoj6nZ/cc7PYNMRD1/SGlEUpwqVRvyX/1b8mkgXndAW8c3m0cyvxrJEjx/tbRQXQdSopkSbN7x6SoJH7XE9TXJ/h5jlp/zC0aRFFSSAcoqY
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee12ca6e-fc4f-4670-a42e-08d82ebd9806
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 04:05:10.5614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LdlSUumxgHbhxrUE6D7ssBGMiilyIZw6YyT73b7z8nTR4m4XwVl/xaHAVKmC/VFhi30IzgWsZyQAlc6sN7xq3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5245
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Instead of writing a long email, let me just say this.
> I ran your commands on 2 random network cards (not ocelot/felix ports).
> They don't produce the same results as you. In fact, no frame with VLAN
> 111 C-TAG is forwarded (or received) at all by the bridge, not to mention=
 that
> no VLAN 1000 S-TAG is pushed on egress.
>=20
>=20
> Have you tried playing with these commands?
>=20
> ip link add dev br0 type bridge vlan_filtering 1 vlan_protocol 802.1ad ip=
 link
> set eth0 master br0 ip link set eth1 master br0 bridge vlan add dev eth0 =
vid
> 100 pvid bridge vlan add dev eth1 vid 100
>=20
> They produce the same output as yours, but have the benefit of using the
> network stack's abstractions and not glue between the 802.1q and the brid=
ge
> module, hidden in the network driver.
>=20
> I am sending the following packet towards eth0:
>=20
> 00:04:9f:05:f4:ad > 00:01:02:03:04:05, ethertype 802.1Q (0x8100), length
> 102: \
>         vlan 111, p 0, ethertype IPv4, 10.0.111.1 > 10.0.111.3: \
>         ICMP echo request, id 63493, seq 991, length 64
>=20
> and collecting it on the partner of eth1 as follows:
>=20
> 00:04:9f:05:f4:ad > 00:01:02:03:04:05, ethertype 802.1Q-QinQ (0x88a8),
> length 106: \
>         vlan 100, p 0, ethertype 802.1Q, vlan 111, p 0, ethertype IPv4, \
>         10.0.111.1 > 10.0.111.3: ICMP echo request, id 63493, seq 991,
> length 64
>=20
> Thanks,
> -Vladimir

Hi Vladimir,
  the command " ip link add dev br0 type bridge vlan_filtering 1 vlan_proto=
col=20
802.1ad " will influence all ports within the bridge, it will enable all po=
rts vlan_filtering
flag and 802.1ad mode, if ocelot port enable vlan_filtering, it will set VL=
AN_AWARE_ENA
and VLAN_POP_CNT(1), the code is in ocelot_port_vlan_filtering in ocelot.c.=
 it will
pop one tag from ingress frame, it's not my need, so I don't set vlan_filte=
ring.

  If enable vlan_filtering, it needs enable VCAP ES0 push double VLAN tag, =
the code
is in another patch, it's based on VCAP ES0 related code, I will post it af=
ter ES0 code
be accepted.

  In this case, I only want the egress port(swp1) in QinQ mode, the mode wi=
ll change swp1's
REW_TAG value, don't need swp0 enter QinQ mode, another issue is that if us=
e " ip link add dev=20
br0 type bridge ...", it can't pass proto to port driver, in dsa_slave_vlan=
_rx_add_vid, it will walk
into here:
		ret =3D br_vlan_get_info(dp->bridge_dev, vid, &info);
		if (ret =3D=3D 0)  // ret is 0
			return -EBUSY;
so I use "ip link add link swp1 name swp1.111 type vlan protocol 802.1ad id=
 111" to enable only
port swp1's QinQ mode.

Thanks,
hongbo


