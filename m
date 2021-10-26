Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793F143BA18
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbhJZTEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:04:06 -0400
Received: from mail-db8eur05on2040.outbound.protection.outlook.com ([40.107.20.40]:32961
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231592AbhJZTEE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:04:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4DOlalfT8cp4NM/J4clzYcsrdrQzFDdg+qcPQAzhNzEhwIj7FgVmxqQn0uGXCHJyXAnakJQ3r0Z0zayetUVQWJUHhRs7xcuiq4Ftm2V+ou1DnrA9JVA28+zUKm0pPln6W6e1XUK1O+C1GDywGyybE+USR5zdizfonwIkdnhWgsz25KXpwgjMXSlJ9MP0edODonSp8DiS7FZsIvRGvz5HvQIE76VDFTkwqrHgh3ysouKsRO4j1USMZcu24ElaF4tSEBRx/dwK7APrtaYxihQT/nwQEvPELZSNoUjaz64LMYklaPUa1ibxIXR3mSdvDoHRkiKiCD2rA6x5TaVBaR0cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WF3juTV2wTj5sIdF5ppla59v742HMP7p35xYK0iydMY=;
 b=FaSDpUgCszgfGetnMZHbyyEQctt1daFu0hMnjm2CWQTMPtXt9u7SeWsW2P2m0Gl2U0mhmKIKN54mK/DoceHq0J71hjcFaZnsC/6a9wM2Whm/Z+OYs37iXGpJ3tIHBiokUQqFn/nXeN98w9EyEMG7b++4MoVCrkPxOI+cb8f+ROzWpQVs+3aaIs2L9dN32toUguHRDGeG/t22Bjk18+8Txjy7TT4DyJ1JOeGp5DM/nNGpX/Gx61uOY3qXwD+TI7F+xleNK9KnWXWl0IYdAQGAuZJeBgFytIsCDJ3m0+mYFBUdoKzK1VnDC9UiKNu1BbVIVx/s/E79vGnzgYmAiNB82Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WF3juTV2wTj5sIdF5ppla59v742HMP7p35xYK0iydMY=;
 b=M5qkSLSNYGKNZw18DQ7+oxLp9ipg3jNbFZSOfXi3arEdtd5uImshnSMsUYKOvNS22qHRGR8znFujvm9wgmN07h/pLlpQnWtQZaG1ADd1tV+/rp3jwjA4J71hddhTwNfNL4rW9kov4KT6gc+Qavzo8L/6s0QT0l+6ZQkOlL3jtpk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4911.eurprd04.prod.outlook.com (2603:10a6:803:56::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 19:01:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 19:01:37 +0000
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
Thread-Index: AQHXye8TuHIQFfcKx02oYjeM7kf+xavlF9qAgAAMn4CAAA9DgIAATKgAgAAEkYCAAB75AA==
Date:   Tue, 26 Oct 2021 19:01:37 +0000
Message-ID: <20211026190136.jkxyqi6b7f4i2bfe@skbuf>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
 <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
 <20211026112525.glv7n2fk27sjqubj@skbuf>
 <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
 <20211026165424.djjy5xludtcqyqj2@skbuf>
 <a703cf3c-50f5-1183-66a8-8af183737e26@nvidia.com>
In-Reply-To: <a703cf3c-50f5-1183-66a8-8af183737e26@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b969b3ff-3bad-4e1e-66d0-08d998b3099d
x-ms-traffictypediagnostic: VI1PR04MB4911:
x-microsoft-antispam-prvs: <VI1PR04MB49118ACECEFEB949BAACDDB4E0849@VI1PR04MB4911.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qancoMK9bhf++Ht8IfuCfRluAOj4ePyzYKMUMLn5R3C3i3eYQ7B3iRG/uwJ5SzwkhzTlnLPkQOHTJx8I00sOyRKicz5Q3VRm99KONmdKIGPGqfuCXoF5QAE2Kkf8ZAgVlPZmh6T1tguNAoF5+OpevJ3OdVEUTqZ6iwKWTz/yojSKnJKe/aFF51TrYPLVo7V3kdr+OEusFrP2hBshkhG4qarLG0fxodu3I8Tp93kpIb+LiDzAzMNyTxRlBFAOnZc34yKVq4FawfzH+D0v/nMmo8kL3fiGP/YziVuBX2rDQzBRdKQe/xivc2FZoJsz/70Xkvb241EyjL3rJis0eOH9H4Qz41i/iW0JAXHk4goDyE2Pw6eQU+ltiij+Tbxq09RbXWNyFFRkd0b0Q/JqyfXhdn86aDLSpvck0p9kw2nJd5NEnw9BZDENBavAH5mrx8My1O27IDmUEw3LS6JB+HseqWYa+Ut0lTvssI3hyg8IXWpq7hQH3WQcvulBIKdGqq4uWJ003j6wTwLN15xHkEUUCEN6OEq78mr3X0m9QFPSwVt7vbEAzDqSEGdSxmE5CYkwxT8zgxuF6WyQ93F8Q33YhwyNnk97TjLPYMsaVU9QbMl2Diu54dMHsME9vqlAaq7TEj6oEvY45RgbO53G8A7jAnV6FW57TdMsEL7NElwEJ033lgvQHqRpI6OqPpNjrsdoPkcaGqigOSCKqsJPhgurWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6486002)(9686003)(86362001)(6506007)(66556008)(33716001)(44832011)(6512007)(53546011)(83380400001)(26005)(71200400001)(76116006)(8676002)(6916009)(8936002)(508600001)(64756008)(66446008)(66476007)(38100700002)(7416002)(2906002)(54906003)(38070700005)(122000001)(66946007)(186003)(1076003)(4326008)(316002)(91956017)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cl49L46/p/r1q/RNpxA3xPxmXOOup/Kl32q3zy9m6IlXC3OdZSkzEdmnhkr3?=
 =?us-ascii?Q?+YdIMpv6TlUOQp2DXYzszbVlhGFCT45OPQh3JNAUFiwGLzw+3OX57uSnnxMp?=
 =?us-ascii?Q?epWq7t08uoGr5jL03TqicK1OyR+5/qLHZi1UshKu3stHwNgiw9WJLwLk0sY/?=
 =?us-ascii?Q?98HV/jRqZEHpN4I8zZXKe6PMJ6qHGf6AlXWEJSYrsgePD+aLFWe54V7v5WIX?=
 =?us-ascii?Q?VHVaUmNw7Beny5a6s6IkqqTLX4+05Fs8+52mPASa4hNwU5tc7cTmlJjftccj?=
 =?us-ascii?Q?qtIIQe9kHYAN1t/QGUZFE+ql+7lm2cZyOH2/T65/7OQOI9ul9+xmQDpTUoyb?=
 =?us-ascii?Q?dYgplffHR5nXamCkFPBPqdxtpqDNiwS/oTuvrQGhdyMNuYguwXR2KYocWRrw?=
 =?us-ascii?Q?QcI5jdHoK29Zb6iNNaVMxZkZCDROp28IP4cQwa4sToBxk/Dqg6Bl2AqVOgax?=
 =?us-ascii?Q?GwqX2Gsa0a7ICG339vljXjK1nByvkxr6egeSlhhZPmruG3ZMaq+uu2sjzRLj?=
 =?us-ascii?Q?ehrhuzazBtYTXrCwmvWP2j5PuOq/+iiXbJ80y1AV3X4ksmhiUXbac+coqAPN?=
 =?us-ascii?Q?Xvh87zM5RUS75hDYnaDjhWRGCmOT5lrhZR0E+fZSzlyDe7vTvT3WFn3ViGNF?=
 =?us-ascii?Q?IzH5EBsfxZcVU2FQQ9OwESW8nN5GrRUjhFJ4tbH9vzG2kF0tf/um5Gzp0YuX?=
 =?us-ascii?Q?/L6qZ7PCRPvvhpzI7fRqpEeCa5OEPejooYiq/MThTWdZ945g8Kchxr48FvME?=
 =?us-ascii?Q?Qv+u9C4iMHj9HhFecnx9biEhL9ziCmXu2cetHAP2OtHZhl5AD6nHBayTGR1h?=
 =?us-ascii?Q?/Sza5TTz7RlFCgES3g9nCcqVZ+kzqcdhtXLbKtg281KQCkKmQZc+PwZBJJmh?=
 =?us-ascii?Q?8g2jbeni32F59Mcho9q/MFSJADjJG6GjZaKlIA8XgBe8juoj58SSH5SX7dUM?=
 =?us-ascii?Q?N05+TntOKzArEzzpJtStAGsxfJ9NDNxrBOiEGKAkSrJa0Pglbd1+LMg98Kuy?=
 =?us-ascii?Q?3N92cfi6SI15+/J5hJXoE1+5AdYNDBhiDNvQj6TukKIMsV8d6h+QSMmSaEXk?=
 =?us-ascii?Q?wWewJX832v+AFkfIqfcyqDOB58a0nJNDpCcL1drFjhU4w/dWKP0idb5kTNoH?=
 =?us-ascii?Q?SfLFIiwbu9dADzK6qbNHfDXJH0kOVee05OA8nnGuBICKjHAHiIlJIJWDmlZC?=
 =?us-ascii?Q?QE0/KIT6mLeOogpk6Qm1WBgN2qi9qsxIGbUcl70MUDK5syk8L2+oVZZs8M8W?=
 =?us-ascii?Q?D4a190Pc1tYPXiZMUrjJx95hNKqGSaeRzEovMZV26EBZ4ExNVFAJ6FxBRJj2?=
 =?us-ascii?Q?HYU/sJ7SMMLu7tX/UuV9CWLQh4UZTtSqZOQobOcDJveZr77CtVf0YXFNNHK1?=
 =?us-ascii?Q?pJpCLvBZK/ho0fcyKP0I0LXgC5jg/Gwv7DmW3ugWwkBOMkzJ0VVHUFpzwt2C?=
 =?us-ascii?Q?UcN44j/OjFEisqA1S2TC+BYkSEpF9veQeLjXBNSKwqNxKI27Rc5J2utBfE+V?=
 =?us-ascii?Q?JR/HMxnGWGAF9YfRGWqu5qjs96jceAcT/+M85a3VmpdihE8evn7WXAmyto2R?=
 =?us-ascii?Q?5wTG34Dvp3bufLLOCsFk4uMxRnD1wV6uxImRa5BIepG7JyD92Rv0BrRGvqqE?=
 =?us-ascii?Q?knrJCIT43gfMkn3i2cpAZq1Y5uH+Dy88Z41PFLKq7nA8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B041B863869B064CB25B61F24F1B4AB7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b969b3ff-3bad-4e1e-66d0-08d998b3099d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 19:01:37.6134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c9Lhm02H+oSNgCuMjf4o1xPO2y790dZkBUFsnWFBu5NiyKbz3sDaw1bJK2MtdDZa6bM4/9BrRRU81uIguingcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4911
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 08:10:45PM +0300, Nikolay Aleksandrov wrote:
> On 26/10/2021 19:54, Vladimir Oltean wrote:
> > On Tue, Oct 26, 2021 at 03:20:03PM +0300, Nikolay Aleksandrov wrote:
> >> On 26/10/2021 14:25, Vladimir Oltean wrote:
> >>> On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
> >>>> Hi,
> >>>> Interesting way to work around the asynchronous notifiers. :) I went=
 over
> >>>> the patch-set and given that we'll have to support and maintain this=
 fragile
> >>>> solution (e.g. playing with locking, possible races with fdb changes=
 etc) I'm
> >>>> inclined to go with Ido's previous proposition to convert the hash_l=
ock into a mutex
> >>>> with delayed learning from the fast-path to get a sleepable context =
where we can
> >>>> use synchronous switchdev calls and get feedback immediately.
> >>>
> >>> Delayed learning means that we'll receive a sequence of packets like =
this:
> >>>
> >>>             br0--------\
> >>>           /    \        \
> >>>          /      \        \
> >>>         /        \        \
> >>>      swp0         swp1    swp2
> >>>       |            |        |
> >>>    station A   station B  station C
> >>>
> >>> station A sends request to B, station B sends reply to A.
> >>> Since the learning of station A's MAC SA races with the reply sent by
> >>> station B, it now becomes theoretically possible for the reply packet=
 to
> >>> be flooded to station C as well, right? And that was not possible bef=
ore
> >>> (at least assuming an ageing time longer than the round-trip time of =
these packets).
> >>>
> >>> And that will happen regardless of whether switchdev is used or not.
> >>> I don't want to outright dismiss this (maybe I don't fully understand
> >>> this either), but it seems like a pretty heavy-handed change.
> >>>
> >>
> >> It will depending on lock contention, I plan to add a fast/uncontended=
 case with
> >> trylock from fast-path and if that fails then queue the fdb, but yes -=
 in general
> >=20
> > I wonder why mutex_trylock has this comment?
> >=20
> >  * This function must not be used in interrupt context. The
> >  * mutex must be released by the same task that acquired it.
> >=20
> >> you are correct that the traffic could get flooded in the queue case b=
efore the delayed
> >> learning processes the entry, it's a trade off if we want sleepable le=
arning context.
> >> Ido noted privately that's usually how hw acts anyway, also if people =
want guarantees
> >> that the reply won't get flooded there are other methods to achieve th=
at (ucast flood
> >> disable, firewall rules etc).
> >=20
> > Not all hardware is like that, the switches I'm working with, which
> > perform autonomous learning, all complete the learning process for a
> > frame strictly before they start the forwarding process. The software
> > bridge also behaves like that. My only concern is that we might start
> > building on top of some fundamental bridge changes like these, which
> > might risk a revert a few months down the line, when somebody notices
> > and comes with a use case where that is not acceptable.
> >=20
>=20
> I should've clarified I was talking about Spectrum as Ido did in a reply.

Ido also said "I assume Spectrum is not special in this regard" and I
just wanted to say this such that we don't end with the wrong impression.
Special or not, to the software bridge it would be new behavior, which
I can only hope will be well received.

> >> Today the reply could get flooded if the entry can't be programmed
> >> as well, e.g. the atomic allocation might fail and we'll flood it agai=
n, granted it's much less likely
> >> but still there haven't been any such guarantees. I think it's general=
ly a good improvement and
> >> will simplify a lot of processing complexity. We can bite the bullet a=
nd get the underlying delayed
> >> infrastructure correct once now, then the locking rules and other use =
cases would be easier to enforce
> >> and reason about in the future.
> >=20
> > You're the maintainer, I certainly won't complain if we go down this pa=
th.
> > It would be nice if br->lock can also be transformed into a mutex, it
> > would make all of switchdev much simpler.
> >=20
>=20
> That is why we are discussing possible solutions, I don't want to force a=
nything
> but rather reach a consensus about the way forward. There are complexitie=
s involved with
> moving to delayed learning too, one would be that the queue won't be a si=
mple linked list
> but probably a structure that allows fast lookups (e.g. rbtree) to avoid =
duplicating entries,
> we also may end up doing two stage lookup if the main hash table doesn't =
find an entry
> to close the above scenario's window as much as possible. But as I said I=
 think that we can get
> these correct and well defined, after that we'll be able to reason about =
future changes and
> use cases easier. I'm still thinking about the various corner cases with =
delayed learning, so
> any feedback is welcome. I'll start working on it in a few days and will =
get a clearer
> view of the issues once I start converting the bridge, but having straigh=
t-forward locking
> rules and known deterministic behaviour sounds like a better long term pl=
an.

Sorry, I might have to read the code, I don't want to misinterpret your
idea. With what you're describing here, I think that what you are trying
to achieve is to both have it our way, and preserve the current behavior
for the common case, where learning still happens from the fast path.
But I'm not sure that this is the correct goal, especially if you also
add "straightforward locking rules" to the mix.

I think you'd have to explain what is the purpose of the fast path trylock
logic you've mentioned above. So in the uncontended br->hash_lock case,
br_fdb_update() could take that mutex and then what? It would create and
add the FDB entry, and call fdb_notify(), but that still can't sleep.
So if switchdev drivers still need to privately defer the offloading
work, we still need some crazy completion-based mechanism to report
errors like the one I posted here, because in the general sense,
SWITCHDEV_FDB_ADD_TO_DEVICE will still be atomic.

And how do you queue a deletion, do you delete the FDB from the pending
and the main hash table, or do you just create a deletion command to be
processed in deferred context?

And since you'd be operating on the hash table concurrently from the
deferred work and from the fast path, doesn't this mean you'll need to
use some sort of spin_lock_bh from the deferred work, which again would
incur atomic context when you want to notify switchdev? Because with the
mutex_trylock described above, you'd gain exclusivity to the main hash
table, but if you lose, what you need is exclusivity to the pending hash
table. So the deferred context also needs to be atomic when it dequeues
the pending FDB entries and notifies them. I just don't see what we're
winning, how the rtnetlink functions will be any different for the better.=
