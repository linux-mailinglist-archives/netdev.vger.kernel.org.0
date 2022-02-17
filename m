Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476504B9FCD
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240329AbiBQMLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:11:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240271AbiBQMLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:11:08 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52AC6378;
        Thu, 17 Feb 2022 04:10:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3E2SjYLFcwdRrVb0gTPvxMvFcIHro7JqoCv3+wER2zt2YY11jQJJMCD9iEdLYFeoCCY3rnxc2X420KjCZatkEtT5Ubn86qm9Ai+BHyd2tfFKWI0enH/VBOJm0hvqkCYFIeAWZWkhv+AId7NhfoB7g8AcZ4saOfjelVj6h1HBk9Gk2o1mdLUTLNI+8pasAFj5eTaK5rydsMUHX65x0zJs57HLxJa3x+VnSaImIGlpVCjcehnXAVdLgJcvxGEB/vNwXRBlk5CW5m0DTgo/s4clvWTPNl30AJjKlH1YEPx4aAix8OVGkl8KYqFI0al6Ha/Oh/b/yjT6SYGBKidgIYr5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=165sruYtvtKB7IkZNmKvWNhHuqP/A0QQXNs8JUrHhio=;
 b=TXPTX4riznf4GBbeLDwkq8335CPjOPNrXCwx5wL9qOU/AhqI3bvC62IHCBVaIP6DseZuB1gagqM4AcYCFRh8Xd6R/IxREEJDP/XUGeu+O3nRWCaozs8y5I1KOrzNqPvWEOhnMFlbUVqfVdQ1JwxNVWRrF6JhTz6TJ6D8XOMdaeiDKc/a4k3upOkSVUqTfOH6g05CTfxyqlJXBMJsy1Q9gMlTymNsJ3g27K8NngXmdyT9wd6E9J2qClscp3j/YLT7xVBjRDQtPppzz287/z5Fqf9TIaWaspgQ5Nh3XbOyjhF//hbEm1uDL8d0+NHtQ6hkM/bYhd6pRVmUnju7M8gv5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=165sruYtvtKB7IkZNmKvWNhHuqP/A0QQXNs8JUrHhio=;
 b=S9AQuBXKuHkkqyBzhGAY2nuefrOgRqZkv1vG/r1dpakkt3mbtvIte+vJJGqXuE4P2Mp11BiiJe8TtRRaA0uF8/3WovuWXZkTBOsyVffVxNosSe2zsJCr4SreCxuDmdoe1/awKpIA9MEcDvtOMQcJX/Dq9ImC2YvCp+dK2kLXtGVg+OG4ATlKgOkKma3EbY2jqV8uBt7WciRsyrEO3Ez4t8wTdWq4eT0xAFcSu0EPtkImchdtQarcGNxopmeV0cCEg2aA5I8mdQGw31aDXfVwC7Uz1u33uRBoM9Okhfi2/rvYztsY9G1GO5lyGeqx8nY4pspJMq49P2Gfx43rSSIXMA==
Received: from DM6PR08CA0035.namprd08.prod.outlook.com (2603:10b6:5:80::48) by
 BN9PR12MB5322.namprd12.prod.outlook.com (2603:10b6:408:103::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Thu, 17 Feb
 2022 12:10:51 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::f0) by DM6PR08CA0035.outlook.office365.com
 (2603:10b6:5:80::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17 via Frontend
 Transport; Thu, 17 Feb 2022 12:10:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:10:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:10:32 +0000
Received: from [172.27.11.82] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:10:24 -0800
Message-ID: <a196d40f-d96f-3fb2-2189-a3906b340d95@nvidia.com>
Date:   Thu, 17 Feb 2022 14:10:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [PATCH net-next v2 1/2] net: flow_offload: add tc police action
 parameters
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "rajur@chelsio.com" <rajur@chelsio.com>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "gakula@marvell.com" <gakula@marvell.com>,
        "sbhatta@marvell.com" <sbhatta@marvell.com>,
        "hkelam@marvell.com" <hkelam@marvell.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Simon Horman <simon.horman@corigine.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "louis.peens@netronome.com" <louis.peens@netronome.com>,
        Nole Zhang <peng.zhang@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217082803.3881-2-jianbol@nvidia.com>
 <DM5PR1301MB2172C0F6E86850B5646DAB84E7369@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <DM5PR1301MB2172C0F6E86850B5646DAB84E7369@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cdb29a2b-bfea-41bf-72df-08d9f20e8a1b
X-MS-TrafficTypeDiagnostic: BN9PR12MB5322:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB53222BF43E2FF711762A5AC0B8369@BN9PR12MB5322.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXq1pOmGKhvkCYcycp2uJLkYFacqfvoBm8x70bf73GOs3WVtpLIxGw7rJ3W99KV8E97RNvLoNFixi+2oVVFq3P8fShcH/1H8kOZf4QNwcyleVWFqonK8QN64LMzq6dRBkcbRTPZWgiCok5zIspZx7JeHiNrW3dJNzOrHQnea2PwHaTWMigWGCUCghtlNj8ht9Qs8f6BgS33kYNw+rX+FN9d5iJZpY1AH2gzKITxtTkvvMXSxZa25QIQ8GbkYYGQWv0wAYrwT7YcIox9TtgE2wZ3BsABYrBfXfxQu2K4z6zLlUNtrkhoFbW3R3h9J0ENqIHccGfFTeAOPiQ8k6oUIJIoBWf77I8nnDkk8UsxiI9SquOrZbj32bJWeU1xyY330jzE/i3t/w0Rgx86Ilcf6y67UH4+/TsQ1lApBOZ/2aMlUr4mdW6ePiyfN4YNYY30Nvt07qeb/4bFIf4tD6SDkpLNFjCn0k3LRrhAzYyCE4g2ARV1paeNVgV6xvHdlv3JEgvKQzmnu712Se5Rxq3q3/yyb95n/qVbITUUbRxlUUTY7IgY8NJrXstXg/ytBHdhUxQh47mWke+h+XlhVDy4l7NeGo5wau6EGIknNE//QgbVPQ8GZ5fhhvjMw5hUp7KbjtZZFKDFOI+dF//QnzW/en/fhJyb9KgO9tSUrDkK3fNxtXx8BBgXNbJEu1TXi8HaY8bliXtkYa9Ld2zJRv4E/JUmjB7RlS/tqmULAP6EQWCpQQU4xLW/84Agx782CR11t
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(356005)(31686004)(36756003)(36860700001)(47076005)(40460700003)(7416002)(5660300002)(8936002)(81166007)(4326008)(86362001)(31696002)(6666004)(426003)(336012)(8676002)(70586007)(70206006)(54906003)(16576012)(26005)(16526019)(82310400004)(83380400001)(316002)(186003)(110136005)(2616005)(2906002)(508600001)(53546011)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:10:50.8748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb29a2b-bfea-41bf-72df-08d9f20e8a1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5322
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-02-17 12:25 PM, Baowen Zheng wrote:
> On February 17, 2022 4:28 PM, Jianbo wrote:
>> The current police offload action entry is missing exceed/notexceed actions
>> and parameters that can be configured by tc police action.
>> Add the missing parameters as a pre-step for offloading police actions to
>> hardware.
>>
>> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>> ---
>> include/net/flow_offload.h     | 13 ++++++++++
>> include/net/tc_act/tc_police.h | 30 ++++++++++++++++++++++
>> net/sched/act_police.c         | 46 ++++++++++++++++++++++++++++++++++
>> 3 files changed, 89 insertions(+)
>>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h index
>> 5b8c54eb7a6b..94cde6bbc8a5 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -148,6 +148,8 @@ enum flow_action_id {
>> 	FLOW_ACTION_MPLS_MANGLE,
>> 	FLOW_ACTION_GATE,
>> 	FLOW_ACTION_PPPOE_PUSH,
>> +	FLOW_ACTION_JUMP,
>> +	FLOW_ACTION_PIPE,
>> 	NUM_FLOW_ACTIONS,
>> };
>>
>> @@ -235,9 +237,20 @@ struct flow_action_entry {
>> 		struct {				/* FLOW_ACTION_POLICE */
>> 			u32			burst;
>> 			u64			rate_bytes_ps;
>> +			u64			peakrate_bytes_ps;
>> +			u32			avrate;
>> +			u16			overhead;
>> 			u64			burst_pkt;
>> 			u64			rate_pkt_ps;
>> 			u32			mtu;
>> +			struct {
>> +				enum flow_action_id     act_id;
>> +				u32                     index;
>> +			} exceed;
>> +			struct {
>> +				enum flow_action_id     act_id;
>> +				u32                     index;
>> +			} notexceed;
> It seems exceed and notexceed use the same format struct, will it be more simpler to define as:
> 			struct {
> 				enum flow_action_id     act_id;
> 				u32                     index;
> 			} exceed, notexceed;

right. it can be.

> 
>> 		} police;
>> 		struct {				/* FLOW_ACTION_CT */
>> 			int action;
>> diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
>> index 72649512dcdd..283bde711a42 100644
>> --- a/include/net/tc_act/tc_police.h
>> +++ b/include/net/tc_act/tc_police.h
>> @@ -159,4 +159,34 @@ static inline u32 tcf_police_tcfp_mtu(const struct
>> tc_action *act)
>> 	return params->tcfp_mtu;
>> }
>>
>> +static inline u64 tcf_police_peakrate_bytes_ps(const struct tc_action
>> +*act) {
>> +	struct tcf_police *police = to_police(act);
>> +	struct tcf_police_params *params;
>> +
>> +	params = rcu_dereference_protected(police->params,
>> +					   lockdep_is_held(&police->tcf_lock));
>> +	return params->peak.rate_bytes_ps;
>> +}
>> +
>> +static inline u32 tcf_police_tcfp_ewma_rate(const struct tc_action
>> +*act) {
>> +	struct tcf_police *police = to_police(act);
>> +	struct tcf_police_params *params;
>> +
>> +	params = rcu_dereference_protected(police->params,
>> +					   lockdep_is_held(&police->tcf_lock));
>> +	return params->tcfp_ewma_rate;
>> +}
>> +
>> +static inline u16 tcf_police_rate_overhead(const struct tc_action *act)
>> +{
>> +	struct tcf_police *police = to_police(act);
>> +	struct tcf_police_params *params;
>> +
>> +	params = rcu_dereference_protected(police->params,
>> +					   lockdep_is_held(&police->tcf_lock));
>> +	return params->rate.overhead;
>> +}
>> +
>> #endif /* __NET_TC_POLICE_H */
>> diff --git a/net/sched/act_police.c b/net/sched/act_police.c index
>> 0923aa2b8f8a..0457b6c9c4e7 100644
>> --- a/net/sched/act_police.c
>> +++ b/net/sched/act_police.c
>> @@ -405,20 +405,66 @@ static int tcf_police_search(struct net *net, struct
>> tc_action **a, u32 index)
>> 	return tcf_idr_search(tn, a, index);
>> }
>>
>> +static int tcf_police_act_to_flow_act(int tc_act, int *index) {
>> +	int act_id = -EOPNOTSUPP;
>> +
>> +	if (!TC_ACT_EXT_OPCODE(tc_act)) {
>> +		if (tc_act == TC_ACT_OK)
>> +			act_id = FLOW_ACTION_ACCEPT;
>> +		else if (tc_act ==  TC_ACT_SHOT)
>> +			act_id = FLOW_ACTION_DROP;
>> +		else if (tc_act == TC_ACT_PIPE)
>> +			act_id = FLOW_ACTION_PIPE;
>> +	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_GOTO_CHAIN)) {
>> +		act_id = FLOW_ACTION_GOTO;
>> +		*index = tc_act & TC_ACT_EXT_VAL_MASK;
> For the TC_ACT_GOTO_CHAIN  action, the goto_chain information is missing from software to hardware, is it useful for hardware to check?
> 

what information do you mean?

>> +	} else if (TC_ACT_EXT_CMP(tc_act, TC_ACT_JUMP)) {
>> +		act_id = FLOW_ACTION_JUMP;
>> +		*index = tc_act & TC_ACT_EXT_VAL_MASK;
>> +	}
>> +
>> +	return act_id;
>> +}
>> +
>> static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
>> 					u32 *index_inc, bool bind)
>> {
>> 	if (bind) {
>> 		struct flow_action_entry *entry = entry_data;
>> +		struct tcf_police *police = to_police(act);
>> +		struct tcf_police_params *p;
>> +		int act_id;
>> +
>> +		p = rcu_dereference_protected(police->params,
>> +					      lockdep_is_held(&police->tcf_lock));
>>
>> 		entry->id = FLOW_ACTION_POLICE;
>> 		entry->police.burst = tcf_police_burst(act);
>> 		entry->police.rate_bytes_ps =
>> 			tcf_police_rate_bytes_ps(act);
>> +		entry->police.peakrate_bytes_ps =
>> tcf_police_peakrate_bytes_ps(act);
>> +		entry->police.avrate = tcf_police_tcfp_ewma_rate(act);
>> +		entry->police.overhead = tcf_police_rate_overhead(act);
>> 		entry->police.burst_pkt = tcf_police_burst_pkt(act);
>> 		entry->police.rate_pkt_ps =
>> 			tcf_police_rate_pkt_ps(act);
>> 		entry->police.mtu = tcf_police_tcfp_mtu(act);
>> +
>> +		act_id = tcf_police_act_to_flow_act(police->tcf_action,
>> +						    &entry-
>>> police.exceed.index);
>> +		if (act_id < 0)
>> +			return act_id;
>> +
>> +		entry->police.exceed.act_id = act_id;
>> +
>> +		act_id = tcf_police_act_to_flow_act(p->tcfp_result,
>> +						    &entry-
>>> police.notexceed.index);
>> +		if (act_id < 0)
>> +			return act_id;
>> +
>> +		entry->police.notexceed.act_id = act_id;
>> +
>> 		*index_inc = 1;
>> 	} else {
>> 		struct flow_offload_action *fl_action = entry_data;
>> --
>> 2.26.2
> 
