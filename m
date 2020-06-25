Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1466520A7E5
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407438AbgFYV6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405083AbgFYV6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 17:58:12 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716E7C08C5C1;
        Thu, 25 Jun 2020 14:58:12 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so3401794plq.6;
        Thu, 25 Jun 2020 14:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=chesPouUZaMid4bYSr3ZV53BHmtt8IXHr4Z/luYFot0=;
        b=LuDcozJVGWZf2PPstxMq8byipniyQ1t3gGR7PzYjpfp4u6Nxn93t9kYEH07pOzGgVR
         ibwv2hoJ9dsmTvUgzQT9T+nafHvBNwAZoUpvQnzhwJ4Xyu7FSg+BMrBVJB0EK2Km3RxW
         3SQhQYdwUXyXe3iFTohWKqu6h6iP1T5eqNhNLdChrqWV1noBDGP1dEFjBou6LLXu/WdN
         wFkhuu5krNhGGBNIb9IoBX/Bl1i8BcrovlztDsupMRHdMVDeES8WzTnFtOGJDPbZKmVu
         TKxb6q2kbkaYW8ixBRNnvUK0JwXriNv4KIIqxWJooh7QO5aPY7TgDlRqgYTTihvCSZ6k
         bnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=chesPouUZaMid4bYSr3ZV53BHmtt8IXHr4Z/luYFot0=;
        b=k4XSM8avhIEHJu328qazoSo2a9HwT7yRyWdEHf717q3M8RiqjBiDNjKcOatLD64OaF
         dFDoCJMn04AloHo/LVdu/EsQRccN9fTSCPj+BKpiOoOrcZSF7OeBCZkIIVavpDB6bm8l
         7C47FikzP2vdRP/Px1J4xkE+A/Q/pr5V66ldGb5qMN42byZ0k5ofX+dT+GsANiK+sN74
         n4TDMBWOF9Xu8GDgaQ3ubDw+RKsPAi136SOtlk6fRLnBZYqXhI0J4ulpKddrSP/032vM
         tcJurNBkRp20MCEeNscIgQJmQxhVyA0ecVECR/Fmj4dVLgne2wrSouxUUnggzaEFSSLq
         icGQ==
X-Gm-Message-State: AOAM533WsPmTt48sCZ5XdYjOMtaf5hsvMp8pgEYYh/i6FWHZ+YTz4BDy
        WwwP9/Oaf1foHY0dTSFq/ok=
X-Google-Smtp-Source: ABdhPJysTnii06o5O6nWMHrrsXvWoqh0pl9EuBuE56Z795qID84QiM0QF0K3yjm6XNGTrPkrTSUtfA==
X-Received: by 2002:a17:90a:c797:: with SMTP id gn23mr29614pjb.165.1593122292080;
        Thu, 25 Jun 2020 14:58:12 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id p8sm20896840pgs.29.2020.06.25.14.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 14:58:11 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] staging: qlge: fix else after return or break
Date:   Fri, 26 Jun 2020 05:57:55 +0800
Message-Id: <20200625215755.70329-3-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625215755.70329-1-coiby.xu@gmail.com>
References: <20200625215755.70329-1-coiby.xu@gmail.com>
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

