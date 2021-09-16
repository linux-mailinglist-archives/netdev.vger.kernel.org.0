Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BC240EDD0
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 01:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbhIPXSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 19:18:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53432 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231305AbhIPXSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 19:18:44 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GFgwet013888;
        Thu, 16 Sep 2021 16:17:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MFRLkPHGupgYVfZitt6R7L/Yl7TNCOBTbx+jTrKoLmQ=;
 b=eVJv6PzgH/7LD4xVQhZQpRU7Rljfe/a8t8ebBMszEHUps6XsVTJtCP9nle4ya7SYL2Ol
 CkuFrP0kcU10wDwzVBTPSmJguCeQRvsVM5MKpM/i/HxySu2APghMSti+LB8QppRoPdBM
 9Qf+rLal3ynuEk62zZgtKjnWL6Q+AirKKB8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b3kv0tpra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Sep 2021 16:17:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 16 Sep 2021 16:17:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnUtwCsYR/NaezVgS+54mA/omaHkql8TFomtQr2k/+8q/v5PcU+U1wgq2ZdwQl2z0xu1v7Mm3FCXFp9ExGRcgvgqtBGiV8YAwJIiy/lxZEF76kN4m+7+zSjnys2YaA5SvMNaCUZWSzvx5wZkkR5lvZyC71aHO+mTZb61DiyyjipdCl94Oc3SXfVhq4aLeR3GIplSlnKWzZYdXm9m+mwioGpnINYb0p4M0z/kXRDTDAAj4uxGXOhb0rqSbDj9LgYf8Y3A2xGYo21zMtkVoUkFNawpV8Vxpp4RuYW9wG8FyjPQf8ctI5spwlM5dFw3jmbAjb/tkfRtBcTAVmrb02W5zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=MFRLkPHGupgYVfZitt6R7L/Yl7TNCOBTbx+jTrKoLmQ=;
 b=nv0rRz0J5NkdpmMqeAHqqrzV5+B0DLy0GikFuHMjYo/NDtDQWcn2+GjXZwtIclm2Cev1BaBtgrMKFkLokYZqlcAkBGz3cUhGKEB/HlBVTZIJowplARSHwxopeYxF4HsqRbtAFzZHmi8AUrUTjTra6W+1awqkoXPWeWIshQcyFGIjh74H6NxO6pnUsBHoX7cq0yAyGSljQcsUyrsoZ6gaAcLFXQFDRLLWYSZPJYyyskH64c46i+5e3bgC2xzl8dS9TEw16zxZ7/H6WV/oHSimR5qmQl8+Ct1LmomwcgBiO/rbyA3/3O6/mX526whpIQPr7MtSW+oTbu9XmnVhpNxWAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB5030.namprd15.prod.outlook.com (2603:10b6:806:1d9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 23:17:01 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4500.019; Thu, 16 Sep 2021
 23:17:01 +0000
Subject: Re: [PATCH 1/3] bpf: support writable context for bare tracepoint
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20210916135511.3787194-1-houtao1@huawei.com>
 <20210916135511.3787194-2-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9cbbb8b4-f3e3-cd2d-a1cc-e086e7d28946@fb.com>
Date:   Thu, 16 Sep 2021 16:16:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210916135511.3787194-2-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:40::16) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPv6:2620:10d:c085:21e8::1426] (2620:10d:c090:400::5:fd5b) by BYAPR04CA0003.namprd04.prod.outlook.com (2603:10b6:a03:40::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Thu, 16 Sep 2021 23:17:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b83aeff-9121-442f-86df-08d97968165d
X-MS-TrafficTypeDiagnostic: SA1PR15MB5030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB5030B6DB07DD67400BCDF60BD3DC9@SA1PR15MB5030.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnRqcgb9Nzi/3Us88f5YJPvRwg7iG6PTTCdxL+PyXfHkr7eTLlWhQOy+Qa18dVeeET0y4xMaMUlvIdL6iwpp1Usb8n6HtOBeHJFJQMchRfrjO24Af5oh4PBb6+P2edv9AbxaX3R92JPTACQM8NuJUVm4AW+ru9vML5czYcVQ3DgPPJnLM9OOBEaYt8Lj7q9Z3hjyx330o9QNfKaBKxrIrfryjCsI6/McX1r347E2eBLx3WdXQZPyLmzVVVz2+WrXIlHkBLnRr7cCem9Sa2FxfMSA+I6XsPrvBTpWdluwgG7FBmzb4OWy51/cDpWYeq46LUriqsSfGSSDHao95Q3BBVIHBFMtN0sGgjadBAbAVlARR7Rtz9zbegCVZr1J5AuTY+1VHues1RoukH8Gsrk+z4QfhU11vK1JYCNpcLMQ4+aXhoxXKN38I09rbWy+dPFOOu04Q2OLkGLbYbDiAK2Fv9tNYGf9/fe9JDrXgHNQXXw3uCIIy+wcs7W8Q/fY8Dof1rPXEhDcdWHcZ8cuimb4MIa9eD4YdXfG9lWr90S5hAgZRNMSR60kXoL/NjOQ1BTlsJd/zmoNke5ngJE+I9wvWa5ZvDICK3fuvrxWxnVGo0moqzfGBHJoHQ7mHTRwyfmSb7yAZ+tRt8CWh3iGDE5/21iaKaeKbG7bdrzDUezJIga0+TqHZcunJTMMQ5gUL3Msg+7UtgYI0LgAxlWMn+Z+WX+VpWRYV2YuDQVDF8/Dnnzca8B9SWO0fG0Uwcyhoz+J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(53546011)(8676002)(8936002)(4326008)(31686004)(52116002)(86362001)(66946007)(2906002)(186003)(110136005)(54906003)(316002)(66476007)(66556008)(5660300002)(31696002)(6486002)(83380400001)(38100700002)(478600001)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjRITzgwL0F3aW93Ymt3RVZtN01GU3FkUnRvejBjV3hxTkdWSXlSeUFQK0Rq?=
 =?utf-8?B?Z2RmU0JESzlWaGhaR1RSMVVFTTdyMGdmdzBJS2hZdWU0K0xHTkJjY0dJd3Vu?=
 =?utf-8?B?Nk40WHU3N0lGYW02MWVZWjF2Q3U2VHhjU3UwdGYva0JwUUR3akJUcFpHMmVq?=
 =?utf-8?B?c2tnSzRYM3dWQlN2YkZ4eWZ2Yy9NWmQ5aHRhdXluU3VHT2FWcGw5SjBWOVI0?=
 =?utf-8?B?ZU43VkhiWEoyL01ZQkRkWk1adTJ2L1F4NWg1L1c4R1ZkL1BpOW5YQUZ3S0pU?=
 =?utf-8?B?dWJIMlI0WUlqeWJDMkNIcStVOFgzK1dxcHJOV281RUx3dWpGU2FuVE1Ib3hz?=
 =?utf-8?B?R2VLNnNodnVOT0o3SkQrc3ptV0Z5Z01HV216Y1hmMlJMNzBGT3pWdlJiWWZF?=
 =?utf-8?B?STFZV1lVZG42NHJpV0ovWjNSZ0FXR0VGUmY5L3FqNENzQVRkN2J0REhhamd1?=
 =?utf-8?B?OU5aWnpWT0x2bnBFRDlPWTIyTERmOFcyOHN2Zlp1Z1pLY2p0cDd5T3FwZnpZ?=
 =?utf-8?B?WGVJdjU4d3p2WGs4azFPTW1xZ1dsMzFGWkZHVklPZW8reXRXWXR5UnFZWkZm?=
 =?utf-8?B?WjFjTWNZSFlubUNVcy9hRDdjRWJsd3oxeFRaSFlwNk5NT3ZVTzNmVkJwZzVR?=
 =?utf-8?B?TjNrUUlSYm1CbUFrQ2orYWNGcXVHaEp4dzhGckpIVTZUVFRieEo4V2ZwVEVm?=
 =?utf-8?B?N3N2NVpNMkh4MFZJRjZUbEw3Y1l1Ry9LYVovWElpaTB4VWRxK2ZTOUVQc09x?=
 =?utf-8?B?S29NUkxLdW9KeG1TdUp5aXBIenFuNktKUnJ3UkFtYzY4SUZWN0JyMnFRWGVG?=
 =?utf-8?B?RGNxNlhGenVCbzdQRW9ST1JZYjAvZkJrN1FMMjdWclNHMG55ZnNkb0Fhbko0?=
 =?utf-8?B?YVhsbjZhWml2NzdoK2JjbDUzU05wNDhmQkpHeFV5OGdGeHNuWnJVZVNlMlRS?=
 =?utf-8?B?OGFXSGI1SWNIdVkrVkJVaWJkR21kUGJFK2NHaDNFN0Q4enRJMERQcHVRd3ZJ?=
 =?utf-8?B?S3FTaE04S0dCTitpWTVUSG54Zmt1dU1nd29iSTd2MzJQNFlrNE5Pd0p2dS9R?=
 =?utf-8?B?dlFzakhMYUJ1bTM1bUlibnVkY0lUUmJmaWFvNkxUb1o4TGdoV1JWNUlnT2pY?=
 =?utf-8?B?Skhnc2xZMVNyQ3Z6MVhuSGNEK3B1RkRBZ085S1NZZGswOWFOejg4L2xJSXNp?=
 =?utf-8?B?Z0czR3VlUitHVXhoaWF6UHpoZWgrcnVZa0xrT1VHbHZMNlZTVDFvR3ZOTmR0?=
 =?utf-8?B?Zis0RFIrOWNGY3NzV1B0b1FvUnBoTUFUTlZLTGlubFVMa3pGMWsyaEpNS25H?=
 =?utf-8?B?a0UvMG9NZDhnZ05jNUFnalVCRTNpeWpyemdaZ1NVa0t6WUZZck11d3FFWHVI?=
 =?utf-8?B?UktLZGtoT2pBaUs4YVRFcVdkK1RsemdOQVk4T1U5d2pMY3huSlNzNXRid29V?=
 =?utf-8?B?K1Q4cWhleXcrNXZkMys2dUxOTzJobUlabHNvY256TTFvK09xS1IrUDRGaXA0?=
 =?utf-8?B?N2R4NkxtOVROYUlSTzhMNFZYMDJhdVhPbytYK3NnZ052YVM5ZFBza1NweWZr?=
 =?utf-8?B?UWpyaVRhcGNjUmorbmVxQ1RnVFlEWGVaa05MZ2pWM0NqbzlRTUxVSjBNYWJ6?=
 =?utf-8?B?NWV6SEgwN29uaWt3SkFpeEZNRy9KV3V4ejhEZkY5WVFEN1FHWVJqSi8vSWQw?=
 =?utf-8?B?MVpXZmNIQlh1Vmd4S1dBMDhqSE9qNm5aVCtYK1ZkVjJoVWJ3Nng3TGRCa1p3?=
 =?utf-8?B?a2tNWHhnUXBsaDkwcThMTmdNeWxZeXQvK21WMUQxdDZDNEhneEl2cmU5L1VS?=
 =?utf-8?Q?O9qSPu2VpHNQiGsibYAK033rr2NzTx8ciLaIw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b83aeff-9121-442f-86df-08d97968165d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 23:17:00.9193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2NigkC0NXjrZVBrgLlXlI/FGfVaM6Yzx42HF5m1CIu3g0kIQauq2GvCfJA36cqsN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5030
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: IXtQ_c_T6BoKOReFxvvlXOBZByuPATm1
X-Proofpoint-GUID: IXtQ_c_T6BoKOReFxvvlXOBZByuPATm1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-16_07,2021-09-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109160132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/21 6:55 AM, Hou Tao wrote:
> Commit 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
> supports writable context for tracepoint, but it misses the support
> for bare tracepoint which has no associated trace event.
> 
> Bare tracepoint is defined by DECLARE_TRACE(), so adding a corresponding
> DECLARE_TRACE_WRITABLE() macro to generate a definition in __bpf_raw_tp_map
> section for bare tracepoint in a similar way to DEFINE_TRACE_WRITABLE().
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   include/trace/bpf_probe.h | 19 +++++++++++++++----
>   1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
> index a23be89119aa..d08ee1060d82 100644
> --- a/include/trace/bpf_probe.h
> +++ b/include/trace/bpf_probe.h
> @@ -93,8 +93,7 @@ __section("__bpf_raw_tp_map") = {					\
>   
>   #define FIRST(x, ...) x
>   
> -#undef DEFINE_EVENT_WRITABLE
> -#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size)	\
> +#define __CHECK_WRITABLE_BUF_SIZE(call, proto, args, size)		\
>   static inline void bpf_test_buffer_##call(void)				\
>   {									\
>   	/* BUILD_BUG_ON() is ignored if the code is completely eliminated, but \
> @@ -103,8 +102,12 @@ static inline void bpf_test_buffer_##call(void)				\
>   	 */								\
>   	FIRST(proto);							\
>   	(void)BUILD_BUG_ON_ZERO(size != sizeof(*FIRST(args)));		\
> -}									\
> -__DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
> +}
> +
> +#undef DEFINE_EVENT_WRITABLE
> +#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size) \
> +	__CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
> +	__DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>   
>   #undef DEFINE_EVENT
>   #define DEFINE_EVENT(template, call, proto, args)			\
> @@ -119,10 +122,18 @@ __DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>   	__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))		\
>   	__DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), 0)
>   
> +#undef DECLARE_TRACE_WRITABLE
> +#define DECLARE_TRACE_WRITABLE(call, proto, args, size) \
> +	__CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
> +	__BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args)) \
> +	__DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), size)
> +
>   #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>   
>   #undef DEFINE_EVENT_WRITABLE
> +#undef DECLARE_TRACE_WRITABLE
>   #undef __DEFINE_EVENT
> +#undef __CHECK_WRITABLE_BUF_SIZE

Put "#undef __CHECK_WRITABLE_BUF_SIZE" right after "#undef 
DECLARE_TRACE_WRITABLE" since they are related to each other
and also they are in correct reverse order w.r.t. __DEFINE_EVENT?

>   #undef FIRST
>   
>   #endif /* CONFIG_BPF_EVENTS */
> 
