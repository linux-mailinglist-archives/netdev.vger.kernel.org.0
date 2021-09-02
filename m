Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D656B3FF21F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346558AbhIBRLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:11:38 -0400
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:2286
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346549AbhIBRLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 13:11:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpHgCDBdw9ROHvCFj+cfoSNbLrdnWA+mOXBaRnnpKxG0J+ounONVztsUYczemW+qMQ1rImUabgGI5BqsHSzBo9SLB6mIXeUCd1VsfJoINgG/L63Er8Tf1Pd4e3J3bws4XkSxID8cLVGWMoCEpFBNJaxFqC6EDackEnr+C/AslYhRF7K2cC5gUmf96bP5ziYFWRTp2WgjYuZWnXA07YyqM6et+piqW5wWiBuha6YJ2lyb1xCb33CU8FIVWa2tiBiZurscVOiA3T2UfLkikaxJ5GZoHxPit9d/glHKwUEzOAGCDCQlfuzZLL70+JQlpRjGGbyJUF7jueRo2zQZDAQDUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qwGB6wn1uJohZmM5svuL3zp8qhZL6z0ryRBAzI10w8=;
 b=mqGL7LxJSvRN1xK7STvduDTMC0t5KCKeQnibqfAxpCx4BAyS1O+eRf4o1RMxbX16vJmE7H/T/elOJCgYVeMVh4H5U6Mom2e1aA68ZD16FEPI02bVoejN3veXzBw0o7SlmJkpVH/8nThiPrxF0oC/p74cV6TN/I7bo8N9wTH/wnWyBimoH40y1wmSUPwH6GrKfAE0JxftW4ybS7zLR5JQte+7WoeeLNPOkC9lv4paJ5/Xp57EfYicYljBmEqMT5Qwsy7mzQD11cYbi202z4L89v2JUK+Qe+b3w+crOoY6mztpHlIaMTT67X+kNlynmVF8UCFn9br+FRmpHukN2Mk0/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qwGB6wn1uJohZmM5svuL3zp8qhZL6z0ryRBAzI10w8=;
 b=Mjc6womiURxUcQ7uDB3tiVBmoz6oTl5nhaLtv6JRvYurgvWilqh9rJSrY44ss7rS9c5hfIki74/09d1bu3ARqF8DkuJBSUaz1ef79uC0zxgEwI9ueQc7LMjbKG/OSQndcZQzoU3sQHoUHg8waodTcbbCQUkpRHBAMLNdodnPbqA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Thu, 2 Sep
 2021 17:10:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.026; Thu, 2 Sep 2021
 17:10:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Thread-Topic: [RFC PATCH net-next 0/3] Make the PHY library stop being so
 greedy when binding the generic PHY driver
Thread-Index: AQHXn4PYDBrTet8u00a3LEwZfYtsUauQqoOAgAAEfwCAAA5DgIAAILkAgAATAgCAAArYgA==
Date:   Thu, 2 Sep 2021 17:10:34 +0000
Message-ID: <20210902171033.4byfnu3g25ptnghg@skbuf>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210902121927.GE22278@shell.armlinux.org.uk>
 <20210902123532.ruvuecxoig67yv5v@skbuf>
 <20210902132635.GG22278@shell.armlinux.org.uk>
 <20210902152342.vett7qfhvhiyejvo@skbuf>
 <20210902163144.GH22278@shell.armlinux.org.uk>
In-Reply-To: <20210902163144.GH22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62ba6451-6cf2-4e83-7ce0-08d96e3493df
x-ms-traffictypediagnostic: VE1PR04MB7341:
x-microsoft-antispam-prvs: <VE1PR04MB7341C8605FE569E8AA23D37FE0CE9@VE1PR04MB7341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0Vf6gVQWLX/Nl33HLRmJ6LwTkxRae0PGN0s3snZ2R+bQqx8qWRPh9YZo25NBVYYbdjFJZEghXp/RXGg+YSMx06oXRRKlksqkA8C0De+QzFCbUPRe/jYjR3VaoPlpE9fk0Vgzime+TYKkVl+2SbBstQuY/+TKiGKhjrwqrUvzHGDGmpDi5/dHrhXuvuhqGkzBGTTcFE9tlQIYd7CXJhfB5UDq8pZrIdBCVVwokkezyiUV+4EShDNPHkHI6YWKaULJCRbmfR3fUZAReApnzwqDHM51NYlw86JJL9V7FwjjTp1LM7qg0zQo4OC6zqaEnRBtKh0/tghUAH4usZjBuWy17HbVFpoNsEezRdIOIe70kGXsVsDMpbuTUYRPpuH9ZBiumqojXxqZ5agAfsFdDl8NnAvRDWjYAKW2bnZXa9oAu6cFJudQIot2aA5IGHl5UvKmXaD6j0y7EoGIbdnN2us1f7Lr6DITCviyza9CBXE0v8ElQahGdDnjgCWnuzZw37BSyR39eKiQbIcPjh7A+tgDGlaxJuTca0dQfYKpOeOJSGkDKt4VCM52Bu64z0IF0mDeRR7EyA9xjrppFthholIhYhFItAqz9h+Svo62246LOnG42VtCUHyg6MQo2eoO1o2x0jLdsU2YiVuldnsHrv7KS3m8J1G0o5wteUSdVQMezjLWQPeEbCstbbl6ptTCM0aHiZQe3px5JJPrCDIDHVsZjNkswH+0EnQfH8fxPCxUdAsMDKmHl665Nz7uGpUXJVUTRzT31SmLcq9dJ2dUfq2W+2WPgTOAsIsLjpfLmcI6mh9/VLiJOCQTf4N8Rw9uOWwd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(83380400001)(966005)(66556008)(6916009)(6486002)(30864003)(45080400002)(478600001)(38070700005)(66446008)(1076003)(316002)(66476007)(54906003)(44832011)(5660300002)(19627235002)(33716001)(186003)(38100700002)(66946007)(4326008)(8676002)(66574015)(26005)(122000001)(76116006)(6506007)(64756008)(8936002)(6512007)(9686003)(7416002)(2906002)(71200400001)(86362001)(41533002)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?qmacf9R1KmfprbRWuvWctRdyRfK4GRmQThxyea3M3p75PeFl3MhV1kqP?=
 =?Windows-1252?Q?vtQ7Cp3McW3nU+EEDw5I079UD4IYPHeOIWSoYGrtoFGJ2C7d2lQYmyBq?=
 =?Windows-1252?Q?apJfrslzEsNRjgs/KMyMjlrM3Lm9v8O5o/NcEAHDHqY0hymsneaC4C98?=
 =?Windows-1252?Q?cN7J9wkDrSmW7VEyb8sBzHU6A8nWke4Ev59M+vXSFquB7K2UZAwahu5X?=
 =?Windows-1252?Q?enMt/wLBAjsbbDU2h5B0kdeC0URbDYDHeMTKQXh+IgWywmXHT9xaef0W?=
 =?Windows-1252?Q?GVjUywdeC0HYuNjmqmqfFmowmqM0RyuL2TSTUB/e3TAW5+WuVMIATCbb?=
 =?Windows-1252?Q?HRoF5h1FbEtYBLNZ84O9+3A3bbAHaesc4GkJPBMCk2hLMxjlF1bOAcLs?=
 =?Windows-1252?Q?NENH2VCPdS/Yx6BMGgGI632lqQf+aVs+IjZYaFxIi89QgNApl0oL7Y9H?=
 =?Windows-1252?Q?sT4PU9w75NwqVC4l6uji1cKz2pu/Fg+UncmRurLaZe0evk8QKrEBwdDt?=
 =?Windows-1252?Q?adsQBm6sj65Vby/lVm0O3NSk3xW0lPO8bAL4BK9/dNSx7mDMYwOUoeIW?=
 =?Windows-1252?Q?rYpr15H6T5fxg8II1bCN8FFq0rU1DBgiipKmPX2nZOoi+JRO/peLmQej?=
 =?Windows-1252?Q?tfMEoVLvlmsLWcUKkYnVFUlaLMTKWn2By3ib9aIfQdlKCgafpN58slDr?=
 =?Windows-1252?Q?QlEGSCMAYg+Mh3L/eWlB5JXNVZyx3Hz9trTRi0AVuI/iunjQVFaod4Ml?=
 =?Windows-1252?Q?K6SaRO/HIQo3pOKPEIFPDJJWugAe6RLJ2oy4AN97hvMZyX03tckcroyv?=
 =?Windows-1252?Q?wV6XRfsBUqKiD/VfYbLkPX8QPTyRf93AuzWB18+9BL5tn47MOmdjNojH?=
 =?Windows-1252?Q?ecR5JYSrpzFp/n6Mey9RtLBDNzVsnOuQ+sf11D4slRD465FHsqUs2bvz?=
 =?Windows-1252?Q?vpl5dKRND5yzKB3DbT0QiHwYdRRvh/R1GwCoj06qqJfq3MrSq/kG3VGm?=
 =?Windows-1252?Q?YRfvhG4t5Fr/CUYzFf01p3i6H3D23x/8vfDxqTsfkbXx4AZV9rWOeXef?=
 =?Windows-1252?Q?DvkKIbg7EIPpiP1VXljghag5PH19XjpSEe/A2EHVXSPRKFNC7Rd7AfQj?=
 =?Windows-1252?Q?gcZvVv+wTpA6MgMyybMFsGiOwXEW0fbO3WzGnidJQ442jQbdNDtCbvse?=
 =?Windows-1252?Q?5rOiagsa2Q6zGeMb542E/FgO4LObGzcbNKUS68owPH1Qf0GYpFopgPSR?=
 =?Windows-1252?Q?UtRlBZzDoCUPaeUeVcT4q+SXy72R910xCgn+T8fXjtrn+PogYg+N1+EL?=
 =?Windows-1252?Q?33uWwq7Y2/lmTsnj8Az7D2v3ZtB8wYLRPIEHU/DeGTSldg9UQsSAg554?=
 =?Windows-1252?Q?RnlAsxrjraU46cxqrELaLDJgPmxmrejUbdc3cUiJ3ieBtbXXi6RztVhC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <0016150BD4952349B9F4A570E57A6C4B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ba6451-6cf2-4e83-7ce0-08d96e3493df
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 17:10:34.4819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JE8/hkSdNYuguIYc0j3PZAi4m7GYSShleYdkBbZlTFlfOsquw2xFOI82suiiytH0oK/R1Vw4h+NV+H6bNjkXfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 05:31:44PM +0100, Russell King (Oracle) wrote:
> On Thu, Sep 02, 2021 at 06:23:42PM +0300, Vladimir Oltean wrote:
> > On Thu, Sep 02, 2021 at 02:26:35PM +0100, Russell King (Oracle) wrote:
> > > Debian has had support for configuring bridges at boot time via
> > > the interfaces file for years. Breaking that is going to upset a
> > > lot of people (me included) resulting in busted networks. It
> > > would be a sure way to make oneself unpopular.
> > >
> > > > I expect there to be 2 call paths of phy_attach_direct:
> > > > - At probe time. Both the MAC driver and the PHY driver are probing=
.
> > > >   This is what has this patch addresses. There is no issue to retur=
n
> > > >   -EPROBE_DEFER at that time, since drivers connect to the PHY befo=
re
> > > >   they register their netdev. So if connecting defers, there is no
> > > >   netdev to unregister, and user space knows nothing of this.
> > > > - At .ndo_open time. This is where it maybe gets interesting, but n=
ot to
> > > >   user space. If you open a netdev and it connects to the PHY then,=
 I
> > > >   wouldn't expect the PHY to be undergoing a probing process, all o=
f
> > > >   that should have been settled by then, should it not? Where it mi=
ght
> > > >   get interesting is with NFS root, and I admit I haven't tested th=
at.
> > >
> > > I don't think you can make that assumption. Consider the case where
> > > systemd is being used, DSA stuff is modular, and we're trying to
> > > setup a bridge device on DSA. DSA could be probing while the bridge
> > > is being setup.
> > >
> > > Sadly, this isn't theoretical. I've ended up needing:
> > >
> > > 	pre-up sleep 1
> > >
> > > in my bridge configuration to allow time for DSA to finish probing.
> > > It's not a pleasant solution, nor a particularly reliable one at
> > > that, but it currently works around the problem.
> >=20
> > What problem? This is the first time I've heard of this report, and you
> > should definitely not need that.
>=20
> I found it when upgrading the Clearfog by the DSL modems to v5.13.
> When I rebooted it with a previously working kernel (v5.7) it has
> never had a problem. With v5.13, it failed to add all the lan ports
> into the bridge, because the bridge was still being setup by the
> kernel while userspace was trying to configure it. Note that I have
> extra debug in my kernels, hence the extra messages:

Ok, first you talked about the interfaces file, then systemd. If it's
not about systemd's network manager then I don't see how it is relevant.
What package and version is this exactly, ifupdown, ifupdown2,
ifupdown-ng, busybox ifupdown? I think they all use the interfaces file.

> Aug 30 11:29:52 sw-dsl kernel: [    3.308583] Marvell 88E1540 mv88e6xxx-0=
:03: probe: irq=3D78
> Aug 30 11:29:52 sw-dsl kernel: [    3.308595] Marvell 88E1540 mv88e6xxx-0=
:03: probe: irq=3D78
> Aug 30 11:29:52 sw-dsl kernel: [    3.332403] Marvell 88E1540 mv88e6xxx-0=
:04: probe: irq=3D79
> Aug 30 11:29:52 sw-dsl kernel: [    3.332415] Marvell 88E1540 mv88e6xxx-0=
:04: probe: irq=3D79
> Aug 30 11:29:52 sw-dsl kernel: [    3.412638] Marvell 88E1545 mv88e6xxx-0=
:0f: probe: irq=3D-1
> Aug 30 11:29:52 sw-dsl kernel: [    3.412649] Marvell 88E1545 mv88e6xxx-0=
:0f: probe: irq=3D-1
> Aug 30 11:29:52 sw-dsl kernel: [    3.515888] libphy: mv88e6xxx SMI: prob=
ed
>=20
> Here, userspace starts configuring eno1, the ethernet port connected
> to the DSA switch:
>=20
> Aug 30 11:29:52 sw-dsl kernel: [    3.536090] mvneta f1030000.ethernet en=
o1: configuring for inband/1000base-x link mode
> Aug 30 11:29:52 sw-dsl kernel: [    3.536109] mvneta f1030000.ethernet en=
o1: major config 1000base-x
> Aug 30 11:29:52 sw-dsl kernel: [    3.536117] mvneta f1030000.ethernet en=
o1: phylink_mac_config: mode=3Dinband/1000base-x/Unknown/Unknown adv=3D0000=
000,00000200,00002240 pause=3D04 link=3D0 an=3D1
> Aug 30 11:29:52 sw-dsl kernel: [    3.536135] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 30 11:29:52 sw-dsl kernel: [    3.536135] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 30 11:29:52 sw-dsl kernel: [    3.536146] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 30 11:29:52 sw-dsl kernel: [    3.536146] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 30 11:29:52 sw-dsl kernel: [    3.572013] mvneta f1030000.ethernet en=
o1: mac link up
> Aug 30 11:29:52 sw-dsl kernel: [    3.572016] mvneta f1030000.ethernet en=
o1: mac link up
> Aug 30 11:29:52 sw-dsl kernel: [    3.572046] mvneta f1030000.ethernet en=
o1: Link is Up - 1Gbps/Full - flow control rx/tx
> Aug 30 11:29:52 sw-dsl kernel: [    3.657820] 8021q: 802.1Q VLAN Support =
v1.8
>=20
> We get the link to eno1 going down/up due to DSA's actions:

What "actions"? There were only 2 DSA changes related to the state of
the master interface, but DSA never forces the master to go down. Quite
the opposite, it forces the master up when it needs to, and it goes down
when the master goes down. See:

9d5ef190e561 ("net: dsa: automatically bring up DSA master when opening use=
r port")
c0a8a9c27493 ("net: dsa: automatically bring user ports down when master go=
es down")

So if eno1 goes down and that causes breakage, DSA did not trigger it.
Also, please note that eno1 goes down in your "working" example too.

>=20
> Aug 30 11:29:53 sw-dsl kernel: [    4.291882] mvneta f1030000.ethernet en=
o1: Link is Down
> Aug 30 11:29:53 sw-dsl kernel: [    4.309425] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 30 11:29:53 sw-dsl kernel: [    4.309425] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 30 11:29:53 sw-dsl kernel: [    4.309440] mvneta f1030000.ethernet en=
o1: configuring for inband/1000base-x link mode
> Aug 30 11:29:53 sw-dsl kernel: [    4.309447] mvneta f1030000.ethernet en=
o1: major config 1000base-x
> Aug 30 11:29:53 sw-dsl kernel: [    4.309454] mvneta f1030000.ethernet en=
o1: phylink_mac_config: mode=3Dinband/1000base-x/Unknown/Unknown adv=3D0000=
000,00000200,00002240 pause=3D04 link=3D0 an=3D1
> Aug 30 11:29:53 sw-dsl kernel: [    4.345013] mvneta f1030000.ethernet en=
o1: mac link up
> Aug 30 11:29:53 sw-dsl kernel: [    4.345014] mvneta f1030000.ethernet en=
o1: mac link up
> Aug 30 11:29:53 sw-dsl kernel: [    4.345036] mvneta f1030000.ethernet en=
o1: Link is Up - 1Gbps/Full - flow control rx/tx
>=20
> DSA then starts initialising the ports:
>=20
> Aug 30 11:29:53 sw-dsl kernel: [    4.397647] mv88e6085 f1072004.mdio-mii=
:04 lan5 (uninitialized): PHY [mv88e6xxx-0:00] driver [Marvell 88E1540] (ir=
q=3D75)
> Aug 30 11:29:53 sw-dsl kernel: [    4.397663] mv88e6085 f1072004.mdio-mii=
:04 lan5 (uninitialized): phy: setting supported 0000000,00000000,000022ef =
advertising
> 0000000,00000000,000022ef
> Aug 30 11:29:53 sw-dsl kernel: [    4.493080] mv88e6085 f1072004.mdio-mii=
:04 lan4 (uninitialized): PHY [mv88e6xxx-0:01] driver [Marvell 88E1540] (ir=
q=3D76)
> Aug 30 11:29:53 sw-dsl kernel: [    4.493093] mv88e6085 f1072004.mdio-mii=
:04 lan4 (uninitialized): phy: setting supported 0000000,00000000,000022ef =
advertising
> 0000000,00000000,000022ef
> Aug 30 11:29:53 sw-dsl kernel: [    4.577070] mv88e6085 f1072004.mdio-mii=
:04 lan3 (uninitialized): PHY [mv88e6xxx-0:02] driver [Marvell 88E1540] (ir=
q=3D77)
> Aug 30 11:29:53 sw-dsl kernel: [    4.577081] mv88e6085 f1072004.mdio-mii=
:04 lan3 (uninitialized): phy: setting supported 0000000,00000000,000022ef =
advertising
> 0000000,00000000,000022ef
>=20
> Meanwhile userspace is trying to setup the bridge while this is going
> on, and has tried to add the non-existent lan2 at this point, but
> lan4 has just been created in time, so Debian's bridge support adds
> it to the brdsl bridge:
>=20
> Aug 30 11:29:53 sw-dsl kernel: [    4.652237] brdsl: port 1(lan4) entered=
 blocking state
> Aug 30 11:29:53 sw-dsl kernel: [    4.652250] brdsl: port 1(lan4) entered=
 disabled state
>=20
> DSA continues setting up the other ports, here lan2, but the bridge
> setup scripts have already moved on past lan2.

How does this program know that lan2 exists before it starts attempting
to enslave it to a bridge via the brctl program, and what does DSA do to
violate that assumption?

>=20
> Aug 30 11:29:53 sw-dsl kernel: [    4.674038] mv88e6085 f1072004.mdio-mii=
:04 lan2 (uninitialized): PHY [mv88e6xxx-0:03] driver [Marvell 88E1540] (ir=
q=3D78)
> Aug 30 11:29:53 sw-dsl kernel: [    4.674052] mv88e6085 f1072004.mdio-mii=
:04 lan2 (uninitialized): phy: setting supported 0000000,00000000,000022ef =
advertising
> 0000000,00000000,000022ef
> Aug 30 11:29:53 sw-dsl kernel: [    4.674612] device lan4 entered promisc=
uous mode
> Aug 30 11:29:53 sw-dsl kernel: [    4.785886] device eno1 entered promisc=
uous mode
> Aug 30 11:29:53 sw-dsl kernel: [    4.786971] mv88e6085 f1072004.mdio-mii=
:04 lan4: configuring for phy/gmii link mode
> Aug 30 11:29:53 sw-dsl kernel: [    4.786980] mv88e6085 f1072004.mdio-mii=
:04 lan4: major config gmii
> Aug 30 11:29:53 sw-dsl kernel: [    4.786986] mv88e6085 f1072004.mdio-mii=
:04 lan4: phylink_mac_config: mode=3Dphy/gmii/Unknown/Unknown adv=3D0000000=
,00000000,00000000 pause=3D00 link=3D0 an=3D0
> Aug 30 11:29:53 sw-dsl kernel: [    4.786996] mv88e6085 f1072004.mdio-mii=
:04: p1: dsa_port_phylink_mac_config()
> Aug 30 11:29:53 sw-dsl kernel: [    4.789977] 8021q: adding VLAN 0 to HW =
filter
> on device lan4
> Aug 30 11:29:53 sw-dsl kernel: [    4.836720] brdsl: port 2(eno2) entered=
 blocking state
> Aug 30 11:29:53 sw-dsl kernel: [    4.836733] brdsl: port 2(eno2) entered=
 disabled state
>=20
> Here, the SFP port (on eno2) is added to the bridge.
>=20
> Aug 30 11:29:53 sw-dsl kernel: [    4.836907] device eno2 entered promisc=
uous mode
> Aug 30 11:29:53 sw-dsl kernel: [    4.837011] brdsl: port 2(eno2) entered=
 blocking state
> Aug 30 11:29:53 sw-dsl kernel: [    4.837019] brdsl: port 2(eno2) entered=
 forwarding state
> Aug 30 11:29:53 sw-dsl kernel: [    4.837058] IPv6: ADDRCONF(NETDEV_CHANG=
E): brdsl: link becomes ready
> Aug 30 11:29:53 sw-dsl kernel: [    4.846989] mv88e6085 f1072004.mdio-mii=
:04 lan4: phy link down gmii/Unknown/Unknown/off
> Aug 30 11:29:53 sw-dsl kernel: [    4.896264] mv88e6085 f1072004.mdio-mii=
:04 lan1 (uninitialized): PHY [mv88e6xxx-0:04] driver [Marvell 88E1540] (ir=
q=3D79)
> Aug 30 11:29:53 sw-dsl kernel: [    4.896278] mv88e6085 f1072004.mdio-mii=
:04 lan1 (uninitialized): phy: setting supported 0000000,00000000,000022ef =
advertising
> 0000000,00000000,000022ef
> Aug 30 11:29:53 sw-dsl kernel: [    4.934514] DSA: tree 0 setup
>=20
> Here, the DSA tree has finally finished initialising in the kernel.
>=20
> Aug 30 11:29:53 sw-dsl kernel: [    4.986877] mv88e6085 f1072004.mdio-mii=
:04 lan1: configuring for phy/gmii link mode
> Aug 30 11:29:53 sw-dsl kernel: [    4.986890] mv88e6085 f1072004.mdio-mii=
:04 lan1: major config gmii
> Aug 30 11:29:53 sw-dsl kernel: [    4.986896] mv88e6085 f1072004.mdio-mii=
:04 lan1: phylink_mac_config: mode=3Dphy/gmii/Unknown/Unknown adv=3D0000000=
,00000000,00000000 pause=3D00 link=3D0 an=3D0
> Aug 30 11:29:53 sw-dsl kernel: [    4.986907] mv88e6085 f1072004.mdio-mii=
:04: p4: dsa_port_phylink_mac_config()
> Aug 30 11:29:53 sw-dsl kernel: [    4.990199] 8021q: adding VLAN 0 to HW =
filter
> on device lan1
> Aug 30 11:29:54 sw-dsl kernel: [    5.041313] mv88e6085 f1072004.mdio-mii=
:04 lan1: phy link down gmii/Unknown/Unknown/off
> Aug 30 11:29:56 sw-dsl kernel: [    7.630016] mv88e6085 f1072004.mdio-mii=
:04 lan4: phy link up gmii/1Gbps/Full/off
> Aug 30 11:29:56 sw-dsl kernel: [    7.630031] mv88e6085 f1072004.mdio-mii=
:04 lan4: phylink_mac_config: mode=3Dphy/gmii/1Gbps/Full adv=3D0000000,0000=
0000,00000000 pause=3D00 link=3D1 an=3D0
> Aug 30 11:29:56 sw-dsl kernel: [    7.630043] mv88e6085 f1072004.mdio-mii=
:04: p1: dsa_port_phylink_mac_config()
> Aug 30 11:29:56 sw-dsl kernel: [    7.630294] mv88e6085 f1072004.mdio-mii=
:04 lan4: Link is Up - 1Gbps/Full - flow control off
> Aug 30 11:29:56 sw-dsl kernel: [    7.630312] brdsl: port 1(lan4) entered=
 blocking state
> Aug 30 11:29:56 sw-dsl kernel: [    7.630321] brdsl: port 1(lan4) entered=
 forwarding state
>=20
> I then notice that my Internet connection hasn't come back, so I start
> poking about with it, first adding it to the bridge:
>=20
> Aug 30 11:31:13 sw-dsl kernel: [   84.990122] brdsl: port 3(lan2) entered=
 blocking state
> Aug 30 11:31:13 sw-dsl kernel: [   84.990134] brdsl: port 3(lan2) entered=
 disabled state
> Aug 30 11:31:14 sw-dsl kernel: [   85.063971] device lan2 entered promisc=
uous mode
>=20
> And then setting it to up state and configuring its vlan settings:
>=20
> Aug 30 11:32:45 sw-dsl kernel: [  176.476090] mv88e6085 f1072004.mdio-mii=
:04 lan2: configuring for phy/gmii link mode
> Aug 30 11:32:45 sw-dsl kernel: [  176.476103] mv88e6085 f1072004.mdio-mii=
:04 lan2: major config gmii
> Aug 30 11:32:45 sw-dsl kernel: [  176.476109] mv88e6085 f1072004.mdio-mii=
:04 lan2: phylink_mac_config: mode=3Dphy/gmii/Unknown/Unknown adv=3D0000000=
,00000000,00000000 pause=3D00 link=3D0 an=3D0
> Aug 30 11:32:45 sw-dsl kernel: [  176.476120] mv88e6085 f1072004.mdio-mii=
:04: p3: dsa_port_phylink_mac_config()
> Aug 30 11:32:45 sw-dsl kernel: [  176.479495] 8021q: adding VLAN 0 to HW =
filter
> on device lan2
> Aug 30 11:32:45 sw-dsl kernel: [  176.537796] mv88e6085 f1072004.mdio-mii=
:04 lan2: phy link down gmii/Unknown/Unknown/off
> Aug 30 11:32:48 sw-dsl kernel: [  179.280863] mv88e6085 f1072004.mdio-mii=
:04 lan2: phy link up gmii/1Gbps/Full/rx/tx
> Aug 30 11:32:48 sw-dsl kernel: [  179.280877] mv88e6085 f1072004.mdio-mii=
:04 lan2: phylink_mac_config: mode=3Dphy/gmii/1Gbps/Full adv=3D0000000,0000=
0000,00000000 pause=3D03 link=3D1 an=3D0
> Aug 30 11:32:48 sw-dsl kernel: [  179.280888] mv88e6085 f1072004.mdio-mii=
:04: p3: dsa_port_phylink_mac_config()
> Aug 30 11:32:48 sw-dsl kernel: [  179.280894] mv88e6085 f1072004.mdio-mii=
:04: p3: dsa_port_phylink_mac_link_up()
> Aug 30 11:32:48 sw-dsl kernel: [  179.282958] mv88e6085 f1072004.mdio-mii=
:04 lan2: Link is Up - 1Gbps/Full - flow control rx/tx
>=20
> I had:
>=20
> iface brdsl inet manual
>         bridge-ports lan2 lan4
>         bridge-maxwait 0
> 	up brctl addif $IFACE eno2
>=20
> I now have:
> iface brdsl inet manual
>         bridge-ports lan2 lan4
>         bridge-waitport 10
>         bridge-maxwait 0
>         pre-up sleep 1
> 	up brctl addif $IFACE eno2

I searched google for the "bridge-ports" keyword relative to ifupdown
and could not find the source code of a program which parses this. Could
you let me know what is the source code of the program you are using?

>=20
> to ensure that all ports get properly configured.
>=20
> What can be seen from the above is that there is most definitely a race.
> It is possible to start configuring a DSA switch before the DSA switch
> driver has finished being probed by the kernel.
>=20
> Here is the kernel log from v5.7 which has never showed these problems,
> because DSA seemed to always setup everything in kernel space prior to
> userspace beginning configuration:
>=20
> Aug 25 23:03:54 sw-dsl kernel: [    5.793137] mvneta f1030000.ethernet en=
o1: configuring for inband/1000base-x link mode
> Aug 25 23:03:54 sw-dsl kernel: [    5.793148] mvneta f1030000.ethernet en=
o1: config interface 1000base-x
> Aug 25 23:03:54 sw-dsl kernel: [    5.793157] mvneta f1030000.ethernet en=
o1: phylink_mac_config: mode=3Dinband/1000base-x/Unknown/Unknown adv=3D000,=
00000200,00002240 pause=3D04 link=3D0 an=3D1
> Aug 25 23:03:54 sw-dsl kernel: [    5.793168] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 25 23:03:54 sw-dsl kernel: [    5.793170] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 25 23:03:54 sw-dsl kernel: [    5.819769] mvneta f1030000.ethernet en=
o1: mac link up
> Aug 25 23:03:54 sw-dsl kernel: [    5.819792] mvneta f1030000.ethernet en=
o1: Link is Up - 1Gbps/Full - flow control rx/tx
> Aug 25 23:03:54 sw-dsl kernel: [    5.948900] 8021q: 802.1Q VLAN Support =
v1.8
>   6.459779] mv88e6085 f1072004.mdio-mii:04: nonfatal error -95 setting MT=
U on port 0
> Aug 25 23:03:54 sw-dsl kernel: [    6.462890] mv88e6085 f1072004.mdio-mii=
:04 lan5 (uninitialized): PHY [mv88e6xxx-0:00] driver [Marvell 88E1540] (ir=
q=3D67)
> Aug 25 23:03:54 sw-dsl kernel: [    6.462905] mv88e6085 f1072004.mdio-mii=
:04 lan5 (uninitialized): phy: setting supported 000,00000000,000022ef adve=
rtising 000,00000000,000022ef
> Aug 25 23:03:54 sw-dsl kernel: [    6.465904] mv88e6085 f1072004.mdio-mii=
:04: nonfatal error -95 setting MTU on port 1
> Aug 25 23:03:54 sw-dsl kernel: [    6.468101] mv88e6085 f1072004.mdio-mii=
:04 lan4 (uninitialized): PHY [mv88e6xxx-0:01] driver [Marvell 88E1540] (ir=
q=3D68)
> Aug 25 23:03:54 sw-dsl kernel: [    6.468109] mv88e6085 f1072004.mdio-mii=
:04 lan4 (uninitialized): phy: setting supported 000,00000000,000022ef adve=
rtising 000,00000000,000022ef
> Aug 25 23:03:54 sw-dsl kernel: [    6.472162] mv88e6085 f1072004.mdio-mii=
:04: nonfatal error -95 setting MTU on port 2
> Aug 25 23:03:54 sw-dsl kernel: [    6.474247] mv88e6085 f1072004.mdio-mii=
:04 lan3 (uninitialized): PHY [mv88e6xxx-0:02] driver [Marvell 88E1540] (ir=
q=3D69)
> Aug 25 23:03:54 sw-dsl kernel: [    6.474261] mv88e6085 f1072004.mdio-mii=
:04 lan3 (uninitialized): phy: setting supported 000,00000000,000022ef adve=
rtising 000,00000000,000022ef
> Aug 25 23:03:54 sw-dsl kernel: [    6.481824] mv88e6085 f1072004.mdio-mii=
:04: nonfatal error -95 setting MTU on port 3
> Aug 25 23:03:54 sw-dsl kernel: [    6.486354] mv88e6085 f1072004.mdio-mii=
:04 lan2 (uninitialized): PHY [mv88e6xxx-0:03] driver [Marvell 88E1540] (ir=
q=3D70)
> Aug 25 23:03:54 sw-dsl kernel: [    6.486363] mv88e6085 f1072004.mdio-mii=
:04 lan2 (uninitialized): phy: setting supported 000,00000000,000022ef adve=
rtising 000,00000000,000022ef
> Aug 25 23:03:54 sw-dsl kernel: [    6.498494] mv88e6085 f1072004.mdio-mii=
:04: nonfatal error -95 setting MTU on port 4
> Aug 25 23:03:54 sw-dsl kernel: [    6.502272] mv88e6085 f1072004.mdio-mii=
:04 lan1 (uninitialized): PHY [mv88e6xxx-0:04] driver [Marvell 88E1540] (ir=
q=3D71)
> Aug 25 23:03:54 sw-dsl kernel: [    6.502279] mv88e6085 f1072004.mdio-mii=
:04 lan1 (uninitialized): phy: setting supported 000,00000000,000022ef adve=
rtising 000,00000000,000022ef
> Aug 25 23:03:54 sw-dsl kernel: [    6.532258] mv88e6085 f1072004.mdio-mii=
:04: nonfatal error -95 setting MTU on port 6
> Aug 25 23:03:54 sw-dsl kernel: [    6.535877] mvneta f1030000.ethernet en=
o1: Link is Down
> Aug 25 23:03:54 sw-dsl kernel: [    6.541733] mvneta f1030000.ethernet en=
o1: configuring for inband/1000base-x link mode
> Aug 25 23:03:54 sw-dsl kernel: [    6.541741] mvneta f1030000.ethernet en=
o1: config interface 1000base-x
> Aug 25 23:03:54 sw-dsl kernel: [    6.541754] mvneta f1030000.ethernet en=
o1: phylink_mac_config: mode=3Dinband/1000base-x/Unknown/Unknown adv=3D000,=
00000200,00002240 pause=3D04 link=3D0 an=3D1
> Aug 25 23:03:54 sw-dsl kernel: [    6.541771] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 25 23:03:54 sw-dsl kernel: [    6.541779] mvneta f1030000.ethernet en=
o1: mac link down
> Aug 25 23:03:54 sw-dsl kernel: [    6.541907] DSA: tree 0 setup
>=20
> Here, the kernel DSA switch driver has finished doing its setup
> before we even get to configuring the bridge device below.
>=20
> Aug 25 23:03:54 sw-dsl kernel: [    6.569105] mvneta f1030000.ethernet en=
o1: mac link up
> Aug 25 23:03:54 sw-dsl kernel: [    6.569113] mvneta f1030000.ethernet en=
o1: mac link up
> Aug 25 23:03:54 sw-dsl kernel: [    6.569139] mvneta f1030000.ethernet en=
o1: Link is Up - 1Gbps/Full - flow control rx/tx
> Aug 25 23:03:55 sw-dsl kernel: [    6.931763] brdsl: port 1(lan2) entered=
 blocking state
> Aug 25 23:03:55 sw-dsl kernel: [    6.931769] brdsl: port 1(lan2) entered=
 disabled state
> Aug 25 23:03:55 sw-dsl kernel: [    6.932863] device lan2 entered promisc=
uous mode
> Aug 25 23:03:55 sw-dsl kernel: [    7.032838] device eno1 entered promisc=
uous mode
> Aug 25 23:03:55 sw-dsl kernel: [    7.032902] mv88e6085 f1072004.mdio-mii=
:04 lan2: configuring for phy/gmii link mode
> Aug 25 23:03:55 sw-dsl kernel: [    7.032907] mv88e6085 f1072004.mdio-mii=
:04 lan2: config interface gmii
> Aug 25 23:03:55 sw-dsl kernel: [    7.032916] mv88e6085 f1072004.mdio-mii=
:04 lan2: phylink_mac_config: mode=3Dphy/gmii/Unknown/Unknown adv=3D000,000=
00000,00000000 pause=3D00 link=3D0 an=3D0
> Aug 25 23:03:55 sw-dsl kernel: [    7.032920] mv88e6085 f1072004.mdio-mii=
:04: p3: dsa_port_phylink_mac_config()
> Aug 25 23:03:55 sw-dsl kernel: [    7.037225] 8021q: adding VLAN 0 to HW =
filter
> on device lan2
> Aug 25 23:03:55 sw-dsl kernel: [    7.044979] brdsl: port 2(lan4) entered=
 blocking state
> Aug 25 23:03:55 sw-dsl kernel: [    7.044985] brdsl: port 2(lan4) entered=
 disabled state
> Aug 25 23:03:55 sw-dsl kernel: [    7.056189] device lan4 entered promisc=
uous mode
> Aug 25 23:03:55 sw-dsl kernel: [    7.107067] mv88e6085 f1072004.mdio-mii=
:04 lan4: configuring for phy/gmii link mode
> Aug 25 23:03:55 sw-dsl kernel: [    7.107073] mv88e6085 f1072004.mdio-mii=
:04 lan4: config interface gmii
> Aug 25 23:03:55 sw-dsl kernel: [    7.107080] mv88e6085 f1072004.mdio-mii=
:04 lan4: phylink_mac_config: mode=3Dphy/gmii/Unknown/Unknown adv=3D000,000=
00000,00000000 pause=3D00 link=3D0 an=3D0
> Aug 25 23:03:55 sw-dsl kernel: [    7.107084] mv88e6085 f1072004.mdio-mii=
:04: p1: dsa_port_phylink_mac_config()
> Aug 25 23:03:55 sw-dsl kernel: [    7.118831] 8021q: adding VLAN 0 to HW =
filter
> on device lan4
> Aug 25 23:03:55 sw-dsl kernel: [    7.153604] brdsl: port 3(eno2) entered=
 blocking state
> Aug 25 23:03:55 sw-dsl kernel: [    7.153610] brdsl: port 3(eno2) entered=
 disabled state
> Aug 25 23:03:55 sw-dsl kernel: [    7.153720] mv88e6085 f1072004.mdio-mii=
:04 lan2: phy link down gmii/Unknown/Unknown/off
> Aug 25 23:03:55 sw-dsl kernel: [    7.153790] device eno2 entered promisc=
uous mode
> Aug 25 23:03:55 sw-dsl kernel: [    7.153890] brdsl: port 3(eno2) entered=
 blocking state
> Aug 25 23:03:55 sw-dsl kernel: [    7.153895] brdsl: port 3(eno2) entered=
 forwarding state
> Aug 25 23:03:55 sw-dsl kernel: [    7.153930] IPv6: ADDRCONF(NETDEV_CHANG=
E): brdsl: link becomes ready
> Aug 25 23:03:55 sw-dsl kernel: [    7.295739] mv88e6085 f1072004.mdio-mii=
:04 lan4: phy link down gmii/Unknown/Unknown/off
> Aug 25 23:03:55 sw-dsl kernel: [    7.575615] mv88e6085 f1072004.mdio-mii=
:04 lan1: configuring for phy/gmii link mode
> Aug 25 23:03:55 sw-dsl kernel: [    7.575622] mv88e6085 f1072004.mdio-mii=
:04 lan1: config interface gmii
> Aug 25 23:03:55 sw-dsl kernel: [    7.575630] mv88e6085 f1072004.mdio-mii=
:04 lan1: phylink_mac_config: mode=3Dphy/gmii/Unknown/Unknown adv=3D000,000=
00000,00000000 pause=3D00 link=3D0 an=3D0
> Aug 25 23:03:55 sw-dsl kernel: [    7.575634] mv88e6085 f1072004.mdio-mii=
:04: p4: dsa_port_phylink_mac_config()
> Aug 25 23:03:55 sw-dsl kernel: [    7.579334] 8021q: adding VLAN 0 to HW =
filter
> on device lan1
> Aug 25 23:03:55 sw-dsl kernel: [    7.635966] mv88e6085 f1072004.mdio-mii=
:04 lan1: phy link down gmii/Unknown/Unknown/off
>=20
> --=20
> RMK's Patch system: https://eur01.safelinks.protection.outlook.com/?url=
=3Dhttps%3A%2F%2Fwww.armlinux.org.uk%2Fdeveloper%2Fpatches%2F&amp;data=3D04=
%7C01%7Cvladimir.oltean%40nxp.com%7C4226a7652ae7497284df08d96e2f29e4%7C686e=
a1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637661971114812881%7CUnknown%7CTWFpb=
GZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7=
C1000&amp;sdata=3D6hDf%2FS%2FMnpRhzEYuW14zuaEAcaTgdMsQJPpmR9WA5cI%3D&amp;re=
served=3D0
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!=
