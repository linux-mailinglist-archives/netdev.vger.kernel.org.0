Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C5A27302B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgIURDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729152AbgIURDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:03:07 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688CEC0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 10:03:07 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a9so117240pjg.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 10:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jXNkSdIXbufBSrtHNk3ApVydjBkbhg4c2qiUUvjs6TA=;
        b=jxb0/l2DJkwrIIMjqoo53DxSC8hy/q5VtpriKmymVPGzANGz6bB85DzxhFq2v5qLaH
         n2ibFRCTPu7U8Ef0ouSfy+9qRyWim+w1uI9wg2YqOm6/IRUOd6HlIdqCWrjmdQYQvuk8
         nHw+hs/SXm4insqC8T/YMzXzPUUxpgG0v4rnybVA/haqg7iuvCcLxMb0JqVOOvS6SltS
         +M/gLeQha1FmWrHZ1+O3g3Hdg6+pSXzKRGKAwalrVqumGpK6Yz9o3v0C22dIAM2kjbiU
         XdAFuJK30akNa6ModWpnHJeECfQalzDgQNl9yuTSwOajY7EY+M+ZJFliiYhoCaJZ5cIL
         2diw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jXNkSdIXbufBSrtHNk3ApVydjBkbhg4c2qiUUvjs6TA=;
        b=RwoHTjt3dnF44Se7ubGDymTngyI8Ov9iJmO/SEf0L2P1Lu6OetTXA4dve8hCkZcWdd
         ZOAAXgWHmCAuuCA/ZJf/vINU0S+ma0VmbMPPvasVs55OGMNR2gydjB34a5+oG8q0rVcy
         yabwyRMAbPrayBpVN7T4zy6XCSQlYU07EuBJp7Uc7KjMpBF1nF6MgoAJGPYEAz59YXDs
         WrtVNVp0ZAthelbIEgkIA2NqYoWfy5nHF1WTgxlxe8gIUs78S3KcAzQlCEGl9+YRTlKC
         K+2VZNqj74ibIOWx9ZRhkrEzusWdq8BzA42IindTn9lqT5hVTykzux4xZGFrUObeu204
         5a6g==
X-Gm-Message-State: AOAM531umQZ8OqhsJhU4AFHS3FlG976qxenJdsMpqU2z7y5ykSefl7Kx
        rj+gdbM7zZ344bK/xLNpO6U=
X-Google-Smtp-Source: ABdhPJzC7d2Cldn8pTfPiJjFQX94UTY72+TSq6BP5Y0KjQxZMKQGSO1LBBsvkmcaRFdHGQWv7QpJCA==
X-Received: by 2002:a17:90a:e207:: with SMTP id a7mr283483pjz.117.1600707787002;
        Mon, 21 Sep 2020 10:03:07 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id z1sm8507348pgu.80.2020.09.21.10.03.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Sep 2020 10:03:06 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next v2 PATCH 2/2] octeontx2-pf: Add tracepoints for PF/VF mailbox
Date:   Mon, 21 Sep 2020 22:32:42 +0530
Message-Id: <1600707762-24422-3-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600707762-24422-1-git-send-email-sundeep.lkml@gmail.com>
References: <1600707762-24422-1-git-send-email-sundeep.lkml@gmail.com>
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

