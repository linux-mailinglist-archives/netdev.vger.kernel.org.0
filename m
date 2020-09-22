Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108152738FC
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 04:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgIVC5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 22:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgIVC53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 22:57:29 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68177C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 19:57:29 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id t7so780066pjd.3
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 19:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jXNkSdIXbufBSrtHNk3ApVydjBkbhg4c2qiUUvjs6TA=;
        b=nSfyqNx9JOzM694bbb1jFbbOAXiOM2zOO0HZg45Ac30annkfkSJBrK0z50QmcogZvd
         FWPIsUJx+kXizi9iLJ3TOrF6quHHCdEboasQ2mxeVO0v/T4gJK9/ip7OcXp/ytYln7Ht
         vDWLtQYf1Shi4ITuVyc19gmpUyr+lzCLfjhCsgObta/aFciyn4MkVXxY72yDb0cFHKsB
         XIixG9MdExL1BQAq+u3ugeP1GarIh5DVOMyuTjgws2Jy8zoW6Vlfb1/U5RPQeCzIbOIQ
         Ebg/jdkQHnPUlQxgYsqdd+QvwJjDPHDEm13vJjgf9fVqVxP4IZEss612YFSdocRpdAYa
         ZV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jXNkSdIXbufBSrtHNk3ApVydjBkbhg4c2qiUUvjs6TA=;
        b=dm2BbSvF4Ml25KnyvO9CCvolyP63vAIYB2QxK/M5kiv9+3p39aI7MyNS+RsTc3lSNs
         Q7T+Uak5aE2gpaabGm9pJ9sa+9HnYhYH07gc8SocLZsCv3gJ91gjMl5qdwtHaAoSZ4k+
         +88wdmjZEePHplth/K+QLIhyWvTJ2QDWvVO0AM4918MBzY2M4sEtIrwRmu0Cky9FWJi7
         nwNO+WxqHx06EWN/CYMG0I9pKsprotoldbOr17TaNAm1KqMQjOiJALIGf8pKoFYTqc7p
         1oaw9fLU2aMQ1XshHSIhejyEkBqjjexE9XyZ+X7teyH7TyAMOORihzXdc3zWFj7z2zn7
         vDSg==
X-Gm-Message-State: AOAM532fUFsdx2Hl7QoxQPGp1os3QEFdkcl4c+xXOGETDab3l6HNtC52
        wAKhSjkqA27ePjWw/o9iATs=
X-Google-Smtp-Source: ABdhPJw5O9n4Nz68So9gdOfwwob9iwHX2Ehj+ho1ZrP61Xp+qizD2L8bJ+XmRqjvkBnKCDkf/gDp8w==
X-Received: by 2002:a17:90b:3c3:: with SMTP id go3mr2141055pjb.64.1600743449009;
        Mon, 21 Sep 2020 19:57:29 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id 64sm13425349pfg.98.2020.09.21.19.57.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2020 19:57:28 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com
Cc:     jiri@resnulli.us, Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next v3 PATCH 2/2] octeontx2-pf: Add tracepoints for PF/VF mailbox
Date:   Tue, 22 Sep 2020 08:27:05 +0530
Message-Id: <1600743425-7851-3-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600743425-7851-1-git-send-email-sundeep.lkml@gmail.com>
References: <1600743425-7851-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

With tracepoints support present in the mailbox
code this patch adds tracepoints in PF and VF drivers
at places where mailbox messages are allocated,
sent and at message interrupts.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h | 2 ++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c     | 6 ++++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c     | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index ac47762..d6253f2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -20,6 +20,7 @@
 #include <mbox.h>
 #include "otx2_reg.h"
 #include "otx2_txrx.h"
+#include <rvu_trace.h>
 
 /* PCI device IDs */
 #define PCI_DEVID_OCTEONTX2_RVU_PF              0xA063
@@ -523,6 +524,7 @@ static struct _req_type __maybe_unused					\
 		return NULL;						\
 	req->hdr.sig = OTX2_MBOX_REQ_SIG;				\
 	req->hdr.id = _id;						\
+	trace_otx2_msg_alloc(mbox->mbox.pdev, _id, sizeof(*req));	\
 	return req;							\
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index aac2845..265e4d1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -22,6 +22,7 @@
 #include "otx2_txrx.h"
 #include "otx2_struct.h"
 #include "otx2_ptp.h"
+#include <rvu_trace.h>
 
 #define DRV_NAME	"octeontx2-nicpf"
 #define DRV_STRING	"Marvell OcteonTX2 NIC Physical Function Driver"
@@ -558,6 +559,8 @@ static irqreturn_t otx2_pfvf_mbox_intr_handler(int irq, void *pf_irq)
 
 	otx2_queue_work(mbox, pf->mbox_pfvf_wq, 0, vfs, intr, TYPE_PFVF);
 
+	trace_otx2_msg_interrupt(mbox->mbox.pdev, "VF(s) to PF", intr);
+
 	return IRQ_HANDLED;
 }
 
@@ -940,6 +943,9 @@ static irqreturn_t otx2_pfaf_mbox_intr_handler(int irq, void *pf_irq)
 	otx2_write64(pf, RVU_PF_INT, BIT_ULL(0));
 
 	mbox = &pf->mbox;
+
+	trace_otx2_msg_interrupt(mbox->mbox.pdev, "AF to PF", BIT_ULL(0));
+
 	otx2_queue_work(mbox, pf->mbox_wq, 0, 1, 1, TYPE_PFAF);
 
 	return IRQ_HANDLED;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 70e0d4c..32daa3e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -187,6 +187,8 @@ static irqreturn_t otx2vf_vfaf_mbox_intr_handler(int irq, void *vf_irq)
 	mdev = &mbox->dev[0];
 	otx2_sync_mbox_bbuf(mbox, 0);
 
+	trace_otx2_msg_interrupt(mbox->pdev, "PF to VF", BIT_ULL(0));
+
 	hdr = (struct mbox_hdr *)(mdev->mbase + mbox->rx_start);
 	if (hdr->num_msgs) {
 		vf->mbox.num_msgs = hdr->num_msgs;
-- 
2.7.4

