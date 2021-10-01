Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A141F405
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355582AbhJAR5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:57:15 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:49248
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355555AbhJAR5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 13:57:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLT+kSJdkbI7PI3pYmMb+EEam4o5dIQ71dJQX2ztB6W1+okvRDK2ENgdyv6IX8LjUMCycy0ao9hJwjbXstL+l/MiFSluWr42khkM20dqD4S5vvh+jrkFeFH1xpExId1wA9auOGDd7WbnaThkmcUkqnfWfI8dONo1VOVUN/Tm2r38PhcAqN8X1dzXICDNuHcWTcaNKgb/CFzAAyAvYVPh0+fzaUwJfi/ddJ6/xn5yQIRhpz5w+KNcAsDRIbFesuPYWVTGWXv0evwI19zDV5VOjn5SAXoNE2SHsu7E/3EvnV+tO29W7Xunu2HB6GLw9rGtTlsqucSrJRabAYvMUY7xoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mDU5ZwvJFuJKKIXsJqovV8vsw8GJ7ukieUD2FJam9Yg=;
 b=EunHqIOd4Z3GyzK+Vx4gi+AnxZI620PDd4kk0VtId+F14jkm0WivTDRg7RmLQRyAXr8RVL8aENw9hs1TahKvm7xEKKDPjIdgwBhyN9+z75GjUiCMhGtr7TSDjLOYaARQjnixfjzibtGoM9wqJ/lQAK7aKG3sKGNI6Qjug/rscifIYRnSOo6pgDl1NYLxQvfzTR2T7Ucq8nLWhA2yWTwG+2OVFZuaR0GnH8p0UGLAlIpFoNh3fklPKd6XwNG1Ag0NcmiXgG7IfyeG62V7Lj1tAR1NYR0LKdojNsBOgHB2dQdVWMMMCQ0iWvfZY8Nysd5pDTANWCf1HjDpEErUsO4QUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mDU5ZwvJFuJKKIXsJqovV8vsw8GJ7ukieUD2FJam9Yg=;
 b=LoAWq9qk7RTdx/+/c9AV74tCJmuSV+xzBXGaYt5m/DhXElaBEfupRDnJVvk4QvzZY8pFIPc37oYvD7eqRxNJUcskOe5swab1NveZ7hDNJIExPzAu74xwNh8e7BENctIbHGgHb7wK7wX2S1/r696kJoFdISt5kuLdza9WvXKKI/Y=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Fri, 1 Oct
 2021 17:55:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 17:55:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: Re: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
Thread-Topic: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
Thread-Index: AQHXtFznyGH2JvuT50mNvd/a5fV2Jau6CVIAgADGvQCAA5paAIAAB+EA
Date:   Fri, 1 Oct 2021 17:55:25 +0000
Message-ID: <20211001175524.3sa2m3occzham5og@skbuf>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <87czos9vnj.fsf@linux.intel.com>
 <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <87lf3cfyfj.fsf@intel.com>
In-Reply-To: <87lf3cfyfj.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 494c8716-91fc-43e6-1957-08d98504a584
x-ms-traffictypediagnostic: VE1PR04MB7408:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB740816EA92DCB9F4A0B38991E0AB9@VE1PR04MB7408.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oKfAvOI8p7le5vsviZZB5zfxA/eFtUT7dluTxTMWmLpVMTd2fOV4h4kfHJD45xyadg0uIv61cl+KXuVJd46lIEbuhNaJXNFkCQJcLV1lkeNkJb6jZRRHFlhc784UcrFqVELoWrlMznuA7KXQ5tl5ke1VGLuo6HyBDYXRdPmA91o5ezJSZzaGOkQhCp7e1jNEHe73mlY6fz5nFnwkP1+T9Cd9Vsb9QoxcQn4sXxNUTzYbjgzaKrCMkEzrKjqv/bx3bh5EmF7+R66j4FDOkdbqKtbUE09Jb73sSb+G5WH16MliWB5+F+qwLSWyEnrooAyeDAYAH+CBZODmj9w/+Oi0o8w7QIJlVFWNiIIzG6ucFSaUpGbtM5RueSYA5F/pAEvlfchfTyhI4BhBEhtyMWJgEeiLwOdaVWkFT/LEh2iNKjMJdoAxgyMmKbd2C0WSBeOD6KdzTV5inJxg0vq88kcVYGbvBDEqQaFmw3Qp3oH9yX3ewcIFkT7/Yvme45wlpx701eoaoRmafo6h8TqkMvYubtrR46VYDA78yzP/4CT0s3z9U3Mys3YQxvcV1+XMOQvlUHAe9gEtbXWmqslq7340+bxPAZ1+nx9je43BO8k4+oVx4fa2pWjnWOZE69dz1zk9neUA86BCkoVKgl8eV1oXvu7p61b3vMTlU6zXQXR5dfxq5Hsd/CWmRMIbHafW8eqRIhkogged1fY9B5tp9ga8GO4Xv4eIlZ8F2DJlmjEqJzBkMy7jMGMyYGox4BfU3jBpEh5W22nw63WBphwt2INpi1F+e9dd4LKkE3+h4Ir3H+g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(64756008)(83380400001)(66446008)(66556008)(186003)(71200400001)(86362001)(5660300002)(66476007)(4326008)(2906002)(91956017)(76116006)(508600001)(38070700005)(66946007)(8676002)(9686003)(6512007)(6486002)(122000001)(33716001)(53546011)(6916009)(54906003)(6506007)(44832011)(316002)(8936002)(26005)(966005)(7416002)(1076003)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eGE50GbktRTK/oV9QLvMPQ+A8/P6LjjzD+LqspwcjNCRQt2Htqt/uVv6kf6B?=
 =?us-ascii?Q?LqJOWufadUqmy0PtbQ3mMbbx4vGFyUjOt1TISWPrnwVYz+5m4cybqhVWhfS5?=
 =?us-ascii?Q?eboGjCWORUa1O5B0rMVNF8l1ZnM/X53eRRbzLjhV9tD5RQHOKzCUv356sknZ?=
 =?us-ascii?Q?TqvW3cidPPovlzImGcLtkzYdhF7wnlDQqmDgXfaQIeoKAqRcGSdPiQa1IDyZ?=
 =?us-ascii?Q?22+VKuwuzqc0x3G3C0PBXHLjYfGHUHh9TJWRlY6Kd9vrYfFNN/asouqpJNkl?=
 =?us-ascii?Q?t52W7+srEtFiyOaAak9IB/G0ZUMc7kFfs+ym3yxz1H/OvQij+eXoM+Gq+eNl?=
 =?us-ascii?Q?AVAP3qUOCxQxqXacIM8hBaRAikWPEPqYhq+/nmmNMwq+45WjaA7WVLNGFLZ7?=
 =?us-ascii?Q?4RVUFOXkVEnhlOvTrdkl2IGAxywPwaEJL/vlvnVtivNP7yfl68UcoZuw111Y?=
 =?us-ascii?Q?7zbaFDY+pYY0T8LFpkI3iYWEWQF+lu3SN+/PerU1P8Gg2GWkbgpcOtu7Kc0s?=
 =?us-ascii?Q?LlI4A+QL5aQJXUuBEZWbVuRtmY7wD8Pwoz29por3mO9pcfLr1u4XuprL2a3o?=
 =?us-ascii?Q?btVl/1sOCTSKfPcNQrUcliQEHWbg8gf+A/Wp9ONxQETwKKNbGN2on7BF78EZ?=
 =?us-ascii?Q?YCNv+zhXcKb5TN7PHKK9xToCunzx/32IIces3RElrjMCjXrnzsTN5zqbrhSK?=
 =?us-ascii?Q?3ngTCWrLX9L9qp9EHgp7Ox8bBkCc0D+9kpCextDnwJ2Fbu8QIOHS9PZIa72f?=
 =?us-ascii?Q?rsIDDA8Dr0Wycdob7Tf3dVYV53Fyltm9gKkNk2fQtYOY0PHzx2QwlzUEF1Gs?=
 =?us-ascii?Q?/ln6yX7BTe7eKtiKRx14VCjp0OgV8hAsCAf4NswnG+XQCX26/eoML+A52sKh?=
 =?us-ascii?Q?wNH29H/+Pqob9Y77PyEotlpHoaYnYuFsYKZ77hTfLTMtZhDySo6IKzXNST7/?=
 =?us-ascii?Q?EiedxitzLLS23WZgYqAVpHiuIRACQV+Q0F2r99s2QxrNSp2FeAZ0/3zA5ZIv?=
 =?us-ascii?Q?s1sOdgWVbgH0aRP1ZIRssErXZAUhKmCO+BlcuinbugvEFbeVc5XQ6vn7puI+?=
 =?us-ascii?Q?e/MoMmIdTr/kpWJKbjUSsJEHNnmC2AJZnZqhwPgETWkpUTYhOsygvsS65zns?=
 =?us-ascii?Q?17B6kRSZG733BcMTduvgTBHY3He/8vixDAKruNIeqKnkfFOu+AbP9tptzFW1?=
 =?us-ascii?Q?2jCIdTI5AQj1GsvToeXOyJuo6vAWjdS6E6khca9H2jelgaWG6UqX58jooxkz?=
 =?us-ascii?Q?/k69jyKJaTA2uuP36X4jhuHi8ugM0NHs2RH42Y2BeQLStxttElRABPa6HA6r?=
 =?us-ascii?Q?ZHZ4vj8QPhR1r1nsriLcOIFf?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27EBEBEA5D84734B83CC16D25090F6D9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494c8716-91fc-43e6-1957-08d98504a584
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 17:55:25.2177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LFz8q5Qi/DBxNajpTDj/5y9WEtfwiqdnWN3NZgfedVTttP/5QVy/1/7sN9UCoozxjvtrVjMa8nSpiPjArIsUCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 10:27:12AM -0700, Vinicius Costa Gomes wrote:
> Xiaoliang Yang <xiaoliang.yang_1@nxp.com> writes:
>=20
> > Hi Vinicius,
> >
> > On Sep 29, 2021 at 6:35:59 +0000, Vinicius Costa Gomes wrote:
> >> > This patch introduce a frer action to implement frame replication an=
d
> >> > elimination for reliability, which is defined in IEEE P802.1CB.
> >> >
> >>=20
> >> An action seems, to me, a bit too limiting/fine grained for a frame re=
plication
> >> and elimination feature.
> >>=20
> >> At least I want to hear the reasons that the current hsr/prp support c=
annot be
> >> extended to support one more tag format/protocol.
> >>=20
> >> And the current name for the spec is IEEE 802.1CB-2017.
> >>=20
> > 802.1CB can be set on bridge ports, and need to use bridge forward
> > Function as a relay system. It only works on identified streams,
> > unrecognized flows still need to pass through the bridged network
> > normally.
>=20
> This ("only on identified streams") is the strongest argument so far to
> have FRER also as an action, in adition to the current hsr netdevice
> approach.
>=20
> >
> > But current hsr/prp seems only support two ports, and cannot use the
> > ports in bridge. It's hard to implement FRER functions on current HSR
> > driver.
>=20
> That the hsr netdevice only support two ports, I think is more a bug
> than a design issue. Which will need to get fixed at some point.=20

What do you mean 'a bug'? HSR and PRP, as protocols, use _two_ ports,
see IEC 62439-3, that's where the "D" (doubly attached node) in DANH and
DANP comes from. There's no TANH/TANH for "triply attached node".
It doesn't scale.

> Speaking of functions, one thing that might be interesting is trying to
> see if it makes sense to make part of the current hsr functionality a
> "library" so it can be used by tc-frer as well. (less duplication of
> bugs).

You mean tc-frer should inherit from the get-go the plethora of bugs
from the unmaintained hsr driver? :)

That would be good for hsr, which is in a pretty poor state, but the
design of the 802.1CB spec isn't really in its favor sadly.

> >
> > You can see chapter "D.2 Example 2: Various stack positions" in IEEE 80=
2.1CB-2017,
> > Protocol stack for relay system is like follows:
> >
> >              Stream Transfer Function
> >                 |             |
> >   				|    	Sequence generation
> >                 |       	Sequence encode/decode
> >   Stream identification		Active Stream identification
> > 				|			  |
> >   			    |		Internal LAN---- Relay system forwarding
> > 				|						|		|
> > 				MAC						MAC		MAC
> >
> > Use port actions to easily implement FRER tag add/delete, split, and
> > recover functions.
> >
> > Current HSR/PRP driver can be used for port HSR/PRP set, and tc-frer
> > Action to be used for stream RTAG/HSR/PRP set and recover.
>=20
> I am still reading the spec and trying to imagine how things would fit
> together:
>   - for which use cases tc-frer would be useful;
>   - for which use cases the hsr netdevice would be useful;
>   - would it make sense to have them in the same system?

You could use FRER in networks where normally you'd use HSR (aka rings).
In fact the 802.1CB demonstration I have, which uses the NXP tsntool
program with the downstream genetlink tsn interface, does exactly that:
https://github.com/vladimiroltean/tsn-scripts

Basically FRER is IEEE's take on redundancy protocols and more like a
generalization of HSR/PRP, the big changes are:
- not limited to two (or any number of) ports
- more than one type of stream/flow identification function: can look at
  source/destination MAC, source/destination IP, VLAN, and most
  importantly, there can be passive stream identification functions (don't
  modify the packet) and active stream identification functions (do
  modify the packet).

Please note that we've already started modeling IEEE 802.1CB stream
identification functions as tc flower filters, since those map nicely on to=
p.
We use these for PSFP (former 802.1Qci) tc-police and tc-gate actions
(yes, tc-police is single-bucket and color-unaware, that needs to be improv=
ed).

Basically IEEE 802.1CB is a huge toolbox, the spec gives you the tools
but it doesn't tell you how to use them, that's why the stream
identification functions are so generic and decoupled from the
redundancy protocol itself.

In both HSR and PRP, sequence numbers are kept per source MAC address,
that is absolutely baken into the standard.

But think about this. When the sequence number is kept per source
station, frames sent from node A to multiple destinations (nodes B and C)
will be part of the same stream. So nodes B and C will see
discontinuities in the sequence numbers when node A talks to them.

The opposite is true as well. When sequence numbers are kept per
destination MAC address, then frames sent from multiple talkers (nodes A
and B) to the same destination (node C) will be interpreted as part of
the same stream by the listener. So there will be jumps in sequence
numbers seen by C when A and B are simultaneously transmitting to it.

Which type of stream identification you need depends on the traffic you
need to support, and the topology.

So again, IEEE 802.1CB doesn't tell you what to do, but it gives you the
tools. You can do source MAC based stream identification, and you can
emulate HSR, or you can do something that encompasses both source node
information as well as destination node information.

It's one whole degree of freedom more flexible, plain and simple.
And the topologies are not limited to:
- the rings that HSR supports
- the disjoint IP networks that PRP supports
but are rather generic graphs.

I fully expect there to be hardware out there already that can convert
between the HSR/PRP frame format on one set of ports to 802.1CB frame
format on another set of ports. Maybe that's something that some thought
needs to be put into.=
