Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F202171BE
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgGGPZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:25:16 -0400
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:10963
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730174AbgGGPZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 11:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NU/qGDu/qwk1uHxSQQ/rhzc+YBTbwrvIV8/S11Pg770hCjjicGQSsAYoS6uyAi03rAco2S5jCRkwtk/UfFruRPQ9/sDDO6Y5LUZqhLmnWIS9Sw6Knbt+mOvcCsf5hCvpgtytwq9xt0o+MkJA5CbZywBWSTfI0pTllNMemHPT5PLphEJ4ePpNGQQu17Txijh+c++GysqVPCJNs/Yed2eL6Zbjt8ZZWRQ6VOLC930KUY//QtNPwOOFjON4KS/eQEVbJ/RoCM3Drl6ukIwEbBH3y9wO5YXxRrx7Omhs2P59GD8WGI4/n4tFagy2xWCAa3rtrqgd67NFIi7R8QeXgYTyig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vf1SHwrQWDAAamdwfU8Saab+CrWpNV34jPAhqMz5avE=;
 b=YnuXs1giMLmODwXYSVzWa2Gz+Qb2gtlCPwgFWSlinF7Bjxc5Tk0ZbPBNvBytjAwub07ALHGokPhXO2X84j0ApgfSuhIrsxXG4j237PVat4S2L+4Va+TaDjrxVhxTNG9eWbAPvnh0MqpQyrgO6FsyS7wW0pCyBt0S5dSLD1d1FfQHr1UbavVRwQlPqQFpY7dQ8lFQOxoWmU0cCF56kTU/rMqzN36apa6G0XJwWbAXrTV9nLQMMV1Cqh1zfzOE62ho7NgF1USbz0Y9MPh1mpTpxF7RbMKUBojIqTyQqzNU3gnLMrEmyqdEjFeKLrSf3lGTn6lNDsc2WNtltS+uTcORQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vf1SHwrQWDAAamdwfU8Saab+CrWpNV34jPAhqMz5avE=;
 b=rewpLDs6d4+4lV4kn/MpQPx2oE9EfcGrqLXWnJkz1J/WTGRvmRi7hgi0mTaO/dRcgJaQ3NWUsdi/aOotpPH+2k6uwdQXF4sqNIQ6cLNLHCX22paygpK3oym0yXckqwGAjX/1cpp3BGRWG3Ahj+p6vtfbNhG7IcNKGq1RbA3V2p4=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2602.eurprd05.prod.outlook.com (2603:10a6:3:6d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.24; Tue, 7 Jul 2020 15:25:11 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 15:25:11 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <643ef0859371d3bf6280f5014d668fb18b3b6d85.1593209494.git.petrm@mellanox.com> <CAM_iQpUEAt_0Kr1vVfRrpMPz+2arpLA5g4yfWCLe2fhbMTrH7w@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v1 1/5] net: sched: Pass root lock to Qdisc_ops.enqueue
In-reply-to: <CAM_iQpUEAt_0Kr1vVfRrpMPz+2arpLA5g4yfWCLe2fhbMTrH7w@mail.gmail.com>
Date:   Tue, 07 Jul 2020 17:25:08 +0200
Message-ID: <878sfvibzf.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:208:136::33) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR05CA0093.eurprd05.prod.outlook.com (2603:10a6:208:136::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Tue, 7 Jul 2020 15:25:10 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 40e0b913-1bdf-4057-0d69-08d82289f020
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2602:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB2602B61F552C08E34A722611DB660@HE1PR0501MB2602.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0457F11EAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mzk2Zz6F4HrC6++G8NEa1d93+X+qIJS2XisGW65UGtyhVfHTqCF+ntCzQUmWUXiEJrriwhP2AS124yXoj9OIEkR5QYiOX4wvNnJQ/pgA6jla0OihM7G8CsNn6ffxdi2it1uztXJFAZDDQE+G7DOekkbayo23h0fxTSxJoYf4ZjJSdfzeNTMNBsWRYTsfhfDd03wZLaCj6x7SYBlVgIewV4gfgkWFJmjiDN4YPTO1QE3Xwb2Ja6kyIJXZFvehG4S9lM5Nz6mRDoTFid0i8MYJtlOl9l6zXdEHzWsx/121qPFseEx5/fORaRHbaENqIuqu5Osw5LYtid+WE5Vq6kz1nQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(66946007)(8676002)(83380400001)(52116002)(86362001)(498600001)(956004)(54906003)(36756003)(26005)(2616005)(107886003)(186003)(66476007)(66556008)(53546011)(2906002)(6486002)(4326008)(8936002)(6496006)(6916009)(5660300002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qJKBlKIVvEO8oyvcSAeNUbLRFIRmLv7v6KwcYLRpaj/l+xXJlp3qoprM5qoMcXJinuNUaRQDqM1DVJXvkv7Jo4V7xsmSFpiTZLOUQ8hkTNxuxnQJyKnOlEWw3meJFgaDRrjY62bHhAxYV2mHGnc5eOJ7mXOdzNDKeWnnwq91bhcn33rYBYLiwkHmXi/67Qe6BLhJM36vyISZUNKIY5Tn7SZrvEaiL6IAi1bJ8L0Q+CS7riTtcPA96L7YezUQu7jfuT5Gy8mwXbEE5hdSvEX6mEr3P83hnic9vdTpra8QtpdcxLTYwrPkxWzocFdpp1i/DsBmkioKmyVMk7SBFpTlNfKytzwnq9DkeyDHub9112xt2DAifDQhe+xRbjLYAzEZx8dISTyg9KSyDrrgOZCxJhvPnXYwRKMk7pwzNgm/S+4IO9MkvuP7zVEBZkfnK09CwKcpN4tACXj/I17iNFhW5PE7oDR9QrTKpWnzol9iCWf+X8EaJxEHnxSvyPqu/H4d
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e0b913-1bdf-4057-0d69-08d82289f020
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2020 15:25:10.9040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGn4Eh56S56lBmwERoObis7Q8UfoM+V0yfKsjwfJuTiog16MuCn6cqF/YCur7uvgc6myWvfhOm5xKCPv8J2LIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2602
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Fri, Jun 26, 2020 at 3:46 PM Petr Machata <petrm@mellanox.com> wrote:
>>
>> A following patch introduces qevents, points in qdisc algorithm where
>> packet can be processed by user-defined filters. Should this processing
>> lead to a situation where a new packet is to be enqueued on the same port,
>> holding the root lock would lead to deadlocks. To solve the issue, qevent
>> handler needs to unlock and relock the root lock when necessary.
>>
>> To that end, add the root lock argument to the qdisc op enqueue, and
>> propagate throughout.
>
> Hmm, but why do you pass root lock down to each ->enqueue()?
>
> You can find root lock with sch_tree_lock() (or qdisc_lock() if you don't
> care about hierarchy), and you already have qdisc as a parameter of
> tcf_qevent_handle().

I know, I wanted to make it clear that the lock may end up being used,
instead of doing it "stealthily". If you find this inelegant I can push
a follow-up that converts tcf_qevent_handle() to sch_tree_unlock().
