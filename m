Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6691DAC3A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgETHdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:33:08 -0400
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:32835
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726309AbgETHdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 03:33:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXZqLFGAikZl/iSf3OlHtDtkvWLOvDwhsWOJpAyoE6SwzW1ZGZGPv/D+r7ku7YqhZQaRJTOQFbyPegRM2ZaTs8lHekX6GzMvte+ZHfZ/RDhHj9lgwh33uMdhZpLnr8e6Ht4YeZoiKbqeWKcxQC0vObTd+Y0DBtYxKMRrqpxgHt7lbykv37BQyFTrbubmclUEdJxkng+o7qMfdd+Qfrkn+hzsTFVyNZuLAy/z0lA+/w/Y38M3ZHRJuZmZC4Jt7weYgW9BOvgM2DF349nOn3LqM3NzG5SZ6eOgoZ1Nj8ZjVwbmWXSKJ3M6dAy9bNTU/RGyqJZWhTteTp9wWE/d3nV2tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pnHOah3g6qYywdgF9rjQkpyA7/Y0iWvKEfnijof9V8=;
 b=Vnues4nCsYgEOWnISMSkc50at/aSINgyVx72xwd0uQWhnb6uF2CocukMhSLnx1A79JiBjpc1ajHJbgfIiPxKUR9duit8Cs2pfTpM8xHwZYYORER/PQ3LFBIoherfO1nv59EYEBqSfPF9xRGtUXralt/udhgyMzIVr73ZpMfOWg+61yMe6Bq3yEsIuQFsFURHGzhjKs2nix3eOOcoh6PYSS+o+pvMnmDxARieSqS/MCYdeYP3E1WwtaHahMRmFELQcn09YOx/JQIc/LVnjE57pwxN129RTT1J3zlNL4sMFWMImRYM54q6te+gNg4BI8qrfI9YF1Lg9agclwi0PcI15g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pnHOah3g6qYywdgF9rjQkpyA7/Y0iWvKEfnijof9V8=;
 b=stpPIRFdZkwGkjTsAvKLbuVoJwpCAN+tMOoPYw4euSFe3i9UBiRq79In0nQd8ejSd6vUjnY80OY0gZ6uazVdZw5WxwUDLjdZNxIRHk4yy44WOh55WC+Ge7UUYA8Ci/0woz9O4+6U9+Le7hxG48V6ZVb1nzkCjHW2+OyYpCeZKjM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6711.eurprd05.prod.outlook.com (2603:10a6:20b:133::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Wed, 20 May
 2020 07:33:04 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::e135:3e43:e5e5:860d]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::e135:3e43:e5e5:860d%8]) with mapi id 15.20.3021.020; Wed, 20 May 2020
 07:33:04 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <CAM_iQpXtqZ-Uy=x_UzTh0N0_LRYGp-bFKyOwTUMNLaiVs=7XKQ@mail.gmail.com> <vbf4ksdpwsu.fsf@mellanox.com> <CAM_iQpXdyFqBO=AkmLqVW=dZxQ3SfjKp71BxsKRuyhaoVuMEfg@mail.gmail.com> <vbfmu64b88m.fsf@mellanox.com> <CAM_iQpU_BvK0Cgra+-_PUrpwkX3FyLDo6r3sz=phD-dTk278pQ@mail.gmail.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <CAM_iQpU_BvK0Cgra+-_PUrpwkX3FyLDo6r3sz=phD-dTk278pQ@mail.gmail.com>
Date:   Wed, 20 May 2020 10:33:00 +0300
Message-ID: <vbftv0bvz6b.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0032.eurprd03.prod.outlook.com
 (2603:10a6:205:2::45) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by AM4PR0302CA0032.eurprd03.prod.outlook.com (2603:10a6:205:2::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Wed, 20 May 2020 07:33:02 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 872b6c16-ff3b-4274-996b-08d7fc90082c
X-MS-TrafficTypeDiagnostic: AM7PR05MB6711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB67110B3C5DAE8C86E77FEF6CADB60@AM7PR05MB6711.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04097B7F7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BY7t2gR8d1rxH6Zk2Ja7+tDd3ZKREWxo94aqBBv4u/53osA+HBvJCPyzeUKpg4hRBDUAg03eZMUkLUyQX9xSyX2k3RwQQNktN19byPsDkoNHWrAG4OFKjnv6S6z9Ruh66KPBsJ9bR2d7FGsnukJLL0pIrP9QtO8o6C+DhjqARZDG/iMBudRwdat1m5TDSILJZcXg74mEmB6TUbvLi0h0I9mVaAqMA7FMKN6f/NM7tOcPms6/jto1tUFZuIhFMFRV0ZvK1mOjV5t6SVaBDOmDfXcVTpWjXckNWLZbHodA33w5cuXk0coz6LzkCkaeDB1l2ubdcy0LDQ4syG1PnXo0DMqWgwKBRRtxAP298BuDMCLObCk8dFxeIQnQB4xyDcfR1qxeGKYNiXe8uC0LPR32hJDvkTgL+2MrgtuOLHhOsncgGee8fZKHJxgx5k4Wu2cN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(66946007)(16526019)(26005)(66476007)(53546011)(186003)(66556008)(478600001)(4326008)(36756003)(5660300002)(8936002)(956004)(2616005)(2906002)(86362001)(52116002)(7696005)(316002)(8676002)(6486002)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: U7ogdvC5iDe6T2t3EvFQbgEraqiJxq980maVUGa/4l7j5M1lDWr7knLpUFPP7ir6g/iFAZeJhrKnLnQ31lOftYrZ+zB5uWiDE43J7NeB+3eT9vPRpx6z0RVOcA+BP9c4pl0BQPaGzSRVJUgRGs2juCR94CQXdm6Fa7DhVuNOMWnYKGbZlmipTduUpMwf8tqjyHrBVENZa6I9TY6jthWYpEYj8hvqPHQu1kRDnDCDxnRc95K4DiGj8uOweLiHQ+a/B1FiIGidXaCSmAk7RlmNdZgU+JtvOmgq0YxVvvq++9DKQ3wEnBYMnRKtoG+nmMGtrdCcGRB5K3IbtYUpRdOwlaLNC/Yn8/37TBwZp5rdvvofNeO+pHcUBLS6mhN7BwdhwjteIXlBfFoNSotjNgZ1gYQNPqnqu/E6DexsPjfIBieGXRZvm2VmWdDs5+jMtZ8OIk7wtySLFXhEHs+bFcO4NYCm7RCNvALGK7io6/I2r10pHX6VqgWGFtMFoyZpxmuP
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 872b6c16-ff3b-4274-996b-08d7fc90082c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2020 07:33:04.0269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgcRO2G1V4ERuInM74oMijFIysGT+LFQuw3V4gPjsGkrc+9MIO1PZaurOa6Zahcx5JV3PjlJ40V5e4hUrYDDmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6711
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 19 May 2020 at 21:39, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, May 19, 2020 at 2:10 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>>
>> On Mon 18 May 2020 at 21:46, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> > On Sun, May 17, 2020 at 11:44 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>> >>
>> >>
>> >> On Sun 17 May 2020 at 22:13, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> >> > On Fri, May 15, 2020 at 4:40 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>> >> >>
>> >> >> Output rate of current upstream kernel TC filter dump implementation if
>> >> >> relatively low (~100k rules/sec depending on configuration). This
>> >> >> constraint impacts performance of software switch implementation that
>> >> >> rely on TC for their datapath implementation and periodically call TC
>> >> >> filter dump to update rules stats. Moreover, TC filter dump output a lot
>> >> >> of static data that don't change during the filter lifecycle (filter
>> >> >> key, specific action details, etc.) which constitutes significant
>> >> >> portion of payload on resulting netlink packets and increases amount of
>> >> >> syscalls necessary to dump all filters on particular Qdisc. In order to
>> >> >> significantly improve filter dump rate this patch sets implement new
>> >> >> mode of TC filter dump operation named "terse dump" mode. In this mode
>> >> >> only parameters necessary to identify the filter (handle, action cookie,
>> >> >> etc.) and data that can change during filter lifecycle (filter flags,
>> >> >> action stats, etc.) are preserved in dump output while everything else
>> >> >> is omitted.
>> >> >>
>> >> >> Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
>> >> >> available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
>> >> >> individual classifier support (new tcf_proto_ops->terse_dump()
>> >> >> callback). Support for action terse dump is implemented in act API and
>> >> >> don't require changing individual action implementations.
>> >> >
>> >> > Sorry for being late.
>> >> >
>> >> > Why terse dump needs a new ops if it only dumps a subset of the
>> >> > regular dump? That is, why not just pass a boolean flag to regular
>> >> > ->dump() implementation?
>> >> >
>> >> > I guess that might break user-space ABI? At least some netlink
>> >> > attributes are not always dumped anyway, so it does not look like
>> >> > a problem?
>> >> >
>> >> > Thanks.
>> >>
>> >> Hi Cong,
>> >>
>> >> I considered adding a flag to ->dump() callback but decided against it
>> >> for following reasons:
>> >>
>> >> - It complicates fl_dump() code by adding additional conditionals. Not a
>> >>   big problem but it seemed better for me to have a standalone callback
>> >>   because with combined implementation it is even hard to deduce what
>> >>   does terse dump actually output.
>> >
>> > This is not a problem, at least you can add a big if in fl_dump(),
>> > something like:
>> >
>> > if (terse) {
>> >   // do terse dump
>> >   return 0;
>> > }
>> > // normal dump
>>
>> That is what I was trying to prevent with my implementation: having big
>> "superfunctions" that implement multiple things with branching. Why not
>> just have dedicated callbacks that do exactly one thing?
>
> 1. Saving one unnecessary ops.
> 2. Easier to trace the code: all dumpings are in one implementation.

Okay, I see your point.

>
>>
>> >
>> >>
>> >> - My initial implementation just called regular dump for classifiers
>> >>   that don't support terse dump, but in internal review Jiri insisted
>> >>   that cls API should fail if it can't satisfy user's request and having
>> >>   dedicated callback allows implementation to return an error if
>> >>   classifier doesn't define ->terse_dump(). With flag approach it would
>> >>   be not trivial to determine if implementation actually uses the flag.
>> >
>> > Hmm? For those not support terse dump, we can just do:
>> >
>> > if (terse)
>> >   return -EOPNOTSUPP;
>> > // normal dump goes here
>> >
>> > You just have to pass 'terse' flag to all implementations and let them
>> > to decide whether to support it or not.
>>
>> But why duplicate the same code to all existing cls dump implementations
>> instead of having such check nicely implemented in cls API (via callback
>> existence or a flag)?
>
> I am confused, your fl_terse_dump() also has duplication with fl_dump()...
>
> Thanks.

I meant duplicating the "if terse not supported return -EOPNOTSUPP" in
dump callback of every classifier implementation. With current
implementation cls API handles such case by checking whether classifier
implementation has ->terse_dump() defined and returns error otherwise.
This can also be achieved by having a new classifier flag, in case we
decide to proceed with folding both dump and terse_dump into single
->dump(bool terse) callback.
