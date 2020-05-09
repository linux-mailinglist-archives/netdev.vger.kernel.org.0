Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEC51CBE00
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 08:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgEIGEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 02:04:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43716 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbgEIGEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 02:04:36 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0495w3ka027698;
        Fri, 8 May 2020 23:04:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=075QQfLY9fZ7Hjp+VPnGqL2WNIF1old1vpYFWho4TCw=;
 b=rnKa6qKweV2A4PzzupzjVtMtY9HpuIczquY18tguQNh0ffJqjv0Lk1TSmppiUGrGSEa3
 WYVOB+7EziwjAXSBcE5/dACwFXsh6COcIe8INCn4swg+S/d6rNL/Wv8ru1grXhKB/Bl6
 NrnB31QybXB98In45SiDR3e/9jryv0JjVPg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtccrav6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 23:04:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 23:04:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2h7dASPfM83MpOsUeqPR/otAvmfFyUyDAsEJ0d70sCX/1OfiLy9Ocf+mFgzguk0yWoJF7jHbHcTiWA64p3qbPKC+ZmsAKY/KA/1p1jZv3IiYjEqAYgPD+eG701pS9Qa7XXWzNICWJRsQap1notojgg8Z2YiBlalz2cQanyv/kF1yi6xpchiXT87eOEuleljzy7Qawxq3cFGgnPwf3YTkVGkG46QIPboSCABIws8D9CH3h7foghq62Bd5WmKqwssEJVj4cUjzJmJv2wPnEELmbpvyziKl8dWXTY/gRJVhfa+E1r7HY3J6bzq2Sco/wkOd9pXDLbG06OUIJsZcbkd8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=075QQfLY9fZ7Hjp+VPnGqL2WNIF1old1vpYFWho4TCw=;
 b=CAUyLWh3W7ESbpbEIFy7hsv1JB+DobPs67GspnQ+4zZDMI1i196J+YMy+zoBwpVdLPjUUGwFuqU8lhnXY2ZBRtgG9NssjgfzB9Gt9kHwqHXys1QC3gloOm3YPIawjYWq9j97mEEUbcCNO4qvG6RDzpjgfNSOpQVYQqTkKFjByHUr5Fz8v2D54j2vV6O85QGiUuEn+gIFpKZEK7tWWTL1j3iROziyiUXcORfufrbw09lO6cF8V8oAYNy3N3VEcLTHPUrNhtpNfrFnXgFwS7LOFLE3ER3Hzh3D5ov0ybktuhOYhn5kiaP1H2F5071hwrKhNUjhvou6ZYMtxsOvXTNnhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=075QQfLY9fZ7Hjp+VPnGqL2WNIF1old1vpYFWho4TCw=;
 b=eeatJx0XJbIfIHalWMGBINA4YS14XhDSzCWp5+wuqoo2wnEzffmeV7J11LQeHQG4jwGt8tKILP2P1LAwjfIHDuIwNNnaVkqVnBSgil/T/TAcKlUcFHHbg3R8Ge2gP8TVVgVDyDOk3PrBqeunOhLzo2fFN3pQCzKEpPy+Qvhwo7U=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2984.namprd15.prod.outlook.com (2603:10b6:a03:b5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Sat, 9 May
 2020 06:04:19 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 06:04:19 +0000
Subject: Re: [PATCH bpf-next v3 13/21] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
 <20200507053930.1544090-1-yhs@fb.com>
 <CAEf4BzabLpaMvJtTNtb88xJZzdjwwvcnfqSH=hq3bMiEt-gtmw@mail.gmail.com>
 <931b683e-ccb5-f258-f5fb-549b2daf47b3@fb.com>
 <f78b0a02-9469-32c5-d8af-78335010660b@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9993230e-ce46-ba4d-7d5c-e5f8b3b8c078@fb.com>
Date:   Fri, 8 May 2020 23:04:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <f78b0a02-9469-32c5-d8af-78335010660b@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:a03:100::39) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:a70f) by BYAPR08CA0026.namprd08.prod.outlook.com (2603:10b6:a03:100::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 06:04:18 +0000
X-Originating-IP: [2620:10d:c090:400::5:a70f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82f9af49-25e8-441f-ee0c-08d7f3decfee
X-MS-TrafficTypeDiagnostic: BYAPR15MB2984:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB298489FA16827A1AAD1D3CB6D3A30@BYAPR15MB2984.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sxJGPQzlNeRl/akigrtHi61Xhden3drS0B/8iRymC38Ljxykl3UNaP1QkJ5zWzasaf43J/CGVrLa6XzScEE5jPb1xal6zLh+KNFTFACMhCsXSQWbUkUOtLBTgzF6UoFMGxb4NsPKhgWSqCFcnX+FBLfV7F9kVi3LmrENy+3p1QKtkS9+9OpXH40xQ1sbhoKOLH5yxxDWc69div1b5OHOS67xVRcCs/W3LnH5tvtmOHKF3NzyFIqA5gsFNhD6x4SMbgAqmhqKYh45bXI/fEzUpVEehxwsBr2+rIdGLe9/J26CZuXQF4dbroifiOGyvPSP/+UX2Vhw0cjG6y7oZr/kQOScVGgTutj9cKlZtG3ScvnFvDwh6g+3Oxg1ppZfSBK5Wkm+Nfn9Ymek359GqphuZK771/zWr4i/6tEb7xnri3vnzk31IAiyidxJjpbcgNchhkVErDgnCaTCpVXANry14tYUP7Hu020MAEnjfNeOctdpDoMzRrTp0T5TlPuuNgEykCjg4n0F7s0AK/+Z0PYxPdVYPP3xNhq2YFTti/MlVg0LhhTOHDOZ8CBVKjhnKwmD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(366004)(346002)(396003)(39860400002)(33430700001)(66476007)(86362001)(66946007)(5660300002)(31696002)(36756003)(53546011)(31686004)(2616005)(6506007)(66556008)(52116002)(54906003)(33440700001)(316002)(4326008)(110136005)(2906002)(478600001)(6512007)(186003)(16526019)(6486002)(8676002)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: JEM1991hFnRKq0T9mPRsIn59oaEUWLTG2HNMD912FZUc+iGcVTSUJZT3Cco3nwJ9FcJdg7Dvqw8c/1whUV5fwOZo+D3InlFrMLSNFnj/Ofnt4+XjkkdwL14wZJhI5TzL9KHoGvWAuqhSof00OBybahUtk/8uly0f3aQ0ffAnr3v3xPReQRpUZwmpBZ5N2Hew7Sg+QCqV0BmENKwu+i58EBvmF21bJ92wN1UjsDWWywtx156f4CY+MOcXZXQDx62ZVFPu4CqfKQyEyevFmeslUQHbUFwfcGdtZAtyrdl8nWogPnOXsqL1TvXGUmtuAE1zUwv+yhdbXTvPM6DQrpQLr0m9O3TKJClmW6pVQfQK4Vh2xOJhZ0mj8kCtQhJHxlnwJgCdQ3Q57UN8dHbq+nnRpXjLNZhcfk9nGVvvOyilXlXL79908uFCScDYvRY0pWJPQsxcQz39f4pGgAIs6bayG/td/Uz/pj5YB9KRK9bcJu20wea3qOjHSvFWTXu6MxqEU34ZXtQIwpHh97EueKUecA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f9af49-25e8-441f-ee0c-08d7f3decfee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 06:04:19.5194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ca8Nzg68eT+SlcCfYPU7mAzILwMP0+u4LxsLvaCYGZFnsui8rjec02p7WDIoAYKz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2984
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_01:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 10:30 PM, Alexei Starovoitov wrote:
> On 5/8/20 9:18 PM, Yonghong Song wrote:
>>
>>
>> On 5/8/20 12:44 PM, Andrii Nakryiko wrote:
>>> On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> Two helpers bpf_seq_printf and bpf_seq_write, are added for
>>>> writing data to the seq_file buffer.
>>>>
>>>> bpf_seq_printf supports common format string flag/width/type
>>>> fields so at least I can get identical results for
>>>> netlink and ipv6_route targets.
>>>>
>>>> For bpf_seq_printf and bpf_seq_write, return value -EOVERFLOW
>>>> specifically indicates a write failure due to overflow, which
>>>> means the object will be repeated in the next bpf invocation
>>>> if object collection stays the same. Note that if the object
>>>> collection is changed, depending how collection traversal is
>>>> done, even if the object still in the collection, it may not
>>>> be visited.
>>>>
>>>> bpf_seq_printf may return -EBUSY meaning that internal percpu
>>>> buffer for memory copy of strings or other pointees is
>>>> not available. Bpf program can return 1 to indicate it
>>>> wants the same object to be repeated. Right now, this should not
>>>> happen on no-RT kernels since migrate_disable(), which guards
>>>> bpf prog call, calls preempt_disable().
>>>>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>>   include/uapi/linux/bpf.h       |  32 +++++-
>>>>   kernel/trace/bpf_trace.c       | 200 
>>>> +++++++++++++++++++++++++++++++++
>>>>   scripts/bpf_helpers_doc.py     |   2 +
>>>>   tools/include/uapi/linux/bpf.h |  32 +++++-
>>>>   4 files changed, 264 insertions(+), 2 deletions(-)
>>>>
>>>
>>> Was a bit surprised by behavior on failed memory read, I think it's
>>> important to emphasize and document this. But otherwise:
>>>
>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>>
>>> [...]
>>>
>>>> +               if (fmt[i] == 's') {
>>>> +                       /* try our best to copy */
>>>> +                       if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
>>>> +                               err = -E2BIG;
>>>> +                               goto out;
>>>> +                       }
>>>> +
>>>> +                       bufs->buf[memcpy_cnt][0] = 0;
>>>> +                       strncpy_from_unsafe(bufs->buf[memcpy_cnt],
>>>> +                                           (void *) (long) 
>>>> args[fmt_cnt],
>>>> +                                           MAX_SEQ_PRINTF_STR_LEN);
>>>
>>> So the behavior is that we try to read string, but if it fails, we
>>> treat it as empty string? That needs to be documented, IMHO. My
>>> expectation was that entire printf would fail.
>>
>> Let me return proper error. Currently, two possible errors may happen:
>>    - user provide an invalid address, yes, an error should be returned
>>      and we should not do anything
>>    - user provide a valid address, but it needs page fault happening
>>      to read the content. With current implementation,
>>      strncpy_from_unsafe will return fail. Future sleepable
>>      bpf program will help for this case, so an error means a
>>      real address error.
> 
> It matches what bpf_trace_printk() is doing.
> I suggest to defer any improvements to later patches.
> Both should be consistent.

Sure. We can do that.
