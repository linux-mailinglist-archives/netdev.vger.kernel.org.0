Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44063589B22
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 13:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbiHDLko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 07:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239128AbiHDLke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 07:40:34 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2068.outbound.protection.outlook.com [40.107.95.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F4EE3B;
        Thu,  4 Aug 2022 04:40:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkDgQDkTXh7/2FmUNEm7ubKwGmnIdtXaLJ1UQZEWF+m1TNDb9VAKo128ItzVhx4swD9knR22p49fTVmCl5/3g0YrbOyzmx6HWVtrYqBLgzkKdfK1X/jHTvE9oQtsmIrhuRUP5n7TldBTGRs25hDT5MizxKKy9OXOAo57pftC5ORv6ld2ubT+9KI3mWKhjKvy8WJCLpU8KAbvkjpwvM9RgyqfRH4oDmz5inxRqcQcIn416cL66Wrzw5nMKF4pe5EY177R+FLzlLAJZVh9oYvxFev25OLRpv6BpB9TSnIIjejBIv/hqZafzz4Fucpdh+npjSIdzN00x8ADPJYX3Fl69A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14wPZRhAYvtZTqxeN0W5Uxb5dhgwtMIdWmK0vshLmp4=;
 b=e/EylboAzh7snWdOUYkDkz9hg0T8NX9UY3yrjAkRl7DUU7T9iNJ2AXDoK0nL7sz7d3rpuZgC/2q06KSVQlh5mO0s2kRv3/KiqDcPOiEITp6yBlIW8cGsJqZin5PTujzfzVPuF1tR2JzT/GA+9DVAACprlZHmV3Jmep9rT/HdKVt1VdjIoIfYvaT+JZnMgse01m0ko8ThRPxb/bKOM0U/WWJd+T/PTbOwHaCu6YAXMM0Vi/F6C+NX+MelzenHnTYUzNiVu4Bbnu6B88GUQVxes6hqw5DmUBmkPj2F6e4x81corOe3dV8+uPyR5+uRwJmjJFnkxGR0P17EQgoLoLNqWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14wPZRhAYvtZTqxeN0W5Uxb5dhgwtMIdWmK0vshLmp4=;
 b=osT72ZhFJn5HUBSq+hMgwvjfitUAL4OkUSkpNVlB3p/nyTVMkxQu88lYIi8Mw0nNCBMV4HFUC+VgruW9QUE+0PnMAOyyuyLhgBAQUkoIiPlvENAR1PsLRAZkUdxomTG20pK9eN0Ax26ngLTnpm+aH037YSIBFQm2BxsnkxQn2YB2YtrOLR0V2ijT1XR1u6wmDcs9UnjWjxbta9tLvYe3fTv9+Y/IIMrI3CNuw4YkPRDuqLjO49ccpdfoPH+FnzrK6Yl/DXiIiCL8mO5fMQVAdqNqavA+sKsz0BLpBxyo7s/m75UpJZdY9r6eMzPujQBH4VmwD1zAU6aIrmIhJ7VkHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR1201MB2490.namprd12.prod.outlook.com (2603:10b6:3:e3::20)
 by CY4PR1201MB2484.namprd12.prod.outlook.com (2603:10b6:903:d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 11:40:32 +0000
Received: from DM5PR1201MB2490.namprd12.prod.outlook.com
 ([fe80::3870:f6d0:1c15:eee4]) by DM5PR1201MB2490.namprd12.prod.outlook.com
 ([fe80::3870:f6d0:1c15:eee4%5]) with mapi id 15.20.5482.016; Thu, 4 Aug 2022
 11:40:31 +0000
Message-ID: <228ceba4-47a8-49ef-994a-fe898cdc7fc1@nvidia.com>
Date:   Thu, 4 Aug 2022 14:40:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net-next 1/3] ptp: Add adjphase function to support
 phase offset control.
Content-Language: en-US
To:     vincent.cheng.xh@renesas.com, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <1588390538-24589-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588390538-24589-2-git-send-email-vincent.cheng.xh@renesas.com>
From:   Aya Levin <ayal@nvidia.com>
In-Reply-To: <1588390538-24589-2-git-send-email-vincent.cheng.xh@renesas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0076.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::11) To DM5PR1201MB2490.namprd12.prod.outlook.com
 (2603:10b6:3:e3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73aa4277-e555-49e0-6948-08da760e230d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2484:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgPQTA+jjWVVFAKR/QZQXpp+gY2WEmBcsPJhaS1TvX6qsXQnfdE/Lv5KIauO/Z5jEVwKBFMHMYvycdDCjr7vNUfENNc6OxGOjo+nCpgdh/qha+16YxPIUe3nsyJfOlzKUUGkGt/ZGDfjwHvNge5xdhoNqg1Yq1iOcR8MkpnR86+UUaIJCoc6meM0OkyggmoqDvjY8qjrMomqxVGkx1e4l0pnfM+i0l4ReAGHTPcpZOnRa+BkHVO5r3euv30hSkqEFr3YVOfPUODzRhpeJeCy5HA7mMgFa/BnZtB/odx/6woBSFsZVkhmxWYc79fig/PPlzxIEpA/liTkfUmBeEIk5hQGgxS+DvRdPgDUFz12YwE+MycUL/+ufPRQnAwqNZ0mq2LkJLq+A7zHMzTfOXnxTBER1STgbgQHW4pyB9MOOXWh82xODACw1///Ut9AbA3UzGp2Oyl1Pd1oC3SHjwbr7055OgxBB43J/gtnokbGkYlCZLNjHmlHgp4eCfxGmLqoV0MxYt7N+ExoBCzgdmcMjaI4jTWF9MvAm+a1qjmBJkc/SN5Gv03D6U26W9Qrczi1ihjUj07AHj7OytF4/xSXkw+mL4YZAbKtXS6vSql2eDJTmTJgNuJZTqZ7rGm82nRZROALSXWLBs/BNzanWkAxOh/0uKoEddeheBahi57OwrMhitfjrEphvN/J+aM68gZJSmFU3UPn4PB7b3+sUzRhpvN75ywOLV3W2DouJf75o0IV6zHac/GoclcHy7B2q8hvwsN0kMp8gRpAFyEzCDTpnN0t7DQhXAHGtx4kmmdtrl2nfTjSSnLTc/J8/A6qmDnrhClEMO4eIv8XBx1h0XBpSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB2490.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(186003)(31696002)(6666004)(6506007)(53546011)(2616005)(26005)(41300700001)(38100700002)(83380400001)(6512007)(2906002)(8936002)(36756003)(5660300002)(478600001)(86362001)(6486002)(4326008)(66556008)(66476007)(31686004)(66946007)(316002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFVCZytWREwwYnBPUmQrRytTejdpcHM2dk56WEJkdkRIcXZGamV6WkpmSWow?=
 =?utf-8?B?ZEJtWkVsNUdZYlh1RkRZNUx6V3NVVXl2ZEdTL2o4NnU4eG43ODhNYktVT1Rs?=
 =?utf-8?B?NjZZQUZaVDhZaGQ3aUZvaGNJRlZjZzlFWXpsWVJ4YXFJMGJHTEZsRkY4M3Br?=
 =?utf-8?B?SVptaVBXTEE5QkpyVWZVRmlOVXozNStib0xYdnQ4R3hsL0xsZEZtb3VnQVlq?=
 =?utf-8?B?bGhuT2IzQ2RkTTRXa3ZHTk1CTWlCWlVBdWVFUHhXWmwyN01KNVQzQW5KTTVi?=
 =?utf-8?B?Q3NPdU9XVGthYjJUNkV1TWRuVm5PczFJMCt1VXliemhuOEVDOWJMWjVxSU9L?=
 =?utf-8?B?S0pDQ08rcVFJSlBnREs4OEZDazNLMEdnRTBQQjFOKzkxQnBvUll5U3RBOHJE?=
 =?utf-8?B?dzllcDhqeUx0L0tVbTJ2S0NZNG1MemgwSllMY2dxVTlnWFk0R0orV0t2ODNY?=
 =?utf-8?B?YXA0aDdvWlAwWjlqOUZzeTVoTVZJenpWeUw4UHZpdmlKQjZrcUhiUk55Tlll?=
 =?utf-8?B?YWYxY2VDaDBGQlJ1Y0ZFK1lnWTlDWVowQ0huR2VHS3VrTW4weUJvWmhkTlNx?=
 =?utf-8?B?ZEhFVGhnTFpoV0hFZ0wwaW9hMEVHSFQwbjE2dGRtZGdFSjArYWgwRGlQdTNY?=
 =?utf-8?B?cGhoRVIwNjVXRE5TS2ZDdFVmZGwvN0w2RDBiWUpwNXJnbU5rYmpBZWx2N3RO?=
 =?utf-8?B?VHNMbGRvWGVUUzR3amQ1czRWRis4K1hSQmxkakdVNFcxOHlWVHVlanp4M3Bs?=
 =?utf-8?B?czZ3N2h3cE9vaFBqaXJ1ZmZsRWVzNVQrUXQxdVJNOTBwMXFiYjZqdGdvMVBS?=
 =?utf-8?B?UU9NSUFzdkN4VmVIS2NRMGxDSlNJTjZjSkRrNVBmbUlXSlRNWnl0VXFHWlJM?=
 =?utf-8?B?d2FSa2Zwekk5RWhQWitkcStzTk03T3BPMXJFNXRRNmZxYWd0emc3Rm9FQ25h?=
 =?utf-8?B?N2FSa245ZlJUMDlvQ1EybHJsTXZrSUZzZC81UWIrU0Y0dCt4VG9IbCsvVndP?=
 =?utf-8?B?My9rTmhQNWxRVHdpaGMwdE9KS3lkeGZhVnhEZS9mNnNoU0NzNnNtbEpLdlBa?=
 =?utf-8?B?SXBsUG9ISHVBVmxSMmowWW91WkVnSVJOc2xMcWpFNGE0VGNWa2NoRzVNY2g3?=
 =?utf-8?B?UENvbzVINVdwODh1VUQveGJSOWpHY0djYU9ucTFBNXFzeGowWHVPdmZtajNR?=
 =?utf-8?B?YUxvUXZRR0RpSitCQUVnRWZmREt2bjB6UnFuSHUwV1ZwbWk5dkFBSDNvWHRP?=
 =?utf-8?B?QlFJYksxVFV1S1R0MjA4T1VxNjhFN1p3VlB0Y1V0K1BsaXpnVkZCYkcreHpj?=
 =?utf-8?B?WFI3bW4yZFZXN3FiMVAwbG8rSE9ZNUd3YzEzUkdHUi91RkZRQWZEMllDTjhZ?=
 =?utf-8?B?QlVEL3hCc1JjZFlCck5VK0ViQmovakRsMmRoeEt1ZG5FRjlMMHB0NnJwWVo5?=
 =?utf-8?B?WnVOUWc4WUFFOUlJR1BkaW0xQTJzaWpWWENBT1pUQkYzcklKRkcwVHVCSXR6?=
 =?utf-8?B?UTU5U2gyTGdwS1JkU1NKYlh4ZU1IbHBOT2dkS2lxdDNCT241OU5td21JYVFX?=
 =?utf-8?B?bVVOWlE5TGtGdk5QakdwRGRsanFLSHVaTmxUbEFNMTIyaEt2NEV2akRzNmNS?=
 =?utf-8?B?QXV3SkZtekxRbjlTaksyNXlONDQ2UTMra0FiNkZzQlNZZml6SW5KNGp5YjZr?=
 =?utf-8?B?WG5UOThLR1dsb1lHVHNPYUhMQWtwUXBPWmJRc002SGxrVkV5T1dGd2ZwS2NP?=
 =?utf-8?B?N0pTR2UwR3d3STgrNDg3SHlhZDIxOE00WTM1SUFDM3d1MFQ5ejNSekwyU0p2?=
 =?utf-8?B?dDBzRTRmU2c0NmFLV2xYR0lUcVVtRDJKYWsvbzA2Mlh5RWsyNHZ5VFRIa3li?=
 =?utf-8?B?Ri94UStSblhwd04wQlZEK3BFWUxDWFo1cDNrejBaWHREM3VIaEdrRGZGcUh0?=
 =?utf-8?B?REc0TytCNlA0UnprZFZYbU43bC9kTG5TcnZ1UGVvZXNPR1V4c3JqTU40UERh?=
 =?utf-8?B?cXFmd1hubU80RGhkMWI5a1QwaEttTnZHZXN3bGxEOXo1VWxuQzhkS2xUdys1?=
 =?utf-8?B?VFZIY3E1cFVzai82bHF1akVSTmY1WUtxSjNNTGlCUzl1Z0RrVmFSOG90UVFi?=
 =?utf-8?Q?MhDCkRS8Bwr3+/VgghU0ogokE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73aa4277-e555-49e0-6948-08da760e230d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB2490.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 11:40:31.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NW5GNHih8FnsPQf1+UT7yDXrOeXSEAxLHAiN980svXDvnw7zN/VzMol2BzF5EW76
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2484
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/2/2020 6:35 AM, vincent.cheng.xh@renesas.com wrote:
> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> 
> Adds adjust phase function to take advantage of a PHC
> clock's hardware filtering capability that uses phase offset
> control word instead of frequency offset control word.
> 
> Signed-off-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
> ---
>   drivers/ptp/ptp_clock.c          | 3 +++
>   include/linux/ptp_clock_kernel.h | 6 +++++-
>   2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index acabbe7..fc984a8 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -146,6 +146,9 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
>   		else
>   			err = ops->adjfreq(ops, ppb);
>   		ptp->dialed_frequency = tx->freq;
> +	} else if (tx->modes & ADJ_OFFSET) {
> +		if (ops->adjphase)
> +			err = ops->adjphase(ops, tx->offset);
>   	} else if (tx->modes == 0) {
>   		tx->freq = ptp->dialed_frequency;
>   		err = 0;
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index 121a7ed..31144d9 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -36,7 +36,7 @@ struct ptp_system_timestamp {
>   };
>   
>   /**
> - * struct ptp_clock_info - decribes a PTP hardware clock
> + * struct ptp_clock_info - describes a PTP hardware clock
>    *
>    * @owner:     The clock driver should set to THIS_MODULE.
>    * @name:      A short "friendly name" to identify the clock and to
> @@ -65,6 +65,9 @@ struct ptp_system_timestamp {
>    *            parameter delta: Desired frequency offset from nominal frequency
>    *            in parts per billion
>    *
> + * @adjphase:  Adjusts the phase offset of the hardware clock.
> + *             parameter delta: Desired change in nanoseconds.
> + *
>    * @adjtime:  Shifts the time of the hardware clock.
>    *            parameter delta: Desired change in nanoseconds.
>    *
> @@ -128,6 +131,7 @@ struct ptp_clock_info {
>   	struct ptp_pin_desc *pin_config;
>   	int (*adjfine)(struct ptp_clock_info *ptp, long scaled_ppm);
>   	int (*adjfreq)(struct ptp_clock_info *ptp, s32 delta);
> +	int (*adjphase)(struct ptp_clock_info *ptp, s32 phase);
Hi,

Please explain the difference in the output between adjphase and 
adjtime. I'd expect both to add delta to current time. Am I missing 
something?

Thanks,
Aya
>   	int (*adjtime)(struct ptp_clock_info *ptp, s64 delta);
>   	int (*gettime64)(struct ptp_clock_info *ptp, struct timespec64 *ts);
>   	int (*gettimex64)(struct ptp_clock_info *ptp, struct timespec64 *ts,
