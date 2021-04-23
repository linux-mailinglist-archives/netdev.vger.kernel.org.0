Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3F9369907
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhDWSRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:17:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48990 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhDWSRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:17:05 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIG8SC008949;
        Fri, 23 Apr 2021 11:16:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Xl5okWE5hGPmEZbgBP693fHMS9tCbpQHse+4vnFWbVU=;
 b=TYLuFAwPMFDBrVD9de865v4RO6T+WARKPqx8/Mh6JUyVUnykcJJhrsQ+tFzEj8nZDrvM
 of8DpmFAmCDv3tDVLbQ3w5B9rJ3msWublzcQsTmsLrt9b1/nCYTvUAsw/10zWSllv61d
 dVQuGn3pnIzaPyROl5+w8V56JIj/xXyV5zI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383kvnmmc2-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:16:14 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:15:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWEcR1vhvlpg8mtKGBes5GsBcgBMHKImlqIXNYyW5Z1yxNN4DWZ0/3O8/m0WabIpFcqrLCKR2emw/dK9rGd6mT+xrUPHhSw8ujHGVuHaUjE8tJpMBEJC/88HdWr+gspK5Bp3khPRSkdZvXHhukTCsppyoFxlkxj8OCmTicE0qmfWpXVeie1iDUSLKRH6hwJClzyAObk9Wz+7GXLSHCIzRu2zduW/E7FoN0/RN1eCWKpA0r0HbYv9tsiSB5Qzaoa3DqdRFXFcQD2QAZi7D0pq0MwEPoOla8T/fWk//Wn2aKQosiQA0oEV/ZBQcG9OzlmeBHoP1q9kdSJJ01MaZktq6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xl5okWE5hGPmEZbgBP693fHMS9tCbpQHse+4vnFWbVU=;
 b=SyKzmpiWtN8eH7z2CQJ7oI9tCtlsU6u0XjUE/Wy4YG11mLivr9iaHVV5BlaxkN003Eghla4YONc3EkUGEA4mNwUu+H98IC3oQxraOtv97pTcWYnFD7cPvXubEJLFK02oyaEcBzF3fbUCpd/3j7eMY8eQwApAePM4IzsMIkDtBJn3JATgEruGBKXxcGsj3WAIaGMG0F4a4dte1frpkIyck14n+rMYnrdTU2JYJh8gRS2k9JbntLtNisMNEpIjW3P/pIVghDSy287DC/tlIZWDiURE+X8TCujG7LAP+zRnPD7s8H/V530TwO9ZpmjHXMP4l1kWHuB0s+S4wChxjwDBFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3886.namprd15.prod.outlook.com (2603:10b6:806:8f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 18:15:52 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:15:52 +0000
Subject: Re: [PATCH v2 bpf-next 01/16] bpf: Introduce bpf_sys_bpf() helper and
 program type.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-2-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <75b1c0b2-12f6-57f3-0cd0-2a59285b6aa5@fb.com>
Date:   Fri, 23 Apr 2021 11:15:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423002646.35043-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MWHPR17CA0063.namprd17.prod.outlook.com
 (2603:10b6:300:93::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MWHPR17CA0063.namprd17.prod.outlook.com (2603:10b6:300:93::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 18:15:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b959140e-0727-4105-b3e1-08d90683d428
X-MS-TrafficTypeDiagnostic: SA0PR15MB3886:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB38863E0C409B1A85670F71BBD3459@SA0PR15MB3886.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RW12rH7c/o14cKADgzJTwDRIXK2k5l8C2xk/hg0MwZ3pcbIdtEdGkrjEcTaY2IGwe5Dq9LY85JForJwBbWxEiH6595hkXbEeWh9Msdd96zMlnigpZDxJTcGJ+slLk67ABlglST7EMbzNYYsMhV108lnRh1CNR3pRymM8KcGfDjmO57nOeUWkaJ0OOn4pPAZsS7e6GY4dNCuGTrD+j2R5l43q/sqLOb1D2Fi3E+YJMo7F8uEluB4b9hPE7GoDM48Y3sEiYJK3X57UE9QeC1BPmMT/gM/DeY8iEpA7wGTQyjqbw7+fQt6McwGDtzybPrx8DGecWFoUbgy2FfA8jt78va498BnHFJMpFNWi2j96M9XYDafZtsjW+NxK8+gLJ3dNFx+3IXc5kyzoFQzhemTgWcaTx4MKb0/2gXNqaBJcVLOo6X6l2Z44Th8jJcUAJXh8eHgaVvxThmk9Z6IDw9DfL8hQ4KfpjMjb/xbBSMOqb+GQZ4cpyEECFl+zOm5Vbv7JPvnQEQg0g5vi5JHqNlvYEFyyA+yrI9jrOHPn/3NBhkuh42sVl64lg58nbhmHzCxUryWdE6mfMkdUdWsf05i9bgKee4omQ8t2i7rIBEryKVkrRAFiQG70lwwzb+5+PweoHhSV0DPfCiIgErIamvT9UFQ2LAIle3jJIboyiFf5dprnwrW+PWBeuKuejJ0JBvp+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(4326008)(8676002)(66946007)(478600001)(316002)(6486002)(66476007)(83380400001)(5660300002)(52116002)(53546011)(8936002)(38100700002)(2906002)(186003)(31686004)(16526019)(31696002)(86362001)(66556008)(36756003)(6666004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WVZyUEgrZWRmclNPNVA4dlBqV3QyNGRwWm8wKzh2NGVnMmhuOUhLd1RhYXJN?=
 =?utf-8?B?QTFKRk9rV1QxSXgrdlVvSDhMNHRBeFlXWjNZSDFMU2dGejVOTERtays2K0k3?=
 =?utf-8?B?ZGJwN040TGdXM1dHeFpxaUtxekh2NTJHQ1VqZmVYY1pCYzVCMThYS2UyR0hR?=
 =?utf-8?B?bGwxYVRRUlh6WTZ1SW9Cdkx2V0RVYUtZWXFDMWs1ZVNHSE9ER0dvSUE1TzBa?=
 =?utf-8?B?YWVJTzhnN0ozenpielpUYzJMWFE2eEZWNFN2ZXg2azM1a1RUc00xeHdtV3pG?=
 =?utf-8?B?cHVLSXpjdXdRL0pqa3B1ZXNsRWhpeCtIcXZ6MEt1TkhRMENkbERFV24rMzZX?=
 =?utf-8?B?WHMvSkJUeWNobkgrdWh5TytpQnhqN0NUd3d2NXhHTmFJOW9ocmFYSEcrNGtG?=
 =?utf-8?B?STBQM0Urbks5OVo0a1h1eGpZVlFFUFdQZTJIN25VN3Byd3Iya3lqeVR1ZE1O?=
 =?utf-8?B?MlJUbUUyeG1wL0thZ2hFUkordFlMM0FGVkhIa09jUWV6TCtDWkczb3k3ZjBu?=
 =?utf-8?B?aG9vUzFZeENHQi9jWVRsU0UxYnJBRGZnQ1VZRkZveFNqRHRiR2hEZHRqcFQy?=
 =?utf-8?B?NVUreHhndWx3bU96RkljZGVYemR5YnZCVCtkK2V6bTFTVXFmc1BGRHVUNGV6?=
 =?utf-8?B?dHE2dTlSbGZ3akVRQTdMNVl2WnBGQTlobVFWMU02M3VwdG9pQnNIV2Y1cWFU?=
 =?utf-8?B?M2lkbC9qcjkyMTJFSmkyUDBreEMxanl0Nzl1YS8rdENmNmxCTG5mR0lRbC9h?=
 =?utf-8?B?Ym9pK1NObG5uR1ArY1kxYXlnbE5JdW9PWWtMNlAyVHA5MWt3ckZKVFFXTDNm?=
 =?utf-8?B?M3JtZ0dkNDVBOXIxTW1PVm1QbjVKbDd2NmQ1b3NHeXFjK2loeWNBd2JsRTFG?=
 =?utf-8?B?ZDIrOWdPRW9JN0JKRXNxd0NPdzUxV2I5ZHF0eDRleGFteFlkYjBjSUUvd1A0?=
 =?utf-8?B?eWpweHVIWnI0Q0RhRTBqcWdwSGFLLzg2VHpmd251UkNaVkpxRXJSdCtONEZD?=
 =?utf-8?B?bGc4aXZzcWU0MFBERDJtK2oyUk9jWFI1b1Z0aUZLTi9WWU53Zkp1VGlBTjlw?=
 =?utf-8?B?MzZYbHk0QmRyL0RMcGNPMG9ueTVtS2w0eHpmbUNidnNYWnlJeElOM1Qvd2lK?=
 =?utf-8?B?MDlYZGtEblpuTXgwR2pjWXV2KzBhUE1JdjBHbXN5QlNsUnhmMVJRWXJtalVV?=
 =?utf-8?B?UXlGM2lJaXd3WWVXNGRCT0tUM3ZIdGV6Ync3OVZGb0RQWE1jc1ZzSEd3SVVC?=
 =?utf-8?B?bjhrVUlSWEFWQXgzZWx2Z1R5djBtaU84SmI2dEVCU2JpamNwZzZsUUtrcmFJ?=
 =?utf-8?B?WDJZSVgzbXF6c2Z3eWgxckJjbmhYV1UzSFljSXpDVnpsYUkzdGdqZTBFL3Bv?=
 =?utf-8?B?eFMwaGFPdDQ3TDlJaUdISlcyd3pWenRabUxJeSs5dTIxM0RhWGlpRy9LdGRE?=
 =?utf-8?B?a25hdVpNMjdiS1RaNW1CUmtGaFl1Nm01WUxrcXdrWFFSN05QVkJsc3pZRjVi?=
 =?utf-8?B?NkxxQjdTR3NIT1BLRUpCQ1lEcGtMOE80SENPQnN5Q0xuTjc0NnVEK1F4anB5?=
 =?utf-8?B?ZTZPazMvZ0tLelYwelYxWU5CV1A2OGFGZ1RLY2ZDMU9Lak44MXo3N1JTYnRn?=
 =?utf-8?B?OXFFQjJaZ2dRaHk5ZEtBYnlpalRTK1FDczhMNU1hMjh4T0JLbnR0aDFuS3My?=
 =?utf-8?B?NHUvNzVzZnFGbStEaW1xTjNpem16T0hRQnQwL2FVVGYxeU1NdHFSam1IeGRy?=
 =?utf-8?B?ZC9Vb3lmdGhVempadThqOGtNUGtmQWhDdDQ2VGVTV1dlMDVWekovZ0tEUi9z?=
 =?utf-8?Q?r2NXoY2jTnnoJyzeHX4r8BTn86XSr1MJ5NpmA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b959140e-0727-4105-b3e1-08d90683d428
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:15:52.0495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIYB4wweC8b/MeZuuXcsP1C9nWIOOpMhxIXUiZlxQOpBVQfL7FpRYVl9h6ADMzkD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3886
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 4tAjC0_X-pulO5P-igiL381kSDhoWwZb
X-Proofpoint-ORIG-GUID: 4tAjC0_X-pulO5P-igiL381kSDhoWwZb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/21 5:26 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Add placeholders for bpf_sys_bpf() helper and new program type.
> 
> v1->v2:
> - check that expected_attach_type is zero
> - allow more helper functions to be used in this program type, since they will
>    only execute from user context via bpf_prog_test_run.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>   include/linux/bpf.h            | 10 +++++++
>   include/linux/bpf_types.h      |  2 ++
>   include/uapi/linux/bpf.h       |  8 +++++
>   kernel/bpf/syscall.c           | 54 ++++++++++++++++++++++++++++++++++
>   net/bpf/test_run.c             | 43 +++++++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |  8 +++++
>   6 files changed, 125 insertions(+)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f8a45f109e96..aed30bbffb54 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1824,6 +1824,9 @@ static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
>   
>   struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
>   void bpf_map_offload_map_free(struct bpf_map *map);
> +int bpf_prog_test_run_syscall(struct bpf_prog *prog,
> +			      const union bpf_attr *kattr,
> +			      union bpf_attr __user *uattr);
>   #else
>   static inline int bpf_prog_offload_init(struct bpf_prog *prog,
>   					union bpf_attr *attr)
> @@ -1849,6 +1852,13 @@ static inline struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
>   static inline void bpf_map_offload_map_free(struct bpf_map *map)
>   {
>   }
> +
> +static inline int bpf_prog_test_run_syscall(struct bpf_prog *prog,
> +					    const union bpf_attr *kattr,
> +					    union bpf_attr __user *uattr)
> +{
> +	return -ENOTSUPP;
> +}
>   #endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
>   
>   #if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index f883f01a5061..a9db1eae6796 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -77,6 +77,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
>   	       void *, void *)
>   #endif /* CONFIG_BPF_LSM */
>   #endif
> +BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
> +	      void *, void *)
>   
>   BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
>   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ec6d85a81744..c92648f38144 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -937,6 +937,7 @@ enum bpf_prog_type {
>   	BPF_PROG_TYPE_EXT,
>   	BPF_PROG_TYPE_LSM,
>   	BPF_PROG_TYPE_SK_LOOKUP,
> +	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
>   };
>   
>   enum bpf_attach_type {
> @@ -4735,6 +4736,12 @@ union bpf_attr {
>    *		be zero-terminated except when **str_size** is 0.
>    *
>    *		Or **-EBUSY** if the per-CPU memory copy buffer is busy.
> + *
> + * long bpf_sys_bpf(u32 cmd, void *attr, u32 attr_size)
> + * 	Description
> + * 		Execute bpf syscall with given arguments.
> + * 	Return
> + * 		A syscall result.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -4903,6 +4910,7 @@ union bpf_attr {
>   	FN(check_mtu),			\
>   	FN(for_each_map_elem),		\
>   	FN(snprintf),			\
> +	FN(sys_bpf),			\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index fd495190115e..8636876f3e6b 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2014,6 +2014,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
>   		if (expected_attach_type == BPF_SK_LOOKUP)
>   			return 0;
>   		return -EINVAL;
> +	case BPF_PROG_TYPE_SYSCALL:
>   	case BPF_PROG_TYPE_EXT:
>   		if (expected_attach_type)
>   			return -EINVAL;
> @@ -4497,3 +4498,56 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
>   
>   	return err;
>   }
> +
> +static bool syscall_prog_is_valid_access(int off, int size,
> +					 enum bpf_access_type type,
> +					 const struct bpf_prog *prog,
> +					 struct bpf_insn_access_aux *info)
> +{
> +	if (off < 0 || off >= U16_MAX)
> +		return false;

Is this enough? If I understand correctly, the new program type
allows any arbitrary context data from user as long as its size
meets the following constraints:
    if (ctx_size_in < prog->aux->max_ctx_offset ||
  	    ctx_size_in > U16_MAX)
		return -EINVAL;

So if user provides a ctx with size say 40 and inside the program looks
it is still able to read/write to say offset 400.
Should we be a little more restrictive on this?

> +	if (off % size != 0)
> +		return false;
> +	return true;
> +}
> +
> +BPF_CALL_3(bpf_sys_bpf, int, cmd, void *, attr, u32, attr_size)
> +{
> +	return -EINVAL;
> +}
> +
> +const struct bpf_func_proto bpf_sys_bpf_proto = {
> +	.func		= bpf_sys_bpf,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_ANYTHING,
> +	.arg2_type	= ARG_PTR_TO_MEM,
> +	.arg3_type	= ARG_CONST_SIZE,
> +};
> +
> +const struct bpf_func_proto * __weak
> +tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +
> +	return bpf_base_func_proto(func_id);
> +}
> +
> +static const struct bpf_func_proto *
> +syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +	switch (func_id) {
> +	case BPF_FUNC_sys_bpf:
> +		return &bpf_sys_bpf_proto;
> +	default:
> +		return tracing_prog_func_proto(func_id, prog);
> +	}
> +}
> +
> +const struct bpf_verifier_ops bpf_syscall_verifier_ops = {
> +	.get_func_proto  = syscall_prog_func_proto,
> +	.is_valid_access = syscall_prog_is_valid_access,
> +};
> +
> +const struct bpf_prog_ops bpf_syscall_prog_ops = {
> +	.test_run = bpf_prog_test_run_syscall,
> +};
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index a5d72c48fb66..1783ea77b95c 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -918,3 +918,46 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
>   	kfree(user_ctx);
>   	return ret;
>   }
> +
> +int bpf_prog_test_run_syscall(struct bpf_prog *prog,
> +			      const union bpf_attr *kattr,
> +			      union bpf_attr __user *uattr)
> +{
> +	void __user *ctx_in = u64_to_user_ptr(kattr->test.ctx_in);
> +	__u32 ctx_size_in = kattr->test.ctx_size_in;
> +	void *ctx = NULL;
> +	u32 retval;
> +	int err = 0;
> +
> +	/* doesn't support data_in/out, ctx_out, duration, or repeat or flags */
> +	if (kattr->test.data_in || kattr->test.data_out ||
> +	    kattr->test.ctx_out || kattr->test.duration ||
> +	    kattr->test.repeat || kattr->test.flags)
> +		return -EINVAL;
> +
> +	if (ctx_size_in < prog->aux->max_ctx_offset ||
> +	    ctx_size_in > U16_MAX)
> +		return -EINVAL;
> +
> +	if (ctx_size_in) {
> +		ctx = kzalloc(ctx_size_in, GFP_USER);
> +		if (!ctx)
> +			return -ENOMEM;
> +		if (copy_from_user(ctx, ctx_in, ctx_size_in)) {
> +			err = -EFAULT;
> +			goto out;
> +		}
> +	}
> +	retval = bpf_prog_run_pin_on_cpu(prog, ctx);
> +
> +	if (copy_to_user(&uattr->test.retval, &retval, sizeof(u32)))
> +		err = -EFAULT;
> +	if (ctx_size_in)
> +		if (copy_to_user(ctx_in, ctx, ctx_size_in)) {
> +			err = -EFAULT;
> +			goto out;
> +		}
> +out:
> +	kfree(ctx);
> +	return err;
> +}
[...]
