Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829564401E3
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 20:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhJ2Sbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 14:31:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21858 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230077AbhJ2Sbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 14:31:47 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19THwRfs023855;
        Fri, 29 Oct 2021 11:29:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=YeD4pXRc9/qhQChOyavybaw5/YSlyCNkx52VPz6wvgM=;
 b=gh2DldJFLsEApj7WA4qhS0hb/6ogNJcNyA0G343ryche11p3IXCRVJBM2PrKzguc/JFh
 p13ZEwbFe89b8s6V4T3QfdVJkY1U7ew/Geb/BGi7Lce1uvlgfuCJ3WKGg7xMwo8ZS3qI
 tuoj4c0Vqsz2/uEimLWIBSxV4YP8kse4k50= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c0mdnh72v-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 29 Oct 2021 11:29:04 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 29 Oct 2021 11:29:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nT3PrOTuvv1StLHdQeu2Lc+9KXHKT45pGINvMCew77zXxgGWTF4IYmHjZ3HbRyY7A1ApIDCwyuT0o8OuGe4VDWJxxUszV4DkXaYoiYbrzzpCbGFwMEl1qyNfQm8j+V7w2g52F0oD5QYAowdWPg6ftMnq6WQcX+KEiroZp4PkgU0l3H5vqdrXZoZ3pOX3DGrrzpGX0A+RhedDB0JkQZL6mopbNcbUMqD+vNTJHc1+mvXctIEuh0nxPIlDlMjtB1Jzp9Coc7dyUlU2NqNK4pW6Zdh0OCHANzTLS1n994swN4GEOacG9QAsnmNDC+RUc47lXPcElfuxCER01nmQI/0ZJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeD4pXRc9/qhQChOyavybaw5/YSlyCNkx52VPz6wvgM=;
 b=kBMc8rx/dzQSZX+nVz3l1Uk7VxZC0x96lSEoesgcbCuIFCSa4U8gVkW87Vi5JOmSGRGNHRTQZbP+qt6ajWJ4aic77/JLHDEoiIHWdFod4KBIJMkeGAlHWBzr+1tSi0x+YuZ6v7+BVcEldR0JppxqMTl4iC8QnwJ9EIbH5nwqzZ+ptemkpVeyviWeAqc49cGpPmGV2JN+ulzDovofH3LjZGnqAv3rQ7RZONZYn5qlRmrYHr0dDikHEPi3uGJNw7Kon6nzi/Z4Yili5eU9+9hFWcnW6aNYfFkwF/90FawJ39y+l7AsT6C/SFYj/Z5EClwGSkuU9Okl+GYYD6El4Hm2qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3968.namprd15.prod.outlook.com (2603:10b6:806:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 18:29:02 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4628.023; Fri, 29 Oct 2021
 18:29:02 +0000
Message-ID: <2d8df23d-175f-3eb8-3ba4-35659664336c@fb.com>
Date:   Fri, 29 Oct 2021 11:28:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next] bpf: Fix propagation of bounds from 64-bit
 min/max into 32-bit and var_off.
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20211029163102.80290-1-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211029163102.80290-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:300:117::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21c1::17cb] (2620:10d:c090:400::5:47d6) by MWHPR03CA0021.namprd03.prod.outlook.com (2603:10b6:300:117::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 18:29:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f577a53-5ee0-4b6c-9084-08d99b09fb6d
X-MS-TrafficTypeDiagnostic: SA0PR15MB3968:
X-Microsoft-Antispam-PRVS: <SA0PR15MB3968B0100D7F67EBE7D4F8FDD3879@SA0PR15MB3968.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUIOHIMU+GXnErw/8kpGww3H0sHarsMqxUL2PnVvBcGp8AzrZlqSH1OmwoJvpmGBuk4PD/O4chDf4jUcEgEO7t2eqTeY1OWMBk4Km5e1rAlURo+ppZF6R0mkpCa7sHBRLiUjKk0KzL87PPH6HTqyjMF4CJes/GS8iEOXo3tvu4hzq4e7lD8awNvbh3DkiidoHJd10FxYCtZScs6nGm0DHLIoqs4v512vgXpL9Hkfxf81T6Tb4YejXgJPjW3Xtzo3wRrgDZwvPeBUnjsruQdK2g7dkU25zrZZ4c3naPXc39SKYBYq/Z7PNpc3amGzgbZ8kB+ZTnG93fSzxRg4ZqhPE0PLOsI1koDNkXnDtDbSH9EHtFp3AE+2YNfMbCeFvbd2u2Tkowxu/mO1kNaXGiyvQrQolpgaH+lo56SzxmE1u3Di1VNJVU6lNuvOe64uoMwM2dSb5rFNXDNpdIStEU1UNQTEH4fPHugZ56uqC1Y2ct22dQjohGcAeYyb8DB9wms6JpOMIbwzDgaPGrLSfzU+98h6EX5bgkK0RSnuSyOuko3x3v0ijSCU5DwvCsflw3ePi56DZO9bGKVQwNtNqVDdv8ZzYA1nw0Q8iGQywOtyxMzSBpTl8pmXaMoCQnNwuMevEs5zFbjkDWM28UfKYMZplT08bQtn7bU8PRKSTYmdwGLxxvLeNzjq6JQxkU1DcvsRxny6eMmLf/mbNxD8M2r67qDZQLbDYhePYGOUfrk40BA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2616005)(8936002)(38100700002)(508600001)(5660300002)(2906002)(31686004)(4326008)(66946007)(66476007)(66556008)(36756003)(53546011)(31696002)(83380400001)(52116002)(8676002)(316002)(186003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnZ5dnFSMjZGSlFwcDRaVnJBT0tSR2dlZ2NLWk5MOFpKNkttR0FpQWgySW1W?=
 =?utf-8?B?eCs4TU1aYUVTM0tQS0FDNzNZazdKMytxYVp1dU9FME51L1VhUEwzZGFGK0Fo?=
 =?utf-8?B?Y21NempLZ3JUSVFlYTdERms0WDJTMENnNTByM3VXdkdDWW5YRnkyR0RUemU3?=
 =?utf-8?B?M3lWTjZaaFpIOFA2UkZWdEtKUmM2MzFJWndVV2VHK21WNHU3SlNsazBFVUlG?=
 =?utf-8?B?Q0NvcldzZ1lxMXl0OW1NL0VBdmNFK3RLbjF2Z3BTdEJOZVp1M0g0TTJRNGV4?=
 =?utf-8?B?YkRKVG9JVzJrKytjMXFUaDQvTVBrd0pXUjVFWHFzR3hGYXI4ejFzeHBQMmg0?=
 =?utf-8?B?UmpJNHMrZGRpQm03a2FQSy9RVUxjY1RsQ0o3eUwwM1EyWEZCTEN6cy9wZmhH?=
 =?utf-8?B?N2Nlc3B4WkdFVnh4VGdYZzZoY3RsVHp5cm50WHpIV3NmM3BPNEhFd21YbVRV?=
 =?utf-8?B?QnpUTTZpYzV4RS9yU09vSXk4dGtjejI4Z3h3RDMzUHRvWi9wYlJ6NVNHaWpW?=
 =?utf-8?B?c25BRjZESFJPRlZxZzRGYnFIckNyWjVRRldTUzZxbzVZczhTMEtIUmJJdnFz?=
 =?utf-8?B?UnpRNEI4RzUycnFPc29yQTE2azE1Mjh2K0RpTk96bnhvdDVKTlFZQm5iNWRO?=
 =?utf-8?B?SzdLQzhUU2pzVWVxbm9xRk9CRlErR09wb2dpb3pWSFA3NmJNT2FLZnBhNmdY?=
 =?utf-8?B?NGQvV2QyMUdvaUZmTHNlTjRDNHJHakZoeWtHUkVLTm9mRTNTMUdhcEEzRXBX?=
 =?utf-8?B?bUhObDZBMjByV05ZZTN6R09Ib2ZubFBOanRDZmZidUE5R1NIQ2dGWDROR04v?=
 =?utf-8?B?anNsT0JlRktJVTRydmZTZWpmTGFaV1N6UTdaTDlTeWZTeG0zdk9SRGRlVmg5?=
 =?utf-8?B?azJEanNtUkRPdnFmTHBsUG1vM2VLNFM1dk9CNzN0dlNaVEFXNjdzaWRBUEZG?=
 =?utf-8?B?K2FsYmRIUTNUakJrUFNwa1BIOGc4VENHeklDdVpCNzZIdmNJa2pmekc2bW1q?=
 =?utf-8?B?dGpPOTZOaitkNmlsdkpUUC9pU3QzbHR3VmVmMEFaQXlFZTh6cGxYZHpadUZ2?=
 =?utf-8?B?VmdrYVYyUkRUSEF1d29NVW1xTEpvam96U2hHWTBuOE8xR2N3Q2hOS2VCcVlK?=
 =?utf-8?B?bGE3YlBxV1daa1F0UW9sYUloZmlwUzRDMkJXNVVkWG5Yc2FhRHc1MWVFNS8z?=
 =?utf-8?B?bjdPNkRDK2sxcVpNOG1OZHFYMGlyUkhpZVRMRmdUTnQrOXpldjJwR2F3NVZl?=
 =?utf-8?B?eTk3cE5ydjdreGJPV2YxbVZVM3ZRazViVUFxYjlZZmFGeVFWRFFOcVVMUkVP?=
 =?utf-8?B?M1dsVkRjb0lvWUlELytGUnc1RnoyY2hOMjk1S1cyRXJMRWo3VDNPc0pMSTQ5?=
 =?utf-8?B?RGp5TEgxWU9rUlhla3gwdlNMSVpPRUUrYkU2VHhncW9kd1NsWXZuMzdXZ01W?=
 =?utf-8?B?dmJweVBsK1M3R0lSNStnSHRIa29GMGp1OHdUb2Y5azU0VE1XcWVxd3ZDYncr?=
 =?utf-8?B?SkNXeGIvY1ljR1FPcjZINWhaMFhhcTRFYm5BL0w5RE5Uanc4OGhPTmthMmFX?=
 =?utf-8?B?VFhnZ2lxbmI5dFlqOUo1RzRWc1NxT3ZIS201aWExVlpGd1IvR0xta0ZYV3VV?=
 =?utf-8?B?aTk0QmVlYkdyZDhieURuS3dsUGorUWFIdVlNU0FjbHlUSnlCM0dYMGp6M2Qv?=
 =?utf-8?B?Ny9LQWRVMHhoWkIwQzFwaE0yM2FETVBBeHRwSXJCYTZ1RHFaSW53dVhlZldk?=
 =?utf-8?B?aTFweFFJb001amVPUmxQb3ZwdzNkMmlYdTR6SzJoMzE4cWVMTHBDTUR6OURo?=
 =?utf-8?B?ZXZEVktKMk0zM2dycHdtSnhXUjlCU0VZMFJBVVZTamtRaU5DVUEwT2hzb2Rv?=
 =?utf-8?B?RG5wTmpHcmNKUTlCL09TQWZtTndXWFpFZUQ1Z1YvVDFBNi9YcTRQTUx2dnNI?=
 =?utf-8?B?UlVBeStxdlVhMjVYTlFmWmZTM05hMmRwSzZpdG96SVJ4aHc5emVBaE1CUS9l?=
 =?utf-8?B?MHpkK1VFYnlYakN6MzVVQW53MkE4c2dTMnpSaDY2azdpa2h6Nm1XejFzSWw1?=
 =?utf-8?B?czR2Nlc2MWFZc0Job2lUTlE1cVlyVC8wNjJEblc0R2dERDlTYjlUMDZPZ2Rq?=
 =?utf-8?Q?bhaAU/OG1oPFyZjpYnChxhGY/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f577a53-5ee0-4b6c-9084-08d99b09fb6d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 18:29:02.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prM+xUpu5rvmqqlM7LSgOwybcssIi5YgGva84dkuX5mAOR028QxfE5OMXrlt8xNJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3968
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Bdyon-JOnToDnWRfjZORtr5OXIbTg4Fd
X-Proofpoint-ORIG-GUID: Bdyon-JOnToDnWRfjZORtr5OXIbTg4Fd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_04,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1011
 mlxlogscore=999 lowpriorityscore=0 spamscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/21 9:31 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Before this fix:
> 166: (b5) if r2 <= 0x1 goto pc+22
> from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0xffffffff))
> 
> After this fix:
> 166: (b5) if r2 <= 0x1 goto pc+22
> from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0x1))
> 
> While processing BPF_JLE the reg_set_min_max() would set true_reg->umax_value = 1
> and call __reg_combine_64_into_32(true_reg).
> 
> Without the fix it would not pass the condition:
> if (__reg64_bound_u32(reg->umin_value) && __reg64_bound_u32(reg->umax_value))
> 
> since umin_value == 0 at this point.
> Before commit 10bf4e83167c the umin was incorrectly ingored.
> The commit 10bf4e83167c fixed the correctness issue, but pessimized
> propagation of 64-bit min max into 32-bit min max and corresponding var_off.
> 
> Fixes: 10bf4e83167c ("bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

See an unrelated nits below.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/verifier.c                               | 2 +-
>   tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3c8aa7df1773..29671ed49ee8 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1425,7 +1425,7 @@ static bool __reg64_bound_s32(s64 a)

We have
static bool __reg64_bound_s32(s64 a)
{
         return a > S32_MIN && a < S32_MAX;
}

Should we change to
	return a >= S32_MIN && a <= S32_MAX
?

>   
>   static bool __reg64_bound_u32(u64 a)
>   {
> -	return a > U32_MIN && a < U32_MAX;
> +	return a >= U32_MIN && a <= U32_MAX;
>   }
>   
>   static void __reg_combine_64_into_32(struct bpf_reg_state *reg)
> diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
> index 1b1c798e9248..1b138cd2b187 100644
> --- a/tools/testing/selftests/bpf/verifier/array_access.c
> +++ b/tools/testing/selftests/bpf/verifier/array_access.c
> @@ -186,7 +186,7 @@
>   	},
>   	.fixup_map_hash_48b = { 3 },
>   	.errstr_unpriv = "R0 leaks addr",
> -	.errstr = "R0 unbounded memory access",
> +	.errstr = "invalid access to map value, value_size=48 off=44 size=8",
>   	.result_unpriv = REJECT,
>   	.result = REJECT,
>   	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
> 
