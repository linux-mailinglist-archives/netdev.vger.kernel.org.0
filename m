Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9E25932EA
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 18:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbiHOQUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 12:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiHOQUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 12:20:42 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ADF1D0F8
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:20:38 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11be650aaccso1249411fac.6
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=lHIcVgvWJN3OdYYSsC7RBMC65yCdGzXPq7WonvXuURg=;
        b=RvEV/vtBES4QRTvsEVNe4a5Hi5zkKvoQo4b6nwm41wBEK6GofgwjNoYoz10qjXdup+
         MvGKBgcg8caPoHTuStaUp/U5En+8Hy9TjJ4WRUDbgB47RU/ULRTbNYYa1ZoiPDqGDqeE
         ytBifsdreKSg5RvG/bMzaPl3czA5/79GcxKJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=lHIcVgvWJN3OdYYSsC7RBMC65yCdGzXPq7WonvXuURg=;
        b=y2vDMzh/3xSD/IjjzW/5dxAGwJr8PuMa7gZwDUKup48xuYjMH339YmNFXlq51iM11r
         q6gXsjnnIVe6bbLSET5tbG4uVBCIymNI/SVcSV5G5QcGzWYjE7HWHbbAxGRWygXEgdeQ
         RFaIJKIGW8x8JNcriLjEOKdi75bj++RuK8pgE7Z4tLtC2IAebRj7QFwgxASDYBmakA6i
         wdZgUEhkZFPjCg9nBUfD41p+5F+tUy3d3FzIzmbKxzJkrRK21CdwYdf2bqnem9NIfdZZ
         84aWsQFYWivqt1T5MSGAiYtgzoQp9Zy31OEXb74EfgyXw8naGBJWhw+hYzj5sICKjA3d
         pj9g==
X-Gm-Message-State: ACgBeo1c6BWuceD8wK3ilWtrz1Q3iBKlHXVIV/W1k3cV7btOcIq7YZWB
        b8+zJGBvamuz43kWvQ2pKU924Q==
X-Google-Smtp-Source: AA6agR650fvSfcKdkYWoRVUrzHcgjSsjMtiAbKZqBqqTc2hdtVBGXw6xkiFF2LwUv+jWcic87SCttg==
X-Received: by 2002:a05:6870:8984:b0:10d:d981:151f with SMTP id f4-20020a056870898400b0010dd981151fmr11077864oaq.212.1660580437137;
        Mon, 15 Aug 2022 09:20:37 -0700 (PDT)
Received: from localhost.localdomain ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id x91-20020a9d37e4000000b00636ee04e7aesm2163371otb.67.2022.08.15.09.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 09:20:36 -0700 (PDT)
From:   Frederick Lawler <fred@cloudflare.com>
To:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com,
        Frederick Lawler <fred@cloudflare.com>
Subject: [PATCH v5 1/4] security, lsm: Introduce security_create_user_ns()
Date:   Mon, 15 Aug 2022 11:20:25 -0500
Message-Id: <20220815162028.926858-2-fred@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815162028.926858-1-fred@cloudflare.com>
References: <20220815162028.926858-1-fred@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User namespaces are an effective tool to allow programs to run with
permission without requiring the need for a program to run as root. User
namespaces may also be used as a sandboxing technique. However, attackers
sometimes leverage user namespaces as an initial attack vector to perform
some exploit. [1,2,3]

While it is not the unprivileged user namespace functionality, which
causes the kernel to be exploitable, users/administrators might want to
more granularly limit or at least monitor how various processes use this
functionality, while vulnerable kernel subsystems are being patched.

Preventing user namespace already creation comes in a few of forms in
order of granularity:

        1. /proc/sys/user/max_user_namespaces sysctl
        2. Distro specific patch(es)
        3. CONFIG_USER_NS

To block a task based on its attributes, the LSM hook cred_prepare is a
decent candidate for use because it provides more granular control, and
it is called before create_user_ns():

        cred = prepare_creds()
                security_prepare_creds()
                        call_int_hook(cred_prepare, ...
        if (cred)
                create_user_ns(cred)

Since security_prepare_creds() is meant for LSMs to copy and prepare
credentials, access control is an unintended use of the hook. [4]
Further, security_prepare_creds() will always return a ENOMEM if the
hook returns any non-zero error code.

This hook also does not handle the clone3 case which requires us to
access a user space pointer to know if we're in the CLONE_NEW_USER
call path which may be subject to a TOCTTOU attack.

Lastly, cred_prepare is called in many call paths, and a targeted hook
further limits the frequency of calls which is a beneficial outcome.
Therefore introduce a new function security_create_user_ns() with an
accompanying userns_create LSM hook.

With the new userns_create hook, users will have more control over the
observability and access control over user namespace creation. Users
should expect that normal operation of user namespaces will behave as
usual, and only be impacted when controls are implemented by users or
administrators.

This hook takes the prepared creds for LSM authors to write policy
against. On success, the new namespace is applied to credentials,
otherwise an error is returned.

Links:
1. https://nvd.nist.gov/vuln/detail/CVE-2022-0492
2. https://nvd.nist.gov/vuln/detail/CVE-2022-25636
3. https://nvd.nist.gov/vuln/detail/CVE-2022-34918
4. https://lore.kernel.org/all/1c4b1c0d-12f6-6e9e-a6a3-cdce7418110c@schaufler-ca.com/

Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Frederick Lawler <fred@cloudflare.com>

---
Changes since v4:
- Update commit description
Changes since v3:
- No changes
Changes since v2:
- Rename create_user_ns hook to userns_create
Changes since v1:
- Changed commit wording
- Moved execution to be after id mapping check
- Changed signature to only accept a const struct cred *
---
 include/linux/lsm_hook_defs.h | 1 +
 include/linux/lsm_hooks.h     | 4 ++++
 include/linux/security.h      | 6 ++++++
 kernel/user_namespace.c       | 5 +++++
 security/security.c           | 5 +++++
 5 files changed, 21 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 806448173033..aa7272e83626 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -224,6 +224,7 @@ LSM_HOOK(int, -ENOSYS, task_prctl, int option, unsigned long arg2,
 	 unsigned long arg3, unsigned long arg4, unsigned long arg5)
 LSM_HOOK(void, LSM_RET_VOID, task_to_inode, struct task_struct *p,
 	 struct inode *inode)
+LSM_HOOK(int, 0, userns_create, const struct cred *cred)
 LSM_HOOK(int, 0, ipc_permission, struct kern_ipc_perm *ipcp, short flag)
 LSM_HOOK(void, LSM_RET_VOID, ipc_getsecid, struct kern_ipc_perm *ipcp,
 	 u32 *secid)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 84a0d7e02176..2e11a2a22ed1 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -806,6 +806,10 @@
  *	security attributes, e.g. for /proc/pid inodes.
  *	@p contains the task_struct for the task.
  *	@inode contains the inode structure for the inode.
+ * @userns_create:
+ *	Check permission prior to creating a new user namespace.
+ *	@cred points to prepared creds.
+ *	Return 0 if successful, otherwise < 0 error code.
  *
  * Security hooks for Netlink messaging.
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index 1bc362cb413f..767802fe9bfa 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -437,6 +437,7 @@ int security_task_kill(struct task_struct *p, struct kernel_siginfo *info,
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
+int security_create_user_ns(const struct cred *cred);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
@@ -1194,6 +1195,11 @@ static inline int security_task_prctl(int option, unsigned long arg2,
 static inline void security_task_to_inode(struct task_struct *p, struct inode *inode)
 { }
 
+static inline int security_create_user_ns(const struct cred *cred)
+{
+	return 0;
+}
+
 static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
 					  short flag)
 {
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 5481ba44a8d6..3f464bbda0e9 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -9,6 +9,7 @@
 #include <linux/highuid.h>
 #include <linux/cred.h>
 #include <linux/securebits.h>
+#include <linux/security.h>
 #include <linux/keyctl.h>
 #include <linux/key-type.h>
 #include <keys/user-type.h>
@@ -113,6 +114,10 @@ int create_user_ns(struct cred *new)
 	    !kgid_has_mapping(parent_ns, group))
 		goto fail_dec;
 
+	ret = security_create_user_ns(new);
+	if (ret < 0)
+		goto fail_dec;
+
 	ret = -ENOMEM;
 	ns = kmem_cache_zalloc(user_ns_cachep, GFP_KERNEL);
 	if (!ns)
diff --git a/security/security.c b/security/security.c
index 14d30fec8a00..1e60c4b570ec 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1909,6 +1909,11 @@ void security_task_to_inode(struct task_struct *p, struct inode *inode)
 	call_void_hook(task_to_inode, p, inode);
 }
 
+int security_create_user_ns(const struct cred *cred)
+{
+	return call_int_hook(userns_create, 0, cred);
+}
+
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
 	return call_int_hook(ipc_permission, 0, ipcp, flag);
-- 
2.30.2

