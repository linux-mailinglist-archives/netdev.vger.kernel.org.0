Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA0F21B8DD
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGJOk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:40:29 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:50121
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726977AbgGJOk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 10:40:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBlltniqStzij2lFBGG3EirGKmmM53P5zqCJAXeZBe5hhpKkM798pGYTJwryMZxw4q2ssIi3TcwY/cldRrVt0RKszA6IrSAgqOcznjHwJSB3FAhj/YFhPpK3IzFz83W9r2QeeyBqsozN+PoOB3b3UsgUqBI926vo1MZCWCT3zLkUG9BXsal6vDs8kIPqMFgyig/3wZdWX80FBtgXfX/ahZ3L/Wh6iajQVRKtYjBmIyRFX16ElQDaOuPI4RezjYIIMtnOpszT9gO9vnesLhpfBEJazUw8MJPuh8KUS+D0amRF31NliT69Q4kiDkpJQHPpghCjgFe+XkVk3d7+bbbIXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ay4pU6gPxgCJLUe/jXAU5yXDP5G+QdG9LrZ75LdAylg=;
 b=Jh0iJGKKWMdI1hyuiI3Mld7nJ6UCIBCK+mv6lvClRFjJoMneOuKhAPQ0htexbgJZ5UKrp2kh7RZ3++JwBREW7HvKFwBnqin/XsKdq7KpduPzxX+czi8jH48g48Ip7/J9NMu8UUeFCi4z9y1TnFvHFdR+bQoFB9zN083UnYrWprYP6To4VA7FHGQo/hbSmo2U7JWTzUIpwVsUIJS2pyL44B5SHWukVm2B3ldf+QA86RWFuM1be3Y8lQMNCTRlI2ttr/fx8M5E6JTX1YUjpVq0pvrjxeX+WEoQqKob9QHrlQJ5oF8yau/eS2G38mNOWaFyj+ow976OQYYDJ8omljiWWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ay4pU6gPxgCJLUe/jXAU5yXDP5G+QdG9LrZ75LdAylg=;
 b=gWiLyZYwU9UeMw9dVvVQTKWoJavJPtEXsHC2mGrm05B70oaosk1HvTl0o2ReOoTuG7XHWfBGUENZqp6Sx93aSVhczOiC0d/5NPsdleNQt2geeJ2db62+e4K9pE9TQj6C7Je8PHHZJXpLFI5rPsuFuZvBBWCroYFbd2iLD+eE5w8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3193.eurprd05.prod.outlook.com (2603:10a6:7:2f::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 14:40:24 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 14:40:24 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com> <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com> <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com> <873662i3rc.fsf@mellanox.com> <CAM_iQpVs_OEBw54qMhn7Tx6_YAGh5PMSApj=RrO0j6ThSXpkcg@mail.gmail.com> <87wo3dhg63.fsf@mellanox.com> <87v9ixh7es.fsf@mellanox.com> <CAM_iQpU-fh9Saaxo+6juONn+Xd891sUhgaaoht0Bkn2ssAEm8A@mail.gmail.com>
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
In-reply-to: <CAM_iQpU-fh9Saaxo+6juONn+Xd891sUhgaaoht0Bkn2ssAEm8A@mail.gmail.com>
Date:   Fri, 10 Jul 2020 16:40:21 +0200
Message-ID: <875zavh1re.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0133.eurprd07.prod.outlook.com
 (2603:10a6:207:8::19) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM3PR07CA0133.eurprd07.prod.outlook.com (2603:10a6:207:8::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.14 via Frontend Transport; Fri, 10 Jul 2020 14:40:23 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 918e3761-1b14-4a7c-dbd0-08d824df2dae
X-MS-TrafficTypeDiagnostic: HE1PR05MB3193:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB31937B2812E582650042FE52DB650@HE1PR05MB3193.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VNH4fYvXmL730HSTyQWKji+IbZ8mogfVLZ2w/ZI4epzDJY4xysL0hVN0ylom0Yx6RiIaZlPKGAtmNOHFPwj3cexuGmU1AWcKULr32t42LbWmNydttN/sK2M2hP36QbgJ0xZtmYArHnQCe8SXHqG6TA15BpGvmOIm8qAgWSWderziTMVIBxN+av4ODdpEwhS0FE7/02tCM6vlTwZILC7XAtDvBLtYOT2gICAai+tfdG6U6RjTwYGNFr3KE3IKTXRhdsvPPXh7KAmffCemHYL7h0EbK+OCoQnnlas5VeYXURWGShA1Xab76A5RvWqn3ED6Y7hnWJ80gJRZFlqlUxZ+mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(956004)(316002)(2616005)(4326008)(26005)(186003)(16526019)(53546011)(52116002)(6496006)(107886003)(66946007)(83380400001)(66476007)(5660300002)(66556008)(478600001)(86362001)(8936002)(36756003)(54906003)(6916009)(6486002)(2906002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ggRGCdg3AiiruWGE2Po32jkDKDnOvwLGQ6vRhn3oY7WKaV+Do4vobVq47VHKaLr6aPwlJgmhteVElwNdGBSMjmEB/TH4A/4+438fxx5jfAgPSEx5QoWdczUJTazxr+/JU+cKBP74b3WE6q4v1bdBZH2X2/3xyyd9YU34fu7gYxKnqce3imjYzAOOqRxt/OL7zAX5dRFhgRdR8GlHMd3lIgnZtfCqV2mGMNLk6meO9eKNyrJAjjpObfVgsDWqe9yNZRNlVVE1/ZBJ8b4U/vJw2UcdpMG1aqUYgF9Lry+tC6ksxGUPUEsivkEAx+oM4OxYJHFbUYnUFV/whEhWM+qc/aCJPdfZLWmyTPzSFm+peNX7BSIa/TeXO76gDC7KXK8Yl4fixvVDj+E5fyJD59JbE9LuXYnTmh0fQ3/DMsIGwHVB4EIeBbJdTTjyM3+LHZJSoJtamd3mqxB44OV1xgu5JDc29VXD0I1FAFNVS7wUnZZBfio0PmN/XY1UgXC/eVkF
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 918e3761-1b14-4a7c-dbd0-08d824df2dae
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 14:40:23.8834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gt4OQkCCQZkjxODhEVJT3ejC9UPEbTjip9CtLPnEoo2CJ8IZG6HHMFCCBj46y0szHQ8dMPe6FwXgochovv+Emw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3193
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Wed, Jul 8, 2020 at 5:13 PM Petr Machata <petrm@mellanox.com> wrote:
>>
>>
>> Petr Machata <petrm@mellanox.com> writes:
>>
>> > Cong Wang <xiyou.wangcong@gmail.com> writes:
>> >
>> > I'll think about it some more. For now I will at least fix the lack of
>> > locking.
>>
>> I guess I could store smp_processor_id() that acquired the lock in
>> struct qdisc_skb_head. Do a trylock instead of lock, and on fail check
>> the stored value. I'll need to be careful about the race between
>> unsuccessful trylock and the test, and about making sure CPU ID doesn't
>> change after it is read. I'll probe this tomorrow.
>
> Like __netif_tx_lock(), right? Seems doable.

Good to see it actually used, I wasn't sure if the idea made sense :)

Unfortunately it is not enough.

Consider two threads (A, B) and two netdevices (eth0, eth1):

- "A" takes eth0's root lock and proceeds to classification
- "B" takes eth1's root lock and proceeds to classification
- "A" invokes mirror to eth1, waits on lock held by "B"
- "B" invakes mirror to eth0, waits on lock held by "A"
- Some say they are still waiting to this day.

So one option that I see is to just stash the mirrored packet in a queue
instead of delivering it right away:

- s/netif_receive_skb/netif_rx/ in act_mirred

- Reuse the RX queue for TX packets as well, differentiating the two by
  a bit in SKB CB. Then process_backlog() would call either
  __netif_receive_skb() or dev_queue_transmit().

- Drop mirred_rec_level guard.

This seems to work, but I might be missing something non-obvious, such
as CB actually being used for something already in that context. I would
really rather not introduce a second backlog queue just for mirred
though.

Since mirred_rec_level does not kick in anymore, the same packet can end
up being forwarded from the backlog queue, to the qdisc, and back to the
backlog queue, forever. But that seems OK, that's what the admin
configured, so that's what's happening.

If this is not a good idea for some reason, this might work as well:

- Convert the current root lock to an rw lock. Convert all current
  lockers to write lock (which should be safe), except of enqueue, which
  will take read lock. That will allow many concurrent threads to enter
  enqueue, or one thread several times, but it will exclude all other
  users.

  So this guards configuration access to the qdisc tree, makes sure
  qdiscs don't go away from under one's feet.

- Introduce another spin lock to guard the private data of the qdisc
  tree, counters etc., things that even two concurrent enqueue
  operations shouldn't trample on. Enqueue takes this spin lock after
  read-locking the root lock. act_mirred drops it before injecting the
  packet and takes it again afterwards.

Any opinions y'all?
