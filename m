Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7EC57845F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiGRNxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:53:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235550AbiGRNxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:53:07 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC11227CD8;
        Mon, 18 Jul 2022 06:53:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0tTMt1bReq1NRReIy4Kg5P3NgS82NRgsDzczUUqnaiscLIDxn6HImiQehtoB+tXV7RQ2C3EAhsskDELTrrtIYkOBx63PuBdsONDhb7dmk/04L0uyZAaDFHhxa9lPfifh3G9AEX/3ZWhZKfTKty8BfFbIfd9WXvA0tjI7CaTL3qhOgwgdDbcPq1fzmNyJAt/EG2K/4XJa2TK+F/LB6414NS/sFxFvF68nruAlzfajxpsMDGYsgF1Y1Gp7eKDOwECfRZjoSYUoqyzSn5vRNnumcesorzibfjRxuhQxOQpOynBz+BwaqPCsHoRkt8Qf3ZrvToyOV0DsIi/c/BwIMcD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFH586UD63xUU34H0YwWy9hjeMllCZ3f67Gyyo1q4V8=;
 b=QOJKPTG/WXu4SK5vCYQajp4GvAXrqwaA9A9WbO9AmvzPLNSsz4JJcYHKO358IZYaWDORfhF9lEGp8Xp6WjvzucQHz0tySGqCiaOQM8G4L/EUQMyL+sdc/XZtDM1cs+Po1Y6zYnkd8JywRPyeY7RxZui3hH8z/ANSNYX75pkUoWLJpvYwYV/CyMEeB9z39sQICcrKFWKIDm56MGA4Dm1C9m3LAHiMMIcV2YgXHtsIiKaHQn0Fk/Cm7Oau0i2ExuAU1hEoyDVGzt7vAWjHYRI10jWQ2hImpAFgvG6F2oleNMxi5NPDWoja57rO3YnwjKqXlXuIa6Oi4PTGRKBNT6zq2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFH586UD63xUU34H0YwWy9hjeMllCZ3f67Gyyo1q4V8=;
 b=pC1HYWhaVAev8QR00PMGI0b0vgGz1umWa35UO4xP0GCtv4/cQFf5PpMN5Xa/FvodUG3+nHEDK8/S/kwj+GF0XcA+tmkSNzZJ4ZqkTpNbal8dRZeAHfosYBH++MO976HPtcQJN81pzz1dABsDWbQH9MzZ7eBJV73gld+8bYt7g8fD+DPNjuKM2H65iwfDdQKiSOpx70wFt6u3rhszM9XU+UHwcxMmL85fXqKXq6jLGcechntgW14USISQJvTA4Sd2IYrfeDR1rP5PADmm7HF/VgupiSVt5w0IQeiEpCj3IBwttO7Cjp/PnpjZGRvxQ7N7hG3l8Q+CtEVWhEmLkgZ9gA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 SN6PR12MB2654.namprd12.prod.outlook.com (2603:10b6:805:73::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.12; Mon, 18 Jul 2022 13:53:02 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b148:f3bb:5247:a55d]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b148:f3bb:5247:a55d%2]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 13:53:02 +0000
Message-ID: <8de014c1-aa63-5783-e5fd-53b7fdece805@nvidia.com>
Date:   Mon, 18 Jul 2022 14:52:52 +0100
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
        Jason Wang <wangborong@cdjrlc.com>
References: <20220711150823.2128542-1-xukuohai@huawei.com>
 <20220711150823.2128542-4-xukuohai@huawei.com>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220711150823.2128542-4-xukuohai@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0647.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::22) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e1f25c6-4e81-4f4d-2a73-08da68c4d4d4
X-MS-TrafficTypeDiagnostic: SN6PR12MB2654:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bn98EjncJTcLgu62if2Ipli9yRaTWZHQ+WJ4xgZBvcorD+eUIPxptWHuH2EFituFPPjTmg0c1Fgok7pi4teTqCE/tnNBTFs5TAEf+dt7kdF+0p7eVZ93q5nLHBt3vNHkMTQvv7nwZ4VT7ZekU1Yd2qhlugJRcQHqzifSmfG/lslOukOwaNqmqHUKJJYQ+NHoihAhCPWp5w2jdydH74HjV5KsvSgrRmoGPut54Xgg2fyN5+rPSxQS/mzrdfcWQM+tMRJmKuBNO/siXieLeQtAkzcoR3gyP1fULQe1Z9iou7dSHOkAyKOl0kQL3wp+weNFNup4IJYDTAJkqVwQbzFzixskPMXdfMXcFXsGwKIiKMSsETb8LiPsRLKyrjcZWXayjCUHnPC5/XI8L0ozT4xriS+FkLBEpK7masIwcOCL2FoRIDTEJxjlDUq0gTMZn9V+fFme9stHUSjWIFZ7ZoLwz/9GcUgnjGyov5EJw65JadqO3VlvOy3l72XKkeo0vPd01wkdAT5GRO0YWwyYJj+hIO696irpkYOVLjw7HGkTkcrHi5aOCb5DZ4EfoXShe9fgLIz+hR8olti7OvK3qks3hhCoUQZwv6pgIispzilHd6f2vXpBqxJ51lLuu7QcI2N/1ba+SEZOEVPsYsDmlxrrD5vs21oUSMwAt43rz4C55kQoiACaBCQnX05cyLipzDQbpqAfYwDKdtB2Z827XoWRitlSNjPIeah7CbhMAIuaL+LfArhUQqXUOBS/PCjfV7q16UaM1UuyIC6ZLTSu4TPuZbYwJ99jU+aBtIAAR5BH2YadbCTwiyQFsY/LSPWDBwfQzXmVagWYrSAUyMd8ORePltHJHZuN6eKyVTzhlLB4CoQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(316002)(31686004)(110136005)(54906003)(36756003)(83380400001)(38100700002)(478600001)(41300700001)(66556008)(66946007)(4326008)(8676002)(2616005)(6666004)(7406005)(7416002)(66476007)(2906002)(5660300002)(31696002)(55236004)(6506007)(53546011)(86362001)(8936002)(6486002)(186003)(26005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTBtK1lyRUFOVDFkZ3RCQnlNMm5BUXJyS2R1Rkcwc1NYUWpGSGppTWhtYndz?=
 =?utf-8?B?eGpkSVB2WDFVZGxBRXF0UVFVdU5UUmxYOGRwOXMxRDNxeENPUFJTaXdNWE5i?=
 =?utf-8?B?eWVlKzNsd0lDRXA1UWJGR0ZsWjJ4eUR6dEZ5VEF0MDVUTnIrZW9vajhjSHlR?=
 =?utf-8?B?TkFWQU5uK2ZaNFNoVWxzRE5IKys5RHNMMTZnbTJCQnl6VkhmODJBU2pLVE1m?=
 =?utf-8?B?eXdHWHJROUVJbDYzZ0RkUEZ0Qk9TTGxFRTFKNWFxZkNPYXFSUXk1VUlveDdr?=
 =?utf-8?B?UFN3QXFYWHhLa2NSb0JvSFJCQlU3MkVpRkhSRzljRU51VDN5Qno4OHozOEx1?=
 =?utf-8?B?Q0ROM0xYRTVxNi9rU0EyMnJjRC9YMUdiVDBrK3ZQUElvU0VoSXhrT0VXT1Fk?=
 =?utf-8?B?NnNwbk1ZQWpnVjRDV0d1THBrT01HTUVWVGpXM3VMd1hKdXkweUt5aTJIbTlV?=
 =?utf-8?B?ZWpoRkxnRHd6cWpPeDNzUWdvZ2h1czV3N3ppTWhsZWpmYmZ5OXlTc3Ira1Ra?=
 =?utf-8?B?K3d5YkdjbVZ4YjYycE5MUDZoenZucytMYi9pSENSQnVzVk1iTlBUZ2V4amtW?=
 =?utf-8?B?NXA1MHpXdVNXR1VMRUxtanJ4UVRIS3A5ZXcraEljS0s4WjdSS09kNEFwaDB2?=
 =?utf-8?B?MklvbkI1bGJHUlozcmZDanV2bHRaSlhhU2hGdWQ2eWZSTHl3VHIrNENqTXNu?=
 =?utf-8?B?b0NBSXljakxXWmt3Rjl5b2FpaE1MTFRtTHJob0RGRWIvdXd0YmFoMCtybE9K?=
 =?utf-8?B?QVhDVUZnRzV3NGNIOTRmTTIrYXc1dUJnbHN6TCtManZCa29BNXRNNTMvRjJy?=
 =?utf-8?B?TG1oZnM4cU1aRmFqRnlBNnZHMFZYRjVGVFVTdTVlMFRDVCtiQWhqWmlnRGta?=
 =?utf-8?B?S3hBLy83b1FWQWxuNU5rMzNSUi9rNDhnUlhGWHJiQ1pTNnprN3kzd2xkQU9P?=
 =?utf-8?B?SmRFUU0wY0VMcy9VYTJPcXBQWitiMExNRGZrUjJISHgydjdldDJUZkxnaXJT?=
 =?utf-8?B?MVlZZWNUdmR4dFhrcEQxQ0FQVGliRVQva0hsejJxM2srcmY3K0pnK2hCUk9K?=
 =?utf-8?B?TVg1YWo4NytCNXZBKzJtczIxZWFmclBVcGJJNGVyU0h4allVWnpMdGY1L1Ru?=
 =?utf-8?B?d01mSlR6a0NaUjI2MEJzaGNneGltWGNjWGxhdkljV1dRNHF6bldpV1N5bkRL?=
 =?utf-8?B?WDNob0FwdjladUtFY0Y2Y2QzZHRHdEJ6MUFmTUhyWkxkeTlTd3pXTzM0eElx?=
 =?utf-8?B?NDBVdkdSOVFYK05xRVZ2YnB5MXYzcHBmWlpXRGRRTmxxY1dqVitUbnRQR0dZ?=
 =?utf-8?B?TXhhUTVBamxJQ3RTRGluVVN4MUl2bnBQT0tlWWhjNGJhQk5QL2NzczEvQlBD?=
 =?utf-8?B?QnBGcUszbmZzYmlxbXdXZlJqTk5RV0hsOTlScUlmOElwMlkyTlNBdWQ2My9s?=
 =?utf-8?B?M3E2L2s3eEFacXVOSmQ3TWh6bEJrTGFZMU9IanpjbEkvMVQxMVN4aGY0Q3J3?=
 =?utf-8?B?eXNWUE1RUXVMN3ByeEJ3cmRaWEpPbXJYVXdwV1FBYjN1aElFWHc0ZmtWbVhu?=
 =?utf-8?B?TTNtQUpYemJJbnoybkhueE9rZzVxcFNCWEF5WDVIQlVoSW5RcHdDL1dobnVq?=
 =?utf-8?B?VDhUWnR6M0FvYnlXUkZ1YjRoV283WjJ2eG11UkNFeG9SL28rYzNzaWhHTldx?=
 =?utf-8?B?cThtWjZjVmxoYjh1ZERqd1hHcjZBTHQvTDNFUWplYlRDWExhRlluVnhKc054?=
 =?utf-8?B?S3Y2Z0NnOFpLMTExR1lpbU1rKzN1S29HVVlGUVYwOU1wejYrcEo5b0MySlRG?=
 =?utf-8?B?SDd0LzcrbWl3UGk4SEgwdm1MM0FZeGI3U2N3QWlIYlRnRFBYVjc2bU5PK1Bs?=
 =?utf-8?B?VUVMY1NLSS9tcTRqa0Z3bHlWZ2pnRXVyOW9qYVpFd0lsUm16TDV6VXJkQmZM?=
 =?utf-8?B?d1dpTzMxdEp5WG40KzhERkFHcHV2Qm1VOStidFVCbGQwUmNLZmprL2xkSEtH?=
 =?utf-8?B?TEhudFd3eVppN0U5M1l5MU9EZXhQMVRHM3pwbGdCbXBJTDJiOTJQOGxMc0hO?=
 =?utf-8?B?L3htZHp4THU5bnRyNCtNY2d5c1VoS00zVmp6VjZkM1lGZ0YxYnNwbWZmdEdD?=
 =?utf-8?B?YXMxNlk4ZFhtMEw5Zm1BTVJsMHYwRXMyOVNOczBRWUpKOHVmVGtRdnFhenlt?=
 =?utf-8?B?Snc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e1f25c6-4e81-4f4d-2a73-08da68c4d4d4
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 13:53:02.3180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GBVA5Z1MBbF6GnZQJ6pGv+WtRCD56HPGOHNHacOPNUYRd4c9rG43bCP9vSNeuSVGXJz2v6+jTxjK4PRKQy3eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2654
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/07/2022 16:08, Xu Kuohai wrote:
> Implement bpf_arch_text_poke() for arm64, so bpf prog or bpf trampoline
> can be patched with it.
> 
> When the target address is NULL, the original instruction is patched to a
> NOP.
> 
> When the target address and the source address are within the branch
> range, the original instruction is patched to a bl instruction to the
> target address directly.
> 
> To support attaching bpf trampoline to both regular kernel function and
> bpf prog, we follow the ftrace patchsite way for bpf prog. That is, two
> instructions are inserted at the beginning of bpf prog, the first one
> saves the return address to x9, and the second is a nop which will be
> patched to a bl instruction when a bpf trampoline is attached.
> 
> However, when a bpf trampoline is attached to bpf prog, the distance
> between target address and source address may exceed 128MB, the maximum
> branch range, because bpf trampoline and bpf prog are allocated
> separately with vmalloc. So long jump should be handled.
> 
> When a bpf prog is constructed, a plt pointing to empty trampoline
> dummy_tramp is placed at the end:
> 
>          bpf_prog:
>                  mov x9, lr
>                  nop // patchsite
>                  ...
>                  ret
> 
>          plt:
>                  ldr x10, target
>                  br x10
>          target:
>                  .quad dummy_tramp // plt target
> 
> This is also the state when no trampoline is attached.
> 
> When a short-jump bpf trampoline is attached, the patchsite is patched to
> a bl instruction to the trampoline directly:
> 
>          bpf_prog:
>                  mov x9, lr
>                  bl <short-jump bpf trampoline address> // patchsite
>                  ...
>                  ret
> 
>          plt:
>                  ldr x10, target
>                  br x10
>          target:
>                  .quad dummy_tramp // plt target
> 
> When a long-jump bpf trampoline is attached, the plt target is filled with
> the trampoline address and the patchsite is patched to a bl instruction to
> the plt:
> 
>          bpf_prog:
>                  mov x9, lr
>                  bl plt // patchsite
>                  ...
>                  ret
> 
>          plt:
>                  ldr x10, target
>                  br x10
>          target:
>                  .quad <long-jump bpf trampoline address>
> 
> dummy_tramp is used to prevent another CPU from jumping to an unknown
> location during the patching process, making the patching process easier.
> 
> The patching process is as follows:
> 
> 1. when neither the old address or the new address is a long jump, the
>     patchsite is replaced with a bl to the new address, or nop if the new
>     address is NULL;
> 
> 2. when the old address is not long jump but the new one is, the
>     branch target address is written to plt first, then the patchsite
>     is replaced with a bl instruction to the plt;
> 
> 3. when the old address is long jump but the new one is not, the address
>     of dummy_tramp is written to plt first, then the patchsite is replaced
>     with a bl to the new address, or a nop if the new address is NULL;
> 
> 4. when both the old address and the new address are long jump, the
>     new address is written to plt and the patchsite is not changed.
> 
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
> Reviewed-by: KP Singh <kpsingh@kernel.org>
> Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>   arch/arm64/net/bpf_jit.h      |   7 +
>   arch/arm64/net/bpf_jit_comp.c | 329 ++++++++++++++++++++++++++++++++--
>   2 files changed, 322 insertions(+), 14 deletions(-)


This change appears to be causing the build to fail ...

/tmp/cc52xO0c.s: Assembler messages:
/tmp/cc52xO0c.s:8: Error: operand 1 should be an integer register -- `mov lr,x9'
/tmp/cc52xO0c.s:7: Error: undefined symbol lr used as an immediate value
make[2]: *** [scripts/Makefile.build:250: arch/arm64/net/bpf_jit_comp.o] Error 1
make[1]: *** [scripts/Makefile.build:525: arch/arm64/net] Error 2

Let me know if you have any thoughts.

Cheers
Jon

-- 
nvpublic
