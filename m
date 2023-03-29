Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C28C6CD817
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjC2LDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjC2LDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:03:46 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B3C40E4
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:03:45 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x3so61455550edb.10
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1680087824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTcU5HqVU1XgtuJ2Y8sd/OBjaB0pp67CpHcRkiVabVQ=;
        b=hp9Oqw5dPokqfYz22NTNm5CHcmPFA2qdpKFsieBHsz4KO70+K4slt8EpuWfc6ep4lp
         TYCGSsvwp0m6/9lSJ9u4U+XtDTleePGuvm92TS3wFIPH0sKpaOR+VOuBOWyaBcxhIprl
         FARrFe2ntTy9ipfwq7TB8Aks2TMPoxAFMbsBI3niPkMH2onKdvwgO+mN4vfgYTP4Sk5s
         560shzhQjKaKxTtm8+F4rijxkDlnGHGpR99TmIHlQ3334L8qfu1uZOGyBadXQSvoPu6v
         BsxD4OBg21M3czeMY3tXp5tf1EPM98Ho0kDC8lZY6x5niT/b/zLxAS7keWu0ZZTA+kz6
         8moQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680087824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gTcU5HqVU1XgtuJ2Y8sd/OBjaB0pp67CpHcRkiVabVQ=;
        b=DZjHBMG7B0GEFmDygmBuhvPivi16q8xVGsORM1MGDDxCjloELFBt/CGsDfrkmudxsJ
         KcrR4FxUeJCio5uymgsEMPRqql8R/bYiBZghtdkVpO1WM1Xv8LimEQqFahUQJ95UxlPg
         Vy81+LHgtxQII1Qb9zazSwAzdEajWARiMCbIiml/A5GC7lpSlJG8XX62PD/a3Uj5c3YW
         aKe+Xb63IX1wsy1oo0O3Y5ElZ1rfCndeRIfqf6fYz8NZswRBnB2UDPYC9bSFUoYdKsQZ
         0kcbjwULgUPLpypzqjDW5RaMnoWhMLrvBA2EigswtALPcgh5JXlf3IYjWum0QGXVSI+p
         Ddfg==
X-Gm-Message-State: AAQBX9cho/yztd/PLWt1By4oniI6lfB5B1fIanURJAh+acIK8U8yDix5
        r4Vc8/hNQnvsMm1yr0O9T56h5A==
X-Google-Smtp-Source: AKy350Z+lk0YVQodaLqvLOoFXIYHXTVciDftd4mzJAORAhetfY/MF8nRkPvYHqDZI2pPUaUQRSSdsA==
X-Received: by 2002:a17:906:4d8b:b0:92f:7c42:8631 with SMTP id s11-20020a1709064d8b00b0092f7c428631mr18787825eju.16.1680087824034;
        Wed, 29 Mar 2023 04:03:44 -0700 (PDT)
Received: from localhost.localdomain (178-133-100-41.mobile.vf-ua.net. [178.133.100.41])
        by smtp.gmail.com with ESMTPSA id md12-20020a170906ae8c00b008e68d2c11d8sm16406975ejb.218.2023.03.29.04.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 04:03:43 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com, yuri.benditovich@daynix.com
Subject: [RFC PATCH 3/5] ebpf: Added declaration/initialization routines.
Date:   Wed, 29 Mar 2023 13:45:44 +0300
Message-Id: <20230329104546.108016-4-andrew@daynix.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230329104546.108016-1-andrew@daynix.com>
References: <20230329104546.108016-1-andrew@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now, the binary objects may be retrieved by id/name.
It would require for future qmp commands that may require specific
eBPF blob.

Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
---
 ebpf/ebpf.c      | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 ebpf/ebpf.h      | 25 +++++++++++++++++++++++++
 ebpf/ebpf_rss.c  |  4 ++++
 ebpf/meson.build |  1 +
 4 files changed, 78 insertions(+)
 create mode 100644 ebpf/ebpf.c
 create mode 100644 ebpf/ebpf.h

diff --git a/ebpf/ebpf.c b/ebpf/ebpf.c
new file mode 100644
index 0000000000..86320d72f5
--- /dev/null
+++ b/ebpf/ebpf.c
@@ -0,0 +1,48 @@
+/*
+ * QEMU eBPF binary declaration routine.
+ *
+ * Developed by Daynix Computing LTD (http://www.daynix.com)
+ *
+ * Authors:
+ *  Andrew Melnychenko <andrew@daynix.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#include "qemu/osdep.h"
+#include "qemu/queue.h"
+#include "ebpf/ebpf.h"
+
+struct ElfBinaryDataEntry {
+    const char *id;
+    const void * (*fn)(size_t *);
+
+    QSLIST_ENTRY(ElfBinaryDataEntry) node;
+};
+
+static QSLIST_HEAD(, ElfBinaryDataEntry) ebpf_elf_obj_list =
+                                            QSLIST_HEAD_INITIALIZER();
+
+void ebpf_register_binary_data(const char *id, const void * (*fn)(size_t *))
+{
+    struct ElfBinaryDataEntry *data = NULL;
+
+    data = g_malloc0(sizeof(*data));
+    data->fn = fn;
+    data->id = id;
+
+    QSLIST_INSERT_HEAD(&ebpf_elf_obj_list, data, node);
+}
+
+const void *ebpf_find_binary_by_id(const char *id, size_t *sz)
+{
+    struct ElfBinaryDataEntry *it = NULL;
+    QSLIST_FOREACH(it, &ebpf_elf_obj_list, node) {
+        if (strcmp(id, it->id) == 0) {
+            return it->fn(sz);
+        }
+    }
+
+    return NULL;
+}
diff --git a/ebpf/ebpf.h b/ebpf/ebpf.h
new file mode 100644
index 0000000000..fd705cb73e
--- /dev/null
+++ b/ebpf/ebpf.h
@@ -0,0 +1,25 @@
+/*
+ * QEMU eBPF binary declaration routine.
+ *
+ * Developed by Daynix Computing LTD (http://www.daynix.com)
+ *
+ * Authors:
+ *  Andrew Melnychenko <andrew@daynix.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or
+ * later.  See the COPYING file in the top-level directory.
+ */
+
+#ifndef EBPF_H
+#define EBPF_H
+
+void ebpf_register_binary_data(const char *id, const void * (*fn)(size_t *));
+const void *ebpf_find_binary_by_id(const char *id, size_t *sz);
+
+#define ebpf_binary_init(id, fn)                                           \
+static void __attribute__((constructor)) ebpf_binary_init_ ## fn(void)     \
+{                                                                          \
+    ebpf_register_binary_data(id, fn);                                     \
+}
+
+#endif /* EBPF_H */
diff --git a/ebpf/ebpf_rss.c b/ebpf/ebpf_rss.c
index 08015fecb1..b4038725f2 100644
--- a/ebpf/ebpf_rss.c
+++ b/ebpf/ebpf_rss.c
@@ -21,6 +21,8 @@
 
 #include "ebpf/ebpf_rss.h"
 #include "ebpf/rss.bpf.skeleton.h"
+#include "ebpf/ebpf.h"
+
 #include "trace.h"
 
 void ebpf_rss_init(struct EBPFRSSContext *ctx)
@@ -237,3 +239,5 @@ void ebpf_rss_unload(struct EBPFRSSContext *ctx)
     ctx->obj = NULL;
     ctx->program_fd = -1;
 }
+
+ebpf_binary_init("rss", rss_bpf__elf_bytes)
diff --git a/ebpf/meson.build b/ebpf/meson.build
index 2dd0fd8948..67c3f53aa9 100644
--- a/ebpf/meson.build
+++ b/ebpf/meson.build
@@ -1 +1,2 @@
+softmmu_ss.add(files('ebpf.c'))
 softmmu_ss.add(when: libbpf, if_true: files('ebpf_rss.c'), if_false: files('ebpf_rss-stub.c'))
-- 
2.39.1

