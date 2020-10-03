Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8C3282186
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 07:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725763AbgJCFQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 01:16:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgJCFQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 01:16:18 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0935G2Ia023186;
        Fri, 2 Oct 2020 22:16:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lIjF3LglxdzGXKwaDMZ7DtsYtBqpkhQFIk8wFRweff0=;
 b=kcgtDpRXFxIq4dNHBVZlsok7bpMjMcQD+fgU964uo2pg0g+RB4sG3gfGidjUDVUWxRLl
 +cywNk8FM7sb5XGkotD0NTuG93xLJpAVuvHD39bKxwp3CBJrJCbdfVi29Ag5fzIsYZAi
 jDOW4F5A3Sdramj8HIE2ZkydJFXJaBroAlQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33w05ne3nb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Oct 2020 22:16:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 2 Oct 2020 22:15:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhxxqeWobu07gISUeJy0MDKOSOYLBxCu2py+u6V/1nvHK6vW5XBnKajqOL7elMFxdtqlA+cX38zuZyTCnsycgfJG35I9X4PtKfuQmKRi2BG1hHL1GB1LekmzQg8zEZJXxVNh5VkfBrsybnAyLtNJHHigHQc30+ARHpXnP74pmmqgJMmAFADDu6t67YHSiRL0/40b2WQuN2OkRuuK0CxJEChenYd9H2BCCjo+63roq71QUykamOmwekL/Np5MznpFXHxwGSWv9UmRnsN2MJ7zosMACwIySMu8TowGhMMnl1QdIWgrSJmL/9OxcwM2hgOQlaO22SFRIeWPCmjQXlORRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIjF3LglxdzGXKwaDMZ7DtsYtBqpkhQFIk8wFRweff0=;
 b=US9cE4SxtM89bkdWboZDOwABjfdpAFAeVaPyKaU1GL8ATS5SELUHjRcfkW1zrQ/D4GO/kCSKmk1ukHXl+b79FwTpQrbdBMU1jE344Iy4qKXNaDSdwLl6e8RxLJWlhtkByhUuWM8XLweOJGvJwLKhTq+I98Z0QuOpZZpqD1i4kYDtmXX5Isj6LDwKPGBIgpN1IpWjW9oKfEu0eH59v2LqDtTBNSPI2ufn6RKzyuG2XkW9eMGFV+RNYfhQFrM32mXpwWe69eTOAlUULh+RDfRqlAelQdnMSzbH+1AxwiEdbAKTGT+jZnwu6m5QjgajTA0S+gxI3dyeAm75/CWeKKql+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lIjF3LglxdzGXKwaDMZ7DtsYtBqpkhQFIk8wFRweff0=;
 b=CMm2cZmvMPj6dRrmwySk24RYVS1D2bXoeVbm8tLzHzIoRwvEAJOUoP7WOV326ZNIR83xtchbDqySN7rM+fcgD/Pg70VhT9sKU0YwsJSiM83b96l1cEnJFhpEo/ESvoyalWR/9pZPSAR9dpwPK0pvm912TEHPK6+9FCrw82y3F60=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2727.namprd15.prod.outlook.com (2603:10b6:a03:15b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Sat, 3 Oct
 2020 05:15:51 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3433.039; Sat, 3 Oct 2020
 05:15:51 +0000
Subject: Re: [PATCH bpf-next 1/2] samples/bpf: change Makefile to cope with
 latest llvm
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20201003021904.1468678-1-yhs@fb.com>
 <CAEf4BzZSg9TWF=kGVmiZ7HUbpyXwYUEqrvFMeZgYo0h7EC8b3w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9dba5b12-8a78-fa6b-ec43-224fb9297f48@fb.com>
Date:   Fri, 2 Oct 2020 22:15:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAEf4BzZSg9TWF=kGVmiZ7HUbpyXwYUEqrvFMeZgYo0h7EC8b3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a7b6]
X-ClientProxiedBy: MWHPR01CA0028.prod.exchangelabs.com (2603:10b6:300:101::14)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1836] (2620:10d:c090:400::5:a7b6) by MWHPR01CA0028.prod.exchangelabs.com (2603:10b6:300:101::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Sat, 3 Oct 2020 05:15:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f92094ef-e11f-4cbf-26b9-08d8675b653b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2727:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB272732B109B06FDF99D7682FD30E0@BYAPR15MB2727.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VcFnC545M4XKlDKxObikm8D10nN74ggUWOE9NPOM41heo/HSf+xn/zfVjDqA8bvUS61dFWAHySy/bazKWsB1o7GSRHMZ9IpOmqQGg4sPzwamEpza6h7NpHuDuD+z1/fMoiFLKOmBoYNtCMvYUjUbryG8GGDTkaGnahyg2tVkdbxV4JrRZzsDnY18d621rY8/pbxfv7CTjk56yGGuFj31kL3heRUSG2uiTKavsGi9NvR4fq/C8iEkthZqx5q1WwblWoR3ugJhnt1b8HTYvj96NKCA0KaGWoKUS+RcTcTu8rbYBOruDwBDT/8V8EWuDxqWsNlZinK2fCxMurFLqxamDHB5oig81mUoiT+FYqDUMLRelDS8qsGT53URJcHqQgG+dLR2kMYQkFQp0fplIRLOQsWZrL7Sknj/AASYLtLYdTKg3oH23ck8EMuPSSg2d7tLXFJv9gPOBmlcXgjUBEV2Oac8jfaoF5dm7K+UAO3whA8Ot0b7VsxPUs9BDLNWJies
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(376002)(366004)(31696002)(66946007)(86362001)(966005)(5660300002)(478600001)(6916009)(66476007)(8676002)(186003)(8936002)(16526019)(4326008)(316002)(66556008)(36756003)(53546011)(2906002)(52116002)(83380400001)(54906003)(31686004)(2616005)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yzABhx+7C1ygdcbDdhjkqhYrA1utLKjCJFmps0Lgb3PZoQP5isFhzNmL/4eM0I2kw85Wt2T1VXYB0PvEM/VdiLUGKtzldDNFVdX48fDdxqCzC5ODJFnDkMXqEIWzSMrl46H1o4fBQgWUBHFSX1muEU7/w4qAU+zeU+FAbvUWRz/Q3Mhv+xL0tZ6TKPl3durNjA9EpPqwODCZ6acfMYdj7TWu8SLBzX/WeUMZpjbrUtZ5ouDHpI0Mv4RBZPlMDlLbFHTvg4Kjmugsw35tyh9dPadM/jTSaX2L2reo67z6KofvAIQGevpb1yflsPf0dVzvmm4iLExOKtC0ZJ387j4wSoDcW6rfPwmvUZY3A2ZLVjZKHHI6OKSY0Xhjz4qQY+7t5aw2OwmEpmGLZkx30AtocuRiDF5//U3iSRFtzhSHb5rhXbOVrNN4ZQWD9b/pBrIW+HzYqlvIrEfF4WRmKYAazpW5KUHqGIKtbbSMpl5ygr34O9hQHSaln3DQHdjkt9XS7cQqFYHku+RLVEIZ1yHhT+b+S4+NZgn/RZ/OTxw3PjKh4YlAlgp/VEo0yCqskHSnEl4YOXn9jyDeom0jp74RaSWrI3DF79IKuo6ppYDtCQ2BRhCT44uhnJte18yC1kA3cAopOJGLX/ZZwK//b0jS7ZmAyZG2dw+3dTEjtOiR/v8=
X-MS-Exchange-CrossTenant-Network-Message-Id: f92094ef-e11f-4cbf-26b9-08d8675b653b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2020 05:15:51.3284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dHCUHvuOYGKQVB+KezJ/rL8UXcZtEkZYkgyrTg70E6qxNLl1RFqmquaGV+Djinsj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2727
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-03_01:2020-10-02,2020-10-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010030044
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/20 9:22 PM, Andrii Nakryiko wrote:
> On Fri, Oct 2, 2020 at 7:19 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> With latest llvm trunk, bpf programs under samples/bpf
>> directory, if using CORE, may experience the following
>> errors:
>>
>> LLVM ERROR: Cannot select: intrinsic %llvm.preserve.struct.access.index
>> PLEASE submit a bug report to https://urldefense.proofpoint.com/v2/url?u=https-3A__bugs.llvm.org_&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=_D9tvuWQ6EbYqcMBdVB0qqRMVdV6Etws5ITtx8Pa1ZM&s=BwTAvhipPl-Az_WaiJDbqU8yl__NvG8W4HmCqWqHdqg&e=  and include the crash backtrace.
>> Stack dump:
>> 0.      Program arguments: llc -march=bpf -filetype=obj -o samples/bpf/test_probe_write_user_kern.o
>> 1.      Running pass 'Function Pass Manager' on module '<stdin>'.
>> 2.      Running pass 'BPF DAG->DAG Pattern Instruction Selection' on function '@bpf_prog1'
>>   #0 0x000000000183c26c llvm::sys::PrintStackTrace(llvm::raw_ostream&, int)
>>      (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x183c26c)
>> ...
>>   #7 0x00000000017c375e (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x17c375e)
>>   #8 0x00000000016a75c5 llvm::SelectionDAGISel::CannotYetSelect(llvm::SDNode*)
>>      (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x16a75c5)
>>   #9 0x00000000016ab4f8 llvm::SelectionDAGISel::SelectCodeCommon(llvm::SDNode*, unsigned char const*,
>>      unsigned int) (/data/users/yhs/work/llvm-project/llvm/build.cur/install/bin/llc+0x16ab4f8)
>> ...
>> Aborted (core dumped) | llc -march=bpf -filetype=obj -o samples/bpf/test_probe_write_user_kern.o
>>
>> The reason is due to llvm change https://urldefense.proofpoint.com/v2/url?u=https-3A__reviews.llvm.org_D87153&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=_D9tvuWQ6EbYqcMBdVB0qqRMVdV6Etws5ITtx8Pa1ZM&s=fo_LvXqHJx_m0m0pJJiDdOUcOzVXm2_iYoxPhpqpzng&e=
>> where the CORE relocation global generation is moved from the beginning
>> of target dependent optimization (llc) to the beginning
>> of target independent optimization (opt).
>>
>> Since samples/bpf programs did not use vmlinux.h and its clang compilation
>> uses native architecture, we need to adjust arch triple at opt level
>> to do CORE relocation global generation properly. Otherwise, the above
>> error will appear.
>>
>> This patch fixed the issue by introduce opt and llvm-dis to compilation chain,
>> which will do proper CORE relocation global generation as well as O2 level
>> optimization. Tested with llvm10, llvm11 and trunk/llvm12.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   samples/bpf/Makefile | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>> index 4f1ed0e3cf9f..79c5fdea63d2 100644
>> --- a/samples/bpf/Makefile
>> +++ b/samples/bpf/Makefile
>> @@ -211,6 +211,8 @@ TPROGLDLIBS_xsk_fwd         += -pthread
>>   #  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
>>   LLC ?= llc
>>   CLANG ?= clang
>> +OPT ?= opt
>> +LLVM_DIS ?= llvm-dis
>>   LLVM_OBJCOPY ?= llvm-objcopy
>>   BTF_PAHOLE ?= pahole
>>
>> @@ -314,7 +316,9 @@ $(obj)/%.o: $(src)/%.c
>>                  -Wno-address-of-packed-member -Wno-tautological-compare \
>>                  -Wno-unknown-warning-option $(CLANG_ARCH_ARGS) \
>>                  -I$(srctree)/samples/bpf/ -include asm_goto_workaround.h \
>> -               -O2 -emit-llvm -c $< -o -| $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
>> +               -O2 -emit-llvm -Xclang -disable-llvm-passes -c $< -o - | \
>> +               $(OPT) -O2 -mtriple=bpf-pc-linux | $(LLVM_DIS) | \
>> +               $(LLC) -march=bpf $(LLC_FLAGS) -filetype=obj -o $@
> 
> I keep forgetting exact details of why we do this native clang + llc
> pipeline instead of just doing `clang -target bpf`? Is it still

samples/bpf programs did not use vmlinux.h. they directly use 
kernel-devel headers, hence they need to first compile with native arch 
for clang but later change target arch to bpf to generate final byte code.
They cannot just do 'clang -target bpf' without vmlinux.h.

But changing to use vmlinux.h is a much bigger project and I merely
want to make it just work so people won't make/compile samples/bpf
and get compilation errors.

> relevant and necessary, or we can just simplify it now?
> 
>>   ifeq ($(DWARF2BTF),y)
>>          $(BTF_PAHOLE) -J $@
>>   endif
>> --
>> 2.24.1
>>
