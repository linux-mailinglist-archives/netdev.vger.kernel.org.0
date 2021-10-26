Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFC943BCB2
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239706AbhJZVyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:54:22 -0400
Received: from mail-eopbgr150043.outbound.protection.outlook.com ([40.107.15.43]:56038
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237335AbhJZVyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 17:54:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWV9mkk62yUvduAeGf5oMOsYI7znVDfVW37RFIAkgRjW2ZGUhgA1xvni1H03Wejk0QR0aIoTAD4kFyrZ7WI28SG03kf1NJBT7iEJtbHiRI/TdQmW+QIYHRqcbbO1qtgS8Ip29/e75IWwQx6D4FfxXVhbS4y5a69rd+S0UKSkAMCM05F57KEY0ALsoC6Wc8/hp+xxksGu7qg0FIP+ggDeqZIumk592JeNii8a7OfuG8TLmX+wmPxSflYXGR3sLqh8Gqr8UQZNuCGYDCNe2E8KL55mCz0MkUnrINR/o5uKVotEngw66CBQBM5dxZGuJhrRTY5/xNA8U25FvAzL1Bfg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D14Qk/bqqVNou+OuhvxNqiXKrlIonoiRL+48pGtqlIE=;
 b=J9o63MbgUDIVM7kH4yjVc3HeRtNudkVj67A4OgpTm7oWvSjhdcdj/oUc2r697fwKOpzAIHz5UHnbR6Od6LTC2fFtyWoh37Nr4v2TGLuhj4SuM9QAFxzRhnDtD+iODL7pOeoq+rb0+Pad5Oio9IGbsiB2oIV/w716zJ7Um7lQBozLdmk8/d0RU90kqZKbNSawOmsyJx27S7b1i9+Slt+p0LjFABtsWOCv3/sO/tlwXWEV3nos+Lyiim41tIjDMLZdJgLQkdEcNxrY7iFZr7GS+M+74YnVBwI5/THSYQEA4T/JEbZgqeDblMpYZApjV0Rjd5LTs1iLNnlkqq5jMvKNHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D14Qk/bqqVNou+OuhvxNqiXKrlIonoiRL+48pGtqlIE=;
 b=YuP0NKn5Wnvi/jnPV7w6HkPmVOxOfxsh08IBmTzIvdnmAs6ilSFhmOtlz1cwisS+bGBylhGlyzbinbXBdE3FEGTb2swN/DY5+LTELVQVbLisFXu7sYuKlQYv9J4AJTMoz0QhNwnDGJPPq48B8HYxqRajUC+6Pi4/yGphIFm/3VU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 21:51:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 21:51:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Thread-Topic: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Thread-Index: AQHXye8TuHIQFfcKx02oYjeM7kf+xavlF9qAgAAMn4CAAA9DgIAATKgAgAAEkYCAAB75AIAAD3mAgAAgGoA=
Date:   Tue, 26 Oct 2021 21:51:54 +0000
Message-ID: <20211026215153.lpdk66rjvsodmxto@skbuf>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
 <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
 <20211026112525.glv7n2fk27sjqubj@skbuf>
 <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
 <20211026165424.djjy5xludtcqyqj2@skbuf>
 <a703cf3c-50f5-1183-66a8-8af183737e26@nvidia.com>
 <20211026190136.jkxyqi6b7f4i2bfe@skbuf>
 <dcff6140-9554-5a08-6c23-eeef47dd38d0@nvidia.com>
In-Reply-To: <dcff6140-9554-5a08-6c23-eeef47dd38d0@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9cde4c6-31aa-467b-6a96-08d998cad337
x-ms-traffictypediagnostic: VI1PR04MB5295:
x-microsoft-antispam-prvs: <VI1PR04MB529559FD4C1646243C6F8EE7E0849@VI1PR04MB5295.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wy/IxKUx/RhxziJKsYsfJUw5UsDy60vTRRrjEMtQcYhmYjnFxOg4IqAW7TIP/j7Adc1xFD/RKuFiLsSqUmqO9T0OE+1rTzplE8gviVidAzpwGCF40C8pU96VQzNrnmcX0DbOb9Hy5fSFd4yvvZscSvlN+oudg3Y7Aril2DfgIxfGT0VKXEjFD/EUhc3+3MqmZZqTKlwAn3mYoitCrjr8Unm5etZzM/SuEh+OgFusleEnWf/JPIyb2wn0sFoALmW7lRWAr0hrgBKBUvXWbf/yvmX1G5S0cl1YgOk3UFnb+Lj/cyqEnldcaB/aZpevmsmit2ZtC9lPOlxScfZZeRK98lzgkDyCzZ+OIi8Ib1jDAiZp1ViAJJnFMYVwI/CFbqJPUHVDHV3Il3uNFj7vq7u6J5X9U/d1+/ElWjObBhoR7zfMmJx9DZB9BN8X2FGS/aqNVdi9BAi+mHcuTKzOgYfj8Pq6AMrZtjZPUhVZSL2IRHIhlmptgdWx6567LsBCRsoJpAqtgkwTTSrZ8uoKlzPkrFPt/Iu40gj+9PR/RHb63r8AcWXq9fevtEWicslmwdFbqryZCN2wbN0irCtARYbRQPZcudeDh1dWp9X0ddzZIMaTz9cKAjz0n0LwwH3hDK2KhPMNK5rAN0eIGKMqM8+EJDPTCrw1Q/Blxh47Uwq/n1ohr0o8atHHBBN8+mahZW9W4nmO7XOusD38u+rqJXh8Pg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(7416002)(66476007)(38100700002)(8676002)(71200400001)(91956017)(508600001)(64756008)(66556008)(66446008)(54906003)(9686003)(5660300002)(26005)(316002)(6506007)(53546011)(122000001)(4326008)(76116006)(66946007)(30864003)(8936002)(6916009)(83380400001)(86362001)(44832011)(186003)(2906002)(1076003)(6486002)(38070700005)(33716001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iWyHRaQCo8rvfyziP+ALf1b2tYITW2hfJR94ZXZZz5B+0pOhp2GDrRv5DEO+?=
 =?us-ascii?Q?ZlJPCELdATUzIY6F9uRBc/HjfPzlTJTsBNFPfCIzVOQ8ooMKDHXF9g6HhXeS?=
 =?us-ascii?Q?+xYsbLa1zGr6R7lBHNMwVhOmOKl5gtinvdK1U+xzqFOYF2wTjpE/MWemX+L1?=
 =?us-ascii?Q?bh4Fp918Hvf7tULYW4rc/L/QkNTdaYedwoSnyv0K1mF0ePq13GM5ioGGh0V4?=
 =?us-ascii?Q?fDlAyQ3DGqzWw7h5eNKvNniuxkJI897JcRtAdPlMX3ERh1JuP9bQUkYUN361?=
 =?us-ascii?Q?I86UIpydVtvz+3s3uYY6u9/zQ5y6822OllOVXPH38QYeQ1c8yYEafW1OagdG?=
 =?us-ascii?Q?iHuXKwqVW1IEIK6Tx3XaNYz8W5/udY4S/Vy30V/mzmNT5r4D70YAnLdKs9tF?=
 =?us-ascii?Q?whjbuC74SKnXjGCkQLtb+Bk7EOpRw0Ox4z+xBwFICEIFsSB4pN90ZIKA4/fM?=
 =?us-ascii?Q?1gJly+Bokk7b8Z7l8HD5bibTvuDbGvNcOU8Zakx3h+x9TA4I9nVb+Ao4w/H5?=
 =?us-ascii?Q?daHGGdSf5a4/Zun/vk2daO2uim85yUKeoNYWc0CXsRM8qKrzl0dq/yDq5WT9?=
 =?us-ascii?Q?q9ddheyGH0eu7UWt94jSiCR+9kAqJm6I8I0N4cHAUE2pvxrUTH56HVxLWG4x?=
 =?us-ascii?Q?ywj8lQ1IG6J2v1GHRNZUm2i5x1sMv4HgS+MH2Hc3O568n02GktFycIet47Ju?=
 =?us-ascii?Q?9JSzdWfPYAHSP739dr781Mj5O+uiaGKpzaANY9mand/O1xga0LQ7Y4jTSUUs?=
 =?us-ascii?Q?tVvRzDVNIuxGUD/8e5ooEu8ebE4wcIt+OUqbiaJNsNGnUJp5BfypA+rUK8Lh?=
 =?us-ascii?Q?UbcFd6KyXSkzZu8UJ+dBDWO7ngKPzSMzFcIM1z+r4FZ4nkQe7a77ac/s3cux?=
 =?us-ascii?Q?TJrB07WMnwrSbLYNC+TiCl8vh0z8Sh+W8WqCs8R2hilRIXOnHI6AGP7VyLwK?=
 =?us-ascii?Q?b6Dm7kk28qd/h3D/9mPvJsq4/qxLae/y78feNNIYbktALBfS67V2kwDaJQB6?=
 =?us-ascii?Q?gvwAq2w6AFUv/1iEKHht42RutTDjdfuz330zN9Z/dSApPqmY8HzQYWkiAj5U?=
 =?us-ascii?Q?ACDwpVLV2q8/ukxlpLhEokMtBstOTXzAsyFBJI5pJ+l/Hy7FDsGx6I3gX8BH?=
 =?us-ascii?Q?YY4IUVNSH5B6GMs0sQshF8zWZI0facM7GWtXz0N1rK0iBBn1YSxWW90D7+EJ?=
 =?us-ascii?Q?gCshyBCNIfmgues9P6EdJLQ1tmi9g/nZ0nUlfh7lLtum6Xi34m1HaV3eda9t?=
 =?us-ascii?Q?WEsnu9TvxTUzQFLyTaMMWkSgnqaeK4xb8jW002jwJLYO4WTZ12h0y1rwOYJ7?=
 =?us-ascii?Q?RwmFKKyjSKEsQdg5GH8XDVXZWRRCPqMlgdqLKr2tPbm6GsT9PD/lXqsPo0gB?=
 =?us-ascii?Q?auyeIbreQcqeF9w/XHeNEwNxSmJ9ZNTxjIg5GzFsM4AeCXNx0sov3p7BUgrd?=
 =?us-ascii?Q?km8huuOUxcCWBYorUXGhNZbpabIw3Sr04mD/sK3fH+Ic1acpZGc1gQgmTv0i?=
 =?us-ascii?Q?0Cboh7T7ofN3PUviuPTjGGCTyA488sFc2L2whMkrep9zgWV7NzFSPWo0BovR?=
 =?us-ascii?Q?P//pTgIrfxyIFDk4m8JVMjUKRTYFwqQeXoZnRSJi7h8uNMSsbIUajBptVln3?=
 =?us-ascii?Q?Tt8UeYbK7FRPZBI18NA4vnU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5A24C022BB34A4684A332B61BDCE6C0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9cde4c6-31aa-467b-6a96-08d998cad337
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 21:51:54.2426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5x9lFSa/a+w1eoUaXjtnHLZ0ZbeR28GBushWku6FxJnF/DLnOz6nl3jy7Q0zarEBodB8ovQ6galBTZSYohQzng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 10:56:59PM +0300, Nikolay Aleksandrov wrote:
> On 26/10/2021 22:01, Vladimir Oltean wrote:
> > On Tue, Oct 26, 2021 at 08:10:45PM +0300, Nikolay Aleksandrov wrote:
> >> On 26/10/2021 19:54, Vladimir Oltean wrote:
> >>> On Tue, Oct 26, 2021 at 03:20:03PM +0300, Nikolay Aleksandrov wrote:
> >>>> On 26/10/2021 14:25, Vladimir Oltean wrote:
> >>>>> On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote=
:
> >>>>>> Hi,
> >>>>>> Interesting way to work around the asynchronous notifiers. :) I we=
nt over
> >>>>>> the patch-set and given that we'll have to support and maintain th=
is fragile
> >>>>>> solution (e.g. playing with locking, possible races with fdb chang=
es etc) I'm
> >>>>>> inclined to go with Ido's previous proposition to convert the hash=
_lock into a mutex
> >>>>>> with delayed learning from the fast-path to get a sleepable contex=
t where we can
> >>>>>> use synchronous switchdev calls and get feedback immediately.
> >>>>>
> >>>>> Delayed learning means that we'll receive a sequence of packets lik=
e this:
> >>>>>
> >>>>>             br0--------\
> >>>>>           /    \        \
> >>>>>          /      \        \
> >>>>>         /        \        \
> >>>>>      swp0         swp1    swp2
> >>>>>       |            |        |
> >>>>>    station A   station B  station C
> >>>>>
> >>>>> station A sends request to B, station B sends reply to A.
> >>>>> Since the learning of station A's MAC SA races with the reply sent =
by
> >>>>> station B, it now becomes theoretically possible for the reply pack=
et to
> >>>>> be flooded to station C as well, right? And that was not possible b=
efore
> >>>>> (at least assuming an ageing time longer than the round-trip time o=
f these packets).
> >>>>>
> >>>>> And that will happen regardless of whether switchdev is used or not=
.
> >>>>> I don't want to outright dismiss this (maybe I don't fully understa=
nd
> >>>>> this either), but it seems like a pretty heavy-handed change.
> >>>>>
> >>>>
> >>>> It will depending on lock contention, I plan to add a fast/uncontend=
ed case with
> >>>> trylock from fast-path and if that fails then queue the fdb, but yes=
 - in general
> >>>
> >>> I wonder why mutex_trylock has this comment?
> >>>
> >>>  * This function must not be used in interrupt context. The
> >>>  * mutex must be released by the same task that acquired it.
> >>>
> >>>> you are correct that the traffic could get flooded in the queue case=
 before the delayed
> >>>> learning processes the entry, it's a trade off if we want sleepable =
learning context.
> >>>> Ido noted privately that's usually how hw acts anyway, also if peopl=
e want guarantees
> >>>> that the reply won't get flooded there are other methods to achieve =
that (ucast flood
> >>>> disable, firewall rules etc).
> >>>
> >>> Not all hardware is like that, the switches I'm working with, which
> >>> perform autonomous learning, all complete the learning process for a
> >>> frame strictly before they start the forwarding process. The software
> >>> bridge also behaves like that. My only concern is that we might start
> >>> building on top of some fundamental bridge changes like these, which
> >>> might risk a revert a few months down the line, when somebody notices
> >>> and comes with a use case where that is not acceptable.
> >>>
> >>
> >> I should've clarified I was talking about Spectrum as Ido did in a rep=
ly.
> >=20
> > Ido also said "I assume Spectrum is not special in this regard" and I
> > just wanted to say this such that we don't end with the wrong impressio=
n.
> > Special or not, to the software bridge it would be new behavior, which
> > I can only hope will be well received.
> >=20
> >>>> Today the reply could get flooded if the entry can't be programmed
> >>>> as well, e.g. the atomic allocation might fail and we'll flood it ag=
ain, granted it's much less likely
> >>>> but still there haven't been any such guarantees. I think it's gener=
ally a good improvement and
> >>>> will simplify a lot of processing complexity. We can bite the bullet=
 and get the underlying delayed
> >>>> infrastructure correct once now, then the locking rules and other us=
e cases would be easier to enforce
> >>>> and reason about in the future.
> >>>
> >>> You're the maintainer, I certainly won't complain if we go down this =
path.
> >>> It would be nice if br->lock can also be transformed into a mutex, it
> >>> would make all of switchdev much simpler.
> >>>
> >>
> >> That is why we are discussing possible solutions, I don't want to forc=
e anything
> >> but rather reach a consensus about the way forward. There are complexi=
ties involved with
> >> moving to delayed learning too, one would be that the queue won't be a=
 simple linked list
> >> but probably a structure that allows fast lookups (e.g. rbtree) to avo=
id duplicating entries,
> >> we also may end up doing two stage lookup if the main hash table doesn=
't find an entry
> >> to close the above scenario's window as much as possible. But as I sai=
d I think that we can get
> >> these correct and well defined, after that we'll be able to reason abo=
ut future changes and
> >> use cases easier. I'm still thinking about the various corner cases wi=
th delayed learning, so
> >> any feedback is welcome. I'll start working on it in a few days and wi=
ll get a clearer
> >> view of the issues once I start converting the bridge, but having stra=
ight-forward locking
> >> rules and known deterministic behaviour sounds like a better long term=
 plan.
> >=20
> > Sorry, I might have to read the code, I don't want to misinterpret your
> > idea. With what you're describing here, I think that what you are tryin=
g
> > to achieve is to both have it our way, and preserve the current behavio=
r
> > for the common case, where learning still happens from the fast path.
> > But I'm not sure that this is the correct goal, especially if you also
> > add "straightforward locking rules" to the mix.
> >=20
>=20
> The trylock was only an optimization idea, but yes you'd need both synchr=
onous
> and asynchronous notifiers. I don't think you need sleepable context when
> learning from softirq, who would you propagate the error to? It is import=
ant
> when entries are being added from user-space, but if you'd like to have v=
eto
> option from softirq then we can scratch the trylock idea altogether.

I'll let Ido answer here. As I said, the model I'm working with is that
of autonomous learning, so for me, no. Whereas the Spectrum model is
that of secure learning. I expect that it'd be pretty useless to set up
software assisted secure learning if you're just going to say yes and
learn all addresses anyway. I've never seen Spectrum documentation, but
I would be shocked if it wouldn't be able to be configured to operate in
the bare-bones autonomous learning mode too.

> Let's not focus on the trylock, it's a minor detail.
>=20
> > I think you'd have to explain what is the purpose of the fast path tryl=
ock
> > logic you've mentioned above. So in the uncontended br->hash_lock case,
> > br_fdb_update() could take that mutex and then what? It would create an=
d
> > add the FDB entry, and call fdb_notify(), but that still can't sleep.
> > So if switchdev drivers still need to privately defer the offloading
> > work, we still need some crazy completion-based mechanism to report
> > errors like the one I posted here, because in the general sense,
> > SWITCHDEV_FDB_ADD_TO_DEVICE will still be atomic.
>=20
> We do not if we have ADD_TO_DEVICE and ADD_TO_DEVICE_SYNC,

Just when I was about to say that I'm happy to get rid of some of those
workqueues, and now you're telling me not only we might not get rid of
them, but we might also end up with a second, separate implementation :)

Anyway, let's not put the cart before the horses, let's see what the
realities of the bridge data path learning and STP flushing will teach
us about what can and can't be done.

> but that optimization is probably not worth the complexity of
> maintaining both so we can just drop the trylock.
>=20
> >=20
> > And how do you queue a deletion, do you delete the FDB from the pending
> > and the main hash table, or do you just create a deletion command to be
> > processed in deferred context?
> >=20
>=20
> All commands which cannot take the mutex directly will be executed from a=
 delayed
> queue. We also need a delayed flush operation because we need to flush fr=
om STP code
> and we can't sleep there due to the STP spinlock. The pending table can b=
e considered
> only if we decide to do a 2-stage lookup, it won't be used or consulted i=
n any other
> case, so user-space adds and deletes go only the main table.
>=20
> > And since you'd be operating on the hash table concurrently from the
> > deferred work and from the fast path, doesn't this mean you'll need to
> > use some sort of spin_lock_bh from the deferred work, which again would
> > incur atomic context when you want to notify switchdev? Because with th=
e
> > mutex_trylock described above, you'd gain exclusivity to the main hash
> > table, but if you lose, what you need is exclusivity to the pending has=
h
> > table. So the deferred context also needs to be atomic when it dequeues
> > the pending FDB entries and notifies them. I just don't see what we're
> > winning, how the rtnetlink functions will be any different for the bett=
er.
> >=20
>=20
> The rbtree can be fully taken by the delayed action and swapped with a ne=
w one,
> so no exclusivity needed for the notifications. It will take the spinlock=
, get
> the whole tree and release the lock, same if it was a simple queue.

I'm quite unfamiliar with this technique, atomically swapping a queue
pointer with a new empty one, and emptying that queue while unlocked.
Do you have any reference implementation for this kind of technique?

> The spinlock for the rbtree for the delayed learning is necessary in all =
cases,

"in all cases" means "regardless of whether we try from the fast path to
make fdb_create() insert directly into &br->fdb_hash_tbl, or if we
insert into a temporary rbtree for pending entries"? I don't understand
this: why would you take the rbtree spinlock if you've inserted into the
main hash table already?

I'm only concerned about spin locks we'd have to hold while calling
fdb_notify().

> if we used the trylock fast learn then we could directly insert the entry=
 if we win, but
> again lets just always use delayed ops from atomic contexts as a start.
>=20
> All entries from atomic contexts will be added to an rbtree which will be=
 processed
> from a delayed work, it will be freed by RCU so lookups can be done if we=
 decide to
> do a 2-stage lookup for the fast Rx path to reduce the flooding case wind=
ow that you
> described above.
>=20
> We win having sleepable context for user-space calls and being able to do=
 synchronous
> calls to the drivers to wait for the errors.

I think I'd really have to see the code at this point, sorry.=
