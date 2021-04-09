Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7F535A036
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhDINoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:44:18 -0400
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:8289
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232615AbhDINoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 09:44:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eC+i2tkalMkP0Wwk2livMCv9gKg+XGp6ZyJaaNg5hr4lUV2RyMNpt/dvwAuf+xaN7aCqWyzdmwkTBYsc+nsahoKJKx+0kqNtdNxwsCP5GJ3mGvyWtD0aKNTpQDsNBbYsy/MlQvMApjEPJcwfdDfjHjXYEv7NuPgrHk3oEIcN8s8phQhIyykkuI4yETD1egr3fh0nO4cibN57Wn53NWTm2oeoESEpYQ88T7bDamrQgw70DR7wj/GHp15+eqr8CWbxGFOPHiu4OXQDkrt3yZcN+nTb8IzNTlOjm+PV1nUmyEVT1DZasZgVxLVTHTYpTTEtyDdaQZKRhY7kh7zZo/ct1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zbzx5XNIslha4MNrg8giIW6kcqf3OXQO03p/rEPL8A4=;
 b=Kyf8WVFOvf4YB1a2Lhm1S2/MthSUQm9dXafxaO2m9aBOxLlU1ezrlvMuX2pD42MEqs6YgLqOnEGsVZSS/idebjAfh9trcY2jOCmOufy7IuvdJHnjVJiV7zh7f4ozZJkWEgU07EDMCDGzNmZY/2qR9a5xSV1OpfIQWamtYoSRw4URjIlb9/gPumSsOMpVSrXbexGfAMfxoG9Z3bx5TAvsN8xLuea0nvZ7N1kqaqDyOcTMYqiA9EV+I9C5MVcBV+q6UIEP1QOhxyKqlHZBMUdP5xy4Um4hc1kYpo7D8TNF4hchgRf4FhqdarT0gi3NC50NeNGru6Wd9TluSq2fqRllwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zbzx5XNIslha4MNrg8giIW6kcqf3OXQO03p/rEPL8A4=;
 b=lGb9j5xEnPYsSntG7QQznCA4bd7vGQtpvZMHYZhC6omeFTdZytAfZHQTjKsVUYTzraJXbgVVBLMlRcAvlFSu4TYnio2WrE13ii/H14YZuj5PIUjGuD5PRhNYrlAmgu5ON2/iUwUAmVTTnu4bqY5yBBg14geHKM4hPciGs0G9Wg8f3+tzte4trR5Bar5jnjb3DHmo+1qSO/Q/XXC16DoH96IvMtWbobVbDIZE6rU6jndkHXFfNmZHkk7lek8rwgmzpWOMn2mueM4hinOJ46czZezRb6b+ZLoYV9A6efzMxvAgJYNgDwf1rrqtpG8XBRJNiRxJP197ibGTHUDUtWCOoQ==
Received: from BN6PR16CA0013.namprd16.prod.outlook.com (2603:10b6:404:f5::23)
 by MN2PR12MB4551.namprd12.prod.outlook.com (2603:10b6:208:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 9 Apr
 2021 13:44:02 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::eb) by BN6PR16CA0013.outlook.office365.com
 (2603:10b6:404:f5::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Fri, 9 Apr 2021 13:44:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 13:44:02 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Apr 2021 13:43:58
 +0000
References: <20210408133829.2135103-1-petrm@nvidia.com>
 <20210408133829.2135103-2-petrm@nvidia.com>
 <b60df78a-1aba-ba27-6508-4c67b0496020@mojatatu.com>
 <877dlb67pk.fsf@nvidia.com>
 <6424d667-86a9-8fd1-537e-331cf4e5970c@mojatatu.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 1/7] net: sched: Add a trap-and-forward action
In-Reply-To: <6424d667-86a9-8fd1-537e-331cf4e5970c@mojatatu.com>
Date:   Fri, 9 Apr 2021 15:43:54 +0200
Message-ID: <8735vz609x.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c947d023-4530-47c5-139a-08d8fb5d891b
X-MS-TrafficTypeDiagnostic: MN2PR12MB4551:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4551AA65A08A4D03F360464BD6739@MN2PR12MB4551.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PC8kn3itTFlhIFMqO8F6y0tP3//sCE9UB9VsAPcd64tw9Duql9j1dpIGeo+2p2x1Yk0JjiZ3/LTwHzzhWFJ4x/PO/BfNYjsC6klwwXcfLdKHszabFMFpv82nhsBsUaA9BnLGeq12ImXpd9XBTZfB9cdCUizs3NgN60MvHp1vqI93bsStMryAN754LFYrZFz4Bp+ljEhsF+ykZGDIJOp3yycJieDI4QYsii7heRjjVNpbj0PRDxL6yeDB0qITkcvQhQaZxCotRviofbypZ0t+y+yC7zgFN5Vg1wZ5PJOn5uSx5dvjqmZMFXomT5NZWGnClyAx0HjXG4Wbr+1iaDzcJUi6yr1FJT3TuRRqWSu2iggy36TXcbvbfGTsoiK/k8Qix5cYDFkPf73gGDJ77Ss0A85Zp1B5FD4IyxDGfarQ1QjOSbOhT9mdcwcj4bqUOvOlOQ1PAdFVtxO/BJPpR/pduALFQ40Ef+sHNHdgrgTitpSf91utKz+4AeH7dRjMLGVk2FIJQ5q/wRjgrM/7+7FLouEFMwdBCPqrktZ1N2oVUcnrKGSo2Wx2kyBVVfH9H/GBUMthpSieP6utGaMgRPUdPk31j3QhnImGY7teuC2smauiB1rbKmSf4ZExhaJRcWKBtdLctVvZz18A8MVL8fnThZmhwVoFnIlZF8C3Ljl8P4yoVzftjqTFhguz/shOy1EzOB/AiguCvf0VofejYHpUxPvp3pN09LIKDtMpznwqZI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(46966006)(36840700001)(8936002)(6916009)(8676002)(86362001)(36756003)(966005)(478600001)(70586007)(70206006)(426003)(2616005)(5660300002)(4326008)(336012)(36906005)(316002)(54906003)(82740400003)(2906002)(356005)(7636003)(186003)(16526019)(26005)(6666004)(53546011)(36860700001)(82310400003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 13:44:02.2009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c947d023-4530-47c5-139a-08d8fb5d891b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jamal Hadi Salim <jhs@mojatatu.com> writes:

> On 2021-04-09 7:03 a.m., Petr Machata wrote:
>> Jamal Hadi Salim <jhs@mojatatu.com> writes:
>> 
>>> I am concerned about adding new opcodes which only make sense if you
>>> offload (or make sense only if you are running in s/w).
>>>
>>> Those opcodes are intended to be generic abstractions so the dispatcher
>>> can decide what to do next.
>>> [...]
>>> For details see:
>>> https://people.netfilter.org/pablo/netdev0.1/papers/Linux-Traffic-Control-Classifier-Action-Subsystem-Architecture.pdf
>>
>> Trap has been in since 4.13, so 2017ish. It's done and dusted at this
>> point.
>
> here's how it translates:
> "We already made a mistake, therefore, its ok to build on it and
> make more mistakes".

I can see how it reads that way, but that was not the intention. I was
actually thinking about whether there might be a way to gradually
migrate all this stuff over to mirred, but at this point, trap is very
much baked in.

>>> IMO:
>>> It seems to me there are two actions here encapsulated in one.
>>> The first is to "trap" and the second is to "drop".
>>>
>>> This is no different semantically than say "mirror and drop"
>>> offload being enunciated by "skip_sw".
>>>
>>> Does the spectrum not support multiple actions?
>>> e.g with a policy like:
>>>   match blah action trap action drop skip_sw
>> Trap drops implicitly. We need a "trap, but don't drop". Expressed in
>> terms of existing actions it would be "mirred egress redirect dev
>> $cpu_port". But how to express $cpu_port except again by a HW-specific
>> magic token I don't know.

(I meant mirred egress mirror, not redirect.)

> Note: mirred was originally intended to send redirect/mirror
> packets to user space (the comment is still there in the code).
> Infact there is a patch lying around somewhere that does that with
> packet sockets (the author hasnt been serious about pushing it
> upstream). In that case the semantics are redirecting to a file
> descriptor. Could we have something like that here which points
> to whatever representation $cpu_port has? Sounds like semantics
> for "trap and forward" are just "mirror and forward".

Hmm, we have devlink ports, the CPU port is exposed there. But that's
the only thing that comes to mind. Those are specific for the given
device though, it doesn't look suitable...

> I think there is value in having something like trap action
> which generalizes the combinations only to the fact that
> it will make it easier to relay the info to the offload without
> much transformation.
> If i was to do it i would write one action configured by user space:
> - to return DROP if you want action trap-and-drop semantics.
> - to return STOLEN if you want trap
> - to return PIPE if you want trap and forward. You will need a second
> action composed to forward.

I think your STOLEN and PIPE are the same behavior. Both are "transfer
the packet to the SW datapath, but keep it in the HW datapath".

In general I have no issue expressing this stuff as a new action,
instead of an opcode. I'll take a look at this.
