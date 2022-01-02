Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B34D482BEE
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbiABQVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbiABQVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 11:21:22 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCB2C061761;
        Sun,  2 Jan 2022 08:21:21 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id m1so27597095pfk.8;
        Sun, 02 Jan 2022 08:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FneKfEeM6t7V97+0czUOEIIjpFG+NHNOywBYdTBFn8U=;
        b=d8rvVb5aVUB1pTIgKc1H8z543k51Z2LKbeO20W3Z4HjpXQIaAna573nwuoP2ivR0EL
         dWA0NWeoolgtGm7fVeLN3Ky8thD4bjFnfZTSXSGymH3H5VtyhOEVShEOBRgZGPQso4hX
         zvnZ9XdU3TxlpK/RxrFZzJW/qnrjVidVRY77E0+tsqV+fkU+zWmvcL99oOOC0tVZ0rUD
         f0lqZzrIge9MMVYuVDhT6mipi9zeU45mzFeuLF2MXuetgCi6i5viNV3jl7UjsyPphulN
         a5DzCAZn3/cdiTVXsIEtGACzci17wRD45l80oiTCOXRRkjsWjSt0ooUWITZ3VzsrLMWU
         UwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FneKfEeM6t7V97+0czUOEIIjpFG+NHNOywBYdTBFn8U=;
        b=z7vkRL18a18yoYl9wy2VTPlC5iIhmVU6yPSc7q0zw9DON7jHQ2GRBZXLvey7b+j+Op
         yry56btRlWi9n9dyDfhmhbV5yF3Ym6+aCUCBVsmUO2410W92r9OTg1pLf8G6u/Qkvi+8
         9S3KHc2A5+i+GqzpoGF7ZmK1gRaBduuWfE8Rw8ipNbF0sKx7IfJ5z2mntEHirFsu8cnV
         mY94qnyCzV7Q6yNbt9UFcT3RtINfMLcxPEK4eY61AKuBFaii7IGOTXKnhiQZL9i6x276
         hZcqxY1RxFws2AD0Bb1V57GVujmosIVYF8AXN8j2hg/bRe7js5qlBMkfcIpFlYDTvzLV
         NY0g==
X-Gm-Message-State: AOAM533ggHdg9/5DkdN5FGGLeuKr1/+bw4+vKW55y83u+vd//+o97eOY
        NE02X6T9pu5eJSAMQpjMwAdZoce8k4o=
X-Google-Smtp-Source: ABdhPJxhLC5HZgy3skPzbcJW6m0dJ+4wOlZXhhrjj/zRu8XYzOFAUP4PW7TM84s5/+F2AiXfJyOpKQ==
X-Received: by 2002:a05:6a00:14c9:b0:4bb:68c5:b649 with SMTP id w9-20020a056a0014c900b004bb68c5b649mr43531087pfu.25.1641140481360;
        Sun, 02 Jan 2022 08:21:21 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id cx5sm33102383pjb.22.2022.01.02.08.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jan 2022 08:21:21 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v6 01/11] kernel: Implement try_module_get_live
Date:   Sun,  2 Jan 2022 21:51:05 +0530
Message-Id: <20220102162115.1506833-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220102162115.1506833-1-memxor@gmail.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3900; h=from:subject; bh=0xQJuMPHF9jAUeRRbCHR10LRMBj3BLengC9L+D9l2vg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh0dCJpKFzooU7tf/91QImFry8ZYWdj9EwitOF8zeJ IfebNjOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYdHQiQAKCRBM4MiGSL8RysKWD/ 0UCxYPovkVO+6WskDoPzJXUpeIYsU1jxycTSodueyhUQ1gyCzKDP8HlRnBrPJ14ERamRB4Mp+71308 qHgB9L9w6zmhznEBSiNnvRz98nuDUSqJKC1lELMV8R3s5/pUT8ZjMmWx8RAJuMD5H78AHjf1r32rGa dG4wl1td5iFclrwvszFzDfL1NEGancPqRUbAzH0tl3pIFt7FL2jwAH0/PxaFPe209oOMDaOP0lGps1 VdPe+Y/NqyY8re2D8RLMj9vMLQ7dkxamPQqLuVEltejNSwWlFQ9I5xyXBojre/Kl8cZVS5+y8gYo9Z SVdf7arL6xVKIsFSkRXkp6BMimhhFBb8E8PaVaDhIKP2iHM3jG1IiN8EXwSVt67baFxQTM+74kWBHY 75nDMIVKQ6bF5zdrnxdTXmwoJ1rnPKc4o58wLIToaPK0cuzWtttTQlASO2oIGXUQ5mPavEN9je6F5a C9kPYGQl85v4diiE1Vb5ZofnyDRr40BohBINBDfQPT3X6IC+dLPbTx4kiZ4NLMqZv9D/7zZ00Ac4Vj ycYvblVmq2Y70q5vxjlY6GnbmR6+Jfrhg09wHpF5XrVpDYHV42TS59bNjCbCd0K+SXb4U4j0uDPp31 lvUHUNBzuiiDoaxBXtAw2m41B0DaS0+qXSYLY1yEcjBtN5/8KEq4l0KcuU5w==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor shared functionality between strong_try_module_get and
try_module_get into a common helper, and expose try_module_get_live
that returns a bool similar to try_module_get.

It will be used in the next patch for btf_try_get_module, to eliminate a
race between module __init function invocation and module_put from BPF
side.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-modules@vger.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/module.h | 26 +++++++++++++++++++-------
 kernel/module.c        | 20 ++++++++------------
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index c9f1200b2312..eb83aaeaa76e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -608,17 +608,17 @@ void symbol_put_addr(void *addr);
 /* Sometimes we know we already have a refcount, and it's easier not
    to handle the error case (which only happens with rmmod --wait). */
 extern void __module_get(struct module *module);
-
-/* This is the Right Way to get a module: if it fails, it's being removed,
- * so pretend it's not there. */
-extern bool try_module_get(struct module *module);
-
+extern int __try_module_get(struct module *module, bool strong);
 extern void module_put(struct module *module);
 
 #else /*!CONFIG_MODULE_UNLOAD*/
-static inline bool try_module_get(struct module *module)
+static inline int __try_module_get(struct module *module, bool strong)
 {
-	return !module || module_is_live(module);
+	if (module && !module_is_live(module))
+		return -ENOENT;
+	if (strong && module && module->state == MODULE_STATE_COMING)
+		return -EBUSY;
+	return 0;
 }
 static inline void module_put(struct module *module)
 {
@@ -631,6 +631,18 @@ static inline void __module_get(struct module *module)
 
 #endif /* CONFIG_MODULE_UNLOAD */
 
+/* This is the Right Way to get a module: if it fails, it's being removed,
+ * so pretend it's not there. */
+static inline bool try_module_get(struct module *module)
+{
+	return !__try_module_get(module, false);
+}
+/* Only take reference for modules which have fully initialized */
+static inline bool try_module_get_live(struct module *module)
+{
+	return !__try_module_get(module, true);
+}
+
 /* This is a #define so the string doesn't get put in every .o file */
 #define module_name(mod)			\
 ({						\
diff --git a/kernel/module.c b/kernel/module.c
index 84a9141a5e15..a9bb0a5576c8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -318,12 +318,7 @@ EXPORT_SYMBOL(unregister_module_notifier);
 static inline int strong_try_module_get(struct module *mod)
 {
 	BUG_ON(mod && mod->state == MODULE_STATE_UNFORMED);
-	if (mod && mod->state == MODULE_STATE_COMING)
-		return -EBUSY;
-	if (try_module_get(mod))
-		return 0;
-	else
-		return -ENOENT;
+	return __try_module_get(mod, true);
 }
 
 static inline void add_taint_module(struct module *mod, unsigned flag,
@@ -1066,24 +1061,25 @@ void __module_get(struct module *module)
 }
 EXPORT_SYMBOL(__module_get);
 
-bool try_module_get(struct module *module)
+int __try_module_get(struct module *module, bool strong)
 {
-	bool ret = true;
+	int ret = 0;
 
 	if (module) {
 		preempt_disable();
+		if (strong && module->state == MODULE_STATE_COMING)
+			ret = -EBUSY;
 		/* Note: here, we can fail to get a reference */
-		if (likely(module_is_live(module) &&
+		else if (likely(module_is_live(module) &&
 			   atomic_inc_not_zero(&module->refcnt) != 0))
 			trace_module_get(module, _RET_IP_);
 		else
-			ret = false;
-
+			ret = -ENOENT;
 		preempt_enable();
 	}
 	return ret;
 }
-EXPORT_SYMBOL(try_module_get);
+EXPORT_SYMBOL(__try_module_get);
 
 void module_put(struct module *module)
 {
-- 
2.34.1

