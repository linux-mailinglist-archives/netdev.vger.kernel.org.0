Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02607534C87
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 11:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346399AbiEZJap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 05:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbiEZJao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 05:30:44 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70085.outbound.protection.outlook.com [40.107.7.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF20C8BD3;
        Thu, 26 May 2022 02:30:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eH1J1E41LSRwjoOuTROsz88sgahYngkkLHNetS97YjsTDZ2Ghb8n2hQOq1fW4/P6A1kW2v+bDkR3g4rNioVTGiUARc8pw3d4zVlt0vQ0Ef8TyNFOy6UwB0eCyXb4JGJnRDDpSNMC2TZPKd6VlJlI1t3vTZMwLPaWD0HOkMwQaJzDW9oo1XbBif62WAwf907PoJS7pyXwi3Sg1p1e9ItcKgQApgru5Ek3AuyNSiXBiJ4UnKEZyhk6I/tCYX8ULNzZtTPRuCQIlXmBWkqdteGd/lBVc1m52yQUB2QKFl2V9rAH4bB+tfpALRgnzJTIAYXIfelfhjB5/ia83EPJXTSX8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHJUHAhGE+euFU6uYDWG3Ig9R1RPXbQaKg1R+PoSsrE=;
 b=iRJEXmN857oK0d04xHd8vzgqqGM7WxTMlFJpaHPhm+ichDBEwU3HdL9hnoqhV8BlDYc0dL4FATyeQJpItzHL2KEu7d+MA7lVAABInkXfcbGIrNKl7Oa8GUSpYPpfcxOehxpTdRCZfW0B7JTTO4C1w8j/iJW6ac68oMpH1EvIljRyTbiesUPzKK57+3e7vnToswdc06Yy/zXeM71g33N16XijOP5wZangyARHHun1+afpPc3yA7BmepGRyg13kGTJUHFaoF2wj5hh5gvIXl43sIf67ZShZCvY9lwpfYb7n1zZ0k9LzzgGOT8lJCHyLos/OzHIHow+hn0GmF/86SQS9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UHJUHAhGE+euFU6uYDWG3Ig9R1RPXbQaKg1R+PoSsrE=;
 b=BfUmk4jfGN3szc/5OiefcVZtviRjJAefz6HR8kakHNQuEVggzTRFwF0MUksCmRmI44qSFFiUY145bvhYVcIe+PYiQWWQoeNN/Q2keTYmKDhlAB+ojQ8GXKHPtTidnxqfi1GTNwJVxCV8CaXbaZeKiEG62oojrxkHWmOAzzOM2lM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7329.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 09:30:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Thu, 26 May 2022
 09:30:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, "jiri@nvidia.com" <jiri@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Topic: [PATCH v2 net-next] selftests: forwarding: add Per-Stream
 Filtering and Policing test for Ocelot
Thread-Index: AQHYXU7ReS+uKz5es0qSAulr7qr8960RgRAAgABGeICAAAZagIAerKeAgABhywCAAC+QAA==
Date:   Thu, 26 May 2022 09:30:37 +0000
Message-ID: <20220526093036.qtsounfawvzwbou2@skbuf>
References: <20220501112953.3298973-1-vladimir.oltean@nxp.com>
 <302dc1fb-18aa-1640-dfc7-6a3a7bc6d834@ericsson.com>
 <20220506120153.yfnnnwplumcilvoj@skbuf>
 <c2730450-1f2b-8cb9-d56c-6bb8a35f0267@ericsson.com>
 <20220526005021.l5motcuqdotkqngm@skbuf>
 <cd0303b16e0052a119392ed021d71980db63e076.camel@ericsson.com>
In-Reply-To: <cd0303b16e0052a119392ed021d71980db63e076.camel@ericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 169fbe28-1e19-421a-07a1-08da3efa64ba
x-ms-traffictypediagnostic: AM8PR04MB7329:EE_
x-microsoft-antispam-prvs: <AM8PR04MB73295FC1874BB65D86225C84E0D99@AM8PR04MB7329.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pebSiakdGyuKGQ1IkHtJP0Bhy5DPI71YdC+VnYORzE3aIDfBGieR0MEDjjHZEMQUdLpKBRbnX4V84JjrbtWqNweY91k1/7ubff8WAQsrlnPvCbIQ8YEBuBB8NgJDfarNpStzRedGrCd51z2adycQqjk6j3323IG1hNLDDggv1Z72Kf/L9DVDK5hWTmx4IA1Ob0RJSBTdNYjrusZU6moaFFI8OQTHASuoVfs3L87Q+hVdwK75uCPuvMPpvHsW6MniFbFxyrUHCz7hF3l9xL2aEVlfW0eBOCJfOSbgIQxTFi1nyMMvaNOlKfITbz0LMfEl7ZzajtYHJfN1WPX+pEDLWEJLyid9zBsP3ivwLbOVZMmeBkgrvSkvumB6H+FIoxCNY58LAs6TL1FoBa+ryNmiO6WilWOAXAiz3i4r/QkmY1NiONaNy5UDsLFXfV+wLVtl9k8AeuC9ueotrKRVnW1I/DT3L3eWP4SehisaAHJZhU2Kk2lZ6RqlMMPmRVYX+ASXDLX7d3058OY2ZnRzOitUdObTNVzl67lzmir3O/JQC32zC8r9iMj5i4uYG5QWlTYjSKzm4jvYzrgHeULptw8hlw2aRA7g/ooA9HMiXztM33o7gqPltIhIi1EIWcLiBdGse+40gg8uW5mQ/GLyC226o+xicFYH737YpEKw9S2iVplbl7hrPapdw2gbJYad7GFPY/mUNec50wxCrWVsWIvlyYfD14jTenrSY8CIXCnA1HcZLXGo5Dx5YMOSFzE9QmefCOWfZW7DZdHqr9FajPrGV1XgZ8TB+ET8TYoafVH0JrM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38100700002)(5660300002)(7416002)(38070700005)(508600001)(66556008)(4326008)(91956017)(66446008)(64756008)(66476007)(8676002)(44832011)(83380400001)(66946007)(76116006)(71200400001)(9686003)(6512007)(30864003)(1076003)(6506007)(26005)(53546011)(316002)(6486002)(2906002)(33716001)(8936002)(122000001)(54906003)(6916009)(186003)(966005)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iYvUlmcNrc69CYnvQzrYH1Dci5jG8CQFVCriGuezp12CaNmmmdn/Dyy+XQV6?=
 =?us-ascii?Q?279bcnAQCMa4/ef3rHJP5Gp5yIT3wKX7hUCdk7PtfjhEdfg9gHcGm7vkUrWe?=
 =?us-ascii?Q?BylwOHPqFAQMNsFvfQNyelKnGMXlGg4ynfT82rVR4zR12SIEH2kzwPYvnVk5?=
 =?us-ascii?Q?LOZQDSMUir24g8hGmSD2SqC1Zkpjv1Y3k+6MMJH/UTwPfPESbwD7ZINJ3xEl?=
 =?us-ascii?Q?po7WVLRIOjOJpdaiv9vMb3KQTESDQOI0sfqBqrldVXGqDBujS37BWFkhVtms?=
 =?us-ascii?Q?wv3fENRWEGztRTBzSTlgLbzs7NVpMR01j/4sqwfWthKd1C8GzVTcGLTkdDXx?=
 =?us-ascii?Q?P6OYU2Gxj8+QLCFHdc1KQkuBEv3Io0aJC4H4DDyl90uvbhr9zdvBRk79MXbD?=
 =?us-ascii?Q?1+xS7myGyM3Qgiuc3x/NN3z8eLw/Ks2GfwWqQhK0r4qrEk+N5klflYee15IF?=
 =?us-ascii?Q?kGJ10dLWgrASnm6H2DXxTARwyWBYaqPAh0JP6yV0CtPvcN3gvj7gVd2xtf08?=
 =?us-ascii?Q?eCddvc2QFtGEJ1Pspw/QmimYoaWkzz/VniShr8smzYa3vQy0pRIOPiVvd55+?=
 =?us-ascii?Q?EpclP+hAym7KFne/qLIXvajFfFJgHeHxlqsKazn4wCY+tEMJQFlhpGsQq7SC?=
 =?us-ascii?Q?g9+cMoe1VGWr3OLRICIihfQRWqxnKfMc1WH579ucTPME+hLfnPVkVMlaiVNG?=
 =?us-ascii?Q?sms99PlETsKlHOt5QEDgqB4zplI+NpuEuVYO7E0Pex0mg7b22r5Rzz4jsfw8?=
 =?us-ascii?Q?6X5WuIeRIXbO73WqThItOQEx7CJ5LKujLtOFZ1XVDmiNK4sr0xSSInUbDH+3?=
 =?us-ascii?Q?IlUmJpO6d8KRQENUde5JISo7UeSG0LW9fUxS9OOCKpwsD1r0NIxCTyeZ0PIn?=
 =?us-ascii?Q?MEH79IwWJVpLnf1ZqdS23oqMwpSOdtorFcEkCO8NchwqajWX/j8G6s8+Wu/5?=
 =?us-ascii?Q?25JDklWWwugp/TFJh0r2sfNvRHv3iUCBv7NPYFqFuwENPBGSKZH+Z2CUClx1?=
 =?us-ascii?Q?JqTiqsFADiq98FAdN1XRJptg9zgAQecLlDx9ftxUayugqGMXnAM+IiHR4H15?=
 =?us-ascii?Q?jwnvkjziH0wBDxwFIv/B2xoHH7h0U4OznUbnKmlqxyJOL3ujNQluLtdo0LdX?=
 =?us-ascii?Q?9T1PB4vw2XjXR2obRzNbhKS2q9Mmb5C1CEf65unTczBpwcQgN2hN26+dVKsA?=
 =?us-ascii?Q?w1cUi5WBla6qzD/AaifnAVu/yv3rHK0QywWBBG9Rv5VgLKl+QJVAcvWq5Jl7?=
 =?us-ascii?Q?Ua2Aza8XS+zdTJZhhFJ90skTnhsbBIWemYqUiqs+r1VbtfK+J1NDhF4nO+U7?=
 =?us-ascii?Q?P4TDeZ6o9DZx6O+jKGLBIMphuBFLjfVhs0N5SYBTTmjeS0py8hzrZBTjOnzS?=
 =?us-ascii?Q?LQxw8H9S8yXZHSChVZ0n47ONk7vuKyjsqrnzzeXSpDk1uywawtTQRNJxFTt3?=
 =?us-ascii?Q?O0x/uqadoFIKX3pQLg9mTWXOIAS/7c7IYzHAtt/lSKBlxmtyey7aiw08Jwq6?=
 =?us-ascii?Q?bXh2ccS6sck7JHHpIXJ1nkhiLm+3M4C0527VktYBipQwLbi8GWAkZ4tTwfkP?=
 =?us-ascii?Q?nOKCm4xXmsInCXSsyJ8PZe8PcrborM0t5N4ejxTTvvSfu9+BQTZB7CYHUKPh?=
 =?us-ascii?Q?7QIFrARNoESAbBnHs3o/q7lpzWYs6ETrhXLnBJ9P90rKoFsGk6NMziaUwTZK?=
 =?us-ascii?Q?mYcA6vuk22i6705ZGpix+sADqVDCWcFNxFdG/VTMVPYNW60eC3yegGPnKH1q?=
 =?us-ascii?Q?/KM5MSe8rd7p07AjvrWo0Bjd9exTFGk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A4EC23AE17E87459C0F6907A5DA6C7B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169fbe28-1e19-421a-07a1-08da3efa64ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2022 09:30:37.8380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DWHzOuj+5JuTsB0DzcelEuepAvZrTEMNOqhuIEPgZ4wQee/xWVUTPAfioxz/e8fS73odQo6ZD981SmUfkaGzvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7329
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 06:40:22AM +0000, Ferenc Fejes wrote:
> Hi Vladimir!
>=20
> On Thu, 2022-05-26 at 00:50 +0000, Vladimir Oltean wrote:
> > On Fri, May 06, 2022 at 12:24:37PM +0000, Ferenc Fejes wrote:
> > > Hi Vladimir!
> > >=20
> > > On 2022. 05. 06. 14:01, Vladimir Oltean wrote:
> > > > Hi Ferenc,
> > > >=20
> > > > On Fri, May 06, 2022 at 07:49:40AM +0000, Ferenc Fejes wrote:
> > > > This is correct. I have been testing only with the offloaded tc-
> > > > gate
> > > > action so I did not notice that the software does not act upon
> > > > the ipv.
> > > > Your proposal sounds straightforward enough. Care to send a bug
> > > > fix patch?
> > >=20
> > > Unfortunately I cant, our company policy does not allow direct=20
> > > open-source contributions :-(
> > >=20
> > > However I would be more than happy if you can fix it.
> >=20
> > That's too bad.
> >=20
> > I have a patch which I am still testing, but you've managed to
> > captivate
> > my attention for saying that you are testing 802.1Qch with a software
> > implementation of tc-gate.
> >=20
> > Do you have a use case for this? What cycle times are you targeting?
> > How are you ensuring that you are deterministically meeting the
> > deadlines?
>=20
> The cycle times I targeted were nowhere near to a realistic TSN
> scenario:
> I "generated" ping packets in every 100 msecs and on the ingress port
> and I marked them with prio 1 for 500ms (gate 1) and prio 2 for another
> 500ms (gate 2). On the egress port I applied taprio with the same base-
> time and same 500-500ms cycles but reverse ordered gates (that's the
> "definition" of the Qch), so while act_gate on the ingress is in gate 1
> cycle, the taprio kept open gate 2 and gate 1 closed, etc.
> For "verification" I simply run a tcpdump on the listener machine what
> I pinged from the talker and eyeballed wether the 5-5 packets bursts
> shows up arrival timestamps.
>=20
> > Do you also have a software tc-taprio on the egress device or is that
> > at least offloaded?
>=20
> No, I experimented with the software version, but that worked with my
> netns tests and on physical machines too (after the IPV patch).
>=20
> >=20
> > I'm asking these questions because the peristaltic shaper is
> > primarily
> > intended to be used on hardware switches. The patch I'm preparing
> > includes changes to struct sk_buff. I just want to know how well I'll
> > be
> > able to sell these changes to maintainers strongly opposing the
> > growth
> > of this structure for an exceedingly small niche :)
>=20
> Can you tell me about the intention behind the sk_buff changes? Does
> that required because of some offloading scenario? In my case putting
> the IPV into the skb->priority was good enough because the taprio using
> that field by default to select the traffic class for the packet.
>=20
> Thanks,
> Ferenc
>

Hopefully this patch explains it:

-----------------------------[ cut here ]-----------------------------
From c8d33e0d65a4a63884a626dc04c7190a2bbe122b Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Wed, 25 May 2022 16:27:52 +0300
Subject: [PATCH] net/sched: act_gate: act on Internal Priority Value

IEEE 802.1Q specifies in Annex T ("Cyclic queuing and forwarding") the
use case for an Internal Priority Value set by the PSFP function.
Essentially, the intended use is to be able to select a packet's egress
queue squarely based on its arrival time. Essentially, this means that a
packet with the same VLAN PCP 5 can be delivered to TC 7 or 6 depending
on whether it was received in an "odd" or "even" cycle. To quote the
spec, "The use of the IPV allows this direction of frames to outbound
queues to be independent of the received priority, and also does not
affect the priority associated with the frame on transmission."

The problem is that the software implementation of act_gate takes the
IPV as entry from user space, but does not act on it in its software
implementation - only offloading drivers do.

To fix this, we need to keep a current_ipv variable according to the
gate entry that's currently executed by act_gate, and use this IPV to
overwrite the skb->priority.

In fact, a complication arises due to the following clause from 802.1Q:

| 8.6.6.1 PSFP queuing
| If PSFP is supported (8.6.5.1), and the IPV associated with the stream
| filter that passed the frame is anything other than the null value, then
| that IPV is used to determine the traffic class of the frame, in place
| of the frame's priority, via the Traffic Class Table specified in 8.6.6.
| In all other respects, the queuing actions specified in 8.6.6 are
| unchanged. The IPV is used only to determine the traffic class
| associated with a frame, and hence select an outbound queue; for all
| other purposes, the received priority is used.

An example of layer that we don't want to see the IPV is the egress-qos-map
of a potential VLAN output device. Instead, the VLAN PCP should still be
populated based on the original skb->priority.

I'm aware of the existence of a skb_update_prio() function in
__dev_queue_xmit(), right before passing the skb to the qdisc layer,
for the use case where net_prio cgroups are used to assign processes to
network priorities on a per-interface basis. But rewriting the
skb->priority with the skb->ipv there simply wouldn't work, exactly
because there might be a VLAN in the output path of the skb.

One might suggest: just delay the IPV rewriting in the presence of
stacked devices until it is actually needed and likely to be used,
like when dev->num_tc !=3D 0 (which VLAN doesn't have). But there are
still other uses of skb->priority in the qdisc layer, like skbprio,
htb etc. From the spec's wording it isn't clear that we want these
functions to look at the proper packet user priority or at the PSFP IPV.
Probably the former.

So the only implementation that conforms to these requirements
seems to be the invasive one, where we introduce a dedicated
helper for the pattern where drivers and the core ask for
netdev_get_prio_tc_map(dev, skb->priority). We replace all such
instances with a helper that selects the TC based on IPV, if the skb
was filtered by PSFP time gates on ingress, and falls back to
skb->priority otherwise.

Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")
Reported-by: Ferenc Fejes <ferenc.fejes@ericsson.com>
Link: https://lore.kernel.org/netdev/87o80h1n65.fsf@kurt/T/#meaec9c24b3add9=
cb11edd411278a3a6ecf01573e
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 include/linux/netdevice.h                     | 13 +++++++++++++
 include/linux/skbuff.h                        | 11 +++++++++++
 include/net/tc_act/tc_gate.h                  |  1 +
 net/core/dev.c                                |  4 ++--
 net/dsa/tag_ocelot.c                          |  2 +-
 net/sched/act_gate.c                          |  6 ++++++
 net/sched/sch_taprio.c                        | 12 +++---------
 8 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/et=
hernet/intel/ixgbe/ixgbe_main.c
index 77c2e70b0860..719259af9aaa 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8531,7 +8531,7 @@ static u16 ixgbe_select_queue(struct net_device *dev,=
 struct sk_buff *skb,
 	int txq;
=20
 	if (sb_dev) {
-		u8 tc =3D netdev_get_prio_tc_map(dev, skb->priority);
+		u8 tc =3D skb_get_prio_tc_map(skb, dev);
 		struct net_device *vdev =3D sb_dev;
=20
 		txq =3D vdev->tc_to_txq[tc].offset;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 47b59f99b037..8b87d017288f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2366,6 +2366,19 @@ int netdev_set_prio_tc_map(struct net_device *dev, u=
8 prio, u8 tc)
 	return 0;
 }
=20
+static inline int skb_get_prio_tc_map(const struct sk_buff *skb,
+				      const struct net_device *dev)
+{
+	__u32 prio =3D skb->priority;
+
+#if IS_ENABLED(CONFIG_NET_ACT_GATE)
+	if (skb->use_ipv)
+		prio =3D skb->ipv;
+#endif
+
+	return netdev_get_prio_tc_map(dev, prio);
+}
+
 int netdev_txq_to_tc(struct net_device *dev, unsigned int txq);
 void netdev_reset_tc(struct net_device *dev);
 int netdev_set_tc_queue(struct net_device *dev, u8 tc, u16 count, u16 offs=
et);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index da96f0d3e753..b0a463c0bc65 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -913,6 +913,9 @@ typedef unsigned char *sk_buff_data_t;
  *	@csum_start: Offset from skb->head where checksumming should start
  *	@csum_offset: Offset from csum_start where checksum should be stored
  *	@priority: Packet queueing priority
+ *	@use_ipv: Packet internal priority was altered by PSFP
+ *	@ipv: Internal Priority Value, overrides priority for traffic class
+ *		selection
  *	@ignore_df: allow local fragmentation
  *	@cloned: Head may be cloned (check refcnt to be sure)
  *	@ip_summed: Driver fed us an IP checksum
@@ -1145,6 +1148,10 @@ struct sk_buff {
 	__u8			slow_gro:1;
 	__u8			csum_not_inet:1;
=20
+#ifdef CONFIG_NET_ACT_GATE
+	__u8			use_ipv:1;
+#endif
+
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
 #endif
@@ -1209,6 +1216,10 @@ struct sk_buff {
 	/* only useable after checking ->active_extensions !=3D 0 */
 	struct skb_ext		*extensions;
 #endif
+
+#ifdef CONFIG_NET_ACT_GATE
+	__u32			ipv;
+#endif
 };
=20
 /* if you move pkt_type around you also must adapt those constants */
diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
index c8fa11ebb397..b05c2c7d78e4 100644
--- a/include/net/tc_act/tc_gate.h
+++ b/include/net/tc_act/tc_gate.h
@@ -44,6 +44,7 @@ struct tcf_gate {
 	ktime_t			current_close_time;
 	u32			current_entry_octets;
 	s32			current_max_octets;
+	s32			current_ipv;
 	struct tcfg_gate_entry	*next_entry;
 	struct hrtimer		hitimer;
 	enum tk_offsets		tk_offset;
diff --git a/net/core/dev.c b/net/core/dev.c
index 721ba9c26554..956aa227c260 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3194,7 +3194,7 @@ static u16 skb_tx_hash(const struct net_device *dev,
 	u16 qcount =3D dev->real_num_tx_queues;
=20
 	if (dev->num_tc) {
-		u8 tc =3D netdev_get_prio_tc_map(dev, skb->priority);
+		u8 tc =3D skb_get_prio_tc_map(skb, dev);
=20
 		qoffset =3D sb_dev->tc_to_txq[tc].offset;
 		qcount =3D sb_dev->tc_to_txq[tc].count;
@@ -4002,7 +4002,7 @@ EXPORT_SYMBOL_GPL(netdev_xmit_skip_txqueue);
 static int __get_xps_queue_idx(struct net_device *dev, struct sk_buff *skb=
,
 			       struct xps_dev_maps *dev_maps, unsigned int tci)
 {
-	int tc =3D netdev_get_prio_tc_map(dev, skb->priority);
+	int tc =3D skb_get_prio_tc_map(skb, dev);
 	struct xps_map *map;
 	int queue_index =3D -1;
=20
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 0d81f172b7a6..036e746f18eb 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -52,7 +52,7 @@ static void ocelot_xmit_common(struct sk_buff *skb, struc=
t net_device *netdev,
 	ocelot_xmit_get_vlan_info(skb, dp, &vlan_tci, &tag_type);
=20
 	qos_class =3D netdev_get_num_tc(netdev) ?
-		    netdev_get_prio_tc_map(netdev, skb->priority) : skb->priority;
+		    skb_get_prio_tc_map(skb, netdev) : skb->priority;
=20
 	injection =3D skb_push(skb, OCELOT_TAG_LEN);
 	prefix =3D skb_push(skb, OCELOT_SHORT_PREFIX_LEN);
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index fd5155274733..9fb248b104f8 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -81,6 +81,7 @@ static enum hrtimer_restart gate_timer_func(struct hrtime=
r *timer)
 	gact->current_gate_status =3D next->gate_state ? GATE_ACT_GATE_OPEN : 0;
 	gact->current_entry_octets =3D 0;
 	gact->current_max_octets =3D next->maxoctets;
+	gact->current_ipv =3D next->ipv;
=20
 	gact->current_close_time =3D ktime_add_ns(gact->current_close_time,
 						next->interval);
@@ -140,6 +141,11 @@ static int tcf_gate_act(struct sk_buff *skb, const str=
uct tc_action *a,
 		}
 	}
=20
+	if (gact->current_ipv >=3D 0) {
+		skb->use_ipv =3D true;
+		skb->ipv =3D gact->current_ipv;
+	}
+
 	spin_unlock(&gact->tcf_lock);
=20
 	return gact->tcf_action;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index b9c71a304d39..fb8bc17e38bb 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -201,7 +201,7 @@ static struct sched_entry *find_entry_to_transmit(struc=
t sk_buff *skb,
 	s32 cycle_elapsed;
 	int tc, n;
=20
-	tc =3D netdev_get_prio_tc_map(dev, skb->priority);
+	tc =3D skb_get_prio_tc_map(skb, dev);
 	packet_transmit_time =3D length_to_duration(q, qdisc_pkt_len(skb));
=20
 	*interval_start =3D 0;
@@ -509,7 +509,6 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *s=
ch)
=20
 	for (i =3D 0; i < dev->num_tx_queues; i++) {
 		struct Qdisc *child =3D q->qdiscs[i];
-		int prio;
 		u8 tc;
=20
 		if (unlikely(!child))
@@ -522,9 +521,7 @@ static struct sk_buff *taprio_peek_soft(struct Qdisc *s=
ch)
 		if (TXTIME_ASSIST_IS_ENABLED(q->flags))
 			return skb;
=20
-		prio =3D skb->priority;
-		tc =3D netdev_get_prio_tc_map(dev, prio);
-
+		tc =3D skb_get_prio_tc_map(skb, dev);
 		if (!(gate_mask & BIT(tc)))
 			continue;
=20
@@ -579,7 +576,6 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc=
 *sch)
 	for (i =3D 0; i < dev->num_tx_queues; i++) {
 		struct Qdisc *child =3D q->qdiscs[i];
 		ktime_t guard;
-		int prio;
 		int len;
 		u8 tc;
=20
@@ -597,9 +593,7 @@ static struct sk_buff *taprio_dequeue_soft(struct Qdisc=
 *sch)
 		if (!skb)
 			continue;
=20
-		prio =3D skb->priority;
-		tc =3D netdev_get_prio_tc_map(dev, prio);
-
+		tc =3D skb_get_prio_tc_map(skb, dev);
 		if (!(gate_mask & BIT(tc))) {
 			skb =3D NULL;
 			continue;
-----------------------------[ cut here ]-----------------------------=
