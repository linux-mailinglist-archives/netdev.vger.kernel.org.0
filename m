Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB631D9300
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 11:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgESJKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 05:10:41 -0400
Received: from mail-am6eur05on2058.outbound.protection.outlook.com ([40.107.22.58]:6264
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726818AbgESJKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 05:10:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByNY8S7XSj+IPac9B0Bh+4RQsm1ztZ9u/PeceCPziIfgmOPzyQaX1HOEDj2OSWal7Ht4LfNvt1Vm9hh5TE6cdoqIjIsNupoHQSzsmFyB/pz1S5ziL447SWksKinj+c5BB4C2/1+9tQmOk0NO0utkrEJKilJoxErVfOHr/15qsL3otbc8XMGmg/0zBzu4fudR1/8UId1gXBWVET2/6S3k0k7/gDMP04ZRa8vdW1fUsGg8Ia/9bvMSk1cXXx1hDM2pHYaPSn5RahZ9TUqcvMPYRt8avS+IOPUgy/G5684NQrKEK8tikR0peA4UAdMY+b9fk36KSe2owKCrxDturG0m4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxyOWENtLYNAlsE8iPJb7516DMeLooI/dIYZNB+A7QY=;
 b=Zn0zeRlGHODVD6WVWjEjCYbWzU17g4Iq03ZetgTPR8aybeHkTJODI9w+XgMv3KGnlkXEy/sxfIH5clvZxjDjeKuPYBP0+zrIE5iE40eCJEyKLhhp2atnYXuKmxZ8Yn31DWF6rQ58Cjd2Z3p2jiwQeNs4lkLzgiTDsl67IC8rEuKu+Jy1ilShH1aFVxv5VHoa8Y9sn3SReD+IvKz0/dBfVtSLUzLowa+Mc7b3U0YWlW8JTVTQ4vlmAlgGOxkNJ6lOLya4gGwQp2SRre+TQvW1dr+1qaZRq81wjasDS6P6/s2ev1KuDRsJCv34d1Hg0B83YrG5Y/vL8x4PEACh4OANnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxyOWENtLYNAlsE8iPJb7516DMeLooI/dIYZNB+A7QY=;
 b=tLMLrsgJf1xDH4Px5Gmklb3e4D1Lwr09SwCq41DuxHsBeina/WpW1LoXtGzDUczIA4hhKbqjUHCKB/qxRqnwNMLor5/MhgKgRaF7uIve9qE1+8oa+lYmNDC15SjntoC1TMREAIFGT/L2PHhMtFTLmysft6LciH7pyyf3h2SV1wo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6961.eurprd05.prod.outlook.com (2603:10a6:20b:1a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Tue, 19 May
 2020 09:10:36 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e%8]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 09:10:36 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <CAM_iQpXtqZ-Uy=x_UzTh0N0_LRYGp-bFKyOwTUMNLaiVs=7XKQ@mail.gmail.com> <vbf4ksdpwsu.fsf@mellanox.com> <CAM_iQpXdyFqBO=AkmLqVW=dZxQ3SfjKp71BxsKRuyhaoVuMEfg@mail.gmail.com>
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
In-reply-to: <CAM_iQpXdyFqBO=AkmLqVW=dZxQ3SfjKp71BxsKRuyhaoVuMEfg@mail.gmail.com>
Date:   Tue, 19 May 2020 12:10:33 +0300
Message-ID: <vbfmu64b88m.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 19 May 2020 09:10:35 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: adef65a4-8015-45a8-cac7-08d7fbd47e50
X-MS-TrafficTypeDiagnostic: AM7PR05MB6961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB6961BEA3A0C5B0AE7C48E230ADB90@AM7PR05MB6961.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: furwftFE0ou8NUg22wC3ijhhvGD5IDgimCD9UMSgxHyPHU7itMSVONVZhYGlUyOsgsw6CCjZQOHo1lMQLDsk0ybn1togebGFRqshXVWc+MN9nUJasMJKlqZ97booA4IvGIcfXM/BCGJpQUZep/V6U8+xEzMzVpMueyw22q2kUAUH6Z7yjOo284rIrFwkQ+S44i3lE25MJ244uyHqMc597szZsGwt21ssIyA5EXB8zslfzas/OdV/YpjvQtmKTMZaPIPjs5yjLBG9NmRal1FQ3x8jmwTcMWYi/REAnIMRNCr2OwITqGjajmfbuy5PjTJLAfCjTdwe+6rgoGtHSjoNQuK2hohNiPPRAFkVFCn5id6Pm68a9bNZ8GEEdEd6XFusogvV2JyBoEkzucQiLnQrXQP2g1RLG7GsDAC8dk2UYN29LcKeGg7SVtiKsN8tFbCG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(2906002)(6486002)(66946007)(66556008)(66476007)(8936002)(36756003)(8676002)(478600001)(86362001)(4326008)(54906003)(5660300002)(26005)(53546011)(7696005)(956004)(52116002)(186003)(16526019)(2616005)(316002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Zixp6/ZBE5wwuYvJJVKKVwwhCHZf4DaxrEaS1qfCp1vmtgGQlP5FbF5j6ifH4hPtK3nRUF6lvAPxoI7EET2NVOET8cvpjvz4iHIQHb+AoXYIaNbLicez5X1n32u3N+pLfnA1HaqSbxsjK5tVzYZBcQkresn7P1zZtvklapMNk3pzM8ApDz6hNeyfzb3QaMS6xtGzVzf9OsnQwKGg0ZwD3E7Yb4pEP1tRmbweOXxWcFyGDFyK23dziOsVY+tGkgeum3pXaQeG2v0c7jR+cLUJ8J6Xz02/0la3mheT3TjtcyWl4D+2S+ZRIs+p1uxnJJy3UrOHgJ80z1JCSQUEQs8b+yRd0vbk/PdIkMxDZRY/5DwZwXBtZGSfBEDViJ5VG/9kLNzBnBTr0oksW9Jnjd3b7OayyndLoWFGHe/2tp2IyO12OGXniqpey4B0qJQzO+QTD1PCOED7A0n1GVxw+FcQOBT10dSRi6rBge/NKOmYSQPgJY5w5QgugLVXec69ffII
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adef65a4-8015-45a8-cac7-08d7fbd47e50
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 09:10:36.7893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpHDoWLRoLGBbZkscyKqbVqGE9coJMXUeUzCje4zESgu/Xf7yHL78iHI/cyZJsd2erN7Lhfm9ryrjVdk6UJgpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6961
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 18 May 2020 at 21:46, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Sun, May 17, 2020 at 11:44 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>>
>> On Sun 17 May 2020 at 22:13, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> > On Fri, May 15, 2020 at 4:40 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>> >>
>> >> Output rate of current upstream kernel TC filter dump implementation if
>> >> relatively low (~100k rules/sec depending on configuration). This
>> >> constraint impacts performance of software switch implementation that
>> >> rely on TC for their datapath implementation and periodically call TC
>> >> filter dump to update rules stats. Moreover, TC filter dump output a lot
>> >> of static data that don't change during the filter lifecycle (filter
>> >> key, specific action details, etc.) which constitutes significant
>> >> portion of payload on resulting netlink packets and increases amount of
>> >> syscalls necessary to dump all filters on particular Qdisc. In order to
>> >> significantly improve filter dump rate this patch sets implement new
>> >> mode of TC filter dump operation named "terse dump" mode. In this mode
>> >> only parameters necessary to identify the filter (handle, action cookie,
>> >> etc.) and data that can change during filter lifecycle (filter flags,
>> >> action stats, etc.) are preserved in dump output while everything else
>> >> is omitted.
>> >>
>> >> Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
>> >> available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
>> >> individual classifier support (new tcf_proto_ops->terse_dump()
>> >> callback). Support for action terse dump is implemented in act API and
>> >> don't require changing individual action implementations.
>> >
>> > Sorry for being late.
>> >
>> > Why terse dump needs a new ops if it only dumps a subset of the
>> > regular dump? That is, why not just pass a boolean flag to regular
>> > ->dump() implementation?
>> >
>> > I guess that might break user-space ABI? At least some netlink
>> > attributes are not always dumped anyway, so it does not look like
>> > a problem?
>> >
>> > Thanks.
>>
>> Hi Cong,
>>
>> I considered adding a flag to ->dump() callback but decided against it
>> for following reasons:
>>
>> - It complicates fl_dump() code by adding additional conditionals. Not a
>>   big problem but it seemed better for me to have a standalone callback
>>   because with combined implementation it is even hard to deduce what
>>   does terse dump actually output.
>
> This is not a problem, at least you can add a big if in fl_dump(),
> something like:
>
> if (terse) {
>   // do terse dump
>   return 0;
> }
> // normal dump

That is what I was trying to prevent with my implementation: having big
"superfunctions" that implement multiple things with branching. Why not
just have dedicated callbacks that do exactly one thing?

>
>>
>> - My initial implementation just called regular dump for classifiers
>>   that don't support terse dump, but in internal review Jiri insisted
>>   that cls API should fail if it can't satisfy user's request and having
>>   dedicated callback allows implementation to return an error if
>>   classifier doesn't define ->terse_dump(). With flag approach it would
>>   be not trivial to determine if implementation actually uses the flag.
>
> Hmm? For those not support terse dump, we can just do:
>
> if (terse)
>   return -EOPNOTSUPP;
> // normal dump goes here
>
> You just have to pass 'terse' flag to all implementations and let them
> to decide whether to support it or not.

But why duplicate the same code to all existing cls dump implementations
instead of having such check nicely implemented in cls API (via callback
existence or a flag)?

>
>
>>   I guess I could have added new tcf_proto_ops->flags value to designate
>>   terse dump support, but checking for dedicated callback existence
>>   seemed like obvious approach.
>
> This does not look necessary, as long as we can just pass the flag
> down to each ->dump().
>
> Thanks.
