Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E811BE738
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgD2TUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:20:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgD2TUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:20:41 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03TJB3uA024920;
        Wed, 29 Apr 2020 12:20:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GLchTlKA+9gMCqzwP7MTSmDrih9SE8OPS6etDmljWc8=;
 b=nyG8BMMrUONfgxd5tZR/92BTNmr7DXaSjBd86Xjxe/BnxVMI1gH+F1YJJVtUAx8fs4lA
 oVAOoOe3s/OdJxKylP7vrCj3iL4jP11ohvW/HpfjkHhauwswF/8OW2/Y90sbKj6/5XZB
 VQBEBFBdgMZ705A7CrvlH3dkHt2Sb4vDKi4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30pq0dhn5v-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 12:20:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 12:20:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OETzlf4WBbFVjFiKYLlncWmq0bsk55UXy0M72Gwki2sMylQZnllbchwmttbXUORLzcCUCFvRxgijoaIuXvZjyGLxP457gCFLoA7RSnGYP4plDJL6zuTWE5ibGnNAdYESVGj8cZy907iujlZuWQnsjFav2cU7mkoFBuyTZ4PYfTBgPS+5Lmyrub0QebNDJ2RseHRtOdjRcAv7c0hvFycdBGsQmmL5pTpFkG6t5YSS86R+39TrhCGpqaOnsiY5/9x1YLzpFQ6cJ9AjMRgL385k7VLrE7jENOAaaGbIoV6SyNQXSKAUyYd290ZddyhhgHWpy0JhmqBhpGvfvETetimF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLchTlKA+9gMCqzwP7MTSmDrih9SE8OPS6etDmljWc8=;
 b=Ika4fQIQZALjok1eOcIbf1nW0IBcjWyCVHK3VVoeqZfTai2w23+BBCEeMP8zXyVaTh+BT6cwJySpMRKQpH6mIqe2VsIryOLDzJYgy7+RKjE2MATVoeAhehyPm9MN43AUfqdQlJnDTpXK29JyVSsZdo1NqM6v7teHqwEsc2/sLvG5MocgAJJuW3sii3dgeIBA8fkTW4EmXohNjJvnG2AXwITuygjdkQ4LzmJ7yQWJx6HJlQUFOqlgTO2Zqy6sih6cGsehy1DIyzfIW3g5gC+jYl4wjTTZgs6eKgMnBcxQIGQmAYsPJ2BuIfemk8QbuaCHAMOwjNrrefJBUX2cWImsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLchTlKA+9gMCqzwP7MTSmDrih9SE8OPS6etDmljWc8=;
 b=HVYO83ZMDsnDKhhaqjhtT+rPDXF6KoUzqK2ajlxlpnzCNIekKqnQAcH3wRMVSwyVc34hF0bvo5raMC0soSLoREb8KDfGlL/EukZ2MznCzNJ8oTjTPgyqbUD0RvVTHp2G/4mOInVKJKCTMyHmkIlhUCvuE5gdTdz+BQbLBMnj7tA=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3398.namprd15.prod.outlook.com (2603:10b6:a03:10e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 19:20:09 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 19:20:09 +0000
Subject: Re: [PATCH bpf-next v1 07/19] bpf: create anonymous bpf iterator
To:     Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <88bfc829-3c2d-96aa-7d32-4f3ff9b4ad08@fb.com>
Date:   Wed, 29 Apr 2020 12:20:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <20200429184623.ul7nxelzxeip2ign@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0089.namprd15.prod.outlook.com
 (2603:10b6:101:20::33) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:99f7) by CO1PR15CA0089.namprd15.prod.outlook.com (2603:10b6:101:20::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 29 Apr 2020 19:20:07 +0000
X-Originating-IP: [2620:10d:c090:400::5:99f7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28df0c02-2eed-4e7a-4959-08d7ec7254b6
X-MS-TrafficTypeDiagnostic: BYAPR15MB3398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3398BB3E11149564190829B4D3AD0@BYAPR15MB3398.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(346002)(396003)(39860400002)(376002)(2906002)(16526019)(66476007)(66556008)(53546011)(186003)(4326008)(66946007)(5660300002)(31686004)(110136005)(6512007)(316002)(8676002)(6486002)(8936002)(52116002)(6506007)(478600001)(31696002)(54906003)(2616005)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OGNitkINGhI0BhK60iYMtEsqOqcMMJiR04hcVywdarJ+JJr0Xi4pH72Dv8hP8EjdUJfijcBGFrvj+qKa5ikMZLcMLRSGfMapnsoNOcD/JZfaQyH12N8gOdLB45pvi+r7Tqp+VBq8Bp+iHAthUmkUhU2XM4WGEUuCdJ7/xxWloKfL23iCDb+NkgFBjIq2kBipG9ZbB0lOAY7Fkp1DX4JqQvzBklPYs2HPWcdhybAt1zDaIXTfpuBKJjFXJF5VK0pYdj1eDn8WuRkZN4n7A8i1ba9l4klVhAF52wFiBNYafLHv9iy5Bz8TJ1rj445+J3XulZhiwxK3/ZpyWxRh8fFn76ZQlvnYpairSWfaIsA6I33X85Tr+P/jLQu2VHKx8xd9DyoIixWZzN83Ggoi/vIxJCrNGE5ppLdLltjjPquEsa38R8WO7N7WOSHiDcUcIkYu
X-MS-Exchange-AntiSpam-MessageData: lMNAXDQvKZ988hRsrBPRMmCRe8oj2GNLckgaJxbRTLXPH2P9a6rT8ZUQ/+5UHMFjhoov8NsrAZ7LZPc5KWlRC87GNp2ebLQTl66PndpQsg88yNU+Q8mU0vlA2PnXc/1239sWUYE5zE/DPBifcP6Q6LwqYsyglqeCyL+QxSaKCLePR9FkTt3ke5ZFrtwAXZAU+TrLaAC5CeD1K4OG6JLPP46+U0mxh5lt7uu61qGJ4CbA7fsDWHYfFWISICA4xgbWMJQ5Y5UsDnM8HWMI7+hAwtp8q4deVyCMAFEymW8e6V6anvq/M0ZyX4qHtQfcmjgzU5gbaDn1pSqje5EYv9pDyvva2RH5HKAU67/wPegJNIUBZnw/ipgE1OsYLIhBSd6BjLc5egCjrULZF1FX2U2txbXQMcEY7nezd9i1ww/bIg/6WyCql3oELyyZfJRBmtpFLS0HRJJr66GsPO3ew337N665lWi3rRiFggfzWZZFfJxUYVOUH4J6gXIZItMBkN1kqzcPnD0vjn2E8BlAJsoI7cYvzeaO+vHjC1E7k1DGZzvhvJ2ZaRKRS/yuaXxu4GSbpGVjoRcGGMsZBnGxN8EkFZWLL1nDjl9lX9hrPcMFh57pgIqRz7e9blWItEJRQMjsfk8v/JLgYetNMGKmr7Hczz8c4j3//gjiTpFdpvTmDQ9+8rwgiiMeEosFka+eLgxI7C9ilzqgyZi1vvIi5OmlyRhSUKGcgj2a3lAaEdN2G1lNOgYZmgOcEPdiE5btuZhQzo383kX++hGAHqSxB+aElG1JQDgFGZyPX9c9ASMfca5ehxPwi0Mgrzc7LXLFyoK/Id0aqcpJdFFP1b34l/WhZw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 28df0c02-2eed-4e7a-4959-08d7ec7254b6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 19:20:08.8923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pk/IyTj0UfFzv/pD5BcLZGaYpxFBHDVReKsQ299GzhSADxFCqE4IKuhf0vmm4Api
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3398
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_09:2020-04-29,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/29/20 11:46 AM, Martin KaFai Lau wrote:
> On Wed, Apr 29, 2020 at 11:16:35AM -0700, Andrii Nakryiko wrote:
>> On Wed, Apr 29, 2020 at 12:07 AM Yonghong Song <yhs@fb.com> wrote:
>>>
>>>
>>>
>>> On 4/28/20 11:56 PM, Andrii Nakryiko wrote:
>>>> On Mon, Apr 27, 2020 at 1:19 PM Yonghong Song <yhs@fb.com> wrote:
>>>>>
>>>>> A new bpf command BPF_ITER_CREATE is added.
>>>>>
>>>>> The anonymous bpf iterator is seq_file based.
>>>>> The seq_file private data are referenced by targets.
>>>>> The bpf_iter infrastructure allocated additional space
>>>>> at seq_file->private after the space used by targets
>>>>> to store some meta data, e.g.,
>>>>>     prog:       prog to run
>>>>>     session_id: an unique id for each opened seq_file
>>>>>     seq_num:    how many times bpf programs are queried in this session
>>>>>     has_last:   indicate whether or not bpf_prog has been called after
>>>>>                 all valid objects have been processed
>>>>>
>>>>> A map between file and prog/link is established to help
>>>>> fops->release(). When fops->release() is called, just based on
>>>>> inode and file, bpf program cannot be located since target
>>>>> seq_priv_size not available. This map helps retrieve the prog
>>>>> whose reference count needs to be decremented.
>>>>>
>>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>> ---
>>>>>    include/linux/bpf.h            |   3 +
>>>>>    include/uapi/linux/bpf.h       |   6 ++
>>>>>    kernel/bpf/bpf_iter.c          | 162 ++++++++++++++++++++++++++++++++-
>>>>>    kernel/bpf/syscall.c           |  27 ++++++
>>>>>    tools/include/uapi/linux/bpf.h |   6 ++
>>>>>    5 files changed, 203 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>>>> index 4fc39d9b5cd0..0f0cafc65a04 100644
>>>>> --- a/include/linux/bpf.h
>>>>> +++ b/include/linux/bpf.h
>>>>> @@ -1112,6 +1112,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>>>>>    int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>>>>>    int bpf_obj_get_user(const char __user *pathname, int flags);
>>>>>
>>>>> +#define BPF_DUMP_SEQ_NET_PRIVATE       BIT(0)
>>>>> +
>>>>>    struct bpf_iter_reg {
>>>>>           const char *target;
>>>>>           const char *target_func_name;
>>>>> @@ -1133,6 +1135,7 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>>>>>    int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>>>>>    int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>>>>>                             struct bpf_prog *new_prog);
>>>>> +int bpf_iter_new_fd(struct bpf_link *link);
>>>>>
>>>>>    int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>>>>    int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>> index f39b9fec37ab..576651110d16 100644
>>>>> --- a/include/uapi/linux/bpf.h
>>>>> +++ b/include/uapi/linux/bpf.h
>>>>> @@ -113,6 +113,7 @@ enum bpf_cmd {
>>>>>           BPF_MAP_DELETE_BATCH,
>>>>>           BPF_LINK_CREATE,
>>>>>           BPF_LINK_UPDATE,
>>>>> +       BPF_ITER_CREATE,
>>>>>    };
>>>>>
>>>>>    enum bpf_map_type {
>>>>> @@ -590,6 +591,11 @@ union bpf_attr {
>>>>>                   __u32           old_prog_fd;
>>>>>           } link_update;
>>>>>
>>>>> +       struct { /* struct used by BPF_ITER_CREATE command */
>>>>> +               __u32           link_fd;
>>>>> +               __u32           flags;
>>>>> +       } iter_create;
>>>>> +
>>>>>    } __attribute__((aligned(8)));
>>>>>
>>>>>    /* The description below is an attempt at providing documentation to eBPF
>>>>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>>>>> index fc1ce5ee5c3f..1f4e778d1814 100644
>>>>> --- a/kernel/bpf/bpf_iter.c
>>>>> +++ b/kernel/bpf/bpf_iter.c
>>>>> @@ -2,6 +2,7 @@
>>>>>    /* Copyright (c) 2020 Facebook */
>>>>>
>>>>>    #include <linux/fs.h>
>>>>> +#include <linux/anon_inodes.h>
>>>>>    #include <linux/filter.h>
>>>>>    #include <linux/bpf.h>
>>>>>
>>>>> @@ -19,6 +20,19 @@ struct bpf_iter_link {
>>>>>           struct bpf_iter_target_info *tinfo;
>>>>>    };
>>>>>
>>>>> +struct extra_priv_data {
>>>>> +       struct bpf_prog *prog;
>>>>> +       u64 session_id;
>>>>> +       u64 seq_num;
>>>>> +       bool has_last;
>>>>> +};
>>>>> +
>>>>> +struct anon_file_prog_assoc {
>>>>> +       struct list_head list;
>>>>> +       struct file *file;
>>>>> +       struct bpf_prog *prog;
>>>>> +};
>>>>> +
>>>>>    static struct list_head targets;
>>>>>    static struct mutex targets_mutex;
>>>>>    static bool bpf_iter_inited = false;
>>>>> @@ -26,6 +40,50 @@ static bool bpf_iter_inited = false;
>>>>>    /* protect bpf_iter_link.link->prog upddate */
>>>>>    static struct mutex bpf_iter_mutex;
>>>>>
>>>>> +/* Since at anon seq_file release function, the prog cannot
>>>>> + * be retrieved since target seq_priv_size is not available.
>>>>> + * Keep a list of <anon_file, prog> mapping, so that
>>>>> + * at file release stage, the prog can be released properly.
>>>>> + */
>>>>> +static struct list_head anon_iter_info;
>>>>> +static struct mutex anon_iter_info_mutex;
>>>>> +
>>>>> +/* incremented on every opened seq_file */
>>>>> +static atomic64_t session_id;
>>>>> +
>>>>> +static u32 get_total_priv_dsize(u32 old_size)
>>>>> +{
>>>>> +       return roundup(old_size, 8) + sizeof(struct extra_priv_data);
>>>>> +}
>>>>> +
>>>>> +static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
>>>>> +{
>>>>> +       return old_ptr + roundup(old_size, 8);
>>>>> +}
>>>>> +
>>>>> +static int anon_iter_release(struct inode *inode, struct file *file)
>>>>> +{
>>>>> +       struct anon_file_prog_assoc *finfo;
>>>>> +
>>>>> +       mutex_lock(&anon_iter_info_mutex);
>>>>> +       list_for_each_entry(finfo, &anon_iter_info, list) {
>>>>> +               if (finfo->file == file) {
>>>>
>>>> I'll look at this and other patches more thoroughly tomorrow with
>>>> clear head, but this iteration to find anon_file_prog_assoc is really
>>>> unfortunate.
>>>>
>>>> I think the problem is that you are allowing seq_file infrastructure
>>>> to call directly into target implementation of seq_operations without
>>>> intercepting them. If you change that and put whatever extra info is
>>>> necessary into seq_file->private in front of target's private state,
>>>> then you shouldn't need this, right?
>>>
>>> Yes. This is true. The idea is to minimize the target change.
>>> But maybe this is not a good goal by itself.
>>>
>>> You are right, if I intercept all seq_ops(), I do not need the
>>> above change, I can tailor seq_file private_data right before
>>> calling target one and restore after the target call.
>>>
>>> Originally I only have one interception, show(), now I have
>>> stop() too to call bpf at the end of iteration. Maybe I can
>>> interpret all four, I think. This way, I can also get ride
>>> of target feature.
>>
>> If the main goal is to minimize target changes and make them exactly
>> seq_operations implementation, then one easier way to get easy access
>> to our own metadata in seq_file->private is to set it to point
>> **after** our metadata, but before target's metadata. Roughly in
>> pseudo code:
>>
>> struct bpf_iter_seq_file_meta {} __attribute((aligned(8)));
>>
>> void *meta = kmalloc(sizeof(struct bpf_iter_seq_file_meta) +
>> target_private_size);
>> seq_file->private = meta + sizeof(struct bpf_iter_seq_file_meta);
> I have suggested the same thing earlier.  Good to know that we think alike ;)
> 
> May be put them in a struct such that container_of...etc can be used:
> struct bpf_iter_private {
>          struct extra_priv_data iter_private;
> 	u8 target_private[] __aligned(8);
> };

This should work, but need to intercept all seq_ops() operations
because target expects private data is `target_private` only.
Let me experiment what is the best way to do this.

> 
>>
>>
>> Then to recover bpf_iter_Seq_file_meta:
>>
>> struct bpf_iter_seq_file_meta *meta = seq_file->private - sizeof(*meta);
>>
>> /* voila! */
>>
>> This doesn't have a benefit of making targets simpler, but will
>> require no changes to them at all. Plus less indirect calls, so less
>> performance penalty.
>>
