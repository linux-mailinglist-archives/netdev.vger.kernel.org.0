Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF36320A213
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405858AbgFYPgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:36:31 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC28C08C5C1;
        Thu, 25 Jun 2020 08:36:31 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y18so2952164plr.4;
        Thu, 25 Jun 2020 08:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bfgtGWX8ohA5pb3Ut9fGEq9lHt//ieN4999zfH1Y6xI=;
        b=J1WlZPcM5orSXpO4GBcx0CmYGNuymyvCL/1z3f83e4BW4ram7LvutZyEXm+Iy1cQM1
         VvCjCd878vAnRR3fGTOXkgsu1PbsX7YqSgOjv74pnRMUQ9fTcvpOSAaC174fFu0n0nHL
         dyY4CrWHgIiZ1qQwt9fAODCBGxWR5YgbWJHFqpZW5iEyDxPNwouEcrRCNBg/5yF4Gbff
         8YO+mCDxVboUKrMXb9L7+rugUqo9oAJ20qyYnxHHOuqdx+n1iK8qgtqDYxIC9TV/Z03E
         D8WlgtuNoBuDkbYhlcte4yWKajrtF8+kkwreQ/beXjuJ2W7tzKd3wKa51SgvIhPeITNu
         6azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bfgtGWX8ohA5pb3Ut9fGEq9lHt//ieN4999zfH1Y6xI=;
        b=HkzJ8fFcrp4HH8GIJv8357o0gK1DVY0TlAM/YqWDIBpTkGqFbFfChWVLG1T/v6yWgg
         ByDImrAL//r4EWPQhM06i4R6FIBqt4nmfPW7X/x4ZJh9ZI3jNGcv0SJFk0GUojTPQZWA
         BaTRqWma4OVmM2r5sIUgaXmtQdTHThVzjxplgcNRc1fHejSE2gHk3gYc3dMC4/Yy2kC1
         Ft3CUlUHPTnT4wdegbADMNEr/v1HdUECm8Apr0mBUvxQ5b5slLKwkYBFxXDmn0CYa/UK
         sUEHvZRxPqvXKKptL49H3cEN/8cQHZWccpAZ2rU46T+QttSPAQHDznuhZGwVENlnUARp
         tchQ==
X-Gm-Message-State: AOAM533s8F3zlCDtAuTgt8YUKd1eUH2InmyZYSk8yS3cAO17iNwepGkR
        vbUQ7uFpgV+UAxsvAiI/wj0=
X-Google-Smtp-Source: ABdhPJwFDKRrMmvG2CAiFZdg1UXxnMVF4PE0N9I3xhhWBAXIJrAy/vYCGSeciWyS/jr6QqegIx1LDg==
X-Received: by 2002:a17:90a:a47:: with SMTP id o65mr4129035pjo.70.1593099390950;
        Thu, 25 Jun 2020 08:36:30 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id i20sm24174151pfd.81.2020.06.25.08.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:36:30 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] fix else after return or break
Date:   Thu, 25 Jun 2020 23:36:14 +0800
Message-Id: <20200625153614.63912-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625153614.63912-1-coiby.xu@gmail.com>
References: <20200625153614.63912-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c  | 23 ++++++++++-------------
 drivers/staging/qlge/qlge_main.c |  8 ++++----
 drivers/staging/qlge/qlge_mpi.c  |  4 ++--
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 058889687907..87433510a224 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1391,12 +1391,11 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
 			pr_err("%s: Failed read of mac index register\n",
 			       __func__);
 			return;
-		} else {
-			if (value[0])
-				pr_err("%s: CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
-				       qdev->ndev->name, i, value[1], value[0],
-				       value[2]);
 		}
+		if (value[0])
+			pr_err("%s: CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
+			       qdev->ndev->name, i, value[1], value[0],
+			       value[2]);
 	}
 	for (i = 0; i < 32; i++) {
 		if (ql_get_mac_addr_reg
@@ -1404,11 +1403,10 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
 			pr_err("%s: Failed read of mac index register\n",
 			       __func__);
 			return;
-		} else {
-			if (value[0])
-				pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
-				       qdev->ndev->name, i, value[1], value[0]);
 		}
+		if (value[0])
+			pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
+			       qdev->ndev->name, i, value[1], value[0]);
 	}
 	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
 }
@@ -1427,11 +1425,10 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
 			pr_err("%s: Failed read of routing index register\n",
 			       __func__);
 			return;
-		} else {
-			if (value)
-				pr_err("%s: Routing Mask %d = 0x%.08x\n",
-				       qdev->ndev->name, i, value);
 		}
+		if (value)
+			pr_err("%s: Routing Mask %d = 0x%.08x\n",
+			       qdev->ndev->name, i, value);
 	}
 	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
 }
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index aaecf2b0f9a1..0054c454506b 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3778,10 +3778,10 @@ static int ql_wol(struct ql_adapter *qdev)
 				  "Failed to set magic packet on %s.\n",
 				  qdev->ndev->name);
 			return status;
-		} else
-			netif_info(qdev, drv, qdev->ndev,
-				   "Enabled magic packet successfully on %s.\n",
-				   qdev->ndev->name);
+		}
+		netif_info(qdev, drv, qdev->ndev,
+			   "Enabled magic packet successfully on %s.\n",
+			   qdev->ndev->name);
 
 		wol |= MB_WOL_MAGIC_PKT;
 	}
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 3bb08d290525..fa178fc642a6 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -276,8 +276,8 @@ static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init CAM/Routing tables.\n");
 			return;
-		} else
-			clear_bit(QL_CAM_RT_SET, &qdev->flags);
+		}
+		clear_bit(QL_CAM_RT_SET, &qdev->flags);
 	}
 
 	/* Queue up a worker to check the frame
-- 
2.27.0

