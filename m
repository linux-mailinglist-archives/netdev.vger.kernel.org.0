Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E61656E874
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbfGSQHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:07:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59867 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfGSQHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:07:54 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVQF-0001CW-AF; Fri, 19 Jul 2019 10:07:51 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVQD-0001X8-CP; Fri, 19 Jul 2019 10:07:51 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, nhorman@tuxdriver.com
References: <cover.1554732921.git.rgb@redhat.com>
        <cover.1554732921.git.rgb@redhat.com>
        <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
Date:   Fri, 19 Jul 2019 11:07:36 -0500
In-Reply-To: <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
        (Richard Guy Briggs's message of "Mon, 8 Apr 2019 23:39:09 -0400")
Message-ID: <87y30uc8jb.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hoVQD-0001X8-CP;;;mid=<87y30uc8jb.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+hbXFXPaobkrA2h+btAHY/3WXcCltEO3E=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Guy Briggs <rgb@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1530 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 3.1 (0.2%), b_tie_ro: 2.0 (0.1%), parse: 2.2
        (0.1%), extract_message_metadata: 33 (2.1%), get_uri_detail_list: 12
        (0.8%), tests_pri_-1000: 30 (1.9%), tests_pri_-950: 1.61 (0.1%),
        tests_pri_-900: 1.30 (0.1%), tests_pri_-90: 67 (4.4%), check_bayes: 65
        (4.3%), b_tokenize: 26 (1.7%), b_tok_get_all: 22 (1.4%), b_comp_prob:
        4.8 (0.3%), b_tok_touch_all: 9 (0.6%), b_finish: 1.11 (0.1%),
        tests_pri_0: 1371 (89.6%), check_dkim_signature: 0.75 (0.0%),
        check_dkim_adsp: 2.4 (0.2%), poll_dns_idle: 0.68 (0.0%), tests_pri_10:
        3.0 (0.2%), tests_pri_500: 12 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> Implement the proc fs write to set the audit container identifier of a
> process, emitting an AUDIT_CONTAINER_OP record to document the event.
>
> This is a write from the container orchestrator task to a proc entry of
> the form /proc/PID/audit_containerid where PID is the process ID of the
> newly created task that is to become the first task in a container, or
> an additional task added to a container.
>
> The write expects up to a u64 value (unset: 18446744073709551615).
>
> The writer must have capability CAP_AUDIT_CONTROL.
>
> This will produce a record such as this:
>   type=CONTAINER_OP msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 contid=123456 old-contid=18446744073709551615 pid=628 auid=root uid=root tty=ttyS0 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 comm=bash exe=/usr/bin/bash res=yes
>
> The "op" field indicates an initial set.  The "pid" to "ses" fields are
> the orchestrator while the "opid" field is the object's PID, the process
> being "contained".  New and old audit container identifier values are
> given in the "contid" fields, while res indicates its success.
>
> It is not permitted to unset the audit container identifier.
> A child inherits its parent's audit container identifier.

Why get proc involved in this?  I know it more or less fits as
this is about a process and it's descendants.  But this seems to
encouarge being able to read this value, and being able to read
this value seems to encourage misuse.

So I am not of fan of using proc for this.

> Please see the github audit kernel issue for the main feature:
>   https://github.com/linux-audit/audit-kernel/issues/90
> Please see the github audit userspace issue for supporting additions:
>   https://github.com/linux-audit/audit-userspace/issues/51
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Steve Grubb <sgrubb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  fs/proc/base.c             | 36 ++++++++++++++++++++++++
>  include/linux/audit.h      | 25 +++++++++++++++++
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 69 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/audit.h             |  1 +
>  kernel/auditsc.c           |  4 +++
>  6 files changed, 137 insertions(+)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index ddef482f1334..43fd0c4b87de 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1294,6 +1294,40 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
>  	.read		= proc_sessionid_read,
>  	.llseek		= generic_file_llseek,
>  };
> +
> +static ssize_t proc_contid_write(struct file *file, const char __user *buf,
> +				   size_t count, loff_t *ppos)
> +{
> +	struct inode *inode = file_inode(file);
> +	u64 contid;
> +	int rv;
> +	struct task_struct *task = get_proc_task(inode);
> +
> +	if (!task)
> +		return -ESRCH;
> +	if (*ppos != 0) {
> +		/* No partial writes. */
> +		put_task_struct(task);
> +		return -EINVAL;
> +	}
> +
> +	rv = kstrtou64_from_user(buf, count, 10, &contid);
> +	if (rv < 0) {
> +		put_task_struct(task);
> +		return rv;
> +	}
> +
> +	rv = audit_set_contid(task, contid);
> +	put_task_struct(task);
> +	if (rv < 0)
> +		return rv;
> +	return count;
> +}
> +
> +static const struct file_operations proc_contid_operations = {
> +	.write		= proc_contid_write,
> +	.llseek		= generic_file_llseek,
> +};
>  #endif
>  
>  #ifdef CONFIG_FAULT_INJECTION
> @@ -3033,6 +3067,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
>  #ifdef CONFIG_AUDIT
>  	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> +	REG("audit_containerid", S_IWUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3431,6 +3466,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
>  #ifdef CONFIG_AUDIT
>  	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> +	REG("audit_containerid", S_IWUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index bde346e73f0c..301337776193 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -89,6 +89,7 @@ struct audit_field {
>  struct audit_task_info {
>  	kuid_t			loginuid;
>  	unsigned int		sessionid;
> +	u64			contid;
>  #ifdef CONFIG_AUDITSYSCALL
>  	struct audit_context	*ctx;
>  #endif
> @@ -189,6 +190,15 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>  	return tsk->audit->sessionid;
>  }
>  
> +extern int audit_set_contid(struct task_struct *tsk, u64 contid);
> +
> +static inline u64 audit_get_contid(struct task_struct *tsk)
> +{
> +	if (!tsk->audit)
> +		return AUDIT_CID_UNSET;
> +	return tsk->audit->contid;
> +}
> +
>  extern u32 audit_enabled;
>  #else /* CONFIG_AUDIT */
>  static inline int audit_alloc(struct task_struct *task)
> @@ -250,6 +260,11 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
>  	return AUDIT_SID_UNSET;
>  }
>  
> +static inline u64 audit_get_contid(struct task_struct *tsk)
> +{
> +	return AUDIT_CID_UNSET;
> +}
> +
>  #define audit_enabled AUDIT_OFF
>  #endif /* CONFIG_AUDIT */
>  
> @@ -606,6 +621,16 @@ static inline bool audit_loginuid_set(struct task_struct *tsk)
>  	return uid_valid(audit_get_loginuid(tsk));
>  }
>  
> +static inline bool audit_contid_valid(u64 contid)
> +{
> +	return contid != AUDIT_CID_UNSET;
> +}
> +
> +static inline bool audit_contid_set(struct task_struct *tsk)
> +{
> +	return audit_contid_valid(audit_get_contid(tsk));
> +}
> +
>  static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
>  {
>  	audit_log_n_string(ab, buf, strlen(buf));
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 3901c51c0b93..4a6a8bf1de32 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -71,6 +71,7 @@
>  #define AUDIT_TTY_SET		1017	/* Set TTY auditing status */
>  #define AUDIT_SET_FEATURE	1018	/* Turn an audit feature on or off */
>  #define AUDIT_GET_FEATURE	1019	/* Get which features are enabled */
> +#define AUDIT_CONTAINER_OP	1020	/* Define the container id and info */
>  
>  #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
>  #define AUDIT_USER_AVC		1107	/* We filter this differently */
> @@ -485,6 +486,7 @@ struct audit_tty_status {
>  
>  #define AUDIT_UID_UNSET (unsigned int)-1
>  #define AUDIT_SID_UNSET ((unsigned int)-1)
> +#define AUDIT_CID_UNSET ((u64)-1)
>  
>  /* audit_rule_data supports filter rules with both integer and string
>   * fields.  It corresponds with AUDIT_ADD_RULE, AUDIT_DEL_RULE and
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 3fb09783cd4a..182b0f2c183d 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -244,6 +244,7 @@ int audit_alloc(struct task_struct *tsk)
>  	}
>  	info->loginuid = audit_get_loginuid(current);
>  	info->sessionid = audit_get_sessionid(current);
> +	info->contid = audit_get_contid(current);
>  	tsk->audit = info;
>  
>  	ret = audit_alloc_syscall(tsk);
> @@ -258,6 +259,7 @@ int audit_alloc(struct task_struct *tsk)
>  struct audit_task_info init_struct_audit = {
>  	.loginuid = INVALID_UID,
>  	.sessionid = AUDIT_SID_UNSET,
> +	.contid = AUDIT_CID_UNSET,
>  #ifdef CONFIG_AUDITSYSCALL
>  	.ctx = NULL,
>  #endif
> @@ -2341,6 +2343,73 @@ int audit_set_loginuid(kuid_t loginuid)
>  }
>  
>  /**
> + * audit_set_contid - set current task's audit contid
> + * @contid: contid value
> + *
> + * Returns 0 on success, -EPERM on permission failure.
> + *
> + * Called (set) from fs/proc/base.c::proc_contid_write().
> + */
> +int audit_set_contid(struct task_struct *task, u64 contid)
> +{
> +	u64 oldcontid;
> +	int rc = 0;
> +	struct audit_buffer *ab;
> +	uid_t uid;
> +	struct tty_struct *tty;
> +	char comm[sizeof(current->comm)];
> +
> +	task_lock(task);
> +	/* Can't set if audit disabled */
> +	if (!task->audit) {
> +		task_unlock(task);
> +		return -ENOPROTOOPT;
> +	}
> +	oldcontid = audit_get_contid(task);
> +	read_lock(&tasklist_lock);
> +	/* Don't allow the audit containerid to be unset */
> +	if (!audit_contid_valid(contid))
> +		rc = -EINVAL;
> +	/* if we don't have caps, reject */
> +	else if (!capable(CAP_AUDIT_CONTROL))
> +		rc = -EPERM;
> +	/* if task has children or is not single-threaded, deny */
> +	else if (!list_empty(&task->children))
> +		rc = -EBUSY;
> +	else if (!(thread_group_leader(task) && thread_group_empty(task)))
> +		rc = -EALREADY;
> +	read_unlock(&tasklist_lock);
> +	if (!rc)
> +		task->audit->contid = contid;
> +	task_unlock(task);
> +
> +	if (!audit_enabled)
> +		return rc;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_CONTAINER_OP);
> +	if (!ab)
> +		return rc;
> +
> +	uid = from_kuid(&init_user_ns, task_uid(current));
> +	tty = audit_get_tty();
> +	audit_log_format(ab,
> +			 "op=set opid=%d contid=%llu old-contid=%llu pid=%d uid=%u auid=%u tty=%s ses=%u",
> +			 task_tgid_nr(task), contid, oldcontid,
> +			 task_tgid_nr(current), uid,
> +			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +			 tty ? tty_name(tty) : "(none)",
> +			 audit_get_sessionid(current));
> +	audit_put_tty(tty);
> +	audit_log_task_context(ab);
> +	audit_log_format(ab, " comm=");
> +	audit_log_untrustedstring(ab, get_task_comm(comm, current));
> +	audit_log_d_path_exe(ab, current->mm);
> +	audit_log_format(ab, " res=%d", !rc);
> +	audit_log_end(ab);
> +	return rc;
> +}
> +
> +/**
>   * audit_log_end - end one audit record
>   * @ab: the audit_buffer
>   *
> diff --git a/kernel/audit.h b/kernel/audit.h
> index c00e2ee3c6b3..e2912924af0d 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -148,6 +148,7 @@ struct audit_context {
>  	kuid_t		    target_uid;
>  	unsigned int	    target_sessionid;
>  	u32		    target_sid;
> +	u64		    target_cid;
>  	char		    target_comm[TASK_COMM_LEN];
>  
>  	struct audit_tree_refs *trees, *first_trees;
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index fd7ca983de4f..1f7edf035b16 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -113,6 +113,7 @@ struct audit_aux_data_pids {
>  	kuid_t			target_uid[AUDIT_AUX_PIDS];
>  	unsigned int		target_sessionid[AUDIT_AUX_PIDS];
>  	u32			target_sid[AUDIT_AUX_PIDS];
> +	u64			target_cid[AUDIT_AUX_PIDS];
>  	char 			target_comm[AUDIT_AUX_PIDS][TASK_COMM_LEN];
>  	int			pid_count;
>  };
> @@ -2368,6 +2369,7 @@ void __audit_ptrace(struct task_struct *t)
>  	context->target_uid = task_uid(t);
>  	context->target_sessionid = audit_get_sessionid(t);
>  	security_task_getsecid(t, &context->target_sid);
> +	context->target_cid = audit_get_contid(t);
>  	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
>  }
>  
> @@ -2408,6 +2410,7 @@ int audit_signal_info(int sig, struct task_struct *t)
>  		ctx->target_uid = t_uid;
>  		ctx->target_sessionid = audit_get_sessionid(t);
>  		security_task_getsecid(t, &ctx->target_sid);
> +		ctx->target_cid = audit_get_contid(t);
>  		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
>  		return 0;
>  	}
> @@ -2429,6 +2432,7 @@ int audit_signal_info(int sig, struct task_struct *t)
>  	axp->target_uid[axp->pid_count] = t_uid;
>  	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
>  	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
> +	axp->target_cid[axp->pid_count] = audit_get_contid(t);
>  	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
>  	axp->pid_count++;
