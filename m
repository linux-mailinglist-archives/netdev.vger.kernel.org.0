Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BB743C517
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240965AbhJ0IbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:31:23 -0400
Received: from mail-bn1nam07on2057.outbound.protection.outlook.com ([40.107.212.57]:25670
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240931AbhJ0Ia7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:30:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGkVP1NVAI/Xrrzsf8B9el9sxtBcXvu1GUP82IvR73ymPQERulvVERRcc39t1RLHtjoMQTh5YeVLmSVy9GUSuKMMYnt2W8OVTbGtU73/Lb49ov9P39KqmYzLmqkIqF2G3IguTbF4Fn3TWTVh5Sa5v4S0OSIS4Eg3dOZcZQlCHvHa3u0ot5xcyACYApsGf1QFVXoE9kakUvhHJXagkmm+Jr6iZMF79e/nk7NvpI3n4qSWAFpTzs8ZW+yNuYXipBmBa8BAezuX1txGgYtJgLVxBdB6bfMkpb9PVJvJLLt0e7XqYIe/P28NaEujQf6MWYGTcN9bIeG++xccxsqAqkwK4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6a46uVT8Bio8SFbqQjnImN9PCAZsHT0n8TWtCtm4VG0=;
 b=NO4OZDEznY90/DjSbbqRSxfqcy4mAuy9yFCP5IRMtFxQDGUkx050xfReFSHxpe8TyEy7UCepLc0KiFAioGXKCTot2Jfx+PgPqQLD+nseSMdKLmEaFkyf6Prjh36Evy7Euh1y0YDZw6wQoSrpi4c5aaGFIINCmfKQ8NiVQB1vDoAEysREXd8tKltvzmbsk81g+3wqAHxfywxzghr/cB9Mdd3WzoGdLaxVqs6FcK0T5dAW4iOaIWByTmPiN62S6EIhNSIniJqO5MHdbqxDAgn3NifQorz4dOBk+0RuG84YZvOEqaxm1yaj6qAQRlD86UbmUmL9Q1oYSw/hTE2Xxk7kKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6a46uVT8Bio8SFbqQjnImN9PCAZsHT0n8TWtCtm4VG0=;
 b=azg2tMZFhmEkAix5ZZ5kPvp6cbhYh28Wz2NuJyYt5EVfBRkB8BPPjBzPW7xxe4Yp8qqdnWO3DCuUR/FZCFalKiAyQgV7qzz5ZmqtoXURxCc35BSCsOuKiYsl/0DEYJ5FBBTTulqUE471qoucvvyrnkWX6037An5hdClLTsBb8T2uo9qY3XoR4e3F92rd86pxwQPXRuJYVL3UTXIxVD+TjOGSTQfHSIaWKogfOeMo7f/ELEyMJ1NJua4xx8F57WGijIgztvARXeYR7on8nZ0K04/RAND412pPXYOZ0jAwhPN4PMRbROUftZyijKFcz7pEhISx6G7vWdml9c0aCjS2zA==
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5534.namprd12.prod.outlook.com (2603:10b6:5:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 08:28:32 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 08:28:32 +0000
Message-ID: <b73e4afe-07a7-08df-cc29-c2490265f2f8@nvidia.com>
Date:   Wed, 27 Oct 2021 11:28:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 6/8] net: bridge: move br_fdb_replay inside
 br_switchdev.c
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-7-vladimir.oltean@nxp.com>
 <YXkK5jp7FHwJEeuw@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <YXkK5jp7FHwJEeuw@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::12) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Wed, 27 Oct 2021 08:28:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79358c76-010a-4fe8-6873-08d99923c2dc
X-MS-TrafficTypeDiagnostic: DM6PR12MB5534:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5534BF3151684DC76B96E26FDF859@DM6PR12MB5534.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GDCAKO9rM+fW6sKtG2TU3cG7bS5qKCATDnhCzVrxbez1CrPY6q2rFsoxhDe0YAA8x+xoBYkVD/uIq+uKfwep3bnnJYrfsRStqIdDAmvzwkh6tY52j62dpRZ0+GtqIcpAMs/yPxaAcxROE/Z1sQ9GVo4m0VoRwrk18g8cVgRUBYPUcL5inLDTXokOT18wfXZwEA2m6KU0knKptLGW1Tqj5MZJOe5FCNSZWc3RQYANTfoHXvDNvXS8rm8xWCXM6Mj4SQ6vunbpMaMqSwtYDVKddNVMDslLbQ+SnrpvJ/LcO3rbKNoHrox6MJZrlWsrb5V4ad2ZpJpO2qbNIn6nRduxYXYrkFYImCbzyLNrA/8RaSfcoEhrxaRGOpprEX0ZtOKLl091AXRi+w6aAURbRPv885FJ0zwISGSHjn6Kx1Eykc/tPlO6xg/CLFrOV816OO64CxpH+0lG3ryNKDmz4xiSsrHU6pLZP1Tqv3kH4OVoQV0f6aDzz908v/vX56VlnPQmzmTPHPVBMIoMjhE9ifpgNWg8JJemeduyv7g3jhU1NgSaHkTAHnbYo3g2sYdr2T5dPU8XE2PxRGFxOOSSZO4JGnW+/vfe0ZDrbPYZYbcW6pXTJ5pNgiz7KkUucg9D5vnwU6BUl4bNVkuKI5+ceQYru7Lu5qrJarZsFA7dwMczv+ThBkyVxTRpMOYjaAV1D9GdsLiw0KMtPvEEHU0Jx7Ioo9zCR0EZ3iy9tatTDAlu5TM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(54906003)(4326008)(6666004)(66946007)(110136005)(8936002)(66476007)(956004)(36756003)(83380400001)(31696002)(6486002)(316002)(16576012)(86362001)(5660300002)(8676002)(508600001)(26005)(186003)(31686004)(53546011)(107886003)(2616005)(66556008)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGE1OGtkNGdCbDFSWHNyWE9vYnliZzVncSswYlNqMmc2MXJLQllXNFhuMWk2?=
 =?utf-8?B?WEd2YXhHVlltdEppQktjWkQ2cmFlUE8zVGwxaUVRdnkrb1JUV2lNY3pqT2pn?=
 =?utf-8?B?OGNDanQ2SkZ6aTF6QWtCYTdxcWtLdGg4bjlqakRCZWJUUm9XRkpvQW8vZk9S?=
 =?utf-8?B?MUR5YUYrcnVuRDNieVZPc3F4WWF2d0l0YVdESGZBbHhlMitLSjJUU3VhREhR?=
 =?utf-8?B?LzVNeW45RVUzaXd0N2JQb055Z09mRUlueERPSFJwZ0QvalhWcW9uY0xnZklu?=
 =?utf-8?B?cS9ZSTBmUXI0S1hxQXpQQUNRQVo3dTU3cG1FUHVsYk54cS9Pa3pPalpsM3RU?=
 =?utf-8?B?TEpYZUdxaGU1cmJHN2JvN3BMUjRHUS9LTE5Ib2lNWk1rN1VIWWtrQnE4Sncy?=
 =?utf-8?B?MWVDdjN3ZWpJTWUzTFN3NVhEd3RKdHY4N1IxVVJuS05tTkhUSVJDSElCS3lj?=
 =?utf-8?B?N2VRcFh3R3Y2WEtHTlYyVnFXeW9Ld1huRms5K3Jycy9QWW9IYXZFM2poZE1m?=
 =?utf-8?B?blJCazBNamZTcnQvaE83NlJ6RWNmMCtiSEtFVlljL01YVkNDRU9ldmdmSGcv?=
 =?utf-8?B?YTd4ZU45azNIOEh0TVUrWk8xSHp0NjFCRWE5cnVVRnAwendWNjlsLzBPTmtL?=
 =?utf-8?B?Z0F5eml6d0NoUnUyL3lOdEZVZFB6dUZFZk9lWVZFUWRLM3NoT3dvYUlheWZK?=
 =?utf-8?B?S0YxZVZhYVFHVnZkWnJ6ZlVhaytUeHhqemdpSy90RnZUVXpiQVM2Z0ZWTnpq?=
 =?utf-8?B?RlZLMUtSSDRCa3ZjOUliNmpoYnJBL0pPNVdZV3JNYnU1Q21HaVYzNHg0TTQ4?=
 =?utf-8?B?VmhGWXFGRGNnZ2RkWUt1UDNJNVRxbG9STTVudGluV2hDUlFKMHpUVUMwM2dw?=
 =?utf-8?B?QWh4cDRyd3lLZkJqb0FpMWpIN2JNQ3l1VTNQYjhLS2lScVdMVVdJN0FJdEt0?=
 =?utf-8?B?a3c2NFBiS25SVkR6a0R0T3cwN1VvOXViTGhsNklyWDBFS1JwWk5kU1lGYUVX?=
 =?utf-8?B?VFlVQ0lNUUpiaVVaUTJ2eVZUQkJtVzhmcWlDLytZN3ZlYVpWMjhRRFA1bENO?=
 =?utf-8?B?ZG51cjNaWXVWSFRZeEt0WWk1L05GZW0ySEJBNXhYTkRKbEpkSDRnOVo5R0Zq?=
 =?utf-8?B?SVNNdTVrUnQ1a0p6OFFEYmNaeU1NVkREYkhjSytUOFRkLzk1UVpweUZxNTl3?=
 =?utf-8?B?V3RETWtFY1hUb1k3OHlhcVpVS3JUQ0xXYlUyWWkwZnpsWTRna2xRUnkvY0VF?=
 =?utf-8?B?WWszTHNacmRoVUpBU0kzMk16RkFEU0xXRjIyV0Q0WUJrYU93RXhqRFByamRR?=
 =?utf-8?B?bWJWemdGb21lRStyZFl5Q0NiNWlvKzJMZVg1Vm8wWE1WcGl5bktYZC9QTXNK?=
 =?utf-8?B?ZXRCa0FMVS9uNG9MQTVnNlNla2tiT3BnbEpsNGRhYUxaNmNsaC9sQmtkbXZF?=
 =?utf-8?B?QW1YM0xyeHhNMFZnTkpUODRpUkpZdU1XR1FMbmxxQlptNVVicVJ4QkNyZzhy?=
 =?utf-8?B?U0t0bWcxTmNzcjZCOGgwTDdDb2h0NGRuV0xnWFQ4THlOVzljNWVzdFBBR29z?=
 =?utf-8?B?R2kxM1E5N0plWHJGb0dSNzZnZTlNWjJ6Z01kbE5kNkhMeml2RVYxaUR6aDUz?=
 =?utf-8?B?bHlBazVtbWRvOGFSN01odjk5dmRFQTJqSGcydEM3cFdsakhYY2NobUlieGhw?=
 =?utf-8?B?c3lFOG9hK0lFaTBPY1hEWkV3eG9GN0xja1A5bzFraUpKd2wrVUJ6QmRwYWZ4?=
 =?utf-8?B?dm5BSW9LcjMyNUdTL21uZ1dJWG1tcDFIU1JlQ0lyZXphN0hnazdLNHFBRDlt?=
 =?utf-8?B?d0hDQlVNaUs3eURwWnAvQTlFYzM2RDJJZGNIdXllamNBSHZMYmVSU0lsK2Vz?=
 =?utf-8?B?ZUNWKzR2dnBseGVIR0k4OGt3b1BUbExwd0Nld2NFakN0UVBleDdiMzBEN3VJ?=
 =?utf-8?B?bXFlblM0UG0zZTRhd1ErdElEbzl3cGh3aDAxRlBtRkZkc0JUdFB5NGxSR0pm?=
 =?utf-8?B?bXREYjYyLzlvdytGcDB2RVdYWXVrMzhDemNlZ1UvRVlZNG9NZlJFVnJvSUEv?=
 =?utf-8?B?cUNGRWVPZlJuT0pTVUlzbHBDOGNTdCtJOXRySXZLM2pOM1VUQ1VvczBISzR3?=
 =?utf-8?B?NkJrTC8ra3hWWmFZWnB3Ymp1UDNKa1QzbFlTRUU1RzFDa0twdTJkUExpbTVM?=
 =?utf-8?Q?tq+XOsLnLOoheKxg65vitr8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79358c76-010a-4fe8-6873-08d99923c2dc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 08:28:32.4264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32PtFsA2j8B2tnHiiPC+DJdcLDd0+MN4JVSHOJV8hFEkLqqQ8NPv1R1gTjmjkID8YMnAbfN8PKFKm13rG7RvHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5534
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 11:16, Ido Schimmel wrote:
> On Tue, Oct 26, 2021 at 05:27:41PM +0300, Vladimir Oltean wrote:
>> br_fdb_replay is only called from switchdev code paths, so it makes
>> sense to be disabled if switchdev is not enabled in the first place.
>>
>> As opposed to br_mdb_replay and br_vlan_replay which might be turned off
>> depending on bridge support for multicast and VLANs, FDB support is
>> always on. So moving br_mdb_replay and br_vlan_replay inside
>> br_switchdev.c would mean adding some #ifdef's in br_switchdev.c, so we
>> keep those where they are.
> 
> TBH, for consistency with br_mdb_replay() and br_vlan_replay(), it would
> have been good to keep it where it is, but ...
> 
>>
>> The reason for the movement is that in future changes there will be some
>> code reuse between br_switchdev_fdb_notify and br_fdb_replay.
> 
> this seems like a good reason, so:
> 
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> 
> Nik, WDYT?
> 

Good point, it'd be nice to have them all in one place, since they all deal
specifically with switchdev we can move them to br_switchdev.c. We can also
rename them similar to other functions in br_switchdev, e.g. br_switchdev_fdb_replay

Thanks,
 Nik


