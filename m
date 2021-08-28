Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C103FA30C
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 04:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbhH1CGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 22:06:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48886 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232555AbhH1CGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 22:06:38 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17S24dj0004262;
        Fri, 27 Aug 2021 19:05:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=COmXOs7v1zIcEf3JCzTrQVS95Zlf8bALsuO/Bjow5Qs=;
 b=oYmi1p1mQrHhMPIWXuQp2TYA5oDzQ6HM8bzOdrOXpXMzntVMglZaDR/NhscmFpAQePyq
 JRfVYPnDdW+SfJ8T9bDGpvE8lJxhR60xKLs36wzWGGL7CbUKmIvJ/A/s7wbcTq81f+bK
 PuQTxtoQUEXV2gsXNqRAu9yCDcRaoUbGPCo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3aq2fh3g2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Aug 2021 19:05:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 27 Aug 2021 19:05:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R92yaGQP+qy+eF59mR3r8MTZTlkiLDAvGRfN5aJhm0Remm1zH4TKGXAmALfoyV+9TSDuAHpO6vmK/aI3iuV7OSgiZY/SpURDm9gJPLbo4a0iP1YzmYVxeD3VfzhhzEomylENEo+RD7JIvmdmslNbD2N8TCtxIwlWX+kJz8zVIsOysHNQGhZgXyUG+OU9ETqD4TF2IvVCtX0lVffHjwgCTbVWq7K9NVBKcMzyOvmlRjvTf3ufG1PpwjttMt5YKiQLe9YjYV/g2N+l14G0T9PTjFcBr++LjNBbloyg1iQFKL8GZ4hXtMDepO4RcKWSzlRksu3xEvfY83LsDLK4t0egSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=COmXOs7v1zIcEf3JCzTrQVS95Zlf8bALsuO/Bjow5Qs=;
 b=fhH8QRvOf9FGxs4yEiadThtsFjiI1G6FIZ0nc5G19FmWFCvuKcezwtgS86iQA34P811EnjyvS1oF99YX4m1f47Kya2U82AVRTVQd1+Au2G6TJ/9Z7HsAzXjVVOpdSwy7E0bPCR6xH6ELccfTa7ksFq7ignJ7oBIYwnRYKE5xz9CgMgutprrRZcMc8aKOshjT0QOZDhYhJBN9o3ZAz2aU3BFgD7NW9X4QRVinbTx1H2KTA8UJHML1wL2AXONSbG22/4CJEJX/DzB1ykOgvtOWXscAf2gTQ29ulZ2RlgrBHeVtVayKdlRNZa+FU9uyhy73oDqNHAyBttIxWHL0c2OBWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SA0PR15MB4048.namprd15.prod.outlook.com (2603:10b6:806:83::17)
 by SA1PR15MB4337.namprd15.prod.outlook.com (2603:10b6:806:1ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Sat, 28 Aug
 2021 02:05:33 +0000
Received: from SA0PR15MB4048.namprd15.prod.outlook.com
 ([fe80::d17f:d412:d7fb:9086]) by SA0PR15MB4048.namprd15.prod.outlook.com
 ([fe80::d17f:d412:d7fb:9086%9]) with mapi id 15.20.4457.017; Sat, 28 Aug 2021
 02:05:32 +0000
Message-ID: <c8b3ce57-41d2-4a75-8537-2f2128d67a85@fb.com>
Date:   Fri, 27 Aug 2021 22:05:30 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.0.3
Subject: Re: [PATCH v2 bpf-next 3/6] libbpf: Modify bpf_printk to choose
 helper based on arg count
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>
References: <20210825195823.381016-1-davemarchevsky@fb.com>
 <20210825195823.381016-4-davemarchevsky@fb.com>
 <CAADnVQJ+SRO-PZHYb9ef_RV3Yw_FOuOL0V+Q6A3Z_NYOn-Ezzw@mail.gmail.com>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <CAADnVQJ+SRO-PZHYb9ef_RV3Yw_FOuOL0V+Q6A3Z_NYOn-Ezzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-ClientProxiedBy: MN2PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:c0::28) To SA0PR15MB4048.namprd15.prod.outlook.com
 (2603:10b6:806:83::17)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPV6:2620:10d:c0a8:11c9::12c2] (2620:10d:c091:480::1:248f) by MN2PR05CA0015.namprd05.prod.outlook.com (2603:10b6:208:c0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.10 via Frontend Transport; Sat, 28 Aug 2021 02:05:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ecbf091-5d94-41b4-67fb-08d969c8513a
X-MS-TrafficTypeDiagnostic: SA1PR15MB4337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB433793047881263AA0202319A0C99@SA1PR15MB4337.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hRHjUkCq4lAJLe1Dol6NQ+m4TWEB4fBEhQiOpOnjdEGsMpXK2jYgJoOwwQqJv3mAYL88SRTGgdeOw2O5uBx9HdcVQI+/wYAyk6FtT1BaFbryJh9ByA+/wWnmxq6mfV37jW7j/74E7+XFhr/irGdSP5mG5Pj+airCiSDqi5asHbj5Md+ccJRVVzhvEBMCxZDFL0I5x+y5J1Is3v/PlKUZwHo7zF7sPPXC2SEsk90B0TeOvVDuYynZ1dPafr3bAePV8PXALKN0namzseJmx/RfWzQLpPfIx376AhOolLOCMqcJIT0sgOn0I34SNKVaMpPQrD+ZDuBRwnVSIZKpxR90ZbugxpSPRS10jwTD52N5ycHszlWT7EkxoXOTjMhxKm2JEZTXLrTJsg4vFFRr8DbP+yWPfZbRqM44Sj+8MWvYAOXz2TZ4DqRXZa/CqsiMkMMqVpA5JHnrCcjIJrGCDyQWBI3p6HKfPBEebmiz8iTbZx0MhOZxlAgyIaP2dB9Vilv5Tf6pnRDa9r7ShJro8GhivdOL57n8ysmoCrZd3X6iDG9WbVIkLe4OBWGiMKp4Oq+8DHILNC7qcQO24d3S5iJz9yU0mnmuw993GuwzZfgoq4Ln4dULOU7ZjarcJA5RmFxgatFthFVGq/jJRus+dC2KTZepQzahVHDB6ykWmUY5I29NkvzXWjVpKFxNBalGK3OGLsSPOPJUeZqDldeUqfWHAdm5aZfC9U52gwdsLFxijtWo0Hphsnz/qMMSUwAYSQgyKayUXF4SDhxrNbBttVVSK1oVsTC4KLSG3z2KxYj61vUcGRdThMHS4RpfEFyVl5uk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB4048.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(53546011)(186003)(52116002)(86362001)(966005)(31696002)(508600001)(8676002)(83380400001)(36756003)(316002)(4326008)(66476007)(2616005)(31686004)(6916009)(66946007)(54906003)(2906002)(8936002)(66556008)(5660300002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzA2MC9IYndIQXBxc0VxSGhQZERzU2ZNb1QxdlRMWlNTV3VxaXNMUk5aZlYx?=
 =?utf-8?B?TlBSL3RGakJpd3d3Z3hSLzZUdm84QkMya2ZMYUhScEtEZ3hYWERLdmJuS09S?=
 =?utf-8?B?YVVVNG9kRDVDckovMWluWlhNTmV3QnRYcEJ6U2h5Y1Q2cHBsR0dvbHAvaWJG?=
 =?utf-8?B?Qk1sM3h4OHlxR2Y0dVB6NlZzc3JvQTBHNGZSWnkyTXdkZXRtV05rNE5lYk5M?=
 =?utf-8?B?d2JRazFTUFJIQ0VqN0RPYXBQQ2dkbnlBZ041c3VjLzMxMHN5MlJ6bkkvcE1M?=
 =?utf-8?B?UDhJcmwzUjVBVHdTZ3g1bXdqUzlZd2x0eW04Y3ZydW52MGFKaEVyVStPTUFL?=
 =?utf-8?B?QnJ3RnV0WXdkaW5kSkFFVjdGRWNwL1BhM0NvbWYweFdnV1Z2RzB6YTE3b1ZN?=
 =?utf-8?B?Nys3bXRJeVh5amU1NUIzZFJKLytBZlhjbHFnWFROKytYUno3QjhCZUt5RUpS?=
 =?utf-8?B?UW5tR2J6bXE4akJMQVVMY0k1MEFvYnd1ZlhBTC9KUlorWndtMzNRN2R6a1ZU?=
 =?utf-8?B?eUxwQzRjYThYczV2SFk1L3V4dnVBYkQ4ZWVaTE5jK2g4S2JLbmpPTGRjTFc0?=
 =?utf-8?B?aUxwZWY4ZndROUJOUDBaeVN5OTA0cFVQREgyVzNVdEtra1lLMmFVNlo0bEZS?=
 =?utf-8?B?cm83U0lzSDBBQldQQ250ZC9IaWw4UkQ5WklBZ2tqTDdUVDlVaStwRzR5T0xI?=
 =?utf-8?B?ZTZBKzFkSHlaeERIdTMrTjJGVkJVUFVydWs4aE5LYXBBTWRuTW5WNFgrMmlS?=
 =?utf-8?B?dU9XN2ZiSVg2TlpNR2lvOU1uZ2xDSDJRZTBXTzNqdlhlVlRtN2ZKY3ZkbDJJ?=
 =?utf-8?B?V1IydjJCNmwzQmZzM0dScE13QTlhMHo4VmQveFRZQVRGaTQwSUdEa2tZSzFP?=
 =?utf-8?B?VCtJWThYbmJQNElwamUzUWFBd210TlF2TWkyZVh1NHZmOFJFSWVCNmdpVHVs?=
 =?utf-8?B?cW91ZUs0bDRVS1lLaUs2VUFFOXlZOTgvUjZaYi9tYVNGbytTaENBU0pxdnZs?=
 =?utf-8?B?WEF5ay9kZ3JDNFVNQnBBazFWUnd6V3grZ01BYWZ3dFp6TmNVZHJkRUJCYUpw?=
 =?utf-8?B?ZFVoajJycWdscXZON3FGekIxSWRzZ3BKWEdMVTlidmtjLytYb3lYWnFGUUYr?=
 =?utf-8?B?N09INnA0T285ZmJOT2tmZ25SSDJJK2l1bVo5ekp5UE1vRFAvTzJZdFRFSUs4?=
 =?utf-8?B?NHlRdXFvdkt5RFJ0V240VnBFSm8zMGJwL2g2U3FJdUV2aU5KNXFIOFgrbVdV?=
 =?utf-8?B?U1IycEowclNUL2l1eHFhWFRFUDNkd0VBSVJ2ZGdhQURPQnluNmlCdXhQd0F1?=
 =?utf-8?B?bXFHSkZIeUwvNUhZYjFpUjgrQU1sRzBxblU2NEN4YklKUEVNTmtMeUpCNGFS?=
 =?utf-8?B?ZGJJOTdCYzlEUWNTMkdzSTJCS0NJRXVMT0tZeWJIYXA4cEdpNy92NDJkRDc2?=
 =?utf-8?B?N0pKQUlYK2pibjNNOHNIK000OTZMcU1hMkVpdzAwVkR1T1JhT0Z6dE1kRzJa?=
 =?utf-8?B?YmlxY094bElxakI2VE1ZeVhRTkp6Ui9LNVVOeDRpYmlGT2NpUHBaZVB4TzZJ?=
 =?utf-8?B?ZjVKV1pRNFUwN2g0dXB3SE9BcDZLUUNSZ3hMemo4QjdPQ3g1RlhHb0xoMHRy?=
 =?utf-8?B?aGE2VUw0Z1BWS0VpdldtKzZMSkRyckpmWVJ1NjNJdEFQRmQvRGplSGFaekdo?=
 =?utf-8?B?RmhwOERVcWFYZVBNa1JvYnZsZUw1cHJIYUlyRlpXMjdPWFU2elBJeWZoK1dv?=
 =?utf-8?B?TnB3V2VoSEEyWU44aDQvZlF5cExmZDFhRlN5cnA4NzFhMzFBR2x6Y3kzeEQz?=
 =?utf-8?Q?fbSfkXLte+crjtOZ9xWPQ20LcejdH1UBoK5Wo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ecbf091-5d94-41b4-67fb-08d969c8513a
X-MS-Exchange-CrossTenant-AuthSource: SA0PR15MB4048.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:05:32.8088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0G2++lQykNjB94ctYEBISr1XzkpI0ey3sJGAMpc9Mbi0z4fhc6qHxH8guVRgXFWuEMfX07SHtaUd7ZD1l1ybQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4337
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: vmR3mSxjdUfe7bRf8QWBhYtPyEiFhfK7
X-Proofpoint-ORIG-GUID: vmR3mSxjdUfe7bRf8QWBhYtPyEiFhfK7
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_07:2021-08-27,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 bulkscore=0 clxscore=1011 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108280011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/21 9:01 PM, Alexei Starovoitov wrote:   
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
> 
> and with a new bpf_printk it will compile to use bpf_trace_vprintk
> and gets rejected during load on old kernels, right?
> That will be the case for any clang.
> It's fine.
> Would be good to clarify the commit log.

Yep, I think we're on the same page here. Wanted to call out the 
changed behavior in case it felt more like 'breaking user expectations'.
Will simplify the commit message for this patch in v3.

>> I was able to replicate this behavior with an older clang as well. When
>> the format string has >3 format specifiers, there is no output to the
>> trace_pipe in either case.
> 
> I don't understand this paragraph. What are the cases?

This was me trying to enumerate behavior before/after this patch in
order to answer the 'does this break user expectations' question. I was
curious whether clang version affected error messages users would see
when doing things old bpf_printk didn't support (>3 args, >3 format
specifiers). Format specifier >3 case is intentional runtime behavior,
so in retrospect there was no reason to focus on clang version there.

Will remove from commit msg.

>> After this patch, using bpf_printk with 4 args would result in a
>> trace_vprintk helper call being emitted and a load-time failure on older
>> kernels.
> 
> right.
> 
>> +#define __bpf_printk(fmt, ...)                         \
>> +({                                                     \
>> +       char ____fmt[] = fmt;                           \
> 
> Andrii was suggesting to make it const while we're at it,
> but that could be done in a follow up.

This was intentionally left out of v2 as I wanted to get early feedback
on the macro stuff, will add a patch doing this to v3. 
