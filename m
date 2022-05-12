Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76F852510F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 17:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355832AbiELPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 11:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241529AbiELPQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 11:16:51 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED123381AA;
        Thu, 12 May 2022 08:16:48 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CCLm0f013987;
        Thu, 12 May 2022 08:16:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Uq1HZPpHIUXgagpx3tkoZVcTDKLMfqJnHADbL1QSWE4=;
 b=Tw6waHZmyqbQYWNt2E0gjhc8q5nA05Oolfl4KaYlwKGA4dojDBMJ2Qe6Jo9UsF72ESZW
 cqqLTnz5UhTlgciH61+0Kjy5kCm0TYVm24sWuEzZJmC2mmLYBVNTI6xFZ+6GLAMs6C0w
 5za24h+EO9zT3DyYJ+Q5yXfUSjsHg+1DHF4= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g04tbb9a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 08:16:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UB9Bx3QO7qnNPymiIIQJgRtq9oU4lJvLqMhqh4oyd9EnYHQmJ4AH1UnipV0QEI//408vJc8uaYdRE+C2d9k7rtlZhIcX2n7fyLHe5kxaK5tLytbJxq+LrVf8CQFbRXNIaqrlqemlL7lEk7hFgPkIIgI5n90SxDhXutHTkXrJarpwOXbTUg2ejpkuQxnLVpJQ4hiWrg8kFlfDJIHNa9mT7X9PB6W+utEth5Gjt2//s4pn/HeeVPayxw3fFNk60Rlvsc5sOF1MeZW2vaoS1EX1o506DlT97Q11PQ6cnVFQJJZlLr7pLQ5XpD6rOk3poXHBbnT+oieL1BuCHvICzVa5Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uq1HZPpHIUXgagpx3tkoZVcTDKLMfqJnHADbL1QSWE4=;
 b=kVCyzu5mzoUG9R0lThY+TNlQuOXcFAyGdq0pDfprESiR3b1LdVFarOTa9nWb6M2pKFuhkwNRlQqEm7M+W7x3P701vJWDVIdUt7Y3CWTcUioqwKX1riCVKuDqncwUpeVQPISt67TLBjAmpKSTuoL3RUsTbWpQggwkltmpcw0yXoKAaeLnVizZnb57cP6leznjvTq+TJYOaWAv6MMzXN6zFJABoVmWums5DykPgqadlVZ480Y3bxOSDLUHsbTz6gpmM83a9LMDKhEWyqzhl4Qprn1Sb8hHAye6atcgMf/qIDhE27lGergJVK8Ya6YJtdasUsvMeF3lSs1l1tcEp5z8yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB3430.namprd15.prod.outlook.com (2603:10b6:a03:107::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 15:16:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 15:16:25 +0000
Message-ID: <bd3d4379-e4aa-79c7-85b8-cc930a04f267@fb.com>
Date:   Thu, 12 May 2022 08:16:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] kernel/bpf: change "char *" string form to "char []"
Content-Language: en-US
To:     liqiong <liqiong@nfschina.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, hukun@nfschina.com,
        qixu@nfschina.com, yuzhe@nfschina.com, renyu@nfschina.com
References: <20220512142814.26705-1-liqiong@nfschina.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220512142814.26705-1-liqiong@nfschina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0100.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::15) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 444ead33-ff97-4b84-66e2-08da342a612d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3430:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB34301901552B7F790D4EC4E6D3CB9@BYAPR15MB3430.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6f9UDbHy6ycqwgNIw69aOzeOnrSJybJTUpGiwBkF0UtIBhGprkzHNEPa2/Bg29u6MCAMeXcaBzGFikQBGxM+91sQEJSFKoD1AGpCxTpsIu3Aj5ZvJhHmPZaIU7ru2saqu8yupUiaPBmsQ61DjfPb2Tn2bTu3R1slUyAyXGCgxBJjyys2OpyreYEw2HhmQgXLHuokmRSIm9UWR6qyXuYjMj5boEe67/H98t8vpHn/Gqo5y/DFFJO5F8B/ZcK+Hs53MlF7+d3pAWMw89VsvtpCIMSpCpVLhdlN4jDonYtl67RwoURSLrwHF+rFecRC1/CqEI1f3EoMx3ZBNMxhY1T+aS4JUziXV18kBRPYnlkyvGRljcHc6lrom/yIdCz3qkrerfHUB/qlJDfkSQiA94fhl+CWNRV9QsTiygM9rRNPdBa73D15Jgtcs3jZP31t6YOVctjwlLydhAmKIwybTboXh6E3gN6CVSDXyQaEhcCNh4/UCU6SzzieE9AyRRRcXYhP2a5ByrOapAWoNmS/YT8ovpiGNrSFMqxywg9mx/leiK5n31VTsAHMvx6/hlpa7rvRvfnihoWgVxy6art1fPKeMypBBQRF5/83blqBMrQMUV6RfOqKBlQ+dHbKR8XCkNto91g7umHxyp8si/esIAhk4XtQgXjQ7dnp3xgEAWrmHOxndqvsjYVnI/3lbwy5aet5t35DYWG4cThBv+tilzC4wV68pcI3u/roopcpPuhGWc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(2616005)(110136005)(4326008)(6666004)(53546011)(66946007)(66556008)(31696002)(86362001)(66476007)(316002)(6506007)(52116002)(38100700002)(508600001)(6486002)(83380400001)(6512007)(186003)(7416002)(8936002)(5660300002)(31686004)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjZKNVBLR0EvMTZMZC8zTFBDUE5ya2M2d2huL0pmbXA4a05veGxLa2pKRFBs?=
 =?utf-8?B?cnZRbHF0d3BuWEZHclBNc05TQ1hROFVhMjZ4WlBPYkFEeE1aN0NoR3Q0L1dC?=
 =?utf-8?B?cFRSNU14V2VJUDVvMlcvZURpdlZtd2V1OWRYK1JsVTU2b1RYemNWdVJUQk4z?=
 =?utf-8?B?QlJ6OGVhelh4N2VLbUxQSjFNaUFDUktoWFJVc3RFdWI5a042SStBTVpiazRk?=
 =?utf-8?B?bDdtMzZaajJmWDhQcHd5bExSYmdvRlRBZi8rWWJibFRQV0MwVXQ3aUUzMjJ0?=
 =?utf-8?B?THFra0JEa05FaTlGWTBnVTU1dVczRHFlcTN2dlRINTFHVHIvZUZGdTh4cDNz?=
 =?utf-8?B?QnkwVmFXS2R1NXJ2ZExBSW9VeUtHOG8xdk9CQ0dITWJOb3dPTjZsQ1QzNTIy?=
 =?utf-8?B?SmRuSDJ5OC9ZN1VWb1dzUnV1RUxHVjdSZlA4djl6S3BlL2pTcC9vQUxpU0Zv?=
 =?utf-8?B?Q1dBNjh5Vktod0dGSmlZa1BkRWRHczdCakdlL3ZKZ2RpZzliekZZeDdoY1Ax?=
 =?utf-8?B?bVB5RVY4VkZCVmxFaGtBUXVBcVpuWjJSd2FxRU15RjFyL2pmNXpRcmxlZlZr?=
 =?utf-8?B?VTlMbFpsTkxIMFlrN2VLM2UxRlpNbGUvWnRJelYwOUJtbGJQK1VEUEZENm9S?=
 =?utf-8?B?NHFKRU0wZmZ1bzJlQkx6dmc2ZCtOTGp2ZVViendkWTFJZ0EwWXdXcC9xSjd5?=
 =?utf-8?B?Z1ZqWW5telVERXh3eXJ5cVdCdUxJaVk3dUpSK1Q1SytIdTBwa2IwZUtpVmxN?=
 =?utf-8?B?eStHdlk0d0xtQ3ZadkRjNFNwQXlBZHkxa2lWTmdnK1JGcVZmWmZCWHVyTy85?=
 =?utf-8?B?L2lpUERUV2kzR29wSjBpaTh2VUdXb1NvK08wWjB6SVFia3VXYlBxeDMxV1Qw?=
 =?utf-8?B?OGtGcjJQK1hwWlRHckdtOFk0Z2J1cmFYOUE5RnFoNXpQekVQaS9qUk1hSnFt?=
 =?utf-8?B?NHJYTjN3WVYyQ0JzVXFWR1NuRVN0dC9rcktnWHZjQUwwbkt4eGM1Smh3aWMr?=
 =?utf-8?B?cEJ2V2RqbVI4SndyR3dNTVRoMC9lZjdEM1kydWVPQ2k2bEV1dldsZmZOWjc4?=
 =?utf-8?B?UlJEaXZ1QWFKWTVJdDRBTnY4bDhVQVlvY2pJaEhxUmJxRGk5R3ZyeEQyaWdO?=
 =?utf-8?B?YVdIbkJUdVNmSDJUMnpyN1ZJM3VZMUpLaDRuTnNFTlFmZ3BlUmxERG5FTnVk?=
 =?utf-8?B?TWZvNFc0bUNrZGZ0S1MrTTI1OHN4WUhhT011RFhIMzNnU3Fna3dSUVBrMTd1?=
 =?utf-8?B?TzNCQ3pvaWl2Q0JzWEhOMnpLSFQweXhiL0xoK2hYVWpIUlR1Qno1aDJyS2ZY?=
 =?utf-8?B?aTNINlhuMlVid0hkamhzR3JTNSsxYnpaK2tNc1dYdDVLTzBXYzVNa29XM0Fp?=
 =?utf-8?B?OEh0OXBiQXlNcWN4RVdDOXErdU8wak1xQjZ6TEo5eitxMng4ZWMzV2VHODNt?=
 =?utf-8?B?SnVSL0JESE13RDRUQ1ZoT1A3b2R0Y05HVWEvNTZrVjg1S3JvYWx0dFY0Z3RN?=
 =?utf-8?B?WUZmOXpyYk5UWXpkVmNOb1FadURrYkpPS2doQWFOck5oM2dTdENKNnNYTGU1?=
 =?utf-8?B?eGhFdWxVR1Z0cFkrby9kZGdCRFFzd1RudXQ1R2dGRDlUdEdiRnpIOElQa0Q0?=
 =?utf-8?B?SzNFanU0YUo4M1ArRGYxQXBzc2cyYkRNT2hHZXZNeEw1WFJLVjB2WlhWeXIz?=
 =?utf-8?B?eCtVQis5MGpPcmp1ekl5TEcwdkhHUHNUdnRvWEs3YUl0eC8xcjBWSmZVckR5?=
 =?utf-8?B?eXliMVJNdHhVWTZxRzZJOTYwYjhjaCtwdEdTNWx3VjVuSXVtK2N1QUpiVWph?=
 =?utf-8?B?b1VzMjhRVmdBc3IvMytoTWVJYjczaFNub1Zlc2xrT0JOWGtPREkxNkdKMmVV?=
 =?utf-8?B?bkk4TFc1Qk8ra0hPdmxPZkFhY29ZS0U3ejk3TUhPeHRCZEg0NThDOHIyZVUr?=
 =?utf-8?B?aEFIQmtDMUFVc1RNRWFSRlorTGpZYms4RENoK09QTm9aVjR5MVVSZG9aaUJY?=
 =?utf-8?B?bjIvK0ZwMG1Xdmc5dnhnT29YRTMrRE5wclFkdzhCWW5UR3dzOGxWN3ZzMkp0?=
 =?utf-8?B?NXYwN05vNi9KY0FGK3dpelFzNzlxVlZZeE51WVBuN2pGeVNqVkJYaGc1cDVj?=
 =?utf-8?B?em9vR0FGZ0pZVGxLOFVzdGtLNzZ5d2RveWJaL0xSVHkvUkR5Q2dzczdpNTRT?=
 =?utf-8?B?ZFhHcDRWcm9wTUdwd2xlWlNMTmRyZVAyMjF6RHVtblNLejBwMmJ0OVZyV1h3?=
 =?utf-8?B?NU1BRStXelFRNHp2NmQxRXBiVDNHOWhsKytTUjJiS0EvU3QySllSdzFDMlpE?=
 =?utf-8?B?ckV6UEl4cnZuK1dmWTFYUTlyb3h6MGZka2wyOXB1NGNzaVlSSWxKUWZWcmdu?=
 =?utf-8?Q?wO+9iLsv1zcP9UV0=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 444ead33-ff97-4b84-66e2-08da342a612d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 15:16:25.2013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kiRHt5i4IfHCqmKCvVT3JtV6XHCsYMty4n4HkNyQCx3dop4EfeA/AdDupW7NShyA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3430
X-Proofpoint-GUID: -gXJYRRdqEAJ3gnR69m9QO4beZLtmMBz
X-Proofpoint-ORIG-GUID: -gXJYRRdqEAJ3gnR69m9QO4beZLtmMBz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_12,2022-05-12_01,2022-02-23_01
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/22 7:28 AM, liqiong wrote:
> The string form of "char []" declares a single variable. It is better
> than "char *" which creates two variables.

Could you explain in details about why it is better in generated codes?
It is not clear to me why your patch is better than the original code.

> 
> Signed-off-by: liqiong <liqiong@nfschina.com>
> ---
>   kernel/bpf/btf.c      | 4 ++--
>   kernel/bpf/verifier.c | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 0918a39279f6..218a8ac73644 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -894,10 +894,10 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
>   static const char *btf_show_name(struct btf_show *show)
>   {
>   	/* BTF_MAX_ITER array suffixes "[]" */
> -	const char *array_suffixes = "[][][][][][][][][][]";
> +	static const char array_suffixes[] = "[][][][][][][][][][]";
>   	const char *array_suffix = &array_suffixes[strlen(array_suffixes)];
>   	/* BTF_MAX_ITER pointer suffixes "*" */
> -	const char *ptr_suffixes = "**********";
> +	static const char ptr_suffixes[] = "**********";
>   	const char *ptr_suffix = &ptr_suffixes[strlen(ptr_suffixes)];
>   	const char *name = NULL, *prefix = "", *parens = "";
>   	const struct btf_member *m = show->state.member;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index d175b70067b3..78a090fcbc72 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7346,7 +7346,7 @@ static int sanitize_err(struct bpf_verifier_env *env,
>   			const struct bpf_reg_state *off_reg,
>   			const struct bpf_reg_state *dst_reg)
>   {
> -	static const char *err = "pointer arithmetic with it prohibited for !root";
> +	static const char err[] = "pointer arithmetic with it prohibited for !root";
>   	const char *op = BPF_OP(insn->code) == BPF_ADD ? "add" : "sub";
>   	u32 dst = insn->dst_reg, src = insn->src_reg;
>   
