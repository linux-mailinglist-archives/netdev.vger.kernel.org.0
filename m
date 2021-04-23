Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D2D369B42
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243799AbhDWUZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:25:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28336 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243795AbhDWUZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 16:25:54 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NKOMZW014869;
        Fri, 23 Apr 2021 13:24:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vTZH942hB5uOUYBVFEtlIgETts3AtrE2BbYljzTHQio=;
 b=evCd7ltg8DNhM7FlN8W+3HUkuc+nLiHj589PgEVam9/MLbo5DSSbHou1KsIOmtbtwrNZ
 KpareIuwfe9g2641HL2y/vG/j4rdIR7V4qI1lFEbQ4MhOj8eU8reknpQtijH18YS0S8b
 QoIO5gPf/RtcWPRejKHqvgu3+S0hqLbI/X4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839sh96q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 13:24:45 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 13:24:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ej7zzvApP5T/MbAWrJG+oqKKx+vvdw1IgixlsCK2VOe5hgC0qQM9Z4YlNhiw+DiF258qjLkW9/ZghRvNu76u3YVat0S5LPNHZ4OWHBNAb0o+Y+eKPBLidcE3bdul/+CYmHzAreKSCETMOL4z5nBteldZKocKwVCiV+6vldDOVDBTA/CdjGI7y3s4SQZ/PonqePizLnyszH6HiX6pY1pGvGNJugnKzU9wT2SMruiqvPlJRpn34l3rBzu3Dxg0OjU0n8H43Lv5+r7AAOKI9xnRnsNKrPNDzsZZQ9383ql6az4dosVoWHx/ZZTxGo7eQjgY2awlWwVZrLnjQ3uLr+3PBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTZH942hB5uOUYBVFEtlIgETts3AtrE2BbYljzTHQio=;
 b=kIms06hvT1H6XewbX9ge03eMnpZM9g7y5VHrv4EvInhRy7HLr1oEtuTHpD7QNUnWcFgNobOoMZYqE6ZV6k5DE0fGU8LF5MDP6Et5h1mtaxT9exX5m9tBWsJyapNmZmp9S3nSMk7818Cml3YnuivzX29cs2zl32tzNlsbY8r+BhABHcHEM66wxi+5XTGEjYV+XVrk3vKGQnmaRCDRRmzwGadKGMTpRnv9YYSSBWlvC+8Jy65eezvOyMGFa/a+JuddTQ48o+sfnMGaMPRHFFKjz8GKiW9WooV0vGgFWihP/d2nag7cj5beG2tZ9aRV9Dp+ymfjuTjvfndKkzo59wHZaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4032.namprd15.prod.outlook.com (2603:10b6:806:81::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 20:24:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 20:24:42 +0000
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during
 linking
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-3-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com>
Date:   Fri, 23 Apr 2021 13:24:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423185357.1992756-3-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW2PR16CA0049.namprd16.prod.outlook.com
 (2603:10b6:907:1::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW2PR16CA0049.namprd16.prod.outlook.com (2603:10b6:907:1::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 20:24:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5b6d8df-c9f2-428d-6412-08d90695d304
X-MS-TrafficTypeDiagnostic: SA0PR15MB4032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB403261986B2D5C512F2BD382D3459@SA0PR15MB4032.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qcWhS8lMHtoS+0M29qKycQrqApC8Xy1a/2/Mp59qFiZQqLBbM90kUNvkTeHUXj/lWsHyScA7qFBCc3y6Xj/8IdEBpatNpUZnGCst1vyk3p8NU5ESmxTKcxLtkqrCLjMyuMI7mShxX68stjtb42ed+90btfBuWoLUXtdXFVGHDB1BGvCVBW+DSfnnPMGF8ZVTJHMZmJHHma7nSLcVrLqxZr66RS8AhHdb3Qi8ZdmyWuXDUqjwR1gm3gLitnmXKVMtmA67S7t/CYta7azVlAT0eM8Bq6jxMMhN458KnrRbpPhS3Yqa9qz2oJFDZSxVOsxIXIZPsp/CDiVoMADcogf5P5i+2NemvHOx9eG8IWXCobcEzQ3KBHbXmGuCma0sxNoJeBGk6kGLz73ErkJEEtGefU8BUXU2lh4+aesmwgwpZGDe7ksK/WhbjqyL3f2najlNLx+eGj6eKu5jjTcgTZpgfsv4n8ua+BGV135Sk/4TyFsBOTsuWaWZqYka17wC2I3STJyCIbmRb/YLAann9F9zlRJVJt9+91AmE1OCl8/4gKaoCxNWmj4c3uMOOqbe/hiXlJWrIoTkX6viBIIEJV17yiCl9t5qTnEa1bkhPMbCtvKq78hfjpyqZmK4kP3RCXRsdYUGRK4wmzcW6EU2scSOJNx0+u65uklB54jHZ2epPMbH63yu/e2sIF3KHC5Y0neS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(8676002)(31696002)(53546011)(5660300002)(31686004)(6666004)(8936002)(4326008)(66946007)(478600001)(30864003)(66476007)(36756003)(83380400001)(316002)(38100700002)(16526019)(186003)(66556008)(52116002)(86362001)(2906002)(2616005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S0FOd3lSOUREZTI3TEVBSWFKaUR2bkp6eno4aWhyemNlZ1lidVdpekJWRzlk?=
 =?utf-8?B?b053UXUrWXhUb2Z1TkNFMVV6MGcyaGNlLzZMRFNWWXRweW9ZZ0lhNzRjVWtJ?=
 =?utf-8?B?TmFqbUxhSlJvV2dFQk0zZXNZMlc1bWE5Uzh6aFlSUWErK3NJbG55aTUrNnp0?=
 =?utf-8?B?Yll6cmxkaEFLSWg4b01TZHh2QzEweE9zbm5Ea1lhbHloSkFUOWFsN1RsZmNJ?=
 =?utf-8?B?NmdLb1BYaTM5eHhIbWZsZXBYZ05CS0dMeE01bWJKdHd1YjhrQkhUb3FKdXVX?=
 =?utf-8?B?bUZoT0NKdVgwcHF2YWcwWnRPaDhvNUV6bXlYR3Eyb2FTK1hhTzhXdDZ3YUVO?=
 =?utf-8?B?WnN2ekd6N2tRZWtEOUZxYUhBWVRySW8rdHcvekJmRXJXZjlJb1NIRnU5b2xN?=
 =?utf-8?B?eVA1TWI4N3FDMHhYSWg2WDAzR0JPSHl5T0ErM1NLTHJUbXFvTGNvYnYyVjZG?=
 =?utf-8?B?MlkrTFhuNXVxTHF1eXN2c1AvTXlya0F6Q1h1VGUyMDAydXFKZkZWUSswYzVn?=
 =?utf-8?B?UVY3YnlNdkZtRkhLaHJvdkRiaHhoekJLOGpDaXJhaE5UWkhQN3diRmhXbnhs?=
 =?utf-8?B?TzcvZmQ4Sm5OZ3ozam54MHBRYjZBamVSM2FZaW00R05yTlFrTkpONEpIRHQ2?=
 =?utf-8?B?bDZMaUQ4N1RLYVQ0LzloNjJIOWV2L1lGV2RzN2piTmNiK01MZXVybUVKRXY3?=
 =?utf-8?B?VkNoS1czYkhiMHpXQzUzNGIvdnNoZWJicWdXRDB1UTNZTzlnUGlyNmFhKzJF?=
 =?utf-8?B?ckVhYndpMjBSUE9nbXYweFdYU3N2cHd2TzNrQUhBd3lCbkJBZ3ViQVFuZm00?=
 =?utf-8?B?WGtub203SlI1bnJaWXhxV25sdWFrOVU1azJBdUVkUGVCNElSd0dqczBmdzhx?=
 =?utf-8?B?amhjNTVOdDMzUmZiK2dwczZNeWs5RnNWSTBZTnMzL2JST29vSUNIOUJ3RGxF?=
 =?utf-8?B?M3hGQmMzSG9vSXEyVUN6ZTU0Y1UyQlpRZVpJMEYrTVZLc3lHQ3RHZWZRR2t0?=
 =?utf-8?B?Rm13Q2lXcWR1ZHgyUXhOTGs2TUU2RFAyN1B2WGRGZm9oTUxUUFV0eDdhdlc4?=
 =?utf-8?B?SWhNUjdITzVqd2xjZU5QcVk3YWRjTWdIdFV2OWE2MW9YWklkdVBPMlFPUUU2?=
 =?utf-8?B?TzB6QlVxREVjaGhYdEFiRkN4UzdzOTV1aW1jNUxpaElTWWV6NkxpU2ZrQVBD?=
 =?utf-8?B?UHNjMzI1U3ZQa0U4bnFDcStORHI3M1c2TjdmUy9kaC96MzV4WDhpeFBTcFBj?=
 =?utf-8?B?Ym44OUs1R1JJc2dQVGRuckZCaVhQQkRNZGl0U1BLeWpUd0JRKzl0Z1ZhMGFv?=
 =?utf-8?B?VzZiYUF2T1h3M0p1WFpiS0tsaW1SaHE5bVFPVEZZdm1SVlRvZ09wbndlZnVv?=
 =?utf-8?B?dGN2Q2NLMG8vSlZxK2VFYVdMalJ6aXcraStHYkJDNTN4aTRBbU9zeEF4b2Zi?=
 =?utf-8?B?MFA3U2NJT3VGQkp6ai85eE9kTGQ0MWVpY05QUTE0U2o4U0krRXp6WFFYOU81?=
 =?utf-8?B?ckNkMDl1KzhacFExVjBZbTAzSHhBY2t6SW8wRlF5Z1oxYzZuYnVmTDZOeDV0?=
 =?utf-8?B?QURJSXhzVXNiODhGMUhHenF4Y0JEdFFWTnlKNlVJWStXTEsrU2k0NUhWTTJy?=
 =?utf-8?B?TGJKcVdVY2R5MlBQY2lMZXFGaEJzUTlLcjJzUjgwRnE1TENEUVdUaFJlNnQw?=
 =?utf-8?B?djhXRFpKeEowZEJDbGhkb2lBMHZHa0ZNTTlEN1Z2OUJXMnNEM3I0bWNXZVhh?=
 =?utf-8?B?cmJCaVpneExHZUpLYktIWDlzREFOYXdILzRqTHNSWjNzMkk0dHhjOTNiRmwx?=
 =?utf-8?Q?ceq5bQgKVbxaZUioEtajHyhIXKJO5uD45kflc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b6d8df-c9f2-428d-6412-08d90695d304
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 20:24:41.9084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/ZMKkJpx2gQMJeCM/ofRdgNRDw421Zx4GUpJYZmT+rDIgPUdyucMc6iKzd4A/PT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4032
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: o-tPedlw13KeBzvqGxXeZYqRTXmvI1tN
X-Proofpoint-GUID: o-tPedlw13KeBzvqGxXeZYqRTXmvI1tN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_10:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
> Prepend <obj_name>.. prefix to each static variable in BTF info during static
> linking. This makes them uniquely named for the sake of BPF skeleton use,
> allowing to read/write static BPF variables from user-space. This uniqueness
> guarantee depends on each linked file name uniqueness, of course. Double dots
> separator was chosen both to be different (but similar) to the separator that
> Clang is currently using for static variables defined inside functions as well
> as to generate a natural (in libbpf parlance, at least) obj__var naming pattern
> in BPF skeleton. Static linker also checks for static variable to already
> contain ".." separator and skips the rename to allow multi-pass linking and not
> keep making variable name ever increasing, if derived object name is changing on
> each pass (as is the case for selftests).
> 
> This patch also adds opts to bpf_linker__add_file() API, which currently
> allows to override object name for a given file and could be extended with other
> per-file options in the future. This is not a breaking change because
> bpf_linker__add_file() isn't yet released officially.
> 
> This patch also includes fixes to few selftests that are already using static
> variables. They have to go in in the same patch to not break selftest build.

"in in" => "in"

> Keep in mind, this static variable rename only happens during static linking.
> For any existing user of BPF skeleton using static variables nothing changes,
> because those use cases are using variable names generated by Clang. Only new
> users utilizing static linker might need to adjust BPF skeleton use, which
> currently will be always new use cases. So ther is no risk of breakage.
> 
> static_linked selftests is modified to also validate conflicting static variable
> names are handled correctly both during static linking and in BPF skeleton.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/bpf/bpftool/gen.c                       |   2 +-
>   tools/lib/bpf/libbpf.h                        |  12 +-
>   tools/lib/bpf/linker.c                        | 121 +++++++++++++++++-
>   .../selftests/bpf/prog_tests/skeleton.c       |   8 +-
>   .../selftests/bpf/prog_tests/static_linked.c  |   8 +-
>   .../selftests/bpf/progs/bpf_iter_test_kern4.c |   4 +-
>   .../selftests/bpf/progs/test_check_mtu.c      |   4 +-
>   .../selftests/bpf/progs/test_cls_redirect.c   |   4 +-
>   .../bpf/progs/test_snprintf_single.c          |   2 +-
>   .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
>   .../selftests/bpf/progs/test_static_linked1.c |   6 +-
>   .../selftests/bpf/progs/test_static_linked2.c |   4 +-
>   12 files changed, 151 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 440a2fcb6441..06fee4a2910a 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -638,7 +638,7 @@ static int do_object(int argc, char **argv)
>   	while (argc) {
>   		file = GET_ARG();
>   
> -		err = bpf_linker__add_file(linker, file);
> +		err = bpf_linker__add_file(linker, file, NULL);
>   		if (err) {
>   			p_err("failed to link '%s': %s (%d)", file, strerror(err), err);
>   			goto out;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index bec4e6a6e31d..67505030c8d1 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -768,10 +768,20 @@ struct bpf_linker_opts {
>   };
>   #define bpf_linker_opts__last_field sz
>   
> +struct bpf_linker_file_opts {
> +	/* size of this struct, for forward/backward compatiblity */
> +	size_t sz;
> +	/* object name override, similar to the one in bpf_object_open_opts */
> +	const char *object_name;
> +};
> +#define bpf_linker_file_opts__last_field sz
> +
>   struct bpf_linker;
>   
>   LIBBPF_API struct bpf_linker *bpf_linker__new(const char *filename, struct bpf_linker_opts *opts);
> -LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filename);
> +LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker,
> +				    const char *filename,
> +				    const struct bpf_linker_file_opts *opts);
>   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>   
> diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
> index 9de084b1c699..adc3aa9ce040 100644
> --- a/tools/lib/bpf/linker.c
> +++ b/tools/lib/bpf/linker.c
> @@ -4,6 +4,8 @@
>    *
>    * Copyright (c) 2021 Facebook
>    */
> +#define _GNU_SOURCE
> +#include <ctype.h>
>   #include <stdbool.h>
>   #include <stddef.h>
>   #include <stdio.h>
> @@ -47,6 +49,16 @@ struct src_sec {
>   	int sec_type_id;
>   };
>   
> +#define MAX_OBJ_NAME_LEN 64
> +
> +/* According to C standard, only first 63 characters of C identifiers are
> + * guaranteed to be significant. So for transformed static variables of the most
> + * verbose form ('<obj_name>..<func_name>.<var_name>') we need to reserve extra
> + * 64 (function name and dot) + 63 (variable name) + 2 (for .. separator)
> + * characters.
> + */
> +#define MAX_VAR_NAME_LEN (MAX_OBJ_NAME_LEN + 2 + 63 + 1 + 63)
> +
>   struct src_obj {
>   	const char *filename;
>   	int fd;
> @@ -67,6 +79,10 @@ struct src_obj {
>   	int *sym_map;
>   	/* mapping from the src BTF type IDs to dst ones */
>   	int *btf_type_map;
> +
> +	/* BPF object name used for static variable prefixing */
> +	char obj_name[MAX_OBJ_NAME_LEN];
> +	size_t obj_name_len;
>   };
>   
>   /* single .BTF.ext data section */
> @@ -158,7 +174,9 @@ struct bpf_linker {
>   
>   static int init_output_elf(struct bpf_linker *linker, const char *file);
>   
> -static int linker_load_obj_file(struct bpf_linker *linker, const char *filename, struct src_obj *obj);
> +static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
> +				const struct bpf_linker_file_opts *opts,
> +				struct src_obj *obj);
>   static int linker_sanity_check_elf(struct src_obj *obj);
>   static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *sec);
>   static int linker_sanity_check_elf_relos(struct src_obj *obj, struct src_sec *sec);
> @@ -435,15 +453,19 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
>   	return 0;
>   }
>   
> -int bpf_linker__add_file(struct bpf_linker *linker, const char *filename)
> +int bpf_linker__add_file(struct bpf_linker *linker, const char *filename,
> +			 const struct bpf_linker_file_opts *opts)
>   {
>   	struct src_obj obj = {};
>   	int err = 0;
>   
> +	if (!OPTS_VALID(opts, bpf_linker_file_opts))
> +		return -EINVAL;
> +
>   	if (!linker->elf)
>   		return -EINVAL;
>   
> -	err = err ?: linker_load_obj_file(linker, filename, &obj);
> +	err = err ?: linker_load_obj_file(linker, filename, opts, &obj);
>   	err = err ?: linker_append_sec_data(linker, &obj);
>   	err = err ?: linker_append_elf_syms(linker, &obj);
>   	err = err ?: linker_append_elf_relos(linker, &obj);
> @@ -529,7 +551,49 @@ static struct src_sec *add_src_sec(struct src_obj *obj, const char *sec_name)
>   	return sec;
>   }
>   
> -static int linker_load_obj_file(struct bpf_linker *linker, const char *filename, struct src_obj *obj)
> +static void sanitize_obj_name(char *name)
> +{
> +	int i;
> +
> +	for (i = 0; name[i]; i++) {
> +		if (name[i] == '_')
> +			continue;
> +		if (i == 0 && isalpha(name[i]))
> +			continue;
> +		if (i > 0 && isalnum(name[i]))
> +			continue;
> +
> +		name[i] = '_';
> +	}
> +}
> +
> +static bool str_has_suffix(const char *str, const char *suffix)
> +{
> +	size_t n1 = strlen(str), n2 = strlen(suffix);
> +
> +	if (n1 < n2)
> +		return false;
> +
> +	return strcmp(str + n1 - n2, suffix) == 0;
> +}
> +
> +static void get_obj_name(char *name, const char *file)
> +{
> +	/* Using basename() GNU version which doesn't modify arg. */
> +	strncpy(name, basename(file), MAX_OBJ_NAME_LEN - 1);
> +	name[MAX_OBJ_NAME_LEN - 1] = '\0';
> +
> +	if (str_has_suffix(name, ".bpf.o"))
> +		name[strlen(name) - sizeof(".bpf.o") + 1] = '\0';
> +	else if (str_has_suffix(name, ".o"))
> +		name[strlen(name) - sizeof(".o") + 1] = '\0';
> +
> +	sanitize_obj_name(name);
> +}
> +
> +static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
> +				const struct bpf_linker_file_opts *opts,
> +				struct src_obj *obj)
>   {
>   #if __BYTE_ORDER == __LITTLE_ENDIAN
>   	const int host_endianness = ELFDATA2LSB;
> @@ -549,6 +613,14 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
>   
>   	obj->filename = filename;
>   
> +	if (OPTS_GET(opts, object_name, NULL)) {
> +		strncpy(obj->obj_name, opts->object_name, MAX_OBJ_NAME_LEN);
> +		obj->obj_name[MAX_OBJ_NAME_LEN - 1] = '\0';

Looks we don't have examples/selftests which actually use this option.
The only place to use bpf_linker__add_file() is bpftool which did not
have option to overwrite the obj file name.

The code looks fine to me though.

> +	} else {
> +		get_obj_name(obj->obj_name, filename);
> +	}
> +	obj->obj_name_len = strlen(obj->obj_name);
> +
>   	obj->fd = open(filename, O_RDONLY);
>   	if (obj->fd < 0) {
>   		err = -errno;
> @@ -2264,6 +2336,47 @@ static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj)
>   				obj->btf_type_map[i] = glob_sym->btf_id;
>   				continue;
>   			}
> +		} else if (btf_is_var(t) && btf_var(t)->linkage == BTF_VAR_STATIC) {
> +			/* Static variables are renamed to include
> +			 * "<obj_name>.." prefix (note double dots), similarly
> +			 * to how static variables inside functions are named
> +			 * "<func_name>.<var_name>" by compiler. This allows to
> +			 * have  unique identifiers for static variables across
> +			 * all linked object files (assuming unique filenames,
> +			 * of course), which BPF skeleton relies on.
> +			 *
> +			 * So worst case static variable inside the function
> +			 * will have the form "<obj_name>..<func_name>.<var_name"
<var_name  => <var_name>
> +			 * and will get sanitized by BPF skeleton generation
> +			 * logic to a field with <obj_name>__<func_name>_<var_name>
> +			 * name. Typical static variable will have a
> +			 * <obj_name>__<var_name> name, implying arguably nice
> +			 * per-file scoping.
> +			 *
> +			 * If static var name already contains '..', though,
> +			 * don't rename it, because it was already renamed by
> +			 * previous linker passes.
> +			 */
> +			name = btf__str_by_offset(obj->btf, t->name_off);
> +			if (!strstr(name, "..")) {
> +				char new_name[MAX_VAR_NAME_LEN];
> +
> +				memcpy(new_name, obj->obj_name, obj->obj_name_len);
> +				new_name[obj->obj_name_len] = '.';
> +				new_name[obj->obj_name_len + 1] = '.';
> +				new_name[obj->obj_name_len + 2] = '\0';
> +				/* -3 is for '..' separator and terminating '\0' */
> +				strncat(new_name, name, MAX_VAR_NAME_LEN - obj->obj_name_len - 3);
> +
> +				id = btf__add_str(obj->btf, new_name);
> +				if (id < 0)
> +					return id;
> +
> +				/* btf__add_str() might invalidate t, so re-fetch */
> +				t = btf__type_by_id(obj->btf, i);
> +
> +				((struct btf_type *)t)->name_off = id;
> +			}
>   		}
>   
>   		id = btf__add_type(linker->btf, obj->btf, t);
> diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/testing/selftests/bpf/prog_tests/skeleton.c
> index fe87b77af459..bbade99fa544 100644
> --- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
> +++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
> @@ -82,10 +82,10 @@ void test_skeleton(void)
>   	CHECK(data->out2 != 2, "res2", "got %lld != exp %d\n", data->out2, 2);
>   	CHECK(bss->out3 != 3, "res3", "got %d != exp %d\n", (int)bss->out3, 3);
>   	CHECK(bss->out4 != 4, "res4", "got %lld != exp %d\n", bss->out4, 4);
> -	CHECK(bss->handler_out5.a != 5, "res5", "got %d != exp %d\n",
> -	      bss->handler_out5.a, 5);
> -	CHECK(bss->handler_out5.b != 6, "res6", "got %lld != exp %d\n",
> -	      bss->handler_out5.b, 6);
> +	CHECK(bss->test_skeleton__handler_out5.a != 5, "res5", "got %d != exp %d\n",
> +	      bss->test_skeleton__handler_out5.a, 5);
> +	CHECK(bss->test_skeleton__handler_out5.b != 6, "res6", "got %lld != exp %d\n",
> +	      bss->test_skeleton__handler_out5.b, 6);
>   	CHECK(bss->out6 != 14, "res7", "got %d != exp %d\n", bss->out6, 14);
>   
>   	CHECK(bss->bpf_syscall != kcfg->CONFIG_BPF_SYSCALL, "ext1",
> diff --git a/tools/testing/selftests/bpf/prog_tests/static_linked.c b/tools/testing/selftests/bpf/prog_tests/static_linked.c
> index 46556976dccc..f16736eab900 100644
> --- a/tools/testing/selftests/bpf/prog_tests/static_linked.c
> +++ b/tools/testing/selftests/bpf/prog_tests/static_linked.c
> @@ -14,12 +14,12 @@ void test_static_linked(void)
>   		return;
>   
>   	skel->rodata->rovar1 = 1;
> -	skel->bss->static_var1 = 2;
> -	skel->bss->static_var11 = 3;
> +	skel->bss->test_static_linked1__static_var = 2;
> +	skel->bss->test_static_linked1__static_var1 = 3;
>   
>   	skel->rodata->rovar2 = 4;
> -	skel->bss->static_var2 = 5;
> -	skel->bss->static_var22 = 6;
> +	skel->bss->test_static_linked2__static_var = 5;
> +	skel->bss->test_static_linked2__static_var2 = 6;
>   
>   	err = test_static_linked__load(skel);
>   	if (!ASSERT_OK(err, "skel_load"))
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
> index ee49493dc125..43bf8ec8ae79 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
> @@ -9,8 +9,8 @@ __u32 map1_id = 0, map2_id = 0;
>   __u32 map1_accessed = 0, map2_accessed = 0;
>   __u64 map1_seqnum = 0, map2_seqnum1 = 0, map2_seqnum2 = 0;
>   
> -static volatile const __u32 print_len;
> -static volatile const __u32 ret1;
> +volatile const __u32 print_len = 0;
> +volatile const __u32 ret1 = 0;

I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think 
this is not in a static link test, right? The same for a few tests below.

>   
>   SEC("iter/bpf_map")
>   int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
> diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
> index c4a9bae96e75..71184af57749 100644
> --- a/tools/testing/selftests/bpf/progs/test_check_mtu.c
> +++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
> @@ -11,8 +11,8 @@
>   char _license[] SEC("license") = "GPL";
>   
>   /* Userspace will update with MTU it can see on device */
> -static volatile const int GLOBAL_USER_MTU;
> -static volatile const __u32 GLOBAL_USER_IFINDEX;
> +volatile const int GLOBAL_USER_MTU;
> +volatile const __u32 GLOBAL_USER_IFINDEX;
>   
>   /* BPF-prog will update these with MTU values it can see */
>   __u32 global_bpf_mtu_xdp = 0;
> diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> index 3c1e042962e6..e2a5acc4785c 100644
> --- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> +++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> @@ -39,8 +39,8 @@ char _license[] SEC("license") = "Dual BSD/GPL";
>   /**
>    * Destination port and IP used for UDP encapsulation.
>    */
> -static volatile const __be16 ENCAPSULATION_PORT;
> -static volatile const __be32 ENCAPSULATION_IP;
> +volatile const __be16 ENCAPSULATION_PORT;
> +volatile const __be32 ENCAPSULATION_IP;
>   
>   typedef struct {
>   	uint64_t processed_packets_total;
> diff --git a/tools/testing/selftests/bpf/progs/test_snprintf_single.c b/tools/testing/selftests/bpf/progs/test_snprintf_single.c
> index 402adaf344f9..6b63ba86b409 100644
> --- a/tools/testing/selftests/bpf/progs/test_snprintf_single.c
> +++ b/tools/testing/selftests/bpf/progs/test_snprintf_single.c
> @@ -5,7 +5,7 @@
>   #include <bpf/bpf_helpers.h>
>   
>   /* The format string is filled from the userspace such that loading fails */
> -static const char fmt[10];
> +const char fmt[10] = {};
>   
>   SEC("raw_tp/sys_enter")
>   int handler(const void *ctx)
> diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
> index a39eba9f5201..a1cc58b10c7c 100644
> --- a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
> +++ b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
> @@ -28,8 +28,8 @@ struct {
>   	__type(value, unsigned int);
>   } verdict_map SEC(".maps");
>   
> -static volatile bool test_sockmap; /* toggled by user-space */
> -static volatile bool test_ingress; /* toggled by user-space */
> +bool test_sockmap = false; /* toggled by user-space */
> +bool test_ingress = false; /* toggled by user-space */
>   
>   SEC("sk_skb/stream_parser")
>   int prog_stream_parser(struct __sk_buff *skb)
[...]
