Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED12B2625FA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIIDuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:50:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48376 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725984AbgIIDuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:50:51 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0893oaY4009035;
        Tue, 8 Sep 2020 20:50:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tatuKkpMqsntGgl2t4mCy+ScxO1cmb3+xLbz/1fd21Y=;
 b=knWjx6haNVgS4NX0HP8y4YLQOaA3kuAlg+XovBtxxAJY92mAimFnFVS8YCZSSnrq2soZ
 q/3kwsqgUFB95SkBfuGDGOQvVZBiXbeoqYpmm8Ea2Ua3h+S6XDsY+4vi6p2wgTQYruWW
 oHVXMtWL9rc9IFSCD00j9RpHlXoKF1XvVs8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33ct5tw8n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Sep 2020 20:50:36 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 20:50:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dABNEabrBaseAfi4pWTzz8AvBgIyFn1rVtb9sKb/qLI0P3ffpS5EyO6l1RUhTkdJPVolpwS0capsbC5kZUA+2REQnXcLsOxW7yPFkyPoTDQmM7EhxwIf5rGbtv9TMiHBiPrPH7Hi+3kBgqVzbRFMDc3Aorl3dJnnGrqTWacFzXClw173ljYhf2DRxoqW3M2kuMBEbVT3YrvuOYwMSPO0qKVymw/Axx7CAQiz4LjhuWOFUaCWe+IPaI9KWWRY2Ju1vktlThWPcupQ3nTb9TJSFwjOIgJsnUpDt1p7pnA9a/5PoilAVnwP1AGvwXsvExFALxH2gFD2hFqwAK+s+d/Afg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tatuKkpMqsntGgl2t4mCy+ScxO1cmb3+xLbz/1fd21Y=;
 b=S9sLaj8u0rJAZmRJd0ltEoZQn9+wZjB7bigaFfO/RZwduhNiZRS/SI+CEaRVUB2Z9+BDFKJybLb146v9bxk+V5KSnCnDV8d5F5kVC/VpqBr7prAqnaHqk7kSmRXa9//XFc/Sq0GN6R88uMIUSeaNYjVLKd8+3T4/Cyzeu1rkiRjFE5/JnqQ29ckvw7keLDOjliWbRcRMKzpI8dmQWVw9qXpAJGFqWapwKoS+c5Inhy/Q/AkN52GlVCCFAkKahcKHo7lGoV2DtBaFzdTv6vk4+XaFctVmrmgl94xhNalJk39ntl6WNDHzNXs6yPlUD3GRtIv3TQJh9/k+4zAN5eRUcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tatuKkpMqsntGgl2t4mCy+ScxO1cmb3+xLbz/1fd21Y=;
 b=VU3x/81cOlT/VdNU/oQdT9RHqE7+RVo5LkyCm+SMZT3IFDbpr0LSJ2PtmBB17yVSjZ2lqe3rBJGvMRfvXqG3EWqawl25nAIGD55Vvi2g9JO7TQNMRXDZkUVCOkDfAbfARj9HYY8dAjelUV7Avrl+Eyt2Y5Q/x8WC8wZRvplMzho=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3570.namprd15.prod.outlook.com (2603:10b6:a03:1f9::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Wed, 9 Sep
 2020 03:49:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 03:49:59 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: fix test_sysctl_loop{1,2} failure
 due to clang change
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200909031227.963161-1-yhs@fb.com>
 <CAEf4BzZmtd_5fu53ZR==KW4jGO2UpzaBJU62GqOqgE0BFCtvvw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ac5be30e-9d61-c113-6c98-d222d873a54c@fb.com>
Date:   Tue, 8 Sep 2020 20:49:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzZmtd_5fu53ZR==KW4jGO2UpzaBJU62GqOqgE0BFCtvvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0044.namprd08.prod.outlook.com
 (2603:10b6:a03:117::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::109f] (2620:10d:c090:400::5:8fb4) by BYAPR08CA0044.namprd08.prod.outlook.com (2603:10b6:a03:117::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 03:49:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:8fb4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82ea3922-b2c0-4762-3dc4-08d854736c6d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3570B665AFA8FFA6C3C6752ED3260@BY5PR15MB3570.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JTuXf9tgvGIh9vgtITPZueyznIO7X02k9aFfWIElvDKDvWnA9m5w6lE8+PqjoGqsXjDY6TeoSqrwbSi13mS9ZN7zKJx854paFnPIy89Qs+ZPf4h3WznC1i3Nx9Rh2e3ba1uhJ+JM6Z/1EJ/0BojeeBjbJG9QR9fAtTX5wj0kYTELVYChf0MsG5V8wLU5GhQ1tN+1zdH7xXW78PuG3JZq3rInp4zkTVs+VO4R8eIzZDDcdNP3zHsFIWSiHwUj/MRQEcHGAqgKSHkFx5QhbfFTb17ziFFFgX/P0RCWQDtfrO94L/bemdfhnANQPS/j4RJu1w1QJiFlM27HP+NO+/Mr0pGV3q5L9I6p5FSwc8DP8gdQYq7+ULw2/OoiEDqRr+VL7NWGdrBE100hy2YvgrBD6heHMgN0HWI/6rQ73HhIQ1Xx2D3sNq2ABB0KveYHREOuJNF7QsD1plynsb5oSGkgpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39860400002)(136003)(36756003)(6916009)(54906003)(2616005)(966005)(186003)(6486002)(83380400001)(53546011)(52116002)(16526019)(4326008)(478600001)(316002)(8676002)(31696002)(5660300002)(66946007)(86362001)(2906002)(66556008)(8936002)(31686004)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Nt5vMt/tjjaCvmjg2EMI6VxeohPoJ0ewNlPm2nTvUZI2hhGUTa3fam291wqacvAvZMwS9394l8DvQ7h9VdGRzAEmsTYrCHOTsL3iWLeqCIa2+6Qdd+5JEIEQf2LMhPZEZxK0gPb3KWBSTja5IRw8wph8tQeWDUDuhbHgkCBjeHIeam+tG8tG5SdOMBiG3HgcF7S8342d4GsqHgVOKzfGNH7oz2KqARGBDo3B9uX0wsLGky/NRiH8cGdjDb9cjEqz9hbh0BdYOEg3wSujaejGqpSNauM1iLOdNk0xKx+96ttunIC27KSHNtyJCvEstyTkmxgOebAOjbs7eCPr5vWDLJK45ITE3U/c8zdT81yQMDwKsa+gN72XeT1aoWOQvyAD3bamLAbdRMaUFWqCMJ/i8c/Xfo0pR2Hbd7GtiwqI7CCQju/Lq2BTbuG05au6PJq1cs9lp5CpQy5M3dGCqbps7AszQW0E0WxnS5hhZGL3DtJvX8u5DRpTew90tyUAdCPX7GWRVl5Plb89Mj2VktqbpxMHLuVOH2qC8fUDdTzPGkPrZIb6dVjoAEOQlQUGArekddqZPQvjVuHmVMTgQhUWZGdQ8ZPudjYpCwMuvWtD4SOlpP0y/F0dNiUpRFzq7ckRvytHdumKifL4cQrb6RX/ACkDCeod/h0MTMbYAbQcyOM=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ea3922-b2c0-4762-3dc4-08d854736c6d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 03:49:59.3303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: grAyiD1wWQqxEMtjjgODoW9UXNXsHYZgsqee3CFo/StfWm27p+9sfuCPsfMwO0eO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3570
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_02:2020-09-08,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009090033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/20 8:20 PM, Andrii Nakryiko wrote:
> On Tue, Sep 8, 2020 at 8:13 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Andrii reported that with latest clang, when building selftests, we have
>> error likes:
>>    error: progs/test_sysctl_loop1.c:23:16: in function sysctl_tcp_mem i32 (%struct.bpf_sysctl*):
>>    Looks like the BPF stack limit of 512 bytes is exceeded.
>>    Please move large on stack variables into BPF per-cpu array map.
>>
>> The error is triggered by the following LLVM patch:
>>    https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D87134&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=MY4KJcuRPEAEtKz22Ylp90Su0nIcw8XHrqU5G6JygYw&s=gGtiXV8_9aQuXsJxyzNmh6CNLKMibukbD2X2QJj3tgw&e=
>>
>> For example, the following code is from test_sysctl_loop1.c:
>>    static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
>>    {
>>      volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
>>      ...
>>    }
>> Without the above LLVM patch, the compiler did optimization to load the string
>> (59 bytes long) with 7 64bit loads, 1 8bit load and 1 16bit load,
>> occupying 64 byte stack size.
>>
>> With the above LLVM patch, the compiler only uses 8bit loads, but subregister is 32bit.
>> So stack requirements become 4 * 59 = 236 bytes. Together with other stuff on
>> the stack, total stack size exceeds 512 bytes, hence compiler complains and quits.
>>
>> To fix the issue, removing "volatile" key word or changing "volatile" to
>> "const"/"static const" does not work, the string is put in .rodata.str1.1 section,
>> which libbpf did not process it and errors out with
> 
> Yeah, those .str1.1 sections are becoming more prominent, I think I'll
> be able to fix it soon, just need the right BTF APIs implemented
> first.
> 
>>    libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
>>    libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_mem.tcp_mem_name'
>>            in section '.rodata.str1.1'
>>
>> Defining the string const as global variable can fix the issue as it puts the string constant
>> in '.rodata' section which is recognized by libbpf. In the future, when libbpf can process
>> '.rodata.str*.*' properly, the global definition can be changed back to local definition.
>>
>> Reported-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> thanks!
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>>   tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 2 +-
>>   tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
>> index 458b0d69133e..4b600b1f522f 100644
>> --- a/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
>> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
>> @@ -18,9 +18,9 @@
>>   #define MAX_ULONG_STR_LEN 7
>>   #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
>>
>> +const char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
> 
> Do you think we should put "volatile" there just in case Clang decides
> to be very optimizing and smart?

In this particular case, 'volatile' is not needed since volatile is
mostly used to keep compiler optimizing away the variable. In this
case, since it is a global, the compiler has no way to optimize it
away, so we should be fine here. It should appear in skeleton .rodata
section.

Since the variable is defined as a 'const', compiler feels free to
do optimization, e.g., doing actual loads and put the const strings
on the stack, in certain cases. Even for this, the constant string
should still be available in .rodata section since it is a global
and somebody else may references it.

> 
>>   static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
>>   {
>> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
>>          unsigned char i;
>>          char name[64];
>>          int ret;
>> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> index b2e6f9b0894d..3c292c087395 100644
>> --- a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> @@ -18,9 +18,9 @@
>>   #define MAX_ULONG_STR_LEN 7
>>   #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
>>
>> +const char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>>   static __attribute__((noinline)) int is_tcp_mem(struct bpf_sysctl *ctx)
>>   {
>> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>>          unsigned char i;
>>          char name[64];
>>          int ret;
>> --
>> 2.24.1
>>
