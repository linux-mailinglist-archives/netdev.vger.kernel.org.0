Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8750A3D24D4
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhGVNGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:06:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4506 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231925AbhGVNGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:06:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MDkX6e026150;
        Thu, 22 Jul 2021 06:47:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=+eqMGYBVdJOxU4+iETZGUjH9mWNPoLXvNsQYswa0TKo=;
 b=QRoTSXU0B//wh9jp+vX/Hxef59YvvZYzNQ+78hhnB6/pSMFhrnl0ISrjsrMJKin2ab9J
 g8h4/cTKNvFz3usEAi0dKbC5rsG/9604IjEHPzcyfD8cJhAHYyb+9CrhOlWkc4tSvwyW
 YFlhy++7Ow6TROTkLiMJkXHS2nPry0AWjua1skaPKUjTRMkLOVq8BByCPtRORNtGmAtj
 MDG1CJRCEVJumxKaKGGnY0yexMTxH6xxajy9h+38j8g0/Er3OE4hx4v5qBNaE5ViO3aP
 W48i5gilPY83iYRfwzCDW0tvIpAfu0zzX2d6B7eNL63w6l3NKQSsjZJxnasXeku8onAf hA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 39y25bhq8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 06:47:25 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 22 Jul
 2021 06:47:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 22 Jul 2021 06:47:23 -0700
Received: from jerin-lab.marvell.com (jerin-lab.marvell.com [10.28.34.14])
        by maili.marvell.com (Postfix) with ESMTP id ECA213F7082;
        Thu, 22 Jul 2021 06:47:20 -0700 (PDT)
From:   <jerinj@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     <jerinjacobk@gmail.com>
Subject: [PATCH net-next v1] octeontx2-af: Enhance mailbox trace entry
Date:   Thu, 22 Jul 2021 19:15:40 +0530
Message-ID: <20210722134540.644370-1-jerinj@marvell.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: W2IJMvYWXjV6z1K1UyJjrIexTBmtqBZD
X-Proofpoint-GUID: W2IJMvYWXjV6z1K1UyJjrIexTBmtqBZD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_07:2021-07-22,2021-07-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Added mailbox id to name translation on trace entry for
better tracing output.

Before the change:
otx2_msg_process: [0002:01:00.0] msg:(0x03) error:0

After the change:
otx2_msg_process: [0002:01:00.0] msg:(DETACH_RESOURCES) error:0

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
index 64aa7d350df1..6af97ce69443 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
@@ -14,6 +14,8 @@
 #include <linux/tracepoint.h>
 #include <linux/pci.h>
 
+#include "mbox.h"
+
 TRACE_EVENT(otx2_msg_alloc,
 	    TP_PROTO(const struct pci_dev *pdev, u16 id, u64 size),
 	    TP_ARGS(pdev, id, size),
@@ -25,8 +27,8 @@ TRACE_EVENT(otx2_msg_alloc,
 			   __entry->id = id;
 			   __entry->size = size;
 	    ),
-	    TP_printk("[%s] msg:(0x%x) size:%lld\n", __get_str(dev),
-		      __entry->id, __entry->size)
+	    TP_printk("[%s] msg:(%s) size:%lld\n", __get_str(dev),
+		      otx2_mbox_id2name(__entry->id), __entry->size)
 );
 
 TRACE_EVENT(otx2_msg_send,
@@ -88,8 +90,8 @@ TRACE_EVENT(otx2_msg_process,
 			   __entry->id = id;
 			   __entry->err = err;
 	    ),
-	    TP_printk("[%s] msg:(0x%x) error:%d\n", __get_str(dev),
-		      __entry->id, __entry->err)
+	    TP_printk("[%s] msg:(%s) error:%d\n", __get_str(dev),
+		      otx2_mbox_id2name(__entry->id), __entry->err)
 );
 
 #endif /* __RVU_TRACE_H */
-- 
2.32.0

