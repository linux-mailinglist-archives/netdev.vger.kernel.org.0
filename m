Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BF4409AB1
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 19:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242772AbhIMRcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 13:32:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238180AbhIMRcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 13:32:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 18DH3hBD027652;
        Mon, 13 Sep 2021 10:30:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date : from
 : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KA/qWuaOaXCLCjugz/GnebRIZVli1908geaQKnCFNJw=;
 b=Ss/6KAPN/MhK3TUBXFFWxaZ2oMd1daSITbgN59WKj6cfPCb+6HIG3mQ4YaqfmqAvwGLY
 gOfPKPIQkCUxEOz9jvIgryKq9EHq/qdzw00e5VhWQ3DckmotH8zm+9O9+H70dBtbseMt
 XJYBml/MQZyrOeHTdoKkhVMcEfBHifq49aI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3b1vwnvkt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Sep 2021 10:30:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 13 Sep 2021 10:30:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEbgGwhGIbWleThJFJXRaUbGq9pyQUBuUV4CPx9VI66Kp1IgfYmWDHWtRqXwv+zNcISG/9o/j/ybNXdDqp4wyiqPvzE7jYz0z/lUEUjEnv5a2xNQ/0deW4kJRzg2sqHELvxb7R1xttqQkUwxuRarhLD8myxeUY47wQRwUr1ML4Yk7EXycqGRe5qfzEiChyEKC31XtL5roKYxmnTTQcAMoZsFiRxDsPIEz/Kpt0nJwIOcl+0HVDGobBtBq8JpoN44Rt1+iUKKfoIrzuSF9ih9fr1kX9YV0qh7b3PErGYSVi5dMG6a1ADb3je29hTEeUBHENMT4TxsDi5MpaX9UTIcYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KA/qWuaOaXCLCjugz/GnebRIZVli1908geaQKnCFNJw=;
 b=fWX6J/igghE2l4h/oEOkQ33Xnu37YGW5jLYuQs+giGY0RlGOTt2G6u0ZTcX79y8TO+Un0yH+8jHZDhlQJ0U8PXuPccICJJ2/1+bartxDhJoHEZgwZhVRmieJhF/jsMLRA9s/wxrHKRCCi4v5PvMBjaAc4m1z1MBQxBwfFxKEQgpY4/QLBbzad5RxJ48aAeS2g6ZLFp2+LuXK7/xtvregJCoHmA5ZxgitkTHbEmHh2IrA4/JiyVBa7UFLS3ZX7SiGRvzQ7DGI4Ln4KMq2LwAyNCa8lq7g3zhl0V3Whf2qj1EtbktfqoLACzzgpv+of1Fmhg4z2HeHx8ztsb9NmKytgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM5PR15MB1257.namprd15.prod.outlook.com (2603:10b6:3:b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Mon, 13 Sep
 2021 17:30:38 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6%8]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 17:30:38 +0000
Message-ID: <dc49dc8d-7ec1-32cf-4170-4c0b32748caf@fb.com>
Date:   Mon, 13 Sep 2021 13:30:11 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.0
From:   Dave Marchevsky <davemarchevsky@fb.com>
Subject: Re: [PATCH v3 bpf-next 2/7] bpf: add bpf_trace_vprintk helper
To:     Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>
References: <20210828052006.1313788-1-davemarchevsky@fb.com>
 <20210828052006.1313788-3-davemarchevsky@fb.com>
 <1253feeb-9832-1a86-7eb2-5076698c4ca3@iogearbox.net>
Content-Language: en-US
In-Reply-To: <1253feeb-9832-1a86-7eb2-5076698c4ca3@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:208:23b::8) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c0a8:11d9::109f] (2620:10d:c091:480::1:22ea) by MN2PR11CA0003.namprd11.prod.outlook.com (2603:10b6:208:23b::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 17:30:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3cff21c-04e2-471d-5ef6-08d976dc33ce
X-MS-TrafficTypeDiagnostic: DM5PR15MB1257:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR15MB12576677A8A14F3C9BC22EFDA0D99@DM5PR15MB1257.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZOEQGiO9PD+gX5SyBhlUHZl7+jYtcslTioftSi8okdECcismuT/OsjL3MmGmsDHjVcG6JE0LvYdrWXNOvnZJaJaePWgeZh+URdXiYxJF/ep8ak94xTGr5D9t3ky6ZLvGKCrDF3ZgPqF4ORL2iSkhMdL9N1lJScz9J4hS8E12Amp0J7cKYChEkhkZA6rRes951DDLaMP5EuEhnT6+1V8pqEJEPMNtfVPtjk2e58RjoCbdvL+2f1ZBi9/7rNbMkerLFryKCr2DeVsxQnVHMijNQqzGTEvMCwmduwY+Imy4e6Rm4a05lxQD26NTDYqhlwOamHHv8HX1Cy5N0NQaHje0VcdxoORswpbvp0XuNzpI8igv5/45F0pKcHWyLf9EEiAtbKUzL/nLffIoucUhayH9OX0R77v74xlO9jEx0Bqep2IZ/zAoq9L7fwF7M+xjdGIWm9rPWx+yyqJA0qTTGS7cT7DeVkUhxZRJidXnNU3LFuq5/nqZ3GEEycuN93JyDtcC/u1tOyt3QlTbCldQCZyakse7xR0AFo05DCSoUfAigyFMvyKzKSe6V8wbAeTzb4/XRhjPhOjT9IzIRP5cRFGMXkPpK2d5/fRvphJWd5eEhvRUazcbKq78NsrRqSDxqB9nHYYSvTKzdTKvSmPFFgS6ZV8l0rGr79IjzOKICoiwz00HoSf+3yGNrnadttKRpeCNOUu3FlAppBMMsZvjCwqog770k69aIARh3Jz+UUXwoU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(31686004)(5660300002)(2906002)(54906003)(83380400001)(36756003)(6486002)(8936002)(38100700002)(8676002)(316002)(4326008)(186003)(53546011)(2616005)(508600001)(31696002)(66946007)(6666004)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmVlTDk0OFhOcDVBUXJyQkRrakhXdW1FcHFaOWJ5Rkx2QThwU25qcXQzblhO?=
 =?utf-8?B?WjZPY1E5NnRQbXZHRjJsRzA1eDVCdVNXblNYd05wdytMQmJIT093ZXRtTFdu?=
 =?utf-8?B?VGVyYXQrTVJ6RmMzRnJJbWsyUFpMaEtWTDNwQkx2dHI1RUpmUXRlQkZIeXBX?=
 =?utf-8?B?VkZBSU5lNUdpZTdWeVlJQkNMbXRYeGpHMDRiS3Z3aDFjSzRYSmZGUlpPWUdp?=
 =?utf-8?B?Uk5tQ0ZFaFh1QXUwRVZoblNFLzh3RGg2cytMNWUvNTY5NWZnalM1aWM0UDIz?=
 =?utf-8?B?R1lKM1RaTlRPd3pFZmRZNHJVWTkva0d2a1g1N1l1WjFqWFgrNlAzaDhueW9q?=
 =?utf-8?B?WmhxdzlPWVJJSktLeWJwdFd1WW1LMHU4RkpoV0JFNW9iMklwTGlycEtGK1Y3?=
 =?utf-8?B?dUFoMFJYTTYrUmZwRmFTWmJGRVc3VnVWNWx1Tndob3JDRi96S29xMkYwSEZK?=
 =?utf-8?B?VVBoQ3B6ZVFQSU9zUmphb0dLSENwWm5IK2tRTGV0aUtDaTY2UUF5QklUSXUx?=
 =?utf-8?B?QXpFdG9qZmJjam5RanFCd0hZdFdUNjNHSDFkQkdyWEJDTkNIcFdDazBwTkt1?=
 =?utf-8?B?a0pxakpnK1BINDMvZmNmRVQzL1NxSTc0UUJCTnFXUUJXaDBlNEltQ2k1VTg4?=
 =?utf-8?B?S1ZZYXg3MTgyNnhFUFJCLzFDV2UrdmJnQnJTenVWL2ZYUzVPQTVLNFhFaW5H?=
 =?utf-8?B?S3M2azM3aUwwVU5tNVo1ckwyenBQZHI2SkZidjVQMTNSNDdMdGVvVlFjRUdV?=
 =?utf-8?B?MThKYWd1dU1ETzZwTWIrYU5scHZUNTkyMXpLb1RsR0IxalBtS3ppVnMvZmcz?=
 =?utf-8?B?NmRPWTJZVXFwb0dqc2llWEVsS2J3V21YYkZLWUkzNGhTdkdoVENuNFZGNlBt?=
 =?utf-8?B?WHFTTFNPaEF2NDBTSXBFNHVpNnNsY25jR1oyWUIrMW1SY0c3cTNBLzZKNUUr?=
 =?utf-8?B?ckhkZU1nOGErdTV5cTkvWjEwdVJFNW82YlFMRTNpdll1T25xMVAyM2k0VFpz?=
 =?utf-8?B?UGdaNitGSmx1ZlMxT0M1SVppOEVXZWN2QkVwRG5LQjVKaGNxS0t5WXkxNC9X?=
 =?utf-8?B?aFJXbXh2VVN2WWdETE1PeTVJQTB5Z2ZrODRqeWZGSGk3czZNYlY5a2hnQkVL?=
 =?utf-8?B?eXN4SThOODF4SStoYU9oTUIzdWFqeUR1VzR5c1c1YW9wUStPMmRnQXdCMzc2?=
 =?utf-8?B?aXRjQ1R3Qi9QQnlCSDZvUFpvSG9mTVRKanB2a3hSVVkzelVrNVFUWU9PSzZy?=
 =?utf-8?B?YjJCUkk0YTlJNnZNeWZFVDZ4YkdSQTdHVDVTb255YWJYQVYxRWc1cmE5aWp3?=
 =?utf-8?B?emovU29YV1ZlbzNLWkVRN2MrOTArR3V4M2dBaUtndWZhT1BHQzB1UldSVU5R?=
 =?utf-8?B?OEtJWE1DRmtUYlc4UXhqdi9lWDZtUlNmSExEMnFPWnFlL1orNWRHZ2tzbkc5?=
 =?utf-8?B?SldVQzUvTkFjZUthbUxyaE53UkpvUmpSQ3VEM2owQVJZekRvcHNGUlAxL2Qy?=
 =?utf-8?B?NHpmZUtNL0RxM3JPR1Rsd01sdWFoeE5TZmo3bWNGenRCeDBKblVQN3NCWnRW?=
 =?utf-8?B?NFhuUytncjNRVTRvR1VBdkh3NmhIbGcvMjQwakFFbHB5Yi9FUGNSc1g4QUVV?=
 =?utf-8?B?aU1GVGl1OUdDUXpPVEZHUHVHNWNJSEVCY3VhajUvRDhTZHFVSWJnclh4R0Ny?=
 =?utf-8?B?Qzk0NTVySThhVkxJMDBYZUwzYXFRZ09vTlpDMUdSaFZvRk9KSXhDQ3p4RjFQ?=
 =?utf-8?B?VGg0NUFiZldBYUJaZzdsVE0ycDh4K05IQ0cxVDFTVHp1UUNKVHV1Y0hBdW8y?=
 =?utf-8?B?Q3V0NlVDNEhxR2NZbmZMdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3cff21c-04e2-471d-5ef6-08d976dc33ce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 17:30:38.6379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ieuQdxAZ5P7pMLxBys+7l1FzfatEkQ2ud0VYTsWG+Ms8Da4TH0SH6dUF2b+HnsNKy54s8EOL3bHZqDmVklitwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1257
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: QqXVMHwibTu0kyUDJHBGhqmGoUJrcGWh
X-Proofpoint-GUID: QqXVMHwibTu0kyUDJHBGhqmGoUJrcGWh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_08,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/21 4:00 AM, Daniel Borkmann wrote:   
> On 8/28/21 7:20 AM, Dave Marchevsky wrote:
>> This helper is meant to be "bpf_trace_printk, but with proper vararg
>> support". Follow bpf_snprintf's example and take a u64 pseudo-vararg
>> array. Write to /sys/kernel/debug/tracing/trace_pipe using the same
>> mechanism as bpf_trace_printk.
>>
>> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> 
> lgtm, minor comments below:
> 
>> ---
>>   include/linux/bpf.h            |  1 +
>>   include/uapi/linux/bpf.h       |  9 ++++++
>>   kernel/bpf/core.c              |  5 ++++
>>   kernel/bpf/helpers.c           |  2 ++
>>   kernel/trace/bpf_trace.c       | 52 +++++++++++++++++++++++++++++++++-
>>   tools/include/uapi/linux/bpf.h |  9 ++++++
>>   6 files changed, 77 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index be8d57e6e78a..b6c45a6cbbba 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1088,6 +1088,7 @@ bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *f
>>   int bpf_prog_calc_tag(struct bpf_prog *fp);
>>     const struct bpf_func_proto *bpf_get_trace_printk_proto(void);
>> +const struct bpf_func_proto *bpf_get_trace_vprintk_proto(void);
>>     typedef unsigned long (*bpf_ctx_copy_t)(void *dst, const void *src,
>>                       unsigned long off, unsigned long len);
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 791f31dd0abe..f171d4d33136 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -4877,6 +4877,14 @@ union bpf_attr {
>>    *        Get the struct pt_regs associated with **task**.
>>    *    Return
>>    *        A pointer to struct pt_regs.
>> + *
>> + * u64 bpf_trace_vprintk(const char *fmt, u32 fmt_size, const void *data, u32 data_len)
> 
> s/u64/long/
> 
>> + *    Description
>> + *        Behaves like **bpf_trace_printk**\ () helper, but takes an array of u64
> 
> nit: maybe for users it's more clear from description if you instead mention that data_len
> needs to be multiple of 8 bytes? Or somehow mention the relation with data more clearly
> resp. which shortcoming it addresses compared to bpf_trace_printk(), so developers can more
> easily parse it.

In a previous review pass, Andrii preferred having bpf_trace_vprintk's reference other helpers
instead of copy/pasting. So in v5 (patch 9) of this patchset I've added "multiple of 8 bytes"
to helper comments for bpf_seq_printf and bpf_snprintf. Added a sentence mentioning benefits
of vprintk over printk in v5 (patch 3).

>> + *        to format. Arguments are to be used as in **bpf_seq_printf**\ () helper.
>> + *    Return
>> + *        The number of bytes written to the buffer, or a negative error
>> + *        in case of failure.
>>    */
> [...]
>>       default:
>>           return NULL;
>>       }
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index 10672ebc63b7..ea8358b0c748 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -398,7 +398,7 @@ static const struct bpf_func_proto bpf_trace_printk_proto = {
>>       .arg2_type    = ARG_CONST_SIZE,
>>   };
>>   -const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>> +static void __set_printk_clr_event(void)
>>   {
>>       /*
>>        * This program might be calling bpf_trace_printk,
>> @@ -410,10 +410,58 @@ const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>>        */
>>       if (trace_set_clr_event("bpf_trace", "bpf_trace_printk", 1))
>>           pr_warn_ratelimited("could not enable bpf_trace_printk events");
>> +}
>>   +const struct bpf_func_proto *bpf_get_trace_printk_proto(void)
>> +{
>> +    __set_printk_clr_event();
>>       return &bpf_trace_printk_proto;
>>   }
>>   +BPF_CALL_4(bpf_trace_vprintk, char *, fmt, u32, fmt_size, const void *, data,
>> +       u32, data_len)
>> +{
>> +    static char buf[BPF_TRACE_PRINTK_SIZE];
>> +    unsigned long flags;
>> +    int ret, num_args;
>> +    u32 *bin_args;
>> +
>> +    if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
>> +        (data_len && !data))
>> +        return -EINVAL;
>> +    num_args = data_len / 8;
>> +
>> +    ret = bpf_bprintf_prepare(fmt, fmt_size, data, &bin_args, num_args);
>> +    if (ret < 0)
>> +        return ret;
> 
> Given you have ARG_PTR_TO_MEM_OR_NULL for data, does this gracefully handle the
> case where you pass in fmt string containing e.g. %ps but data being NULL? From
> reading bpf_bprintf_prepare() looks like it does just fine, but might be nice
> to explicitly add a tiny selftest case for it while you're at it.
> 
>> +    raw_spin_lock_irqsave(&trace_printk_lock, flags);
>> +    ret = bstr_printf(buf, sizeof(buf), fmt, bin_args);
>> +
>> +    trace_bpf_trace_printk(buf);
>> +    raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
>> +
>> +    bpf_bprintf_cleanup();
>> +
>> +    return ret;
>> +}
> 
> Thanks,
> Daniel

