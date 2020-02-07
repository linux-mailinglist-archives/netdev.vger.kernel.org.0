Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD23E1559AE
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 15:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgBGOfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 09:35:47 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:25735 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgBGOfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 09:35:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581086143;
        s=strato-dkim-0002; d=xenosoft.de;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=cNnAQeGGvvTjFRamv7ZkW4dXUfu1hiTbBBwJDVmkbDw=;
        b=Letc4GOAySLeglQk4xvXeo6pYs5eZeEz4En2jzp4KB4VoAl9mWa6s1yp0H9PsQdXeL
        djU8O9JcsXXHc3UiTiaRB5eb8n0iN6Ke7qnZH4lE7gYH3U/oDiBTy29xW83Q8fbZlVQb
        8BYvw+KQ59KpcAezOeSEJUO7pptCSvPhAmkm48t9S+Lg9Ur/GK8uE7f5SHSVzLn2SmAp
        nhTDHJvtn1kGLJrmvNt09pbkQdjWZw2Het2iSlOEr9MssCVYGPDnAZbx0bmvMaDhZE6C
        ZrYcjHIFvdTfetRXCrLs7yg5xziqQtYr+fOFgcnSEErm8bFYTZcJe5pGiPw8+RrL6a19
        PtuQ==
X-RZG-AUTH: ":L2QefEenb+UdBJSdRCXu93KJ1bmSGnhMdmOod1DhGM4l4Hio94KKxRySfLxnHfJ+Dkjp5DdBJSrwuuqxvPgBL7coCbpz+JyHSiG0DZUc3rEWew=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2a02:8109:89c0:ebfc:b9f8:3811:c7de:b70d]
        by smtp.strato.de (RZmta 46.1.12 AUTH)
        with ESMTPSA id 40bcf3w17EYpeyF
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 7 Feb 2020 15:34:51 +0100 (CET)
Subject: Latest Git kernel: avahi-daemon[2410]: ioctl(): Inappropriate ioctl
 for device
To:     arnd@arndb.de
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        DTML <devicetree@vger.kernel.org>,
        Darren Stevens <darren@stevens-zone.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, "contact@a-eon.com" <contact@a-eon.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>, Christoph Hellwig <hch@lst.de>,
        mad skateman <madskateman@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Christian Zigotzky <info@xenosoft.de>
References: <20200203095325.24c3ab1c@cakuba.hsd1.ca.comcast.net>
 <C11859E1-BE71-494F-81E2-9B27E27E60EE@xenosoft.de>
 <87tv441gg1.fsf@mpe.ellerman.id.au>
From:   Christian Zigotzky <chzigotzky@xenosoft.de>
Message-ID: <42888ad2-71e0-6d03-ddff-3de6f0ee5d43@xenosoft.de>
Date:   Fri, 7 Feb 2020 15:34:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87tv441gg1.fsf@mpe.ellerman.id.au>
Content-Type: multipart/mixed;
 boundary="------------25FA60D130063DB92E20AE88"
Content-Language: en-AU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------25FA60D130063DB92E20AE88
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello Arnd,

We regularly compile and test Linux kernels every day during the merge 
window. Since Thursday last week we have very high CPU usage because of 
the avahi daemon on our desktop Linux systems (Ubuntu, Debian etc). The 
avahi daemon produces a lot of the following log message. This generates 
high CPU usage.

Error message: avahi-daemon[2410]: ioctl(): Inappropriate ioctl for device

strace /usr/sbin/avahi-daemon:

poll([{fd=4, events=POLLIN}, {fd=16, events=POLLIN}, {fd=15, 
events=POLLIN}, {fd=14, events=POLLIN}, {fd=13, events=POLLIN}, {fd=12, 
events=POLLIN}, {fd=11, events=POLLIN}, {fd=10, events=POLLIN}, {fd=9, 
events=POLLIN}, {fd=8, events=POLLIN}, {fd=6, events=POLLIN}], 11, 65) = 
2 ([{fd=12, revents=POLLIN}, {fd=9, revents=POLLIN}])
ioctl(12, FIONREAD, 0xffba6f24)         = -1 ENOTTY (Inappropriate ioctl 
for device)
write(2, "ioctl(): Inappropriate ioctl for"..., 39ioctl(): Inappropriate 
ioctl for device) = 39
write(2, "\n", 1
)                       = 1

----------------------

I bisected the latest kernel source code today.

Result:

77b9040195dea3fcddf19e136c9e99a501351778 is the first bad commit
commit 77b9040195dea3fcddf19e136c9e99a501351778
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Wed Nov 27 21:25:36 2019 +0100

     compat_ioctl: simplify the implementation

     Now that both native and compat ioctl syscalls are
     in the same file, a couple of simplifications can
     be made, bringing the implementation closer together:

     - do_vfs_ioctl(), ioctl_preallocate(), and compat_ioctl_preallocate()
       can become static, allowing the compiler to optimize better

     - slightly update the coding style for consistency between
       the functions.

     - rather than listing each command in two switch statements
       for the compat case, just call a single function that has
       all the common commands.

     As a side-effect, FS_IOC_RESVSP/FS_IOC_RESVSP64 are now available
     to x86 compat tasks, along with FS_IOC_RESVSP_32/FS_IOC_RESVSP64_32.
     This is harmless for i386 emulation, and can be considered a bugfix
     for x32 emulation, which never supported these in the past.

     Reviewed-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
     Signed-off-by: Arnd Bergmann <arnd@arndb.de>

:040000 040000 5c4b62f4d1bfe643d3bbf9d9a3b50ee50ae0f159 
5ca610e3197df96adfcae4f94fceeb496756609b M    fs
:040000 040000 086f2e2ac49384988733cbb706243943748c4ce7 
b906926e53dfa2e8927629e77a0708dda6f49d31 M    include

----------------------

Link to the first bad commit: 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=77b9040195dea3fcddf19e136c9e99a501351778

I was able to revert the first bad commit.

git revert 77b9040195dea3fcddf19e136c9e99a501351778

[master a91dcf9dc14c] Revert "compat_ioctl: simplify the implementation"
  4 files changed, 105 insertions(+), 64 deletions(-)

After that the avahi daemon works without any problems again.

I created a patch today. (attached)

It is also possible to deactivate the avahi daemon with the following lines
in the file "/etc/avahi/avahi-daemon.conf":

use-ipv4=no
use-ipv6=no

Could you please check your commit?

Thanks,
Christian

--------------25FA60D130063DB92E20AE88
Content-Type: text/x-patch; charset=UTF-8;
 name="compat_ioctl-v1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="compat_ioctl-v1.patch"

diff -rupN a/fs/internal.h b/fs/internal.h
--- a/fs/internal.h	2020-02-07 13:20:46.294317088 +0100
+++ b/fs/internal.h	2020-02-07 13:16:06.731416797 +0100
@@ -182,6 +182,12 @@ extern void mnt_pin_kill(struct mount *m
  */
 extern const struct dentry_operations ns_dentry_operations;
 
+/*
+ * fs/ioctl.c
+ */
+extern int do_vfs_ioctl(struct file *file, unsigned int fd, unsigned int cmd,
+		    unsigned long arg);
+
 /* direct-io.c: */
 int sb_init_dio_done_wq(struct super_block *sb);
 
diff -rupN a/fs/ioctl.c b/fs/ioctl.c
--- a/fs/ioctl.c	2020-02-07 13:20:46.294317088 +0100
+++ b/fs/ioctl.c	2020-02-07 13:16:06.331418365 +0100
@@ -467,7 +467,7 @@ EXPORT_SYMBOL(generic_block_fiemap);
  * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
  * are used here, rest are ignored.
  */
-static int ioctl_preallocate(struct file *filp, int mode, void __user *argp)
+int ioctl_preallocate(struct file *filp, int mode, void __user *argp)
 {
 	struct inode *inode = file_inode(filp);
 	struct space_resv sr;
@@ -495,8 +495,8 @@ static int ioctl_preallocate(struct file
 /* on ia32 l_start is on a 32-bit boundary */
 #if defined CONFIG_COMPAT && defined(CONFIG_X86_64)
 /* just account for different alignment */
-static int compat_ioctl_preallocate(struct file *file, int mode,
-				    struct space_resv_32 __user *argp)
+int compat_ioctl_preallocate(struct file *file, int mode,
+				struct space_resv_32 __user *argp)
 {
 	struct inode *inode = file_inode(file);
 	struct space_resv_32 sr;
@@ -521,9 +521,11 @@ static int compat_ioctl_preallocate(stru
 }
 #endif
 
-static int file_ioctl(struct file *filp, unsigned int cmd, int __user *p)
+static int file_ioctl(struct file *filp, unsigned int cmd,
+		unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
+	int __user *p = (int __user *)arg;
 
 	switch (cmd) {
 	case FIBMAP:
@@ -540,7 +542,7 @@ static int file_ioctl(struct file *filp,
 		return ioctl_preallocate(filp, FALLOC_FL_ZERO_RANGE, p);
 	}
 
-	return -ENOIOCTLCMD;
+	return vfs_ioctl(filp, cmd, arg);
 }
 
 static int ioctl_fionbio(struct file *filp, int __user *argp)
@@ -659,48 +661,53 @@ out:
 }
 
 /*
+ * When you add any new common ioctls to the switches above and below
+ * please update compat_sys_ioctl() too.
+ *
  * do_vfs_ioctl() is not for drivers and not intended to be EXPORT_SYMBOL()'d.
  * It's just a simple helper for sys_ioctl and compat_sys_ioctl.
- *
- * When you add any new common ioctls to the switches above and below,
- * please ensure they have compatible arguments in compat mode.
  */
-static int do_vfs_ioctl(struct file *filp, unsigned int fd,
-			unsigned int cmd, unsigned long arg)
+int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
+	     unsigned long arg)
 {
+	int error = 0;
 	void __user *argp = (void __user *)arg;
 	struct inode *inode = file_inode(filp);
 
 	switch (cmd) {
 	case FIOCLEX:
 		set_close_on_exec(fd, 1);
-		return 0;
+		break;
 
 	case FIONCLEX:
 		set_close_on_exec(fd, 0);
-		return 0;
+		break;
 
 	case FIONBIO:
-		return ioctl_fionbio(filp, argp);
+		error = ioctl_fionbio(filp, argp);
+		break;
 
 	case FIOASYNC:
-		return ioctl_fioasync(fd, filp, argp);
+		error = ioctl_fioasync(fd, filp, argp);
+		break;
 
 	case FIOQSIZE:
 		if (S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode) ||
 		    S_ISLNK(inode->i_mode)) {
 			loff_t res = inode_get_bytes(inode);
-			return copy_to_user(argp, &res, sizeof(res)) ?
-					    -EFAULT : 0;
-		}
-
-		return -ENOTTY;
+			error = copy_to_user(argp, &res, sizeof(res)) ?
+					-EFAULT : 0;
+		} else
+			error = -ENOTTY;
+		break;
 
 	case FIFREEZE:
-		return ioctl_fsfreeze(filp);
+		error = ioctl_fsfreeze(filp);
+		break;
 
 	case FITHAW:
-		return ioctl_fsthaw(filp);
+		error = ioctl_fsthaw(filp);
+		break;
 
 	case FS_IOC_FIEMAP:
 		return ioctl_fiemap(filp, argp);
@@ -709,7 +716,6 @@ static int do_vfs_ioctl(struct file *fil
 		/* anon_bdev filesystems may not have a block size */
 		if (!inode->i_sb->s_blocksize)
 			return -EINVAL;
-
 		return put_user(inode->i_sb->s_blocksize, (int __user *)argp);
 
 	case FICLONE:
@@ -723,30 +729,24 @@ static int do_vfs_ioctl(struct file *fil
 
 	default:
 		if (S_ISREG(inode->i_mode))
-			return file_ioctl(filp, cmd, argp);
+			error = file_ioctl(filp, cmd, arg);
+		else
+			error = vfs_ioctl(filp, cmd, arg);
 		break;
 	}
-
-	return -ENOIOCTLCMD;
+	return error;
 }
 
 int ksys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
-	struct fd f = fdget(fd);
 	int error;
+	struct fd f = fdget(fd);
 
 	if (!f.file)
 		return -EBADF;
-
 	error = security_file_ioctl(f.file, cmd, arg);
-	if (error)
-		goto out;
-
-	error = do_vfs_ioctl(f.file, fd, cmd, arg);
-	if (error == -ENOIOCTLCMD)
-		error = vfs_ioctl(f.file, cmd, arg);
-
-out:
+	if (!error)
+		error = do_vfs_ioctl(f.file, fd, cmd, arg);
 	fdput(f);
 	return error;
 }
@@ -790,63 +790,92 @@ long compat_ptr_ioctl(struct file *file,
 EXPORT_SYMBOL(compat_ptr_ioctl);
 
 COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
-		       compat_ulong_t, arg)
+		       compat_ulong_t, arg32)
 {
+	unsigned long arg = arg32;
 	struct fd f = fdget(fd);
-	int error;
-
+	int error = -EBADF;
 	if (!f.file)
-		return -EBADF;
+		goto out;
 
 	/* RED-PEN how should LSM module know it's handling 32bit? */
 	error = security_file_ioctl(f.file, cmd, arg);
 	if (error)
-		goto out;
+		goto out_fput;
 
 	switch (cmd) {
-	/* FICLONE takes an int argument, so don't use compat_ptr() */
+	/* these are never seen by ->ioctl(), no argument or int argument */
+	case FIOCLEX:
+	case FIONCLEX:
+	case FIFREEZE:
+	case FITHAW:
 	case FICLONE:
-		error = ioctl_file_clone(f.file, arg, 0, 0, 0);
-		break;
-
-#if defined(CONFIG_X86_64)
+		goto do_ioctl;
+	/* these are never seen by ->ioctl(), pointer argument */
+	case FIONBIO:
+	case FIOASYNC:
+	case FIOQSIZE:
+	case FS_IOC_FIEMAP:
+	case FIGETBSZ:
+	case FICLONERANGE:
+	case FIDEDUPERANGE:
+		goto found_handler;
+	/*
+	 * The next group is the stuff handled inside file_ioctl().
+	 * For regular files these never reach ->ioctl(); for
+	 * devices, sockets, etc. they do and one (FIONREAD) is
+	 * even accepted in some cases.  In all those cases
+	 * argument has the same type, so we can handle these
+	 * here, shunting them towards do_vfs_ioctl().
+	 * ->compat_ioctl() will never see any of those.
+	 */
+	/* pointer argument, never actually handled by ->ioctl() */
+	case FIBMAP:
+		goto found_handler;
+	/* handled by some ->ioctl(); always a pointer to int */
+	case FIONREAD:
+		goto found_handler;
 	/* these get messy on amd64 due to alignment differences */
+#if defined(CONFIG_X86_64)
 	case FS_IOC_RESVSP_32:
 	case FS_IOC_RESVSP64_32:
 		error = compat_ioctl_preallocate(f.file, 0, compat_ptr(arg));
-		break;
+		goto out_fput;
 	case FS_IOC_UNRESVSP_32:
 	case FS_IOC_UNRESVSP64_32:
 		error = compat_ioctl_preallocate(f.file, FALLOC_FL_PUNCH_HOLE,
 				compat_ptr(arg));
-		break;
+		goto out_fput;
 	case FS_IOC_ZERO_RANGE_32:
 		error = compat_ioctl_preallocate(f.file, FALLOC_FL_ZERO_RANGE,
 				compat_ptr(arg));
-		break;
+		goto out_fput;
+#else
+	case FS_IOC_RESVSP:
+	case FS_IOC_RESVSP64:
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
+	case FS_IOC_ZERO_RANGE:
+		goto found_handler;
 #endif
 
-	/*
-	 * everything else in do_vfs_ioctl() takes either a compatible
-	 * pointer argument or no argument -- call it with a modified
-	 * argument.
-	 */
 	default:
-		error = do_vfs_ioctl(f.file, fd, cmd,
-				     (unsigned long)compat_ptr(arg));
-		if (error != -ENOIOCTLCMD)
-			break;
-
-		if (f.file->f_op->compat_ioctl)
+		if (f.file->f_op->compat_ioctl) {
 			error = f.file->f_op->compat_ioctl(f.file, cmd, arg);
-		if (error == -ENOIOCTLCMD)
-			error = -ENOTTY;
-		break;
+			if (error != -ENOIOCTLCMD)
+				goto out_fput;
+		}
+		error = -ENOTTY;
+		goto out_fput;
 	}
 
- out:
+ found_handler:
+	arg = (unsigned long)compat_ptr(arg);
+ do_ioctl:
+	error = do_vfs_ioctl(f.file, fd, cmd, arg);
+ out_fput:
 	fdput(f);
-
+ out:
 	return error;
 }
 #endif
diff -rupN a/include/linux/falloc.h b/include/linux/falloc.h
--- a/include/linux/falloc.h	2020-02-07 13:20:46.382316741 +0100
+++ b/include/linux/falloc.h	2020-02-07 13:16:06.331418365 +0100
@@ -51,6 +51,8 @@ struct space_resv_32 {
 #define FS_IOC_UNRESVSP64_32	_IOW ('X', 43, struct space_resv_32)
 #define FS_IOC_ZERO_RANGE_32	_IOW ('X', 57, struct space_resv_32)
 
+int compat_ioctl_preallocate(struct file *, int, struct space_resv_32 __user *);
+
 #endif
 
 #endif /* _FALLOC_H_ */
diff -rupN a/include/linux/fs.h b/include/linux/fs.h
--- a/include/linux/fs.h	2020-02-07 13:20:46.382316741 +0100
+++ b/include/linux/fs.h	2020-02-07 13:16:06.731416797 +0100
@@ -2563,6 +2563,10 @@ extern int finish_open(struct file *file
 			int (*open)(struct inode *, struct file *));
 extern int finish_no_open(struct file *file, struct dentry *dentry);
 
+/* fs/ioctl.c */
+
+extern int ioctl_preallocate(struct file *filp, int mode, void __user *argp);
+
 /* fs/dcache.c */
 extern void __init vfs_caches_init_early(void);
 extern void __init vfs_caches_init(void);

--------------25FA60D130063DB92E20AE88--
