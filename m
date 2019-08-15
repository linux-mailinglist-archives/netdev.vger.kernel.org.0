Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074D58EBAC
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731629AbfHOMj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:39:58 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:41934
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfHOMj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 08:39:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCYqB8XbZK7QZ6QtVotWmmwjZ2V1CnU4lawthnVoOxlppf3rJ/mbEr+c1sN7vK6Negv1w6/RXZCLld7vssXA44ifirwWt74pahvEyjMvGX59Mz9yakFxbyqiKQuw9NMaki6n614EcZVfnI+BriKxzT+QFGz3fo19UjfPXSFw85RDKB48//CpP3AcZCMHiuuD9FvDebpLKcI+6UMzCCTNK3aZE9bpK/+LshVRWq/WECazObE8vceg8T23cXQ3v+SxyREJnuEBaXgwa91przrckmhP+JlgP3n5phtT5ebQvM7NDeDKW4NqIMdG3tBNp3hpVnWp6zhHjgSTIV5X4aAUxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNylu2hbYr9zA831mPq+upmyJJhmX+/mxjmt1u+rWMs=;
 b=cjvlWNFS4M5spDbx5XydjNPRg7ll4PcrfNhSqzCMMH4fu2yp5bUfFgVROBAmoR1GvUcy3hb54XpC0HmifOCytHovO4fs3qw9Zhb5TxbHGE2nCC+GiAsujj7UlBu/VWxKknNOwm6AxIHMTNZ2sKLJ5f6dr/mRlej0XvYUofZHsVcPo2WprBLLkzCfnY2183QiWtNLSgoF+B932G0r68rvyojWOcFpiS82zjntTfcQ1JYaboFDTL0RMLqg9EN2cBTeOPDaDsc83QZax1fyRSnyR/4fqUhik8X/XnoILxKB6+wgRWGxq/rezRfGT9B5juPg128vcTNF/LcOqamNdfdDsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BNylu2hbYr9zA831mPq+upmyJJhmX+/mxjmt1u+rWMs=;
 b=K/R8clVDK6BTLdzPxKrAyA56gsFieAgZRtMMf567MTGzMwIvphRR6yuf9bWq8SYGLUaux58J17pFRuXtWxcNiCN08kjlibPUFa3Ty+dwCdYmei8paufA9iwwDGFvFlTVR0sQhQUL3cvkiObN1PGzPjYNEzo3hEn2qCCs1+9Z7AI=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2653.eurprd04.prod.outlook.com (10.168.65.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 12:39:52 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2178.016; Thu, 15 Aug
 2019 12:39:52 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH 3/3] ocelot_ace: fix action of trap
Thread-Topic: [PATCH 3/3] ocelot_ace: fix action of trap
Thread-Index: AQHVUPsbgCvvMJE2AE2KMlSf5gLebab3cdsAgADjDBCAAMMRAIAA8IOQgABSFACAAFJ+gIABdYtw
Date:   Thu, 15 Aug 2019 12:39:52 +0000
Message-ID: <VI1PR0401MB223719E0527C26387306D23BF8AC0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190813134236.GG15047@lunn.ch>
 <VI1PR0401MB2237D9358AA17400E72A776EF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190814085711.7654bff2u66o4yjj@lx-anielsen.microsemi.net>
 <20190814135227.GC5265@lunn.ch>
In-Reply-To: <20190814135227.GC5265@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47557184-313e-40d5-9004-08d7217dab4d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2653;
x-ms-traffictypediagnostic: VI1PR0401MB2653:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0401MB26536D2B831947BBCD921BFAF8AC0@VI1PR0401MB2653.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(136003)(39850400004)(346002)(51874003)(189003)(199004)(13464003)(53754006)(54906003)(33656002)(66946007)(9686003)(478600001)(486006)(53936002)(71200400001)(966005)(186003)(7736002)(74316002)(64756008)(71190400001)(53546011)(66446008)(76116006)(66066001)(229853002)(66476007)(102836004)(86362001)(52536014)(6506007)(6436002)(66556008)(6306002)(55016002)(305945005)(446003)(14454004)(476003)(4326008)(26005)(76176011)(2906002)(6116002)(256004)(6246003)(25786009)(99286004)(81156014)(81166006)(8936002)(7696005)(5660300002)(11346002)(8676002)(3846002)(110136005)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2653;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Aw/2bDEVh5XDrbOIH5V//ACcFU4/v7pB2a7CrK20au5OD6vBAQMM6IFFoDKYVCP89vvBYkW5HwlOn/k0622BMgzgMh6WQ2uTNah0TCC6Sfk39gADfutDsX+USqTLWrvCt6Xu3uU5n293vVkkbUaDLndYc3st4MDH9ZB/Wa3C19cQQL1K1b0nwOBHd+eQ5WXjZwdwzmr37Yo2NKQQWd6OzYrhtxLOXjw8k/LdsHphBaZe2sh153M5Md5x3WAtvJpzZvCHRxdG/QEiXYh5V/iUMHQuaWzjA/eEAqv4Fjuxw45sQdSNwqCfb+qBOKQlDoapWDG4Oiae0OIa+wq+GDMhweRmOTEMdaFUmJyNfxkjqSUyVpBhy5E8dkx++1KGv96EIrn2fKa7t30fUt5acl3L0PhiBJOlwtppI2h6ZtWyfz4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47557184-313e-40d5-9004-08d7217dab4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 12:39:52.4350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xm3QsZgsyA+gQXEveU9ixrlZGiaZu8uyUMBW2oZH3jTf4mvn/UNJbViTrIZfZ4vHzNbRmDuK5x+mjniYApU0hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2653
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Allan,

I add Richard in email for help and some suggestions.
And please see my comments inline.
Thanks.

Hi Richard,

We are discussing problem of PTP message trapping to CPU on switch. Hope fo=
r your suggestions since you are the expert.
Here are the two versions patch-set.
V2: https://patchwork.ozlabs.org/project/netdev/list/?series=3D124713&state=
=3D*
V1: https://patchwork.ozlabs.org/project/netdev/list/?series=3D124563&state=
=3D*

Thanks in advance :)

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, August 14, 2019 9:52 PM
> To: Allan W. Nielsen <allan.nielsen@microchip.com>
> Cc: Y.b. Lu <yangbo.lu@nxp.com>; netdev@vger.kernel.org; David S . Miller
> <davem@davemloft.net>; Alexandre Belloni <alexandre.belloni@bootlin.com>;
> Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
>=20
> On Wed, Aug 14, 2019 at 10:57:12AM +0200, Allan W. Nielsen wrote:
> > Hi Y.b. and Andrew,
> >
> > The 08/14/2019 04:28, Y.b. Lu wrote:
> > > > > I'd like to trap all IEEE 1588 PTP Ethernet frames to CPU
> > > > > through etype
> > > > 0x88f7.
> > > >
> > > > Is this the correct way to handle PTP for this switch? For other
> > > > switches we don't need such traps. The switch itself identifies
> > > > PTP frames and forwards them to the CPU so it can process them.
> > > >
> > > > I'm just wondering if your general approach is wrong?
> > >
> > > [Y.b. Lu] PTP messages over Ethernet will use two multicast addresses=
.
> > > 01-80-C2-00-00-0E for peer delay messages.
> > Yes, and as you write, this is a BPDU which must not be forwarded (and
> > they are not).
> >
> > > 01-1B-19-00-00-00 for other messages.
> > Yes, this is a normal L2 multicast address, which by default are broadc=
astet.
> >
> > > But only 01-80-C2-00-00-0E could be handled by hardware filter for
> > > BPDU frames (01-80-C2-00-00-0x).  For PTP messages handling,
> > > trapping them to CPU through VCAP IS2 is the suggested way by
> Ocelot/Felix.
>=20
> Hi Allan
>=20
> The typical userspace for this is linuxptp. It implements Boundary Clock =
(BC),
> Ordinary Clock (OC) and Transparent Clock (TC). On switches, it works gre=
at for
> L2 PTP. But it has architectural issues for L3 PTP when used with a bridg=
e. I've
> no idea if Richard is fixing this.

[Y.b. Lu] Right.
For the 3 scenarios Allan listed, actually I think usually the first and th=
e second wouldn't be used if user needs 1588 synchronization.
#1 scenario, since it's PTP unaware, asymmetric delay will be introduced an=
d it couldn't ensure sync performance.
#2 scenario, this has too much limitation. The switch hardware could only b=
e configured as two-step end-to-end transparent clock in hardware.
For other clock types, it requires CPU handling and ptp software. In additi=
on, ptp software takes very few resources.

So the desired scenario for 1588 synchronization should be #3 scenario.

>=20
> > 3) It can be done via 'tc' using the trap action, but I do not know if =
this is
> >    the desired way of doing it.
>=20
> No, it is not. It could be the way you the implement
> ptp_clock_info.enable() does the same as what TC could do, but TC itself =
is not
> used, it should all be internal to the driver. And you might also want to
> consider hiding such rules from TC, otherwise the user might remove them =
and
> things break.

[Y.b. Lu] ptp_clock_info.enable() ?
As I understand, PTP clock driver is only for ptp clock operations, not for=
 networking.

I would have intended to send PTP trapping rule patch for discussion after =
Felix driver is ready on upstream.
Let me just send TRAP option fix-up patch in next version. Will rework and =
send PTP trapping rule patch once Felix driver is accepted by upstream.
But I'd like to gather suggestions on that.

Thanks a lot.

>=20
>      Andrew
