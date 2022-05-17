Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA97529A4D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240499AbiEQHC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbiEQHCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:02:13 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC98246B27;
        Tue, 17 May 2022 00:01:53 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIXOXI022452;
        Tue, 17 May 2022 00:01:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6h5xm4JmQFoTFEIY7PgLbaJWKi6rfumkFvziukNEZ9s=;
 b=gqHSsxV4G19VlT9tDaIQUeA8JKrsoZSX4DtWC9wBM6gveHM+zwu5OwBGuruu4C7CoeJK
 ElzDinaMnKiHmjzxelpZftNBRqFivrDrEELH7HeILcw31wMt8UtmP5zNwuHy0mx8wuEo
 b6+ITF3Kr0ACVcPm5ynHOrz8kFXNJo67ZVc= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a8u74e2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 00:01:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WA2hkMxdxIBjJgFVWBwS7oU6Dqmbd4ZvsfiibyRhUebVLJ56PUZQFFQ8nJfAsJBDch5kJ8jyKjE0b41no583hhDO2NGTWOk40e8pDZFgqUlKN4swxLjunaMEDDK5qjIn/X6hGb9lILUFNvMWMRamuKTvCjkpI2K8yjW3cjBmp5qPxwZDMUtV2UnTR+wgUhLpn16HE8sivJCG+KCYUSxKri3yBGcvk4z6Vu2WzViDC5sWfqgWpKNca9fDvHxk9u9ckhB6fbkvsywiWzKkD3NwDR67wIP7NKhUFRw+tDazNfXC03psl6/8t/jQ44ZvpF+67djIAa8tmxFs/VFqeDiTJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6h5xm4JmQFoTFEIY7PgLbaJWKi6rfumkFvziukNEZ9s=;
 b=mxpZB5CwZsM+1hEbphUPlbZaZp70A4IJb0Zn74RJumAdBmp9GuG0aX9SZtNis6iwgUxe1aMnm1J66ulbI5TL0TY/iaL7RBl1NDxkeQ5keeuqROG3JLH/3n/DAocnM+U0ezUXidwPZGWgTnMVjZm0q33fXf0sJ6QJla1HHNeBgJUAs6uyMWYbjoDd/FDkxed8aTm276KGRnrnM0qMBsUcoA8+T43r4D4HS/f3Kj2N17q+1TnUYkvy8IhQhV6ZZFYllZnlQ+FCLbYi0coMVqSgaMN8jyqTNjZ2tzubcuH+aluKV3TIWa3AZNqXx2mTR3oMdWpZcpKYMwZdpaWsc0649w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SJ0PR15MB4201.namprd15.prod.outlook.com (2603:10b6:a03:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 07:01:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.013; Tue, 17 May 2022
 07:01:34 +0000
Message-ID: <d54a6bd2-904c-f4c4-5ee0-dd8fe6c64679@fb.com>
Date:   Tue, 17 May 2022 00:01:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v2 1/4] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Content-Language: en-US
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <20220516230455.GA25103@asgard.redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220516230455.GA25103@asgard.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::7) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecd9a164-d5b4-44e7-6125-08da37d31451
X-MS-TrafficTypeDiagnostic: SJ0PR15MB4201:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR15MB4201DDD8B324325C9AE5FD33D3CE9@SJ0PR15MB4201.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PlZ71q5vfPrxa3WvLcFyo2fEjqRJM5184yFav7eVl1fG2o6jxY+baH96mmqOTYxKi/FFprtwgrlcPUodltfq44+L01ngDWF9FmFxvCbkECy5DJYHGHP6b1Bur6IIXlcqc6ofBD36xa9TaEXW13mSkjpxbxm1L0mBvpnOcaCFd4UdiMIW/17TqCXhlx6TO9ZHZF+aI1WXqH0qnh0kr42B/YwJaKFWjGtYdOt9/+zjzV5D+/JAo6HjrqlcLpubunjJBop8ZwUv9keeJODjPkjb6v4mscH5EXDAAdqCy7JPP1YhCmGzG7eue9mN5EofCPUj6bmS1ztFu+08WLZx4zcQUncSDBELT1idco5LRgyNdTmskw+RpUsFEcGp02vLwwhj0xyUpI0VJm3L5x1eqET0vj6BQm1bPByePvvioPe8Yr4OkIW3RgmWN9Dv5VHwlstVnQu69sxLSucI2jkcHEL+2KPbrkQdJgT7c3wmu18XiTksAqn86+/wk+nhROw6DvCBZ1jIFOk6yqGwtHVbtWwBx6uXZpFoDl2CzxTi4xKAOH+BSYu+RWNltKTrlE2TdWjNgoQKlVd5tWEbH7z4VOqJQnK2ZaQ/lgwPkX9zdFhA11plc/Bm0ZVQBoLPQBdQznJG12ZwBN6yUJOLK7bs2qlVMj2uzl3sjHGIs+fO9/AaK2QDQ1wGS75ltR6fQpVSwPttxUxVFcpVz3ykFLlUBx1FII6QcCqdaGq80S7k9Fuv+Rt6Bda/qkKoLZMCs/3TtWWI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(31696002)(83380400001)(2906002)(6506007)(52116002)(6512007)(53546011)(316002)(7416002)(186003)(2616005)(508600001)(8936002)(6486002)(66476007)(66946007)(66556008)(38100700002)(4326008)(54906003)(36756003)(110136005)(31686004)(8676002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3UvNm5LZUJqTHo4VWl6eGh2N282RHY3VXlraS8xSGNweWFvWmpybXkwZ0lv?=
 =?utf-8?B?UWsveTU0UFdrMXhiekJjczJoank5MG4wMFA4V2JUTHB1TEw3ZUNOM0ZZRW5h?=
 =?utf-8?B?VE9pM3Y3TmU4bG96d1A3NXRYUXZtYmR3eTdNa0RLc2RVOWhWc2Njb3FuLy9S?=
 =?utf-8?B?MVJrSjFMTEpKb0FuMjRCK0txTmRtV3JmWkhOaFhiUVJUeldlVWNjcG43aXZS?=
 =?utf-8?B?STV1ZkFCTGlycmhoK1lzanZtMG0xSXB0emFjVlhpNHlmTXRKaVoxRjFJZXk0?=
 =?utf-8?B?Y0tvcFh3WXhsM3RRWno1N2M0STRqQzBKb1kvZUYrYnZLTnBGNDR5TFVDK20r?=
 =?utf-8?B?Ym5PWXdkS0xBMnVWYjh2TnR5bFlNSWRHdFlsQ3F1WllyWjcvZlBBaStETENS?=
 =?utf-8?B?QXBZR1RJMmxoOU91ZCtjM01WY3NidDZZYWwwb3NnY2U0YlhjY2xVMVNyak4x?=
 =?utf-8?B?Q3ZlWEFISkJUMHBQOTBhSFpVbjl0bUFtbm0vMDVVbmpBNnZ0c1FTMmFzVGt0?=
 =?utf-8?B?MDNWTHdMVitlZUZBL3lsRE9CN3ZmeG9keG8yQmtQV3VWWTBYQUtaTmFJNG00?=
 =?utf-8?B?dWxudzkzKzhOUmhnMnBIODlEWmtwYWIzR09XdDFVRTlTRDE3K3NWL0IwUEg1?=
 =?utf-8?B?MXcwaWNLTjNtcndtQ0ZYTnBpSTJ0UE80S09XRTlWQUgvclVCS0VjNFhWVTJH?=
 =?utf-8?B?c0U4dkdlTFN1b1ljZ1Jzbjh5eUdKdUphNyt5NXVMV1lIcnFpc0NRNDVwOFFj?=
 =?utf-8?B?SURrUkRJRXhTV0EyT2Y3NEhZTkUxdU95cHZlb3V1OXVWcDNCMkFzWlpSZkR1?=
 =?utf-8?B?S3pOb0poeWp2dDNBYTFyT0xkdUg3ZXlNNFl5aFlVbWdrb0NEaVM3M1ZuVExx?=
 =?utf-8?B?OVdlM2RHbzh4R3QyKzQ4U1Q2QmdlWmg4UG5jd2pTT25CTTBrUWtHRHUvT043?=
 =?utf-8?B?b21KcXozdWQ0eU1paHhDcnN5VG52dDFtd3JGNmJMKy93aXZ3b0k3VDk3Nk05?=
 =?utf-8?B?WWtGV25DZUtWdk5PdzdlUS9yR1pQQzd5Z2w0UWFYU0VyYlZSdUR2M0RnaFVK?=
 =?utf-8?B?Z2FTNFJtZFNTNDR6Wk0ybU5neWVNazQxeHlqQTFYVmFOZmptcWdYaUNhTlhW?=
 =?utf-8?B?T3FVajhMSG95SEdmb2lCRlBheDNQbWdOcm4zVVppRmxKazV5ZlNXTVplM0hI?=
 =?utf-8?B?cC85TTlMSUplRXFLcm5sZ041MDk2U29DNCtlMjhnWXRka1RHM2oyM3Bndmxi?=
 =?utf-8?B?WUtZakI2VUd1VENRV3VHZC9Nb1pEbDBTZVkyS1pxZWd3QkRuR2RyZFFoSzlS?=
 =?utf-8?B?ZWVIWklYMGlNM05Mdlh0cHFJeEdmUU5Ja0h4SlhPa2k1RzV6Z1RjbDVjeklK?=
 =?utf-8?B?dWdleGJNOEM3M3J3ajQwc25JWWx0dXZSN0lLcHpFdFU0M1liVzhKVnpzYnpR?=
 =?utf-8?B?YkM2Y2trbHNJU2pTb0szSkFCQlV4ZFZ2VWdxeVdKR0I5T0pxOXROaGxoakZQ?=
 =?utf-8?B?RGVVbjBPeW1qd0R6UkJVZ2VmZG5XbWxMU1F0NWhpWnVmVmZZZ3ZMeHYraUJQ?=
 =?utf-8?B?MkZmWUtDbGJvbVZFell1dEl1OTQ4akwrWlJXUldaM1lkcTFvMkhVQ3pLV2o3?=
 =?utf-8?B?dmo0TWNFbHBLZnM4VHZWVTB1c3FsMGdHU1lMRnBQZ2F0dU9Ta1dsUkRzMk42?=
 =?utf-8?B?dDcrS0U0TjJrVHVWdjgrUU45dFdsaVltd0l3Qm9mb0VRZkF6Tm9Kd1pyQU1M?=
 =?utf-8?B?VnBuVEhmN0xrNWdQenMvSSszU2VNMDEwRzZoMVFPSHY3am5VNm9yalFlamg4?=
 =?utf-8?B?TnUzQVZabTNxd0hXdE1odTdGWDhERjNyck56amhuSFBBZUpSa2xUOVc2ZFpx?=
 =?utf-8?B?NExFM1JudTBGdmNDd2R0L3dwci90ZThra3NKU040Y1Jaa3hrbU9kNmxXaUpX?=
 =?utf-8?B?QkNmMDgzT2IwdE1SdmdiM3RickhzOE05NzlvL0kvRGNDbVk0NVRrd0dtb3Rh?=
 =?utf-8?B?Zm9EaGg1N1UzYTVjdUVnQmRFekNtenNCZDZYZVZyZ25CRHVwN3l3UVhQMnpG?=
 =?utf-8?B?aUVvZHdtN09OK094NExsUEJPSHVSUFJaTnpZNDRQWE5PRlJDVlc0UnB4RjJj?=
 =?utf-8?B?cTlHMzMwL25UVzh3aTJXY0xvN0JVZ0xJRlpUUXNwQXd4Nlpla2tGOGdEVjZZ?=
 =?utf-8?B?RCs4NzRPa3pJYmJCYm8vejFPVU9QS2JtRzlSSEE1ZnNKNWJacTh1bmFodEVi?=
 =?utf-8?B?SysyYjJnQkFtRFl5WUJVdUR4UVp3bmtZNWRLNjNQekRVcURtMU5yTVZQRmdn?=
 =?utf-8?B?RncxSnFuOStyMnIwQktIeUVSa1Mvd01oRkEvVmErMlNXLzA0WHJ4RU5jSkJ0?=
 =?utf-8?Q?ili7B1zxpQcRqaTU=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd9a164-d5b4-44e7-6125-08da37d31451
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:01:34.6101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPd6kcMIsSKrvTUxGOTW4qZUJKrJO61VHm0LTilTFIERPVdINvK27yVVOvFWCOMq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4201
X-Proofpoint-ORIG-GUID: 1YpaJ4p7uccOXTKK67h0pTQzskj6P-of
X-Proofpoint-GUID: 1YpaJ4p7uccOXTKK67h0pTQzskj6P-of
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_01,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/16/22 4:04 PM, Eugene Syromiatnikov wrote:
> Check that size would not overflow before calculation (and return
> -EOVERFLOW if it will), to prevent potential out-of-bounds write
> with the following copy_from_user.  Add the same check
> to kprobe_multi_resolve_syms in case it will be called from elsewhere
> in the future.
> 
> Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>   kernel/trace/bpf_trace.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d8553f4..f1d4e68 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2352,12 +2352,15 @@ static int
>   kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
>   			  unsigned long *addrs)
>   {
> -	unsigned long addr, size;
> +	unsigned long addr, sym_size;
> +	u32 size;
>   	const char __user **syms;
>   	int err = -ENOMEM;
>   	unsigned int i;
>   	char *func;
>   
> +	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size))
> +		return -EOVERFLOW;
>   	size = cnt * sizeof(*syms);

The statement 'size = cnt * sizeof(*syms)' can be removed right?
Here, the 'size' will be computed properly with check_mul_overflow()
if 0 is returned.

>   	syms = kvzalloc(size, GFP_KERNEL);
>   	if (!syms)
> @@ -2382,9 +2385,9 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
>   		addr = kallsyms_lookup_name(func);
>   		if (!addr)
>   			goto error;
> -		if (!kallsyms_lookup_size_offset(addr, &size, NULL))
> +		if (!kallsyms_lookup_size_offset(addr, &sym_size, NULL))
>   			goto error;
> -		addr = ftrace_location_range(addr, addr + size - 1);
> +		addr = ftrace_location_range(addr, addr + sym_size - 1);
>   		if (!addr)
>   			goto error;
>   		addrs[i] = addr;
> @@ -2429,6 +2432,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
>   	if (!cnt)
>   		return -EINVAL;
>   
> +	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
> +		return -EOVERFLOW;
>   	size = cnt * sizeof(*addrs);

Same here, 'size = ...' is not needed.

>   	addrs = kvmalloc(size, GFP_KERNEL);
>   	if (!addrs)
