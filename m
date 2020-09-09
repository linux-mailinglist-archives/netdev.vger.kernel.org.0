Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DB82633DD
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgIIRLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:11:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25690 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730299AbgIIRLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:11:35 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 089HBAH9027459;
        Wed, 9 Sep 2020 10:11:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=00YqZlKyAxTWfJdMNiqxhayAxzXQugQ0chNIiJzT49U=;
 b=J9ECC2oaSHibzj680TNW5zOG3NzRqEFeIRlSvxM2Me03YY7AapCXYZEsxbJ7DBSYkRDO
 9pONrTXP/r6FeYOkuqQ4dwcDS5wRBhUrOYARFbktpZVaaHEPxoNy8Id5Db5M+g/ZdpCP
 EYPW1RRsMcstmGYPGQNpNzfb5VxSFr64vbE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33c8dwk6hg-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Sep 2020 10:11:13 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Sep 2020 10:10:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RRfSMCvc1uvLyVNeZ6nPAFP8zOjrFXIkXbpTouiBKpAR+zGXxFx3hNvxzXq51bYYYpjymUOePQr3A3a7rmYdwEQqkm7lQWM30pS5/vsWrph+GPdNGhpizWEHmRRIxRD/2Yxw0tjUd4U7Tnf028mCvU2Ld+fElGVQScuBu3dmfDfUdOw7iQOFU0Sl5Ha+XwGZ1iuT5nMwKUyInptK4VdCGsvs7XzStzWc1wU2rOdmySOLIKFjLHQZGdrTYv90DPh7T85pmIRxcvXi4R51ZjExmEYYp/iEw1BwBVL+Np7eB+vvBovlxPW9qelelmAJco0+hx6wd57wKI0RpOZq2QE4+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00YqZlKyAxTWfJdMNiqxhayAxzXQugQ0chNIiJzT49U=;
 b=Jhy1Y5y+PlAX02i1hKHmtsXjheoebBa8VFqxxh84nSYUAg8101okmG+brPrgFKrbs0PYh/bK3TP3mrBgyHTUupT09MJpe0tUG0sDvOwVCRj6uFuFViXT8CJGaFiYIriZefCeV8WXKgI0tS0Ag63uhzVBcATjFb/4bYG63HStkEk/8dejHaasXUZCMsyuYUOkRcKjKAAIUVqzw1133bMORJkwwcXf+8MfReunIZyD6xjC8nfNbmkwe6IF2/2GVHfotJ0/ymkaCjjnXj4+pJqWII7IoXsFuNY+B9j40dhoRi1GTsmVFxIokoZ0pQUsXUb8Uvvsy2CqYG4LqtHYTZSMVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00YqZlKyAxTWfJdMNiqxhayAxzXQugQ0chNIiJzT49U=;
 b=THVCO5GRoJ3ZNX1YTl7wMW5LN88DgJ+vu7HwrBt4TdmgRZmouwO4kTZX+jnUw+Q0zDK7DLhGg77tesKPysP4BXdK18vszrdP32ueGEFdUvR7ZSlFo6j8umBzAtfUHDAyvQ8joJsHkrK1ZJ3ydALgNNgLyqS+JlvoSa/JNv/9MfI=
Received: from DM6PR15MB4090.namprd15.prod.outlook.com (2603:10b6:5:c2::18) by
 DM6PR15MB3781.namprd15.prod.outlook.com (2603:10b6:5:2b9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Wed, 9 Sep 2020 17:10:54 +0000
Received: from DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::293b:8163:b8e5:29ef]) by DM6PR15MB4090.namprd15.prod.outlook.com
 ([fe80::293b:8163:b8e5:29ef%6]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 17:10:54 +0000
Subject: Re: [PATCH bpf-next v2] selftests/bpf: fix test_sysctl_loop{1,2}
 failure due to clang change
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200909063943.1653670-1-yhs@fb.com>
 <CAEf4BzYRG=q_0BZwc+K89+OF9M4w7h2SoS3Qb_A6BiUNGPg4hg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <a3a87a24-aefa-2d98-97b7-33edf83c2a31@fb.com>
Date:   Wed, 9 Sep 2020 10:10:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzYRG=q_0BZwc+K89+OF9M4w7h2SoS3Qb_A6BiUNGPg4hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0027.namprd06.prod.outlook.com
 (2603:10b6:303:2a::32) To DM6PR15MB4090.namprd15.prod.outlook.com
 (2603:10b6:5:c2::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11fe] (2620:10d:c090:400::5:6162) by MW3PR06CA0027.namprd06.prod.outlook.com (2603:10b6:303:2a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Wed, 9 Sep 2020 17:10:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:6162]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fe845eb-60e9-4db5-4d57-08d854e34fba
X-MS-TrafficTypeDiagnostic: DM6PR15MB3781:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3781D97E2DFF4FA313AE305CD3260@DM6PR15MB3781.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qOUSIznGweNmOcdbRySAmvEJQAZx3/ECarbkc6HpX4iZlxDdGoE3SbejW1Vn1hdg1C71pJaFDUc+/n07VmW9SRcmHqibwE/SxrokFToawZCKas9c0aoBBpReBzqH9khtybQ1TDfLBnZhjXWBc6AZv3dr9nAipEJtzEzpUpYZsis8AWHbeJP4Tfm0LSqZT+DZBJTKdla13IobOEJ+FBFioDkl4DjSq73EW/GiYrVAbd9GSWTkre8jRrcI1L5RVOzi0/tnLGKWBD8UXpJPyhp1g1v+/Uq/y/v6yittER6XR7utYvPZFeYXa+DbMEsr3fQX4AGXJxTSm1PophZKLgCGB8vJNkrZHeA3T+R/he1aqua80avr3kLxTTcQRGKoCDS9Qf4SeaDi59Z5kIL/DauELUgn3VtFRCJaXQm6rtgn25XuXfEIsB90Rfefyfs3gVOnyergufKI/4fzJWTD0O/XUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4090.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(376002)(366004)(54906003)(5660300002)(8936002)(966005)(36756003)(31696002)(66476007)(6916009)(53546011)(2616005)(86362001)(316002)(6486002)(66946007)(2906002)(66556008)(8676002)(52116002)(478600001)(31686004)(16526019)(83380400001)(186003)(4326008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yzH2Ybj4C9oHMXIhRzaVIBmJ1VfMxQNRFrkEvloRyVpwWcpIAXrrZzXuoxJLAzSVlkkb+8heIb7GJYR9Ycu+Ml/pBhxYJ0zpoFt9xxJyjOmON4VIGSX93EtgmR77MgVnQPfwCxU2NnyVx/L+NavFNZv4IkG3atl5Ydp3PM/4iZ8UrRosLbZnq06mDz46A9OVrF11deP8vDf0fxKiSYPJ6DQOgmKhH81zm3eUijqEvL6DyJWnoAiuCwrxzVuLsLTriOe+2F664+sjHjVCoIeaq4lmUoAicbgnekgGoAfJtDYqoIseEQL9liLR2AWxlnqPAhgbgHqObH2VNNjpXrjDBHY5Bom4e2YcrFDjjrQ7pOz0DfSSuuuRkjIB0j/xk2NP3UbVadwameMxugzUAK46gfQCuVG7GFrV9mEvhRDpN8wYKVAay0S2EBTcKYB4gcFZJo+b7ZTpcmonPBTECLKgSU8Zk6ePaliROB42n2owyUx447z2BRigxE6Ki9hqRZospIOhkWnmpvCfyzu6Rf0130uzjVVsQZEINwqeNE2KQ4GCMgVrDDTSGI0Q2j95dofUXGE8V1e12eROaTWVyfjOe2s61UTnDlOLDi22BjhbQnnmFph74NhG/hVTcTYkoHO3ghIe/yHoTXAe6/zZaYe9ohwhYBkHbstIHYexg741jew44agb1D+lpqZGsfJ4Ua/Q
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe845eb-60e9-4db5-4d57-08d854e34fba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4090.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 17:10:54.7932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BaYjlHmF8Yev3XMxk3ZayDXzeYMC3yF08AHK8cNnTrjVpFnXOr82jmoUcdNLf6wu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3781
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_12:2020-09-09,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/20 9:32 AM, Andrii Nakryiko wrote:
> On Tue, Sep 8, 2020 at 11:40 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Andrii reported that with latest clang, when building selftests, we have
>> error likes:
>>    error: progs/test_sysctl_loop1.c:23:16: in function sysctl_tcp_mem i32 (%struct.bpf_sysctl*):
>>    Looks like the BPF stack limit of 512 bytes is exceeded.
>>    Please move large on stack variables into BPF per-cpu array map.
>>
>> The error is triggered by the following LLVM patch:
>>    https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D87134&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=bsWiCrZT5nrmfm3_om52dUcH95ej2IV4N_-xOE1v14U&s=yM0hEwDFkjIegJg44-iJ8dZYLUk1F7YlKOm65VObloQ&e=
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
>>    libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
>>    libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_mem.tcp_mem_name'
>>            in section '.rodata.str1.1'
>>
>> Defining the string const as global variable can fix the issue as it puts the string constant
>> in '.rodata' section which is recognized by libbpf. In the future, when libbpf can process
>> '.rodata.str*.*' properly, the global definition can be changed back to local definition.
>>
>> Defining tcp_mem_name as a global, however, triggered a verifier failure.
>>     ./test_progs -n 7/21
>>    libbpf: load bpf program failed: Permission denied
>>    libbpf: -- BEGIN DUMP LOG ---
>>    libbpf:
>>    invalid stack off=0 size=1
>>    verification time 6975 usec
>>    stack depth 160+64
>>    processed 889 insns (limit 1000000) max_states_per_insn 4 total_states
>>    14 peak_states 14 mark_read 10
>>
>>    libbpf: -- END LOG --
>>    libbpf: failed to load program 'sysctl_tcp_mem'
>>    libbpf: failed to load object 'test_sysctl_loop2.o'
>>    test_bpf_verif_scale:FAIL:114
>>    #7/21 test_sysctl_loop2.o:FAIL
>> This actually exposed a bpf program bug. In test_sysctl_loop{1,2}, we have code
>> like
>>    const char tcp_mem_name[] = "<...long string...>";
>>    ...
>>    char name[64];
>>    ...
>>    for (i = 0; i < sizeof(tcp_mem_name); ++i)
>>        if (name[i] != tcp_mem_name[i])
>>            return 0;
>> In the above code, if sizeof(tcp_mem_name) > 64, name[i] access may be
>> out of bound. The sizeof(tcp_mem_name) is 59 for test_sysctl_loop1.c and
>> 79 for test_sysctl_loop2.c.
>>
>> Without promotion-to-global change, old compiler generates code where
>> the overflowed stack access is actually filled with valid value, so hiding
>> the bpf program bug. With promotion-to-global change, the code is different,
>> more specifically, the previous loading constants to stack is gone, and
>> "name" occupies stack[-64:0] and overflow access triggers a verifier error.
>> To fix the issue, adjust "name" buffer size properly.
>>
>> Reported-by: Andrii Nakryiko <andriin@fb.com>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 2 +-
>>   tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 5 +++--
>>   2 files changed, 4 insertions(+), 3 deletions(-)
>>
>> Changelog:
>>    v1 -> v2:
>>      . The tcp_mem_name change actually triggers a verifier failure due to
>>        a bpf program bug. Fixing the bpf program bug can make test pass
>>        with both old and latest llvm. (Alexei)
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
>>   static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
>>   {
>> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string";
>>          unsigned char i;
>>          char name[64];
>>          int ret;
>> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> index b2e6f9b0894d..d01056142520 100644
>> --- a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> @@ -18,11 +18,12 @@
>>   #define MAX_ULONG_STR_LEN 7
>>   #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
>>
>> +const char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>>   static __attribute__((noinline)) int is_tcp_mem(struct bpf_sysctl *ctx)
>>   {
>> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>>          unsigned char i;
>> -       char name[64];
>> +       /* the above tcp_mem_name length is 79, make name buffer length 80 */
>> +       char name[80];
> 
> 
> Wow, did you really count? Why not use sizeof(tcp_mem_name) and drop

The assembly code told me it is 79 and I double checked.

> the comment entirely?

Original intention is probably multiple of 8. At least memset will
have fewer instructions since all 64bit store. But I do see
sizeof(tcp_mem_name) is simpler and easier to understand. Will
respin and send v3.

> 
>>          int ret;
>>
>>          memset(name, 0, sizeof(name));
>> --
>> 2.24.1
>>
