Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA63D25BB7D
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 09:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbgICHSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 03:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727965AbgICHSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 03:18:37 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AEDC061245
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 00:18:36 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w7so1565808pfi.4
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 00:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jXNkSdIXbufBSrtHNk3ApVydjBkbhg4c2qiUUvjs6TA=;
        b=Lg24P8jvR2nMBBnTZ23R+rhcjGIzuFdjx5H9l/RoufRU1u/R31QrQiymOWmqsKu0o2
         DIo6rBVQqcRM/Vx34vcf4p2o9/vkjhEAx2lq993pnqbaNA3M8fqvpd1uX0Q0JM/cgKa3
         FZ3QDuL8ZultDhQVM1TdK0OMZOxOQN0X7JdJRK4YOmRjvJ02FZfRHtzgXBBYunrTtivY
         MpAKFq8P8yALNfBNQxubpscWe+6lDxxPab8NoH6RAWbYS3F6OKGOYMeQBkYyKuwvleqi
         3L0IXCzf9UTgaMwx807GOS1QcTNOw29RutOMtit1F7fCnaSrhzxW3U2C8eXslbc1Rj69
         2D6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jXNkSdIXbufBSrtHNk3ApVydjBkbhg4c2qiUUvjs6TA=;
        b=SWh1hEcnl1FEvqgSE/Gvty1tXuWIfwg2palyp/jaLkN87XcP3O70aDGoNCB4c8gZCW
         9D6JS1X8BVoUyqWrjkUyIC2mA25Cxn1iP4DA8G33XLGThjRHK7W1U++BtWMGFKwNr6FY
         o9IPPMNhqiK4l5xLh+QsrkHwWmMeCqluuWj20skQS9nKVXuJzceLOVPZXxZ194Y5MiWK
         /Rbl9Y9Jczn9AUIstoIhBR93eywlPtAPfQ4+yK+6p8UbXHwfcqLbF1T9YufOfkRrQxS9
         upQKx6ZhaktFqGatLZUeRLhkuPUeFZ0AKaW1Eg/vMXKHQVcwmua96yBJWuvoc0v7EYQl
         elYw==
X-Gm-Message-State: AOAM531UlcDibPtPSjfUIcZ6GzrQ+tj9XTQ9E+Ra6yl3O3m24xj8mKsx
        SMguqjSVHnWrsRtKH1D3zfk=
X-Google-Smtp-Source: ABdhPJyMQCOyz6I87bKPxEhH70W582ADpvX++9kd4tntIEj4IKBGFm85zmTM3pXfVM4ADeeC8dPgxQ==
X-Received: by 2002:a63:224f:: with SMTP id t15mr1892418pgm.251.1599117516525;
        Thu, 03 Sep 2020 00:18:36 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id x5sm1506266pgf.65.2020.09.03.00.18.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Sep 2020 00:18:36 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 2/2] octeontx2-pf: Add tracepoints for PF/VF mailbox
Date:   Thu,  3 Sep 2020 12:48:18 +0530
Message-Id: <1599117498-30145-3-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
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

