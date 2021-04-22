Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE3C3684F0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbhDVQf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:35:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37762 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232670AbhDVQf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:35:57 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13MGXFaM028617;
        Thu, 22 Apr 2021 09:35:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aKhdTEyjhLdNAIQbg73pHueAw7YpZn3D4+OFjTtl4GQ=;
 b=OMXA1Iebb/JvOSejGnaYQSVvtT1MmcY0IwozElN2Sbzpkr8wt128zK5PMRVDa0gp15YE
 V+b2Q7IPrznj9gw+z0JzfrmdNGKoB40fpzx0QUFDXJUkfC7lzP+jBbX9weaH/7Ja1lLn
 1M/xnPy55zoDSbvdEoxDCbfIBLxqnKgJ9KE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3839vuh7s3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 09:35:09 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 09:35:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKQpkdfKSoszhEfyNLYg0Cp1dLK5dZE03646yTJTyOV5ajeDurFZVMYgHswjNCuscbl64oXHK/nh7fEN6Inho+KcZXdZEPR9Z9Ln/vf9xD3dmI5o5hh/A1GZgCdBaw6hB4BX6ALjjNkUzyw5xfXf1xPFvTG89S1NaCZ9mEeoePxkmu3WloL2Na1lWzSMnMSIN0yHReeIwQjVk7L1e+ptndJb5pD59Og/tZToX5vaxGXk6GJ8QwirT9YUK3fDlk1a6pdoQL6UPT3yMPdXdPY/mKiJKftew8GFcvHJ5S4C/Qc6aJil5/GMpW3JmKBvmrHUE+g4H78YuOal4L2RHNsqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKhdTEyjhLdNAIQbg73pHueAw7YpZn3D4+OFjTtl4GQ=;
 b=kLVsZlCz1gWvueF9NBmBGxMLoX9sudqDP8i/LWCchSsblcmjxJl4VJ7V0um+laDSg8zALqnckUWeHUvwI33ep4sIDZxHU59Huh8ftmitV2+oDvMt9Osk3bMezgJC8Vlqm6xzPS57QQo+MMtZH9ztsn9FPa7JnzlSLGVJzMbNSd8H4oY5FaVJT6F+kau+epbdCZY5g+CY1taOxJrvAHGi2N5/WPyPDf+XLbIm0RZHTAqe0iPsofQlyaqvY0TbYQVr+V2GkoBCzF41/1l6UsZXLXWkEi/hgO11C9QP0wf/Ja5r+F3M3I4m9VlTBBo+N2JrA5VUqHxxeYqvtA6YgLNcHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4869.namprd15.prod.outlook.com (2603:10b6:806:1d0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Thu, 22 Apr
 2021 16:35:07 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 16:35:07 +0000
Subject: Re: [PATCH v2 bpf-next 09/17] libbpf: extend sanity checking ELF
 symbols with externs validation
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-10-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7ad73fdc-e81a-9b4b-1dce-e8c304e88e0a@fb.com>
Date:   Thu, 22 Apr 2021 09:35:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-10-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:427c]
X-ClientProxiedBy: CO1PR15CA0094.namprd15.prod.outlook.com
 (2603:10b6:101:21::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:427c) by CO1PR15CA0094.namprd15.prod.outlook.com (2603:10b6:101:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 16:35:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e6526dd-8594-475c-dafe-08d905ac9689
X-MS-TrafficTypeDiagnostic: SA1PR15MB4869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB48699974EF066B1A9632D841D3469@SA1PR15MB4869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:669;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sss3+42d+9xJe8z+g642jFizt1CIvplS1OzOCbxPBs6ADhdreG0OcOG1TYw7YB1/l/6baTiBYM3A4jxb9N6CVAmXmGRZdKX4ZzKd3beFpWj8OMPaZ6nd6dmtZTM+9T/o33q7de2A7JvuZcqvoTHUQBq77ZYAvHshmVVSEGJ3zXsWkn2p4IjYendqYM/CI0srwsBlgJaUzXRxGecXDZZ8AlKeD39+KCCXn5lTJnQkqtfCbeeT2IOPWKfxsVqkme8oIRm2fCKZUENmGpFo5SODpVpOrHE4veBM2mvltq/iXNtywz5n4pRLkIMtSRlqy+02EkTzpU2TRVQ5NsO2/HsY3TtUK/jPbKgh5iVm4PgqMekT5oCv2eUXhZGieSyyk2wRRHnBm579JqPpvMCxDhTeclF1T5OhBLzUGBxxo5hokljEwHOVpcMCmV0OLCEwPO4NW6I5jN8ckp8Qmq3C5WjRIDzwHDxkui3/j7fozyUzqetoNQZLNC7Psdqyl6AohaUxn+L12RGmj4tDTGdjjt5k1MfeAZb/qtEBi1uKxx9xCcTsXPC6P4VNOPH1IkWd8x1Jy6CJ2QpAZahKoN4GYCd9kQFswIoQ4CxehtcABvz5TGL9GCx8pLoUzhMxbxVA2lDvtyeMYJUqg31/h64g2PpdJNoG/RS82/1Q3JKpViStIhKDzHNMMUGY9524xUltZYjl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(498600001)(66946007)(66556008)(83380400001)(66476007)(38100700002)(53546011)(6666004)(2906002)(36756003)(16526019)(5660300002)(31686004)(8936002)(6486002)(186003)(2616005)(31696002)(52116002)(4326008)(8676002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S2pYdlRvMXZKSXZPaWhBcXI3Yjh5b0ZONjdtb3NTVGJKbkpwNFlyR04rMHVo?=
 =?utf-8?B?T1d1Ty9xSW1qNG5vNXo0Yk5HOWlXeFFtYStXRk5LWTFVRmV0bzZoUWk1YVRT?=
 =?utf-8?B?TWdPbmJMeTg5Tkd4Z01qNVBtdTZJYzIxV1NQSHpHaGs5Z3p2ZG9FRTlMV25H?=
 =?utf-8?B?SS9XbHVaVmFWRVFXY0NZd0lhMkVwcEE2Q2VoZVVIMVBlZnpESmJHZ2wyRy8y?=
 =?utf-8?B?R1pnRFBkS0lKbG15ejhKVWY2ZXlKejhvTkxRM0VOTTJ4NHJtN2R4bTBsTk9s?=
 =?utf-8?B?a0RFNng1TlFjYzV3YU9Xd3lHVG5wVk45VzYrUW9UeEp2VTFpUVN1WE1sVWs2?=
 =?utf-8?B?TUtzMVFOYUhJcHNzVlNjVHRpZVBYb2RQTGdwUytCWDV6YjRVL1hkbkVIR010?=
 =?utf-8?B?d21RbnhNVHlRTy92SjgzVUpIaXNpY1BKdEpaQTQ1WXY5Qm8zdEEzUS81U01V?=
 =?utf-8?B?ekRTNGlUVWxIWWlDU211TDVVSDdVeW0wNEpvNzhHSWFtZ2IxalRHWENJdFpE?=
 =?utf-8?B?cjdxS3RiRldLc1hsOHkrU1lwYTJsMk00WFhNbWVBRnk1czFKR1VjRlFYY25V?=
 =?utf-8?B?Q1AzclAxMGFjZWxmZ0ZBVTVsemVPUVp4Y3BXZlgwMUkyQzZFeFpIUWw0STkr?=
 =?utf-8?B?N3prUDh5MmtkRytCSDRxQ1FhVXJnL2ZNajkzRENxZjh4YzBBNEN0L0VWeGRa?=
 =?utf-8?B?bG9hRVNNUC9kL2JOSWJLWlRQSS92VnFGTUtYREdRaGdyRkQ0K1M4NEozYzcw?=
 =?utf-8?B?S1NrS3A0emIxTFlpbXNXclZ6UExqS3d3OXpTK2hPRVpMOGxOeFJwZnFWOHJW?=
 =?utf-8?B?YmFJcFZKZHhERnh3VkcrMUU5VUhpWVhWSGZCOG1WRk9WZVBMb2FoUkJWenpQ?=
 =?utf-8?B?NW5EaXNwdCtLZkF3ZklKSTgvbXNBVUpxbnExSnpqVWt2SzBMNVZ3K01ZQ3kw?=
 =?utf-8?B?VlNzVXB2UkNnbnE1OXRFZ3NKb1NkTXM5SllDQ2ROYnlQcksrMkhoVUw1cGph?=
 =?utf-8?B?MDAvMDFxZWptMk51UXFjNTJBd3A3WlM1R2w2Tnp6SC9PSVlaaFlxRTlRcGlL?=
 =?utf-8?B?SXlOTHE4VTF3Umh5bEJGeFQxMzVkT2VHd3MydzNRaXY3UWhzUFBPcWJ1MEJH?=
 =?utf-8?B?SWJFNHBtbGI1akF3eDNOcFVzMXBMVUhqbDNkdHpsWTNRUE9jWUZ2QUdLbGkw?=
 =?utf-8?B?dDIzOFdVbWhZL0hUQWtvK3FYNjRxZm5QYnlXUzJ5QmlNSGswVWtxUG1EdDVE?=
 =?utf-8?B?RDB6RndYMlJVUDNiT3pFTFFmNlRSUWtJVWo0UlQweFZ6aWtTa2NTUkRocmtG?=
 =?utf-8?B?ZEdrdk5vVDM2YnVucjBtdUt1M2ZxTnBFSUNiMFkwZUcxcEZiRGsyUEdhbVpl?=
 =?utf-8?B?WHJuTDlDcUYxK2t0R3ZHRUl4bzJ3VlR2NzdqaHNpM3NvWWRpNWphTGRJQWUz?=
 =?utf-8?B?WkxxMGtTYjFOd21OUXJKaTdnaEhaWVFBZytVMXhiWFdwRG1FejFRSkNrK1dH?=
 =?utf-8?B?ckwwQmp3ZyttcSsxa0pxSC94TEJaSTF3eEtrRlpQcTZKajhHYm9FNll6UWZn?=
 =?utf-8?B?Sk5aTngyeWpGZjMwZ2VDT09wVWhMZXZzRWxYRHpVS2RsUGRPYUZlRDlJZERK?=
 =?utf-8?B?NGpNQVBHWVNlRmt3bEh2YzM5SDdXTVdOSlh3UlpLUXhHZ01laUdtM0lReEZn?=
 =?utf-8?B?WmR5THk0czNKVW4xK3NOcUJBVGJGS3RFWlYyQ3d3K0dEOUNIOGxXZk15d3Ez?=
 =?utf-8?B?MkZ2aTJtUDBkRWFDNVI4U3ZYeDB0RDdLVm81amZmUjRhU3NoeFVMaTFEeWRz?=
 =?utf-8?Q?atZMwg3uxvDFw5IKqmnEyszsuod2suS+7lZ1g=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e6526dd-8594-475c-dafe-08d905ac9689
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:35:06.8835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T0DhoMpHNUEf/53E0hHv3v2sqqPWVqmD1eZbaXOhLm7aX90YgIQFJyLBP4uURMEu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4869
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: N5geLUJFI1XQLpAt3RtV6MsC6Zi18uNQ
X-Proofpoint-GUID: N5geLUJFI1XQLpAt3RtV6MsC6Zi18uNQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_11:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104220124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Add logic to validate extern symbols, plus some other minor extra checks, like
> ELF symbol #0 validation, general symbol visibility and binding validations.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/lib/bpf/linker.c | 43 +++++++++++++++++++++++++++++++++---------
>   1 file changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index 1263641e8b97..283249df9831 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -750,14 +750,39 @@ static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *s
>   	n = sec->shdr->sh_size / sec->shdr->sh_entsize;
>   	sym = sec->data->d_buf;
>   	for (i = 0; i < n; i++, sym++) {
> -		if (sym->st_shndx
> -		    && sym->st_shndx < SHN_LORESERVE
> -		    && sym->st_shndx >= obj->sec_cnt) {
> +		int sym_type = ELF64_ST_TYPE(sym->st_info);
> +		int sym_bind = ELF64_ST_BIND(sym->st_info);
> +
> +		if (i == 0) {
> +			if (sym->st_name != 0 || sym->st_info != 0
> +			    || sym->st_other != 0 || sym->st_shndx != 0
> +			    || sym->st_value != 0 || sym->st_size != 0) {
> +				pr_warn("ELF sym #0 is invalid in %s\n", obj->filename);
> +				return -EINVAL;
> +			}
> +			continue;
> +		}

In ELF file, the first entry of symbol table and section table (index 0) 
is invalid/undefined.

Symbol table '.symtab' contains 9 entries:
    Num:    Value          Size Type    Bind   Vis       Ndx Name
      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   UND

Section Headers: 

   [Nr] Name              Type            Address          Off    Size 
  ES Flg Lk Inf Al
   [ 0]                   NULL            0000000000000000 000000 000000 
00      0   0  0

Instead of validating them, I think we can skip traversal of the index = 
0 entry for symbol table and section header table. What do you think?

> +		if (sym_bind != STB_LOCAL && sym_bind != STB_GLOBAL && sym_bind != STB_WEAK) {
> +			pr_warn("ELF sym #%d is section #%zu has unsupported symbol binding %d\n",
> +				i, sec->sec_idx, sym_bind);
> +			return -EINVAL;
> +		}
> +		if (sym->st_shndx == 0) {
> +			if (sym_type != STT_NOTYPE || sym_bind == STB_LOCAL
> +			    || sym->st_value != 0 || sym->st_size != 0) {
> +				pr_warn("ELF sym #%d is invalid extern symbol in %s\n",
> +					i, obj->filename);
> +
> +				return -EINVAL;
> +			}
> +			continue;
> +		}
> +		if (sym->st_shndx < SHN_LORESERVE && sym->st_shndx >= obj->sec_cnt) {
>   			pr_warn("ELF sym #%d in section #%zu points to missing section #%zu in %s\n",
>   				i, sec->sec_idx, (size_t)sym->st_shndx, obj->filename);
>   			return -EINVAL;
>   		}
> -		if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION) {
> +		if (sym_type == STT_SECTION) {
>   			if (sym->st_value != 0)
>   				return -EINVAL;
>   			continue;
> @@ -1135,16 +1160,16 @@ static int linker_append_elf_syms(struct bpf_linker *linker, struct src_obj *obj
>   		size_t dst_sym_idx;
>   		int name_off;
>   
> -		/* we already have all-zero initial symbol */
> -		if (sym->st_name == 0 && sym->st_info == 0 &&
> -		    sym->st_other == 0 && sym->st_shndx == SHN_UNDEF &&
> -		    sym->st_value == 0 && sym->st_size ==0)
> +		/* We already validated all-zero symbol #0 and we already
> +		 * appended it preventively to the final SYMTAB, so skip it.
> +		 */
> +		if (i == 0)
>   			continue;
>   
>   		sym_name = elf_strptr(obj->elf, str_sec_idx, sym->st_name);
>   		if (!sym_name) {
>   			pr_warn("can't fetch symbol name for symbol #%d in '%s'\n", i, obj->filename);
> -			return -1;
> +			return -EINVAL;
>   		}
>   
>   		if (sym->st_shndx && sym->st_shndx < SHN_LORESERVE) {
> 
