Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462FB3D7B58
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhG0Qrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:47:52 -0400
Received: from mail-co1nam11on2051.outbound.protection.outlook.com ([40.107.220.51]:60385
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229497AbhG0Qrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 12:47:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXfsbc6R6ZeOOiyoBIbFauB3R2tekF0w59Q3TNAry1n8xuZERvDslccz+DV0qTd/zAmwOVMfz/hI+sXwqGpS0Mos7YiLhNIxH/lYSUeNoJagYsJWX0fNhZyd3+E9HMVk2ZqVNKtXSBjELIXYeh/An+Ac7vuOJtInxZcaRzc0Uwj0E8q23LTQF0reSfN+u4C1PkkybH7hIvh5u+x96hyQWKZDP+D2Csn3A+5z/wXJX6tPfRkcdTexLvXljiu9CBxmB6F9mX5h9QR0Nlgt1KPzhwM8D+8wghCm+XpZ5AgUkmfpcZ7Q7bELnsEtKfmzCvVUxyWYRQT/bCNZOy/xo8GIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rJuO/MZ6AIcv43om5/7zvo2hE49Q0H6YavkN0jjii4=;
 b=ACysHqBqlJ0l+jlSbucrJ1rpiJ4wgSCM9NgDzMw4zEhtRIA9GQCuXSIlhMwviZ57MsEozmWSHCGO3kMh5W9Tw0Yqx79CovUECPGGibC3P0qR3e/g+991TDqQwPXJIi8hp1+i7SK1TagxOCmjXBuIddzfsEXKPppMqrsFlVB1k9Hu7rQjXRsfuclloh9UERQkJ9cUiSOvGP5/jTaka/AFCwyZLDwW6SwzEn3kWRG/pDwKtxe/RtV7lFwffisiCoJL6ydDH0y9y6NLWrBXgqxvp5DaR/9eSwY/tKnycy0gVv7MxBE0TwaIDXHH5jkLbbArtnLyiB0fCNVoS/n6yyVtvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rJuO/MZ6AIcv43om5/7zvo2hE49Q0H6YavkN0jjii4=;
 b=cwdzA1Ee4i683OhV3wsKmZERDZtnPDvSy7+vgOu1yOE0xGGcRNA9Kuc6uffmxyIaTpegETA48VyrZfzDBh3scqGEIEuDiobYQA3tQi0nTRt2vc+Pxk18O0P6r9LIqbucgipsfGNuoj2myRIPb/BjT9YY8I/hA2et0G54sKx8mcGbzruLfX0rWBtSvL9ZH7hor4XH31bcBHQUi2sQofe2T+A40aG1UCjtxu9XZNGez+Jew7TntV9MLZ1w3mTl98CtZza26wZebviF8BC5DvMCRyIWgNclMdXFdW9M5r7AQ2pCKjhj4hJUpZhod1LKeU/6rcIkMr2yymcgro8zpC0lPQ==
Received: from BN7PR06CA0053.namprd06.prod.outlook.com (2603:10b6:408:34::30)
 by CH2PR12MB4087.namprd12.prod.outlook.com (2603:10b6:610:7f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 16:47:50 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::b7) by BN7PR06CA0053.outlook.office365.com
 (2603:10b6:408:34::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Tue, 27 Jul 2021 16:47:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 16:47:49 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 27 Jul 2021 16:47:46 +0000
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
In-Reply-To: <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
Date:   Tue, 27 Jul 2021 19:47:43 +0300
Message-ID: <ygnh4kcfr9e8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6daec20e-cc57-4acf-dbe2-08d9511e44d1
X-MS-TrafficTypeDiagnostic: CH2PR12MB4087:
X-Microsoft-Antispam-PRVS: <CH2PR12MB40878C3C68193CBF7DE78EAFA0E99@CH2PR12MB4087.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zO1zM4P2+YojNJYnuPIfJ4flFboUvL91a7RSeNcQ7USUegGU7brWbfLz5r0zPUQvN4wGHxC2omoFPZliIgZR6sgjPEKHEu+oVfR+ngjPx6lSX4aB0JquYDdyflH3LUtGZxBeliemRRnH5aZ+aBSKG0/YbD5uZygm5lDcBSmpiqTYIW889LiGRQ+Qdqr+FTg4ANRlj5IGjpJKS6Si6iV+UWNTHvFP5iX3TZW6BfyRBv1v45a3W8THXJrn1vhNe0ALUP3reH2/D2Q/9PJrbI9NrDdnuYPiKg8mGpvbMgBAmCUe/U0hxzHpFCYkwQs0gquMpePv679mI6Kgj/Y0eM9ho/KYbLAK4oM9h31TvqCbJEFNexw/dmlfQjWRtRqxFDiDNowgRmkN6fTAAPFOJ7fiqMzcLx/pU5ADtTnDcl9kmSiOA8RamEPf1HXZ1ZrzWP0uZOeNLMAplNbkBNiVbxAA3/8d9TsCHu1WV83gJat/kQxXaHiSJHULBvgvAWkWDIsPpM1QWsI9MUOalBdgw4WslmWqGkU8quWZpp3GusG5BqeVzFgJNoPOp/V1kk6ul+BxfjM+11c2xup9/yMpXiMXlBGm9wTkqQVYbALShRZwHKgcJ2W42fp/d2fM5FDe+HdgV5NChU+9bkYH1baSJZArHCz8gqwaMOV7Iu0/D6YMOjEi1OJxOOfkpEeR7qAlCXHUlQ+rjZgTt375YUILrkhrlg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(5660300002)(54906003)(86362001)(82310400003)(6666004)(4326008)(316002)(186003)(8676002)(47076005)(6916009)(26005)(83380400001)(36756003)(7696005)(356005)(16526019)(36860700001)(36906005)(70586007)(70206006)(336012)(53546011)(7636003)(2906002)(2616005)(8936002)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 16:47:49.2619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6daec20e-cc57-4acf-dbe2-08d9511e44d1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 27 Jul 2021 at 19:13, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2021-07-27 10:38 a.m., Vlad Buslov wrote:
>> On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:
>
>>>>
>>>> Also showing a tc command line in the cover letter on how one would
>>>> ask for a specific action to be offloaded.
>>>
>>> In practice actions are offloaded when a flow using them is offloaded.
>>> So I think we need to consider what the meaning of IN_HW is.
>>>
>>> Is it that:
>>>
>>> * The driver (and potentially hardware, though not in our current
>>>    implementation) has accepted the action for offload;
>>> * That a classifier that uses the action has bee offloaded;
>>> * Or something else?
>> I think we have the same issue with filters - they might not be in
>> hardware after driver callback returned "success" (due to neigh state
>> being invalid for tunnel_key encap, for example).
>> 
>
> Sounds like we need another state for this. Otherwise, how do you debug
> that something is sitting in the driver and not in hardware after you
> issued a command to offload it? How do i tell today?
> Also knowing reason why something is sitting in the driver would be
> helpful.

It is not about just adding another state. The issue is that there is no
way for drivers to change the state of software filter dynamically.

>
>>> With regards to a counter, I'm not quite sure what this would be:
>>>
>>> * The number of devices where the action has been offloaded (which ties
>>>    into the question of what we mean by IN_HW)
>>> * The number of offloaded classifier instances using the action
>>> * Something else
>> I would prefer to have semantics similar to filters:
>> 1. Count number of driver callbacks that returned "success".
>> 2. If count > 0, then set in_hw flag.
>> 3. Set in_hw_count to success count.
>> This would allow user to immediately determine whether action passed
>> driver validation.
>>
>
> I didnt follow this:
> Are we refering to the the "block" semantics (where a filter for
> example applies to multiple devices)?

This uses indirect offload infrastructure, which means all drivers
in flow_block_indr_dev_list will receive action offload requests.

>
>>>
>>> Regarding a flag to control offload:
>>>
>>> * For classifiers (at least the flower classifier) there is the skip_sw and
>>>    skip_hw flags, which allow control of placement of a classifier in SW and
>>>    HW.
>>> * We could add similar flags for actions, which at least in my
>>>    world view would have the net-effect of controlling which classifiers can
>>>    be added to sw and hw - f.e. a classifier that uses an action marked
>>>    skip_hw could not be added to HW.
>
> I guess it depends on the hardware implementation.
> In S/W we have two modes:
> Approach A: create an action and then 2) bind it to a filter.
> Approach B: Create a filter and then bind it to an action.
>
> And #2A can be repeated multiple times for the same action
> (would require some index as a reference for the action)
> To Simon's comment above that would mean allowing
> "a classifier that uses an action marked skip_hw to be added to HW"
> i.e
> Some hardware is capable of doing both option #A and #B.
>
> Todays offload assumes #B - in which both filter and action are assumed
> offloaded.
>
> I am hoping whatever approach we end up agreeing on doesnt limit
> either mode.
>
>>> * Doing so would add some extra complexity and its not immediately apparent
>>>    to me what the use-case would be given that there are already flags for
>>>    classifiers.
>> Yeah, adding such flag for action offload seems to complicate things.
>> Also, "skip_sw" flag doesn't even make much sense for actions. I thought
>> that "skip_hw" flag would be nice to have for users that would like to
>> avoid "spamming" their NIC drivers (potentially causing higher latency
>> and resource consumption) for filters/actions they have no intention to
>> offload to hardware, but I'm not sure how useful is that option really
>> is.
>
> Hold on Vlad.
> So you are looking at this mostly as an optimization to speed up h/w
> control updates? ;->

No. How would adding more flags improve h/w update rate? I was just
thinking that it is strange that users that are not interested in
offloads would suddenly have higher memory usage for their actions just
because they happen to have offload-capable driver loaded. But it is not
a major concern for me.

>
> I was looking at it more as a (currently missing) feature improvement.
> We already have a use case that is implemented by s/w today. The feature
> mimics it in h/w.
>
> At minimal all existing NICs should be able to support the counters
> as mapped to simple actions like drop. I understand for example if some
> cant support adding separately offloading of tunnels for example.
> So the syntax is something along the lines of:
>
> tc actions add action drop index 15 skip_sw
> tc filter add dev ...parent ... protocol ip prio X ..\
> u32/flower skip_sw match ... flowid 1:10 action gact index 15
>
> You get an error if counter index 15 is not offloaded or
> if skip_sw was left out..
>
> And then later on, if you support sharing of actions:
> tc filter add dev ...parent ... protocol ip prio X2 ..\
> u32/flower skip_sw match ... flowid 1:10 action gact index 15
>
> cheers,
> jamal

