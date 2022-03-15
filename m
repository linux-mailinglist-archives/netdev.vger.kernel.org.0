Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43AF4DA398
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347265AbiCOT6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343624AbiCOT6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:58:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177B95623E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5PaDI5EzEC5dHVAEnjS+W/rFWX1Vsi3a0/BCkVWL/g2USK6uMN55TQi3JRpqZwWd4NB3bCJR6y3ciCIip46cAsW5zFsGM644zRlbBXleVa883D8LPdsnncsk79dBBsl7is8j06dQttCCRNq6od+F1kC0m/R4CpVHeI8wD2BcasyPXKR2sHcLRU9O7OzAmx9KpvBdjY0Wk/2LNKV8f3NynGclnvl6jFKxZvdJTAqBKabsbEFgnvCUgQlYl2i9Gjnuhz48DoWrm7DOCfH1Mf3R9BPu0VWg8yDHk4mjivXaGlXtBch78HptwPgbyjvcbR8C1+jEapkAjDitI27n0D92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mSsAViELfJXSNCIwMhF4ejq/bR+NiQCIY3FSIoEPaY=;
 b=dhIzPTIVrBZ84apx5c9azg/p+azJWgzRVrb87EtcvS+YE0odSM7GntBXBVFBxvWTjkl1XqZOCHYJjw98/RrI4N0wEPzyyHgruKqYOWGsN7M0Yey7oClXgSkKzfLLludkEo4oO+EP6ZSxn0GcHOQF4JrlsNXBjd8NNnSgH4Cwg2FDNadZDiuilxv4WkDksOk/YkQtchtjKdRVBa6JSxXMcST4ja7R0oN3ypo9gN3G1pRwoN67f6hL/tkJfDKAJRYV9Ol9WKpPhfCJYITNtsff5maKTYqlF5+13IGEvYPAX1MLtyH58dHs7dkf6w14/aOvAOSb7j7FIQUvYFQLD2Q25g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mSsAViELfJXSNCIwMhF4ejq/bR+NiQCIY3FSIoEPaY=;
 b=uDHCw1HCMaCxbFogVn7iv29ljlvCpDKTq0vqnD1zDVjLWzjfjs12u2tx1I1ULTh03EbW6OKqnWVr/fk8stuGpzXZMTckYUzyGkntAFvPTHAe/pX+h8PzeFV3nNRfyk9A+0Jz9S0/iQRcuc5jhJZDGljM84y/pqbpxY/5qSlQE4rFco6211g0eRuy+D2lXTnZIZgUVQjtkXTmMzff2QF+EsSu0aQ3a5BbffqWEEM/rjq5KJDeTcCOu7wf9wkfZDWazwfvU+y8EimhcmsXs9lfhxqSCyNf68V15wFX6V2ngx+7cfe/ONNteiGr3MM7y1Yr9RYY+ElZeFGoW3ftEu0qFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Tue, 15 Mar
 2022 19:57:28 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::e037:47db:2c40:722c]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::e037:47db:2c40:722c%5]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 19:57:28 +0000
Message-ID: <5218b1e8-ee36-f708-00a3-79738b8f7ac4@nvidia.com>
Date:   Tue, 15 Mar 2022 12:57:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: geneve: support IPv4/IPv6 as inner protocol
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     shmulik.ladkani@gmail.com, netdev@vger.kernel.org
References: <20220315185603.160778-1-eyal.birger@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220315185603.160778-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0039.prod.exchangelabs.com (2603:10b6:a03:94::16)
 To SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73a4c830-642e-45bf-01d8-08da06be0866
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB50014610B9CC28CC7F458112CB109@CH2PR12MB5001.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H2Ye6NCHKU2Qns1BeLBSB4UrPdT4UJ58MUPepl6ljplMAyjYQ0AAopP/2MuuDW9ojpNgHwtpkp/RpdDOcnnVf70TOQwczReodu7G11+l/VxC32H+m9SMYfOczDPXBJg6Os+oS3nRXVJW8u5Cq91XaV8bTlK+wr+F5lG8m8oV8rFgK9THB8nocJ0LXhUHarUjJsbPgFwOVU3OWp1gXaeHnzPRLUOxEBiK6WQ4Burq/ZmCOtmeqX43OjRAQcSRamJ6YNfNj4KDxGjf5doewbb2y07h6aJah49PLNtmP1/8zBung6z0Cw0n8GGm7oeWdX0vcBnC5Ss5RWHskRWZkXIzAc+nEn6JaNyC43+dydqUP4bKww/b8iPTcGQeGt8LNjVRbMPUWx21rwRE/iuc7gGE59vf+g3Tukv4XMeYpDXea8hA2f/DswtbEtw3AaW/M6kh5gfvYzcWwozFdB8yyANnzuQgnODc7YQfzlGQXJcsYGqkhjgR/HGUYxwAQR09Ca1VM9dvtBBieLkSQLmK4JgTggiDjeDNb11UFf4SW4oE4t93ktMhxfilwT0OaoEICRVjytGWrFhDHeqxB8+APrULC3A0RfaGctdOLijCGgnpVqbpgBnqY1x0kPD5neux5MJ0FcRw8uq1dZpLKs9LJyxzFHITDs8RaRsUmWOXBxTMLYgfoUCzUSHsuyNx0VKb6erO/RuvdcWXmmVgr2cE7TRhbdzrVgMvaEPanrQojn9ro6In+ZBm5PVzXKV1ZCo3PxqF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(26005)(31686004)(6506007)(2616005)(6512007)(6666004)(38100700002)(8936002)(53546011)(186003)(508600001)(6486002)(316002)(31696002)(86362001)(2906002)(5660300002)(36756003)(66556008)(66476007)(4326008)(8676002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2Zsc0s4RXNNMDBBVVVzYy90S2NVQUlORHJjZTJTcWhGNjhDQ2FjSWRpbXlE?=
 =?utf-8?B?dU5RV2Fma2NuRWdCZ0pDT0Q2OUl2bVNwT0pBS0VGY1FCVlhVYzZWUzc0MDdZ?=
 =?utf-8?B?ZGZVQTgrNysvbERkYnJmbnBnZVVwODVHMmpiWkdvcVlGdmlsT2xsWVpsa3VY?=
 =?utf-8?B?cHJUaTB1K3pEKzkxQkRaaGZYZjJKT3NGVk91QWMyc2pRY0lPZHU3eEY5SlBp?=
 =?utf-8?B?UDdYbjVlNW0yQnFEVFh6eEpGSVJsQTIzNVZqUzJIVkZGdHlzK3pTYXREQ1lC?=
 =?utf-8?B?THEzbWw2ZFNNZFVZZEZlK0hjOThwV1RjTWFUQjMvU0NtTzJYYVB2U2ExRmhZ?=
 =?utf-8?B?dGFtSXBjdkZTdDFPSWI5TUtpdGsrdW9IcE5TYVFwbWJ4ZzJhK2hkZjk2Rm1Y?=
 =?utf-8?B?azhERkhOM0dTR1VENWlJNExyQjN0U3J6bm9WMGhFc2tpd0xDa1p1RWNKdGNY?=
 =?utf-8?B?d0pycndmUmkwbDJ5ZjBEOVllVlFkdVJJRDdUc0JEaGFzM1lVdGIrS00zaUt0?=
 =?utf-8?B?V0xQZmFCSzhkOWw1UWl0ZE5DSnNRZnREb1o4dzhsbmd0bTlWWkx0VnVKUW9S?=
 =?utf-8?B?enlvektwQjZlNXZIVDlGMUdPWHNOc3gzYWx3Q0VIckpqejkxRG1hY0J0MEZS?=
 =?utf-8?B?R3Y0TXgyTlpGY3M1Y2hqTFZFb3hReElXbzNOMnBRK3pxamVLYmhwdVpmQzEx?=
 =?utf-8?B?NWRIV2dnREdpZzVLUlljdzlXaHJaVmV6RU9nWE5CSVVVblZsSXRNN3pPSjNu?=
 =?utf-8?B?U3ZlUWVBclRJMlZjTHNyRlpWVHN0MTI1RFZDMFNUTC9oU01DRjN5SEVlK1pY?=
 =?utf-8?B?Sk1KL3BidDVPUUczZTVybHFQWmdTVXM2NlNyUGYvcGUvVFY5REwxbzFTS1VQ?=
 =?utf-8?B?QXBCWEp3eUFxTm1qdnhWV1c0U0JTRXBRRjlhVEIzaEtsOHZDN2poSnBVS3g2?=
 =?utf-8?B?MjdGVEt3ZWpzYTJaSlFaalhSMUpWT1FXdHBFRCt1bjg3aWgxSmxMN1k0V01m?=
 =?utf-8?B?T0JOd3BQWDVsSklIeFEwMUFGamcxZTZPZTVCYStqVDdjelJISUp0azJuNHhG?=
 =?utf-8?B?a282RkhmVW9uMlRCbXpmck1HcEdoTHB5Z3JRNk81emlCYllXcnluRFFwT05L?=
 =?utf-8?B?djJtTTZhTHhJd2hBUGdjTGZJTXBpdXU5RGhHVVNsQ1RYcnlhYmZ3dTUyZkNX?=
 =?utf-8?B?M01tWFZjRTFHa0g5UVVvSjFpdWg0aFBkbk8waUxFZmt3MnpwM3RYajFUNlRX?=
 =?utf-8?B?QjdnLzRLSE5jOVdqRnpYQjBTYTBDZExxUkt6cXdaWnhBTEd2bVlGc2lCZGRS?=
 =?utf-8?B?Si9POEdZL2YzaHZ4bjhZcnFUQmkvRG5lYUhkbnJRNlp2bnJOVldkTk1RQzZM?=
 =?utf-8?B?WFFKQlVQMDFad0Jqd0V3QWV4ZHdqZzZlOVluQnljaHlwMENzVnhYMGE4c01u?=
 =?utf-8?B?enBtVVZkYjk3V2pPWThrT2ZMWnBXMHplTW1veTk4cGorcXgrT0xLL0pWUjZj?=
 =?utf-8?B?azBhUFlRcVN5Z1IybjdOcm1Fb2daYjJnbm9ybzFudHpQdUY3Zm5vWVlBUHVp?=
 =?utf-8?B?NVVzSCtQTmgwb2lTMDlKbzJEWGVnL1d2S0N3NkJydlZvcTAzcEFtWkJ3dU1j?=
 =?utf-8?B?d2VVVnhaY0RaVDNtT2RYUWJLYWVjbkg2cDR1T0VjWk1xSjY3bmdRTkJrQzkz?=
 =?utf-8?B?M1dWc3pqN2pvbmo2Y1g2V2Q0SHFCN2VCNlI3QUoybmc2bnoxN2FGQ09oS2NY?=
 =?utf-8?B?T09QYk80dGh4SUpoMWpkVGFDRjNzQ2NsL1BhQ2V1akVnRWRKenNHZWNmU3VW?=
 =?utf-8?B?eUgrUG1ZMldKMjg4NzZPM1gvaU56Y3QyQ3pYb1hoSlFvYUovdlZwY3hkUTNL?=
 =?utf-8?B?ZThGWmUxaWhadkcyUjJzSVlnTXczamt6bE1sa0owU2IwdlUrTG10NGtIRXBq?=
 =?utf-8?Q?sH+mDl6gHQGhnseUMf+VGAtDM/gtg7Yo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a4c830-642e-45bf-01d8-08da06be0866
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 19:57:28.1895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FarAVvCIOMYqylvNe7ODutJFCfsA6w/6g4tRLHncSp7xPPz+GuGES/LQHDXQFyEMuklQWTU0YdsM2G0+gvjo+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5001
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/22 11:56, Eyal Birger wrote:
> This patch adds support for encapsulating IPv4/IPv6 within GENEVE.
>
> In order use this, a new IFLA_GENEVE_TUN flag needs to be provided at
> device creation. This property cannot be changed for the time being.
>
> In case IP traffic is received on a non-tun device the drop count is
> increased.
>
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> ---
>   drivers/net/geneve.c         | 79 +++++++++++++++++++++++++++---------
>   include/uapi/linux/if_link.h |  1 +
>   2 files changed, 61 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index a895ff756093..37305ec26250 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -56,6 +56,7 @@ struct geneve_config {
>   	bool			use_udp6_rx_checksums;
>   	bool			ttl_inherit;
>   	enum ifla_geneve_df	df;
> +	bool			tun;
>   };
>   
>   /* Pseudo network device */
> @@ -251,17 +252,24 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
>   		}
>   	}
>   
> -	skb_reset_mac_header(skb);
> -	skb->protocol = eth_type_trans(skb, geneve->dev);
> -	skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> -
>   	if (tun_dst)
>   		skb_dst_set(skb, &tun_dst->dst);
>   
> -	/* Ignore packet loops (and multicast echo) */
> -	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
> -		geneve->dev->stats.rx_errors++;
> -		goto drop;
> +	if (gnvh->proto_type == htons(ETH_P_TEB)) {
> +		skb_reset_mac_header(skb);
> +		skb->protocol = eth_type_trans(skb, geneve->dev);
> +		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> +
> +		/* Ignore packet loops (and multicast echo) */
> +		if (ether_addr_equal(eth_hdr(skb)->h_source,
> +				     geneve->dev->dev_addr)) {
> +			geneve->dev->stats.rx_errors++;
> +			goto drop;
> +		}
> +	} else {
> +		skb_reset_mac_header(skb);
> +		skb->dev = geneve->dev;
> +		skb->pkt_type = PACKET_HOST;
>   	}
>   
>   	oiph = skb_network_header(skb);
> @@ -345,6 +353,7 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>   	struct genevehdr *geneveh;
>   	struct geneve_dev *geneve;
>   	struct geneve_sock *gs;
> +	__be16 inner_proto;
>   	int opts_len;
>   
>   	/* Need UDP and Geneve header to be present */
> @@ -356,8 +365,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>   	if (unlikely(geneveh->ver != GENEVE_VER))
>   		goto drop;
>   
> -	if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
> +	inner_proto = geneveh->proto_type;
> +
> +	if (unlikely((inner_proto != htons(ETH_P_TEB) &&
> +		      inner_proto != htons(ETH_P_IP) &&
> +		      inner_proto != htons(ETH_P_IPV6)))) {
>   		goto drop;
> +	}
>   


unnecessary braces

>   	gs = rcu_dereference_sk_user_data(sk);
>   	if (!gs)
> @@ -367,9 +381,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>   	if (!geneve)
>   		goto drop;
>   
> +	if (unlikely((!geneve->cfg.tun && inner_proto != htons(ETH_P_TEB)))) {
> +		geneve->dev->stats.rx_dropped++;
> +		goto drop;
> +	}

Does this change current default behavior ?.

its unclear to be what the current behavior is for a non ETH_P_TEB packet


> +
>   	opts_len = geneveh->opt_len * 4;
> -	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
> -				 htons(ETH_P_TEB),
> +	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_proto,
>   				 !net_eq(geneve->net, dev_net(geneve->dev)))) {
>   		geneve->dev->stats.rx_dropped++;
>   		goto drop;
> @@ -717,7 +735,8 @@ static int geneve_stop(struct net_device *dev)
>   }
>   
>   static void geneve_build_header(struct genevehdr *geneveh,
> -				const struct ip_tunnel_info *info)
> +				const struct ip_tunnel_info *info,
> +				__be16 inner_proto)
>   {
>   	geneveh->ver = GENEVE_VER;
>   	geneveh->opt_len = info->options_len / 4;
> @@ -725,7 +744,7 @@ static void geneve_build_header(struct genevehdr *geneveh,
>   	geneveh->critical = !!(info->key.tun_flags & TUNNEL_CRIT_OPT);
>   	geneveh->rsvd1 = 0;
>   	tunnel_id_to_vni(info->key.tun_id, geneveh->vni);
> -	geneveh->proto_type = htons(ETH_P_TEB);
> +	geneveh->proto_type = inner_proto;
>   	geneveh->rsvd2 = 0;
>   
>   	if (info->key.tun_flags & TUNNEL_GENEVE_OPT)
> @@ -734,8 +753,9 @@ static void geneve_build_header(struct genevehdr *geneveh,
>   
>   static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
>   			    const struct ip_tunnel_info *info,
> -			    bool xnet, int ip_hdr_len)
> +			    bool xnet, int ip_hdr_len, bool tun)
>   {
> +	__be16 inner_proto = tun ? skb->protocol : htons(ETH_P_TEB);
>   	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
>   	struct genevehdr *gnvh;
>   	int min_headroom;
> @@ -755,8 +775,8 @@ static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
>   		goto free_dst;
>   
>   	gnvh = __skb_push(skb, sizeof(*gnvh) + info->options_len);
> -	geneve_build_header(gnvh, info);
> -	skb_set_inner_protocol(skb, htons(ETH_P_TEB));
> +	geneve_build_header(gnvh, info, inner_proto);
> +	skb_set_inner_protocol(skb, inner_proto);
>   	return 0;
>   
>   free_dst:
> @@ -959,7 +979,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>   		}
>   	}
>   
> -	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr));
> +	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
> +			       geneve->cfg.tun);
>   	if (unlikely(err))
>   		return err;
>   
> @@ -1038,7 +1059,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>   			ttl = key->ttl;
>   		ttl = ttl ? : ip6_dst_hoplimit(dst);
>   	}
> -	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr));
> +	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
> +			       geneve->cfg.tun);
>   	if (unlikely(err))
>   		return err;
>   
> @@ -1388,6 +1410,14 @@ static int geneve_configure(struct net *net, struct net_device *dev,
>   	dst_cache_reset(&geneve->cfg.info.dst_cache);
>   	memcpy(&geneve->cfg, cfg, sizeof(*cfg));
>   
> +	if (geneve->cfg.tun) {
> +		dev->header_ops = NULL;
> +		dev->type = ARPHRD_NONE;
> +		dev->hard_header_len = 0;
> +		dev->addr_len = 0;
> +		dev->flags = IFF_NOARP;
> +	}
> +
>   	err = register_netdevice(dev);
>   	if (err)
>   		return err;
> @@ -1561,10 +1591,18 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
>   #endif
>   	}
>   
> +	if (data[IFLA_GENEVE_TUN]) {
> +		if (changelink) {
> +			attrtype = IFLA_GENEVE_TUN;
> +			goto change_notsup;
> +		}
> +		cfg->tun = true;
> +	}
> +
>   	return 0;
>   change_notsup:
>   	NL_SET_ERR_MSG_ATTR(extack, data[attrtype],
> -			    "Changing VNI, Port, endpoint IP address family, external, and UDP checksum attributes are not supported");
> +			    "Changing VNI, Port, endpoint IP address family, external, tun, and UDP checksum attributes are not supported");
>   	return -EOPNOTSUPP;
>   }
>   
> @@ -1799,6 +1837,9 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
>   	if (nla_put_u8(skb, IFLA_GENEVE_TTL_INHERIT, ttl_inherit))
>   		goto nla_put_failure;
>   
> +	if (geneve->cfg.tun && nla_put_flag(skb, IFLA_GENEVE_TUN))
> +		goto nla_put_failure;
> +
>   	return 0;
>   
>   nla_put_failure:
> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> index bd24c7dc10a2..198aefa2c513 100644
> --- a/include/uapi/linux/if_link.h
> +++ b/include/uapi/linux/if_link.h
> @@ -842,6 +842,7 @@ enum {
>   	IFLA_GENEVE_LABEL,
>   	IFLA_GENEVE_TTL_INHERIT,
>   	IFLA_GENEVE_DF,
> +	IFLA_GENEVE_TUN,

geneve is itself called a tunnel, i wonder if a different name for the 
flag would be more appropriate.

what is the use case for this ?. is there a RFC reference ?



>   	__IFLA_GENEVE_MAX
>   };
>   #define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
