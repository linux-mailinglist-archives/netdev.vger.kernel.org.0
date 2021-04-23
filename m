Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E292B369893
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhDWRkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbhDWRkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 13:40:51 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417DAC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 10:40:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o16so11963315plg.5
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 10:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5dCXYfm1eGoY5tlk16sQHcYV/eGb94UFjaigJW1nAyc=;
        b=R2IxoV9LzA7JFc6tWaKziOjn0l1ADMNKOYGDM3xYq9mJOHtkUbwm/eKbZi+Sp/Sxsv
         rVkEyUbx0f3X8O63VEEW6eMuUaqUEjoINhHSgmLHjkAXowRf4MPm0qOFjoeEZwBJkYEe
         d+16RRG2+j6ftzp7+VedXw8xtaE769uiKsxPAR55Fvi34tha52J6NnoFv8bK3NiPIH44
         rTospGg2cLsgTn+z79/o5noLHrPAAwQ/dEt+AV8TASfdy2lv41rYjHQO8J+3s4/1GvKU
         zzgBi3CspwF+2Uspr3N8YCnUJTo+bqBjRZKl829D32Sp02Q9DSQFP9FejQc7U6g87Ass
         jkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5dCXYfm1eGoY5tlk16sQHcYV/eGb94UFjaigJW1nAyc=;
        b=RSEuZqGoNwrsRmds0C99sH186LL6sMoV22F2nxHEFEOcYMNv1oxEot442mTz000LaB
         UBhpWm9j3SEQlF3rAsvZfjyGKWE21OWZBYyCV6/1dJplGL4zpvfzJ2JbFlwUUoS6kFum
         iZW7WYlOvHVO8qwicS9gkEcsW4pHwD/54v5yaaedgdi34JQTOKxPxocOIClYFf1LIZ8n
         MKobt9qNarIrMe+kmhb4m4aB6wykHb24RN5QXhCR0NYHh++VzdsfzYptjBn/lbXUejCB
         U4IeS5rBka4XUxlbR59JAiGYAHS7bd8lJBmE3ddVFg8Ml/dy/SC0r8HsTXVzxvARhXPb
         Rz7w==
X-Gm-Message-State: AOAM531jibxkknSrW2FHex8Un6DZPTYyefNuy7HsOMwI/QzPeeRbIfn1
        S0OzyMWnKHQ7SMZU3KuvmL+db9HudqhjIQ==
X-Google-Smtp-Source: ABdhPJwY4LoKKxI895/aUqJkM9LLjwgct3Mw92S74rpH+4QVMngv5oULt55MmCH1Nqi1XYe4z5O7pw==
X-Received: by 2002:a17:902:263:b029:ec:a39a:419b with SMTP id 90-20020a1709020263b02900eca39a419bmr4840372plc.84.1619199614297;
        Fri, 23 Apr 2021 10:40:14 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id g15sm5127687pfv.216.2021.04.23.10.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 10:40:13 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     parav@nvidia.com, Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] uapi: add missing virtio related headers
Date:   Fri, 23 Apr 2021 10:40:11 -0700
Message-Id: <20210423174011.11309-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The build of iproute2 relies on having correct copy of santized
kernel headers. The vdpa utility introduced a dependency on
the vdpa related headers, but these headers were not present
in iproute2 repo.

Fixes: c2ecc82b9d4c ("vdpa: Add vdpa tool")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/uapi/linux/vdpa.h       | 40 +++++++++++++++++++++++
 include/uapi/linux/virtio_ids.h | 58 +++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 include/uapi/linux/vdpa.h
 create mode 100644 include/uapi/linux/virtio_ids.h

diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
new file mode 100644
index 000000000000..37ae26b6ba26
--- /dev/null
+++ b/include/uapi/linux/vdpa.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * vdpa device management interface
+ * Copyright (c) 2020 Mellanox Technologies Ltd. All rights reserved.
+ */
+
+#ifndef _LINUX_VDPA_H_
+#define _LINUX_VDPA_H_
+
+#define VDPA_GENL_NAME "vdpa"
+#define VDPA_GENL_VERSION 0x1
+
+enum vdpa_command {
+	VDPA_CMD_UNSPEC,
+	VDPA_CMD_MGMTDEV_NEW,
+	VDPA_CMD_MGMTDEV_GET,		/* can dump */
+	VDPA_CMD_DEV_NEW,
+	VDPA_CMD_DEV_DEL,
+	VDPA_CMD_DEV_GET,		/* can dump */
+};
+
+enum vdpa_attr {
+	VDPA_ATTR_UNSPEC,
+
+	/* bus name (optional) + dev name together make the parent device handle */
+	VDPA_ATTR_MGMTDEV_BUS_NAME,		/* string */
+	VDPA_ATTR_MGMTDEV_DEV_NAME,		/* string */
+	VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES,	/* u64 */
+
+	VDPA_ATTR_DEV_NAME,			/* string */
+	VDPA_ATTR_DEV_ID,			/* u32 */
+	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
+	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
+	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
+
+	/* new attributes must be added above here */
+	VDPA_ATTR_MAX,
+};
+
+#endif
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
new file mode 100644
index 000000000000..bc1c0621f5ed
--- /dev/null
+++ b/include/uapi/linux/virtio_ids.h
@@ -0,0 +1,58 @@
+#ifndef _LINUX_VIRTIO_IDS_H
+#define _LINUX_VIRTIO_IDS_H
+/*
+ * Virtio IDs
+ *
+ * This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE. */
+
+#define VIRTIO_ID_NET			1 /* virtio net */
+#define VIRTIO_ID_BLOCK			2 /* virtio block */
+#define VIRTIO_ID_CONSOLE		3 /* virtio console */
+#define VIRTIO_ID_RNG			4 /* virtio rng */
+#define VIRTIO_ID_BALLOON		5 /* virtio balloon */
+#define VIRTIO_ID_IOMEM			6 /* virtio ioMemory */
+#define VIRTIO_ID_RPMSG			7 /* virtio remote processor messaging */
+#define VIRTIO_ID_SCSI			8 /* virtio scsi */
+#define VIRTIO_ID_9P			9 /* 9p virtio console */
+#define VIRTIO_ID_MAC80211_WLAN		10 /* virtio WLAN MAC */
+#define VIRTIO_ID_RPROC_SERIAL		11 /* virtio remoteproc serial link */
+#define VIRTIO_ID_CAIF			12 /* Virtio caif */
+#define VIRTIO_ID_MEMORY_BALLOON	13 /* virtio memory balloon */
+#define VIRTIO_ID_GPU			16 /* virtio GPU */
+#define VIRTIO_ID_CLOCK			17 /* virtio clock/timer */
+#define VIRTIO_ID_INPUT			18 /* virtio input */
+#define VIRTIO_ID_VSOCK			19 /* virtio vsock transport */
+#define VIRTIO_ID_CRYPTO		20 /* virtio crypto */
+#define VIRTIO_ID_SIGNAL_DIST		21 /* virtio signal distribution device */
+#define VIRTIO_ID_PSTORE		22 /* virtio pstore device */
+#define VIRTIO_ID_IOMMU			23 /* virtio IOMMU */
+#define VIRTIO_ID_MEM			24 /* virtio mem */
+#define VIRTIO_ID_FS			26 /* virtio filesystem */
+#define VIRTIO_ID_PMEM			27 /* virtio pmem */
+#define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
+
+#endif /* _LINUX_VIRTIO_IDS_H */
-- 
2.30.2

