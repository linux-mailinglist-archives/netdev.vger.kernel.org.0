Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0A3C42DB
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbfJAVmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:42:01 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37952 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbfJAVmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:42:00 -0400
Received: by mail-qk1-f194.google.com with SMTP id u186so12836523qkc.5;
        Tue, 01 Oct 2019 14:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mJEbpnnBACnjKqVJ7ryTqoKmyEa7W0hY6uGaayjFIYA=;
        b=h80AYzek/0mtKGTG/s6iFgvbhXKJGTvX6PBJ70/+iPeybULGYsNjwDQJM1/sKgG52L
         0jh70gaSzstDlldMZCwpZHZDk6pYWLjM9ksE4+xRcNBvO7BtC1OiHplVTErVZ/Bpa/Tv
         is6mkB5u/RUm9L43cx+DnLF3wAr/7j370Nv5otRPoq5B9VkhCm8eZyrzQylG/5hj0l4E
         xfwKjXwklg/jWgf3sDGKE5toRQ4fagK7uDBuQfCnrlcJwjuZY4Hg45WLAoCksTpf56RS
         ul2t4WMwqLfutbcLf5WK3r/TKSRXfR7RiPflLzfRzMtnc7EMKRY+mzjfgOHJbyNFH9dK
         RJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJEbpnnBACnjKqVJ7ryTqoKmyEa7W0hY6uGaayjFIYA=;
        b=WPWy9GcIPXiTN8XN9Am9tgFp483TsRxZrIVRdDLDDNDkBR0hvOFVf6jQnYyri7Hq63
         x7qIQZD+09l2Iu2/VsXBBi1geGHhfT55hT93cWYsIt9nDsPnPINm/rcPHNJZFiAHGjZ0
         4tQ6xspqyR52eGK4gMpgwg7izyjBrfPmdUrnMkH235Wy59o0WTy6az4rlVJNnHFROuo6
         j4hlwiroeSqSSVU4Qf4v2imrQj0raGhIAlApfvfXlGf+Cb/vS2rVXbMqbTlqJ2hBC3Cp
         NiCnEaLPnmDN/ph49eUh4YbJ8cQM5mcAI9lAPTQZmbcJfTZsgBZXSLO0Xdmyx6d3vABO
         XTDQ==
X-Gm-Message-State: APjAAAWbmI9OCnqiXhECufcBfFpuBL0eZ6bx9/D90WB0TqRdUbidVGXD
        iDtlMhKKKHHRkgl4+3PEXULBp4Omr80=
X-Google-Smtp-Source: APXvYqyvtKcku2+wJzxA5Qewwa8T6dTbMdM6Ab3lnVp5UHSGw3lN2BYrMSdOd9jse2XtuN97Hk26CA==
X-Received: by 2002:a05:620a:147:: with SMTP id e7mr285180qkn.227.1569966119391;
        Tue, 01 Oct 2019 14:41:59 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id v13sm8559352qtp.61.2019.10.01.14.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 14:41:58 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH V12 2/4] bpf: added new helper bpf_get_ns_current_pid_tgid
Date:   Tue,  1 Oct 2019 18:41:39 -0300
Message-Id: <20191001214141.6294-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001214141.6294-1-cneirabustos@gmail.com>
References: <20191001214141.6294-1-cneirabustos@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New bpf helper bpf_get_ns_current_pid_tgid,
This helper will return pid and tgid from current task
which namespace matches dev_t and inode number provided,
this will allows us to instrument a process inside a container.

Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
---
 include/linux/bpf.h      |  1 +
 include/uapi/linux/bpf.h | 18 +++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 36 ++++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  2 ++
 5 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d22338606..231001475504 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77c6be96d676..ea8145d7f897 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2750,6 +2750,21 @@ union bpf_attr {
  *		**-EOPNOTSUPP** kernel configuration does not enable SYN cookies
  *
  *		**-EPROTONOSUPPORT** IP packet version is not 4 or 6
+ *
+ * u64 bpf_get_ns_current_pid_tgid(u64 dev, u64 inum)
+ *	Return
+ *		A 64-bit integer containing the current tgid and pid from current task
+ *              which namespace inode and dev_t matches , and is create as such:
+ *		*current_task*\ **->tgid << 32 \|**
+ *		*current_task*\ **->pid**.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
+ *
+ *		**-ENOENT** if /proc/self/ns does not exists.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2862,7 +2877,8 @@ union bpf_attr {
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
-	FN(tcp_gen_syncookie),
+	FN(tcp_gen_syncookie),          \
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 66088a9e9b9e..b2fd5358f472 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2042,6 +2042,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..8777181d1717 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,8 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/pid_namespace.h>
+#include <linux/proc_ns.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -487,3 +489,37 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_2(bpf_get_ns_current_pid_tgid, u64, dev, u64, inum)
+{
+	struct task_struct *task = current;
+	struct pid_namespace *pidns;
+	pid_t pid, tgid;
+
+	if ((u64)(dev_t)dev != dev)
+		return -EINVAL;
+
+	if (unlikely(!task))
+		return -EINVAL;
+
+	pidns = task_active_pid_ns(task);
+	if (unlikely(!pidns))
+		return -ENOENT;
+
+
+	if (!ns_match(&pidns->ns, (dev_t)dev, inum))
+		return -EINVAL;
+
+	pid = task_pid_nr_ns(task, pidns);
+	tgid = task_tgid_nr_ns(task, pidns);
+
+	return (u64) tgid << 32 | pid;
+}
+
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
+	.func		= bpf_get_ns_current_pid_tgid,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+};
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 44bd08f2443b..32331a1dcb6d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_get_ns_current_pid_tgid:
+		return &bpf_get_ns_current_pid_tgid_proto;
 	default:
 		return NULL;
 	}
-- 
2.20.1

