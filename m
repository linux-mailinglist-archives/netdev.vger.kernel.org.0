Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A44182D3F
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 11:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgCLKQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 06:16:09 -0400
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:9395
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbgCLKQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 06:16:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMrNTx4Q795iE0Pf51vRHVN+VNoX9Vrq8Ndz95KdEm/Mc1E/MtyUwFaQxR+fNlF4/pvJL3bwJ3RgQmI8FQQzMwNs3digzGQZqVkOGC7fDHCCO4b7/jD0EVqm0iL9WE4wY2TZSkAuEpORyRyQV7Qyar56m4KdxECEQF7yhL9qp7tfOL7u+zPzCZdlXPB63SgQmCLE5+DhxVR97BkT9/FTTMqaZfW0fGdlbQDnGZ83UJ99ottpNW/Vky+R8IoXAfmkltbnWTXG+txM01dR/Rka6BncIFH7gEit7hNZEvYA5aP9gtRpKpURr68jXrn3QIMim55bjvc3AE2v4aKTyVAO6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v5AYImHWZQWIL20SkL1Pv2W2V3nac7NDDSAP0v34BY=;
 b=TVt1bAUUQBBQ2EEEFW2cbZ2NOmlUDZGdOMBa+8LqKDVI/QP+t7GyOw9xAgWEHvolyoSDLOHp5vQzHJDR6xHGGtJZuX+Xq8uB+46rKHo7BufS8ekKdxEHAyoHlIGtFKdVxVvfkfvLLUJbJsnT23DCVpz5pXv+0kxODVVD2ciZnnhoZSwm6B/E59nY44+fnYJ1N8zgLYQPc383m4wUr5Tsr61/C0vdrF62wnO3ZGOuxG46jJ119PfxP6fxNPkGfwT4Rt8zwBkp2UqRWP9bMibC6LMXchE+d6TW56+E0Uicer7SAPYQcbLVhQGgTOlgY/yoISZAFcGkOicxr2jT2HzUjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v5AYImHWZQWIL20SkL1Pv2W2V3nac7NDDSAP0v34BY=;
 b=cfgCsM0c2EnNbtyIqlRjuWzX19ZK8XGKDoEuzZE8LYIYs4oR3kSQxq0WBJ+Q3df8aHeTPkUYKt7q+vjI4w7Zzq+MVBC4gRA8eG5VJTvnQeb9R42t7aw9mlZn60gYgIuTuUATcWFs8FxQiwQ4hMsGIxOpKOjsH0/jEOcIJVwprWc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 AM6SPR01MB03.eurprd05.prod.outlook.com (52.133.25.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Thu, 12 Mar 2020 10:16:04 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 10:16:04 +0000
References: <20200311173356.38181-1-petrm@mellanox.com> <20200311173356.38181-4-petrm@mellanox.com> <2629782f-24e7-bf34-6251-ab0afe22ff03@gmail.com> <87imjaxv23.fsf@mellanox.com> <7a7038ca-2f6f-30f6-e168-6a3510db0db7@gmail.com> <20200311192511.3260658c@kicinski-fedora-PC1C0HJN>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 3/6] net: sched: RED: Introduce an ECN tail-dropping mode
In-reply-to: <20200311192511.3260658c@kicinski-fedora-PC1C0HJN>
Date:   Thu, 12 Mar 2020 11:16:01 +0100
Message-ID: <87h7ytyj32.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 10:16:03 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53f5506d-9038-4b9b-3f8d-08d7c66e5f05
X-MS-TrafficTypeDiagnostic: AM6SPR01MB03:|AM6SPR01MB03:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB03EE07E83FF77D86F904B9DBFD0@AM6SPR01MB03.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(199004)(52116002)(4326008)(956004)(16526019)(2616005)(6496006)(86362001)(26005)(81156014)(81166006)(6916009)(478600001)(8676002)(186003)(66476007)(107886003)(66556008)(2906002)(54906003)(5660300002)(8936002)(316002)(6486002)(36756003)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6SPR01MB03;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYxZq9DEgW3c1m+nH597jyC1yFRKi37LLav13fnBw1bpYH3aZqID0KVxa+lttCEi3mSRaUlyQ4r1S7r/9lNKC1AhaCLVz+5sKMSjJNlI6TplA7SnPgTOWmF8V7lXkArOPGD+NpQgaJe3TQ2ubIO2lYRON9MT0fNKMbRE2OvXOblviv14sHl8+VPB1TWl/nxRk2gxiSPqWGYnmcciK+iH9ivtWmK4G9v1hPfxSDkz3WXfK/2ugGSXog11iAfIQ4T1CjED9FunYIQMKQzXGEB3tsQu5b8mp80NpXKoiUXiSrbEwkKRLF3ddFxHX670892mWmjEV3kXClv1u4WK+A1AfLpypn9VTpXosqPZNGZh3jSOF1nr+wbZn8vCoYMrkEpb2JVmweuwo5mGP8wfzsUmHclqbCOHJsZlysGzaBI6TwoyH996suj4yA+yG+Oc1j0z
X-MS-Exchange-AntiSpam-MessageData: ZiUM06Zoi8/5tPzExgIk1umVpxvrvExtwX2336BXkXWG47y7bqJ6T8HOjK6vQx5p/DYzFK2awo6EkKQv4+hRIyGc5VReKDX0ktR/F8rWqwbBovmzINPJfBKGDEH+a0uC3vibdxoj71q6AEuIZoZouw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f5506d-9038-4b9b-3f8d-08d7c66e5f05
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 10:16:04.2674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWiHW6vzfkdqWbmZ61kKEbo8LlCB5PQaAtoU2R/H4Yt7WCkwWjm151sndigsuE+1byk+jKL5IZ4kazHj6bBOng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB03
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 11 Mar 2020 18:01:38 -0700 Eric Dumazet wrote:
>> > That said, I agree that from the perspective of the qdisc itself the
>> > name does not make sense. We can make it "nodrop", or "nored", or maybe
>> > "keep_non_ect"... I guess "nored" is closest to the desired effect.
>>
>> Well, red algo is still used to decide if we attempt ECN marking, so "nodrop"
>> seems better to me :)

I know that the D in RED could stand for "detection", but the one in RED
as a qdisc kind certainly stands for "drop" :)

> nodrop + harddrop is a valid combination and that'd look a little
> strange. Maybe something like ect-only?

But then "ecn ect_only" would look equally strange. Like, of course ECN
is ECT only...

I don't actually mind "nodrop harddrop". You can't guess what these
flags do from just their names anyway, so the fact they don't seem to
make sense next to each other is not an issue. And "nodrop" does
describe what the immediate behavior in context of the RED qdisc is.
