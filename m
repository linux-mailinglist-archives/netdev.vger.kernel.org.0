Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBA0316387
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhBJKRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:17:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17040 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbhBJKPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:15:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023b2090000>; Wed, 10 Feb 2021 02:14:33 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 10:14:19 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 10:14:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkM08WrD1nOt2DorU0QZg9mS6xcQyrJN6yslBYzw7FtsLsY/TC4MDImHib4e3V34FfeHZ9dOVPoJyo4XxFO3XVol0jKqn4zu/wT3VPpfLualIadUiGXtZB430XkzLQc6Q5CF5z+1wIOr32A/TlMnjnECVQzps3jLpjHxXNg3Z7Ua49ZQAiZEhA0c0B2ZxvjsuZQQmdAlKE54o+vEtURnbDFzCZlibHwD2Afjcs6XZSbfNnb4RqGj4/70GVnGzSJlrRoOkl7rvYSaLcHnv7X1IqABPGhAFUrHgXb3I9fxtDsG518WnDHaUYy2cbdJ6/RYMNP6V8DexbomrqATQq6pAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgUy/wru6f2nYcJA3qXWcQJ2f3n/Oyblho3aFWygJk4=;
 b=OMa6MWYam/7koy9Rafo9tGtUQZppGdXMow9xogjXU2EEoEidJ4Sbr4nCvrgHtjkkg8hUB45gdtFwsdA+sYw+mCPInOiwuVlRcqGxTllIjnAkBbtyj0hOpyvLJ7z3eHvqbzFklrmqiZvq1QzfdFiG56GpRVUkxSWkmZrU79m3GgNuNpAWr+LRbav5Ya+VwS/1axYADEsGw+yWbZTKj6+GTbM3sw/JF8UJCa2ladOIc//Qy9Nl//CUKcFCWK6aaU0ExeC6OF6LMHC/KjXTdRtRxndj03EAqBQEpOjjypxodTFT26DZOg9Oh2cVyupwE07DnQoO6bwtTZBlNkAMMA3PBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR12MB1290.namprd12.prod.outlook.com (2603:10b6:3:74::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.30; Wed, 10 Feb 2021 10:14:18 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 10:14:18 +0000
Subject: Re: [PATCH v3 net-next 08/11] net: bridge: put
 SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS on the blocking call chain
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Roopa Prabhu" <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <20210210091445.741269-9-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <0208ba7c-601b-de5c-1922-c6d1911501a1@nvidia.com>
Date:   Wed, 10 Feb 2021 12:14:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210210091445.741269-9-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0124.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::21) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.121] (213.179.129.39) by ZR0P278CA0124.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 10:14:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8db930d0-a4d2-4b9b-9b11-08d8cdaca028
X-MS-TrafficTypeDiagnostic: DM5PR12MB1290:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1290E6FB515D8628CF081902DF8D9@DM5PR12MB1290.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hOkROhGNBc/c7nswUbrI2fji0e00sMIcX7K1nDTYj0/QfAF2JXeTmGAIUEkyG3zkzAkVqIWkzHiYKZ39ZCxBVL5rIasV+YiXQkV+cvTVpvMD60Ehdwqu0A6tP8ouRpz4yLEmXvHRxOs60D1weNqn+WvSDbM9dsucwcHH8wlY0wXv4MF2KYkYrnUxYT3mCdPgja8TSwhkaKAKLAfGYi24ua0OKoVGCNs0ya2BE5GmdKAmr7saZUYcL6PCaMOOF3UuMjoJTTP9nF7DZ+qwLzvx4ZHlk8Xj9bhSbFnH2hgvw3VEmZgfe/zWkt/DqJYweWSMXxPhW9S8+VndTZnfgyV6efsSruZBergM9mfajP5EOrI20JBe4Ezx4AmhOq2G5Ipp/yehbMGc7rZ2HS9VEqGQa542PDw2D7xQqTTdovHtKI36Ck/0qWfKCNdfD21wVJRGsmtL52toxxAwRBPpQlS9KvmhDdX8NigCkM1g9ko64usNJrX1I8wORfV5w02mHLQrO899YIDirdMewTFb6lunhBbzm9K9pa+WLevvORIrKVQOTCKD96c+unSlVQHKElhQuVD08ixGQGiG9TjwgvNm1wh3aFJ1lkYIVHqUg6tSIC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(366004)(39840400004)(376002)(31686004)(26005)(31696002)(2616005)(54906003)(956004)(83380400001)(2906002)(6666004)(8676002)(7416002)(5660300002)(86362001)(53546011)(8936002)(316002)(36756003)(6486002)(16576012)(66946007)(66476007)(110136005)(478600001)(66556008)(186003)(4326008)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aVBCOUdzaUhqcmN0WW15dVRoMjBsZFlTbjZIdTJuZWUvN0xTVlZVU3c0N1Yv?=
 =?utf-8?B?aE5jZFhCUHRZUGlTTEtiblVobjdjSWNpbEpZMFd5Z1pYUjZRU2JxdmNEWVlF?=
 =?utf-8?B?UGZXT21xZXc2TUh4ZlU4UWQrK1FKT2JOa2hROUQ1b28vUkh5STY5TlBhRWM2?=
 =?utf-8?B?aERISHVHaVJJMzRBbk15dkhNdVMrbzlsWG4vYmh4KzJBTUpONk15ZVhLOE5Z?=
 =?utf-8?B?dHBaaGZpd2tyRnR4alc0NzdFS0RoM2hKOFFObldwb3YwbC8yYTZnbW04OEtu?=
 =?utf-8?B?T08wZmZnemN3aTVOUkVEazRWVThJVHgvZUFNQmUydWs0aVd2UmhuQVV5d1hr?=
 =?utf-8?B?VFNtblc2OVJ5MnV2eDRqZzhWSC9xWGhZNmQrRFhEb1BYVXVoYUNrcFdtMlpp?=
 =?utf-8?B?d2xnbC9RTEQ0bVlCeXhMQTU0TGZJMmdXL2kvL0ExSHJEaWcyZy9KSmwxY0lS?=
 =?utf-8?B?aFU2RlRpQ0RiUjNFajJ6K3RadStDQzkxamF4ZFlPMUVhMTFkSm40cExIVGtx?=
 =?utf-8?B?dCt3WGFRNWl0SjJ3bU5DekxuOGprS0gzR3l3cUJPWDJtczRYYTBwcEVBWUJs?=
 =?utf-8?B?d25VdlI0eWYwc2VNZjNCR0F5UDVVRHkvMkFhY1lsRTZiYmgwdmxJcWN1M0Y2?=
 =?utf-8?B?OGdCTUFPRmoyWXhGVmxvcDdYeEZseFIvSGE5b0tzdXJIVlV0a0piZEdISXRH?=
 =?utf-8?B?eXk5RHZmakVFaW0yZUxOSmlvb1JrR2NJZldMZkkrZGRCR3d4eWo1TWZGR1Ew?=
 =?utf-8?B?QU11Zzhmc1lxd2JZcnlvTGwySFgvdkVxcWRvTGk2TmpaSU8xUXQ4YW1mYXhK?=
 =?utf-8?B?cU1RM0FBZGxmdVlLQ3ZnUDJlMm9uZ0pxQ0VXNENDV0JjMmNiY2VjdDFCVDg0?=
 =?utf-8?B?QWJYck9PdEg0MzhLTVF2ZnFBekJ4SmU0RXp4ZzVSK2VHNFZzY3doRzFXOWZz?=
 =?utf-8?B?VStoazFrY2VWaXRLZnZmQWw0eWJreEluanBpREU2emtWVnNCc0FmcW9hbG5h?=
 =?utf-8?B?eFJXRmdOUTlQclQ1R0YwVExkeStsUFZNbmw3bGZCaEUvNDZIdWFLWGJuaXBX?=
 =?utf-8?B?QldSUmIybjhmVnh4RitIWExIbVFMWHg2bHU5UzJaYlFSam95K1dtZ01FakVR?=
 =?utf-8?B?WCsyNzhLdzlpZUhVQ1huNjVtbjF6UE53Zy9WNk56dUQ0Z2E5dmV6aVhScFJ4?=
 =?utf-8?B?OGhqREF3YjRHazlIV1FFTTFDUWw5ckpaSGNCclI5WkFIQllzamhhOXZVZW5F?=
 =?utf-8?B?ajFLRVlvY2szSVl3MWxWZEs2MmJ3MVh5QTFtaHZtYXc1RGRxTkMvbEpBbkZo?=
 =?utf-8?B?bENGS3NPMGo2OEJHTHpDVVByUlprUVNLQWVaM2JOTS85ZUxWR3YvWHBoa0cv?=
 =?utf-8?B?SGt6SnBVdk5JMjlHMmRUV3lEdGJkV3FTeHBSTDh5R3dRUVhvNWFISHU3TVZO?=
 =?utf-8?B?bXBJV1hkMzZMUS9BdHR1MitGeVJsU3l0VE5zTTFwZW83QjhudDFLSUdPd0FK?=
 =?utf-8?B?Q0ZWQWw4cU94SzZidHNmK05sYmozS29PMjlrSWxuYWg0S3laTlNub29xZFlI?=
 =?utf-8?B?cFdmR01Oc093OGVoSGhndlZWSFVWV1JsKzVnOVcxc1N5MytkT1dPem5RSlRY?=
 =?utf-8?B?aVN3QnB6NEVHVENYQkNVMmZnQVdRTHVwTEdVR2NzKzR4Yll2b0pReHcxRHFE?=
 =?utf-8?B?RE14bDVmQ2QvTEJud0FOclZNT20yT2RrbWROb01xTGpONzM4WUhOMFpHaVVT?=
 =?utf-8?Q?ZiUK8E1JfG5bTij1dFtym72i3zIT9uZGNiRYwSe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8db930d0-a4d2-4b9b-9b11-08d8cdaca028
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 10:14:18.1026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SatWL5VOKhfhNrhJoTlOOr127tZAcHrzD768BgSmzm5xn6gtEJ0lVyvZkxMkIgUpq+TkMIif+RBtSJVlFzb+pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1290
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612952073; bh=zgUy/wru6f2nYcJA3qXWcQJ2f3n/Oyblho3aFWygJk4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=ZtOfmDlfV1Tp7N8HhlFgU4zJwdGshYQQCmepadE+GqO0WjdXzgyrQlQ5KEV/a/sf7
         zTqggHdYQSa4HVyCs0RgDjmPELGcwDV49Ukl6u7vYWmMeHrRgjQ7D4wVRm/6kjIV84
         Rps2/5Uk48WpUvBG9czEJv+8CDNqccQ3qS5lLnJ7gp9o0hnoH8kYpywHwXCmgKjl24
         LY1SiaUvKM60RK6PlQ3UJkj5CJdozIoxbMxsXZHj5GOvfjJH1ZV/QD+Rf5aYhTY/wk
         nBe/0yCaPB7kksI4amfn7SmngDldSOICG7Y5T4HTBOKhb4sIeSiedesXHGrpgxrrd+
         rXdkaUbGIY1XA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/02/2021 11:14, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since we would like br_switchdev_set_port_flag to not use an atomic
> notifier, it should be called from outside spinlock context.
> 
> We can temporarily drop br->lock, but that creates some concurrency
> complications (example below is given for sysfs):
> - There might be an "echo 1 > multicast_flood" simultaneous with an
>   "echo 0 > multicast_flood". The result of this is nondeterministic
>   either way, so I'm not too concerned as long as the result is
>   consistent (no other flags have changed).
> - There might be an "echo 1 > multicast_flood" simultaneous with an
>   "echo 0 > learning". My expectation is that none of the two writes are
>   "eaten", and the final flags contain BR_MCAST_FLOOD=1 and BR_LEARNING=0
>   regardless of the order of execution. That is actually possible if, on
>   the commit path, we don't do a trivial "p->flags = flags" which might
>   overwrite bits outside of our mask, but instead we just change the
>   flags corresponding to our mask.
> 

Not sure I follow here, how do we get any concurrency issues with sysfs or netlink
when both take rtnl before doing any changes ?

> Now that br_switchdev_set_port_flag is never called from under br->lock,
> it runs in sleepable context.
> 
> All switchdev drivers handle SWITCHDEV_PORT_ATTR_SET as both blocking
> and atomic, so no changes are needed on that front.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v3:
> - Drop the br->lock around br_switchdev_set_port_flag in this patch, for
>   both sysfs and netlink.
> - Only set/restore the masked bits in p->flags to avoid concurrency
>   issues.
> 
> Changes in v2:
> Patch is new.
> 
>  net/bridge/br_netlink.c   | 10 +++++++---
>  net/bridge/br_switchdev.c |  5 ++---
>  net/bridge/br_sysfs_if.c  | 22 ++++++++++++++--------
>  3 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index b7731614c036..8f09106966c4 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -869,7 +869,7 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
>  static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
>  		      struct netlink_ext_ack *extack)
>  {
> -	unsigned long old_flags, changed_mask;
> +	unsigned long flags, old_flags, changed_mask;
>  	bool br_vlan_tunnel_old;
>  	int err;
>  
> @@ -896,10 +896,14 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
>  	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
>  
>  	changed_mask = old_flags ^ p->flags;
> +	flags = p->flags;
>  
> -	err = br_switchdev_set_port_flag(p, p->flags, changed_mask, extack);
> +	spin_unlock_bh(&p->br->lock);
> +	err = br_switchdev_set_port_flag(p, flags, changed_mask, extack);
> +	spin_lock_bh(&p->br->lock);
>  	if (err) {
> -		p->flags = old_flags;
> +		p->flags &= ~changed_mask;
> +		p->flags |= (old_flags & changed_mask);
>  		goto out;
>  	}
>  
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index dbd94156960f..a79164ee65b9 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -79,9 +79,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
>  	attr.u.brport_flags.val = flags & mask;
>  	attr.u.brport_flags.mask = mask;
>  
> -	/* We run from atomic context here */
> -	err = call_switchdev_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
> -				       &info.info, extack);
> +	err = call_switchdev_blocking_notifiers(SWITCHDEV_PORT_ATTR_SET, p->dev,
> +						&info.info, extack);
>  	err = notifier_to_errno(err);
>  	if (err == -EOPNOTSUPP)
>  		return 0;
> diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
> index 72e92376eef1..3f21fdd1cdaa 100644
> --- a/net/bridge/br_sysfs_if.c
> +++ b/net/bridge/br_sysfs_if.c
> @@ -68,16 +68,22 @@ static int store_flag(struct net_bridge_port *p, unsigned long v,
>  	else
>  		flags &= ~mask;
>  
> -	if (flags != p->flags) {
> -		err = br_switchdev_set_port_flag(p, flags, mask, &extack);
> -		if (err) {
> -			netdev_err(p->dev, "%s\n", extack._msg);
> -			return err;
> -		}
> +	if (flags == p->flags)
> +		return 0;
>  
> -		p->flags = flags;
> -		br_port_flags_change(p, mask);
> +	spin_unlock_bh(&p->br->lock);
> +	err = br_switchdev_set_port_flag(p, flags, mask, &extack);
> +	spin_lock_bh(&p->br->lock);
> +	if (err) {
> +		netdev_err(p->dev, "%s\n", extack._msg);
> +		return err;
>  	}
> +
> +	p->flags &= ~mask;
> +	p->flags |= (flags & mask);
> +
> +	br_port_flags_change(p, mask);
> +
>  	return 0;
>  }
>  
> 

