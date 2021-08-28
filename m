Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E538A3FA704
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 19:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhH1R0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 13:26:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38392 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbhH1RZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 13:25:59 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17SGcYRJ012919;
        Sat, 28 Aug 2021 09:45:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0kwdN+Y1Ne8FI+W+FoDZzBzoiQb/Y/0XDE9NZ3b3FNQ=;
 b=EeCSBef9DuM6cTKpSODH7D67176gGVRff1CWfSZM7+yQb9dNDA6mQmhVivLV+XPNF/3t
 JJVPlc+prxt1u0Xhz3WnSCAFm0Fd6PJzDM2BANz5RH5VfIvIUoBb+0Ki40Xvhk5/tLht
 sIB7d61oq5e1Pqr6dhRnXsJjqqTNu/yurDo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3aqjyvhdgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 28 Aug 2021 09:45:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 09:45:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PEy8aY6CqrlPtWI0S6h3pX4a8OsUyBLV7nltElcTflpyJTlPe9jWMAsMcLFE4cxBNnjsfj5699YuYyyNibaMw1Fw1+PFON1K3W3muuSzZ2IEq+0N9dKP1FSPDMOWsKdC6l/nYZqe16YFjq1p87iqwLM0tPTy1QJj4k7KN95dpNy7Cor6WpxBI4tRp7BugGkUWII+4GeF8sy2OrLzBSQYeYLFizi98AZL4hKUolufxEFPT7ZFqyImwVaJSPrTYdLcbyz5WqEHBKsZbFned/+70UrhypXquz9j0mY+sQGNtkvwssAjRLIBTx+Jou1X+suSlPpFNb+SDl4Qc+9qRnUnsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kwdN+Y1Ne8FI+W+FoDZzBzoiQb/Y/0XDE9NZ3b3FNQ=;
 b=QYuJkdafQM0LEHKetJQOv0ZBeCBB84kfOFdtMC9hHUoPSvpirDdPUIRNEjAYMmA0htOdfPxcjsemjzturZwxWpQDru34tQDdOrC5x0bWWxyKGXP/BUgocoaYlaidDIIjgq9KE0abCGbWzVp8XPB/XZmBVcqEhwpX2Uk+r4Be38vsCqYRqLmZGRwe8t7wrcMjPTwuF9bUxanlQRoelrNbIk32+HUydEvH4BWJDXhJMwKNh2cmAUQBKv/ogqSr78/UFVYWa/lBZKcfIQk119X1whaVpxM/IqgHnYwEOuUJP7Go5pDC14HRnd4gNpSnJ/gxLYvb3TaRNoSzFIFSjWefNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM6PR15MB2972.namprd15.prod.outlook.com (2603:10b6:5:139::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sat, 28 Aug
 2021 16:45:02 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6%7]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 16:45:02 +0000
Message-ID: <9e742d39-1ee0-b08b-9ee9-edf5b8687d8d@fb.com>
Date:   Sat, 28 Aug 2021 12:44:48 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.0.3
Subject: Re: [PATCH v3 bpf-next 3/7] libbpf: Modify bpf_printk to choose
 helper based on arg count
Content-Language: en-US
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>
References: <20210828052006.1313788-1-davemarchevsky@fb.com>
 <20210828052006.1313788-4-davemarchevsky@fb.com>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <20210828052006.1313788-4-davemarchevsky@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0089.namprd03.prod.outlook.com
 (2603:10b6:208:329::34) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPV6:2620:10d:c0a8:11e8::1060] (2620:10d:c091:480::1:1853) by BLAPR03CA0089.namprd03.prod.outlook.com (2603:10b6:208:329::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 16:45:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 336917d7-b069-40fc-7d0e-08d96a432e4d
X-MS-TrafficTypeDiagnostic: DM6PR15MB2972:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB29721704D810540399180742A0C99@DM6PR15MB2972.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCYTO1o1K2XONp7UCitCcqG/zRUDJnmpHI57iVZoag2Kb+uJm6s/UZVXWOZVNAou3hoFomiGON6ZLernRa4SHP2NVjuWTKy9p5E8EPVm2v7mGz+JVigZL/JQ6I4+F95NiwQ9WPe4cNy70EMx2+DqElC6dXRI/vsN06ybUuLtBVv8kLD8o5Z/xlNR6XpaFYQYnXCBGvkOvsBE+fcPp41njZrJbKeh4dTFmcaJKuZPB2ZTjF6JNyMpeREVyO5xO/sX/v9G00cx8eAQ96flzaLLPzaa+h2zFDtuMN+NCvzRjZXTFG+89jVo0TKaVJowctAmMfhzVADkSRzLvAS1pnVH2Hf/7ELqbJxkgIDw9KfnqXY0XMakhMsL7IT9QWrgU/MqCFrPEnHfUXY28JoCupSmLvw73iGSFqeoS8zgrPM2u0hIsRNLGuPYzDwLDW2fRmJj8mfapdfqgI0bSjFQa0hXnhiBrXJkZgm1rUV/TeG8M+ihcdu5lfmQHZ+nxR+IqYVDsR2zzfrKE8NzlWvsC2ck0VPCe93lDBUHoAW8t8cw5Fa96SiegifFOcHYzt+ZwSiCY0mhuv48sQ1iYabhSis46jBp7KRHgerqATtHlrEF5vqaz1DGh3WjcElOU4ESvnHW4cyf9xcoSWFNkCt6Ctvrl35S6tmpNqUPyXIv91m1sH62QkjAtRHL1bIMamdEDFGyQmEAS+n9gGDPlnXINvdzSu0Sz8ue2IzCpq47jmT+mgo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(66476007)(52116002)(6916009)(316002)(186003)(8936002)(53546011)(2906002)(6666004)(86362001)(66556008)(5660300002)(31686004)(2616005)(6486002)(83380400001)(478600001)(36756003)(31696002)(8676002)(4326008)(38100700002)(54906003)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVlWenFBQkNvVTQxRGdSUkJnTllpWU94dk5uenIvSjN0ck91NVg3WWlpc2Y4?=
 =?utf-8?B?czdDaUhlY1cySWF5Y0s5WG5xVUl4b0dNb20xaHZkSnVLZUc2SmdqMWltazBu?=
 =?utf-8?B?VG1DdW5jT0I4VWxOazJRS2F1cXhncU53eE9CUVdPQmJEemdjZWdlVmR4bEJN?=
 =?utf-8?B?RS8vcFR2ZXgyY05iZWNsU080V05EdVYwZ3BFTU0xbXp0R1Rmbmw5WmpIOW1K?=
 =?utf-8?B?WG5oelhwNlJ6clJRR1h5bXJQV2I5aU9JSFU5TTB5eEZhSE1NQ3NKUkNpQno5?=
 =?utf-8?B?cktCNlk3aG52Yk93TmRyOEI3K0VtaUxXUjNlNzlzWFBrcEtzTW9WdlhSaEFL?=
 =?utf-8?B?WndyRUQ4L0dhMitZSUZmb0ZETkxaSXlnamJ5K3RYSVc2TmwyNlFJU2VhSFdq?=
 =?utf-8?B?MDZQL0VxTnludXUzSGtKNUFORmlxcXpZeWJkLy9vV1RkZHJiMHQ4WTFDOXkz?=
 =?utf-8?B?SkVKS1dKQlZJNGc4WG40Z3pzTTBWaFFFcmpSMmlFZUZaTTNRUjVtbkNLTXo4?=
 =?utf-8?B?Nk1zQUJaRHNSRml2YjdLM3EwRmsxVGhDdkZNVXJrUGg1eDFzUWZRajBxWjRy?=
 =?utf-8?B?cGtnN1lBVWdVdFZhNWM3ckUrN0lBb3JuS0ZzOENmUk5tYVQ1VXNabTFJTFlx?=
 =?utf-8?B?ME5RTkk2TjArVXhKdWZRTm5LU2dLYkxIdUlNOFA4aElna3dpZkxaemxrK2p2?=
 =?utf-8?B?MzY1aXNSdVJxZW10MVdqRHY2KzVvVnZmR2tDbW9Nb2hJYmNmRkE0dUFkRXls?=
 =?utf-8?B?WWIvY0JtejZ1Rnlkano5VkRJclR2d1o5T0dJYktVdjIxczJXY09KbHJxQXNs?=
 =?utf-8?B?NzF2WWliKzVMOSt1MVJWekZxcjRCbTV5QTF5VGlEU3h4Y3RXVDY0cytQUHVJ?=
 =?utf-8?B?bHY2MERUalFKSUxpbnZ2ekszaDY3dlRFQnc1RnVzZ09ISTlkQlRYUVhQZlUw?=
 =?utf-8?B?dHdqM012Z090SE1MVjI3TjZGajNaKzV1amdtS0RsVm53QW1DOHUzOThib243?=
 =?utf-8?B?T0JIaGRUUVo0Q3BzaVVrSXVqallIclRRSm9RL3IrZ2l1ZmpKL0F0LzlkeDEv?=
 =?utf-8?B?NVdtSzRTV3VEVElKTmZRUlhtSlkxR1grQ0Q3YkRmUW9wMzlqWC9qeDQ5ODEz?=
 =?utf-8?B?RUZ4Y2ZkelQzUUsvZTczZTZ5U2p4VnJBQ2sxVEdQQStYNlQ0MkNxVlNOYW1u?=
 =?utf-8?B?SldxS2hXazdKSExNTnB2am8rR1FaSnF1UTh0ajhud2xZcDJ3ZDJoeGZ3Zkt1?=
 =?utf-8?B?bFFyYitKMzJ5V2pRd0NjdG43eUd6QUI2Wmhvc1A4RXltL0E3SnRzdG13Vjg5?=
 =?utf-8?B?UUlPUDJZZkNZZnMrME9HUnZoOUFDckhza0t6UE9zTzZZbmFZS2p4L2ttRFkv?=
 =?utf-8?B?c2xuOC9JNy80TlFuaGV1UWw5Q3lwV0pBbXZTL3Y3dTI5U3N4Z2NCd2krZVJ2?=
 =?utf-8?B?R0hPejRFVFpOVFR6NWR1ZURiT2xBa3IrN0FKZDdKYmJoZjluWDlSVG44MFVY?=
 =?utf-8?B?WEplOHZtQzc3bzVKNkR3ZGsrZGFLRFlaVEFuVzBUMEFXN1lrMHFsMWdBSUdT?=
 =?utf-8?B?dnlNUFVMRk53d1JadG5EbmpyRWp3Y1IzR0pjaktvK0ZrWXVxYnRLTjBvQXFR?=
 =?utf-8?B?cEtaTEJHOExzZE5LektoVXQ2VjBGalFRR2E3MSt3MGplaXBkbmgrY2ltaWdY?=
 =?utf-8?B?Q1VXclVnOU5UTnJTaFZ4MXdlL1E3MHJNQkZIR1JrdktCUFhiS3UrTlkwTHVQ?=
 =?utf-8?B?YlYrUHNocUhwL2g0NHdnamZKSzlKT2tDalZNWTNQSkhaVVhFaDVUMlZwb3R4?=
 =?utf-8?Q?lKzaF6FDYavpNjdh3KRyqMX8P9THSFrpHnZAc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 336917d7-b069-40fc-7d0e-08d96a432e4d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 16:45:02.3262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5LC6YpwPAhwb2D9eamaw9iNCyq96gkPMdw608GitlvkK/5VdiVaGz7n+QHnRe1qQzJ9R9GDCume/gtndObJlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2972
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: GzcVe0R81lv2KZbr6xa6FKK9kem8DDAd
X-Proofpoint-ORIG-GUID: GzcVe0R81lv2KZbr6xa6FKK9kem8DDAd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-28_05:2021-08-27,2021-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108280109
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/21 1:20 AM, Dave Marchevsky wrote:   
> Instead of being a thin wrapper which calls into bpf_trace_printk,
> libbpf's bpf_printk convenience macro now chooses between
> bpf_trace_printk and bpf_trace_vprintk. If the arg count (excluding
> format string) is >3, use bpf_trace_vprintk, otherwise use the older
> helper.
> 
> The motivation behind this added complexity - instead of migrating
> entirely to bpf_trace_vprintk - is to maintain good developer experience
> for users compiling against new libbpf but running on older kernels.
> Users who are passing <=3 args to bpf_printk will see no change in their
> bytecode.
> 
> __bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
> macros elsewhere in the file - it allows use of bpf_trace_vprintk
> without manual conversion of varargs to u64 array. Previous
> implementation of bpf_printk macro is moved to __bpf_printk for use by
> the new implementation.
> 
> This does change behavior of bpf_printk calls with >3 args in the "new
> libbpf, old kernels" scenario. Before this patch, attempting to use 4
> args to bpf_printk results in a compile-time error. After this patch,
> using bpf_printk with 4 args results in a trace_vprintk helper call
> being emitted and a load-time failure on older kernels.
> 
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 45 ++++++++++++++++++++++++++++++-------
>  1 file changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index b9987c3efa3c..5f087306cdfe 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -14,14 +14,6 @@
>  #define __type(name, val) typeof(val) *name
>  #define __array(name, val) typeof(val) *name[]
>  
> -/* Helper macro to print out debug messages */
> -#define bpf_printk(fmt, ...)				\
> -({							\
> -	char ____fmt[] = fmt;				\
> -	bpf_trace_printk(____fmt, sizeof(____fmt),	\
> -			 ##__VA_ARGS__);		\
> -})
> -
>  /*
>   * Helper macro to place programs, maps, license in
>   * different sections in elf_bpf file. Section names
> @@ -224,4 +216,41 @@ enum libbpf_tristate {
>  		     ___param, sizeof(___param));		\
>  })
>  
> +/* Helper macro to print out debug messages */
> +#define __bpf_printk(fmt, ...)				\
> +({							\
> +	char ____fmt[] = fmt;				\
> +	bpf_trace_printk(____fmt, sizeof(____fmt),	\
> +			 ##__VA_ARGS__);		\
> +})
> +
> +/*
> + * __bpf_vprintk wraps the bpf_trace_vprintk helper with variadic arguments
> + * instead of an array of u64.
> + */
> +#define __bpf_vprintk(fmt, args...)				\
> +({								\
> +	static const char ___fmt[] = fmt;			\
> +	unsigned long long ___param[___bpf_narg(args)];		\
> +								\
> +	_Pragma("GCC diagnostic push")				\
> +	_Pragma("GCC diagnostic ignored \"-Wint-conversion\"")	\
> +	___bpf_fill(___param, args);				\
> +	_Pragma("GCC diagnostic pop")				\
> +								\
> +	bpf_trace_vprintk(___fmt, sizeof(___fmt),		\
> +		     ___param, sizeof(___param));		\
> +})
> +
> +#define ___bpf_pick_printk(...) \
> +	___bpf_nth(_, ##__VA_ARGS__, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,	\
> +		__bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,		\
> +		__bpf_vprintk, __bpf_vprintk, __bpf_printk, __bpf_printk,		\
> +		__bpf_printk, __bpf_printk)
> +
> +#define bpf_printk(fmt, args...)		\
> +({						\
> +	___bpf_pick_printk(args)(fmt, args);	\

While looking at test failure related to patch 4, noticed
that this isn't handling 0 format arg case correctly, resulting
in compilation error.

Need to fix and add a test as all extant selftests are doing
bpf_printk with at least 1 format arg.

> +})
> +
>  #endif
> 

