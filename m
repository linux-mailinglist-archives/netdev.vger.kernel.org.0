Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9A5AFB49
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfIKLVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:21:42 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:39024
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725616AbfIKLVm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 07:21:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BERtgqR7EtUVjYGo8GrqFzgHpTOQebdwqQnzVyE0on5/yN2rM8ZPxxipuq0lLrSy3poitL3+9869G/p7d070Is8J8jF4XfBtbgFxbEyFlcPJN1K4lg2gv71Va+c1eo6eN5oJcmIj+8T1lHNb5d/LdCE+o9CC6UBaT0kmqwtRvaDsns7FbRc4k+Sb9TIxlm4CnmElAZTWd4sMvjHYxHE7lqyXwlHgwDrxKAWo13VR0m7MP7AE2pzSWTuYkkuL1bl870ULy84PsG6rSWy3/gg4usHbyTX1Il70OeUB1Oy10LtgBGqikdoSnIq3ZxPIyL0+4lJlRsY9tCq3YPv0MP6T2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wp+R4m9tBD0+//3U5i5SioeI0LtiJ3wFs1ea3qxAc9I=;
 b=Unwv0EA/2TddXPPH6/89da+zG2qKN0Tp9SKoqXD46R3/lJGmwq9Ci2UF1aSm3rfVD38UxmeSHpB5PfZwNKOlztpXujN47MqyvciSyhbF1ysnjnZ8NGwENmDaPD40ezVIULVZCX6dJEVp6Iv8I8fi+ND8gnHozq0WFFvWI9mKu7pZP3SwgJCx7nr3ndEVLxJebzrn0s9CECGncfHDupPgOu3bntBP3u9/N7NmIbIeGs/HVvt0XMxEXni7sxvEASYrc3bHmLJPA2oHEFuudI0QBjTb7xeuUxeGBZc9YX24u5bZQR6LRmIcycsNr4ZhCY2DAodyP/FFJSv4EepzdTHJrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wp+R4m9tBD0+//3U5i5SioeI0LtiJ3wFs1ea3qxAc9I=;
 b=NHrbhLE9i3oPXpsIKRa6Mis5NH3r2ZyOw0iL6E9o07OXINyzXgGNeP1ti9lxLyVWv/GqR7+LD217PakungkpMh8hi9ho90UPScuJk8w4lr9vyXBUsiwRbbwkyP41MOL+DXbo9l+HQHiW3dfGsAKkbhDVCptRkO66On/nmDREHWc=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB4171.eurprd05.prod.outlook.com (52.134.107.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Wed, 11 Sep 2019 11:21:37 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b%5]) with mapi id 15.20.2241.018; Wed, 11 Sep 2019
 11:21:37 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Robert Beckett <bob.beckett@collabora.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Thread-Topic: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Thread-Index: AQHVZ/fFKpiR45rTHECGjkP5vPFNT6cmVjMA
Date:   Wed, 11 Sep 2019 11:21:37 +0000
Message-ID: <20190911112134.GA20574@splinter>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
In-Reply-To: <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::45) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0432e659-4cd6-4901-b6e2-08d736aa35a8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB4171;
x-ms-traffictypediagnostic: DB7PR05MB4171:
x-microsoft-antispam-prvs: <DB7PR05MB4171F94C42CD06DD228C06C9BFB10@DB7PR05MB4171.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(189003)(199004)(6486002)(8936002)(478600001)(386003)(26005)(6116002)(3846002)(486006)(186003)(11346002)(2906002)(33716001)(476003)(33656002)(53936002)(9686003)(54906003)(25786009)(305945005)(6512007)(6916009)(6436002)(64756008)(66476007)(66556008)(71190400001)(71200400001)(86362001)(1076003)(5660300002)(229853002)(256004)(316002)(53546011)(4326008)(66066001)(81166006)(81156014)(6246003)(446003)(14454004)(102836004)(99286004)(7736002)(14444005)(8676002)(52116002)(76176011)(6506007)(66446008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB4171;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j+OzVUm5ZzrHOMvkx0thHHgkIdduvx5At4+M7nHcen+LsDMDRXMum2awrSiu0I880/F4z2kvKbPKzhoK7i+xHBBi8HOonlDYCDYcIGrzCqbFuGLWJJ2HLFslOuhP08EigeHd82u1ze6aA+DoiG2RSd2NVvLjX3VfmWEyh23VvjPH3n4HxYyRoUYsJGJAc7FqLeiGrh95OTLrMeqA/lt+pyZO6+3GtObN8marXUs6owJwgbpORlik+J/DlRjLlzPWWCrJPj6KP86UbwNNry47NwJLToVkyTwqLoox18etoKi1e00m0FO4blQUXpTSPDT1Cc2N6VCHm5yT5/+GtCOIBK0a8ZJeUh4nnBduGawEynmxldP2cwcwjB3+JXCJqzSstUvNTZJNidjLRmmKkx4ZpP28ZqyEbpyPndQP9z+FadE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B52C17E898D367489F8DA2E8D373B79E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0432e659-4cd6-4901-b6e2-08d736aa35a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 11:21:37.0762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 91fGx5udvKbvfa5csQhTB+X1LzDBENp+qTTHH/zo7GAZtM+nG0/B7UDqjXl7N5ucF6obr2WnRa9HbkuYWjeGFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 09:49:46AM -0700, Florian Fainelli wrote:
> +Ido, Jiri,
>=20
> On 9/10/19 8:41 AM, Robert Beckett wrote:
> > This patch-set adds support for some features of the Marvell switch
> > chips that can be used to handle packet storms.
> >=20
> > The rationale for this was a setup that requires the ability to receive
> > traffic from one port, while a packet storm is occuring on another port
> > (via an external switch with a deliberate loop). This is needed to
> > ensure vital data delivery from a specific port, while mitigating any
> > loops or DoS that a user may introduce on another port (can't guarantee
> > sensible users).
>=20
> The use case is reasonable, but the implementation is not really. You
> are using Device Tree which is meant to describe hardware as a policy
> holder for setting up queue priorities and likewise for queue scheduling.
>=20
> The tool that should be used for that purpose is tc and possibly an
> appropriately offloaded queue scheduler in order to map the desired
> scheduling class to what the hardware supports.
>=20
> Jiri, Ido, how do you guys support this with mlxsw?

Hi Florian,

Are you referring to policing traffic towards the CPU using a policer on
the egress of the CPU port? At least that's what I understand from the
description of patch 6 below.

If so, mlxsw sets policers for different traffic types during its
initialization sequence. These policers are not exposed to the user nor
configurable. While the default settings are good for most users, we do
want to allow users to change these and expose current settings.

I agree that tc seems like the right choice, but the question is where
are we going to install the filters?

>=20
> >=20
> > [patch 1/7] configures auto negotiation for CPU ports connected with
> > phys to enable pause frame propogation.
> >=20
> > [patch 2/7] allows setting of port's default output queue priority for
> > any ingressing packets on that port.
> >=20
> > [patch 3/7] dt-bindings for patch 2.
> >=20
> > [patch 4/7] allows setting of a port's queue scheduling so that it can
> > prioritise egress of traffic routed from high priority ports.
> >=20
> > [patch 5/7] dt-bindings for patch 4.
> >=20
> > [patch 6/7] allows ports to rate limit their egress. This can be used t=
o
> > stop the host CPU from becoming swamped by packet delivery and exhastin=
g
> > descriptors.
> >=20
> > [patch 7/7] dt-bindings for patch 6.
> >=20
> >=20
> > Robert Beckett (7):
> >   net/dsa: configure autoneg for CPU port
> >   net: dsa: mv88e6xxx: add ability to set default queue priorities per
> >     port
> >   dt-bindings: mv88e6xxx: add ability to set default queue priorities
> >     per port
> >   net: dsa: mv88e6xxx: add ability to set queue scheduling
> >   dt-bindings: mv88e6xxx: add ability to set queue scheduling
> >   net: dsa: mv88e6xxx: add egress rate limiting
> >   dt-bindings: mv88e6xxx: add egress rate limiting
> >=20
> >  .../devicetree/bindings/net/dsa/marvell.txt   |  38 +++++
> >  drivers/net/dsa/mv88e6xxx/chip.c              | 122 ++++++++++++---
> >  drivers/net/dsa/mv88e6xxx/chip.h              |   5 +-
> >  drivers/net/dsa/mv88e6xxx/port.c              | 140 +++++++++++++++++-
> >  drivers/net/dsa/mv88e6xxx/port.h              |  24 ++-
> >  include/dt-bindings/net/dsa-mv88e6xxx.h       |  22 +++
> >  net/dsa/port.c                                |  10 ++
> >  7 files changed, 327 insertions(+), 34 deletions(-)
> >  create mode 100644 include/dt-bindings/net/dsa-mv88e6xxx.h
> >=20
>=20
>=20
> --=20
> Florian
