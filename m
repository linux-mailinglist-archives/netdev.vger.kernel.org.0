Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F1920C09F
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 12:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgF0KPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 06:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgF0KPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 06:15:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EB8C03E979;
        Sat, 27 Jun 2020 03:15:05 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q17so5757778pfu.8;
        Sat, 27 Jun 2020 03:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=chesPouUZaMid4bYSr3ZV53BHmtt8IXHr4Z/luYFot0=;
        b=hb2mf82EkK8Gc/tlZZRbnmdifD+vMNvAIhVu8LVGyv3Cq+t6nThGWSJFNwsoC0Ie5a
         bjb87/eRFMNdyr2/K73aJ9hxc0y8BlVQ9E4zlIzQHhbauInFUGNmVn5N82lIgbIlH1iq
         yMrNzBvtzRt+YadHXioJ2dDHajU/F+Aho83VlMRW/hYdijMqROSZlyAoOWwnAD1CEEp2
         mjX7xVHGEyjHqdr9rgQdsZ0UB+x0G3jP+a/9f6duVEsmaNEberl2A4kPIE0Vaa1zy83P
         c8mCkLr/kGbaTbke8q4+cHfcG6k4fW6AWKvryXTKaV+KBSgXNkRSWrDhb0KEknKWmQy4
         7sDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=chesPouUZaMid4bYSr3ZV53BHmtt8IXHr4Z/luYFot0=;
        b=Y5CLwLL5zvgKU3TjsA9fV6u0QaeKQp+3xROBuEnXhhxVoIAGqagsVghfTFCUgvhX9Z
         +Tecmb1FR/TDogEbkJik3wWzCmRMT8XgqD2oFm7m0IYrmd/+Gaq6UQspIkweO6rMd59y
         Fdh0zkzVcE99MlmNsNcVNQDMjjNZNkN5X30k54EO18jCL6KvJMHuihJwULzDiIteexr9
         CuIKsynDfwrBmLmD9JFvTjQDetKbtaux5tuDTCQWTTTcnvRHw7nmA2NBPTOpUohkSWYD
         mNmQuheebd8LQEtftF5YppMzzFlH+2piT96TMCxTMSDls6FlYicgANRVCzJAjdhTx06X
         bsyQ==
X-Gm-Message-State: AOAM532KFoEgTg2i+x3RAsGQwMF/lC1WIE072U/MD1IaeRn0wXBv+KN1
        uXqhjeDvv2RVA1huMmmBcbw=
X-Google-Smtp-Source: ABdhPJwf05pMgFxruixsthWrlLGcxM1bPflHihyI4UjTv/LS/QWnMvvGhW+GpTxzwnw9LR+tooU5Mw==
X-Received: by 2002:a63:2257:: with SMTP id t23mr2629871pgm.245.1593252905035;
        Sat, 27 Jun 2020 03:15:05 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id u124sm6047448pfc.161.2020.06.27.03.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 03:15:04 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     joe@perches.com, dan.carpenter@oracle.com,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/4] fix else after return or break
Date:   Sat, 27 Jun 2020 18:14:45 +0800
Message-Id: <20200627101447.167370-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200627101447.167370-1-coiby.xu@gmail.com>
References: <20200627101447.167370-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary elses after return or break.

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

