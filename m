Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8826B6E865
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbfGSQDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:03:54 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53669 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfGSQDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:03:53 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVMN-000653-Rm; Fri, 19 Jul 2019 10:03:51 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVMM-0002r7-VQ; Fri, 19 Jul 2019 10:03:51 -0600
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
        <846df5e5bf5a49094fede082a2ace135ab6f5772.1554732921.git.rgb@redhat.com>
Date:   Fri, 19 Jul 2019 11:03:35 -0500
In-Reply-To: <846df5e5bf5a49094fede082a2ace135ab6f5772.1554732921.git.rgb@redhat.com>
        (Richard Guy Briggs's message of "Mon, 8 Apr 2019 23:39:10 -0400")
Message-ID: <87d0i6dnag.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hoVMM-0002r7-VQ;;;mid=<87d0i6dnag.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ZObZxtYj3Ingkk2j6NVLV9B+vGA99pls=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Guy Briggs <rgb@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 427 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 2.5 (0.6%), b_tie_ro: 1.74 (0.4%), parse: 0.67
        (0.2%), extract_message_metadata: 13 (3.0%), get_uri_detail_list: 1.86
        (0.4%), tests_pri_-1000: 18 (4.1%), tests_pri_-950: 1.09 (0.3%),
        tests_pri_-900: 1.08 (0.3%), tests_pri_-90: 24 (5.6%), check_bayes: 23
        (5.3%), b_tokenize: 8 (1.9%), b_tok_get_all: 8 (1.8%), b_comp_prob:
        1.56 (0.4%), b_tok_touch_all: 3.7 (0.9%), b_finish: 0.56 (0.1%),
        tests_pri_0: 358 (83.8%), check_dkim_signature: 0.60 (0.1%),
        check_dkim_adsp: 3.9 (0.9%), poll_dns_idle: 0.06 (0.0%), tests_pri_10:
        1.59 (0.4%), tests_pri_500: 4.9 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH ghak90 V6 03/10] audit: read container ID of a process
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> Add support for reading the audit container identifier from the proc
> filesystem.
>
> This is a read from the proc entry of the form
> /proc/PID/audit_containerid where PID is the process ID of the task
> whose audit container identifier is sought.
>
> The read expects up to a u64 value (unset: 18446744073709551615).
>
> This read requires CAP_AUDIT_CONTROL.

This scares me.    As this seems to make it easy to reuse an audit
containerid for non-audit purporses.

I would think it would be safer and easier to poke audit and ask it to
log a message with your audit container id.

Eric


> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  fs/proc/base.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 43fd0c4b87de..acc70239d0cb 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1211,7 +1211,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
>  };
>  
>  #ifdef CONFIG_AUDIT
> -#define TMPBUFLEN 11
> +#define TMPBUFLEN 21
>  static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
>  				  size_t count, loff_t *ppos)
>  {
> @@ -1295,6 +1295,24 @@ static ssize_t proc_sessionid_read(struct file * file, char __user * buf,
>  	.llseek		= generic_file_llseek,
>  };
>  
> +static ssize_t proc_contid_read(struct file *file, char __user *buf,
> +				  size_t count, loff_t *ppos)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct task_struct *task = get_proc_task(inode);
> +	ssize_t length;
> +	char tmpbuf[TMPBUFLEN];
> +
> +	if (!task)
> +		return -ESRCH;
> +	/* if we don't have caps, reject */
> +	if (!capable(CAP_AUDIT_CONTROL))
> +		return -EPERM;
> +	length = scnprintf(tmpbuf, TMPBUFLEN, "%llu", audit_get_contid(task));
> +	put_task_struct(task);
> +	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length);
> +}
> +
>  static ssize_t proc_contid_write(struct file *file, const char __user *buf,
>  				   size_t count, loff_t *ppos)
>  {
> @@ -1325,6 +1343,7 @@ static ssize_t proc_contid_write(struct file *file, const char __user *buf,
>  }
>  
>  static const struct file_operations proc_contid_operations = {
> +	.read		= proc_contid_read,
>  	.write		= proc_contid_write,
>  	.llseek		= generic_file_llseek,
>  };
> @@ -3067,7 +3086,7 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
>  #ifdef CONFIG_AUDIT
>  	REG("loginuid",   S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
> @@ -3466,7 +3485,7 @@ static int proc_tid_comm_permission(struct inode *inode, int mask)
>  #ifdef CONFIG_AUDIT
>  	REG("loginuid",  S_IWUSR|S_IRUGO, proc_loginuid_operations),
>  	REG("sessionid",  S_IRUGO, proc_sessionid_operations),
> -	REG("audit_containerid", S_IWUSR, proc_contid_operations),
> +	REG("audit_containerid", S_IWUSR|S_IRUSR, proc_contid_operations),
>  #endif
>  #ifdef CONFIG_FAULT_INJECTION
>  	REG("make-it-fail", S_IRUGO|S_IWUSR, proc_fault_inject_operations),
