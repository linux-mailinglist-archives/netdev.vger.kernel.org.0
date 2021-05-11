Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0717D37A367
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhEKJVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:21:18 -0400
Received: from mail-bn7nam10on2073.outbound.protection.outlook.com ([40.107.92.73]:53791
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230520AbhEKJVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:21:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mt1GyzjqhISEzpab9/EruazEfsPQjjWlGFl8tOQmh4NaPXdRJFVd8Pe64Wew1JS0arTF9dO2xRQP9VmXAjpidI4+DlVsfgOUuInGsCjZKN+zkAdECK5ZRHaFnvw58qviOPWkA/t7ZpwdTkP+1rCbSazDFFjvH9cqaYqG1F5htD+vPLfx+J+3dJuo1UX4rFvxRX7B9AUWOu4eB4xavljy4hXqp4orWoIF25Y6okHEjswE5gM483zg02zgolz6xGM0yu0zhgdyHPBmyXuA3eVey+rd+djWjlnpfETOhEmYTHmtRHpd0MJXtYo9Tj4vLHOHRVF9YGiGQ7cqaRV7BosUEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GW42DRbSEf8AdlC+pqaeyj+pJFrlKqKOjDbDsuiCFkg=;
 b=mfXtx+ZWh+MyrFTTil0FAJCnH4lVFYc63LnGzoHa+dpBiZk9kewaxXQcvnJaL/XOsC91DsFhGtWjT/on7jzZ8c9f8rrzNgk+D+9txa6jXN9LdIgXAJc9idWgHnJTQ6cHTeQ1JdOK2Ov//H8ShjPHOzq0hPx2LplR4R1IqP+1UNki8LpArqcV/OrY1Py0TUxEAXaNhO3FnJYXU2d2RN+pBnxByzqLTc9YiI3hySU0FSOOp2vsSGRiDTnrFF51UxhVhEI06Fzw2FUPCuDO+ADo0zzVQFZpV6QOJh+LrUo8mA5RAUzIccQVfaS2Q5bt7xdiIa7xNgFJiuB/yki6a4kBmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GW42DRbSEf8AdlC+pqaeyj+pJFrlKqKOjDbDsuiCFkg=;
 b=hibKb73kbtLFz1IJGyCV/tQzca5GMscb6CQzEDNxm3Y5SXd+nOXw9Zq9cBrh7ERKqdkXiKQSAJoXn6SLzorNzF/7xPyejUdGs/pz/Eb0pgKP5fEyh3mvW3mAgFU9CsKiS6sSPCLaNay6TwR/0JnI4RcCx7r7jSFBJxu/O/YESxxPDreUv7c3ZlujVi1nDztR8Ov4Y8r1+saTR8pW14p6r7DRhvK+PBVCPrWRQnaoWIHPHkMi4LbD/r7ZAtAqgM31Czf8r4Tks/1DSdTCFZQtVNs2wYoYhhWAIqdAGcR3vW5SIfaFXqoXVGINIWkDZ9fWqkkprkMbVqm4PuV4k3BGzw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28; Tue, 11 May
 2021 09:20:07 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 09:20:07 +0000
Subject: Re: [net-next v2 08/11] net: bridge: mcast: split router port
 del+notify for mcast router split
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, b.a.t.m.a.n@lists.open-mesh.org,
        linux-kernel@vger.kernel.org
References: <20210509194509.10849-1-linus.luessing@c0d3.blue>
 <20210509194509.10849-9-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <640d2ba9-9e56-a36c-3734-44d72d8a6512@nvidia.com>
Date:   Tue, 11 May 2021 12:19:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210509194509.10849-9-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::24) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZRAP278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 09:20:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c05fb81-5240-423e-1937-08d9145df79a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5278:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5278F1E31B2851D32B339CE4DF539@DM4PR12MB5278.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hEMjA5iHlAlaLeeBwqodS9XPihN+ppXbNMErLlPqAL5z+xNUPadR/Lne5fK0ElpCPmP4Z/Ow+1GOMh5U6oj6yQPma49tgNBJw95M+DftN4Ll4FEy43ZVSmgcPbVtOwmlzlMCg+pIRd3Vh571KRQMe/GrhxZuZfTWJIQq2m/TqQ63XqRHBX0yU8otGzCgLgLUdy2pVkwvbS2p5cxMVPk1VHPdS2doQgGm6HHkCgPzLZuVIspoo3ENHq/4VnJqxj2EECqdKQkH4vf9QmWUJuHmoyeEpOU2zs+2zG8Leb9sxQg+ek4JyTwvW75TypEe7aKZnimvEqvfYZXdAow2SHgA3uvvtkZW6cr+Xrkcjhk7sTnDWENMruYb0OiDDxEFZ7HzonhMJ2blcnoBI0g81QMGDyC2T+LNJePCuiEe097lw5svzbmW0Tg9XHo+7e3+YY8KhR2YZOxoxYeFdPDfei4h3kVMTevY78CniLr7KLZMDjyoa/8SdRqgNHrpjTL2MfgXNB7hURZdiNWn5D3h5XlbSVXPF0TMuAvbEPL8TRYzj4bKEzzV+yKm6cV3TgPFTUloQOGxPY+RZPSStpEVGzfhGugpughr9g5Yw0BTHnXJ4BsgkBaiapgbI+GcMNzb6u47WMa/37Y+ignOmdQh78H069QjaamV5UpneJvYvASCYU7MTDtOWid2vaXq6sh2CLf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(316002)(8676002)(86362001)(16576012)(66574015)(31696002)(31686004)(6486002)(186003)(5660300002)(956004)(478600001)(8936002)(54906003)(2616005)(16526019)(66946007)(6666004)(83380400001)(2906002)(36756003)(4326008)(53546011)(26005)(66476007)(66556008)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WnNVN1c2dGtSTTV0RWErR2pHL3c3RmpFL3BxQkJLY2RRZzBINUJDZHVOTEFV?=
 =?utf-8?B?VWNHeGtRNSsybnJxbCtuNzJRNG92eGQzb1hjVXNhMWpIeFlvcjRxeTgvL04r?=
 =?utf-8?B?S2IxMEhhVVg4QmFOOE05a3kvOXJrelROZFQwdmROdmZjYjMya245UDVRbTBW?=
 =?utf-8?B?M1hGakJUWG10UC9kcWpZTWVCYkQ0dzRtLzhzdENpdTBkNmNmUEZvZHdZUTda?=
 =?utf-8?B?UmlGeGJEVkxQZVZya1pYZVpSRHY0US9FWFZ6MVh6aGxMdHlNaWtjS2FZeTJO?=
 =?utf-8?B?a0ZSbXBmTzRERnFjNEEvWTFZZkFXYXArNmtOOFBpNWRZTnYyOVJsdjlGVTdm?=
 =?utf-8?B?QWJBZzJmb1Q4ZDUxcmY2bEEvM1o0NUorakxRWURYb0FNbnVzYXZpb2JzMEo3?=
 =?utf-8?B?T2VXREc5a3FTSFNtWElQcXliY0NzTW44dnY2RVNBYjJVbENwcng3OTlOTXRT?=
 =?utf-8?B?bGRQOW84Ym4yR3pod3ZzWTVRTkN4K0h6SGRGdlBSM2dkcm5WUEFFcGNMSUxH?=
 =?utf-8?B?VkF3WFA3bnZrRTZDVzU2cmJZRENFSUpXUTZFLzh4c2FZZEViN2ZLTjJZMmhS?=
 =?utf-8?B?NHplb053SmZLR2FkSE0rSXZTdU0rajdVaXYzYm0xZXR3RjlMYVpCczloR3BE?=
 =?utf-8?B?RXphK2QwRXM2SzBOaW1SQ2ZoQk02SHpZUDNsVXFPWUFGWkdFSGJReUluUTdV?=
 =?utf-8?B?N0VpL3lqcld5Y2xUcUpYTmkxWHFmRmxhOC9LOE95Y1pGYUxpckpOdWNHUUF0?=
 =?utf-8?B?aFBKeW9pVC95WnBBM0ljYVBDUzNWcUJIbFNjT1NtTDNRbi82Y25xNzgxZTNh?=
 =?utf-8?B?Q253TStlczdwdkdQdHROWkFoYVNyY1ZEaGVJY1IySXNsUGNud2tmT3ZXLzhu?=
 =?utf-8?B?OUF3TGliWGs1T3RtSGpjaXFEcGNOMENDUzZnY2ppcE5lVm9QVml5RnExa3RO?=
 =?utf-8?B?WlB0QzU1aURGcnBCbE9qeU9nVEdXZjVpTTVsUUxDNXpaWjQxS2dBSDhqN2hM?=
 =?utf-8?B?UE9HdmpZYWlnTk1SZlBSOVNKSWYvRlFrd010dUNCL0xlbnVyU2JBNW5DTk9z?=
 =?utf-8?B?NGFVbm1ENDY0TXdYNlU0dGNDNC8rNE1oRmxGa0xOWmZxNjFhQUtyUTRIT0Iy?=
 =?utf-8?B?TzhIT3JVOG5rYWRhMy9ockpIYnJWZFJZejZHR3I5KzdUdnYvS0pheit2dGpi?=
 =?utf-8?B?Z1lTOXdicjJEa2NsVmcreGlGZE9Zczhxcjd4Um91TEFaNjRNUXlHai95MlYz?=
 =?utf-8?B?d253Z1VvWElid3U3UXlJMmRnTFM0Nk41dHM4WFd5WGNQRjQydTlxMGhjczNH?=
 =?utf-8?B?LzV6djMrWlhRdy9SNFJTVkRpY1hCZWNpbVgyclhFSjNXbkNwZFJpaUt2S2hq?=
 =?utf-8?B?b043cWE1ZWpWVXlMUHpVSDlUM1NlT21UNHo5TEUzNWxIZnBYd0tJekZPL0la?=
 =?utf-8?B?ODA2bGR1bDRuVG1udEV2RFZ5a3drVGdUWG80aUhubS9Qc0xvVFBCTTJ4QlFN?=
 =?utf-8?B?QWFRYWdHS1dPWU1JSlFwNE4yNkNlM2FsdkNNQ0ZPTVR1bDBGU0FXcFlrWWFa?=
 =?utf-8?B?Q2M3YnRxdU9YQlNNdFQ0WmZpMVg4RnRTN25mZ2tISzN1bXFGaU45OVFFSDVr?=
 =?utf-8?B?SHNKbVBPUEFWUGNqSXhqQWJ3dXF3OHZic04vM3pQTWw1NCtHRmlmbWVYQjJI?=
 =?utf-8?B?T21UaVpkNUFybklKWFRPeVBhOTZ1bGQvZU0vWUJTNDYwYkNVUnhGeHIzcjJz?=
 =?utf-8?Q?lppbG9DiGypRPeLuISPrtQGGjxVbe6oCOczGLm6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c05fb81-5240-423e-1937-08d9145df79a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 09:20:06.9515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/E+tDP7oDuCw+tzFykUamnvorSfq3lTSOKqVoj90XhOvoxy/BojIHqL6xd3K6dKLoid6qosnclR2XASGcDeSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5278
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/05/2021 22:45, Linus Lüssing wrote:
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
> diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> index 839d21b..39854d5 100644
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
> +static inline bool br_ip4_multicast_rport_del(struct net_bridge_port *p)
> +{
> +	return br_multicast_rport_del(&p->ip4_rlist);
> +}
> +

Same comment about inline in .c files, either drop the inline or move it to br_private.h
For functions that are not critical for performance(fast-path) I'd just drop the inline
in the .c files and leave them there.

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

