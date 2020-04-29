Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582191BE935
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgD2Uyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:54:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56594 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726871AbgD2Uyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:54:46 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TKk0IB014006;
        Wed, 29 Apr 2020 13:54:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fgLNw1Kh0lbjlp3uZcxmB5vIoSkkKvNEy4xI/NLGqJc=;
 b=aOgnRmqbgrZO/JoSqIVGS3VvUPoyTJnd+cz7jmNcrYuye0FZ4AzYPgD5HfFglqCYyXbc
 KF9+lPJPiWBTawbIagA436dcMRKWMIY3DM1OQJ24aZmvuCc6VwqzxryYNhnURoz+qotm
 AmmILWxSqmFtRlylAxDgqGVCi2Up7Hl9+Ek= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n5bxhk8f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 13:54:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 13:54:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZ8/Sn1x7oM/Ks5HTkaMnJmBTo/ExuNBVn5DfMmiRLwahkxerFrF9jB49K+yA4dqzUQgfff2yc8LApqkx4/67VWLTUpS4Rn0aNZqnOg4qMJnZWJQakvxcC9rhGj8ElrZSUFAhoPr/b/k8v4SfXrke3hvsAH1tK7ugRxWMgppkFostcxXFYq47RrNTctNS7jT2dNOUrZ6jqrrgG0UFgAfvouOPPzbMGDJBqxTMQn0c4NajkL02B7hfmXPBXqxOm6/LHHKSkwRO/KOTchhG0euFAWW+b7fr22EGu6fwE8kjSiQuntlo9dDSz5yJuqX47fiySJ/Axu66fJkAMJZJAtwjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgLNw1Kh0lbjlp3uZcxmB5vIoSkkKvNEy4xI/NLGqJc=;
 b=dzYBc7x8OT8IUqUV+R3EZfY2ZEBz8x00FvFQBZhEuz8xZla5KNewhs9xhr43W7C4Ea/Wzx05TwLEINl5C/48AAEROS3U7HnrRXhwGV8RWzv1OiiFHOk2PIK+ePQqhJHkFDQwKQvYgI9xoos5QVoBvAZYt6JzzU/Ri4MnhWsPzc6dnnxC7dlA038Ungm3Aa87SJyJxz/hUIzXDwMgshQQaRkZksCa4ZP88uuaGN6dHzpOCIanQ8bA/Q+7/yOxlV6d6H/Y61HB48wM9s9K9srPncDdacpCDqm6LwDoYu9G18f6T2avEcn+ig5L+m4lQxsq6C4h+UbkI7vBobfMHIfzEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgLNw1Kh0lbjlp3uZcxmB5vIoSkkKvNEy4xI/NLGqJc=;
 b=dSpb2UxSA5LVB7gJkzAT3KAF7D+AkH4Ib4y+T0Fl4+PUYR0oB8y0ZYy3lbLcJFAXFzxp6g2Vl2Cj2a08OZcYaLsVdyhDjy8upiOe/27r87epSwLd79HGvV9gHOU9SuJYGXDFDw0udk4XshdcC42zYcNsdFLI68fz52/N02mY4Rk=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3030.namprd15.prod.outlook.com (2603:10b6:a03:fb::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 20:54:29 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 20:54:29 +0000
Subject: Re: [PATCH bpf-next v1 07/19] bpf: create anonymous bpf iterator
To:     Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201242.2995160-1-yhs@fb.com>
 <CAEf4BzYtxOrzSW6Yy+0ABbm0Q71dkZTGDOcGCgHCVT=4ty5k1g@mail.gmail.com>
 <2b88797e-23b3-5df0-4d06-00b26912d14a@fb.com>
 <CAEf4BzaX_GgieGTdTG7cgDE=SxQZBaPrd3EfRGTKaNNSGrW0Tw@mail.gmail.com>
 <20200429184623.ul7nxelzxeip2ign@kafai-mbp>
 <88bfc829-3c2d-96aa-7d32-4f3ff9b4ad08@fb.com>
 <20200429205051.fjf7uxowggqoxozh@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3f9de8b8-45dc-a1f2-13d5-2f6345976814@fb.com>
Date:   Wed, 29 Apr 2020 13:54:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200429205051.fjf7uxowggqoxozh@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0007.namprd14.prod.outlook.com
 (2603:10b6:300:ae::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:99f7) by MWHPR14CA0007.namprd14.prod.outlook.com (2603:10b6:300:ae::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 20:54:27 +0000
X-Originating-IP: [2620:10d:c090:400::5:99f7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fdc1e03-4b25-46d0-f05d-08d7ec7f825c
X-MS-TrafficTypeDiagnostic: BYAPR15MB3030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3030A5E1624F997C5BBFAF37D3AD0@BYAPR15MB3030.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(376002)(136003)(39860400002)(366004)(66556008)(66946007)(86362001)(6862004)(6636002)(16526019)(5660300002)(4326008)(2906002)(66476007)(6512007)(8676002)(52116002)(186003)(8936002)(316002)(2616005)(54906003)(31696002)(53546011)(36756003)(31686004)(6486002)(6506007)(37006003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nxBrhvww0eUMX2zeln6S+6aT4QITflJJofTb33FFdnrIC4OiKBfsxFRNFym6ujve6f6bEq9QFbXyr8f/wUTi130rlNCLh3K2nAGzIizochF8G1Q3AaOUs4ij9YWG20E9mJ+EcmkBJxc+YJnjWma8Qtsbs+8oralIrzHCI1P2/J6T7J22KCPzW+7v57Y5kMRhlAsqv9lC0+9Xn96Xoc2qNaVz+GamscAWA64DpzDBI7FJKyfOXXYVCv+V/1wGu99yzSNDfwjqsTsr950soknQMpVBn9X0gjWfXo+QB/+NYxcN/RdavWujkjJkTXtOYg0nEeQFdkBPOCHW3InUQmPoqscVaMrhoyWVnRlcBDayVxlAHka0ZTufwtpnFbqBLzoHGOAeOuxM+n4UZANFo++rPxvWxSKWEhUQzfXvmdBdTc1Z99tzuRvbyjyo3Nsfpubd
X-MS-Exchange-AntiSpam-MessageData: L2uLnz7Q83AwMLGrLSrxibY/pbnxUcsm6zdd7qJSrRv0xwuiaLU/69xGdZVyOUOOU9OFDpJn76gWK+zi/qfPxdjjPjxmSz2moPaIykyvbvPiKRvHgt3zHmqf4K2KX+14aPex3KbcaHF55JHdZNjJwPf/fDNcxSibm+8a7FxcbNwtKPUdv+E1BwzWft6+7f4+1rMrwNF9r72BbwTIIGpmxujZX5GZTic8LbThEU3HklGilDhK40DOTui6EIxQFyMbOEeOSQ6GjgWhvuRRGEkk/m8NlF8gmQP/Kh/izimtEzQg2jVYxaN4yyVinPJ/x5lKmAWjieA+WLQPd7MSO+zbjWgYlJjqTB2tJZPLBojG+xUiR/syzWEgkorl9UMtIgpBq00j1vIZ40lk3b19/SRTZJfz1HdpFDIR4K9T7Gdyvv/lN0JViDHnIG5K6xATpwOnBQlLACALeiEVE2OI7I45wM8AICHu2heKjvGdc3fXQQyb4RuBMqmTRe998qYgfb0QPTMdW6y/cwrgw4M7qsNfN9F3tbUqFuQUj+sf9S2u7V5eCMjyISbxnffqrBXp9cp58NVb5AZZKH9XytOEUtlrB9lR7Fn4shzAuZoDFXOhsTuUOhDW4HVXF2DT6W2qc9J5CDquOyovywEVq990gFa4PRrz/c/6F7HbLu3ZaxxkA3dCT8MxZkpSOulROW70YQcYijkjwsFxZ7JFC08uEVYn+4V4i9h8AbFIiKBAJZ1VN1YByiLmuZJDZ/NhKXhv5bF74Qm6bkY7rD4QXhelVYPgZdaoXYyZo73Fsz6G+IGiy7RZCd8m6aOy2wpULoUaLzQ+mf1rueFXxSaMf1Qj9OwCXg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fdc1e03-4b25-46d0-f05d-08d7ec7f825c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 20:54:28.9914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6boTZ1aqEkWt/nSBQk+loeyMCECU08Uex+u/jCxrE/h8SyvBgXb4bdcBXHecqxP8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3030
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_10:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 1:50 PM, Martin KaFai Lau wrote:
> On Wed, Apr 29, 2020 at 12:20:05PM -0700, Yonghong Song wrote:
>>
>>
>> On 4/29/20 11:46 AM, Martin KaFai Lau wrote:
>>> On Wed, Apr 29, 2020 at 11:16:35AM -0700, Andrii Nakryiko wrote:
>>>> On Wed, Apr 29, 2020 at 12:07 AM Yonghong Song <yhs@fb.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 4/28/20 11:56 PM, Andrii Nakryiko wrote:
>>>>>> On Mon, Apr 27, 2020 at 1:19 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>>>
>>>>>>> A new bpf command BPF_ITER_CREATE is added.
>>>>>>>
>>>>>>> The anonymous bpf iterator is seq_file based.
>>>>>>> The seq_file private data are referenced by targets.
>>>>>>> The bpf_iter infrastructure allocated additional space
>>>>>>> at seq_file->private after the space used by targets
>>>>>>> to store some meta data, e.g.,
>>>>>>>      prog:       prog to run
>>>>>>>      session_id: an unique id for each opened seq_file
>>>>>>>      seq_num:    how many times bpf programs are queried in this session
>>>>>>>      has_last:   indicate whether or not bpf_prog has been called after
>>>>>>>                  all valid objects have been processed
>>>>>>>
>>>>>>> A map between file and prog/link is established to help
>>>>>>> fops->release(). When fops->release() is called, just based on
>>>>>>> inode and file, bpf program cannot be located since target
>>>>>>> seq_priv_size not available. This map helps retrieve the prog
>>>>>>> whose reference count needs to be decremented.
>>>>>>>
>>>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>>>> ---
>>>>>>>     include/linux/bpf.h            |   3 +
>>>>>>>     include/uapi/linux/bpf.h       |   6 ++
>>>>>>>     kernel/bpf/bpf_iter.c          | 162 ++++++++++++++++++++++++++++++++-
>>>>>>>     kernel/bpf/syscall.c           |  27 ++++++
>>>>>>>     tools/include/uapi/linux/bpf.h |   6 ++
>>>>>>>     5 files changed, 203 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>>>>>> index 4fc39d9b5cd0..0f0cafc65a04 100644
>>>>>>> --- a/include/linux/bpf.h
>>>>>>> +++ b/include/linux/bpf.h
>>>>>>> @@ -1112,6 +1112,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>>>>>>>     int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>>>>>>>     int bpf_obj_get_user(const char __user *pathname, int flags);
>>>>>>>
>>>>>>> +#define BPF_DUMP_SEQ_NET_PRIVATE       BIT(0)
>>>>>>> +
>>>>>>>     struct bpf_iter_reg {
>>>>>>>            const char *target;
>>>>>>>            const char *target_func_name;
>>>>>>> @@ -1133,6 +1135,7 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>>>>>>>     int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>>>>>>>     int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>>>>>>>                              struct bpf_prog *new_prog);
>>>>>>> +int bpf_iter_new_fd(struct bpf_link *link);
>>>>>>>
>>>>>>>     int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>>>>>>     int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>>>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>>>> index f39b9fec37ab..576651110d16 100644
>>>>>>> --- a/include/uapi/linux/bpf.h
>>>>>>> +++ b/include/uapi/linux/bpf.h
>>>>>>> @@ -113,6 +113,7 @@ enum bpf_cmd {
>>>>>>>            BPF_MAP_DELETE_BATCH,
>>>>>>>            BPF_LINK_CREATE,
>>>>>>>            BPF_LINK_UPDATE,
>>>>>>> +       BPF_ITER_CREATE,
>>>>>>>     };
>>>>>>>
>>>>>>>     enum bpf_map_type {
>>>>>>> @@ -590,6 +591,11 @@ union bpf_attr {
>>>>>>>                    __u32           old_prog_fd;
>>>>>>>            } link_update;
>>>>>>>
>>>>>>> +       struct { /* struct used by BPF_ITER_CREATE command */
>>>>>>> +               __u32           link_fd;
>>>>>>> +               __u32           flags;
>>>>>>> +       } iter_create;
>>>>>>> +
>>>>>>>     } __attribute__((aligned(8)));
>>>>>>>
>>>>>>>     /* The description below is an attempt at providing documentation to eBPF
>>>>>>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>>>>>>> index fc1ce5ee5c3f..1f4e778d1814 100644
>>>>>>> --- a/kernel/bpf/bpf_iter.c
>>>>>>> +++ b/kernel/bpf/bpf_iter.c
>>>>>>> @@ -2,6 +2,7 @@
>>>>>>>     /* Copyright (c) 2020 Facebook */
>>>>>>>
>>>>>>>     #include <linux/fs.h>
>>>>>>> +#include <linux/anon_inodes.h>
>>>>>>>     #include <linux/filter.h>
>>>>>>>     #include <linux/bpf.h>
>>>>>>>
>>>>>>> @@ -19,6 +20,19 @@ struct bpf_iter_link {
>>>>>>>            struct bpf_iter_target_info *tinfo;
>>>>>>>     };
>>>>>>>
>>>>>>> +struct extra_priv_data {
>>>>>>> +       struct bpf_prog *prog;
>>>>>>> +       u64 session_id;
>>>>>>> +       u64 seq_num;
>>>>>>> +       bool has_last;
>>>>>>> +};
>>>>>>> +
>>>>>>> +struct anon_file_prog_assoc {
>>>>>>> +       struct list_head list;
>>>>>>> +       struct file *file;
>>>>>>> +       struct bpf_prog *prog;
>>>>>>> +};
>>>>>>> +
>>>>>>>     static struct list_head targets;
>>>>>>>     static struct mutex targets_mutex;
>>>>>>>     static bool bpf_iter_inited = false;
>>>>>>> @@ -26,6 +40,50 @@ static bool bpf_iter_inited = false;
>>>>>>>     /* protect bpf_iter_link.link->prog upddate */
>>>>>>>     static struct mutex bpf_iter_mutex;
>>>>>>>
>>>>>>> +/* Since at anon seq_file release function, the prog cannot
>>>>>>> + * be retrieved since target seq_priv_size is not available.
>>>>>>> + * Keep a list of <anon_file, prog> mapping, so that
>>>>>>> + * at file release stage, the prog can be released properly.
>>>>>>> + */
>>>>>>> +static struct list_head anon_iter_info;
>>>>>>> +static struct mutex anon_iter_info_mutex;
>>>>>>> +
>>>>>>> +/* incremented on every opened seq_file */
>>>>>>> +static atomic64_t session_id;
>>>>>>> +
>>>>>>> +static u32 get_total_priv_dsize(u32 old_size)
>>>>>>> +{
>>>>>>> +       return roundup(old_size, 8) + sizeof(struct extra_priv_data);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
>>>>>>> +{
>>>>>>> +       return old_ptr + roundup(old_size, 8);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int anon_iter_release(struct inode *inode, struct file *file)
>>>>>>> +{
>>>>>>> +       struct anon_file_prog_assoc *finfo;
>>>>>>> +
>>>>>>> +       mutex_lock(&anon_iter_info_mutex);
>>>>>>> +       list_for_each_entry(finfo, &anon_iter_info, list) {
>>>>>>> +               if (finfo->file == file) {
>>>>>>
>>>>>> I'll look at this and other patches more thoroughly tomorrow with
>>>>>> clear head, but this iteration to find anon_file_prog_assoc is really
>>>>>> unfortunate.
>>>>>>
>>>>>> I think the problem is that you are allowing seq_file infrastructure
>>>>>> to call directly into target implementation of seq_operations without
>>>>>> intercepting them. If you change that and put whatever extra info is
>>>>>> necessary into seq_file->private in front of target's private state,
>>>>>> then you shouldn't need this, right?
>>>>>
>>>>> Yes. This is true. The idea is to minimize the target change.
>>>>> But maybe this is not a good goal by itself.
>>>>>
>>>>> You are right, if I intercept all seq_ops(), I do not need the
>>>>> above change, I can tailor seq_file private_data right before
>>>>> calling target one and restore after the target call.
>>>>>
>>>>> Originally I only have one interception, show(), now I have
>>>>> stop() too to call bpf at the end of iteration. Maybe I can
>>>>> interpret all four, I think. This way, I can also get ride
>>>>> of target feature.
>>>>
>>>> If the main goal is to minimize target changes and make them exactly
>>>> seq_operations implementation, then one easier way to get easy access
>>>> to our own metadata in seq_file->private is to set it to point
>>>> **after** our metadata, but before target's metadata. Roughly in
>>>> pseudo code:
>>>>
>>>> struct bpf_iter_seq_file_meta {} __attribute((aligned(8)));
>>>>
>>>> void *meta = kmalloc(sizeof(struct bpf_iter_seq_file_meta) +
>>>> target_private_size);
>>>> seq_file->private = meta + sizeof(struct bpf_iter_seq_file_meta);
>>> I have suggested the same thing earlier.  Good to know that we think alike ;)
>>>
>>> May be put them in a struct such that container_of...etc can be used:
>>> struct bpf_iter_private {
>>>           struct extra_priv_data iter_private;
>>> 	u8 target_private[] __aligned(8);
>>> };
>>
>> This should work, but need to intercept all seq_ops() operations
>> because target expects private data is `target_private` only.
>> Let me experiment what is the best way to do this.
> As long as "seq_file->private = bpf_iter_private->target_private;" as
> Andrii also suggested, the existing seq_ops() should not have to be
> changed or needed to be intercepted because they are only
> accessing it through seq_file->private.
> 
> The bpf_iter logic should be the only one needed to access the
> bpf_iter_private->iter_private and it can be obtained by, e.g.
> "container_of(seq_file->private, struct bpf_iter_private, target_private)"

Thanks for explanation! I never thought of using container_of
magic here. It indeed work very nicely.

> 
>>
>>>
>>>>
>>>>
>>>> Then to recover bpf_iter_Seq_file_meta:
>>>>
>>>> struct bpf_iter_seq_file_meta *meta = seq_file->private - sizeof(*meta);
>>>>
>>>> /* voila! */
>>>>
>>>> This doesn't have a benefit of making targets simpler, but will
>>>> require no changes to them at all. Plus less indirect calls, so less
>>>> performance penalty.
>>>>
