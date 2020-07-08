Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA5D218CDB
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgGHQVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:21:21 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:6070
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730498AbgGHQVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 12:21:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUZYXs/AIA0OeX3QMqsdwaAdp70RbF1OimnNE8e5ImdrGWge7I8Syf+Hq6rXbeYTcxubtArasogTAaTeLnetfcjqgaDHhFCuMODYVgRLgdwx+VWs+GVzqqkrocEvKOLl8u7xbmUrTRBLhlOXllbT9G+N3vY00X+4d43RAwWYu8aXRcO03jxvYcu/KL7xBiFuhzqKM8Rj8QI2lKbmeEaHFoZgBvV+2fzRrQoCF+UR7JCwCkatyFwDcYxE105MeYXeyno5k533QDjb85KX0ZLbSjleaPn2lFE2/W7FCzRRQ2RoHq4YNM0dXmtfqhix7aAlA8OBG6wmBaM9PUIB8BVjhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veKp0biVWoHLf4rbh5y9jXYBJeRkqbafgOFDkLfMbeE=;
 b=fMPOTT4FLr+lDYfCoC4X1JCe46v9Vmow66CbAxr19clOi+KB+pXV/CsWlnDD+FY6QNrioTeLGTqVxPIwhQep58RNKVZXt9TO4+sFJnEFa5aO6cWMsy3JfhPEM8CmmzLcUa118mWp6hsMGoNne3qv87sFevoj9ZsAr7mu4DaUo2YoR/ibTAa96ygOsqS/vi1YRCAW1LWaNZayCT61kcFHYZybBPpXfvwpRxORHDgqwkr3PPjswCa+ESjl+8CHl2aauLU/7A5NCAhjIxDdNQnbhiIjsmX47oCNE2OXDjltwwybrPP41hK4c0Y6pfSkyG8uSIayT8QIEpW9tJQ9HHPzwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=veKp0biVWoHLf4rbh5y9jXYBJeRkqbafgOFDkLfMbeE=;
 b=YZrkKnsNDdObfB6kJY/9UAbVjigwKhVJtmC9UxcWo1QDUBRo772crv0KQyuKkRqA2xCrm3pDdgHsnPoUnt6I0OSE13yhqgJx8CkVjaYVmUqlhhePbWrDMkSRsomC2iPR8MZ0Y5grMRDFaFLqxGUf4C/Bgbvt+vCGFsABsY7Mk5w=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3722.eurprd05.prod.outlook.com (2603:10a6:7:85::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Wed, 8 Jul 2020 16:21:17 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 16:21:17 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com> <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com> <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com> <873662i3rc.fsf@mellanox.com>
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
In-reply-to: <873662i3rc.fsf@mellanox.com>
Date:   Wed, 08 Jul 2020 18:21:12 +0200
Message-ID: <87y2nugepz.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0131.eurprd05.prod.outlook.com
 (2603:10a6:207:2::33) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (46.135.29.132) by AM3PR05CA0131.eurprd05.prod.outlook.com (2603:10a6:207:2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 16:21:15 +0000
X-Originating-IP: [46.135.29.132]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 005aca01-4890-425c-99b0-08d8235af0de
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3722:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB3722A9A92030BDA7BE6A952BDB670@HE1PR0502MB3722.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pmWKlNaSiiWyQs9k3UB0smVW5UepG4VkG3gy4KBErWLDfzNkiLJuId02cp6XhrB863f67s3XvHJj4/0ZT+btJSI90rlw2BRsSYi8YsOLEpEEMTwyZzXY6VgT0Pxg9M1hovl0RG7OKqYqpK2V/2ewL6zw6L70sVwS4/Wrjdr4o6idfo9tAPaGX9H1GyugLHLpQUhsXvUlyvMF/wt+v2pHyLDkLlpW9bI7kKFJvDSorPQ1wNHFDEXvNodFY18T5R+X1+CbeiYN5cGVJd9wvIWY0zN6iTiR1sRcWATvIP6LFnirg74Z4EYFDC1dECBqdQc60VosDBa8gV/FQFwB2pniVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(316002)(4326008)(53546011)(6666004)(26005)(186003)(2616005)(956004)(16526019)(83380400001)(478600001)(8676002)(107886003)(6916009)(8936002)(52116002)(54906003)(86362001)(66946007)(66476007)(2906002)(6496006)(5660300002)(66556008)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5QnmX/ug4h73kUAX7I+tnP9Km6tXWkQsNk82/kI64Pg1qkFayI3w1XdOzwzbGSOX4KUttUCYcNdDdl3Eb4JbV3R5gJXaqaSgobPeAKUleIEbvuK9e3RA+xUF9uK7VYyiZvlh663PDmpHJcnar39FNvyAEhImMQZKR+84ZM3GN+JzSvW1db00bO8LSMNY5wJTnUnMcMQscnHR7Kz4SMlEcUwS2xFKdNWm8/DTtb2/Kx7KNW/2/LM0YwOl4QRW4lESl5sq/RDO/Bp8y9MUJhMsNIO4dLZ8gr/sqwNYgE0Uv6ycTCb5f9adtIfv/M1cwa7T4e/HUHJTn0gRqdIrJkx79kuEdqrfU0MTRTfDn9PI6P2TKrYQ+n7beiEOaJ5fqv/8m7FqhFf3vu+a3+Rrm5dO1UwDeu+IXVNm6w1uGm0kHmes/wTrPYPCpi7aL6JUygaP24EEDe6SA9HF6vOt+xgCEoWuo3xY+1hY3w5i9Ku8R7M=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 005aca01-4890-425c-99b0-08d8235af0de
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 16:21:17.0672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWsEIZQeAZvFC/0Bu1jwz2iD1p7loCfXNljhc4Ylg38IT62gGb7yva2NCK2Yvs/4n64JT224+uLIheVIcZuPsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3722
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@mellanox.com> writes:

> Cong Wang <xiyou.wangcong@gmail.com> writes:
>
>> On Tue, Jul 7, 2020 at 8:22 AM Petr Machata <petrm@mellanox.com> wrote:
>>>
>>>
>>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>>
>>> > On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
>>> >> The function tcf_qevent_handle() should be invoked when qdisc hits the
>>> >> "interesting event" corresponding to a block. This function releases root
>>> >> lock for the duration of executing the attached filters, to allow packets
>>> >> generated through user actions (notably mirred) to be reinserted to the
>>> >> same qdisc tree.
>>> >
>>> > Are you sure releasing the root lock in the middle of an enqueue operation
>>> > is a good idea? I mean, it seems racy with qdisc change or reset path,
>>> > for example, __red_change() could update some RED parameters
>>> > immediately after you release the root lock.
>>>
>>> So I had mulled over this for a while. If packets are enqueued or
>>> dequeued while the lock is released, maybe the packet under
>>> consideration should have been hard_marked instead of prob_marked, or
>>> vice versa. (I can't really go to not marked at all, because the fact
>>> that we ran the qevent is a very observable commitment to put the packet
>>> in the queue with marking.) I figured that is not such a big deal.
>>>
>>> Regarding a configuration change, for a brief period after the change, a
>>> few not-yet-pushed packets could have been enqueued with ECN marking
>>> even as I e.g. disabled ECN. This does not seem like a big deal either,
>>> these are transient effects.
>>
>> Hmm, let's see:
>>
>> 1. red_enqueue() caches a pointer to child qdisc, child = q->qdisc
>> 2. root lock is released by tcf_qevent_handle().
>> 3. __red_change() acquires the root lock and then changes child
>> qdisc with a new one
>> 4. The old child qdisc is put by qdisc_put()
>> 5. tcf_qevent_handle() acquires the root lock again, and still uses
>> the cached but now freed old child qdisc.
>>
>> Isn't this a problem?
>
> I missed this. It is a problem, destroy gets called right away and then
> enqueue would use invalid data.
>
> Also qdisc_graft() calls cops->graft, which locks the tree and swaps the
> qdisc pointes, and then qdisc_put()s the original one. So dropping the
> root lock can lead to destruction of the qdisc whose enqueue is
> currently executed.
>
> So that's no good. The lock has to be held throughout.
>
>> Even if it really is not, why do we make tcf_qevent_handle() callers'
>> life so hard? They have to be very careful with race conditions like this.
>
> Do you have another solution in mind here? I think the deadlock (in both
> classification and qevents) is an issue, but really don't know how to
> avoid it except by dropping the lock.

Actually I guess I could qdisc_refcount_inc() the current qdisc so that
it doesn't go away. Then when enqueing I could access the child
directly, not relying on the now-obsolete cache from the beginning of
the enqueue function. I suppose that a similar approach could be used in
other users of tcf_classify() as well. What do you think?
