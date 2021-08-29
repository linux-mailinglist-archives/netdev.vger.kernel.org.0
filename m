Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583393FAB39
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 13:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhH2L4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 07:56:33 -0400
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:5792
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235182AbhH2L4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 07:56:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/UiFZqC4vuGxvbZ1q4kqSnxWvLRpBSCb7pyyfTLLBc2W6hNbTSWUqCyrxbHzcPdgzTrOgTh0FD53oJqrEbxSkLezF6pu+E8eR29SqmOzjpTFeHpx7cUtjxGoLGEzJvUR8v0NF30xoQ86JK5LGGQFXdv+6tZ+JEg4KsQG9IZrHyxDt2GQG3ADRphSEFp70pi/32YJh5LmalleQSOwecglIfGe6PDdfeNYsncBtbaq1a4GdpMZl6mHzGtaurM5bB586HcPK9rmAbjOYASPWlOb5uvCiJY5rCeCPfUalSI8r5jG4YsuYcqUyKtviHULudI/Bn8S24W//m0+IImLMW0pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flAwkjKadld7n+2b95Z3IWwd24Jidge/adofb6o8Ips=;
 b=WnI6/agRzZwtxsVhOexOPoy4AFrqtuQ93RjiLeUx+VeieIp6lZXSJsoM1R+TsycRQ3GDl5YMUQDShXNeFQzLBVRFHGQC8XUybNuOE+SlA9qbJA9ZFo31/s0zwUWTx/GQsUglFoaQNGk/LPzAhE2BxmnRoIsUUPvfb1+/ZCsE4HaHrV2UrtSV501rVuAGJPzpP2azfsLmyLho7MmoAYpy3L5dt/CW8HyJnNvb7rJuuhK5FijAKMPMRTlvUAE3sNxk49hbR1uP2RJ93foGbDm7roghuINOA4cwG878C3vDdxQ1xZRbyA0LTEcg+gf0Xi7p2gJPYp+JiaDGc7Aq8DuaYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flAwkjKadld7n+2b95Z3IWwd24Jidge/adofb6o8Ips=;
 b=XD8iPSe4zHbrNtCh9vCf/tsXA/yFsIuw1CuO/6FU1KO/j2kE9dI2iavs4i1KHJjur8TY9rcScKY2Zz+kHBo54Z1x8M9HYa/XlXGL27sKUEwBtVD5HM3TrTh9qWLwWnKgCtR5tPlFcQk45HOygi3E8wQvStHEZJZ8sUCABOfyIOnRoLuwiOgxU7bxBXKUgoxd6aDvLt5zroeIFmZ7r2gLwGWp3y4QfZHDIj2a8VYC58E4XW0cnuAEd2g/J9Umh5oIJ5HRXaR5/NpOAQlK6yP7ReifPhmHY4HVNkF/7X8ahsXL1ogXFZ62Iuoywgi2KiDgo3tL52rzWxx1pBZGhxg1YQ==
Received: from MW4PR04CA0264.namprd04.prod.outlook.com (2603:10b6:303:88::29)
 by MWHPR12MB1343.namprd12.prod.outlook.com (2603:10b6:300:7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Sun, 29 Aug
 2021 11:55:38 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::55) by MW4PR04CA0264.outlook.office365.com
 (2603:10b6:303:88::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend
 Transport; Sun, 29 Aug 2021 11:55:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Sun, 29 Aug 2021 11:55:37 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Aug
 2021 11:55:37 +0000
Received: from [172.27.14.37] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 29 Aug
 2021 11:55:34 +0000
Message-ID: <b25cb092-6793-5175-55a2-1d620949da09@nvidia.com>
Date:   Sun, 29 Aug 2021 14:55:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:92.0) Gecko/20100101
 Thunderbird/92.0
Subject: Re: [PATCH] net/mlx5e: Add extack msgs related to TC for better debug
Content-Language: en-US
To:     Abhiram R N <abhiramrn@gmail.com>, <saeedm@nvidia.com>
CC:     <hakhande@redhat.com>, <arn@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210826110253.311456-1-abhiramrn@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20210826110253.311456-1-abhiramrn@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 571d9b4d-d6a4-47e9-fb2b-08d96ae3eac9
X-MS-TrafficTypeDiagnostic: MWHPR12MB1343:
X-Microsoft-Antispam-PRVS: <MWHPR12MB13437B3045DD90E7E251734FB8CA9@MWHPR12MB1343.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LRerkrYVOE8pEJUdRpYzgZ99zlacwys+ILen2ubJSXyHplbZ1hytuwD/FxEcd6P1+k7bZ7oK8yds224en45Ttl6tmVSYUM9cnu5AC0iRSh912LZY9WPCLV6An2GXwPkctUp+vgx/RxBFsGoNGW/6zdMDIGVjTYyj2cU1sucerbYaTfCWWuzAbsxtBUr0rugXYvA+4qm7P6E3M+dE3kMeo/Q5jaMaznTtYf6ke/cJ3PKP75ZT3R0qUPa3XCsdfFZjlUWPephDfA/ue572gmLALCKD8vJnQfxIBC8Ru3UEeWHj91Al+nw3a6ipauC0h3LysrqJkdQyg7++heMBefCBYWehqEtP/csK9v+IYn5hTzzePV7vYiDUG8iPYLXG/D7uzjxqgBY31dyMGzsnb06eR9sXSerM423X2RZQb8blOr6UTvWatdnpVtzc/XndumAgV5P0qXc2+4ApmxtKgaFKqTmRgjOpew5V3BjKgwn4LXqIZ+pG/Ia/dpBCwmj6He4kLmtYy6qWbB/+5MgWWHv08Xfo3+qOhVvjxhCCHaSenRMWyjxIUO6RJE60WV2tz2aQNBJk1zcmUvXs1G9Ujuve4XRnpud9ja3qCyvxMWih8Dj94EBL7e0gfhEVsCkHP67Kw8g/37bPcYsyDgqKTezwLKi22L9ygNASWy86/tuY3Ch6K5XTsFe3OW0kIc+sie+UfBrIfSic+Jb7Nmq7oZZ2hOj96/14rhRzo8E4KnctgVuckT3QQbP1G1wiUQF/++Q7ojL0Axz5qxuE+PcWYbYdRw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(46966006)(36840700001)(36906005)(316002)(36756003)(26005)(53546011)(8676002)(5660300002)(83380400001)(2616005)(6666004)(70206006)(82310400003)(82740400003)(31696002)(16526019)(4326008)(6636002)(356005)(478600001)(336012)(2906002)(54906003)(47076005)(30864003)(86362001)(8936002)(31686004)(36860700001)(16576012)(70586007)(110136005)(186003)(7636003)(426003)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2021 11:55:37.7532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 571d9b4d-d6a4-47e9-fb2b-08d96ae3eac9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-08-26 2:02 PM, Abhiram R N wrote:
> As multiple places EOPNOTSUPP and EINVAL is returned from driver
> it becomes difficult to understand the reason only with error code.
> With the netlink extack message exact reason will be known and will
> aid in debugging.
> 
> Signed-off-by: Abhiram R N <abhiramrn@gmail.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 121 +++++++++++++-----
>   1 file changed, 87 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index d273758255c3..87faffda388d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1894,8 +1894,10 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
>   	bool needs_mapping, sets_mapping;
>   	int err;
>   
> -	if (!mlx5e_is_eswitch_flow(flow))
> +	if (!mlx5e_is_eswitch_flow(flow)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Not an eswitch Flow");

probably a better msg would be "Match on tunnel is not supported"

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
> +			NL_SET_ERR_MSG_MOD(extack, "HW doesn't support frag first/later");

to be consistent with the messages here this should probably
be "Match on frag first/later is not supported"

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
> @@ -3409,7 +3429,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
>   						   act->csum_flags,
>   						   extack))
>   				break;
> -
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Flow Action CSUM offload not supported in NIC actions");

this is a mistake. csum_offload_supported() already set informative
msg and you override it.

>   			return -EOPNOTSUPP;
>   		case FLOW_ACTION_REDIRECT: {
>   			struct net_device *peer_dev = act->dev;
> @@ -3459,7 +3480,8 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
>   			flow_flag_set(flow, CT);
>   			break;
>   		default:
> -			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "The offload action is not supported in NIC actions")

in parse_tc_fdb_actions you added a string "in FDB action" so here use
"in NIC action" to be consistent (i.e. action vs actions)

>   			return -EOPNOTSUPP;
>   		}
>   	}
> @@ -3492,8 +3514,11 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
>   	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
>   		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
>   
> -	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
> +	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Action Match not supported for the flow in NIC actions");
>   		return -EOPNOTSUPP;

actions_match_supported() set a msg. so here you override it with
a generic "action match not supported".

> +	}
>   
>   	return 0;
>   }
> @@ -3514,19 +3539,25 @@ static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
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
> +		NL_SET_ERR_MSG_MOD(extack, "VLAN IDs greater than supported");

it's not the vlad id that is not supported but the total of vlans used.

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
> +						   "ESWITCH VLAN POP action requested is not supported");

why the additional "requested" ? we dont have that in any other msgs.
also instead of ESWITCH use E-Switch. though not sure if even needed.

>   				return -EOPNOTSUPP;
> +			}
>   
>   			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2;
>   		} else {
> @@ -3542,20 +3573,27 @@ static int parse_tc_vlan_action(struct mlx5e_priv *priv,
>   
>   		if (vlan_idx) {
>   			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev,
> -								 MLX5_FS_VLAN_DEPTH))
> +								 MLX5_FS_VLAN_DEPTH)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "ESWITCH VLAN PUSH action requested is not supported");
>   				return -EOPNOTSUPP;
> +			}
>  
this is not the first vlan push. if you intended to distinguish between
the vlan push msgs. then here it's vlan push action not supported for
vlan depth > 1.

>   			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2;
>   		} else {
>   			if (!mlx5_eswitch_vlan_actions_supported(priv->mdev, 1) &&
>   			    (act->vlan.proto != htons(ETH_P_8021Q) ||
> -			     act->vlan.prio))
> +			     act->vlan.prio)) {
> +				NL_SET_ERR_MSG_MOD(extack,
> +						   "ESWITCH VLAN PUSH act for vlan proto requested is not supported");

this is the normal vlan push action. so just vlan push action not
supported.

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
> @@ -3589,7 +3627,8 @@ static struct net_device *get_fdb_out_dev(struct net_device *uplink_dev,
>   static int add_vlan_push_action(struct mlx5e_priv *priv,
>   				struct mlx5_flow_attr *attr,
>   				struct net_device **out_dev,
> -				u32 *action)
> +				u32 *action,
> +				struct netlink_ext_ack *extack)
>   {
>   	struct net_device *vlan_dev = *out_dev;
>   	struct flow_action_entry vlan_act = {
> @@ -3600,7 +3639,7 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
>   	};
>   	int err;
>   
> -	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
> +	err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
>   	if (err)
>   		return err;
>   
> @@ -3611,14 +3650,15 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
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
> @@ -3628,7 +3668,7 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
>   	nest_level = attr->parse_attr->filter_dev->lower_level -
>   						priv->netdev->lower_level;
>   	while (nest_level--) {
> -		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action);
> +		err = parse_tc_vlan_action(priv, &vlan_act, attr->esw_attr, action, extack);
>   		if (err)
>   			return err;
>   	}
> @@ -3751,12 +3791,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
> @@ -3824,7 +3868,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   			if (csum_offload_supported(priv, action,
>   						   act->csum_flags, extack))
>   				break;
> -
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "Flow Action CSUM Offload not supported in FDB action");

this is a mistake csum_offload_supported() also set a more informative
err msg and you override it.

>   			return -EOPNOTSUPP;
>   		case FLOW_ACTION_REDIRECT:
>   		case FLOW_ACTION_MIRRED: {
> @@ -3887,8 +3932,11 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   								out_dev,
>   								ifindexes,
>   								if_count,
> -								extack))
> +								extack)) {
> +					NL_SET_ERR_MSG_MOD(extack,
> +							   "Duplicated output device not supported");

you override a msg already set in is_duplicated_output_device()


>   					return -EOPNOTSUPP;
> +				}
>   
>   				ifindexes[if_count] = out_dev->ifindex;
>   				if_count++;
> @@ -3900,14 +3948,14 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
> @@ -3953,10 +4001,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   			break;
>   		case FLOW_ACTION_TUNNEL_ENCAP:
>   			info = act->tunnel;
> -			if (info)
> +			if (info) {
>   				encap = true;
> -			else
> +			} else {
> +				NL_SET_ERR_MSG_MOD(extack, "Non-zero tunnel value not set");

i dont understand the meaning of the msg. non-zero value not set.
Did you mean zero tunnel was set ?
Maybe use "Zero tunnel attributes is not supported".
Not sure we can get here unless there was a bug from flower.


>   				return -EOPNOTSUPP;
> +			}
>   
>   			break;
>   		case FLOW_ACTION_VLAN_PUSH:
> @@ -3970,7 +4020,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   							      act, parse_attr, hdrs,
>   							      &action, extack);
>   			} else {
> -				err = parse_tc_vlan_action(priv, act, esw_attr, &action);
> +				err = parse_tc_vlan_action(priv, act, esw_attr, &action, extack);
>   			}
>   			if (err)
>   				return err;
> @@ -4023,7 +4073,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
>   			flow_flag_set(flow, SAMPLE);
>   			break;
>   		default:
> -			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
> +			NL_SET_ERR_MSG_MOD(extack,
> +					   "The offload action is not supported in FDB action");
>   			return -EOPNOTSUPP;
>   		}
>   	}
> @@ -4731,8 +4782,10 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
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
