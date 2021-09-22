Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5258E41417A
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 08:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhIVGE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 02:04:29 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:53473
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231908AbhIVGE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 02:04:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsPcyDN+piu/o97OnQ/OOCngJenR0N1kzf+EokMLOr77i76hiBBqAJFILVWpmLImtsD15H7hvlshE4fzgLnjuLBXCuywR22cEu8p53p6fo0a/cA1euyV7PCa2XNxEEvOuF7fIwU7KAAS2aIzmhggQK0IoODueXLqLiiA9xMM3dgPaNpKYcVN5IzCEoTqROBztYJC1Lbql8QYcUwS7OHBkTZpLeo7K4n++GFkjt1S0p87hqKps+ojmIVknUDM9dIm8py4O5VZsa2b6T9AbyzcwD7lYGc6DNBTkLtBuxOWBLuHzCzxwIArIbP/adAsMdDZHjz2SoHw03Exeoh0AGEBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8eszHl9+F7JQ4aYQ+K3bW2Z1Ou9SUJFtyUg3/naUFkE=;
 b=gb/mE9zfnQtJkEiQVYN92oriNHfXaI35OPU49pWplF0s4q5wz/p/n7MY5xeMyFRXYRfQs8qvNMlRXD7kfFyCWb3oTEF6S89RvxQY5RST/g8H8Qnaxk7j6xqHvP94kUyAGiR3LKU9sJU1VFebtv7rtTRiBsC8DHnBdXYmAViAfgz68Y0iJMom0NeGmLFZbbjjOlnl6/LeHWGsrNk/g9tjL70zevuFgYSSjiRQu7jU+eMre3PWYOWnHxjlIDyGfOoUvrnfI9OrvPwZDksVloAVVgpYuTmVfRdIKa/WlDj5n9q43lub8782dYcrvO3QqaRyXTzp40fYX2FuXKfghiBalQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8eszHl9+F7JQ4aYQ+K3bW2Z1Ou9SUJFtyUg3/naUFkE=;
 b=EF0aiPQUYWumJffgCLPPIdf4KtEkh91421uQ4NAqkAo42zH3LCkdO0spwtmHXW7kY874Lp0bGub2CGAvQ/S241QSviuXfaETBqb8V/NZMneS1UrFZJqKUSqzT8gwewYhybOqYXOXvRAyPj2cpmje5aI2xov6u1AzTuBs3ZGsx0LXrR/7zlq9CK/Iqc+SrzxJhUumfpBkUMWRnBEkCMxgK0ycvyReOdSF8GQHSF7KGULxnYac2kTHKfqneOULswUEPCj0+huVdc9L15sJnHTN9sUcbKt1e72oRvC0qxLY3RtAZWoQG9wF4yN8UAKMby1ujj0R7R9wYUttTFYvo8BzvQ==
Received: from DM5PR16CA0025.namprd16.prod.outlook.com (2603:10b6:4:15::11) by
 MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 06:02:57 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::4a) by DM5PR16CA0025.outlook.office365.com
 (2603:10b6:4:15::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Wed, 22 Sep 2021 06:02:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 06:02:57 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 06:02:56 +0000
Received: from [172.27.11.12] (172.20.187.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 22 Sep
 2021 06:02:53 +0000
Message-ID: <e91b2692-2f1c-5712-1e37-db7def52cb9a@nvidia.com>
Date:   Wed, 22 Sep 2021 09:02:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101
 Thunderbird/93.0
Subject: Re: [PATCH net-next v5] net/mlx5e: Add extack msgs related to TC for
 better debug
Content-Language: en-US
To:     Abhiram R N <abhiramrn@gmail.com>
CC:     <arn@redhat.com>, <hakhande@redhat.com>, <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <b2f9291a-4c6f-99f5-00be-21dfef110e12@nvidia.com>
 <20210919191648.9953-1-abhiramrn@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20210919191648.9953-1-abhiramrn@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17b7f828-a50c-4ebf-b99a-08d97d8ea01d
X-MS-TrafficTypeDiagnostic: MN2PR12MB4175:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4175AA15B2241BAE3DB81CF7B8A29@MN2PR12MB4175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3gDkSuujgAwlTk84N6y6PZzRRCtqAT1dhbTnMgWg93Y4YmZLvfcminf2MYCLPUH4cdDpPOGN0n73CiALCYjbQri4HC98Gr8DbsmLt+2ysloeKZK1PZd0Nph2F54GCAjs80at45xR0JPy2osJFJvQidUCAHk8U4sixr3crK6AfHB7w8iPgUtL3O1zrT6dk9EwVWRMRb5Of8v5Q9lQqmW0qNv929odTNEzoTStbdOW12gLvS5Jx397vJIqwPpdHQ1PYt3U3z9S3DRGLgcK9c/K1n0ipjLawnOc3fA+rUdRzBGebafTixVrxdR0jNDfm+dkhYPhG+NV87aPCviQnRpqQmcJlgy67tR+MPLtl1M+N18ekIFaasbGutYTn6bITUhvsszfhR6VUnH2G5kuFAQxHkwAMDqixPeiOW+O4OyGMGF8fQruRrD+ZakUxAuvABM+bKNEJJGJc5c6sFL58xNVONMMO0C4HWRlHjkSMxsoXMTPNFPbP8/FwfJ97MLtK+Ekzm4yUWJETgXrRyEkLMWv7YEMYw6nbr7wQHBMzBIuNF4LR0G6yliDcnho4nG67McZW9SEKuEf10a47X4vXNQD6GdBUJkbu5v0IGy85ay33WvRFrts6fe10SfaChskTED6vWxQEFJYGqj2QzJLGJuYvpH1ZSsm6lbl/Z7SlTypuebhI4oUkGSjzsFbqxdR4RfF395DqGFYgLuIQ6iiRwREF/zgVJGXBDG6SWotgCCiAOGYr7yi/NJU0TSc/VvXKd6/nIrVkQZFuebzZohqLvpQ8A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(82310400003)(31696002)(31686004)(30864003)(54906003)(356005)(508600001)(7636003)(336012)(53546011)(36756003)(36906005)(16576012)(8676002)(316002)(8936002)(70586007)(26005)(5660300002)(186003)(70206006)(86362001)(4326008)(83380400001)(47076005)(16526019)(426003)(2616005)(2906002)(6916009)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 06:02:57.3707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b7f828-a50c-4ebf-b99a-08d97d8ea01d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-09-19 10:16 PM, Abhiram R N wrote:
> As multiple places EOPNOTSUPP and EINVAL is returned from driver
> it becomes difficult to understand the reason only with error code.
> With the netlink extack message exact reason will be known and will
> aid in debugging.
> 
> V4->V5: Adressed comments (Rephrasing of msgs)
> V3->V4: Rebased net-next (Fixed the merge conflicts in net-next branch)
> V2->V3: Addressed comments (Rephrasing of msgs)
> V1->V2: Addressed comments (Removed redundant msgs, rephrasing of msgs)
> 
> Signed-off-by: Abhiram R N <abhiramrn@gmail.com>
> ---

hi

the changelog is not needed as part of the commit msg.
it will have no meaning after merging.
the changelog should be here after the three dashes.
everything else looks ok to me but can you move the changelog to
this part.

thanks

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
