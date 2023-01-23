Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192D2677A3D
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjAWLig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjAWLif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:38:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF311E2A1;
        Mon, 23 Jan 2023 03:38:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVUTCOajdoh/QShdEkW3nS9n2CfY+DeFCEqKdO6LqXk57WhikH1MECwWjjtgezxmh9nCA99vmZ8UKAxkwZVpXFlw93x80utAC24HfQc5GAkQiS2rWR/kAJBspCgWNvPdx0JAy7mI7FXvhbxu7vgIEJ38HaBAxN8i7Xhmi9/ITvtxWel6m6CTDSz7RRfo1RAKi4m/DrW2koyEuuN8ryxZzAxpGplk005I44KYAQfcWnNqF7PhCcs8YCEfig4wt2l/hv94w2fdRRn5qJDESt3l0EHPhD4Nlg65Uh+14neamF9Az4dYRHH8eNdzYXXVa5XfU2njTZIlztHxEnO/NCAS5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rH5078LoOVqwqBcFYYhjAup82eaNnaZd2JAYg2M7ZPo=;
 b=m23UGBcGcoA3uPYVN++F4fDOqQElzsfjZ9ArarQECH9rNhhXSgNx8GQkRgAkgqBrOXrvQERFUzBCENwmBnA8IZCk73SeNAYmOhCFjh9TycBVHrSSTupO/bS3avBF3oIjKDgT3T6OVSYw5gB0/yA62DOluxSwttnq9vVN7dtuskSGH6VwH/z0pzcOZUGO+YnnHIglBkN5xrbAK8+1YI6imiXfSDmrWwjk4v5wfqjKT1nCvvc9iz0b378+22dTI5vKS3XEO8Vt7x+zoZ1NtJpndurDt0RWf2LivQJO+UeOgm1tzp8RcMMLwpQtSrMy0Sbub5A97bk6Bnb5iC8XdJC7pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rH5078LoOVqwqBcFYYhjAup82eaNnaZd2JAYg2M7ZPo=;
 b=L8p7dCzsQlwCluMpVcgctHza7lnfda6WyI8cecNpal/fdtQjx7mgTYziTkxgsX6JK5YYe/SytjHu+awfcEyOINAg1PBjpsHNDVn6jehCQs2to/Ec3lNQbqXRTirFq4km7QL/yscWn9JL2km4Ihs1fIcL4gUZeTzJNWD8z70Xm7N4pC+AiLe02t4Oy8QlK1teuOFI9Ob33HOkWTOL0FCBDcq69aWtStH6kyr8CggyJ6LP8T+60LQSJSEShUbybUAmDWVhxCtQ3MRymrZeWq4/AkchuxYUwZyg/JbAJ0pLuk+KEWeX+7VIDYDK7yKo5yXUWKdl/tjFuAFdIJt9dpZxXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DM4PR12MB6471.namprd12.prod.outlook.com (2603:10b6:8:ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Mon, 23 Jan
 2023 11:38:10 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::db1d:e068:3fd6:ed08]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::db1d:e068:3fd6:ed08%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 11:38:10 +0000
Message-ID: <b352f87d-fe0d-a5ff-451c-57376f6f3bc3@nvidia.com>
Date:   Mon, 23 Jan 2023 13:38:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101
 Thunderbird/109.0
Subject: Re: [PATCH net-next 3/9] netfilter: conntrack: avoid reload of
 ct->status
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, Maor Dickman <maord@nvidia.com>
References: <20230118123208.17167-1-fw@strlen.de>
 <20230118123208.17167-4-fw@strlen.de>
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20230118123208.17167-4-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0437.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::17) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|DM4PR12MB6471:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad28ece-1736-4b3d-2086-08dafd364db1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EbS/tcJbcJFIXI/OcTQB14GxMKd0nzuhC0WL+LlZBZrZ3r/79zwkRmPjqzP/GMxDYe5AFpwLPBpLqX8Bwx1HIn42swK/Q54UaQzt7aS6oDhnTbcvOsakPrXHO2b6MSzJbCqGwoeMcXZ1WPyWHoJuHJJiMzJJrQ1vXBYVJAhaU7mOJ5fi4DMGDMteN02fcMbvvrukz7FDMzOsqZF4yiDmKgRZ+hfZztX4ibsEYc/TilsMtIf2YZB2aL0ucmAMxrDxqTU2ibmi8q8lrbxLzcCM6byDEtWKFyYwTp2tIdasViAwzBWBOMKPz6hr2Icnii0E1x86NB2yqslF88x8rYAuKPiap3F+WDgcHFV+dkJaEwr1Jze/k7us5g/1eL7D0rp4q7pXGQzKB8yLrGRWkMcNghsyqBfvO2gf4SzzCnN+ikLesgY8UVXeCUMkFbENQrbhAZuklKBmDXQsKUpCuIp6SpVeMOSRdHP9UlxsNh2soO2wwRK4F8oQLVPATC63O1ecJuryOjdh25R89EQ/NzGS8MHk5tX1jk72mif33FVMQd9eso1gCJJLjCINAvw03nh+FGBKASJShvigt7Zxite6KnXQ0ZhafndDPhyENdsSnGh2v5RMxZQWnnmZFOUy2qhz27IraDdb4JnU9sL6j4xWSd+T3BGRdb6d5J+On9MSjTnp3AtNUObmVr01mYAr4hwjmBGN2LJpI19kHxRTyTtkSihVtIpBtyCasFJ575KHNhU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199015)(26005)(31686004)(5660300002)(316002)(8936002)(36756003)(478600001)(54906003)(6506007)(86362001)(107886003)(6486002)(6666004)(31696002)(53546011)(2906002)(66556008)(83380400001)(186003)(2616005)(4326008)(38100700002)(8676002)(66476007)(66946007)(6512007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3RFTU04RVB5U3VucVRnelNKVncraEIxN3FRQktJQnpaN1BtOVp1NHBJVEJh?=
 =?utf-8?B?Y1g0aURsQzlvdWZlUmoxL3d3ZlRwZzB1TXJSd3NkdjFEQzY3VkswWGhvMFJi?=
 =?utf-8?B?d0x5ZzJxUUU0dDRWa3l1NjJRWkdxNk9za1NaNzFpallKSld0aXVoR1FGR0Jr?=
 =?utf-8?B?UmxaU21pbURHdkVaNjkreS9PMURUWjFWTkNjL293YVZuTWlVcXlzK241NWpw?=
 =?utf-8?B?RUJDT2FHY3FadWlScWdPSUNqMVMrQ3RacUdKUWVZTS9oVW5vUWY4UXFsbVdx?=
 =?utf-8?B?M3o2WmxkQU9JZ1hkUGFPSnNhOWs0bktKRzNsclpibDBhVnptWXpMemFlTkN5?=
 =?utf-8?B?d3dTSDY1N29hYStIVWY0bUg0aThpSnNEVUR6UEp1cCswRXV6UVU3enNIdXE2?=
 =?utf-8?B?b3JJcFFveTVONkNYR1lsK0JrdjFESXJ3bUFOMHN0a2UrL1RqWktKazlyYzNG?=
 =?utf-8?B?dElhQkJZZ0NhdytXUXFpQmZVTWpmbytIZ1AzYjVYVEwwVDRYQ3hqM0lCVkZH?=
 =?utf-8?B?N3ZEU09jd0ROOTlkNHFPcFNicXluNTVudWFveDF2K0c2bXo0SmI4T1pWRGFs?=
 =?utf-8?B?MXZPVGxJdzNIdHdKWTZGaC8zMnUvTkZ4UnRGVnltd0htYk02VnZrS1ozVnJh?=
 =?utf-8?B?YUlBaWtnem53NnZ4TXArTnJIT0VEbTBwYVdsa2lNdHNUcTIvSkpwaS9rZDVi?=
 =?utf-8?B?T2Zzcmo5aWFzMGhqUlZXL083QWZub0hOOXZIZE82QXZ4M0Ftd2RDTUZDN2Qy?=
 =?utf-8?B?Wi9vdmlHTWpLaDZmYk5INjVYMDMwcUJFNnhIVEh4NG5DcENGeE8vTGFqRUtn?=
 =?utf-8?B?b0pmdFJHYU0xOEQ2dDloWmg0MDZndmV6d0tLY2dNWU5DMTQ2bmhqQWg2Nmxk?=
 =?utf-8?B?bVRxaW9BS0RORDdlaW8wTThEVjVPWTY0V28vRE1RS1dFZFNxbEZmUTE2TUZz?=
 =?utf-8?B?STdhM1BtY1VGVmtLQ08ySHNScmdFbW9uVFd6d1JYSHZURmdtdm1Ob1pWNGdD?=
 =?utf-8?B?cnhFTUllRFB3LzBXc0NETmFQKzhrbHpXVzE3K1BrL1JoRmRKOVRJaDN2YTFn?=
 =?utf-8?B?N0lKTzU1aFNZN0krQXNwZW5GeG0zWXBnajBPKzEyeDZWOFlaS21zdHV0UzVR?=
 =?utf-8?B?b241K2VHaXVBNCtFdlBIUUtGdEExUjV6aHBjUEQ2a2FLaWU3YzU2TkEvUWdE?=
 =?utf-8?B?YkNIbVl6TUtETm45b2oyM1VpcVJ3RW9OSUpXYnVyY2RVRmdUSjAxVUlHc3RX?=
 =?utf-8?B?cGI4c1QyOStGaE1uVEdTcE0xTmlWMTB3YjBVcjN1ekpuZ3lNbnVzUFRxai9w?=
 =?utf-8?B?NWVvNEI1VEJrNVU4bkdKQmc4NE81Q0JGRlB5ZCtwSVppMjE4OHFIaHR0YUtQ?=
 =?utf-8?B?RkRHL3kwbitTV2ZDTHlZOW9pSGl3UTdyV3lCRFd0WXM0a1Urc083dXdEOTZi?=
 =?utf-8?B?RElkUUpWSG5QQ0hGMmNXR2xQWU93MWgyekhVQWF5UlNXZ1VIV2daRnc4c0dV?=
 =?utf-8?B?NjFxOHlEb213WWQreHRJMlpWMG9WL3FYanVJUGl1TStkVThITy8xN1Myamp6?=
 =?utf-8?B?bDBmTmdnb1pldUlFeTFoYUxYU0JpTzFlRmdza1NmS2V4dnoxcENDUGJVTWdY?=
 =?utf-8?B?TktqSTVYcmRDdkNtRUxRVjJiRlJDdlkxUlluSGNKS1ljdXd0dGxib0UyUThl?=
 =?utf-8?B?eS9VOE9ZMjdGTHNjRGFHdmFaMnoybVBkbVE4RlRsZGxMMG1vUWs3bVMwTktC?=
 =?utf-8?B?ZGllcG9uenBDS2ZuOEpNRjE1VEJudjErSTl6a2ZYdmFlS0ZMQmdWR2NwTzds?=
 =?utf-8?B?WHFMNHpra2tTbkdIRktSNFRqMTZXVjVxbjkrM00xWldMZnFPYTlEUW5WSmhw?=
 =?utf-8?B?WlBMcWZodmI5UDJmV0dGU1gyOStGNG00WVl2KzdJNXFsUDMvMzZzcUxCVzAx?=
 =?utf-8?B?L091WGhOdFR0dW1Nd3RFNHlZUitBdmFkcDFUMFBiQmM2WGtDNWJ0QXhibWt2?=
 =?utf-8?B?R1VYelY1T3JpY0tNZzNVQk5kOE5SRm01NEIvZVlraGpmdHh0bVhKSDNDZDR5?=
 =?utf-8?B?OXl1bUdKNFErYkIzc1lwQmJaMEJyQWlnVU9WVCtTckQ0ZFUrZGEwU1p6dEJm?=
 =?utf-8?Q?hFkHIZLiEKRgDNkXRQIkmLrZi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad28ece-1736-4b3d-2086-08dafd364db1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 11:38:10.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVSagpTS7Cx+B5auE2WiUQ7l1cgoBH3QwaSq/eP8hyFqJfeb4dLDPie/6rqIPMFp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6471
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/01/2023 14:32, Florian Westphal wrote:
> Compiler can't merge the two test_bit() calls, so load ct->status
> once and use non-atomic accesses.
> 
> This is fine because IPS_EXPECTED or NAT_CLASH are either set at ct
> creation time or not at all, but compiler can't know that.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_core.c      |  9 +++++----
>  net/netfilter/nf_conntrack_proto_udp.c | 10 ++++++----
>  2 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 81ece117033a..9e12cade4e0f 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1854,14 +1854,15 @@ resolve_normal_ct(struct nf_conn *tmpl,
>  	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY) {
>  		ctinfo = IP_CT_ESTABLISHED_REPLY;
>  	} else {
> +		unsigned long status = READ_ONCE(ct->status);
> +
>  		/* Once we've had two way comms, always ESTABLISHED. */
> -		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
> +		if (likely(status & IPS_SEEN_REPLY))
>  			ctinfo = IP_CT_ESTABLISHED;
> -		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
> +		else if (status & IPS_EXPECTED)
>  			ctinfo = IP_CT_RELATED;
> -		} else {
> +		else
>  			ctinfo = IP_CT_NEW;
> -		}
>  	}
>  	nf_ct_set(skb, ct, ctinfo);
>  	return 0;
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 3b516cffc779..6b9206635b24 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -88,6 +88,7 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
>  			    const struct nf_hook_state *state)
>  {
>  	unsigned int *timeouts;
> +	unsigned long status;
>  
>  	if (udp_error(skb, dataoff, state))
>  		return -NF_ACCEPT;
> @@ -96,26 +97,27 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
>  	if (!timeouts)
>  		timeouts = udp_get_timeouts(nf_ct_net(ct));
>  
> -	if (!nf_ct_is_confirmed(ct))
> +	status = READ_ONCE(ct->status);
> +	if ((status & IPS_CONFIRMED) == 0)
>  		ct->proto.udp.stream_ts = 2 * HZ + jiffies;
>  
>  	/* If we've seen traffic both ways, this is some kind of UDP
>  	 * stream. Set Assured.
>  	 */
> -	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
> +	if (status & IPS_SEEN_REPLY_BIT) {

Hi,

This change has a bug not matching reply status anymore.
Since you don't use test_bit() you should use IPS_SEEN_REPLY
instead of IPS_SEEN_REPLY_BIT.

Thanks,
Roi

>  		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
>  		bool stream = false;
>  
>  		/* Still active after two seconds? Extend timeout. */
>  		if (time_after(jiffies, ct->proto.udp.stream_ts)) {
>  			extra = timeouts[UDP_CT_REPLIED];
> -			stream = true;
> +			stream = (status & IPS_ASSURED) == 0;
>  		}
>  
>  		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
>  
>  		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
> -		if (unlikely((ct->status & IPS_NAT_CLASH)))
> +		if (unlikely((status & IPS_NAT_CLASH)))
>  			return NF_ACCEPT;
>  
>  		/* Also, more likely to be important, and not a probe */
