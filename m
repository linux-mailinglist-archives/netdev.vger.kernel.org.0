Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6270C2E7BED
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 19:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgL3SW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 13:22:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726261AbgL3SW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 13:22:27 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BUIB0SU005254;
        Wed, 30 Dec 2020 10:21:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JK25vE9pAd6NpVCpcVrl1oXMSYSsMYoslS4FQzsGxFA=;
 b=BgMpq8HZIHzEaQrMczu5JiezB71b+UlkY7n5Axe7G3ieGgA8xdNcwZeQ08AFcwYc5L3w
 AW33S5tbPzUq6uTLjniqraaBXGN45YUba7PMeUARg/gIUn1j2SjOsgQc3wjD1pISUDXd
 vlJNBn7y5mGikg1UGbBG1dQlqAbLZWdZgqE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35rr9e1pmd-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Dec 2020 10:21:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Dec 2020 10:21:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B846dAnA+g2HYn3/TSSs1ucnWMmIOHVlyz10kE4KGXeeF6t/i1vJVWaEpHkAKO5lVsctAB60NrDuycUfyz1mS+2DFsZfMO4qSEy5Tgo13csVSaWjgMau2Vni9lT7TBUFf1aEbe9WaNql0TT7ogTypfMlJsd8+MVaGX039qoTOQnxyMkQMJvWYxPvC/+j0nlWU3ny04nhlHMQFX09XxpXzvrB03P2IvYsikq7ubnhL1RvPkOSYVvt89/fHg1qDr/tOkRkG0ZZCAXLuKZELRkLx36YGHA+Nrba7yLALRQYyspnl9mSjE89+Z6F7/vbOEZWPphqbzhrUc59aBN3TICiQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rr1p/uUWNrvQnWQmcePfalTBjq2BYxUcqtTYQCe/MEY=;
 b=TSyW/txED8paiYQzbKYZegqtdyv/qQr70e68/UFPInmx8ZAcwPJfNJf2wH4uXhN3NbST6lrRiX6mf3BDzpJte4jtOvxGVqK8LvSpBcngaMrjIco7EvQPok4Pb7VmBcAY/WOhswHmLh6yBbykxESsbZOEfNxdJ7y54fb44nU6W/UWVyjPUcxYnFE1l1y5koxO7o+xm/oKSiXbxZhx4SY7rnNPA4FhLWzZIZu2ZFrEJ8+4kI4V76bPhWU9IsiXQWZ4JksoP9n44ajc2eRzWUlC4RV2t79DsKIhUJwBE8SImf9sLhcK7rxoG8wv3e/8tVRgzzWxcxhWDsRamdn2NdTeuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rr1p/uUWNrvQnWQmcePfalTBjq2BYxUcqtTYQCe/MEY=;
 b=Yb32P+Yf8ZgxGOWT+x/ghS9hi0pHXes9wMzzcvq98IwgE0NJe2akArnqTvOmWkuMVns0qrstLoGxk5bCQAOLosagkhwwDkAifX3jy9YF6VN9vcicdzWLCUeI7rf8FvpLla3DqwC7UUZ7FtLH/wCnxQ6oK4WhWFx/qg+uSeyBqC0=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.28; Wed, 30 Dec
 2020 18:21:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3700.031; Wed, 30 Dec 2020
 18:21:13 +0000
Subject: Re: [PATCH v2] btf: support ints larger than 128 bits
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
References: <20201219163652.GA22049@gofer.mess.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <bf26fcc9-a2b5-9d6f-a2ac-e39a0b14d838@fb.com>
Date:   Wed, 30 Dec 2020 10:21:09 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20201219163652.GA22049@gofer.mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:c584]
X-ClientProxiedBy: MWHPR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:300:13d::15) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1231] (2620:10d:c090:400::5:c584) by MWHPR20CA0005.namprd20.prod.outlook.com (2603:10b6:300:13d::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 30 Dec 2020 18:21:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcd5f195-167c-41be-d7a5-08d8acefb09b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2821BDB299442CB1E61A2E4BD3D70@BYAPR15MB2821.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:117;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wOsKvCGoYQMAW9VtcZEsjo3/Xn3/XRZ/NeXC/d1RE/KJ7POelCUTR7gYaYlqXNafHqzH1o9dwzSVWBQxl3eR0lIhHDcEjzChshSNpLF97tbi/gETzvCAGS8Vcl6X8ordujJBavuOwalqZB4BZH8OfbJYWDGXFOBnQilrxbM2PM/k175dM72Nuz+rv3GjT2l9f6wiCJ3BO5Cgkd1Irz08mlQYPTzE4lJSkFOO81s7Oo6ek5lwBzicWAP61tZ7WnPeZ8exxcCmXSx54MEgFB4J0OuTriqd6g4NmFrZxC1Pw/9rEaeZB9XwvR8LFcSUzG/6Xzfw1iUdWLRMv7xvO1vMBPmCR1eZ4i5PVsZZrvvgw9fPlFtGkE5cIIgri/XydPrcckNFFDo+Iros7Ybfkw8hwIttY2KI25us+e+Cpw4SejvMb+/ZqiKMxekgEMWfsgxstC4rE2bBZuE+Lhvea4rUxYf1qyXX+EoJw7FP21CS5c188mKhIlMjF6VsjBvRvtFvFCFJ6LmMeHS2O3YYxBc0yj4PaeQZMprg4QVG75SQMKOzC86KOWRd+NEF86xNX57P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(346002)(376002)(366004)(110136005)(7416002)(86362001)(316002)(30864003)(186003)(2616005)(83380400001)(5660300002)(8676002)(2906002)(31686004)(52116002)(31696002)(66946007)(8936002)(66476007)(6486002)(66556008)(53546011)(966005)(478600001)(921005)(16526019)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MmkrSzNBYnAzNm9zeURZR0NmMW5wT3RPSjJXZVpneVYrZml0S1NpdDZLOURG?=
 =?utf-8?B?ZnNwTXVOZGQ4TzVHQlQ2Yy80T2R6NnFVWGlsdEtlRlF2a29iYjhRZUNHT1Z3?=
 =?utf-8?B?TUJFL0FXY3JBUjBXWEVkL0lNM3l4bDhwOVJEY29HM21kbUNwS0NGekQ1Q3Z4?=
 =?utf-8?B?SVVZRGhWa25POXFTMzFYcmo0T3d0Yk5UNHpBdXFLWGVEVVp4by9mK1Z5WExl?=
 =?utf-8?B?RHdzT3JPTWQwcTc0TFpUZGExZUJRKzJrL0xyTmhMN0dpOXRDdjhmQlBxYk1i?=
 =?utf-8?B?dzE3bHZJcHVLMlRHMDhoV094am9uSllqSWFheFBPVWhNU2NwT2VscGhoS2hp?=
 =?utf-8?B?ano5Zm5FbnkrZzZKMG1TbGxyKzFqdld4MGNUZnhmTHdBb0RqTUdNdkp0RFJy?=
 =?utf-8?B?M3Ird2JkeXZCM1IxYUN3WEJ3U25WdHppd2ZqVnlEVnVpNTczZnZWZWFZUXR6?=
 =?utf-8?B?NW5uRjRaU3MrRWU4eTdHWU9GU2l3QnM4RUFBNG4rTGZMemlpQ1JxVk5oVnJq?=
 =?utf-8?B?em1mRVRQRmZ5VzZudktUbFhmTHBiZUFCNmt3RWswME5EZVhRZWxBOFhVU3dh?=
 =?utf-8?B?c1lLMTNDeHg1ZjB1WE9SMkI5U0hwSDRNQVdwM2JwbXFZQjFVVm5vS1NzR3FU?=
 =?utf-8?B?VW1mSk1zaGlhVFpCSy9JUzJCalRqMmN6K05yczZlUkVuSGZRdFI4d2VsUzdJ?=
 =?utf-8?B?Y0NobHVYTnBES21ZVjh1VndiOFJtcmFLNVVFL2VyZmRPb2VNVHJNcFo3eVlD?=
 =?utf-8?B?Z2k1VEhrSWJUTW1QUllCVVJQZVJHT1BmL3dHZjJSZlNBSHh0eXZxQmJ0c21T?=
 =?utf-8?B?aUc5TThsdEVVNjJ1eVI3OUF1VER0cGFhNXdZYXdNMVFhTEpXNmd0c3FpWi9p?=
 =?utf-8?B?WVBjOEIvYWszNlpVSllkdWtjMU1TQTg0T2Jkd3lmVmJBSG53cHR1Y1lWaUR1?=
 =?utf-8?B?N0ZNZGczQ2FWRm1JYlVrTlNoaGF3ZDl5MUpsNE5IOGk2N3RSKzl0bzZJbVF3?=
 =?utf-8?B?b2krMXJ2TUk4Nm1nUnk1MU9rdUJUZnN6dENhNnM3OE1VNW9UdWxKOWpZV1FF?=
 =?utf-8?B?Vkh6aER4SEttclY4L095SXE5NHVNQ3ZjbnhGNmN0WlpLMFBGVXAzckFhK3N5?=
 =?utf-8?B?TlRiZGk3T1FVeCtScHA1UFRUUWRqRWIwajEyTTdkbS9TY2J0WjYvMDNEeC82?=
 =?utf-8?B?M21tYWtmRlRwWjBoc3lUc0FsSTE5T1ZVOStoV3l3NXczbWFubzZzTHJMK0Rz?=
 =?utf-8?B?cGhodWlYQ1JDZHIvQ0lGcXhKdThtU25vVlpFUzQ1ZC9iZndOWm5XUEFodk5K?=
 =?utf-8?B?TUp1Ym1hek9KSU5zczBLVHR6MytTOTRFY1NEOW91T1FGaHBYbzhRWlJsZVZw?=
 =?utf-8?B?L2Q4VDhBUitNbUE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2020 18:21:13.2090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd5f195-167c-41be-d7a5-08d8acefb09b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xotvS/7Un1WpTQuWiZTVyNDvZoLJGCN2hjlJSvKghHT3771Bx6PNERGOieEvTLlS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 2 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-30_12:2020-12-30,2020-12-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012300114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/20 8:36 AM, Sean Young wrote:
> clang supports arbitrary length ints using the _ExtInt extension. This
> can be useful to hold very large values, e.g. 256 bit or 512 bit types.
> 
> Larger types (e.g. 1024 bits) are possible but I am unaware of a use
> case for these.
> 
> This requires the _ExtInt extension enabled in clang, which is under
> review.
> 
> Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
> Link: https://reviews.llvm.org/D93103
> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
> changes since v2:
>   - added tests as suggested by Yonghong Song
>   - added kernel pretty-printer
> 
>   Documentation/bpf/btf.rst                     |   4 +-
>   include/uapi/linux/btf.h                      |   2 +-
>   kernel/bpf/btf.c                              |  54 +-
>   tools/bpf/bpftool/btf_dumper.c                |  40 ++
>   tools/include/uapi/linux/btf.h                |   2 +-
>   tools/lib/bpf/btf.c                           |   2 +-
>   tools/testing/selftests/bpf/Makefile          |   3 +-
>   tools/testing/selftests/bpf/prog_tests/btf.c  |   3 +-
>   .../selftests/bpf/progs/test_btf_extint.c     |  50 ++
>   tools/testing/selftests/bpf/test_extint.py    | 535 ++++++++++++++++++

For easier review, maybe you can break this patch into a patch series 
like below?
   patch 1 (kernel related changes and doc)
       kernel/bpf/btf.c, include/uapi/linux/btf.h,
       tools/include/uapi/linux/btf.h
       Documentation/bpf/btf.rst
   patch 2 (libbpf support)
       tools/lib/bpf/btf.c
   patch 3 (bpftool support)
       tools/bpf/bpftool/btf_dumper.c
   patch 4 (testing)
       rest files

>   10 files changed, 679 insertions(+), 16 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/test_btf_extint.c
>   create mode 100755 tools/testing/selftests/bpf/test_extint.py
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
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 8d6bdb4f4d61..44bc17207e9b 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -166,7 +166,8 @@
>    *
>    */
>   
> -#define BITS_PER_U128 (sizeof(u64) * BITS_PER_BYTE * 2)
> +#define BITS_PER_U128 128
> +#define BITS_PER_U512 512
>   #define BITS_PER_BYTE_MASK (BITS_PER_BYTE - 1)
>   #define BITS_PER_BYTE_MASKED(bits) ((bits) & BITS_PER_BYTE_MASK)
>   #define BITS_ROUNDDOWN_BYTES(bits) ((bits) >> 3)
> @@ -1907,9 +1908,9 @@ static int btf_int_check_member(struct btf_verifier_env *env,
>   	nr_copy_bits = BTF_INT_BITS(int_data) +
>   		BITS_PER_BYTE_MASKED(struct_bits_off);
>   
> -	if (nr_copy_bits > BITS_PER_U128) {
> +	if (nr_copy_bits > BITS_PER_U512) {
>   		btf_verifier_log_member(env, struct_type, member,
> -					"nr_copy_bits exceeds 128");
> +					"nr_copy_bits exceeds 512");
>   		return -EINVAL;
>   	}
>   
> @@ -1963,9 +1964,9 @@ static int btf_int_check_kflag_member(struct btf_verifier_env *env,
>   
>   	bytes_offset = BITS_ROUNDDOWN_BYTES(struct_bits_off);
>   	nr_copy_bits = nr_bits + BITS_PER_BYTE_MASKED(struct_bits_off);
> -	if (nr_copy_bits > BITS_PER_U128) {
> +	if (nr_copy_bits > BITS_PER_U512) {
>   		btf_verifier_log_member(env, struct_type, member,
> -					"nr_copy_bits exceeds 128");
> +					"nr_copy_bits exceeds 512");
>   		return -EINVAL;
>   	}
>   
> @@ -2012,9 +2013,9 @@ static s32 btf_int_check_meta(struct btf_verifier_env *env,
>   
>   	nr_bits = BTF_INT_BITS(int_data) + BTF_INT_OFFSET(int_data);
>   
> -	if (nr_bits > BITS_PER_U128) {
> -		btf_verifier_log_type(env, t, "nr_bits exceeds %zu",
> -				      BITS_PER_U128);
> +	if (nr_bits > BITS_PER_U512) {
> +		btf_verifier_log_type(env, t, "nr_bits exceeds %u",
> +				      BITS_PER_U512);
>   		return -EINVAL;
>   	}
>   
> @@ -2080,6 +2081,37 @@ static void btf_int128_print(struct btf_show *show, void *data)
>   				     lower_num);
>   }
>   
> +static void btf_bigint_print(struct btf_show *show, void *data, u16 nr_bits)
> +{
> +	/* data points to 256 or 512 bit int type */
> +	char buf[129];
> +	int last_u64 = nr_bits / 64 - 1;
> +	bool seen_nonzero = false;
> +	int i;
> +
> +	for (i = 0; i <= last_u64; i++) {
> +#ifdef __BIG_ENDIAN_BITFIELD
> +		u64 v = ((u64 *)data)[i];
> +#else
> +		u64 v = ((u64 *)data)[last_u64 - i];
> +#endif
> +		if (!seen_nonzero) {
> +			if (!v && i != last_u64)
> +				continue;
> +
> +			snprintf(buf, sizeof(buf), "%llx", v);
> +
> +			seen_nonzero = true;
> +		} else {
> +			size_t off = strlen(buf);
> +
> +			snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
> +		}
> +	}
> +
> +	btf_show_type_value(show, "0x%s", buf);
> +}
> +
>   static void btf_int128_shift(u64 *print_num, u16 left_shift_bits,
>   			     u16 right_shift_bits)
>   {
> @@ -2172,7 +2204,7 @@ static void btf_int_show(const struct btf *btf, const struct btf_type *t,
>   	u32 int_data = btf_type_int(t);
>   	u8 encoding = BTF_INT_ENCODING(int_data);
>   	bool sign = encoding & BTF_INT_SIGNED;
> -	u8 nr_bits = BTF_INT_BITS(int_data);
> +	u16 nr_bits = BTF_INT_BITS(int_data);
>   	void *safe_data;
>   
>   	safe_data = btf_show_start_type(show, t, type_id, data);
> @@ -2186,6 +2218,10 @@ static void btf_int_show(const struct btf *btf, const struct btf_type *t,
>   	}
>   
>   	switch (nr_bits) {
> +	case 512:
> +	case 256:
> +		btf_bigint_print(show, safe_data, nr_bits);
> +		break;
>   	case 128:
>   		btf_int128_print(show, safe_data);
>   		break;

You shuold adjust for the following function as well.

/*
  * Regular int is not a bit field and it must be either
  * u8/u16/u32/u64 or __int128.
  */
static bool btf_type_int_is_regular(const struct btf_type *t)
{
         u8 nr_bits, nr_bytes;
         u32 int_data;

         int_data = btf_type_int(t);
         nr_bits = BTF_INT_BITS(int_data);
         nr_bytes = BITS_ROUNDUP_BYTES(nr_bits);
         if (BITS_PER_BYTE_MASKED(nr_bits) ||
             BTF_INT_OFFSET(int_data) ||
             (nr_bytes != sizeof(u8) && nr_bytes != sizeof(u16) &&
              nr_bytes != sizeof(u32) && nr_bytes != sizeof(u64) &&
              nr_bytes != (2 * sizeof(u64)))) {
                 return false;
         }

         return true;
}

This function is used to test struct/union int member type, array 
index/element int type.

> diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> index 0e9310727281..8b5318ec5c26 100644
> --- a/tools/bpf/bpftool/btf_dumper.c
> +++ b/tools/bpf/bpftool/btf_dumper.c
> @@ -271,6 +271,41 @@ static void btf_int128_print(json_writer_t *jw, const void *data,
>   	}
>   }
>   
> +static void btf_bigint_print(json_writer_t *jw, const void *data, int nr_bits,
> +			     bool is_plain_text)
> +{
> +	char buf[nr_bits / 4 + 1];
> +	int last_u64 = nr_bits / 64 - 1;
> +	bool seen_nonzero = false;
> +	int i;
> +
> +	for (i = 0; i <= last_u64; i++) {
> +#ifdef __BIG_ENDIAN_BITFIELD
> +		__u64 v = ((__u64 *)data)[i];
> +#else
> +		__u64 v = ((__u64 *)data)[last_u64 - i];
> +#endif
> +
> +		if (!seen_nonzero) {
> +			if (!v && i != last_u64)
> +				continue;
> +
> +			snprintf(buf, sizeof(buf), "%llx", v);
> +
> +			seen_nonzero = true;
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
> @@ -373,6 +408,11 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
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
> diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
> index 5a667107ad2c..1696fd02b302 100644
> --- a/tools/include/uapi/linux/btf.h
> +++ b/tools/include/uapi/linux/btf.h
> @@ -84,7 +84,7 @@ struct btf_type {
>    */
>   #define BTF_INT_ENCODING(VAL)	(((VAL) & 0x0f000000) >> 24)
>   #define BTF_INT_OFFSET(VAL)	(((VAL) & 0x00ff0000) >> 16)
> -#define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
> +#define BTF_INT_BITS(VAL)	((VAL)  & 0x000003ff)
>   
>   /* Attributes stored in the BTF_INT_ENCODING */
>   #define BTF_INT_SIGNED	(1 << 0)
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 3c3f2bc6c652..a676373f052b 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1722,7 +1722,7 @@ int btf__add_int(struct btf *btf, const char *name, size_t byte_sz, int encoding
>   	if (!name || !name[0])
>   		return -EINVAL;
>   	/* byte_sz must be power of 2 */
> -	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 16)
> +	if (!byte_sz || (byte_sz & (byte_sz - 1)) || byte_sz > 64)
>   		return -EINVAL;
>   	if (encoding & ~(BTF_INT_SIGNED | BTF_INT_CHAR | BTF_INT_BOOL))
>   		return -EINVAL;
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 8c33e999319a..436ad1aed3d9 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -70,7 +70,8 @@ TEST_PROGS := test_kmod.sh \
>   	test_bpftool_build.sh \
>   	test_bpftool.sh \
>   	test_bpftool_metadata.sh \
> -	test_xsk.sh
> +	test_xsk.sh \
> +	test_extint.py

Can we fold all tests into test_progs instead of test_extint.py?
People regularly run test_progs, but maybe not other shell scripts.
test_progs should be able to help test libbpf APIs and kernel APIs.
The existing prog_tests/btf.c is a good starting point. You can
add additional raw tests to test kernel btf with Extint. You can
add additional pretty print tests to test kernel bpffs map printout
with Extint. Putting tests in btf.c is also good as btf.c is the
place in selftests/bpf which tests basic btf types.

Also, you need to do a feature detection in btf.c. You can construct
a simple btf with Extint(256) type to see whether the kernel supports
it or not. If not, your newer tests should be skipped. There are
some test/skip examples in btf.c already.

The test_progs won't test bpftool change. in the past, people just
add some bpftool examples in the commit message to illustrate how
it is printed out and in general that is good enough.

>   
>   TEST_PROGS_EXTENDED := with_addr.sh \
>   	with_tunnels.sh \
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
> index 8ae97e2a4b9d..96a93502cf27 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> @@ -4073,6 +4073,7 @@ struct btf_file_test {
>   static struct btf_file_test file_tests[] = {
>   	{ .file = "test_btf_haskv.o", },
>   	{ .file = "test_btf_newkv.o", },
> +	{ .file = "test_btf_extint.o", },
>   	{ .file = "test_btf_nokv.o", .btf_kv_notfound = true, },
>   };
>   
> @@ -4414,7 +4415,7 @@ static struct btf_raw_test pprint_test_template[] = {
>   	 * will have both int and enum types.
>   	 */
>   	.raw_types = {
> -		/* unsighed char */			/* [1] */
> +		/* unsigned char */			/* [1] */
>   		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 8, 1),
>   		/* unsigned short */			/* [2] */
>   		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 16, 2),
> diff --git a/tools/testing/selftests/bpf/progs/test_btf_extint.c b/tools/testing/selftests/bpf/progs/test_btf_extint.c
> new file mode 100644
> index 000000000000..b0fa9f130dda
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_btf_extint.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include "bpf_legacy.h"
> +
> +struct extint {
> +	_ExtInt(256) v256;
> +	_ExtInt(512) v512;
> +};
> +
> +struct bpf_map_def SEC("maps") btf_map = {
> +	.type = BPF_MAP_TYPE_ARRAY,
> +	.key_size = sizeof(int),
> +	.value_size = sizeof(struct extint),
> +	.max_entries = 1,
> +};
> +
> +BPF_ANNOTATE_KV_PAIR(btf_map, int, struct extint);

Please use newer .maps format instead of legacy one (the
above bpf_legacy.h). There are a lot of examples in
tools/testing/selftests/bpf/progs/ directory.

> +
> +__attribute__((noinline))
> +int test_long_fname_2(void)
> +{
> +	struct extint *bi;
> +	int key = 0;
> +
> +	bi = bpf_map_lookup_elem(&btf_map, &key);
> +	if (!bi)
> +		return 0;
> +
> +	bi->v256 <<= 64;
> +	bi->v256 += (_ExtInt(256))0xcafedead;
> +	bi->v512 <<= 128;
> +	bi->v512 += (_ExtInt(512))0xff00ff00ff00ffull;
> +
> +	return 0;
> +}
> +
> +__attribute__((noinline))
> +int test_long_fname_1(void)
> +{
> +	return test_long_fname_2();
> +}
> +
> +SEC("dummy_tracepoint")
> +int _dummy_tracepoint(void *arg)
> +{
> +	return test_long_fname_1();
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_extint.py b/tools/testing/selftests/bpf/test_extint.py
> new file mode 100755
> index 000000000000..86af815a0cf6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_extint.py
> @@ -0,0 +1,535 @@
> +#!/usr/bin/python3
> +# SPDX-License-Identifier: GPL-2.0
> +
> +# Copyright (C) 2020 Sean Young <sean@mess.org>
> +# Copyright (C) 2017 Netronome Systems, Inc.
> +# Copyright (c) 2019 Mellanox Technologies. All rights reserved
> +#
> +# This software is licensed under the GNU General License Version 2,
> +# June 1991 as shown in the file COPYING in the top-level directory of this
> +# source tree.
> +#
> +# THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS"
> +# WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
> +# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
> +# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
> +# OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME
> +# THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
> +
> +from datetime import datetime
> +import argparse
> +import errno
> +import json
> +import os
> +import pprint
> +import random
> +import re
> +import stat
> +import string
> +import struct
> +import subprocess
> +import time
> +import traceback
> +
[...]
