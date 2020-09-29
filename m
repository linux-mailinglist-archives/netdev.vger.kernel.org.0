Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291DE27D83E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgI2UdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:33:14 -0400
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:64590
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725372AbgI2UdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 16:33:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWf4widwgQZKThnlEVLiV5f7hGJwRbTC4U4MU0IGO4bo+fWewmYoKR2JPyqkgZ8DqlOm/ae68lYqoYstOY2fcBg4oAa2P/YBbgqLrJyalH0yRnBv3TGhddj86jLgsI1I1GSQKEYuyAs6IHVdKsCpLhziKTeo+qel5NJx6L1RVmxfdpUVLfSHX4ZDBoexNeDAnHyZN8TpL3DZSPdP6URsnBxxR5GZA2E2d4T+cEXBSRM0bIgTXG0kn2E/ikRM1KSKb0pTD02pP1uLw/WlobAs+4METCwMeo+2sfR5ST2/HJZJBNxB7V0AE9cL/poOfaOWds6fgY7Aw5aeFyjAw0+UTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oafLxV+rIZES4vJ960HZFA33bMs5RePS6TRTo+/am/k=;
 b=ODu+hkley3Ll1b4GtLlUKwwTCbxoIg4axhFj3eVeCuwTnnubMHMGImtikWW2UGjTJGe+f3ba1jcTKigOxbutMYLRQr/f5w+XAb8GVXI+Rh0Zet69ivCHMP1OGsCCuw3KFQ+hyDzOm12wM85OKpM/73bWzylW32tSYleEDG2E7wqIu1x1J8KnFAL9zs6AKQ+pxQaJ9SGDTAGHcnxzA6DYYu+W99lBGG6gWaGWzKCUAPmZGGGgyVDmgCEz0H2I7SFXX5Ex9uEHvB9EpkTA5tfrS1AzEx6szbZue6UwA8bIDKQu1GKtOvvYnvpD540PnFSUiF2nntjgzke7iAoPdthi8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oafLxV+rIZES4vJ960HZFA33bMs5RePS6TRTo+/am/k=;
 b=CYqpG2cSjWijk6Bfd03TugFdC2PuL2dvHWB7C14K4PRcCi5PG7f0+P0m1Mj4oeHzOOIlmR9diT0JRNoY4Hw9qnr98+YZVPLNTspnowVdAUPpZp7FoUxRKPGMpuAnCyZzB9hnbkMPqPAnD/pIIG0u757rzREzSTgPUMB+Ufh6hwQ=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Tue, 29 Sep
 2020 20:33:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 20:33:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Radu-andrei Bulie <radu-andrei.bulie@nxp.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 devicetree 2/2] powerpc: dts: t1040rdb: add ports for
 Seville Ethernet switch
Thread-Topic: [PATCH v2 devicetree 2/2] powerpc: dts: t1040rdb: add ports for
 Seville Ethernet switch
Thread-Index: AQHWllQyl+0N41wVskyCvsQrZKm24ql//B+AgAAH04CAAAijAIAABjyA
Date:   Tue, 29 Sep 2020 20:33:09 +0000
Message-ID: <20200929203307.ywjtjyogbpo6x6xl@skbuf>
References: <20200929113209.3767787-1-vladimir.oltean@nxp.com>
 <20200929113209.3767787-3-vladimir.oltean@nxp.com>
 <20200929191153.GF3996795@lunn.ch> <20200929193953.rgibttgt6lh5huef@skbuf>
 <20200929201048.GG3996795@lunn.ch>
In-Reply-To: <20200929201048.GG3996795@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 349c6484-1201-4940-92b4-08d864b6e0d8
x-ms-traffictypediagnostic: VI1PR04MB6270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6270903BD8B8674E2CA02B2FE0320@VI1PR04MB6270.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +JhrorQJ6bJFJFQQCHgAVp531uWb7xYbu0/KXPcOvgHuXKxOBJtkQdVzls7ayTFnSZah44jEXu7RP1TphVvh4A+yUJfYROppiieoMdAQHe07XHTTSD2pmq4qHB8QWAuGkrKdUYkykEBLNXl/9OioX9p+WrXHUgCaN/fmW/k5qvY9FrcVDhCDsrwBVOiQ2avR15LoZRfQRq6YTKIoykl6fvqoaz9al7gPQUCYyFYssZ/Jc0FXsI68oKmVcZFo5b2ulv164FwX97ufPNRp/MMuAmqZU5Lt8uDGUMzooiPGIYAOxlLkPPlyHbTfGNj1tTAumsxtXpZWGMFbs2K9N96+qY8Is6MxzBneKa6JMo81O55ll4TiFr9ybUE5O/Zp3HuE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(136003)(376002)(396003)(366004)(346002)(2906002)(83380400001)(478600001)(186003)(54906003)(6506007)(316002)(91956017)(66946007)(66446008)(71200400001)(76116006)(64756008)(86362001)(66476007)(66556008)(26005)(44832011)(1076003)(33716001)(5660300002)(8936002)(4326008)(6916009)(6486002)(8676002)(6512007)(9686003)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: S+7N17SNMk6kF20BDUqYmkt4LFUJdfi+Q9g9DVoyCPS4tLj24Z2lnJqlSqjt5BmlNvt/z1AnvK+8NaY0Hh1s0itnXhvDTtY1Hs3CZ0FvpYYs1N2CUQnYdjhvk6SL4QopSaTZAF9P0QUUcCV8YQUnZkldAx5yOlHw+S4swQu9H3QpH2ypSe3vGP1I626hsSDwnnG/UpGIbM1a/B6TBT1BqKZBE2Z8JA15PQYuOotWCr/Wiju+KnFWPLGLYdOdlWddrNfFwAltq5mxkdT1HNL1C7HrXaIV8t+/SUH28D6aHypcQ8gBBEYgculKJM/ZPwn22l2kOUTV+FOYQktqBsPgEzXxGSfxUm8fDPETbemWyqlxAcA1/HnPkmgq4m75Yc5kdbfQfmioyajeNyX5CGcGaUEgTy27tffvXVdPzqWfF8VApotkp2BvM2sg9+zojZj6LJKdZoRJLtXY3La3Afapi2igL2sj3b2sK5buizcpMQJKHKwBZ2iGEyu/+C6Zwgm20I4M9OX/5VEyKZVMLH9uVDfyNCuB+MkjJ1ytOMj0lprVgOaNynkroJdLnFR0Y7P36u76/rPF8lZP7eAwjTpHXa7VieAfbUM/lIMrbnk8dtH3HtZbGrivJwRM0pz1gWJcchapc7CYeZI0BIhaxaF59w==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BEFB5A9AA2E4394C878894AEF5F98541@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 349c6484-1201-4940-92b4-08d864b6e0d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 20:33:09.1060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I3IjvYFDoDRo8yPoCopYhIQaVlcFIIXhfaR9pnQMqcqogMn35AnWGl7AS5BGezwZNLYIGYUNwJJgm11Yvf5QWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 10:10:48PM +0200, Andrew Lunn wrote:
> On Tue, Sep 29, 2020 at 07:39:54PM +0000, Vladimir Oltean wrote:
> > On Tue, Sep 29, 2020 at 09:11:53PM +0200, Andrew Lunn wrote:
> > > > +&seville_port0 {
> > > > +	managed =3D "in-band-status";
> > > > +	phy-handle =3D <&phy_qsgmii_0>;
> > > > +	phy-mode =3D "qsgmii";
> > > > +	/* ETH4 written on chassis */
> > > > +	label =3D "swp4";
> > >
> > > If ETH4 is on the chassis why not use ETH4?
> >
> > You mean all-caps, just like that?
>
> Yes.
>
> DSA is often used in WiFI access point, etc. The user is not a
> computer professional. If the WebGUI says ETH4, and the label on the
> front says ETH4, they probably think the two are the same, and are
> happy.
>
> I have one box which does not have an labels on the front panels, but
> the industrial sockets for Ethernet are colour coded. So the interface
> names are red, blue, green, to match the socket colour, and the cable
> set is also colour coded the same.
>
> So long as it is unique, the kernel does not care. So make it easy for
> the user.

It would look like this:

[root@T1040 ~] # ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DE=
FAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNO=
WN mode DEFAULT group default qlen 1000
    link/ether de:91:41:1a:92:b8 brd ff:ff:ff:ff:ff:ff
3: fm1-gb3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mo=
de DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:68 brd ff:ff:ff:ff:ff:ff
4: fm1-gb4: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOW=
N mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:88 brd ff:ff:ff:ff:ff:ff
5: fm1-gb0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1504 qdisc mq state UP mo=
de DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
6: fm1-gb1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mo=
de DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:28 brd ff:ff:ff:ff:ff:ff
7: fm1-gb2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOW=
N mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:48 brd ff:ff:ff:ff:ff:ff
8: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group de=
fault qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
9: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group def=
ault qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
10: ETH4@fm1-gb0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue =
state UP mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
11: ETH5@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueu=
e state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
12: ETH6@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueu=
e state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
13: ETH7@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueu=
e state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
14: ETH8@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueu=
e state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
15: ETH9@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueu=
e state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
16: ETH10@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noque=
ue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
17: ETH11@fm1-gb0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noque=
ue state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
    link/ether 00:1f:7b:6a:02:08 brd ff:ff:ff:ff:ff:ff
[root@T1040 ~] # ip link set ETH4 down
[   94.942190] mscc_seville ffe800000.ethernet-switch ETH4: Link is Down
[root@T1040 ~] # ip link set ETH4 up
[  100.262533] mscc_seville ffe800000.ethernet-switch ETH4: configuring for=
 inband/qsgmii link mode
[  100.272122] 8021q: adding VLAN 0 to HW filter on device ETH4
[  103.333369] mscc_seville ffe800000.ethernet-switch ETH4: Link is Up - 1G=
bps/Full - flow control rx/tx
[  103.342697] IPv6: ADDRCONF(NETDEV_CHANGE): ETH4: link becomes ready

I'm not in love, but I guess at least there won't be any doubt if they
are named like this. I'm sending another revision with these names soon.

Thanks,
-Vladimir=
