Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D3F21EC65
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgGNJMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:12:48 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:59520
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725833AbgGNJMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 05:12:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mnudd7XkrHw4Ij0gDEHwnb7qm6E3Y5hq2K7mDHRWivQrtdR4YON3Y7Zjw2d+3dUGVHe+vMxF8TM60yvZV9tfEaq6tccYZEE6bFgsS7qzupFWpL6o24Jmi6Psdf/3IHbR1E7Un0RZSmLY9+j5Dxzi3uAQiphWM5zVGpadDa83tPTIlwpbS+ExTnH9Cmse5YwdE+OS61RLVsXVg7S3GgMoocdYA/Ks5OYq63FiWvwFKoX1KQct5WcD9zZiuAkRkqmCw7xhn1cqn3uNnVnIXadzyR2uwTm+jrNvTFhU3H0uMHKqxwNBv/IMGGKT0J3t0vQ2mIFx6myPrJFAMRgm1tTVBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egoU0Gmh4kTppTTE7zSpgYO1OGpgLEvy9ygxMwD52hU=;
 b=XSQy1S8Ivx3HSqnG4XfWX0ngve2PEUWzS8gBiAC3/eGMgAexZQ/UVN8thh7xYj19sbHyTZDNG46QinjU4QF44DgM9Yu1qEy7ZWmk9FK632DMI9pcJIcqTUlp/kmFSawf7/11/umMygSS1eD40zgi+JcO6EskYpiqt3D73syT7MOS0QJWVMw1Pz8rvG7uUAEt+VTXrMeW0dL2AdY+uozqWH6y2Y54PcSk0gx8mGHzVg5YRA424xuVcRXEWAJSzxCIVwKktNQ+3qJEu0ND6gv1PgxAuBD5jbL4ezPDhZHWCMrbe3G/+JvFL1OM5GlVFE8UQ4W5fCd70H4VLtgiXDAu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egoU0Gmh4kTppTTE7zSpgYO1OGpgLEvy9ygxMwD52hU=;
 b=SqSsG1Y+2LmfLOfCtW+cwu9k0kPqKD2MU3/GbFNYsgTQtArQPvX4G3iMVUwuwyRk5X+yxLzMFcjxqXhmOZesSmZxfH9DI4QNNsY45AKT4cBW0n+B8Q2U/dsvFmUG3qHwiMt/jTIUMbkoJ5XfJmtSdqvFp6eTrSTJW0rSA+Itggg=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3113.eurprd05.prod.outlook.com (2603:10a6:3:d7::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Tue, 14 Jul 2020 09:12:42 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 09:12:42 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com> <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com> <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com> <873662i3rc.fsf@mellanox.com> <CAM_iQpVs_OEBw54qMhn7Tx6_YAGh5PMSApj=RrO0j6ThSXpkcg@mail.gmail.com> <87wo3dhg63.fsf@mellanox.com> <87v9ixh7es.fsf@mellanox.com> <CAM_iQpU-fh9Saaxo+6juONn+Xd891sUhgaaoht0Bkn2ssAEm8A@mail.gmail.com> <875zavh1re.fsf@mellanox.com> <CAM_iQpUi-aKBLF5MkkSkCBchHeK5a_8OEDw3eXHZ4yPo=_hvsQ@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v1 2/5] net: sched: Introduce helpers for qevent blocks
In-reply-to: <CAM_iQpUi-aKBLF5MkkSkCBchHeK5a_8OEDw3eXHZ4yPo=_hvsQ@mail.gmail.com>
Date:   Tue, 14 Jul 2020 11:12:38 +0200
Message-ID: <877dv6jw8p.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0016.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::29) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by AM0PR02CA0016.eurprd02.prod.outlook.com (2603:10a6:208:3e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Tue, 14 Jul 2020 09:12:40 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e2c6c325-e1f9-4d21-53b9-08d827d60fbd
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3113:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB31139AFD1C5326597C556B89DB610@HE1PR0502MB3113.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hKcXrQFCXzii8OJLQqpvrcJ9dQy2kEgqOpgIVchQ4WFmloreayJnRxhtrLLHhbG5gI/9V7kGv0BZ68bVQaG9AXs/DMvIsg0yT74Y4CwlsWIciqr3n0wlJ6IkG92KIHTzMnkyMhCBrWSqR4xkJ+bpq5mngWnJ2cPUT0muaP3dbyJXaFV1wYS7x5TBKiwgh2z1bA+vz0jwIzfXF0PrELjMs00WXvLWQSPtZKdCLvm2aQEB5Eu8BLsd90TBWsypTbxTSC9bOn3mMAJvefGNzJ9TgJcne7oF035ce59575l0ZysZW7Vs2CiobBgIZr5e46dJ2bLVxw3RDA3ceL+hi3QUiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(52116002)(2616005)(66574015)(316002)(2906002)(6486002)(36756003)(4326008)(54906003)(956004)(66556008)(107886003)(6916009)(8936002)(83380400001)(6496006)(66946007)(66476007)(186003)(26005)(86362001)(5660300002)(16526019)(53546011)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: xaByUJE+1iW1PyQd77x1X4s/K0ePM3ext87x+gIDhs7xLg3cSt3xCwq3iSbZJ+Kqw4ci6CBSr+vFg6RtT6yvlId40/bgx6vp+kz15xi4zFlZW8gE2FFoIFLoTFOgBfIXn1sgGays4lHQNvhxgE9MI6I93F8s6W1U7gJNrUV11T59nS5HOE3zxH1MWaApaL8LYzSCpJNTpLaWO7k77BMiW+5SfRGsgGljZnIij80ByUb1Bn8vrGidHYnyK7XfHZLvbOZXTKqKy9Gq3WGylAwADiWhCNzf85p1noO8mpM/eQ0sTjdBlDLJkTPPdu5CmAW0l2RVEU3PDDeegd/pPkr5TxgsxyXrae1nH/Gj/c9U0ELBRsB9sZgMvghTKMWwpn5NFtYNd8giBIl7igPJ0WNsXh77R+LTgAQp26H6TPjlXFe7T4lDP7lN9EbsYl5Oc4tQjbanRzUcvQC2m4IOW3/ipJYlvIO4PFfoHc4N+RPPOiS5zgdO/OaFcE+tEIq87i13
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2c6c325-e1f9-4d21-53b9-08d827d60fbd
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 09:12:42.0521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i60PrQZ4vkF6BC2CU8EV8TYlvkioZDiDz60HW0H8kYN0eFiVwTutROvaxi3ADlL4WEix1OI/tnsnDRu6zOJvZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3113
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Fri, Jul 10, 2020 at 7:40 AM Petr Machata <petrm@mellanox.com> wrote:
>>
>>
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>
>> > On Wed, Jul 8, 2020 at 5:13 PM Petr Machata <petrm@mellanox.com> wrote:
>> >>
>> >>
>> >> Petr Machata <petrm@mellanox.com> writes:
>> >>
>> >> > Cong Wang <xiyou.wangcong@gmail.com> writes:
>> >> >
>> >> > I'll think about it some more. For now I will at least fix the lack of
>> >> > locking.
>> >>
>> >> I guess I could store smp_processor_id() that acquired the lock in
>> >> struct qdisc_skb_head. Do a trylock instead of lock, and on fail check
>> >> the stored value. I'll need to be careful about the race between
>> >> unsuccessful trylock and the test, and about making sure CPU ID doesn't
>> >> change after it is read. I'll probe this tomorrow.
>> >
>> > Like __netif_tx_lock(), right? Seems doable.
>>
>> Good to see it actually used, I wasn't sure if the idea made sense :)
>>
>> Unfortunately it is not enough.
>>
>> Consider two threads (A, B) and two netdevices (eth0, eth1):
>>
>> - "A" takes eth0's root lock and proceeds to classification
>> - "B" takes eth1's root lock and proceeds to classification
>> - "A" invokes mirror to eth1, waits on lock held by "B"
>> - "B" invakes mirror to eth0, waits on lock held by "A"
>> - Some say they are still waiting to this day.
>
> Sure, AA or ABBA deadlock.
>
>>
>> So one option that I see is to just stash the mirrored packet in a queue
>> instead of delivering it right away:
>>
>> - s/netif_receive_skb/netif_rx/ in act_mirred
>>
>> - Reuse the RX queue for TX packets as well, differentiating the two by
>>   a bit in SKB CB. Then process_backlog() would call either
>>   __netif_receive_skb() or dev_queue_transmit().
>>
>> - Drop mirred_rec_level guard.
>
> I don't think I follow you, the root qdisc lock is on egress which has
> nothing to do with ingress, so I don't see how netif_rx() is even involved.

netif_rx() isn't, but __netif_receive_skb() is, and that can lead to the
deadlock as well when another mirred redirects it back to the locked
egress queue.

So a way to solve "mirred ingress dev" action deadlock is to
s/netif_receive_skb/netif_rx/. I.e. don't resolve the mirror right away,
go through the per-CPU queue.

Then "mirred egress dev" could be fixed similarly by repurposing the
queue for both ingress and egress, differentiating ingress packets from
egress ones by a bit in SKB CB.

>>
>> This seems to work, but I might be missing something non-obvious, such
>> as CB actually being used for something already in that context. I would
>> really rather not introduce a second backlog queue just for mirred
>> though.
>>
>> Since mirred_rec_level does not kick in anymore, the same packet can end
>> up being forwarded from the backlog queue, to the qdisc, and back to the
>> backlog queue, forever. But that seems OK, that's what the admin
>> configured, so that's what's happening.
>>
>> If this is not a good idea for some reason, this might work as well:
>>
>> - Convert the current root lock to an rw lock. Convert all current
>>   lockers to write lock (which should be safe), except of enqueue, which
>>   will take read lock. That will allow many concurrent threads to enter
>>   enqueue, or one thread several times, but it will exclude all other
>>   users.
>
> Are you sure we can parallelize enqueue()? They all need to move
> skb into some queue, which is not able to parallelize with just a read
> lock. Even the "lockless" qdisc takes a spinlock, r->producer_lock,
> for enqueue().

That's why the second spin lock is for. In guards private data,
including the queues.

>>
>>   So this guards configuration access to the qdisc tree, makes sure
>>   qdiscs don't go away from under one's feet.
>>
>> - Introduce another spin lock to guard the private data of the qdisc
>>   tree, counters etc., things that even two concurrent enqueue
>>   operations shouldn't trample on. Enqueue takes this spin lock after
>>   read-locking the root lock. act_mirred drops it before injecting the
>>   packet and takes it again afterwards.
>>
>> Any opinions y'all?
>
> I thought about forbidding mirror/redirecting to the same device,
> but there might be some legitimate use cases of such. So, I don't

Yes, and also that's not enough:

- A chain of mirreds can achieve the deadlocks as well (i.e. mirror to
  eth1, redirect back to eth0). Or the ABA case shown above, where it's
  two actions that don't even work with the same packets causing the
  deadlock.

- I suspect general forwarding could cause this deadlock as well. E.g.
  redirecting to ingress of a device, where bridge, router take over and
  bring the packet back to egress. I have not tried reproducing this
  though, maybe there's a queue or delayed work etc. somewhere in there
  that makes this not an issue.

> have any other ideas yet, perhaps there is some way to refactor
> dev_queue_xmit() to avoid this deadlock.
