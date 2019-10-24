Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6182EE3A91
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503965AbfJXSD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:03:59 -0400
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:15013
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406106AbfJXSD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 14:03:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJLFXOgTwetR9x03wArwwxs/JJmHoQpJwuLxo8ghOogYKxvcOcfrl/UGPwGNmBftV3ikhSl8VUoDPEnIc6wwHSN5achHXZDQpKv6u9jI0acthMsM52uZ8pcP5R96buG5a/0TDfJ4EPwXPcEExZm2Oll6EP0oW2mMH1JwOzg/6g65tsDvU9rKNud13i+9rJA2Vdh/Ykl7yVwgLkIc1dNlJfLFhffKgTIeHMhp8XaNmLe5ZvRv7ij7OmotdbGcIq0eYpEx4BCDN5hks2fZpB9S7uc9q6Z2nLEMotdCc2XGqDe9rzWVz1ed0VF2ucgaSnOrBQHULQ5dUOrUqriaCLuDrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0i8j8e+9b6yd3nskya87YRsIvfdniJVB5zE7j1u5aM=;
 b=Zj8ZDRjLX5z5UxJvg18iutcAWJ0xB2KVUmOmttI35CQW6c++rwCMo7r/nexLHN38c7rrPNxwTLgjlofBGs5QqjhfoI4d/AHVBG6JEpxRNhXspRDuUqJ/PfJPyG9IQ+XLXMUxltRWnbnew4+1RCJITXGkBsMHy5MGnW8hqoKaZZbQooWmPpY6FM8VKLS1sUMgfh2YfpPuCRUF09t4Ayki09TOutfVIygLFx6G4dKnxb21XoyJT3YXtDKatKz4UM/bTQLMr1/tGx5D+3jDMt4CGrjSA6MkH5wx+jtN+vqv7BZ7PHjP/syZjf1tn2GV3rLI9macUIW+srWAlOtXKdrEzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0i8j8e+9b6yd3nskya87YRsIvfdniJVB5zE7j1u5aM=;
 b=Qul4bQELrTihb40YlKrO1q0QWFLoaWP1UeRyQ+MpeV/oPnUpZMRHQspiQKyz3oZeKMumItVA57uBX6/cL7iEc6DMalrpZYjuOdPp4madDtsZHXOFut17xf6CqGL6Y+Q3FjV0ALOOhUNXxjfRWs7NYGTtXpkDySrOWSQsMegZAX8=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5455.eurprd05.prod.outlook.com (20.177.201.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Thu, 24 Oct 2019 18:03:52 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2387.021; Thu, 24 Oct 2019
 18:03:52 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Topic: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
Thread-Index: AQHViOOkkjw7TmA4ukWSexbeE6ZJ+6dmxUYAgAAKWoCAABWbgIADA/gAgAABcYCAACVkgIAACPUA
Date:   Thu, 24 Oct 2019 18:03:52 +0000
Message-ID: <vbftv7y6mwr.fsf@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <20191022151524.GZ4321@localhost.localdomain> <vbflftcwzes.fsf@mellanox.com>
 <20191022170947.GA4321@localhost.localdomain>
 <CAJieiUiDC7U7cGDadSr1L8gUxS6QiW=x9+pkp=8thxbMsMYVCQ@mail.gmail.com>
 <vbfy2xauq8s.fsf@mellanox.com> <20191024173145.GO4321@localhost.localdomain>
In-Reply-To: <20191024173145.GO4321@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0042.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::30) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 03e2f2a7-3123-4bcc-eef1-08d758ac876b
x-ms-traffictypediagnostic: VI1PR05MB5455:|VI1PR05MB5455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5455A9A63FC0EE46A2256FA3AD6A0@VI1PR05MB5455.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(26005)(316002)(446003)(6512007)(3846002)(478600001)(6486002)(25786009)(54906003)(229853002)(14454004)(186003)(6436002)(99286004)(6916009)(66066001)(8676002)(66476007)(66556008)(64756008)(66446008)(2616005)(102836004)(66946007)(11346002)(2906002)(52116002)(6246003)(7736002)(81156014)(81166006)(8936002)(476003)(76176011)(6116002)(5660300002)(53546011)(486006)(305945005)(36756003)(4326008)(14444005)(256004)(86362001)(6506007)(386003)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5455;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mEJpd2p/WxrNHnysROK5Le7NlpNuJBbfoenvubShHlNxz1wCr9D2Q0zyFltAjOmshrvqz1U9ZieWHynXmqfVUMUua1uJOoB+EQ5x25BJEH0TIAPNvQsSQeZKXH+z2iTRSeUmkoHAmuUCvsjGIPtfFmOLtL5PpMTtiyDo4feM1CgrJ+6LAbPrU44Q0RCsCs8qg0SFcH7+1OuHnGcvIhHXei014p9GALJybwj2Q11QlTtVbRmbuC2DJURJhOOPgGZb4ZKe3fJ6Wqn+9TqXq7JfsvPC1kEENltV/MXRp89UC/X2tfXPyJj4X5pHZ2dElJX2+nq2BT0vkrOVOQJRHQlVVI+zZH/V86UmLkPG/v+HaHNCksBwLrgMFAw3/dv0tNYVpfh67rsTNgUMyvOwlp3uLv7aXKTpFj7d37h/ntRgAqEFog1oPj/MSyqu7vuX3Fxa
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e2f2a7-3123-4bcc-eef1-08d758ac876b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 18:03:52.7190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EyzxIEsri2XVTCRw18QD+F6yRuji2yTIICocRR3vKPykuaLSaealrbMU+Lz8qSGbcytN76LwKZKOWLOChzAhMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5455
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 24 Oct 2019 at 20:31, Marcelo Ricardo Leitner <mleitner@redhat.com> =
wrote:
> On Thu, Oct 24, 2019 at 03:18:00PM +0000, Vlad Buslov wrote:
>>
>> On Thu 24 Oct 2019 at 18:12, Roopa Prabhu <roopa@cumulusnetworks.com> wr=
ote:
>> > On Tue, Oct 22, 2019 at 10:10 AM Marcelo Ricardo Leitner
>> > <mleitner@redhat.com> wrote:
>> >>
>> >> On Tue, Oct 22, 2019 at 03:52:31PM +0000, Vlad Buslov wrote:
>> >> >
>> >> > On Tue 22 Oct 2019 at 18:15, Marcelo Ricardo Leitner <mleitner@redh=
at.com> wrote:
>> >> > > On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
>> >> > >> - Extend actions that are used for hardware offloads with option=
al
>> >> > >>   netlink 32bit flags field. Add TCA_ACT_FLAGS_FAST_INIT action =
flag and
>> >> > >>   update affected actions to not allocate percpu counters when t=
he flag
>> >> > >>   is set.
>> >> > >
>> >> > > I just went over all the patches and they mostly make sense to me=
. So
>> >> > > far the only point I'm uncertain of is the naming of the flag,
>> >> > > "fast_init".  That is not clear on what it does and can be overlo=
aded
>> >> > > with other stuff later and we probably don't want that.
>> >> >
>> >> > I intentionally named it like that because I do want to overload it=
 with
>> >> > other stuff in future, instead of adding new flag value for every s=
ingle
>> >> > small optimization we might come up with :)
>> >>
>> >> Hah :-)
>> >>
>> >> >
>> >> > Also, I didn't want to hardcode implementation details into UAPI th=
at we
>> >> > will have to maintain for long time after percpu allocator in kerne=
l is
>> >> > potentially replaced with something new and better (like idr is bei=
ng
>> >> > replaced with xarray now, for example)
>> >>
>> >> I see. OTOH, this also means that the UAPI here would be unstable
>> >> (different meanings over time for the same call), and hopefully new
>> >> behaviors would always be backwards compatible.
>> >
>> > +1, I also think optimization flags should be specific to what they op=
timize.
>> > TCA_ACT_FLAGS_NO_PERCPU_STATS seems like a better choice. It allows
>> > user to explicitly request for it.
>>
>> Why would user care about details of optimizations that doesn't produce
>> visible side effects for user land? Again, counters continue to work the
>> same with or without the flag.
>
> It's just just details of optimizations, on whether to use likely() or
> not, and it does produce user visible effects. Not in terms of API but
> of system behavior. Otherwise we wouldn't need the flag, right?
> _FAST_INIT, or the fact that it inits faster, is just one of the
> aspects of it, but one could also want it for being lighther in
> footprint as currently it is really easy to eat Gigs of RAM away on
> these percpu counters. So how should it be called, _FAST_INIT or
> _SLIM_RULES?

Hmm, yes, I think I emphasize insertion rate too much because it was my
main goal, but memory usage is also important.

>
> It may be implementation detail, yes, but we shouldn't be building
> usage profiles and instead let the user pick what they want. Likewise,
> we don't have net.ipv4.fast_tcp, but net.ipv4.tcp_sack, tcp_timestamps
> & cia.
>
> If we can find another name then, without using 'percpu' on it but
> without stablishing profiles, that would be nice.
> Like TCA_ACT_FLAGS_SIMPLE_STATS, or so.
>
> Even though I still prefer the PERCPU, as it's as explicit as it can be. =
Note
> that bpf does it like that already:
> uapi]$ grep BPF.*HASH -- linux/bpf.h
>         BPF_MAP_TYPE_HASH,
>         BPF_MAP_TYPE_PERCPU_HASH,
>         BPF_MAP_TYPE_LRU_HASH,
>         BPF_MAP_TYPE_LRU_PERCPU_HASH,
> ...

I would argue that all of these produce visible side effect for the
user. Selective acks are clearly visible in packet dumps, BPF maps are
directly accessed from BPF programs loaded from user space, etc. But I
get your point that naming can be improved from FAST_INIT which is too
abstract.
