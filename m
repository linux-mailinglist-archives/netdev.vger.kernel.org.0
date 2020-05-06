Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDB41C7CBF
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgEFVmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:42:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728888AbgEFVmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:42:36 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046Lf24f026212;
        Wed, 6 May 2020 14:42:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2ir3gJsEfo351PRe9wKeV/RqMRKt0+C5atEITt1f0gs=;
 b=YTiTWfpUO4Cenw7cipDJTOZ+7NgqZUBD/1md05RE7lMftDBUanmywoTKs1Jjg66XuTx0
 0pWRJsO/8D/+Uxwe3bnP/nWQtGheMXpq6UctSGBRUVFPM98ucvjGFX+U6q+aOANIT6Ld
 WOi08XLuvAKiYUw7wRBL8061xm2HV0g4nSA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30ss0x3tr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 14:42:21 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 14:42:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZAOPTOeI+7luEp4/YrRHk8nQDu+1RyZCSvBhigs8/bJkoeJ/xsGNY0ZvmaMsDgkQOccOCb1BIlarXOLix4GSxKoZ3IQkW4mZoPh31l6J06XJRoDwoB6LpFn8VH8Y1d7GJcJeItCUAcuB7Fm5vcAPR6jpHPsYkYplr2q5ssBjE1R2VNlnEwKysnbsCosbB1AaxJ2EJ5ci4Ky2JcUeB3bpu1/a1tWO4H3iblvDVToie/rNZF98uKpgbc5sGmgeiGIzW2riFLcx6DlE2gANJqWzx+5315AiEe9Oj5aNjyacxF8k/d+GQtqujEMXPu/Lpcfo4nnwnQ+BpoUUMLpfnSpyxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ir3gJsEfo351PRe9wKeV/RqMRKt0+C5atEITt1f0gs=;
 b=BLDbJ2smNihszckGe3SJI/WbCpZtEjsaMjb+wnME0VZ3MJtIl8bf/2qgTuraw9tuCqGu1AlOsWRLdJjv1cmAuYMyCAIPOW5kD/XDAU2NMZlMjgciZ0brPupVIr4iBcv9qjgtZRD+tbokPliK6NSHXo72qLxSMbeSj5tU/pA2xTafcssy0r/7oY4qh0y5NqFa3RvY1wWcjEXuK5S/C8naTzoJieBvh4i3NBTECSodC4iIClVKyVhAjdAMFqc6D2877xALXlf1NnYZQiwwuPrL6XF22Ael+ewaUyQy8smg1E41aCC87bPOHMJC2mdzzGYurYBBg/6zeHJakY5zrNWFsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ir3gJsEfo351PRe9wKeV/RqMRKt0+C5atEITt1f0gs=;
 b=TqwtCHDCitfAG8DweZxq830DKxQy2QLFrub+lRnzmK20qSKIJRGMljUJRlOrrwLEE4Ri5l8VJZX06ToTazkFpVczGiOAu7zTvvJj661UsTTdIUFHP0w+2N3iNe3PvXHQesOb+KdS7sAG2Fy27bkhEOq66kVULVuIadLIhbJVIvg=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2855.namprd15.prod.outlook.com (2603:10b6:a03:b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 6 May
 2020 21:42:17 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 21:42:17 +0000
Subject: Re: [PATCH bpf-next v2 13/20] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062602.2048597-1-yhs@fb.com>
 <CAEf4Bzb-COkgcLB=HK4ahtnEFD7QGY0s=Qb-kWTBKK56319JAg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <71cff8d8-05b9-87ef-8a12-1da3e38c4b55@fb.com>
Date:   Wed, 6 May 2020 14:42:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bzb-COkgcLB=HK4ahtnEFD7QGY0s=Qb-kWTBKK56319JAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::44) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:66a9) by BYAPR05CA0103.namprd05.prod.outlook.com (2603:10b6:a03:e0::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.17 via Frontend Transport; Wed, 6 May 2020 21:42:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:66a9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69d0b262-12ca-4501-a974-08d7f20658ef
X-MS-TrafficTypeDiagnostic: BYAPR15MB2855:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB285587CB2DDBB53DC9A1FC86D3A40@BYAPR15MB2855.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PcEvygcAeJmZmklWLk8ggAKxXBX0Neiy6bHXDBiW7ELUsyEGKNHa9aBFRkcOqQneE4CVGS1cgEGK+f73EUfy2WIQrHzOdxRZIQoFYagXUEEkAu2u9E5vEPpoXtI2nFJIy8CcDfgKqiSVLH9JlbC0Edleqtn6or4CtmgNvh+j+InRrY9tYfKihQVs6+hi3PVhLBs6reHv1QGMkatgqd1YkTr0n6nbLHFC1sclit//5v8vGiURzev9hz/3f9mlJ4Yxmj8pJhYHnq7tbUGYhXgVDKWE0QCjJswg4C3O4kf3m/oGA8VtkooY8ihm8N7kky1rT8Ao1zsnewVpQNLJ8GtfLih6t5Sy/w3UaLOcma8O0Gi9op/m/Nugwt8Ce17ka3QbY/h5C5qXYDkhR7OEVTzTIRTz2ZNIYQAdxgx4NrH+JyhGohW44dkUME8SoH9k90nmzDqE22f0a5Yo+4uOtWt3FIIb0oyUhnsQO8y8+1mRChx4YyUXLA7Vo1Y8OZYG0sJuAr9YxSuoDydmQH/IjK/X22tMbyNZ/FUHwB/MLEZ4B1Jo6nC95A4oYAk9zAf63GeD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(39860400002)(376002)(136003)(396003)(33430700001)(66946007)(66556008)(8936002)(66476007)(36756003)(316002)(33440700001)(54906003)(8676002)(86362001)(6486002)(6916009)(2616005)(4326008)(31686004)(478600001)(53546011)(52116002)(16526019)(6512007)(186003)(2906002)(6506007)(31696002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: luMABwrrlZr438f64l0IrnCEoP5P6/b5qXxjei1rsigeSPCOKinNnNLNU3WKM0T7sy5xm4rrEnIhMkDRWD40XHhFMh95XH0y0vHKdXxvt1y7qiYNWNeNZGydcVQmp8FoHddt6GZuzPUmbGqUzwDTV1EwCIc9f+yRSRc94PMf2QPZ93jhl8cd0w46uigZzNngULEuL46zN07zOlM2fi8ZKwfSmWrt1mfgPVh4s9gRfZQ/GHgCNzQSVMOi4oMD0XHMfIGw5mfjAlXMCIKS7TvcV0G+xgEyvaiNjFEk4AwsPQtjQxwJO8GWUkc5cO5ltMpOxI8UcigwwwdJ+/wEiQKO6gl7vTabBoh69T3bFLPrHDjDk3I7svf8H8oq3MfWuEpvgilsgMd/g46Q7UNefwXS/5Oqzykug3/oC8wbAE9U+kFVc9SjOp583T9kauXIsnHToO/m7TFe5QYGHNjyZessNE+eOnWIH2X4GVRU3njylPJyKNLEHlnUnHAswOuvbJJGRmV3T53B3FB22lTIFw0oQrtF44bJjTIwKXSP0CZ49b2xe2iTDBxbK5AP7ecGk0jqAfI5T0mDq3TUhcwPUFk7KBlpXH6sPBWz+8DxUvASUty6Ang4AylTQ/QcqMz2CivtxNL4do3uda/+mwan8XjxJzZfvpTgKjlyxsDS42AkCvZYEoONhj6Te/884rEA0117Vh14IETvWw9Sr7KguC/mRxNKYLC+ZTr/5+1LSQBMxDTO/D9R/k9LaUVDW/7JcfQhsoBWnbtuvv2K6adE/DUFFWJkw0uxyLSTjvU42zgYw+Fmu+Vtx5bYqC7NOd8nlsOBzF3Dg4kdaLDo8LvJhT21Ng==
X-MS-Exchange-CrossTenant-Network-Message-Id: 69d0b262-12ca-4501-a974-08d7f20658ef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 21:42:17.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1LezVlEj6gvBjpgg/jpDhNEPoKvCdYnyb4tEy5hWtVVU8ItpuOPhxYddRGr5uNJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2855
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005060174
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/20 10:37 AM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Two helpers bpf_seq_printf and bpf_seq_write, are added for
>> writing data to the seq_file buffer.
>>
>> bpf_seq_printf supports common format string flag/width/type
>> fields so at least I can get identical results for
>> netlink and ipv6_route targets.
>>
> 
> Does seq_printf() has its own format string specification? Is there
> any documentation explaining? I was confused by few different checks
> below...

Not really. Similar to bpf_trace_printk(), since we need to
parse format string, so we may only support a subset of
what seq_printf() does. But we should not invent new
formats.

> 
>> For bpf_seq_printf and bpf_seq_write, return value -EOVERFLOW
>> specifically indicates a write failure due to overflow, which
>> means the object will be repeated in the next bpf invocation
>> if object collection stays the same. Note that if the object
>> collection is changed, depending how collection traversal is
>> done, even if the object still in the collection, it may not
>> be visited.
>>
>> bpf_seq_printf may return -EBUSY meaning that internal percpu
>> buffer for memory copy of strings or other pointees is
>> not available. Bpf program can return 1 to indicate it
>> wants the same object to be repeated. Right now, this should not
>> happen on no-RT kernels since migrate_enable(), which guards
>> bpf prog call, calls preempt_enable().
> 
> You probably meant migrate_disable()/preempt_disable(), right? But

Yes, sorry for typo.

> could it still happen, at least due to NMI? E.g., perf_event BPF
> program gets triggered during bpf_iter program execution? I think for
> perf_event_output function, we have 3 levels, for one of each possible
> "contexts"? Should we do something like that here as well?

Currently bpf_seq_printf() and bpf_seq_write() helpers can
only be called by iter bpf programs. The iter bpf program can only
be run on process context as it is triggered by a read() syscall.
So one level should be enough for non-RT kernel.

For RT kernel, migrate_disable does not prevent preemption,
so it is possible task in the middle of bpf_seq_printf() might
be preempted, so I implemented the logic to return -EBUSY.
I think this case should be extremely rare so I only implemented
one level nesting.

> 
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/uapi/linux/bpf.h       |  32 +++++-
>>   kernel/trace/bpf_trace.c       | 195 +++++++++++++++++++++++++++++++++
>>   scripts/bpf_helpers_doc.py     |   2 +
>>   tools/include/uapi/linux/bpf.h |  32 +++++-
>>   4 files changed, 259 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 97ceb0f2e539..e440a9d5cca2 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3076,6 +3076,34 @@ union bpf_attr {
>>    *             See: clock_gettime(CLOCK_BOOTTIME)
>>    *     Return
>>    *             Current *ktime*.
>> + *
> 
> [...]
> 
>> +BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
>> +          const void *, data, u32, data_len)
>> +{
>> +       int err = -EINVAL, fmt_cnt = 0, memcpy_cnt = 0;
>> +       int i, buf_used, copy_size, num_args;
>> +       u64 params[MAX_SEQ_PRINTF_VARARGS];
>> +       struct bpf_seq_printf_buf *bufs;
>> +       const u64 *args = data;
>> +
>> +       buf_used = this_cpu_inc_return(bpf_seq_printf_buf_used);
>> +       if (WARN_ON_ONCE(buf_used > 1)) {
>> +               err = -EBUSY;
>> +               goto out;
>> +       }
>> +
>> +       bufs = this_cpu_ptr(&bpf_seq_printf_buf);
>> +
>> +       /*
>> +        * bpf_check()->check_func_arg()->check_stack_boundary()
>> +        * guarantees that fmt points to bpf program stack,
>> +        * fmt_size bytes of it were initialized and fmt_size > 0
>> +        */
>> +       if (fmt[--fmt_size] != 0)
> 
> If we allow fmt_size == 0, this will need to be changed.

Currently, we do not support fmt_size == 0. Yes, if we allow, this
needs change.

> 
>> +               goto out;
>> +
>> +       if (data_len & 7)
>> +               goto out;
>> +
>> +       for (i = 0; i < fmt_size; i++) {
>> +               if (fmt[i] == '%' && (!data || !data_len))
> 
> So %% escaping is not supported?

Yes, have not seen a need yet my ipv6_route/netlink example.
Can certain add if there is a use case.

> 
>> +                       goto out;
>> +       }
>> +
>> +       num_args = data_len / 8;
>> +
>> +       /* check format string for allowed specifiers */
>> +       for (i = 0; i < fmt_size; i++) {
>> +               if ((!isprint(fmt[i]) && !isspace(fmt[i])) || !isascii(fmt[i]))
> 
> why these restrictions? are they essential?

This is the same restriction in bpf_trace_printk(). I guess the purpose
is to avoid weird print. To promote bpf_iter to dump beyond asscii, I 
guess we can remove this restriction.

> 
>> +                       goto out;
>> +
>> +               if (fmt[i] != '%')
>> +                       continue;
>> +
>> +               if (fmt_cnt >= MAX_SEQ_PRINTF_VARARGS) {
>> +                       err = -E2BIG;
>> +                       goto out;
>> +               }
>> +
>> +               if (fmt_cnt >= num_args)
>> +                       goto out;
>> +
>> +               /* fmt[i] != 0 && fmt[last] == 0, so we can access fmt[i + 1] */
>> +               i++;
>> +
>> +               /* skip optional "[0+-][num]" width formating field */
>> +               while (fmt[i] == '0' || fmt[i] == '+'  || fmt[i] == '-')
> 
> There could be space as well, as an alternative to 0.

We can allow space. But '0' is used more common, right?

> 
>> +                       i++;
>> +               if (fmt[i] >= '1' && fmt[i] <= '9') {
>> +                       i++;
>> +                       while (fmt[i] >= '0' && fmt[i] <= '9')
>> +                               i++;
>> +               }
>> +
>> +               if (fmt[i] == 's') {
>> +                       /* disallow any further format extensions */
>> +                       if (fmt[i + 1] != 0 &&
>> +                           !isspace(fmt[i + 1]) &&
>> +                           !ispunct(fmt[i + 1]))
>> +                               goto out;
> 
> I'm not sure I follow this check either. printf("%sbla", "whatever")
> is a perfectly fine format string. Unless seq_printf has some
> additional restrictions?

Yes, just some restriction inherited from bpf_trace_printk().
Will remove.

> 
>> +
>> +                       /* try our best to copy */
>> +                       if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
>> +                               err = -E2BIG;
>> +                               goto out;
>> +                       }
>> +
> 
> [...]
> 
>> +
>> +static int bpf_seq_printf_btf_ids[5];
>> +static const struct bpf_func_proto bpf_seq_printf_proto = {
>> +       .func           = bpf_seq_printf,
>> +       .gpl_only       = true,
>> +       .ret_type       = RET_INTEGER,
>> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
>> +       .arg2_type      = ARG_PTR_TO_MEM,
>> +       .arg3_type      = ARG_CONST_SIZE,
> 
> It feels like allowing zero shouldn't hurt too much?

This is the format string, I would prefer to keep it non-zero.

> 
>> +       .arg4_type      = ARG_PTR_TO_MEM_OR_NULL,
>> +       .arg5_type      = ARG_CONST_SIZE_OR_ZERO,
>> +       .btf_id         = bpf_seq_printf_btf_ids,
>> +};
>> +
>> +BPF_CALL_3(bpf_seq_write, struct seq_file *, m, const void *, data, u32, len)
>> +{
>> +       return seq_write(m, data, len) ? -EOVERFLOW : 0;
>> +}
>> +
>> +static int bpf_seq_write_btf_ids[5];
>> +static const struct bpf_func_proto bpf_seq_write_proto = {
>> +       .func           = bpf_seq_write,
>> +       .gpl_only       = true,
>> +       .ret_type       = RET_INTEGER,
>> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
>> +       .arg2_type      = ARG_PTR_TO_MEM,
>> +       .arg3_type      = ARG_CONST_SIZE,
> 
> Same, ARG_CONST_SIZE_OR_ZERO?

This one, possible. Let me check.

> 
>> +       .btf_id         = bpf_seq_write_btf_ids,
>> +};
>> +
> 
> [...]
> 
