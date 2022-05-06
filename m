Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B8651DFA6
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390894AbiEFTey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbiEFTex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:34:53 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10072.outbound.protection.outlook.com [40.107.1.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069943B2A9;
        Fri,  6 May 2022 12:31:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkOWv9NUb50my5xmfxGVqld4e0zYBQd1XL/Rc6eR4p9wKFAq3N3aaOZEJUUlyfRSIA2JEBji/8ryG+EDhftrGODcO9rudxBI5DtXYO2FDu3LbdfX8JQNXbS4ekHXvyFapMF9YCRX6Sm0E5CJM1Pr2W2TX5htBenMRambrOh0rNslcy8FLSEKJDX9SG2rzPHBoiKr2Q3HMjvl77BIFlbrmW149B2YtswNPzckwqSU5iVieZ6nNBno0J4leISpfIuwf3F3pZcwV3vWxYCWQXMuT3vY5WH54dQLg6g1haGzXQ0006ZVq3/yS00eRl3maiC/24TNzvtzy8uzuzX0tWd/jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jaGLyF4iecthlep5mJeAooOKkFWnkskX6oygzILeGdE=;
 b=lUGGHumsyYjwka+r1Szy//loYEzY/V08eiwrinty7aK2OjSwiZSZQiCePT4RwYAJ681rRWVu2LxbTgGi3bA+Mtx0jWAxqhrENr861o8UNi5fcNPlKubhOK3ntttubkKJc1ZrvDJl3F+7vHYOMiZIl3ZI23XOFWudQ6NQRm4mnho/jVdFFvbhBDvppvPQOxP0b/Qg4NAikPr/Sjah5rsN5tOAJFwb0P4gIalk7OkidLCH040UIvpkeS108IKmBAJi3ocbfPh1m9REd8YrSaOQO3m0D+vsi0bv5Po9w+QxQWrXH1lPRW7A99n99AmnFBdoiAu6HOMbBk9qCdpTtzYsCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaGLyF4iecthlep5mJeAooOKkFWnkskX6oygzILeGdE=;
 b=IYRGJ2q31+BXQHwxoZAsQWe5JtOk1UlC5iNRD/j1Z5GiSptICdTDFfYOjZ54z8fZ0ZxQpjINAPl9BmeQKmcWe69QnT/1EIwuigNkm/vF5MYuhAdYmmgPKi+38gTWq6AJLcLrSodlyToDeODn3ecM6OfgJgubSBNQhiMnAlU01rw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB9329.eurprd04.prod.outlook.com (2603:10a6:10:36f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Fri, 6 May
 2022 19:31:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5227.018; Fri, 6 May 2022
 19:31:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        =?iso-8859-1?Q?Bal=E1zs_Varga_A?= <balazs.a.varga@ericsson.com>,
        Janos Farkas <Janos.Farkas@ericsson.com>,
        "moldovan@tmit.bme.hu" <moldovan@tmit.bme.hu>,
        =?iso-8859-1?Q?Mikl=F3s_M=E1t=E9?= <mate@tmit.bme.hu>
Subject: Re: [RFC, net-next] net: qos: introduce a frer action to implement
 802.1CB
Thread-Topic: [RFC, net-next] net: qos: introduce a frer action to implement
 802.1CB
Thread-Index: AQHXtFznyGH2JvuT50mNvd/a5fV2Ja0TF8IAgAAHuQCAACdRgIAAUB+A
Date:   Fri, 6 May 2022 19:31:03 +0000
Message-ID: <20220506193103.hla2jlpawn6te5cl@skbuf>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <df67ceaa-4240-d084-7ba1-d703f0c38f33@ericsson.com>
 <20220506122334.i7eqt2ngbfwqlrwn@skbuf>
 <ef5ef65f-0410-2d0a-dff4-4f4421e34fb1@ericsson.com>
In-Reply-To: <ef5ef65f-0410-2d0a-dff4-4f4421e34fb1@ericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ac17635-8293-4078-0abf-08da2f96f5c2
x-ms-traffictypediagnostic: DB9PR04MB9329:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <DB9PR04MB93294531CF70E86DF5CAC109E0C59@DB9PR04MB9329.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p7Bz8RWodFW8dt/LxppMs1YaCNayCy99xL5eTUzzZbiqjVDP9MeiEF7/lWMykoSrPBybSxPjZLm7hJhALuK26huaf7naX19tXY4QAJ1RqB7vOmZ+R/4EzB6e6kmPkAa63BGqqC9R0Zov/v6JDx7RXNoZEVLEICk+PYMwO0afeJVtcf2q8nqf5yzpfEpf/MF9BWT+kGibwt3eTQwckQ/DmfcZVtO6qJS37vazhW29wOsWj8myPhzT8SF1okggpXMf+b2qGapnmfPppg7sKBuE0A0wDMMdQj/EJYvvFaFSI4CLEht4RWSyKoVlEo5iGIT9UG689du3QXHeW/v27KlKwAAseu45sly/GhrWGZ5IZYq6IpKPkmW8d9mCBSVVlY1ptNXqXAF63vu6TFQx51CNzSc+nd1Q2L29bqCu+B2YIFC8nlhr+Em5RhRVRhj3IzicVOqe4zCv1xOab3ac6n0LVODWrkf3OETPAGAsamKc6QS7+wIiUjD2AMe5zrBH2Q4IiMClOmY3HBEpPe2czb2k743ilwXRvykhOa1wnxGe4rrmfNRa6c7zFESDbw95XMzLhyEonx+26F5oVJMKoaVb+SZktsNTYP0h4+adT2LM38GGnRFDURkmQxhxXlprEpl/AalqGYabN1LB26pSFMUgzfl7BDwXhNFzjLuacJLVjjqVeVdir8u3pz3/GzSDLtAnOzYil/dM4vlx/+WRgVgYXT2zW97E3YPDqrvYAjmd3v6MnXHj+dwXnfHSo8ELUq1p8O1XtKjChhu4F8okpiVxFPV/j+/G7WkgAnBf7voEEiU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38100700002)(38070700005)(1076003)(33716001)(83380400001)(86362001)(122000001)(66476007)(71200400001)(8676002)(64756008)(66556008)(66946007)(76116006)(66446008)(4326008)(91956017)(8936002)(186003)(2906002)(316002)(5660300002)(6486002)(7416002)(508600001)(6512007)(44832011)(9686003)(6916009)(26005)(30864003)(54906003)(6506007)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?cEyq1XTiHWf4NW/I59D+HYwHRaaqAngLgjg6Ex4ju7uBHOIB5okwWgSQ5x?=
 =?iso-8859-1?Q?x6l1UhoeD9HzUeoksWqPCTRGjTQf0R/ddmi5e1qLCZdn7pWCQsYltt51jT?=
 =?iso-8859-1?Q?2MozosOYgMtWdukzxDzCq0Ec0pmn5M4cca8NqEWiK1/Dmp+51Bo8dWmPUG?=
 =?iso-8859-1?Q?L63jCwnIJGmKYsUjI16mZUAhNY0xQdzsapHy86plvXt1qnxjQjKWzBtrQ0?=
 =?iso-8859-1?Q?qiXb3mfYM+/WM+T+SQHw/VZF2uFZPZcqai0BDy9cy2HDGuI6F8+9edXfJc?=
 =?iso-8859-1?Q?Wt6qF6e8ot3Di0mxPZZgszgfBz+wFpvV8I8CB/5kFVgudaPCR4P8F8KL1q?=
 =?iso-8859-1?Q?85uFzxQK2normmstnhY6Fk3bxLsSa7LUBU6B9VuU6YLetNp9zyfLCAnSH3?=
 =?iso-8859-1?Q?9q9gkX0eqmDUx28rvsTJuA3xanwvuomRiVR4V/al7yP3EGBpfp4BbV4eK4?=
 =?iso-8859-1?Q?K0BFzuLF+ciPE4gKviap+d+dW+yo82P97Fu7CkB1sfeode6kiL1kKGCsm1?=
 =?iso-8859-1?Q?NlyEpy5D9GBzSKzXYW5cEeAbwpdWVLW1sTBoZMYbv/rqozi7cVRP3O5Jhh?=
 =?iso-8859-1?Q?Y2XRoYj4zHazH/DJ+dCQ/1uwtnZzXMrOk5QALDkNJfvwHPnSVjvuxhdHgC?=
 =?iso-8859-1?Q?Qqhi6Fy6O9Rczphm6TS3yNZO7l/H11Zri6TVmI8oPh31csDvdu1HxDYrpI?=
 =?iso-8859-1?Q?1fGp4Lb6xL8vvqj9RhpoRcG85mLhaX2a6UMkR0iUhTF+Q4JdJDQIUpHfI2?=
 =?iso-8859-1?Q?B2FN1dHlHUe5lIVoFTSugS7Dz/c3G7O8Rgc8XYy0i2EkvK0dRoVPwcCFFq?=
 =?iso-8859-1?Q?aOujQJu2iYnGF0vRZhNrZ72UwLuDM5cSrK8nkXjpSUFfzU6EtR/7trB9hB?=
 =?iso-8859-1?Q?M+SwlO2HmXBgK8AAYw8vpbEYKq7GQjtnk08FKwPRcEpFmExvHszrEF+5ci?=
 =?iso-8859-1?Q?tsZrcdFJRgSAFDkp9C7vbdAJdlQWe+SsSkdjuG2MgZC4KM9UBlrrZVWO0+?=
 =?iso-8859-1?Q?4RRCKu5NqiKVanU7Qg5NoLc5xEuYCjQeLggJHK4JbquV35reVuSmqDfoiV?=
 =?iso-8859-1?Q?q7/m/GMsbxn7OGKv/01PTLMQtn32ltwrYs3cHOKWsXAhmB4UVpKIkAMhzk?=
 =?iso-8859-1?Q?pMqz7GVyBEG1HrMCozv0TRmKSoAXjrhmx9j/kPUjU6cwUcJHinGDQMZY4m?=
 =?iso-8859-1?Q?uSo/bGh6e3xFutfm61POOkTTZcit99ihA3xLyJjbSxfd90iRRNWK7yqgcx?=
 =?iso-8859-1?Q?jUn7uUKMVXiGt5rLNtwyxb90uHelWX+xQHPWYFEXEMlK6D8Aets/+8B7TZ?=
 =?iso-8859-1?Q?Aka56EkgEfnmM8uCurJH0VIgBug8UC53UpH9dw+rn989WRO83JO2yf0/Dx?=
 =?iso-8859-1?Q?EJOxhW/RxL8fXWztb7tGtU9OVDKXblOqEPYIfwc22agUgApb1woTil2NcI?=
 =?iso-8859-1?Q?BlzY6eHXPSgRsZzpERsE08cTuHPrPiEJQOb2MSVaYZAeKduoTbnkAB524K?=
 =?iso-8859-1?Q?MfdArpJzQHRWZxE1BohhekAdYxLbovjgrNYUhtHdD1OEbjsFDZA4C5/Zem?=
 =?iso-8859-1?Q?8EqumecYGx4PmpYD/RRzS63cOFSio/T8rDdwVrV9CoPfkiYqjtqB+my9IF?=
 =?iso-8859-1?Q?6/qwdi4mlPTS2M/UY4hQx4jOyUTjLLv+TfnXwTuMEOGQqqpNWomZ5hyzve?=
 =?iso-8859-1?Q?Up+TfdlxwZdF+6Dmqgrcwbhzizpedx+Rq0GelG1g2W4v+eVQ3uzjiutTjA?=
 =?iso-8859-1?Q?YvhumhCTbWqivHBxsSvNxY/dUQde1D5GRp1JQROCC50Mv8lkq/0mL+fdBv?=
 =?iso-8859-1?Q?MaLnnhinsYVZgQPMD3F3Tteu9wk3cFw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <B61DC245C87F704899186144C6A4E798@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac17635-8293-4078-0abf-08da2f96f5c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 19:31:04.0456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1tlLWQW519ePjEE8Ie2NIG6N1HuzSdolLYVvRPjCc0N1tUA0Lk9vXn5oKU428Kmy3CMHV9kytAWmzwV2xPbG3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9329
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 02:44:17PM +0000, Ferenc Fejes wrote:
> > Glad to see someone familiar with 802.1CB. I have a few questions and
> > concerns if you don't mind.
>=20
> I CCd Balazs Varga=A0 and Janos Farkas, experts of the TSN topics
> including 802.1CB as well. Istvan Moldovan's can also give valuable
> feedback as the author of our in-house userspace FRER. I'll also try my
> best to answer but I'm the least competent in the topic.
>=20

Nope, that would probably be me ;)
I am commenting on Xiaoliang's patch without having even run it, and I
have only looked through the code diagonally, and I'm not exactly an
expert on the use cases that drove the standard either. So plenty of
chances to make mistakes. But nonetheless I hope that by explaining to
me where I'm wrong we'll be able to make progress with this.

> >
> > I think we are seeing a bit of a stall on the topic of FRER modeling in
> > the Linux networking stack, in no small part due to the fact that we ar=
e
> > working with pre-standard hardware.
> >
> > The limitation with Xiaoliang's proposal here (to model FRER stream
> > replication and recovery as a tc action) is that I don't think it works
> > well for traffic termination - it only covers properly the use case of =
a
> > switch. More precisely, there isn't a single convergent termination
> > point for either locally originating traffic, or locally received
> > traffic (i.e. you, as user, don't know on which interface of several
> > available to open a socket).
> >
> > In our hardware, this limitation isn't really visible because of the wa=
y
> > in which the Ethernet switch is connected inside the NXP LS1028A.
>=20
> We have some NXP LS1028As as well so at least I familiar with the box :-)

Cool, this means we'll eventually reach a common understanding of the
topic.

> > It is something like this:
> >
> >    +---------------------------------------+
> >    |                                       |
> >    |           +------+ +------+           |
> >    |           | eno2 | | eno3 |           |
> >    |           +------+ +------+           |
> >    |              |         |              |
> >    |           +------+ +------+           |
> >    |           | swp4 | | swp5 |           |
> >    |           +------+ +------+           |
> >    |  +------+ +------+ +------+ +------+  |
> >    |  | swp0 | | swp1 | | swp2 | | swp3 |  |
> >    +--+------+-+------+-+------+-+------+--+
> >
> > In the above picture, the switch ports swp0-swp3 have eno3 as a DSA
> > master (connected to the internal swp5, a CPU port). The other internal
> > port, swp5, is configured as a DSA user port, so it has a net device.
> > Analogously, while eno3 is a DSA master and receives DSA-tagged traffic
> > (so it is useless for direct IP termination), eno2 receives DSA untagge=
d
> > traffic and is therefore an IP termination endpoint into a switched
> > network.
>
> Unfortunately I'm not familiar with the distributed switch architecture
> (I only read a netdev paper from that and thats all) but I try to grasp
> on the problem.
> In my understanding, the main issue is the distinction between the
> locally terminated and forwarded TSN streams, because currently the DSA
> metadata tags are required to do that? Can you explain the problem for
> one who not familiar with DSA?

Forget about DSA, what I'm trying to get at is that you might one day
read the release notes of the Linux kernel and see that it gained
support for FRER using tc, and get all excited, download and compile it,
set up 2 machines connected through 2 port pairs, and try to configure
the systems to ping each other redundantly, to become familiar with how
it works. Start with something simple, what can be so hard about a ping ;)

You'll say something along the lines of

1. ok, I have 2 IP addresses, so I need 2 streams, one A -> B and one B -> =
A

2. I want to use the null stream identification function (MAC DA, VLAN ID
   for those following along) so I have to resolve each IP address to a
   MAC address to use as a stream identifier, but how? since the 2
   Ethernet cards on each system have different MAC addresses. Anyway,
   pick one and put the other card in promisc for now.

3. I have the MACs now, I want to configure the streams. The stream "A -> B=
"
   needs to be configured for splitting on the first system, and for
   sequence recovery on the second system. The stream "B -> A" needs to
   be configured for recovery on the first system and for splitting on
   the second.

4. Let's start with splitting, this is just the "mirred egress mirror"
   action, nothing FRER specific about it. There's also the "frer rtag
   tag-action tag-push" action which adds the redundancy tag. Good thing
   these actions can be chained. So let's put a filter on the egress
   qdisc of eth0, that matches on the MAC address of B, and has a mirred
   mirror action to eth1, and a "rtag tag-push" action. Notice how by
   this time, eth0 becomes sort of a "primary" interface and eth1 sort
   of a "secondary" interface. So if you ping, you need to use eth0.
   What if the link goes down on eth0 you ask, how does the "redundancy"
   in "frer" come into play, with the traffic still going through eth1?
   No time to ask questions like that, let's move on.

5. Let's say that both links are up, and system B is receiving a
   replicated stream with FRER tags on both eth0 and eth1. It wants to
   eliminate the duplicates and see a continuous flow of ICMP requests
   without the extra FRER tag. Back to the documentation. We see 2 kinds
   of stream recovery, one is "individual" recovery which is a
   "frer rtag recover" action put on the ingress qdisc of an interface,
   and the other is just "recovery", which is the same action but put on
   the egress qdisc. We don't want individual sequence recovery processes
   on eth0 and eth1 of station B, since those won't consider the packets
   as being members of the same stream, and the'll still be duplicated.
   So we want the normal recovery. But on whose netdev's egress qdisc do
   we put the "rtag recover" action? Both eth0 and eth1 are receiving.
   There is no central convergence point.

Now you're stumped and thinking, how is this supposed to be used?
What can you do with it? I mean, I can probably create a veth pair as
that aforementioned missing convergence point, and guide packets from
{eth0, eth1} towards the lefthand side of the veth pair, using mirred
redirect.
Then I can put the frer rules on the egress qdisc of the lefthand side
of the veth pair, and recover the plaintext traffic (no duplicates, no
RTAG) on the righthand side of the veth pair. But... seriously?
And there is not even one mention of this in the documentation?
And even so. You need to send the request through eno0 and expect to
receive the reply through a veth interface? How is any user space
application ever going to work?


Now comes the connection with DSA. Xiaoliang made tc-frer with LS1028A
offloading in mind. No criticism there, after all it is the hardware we
are working with.

The intended usage pattern is to put the FRER rules on the switch port
netdevices, and to do the termination on the switch-unaware netdevices.
In other words, it's as if eno2 is connected to a completely external
RedBox, and tc-frer only serves externally received traffic. Except that
those 2 isolated parts of the system are physically embedded in one.

So at step (1) you put the IP on eno2, at step (2) you choose the MAC
address for the stream to be that of eno2, at step (4) you configure the
split action (mirred towards the external ports, plus FRER tag push) on
the _ingress_ of swp4 (traffic sent by eno2 is received by swp4).
At step (5) you put the sequence recovery on the _egress_ of swp4
(traffic that egresses swp4 ingresses eno2).

So then you might ask, what would we do if we didn't have that eno2 <->
swp4 port pair? Is tc-frer useful for someone who doesn't, but is maybe
even able to offload 802.1CB streams, including termination, through
some other paradigm? The thing is that, as far as I can tell, Linux does
not really like to set up a network for the exclusive use of others
(pure forwarding), to which it has no local access. This is essentially
the design of tc-frer, and my issue with it.

> >
> > What we do in this case is put tc-frer rules for stream replication and
> > recovery on swp4 itself, and we use eno2 as the convergence point for
> > locally terminated streams.
> >
> > However, naturally, a hardware design that does not look like this can'=
t
> > terminate traffic like this.
>=20
> Yes, this is my concern too. What would be a nice to have thing if the
> user can configure the SW implementation and the HW offload with the
> same commands and the original tc-frer approach fits well to this
> concept. Anything towards that direction is the way forward IMO, even if
> the underlying implementation will change.
> >
> > My idea was that it might be better if FRER was its own virtual network
> > interface (like a bridge), with multiple slave interfaces. The FRER net
> > device could keep its own database of streams and actions (completely
> > outside of tc) which would be managed similar to "bridge fdb add ...".
> > This way, the frer0 netdevice would be the local termination endpoint,
> > logically speaking.
>=20
> Interesting approach. To be honest I dont see the long term implications
> of this solution, others might have ideas about the pros and cons, but
> that looks like a solution where local stream termination is trivial.

The implication is that you can easily do stuff with FRER. Maybe I'm
relying too much on ping as an example, but I am really lacking real
life use cases. Feedback here would be extremely appreciated.

> > What I don't know for sure is if a FRER netdevice is supposed to forwar=
d
> > frames which aren't in its list of streams (and if so, by which rules).
>=20
> Yes this sounds correct, somehow non-local packets should be forwarded
> too with a bridge. Is it possible to the linux bridge recognize if one
> port is a frer0 port (or on the frer0 if that is enslaved) and do the
> forwarding of the streams? Re-implementing bridge functions just for the
> frer device would be redundant. Unfortunately I never dug myself deep
> enough into the linux bridge code, just when debugged VXLAN ARP
> suppression for EVPN, but I think it would be possible to exchange some
> metadatas between the bridge and the frer device to do the
> forwarding/terminating decision, something like here [0]

The other question if you're in favor of "FRER as net device" is whether
we should have a FRER interface per TSN stream (or per stream pair, RX
and TX, since streams are unidirectional), or a FRER interface for all
TSN streams. If the latter, we're moving more towards "FRER integrated
in bridge" territory. Or... maybe even resolve local termination through
some other mechanism, and still build on top of a tc-frer action.

The thing with "FRER as net device" on the other hand is that we've
already started modeling PSFP through tc. So if the FRER device has its
own rules, then "these" streams are not the same as "those" streams, and
a user would have to duplicate parts of the configuration. Whereas I
think the PSFP standard refers to stream identifiers directly from 802.1CB.

> > Because if a FRER netdevice is supposed to behave like a regular bridge
> > for non-streams, the implication is that the FRER logic should then be
> > integrated into the Linux bridge.
>
> This is (for me) more appealing. Also we can keep that in mind when
> Linux will support deterministic layer3 networking (IETF DetNet WG RFCs)
> it would be nice to have mapping between TSN and DetNet streams, then
> forward the packets on DetNet tunnels as well (with different
> endpoints). This is something our team researching so Balazs and Istvan
> might give you some info about that. But I admit that thinking about
> playing nicely with DetNet in regard of the current linux FRER
> implementation is more than overwhelming, but the Linux bridge would be
> a nice place to map TSN flows to DetNet flow like currently EVPN maps
> VLANs to VXLANs.

So what would be the use case for bridging packets belonging to
unrecognized TSN streams? In my toy setups I almost ran out of ideas how
to drop unwanted traffic and prevent it from being looped forever.
STP, MSTP, MRP are all out the window, this is active redundancy, you
need to embrace the loops, so it isn't as if you can pretend that
something sane is going to happen with a packet if it isn't part of a
stream that gets special handling from 802.1CB. No broadcast, no
multicast, and self address filtering on all switch ports.

> > Also, this new FRER software model complicates the offloading on NXP
> > LS1028A, but let's leave that aside, since it shouldn't really be the
> > decisive factor on what should the software model look like.
> >
> > Do you have any comments on this topic?
> I would like to see if others can join to the discussion as well, I will
> try to think about this problem more too.
>
> [0] https://lore.kernel.org/netdev/20220301050439.31785-10-roopa@nvidia.c=
om/
>
> Best,
> Ferenc=
