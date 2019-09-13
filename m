Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1D8B2472
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 18:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbfIMQ7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 12:59:46 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:41174 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbfIMQ7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 12:59:45 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i8ov8-0006Qy-CD; Fri, 13 Sep 2019 10:59:42 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i8ov7-0000yk-10; Fri, 13 Sep 2019 10:59:42 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Yonghong Song <yhs@fb.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Antonio Neira Bustos <cneirabustos@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer\@redhat.com" <brouer@redhat.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
        <20190906150952.23066-3-cneirabustos@gmail.com>
        <20190906152435.GW1131@ZenIV.linux.org.uk>
        <20190906154647.GA19707@ZenIV.linux.org.uk>
        <20190906160020.GX1131@ZenIV.linux.org.uk>
        <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
        <20190907001056.GA1131@ZenIV.linux.org.uk>
        <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
        <20190909174522.GA17882@frodo.byteswizards.com>
        <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
        <20190910231506.GL1131@ZenIV.linux.org.uk>
        <87o8zr8cz3.fsf@x220.int.ebiederm.org>
        <7b0a325e-9187-702f-eba7-bfcc7e3f7eb4@fb.com>
Date:   Fri, 13 Sep 2019 11:59:23 -0500
In-Reply-To: <7b0a325e-9187-702f-eba7-bfcc7e3f7eb4@fb.com> (Yonghong Song's
        message of "Thu, 12 Sep 2019 05:49:00 +0000")
Message-ID: <87a7b8gmj8.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1i8ov7-0000yk-10;;;mid=<87a7b8gmj8.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/cD5NG1UJx++PyMjNdkjNsczn4qkEJJm0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMGappySubj_01,XMGappySubj_02,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.0 XMGappySubj_02 Gappier still
        *  0.5 XMGappySubj_01 Very gappy subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Yonghong Song <yhs@fb.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 950 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.5 (0.3%), b_tie_ro: 1.71 (0.2%), parse: 0.83
        (0.1%), extract_message_metadata: 14 (1.5%), get_uri_detail_list: 3.6
        (0.4%), tests_pri_-1000: 4.9 (0.5%), tests_pri_-950: 1.07 (0.1%),
        tests_pri_-900: 0.83 (0.1%), tests_pri_-90: 35 (3.7%), check_bayes: 34
        (3.6%), b_tokenize: 13 (1.3%), b_tok_get_all: 12 (1.2%), b_comp_prob:
        2.8 (0.3%), b_tok_touch_all: 4.5 (0.5%), b_finish: 0.57 (0.1%),
        tests_pri_0: 598 (63.0%), check_dkim_signature: 0.47 (0.0%),
        check_dkim_adsp: 2.4 (0.3%), poll_dns_idle: 277 (29.1%), tests_pri_10:
        1.70 (0.2%), tests_pri_500: 288 (30.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data from current task New bpf helper bpf_get_current_pidns_info.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song <yhs@fb.com> writes:

> On 9/11/19 9:16 AM, Eric W. Biederman wrote:
>> Al Viro <viro@zeniv.linux.org.uk> writes:
>> 
>>> On Tue, Sep 10, 2019 at 10:35:09PM +0000, Yonghong Song wrote:
>>>>
>>>> Carlos,
>>>>
>>>> Discussed with Eric today for what is the best way to get
>>>> the device number for a namespace. The following patch seems
>>>> a reasonable start although Eric would like to see
>>>> how the helper is used in order to decide whether the
>>>> interface looks right.
>>>>
>>>> commit bb00fc36d5d263047a8bceb3e51e969d7fbce7db (HEAD -> fs2)
>>>> Author: Yonghong Song <yhs@fb.com>
>>>> Date:   Mon Sep 9 21:50:51 2019 -0700
>>>>
>>>>       nsfs: add an interface function ns_get_inum_dev()
>>>>
>>>>       This patch added an interface function
>>>>       ns_get_inum_dev(). Given a ns_common structure,
>>>>       the function returns the inode and device
>>>>       numbers. The function will be used later
>>>>       by a newly added bpf helper.
>>>>
>>>>       Signed-off-by: Yonghong Song <yhs@fb.com>
>>>>
>>>> diff --git a/fs/nsfs.c b/fs/nsfs.c
>>>> index a0431642c6b5..a603c6fc3f54 100644
>>>> --- a/fs/nsfs.c
>>>> +++ b/fs/nsfs.c
>>>> @@ -245,6 +245,14 @@ struct file *proc_ns_fget(int fd)
>>>>           return ERR_PTR(-EINVAL);
>>>>    }
>>>>
>>>> +/* Get the device number for the current task pidns.
>>>> + */
>>>> +void ns_get_inum_dev(struct ns_common *ns, u32 *inum, dev_t *dev)
>>>> +{
>>>> +       *inum = ns->inum;
>>>> +       *dev = nsfs_mnt->mnt_sb->s_dev;
>>>> +}
>>>
>>> Umm...  Where would it get the device number once we get (hell knows
>>> what for) multiple nsfs instances?  I still don't understand what
>>> would that be about, TBH...  Is it really per-userns?  Or something
>>> else entirely?  Eric, could you give some context?
>> 
>> My goal is not to paint things into a corner, with future changes.
>> Right now it is possible to stat a namespace file descriptor and
>> get a device and inode number.  Then compare that.
>> 
>> I don't want people using the inode number in nsfd as some magic
>> namespace id.
>> 
>> We have had times in the past where there was more than one superblock
>> and thus more than one device number.  Further if userspace ever uses
>> this heavily there may be times in the future where for
>> checkpoint/restart purposes we will want multiple nsfd's so we can
>> preserve the inode number accross a migration.
>> 
>> Realistically there will probably just some kind of hotplug notification
>> to userspace to say we have hotplugged your operatining system as
>> a migration notification.
>> 
>> Now the halway discussion did not quite capture everything I was trying
>> to say but it at least got to the right ballpark.
>> 
>> The helper in fs/nsfs.c should be:
>> 
>> bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino)
>> {
>>          return ((ns->inum == ino) && (nsfs_mnt->mnt_sb->s_dev == dev));
>> }
>> 
>> That way if/when there are multiple inodes identifying the same
>> namespace the bpf programs don't need to change.
>
> Thanks, Eric. This is indeed better. The bpf helper should focus
> on comparing dev/ino, instead of return the dev/ino to bpf program.
>
> So overall, nsfs related change will look like:
>
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index a0431642c6b5..7e78d89c2172 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -245,6 +245,11 @@ struct file *proc_ns_fget(int fd)
>          return ERR_PTR(-EINVAL);
>   }
>
> +bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino)
> +{
> +       return ((ns->inum == ino) && (nsfs_mnt->mnt_sb->s_dev == dev));
> +}
> +
>   static int nsfs_show_path(struct seq_file *seq, struct dentry *dentry)
>   {
>          struct inode *inode = d_inode(dentry);
> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
> index d31cb6215905..79639807e960 100644
> --- a/include/linux/proc_ns.h
> +++ b/include/linux/proc_ns.h
> @@ -81,6 +81,7 @@ extern void *ns_get_path(struct path *path, struct 
> task_struct *task,
>   typedef struct ns_common *ns_get_path_helper_t(void *);
>   extern void *ns_get_path_cb(struct path *path, ns_get_path_helper_t 
> ns_get_cb,
>                              void *private_data);
> +extern bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino);
>
>   extern int ns_get_name(char *buf, size_t size, struct task_struct *task,
>                          const struct proc_ns_operations *ns_ops);
>
>> 
>> Up farther in the stack it should be something like:
>> 
>>> BPF_CALL_2(bpf_current_pidns_match, dev_t *dev, ino_t *ino)
>>> {
>>>          return ns_match(&task_active_pid_ns(current)->ns, *dev, *ino);
>>> }
>>>
>>> const struct bpf_func_proto bpf_current_pidns_match_proto = {
>>> 	.func		= bpf_current_pins_match,
>>> 	.gpl_only	= true,
>>> 	.ret_type	= RET_INTEGER
>>> 	.arg1_type	= ARG_PTR_TO_DEVICE_NUMBER,
>>> 	.arg2_type	= ARG_PTR_TO_INODE_NUMBER,
>>> };
>> 
>> That allows comparing what the bpf came up with with whatever value
>> userspace generated by stating the file descriptor.
>> 
>> 
>> That is the least bad suggestion I currently have for that
>> functionality.  It really would be better to not have that filter in the
>> bpf program itself but in the infrastructure that binds a program to a
>> set of tasks.
>> 
>> The problem with this approach is whatever device/inode you have when
>> the namespace they refer to exits there is the possibility that the
>> inode will be reused.  So your filter will eventually start matching on
>> the wrong thing.
>
> I come up with a differeent helper definition, which is much more
> similar to existing bpf_get_current_pid_tgid() and helper definition
> much more conforms to bpf convention.

There is a problem with your bpf_get_ns_current_pid_tgid below.
The inode number is a 64bit number.  To be nice to old userspace
we try and not use 64bit inode numbers where they are not required
but in this case we should not use an interface that assumes inode
numbers are 32bit.  They just aren't.

I didn't know how to express that in the bpf proto so I did what
I could.

The alternative to this would be to simply restrict this
helper to bpf programs registered in the initial pid namespace.
At which point you could just ensure all the numbers are in
the global pid namespace.

Hmm.  Looing at the comment below I am confused.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 5e28718928ca..bc26903c80c7 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -11,6 +11,8 @@
>   #include <linux/uidgid.h>
>   #include <linux/filter.h>
>   #include <linux/ctype.h>
> +#include <linux/pid_namespace.h>
> +#include <linux/proc_ns.h>
>
>   #include "../../lib/kstrtox.h"
>
> @@ -487,3 +489,33 @@ const struct bpf_func_proto bpf_strtoul_proto = {
>          .arg4_type      = ARG_PTR_TO_LONG,
>   };
>   #endif
> +
> +BPF_CALL_2(bpf_get_ns_current_pid_tgid, u32, dev, u32, inum)
> +{
> +       struct task_struct *task = current;
> +       struct pid_namespace *pidns;
> +       pid_t pid, tgid;
> +
> +       if (unlikely(!task))
> +               return -EINVAL;
> +
> +
> +       pidns = task_active_pid_ns(task);
> +       if (unlikely(!pidns))
> +               return -ENOENT;
> +
> +       if (!ns_match(&pidns->ns, (dev_t)dev, inum))
> +               return -EINVAL;
> +
> +       pid = task_pid_nr_ns(task, pidns);
> +       tgid = task_tgid_nr_ns(task, pidns);
> +
> +       return (u64) tgid << 32 | pid;
> +}
> +
> +const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
> +       .func           = bpf_get_ns_current_pid_tgid,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_ANYTHING,
> +       .arg2_type      = ARG_ANYTHING,
> +};
>
> Existing usage of bpf_get_current_pid_tgid() can be converted
> to bpf_get_ns_current_pid_tgid() if ns dev/inode number
> is supplied. For bpf_get_ns_current_pid_tgid(), checking
> return value ( < 0 or not) is needed.

Ok.  I missed something.

What is the problem bpf_get_ns_current_pid_tgid trying to solve
that bpf_get_current_pid_tgid does not solve.

I would think since much of tracing ebpf is fundamentally restricted
to the global root user.  Limiting the ebpf programs to the initial
pid namespace should not be a problem.

So I don't understand why you need to specify the namespace in
the ebpf call.

Can someone give me a clue what problem is being sovled by this
new call?

Eric
