Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C48E44143E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 08:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhKAHlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 03:41:19 -0400
Received: from mail-dm6nam08on2076.outbound.protection.outlook.com ([40.107.102.76]:37664
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231185AbhKAHlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 03:41:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAlLWBVkINHuvLZnMISAuJBDxSIp0wQ9c0C4/hdP/7VhDmeWVV0tqYbZJkciEVi2SjATXIfgOWSdZcOLzS56uU+Knlu2w9Yqu6mnTSV0LPe0ZO9bQj0oVYbAf1Z71o5n25yHU4bz3Q50c23LpF7OIvv+iBvCGDzY3i/UsO1kDQDwNzAVUWVP3xqQFlncQQ1TVF51dHgU3PN/IyGbK3vnJeagbsEcEzvMiSNn74YljziU91RvK8s0qHT70j5aO3dOT0q6R1JarCVgvNoa5Q+nD4LX7pj/hhTmP56TMHKqN0fsMc3qpGs3RrkKNNPASp9Vw7cYDQaz4Xgyrndl//w37Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msFgNHxsJsFBQCzvQh/t8f3r4vSkCupheVW1x8P5T/w=;
 b=ZSAmVu/vsmI0PgO3Hb/JWEQpMyOBklqKwJTmssSD4upJbKK1z13+WpQr6yzkE0el4QvKtgd6H6O3c4k9Dho7DDruB58StTmdBAMzpOEUADlOqRFb2+pMetLoV5dRaC19GjmUnt9Z5adWPxOn7iz9yfSTCrjRl1WRD1TJhcFcsK0c3Xjey4VMY0c1cxVw2dmqe2ZeECybh7h9tl3+Qp27k2EmXrSUJeSiv5UJ5H6LiO1Q+qVcwz+nbk031Igkn9FfstGbqnrA/UgQZM3p+jPHyi8+P5aGGluTBv02QXaEgoFFc6FJGMFhnUtoYZj7Ecb7ze7/vZKbrFTgXZXv5k24Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=msFgNHxsJsFBQCzvQh/t8f3r4vSkCupheVW1x8P5T/w=;
 b=cLziT8o7NuK336Qjt3BNa7uGqEeHUNANP5rM7SZc7hijQyyeTmlRGmktR7YPXAg3wSJ3+Ox8ANzWLlUc/0zbbVg/VEchAk9p1KP7RA19GfROVYu7+cQVDqW4V3MU09CUodIneWbLmhy/JDIiFYW2qar6Y4Rm/Ehi3+a0aYHbHpInYuStKtnr3BA0Mt5iTcsQ9NnNNkzWx4cGFY8nYTU/MrMjSAuCX9Q+cOXRBQo1IdckeU+iqf/LiIilfUKvotQv00upQECj0Dbie2/rn6uQnI4ShRz0oEkK4jnJn8anDpAymSW0xoKxgJVu4HSIGf62QvUR4Ui2Fy4ri9BsDSBj/A==
Received: from MW3PR06CA0004.namprd06.prod.outlook.com (2603:10b6:303:2a::9)
 by DM8PR12MB5477.namprd12.prod.outlook.com (2603:10b6:8:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Mon, 1 Nov
 2021 07:38:43 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::3d) by MW3PR06CA0004.outlook.office365.com
 (2603:10b6:303:2a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Mon, 1 Nov 2021 07:38:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 07:38:40 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 1 Nov 2021 07:38:37 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
In-Reply-To: <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Date:   Mon, 1 Nov 2021 09:38:34 +0200
Message-ID: <ygnhcznk9vgl.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3de45bce-1658-4bab-13e4-08d99d0a9fc7
X-MS-TrafficTypeDiagnostic: DM8PR12MB5477:
X-Microsoft-Antispam-PRVS: <DM8PR12MB54776781C92F482B69D353AAA08A9@DM8PR12MB5477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4AQL/ChvvIyIeNW8takjvVZJM7po6en/sLeLJ9pbpVziLFnkKFK+PKEeOCGBOMdQ5Wxsw50w408VFySgC9VCtu7+oTvFFw2A91EjneQUThooJz53ssdF7S+DEHcDLd8qSQA+spnhTpTaSJk8WYjQduGv/hwPMqiNMiKePIOZp0RW/p8c9Uh8LQ+GRl56EAfY0iNFYft29cp84KdhyKeZf4C0cfE2mZdYKTl2pCJoh0pEbxteKxWoqTGnZkv1A27OopFVro6hYS+4N6kmke6U5JJkoMPR+XPeAk8dSAKz0qrNLc6sdh88SBbHnZejXgk45eRtg5VrXbdNpkjL/TADJ9e8p3ItyvqaA9EUO2JffTfWOkFBPY8xcNXvHIWa3ARKPW/J5LDBHF02ZFNMLlUwVCwAK1o77d6vNA60i5CXXyn2HQf3oEhM/4vUcFtIqEB0jPSezd7jr11eBw5wbPaVo2OZYfyi1IOlXC5QOWfnWQYAAWWXQvFiF58Kg3n5cK2ndi2zPk9XnSijwxAdXPh+oZKPTrt59V37otGSJ04ePCDj8OsJ97vi1bjoF88/UX1tNCXjsbJcZ6hMEIO7B60i0nW2W22mX0ruEsGhzMkMetG6MtUAN/mjBlb5ed4W/sA9kPwd5zjW76snuksZBWvMn23l3TE9AvUdS4s2P80Rz9O9S46MM+kVbod3Gw5Ge/cJudJ8CF3b56Dts0GA/JL4tQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8936002)(316002)(2906002)(16526019)(508600001)(26005)(6916009)(8676002)(54906003)(7636003)(82310400003)(4326008)(53546011)(15650500001)(336012)(186003)(356005)(83380400001)(86362001)(7696005)(36756003)(2616005)(70206006)(6666004)(36860700001)(4001150100001)(426003)(47076005)(5660300002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 07:38:40.4384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de45bce-1658-4bab-13e4-08d99d0a9fc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5477
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 01 Nov 2021 at 05:29, Baowen Zheng <baowen.zheng@corigine.com> wrote:
> On 2021-10-31 9:31 PM, Jamal Hadi Salim wrote:
>>On 2021-10-30 22:27, Baowen Zheng wrote:
>>> Thanks for your review, after some considerarion, I think I understand what
>>you are meaning.
>>>
>>
>>[..]
>>
>>>>>> I know Jamal suggested to have skip_sw for actions, but it
>>>>>> complicates the code and I'm still not entirely understand why it is
>>necessary.
>>>>>
>>>>> If the hardware can independently accept an action offload then
>>>>> skip_sw per action makes total sense. BTW, my understanding is
>>>>
>>>> Example configuration that seems bizarre to me is when offloaded
>>>> shared action has skip_sw flag set but filter doesn't. Then behavior
>>>> of classifier that points to such action diverges between hardware
>>>> and software (different lists of actions are applied). We always try
>>>> to make offloaded TC data path behave exactly the same as software
>>>> and, even though here it would be explicit and deliberate, I don't
>>>> see any practical use-case for this.
>>> We add the skip_sw to keep compatible with the filter flags and give
>>> the user an option to specify if the action should run in software. I
>>> understand what you mean, maybe our example is not proper, we need to
>>> prevent the filter to run in software if the actions it applies is skip_sw, so we
>>need to add more validation to check about this.
>>> Also I think your suggestion makes full sense if there is no use case
>>> to specify the action should not run in sw and indeed it will make our
>>> implement more simple if we omit the skip_sw option.
>>> Jamal, WDYT?
>>
>>
>>Let me use an example to illustrate my concern:
>>
>>#add a policer offload it
>>tc actions add action police skip_sw rate ... index 20 #now add filter1 which is
>>offloaded tc filter add dev $DEV1 proto ip parent ffff: flower \
>>     skip_sw ip_proto tcp action police index 20 #add filter2 likewise offloaded
>>tc filter add dev $DEV1 proto ip parent ffff: flower \
>>     skip_sw ip_proto udp action police index 20
>>
>>All good so far...
>>#Now add a filter3 which is s/w only
>>tc filter add dev $DEV1 proto ip parent ffff: flower \
>>     skip_hw ip_proto icmp action police index 20
>>
>>filter3 should not be allowed.
>>
>>If we had added the policer without skip_sw and without skip_hw then i think
>>filter3 should have been legal (we just need to account for stats in_hw vs
>>in_sw).
>>
>>Not sure if that makes sense (and addresses Vlad's earlier comment).
>>
> I think the cases you mentioned make sense to us. But what Vlad concerns is the use
> case as: 
> #add a policer offload it
> tc actions add action police skip_sw rate ... index 20
> #now add filter4 which can't be  offloaded
> tc filter add dev $DEV1 proto ip parent ffff: flower \
> ip_proto tcp action police index 20
> it is possible the filter4 can't be offloaded, then filter4 will run in software,
> should this be legal? 
> Originally I think this is legal, but as comments of Vlad, this should not be legal, since the action
> will not be executed in software. I think what Vlad concerns is do we really need skip_sw flag for
> an action? If a packet matches the filter in software, the action should not be skip_sw. 
> If we choose to omit the skip_sw flag and just keep skip_hw, it will simplify our work. 
> Of course, we can also keep skip_sw by adding more check to avoid the above case. 
>
> Vlad, I am not sure if I understand your idea correctly. 

My suggestion was to forgo the skip_sw flag for shared action offload
and, consecutively, remove the validation code, not to add even more
checks. I still don't see a practical case where skip_sw shared action
is useful. But I don't have any strong feelings about this flag, so if
Jamal thinks it is necessary, then fine by me.

