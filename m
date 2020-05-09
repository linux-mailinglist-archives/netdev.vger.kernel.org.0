Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E96E1CBC23
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 03:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgEIBlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 21:41:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727828AbgEIBlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 21:41:21 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0491aAQu027349;
        Fri, 8 May 2020 18:41:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KBoz9SXJU/EzOPfx3pNdY3NSe7vmySTxamnOnkYQCWo=;
 b=Lo5vSD11kSETre6bJaCc2VNRAzYFu82XwNA4AuoxrST6E8nlx06j241fE1np/6bkN99g
 9ipslJmKZJPGKcaevcFYA5Vjk+iqtZCvvlGml54ctBQoFVGrhnUDZjbEPhfQUt/x7ncj
 9+kAVFQpMc6lSPGQFds2qv6Z/bNtrBqhu6c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtdxy5rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 May 2020 18:41:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 18:41:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTxuOQLtzx5cQzvlIzrwY5A/gUrhOcGu11bvhSKd7mCDzQnUGfPMcQRCvgx4ce2ZlCO76/aEjblAQWaGrpWcqcOzraWL/eixZD+4FNL7Mb1xG5qMXiCue/hX+MKE1gFPaak0D4FfhemF+aY8vwdhclVXY5jnA7PW/xa5NCo9Zg6vaV1ISq5fWVEbSockpjlPSbRhjwvUzlWyrN5ObSwEKXaKF4/vOLG0ctY0gNyx2pip6XXgZ97EGDZ+266A7ZJcvikOx8R5klxcsRn9am5Nr7cbGIgINY28ryicmJ+Xn8i5F2T70xmXiFzMA/dKArh81FOE40yNboQbg4HQNI16Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBoz9SXJU/EzOPfx3pNdY3NSe7vmySTxamnOnkYQCWo=;
 b=Qu34nNpvgOGbrz2KryWzEUFIXgr8R8Z97rTeeRCI2dHKbLsvlE8y5T5UmJdBxMy/0J7y28i2FZpqUZ+e3/J2fLuNfn7+ZG4FGoDKO9pFoI60vpS/OHICxi20tUNoQ5Uc3KTSapniLQzGIlYJKtkCvsEUD+4qaVteBahOly2NcBJzMnj3v14dMmV7BOt7dAVN+gLn77jsgCsCKMsa+8Y2s+T6HJLfsKGxYC/fzxcDBkVxYgIobk0f+VTbScFZSyDGftX3SGtVqrDTziTMCUTcV/w9mV8TSxcsBXT5Jr2Vk7NtzmjykUzLrg89XbrBjtPANAXOB4VVgFwPAsIjxEVlfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBoz9SXJU/EzOPfx3pNdY3NSe7vmySTxamnOnkYQCWo=;
 b=JIo4sGU89t6TZJXSkOpPkS/26WQO/HVU5E6iNzKQgqsDBWlze7p9vHljKxnfy6174GidKO4oL/orur3XwWHL0Kfchun39aWTqY9SXPlKTFyC84H34s3QRK1QZcVWw3Ty91UGI2e18iDmjHy5u0sjvmmYZuvAyG0b3gsCiFxXrws=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3253.namprd15.prod.outlook.com (2603:10b6:a03:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Sat, 9 May
 2020 01:41:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sat, 9 May 2020
 01:41:04 +0000
Subject: Re: [PATCH bpf-next v3 05/21] bpf: implement bpf_seq_read() for bpf
 iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
 <20200507053920.1542763-1-yhs@fb.com>
 <CAEf4BzZ_TnCdvTucUpr1CRiGqnf7GZfdyXmszToTTLYyQxbk4Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <62858d10-0200-592f-1bf4-e97f462a9c68@fb.com>
Date:   Fri, 8 May 2020 18:41:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEf4BzZ_TnCdvTucUpr1CRiGqnf7GZfdyXmszToTTLYyQxbk4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0078.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from joshferguson-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:6692) by BYAPR11CA0078.namprd11.prod.outlook.com (2603:10b6:a03:f4::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Sat, 9 May 2020 01:41:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:6692]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 214b1658-4910-47e1-8dcf-08d7f3ba098c
X-MS-TrafficTypeDiagnostic: BYAPR15MB3253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3253AF85FA637667C4644BDAD3A30@BYAPR15MB3253.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03982FDC1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zUl4+/YXYEW3FNqC0cnA8I1XXV/rsc+vmG7FbDpmQluTgO+6D+gd+kC7HYW2lyCQ9rfPztsGU9fSxhgRPLyD37ZDkxzJhplaDshlqntFyOPypbmzstJoDJKSrBtmD22GSV0iJAbp+rK9m5zY9lyL/ztPYAx3GhokqzySwblr7HpoBasKqSgF1dBP24nw/nwHZQhBxw4OB336bNflTjGhL9A69XkY/gtjXUv9tuLEsD9r66Dj1cl86F1Ne5N3/50hraetbR57A6Isfnp9OAEq27CT/3rdUa1+lD/G/yIsxqkJGILqkE9SfBem9FqOAaFVwjFnA7JuJY3p4Ho2alBVIDRyscERl5vPtSndq2OY9EGqRhrwth3KoAf4l58PuxVqLHYMVeeUUTLxMlb+lO+xOYvcor2TnXeu8U7ECZHJoO4auJkGJ7kgyVmrrvyt4hAIJ8W0rAQQnZaM3RCOAZ8ayeEUtonz4nOjNGbMFI4oYQRinXQk5yAseNdVPgzzppWNB72uFVH+ZXATsRVLk6p6kbD/K6DbBcElkX0XDx1rRBwIKHDo3GoI/99OjN3bg9uL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(136003)(39860400002)(376002)(366004)(33430700001)(53546011)(31696002)(2906002)(478600001)(31686004)(36756003)(186003)(6486002)(6916009)(6506007)(33440700001)(5660300002)(66946007)(54906003)(66476007)(66556008)(4326008)(8936002)(2616005)(6512007)(316002)(16526019)(86362001)(52116002)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cnOVQwvzKNxyhpRXSCbk/HpNT+GOUgSdAr+CJMTd2MbYCXTemlgW71+Pv94u27pOX/7Iw2tddRBYknHgHijnsZnhoo+eq3dLZHL4tv96q0DL2pddyNTrBqIw6mF8XCnYm4dc+BRHtLSagnb/KiUm6s/oDuaFo4GwOmQdRQFekZXUOtFBukYaII+kVt4kdhtg8QSZaxhYCaww8s8+bqRfk4uwnf5tpBW0uPaRH44eGLNIdAHhWXVCXRGSfqT93Exf7KSJ9H6ImrvMT94pFIudlHm8T1NVBLTkO4pjrXzSjYvorNTUs4W3nGlQU1N+cxVYSn0QMlncQbqho+e43yDjiy8wyJKhDjORqVcCGy1+QnbqdKwiM004YGjLeCw7hWDM5tuc06qrapuz2goyhWbZennAcHBN+3pK0gTF/gz+OMjrSOXFV/b5YPWvd1KAZlG/luUPk5ULxucK7PkefIQTtCNl5i+BKIsYiLHK83DxbWiRd2AU57spAXebEC5zfNOYWaLuxWaRObluoCnPucuzWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 214b1658-4910-47e1-8dcf-08d7f3ba098c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2020 01:41:04.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ktIAXtwU4zbLX4t9BPy3708niaW93BQ/5CRJKBm0CNhCwgVIhIIpyIsEhHmQavf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3253
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_20:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 11:52 AM, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 10:39 PM Yonghong Song <yhs@fb.com> wrote:
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
> 
> This loop is much simpler and more streamlined now, thanks a lot! I
> think it's correct, see below about one confusing (but apparently
> correct) bit, though. Either way:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>>   kernel/bpf/bpf_iter.c | 118 ++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 118 insertions(+)
>>
>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>> index 0542a243b78c..f198597b0ea4 100644
>> --- a/kernel/bpf/bpf_iter.c
>> +++ b/kernel/bpf/bpf_iter.c
>> @@ -26,6 +26,124 @@ static DEFINE_MUTEX(targets_mutex);
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
>> +               if (!seq->buf) {
>> +                       err = -ENOMEM;
>> +                       goto done;
> 
> oh, thank you for converting to all lower-case label names! :)
> 
>> +               }
>> +       }
>> +
>> +       if (seq->count) {
>> +               n = min(seq->count, size);
>> +               err = copy_to_user(buf, seq->buf + seq->from, n);
>> +               if (err) {
>> +                       err = -EFAULT;
>> +                       goto done;
>> +               }
>> +               seq->count -= n;
>> +               seq->from += n;
>> +               copied = n;
>> +               goto done;
>> +       }
>> +
>> +       seq->from = 0;
>> +       p = seq->op->start(seq, &seq->index);
>> +       if (IS_ERR_OR_NULL(p))
>> +               goto stop;
> 
> if start() returns IS_ERR(p), stop(p) below won't produce any output
> (because BPF program is called only for p == NULL), so we'll just
> return 0 with no error, do I interpret the code correctly? I think
> seq_file's read actually returns PTR_ERR(p) as a result in this case.
> 
> so I think you need err = PTR_ERR(p); before goto stop here?

Thanks for catching this!
Yes, seq_file() indeed returns PTR_ERR(p) to user space here.
Will make the change.

> 
>> +
>> +       err = seq->op->show(seq, p);
>> +       if (err > 0) {
>> +               seq->count = 0;
>> +       } else if (err < 0 || seq_has_overflowed(seq)) {
>> +               if (!err)
>> +                       err = -E2BIG;
>> +               seq->count = 0;
>> +               seq->op->stop(seq, p);
>> +               goto done;
>> +       }
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
>> +               if (IS_ERR_OR_NULL(p)) {
>> +                       err = PTR_ERR(p);
>> +                       break;
>> +               }
>> +               if (seq->count >= size)
>> +                       break;
>> +
>> +               err = seq->op->show(seq, p);
>> +               if (err > 0) {
>> +                       seq->count = offs;
>> +               } else if (err < 0 || seq_has_overflowed(seq)) {
>> +                       seq->count = offs;
>> +                       if (!err)
>> +                               err = -E2BIG;
> 
> nit: this -E2BIG is set unconditionally even for 2nd+ show(). This
> will work, because it will get ignored on next iteration, but I think
> it will be much more obvious if written as:
> 
> if (!err && offs = 0)
>      err = -E2BIG;

Yes, will make the change since it indeed makes code more readable.

> 
> It took me few re-readings of the code I'm pretty familiar with
> already to realize that this is ok.
> 
> I had to write the below piece to realize that this is fine :) Just
> leaving here just in case you find it useful:
> 
> else if (err < 0 || seq_has_overflowed(seq)) {
>      if (!err && offs == 0) /* overflow in first show() output */
>          err = -E2BIG;
>      if (err) {             /* overflow in first show() or real error happened */
>          seq->count = 0; /* not strictly necessary, but shows that we
> are truncating output */
>          seq->op->stop(seq, p);
>          goto done; /* done will return err */
>      }
>      /* no error and overflow for 2nd+ show(), roll back output and stop */
>      seq->count = offs;
>      break;
> }
> 
>> +                       if (offs == 0) {
>> +                               seq->op->stop(seq, p);
>> +                               goto done;
>> +                       }
>> +                       break;
>> +               }
>> +       }
>> +stop:
>> +       offs = seq->count;
>> +       /* bpf program called if !p */
>> +       seq->op->stop(seq, p);
>> +       if (!p && seq_has_overflowed(seq)) {
>> +               seq->count = offs;
>> +               if (offs == 0) {
>> +                       err = -E2BIG;
>> +                       goto done;
>> +               }
>> +       }
>> +
>> +       n = min(seq->count, size);
>> +       err = copy_to_user(buf, seq->buf, n);
>> +       if (err) {
>> +               err = -EFAULT;
>> +               goto done;
>> +       }
>> +       copied = n;
>> +       seq->count -= n;
>> +       seq->from = n;
>> +done:
>> +       if (!copied)
>> +               copied = err;
>> +       else
>> +               *ppos += copied;
>> +       mutex_unlock(&seq->lock);
>> +       return copied;
>> +}
>> +
>>   int bpf_iter_reg_target(struct bpf_iter_reg *reg_info)
>>   {
>>          struct bpf_iter_target_info *tinfo;
>> --
>> 2.24.1
>>
