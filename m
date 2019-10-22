Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245F7E0C6B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 21:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbfJVTSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 15:18:11 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:47066 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVTSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 15:18:10 -0400
Received: by mail-qk1-f193.google.com with SMTP id e66so17350801qkf.13;
        Tue, 22 Oct 2019 12:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ZO7S6LM3jSCHbQEfmNEYf2yD/qvK5cSl3UDAKIr2A8=;
        b=DMUTy1tc4a9vMQdVfwcNa+3qX8Q9wvoJCK+yI08TU4OxjtAyzRR4I7en21kdxAvYzG
         w0IonBCbGZWnSNU4ognXWsOKef2w9g7w276IQN+lHpbGwOgq2UmAUJMRoR0ynDiTvmN6
         A7hewQG2oSzr9B3L9Pn/0GRLXg1HdpBkszsqYPRY4w1i3TLmYU0dqklxn0o+1hq2NJb0
         8kJK/whmbJun03yYlMeKj8CF9F4Lq+gOjPOQnSgi8o+mlDvN5bXMPv6f6uh4eMgptI8V
         XYAZTUIoeJVzR+pDKaM7IZ9tWj+CONXHa/8AeJGxCmH6UPvc4aDeVc81H4XiAzEG5LFy
         A8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ZO7S6LM3jSCHbQEfmNEYf2yD/qvK5cSl3UDAKIr2A8=;
        b=Um1iAWAD7RPv74QwjJSg18i02g1P6xSG7ykDRBNmp1sPmAokezCEW7FC6GqIGDx7nr
         5AtCjws19ZlTkk8xDVcbc9Y2HKoi3r5KyM8DvoPxP75wJCSmwpGjika7JdewPXaeCf8V
         vLqQkiFObRMeCVu+3TNFhjMr7OyJG5im7p/JM9hgwtsU5w8mc33ZbJ103Bxd1aTqFUI+
         3xKT5kF/W9hmYiSCTVyazQQnFVsxvPQg+75oUEukqubgkJzIAT1tl7SDIBqEe+yKeKH2
         ZN8shZCQb/V8WfbQP670JIJdrej9jKYSrXeiCZEUB260N9MLa5+7QpYWBhwrmRZA3hEu
         TlSA==
X-Gm-Message-State: APjAAAUcfyWC5vsrTjBaYrVmen/lnnu/1CXdDt6xi3XVTws2wh/iCk8F
        9vWAfqHztyC/cFGDNuPXaVmtiPiVWwLf6983
X-Google-Smtp-Source: APXvYqxyW8PViZh3AycUqVq5NYcF0ynS+YcsUQIwSexVHtCW7Lqy/V0C2SyouvDjwG/eyCbwA+d+dQ==
X-Received: by 2002:a37:8547:: with SMTP id h68mr4636852qkd.162.1571771887521;
        Tue, 22 Oct 2019 12:18:07 -0700 (PDT)
Received: from ebpf00.byteswizards.com ([190.162.109.190])
        by smtp.googlemail.com with ESMTPSA id r36sm8015969qta.27.2019.10.22.12.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 12:18:06 -0700 (PDT)
From:   Carlos Neira <cneirabustos@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, ebiederm@xmission.com, brouer@redhat.com,
        bpf@vger.kernel.org, cneirabustos@gmail.com
Subject: [PATCH v15 2/5] bpf: added new helper bpf_get_ns_current_pid_tgid
Date:   Tue, 22 Oct 2019 16:17:48 -0300
Message-Id: <20191022191751.3780-3-cneirabustos@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191022191751.3780-1-cneirabustos@gmail.com>
References: <20191022191751.3780-1-cneirabustos@gmail.com>
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
 include/uapi/linux/bpf.h | 20 +++++++++++++++++-
 kernel/bpf/core.c        |  1 +
 kernel/bpf/helpers.c     | 45 ++++++++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |  2 ++
 5 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2c2c29b49845..1d7c86019113 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1082,6 +1082,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4af8b0819a32..4c3e0b0952e6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2775,6 +2775,19 @@ union bpf_attr {
  * 		restricted to raw_tracepoint bpf programs.
  * 	Return
  * 		0 on success, or a negative error in case of failure.
+ *
+ * int bpf_get_ns_current_pid_tgid(u64 dev, u64 ino, struct bpf_pidns_info *nsdata, u32 size)
+ *	Description
+ *		Returns 0 on success, values for *pid* and *tgid* as seen from the current
+ *		*namespace* will be returned in *nsdata*.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EINVAL** if dev and inum supplied don't match dev_t and inode number
+ *              with nsfs of current task, or if dev conversion to dev_t lost high bits.
+ *
+ *		**-ENOENT** if pidns does not exists for the current task.
+ *
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2888,7 +2901,8 @@ union bpf_attr {
 	FN(sk_storage_delete),		\
 	FN(send_signal),		\
 	FN(tcp_gen_syncookie),		\
-	FN(skb_output),
+	FN(skb_output),			\
+	FN(get_ns_current_pid_tgid),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3639,4 +3653,8 @@ struct bpf_sockopt {
 	__s32	retval;
 };
 
+struct bpf_pidns_info {
+	__u32 pid;
+	__u32 tgid;
+};
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 673f5d40a93e..04083942a13a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2079,6 +2079,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..5477ad984d7c 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -11,6 +11,8 @@
 #include <linux/uidgid.h>
 #include <linux/filter.h>
 #include <linux/ctype.h>
+#include <linux/pid_namespace.h>
+#include <linux/proc_ns.h>
 
 #include "../../lib/kstrtox.h"
 
@@ -487,3 +489,46 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_4(bpf_get_ns_current_pid_tgid, u64, dev, u64, ino,
+	   struct bpf_pidns_info *, nsdata, u32, size)
+{
+	struct task_struct *task = current;
+	struct pid_namespace *pidns;
+	int err = -EINVAL;
+
+	if (unlikely(size != sizeof(struct bpf_pidns_info)))
+		goto clear;
+
+	if (unlikely((u64)(dev_t)dev != dev))
+		goto clear;
+
+	if (unlikely(!task))
+		goto clear;
+
+	pidns = task_active_pid_ns(task);
+	if (unlikely(!pidns)) {
+		err = -ENOENT;
+		goto clear;
+	}
+
+	if (!ns_match(&pidns->ns, (dev_t)dev, ino))
+		goto clear;
+
+	nsdata->pid = task_pid_nr_ns(task, pidns);
+	nsdata->tgid = task_tgid_nr_ns(task, pidns);
+	return 0;
+clear:
+	memset((void *)nsdata, 0, (size_t) size);
+	return err;
+}
+
+const struct bpf_func_proto bpf_get_ns_current_pid_tgid_proto = {
+	.func		= bpf_get_ns_current_pid_tgid,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+	.arg2_type	= ARG_ANYTHING,
+	.arg3_type      = ARG_PTR_TO_UNINIT_MEM,
+	.arg4_type      = ARG_CONST_SIZE,
+};
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index c3240898cc44..07f6fa354f15 100644
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

