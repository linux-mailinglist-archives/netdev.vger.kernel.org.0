Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B1F1A4C9B
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 01:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgDJXYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 19:24:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45096 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbgDJXYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 19:24:41 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03ANOOpq025134;
        Fri, 10 Apr 2020 16:24:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hFPE7LLwp3Lq4EPpBNMFDptJ5ZwnvWwr888nh+FhNVo=;
 b=MNUJzrUEQNJrefZOYckDJU3d5uyjewy6opou46oYX5+dOGD6rGs5RXk3PZwWvc+dulDg
 MKBdOXlmqpAMAQ0ZGCqK4Avw7AYAagqzvZQSBf0zG6d4cwUCCTGWqqrd9QLU2QvCeL00
 il3FEGej51tu7FJGrJ7DvE54c+GtzNIn7w4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3091n4a9gj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 16:24:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 16:24:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAG0HodgMYKVdV+QbmSQbvvti7eKc7su12uP/Roio+XqAuK+DpqB83pHSRLVwnV3YiNoqVlxCkfglDJEQsLdUp3sNZ1kdYUxg146IZH9VNt2iz4e4oGNcbivnpVviK64NHluaIbWYlhpYkhQ6JxRTQmyW5mAuGmgvOHKO/5JM9ndswGFGWpEG9HfzXkJ2v2acEfDNxQaxqoGiwEOvJePCwZ5fp4msSx7SGAuS4XyDx8j1RaAvj6slkpdMQFef6gmMxAOMyOfRcODNgvOm3Ef2Qk4olY34m4C/VDm+pN15mJoz5taEMqAE0ne6KZHJDnPhmFrh0tJX/Flny4C5eA1cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFPE7LLwp3Lq4EPpBNMFDptJ5ZwnvWwr888nh+FhNVo=;
 b=NsY5af7Q1ourtWQ5FiqaZTLWngaOfkuY2NktZ3PIAq0XzdCZJyVi0IAa2Qg6uVmoaQumtXYHwX3x5JdtBvCs/11RjxZHu33QnX4g6KE6imLaDBCQkn9vDzCIoLF37xwSFEhR5+wAiyNlhP4XmcWwuZHDv1i1YVK884e3qhV7L39zO+NaaRZLFyOgOjifIfduHmAMhYjurwUHgsxoH68/gH+hLqr0wDgbW1OlapY8GhkPEtrGNbmDuSWL1LQy0iCd8g5fBCxPKyGwPGs2gz+9Hgy+wml/nYPEFKb5MMO4pzvNQpuZvpS+8ppbSPEjVqXNDL9JKACJ+AL4WDWgRDoO6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFPE7LLwp3Lq4EPpBNMFDptJ5ZwnvWwr888nh+FhNVo=;
 b=HKlVUulhsWLag6O2RzEFPEYAAwyHmeDKNNye1/kIJtJ6VhpzEOKyPjPpWA5G7I2yuezueGUM3HULRNw6syy4L/ztbZzYui+kdtCgkvOoZu5Glz2qjy+QbihXw6T6tJYov7dE/ehil/vCtAebN4G0OxuiY9ioEcQgNfDQ4Y109bg=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3819.namprd15.prod.outlook.com (2603:10b6:303:43::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 23:24:15 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 23:24:15 +0000
Subject: Re: [RFC PATCH bpf-next 03/16] bpf: provide a way for targets to
 register themselves
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232523.2675550-1-yhs@fb.com>
 <CAEf4Bzb5K6h+Cca63JU35XG+NFoFDCVrC=DhDNVz6KTmoyzpFw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <904ce2a9-6318-9360-c1d5-16cb07c9ca5a@fb.com>
Date:   Fri, 10 Apr 2020 16:24:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bzb5K6h+Cca63JU35XG+NFoFDCVrC=DhDNVz6KTmoyzpFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0067.namprd17.prod.outlook.com
 (2603:10b6:300:93::29) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e0e4) by MWHPR17CA0067.namprd17.prod.outlook.com (2603:10b6:300:93::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.23 via Frontend Transport; Fri, 10 Apr 2020 23:24:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:e0e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9f6c754-5291-4968-0831-08d7dda648ea
X-MS-TrafficTypeDiagnostic: MW3PR15MB3819:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38199BC924CA0CB70E51E9B6D3DE0@MW3PR15MB3819.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(136003)(346002)(39860400002)(376002)(366004)(31696002)(66556008)(66476007)(66946007)(2616005)(86362001)(5660300002)(186003)(16526019)(54906003)(52116002)(316002)(36756003)(31686004)(2906002)(6916009)(81156014)(53546011)(478600001)(4326008)(8936002)(6486002)(8676002)(6512007)(6506007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CkGi8mgn97RrvMFDlsQvgjE8gXajPEf3c9Pb1Xl/ILBtXAqRZcOJOcIIDYtYhCYPVkW/d6Ulu14bypJ7Xq1tXIXZwEI26Bo17zGT/AyCGVgUReWVnB4hi2YXuBk6T4Ti5+yhIcGRGhFw1kjNMQ3WQWT6V9rsuJ0jUWrJudOiYN3pR2jtAP76+Uk3T9F9tl+dRw3RhWREV96nXux2dcrvZxQaH44Ds7DVwFSQOwQD/JCbmJMDhnZJIjY50HhQX9kM+lhBSU36CbFWuz7cy0k1cHuYZFY/PwWLopdPlmtoKhUJRY93xmsmok4G3j999NpW72T/fqnomri4B05HaKjV1f2sFn60W7EtPOCIj69/2dUM3vupH93VJHFGIob8UIllOlf6pY3/gUudQc2+vQyIGxDdFe9a9RTUbmk11luqwMUT/8RBL/hFUAKb3G8hFyhK
X-MS-Exchange-AntiSpam-MessageData: 6KGBXQxJuCekO2eC6zHZcbrtfE2o22cbHMdrWBkGZMnsQ0/fFFD51+PuXbeMqWqGjZFazm1uiL/RIGAz3gJQB7J41JHGSa68miotAMYgk+AfAy+7UvJUs0OnTsozjONZe8untc6pjB/OG7VAN2HTimWGxWYOspkrqbr3v89V3txt4qacCQCa4+ymHIwXJGEg
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f6c754-5291-4968-0831-08d7dda648ea
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 23:24:15.5553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tm2ayqlchRKT1lLGNUENhvNGkifRe76WqtfZbiSy0RyVLp2Q0wDELsLqablqkUQO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3819
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_10:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 suspectscore=2 adultscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/20 3:18 PM, Andrii Nakryiko wrote:
> On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Here, the target refers to a particular data structure
>> inside the kernel we want to dump. For example, it
>> can be all task_structs in the current pid namespace,
>> or it could be all open files for all task_structs
>> in the current pid namespace.
>>
>> Each target is identified with the following information:
>>     target_rel_path   <=== relative path to /sys/kernel/bpfdump
>>     target_proto      <=== kernel func proto which represents
>>                            bpf program signature for this target
>>     seq_ops           <=== seq_ops for seq_file operations
>>     seq_priv_size     <=== seq_file private data size
>>     target_feature    <=== target specific feature which needs
>>                            handling outside seq_ops.
> 
> It's not clear what "feature" stands for here... Is this just a sort
> of private_data passed through to dumper?

This is described later. It is some kind of target passed to the dumper.

> 
>>
>> The target relative path is a relative directory to /sys/kernel/bpfdump/.
>> For example, it could be:
>>     task                  <=== all tasks
>>     task/file             <=== all open files under all tasks
>>     ipv6_route            <=== all ipv6_routes
>>     tcp6/sk_local_storage <=== all tcp6 socket local storages
>>     foo/bar/tar           <=== all tar's in bar in foo
> 
> ^^ this seems useful, but I don't think code as is supports more than 2 levels?

Currently implement should support it.
You need
  - first register 'foo'. target name 'foo'.
  - then register 'foo/bar'. 'foo' will be the parent of 'bar'. target 
name 'foo/bar'.
  - then 'foo/bar/tar'. 'foo/bar' will be the parent of 'tar'. target 
name 'foo/bar/tar'.

> 
>>
>> The "target_feature" is mostly used for reusing existing seq_ops.
>> For example, for /proc/net/<> stats, the "net" namespace is often
>> stored in file private data. The target_feature enables bpf based
>> dumper to set "net" properly for itself before calling shared
>> seq_ops.
>>
>> bpf_dump_reg_target() is implemented so targets
>> can register themselves. Currently, module is not
>> supported, so there is no bpf_dump_unreg_target().
>> The main reason is that BTF is not available for modules
>> yet.
>>
>> Since target might call bpf_dump_reg_target() before
>> bpfdump mount point is created, __bpfdump_init()
>> may be called in bpf_dump_reg_target() as well.
>>
>> The file-based dumpers will be regular files under
>> the specific target directory. For example,
>>     task/my1      <=== dumper "my1" iterates through all tasks
>>     task/file/my2 <=== dumper "my2" iterates through all open files
>>                        under all tasks
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h |   4 +
>>   kernel/bpf/dump.c   | 190 +++++++++++++++++++++++++++++++++++++++++++-
>>   2 files changed, 193 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index fd2b2322412d..53914bec7590 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1109,6 +1109,10 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd);
>>   int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
>>   int bpf_obj_get_user(const char __user *pathname, int flags);
>>
>> +int bpf_dump_reg_target(const char *target, const char *target_proto,
>> +                       const struct seq_operations *seq_ops,
>> +                       u32 seq_priv_size, u32 target_feature);
>> +
>>   int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
>>   int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
>> diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
>> index e0c33486e0e7..45528846557f 100644
>> --- a/kernel/bpf/dump.c
>> +++ b/kernel/bpf/dump.c
>> @@ -12,6 +12,173 @@
>>   #include <linux/filter.h>
>>   #include <linux/bpf.h>
>>
>> +struct bpfdump_target_info {
>> +       struct list_head list;
>> +       const char *target;
>> +       const char *target_proto;
>> +       struct dentry *dir_dentry;
>> +       const struct seq_operations *seq_ops;
>> +       u32 seq_priv_size;
>> +       u32 target_feature;
>> +};
>> +
>> +struct bpfdump_targets {
>> +       struct list_head dumpers;
>> +       struct mutex dumper_mutex;
> 
> nit: would be a bit simpler if these were static variables with static
> initialization, similar to how bpfdump_dentry is separate?

yes, we could do that. not 100% sure whether it will be simpler or not.
the structure is to glue them together.

> 
>> +};
>> +
>> +/* registered dump targets */
>> +static struct bpfdump_targets dump_targets;
>> +
>> +static struct dentry *bpfdump_dentry;
>> +
>> +static struct dentry *bpfdump_add_dir(const char *name, struct dentry *parent,
>> +                                     const struct inode_operations *i_ops,
>> +                                     void *data);
>> +static int __bpfdump_init(void);
>> +
>> +static int dumper_unlink(struct inode *dir, struct dentry *dentry)
>> +{
>> +       kfree(d_inode(dentry)->i_private);
>> +       return simple_unlink(dir, dentry);
>> +}
>> +
>> +static const struct inode_operations bpf_dir_iops = {
>> +       .lookup         = simple_lookup,
>> +       .unlink         = dumper_unlink,
>> +};
>> +
>> +int bpf_dump_reg_target(const char *target,
>> +                       const char *target_proto,
>> +                       const struct seq_operations *seq_ops,
>> +                       u32 seq_priv_size, u32 target_feature)
>> +{
>> +       struct bpfdump_target_info *tinfo, *ptinfo;
>> +       struct dentry *dentry, *parent;
>> +       const char *lastslash;
>> +       bool existed = false;
>> +       int err, parent_len;
>> +
>> +       if (!bpfdump_dentry) {
>> +               err = __bpfdump_init();
> 
> This will be called (again) if bpfdump_init() fails? Not sure why? In
> rare cases, some dumper will fail to initialize, but then some might
> succeed, which is going to be even more confusing, no?

I can have a static variable to say bpfdump_init has been attempted to
avoid such situation to avoid any second try.

> 
>> +               if (err)
>> +                       return err;
>> +       }
>> +
>> +       tinfo = kmalloc(sizeof(*tinfo), GFP_KERNEL);
>> +       if (!tinfo)
>> +               return -ENOMEM;
>> +
>> +       tinfo->target = target;
>> +       tinfo->target_proto = target_proto;
>> +       tinfo->seq_ops = seq_ops;
>> +       tinfo->seq_priv_size = seq_priv_size;
>> +       tinfo->target_feature = target_feature;
>> +       INIT_LIST_HEAD(&tinfo->list);
>> +
>> +       lastslash = strrchr(target, '/');
>> +       if (!lastslash) {
>> +               parent = bpfdump_dentry;
> 
> Two nits here. First, it supports only one and two levels. But it
> seems like it wouldn't be hard to support multiple? Instead of
> reverse-searching for /, you can forward search and keep track of
> "current parent".
> 
> nit2:
> 
> parent = bpfdump_dentry;
> if (lastslash) {
> 
>      parent = ptinfo->dir_dentry;
> }
> 
> seems a bit cleaner (and generalizes to multi-level a bit better).
> 
>> +       } else {
>> +               parent_len = (unsigned long)lastslash - (unsigned long)target;
>> +
>> +               mutex_lock(&dump_targets.dumper_mutex);
>> +               list_for_each_entry(ptinfo, &dump_targets.dumpers, list) {
>> +                       if (strlen(ptinfo->target) == parent_len &&
>> +                           strncmp(ptinfo->target, target, parent_len) == 0) {
>> +                               existed = true;
>> +                               break;
>> +                       }
>> +               }
>> +               mutex_unlock(&dump_targets.dumper_mutex);
>> +               if (existed == false) {
>> +                       err = -ENOENT;
>> +                       goto free_tinfo;
>> +               }
>> +
>> +               parent = ptinfo->dir_dentry;
>> +               target = lastslash + 1;
>> +       }
>> +       dentry = bpfdump_add_dir(target, parent, &bpf_dir_iops, tinfo);
>> +       if (IS_ERR(dentry)) {
>> +               err = PTR_ERR(dentry);
>> +               goto free_tinfo;
>> +       }
>> +
>> +       tinfo->dir_dentry = dentry;
>> +
>> +       mutex_lock(&dump_targets.dumper_mutex);
>> +       list_add(&tinfo->list, &dump_targets.dumpers);
>> +       mutex_unlock(&dump_targets.dumper_mutex);
>> +       return 0;
>> +
>> +free_tinfo:
>> +       kfree(tinfo);
>> +       return err;
>> +}
>> +
> 
> [...]
> 
>> +       if (S_ISDIR(mode)) {
>> +               inode->i_op = i_ops;
>> +               inode->i_fop = f_ops;
>> +               inc_nlink(inode);
>> +               inc_nlink(dir);
>> +       } else {
>> +               inode->i_fop = f_ops;
>> +       }
>> +
>> +       d_instantiate(dentry, inode);
>> +       dget(dentry);
> 
> lookup_one_len already bumped refcount, why the second time here?

good question. this is what security/inode.c is doing and seems working.
do not really know the science behind this. will check more.

> 
>> +       inode_unlock(dir);
>> +       return dentry;
>> +
>> +dentry_put:
>> +       dput(dentry);
>> +       dentry = ERR_PTR(err);
>> +unlock:
>> +       inode_unlock(dir);
>> +       return dentry;
>> +}
>> +
> 
> [...]
> 
