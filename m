Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558F83DB7F1
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238663AbhG3LlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:41:06 -0400
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:47232
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238597AbhG3LlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 07:41:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRwjWcQTDeDEmBGNy0LkbRHuqAAZ9kgePx6sXyIw2JQ/HyQO7Pozqf/bNrm5UG3nXSZlLYbGDB9JeSbC82b0gL2yALNSQEKrn5RXg6cZTmBH52GKF29UofKN5vEx4gup5ZaeHTIHcfQCN8T3uEgzMEA5T9DT/iJPeydlRCs8UoWFhZsOQpceX2pRmkMHh1eONhnJlBcLKMpNtXQi++noOieFg/CmjGOSRKK2v/kzv6oSt1NbCZGfX4rrMzy8MKbBS8fGLonbiCJyShmhVhYHL9a2nhQWB0nRIVshTrEBHMAEXFcbmm0m/99RB7o9Cmy+GtjEf08Wyhi1r42b4djLfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjjID8kKH1+Q/XeLjQ83eygmpP35gI5lgvU6gXX6Y8w=;
 b=kO+Ke8Em0rgCj8hsNn/Eo2sUzjy972/jq1C2Pgo8lVRclcE2ViPecKKUgSowUW8ZoH3zAWJjvbzZ0mHWq1dk5181obaH7sfwl/qxvS82C9XXEEPogNY7wyRK+2JgQblHN3IBlY2WGeotJruEp5E7vDKOwyXlpxb18PsFWAleuWdXSlaNPBlPyQAXVJYzgz/9dHUJvd47DLQnh3uq/eudv+mU81o4J9sz9Oj0nL5lZ8Ek00Idl/i11D4IoFn0Un1nb/XkG5dnAtgrKsN3N6/zONVpgAiY9rrChzYzND8XycsWh2r06zTvRLiobYh0q9mHhlX1J8oT+7IvCVNFBQbDVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjjID8kKH1+Q/XeLjQ83eygmpP35gI5lgvU6gXX6Y8w=;
 b=ClIWCg7Zd8XvRLyYzYo8D6lhYHpUKKO4uaBiR/6vJV0QPBfficOgcQGmLJwGgsf+q6FZTjHOrIg4fdU+h4npMLAy54aNN6UeDvPa88PR1ecRvB17WKkK32/QojLPp49ueCtHi7kphCPURhBj4IoFrOQiJGMxuNuaN01ZVW5jAX8cnS2eaKAnaqvzg6LT8wL4xR40MHwPE0kFqqhGSbvChJxIvX2omLo74q/MgxQ50vZbGuuSZlf8JCU3kOw1s6pvchKwwJoVJP9r95qaLfVTj/v1pxplmQxC7p1G0cF4XV/phPZJnSiRyBXqIcr2VmZ0wKMTr85JpeEThRGn4W+s1w==
Received: from MW4PR04CA0228.namprd04.prod.outlook.com (2603:10b6:303:87::23)
 by MN2PR12MB3309.namprd12.prod.outlook.com (2603:10b6:208:106::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 11:40:59 +0000
Received: from CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::d7) by MW4PR04CA0228.outlook.office365.com
 (2603:10b6:303:87::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend
 Transport; Fri, 30 Jul 2021 11:40:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT008.mail.protection.outlook.com (10.13.175.191) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 11:40:58 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 30 Jul 2021 11:40:54 +0000
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com> <ygnh7dhbrfd0.fsf@nvidia.com>
 <95d6873c-256c-0462-60f7-56dbffb8221b@mojatatu.com>
 <ygnh4kcfr9e8.fsf@nvidia.com> <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
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
        Louis Peens <louis.peens@corigine.com>,
        "Ido Schimmel" <idosch@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
In-Reply-To: <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
Date:   Fri, 30 Jul 2021 14:40:52 +0300
Message-ID: <ygnhv94sowqj.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a065dfe7-ff50-4428-7ea4-08d9534ee62d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3309:
X-Microsoft-Antispam-PRVS: <MN2PR12MB33097E226F57E8ABE76AE96DA0EC9@MN2PR12MB3309.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tTD3fFE9e+v+q1+yGvxEGjjkzZt5bqkNLMzZv/ZX7E4Aay18yK+xjd4CnOdKVjysug8x5U3JFIF1/tPWQ+GH8n5DcJ+0bnWD4v5Aq/ihU0EgpuECn+I/pcSZA44dQS9Helk9wpWuMqL3uRxe6sq6HqiKdKxHvcvZgAaw6CPJDjhAidi9djrP0O3v4s9O7l+u3Z17UAFW+dr4ZQT59AD43ocXy6a4DkZ35CJRGDSKD8PJrwfa3fbTRoN3XuJVgT+lSOMTP+qy9COQNqlN90yBKIPBJ1eUOEHeKjoiWWrhHnBnp0LRcO9u3nm8SlNy2zMqnOCHgeZhNNyVgTZJbgY2355b8w+SJmrDZJhuOp5OtTiQBy2HiiYfhFf47Vpta3ARdv5C8Nf0syD4V6a4/y97WvrFAoUxZhOY8MsVMM3fBJSi/FXf8/fYwmrSpVybVRASVkIh5XuWglP328lYGrcEtVDakjNoe+bSmCpTki5WaXhnsRd2tHcToLme8RGKiJzAWAVYvsk3JOgawZhq4XFK3sTaz7qiK3iwcqWJ4PBx4B3Xp38kHxdvWercVZypfw6U+HOUCGRaXVVOy+O+QegQJf62+aLaWR/76sdSc/Gcwyzdt7DE2jG1hoV4iRUurus5IKL396fzjAtMr4a4ceGFNo1a18evNO24umBr2KWlZqlAuuWLQlcRA8cdzg5B0QJ0gZoT0V+0EbKZGv1xdtsROQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(46966006)(8676002)(2906002)(82740400003)(7416002)(478600001)(36860700001)(7696005)(356005)(8936002)(53546011)(86362001)(70206006)(7636003)(82310400003)(36756003)(70586007)(6916009)(36906005)(316002)(47076005)(2616005)(5660300002)(107886003)(54906003)(4326008)(16526019)(26005)(83380400001)(336012)(426003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 11:40:58.2852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a065dfe7-ff50-4428-7ea4-08d9534ee62d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3309
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 30 Jul 2021 at 13:17, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2021-07-28 10:46 a.m., Simon Horman wrote:
>> On Wed, Jul 28, 2021 at 09:51:00AM -0400, Jamal Hadi Salim wrote:
>>> On 2021-07-28 3:46 a.m., Simon Horman wrote:
>>>> On Tue, Jul 27, 2021 at 07:47:43PM +0300, Vlad Buslov wrote:
>>>>> On Tue 27 Jul 2021 at 19:13, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>>>> On 2021-07-27 10:38 a.m., Vlad Buslov wrote:
>>>>>>> On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:
>>>
>>> [..]
>>>
>>>>>>> I think we have the same issue with filters - they might not be in
>>>>>>> hardware after driver callback returned "success" (due to neigh state
>>>>>>> being invalid for tunnel_key encap, for example).
>>>>>>
>>>>>> Sounds like we need another state for this. Otherwise, how do you debug
>>>>>> that something is sitting in the driver and not in hardware after you
>>>>>> issued a command to offload it? How do i tell today?
>>>>>> Also knowing reason why something is sitting in the driver would be
>>>>>> helpful.
>>>>>
>>>>> It is not about just adding another state. The issue is that there is no
>>>>> way for drivers to change the state of software filter dynamically.
>>>>
>>>> I think it might be worth considering enhancing things at some point.
>>>> But I agree that its more than a matter of adding an extra flag. And
>>>> I think it's reasonable to implement something similar to the classifier
>>>> current offload handling of IN_HW now and consider enhancements separately.
>>>
>>> Debugability is very important. If we have such gotchas we need to have
>>> the admin at least be able to tell if the driver returns "success"
>>> and the request is still sitting in the driver for whatever reason
>>> At minimal there needs to be some indicator somewhere which say
>>> "inprogress" or "waiting for resolution" etc.
>>> If the control plane(user space app) starts making other decisions
>>> based on assumptions that filter was successfully installed i.e
>>> packets are being treated in the hardware then there could be
>>> consequences when this assumption is wrong.
>>>
>>> So if i undestood the challenge correctly it is: how do you relay
>>> this info back so it is reflected in the filter details. Yes that
>>> would require some mechanism to exist and possibly mapping state
>>> between whats in the driver and in the cls layer.
>>> If i am not mistaken, the switchdev folks handle this asynchronicty?
>>> +Cc Ido, Jiri, Roopa
>>>
>>> And it should be noted that: Yes, the filters have this
>>> pre-existing condition but doesnt mean given the opportunity
>>> to do actions we should replicate what they do.
>> I'd prefer symmetry between the use of IN_HW for filters and actions,
>> which I believe is what Vlad has suggested.
>> 
>
> It still not clear to me what it means from a command line pov.
> How do i add a rule and when i dump it what does it show?
>
>> If we wish to enhance things - f.e. for debugging, which I
>> agree is important - then I think that is a separate topic.
>> 
>
> My only concern is not to repeat mistakes that are in filters
> just for the sake of symmetry. Example the fact that something
> went wrong with insertion or insertion is still in progress
> and you get an indication that all went well.
> Looking at mlnx (NIC) ndrivers it does seem that in the normal case
> the insertion into hw is synchronous (for anything that is not sw
> only). I didnt quiet see what Vlad was referring to.

Filters with tunnel_key encap actions can be offloaded/unoffloaded
dynamically based on neigh state (see mlx5e_rep_neigh_update()) and fib
events (see mlx5e_tc_fib_event_work()).

[...]

