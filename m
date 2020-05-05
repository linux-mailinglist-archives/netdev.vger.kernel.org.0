Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872B61C6218
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgEEUbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:31:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60648 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726350AbgEEUbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:31:13 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045KT6Yg031510;
        Tue, 5 May 2020 13:30:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=a5oQX2x5ajE7dxJwxWssS87YV/ZKQnEHeg/ZdkyGO+M=;
 b=bI0AqY4TJaF+bfDcIyqpjAeda2Ut72pxEkdbvAz5Iiouf202tbcdLYjejDghFJqxq0UI
 65osqsW5ZAUD/3ZQzmK9J0lwYeTC1sQ0Jh2SAviiNF7UVBOmDCClg4/f5GP4SC0XpPKL
 KqKJZqTwBFgSB4qixQJAER2kfZUaDvuz7z0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30srvywdkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 13:30:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 13:30:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6C8KIvz/LrYENJDV1G9xgEnwIFj0zeMi8LjgeHd7afqBnzDxHd6Apl9ZkUViV7ji4q/uUzHI2Ij+7t6+BFusLIHRlO6GzQEqydu6UshLHVmMaxLwlKtCYne/R+3OyG69L4x81k6gTcN581ZND6SKGJSEfI2eca41KuHCLo93qwE9BWF20A0XQjO4JvXyB3QTeFNs8P4th5D0FTAq4nfcPx1193vLkVuJICZbUV5xh2OfdLkwTG8+WXxTJbDNAqPb41tHUKF9Xme8jBccf5WOpanfO2dc4Yagv4IcXoeCRgsYySk+6UsMuwE2IFnlWKT1bNfBGM3avmRas2MLPJpZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5oQX2x5ajE7dxJwxWssS87YV/ZKQnEHeg/ZdkyGO+M=;
 b=ZLNKvesnGXnbr8FLOt+IfClpynHh7+7fIjcZiialsnWpkuVVRqFCtzkhOlAeWGW4RWcpfxXAbUYNGnsAacAC0wk91/YL12DHbzwhLZZ7ArFm362Dfav9Cb5uCkcXwsJIgneC2lU8+/5RKuS+mu7XZTmgSM81D/wAddAdL1eUld2d5572clh8tP9e8uzqyYSDbdEaRHo+JBouckZKGghrFd/YCFjZfhptH4wxesOx8Pc7Gf7TuQa9oKCBuw3uSASzGvmzNYQfCbotPyZGdpFt1sHZYLRUfENf7tmpEeLhp0IeVoQ9FZCGEtSuLLILT95erSueRG9EM7BCKrXhB5kQBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5oQX2x5ajE7dxJwxWssS87YV/ZKQnEHeg/ZdkyGO+M=;
 b=hy6ICjeyCHpKBZZLusLSQ/cJt53nXfroJjmiHl2xb26q8/X7ma4MPaMQX6iRNiO95XtU23qlI9vZS9l04C26nkd5yPykFbhGq89vDunRa8KrnZCL2FK34St2VXRrahiDBggbjvkdndenUlOth/wtlONWMH8J4ma6pFjMeakA/IE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3398.namprd15.prod.outlook.com (2603:10b6:a03:10e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Tue, 5 May
 2020 20:30:46 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 20:30:46 +0000
Subject: Re: [PATCH bpf-next v2 08/20] bpf: implement common macros/helpers
 for target iterators
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062555.2048028-1-yhs@fb.com>
 <CAEf4BzZnzKrTX4sN+PJC8fhdv=+gXMTAan=OUfgRFtvusfnaWQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2794c31e-c750-7488-5e2b-a72a8791082b@fb.com>
Date:   Tue, 5 May 2020 13:30:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzZnzKrTX4sN+PJC8fhdv=+gXMTAan=OUfgRFtvusfnaWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0068.namprd07.prod.outlook.com
 (2603:10b6:a03:60::45) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:99aa) by BYAPR07CA0068.namprd07.prod.outlook.com (2603:10b6:a03:60::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 20:30:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:99aa]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ceb542af-1ac5-417b-795a-08d7f13330da
X-MS-TrafficTypeDiagnostic: BYAPR15MB3398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3398F70B96ECEC16758E11FDD3A70@BYAPR15MB3398.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IiG7zE4v7C6IjtBz/c/qHBHztS1rlc2CtKZGFYX6LsLvxbrIVc67lnm41u4vmVehUvYs579CwSX1u9+diAnw0vcIAgOEmkrqJhTZBQWxchaDipXos1Y+TxkkLDeuB1Cum2cU2JzOucmIavFvAFQDMePvx8bnWI+4wvZz5jLz8xt+1nRAqu0UTALg7ibLeOOXa6SZw6o02dNu4tYcABOX4H54sISOPURGqQYxMzEOPuKZqa+7D0GMAgsREmptFJ+dN+HD96GWT5gahtSnN4m4GnNK5ZJhmg3Sa3Ehn40i9ze8fhdphbSRypmzLsGZJKSn7btgR4zMZP2uvn6J5O7aCMOMntDz06brdbbW22lGaefPx8p9Yymbm66o1qhWLLqQdcvLzTym8ehj5akG9ysm04byNoC/Q59v0r9sCBppJ0gjCX+oJSTQatrk9fnLQtaHrEFMbbUULCL61QwwF777GnyOFdYnqvu4EByVaPYuyZefH/ujB/4MAtcMzjXVweNjkiCqntZ06dkxLz98NEznvQvYr0D0NbXHWaSz+Vs5RHYubrm2q+nry0Bo67lp0rj+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39850400004)(376002)(366004)(136003)(346002)(33430700001)(16526019)(66946007)(316002)(8676002)(66556008)(66476007)(186003)(53546011)(54906003)(478600001)(8936002)(4326008)(33440700001)(52116002)(6506007)(31686004)(6512007)(6486002)(2906002)(86362001)(2616005)(31696002)(36756003)(6916009)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: alYwVSr4Zdj/MxU8dvFBD+GQUx48at1Y6ox/tGbdi2kXYr6xpbwadZhAaRBpUETWc2YbdECNI1VOWTkFSn2jcJaKHA2VCQymBzDKeSCon8rxBoyUR0XV0lUrfRi93v7tva5PXHHcr8rmWTLxX7g3n9EIQpBVE+Z6PCXRHJ24Y55zN8zHRWWw3Kk36hYsjTJ5O+RQC+wx+JQkOfBQeb0FUx9SJ7jtxVw8k0bGrmr30cFIFGhNbTXM7LLbZQR6ZE47Ao2QuVcBWrecrFvFKhRYdsEXRUOB9eeNZRLLc2i5wJwWdF1vLuR6eF42l8BnnOuNjaE/z60+6xGldjhwKS1Y79hLek8WYBdRTumVcnOWHnymIOf7F+hV13mrTqC2GYJUBgLnuDmq3I0H4FKA0aIM+E9VIjBvGBtzW3zTUAgdQGDtDcNcFFY+7TfVjiUzO2mJ5X9y+YJO84d96YJZz0xADf2gQ4vEp0jA9uOVOKQwJlQ1dG+6aNeejoaegUejqG9I+vhFr3DedhmzV+KqCH0ra7UQr3RP7cKj5Qtw6fx+yOp0RhhuNYKY6ZCteGP7MEuvfpJLuJQ8ClAC62YJWdmews84lqR1j7bSsWF1Ap7olV6WR6QkJ7HSifJA06tWV9tnhv5ohw0OPcP6Kqa6dKSG3nmKCXPCJj45fJwuPOkzu49rRxIG4H/a8iTxHTHMb939ZWpcvEm3H8OOueIRpVnMwav8wq2mdEk3rOZnYqYpxpxn7XldIP2tEaWaUC/yW4RICQpgjdd3QE6BNhjBmfzpFktImqRT95fAPFcCo9ZA7xLAzvCOca3ctZo3n37SyCYYx98/zuxBfB62/UMCLYVJGw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb542af-1ac5-417b-795a-08d7f13330da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 20:30:46.3543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hOxg+OK7zFbtRfpYXsIRC9dapguhchoYtOfOGPUkvC9VpV7Ql+Z7fS+Xz7X+I5w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3398
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 1:25 PM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Macro DEFINE_BPF_ITER_FUNC is implemented so target
>> can define an init function to capture the BTF type
>> which represents the target.
>>
>> The bpf_iter_meta is a structure holding meta data, common
>> to all targets in the bpf program.
>>
>> Additional marker functions are called before/after
>> bpf_seq_read() show() and stop() callback functions
>> to help calculate precise seq_num and whether call bpf_prog
>> inside stop().
>>
>> Two functions, bpf_iter_get_info() and bpf_iter_run_prog(),
>> are implemented so target can get needed information from
>> bpf_iter infrastructure and can run the program.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h   | 11 +++++
>>   kernel/bpf/bpf_iter.c | 94 ++++++++++++++++++++++++++++++++++++++++---
>>   2 files changed, 100 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 26daf85cba10..70c71c3cd9e8 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1129,6 +1129,9 @@ int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>>   int bpf_obj_get_user(const char __user *pathname, int flags);
>>
>>   #define BPF_ITER_FUNC_PREFIX "__bpf_iter__"
>> +#define DEFINE_BPF_ITER_FUNC(target, args...)                  \
>> +       extern int __bpf_iter__ ## target(args);                \
>> +       int __init __bpf_iter__ ## target(args) { return 0; }
> 
> Why is extern declaration needed here? Doesn't the same macro define

Silence sparse warning. Apparently in kernel, any global function, they 
want a declaration?

> global function itself? I'm probably missing some C semantics thingy,
> sorry...
> 
>>
>>   typedef int (*bpf_iter_init_seq_priv_t)(void *private_data);
>>   typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
>> @@ -1141,11 +1144,19 @@ struct bpf_iter_reg {
>>          u32 seq_priv_size;
>>   };
>>
>> +struct bpf_iter_meta {
>> +       __bpf_md_ptr(struct seq_file *, seq);
>> +       u64 session_id;
>> +       u64 seq_num;
>> +};
>> +
> 
> [...]
> 
>>   /* bpf_seq_read, a customized and simpler version for bpf iterator.
>>    * no_llseek is assumed for this file.
>>    * The following are differences from seq_read():
>> @@ -83,12 +119,15 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>>          if (!p || IS_ERR(p))
>>                  goto Stop;
>>
>> +       bpf_iter_inc_seq_num(seq);
> 
> so seq_num is one-based, not zero-based? So on first show() call it
> will be set to 1, not 0, right?

It is 1 based, we need to document this clearly. I forgot to adjust my 
bpf program for this. Will adjust them properly in the next revision.
> 
>>          err = seq->op->show(seq, p);
>>          if (seq_has_overflowed(seq)) {
>> +               bpf_iter_dec_seq_num(seq);
>>                  err = -E2BIG;
>>                  goto Error_show;
>>          } else if (err) {
>>                  /* < 0: go out, > 0: skip */
>> +               bpf_iter_dec_seq_num(seq);
>>                  if (likely(err < 0))
>>                          goto Error_show;
>>                  seq->count = 0;
> 
> [...]
> 
