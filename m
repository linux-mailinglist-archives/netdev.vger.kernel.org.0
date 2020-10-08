Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A372B2873B8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 13:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgJHL6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 07:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbgJHL6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 07:58:37 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450A0C061755;
        Thu,  8 Oct 2020 04:58:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so4071302pgm.11;
        Thu, 08 Oct 2020 04:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bEAelpRiHustXW5V3YshgfU8vMjoeMB0xcSYBIrSiOg=;
        b=BVL0iDFtsgfWa+kE5fCunUorX2j2hf1QwPHlaCuiw2u86+MkANg93O5MEEKOpngNMx
         eThiEwVHhIIv6FnGZJGX7Lvvb0k+WdkejwQEyJ49xauJ8FxF+wj8/yZm+i/HxB+bemxd
         /T7+iqgkEPZK86JmJPMLLxN8xIrz6+5V34jv8DLgzXy8v183ZCWOOftuiwiyFjK4h6LQ
         +W59U2gWBQkrHVhltLCpPojAhfyuZAOuM1XZPQ5OW3O272oVCr7JnmZTaxFmtdmvRoxO
         Ks9o4tqD50uwvSF2B23J3No9l8IlgN2vmDPX+UoDUEykH/HPjhf9FVV6EmaT+IL+K3LN
         aIqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bEAelpRiHustXW5V3YshgfU8vMjoeMB0xcSYBIrSiOg=;
        b=LOTWZqhRGdKZk7i87O4QVyJl6tmBqiNAy2R2sdatceJqkjkvvSyskNPqjHovaDAlqZ
         c5PlZuln0pIBROD8QsbpySfLtOyxAUOfl2SSvXbk4h9/pCMD+oWyHriuBCHdxtfPbMTk
         9NMVZgzgyDbiSGh5nLuVUkOTP9j8EVRuaWg6wUeVZ9YPqot99I+oVt0d2K+e9mQFI92C
         fWj1kSPy8olbikTVskZe/turyxjrQqwQfrZrPka+KXF/OTUHjjr+T1DP626bOYacIamY
         gh/c7Hmjwk6AaNTW69C1SG4j61VbKRBDc4hscuyCkilb2jXmwJme8wDdyxdX0bUmfTRo
         Aeuw==
X-Gm-Message-State: AOAM533+BROmoJj1H1qdHrff2oHX6GjWXxwRVDjr1pQNt8WDCwwpul53
        HqLNMZnLdmftrujU//ke0xfxZO72mVrLQg==
X-Google-Smtp-Source: ABdhPJy4Od0Fv6yQ29AYh31ZIu42PWrymIyFirG6WqS8uxAyU1pjzv/mgVkI4lZehCq2L3HjZPOYQA==
X-Received: by 2002:a17:90a:8007:: with SMTP id b7mr7815533pjn.84.1602158316881;
        Thu, 08 Oct 2020 04:58:36 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id a9sm7151206pjm.40.2020.10.08.04.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 04:58:36 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 4/6] staging: qlge: remove mpi_core_to_log which sends coredump to the kernel ring buffer
Date:   Thu,  8 Oct 2020 19:58:06 +0800
Message-Id: <20201008115808.91850-5-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008115808.91850-1-coiby.xu@gmail.com>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink health could be used to get coredump. No need to send so much
data to the kernel ring buffer.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge.h         |  3 ---
 drivers/staging/qlge/qlge_dbg.c     | 11 -----------
 drivers/staging/qlge/qlge_ethtool.c |  1 -
 drivers/staging/qlge/qlge_main.c    |  2 --
 drivers/staging/qlge/qlge_mpi.c     |  6 ------
 5 files changed, 23 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 290e754450c5..0a39801be15a 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2149,7 +2149,6 @@ struct ql_adapter {
 	u32 port_init;
 	u32 link_status;
 	struct ql_mpi_coredump *mpi_coredump;
-	u32 core_is_dumped;
 	u32 link_config;
 	u32 led_config;
 	u32 max_frame_size;
@@ -2162,7 +2161,6 @@ struct ql_adapter {
 	struct delayed_work mpi_work;
 	struct delayed_work mpi_port_cfg_work;
 	struct delayed_work mpi_idc_work;
-	struct delayed_work mpi_core_to_log;
 	struct completion ide_completion;
 	const struct nic_operations *nic_ops;
 	u16 device_id;
@@ -2253,7 +2251,6 @@ int ql_write_cfg(struct ql_adapter *qdev, void *ptr, int size, u32 bit,
 void ql_queue_fw_error(struct ql_adapter *qdev);
 void ql_mpi_work(struct work_struct *work);
 void ql_mpi_reset_work(struct work_struct *work);
-void ql_mpi_core_to_log(struct work_struct *work);
 int ql_wait_reg_rdy(struct ql_adapter *qdev, u32 reg, u32 bit, u32 ebit);
 void ql_queue_asic_error(struct ql_adapter *qdev);
 void ql_set_ethtool_ops(struct net_device *ndev);
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 42fd13990f3a..989575743718 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1314,17 +1314,6 @@ void ql_get_dump(struct ql_adapter *qdev, void *buff)
 	}
 }
 
-/* Coredump to messages log file using separate worker thread */
-void ql_mpi_core_to_log(struct work_struct *work)
-{
-	struct ql_adapter *qdev =
-		container_of(work, struct ql_adapter, mpi_core_to_log.work);
-
-	print_hex_dump(KERN_DEBUG, "Core is dumping to log file!\n",
-		       DUMP_PREFIX_OFFSET, 32, 4, qdev->mpi_coredump,
-		       sizeof(*qdev->mpi_coredump), false);
-}
-
 #ifdef QL_REG_DUMP
 static void ql_dump_intr_states(struct ql_adapter *qdev)
 {
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index d44b2dae9213..eed116d8895e 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -616,7 +616,6 @@ static void ql_get_regs(struct net_device *ndev,
 	struct ql_adapter *qdev = netdev_priv(ndev);
 
 	ql_get_dump(qdev, p);
-	qdev->core_is_dumped = 0;
 	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags))
 		regs->len = sizeof(struct ql_mpi_coredump);
 	else
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 135225530e51..aaca740d46c4 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3808,7 +3808,6 @@ static void ql_cancel_all_work_sync(struct ql_adapter *qdev)
 	cancel_delayed_work_sync(&qdev->mpi_reset_work);
 	cancel_delayed_work_sync(&qdev->mpi_work);
 	cancel_delayed_work_sync(&qdev->mpi_idc_work);
-	cancel_delayed_work_sync(&qdev->mpi_core_to_log);
 	cancel_delayed_work_sync(&qdev->mpi_port_cfg_work);
 }
 
@@ -4504,7 +4503,6 @@ static int ql_init_device(struct pci_dev *pdev, struct net_device *ndev,
 	INIT_DELAYED_WORK(&qdev->mpi_work, ql_mpi_work);
 	INIT_DELAYED_WORK(&qdev->mpi_port_cfg_work, ql_mpi_port_cfg_work);
 	INIT_DELAYED_WORK(&qdev->mpi_idc_work, ql_mpi_idc_work);
-	INIT_DELAYED_WORK(&qdev->mpi_core_to_log, ql_mpi_core_to_log);
 	init_completion(&qdev->ide_completion);
 	mutex_init(&qdev->mpi_mutex);
 
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 143a886080c5..1cea24201b17 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -1269,11 +1269,5 @@ void ql_mpi_reset_work(struct work_struct *work)
 		return;
 	}
 
-	if (qdev->mpi_coredump && !ql_core_dump(qdev, qdev->mpi_coredump)) {
-		netif_err(qdev, drv, qdev->ndev, "Core is dumped!\n");
-		qdev->core_is_dumped = 1;
-		queue_delayed_work(qdev->workqueue,
-				   &qdev->mpi_core_to_log, 5 * HZ);
-	}
 	ql_soft_reset_mpi_risc(qdev);
 }
-- 
2.28.0

