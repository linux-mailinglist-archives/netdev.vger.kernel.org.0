Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6F441F463
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 20:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355488AbhJASNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 14:13:17 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:11425
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232126AbhJASNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 14:13:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRzfY7n8B6z3qkS+20mnw3IfK7aEi8dRaqkadMpRsATplQv9mpW6kshmiOFbyeHxVYIiFl7zHhIhcM/6V6FagIjZb9uWilMNWJAGAIMc2LR4/CurCNO6lw8h3vPPlTO/qwlfjWbdFHmCMA29B/3FhtRHoM8Jzsm56PjsIcSdYooDxqkCxvegcYRb4NsiNl9Iepa8zz3lNTZhj2eg9Y1JSWKhNcKKO8jMlfIC5RkYHKV+w1fgs+GYiddwNAK28bpT5t6W27ebQBXoWi/+8BxwjEGGYA/0jNHUHL8Mox1D5FMXkYKp4Zbv5Dhx54+EfgI5DbF3iHR5kDRG3g8LdDz17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fc024PyNNv5wFITayM74Cvh6VGGWm728iTs2EF0+Wxo=;
 b=OFsMSlr31hcDFBrgA0KKAuipL7rgZKVWyQhqkTQLKGFh+6YoE9BDacuwfXiLgV+jRquyUsYfsPV87q0r9RIF/Hf0DdUCWOViDAeq2wCfCQKMYs/QKmHpmlBcKsZlVVN59P6jkpBqLMJ+sZRoEfGwXhAChTTRT+dmjrzO5Vq9JfDqddJvgy0PtDq0UU9NRNmgCSzIImFMySUN0jAMiP5VY0nQs42dxQpxnJAsML78UvU7WEE9pk+oiE6xIS4LCBykBlLy4LZUxsSjdyL8aoP2rGbmcD7J3Y6YokXjD5CXzrWg51y1LJ/KUgmlYjYmHzzbPTIzcbDnDngDG5O/XeKvXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fc024PyNNv5wFITayM74Cvh6VGGWm728iTs2EF0+Wxo=;
 b=sHyXDgh7eeyZ9oI7lz1C1HqbbU9vL8KBlZEXzIiMLW+EMb9xyGUAp6LLw2Zz9mALLjSySar2dBzS+xmU0YamP6ExC8kVHCGnLtx0zJoiHiP8/A+/FqFIVB2IjYiZqZ+xoaTmXiqzfGAZTT5n4COfyAW08bD2cE6yQZ53qUkw+tc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Fri, 1 Oct
 2021 18:11:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 18:11:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: Re: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
Thread-Topic: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
Thread-Index: AQHXtFznyGH2JvuT50mNvd/a5fV2Jau6CVIAgADGvQCAA5paAIAAB+EAgAAEfQA=
Date:   Fri, 1 Oct 2021 18:11:29 +0000
Message-ID: <20211001181128.goytn4jhicqx7ehk@skbuf>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <87czos9vnj.fsf@linux.intel.com>
 <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <87lf3cfyfj.fsf@intel.com> <20211001175524.3sa2m3occzham5og@skbuf>
In-Reply-To: <20211001175524.3sa2m3occzham5og@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ff67262-3daa-43b5-7dba-08d98506e41d
x-ms-traffictypediagnostic: VI1PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5504531223CD1E52657558E4E0AB9@VI1PR04MB5504.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8F+h495FLzE+h8gWgFwIMKxzrbNY77NdzoMLvqpR4m+q8BcLk5AQImef4lFRDCTnxgkJD2QPi/ZdKE6OrTWGi10LZaFyoiIHGeJvq5i+Cu+pfL1uQOdBL8h5T5/s0FHwurpVhkDIIVvUtXJ+WRqdWEGbWbzyEPgqWH57eInbiNIKyx1ilfMW4QFhqdYe43eXF9AXhU++KbkM6J1/SnmtSzqqTolG04/A+DnoombTyzhVyiDuUgrJl9xZ/jyPdE6UscrLTVuIl9zi5KTurHg02G4GLoFINyeRYEAwQOIYGujwF0X8bXe7xxtSsKubtg2cXN8KOn7fPP8ohVgTrwWsuRpVALMxSFHDlFSN4aCGt6eL17Cd1Mbq6Gf8A8/zZ0/bOgsZYT+WWo49gPRDww2fyUSw6ri4VMP/YasnvH0URVPdvsvEJDtrCJvVhTdqBzi1NcFMfaYL15+W+cI/pGfE8J0WX/92l8Rc2BZIR8UDdTMSYt2Qlz/Gvzm1IidWnDJpp7m6mnpA233STULSl3ghG2Fd7aNu3jOzzauzL9DV1k17NB4e0szIbZwCZKvykTgbmk+PH+0yzlSFdgL+HAynC8xDfUJTsppOUduonpTiQivq+QffZOaCePn1+5eH1dgkkrC9euHmbdI3aCGtUoeXGMjn2xiqQ9nrGHUJ4vve64IIVBwNzicqrukOzuT752txj/9upFu2fKfoD3TA73xIl54WxJo++tdWSvII6rfqTq5sHjNWJDjNgP2Sh12Hck2Vxn5YSf1rV/nmkn1RqZvCDbcR2579kQ6a7jyadGB7aUs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(186003)(38070700005)(83380400001)(5660300002)(6916009)(4326008)(6506007)(44832011)(53546011)(122000001)(38100700002)(9686003)(6512007)(33716001)(2906002)(26005)(66946007)(66446008)(64756008)(91956017)(76116006)(508600001)(966005)(86362001)(316002)(1076003)(54906003)(8676002)(66556008)(66476007)(6486002)(8936002)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PeCVrKq7wMNhllltvEjFllGq4m5P+JOYSh0P4gNBU0gcXdU4I9JhcskGkrJL?=
 =?us-ascii?Q?h1Ruzkeqy7PV/nvf5vautCwkeKCClqDcCu/TFuiFRBWIGNkFKSYUre0h5IyV?=
 =?us-ascii?Q?Ooc8fuvKYH9KW4f61exIwufark9QVaOWDjiY2B1DuY5h2eOTQbbnly4EbB0S?=
 =?us-ascii?Q?u2dIZsrMTHMy1azWDwygkdAfeE9DFnmvmWR7UpfDeqWIFOvNT60S9VrxU/fn?=
 =?us-ascii?Q?EtzfMi0A/zBCYd+G3ayph4nuJPbKb8GiIRNzxW8gdOf4i+UP7NO+YQ6p8TZ8?=
 =?us-ascii?Q?RG0kEqsxqtYv27SYoSbjGGIsZBDZaCrd4vMIst64eLhQMDBNuLLdTZM/HcjL?=
 =?us-ascii?Q?dnCpOmaN9j7ESjydnWxCD9EbtPX24hoMoUsRMJZlQhPCPa/il3h7VZ+Fq9II?=
 =?us-ascii?Q?6hEF0kl5Vi3LKgqi+SsT29KsI54DNdw9za5vFtOYjH9VVbgUTvSPTH60wdi7?=
 =?us-ascii?Q?oApdsRV7BTKNrjvgojtBGftbzjnifMiUxSg/KjUP+geKxaSjTuySWM0WkewO?=
 =?us-ascii?Q?2LHv24pqf+xrzH2DtlRiJgTJwfZevXkoXF5vkEinyw7nmfuNAY20QzBAemd5?=
 =?us-ascii?Q?QqRqBLpGms6uRUcygZztYSSjuU/yM40GOjl/Um+gHcLgMrCkKevVdpZ0BidD?=
 =?us-ascii?Q?Ny5rYdHxQwDTSD6M2CwFGfv1aUD3sLKOzF09G+ahnALqes5qr3rYTDm0y9ag?=
 =?us-ascii?Q?UAJsb8T4lG0O7YlIryFpomON0vyrtrKADamlED9vxt504Y5nW1S5wZZEIkBt?=
 =?us-ascii?Q?59hI/+Sr559isLZiecPYWq37aRplPfmGzpqht4KWlTputKIg4xIaNYKQt6eO?=
 =?us-ascii?Q?0pzbW74jGYozDQoJ4TlQ3M715vjYvRG+tlN/6PKc3KDHgMD2T9ZZZlOTR23X?=
 =?us-ascii?Q?jKGNlQe8mihGwsIxPBSO0MsvY71RsDcRv3HsTRAnmIxTAX/K9YiHfC/SlQ8a?=
 =?us-ascii?Q?9PYa+VDyP53Z8b8lzWEba98JB5KHtX4AjMHcMZogimg/XkVreGpg9RuWGk7G?=
 =?us-ascii?Q?p+hJY/hsVGkog4F9sqmj9xsjlizL0/oR4PbsMzk3/p/r4rGBKUlUmh7CwUlI?=
 =?us-ascii?Q?jofBaViHFYKUtmQByGHDQE7gsf6LUL3qa36wOwsee6nXuboMBSLazI+edSN4?=
 =?us-ascii?Q?+jDsYST07DCy3xFoeisFf+yYBev5SbCTnj6uPkI8hdgjOLXFFpesqD+B2b4K?=
 =?us-ascii?Q?wDIJwz7wbrPR8ziruoqDgcNEDcxxrxvaRCx201AETfpL9Tnwz+7pdIRxR68p?=
 =?us-ascii?Q?DNxGZ0DxuVpWytW/3lysA2wZBtjmKw+9NF8v8LDVjjT2cvTXDMAGdWjtxqvQ?=
 =?us-ascii?Q?a6ldVYJg3vB/03IbeeTkU7YfzR4dpABvL8N14him3n6ndA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <005F40F4D741B44A81ED8BE11EE61669@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff67262-3daa-43b5-7dba-08d98506e41d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 18:11:29.2522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZkvZ+4bbgoln/GkyUtcdAzXnagMb/WNGgtsU+9troAM11tRjC2DaONz0k+lxeoLjvGqcvOqossT2RP5rmzuiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 08:55:24PM +0300, Vladimir Oltean wrote:
> On Fri, Oct 01, 2021 at 10:27:12AM -0700, Vinicius Costa Gomes wrote:
> > Xiaoliang Yang <xiaoliang.yang_1@nxp.com> writes:
> >=20
> > > Hi Vinicius,
> > >
> > > On Sep 29, 2021 at 6:35:59 +0000, Vinicius Costa Gomes wrote:
> > >> > This patch introduce a frer action to implement frame replication =
and
> > >> > elimination for reliability, which is defined in IEEE P802.1CB.
> > >> >
> > >>=20
> > >> An action seems, to me, a bit too limiting/fine grained for a frame =
replication
> > >> and elimination feature.
> > >>=20
> > >> At least I want to hear the reasons that the current hsr/prp support=
 cannot be
> > >> extended to support one more tag format/protocol.
> > >>=20
> > >> And the current name for the spec is IEEE 802.1CB-2017.
> > >>=20
> > > 802.1CB can be set on bridge ports, and need to use bridge forward
> > > Function as a relay system. It only works on identified streams,
> > > unrecognized flows still need to pass through the bridged network
> > > normally.
> >=20
> > This ("only on identified streams") is the strongest argument so far to
> > have FRER also as an action, in adition to the current hsr netdevice
> > approach.
> >=20
> > >
> > > But current hsr/prp seems only support two ports, and cannot use the
> > > ports in bridge. It's hard to implement FRER functions on current HSR
> > > driver.
> >=20
> > That the hsr netdevice only support two ports, I think is more a bug
> > than a design issue. Which will need to get fixed at some point.=20
>=20
> What do you mean 'a bug'? HSR and PRP, as protocols, use _two_ ports,
> see IEC 62439-3, that's where the "D" (doubly attached node) in DANH and
> DANP comes from. There's no TANH/TANH for "triply attached node".
> It doesn't scale.
>=20
> > Speaking of functions, one thing that might be interesting is trying to
> > see if it makes sense to make part of the current hsr functionality a
> > "library" so it can be used by tc-frer as well. (less duplication of
> > bugs).
>=20
> You mean tc-frer should inherit from the get-go the plethora of bugs
> from the unmaintained hsr driver? :)
>=20
> That would be good for hsr, which is in a pretty poor state, but the
> design of the 802.1CB spec isn't really in its favor sadly.
>=20
> > >
> > > You can see chapter "D.2 Example 2: Various stack positions" in IEEE =
802.1CB-2017,
> > > Protocol stack for relay system is like follows:
> > >
> > >              Stream Transfer Function
> > >                 |             |
> > >   				|    	Sequence generation
> > >                 |       	Sequence encode/decode
> > >   Stream identification		Active Stream identification
> > > 				|			  |
> > >   			    |		Internal LAN---- Relay system forwarding
> > > 				|						|		|
> > > 				MAC						MAC		MAC
> > >
> > > Use port actions to easily implement FRER tag add/delete, split, and
> > > recover functions.
> > >
> > > Current HSR/PRP driver can be used for port HSR/PRP set, and tc-frer
> > > Action to be used for stream RTAG/HSR/PRP set and recover.
> >=20
> > I am still reading the spec and trying to imagine how things would fit
> > together:
> >   - for which use cases tc-frer would be useful;
> >   - for which use cases the hsr netdevice would be useful;
> >   - would it make sense to have them in the same system?
>=20
> You could use FRER in networks where normally you'd use HSR (aka rings).
> In fact the 802.1CB demonstration I have, which uses the NXP tsntool
> program with the downstream genetlink tsn interface, does exactly that:
> https://github.com/vladimiroltean/tsn-scripts
>=20
> Basically FRER is IEEE's take on redundancy protocols and more like a
> generalization of HSR/PRP, the big changes are:
> - not limited to two (or any number of) ports
> - more than one type of stream/flow identification function: can look at
>   source/destination MAC, source/destination IP, VLAN, and most
>   importantly, there can be passive stream identification functions (don'=
t
>   modify the packet) and active stream identification functions (do
>   modify the packet).
>=20
> Please note that we've already started modeling IEEE 802.1CB stream
> identification functions as tc flower filters, since those map nicely on =
top.
> We use these for PSFP (former 802.1Qci) tc-police and tc-gate actions
> (yes, tc-police is single-bucket and color-unaware, that needs to be impr=
oved).
>=20
> Basically IEEE 802.1CB is a huge toolbox, the spec gives you the tools
> but it doesn't tell you how to use them, that's why the stream
> identification functions are so generic and decoupled from the
> redundancy protocol itself.
>=20
> In both HSR and PRP, sequence numbers are kept per source MAC address,
> that is absolutely baken into the standard.
>=20
> But think about this. When the sequence number is kept per source
> station, frames sent from node A to multiple destinations (nodes B and C)
> will be part of the same stream. So nodes B and C will see
> discontinuities in the sequence numbers when node A talks to them.
>=20
> The opposite is true as well. When sequence numbers are kept per
> destination MAC address, then frames sent from multiple talkers (nodes A
> and B) to the same destination (node C) will be interpreted as part of
> the same stream by the listener. So there will be jumps in sequence
> numbers seen by C when A and B are simultaneously transmitting to it.
>=20
> Which type of stream identification you need depends on the traffic you
> need to support, and the topology.
>=20
> So again, IEEE 802.1CB doesn't tell you what to do, but it gives you the
> tools. You can do source MAC based stream identification, and you can
> emulate HSR, or you can do something that encompasses both source node
> information as well as destination node information.
>=20
> It's one whole degree of freedom more flexible, plain and simple.
> And the topologies are not limited to:
> - the rings that HSR supports
> - the disjoint IP networks that PRP supports
> but are rather generic graphs.
>=20
> I fully expect there to be hardware out there already that can convert
> between the HSR/PRP frame format on one set of ports to 802.1CB frame
> format on another set of ports. Maybe that's something that some thought
> needs to be put into.

And Xiaoliang, can you PLEASE remove the following email addresses from
further submissions you make:
andre.guedes@linux.intel.com
vishal@chelsio.com
ivan.khoronzhuk@linaro.org
m-karicheri2@ti.com
Arvid.Brodin@xdin.com

You also copied some of them on all 6 submissions for the PSFP offload seri=
es.
It gets really annoying to get email bounces from these addresses.
I've removed them from this email thread. Thanks.=
