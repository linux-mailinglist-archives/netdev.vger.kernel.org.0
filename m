Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68FE2D8DA9
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 14:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394881AbgLMN4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 08:56:49 -0500
Received: from mail-eopbgr10074.outbound.protection.outlook.com ([40.107.1.74]:44796
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389894AbgLMN4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 08:56:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WknyJPicExn0olkMDMw/+ecirJ/5RWHK3MLGLbsOeq47L+kkNeyvbkZmAC4HLubKQOmxG9lR40SwjXGgAGgP/0C+gTqBKJuQHCdwFn+P2ZHUeB9LNJktncmoXOz2zfCxBWoSJl9K/goaKQK9vSm1JnpiynSpnQoQb5VCReCsVPR6Xf32bC63RXJthR/W9SevTm7O029wPq9Jf/upjZ5UoXFakKeHdLbN2rNChnZqVq1JdnNgYB7Ta85AIejoCGCeHz/ut0s6x4m0Sd/sbRq7ARXAKhcifBONzds4CKzqxWpDtlI9PCtu1BnsCzFasI1UaHfOa/szBTUisaHjwvCtbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nDUBbtdHt7Z9suYjI/Po8cN8ood0qhS4xL1CgqJIkQ=;
 b=UvjCXYydXMAh+e5AeN4mQGMkwfULfktkGdbVXl1l9fMzWsxXD+crdJzbvpkdHzRGSndxsPlDLZJaHT8pHw66kEIHkiHCDMjBCObtSXc/Kdji07ujj0ymWw1ZsljW9M2+6T5LvDfLEmCOyEi/uneMyQFGa13jVB14CMtzDlYfDufHSL1U3HefCg5bWCvzKUe93zMVrfO0LazF1jrIddxyT4nOKLeyRKsUxQojuycbbX4Yw3sk26L6kjx4hGRKZrAsxhxWMBWr2PzQWiAx5HeaHPR8iccJwo3JFCrD/z0zUkq7qAawjcqyMkO5UZjl9ZXQdORNrsqLGPiDjuwh7ZRADg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2nDUBbtdHt7Z9suYjI/Po8cN8ood0qhS4xL1CgqJIkQ=;
 b=kL5TDeMjLnbGGXyGdPa5mzX7Sqi3cUgN3Gk3daPQLS1v/IikWWkqjXhOmd8QyLEyS90zMmNlmM1RH/FfmQl0T6/AsVgdjlAMMWgNQ1ZzoPmTMacSld7PBNatc81+Hw4B1BGEoP1ilMPEdO4t8UW6lup7I4VX+SGqlq01n5zo3+I=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 13:55:58 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 13:55:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v2 net-next 1/6] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
Thread-Topic: [PATCH v2 net-next 1/6] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
Thread-Index: AQHW0PlmzHTq9ao+zkuxYGhmmae9UKn1BAAAgAAJaYA=
Date:   Sun, 13 Dec 2020 13:55:58 +0000
Message-ID: <20201213135557.ysmx3qjnafl5yihm@skbuf>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
 <20201213024018.772586-2-vladimir.oltean@nxp.com>
 <85b824ea-5f43-b483-55b6-4ffd0e8275d8@nvidia.com>
In-Reply-To: <85b824ea-5f43-b483-55b6-4ffd0e8275d8@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8194be6a-dc39-44bf-76df-08d89f6ed18e
x-ms-traffictypediagnostic: VI1PR04MB3968:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB39687321E0E4EA4B9A952713E0C80@VI1PR04MB3968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gL2fx3Lsoo/ZzJWEB7SjjBagDPAr47SCLWstxrpJPVFZbNCuB+RS52FHcKp1UZAlCHkQWZ9uPodwQzWYkA2rGK81O1zIINdVEYJ5Nw4Nzm5D9dUi+Xmagg5DTlR+M3Ayjv6SDIEuwB25KzY9eSs5PnUsH+i7nogRGb49YtGsTNW25D1ILCvNZmPtf4f3aWssXOFkv/VCg3eLVujzj0KRfPM1q5SpGpcgCESC3s/jUEQVxD//JXf5GhFW9BaOpM0Q4he9VTA38lxhpxa/DhS60Y0/5Yg3rFuIGmMZ0+Gj8+g0Soell7ut5N+i8TYGlOLJcAy2eQcSH9Ennl2+NmBoIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(376002)(136003)(366004)(39850400004)(346002)(83380400001)(6506007)(86362001)(54906003)(1076003)(2906002)(26005)(6486002)(478600001)(5660300002)(44832011)(33716001)(4326008)(316002)(7416002)(186003)(66476007)(66446008)(66556008)(64756008)(76116006)(6512007)(9686003)(8936002)(66946007)(71200400001)(8676002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?7rn/bNUHQnS7dubJiYNCkMy1fv7ppG2qZG5VtN+XDaks5QTXN8mAsJAYP7lX?=
 =?us-ascii?Q?YSaV3C2WZLBxAKV6inPUPYkAPhui2iTc3Uv1UIC4UgGBuG7bwBYKEgTtoRQA?=
 =?us-ascii?Q?b2mZNpQ+Ria/Ruswg8nxlhZeFzdM7B5PS/8whzPu7DqjueWLh3ONu2jvxPIp?=
 =?us-ascii?Q?rC36vLA/8wrzJMz3/2C+4YTkOAuxVFE3lTb4+s+UBypLSPTsnhNXt4D+z/56?=
 =?us-ascii?Q?iYTgUld/VTvxQKQm9I/Emjl8I/9oBQnmpO7nZ7gmI3rSIgenNsUqib5sKoEy?=
 =?us-ascii?Q?K2IPgtut6Dk1RliOPdrQkFR2LfpTKrr5ts0TlvmHTjRb7LyWvuqwrHIlgXrJ?=
 =?us-ascii?Q?8U54HzY5bIbhnJ7SXcq4nvONL5n9fn0pvpX8IremcgMOos0V+RH8GwWbrVmo?=
 =?us-ascii?Q?WJXfTuXsgxhFq9m1BLuuhheRQtrOx8Pygd6XR0xuY1dN5vJLq7QPS1CS1rRL?=
 =?us-ascii?Q?/ycCfvdabkc2Ye6+fPBx0AtRbu9ea1Kdn0s114fvpBgwEJe1E1GbJM7X9c29?=
 =?us-ascii?Q?WzIlwnDzCHLYTSttBhSvkiI8y1nhl5Qw+YWNL7DPXB4HauEsD4z07OvQKNCF?=
 =?us-ascii?Q?9SqG5+QwjVFgEKMsjDahL2TTBRvycxo0FNhgrK0CVCKso6LQd1yxG9/mqPKC?=
 =?us-ascii?Q?+jEJNmKMsfVK7kC5ikiCYn3i8v6H98rnKEvC8kCx9VpIMoMjykPFxIg6jmAv?=
 =?us-ascii?Q?mIRG9weh4wKdemflFW1CHjR1e/YS1A6ccfSIuJ0mUq3RuxSnw5BVehGyQ+n0?=
 =?us-ascii?Q?ZtlkRW7NLdJ2pWLdZc2oHLWlzqORV9C3e0QV33RmSkogqYiZev99mx5Wt+sr?=
 =?us-ascii?Q?sU1obuuspMPsCWdzv/rWIn6uHXIHhfLONxFa7KD3hxSlSLA+YBirkPY3nnvp?=
 =?us-ascii?Q?gp8XtSoMKIRRnVhsExsNaQgdBfDXwQonr1c2cshmfxOiH4Xp+QIrAH4AvGXG?=
 =?us-ascii?Q?7A1xvH41zyp6Zq7pTF3SArk8Nmwn0pqbytlSCZkbcp8Ue/afFCj/UkzQRtwk?=
 =?us-ascii?Q?ZAjr?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1FE01054C65A434E987CA83C6F8E98E4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8194be6a-dc39-44bf-76df-08d89f6ed18e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2020 13:55:58.3099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: beoYN6/JAc13PPR9Gbpt+dYrcRT3sbPEywbb4fsvSEZHiI7TCPTRZLc+WFpJo10lQNLYyXxAHiA+lvQ0AHRU5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

On Sun, Dec 13, 2020 at 03:22:16PM +0200, Nikolay Aleksandrov wrote:
> Hi Vladimir,
> Thank you for the good explanation, it really helps a lot to understand t=
he issue.
> Even though it's deceptively simple, that call adds another lock/unlock f=
or everyone
> when moving or learning (due to notifier lock)

This unlikely code path is just on movement, as far as I understand it.
How often do we expect that to happen? Is there any practical use case
where an FDB entry ping pongs between ports?

> , but I do like how simple the solution
> becomes with this change, so I'm not strictly against it. I think I'll ad=
d a "refcnt"-like
> check in the switchdev fn which would process the chain only when there a=
re registered users
> to avoid any locks when moving fdbs on pure software bridges (like it was=
 before swdev).

That makes sense.

> I get that the alternative is to track these within DSA, I'm tempted to s=
ay that's not such
> a bad alternative as this change would make moving fdbs slower in general=
.

I deliberately said "rule" instead of "static FDB entry" and "control
interface" instead of "CPU port" because this is not only about DSA.
I know of at least one other switchdev device which doesn't support
source address learning for host-injected traffic. It isn't even so much
of a quirk as it is the way that the hardware works. If you think of it
as a "switch with queues", there would be little reason for a hardware
designer to not just provide you the means to inject directly into the
queues of the egress port, therefore bypassing the normal analyzer and
forwarding logic.

Everything we do in DSA must be copied sooner or later in other similar
drivers, to get the same functionality. So I would really like to keep
this interface simple, and not inflict unnecessary complications if
possible.

> Have you thought about another way to find out, e.g. if more fdb
> information is passed to the notifications ?

Like what, keep emitting just the ADD notification, but put some
metadata in it letting listeners know that it was actually migrated from
a different bridge port, in order to save one notification? That would
mean that we would need to:

	case SWITCHDEV_FDB_ADD_TO_DEVICE:
		fdb_info =3D ptr;

		if (dsa_slave_dev_check(dev)) {
			if (!fdb_info->migrated_from_dev || dsa_slave_dev_check(fdb_info->migrat=
ed_from_dev)) {
				if (!fdb_info->added_by_user)
					return NOTIFY_OK;

				dp =3D dsa_slave_to_port(dev);

				add =3D true;
			} else if (fdb_info->migrated_from_dev && !dsa_slave_dev_check(fdb_info-=
>migrated_from_dev)) {
				/* An address has migrated from a non-DSA port
				 * to a DSA port. Check if that non-DSA port was
				 * bridged with us, aka if we previously had that
				 * address installed towards the CPU.
				 */
				struct net_device *br_dev;
				struct dsa_slave_priv *p;

				br_dev =3D netdev_master_upper_dev_get_rcu(dev);
				if (!br_dev)
					return NOTIFY_DONE;

				if (!netif_is_bridge_master(br_dev))
					return NOTIFY_DONE;

				p =3D dsa_slave_dev_lower_find(br_dev);
				if (!p)
					return NOTIFY_DONE;

				delete =3D true;
			}
		} else {
			/* Snoop addresses learnt on foreign interfaces
			 * bridged with us, for switches that don't
			 * automatically learn SA from CPU-injected traffic
			 */
			struct net_device *br_dev;
			struct dsa_slave_priv *p;

			br_dev =3D netdev_master_upper_dev_get_rcu(dev);
			if (!br_dev)
				return NOTIFY_DONE;

			if (!netif_is_bridge_master(br_dev))
				return NOTIFY_DONE;

			p =3D dsa_slave_dev_lower_find(br_dev);
			if (!p)
				return NOTIFY_DONE;

			dp =3D p->dp->cpu_dp;

			if (!dp->ds->assisted_learning_on_cpu_port)
				return NOTIFY_DONE;
		}
	case SWITCHDEV_FDB_DEL_TO_DEVICE:
		not shown here

I probably didn't even get it right. We would need to delete an entry
from the notification of a FDB insertion, which is a bit counter-intuitive,
and the logic is a bit mind-boggling. I don't know, it is all much
simpler if we just emit an insertion notification on insertion and a
deletion notification on deletion. Which way you prefer, really.=
