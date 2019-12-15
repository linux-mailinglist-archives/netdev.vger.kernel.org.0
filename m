Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139E711F581
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 05:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfLOEBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 23:01:31 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35768 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfLOEBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 23:01:31 -0500
Received: by mail-pj1-f65.google.com with SMTP id w23so1492307pjd.2;
        Sat, 14 Dec 2019 20:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=shsr7upRmos7BquY4lUPGhwBviQZfi7I2Tz+KmfbZKU=;
        b=g4dkITdskuSq4xu9XAMlGEiCmqLvybOqtOfHkE4HerumrPNh4ud+x6SiIRME4SiGsu
         NLEsFGDe60z6J0siitMvL97/a1DrRK/AqDL6Dojxcu/BM5/+nleVdryh6BMZ1p1Kos9f
         k1PVyVDiFBSyC/YtboY7IVhWxOhPo9rKNw/hfOyZKaqBiR8u/YFXQ/+58IerSBhDo9L8
         uNItP7KWHsU6ESPnb8xM+c/xqp3OXvKqi9v7wcu153avGBn3QqPmisvZEEmmTcm4sezx
         C+zG7gbjgl4KoDAjShSxWDURjd/pXNkq+3tDVQn5+xzWGxEg5QMQ0P2KV95hy62lSAWt
         6JYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=shsr7upRmos7BquY4lUPGhwBviQZfi7I2Tz+KmfbZKU=;
        b=D05OSfFo/iQX7UMeUjwpJICJEAIYqPTZWOe3zdNnYA+0QerXRZxmFlrNQWw09MU+lq
         vjv4bb2NGMmYL0PF5Eu0D0+ApjXwKirLAm0C82rk0dlW9B8r9PUS1hb3PhXoti+VMqkV
         nMOZVAjFaSxSurpWslMaRnQkf6Q3zKO5ngoKq9C9l4+wkQtNKF3+79ez12h/evSxS7dT
         7Z8+Tgo57WKiPxmxcbWVLxzoxiRiP1L5364xz84aNdcKKBHvPmd+QDu846Ky+x9lfNgj
         oE/5+6OSgjwet8LAJpb8VAi+Dz3/I1KD7KZfOTVD/Ly2WWoZGaOf8ekmX5aS1llzemJ8
         hD4g==
X-Gm-Message-State: APjAAAX+hzhma4nyPfDgehGN1j3cU7E8oYXoh3Qg+l+EW4LbDL5BXPMj
        bB512tyRwIy0rT/DTeucB8avt2cFI0V8PA==
X-Google-Smtp-Source: APXvYqxHL5eCWkmgzAMVIKUZ+C7ipowx9UmSUgUdei0Uo+vpOW1NSahrx7BZoBIEltkGZtCJ/scqPg==
X-Received: by 2002:a17:902:7406:: with SMTP id g6mr8969653pll.103.1576382489790;
        Sat, 14 Dec 2019 20:01:29 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id o12sm14586002pjf.19.2019.12.14.20.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 20:01:29 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org
Subject: [PATCH bpf-next v12 1/2] bpf: add new helper get_file_path for mapping a file descriptor to a pathname
Date:   Sat, 14 Dec 2019 23:01:09 -0500
Message-Id: <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1576381511.git.ethercflow@gmail.com>
References: <afe4deb020b781c76e9df8403a744f88a8725cd2.1575517685.git.ethercflow@gmail.com>
 <cover.1576381511.git.ethercflow@gmail.com>
In-Reply-To: <cover.1576381511.git.ethercflow@gmail.com>
References: <cover.1576381511.git.ethercflow@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When people want to identify which file system files are being opened,
read, and written to, they can use this helper with file descriptor as
input to achieve this goal. Other pseudo filesystems are also supported.

This requirement is mainly discussed here:

  https://github.com/iovisor/bcc/issues/237

v11->v12: addressed Alexei's feedback
- only allow tracepoints to make sure it won't dead lock

v10->v11: addressed Al and Alexei's feedback
- fix missing fput()

v9->v10: addressed Andrii's feedback
- send this patch together with the patch selftests as one patch series

v8->v9:
- format helper description

v7->v8: addressed Alexei's feedback
- use fget_raw instead of fdget_raw, as fdget_raw is only used inside fs/
- ensure we're in user context which is safe fot the help to run
- filter unmountable pseudo filesystem, because they don't have real path
- supplement the description of this helper function

v6->v7:
- fix missing signed-off-by line

v5->v6: addressed Andrii's feedback
- avoid unnecessary goto end by having two explicit returns

v4->v5: addressed Andrii and Daniel's feedback
- rename bpf_fd2path to bpf_get_file_path to be consistent with other
helper's names
- when fdget_raw fails, set ret to -EBADF instead of -EINVAL
- remove fdput from fdget_raw's error path
- use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointer
into the buffer or an error code if the path was too long
- modify the normal path's return value to return copied string length
including NUL
- update this helper description's Return bits.

v3->v4: addressed Daniel's feedback
- fix missing fdput()
- move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
- move fd2path's test code to another patch
- add comment to explain why use fdget_raw instead of fdget

v2->v3: addressed Yonghong's feedback
- remove unnecessary LOCKDOWN_BPF_READ
- refactor error handling section for enhanced readability
- provide a test case in tools/testing/selftests/bpf

v1->v2: addressed Daniel's feedback
- fix backward compatibility
- add this helper description
- fix signed-off name

Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
---
 include/uapi/linux/bpf.h       | 29 +++++++++++++-
 kernel/trace/bpf_trace.c       | 70 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h | 29 +++++++++++++-
 3 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index dbbcf0b02970..71d9705df120 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2821,6 +2821,32 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
+ *
+ * int bpf_get_file_path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. Notice the **path** don't support unmountable
+ *		pseudo filesystems as they don't have path (eg: SOCKFS, PIPEFS).
+ *		The *size* must be strictly positive. On success, the helper
+ *		makes sure that the *path* is NUL-terminated, and the buffer
+ *		could be:
+ *		- a regular full path (include mountable fs eg: /proc, /sys)
+ *		- a regular full path with "(deleted)" at the end.
+ *		On failure, it is filled with zeroes.
+ *	Return
+ *		On success, returns the length of the copied string INCLUDING
+ *		the trailing NUL.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EPERM** if no permission to get the path (eg: in irq ctx).
+ *
+ *		**-EBADF** if *fd* is invalid.
+ *
+ *		**-EINVAL** if *fd* corresponds to a unmountable pseudo fs
+ *
+ *		**-ENAMETOOLONG** if full path is longer than *size*
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2938,7 +2964,8 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(get_file_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e5ef4ae9edb5..db9c0ec46a5d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -762,6 +762,72 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
 	.arg1_type	= ARG_ANYTHING,
 };
 
+BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
+{
+	struct file *f;
+	char *p;
+	int ret = -EBADF;
+
+	/* Ensure we're in user context which is safe for the helper to
+	 * run. This helper has no business in a kthread.
+	 */
+	if (unlikely(in_interrupt() ||
+		     current->flags & (PF_KTHREAD | PF_EXITING))) {
+		ret = -EPERM;
+		goto error;
+	}
+
+	/* Use fget_raw instead of fget to support O_PATH, and it doesn't
+	 * have any sleepable code, so it's ok to be here.
+	 */
+	f = fget_raw(fd);
+	if (!f)
+		goto error;
+
+	/* For unmountable pseudo filesystem, it seems to have no meaning
+	 * to get their fake paths as they don't have path, and to be no
+	 * way to validate this function pointer can be always safe to call
+	 * in the current context.
+	 */
+	if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname) {
+		ret = -EINVAL;
+		fput(f);
+		goto error;
+	}
+
+	/* After filter unmountable pseudo filesytem, d_path won't call
+	 * dentry->d_op->d_name(), the normally path doesn't have any
+	 * sleepable code, and despite it uses the current macro to get
+	 * fs_struct (current->fs), we've already ensured we're in user
+	 * context, so it's ok to be here.
+	 */
+	p = d_path(&f->f_path, dst, size);
+	if (IS_ERR(p)) {
+		ret = PTR_ERR(p);
+		fput(f);
+		goto error;
+	}
+
+	ret = strlen(p);
+	memmove(dst, p, ret);
+	dst[ret++] = '\0';
+	fput(f);
+	return ret;
+
+error:
+	memset(dst, '0', size);
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_get_file_path_proto = {
+	.func       = bpf_get_file_path,
+	.gpl_only   = true,
+	.ret_type   = RET_INTEGER,
+	.arg1_type  = ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type  = ARG_CONST_SIZE,
+	.arg3_type  = ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -953,6 +1019,8 @@ tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_stackid_proto_tp;
 	case BPF_FUNC_get_stack:
 		return &bpf_get_stack_proto_tp;
+	case BPF_FUNC_get_file_path:
+		return &bpf_get_file_path_proto;
 	default:
 		return tracing_func_proto(func_id, prog);
 	}
@@ -1146,6 +1214,8 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_stackid_proto_raw_tp;
 	case BPF_FUNC_get_stack:
 		return &bpf_get_stack_proto_raw_tp;
+	case BPF_FUNC_get_file_path:
+		return &bpf_get_file_path_proto;
 	default:
 		return tracing_func_proto(func_id, prog);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index dbbcf0b02970..71d9705df120 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2821,6 +2821,32 @@ union bpf_attr {
  * 	Return
  * 		On success, the strictly positive length of the string,	including
  * 		the trailing NUL character. On error, a negative value.
+ *
+ * int bpf_get_file_path(char *path, u32 size, int fd)
+ *	Description
+ *		Get **file** atrribute from the current task by *fd*, then call
+ *		**d_path** to get it's absolute path and copy it as string into
+ *		*path* of *size*. Notice the **path** don't support unmountable
+ *		pseudo filesystems as they don't have path (eg: SOCKFS, PIPEFS).
+ *		The *size* must be strictly positive. On success, the helper
+ *		makes sure that the *path* is NUL-terminated, and the buffer
+ *		could be:
+ *		- a regular full path (include mountable fs eg: /proc, /sys)
+ *		- a regular full path with "(deleted)" at the end.
+ *		On failure, it is filled with zeroes.
+ *	Return
+ *		On success, returns the length of the copied string INCLUDING
+ *		the trailing NUL.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EPERM** if no permission to get the path (eg: in irq ctx).
+ *
+ *		**-EBADF** if *fd* is invalid.
+ *
+ *		**-EINVAL** if *fd* corresponds to a unmountable pseudo fs
+ *
+ *		**-ENAMETOOLONG** if full path is longer than *size*
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2938,7 +2964,8 @@ union bpf_attr {
 	FN(probe_read_user),		\
 	FN(probe_read_kernel),		\
 	FN(probe_read_user_str),	\
-	FN(probe_read_kernel_str),
+	FN(probe_read_kernel_str),	\
+	FN(get_file_path),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.17.1

