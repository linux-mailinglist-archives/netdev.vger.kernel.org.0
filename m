Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A12A1BD56A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 09:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgD2HHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 03:07:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5656 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbgD2HHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 03:07:16 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T76sNX032664;
        Wed, 29 Apr 2020 00:07:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aeEXz8tUoCUNILL6bWRZsLZZjOzgXHdri78EzgGEBq8=;
 b=owXd+xtUOc6WHxXBDXEbNwfZT9sE7BS8PF6siUpZVGOtmJUqz9RwwS+mpSEL+MiTN79l
 0BLE+DhqIl1k31yLC63KVaWY0p3K3T2UdpRmIfrRtZ3NpizA9JPjus+fcyWTY+YgxnUn
 oWvVwfGNZIyYVWfXA+edf9LVsRvhbkZv1Vs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57qdcqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 29 Apr 2020 00:07:02 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 29 Apr 2020 00:07:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FscnTokGbnhYo2vt7PeNBcF7OrxiaF3RMJza9EkhY5GE4uqAz9rhUhSzmTmI/N9Ob/kmJws3sZh2rkjoYaHj0mBetskXHuCA9QSWQ56iowPMgJasRte8/W3PPKsA5d3tigFYan4IZRC0R+GNfwdMIhhn05BT7hWTcInD1SVq2RtVWjtTUAcUriYDHGVcP55z8Xg/rcWidJ9WHHom+1LtA1mN0cKfswPgDB13Xn+lYFPHW5BcIvWIfa9Fu7XEPUOAuQ/Hf8sSnzZD5ajZ9QGdWhmflJnxY+NaymetPNj45Sucn8zXdS9P6gi3k5jL1hOGhLhNfZcFsNahk0dnIWWOJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeEXz8tUoCUNILL6bWRZsLZZjOzgXHdri78EzgGEBq8=;
 b=eWukpiFRLFB34wlW0Gp+gItC4GfUN4OmZIHqVB2yGIuvIw1mpek3gRROcW47V9Zpc4LFtr7a+uDIZxgqlMNOJ7TYTJWe0/CH/3pWZkdrqpWeqcUdswVGJINU3383uImlpN0g0X0i8Dxt4Bk4QEFgubr9n22UHNpF32FaQoZsSp8plYQ7JI2EJMPVmQ/DlI/B0tFDILKdMxjgsdb9dwHROkKZ+7BQLsj1Yl78q/rZOf13pMnCWXNEgkdLigHJeCroCvJPnpMFvB54erYJC5nmmqVImWz6aFy+W2d6laCsiAl6EJqjR0RXm3X6w+y/sg70JGXBaSwXAgt/ezZXrqe6mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeEXz8tUoCUNILL6bWRZsLZZjOzgXHdri78EzgGEBq8=;
 b=YqiSgR7uHBVshOL9HwEQhGFuP3yROPoYBOFjfDZzV3Z8kXcbT1hcKGIxOkaAWsk7cKIv3qHJZFQfeVR6EyH3URvqTEqH3Fxde+ovcr7yeKn1iL/j9IqQIdh0hKjA1+YVlFfTMkIDqQVuBSgVsoTZbG1E9ZYrSrQFszw9yrk0UdY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4133.namprd15.prod.outlook.com (2603:10b6:a03:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 29 Apr
 2020 07:07:00 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 07:07:00 +0000
Subject: Re: [PATCH bpf-next v1 07/19] bpf: create anonymous bpf iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201242.2995160-1-yhs@fb.com>
 <CAEf4BzYtxOrzSW6Yy+0ABbm0Q71dkZTGDOcGCgHCVT=4ty5k1g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2b88797e-23b3-5df0-4d06-00b26912d14a@fb.com>
Date:   Wed, 29 Apr 2020 00:06:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzYtxOrzSW6Yy+0ABbm0Q71dkZTGDOcGCgHCVT=4ty5k1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR18CA0038.namprd18.prod.outlook.com
 (2603:10b6:320:31::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e9ab) by MWHPR18CA0038.namprd18.prod.outlook.com (2603:10b6:320:31::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Wed, 29 Apr 2020 07:06:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:e9ab]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffd1e252-9b47-4cef-8387-08d7ec0be93d
X-MS-TrafficTypeDiagnostic: BYAPR15MB4133:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB413330DD5F93D9AE25418BF5D3AD0@BYAPR15MB4133.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(136003)(396003)(39860400002)(31696002)(6512007)(6916009)(5660300002)(316002)(36756003)(2906002)(86362001)(186003)(31686004)(16526019)(6486002)(8936002)(2616005)(6506007)(52116002)(53546011)(4326008)(8676002)(54906003)(478600001)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fV/ZJUdJRNVnbA+bbo4Pp4rYWtkkhrkpdb92E3TxKFspH68pmVryw8hB0n5Yj6NkTyzHwTgXurVGXGQ4thXL62Kd1x6JXK7L6+bN3yQNSymWRAAGxKEfE/ttoAOZJjq/KlGpNrJABswBt6kEa48FFZRa0g+7dA1fqUyANcuSXVdc3CuGfc+Y7sm+0dGusicvrs9qTX0XAcOwX2JlcJPMwSOxl/Lw6jBNyXTlZwdKyKUc5h33qAuX6//Zuch3ANW3qFc4GQaGK5phllT22piVgEwP9uXjtasc72/1IiBBgwyu14LWlwNfNs5eilBTkucmuHss7ZT8R6mg3m93TJRfV+34V/m+iLnSCdq4BY0X2ydIikVRTeJXK6WNQvLCb2KeuFHJN1eYeqHi3lsU/SYLYFjlfoFTKugX7/OJlFBbeDgaSEZ46+sS+BsI6lDGlqH6
X-MS-Exchange-AntiSpam-MessageData: kpUWQKsPVh9bR5EDn14fkpxFaVsn8f3v6yMj3oJrmzc800QRLq3aMNXnJ6c52VRdKuEm+ZHyQ1TaNXpmqEek80RBqFplU3dqRwEwd3ue9GPOoVZ3lvQqqkroqciUmA4f7xXm+PSkh/KbK8EeXkW7GgsuigShNuwBHEfvW7btulYC8oEf41U4qEXNVGDTKIJnYNSmExlmcVaWQP7DR2Wk8xyn42d9wBmDvCXOensUQmDPZ9Ctf6A38XwGIKHLb2cFBCyArwaILDgOh+41KksNtwgXdjCP09NL0Lu9wNns4TzaUN0N7/vr/DcuuD12iD+Ixv6nR897eSAfzdDh+w42P+GHCKLWtqteX92H59Gn114lDMLiH1Fa6818w1ZuEAVVrKiRBzpWq5zjowiNo0sQ/lGOresZ+1a4sk9KbNNaHnGmpsJk8lW5GJ9BpGKi0mfJC5i+bWAIWCJ2IyFTqjnscAkGmW0VHlEGdBYqZGI9IHtJ7xiVBDTIMjnfjl7AZN26Y934AXUVHIrPVYt2gReiNcZpc9TckkSX/Sh8m9Fu8S6vmVrqE7DLBfsixet/5RLzuVzwQiSkiOxBu9LZBBdYofVE6KrPdo5tLR8hpVyzqZnsOuY0Z/gU4JhlCzpiiZ3dyVNYOTuw11s/RqeX2CcjDDSCYSdFVK7ZNoVMeDve4mP4bINiBpSBitycMpJWGGdN2X68takmUOJl7g/k8W8eqTjYGT3ZExkEhgnq8qOjZjJbL9tfKW+tQKFaG3RuoXAUECj9lmaCMYr64LCAXmev6uh8MdHK/4WKetoTrBD4vqOUpSi14lXto04pd5F3gShSJnn4vZVjwiPvDd4q+6Gepw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd1e252-9b47-4cef-8387-08d7ec0be93d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 07:07:00.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RX0jp66RxrUl8BZ4AuCGe5qUEOPEuOp1v1tlY+2CWB1/IjWfge00nZHpvsnTTOe5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4133
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-29_02:2020-04-28,2020-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290058
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/20 11:56 PM, Andrii Nakryiko wrote:
> On Mon, Apr 27, 2020 at 1:19 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> A new bpf command BPF_ITER_CREATE is added.
>>
>> The anonymous bpf iterator is seq_file based.
>> The seq_file private data are referenced by targets.
>> The bpf_iter infrastructure allocated additional space
>> at seq_file->private after the space used by targets
>> to store some meta data, e.g.,
>>    prog:       prog to run
>>    session_id: an unique id for each opened seq_file
>>    seq_num:    how many times bpf programs are queried in this session
>>    has_last:   indicate whether or not bpf_prog has been called after
>>                all valid objects have been processed
>>
>> A map between file and prog/link is established to help
>> fops->release(). When fops->release() is called, just based on
>> inode and file, bpf program cannot be located since target
>> seq_priv_size not available. This map helps retrieve the prog
>> whose reference count needs to be decremented.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |   3 +
>>   include/uapi/linux/bpf.h       |   6 ++
>>   kernel/bpf/bpf_iter.c          | 162 ++++++++++++++++++++++++++++++++-
>>   kernel/bpf/syscall.c           |  27 ++++++
>>   tools/include/uapi/linux/bpf.h |   6 ++
>>   5 files changed, 203 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 4fc39d9b5cd0..0f0cafc65a04 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1112,6 +1112,8 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>>   int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>>   int bpf_obj_get_user(const char __user *pathname, int flags);
>>
>> +#define BPF_DUMP_SEQ_NET_PRIVATE       BIT(0)
>> +
>>   struct bpf_iter_reg {
>>          const char *target;
>>          const char *target_func_name;
>> @@ -1133,6 +1135,7 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *ctx);
>>   int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>>   int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
>>                            struct bpf_prog *new_prog);
>> +int bpf_iter_new_fd(struct bpf_link *link);
>>
>>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index f39b9fec37ab..576651110d16 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -113,6 +113,7 @@ enum bpf_cmd {
>>          BPF_MAP_DELETE_BATCH,
>>          BPF_LINK_CREATE,
>>          BPF_LINK_UPDATE,
>> +       BPF_ITER_CREATE,
>>   };
>>
>>   enum bpf_map_type {
>> @@ -590,6 +591,11 @@ union bpf_attr {
>>                  __u32           old_prog_fd;
>>          } link_update;
>>
>> +       struct { /* struct used by BPF_ITER_CREATE command */
>> +               __u32           link_fd;
>> +               __u32           flags;
>> +       } iter_create;
>> +
>>   } __attribute__((aligned(8)));
>>
>>   /* The description below is an attempt at providing documentation to eBPF
>> diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
>> index fc1ce5ee5c3f..1f4e778d1814 100644
>> --- a/kernel/bpf/bpf_iter.c
>> +++ b/kernel/bpf/bpf_iter.c
>> @@ -2,6 +2,7 @@
>>   /* Copyright (c) 2020 Facebook */
>>
>>   #include <linux/fs.h>
>> +#include <linux/anon_inodes.h>
>>   #include <linux/filter.h>
>>   #include <linux/bpf.h>
>>
>> @@ -19,6 +20,19 @@ struct bpf_iter_link {
>>          struct bpf_iter_target_info *tinfo;
>>   };
>>
>> +struct extra_priv_data {
>> +       struct bpf_prog *prog;
>> +       u64 session_id;
>> +       u64 seq_num;
>> +       bool has_last;
>> +};
>> +
>> +struct anon_file_prog_assoc {
>> +       struct list_head list;
>> +       struct file *file;
>> +       struct bpf_prog *prog;
>> +};
>> +
>>   static struct list_head targets;
>>   static struct mutex targets_mutex;
>>   static bool bpf_iter_inited = false;
>> @@ -26,6 +40,50 @@ static bool bpf_iter_inited = false;
>>   /* protect bpf_iter_link.link->prog upddate */
>>   static struct mutex bpf_iter_mutex;
>>
>> +/* Since at anon seq_file release function, the prog cannot
>> + * be retrieved since target seq_priv_size is not available.
>> + * Keep a list of <anon_file, prog> mapping, so that
>> + * at file release stage, the prog can be released properly.
>> + */
>> +static struct list_head anon_iter_info;
>> +static struct mutex anon_iter_info_mutex;
>> +
>> +/* incremented on every opened seq_file */
>> +static atomic64_t session_id;
>> +
>> +static u32 get_total_priv_dsize(u32 old_size)
>> +{
>> +       return roundup(old_size, 8) + sizeof(struct extra_priv_data);
>> +}
>> +
>> +static void *get_extra_priv_dptr(void *old_ptr, u32 old_size)
>> +{
>> +       return old_ptr + roundup(old_size, 8);
>> +}
>> +
>> +static int anon_iter_release(struct inode *inode, struct file *file)
>> +{
>> +       struct anon_file_prog_assoc *finfo;
>> +
>> +       mutex_lock(&anon_iter_info_mutex);
>> +       list_for_each_entry(finfo, &anon_iter_info, list) {
>> +               if (finfo->file == file) {
> 
> I'll look at this and other patches more thoroughly tomorrow with
> clear head, but this iteration to find anon_file_prog_assoc is really
> unfortunate.
> 
> I think the problem is that you are allowing seq_file infrastructure
> to call directly into target implementation of seq_operations without
> intercepting them. If you change that and put whatever extra info is
> necessary into seq_file->private in front of target's private state,
> then you shouldn't need this, right?

Yes. This is true. The idea is to minimize the target change.
But maybe this is not a good goal by itself.

You are right, if I intercept all seq_ops(), I do not need the
above change, I can tailor seq_file private_data right before
calling target one and restore after the target call.

Originally I only have one interception, show(), now I have
stop() too to call bpf at the end of iteration. Maybe I can
interpret all four, I think. This way, I can also get ride
of target feature.

> 
> This would also make each target's logic a bit simpler because you can:
> - centralize creation and initialization of bpf_iter_meta (session_id,
> seq, seq_num will be set up once in this generic code);
> - loff_t pos increments;
> - you can extract and centralize bpf_iter_get_prog() call in show()
> implementation as well.
> 
> I think with that each target's logic will be simpler and you won't
> need to maintain anon_file_prog_assocs.
> 
> Are there complications I'm missing?
> 
> [...]
> 
