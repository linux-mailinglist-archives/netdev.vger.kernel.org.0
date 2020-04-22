Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2869C1B43EF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgDVMFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:05:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41638 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgDVMFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 08:05:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C0AF71A11D3;
        Wed, 22 Apr 2020 14:05:34 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B4F6C1A11C4;
        Wed, 22 Apr 2020 14:05:34 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 741ED202AF;
        Wed, 22 Apr 2020 14:05:34 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     brouer@redhat.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 1/5] xdp: export the DEV_MAP_BULK_SIZE macro
Date:   Wed, 22 Apr 2020 15:05:09 +0300
Message-Id: <20200422120513.6583-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422120513.6583-1-ioana.ciornei@nxp.com>
References: <20200422120513.6583-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the DEV_MAP_BULK_SIZE macro to the header file so that drivers
can directly use it as the maximum number of xdp_frames received in the
.ndo_xdp_xmit() callback.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - patch added

 include/net/xdp.h   | 2 ++
 kernel/bpf/devmap.c | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp.h b/include/net/xdp.h
index 40c6d3398458..3cc6d5d84aa4 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -181,4 +181,6 @@ bool xdp_attachment_flags_ok(struct xdp_attachment_info *info,
 void xdp_attachment_setup(struct xdp_attachment_info *info,
 			  struct netdev_bpf *bpf);
 
+#define DEV_MAP_BULK_SIZE 16
+
 #endif /* __LINUX_NET_XDP_H__ */
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 58bdca5d978a..a51d9fb7a359 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -52,7 +52,6 @@
 #define DEV_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_RDONLY | BPF_F_WRONLY)
 
-#define DEV_MAP_BULK_SIZE 16
 struct xdp_dev_bulk_queue {
 	struct xdp_frame *q[DEV_MAP_BULK_SIZE];
 	struct list_head flush_node;
-- 
2.17.1

