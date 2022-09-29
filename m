Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EE85F00F5
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 00:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiI2Wsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 18:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiI2Wsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 18:48:40 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0C070E7B;
        Thu, 29 Sep 2022 15:48:39 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:51916)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oe2Ka-00Bgyk-5s; Thu, 29 Sep 2022 16:48:36 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:44804 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oe2KY-00DOgy-Vi; Thu, 29 Sep 2022 16:48:35 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
        <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
        <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV>
        <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
        <YzXzXNAgcJeJ3M0d@ZenIV> <YzYK7k3tgZy3Pwht@ZenIV>
        <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
        <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
Date:   Thu, 29 Sep 2022 17:48:29 -0500
In-Reply-To: <871qrt4ymg.fsf@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Thu, 29 Sep 2022 17:14:15 -0500")
Message-ID: <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oe2KY-00DOgy-Vi;;;mid=<87ill53igy.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18Ez9f5/cGbkHt0RMLYwH4f1+0QAerqkto=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 662 ms - load_scoreonly_sql: 0.11 (0.0%),
        signal_user_changed: 14 (2.1%), b_tie_ro: 12 (1.8%), parse: 2.2 (0.3%),
         extract_message_metadata: 22 (3.3%), get_uri_detail_list: 5 (0.8%),
        tests_pri_-1000: 20 (3.0%), tests_pri_-950: 1.74 (0.3%),
        tests_pri_-900: 1.35 (0.2%), tests_pri_-90: 107 (16.1%), check_bayes:
        104 (15.7%), b_tokenize: 16 (2.5%), b_tok_get_all: 11 (1.7%),
        b_comp_prob: 3.1 (0.5%), b_tok_touch_all: 70 (10.5%), b_finish: 1.13
        (0.2%), tests_pri_0: 470 (71.0%), check_dkim_signature: 1.10 (0.2%),
        check_dkim_adsp: 3.8 (0.6%), poll_dns_idle: 1.25 (0.2%), tests_pri_10:
        4.5 (0.7%), tests_pri_500: 14 (2.2%), rewrite_mail: 0.00 (0.0%)
Subject: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Since common apparmor policies don't allow access /proc/tgid/task/tid/net
point the code at /proc/tid/net instead.

Link: https://lkml.kernel.org/r/dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

I have only compile tested this.  All of the boiler plate is a copy of
/proc/self and /proc/thread-self, so it should work.

Can David or someone who cares and has access to the limited apparmor
configurations could test this to make certain this works?

 fs/proc/base.c          | 12 ++++++--
 fs/proc/internal.h      |  2 ++
 fs/proc/proc_net.c      | 68 ++++++++++++++++++++++++++++++++++++++++-
 fs/proc/root.c          |  7 ++++-
 include/linux/proc_fs.h |  1 +
 5 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 93f7e3d971e4..c205234f3822 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3479,7 +3479,7 @@ static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter ite
 	return iter;
 }
 
-#define TGID_OFFSET (FIRST_PROCESS_ENTRY + 2)
+#define TGID_OFFSET (FIRST_PROCESS_ENTRY + 3)
 
 /* for the /proc/ directory itself, after non-process stuff has been done */
 int proc_pid_readdir(struct file *file, struct dir_context *ctx)
@@ -3492,18 +3492,24 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 	if (pos >= PID_MAX_LIMIT + TGID_OFFSET)
 		return 0;
 
-	if (pos == TGID_OFFSET - 2) {
+	if (pos == TGID_OFFSET - 3) {
 		struct inode *inode = d_inode(fs_info->proc_self);
 		if (!dir_emit(ctx, "self", 4, inode->i_ino, DT_LNK))
 			return 0;
 		ctx->pos = pos = pos + 1;
 	}
-	if (pos == TGID_OFFSET - 1) {
+	if (pos == TGID_OFFSET - 2) {
 		struct inode *inode = d_inode(fs_info->proc_thread_self);
 		if (!dir_emit(ctx, "thread-self", 11, inode->i_ino, DT_LNK))
 			return 0;
 		ctx->pos = pos = pos + 1;
 	}
+	if (pos == TGID_OFFSET - 1) {
+		struct inode *inode = d_inode(fs_info->proc_net);
+		if (!dir_emit(ctx, "net", 11, inode->i_ino, DT_LNK))
+			return 0;
+		ctx->pos = pos = pos + 1;
+	}
 	iter.tgid = pos - TGID_OFFSET;
 	iter.task = NULL;
 	for (iter = next_tgid(ns, iter);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 06a80f78433d..9d13c24b80c8 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -232,8 +232,10 @@ extern const struct inode_operations proc_net_inode_operations;
 
 #ifdef CONFIG_NET
 extern int proc_net_init(void);
+extern int proc_setup_net_symlink(struct super_block *s);
 #else
 static inline int proc_net_init(void) { return 0; }
+static inline int proc_setup_net_symlink(struct super_block *s) { return 0; }
 #endif
 
 /*
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 856839b8ae8b..99335e800c1c 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -408,9 +408,75 @@ static struct pernet_operations __net_initdata proc_net_ns_ops = {
 	.exit = proc_net_ns_exit,
 };
 
+/*
+ * /proc/net:
+ */
+static const char *proc_net_symlink_get_link(struct dentry *dentry,
+					     struct inode *inode,
+					     struct delayed_call *done)
+{
+	struct pid_namespace *ns = proc_pid_ns(inode->i_sb);
+	pid_t tid = task_pid_nr_ns(current, ns);
+	char *name;
+
+	if (!tid)
+		return ERR_PTR(-ENOENT);
+	name = kmalloc(10 + 4 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);
+	if (unlikely(!name))
+		return dentry ? ERR_PTR(-ENOMEM) : ERR_PTR(-ECHILD);
+	sprintf(name, "%u/net", tid);
+	set_delayed_call(done, kfree_link, name);
+	return name;
+}
+
+static const struct inode_operations proc_net_symlink_inode_operations = {
+	.get_link	= proc_net_symlink_get_link,
+};
+
+static unsigned net_symlink_inum __ro_after_init;
+
+int proc_setup_net_symlink(struct super_block *s)
+{
+	struct inode *root_inode = d_inode(s->s_root);
+	struct proc_fs_info *fs_info = proc_sb_info(s);
+	struct dentry *net_symlink;
+	int ret = -ENOMEM;
+
+	inode_lock(root_inode);
+	net_symlink = d_alloc_name(s->s_root, "net");
+	if (net_symlink) {
+		struct inode *inode = new_inode(s);
+		if (inode) {
+			inode->i_ino = net_symlink_inum;
+			inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
+			inode->i_mode = S_IFLNK | S_IRWXUGO;
+			inode->i_uid = GLOBAL_ROOT_UID;
+			inode->i_gid = GLOBAL_ROOT_GID;
+			inode->i_op = &proc_net_symlink_inode_operations;
+			d_add(net_symlink, inode);
+			ret = 0;
+		} else {
+			dput(net_symlink);
+		}
+	}
+	inode_unlock(root_inode);
+
+	if (ret)
+		pr_err("proc_fill_super: can't allocate /proc/net\n");
+	else
+		fs_info->proc_net = net_symlink;
+
+	return ret;
+}
+
+void __init proc_net_symlink_init(void)
+{
+	proc_alloc_inum(&net_symlink_inum);
+}
+
 int __init proc_net_init(void)
 {
-	proc_symlink("net", NULL, "self/net");
+	proc_net_symlink_init();
 
 	return register_pernet_subsys(&proc_net_ns_ops);
 }
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 3c2ee3eb1138..6e57e9a4acf9 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -207,7 +207,11 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 	if (ret) {
 		return ret;
 	}
-	return proc_setup_thread_self(s);
+	ret = proc_setup_thread_self(s);
+	if (ret) {
+		return ret;
+	}
+	return proc_setup_net_symlink(s);
 }
 
 static int proc_reconfigure(struct fs_context *fc)
@@ -268,6 +272,7 @@ static void proc_kill_sb(struct super_block *sb)
 
 	dput(fs_info->proc_self);
 	dput(fs_info->proc_thread_self);
+	dput(fs_info->proc_net);
 
 	kill_anon_super(sb);
 	put_pid_ns(fs_info->pid_ns);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 81d6e4ec2294..65f4ef15c8bf 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -62,6 +62,7 @@ struct proc_fs_info {
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self;        /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self */
+	struct dentry *proc_net;	 /* For /proc/net */
 	kgid_t pid_gid;
 	enum proc_hidepid hide_pid;
 	enum proc_pidonly pidonly;
-- 
2.35.3

