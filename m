Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6C836845F
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 18:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhDVQHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 12:07:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22544 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230510AbhDVQHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 12:07:08 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13MFnieE007013;
        Thu, 22 Apr 2021 09:06:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dyQ4Y/8YWyaMoQ7tiQPrS5jTHibevlsVlfLCKH1wXQI=;
 b=XDJYfEUy3RDN0VcXTpBKo2yVnZ+EuEHiFRoKjPcmrr3wzWGgkZP+1boJKgF5VsVtVkt4
 BSXAA1VtsF5PNX7TEQ7vElNBIMEjJ8LyOhadu1mboNytSVWZKRais0vqWIzGGqVtCWzB
 RkV3uqnCOtOTCpOFK7/c2djMauMPwRb1rVg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3839sh140e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Apr 2021 09:06:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 09:06:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KExGpztJDWVw1MfE/R7LJcco4FIqKNzNdy0YlHBv42KXPRRIIl486AN5qkn9Xi3+uMEsKVUrdfubmExmkE7ycoe+OCzCsNr1zy9/476JX1wgtY1gHNoN9IxIZIp7vAWauMiS4Y1XkKd7Ini8PnX2K+Mix9Or9aXupfUkWtgtsn+Hj46VB0V4SiaNHjwXqiMW1qaQC1npsR281fqMTSpj0iR59ToW/eXAsEdLFohmP/MbGCL8ECKZKDiJXw38ICIl44QwrrffE+aEZdVlZqEChhEXGWqDYHY/zVTZ7IUi3Or6DXj0nkLs6Og92noel7/+pKNlAbwhl7rmKq2zqXVdpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dyQ4Y/8YWyaMoQ7tiQPrS5jTHibevlsVlfLCKH1wXQI=;
 b=Njpyv2ni0f8MN8Eh7McE74KJBZumVfJNIqpqwMuG0fl2UPlu3WbxhibpkMbMtvsUBmUs+MlMpEWskaH2MceLPP3ihOdL8MSXrFwHQDHJBlKhY7wtM9zUXgExecH+8e8XBy2781gf/wHrxkS0+hUL2nernmqf3dg/RIJWwQ+qdfdS5vjkEOfe7zM589ZPVFvN17FAWEOOfwXWA1nPPLGK+RIbRfrTPxOh8cIm+ure4mkKeHbLIToi6tbrCsiEGgz9WH+VgKWgQDTRAQDIIuR/qfmFM/IMeclDx9JlHkChzUQdiaPA1KDAzE+eOqo4QxSYL2HqZBZ5vM/lmQTPLQsEEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3917.namprd15.prod.outlook.com (2603:10b6:806:87::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 16:06:18 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 16:06:18 +0000
Subject: Re: [PATCH v2 bpf-next 07/17] libbpf: factor out symtab and relos
 sanity checks
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-8-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6fb105a3-ffc3-1970-8833-429e5b624e31@fb.com>
Date:   Thu, 22 Apr 2021 09:06:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210416202404.3443623-8-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:427c]
X-ClientProxiedBy: CO1PR15CA0065.namprd15.prod.outlook.com
 (2603:10b6:101:1f::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::16ea] (2620:10d:c090:400::5:427c) by CO1PR15CA0065.namprd15.prod.outlook.com (2603:10b6:101:1f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Thu, 22 Apr 2021 16:06:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 921d7ea1-1ef1-4354-c95b-08d905a89047
X-MS-TrafficTypeDiagnostic: SA0PR15MB3917:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB39174AE7F403D571B2281779D3469@SA0PR15MB3917.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:389;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ds+R93+wWZu6Z5f0ORIMCFd87muLJ9RF7iRXfAgbdw2V/cFTo8dO0tHRFexND/O5qzQZu/wDnd0Xquxnwy1VMSr0UcBv3q61YAjlb+R6uLbkAWdE44y+itw/if08am25CAL/1bzHnc+vD6tw+Tgaxqf0NumrDvGAP2FMZmkOtcvIs3iK3B/BJ+4nmEm7goO1IRGzMDg8cm4u1QpM3/wE94xQd457oCUXOI4QOooQsjMxv/W4hmVtiQTO77t6HImF64aNvtf522vLDdgoTKmLVAnzZZNGVodkmiB2ULBuTDpSaLjabgTPD0UbsbIV+tMagVHZNegoIGn8X1lk+yEhM5V0hi7+s+WJelMXIEarloHTblCpQbN1xkXbaM0Ycth8awQ6dyTCwl1U+vgSANIOH7GcGfpN+TFhI+zzqYoIWj6zpzl1X3b3aIhwxU5iHKpm17g7D7uYSPCUO4mXhvF/SoqM0nKCyBLYCJThcHIh6EJYyokmwvX23CQX4T8XMUv8iOdmTLSJ5NaET8rR8YT178dKjjiESgVtzJauMRFkKBOomtbuiCUhO1DdfS4IYtf6/HiMT4uyoGicAX5SJeJVZtAHpO9XkVMKi+7/00UcLJhTz612UhUSip+bw1BtYE3/KbPKbK+z3+ESS7+hjaMHbwKpFj5k48e+uIy+MbnRNT/e2SS4MpbFPMxc8yjnPKnU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(346002)(376002)(5660300002)(6486002)(4326008)(66476007)(478600001)(31696002)(66556008)(2906002)(86362001)(2616005)(66946007)(53546011)(186003)(38100700002)(52116002)(83380400001)(16526019)(8936002)(36756003)(31686004)(8676002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S2RQcW92WU5UcUJpSTdTMlJsWkNHV3M4RkRFdnlHRWhIc0Zob3I0UnBsUUNl?=
 =?utf-8?B?YUlXMFNxZWhoWTBxdDJSN1l3RUVQSHE4S1F4SE9tYTRXZ0ovcnQzbmJDRkJq?=
 =?utf-8?B?NVl2VTFPN0NYZUFnTkhJU3BRYW5lMTR6ZTVnY3ZndUQzNml0YXdwb3lNQUNl?=
 =?utf-8?B?WEphcE9oUWNWSHlLRm1paHEwUEY3aVJ2SEVZcVpIVzBtN1ZWanludjg2NXli?=
 =?utf-8?B?SDhuZXpaM3YyZEs1WW9BcjNRYjV5VTRnVWxuZ25GSEZmNFJOZ1piV295Uk9q?=
 =?utf-8?B?cWZUaVRRdHpKNXpkQjZGKzErdE81ZTZJYkU4Nnd4K3NaaGJybGFQUFZPM28r?=
 =?utf-8?B?cFY3RmQrbU5wVkhVRmY1TGdEU2trMUg4MHhlQ2JSaktmQW0rMjJXTzVGZkZR?=
 =?utf-8?B?bXhnYVhnWUY1U25tbUNZZmIxeDFkMlNSYXFXTlpMeHRvNTFaSjA0VHBCaEJu?=
 =?utf-8?B?UDF6cDBGTG15ejJiSlRKcERnanpMZ1RiUFlxZmM5NzBodlJNTlQyR2RaSHVX?=
 =?utf-8?B?K1ZMdjltS2d2K3hTaERWL3pIdWtrNFhYN3pHU2g3UWEvZ0V5eDFTYU9UODB3?=
 =?utf-8?B?TUN4OElMek9DVm5qelpUT0xwaVNIcjA3L29LQUFydlBQZEZxVVluS1ppbnE4?=
 =?utf-8?B?Rk5uNFFBdERjLzN1Q0ZpUEJDQ2QvNzFBYlYzQkw4TXFNUVkwTnZRMkFEM1VX?=
 =?utf-8?B?Y0lMdW0zcDlvdHkvb1NLY2o2V1AzUVNxWHpYUWtNdE1HVG0xN1MzK2NPQ3lu?=
 =?utf-8?B?aHhzWnBZL0xHVzFRdkNLdGFML01LUnRZdzVCZjgvUlpnY2EwR3JNZDNDb3R2?=
 =?utf-8?B?WHZnRGdzalR2M2NtVHhJRXJURTIvTysxZmQ2NmhhSXBHRWNleEhpUnN3QjAx?=
 =?utf-8?B?RklDUWsvdFlBUWNxS1dKRUNFL2ptRlRkcDIxYkdQeVJtNzh5Y0UzZjVIR2h0?=
 =?utf-8?B?NC8vc3k3djZzeHhFdktDdyt4WTFYN3FLTlIzNkFzb0lOZHVSWmJscFFwaFJR?=
 =?utf-8?B?NTRkYkd0TjcrSWZBYlpnV0hkaVdWeDFGdHEvZmNULzQrSEZwOHdDbUJGc1hD?=
 =?utf-8?B?ZEx2RGhmdUc4cUNTV1UyUTZMR1B4cVpZbVJxOGZadzAvZ1ZqUTFEYkVvUDNP?=
 =?utf-8?B?eTlZTEp5LzdiWDdLcnJ0ZFBjZXVpdEg0djZQL0lqK2czemFXNkh1aUNOWUN0?=
 =?utf-8?B?eHhSV0NlRk5RaVZ5WUpaR0hNQll5RXFRWnE0VERjNS83bG9vVVhjdzI0Mm9Z?=
 =?utf-8?B?aFVrZmJNeVcyRG1qZnZOU2srNXVqM3NIbU82NFQzNXltTDRlQzUyK1ZqRzFI?=
 =?utf-8?B?TnN2ZGpQdkorRjJTVDNyTHRRTlE2UFVVZVlFYjFsbnhzU0MvRUVGdzAxcWdL?=
 =?utf-8?B?WStFNUYyOWY4THkyWURxU2N6OUtjaWQvMTF1cFdydm1xdHVENUdQRmEzSFdn?=
 =?utf-8?B?c08yQjhyZ0pWQzdLUXJlbFl5bXA1ejNSWXJCNGtYRFVUcWdvaDZ6bDdoNitK?=
 =?utf-8?B?K3k3cmh1aER6QWpINFdiV0pUT0s1SXB6Z3FNNjhOYTlabXVOekwzcUEzQXBx?=
 =?utf-8?B?ZjJCMlB4ZmxkUHFQTTRjd3hnWTgyWk05TDdKT25NMEFjaXFRUjByVGZOYzFU?=
 =?utf-8?B?UEtJYWIzK2xTb1IxOE5sQlplVkRaMUJVT2E3WHJIL2VHSEE0N2lYYklNRXIx?=
 =?utf-8?B?SUNvd3VERGRXb2ltWGpqYWg1Q0RuV0FjNzBmeXgzeUlZZVhITTlkb0w1VE9x?=
 =?utf-8?B?UVZzQTZkeVRPTllWajhhb2YyVGNOdzE4VE5BTXJvY0lDcXJ5cHY5Ulk3VmJ3?=
 =?utf-8?Q?xyYX5BQglVUM/jOSY0zPbGxjd3jezyw0J+mgo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 921d7ea1-1ef1-4354-c95b-08d905a89047
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 16:06:18.4353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b8iW1SaXoXvTBeQeot4djelBeL+rItnSF10TDVHXDtRcXm6oTzZqvbgvlRo9pwQb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3917
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: _UVWnr4_1b8RLC94566U_tO3PzHwJgmP
X-Proofpoint-GUID: _UVWnr4_1b8RLC94566U_tO3PzHwJgmP
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-22_11:2021-04-22,2021-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/21 1:23 PM, Andrii Nakryiko wrote:
> Factor out logic for sanity checking SHT_SYMTAB and SHT_REL sections into
> separate sections. They are already quite extensive and are suffering from too
> deep indentation. Subsequent changes will extend SYMTAB sanity checking
> further, so it's better to factor each into a separate function.
> 
> No functional changes are intended.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Ack with a minor suggestion below.
Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   tools/lib/bpf/linker.c | 233 ++++++++++++++++++++++-------------------
>   1 file changed, 127 insertions(+), 106 deletions(-)
> 
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index 4e08bc07e635..0bb927226370 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -131,6 +131,8 @@ static int init_output_elf(struct bpf_linker *linker, const char *file);
>   
>   static int linker_load_obj_file(struct bpf_linker *linker, const char *filename, struct src_obj *obj);
>   static int linker_sanity_check_elf(struct src_obj *obj);
> +static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *sec);
> +static int linker_sanity_check_elf_relos(struct src_obj *obj, struct src_sec *sec);
>   static int linker_sanity_check_btf(struct src_obj *obj);
>   static int linker_sanity_check_btf_ext(struct src_obj *obj);
>   static int linker_fixup_btf(struct src_obj *obj);
> @@ -663,8 +665,8 @@ static bool is_pow_of_2(size_t x)
>   
>   static int linker_sanity_check_elf(struct src_obj *obj)
>   {
> -	struct src_sec *sec, *link_sec;
> -	int i, j, n;
> +	struct src_sec *sec;
> +	int i, err;
>   
>   	if (!obj->symtab_sec_idx) {
>   		pr_warn("ELF is missing SYMTAB section in %s\n", obj->filename);
> @@ -692,43 +694,11 @@ static int linker_sanity_check_elf(struct src_obj *obj)
>   			return -EINVAL;
>   
>   		switch (sec->shdr->sh_type) {
> -		case SHT_SYMTAB: {
> -			Elf64_Sym *sym;
> -
> -			if (sec->shdr->sh_entsize != sizeof(Elf64_Sym))
> -				return -EINVAL;
> -			if (sec->shdr->sh_size % sec->shdr->sh_entsize != 0)
> -				return -EINVAL;
> -
> -			if (!sec->shdr->sh_link || sec->shdr->sh_link >= obj->sec_cnt) {
> -				pr_warn("ELF SYMTAB section #%zu points to missing STRTAB section #%zu in %s\n",
> -					sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
> -				return -EINVAL;
> -			}
> -			link_sec = &obj->secs[sec->shdr->sh_link];
> -			if (link_sec->shdr->sh_type != SHT_STRTAB) {
> -				pr_warn("ELF SYMTAB section #%zu points to invalid STRTAB section #%zu in %s\n",
> -					sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
> -				return -EINVAL;
> -			}
> -
> -			n = sec->shdr->sh_size / sec->shdr->sh_entsize;
> -			sym = sec->data->d_buf;
> -			for (j = 0; j < n; j++, sym++) {
> -				if (sym->st_shndx
> -				    && sym->st_shndx < SHN_LORESERVE
> -				    && sym->st_shndx >= obj->sec_cnt) {
> -					pr_warn("ELF sym #%d in section #%zu points to missing section #%zu in %s\n",
> -						j, sec->sec_idx, (size_t)sym->st_shndx, obj->filename);
> -					return -EINVAL;
> -				}
> -				if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION) {
> -					if (sym->st_value != 0)
> -						return -EINVAL;
> -				}
> -			}
> +		case SHT_SYMTAB:
> +			err = linker_sanity_check_elf_symtab(obj, sec);
> +			if (err)
> +				return err;
>   			break;
> -		}
>   		case SHT_STRTAB:
>   			break;
>   		case SHT_PROGBITS:
> @@ -739,87 +709,138 @@ static int linker_sanity_check_elf(struct src_obj *obj)
>   			break;
>   		case SHT_NOBITS:
>   			break;
> -		case SHT_REL: {
> -			Elf64_Rel *relo;
> -			struct src_sec *sym_sec;
> +		case SHT_REL:
> +			err = linker_sanity_check_elf_relos(obj, sec);
> +			if (err)
> +				return err;
> +			break;
> +		case SHT_LLVM_ADDRSIG:
> +			break;
> +		default:
> +			pr_warn("ELF section #%zu (%s) has unrecognized type %zu in %s\n",
> +				sec->sec_idx, sec->sec_name, (size_t)sec->shdr->sh_type, obj->filename);
> +			return -EINVAL;
> +		}
> +	}
>   
> -			if (sec->shdr->sh_entsize != sizeof(Elf64_Rel))
> -				return -EINVAL;
> -			if (sec->shdr->sh_size % sec->shdr->sh_entsize != 0)
> -				return -EINVAL;
> +	return 0;
> +}
>   
> -			/* SHT_REL's sh_link should point to SYMTAB */
> -			if (sec->shdr->sh_link != obj->symtab_sec_idx) {
> -				pr_warn("ELF relo section #%zu points to invalid SYMTAB section #%zu in %s\n",
> -					sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
> -				return -EINVAL;
> -			}
> +static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *sec)
> +{
> +	struct src_sec *link_sec;
> +	Elf64_Sym *sym;
> +	int i, n;
>   
> -			/* SHT_REL's sh_info points to relocated section */
> -			if (!sec->shdr->sh_info || sec->shdr->sh_info >= obj->sec_cnt) {
> -				pr_warn("ELF relo section #%zu points to missing section #%zu in %s\n",
> -					sec->sec_idx, (size_t)sec->shdr->sh_info, obj->filename);
> -				return -EINVAL;
> -			}
> -			link_sec = &obj->secs[sec->shdr->sh_info];
> +	if (sec->shdr->sh_entsize != sizeof(Elf64_Sym))
> +		return -EINVAL;
> +	if (sec->shdr->sh_size % sec->shdr->sh_entsize != 0)
> +		return -EINVAL;
> +
> +	if (!sec->shdr->sh_link || sec->shdr->sh_link >= obj->sec_cnt) {
> +		pr_warn("ELF SYMTAB section #%zu points to missing STRTAB section #%zu in %s\n",
> +			sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
> +		return -EINVAL;
> +	}
> +	link_sec = &obj->secs[sec->shdr->sh_link];
> +	if (link_sec->shdr->sh_type != SHT_STRTAB) {
> +		pr_warn("ELF SYMTAB section #%zu points to invalid STRTAB section #%zu in %s\n",
> +			sec->sec_idx, (size_t)sec->shdr->sh_link, obj->filename);
> +		return -EINVAL;
> +	}
>   
> -			/* .rel<secname> -> <secname> pattern is followed */
> -			if (strncmp(sec->sec_name, ".rel", sizeof(".rel") - 1) != 0
> -			    || strcmp(sec->sec_name + sizeof(".rel") - 1, link_sec->sec_name) != 0) {
> -				pr_warn("ELF relo section #%zu name has invalid name in %s\n",
> -					sec->sec_idx, obj->filename);
> +	n = sec->shdr->sh_size / sec->shdr->sh_entsize;
> +	sym = sec->data->d_buf;
> +	for (i = 0; i < n; i++, sym++) {
> +		if (sym->st_shndx
> +		    && sym->st_shndx < SHN_LORESERVE
> +		    && sym->st_shndx >= obj->sec_cnt) {
> +			pr_warn("ELF sym #%d in section #%zu points to missing section #%zu in %s\n",
> +				i, sec->sec_idx, (size_t)sym->st_shndx, obj->filename);
> +			return -EINVAL;
> +		}
> +		if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION) {
> +			if (sym->st_value != 0)
>   				return -EINVAL;
> -			}
> +			continue;

I think this "continue" is not necessary.

> +		}
> +	}
>   
> -			/* don't further validate relocations for ignored sections */
> -			if (link_sec->skipped)
> -				break;
> +	return 0;
> +}
>   
> -			/* relocatable section is data or instructions */
> -			if (link_sec->shdr->sh_type != SHT_PROGBITS
> -			    && link_sec->shdr->sh_type != SHT_NOBITS) {
> -				pr_warn("ELF relo section #%zu points to invalid section #%zu in %s\n",
> -					sec->sec_idx, (size_t)sec->shdr->sh_info, obj->filename);
> -				return -EINVAL;
> -			}
[...]
