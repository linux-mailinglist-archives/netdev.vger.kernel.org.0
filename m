Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D94C11BB7B
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbfLKSQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:16:57 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42917 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbfLKSPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:16 -0500
Received: by mail-yb1-f195.google.com with SMTP id p137so9382249ybg.9;
        Wed, 11 Dec 2019 10:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ggr+AKX5engezExfhdC8ySYECM4dPUTKeu6ngH19AQ=;
        b=SYSEnQSHkXFv2CrX2qUTpmmHJzxW/Dx4QYpxBbxNTRF0K3PxkVr/4r1nMWIpUv1plZ
         fQbKZMY8i37JD2A+SgjyHodZg/twL/N9nQNrrUxV8JnrHa3eEfQREgXKCqu1CxkpDErY
         tI2AkDEmYJNJKnz7xRUMHfAk+VIWCPDB7VsLjJe8SdOBdPKuk3N0gzH1SbVNFvNPxp5c
         AsaIx6wsCOPXlzrUq4wWCbCzGZwh9/YtWy6K2+9PLb7XKbqJcsc9wHTR4MYvbFZ5X2Pz
         sm8vnWvaFyzuqKdmCHnKs2MiiTb1vPUSb4BgUDybs2spDIN1RB/8YfTN5fKfpJbHP5xC
         sjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ggr+AKX5engezExfhdC8ySYECM4dPUTKeu6ngH19AQ=;
        b=qMWmvA7eaHRYrqZeblCxd7UVJKMMO3L55tO3m9iH6MdyZO5BJiGwAhRRLBMsv42vgi
         udDTyg57FOQ/HYjiXgVYrz44UD5oTiSr6XhWEY5ET6WFevi8ucqmFkI4+O6gcuFFLfi6
         O/jAHUvyBNtSQenNQTo9KuaNy+o3FN+qmDkx5b/fYRL2G8kTEdpdbeqrhMa4dBTEtODJ
         Dg9s0/tjvx1E1uh84rWjFUb2VWj/F0ix3tISIYt/z/l/Ll9fgc5eSfV7Uy7KNFXeCX3B
         5uXihxT1xZubBhj6Z85HSXK33ekISPq6NQtVYHfhUuFcS2SYD+FV9J+Vf1pQcn4w2j2M
         c3vg==
X-Gm-Message-State: APjAAAX3QfGuW/lmrk8FZT6X6UyzAxETxv6icAQCB0qpe2xa9W2A3Me0
        7thJeQp9lV65sQ2vci/6R72t2V2GL1fuzg==
X-Google-Smtp-Source: APXvYqw/v53mnh/ks839I6SYLP366QTd8fXU7JQmPj1HGsXw45yrN1RegI6j8aV7uG/iGeKakaiJrA==
X-Received: by 2002:a25:db47:: with SMTP id g68mr1024543ybf.224.1576088114636;
        Wed, 11 Dec 2019 10:15:14 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id d9sm1372449ywh.55.2019.12.11.10.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:14 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/23] staging: qlge: Fix WARNING: quoted string split across lines
Date:   Wed, 11 Dec 2019 12:12:36 -0600
Message-Id: <0e1f9c5182a909bfe534f7f2d6f93c3e65862d48.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix WARNING: quoted string split across lines in the following files:

qlge_dbg.c
qlge_main.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c  | 19 +++++++++----------
 drivers/staging/qlge/qlge_main.c | 13 ++++++-------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 6b740a712943..1d4de39a2a70 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1331,16 +1331,15 @@ void ql_mpi_core_to_log(struct work_struct *work)
 		     "Core is dumping to log file!\n");
 
 	for (i = 0; i < count; i += 8) {
-		pr_err("%.08x: %.08x %.08x %.08x %.08x %.08x "
-			"%.08x %.08x %.08x\n", i,
-			tmp[i + 0],
-			tmp[i + 1],
-			tmp[i + 2],
-			tmp[i + 3],
-			tmp[i + 4],
-			tmp[i + 5],
-			tmp[i + 6],
-			tmp[i + 7]);
+		pr_err("%.08x: %.08x %.08x %.08x %.08x %.08x %.08x %.08x %.08x\n", i,
+		       tmp[i + 0],
+		       tmp[i + 1],
+		       tmp[i + 2],
+		       tmp[i + 3],
+		       tmp[i + 4],
+		       tmp[i + 5],
+		       tmp[i + 6],
+		       tmp[i + 7]);
 		msleep(5);
 	}
 }
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index f5cc235e9854..a103d491bbb1 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2095,9 +2095,9 @@ static void ql_process_chip_ae_intr(struct ql_adapter *qdev,
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
 
@@ -2428,8 +2428,8 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
 		ql_queue_asic_error(qdev);
 		netdev_err(qdev->ndev, "Got fatal error, STS = %x.\n", var);
 		var = ql_read32(qdev, ERR_STS);
-		netdev_err(qdev->ndev, "Resetting chip. "
-					"Error Status Register = 0x%x\n", var);
+		netdev_err(qdev->ndev, "Resetting chip. Error Status Register = 0x%x\n",
+			   var);
 		return IRQ_HANDLED;
 	}
 
@@ -3749,8 +3749,7 @@ static void ql_display_dev_info(struct net_device *ndev)
 	struct ql_adapter *qdev = netdev_priv(ndev);
 
 	netif_info(qdev, probe, qdev->ndev,
-		   "Function #%d, Port %d, NIC Roll %d, NIC Rev = %d, "
-		   "XG Roll = %d, XG Rev = %d.\n",
+		   "Function #%d, Port %d, NIC Roll %d, NIC Rev = %d, XG Roll = %d, XG Rev = %d.\n",
 		   qdev->func,
 		   qdev->port,
 		   qdev->chip_rev_id & 0x0000000f,
-- 
2.20.1

