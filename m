Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9189AF787
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfIKIQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:16:45 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57590 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfIKIQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:16:44 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i7xnu-0003mo-Lx; Wed, 11 Sep 2019 02:16:42 -0600
Received: from 110.8.30.213.rev.vodafone.pt ([213.30.8.110] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i7xnp-0000gG-GW; Wed, 11 Sep 2019 02:16:42 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Yonghong Song <yhs@fb.com>,
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
Date:   Wed, 11 Sep 2019 03:16:16 -0500
In-Reply-To: <20190910231506.GL1131@ZenIV.linux.org.uk> (Al Viro's message of
        "Wed, 11 Sep 2019 00:15:06 +0100")
Message-ID: <87o8zr8cz3.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1i7xnp-0000gG-GW;;;mid=<87o8zr8cz3.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=213.30.8.110;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+rB1/EbSiXLC2gKNzl0bODizDKGQpqjGE=
X-SA-Exim-Connect-IP: 213.30.8.110
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,TVD_RCVD_IP,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMGappySubj_01,XMGappySubj_02,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4963]
        *  0.7 XMSubLong Long Subject
        *  1.0 XMGappySubj_02 Gappier still
        *  0.5 XMGappySubj_01 Very gappy subject
        *  0.0 TVD_RCVD_IP Message was received from an IP address
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 4609 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.9 (0.1%), b_tie_ro: 2.1 (0.0%), parse: 1.10
        (0.0%), extract_message_metadata: 15 (0.3%), get_uri_detail_list: 3.3
        (0.1%), tests_pri_-1000: 9 (0.2%), tests_pri_-950: 0.99 (0.0%),
        tests_pri_-900: 0.82 (0.0%), tests_pri_-90: 33 (0.7%), check_bayes: 32
        (0.7%), b_tokenize: 7 (0.2%), b_tok_get_all: 13 (0.3%), b_comp_prob:
        2.5 (0.1%), b_tok_touch_all: 3.4 (0.1%), b_finish: 5 (0.1%),
        tests_pri_0: 4531 (98.3%), check_dkim_signature: 0.40 (0.0%),
        check_dkim_adsp: 4.6 (0.1%), poll_dns_idle: 0.25 (0.0%), tests_pri_10:
        2.9 (0.1%), tests_pri_500: 8 (0.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data from current task New bpf helper bpf_get_current_pidns_info.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Tue, Sep 10, 2019 at 10:35:09PM +0000, Yonghong Song wrote:
>> 
>> Carlos,
>> 
>> Discussed with Eric today for what is the best way to get
>> the device number for a namespace. The following patch seems
>> a reasonable start although Eric would like to see
>> how the helper is used in order to decide whether the
>> interface looks right.
>> 
>> commit bb00fc36d5d263047a8bceb3e51e969d7fbce7db (HEAD -> fs2)
>> Author: Yonghong Song <yhs@fb.com>
>> Date:   Mon Sep 9 21:50:51 2019 -0700
>> 
>>      nsfs: add an interface function ns_get_inum_dev()
>> 
>>      This patch added an interface function
>>      ns_get_inum_dev(). Given a ns_common structure,
>>      the function returns the inode and device
>>      numbers. The function will be used later
>>      by a newly added bpf helper.
>> 
>>      Signed-off-by: Yonghong Song <yhs@fb.com>
>> 
>> diff --git a/fs/nsfs.c b/fs/nsfs.c
>> index a0431642c6b5..a603c6fc3f54 100644
>> --- a/fs/nsfs.c
>> +++ b/fs/nsfs.c
>> @@ -245,6 +245,14 @@ struct file *proc_ns_fget(int fd)
>>          return ERR_PTR(-EINVAL);
>>   }
>> 
>> +/* Get the device number for the current task pidns.
>> + */
>> +void ns_get_inum_dev(struct ns_common *ns, u32 *inum, dev_t *dev)
>> +{
>> +       *inum = ns->inum;
>> +       *dev = nsfs_mnt->mnt_sb->s_dev;
>> +}
>
> Umm...  Where would it get the device number once we get (hell knows
> what for) multiple nsfs instances?  I still don't understand what
> would that be about, TBH...  Is it really per-userns?  Or something
> else entirely?  Eric, could you give some context?

My goal is not to paint things into a corner, with future changes.
Right now it is possible to stat a namespace file descriptor and
get a device and inode number.  Then compare that. 

I don't want people using the inode number in nsfd as some magic
namespace id.

We have had times in the past where there was more than one superblock
and thus more than one device number.  Further if userspace ever uses
this heavily there may be times in the future where for
checkpoint/restart purposes we will want multiple nsfd's so we can
preserve the inode number accross a migration.

Realistically there will probably just some kind of hotplug notification
to userspace to say we have hotplugged your operatining system as
a migration notification.

Now the halway discussion did not quite capture everything I was trying
to say but it at least got to the right ballpark.

The helper in fs/nsfs.c should be:

bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino)
{
        return ((ns->inum == ino) && (nsfs_mnt->mnt_sb->s_dev == dev));
}

That way if/when there are multiple inodes identifying the same
namespace the bpf programs don't need to change.

Up farther in the stack it should be something like:

> BPF_CALL_2(bpf_current_pidns_match, dev_t *dev, ino_t *ino)
> {
>         return ns_match(&task_active_pid_ns(current)->ns, *dev, *ino);
> }
> 
> const struct bpf_func_proto bpf_current_pidns_match_proto = {
> 	.func		= bpf_current_pins_match,
> 	.gpl_only	= true,
> 	.ret_type	= RET_INTEGER
> 	.arg1_type	= ARG_PTR_TO_DEVICE_NUMBER,
> 	.arg2_type	= ARG_PTR_TO_INODE_NUMBER,
> };

That allows comparing what the bpf came up with with whatever value
userspace generated by stating the file descriptor.


That is the least bad suggestion I currently have for that
functionality.  It really would be better to not have that filter in the
bpf program itself but in the infrastructure that binds a program to a
set of tasks.

The problem with this approach is whatever device/inode you have when
the namespace they refer to exits there is the possibility that the
inode will be reused.  So your filter will eventually start matching on
the wrong thing.

Eric
