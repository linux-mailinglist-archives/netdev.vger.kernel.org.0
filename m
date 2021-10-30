Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 008F84409A5
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhJ3Osj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:48:39 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:61792
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229993AbhJ3Osi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 10:48:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLfsM3iXz19C2yTGifKOvks/ZngWyU8XFFz+j4RmAZrGAWbmwvx8s6ejziIBJ4J9uYruKU9ROPCAJN+h5VxZ3rDjlxmlvmS6BC1cIu8Sax+gG8f70OwKK5XR/tixkUzMiQENzGIRKUrOb1g4yFU0dY4CfX8cWtF6LGhv9OM53/iLfskyqJJheGLGEtprAHlY1H1XAyj+ha72TuG+4A0lF2EPDYNMvbD7kVyRQdhgo+DEW46WwAIS7ycpuZMTEUw16qLUqnUMmo3VqctOqFSO6P+Nf9m8ZxhJUZSWXweLP1G8FaA0uGuRaNLhekTY/4SuUmibxnkoLRPhtGGgD0qvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkT9wFaN/GYu89/RlNdj8zYJVx7BVEvF8+pdqd4+OXY=;
 b=OsFW6WZ1RG5cKFeM0kIuh4u4CfvqZEZBaPYweyV1+EKiEO7gfTZrqB+b7kihSPD26vek9LjJcaPKfl5LZr7EH33SZdCUuttHL5JVOY48vLD0C2c3z50W0cs8drGatJPfEPd8lY3zM+96OYdIJMIkJIsi97phL2M0F1OMcydDwNqgyDsbCnL+fwj2eH59Ks61Hin/mi8ccLKtyaqT0GkSuAB2NSQeBE3QHppuTvVdRfe2XcXZYA6uOTPVUfsqszc4v6T8PvfiDPUtEb6txikFu5MeyrEG1wLhotQjQZTrsEkMHRnX4ffgoyI4JKj1Pz1CdSeqkHxrf7idjAP/v+IybQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkT9wFaN/GYu89/RlNdj8zYJVx7BVEvF8+pdqd4+OXY=;
 b=mj8hzo67KwLXkjBc38cuwfzQ/cYMyQkFwRwdF/v7gUy5aN9oDCIP2SEu9534m/aYdWOBkQsdRzcZisFfVDWWlKotp2P/OqkvuSapCRtL23wJ+4abP53a3zeWSagX0EPUI5HXjqgJpZlqlFtF3Y9CvB2fK/KNN53MsBcSVf/1dkQ3Vzz2bsCXy93jGaDZqnQCgxAiOAP7h98q8lwZ/rCDK8J52gQX4CFbdZCGmFE5qMQj6MSrUNwX2Ze33z08zzUekx14802gn8ITmpgDu0/7+QdDKvqT29zwcPwrHlxjfMmWerG/lIrrv/TSx8Gjbt3rjvgEIW3BuL1r8g1TfzEaiA==
Received: from BN6PR16CA0040.namprd16.prod.outlook.com (2603:10b6:405:14::26)
 by DM6PR12MB3212.namprd12.prod.outlook.com (2603:10b6:5:186::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sat, 30 Oct
 2021 14:46:06 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::e1) by BN6PR16CA0040.outlook.office365.com
 (2603:10b6:405:14::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Sat, 30 Oct 2021 14:46:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Sat, 30 Oct 2021 14:46:05 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sat, 30 Oct 2021 14:46:01 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Simon Horman <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        "Roi Dayan" <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
In-Reply-To: <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
Date:   Sat, 30 Oct 2021 17:45:58 +0300
Message-ID: <ygnhfssia7vd.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c9cc8a6-dd24-4e7d-2c1f-08d99bb40098
X-MS-TrafficTypeDiagnostic: DM6PR12MB3212:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3212EDB7C7653FC6667B3B1BA0889@DM6PR12MB3212.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThpiaN9azJkPft/zNcWZsmeSsbMtYZOwuQ3XfCd+8572b6m37XQptevXbgqEm9yJsiqSgDFgXRJf0e4dhEzeKSt4JuIaN3XhvUpLRw77yLpeg7ZGc4SGnqaoLavAmYc9q4UqxM03OWMO/5AuwjYrYQgqPotMWbMb2ee8i8/PSu6bQzem2bK3doJcRj6y0/HZ0nZN9HDWiLN/3B0Oan7XJzYxj8mJB2omVEDK4LPnEqmzRB59P7G0EEBwaT5hTwQyYHKiOzlmrUoUh1G/aVaArdX0k6EZrUyK0Y3xQmGt06C4SA70pgX75i2SceVcF1pgXlwpZ8ViweAuGKJvXUJF4C5P7BD2CyDStncvyVjAPRHNEUZYZejo6MSxGzUWga20oSRfAlI7RtNV+V4+jTGDdASEIagT95aluZuutrikYdF6Br66p9EJ/Q0OyF/VGCR/4IE8Jf5XOhUgbTk4SWfYDAIh51VJiSsnvq3hxyC/Vd4naAXVl2/KyNQ4QYdT8+orJnvpccnC5MscEQSK4O8CHiQyGahskyMrcnJyn76nuKjmfdMSSmPoGQatadNYQgd8pheWgijRAiyw35W3L9W1fcrT2IDYJHEGXUS/VkJYupnCnzZ6r+vPiiqLA6/iiq5vu94Xg9Z6Z8lvOber+F9krN0mcRvOiVZkeRSS+5x2h6EAjKIhQYaDXqM8c/DVGKZO09+90ZSL4i9/rOH3jLrvfA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(426003)(4001150100001)(8936002)(508600001)(4326008)(36756003)(86362001)(36860700001)(7696005)(47076005)(2616005)(54906003)(8676002)(70586007)(83380400001)(356005)(70206006)(186003)(336012)(7636003)(53546011)(316002)(6666004)(15650500001)(6916009)(16526019)(5660300002)(82310400003)(26005)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2021 14:46:05.4308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9cc8a6-dd24-4e7d-2c1f-08d99bb40098
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3212
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 30 Oct 2021 at 13:54, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 2021-10-29 14:01, Vlad Buslov wrote:
>> On Thu 28 Oct 2021 at 14:06, Simon Horman <simon.horman@corigine.com> wrote:
>>> From: Baowen Zheng <baowen.zheng@corigine.com>
>>>
>>> Add process to validate flags of filter and actions when adding
>>> a tc filter.
>>>
>>> We need to prevent adding filter with flags conflicts with its actions.
>>>
>>> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
>>> Signed-off-by: Louis Peens <louis.peens@corigine.com>
>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>> ---
>>>   net/sched/cls_api.c      | 26 ++++++++++++++++++++++++++
>>>   net/sched/cls_flower.c   |  3 ++-
>>>   net/sched/cls_matchall.c |  4 ++--
>>>   net/sched/cls_u32.c      |  7 ++++---
>>>   4 files changed, 34 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>>> index 351d93988b8b..80647da9713a 100644
>>> --- a/net/sched/cls_api.c
>>> +++ b/net/sched/cls_api.c
>>> @@ -3025,6 +3025,29 @@ void tcf_exts_destroy(struct tcf_exts *exts)
>>>   }
>>>   EXPORT_SYMBOL(tcf_exts_destroy);
>>>   +static bool tcf_exts_validate_actions(const struct tcf_exts *exts, u32
>>> flags)
>>> +{
>>> +#ifdef CONFIG_NET_CLS_ACT
>>> +	bool skip_sw = tc_skip_sw(flags);
>>> +	bool skip_hw = tc_skip_hw(flags);
>>> +	int i;
>>> +
>>> +	if (!(skip_sw | skip_hw))
>>> +		return true;
>>> +
>>> +	for (i = 0; i < exts->nr_actions; i++) {
>>> +		struct tc_action *a = exts->actions[i];
>>> +
>>> +		if ((skip_sw && tc_act_skip_hw(a->tcfa_flags)) ||
>>> +		    (skip_hw && tc_act_skip_sw(a->tcfa_flags)))
>>> +			return false;
>>> +	}
>>> +	return true;
>>> +#else
>>> +	return true;
>>> +#endif
>>> +}
>>> +
>> I know Jamal suggested to have skip_sw for actions, but it complicates
>> the code and I'm still not entirely understand why it is necessary.
>
> If the hardware can independently accept an action offload then
> skip_sw per action makes total sense. BTW, my understanding is

Example configuration that seems bizarre to me is when offloaded shared
action has skip_sw flag set but filter doesn't. Then behavior of
classifier that points to such action diverges between hardware and
software (different lists of actions are applied). We always try to make
offloaded TC data path behave exactly the same as software and, even
though here it would be explicit and deliberate, I don't see any
practical use-case for this.

> _your_ hardware is capable as such at least for policers ;->
> And such policers are then shared across filters.

True, but why do you need skip_sw action flag for that?

> Other than the architectural reason I may have missed something
> because I dont see much complexity added as a result.

Well, other part of my email was about how I don't understand what is
going on in the flags handling code here. This patch and parts of other
patches in the series would be unnecessary, if we forgo the action
skip_sw flag. I guess we can just make the code nicer by folding the
validation into tcf_action_init(), for example.

> Are you more worried about slowing down the update rate?

I don't expect the validation code to significantly impact the update
rate.
