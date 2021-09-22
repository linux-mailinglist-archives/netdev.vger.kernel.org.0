Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466FC414299
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhIVHZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:25:15 -0400
Received: from mail-dm6nam08on2041.outbound.protection.outlook.com ([40.107.102.41]:5089
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229697AbhIVHZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 03:25:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jl9X8Crfvhphca513xiw5+d+vrhCcAF+ZE+KAr69wVN0FtxeTcWzRr1KeoGBOzmNn2fggWNzqqhQG7RICGLTug56Mq1wD4TwYE0yZRQb+pwkwQEZSQZ4Kgewe3bkvbmMOeBhbqbGhLxL88H4qrjHFPvEI/seY/uT2FzRNS+ZdsjFS0eYcKyyjNFLoutTqCmWAQaRdgKiFEAz9CVGzwxIXqFYr6Dl4XWKVSJ5b7Z56N7JUULIIyohXxYa8FT53iSngYqMlrrqiSjbz1av2UgEmLUlCTz2XGXXcvx/vbFeJdkmid2lW79LDb5d3kfl6PzL69wpqIn3FTK4WaedcwjvqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=T8RfFE96V/ukkSdBBf9/zU1uVdOofsSC339oAEg8qPA=;
 b=KlShpnxMrRpjE9Tmerj8uSW19zPmkZiFaXylzumLKV6R6nYJAMJngdUKcVHNsy/K/JSTRxXQXmJalEeW/9PuUjV10NrxhQ0nHuxklINITT6BP05s46TQHvj/qqD1ZUsyzrOQqQp+l4hgDyPxm8LZopC74D6XTeiGVBxQXhlthBnPZ3YtHRKVORsX4glGp/C9ruOI9SOEiydIvXylo9lwnW8vUh+G6oKvhy29lnzb5rbcKFgUtGqsV3eDHcl+LKa5DA/F7z4fZsJO8mcd5j0iB6hgqkwEi/33Xjn3V6C7eUimz1ACbtZBUJaVNByo0bQXLq/cqLclV5eKqmQUEKG4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8RfFE96V/ukkSdBBf9/zU1uVdOofsSC339oAEg8qPA=;
 b=CpoujzNNa7HDhSaREjhdCQzqgtzpoDP3CDQYgrVO4ncDWGtnZSOCj3Lw+jU4ZQXmdfPN1mkpvrmenfNiT/VYEc3Sn/LVFpo58KUI8M9RbaT73GcXICRr0QkHX/5mBD/s88ijwz0dn+6+HaJRziWZhH6GmdLET2MiZu3a8Jlt00wJWMu8XKVE3OIjYk1RcuI8PoV3C6WnrHnnz93nyTrr2VXWXJWIks5fTma+54augt4NJTAOJ+waokjchsOObH8cOdOEpFsBXlPPs7YKNiflK3AnhsAefh54PtI8y1xJ0lITR0XWBDAAMX8crZ/a7XUcUXfN+60MWiBsE3XEVjVh1g==
Received: from DM6PR13CA0016.namprd13.prod.outlook.com (2603:10b6:5:bc::29) by
 MW3PR12MB4428.namprd12.prod.outlook.com (2603:10b6:303:57::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.14; Wed, 22 Sep 2021 07:23:41 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::73) by DM6PR13CA0016.outlook.office365.com
 (2603:10b6:5:bc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Wed, 22 Sep 2021 07:23:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 07:23:41 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 07:23:40 +0000
Received: from [172.27.11.12] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 07:23:37 +0000
Message-ID: <6241b491-2957-e80a-6ba5-c1f2138d84e0@nvidia.com>
Date:   Wed, 22 Sep 2021 10:23:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101
 Thunderbird/93.0
Subject: Re: [PATCH net-next v6] net/mlx5e: Add extack msgs related to TC for
 better debug
Content-Language: en-US
To:     Abhiram R N <abhiramrn@gmail.com>
CC:     <arn@redhat.com>, <hakhande@redhat.com>, <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <e91b2692-2f1c-5712-1e37-db7def52cb9a@nvidia.com>
 <20210922063007.123136-1-abhiramrn@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20210922063007.123136-1-abhiramrn@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3ba02db-ba2f-4e3b-0607-08d97d99e72f
X-MS-TrafficTypeDiagnostic: MW3PR12MB4428:
X-Microsoft-Antispam-PRVS: <MW3PR12MB442850F9641C055CFA57DB33B8A29@MW3PR12MB4428.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vF5IFJr8HlmVweyd9pZljr3qAhKrHQ3jvwGGXEXds1TwMoaotGDowimQGvUNFuLNnuzQ0nnmfyEC+rMGSAMuORqX2tQDOp4M/cR+0Qtt9Jdl05hn1AKgFKMKVaXNL+6d7N6l7nyNS3cs7Y+xovPMazh5zhAtgtienWMDGsX051qTbT0IJBa8D2KqyZJMKt2fvUdeymagMnhGSVIbfhKMjzXh3FAqR0A3vdmRdV3dpipHonwyh41KPoxpouzUIx3H3fids6cCv38jN/EstHDMnSBOQLGkqyImAZ2yROtIvKxyHQKN9LLWjgBT4SPKJb50x8EC00VwI++gHOhrdb0/mOU5VhV2bdyUVGtZMmYFMto6QAp2AtowPlE10uOtmRFuytk4kv7vIubsntHmnenQ0n2DjJKZ9FTYWP6mI4YciMaveF6Bs+2XgR6nImnrs4pH3LPW25Qql+Jqh4aVAyipSgqWw578xXAEMNzG0cOVpralnoYOQrJIji2tbUMJwr0lg/rJEvi/l8VgLUpwsqlo8ubIgqG05+RNoloRensPXBicIDgn4wZHen7YPhr6pCUK02TCRkkT+U8qDGfQ2GZgVAWSGB8buPNQuwM3O/AObWUaNJuwbAr18+yMINHotguW6+G2ax0ENb89D17o5FgPrM+VKuYWmpvs3dDBpT7mPIA7hL0lxhlOmH2XJhypPbfh49+jZf/Z3saZV49OAf+glVh7isWJ2xKS/sdwk4Jw2cNofQRS7AjEfzrSuYNxqDw1mBdvsc3UtneOU54yy/o34Q==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(31696002)(36756003)(83380400001)(508600001)(16576012)(316002)(2616005)(30864003)(86362001)(5660300002)(6916009)(2906002)(36906005)(426003)(36860700001)(54906003)(26005)(70586007)(70206006)(31686004)(7636003)(356005)(16526019)(186003)(336012)(47076005)(82310400003)(8676002)(8936002)(4326008)(53546011)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 07:23:41.0573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ba02db-ba2f-4e3b-0607-08d97d99e72f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4428
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-09-22 9:30 AM, Abhiram R N wrote:
> As multiple places EOPNOTSUPP and EINVAL is returned from driver
> it becomes difficult to understand the reason only with error code.
> With the netlink extack message exact reason will be known and will
> aid in debugging.
> 
> Signed-off-by: Abhiram R N <abhiramrn@gmail.com>
> ---
> V5->V6: Removed changelog from commit msg
> V4->V5: Addressed comments (Rephrasing of msgs)
> V3->V4: Rebased net-next (Fixed the merge conflicts in net-next branch)
> V2->V3: Addressed comments (Rephrasing of msgs)
> V1->V2: Addressed comments (Removed redundant msgs, rephrasing of msgs)
> 
>   .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 106 +++++++++++++-----
>   1 file changed, 76 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index ba8164792016..0fda231c07cd 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1896,8 +1896,10 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
>   	bool needs_mapping, sets_mapping;
>   	int err;
>   
> -	if (!mlx5e_is_eswitch_flow(flow))
> +	if (!mlx5e_is_eswitch_flow(flow)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Match on tunnel is not supported");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	needs_mapping = !!flow->attr->chain;
>   	sets_mapping = flow_requires_tunnel_mapping(flow->attr->chain, f);
> @@ -2269,8 +2271,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>   		addr_type = match.key->addr_type;
>   
>   		/* the HW doesn't support frag first/later */
> -		if (match.mask->flags & FLOW_DIS_FIRST_FRAG)
> +		if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
> +			NL_SET_ERR_MSG_MOD(extack, "Match on frag first/later is not supported");
>   			return -EOPNOTSUPP;
> +		}
>   
>   		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
>   			MLX5_SET(fte_match_set_lyr_2_4, headers_c, frag, 1);
> @@ -2437,8 +2441,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>   		switch (ip_proto) {
>   		case IPPROTO_ICMP:
>   			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
> -			      MLX5_FLEX_PROTO_ICMP))
> +			      MLX5_FLEX_PROTO_ICMP)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Match on Flex protocols for ICMP is not supported");
>   				return -EOPNOTSUPP;
> +			}
>   			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_type,
>   				 match.mask->type);
>   			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_type,
> @@ -2450,8 +2457,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>   			break;
>   		case IPPROTO_ICMPV6:
>   			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
> -			      MLX5_FLEX_PROTO_ICMPV6))
> +			      MLX5_FLEX_PROTO_ICMPV6)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Match on Flex protocols for ICMPV6 is not supported");
>   				return -EOPNOTSUPP;
> +			}
>   			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_type,
>   				 match.mask->type);
>   			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_type,
> @@ -2557,15 +2567,19 @@ static int pedit_header_offsets[] = {
>   #define pedit_header(_ph, _htype) ((void *)(_ph) + pedit_header_offsets[_htype])
>   
>   static int set_pedit_val(u8 hdr_type, u32 mask, u32 val, u32 offset,
> -			 struct pedit_headers_action *hdrs)
> +			 struct pedit_headers_action *hdrs,
> +			 struct netlink_ext_ack *extack)
>   {
>   	u32 *curr_pmask, *curr_pval;
>   
>   	curr_pmask = (u32 *)(pedit_header(&hdrs->masks, hdr_type) + offset);
>   	curr_pval  = (u32 *)(pedit_header(&hdrs->vals, hdr_type) + offset);
>   
> -	if (*curr_pmask & mask)  /* disallow acting twice on the same location */
> +	if (*curr_pmask & mask) { /* disallow acting twice on the same location */
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "curr_pmask and new mask same. Acting twice on same location");
>   		goto out_err;
> +	}
>   
>   	*curr_pmask |= mask;
>   	*curr_pval  |= (val & mask);
> @@ -2898,7 +2912,7 @@ parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
>   	val = act->mangle.val;
>   	offset = act->mangle.offset;
>   
> -	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
> +	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd], extack);
>   	if (err)
>   		goto out_err;
>   
> @@ -2918,8 +2932,10 @@ parse_pedit_to_reformat(struct mlx5e_priv *priv,
>   	u32 mask, val, offset;
>   	u32 *p;
>   
> -	if (act->id != FLOW_ACTION_MANGLE)
> +	if (act->id != FLOW_ACTION_MANGLE) {
> +		NL_SET_ERR_MSG_MOD(extack, "Unsupported action id");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	if (act->mangle.htype != FLOW_ACT_MANGLE_HDR_TYPE_ETH) {
>   		NL_SET_ERR_MSG_MOD(extack, "Only Ethernet modification is supported");
> @@ -3368,12 +3384,16 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
>   	u32 action = 0;
>   	int err, i;
>   
> -	if (!flow_action_has_entries(flow_action))
> +	if (!flow_action_has_entries(flow_action)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow action doesn't have any entries");
>   		return -EINVAL;
> +	}
>   
>   	if (!flow_action_hw_stats_check(flow_action, extack,
> -					FLOW_ACTION_HW_STATS_DELAYED_BIT))
> +					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	nic_attr = attr->nic_attr;
>   	nic_attr->flow_tag = MLX5_FS_DEFAULT_FLOW_TAG;
> @@ -3462,7 +3482,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
>   			flow_flag_set(flow, CT);
>   			break;
>   		default:
> -			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "The offload action is not supported in NIC action");
>   			return -EOPNOTSUPP;
>   		}
>   	}
> @@ -3517,19 +3538,25 @@ static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
>   static int parse_tc_vlan_action(struct mlx5e_priv *priv,
>   				const struct flow_action_entry *act,
>   				struct mlx5_esw_flow_attr *attr,
> -				u32 *action)
> +				u32 *action,
> +				struct netlink_ext_ack *extack)
>   {
>   	u8 vlan_idx = attr->total_vlan;
>   
> -	if (vlan_idx >= MLX5_FS_VLAN_DEPTH)
> +	if (vlan_idx >= MLX5_FS_VLAN_DEPTH) {
> +		NL_SET_ERR_MSG_MOD(extack, "Total vlans used is greater than supported");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	switch (act->id) {
>   	case FLOW_ACTION_VLAN_POP:
>   		if (vlan_idx) {
>   			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
> -								 MLX5_FS_VLAN_DEPTH))
> +								 MLX5_FS_VLAN_DEPTH)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "vlan pop action is not supported");
>   				return -EOPNOTSUPP;
> +			}
>   
>   			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2;
>   		} else {
> @@ -3545,20 +3572,27 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
>   
>   		if (vlan_idx) {
>   			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
> -								 MLX5_FS_VLAN_DEPTH))
> +								 MLX5_FS_VLAN_DEPTH)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "vlan push action is not supported for vlan depth > 1");
>   				return -EOPNOTSUPP;
> +			}
>   
>   			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
>   		} else {
>   			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
>   			    (act->vlan.proto != htons(ETH_P_8021Q) ||
> -			     act->vlan.prio))
> +			     act->vlan.prio)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "vlan push action is not supported");
>   				return -EOPNOTSUPP;
> +			}
>   
>   			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
>   		}
>   		break;
>   	default:
> +		NL_SET_ERR_MSG_MOD(extack, "Unexpected action id for VLAN");
>   		return -EINVAL;
>   	}
>   
> @@ -3592,7 +3626,8 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
>   static int add_vlan_push_action(struct mlx5e_priv *priv,
>   				struct mlx5_flow_attr *attr,
>   				struct net_device **out_dev,
> -				u32 *action)
> +				u32 *action,
> +				struct netlink_ext_ack *extack)
>   {
>   	struct net_device *vlan_dev = *out_dev;
>   	struct flow_action_entry vlan_act = {
> @@ -3603,7 +3638,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
>   	};
>   	int err;
>   
> -	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
> +	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
>   	if (err)
>   		return err;
>   
> @@ -3614,14 +3649,15 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
>   		return -ENODEV;
>   
>   	if (is_vlan_dev(*out_dev))
> -		err = add_vlan_push_action(priv, attr, out_dev, action);
> +		err = add_vlan_push_action(priv, attr, out_dev, action, extack);
>   
>   	return err;
>   }
>   
>   static int add_vlan_pop_action(struct mlx5e_priv *priv,
>   			       struct mlx5_flow_attr *attr,
> -			       u32 *action)
> +			       u32 *action,
> +			       struct netlink_ext_ack *extack)
>   {
>   	struct flow_action_entry vlan_act = {
>   		.id = FLOW_ACTION_VLAN_POP,
> @@ -3631,7 +3667,7 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
>   	nest_level = attr->parse_attr->filter_dev->lower_level -
>   						priv->netdev->lower_level;
>   	while (nest_level--) {
> -		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
> +		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
>   		if (err)
>   			return err;
>   	}
> @@ -3753,12 +3789,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   	int err, i, if_count = 0;
>   	bool mpls_push = false;
>   
> -	if (!flow_action_has_entries(flow_action))
> +	if (!flow_action_has_entries(flow_action)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow action doesn't have any entries");
>   		return -EINVAL;
> +	}
>   
>   	if (!flow_action_hw_stats_check(flow_action, extack,
> -					FLOW_ACTION_HW_STATS_DELAYED_BIT))
> +					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	esw_attr = attr->esw_attr;
>   	parse_attr = attr->parse_attr;
> @@ -3902,14 +3942,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   				if (is_vlan_dev(out_dev)) {
>   					err = add_vlan_push_action(priv, attr,
>   								   &out_dev,
> -								   &action);
> +								   &action, extack);
>   					if (err)
>   						return err;
>   				}
>   
>   				if (is_vlan_dev(parse_attr->filter_dev)) {
>   					err = add_vlan_pop_action(priv, attr,
> -								  &action);
> +								  &action, extack);
>   					if (err)
>   						return err;
>   				}
> @@ -3955,10 +3995,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   			break;
>   		case FLOW_ACTION_TUNNEL_ENCAP:
>   			info = act->tunnel;
> -			if (info)
> +			if (info) {
>   				encap = true;
> -			else
> +			} else {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Zero tunnel attributes is not supported");
>   				return -EOPNOTSUPP;
> +			}
>   
>   			break;
>   		case FLOW_ACTION_VLAN_PUSH:
> @@ -3972,7 +4015,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   							      act, parse_attr, hdrs,
>   							      &action, extack);
>   			} else {
> -				err = parse_tc_vlan_action(priv, act, esw_attr, &action);
> +				err = parse_tc_vlan_action(priv, act, esw_attr, &action, extack);
>   			}
>   			if (err)
>   				return err;
> @@ -4025,7 +4068,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   			flow_flag_set(flow, SAMPLE);
>   			break;
>   		default:
> -			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "The offload action is not supported in FDB action");
>   			return -EOPNOTSUPP;
>   		}
>   	}
> @@ -4733,8 +4777,10 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
>   		return -EOPNOTSUPP;
>   	}
>   
> -	if (!flow_action_basic_hw_stats_check(flow_action, extack))
> +	if (!flow_action_basic_hw_stats_check(flow_action, extack)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow action HW stats type is not supported");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	flow_action_for_each(i, act, flow_action) {
>   		switch (act->id) {
> 

thanks

Reviewed-by: Roi Dayan <roid@nvidia.com>
