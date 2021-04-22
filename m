Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508FF36888E
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbhDVV2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:28:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40604 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237012AbhDVV2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 17:28:01 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13MLPdBH025669;
        Thu, 22 Apr 2021 14:27:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=L4bWvIg+T7xP5vVhbGKyOp7gHV5QXIJKtVMsBs+q4F0=;
 b=cqtNwuta4gsQzi7OqXymuC8+4c9EBO1IZoIwzqoT2F5KpmSkvWAf2Nv+0K6FiLz52NkB
 aFWRIwW+5lDYgmpuDcH40u/bd/f6zn1f1rGMeVHqeVTPbtJVQsMyQsQ0GmzOtmWXcr8c
 BfV11g7dRGlyKNKix39q9mcAa7c9M0K2+QI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 383h1ug08b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 14:27:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 14:27:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiFBNA9rOm5Tigh45giSbp6jmlujYDafm7i5x+siuBu3pY4P6G5GTcnBSsSDJLfue+Rt6AaLhUz7TLqwmVFrMWQ+U0N2Pi4gm9/lcCOW0q3orWa9aAkMQVmLepLwaLTvdKRCNnK83m3subCuWuwxjx+o599ccP+dKoCVt6zaC2B/rdy/I/kq/QnirXdvmpNl2Y9zVsV8xSNSSM+v607K/W8MFtyEA7CgB+8L3RJLSvcDvrnPuH7YgDqCGGlXGTDOgaFVdXksQNr02oZv7XrFc2v2H/LaWuZMudEdtkrwDFWsbnTam9bFbCgdbhD8L8VKotda/lp6DQnKP5kWDQ4iLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4bWvIg+T7xP5vVhbGKyOp7gHV5QXIJKtVMsBs+q4F0=;
 b=D3nBF+TunpDTrKnw1KYLCx1e4WsyIAxTaAU0xJjOnas7vOwtbISNevLMJnG5AyCbSunXJjDZKutG9iB8zAHxH4zWxj1Tk3ft6uvcWmYQDUI2UMs2K+YcdRimOHxJm/DIoATRWpmdQZzcjBkF05C+3Ts/vAuH51/QjIoNNrFSDF0NUq3+xBiDwreyGNlR3ZnsClgisS+GkBqiJkIZH1KtRj5py9kp0bzn+TfezSZyCCGRQqN8LOLmLZlxqSKLKby0dGYRYmQOgNyeg2nQHXlr15kMZnnxJbZSRlneiZJ1xEu08Ib+QlJvrM1f7yXF3TEFwEdgtih33xxaJcQ3uW3gFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3968.namprd15.prod.outlook.com (2603:10b6:806:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Thu, 22 Apr
 2021 21:27:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 21:27:06 +0000
Subject: Re: [PATCH v2 bpf-next 11/17] libbpf: add linker extern resolution
 support for functions and global variables
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-12-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d6297a28-855f-4c46-7754-b0c0b1f11d6b@fb.com>
Date:   Thu, 22 Apr 2021 14:27:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-12-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:427c]
X-ClientProxiedBy: MW4PR04CA0231.namprd04.prod.outlook.com
 (2603:10b6:303:87::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:427c) by MW4PR04CA0231.namprd04.prod.outlook.com (2603:10b6:303:87::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 21:27:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e69945b-49c9-4cf7-b507-08d905d560ce
X-MS-TrafficTypeDiagnostic: SA0PR15MB3968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB3968710BFEA382A9588FB5E7D3469@SA0PR15MB3968.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WpERvezXKUMiVbyccX//wqU+thJR+k0gkC4xa884Gr8JDMSN9JL7gwZ7XWP1LVcDIM+OOoU5exQmdJQ8FvkXJ0b+QNLSvT1Rw3zgCaZd0ddHE3AFOu8XIou7O0/ACwXv321YAMfG+jTt1QfHgm29kcFd5owgeG1Q/77c8KAB6hlvCdtwFq17/VwLdcDeIHR9x6rqtsiN3XrFad4tk10mtFBuVsipn0XyD6G9Ai0EMntyy+lOkzH1Ux7godrRnXtHrotoBBE7Auxz3YjeSxPc3A8AyCxIgH/IERN/BxicoC2iZtBLXVZZ4RkmE7oNZHfs3mX/6+U7ttwgtslG4QX++hBsCa81XDeC52NlPyaoVL2tw/sym/clpNVOjiRIxNdeJhujbd51lhMOE7FKGwM0v/qEzYcDD1GIG4UnD9cpShqA/pmjdab5BeE2KGlvz1gepgC9zNAJ9jZrNBFEBHkapcQiiDMX8EUswbFEp1vIt/0hrmhGuA2s0dfh3R0esngduyOf4aYFmsMLWTE/55nJB/goquyk+IZcc3SxsUOBkDLTDPlGJ7Nn/WmBNzd3Co01l19FRde4YcXS1KzJVsLlrvf8TjeBezgdYaFDKM7dTHaWiSt3xhb1ONtXDPiLUkktbeVDviIc09KKVHn8JR8ZsFJ6OVQNJezsRqC45zm8caKc9Ma/Duw8hvC7eTG8ZVhv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(38100700002)(36756003)(316002)(8676002)(2616005)(66556008)(66476007)(66946007)(8936002)(186003)(53546011)(16526019)(52116002)(2906002)(4326008)(83380400001)(478600001)(6486002)(86362001)(6666004)(30864003)(31686004)(31696002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WEdMQkVUcVF1cmwycEc1eDJpMEhZWWRPV0tWZlZhb0luT0lUaGpyMGIvTUhM?=
 =?utf-8?B?NURWYzFHS252OWxLanNiR1NHakJKd2dRZnNBU01wYXlBbm1xVmRYQ2VmTldX?=
 =?utf-8?B?WTU4bWdlV1VRRlpZbVJMeWFvV2N0QzZZRXZrRGlndFZaQlY2Sjd2SDJKNGts?=
 =?utf-8?B?OVBITk1nNFdwdTVDZ24rUnFYMGxld2c3UEJFN1VmZEJlU2Mzb1VNREpjdHlZ?=
 =?utf-8?B?NlJLalNMbkN1ZHJaTVczSUNLYnhmOU9hYS9nNkRrVnQ3RGJjVDBIWXBiOXEw?=
 =?utf-8?B?bzdzdnhkM3I3cll4cmNFUmlySTJIeG55Y3lJSGdUTTVVZElKaUhjTlBQQmNJ?=
 =?utf-8?B?OUZnT0trNTVTbVNWUHBwWDRZODJKaHFkMEoxdFM3OVFVZk1tV09XOTA2Yitx?=
 =?utf-8?B?NmxTTXBKR0lkK0xuOFBTUXYzWmFXa3ZiOXpZTjNUNjNhRWQvMDcrU3UwRDFn?=
 =?utf-8?B?ak9tbnU2b0RnL1dBam5EMFRXeEwvZmJNdEkyYUNocGVLRU5wQ1hGalB6Q01z?=
 =?utf-8?B?U3pBVml3dmhMU051L0lmMEd5cFg1enE5am5kMzFBZXBuZHdTYW1uUXV4NkI0?=
 =?utf-8?B?UjFWYnFkeE5sYytkVFlUQmRFd3FtZWtCRnhodXIvYmFqdlE3MTZ2ekdvOVc1?=
 =?utf-8?B?THpkd1pOU0xHQ3oyb3FrVmhJNk00VWVoQ3FuSTNTMlZtWGtUekpqSW9NRWlj?=
 =?utf-8?B?RGFWd2wxL0RMc2ZRb3pZZ3M4Z09JNWVPcnJoa0RwZS9yZXlPY0ZEM0xSdzZK?=
 =?utf-8?B?MjBDVXc4VFNaYmo0bVNWcHdKWnR6ZEk5L2ZqZkUxcEd2UDEwNFhsSGZmNjll?=
 =?utf-8?B?MVozeGF3N05pWXdDSHhDcGk2NG0zdnM4cXVHM1RiNXVVL2p0cFo5WVlVeCtF?=
 =?utf-8?B?SFg5eDhnQ0tCWE84SGJrM1lVKzlxTkdScHp3dW0ydmwxeHl5TGNtcThjOFFr?=
 =?utf-8?B?K1Q2V0hIcmxjcVc0MjJBaWRoMDVkNG5ZdHVYajlLbEl0dDFpREhIL01JdkFL?=
 =?utf-8?B?TjdpTnJpWEp3NkdJN2hIL0hyWlRzVUVrdFhEZTlSZS9hSGNLUWlhZFR2SHNw?=
 =?utf-8?B?ZHVTZFR0SXJwMXRCUSthQjdYV1RYSHFtMkpvMmljQUJxRUlWQStKcXc1RlZK?=
 =?utf-8?B?Wnl2Z3dZMGlteUdiRFBPWWtqa2ZIdWdmdVBCVFZmSE13TlBFMWhoeHdCeHVC?=
 =?utf-8?B?ZnkyNG5sUFVoc3MrTEF3a3hMdXJGNUU3T1dVOTFrZlVPcksveHQwWVRzbmdT?=
 =?utf-8?B?V2RGVFU2cUlUSVVWYmhKUVFoa1FKWk0waWRxdWRiQ3ZKNkkxS2E5YmxoMnBQ?=
 =?utf-8?B?R3k5dTU1UTZ2RlBWYnM4QldYL20wN1RJbDdxZHI4ZHplZktBd2wyZW9ZelAw?=
 =?utf-8?B?Mm4rRFczWHhEK1AyOEYwVDdDVkFJdGdIc001ZVR3QklrUm5oZFhRMEZURDF5?=
 =?utf-8?B?bm5PR2NPV3Rrd3d6cDQrYzZraWRnZlpwU0RPTGlVSHF1WmRlSWdmaXgvRDht?=
 =?utf-8?B?WHpSNmxxd2p3T0hKM0JnQURDU0x4QW9POUF5WCt4bEs1MzRGMThDZTQraFFG?=
 =?utf-8?B?akowemFEbmtzYUV4U1pUS0tnWi9IZmlKMzVDZHYvNnExc3QxckJvM1FUQ3hB?=
 =?utf-8?B?TGZnUXQvOGxKZklLS255S0k1c1ZVaUFSZXpxNUU2a0plbmtDazVyaEhhQ08r?=
 =?utf-8?B?a0xXa0tvMnp6M3VudlNzZTR4NENmcGRGL3lhSzJlcG1OVWs2c3AzZVBLWklh?=
 =?utf-8?B?Sk5pbHViYWxJS1QzUjh1MmU5RzN0SEZhYVg0TnJwN1Y4aUN0em82K1lzaU02?=
 =?utf-8?Q?jYARw6xRxwev/7ULRFPqxCv8s5/aKjo0oNYbY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e69945b-49c9-4cf7-b507-08d905d560ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 21:27:06.1947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ncRJC10NZqeaA6Rvk4Lk99rflsr2fnftz+j92CGlY2PVP+L+yM9NTyHWSMmnddYg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3968
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: kIwsR0XC1dxBvXYlVlK8FEWL2Zj19cQi
X-Proofpoint-ORIG-GUID: kIwsR0XC1dxBvXYlVlK8FEWL2Zj19cQi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_14:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220158
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Add BPF static linker logic to resolve extern variables and functions across
> multiple linked together BPF object files.
> 
> For that, linker maintains a separate list of struct glob_sym structures,
> which keeps track of few pieces of metadata (is it extern or resolved global,
> is it a weak symbol, which ELF section it belongs to, etc) and ties together
> BTF type info and ELF symbol information and keeps them in sync.
> 
> With adding support for extern variables/funcs, it's now possible for some
> sections to contain both extern and non-extern definitions. This means that
> some sections may start out as ephemeral (if only externs are present and thus
> there is not corresponding ELF section), but will be "upgraded" to actual ELF
> section as symbols are resolved or new non-extern definitions are appended.
> 
> Additional care is taken to not duplicate extern entries in sections like
> .kconfig and .ksyms.
> 
> Given libbpf requires BTF type to always be present for .kconfig/.ksym
> externs, linker extends this requirement to all the externs, even those that
> are supposed to be resolved during static linking and which won't be visible
> to libbpf. With BTF information always present, static linker will check not
> just ELF symbol matches, but entire BTF type signature match as well. That
> logic is stricter that BPF CO-RE checks. It probably should be re-used by
> .ksym resolution logic in libbpf as well, but that's left for follow up
> patches.
> 
> To make it unnecessary to rewrite ELF symbols and minimize BTF type
> rewriting/removal, ELF symbols that correspond to externs initially will be
> updated in place once they are resolved. Similarly for BTF type info, VAR/FUNC
> and var_secinfo's (sec_vars in struct bpf_linker) are staying stable, but
> types they point to might get replaced when extern is resolved. This might
> leave some left-over types (even though we try to minimize this for common
> cases of having extern funcs with not argument names vs concrete function with
> names properly specified). That can be addresses later with a generic BTF
> garbage collection. That's left for a follow up as well.
> 
> Given BTF type appending phase is separate from ELF symbol
> appending/resolution, special struct glob_sym->underlying_btf_id variable is
> used to communicate resolution and rewrite decisions. 0 means
> underlying_btf_id needs to be appended (it's not yet in final linker->btf), <0
> values are used for temporary storage of source BTF type ID (not yet
> rewritten), so -glob_sym->underlying_btf_id is BTF type id in obj-btf. But by
> the end of linker_append_btf() phase, that underlying_btf_id will be remapped
> and will always be > 0. This is the uglies part of the whole process, but
> keeps the other parts much simpler due to stability of sec_var and VAR/FUNC
> types, as well as ELF symbol, so please keep that in mind while reviewing.

This is indeed complicated. I has some comments below. Please check 
whether my understanding is correct or not.

> 
> BTF-defined maps require some extra custom logic and is addressed separate in
> the next patch, so that to keep this one smaller and easier to review.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/lib/bpf/linker.c | 844 ++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 785 insertions(+), 59 deletions(-)
> 
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index d5dc1d401f57..67d2d06e3cb6 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -22,6 +22,8 @@
>   #include "libbpf_internal.h"
>   #include "strset.h"
>   
> +#define BTF_EXTERN_SEC ".extern"
> +
>   struct src_sec {
>   	const char *sec_name;
>   	/* positional (not necessarily ELF) index in an array of sections */
> @@ -74,11 +76,36 @@ struct btf_ext_sec_data {
>   	void *recs;
>   };
>   
> +struct glob_sym {
> +	/* ELF symbol index */
> +	int sym_idx;
> +	/* associated section id for .ksyms, .kconfig, etc, but not .extern */
> +	int sec_id;
> +	/* extern name offset in STRTAB */
> +	int name_off;
> +	/* optional associated BTF type ID */
> +	int btf_id;
> +	/* BTF type ID to which VAR/FUNC type is pointing to; used for
> +	 * rewriting types when extern VAR/FUNC is resolved to a concrete
> +	 * definition
> +	 */
> +	int underlying_btf_id;
> +	/* sec_var index in the corresponding dst_sec, if exists */
> +	int var_idx;
> +
> +	/* extern or resolved/global symbol */
> +	bool is_extern;
> +	/* weak or strong symbol, never goes back from strong to weak */
> +	bool is_weak;
> +};
> +
>   struct dst_sec {
>   	char *sec_name;
>   	/* positional (not necessarily ELF) index in an array of sections */
>   	int id;
>   
> +	bool ephemeral;
> +
>   	/* ELF info */
>   	size_t sec_idx;
>   	Elf_Scn *scn;
> @@ -120,6 +147,10 @@ struct bpf_linker {
>   
>   	struct btf *btf;
>   	struct btf_ext *btf_ext;
> +
> +	/* global (including extern) ELF symbols */
> +	int glob_sym_cnt;
> +	struct glob_sym *glob_syms;
>   };
>   
[...]
> +
> +static bool glob_sym_btf_matches(const char *sym_name, bool exact,
> +				 const struct btf *btf1, __u32 id1,
> +				 const struct btf *btf2, __u32 id2)
> +{
> +	const struct btf_type *t1, *t2;
> +	bool is_static1, is_static2;
> +	const char *n1, *n2;
> +	int i, n;
> +
> +recur:
> +	n1 = n2 = NULL;
> +	t1 = skip_mods_and_typedefs(btf1, id1, &id1);
> +	t2 = skip_mods_and_typedefs(btf2, id2, &id2);
> +
> +	/* check if only one side is FWD, otherwise handle with common logic */
> +	if (!exact && btf_is_fwd(t1) != btf_is_fwd(t2)) {
> +		n1 = btf__str_by_offset(btf1, t1->name_off);
> +		n2 = btf__str_by_offset(btf2, t2->name_off);
> +		if (strcmp(n1, n2) != 0) {
> +			pr_warn("global '%s': incompatible forward declaration names '%s' and '%s'\n",
> +				sym_name, n1, n2);
> +			return false;
> +		}
> +		/* validate if FWD kind matches concrete kind */
> +		if (btf_is_fwd(t1)) {
> +			if (btf_kflag(t1) && btf_is_union(t2))
> +				return true;
> +			if (!btf_kflag(t1) && btf_is_struct(t2))
> +				return true;
> +			pr_warn("global '%s': incompatible %s forward declaration and concrete kind %s\n",
> +				sym_name, btf_kflag(t1) ? "union" : "struct", btf_kind_str(t2));
> +		} else {
> +			if (btf_kflag(t2) && btf_is_union(t1))
> +				return true;
> +			if (!btf_kflag(t2) && btf_is_struct(t1))
> +				return true;
> +			pr_warn("global '%s': incompatible %s forward declaration and concrete kind %s\n",
> +				sym_name, btf_kflag(t2) ? "union" : "struct", btf_kind_str(t1));
> +		}
> +		return false;
> +	}
> +
> +	if (btf_kind(t1) != btf_kind(t2)) {
> +		pr_warn("global '%s': incompatible BTF kinds %s and %s\n",
> +			sym_name, btf_kind_str(t1), btf_kind_str(t2));
> +		return false;
> +	}
> +
> +	switch (btf_kind(t1)) {
> +	case BTF_KIND_STRUCT:
> +	case BTF_KIND_UNION:
> +	case BTF_KIND_ENUM:
> +	case BTF_KIND_FWD:
> +	case BTF_KIND_FUNC:
> +	case BTF_KIND_VAR:
> +		n1 = btf__str_by_offset(btf1, t1->name_off);
> +		n2 = btf__str_by_offset(btf2, t2->name_off);
> +		if (strcmp(n1, n2) != 0) {
> +			pr_warn("global '%s': incompatible %s names '%s' and '%s'\n",
> +				sym_name, btf_kind_str(t1), n1, n2);
> +			return false;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	switch (btf_kind(t1)) {
> +	case BTF_KIND_UNKN: /* void */
> +	case BTF_KIND_FWD:
> +		return true;
> +	case BTF_KIND_INT:
> +	case BTF_KIND_FLOAT:
> +	case BTF_KIND_ENUM:
> +		/* ignore encoding for int and enum values for enum */
> +		if (t1->size != t2->size) {
> +			pr_warn("global '%s': incompatible %s '%s' size %u and %u\n",
> +				sym_name, btf_kind_str(t1), n1, t1->size, t2->size);
> +			return false;
> +		}
> +		return true;
> +	case BTF_KIND_PTR:
> +		/* just validate overall shape of the referenced type, so no
> +		 * contents comparison for struct/union, and allowd fwd vs
> +		 * struct/union
> +		 */
> +		exact = false;
> +		id1 = t1->type;
> +		id2 = t2->type;
> +		goto recur;
> +	case BTF_KIND_ARRAY:
> +		/* ignore index type and array size */
> +		id1 = btf_array(t1)->type;
> +		id2 = btf_array(t2)->type;
> +		goto recur;
> +	case BTF_KIND_FUNC:
> +		/* extern and global linkages are compatible */
> +		is_static1 = btf_func_linkage(t1) == BTF_FUNC_STATIC;
> +		is_static2 = btf_func_linkage(t2) == BTF_FUNC_STATIC;
> +		if (is_static1 != is_static2) {
> +			pr_warn("global '%s': incompatible func '%s' linkage\n", sym_name, n1);
> +			return false;
> +		}
> +
> +		id1 = t1->type;
> +		id2 = t2->type;
> +		goto recur;
> +	case BTF_KIND_VAR:
> +		/* extern and global linkages are compatible */
> +		is_static1 = btf_var(t1)->linkage == BTF_VAR_STATIC;
> +		is_static2 = btf_var(t2)->linkage == BTF_VAR_STATIC;
> +		if (is_static1 != is_static2) {
> +			pr_warn("global '%s': incompatible var '%s' linkage\n", sym_name, n1);
> +			return false;
> +		}
> +
> +		id1 = t1->type;
> +		id2 = t2->type;
> +		goto recur;
> +	case BTF_KIND_STRUCT:
> +	case BTF_KIND_UNION: {
> +		const struct btf_member *m1, *m2;
> +
> +		if (!exact)
> +			return true;
> +
> +		if (btf_vlen(t1) != btf_vlen(t2)) {
> +			pr_warn("global '%s': incompatible number of %s fields %u and %u\n",
> +				sym_name, btf_kind_str(t1), btf_vlen(t1), btf_vlen(t2));
> +			return false;
> +		}
> +
> +		n = btf_vlen(t1);
> +		m1 = btf_members(t1);
> +		m2 = btf_members(t2);
> +		for (i = 0; i < n; i++, m1++, m2++) {
> +			n1 = btf__str_by_offset(btf1, m1->name_off);
> +			n2 = btf__str_by_offset(btf2, m2->name_off);
> +			if (strcmp(n1, n2) != 0) {
> +				pr_warn("global '%s': incompatible field #%d names '%s' and '%s'\n",
> +					sym_name, i, n1, n2);
> +				return false;
> +			}
> +			if (m1->offset != m2->offset) {
> +				pr_warn("global '%s': incompatible field #%d ('%s') offsets\n",
> +					sym_name, i, n1);
> +				return false;
> +			}
> +			if (!glob_sym_btf_matches(sym_name, exact, btf1, m1->type, btf2, m2->type))
> +				return false;
> +		}
> +
> +		return true;
> +	}
> +	case BTF_KIND_FUNC_PROTO: {
> +		const struct btf_param *m1, *m2;
> +
> +		if (btf_vlen(t1) != btf_vlen(t2)) {
> +			pr_warn("global '%s': incompatible number of %s params %u and %u\n",
> +				sym_name, btf_kind_str(t1), btf_vlen(t1), btf_vlen(t2));
> +			return false;
> +		}
> +
> +		n = btf_vlen(t1);
> +		m1 = btf_params(t1);
> +		m2 = btf_params(t2);
> +		for (i = 0; i < n; i++, m1++, m2++) {
> +			/* ignore func arg names */
> +			if (!glob_sym_btf_matches(sym_name, exact, btf1, m1->type, btf2, m2->type))
> +				return false;
> +		}
> +
> +		/* now check return type as well */
> +		id1 = t1->type;
> +		id2 = t2->type;
> +		goto recur;
> +	}
> +
> +	case BTF_KIND_TYPEDEF:
> +	case BTF_KIND_VOLATILE:
> +	case BTF_KIND_CONST:
> +	case BTF_KIND_RESTRICT:

We already did skip_mods_and_typedefs() before. Unless something serious 
wrong, we should not hit the above four types. So I think we can skip 
them here.

> +	case BTF_KIND_DATASEC:
> +	default:
> +		pr_warn("global '%s': unsupported BTF kind %s\n",
> +			sym_name, btf_kind_str(t1));
> +		return false;
> +	}
> +}
> +
> +static bool glob_syms_match(const char *sym_name,
> +			    struct bpf_linker *linker, struct glob_sym *glob_sym,
> +			    struct src_obj *obj, Elf64_Sym *sym, size_t sym_idx, int btf_id)
> +{
> +	const struct btf_type *src_t;
> +
> +	/* if we are dealing with externs, BTF types describing both global
> +	 * and extern VARs/FUNCs should be completely present in all files
> +	 */
> +	if (!glob_sym->btf_id || !btf_id) {
> +		pr_warn("BTF info is missing for global symbol '%s'\n", sym_name);
> +		return false;
> +	}
> +
> +	src_t = btf__type_by_id(obj->btf, btf_id);
> +	if (!btf_is_var(src_t) && !btf_is_func(src_t)) {
> +		pr_warn("only extern variables and functions are supported, but got '%s' for '%s'\n",
> +			btf_kind_str(src_t), sym_name);
> +		return false;
> +	}
> +
> +	if (!glob_sym_btf_matches(sym_name, true /*exact*/,
> +				  linker->btf, glob_sym->btf_id, obj->btf, btf_id))
> +		return false;
> +
> +	return true;
> +}
> +
[...]
> +
> +static void sym_update_visibility(Elf64_Sym *sym, int sym_vis)
> +{
> +	/* libelf doesn't provide setters for ST_VISIBILITY,
> +	 * but it is stored in the lower 2 bits of st_other
> +	 */
> +	sym->st_other &= 0x03;
> +	sym->st_other |= sym_vis;
> +}
> +
> +static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
> +				 Elf64_Sym *sym, const char *sym_name, int src_sym_idx)
> +{
> +	struct src_sec *src_sec = NULL;
> +	struct dst_sec *dst_sec = NULL;
> +	struct glob_sym *glob_sym = NULL;
> +	int name_off, sym_type, sym_bind, sym_vis, err;
> +	int btf_sec_id = 0, btf_id = 0;
> +	size_t dst_sym_idx;
> +	Elf64_Sym *dst_sym;
> +	bool sym_is_extern;
> +
> +	sym_type = ELF64_ST_TYPE(sym->st_info);
> +	sym_bind = ELF64_ST_BIND(sym->st_info);
> +	sym_vis = ELF64_ST_VISIBILITY(sym->st_other);
> +	sym_is_extern = sym->st_shndx == SHN_UNDEF;
> +
> +	if (sym_is_extern) {
> +		if (!obj->btf) {
> +			pr_warn("externs without BTF info are not supported\n");
> +			return -ENOTSUP;
> +		}
> +	} else if (sym->st_shndx < SHN_LORESERVE) {

So what happens if sym->st_shndx >= SHN_LORESERVE. Maybe return failures 
here? In general, bpf program shouldn't hit sym->st_shndx >= SHN_LORESERVE.

> +		src_sec = &obj->secs[sym->st_shndx];
> +		if (src_sec->skipped)
> +			return 0;
> +		dst_sec = &linker->secs[src_sec->dst_id];
> +
> +		/* allow only one STT_SECTION symbol per section */
> +		if (sym_type == STT_SECTION && dst_sec->sec_sym_idx) {
> +			obj->sym_map[src_sym_idx] = dst_sec->sec_sym_idx;
> +			return 0;
> +		}
> +	}
> +
> +	if (sym_bind == STB_LOCAL)
> +		goto add_sym;
> +
> +	/* find matching BTF info */
> +	err = find_glob_sym_btf(obj, sym, sym_name, &btf_sec_id, &btf_id);
> +	if (err)
> +		return err;
> +
> +	if (sym_is_extern && btf_sec_id) {
> +		const char *sec_name = NULL;
> +		const struct btf_type *t;
> +
> +		t = btf__type_by_id(obj->btf, btf_sec_id);
> +		sec_name = btf__str_by_offset(obj->btf, t->name_off);
> +
> +		/* Clang puts unannotated extern vars into
> +		 * '.extern' BTF DATASEC. Treat them the same
> +		 * as unannotated extern funcs (which are
> +		 * currently not put into any DATASECs).
> +		 * Those don't have associated src_sec/dst_sec.
> +		 */
> +		if (strcmp(sec_name, BTF_EXTERN_SEC) != 0) {
> +			src_sec = find_src_sec_by_name(obj, sec_name);
> +			if (!src_sec) {
> +				pr_warn("failed to find matching ELF sec '%s'\n", sec_name);
> +				return -ENOENT;
> +			}
> +			dst_sec = &linker->secs[src_sec->dst_id];
> +		}
> +	}
> +
> +	glob_sym = find_glob_sym(linker, sym_name);
> +	if (glob_sym) {
> +		/* Preventively resolve to existing symbol. This is
> +		 * needed for further relocation symbol remapping in
> +		 * the next step of linking.
> +		 */
> +		obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
> +
> +		/* If both symbols are non-externs, at least one of
> +		 * them has to be STB_WEAK, otherwise they are in
> +		 * a conflict with each other.
> +		 */
> +		if (!sym_is_extern && !glob_sym->is_extern
> +		    && !glob_sym->is_weak && sym_bind != STB_WEAK) {
> +			pr_warn("conflicting non-weak symbol #%d (%s) definition in '%s'\n",
> +				src_sym_idx, sym_name, obj->filename);
> +			return -EINVAL;
>   		}
>   
> +		if (!glob_syms_match(sym_name, linker, glob_sym, obj, sym, src_sym_idx, btf_id))
> +			return -EINVAL;
> +
> +		dst_sym = get_sym_by_idx(linker, glob_sym->sym_idx);
> +
> +		/* If new symbol is strong, then force dst_sym to be strong as
> +		 * well; this way a mix of weak and non-weak extern
> +		 * definitions will end up being strong.
> +		 */
> +		if (sym_bind == STB_GLOBAL) {
> +			/* We still need to preserve type (NOTYPE or
> +			 * OBJECT/FUNC, depending on whether the symbol is
> +			 * extern or not)
> +			 */
> +			sym_update_bind(dst_sym, STB_GLOBAL);
> +			glob_sym->is_weak = false;
> +		}
> +
> +		/* Non-default visibility is "contaminating", with stricter
> +		 * visibility overwriting more permissive ones, even if more
> +		 * permissive visibility comes from just an extern definition
> +		 */
> +		if (sym_vis > ELF64_ST_VISIBILITY(dst_sym->st_other))
> +			sym_update_visibility(dst_sym, sym_vis);

For visibility, maybe we can just handle DEFAULT and HIDDEN, and others
are not supported? DEFAULT + DEFAULT/HIDDEN => DEFAULT, HIDDEN + HIDDEN 
=> HIDDEN?

> +
> +		/* If the new symbol is extern, then regardless if
> +		 * existing symbol is extern or resolved global, just
> +		 * keep the existing one untouched.
> +		 */
> +		if (sym_is_extern)
> +			return 0;
> +
> +		/* If existing symbol is a strong resolved symbol, bail out,
> +		 * because we lost resolution battle have nothing to
> +		 * contribute. We already checked abover that there is no
> +		 * strong-strong conflict. We also already tightened binding
> +		 * and visibility, so nothing else to contribute at that point.
> +		 */
> +		if (!glob_sym->is_extern && sym_bind == STB_WEAK)
> +			return 0;
> +
> +		/* At this point, new symbol is strong non-extern,
> +		 * so overwrite glob_sym with new symbol information.
> +		 * Preserve binding and visibility.
> +		 */
> +		sym_update_type(dst_sym, sym_type);
> +		dst_sym->st_shndx = dst_sec->sec_idx;
> +		dst_sym->st_value = src_sec->dst_off + sym->st_value;
> +		dst_sym->st_size = sym->st_size;
> +
> +		/* see comment below about dst_sec->id vs dst_sec->sec_idx */
> +		glob_sym->sec_id = dst_sec->id;
> +		glob_sym->is_extern = false;
> +		/* never relax strong to weak binding */
> +		if (sym_bind == STB_GLOBAL)
> +			glob_sym->is_weak = false;

In the above, we already set glob_sym->is_weak to false if STB_GLOBAL.

> +
> +		if (complete_extern_btf_info(linker->btf, glob_sym->btf_id,
> +					     obj->btf, btf_id))
> +			return -EINVAL;
> +
> +		/* request updating VAR's/FUNC's underlying BTF type when appending BTF type */
> +		glob_sym->underlying_btf_id = 0;
> +
> +		obj->sym_map[src_sym_idx] = glob_sym->sym_idx;
> +		return 0;
> +	}
> +
> +add_sym:
> +	name_off = strset__add_str(linker->strtab_strs, sym_name);
> +	if (name_off < 0)
> +		return name_off;
> +
> +	dst_sym = add_new_sym(linker, &dst_sym_idx);
> +	if (!dst_sym)
> +		return -ENOMEM;
> +
> +	dst_sym->st_name = name_off;
> +	dst_sym->st_info = sym->st_info;
> +	dst_sym->st_other = sym->st_other;
> +	dst_sym->st_shndx = dst_sec ? dst_sec->sec_idx : sym->st_shndx;
> +	dst_sym->st_value = (src_sec ? src_sec->dst_off : 0) + sym->st_value;
> +	dst_sym->st_size = sym->st_size;
> +
> +	obj->sym_map[src_sym_idx] = dst_sym_idx;
> +
> +	if (sym_type == STT_SECTION && dst_sym) {
> +		dst_sec->sec_sym_idx = dst_sym_idx;
> +		dst_sym->st_value = 0;
> +	}
> +
> +	if (sym_bind != STB_LOCAL) {
> +		glob_sym = add_glob_sym(linker);
> +		if (!glob_sym)
> +			return -ENOMEM;
> +
> +		glob_sym->sym_idx = dst_sym_idx;
> +		/* we use dst_sec->id (and not dst_sec->sec_idx), because
> +		 * ephemeral sections (.kconfig, .ksyms, etc) don't have
> +		 * sec_idx (as they don't have corresponding ELF section), but
> +		 * still have id. .extern doesn't have even ephemeral section
> +		 * associated with it, so dst_sec->id == dst_sec->sec_idx == 0.
> +		 */
> +		glob_sym->sec_id = dst_sec ? dst_sec->id : 0;
> +		glob_sym->name_off = name_off;
> +		/* we will fill btf_id in during BTF merging step */
> +		glob_sym->btf_id = 0;
> +		glob_sym->is_extern = sym_is_extern;
> +		glob_sym->is_weak = sym_bind == STB_WEAK;
>   	}
>   
>   	return 0;
> @@ -1256,7 +1887,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
>   		dst_sec->shdr->sh_info = dst_linked_sec->sec_idx;
>   
>   		src_sec->dst_id = dst_sec->id;
> -		err = extend_sec(dst_sec, src_sec);
> +		err = extend_sec(linker, dst_sec, src_sec);
>   		if (err)
>   			return err;
>   
> @@ -1309,21 +1940,6 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
>   	return 0;
>   }
>   
[...]
> @@ -1442,6 +2078,7 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>   {
>   	const struct btf_type *t;
>   	int i, j, n, start_id, id;
> +	const char *name;
>   
>   	if (!obj->btf)
>   		return 0;
> @@ -1454,12 +2091,40 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>   		return -ENOMEM;
>   
>   	for (i = 1; i <= n; i++) {
> +		struct glob_sym *glob_sym = NULL;
> +
>   		t = btf__type_by_id(obj->btf, i);
>   
>   		/* DATASECs are handled specially below */
>   		if (btf_kind(t) == BTF_KIND_DATASEC)
>   			continue;
>   
> +		if (btf_is_non_static(t)) {
> +			/* there should be glob_sym already */
> +			name = btf__str_by_offset(obj->btf, t->name_off);
> +			glob_sym = find_glob_sym(linker, name);
> +
> +			/* VARs without corresponding glob_sym are those that
> +			 * belong to skipped/deduplicated sections (i.e.,
> +			 * license and version), so just skip them
> +			 */
> +			if (!glob_sym)
> +				continue;
> +
> +			if (glob_sym->underlying_btf_id == 0)
> +				glob_sym->underlying_btf_id = -t->type;

Is this needed? If glob_sym->btf_id is not NULL, then 
glob_sym->underlying_btf_id has been set by the previous object.
If it is NULL, it will set probably after this
if (btf_is_non_static(t)) { ...}, is this right?

> +
> +			/* globals from previous object files that match our
> +			 * VAR/FUNC already have a corresponding associated
> +			 * BTF type, so just make sure to use it
> +			 */
> +			if (glob_sym->btf_id) {
> +				/* reuse existing BTF type for global var/func */
> +				obj->btf_type_map[i] = glob_sym->btf_id;
> +				continue;
> +			}
> +		}
> +
>   		id = btf__add_type(linker->btf, obj->btf, t);
>   		if (id < 0) {
>   			pr_warn("failed to append BTF type #%d from file '%s'\n", i, obj->filename);
> @@ -1467,6 +2132,12 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>   		}
>   
>   		obj->btf_type_map[i] = id;
> +
> +		/* record just appended BTF type for var/func */
> +		if (glob_sym) {
> +			glob_sym->btf_id = id;
> +			glob_sym->underlying_btf_id = -t->type;
> +		}
>   	}
>   
>   	/* remap all the types except DATASECs */
> @@ -1478,6 +2149,22 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>   			return -EINVAL;
>   	}
>   
> +	/* Rewrite VAR/FUNC underlying types (i.e., FUNC's FUNC_PROTO and VAR's
> +	 * actual type), if necessary
> +	 */
> +	for (i = 0; i < linker->glob_sym_cnt; i++) {
> +		struct glob_sym *glob_sym = &linker->glob_syms[i];
> +		struct btf_type *glob_t;
> +
> +		if (glob_sym->underlying_btf_id >= 0)
> +			continue;
> +
> +		glob_sym->underlying_btf_id = obj->btf_type_map[-glob_sym->underlying_btf_id];

After this point, any new *extern* variables will hit the below in the 
previous code:
 > +			if (glob_sym->btf_id) {
 > +				/* reuse existing BTF type for global var/func */
 > +				obj->btf_type_map[i] = glob_sym->btf_id;
 > +				continue;
 > +			}

> +
> +		glob_t = btf_type_by_id(linker->btf, glob_sym->btf_id);
> +		glob_t->type = glob_sym->underlying_btf_id;
> +	}
> +
>   	/* append DATASEC info */
>   	for (i = 1; i < obj->sec_cnt; i++) {
>   		struct src_sec *src_sec;
> @@ -1505,6 +2192,42 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
[...]
