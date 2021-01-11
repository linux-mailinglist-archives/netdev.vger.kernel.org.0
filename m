Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43ABD2F1DB4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390269AbhAKSOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:14:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50028 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389860AbhAKSOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 13:14:41 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BI33rs021223;
        Mon, 11 Jan 2021 10:13:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=5d/drFyavJinxTkwg3IDFfe9G42Sfz2BhZ4cA/oGBYk=;
 b=VDvjZlARdSGQ7qKq0vTvX4KtsdxbPqVE10HD/0gDSvxsvf9hHy+49NtyzdZsffa9k6EL
 wCQmsKDDe4qDf6D7IBM2/UCN+gJvjaWXOrE8LkiVWgOjl93cJwI42r8UwuQFNNmpPbLL
 FUUFl3KO3oKy8YtxbRcotTWxCPwo9S33JOw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw8760wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 10:13:45 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 10:13:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHJh4q4GRaPy4xH0K3FtHXZADHbjGj2LhAhHk9JuqzqXp+qj7uuCeAyXQ3RCQxa4VW/+4HFzl5hBKt5Zfr4gCgZI1YGyYr1pW+P8RAtnA4kKbdeMIuOtqplc2v4XVnaceG7iph6DidOkpw4v9n6TbdzXJ7umuYEVbE66dO/WJqzue6X4YYptndrGyYhVlJvM+R602z4MPqq8Fx2KmsjZCoExSBusbBwXBKGvQnyi9agaBtJ2eSZ5TqS98zkZZOxXc049ee5uqQONKz3BCfFA/1ShlGknA9QgzZn791hDOWCIkhQc80KaF3jrBqHGbArBnG7UbYsB0BBzKTsGnH9ZDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5d/drFyavJinxTkwg3IDFfe9G42Sfz2BhZ4cA/oGBYk=;
 b=gSgqYT/21is4hSUxkNFukCzgcot5slXBgczm8RuJ56ttFWCgU+AIMrbTWNpQAbsCU3OCa4xa9NpQRgz4DR2uuZc+IRK6I+Jk95F5jIxY9/8bkS6CLBGPF2wGhbb1fcGTRaLPu3XdlxANuIhtYEOlpcQoas/Q0sRB85fR2qJsDujY2Bu/Lspr+gdPWLnicvxbigHZlVPeRR20usv50m0laecqMz6PEgfXkXNLTEozQZlCrqoUGGDMpot2QxxvOI2CUq2tJbEy4FYII2MDH/WV5bD6o9NW7Fmax7/0xoHxN3/SU2zgyUvitHImfYsz5CGchAlUNuXZpbHmg8FKnK5ojQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5d/drFyavJinxTkwg3IDFfe9G42Sfz2BhZ4cA/oGBYk=;
 b=dOqdlL+oVIJDupnNw8wLKB0DMdakt4vwkIs40cM4ok4Q3zqodY81TRu5kRpU6FZ4HOc8rB6+0yv1TrSrjCtAn/RX2qd/XeAiol6M5KB52/A0v1f1fxOxcqAqRinD3dM0fQgI3Tim8dx+Y2MGqSDqTXErn/jgWUNhr04OkoJC55s=
Authentication-Results: kode54.net; dkim=none (message not signed)
 header.d=none;kode54.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2262.namprd15.prod.outlook.com (2603:10b6:a02:8c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 18:13:39 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 18:13:39 +0000
Subject: Re: [PATCH bpf 2/2] libbpf: allow loading empty BTFs
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>,
        Christopher William Snowhill <chris@kode54.net>
References: <20210110070341.1380086-1-andrii@kernel.org>
 <20210110070341.1380086-2-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e621981d-5c3d-6d92-871b-a98520778363@fb.com>
Date:   Mon, 11 Jan 2021 10:13:36 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210110070341.1380086-2-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: CO2PR18CA0044.namprd18.prod.outlook.com
 (2603:10b6:104:2::12) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by CO2PR18CA0044.namprd18.prod.outlook.com (2603:10b6:104:2::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 18:13:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df486b4f-c7c2-433c-e472-08d8b65c9ef1
X-MS-TrafficTypeDiagnostic: BYAPR15MB2262:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2262AE2CC2DE50DF103250E2D3AB0@BYAPR15MB2262.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CX44+YGY4cVZcoEWHOyeWqn2+V0X8ABYMI7AkdRbi+i9/NYPOz0Z93K8ReuC94NtShapjXlWFPE5ZgRsF2V+IKW/DE0PMvMk9HtFSYzqaHHhiCGxBxCE9+L3baS9nJLr7WHQrYx31JQnpD+Rpz4AYb2Yi+A7QHVxucyEAWuijH0eOYcMLaw0zdZJmskoEs0JO5eTsN5KpvMUHbkDYcCoSnUTdRzP7Ohp4bSX/ociorskxffP2D2b7zlOe4ZoEAJiqVzVOsKpa0IeKjdgsEbuyI4U3K91b+P5Gdu+8HYRHop74ovPBkqBKyl11sDkx0sHUuyluclVKn9wHu1QVt2YDNqkKsqMkIc8zVIIWuZEaXXWDFzaEU+totQfrcFUXMo19vx0T1HkFKDlxWnQE4mgPg8NFG/OjB9bOxddwRuZSbtlbzqK7AhB5wld/giFqa+9nBGQUWgHqjVGmgEtnL/iIzOmUUViAWB2z5aybMXJ1Js=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(136003)(346002)(8676002)(66476007)(66556008)(31686004)(31696002)(86362001)(316002)(36756003)(6486002)(52116002)(4326008)(5660300002)(66946007)(8936002)(16526019)(478600001)(186003)(2616005)(2906002)(53546011)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c0NaMURLN0lxSjd4U1U0c0xYeXRjM1dvRjNHR1BDVnJIdmM5OWp1MTlwamFG?=
 =?utf-8?B?Y1NqeDBHNm9KY1g5VFEzMnFvQi9MbTZGSWdVNFh5TDc2dG92MTRMbEJuUjU2?=
 =?utf-8?B?eFY2cDRtTVJsWCtHZkZZM0hPeGFVYTlXaUpyaVNldkRRd0J0V1krdWpMU0pH?=
 =?utf-8?B?VHQyRi9nYVQzMkd2dVNTUzdsQ1dSYUk3K0FjYmZoRkNyc3l5UXorTjNmdElY?=
 =?utf-8?B?TFUza3J3M2ZFVG5PdHBuTnVhYjFFUVlZTkdNdy9PcXFVeVJaNFBxdDk5NDlq?=
 =?utf-8?B?NTloV0xJbGpNRFdvc1cyV0EzNDU3Rmx1Zm9TWkxzNEtVMEhnVkV3VU03ZFFj?=
 =?utf-8?B?T09QVWZpcy9uaHAwU3h6TThOTW9Fc0hRVlhSVXBsT0IxQ2dXZ1Y5a01YanVy?=
 =?utf-8?B?b1NVSDZyMVdmUEhwc1VjdHpYcGxhcHFWVXhKSkFVMEQzeFZ0ZHVYODBxTnA5?=
 =?utf-8?B?SGV4b2tJdjVDQ2l3cXE3RkF0UjVYQWxSTENoOXdyV0owVWd5WGowZml4YVp4?=
 =?utf-8?B?TG8wMzFTREVuOFEwQVh6VUgxelJTOUg1S1dPMHNJUWVMYUFlTUU1QVBld2NY?=
 =?utf-8?B?bDJJWTV2NUVFdlJYcUNvSS94T1RNVm9jWGNwR2I2NXE0aVdZUWs2VEJIbVp2?=
 =?utf-8?B?SFlNQ0sreDY4SEdGSVdIZWVBZWtHT2pEcVBvRE5kZ1ZlSGFheGwvc1NSSzBB?=
 =?utf-8?B?YUM2UUNpcVlyMFB4dWorcTl0czg0TWRNV0hnQ3pHQk4xaGdIQTNTb1NXcVBR?=
 =?utf-8?B?ZWkyQ2RKNjJZdldsRVBEVXdoNHFpb3JoTEs5Z0diak5tNk04bUY0ZXlZL1VB?=
 =?utf-8?B?L1dTL3pWaTZpdkZEQ1ZJK3pnem1BL2xSZ0ZGZExrSEtIT1VZemo1Qk03VkRo?=
 =?utf-8?B?NFFWK1BlZU5EY25NK2RLM0Y0QXRNZi92S0l0VWs1WGRWR3dyWXlwNmhtb0w2?=
 =?utf-8?B?UzhCSm5Mb0JNUkNvbnFRMXNQSVpqd2VNYWR4am5TZkhSRlBvaWFKN2Z3WkFJ?=
 =?utf-8?B?ZE5WdXVqTE55RG05THU3YUovM01tQ1FyVlJHclNjZERNSEl5YkZsVjd4RDJ1?=
 =?utf-8?B?YmhYa1lQYzJRU3ViTGZhQlRhK1ZIeTlDbjVCT2pWRVIvc2s4cFE0ckFwWlNU?=
 =?utf-8?B?OFBEMzZYY0RqMnc3WENHRkxzNHZFVU9zZVBlSmdEdlRmWVF0Ky9hdjJmN3dW?=
 =?utf-8?B?MnREdDkwSDgwMS9SYzNYZ1ErTUtUdUxTMTZVM0tDNmVHUGZIWTBRUGJETW11?=
 =?utf-8?B?UG1icStRb3Iwd0hTYm9DT05FQnExeFU0SjludUZ2Sk9jdnlmWEIvVWJSVXBy?=
 =?utf-8?B?VUsza1lFQlR0dGhjYTJIUG1XWWlCc052QUxEL0wyS3UvV0tRWGhLUWplcTBy?=
 =?utf-8?B?S0lITGJqV3cwdWc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 18:13:39.1934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: df486b4f-c7c2-433c-e472-08d8b65c9ef1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cVmZHSQ75yTX2cCqLPuQHXTCFrJhbXNDQPzp824duaXIpGPrY4k1h1kgxQWvRWw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2262
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_29:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/9/21 11:03 PM, Andrii Nakryiko wrote:
> Empty BTFs do come up (e.g., simple kernel modules with no new types and
> strings, compared to the vmlinux BTF) and there is nothing technically wrong
> with them. So remove unnecessary check preventing loading empty BTFs.
> 
> Reported-by: Christopher William Snowhill <chris@kode54.net>
> Fixes: ("d8123624506c libbpf: Fix BTF data layout checks and allow empty BTF")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>   tools/lib/bpf/btf.c | 5 -----
>   1 file changed, 5 deletions(-)
> 
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 3c3f2bc6c652..9970a288dda5 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -240,11 +240,6 @@ static int btf_parse_hdr(struct btf *btf)
>   	}
>   
>   	meta_left = btf->raw_size - sizeof(*hdr);
> -	if (!meta_left) {
> -		pr_debug("BTF has no data\n");
> -		return -EINVAL;
> -	}

Previous kernel patch allows empty btf only if that btf is module (not 
base/vmlinux) btf. Here it seems we allow any empty non-module btf to be 
loaded into the kernel. In such cases, loading may fail? Maybe we should
detect such cases in libbpf and error out instead of going to kernel and
get error back?

> -
>   	if (meta_left < hdr->str_off + hdr->str_len) {
>   		pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
>   		return -EINVAL;
> 
