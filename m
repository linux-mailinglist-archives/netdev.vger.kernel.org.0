Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6E52187AE
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 14:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbgGHMfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 08:35:11 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:51249
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729036AbgGHMfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 08:35:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlLgQe2vSaZGr+JnPx1BOa8bsHsJ2m0GL5fS31HdcEi36N/i32/3kcqZfG8Pd5L+ErOsABvuavPFpu7nMFxyP8XoJ8PkOupsNwjElRkjnfjmeDmhax1AVihm6WuAcn0wA14GDaGsvWKfh9WW59UdMHiaY0BolIqNYn3eAIE06idfneM6ZZ1MbP+czctt/fO5xGOm5pdQ4siNnt7l7l8mCQgqvrCaWajQ9FGr2JdvU9eS3GqlXGsOnkMpJKmAVl8Lr5rSdqB+mskBnJP54R2LnLitf3dg4qfONOnO22xVChoB7D7HuY4x8dpDxT0eQUsOcUznjhtVFlgLyR3ejFedWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBg8afdGNclfTOQ/PuqaGfO9f11bKqdCiU132JYDo+E=;
 b=nOvTX939/ieoqnY6Uv3Hoe0aoUDBKCVxBNkK8bnU6kwxgCqfRyWNMKouX5bG2g8U+ih3094GwiyDsYvzicJvDHUEivV1rqB/JeTsi+CCIFGtNaVfWBCTzv70tw2aYAYxHgZW/MASPwoOhHvG/JwRr5TXa0BJsSQycyBfE939EDfsCNgEUBJK73woJu+j79ls5zi9TAoTPbmqPEuOhOJ1phVsM8OthdtbM/+K3HhIpf9Br3mAJRfSDh1A3+sL0weaHZk8mRM+z7Si9aOAThaA9VngZI/BpteVWiXXfiNOwWFNdzNWNps/HJOn+r++nQgpiQofBUYoP/K42FMVixxH5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBg8afdGNclfTOQ/PuqaGfO9f11bKqdCiU132JYDo+E=;
 b=pwZg0OD0LhC5/OSpxYjq6+7f0ph9TcvlIzwhKBOZtm2WfqRdCLxuK760J2pli81idq67IjCgK653IUfahjsx7tYfS41OcsNlQeNh/wKrsweOalfQf+s7IPLUeHLYmWv5toCar6omCKbmkkpEwyh0abu2BmKAXiPA5sDJgWNlS4s=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3356.eurprd05.prod.outlook.com (2603:10a6:7:37::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.29; Wed, 8 Jul 2020 12:35:05 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 12:35:05 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <79417f27b7c57da5c0eb54bb6d074d3a472d9ebf.1593209494.git.petrm@mellanox.com> <CAM_iQpXvwPGz=kKBFKQAkoJ0hwijC9M03SV9arC++gYBAU5VKw@mail.gmail.com> <87a70bic3n.fsf@mellanox.com> <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com>
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
In-reply-to: <CAM_iQpWjod0oLew-jSN+KUXkoPYkJYWyePHsvLyW4f2JbYQFRw@mail.gmail.com>
Date:   Wed, 08 Jul 2020 14:35:03 +0200
Message-ID: <873662i3rc.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0131.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::36) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR01CA0131.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Wed, 8 Jul 2020 12:35:04 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eae4bc19-44b8-4e49-6b0a-08d8233b5781
X-MS-TrafficTypeDiagnostic: HE1PR05MB3356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB335679945BCA3FC1A2BC4C21DB670@HE1PR05MB3356.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tiCZ7TAT5HF7tEkkM+1hpzI+tee0CVf5RAI6ry5gGoMA6vQg20mDkK/Jqdvxx1VV2cweS6g5HTsMHdgzgHjnRhi+Id6JYO7aRvRls4GCkhWJOy9pfZoCK6nU96AOB16+MqrDxgIpBFbIu3XDdVKBCbhWtLxLGZ9XgzUUjWtktVvsh6d16FvJdz/SDX7uOcLSH5p9AyC2ohStrSAi86NQniXgKT8/0s+bfFVqsIey92qcq5a+CSRNYa2sQMRUAR1hpe3DpypA49YM3qxbMC7LvPmX6X3665BPLPQGgljtTjNKfy2F04ma9Q5CJ1DCKndXLNpkpWvKnSX65qmwJXbkFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(956004)(83380400001)(2616005)(8936002)(54906003)(8676002)(316002)(5660300002)(478600001)(52116002)(107886003)(4326008)(26005)(6496006)(2906002)(53546011)(186003)(86362001)(6486002)(66946007)(6916009)(66476007)(66556008)(36756003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: h9miMMQS8BOYAem19lR5nVCxfhyo5QOyIH9RzVIITWhsRQzhpouGwKxBAPZgiTxjYZbv/Zhf1YE9OyPH8mkvvFSPE+y2aDNMIdGoSDC3puVZIhJkxnSplCzgGFoMxTqTpkp/imw6DSwLOl4qPKzM0T7bQOtQCJ2rSbvwSB7nKDVPn0A2j75j4pyM/jVCAS04wMtYS8nwlq8InDd0LtE5pjb98BxEEEPzbnEmussiWskzpY0LmjPxMkV81S9s7j30yMpSWy8XUtXZjj/AHd5E3iFYL1erSa1asxhMpDtQ0NbwmA39kc2y4swQmRXX8V9jokKGeiic8oeNc7+mMoijc14eDqW0ApjGFsC4qujhSLPPVkU7UnofoGZTomkkbI3gyAodLi7uH9e3oJfifIEQTcGdGMgdceHR8F2i+PUm9WYgluA9lB574Im1SH1bTaxgMVe/gZhFLIfPH8nP/IybTgMoEM3GeIVWqB6LaUJ9qrKFBxuVmEjy0moaE9baGpgF
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eae4bc19-44b8-4e49-6b0a-08d8233b5781
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 12:35:05.3525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ziRuFvmvVP3/i++fP8LoYysfWIr2K8SFdtSHmKfTDTQUF7+bMORqjjRJOBtaIp4nafJsgZz+Pjm42EdtiAWt4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3356
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Tue, Jul 7, 2020 at 8:22 AM Petr Machata <petrm@mellanox.com> wrote:
>>
>>
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>
>> > On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
>> >> The function tcf_qevent_handle() should be invoked when qdisc hits the
>> >> "interesting event" corresponding to a block. This function releases root
>> >> lock for the duration of executing the attached filters, to allow packets
>> >> generated through user actions (notably mirred) to be reinserted to the
>> >> same qdisc tree.
>> >
>> > Are you sure releasing the root lock in the middle of an enqueue operation
>> > is a good idea? I mean, it seems racy with qdisc change or reset path,
>> > for example, __red_change() could update some RED parameters
>> > immediately after you release the root lock.
>>
>> So I had mulled over this for a while. If packets are enqueued or
>> dequeued while the lock is released, maybe the packet under
>> consideration should have been hard_marked instead of prob_marked, or
>> vice versa. (I can't really go to not marked at all, because the fact
>> that we ran the qevent is a very observable commitment to put the packet
>> in the queue with marking.) I figured that is not such a big deal.
>>
>> Regarding a configuration change, for a brief period after the change, a
>> few not-yet-pushed packets could have been enqueued with ECN marking
>> even as I e.g. disabled ECN. This does not seem like a big deal either,
>> these are transient effects.
>
> Hmm, let's see:
>
> 1. red_enqueue() caches a pointer to child qdisc, child = q->qdisc
> 2. root lock is released by tcf_qevent_handle().
> 3. __red_change() acquires the root lock and then changes child
> qdisc with a new one
> 4. The old child qdisc is put by qdisc_put()
> 5. tcf_qevent_handle() acquires the root lock again, and still uses
> the cached but now freed old child qdisc.
>
> Isn't this a problem?

I missed this. It is a problem, destroy gets called right away and then
enqueue would use invalid data.

Also qdisc_graft() calls cops->graft, which locks the tree and swaps the
qdisc pointes, and then qdisc_put()s the original one. So dropping the
root lock can lead to destruction of the qdisc whose enqueue is
currently executed.

So that's no good. The lock has to be held throughout.

> Even if it really is not, why do we make tcf_qevent_handle() callers'
> life so hard? They have to be very careful with race conditions like this.

Do you have another solution in mind here? I think the deadlock (in both
classification and qevents) is an issue, but really don't know how to
avoid it except by dropping the lock.
