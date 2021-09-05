Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB29401007
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 15:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhIENk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 09:40:56 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:35235
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229759AbhIENky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 09:40:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTpL7kLA2hGHZWWsZ8MbzNbxW2/L59CBNLX9MfldOVQbzBgPVj/JDDVQN3J3+JY/HOscH2aHxoNae9/sy+y644zfAAajJdjUXFAdpfuwyC4AiJMpVPv9izBkOw+mc5ufkxInt8ssH71vai5g9keUBrMizac8FXABbtIOPV7Axu886z5/HpwBfL40f2QDwJ531/E9YZ4B8zLFhZEK3M7dkQReYPSe1ixzpeYukYvFOiviHUiC9NFSCV9sdZl3XzxvD/Rf4KHXcIbGN7bsNrv3fdN31kMF5l/umAld80hmJrT4aXVrZViTV6OZamfa7JPSqatqnhfOzzfM6+LSn15wkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SywhyGExZ4+AwY47CgrOSluwZYPsmBRR4xoGSVWi/6g=;
 b=OmFuVvOclwmxAs8lFhrcrTvvAxonB+OH+n+mjgSUa3OEcDI8vbVTlHz8hsTGgnfabHOB5jVcmCnHvYAuBT/ppWxs6ZwkHbuwFI6LKKYbmiB5TNfWiU38Y9rietmcrXjAAxq0ZT+LHNX+db7YiNGPQtm182gbOb4HCa1jZ6340UwIktysWYfkPlrMWvj1+5S7xqVApQjuS40+e5woVV8rJkHMB1m4dmEvyFgth3s09fgJGwx9bV8CR9IxX1kMxOdVNekK+8RK/xIrkTtXu/eKwcHKKPLhpa5qzMa0XI/GtfjpLAioXWu4gucRdpzWMmjes1RnwZGpYvlPTzxCEEdyZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SywhyGExZ4+AwY47CgrOSluwZYPsmBRR4xoGSVWi/6g=;
 b=ABtOrpScOhfWJoOBv5DQ0vQQgEp7aXdTcbdRxMbYM+tJEYtB17/y5OWeO0vQfvY421RKFDtmbxdCNJ8x/jfWNeVX8T1aJ+geVQ+s5pjFOGlMVkE+IRBNHMbpTzc0bLy1aqYSuph325fDwV0/EDJ6tQgywycuWDPj2XP1ay0AL3FOl/nZMMaIynBm4oTunJ+6eeyLzFKzlCUIiSyZC/E3UKWLpqW+IvWEzA75NITuCLl+6E0hr31uujac8nH1gh59QvJNNmu0aYkPdNsUNJNaiH2zuYxR8HTV3noxNpwIwckFXwypjRY+Ku5w5eg84nxuacCg6/6mEOOakh4B0C+zpg==
Received: from MW4PR03CA0019.namprd03.prod.outlook.com (2603:10b6:303:8f::24)
 by MN2PR12MB3887.namprd12.prod.outlook.com (2603:10b6:208:168::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Sun, 5 Sep
 2021 13:39:49 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::c2) by MW4PR03CA0019.outlook.office365.com
 (2603:10b6:303:8f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21 via Frontend
 Transport; Sun, 5 Sep 2021 13:39:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4478.19 via Frontend Transport; Sun, 5 Sep 2021 13:39:49 +0000
Received: from [172.27.15.40] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Sep
 2021 13:39:46 +0000
Message-ID: <76ab8d32-4457-8dd2-8df0-d31919d8441f@nvidia.com>
Date:   Sun, 5 Sep 2021 16:39:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:92.0) Gecko/20100101
 Thunderbird/92.0
Subject: Re: [PATCH v2] net/mlx5e: Add extack msgs related to TC for better
 debug
Content-Language: en-US
To:     Abhiram R N <abhiramrn@gmail.com>
CC:     <saeedm@nvidia.com>, <arn@redhat.com>, <hakhande@redhat.com>,
        "Leon Romanovsky" <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <b25cb092-6793-5175-55a2-1d620949da09@nvidia.com>
 <20210831084406.12825-1-abhiramrn@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20210831084406.12825-1-abhiramrn@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 039b2299-3354-43e6-39f1-08d97072a1e7
X-MS-TrafficTypeDiagnostic: MN2PR12MB3887:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3887BFE41311DE0DA08DC729B8D19@MN2PR12MB3887.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMZSNCXHA+xnkpfPaFYUyZWzkOlqMGH5dvHp4jrLdGXMQjf/K908eObF4TqZFoKowkmx7pquJX0ySgF06lG1oaO9B4gtSVr9igH5J4Nvd0l3ISIvrJ37ZWgaUrPvWETEpD714R6muyI84jqZs+/AGksv7/ffhZ2OwWeFnlf6eXhDpDvmUMaQyBYAMwXApIeORjTrQIbxrXcrGwK2if1NyeZ6z3Sa3nbStnEinO0fspcev6FBccagxaE6Ze3CMrRjKxGHaLIY3lDja3GLA/8xAFT6fjoRAjSfFHTwFoRefvau+/cmmbNSQH9RPpR3nlENHOX4ppMvm/q/GN41vO3nh+btPcEJvtBgoBJ3bR/4jIXzxVjXCggorkhQGE9mbrj/W/lPVeqyDVXeIuU2fqm+RH1uxJp+2qWQ27xbVwH6DzpcntQuYPS9AJ0c19M9hMCZcAehkWHkpFo/pV6il9ZIKb9N8RDmD+pjZBIn8+tXygWQ+DEQKeB9//T9L+HKLcwPNjN9TYyT03007ikI4SS7NdEoGKdVPogJPllrIOX6Xpj/Z2IGNtY81sdF7rRLyw4GRlCZ7HccmLL1Ql3v7fBH3jW7XvAxNN90z9ChAO82+fGwAUsio04E0RgkHj3LekgOf6UGjth5xFY4DzoSzzMOEimVFBPrb3pUjoNfd61pG9GHPhmmrLc1/8QQXOt5M//NoTtGn5Y3QiMOXPUjqRm8x8UO/TqIguFcb5Khcx+DLtQSGmDOMSgePG5pHCKChqlo1grfT4LixYUcml43QkAdQw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(46966006)(2616005)(36860700001)(426003)(478600001)(4326008)(5660300002)(31696002)(31686004)(70206006)(356005)(186003)(336012)(86362001)(82740400003)(6916009)(16526019)(70586007)(26005)(6666004)(54906003)(30864003)(47076005)(36906005)(2906002)(7636003)(8676002)(16576012)(82310400003)(316002)(36756003)(53546011)(83380400001)(8936002)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2021 13:39:49.3024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 039b2299-3354-43e6-39f1-08d97072a1e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3887
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-08-31 11:44 AM, Abhiram R N wrote:
> As multiple places EOPNOTSUPP and EINVAL is returned from driver
> it becomes difficult to understand the reason only with error code.
> With the netlink extack message exact reason will be known and will
> aid in debugging.
> 
> Signed-off-by: Abhiram R N <abhiramrn@gmail.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 106 +++++++++++++-----
>   1 file changed, 76 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index d273758255c3..911eab2acaad 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1894,8 +1894,10 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
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
>   	sets_mapping = !flow->attr->chain && flow_has_tc_fwd_action(f);
> @@ -2267,8 +2269,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
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
> @@ -2435,8 +2439,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>   		switch (ip_proto) {
>   		case IPPROTO_ICMP:
>   			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
> -			      MLX5_FLEX_PROTO_ICMP))
> +			      MLX5_FLEX_PROTO_ICMP)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Match on Flex protocols for ICMP not supported");

can you add "is" as ".. is not supported"?

>   				return -EOPNOTSUPP;
> +			}
>   			MLX5_SET(fte_match_set_misc3, misc_c_3, icmp_type,
>   				 match.mask->type);
>   			MLX5_SET(fte_match_set_misc3, misc_v_3, icmp_type,
> @@ -2448,8 +2455,11 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>   			break;
>   		case IPPROTO_ICMPV6:
>   			if (!(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) &
> -			      MLX5_FLEX_PROTO_ICMPV6))
> +			      MLX5_FLEX_PROTO_ICMPV6)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "Match on Flex protocols for ICMPV6 not supported");

can you add "is" as ".. is not supported"?

also, can you submit this patch to net-next and not net please?
it's not really fixing an issue and will help avoid conflicts with
changes we plan on this file.
thanks


>   				return -EOPNOTSUPP;
> +			}
>   			MLX5_SET(fte_match_set_misc3, misc_c_3, icmpv6_type,
>   				 match.mask->type);
>   			MLX5_SET(fte_match_set_misc3, misc_v_3, icmpv6_type,
> @@ -2555,15 +2565,19 @@ static int pedit_header_offsets[] = {
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
> +	if (*curr_pmask & mask) {  /* disallow acting twice on the same location */
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "curr_pmask and new mask same. Acting twice on same location");
>   		goto out_err;
> +	}
>   
>   	*curr_pmask |= mask;
>   	*curr_pval  |= (val & mask);
> @@ -2893,7 +2907,7 @@ parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
>   	val = act->mangle.val;
>   	offset = act->mangle.offset;
>   
> -	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd]);
> +	err = set_pedit_val(htype, ~mask, val, offset, &hdrs[cmd], extack);
>   	if (err)
>   		goto out_err;
>   
> @@ -2913,8 +2927,10 @@ parse_pedit_to_reformat(struct mlx5e_priv *priv,
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
> @@ -3363,12 +3379,16 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
>   	u32 action = 0;
>   	int err, i;
>   
> -	if (!flow_action_has_entries(flow_action))
> +	if (!flow_action_has_entries(flow_action)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow Action doesn't have any entries");
>   		return -EINVAL;
> +	}
>   
>   	if (!flow_action_hw_stats_check(flow_action, extack,
> -					FLOW_ACTION_HW_STATS_DELAYED_BIT))
> +					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check not supported");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	nic_attr = attr->nic_attr;
>   
> @@ -3459,7 +3479,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
>   			flow_flag_set(flow, CT);
>   			break;
>   		default:
> -			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "The offload action is not supported in NIC action");
>   			return -EOPNOTSUPP;
>   		}
>   	}
> @@ -3514,19 +3535,25 @@ static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
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
> @@ -3542,20 +3569,27 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
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
> @@ -3589,7 +3623,8 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
>   static int add_vlan_push_action(struct mlx5e_priv *priv,
>   				struct mlx5_flow_attr *attr,
>   				struct net_device **out_dev,
> -				u32 *action)
> +				u32 *action,
> +				struct netlink_ext_ack *extack)
>   {
>   	struct net_device *vlan_dev = *out_dev;
>   	struct flow_action_entry vlan_act = {
> @@ -3600,7 +3635,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
>   	};
>   	int err;
>   
> -	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
> +	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
>   	if (err)
>   		return err;
>   
> @@ -3611,14 +3646,15 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
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
> @@ -3628,7 +3664,7 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
>   	nest_level = attr->parse_attr->filter_dev->lower_level -
>   						priv->netdev->lower_level;
>   	while (nest_level--) {
> -		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
> +		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
>   		if (err)
>   			return err;
>   	}
> @@ -3751,12 +3787,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
> +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check is not supported");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	esw_attr = attr->esw_attr;
>   	parse_attr = attr->parse_attr;
> @@ -3900,14 +3940,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
> @@ -3953,10 +3993,13 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
> @@ -3970,7 +4013,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   							      act, parse_attr, hdrs,
>   							      &action, extack);
>   			} else {
> -				err = parse_tc_vlan_action(priv, act, esw_attr, &action);
> +				err = parse_tc_vlan_action(priv, act, esw_attr, &action, extack);
>   			}
>   			if (err)
>   				return err;
> @@ -4023,7 +4066,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   			flow_flag_set(flow, SAMPLE);
>   			break;
>   		default:
> -			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "The offload action is not supported in FDB action");
>   			return -EOPNOTSUPP;
>   		}
>   	}
> @@ -4731,8 +4775,10 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
>   		return -EOPNOTSUPP;
>   	}
>   
> -	if (!flow_action_basic_hw_stats_check(flow_action, extack))
> +	if (!flow_action_basic_hw_stats_check(flow_action, extack)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check is not supported");
>   		return -EOPNOTSUPP;
> +	}
>   
>   	flow_action_for_each(i, act, flow_action) {
>   		switch (act->id) {
> 
