Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596E5CAB37
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390459AbfJCRT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:19:27 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:32898
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730582AbfJCRT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 13:19:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djwkjZ62lwh0L9c29AXfqXZX3PWJ5pxz5uB2bZXOIaZ3tCZvByEBGWcn6NeWvbx7+Z5mlF2u7yQ3NPsxvlBRPYIYFVqKE85ihpyRsOL60f1etg0I6YtcCULKZth+uwUezz2xoruT2eny+sKi49uVQRQhjMxa4cyDwT79//KWB5WETcYBUtr6ETW0rs5Yr4lzfDYuMoc6o8nwuvAXXQu228NwpjKbrc3arcdKI6XKGqBHNsflaVku2G2+RJYuNC/KlrBT3h42q9OC2QArN42wOgVVFFsfrlIMwPp9K8+ezbEdpxmV0kKsvVxEuSYUwanqQGzORTKK7sD7EegoWBjx6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Miyz8Uyf3r5gwcnsHIgPQBsaTzAPSySpYq1y185Tjiw=;
 b=oaNpESYLw7naIDISGxqIUPmT3yzbry/pog6KDYkt1y7UDDnb2VdrSQcEA4IMy0uLaYUJOBnE7Kempx8ZPRBmMguQ6RHKBgib2tB9BaWCzmrW9SPUUMOS5r72c1DfwyUyN2uD/tADq1NMC2XLnQ5Mmvqdng6hAE/YGXAl2WRsmEigOp8smwYZNrmkHiliPqB6Bntc1WN9RAA0ftV6rorox9x8iHT13ntstIYcurZhFzY7sQIbPOyW/EY+sBwBZdxDSM+lAje6Zn5j6DqZydHYPBXfqa4TjrXboRJFNpQM6CGiKoJDzJs7meK4xVphYM4XRwAypb2U4uTMbjw+PhKUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Miyz8Uyf3r5gwcnsHIgPQBsaTzAPSySpYq1y185Tjiw=;
 b=b058Y9KNqHWCHDelg67GWCOW5IbhcCe1yjn5R3QLpoIqLxlb3TL8CvXbSls6rEKUf7ZjXUEnKQPIaBgg/bn1vaHyrNR1IO/OyMi8Q/EONWKj7kMLl+XVf/8/mgf/OlMG3hWY3PUiLQSGAQ06oul16/66v3a491YJQS+73LZgmJc=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6174.eurprd05.prod.outlook.com (20.178.123.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 17:19:22 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 17:19:22 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     John Hurley <john.hurley@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [RFC net-next 0/2] prevent sync issues with hw offload of flower
Thread-Topic: [RFC net-next 0/2] prevent sync issues with hw offload of flower
Thread-Index: AQHVeXc5O/tBF1cs/0KKA2t1J+rpTKdJG6uAgAAJVgCAAAVwAA==
Date:   Thu, 3 Oct 2019 17:19:22 +0000
Message-ID: <vbfimp5oig9.fsf@mellanox.com>
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
 <vbfk19lokwe.fsf@mellanox.com>
 <CAK+XE=mjARd+DodNg9Sn4C+gg6dMTmvdNrKtEYhsLGVqtGrysw@mail.gmail.com>
In-Reply-To: <CAK+XE=mjARd+DodNg9Sn4C+gg6dMTmvdNrKtEYhsLGVqtGrysw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0067.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::31) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d21cd76d-c480-43f0-127a-08d74825d4ec
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB6174:|VI1PR05MB6174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB617402F294FD5C3532683398AD9F0@VI1PR05MB6174.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(51914003)(199004)(189003)(446003)(86362001)(14454004)(52116002)(71200400001)(25786009)(2616005)(76176011)(71190400001)(6916009)(66066001)(3846002)(6246003)(26005)(53546011)(4326008)(36756003)(6116002)(99286004)(102836004)(186003)(6506007)(14444005)(256004)(7736002)(476003)(2906002)(6486002)(6512007)(305945005)(54906003)(6436002)(8936002)(229853002)(316002)(11346002)(66946007)(478600001)(81156014)(5660300002)(64756008)(66556008)(66476007)(81166006)(66446008)(386003)(8676002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6174;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TP72JmcriI4mhB54Jyb/9gHsuCKpTjvNnmEr0b8C3K20dqQbaEY+8zs4VxdGJoMqmQFx81OO28ep5/BMPoIGqx9ilTtjpsKRwKas0yz3XbmPnvUAU98MK+KD1db38U1Ox9IGvZL8fL5hvqzAbbJi8E9K/g+dhEZogNnwtxsIWI4TzuJIplcD5CFwtNSn/4pFRRv1n/WdmdQj7ZkuCPGoavd0ocyn0b8HRR8e3tyXx9HvHrWKQiSkELnC1TAACpCWnAm7qG7V8ehcsi95j3cIS/WoIgunlpmxWkdXELzo8H+cA+ERo08LDNhzebMo1r+h8QwnrVNJaCsZpUhK/rbtQEuCqkLwV7Dv/tUOgG1tyPtG8LHjy4B56Psdz4afIE+iHN03jADq/OBxaPLdLABil5RKBSF5SmkaN0fDHTeg0Xs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d21cd76d-c480-43f0-127a-08d74825d4ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 17:19:22.0874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zwwtStm64+XVFi2sEmHH72swn/g01xyTXp28mN7mYfIGl0CPs3wXSazKZubLeBx8j85n2XA87AaSsQVpXkP5bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 03 Oct 2019 at 19:59, John Hurley <john.hurley@netronome.com> wrote:
> On Thu, Oct 3, 2019 at 5:26 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>>
>> On Thu 03 Oct 2019 at 02:14, John Hurley <john.hurley@netronome.com> wro=
te:
>> > Hi,
>> >
>> > Putting this out an RFC built on net-next. It fixes some issues
>> > discovered in testing when using the TC API of OvS to generate flower
>> > rules and subsequently offloading them to HW. Rules seen contain the s=
ame
>> > match fields or may be rule modifications run as a delete plus an add.
>> > We're seeing race conditions whereby the rules present in kernel flowe=
r
>> > are out of sync with those offloaded. Note that there are some issues
>> > that will need fixed in the RFC before it becomes a patch such as
>> > potential races between releasing locks and re-taking them. However, I=
'm
>> > putting this out for comments or potential alternative solutions.
>> >
>> > The main cause of the races seem to be in the chain table of cls_api. =
If
>> > a tcf_proto is destroyed then it is removed from its chain. If a new
>> > filter is then added to the same chain with the same priority and prot=
ocol
>> > a new tcf_proto will be created - this may happen before the first is
>> > fully removed and the hw offload message sent to the driver. In cls_fl=
ower
>> > this means that the fl_ht_insert_unique() function can pass as its
>> > hashtable is associated with the tcf_proto. We are then in a position
>> > where the 'delete' and the 'add' are in a race to get offloaded. We al=
so
>> > noticed that doing an offload add, then checking if a tcf_proto is
>> > concurrently deleting, then remove the offload if it is, can extend th=
e
>> > out of order messages. Drivers do not expect to get duplicate rules.
>> > However, the kernel TC datapath they are not duplicates so we can get =
out
>> > of sync here.
>> >
>> > The RFC fixes this by adding a pre_destroy hook to cls_api that is cal=
led
>> > when a tcf_proto is signaled to be destroyed but before it is removed =
from
>> > its chain (which is essentially the lock for allowing duplicates in
>> > flower). Flower then uses this new hook to send the hw delete messages
>> > from tcf_proto destroys, preventing them racing with duplicate adds. I=
t
>> > also moves the check for 'deleting' to before the sending the hw add
>> > message.
>> >
>> > John Hurley (2):
>> >   net: sched: add tp_op for pre_destroy
>> >   net: sched: fix tp destroy race conditions in flower
>> >
>> >  include/net/sch_generic.h |  3 +++
>> >  net/sched/cls_api.c       | 29 ++++++++++++++++++++++++-
>> >  net/sched/cls_flower.c    | 55 ++++++++++++++++++++++++++------------=
---------
>> >  3 files changed, 61 insertions(+), 26 deletions(-)
>>
>> Hi John,
>>
>> Thanks for working on this!
>>
>> Are there any other sources for race conditions described in this
>> letter? When you describe tcf_proto deletion you say "main cause" but
>> don't provide any others. If tcf_proto is the only problematic part,
>
> Hi Vlad,
> Thanks for the input.
> The tcf_proto deletion was the cause from the tests we ran. That's not
> to say there are not more I wasn't seeing in my analysis.
>
>> then it might be worth to look into alternative ways to force concurrent
>> users to wait for proto deletion/destruction to be properly finished.
>> Maybe having some table that maps chain id + prio to completion would be
>> simpler approach? With such infra tcf_proto_create() can wait for
>> previous proto with same prio and chain to be fully destroyed (including
>> offloads) before creating a new one.
>
> I think a problem with this is that the chain removal functions call
> tcf_proto_put() (which calls destroy when ref is 0) so, if other
> concurrent processes (like a dump) have references to the tcf_proto
> then we may not get the hw offload even by the time the chain deletion
> function has finished. We would need to make sure this was tracked -
> say after the tcf_proto_destroy function has completed.
> How would you suggest doing the wait? With a replay flag as happens in
> some other places?
>
> To me it seems the main problem is that the tcf_proto being in a chain
> almost acts like the lock to prevent duplicates filters getting to the
> driver. We need some mechanism to ensure a delete has made it to HW
> before we release this 'lock'.

Maybe something like:

1. Extend block with hash table with key being chain id and prio
combined and value is some structure that contains struct completion
(completed in tcf_proto_destroy() where we sure that all rules were
removed from hw) and a reference counter.

2. When cls API wants to delete proto instance
(tcf_chain_tp_delete_empty(), chain flush, etc.), new member is added to
table from 1. with chain+prio of proto that is being deleted (atomically
with detaching of proto from chain).

3. When inserting new proto, verify that there are no corresponding
entry in hash table with same chain+prio. If there is, increment
reference counter and wait for completion. Release reference counter
when completed.

>
>>
>> Regards,
>> Vlad
