Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD22CFE0C
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgLETEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:04:04 -0500
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:32334
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725267AbgLETEB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:04:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4gHtqhVE57UtGd8uUZ4xy16UtroCj4wVR/EfZnjAARsZiinBZ0k3eM6LBhrDoTwM88deL6v7MT006DXsK9niQNTZQ5go7PxdGoXrU3eW+Xc5jkZ/lM1dj8NMOJ5ZiemX0UEgjQwzuLBEWPzlyyBUo7ydCkciM7kY6+hJbH0GjC3QvB6FeIcTewK8PES29OvRbUk2xDE+6qTEtPXdrpzvO0ug5W7iakSdP+ROdckOILRwjAVxKn+MmuII2c49L1cbCnJsHJSP3YTYg+OwAWWJHzmdtWx8NBBtYguJwgtXzNEj2svtW+Voj0XKbbVTlCYAGuHwlGIicY8pMV1Ztw2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qereEVVea072/iSYY+7ugGMZR/2Kj9eAnpMoyHhEhZc=;
 b=dJCoyRHUGDDyigd9k91YkpUTRHN7CcVNgNsgeGvT3yzrelv9t/iUCm9Ggbl4NUZettymA6tKt0Csgg2XyRLkybosBd6yuICkqwkdp59pTw6hNWaTTfGDUJJayxVtLyPQkZzceTrCrXP9f9t0+aQmPF7qMhYd6sJJ2mIlg0j9f26dzlZ4QrxihtvJ06ERiKCl1a6r2xC8bgrVDuyqLl78rS/jgDc4McG7oH1HWRQ4dIh257g841vDpQTbFf1pR0eVJBI6LxJzX6ZHvrsJZB8uDeLtOF0S2JT49DmMU8zr2aP6CygheCcv/vp3/zRJumb7e21MdQOo+4+9S1wKVQvDnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qereEVVea072/iSYY+7ugGMZR/2Kj9eAnpMoyHhEhZc=;
 b=KZcKk/IeUSR1CqgM16Aj0u30ECK77RdRiPJQ1wFr5+t1CZIEe/qdyeBANBREgs8Up0ecV6TvkI6NUHTCQFDnpvWftjGn46d7kMUoLG6dUYUUIG88i9A6DlRqVphs57BwbQ1hLDhmv0S4idaXzP1S8HGQ049o7aYGrUrA/yyKhhQ=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.31; Sat, 5 Dec
 2020 19:03:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:03:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: vlan_filtering=1 breaks all traffic (was: Re: warnings from MTU
 setting on switch ports)
Thread-Topic: vlan_filtering=1 breaks all traffic (was: Re: warnings from MTU
 setting on switch ports)
Thread-Index: AQHWyxXKCqBxYHwhmE+cYeSX9acSUqno3GAA
Date:   Sat, 5 Dec 2020 19:03:11 +0000
Message-ID: <20201205190310.wmxemhrwxfom3ado@skbuf>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
In-Reply-To: <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9962acfe-65c2-459e-9d5d-08d89950698f
x-ms-traffictypediagnostic: VI1PR0402MB3552:
x-microsoft-antispam-prvs: <VI1PR0402MB355208AF29479B85F64F196CE0F00@VI1PR0402MB3552.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sDzDWE90GTDE4cZ0q/5BGGaYoVGxnbTvmtkjR5ACg1s3g93aKEFZwfU3MlMeQiUX+TcXeTzI9Dnige+21UTGhqtuH5kYl7sFhxHF6rPrAYGtt4jAR/3WD+YD02RNs4G9v291BTGIFwmCGjyJZFuJ3mPGd+RUyTesp5QxXSsUQJBMm4QfvAusQ1K2e7mX+OIEUL2yWqgNefPvdII3N9USdlPjs114bDgHMgpFlccRRzg4woEr1d1NNnrTUKBwrgxGNMrq3LGlZF2ZcRLZFkPYoBeJOufI7CGsbEGCDXyl2igDgVgF0ySg7s+S1qAz3ZrxPAj67RVmw4qeO9cwnX4KgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39860400002)(366004)(136003)(396003)(376002)(44832011)(5660300002)(186003)(9686003)(6916009)(8936002)(1076003)(66476007)(86362001)(76116006)(33716001)(6486002)(66946007)(316002)(64756008)(66556008)(2906002)(54906003)(66446008)(26005)(6512007)(478600001)(4326008)(71200400001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tTDGVvgZe5yFwq49adNsiFTtOvDhABqK38Q774UHbgf/GZZXDLV23Q+QAKqh?=
 =?us-ascii?Q?SLlVIl6Vb1TGGobFoGyv90q+8dtxfh222s5y5EU46dJNQ/XlHaTRCuxTwJ9Y?=
 =?us-ascii?Q?WDXJNZm9x+4CfOFKuy2/YzlaMVVeVYq062UmmOENr8qxy6AvOQs74Za/TTqk?=
 =?us-ascii?Q?6C9asYfHqZtKjtwkzolqFWPoxb1zn5ldGpsKwMYiJn6ORRbs4jPkqB39lw8H?=
 =?us-ascii?Q?l2QiBSvbpPXNAHJqbWsTeTbrf7oy+g2QsjqCbDo+anLpUaeAmT7edk41DSgw?=
 =?us-ascii?Q?SZi1NE/m6ADehI9r25g8Bm1rMe6vaODhCZdtUmUft6CWCv+ruxqAaXhKwiQt?=
 =?us-ascii?Q?bVSsexXzurW9Ccf3Mzr6A6J9iDr9WNyLtTPQ93Z9RolrYaU/DVLhj/E8NdFO?=
 =?us-ascii?Q?+dkL4XIU2jtbt1p2yfS6iMFQugaA8P6X8RxKC93nV4RKd+YeB6tcxc2p92Qs?=
 =?us-ascii?Q?vnoH9X7/eqiJw9465PDAReSKsKlHK13nIUD5twcwkmWzVetNf81LNp2+40S2?=
 =?us-ascii?Q?mpBRddddg7jpJOYLmWtLXcId10+gd+GJXktwz2JICD6VF5k8ixnxsDa0qRdX?=
 =?us-ascii?Q?QSopwaHLszPlqDLXmebUkP9b5Ni/HWhOpCm6GyVSH+GuAuscz5Q+M85ZM/6G?=
 =?us-ascii?Q?SxHRlHvn8Gn1paolobkIS96fpzyXknTm87xgyKW7drJCxuiN+4xSGgDYwhLg?=
 =?us-ascii?Q?LtEOueL16aYoZ8BisNdQlIA1eP8LNWbK9O0zpwz/ueoaFiU2w2dKekkX2bOG?=
 =?us-ascii?Q?3HHL8STohGgJl7CJBiAmTQhD1kIzlM5/j0mLpvu8wa9NX4cL22peB8cHGFwY?=
 =?us-ascii?Q?k3YNiVisTGMBFtrTGRpRupCBRWWLbG+j89o8627TGvt8vbd+a+F2fT3cdj4s?=
 =?us-ascii?Q?/tfkCDk1c6w8oylBfJ8WUoQuO2N0cKigLs8m2gesMBRA6o2HVWPhnHPWXaa1?=
 =?us-ascii?Q?p0KdvUxMS6bk1h/W5rndzfaVCruKXWP4JeoCv1fQ2jVbYCq2+2yMuuhxKxn2?=
 =?us-ascii?Q?gbrM?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AF63A6612B6F624086572CC29217B685@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9962acfe-65c2-459e-9d5d-08d89950698f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2020 19:03:11.9328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aV4By2EPsg7ZMnSvuL9AId13tI5oH3ilFWKFS1vmBZ97GCi5YAhynXhTV/Vfj9QA6LkMVZOdDbyIK9BdpYwURw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Sat, Dec 05, 2020 at 03:49:02PM +0100, Rasmus Villemoes wrote:
> So I'm out of ideas. I also tried booting a 5.3, but that had some
> horrible UBI/nand failure,

Test with a ramdisk maybe?

> and since the mv88e6250 support only landed
> in 5.3, it's rather difficult to try kernels further back.
> Does anyone know what might have happened between 4.19 and 5.4 that
> caused this change in behaviour for Marvell switches?

I think the most important question is: what commands are you running,
and how are you determining that "it doesn't work"? What type of traffic
are you sending, and how are you receiving it?

I don't own a 6250 switch, but the 6390 and 6190. On my switches, both
termination and forwarding work fine with VLAN filtering enabled -
tested just now. This is with the official v5.9 tag:

commit bbf5c979011a099af5dc76498918ed7df445635b (HEAD, tag: v5.9)
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Oct 11 14:15:50 2020 -0700

    Linux 5.9

It's interesting that it is you who added VLAN support for the 6250 in
commit bec8e5725281 ("net: dsa: mv88e6xxx: implement vtu_getnext and
vtu_loadpurge for mv88e6250") which appeared around the v5.3 timeframe.
When you tested it then, did you apply the same test as you did now?

It is very confusing that you mention v4.19, since of course, it is the
v5.3 tag where the 6250 support for VLANs has appeared, just as you said.
As far as I can gather from your email, the only kernel where your
testing passes is a kernel that nobody else can test, am I right?

So it either is a problem specific to the 6250, or a problem that I did
not catch with the trivial setup I had below:

# uname -a
Linux buildroot 5.9.0-mox #1526 SMP PREEMPT Sat Dec 5 20:53:11 EET 2020 aar=
ch64 GNU/Linux
# ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
# ip link set lan4 master br0
[   56.393743] br0: port 1(lan4) entered blocking state
[   56.396614] br0: port 1(lan4) entered disabled state
[   56.408327] device lan4 entered promiscuous mode
[   56.410255] device eth1 entered promiscuous mode
[   57.155280] br0: port 1(lan4) entered blocking state
[   57.157639] br0: port 1(lan4) entered forwarding state
#
# ip addr add 192.168.100.2/24 dev br0
# ping 192.168.100.1
[...]
--- 192.168.100.1 ping statistics ---
18 packets transmitted, 18 received, 0% packet loss, time 17034ms
rtt min/avg/max/mdev =3D 1.389/1.643/2.578/0.266 ms
# bridge vlan del dev lan4 vid 1
# bridge vlan add dev lan4 vid 100 pvid untagged && bridge vlan add dev br0=
 vid 100 pvid untagged self
# ping 192.168.100.1
[...]
^C--- 192.168.100.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2005ms
rtt min/avg/max/mdev =3D 0.993/1.358/1.633/0.269 ms=
