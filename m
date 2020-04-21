Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D761B224E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgDUJGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:06:23 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:41868
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726095AbgDUJGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 05:06:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcsyIaFKlqw9Xd3/fXr4LF975VmyJnuMPFK5O/CGP0F+ydKAaUsXcCPRESzsAkR725J8T/RyAlbBC9RmxhKrDRo8KEJxU0Ubt6zg2oDP33c/Hl+TT/7drNXPTE9q6fmAQD//SV1HwviWXF3ngwsf6l0J0vUCOY8mq3spvaVbE5aYqQL56Oq9x8h+YvtqgxUFsE6ayMr2XkK5mqOgF7UeyG1pJKiY5Qwa46MC290WY6UkyCdDZpbsuJn/+1NAhW/P1XTcrfuqla5J6rwC4+h+PYCVK7/eBh2ArYDej5hOlPils3283a4Kzn/6mnLouEySOas50GLff+4P8z0avs/V9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIT17Gf7Q8zzxv8UrVSaLcMOGIL1dm1JNssvL9Lz6PA=;
 b=ISMFo+wO0nnesb/fhUl5X9CsUrehoUhN/7yC/j0VbaUI/2qHJvWwu47oxzbjHBs7upbjqyINj84Ujxir21d4TW/Bwgt7rt5AZMrkc7zyFc8XaEFjXPgaYbXjgvn90rpVavdgP09Lkw+p/sxOn4ppnrKsMr74G1GPjoMJf+9fV7qtjHal7P+145zZtT8YIN9HZDk5DViUO+FoIe8P7ZXOK6Fe3fTacr2UhCEmHnPUr7KxW4jxSDF83bWr+Ts93ap5g7M8v2P7TbyRYsCYHOJSAhT6H1oSue0whMDsUHIENYL1MVdBWc0mYvlr2iSg8f7Om0+BfvtNxSOM2wJjAaB24w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIT17Gf7Q8zzxv8UrVSaLcMOGIL1dm1JNssvL9Lz6PA=;
 b=lwOuVjZvgT2vfTqC0cweLg9N7Ex0ePGrahm0cd5dOVZRtLLhBFBNMZacb3MyPvZmZuQsYBrwVzK8Xjye6jcvQ0Z9hZsgiDtxXYG96InZ2WbFKLyTTI3e6hMXUTgGR4KJmTGSLNr8tTSQw+mrG66FqIKS/6geJtJsxX5Ym03Yv/Y=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB7PR05MB4155.eurprd05.prod.outlook.com (2603:10a6:5:1a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Tue, 21 Apr 2020 09:06:13 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::d12b:b2d7:95a0:8088]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::d12b:b2d7:95a0:8088%7]) with mapi id 15.20.2921.027; Tue, 21 Apr 2020
 09:06:13 +0000
Subject: Re: [PATCH net-next] net/sched: act_ct: update nf_conn_acct for
 act_ct SW offload in flowtable
To:     wenxu@ucloud.cn, paulb@mellanox.com
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1587426943-31009-1-git-send-email-wenxu@ucloud.cn>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <0ed8b020-611f-525d-0c2b-7f15785cb50b@mellanox.com>
Date:   Tue, 21 Apr 2020 12:06:09 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <1587426943-31009-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0124.eurprd07.prod.outlook.com
 (2603:10a6:207:7::34) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by AM3PR07CA0124.eurprd07.prod.outlook.com (2603:10a6:207:7::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.5 via Frontend Transport; Tue, 21 Apr 2020 09:06:11 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c8bd078d-685f-45c3-d1f4-08d7e5d33d8c
X-MS-TrafficTypeDiagnostic: DB7PR05MB4155:|DB7PR05MB4155:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB415550E4EBEA5FCE2854F5FDB5D50@DB7PR05MB4155.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(4326008)(8676002)(16526019)(186003)(8936002)(6486002)(66556008)(2906002)(66476007)(6636002)(5660300002)(66946007)(81156014)(31686004)(478600001)(36756003)(31696002)(53546011)(26005)(956004)(16576012)(52116002)(316002)(86362001)(2616005)(15650500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sONcP/ban0EnSG1jt+lbM82KJdfq9vnDeRrpOu1+aeC4iY5ZS5wn9HdeE7co0WYkw4augPYY9giEXXG1KN7MBWqPzg5jMwhJ8+VfehSXubPrcqKlXKlVwkqFi2zs7IPtARsioRgrd8xBGX/NABOyD/di3g78rVd+6JGurY4uj5duRAXDfnVmryR9sJY7cNbhJ0Acl7fNJRbZLBqmJcPKB/Zd0bhbMmpxIu7OLc7t6UG6060o1FOf0p28FNjr/VLL1HUqzEI3+4EYfQyjnb0pn7OUsqfm4NICqcpwFAXbFIiJxpTFq3AY4S0s/zsxTaIcTcjmqvwWwhOWpn6321EwBNpBI3oS4f/FHYvlUXMnexUVpr7SvjIG7IgEotA7cFGezMI6Km9sD0P8jxiOI3NS9p8woENqNvDExp+UoPwSZWY5ioQ4HuJIOXtUHgjif5iI
X-MS-Exchange-AntiSpam-MessageData: WHK/oE7uW/PRAt/95zsVHWLJLeT3bJUjEkykHF6aOoveBJV859NAeCuvOoQsts3BjY9vJhfC8KW9vp0YfxG5MI/NAPoWZkwViA4hDZzqMTdNcn7A/R5QDAAEL+J/6V3JIIXlmpmJY+DewcB2Lm2fuw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8bd078d-685f-45c3-d1f4-08d7e5d33d8c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 09:06:13.1952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ktf7urhstJPHGwVUONuGWQIjigZ0ISodobsvW0TGY9kUMgbIQ9Jd8+JJ+bF2QSna5peA0PebATNFgDcOqspu9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-04-21 2:55 AM, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> When the act_ct SW offload in flowtable, The counter of the conntrack
> entry will never update. So update the nf_conn_acct conuter in act_ct
> flowtable software offload.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/sched/act_ct.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 1a76639..9adff83 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -30,6 +30,7 @@
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_zones.h>
>  #include <net/netfilter/nf_conntrack_helper.h>
> +#include <net/netfilter/nf_conntrack_acct.h>
>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>  #include <uapi/linux/netfilter/nf_nat.h>
>  
> @@ -536,6 +537,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
>  	flow_offload_refresh(nf_ft, flow);
>  	nf_conntrack_get(&ct->ct_general);
>  	nf_ct_set(skb, ct, ctinfo);
> +	nf_ct_acct_update(ct, dir, skb->len);
>  
>  	return true;
>  }
> 

Hi wenxu,

Looks good. I also tested this and verified.

Thanks,
Roi

Reviewed-by: Roi Dayan <roid@mellanox.com>
