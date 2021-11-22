Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A6458C28
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 11:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239228AbhKVKU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 05:20:57 -0500
Received: from mail-mw2nam08on2064.outbound.protection.outlook.com ([40.107.101.64]:18374
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236312AbhKVKU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 05:20:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc7vmsg4Ojf7Cwtl99uK6PFZwweQW8k+ClMq/PN7/hiFeX//Q2tVXB6XF4ff3W4Z/VONkDosVU15HEKwFlCe4f/PW8C4olgVC22C0n+x+H+dPElMoIzcSLX99RMsBK7ssaWMOT0wwCw/UetYdhZDvhEc58Ou5l8q4NG85Sc7NaiOvGk50JO2d5/BUX9a3yEd17CFBq7fngokeUR2tsnuCgo30O6MrQ5TmLvQs59+Jrz4Swhx6IENukT3cZr43CW1uvVNPo/J5rM/mnr0ZatQ7IJhrLG3Mkb4r2X6rmm/m4a82eB7cRsT6qOj8LmBxndmTfLPPtj3/pTwiooTroWa/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkqXOICDwkvy3Uv45WLrn0veTuvdTBs8UNmAEkNg4Rk=;
 b=UGvolmKirDBRtb55kkE2Yv8uJHXUDvWNUVnnbu3GcJjJhBqzeYtBxV/gzjoM42dUqTKaBE5nrG466MZRIbJR0c8PI92ZtkqFBsHoCb9YrmBY7psB02bxfCftcYs14t4aEfyotFZj4rJ/1tcMJjpdGj7Fwb70X5RD1klYdNhbqvL1n6En6m8sP4/9PNi5uMe3Z5mU27NJfYJubvDzRFHdAt3fkjwjtmKfecTMqiTwmUSMz/82XpcGcaPfoVG8KM6ylTW25obRBYf/APNelsbKZwZXp1246Ws6TbdUEOV4+MItrB77YviXlMGtXcf8sE2fIxrs81Uy1XJJ4xdiATj9LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkqXOICDwkvy3Uv45WLrn0veTuvdTBs8UNmAEkNg4Rk=;
 b=r/l+M3N+741p2oJQYbNRDztQO0qwoR9YyLJ9Dp5qoS6fRL+vxKSMxe+LmuL1UN4WR5crZG5KDBHQ6q9og1w62SkrCzsbq5dq8OYOhsLS3PzFiY/h2oUSgW6U21Owp2uRD4ADQoJw+ys9WayQhqFKNLlOf8vxRMt5Lu4u/p2grMX8zyxL1tYvdnbDFYbEVl25n1WQvh+fMe+zvv6ffqoiwbAtmxhQoa/KLs9yUZcvHIXJL15KdmO9lMwtowHEesnOZvkoGivtZwdhAbdUszMT/1ASV57W/N+AfHqWQQWO5M2wOloFx37h7iat2pgxeLUNmgFLYm2UQqthA6PPs99OHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5310.namprd12.prod.outlook.com (2603:10b6:5:39e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 10:17:49 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%9]) with mapi id 15.20.4690.027; Mon, 22 Nov 2021
 10:17:49 +0000
Message-ID: <f98615d9-a129-d0b0-e444-cb649c14d7ce@nvidia.com>
Date:   Mon, 22 Nov 2021 12:17:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] net/bridge: replace simple_strtoul to kstrtol
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>, Bernard Zhao <bernard@vivo.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211119020642.108397-1-bernard@vivo.com>
 <YZtrM3Ukz7rKfNLN@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YZtrM3Ukz7rKfNLN@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0132.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::11) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.23] (213.179.129.39) by ZR0P278CA0132.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Mon, 22 Nov 2021 10:17:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 575e1366-0d92-4b4b-01c0-08d9ada155c3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5310:
X-Microsoft-Antispam-PRVS: <DM4PR12MB53107AC70E5A8FDD345D4DC5DF9F9@DM4PR12MB5310.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uBiS6mk6pjlXU4Q5alX3RhvLbFqpArhQMQvB/79W1JtpTO0cdPI/A/cYo3DkJnlq/eDEoF4yf+QxvPwWwiBGqHUmCWoFHMJ1w6KnbcOvNY299SgxDuXc8e3XB7kKDfkKs3CCfNBjv0ewj08AwX/SOShXSvk1kpVQ04CUMJmd8IBVE0O8zZ4PhUKQup8ztx9T7S6QKhSJnBii0j5EIhYgmYi68yDlrHOqMBzc7Cev8mRQp83CE2io0FRRxe+i14bXSBcLDu4mLIy6EYLfvrqZybl4gZIS6R95SvdbZzx2rXZviqwJXnYyeooRRnU4ajmziatsGNqK2O+IVUNqs7Dahzw2HwmCtwcaXm7gefDm0Wnd8jYsWZgUkQUEiVFiNYUMX/iHz9B8vx5JsCp8Mk8O6xK3+0Sas7tkTUOFS2NqggtiVWW65wI7kNh1ywuElvQslEiR6IU/8HVKmKRPj3c1aXkykaOM4L3YPLGFClmZT7d0zxn7uE5S2dKXQ3XR96wtx+m+ypYirPP3RysqgNVf9MJTU/R/MMoQlrXyxY2MKqs4s22ybIT5b4GKO5r2PMatoBSot0TI2sDKcuOP8SJCJWXkn73ZbFyUW5PVKtCLd+/9PaH4uDKHWCtlhiJCdHNjZzueAaJIy9PpWoCOzj8w949O1HzF14/KQjxXGBR2/IDVuvOtpAViCuqbJJvJsMmqyXWvUwjCsUa420omsqjO2zP40oZs4PfFYOAW6Xl/GU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(53546011)(2906002)(66946007)(508600001)(31686004)(316002)(16576012)(110136005)(2616005)(66476007)(66556008)(36756003)(4326008)(86362001)(26005)(31696002)(8936002)(956004)(8676002)(5660300002)(54906003)(6666004)(186003)(83380400001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azRMcmorYXU2d0t3QnRpTHBsMmFYRnF6cHEwQjRrcG93YVdIVitKTmxjZzNY?=
 =?utf-8?B?bllXdWVDOUxmZW43SmFOU05WdXpFbXdwTUFwMTRQQ0lLZnl1UUd6TnB3RjBY?=
 =?utf-8?B?MUgzSm53VVM3WjA4VjNMRWZ1YWFsb3k5a3AvVVZPc0dMK2RUZk9qdVVKZ0Zx?=
 =?utf-8?B?bno2NEowWWFVZFBrbTJGWmJJeHViQ2Z5b0xrQ3o0V2U2eUs3UkQ1UEhGL0Rm?=
 =?utf-8?B?VitWb3V4ZW5CRzlLcU5lbDVFSnJqaEpBUHhqVWNFMURnRjA3NzBVbDhDRnZP?=
 =?utf-8?B?cFlNOTQ5MktTMnVXSEZNbEVxM1lRdXE0VnF5K1hWK0x6OEpzOXdxZjhKUFJS?=
 =?utf-8?B?SXJxcHE2VVZJbHlBWEhtTDRKVmFUSTJNRkR1NnFETlFFT3JGaFVZMGxWOXIw?=
 =?utf-8?B?RVFOZnlBNGo5V1dpUCtyMGt4WkVFUUNPMm5IVk9rY0FzS3BhWk1yUzVVbGhj?=
 =?utf-8?B?R0FoMWVJZDdEWC9tNVRRUWM0d1ZCQk8zK3RueTFyVlBjejVKcWN1OStrUWFS?=
 =?utf-8?B?SFhuYjVTT2JKNEEzTHZBTktIZmRLWkI0MVZMUUpGNFF3b0VmTm1CTzFuL3J4?=
 =?utf-8?B?ZnZhdXRrSW5ka2hRZ20wTCs5aklyeTdXNkdCVWNTKy91dzlUY1BkRDQ2ZW04?=
 =?utf-8?B?Tk1RSTh6SmJkbndseUtNWXU1NEFnUGluc01CaWlDMTNzQ25GZFV5a0NXMld4?=
 =?utf-8?B?SCt5QjVVNUE1R090SXBiaWx1endhS3RRVVVIYlIxNVZ6Vkd6a2xKZEUycHI2?=
 =?utf-8?B?S2xpZmNzclR3aWlSZGV0cjZIR1lYNjhLR0xYd3VJUjZtQ1JYTE5EazBCak1v?=
 =?utf-8?B?ZzhhT3lielN4MjhKakxjRXVuQnE5bUFxV1lQN0tRalJROTNpMGNMUitQbEpZ?=
 =?utf-8?B?VHhsVlNsVUxZQUcyOGJOSExoVXlGWVpwTGY4UTNwd05velVrMDIrcW5vM2RH?=
 =?utf-8?B?QUtZQVhBdWUxNVFuaEcxQ2NhbDhQbUZwd0twYjEvWGdPM3d6Z0hwNEg1UlM4?=
 =?utf-8?B?SElUcVh4M1FYMTF6cDNUMHVNcmViR3k2UU5IUlBhTzd5MWJsUzU3U081YUxh?=
 =?utf-8?B?THgyQVVTRVJoK2lXeXhOMS9iZ1VDNGhsWGlvRXpVV1ZZcW5sNDhhQlFCTW1F?=
 =?utf-8?B?aEtUTGgrd2s5QWZpZjZhbGRuWmpmRlNLWVpyVE5VOFhDY2FmRzh4VDhZUFla?=
 =?utf-8?B?cVk1ZFJXWCsrYzE4MGNRYWhOZmYzVlVrY1FyaXMya2ZmTEZDVGQwaWM4TW40?=
 =?utf-8?B?UGY4MUZ5eVhFWmgxK2VxVHpDeFdTY05WZHNjWEtqL216TjBidFdIRkhaVEdX?=
 =?utf-8?B?OURQVXd4a1NERWg1OXJTa0FieTJXMEtIOGI0U1VzNnV4L3dsclpJS0t5V2NX?=
 =?utf-8?B?b05MQ2phNWVKR0dzWDhzQVZsM0diTnZNblVyQm1XNk5mUTE2MUhIQXBPUWlz?=
 =?utf-8?B?K0Q1RXNFVDdXR3huMldDY04reXZsTkdsZmxzVXFzN0MxMlE1c3hHbG44NGlu?=
 =?utf-8?B?cHl3WW5iNXlvVGpnTm5iSXZPV2ZQODdvUEdZczV4dFkrZlVwS3Q1ZHNSTVBp?=
 =?utf-8?B?UittaXdOSHpCdkVmREFUL0xRUE4zTVpUaUtwSDhQQVdYRHcxam94eDJOSklm?=
 =?utf-8?B?d0xKUWtVc3BBNlZUNlk1ZlZCTjdNMllwa3V2Z2FPRFJkallCdEJHQXVZNldH?=
 =?utf-8?B?aW43V2J5c3plcnFtSGJwYjc4TFRyZ1FLWlU1TVdjU2lRWk1meDFmQXpwa01J?=
 =?utf-8?B?bVNpM0k4UkNtMmh1dC8zWDBaTTZIRTg3eWVDNjBhc3lXSjYvUXp0K1g5bHNJ?=
 =?utf-8?B?ajZ5YlNSTkYybE8vV254c3EyVUEzUHJnMnd5aGZTbUd3VjF2L05wdVhINWF0?=
 =?utf-8?B?RWFMaThTdGx3OUNVcjUwWDU5ZVVhS2JEdC9OejZic05FTGp0L2tnK3NQQVpO?=
 =?utf-8?B?Zi9PWXRFYnF2eWxoNktxZDYzdjlZa1F3Vm41dlVuUW5oekdCZXJXVGNObXFB?=
 =?utf-8?B?VTBvUDBvQXdaT3c2WFh6cVd4UzJUQThHWUl2WEdHck9DR0JLc1ZVL0FwaTdy?=
 =?utf-8?B?Z1NJczRCTVM2Sm1CMmcwT3pCWFZNNkwrV2ovVnkrbk80dnVvd3JhSXF3VXdI?=
 =?utf-8?B?VHhDYkxaamNwc2Q0bnFsaERSMVRqeWxaTGFsSkM1V3JXcUZCQ1dIQzRhK2Zu?=
 =?utf-8?Q?wTRqsnnCVqvJ+JZ6GVnJEs8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 575e1366-0d92-4b4b-01c0-08d9ada155c3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 10:17:49.2507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJZOft7BMBIi7DiNlIUuXU56axv9rrR8xWgivgoibPR7g0EAEj1jvyTSYUmXR6t5GbPrbmK7gtIjTNi/hWcu/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5310
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2021 12:04, Ido Schimmel wrote:
> On Thu, Nov 18, 2021 at 06:06:42PM -0800, Bernard Zhao wrote:
>> simple_strtoull is obsolete, use kstrtol instead.
>>
>> Signed-off-by: Bernard Zhao <bernard@vivo.com>
>> ---
>>  net/bridge/br_sysfs_br.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
>> index d9a89ddd0331..11c490694296 100644
>> --- a/net/bridge/br_sysfs_br.c
>> +++ b/net/bridge/br_sysfs_br.c
>> @@ -36,15 +36,14 @@ static ssize_t store_bridge_parm(struct device *d,
>>  	struct net_bridge *br = to_bridge(d);
>>  	struct netlink_ext_ack extack = {0};
>>  	unsigned long val;
>> -	char *endp;
>>  	int err;
>>  
>>  	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
>>  		return -EPERM;
>>  
>> -	val = simple_strtoul(buf, &endp, 0);
>> -	if (endp == buf)
>> -		return -EINVAL;
>> +	err = kstrtoul(buf, 10, &val);
> 
> Base 16 is valid.
> 
> Before this patch:
> 
> # ip link add name br0 type bridge vlan_filtering 1
> # echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol
> # echo $?
> 0
> 
> After this patch:
> 
> # ip link add name br0 type bridge vlan_filtering 1
> # echo "0x88a8" > /sys/class/net/br0/bridge/vlan_protocol 
> bash: echo: write error: Invalid argument
> 

Good catch, Bernard please send a revert. Thanks.



