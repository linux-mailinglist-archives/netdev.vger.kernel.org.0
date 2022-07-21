Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8A857C550
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 09:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiGUHaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 03:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiGUH37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 03:29:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4FE7C18F;
        Thu, 21 Jul 2022 00:29:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCEjn+1dm7myASDlhGPsFwKaZptUC8+i1aK106H0dzCFich9oyuazaEVAnxXLy+of4KTfAx+8tLxuVwoZ/4o9Xn0F8nr/WrRJBQq1SdUBo8AsikBc1dHvRXCkUI960hW47IhWJblY8H8qi6jH6Stc3L+WUU6Q9OnodjLlVG7ZVVk8yW4N3zmQ10kBX/r0J9Oyrs1qb10tAqQ+Pg4NjM8g051sUNVkKlPx2LTvqcPHBZsUME4tTRCz74wRnJmK25L3jD8Dg1YKyM0USINvMscX16fdE7Ylb9lMSbpbNYhCUkxMMBZHI8g93KXQCDuHF9W79uONGTg6eVLJSDXd8kV8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5T0C8aOo9b6FhF5pZ4csIR8wyCuXBr3xKu36QMrZ7z8=;
 b=G4Z3TyzW+EYGD4/ScUXdDzpszmIr0StGAxw+gKUEY9n9f9TxP0rSkAOmWuFh0N8UyVX2CvWHKYW2bMXRk2BfEqPFdbtp0MTu2HUrA1/v+8T0JgqGpmxsprU0P+4nnnjRRi3qnO4EpyRJIDqxmsKeqBSW67Rf4L2gYqjP17UYaVa5dQ6Xv5xHGuBDr4XFNvgklVv1ARkX8NRyc6OtAy19exvidODhocdezJ5gtkAijyLWNFuNeiknNqbfg1vPTLgURHJ9oh3TyAEnQyoAGq+eJ8nBoIoaZFGplSDYl+BpVOz8HBQP7M+i3/SIR57X4f2cMh8on1PwbbKCWWu2YTpleg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5T0C8aOo9b6FhF5pZ4csIR8wyCuXBr3xKu36QMrZ7z8=;
 b=I/v6dPwAK7BX7FjlABozaybttxk9CPpSl+4dAVZckm3sldGQn5huzH6r4oeugyQ0NT39tIBGK1bz4CTOP0vCMyF+wWY+I4xeHyA+pFwTJ5pYi+BeggOv1wQ+vKxOcEiq/20YC2JB/YbxzDZXNHSPA8N1Iu0g8nwYo+1XM/P+7j7dufOg6vqWGQbLKKxyVgdxolsNebe7bVgRqGO5siOdjuSCgiygast1UNvyXnr8KeYJj0/jCu/2HvnSLfOAm13KK+A8vCXPt8sL72U73Fnjyqs0bJa+WNWVPDgAdFhfxzI1I5oOCyDywqTHm86fR1h8VLvthu1fXBdGhkr6H7svjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DM4PR12MB5261.namprd12.prod.outlook.com (2603:10b6:5:398::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Thu, 21 Jul 2022 07:29:56 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b148:f3bb:5247:a55d]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b148:f3bb:5247:a55d%2]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 07:29:56 +0000
Message-ID: <8489a831-1785-fa8d-183e-22fd841b65d0@nvidia.com>
Date:   Thu, 21 Jul 2022 08:29:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v9 3/4] bpf, arm64: Implement
 bpf_arch_text_poke() for arm64
Content-Language: en-US
To:     Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Will Deacon <will@kernel.org>, KP Singh <kpsingh@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220711150823.2128542-1-xukuohai@huawei.com>
 <20220711150823.2128542-4-xukuohai@huawei.com>
 <8de014c1-aa63-5783-e5fd-53b7fdece805@nvidia.com>
 <b0e740c4-9630-c539-e811-a4ad93fcca5c@huawei.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <b0e740c4-9630-c539-e811-a4ad93fcca5c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0112.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::15) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c732355-f296-4e52-78ed-08da6aeacf5c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5261:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2wfmp4/Bf8awLOImF9AC6etEIQF1KYWVFAk6ha2+oZT7VxzLOw6gbZ0Jc7s+A0R5GjSx+4/tRBarLCIl4b6XlsecW7tbweACveMCm9rlelfJA1+aulCT8UKdt3wHG9z61G4T5RQunLe+1e02GZAWYhhOO74MKG7XgbAAQSn8rmoddqXavEEL/03YTvL0kSldXVLK4i2nUeBg1Im7Uw/5bHGkYhsbyzLu7ogVhqQ4Y/LHdHRTefy3pLRLJFfwNH+C5C73+UDr8dHRpjI/+tZbRwD9P4cp0xTl9k/AcTh3qu1a81E0LaavUs3vw7uLWv4GYYnjJxcQJdhQnSp1r/kwFpsN37yVvVYPsd9oJ3qI7afS5J9Q13uBLhh50LTCIFd/EMWh+3xqAG+FoLwYLQNqGnskGhc/th1JtMTxtjN5YnETt8OKa81uH09ETRW7/zJ30GTf+FpsSDAP7SjVJELTY/0+o8id4+MiyqfSSvdZEBdGnb4CmWDc1tT/j+c9ZQXLM2Vc9l3Q+pGeQB16fAK4TvMKMEM8Uhx3MUdIK48LeKiyWoXKd1fzJDST6rDmrS2wYuypSm55n4yYHwPlZE96NQ94G2X2ELBr90Y6hKV/siw0mUiKqsHoZ96bCMOzCOR4xPXgTxMDEf5T10f84Ry2sWiz0eu1S3IZR/S3p8eHU0f7AgnApXBO/rBqmmknhj4DzOitFGDc/sNe3+X79QJrONyKXQe83EQRXRFzw1WRDaVYob2KXit/P47AKh1eCQkJ9H7X+IOtOgV2PnH2ZiASvAOGLM952+Hu4lTToBRtJ9wlqmKBnKSCmqQiEpaOZN9h2R8BB8Y3pmBCUtGY3AJ6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(4326008)(86362001)(2616005)(478600001)(186003)(55236004)(6506007)(8936002)(53546011)(38100700002)(6666004)(41300700001)(2906002)(7416002)(5660300002)(7406005)(6486002)(26005)(6512007)(31696002)(31686004)(83380400001)(54906003)(110136005)(8676002)(36756003)(316002)(66556008)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1czWWIxWUQyL1hHM3A4V2lnRGlncWFuWWNEY0pWMXZqNkttMlpURXRQMzhh?=
 =?utf-8?B?alNtMW1JQnU0cXNrWW1JRjl0RHgzMFlOQkx5WHI2ZFh3amlQOXB2QXBQZklY?=
 =?utf-8?B?eGdjcFBJWGxFeG03STJ2dzhXNysxR3orK0FYakgzTUtKMCtUQTl6dk5WSXdW?=
 =?utf-8?B?cEcwS0cvYkdRUDNRZXJTQTVpNk1rbWl2WDlrRXp1bGNZcFhZNnZFdk0wTmdh?=
 =?utf-8?B?UjFzRG81ZERVMmlValEwSS9VUkQ4KzhHMW8rNTMyVEJsaE1XS0k5NTY3S09s?=
 =?utf-8?B?MGYwUEl6aWRRZDZoMDdzcm0wMFZQUUlwWW53d1ZieEE2K3ZMd0lsTFRiVTU5?=
 =?utf-8?B?eE0xZkY1K0txbzQ0MWk3a00yMWdFUmFMdWRLdk1FdGJSbUVYVnJSTWp0Q1E2?=
 =?utf-8?B?VCs2SUYzWlArMjJvbWV1MTFtdUV4QlNOaWVma3pwRUtmcWFSbzFPM0FTYjIy?=
 =?utf-8?B?a2o5S0xkMFp2U2NLNFR3bFpMaHB3UlptSlI2eXBvcU4xQ3hEblg2NGpZbW9Z?=
 =?utf-8?B?a3owdU9HaXp6ZlA0anBUbzV3cCs4WGRtRnRTLy9ObEUwOW9VSFdMMWJYK0pl?=
 =?utf-8?B?aFNpSXV0UkJFR21iOTU3UmFUc29Nei9tUU9aUDVaUFZDNTllZEttZlRNV0RH?=
 =?utf-8?B?cE4xZWM0encvN3k0QWcxTlQ3a25rTVBMVWlLMzkyQWk3TnJYRUJqSDdKRzZy?=
 =?utf-8?B?MWwrVEkwLzk3NGU4UXduYWxRcmNzdGZhZzg5eWw5cXl3eXBkYjBLRVRGaWcw?=
 =?utf-8?B?L3BQaW5pcUdqZ1JsMEJvLzNzOWd5OE9mTzJVV2I5WThKRkRhVkxiVDVkUW0w?=
 =?utf-8?B?bThXVU14bHozNlpIM01DSDFKRXFkS05wWStUQlZUYkVJenZPREtjeVhpWVRT?=
 =?utf-8?B?NXdmb3dvd3Vtb1JndzNTYnRlRUE0and1WWZRWTRUSStQUlVRY0F2b1ZwWWZX?=
 =?utf-8?B?L2FNaTA2cEtOZ3duVlhvMGFIWXJtdDBoTmNxVksvT1I2S2MvUFZLenRUYnVo?=
 =?utf-8?B?TUNCSDRYRGZaRmNlRWNOMlZ2Ykk2bEYyRHhEaE9UTjBVUVRuKytmM0h0dTcr?=
 =?utf-8?B?MnliT2JSRlA2MjNUQm5DVWJhQVBxdkZTY1FNRUx1eVFOdTZ2RXUxeWRmYlFw?=
 =?utf-8?B?OU9GM0gwa3N1WjZqZnlUVUp2WjhEVWhlUmMrOCtEdE5IdC9qME5yU0hsendM?=
 =?utf-8?B?NnFCYXhsT2gwZktGcFprTFBwS3Q0T2tmVmY3RzRBOXYvNE5EYVVJQTVvVDc3?=
 =?utf-8?B?QmZmSjVTdHhza0g5RWdwQmxlNkhhWFo0VHFMT3JZaXBDYnlrTFYweWpQWWUx?=
 =?utf-8?B?WXBVNTVpUURObGpyVXVHVDl4NlNoVC8zL3A2REV3djA3WFlwQUJtWjg4US9i?=
 =?utf-8?B?OGZod1FnSnhCK1VTSXlXSWtDNXBpVDRRSGRsVzdVQzNCVWNnRFFRNVNKZXor?=
 =?utf-8?B?RERlbW8vejlPU1BYS0IwbzVBdVp3am5wUDdreEtiS2pxVGM1eW5La0NHUFJV?=
 =?utf-8?B?RnRVZEFNWVVER3dtN2x2czBxZ244elZ1ZG8xRFJYSkdDekwyZEdqekZpbHha?=
 =?utf-8?B?c1FPU3VhVlkzcTBtSUJZT0dOM1AwbmZXb2FWbU1SRnRzemZGL0taTnlmY3Y5?=
 =?utf-8?B?LzV2Vm1sczdoVmxJMmYyc0FUMTFWMmNPOTBWNEpTTklDV3B6OUx3K0g3alQw?=
 =?utf-8?B?OXNpdHg3T3BrVUNTU0FrS3NPakRkVldUWEdEbjNCRkpmVzVPUTJoVkVscFFV?=
 =?utf-8?B?eVd5UHNjdE5kTzNYUk1HSFVYS1l6U0FKWjRZeVNoYmZVbHJVUVliSHc1bG9p?=
 =?utf-8?B?M0puaTg3Mi9PZW9qYlU3bVZ0UWxobEEzR1E4bEQ2WG5zZS9GZG9PcmdEV3Bj?=
 =?utf-8?B?aWV1M2RQaWhRN29vbXR6S2Y2Y1RCeElnR3RFWjM1Y3NtSzVENElOK25nVWVr?=
 =?utf-8?B?NW4zaWFqa1A1WndibUxYK0JTNFBsTGZnOXpUNUhVWEVINUtMVHZpTTQwUW1F?=
 =?utf-8?B?S1JPY2ladG1IbTdTRGo1R3FncllJM1ZVYUxoNHh0cVVNTkI4WmViRURFTUUx?=
 =?utf-8?B?ZldrdG40QXJCb0J5UnFpWEpHbCtkR3JudTlXaDNtUnBiQUlCa0FvNlg4Q0dU?=
 =?utf-8?Q?/p5DstSnwHYiCXMVHXYTFx5ad?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c732355-f296-4e52-78ed-08da6aeacf5c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 07:29:56.3930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kG3Vh1A5NbKMoNiC9YnLWfuNkGjiwaCJTnqzHupj6leQrEMKPONebrSXH6UwjN1dtcyvwSZ0nOF4plo7nPunKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5261
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/07/2022 16:37, Xu Kuohai wrote:
> On 7/18/2022 9:52 PM, Jon Hunter wrote:
> 
> [..]
>>
>> This change appears to be causing the build to fail ...
>>
>> /tmp/cc52xO0c.s: Assembler messages:
>> /tmp/cc52xO0c.s:8: Error: operand 1 should be an integer register --
>> `mov lr,x9'
>> /tmp/cc52xO0c.s:7: Error: undefined symbol lr used as an immediate value
>> make[2]: *** [scripts/Makefile.build:250: arch/arm64/net/bpf_jit_comp.o]
>> Error 1
>> make[1]: *** [scripts/Makefile.build:525: arch/arm64/net] Error 2
>>
>> Let me know if you have any thoughts.
>>
> 
> Sorry for this failure, but I can't reproduce it.
> 
> I guess maybe your assembler doesn't recognize "lr". Could you give a
> try to replace "lr" with "x30"?
> 
>   #if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
>   "      bti j\n" /* dummy_tramp is called via "br x10" */
>   #endif
> -"      mov x10, lr\n"
> -"      mov lr, x9\n"
> +"      mov x10, x30\n"
> +"      mov x30, x9\n"
>   "      ret x10\n"
>   "      .size dummy_tramp, .-dummy_tramp\n"
>   "      .popsection\n
> 
> Thanks.


Sorry for delay, this did not seem to land in my inbox. Anyway, yes this 
fixes the build issue for me!

Thanks!
Jon

-- 
nvpublic
