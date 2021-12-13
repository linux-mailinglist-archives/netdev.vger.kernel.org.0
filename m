Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA19A4731A2
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbhLMQZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:25:10 -0500
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:61080
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231150AbhLMQZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 11:25:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQjwBZNsDV2pHbabBnoZ+0BSHf/tgmOznjCpXtex66HumSqXJMyBHgjICIhVW4FSo+rMj3MmHZClWff1WMvIYceNySCHEkIEIOXwewTNGWWZFbg9ZW/OhqdIBPe7AKA4VWyYzrc///z5U+7S+VwUv8QRdtubKqMktgCcvrwqYeXVPm/5DoNKYBj/js/GBR1syB1sEvwAtchHI/GyAtbZlMGeJiP1YGF2PqzrkM1kDRGoxXEogvoGBGnzcrqpcNlGORWowwmyfLjQCxSyjcmy92oyyLm9JOl7vQjwd2omEQaXqkm822pXDnMyJKbVoY19gfIDa4BoOQyVV9cQRMmnqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5J1gMTIipVMnVmmPKFusoeoELYVhtERMso/JMFx5QY=;
 b=EKKb1oq0Vl2NPXEQg9ZyQ9+HNngtJ06tZDYMlW8xuLwrmczJ1UYM7FtfTdTzG6kL0ID7FyDm1eeBWty8wZPnyDoe+m0WpFd+aH27vwG/Xaa5qJwaABxdHRMV+8tdCgYi82PxcgPcP/JMxeMtIbdh4lIuBBe6Wq36ixqleZQAPwiL/8fIEVzK5jedU1ChlgRNvK0mion3lCtbs29QLkLII8IwbHQfkX7htRshX54Yce4ArI18Z8KSva63qM/RfYkE99pTAQv5Y/fJwhfCkdwbvRhUpX+40KVvL9XNm2wrKNkPp3lUZV2+6nWMATApWZuzNKMlkvfQKZL6Eoh7G//PJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5J1gMTIipVMnVmmPKFusoeoELYVhtERMso/JMFx5QY=;
 b=gKjq9Dj+iOnVI6Ci14FvM0SaqgA3kFHxu3CTOJspIWIoIIHZSbJ/nSOrhM7+4MCAN5O/J/H9NvuJZXtkU6Frtepu6sw7GhUezzLgV7yKOWiV0tuFhkR2npteha1IJPPnF6zo+Pt631b/lTpYPHZY5m4uIIGtPy+gFvaItVoZEUE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3198.eurprd04.prod.outlook.com (2603:10a6:802:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Mon, 13 Dec
 2021 16:25:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Mon, 13 Dec 2021
 16:25:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Topic: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Index: AQHX7OGqma9W7JTLPke3A5iwt0gyh6wqKbcAgAA0OYCABd/MgIAAN0eAgAAMLwCAAACdgIAAEJAAgAAP1QA=
Date:   Mon, 13 Dec 2021 16:25:05 +0000
Message-ID: <20211213162504.gc62jvm6csmymtos@skbuf>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
 <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
 <20211213134319.dp6b3or24pl3p4en@skbuf>
 <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
 <20211213142907.7s74smjudcecpgik@skbuf>
 <20211213152824.22odaltycnotozkw@soft-dev3-1.localhost>
In-Reply-To: <20211213152824.22odaltycnotozkw@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2b74037c-6f63-4e91-190d-08d9be551f2a
x-ms-traffictypediagnostic: VI1PR04MB3198:EE_
x-microsoft-antispam-prvs: <VI1PR04MB3198C2B5BF731FA439746FF5E0749@VI1PR04MB3198.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ThJH6smXRPfvH0rsZip5NzSBMEuOSQwK3PqJ5skDhoK0N5VQ5Vg/EyMxdrQ+ZIRn0jkfZsi4AxGBq0tXQQqK+G4v7lFjyj8EFbnUkgx7owgHRBjrY6TiaMdk45t/PsY4yhC5j/+L8Wi2fW6k32IJ3E7LDYt+MUYNGJLAahmxsT9ArjCg3/Jll5AMG/hhjAjGneEIh97/ujd5JnsxK3SsOsRZ6vwvxLhRNobx297uyiXbwUbpUTodS/qjnBec/nrP8z5wp7ZlXGHbXeNBbli1seHFqD+/Nj1vIGXEGM8nifFexCsbl8WOr7RZomg/Jpqto8ZyiYPSjUJn1g5cSc3mK7uG9PbuvrfCdGSFCnEiFg6/0RcQEwiPyacapS6EwfRWVu0rDeVECGvwR9fPx4NL0VagRYfu71EjjOdVTG0o8/hiLvpHVpPJTYTSOtrTSsHI1SYBlAsjb5trz+yYMh6+n7Ujw2GmzzMwXBccguS2nr/lQVK1NR/L0brNC4FnBAafiK9xdY1Uu0b2pwqkw4eKJyu4400VoQSXEHwclzKzkDq8RGS7Z8Rpo1JX8Ab09fMZy9C3je+ljotr7D7YCHVXWYdjyjdovkOnZXaK/ZWf6SSpjU/OnP4DK4ULC/GRSLcksRqbRSwWfw+OowN84tW9RP9o5t20GBsvbYkwFNxIzCVsZkdyTASVPdaybkUbFXAlwe67RLt25FrBMOsN2yxKPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66446008)(91956017)(66946007)(66476007)(6486002)(64756008)(5660300002)(38100700002)(186003)(83380400001)(6512007)(33716001)(8936002)(2906002)(316002)(66556008)(54906003)(76116006)(1076003)(9686003)(38070700005)(122000001)(6916009)(86362001)(508600001)(6506007)(26005)(44832011)(71200400001)(4326008)(7416002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UD7FHFyGRRatEPm0LQrewGEVTi7iGB2S+n5oLbKo95/v1LnGq5ttDVZmU4kr?=
 =?us-ascii?Q?V5AiD0OMYmvh1eHC2RKjRde7FwuRBq4TqUIU3DbVtHfcIBhzvxWadbMxBkfP?=
 =?us-ascii?Q?TnOenk6Ban0ol7RDfFYJgc/rFO3dAzLFqrM+v0NpBCdNBkR/y/iCf3P2wkS6?=
 =?us-ascii?Q?nP2ObULyTyY3b2YAD/5JLZljIbP5DielhzDTdx3EPCAeQLdUzvJWTe5l6byr?=
 =?us-ascii?Q?7NZTRNgPnX6qYQY5vCFnDBt0VHnIiaRfCe3m3shbzHyHhIVX9n2HQBsNjO3N?=
 =?us-ascii?Q?U/2Afph3TWVVjRtjIOvz8y356L2L4i1+fcsKvnZ6sv9mtxNtPcAYGnhkDcOp?=
 =?us-ascii?Q?C59sOQnYFu0KSQbahkDsibCkDAlgRI9EbOGdm4HgliDX6uOR2FSW5smSh4yR?=
 =?us-ascii?Q?Ew3CVTfUfX2BFPAMIzpiuTU58b29rmKCV54j6EGjAWGwOH5obnknSs4JfDoZ?=
 =?us-ascii?Q?CvM2uXh8K3wmGbF8p74p3jk77LZdZkAaCb3kiEZ83VdTCNVNQ7LjN5G2CCo8?=
 =?us-ascii?Q?DTUzsa8i0KPdxXNeORv+kbCTpIl1nO3CStTGNwVFClRNRxDVwfzo1RZHGR2t?=
 =?us-ascii?Q?qS/2my4ZQISKZLZ9wvsvx5dqQUydBppbuhC9wOJS4+TGyXiQEsvCGRNtC2eT?=
 =?us-ascii?Q?ORar/9Zatr7N1x2YS0o5ztxxOQ6HxrvbGwxYI/IQWw81UuuqqEIz9pYABAgS?=
 =?us-ascii?Q?fsfgUI6iH+WLYgHtgNsrpj3anI/OKyAaYSwHk8P2LK0qi9POClaub7Y6Iq1t?=
 =?us-ascii?Q?gegHWSgLH0bE0phtIY9woFfFUuqIOdb9lKCmNsveF/v6jV+ro+DMLuovFAGW?=
 =?us-ascii?Q?g0gH9UA3MXwV8zpcxiSfC2qm9pkpckOetcfehi1FqeHG5nTlrh8XoaZwHWzM?=
 =?us-ascii?Q?gQdsAUd/KqetCOLqxhWY+m359RbgvMJJ1N8/oAdrvVAawNhIvjzUPv+H7e3j?=
 =?us-ascii?Q?d/dKFQNWXYfYE19C6DGrMYqMEYNfUlKJUeI1yCnCfQoAELMn3PEeGzeQt7jr?=
 =?us-ascii?Q?V17ecEKxVDNW4ap3wniZW2uw6mflVnibCLWpP5zbvgW7ZvvA9OLgDnE6VLYh?=
 =?us-ascii?Q?nqTha3JqWks/k5ogftY01uqfaVVq4TYToyUI0sDMat8Fc2A2uwMNz0BsQ+q1?=
 =?us-ascii?Q?Xq4hH+hfcMKwwiWCfPflqhN0rM/TzNmu2LQkA7fb1zdI2bQei7U7PMjjzJoC?=
 =?us-ascii?Q?pZMFjONzQ0euDfuae0AdKck+A100dr1V52aF04bNZF/3thvnYmTD54DBQpfh?=
 =?us-ascii?Q?d9eGnZMcuU1FMBkrln03eNRgs88JJBMknKfx+dno6f5oYqCZH11EFOViTmRK?=
 =?us-ascii?Q?SWBma1ZX8Q/+/irWiB4aaZo2VjAa6VyhI32mypIkO1yPEOK9VTnsEV4lH1SI?=
 =?us-ascii?Q?5kUNlwgc+PTFBSI74lFbaSrxJmw/JuqvDrLuF48OkArbztoJVJPIfu/RE54F?=
 =?us-ascii?Q?iY/YXT6vT7TLs6RRQrJNCsknIRZVfpEY+HQ0xHE7E2DV/qY5hlMwlqvYsBUe?=
 =?us-ascii?Q?ga6sKWONAUJ+rNn/ozqDX8nWWwhzN+x+P438IvgGM6yoIiqFIOodNxY8wmOv?=
 =?us-ascii?Q?eIWkTFcC2ruQ5Kw8BybBTXad/tCjYnMZpLB2bAhaZuI0kQy1GvEhqykZJJzv?=
 =?us-ascii?Q?FiQQNLGdVBmapKvKKmOSllg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <87332AF321ECF449B515F0037DA17BDE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b74037c-6f63-4e91-190d-08d9be551f2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 16:25:05.2579
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FmY+NbbgBDHZPF0TJ32CpMs2Rhc9L9w1HISQ/w83WsTPIQrajc+AuZGESF1m1uhtIrxdHaeJuOruOc2a9+iFLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3198
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 04:28:24PM +0100, Horatiu Vultur wrote:
> The 12/13/2021 14:29, Vladimir Oltean wrote:
> >=20
> > On Mon, Dec 13, 2021 at 03:26:56PM +0100, Horatiu Vultur wrote:
> > > > They are independent of each other. You deduce the interface on whi=
ch
> > > > the notifier was emitted using switchdev_notifier_info_to_dev() and=
 act
> > > > upon it, if lan966x_netdevice_check() is true. The notifier handlin=
g
> > > > code itself is stateless, all the state is per port / per switch.
> > > > If you register one notifier handler per switch, lan966x_netdevice_=
check()
> > > > would return true for each notifier handler instance, and you would
> > > > handle each event twice, would you not?
> > >
> > > That is correct, I will get the event twice which is a problem in the
> > > lan966x. The function lan966x_netdevice_check should be per instance,=
 in
> > > this way each instance can filter the events.
> > > The reason why I am putting the notifier_block inside lan966x is to b=
e
> > > able to get to the instance of lan966x even if I get a event that is =
not
> > > for lan966x port.
> >=20
> > That isn't a problem, every netdevice notifier still sees all events.
>=20
> Yes, that is correct.
> Sorry maybe I am still confused, but some things are still not right.
>=20
> So lets say there are two lan966x instances(A and B) and each one has 2
> ports(ethA0, ethA1, ethB0, ethB1).
> So with the current behaviour, if for example ethA0 is added in vlan
> 100, then we get two callbacks for each lan966x instance(A and B) because
> each of them registered. And because of lan966x_netdevice_check() is true
> for ethA0 will do twice the work.
> And you propose to have a singleton notifier so we get only 1 callback
> and will be fine for this case. But if you add for example the bridge in
> vlan 200 then I will never be able to get to the lan966x instance which
> is needed in this case.

I'm not sure what you mean by "you add the bridge in vlan 200" with
respect to netdevice notifiers. Create an 8021q upper with VID 200 on
top of a bridge (as that would generate a NETDEV_CHANGEUPPER)?
If there's a netdevice event on a bridge, the singleton netdevice event
handler can see if it is a bridge (netif_is_bridge_master), and if it
is, it can crawl through the bridge's lower interfaces using
netdev_for_each_lower_dev to see if there is any lan966x interface
beneath it. If there isn't, nothing to do. Otherwise, you get the
opportunity to do something for each port under that bridge. Maybe I'm
not understanding what you're trying to accomplish that's different?

> That is why if the lan966x_netdevice_check would be per instance, then
> we can filter like before, we still get call twice but then we filter for
> each instance. We get the lan966x instance from notifier_block and then
> we can check if the port netdev_ops is the same as the lan966x
> netdev_ops.
>=20
> And in the other case we will still be able to get to the lan966x instanc=
e
> in case the bridge is added in a vlan.
>=20
> > DSA intercepts a lot of events which aren't directly emitted for its ow=
n
> > interfaces. You don't gain much by having one more, if anything.
> >=20
> > > > notifier handlers should be registered as singletons, like other dr=
ivers
> > > > do.
> > >
> > > It looks like not all the other driver register them as singletone. F=
or
> > > example: prestera, mlx5, sparx5. (I just have done a git grep for
> > > register_switchdev_notifier, I have not looked in details at the
> > > implementation).
> >=20
> > Not all driver writers may have realized that it is an issue that needs
> > to be thought of.
>=20
> --=20
> /Horatiu=
