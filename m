Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6557C1A4CA4
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 01:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgDJX2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 19:28:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50358 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726582AbgDJX2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 19:28:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03ANPML6032278;
        Fri, 10 Apr 2020 16:28:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kluFxUKLFOCePABCksoUJwzmLE5f9mNkbEAza+f3l2c=;
 b=Xr0i56yYDydmHykqejhFVsEKWxCYX8iLXjfOlt0E/sACuJvg15JhEry0QmbM2YeXwu/t
 jv5lcR1pMgjYJtqKm72z+T08okoRDEWqrl9zrlbeSClxJXeqxMm5NOc3/SHwXj+nCYRg
 f44T2EXTvXjgVzUw/6k3xkVUAL+qx/QOjqw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30a6200nrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 16:28:36 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 16:28:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8t7hb6aKM3hQIrSDdDtMB+gDX55lY8liIvAgg0Uzd02VZBQrY8ppG4M9l6Ft/VDfo0c4AbyVKwyKyNXmjQP+jJlk7O4NRByOiy6CNtQ/eYc+GlLngLoHkbhZedIEH1MgfvVKzlcrfdb3NuShOqfQV5nxPR9kSOto36A7XgWfIjey11Qz2MDe+eRJ8vauWqM2bS6ePkdM/tmDJOBvmSSQC1khbnwjuw3mWhu/rnND4+hxpC1D6L+P4pkUEtylOU8yao7CppnRtdXbJvh2HyA0rmI39LlzRvB02gMsq85X/7siWQUV3tUFGScx/E58S2nHHlRo1QOogqg5prAVzxG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kluFxUKLFOCePABCksoUJwzmLE5f9mNkbEAza+f3l2c=;
 b=GDZ36QPwMR+v5fie3snC+K3qffyrBBn9ThK8iXv6D8XQFubhE0kTUNU/Crdf4zhrKWEUbLPFi6JrdMDcqYznu3FIjrBrP+laW3b1xeOV0FChltmMjUXgo0USQEp/gBFoDoIH5iKzlXZQCyqheER0Z0rC1LBX4QTGaRRVJPs1MEJI4iuuD4GEdS5jyzfhVXsSPyiTqE657xYcpTTHT4Y0vs2O78GuhulHt29f88nbKbfPRGEPopH4dLIcisEOaDH4dAc98So52LV1/iXJpWlZuFUUSks7Pvj27b/Ew5YU5qkyHRbw23U/FTX/p2w6/jHy72GSBFqs2hWkM2cZybckTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kluFxUKLFOCePABCksoUJwzmLE5f9mNkbEAza+f3l2c=;
 b=g2+mt7HBHszGNiZcm2pcaoqibhEodotjHxIWewMHmbJT+oGwsGIowFFldg1fr9uJ8wDbNfaXoqGyzbhceKb/KIVRqfk6na0p6oPQpw6iJxaAZ8CnD93/RmkaVT3jYDG7ymd/wlCoKAK7hHzHzSw6bbR8mO7NKfqmsXM06zhV1SE=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3913.namprd15.prod.outlook.com (2603:10b6:303:42::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 23:28:33 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 23:28:33 +0000
Subject: Re: [RFC PATCH bpf-next 04/16] bpf: allow loading of a dumper program
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232524.2675603-1-yhs@fb.com>
 <CAEf4BzaTvAMOLVfhqvFCY_5Aj32J4vVSm343-C4Cg7Xyr65H4w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8005135f-03a1-17ae-29ca-c0b4b68c1eaa@fb.com>
Date:   Fri, 10 Apr 2020 16:28:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzaTvAMOLVfhqvFCY_5Aj32J4vVSm343-C4Cg7Xyr65H4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1201CA0013.namprd12.prod.outlook.com
 (2603:10b6:301:4a::23) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e0e4) by MWHPR1201CA0013.namprd12.prod.outlook.com (2603:10b6:301:4a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.20 via Frontend Transport; Fri, 10 Apr 2020 23:28:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:e0e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf60c2a1-8968-4a7e-1227-08d7dda6e2a2
X-MS-TrafficTypeDiagnostic: MW3PR15MB3913:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB39130D39C749110FE4198001D3DE0@MW3PR15MB3913.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(396003)(346002)(376002)(39860400002)(136003)(6512007)(66476007)(478600001)(4326008)(86362001)(6916009)(6486002)(2906002)(81156014)(16526019)(36756003)(54906003)(6506007)(5660300002)(66946007)(8676002)(31686004)(8936002)(186003)(52116002)(2616005)(316002)(53546011)(31696002)(66556008);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0EJ2UK8NQXJf7/JjEUtJTFx9AlJ+D9TfNvKyLu1kVu9bAZzpt0F7thTW3rY5fv7zhnGX2RXAheLxpEZehLmqLV70gx+No45Sjxbo8KKMXWRCOmVQCv5rLXJvq5bAfCoE+2mPWwILtkkT2ELb6Jh8TRz3ZQ3ecLfZmTWiTUxLBTgpy1jXLD3mvrNtEIOds/gptlZP8jzEKqme8n4L1fvEEi/bsVyqhpKVAlAWjRvzx28TpAP1FB10qJyCkChp5sRlr4GNthwM1DLHwQq2MSqC/XOLfZpvg3c5lfYLXb/JW2UuvJdnwVN8VLiJcaTZ5VHaZ/+RpTQ0Mm2ycyAWaqpg+SFBuFD99RAbNPgaDrRHVi+IalDK1s+20sxvXUYca/dWH4TFMumbMC/2NRXuuhZ4G/bgdbVz0gSiNTygpUvOxidgA60GLMaCyySXBhn0fNPd
X-MS-Exchange-AntiSpam-MessageData: Lnex84WwDYNHzuM+ZREEFc7tPnuq277/8jZ5Po01vxRC4oyZTBKKl2wKkeildl6/Mtqzy04N9qD9CHVIIQcIe26HsnjOuJKys3hGIaCUl5OdXBkWctHI/pPTkF0yAfe/SByJnn7CHe7OGNFmxieIm1tEgPP0XyhEhfb8EV5MmT3dPm3OoU5zGaI+0x4Qv4NF
X-MS-Exchange-CrossTenant-Network-Message-Id: cf60c2a1-8968-4a7e-1227-08d7dda6e2a2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 23:28:33.4837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5DsQRJRU0Yrx3vlCPCCmo0TMeFPtJqRlA9YAYqvAl7yVpPMfMQhxg+jiKmvkEHE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3913
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_10:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=2 lowpriorityscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/20 3:36 PM, Andrii Nakryiko wrote:
> On Wed, Apr 8, 2020 at 4:25 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> A dumper bpf program is a tracing program with attach type
>> BPF_TRACE_DUMP. During bpf program load, the load attribute
>>     attach_prog_fd
>> carries the target directory fd. The program will be
>> verified against btf_id of the target_proto.
>>
>> If the program is loaded successfully, the dump target, as
>> represented as a relative path to /sys/kernel/bpfdump,
>> will be remembered in prog->aux->dump_target, which will
>> be used later to create dumpers.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |  2 ++
>>   include/uapi/linux/bpf.h       |  1 +
>>   kernel/bpf/dump.c              | 40 ++++++++++++++++++++++++++++++++++
>>   kernel/bpf/syscall.c           |  8 ++++++-
>>   kernel/bpf/verifier.c          | 15 +++++++++++++
>>   tools/include/uapi/linux/bpf.h |  1 +
>>   6 files changed, 66 insertions(+), 1 deletion(-)
>>
> 
> [...]
> 
>>
>> +int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog)
>> +{
>> +       struct bpfdump_target_info *tinfo;
>> +       const char *target_proto;
>> +       struct file *target_file;
>> +       struct fd tfd;
>> +       int err = 0, btf_id;
>> +
>> +       if (!btf_vmlinux)
>> +               return -EINVAL;
>> +
>> +       tfd = fdget(target_fd);
>> +       target_file = tfd.file;
>> +       if (!target_file)
>> +               return -EBADF;
> 
> fdput is missing (or rather err = -BADF; goto done; ?)

No need to do fdput if tfd.file is NULL.

> 
> 
>> +
>> +       if (target_file->f_inode->i_op != &bpf_dir_iops) {
>> +               err = -EINVAL;
>> +               goto done;
>> +       }
>> +
>> +       tinfo = target_file->f_inode->i_private;
>> +       target_proto = tinfo->target_proto;
>> +       btf_id = btf_find_by_name_kind(btf_vmlinux, target_proto,
>> +                                      BTF_KIND_FUNC);
>> +
>> +       if (btf_id > 0) {
>> +               prog->aux->dump_target = tinfo->target;
>> +               prog->aux->attach_btf_id = btf_id;
>> +       }
>> +
>> +       err = min(btf_id, 0);
> 
> this min trick looks too clever... why not more straightforward and composable:
> 
> if (btf_id < 0) {
>      err = btf_id;
>      goto done;
> }
> 
> prog->aux->dump_target = tinfo->target;
> prog->aux->attach_btf_id = btf_id;
> 
> ?

this can be done.

> 
>> +done:
>> +       fdput(tfd);
>> +       return err;
>> +}
>> +
>>   int bpf_dump_reg_target(const char *target,
>>                          const char *target_proto,
>>                          const struct seq_operations *seq_ops,
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index 64783da34202..41005dee8957 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -2060,7 +2060,12 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>>
>>          prog->expected_attach_type = attr->expected_attach_type;
>>          prog->aux->attach_btf_id = attr->attach_btf_id;
>> -       if (attr->attach_prog_fd) {
>> +       if (type == BPF_PROG_TYPE_TRACING &&
>> +           attr->expected_attach_type == BPF_TRACE_DUMP) {
>> +               err = bpf_dump_set_target_info(attr->attach_prog_fd, prog);
> 
> looking at bpf_attr, it's not clear why attach_prog_fd and
> prog_ifindex were not combined into a single union field... this
> probably got missed? But in this case I'd say let's create a
> 
> union {
>      __u32 attach_prog_fd;
>      __u32 attach_target_fd; (similar to terminology for BPF_PROG_ATTACH)
> };
> 
> instead of reusing not-exactly-matching field names?

I thought about this, but thinking to avoid uapi change (although 
compatible). Maybe we should. Let me think about this.

> 
>> +               if (err)
>> +                       goto free_prog_nouncharge;
>> +       } else if (attr->attach_prog_fd) {
>>                  struct bpf_prog *tgt_prog;
>>
>>                  tgt_prog = bpf_prog_get(attr->attach_prog_fd);
>> @@ -2145,6 +2150,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>>          err = bpf_prog_new_fd(prog);
>>          if (err < 0)
>>                  bpf_prog_put(prog);
>> +
>>          return err;
>>
> 
> [...]
> 
