Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C934B0DB7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbiBJMoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:44:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbiBJMoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:44:30 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08hn2211.outbound.protection.outlook.com [52.100.163.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F38F48;
        Thu, 10 Feb 2022 04:44:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeUtxI6+CpnDHCeQLgGrBYyA4mdUaqkSEyvWrOM0wvSb9FiVHHJL8i8Eb77NM2zBpGzTCgnAeqyyVqcfqoN/ojH8mwcBXTFj+lMPpHbetasd9c9D3bfpjjCy0/utAg/FTeT2wbl/c/YFcvL2+0KRvDoTiKB8/sMHesF3BjFKB/A/lLbAKz9aS6wYXUjushuhfm5wjN/r0eogtrOJ28IfY+vyNutGsr9t8S9NFneR2r4a9Oy2CnCR6lGmRZRdKDE01P1AazkYM8yjNGCHdHXH//yNfnHIcYvbY+onZI3xqZW7teCbK+puyasn2YcNHQi7AX80RLRmfjWBeAK+5ETiTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fgs6YC8Cny2LxtYfQvXpMcu00TeNmrqVU8Y/318jYhk=;
 b=kY+P/gWA/HtFqHT/C+BRRmRp8HwVE0NKz5LoLPodqYVrrLvr9XGsXKUzW7/VkXRhIT97FL4T9WsVqkXupXS5B62civ7nlsIp0lwVlHknDpdgpURwaa6z4Je2Eo7ROrGY3kij3OmljHnnCnmJrZiqRMI5VIb8imt8iJt9Jo6ZsRCWsalQTfy7dIqc+EsWu7rfSynkdENRVDLrZnRBXaIvqOaS0OR3nBNR/tx4IDEV//D3IQ5aWSpxyQgEXlwcC+hvnLWjBVEB4HjOPWj4o8iHv8k2KPqyPJvf3tbFnh4FvLtSpLPCgoNkkHTcWRAVqB5KXaB6xuNJPnheBgUGC4meyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fgs6YC8Cny2LxtYfQvXpMcu00TeNmrqVU8Y/318jYhk=;
 b=LMHKzqagCoeYcSHjoet4iE1zh4E0BLXhiKlp4LFwhUVckHsNfDjG0SLuJ0AKWkf5V0jyQyf2BqfZelj+VDzwt4enBQYMvDSPJofgBcQT2+F9v+N3LtDlcEhkZ9wzh6tnjXXLTfHJ22x3e8tYPDZeU9xeOUZNVcDcukH90L3pU3NdZYLdIxtnKsDyok34qMvI2dHVcA/WRLzEaohc3NqMovfSdQ421szCMRbc6wqspDtKxQe9n70L3tAKCmRVSzJp8k3mc03+osz/CHgFcb4oMINrQW7lEQWNuHepl+k4rpd0xpj3qAI5wlN82jb9XCykCnWx20V9FVRDcUhSXXRNjg==
Received: from BN6PR20CA0055.namprd20.prod.outlook.com (2603:10b6:404:151::17)
 by MWHPR1201MB2476.namprd12.prod.outlook.com (2603:10b6:300:de::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 12:44:29 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::f4) by BN6PR20CA0055.outlook.office365.com
 (2603:10b6:404:151::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Thu, 10 Feb 2022 12:44:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 12:44:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 12:44:27 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Thu, 10 Feb 2022 04:44:23 -0800
Date:   Thu, 10 Feb 2022 14:44:14 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
Subject: Re: [PATCH net-next 3/3] net/mlx5: Support GRE conntrack offload
In-Reply-To: <20220203115941.3107572-4-toshiaki.makita1@gmail.com>
Message-ID: <cd58c021-40e3-8c9d-30f4-fc499e77a65@nvidia.com>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com> <20220203115941.3107572-4-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aac6571c-de47-43a3-18b7-08d9ec9313b8
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2476:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB2476F1BC037417015C85F846C22F9@MWHPR1201MB2476.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:326;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Y6TfEpm+7BqoFVy2vPpAUTW4Svt9Fq+mWa1FzraG5JLrBOZTIbVD8yI7f0Ka?=
 =?us-ascii?Q?89sd5oNiCN4HqKZgZsou39fDXhNU3e5fkfIPtiL2AVqC3V67M9gSJdKb+vHm?=
 =?us-ascii?Q?F1l5Ompe0URxUR9Av+qXCWjuppqJ5LxhkT7UHsJuqYrmtMiJyEM5zPBiydZI?=
 =?us-ascii?Q?MPInlul2E94IiN2nWovdse/PvB8zYlxuBjAzBDvWgzv01Aqht5rGFdDWP5ZN?=
 =?us-ascii?Q?+qGeIw1t7BCVPOi4A4yu2qD+G2XPUa9q1vg9DA4UiZZl5PNLiFHsMn9O2paO?=
 =?us-ascii?Q?0OuyINDComzLNT9K5udnjbqpasmDwaQc/LTjaz/qgHDHu03eu9BvTima91/A?=
 =?us-ascii?Q?KxMkr2agWxrMJl2GEa7kG7UjoXXa4ZK4751wcIjTLh3Aj/bNecaqjFkbSWe3?=
 =?us-ascii?Q?oa4Yxh4G/2jNV/MNb6yDNjVYCtoAZQs2MOO0MB4f4ggmWXJAKLomoaUfh4jb?=
 =?us-ascii?Q?BMWy4EfRd1SFgcLYSDDAHnQtNaCJkhKwE16F/gGB5EfqJO0bBXp4bsBL2UrB?=
 =?us-ascii?Q?5Eh7+ChW/WwJy61ZDRnFvicqDDEQO6YhOJA068JzkujfS+wZp3W/0tBxENHn?=
 =?us-ascii?Q?+ZvIDyn1wkLsdM2QLp0hm2cX19xDVVXrfwkSctuiJ65JrwJRjbNT8PAvdcKp?=
 =?us-ascii?Q?86Jtbmn2lFMkgoji2mfe4RgU0y8Ym2r68Jsphj8Avdba34o2iqzFGkU6/VbG?=
 =?us-ascii?Q?ZWbBVOzr/pqbsA9I2IBRxbITHOI4OMuxApnpoM4ROB8wTM9u/edoHNs6ctE7?=
 =?us-ascii?Q?+O85wuPLBsZ797TFMQIp9s4/SmUo8OSY4B0xK/fAI9A+Es99Te9ps06EFqAP?=
 =?us-ascii?Q?Z7WuqO55STRmV4vSLu/Fk37QC+kUWsj4QOFmbqqBOL1p6l95IRT24mb9Chxl?=
 =?us-ascii?Q?ARYfKjapnQuVUuf3zuU1TFSY6eUklbwrx1cL6KR1CY1Mg/byd4hcjSx04at9?=
 =?us-ascii?Q?MPXSg+EajIIWMm0Qcy/izB+tSKKlAKPKuDkuKrK9fvm2NPVpMKpWc5TUDP52?=
 =?us-ascii?Q?gvQJRxIfkXVHXRftIrjtZ57iQxaf7G0yGcUL7IKiy2xQd+WCLphrASgmpIRb?=
 =?us-ascii?Q?22sP9NUd?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:5;SRV:;IPV:CAL;SFV:SPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:OSPM;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(2616005)(426003)(26005)(16526019)(4326008)(336012)(36756003)(54906003)(6916009)(70586007)(8936002)(8676002)(316002)(70206006)(5660300002)(508600001)(2906002)(82310400004)(40460700003)(7416002)(356005)(83380400001)(81166007)(36860700001)(47076005)(6666004)(86362001)(58440200007)(36900700001);DIR:OUT;SFP:1501;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:44:28.3096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aac6571c-de47-43a3-18b7-08d9ec9313b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2476
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, 3 Feb 2022, Toshiaki Makita wrote:

> Support GREv0 without NAT.
> 
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 0f4d3b9d..465643c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -258,7 +258,8 @@ struct mlx5_ct_entry {
>  			return -EOPNOTSUPP;
>  		}
>  	} else {
> -		return -EOPNOTSUPP;
> +		if (tuple->ip_proto != IPPROTO_GRE)
> +			return -EOPNOTSUPP;
>  	}
>  
>  	return 0;
> @@ -807,7 +808,11 @@ struct mlx5_ct_entry {
>  	attr->dest_chain = 0;
>  	attr->dest_ft = mlx5e_tc_post_act_get_ft(ct_priv->post_act);
>  	attr->ft = nat ? ct_priv->ct_nat : ct_priv->ct;
> -	attr->outer_match_level = MLX5_MATCH_L4;
> +	if (entry->tuple.ip_proto == IPPROTO_TCP ||
> +	    entry->tuple.ip_proto == IPPROTO_UDP)
> +		attr->outer_match_level = MLX5_MATCH_L4;
> +	else
> +		attr->outer_match_level = MLX5_MATCH_L3;
>  	attr->counter = entry->counter->counter;
>  	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
>  	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
> @@ -1224,16 +1229,20 @@ static void mlx5_tc_ct_entry_del_work(struct work_struct *work)
>  	struct flow_keys flow_keys;
>  
>  	skb_reset_network_header(skb);
> -	skb_flow_dissect_flow_keys(skb, &flow_keys, 0);
> +	skb_flow_dissect_flow_keys(skb, &flow_keys, FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);
>  
>  	tuple->zone = zone;
>  
>  	if (flow_keys.basic.ip_proto != IPPROTO_TCP &&
> -	    flow_keys.basic.ip_proto != IPPROTO_UDP)
> +	    flow_keys.basic.ip_proto != IPPROTO_UDP &&
> +	    flow_keys.basic.ip_proto != IPPROTO_GRE)
>  		return false;
>  
> -	tuple->port.src = flow_keys.ports.src;
> -	tuple->port.dst = flow_keys.ports.dst;
> +	if (flow_keys.basic.ip_proto == IPPROTO_TCP ||
> +	    flow_keys.basic.ip_proto == IPPROTO_UDP) {
> +		tuple->port.src = flow_keys.ports.src;
> +		tuple->port.dst = flow_keys.ports.dst;
> +	}
>  	tuple->n_proto = flow_keys.basic.n_proto;
>  	tuple->ip_proto = flow_keys.basic.ip_proto;
>  
> -- 
> 1.8.3.1
> 
> 

Acked-by: Paul Blakey <paulb@nvidia.com>

Looks good to me.
Thanks.
