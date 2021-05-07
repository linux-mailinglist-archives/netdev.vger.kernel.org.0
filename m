Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A21937644D
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 13:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhEGLKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 07:10:33 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:19926
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234416AbhEGLK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 07:10:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NK7wIVSrXEVpzEp6hzHLjD1xIqgSYm91v5oJ8LY8HBtOz8tkp1wWiJEYxcavNKVdZ+UyWh59gCGFcx1NsgBfjTcxMc1qjFexaqTdSYP+9a74vTQUlxhIuGvBVXZOePXqwMN2Uplbjw3RLhPfx+afrYfiG1AkWIq0n9bh/H/pTL4pEADBGhvj1ihzPWEUI/Fv/LgBlh16b9HrCkbeYGtw6zYcOZ5gLNxq/ZwFwlJSs8nBvFQK4VKKxlCoa05kjh5pwRmhw/5JAy6VaX9RG5VJHFBzZ4m+ZYIqNnE5oD5+yEs8H5zFznTxjfrFopwu9JPhyxJaQO/MUHryVVLYH9rSBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0/GZX+2Tsk8zrHVZwxKQ/cWgHbBWpGJzjRVKNHsH1Q=;
 b=mtLct+4JGMDGfK47fLUmCVOp/e1Xd/71w7UihyZEC6YHz3iGJyo8sUzW+OwuZo6UBTmgP5vS5cQUXbaJJQMmwdRuTgEtzVORu9v+nGlSn9KBIf9hKryUsES4QrX2s8Vz0kso9+OmGZYdbVHpZOxgnRR11qAfMBmEbbAbP6of4Ngrif/LQVDQ9qrAjwxd1cSa6BoiAGribpxxDAuYduSd3uOP5n+/hpRK/OezIPx/RevMAN43wPcyQrzeFWxKY34Ajb98GibxkNrmPbci+5ubtrGCldngroD9fJYKeclvKZBHbwV/3jMKAAu3wLAMa9JraLzbzocJB4fiGcNomMim9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0/GZX+2Tsk8zrHVZwxKQ/cWgHbBWpGJzjRVKNHsH1Q=;
 b=qCjjDRLTwaO47l2iZoL8IxGQaZdev77KZXMhTl/xiKyXn7Z4YabM9h2ni5l8VNhMzKWMSvTP5EvgUPW+ZpEruQAl/m6LtFJkQHBhZ/CbSDEvEaVZE0+TH72u8neR4gec4S+utxVOUyTdsQ80iKV1lcwEpNa+8LADcCatf8bP5L4=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB6345.eurprd04.prod.outlook.com (2603:10a6:10:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Fri, 7 May
 2021 11:09:25 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::8403:eeba:4caf:88d6]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::8403:eeba:4caf:88d6%7]) with mapi id 15.20.4108.029; Fri, 7 May 2021
 11:09:25 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Subject: RE: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Thread-Topic: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Thread-Index: AQHXQS0PuJYBaI7R9kW6JDEEKsgTEqrWdByAgAEnPZCAAAlTAIAADhQg
Date:   Fri, 7 May 2021 11:09:24 +0000
Message-ID: <DB8PR04MB5785D01D2F9091FB9267D515F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
 <20210504181833.w2pecbp2qpuiactv@skbuf>
 <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
 <20210504213259.l5rbnyhxrrbkykyg@skbuf>
 <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
 <DB8PR04MB5785A6A773FEA4F3E0E77698F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <2898c3ae1319756e13b95da2b74ccacc@walle.cc>
In-Reply-To: <2898c3ae1319756e13b95da2b74ccacc@walle.cc>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cf258ae-3fe2-4ca3-3150-08d911489309
x-ms-traffictypediagnostic: DB8PR04MB6345:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB63458B6DFCA82AADB370B1FDF0579@DB8PR04MB6345.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e9ELD/ZoD2hTOp96qbTUln5T/kZUBbyDVYMP5376RDs1JvgD50L9kVPEqKm3ATxHchXrur6iowu5pzjsj9d6cUZIJoYzb7ZQSfnFyHrkDpPipuJpAzA17ubMg2gd3t40yDwdeHEiiDx8UVDXhVAg0JdFPkzJ2tFNjOHGOz+NVEizwuWxA0bnzjo52HyLYnVH4cekz/2mDO+CcCGOAtM0Jm32eN9SwTUyFkCJuJfqjbY02BgzlmC0b5ltiBfaxaUsqrEjDD1GJPiZ66A+Yk6FNbZLqv1kkdnP6Dhyhr7YUnt9OgMcf3fCRaAbF+wuxHqr8iUumlNuIc8yRrzezCF3reFGrLehgUer2Q7qBza0Wx2D2/Bcl4kvcPx3RsECtQ7tOopaCJC35/2aZkHebtGCEHDFNQmOh5RToKCx90EFiIjPbE5oLXPQzgydjKiEsTYC8xrQC/pRH45Tr3DIkN4xO/APOm6BOSC2QIxlEheAwGRIS8K5JTljcaTNfgkQgInV2bDkN2LbN54iuDyee1msjmOTZ40BvI8qVaN5ANd8F+Nr97moFmdF6m6DiZDnUtGrNadNDvlhbPyaOTxbf5kS5SVU7UmPsLkIpEnunL1DSko=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39850400004)(366004)(6506007)(122000001)(33656002)(83380400001)(38100700002)(53546011)(4326008)(8936002)(2906002)(9686003)(55016002)(7696005)(7416002)(66476007)(71200400001)(54906003)(76116006)(86362001)(186003)(26005)(478600001)(52536014)(5660300002)(6916009)(64756008)(66556008)(316002)(66446008)(8676002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LBJoFjmavfSJDPd2R2ICL4KVM7aE62oe1NJzDVRXvfwooKM/JKI8IRrNTzEI?=
 =?us-ascii?Q?ZOvd+qNmwNW8603HE2+CRayZY3brgpdyXWVHWN+F58NKJEnONUjGTEHb4kPo?=
 =?us-ascii?Q?6insQG2qcTSXfXNR7tnWZn/RUiZT4wIKZ1YmeHZJjozQtBCHo0Ay45ERnLwx?=
 =?us-ascii?Q?W8qjhSTCw+mwJFb4gtuKd8A13G0uIFgdWdd3hGX9Rm6q42mBVs1Dvoh7jdHi?=
 =?us-ascii?Q?MSBSBxOkJtDJrnRoN11L8NMvMwharBTG5qItNwCTIfDmAtIDd2Rc9gBtpW3J?=
 =?us-ascii?Q?BGT3p+GAdHgjxWwx/EJDwHyWWGCyGwzJ6e9yJp5OEZLw6WhNqczBNzLZsrww?=
 =?us-ascii?Q?lJQWigkbv6sOa15qDjKbr0jVMS2RxDd+vtGxqszGhOjzS4odnXaXC/87Hprp?=
 =?us-ascii?Q?aO2co+Qi95PS24Rt9FzcWDQFYI4fvLKVXgLhFL2mwGroGwo7am/lzFFi7sBP?=
 =?us-ascii?Q?tf3QYme9Bn9RV+zUUu5k1UXkhAWT/am/W4HDwjsjFoHeE7bgrA5UmsRPEEii?=
 =?us-ascii?Q?+ScCpn04fveLwaosg+2ri6RYqyQfr0bXLWTKtgNgio8eq3zPNN3IstRQlwzj?=
 =?us-ascii?Q?Db/sVoiMhAKrwGuO1TTlmnQmfQiT4+6sgBoRWkfDYzhSUdWdNuY9zNRcno5G?=
 =?us-ascii?Q?XvMXr3YS0DLjQNa3vP2fOFko0H8PoluVbQ6KJxm5+YkVG1iPZLuYMQUcGirb?=
 =?us-ascii?Q?gvh//U+9aMHCX/BHbPHZ4qiu8bcJBEmxPCzp4oRl4sUzy3hI3wemGjU6A5rq?=
 =?us-ascii?Q?a//xQprP9Mwm0YplnroyBW5KOBiVg0mJ+kQb3crQ7SLX4EyjUtAMOdSOVpjo?=
 =?us-ascii?Q?zOTdR0N5OrctB1HZKfgbiEfam/PTAXkwSHDpFw7Eo/nksPFPK/+cyMdFxdJb?=
 =?us-ascii?Q?AS25aVVNZzDS0SAxY24LORRX3q4rJQpLmaV7gbvKDB4jptRAaVLH1qQa4ckP?=
 =?us-ascii?Q?Xgkso2cIQByvKVWujT2d8A/pe/EpV2RGKZ1y3AXQyJKA//aTNhyxBDaQEF3k?=
 =?us-ascii?Q?W6Zl/zBEnXGDnvvTPNqYHs435O1m4WEVZiC55u4Lfv9Ckm8r9VC+cyGmIEOv?=
 =?us-ascii?Q?np74TvmsoJO0fpNFRjFOB5cRZrh6iZU0fz515cBKL0NUQZ6/lA4wgsIfwtl1?=
 =?us-ascii?Q?r3WVegzzvuxedjkuwRp9efwEEBiE8U1mtDt6LlS90KMUUH1jn4mGEsx7Eg41?=
 =?us-ascii?Q?qH9TnUjmQ5iAfCQlXTgM4KHQvcRDkOUJ3QEVBMOw32IGDZHlzSrJx0viLy9l?=
 =?us-ascii?Q?MeqVQyo0TaLyZW5yAjic7GHAHLA4oqpGRY6a8nWYSy/CSs+5x2XMVuCn+xSZ?=
 =?us-ascii?Q?5+1ko3aswsFwtrSS7ySx5q7e?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf258ae-3fe2-4ca3-3150-08d911489309
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 11:09:25.0157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DHaMNhrCiGqHtX0cvt9LClGkv6dOStmwtIr3AQJrOgjqtg28fgeUIBZULNGG4EXQkWGRJPok8scyrLV2bX6Gc6BEqZVgIAdDL6g9YLmFM4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On 2021-05-07 15:35, Michael Walle <michael@walle.cc> wrote:
> Am 2021-05-07 09:16, schrieb Xiaoliang Yang:
> > On 2021-05-06 21:25, Michael Walle <michael@walle.cc> wrote:
> >> Am 2021-05-04 23:33, schrieb Vladimir Oltean:
> >> > [ trimmed the CC list, as this is most likely spam for most people
> >> > ]
> >> >
> >> > On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
> >> >> Am 2021-05-04 21:17, schrieb Vladimir Oltean:
> >> >> > On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
> >> >> > > > > > > As explained in another mail in this thread, all
> >> >> > > > > > > queues are marked as scheduled. So this is actually a
> >> >> > > > > > > no-op, correct? It doesn't matter if it set or not set
> >> >> > > > > > > for now. Dunno why
> >> we even care for this bit then.
> >> >> > > > > >
> >> >> > > > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the
> >> >> > > > > > available throughput when set.
> >> >> > > > >
> >> >> > > > > Ahh, I see now. All queues are "scheduled" but the guard
> >> >> > > > > band only applies for "non-scheduled" -> "scheduled" transi=
tions.
> >> >> > > > > So the guard band is never applied, right? Is that really
> >> >> > > > > what we want?
> >> >> > > >
> >> >> > > > Xiaoliang explained that yes, this is what we want. If the
> >> >> > > > end user wants a guard band they can explicitly add a
> >> >> > > > "sched-entry 00" in the tc-taprio config.
> >> >> > >
> >> >> > > You're disabling the guard band, then. I figured, but isn't
> >> >> > > that suprising for the user? Who else implements taprio? Do
> >> >> > > they do it in the same way? I mean this behavior is passed
> >> >> > > right to the userspace and have a direct impact on how it is
> >> >> > > configured. Of course a user can add it manually, but I'm not
> >> >> > > sure that is what we want here. At least it needs to be
> >> >> > > documented somewhere. Or maybe it should be a switchable option=
.
> >> >> > >
> >> >> > > Consider the following:
> >> >> > > sched-entry S 01 25000
> >> >> > > sched-entry S fe 175000
> >> >> > > basetime 0
> >> >> > >
> >> >> > > Doesn't guarantee, that queue 0 is available at the beginning
> >> >> > > of the cycle, in the worst case it takes up to <begin of
> >> >> > > cycle> + ~12.5us until the frame makes it through (given
> >> >> > > gigabit and 1518b frames).
> >> >> > >
> >> >> > > Btw. there are also other implementations which don't need a
> >> >> > > guard band (because they are store-and-forward and cound the
> >> >> > > remaining bytes). So yes, using a guard band and scheduling is
> >> >> > > degrading the performance.
> >> >> >
> >> >> > What is surprising for the user, and I mentioned this already in
> >> >> > another thread on this patch, is that the Felix switch overruns
> >> >> > the time gate (a packet taking 2 us to transmit will start
> >> >> > transmission even if there is only 1 us left of its time slot,
> >> >> > delaying the packets from the next time slot by 1 us). I guess
> >> >> > that this is why the ALWAYS_GUARD_BAND_SCH_Q bit exists, as a
> >> >> > way to avoid these overruns, but it is a bit of a poor tool for
> >> >> > that job. Anyway, right now we disable it and live with the overr=
uns.
> >> >>
> >> >> We are talking about the same thing here. Why is that a poor tool?
> >> >
> >> > It is a poor tool because it revolves around the idea of "scheduled
> >> > queues" and "non-scheduled queues".
> >> >
> >> > Consider the following tc-taprio schedule:
> >> >
> >> >       sched-entry S 81 2000 # TC 7 and 0 open, all others closed
> >> >       sched-entry S 82 2000 # TC 7 and 1 open, all others closed
> >> >       sched-entry S 84 2000 # TC 7 and 2 open, all others closed
> >> >       sched-entry S 88 2000 # TC 7 and 3 open, all others closed
> >> >       sched-entry S 90 2000 # TC 7 and 4 open, all others closed
> >> >       sched-entry S a0 2000 # TC 7 and 5 open, all others closed
> >> >       sched-entry S c0 2000 # TC 7 and 6 open, all others closed
> >> >
> >> > Otherwise said, traffic class 7 should be able to send any time it
> >> > wishes.
> >>
> >> What is the use case behind that? TC7 (with the highest priority) may
> >> always take precedence of the other TCs, thus what is the point of
> >> having a dedicated window for the others.
> >>
> >> Anyway, I've tried it and there are no hiccups. I've meassured the
> >> delta between the start of successive packets and they are always
> >> ~12370ns for a 1518b frame. TC7 is open all the time, which makes
> >> sense. It only happens if you actually close the gate, eg. you have a
> >> sched-entry where a TC7 bit is not set. In this case, I can see a
> >> difference between ALWAYS_GUARD_BAND_SCH_Q set and not set. If it is
> >> set, there is up to a ~12.5us delay added (of course it depends on
> >> when the former frame was scheduled).
> >>
> >> It seems that also needs to be 1->0 transition.
> >>
> >> You've already mentioned that the switch violates the Qbv standard.
> >> What makes you think so? IMHO before that patch, it wasn't violated.
> >> Now it likely is (still have to confirm that). How can this be
> >> reasonable?
> >>
> >> If you have a look at the initial commit message, it is about making
> >> it possible to have a smaller gate window, but that is not possible
> >> because of the current guard band of ~12.5us. It seems to be a
> >> shortcut for not having the MAXSDU (and thus the length of the guard
> >> band) configurable. Yes (static) guard bands will have a performance
> >> impact, also described in [1]. You are trading the correctness of the
> >> TAS for performance. And it is the sole purpose of Qbv to have a
> >> determisitc way (in terms of timing) of sending the frames.
> >>
> >> And telling the user, hey, we know we violate the Qbv standard,
> >> please insert the guard bands yourself if you really need them is not
> >> a real solution. As already mentioned, (1) it is not documented
> >> anywhere, (2) can't be shared among other switches (unless they do
> >> the same workaround) and (3) what am I supposed to do for TSN
> >> compliance testing. Modifying the schedule that is about to be
> >> checked (and thus given by the compliance suite)?
> >>
> > I disable the always guard band bit because each gate control list
> > needs to reserve a guard band slot, which affects performance. The
> > user does not need to set a guard band for each queue transmission.
> > For example, "sched-entry S 01 2000 sched-entry S fe 98000". Queue 0
> > is protected traffic and has smaller frames, so there is no need to
> > reserve a guard band during the open time of queue 0. The user can add
> > the following guard band before protected traffic: "sched-entry S 00
> > 25000 sched-entry S 01 2000 sched-entry S fe 73000"
>=20
> Again, you're passing the handling of the guard band to the user, which i=
s an
> implementation detail for this switch (unless there is a new switch for i=
t on the
> qdisc IMHO). And (1), (2) and (3) from above is still valid.
>=20
> Consider the entry
>   sched-entry S 01 2000
>   sched-entry S 02 20000
>=20
> A user assumes that TC0 is open for 2us. But with your change it is basci=
ally
> open for 2us + 12.5us. And even worse, it is not deterministic. A frame i=
n the
> subsequent queue (ie TC1) can be scheduled anywhere beteeen 0us and
> 12.5us after opening the gate, depending on wether there is still a frame
> transmitting on TC0.
>=20
After my change, user need to add a GCL at first: "sched-entry S 00 12500".
Before the change, your example need to be set as " sched-entry S 01 14500 =
sched-entry S 02 20000", TC0 is open for 2us, and TC1 is only open for 20us=
-12.5us. This also need to add guard band time for user.
So if we do not have this patch, GCL entry will also have a different set w=
ith other devices.

> > I checked other devices such as ENETC and it can calculate how long
> > the frame transmission will take and determine whether to transmit
> > before the gate is closed. The VSC9959 device does not have this
> > hardware function. If we implement guard bands on each queue, we need
> > to reserve a 12.5us guard band for each GCL, even if it only needs to
> > send a small packet. This confuses customers.
>=20
> How about getting it right and working on how we can set the MAXSDU per
> queue and thus making the guard band smaller?
>=20
Of course, if we can set maxSDU for each queue, then users can set the guar=
d band of each queue. I added this patch to set the guard band by adding GC=
L, which is another way to make the guard band configurable for users. But =
there is no way to set per queue maxSDU now. Do you have any ideas on how t=
o set the MAXSDU per queue?

> > actually, I'm not sure if this will violate the Qbv standard. I looked
> > up the Qbv standard spec, and found it only introduce the guard band
> > before protected window (Annex Q (informative)Traffic scheduling). It
> > allows to design the schedule to accommodate the intended pattern of
> > transmission without overrunning the next gate-close event for the
> > traffic classes concerned.
>=20
> Vladimir already quoted "IEEE 802.1Q-2018 clause 8.6.8.4". I didn't check=
 it,
> though.
>=20
> A static guard band is one of the options you have to fulfill that.
> Granted, it is not that efficient, but it is how the switch handles it.
>=20
I'm still not sure if guard band is required for each queue. Maybe this pat=
ch need revert if it's required. Then there will be a fixed non-configurabl=
e guard band for each queue, and the user needs to calculate the guard band=
 into gate opening time every time when designing a schedule. Maybe it's be=
tter to revert it and add MAXSDU per queue set.

Thanks,
Xiaoliang
