Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890013FE619
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhIAXav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 19:30:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3642 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240891AbhIAXat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 19:30:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 181NTUWA031642;
        Wed, 1 Sep 2021 16:29:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=daPS3UIkttTn9m9mxiteAZoO8zktodQmaKexnte7qPA=;
 b=LDXxVb0QCzkL4anzTAm/fd0YI6g9kjb0yDswri2K/Aqx2Yyuz7nTj48VWHoYXrp89Cd/
 GPUxhsakMvTOE8KEMAFiC1/muTOkWNcet7M7rdeTWNLQJ8hskrd23Yovv0L/uLVSQ61s
 YJ5aiASinCQglzy1nAEnlWmOVeggmAbQamY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ate08vvmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Sep 2021 16:29:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 1 Sep 2021 16:29:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cejqx09jjfmzLUXh7CV0wRYe9EQ7A1aOdsq+QeZlbmSFss4tXLW08zL3mgu7OWcBZ3BsSCaItdAK9ge9E4APAlp3ieoqXIgppY7Gj9tvWvJyTXdLow5y6cJ98LJtqj1VZrcc4YHuqDw/pUJXv5nTx8bH8aoiSULDWJtN1NY4d+GlzJk5cDXFnOhBZpR5vyIaYcveWYRHpsY0YaiQqz9oKL+nan5Au+/CoPRVisqya+9UBNFHInt5LNmln+HpQMDSsiizys3Ft16ciqNRdoiGq26oKEkUeYXnYu9Q+RmKw5gvx68vFRTsSfPO5eKRVxqNxO3wIo+TBW9zfK6wIVuPGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=daPS3UIkttTn9m9mxiteAZoO8zktodQmaKexnte7qPA=;
 b=UZIndDSvA9vjwEzNeg4B7dHJT2KuWJ6d6qvl5BUZ1XLwOXpFvOn6uxnwFKBUw8QjmjQI0W4NM8w3i+qSU0k5DWoRssEhg8kGRYSqiYzhhH2NECq67p/3IXqiC5VS1q4rfQPpMr80EWf5cVeKT6jjZbONA+hLIFL4zPJMceXh+0mlw44LeOCcZd1f+mC47W3ZIPhQiJmv5LHFHi7wwY/0vqTn1qT90bBZEohiQlpeFaF/8wwt2Ec0lXxD8FhexOBJc5Rk2pQ6RDZU+Y+WZquORAa6jn3ISqyXi1VApdloee/AOxZGjhiK0VcC9pkd3dHugbpxQaQjW2n9Us94jMgm2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM5PR15MB1259.namprd15.prod.outlook.com (2603:10b6:3:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Wed, 1 Sep
 2021 23:29:31 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6%7]) with mapi id 15.20.4457.024; Wed, 1 Sep 2021
 23:29:31 +0000
Message-ID: <f4bd93de-14e1-855d-eb31-1de4697ce7d7@fb.com>
Date:   Wed, 1 Sep 2021 19:29:28 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.0.3
Subject: Re: [PATCH v2 bpf-next 3/6] libbpf: Modify bpf_printk to choose
 helper based on arg count
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
References: <20210825195823.381016-1-davemarchevsky@fb.com>
 <20210825195823.381016-4-davemarchevsky@fb.com>
 <CAEf4BzaNH1vRQr5jZO_m3haUaV5rXKiH5AJLFrM5iwbkEja=VQ@mail.gmail.com>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <CAEf4BzaNH1vRQr5jZO_m3haUaV5rXKiH5AJLFrM5iwbkEja=VQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: BL1PR13CA0432.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::17) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPV6:2620:10d:c0a8:11d1::130a] (2620:10d:c091:480::1:1928) by BL1PR13CA0432.namprd13.prod.outlook.com (2603:10b6:208:2c3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.11 via Frontend Transport; Wed, 1 Sep 2021 23:29:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29227a7a-7007-42c7-c007-08d96da059b4
X-MS-TrafficTypeDiagnostic: DM5PR15MB1259:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR15MB1259D9F2E2ADD271EF545A6FA0CD9@DM5PR15MB1259.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqoV5pWDyRj2QL3PhBrZcWGxvu/5j/8g2wouex/u460ieNC9w6BH78GWwzfO6sQpv+8LDt2mOtzMR+Jl+AcVhODm8LnMuzdjoz+76ZxytUxQGDs0gIQeOQ843ZT99ySVa56oIbNW7FuZBeX4c31nddXESwksMQxc8tw7B4ZbaJLw8IxUiTbPqUd5Kbls7uFY6ctI7ZC7m0VwYhw0KbvPo0DZx6W6VZo4ws8K1ZWRfsWdFXOa7wG7vZFQVz2U6iTqWZstSZLSdMIdtbggEULZMo44zaRnmzu1KHeGyCQio9MZR8IrNwPFSwKvkJJO1EPGZ+D7SUScr4AYotbD4qLOvT65u8D1ldvFwDH6r5P8Zc+KPlz187FRjo/SVV5bu2Lpot+3g/H7hZzLZ3WAEKmg9TaMcFbYmmEGNHKqAd4wruRVbD+QNW0l3VTnX563rgBmtJX7Gjvhz5nslkbBJFHILz09bwkR7xbsVmKONoXc+ePY7qYOm482AuwhruV756GDEBMBl2xvUm14PraPcO4PU5rhtNGXb3L3f2Jn/bVTChk46bpjb6RZW7H8tWOO0G1PPTPK9N6TJcYaUbImRmUIcG6w3wOp9rIAoJBoGgCsZds/hGX+Mw6j4lqw10608p8JRqhbYilGCjGNDfEVF3MGhGOpCD7yqNuLaCQgohrU4bwXL1vslrtQ4ErEQdKi2efzVsZvH9YgigqD2So+htSqN2EUvXCcVCm1IDf1AoIXUm68njF0bY5HJ2EXf94jvEWryz9f3mPsDsw41p9nn+zIj5IAtaeaJwiLzQVrgiv5Od78qCxl8e09JCUtaCu6miUB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(2616005)(54906003)(478600001)(2906002)(53546011)(8676002)(83380400001)(36756003)(316002)(8936002)(52116002)(4326008)(6666004)(186003)(66946007)(6486002)(5660300002)(66556008)(66476007)(966005)(38100700002)(6916009)(31696002)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWRaRjZ4TVorV2VFRGlIRWJ1em1TK2Z0cXQrN1RpUlB6bHIzTG14NDdoZ2Zo?=
 =?utf-8?B?Z0lrOUhJKytqM2NpL21PdkVZQk0xb3d6dHVnaFV6OVRHaDhQWThWbHJYZDFU?=
 =?utf-8?B?cGtyRWxhUUp3V1BtakRnWndPblh4MnJ3eFN4ME5hQkJ3MDMrUGZ2b1FtWWx1?=
 =?utf-8?B?WDJqRVJ1YjNOY2RkYUNHNVhrNmR6Qm5nVktRWUpoQTNPamJvMldIb0dIS3h3?=
 =?utf-8?B?N3lQQndHdXlqNW05R0dRRnJyM0hoQi9Db2RaVDh4d1k4Zk5pU1BrM2loeWVG?=
 =?utf-8?B?OU5idEtURGdJUG5Vam14a0hTeVhaMGRnSjRIaDZaVlJpUEVob3krUzU0ankr?=
 =?utf-8?B?YjNiejZxSEpTSWp6eDlxUEhIbUdJclVqSUlFY0FrWG0ybFZVMVhwcitud25K?=
 =?utf-8?B?a09RT3VqcDZXQUYxOW1Cd0Y1cS9zSmpzVFQvUGplTGh4bC9IUE5DeE9zUHFh?=
 =?utf-8?B?cUNkN1JGdCtxOFUxejZEQ1M4Nnc2dXllam5LMnpXdC9Ea3N5Z1F6c3ZPRDM1?=
 =?utf-8?B?VHQzQVJJU1BTNmlERnBCZEIxNVd6VkwrZnBvQkZZRGxlRi9yaGdvZTlTTWRk?=
 =?utf-8?B?SWEwbU4rcWpBNm5pUkdVWitkZDd6OG91T1huYTg4SlRGNUkrenZUUjlGYnlF?=
 =?utf-8?B?a3Znd1h3K1VudEVVV20rUEFIc2lnT25YY2phVVVqUS8xYzJ0alN2MTgyaStu?=
 =?utf-8?B?VUxzTmxUYXByYTdWN2tJL01Yd1Q1ODZXc0xMUDVRUG9PQ2VzVWxBeWMvbUMy?=
 =?utf-8?B?WVBnYXRweDBIeXBlcmtTYUE4LzhkVkhicGpjb0ZMbjNxNHpkbTd4ZG43WEZG?=
 =?utf-8?B?a0lzS3g0ZmQxTGNoR3FUYWc4UmoyRk5BeXl0VVZCVHFqMk1XQVdGemEyM0oz?=
 =?utf-8?B?RzNMS09icmVkYVNiQ3krdmFQb3puVDU4cThCZHNWVU1kSHVHQWU5bmRPWWtQ?=
 =?utf-8?B?N2J6T0tKUjFuTStjS2VXTVhxblNjeGlCTWNUSXkxR3hVeWJTU2Y4ZlhyWHVV?=
 =?utf-8?B?SWpRQm53d016b0J3UlFvelg0NTJOZXFLZlBlTEEwQWxHclZCYWtBemwyalNE?=
 =?utf-8?B?VjJaNjhuWXJ1MGxYY1U3L0RHWTlFbndESTZtTGExZS9mZFZ5UVBaaGYwV0l4?=
 =?utf-8?B?VEt4RnN5Mlg0M0lNTk1MSDI5SlNVcFNGT2E4cjZteEZDeE8yaXp3VUFWQWdS?=
 =?utf-8?B?b3B3MFc2RTgxRjhuZFNPMGtTKzMxSmJjOGw4Smx2M0hoVi9Mc0lra1NiTnpB?=
 =?utf-8?B?M2RUWWxQOXU1ODFSalJYa1Z2aFVCWGwrMnFDUkFLR2dqeVQ5YXVlSFRjMENF?=
 =?utf-8?B?UC9JeGp6S3d0elBEbEZnZ2FyVGc3UzZVUlBQUmVORzdQdFQzdjZma3ZUT2FX?=
 =?utf-8?B?c1VEZGFCN1NDY01xaDN0SXl3MzZxZnJYZGpmTTNBdmdubUw2bURIL0Q3R2Fk?=
 =?utf-8?B?Wm80UXJRQTFxYkltRGROUkpVcVlhQWpFZ0c5ZHhIcTVUeEIycE02emp3dEhn?=
 =?utf-8?B?Y1hoV21STEs0YU5MdlhJODRPSnI2Um8rdzMzaDVRUEk1UjVzdjRNUlJYNFVN?=
 =?utf-8?B?Mlk3QTN1R0NISVdJbFhHclJheDJ1OVdYSFhOekFKV25DQ1NLeWpBdEF5M2VC?=
 =?utf-8?B?ZlJKMy96MjNoZld3NFo0TnYyOGdEZm80THNhOWFQa09VU2NZVllOdENLbXVT?=
 =?utf-8?B?ZnNERXZBR1VNSzJDZFRhUXc1U1JjcXNKY2dMWmFrTlRNeU94cUdEa0l1MExY?=
 =?utf-8?B?ay92bXlrVzBUV1psWFBWdDlzRnRJMG5GcWJvR1RYZkVORU1aalJ1dDYyY0FW?=
 =?utf-8?B?a0xVNkRtTnVaZjNreUV3UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29227a7a-7007-42c7-c007-08d96da059b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 23:29:31.7754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSmx/bmp5rICU1MSGH0k/z+jXca2jFC6GvKFFqjLsOXW9npj8lH7u7bg/ByvNcldbWSqaqJCPu5FP1unkFP+4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1259
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: BIzAePN1DlGcPgbTktNu-Ogq_gbqpgyx
X-Proofpoint-ORIG-GUID: BIzAePN1DlGcPgbTktNu-Ogq_gbqpgyx
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-01_05:2021-09-01,2021-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 phishscore=0 clxscore=1011 impostorscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2108310000 definitions=main-2109010138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/21 7:55 PM, Andrii Nakryiko wrote:   
> On Wed, Aug 25, 2021 at 12:58 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>>
>> Instead of being a thin wrapper which calls into bpf_trace_printk,
>> libbpf's bpf_printk convenience macro now chooses between
>> bpf_trace_printk and bpf_trace_vprintk. If the arg count (excluding
>> format string) is >3, use bpf_trace_vprintk, otherwise use the older
>> helper.
>>
>> The motivation behind this added complexity - instead of migrating
>> entirely to bpf_trace_vprintk - is to maintain good developer experience
>> for users compiling against new libbpf but running on older kernels.
>> Users who are passing <=3 args to bpf_printk will see no change in their
>> bytecode.
>>
>> __bpf_vprintk functions similarly to BPF_SEQ_PRINTF and BPF_SNPRINTF
>> macros elsewhere in the file - it allows use of bpf_trace_vprintk
>> without manual conversion of varargs to u64 array. Previous
>> implementation of bpf_printk macro is moved to __bpf_printk for use by
>> the new implementation.
>>
>> This does change behavior of bpf_printk calls with >3 args in the "new
>> libbpf, old kernels" scenario. On my system, using a clang built from
>> recent upstream sources (14.0.0 https://github.com/llvm/llvm-project.git
>> 50b62731452cb83979bbf3c06e828d26a4698dca), attempting to use 4 args to
>> __bpf_printk (old impl) results in a compile-time error:
>>
>>   progs/trace_printk.c:21:21: error: too many args to 0x6cdf4b8: i64 = Constant<6>
>>         trace_printk_ret = __bpf_printk("testing,testing %d %d %d %d\n",
>>
>> I was able to replicate this behavior with an older clang as well. When
>> the format string has >3 format specifiers, there is no output to the
>> trace_pipe in either case.
>>
>> After this patch, using bpf_printk with 4 args would result in a
>> trace_vprintk helper call being emitted and a load-time failure on older
>> kernels.
>>
>> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
>> ---
>>  tools/lib/bpf/bpf_helpers.h | 45 ++++++++++++++++++++++++++++++-------
>>  1 file changed, 37 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
>> index b9987c3efa3c..5f087306cdfe 100644
>> --- a/tools/lib/bpf/bpf_helpers.h
>> +++ b/tools/lib/bpf/bpf_helpers.h
>> @@ -14,14 +14,6 @@
>>  #define __type(name, val) typeof(val) *name
>>  #define __array(name, val) typeof(val) *name[]
>>
>> -/* Helper macro to print out debug messages */
>> -#define bpf_printk(fmt, ...)                           \
>> -({                                                     \
>> -       char ____fmt[] = fmt;                           \
>> -       bpf_trace_printk(____fmt, sizeof(____fmt),      \
>> -                        ##__VA_ARGS__);                \
>> -})
>> -
>>  /*
>>   * Helper macro to place programs, maps, license in
>>   * different sections in elf_bpf file. Section names
>> @@ -224,4 +216,41 @@ enum libbpf_tristate {
>>                      ___param, sizeof(___param));               \
>>  })
>>
>> +/* Helper macro to print out debug messages */
>> +#define __bpf_printk(fmt, ...)                         \
>> +({                                                     \
>> +       char ____fmt[] = fmt;                           \
>> +       bpf_trace_printk(____fmt, sizeof(____fmt),      \
>> +                        ##__VA_ARGS__);                \
>> +})
>> +
>> +/*
>> + * __bpf_vprintk wraps the bpf_trace_vprintk helper with variadic arguments
>> + * instead of an array of u64.
>> + */
>> +#define __bpf_vprintk(fmt, args...)                            \
>> +({                                                             \
>> +       static const char ___fmt[] = fmt;                       \
>> +       unsigned long long ___param[___bpf_narg(args)];         \
>> +                                                               \
>> +       _Pragma("GCC diagnostic push")                          \
>> +       _Pragma("GCC diagnostic ignored \"-Wint-conversion\"")  \
>> +       ___bpf_fill(___param, args);                            \
>> +       _Pragma("GCC diagnostic pop")                           \
>> +                                                               \
>> +       bpf_trace_vprintk(___fmt, sizeof(___fmt),               \
>> +                    ___param, sizeof(___param));               \
> 
> nit: is this really misaligned or it's just Gmail's rendering?

It's misaligned, will fix. As is __bpf_pick_printk below.

>> +})
>> +
>> +#define ___bpf_pick_printk(...) \
>> +       ___bpf_nth(_, ##__VA_ARGS__, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,       \
>> +               __bpf_vprintk, __bpf_vprintk, __bpf_vprintk, __bpf_vprintk,             \
>> +               __bpf_vprintk, __bpf_vprintk, __bpf_printk, __bpf_printk,               \
>> +               __bpf_printk, __bpf_printk)
> 
> There is no best solution with macros, but I think this one is
> extremely error prone because __bpf_nth invocation is very long and
> it's hard to even see where printk turns into vprintk.
> 
> How about doing it similarly to ___empty in bpf_core_read.h? It will
> be something like this (untested and not even compiled, just a demo)
> 
> #define __bpf_printk_kind(...) ___bpf_nth(_, ##__VA_ARGS__, new, new,
> new, new, new, <however many>, new, old /*3*/, old /*2*/, old /*1*/,
> old /*0*/)
> 
> #define bpf_printk(fmt, args...) ___bpf_apply(___bpf_printk_,
> ___bpf_narg(args))(fmt, args)
> 
> 
> And you'll have s/__bpf_printk/__bpf_printk_old/ (using
> bpf_trace_printk) and s/__bpf_printk_new/__bpf_vprintk/ (using
> bpf_trace_vprintk).
> 
> This new/old distinction makes it a bit clearer to me. I find
> __bpf_nth so counterintuitive that I try not to use it directly
> anywhere at all.

When you're saying 'error prone' here, do you mean something like 
'hard to understand and modify'? Asking because IMO adding 
___bpf_apply here makes it harder to understand. Having the full
helper macros in ___bpf_nth makes it obvious that they're being used
somehow.

But I feel more strongly that these should not be renamed to __bpf_printk_{old,new}.
Although this is admittedly an edge case, I'd like to leave an 'escape
hatch' for power users who might not want bpf_printk to change the 
helper call underneath them - they could use the __bpf_{v}printk
macros directly. Of course they could do the same with _{old,new},
but the rename obscures the name of the underlying helper called,
which is the very thing the hypothetical power user cares about in 
this scenario.

One concrete example of such a user: someone who keeps up with
latest bpf developments but needs to run their programs on a fleet
which has some % of older kernels. Using __bpf_printk directly to 
force a compile error for >3 fmt args instead of being bitten at
load time would be desireable.

Also, 'new' name leaves open possibility that something newer comes
along in the future and turns 'new' into 'old', which feels churny. 
Although if these are never used directly it doesn't matter.

I agree with 'it's hard to even see where printk turns into vprintk'
and like your comment idea. If you're fine with keeping names as-is,
will still add /*3*/ /*2*/... and perhaps a /*BOUNDARY*/ marking the
switch from vprintk to printk.

> 
>> +
>> +#define bpf_printk(fmt, args...)               \
>> +({                                             \
>> +       ___bpf_pick_printk(args)(fmt, args);    \
>> +})
> 
> not sure ({ }) buys you anything?...

Agreed, will fix.

>> +
>>  #endif
>> --
>> 2.30.2
>>

