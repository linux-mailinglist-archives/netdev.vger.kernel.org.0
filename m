Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7971C23D0
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 09:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgEBHRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 03:17:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12782 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726468AbgEBHRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 03:17:55 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0427H5AJ014799;
        Sat, 2 May 2020 00:17:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=c9xCL/lfOcEoAWT8nbTKNjUVyc3QQkqgKeg7Qymx2j4=;
 b=GBiCrypTiysJ0osw4EZ3HlPyPrUgPJW90z8012qlszIgfFgSKyJoHLnefpdneACIBVTJ
 I20zBvyy9wU8j++C4McWig6kjXmVFD3UjyE7gPF/ztwCRx2mAc03v8011frc3UuVR3eO
 1u7wTwrH/Rx9CtqHF6cj6Z0suHbUoREBmw0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30s46b80vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 02 May 2020 00:17:41 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 2 May 2020 00:17:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFHy88WFygGELbIhptKxPeKIKyNN9J4Bjh1Yq6JFRPNlLbbYahZyye3bImeQKqT0JMdnpb/yAn7B0Uw8Mpuwd6dxDRQ7TYD9uJjaVNLz1iFANffWFe8eH52lMdRICRbdY7pTSQPe4d1ffbAY2pPHqOs01QyqAUysWqE6dIdwOqXWHD8LtIciiorEAhyfGQ5ZkO0eVPZuc3iNyeFJhCRCwYPBUaUa+Re9mt3XYvB3n5NrnyHroRg+KbY6ixN4+55y+o9j+EscqEdaW4SV8tV7amMbGiPhkIyUPz0V8X4QEaNNsV6J+n41pZssflLBycAPveXmxGKavlp4fAX6tL9YkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9xCL/lfOcEoAWT8nbTKNjUVyc3QQkqgKeg7Qymx2j4=;
 b=XLtkLQL0d1AbJCcpStotb5Y+CesWTJK/1bIxyVzM9J+qtrveRcpiG6n1hTPpeUltzeMw0KfwSBwyc/bg0nhjwmwyhH3nC+7NFKA2qAMsb5/uTrKF2aHswuBoowTGAimcq8b1ceYR1UU+e0WiETi4JlZLlwYbvUaAvzKDiv1hPwBysDhBXvg4t3Mai2CpewH+KXK9hRUid8k6qBwDU4OqJfI69A8eb4W7oPqciFgJNGkEndzHxpHlz/OYTZxWbLaRmNzs7Yo0RdRr+BQ2VgOu3mMoFe94jyUXpqA45ZAf00j83wFE9Bmfm7/jC6Re7bhpmPR/qSp1G2Ys+g5eBPEVHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9xCL/lfOcEoAWT8nbTKNjUVyc3QQkqgKeg7Qymx2j4=;
 b=Z5ZkTtObClL/Au5WawhiChcAc8K1I0IJdsRp4tvGYZ011Vib/DuR6Fu45xwtzz2dEHjERmdr+7nRdKPM3oqh4zyF/quw3XlluPlqFugoEUQq5lhAyb3xevlvC3bIBIWaTNYVoQ1u5gmgIewrENSLrngxYYrDRcgXtbN+MRSOTCc=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2261.namprd15.prod.outlook.com (2603:10b6:a02:8e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sat, 2 May
 2020 07:17:26 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.027; Sat, 2 May 2020
 07:17:26 +0000
Subject: Re: [PATCH bpf-next v1 15/19] tools/libbpf: add bpf_iter support
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201252.2996037-1-yhs@fb.com>
 <CAEf4BzZKaBpQfohsWcF5qJpMU96vxDVniaPie=54Gx6kK66KQw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d27a42f2-47a6-e12b-56c0-13c447ce15d1@fb.com>
Date:   Sat, 2 May 2020 00:17:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzZKaBpQfohsWcF5qJpMU96vxDVniaPie=54Gx6kK66KQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::45) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:29a8) by BYAPR02CA0032.namprd02.prod.outlook.com (2603:10b6:a02:ee::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Sat, 2 May 2020 07:17:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:29a8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc39031e-e3ab-46e8-297e-08d7ee68ddac
X-MS-TrafficTypeDiagnostic: BYAPR15MB2261:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB226112F9D0A8450518BB824BD3A80@BYAPR15MB2261.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 039178EF4A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(52116002)(2616005)(16526019)(6916009)(8936002)(5660300002)(6512007)(8676002)(31686004)(54906003)(6486002)(31696002)(4326008)(316002)(66476007)(66556008)(478600001)(36756003)(6506007)(53546011)(2906002)(186003)(66946007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: meunBZkiuv+QEj2BKCreXRTawgLtSKbex/rwanGV/Bp+4IUsUAiF/g3UvabIClNwIpHI+YmwpukxjkJtbO0hCR0TAZlQrsZCo99QvLv01SM8t0DTyd6PnFsm66KxaPsL0xBdiyn+5bcu6+Hs09ZfTJxUKl5vZV2Kyv0iSaa5IBdu0+zFKx/YKzSI36AfSdH4Lu3G6uhGrwD9H1OyALl37Z+zy+yLbOLZe341CxxOBfC76iPaTghYLglWM1xd5GGfWD3fKR/p+wF4k233igmmGxP7lovVMMpmW6tDwCMEYFnxPwdIyfL+yB4KzDkL+9YrN+Z7jk9lPmCqyjXDyVTzyBl/J0bFMAAOuf3Wi376NPikFvAWCBs3xYpAda3RniMFIdQCe46zbxUl27zyY3SrRJr9qdm70Kf2F/U96gES1X+LOnc029fu/icS0vvVjqr6
X-MS-Exchange-AntiSpam-MessageData: 2AOqWKZq0qfv7nGC3cwTHkf3zwQ0S4/NvVB0gH+tU/GEr3V6hJbrCUwRSw//j8cshylcAaEcwRcN6GawJ3rVhr7e8QfiNIFYtMBtKhmArgq9BH7KHSnu/WBriq/gLy75Yr/rTZgCjCd8hsEq/W9zeUHEm1zddMMCb5lQ+9WQgaClOfcpL2Q366HNNOlYHm+60Xoh81eAE3NLcHd23zEtN2Y9WAbIq4opHToB6fFpDVuRP86hswMFJn7fGAGQgH0w4d5+gHXJEoHLqCveDg7mOw6SzTDEf5+9zwT9mhue/3YPdCv44Lz6FegsAhyvb5ztkxvE2Ba3gCKz8sAMeStkwSk08bU+S9VFgDvK7SmoJfrLKq3S3vmh+jhiYxASmIQv5kgmRHvfKuXhiii0I8x/QLTqmtkYOQ8RT+yQJyMwIQl/Dkt7uufqJVuiNjyqjxvoh+jrsb1woXI+OqDiO5rHko6Nxfy0T0FQsacghtspOGYJEeQG3avHDD9g9kaixowsK/qWszTAS13GLT8JPiN4FdvJ5jRmkdCBz7vV9FrBNtY+6MI5Et2X/DbF0XXfR8QHOQD0wvfksQ4mAW4C/JCPnLZcKEuOlb8xTJbSRzonWuOstNn3KBrIk5TTkJ3+2qJnqtropuM1/Ej1NZZd8ZfnbUDUFdOvfkj4XZUBW5tpan3+EfKDuCig8yu5u1PwO7OT0+M0HBLOvLv20bn3yMS+HIjsh5dzHGy18xXRRSwgxxrl0nM7DfvPsv/dGtBO7FtI6le31dx78DDHqTZLfLXsEt2deHpmSJxSRv02o6dojyzGvDF+OIMLcwEA7rQ1MGRuQRgUD+CvdQbnFRb8tBpdAA==
X-MS-Exchange-CrossTenant-Network-Message-Id: cc39031e-e3ab-46e8-297e-08d7ee68ddac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2020 07:17:26.2229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KWaZonlTw0xtDFFOlwu1zXrdm8Uvq3ASZUztDjLOVS5GnlLl2U1xGHZhvsqnREBb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2261
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-02_03:2020-05-01,2020-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005020063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 6:41 PM, Andrii Nakryiko wrote:
> On Mon, Apr 27, 2020 at 1:17 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Three new libbpf APIs are added to support bpf_iter:
>>    - bpf_program__attach_iter
>>      Given a bpf program and additional parameters, which is
>>      none now, returns a bpf_link.
>>    - bpf_link__create_iter
>>      Given a bpf_link, create a bpf_iter and return a fd
>>      so user can then do read() to get seq_file output data.
>>    - bpf_iter_create
>>      syscall level API to create a bpf iterator.
>>
>> Two macros, BPF_SEQ_PRINTF0 and BPF_SEQ_PRINTF, are also introduced.
>> These two macros can help bpf program writers with
>> nicer bpf_seq_printf syntax similar to the kernel one.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   tools/lib/bpf/bpf.c         | 11 +++++++
>>   tools/lib/bpf/bpf.h         |  2 ++
>>   tools/lib/bpf/bpf_tracing.h | 23 ++++++++++++++
>>   tools/lib/bpf/libbpf.c      | 60 +++++++++++++++++++++++++++++++++++++
>>   tools/lib/bpf/libbpf.h      | 11 +++++++
>>   tools/lib/bpf/libbpf.map    |  7 +++++
>>   6 files changed, 114 insertions(+)
>>
>> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>> index 5cc1b0785d18..7ffd6c0ad95f 100644
>> --- a/tools/lib/bpf/bpf.c
>> +++ b/tools/lib/bpf/bpf.c
>> @@ -619,6 +619,17 @@ int bpf_link_update(int link_fd, int new_prog_fd,
>>          return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
>>   }
>>
>> +int bpf_iter_create(int link_fd, unsigned int flags)
> 
> Do you envision anything more than just flags being passed for
> bpf_iter_create? I wonder if we should just go ahead with options
> struct here?

I think most, if not all, parameters should go to link create.
This way, we can have the identical anon_iter through:
    link -> anon_iter
    link -> pinned file -> anon_iter

I do not really expect any more fields for bpf_iter_create.
The flags here is for potential future extension, which I
have no idea how it looks like.

> 
>> +{
>> +       union bpf_attr attr;
>> +
>> +       memset(&attr, 0, sizeof(attr));
>> +       attr.iter_create.link_fd = link_fd;
>> +       attr.iter_create.flags = flags;
>> +
>> +       return sys_bpf(BPF_ITER_CREATE, &attr, sizeof(attr));
>> +}
>> +
> 
> [...]
> 
>> +/*
>> + * BPF_SEQ_PRINTF to wrap bpf_seq_printf to-be-printed values
>> + * in a structure. BPF_SEQ_PRINTF0 is a simple wrapper for
>> + * bpf_seq_printf().
>> + */
>> +#define BPF_SEQ_PRINTF0(seq, fmt)                                      \
>> +       ({                                                              \
>> +               int ret = bpf_seq_printf(seq, fmt, sizeof(fmt),         \
>> +                                        (void *)0, 0);                 \
>> +               ret;                                                    \
>> +       })
>> +
>> +#define BPF_SEQ_PRINTF(seq, fmt, args...)                              \
> 
> You can unify BPF_SEQ_PRINTF and BPF_SEQ_PRINTF0 by using
> ___bpf_empty() macro. See bpf_core_read.h for similar use case.
> Specifically, look at ___empty (equivalent of ___bpf_empty) and
> ___core_read, ___core_read0, ___core_readN macro.

Thanks for the tip. Will try.

> 
>> +       ({                                                              \
>> +               _Pragma("GCC diagnostic push")                          \
>> +               _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
>> +               __u64 param[___bpf_narg(args)] = { args };              \
> 
> Do you need to provide the size of array here? If you omit
> __bpf_narg(args), wouldn't compiler automatically calculate the right
> size?
> 

Yes, compiler should calculate correct size.

> Also, can you please use "unsigned long long" to not have any implicit
> dependency on __u64 being defined?

Will do.

> 
>> +               _Pragma("GCC diagnostic pop")                           \
>> +               int ret = bpf_seq_printf(seq, fmt, sizeof(fmt),         \
>> +                                        param, sizeof(param));         \
>> +               ret;                                                    \
>> +       })
>> +
>>   #endif
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 8e1dc6980fac..ffdc4d8e0cc0 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -6366,6 +6366,9 @@ static const struct bpf_sec_def section_defs[] = {
>>                  .is_attach_btf = true,
>>                  .expected_attach_type = BPF_LSM_MAC,
>>                  .attach_fn = attach_lsm),
>> +       SEC_DEF("iter/", TRACING,
>> +               .expected_attach_type = BPF_TRACE_ITER,
>> +               .is_attach_btf = true),
> 
> It would be nice to implement auto-attach capabilities (similar to
> fentry/fexit, lsm and raw_tracepoint). Section name should have enough
> information for this, no?

In the current form, yes, auto attach is possible.
But I am thinking we may soon have additional information
like map_id (appear in link_create) etc.
to make auto attach not possible. That is why
I implemented an explicit attach. is this assessment correct?

> 
>>          BPF_PROG_SEC("xdp",                     BPF_PROG_TYPE_XDP),
>>          BPF_PROG_SEC("perf_event",              BPF_PROG_TYPE_PERF_EVENT),
>>          BPF_PROG_SEC("lwt_in",                  BPF_PROG_TYPE_LWT_IN),
>> @@ -6629,6 +6632,7 @@ static int bpf_object__collect_struct_ops_map_reloc(struct bpf_object *obj,
>>
> 
> [...]
> 
>> +
>> +       link = calloc(1, sizeof(*link));
>> +       if (!link)
>> +               return ERR_PTR(-ENOMEM);
>> +       link->detach = &bpf_link__detach_fd;
>> +
>> +       attach_type = bpf_program__get_expected_attach_type(prog);
> 
> Given you know it has to be BPF_TRACE_ITER, it's better to explicitly
> specify that. If provided program wasn't loaded with correct
> expected_attach_type, kernel will reject it. But if you don't do it,
> then you can accidentally create some other type of bpf_link.

Yes, will do.

> 
>> +       link_fd = bpf_link_create(prog_fd, 0, attach_type, NULL);
>> +       if (link_fd < 0) {
>> +               link_fd = -errno;
>> +               free(link);
>> +               pr_warn("program '%s': failed to attach to iterator: %s\n",
>> +                       bpf_program__title(prog, false),
>> +                       libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
>> +               return ERR_PTR(link_fd);
>> +       }
>> +       link->fd = link_fd;
>> +       return link;
>> +}
>> +
>> +int bpf_link__create_iter(struct bpf_link *link, unsigned int flags)
>> +{
> 
> Same question as for low-level bpf_link_create(). If we expect the
> need to extend optional things in the future, I'd add opts right now.
> 
> But I wonder if bpf_link__create_iter() provides any additional value
> beyond bpf_iter_create(). Maybe let's not add it (yet)?

The only additional thing is better warning messsage.
Agree that is so marginal. Will drop it.

> 
>> +       char errmsg[STRERR_BUFSIZE];
>> +       int iter_fd;
>> +
>> +       iter_fd = bpf_iter_create(bpf_link__fd(link), flags);
>> +       if (iter_fd < 0) {
>> +               iter_fd = -errno;
>> +               pr_warn("failed to create an iterator: %s\n",
>> +                       libbpf_strerror_r(iter_fd, errmsg, sizeof(errmsg)));
>> +       }
>> +
>> +       return iter_fd;
>> +}
>> +
> 
> [...]
> 
