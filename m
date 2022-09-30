Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A125F0796
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 11:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiI3JbG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Sep 2022 05:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiI3JbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 05:31:04 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED61EC1101
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 02:31:01 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-44-avJ3a8oNN9K4AaK0uayjow-1; Fri, 30 Sep 2022 10:30:53 +0100
X-MC-Unique: avJ3a8oNN9K4AaK0uayjow-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 30 Sep
 2022 10:30:41 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Fri, 30 Sep 2022 10:30:41 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Eric W. Biederman'" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: RE: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Thread-Topic: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Thread-Index: AQHY1FWf381Lc0KOOEGaF1/0a4qSLq33sN8w
Date:   Fri, 30 Sep 2022 09:30:41 +0000
Message-ID: <ea14288676b045c29960651a649d66b9@AcuMS.aculab.com>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
        <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
        <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV>
        <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
        <YzXzXNAgcJeJ3M0d@ZenIV> <YzYK7k3tgZy3Pwht@ZenIV>
        <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
        <871qrt4ymg.fsf@email.froward.int.ebiederm.org>
 <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
In-Reply-To: <87ill53igy.fsf_-_@email.froward.int.ebiederm.org>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric W. Biederman
> Sent: 29 September 2022 23:48
> 
> Since common apparmor policies don't allow access /proc/tgid/task/tid/net
> point the code at /proc/tid/net instead.
> 
> Link: https://lkml.kernel.org/r/dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
> 
> I have only compile tested this.  All of the boiler plate is a copy of
> /proc/self and /proc/thread-self, so it should work.
> 
> Can David or someone who cares and has access to the limited apparmor
> configurations could test this to make certain this works?

It works with a minor 'cut & paste' fixup.
(Not nested inside a program that changes namespaces.)

Although if it is reasonable for /proc/net -> /proc/tid/net
why not just make /proc/thread-self -> /proc/tid
Then /proc/net can just be thread-self/net

I have wondered if the namespace lookup could be done as a 'special'
directory lookup for "net" rather that changing everything when the
namespace is changed.
I can imagine scenarios where a thread needs to keep changing
between two namespaces, at the moment I suspect that is rather
more expensive than a lookup and changing the reference counts.

Notwithstanding the apparmor issues, /proc/net could actuall be
a symlink to (say) /proc/net_namespaces/namespace_name with
readlink returning the name based on the threads actual namespace.

I've also had problems with accessing /sys/class/net for multiple
namespaces within the same thread (think of a system monitor process).
The simplest solution is to start the program with:
	ip netne exec namespace program 3</sys/class/net
and the use openat(3, ...) to read items in the 'init' namespace.

FWIW I'm pretty sure there a sequence involving unshare() that
can get you out of a chroot - but I've not found it yet.

	David

> 
>  fs/proc/base.c          | 12 ++++++--
>  fs/proc/internal.h      |  2 ++
>  fs/proc/proc_net.c      | 68 ++++++++++++++++++++++++++++++++++++++++-
>  fs/proc/root.c          |  7 ++++-
>  include/linux/proc_fs.h |  1 +
>  5 files changed, 85 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 93f7e3d971e4..c205234f3822 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3479,7 +3479,7 @@ static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter ite
>  	return iter;
>  }
> 
> -#define TGID_OFFSET (FIRST_PROCESS_ENTRY + 2)
> +#define TGID_OFFSET (FIRST_PROCESS_ENTRY + 3)
> 
>  /* for the /proc/ directory itself, after non-process stuff has been done */
>  int proc_pid_readdir(struct file *file, struct dir_context *ctx)
> @@ -3492,18 +3492,24 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
>  	if (pos >= PID_MAX_LIMIT + TGID_OFFSET)
>  		return 0;
> 
> -	if (pos == TGID_OFFSET - 2) {
> +	if (pos == TGID_OFFSET - 3) {
>  		struct inode *inode = d_inode(fs_info->proc_self);
>  		if (!dir_emit(ctx, "self", 4, inode->i_ino, DT_LNK))
>  			return 0;
>  		ctx->pos = pos = pos + 1;
>  	}
> -	if (pos == TGID_OFFSET - 1) {
> +	if (pos == TGID_OFFSET - 2) {
>  		struct inode *inode = d_inode(fs_info->proc_thread_self);
>  		if (!dir_emit(ctx, "thread-self", 11, inode->i_ino, DT_LNK))
>  			return 0;
>  		ctx->pos = pos = pos + 1;
>  	}
> +	if (pos == TGID_OFFSET - 1) {
> +		struct inode *inode = d_inode(fs_info->proc_net);
> +		if (!dir_emit(ctx, "net", 11, inode->i_ino, DT_LNK))

The 11 is the length so needs to be 4.
This block can also be put first - to reduce churn.

	David

> +			return 0;
> +		ctx->pos = pos = pos + 1;
> +	}
>  	iter.tgid = pos - TGID_OFFSET;
>  	iter.task = NULL;
>  	for (iter = next_tgid(ns, iter);
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 06a80f78433d..9d13c24b80c8 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -232,8 +232,10 @@ extern const struct inode_operations proc_net_inode_operations;
> 
>  #ifdef CONFIG_NET
>  extern int proc_net_init(void);
> +extern int proc_setup_net_symlink(struct super_block *s);
>  #else
>  static inline int proc_net_init(void) { return 0; }
> +static inline int proc_setup_net_symlink(struct super_block *s) { return 0; }
>  #endif
> 
>  /*
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index 856839b8ae8b..99335e800c1c 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -408,9 +408,75 @@ static struct pernet_operations __net_initdata proc_net_ns_ops = {
>  	.exit = proc_net_ns_exit,
>  };
> 
> +/*
> + * /proc/net:
> + */
> +static const char *proc_net_symlink_get_link(struct dentry *dentry,
> +					     struct inode *inode,
> +					     struct delayed_call *done)
> +{
> +	struct pid_namespace *ns = proc_pid_ns(inode->i_sb);
> +	pid_t tid = task_pid_nr_ns(current, ns);
> +	char *name;
> +
> +	if (!tid)
> +		return ERR_PTR(-ENOENT);
> +	name = kmalloc(10 + 4 + 1, dentry ? GFP_KERNEL : GFP_ATOMIC);
> +	if (unlikely(!name))
> +		return dentry ? ERR_PTR(-ENOMEM) : ERR_PTR(-ECHILD);
> +	sprintf(name, "%u/net", tid);
> +	set_delayed_call(done, kfree_link, name);
> +	return name;
> +}
> +
> +static const struct inode_operations proc_net_symlink_inode_operations = {
> +	.get_link	= proc_net_symlink_get_link,
> +};
> +
> +static unsigned net_symlink_inum __ro_after_init;
> +
> +int proc_setup_net_symlink(struct super_block *s)
> +{
> +	struct inode *root_inode = d_inode(s->s_root);
> +	struct proc_fs_info *fs_info = proc_sb_info(s);
> +	struct dentry *net_symlink;
> +	int ret = -ENOMEM;
> +
> +	inode_lock(root_inode);
> +	net_symlink = d_alloc_name(s->s_root, "net");
> +	if (net_symlink) {
> +		struct inode *inode = new_inode(s);
> +		if (inode) {
> +			inode->i_ino = net_symlink_inum;
> +			inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
> +			inode->i_mode = S_IFLNK | S_IRWXUGO;
> +			inode->i_uid = GLOBAL_ROOT_UID;
> +			inode->i_gid = GLOBAL_ROOT_GID;
> +			inode->i_op = &proc_net_symlink_inode_operations;
> +			d_add(net_symlink, inode);
> +			ret = 0;
> +		} else {
> +			dput(net_symlink);
> +		}
> +	}
> +	inode_unlock(root_inode);
> +
> +	if (ret)
> +		pr_err("proc_fill_super: can't allocate /proc/net\n");
> +	else
> +		fs_info->proc_net = net_symlink;
> +
> +	return ret;
> +}
> +
> +void __init proc_net_symlink_init(void)
> +{
> +	proc_alloc_inum(&net_symlink_inum);
> +}
> +
>  int __init proc_net_init(void)
>  {
> -	proc_symlink("net", NULL, "self/net");
> +	proc_net_symlink_init();
> 
>  	return register_pernet_subsys(&proc_net_ns_ops);
>  }
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 3c2ee3eb1138..6e57e9a4acf9 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -207,7 +207,11 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
>  	if (ret) {
>  		return ret;
>  	}
> -	return proc_setup_thread_self(s);
> +	ret = proc_setup_thread_self(s);
> +	if (ret) {
> +		return ret;
> +	}
> +	return proc_setup_net_symlink(s);
>  }
> 
>  static int proc_reconfigure(struct fs_context *fc)
> @@ -268,6 +272,7 @@ static void proc_kill_sb(struct super_block *sb)
> 
>  	dput(fs_info->proc_self);
>  	dput(fs_info->proc_thread_self);
> +	dput(fs_info->proc_net);
> 
>  	kill_anon_super(sb);
>  	put_pid_ns(fs_info->pid_ns);
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 81d6e4ec2294..65f4ef15c8bf 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -62,6 +62,7 @@ struct proc_fs_info {
>  	struct pid_namespace *pid_ns;
>  	struct dentry *proc_self;        /* For /proc/self */
>  	struct dentry *proc_thread_self; /* For /proc/thread-self */
> +	struct dentry *proc_net;	 /* For /proc/net */
>  	kgid_t pid_gid;
>  	enum proc_hidepid hide_pid;
>  	enum proc_pidonly pidonly;
> --
> 2.35.3

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

