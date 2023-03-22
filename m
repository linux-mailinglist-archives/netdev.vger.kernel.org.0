Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E416C4F8A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCVPf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjCVPfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:35:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B75E3B0C7;
        Wed, 22 Mar 2023 08:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 496E7B81D21;
        Wed, 22 Mar 2023 15:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11C4C433D2;
        Wed, 22 Mar 2023 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679499351;
        bh=WVV/H80+zuLPMgmWWvz0wCM8BiYBexz+Nk2HHh9NVAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BvgGxD2hLC0s4kB+sGkNES8gUWeJsKFGUdzYIvpWQnEAxyw7aoDYglaH2Jlntv64z
         Zl6TjXUh7CTlS4gDKjae1ZZ8UUsnGbogyPRpzzlEifpWYL02rztCs+gWedcCCdKlc5
         6IJvp2KRCLEHB8jJTQ69yMr3WpM4CCHjYaSf5MtxydiCl4cUEP/8uiq4mZMsPLq4QP
         cH0BlanMPmYN3dQx/wsbuNWz1RonkO8hBn4yg5j1hWlpbuwTK8vY1vVR7QloEzpvcJ
         sqIN5ADEdxhkppgC1AW33t4BDnAgisjqsim4LGVy9VrU930J2oS9lpaGES86xasWZE
         xvUnp8Zd/YGaA==
Date:   Wed, 22 Mar 2023 16:35:44 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: core: add getsockopt SO_PEERPIDFD
Message-ID: <20230322153544.u7rfjijcpuheda6m@wittgenstein>
References: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
 <20230321183342.617114-3-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230321183342.617114-3-aleksandr.mikhalitsyn@canonical.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 07:33:41PM +0100, Alexander Mikhalitsyn wrote:
> Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> This thing is direct analog of SO_PEERCRED which allows to get plain PID.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
> v2:
> 	According to review comments from Kuniyuki Iwashima and Christian Brauner:
> 	- use pidfd_create(..) retval as a result
> 	- whitespace change
> ---
>  arch/alpha/include/uapi/asm/socket.h    |  1 +
>  arch/mips/include/uapi/asm/socket.h     |  1 +
>  arch/parisc/include/uapi/asm/socket.h   |  1 +
>  arch/sparc/include/uapi/asm/socket.h    |  1 +
>  include/uapi/asm-generic/socket.h       |  1 +
>  net/core/sock.c                         | 21 +++++++++++++++++++++
>  tools/include/uapi/asm-generic/socket.h |  1 +
>  7 files changed, 27 insertions(+)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index ff310613ae64..e94f621903fe 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -138,6 +138,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 762dcb80e4ec..60ebaed28a4c 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -149,6 +149,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index df16a3e16d64..be264c2b1a11 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -130,6 +130,7 @@
>  #define SO_RCVMARK		0x4049
>  
>  #define SO_PASSPIDFD		0x404A
> +#define SO_PEERPIDFD		0x404B
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 6e2847804fea..682da3714686 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -131,6 +131,7 @@
>  #define SO_RCVMARK               0x0054
>  
>  #define SO_PASSPIDFD             0x0055
> +#define SO_PEERPIDFD             0x0056
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index b76169fdb80b..8ce8a39a1e5f 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -133,6 +133,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 3f974246ba3e..85c269ca9d8a 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1763,6 +1763,27 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
>  		goto lenout;
>  	}
>  
> +	case SO_PEERPIDFD:
> +	{
> +		struct pid *peer_pid;
> +		int pidfd;
> +
> +		if (len > sizeof(pidfd))
> +			len = sizeof(pidfd);
> +
> +		spin_lock(&sk->sk_peer_lock);
> +		peer_pid = get_pid(sk->sk_peer_pid);
> +		spin_unlock(&sk->sk_peer_lock);
> +
> +		pidfd = pidfd_create(peer_pid, 0);
> +
> +		put_pid(peer_pid);
> +
> +		if (copy_to_sockptr(optval, &pidfd, len))
> +			return -EFAULT;

This leaks the pidfd. We could do:

	if (copy_to_sockptr(optval, &pidfd, len)) {
		close_fd(pidfd);
		return -EFAULT;
	}

but it's a nasty anti-pattern to install the fd in the caller's fdtable
and then close it again. So let's avoid it if we can. Since you can only
set one socket option per setsockopt() sycall we should be able to
reserve an fd and pidfd_file, do the stuff that might fail, and then
call fd_install. So that would roughly be:

	peer_pid = get_pid(sk->sk_peer_pid);
	pidfd_file = pidfd_file_create(peer_pid, 0, &pidfd);
	f (copy_to_sockptr(optval, &pidfd, len))
	       return -EFAULT;
	goto lenout:
	
	.
	.
	.

lenout:
	if (copy_to_sockptr(optlen, &len, sizeof(int)))
		return -EFAULT;

	// Made it safely, install pidfd now.
	fd_install(pidfd, pidfd_file)

(See below for the associated api I'm going to publish independent of
this as kernel/fork.c and fanotify both could use it.)

But now, let's look at net/socket.c there's another wrinkle. So let's say you
have successfully installed the pidfd then it seems you can still fail later:

        if (level == SOL_SOCKET)
                err = sock_getsockopt(sock, level, optname, optval, optlen);
        else if (unlikely(!sock->ops->getsockopt))
                err = -EOPNOTSUPP;
        else
                err = sock->ops->getsockopt(sock, level, optname, optval,
                                            optlen);

        if (!in_compat_syscall())
                err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
                                                     optval, optlen, max_optlen,
                                                     err);

out_put:
	fput_light(sock->file, fput_needed);
	return err;

If the bpf hook returns an error we've placed an fd into the caller's sockopt
buffer without their knowledge.

From 4fee16f0920308bee2531fd3b08484f607eb5830 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 22 Mar 2023 15:59:02 +0100
Subject: [PATCH 1/3] [HERE BE DRAGONS - DRAFT - __UNTESTED__] pid: add
 pidfd_file_create()

Reserve and fd and pidfile, do stuff that might fail, install fd when
point of no return.

[HERE BE DRAGONS - DRAFT - __UNTESTED__] pid: add pidfd_file_create()

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 include/linux/pid.h |  1 +
 kernel/pid.c        | 45 +++++++++++++++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 343abf22092e..c486dbc4d7b6 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -80,6 +80,7 @@ extern struct pid *pidfd_pid(const struct file *file);
 struct pid *pidfd_get_pid(unsigned int fd, unsigned int *flags);
 struct task_struct *pidfd_get_task(int pidfd, unsigned int *flags);
 int pidfd_create(struct pid *pid, unsigned int flags);
+struct file *pidfd_file_create(struct pid *pid, unsigned int flags, int *pidfd);
 
 static inline struct pid *get_pid(struct pid *pid)
 {
diff --git a/kernel/pid.c b/kernel/pid.c
index 3fbc5e46b721..8d0924f1dbf6 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -576,6 +576,32 @@ struct task_struct *pidfd_get_task(int pidfd, unsigned int *flags)
 	return task;
 }
 
+struct file *pidfd_file_create(struct pid *pid, unsigned int flags, int *pidfd)
+{
+	int fd;
+	struct file *pidfile;
+
+	if (!pid || !pid_has_task(pid, PIDTYPE_TGID))
+		return ERR_PTR(-EINVAL);
+
+	if (flags & ~(O_NONBLOCK | O_RDWR | O_CLOEXEC))
+		return ERR_PTR(-EINVAL);
+
+	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return ERR_PTR(fd);
+
+	pidfile = anon_inode_getfile("[pidfd]", &pidfd_fops, pid,
+				     flags | O_RDWR | O_CLOEXEC);
+	if (IS_ERR(pidfile)) {
+		put_unused_fd(fd);
+		return pidfile;
+	}
+	get_pid(pid); /* held by pidfile now */
+	*pidfd = fd;
+	return pidfile;
+}
+
 /**
  * pidfd_create() - Create a new pid file descriptor.
  *
@@ -594,20 +620,15 @@ struct task_struct *pidfd_get_task(int pidfd, unsigned int *flags)
  */
 int pidfd_create(struct pid *pid, unsigned int flags)
 {
-	int fd;
+	int pidfd;
+	struct file *pidfile;
 
-	if (!pid || !pid_has_task(pid, PIDTYPE_TGID))
-		return -EINVAL;
+	pidfile = pidfd_file_create(pid, flags, &pidfd);
+	if (IS_ERR(pidfile))
+		return PTR_ERR(pidfile);
 
-	if (flags & ~(O_NONBLOCK | O_RDWR | O_CLOEXEC))
-		return -EINVAL;
-
-	fd = anon_inode_getfd("[pidfd]", &pidfd_fops, get_pid(pid),
-			      flags | O_RDWR | O_CLOEXEC);
-	if (fd < 0)
-		put_pid(pid);
-
-	return fd;
+	fd_install(pidfd, pidfile);
+	return pidfd;
 }
 
 /**
-- 
2.34.1

From c336f1c6cc39faa5aef4fbedd3c4f8eca51d8436 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 22 Mar 2023 15:59:54 +0100
Subject: [PATCH 2/3] [HERE BE DRAGONS - DRAFT - __UNTESTED__] fork: use
 pidfd_file_create()

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 kernel/fork.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index f68954d05e89..c8dc78ee0a74 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2296,20 +2296,11 @@ static __latent_entropy struct task_struct *copy_process(
 	 * if the fd table isn't shared).
 	 */
 	if (clone_flags & CLONE_PIDFD) {
-		retval = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
-		if (retval < 0)
-			goto bad_fork_free_pid;
-
-		pidfd = retval;
-
-		pidfile = anon_inode_getfile("[pidfd]", &pidfd_fops, pid,
-					      O_RDWR | O_CLOEXEC);
+		pidfile = pidfd_file_create(pid, O_RDWR | O_CLOEXEC, &pidfd);
 		if (IS_ERR(pidfile)) {
-			put_unused_fd(pidfd);
 			retval = PTR_ERR(pidfile);
 			goto bad_fork_free_pid;
 		}
-		get_pid(pid);	/* held by pidfile now */
 
 		retval = put_user(pidfd, args->pidfd);
 		if (retval)
-- 
2.34.1

From 0897f68fe06a8777d8ec600fdc719143f76095b1 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 22 Mar 2023 16:02:50 +0100
Subject: [PATCH 3/3] [HERE BE DRAGONS - DRAFT - __UNTESTED__] fanotify: use
 pidfd_file_create()

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 8f430bfad487..4a8db6b5f690 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -665,6 +665,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	unsigned int pidfd_mode = info_mode & FAN_REPORT_PIDFD;
 	struct file *f = NULL;
 	int ret, pidfd = FAN_NOPIDFD, fd = FAN_NOFD;
+	struct file *pidfd_file = NULL;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
@@ -718,9 +719,11 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 		    !pid_has_task(event->pid, PIDTYPE_TGID)) {
 			pidfd = FAN_NOPIDFD;
 		} else {
-			pidfd = pidfd_create(event->pid, 0);
-			if (pidfd < 0)
+			pidfd_file = pidfd_file_create(event->pid, 0, &pidfd);
+			if (IS_ERR(pidfd_file)) {
 				pidfd = FAN_EPIDFD;
+				pidfd_file = NULL;
+			}
 		}
 	}
 
@@ -750,6 +753,8 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 
 	if (f)
 		fd_install(fd, f);
+	if (pidfd_file)
+		fd_install(pidfd, pidfd_file);
 
 	return metadata.event_len;
 
@@ -759,8 +764,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 		fput(f);
 	}
 
-	if (pidfd >= 0)
-		close_fd(pidfd);
+	if (pidfd >= 0) {
+		put_unused_fd(pidfd);
+		fput(pidfd_file);
+	}
 
 	return ret;
 }
-- 
2.34.1

