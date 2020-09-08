Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E392608EA
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgIHDJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728241AbgIHDJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 23:09:10 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D116BC061573;
        Mon,  7 Sep 2020 20:09:09 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h4so15585669ioe.5;
        Mon, 07 Sep 2020 20:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rBq6L8j6VXoV9kBXKeeyWs5lIar9dvrGK6LriY/bemU=;
        b=dgcbDcv5+Wc8PKQMo1siPE6CbXStP0BwfrR3dBoESevR1ySVkrfGJvRsAK6WxudbMs
         tJrDc9XJUj+U2fFKE0uveTXwu9LvvdlYUTY9g3WDwcwxrEnRCthG2lDvCJ+gEs1fVrfi
         zaFY0JUHbduPQ42Yo01YyL0Na6laN6swR3y+O/lsZBuuTfdMXD+78rZFEtBLWx1bgqF5
         zPwhQH1DIT/mv1vKN/2o/h2U5QSDUzEEjI6kgMkzvDqsxtzNB3p9Xkk+36/Kt4D8wvxa
         qSyD34CaT04MW9CjnwvqqZl1iBPmV6s+dEI8kr4KF5roOQu4Wf0Koe718rpIYHPlq0Hd
         EAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rBq6L8j6VXoV9kBXKeeyWs5lIar9dvrGK6LriY/bemU=;
        b=ciZPIFOPqn0NYL8TawDRVUcjs+YiIywm+20IpBOfQkgI4q+BhO99Sl6hBqq/yu+9IC
         tumlE7sYxhkER8gHjVizrW2s4No0A3Zq+4gO7q4vq0ctfRX6tHNwC77JSUKj6liqYda0
         ZNZ7N1o997xPZtpv+4+ha2Y/eXT0hqzqmwyrDBxdZzuoIT9wQAiOoUQ6IQNi66JIlVia
         ReIJPw1EnZ8Q1CgMgphnipTu69uK5b5CLHcLF30kKqI+zT1+ZB1twUmxn0BZIpPdOcdT
         gQej0HfZcW/is/xT8OBQjZh2sZ+OkAXmrAAdl39/xuZQUPW1aorRj1jnFXkC0hG3dCsG
         60iQ==
X-Gm-Message-State: AOAM533IdES/rnM0Bpbu/xvqxUf0KeMszI/5nMRuZjoU6MuNQwqajOBw
        e+YQUwAmyuHL0sOZ+SaOOoeUgCV1TS8=
X-Google-Smtp-Source: ABdhPJzCd21arCbtl6Ci687epIwl9O9Ql/OkCtD7cuxgSfMkxemjdGkFrNnMRt7Oito4GFPrl3DorQ==
X-Received: by 2002:a02:8791:: with SMTP id t17mr21129203jai.89.1599534549063;
        Mon, 07 Sep 2020 20:09:09 -0700 (PDT)
Received: from localhost.localdomain (c-73-242-81-227.hsd1.mn.comcast.net. [73.242.81.227])
        by smtp.gmail.com with ESMTPSA id b8sm7923367ioa.33.2020.09.07.20.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 20:09:08 -0700 (PDT)
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org
Cc:     netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ross Schmidt <ross.schm.dev@gmail.com>
Subject: [PATCH] staging: qlge: fix quoted string split across lines
Date:   Mon,  7 Sep 2020 22:07:57 -0500
Message-Id: <20200908030757.101278-1-ross.schm.dev@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed a coding style issue by merging split quoted strings in qlge_main.c
to fix checkpatch warnings.

Signed-off-by: Ross Schmidt <ross.schm.dev@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 2028458bea6f..e4c9f5d3bfdd 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2079,9 +2079,9 @@ static void ql_process_chip_ae_intr(struct ql_adapter *qdev,
 		break;
 
 	case PCI_ERR_ANON_BUF_RD:
-		netdev_err(qdev->ndev, "PCI error occurred when reading "
-					"anonymous buffers from rx_ring %d.\n",
-					ib_ae_rsp->q_id);
+		netdev_err(qdev->ndev,
+			   "PCI error occurred when reading anonymous buffers from rx_ring %d.\n",
+			   ib_ae_rsp->q_id);
 		ql_queue_asic_error(qdev);
 		break;
 
@@ -2415,8 +2415,7 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 		ql_queue_asic_error(qdev);
 		netdev_err(qdev->ndev, "Got fatal error, STS = %x.\n", var);
 		var = ql_read32(qdev, ERR_STS);
-		netdev_err(qdev->ndev, "Resetting chip. "
-					"Error Status Register = 0x%x\n", var);
+		netdev_err(qdev->ndev, "Resetting chip. Error Status Register = 0x%x\n", var);
 		return IRQ_HANDLED;
 	}
 
@@ -3739,8 +3738,7 @@ static void ql_display_dev_info(struct net_device *ndev)
 	struct ql_adapter *qdev = netdev_priv(ndev);
 
 	netif_info(qdev, probe, qdev->ndev,
-		   "Function #%d, Port %d, NIC Roll %d, NIC Rev = %d, "
-		   "XG Roll = %d, XG Rev = %d.\n",
+		   "Function #%d, Port %d, NIC Roll %d, NIC Rev = %d, XG Roll = %d, XG Rev = %d.\n",
 		   qdev->func,
 		   qdev->port,
 		   qdev->chip_rev_id & 0x0000000f,
-- 
2.26.2

