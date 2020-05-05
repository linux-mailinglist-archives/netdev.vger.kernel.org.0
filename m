Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E289A1C61F3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgEEUZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:25:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49290 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726350AbgEEUZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:25:42 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045KOiUL011403;
        Tue, 5 May 2020 13:25:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=9vTMTuM4X5Ai3SWcnvebyO/yoCWLmeTqp0qYXLracZQ=;
 b=jzxrweZV+YXYJVq/THW6RUklnDu7/oLnv9qwJZ5MNNreTPGE3dkEXBj4VfZY2lonBdHX
 +fT8HcAsjp4wkKS8kk18S/P3P/uXIRV2MJyzf7fJ0tdO3inNcEOFLOL852kJlZqPoAj3
 20RvDT2fg0zOAXGZf/NfaQWsrVpMTGQO5Uk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6pg8gg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 13:25:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 13:25:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdWfKxIh3cXCRFuuXSzeLWX5p4AX0ocYeDvpUIN7CwW4NtjWNhYLSetkvt6pZ9r+Ky+gNLaGW6aH/0iFaqOkvKWHsJMRA+bygdLX7AeRe/S949lDcjGXPhcGkTFtV5A+Xg616HJRPCz90EQEqg0vv5xMlHUWrenForHqRehXyM9XGBZB51Tj2FTwkA3CoUkQ3om+yVwxYxr6qKhjFDM3Wl+bfLR0E2wKQ2q7xesC99yIqE1172yrcRLD++YZ1vEWI7QXq3HAVcE6SdCPjy/Mxy3+8iOyAmZ0Yz2HvTUDkGF53NtvrvEU0OOLYqOTWQz64zHB63rGRTPiWZ3nTOJ/lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vTMTuM4X5Ai3SWcnvebyO/yoCWLmeTqp0qYXLracZQ=;
 b=SSdyg1WQyGL9kryweb8L8tfbIhepSgCUn0lw0R9z2f09tTQNdUcz19/HTCEnEInyskbKTnBVlxhQEMdWL4/7EAnuR5JVgPrpHTU46tecJmvuwb82OqiTcwEWlutGjT4vpKrcWbeeSDkj4eXcf/Qg6040lPMAYj2akzhVgIaYv4C5c+xpfsLvnIcs8n07iyrF5/21inPHmjDRjzJVeJt+6b35hlmTnIbdGU6XKqWcfvtDIfzQxI5bqk6Qrvuff2FqwPSu7ApyOHN2SEukC4rb5+hwUmSaTE0NLgagtsj1vFfulQsdhiI66JIgIjoFYvg5X+UBz9VOe5gXvF9ppMeMWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vTMTuM4X5Ai3SWcnvebyO/yoCWLmeTqp0qYXLracZQ=;
 b=Ms3drmJIIZysufKQSoZPV9vrDWe19/KWyuU/qE+ZoC+BDo1cQXZZhfgN6fg7eauDItY9gWy+SNE8w3d/UTcEjFORtBZTCajIwoNflGzPmaC/o3vBJEywQUjDOLTlPoo7n8tpvtkzQSPUiuBPtsrEJhyrSycB/8wJMBXKdWodXoc=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 20:25:23 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 20:25:23 +0000
Subject: Re: [PATCH bpf-next v2 05/20] bpf: implement bpf_seq_read() for bpf
 iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062552.2047789-1-yhs@fb.com>
 <CAEf4BzYKACiOB+cAC+g-LdJNJbnz9yrGyw7VsBoW1b2pHjUghw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <23105f0f-3d0a-7a40-8795-fe1a68349880@fb.com>
Date:   Tue, 5 May 2020 13:25:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzYKACiOB+cAC+g-LdJNJbnz9yrGyw7VsBoW1b2pHjUghw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0049.namprd11.prod.outlook.com
 (2603:10b6:a03:80::26) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:99aa) by BYAPR11CA0049.namprd11.prod.outlook.com (2603:10b6:a03:80::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 20:25:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:99aa]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5006193-5bdf-4cd8-9039-08d7f1327079
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3461C403062BD387D059772ED3A70@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRoAtreujoRxVCPgVwtE9roy/dyDt0J9klbLu+m7dMv+ZXmJ1ywqAuexKJO5lIgHsrZB3a0c62jUdnrMT6rrZeSIQ31bZLzmxSJfJzVxPLW+RGMF081d9mzyVML7wEJ86LcUIEL3Zpm492S7ic1L0yVZ1OtTAuAi46n+L8onB2sM/ELN7AEX3p6mqc14HKj8goxaOn0lw0vpuyZ4t/UxWUN5OvGK1wJFYOIiIVEeunFTSLPEwWzIdzJZ7HODo2dSzfxHIoZ2oj2cvNE3ZSEuqtkjV/QrchKXVO5UlkKFzYfrcW4FgDLiy2rw6jAGwp5ya+rjiowiyvFq9lh6KUkDfcAdH+d6MEvuaCImN2+Dm2KWe4jIdmCLZrxLf2u6O+g1uNZEOlGCFBWX1F39nA5UUegUF68Og9GVhP1GbIgq6IpAYbFc/0w1Ybt3GVNJXEyULaLMEdz+lUTuczNOxOOpdZTY/9Fo+3p88ttq9HkRAkrCMW1Yq/Iy+XFFI/6+fhlBar/0KsCHt/A7OsHIgEqD9BKCQvh9ITmzqxst6H+EDPGWemiTjy7ZLFy0nYJ8hu2C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(136003)(396003)(39850400004)(33430700001)(31686004)(316002)(54906003)(52116002)(16526019)(186003)(6666004)(5660300002)(31696002)(2906002)(86362001)(8676002)(66476007)(66556008)(478600001)(6916009)(66946007)(8936002)(4326008)(53546011)(36756003)(6506007)(2616005)(6486002)(33440700001)(6512007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: PrbHqXl1QT+rpU0yxnQh2xyGoaC94fcESUtUNZe5yllEUQodFSnzSbdCVfafHEmJ4fxJ9Ck4bDIg4WqaTHKrTz8YXNgAT1HoikNdjPkfd4gGOqzM4Uvei0xnJnODvKs66lfnyVIdwr/YU6ZM8nuM1F4Xlq65KU6eqpcYymNO7E81qEhHQTw13lQQUXttQjOtdXylF0OB5HDYrq5H+CdaqfzzrmCD0g4IFwBshWLLNDfCrFfkOtz+sj9sTy84EGVmmXbQUmQ1ms1fQ2ZaCsqEJfrzljTVQ1APUVyb+DehdTli95icwd/KkkmxRuoNKmvBrfpxXACV1pE1Xq401cWJ2jswy9CFQHxpKpvY/XpWUtXXTmBE8i1zmNNOd25dD0rFkLyaP5z1tltMpt4WmROCVHt8/T+2Jo8luGmPBMRRH3+PAUXgZ/yCl/cieZsxKqu9zJ8Gt6i+sxBDw81/RgtWu+tUffCcOEkfR+rG8oaWWjMAumlf69xYRuMf9c+k3sHU7950jCthh9hb08uZe/lev2+rbwJ+nUMfNQC6/LPNHPtCbqVqmICaFeSdZzArJrNMJfLJaDUYNNik43jMWk5Q/dcw3ynlmyTJIroRROmQJhtivUiugomS1Zcp48KpWPxpM4dCWSBVsdS8YOkp1DAKvYojI3cVbja7GDDN9bx2fVNaHy4kp3q8mDozGJlNE60elt+p4dni8SM2ubeszjc0hiBdf+PhS9jg5twB3aIyTHSYEmo0r9AzukyJe756qZ26kefxq5hEXAxVGoIqNgZI4pXfvwg24oOd3BeYFoW4I1MeZ86siXnWl7a94AbL9uSlFD4kkCs5SkV0HaIWCuXO1w==
X-MS-Exchange-CrossTenant-Network-Message-Id: a5006193-5bdf-4cd8-9039-08d7f1327079
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 20:25:23.5657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wsc8mQR6z0MtLFcRgQYYp10X0XWnjGiD0Bh12tWCYwgCbIWQUUuYzmNAKD7zNoho
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 12:56 PM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> bpf iterator uses seq_file to provide a lossless
>> way to transfer data to user space. But we want to call
>> bpf program after all objects have been traversed, and
>> bpf program may write additional data to the
>> seq_file buffer. The current seq_read() does not work
>> for this use case.
>>
>> Besides allowing stop() function to write to the buffer,
>> the bpf_seq_read() also fixed the buffer size to one page.
>> If any single call of show() or stop() will emit data
>> more than one page to cause overflow, -E2BIG error code
>> will be returned to user space.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   kernel/bpf/bpf_iter.c | 128 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 128 insertions(+)
>>
>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>> index 05ae04ac1eca..2674c9cbc3dc 100644
>> --- a/kernel/bpf/bpf_iter.c
>> +++ b/kernel/bpf/bpf_iter.c
>> @@ -26,6 +26,134 @@ static DEFINE_MUTEX(targets_mutex);
>>   /* protect bpf_iter_link changes */
>>   static DEFINE_MUTEX(link_mutex);
>>
>> +/* bpf_seq_read, a customized and simpler version for bpf iterator.
>> + * no_llseek is assumed for this file.
>> + * The following are differences from seq_read():
>> + *  . fixed buffer size (PAGE_SIZE)
>> + *  . assuming no_llseek
>> + *  . stop() may call bpf program, handling potential overflow there
>> + */
>> +static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>> +                           loff_t *ppos)
>> +{
>> +       struct seq_file *seq = file->private_data;
>> +       size_t n, offs, copied = 0;
>> +       int err = 0;
>> +       void *p;
>> +
>> +       mutex_lock(&seq->lock);
>> +
>> +       if (!seq->buf) {
>> +               seq->size = PAGE_SIZE;
>> +               seq->buf = kmalloc(seq->size, GFP_KERNEL);
>> +               if (!seq->buf)
>> +                       goto Enomem;
> 
> Why not just mutex_unlock and exit with -ENOMEM? Less goto'ing, more
> straightforward.
> 
>> +       }
>> +
>> +       if (seq->count) {
>> +               n = min(seq->count, size);
>> +               err = copy_to_user(buf, seq->buf + seq->from, n);
>> +               if (err)
>> +                       goto Efault;
>> +               seq->count -= n;
>> +               seq->from += n;
>> +               copied = n;
>> +               goto Done;
>> +       }
>> +
>> +       seq->from = 0;
>> +       p = seq->op->start(seq, &seq->index);
>> +       if (!p || IS_ERR(p))
> 
> IS_ERR_OR_NULL?

Ack.

> 
>> +               goto Stop;
>> +
>> +       err = seq->op->show(seq, p);
>> +       if (seq_has_overflowed(seq)) {
>> +               err = -E2BIG;
>> +               goto Error_show;
>> +       } else if (err) {
>> +               /* < 0: go out, > 0: skip */
>> +               if (likely(err < 0))
>> +                       goto Error_show;
>> +               seq->count = 0;
>> +       }
> 
> This seems a bit more straightforward:
> 
> if (seq_has_overflowed(seq))
>      err = -E2BIG;
> if (err < 0)
>      goto Error_show;
> else if (err > 0)
>      seq->count = 0;
> 
> Also, I wonder if err > 0 (so skip was requested), should we ignore
> overflow? So something like:

Think about overflow vs. err > 0 case, I double checked seq_file()
implementation again, yes, it is skipped. So your suggestion below
looks reasonable.

> 
> if (err > 0) {
>      seq->count = 0;
> } else {
>      if (seq_has_overflowed(seq))
>          err = -E2BIG;
>      if (err)
>          goto Error_show;
> }
> 
>> +
>> +       while (1) {
>> +               loff_t pos = seq->index;
>> +
>> +               offs = seq->count;
>> +               p = seq->op->next(seq, p, &seq->index);
>> +               if (pos == seq->index) {
>> +                       pr_info_ratelimited("buggy seq_file .next function %ps "
>> +                               "did not updated position index\n",
>> +                               seq->op->next);
>> +                       seq->index++;
>> +               }
>> +
>> +               if (!p || IS_ERR(p)) {
> 
> Same, IS_ERR_OR_NULL.

Ack.

> 
>> +                       err = PTR_ERR(p);
>> +                       break;
>> +               }
>> +               if (seq->count >= size)
>> +                       break;
>> +
>> +               err = seq->op->show(seq, p);
>> +               if (seq_has_overflowed(seq)) {
>> +                       if (offs == 0) {
>> +                               err = -E2BIG;
>> +                               goto Error_show;
>> +                       }
>> +                       seq->count = offs;
>> +                       break;
>> +               } else if (err) {
>> +                       /* < 0: go out, > 0: skip */
>> +                       seq->count = offs;
>> +                       if (likely(err < 0)) {
>> +                               if (offs == 0)
>> +                                       goto Error_show;
>> +                               break;
>> +                       }
>> +               }
> 
> Same question here about ignoring overflow if skip was requested.

Yes, we should prioritize err > 0 over overflow.

> 
>> +       }
>> +Stop:
>> +       offs = seq->count;
>> +       /* may call bpf program */
>> +       seq->op->stop(seq, p);
>> +       if (seq_has_overflowed(seq)) {
>> +               if (offs == 0)
>> +                       goto Error_stop;
>> +               seq->count = offs;
> 
> just want to double-check, because it's not clear from the code. If
> all the start()/show()/next() succeeded, but stop() overflown. Would
> stop() be called again on subsequent read? Would start/show/next
> handle this correctly as well?

I am supposed to handle this unless there is a bug...
The idea is:
    - if start()/show()/next() is fine and stop() overflow,
      we will skip stop() output and move on.
      (if we found out, we skip to the beginning of the
       buffer, we will return -E2BIG. Otherwise, we will return
       0 here, the user read() may just exit.)
    - next time, when read() called again, the start() will return
      NULL (since previous next() returns NULL) and the control
      will jump to stop(), which will try to do another dump().

> 
>> +       }
>> +
>> +       n = min(seq->count, size);
>> +       err = copy_to_user(buf, seq->buf, n);
>> +       if (err)
>> +               goto Efault;
>> +       copied = n;
>> +       seq->count -= n;
>> +       seq->from = n;
>> +Done:
>> +       if (!copied)
>> +               copied = err;
>> +       else
>> +               *ppos += copied;
>> +       mutex_unlock(&seq->lock);
>> +       return copied;
>> +
>> +Error_show:
>> +       seq->op->stop(seq, p);
>> +Error_stop:
>> +       seq->count = 0;
>> +       goto Done;
>> +
>> +Enomem:
>> +       err = -ENOMEM;
>> +       goto Done;
>> +
>> +Efault:
>> +       err = -EFAULT;
>> +       goto Done;
> 
> Enomem and Efault seem completely redundant and just add goto
> complexity to this algorithm. Let's just inline `err =
> -E(NOMEM|FAULT); goto Done;` instead?

We can do this. This is kind of original seq_read() coding
style. Agree that we do not need to follow them.

> 
>> +}
>> +
>>   int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>>   {
>>          struct bpf_iter_target_info *tinfo;
>> --
>> 2.24.1
>>
