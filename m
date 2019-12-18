Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E92711250B1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfLRSfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:35:24 -0500
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:18944
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbfLRSfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 13:35:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgI573qqR/HKk0zhyZTr0mim0ZR/AV43NZ3dnTmOaCzNGYwv6WC138T67FfsTXm+lqpBUxlZe01YtyLEFxjZ/pyQKQ+gTXqsRrmbJiFqeWENUokDMHtA6ESNkYNPLSDZsXynhtZLh/NmX0mHtLVezxzzNiYbf2RfeNXdEEue/BZOSck/aoSEHmIarXsjIDORs+zeXBgFS+rtCC1NwfOQYAxkZvca1gc55e+gKYY5SCVPj0JF70RFRXY9E38ryeUHorf/vQodP53Xd6dO5d0Fbmb1dKYwlJOnnNUlweZ9EaiNnysPVlRMlNMacvb6KveuQ2L3pHhIlOkPGRl088Nquw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kP0Y0o1UtbbgiyYlOU0hVBBr+HDs9NYbtsgZ0qFgMEo=;
 b=BGJjqaHxucTeALSDr6MVFi7e0yDJCBzE87is3BHDypfjO1++pG1skwuGFDfVoaCIUJZq5UhC2Nvztrp1zOUnvoNxRA98Y4EZlmfTBg1Ibo+gBzuPvVyH0SbIts/unjxIgRIgHX1pqWcdeCm1GcaMyGhEl67H+2A6eiFxkGp6vpCuTQMIFy10fzGkV9OaHyYypHfm7TCcv7Eg7UAFWqLFWH6oVyt7JYibnC6hEKkTfvKzEOfDBV7K8tRCEWINFYvBzr2kAxb40sgnDYOj7v86h13s68V/Je9dscVJQKN8ffNKd7KLjy0bBU3Li3Wukj9HZI0cb+MyzEuDSJHu+DMgIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kP0Y0o1UtbbgiyYlOU0hVBBr+HDs9NYbtsgZ0qFgMEo=;
 b=VLzbx3rLtfdXjm1OH0d+QDDrIZZfobDtkzlZarKdYXamyQxPhP0oyamdrKN0fLX9VsaaHq0tamdQLcP5Aq2yTYSXavuhlUZcUUCfjTYQ1HEHr0D7bSjo7G7XLfjA6QbmJ5y3UMZfC8g8rdv++uSrl1516uQ3l6Jepi+9dwrN4Ms=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2887.eurprd05.prod.outlook.com (10.172.249.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 18:35:14 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 18:35:13 +0000
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
Thread-Index: AQHVtbMil1f5NeWUQUa8VUFTFPuvkqfAE2OAgAAk+YA=
Date:   Wed, 18 Dec 2019 18:35:13 +0000
Message-ID: <87eex1o528.fsf@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
 <5dfa525bc3674_2dca2afa496f05b86e@john-XPS-13-9370.notmuch>
In-Reply-To: <5dfa525bc3674_2dca2afa496f05b86e@john-XPS-13-9370.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR07CA0133.eurprd07.prod.outlook.com
 (2603:10a6:207:8::19) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.220.234.169]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01c7f22d-4211-492e-727d-08d783e90519
x-ms-traffictypediagnostic: DB6PR0502MB2887:|DB6PR0502MB2887:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2887FE0E536719E55ECFE6FCDB530@DB6PR0502MB2887.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(43544003)(199004)(189003)(6486002)(66946007)(478600001)(64756008)(66446008)(66476007)(66556008)(4326008)(186003)(316002)(2906002)(36756003)(86362001)(6512007)(71200400001)(52116002)(54906003)(2616005)(6916009)(81166006)(81156014)(8676002)(6506007)(5660300002)(26005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2887;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VMjyjnJAx2AXAbaXZZV1JzDCIfKx4tKUwvuuV8KvzkvURRc0pR1eKVNLn0NFycuX15GzudNZ6kkcAx38EMWMi9nL55WaR3mV4RbwK8Huj8ANZitvG62a9BHmWPeuI2K0Gd2V5fzR5t8hJE1EsXHxixNcFBWQOUlpR3xy/CQNJ9Os+VyGG1MXZvxHLWBspwRCH6IaMW+X6lf1GMJZJEXQtsfBhEbsd9xAwD2fXMoTpxqXOgfiWbc0P9LwOKPwqiAZ8iL7Uo1SVVOmvGFEbezAmke11ZCGbAhwKUiTv1rPOpKjUhZhiK6RiAM1rlTnuYpJazEcQt+AMS/yX7NXChadJVu9A0i8U2I5pIImxF7feM6XQ6FVq8iYu3iFindNPWcqy8Zu4o0cExXup0sLIEPPrw53hphi2Qx1fZh9HXpX7Evcj0Rolqeli8GKOb3IvSPrjQDp8kfp7nbCvJ6ssXxDwtUGZMNtoeBpIz/lunzKs3RR21w0hKiFHXzkteS78CBe
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01c7f22d-4211-492e-727d-08d783e90519
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 18:35:13.6575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tiFTLEtRuowJnA7gatPsVXqzpXy03kbZm7kkwljFwNatfX0BLsAo/bzlBEC6NM4ciul4G28rD/C3WJzdfltqdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2887
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


John Fastabend <john.fastabend@gmail.com> writes:

> Petr Machata wrote:
>> The IEEE standard 802.1Qaz (and 802.1Q-2014) specifies four principal
>> transmission selection algorithms: strict priority, credit-based shaper,
>> ETS (bandwidth sharing), and vendor-specific. All these have their
>> corresponding knobs in DCB. But DCB does not have interfaces to configur=
e
>> RED and ECN, unlike Qdiscs.
>
> So the idea here (way back when I did this years ago) is that marking ECN
> traffic was not paticularly CPU intensive on any metrics I came up with.
> And I don't recall anyone ever wanting to do RED here. The configuration
> I usually recommended was to use mqprio + SO_PRIORITY + fq per qdisc. The=
n
> once we got the BPF egress hook we replaced SO_PRIORITY configurations wi=
th
> the more dynamic BPF action to set it. There was never a compelling perf
> reason to offload red/ecn.
>
> But these use cases were edge nodes. I believe this series is mostly abou=
t
> control path and maybe some light control traffic? This is for switches
> not for edge nodes right? I'm guessing because I don't see any performanc=
e
> analaysis on why this is useful, intuitively it makes sense if there is
> a small CPU sitting on a 48 port 10gbps box or something like that.

Yes.

Our particular use case is a switch that has throughput in Tbps. There
simply isn't enough bandwidth to even get all this traffic to the CPU,
let alone process it on the CPU. You need to offload, or it doesn't make
sense. 48 x 10Gbps with a small CPU is like that as well, yeah.

From what I hear, RED / ECN was not used very widely in these sorts of
deployments, rather the deal was to have more bandwidth than you need
and not worry about QoS. This is changing, and people experiment with
this stuff more. So there is interest in strict vs. DWRR TCs, shapers,
and RED / ECN.

>> In the Qdisc land, strict priority is implemented by PRIO. Credit-based
>> transmission selection algorithm can then be modeled by having e.g. TBF =
or
>> CBS Qdisc below some of the PRIO bands. ETS would then be modeled by
>> placing a DRR Qdisc under the last PRIO band.
>>
>> The problem with this approach is that DRR on its own, as well as the
>> combination of PRIO and DRR, are tricky to configure and tricky to offlo=
ad
>> to 802.1Qaz-compliant hardware. This is due to several reasons:
>
> I would argue the trick to configure part could be hid behind tooling to
> simplify setup. The more annoying part is it was stuck behind the qdisc
> lock. I was hoping this would implement a lockless ETS qdisc seeing we
> have the infra to do lockless qdiscs now. But seems not. I guess software
> perf analysis might show prio+drr and ets here are about the same perform=
ance
> wise.

Pretty sure. It's the same algorithm, and I would guess that the one
extra virtual call will not throw it off.

> offload is tricky with stacked qdiscs though ;)

Offload and configuration both.

Of course there could be a script to somehow generate and parse the
configuration on the front end, and some sort of library to consolidate
on the driver side, but it's far cleaner and easier to understand for
all involved if it's a Qdisc. Qdiscs are tricky, but people still
understand them well in comparison.

>> - As any classful Qdisc, DRR supports adding classifiers to decide in wh=
ich
>>   class to enqueue packets. Unlike PRIO, there's however no fallback in =
the
>>   form of priomap. A way to achieve classification based on packet prior=
ity
>>   is e.g. like this:
>>
>>     # tc filter add dev swp1 root handle 1: \
>> 		basic match 'meta(priority eq 0)' flowid 1:10
>>
>>   Expressing the priomap in this manner however forces drivers to deep d=
ive
>>   into the classifier block to parse the individual rules.
>>
>>   A possible solution would be to extend the classes with a "defmap" a l=
a
>>   split / defmap mechanism of CBQ, and introduce this as a last resort
>>   classification. However, unlike priomap, this doesn't have the guarant=
ee
>>   of covering all priorities. Traffic whose priority is not covered is
>>   dropped by DRR as unclassified. But ASICs tend to implement dropping i=
n
>>   the ACL block, not in scheduling pipelines. The need to treat these
>>   configurations correctly (if only to decide to not offload at all)
>>   complicates a driver.
>>
>>   It's not clear how to retrofit priomap with all its benefits to DRR
>>   without changing it beyond recognition.
>>
>> - The interplay between PRIO and DRR is also causing problems. 802.1Qaz =
has
>>   all ETS TCs as a last resort. Switch ASICs that support ETS at all are
>>   likely to handle ETS traffic this way as well. However, the Linux mode=
l
>>   is more generic, allowing the DRR block in any band. Drivers would nee=
d
>>   to be careful to handle this case correctly, otherwise the offloaded
>>   model might not match the slow-path one.
>
> Yep, although cases already exist all over the offload side.
>>
>>   In a similar vein, PRIO and DRR need to agree on the list of prioritie=
s
>>   assigned to DRR. This is doubly problematic--the user needs to take ca=
re
>>   to keep the two in sync, and the driver needs to watch for any holes i=
n
>>   DRR coverage and treat the traffic correctly, as discussed above.
>>
>>   Note that at the time that DRR Qdisc is added, it has no classes, and
>>   thus any priorities assigned to that PRIO band are not covered. Thus t=
his
>>   case is surprisingly rather common, and needs to be handled gracefully=
 by
>>   the driver.
>>
>> - Similarly due to DRR flexibility, when a Qdisc (such as RED) is attach=
ed
>>   below it, it is not immediately clear which TC the class represents. T=
his
>>   is unlike PRIO with its straightforward classid scheme. When DRR is
>>   combined with PRIO, the relationship between classes and TCs gets even
>>   more murky.
>>
>>   This is a problem for users as well: the TC mapping is rather importan=
t
>>   for (devlink) shared buffer configuration and (ethtool) counters.
>>
>> So instead, this patch set introduces a new Qdisc, which is based on
>> 802.1Qaz wording. It is PRIO-like in how it is configured, meaning one
>> needs to specify how many bands there are, how many are strict and how m=
any
>> are ETS, quanta for the latter, and priomap.
>>
>> The new Qdisc operates like the PRIO / DRR combo would when configured a=
s
>> per the standard. The strict classes, if any, are tried for traffic firs=
t.
>> When there's no traffic in any of the strict queues, the ETS ones (if an=
y)
>> are treated in the same way as in DRR.
>>
>> The chosen interface makes the overall system both reasonably easy to
>> configure, and reasonably easy to offload. The extra code to support ETS=
 in
>> mlxsw (which already supports PRIO) is about 150 lines, of which perhaps=
 20
>> lines is bona fide new business logic.
>
> Sorry maybe obvious question but I couldn't sort it out. When the qdisc i=
s
> offloaded if packets are sent via software stack do they also hit the sw
> side qdisc enqueue logic? Or did I miss something in the graft logic that
> then skips adding the qdisc to software side? For example taprio has dequ=
eue
> logic for both offload and software cases but I don't see that here.

You mean the graft logic in the driver? All that stuff is in there just
to figure out how to configure the device. SW datapath packets are
still handled as usual.

There even is a selftest for the SW datapath that uses veth pairs to
implement interconnect and TBF to throttle it (so that the scheduling
kicks in).

>>
>> Credit-based shaping transmission selection algorithm can be configured =
by
>> adding a CBS Qdisc under one of the strict bands (e.g. TBF can be used t=
o a
>> similar effect as well). As a non-work-conserving Qdisc, CBS can't be
>> hooked under the ETS bands. This is detected and handled identically to =
DRR
>> Qdisc at runtime. Note that offloading CBS is not subject of this patchs=
et.
>
> Any performance data showing how accurate we get on software side? The
> advantage of hardware always to me seemed to be precision in the WRR algo=
rithm.

Quantum is specified as a number of bytes allowed to dequeue before a
queue loses the medium. Over time, the amount of traffic dequeued from
individual queues should average out to be the quanta your specified. At
any point in time, size of the packets matters: if I push 1000B packets
into a 10000B-quantum queue, it will use 100% of its allocation. If they
are 800B packets, there will be some waste (and it will compensate next
round).

As far as the Qdisc is defined, the SW side is as accurate as possible
under given traffic patterns. For HW, we translate to %, and rounding
might lead to artifacts. You kinda get the same deal with DCB, where
there's no way to split 100% among 8 TCs perfectly fairly.

> Also data showing how much overhead we get hit with from basic mq case
> would help me understand if this is even useful for software or just a
> exercise in building some offload logic.

So the Qdisc is written to do something reasonable in the SW datapath.
In that respect it's as useful as PRIO and DRR are. Not sure that as a
switch operator you really want to handle this much traffic on the CPU
though.

> FWIW I like the idea I meant to write an ETS sw qdisc for years with
> the expectation that it could get close enough to hardware offload case
> for most use cases, all but those that really need <5% tolerance or somet=
hing.
