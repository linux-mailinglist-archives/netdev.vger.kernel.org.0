Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D0946F201
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243057AbhLIRhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:37:02 -0500
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:35906
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243038AbhLIRg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:36:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQJHCbx9Pmfm23/Gc7MiX+Nvma6Rk6WFHMuZT90SeETMzkdswJLgP/8E8/hU9Qa++KDvT3x3LmCPh7QbbXqrQKTixHh3iD/v+kueaPKs5k2BJ2KaOJFhN5rxLXpxWcnpcHF271f/hUHQ2tZFLkh9LWo98cSdGzpVdqOTKcvo9RMxVidDoc/7JZWYsFPdwRk/w04rT6OVHS0rwyxwGwEBX3j6q75o4ewjyma6osLwqTfSMlNmJ8W0L8NstPDb2M6DhmeArP4zNl8Dr6X/ecdQgGILnUKJIPkopFjyRq234CnXx+nf9424gU+7O5mI4jxnOL0VXzQS4eES3OD8E56xUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2YkvuUxTJJP1FlGafkxyS7JKLxhCjT49Qyfb/T7I+4=;
 b=K9PhYKA8cCV5BOxdN2ZCFsDOcnUDgtHFiV+7zbYRdbxOSsZQ7DSGtFXY5nQW+EzedyXmhqIEqw2crCA0fJZ0y9iUI00yyrlhOhWidgiOmdUuqD+FLxzGKZFfnrt1DywQb7FVpZZgZIOUWcAMJa2wzsIsjNX5Rb3egQK2yoeLYtXUVPsQTXYZ+65BNMYRCxDESuhGScFsxkxelbe/1ELJ/4rzN0jIzywx8eBiLjSzYz1bA0FT6WDgxuhXUIABFVg9fCzfKziZjvi/XK6/WtcNCHKWX3sFAGVL0FSuPBAPYG5OAepOW2/0bGBizhAWqvOcrvvhrwKC6mq0umWxgG44Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2YkvuUxTJJP1FlGafkxyS7JKLxhCjT49Qyfb/T7I+4=;
 b=CxkdKio7wHjUUIPYbc13kToabOwVgnRw6tj8g39d7bGP7MZeiHtLRhbFrs3Tb8TwamDd8lHaxfNfLf7evJ/Q1UDQZgpSPJicp+ZtZWwbXgcBpARJS3GII8uWrVLcwv7TLsfrN5fr8ngp22sc9uPUsO7/f0uYOq01xRWEiCDebEE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2512.eurprd04.prod.outlook.com (2603:10a6:800:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 17:33:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 17:33:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 0/7] DSA master state tracking
Thread-Topic: [RFC PATCH net-next 0/7] DSA master state tracking
Thread-Index: AQHX7IOEQ9VmgGohuU2xLWeadphC86wpelqAgAC+sQCAAARmAIAALzoA
Date:   Thu, 9 Dec 2021 17:33:17 +0000
Message-ID: <20211209173316.qkm5kuroli7nmtwd@skbuf>
References: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
 <61b17299.1c69fb81.8ef9.8daa@mx.google.com>
 <20211209142830.yh3j6gv7kskfif5w@skbuf>
 <61b21641.1c69fb81.d27e9.02a0@mx.google.com>
In-Reply-To: <61b21641.1c69fb81.d27e9.02a0@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2cd8b04e-a013-4093-c602-08d9bb39fca3
x-ms-traffictypediagnostic: VI1PR0401MB2512:EE_
x-microsoft-antispam-prvs: <VI1PR0401MB251256E72733451706175D0BE0709@VI1PR0401MB2512.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wcSooRH/LVGwpb+2ppOJyeD6cMqIRJszStAIUhS+nez22hF6gzk0cR5QSAFIeMShX2In6nNcbu6T2brrai7F6dAlnR1sstYRDhmBWAJZOA3/zowGAsmNkxVx7N/iUxi7TG+XODBCs5tbwiyuVKWHjotQG2dPpVJX0P21KeFrJPXS9WhbP8u0dqHVjQYuw/LzfH0CxJNAMIeCSzpTIy8oFDCp/bfbTLGFBftLSCJmMXqjuCcFOXosPMABgddolbOXQg/9+yt+EeLGY4PlgCCRgZ2D1o1SnPWJvwuweOiUcA0fnXWdBKrn7qguxvRslOwlsDy08Om0SMWRC++B2qqXMVmrSUe2JNrLaAVjtn8NosOit0N8m+VDp/kLgpVyF+o9YnW2wUSJ49n4Ue63WfxiQyIxt9tJQcfvbEksO+mbq0/aHLTBXoowDPWQLx81D6RrJCXu2PZ4RNTWcKkEFE3U0KCucxvXt+M/15G3sqKtfV7ok4w4GdbmSGqRHS0FQGddlXLmEXGU1E3cX71ZCqORWtwBSfLwMzK6i5dBpfZJTwgnRXREHa4Yegf6810xWPsUtRHqd+xzQe79PVjAlNgUndTTklnF+q/WL8HhlzkX6l9lntrxp51f++FIhkYODn0YFEaW7jLdytDiZPoSL51wObNkJ/pp3ffJTP544eEPRM3LJ8WgEed4R/vSlALzoJ+2I8jiApn55PkcEWF/eRf/PN14x/iD7QtgUOmtcxEuoFZvdfKV2aP3kkIQlhA3cNI+aZCSGlhcEEFWEEwBtPnN22937J0CtO2ft1KwJ0eUoSmgrEM8C7oJArCAN6+gBgpackopMGylSVzMeJwXPDPDFH7JGm+vvpWaPEFPVxhIaoo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66946007)(83380400001)(86362001)(76116006)(66574015)(64756008)(66476007)(66446008)(66556008)(8676002)(38100700002)(508600001)(6916009)(122000001)(38070700005)(5660300002)(8936002)(4326008)(54906003)(316002)(1076003)(2906002)(9686003)(6512007)(71200400001)(186003)(26005)(6506007)(44832011)(33716001)(966005)(6486002)(10126625002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DX78I/ruOHx1ZGuW8fx139JvIROyNupKGGyGgffXzVrHIUbAUEs3caeRv7OO?=
 =?us-ascii?Q?PEwtt/+nRwAo34ZXOpWA+M3Z5upVQD0AcSZ6Kq23BzeEcHpL0QoYRRJLJgub?=
 =?us-ascii?Q?BU64kayNIgQMoTghPE1rj58BhzJvv6RKtAkJztW8lywzZw01kf/rlavOxk2P?=
 =?us-ascii?Q?NBUak0b4WIOavyLf83dI/vBnkqMDl9v2GaVIPCxq4tjq7RndR/F6+3Gc7GfA?=
 =?us-ascii?Q?DXe5sAyiD/m28gDO+r5afo0nxX9NHUpsLVREtIe5k9U7h1CKwaoQKpav6Xqe?=
 =?us-ascii?Q?B1Uqk3MBLOUSHSohCTTdXWEqFAt9JYNTCf0NbcnPHoa2nbqxSCeScARBN8/m?=
 =?us-ascii?Q?dBibXeUEgVNW+Yb1wKV4GKeT+nHPOE6rUjhfQ1E4s5NDWTmLNPx5spK7NjbN?=
 =?us-ascii?Q?Fh2cyF3nN8/slAZfEJl3ag53WN63Et7URsWNwmpwKUxbb+90C0nYHLZx+Oeo?=
 =?us-ascii?Q?vLl5ALc2aBrPLOZNtCxQ7VW+LX2qhhUgTGJPA0EvZ6UInenay0jecDmnBAoP?=
 =?us-ascii?Q?rXV/6Cv9U2xt3ko0bjTMeu0H4vKHmNojp+43Ze2ssv9Pih2bg1zoXaLrhwQZ?=
 =?us-ascii?Q?/i5aQ+SmbZgORKZSxjY+xNhIxWkfQjW6sjJ4U6SWYkC9zwDidHuPcwvQYWSf?=
 =?us-ascii?Q?NAsw4MtS4kFUtc1vnvYkhVlQyrkFG8dRHxxp0pQ/EVPPYIusg9ODEOmS+Azy?=
 =?us-ascii?Q?MvFnVHN7v2rUxqJkyfuf5WGY8m7gIG00QsykhLz9tT7WshP+wFEmUMxIAV2i?=
 =?us-ascii?Q?CJG57x5sHnugVhOlmFuwiGZFdOFxmn4kZw+I+4FBt2PEDCTwnKzz4DsuBnxc?=
 =?us-ascii?Q?mt8++rPCcHNWxLvQFMncfZ0LYQbnccxVLF5AT1FgTwqhpeZSk+UQJUGpUrLA?=
 =?us-ascii?Q?K4vmfGOesoXr18kBsW95UI5axWz1A7KYLhbGj9mIX0JTj9h+PaPCXIRAIUhG?=
 =?us-ascii?Q?C0Y7cP/PjASSEQCl7AdSJFWPVS7HTyAxhNUEpnTtxCINISsoAvfK7yVzcyj8?=
 =?us-ascii?Q?r5BpjFjSMOOsOcZ0W3N1S1WPG5TlNjsViQC3HHE13mlwW+bIKUTapfgk1CTN?=
 =?us-ascii?Q?zZctN4NRZ7V8mg5wWGWsTyodWqz7LmLxp17oaL5Gdm0Lqxsfv4mRGZx70/vf?=
 =?us-ascii?Q?SmNgbmc0j10N7O499UD6qjiYkoN/kSJktg2MbJHR9j3MQPm8vYHX36il4Z5n?=
 =?us-ascii?Q?GFn8shp1yrdkI9Go1OOVpt1iIPvjHF3pl4QlsDG69oZ1Z/F9cTvWG0+N108S?=
 =?us-ascii?Q?xcGn83gjNllTuuqX4ZFFF8Ou3KqTFWgnQz2mLER0lRpgDY+o3ZE7E7apjZOP?=
 =?us-ascii?Q?GY6JkXs8wKA9qvaRBwi+tIzOG0A/R7HTUJd+8cN1LuiGg908H9cn+hOYk2+d?=
 =?us-ascii?Q?XIA4Y3KTfYTA+azU8ZikPnzED8dXnnkPxdRl/hNCz53nLlLy2UZ8AP6uBaf9?=
 =?us-ascii?Q?VwnWVu/PNiIvCrryP2JK/PibOawsYCFrmglCZhyUvffTfIenAdaEr970m6Lz?=
 =?us-ascii?Q?yXFSf320D18f0xm8SDEaVhxPxZO0WHE0PCC4RAoQGX8j7wH3+XQbkbWqZz/r?=
 =?us-ascii?Q?P2N9EKmihOSXC8f2NLqEDh1X8Xe/Q5IlkwZICyRuo5dn3x4rFPCAvKMhirt6?=
 =?us-ascii?Q?ZWmyd1NRoZDEPd6AY4lxY/k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <86835238CAD07E4C850E852861EE2B8A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd8b04e-a013-4093-c602-08d9bb39fca3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 17:33:17.3882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v6ruo+SP/FdQ6ptoRZEFZahC68vIwY/AaqFQ/CirPjpmk5PSX6KaW3yk6pSmLhIZczAqczCqDHqL5FkHLjIxSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 03:44:14PM +0100, Ansuel Smith wrote:
> On Thu, Dec 09, 2021 at 02:28:30PM +0000, Vladimir Oltean wrote:
> > On Thu, Dec 09, 2021 at 04:05:59AM +0100, Ansuel Smith wrote:
> > > On Thu, Dec 09, 2021 at 12:32:23AM +0200, Vladimir Oltean wrote:
> > > > This patch set is provided solely for review purposes (therefore no=
t to
> > > > be applied anywhere) and for Ansuel to test whether they resolve th=
e
> > > > slowdown reported here:
> > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942=
.7444-1-ansuelsmth@gmail.com/
> > > >=20
> > > > It does conflict with net-next due to other patches that are in my =
tree,
> > > > and which were also posted here and would need to be picked ("Rewor=
k DSA
> > > > bridge TX forwarding offload API"):
> > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211206165758=
.1553882-1-vladimir.oltean@nxp.com/
> > > >=20
> > > > Additionally, for Ansuel's work there is also a logical dependency =
with
> > > > this series ("Replace DSA dp->priv with tagger-owned storage"):
> > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211208200504=
.3136642-1-vladimir.oltean@nxp.com/
> > > >=20
> > > > To get both dependency series, the following commands should be suf=
ficient:
> > > > git b4 20211206165758.1553882-1-vladimir.oltean@nxp.com
> > > > git b4 20211208200504.3136642-1-vladimir.oltean@nxp.com
> > > >=20
> > > > where "git b4" is an alias in ~/.gitconfig:
> > > > [b4]
> > > > 	midmask =3D https://lore.kernel.org/r/%25s
> > > > [alias]
> > > > 	b4 =3D "!f() { b4 am -t -o - $@ | git am -3; }; f"
> > > >=20
> > > > The patches posted here are mainly to offer a consistent
> > > > "master_up"/"master_going_down" chain of events to switches, withou=
t
> > > > duplicates, and always starting with "master_up" and ending with
> > > > "master_going_down". This way, drivers should know when they can pe=
rform
> > > > Ethernet-based register access.
> > > >=20
> > > > Vladimir Oltean (7):
> > > >   net: dsa: only bring down user ports assigned to a given DSA mast=
er
> > > >   net: dsa: refactor the NETDEV_GOING_DOWN master tracking into sep=
arate
> > > >     function
> > > >   net: dsa: use dsa_tree_for_each_user_port in
> > > >     dsa_tree_master_going_down()
> > > >   net: dsa: provide switch operations for tracking the master state
> > > >   net: dsa: stop updating master MTU from master.c
> > > >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown=
}
> > > >   net: dsa: replay master state events in
> > > >     dsa_tree_{setup,teardown}_master
> > > >=20
> > > >  include/net/dsa.h  |  8 +++++++
> > > >  net/dsa/dsa2.c     | 52 ++++++++++++++++++++++++++++++++++++++++++=
++--
> > > >  net/dsa/dsa_priv.h | 11 ++++++++++
> > > >  net/dsa/master.c   | 29 +++-----------------------
> > > >  net/dsa/slave.c    | 32 +++++++++++++++-------------
> > > >  net/dsa/switch.c   | 29 ++++++++++++++++++++++++++
> > > >  6 files changed, 118 insertions(+), 43 deletions(-)
> > > >=20
> > > > --=20
> > > > 2.25.1
> > > >=20
> > >=20
> > > I applied this patch and it does work correctly. Sadly the problem is
> > > not solved and still the packet are not tracked correctly. What I not=
ice
> > > is that everything starts to work as soon as the master is set to
> > > promiiscuous mode. Wonder if we should track that event instead of
> > > simple up?
> > >=20
> > > Here is a bootlog [0]. I added some log when the function timeouts an=
d when
> > > master up is actually called.
> > > Current implementation for this is just a bool that is set to true on
> > > master up and false on master going down. (final version should use
> > > locking to check if an Ethernet transation is in progress)
> > >=20
> > > [0] https://pastebin.com/7w2kgG7a
> >=20
> > This is strange. What MAC DA do the ack packets have? Could you give us
> > a pcap with the request and reply packets (not necessarily now)?
>=20
> If you want I can give you a pcap from a router bootup to the setup with
> no ethernet cable attached. I notice the switch sends some packet at the
> bootup for some reason but they are not Ethernet mdio packet or other
> type. It seems they are not even tagged (doesn't have qca tag) as the
> header mode is disabled by default)
> Let me know if you need just a pcap for the Ethernet mdio transaction or
> from a bootup. I assume it would be better from a bootup? (they are not
> tons of packet and the mdio Ethernet ones are easy to notice.)

Anything that contains some request and response packets should do, as
long as they're relatively easy to spot. But as stated, this can wait
for a while, I don't think that promiscuity is the issue, after your
second reply.

> > Can you try to set ".promisc_on_master =3D true" in qca_netdev_ops?
>=20
> I already tried and here [0] is a log. I notice with promisc_on_master
> the "eth0 entered promiscuous mode" is missing. Is that correct?
> Unless I was tired and misread the code, the info should be printed
> anyway. Also looking at the comments for promisc_on_master I don't think
> that should be applied to this tagger.
>=20
> [0] https://pastebin.com/MN2ttVpr

It isn't missing, it's right there on line 11.
I think the problem is that we also need to track the operstate of the
master (netif_oper_up via NETDEV_CHANGE) before declaring it as good to go.
You can see that this is exactly the line after which the timeouts disappea=
r:

[    7.146901] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

I didn't really want to go there, because now I'm not sure how to
synthesize the information for the switch drivers to consume it.
Anyway I've prepared a v2 patchset and I'll send it out very soon.=
