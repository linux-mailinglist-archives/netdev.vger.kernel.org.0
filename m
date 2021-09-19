Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70093410A92
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 09:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhISHlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 03:41:40 -0400
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:58220
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231495AbhISHlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 03:41:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5Ug5/5M/7T7lX0ligAJKl4ym0tZkaty8LxUjSNgcD+AZhjMc3Y/MoQ1AN/4TrXBnRxGlgokFswbADuU05pH+yBZNqiZ0ywX2cj1IjB26xzWCat6isUHC8iXXD8mzc3GI657W9ah41YdAKBzW1ZVRUZEZ4OZ4qUO0P1Yk81vsJcz4Y7KKryKyyJ5LAB1yk06y9/hgi5s5pNSYYGDyAt77ZrVge/+FRGtrrpRFvOCZKy7/tWYPoF/sKFKwU6tJsnnCftjkTn4L6jJThUEiRno/cdHJU7MrnkMvSAntgXw/7OtGCYE8WwsWgrgUR2A+55RNOZCO9UwTGfmJno9wCeC9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wtZWXqo2x8u3YiIQ/+yjlYi8OAE9Vn6wUrEvLAl1900=;
 b=lxNl+Bw12GcNJhLaPmInBFliBF5ODRljxPhGFAmO1O5VNNMff60GAuMP35xz9k/54x+KohHQJRQo5gq5IwHraweNa2G5uWKvWCO6ATuudT8K5KKeRTWxRdbWLHlZi3EBHBAHXENePSkHniZkRGIBWI9OOuyAlS/aAYUNipKD0f20n8qXSvKf6TvhA9p6sLZWPK07Jp8XDmI2Iid5C0pFeyTjItmNptMF/jOo1y9vh6OcfBfa+oOCeQZjJemHupjZB++64UAxu9KECGkgCCPtWIHsN+aHTz0Ur1UFQWrukw3+HX1KO124nA1r9QWpHU8N/IjhzHQ7bD4SccvmQogDIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtZWXqo2x8u3YiIQ/+yjlYi8OAE9Vn6wUrEvLAl1900=;
 b=LvYuMfs8Oqw9gjwApF1PfRne9GLd2v+rX7Jt+1kfxE11xVCUTrpZG/iLHj/uYxIlun3wj7Rqu4GMiTe/PK+fahoU+vpbCDOfODqh6uJ4kiqaBbawO8y6c9MNmO+5wnlWu72Ept6biU40HfuDq9y17KkXFQ0M5L+j7/cBJKlldVnCoFxHJQzn6DRPN9ioUusdSZFwEu9wBHlEMTo8Ed+HR6JBGo0HJlhDAB89G/jeimeXMrhmyJXy1eleiRyn3WaKSsYWEDwhHsVLwp/P4ujmMakLUYApLlG0vJyjPvwD1IEkA9FvyVRq89Of+pjoVexG86BP3dTSnp7vWVTZUNIipA==
Received: from BN9PR03CA0309.namprd03.prod.outlook.com (2603:10b6:408:112::14)
 by BN7PR12MB2611.namprd12.prod.outlook.com (2603:10b6:408:27::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Sun, 19 Sep
 2021 07:40:12 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::45) by BN9PR03CA0309.outlook.office365.com
 (2603:10b6:408:112::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Sun, 19 Sep 2021 07:40:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Sun, 19 Sep 2021 07:40:12 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 19 Sep
 2021 07:40:11 +0000
Received: from [172.27.12.123] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 19 Sep
 2021 07:40:09 +0000
Message-ID: <b2f9291a-4c6f-99f5-00be-21dfef110e12@nvidia.com>
Date:   Sun, 19 Sep 2021 10:40:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101
 Thunderbird/93.0
Subject: Re: [PATCH net-next v4] net/mlx5e: Add extack msgs related to TC for
 better debug
Content-Language: en-US
To:     Abhiram R N <abhiramrn@gmail.com>
CC:     <arn@redhat.com>, <hakhande@redhat.com>, <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <76ab8d32-4457-8dd2-8df0-d31919d8441f@nvidia.com>
 <20210914115053.42338-1-abhiramrn@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20210914115053.42338-1-abhiramrn@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 633ac520-f001-4838-ded6-08d97b40b6c4
X-MS-TrafficTypeDiagnostic: BN7PR12MB2611:
X-Microsoft-Antispam-PRVS: <BN7PR12MB2611D2F1554866F1908E0E05B8DF9@BN7PR12MB2611.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0umVQFgVqJ+DMxy9xb0DBcePLn8qximWglnl/+SmSk2k4WrqZSgM4m9Az80tHBRVhE6IPvJP6jQeWv4khDlJdIIv1eXVWNqy3k+9NOJZeSIyuuwB63Cnu8askDNj7vnLfIx1iVoDOOSnjS5e4lnMt34P50gEQ1+RXs/0gE5rI6DZjos1w460Qxf6WmsvBzGGWvSRnNXtCZJqCLqXQRDvrq/JqE3IkrnQYKTnG4wDH3Nrhxs+auqXUZd5csxtdTj9unMIdZM8jEETt9ck5fXgztf2vB0lf2Ppast/slvhNQDKZLzpXBzYQMXL+r876IDDT5dn310XO6ZnD5jReNAfd3O1j941ZeeTuTCtlgpoHdKy37HW7qJsnl6wbu2fMVswiaBBlHx3fPo0KbOk8CS+tKOJ1kbzOOZ4j+0IARTBQxLi0MD6+aNB+VXP5Z6NCub8aWxHsA+1nYddvooaSUBn+wbTZ2bWsxSr1hqPXF+ZeloJ40J8CbL/Vxi78uJPLqVo8joRlqrJHb/9aqb8SWObR6wdmwp1C3hY6T7e9YfmNuR+/gXJAMXHlKwdxBMAkTAs3B8o1sjc83cCI4ASB2eFrCBpBhEFnKngLoUuGK956ory6HRQbwd/2iifrVBEvbO9/Vl75ufN9YjoLHB9LNCUT0LEFrcfVGjtjPxcU0/YGoZKIRLeGkCmehWIpvQibUtBA4hKMZJoU5Yq+pC+DakQpvP7Y8GNhCnMaqpx7Ay0IFOAiWAyUFmdyw9mWxNMoTZtMVkb6Uv7m3A881BML4IiuQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(36840700001)(46966006)(70206006)(47076005)(5660300002)(8936002)(30864003)(83380400001)(336012)(82310400003)(70586007)(53546011)(26005)(36756003)(36860700001)(82740400003)(478600001)(4326008)(426003)(6666004)(186003)(6916009)(16526019)(316002)(7636003)(16576012)(36906005)(31686004)(356005)(2906002)(31696002)(86362001)(2616005)(8676002)(54906003)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2021 07:40:12.2355
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 633ac520-f001-4838-ded6-08d97b40b6c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-09-14 2:50 PM, Abhiram R N wrote:
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
> index ba8164792016..0272ba429c81 100644
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
> +		NL_SET_ERR_MSG_MOD(extack, "Flow Action doesn't have any entries");

There is no need for capital letter in action. just "Flow action .."

>   		return -EINVAL;
> +	}
>   
>   	if (!flow_action_hw_stats_check(flow_action, extack,
> -					FLOW_ACTION_HW_STATS_DELAYED_BIT))
> +					FLOW_ACTION_HW_STATS_DELAYED_BIT)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check not supported");

There is no need for capital first letter action.
also the msg is about hw stats type so a better msg would be:
"Flow action HW stats type is not supported"

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
> +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check is not supported");

same here.
the msg is about hw stats type so a better msg would be:
"Flow action HW stats type is not supported"

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
> +		NL_SET_ERR_MSG_MOD(extack, "Flow Action HW stats check is not supported");

same here
the msg is about hw stats type so a better msg would be:
"Flow action HW stats type is not supported"

>   		return -EOPNOTSUPP;
> +	}
>   
>   	flow_action_for_each(i, act, flow_action) {
>   		switch (act->id) {
> 
