Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7D92D8DB0
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391863AbgLMOC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:02:58 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:6373 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389144AbgLMOC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:02:58 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd61ee50000>; Sun, 13 Dec 2020 22:02:13 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 13 Dec
 2020 14:02:11 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 13 Dec 2020 14:02:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyFhergTgG66TJ/xU6QUIm/RrMeP3hzZd5s19jlBCX5cTbk7CAmMGl8gM1COb/YF2eios+KAq7fKjwFdxqa3UJ/G6HpyB/Pvw+ZBcZIJYRhTwHSTy0Povi+fpEjkvoa4ikBqVY8X1dBnCSZsfvBfJBUmNnN5dIpsrUaVPyw++lDQUutq6OYumg8dqyDfA0rhSYbJa3GCEGG1NgYvn2Mn1yIMQc9cefwJHuN3QGbxVGQsQ6cbZbet0/KqY//T9rqSqYU4Gz+d+E26wS0dIcEOAqj4YqK2xoJ3wRxNUyoKsrGVKj5+mmSjly3DPjWHJfE1x0icfR6uON2p3dzBlqtj1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VS45v/4oHcq3MkARQIPn4OmfOXIsiVg0jyAmBUgUsR0=;
 b=SD/a6BMIA6oM7PzYz/A4QCh+64h27sESuR5cIKtbnl5slxr+ayZdrsD7lhIZsvxoTSKSxLihBVM1CI0Od+Hq02qiPz6k9vGJM/I/HOy2EqCmXwyPUDiXI2R2oPv7VaXw+qkBW2BhHc78Le+N8tt/ikY7ntmmiA/yghFx46GjMae/Pxvtbzccp1wVQtq7EDjz+eyY42XxiSDC7RneHZM881BSiC0oVeBmAdb7i7cVuhXPZj3rxuxxmEiNgEeEtbXA10Rg/N/6QcC0v+cprx2IvwTwwX7STl1KBsLSwUVe1StctK2fD0a8BGk7j3ty8xIaFwWbpNegBLKGp6XtjbgV/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM5PR12MB1771.namprd12.prod.outlook.com (2603:10b6:3:110::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.20; Sun, 13 Dec 2020 14:02:06 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3654.021; Sun, 13 Dec 2020
 14:02:06 +0000
Subject: Re: [PATCH v2 net-next 1/6] net: bridge: notify switchdev of
 disappearance of old FDB entry upon migration
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
 <20201213024018.772586-2-vladimir.oltean@nxp.com>
 <85b824ea-5f43-b483-55b6-4ffd0e8275d8@nvidia.com>
 <20201213135557.ysmx3qjnafl5yihm@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <e40272d8-0a9c-eb53-c740-dcb156643fda@nvidia.com>
Date:   Sun, 13 Dec 2020 16:01:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
In-Reply-To: <20201213135557.ysmx3qjnafl5yihm@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0121.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::18) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.216] (213.179.129.39) by ZR0P278CA0121.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:02:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13e58897-3112-40ff-e034-08d89f6fad13
X-MS-TrafficTypeDiagnostic: DM5PR12MB1771:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17713420FB3E16EB6EFA8845DFC80@DM5PR12MB1771.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qm7S+FUoVkqM8wy8kn07zn1klDbeqR56upby3x0Lrf38QCAvOsFLqchRwaxPduQnZxy42pTsjHcjC+8ziixncGbgEBnMgWTGjBRQN+0R+W3WxbvjZIsEjig2VCt0fCa8e/TVeaUqS8mYuHLy7lIQkPMK5hdpyY3zq1y5teENlNiMH3yimBAGj37APqxV7jHDOvTjWTIAq3pSwYf/U5sZ1IVRS4dXebaqTSpDNiT7SwLze87GLdCAgWPJy9w5HM63hwy7pLAOY12tK0S3Q7QTScErmjqHNI6fQtBK+8cBEb+6YcfnI3Y4uwSdRpOoPt3bNN2BVYJgrrxJrX7qBbzari/GOP51pqefPaBBJSxkp6BBx7lgI0oBbnmYkfateLM+0onmFKJ0flc7S9x1Y0Tmv7lrkIu7JP2PaS/PG4B0iG0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(508600001)(16576012)(83380400001)(4326008)(8936002)(7416002)(66946007)(66556008)(5660300002)(956004)(36756003)(54906003)(66476007)(6916009)(186003)(16526019)(6486002)(2616005)(6666004)(86362001)(26005)(31696002)(2906002)(53546011)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Ti9EV29UTWtld0pwcTlrNkxrM2ZkTmVOVFA4UjdCUW5SM01oNWNLWGFuZUpq?=
 =?utf-8?B?aUI0VDVQcE5TNjVKUXVEQkE2UUlHeGJsaWZhWk5mbVpJVENsOW9OVmpIZ1lJ?=
 =?utf-8?B?ZlZNaEhmb3puajBVZE8xRDdXN2JzZWs4cFNxa3JkTytudkd3TFkyVDQyZi8y?=
 =?utf-8?B?bU9TL0xkSmNjaUhUOFJ1MUpKZVpjSWZjNTZmQ2xCWDVsb2VqanRYK0tEMzRC?=
 =?utf-8?B?QThVQnkzQU9aa1FXeWg1WS9iVGJDVVdlZnlqQnY1cWoxQzI5MlpLWGpLQ0tv?=
 =?utf-8?B?bm5BR1lqd0NaSm5jRFViYUV4OC95d3VGRWlUWEg1SmFGMWo0L2ZwTEpFQWd4?=
 =?utf-8?B?YkEwY2ZUVkNodDJmWFNHYmJCSnp6VG5vRUEyYnZibUN6OEJEcE01VWtLUGUv?=
 =?utf-8?B?czdmMnVsckdXN0hpSHFFSU9id01QNTUzR1dzNjlwaWtJOG9ENW9wSi9sS1dQ?=
 =?utf-8?B?RC9BU3ZsUU44dndnaWpLbDg0OXJaMVFpekpYb2xGSlhBSU1lejZmR1M1aE5C?=
 =?utf-8?B?a2RJN2tkWFphWW1rT29qSEp4WW5WdVpPdFRrZm01SWF0N0tnWnpTYWI4M09k?=
 =?utf-8?B?VFUxNjFZQ0F4RVoyUW56TFBLc1RUNHFRcW05MG9yVERMUE05ZlpKS1ZOVUFm?=
 =?utf-8?B?cHFmT2VOakdvbStBSUxkYVRWdFVYV3U3a1pKbk5nb2tSaWZMdUhPemJUODd2?=
 =?utf-8?B?KytBSFBTZTRCQ3Q0VGxldlFBekF5eGRHelJSV2ZBbjl0MXBqUnhkYm1CeGIr?=
 =?utf-8?B?aXB3YmdWdjcxRUs4Vk1DZ0ExaGlyVWxUL2NPdDhsc0IrYjVrWlRDYzFsdzhn?=
 =?utf-8?B?d1E0VGdNaGlDMjEyOFlJcWYyZjhydW1ZK0tPRVpEcncreUM1bHQySFlSeGZY?=
 =?utf-8?B?Zzc3M2V2SWJ2QmN6UzZzdVZFektEdEpXcUFQeW1qeHFoT1JRSURqSmR2MmE4?=
 =?utf-8?B?K2I3b1gwNmFmYzB6MTQ1L2ljamlMMWZuaS85anZCdUw4bElCQVJNMVBsTTRM?=
 =?utf-8?B?dzMvN21vTnFUQUNSLzVGZFMwTy9zaHB2M0k1aFVxbEpCc3JYM2VNMXM0d2FV?=
 =?utf-8?B?SitMTWhhVHM1ajNxcWptN1VBS2tWQnpnQUZEVFdKSDVGbit0ZHp4dGM1aG85?=
 =?utf-8?B?d2p3ck5oRGVMM0FkWjliVk1CaGREQ1dqb3NjQXVQUGU3NnUrMFpHN3BSWFpI?=
 =?utf-8?B?NGN6WTE4N1JWZlA2YjAybmxEdG52YnlxUzB3Uk9CM1BhZmRuMGorRStvbU1G?=
 =?utf-8?B?WlhzWHAxcmpvLzNXQWxPWit2b2xwcHJRd3NwaUUzR2NQcUlBOVhIMnEwN0dl?=
 =?utf-8?Q?ti+DiZ1moUkZZGAgiagh0cVlkAnNvGl6XY?=
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:02:06.6472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e58897-3112-40ff-e034-08d89f6fad13
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y4WjzQFw700AJIQHTT0WYsYATLK3JfXfX6nnvA+A8FHCLjG0A6ApvH5c8qHKBuHkc0tKCVYYJnMe52KThfWvxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1771
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607868133; bh=VS45v/4oHcq3MkARQIPn4OmfOXIsiVg0jyAmBUgUsR0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
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
        b=M9MhokZYUPqn+b2QqG1x0VhcfI1+ON2N0jrnQWYTrnO8J7jl+1J2/UXACnj0dQ6Kh
         Q304Wwv75Lj4MKixbTY9P0S+r/MtJn3FWaAjBFJCvCj03qGIGGqx69crTnPCod1FpK
         PlKeXK1otZSxfXAtkoWsvS185a4Ekwu17T/xYNWeNpaCcBNuaXaNP/Gg/DTStHVG/P
         li7tiX24fbMgpjX+1ynKTp8XDpdPufjGp8LCWV+D/aWoSGu479VBqGQR5t2N8V+/gD
         2qTnfOJVhrT+qW8tX9EG7pTio86iGZ+YW9pbWrPihSwTKKfDMQa1dC4n0wQZIkV3sZ
         Su66ene1jRmeg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/12/2020 15:55, Vladimir Oltean wrote:
> Hi Nik,
> 
> On Sun, Dec 13, 2020 at 03:22:16PM +0200, Nikolay Aleksandrov wrote:
>> Hi Vladimir,
>> Thank you for the good explanation, it really helps a lot to understand the issue.
>> Even though it's deceptively simple, that call adds another lock/unlock for everyone
>> when moving or learning (due to notifier lock)
> 
> This unlikely code path is just on movement, as far as I understand it.
> How often do we expect that to happen? Is there any practical use case
> where an FDB entry ping pongs between ports?
> 

It was my bad because I was looking at the wrong atomic notifier call function.
Switchdev uses the standard atomic notifier call chain with RCU only which is fine
and there are no locks involved.
I was looking at the _robust version with a spin_lock and that would've meant that
learning (because of notifications) would also block movements and vice versa.

Anyway as I said all of that is not an issue, the patch is good. I've replied to my comment
and acked it a few minutes ago.

>> , but I do like how simple the solution
>> becomes with this change, so I'm not strictly against it. I think I'll add a "refcnt"-like
>> check in the switchdev fn which would process the chain only when there are registered users
>> to avoid any locks when moving fdbs on pure software bridges (like it was before swdev).
> 
> That makes sense.
> 
>> I get that the alternative is to track these within DSA, I'm tempted to say that's not such
>> a bad alternative as this change would make moving fdbs slower in general.
> 
> I deliberately said "rule" instead of "static FDB entry" and "control
> interface" instead of "CPU port" because this is not only about DSA.
> I know of at least one other switchdev device which doesn't support
> source address learning for host-injected traffic. It isn't even so much
> of a quirk as it is the way that the hardware works. If you think of it
> as a "switch with queues", there would be little reason for a hardware
> designer to not just provide you the means to inject directly into the
> queues of the egress port, therefore bypassing the normal analyzer and
> forwarding logic.
> 
> Everything we do in DSA must be copied sooner or later in other similar
> drivers, to get the same functionality. So I would really like to keep
> this interface simple, and not inflict unnecessary complications if
> possible.
> 

Right, I like how the solution and this set look.

>> Have you thought about another way to find out, e.g. if more fdb
>> information is passed to the notifications ?
> 
> Like what, keep emitting just the ADD notification, but put some
> metadata in it letting listeners know that it was actually migrated from
> a different bridge port, in order to save one notification? That would
> mean that we would need to:
> 
> 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> 		fdb_info = ptr;
> 
> 		if (dsa_slave_dev_check(dev)) {
> 			if (!fdb_info->migrated_from_dev || dsa_slave_dev_check(fdb_info->migrated_from_dev)) {
> 				if (!fdb_info->added_by_user)
> 					return NOTIFY_OK;
> 
> 				dp = dsa_slave_to_port(dev);
> 
> 				add = true;
> 			} else if (fdb_info->migrated_from_dev && !dsa_slave_dev_check(fdb_info->migrated_from_dev)) {
> 				/* An address has migrated from a non-DSA port
> 				 * to a DSA port. Check if that non-DSA port was
> 				 * bridged with us, aka if we previously had that
> 				 * address installed towards the CPU.
> 				 */
> 				struct net_device *br_dev;
> 				struct dsa_slave_priv *p;
> 
> 				br_dev = netdev_master_upper_dev_get_rcu(dev);
> 				if (!br_dev)
> 					return NOTIFY_DONE;
> 
> 				if (!netif_is_bridge_master(br_dev))
> 					return NOTIFY_DONE;
> 
> 				p = dsa_slave_dev_lower_find(br_dev);
> 				if (!p)
> 					return NOTIFY_DONE;
> 
> 				delete = true;
> 			}
> 		} else {
> 			/* Snoop addresses learnt on foreign interfaces
> 			 * bridged with us, for switches that don't
> 			 * automatically learn SA from CPU-injected traffic
> 			 */
> 			struct net_device *br_dev;
> 			struct dsa_slave_priv *p;
> 
> 			br_dev = netdev_master_upper_dev_get_rcu(dev);
> 			if (!br_dev)
> 				return NOTIFY_DONE;
> 
> 			if (!netif_is_bridge_master(br_dev))
> 				return NOTIFY_DONE;
> 
> 			p = dsa_slave_dev_lower_find(br_dev);
> 			if (!p)
> 				return NOTIFY_DONE;
> 
> 			dp = p->dp->cpu_dp;
> 
> 			if (!dp->ds->assisted_learning_on_cpu_port)
> 				return NOTIFY_DONE;
> 		}
> 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> 		not shown here
> 
> I probably didn't even get it right. We would need to delete an entry
> from the notification of a FDB insertion, which is a bit counter-intuitive,
> and the logic is a bit mind-boggling. I don't know, it is all much
> simpler if we just emit an insertion notification on insertion and a
> deletion notification on deletion. Which way you prefer, really.

Yep, I agree.

Thanks,
 Nik

