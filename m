Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B811762CD
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 19:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCBSdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 13:33:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29160 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727255AbgCBSdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 13:33:38 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 022IOvv3022551;
        Mon, 2 Mar 2020 10:33:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bPfuQP2eo3bYHKVKZEqxgi9IjvEkRLMS3EwR5lq9s+s=;
 b=dirMbBDRQ+ZpJmCGjrHFJu1vtiL1AaZlCjKBDAtedP0aYf3PXyZR4ieJKizlB+p33dRa
 WP301tdSC305YRC3IiLNB9TU3ZNdwVqymz6c38QiH8YH1zfgFSK3673EQ1uUcL9biAwr
 IYgUguxuBWcCP2S798v/Q5bwsTwUqIFWJhQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8x7e56d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 02 Mar 2020 10:33:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 10:33:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4QPL2Trj9WKvrK2vOi6Hfj10zSE7ArRuX7pRnvoGFRi25tqLaMYPzWsMYOIGUiEgT4LYZQ8ijMpyrFWnmWfqmqAH+7aJGeZ5wzSQmXCRcJSNw9Cx+G33s+e5qT9cMITJVwPW0QVBo7ourY+Ldhh9wEoOY7v5g1D5avZNb8bP5mHrP+yahmzWLdOGfDja+05495aQ0sdw7VUI2uwrYBLusWsKp6ppFCSwO7ueyphX95imcrgp4zSy8IVWO4WqRT2h13kcO8JzNtU0niO0b+PE7ekUyW+JxtVTrd3xUu5Mu4glgXPrK3UPZBAOtH7DHogLjW63lZAp9ekKhP/2gpp+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPfuQP2eo3bYHKVKZEqxgi9IjvEkRLMS3EwR5lq9s+s=;
 b=lymZR57D87sZZdxAeQBh3DY3tgWmxi8Ojv49Uxzmkoj/PIMuIA7LmWGPa88Vw21quiwonh3xf6bB8guS8B06U6C9TiNkoI7geMXxIrfvKd6sg+gFqbNwvjDynNbDah9SkrQM6YVfhODSGdiiyhSXyvlxP4ktXA3K96N2kJjf196/UsQA3vTNOE0zUIBTr0yTUdls/C6uJmKSas2YZlTKPrbLCOrsqV3bH0nM2KsL5JggSTenNoDD++u3vmc4WbmUlOoOUfjH+o46jYWOHtJ8/Fz+ZgzERBmx9YkKID/78KDVfabrKMN4H0ksi20+ks93isFrgrCd6c1w1z5Lbvmmyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPfuQP2eo3bYHKVKZEqxgi9IjvEkRLMS3EwR5lq9s+s=;
 b=STosLrH7cpJ7EMii+jsDo7yk6c/kbhia3vhEyxAKCFe8c9NyMoo9c2zxnxV0tzxwxHqOB2sYgxStEId47toPoGgPOlydfN4azoq0ogUvc7FxaNejPwat+VnsmAksSJeRrf6sGD18MKKapsLgdb1KpTUiOAhls//sTkr0dan8m7s=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB2554.namprd15.prod.outlook.com (2603:10b6:5:1a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.16; Mon, 2 Mar
 2020 18:33:23 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 18:33:23 +0000
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: switch BPF UAPI #define constants to
 enums
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200301062405.2850114-1-andriin@fb.com>
 <20200301062405.2850114-2-andriin@fb.com>
 <b57cdf6d-0849-2d54-982e-352886f86201@fb.com>
 <CAEf4BzZspu-wXMr6v=Sd-_m-XzXJwJHyU9zd0ydEiWmch8F9GQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <af9e3e1e-e1e9-0462-88a4-93fd06c40957@fb.com>
Date:   Mon, 2 Mar 2020 10:33:19 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <CAEf4BzZspu-wXMr6v=Sd-_m-XzXJwJHyU9zd0ydEiWmch8F9GQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR2001CA0019.namprd20.prod.outlook.com
 (2603:10b6:301:15::29) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::6:87b3) by MWHPR2001CA0019.namprd20.prod.outlook.com (2603:10b6:301:15::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Mon, 2 Mar 2020 18:33:22 +0000
X-Originating-IP: [2620:10d:c090:500::6:87b3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 025fc4dc-c77d-4b89-5a48-08d7bed83052
X-MS-TrafficTypeDiagnostic: DM6PR15MB2554:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2554245E137D23FA37EE407ED3E70@DM6PR15MB2554.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(366004)(346002)(39860400002)(199004)(189003)(6512007)(5660300002)(2616005)(6666004)(81166006)(8676002)(81156014)(31696002)(53546011)(316002)(16526019)(54906003)(186003)(66574012)(6916009)(66946007)(66476007)(66556008)(52116002)(478600001)(86362001)(6506007)(6486002)(4326008)(31686004)(36756003)(8936002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2554;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s8ZVBaicgHBcM8A4/t1mGW0tU2YmUrzgycjEKQAed5POtEHf24ImlTn7JuEQy2+GAwnBZ/h3KcOLQs31D95P1carM8wDijNPMpjV29hel6x0xqvWTV3HBvMqoOMUjRy0OvHwRru50aJH1jwftTkthxdgH9zk+FKqBPdTcnCqIpJRa1a8a+sKDkKIsmUvjESm/GFARL2/mbn82NZHROtOCBZFFk/t94OY4bHheKCCtSJNLfe7zS9P/iJfVuQt8QDKqr3+eJzmMGgSh1FmiCYzW8i9xnUXDOyv7quOF4u2n2sV2OLD/YY0BVq2xF0eKv9gQfBSMlCj87ZPowI+HLo8Ua5OtYEaJSLwfnvfd0n1OYXCnszcDkb8CAyP0nZsycLqTGdjaHip2AhlL9bEl5wzOMq4wFpXQw5GKRYAa6zh7cy7aOLKo/+eXQmbvstuYmra
X-MS-Exchange-AntiSpam-MessageData: ji2E7PXSTOvlAiPansXfH6gZ0ZlKj5bMhYFQwJfmqOhpdK5W9xRdRuq6D1DL4poBJBXXZOt8LW8rI2BRwa4SuhJH4Mm7Y3r8n73PAAsMe6WxcT4y48chRmmjMIgHLoL9L4vF5OHmCZtEFDVScVxlFKZ1iDLGG0Cevu99wTfVotPQhHBVJWtSj0QpJrKvNlu2
X-MS-Exchange-CrossTenant-Network-Message-Id: 025fc4dc-c77d-4b89-5a48-08d7bed83052
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 18:33:23.2199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGF6SEPrH2K/6bIPqLAtyiQjRZ120/F3euIrfDF9xbY0emnlI2LqiK2BKNGj1oYT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2554
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_07:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 phishscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003020121
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/20 10:25 AM, Andrii Nakryiko wrote:
> On Mon, Mar 2, 2020 at 8:22 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 2/29/20 10:24 PM, Andrii Nakryiko wrote:
>>> Switch BPF UAPI constants, previously defined as #define macro, to anonymous
>>> enum values. This preserves constants values and behavior in expressions, but
>>> has added advantaged of being captured as part of DWARF and, subsequently, BTF
>>> type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
>>> for BPF applications, as it will not require BPF users to copy/paste various
>>> flags and constants, which are frequently used with BPF helpers.
>>>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>>    include/uapi/linux/bpf.h              | 272 +++++++++++++++----------
>>>    include/uapi/linux/bpf_common.h       |  86 ++++----
>>>    include/uapi/linux/btf.h              |  60 +++---
>>>    tools/include/uapi/linux/bpf.h        | 274 ++++++++++++++++----------
>>>    tools/include/uapi/linux/bpf_common.h |  86 ++++----
>>>    tools/include/uapi/linux/btf.h        |  60 +++---
>>>    6 files changed, 497 insertions(+), 341 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 8e98ced0963b..03e08f256bd1 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -14,34 +14,36 @@
>>>    /* Extended instruction set based on top of classic BPF */
>>>
>>>    /* instruction classes */
>>> -#define BPF_JMP32    0x06    /* jmp mode in word width */
>>> -#define BPF_ALU64    0x07    /* alu mode in double word width */
>>> +enum {
>>> +     BPF_JMP32       = 0x06, /* jmp mode in word width */
>>> +     BPF_ALU64       = 0x07, /* alu mode in double word width */
>>
>> Not sure whether we have uapi backward compatibility or not.
>> One possibility is to add
>>     #define BPF_ALU64 BPF_ALU64
>> this way, people uses macros will continue to work.
> 
> This is going to be a really ugly solution, though. I wonder if it was
> ever an expected behavior of UAPI constants to be able to do #ifdef on
> them.
> 
> Do you know any existing application that relies on those constants
> being #defines?

I did not have enough experience to work with system level applications.
But in linux/in.h we have

#if __UAPI_DEF_IN_IPPROTO
/* Standard well-defined IP protocols.  */
enum {
   IPPROTO_IP = 0,               /* Dummy protocol for TCP               */
#define IPPROTO_IP              IPPROTO_IP
   IPPROTO_ICMP = 1,             /* Internet Control Message Protocol    */
#define IPPROTO_ICMP            IPPROTO_ICMP
   IPPROTO_IGMP = 2,             /* Internet Group Management Protocol   */
#define IPPROTO_IGMP            IPPROTO_IGMP
   IPPROTO_IPIP = 4,             /* IPIP tunnels (older KA9Q tunnels use 
94) */
#define IPPROTO_IPIP            IPPROTO_IPIP
   IPPROTO_TCP = 6,              /* Transmission Control Protocol        */
#define IPPROTO_TCP             IPPROTO_TCP
   IPPROTO_EGP = 8,              /* Exterior Gateway Protocol            */
#define IPPROTO_EGP             IPPROTO_EGP
   IPPROTO_PUP = 12,             /* PUP protocol                         */
#define IPPROTO_PUP             IPPROTO_PUP
   IPPROTO_UDP = 17,             /* User Datagram Protocol               */
#define IPPROTO_UDP             IPPROTO_UDP
   IPPROTO_IDP = 22,             /* XNS IDP protocol                     */
#define IPPROTO_IDP             IPPROTO_IDP

...


> 
>>
>> If this is an acceptable solution, we have a lot of constants
>> in net related headers and will benefit from this conversion for
>> kprobe/tracepoint of networking related functions.
>>
>>>
>>>    /* ld/ldx fields */
>>> -#define BPF_DW               0x18    /* double word (64-bit) */
>>> -#define BPF_XADD     0xc0    /* exclusive add */
>>> +     BPF_DW          = 0x18, /* double word (64-bit) */
>>> +     BPF_XADD        = 0xc0, /* exclusive add */
>>>
>>>    /* alu/jmp fields */
>>> -#define BPF_MOV              0xb0    /* mov reg to reg */
>>> -#define BPF_ARSH     0xc0    /* sign extending arithmetic shift right */
>>> +     BPF_MOV         = 0xb0, /* mov reg to reg */
>>> +     BPF_ARSH        = 0xc0, /* sign extending arithmetic shift right */
>>>
>>>    /* change endianness of a register */
>>> -#define BPF_END              0xd0    /* flags for endianness conversion: */
>>> -#define BPF_TO_LE    0x00    /* convert to little-endian */
>>> -#define BPF_TO_BE    0x08    /* convert to big-endian */
>>> -#define BPF_FROM_LE  BPF_TO_LE
>>> -#define BPF_FROM_BE  BPF_TO_BE
>>> +     BPF_END         = 0xd0, /* flags for endianness conversion: */
>>> +     BPF_TO_LE       = 0x00, /* convert to little-endian */
>>> +     BPF_TO_BE       = 0x08, /* convert to big-endian */
>>> +     BPF_FROM_LE     = BPF_TO_LE,
>>> +     BPF_FROM_BE     = BPF_TO_BE,
>>>
>>>    /* jmp encodings */
>>> -#define BPF_JNE              0x50    /* jump != */
>>> -#define BPF_JLT              0xa0    /* LT is unsigned, '<' */
>>> -#define BPF_JLE              0xb0    /* LE is unsigned, '<=' */
>>> -#define BPF_JSGT     0x60    /* SGT is signed '>', GT in x86 */
>>> -#define BPF_JSGE     0x70    /* SGE is signed '>=', GE in x86 */
>>> -#define BPF_JSLT     0xc0    /* SLT is signed, '<' */
>>> -#define BPF_JSLE     0xd0    /* SLE is signed, '<=' */
>>> -#define BPF_CALL     0x80    /* function call */
>>> -#define BPF_EXIT     0x90    /* function return */
>>> +     BPF_JNE         = 0x50, /* jump != */
>>> +     BPF_JLT         = 0xa0, /* LT is unsigned, '<' */
>>> +     BPF_JLE         = 0xb0, /* LE is unsigned, '<=' */
>>> +     BPF_JSGT        = 0x60, /* SGT is signed '>', GT in x86 */
>>> +     BPF_JSGE        = 0x70, /* SGE is signed '>=', GE in x86 */
>>> +     BPF_JSLT        = 0xc0, /* SLT is signed, '<' */
>>> +     BPF_JSLE        = 0xd0, /* SLE is signed, '<=' */
>>> +     BPF_CALL        = 0x80, /* function call */
>>> +     BPF_EXIT        = 0x90, /* function return */
>>> +};
>>>
>> [...]
