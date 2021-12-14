Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D60473933
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 01:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244495AbhLNACe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 19:02:34 -0500
Received: from mail-eopbgr40054.outbound.protection.outlook.com ([40.107.4.54]:46656
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244417AbhLNAB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 19:01:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ng1OyLFBkFAFpjyb6LDSoUtWIgyJjjGonsjdGm1sWkVcbKKCksHYQdBCXq0yBUW3S9JVI0zX9e3Lvpky0qmoe1FGjxblEE0jRFB5NUFtgo4/aeHXDF73X7sk0ACHasxuPzg3HbAalAjINYnMdO++5vNlps+q+iAnIX5rjJTbtu9JVOFs+0qo7nBDxVe9oSVIpK+xp2VXvl5jWSTt1FY+iTkLntghPrL2XpO4uNPOztvTc1nZj18V+zl2933oJ19A0PaqILQq/yOH2EBvOLezrYdQvfC5uLjgiXDmCOQpSl2z6q807xh7flJ9pkXN8SyrwoWM/Km9koeWgjSGpyvxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7qtqZnzJUvs+MCjYcWFI3aFdCT17w+Xz+oWCsTR4VI=;
 b=jfXkd/tyslu4Wyt9qwl8jB1N34M6vrEq0P8VYinyAw62sytgJMU4GO/6KsXKETd0MOyMSrYGcJnArkofsOOpKkYioCDzhhG4+Idwi9nvR+C68rP5XZXjAFkCqmzxmHR1AOZbVKP3msNx+K6wS7FChTe47Q2koU4Px1S8VRMwF+x8gWa7fBAJbM8OCvybOmKRomw2BlmRcywoTGcZ07EJNRFcZxqU08AspolmkyPXUO1+w6luGs7WAYHU+Kpuwhui61HoVb1RqcrhOZINNEV5AYphYmzR6jK4i1kXQ8YXsfdTXasURJmU5keW69X4LgrMclTtYI31qnTqakRxwbXfOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7qtqZnzJUvs+MCjYcWFI3aFdCT17w+Xz+oWCsTR4VI=;
 b=FmmlcE2MHv0qZtHbSG4wUpuWlQ7ouwT8RwSF9hiLw73gCmrntLZ1w5WppigveMLEHx5PBViLaApySvFQUMhl/oO555SaleDVzvnQ2e3aUGHUyD5WfjXO0gMjMYMCYLIJK4Z3w5WdLa08ZBrXL+iRq7IH40I0aGcLh0X8PpqjaSE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Tue, 14 Dec
 2021 00:01:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 00:01:53 +0000
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
Thread-Index: AQHX7OGqma9W7JTLPke3A5iwt0gyh6wqKbcAgAA0OYCABd/MgIAAN0eAgAAMLwCAAACdgIAAEJAAgAAP1QCAAFPBAIAAK9+A
Date:   Tue, 14 Dec 2021 00:01:52 +0000
Message-ID: <20211214000151.xiyserx62zq2wpzh@skbuf>
References: <20211209094615.329379-7-horatiu.vultur@microchip.com>
 <20211209133616.2kii2xfz5rioii4o@skbuf>
 <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
 <20211213134319.dp6b3or24pl3p4en@skbuf>
 <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
 <20211213142907.7s74smjudcecpgik@skbuf>
 <20211213152824.22odaltycnotozkw@soft-dev3-1.localhost>
 <20211213162504.gc62jvm6csmymtos@skbuf>
 <20211213212450.ldu5budcx7ybe3nb@soft-dev3-1.localhost>
In-Reply-To: <20211213212450.ldu5budcx7ybe3nb@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e792ead4-b6c0-4e94-96c0-08d9be94ef7c
x-ms-traffictypediagnostic: VE1PR04MB7343:EE_
x-microsoft-antispam-prvs: <VE1PR04MB73436163073CB1DB6F3AA4DDE0759@VE1PR04MB7343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CbBN8QCGxUcpBjDflsYxHzK969/D+HDcAqXAjSlNeOutUziCY72ASgK4d4RbGFXcK2zpR7ffPxvQHUC4Yh8CWdjFKYI0t7Gikp9T4qMca3ZGc6mukERENiQ4TZMIOl4Fn4EW+cdbQZlBjycw70CNCAasOr3m/6qhnDU27AM+++xCxGVwHsU97Q05ZN9o2q21+T/HsfbqV+O3nhEmya8lKLTcg9Ry8oGdtH4Wpd0rqZhTXFI/e1G/is+hKBfVqsLW33dqxI9CjldD94xYo9eO+8MIGtL74lR3Z+Owy0xsxvtsA5bKVaPJoAmLAttKsFwZ02hJMwNvQ4m6Y6mWbTWEcVFb4qBQB+DTlhItpA95N5dqqjgZtWYIPiCcXdauQbBupxpWLWevlkTBHf9uv6WRruM/r+fnc069BQO6eh8Z0CAkbxlAk/jizAFJgBbYGs5Pag4IEWKNDkGN5U13g/TdN0A4pLZiDiW/6vkCuxhIfYGFXYwTQtTT+xrsjuUWovZazl6ZJ9G4xI/RIo/yxkB+5rwCvUAPF6W3rNnCgwGBGrk9VM1ASSZvQ7D0OesPvUnX19k/FJAs6boCo4P5st46po6iz/g+qcEcHIGLWxwNnSgeCuDkkzere9IAuqRW9AxiKRm+HP+lIU8qgsoeCqxmvPMddG1Fr2H+wjrXwOBmmKL8cSh1ns7P2E3oOUrmaifL2sCvAYLzNjGncC3zFzo5s23u8E44uEUdeypXLw0LvMQgFCYaRQ1gq8fxdxa62DUkvg6AtEo0AhDBDeTg/NwBzLFSxLCgqkAL2HTVcgdhFBQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(6486002)(966005)(6512007)(9686003)(86362001)(1076003)(6916009)(8676002)(508600001)(7416002)(4326008)(83380400001)(5660300002)(8936002)(66946007)(66446008)(64756008)(38100700002)(122000001)(44832011)(76116006)(33716001)(66476007)(2906002)(6506007)(66556008)(26005)(91956017)(38070700005)(54906003)(316002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?//OaUVwVw7vljkflCk9CTGJ13iWr8DN/JnHjtzIsXyfCxoES/h5G28jeDGjm?=
 =?us-ascii?Q?ocdk1o3gWLQaP6G7Lutmapo8kQiFYUKwcNyYksbonuIsNXQfsXZaGEVuEr1D?=
 =?us-ascii?Q?I2yrU8yHiJ87hlB9KlSxClHqJPBakkJDmQaRzeFPUQZPKWW+xIxtiqieKTgd?=
 =?us-ascii?Q?rlLM1DtRZdX7eTbUfVKdHjxpm0pbt3GoDCtuGahc60oQzIcY9OfkG/s/MNi0?=
 =?us-ascii?Q?TINS1je7Qk9ftcJaIpcMVIK8TFFhFL6HqcaKn4GI10LuHbMViBzmJrNUct3F?=
 =?us-ascii?Q?DUe2djh0uqO0MabBb6+oTkgbWNVVVe4m7z3cdIBmTe6idsoDxpprljhwPdt8?=
 =?us-ascii?Q?xqstqreKBIiXmMVO19Kwg1g1cgZ76ERDiIR0fSn3/ofPeyTeoYGyMAjjaaaw?=
 =?us-ascii?Q?ZoQb7DJyTJ9d4HMTTwKOXWlff+LTwdBAiI6TFpND3wQ9UqGTzB4FAqegZJPS?=
 =?us-ascii?Q?+UVDe3NQjz8NYI6gmGulsUq0u9qhzROMwlINfx67jwZPKeR436YEGeVcoXtX?=
 =?us-ascii?Q?41C1ua4f6IG+sPmrhtX/5KIWqd/oGhF6t5EPi9sgiAhPLtYSu2D6S/QUwG0I?=
 =?us-ascii?Q?WAbNgv3T1d7qqdhnhF/MHR6ZF+XbzI5Dc6Ru9toRu6QgicA4vJgav++8A4t1?=
 =?us-ascii?Q?n4+ZLZ2pgkia/2JwElTC+fbf2TvqJJ5MbRtPVfwF8yn/Aa3H9dl2/T5c38Nj?=
 =?us-ascii?Q?5MLshBpHXnROSQN7HY2WysYJgabk4evZoCjGu/z2GIn0eFAJZgrhrcOikNPH?=
 =?us-ascii?Q?jtMeofLpjW+rIVG4BTPJRH73tCu8KIQUlwM+aJoIzIm+m4Bw3HON0A2jMfhr?=
 =?us-ascii?Q?jRNfbKnTH7YJkxi2FDIPMx+7zD4dbN8Qqbkvt016BFKIByJbI/wG4yZZ6jEU?=
 =?us-ascii?Q?YESLLKDXMesMEVXlUdIpktfPLM57MCoY+nmu4LIYCfXb1oUWAyyCwgaJ6HSM?=
 =?us-ascii?Q?BHNdr26Ezc1xzDE8Rp9OUpaHuXHKpD0Qf4TzcBRy+awhZbYm+eZU5izqoZSh?=
 =?us-ascii?Q?G3TS98I5oY5rneKDDQfJQOxJPw1JfC7RThgo+QLH9W76PCYF7f0Hb3Nc2emx?=
 =?us-ascii?Q?Bv0SA8wUPKPjs06yiGpATSeYVD5NQVG5AfW/oCAjBTARnlkUzCC2+n8Xf1QH?=
 =?us-ascii?Q?Z/FmRQf2xT10XMlUtv4fkD51uaFk37mRsJNrMuiAkLeDx+BxK9x8/C0MvLpa?=
 =?us-ascii?Q?2uj8lPoPuXodTLXokbUWBtA4v1+HJExYgEnFmHHa74RzhT/BlpKNigYwR5kX?=
 =?us-ascii?Q?qIlX5IVO9CMd2wGYYqWEaSoSwwEjyCS1LnxgfTDNTWshjRmjgzlezvX0Ngrj?=
 =?us-ascii?Q?JB/MD2HQud37x37s4QB937dd/BZL3jD8ju6mHdjaH13tdigdY4zV7vo4jKLX?=
 =?us-ascii?Q?SwMfOHBuZIt+p8DCVn8EdSlMh2mDDPRflciL1ACBLwPb3ZmC1RLXyJnrDvpM?=
 =?us-ascii?Q?LZT5jGqYyOtTipQ924D+c1t+Ow+9Ljr9Jr77eInVc+mAqlUZkVovOjsV1YpI?=
 =?us-ascii?Q?jPWdS2/lGaImXe/rsBadbdjcQNVG1ASeV5/pTm48OwR0Us1E99brz9nIrYeP?=
 =?us-ascii?Q?y2WNMPpsB7t7kJpO9nJQGXWEgjujmzozLKsANlgMmK4vDBPCROXFUtU/X3QJ?=
 =?us-ascii?Q?gOvfnfU1AohAAKJWKzkG9sE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F81CB22CF79BA4E89E8807B87019451@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e792ead4-b6c0-4e94-96c0-08d9be94ef7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 00:01:53.0430
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ky0gUHD7ypwDIxs3bgdw4PIZvq5n8IAockMmYbxqnh79UUzUJ7JUwc1sSN6e4kxMPh+/VTz6vttpLcd8VY7GyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 10:24:50PM +0100, Horatiu Vultur wrote:
> The 12/13/2021 16:25, Vladimir Oltean wrote:
> >
> > On Mon, Dec 13, 2021 at 04:28:24PM +0100, Horatiu Vultur wrote:
> > > The 12/13/2021 14:29, Vladimir Oltean wrote:
> > > >
> > > > On Mon, Dec 13, 2021 at 03:26:56PM +0100, Horatiu Vultur wrote:
> > > > > > They are independent of each other. You deduce the interface on=
 which
> > > > > > the notifier was emitted using switchdev_notifier_info_to_dev()=
 and act
> > > > > > upon it, if lan966x_netdevice_check() is true. The notifier han=
dling
> > > > > > code itself is stateless, all the state is per port / per switc=
h.
> > > > > > If you register one notifier handler per switch, lan966x_netdev=
ice_check()
> > > > > > would return true for each notifier handler instance, and you w=
ould
> > > > > > handle each event twice, would you not?
> > > > >
> > > > > That is correct, I will get the event twice which is a problem in=
 the
> > > > > lan966x. The function lan966x_netdevice_check should be per insta=
nce, in
> > > > > this way each instance can filter the events.
> > > > > The reason why I am putting the notifier_block inside lan966x is =
to be
> > > > > able to get to the instance of lan966x even if I get a event that=
 is not
> > > > > for lan966x port.
> > > >
> > > > That isn't a problem, every netdevice notifier still sees all event=
s.
> > >
> > > Yes, that is correct.
> > > Sorry maybe I am still confused, but some things are still not right.
> > >
> > > So lets say there are two lan966x instances(A and B) and each one has=
 2
> > > ports(ethA0, ethA1, ethB0, ethB1).
> > > So with the current behaviour, if for example ethA0 is added in vlan
> > > 100, then we get two callbacks for each lan966x instance(A and B) bec=
ause
> > > each of them registered. And because of lan966x_netdevice_check() is =
true
> > > for ethA0 will do twice the work.
> > > And you propose to have a singleton notifier so we get only 1 callbac=
k
> > > and will be fine for this case. But if you add for example the bridge=
 in
> > > vlan 200 then I will never be able to get to the lan966x instance whi=
ch
> > > is needed in this case.
> >
> > I'm not sure what you mean by "you add the bridge in vlan 200" with
> > respect to netdevice notifiers. Create an 8021q upper with VID 200 on
> > top of a bridge (as that would generate a NETDEV_CHANGEUPPER)?
>
> I meant the following:
>
> ip link add name brA type bridge
> ip link add name brB type bridge
> ip link set dev ethA0 master brA
> ip link set dev ethA1 master brA
> ip link set dev ethB0 master brB
> ip link set dev ethB1 master brB
> bridge vlan add dev brA vid 200 self

Ok, so the same as this use case and patch posted by Florian for DSA:
https://lkml.org/lkml/2018/6/24/300
we should be getting back to it some day.

> After the last command both lan966x instances will get a switchdev blocki=
ng
> event where event is SWITCHDEV_PORT_OBJ_ADD and obj->id is
> SWITCHDEV_OBJ_ID_PORT_VLAN. And in this case the
> switchdev_notifier_info_to_dev will return brA.

It returns brA anyway. But the point being, your current code submission
is something like this (of course, I had to fish these two functions
from two different patches, because they still aren't properly split):

static int lan966x_vlan_cpu_add_vlan_mask(struct lan966x *lan966x, u16 vid)
{
	lan966x->vlan_mask[vid] |=3D BIT(CPU_PORT);
	return lan966x_vlan_set_mask(lan966x, vid);
}

static int lan966x_handle_port_vlan_add(struct net_device *dev,
					struct notifier_block *nb,
					const struct switchdev_obj_port_vlan *v)
{
	struct lan966x_port *port;
	struct lan966x *lan966x;

	/* When adding a port to a vlan, we get a callback for the port but
	 * also for the bridge. When get the callback for the bridge just bail
	 * out. Then when the bridge is added to the vlan, then we get a
	 * callback here but in this case the flags has set:
	 * BRIDGE_VLAN_INFO_BRENTRY. In this case it means that the CPU
	 * port is added to the vlan, so the broadcast frames and unicast frames
	 * with dmac of the bridge should be foward to CPU.
	 */
	if (netif_is_bridge_master(dev) &&
	    !(v->flags & BRIDGE_VLAN_INFO_BRENTRY))
		return 0;

	lan966x =3D container_of(nb, struct lan966x, switchdev_blocking_nb);

	/* In case the port gets called */
	if (!(netif_is_bridge_master(dev))) {
		if (!lan966x_netdevice_check(dev))
			return -EOPNOTSUPP;

		port =3D netdev_priv(dev);
		return lan966x_vlan_port_add_vlan(port, v->vid,
						  v->flags & BRIDGE_VLAN_INFO_PVID,
						  v->flags & BRIDGE_VLAN_INFO_UNTAGGED);
	}

	/* In case the bridge gets called */
	if (netif_is_bridge_master(dev))
		return lan966x_vlan_cpu_add_vlan(lan966x, dev, v->vid);
		~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		In which way does this function call, exactly, check
		your lan966x's relationship to that bridge?

	return 0;
}

My point being, if you have two veth interfaces in your system just
minding their own business and being put in an unrelated bridge, and
that bridge would be put in VLAN 100 too, my understanding is that your
lan966x driver would sniff that event and add its CPU port to VLAN 100
too.  The reverse is true as well: any removal of a bridge from a VLAN
would also cause your CPU port to stop being in that VLAN, no matter
what interfaces may be in that VLAN. How could I say this... "spooky
action at a distance".

> > If there's a netdevice event on a bridge, the singleton netdevice event
> > handler can see if it is a bridge (netif_is_bridge_master), and if it
> > is, it can crawl through the bridge's lower interfaces using
> > netdev_for_each_lower_dev to see if there is any lan966x interface
> > beneath it. If there isn't, nothing to do. Otherwise, you get the
> > opportunity to do something for each port under that bridge.
>
> If I start to use switchdev_handle_port_obj_add, then as you mention
> will get a callback for each interface under the port and then I need to
> look in obj->orig_dev to see if it was a bridge or was a port that was
> part of the bridge.

Oh yes of course. And right now you don't need that because? You think
you get notifications only of switchdev events emitted by bridges that
you have a port in?

> If I don't use switchdev_handle_port_obj_add and implement own function
> then there is no way to get to the lan966x instance.

The switchdev_handle_port_obj_add() function isn't magic, and it has an
actual public implementation, too. Sure you can get to the lan966x
instance even if you don't use switchdev_handle_port_obj_add() -
although, it is there for people to use it.

> I will get two callbacks but then they can be filtered based on the
> bridge. If I use switchdev_handle_port_obj_add then if I have 2 ports
> under the bridge, both ports will be called which will do the same
> work anyway.

And that's a good thing, if you actually think about how you design
things to actually work. Please consider that you have two distinct
events: you can join a bridge that is in a VLAN, or the bridge can join
that VLAN while you have some ports under it. The invariant is that your
CPU port needs to be in that VLAN only for as long as there is any port
under that bridge. So it is actually beneficial to use the
switchdev_handle_* helper. It tells you how many users of the CPU VLAN
rule there still are. It would be broken to delete it right away, when a
port leaves the bridge. It would also be broken to not delete it after
all ports leave: the bridge may have a longer lifetime than the lan966x
ports beneath them, so there may not be any deletion event that you
should expect.

> So I am not sure how much I will benefit of using
> switchdev_handle_port_obj_add in this case.
>
> One important observation in the driver is that I am separating these 2
> cases:
>
> bridge vlan add dev brA vid 300 self
> bridge vlan add dev ethA0 vid 400

Understood, and that's ok. But I'm not convinced it works, though.

> > Maybe I'm not understanding what you're trying to accomplish that's dif=
ferent?
>
> The reason is that I want to use brA to control the CPU port. To decide
> which frames to be copy to the CPU. Also to copy as few as possible
> frames to CPU.
>
> If we still want to go with the approach of using a singleton notifier
> block, then we will still have a problem for netdevice notifier block.
> We will get the same issue, can't get to lan966x instance in case the
> lan966x callback is called for a different device. And we need this for
> the following case:
>
> If for example eth0, eth1 are part of a different IP and eth2, eth3 are
> part of lan966x. We would like not to be able to put under the same
> bridge interfaces that are part of different IPs (more precisely,
> lan966x interfaces can be only under a bridge where lan966x interfaces
> are part).
>
> For example the following command should fail:
> ip link add name br0 type bridge
> ip link set dev eth0 master br0
> ip link set dev eth2 master br0
>
> Also the this command should fail:
> ip link add name br0 type bridge
> ip link set dev eth2 master br0
> ip link set dev eth0 master br0
>
> But the following should be accepted:
> ip link add name br0 type bridge
> ip link set dev eth0 master br0
> ip link set dev eth1 master br0
> ip link add name br1 type bridge
> ip link set dev eth2 master br1
> ip link set dev eth3 master br1

You can track NETDEV_PRECHANGEUPPER and deny that, and also provide an
extack with a reason. That should work, it's been tested.

> Maybe I should also make it explictly that is not allow to have more
> than one instance of lan966x for now. And once is needed then add
> support for it.

I don't necessarily see the reason for this, but ok. I don't think you
should view things as "support for parallel instances of the driver is
what's complicating the implementation", but rather "catching the events
in all the permutations that they can happen in is what this driver
needs to provide a good user experience".=
