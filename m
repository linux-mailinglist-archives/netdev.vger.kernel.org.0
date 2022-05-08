Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7406E51EEDA
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 18:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbiEHQRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 12:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiEHQRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 12:17:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D12E0B4
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 09:13:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NN7oMljVz28TzCSuyPmb6DJa8Jiuy/lFSaE8mQvVVbehQMACYcU3Cd9eUs9ZW7vI1AuE3c7iyjP71puaXHZiBGBnUzeJPZ0oOZsqhClj4wbH/W25+3Tpy/EZ8wvvvzHPRlxU/ZVhOe+sNOsHkfkGIM0ccvONSEl5AwKXBTuzildUF++lH/fFXd3UH0EeAEc/NB6kn0UQuh6EOF1xrRCiH8PggTnPHZotDO21AqCwlgWpzWe4iVm6ogSuApqgrBqntt2+/bJAZZ2adoW8n+o7sDm3ye7TjRegOJQureD12iAyQK+qnEaV9vqp/1wNhLMPV1uBUsoUBCJeB7VAmS//sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=814YM4VcDV6mUj+e8wRsiinVRrJFM7G9JK2DMWdgqKQ=;
 b=cN0ArH8qH05TDYoXzC6RrXOPHJFJ2Q1xOqIrSms5aO6m0fZM2hUH4vOiUblxYVfWzJWoqszOcLv0NjuH13DQvU1OS5hEBopvgy7z8558xTYrnAVJOZ0+S8+Z2bB61YSlAMh4KAGYcuLzyBg22b6LQIFj64pnm0iSpnV5ShJ2+DoeIE0rLm3f64f0Fe/l/19gaJhn1mi8egQrfOmrkbfQB/OIO0clIq9/EjTvPiELa7gXNC/MovGLkEJ56lctU0Wz8P7Rklx/K5UiY/mJAmpdzIz1+CvRPweHKWZ7V1tDxcxz9j9ycHBvaPeLBUya4/jLM2hM50rvMg//j4gasQjNSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=814YM4VcDV6mUj+e8wRsiinVRrJFM7G9JK2DMWdgqKQ=;
 b=pwzyxzqV4HusAwuFzOrccRrchOQhsWiO0DKtg1LPPwFSPAYt/WRp5wm5s/+SiCxt++TJF48ggkXoWOh3v5TAaSwT4yp8uCb70FC1mvlpWuy3wt6Q/HpjOT+ja35RoQQntLZj2fwimqMbOd6p+893NOSYgkKJ5OpE+NhJo9JiBh+olLL7Lb1z2t5fEVExt1jD7AGg2i/S9PBUhRPkgSjZmg7zltBwS4f0CZaBjVNLvZcOUE444/fEMRmcOhx3ca5KeHHBDtzEyTrZXLdl35Wqv1v7glrDxnedS7HOJNPUQdDo7xtGnlDvB60XiqBV2fmjMokzh3kVuDg38oDDCvPvNg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by SJ0PR12MB5455.namprd12.prod.outlook.com (2603:10b6:a03:3ba::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Sun, 8 May
 2022 16:13:40 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%6]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 16:13:40 +0000
Message-ID: <20c7a87f-0278-ef58-417a-e0e63dfe74c7@nvidia.com>
Date:   Sun, 8 May 2022 09:13:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2 net-next v2 0/3] support for vxlan vni filtering
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        razor@blackwall.org
References: <20220508045340.120653-1-roopa@nvidia.com>
 <7da08a10-7d2d-4b58-821c-bec68bc55c87@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <7da08a10-7d2d-4b58-821c-bec68bc55c87@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0063.namprd08.prod.outlook.com
 (2603:10b6:a03:117::40) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93bfa830-2212-4f89-d841-08da310db6f8
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5455:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5455973AF6730C7614B75E9DCBC79@SJ0PR12MB5455.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cGylZyujWGE8VgsVJ+YrNY3MNvWD8p+1t5xffEL800StRB06OFcrNNsw5TtAH+hvHLSTZlpdXLMDHl4TeIiCWOn9xdz3LM8RJvcd/Ug+Q+1TpGxm44QMdmYWYDgQLZ2WekMqy58QtCSRWmeNOF5fzYbc51DOhrUKptg0UGbjmYaQ07yh3iZwDRpHOOz0cEpR26b9tHoCIVH6xnBLivWLf5t0Wy2ct2iWnin1D7VT+Rs7+V1TWDcM+ZS0aX6YnnGApwTDIz1pV/amPtRQ3cYGV/RVZgV6GSqKpa73ikIMRTYDmqA6uETLrm5vvv9cnZtIYma9IJ+wQiVbmfZSH0LY9AzQbi86uHiN8YDC8HCGg0pRBA9fsZqQMqZ5ivoFfTGxknLWSjqxqZuw/n2/XL3s04fT94mZ054Xt927FsKCywgfJBbkWCFhsuagaYc0uBgvDTkdcwxWlK3Y9DNXziR7inqh7qMRCoOXD5vbDPoNAjFCDCsf+FaP5bLW8VwVnam7rnEJrVgz7Fryv9uBvf0uFM4fCBrA97y2Rw0GZyuISFHiq7jp5Syv57uZJlWUf8P1VOpxcYZSFKDbOdbQFx5JlmafaBWBTE/BTztXUNLbb/J8e9adXjF3rZlnWrEXLC2ZGMwXTL06ZJd1kMdlCncQ+69PqXJoyu2ftCxYugj2pSGoOrM63Tx+f/X4Uus0R9htrtpY+YjEaO/zV+2rWMHnwqZPZiNmHpnyWDtazbX2PpE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(186003)(5660300002)(6512007)(86362001)(2616005)(4744005)(8936002)(2906002)(83380400001)(4326008)(8676002)(66476007)(38100700002)(66556008)(66946007)(6486002)(6506007)(31686004)(6916009)(316002)(508600001)(53546011)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXF0eWFNVDR2czRnelRBQnZtOVo0eFg1bGZwMHF5SjJrT1VwQlVLMVNZT3gv?=
 =?utf-8?B?NE5uTDgxMkxkbzhtajdXSFdpM3BIbzQvcnhiM0tWOTRNZnVQYmF3ZVQ3L3RN?=
 =?utf-8?B?cTZ6a3J1L3FqZE9ZM1NPQk56eFY2Sy9sQXZKV1RheVhyblJnS2lwYkZpT0I5?=
 =?utf-8?B?dkZVYXFKOVhTN01qcmlWWXRISmVteHJQTDIxTVNVbE1xa2VMTXQ1NlRXWUlX?=
 =?utf-8?B?SGxTbmZ0S0JQdXlVcSttVWxseEFDVzlueFdOODJHbzRrYTNFdGtndFJBaEtR?=
 =?utf-8?B?UDVIZks1cy8vSUxGSlR6dDBZZzJRWDM4S0liWkFBZkFZendhWHo5MGk2Mnhs?=
 =?utf-8?B?TW0xK2I0N2JKbXhoN1ZFOURGUnJZSXVPY0IwZzU5a04vTEIrUEVMb05nOFRl?=
 =?utf-8?B?MGwva1QrMk1sUVB6OVdZdDdhSW1vdVlmZGJMQ1M3QW8xNGpQaUdsbXpXenJx?=
 =?utf-8?B?VmU5OWtxTlFkZ245UnZ2eXpKNlQ3RXQxT2RHRk5YczRNY3pmeWVJQittcXRW?=
 =?utf-8?B?cHFKbmQwbHk4d1dqVGl0MEtPb1MyV0dVOTdJLyswSWs3RVRheTBtTVhmVkxs?=
 =?utf-8?B?QnFFNHFvVzFPYXIwTHM1YXBETU9ra1ZQQTRHZDRqeDhCYkZXZzR6OUZndXhI?=
 =?utf-8?B?ZEpiaDFsMHRBYnduZEszYWphYjk0T0pzelRuUG9VMXh4Mlk3cTBOdHkrOUs1?=
 =?utf-8?B?R1NtRFdsVnVXbFgrQkU5K0xIM091QjJwSVRBL0NWcXU4bHd1N09QeWtHNENq?=
 =?utf-8?B?UjNVV2R6Q3I5Vk9jLy9BY2lydGFMekg5dnNwWDdBTndvRkhJYmdxcHIvODNw?=
 =?utf-8?B?bmk1L1hUcXRsUzVVRElUV0ZyS2p4RE5RNUV2eDI0RjNZbHZuZkRqOE8ranZp?=
 =?utf-8?B?SnNIeGJ1RUZTdWFuMzhLZEJZQ0ovL1RidmtveHc0bUx5QmhnVzFXTGRBck1X?=
 =?utf-8?B?VDNoVy9jM3hveTlhUjhxYjlVejdDRWxIOXRCL3ptZWM4S3diUGVuR3JIUmZi?=
 =?utf-8?B?NHlnamRZME9wMGVRTlBWVnk5R2Z6b1h2MHdZVjl4MzRLSWxJY1dLL2tFME5M?=
 =?utf-8?B?c0VoV2xZTTZUaEI3a1RPa1M0djRGWTlRUDRCbFVrcE5uNFNWQkdiY2drSFdQ?=
 =?utf-8?B?bkxvd2J1dnk0VWNYSnIrbis4dFdkd0pubmFSYktTVkJFYVF0emVVWHlrNEJC?=
 =?utf-8?B?aEF2ZHl5VkREMFlkRjRmbkJjUWZBcGVSQkhnSmppMVBaY3NweFdYTnJveE42?=
 =?utf-8?B?cisvSXlUbUgxWEtKT3MyU0NvM3RUUWNCVzUvMkJzd3h2YStNaDRYaHp6cm1I?=
 =?utf-8?B?WXhIbWpmNTcvaEdxTW9JVnJrSnRHWXdmeUZLQS9UdURBQTgvN3NDaGdNczR5?=
 =?utf-8?B?WW1mUS8zYVNqbEZ0Q0ZIZmRhZkxRT0ZTSGlOSGFpZ0xiQndrSUJYUksrVFVn?=
 =?utf-8?B?RlhsRGlwdDBBbHBrR2NmN0h6RVNxbTJqSUcwcWwva0U0bDkxTmN0Y2M3bGRa?=
 =?utf-8?B?VzBrbjQyeWFPN3l6ekRkZ3p1eXpWVEFkZkNsaEpqWk1qNUJ1YzhIcWNBWEll?=
 =?utf-8?B?NVJRaHFjeUR6SFExeDBQK2MvaFBPajNmenNVaExER0tyYVliMHRSdWUwKzY0?=
 =?utf-8?B?RTRSTnZ4cVQ0aGpuandxTW5XM0UzVnlQYkI0UUtNSXZnbE1LTXpwWUtNYkc2?=
 =?utf-8?B?WVdPTWNDWlV4Vm0vdHBNSGRpbEtLcXczdnBBY1BncUI4WGlLeWlKdmNicGFa?=
 =?utf-8?B?YlJIYWdtbkNBOEozMURMNDJoYkxKMFFqdmNMZ2JRUm95aHRXNWxKak9CRlQ3?=
 =?utf-8?B?UXhvbVg1SXdTWmg5Y0pKWG1ScDRVVmt2WkZjRE1MSnRMUEJ4VG9FV25BRmhC?=
 =?utf-8?B?czBlbTZzUXRKQjdtNlk3dWFjWXRGa1lGQ1ZSemJ6VWpZQy96cS9jN2JvRWIy?=
 =?utf-8?B?SGpOZnlSNHkzZWlNYkdvd1Jtd0FqM1l4ZFVWRnh1VHg3VEc2NGJEVEdGS2ZD?=
 =?utf-8?B?RVBUd2o3RlVRd3VuTW9xMHVoQzkvd1dSbytCcFY3U3VSOHdXTFFGRmpKVC84?=
 =?utf-8?B?Uk01MVBnYU1Fem1OdXBXUU5XT24vcStUZnoxUnBkT0NOU3dmM1ZLbDQzOWlN?=
 =?utf-8?B?SnpmWkdxeHN1aFdpbk9tNFZNU09FVHF2K285TWFqVkVaZm1RSmhieGpQRDZO?=
 =?utf-8?B?eWRWczM3clZjVzJKK2JhNVZnWjA1MFBiZ1dyWk9HYWZXZGNnQ0w2eHZNenlq?=
 =?utf-8?B?SXVReFNUNzAxYklTbmJXUzZ0UU1ucU92TWdxQ2VFaldGcVZTbzZmZWhDWjBP?=
 =?utf-8?B?alZFSnd5M1g4cUdGekJicXRabi8zZ2RnVmJma0IwVEVuRHlXSXl2Z2JZR2Vm?=
 =?utf-8?Q?28UBdGET94t+mI33bLSzmHOvbOt4vPqEPjjp30TOu3Y+B?=
X-MS-Exchange-AntiSpam-MessageData-1: scOaXCochudWDw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93bfa830-2212-4f89-d841-08da310db6f8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 16:13:40.1693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 01qelpBu4QHnY73omtGDHpmvJCY/TtNPRzqhoGJn0yFjegHEQOyKXaefRZEgUh46gbOKNhL+zbQX5xxOTjMO4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5455
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/8/22 08:53, David Ahern wrote:
> On 5/7/22 10:53 PM, Roopa Prabhu wrote:
>> This series adds bridge command to manage
>> recently added vnifilter on a collect metadata
>> vxlan (external) device. Also includes per vni stats
>> support.
>>
>> examples:
>> $bridge vni add dev vxlan0 vni 400
>>
>> $bridge vni add dev vxlan0 vni 200 group 239.1.1.101
>>
>> $bridge vni del dev vxlan0 vni 400
>>
>> $bridge vni show
>>
>> $bridge -s vni show
>>
>> Nikolay Aleksandrov (1):
>>    bridge: vni: add support for stats dumping
>>
>> Roopa Prabhu (2):
>>    bridge: vxlan device vnifilter support
>>    ip: iplink_vxlan: add support to set vnifiltering flag on vxlan device
>>
>> v2 : replace matches by strcmp in bridge/vni.c. v2 still uses matches
>> in iplink_vxlan.c to match the rest of the code
>>
> fixed those as well and applied to iproute2-next. We are not taking any
> more uses of matches(), even for legacy commands.

ok, thank you.

