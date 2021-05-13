Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4088137F71A
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhEMLs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:48:28 -0400
Received: from mail-mw2nam10on2076.outbound.protection.outlook.com ([40.107.94.76]:34400
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233590AbhEMLsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:48:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpL6xabC89wEg890TyMrmiAzQFUABVcTB8cA2NW112u6s6eeIEO5KjQ1Ugc1R9hdPB8kjeVgHvHL3te4TbTctmSlaDekGiTaqSTwvlku10jSlCcPojvdKRobeeRE5UxLW8e/wO/IlVsdxOmAZsJfW3IK36khQLUFVbu7UAymATJxmhY7vYLw8nHar24xrp3WJ+zphJ+g7ge6vI+u6XdkWhsObGpNqZ/Jtr0piajzxy1ydzubTH1P1LPc3jjPmamDmbkiJaA4ip6//XR3iSQlHAjsomqoWxi2cislGuZzRv8uE6bwghFCZgnipYsEeHJyrnPfCb29BGyQHO+ObeH9Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jzQduEjD3G/jvJzLUPq8xfxoTdzTnPlDw5So0f5+hs=;
 b=UKHHmJ36JZcp5xnXa1dr6Qu+ky53Fh0DPqAGL/q96YDjPwOhHWzF4UtPPYlUBBqqCjfr0DQsqiI7gMpU+68nsfivB2luyD0qVrYVxJ1PhOYKJvi9MTqc40G1+HOV9qcaNB/x0ZA6krd5fpWRj0g+UXMQ1NUHRJGjgA+jIl43IvlwHXi9yxdAMf4eMF1m6PqcJ1q4+ELsCy+qsW8EAqYDzfa1ML0JnUR2Jwft9f2W/Xm81wv1th6ATUivOy+dqiIk2XQCn0rcyGORtggao8kUpYK5OlMXga56Q0IVnVRuYCvoSuYFUlpJ9XQEmWFQhSnAf/I+PhAn5ku5C6x58RA1sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jzQduEjD3G/jvJzLUPq8xfxoTdzTnPlDw5So0f5+hs=;
 b=qXoIOUYvbtpVp4eRUCt7Uhh5delYaiapYaSnw4fyopBETuG3ARyYnNq3JYDYCfhHAEcVEaRfb/qp0L6/kCRlJ7bFhptmQZrcDxx63W+SSfRIQLEfpE0CE3AQKPly+yPfVpgd90w4s2HzOT2ix4JAwF8i+Q25BxoqupvBk4XaXAEZBGY0d5hrkMWJnfwlrLbpicFiJwC2lo7IN6mE5/tD6hFAfySXZkWCo2x9mM9D0Eq1WdF4xdMYk+Fgt6CNzkqWuI3iEtEtwaDpKKns2kx5Sp9Z6RlKKMlQTFT4tsAheCDkCMG+0GEkeqOLEKXu2JPIR+W8LlTpmP7jbP3vBI/LFQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5325.namprd12.prod.outlook.com (2603:10b6:5:39e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 13 May
 2021 11:47:03 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:47:02 +0000
Subject: Re: [net-next v3 08/11] net: bridge: mcast: split router port
 del+notify for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-9-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <3f003dcc-66d0-e4a8-aaa1-99d9a9fb3940@nvidia.com>
Date:   Thu, 13 May 2021 14:46:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-9-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0042.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0042.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.31 via Frontend Transport; Thu, 13 May 2021 11:47:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7761cd6d-1235-4ba9-32c2-08d91604d310
X-MS-TrafficTypeDiagnostic: DM4PR12MB5325:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB53257C0132F7C220F579DEF1DF519@DM4PR12MB5325.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSyLW04CRgG3vAkLBqUsrpMubCHDwcNAG8umHqDq0zZgRsAF1j8G05doA96T3tLrIjSZl2XVwrVtE8RzpwRhEaxddGFMO1ZkjGsE6uZ0/SrYrP80itiavt0O+IRHFCBddzb64V4cSIXBZiggvuUGAQn7CG79Tc8o9ho4De6l0Lw3khXMEIK41FLaOr6bpyR4flRkQTJS41PtOEpBj5xpMEjG989Ed0mgy/2IAac5s6OHg1eBG84S+LWfEYy8QmOOCFD5uXExz9zVP/mtLmKOVpXmya4sMpu8wqxI9lL/U8Sfh+NM7MXD0VgQAM8j0qGldps90eLxEOe1lFHEq1xw9R3IO0hfIrIa8y3LcUqBWi7Knr5boT5U6iN3v1rVeqIqsem2l3CBLy8pgiTOqKnNojDOC8s9eY0T7AamREjYQ/+tLkinGPRYUm7yiVcwH4hrvwVYZ2XaFJR8bYebRZwijelf7PwY9ezSSwq5+zGfQ//y1rc3DoYlg2TT+Xhvm55JaSx81AWFIlu+dvUuCvq15NVbugbxvvUyBo1TnzQxBlyl9ZVkAI98AmrJSIreeTgUX8ngRwRti4vfytP9HYmkISgezp5Q7c8vaEm76QT5IcWXCSDUfQ+grufTpK6odHe+f7h/6HabIpndGm8ZxkjFXJb5cxX7ii5oC+k0F3r+OlOsALYhiUUUsuNpjlrvpjhp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(38100700002)(478600001)(8676002)(6666004)(5660300002)(2616005)(8936002)(4326008)(53546011)(86362001)(956004)(6486002)(54906003)(26005)(16576012)(66476007)(36756003)(2906002)(31696002)(66556008)(16526019)(66946007)(186003)(31686004)(83380400001)(66574015)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?anY5dEt0SzhCRXA2eUZVelVubTJsSVhTSmR0dThjRDIzQTRDOE9DQUlPaHZ3?=
 =?utf-8?B?M2duTDczL1UwYjk2UEd0WEVpZmVlOFlLSEFoVlRQang0NW16cFBMTmkyU0hX?=
 =?utf-8?B?cmFLa2NNd3o5d3Q0MEh1K0NkcEsrSjYwL3VrVTdQV1BvT0RvQlRveWpHMVB4?=
 =?utf-8?B?QTFsZTN1ZlNqYWJlYWY2MnhmYU5ZdVlQMUQzQ044QXc1aFkzRUk4eUtXenNv?=
 =?utf-8?B?QjJnK2ZEWVkyaGFTTEJUdGFTUWhuQWhkSVR5SmhSU2RIZGx6WElKaWptL1ht?=
 =?utf-8?B?aXVMZVB6VS9wamJqZ05DK0hSMFlka2JJM3c5Sy8vVnFqLy85Sks4cWdwVzda?=
 =?utf-8?B?RmRMUXJ6RTE5U0ovdS90SGpFR0Z2SnB6b1Y3ZjJjemJhUVlzMUdFSTFuNDB1?=
 =?utf-8?B?YlI5Rm1hdzN6NC9mUDJhRG1Dd2tuRnFJMUZISkN5VWdvVGVkUGdNWGFVSDUx?=
 =?utf-8?B?SFFYSk90a3dBTllWQ1BHSk5kNGdXRzRjUGt5Ym91bmp0RTFpMDhjVlcvRm83?=
 =?utf-8?B?eitWdmtoN2QvSS9Ka2VYZUwwdFJRcnlqd3kwRGw5MTJnUXFjRDdYODRPM3V1?=
 =?utf-8?B?amZSWkY3MjdQSWU5eldQbi9TUThhR1F5dWtzNWFrTTJqYnhaVzNOQS9IcUJl?=
 =?utf-8?B?K2Qwc0hpOHFGZllYN2g1cWIvcWdGZkpKdGNSUTJLMEVZUHB4a3l6U2R5VEp2?=
 =?utf-8?B?Ty85YTd2Q1ROb3hNQkFtS0NMVjhsUm8rcE10L281VDdGU3I2dkREUitKTzMv?=
 =?utf-8?B?SnZDcHlUTWlpSTZYUTI2VjZ0VE1ncWhMRWZkeVJEL21VRTJXUGIwRUJ5U1o5?=
 =?utf-8?B?MGg4Z2RTUWdsQ1ZwQjdIem8wcy9mSFhLV1VyRUJxVTI2VmFJQzJacXl6VW1L?=
 =?utf-8?B?MDN2emNOR1dFb2ZYVzliblB0L2VveThxWDZnZCtiYlJ2VEQ2V0VyZkZZN0cv?=
 =?utf-8?B?L1R6YXI4VGtjN3ovM29nRXFYcWJaeVN6aTliMjB1Y204VW01UE9Nb2VsSThn?=
 =?utf-8?B?V05jNDhiSjhHOWVrdnVMenNPcjRXK1A0TUFZWTB6bUxWRkY5MTlLRXlWeldu?=
 =?utf-8?B?M2puVGxQcmJsVUREcjNXZlpVK2syQjVwa0FNNnNaQW9tQXFUV1QzeGRmOWN1?=
 =?utf-8?B?ZG82K29zZ0xGdnlvQmg5RVhuZTV4NEx1bERPaFdlQ29sQ08rOVNKWGgyNlo4?=
 =?utf-8?B?Z2hmY3pTYVdJemVXdlNMQi8ram1iWm4rZ3RDLzgzQmtqYUNwSFJvQjJKaWNG?=
 =?utf-8?B?V0M4Wk9Sd2N3SkRLL3d5Uk5ybDlEOUtLYkZ6ZjFsY0JmRU5wQWE1OUoyaFNI?=
 =?utf-8?B?S3BacnpZUVZDbSswNDFzaXRIRyt4VVFzaUl3cWVYL3FJWXpaNFY0d3dFck9Z?=
 =?utf-8?B?d0x6KzdOMjk0ZkZ1QlVKSnJzQzB3WXpRV0s1REM0MXRNcC8wbTViWkZFd2Na?=
 =?utf-8?B?UFdoQ3FxM0RtZWlHMEhWd3pLcFF2Z3BOK3d2Vi9aSkZIRlBjb2R2VXByN0xF?=
 =?utf-8?B?cHkzbUE4MFNjSGhYQ2I1SGpNY2JaaFd4UXpjbTBaRm91MU1vSmNQZXJJYzQ1?=
 =?utf-8?B?OUFJREFnallzN1FSZnZlZmZ6bzU1ZjZ3TFovWG04dFZHVVk3aWZ1VEN6SjdZ?=
 =?utf-8?B?TDllRkIxMnlqYWFEK00rVmNpZS9iejFmWHVybTY0cGxUQk1rN2N2b0IvdEkx?=
 =?utf-8?B?bTVoTnNXSkhKK3R3ZU5YSGJpN21nZ0g4U09EazZXUzhLeUM2RWhmandlWTI2?=
 =?utf-8?Q?T4Yu2Nx+U/WtjiF5DHM2u1U6NKWNKgkeJ1ily7x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7761cd6d-1235-4ba9-32c2-08d91604d310
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:47:02.7744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8PVHYpSXQH+MUOQiLBSYCxWFUhEyrSo4HTpxQyFC4OMKgxmiaLV/NVI9QvdfkCqy1IqNQFmR6AyImDnZsfK/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants split router port deletion and notification
> into two functions. When we disable a port for instance later we want to
> only send one notification to switchdev and netlink for compatibility
> and want to avoid sending one for IPv4 and one for IPv6. For that the
> split is needed.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_multicast.c | 40 ++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 

Not a fan of using bitwise ops with booleans, but the code looks correct:
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 1d55709..01a1de4 100644
> --- a/net/bridge/br_multicast.c
> +++ b/net/bridge/br_multicast.c
> @@ -60,7 +60,8 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
>  					 const unsigned char *src);
>  static void br_multicast_port_group_rexmit(struct timer_list *t);
>  
> -static void __del_port_router(struct net_bridge_port *p);
> +static void
> +br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted);
>  #if IS_ENABLED(CONFIG_IPV6)
>  static void br_ip6_multicast_leave_group(struct net_bridge *br,
>  					 struct net_bridge_port *port,
> @@ -1354,11 +1355,26 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
>  }
>  #endif
>  
> +static bool br_multicast_rport_del(struct hlist_node *rlist)
> +{
> +	if (hlist_unhashed(rlist))
> +		return false;
> +
> +	hlist_del_init_rcu(rlist);
> +	return true;
> +}
> +
> +static bool br_ip4_multicast_rport_del(struct net_bridge_port *p)
> +{
> +	return br_multicast_rport_del(&p->ip4_rlist);
> +}
> +
>  static void br_multicast_router_expired(struct net_bridge_port *port,
>  					struct timer_list *t,
>  					struct hlist_node *rlist)
>  {
>  	struct net_bridge *br = port->br;
> +	bool del;
>  
>  	spin_lock(&br->multicast_lock);
>  	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
> @@ -1366,7 +1382,8 @@ static void br_multicast_router_expired(struct net_bridge_port *port,
>  	    timer_pending(t))
>  		goto out;
>  
> -	__del_port_router(port);
> +	del = br_multicast_rport_del(rlist);
> +	br_multicast_rport_del_notify(port, del);
>  out:
>  	spin_unlock(&br->multicast_lock);
>  }
> @@ -1706,19 +1723,20 @@ void br_multicast_disable_port(struct net_bridge_port *port)
>  	struct net_bridge *br = port->br;
>  	struct net_bridge_port_group *pg;
>  	struct hlist_node *n;
> +	bool del = false;
>  
>  	spin_lock(&br->multicast_lock);
>  	hlist_for_each_entry_safe(pg, n, &port->mglist, mglist)
>  		if (!(pg->flags & MDB_PG_FLAGS_PERMANENT))
>  			br_multicast_find_del_pg(br, pg);
>  
> -	__del_port_router(port);
> -
> +	del |= br_ip4_multicast_rport_del(port);
>  	del_timer(&port->ip4_mc_router_timer);
>  	del_timer(&port->ip4_own_query.timer);
>  #if IS_ENABLED(CONFIG_IPV6)
>  	del_timer(&port->ip6_own_query.timer);
>  #endif
> +	br_multicast_rport_del_notify(port, del);
>  	spin_unlock(&br->multicast_lock);
>  }
>  
> @@ -3508,11 +3526,12 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
>  	return err;
>  }
>  
> -static void __del_port_router(struct net_bridge_port *p)
> +static void
> +br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
>  {
> -	if (hlist_unhashed(&p->ip4_rlist))
> +	if (!deleted)
>  		return;
> -	hlist_del_init_rcu(&p->ip4_rlist);
> +
>  	br_rtr_notify(p->br->dev, p, RTM_DELMDB);
>  	br_port_mc_router_state_change(p, false);
>  
> @@ -3526,6 +3545,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
>  	struct net_bridge *br = p->br;
>  	unsigned long now = jiffies;
>  	int err = -EINVAL;
> +	bool del = false;
>  
>  	spin_lock(&br->multicast_lock);
>  	if (p->multicast_router == val) {
> @@ -3539,12 +3559,14 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
>  	switch (val) {
>  	case MDB_RTR_TYPE_DISABLED:
>  		p->multicast_router = MDB_RTR_TYPE_DISABLED;
> -		__del_port_router(p);
> +		del |= br_ip4_multicast_rport_del(p);
>  		del_timer(&p->ip4_mc_router_timer);
> +		br_multicast_rport_del_notify(p, del);
>  		break;
>  	case MDB_RTR_TYPE_TEMP_QUERY:
>  		p->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
> -		__del_port_router(p);
> +		del |= br_ip4_multicast_rport_del(p);
> +		br_multicast_rport_del_notify(p, del);
>  		break;
>  	case MDB_RTR_TYPE_PERM:
>  		p->multicast_router = MDB_RTR_TYPE_PERM;
> 

