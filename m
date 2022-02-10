Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FF24B0DC6
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbiBJMsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:48:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240903AbiBJMsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:48:24 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB5025C7;
        Thu, 10 Feb 2022 04:48:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ni2VkOeXMv8tJbYuOYcr0d/UPzFqQ7BbXYP1ULZE6s+MZ8gbqcZSU9PFKJHpjU6Zd27BYmQC8eDtMvc99f/znV08+bYmGxRYiw3UXInONKvgWrND89cuQe3Q3j0wgYXskewl+UhidqEv/mIpMklFlqQQ4fEbUWM59IgtTjGqPVCpDvPnP/P+UPs+vLSDPk+D64YaehbMHJDb0JUk+zrIXWEKzj831YCu/sqakfKEGIxjn7mZINJZ8NXZD6eaIzMderttC9k5uJxc46tQJ61ihlDk9WzMI/fZlDzBTsUBYpZm5WpG0jodeDAtDpReqQ0zMFot6s2k4cfta23xH5RNFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dm2H0/AFliPSzS8vSLim358hgliq/WTdyRRm+e0ybaE=;
 b=fpe++XNoqQaUnLNjZi9drnBbsn9RdDv6PZ8RC6EtUF5525eL5s6GGK/9Q7jtAKImbi9Xmkrg45bQEnvFbt/q01+hxM1S8BQJheZXEw8XX19QOCTPfEEXizZYLdPQ5Dn+2M33aedP9Y8iKG9HLI1pwVLNKveh8ruIEzmbqlZi1W1s8BRscTf/azZfrhG9EOQztaYqARl1z0QM2949TjuUKdHYRiBHEi8t6pGRufmXw5CluxmVIS3bH8VEitXLW9cUOF6btdw8PakxBD+9VX7IR/XYB9gei/anVPxN6p+Wi3w6RO/no63Pi81KSTyS0C7qBuCzLWqGqyC9V2YLH0gySg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dm2H0/AFliPSzS8vSLim358hgliq/WTdyRRm+e0ybaE=;
 b=tkAjGZWQaNRM61Kg6O/dl189pPDhBzpVqZZyCDuargz3rumy0EeNHJqubQ/KsJ6/JNCt41iUTRb0W6wbG7WjYraXcMsPvWj6RUx5Dc+xssQtL2Vp2YmXTb4lLu5gM26oL77WIla4HzUbNgAqkGpr7OIP2W23FqZ7t1RRTqQF9fCSgNgjAhmX1rCZSPlznwdkuYWAz5iMeH/Y6xmmyp2h6B/QPefRWKdS2aTvKhmbuMAj80n7xz1jlQQMLRnc9Fb3FRTmp9LbthQCpQ+NDXlIdTwpwOKYqLruzsAsmJyJr8ji23sG47NArU/YZVJWbfMM+Yc/4Oy8XAHGFp9EsWlBIA==
Received: from BN6PR20CA0069.namprd20.prod.outlook.com (2603:10b6:404:151::31)
 by DM4PR12MB5054.namprd12.prod.outlook.com (2603:10b6:5:389::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 12:48:23 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::ca) by BN6PR20CA0069.outlook.office365.com
 (2603:10b6:404:151::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Thu, 10 Feb 2022 12:48:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 12:48:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 12:48:21 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Thu, 10 Feb 2022 04:48:17 -0800
Date:   Thu, 10 Feb 2022 14:48:10 +0200
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
Subject: Re: [PATCH net-next 2/3] act_ct: Support GRE offload
In-Reply-To: <20220203115941.3107572-3-toshiaki.makita1@gmail.com>
Message-ID: <90bc50c7-845c-5d31-b62a-89774bc95ad7@nvidia.com>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com> <20220203115941.3107572-3-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40c41eed-73ce-48f8-5a88-08d9ec939f8a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5054:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB505467AAF6699F88EBF721FBC22F9@DM4PR12MB5054.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:159;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DDxb4Mquxb9S8E9k3l7sV4TazpteWzBd1Z/l0KGHej0jMdncgGGd9HNmvNgf3LwFFcBVaICkdasskgqtnbAgkLMPNsBD4KpTtvHLaCyRfqRjxEV7DmInNcHJ4Ivel2RMQzNZlWUfw+a9l4HYDXqIBZ8ly+aQJK5Gwl2qglFOzqvWDrEW07aRF8SB9Q6+rBjPSk40jOzpUZvcUcpijAi787q5opGot8NamgH+IKztUNSt2B8hEU2e5gipURbgmLzb2EVKINFPqKOD2e0VB2GEYtbXDW4wPvzkR0qHovDP7BgOUbt7cAAr5055IYpin2Tama3VLIA7iDGUkQy58YkLvc94zFlELn8rBEXpOxVi0dGaNHBif/wIWTUMEQIP2erO3mlL75SDfKeJcINB00VWN4kj20MY/hmAk3hSDYZH7Hvf+fA4Yr1+3d854j3XEthGg8GioHb/8dqCfowQ0Cjymk58EnktVpnk5hMKnssK/6/5OX6VJvwp8PrsOqesCeZLBC3P4BsAIAAtaTkKO1F+9RHV+qQRXnzRhunFGcpjMSJvrSaov5AYJgK50Zkm6/C/bzd0INBPMr1RScVfjEy1hveAAkValOUyQx41rfLvCCkwTq1++PzfCs75gZnL3WzE1ldyGLmoCslcmOdhgDPKgk7pLzw8lHf8rpU5Sl6t43b7FstXCViqQCM9xlkOzl998ypWww6Yx44xFkzTNHmhfA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(4326008)(356005)(31686004)(16526019)(6666004)(8936002)(508600001)(36756003)(70206006)(5660300002)(7416002)(2616005)(8676002)(86362001)(36860700001)(82310400004)(6916009)(316002)(2906002)(70586007)(186003)(54906003)(47076005)(426003)(26005)(83380400001)(336012)(81166007)(31696002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:48:22.8753
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c41eed-73ce-48f8-5a88-08d9ec939f8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5054
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
>  net/sched/act_ct.c | 101 +++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 79 insertions(+), 22 deletions(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index f99247f..a5f47d5 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -421,6 +421,19 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>  		break;
>  	case IPPROTO_UDP:
>  		break;
> +#ifdef CONFIG_NF_CT_PROTO_GRE
> +	case IPPROTO_GRE: {
> +		struct nf_conntrack_tuple *tuple;
> +
> +		if (ct->status & IPS_NAT_MASK)
> +			return;
> +		tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
> +		/* No support for GRE v1 */
> +		if (tuple->src.u.gre.key || tuple->dst.u.gre.key)
> +			return;
> +		break;
> +	}
> +#endif
>  	default:
>  		return;
>  	}
> @@ -440,6 +453,8 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>  	struct flow_ports *ports;
>  	unsigned int thoff;
>  	struct iphdr *iph;
> +	size_t hdrsize;
> +	u8 ipproto;
>  
>  	if (!pskb_network_may_pull(skb, sizeof(*iph)))
>  		return false;
> @@ -451,29 +466,49 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>  	    unlikely(thoff != sizeof(struct iphdr)))
>  		return false;
>  
> -	if (iph->protocol != IPPROTO_TCP &&
> -	    iph->protocol != IPPROTO_UDP)
> +	ipproto = iph->protocol;
> +	switch (ipproto) {
> +	case IPPROTO_TCP:
> +		hdrsize = sizeof(struct tcphdr);
> +		break;
> +	case IPPROTO_UDP:
> +		hdrsize = sizeof(*ports);
> +		break;
> +#ifdef CONFIG_NF_CT_PROTO_GRE
> +	case IPPROTO_GRE:
> +		hdrsize = sizeof(struct gre_base_hdr);
> +		break;
> +#endif
> +	default:
>  		return false;
> +	}
>  
>  	if (iph->ttl <= 1)
>  		return false;
>  
> -	if (!pskb_network_may_pull(skb, iph->protocol == IPPROTO_TCP ?
> -					thoff + sizeof(struct tcphdr) :
> -					thoff + sizeof(*ports)))
> +	if (!pskb_network_may_pull(skb, thoff + hdrsize))
>  		return false;
>  
>  	iph = ip_hdr(skb);
> -	if (iph->protocol == IPPROTO_TCP)
> +	if (ipproto == IPPROTO_TCP) {
>  		*tcph = (void *)(skb_network_header(skb) + thoff);
> +	} else if (ipproto == IPPROTO_GRE) {
> +		struct gre_base_hdr *greh;
> +
> +		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
> +		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
> +			return false;
> +	}
>  
> -	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>  	tuple->src_v4.s_addr = iph->saddr;
>  	tuple->dst_v4.s_addr = iph->daddr;
> -	tuple->src_port = ports->source;
> -	tuple->dst_port = ports->dest;
> +	if (ipproto == IPPROTO_TCP || ipproto == IPPROTO_UDP) {
> +		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
> +		tuple->src_port = ports->source;
> +		tuple->dst_port = ports->dest;
> +	}
>  	tuple->l3proto = AF_INET;
> -	tuple->l4proto = iph->protocol;
> +	tuple->l4proto = ipproto;
>  
>  	return true;
>  }
> @@ -486,36 +521,58 @@ static void tcf_ct_flow_table_process_conn(struct tcf_ct_flow_table *ct_ft,
>  	struct flow_ports *ports;
>  	struct ipv6hdr *ip6h;
>  	unsigned int thoff;
> +	size_t hdrsize;
> +	u8 nexthdr;
>  
>  	if (!pskb_network_may_pull(skb, sizeof(*ip6h)))
>  		return false;
>  
>  	ip6h = ipv6_hdr(skb);
> +	thoff = sizeof(*ip6h);
>  
> -	if (ip6h->nexthdr != IPPROTO_TCP &&
> -	    ip6h->nexthdr != IPPROTO_UDP)
> -		return false;
> +	nexthdr = ip6h->nexthdr;
> +	switch (nexthdr) {
> +	case IPPROTO_TCP:
> +		hdrsize = sizeof(struct tcphdr);
> +		break;
> +	case IPPROTO_UDP:
> +		hdrsize = sizeof(*ports);
> +		break;
> +#ifdef CONFIG_NF_CT_PROTO_GRE
> +	case IPPROTO_GRE:
> +		hdrsize = sizeof(struct gre_base_hdr);
> +		break;
> +#endif
> +	default:
> +		return -1;
> +	}
>  
>  	if (ip6h->hop_limit <= 1)
>  		return false;
>  
> -	thoff = sizeof(*ip6h);
> -	if (!pskb_network_may_pull(skb, ip6h->nexthdr == IPPROTO_TCP ?
> -					thoff + sizeof(struct tcphdr) :
> -					thoff + sizeof(*ports)))
> +	if (!pskb_network_may_pull(skb, thoff + hdrsize))
>  		return false;
>  
>  	ip6h = ipv6_hdr(skb);
> -	if (ip6h->nexthdr == IPPROTO_TCP)
> +	if (nexthdr == IPPROTO_TCP) {
>  		*tcph = (void *)(skb_network_header(skb) + thoff);
> +	} else if (nexthdr == IPPROTO_GRE) {
> +		struct gre_base_hdr *greh;
> +
> +		greh = (struct gre_base_hdr *)(skb_network_header(skb) + thoff);
> +		if ((greh->flags & GRE_VERSION) != GRE_VERSION_0)
> +			return false;
> +	}
>  
> -	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
>  	tuple->src_v6 = ip6h->saddr;
>  	tuple->dst_v6 = ip6h->daddr;
> -	tuple->src_port = ports->source;
> -	tuple->dst_port = ports->dest;
> +	if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP) {
> +		ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
> +		tuple->src_port = ports->source;
> +		tuple->dst_port = ports->dest;
> +	}
>  	tuple->l3proto = AF_INET6;
> -	tuple->l4proto = ip6h->nexthdr;
> +	tuple->l4proto = nexthdr;
>  
>  	return true;
>  }
> -- 
> 1.8.3.1
> 
> 

The GRE ifdefs I assume are for the same reason you mentioned in other 
patch, If so, looks good to me.

Acked-by: Paul Blakey <paulb@nvidia.com


