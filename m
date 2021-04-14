Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741CF35F71E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhDNO6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:58:37 -0400
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:1669
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230247AbhDNO6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 10:58:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3ialyBhOCf6TCfmwmkeKpe0O9F53fw6Mea+ddU4DFgHHDVKBITt1sfouVd9YWdXHM4ZDCHmCcddbylGqubZYL6SVZbDYxdIsDbp+RON3lKFBorLY5lEw+2EPydjfdfQ//Qx7siREpxNesnIWCuJ4Wou/ad8iSg7Swtrak9qnj7opmjXgVNGurLHLO23kMznoyUUaDY6c4MG1SqE7vO6z+qQbQPUV/bhq7gB9znhNf+506BAs4kXC+TkAVM9f68rrbWswMq/d6L9jbv7PCKd12PdWfEQOvbmMZlzZJFj24tkR1Pm0WF0ZLXQWD7L3VoQSQFdLLlTydyYWpHJf8Y2/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2LF7gCZI62Th2J6BjnUNziN3iwM8KlCnHwkr1CmBz4=;
 b=ki0ZsbIxHUCyEQvrWDF84ES90lrzVvHQYsTzTYoXEcfk3WGN0Olmv52Dikr5erXjblVulUM+CTNRBnVYQfjhIkgfMXvfbE3ReoLQM1d3JP7UvPDVg3yWLwdGM+IWCuCzb0gx9AjdKkFyZGSLvpI+5yjowCiHlTFEQf8ILC2vYimjQninRaNgKBQxDyTL0HRpg69yAT95HTFvx+j3SQ1uv4R8hA5ri52Thy0qMNvIPzhogz5rkpEOlBoxdW3UNx2Uip5qmCb2lNpKi8ouFWKRdoYz4Zo2PCt4Mr1NUM9wl6sHqGXhfVB9/C50DLUd9KbxZ+ZVBjV/dPSSemzVF3Wotw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2LF7gCZI62Th2J6BjnUNziN3iwM8KlCnHwkr1CmBz4=;
 b=KVRaQqs5sADWwB9Jkc4sqpyfzxBfaj/PKqyk/LBmoWhdiXsSEqO2I3TJxm+JOdrjaeDRNRoLmlWiYd7MsaJydC6/SdB99MQvwW7vbkZ2XAV658zT9Ef5pWWY4R+WryQmxmU3PVv6sY0RpMsmb5tLJ+L0vYtcT9kUBmEd2YpjEJKqQPILGNw5uX6/HoQdC9d7JCOVKqEeusjhVtT4hqTkObDfgMmBKJb7mL7OnQQeXM352Mpw7Rk8HSGuOVxQrgfhQ8gNRMKX7j/PZRB5wsuBW96sxJtqzocpecZ7fjCNyTeglJG1B+GW4YTk2SwSttynqjz0sTbGnhu0utvvpLTuXw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4059.namprd12.prod.outlook.com (2603:10b6:5:215::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Wed, 14 Apr
 2021 14:58:12 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::a1a4:912e:61ce:e393%7]) with mapi id 15.20.4020.023; Wed, 14 Apr 2021
 14:58:12 +0000
Subject: Re: [PATCH net-next] net: bridge: propagate error code and extack
 from br_mc_disabled_update
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210414143413.1786981-1-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <3fb316d9-8ba2-78d2-ac0c-1fab5de09da8@nvidia.com>
Date:   Wed, 14 Apr 2021 17:58:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210414143413.1786981-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0150.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::14) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.177] (213.179.129.39) by ZR0P278CA0150.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Wed, 14 Apr 2021 14:58:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 766b4501-635e-45e5-e4f9-08d8ff55b9a6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4059:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4059F3A627FB445FB8C7D204DF4E9@DM6PR12MB4059.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wgJ8LNR70wWEirT/Q3eq8mSFwfPqkLLgHaydK3Gfb54o5VoaHTPSM1dPOLqhnT9twB3CIX5LYwq2rua9EbB6iHxgo8huuFzzedf1VQ9Bu/xQPvTEJbaUVFiy5Gct8flsmadY77VNtdL1Wo54gQwVddQJsOABwXAUhn4DNc4Dg/0zuF2uFX+E23ORWPp0/OxEWaaMNgHXRwPNDg3mHw/hTDL13OSAHMymgrngGvT3hWFqrkWlDSaoIfengIDReVJLHDulNol7RMSKqW9BGEvf0G1dkBsxzj1kReSCqgcR/GP+1hO6+0gUhG+/e+v4Mtm9HAhFH8r08GQrcPdlPsojp9IEAFD7AQdXssmUdjYgxfphmOCt0qeh/ZHmi1U7oqfQLHpJ+c+r4twSog+DzgFtQJJIGgPzMiqitwiEoB7+QLG3Lviz7aSQCnP2VcB3PJekSWerHs8x+TuZ4sIyNK/TMfLu6fbvL2zAqPw6O3JiVUwY/INRtsRvlxle+VDxph2zHQJKBSevsJCIKrPP9Pebdf/xaPMOAi159D8nNKsbWSC9gX5VyPzENqKh69bwZdXHgH2bv1syxogd5csTIe1JYnrqIYi/W/lYfI/syubRvPmNdmWVY4OkyZ38Hhtt0xe1GiWvjhIeIN8vqGqHmmBa7YLqhQ4hvyICyKo9d1Hge+0wosOtjlqrb3G78YP+6eOov1tOgdkfNp4FMMRyM11ysA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(31686004)(66556008)(83380400001)(478600001)(16526019)(8936002)(5660300002)(38100700002)(36756003)(6666004)(66476007)(86362001)(110136005)(2616005)(186003)(956004)(6486002)(316002)(66574015)(4326008)(2906002)(54906003)(8676002)(31696002)(66946007)(26005)(53546011)(16576012)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aUkvOW5yb2JwV0tiaHl6NVZ1dFdHK3BCemM4VXdIbW1KS3Jzb2piU0ozemtm?=
 =?utf-8?B?aUtBckNnTUczZUd6bkhleCtaS1pZbmdkbC9aeFd3MXRjYi9wR3Z5ZHJML1hi?=
 =?utf-8?B?ZGxjei84dU11ME9ON2xlOGU2SVhFbmhhem9LMmJJaTFWMGNyNTlTSE9CTng1?=
 =?utf-8?B?N3V5ZUU3aFhQdys2SXp2a1NVazNWMkdMQUZtNjZ4UjZySWdER2tqS3BnYUlj?=
 =?utf-8?B?aDZxSi9TVjFrRXVyTHI1aHcwWFBvbkxlUDVNVkFKazV3MmY2cDJmRUkzVm9C?=
 =?utf-8?B?Qi83aFFHSnFLOFNFUmVUSWpGQXhkTXF2akp4OGpwNFJHUGZxYnUwTTNpZHNE?=
 =?utf-8?B?QzFIVitycStlU2FEWmpQOW9USTRLWmc4K1o2QTZVNVh0Rll5YTl2L3JVTWhi?=
 =?utf-8?B?TUpYa2Z4MnRWK2M0QmsvTXh2Q0p3U1JGVUFUWjhZbW8vRTlMQ0NhMERBMmpv?=
 =?utf-8?B?S1pwbzBYUlM3bHE3Nzl2VnNGV1ptVlZ5R3FXTHV1Vi8rMUZxMmFXbUZXY1Ry?=
 =?utf-8?B?S0xQWHJOVkRzMXM1V2tpd0RZdThYNk1YbEVYVGlOa0NkUHQ0RkgycVp2eXoz?=
 =?utf-8?B?ZHk3R0loUG5BMGd6c015QUJpK3hwcWdWVG5UQjQvN0UxdGQyRVFwZVRFdUNw?=
 =?utf-8?B?bHorcVJua3ZhdEp0MTBseGg1ZzE0cUFPdnp0M2wyOW9QSEVUWm9HS0l0ZDFM?=
 =?utf-8?B?bUNRaEQ5eiswQ1JQOFNuSHRjem1RMGlTQ1hZdVFCRWd2QmdFT1JnMkRMLysw?=
 =?utf-8?B?bGJERjcrWlhMVUNrMGo2bDZveHUvVnlSVUZ1THg1TFVuOEY2RE9HaXpESmJB?=
 =?utf-8?B?MHZBUlNBZ091am1RRGh6VW9Ub1l6b0ZiQWZIQk1rbE5Ddmxad2N0cWJIMFNU?=
 =?utf-8?B?SU9nN3JoMWpmN3pWM2R4RVFBM1c1bUNETUQ4Z2x0SHY5SXd0cWlUV1k4Wm9r?=
 =?utf-8?B?NlllOWxtQkxkZFV3WWZmR2hNQm9Ib3lQYUFFZ1lBcU1SakVKMnk4YUIvRHdQ?=
 =?utf-8?B?bFhUVUZnL2diUThhcWl5Qmt5UlBXNDhwN1NIcGxuL1N5bGRlYnJzZW5vUTEr?=
 =?utf-8?B?K05DYzhTU2lCNkhXSmQ0SWxxMXBtbmFkenpDY1FyNGt3YlhEVStqSk05Wi82?=
 =?utf-8?B?K04zSkYwSk16WlFpTUg2R29LamtvZlhwaXlQbXFIT0ZkMXdieVNIYnlzaHBN?=
 =?utf-8?B?RFVMY3VLVXArNWNqK3dBWXFzQURxQmg3UFpWNElIUjVscStQTC93aFJJYmc0?=
 =?utf-8?B?alF3Y1F5b25hcXZ3ZVprT3VRMzBOc3plQXdka1Byd1AwcWd2d0grcnkzOWhI?=
 =?utf-8?B?VWtSdHFVMnhxMm91NXFoWUFRNHNycFFJWXFtbUM5djlyNjh1L0psOHJDbWow?=
 =?utf-8?B?NG9CZEFjL2RKZWE5WHZ4T1ZvRFc1RlJmYlU3aEt3a2ZWVTBrTFdHdGJlcytn?=
 =?utf-8?B?cXpFenhodG5TNGVocGJUY0lVQStQeUFLMVVyeHBiOUJYdktsMVptWXJvN1E5?=
 =?utf-8?B?OGNEbTlkVlZIeTkvUEVOdmV1UHRMRFJiWWVBaU1MZksvN2pmdEY0SGVpQ3Ux?=
 =?utf-8?B?b1VnS1hQbmh1RFUrRHdCUHY0MjhZaVc1S2RrZHJDMzE0UWkzQXpvVkRlcndK?=
 =?utf-8?B?NXVPUFhoWURBbU1JQ0wvTjUxUEtuM2UzZ0pXcDRUdmIydThYL0hoUnhwc3Jj?=
 =?utf-8?B?bVpBZjVKcW9idE1MNzcwM0tuVDB2VG1va2tmbEdvTnFkbDBBMHEzUmxUVXZ6?=
 =?utf-8?Q?7ETEmGmdXsRZA0j4V/c/Zn/5OSb9FAm/jhzBvSo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 766b4501-635e-45e5-e4f9-08d8ff55b9a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 14:58:12.6822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/CCPLdKzTqIB35x7NPkqa2P9Avv+rNK9qOh4gIccOD36i+Fe/jVxGFZMciTsUBcYvxe4jC/DXvQmWckePFlKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2021 17:34, Vladimir Oltean wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> Some Ethernet switches might only be able to support disabling multicast
> flooding globally, which is an issue for example when several bridges
> span the same physical device and request contradictory settings.
> 
> Propagate the return value of br_mc_disabled_update() such that this
> limitation is transmitted correctly to user-space.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_multicast.c | 26 +++++++++++++++++++-------
>  net/bridge/br_netlink.c   |  4 +++-
>  net/bridge/br_private.h   |  3 ++-
>  net/bridge/br_sysfs_br.c  |  8 +-------
>  4 files changed, 25 insertions(+), 16 deletions(-)
> 

Hi,
One comment below.

[snip]
> @@ -3560,16 +3567,21 @@ static void br_multicast_start_querier(struct net_bridge *br,
>  	rcu_read_unlock();
>  }
>  
> -int br_multicast_toggle(struct net_bridge *br, unsigned long val)
> +int br_multicast_toggle(struct net_bridge *br, unsigned long val,
> +			struct netlink_ext_ack *extack)
>  {
>  	struct net_bridge_port *port;
>  	bool change_snoopers = false;
> +	int err = 0;
>  
>  	spin_lock_bh(&br->multicast_lock);
>  	if (!!br_opt_get(br, BROPT_MULTICAST_ENABLED) == !!val)
>  		goto unlock;
>  
> -	br_mc_disabled_update(br->dev, val);
> +	err = br_mc_disabled_update(br->dev, val, extack);
> +	if (err && err != -EOPNOTSUPP)
> +		goto unlock;
> +
>  	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, !!val);
>  	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED)) {
>  		change_snoopers = true;
> @@ -3607,7 +3619,7 @@ int br_multicast_toggle(struct net_bridge *br, unsigned long val)
>  			br_multicast_leave_snoopers(br);
>  	}
>  
> -	return 0;
> +	return err;

Here won't you return EOPNOTSUPP even though everything above was successful ?
I mean if br_mc_disabled_update() returns -EOPNOTSUPP it will just be returned
and the caller would think there was an error.

Did you try running the bridge selftests with this patch ?

Thanks,
 Nik

>  }
>  
>  bool br_multicast_enabled(const struct net_device *dev)
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index f2b1343f8332..0456593aceec 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1293,7 +1293,9 @@ static int br_changelink(struct net_device *brdev, struct nlattr *tb[],
>  	if (data[IFLA_BR_MCAST_SNOOPING]) {
>  		u8 mcast_snooping = nla_get_u8(data[IFLA_BR_MCAST_SNOOPING]);
>  
> -		br_multicast_toggle(br, mcast_snooping);
> +		err = br_multicast_toggle(br, mcast_snooping, extack);
> +		if (err)
> +			return err;
>  	}
>  
>  	if (data[IFLA_BR_MCAST_QUERY_USE_IFADDR]) {
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index ecb91e13d777..947c724c26b2 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -812,7 +812,8 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
>  			struct sk_buff *skb, bool local_rcv, bool local_orig);
>  int br_multicast_set_router(struct net_bridge *br, unsigned long val);
>  int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val);
> -int br_multicast_toggle(struct net_bridge *br, unsigned long val);
> +int br_multicast_toggle(struct net_bridge *br, unsigned long val,
> +			struct netlink_ext_ack *extack);
>  int br_multicast_set_querier(struct net_bridge *br, unsigned long val);
>  int br_multicast_set_hash_max(struct net_bridge *br, unsigned long val);
>  int br_multicast_set_igmp_version(struct net_bridge *br, unsigned long val);
> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index 072e29840082..381467b691d5 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -409,17 +409,11 @@ static ssize_t multicast_snooping_show(struct device *d,
>  	return sprintf(buf, "%d\n", br_opt_get(br, BROPT_MULTICAST_ENABLED));
>  }
>  
> -static int toggle_multicast(struct net_bridge *br, unsigned long val,
> -			    struct netlink_ext_ack *extack)
> -{
> -	return br_multicast_toggle(br, val);
> -}
> -
>  static ssize_t multicast_snooping_store(struct device *d,
>  					struct device_attribute *attr,
>  					const char *buf, size_t len)
>  {
> -	return store_bridge_parm(d, buf, len, toggle_multicast);
> +	return store_bridge_parm(d, buf, len, br_multicast_toggle);
>  }
>  static DEVICE_ATTR_RW(multicast_snooping);
>  
> 

