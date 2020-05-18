Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE91D713A
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 08:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgERGoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 02:44:09 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:1987
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726357AbgERGoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 02:44:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOYVarOfUVJ9qnQCGoqHLJqEJ7dEP8wl8Rs9SV/Ou1QY+NP29xjxa60wqTQWXGtpVOxGGCBhBuEEZ48JSZ3e1BySMM62JbhCDPM9WYs45mrGFPGVhJdZqIUyQCWLSM81M7BqDpEHVe+7lLUSQMearinONv0lry0tb8HzFtnTFBpCRqK3+9/LZBZBMu3UPya68UdORisBeiXzZ01ofwVEg1dZ7c+j2SPvxHyVdIjqeUh+feC+6OkWToz35UOs81ErczsBWvC4HbeoEjNR20FRZ+3Hjc5BsbNlwnmwzzQs5pq1iYfSy84EOJumaO8znMInk49hEiLBW2kMbfrDz5pzDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNJ79tUlc6miyS5r7hI1JxbBwyKHwx2rXLUzdP0ZUf4=;
 b=dTVnQM6B1bP1vuUmAm61/QVwYVByTp2rUK+8KBkWbPG51XjtBzcS/5ywtRGB7UdJ4UZn+eLra+oupbjDamXiHGxC/q2U7Z/rv9/M+J6evT5MwavCQGr4SPe+L/aVlooCEXTsk8X/p8cXtTJOlhIZFuYLvSsJ1T2p8wjas7iWw6CaCybLRwZ0MI8+WX41ESvxZ/SESr8EvATh4yrNubSg63Ym/MWQsQTGxiD3/pTnL61HAHtp2NT7XbewxTmWToYSgsjY8U6fURrlzgP7GqhCVepkpwGrEkhVAXA1eHgfUMlNl3GBRVta3WJyfz695wuYQdgtEWlZSpBWuaJMakegVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNJ79tUlc6miyS5r7hI1JxbBwyKHwx2rXLUzdP0ZUf4=;
 b=Vm6hySqvE1hyn0psgw5h0NjYE0KKVs3KdhuoyhlJ5kn8D/S+3wKPQ4lnzNKSAxc34dnSHEzY38+35PObZNQp1m93vHNeNmJH14ZuXQfNF6ZARLUwOzOhCl8/AweWBzFmgZVayiv9fR+y0m2Aykh36x/JTq1x6Qr57J0aieoEA10=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB7105.eurprd05.prod.outlook.com (2603:10a6:20b:1a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Mon, 18 May
 2020 06:44:06 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e%8]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 06:44:06 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <CAM_iQpXtqZ-Uy=x_UzTh0N0_LRYGp-bFKyOwTUMNLaiVs=7XKQ@mail.gmail.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <CAM_iQpXtqZ-Uy=x_UzTh0N0_LRYGp-bFKyOwTUMNLaiVs=7XKQ@mail.gmail.com>
Date:   Mon, 18 May 2020 09:44:01 +0300
Message-ID: <vbf4ksdpwsu.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0140.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::32) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR0P264CA0140.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Mon, 18 May 2020 06:44:04 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7bb7a3a1-7046-41b7-8702-08d7faf6dc62
X-MS-TrafficTypeDiagnostic: AM7PR05MB7105:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB7105812308DFD0357DCC5043ADB80@AM7PR05MB7105.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FCsmDT5K9qcsiI/IDO/XYlxgvtTjOCoXLVS0grOXiKpHG1YwFxmnffix/d79JdV7+xrzGW4uh/n0uv83O1GBLYuCdB0I6qdpeZmG6pNWAewRg0Z8P5Uxew5+YIdjGKqUv+odkeLg/dyv8pqBit0tiZeDRq29Ux+r1+UYQrpZtTip5OQLmRqRL+R7wLS8bynnxLQ4AsWvD73hsKU9AeloVTptDbIpE88+z17kFHqo1Q5bXrAY33OGed7kA8q24OiYRcsw+4OA7cBisOm6Bpz1I7HEeuqPj/5NimJnOvnOoSSmezHfguShGwUQD6GBgBstVmesuoJ+KKNNcArIt/JChpirgOtSNn/QasQx0YCD0mDBbtFw1l4alCzAg/wuRcDtauGheR0bf/u24DRyiWEvkWKJDvUUadmSqMnjPFJiAInYsk73GC5/qR6JWzNedW4Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(53546011)(26005)(7696005)(52116002)(2906002)(6486002)(16526019)(186003)(86362001)(54906003)(5660300002)(8676002)(110136005)(66556008)(36756003)(316002)(478600001)(66946007)(66476007)(2616005)(956004)(8936002)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: wfAxLvcjpY/E2y/JuC+4IAGYnTw+6t/kSLGIja+4IUwgLu/19rbLzqtjMrzycQh60PE9rgvjh50IC24U2hLNMEPznV6CqmkGBqeb03MS8O8Gv/MkLH1623Q0g7Tnfqyq51TWqzpDgBCwCo2jej1V6C2t8HA/oI8KFOreKAU10hlDJa3sFiG/jOiXbKcQ9UfCHQAgQJrxo6ionXFXEsVRSV92JHgk0vJ3/9vNkmU+pZII4j8SLsXtzyjYKDJqPQUOp/dFR0seGill3lWOlCSQImslfi+IWuYOYP5XZz2WXi0LGpZN1Qb3PWZQ3gO6Fe3b+fxqVCVYo9xuttRaxxGP5QYP8YjZytXRbC5RVwyuVqiM2KR4BsbA9yRiDsKWCTyjsQYwNMn0RIUUWL07h6OzeX3x/xY44lcTU9w61rF2btyELfQvg+BGpqq55EI0w/kgM3IU+z43vRyk1TP0AC2aNbRpxJDgs5FtQn2Cj06Z/CE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb7a3a1-7046-41b7-8702-08d7faf6dc62
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 06:44:06.4479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YX3aKnCTvNrKCn8epr54C08HDQ83xOI8T9MqB3qBcV2ka2YKFGPJnKWF5VZw78sbGm+3FSdAVC8exCd3uqpe1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sun 17 May 2020 at 22:13, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, May 15, 2020 at 4:40 AM Vlad Buslov <vladbu@mellanox.com> wrote:
>>
>> Output rate of current upstream kernel TC filter dump implementation if
>> relatively low (~100k rules/sec depending on configuration). This
>> constraint impacts performance of software switch implementation that
>> rely on TC for their datapath implementation and periodically call TC
>> filter dump to update rules stats. Moreover, TC filter dump output a lot
>> of static data that don't change during the filter lifecycle (filter
>> key, specific action details, etc.) which constitutes significant
>> portion of payload on resulting netlink packets and increases amount of
>> syscalls necessary to dump all filters on particular Qdisc. In order to
>> significantly improve filter dump rate this patch sets implement new
>> mode of TC filter dump operation named "terse dump" mode. In this mode
>> only parameters necessary to identify the filter (handle, action cookie,
>> etc.) and data that can change during filter lifecycle (filter flags,
>> action stats, etc.) are preserved in dump output while everything else
>> is omitted.
>>
>> Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
>> available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
>> individual classifier support (new tcf_proto_ops->terse_dump()
>> callback). Support for action terse dump is implemented in act API and
>> don't require changing individual action implementations.
>
> Sorry for being late.
>
> Why terse dump needs a new ops if it only dumps a subset of the
> regular dump? That is, why not just pass a boolean flag to regular
> ->dump() implementation?
>
> I guess that might break user-space ABI? At least some netlink
> attributes are not always dumped anyway, so it does not look like
> a problem?
>
> Thanks.

Hi Cong,

I considered adding a flag to ->dump() callback but decided against it
for following reasons:

- It complicates fl_dump() code by adding additional conditionals. Not a
  big problem but it seemed better for me to have a standalone callback
  because with combined implementation it is even hard to deduce what
  does terse dump actually output.

- My initial implementation just called regular dump for classifiers
  that don't support terse dump, but in internal review Jiri insisted
  that cls API should fail if it can't satisfy user's request and having
  dedicated callback allows implementation to return an error if
  classifier doesn't define ->terse_dump(). With flag approach it would
  be not trivial to determine if implementation actually uses the flag.
  I guess I could have added new tcf_proto_ops->flags value to designate
  terse dump support, but checking for dedicated callback existence
  seemed like obvious approach.

Regards,
Vlad
