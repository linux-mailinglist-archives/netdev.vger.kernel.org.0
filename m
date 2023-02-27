Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E666A42CC
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjB0NfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjB0NfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:35:11 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C45C1725;
        Mon, 27 Feb 2023 05:35:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c/opZ0aXdGOFCaVnrf4q866kbghoyQ0R2S8JQzQqYwcbrpVMOmIx/1DQtRqNRKwDuQ7nH/vF4c0K0FCOi24AZolbsHXo+RWXAKtRm57DHSfduaIVzopQ1D7PqtEQ0sVd/RlKSpqDk5aRog4nTMRx8tGixFObDBkomXvxSPttCQOo2NblXUMcpApG9jhL3ZLnAPdMJ2hwfXy/zTi0ws/3XdcFWUuRAKjGA1CLnwdIP2QF83uCGR6gm7U3CYhkEV7o2YNkRT3ItnFqj9TStK+XTgDHD1XztGk7HKsNgBs3g6rc8I9kEVRUII1R5NdVwWIqpBy6ejd1hwe0pbGH/JiWoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/6HvfIzjGO+UItAErv8tdVu0Cjft1/XZpQ0QsxdGfU=;
 b=njqZOwuJhEZtF3ZaNb3gubh8mXkUsfEOojfqapVrd5YarCr40msgaT1C410dvnTJTmq3DyOZDSKEb0PjPtMBxYG7r5LFdo5LzTT6zkELnexNDvXL4Up9j9JpFwy32sVISEOZ9nonbZxYa5+EGiemlR1RI4PZ+8qVwncd+0FuxWLt8RPFA0UtPyPGbZYppURRV64HJjjWIxiGFTrv2UywEELnIlte6oy4YppqgpbxC4AKYaDKNrYb9P7URWGjfXVYKPuTgxXeWSPK8jQ6UhZ/jlC7dDRd8hsy3Ib9aM0eQW0E1MM/LioPQBhlfUg+li3deohYjaRqTO+jzp56VByYlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/6HvfIzjGO+UItAErv8tdVu0Cjft1/XZpQ0QsxdGfU=;
 b=WXXZYHg8pj5CR2Bmh7oayYa9vsy8gW9ikDslbnDSkX20O4FFN6tAEm6jC7FHYpuuvVXCDN2Yve9mG/6OAVCBUNqLrCNCssWsDiGeSgfKaGkrvpPo4TdURCrYsnw63mwXDwkb8F+yJqNj7Ju2FQpgmPldorOjWy2cNZrfTkNankby3PKhJRk5upG65yCPpVPq28Tix7f1gJQhpA5hgjYp8j7yihBd+evX52JlOiTo1DDFMhXvgxSouOu7cx+3/srznQDMGuY5kSc0AcBI/RWlVGElr1sfeTlwfT6PDocmlly6OWPmuQDxsAkcGKASA11XEgR8Gagg8ti+4nVJzfqbRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CY8PR12MB7708.namprd12.prod.outlook.com (2603:10b6:930:87::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.29; Mon, 27 Feb 2023 13:35:01 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 13:35:01 +0000
Message-ID: <1b8de64a-dc55-8ed4-857b-9d524951760d@nvidia.com>
Date:   Mon, 27 Feb 2023 13:34:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] soc:tegra:pmc: Add wake source interrupt for mgbe.
Content-Language: en-US
To:     Sushil Singh <sushilkumars@nvidia.com>, thierry.reding@gmail.com
Cc:     linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        vbhadram@nvidia.com
References: <1673864352-17212-1-git-send-email-sushilkumars@nvidia.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <1673864352-17212-1-git-send-email-sushilkumars@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0144.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::17) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CY8PR12MB7708:EE_
X-MS-Office365-Filtering-Correlation-Id: a1b0a1a2-09af-4629-3739-08db18c76d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J8+8qgof6Fu3RxqbWcW9r/vyJ3aegV6BH0XvzFeV7+uJSt8qKZ1m/WwjtYsUUz68vrJ1gAnosW9Kxd2fgRXXsHGBexnWO3JKz0SPPKhbeldn/n4JpF/ZWRDzkEAIHwsQvoWiljmk/vkgrhcbcdv/MvAJ/CEroBSugokNqz8GqpwmS9/s4E+ByggRm1AbDMqmlZ0LzxYHTubxjnMkvQtRROpuZUgFZ6T6rouWv9fg0SFGQwqWLLZxUaRY0oxqkjqZut3kx6/cfgCHP76zanMkQFT9sYIgpS/mO8gyolNyHRelDeXeMDrpx+3ZisnX0ErvPfVaTBCeCY0XN/+CCQZrfgXBvkKFAWHYaPDOsxXj1hPzaN30odbtRtoYRf3g5ybtYBF2xab0YOSXbRIq3N/UdX3m2BRv//3cOTMErBaJiFdyNlq/WQZBnYhruVdxfUA7ibDVeY4OXax8aNYXeHQElcQUczR4+TqOE/pHKLCbLBwVILZw4WB5g6rlKXQ1xkrQloChmRz+Rd6GecyDpl4tZZF5Ci3foBIrWfaEMFncdugyDrb4KGrAdY/dVqbzKP/EXDuLs8HNF+FPKzaK6ePEOszmTwFNKkQkeI7biolDEQr2gCr/TDNUvbJVY9v+08ATWK/20rHwibeXz0GMHY3vHW0Rq2aqsGMJ0VNPieaKDkq3ifQAAuu0Rm8txJVv4heZJt7SXAWEbPWtpjKmX997Ygez1m0Y3c7x7TdmTr/IH/E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(451199018)(31686004)(83380400001)(316002)(36756003)(4326008)(8676002)(38100700002)(53546011)(6506007)(2616005)(478600001)(6512007)(186003)(107886003)(6666004)(66476007)(6486002)(5660300002)(31696002)(66946007)(66556008)(2906002)(8936002)(86362001)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnBlVHRPUE8xbW55SWNsZU1aUEpacjRDMEk4dUJTSlBYYWZiVjVPdUxMMy9D?=
 =?utf-8?B?Y0xGWGx0cTdKd2J0UHpNNkRxR2hJVzQ2MjhxcGZOV3B1SDh6bVV1S3FkTFhU?=
 =?utf-8?B?T1d2bzR3MENJb3dVV1BKL0xQejVKZS84aURjVi9UWlV0VENJalRHV2tPeFMx?=
 =?utf-8?B?VFlHUGtMekh6OWhNR3cxZ2lxczN3NmphalFTT0tGeXJmdkFuekZUVGZ1RE1z?=
 =?utf-8?B?QUtNam9jQTFzWXJJcjk0bUFBMUI3NnZPQnoxN0czaTJ0RjVPbDd0d0p5cmZZ?=
 =?utf-8?B?T2dDc1BCRENrSnRBUXlBeUZRQTZwVWNSTEtOL0NlbWlYQ3JrQS93SXU4a2tH?=
 =?utf-8?B?a2JoRmYyeWVnQVNockZ3OXptTGgrVkxyUDlUcXMwNitrbDVuS040VnBjZWdF?=
 =?utf-8?B?REJpaGh3MmkxcnhqbXpXSVpKTEt6amQrZ3BmSXQvSWZkWmRzN2hwRDlLU3Jm?=
 =?utf-8?B?NHh6alJGWGRwY3hsUmxTeno4UWRwME5WeDNmME13L09PUEV5YmE3cHJmcHIw?=
 =?utf-8?B?NEtSekNNdjU1MkFGM0JzajB6dlNPYkF5bTVHd0lSb3ZYMGkyVmRyQjMxSHZD?=
 =?utf-8?B?aUl0L3hMdVByeUs1VmFoZUljV3VtRmNjdU5PRExHVUhQNlozOTZWM29QcTA0?=
 =?utf-8?B?c2dWWEtMRXBXSHBVb1FqSzRxZVRCSkRLZmc0aVhhTDJoK05KS2hWeGI3NjNy?=
 =?utf-8?B?K0Q3cWtaZkdDQjBBM0ZFY2lzRTNvOEIvL2ZBYkhRU1ByZU5iMU9NZXhlQnlt?=
 =?utf-8?B?KzNYUXppVlVWUHhoS1BQdG9wbzloSm1yUGtUOUJFeXppbHVJWmdtWkg2RmZV?=
 =?utf-8?B?N1psenpkZVFaeGtXV1lvWXVXWVhCM2RwVFZzMGxUNkIzVENyRTl2bDc2YnhT?=
 =?utf-8?B?aXFneFJTM1RVN0pOa1hLMDEvT2lmZDBVOHBsSkxSOHM3a0NTZklZajJkRTJr?=
 =?utf-8?B?QVJSVE5YQittM2Y5MzFiVS9xTTdCOU9UOGRlc0xxVWtURC9HMHpROWZ3V0pE?=
 =?utf-8?B?VGpJS0hGdTAycThFMHBpN3JVUHlXa1NBdHlzY0VvV1BTUG0rOUh4YUwzNjRG?=
 =?utf-8?B?RE56WUJrTjdKM3BuQ3R6MXE4cFBXbHdOMlBRS01tY2tPWjRzdDQvRUpUbkZn?=
 =?utf-8?B?SWNNU1lIczVrZWNCTDUvYnEzdFFnNGo1bVl1UHRiZEtJUXZKOHdEN3NsZkhY?=
 =?utf-8?B?UUZOelI1ZVlCUjdKYVo0N0VLaGJxZ0JSRm1yNmxNWHdaRXFDNDFROW9kbXBq?=
 =?utf-8?B?anRlQVVhd0JTaHRlQnRYTVlucFpJeHVHVTFZZzZvK2luWUFHeEp5QVl4QWZK?=
 =?utf-8?B?amRmbHFCVkFacmNIRTY0cHJyY2VxbkVjK0x2TkhtOHhkVWRmUDZFQ3d3anBw?=
 =?utf-8?B?aUJRV2ROaE95Q1htaVlsSWJMcGtNd0NKSHB3OERnR3ZwMitEb25xL0pEekYx?=
 =?utf-8?B?SnJ4bFVZaWJXdzNtdGtSV21zbG9jY1YwYXl5bGZLUjZDYjMreWZrRTJiajhD?=
 =?utf-8?B?RjFkYTU1dStaZEpJRHNjenNFOE4vNzloZ3FyeU1NZHEvRDAwL2gyV0JtOUwz?=
 =?utf-8?B?SENoNXRKR3JrM2Y1UHdBWTBCakpNSGkvRUZ1NXRNS1paY3R1RllvTmtyRVJi?=
 =?utf-8?B?d2N2MHJNRGthM3BFU3d0VXIydkJyVCsxSlFuVThIWmNJaHBhaXVaeUNpdnFL?=
 =?utf-8?B?QkNDZEh6Snp0c0d3T0IrdThPYWFJcmxyY3NtcmFWTnZFUk93azBJMW9ib0M0?=
 =?utf-8?B?eVhDVUJabzEzWVVJbmVJOHpmWXF0UlVMbEZQSFBnR0VtTlcvdVlqcG9jSnZK?=
 =?utf-8?B?T3J6cnRVN3Vsc3EzWnBEZndzTW55K3FMdTg0RjBvUXREend5NXBtUlJYWFBt?=
 =?utf-8?B?OXRBaHdJc01vZ1NWNmdSRHdsWFc2L2FoOG1nUlI3NnhqNThrRHhlZEdSSEFj?=
 =?utf-8?B?VitSR3JXR1Q3Ylh3S3BFVzBiQmt1QmxyZXZRblBIWk1Ec0NIQmg5cklGUkJL?=
 =?utf-8?B?U3VaYUNoL0FaUCtWcWlUVlo5dHBLWVhaNGNBdnNGUGUvVFcxeWhURjFtU0d2?=
 =?utf-8?B?QVZuRnlXcEVUbHdveDA1QmNCRmRZZERHa3hzL3BZb3A2TExCMXhUQ3FiUHV6?=
 =?utf-8?B?R0FTam1PUDBUMElKblNzQXJOZFFjNTlXNmtZaGRLY0s5b1pBYkNkQTlaZFgx?=
 =?utf-8?B?ZTZ5N0JDeWJDVEV5OXdLQ3JIZzB6d1A5V3lqdERyOXdTZC9oKzc3OFJpdmpE?=
 =?utf-8?B?SGNobnhNRU1INzhwTi9BbEF0N3NBPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b0a1a2-09af-4629-3739-08db18c76d13
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 13:35:01.3247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5iSfy6ozGsKd3KWkgFoDlHKwX08oIBKfWXmH6QeceXYG0/7x/XZD5UPLoOR7FeoxZakUdK1yFM69r2VkAz4xeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7708
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/01/2023 10:19, Sushil Singh wrote:
> Add mgbe ethernet GPIO wake interrupt

Add the GPIO wake interrupt for the MGBE ethernet controller on Tegra234 
devices.

> 
> Signed-off-by: Sushil Singh <sushilkumars@nvidia.com>
> ---
>   drivers/soc/tegra/pmc.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
> index cf4cfbf..f4abc7f 100644
> --- a/drivers/soc/tegra/pmc.c
> +++ b/drivers/soc/tegra/pmc.c
> @@ -3,7 +3,7 @@
>    * drivers/soc/tegra/pmc.c
>    *
>    * Copyright (c) 2010 Google, Inc
> - * Copyright (c) 2018-2022, NVIDIA CORPORATION. All rights reserved.
> + * Copyright (c) 2018-2023, NVIDIA CORPORATION. All rights reserved.
>    *
>    * Author:
>    *	Colin Cross <ccross@google.com>
> @@ -4227,6 +4227,7 @@ static const char * const tegra234_reset_sources[] = {
>   static const struct tegra_wake_event tegra234_wake_events[] = {
>   	TEGRA_WAKE_GPIO("power", 29, 1, TEGRA234_AON_GPIO(EE, 4)),
>   	TEGRA_WAKE_IRQ("rtc", 73, 10),
> +	TEGRA_WAKE_GPIO("mgbe_wake", 56, 0, TEGRA234_MAIN_GPIO(Y, 3)),

Just 'mgbe' is sufficient.

>   };
>   
>   static const struct tegra_pmc_soc tegra234_pmc_soc = {

Please check the subject prefix for the subsystem by looking at the git 
history ...

$ git log --oneline drivers/soc/tegra/pmc.c
0474cc8489bd soc/tegra: pmc: Process wake events during resume
1ddb8f6d44ff soc/tegra: pmc: Fix dual edge triggered wakes
c9c4ddb20c42 soc/tegra: pmc: Add I/O pad table for Tegra234
74f7f183d81c soc/tegra: pmc: Check device node status property
...

So the subject should start "soc/tegra: pmc: ". Also remove the '.' from 
the end of the subject.

Finally, please use 'MGBE' in the subject and description.

Jon

-- 
nvpublic
