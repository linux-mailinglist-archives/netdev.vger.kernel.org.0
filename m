Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501C443CCA0
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhJ0OrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:47:16 -0400
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:64609
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229618AbhJ0OrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:47:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dks0ahD6pC3lW4C53w2a5aCdVrfJi4QbtIkEv1cPvryLfB6qGMaS4qMIqvpzAD8cHd/Ht/ik8AAx8SE/ttDHpXbjMO9q0YusM4vkH/9J1eCUyCjaFBLenb/8bAzY4KyEfUzPIruLq9p4WHWxxuGFy2phMp17kSlGuCzIdXg6iDm2XkOnWwY/u3tfafWqpKHKnIWLlmIN42IaI61PIyGzleSNOLcdRvWZ9rcTSsH6ZhER+9i+FFcB18nWIqrGU0chzAbDUuI41dRZJufKGDZqtTGX7QyEJ2So14H7rabNpjR1HfotcmMZf+0OOZSvKCD3JIkstbI5rhZ8Lq+gq7ItaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=48pXJ4e4aRVSkFkxlC9OCuumhcx2SAQCkIFKtaPZ3qo=;
 b=S/0XWH1bZIk3xpPHUB8AZFVck8Vd6UflDZ+xuNlu88i/FK2aiGIx37q0sTLoYWEQbh7dUPIK9Ej/JYpcCCV337XapXRnf2Zc877MOc2uMpMQfRE+jvK9/ga95u01zO5eEWM4pToOX8sMHuNQLSedefShgqyQpRhqViiznZ4WPZWFZ40Q7eA27zMdp+wrzuE2XL8gdfG0Qw0EXse6yEdh/jcIXl8H4il0tbilfO+ZT/RoWxvSMQGk01SAx7RDcPZAy9boUoXF+GeilVE9M0+D3AhtKRUZyX8au2nPikqAxD4cMbK7lcbjVBvFzEHdDg1kAxqvpZ9VtPS/oQv1GgAIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48pXJ4e4aRVSkFkxlC9OCuumhcx2SAQCkIFKtaPZ3qo=;
 b=oadHTcdjSXaDokU8OC970u9AAjnXYlscP1p0rploWDXqn7xCzTUAnR8RDkk2Q49mssr1GyXuhT5VxQoEdIRWSdkuM6CGyBFtwzi/p91LRLKrEZYrDPnpLabTYbS9z45G4hz0423OgMBpKpmtYnplbPqbk2EjgbGUMZ7Hm5r5im1y3L/aBljJzgGVkjWqiUeiVE93P3YkkPdLaJt+34uUJBa6oSTqVdySnA78vEwnU04soNMBJOYHg8Dlphnft/mUnEqqgPT+KfCBy5/f3JKnwgeRD3d1Qdp93mODBrLHQw6K2frsL+0HYihgpygxwGTCHx3N9Y9kvV1vMEKM4glWcQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5429.namprd12.prod.outlook.com (2603:10b6:8:29::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 14:44:46 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 14:44:46 +0000
Message-ID: <c9da923f-42b8-8771-8867-9ea35f10da91@nvidia.com>
Date:   Wed, 27 Oct 2021 17:44:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 0/8] Bridge FDB refactoring
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, idosch@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, roopa@nvidia.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, olteanv@gmail.com,
        jiri@nvidia.com
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <163534560950.729.5232614315067836341.git-patchwork-notify@kernel.org>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <163534560950.729.5232614315067836341.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by FR3P281CA0051.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4a::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 14:44:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf39b1e9-7807-446b-6eda-08d9995851ab
X-MS-TrafficTypeDiagnostic: DM8PR12MB5429:
X-Microsoft-Antispam-PRVS: <DM8PR12MB542921632178ADA167A33EFEDF859@DM8PR12MB5429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8XzW/wFvKfzi/aAvXzH0cIIQ3jXEck8WTwwLQqKRdDJCzNkq1VWOf1wdNIkM2UPqL9WtEbNOHRyOLozTjdT4jMTvp104Ap+PyuqJ1Dn9rjvrZp3L9mlSJoAclVKiT3P+gISTm41NHQuSjdXbixUpQPBZqhnd5RYhrxoh0PWEjGYmCLXHLgdGosv5AstU7eSIvS1b4PIZcwUPFXiwp9LWW7q6jAMApqT6EZzMSDT0Gn7kAzPtp0K92PtpL9bY0A5EdbWGEbb8gEwZwe+zDKhZn5p/yYEev5+aouSqXLQdcbUeQhcJvvo47N7i1xGNZ+M9yscvE19FAiz2DUaxUN1dyfHB9TJMhnfxIFdj0bykm2YI+W02c5K2DJQLWtro/vJUEMupkZJdcS/xElpzjnphjmaKeKPQfYxvAttCiv/UxrDUZ9fMlL/nZnRXTqB3vGZlE2BZv/AT/pv3bnRc8iBcGvKkdZgj2B+6FvV4xYbzapeMF0sBZaqkSXstbU1FBOx0aK6qfP/JjG30AnNHvjitIz6igqQKKIYxZ3i0e8UgKFwJANW36B+y3nIKNb4F3yb2XnfcE6K4Y1zkAHCYHFg5A/sUuklWaj4fzW9mpANLhnMW1aalfEaEWikqR2d8JkBJhdulsDS9L5/526fKblLkPyP7ZiD2wHCH8iq1VVVLbUt/V2GwytGNPyTTOm2iVjRX49JQktADKFFv82JCiI20pLKuEKzCEAFOE25pCGgz4hCOxhatcvZLgBVj2nV0OA1vxqape86Qj8A7hnPGCgesggKr4W5BphQ2YevvmRiHjgQtCIXkxYRoOcK+ZStm1ijJ5V+abObk8YXuM1lgGxnBWBrxQJNIq43RQF+72hDka0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(86362001)(31686004)(6486002)(966005)(31696002)(5660300002)(66556008)(107886003)(66946007)(6916009)(66476007)(6666004)(956004)(38100700002)(16576012)(36756003)(2906002)(53546011)(2616005)(4326008)(8936002)(316002)(508600001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2lLaXNGNExFMWdwYXZlTW9CbE4xc1JpZUtiY3R5MGw3MCtEMEtaZUJhMEF0?=
 =?utf-8?B?K0IxVHM2dzJhanpZWmRiaHJRQnFTOTlNM1lnNFAxeE14bzZVMWI3aVREblZQ?=
 =?utf-8?B?SUsrM3c4dzIzUjl6S1Vlb1NMRUc4anFPcmRsRFdiS0ZtWmRQcTlnNjlJV3ZP?=
 =?utf-8?B?WUo1Q2J4YzQvaGRkWWFFU0ZGM1VDSWs1ZmI3T0xoZk9ucmVjYVljVnJJZDNO?=
 =?utf-8?B?TUlDNWJ0Z1p0OENFVDFiejY1U2FjSWN6cTh0b2FCdUZrdFZHaGg0QlVhWW5P?=
 =?utf-8?B?NHVpSytLOWc0MzJZTTFQWVJjSmxlbTFrNU1wOW5WOTB3UHZlU05ZSUwvSlZK?=
 =?utf-8?B?a1ZEN0lTYlMxMzdjSlVVTW1YK3FmT0JSZ3FVQW5FSXJSQ0hBUEVrVElwOGt6?=
 =?utf-8?B?eEFCVjIxdGFVMnZMcXo1WDZDTHdIcVBTMzM0Q0hueitmb2RReGVvK09ZQmpV?=
 =?utf-8?B?WmhqM0lITlNGMDh6SGhVZHQrZ0s0ZHVVR2NIR2dTMGFpc3RpZDVyYmRLdkFZ?=
 =?utf-8?B?NHltaUtSQXpnazRCRlkzNmthbitjdVl1ZFZxVnVwNmU1SmU4WUEwTlZ0YVQ2?=
 =?utf-8?B?amxuUHczR2gyNUk2Ky9vMm9xbXczeDRzK1k2UGNseWM3Z3JyY1ovcXBodS9j?=
 =?utf-8?B?cDhjS0JUZGhZelgwNWNlQkdPbHhpSUIyaGJodWw1a2o1eGhxZzVKMUJoYmJk?=
 =?utf-8?B?dmJXSHRXSTZLTFlodmI2Tk5FcCt5NG5FVDFaRTZzalUvYU1iQm5Yb2tJWmhl?=
 =?utf-8?B?Z256NmxkL1cwU1ZvdzZKSW1KVWRUeVVQUSs5YVl4UDlxOEtFVXUyTnExbVpj?=
 =?utf-8?B?cEhQM2hJcWZYSlhqeEtqbUtwWjJBU2piclh4WGxQZktWMWJaR1RkcDBnVTI5?=
 =?utf-8?B?S0wzVElCTWU4VHBtWGV2ZHdLWk9aMkZzQWFLcTJTanZHNFhEUGoyR3A5aDJ2?=
 =?utf-8?B?NVp2SG5aSExIaGY5NXlSdW9YOG1IRkE3NE1LZy81WERJN0RmNjBpQVFFTHlM?=
 =?utf-8?B?Z1JFN3ZlT0RadGwvZnpybU1QU3V0eEkzcnNNYk1kSkFxN3YvLzYwSjU1UG4y?=
 =?utf-8?B?UGRRbGlEd0hwTURaK2NHY2pJZDAwYmlpeXpKd0pkWVhpUGtkazNWcDQ2NzVt?=
 =?utf-8?B?bXdQVFlMajQzSnZDb3pRUzRJOExyQjNtZGozN05hTEdQV1JiS2ovbEsxUnda?=
 =?utf-8?B?Q3dkZHZmYjk3bVBXSUpjZlRubzg4am1ybE5HbGNSMnZLK3dPSlpuUGdneWFm?=
 =?utf-8?B?MDFKMy9WSmxwRitERk1Ta2pnVW51RTFFaHRCQjExS3pPTE5ub2VwVDlXc0ZC?=
 =?utf-8?B?b1o3MmZNS1BzazVlVDdhQ0hPQnZ4VVFaaVRoV2ZRVmhkQkJPRkdrQ0FDdHU1?=
 =?utf-8?B?TndvNUNrd01uL0xlR29hKy95bkpFU3MxNSs2Rnhkd1hqZytKZjBQOVBKVGp3?=
 =?utf-8?B?cHhsSUdWM2Vxc3pjc01LNFpYSWs0SU9UVEtHUHlzMmdqUUFMT1JnemNIQW9Z?=
 =?utf-8?B?NXpXUE8xanZOLzFuUU9ONDZzUGJQbnMxVDZGb2dHZDFNNXdYUUJxWUJYc0xG?=
 =?utf-8?B?NUNOSzNGeTVsVm1MS0w2bDRuek5mdjk3SUw5ZVNtUUJUYUpETjFyQncvdy9W?=
 =?utf-8?B?OEN2RHRGZ1FydzVnMkMwTUw4L0NQcGp3VllwazNqZjF5OXR3MHhhYkQ2Z2Qw?=
 =?utf-8?B?UnpuZytkZUpVSHlTQmx2TDFib2Q5U24relZ3MXQ2bHZ1UnlGcFBWcTcvMXdk?=
 =?utf-8?B?N2c5b2ZJQTdGcWtQMldiK1dvcDlya0xLZmZ6NnU4QlhRTzdZRTBROFhtVE9Y?=
 =?utf-8?B?bzJvdDQ5dmwxald2WFFKZXM2Z2hCazhhdisvUTF6SVpYSFg3Rm1zREFVeitH?=
 =?utf-8?B?czRnMmxHN1k0SDUyalpiVDJNazhyNlZXZmRLWjh5WDBpd29pNE9ZcEdpMUdh?=
 =?utf-8?B?andHZW1WZ0NISm45V1NwaXB0SGhIM0hvYXk1L25DZU94UTVVQyszRm5KU1hj?=
 =?utf-8?B?N3EwYTFYK1paeU9CMzEzS2haODRady9sU0YvZURDeUJhZ2kvazQxZTcrNG1X?=
 =?utf-8?B?aWdpbjNnWUQyeFo2QlV6Y09aMXN4WUQzSWhlVXFsOUtUMnh0UUhIQ1RleW5S?=
 =?utf-8?B?T2hFODBINmRFejMwaE5lck5PYlNwWWtEbldnOW9jdHBvQm1BaFJPeTA0b0Ra?=
 =?utf-8?Q?XaT5B2vMRc20HsmqC3hAyGA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf39b1e9-7807-446b-6eda-08d9995851ab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 14:44:45.9023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0evbCB9XOwEkDVIPuDrvd8kmYDoyQEACGxRAip7Rkf/0jHQxfV0ZFrQ3rFL8Wkp0KxQxDqYXK2Kyi52f6KOmzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 17:40, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Tue, 26 Oct 2021 17:27:35 +0300 you wrote:
>> This series refactors the br_fdb.c, br_switchdev.c and switchdev.c files
>> to offer the same level of functionality with a bit less code, and to
>> clarify the purpose of some functions.
>>
>> No functional change intended.
>>
>> Vladimir Oltean (8):
>>   net: bridge: remove fdb_notify forward declaration
>>   net: bridge: remove fdb_insert forward declaration
>>   net: bridge: rename fdb_insert to fdb_add_local
>>   net: bridge: rename br_fdb_insert to br_fdb_add_local
>>   net: bridge: reduce indentation level in fdb_create
>>   net: bridge: move br_fdb_replay inside br_switchdev.c
>>   net: bridge: create a common function for populating switchdev FDB
>>     entries
>>   net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
>>
>> [...]
> 
> Here is the summary with links:
>   - [net-next,1/8] net: bridge: remove fdb_notify forward declaration
>     https://git.kernel.org/netdev/net-next/c/4682048af0c8
>   - [net-next,2/8] net: bridge: remove fdb_insert forward declaration
>     https://git.kernel.org/netdev/net-next/c/5f94a5e276ae
>   - [net-next,3/8] net: bridge: rename fdb_insert to fdb_add_local
>     https://git.kernel.org/netdev/net-next/c/4731b6d6b257
>   - [net-next,4/8] net: bridge: rename br_fdb_insert to br_fdb_add_local
>     https://git.kernel.org/netdev/net-next/c/f6814fdcfe1b
>   - [net-next,5/8] net: bridge: reduce indentation level in fdb_create
>     https://git.kernel.org/netdev/net-next/c/9574fb558044
>   - [net-next,6/8] net: bridge: move br_fdb_replay inside br_switchdev.c
>     https://git.kernel.org/netdev/net-next/c/5cda5272a460
>   - [net-next,7/8] net: bridge: create a common function for populating switchdev FDB entries
>     https://git.kernel.org/netdev/net-next/c/fab9eca88410
>   - [net-next,8/8] net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
>     https://git.kernel.org/netdev/net-next/c/716a30a97a52
> 
> You are awesome, thank you!
> 

There was a discussion about patch 06 which we agreed have to turn into its own series
with more changes. Vladimir, since the set got applied please send a follow-up to
finish those changes.

Thanks,
 Nik

