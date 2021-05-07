Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9512837610C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 09:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbhEGHRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 03:17:24 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:61409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232328AbhEGHRT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 03:17:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIdV+gvLWuBqNe3qgpF8m08F7+uBWV1DEora0h6gOzm4Tq6wHjTGFMYnFzhQLrAhzg5qEoVlcGKWFRCac/ZpsOtMqS+8gfTQow4IVXJqbEW2cMq0pOekxKvps1kx8qDRSO3U6WL50h+/p0SUD23eXfQPllWFeCH8HYEYLoxjQ2mryoRZnKNKwZX1fR7YexLWcJsHUQgsd0eojR+Vww2Xe2Wn1AtHpngPNgFfIfBQIbqCn0QieZ2DSfLXRBpw0K4RSBRDeB3a9zt73q5QEXz1F1t99zmuTUCIbWA/LHjCWunTXatSXjm0Ulh6Wl69PDx+OKW5+DvLN+v9n9TgyFpgQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfDz76RMVHdFcWhxST5zFW2ZMKO7X37s6oa94bk7MN4=;
 b=R+5ARHKe8Qm3Z9PdA6LWTt1Dx4O9yvBRDFr4tQ4manSPq8J/KNAFEPUOVfE23ndt4oc7RslZuSlcXmW7L1/42KjLVnrzNADZ2CT3XKE89SKY/y6c7FsLp7/EN6kkkukIlDtYMgH/WMlfTRrsPsV9UmHGQuwO9WBLoob1hkJaLaGc6qVoPwSMiVzu91IK5grgG0bdEast2Cd8GqsQuctOn3gV5A9gqPqNvQltwXcHYk0ZEObyGld4/NmsnCu18xCHtrTabSZeHUiGk0WzkMKpV9PKQpBmq6HQDENkqT7/2iRvx/7psM49kkrmw9wOzD3REgzrJHzObOrUFrPMohM6xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfDz76RMVHdFcWhxST5zFW2ZMKO7X37s6oa94bk7MN4=;
 b=Uo+npodx/92M9z76rbSvycNJGyslK2jtENCN91ruUxjzpa8MbXm7moJgmEX7fC74a7gRQyYQmrUG3bSrKqU4JGSb1jfA4IrAsBb7RE6miZiUvybPq76uo/1tBCTEo07nQrULp+peromQJQVSgXDTfIvodVy4+MTEuz063ESg4KI=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB5193.eurprd04.prod.outlook.com (2603:10a6:10:15::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28; Fri, 7 May
 2021 07:16:17 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::8403:eeba:4caf:88d6]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::8403:eeba:4caf:88d6%7]) with mapi id 15.20.4108.029; Fri, 7 May 2021
 07:16:17 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
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
Thread-Index: AQHXQS0PuJYBaI7R9kW6JDEEKsgTEqrWdByAgAEnPZA=
Date:   Fri, 7 May 2021 07:16:16 +0000
Message-ID: <DB8PR04MB5785A6A773FEA4F3E0E77698F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
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
In-Reply-To: <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c8ce14d-db9b-49a5-db89-08d911280180
x-ms-traffictypediagnostic: DB7PR04MB5193:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB51937DA18AAEB09C9D72D6E7F0579@DB7PR04MB5193.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YNCwRcZ4ay7Rq337Gp78A1YtWP9yK8tn1uJ5VHg+s00Ogta9bq2bxxHGDOuRZKMZKNINwsDDuD2FRGiH+icuCKapGd7uzwcfUQIfJspEYYpTG8Pj8tG5v/Y/JUtRhazM+QDzNpKsS5N49PkguF6hu0WfuBDJXBjhZ17FXNyWeTCaGgioxT3lR7+QkBdBFXIeM3Lsi+tBygSMgxlIsrd6bPppp8Jn2z8l9Zg+9yU/2oEblnu9Ak6bfBdrGXgqnthREOx2lYGQcN9kMHX/B94i7G5xlw4HpYw9wFmA/N59uHfK1i1nw+lyW1+K2GFrpiLdi3Unhar+fSfDZpmdXlzd1LxllUQfvMYX+G848pxnoHvefhyKan1o9o1YK4En4xWolmNokuYP1CN4V5L301xoF3dS/eED+9FIWxulDTQlRy71dwbRTHGIOK++shpegCK3tROYpVoEm5rNNlFT9rbDIBuKxh//sAnMiNGTrUj9p5AbvALvchEnER9kmxgzIii4iwZGE8zSXvXesHIm6T8AQbSZJKOxwleRUC6u1j1xcQ0/LV7PSgvVQdkgEB7Lm+Bo6W4WALD92Rw1sNQsnCisr+taoZOj3XtqlKhPo7PnZvE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(186003)(26005)(478600001)(122000001)(55016002)(66946007)(76116006)(38100700002)(8936002)(5660300002)(66556008)(52536014)(86362001)(110136005)(316002)(8676002)(54906003)(66446008)(7696005)(64756008)(83380400001)(2906002)(6636002)(33656002)(7416002)(4326008)(71200400001)(53546011)(6506007)(9686003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iRJgEyQ/Am5weipcUpZiscn1sFSjPOjq4WFoQ6EgDkqq/gTEbUG5w8JseMmM?=
 =?us-ascii?Q?h29sX0eaMceC+0G/TdYNXZ6YOeMbTFXjdWjIAa8Nklauf9dAUafdDN7FHVhL?=
 =?us-ascii?Q?XxVYW74hjjrl4FP/216RxZhE2G7eGMa+b3HkWhu3rCXWtmHrHZKQ9fYeQkL0?=
 =?us-ascii?Q?SIK6pwxD/Mv7xmPZgbw3s/e5rfqThRT1ONylEMi9RkKcZ/aLJHIpUr+MWtJ1?=
 =?us-ascii?Q?fo1R1WbmAM/2MjhKoKCQL0Ty2BTniN5XMbZ46QKpn4dfnupbwKbSnwz25XyY?=
 =?us-ascii?Q?yvWmZ73S4F5R6kxLwLHKrvSxnIsreNTyuLWPi01upnRtSpdmEa0HAN4EoVde?=
 =?us-ascii?Q?uC/rbNIuUDBxjqEzbYBdcp8yLVuewNJeJHpgbz5y15EV6sU81hGOc6rGvDPp?=
 =?us-ascii?Q?Pr1LiIOu8zZ0pWgACvYOlbPD2wh1dt0x8xbALcRmeHcr5iK11zATFKcqWBzJ?=
 =?us-ascii?Q?z/JiTdSLqm+bvEGy1xtZak2iiW25keJAV/fO5/HFNp+9fvSO7lbObN+wFOWC?=
 =?us-ascii?Q?uRy+fXuXQ3mSoa4npI4BD/j8YnYOlUHUQ15weP+zBn6rBXtZdayWORENqmtz?=
 =?us-ascii?Q?GMr49KyNN207TTZiinAQqMapKJJ8i1Xt4LQX+cJnPU99fO1nurYIorIok8aP?=
 =?us-ascii?Q?+8BVZ0vS7lBMFLQhkogUHa3ExNpePAkgUdj1NpJ41qlfcDPDC6TOe/5nQxCR?=
 =?us-ascii?Q?prCjOZwq0G026nF4H0FbCztGrrMLYPY/O0nK/PsHmcJ/i4+H1WQrEfKKDiDJ?=
 =?us-ascii?Q?l7jTBGIYxBCTl8PXPosxknCw6bqoCAHzc6wDc9SAGb+Gmu2BoIWRzdxTYgEq?=
 =?us-ascii?Q?dMgVhe8H+MhxqcRuAbnouwzaerFiiouwg7gFi8fqtIwLu0wSLtDNnBk10OiP?=
 =?us-ascii?Q?XrJxqDE0tCrzhNRAmnsBzFGjsI7mUL6NIfsGxz59zr3lgLV4Gv8uuvYkTBIP?=
 =?us-ascii?Q?k6QZc1R6LwuA4sE2A7Euy3A/oCuo07aVuthUKubJRQK512OpQaL0tj5shokR?=
 =?us-ascii?Q?SV6MtpWe26789aJnG5OQavcE1TYSvb9vqZrZX8mqXvNv4pRCJXYQb4zJ1jeE?=
 =?us-ascii?Q?nmXDtemwNq6A4WQ/eKvKg/ZhZrSMXpJwl8uqg3BbJqBwAgnJtWen2ve9tra5?=
 =?us-ascii?Q?TyrLt5lajL/f2oPTK67BKD1XV7EUv4SEVKPHEfFcpd8V0To5mQJJXEHDDHd9?=
 =?us-ascii?Q?MqEm6g7ytsh3wgCFul/r6RLFXMNL8V2klC2UFE3t+OEyLHHGIorx4549l1Gd?=
 =?us-ascii?Q?mDKbcdL7EGuJxiyJ/aLayOTeR2dYZhiqw7d+FW+BmC0SOVjCNkD268pMYAha?=
 =?us-ascii?Q?lVq/fhyUPwYeLGfXpa6R+C1L?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8ce14d-db9b-49a5-db89-08d911280180
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 07:16:17.0182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nh35EXFs551pqmmCXn/Vz7FtsTALsIEoT4UJQRxaRqvEgcSGSl+4lG4dlGFMPMciZvFaL4Vc09KlcuTjjYv+LzHQ14f8OyMhVYtX1biqqVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5193
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On 2021-05-06 21:25, Michael Walle <michael@walle.cc> wrote:
> Am 2021-05-04 23:33, schrieb Vladimir Oltean:
> > [ trimmed the CC list, as this is most likely spam for most people ]
> >
> > On Tue, May 04, 2021 at 10:23:11PM +0200, Michael Walle wrote:
> >> Am 2021-05-04 21:17, schrieb Vladimir Oltean:
> >> > On Tue, May 04, 2021 at 09:08:00PM +0200, Michael Walle wrote:
> >> > > > > > > As explained in another mail in this thread, all queues
> >> > > > > > > are marked as scheduled. So this is actually a no-op,
> >> > > > > > > correct? It doesn't matter if it set or not set for now. D=
unno why
> we even care for this bit then.
> >> > > > > >
> >> > > > > > It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the
> >> > > > > > available throughput when set.
> >> > > > >
> >> > > > > Ahh, I see now. All queues are "scheduled" but the guard band
> >> > > > > only applies for "non-scheduled" -> "scheduled" transitions.
> >> > > > > So the guard band is never applied, right? Is that really
> >> > > > > what we want?
> >> > > >
> >> > > > Xiaoliang explained that yes, this is what we want. If the end
> >> > > > user wants a guard band they can explicitly add a "sched-entry
> >> > > > 00" in the tc-taprio config.
> >> > >
> >> > > You're disabling the guard band, then. I figured, but isn't that
> >> > > suprising for the user? Who else implements taprio? Do they do it
> >> > > in the same way? I mean this behavior is passed right to the
> >> > > userspace and have a direct impact on how it is configured. Of
> >> > > course a user can add it manually, but I'm not sure that is what
> >> > > we want here. At least it needs to be documented somewhere. Or
> >> > > maybe it should be a switchable option.
> >> > >
> >> > > Consider the following:
> >> > > sched-entry S 01 25000
> >> > > sched-entry S fe 175000
> >> > > basetime 0
> >> > >
> >> > > Doesn't guarantee, that queue 0 is available at the beginning of
> >> > > the cycle, in the worst case it takes up to <begin of cycle> +
> >> > > ~12.5us until the frame makes it through (given gigabit and 1518b
> >> > > frames).
> >> > >
> >> > > Btw. there are also other implementations which don't need a
> >> > > guard band (because they are store-and-forward and cound the
> >> > > remaining bytes). So yes, using a guard band and scheduling is
> >> > > degrading the performance.
> >> >
> >> > What is surprising for the user, and I mentioned this already in
> >> > another thread on this patch, is that the Felix switch overruns the
> >> > time gate (a packet taking 2 us to transmit will start transmission
> >> > even if there is only 1 us left of its time slot, delaying the
> >> > packets from the next time slot by 1 us). I guess that this is why
> >> > the ALWAYS_GUARD_BAND_SCH_Q bit exists, as a way to avoid these
> >> > overruns, but it is a bit of a poor tool for that job. Anyway,
> >> > right now we disable it and live with the overruns.
> >>
> >> We are talking about the same thing here. Why is that a poor tool?
> >
> > It is a poor tool because it revolves around the idea of "scheduled
> > queues" and "non-scheduled queues".
> >
> > Consider the following tc-taprio schedule:
> >
> >       sched-entry S 81 2000 # TC 7 and 0 open, all others closed
> >       sched-entry S 82 2000 # TC 7 and 1 open, all others closed
> >       sched-entry S 84 2000 # TC 7 and 2 open, all others closed
> >       sched-entry S 88 2000 # TC 7 and 3 open, all others closed
> >       sched-entry S 90 2000 # TC 7 and 4 open, all others closed
> >       sched-entry S a0 2000 # TC 7 and 5 open, all others closed
> >       sched-entry S c0 2000 # TC 7 and 6 open, all others closed
> >
> > Otherwise said, traffic class 7 should be able to send any time it
> > wishes.
>=20
> What is the use case behind that? TC7 (with the highest priority) may alw=
ays
> take precedence of the other TCs, thus what is the point of having a dedi=
cated
> window for the others.
>=20
> Anyway, I've tried it and there are no hiccups. I've meassured the delta
> between the start of successive packets and they are always ~12370ns for =
a
> 1518b frame. TC7 is open all the time, which makes sense. It only happens=
 if
> you actually close the gate, eg. you have a sched-entry where a TC7 bit i=
s not
> set. In this case, I can see a difference between ALWAYS_GUARD_BAND_SCH_Q
> set and not set. If it is set, there is up to a ~12.5us delay added (of c=
ourse it
> depends on when the former frame was scheduled).
>=20
> It seems that also needs to be 1->0 transition.
>=20
> You've already mentioned that the switch violates the Qbv standard.
> What makes you think so? IMHO before that patch, it wasn't violated.
> Now it likely is (still have to confirm that). How can this be reasonable=
?
>=20
> If you have a look at the initial commit message, it is about making it p=
ossible
> to have a smaller gate window, but that is not possible because of the cu=
rrent
> guard band of ~12.5us. It seems to be a shortcut for not having the MAXSD=
U
> (and thus the length of the guard band) configurable. Yes (static) guard =
bands
> will have a performance impact, also described in [1]. You are trading th=
e
> correctness of the TAS for performance. And it is the sole purpose of Qbv=
 to
> have a determisitc way (in terms of timing) of sending the frames.
>=20
> And telling the user, hey, we know we violate the Qbv standard, please in=
sert
> the guard bands yourself if you really need them is not a real solution. =
As
> already mentioned, (1) it is not documented anywhere, (2) can't be shared
> among other switches (unless they do the same workaround) and (3) what am
> I supposed to do for TSN compliance testing. Modifying the schedule that =
is
> about to be checked (and thus given by the compliance suite)?
>
I disable the always guard band bit because each gate control list needs to=
 reserve a guard band slot, which affects performance. The user does not ne=
ed to set a guard band for each queue transmission. For example, "sched-ent=
ry S 01 2000 sched-entry S fe 98000". Queue 0 is protected traffic and has =
smaller frames, so there is no need to reserve a guard band during the open=
 time of queue 0. The user can add the following guard band before protecte=
d traffic: "sched-entry S 00 25000 sched-entry S 01 2000 sched-entry S fe 7=
3000"

I checked other devices such as ENETC and it can calculate how long the fra=
me transmission will take and determine whether to transmit before the gate=
 is closed. The VSC9959 device does not have this hardware function. If we =
implement guard bands on each queue, we need to reserve a 12.5us guard band=
 for each GCL, even if it only needs to send a small packet. This confuses =
customers.

actually, I'm not sure if this will violate the Qbv standard. I looked up t=
he Qbv standard spec, and found it only introduce the guard band before pro=
tected window (Annex Q (informative)Traffic scheduling). It allows to desig=
n the schedule to accommodate the intended pattern of transmission without =
overrunning the next gate-close event for the traffic classes concerned.

Thanks,
Xiaoliang
