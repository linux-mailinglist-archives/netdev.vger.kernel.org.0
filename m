Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301F5B0AD5
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 11:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbfILJDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 05:03:47 -0400
Received: from mail-eopbgr140070.outbound.protection.outlook.com ([40.107.14.70]:63798
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730175AbfILJDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 05:03:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAQjl73BJtLybtqXYbddtQeFOtGcJKcZp7boJp6UekrPlxR4ud+RyWtUx98sWDisEcNOb0lDhuhfikYygiITn3lWhY1JSWzB+Sq3PJ5DfCURbYKyW5ci6M5C+AszaCBFhIf2Xx8jT4MQB4ZQXDanz8ZmLKN+HSJNvk5/4/X279+onWR4ozgo9i8qOW0GqB597VbP1fCIhYb2HuF8fxbSsxwr5dWXTESLXfAs7X1nGwho/mqbALobpFs3gznHVQjadwW/selHiiNxUhOSL8JlvO/V9+5Mca+EsKA3oRfRoIRNtOeUznqEeug91TnxF6oLTTL2YUIgYMeL11Q5Fq5slw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkV4Ic5xHWAk5r6+2k6x5+dkON2TiAI9xZKC7uYt+J4=;
 b=c34+PN87Ng4bxaBy9MkS/eTQnL5HaKobN0CZTRbddZPzbTWfZjMgZwr8813yT3MYJUyYa3GyZ98SW30DqDUduxR4MRzo4D9x6R13K0KEV4H7NsPHUUbS7eXxSEfsFD4UaxWeVxU/0u5xuw5tMGfxMmIscEvNKJeGuDhKfICdFr+wvfQaf2qNyOeRJCNAaRbRJ3jSRoSgQ9ecjKMFWdYmc4I2/B4nmq0pMsLPNGu7URIZexoTY5ry/SPMhtLQy95/YGokb5Le2HznNR9H2BGcVXibqjUt3/CErZHNorNndLp63w4nuJy8bkrG4ZklgGqTvlKB7VooKss+bchyazHKhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkV4Ic5xHWAk5r6+2k6x5+dkON2TiAI9xZKC7uYt+J4=;
 b=Shk60kXXCXhQi0T9Vf5FtRKloKVyXqW5XTs3zcd3G3E0QycrYU3E2ekHGlqFUJd8Nn6cdomsgnTfynzP316FlwMHR3+l+72/QRQAq4eeC6LBr0ZtqGdjsnIDEEKyqA7NmProxeIWD2LAsugKX25Nfhh9XjkCcaNXipAAAIQLcmg=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB5737.eurprd05.prod.outlook.com (20.178.105.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Thu, 12 Sep 2019 09:03:42 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b%5]) with mapi id 15.20.2241.022; Thu, 12 Sep 2019
 09:03:42 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Robert Beckett <bob.beckett@collabora.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Thread-Topic: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Thread-Index: AQHVZ/fFKpiR45rTHECGjkP5vPFNT6cmVjMAgAAHroCAAWQegA==
Date:   Thu, 12 Sep 2019 09:03:42 +0000
Message-ID: <20190912090339.GA16311@splinter>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
 <20190911112134.GA20574@splinter>
 <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
In-Reply-To: <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0001.eurprd05.prod.outlook.com
 (2603:10a6:208:55::14) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2db965bc-76b5-4fda-f294-08d737601bfd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB5737;
x-ms-traffictypediagnostic: DB7PR05MB5737:
x-microsoft-antispam-prvs: <DB7PR05MB573730944B2694533C91041BBFB00@DB7PR05MB5737.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(376002)(396003)(39860400002)(346002)(136003)(366004)(199004)(189003)(256004)(14444005)(6116002)(446003)(7736002)(76176011)(305945005)(316002)(3846002)(33656002)(229853002)(2906002)(33716001)(66446008)(86362001)(64756008)(486006)(53546011)(71200400001)(71190400001)(386003)(66946007)(66556008)(66476007)(6506007)(476003)(102836004)(14454004)(1076003)(6512007)(478600001)(9686003)(8676002)(6436002)(186003)(81156014)(5660300002)(81166006)(54906003)(26005)(8936002)(6246003)(99286004)(11346002)(6916009)(4326008)(6486002)(53936002)(52116002)(66066001)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5737;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: td4K/x+pEJXTKKCsRbDbXx9B+WrIrpxU2UBCXwQu9T1TLXZPtRLYxyQZF4pNwcJ0nYtjYjjClcNXQE21kLTcTcNu51R/on1TIqYBL53pBtV1ziNWTQb/wqgcaWmRqDy4EgZ5go8K8qeDObLmiR/8X42UVmQiXGRsqSG3QF2rvLWAwwSQWHNDCw+GpIJwMoqbiw6eh9T32ZNC/zGsWddR446+6BIgkFVSF5PtF/93xLdvQTlmxaFWDLEPVQditLPNbZs30y1SgewU1VixpbMGfGMZjYTn8GJRdgIzNlWHHxteqqsE9XnGZVlei0gmutUR/GbXLCeBxTA9Ovo+EP7+vTtePWvrwo/iL1Usiy12Hw0v8TBdxnzwsgvgV6NhFeyREUIO38bieVK4cdzE9F3Ly1ARMA+qX1cpA+MpZuPPFQw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17300D52DAE84D4CA4B0B79161230A81@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db965bc-76b5-4fda-f294-08d737601bfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 09:03:42.4209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5bVQPDj1HOdnJbnjoh6p8pLucjMLfPiLgrWXnbuo+tMI/3mmnsQJ44lTq78GUtcBBbvqt/ClUvnzE/QXYNatBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5737
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 12:49:03PM +0100, Robert Beckett wrote:
> On Wed, 2019-09-11 at 11:21 +0000, Ido Schimmel wrote:
> > On Tue, Sep 10, 2019 at 09:49:46AM -0700, Florian Fainelli wrote:
> > > +Ido, Jiri,
> > >=20
> > > On 9/10/19 8:41 AM, Robert Beckett wrote:
> > > > This patch-set adds support for some features of the Marvell
> > > > switch
> > > > chips that can be used to handle packet storms.
> > > >=20
> > > > The rationale for this was a setup that requires the ability to
> > > > receive
> > > > traffic from one port, while a packet storm is occuring on
> > > > another port
> > > > (via an external switch with a deliberate loop). This is needed
> > > > to
> > > > ensure vital data delivery from a specific port, while mitigating
> > > > any
> > > > loops or DoS that a user may introduce on another port (can't
> > > > guarantee
> > > > sensible users).
> > >=20
> > > The use case is reasonable, but the implementation is not really.
> > > You
> > > are using Device Tree which is meant to describe hardware as a
> > > policy
> > > holder for setting up queue priorities and likewise for queue
> > > scheduling.
> > >=20
> > > The tool that should be used for that purpose is tc and possibly an
> > > appropriately offloaded queue scheduler in order to map the desired
> > > scheduling class to what the hardware supports.
> > >=20
> > > Jiri, Ido, how do you guys support this with mlxsw?
> >=20
> > Hi Florian,
> >=20
> > Are you referring to policing traffic towards the CPU using a policer
> > on
> > the egress of the CPU port? At least that's what I understand from
> > the
> > description of patch 6 below.
> >=20
> > If so, mlxsw sets policers for different traffic types during its
> > initialization sequence. These policers are not exposed to the user
> > nor
> > configurable. While the default settings are good for most users, we
> > do
> > want to allow users to change these and expose current settings.
> >=20
> > I agree that tc seems like the right choice, but the question is
> > where
> > are we going to install the filters?
> >=20
>=20
> Before I go too far down the rabbit hole of tc traffic shaping, maybe
> it would be good to explain in more detail the problem I am trying to
> solve.
>=20
> We have a setup as follows:
>=20
> Marvell 88E6240 switch chip, accepting traffic from 4 ports. Port 1
> (P1) is critical priority, no dropped packets allowed, all others can
> be best effort.
>=20
> CPU port of swtich chip is connected via phy to phy of intel i210 (igb
> driver).
>=20
> i210 is connected via pcie switch to imx6.
>=20
> When too many small packets attempt to be delivered to CPU port (e.g.
> during broadcast flood) we saw dropped packets.
>=20
> The packets were being received by i210 in to rx descriptor buffer
> fine, but the CPU could not keep up with the load. We saw
> rx_fifo_errors increasing rapidly and ksoftirqd at ~100% CPU.
>=20
>=20
> With this in mind, I am wondering whether any amount of tc traffic
> shaping would help? Would tc shaping require that the packet reception
> manages to keep up before it can enact its policies? Does the
> infrastructure have accelerator offload hooks to be able to apply it
> via HW? I dont see how it would be able to inspect the packets to apply
> filtering if they were dropped due to rx descriptor exhaustion. (please
> bear with me with the basic questions, I am not familiar with this part
> of the stack).
>=20
> Assuming that tc is still the way to go, after a brief look in to the
> man pages and the documentation at largc.org, it seems like it would
> need to use the ingress qdisc, with some sort of system to segregate
> and priortise based on ingress port. Is this possible?

Hi Robert,

As I see it, you have two problems here:

1. Classification: Based on ingress port in your case

2. Scheduling: How to schedule between the different transmission queues

Where the port from which the packets should egress is the CPU port,
before they cross the PCI towards the imx6.

Both of these issues can be solved by tc. The main problem is that today
we do not have a netdev to represent the CPU port and therefore can't
use existing infra like tc. I believe we need to create one. Besides
scheduling, we can also use it to permit/deny certain traffic from
reaching the CPU and perform policing.

Drivers can run the received packets via taps using
dev_queue_xmit_nit(), so that users will see all the traffic directed at
the host when running tcpdump on this netdev.

>=20
>=20
>=20
> > >=20
> > > >=20
> > > > [patch 1/7] configures auto negotiation for CPU ports connected
> > > > with
> > > > phys to enable pause frame propogation.
> > > >=20
> > > > [patch 2/7] allows setting of port's default output queue
> > > > priority for
> > > > any ingressing packets on that port.
> > > >=20
> > > > [patch 3/7] dt-bindings for patch 2.
> > > >=20
> > > > [patch 4/7] allows setting of a port's queue scheduling so that
> > > > it can
> > > > prioritise egress of traffic routed from high priority ports.
> > > >=20
> > > > [patch 5/7] dt-bindings for patch 4.
> > > >=20
> > > > [patch 6/7] allows ports to rate limit their egress. This can be
> > > > used to
> > > > stop the host CPU from becoming swamped by packet delivery and
> > > > exhasting
> > > > descriptors.
> > > >=20
> > > > [patch 7/7] dt-bindings for patch 6.
> > > >=20
> > > >=20
> > > > Robert Beckett (7):
> > > >   net/dsa: configure autoneg for CPU port
> > > >   net: dsa: mv88e6xxx: add ability to set default queue
> > > > priorities per
> > > >     port
> > > >   dt-bindings: mv88e6xxx: add ability to set default queue
> > > > priorities
> > > >     per port
> > > >   net: dsa: mv88e6xxx: add ability to set queue scheduling
> > > >   dt-bindings: mv88e6xxx: add ability to set queue scheduling
> > > >   net: dsa: mv88e6xxx: add egress rate limiting
> > > >   dt-bindings: mv88e6xxx: add egress rate limiting
> > > >=20
> > > >  .../devicetree/bindings/net/dsa/marvell.txt   |  38 +++++
> > > >  drivers/net/dsa/mv88e6xxx/chip.c              | 122
> > > > ++++++++++++---
> > > >  drivers/net/dsa/mv88e6xxx/chip.h              |   5 +-
> > > >  drivers/net/dsa/mv88e6xxx/port.c              | 140
> > > > +++++++++++++++++-
> > > >  drivers/net/dsa/mv88e6xxx/port.h              |  24 ++-
> > > >  include/dt-bindings/net/dsa-mv88e6xxx.h       |  22 +++
> > > >  net/dsa/port.c                                |  10 ++
> > > >  7 files changed, 327 insertions(+), 34 deletions(-)
> > > >  create mode 100644 include/dt-bindings/net/dsa-mv88e6xxx.h
> > > >=20
> > >=20
> > >=20
> > > --=20
> > > Florian
>=20
