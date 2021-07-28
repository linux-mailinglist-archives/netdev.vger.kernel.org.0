Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3263D95E3
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhG1TNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:13:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33190 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhG1TNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 15:13:37 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SJD3UG027374;
        Wed, 28 Jul 2021 12:13:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=r8eHGGPl2CTgPP3Xokq4NKthbNtbxZKKrd6WIBryVMY=;
 b=rDjXP0lM7MMNhLwfqvywmJFmbi8E0seK/MSx7Chrp1QSZq95EVX6FiS7oNS8MbfjWGoL
 lQrpQ3/3AscE2JhN7XTIsWM3JwhL7OV3POMcRjUE94f0pv0Z9Sh/VCqdGrwhe/lx67Uo
 2d+IAhWZvWq9Pqt11o00VkFwX5+Vxbs4BYE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a3bu98ksu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 28 Jul 2021 12:13:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 12:13:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D2Yd8Tj0dn3AiQLw7720iSMC4At1PP6kw4uBjKvrS1T8KGYodUmXysgBdj9OF9IUS/CPpSDylBjW0VfTpurQTJ+GSUY+PrCBzC8MwtB4Tm2Fnn67Rwkh5oyUfy9OU+atbZf2YoX3fDu4bm+qL99Ajcm2W4EOjk5hzqvW13fdV1Fez7UMRVGMaQBGg+Lq7VLhy/JpOSzNtqTHLFkA0+N8mukRkHS/HrU+ho/jD+7Bp5JCz0u8sKSawyps7yx9aBAqetPTADffY+Bi9UfL+h2nUVdXC5f4WzxlAcnUzh9NBXCFUQyBzFojCFiiXn6Xb9qac9+NhWDTPQnGvzt7VlPRNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8eHGGPl2CTgPP3Xokq4NKthbNtbxZKKrd6WIBryVMY=;
 b=lchxeWBOPgRKTizqIDD3e1xctXlLa54odfJTqYLmGBzfj9oZpxXTz58ub7kPqEwgOeBDt0sT3npbgv520xMfYo1K/HR1RiYlF9OyG/O5R01Lorle9LQGDRBG7V0498kh2AK1Ej8Q8t3YTkfa2vfKLKh6NHvxcPqdcNSQiKLmh+1sn9clZ1pdWQCFpFcNJWV5fk+taF6SxtWJsTYH5m+JnOb9MlTyPIkhimlCdAR+BMAq4VES/TNUTl7GQqwUyL++azNn7oRoVvaQdNrLAoLxGadsx7FGxUCJczlcoIVN+PcNHpxdYsaQ/rh8aefyQr8puFA9y0Io+J6Ki4C54tTOwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3920.namprd15.prod.outlook.com (2603:10b6:806:82::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 19:13:20 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.019; Wed, 28 Jul 2021
 19:13:20 +0000
Subject: Re: [PATCH] bpf: Fix off-by-one in tail call count limiting
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>
CC:     <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <Tony.Ambardar@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
 <20210728164741.350370-1-johan.almbladh@anyfinetworks.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1503e9c4-7150-3244-4710-7b6b2d59e0da@fb.com>
Date:   Wed, 28 Jul 2021 12:13:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <20210728164741.350370-1-johan.almbladh@anyfinetworks.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1398] (2620:10d:c090:400::5:8298) by SJ0PR05CA0050.namprd05.prod.outlook.com (2603:10b6:a03:33f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.9 via Frontend Transport; Wed, 28 Jul 2021 19:13:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bca9ff7a-cce3-4aa7-4042-08d951fbc320
X-MS-TrafficTypeDiagnostic: SA0PR15MB3920:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3920E1E128679F22E2FBB168D3EA9@SA0PR15MB3920.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jkz3oG5CUN4QAXxNxsl/F/dPEaPnKvZmjww4iA+I52XqOL/V9VLun+VE5VQQvpwTP2gfggd5r9jhkCP7Tqjxbvezn3LuUa4JwRWBJY2kMwc/LlXuBZQ6Sh7966+3MEvIvfXGYgz3JLPjseOhyfX+W0xKCmFw2b40zcZPe7uiFqgwIXljAMpiu2gWCBfccabK990baGGA+sC4kw1g1Ndv1uY6e0yf/qawxlgY5A04ddMDwQtpW3L/XAaJliZGV4njrx8ZdP61DutUAvA3h7yMWj1NJk1sda0BISB5Dp6FJM43Y7ZyOOn+rdREPnbgJH3H7e2SM6Eu3/rBG+pp+oc6WEz/4iWsJ2UpNTTs/g6qUYtxfs+07mL/RTYhNcCf8yBptWcRODHUtOmsGibHFhe+4imIkZKw0NUtTeIoiaGzrv5rVskqZITRU7pigTx6ecLkjt5ng06rp17KjjEUV4ml1KvdztOTEYiKQJkxConmJ/LHeRQC0vyxP/Y5oXwSSz/toKuh/9su2T1vmXQXD1MIJLS0DysetjO4cDF8R2cM4RlLY9h+fG8crz5t9csPPR7Cv4waFOfFXpyc1Eqs+kWeiWg0b7tpUQirdjYei+R2EmZRfElkqGEUaJJTnU5GsC55VwHoYSjSKUpAo5CUBaKIp0TAO7I3rlHWAzpDv8423Eqcn3vEdtci+JgknqRh0AM61B0zCnGnigW8zxaCHJo9a51Rn4gygKOdB5ncuRn3loE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(36756003)(2906002)(86362001)(186003)(4326008)(52116002)(38100700002)(2616005)(31696002)(31686004)(83380400001)(8936002)(66476007)(66556008)(8676002)(6486002)(478600001)(5660300002)(53546011)(316002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnl6cXFxVGhNdE5jaS9meFF4b0VuTlJob3VoTk5qWlJJbzNEZU95bm5iL0ZY?=
 =?utf-8?B?M3lZSzNkQ1UxMmg0MldmMTRuUDhScHlqK2NWWGVqSGloclErdUVIZnBwNG9G?=
 =?utf-8?B?THM4Z0M0dmdqNG1qN3Zsck41MlpPQzBEY1o5NURrNmtPbDdqMmUyWnZDS2o3?=
 =?utf-8?B?TWpINnhNaTUzL1Y5WEttL2gyZ2xCbzc1MzNhYzFMSXdFMkNrS3gydUtUemZN?=
 =?utf-8?B?TkQvdDVFTDR2bDFFdkI2cHNQdSt1T3ZaTjV4Z1g5eVYwd2ZDYUdLL3UyM1FM?=
 =?utf-8?B?WEV0M0R1N3JvRXBYSk1JdGFWQTBKaytwYmNtWU8zdFVEc0hmK3NtV3lHbm93?=
 =?utf-8?B?NmlkZFlGV3ZldDc5SEltaFl5MllJYWpsUVd4WURTQjluUEF3emJUS2NvUWRn?=
 =?utf-8?B?ZEg0TUM0eGJoZ092OUg3eldEZ3oxa1pQU1loQXhpUDRFSEErdXRFcFI5VExH?=
 =?utf-8?B?MXdKYlFkbm5OZUpkMS9uZ2dzazBRd0FMcnNaOVpGWGZrMGlLQ0JJR2taLzE4?=
 =?utf-8?B?dlNFV0xkWVZ3RGpuL0lPOEgvOTBKeFNJenZOMVdzR1hxNmo5YmxWZGxYbUVD?=
 =?utf-8?B?WExxbFBoWkFIVU5yTzJpSWFyMHoxcllKTVF5V1RXei9kVXBKZThlR0pvYUhy?=
 =?utf-8?B?cnlvK0lueWxvUThabXNwTzV4NWtHRmM5alBaeFdEelBONEtwVThtY2ROaTBG?=
 =?utf-8?B?VS9oNE15bmx2UElhUmdKRmJRSDlpNHBJS2NrVTFma3hTTGZpZWxZVGZIOVl3?=
 =?utf-8?B?MWxDc1Y2U0tvQ1VoZ3dTSFFla01wOEhLWHBqaHYxSU1tT01sK3VNbkdvZVla?=
 =?utf-8?B?OUdEcy83RmF3WERUeDk1cWphTzhMMWJkRHNnZzltMmpnM2t2Y2g3ZkVMUVdU?=
 =?utf-8?B?T3NKZ3p1M0V0M1E4Tk5NSm1TeTdtMkRlRXNsbytSQ21SeUFJMjREanhxMVBa?=
 =?utf-8?B?dS8vb1hIcWdiSWxuSlJnWENiZWlqSUhrMDRWV0ROcklrQ2hmN1I3dEdJRVBx?=
 =?utf-8?B?OVRLN21ZMjdxbnNJNkpwQVFva0x0YjNjVnhQSEc5emxzWi9LbjJtM2ttV2g1?=
 =?utf-8?B?NS9mR1dMY3pDUE5YREVETWhLSWtpZTlGMDRKL2h4MmpnSXd0SzMzWEtiS0Fq?=
 =?utf-8?B?RnpNcEdVZEYyL3F2QXhMOVdIQ3RSbzk5bCtSd2YrSTN2NTJQc0NlT2NLcXZo?=
 =?utf-8?B?OXZKSWtVR3FYK3V6Y1l5ZGVZbTE2NDdRZzk0QkROYi9EWjNMbFA3QjI3R1ly?=
 =?utf-8?B?UEoydWRvSVJNakJKdkkwV1VpVlI5SVFxSHZSeGdhdEk2bERjZHFNaWlManRV?=
 =?utf-8?B?R25URmtxSXhjRFhGVkRmK1FYeG1hVEV3K2xVTFRidkF3VTdraHZOdnlJMmJu?=
 =?utf-8?B?S2ttaGpXVmJNUWU5NEswelFQVjF0QjBaT0FCMnh4NkZPVkV3MWFjTEdlRnFE?=
 =?utf-8?B?a3puRDVpVkxBNm1VTGRBWllxTUp5clZVV3JYMVh5UnY3ODVEbGg4MGJzVGpZ?=
 =?utf-8?B?WWsxb1NNUXYzN0lQaG04UDF4alU2RWVHWmVySHpwcW5vY2xRN0dUdzNraFJM?=
 =?utf-8?B?aCtHTHBwbEhJL0VXOHF3Qkwzbi93cTRCdjlaTEZBR0Y2OFFYdnM1TVE2cW1m?=
 =?utf-8?B?MlFpcGNUMjRBaFgvaTdWQmlmNUVqMy9NWXdzOGIrTjZZUWorSEpINDNXcEV1?=
 =?utf-8?B?L25Yajh5T1VheTduaG5CVWhWbVlZcHNwV1pOS0FJbzY4Q0drdGdvNjhiQWhT?=
 =?utf-8?B?MUkyVFNvZHZLNVJaZ1h5VW5RUTE3RTk1M05TNmtGY01KcUwwaUIycEFHYmlu?=
 =?utf-8?B?LzdnVjByV1IvakoxWUJ0UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bca9ff7a-cce3-4aa7-4042-08d951fbc320
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 19:13:20.3157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5v0vUa26xn3EeKkAG2Ar+xKoJ5cbpi/aXGmAVm3J/K3HLBG1IsSb8Cc9GOAx8Vwz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3920
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: HT7FEhBV1dIvl1tJKgvTCfx9Iqmy6_w2
X-Proofpoint-GUID: HT7FEhBV1dIvl1tJKgvTCfx9Iqmy6_w2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_09:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxscore=0 bulkscore=0 clxscore=1011
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2107280111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/21 9:47 AM, Johan Almbladh wrote:
> Before, the interpreter allowed up to MAX_TAIL_CALL_CNT + 1 tail calls.
> Now precisely MAX_TAIL_CALL_CNT is allowed, which is in line with the
> behavior of the x86 JITs.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>

LGTM.

Acked-by: Yonghong Song <yhs@fb.com>

I also checked arm/arm64 jit. I saw the following comments:

         /* if (tail_call_cnt > MAX_TAIL_CALL_CNT)
          *      goto out;
          * tail_call_cnt++;
          */

Maybe we have this MAX_TAIL_CALL_CNT + 1 issue
for arm/arm64 jit?

> ---
>   kernel/bpf/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 9b1577498373..67682b3afc84 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1559,7 +1559,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>   
>   		if (unlikely(index >= array->map.max_entries))
>   			goto out;
> -		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
> +		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
>   			goto out;
>   
>   		tail_call_cnt++;
> 
