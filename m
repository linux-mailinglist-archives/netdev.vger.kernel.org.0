Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440883731F4
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 23:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhEDVd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 17:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhEDVd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 17:33:59 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on0614.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1e::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F7EC061574;
        Tue,  4 May 2021 14:33:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0e7q6Z+owFkx1F8hRKZ/pHIiioo6qGxUZT5AshMTZ0i5GoPZGCF52CyBMGQWoewx5pfUxLJtJMFhSZJp8RNWH2oeK54ApLZbRD2GOAnRAnWVuRdJOgA6gwUz4txoL4r9x44WIn39kBg2ZD+XrVNB3CLB3MEA+LyefWD54KVO7r6MXXUzlQvNlwiykpbhD2D6tCVjKCbDAGP8+VL/uRj5qToiAa0CJB8cAz28u8ZiVyPGQKZ2MknxKuEeL0kCEK73ZmOXU6ZBVC3FrDWDTBqH4pGSGvnxNBrGoRT9ntIMWtD7bROoNQVKxdAFZ8FJGTvn3iE6OjcfrexW3HtAz4ahg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmwkJHo2PkYhKDi43/6W0+vEP9Hl73r6aMyfVpSNTqo=;
 b=WDazq8UDeUT4laEAbVx5GIPBnZ2kKdbCQoG49A1C8TQo+WXUarMiZvk4Ha4aGVnNFTBCweGC/M13yubHNfLLexniII/jsQF6j9V7jPlniGrOxeGQdo+EBcvw5h3SLX6BuszkRPdAGvR5NQC1+aD0CD5bj/tAnq/ZPqKPu7RM+drVsnhNiY3zaxYoEYkMfthV77yxH/m1AlUB58+xPkW9Tzj1mqWT/VjdXAtmonAnA6l2DK9Dl1kNwHwBXehYiBiVKbv8JZIuMyk9AI5SAKc0KlEp5ElVZGgfLCarBwVq+GZyF16gUeyuBYzJ+FOcjD65JoP3TydQkO8BFFf5diR2GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmwkJHo2PkYhKDi43/6W0+vEP9Hl73r6aMyfVpSNTqo=;
 b=ldZh0JsySDwMaJQEUAyBQP6PGyh8Ov7vjOXTIvXB0XVtLLwsrtrueOzAquraIyBIJ4/hWoU7AraCAU1tYgNbHzhzLcWCZk/tQWWDZ/CyjyO87D1HjuCjg3ayMRjFhRHUcpnqctTAlM4bIorz2FK1+yylnb8Bo6BMkllmSgWBn2k=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.35; Tue, 4 May
 2021 21:33:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 21:33:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS
 config
Thread-Topic: [net-next] net: dsa: felix: disable always guard band bit for
 TAS config
Thread-Index: AQHXNQV6MaXTJHA0EU+NCfdT047Zd6rTpUEAgAAUfICAAAWSgIAAA2cAgAAE2ACAAAKygIAAEk+AgAATgYA=
Date:   Tue, 4 May 2021 21:33:00 +0000
Message-ID: <20210504213259.l5rbnyhxrrbkykyg@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
In-Reply-To: <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.127.41.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e43fe896-769f-47b1-1371-08d90f443117
x-ms-traffictypediagnostic: VI1PR04MB6016:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB601614C3E4CD4FFC235C5CA2E05A9@VI1PR04MB6016.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jw51q7CiXeGjPGeqdIxKYcAzg0aoZe3XWseXhvHQ0ddypReUXUM9J7CbXI7iwZynLYCjISD7g6kgvNd8QeF3TXG9gMkEjpewWz3MWzdz4/CwptgF+qlzSITaZGjFse48I9rNj81iifewGa7aHAUeZ6swANfPV5qbyTk7K2JlLaERxyXzjoES3TivDZlpolbA8YnAcTnP4x4Yw7kCN5rV71+5WPI9HRQ1KJN/yHos7Zyx+U9wEervPdDc0Hj97RdXrFXPl6Y64Vsl8fL8GqNnHUDfcEpB5uUdHdsZYYAhP8J8mqCjlIcg7JskP3WIqrBgpukYcLrKFOIJjB6m/Q7wOs3k2xIDRQlwnO85TRSzqpIQQlJT+WhF34L+eDLWheSIoJwn7KHHPCib9sWlgU0d/Q4g8V/5HgfCXGS6pnPtONg/XcBcn0kikZz1VEACBHUC4DsUvT4OHg8UWJSZZuffTGj2ReWuQoIX5B6vPO16XvQiX62pkiM+nNfOk/J2qmIKXLFW3NPgf+DeICXjIGPmKBdEAr6xerkj1hbOOnU1RmiXIy1XtgKWzLQ2FivYNM2au/Ia+LstONt0avg0UMsyoDdpM0ubrr3TLzWbK8wLhTc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(366004)(39860400002)(376002)(136003)(396003)(6506007)(64756008)(66556008)(86362001)(7416002)(44832011)(71200400001)(66476007)(122000001)(4326008)(66946007)(76116006)(66446008)(5660300002)(8676002)(6512007)(8936002)(9686003)(38100700002)(26005)(6916009)(83380400001)(186003)(316002)(33716001)(1076003)(54906003)(478600001)(6486002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3DpOJEuLI1hBuqZx9A2nvSddapn0mFhBHi16d5ubgfmVa1j9mtGIXvzwRVZd?=
 =?us-ascii?Q?jJks7SKrGVRTXtSI778GuXqgNOLng9nEE8jVHsy0iXok/qHHBGFEomk/WWOL?=
 =?us-ascii?Q?jBO7HzjaDYDN961waHiLXVTkM0unazYsGoqlSLBhpZ7EzKWNJX2vR94Q+ibO?=
 =?us-ascii?Q?0lJaJ+aNg4VhM2QhQCn+qqpck3ZiwxV2NiQ+WZryeJ2O3y1BTtyaam1zoN+U?=
 =?us-ascii?Q?SVR5KSHnQgPHZv7nqiP9rT5mu9fZ+Phv2MWYjrKmtJDv3C9Z5iGftC8XbjT4?=
 =?us-ascii?Q?/2dWAW8tnVDF/QjvswSHOuvutD4BNDWrE8F+GsL3Ro1pJTmTn6IQATCH8sM2?=
 =?us-ascii?Q?ZyNy97xldu9F7em2vwlNOU7RcpdFpIC6WLhhoAJy1UfZPEc56fIkHVQao1dE?=
 =?us-ascii?Q?SQBqpDmp5XnTQE2Tdsta2W7LNmHRzEXCgYzfxWbs5Bx8AfEB66+/jIFEaEpY?=
 =?us-ascii?Q?HfU7eGSYzxiauhfWu+6KWe1Sw99bEcuov+WQiOH6KdqTl/nua1mRMq96TB5n?=
 =?us-ascii?Q?rqxiac+PGQXlx1RYpGM+J18O28vrCO2iLTp/9bsBWjV8r5POg0yXbDnCIPEg?=
 =?us-ascii?Q?6+9R4qiRzCEwt30+q9hHNcBa8QKCSo7qJu7DYA/TRktKiI/i+xIFPNV2+YuF?=
 =?us-ascii?Q?TSVSzsmZUtoyndmRUDQWyrR/U4ziz1BJTp0oGdVh70zz9LAM2IYx3VeMs/VG?=
 =?us-ascii?Q?kD/rufoY8nP0psPM+ADy1hmD/SrG52HPbV5ai3ddk7Dl6CY1lnbbHbPl1DoG?=
 =?us-ascii?Q?CnFje8XGz1N542jUGb5ioWRs4zgqAkCnAOLa3mcprw1Z7yGhFVANTy9GxKxk?=
 =?us-ascii?Q?nNlfc1glLWKpFPwGXNOx8mAOfq9UYLB1OCLamW3JW9M1K6wNbz+XOjnseim6?=
 =?us-ascii?Q?Ee0MtDGgyGOUIxkZMEKf2SnywfG359aSScigfzvn6lrDhcZAfa5WnkS9Ekkw?=
 =?us-ascii?Q?mOcLMnnRUnwlqPemG98aRwWxXg409NKS5qGiWOtu3bYa7OfAfoukq4nbB/Nw?=
 =?us-ascii?Q?ypWv13Ek2+7zBmz1RhQ7oiGu37YKFYKU+dxzBcSnwCbqsqEVhzuCD1r547uu?=
 =?us-ascii?Q?uygrSp/c819mTaMQvnKiz0IDoa6UjuKLNP5ZsQ3vYLetbpuskSFmfB88DFgk?=
 =?us-ascii?Q?Wm2XHjBK0W8sm903/irZPfy1A/stDfh1Ja8r3w2OM7Luog6UNPk6EoSQYPeN?=
 =?us-ascii?Q?OQNoIo+5O7hVXvgufDVyQxdfdci0c/lX21Ni/miRYbrTXMjQ905pwhyh/mZf?=
 =?us-ascii?Q?pIT+jxUgmdyo8FAOvvfokz9ATsZSgrdpjDcyoVIqX6GxRAkWS/dJVnoRecL7?=
 =?us-ascii?Q?6uM7/yBF1AXZBhuedjg5gGR8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1A18000EA60C9C4AA768EA3867047092@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e43fe896-769f-47b1-1371-08d90f443117
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2021 21:33:00.3975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /znIgBk+plJtsUZF2rb/vuh8eheLubS99c6/q4OJgcBzDVfcCO3iD/l3d9IHwhBT9GjlkYo1BJhTnNSsE5qjtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ trimmed the CC list, as this is most likely spam for most people ]

On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
> Am 2021-05-04 21:17, schrieb Vladimir Oltean:
> > On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
> > > > > > > As explained in another mail in this thread, all queues are m=
arked as
> > > > > > > scheduled. So this is actually a no-op, correct? It doesn't m=
atter if
> > > > > > > it set or not set for now. Dunno why we even care for this bi=
t then.
> > > > > >
> > > > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the availabl=
e
> > > > > > throughput when set.
> > > > >
> > > > > Ahh, I see now. All queues are "scheduled" but the guard band onl=
y
> > > > > applies
> > > > > for "non-scheduled" -> "scheduled" transitions. So the guard band=
 is
> > > > > never
> > > > > applied, right? Is that really what we want?
> > > >
> > > > Xiaoliang explained that yes, this is what we want. If the end user
> > > > wants a guard band they can explicitly add a "sched-entry 00" in th=
e
> > > > tc-taprio config.
> > >=20
> > > You're disabling the guard band, then. I figured, but isn't that
> > > suprising for the user? Who else implements taprio? Do they do it in
> > > the
> > > same way? I mean this behavior is passed right to the userspace and
> > > have
> > > a direct impact on how it is configured. Of course a user can add it
> > > manually, but I'm not sure that is what we want here. At least it
> > > needs
> > > to be documented somewhere. Or maybe it should be a switchable option=
.
> > >=20
> > > Consider the following:
> > > sched-entry S 01 25000
> > > sched-entry S fe 175000
> > > basetime 0
> > >=20
> > > Doesn't guarantee, that queue 0 is available at the beginning of
> > > the cycle, in the worst case it takes up to
> > > <begin of cycle> + ~12.5us until the frame makes it through (given
> > > gigabit and 1518b frames).
> > >=20
> > > Btw. there are also other implementations which don't need a guard
> > > band (because they are store-and-forward and cound the remaining
> > > bytes). So yes, using a guard band and scheduling is degrading the
> > > performance.
> >=20
> > What is surprising for the user, and I mentioned this already in anothe=
r
> > thread on this patch, is that the Felix switch overruns the time gate (=
a
> > packet taking 2 us to transmit will start transmission even if there is
> > only 1 us left of its time slot, delaying the packets from the next tim=
e
> > slot by 1 us). I guess that this is why the ALWAYS_GUARD_BAND_SCH_Q bit
> > exists, as a way to avoid these overruns, but it is a bit of a poor too=
l
> > for that job. Anyway, right now we disable it and live with the
> > overruns.
>=20
> We are talking about the same thing here. Why is that a poor tool?

It is a poor tool because it revolves around the idea of "scheduled
queues" and "non-scheduled queues".

Consider the following tc-taprio schedule:

	sched-entry S 81 2000 # TC 7 and 0 open, all others closed
	sched-entry S 82 2000 # TC 7 and 1 open, all others closed
	sched-entry S 84 2000 # TC 7 and 2 open, all others closed
	sched-entry S 88 2000 # TC 7 and 3 open, all others closed
	sched-entry S 90 2000 # TC 7 and 4 open, all others closed
	sched-entry S a0 2000 # TC 7 and 5 open, all others closed
	sched-entry S c0 2000 # TC 7 and 6 open, all others closed

Otherwise said, traffic class 7 should be able to send any time it
wishes.

With the ALWAYS_GUARD_BAND_SCH_Q bit, there will be hiccups in packet
transmission for TC 7. For example, at the end of every time slot,
the hardware will insert a guard band for TC 7 because there is a
scheduled-queue-to-scheduled-queue transition, and it has been told to
do that. But a packet with TC 7 should be transmitted at any time,
because that's what we told the port to do!

Alternatively, we could tell the switch that TC 7 is "scheduled", and
the others are "not scheduled". Then it would implement the guard band
at the end of TCs 0-6, but it wouldn't for packets sent in TC 7. But
when you look at the overall schedule I described above, it kinds looks
like TCs 0-6 are the ones that are "scheduled" and TC 7 looks like the
one which isn't "scheduled" but can send at any time it pleases.

Odd, just odd. It's clear that someone had something in mind, it's just
not clear what. I would actually appreciate if somebody from Microchip
could chime in and say "no, you're wrong", and then explain.

> > FWIW, the ENETC does not overrun the time gate, the SJA1105 does. You
> > can't really tell just by looking at the driver code, just by testing.
> > It's a bit of a crapshoot.
>=20
> I was speaking of other switches, I see there is also a hirschmann
> switch (hellcreek) supported in linux, for example.
>=20
> Shouldn't the goal to make the configuration of the taprio qdisc
> independent of the switch. If on one you'll have to manually define the
> guard band by inserting dead-time scheduler entries and on another this
> is already handled by the hardware (like it would be with
> ALWAYS_GUARD_BAND_SCH_Q or if it doesn't need it at all), this goal
> isn't met.
>=20
> Also what do you expect if you use the following configuration:
> sched-entry S 01 5000
> sched-entry S fe <some large number>
>=20
> Will queue 0 be able to send traffic? To me, with this patch, it seems
> to me that this isn't always the case anymore. If there is a large packet
> just sent at the end of the second cycle, the first might even be skipped
> completely.
> Will a user of the taprio (without knowledge of the underlying switch)
> assume that it can send traffic up to ~600 bytes? I'd say yes.

Yeah, I think that if a switch overruns a packet's reserved time gate,
then the above tc-taprio schedule is as good as not having any. I didn't
say that overruns are not a problem, I just said that the ALWAYS_blah_blah
bit isn't as silver-bullet for a solution as you think.=
