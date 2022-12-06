Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FEE644AA2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLFRw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLFRw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:52:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60187209BB
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 09:52:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/KvGcJms3yza2KhduBRJ+HAIkcZHDkcUx1aDiZgF2an4wM3dnkSYFZs79u6pviTglG5sm+OacRoC1QQyosjpsoOByct1s/H7cx02W3lgmeqDlLISBM+kUgdf69zH7dQngV+9HHi3GhUiuJqn1sGPO+yVVDyeIZjb9kH/D2e5rl4AZcIfGguiO9d5D/tpJvkZcYnGdAVM28DQ/Kdx6xWSSYH0kq7fSU5runaLrlra+olTLkJzS2kdFAnRBgz0imNIhuPDxaUzud6s+3lUyqmz58SWss8duFaybj8LsKo+GWTVvvIypdaGNQZX5YY/8BO3xqEGL4/rg7NgTRcnjPnTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8W6u+aukd9izvKdLqsXktbhYW5YUbEK5mGKF/9oZISo=;
 b=Se7lq5PtTiiONCA3jQdzVEt/j/FPYEqIksgvoUJPoquSlAwVB+SCDhBDQqKl9A5gC0ajEeI6MrRn9VVpwLjrnqv3jW4qcAJZx21QcFYJBd6qPPesT1zxK+Fyuc/qfx1NWv7w1nA1MZoFozsTUiGMBUS54BwJWViBp+ZA4JdEs8dGAVnukv6/2VEYFZizjZBZsPAUPkfmQkQlbyiVjcrMnudnRIpXEJBvzHwKVDEtJdearHeoosgVTBim02fdN7Y+t8725ZRVF0ZGiRogP0C9O6CwcEbHVksb4vKfvLIxcL7H5dKVUeYB8TVjr7iWAK7WSw63JG926KsSPEcCBVfn0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W6u+aukd9izvKdLqsXktbhYW5YUbEK5mGKF/9oZISo=;
 b=Dq9ocd8CUxVwePhnjXzIxXVVmnWV0MiykLTtsoENZ6OAj9QNg5tEjKXN+mY6CF9MScD2rRkUJ0wnbUuKGNoeLVNe1Yg3vEpYgIgFGVQVzdSHUsMtc5xuqaYCP9sN5Ywi61Da+ZjC4Bd/PhgbxZkWCQV71vf2mr8JKiRGk2IIhSA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 BL1PR12MB5705.namprd12.prod.outlook.com (2603:10b6:208:384::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 17:52:24 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 17:52:24 +0000
Message-ID: <39e24b30-5ef9-7f16-d02f-be81c4745327@amd.com>
Date:   Tue, 6 Dec 2022 09:52:20 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH net-next V3 7/8] devlink: Expose port function commands to
 control migratable
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, danielj@nvidia.com,
        yishaih@nvidia.com, jiri@nvidia.com, saeedm@nvidia.com,
        parav@nvidia.com
References: <20221204141632.201932-1-shayd@nvidia.com>
 <20221204141632.201932-8-shayd@nvidia.com>
 <7e3deb3a-a3fd-d954-3b6f-8d2547e036d5@amd.com> <Y48Di5gcpCpqf9CR@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y48Di5gcpCpqf9CR@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|BL1PR12MB5705:EE_
X-MS-Office365-Filtering-Correlation-Id: e6dfa149-4854-40d8-574a-08dad7b2a0c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4MJTaLy6h/47nmV8OFOcIHUhqTGw3L1rQWbqV57vzLnhFwcnngR5f7JFlFE/heCdfC7bn/SgqmcNr4bfXsTRZ0qcGS8FIA/N61NSWAP7sKfdX3MfoBg4KSOSYgYpuV5uEZXv9ZrmDopUnvXdZ+LjYDeNm7/ycU/souU8lXLmBiN55VBwOxQ5BMasD54yP9O2QDjTdfVZGG30muEf7OLeXJlT9K8E+RZE3X1eiMr6Ek0l4EDHOCVLsOp3HpL8wLge5GXSgV5WsCJLG5VGDHZdLAvuXUQ4Ev+6fbERS2hHAIq6CM29JDpqUlfkLcEf10ASVaP6LAX3lD2yGwSU1V/3dDlos5vPOWEgG+mQgKgCC2roJw52rvaMcyMg641NsNsppUp0Zq01pb6OwF2Trdf7gwY0tknNslmof/5oElEjAtOHFaVg4hlz9HOUeYAfUyJmuLefffgCbiBglC70YzZRzYS3QqBhMmSYn3ssYDsDliKiXrgriFfOU2CQ0hr3ZdwkxkWJKr+YVBlX+0OmpaeYU5V8QtUr9eCzDTur6fGp6MuSw1fpxosXGfxaQ8/mGxENQ4FrxlU19q59wXIwxhPXmqn8IcowPQkzBqOFMrLiPxM7gASmdcWI1aNTSPHYovRnjdH+GB7IfgAB/m/wM83495NihwifobeM1vv/ZrkwNR67Bng1H2iT3CHCelJQ0G9sbaXYhCv9yV5Mn58YvqhrWXjKtOwO7b+3BRxTf/25MQQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(31686004)(186003)(6916009)(316002)(478600001)(6486002)(31696002)(86362001)(36756003)(6506007)(38100700002)(6512007)(2616005)(6666004)(53546011)(26005)(7416002)(8676002)(2906002)(44832011)(5660300002)(41300700001)(4326008)(66946007)(66476007)(66556008)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1lmL2tMdktveTNTSENzK1g1WGhFeXZGOVZSN0RUQWE4UXFEaWYzUGx1akdZ?=
 =?utf-8?B?blFjRGxGNTY0QWJ2aVBpVUtYZmlaRXk0MnpKdkFscTg2RjZxNUZwcnFOZjlP?=
 =?utf-8?B?UzdOUzZmQ3QwdEFEK2x2bzBleHJON0Q5WUNVeWtiakFEbzZXd0JGY3I3Q0Vz?=
 =?utf-8?B?SHh4NzZ0SkJvcHdPbldmQVRkNDd4dWUwd3I3VkVwVDdHNnpqYVRKbE1Qcmtl?=
 =?utf-8?B?MUtwbm1GNHp3ckxUa1NwQW5GdGFUUE00T0t6WXl3UFNKaTRzOW12bzQ2MCtK?=
 =?utf-8?B?akRYazVJdjBpVFVDVGk4TkFEY09jNTRwTUM5YlhlamhCUC8vL2dodkQrK3pV?=
 =?utf-8?B?dTRaczl6TVl5WGhBZm5ocE0rSFQrVi9RYThrTDErdENHVkFWdW1XM29JdWxF?=
 =?utf-8?B?ZWdPZm5CL2hkT1VlSnMxbEQ5UnhtZmlhS3c2ZXVNalRSVVBSajhYcnM2YjFC?=
 =?utf-8?B?MW1GRVY0SjFYSXJrTEdZYjZCRCtXbzRUczdaQUJZWWFVeHIwQ1FlNlhmdlho?=
 =?utf-8?B?NnVOa1liWnJjcG91ajRjWEpDZGhoQ1pmRzdSRDdFQ245SzN5UWRMeHA4b1lB?=
 =?utf-8?B?Qm8zakNDVkJiSTZRYzU1V0NwRjl1U1JCOUF2cEhTaW9ZcUtKU211NHJxK2I5?=
 =?utf-8?B?K05Ub21YMWVXZU85Vkh3aEI2MU40N0ozMjBhYzNJZDhEaGdOV29ramt0M0FB?=
 =?utf-8?B?UDZjaTA3dXJzelIzMU9EUW1RYmhrMUlIamdKeUFjSm9ONmR2azdWb2lsOWl4?=
 =?utf-8?B?aGkrMUlud3U5ek9TSTVGT2J1M3RBeWx3Q0d6UnJDWVpDc2cwL3dCMEIwWGhV?=
 =?utf-8?B?OEFGTElkSS9ORDNqUmVJNWNUWmZYc2FZTkJncjI5dkFQYmZ4Rk9vOG8ySEF6?=
 =?utf-8?B?QWYyR1phRFJFSG1Uek0rc1g2d2dXWVlzQTdtL0NVYWs0RnRtUkRZQzVuU3pS?=
 =?utf-8?B?bDB3c2h0NE51WGR0QVpLM2djSlluaDRRelFlS0I3RmQ1ZHJQMlEwVWJGT0l3?=
 =?utf-8?B?cVh3WEVjUjFqSjhPVkVVclorMVB1c0RwMGt6KzhkSUVHZGNaeEMwRFk1a0xk?=
 =?utf-8?B?K2VQOVFBQlhobm1jdm43Ny9EbEk2M3A5blk0YUhIcGd2TkNtNnhSeHVKRU8y?=
 =?utf-8?B?SjV2ZHVoS2ZIQk8wQkJ2c0hsNTlIZ3JOcXhYeHkzVUIrZW1leUo3UFhYWGlk?=
 =?utf-8?B?OXFGZGJLSlVHemtydHJJTjhxeUNXZ3cvYU5pdUdOYnVkV1hRYmNnZlZCSDg4?=
 =?utf-8?B?YmJORDZBYWNpbHcvNDBtajU1MGdtbVE0TkxTb2cwMyt0V0N2cktodEFkL2o3?=
 =?utf-8?B?M2dHaVZ5aHNLR08wKzdQVE8wWTZHUVNrRTRqV0x4YlFlRm15c2FoM0FHT2pW?=
 =?utf-8?B?SnFHNnhvVUJ1MEdSS2hwQmx0c09sMlJwL1NXaGlmdlVpTzh2VUNUMEFvS0tZ?=
 =?utf-8?B?K3dkdm5RWVNSTmpZbkxjTUpmUGM5Q2huVzdSZWdlTmtPM0lIMlJWbEd0SUhV?=
 =?utf-8?B?SVlPYVhQV05Jci90NmthRXNDYlZMQm5YdUgvYzl0V1FwbE9NUEZ6N1U4VVZE?=
 =?utf-8?B?ZXZBVFRvS3A2S0d1T3BoV1U2RjFpK3FlRXlUN28xUlRPVkcxQnVFeHdENjVX?=
 =?utf-8?B?THJwVXBEUDRHN2ZjS21sTVZINDJ4Y1JZclUzeDd2aXpLTW8ydFRIajNIUkdD?=
 =?utf-8?B?UEFxRzd4OEFzZXYzZFlMQmE3VEdEUjZBUjZrdlo2U2JwZW9QZU1MM0pUM0pQ?=
 =?utf-8?B?ZUlORE5LOVY4RC95WlR1UnZDZlF0c2VOaTFtdDJpbzJEWlFsR3F5NGpxcFBm?=
 =?utf-8?B?bGQ5T3I4YTZJREdEUGZEZXFvMUNWdXFueGM4eSsxM0V1dDhyYjB3aTJ5SEFW?=
 =?utf-8?B?KzExVmt0cTdOSHpJN04rL0lIcWd0YVdnbGczK2J0ZU5LQmZ5eDgvSFhKK0pp?=
 =?utf-8?B?Q21IMFcvbHhKN0srWTQzdDdyUVA3d2xFRHVsSHpvejJyWE42TWFQK1VES3M0?=
 =?utf-8?B?R3NxR1VqQmptV25mWUNLd0xtMGVBWTRzeDVGU1hGMFNwUDQrZFJ4b3dyYmU4?=
 =?utf-8?B?UlJobFQ1NGtPaEMwUTZPK1hnUCtDU2J3UjRSU0YwVFBERWNEN2pDT1lFS05V?=
 =?utf-8?Q?Ydfv5rCrrpc2d9OqARBDOQEmk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6dfa149-4854-40d8-574a-08dad7b2a0c0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 17:52:24.1829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYtq7iqznDwrBX13rsNY/tl42ppqRJ2VVsYqzWsFhUbcfKua96LHC0zlnUJRDDC+dL4QU6vwLWcunaNYe2dbAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5705
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/22 12:55 AM, Jiri Pirko wrote:
> Tue, Dec 06, 2022 at 12:37:44AM CET, shnelson@amd.com wrote:
>> On 12/4/22 6:16 AM, Shay Drory wrote:
>>> Expose port function commands to enable / disable migratable
>>> capability, this is used to set the port function as migratable.
>>
>> Since most or the devlink attributes, parameters, etc are named as nouns or
>> verbs (e.g. roce, running, rate, err_count, enable_sriov, etc), seeing this
>> term in an adjective form is a bit jarring.  This may seem like a picky
>> thing, but can we use "migrate" or "migration" throughout this patch rather
>> than "migratable"?
> 
> But it is about "ability to migrate". That from how I understand the
> language, "migratable" describes the best, doesn't it?

Yes, 'migratable' describes it, but as I said, the adjective form seems 
a bit jarring to read among the many noun and verb forms found in most 
of the rest of the IDs and ATTRs.

Now, after having some coffee this morning and looking through more of 
the lists, I see there are already a couple like this - 
DEVLINK_TRAP_GENERIC_ID_NON_ROUTABLE and DEVLINK_ATTR_PORT_SPLITTABLE.

Fine, carry on.
sln
