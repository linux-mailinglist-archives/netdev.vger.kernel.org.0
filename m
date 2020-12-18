Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C0B2DDCDB
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 03:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732356AbgLRCNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 21:13:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54058 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732022AbgLRCNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 21:13:23 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BI2BeTk019914;
        Thu, 17 Dec 2020 18:12:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=K3krahpAi/beaWANuyRuJk1wpRvW5FaE1mh/2unRJMg=;
 b=VPe+GeZD2yfHTkgixdbp1flN+PRkwFVd7bdwCBRRyirM0aXkedkVtxI6mchNLx0F+/kQ
 5n4JHs6Zxy0/qxuWo1XJZCyeO3f+bgKLv6DzHxGFvnSDlL28WWBYlT2br4/9PZSVOlRN
 5SaqH5dU4xu5duV9UdNkEmuszACBYNPQkms= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35g83xkrg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Dec 2020 18:12:18 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Dec 2020 18:12:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdPh2sT8sur6gE9LdekadyuqSSISI93EVeSqMoaaWKh51oRgVZovRfYAmVaMb2bCpaZOqVWgZJOdIN7o/X8nA0+gZ4apxUAP5uTXRJxyzJPREb7qXJRTtKPF1S28TY7wXvLk8T06uVqbXXZPaCT/v270ym7SsmETFBHFFtNKJ2zQ80fJ12VQ2oArF9xM2x2H7oWA5/wl6aGmyFDc0dYaSAhnonnUIYn0arc1dOf7vzu6VpOUS423aEFpV4ZY78oIpLaRqHVe8Pyv5um1jKJeDwNsRPHNwzMh4c5rxFzpGinASYFdaGAF+LTmOmy14bbF1uhrQLGvmwZs09YSDkOakg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1/J138vR4gXGKCdVDxwhN/xEoCuJx++OYI+aJ10qdA=;
 b=hvHClnYBlDvVUzad1lJx8PseAjpJm47v0EbpVS+C6ZKHlcWBnpsN6XUqgWZdYOkoOb0e5GTKb5ya20PWjKMDNGVtVL/IX1mBa3VmBNjPCFhXurIA8U0Wm75xvx7aqROWJPlD6YQiclyp5b82BHAfdURuk4nMvHQCtlOKRoJwILhGNprIWSo8ZWyC46ZyZbQa4pBdOdhu447KtjqX+dQzXleHRqIApsiyXspXrsMh9OTLB1i2q35/DRjyoAN7g6oK8Z3ICJlrJzqHuGtekngtonAjJ3rDGoHFrgeX4FeDvZTK+zRKgc/O7VYSeVUAes7YGSfX8nsoRo3jG/kWbdCFrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1/J138vR4gXGKCdVDxwhN/xEoCuJx++OYI+aJ10qdA=;
 b=XgT4xgbFeNMAXNKXeFm7hy2UbbX786nRirZwGAzErI23gA+FiQ17op0tRkKaIxf7Qiee8XFuSe16pf3nVYoZfmoEgIzpkQ7KY3UOfYUJ0q4Je9EgdxAOS6XXlQoTQSDlJMVBPjgl26sQxooMnsgL8YEg08v4coojXmxR03Ov7OM=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2695.namprd15.prod.outlook.com (2603:10b6:a03:150::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 18 Dec
 2020 02:12:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 02:12:15 +0000
Subject: Re: [PATCH] btf: support ints larger than 128 bits
To:     Sean Young <sean@mess.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <linux-doc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
References: <20201217150102.GA13532@gofer.mess.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1e9594be-c21d-88d2-e3bf-0b8e3e991aa1@fb.com>
Date:   Thu, 17 Dec 2020 18:12:11 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201217150102.GA13532@gofer.mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:4f3]
X-ClientProxiedBy: MW4PR03CA0366.namprd03.prod.outlook.com
 (2603:10b6:303:114::11) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::12e6] (2620:10d:c090:400::5:4f3) by MW4PR03CA0366.namprd03.prod.outlook.com (2603:10b6:303:114::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13 via Frontend Transport; Fri, 18 Dec 2020 02:12:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fcc9734-4427-4a9f-4c79-08d8a2fa5707
X-MS-TrafficTypeDiagnostic: BYAPR15MB2695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26950A0295891BD1C2435D39D3C30@BYAPR15MB2695.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 45QjXk+uCFi6PwpGXsiu59rxYHIc87Jg1QCO+ULj11ytRmw0QnvNZ/mbLThea+GXhK0S7HZKl+BMl3nrIJMfeM1874YCyGQNkYh9FoKMtXyWeUTzBfbwBJnY25PMgzPMfLf0dtZqhRvxs6oPwahniaXiCZ6tFj9SGX/UoMFcCu9oVcQHdhv62RfZhZMNbZH9BbobOct9AqUngbCAWdVhMgtju9FT3sl0A6g6eC5pMI6bu3F6qM33DnFK/JRIzruoLU/pAkwFZxWgddtc3bN4YSmLhSmWi0rawqTLsMc42RNGPVli8PWz/nurUIyO4rVSfkhgWzxcWZPAHJ1R1PQDKxN5kDM/SB1dKT3V5fwFtMGJ4oI5Hs34izpUy14/vNQRMjfnBxTzkX30aGGdN2yPGkq0TbqVbhR9Iz0Rdxi+vv0N1MJY3Exb2p5lTcC/i+zkBTD96pFq6o2HaL/Ui9Njesy+cNMv7l/l2OP4kSvn6OuAEKb6ZcPtwZttr2JXjjXm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(376002)(366004)(136003)(66476007)(8936002)(478600001)(8676002)(31686004)(16526019)(6486002)(186003)(66556008)(966005)(2906002)(31696002)(110136005)(36756003)(5660300002)(86362001)(921005)(2616005)(53546011)(52116002)(7416002)(66946007)(6666004)(316002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NGpiTnZmWC9pUGRZN2NZeDFEclJQS00xMm1lR3N1b2ZpaGt0WU1kSm1aeSt1?=
 =?utf-8?B?QmVLdEpOZGtlUTBHdVRueEljMG5xaXFUdDhycEVGSkgrME05WW52QnVoRWdx?=
 =?utf-8?B?YmJsMXhmNUttSCtuZE5SM2J1Zm11NFdRN1VwREZuWXZ6a2FJWFdQenArem55?=
 =?utf-8?B?OUt3aGI5a3JDbXJjUUM5NUw3YzlTVjVIUnpiek9KTTdxR0tMdGNyNklGcDNV?=
 =?utf-8?B?a2dJOVhacXNTNlU0NjJjejNoR2YxSUZKQkxtRm42Y0NkZ3FoTWp4SGxsZzdn?=
 =?utf-8?B?ZGVsaDMzS3IrM2MxSFMzYm5sckRoWUhsc1pBeHYrUnlseFkySXNwYkVlY216?=
 =?utf-8?B?MUpkWVZlU2tmQ1BmbEJSNjdjR1BBTFRxTm14dFBBMXN6VnpTdGxHdkx2WTVB?=
 =?utf-8?B?Z0dtbG5rOHJsZzMrL1J4RlpicXM5endrQVdyd3Q4QUVmRjkvZ1N6MDFNZjBy?=
 =?utf-8?B?RVBTT2Zhd0l3R21heHpTTDBlYVpMUFJvWVBwNHpLNEJKM2hHY3JNL1NURFhG?=
 =?utf-8?B?RlNnSmdmSDlLdGdDTWRZZUtEanJiQWhXb1pDeExIYUxkMElMS1VraGxNRW5i?=
 =?utf-8?B?Q0ZTWUNlRkNmV0ZwS2FVRFNBWFN3TUlDSjNnYllLNU5ITUZlUzlUeHhDTmRU?=
 =?utf-8?B?amZ6NmF4NkNFYWd6WmwyMEFuclFjRC9vNngySXM4SmhKcjJDc3NUN3AxT3pr?=
 =?utf-8?B?RHNsemMwaERzU3RaMHhuNUdQWnZ3bXovcmlObldZckV4U1FsMmZLenlIUnBj?=
 =?utf-8?B?bnEzV0p3aFRranlaTVJ1blEwMGR1TWdEZmttS2NrcTJwNzBzZFkwb3BMRVZn?=
 =?utf-8?B?WVQ2N3NhbWx5RzdLN3NlNXgyVjFPMFZNOHlnTnFXVERNZHRZUXhQQ2NNM2hL?=
 =?utf-8?B?eVVkVGhmYjZZWlJHZWF0UTRWVWptNVdKSjE2NlB5OXYzbHN1UXdwMXUxbFZk?=
 =?utf-8?B?NVgwZEhSOG1veTdSNGRObU0zRnVraWlFeGRWVCtnRjdYbVMxUFhBaW1XT2Za?=
 =?utf-8?B?UFhiWWYrcVUwZ0Vic2Nhc3E2a1NxRXVsWG9IYU92b0sxVXZSWkkycTdja01J?=
 =?utf-8?B?UFhDQk5uOGJZYlNPZ21hUC9rZG42U0xDTlorbzJ6aGNRYUNuWGpjNTZhNmVj?=
 =?utf-8?B?N2tMZy8wQ0kxNU1kVHBaTUtuM1RnTlhBVFl1RTB3bmtvN2hTbGNSR0xGV0xx?=
 =?utf-8?B?cElNL0p6QlE1WVZrcVlZMjlXdE5STnBlN2dxZzRSU2RVZ3paajJuMWxyWlFV?=
 =?utf-8?B?UElSUWVJZ0gwN2pCMlpXWEZ4RHB1WU5xZXJpR001SDZQZytZcDFQUTh2a1lz?=
 =?utf-8?B?RkpXSEkvN1Fad01TM1BmL1pPaUQyUDlkbEJCTTJxWGFvd1c2a0hWdEE3ZC9O?=
 =?utf-8?B?eldkTnZvaUp4MUE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 02:12:15.7075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fcc9734-4427-4a9f-4c79-08d8a2fa5707
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tU2sY+6pYoC8LfblWfl50uuFt+RPAoPS0M/kQQBjNHxHmdK5F0Qdq54vu8jbz4R3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2695
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_17:2020-12-17,2020-12-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1011 adultscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180013
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/20 7:01 AM, Sean Young wrote:
> clang supports arbitrary length ints using the _ExtInt extension. This
> can be useful to hold very large values, e.g. 256 bit or 512 bit types.
> 
> Larger types (e.g. 1024 bits) are possible but I am unaware of a use
> case for these.
> 
> This requires the _ExtInt extension to enabled for BPF in clang, which
> is under review.
> 
> Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
> Link: https://reviews.llvm.org/D93103
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>   Documentation/bpf/btf.rst      |  4 ++--
>   include/uapi/linux/btf.h       |  2 +-
>   tools/bpf/bpftool/btf_dumper.c | 39 ++++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/btf.h |  2 +-
>   4 files changed, 43 insertions(+), 4 deletions(-)

Thanks for the patch. But the change is not enough and no tests in the 
patch set.

For example, in kernel/bpf/btf.c, we BITS_PER_U128 to guard in various 
places where the number of integer bits must be <= 128 bits which is
what we supported now. In function btf_type_int_is_regular(), # of int
bits larger than 128 considered false. The extint like 256/512bits 
should be also regular int.

extint permits non-power-of-2 bits (e.g., 192bits), to support them
may not be necessary and this is not your use case. what do you think?

lib/bpf/btf.c btf__and_int() function also has the following check,

         /* byte_sz must be power of 2 */
         if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 16)
                 return -EINVAL;

So Extint 256 bits will fail here.

Please do add some selftests tools/testing/selftests/bpf
directories:
    - to ensure btf with newly supported int types loaded successfully
      in kernel
    - to ensure bpftool map [pretty] print working fine with new types
    - to ensure kernel map pretty print works fine
      (tests at tools/testing/selftests/bpf/prog_tests/btf.c)
    - to ensure btf manipulation APIs works with new types.

> 
> diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
> index 44dc789de2b4..784f1743dbc7 100644
> --- a/Documentation/bpf/btf.rst
> +++ b/Documentation/bpf/btf.rst
> @@ -132,7 +132,7 @@ The following sections detail encoding of each kind.
>   
>     #define BTF_INT_ENCODING(VAL)   (((VAL) & 0x0f000000) >> 24)
>     #define BTF_INT_OFFSET(VAL)     (((VAL) & 0x00ff0000) >> 16)
> -  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000000ff)
> +  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000003ff)
>   
>   The ``BTF_INT_ENCODING`` has the following attributes::
>   
> @@ -147,7 +147,7 @@ pretty print. At most one encoding can be specified for the int type.
>   The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
>   type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
>   The ``btf_type.size * 8`` must be equal to or greater than ``BTF_INT_BITS()``
> -for the type. The maximum value of ``BTF_INT_BITS()`` is 128.
> +for the type. The maximum value of ``BTF_INT_BITS()`` is 512.
>   
>   The ``BTF_INT_OFFSET()`` specifies the starting bit offset to calculate values
>   for this int. For example, a bitfield struct member has:
> diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
> index 5a667107ad2c..1696fd02b302 100644
> --- a/include/uapi/linux/btf.h
> +++ b/include/uapi/linux/btf.h
> @@ -84,7 +84,7 @@ struct btf_type {
>    */
>   #define BTF_INT_ENCODING(VAL)	(((VAL) & 0x0f000000) >> 24)
>   #define BTF_INT_OFFSET(VAL)	(((VAL) & 0x00ff0000) >> 16)
> -#define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
> +#define BTF_INT_BITS(VAL)	((VAL)  & 0x000003ff)
>   
>   /* Attributes stored in the BTF_INT_ENCODING */
>   #define BTF_INT_SIGNED	(1 << 0)
> diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> index 0e9310727281..45ed45ea9962 100644
> --- a/tools/bpf/bpftool/btf_dumper.c
> +++ b/tools/bpf/bpftool/btf_dumper.c
> @@ -271,6 +271,40 @@ static void btf_int128_print(json_writer_t *jw, const void *data,
>   	}
>   }
>   
> +static void btf_bigint_print(json_writer_t *jw, const void *data, int nr_bits,
> +			     bool is_plain_text)
> +{
> +	char buf[nr_bits / 4 + 1];
> +	bool first = true;
> +	int i;
> +
> +#ifdef __BIG_ENDIAN_BITFIELD
> +	for (i = 0; i < nr_bits / 64; i++) {
> +#else
> +	for (i = nr_bits / 64 - 1; i >= 0; i++) {
> +#endif
> +		__u64 v = ((__u64 *)data)[i];
> +
> +		if (first) {
> +			if (!v)
> +				continue;
> +
> +			snprintf(buf, sizeof(buf), "%llx", v);
> +
> +			first = false;
> +		} else {
> +			size_t off = strlen(buf);
> +
> +			snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
> +		}
> +	}
> +
> +	if (is_plain_text)
> +		jsonw_printf(jw, "0x%s", buf);
> +	else
> +		jsonw_printf(jw, "\"0x%s\"", buf);
> +}
> +
>   static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
>   			     __u16 right_shift_bits)
>   {
> @@ -373,6 +407,11 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
>   		return 0;
>   	}
>   
> +	if (nr_bits > 128) {
> +		btf_bigint_print(jw, data, nr_bits, is_plain_text);
> +		return 0;
> +	}
> +
>   	if (nr_bits == 128) {
>   		btf_int128_print(jw, data, is_plain_text);
>   		return 0;
[...]
