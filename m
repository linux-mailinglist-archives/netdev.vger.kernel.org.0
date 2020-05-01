Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCDA1C1B9B
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgEARXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:23:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63814 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728933AbgEARXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:23:37 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 041HKtCY002122;
        Fri, 1 May 2020 10:23:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SECoVfBQQhfBBP2CSfuB7D7ILpikIJpbZxHGxPE9DI4=;
 b=L/KBfmiFj5HfyGOtZT4FntIp79gEivJYTMqjbeSl24o7rA/3VdalSpLEkaAX0W6cxotD
 oh9vV0re9v2a4Z6vqE34fR56z8HlexlsrwWpMx6Q1A7sNl5xipDC8fkr+4WJ4yh/62Qd
 5cYBK99acW31RmXqoIeEYZII6CPjBTCnlbw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30r7eacmv0-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 01 May 2020 10:23:22 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 1 May 2020 10:23:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RN1x7ZCEkTemd5RaLpU1Ne+n8WbwSWkf2vo490fliM3ww/6xa6qQBtcBYJO959Ny5Al0WHiQyUaYWl5NQRH65wg+JVbvT8UC8Q4QshTVBiZ2Ey8Vcj5xJc0I+6rtenMocfo5qH0MmuSiMkLB3B4IAoJgfkbuhzNCsdXgJpB7aW2EnNnZd4Creycs9P7H3t04eb4u+P+FJhyBYLlmc8f4nD0RDPjIjKEwMcepOw4653UaJv/VgMoZFrlIsgexYLT8/7/Sbaae/b2z0FSLpYZfP5RrxqhoGYo3jZmisa0QRs4yW61WyexDtlTxj9LOS3+Lgj8YlTLhTbepF8YnrOkFzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SECoVfBQQhfBBP2CSfuB7D7ILpikIJpbZxHGxPE9DI4=;
 b=ZjSDTB8Z3sp6HrU59ME9r0le1/XAgpZbybc+/HnbMi6+XxxylAhY9svDP9J1eXjsWdUWxmdpU/MIprF7pNDuOSccpzAphIbycbyvwIIIOyqjwCM8iZMkrdt2VEqwdz/teoxicsrit5zFuYKktYXk3gPBFjlEdzrjtaP11vQKBrQqj/mTfPOlMZG9rdi8ltanuRf2SpsLIoteRtZ1iHWs9LriAMeXa9MPllbo7YfPvIBtNzbOQ8kWchunzyfMATR3nnv95Ig6Tt2fcprA4nFbsnT9qk2Bx2wtIADwLDJ+7Z4Nn/5XorzmHv10aeWbFa43HGs9o+Zlvpp0kztcauUkEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SECoVfBQQhfBBP2CSfuB7D7ILpikIJpbZxHGxPE9DI4=;
 b=SQc/WRkaX5XKC4/AN/kcOE92LXNjOeTLF+/UDmt3JcUqDUOtMJvJi9Yl2ZpeSMQV05nDha1W2Oaw/7z7n5HpnzDwXQ4CfRhpyM6nb5QT/dfFANOhhfIR3GzE8Zrru5ax3/ypyntGMJX4wavI6CSBAbqHhtnikKGQBDkNvycObD0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3446.namprd15.prod.outlook.com (2603:10b6:a03:109::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Fri, 1 May
 2020 17:23:19 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.027; Fri, 1 May 2020
 17:23:19 +0000
Subject: Re: [PATCH bpf-next v1 11/19] bpf: add task and task/file targets
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201247.2995622-1-yhs@fb.com>
 <CAEf4BzaWkKbtDQf=0gOBj7Q6icswh61ky3FFS8bAmhkefDV0tg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dc46e006-468d-22d6-91bc-2c8e75590205@fb.com>
Date:   Fri, 1 May 2020 10:23:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzaWkKbtDQf=0gOBj7Q6icswh61ky3FFS8bAmhkefDV0tg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::27) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:c10f) by BYAPR02CA0014.namprd02.prod.outlook.com (2603:10b6:a02:ee::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Fri, 1 May 2020 17:23:19 +0000
X-Originating-IP: [2620:10d:c090:400::5:c10f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f29f52a9-7c30-4a5a-5cbd-08d7edf457c2
X-MS-TrafficTypeDiagnostic: BYAPR15MB3446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3446B3860882B22BC6815FA9D3AB0@BYAPR15MB3446.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uKWYlAHBkSXpIRM2+yr3IK8Jkb8zi1kgTaZc65FzdTy+Oy36b5BuYEWiLdNPf1Tzt3BkWETvzBDlaF2MvpTVCszoOgL+470RCi6lCwm7goLZgbZK797WP1xOODwhRejU0Jc2nGcfEynu9Rndl0rr43SpijGNbzNfdPkyPN47kFbxbhFzoHHbaqfQrkLr7bHfmahvRQo07TO/D9ULdajddDXgL20XvrF2HPw6seV90h8upy4KGuk10OcY/qSHfom5FZBRIH9xKCSmdwcLilohUxRLdmLAI0P/VvxGM5AnGeHOa0mJWbe7HBBbyiXQ7Mx12vnVAtPxMsPGRb15PbFxiMgnZxW9J/yo5UbFPXKpzS8zVTyS+aWAI4t2Gf4eyeI/M/RAZlt1d85KGNDSrFDftL/r1jQaQVmGsyGkIxhA5IvlbfvNuF234mUbgajcuECB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(39860400002)(396003)(366004)(136003)(4326008)(6486002)(6916009)(6512007)(31696002)(66946007)(478600001)(66556008)(2906002)(66476007)(31686004)(8936002)(316002)(86362001)(2616005)(54906003)(16526019)(186003)(8676002)(5660300002)(36756003)(53546011)(6506007)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: fR5NZyOzDOsPJomnfrjXSNNUcJIAix7NmSl+4oW/lxe3QHlwtJTMep4NRNipfSJwgPXdo+fWAq+4bTE4u27muOfOjS8w/XiKffXxKpEu8XX2faLMi4k0epf6khbOH5mJRHTneEwy/zXRtJ9s+YNqgB2onMQwmS6g+8pY2XmEaC+fdJmJurov07JkOSksRoGeoqNFfHbObkNtXBBSCEqOImn2KZrmla+dk8S0FrbcZB/zVnNDI9Wb4JIgnU6nMaj3AguhsvLsS7WpXNFDugzkkWMovU3W2kEiqXT0/7CmBDum3lpocdBOqBLZuXWG0OdU/pqtO6F/g+nNT5xUEtZ+UKPkYZVBMqQppvw7ieQQcJIJSISwLpcF85X+vMRC2j34OrXaWUHaFskLhZqgtMDy4TcnUKcd8RxckpQR5wF4XBL7LcxslTMo79RgmCjMCcNMe1DPhSSR6Q78YzBOcgC6SNnUWjG7hl0fwbqXbfmpXOmmb4uILIEpmuo4WgDpNOkod0R+79cCGkiG37oY4p5ChN2NBIn1GjQJh9VEJO5K6tjm5lYW5G5evKH6urBd/Kwg5M91R8N59E1HfFDUXXgypnW7CgAHR+4d7XnSZCK53iADEedbsjJk6QmK2iaKurVAr7BVjiHN7E+abPj2RbqhT6Ux+LRiJ8q2AkbpCtfKvj87bTLAKJFR3dh/Sby3aHOfkFCoegxbwqNmDlyNTNBZ4M/5MKO/S0skM6f21VRFX2+NpzyqezwsA4ARtRwTjv0Hx+zGWK483kljkKQRthGtFdB+uPCij/iqnd+09gVLx1fUxJ1n09dgTLQ+lQ1vgjCwVka78rhrSk45/Lv/idYx3A==
X-MS-Exchange-CrossTenant-Network-Message-Id: f29f52a9-7c30-4a5a-5cbd-08d7edf457c2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 17:23:19.7442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7HQpjwWIx54SybH8optlf5iemAmJbWfO+cO32qEHyfd4eQrDyqZ1Okc098NRNhI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3446
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-01_11:2020-05-01,2020-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 7:08 PM, Andrii Nakryiko wrote:
> On Mon, Apr 27, 2020 at 1:17 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Only the tasks belonging to "current" pid namespace
>> are enumerated.
>>
>> For task/file target, the bpf program will have access to
>>    struct task_struct *task
>>    u32 fd
>>    struct file *file
>> where fd/file is an open file for the task.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   kernel/bpf/Makefile    |   2 +-
>>   kernel/bpf/task_iter.c | 319 +++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 320 insertions(+), 1 deletion(-)
>>   create mode 100644 kernel/bpf/task_iter.c
>>
> 
> [...]
> 
>> +static void *task_seq_start(struct seq_file *seq, loff_t *pos)
>> +{
>> +       struct bpf_iter_seq_task_info *info = seq->private;
>> +       struct task_struct *task;
>> +       u32 id = info->id;
>> +
>> +       if (*pos == 0)
>> +               info->ns = task_active_pid_ns(current);
> 
> I wonder why pid namespace is set in start() callback each time, while
> net_ns was set once when seq_file is created. I think it should be
> consistent, no? Either pid_ns is another feature and is set
> consistently just once using the context of the process that creates
> seq_file, or net_ns could be set using the same method without
> bpf_iter infra knowing about this feature? Or there are some
> non-obvious aspects which make pid_ns easier to work with?
> 
> Either way, process read()'ing seq_file might be different than
> process open()'ing seq_file, so they might have different namespaces.
> We need to decide explicitly which context should be used and do it
> consistently.

Good point. for networking case, the `net` namespace is locked
at seq_file open stage and later on it is used for seq_read().

I think I should do the same thing, locking down pid namespace
at open.

> 
>> +
>> +       task = task_seq_get_next(info->ns, &id);
>> +       if (!task)
>> +               return NULL;
>> +
>> +       ++*pos;
>> +       info->task = task;
>> +       info->id = id;
>> +
>> +       return task;
>> +}
>> +
>> +static void *task_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>> +{
>> +       struct bpf_iter_seq_task_info *info = seq->private;
>> +       struct task_struct *task;
>> +
>> +       ++*pos;
>> +       ++info->id;
> 
> this would make iterator skip pid 0? Is that by design?

The start will try to find pid 0. That means start will never
return SEQ_START_TOKEN since the bpf program won't be called any way.

> 
>> +       task = task_seq_get_next(info->ns, &info->id);
>> +       if (!task)
>> +               return NULL;
>> +
>> +       put_task_struct(info->task);
> 
> on very first iteration info->task might be NULL, right?

Even the first iteration info->task is not NULL. The start()
will forcefully try to find the first real task from idr number 0.

> 
>> +       info->task = task;
>> +       return task;
>> +}
>> +
>> +struct bpf_iter__task {
>> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
>> +       __bpf_md_ptr(struct task_struct *, task);
>> +};
>> +
>> +int __init __bpf_iter__task(struct bpf_iter_meta *meta, struct task_struct *task)
>> +{
>> +       return 0;
>> +}
>> +
>> +static int task_seq_show(struct seq_file *seq, void *v)
>> +{
>> +       struct bpf_iter_meta meta;
>> +       struct bpf_iter__task ctx;
>> +       struct bpf_prog *prog;
>> +       int ret = 0;
>> +
>> +       prog = bpf_iter_get_prog(seq, sizeof(struct bpf_iter_seq_task_info),
>> +                                &meta.session_id, &meta.seq_num,
>> +                                v == (void *)0);
>> +       if (prog) {
> 
> can it happen that prog is NULL?

Yes, this function is shared between show() and stop().
The stop() function might be called multiple times since
user can repeatedly try read() although there is nothing
there, in which case, the seq_ops will be just
start() and stop().

> 
> 
>> +               meta.seq = seq;
>> +               ctx.meta = &meta;
>> +               ctx.task = v;
>> +               ret = bpf_iter_run_prog(prog, &ctx);
>> +       }
>> +
>> +       return ret == 0 ? 0 : -EINVAL;
>> +}
>> +
>> +static void task_seq_stop(struct seq_file *seq, void *v)
>> +{
>> +       struct bpf_iter_seq_task_info *info = seq->private;
>> +
>> +       if (!v)
>> +               task_seq_show(seq, v);
> 
> hmm... show() called from stop()? what's the case where this is necessary?

I will refactor it better. This is to invoke bpf program
in stop() with NULL object to signal the end of
iteration.

>> +
>> +       if (info->task) {
>> +               put_task_struct(info->task);
>> +               info->task = NULL;
>> +       }
>> +}
>> +
> 
> [...]
> 
