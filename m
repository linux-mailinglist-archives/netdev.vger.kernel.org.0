Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8539444577A
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 17:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhKDQtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 12:49:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14606 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231418AbhKDQtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 12:49:11 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A4GM5lS002812;
        Thu, 4 Nov 2021 09:46:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=s7ztnMLIQD+8fHm1idddUjPulZihVlRiVReFbpDdDa4=;
 b=Hn0sF6o406/rqVU/fiDMyiclJBqaAhPj7sUy02u/6iy4kWxH7atOWG5ww7hp/LaMcQtC
 TKHFoijlMRdYLWQGaSWV+rWdLGOpP51JEAfhbuhYd/8A1uDrmX8lrxX8Fd913IXodLDd
 agVlid3M3D/MK4Q8YfxNEKJ1SEKySHzSoPQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c46b65j5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 04 Nov 2021 09:46:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 4 Nov 2021 09:46:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxnrioUMBlGHEeUNHNH1uc56uPBkUspHHutRF9V12KJ/x+ywPPftkpCPeL3svzxb/OeLf7rRO5EYXHA+S1hf6v4ew3KsIEH6UjfWR4LMwRXAWL2lYlY9JSWfg8ro7MvdDaTnSWgTShcpeKREEKnjwgdQGhlis45jJkqsBlBY+kwuHUFymyC3qbjzBOkSpnwa04AhzrxRhmnY9y3ai1R/RO/mvsi1lM/CW/LS0FjPaO9Y75Pk5si5R4l2GSS20pR+fxeBTmxJy+Pn4R580w8VbAvyMX7j6KmpizvDAPGRzaGKByrQDA0pIzc+7Tf2NfhPCydXvKDhy+EaMdNJ6rIhfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7ztnMLIQD+8fHm1idddUjPulZihVlRiVReFbpDdDa4=;
 b=esoOdCEOruQk/OjuNA9Hxpo5w0Ng3LU2oLHnDEbbk7BD2to+HuduMync2AVHWPxtWqWNEcbyIzqEoDlc66SiSTn2vBCy2ALDY0IKUKsVX6pGrcq30u/D3IrJu1qenA5tdOcC9cBbldUv43SCM42rY1m14jIKFec3Yna0lnpToQg5m2nCfTx1keh7M49Ws400pwf+S8s5D+oz+R4Skr527eL+cMo3K5m+Ri+v/2bedxFedP9ReDtJdn3jDtRQ02FmxwrULpaN8xEPXD8vp4x2pLpAHmo7tYj58CH5pgpfpGu/WU61SAa/YmzJxyDVpL4ECz1spvWgMqxyTZw6orLSsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4839.namprd15.prod.outlook.com (2603:10b6:806:1e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 16:46:19 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 16:46:19 +0000
Message-ID: <6592573c-8cb3-8cb8-2030-f88a3d974400@fb.com>
Date:   Thu, 4 Nov 2021 09:46:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: introduce helper bpf_find_vma
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <kpsingh@kernel.org>
References: <20211104070016.2463668-1-songliubraving@fb.com>
 <20211104070016.2463668-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211104070016.2463668-2-songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0288.namprd04.prod.outlook.com
 (2603:10b6:303:89::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::1253] (2620:10d:c090:400::5:e407) by MW4PR04CA0288.namprd04.prod.outlook.com (2603:10b6:303:89::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 16:46:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bd20613-3c54-41c7-35bc-08d99fb2a04e
X-MS-TrafficTypeDiagnostic: SA1PR15MB4839:
X-Microsoft-Antispam-PRVS: <SA1PR15MB483985150DDA81BD610C67A0D38D9@SA1PR15MB4839.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oc+4Dpg+jzcs9w25gmIQ2ClsV1oCp1zNf7fhTLFKXLgP/k+/cDls6G65R7VaqcLZ+UkA3K1FSOTKTLUkItqROOM2QrUS/0L+Yw+GHdBLvzxlaOZAIrsxA2PuTNOfKdUOTJlOfHPD5SBVzqknikVo9YOSDFk97bzBUzjxI0g10Uqq0ToluKc9zhGV9No+JBzEqx++MBGjyT6nKWdIYv0cBlKTt9jjK+jSq5+fOZJPhFm12MxOfNPL8Us5L0O9oiP3e6/68O6KUfhxga98mbX1HQV1na1938tLyWYRBDLlKtYeW/aen5xkY0Jcomb4vbRL7fWurxGu9jxtgjwKQPzO018fpK/DQJ9YTGVoOhYPCDxNzSMHorrfDLPT5i1jdYSriRACOye5HNi2aPb6preHSpO5VBacY8zsHY5IEVVUFHkYySXgH7fBDrN6JxpPobvM2tJST1aBXPhd3+9ag7ajmifYs8YvGvCDuT9VmN32QvFTHVrcqnl4LjxfzEs4G0dPohRtiSo1RMwHNVAeQBV9myvBxqxFHshq7SbW+RtxosMJPnlL5cbf83uhxZjKF20Fg2trSpawvsGc+1shqr73pzuQVfgtexxYVwOwQzOj1K0CXTV0gU9AtAMprj6n7Ruy4hsQAa4BMhG8el6x2I5lwc/PWEG7+2Vz7t/yEjH5/iTCcXkYsArrmTsHO3GHg1YYpEAOjWSvZyIbm266msQp64gY+H/i0lxGotU3+S80jqY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(83380400001)(66476007)(2616005)(508600001)(4326008)(186003)(52116002)(36756003)(8676002)(66946007)(53546011)(66556008)(8936002)(38100700002)(31686004)(5660300002)(86362001)(31696002)(2906002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1lvcy9IaXVwemlteWtjd0pTMVFpb2o2M1ErVHRDbnBZMkVGS2cxMXZQcmNk?=
 =?utf-8?B?bC83ZU9Yb2RPZFYvZG9MRTVaYWxIcmhiaGlKQWUxYWlEeTlxYkc2SHRacDJL?=
 =?utf-8?B?K0RIMjRIZzAxNHl0QUZGMlcwZzhPbXN5d2I2WkNrOVFSYTFQWi94WEhHQk1s?=
 =?utf-8?B?aWRud0dGSm02SDc2MGFlOVNyQnBWMEdPeVNBUlhsNkpGWk9vZ1F5MHJhM2dT?=
 =?utf-8?B?akFiZ2VlbE14VHRvVEhrNFJBYUl5U0djTENPZnhzblU3UFlWS0ZSVUpwNmkz?=
 =?utf-8?B?Y1dhR1RONlN6TUphZ01wTTQrR3hyRnZNTjd2Q005cXF6NW9SUklvNUt6ZWNF?=
 =?utf-8?B?RHFYYzA5ZEtmQlNLSjdFbFovY2FLTkVqTnhtNUU5aVRPRnZMTldFdUV1b3pQ?=
 =?utf-8?B?L2ZKOFBsVmJyTFpveEN3ZzYvM3ZWZ1lJUThoUURWbU1BTW1rSFNRUmFjNGx0?=
 =?utf-8?B?R3hDK09JS3lZN3A3NWRZdVY1L25XTVd0SEZnK0ZhcUpkQTdnTVNlRVNSbEt3?=
 =?utf-8?B?MTVDdERrUDhIRlhGWTRHSHlUbmJGR05WdU9PQTJtZUNRck1mRG9Cd1ZUaU05?=
 =?utf-8?B?ZmgvajJXdHVMTGJXcjJmeTRCVFFyWWsyUFNWUkpVMThSbDllWUZ4WDVKaCtF?=
 =?utf-8?B?bEVrcmJTSlJLSUtxUkc3b0pWYldScytmMGhDSEcvV1ViWnhINnVDTFRyRXRN?=
 =?utf-8?B?Y1RCSm81WEFNYXEwWTVlT1pqWVlHcTBjcEhONzV1d2FBd25QZHlEOHI3UnY1?=
 =?utf-8?B?b2R0UTVVbkw5SzdWUmRMODF3djEwc0d1VlFITEtwT2Y5WHZhcFlVMElwQ2ln?=
 =?utf-8?B?STlOcnVyZlBtWUdIeVhnR2p2a1liNTZkU0Y5ZTlFcVA2d1VwZGJTM0ZGbWtz?=
 =?utf-8?B?ZThmVURFOEZ4TmJpT01EdjFwekZ1UUVCbjV6cjFLUkp4NXRFN3RNSDlKZXRM?=
 =?utf-8?B?OVRDOVRvekxQWTQzRXJyS3EvWUlzSlIwQi9neVUzMXk0RnVHWW56YWRVdnRY?=
 =?utf-8?B?UGw1K3pTb0pCaE5VTVhKN2JGQ3BnYzNXM2dJRG0vSUFsQWE3YkxsQTlPUlV2?=
 =?utf-8?B?VjI3T0lNRHBWcFV0Wisxd25nRnNuQmIzQ1VmVnFQR1Y2bndyRS9nZUNnMzJ1?=
 =?utf-8?B?TEpVbGZ6enNjdWpuNkRGZndtQmJubXBpYUhMWFBOVGdrazZjTElYcEdlT2hj?=
 =?utf-8?B?VUlkQ2dXeXRIanBZMTdXZTJaNnNFejRUbFR3Mmc0aC9LMlcvY0tucUU0WXg0?=
 =?utf-8?B?c2U0RTlCbjZ1OVBHSStGUVZhQlhHOUNJZWJXZ2I2SzR1cWRsbGtwNEZLZmFK?=
 =?utf-8?B?ajdXelREcWFsVWtkYWJqUWFJN0xWNks5aFFRVHhIS0hJSGxwY3E3NVF2WDdG?=
 =?utf-8?B?RW56MmtYSUl3c05sbWVGbk1hNHkzL3Q2YlpTQjNiVmg4ajlPUENWMFZ1NGpO?=
 =?utf-8?B?dEJGYjZIaExzU21lMEtLOUcwNVZjUnl4VEVFRGh5aGQveVE0VXFDK2t5ZzJI?=
 =?utf-8?B?ZE00dTcwYk9aZVpoYlhtcE9VcWJrNnpUaDF6OStqLy9ZNVVibHN6U0k3VVAx?=
 =?utf-8?B?UFp6TjNUMEFzTTdvK1VXbE5RZWkzM01FUDdmK2JUblR1SWwvZXBKRVlxWXd0?=
 =?utf-8?B?SitPOVQrTU1PRTdxS2RXbnk5Z3NKdlc2VG1FS0haK3JQeHJvWXh1NnRuZkVW?=
 =?utf-8?B?MjRtNUh5V0dTWjhEMU9QU3R4WHFoTWVYUkpIL09Ib01KYVo1ck54UHljVWtn?=
 =?utf-8?B?Wnk0c3owbXgzYzQrblo0aDZ1bDI2UEVkaXNLVkd4ZmluVi9yMnJiTnV1RGh5?=
 =?utf-8?B?bHRRTEZrZkFlRyt0S241NFQyKzV2OHdUZUFnRzB0VXVHZyt0NDdHdzF2Q3hG?=
 =?utf-8?B?R0ZqYVFqNzRhR1d5RDEyZ3E1Y1JIVlhDZjFlTEpPQzU0U0FwU2lpdXk5NHZ0?=
 =?utf-8?B?UHh0d2xXNmZ0L3ZiQXJacW5WY0FPcWlVZHpyRExsb0FyRGthR3RHTTBpSFVs?=
 =?utf-8?B?Z2ZTcDZmSGY1ZW5nMWV6UzZJMW1NZ0N0MFJLdHRZTG9lM0RwVFp4ZmQxV0Iw?=
 =?utf-8?B?ekI1ajlFeVNEdWRvd1RTcFI4TVVtbWllTllESllJWll5d1h6aFJLamFvL3Fv?=
 =?utf-8?Q?Z/b2rQ5CV3e9uNjj1ESsgp2Sf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd20613-3c54-41c7-35bc-08d99fb2a04e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 16:46:19.3070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpTk2NOjL3ucPgW/lFTFJXje3DUCWliwJYlIXnTBKOTUvtPTAJog0gsjr1Jw+DU9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4839
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: pB6CqlKpSjt40yURTOysZRscI64cm3XG
X-Proofpoint-GUID: pB6CqlKpSjt40yURTOysZRscI64cm3XG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_05,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040063
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 12:00 AM, Song Liu wrote:
> In some profiler use cases, it is necessary to map an address to the
> backing file, e.g., a shared library. bpf_find_vma helper provides a
> flexible way to achieve this. bpf_find_vma maps an address of a task to
> the vma (vm_area_struct) for this address, and feed the vma to an callback
> BPF function. The callback function is necessary here, as we need to
> ensure mmap_sem is unlocked.
> 
> It is necessary to lock mmap_sem for find_vma. To lock and unlock mmap_sem
> safely when irqs are disable, we use the same mechanism as stackmap with
> build_id. Specifically, when irqs are disabled, the unlocked is postponed
> in an irq_work. Refactor stackmap.c so that the irq_work is shared among
> bpf_find_vma and stackmap helpers.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/linux/bpf.h            |  1 +
>   include/uapi/linux/bpf.h       | 20 ++++++++++
>   kernel/bpf/mmap_unlock_work.h  | 65 +++++++++++++++++++++++++++++++
>   kernel/bpf/stackmap.c          | 71 ++++++++--------------------------
>   kernel/bpf/task_iter.c         | 49 +++++++++++++++++++++++
>   kernel/bpf/verifier.c          | 36 +++++++++++++++++
>   kernel/trace/bpf_trace.c       |  2 +
>   tools/include/uapi/linux/bpf.h | 20 ++++++++++
>   8 files changed, 209 insertions(+), 55 deletions(-)
>   create mode 100644 kernel/bpf/mmap_unlock_work.h
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 2be6dfd68df99..df3410bff4b06 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -2157,6 +2157,7 @@ extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
>   extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
>   extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
>   extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
> +extern const struct bpf_func_proto bpf_find_vma_proto;
>   
>   const struct bpf_func_proto *tracing_prog_func_proto(
>     enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ba5af15e25f5c..22fa7b74de451 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4938,6 +4938,25 @@ union bpf_attr {
>    *		**-ENOENT** if symbol is not found.
>    *
>    *		**-EPERM** if caller does not have permission to obtain kernel address.
> + *
> + * long bpf_find_vma(struct task_struct *task, u64 addr, void *callback_fn, void *callback_ctx, u64 flags)
> + *	Description
> + *		Find vma of *task* that contains *addr*, call *callback_fn*
> + *		function with *task*, *vma*, and *callback_ctx*.
> + *		The *callback_fn* should be a static function and
> + *		the *callback_ctx* should be a pointer to the stack.
> + *		The *flags* is used to control certain aspects of the helper.
> + *		Currently, the *flags* must be 0.
> + *
> + *		The expected callback signature is
> + *
> + *		long (\*callback_fn)(struct task_struct \*task, struct vm_area_struct \*vma, void \*ctx);

ctx => callback_ctx
this should make it clear what this 'ctx' is.

> + *
> + *	Return
> + *		0 on success.
> + *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
> + *		**-EBUSY** if failed to try lock mmap_lock.
> + *		**-EINVAL** for invalid **flags**.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -5120,6 +5139,7 @@ union bpf_attr {
>   	FN(trace_vprintk),		\
>   	FN(skc_to_unix_sock),		\
>   	FN(kallsyms_lookup_name),	\
> +	FN(find_vma),			\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
[...]
> +
>   static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
>   					  u64 *ips, u32 trace_nr, bool user)
>   {
> -	int i;
> +	struct mmap_unlock_irq_work *work = NULL;
> +	bool irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
>   	struct vm_area_struct *vma;
> -	bool irq_work_busy = false;
> -	struct stack_map_irq_work *work = NULL;
> -
> -	if (irqs_disabled()) {
> -		if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
> -			work = this_cpu_ptr(&up_read_work);
> -			if (irq_work_is_busy(&work->irq_work)) {
> -				/* cannot queue more up_read, fallback */
> -				irq_work_busy = true;
> -			}
> -		} else {
> -			/*
> -			 * PREEMPT_RT does not allow to trylock mmap sem in
> -			 * interrupt disabled context. Force the fallback code.
> -			 */
> -			irq_work_busy = true;
> -		}
> -	}
> +	int i;

I think moving 'int i' is unnecessary here since there is no 
functionality change.

>   
> -	/*
> -	 * We cannot do up_read() when the irq is disabled, because of
> -	 * risk to deadlock with rq_lock. To do build_id lookup when the
> -	 * irqs are disabled, we need to run up_read() in irq_work. We use
> -	 * a percpu variable to do the irq_work. If the irq_work is
> -	 * already used by another lookup, we fall back to report ips.
> -	 *
> -	 * Same fallback is used for kernel stack (!user) on a stackmap
> -	 * with build_id.
> +	/* If the irq_work is in use, fall back to report ips. Same
> +	 * fallback is used for kernel stack (!user) on a stackmap with
> +	 * build_id.
>   	 */
>   	if (!user || !current || !current->mm || irq_work_busy ||
>   	    !mmap_read_trylock(current->mm)) {
[...]
> +
> +	irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
> +
> +	if (irq_work_busy || !mmap_read_trylock(mm))
> +		return -EBUSY;
> +
> +	vma = find_vma(mm, start);
> +
> +	if (vma && vma->vm_start <= start && vma->vm_end > start) {
> +		callback_fn((u64)(long)task, (u64)(long)vma,
> +			    (u64)(long)callback_ctx, 0, 0);
> +		ret = 0;
> +	}
> +	bpf_mmap_unlock_mm(work, mm);
> +	return ret;
> +}
> +
> +BTF_ID_LIST_SINGLE(btf_find_vma_ids, struct, task_struct)

We have global btf_task_struct_ids, maybe reuse it?

> +
> +const struct bpf_func_proto bpf_find_vma_proto = {
> +	.func		= bpf_find_vma,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_BTF_ID,
> +	.arg1_btf_id	= &btf_find_vma_ids[0],
> +	.arg2_type	= ARG_ANYTHING,
> +	.arg3_type	= ARG_PTR_TO_FUNC,
> +	.arg4_type	= ARG_PTR_TO_STACK_OR_NULL,
> +	.arg5_type	= ARG_ANYTHING,
> +};
> +
>   static int __init task_iter_init(void)
>   {
>   	int ret;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index f0dca726ebfde..a65526112924a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -6132,6 +6132,35 @@ static int set_timer_callback_state(struct bpf_verifier_env *env,
>   	return 0;
>   }
>   
> +BTF_ID_LIST_SINGLE(btf_set_find_vma_ids, struct, vm_area_struct)

In task_iter.c, we have

BTF_ID_LIST(btf_task_file_ids)
BTF_ID(struct, file)
BTF_ID(struct, vm_area_struct)

Maybe it is worthwhile to separate them so we can put vm_area_struct as 
global to be reused.

> +
> +static int set_find_vma_callback_state(struct bpf_verifier_env *env,
> +				       struct bpf_func_state *caller,
> +				       struct bpf_func_state *callee,
> +				       int insn_idx)
> +{
> +	/* bpf_find_vma(struct task_struct *task, u64 start,

start => addr ?

> +	 *               void *callback_fn, void *callback_ctx, u64 flags)
> +	 * (callback_fn)(struct task_struct *task,
> +	 *               struct vm_area_struct *vma, void *ctx);

ctx => callback_ctx ?

> +	 */
> +	callee->regs[BPF_REG_1] = caller->regs[BPF_REG_1];
> +
> +	callee->regs[BPF_REG_2].type = PTR_TO_BTF_ID;
> +	__mark_reg_known_zero(&callee->regs[BPF_REG_2]);
> +	callee->regs[BPF_REG_2].btf =  btf_vmlinux;
> +	callee->regs[BPF_REG_2].btf_id = btf_set_find_vma_ids[0];
> +
> +	/* pointer to stack or null */
> +	callee->regs[BPF_REG_3] = caller->regs[BPF_REG_4];
> +
> +	/* unused */
> +	__mark_reg_not_init(env, &callee->regs[BPF_REG_4]);
> +	__mark_reg_not_init(env, &callee->regs[BPF_REG_5]);
> +	callee->in_callback_fn = true;
> +	return 0;
> +}
> +
[...]
