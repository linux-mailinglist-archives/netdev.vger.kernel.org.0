Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC916B308C
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjCIW0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjCIW00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:26:26 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F631F9ECC
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 14:26:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyyuXcKvwMw9TMSJ6zOmrzF3nV1cntI2az/uzb/t9QjJjBWUXURcOvboAExiVZGpIbrtmRAzCguitxSKUKgeoLgJEC8ioMYEFl/+rnLHmu+vd+yS5hn8rWjZ3ywx223x8Q8XnSM6FhBMQAgLIKAf31aLxrQDBm5IkG1C6NQ4vq9D/POuBWrc/zPvLfwZ/ATwXBGW4MJlpL7UMXUUuWhoxVBdzaHdgf87rcXO3M+gdI9kczkkPtO8c8YoHcNqU5yFyBigXd3w9Wt7RYQ49cjQVHPAyj1FYMr9m527CpLj9WKrJfU5R2W9uEpaAfxnVxmOgdIAxIkEI1BxWlYxtZIeJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qy8h8fM9M3vkkl9wv0bAKKx3KkkOXp0uIPcbwR1N+JQ=;
 b=McVEg66MLGVi3em/OIZmy2Woi5EW3qMkBE9T+4gaQZZjnMO7DmkpJhMC1BMR6adVnx+gsMDZs2zSPZcViSygr6jLiam9NqG+tvVXOnv7FRbWYavRYu6KHn6I27MqW2Vd8Bf1e8nBAyYYL7PQwtfA2WlvRorF9MDVewh9cx2h2Bq+omvSKwqJ7Jv41LGDxnC3NfUMBs4+5XRmj9SHqRv42bvSas3/N+qHolvKqFaTBB4aEnHgGT0GDkwhbd70DW75xH4xaaxqZuw/6SghvPHaufkPsz8EQ08xDr14uYIqmb9KZ7zpOVCnLzraiw3wFlShsvCK2sRTkot+hkj9o9ZUgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qy8h8fM9M3vkkl9wv0bAKKx3KkkOXp0uIPcbwR1N+JQ=;
 b=xWKM+xbr4gRd+5iCC7axX8yPyf+8SqRazC8OH3Wss5yjJOFwo1Nc1lEYBdysUJ0E7LK6wRnNiVsJTH0xz6E6Z9oMQmKY0B6VXu9FhSFPTkVwgRniFBbCHQamoQm1oq4eAgm/MovdkUhALp5RUWkvWl2iU1JKFgHFfkMrlAh2rjk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 PH0PR12MB7816.namprd12.prod.outlook.com (2603:10b6:510:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 22:26:22 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%9]) with mapi id 15.20.6156.029; Thu, 9 Mar 2023
 22:26:21 +0000
Message-ID: <4cdabcca-f8e8-81a8-a16c-d646adb84dac@amd.com>
Date:   Thu, 9 Mar 2023 14:26:18 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v4 net-next 03/13] pds_core: health timer and
 workqueue
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-4-shannon.nelson@amd.com> <ZAhXycSgSiNFwpNl@nanopsycho>
 <64d72af6-66f5-ff68-f7b3-1fffba61422b@amd.com> <ZAmnJvkAe4vJHRcN@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZAmnJvkAe4vJHRcN@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::40) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|PH0PR12MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: f4ff987d-f036-4768-6f78-08db20ed4f93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zybAXGTxd/yWus6sQsWjzJMo/61BVCRClEYAtISL5eYeUZ61d6i7DMrkCiR3QlXGyyJw42TneMSPM0rYb7RYXRK6DzOOrjrapoqAHwPVoxLZU8UODsg20yet7C/LHW79CM5PGXHCu3t0WAT18Vf+0aAbxDQ5wEqFsROEDMzeN2MU68LALe0+gEIUuqdhMlE2Iolu15O4kObbUt+ZK/9IkiiXaWFTogOVBY3pCO2YJPxo9lf0vS3Ck3EJg/KNL3YzhEgQm+jgInoosqGEN+Mb2alVlY3t25xmvCKu4ZuYO++lQiXjowWKa1uYbrMk0uvdcRQDm1ACruq4yHXxLszYO3daJnJBetwPZh4cY9cAt3sPk33slKoEp0R1Bde/Oq4nHgTV6m98LhDw++0xjQpPPzFDq3+Xvvk3atRFfyu1SE8fkwjgkKT4Vl4rOrnse1xfnFU1A8R+8NP5igL7oDqH/6PdSF2jAFp86iHZ+5EpWCjXBfQhTkyQV1gJiiHNfVEDfReQLzZAAifN12/hN4XQd0Sw0CPDo28m235m6BagvBKopR9Gq4LWCWqn9mIkn64AiQvcQPGnmFAScKalRFGje5uGV3yZ5BTVjpRsOezWhGInO/HNpyzUCqgTdd/Sk5zvJS3CIiAra3eOHs9iuOT3jvdzIoXbfWnIwhr44FHvIl7TOkfN7rHaE+NMpaC2OhrRLzRNB9m3Pktf47wOyoqOk5kT2VdT0Stz+VIesVwhIDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(451199018)(6666004)(36756003)(6486002)(478600001)(5660300002)(316002)(2906002)(44832011)(66556008)(4744005)(8676002)(66476007)(4326008)(66946007)(41300700001)(6916009)(8936002)(6506007)(26005)(31696002)(86362001)(38100700002)(6512007)(2616005)(186003)(53546011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVM4MEpsMDBBTnpTRWtsL2pNMGpkaS82VlZRUXhDL1RlZzk1bWJ2K015Q2VD?=
 =?utf-8?B?WUc1eE9qNzNHS0RwcVJ0VFo5SytTWFJjL254cDVYcnpPTEFZY2VYWG5EY0Zn?=
 =?utf-8?B?NS9jVXVlQUswV1B5dUZNWWZobWo1NDNiYm9ZbUNSNVE4Q0dLYUhMNVh3UGlF?=
 =?utf-8?B?MDd0Vjk3TnpYSWREcVJmTDJRZmxuTFZjN1FlcGlENHNqNG4vbXlLZ05qTXFy?=
 =?utf-8?B?K1BUMG4wWk9qRjFKclZSZ1NBcGp1YmtyNVBWV05YSHN4M2UyV2FWaXg5RnNY?=
 =?utf-8?B?U08yUDVUekFrV1dpQUxrQnNreFJnOU9LU250RHlmaWhpNUt4NkJ5VE1vY1RV?=
 =?utf-8?B?Q2gvRDZRN1dyYm9FMWdEVHhFTExwYm9zbG5lMU9zZ3BvZWZEWFBtN29BZm5p?=
 =?utf-8?B?bFNyZGwzNGJlVkNhOXRTbEgwNFI1c2djZ3JEcXVJTDVWMFJMeVUvTzJnOGF1?=
 =?utf-8?B?Uld5TTQxWFZNSDVHSXBwc2dtMFpnTUNEVS9Gd2dkYnI3eVNWMER5dyt6STBU?=
 =?utf-8?B?NWpoOXFmUktDNFYrcWMwSytrZFhsQmQxUVF2dGhuUkFnSkxHWW04MHZvM3hy?=
 =?utf-8?B?djBNT3FzZmdpQ3BaUVZGL1A5MG5tOGRBVlBOaTRrUzVmalpYWDJCVjRsemhN?=
 =?utf-8?B?SXlFZ09HYVdsUXVWdFo5SkJQZVFCaXIrVkR2N2hJekJJOGQ5eDkyaGpyNi91?=
 =?utf-8?B?eENWc2RUY0VPQitSS3BmODZQNUFyd0EvVWtWb0R6VHhJU1IvdFl5NllqL1dH?=
 =?utf-8?B?cUNkWksrZkordE0yOUp2U1gwb0FsMTBHTURpT2FRZ0VrU0Mvck9RVFdCOHdD?=
 =?utf-8?B?RHIzcmpkdFNTK2Y3anBpVzZCZGUyUU8xZEFEVklIdVZOQVhidDU2bTUwYjVi?=
 =?utf-8?B?Kzg1OUNOUFZKU01FaHpKVmdGREVseXVDMFUxZGFjbWxPSFJCakJJUU9SWkJM?=
 =?utf-8?B?MDhhNFV2eXdwdkhLMGhHRWZPYXFHTjQwcXVNamNJSXJQaFhpYlhvVGJiV21v?=
 =?utf-8?B?OFNVQnJzT3VTZ20yaVpUT3BMdFFJRlBreVJlWTR2WDNmRVdZRUFIMStaTkFH?=
 =?utf-8?B?S3JWN2VUd3dwTmlOS25SaS8vZ250eHU5OTdiSDFjakc1UUdWYXVGWlU1OFJ0?=
 =?utf-8?B?SCsrTlhGbzBDWmtJMGtZcU8ySmJmbWtGb2ZDcGlUUXpEd2hPVFptS3R4Vm8z?=
 =?utf-8?B?cmJIZFFVTElEWFRKaXl2ZXlZM3lTZmR4b2haT0RTSW5yWkZjMDRnaStuNWZ0?=
 =?utf-8?B?VkduSG90ODVEdWJVcm1HQStOVm5zcVBLVkczWU81czNhK3EwOFAwb3Y3Skor?=
 =?utf-8?B?UVBCaDRwTU9OVWtydnJGQnVNb3YyZG56Sk9iQ2VpQTJFdVhQaXJkdEZMbFdq?=
 =?utf-8?B?REJYVUo0c0gvenJRcGRxeUJJb3FEMlNuUkZzekhaRHEwR0JrM1pUUXdxSFJj?=
 =?utf-8?B?YllqVWhjQW9iY0xxMEhkNlpIM0phcHNGNlEzNWV1RkdKaVk3YkYwTkx3OC9D?=
 =?utf-8?B?Z0ttaC8xVjJSdm83MHpvaXR4T3lFOXlab3haOXFveHYwbmxtblBReWpTcm9l?=
 =?utf-8?B?ZlVBckdmK1dsc0pyUkpvN1lEQU54Zlk5TlVxOHoxSVYrS2NEZnFhWnhtVnla?=
 =?utf-8?B?Q29zNzgxZmErYi8zVnZyWWtuSlBtVjJ2ektQazd4WVppcWMzYWk1T1RyNGcw?=
 =?utf-8?B?SGdNTDQ5VEsvbDI0MUVnaEVjUFpjdWN6ZytHOWxhMVVtL0NUNkpsUVlObkh2?=
 =?utf-8?B?WTY4Z1RQdG1DWVU0OVErQ28yby9rTlkwWGExZVgyelFYM2VSWXZ0TkZ2Y0NT?=
 =?utf-8?B?R0k0TlpzTGwzVkRRZnNPQzF5M2xCRnhSSnNQZHBPOU0zYkthdlNnS2c1WEk2?=
 =?utf-8?B?L01NQTZtMXJGM2k3eS9uYTJ0T2MvOFl5azAycWRnczQ2TVdOcFEzaHJVbHhs?=
 =?utf-8?B?Sk9ZNUpoTDI5VXdEMGJvUkpKelVoNnBzRGcwbWhNQTNjQ3ArM0FXWUZTTVdG?=
 =?utf-8?B?dlZUVEhIbExWWmxlRGxlbnJ3V09ocmdiWXhZeW9HNWhheUZiMkQ1Qks4QW1H?=
 =?utf-8?B?RlJGTC9JZmVPY2p0Vzh4MUFHbkpvRUJpVHFRNDQ5cnVxWTE0T0djYmNLOHFZ?=
 =?utf-8?Q?ly6ZntfE9oaQg82y3Ng2m/5Vz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ff987d-f036-4768-6f78-08db20ed4f93
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:26:21.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gVfbdkj4bbpHj1uztyq0WyQ38Dc8irl+/NTzbepqCJi4PCTi+UCpg0mOgeiFiakF3Z7kzdvW6FOQk5xafodaGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7816
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/23 1:30 AM, Jiri Pirko wrote:
> Thu, Mar 09, 2023 at 03:08:44AM CET, shannon.nelson@amd.com wrote:
>> On 3/8/23 1:39 AM, Jiri Pirko wrote:
>>> Wed, Mar 08, 2023 at 06:13:00AM CET, shannon.nelson@amd.com wrote:
>>>> Add in the periodic health check and the related workqueue,
>>>> as well as the handlers for when a FW reset is seen.
>>>
>>> Why don't you use devlink health to let the user know that something odd
>>> happened with HW?
>>
>> Just haven't gotten to that yet.
> 
> Please do it from start, this is exactly why devlink health was
> introduced.

I'll add it in the next rev.

sln

