Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60B95932F1
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiHOQVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 12:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbiHOQUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 12:20:46 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3BB1EED7
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:20:42 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id q6-20020a05683033c600b0061d2f64df5dso5755655ott.13
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=U3OK8Oqnf2K0vdWXT1jn4LVlcHC3Qy4QXRttGxzPtuo=;
        b=XU3mICcICTtNu7uN8K5AA/UUF9eGokgmjP4mS51xOSo4TbR6mIgICfjf3JleWSCsnD
         3bKxTlmLlhl3CdsgdqLQhB63ngHK/3WAjkc9apGYatsqocuIO2tLcXn8aGkf/AKiaTLs
         sTT1sq/iMyXBWFfe2c4PBoNmB/mESTtAqL4LQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=U3OK8Oqnf2K0vdWXT1jn4LVlcHC3Qy4QXRttGxzPtuo=;
        b=lIdE5xysmArbarhSWNHqolucbLumh32iqzOnM9I8lUEyiJ0najjA8cEUwm+wad7t/g
         BgIkFX0jmykcQAZCgVcsP6bEUAKfuG9bb4liyB0ggHPEq9KmV7TrPIugA6Gb9KQ6QoKZ
         UZmwpmsOprrO1Cc223ZWb53aLIo8iVFJR3dQgGfXF9Yani3CnvhjfZatY8mJyjE1gUFA
         CIf8TR6PS782rBYELHLnNIpcTAPu00rOouTcfCQKC4yfETRlbcjkOdCWgQnwxZ1Et+C0
         9R8QrgenmaGqDrb57H9CwKTuiADfRNp8UeX/XrHiqMkxh3C9yAYyrBzaSicx6GtazDQh
         3zfw==
X-Gm-Message-State: ACgBeo15GypTJ3CgAEu1I8sE2B7cQTrBHG67QWZCUphDUURxC9w9ldeq
        Xh5nmpBhK1Kq9yrE1oyOwzqv4w==
X-Google-Smtp-Source: AA6agR4zqUyCOz7UeYx3gb/1BVfk3brb7qMNS9yuuT17I/dl5o+tdGlomKfd9D9Qo+BAH1l8rlRK4A==
X-Received: by 2002:a05:6830:10c9:b0:636:d88f:1299 with SMTP id z9-20020a05683010c900b00636d88f1299mr6217405oto.134.1660580441763;
        Mon, 15 Aug 2022 09:20:41 -0700 (PDT)
Received: from localhost.localdomain ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id x91-20020a9d37e4000000b00636ee04e7aesm2163371otb.67.2022.08.15.09.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 09:20:41 -0700 (PDT)
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
Subject: [PATCH v5 4/4] selinux: Implement userns_create hook
Date:   Mon, 15 Aug 2022 11:20:28 -0500
Message-Id: <20220815162028.926858-5-fred@cloudflare.com>
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

Unprivileged user namespace creation is an intended feature to enable
sandboxing, however this feature is often used to as an initial step to
perform a privilege escalation attack.

This patch implements a new user_namespace { create } access control
permission to restrict which domains allow or deny user namespace
creation. This is necessary for system administrators to quickly protect
their systems while waiting for vulnerability patches to be applied.

This permission can be used in the following way:

        allow domA_t domA_t : user_namespace { create };

Signed-off-by: Frederick Lawler <fred@cloudflare.com>

---
Changes since v4:
- None
Changes since v3:
- None
Changes since v2:
- Rename create_user_ns hook to userns_create
- Use user_namespace as an object opposed to a generic namespace object
- s/domB_t/domA_t in commit message
Changes since v1:
- Introduce this patch
---
 security/selinux/hooks.c            | 9 +++++++++
 security/selinux/include/classmap.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 79573504783b..b9f1078450b3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4221,6 +4221,14 @@ static void selinux_task_to_inode(struct task_struct *p,
 	spin_unlock(&isec->lock);
 }
 
+static int selinux_userns_create(const struct cred *cred)
+{
+	u32 sid = current_sid();
+
+	return avc_has_perm(&selinux_state, sid, sid, SECCLASS_USER_NAMESPACE,
+						USER_NAMESPACE__CREATE, NULL);
+}
+
 /* Returns error only if unable to parse addresses */
 static int selinux_parse_skb_ipv4(struct sk_buff *skb,
 			struct common_audit_data *ad, u8 *proto)
@@ -7111,6 +7119,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_movememory, selinux_task_movememory),
 	LSM_HOOK_INIT(task_kill, selinux_task_kill),
 	LSM_HOOK_INIT(task_to_inode, selinux_task_to_inode),
+	LSM_HOOK_INIT(userns_create, selinux_userns_create),
 
 	LSM_HOOK_INIT(ipc_permission, selinux_ipc_permission),
 	LSM_HOOK_INIT(ipc_getsecid, selinux_ipc_getsecid),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index ff757ae5f253..0bff55bb9cde 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -254,6 +254,8 @@ const struct security_class_mapping secclass_map[] = {
 	  { COMMON_FILE_PERMS, NULL } },
 	{ "io_uring",
 	  { "override_creds", "sqpoll", NULL } },
+	{ "user_namespace",
+	  { "create", NULL } },
 	{ NULL }
   };
 
-- 
2.30.2

