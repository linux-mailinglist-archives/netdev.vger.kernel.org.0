Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609AF2738FB
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgIVC51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIVC50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 22:57:26 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70714C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 19:57:26 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b17so759767pji.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 19:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WDmV8VJAKIJAvttSCmNaHRyW5uqI3s7Gyf3aOedLgOc=;
        b=HFgIpH3gn2lUVKR6llxTxPBWt5VURxHo/kORjGCYeQKlSKqMLCkjXoy+UCB+bAJgzj
         XgK+irnHiLUb3Y4szTIn4A6Av95KyZjPqwZu+UuNKJ6JKN3MvJbIDK6uPKn48jngabN0
         X6pU1CW0mpP/P3wS7RcmjIRpXJHOiuTml2b4Cc2fYTX4r7lvGwiSHgCcb8Hkubzb3qsN
         ovnIvo7fqQdnBkEJVicrLLGbs6439Q4H9jngJVjzak2k9PRoOG5Shr9jGbOnbS0W5pFN
         s3yeyujywIfKRn9QancFBEiUS+rzdKMPVF81gJ7XKACrkJpInGqZAViNXRjYWpdZPdlu
         Rhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WDmV8VJAKIJAvttSCmNaHRyW5uqI3s7Gyf3aOedLgOc=;
        b=eJHnH8yr3s8E6nRSBUFAPse3EYJwi9H8T+sjICj6HalRA+nn2qV3uwVPI94svUuUj5
         ijIvlCmKRr1Xt0kJNxRz5Hk6Tz26Un9ARV8m7x+VbKR8Xz/g8RwPS9Ar4xAyiuMrzQiX
         XOxX0Vxl4hcAtSmGV8KtQ3c79acPJF5i4OEM4Vf0EgBb23VADrEmP/NeACu0xsMogLNH
         PQmpNyfTbE5OHm+KOnFGV5MdhUN+o4hSItTLsG/cLBWlnwmze3VIV2jmf1R3nQ3PTW3b
         t6+LNDmZWJIVS/oOLCbaXoIUTfDNwQsuCm9YBDXQ+1x0GLwaSRjxPfGbnPbsxVZaRpZD
         mFpQ==
X-Gm-Message-State: AOAM533FTgaJ4L68c6JyrDAKHddyFx/t8maQjtXmu2pkFZxoKmhmCGag
        7pNdVV1aznRdLJENUamY/ww=
X-Google-Smtp-Source: ABdhPJyhckjsIRhzn2To4WgZiHL0pnfnnZShu8jS/fPVzd6A1Mxe3YJVO0KeeOS0xZXq+yv5ih2vbg==
X-Received: by 2002:a17:90a:414e:: with SMTP id m14mr1856408pjg.186.1600743445883;
        Mon, 21 Sep 2020 19:57:25 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id 64sm13425349pfg.98.2020.09.21.19.57.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2020 19:57:25 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com
Cc:     jiri@resnulli.us, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next v3 PATCH 1/2] octeontx2-af: Introduce tracepoints for mailbox
Date:   Tue, 22 Sep 2020 08:27:04 +0530
Message-Id: <1600743425-7851-2-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600743425-7851-1-git-send-email-sundeep.lkml@gmail.com>
References: <1600743425-7851-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

Added tracepoints in mailbox code so that
the mailbox operations like message allocation,
sending message and message interrupts are traced.
Also the mailbox errors occurred like timeout
or wrong responses are traced.
These will help in debugging mailbox issues.

Here's an example output showing one of the mailbox
messages sent by PF to AF and AF responding to it:

~# mount -t tracefs none /sys/kernel/tracing/
~# echo 1 > /sys/kernel/tracing/events/rvu/enable
~# ifconfig eth0 up
~# cat /sys/kernel/tracing/trace

~# cat /sys/kernel/tracing/trace
 tracer: nop

		      _-----=> irqs-off
		     / _----=> need-resched
		    | / _---=> hardirq/softirq
		    || / _--=> preempt-depth
		    ||| /     delay
   TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
      | |       |   ||||       |         |
ifconfig-2382  [002] ....   756.161892: otx2_msg_alloc: [0002:02:00.0] msg:(0x400) size:40

ifconfig-2382  [002] ...1   756.161895: otx2_msg_send: [0002:02:00.0] sent 1 msg(s) of size:48

 <idle>-0     [000] d.h1   756.161902: otx2_msg_interrupt: [0002:01:00.0] mbox interrupt PF(s) to AF (0x2)

kworker/u49:0-1165  [000] ....   756.162049: otx2_msg_process: [0002:01:00.0] msg:(0x400) error:0

kworker/u49:0-1165  [000] ...1   756.162051: otx2_msg_send: [0002:01:00.0] sent 1 msg(s) of size:32

kworker/u49:0-1165  [000] d.h.   756.162056: otx2_msg_interrupt: [0002:02:00.0] mbox interrupt AF to PF (0x1)

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |  11 ++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   7 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.c  |  12 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.h  | 103 +++++++++++++++++++++
 6 files changed, 136 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 0bc2410..2f7a861 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -3,9 +3,10 @@
 # Makefile for Marvell's OcteonTX2 RVU Admin Function driver
 #
 
+ccflags-y += -I$(src)
 obj-$(CONFIG_OCTEONTX2_MBOX) += octeontx2_mbox.o
 obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
 
-octeontx2_mbox-y := mbox.o
+octeontx2_mbox-y := mbox.o rvu_trace.o
 octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
index 387e33f..4b4cf7d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.c
@@ -14,6 +14,7 @@
 
 #include "rvu_reg.h"
 #include "mbox.h"
+#include "rvu_trace.h"
 
 static const u16 msgs_offset = ALIGN(sizeof(struct mbox_hdr), MBOX_MSG_ALIGN);
 
@@ -199,6 +200,9 @@ void otx2_mbox_msg_send(struct otx2_mbox *mbox, int devid)
 	 */
 	tx_hdr->num_msgs = mdev->num_msgs;
 	rx_hdr->num_msgs = 0;
+
+	trace_otx2_msg_send(mbox->pdev, tx_hdr->num_msgs, tx_hdr->msg_size);
+
 	spin_unlock(&mdev->mbox_lock);
 
 	/* The interrupt should be fired after num_msgs is written
@@ -295,10 +299,15 @@ int otx2_mbox_check_rsp_msgs(struct otx2_mbox *mbox, int devid)
 		struct mbox_msghdr *preq = mdev->mbase + ireq;
 		struct mbox_msghdr *prsp = mdev->mbase + irsp;
 
-		if (preq->id != prsp->id)
+		if (preq->id != prsp->id) {
+			trace_otx2_msg_check(mbox->pdev, preq->id,
+					     prsp->id, prsp->rc);
 			goto exit;
+		}
 		if (prsp->rc) {
 			rc = prsp->rc;
+			trace_otx2_msg_check(mbox->pdev, preq->id,
+					     prsp->id, prsp->rc);
 			goto exit;
 		}
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index c3ef73a..e1f9189 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -20,6 +20,8 @@
 #include "rvu_reg.h"
 #include "ptp.h"
 
+#include "rvu_trace.h"
+
 #define DRV_NAME	"octeontx2-af"
 #define DRV_STRING      "Marvell OcteonTX2 RVU Admin Function Driver"
 
@@ -1549,6 +1551,7 @@ static int rvu_process_mbox_msg(struct otx2_mbox *mbox, int devid,
 		if (rsp && err)						\
 			rsp->hdr.rc = err;				\
 									\
+		trace_otx2_msg_process(mbox->pdev, _id, err);		\
 		return rsp ? err : -ENOMEM;				\
 	}
 MBOX_MESSAGES
@@ -1881,6 +1884,8 @@ static irqreturn_t rvu_mbox_intr_handler(int irq, void *rvu_irq)
 	intr = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT);
 	/* Clear interrupts */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT, intr);
+	if (intr)
+		trace_otx2_msg_interrupt(rvu->pdev, "PF(s) to AF", intr);
 
 	/* Sync with mbox memory region */
 	rmb();
@@ -1898,6 +1903,8 @@ static irqreturn_t rvu_mbox_intr_handler(int irq, void *rvu_irq)
 
 	intr = rvupf_read64(rvu, RVU_PF_VFPF_MBOX_INTX(0));
 	rvupf_write64(rvu, RVU_PF_VFPF_MBOX_INTX(0), intr);
+	if (intr)
+		trace_otx2_msg_interrupt(rvu->pdev, "VF(s) to AF", intr);
 
 	rvu_queue_work(&rvu->afvf_wq_info, 0, vfs, intr);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index fe3389c..fa9152f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -15,6 +15,7 @@
 #include "rvu.h"
 #include "cgx.h"
 #include "rvu_reg.h"
+#include "rvu_trace.h"
 
 struct cgx_evq_entry {
 	struct list_head evq_node;
@@ -34,6 +35,7 @@ static struct _req_type __maybe_unused					\
 		return NULL;						\
 	req->hdr.sig = OTX2_MBOX_REQ_SIG;				\
 	req->hdr.id = _id;						\
+	trace_otx2_msg_alloc(rvu->pdev, _id, sizeof(*req));		\
 	return req;							\
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
new file mode 100644
index 0000000..56f90cf
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Admin Function driver tracepoints
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#define CREATE_TRACE_POINTS
+#include "rvu_trace.h"
+
+EXPORT_TRACEPOINT_SYMBOL(otx2_msg_alloc);
+EXPORT_TRACEPOINT_SYMBOL(otx2_msg_interrupt);
+EXPORT_TRACEPOINT_SYMBOL(otx2_msg_process);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
new file mode 100644
index 0000000..e660906
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell OcteonTx2 RVU Admin Function driver tracepoints
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM rvu
+
+#if !defined(__RVU_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __RVU_TRACE_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+#include <linux/pci.h>
+
+TRACE_EVENT(otx2_msg_alloc,
+	    TP_PROTO(const struct pci_dev *pdev, u16 id, u64 size),
+	    TP_ARGS(pdev, id, size),
+	    TP_STRUCT__entry(__string(dev, pci_name(pdev))
+			     __field(u16, id)
+			     __field(u64, size)
+	    ),
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+			   __entry->id = id;
+			   __entry->size = size;
+	    ),
+	    TP_printk("[%s] msg:(0x%x) size:%lld\n", __get_str(dev),
+		      __entry->id, __entry->size)
+);
+
+TRACE_EVENT(otx2_msg_send,
+	    TP_PROTO(const struct pci_dev *pdev, u16 num_msgs, u64 msg_size),
+	    TP_ARGS(pdev, num_msgs, msg_size),
+	    TP_STRUCT__entry(__string(dev, pci_name(pdev))
+			     __field(u16, num_msgs)
+			     __field(u64, msg_size)
+	    ),
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+			   __entry->num_msgs = num_msgs;
+			   __entry->msg_size = msg_size;
+	    ),
+	    TP_printk("[%s] sent %d msg(s) of size:%lld\n", __get_str(dev),
+		      __entry->num_msgs, __entry->msg_size)
+);
+
+TRACE_EVENT(otx2_msg_check,
+	    TP_PROTO(const struct pci_dev *pdev, u16 reqid, u16 rspid, int rc),
+	    TP_ARGS(pdev, reqid, rspid, rc),
+	    TP_STRUCT__entry(__string(dev, pci_name(pdev))
+			     __field(u16, reqid)
+			     __field(u16, rspid)
+			     __field(int, rc)
+	    ),
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+			   __entry->reqid = reqid;
+			   __entry->rspid = rspid;
+			   __entry->rc = rc;
+	    ),
+	    TP_printk("[%s] req->id:0x%x rsp->id:0x%x resp_code:%d\n",
+		      __get_str(dev), __entry->reqid,
+		      __entry->rspid, __entry->rc)
+);
+
+TRACE_EVENT(otx2_msg_interrupt,
+	    TP_PROTO(const struct pci_dev *pdev, const char *msg, u64 intr),
+	    TP_ARGS(pdev, msg, intr),
+	    TP_STRUCT__entry(__string(dev, pci_name(pdev))
+			     __string(str, msg)
+			     __field(u64, intr)
+	    ),
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+			   __assign_str(str, msg)
+			   __entry->intr = intr;
+	    ),
+	    TP_printk("[%s] mbox interrupt %s (0x%llx)\n", __get_str(dev),
+		      __get_str(str), __entry->intr)
+);
+
+TRACE_EVENT(otx2_msg_process,
+	    TP_PROTO(const struct pci_dev *pdev, u16 id, int err),
+	    TP_ARGS(pdev, id, err),
+	    TP_STRUCT__entry(__string(dev, pci_name(pdev))
+			     __field(u16, id)
+			     __field(int, err)
+	    ),
+	    TP_fast_assign(__assign_str(dev, pci_name(pdev))
+			   __entry->id = id;
+			   __entry->err = err;
+	    ),
+	    TP_printk("[%s] msg:(0x%x) error:%d\n", __get_str(dev),
+		      __entry->id, __entry->err)
+);
+
+#endif /* __RVU_TRACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE rvu_trace
+
+#include <trace/define_trace.h>
-- 
2.7.4

