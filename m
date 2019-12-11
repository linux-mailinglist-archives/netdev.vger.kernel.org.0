Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FFA11BB66
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbfLKSQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:16:12 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:38763 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731256AbfLKSPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:32 -0500
Received: by mail-yb1-f194.google.com with SMTP id l129so9394402ybf.5;
        Wed, 11 Dec 2019 10:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7I5s5+li3nljC6wHzNrZU5/96VN1MItgnWEWQ5aryAs=;
        b=BXqmIn6QWMFzu9Icv3FBMdnPbCtCO8Pr7dD8B5WVKaZrEDpRKgijDdRVLMfEGj8R/H
         N3umMOMWaXKJLjQQdlWwoKeZ1h+2uQbmmS87zBKv4SPtWdd9gPxdhkehxXWwefypiChV
         VygcHtk1fIbkdFEfDQqhKulxyXhr+BD7nTR5uYB9GcRstSe2EfsCq1rSVyYYUz8w0vFH
         ZY2hdqADYlJubFp0VqTGgvP+E9xiuUo+EKTSP8dlKBAYGVERqbDBNzpXlMUR7HE/EmkV
         eh1CWeHmf0B0pRYmiNyxAbMvE86K22mL9cbzK5VIhf70iPW/WrgS9W+jIqGzfZWp73oc
         MDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7I5s5+li3nljC6wHzNrZU5/96VN1MItgnWEWQ5aryAs=;
        b=E09OJQR+WIWlBYoFEJ7JadvNNoLtScqY8Y8814rMz53MlB9o+4QQpzDIHYOO21dD5T
         BzH6EecPy9GwLeYNEC2Qjlj+cyWPeAqP04sxu4sd1EpKK5YM8DUC3AT6tzWIpi9SLYqY
         svrA/fny608Ht04aBr+/sMqYA2EVSZl9s2Aak6xRlAJY7a1o6o25tKiKWCdZmKj568hh
         DQaQynAgxQtIN/KyNi4cztrVv9ADOLFlqW0BV62oeDeunbOpYZliSWGc3EnWjcDMQFre
         a5o7v/L0UzwKXirsa7Q3Qh+qoU/ogrc2fOxaEUSayVtI+SY5rdDB88lpgcYQUcV3FZDg
         gtkg==
X-Gm-Message-State: APjAAAUtut1s3NJjNypL6v0zJex7Zwj75N5VLjyGvIILflHaLDT1RoFN
        dWiAWR5s8ZHwYfvQyD1P3kww0I6iDaS0IQ==
X-Google-Smtp-Source: APXvYqzBFRSNG5mzR+KkwQKgqdVGULRwVYx8jwhLm9wpLnTj0bYFm/rzRSDf70+CI8mUtOJfZYrL7Q==
X-Received: by 2002:a25:b90b:: with SMTP id x11mr932114ybj.209.1576088130443;
        Wed, 11 Dec 2019 10:15:30 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id l39sm1361403ywk.36.2019.12.11.10.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:30 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/23] staging: qlge: Fix WARNING: else is not generally useful after a break or return
Date:   Wed, 11 Dec 2019 12:12:46 -0600
Message-Id: <5ddcdb4a507b29a8e2824e0839cc10f77f3cb7e5.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix WARNING: else is not generally useful after a break or return in,
qlge_dbg.c, qlge_main.c, and qlge_mpi.c

Moved everything out of the else block wothout changing any logic

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c  | 23 ++++++++++-------------
 drivers/staging/qlge/qlge_main.c | 10 ++++------
 drivers/staging/qlge/qlge_mpi.c  | 13 +++++--------
 3 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 3324f0650286..0f1e1b62662d 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1409,12 +1409,11 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
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
@@ -1422,11 +1421,10 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
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
@@ -1445,11 +1443,10 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
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
index 90509fd1d95c..c6e26a757268 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3788,14 +3788,12 @@ static int ql_wol(struct ql_adapter *qdev)
 				  "Failed to set magic packet on %s.\n",
 				  qdev->ndev->name);
 			return status;
-		} else
-			netif_info(qdev, drv, qdev->ndev,
-				   "Enabled magic packet successfully on %s.\n",
-				   qdev->ndev->name);
-
+		}
+		netif_info(qdev, drv, qdev->ndev,
+			   "Enabled magic packet successfully on %s.\n",
+			   qdev->ndev->name);
 		wol |= MB_WOL_MAGIC_PKT;
 	}
-
 	if (qdev->wol) {
 		wol |= MB_WOL_MODE_ON;
 		status = ql_mb_wol_mode(qdev, wol);
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 15c97c935618..ba8ce3506a59 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -278,9 +278,8 @@ static void ql_link_up(struct ql_adapter *qdev, struct mbox_params *mbcp)
 			netif_err(qdev, ifup, qdev->ndev,
 				  "Failed to init CAM/Routing tables.\n");
 			return;
-		} else {
-			clear_bit(QL_CAM_RT_SET, &qdev->flags);
 		}
+		clear_bit(QL_CAM_RT_SET, &qdev->flags);
 	}
 
 	/* Queue up a worker to check the frame
@@ -940,13 +939,11 @@ static int ql_idc_wait(struct ql_adapter *qdev)
 			netif_err(qdev, drv, qdev->ndev, "IDC Success.\n");
 			status = 0;
 			break;
-		} else {
-			netif_err(qdev, drv, qdev->ndev,
-				  "IDC: Invalid State 0x%.04x.\n",
-				  mbcp->mbox_out[0]);
-			status = -EIO;
-			break;
 		}
+		netif_err(qdev, drv, qdev->ndev,
+			  "IDC: Invalid State 0x%.04x.\n", mbcp->mbox_out[0]);
+		status = -EIO;
+		break;
 	} while (wait_time);
 
 	return status;
-- 
2.20.1

