Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3825495C59
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiAUIwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 03:52:36 -0500
Received: from mail-bn7nam10on2061.outbound.protection.outlook.com ([40.107.92.61]:57697
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231712AbiAUIwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 03:52:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpmU0mbrqGaDFBaQZRdjJIfk7k8Qx4CQ9udWpvsYTKf8rl8eQsGcKp4PhJHfEcfE94NMPvEMYdLQkNPkjeFvQ3R8bK5mC15FyFhImjk5qR1L/OFUzdtOHjZk192zDNKIEDv4+xxmbjtAYqqgAQLEqa2XWpl9XDSDk17yIE5+mVJTV+I6HMaUIg1OhXTFOObMpnsLMofhw5MeV9B/6Djl+xPsRiagMz18H+nMT+MGm5y6ug5RKS+pP8ZDyvGaXWvUepjGhckoMvRk6yTdOYbeE0aRjQ50CfPxvJ8TcISg7cNZFtf7c4j5qEledEgWurDgL5DIWfVfU9eCyHVqXXr7+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c18z5dcg3o8fXUobFPF7Oaw79KdMwIyyy+G/kUhddl4=;
 b=BQ7GM/UFralICLfvCklNmpjH/INowHebZLJH481vP9DuvcfpDf8M5TUfJr1EHFgn+9VMb1KL0Qqw3cq7oBZx5OXSxMtvoQyKnJUUSSgx6SJb7c9DPt6KAykKRp2gkl3z2fXuFeOun+CFwe6nCqT23NjLkaa0LBCwQE0p7I9y5uKrVpfV0lLOaPHGlsFUskOKsGB73riMPQq1YYku6aYx37mleC9I0dNnroE74ND0pYaWDj/fbYv9eJbVFQpI8zzFzzzz+kiLJjnYsyJ5kORzZq23KwQEvkfUczbqHGLI26ptXHZ85o7ChtBdti9ihcptyu5IanOWos2luaZgZvcnww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c18z5dcg3o8fXUobFPF7Oaw79KdMwIyyy+G/kUhddl4=;
 b=eoPcIf4aKdrSVK4386Ai22A8e+ZhwRTveGM6SL8SEdqULRQPV2kDjmw6xQ8we16An3HB+EweMxzpVeTsxUVYt84sNRngls9ap6IQoSILB0K6gjOXz2CztIcUC+08vT8bafpcojh19kkWHDt+2BsWedZ+TPwnn5OtYOM/NHiY6WsWg5TsBapBD2pA61vu1lsd6Jvr/OFRUXjX9IJGI6tS8SvawpPzI8xSWQ5eYl5E56nSnWnURQsBBUgJhEwgaHOYz4Kt2azWud4bFBLd4TByj3x+EcRNXES92MqOLPS7eGF9FqK2qNbOTnbNLmOzfKt7xNNn+XFZJU2e0q/GMQDQcQ==
Received: from BN1PR10CA0029.namprd10.prod.outlook.com (2603:10b6:408:e0::34)
 by MN2PR12MB4567.namprd12.prod.outlook.com (2603:10b6:208:263::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 21 Jan
 2022 08:52:29 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::46) by BN1PR10CA0029.outlook.office365.com
 (2603:10b6:408:e0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7 via Frontend
 Transport; Fri, 21 Jan 2022 08:52:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Fri, 21 Jan 2022 08:52:28 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 21 Jan
 2022 08:52:27 +0000
Received: from [172.27.1.200] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 21 Jan 2022
 00:52:23 -0800
Message-ID: <fb358da0-d255-301d-c39c-8232aa415a38@nvidia.com>
Date:   Fri, 21 Jan 2022 10:52:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v7] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
Content-Language: en-US
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jay.vosburgh@canonical.com>, <huyd12@chinatelecom.cn>
References: <20220121082243.88155-1-sunshouxin@chinatelecom.cn>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220121082243.88155-1-sunshouxin@chinatelecom.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acc249ff-62ca-4791-51f3-08d9dcbb5ac9
X-MS-TrafficTypeDiagnostic: MN2PR12MB4567:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB45676DA2683A4DA17C37DBB7DF5B9@MN2PR12MB4567.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JpWfTKPWeFA0691GkXn/n8BmVSj/omqpu5sOUsdc9sJEf7xvIHavEV6qluigS0Nm1REF0URNRaplv7ewAYyYtA/z9x1RogsWDyq8TYAeufhIqPk4jByo2WEG4J1K6gyF4ID8ixDRDDBLkDFGxYz+0xfVPBxxHpZ8tTaIz2krny/4bgxYoZ7nWgtySz8WrHCcCXaQIpL+Lk8DOY9CnNP/keLSHEZ04Lzw6GJyZagciNWl5o1+rntbNXPOCioNcXoxjhEEju6KxfFu+XpG5eRPkL98LJHzRKVnnouFAABzxoIGunn2JGI7nQICa8R/s6NVf8zdL2EUasi71KXhx0jWCU9zQkfs1TlNx01/+w1bGzapIjA76/MpmHHBLmMlPUXSn6u5pJkAzclMA4brsEX9LWxojl1HRlB9m5rpXHHVOXKjL/VnDPav4CXnEQl9faj3ZTMsyw9Rn3/su3e8ADxt+fopMHpaEktwrgWC+8EWc/95uQ3JMFzJmyTUNppy0roctOKATkVhv36cwIsfu/5DzULZgBv3ZR7eXl5YUT4mQ+NCyEd1x3OzYmES/SuakNUaqoCMcmo0yu6a0CoMXyteFjEqxOvhrsOy/+Humw40RFiT5irdb9lArwfQS3Nd4Os9Kad1tuaWDw8WzgVjO1NjB+cjGaJ2ThJGyUBRxnU8D/jINCjQdPXh/FOnZ0pS+GwF/lCj/nzXTI5Pzs9ZJhHIK75sf3lTs4TZJ2r4hHmOXdXIK7dZC3c4NdE+fLsy9DOy4oNhvkoZUngufxqtlEi15DznpQouVrlEKh40aqTNbKzI6S66i7xKrQT8Oo2Otd6dF+ue6XP/8GqEqxeuUaiXaA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(2906002)(26005)(40460700001)(2616005)(70586007)(31686004)(336012)(426003)(47076005)(81166007)(82310400004)(36860700001)(31696002)(54906003)(86362001)(16576012)(53546011)(36756003)(7416002)(110136005)(316002)(8676002)(8936002)(356005)(83380400001)(5660300002)(186003)(16526019)(70206006)(508600001)(4326008)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 08:52:28.8055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acc249ff-62ca-4791-51f3-08d9dcbb5ac9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4567
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2022 10:22, Sun Shouxin wrote:
> Since ipv6 neighbor solicitation and advertisement messages
> isn't handled gracefully in bond6 driver, we can see packet
> drop due to inconsistency between mac address in the option
> message and source MAC .
> 
> Another examples is ipv6 neighbor solicitation and advertisement
> messages from VM via tap attached to host bridge, the src mac
> might be changed through balance-alb mode, but it is not synced
> with Link-layer address in the option message.
> 
> The patch implements bond6's tx handle for ipv6 neighbor
> solicitation and advertisement messages.
> 
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: Sun Shouxin <sunshouxin@chinatelecom.cn>
> ---
>  drivers/net/bonding/bond_alb.c | 36 ++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 

Hi,
A few comments below,

> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
> index 533e476988f2..82b7071840b1 100644
> --- a/drivers/net/bonding/bond_alb.c
> +++ b/drivers/net/bonding/bond_alb.c
> @@ -1269,6 +1269,34 @@ static int alb_set_mac_address(struct bonding *bond, void *addr)
>  	return res;
>  }
>  
> +/*determine if the packet is NA or NS*

comments should have spaces, /* text */

> +static bool __alb_determine_nd(struct icmp6hdr *hdr)
> +{
> +	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
> +	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
> +{
> +	struct ipv6hdr *ip6hdr;
> +	struct icmp6hdr *hdr;
> +
> +	if (skb->protocol == htons(ETH_P_IPV6)) {

You can drop this test if you re-arrange the cases in the caller. More below.

> +		ip6hdr = ipv6_hdr(skb);
> +		if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {
> +			hdr = icmp6_hdr(skb);

You have to use pskb_may_pull here, only the IPv6 header is pulled by the caller
and certain to be in the linear part. Also you have to change one of the callers,
more below.

> +			if (__alb_determine_nd(hdr))
> +				return true;

you can do directly return __alb_determine_nd(hdr) here.

> +		}
> +	}
> +
> +	return false;
> +}
> +
>  /************************ exported alb functions ************************/
>  
>  int bond_alb_initialize(struct bonding *bond, int rlb_enabled)
> @@ -1350,6 +1378,9 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,>  		switch (skb->protocol) {
>  		case htons(ETH_P_IP):
>  		case htons(ETH_P_IPV6):
> +			if (alb_determine_nd(skb, bond))
> +				break;
> +

You can drop the IPv6 test in alb_determine_nd() if you re-arrange the cases here.
Something like:
  		case htons(ETH_P_IPV6):
			if (alb_determine_nd(skb, bond))
				break;
			fallthrough;
  		case htons(ETH_P_IP):

You should also use pskb_may_pull to make sure the IPv6 header is in the linear part
and can be accessed.

>  			hash_index = bond_xmit_hash(bond, skb);
>  			if (bond->params.tlb_dynamic_lb) {
>  				tx_slave = tlb_choose_channel(bond,
> @@ -1446,6 +1477,11 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
>  			break;
>  		}
>  
> +		if (alb_determine_nd(skb, bond)) {
> +			do_tx_balance = false;
> +			break;
> +		}
> +
>  		hash_start = (char *)&ip6hdr->daddr;
>  		hash_size = sizeof(ip6hdr->daddr);
>  		break;
> 
> base-commit: 79e06c4c4950be2abd8ca5d2428a8c915aa62c24

Thanks,
 Nik

