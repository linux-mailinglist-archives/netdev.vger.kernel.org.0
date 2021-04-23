Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD1D369D13
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhDWXEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:04:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15482 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244088AbhDWXEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:04:32 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NN0vik007287;
        Fri, 23 Apr 2021 16:03:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JFt9TQrDgpUuNjIgW1rg0gbSpeip0XX+AJ72MqJm9cU=;
 b=YaukeDMHASfTEhvQYTljZ7oC4ylT5IHG5hl475LwO7kHYPe5QHwJ7fl1lT6f25SbaA1A
 oELGOPZZVprmCevw5o+3TMj1jJzO9hdMA5rZn0WgDr4MuI4tnTHCnE8rlLF0IYSoAC6s
 IljEGFh9gyUdmsaG56VAdkr+MIfuFSyLfwo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383b4q9k2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 16:03:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:03:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izAAGMvH0N2OaNKZ1vrLGE9ELmttA3A/B24rRdP7+VnVJ/GJd+v4BC/RlInK2cVwU7oJdfTKGRC92RutUXrnKertipKH7jV5zvJBUX3EoijCm+RJt5iGT0GCJwjDV0XtNnbXvlspMi26xqAkCuYbCMiJzoeDZG7leRcP0m0gsCCGZ11aOaDGdSIlIXBgPfrOrT+qShbdKfmjztYBfwtqwBsNGwee7L4FqACWJlBRo3YaVbeBzPr+tK3vBHMBCgx1Xuw9ydpbHrb/ks2gRFuJwjeciXBOV+qG6PwU6+jWR61vvNDNM7MjtmEExTJBwa/DC2jGSMBsfs8Cp6L89ZJcYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFt9TQrDgpUuNjIgW1rg0gbSpeip0XX+AJ72MqJm9cU=;
 b=c67Jc8E+aP0XNs7/G7/KkYytXbtDI+UsDyx9/DgqYYwHgxuTPcKACto6C/Rstxv9lBuHKDoVXpJUuvmTrFG9GLv8qZKc9lOZsNQMTWYpLxjZHxxbvmuTUoLFExB1zgf1mb1iWk2BqOu99KHL59VE5gJ8dwc62MhsFx/VNSN7IYeWGy6Zt9I1Xxeamg0Nh4IoybLDvhCaFLL34DrIbzxS2LimNAgq2P/j+3mgIZ+cq560MExk/Ouyh7xDII8zTlgkm11yNYAtQKA0eaS4VZngHF1HaxoYshhPPMjD+3AXjhPE8jHhrsTROiT09h9VcDWtfsIr5bXs82xxMyVDRAmZZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4657.namprd15.prod.outlook.com (2603:10b6:806:19c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 23:03:40 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 23:03:40 +0000
Subject: Re: [PATCH v2 bpf-next 5/6] selftests/bpf: extend linked_vars
 selftests with static variables
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-6-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d1693e2c-35a3-a411-edd8-3ea0964abb74@fb.com>
Date:   Fri, 23 Apr 2021 16:03:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423185357.1992756-6-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a7ce]
X-ClientProxiedBy: MWHPR1201CA0021.namprd12.prod.outlook.com
 (2603:10b6:301:4a::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::134e] (2620:10d:c090:400::5:a7ce) by MWHPR1201CA0021.namprd12.prod.outlook.com (2603:10b6:301:4a::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 23:03:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c73b8d3-4b43-444d-b708-08d906ac08cd
X-MS-TrafficTypeDiagnostic: SA1PR15MB4657:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB46578D7AEC96F971538617E7D3459@SA1PR15MB4657.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6Jv2SyNAweb893H/C1X4+w9b6k3R9DIxPneAZpqe6HeLGCbcf0HZJG3nD8DMadcq2Q1dXEl7n2N7DPh6nG4gMsGeFh/yYw4QFmXWZ4LdTmLTKKByC78aFFQjHqAiPzhNlqspt4aiTo9+pe0MYF8Z5vU6XDRW4M1N0Xu/y/NEWRP+ccLl27/+gReEM5TeYKTl8UFDkSzFX4vPW5ldJ0IQblxhJI9W+9KreBX2D+kIYLzQmWb6FHfE+YlPztz/fTVPfvdnm6eeT4Lwkkwoa2a6wgwkwmjecxISCvXo1ItaSFASt+oCKLWixrd5AKmmdVZksB7SHi8COM/+vqsHWFzV+KsqHofyWPkuO4VMr3xkbbvYW8fJiqQ3baj13G0QXRyvPPLgxh2TcxTnTcVhY1ZnOIthT1hmY+JFiKz7mCje3QWEKWO7up5xlNSH9FqhxrvzwDaO+LKW54PT6GaucOZuhAa5kxT42JABzf8fJQJ4PAgvqDXeuqnekQITDlvH2HRLfey4pb2geNGlYgYVq/lrDK8KOJQAgx+RHdeU+e8bgVOqW02Ix/gUqiNeGRgFJ/3jpLsvIhgWbTxQd4/47zEI62ecI/1qPuOXHYNFl6/PUl/PtcA3bCIC2bF60wc+j1AKZbtkY88hCelqxm3EzubMjKbQbvWPE2GTGdCdefwwW9N1Ila/PHPA032eYwL4sJj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(31686004)(38100700002)(8676002)(36756003)(52116002)(478600001)(66946007)(186003)(2906002)(6666004)(66476007)(66556008)(53546011)(2616005)(31696002)(83380400001)(316002)(5660300002)(6486002)(4326008)(86362001)(8936002)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L005aWlTTm1CeVZHZEJ3NlhpL20wWitmNXo4d0V0aCt0QXFjdFFRTFEzNWlz?=
 =?utf-8?B?VkdnbDN5UXRla1JKcHFneThsZHIzNW0yRUF6S2kvTUQ1SWVLeHdZb2I4VUVM?=
 =?utf-8?B?alYzMEhaVU9zYXQzdWxpN1dXWWgzNE52Wjk1YS9vMUJDcmozVmNXNEtpNUdL?=
 =?utf-8?B?aUlxRUI3SGx2Y3Iyd1JWbGxhNml2VWx4bk9KYk0vOWRrY3NqT2lFWk53cyty?=
 =?utf-8?B?VjB2RXgxdEhQN2FtU2pjZy9FdTkxVTZxbE1VcFhPOWpLVjlCLzdPcjIrWVVv?=
 =?utf-8?B?RFpLcWtHdlpyRnhrVTdaUVZNek9XM1owVFU4U0tKbHA1T3ZJNVdqS1VuVXMv?=
 =?utf-8?B?MU1vVVl2Qjl0bHJVNC8vbDR4enpUY3o3SGxCek4wbUlyODEwUFd5TmxuSHor?=
 =?utf-8?B?SEhvOEw3RTY0Nm9MdlFrbDhycXRUUklZZ2VISC80VnJUejlxdFlNZ0FzdHlR?=
 =?utf-8?B?T25hWTZmdlVxL0p2QTVSYit5SEo5T2x1c244VTVHK3hiNXpZWktqL01nejJS?=
 =?utf-8?B?ZkxnQy9tTGFGZWsxOVlGaVlPVFpHSWM1dGlpZzFJRW9PRkxQSTRRQkxxQmFv?=
 =?utf-8?B?L2Jqby9WQm11b2x6eXN4MW0zdVNwV2swREcvbm8wRndINmkzMWJyZVBvT05K?=
 =?utf-8?B?U1RkL2lhVnZlL01Sbi9Mb1RXSFo3S1h4ZWl1S0xDeFBTcXp0UWpWZHNuaFNB?=
 =?utf-8?B?c1JZM3JxNGc5UnVxdzNBT1lqeUtRY3RFeGxhOXlhK0pqaHUwdnFVVko0NVVs?=
 =?utf-8?B?NkR3WEcvcGU1ZEp3YjhXNjNNb3BZTXpnQTY1T3lhMW5rNlA3Y2FKOHNjS0xy?=
 =?utf-8?B?MEhqZi9KZ0NCcW1qazZWakMvdW94WmdNeHNoaEx2M1ladlVkeUJQV0xBbkVx?=
 =?utf-8?B?RGdrV3NFOWtxZmFCVlQ5bWswb2pseis3Q0l2L0R6WHV0M3BLdUVkY1JoZitw?=
 =?utf-8?B?b09MQVByNU9JQUQzY0lHbit0ck45WEY0Q2pLZlFLNGthYlBWSVc1LzhaRW1I?=
 =?utf-8?B?eHZvL1IxQXNycjVrNCtOM0FqV2VVLzBqSXRsMm1hQWM3UGsyWjBqdmpLaWtT?=
 =?utf-8?B?ei9Hbzd2cUNrcWNHeFlyZDFaWWVnOTloVmlrdjZJNWNORy92TmdnNlBWdVJL?=
 =?utf-8?B?Vi9Qa1ovaFNRbjVLN0ZHUHBhR1pTZExOeVRvRVZpRFF0WjE3VUF6cnBaL25u?=
 =?utf-8?B?MGhXbS9IMmJOU2hJNmJwY3RwMkRVak1KYlZzcWxkbTErTEZFbHNsTjkrNGRi?=
 =?utf-8?B?S2VWYy9udnh3NnpWWVp2R1BTdEFENkhLaHJvb2pmWmtWc0YwaHRNc0FUSmdJ?=
 =?utf-8?B?bG1yL2VhQVRld0FNSFdZM1V1bmxUUlF4TVlmWHYrUEMrd0Roa0VUamNYcytq?=
 =?utf-8?B?NkpJclZCZHF3MVBXOEpyVk5OVTFUUjdUSS9jRG1IeUU3bG9rRWlrbEF1YkJJ?=
 =?utf-8?B?c2ZRaFhybFJlQnkzOHU4S1Z2L3JIcU83WmU3eEZtVXRocGx0bUNScTJiU2tk?=
 =?utf-8?B?VjFleUpnUkVmQlBnVm16YVFjR0ZpVW80YnB2TTBUOUtNUEkzaHJvTUtoaDNF?=
 =?utf-8?B?NDdwUTFmOCt5MzBITGhTNWZwTGZaS2ZvN2ZWb1E0VXl5QXlURGVLUGFtN0d4?=
 =?utf-8?B?QXdwRG8wNXJ6NXRZM1o0RU1OQWxDNW84VlhWV2dMNk5QSlRmeXVVUjBRdVFs?=
 =?utf-8?B?elZXcC9KbG90MEtMcU44SlRXNSthbWswL2t0VFBPZUx4aU1aLzIwMjkwTlUy?=
 =?utf-8?B?QTRpb1ZQcDdldHhSRWJaazNFeXNxY21qVUlIQVREZDQvWGJkZm84YUIvY2Zj?=
 =?utf-8?Q?0pU2t4QM6nyPlrIvfavvgf3cW07+bqvtR7fK0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c73b8d3-4b43-444d-b708-08d906ac08cd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 23:03:40.2916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KUgH+6CRneL/FeP6ORser5LJQ/tGHMNxhZRCPiUHv58MSjNSrB8TtWjPonr7uSDi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4657
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 1U6Ww6Gb30qTy63Y1nriGQIrseZL0dMP
X-Proofpoint-ORIG-GUID: 1U6Ww6Gb30qTy63Y1nriGQIrseZL0dMP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230154
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
> Now that BPF static linker supports static variable renames and thus
> non-unique static variables in BPF skeleton, add tests validating static
> variables are resolved properly during multi-file static linking.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/testing/selftests/bpf/prog_tests/linked_vars.c | 12 ++++++++----
>   tools/testing/selftests/bpf/progs/linked_vars1.c     |  4 +++-
>   tools/testing/selftests/bpf/progs/linked_vars2.c     |  4 +++-
>   3 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/linked_vars.c b/tools/testing/selftests/bpf/prog_tests/linked_vars.c
> index 267166abe4c1..75dcce539ff1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/linked_vars.c
> +++ b/tools/testing/selftests/bpf/prog_tests/linked_vars.c
> @@ -14,8 +14,12 @@ void test_linked_vars(void)
>   	if (!ASSERT_OK_PTR(skel, "skel_open"))
>   		return;
>   
> +	skel->bss->linked_vars1__input_bss_static = 100;
>   	skel->bss->input_bss1 = 1000;
> +
> +	skel->bss->linked_vars2__input_bss_static = 200;
>   	skel->bss->input_bss2 = 2000;
> +
>   	skel->bss->input_bss_weak = 3000;
>   
>   	err = linked_vars__load(skel);
> @@ -29,11 +33,11 @@ void test_linked_vars(void)
>   	/* trigger */
>   	syscall(SYS_getpgid);
>   
> -	ASSERT_EQ(skel->bss->output_bss1, 1000 + 2000 + 3000, "output_bss1");
> -	ASSERT_EQ(skel->bss->output_bss2, 1000 + 2000 + 3000, "output_bss2");
> +	ASSERT_EQ(skel->bss->output_bss1, 100 + 1000 + 2000 + 3000, "output_bss1");
> +	ASSERT_EQ(skel->bss->output_bss2, 200 + 1000 + 2000 + 3000, "output_bss2");
>   	/* 10 comes from "winner" input_data_weak in first obj file */
> -	ASSERT_EQ(skel->bss->output_data1, 1 + 2 + 10, "output_bss1");
> -	ASSERT_EQ(skel->bss->output_data2, 1 + 2 + 10, "output_bss2");
> +	ASSERT_EQ(skel->bss->output_data1, 1 + 2 + 10, "output_data1");
> +	ASSERT_EQ(skel->bss->output_data2, 1 + 2 + 10, "output_data2");
>   	/* 100 comes from "winner" input_rodata_weak in first obj file */
>   	ASSERT_EQ(skel->bss->output_rodata1, 11 + 22 + 100, "output_weak1");
>   	ASSERT_EQ(skel->bss->output_rodata2, 11 + 22 + 100, "output_weak2");
> diff --git a/tools/testing/selftests/bpf/progs/linked_vars1.c b/tools/testing/selftests/bpf/progs/linked_vars1.c
> index ef9e9d0bb0ca..7d5152c066d9 100644
> --- a/tools/testing/selftests/bpf/progs/linked_vars1.c
> +++ b/tools/testing/selftests/bpf/progs/linked_vars1.c
> @@ -10,6 +10,8 @@ extern int LINUX_KERNEL_VERSION __kconfig;
>   extern bool CONFIG_BPF_SYSCALL __kconfig __weak;
>   extern const void bpf_link_fops __ksym __weak;
>   
> +static volatile int input_bss_static;
> +
>   int input_bss1;
>   int input_data1 = 1;
>   const volatile int input_rodata1 = 11;
> @@ -32,7 +34,7 @@ long output_sink1;
>   static __noinline int get_bss_res(void)
>   {
>   	/* just make sure all the relocations work against .text as well */
> -	return input_bss1 + input_bss2 + input_bss_weak;
> +	return input_bss_static + input_bss1 + input_bss2 + input_bss_weak;
>   }
>   
>   SEC("raw_tp/sys_enter")
> diff --git a/tools/testing/selftests/bpf/progs/linked_vars2.c b/tools/testing/selftests/bpf/progs/linked_vars2.c
> index e4f5bd388a3c..fdc347a609d9 100644
> --- a/tools/testing/selftests/bpf/progs/linked_vars2.c
> +++ b/tools/testing/selftests/bpf/progs/linked_vars2.c
> @@ -10,6 +10,8 @@ extern int LINUX_KERNEL_VERSION __kconfig;
>   extern bool CONFIG_BPF_SYSCALL __kconfig;
>   extern const void __start_BTF __ksym;
>   
> +static volatile int input_bss_static;
> +
>   int input_bss2;
>   int input_data2 = 2;
>   const volatile int input_rodata2 = 22;
> @@ -38,7 +40,7 @@ static __noinline int get_data_res(void)
>   SEC("raw_tp/sys_enter")
>   int BPF_PROG(handler2)
>   {
> -	output_bss2 = input_bss1 + input_bss2 + input_bss_weak;
> +	output_bss2 = input_bss_static + input_bss1 + input_bss2 + input_bss_weak;
>   	output_data2 = get_data_res();
>   	output_rodata2 = input_rodata1 + input_rodata2 + input_rodata_weak;
>   
> 
