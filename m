Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF456316EE0
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbhBJShw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:37:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2777 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbhBJSfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:35:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602427530001>; Wed, 10 Feb 2021 10:34:59 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 18:34:59 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <mst@redhat.com>,
        <jasowang@redhat.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v5 1/5] Add kernel headers
Date:   Wed, 10 Feb 2021 20:34:41 +0200
Message-ID: <20210210183445.1009795-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210183445.1009795-1-parav@nvidia.com>
References: <20210210183445.1009795-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612982100; bh=nWIJ6P32mwLsw6VZK8WXUs+f1FUPDbhQ34u3t99XSpk=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=RDrHHUXn3n3kfXvHYMFQZRvnu9uMypqB8CxlakuSwrJbPtCr04LVhpIYTNxtaauF7
         ydm5EzPLqg+058WF+VvtSpbrkpr6LbrsmVXEQp7hBn1wzSB66UezM4DNTMGqtfUCZQ
         4QlQhsI6ll8Np6PxUkC7/0fW1IvgxXo9QLtlkssrVtODc5EQN0ef8b9SeU5LQl0Iv4
         3AKcGEvcG1cga31OxMQRIdf7KvDVE3DyrTGso+405+Pxe96As60m2uQhKod3ZSVVzc
         pXVql78NxUHeJZ7Z/fgz6B1HfELAnVNDZiEMdoBfKiHzGjDeZEuXM0BAmHSMXkquUf
         YUIlOQXSuMoGQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kernel headers to commit from kernel tree [1].
  6acba4951632 ("vdpa_sim_net: Add support for user supported devices")

[1] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
changelog:
v4->v5:
 - avoided UAPI prefix in the vdpa.h header file
 - updated commit id to commit of linux-next tree
v3->v4:
 - relocated header files to vdpa/include/uapi/linux
---
 vdpa/include/uapi/linux/vdpa.h       | 40 +++++++++++++++++++
 vdpa/include/uapi/linux/virtio_ids.h | 58 ++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100644 vdpa/include/uapi/linux/vdpa.h
 create mode 100644 vdpa/include/uapi/linux/virtio_ids.h

diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.=
h
new file mode 100644
index 00000000..37ae26b6
--- /dev/null
+++ b/vdpa/include/uapi/linux/vdpa.h
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
+	/* bus name (optional) + dev name together make the parent device handle =
*/
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
diff --git a/vdpa/include/uapi/linux/virtio_ids.h b/vdpa/include/uapi/linux=
/virtio_ids.h
new file mode 100644
index 00000000..bc1c0621
--- /dev/null
+++ b/vdpa/include/uapi/linux/virtio_ids.h
@@ -0,0 +1,58 @@
+#ifndef _LINUX_VIRTIO_IDS_H
+#define _LINUX_VIRTIO_IDS_H
+/*
+ * Virtio IDs
+ *
+ * This header is BSD licensed so anyone can use the definitions to implem=
ent
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
+ *    may be used to endorse or promote products derived from this softwar=
e
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``A=
S IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURP=
OSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENT=
IAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STR=
ICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY W=
AY
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
--=20
2.26.2

