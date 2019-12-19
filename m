Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA648126869
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfLSRsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:48:39 -0500
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:32350
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726797AbfLSRsi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 12:48:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uj9j0oJZVYz798xZDNttBXus1vawi3F6Ed5BhMPVlurHWRDq/nHDVIkxxJKq7Ghnc8RpMIb3urD9i868W+Bp50VcHWq0wcFFHgft9hwhhVsx2R/HTT7m55u0eEAWoMzbw8udB1J0LA2yTpiuXqrRjAbe+r2ZwWgeN/w3DEMQuKZHRbxHjZtwYco0EsTkJx9n/GPpYQ+/8cxTrqb8CcR36ufxn2D8mGOo6sYdAlL4FCnXW/vWflXkas69K0Pda7QXsXxDy7q72L2Ru6TylV6n7Z4fh88ZJWNpKXf2wieHwbo053yHOGwDLbwYSkgLpCudO8MiW6BEWthBNwXw6FbqiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0+H3TtjlNon6TPiWaxu9U5H6niJvA2URYf8h7S6KKA=;
 b=FG4e/ahxv86Tbk6NK4FiJdB0XappkVfB/LKR14nc8rftqf07OlG8yGRsrfw4z5DyOr2HDoX81Nw+hiOrfNGMsGmix2/9ywHJLQm/jsbTxE5Ia76oOIe3oXSKJPiyLsUEb+4ZIztVfFT37k9UzWVUX0gO+/2D4gFtXx5NLNDXMk8BicUhtJVZNuQpdvgHiG7TRMXrkoG4B5jeFjGOzauFhsmkX3CH7ZlUJ8p6UNxX4OEpvDtR/yjFkvyD4cEZ5kaAsI7fnh6oCBKL0uASa5WHFPsc+mvEdCTXvWGmRStTmHisos/JLq+XiWgaZYNscgJ8H6RmFCSPAo0FxCEmO9qR4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0+H3TtjlNon6TPiWaxu9U5H6niJvA2URYf8h7S6KKA=;
 b=hgAxiqoudvqQnGRyjNxzCHVsSlKCgavAtsVMfxdw2snyzfTaA7ZPe857HzoZiG8a2EcOufS2yY7KWeyOM1ShTXfUR61iJE37hfNpFMaWuZnwKikG/OLNPnjC9g97eQHv1ZFnKs4IHNtack6JA2mlMwvtZ6HETTdDX27t7SXruBk=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2934.eurprd05.prod.outlook.com (10.172.249.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Thu, 19 Dec 2019 17:46:52 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.022; Thu, 19 Dec 2019
 17:46:52 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next mlxsw v2 00/10] Add a new Qdisc, ETS
Thread-Topic: [PATCH net-next mlxsw v2 00/10] Add a new Qdisc, ETS
Thread-Index: AQHVtbMil1f5NeWUQUa8VUFTFPuvkqfAE2OAgAAk+YCAAW/1gIAAFN0A
Date:   Thu, 19 Dec 2019 17:46:52 +0000
Message-ID: <878sn8nr79.fsf@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
 <5dfa525bc3674_2dca2afa496f05b86e@john-XPS-13-9370.notmuch>
 <87eex1o528.fsf@mellanox.com>
 <5dfba6091d854_61ae2ac457a865c45f@john-XPS-13-9370.notmuch>
In-Reply-To: <5dfba6091d854_61ae2ac457a865c45f@john-XPS-13-9370.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.220.234.169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ee363154-78ea-4504-87dd-08d784ab6e40
x-ms-traffictypediagnostic: DB6PR0502MB2934:|DB6PR0502MB2934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2934C564EE1D3BBD5314A412DB520@DB6PR0502MB2934.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(136003)(39850400004)(199004)(189003)(51444003)(51914003)(26005)(5660300002)(2616005)(86362001)(54906003)(478600001)(6486002)(52116002)(36756003)(6916009)(316002)(186003)(8936002)(2906002)(8676002)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(6512007)(4326008)(81166006)(81156014)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2934;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RofMaJITKHqYTpBECK+tk4J2+VqXnphfTwT1jxKSHpZQhjuVpfqZpUT7udlqxznQGy4sO+GO7q/mP3iLgztOXr3Zkwd9PPDtQYDtPf0j/RqcXDldAyHDG+7AEsLpq+YO1K7E/vJaol4pqBy5tJhMyot6BCad9g9LZZbod8S3r09uZAiOWEq3z1J1lSg5cNNntZw2tKejd1eAuQdzzvX6peHUDxIKVmbw2/pM2n+wgyrqR/g2GAJXeFQjJDoBmWb+2Zq7I3KCLQOlc7oGbP+Ll8uRQNqxaUWzl9vOyDt2jrNmxwx/EYBVhyyA4B45QRTMReUKPGo+DhdPl/Plyx5JC6f88ZmzA4Qj4u2Ck5lhYeLgpz5q9tXsO+VMtdEOmvUMNJXX0xqbDJs8QIarqmhbDTfwDV2hJJhwhPE0JJW3+ytAFz3NGDeCyqcrbC+0b//UOmTBhNGH6piEZpGu4SqaUBDRRvi+TUcybYR2RJtmwVQr9lcoiJJu7Jma3vXOgUqMVusr+RL/vJQxXL8ZUGl0Gg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee363154-78ea-4504-87dd-08d784ab6e40
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 17:46:52.3260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3zLcFQPgJ2hBo7vCgk6D33zR6dU4IR+NeW8yZyvNvgR+pJyzsGFwoYtNQMhD4JYkUPznkE2guXujyRHqj6oXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


John Fastabend <john.fastabend@gmail.com> writes:

> Petr Machata wrote:
>>
>> John Fastabend <john.fastabend@gmail.com> writes:
>>
>> > Petr Machata wrote:
>> >> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
>> >> transmission selection algorithms: strict priority, credit-based shap=
er,
>> >> ETS (bandwidth sharing), and vendor-specific. All these have their
>> >> corresponding knobs in DCB. But DCB does not have interfaces to confi=
gure
>> >> RED and ECN, unlike Qdiscs.
>> >
>> > So the idea here (way back when I did this years ago) is that marking =
ECN
>> > traffic was not paticularly CPU intensive on any metrics I came up wit=
h.
>> > And I don't recall anyone ever wanting to do RED here. The configurati=
on
>> > I usually recommended was to use mqprio + SO_PRIORITY + fq per qdisc. =
Then
>> > once we got the BPF egress hook we replaced SO_PRIORITY configurations=
 with
>> > the more dynamic BPF action to set it. There was never a compelling pe=
rf
>> > reason to offload red/ecn.
>> >
>> > But these use cases were edge nodes. I believe this series is mostly a=
bout
>> > control path and maybe some light control traffic? This is for switche=
s
>> > not for edge nodes right? I'm guessing because I don't see any perform=
ance
>> > analaysis on why this is useful, intuitively it makes sense if there i=
s
>> > a small CPU sitting on a 48 port 10gbps box or something like that.
>>
>> Yes.
>>
>> Our particular use case is a switch that has throughput in Tbps. There
>> simply isn't enough bandwidth to even get all this traffic to the CPU,
>> let alone process it on the CPU. You need to offload, or it doesn't make
>> sense. 48 x 10Gbps with a small CPU is like that as well, yeah.
>
> Got it so I suspect primary usage will be offload then at least for
> the initial usage.

Yes, particularly configuration of offloaded forwarding path.

>> > offload is tricky with stacked qdiscs though ;)
>>
>> Offload and configuration both.
>>
>> Of course there could be a script to somehow generate and parse the
>> configuration on the front end, and some sort of library to consolidate
>> on the driver side, but it's far cleaner and easier to understand for
>> all involved if it's a Qdisc. Qdiscs are tricky, but people still
>> understand them well in comparison.
>
> At one point I wrote an app to sit on top of the tc netlink interface
> and create common (at least for the customers at the time) setups. But
> that tool is probably lost to history at this point.
>
> I don't think its paticularly difficult to build this type of tool
> on top of the API but also not against a new qdisc like this that
> folds in a more concrete usage and aligns with a spec. And Dave
> already merged it so good to see ;)
>
> [...]
>
>> >> The chosen interface makes the overall system both reasonably easy to
>> >> configure, and reasonably easy to offload. The extra code to support =
ETS in
>> >> mlxsw (which already supports PRIO) is about 150 lines, of which perh=
aps 20
>> >> lines is bona fide new business logic.
>> >
>> > Sorry maybe obvious question but I couldn't sort it out. When the qdis=
c is
>> > offloaded if packets are sent via software stack do they also hit the =
sw
>> > side qdisc enqueue logic? Or did I miss something in the graft logic t=
hat
>> > then skips adding the qdisc to software side? For example taprio has d=
equeue
>> > logic for both offload and software cases but I don't see that here.
>>
>> You mean the graft logic in the driver? All that stuff is in there just
>> to figure out how to configure the device. SW datapath packets are
>> still handled as usual.
>
> Got it just wasn't clear to me when viewing it from the software + smartn=
ic
> use case. So is there a bug or maybe just missing feature, where if I
> offloaded this on a NIC that both software and hardware would do the ETS
> algorithm? How about on the switch would traffic from the CPU be both ETS
> classified in software and in hardware? Or maybe CPU uses different inter=
face
> without offload on?

You would get SW scheduling if there's more traffic than the host
interface can handle.

In the HW, control traffic gets TC 16, which the chip hardcodes as the
highest priority and handles in a dedicated set of queues. So there's no
second classification.

>> >> Credit-based shaping transmission selection algorithm can be configur=
ed by
>> >> adding a CBS Qdisc under one of the strict bands (e.g. TBF can be use=
d to a
>> >> similar effect as well). As a non-work-conserving Qdisc, CBS can't be
>> >> hooked under the ETS bands. This is detected and handled identically =
to DRR
>> >> Qdisc at runtime. Note that offloading CBS is not subject of this pat=
chset.
>> >
>> > Any performance data showing how accurate we get on software side? The
>> > advantage of hardware always to me seemed to be precision in the WRR a=
lgorithm.
>>
>> Quantum is specified as a number of bytes allowed to dequeue before a
>> queue loses the medium. Over time, the amount of traffic dequeued from
>> individual queues should average out to be the quanta your specified. At
>> any point in time, size of the packets matters: if I push 1000B packets
>> into a 10000B-quantum queue, it will use 100% of its allocation. If they
>> are 800B packets, there will be some waste (and it will compensate next
>> round).
>>
>> As far as the Qdisc is defined, the SW side is as accurate as possible
>> under given traffic patterns. For HW, we translate to %, and rounding
>> might lead to artifacts. You kinda get the same deal with DCB, where
>> there's no way to split 100% among 8 TCs perfectly fairly.
>>
>> > Also data showing how much overhead we get hit with from basic mq case
>> > would help me understand if this is even useful for software or just a
>> > exercise in building some offload logic.
>>
>> So the Qdisc is written to do something reasonable in the SW datapath.
>> In that respect it's as useful as PRIO and DRR are. Not sure that as a
>> switch operator you really want to handle this much traffic on the CPU
>> though.
>
> I was more thinking of using it in the smart nic case.

I'm not really familiar with this.

I can imagine some knobs that map the individual bands to NIC queues for
example. I think that's something that mlxsw_spectrum could actually
use. We do have several queues to the chip, and currently round-robin
them by hand in the driver. Logic to determine which queues to use for
which traffic seems to make sense. But currently we simply don't see
these use cases at all.

>> > FWIW I like the idea I meant to write an ETS sw qdisc for years with
>> > the expectation that it could get close enough to hardware offload cas=
e
>> > for most use cases, all but those that really need <5% tolerance or so=
mething.
>
> Anyways thanks for the answers clears it up on my side. One remaining
> question is if software does send packets if they get both classified
> via software and hardware. Might be worth thinking about fixing if
> that is the case or probably more likely switch knows not to do
> this.

Yeah, traffic from the CPU is handled specially.
