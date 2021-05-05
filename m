Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DE0373544
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 08:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhEEHAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 03:00:09 -0400
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:13408
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229647AbhEEHAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 03:00:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxPpOx3lybsKAjchAQLjNNoyFHget8gEL4ucbgZJQfzKgxGZcdiVB7HD6/GmN+B4sly5Z9vRpMQitfvU2tbtKqJzgvOzwHGxIWi3Z0UyaJK08hIU4xmtP96SaLeA8uqengPD9dpvAo+fQH8CBzXKGbePtCdry2sm++vx36hXbPD7+XVPEKte7hY8dUwl1j5bMDpKW44XzITrsYvJQPxbHFCOPprhTjnLGduUwanZH97eHZbx9RinUlThoQAxnHl2rz/Ie/zqP4xAm/xigO9TZNHEJeja5s2GaF1zZuPfxUlUEdaoOmnGZIBGBfDtwKYbntJdTqCvdZ7LQmtIGhmOWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJPQsgqSsyU9F8LNj0Jm/Hbf/xDkIyb1qqa7PtUw34s=;
 b=NId7RkNlTxnqGtpfbJX8pBj8u7uJoQjM0wytfLFkrYk9BxIjsyauOCepjipLYECDAR/SbAq34FDo+OfFdFXYsmMYdQAeGW5ygUG9OO7A+wEdfccgP33ueuCJB7FEcJQtAnqK+yJVSeO4OH60N8a42kjeFe6aZmrkW3y91r5Z0IOAY7cQyZs4CU8Eqi84o0AIxLx5LsLthomg0QI0k6akUxeqaMfUuUNFOmbredd6C8G5JY0Umr49M+GDt1oXEEpVLltENvirVuwrYq6Ec5iQpT7vUbv/KV0cEDcrZ9Hhhte869uxG/GqOD+zrolzdvmxn47TNUXW8VHCVAr0zgpoFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJPQsgqSsyU9F8LNj0Jm/Hbf/xDkIyb1qqa7PtUw34s=;
 b=CGtiF6idCjcY2ISsyMtKq3cI+EfETdmz1cRiByUNMzLUA1gGQ+bqKy4lRMS44SMKJwO7PE/ixlSsp8BNGzJjgIHNzTbOlkq6ik+Qx5fIC2ioFoHGRFejTw6Uzzloq57z9KckbO0OacJEiVK0PXlxQCZmRv/7gFTkYoEeJ4n3h7bRB2MXzYJbv3aVv6t3ZszcQqEhdKvT4wMbXk/q9FHiKWDcCyQI+gaYTZV8Y0bnmjnbpPaEJy4d4tw+gaXTxoRY51d8M1SB5AcJjvzpoplnzAnw+OtQFMNovyk2bs6fi/sz8j5NYVKSLt5yOLnHkv6wxnLvgSAD+Qz9OSDtWf4ijA==
Authentication-Results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5247.namprd12.prod.outlook.com (2603:10b6:5:39b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Wed, 5 May
 2021 06:59:11 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 06:59:11 +0000
Subject: Re: [PATCH net 0/6] bridge: Fix snooping in multi-bridge config with
 switchdev
To:     "Huang, Joseph" <Joseph.Huang@garmin.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>
References: <20210504182259.5042-1-Joseph.Huang@garmin.com>
 <6fd5711c-8d53-d72b-995d-1caf77047ecf@nvidia.com>
 <685c25c2423c451480c0ad2cf78877be@garmin.com> <87v97ym8tc.fsf@waldekranz.com>
 <82693dbedd524f94b5a6223f0287525c@garmin.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <a610666e-c7e4-28cd-ab89-fa2e02ec31de@nvidia.com>
Date:   Wed, 5 May 2021 09:59:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <82693dbedd524f94b5a6223f0287525c@garmin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0070.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::21) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.230] (213.179.129.39) by ZR0P278CA0070.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 06:59:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72d0c79f-7124-4a2b-c07b-08d90f934918
X-MS-TrafficTypeDiagnostic: DM4PR12MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5247613B3D4BEB390C4E13FEDF599@DM4PR12MB5247.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qGAe5C3/jjkrbCar4HgR5Cyv6Ox9j0aZPmrHSeJ0L3lVvBt+LUgHxMmOlG7acWncrsXNtizgC41MewothVrY/De+U5v6PlMaSmEjX+YQPjYjiGUTGFMcFNZbl49weo8q8Na4+jm2/7ADwhSAbZr/6HEhndWI9tXM7R6VXgwNVrbfaMWifzEF6Dqjb7ypQgYUNlg5jAPhDafUtolJXucPD90XSuaGtiPGcGyAMXamMAR2kYykzeqUUFL2TUbP91gHIhekEPpk+qBdFRu3I5gd3y40WS+95Z58MV20cRpyvHUCkgiSskkbggR3QEy+nDziI1A6EhyAe5r5del24w3Yx5ps2kCpD4w+WK2aSgxUfodJnXqbjUFWcybeZMcRESl9SA/6m34PML3BqrnlWjYTY7b1Am6R2ADkzaY0ZOhVPVMGfjTcTAw9oIvl191MrLWmniGuKe8E4MzEIjMoPSslYZ2hzb4Jofvp1G7wTJ1/OJ5h043swonzHob/KtdBqpx//95AF6BaZ84PNbeeY/7ucl+enGtQom32nYAh+05z+dQ2DfLm1vLfLL6CeUxzzQ4ztdaH8j813QWfwvjRI1mkfoD3QsrkbMQGWgZMVDnan1tQfUlsLb/vj0JqKDm2k5dxa1YXsLJp8iN+SNvg8UHUoo5GO+g840RUue4iW3olVtIR0Pur4NUiOLWJFjdYpIzfgg/2oBXmNDdQ/iAro4ttjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(86362001)(956004)(36756003)(316002)(921005)(66574015)(2616005)(16576012)(31696002)(8676002)(16526019)(186003)(31686004)(110136005)(66476007)(66946007)(66556008)(5660300002)(6486002)(2906002)(6666004)(478600001)(38100700002)(26005)(8936002)(53546011)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVpwWUpvK1JlUjZmRWVuSjd2NDRDUXdNQkFpSmhjY3JWUlBrRjJaSXArOGZk?=
 =?utf-8?B?QW5lOW5oSk9ocm43NFRNdUpUeFdSK2xLbHowNUMwQlEyR1FhSmN0Z2E2Zmsy?=
 =?utf-8?B?QUFFRVU3Y0ptMHpuM0dFZzZSRWovdWJKV1pSTGNyRlp5TjJWOElNWkZXZFBV?=
 =?utf-8?B?Vk1UbS9tcHpid3ZQSmVYRnc1Z1NNWWJzWFZia3RtbXIzcGRuU3hvM1FpVllp?=
 =?utf-8?B?U2N3bmZQUWFra2I3M0MvV0hDWTVZcHdPdy92SDNuaFFRNitRazREaW80SGZL?=
 =?utf-8?B?S1VOYTU0bVB0bmJzYzgzTys3U3JVbmgxbGYrenF6cGhBbW5tVDR0azRlV2RW?=
 =?utf-8?B?ZTBXNjl4VDNoSGhMMVQ1K2ZsZzRWTlNmY0hOcmZhWFkzZjBySmVETFFqSEZo?=
 =?utf-8?B?U3VXOHhUNGdTamo1SU53UUdFanRsTE50UU1vbnF2SmRLV29YTVlLZXo5eW9B?=
 =?utf-8?B?YjJwMTRwRDhXclZzcUVCMDFFZ0thdFZReWlKcGxPbXpqL0VGb0g2b1RzeHZi?=
 =?utf-8?B?SmliOUNqSlJ2UVlnNlpiZU9lOGpJSTVwRGhQcmhrbmVvcmxsdm41Ykc4VUwv?=
 =?utf-8?B?dkZlWEM5WDVGZWIwWENJUnRIN01HdVJMdUtETHNIaGVQMWVrZFc0eVlDYXh3?=
 =?utf-8?B?YWdrUEJhM3pOL3ByaWtMQ1p1RmZHdU5zZHByZDF4K1FzM2hEZHpOMjFmUDg5?=
 =?utf-8?B?dEpLUFZXcDhoZ1pVRnRaNDlCQVZRYWNtNmFuejdlSlFKZi9oUStjOUFrOXp6?=
 =?utf-8?B?MVgwMzZOdk5UTDJZUHUwQ3lyaVVNcUtLNGtwUWpSSEZVQ004ckEwT2oweGw2?=
 =?utf-8?B?MkpPOVlWbDg3WmFvcmtPWHZWN1NCak43VEh3enBQTHFSVmxIOGFnNDYyYi9Z?=
 =?utf-8?B?bG0vcXpHc0VKVlF2Q1VxamtrNWpWNGJRbzllQVY2Z2c1MFgrUnZLQ3dLdUl4?=
 =?utf-8?B?TExYNDJrb1AxWVFjNUw4bm9BWmdTSGpOUzZDWDExaWVIV3h2TW1kQXhqVTFD?=
 =?utf-8?B?SjEzYUd2ZG1KdzhHUGhSU3FGT2R5eGoxSVVkMEg3eGRscDhJWjlmZEdLNHlN?=
 =?utf-8?B?eVVYeHMrSFlueW9GdjhGQ2VBcUJ1QW9ycjg4b0M4ZHZVTkRDSitRMHdBNjhK?=
 =?utf-8?B?VDVYcTBLcWcvZWlpMlA4WS9iMnFqT25FTThlazNMWlhMckx2TzdHTE90cWlV?=
 =?utf-8?B?K3QyRkxtSWUwQnM5Tzd5MmVzN1VCT21Rd1NXem1wTUtEWlpSeGRXYUtCNFZM?=
 =?utf-8?B?NG9rU2hHNitPUU9xSTc4M2hKVlRjUTZIVmhoS3laU2ZwVUdNVlFyaml0Q0VX?=
 =?utf-8?B?SjBKV3pHOVNaVTVybTdWRnRwanYwU1BrVjBuTVpFSWdaRmk3TldmUnZzMk9L?=
 =?utf-8?B?WXJxYVAyQ1h1QnJZcWp0WEF2bkFxVVJMZU1UWEx4Qkw3czQyOFVRK0ZtRndP?=
 =?utf-8?B?WWZOZjFKQ2VkY0JFbURYNk05TlVDSWFaRjRsOHZpcCtvUktwZ3h1NTZ3VVU1?=
 =?utf-8?B?TnczVGNsMmx0dWpwT2lIbEpVaklCcU1ycGFNTTVYYktpMzBuQkRMZjkxTVNW?=
 =?utf-8?B?TWlWSlNvZXF1MXh1SXU4TUtmOVcxM2pncFJudituK0l2QnNlNVJEZUhCZVNF?=
 =?utf-8?B?cmhwRUxuY2RGSFdGSkFSRTRXUDI1c2ZDUjdJS0xGWWdFcExwUXo3VXFrVFVX?=
 =?utf-8?B?a29xOUF5N29UQXdoRTh3MFJFODY3MFphdnpPcXU5Yjl6M21ZdUdmbGRMdFB5?=
 =?utf-8?Q?akoX/BXgbJcxviVeTVPz205W12H4BtwwGr688dr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d0c79f-7124-4a2b-c07b-08d90f934918
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 06:59:11.2605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sut2f9K360sXqB6CuWwebdMRTnyK8qPGoaBnbw6sN1PYU++EJHQa4sEKu7n29Mci0NTDfn9A97mnJd0aBLBJmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5247
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/05/2021 02:26, Huang, Joseph wrote:
>> If I may make a suggestion: I also work with mv88e6xxx systems, and we
>> have the same issues with known multicast not being flooded to router
>> ports. Knowing that chipset, I see what you are trying to do.
>>
>> But other chips may work differently. Imagine for example a switch where
>> there is a separate vector of router ports that the hardware can OR in after
>> looking up the group in the ATU. This implementation would render the
>> performance gains possible on that device useless. As another example, you
>> could imagine a device where an ATU operation exists that sets a bit in the
>> vector of every group in a particular database; instead of having to update
>> each entry individually.
>>
>> I think we (mv88e6xxx) will have to accept that we need to add the proper
>> scaffolding to manage this on the driver side. That way the bridge can stay
>> generic. The bridge could just provide some MDB iterator to save us from
>> having to cache all the configured groups.
>>
>> So basically:
>>
>> - In mv88e6xxx, maintain a per-switch vector of router ports.
>>
>> - When a ports router state is toggled:
>>   1. Update the vector.
>>   2. Ask the bridge to iterate through all applicable groups and update
>>      the corresponding ATU entries.
>>
>> - When a new MDB entry is updated, make sure to also OR in the current
>>   vector of router ports in the DPV of the ATU entry.
>>
>>
>> I would be happy to help out with testing of this!
> 
> Thanks for the suggestion/offer!
> 
> What patch 0002 does is that:
> 
> - When an mrouter port is added/deleted, it iterates over the list of mdb's
>   to add/delete that port to/from the group in the hardware (I think this is
>   what your bullet #2 does as well, except that one is done in the bridge,
>   and the other is done in the driver)
> 
> - When a group is added/deleted, it iterates over the list of mrouter ports
>   to add/delete the switchdev programming
> 
> I think what Nik is objecting to is that with this approach, there's now
> a for-loop in the call paths (thus it "increases the complexity with 1 order
> of magnitude), however I can't think of a way to avoid the looping (whether
> done inside the bridge or in the driver) but still achieve the same result
> (for Marvell at least).
> 

Note that I did not say to avoid it in the switchdev driver. :)
I said it should be in the driver or in some user-space helper, but it mustn't
affect non-switchdev software use cases so much.

You can check how mlxsw[1] deals with mdbs and router ports.

[1] drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c

> I suspect that other SOHO switches might have this problem as well (Broadcom
> comes to mind).
> 
> Thanks,
> Joseph
> 

