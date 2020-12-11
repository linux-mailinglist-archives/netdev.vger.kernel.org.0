Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800E52D730A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405669AbgLKJsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:48:15 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5754 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393824AbgLKJrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 04:47:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd3400f0000>; Fri, 11 Dec 2020 01:46:55 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 11 Dec
 2020 09:46:55 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.59) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 11 Dec 2020 09:46:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoPbcGUrrA2YpMFgXgq5UPKozC5oc1jz2HRbZGUA32/EYW6zPGlKknZWlUtgwXQXUjaphXRY3J/u2mo6xz1feAFKgMPmV5cLJRd/GfQANfVsTpWXC4bVm0Z4icXPSpmwpf9H0f9WWZa7DlJaupUv7kzrmsmf0T35BGupUAvuL5iS9J1nFE68E8W0VlKzPy8aGBrevYPf3jJmu8VVcIv4ja+ZbTCDrMfucXUCD7BQTy7KALHeiIKr7V1gYaBlA0P5KJTlVkMfHT2VHU9/H0jxtGFQNMfCCQ+fhuobO4m17zviVqm8qtBBb6Tnh9hjC/BEUOR0VDb24ryN3But4KSLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9+NVCHKwKMhvLyY3Y0rGEBKfgl8nZ8TxcoTvRA6vvE=;
 b=JxR0LRYH+Ad4yT0bs3C506qjnMt4jbWJR3nFxwNguEdXOj8CsxZT+ZjX/yBXAHVWPIYNsnM0svgQQu0n1XlS54IUMaUJZ1IVpWXLr+kqV3rxTMtmyS9gtd4gbG/p/zHz5tvwBy/I19mVDSAVaF5SYBw5U1I3f8ZIFanYZuXMOnq9ohS9yZOvxYY3piiUAXgX2WbvJGDrBj2hvcmfhvwwiXjOpkg9AHiDn8Xj1HCxe+BL62tEP/VQ7NyawHtHuQsxMZWZ+Cb0exu9j/lv7pKqDMYBcSFOk7TF/Sl6iN6CLqTx92XOTeUx2kjDdKjbKB/TEKhgFt3+i9vG0LG1fomFUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB4385.namprd12.prod.outlook.com (2603:10b6:5:2a6::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Fri, 11 Dec 2020 09:46:53 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3654.015; Fri, 11 Dec 2020
 09:46:53 +0000
Subject: Re: [RFC net-next] net: bridge: igmp: Extend IGMP query with vlan
 support
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, <roopa@nvidia.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <allan.nielsen@microchip.com>
References: <20201211092626.809206-1-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <4fe477ff-c58f-5100-d7c8-8dd87b0be302@nvidia.com>
Date:   Fri, 11 Dec 2020 11:46:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201211092626.809206-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0084.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::17) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.216] (213.179.129.39) by ZR0P278CA0084.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 11 Dec 2020 09:46:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e8584da-080d-4b47-0a32-08d89db9b11f
X-MS-TrafficTypeDiagnostic: DM6PR12MB4385:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4385D0FB3E804A365198FF12DFCA0@DM6PR12MB4385.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tM0+xC41nnT/Zuyx8nUFqrw+xlAPHCKw7Fp0tdi8172hC0mvoJXL/3Z5Qaz2mO8QoWkJ9mU5JZYdbCXWH0yKv2kjtQavcM9qQ/J0lgrVBM6epqQERAqc52MoQO/HSHp0JkIxKCWb2xDTr5/AnyIa/1WZ8G9DHXuH2qjrdkU1GAo+dsWIF1bq1AgCS0iD3HFd8N3L441tXEYpcv8TIdd1V7+8d6/dCH5JeYTqtpChhL7TRw7BOL10RFoLT+92T9DPUGOal7GjxcJM2lt48bjSj3AgRv2EwvgyHnE9DjiJ7aU1cJ6ksSafSUp3e5MKMvQY+hJczvo2lWnnDEAM9ALfAredG0WDgLUcRo4RuKax+vVb32LLyBK4+KZT7O9raXHgS1BRQrnBOo+pxBsMaesPuvS7sGkwv1+iVkfZDlq2eLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(16576012)(86362001)(83380400001)(5660300002)(956004)(66556008)(6486002)(6666004)(66476007)(53546011)(36756003)(66946007)(26005)(31686004)(186003)(31696002)(8936002)(16526019)(2906002)(508600001)(8676002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TTR2SjNNeFpkU0hwTEgyQXI2UHNvV2hJaTJ1dVdrUmNRaG1mZTJhSlM4WFlp?=
 =?utf-8?B?ZmlOanYwM2ZtMGVhbS92a09hZlBTcW5GNHZXTTNIMjJ2MG80azh1QlFURko1?=
 =?utf-8?B?c2pEWlJCbnhFeHk2SkRuaDYweVFBTVNaU3g0aVpQaDh5cDRvTzJnUy9FY2Fk?=
 =?utf-8?B?UElNVUhQdGdOSVM4bEFvOHdETmowYzJlSHNYZXVQS05LZ1JUajdzQW1HVnZs?=
 =?utf-8?B?VjB2VFBJMXN6NW1FUkFWMzlVazZUaTJUb0Y2N3AxOHM3NmdLT3N4VGVlby9y?=
 =?utf-8?B?QlhEOUNYYUEwRldXd1FncXJIMURFN3VZL1hYRlc4L2JURVEzWVl4NlhKd1hQ?=
 =?utf-8?B?WEtldXBzOE1PREJRbXlqK3lPTHhSbUYya2xjUkcyNnZZQ1lUMXhRdnZqd3pz?=
 =?utf-8?B?M0l6UktGM3I5bGVKSnJMbVJ4Yjd6am1XV3JOajZnU2lhaVFML0thYVBlYTZK?=
 =?utf-8?B?d2NkNytzNGtLN0lhY3J5SWdnRkczSXdhUDduZkdTTytUUUxjOS9NSkd6SjdX?=
 =?utf-8?B?SG54anBqNXYrUVhCcysxc21rcnpibE56QjN2Q1pVa25ET20zbEwzSVdXdjhZ?=
 =?utf-8?B?MzVweUpZK0xTS0RUV0VTV2NuM0RQNUdkazUvNUNlSk1kU0dhSlgrVGR6V1Fh?=
 =?utf-8?B?cFFKWGhHcXR2OFRKZDJ3SWgybWNqVi9Gd0h4WWVCYXk5QitSRVhGNlBHRnVZ?=
 =?utf-8?B?NE9YZ2dnS0RlbSs0MERQOTJOaEd2RDJ6T3d4amlKVEJiWTNuVXFZWU1VSUF0?=
 =?utf-8?B?ejlXZkVSSGovZlhJSStWcjRvaG5yN1JlUjZaMXN2WmdpWWZyTmJaZkdQcmR1?=
 =?utf-8?B?MXpwMzVacFovRXRHOWJUeGFLckdqa1UwZmk4dlpCQ0pTNVdUaVplUlNGUVd2?=
 =?utf-8?B?Z2VLeERua3BSQk5vZzE4d3k4QmVSM3UyUkJId1hDSnF5d2ZuaVovSWRXNHJu?=
 =?utf-8?B?a0FoSDdrcFF5dERwM0pDOW43OTdiMFN3QzdpcFRVVGFLSkx3aFd6aTBkaFlI?=
 =?utf-8?B?L1VSejBsV1UvZUs2T2FvVk9UNjNpRFVpd3dCbVl4T2wxZnZLY1NaeDE1TzdR?=
 =?utf-8?B?U2d4d1FvT0NkSi9NdG0rZUNHWUtSVk5SUDcxTjdaMjVESlJ2R05EOXNWRktR?=
 =?utf-8?B?eFBSMWVNMnFLdE1zZno4VlVMOWlwTWFYVGgzdVRWK3BzQ21uTWJhdGFER242?=
 =?utf-8?B?QjlyWHpKMXJnQ1o3Zlk5a2ZxSTdZMkEwUXVqU0lUanZ3cEhTbWU1aHo1OWRZ?=
 =?utf-8?B?OGFpUDltWWMyWWlSNzRoZVU3QzFvNUEyOGFOSFBWcU80YTFDN2NTYmE0UWhX?=
 =?utf-8?Q?2mfITvVtG9RKhEpqZO/sRP+LoI+g0WJ2cK?=
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2020 09:46:53.7327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8584da-080d-4b47-0a32-08d89db9b11f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KqXHvRocVRnvXVTYaitTz3CBiHYEmr53zfGAEu3VysKhJg69amUHXfQoz07rOvasKCLJyt+oUL3Lei7B3fkI/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4385
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607680015; bh=h9+NVCHKwKMhvLyY3Y0rGEBKfgl8nZ8TxcoTvRA6vvE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:References:From:Message-ID:Date:
         User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=cew4ExxcehEMGjYH4rSBl7OfhYADfyDWguptT0cGuaXzWiev3Ylhu/LSIJEto5DrL
         jqQ3D04WNVMuQJPnlIL9Aw2gPupxPYtT4pJY6MghHFnABR13NvGTxrqODazJSihCX5
         H4TjptGV1KKVlTnak4kL7Qbs3u+9tbBwWUMDvg9j96IRrPCvQDQGT51hGSTpCEJrT3
         T9txRoh13pao17g5W4IareqCTywKegCIDF5OgIad5wk1KeIx3YmSrOTwjxhUdIgXag
         wVT+xMQEyGhYKn4yNGb5KBr5DnRf7vRDyGcExveJ5gB2nvxBpVjnfhWy+XYFI+kpOn
         WBTmiczdTEQSg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/2020 11:26, Horatiu Vultur wrote:
> This patch tries to add vlan support to IGMP queries.
> It extends the function 'br_ip4_multicast_alloc_query' to add
> also a vlan tag if vlan is enabled. Therefore the bridge will send
> queries for each vlan the ports are in.
> 
> There are few other places that needs to be updated to be fully
> functional. But I am curious if this is the way to go forward or is
> there a different way of implementing this?
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_multicast.c | 31 ++++++++++++++++++++++++++-----
>  1 file changed, 26 insertions(+), 5 deletions(-)
> 

Hi Horatiu,
We've discussed this with other people on netdev before, the way forward is to
implement it as a per-vlan option and then have a per-vlan querier. Which would also
make the change much bigger and more complex. In general some of the multicast options
need to be replicated for vlans to get proper per-vlan multicast control and operation, but
that would require to change a lot of logic around the whole bridge (fast-path included,
where it'd be most sensitive). The good news is that these days we have per-vlan options
support and so only the actual per-vlan multicast implementation is left to be done.
I have this on my TODO list, unfortunately that list gets longer and longer,
so I'd be happy to review patches if someone decides to do it sooner. :)

Sorry, I couldn't find the previous discussion, it was a few years back.

Cheers,
 Nik

> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 484820c223a3..4c2db8a9efe0 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -688,7 +688,8 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
>  						    __be32 ip_dst, __be32 group,
>  						    bool with_srcs, bool over_lmqt,
>  						    u8 sflag, u8 *igmp_type,
> -						    bool *need_rexmit)
> +						    bool *need_rexmit,
> +						    __u16 vid)
>  {
>  	struct net_bridge_port *p = pg ? pg->key.port : NULL;
>  	struct net_bridge_group_src *ent;
> @@ -724,6 +725,9 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
>  	}
>  
>  	pkt_size = sizeof(*eth) + sizeof(*iph) + 4 + igmp_hdr_size;
> +	if (br_vlan_enabled(br->dev) && vid != 0)
> +		pkt_size += 4;
> +
>  	if ((p && pkt_size > p->dev->mtu) ||
>  	    pkt_size > br->dev->mtu)
>  		return NULL;
> @@ -732,6 +736,9 @@ static struct sk_buff *br_ip4_multicast_alloc_query(struct net_bridge *br,
>  	if (!skb)
>  		goto out;
>  
> +	if (br_vlan_enabled(br->dev) && vid != 0)
> +		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vid);
> +
>  	skb->protocol = htons(ETH_P_IP);
>  
>  	skb_reset_mac_header(skb);
> @@ -1008,7 +1015,8 @@ static struct sk_buff *br_multicast_alloc_query(struct net_bridge *br,
>  						    ip4_dst, group->dst.ip4,
>  						    with_srcs, over_lmqt,
>  						    sflag, igmp_type,
> -						    need_rexmit);
> +						    need_rexmit,
> +						    group->vid);
>  #if IS_ENABLED(CONFIG_IPV6)
>  	case htons(ETH_P_IPV6): {
>  		struct in6_addr ip6_dst;
> @@ -1477,6 +1485,8 @@ static void br_multicast_send_query(struct net_bridge *br,
>  				    struct bridge_mcast_own_query *own_query)
>  {
>  	struct bridge_mcast_other_query *other_query = NULL;
> +	struct net_bridge_vlan_group *vg;
> +	struct net_bridge_vlan *v;
>  	struct br_ip br_group;
>  	unsigned long time;
>  
> @@ -1485,7 +1495,7 @@ static void br_multicast_send_query(struct net_bridge *br,
>  	    !br_opt_get(br, BROPT_MULTICAST_QUERIER))
>  		return;
>  
> -	memset(&br_group.dst, 0, sizeof(br_group.dst));
> +	memset(&br_group, 0, sizeof(br_group));
>  
>  	if (port ? (own_query == &port->ip4_own_query) :
>  		   (own_query == &br->ip4_own_query)) {
> @@ -1501,8 +1511,19 @@ static void br_multicast_send_query(struct net_bridge *br,
>  	if (!other_query || timer_pending(&other_query->timer))
>  		return;
>  
> -	__br_multicast_send_query(br, port, NULL, NULL, &br_group, false, 0,
> -				  NULL);
> +	if (br_vlan_enabled(br->dev) && port) {
> +		vg = nbp_vlan_group(port);
> +
> +		list_for_each_entry(v, &vg->vlan_list, vlist) {
> +			br_group.vid = v->vid == vg->pvid ? 0 : v->vid;
> +
> +			__br_multicast_send_query(br, port, NULL, NULL,
> +						  &br_group, false, 0, NULL);
> +		}
> +	} else {
> +		__br_multicast_send_query(br, port, NULL, NULL, &br_group,
> +					  false, 0, NULL);
> +	}
>  
>  	time = jiffies;
>  	time += own_query->startup_sent < br->multicast_startup_query_count ?
> 

