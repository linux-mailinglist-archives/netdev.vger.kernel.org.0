Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2692904C2
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 14:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407038AbgJPMJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 08:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394872AbgJPMJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 08:09:54 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37A9C061755;
        Fri, 16 Oct 2020 05:09:53 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 1so1184647ple.2;
        Fri, 16 Oct 2020 05:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N9pJ8NE9U6OZE83/hXiTjZTPazBXLfSq9vRHOLXIUiE=;
        b=rJZNrFypr/OT7Py8kGf6nuKwbJQFbYSLVSxGiA45yLGU6AVJ185RzHqsSSsM04V6Hk
         9i1Cpuf/VQz+mc5753U620K+h0a3WKJ92ESHZNXK6dHHgMuear3uzrGYRR4+SShWL8av
         TwE8PwnYL0ieh976b+Gxv81lGEotefwdllz8e9oEiwtlVAjyGWYwSS+82jT5+dV2BD3E
         dggHC63b993OQpUkqrj6vw08KvXfmEOvbMDqw0vygwRUxhihFO+f8YVudRvPn8jqfUSX
         +C/hXnfsiI9EEhF5WcQGHfwpDsBBzvI+JlVe2pC+MTNTb6zNULdqhl/MaeoKR9k8OE7v
         6IRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N9pJ8NE9U6OZE83/hXiTjZTPazBXLfSq9vRHOLXIUiE=;
        b=rVpQJBFBzNezmoYXS4EzhpFcopI+tmPnUAdsii+8VuHmrCDU+zxLPtKqVPUj2Qkvlo
         iM1/BedzUDP1fTkZjGG9bP0fvdG9l9Y2xmYwg5Q7AKhNg9pOUFqvVB+hEv/9+Uz9RenL
         FK2PNfran+wfQuy7auokfwBTqpsKb3LfzZSMmxccQUVAtFOHn7QWgQ8nP15k8eOWQNLU
         ekbJtJAI7z3J7EbupHxmQbcjWRYTGbke90geKVA3Lyfv5AijtnhBUi3Hv/KH19phPFXM
         UsHPmY/a9j+iksbnmJkuh64sa7HQkHcaIOdp9rnJYB4XPnKmEV0lXPa5ElojGvBfzSpH
         76Fw==
X-Gm-Message-State: AOAM531R+Zk37RC/OWU7uKf0pvNdo7VbkK3cgC0AhOkgHtLpoif8wIOs
        QvVv+8dPeAcB4vK3rWNBUxOJnpqBhLv6Ad6J
X-Google-Smtp-Source: ABdhPJxF6A0udJbEMovGYDq8sjNpL9CG53wLGcqZpcMdD2Ph3fmrB8wOdCi9hjFELyse1wOVJQFnYQ==
X-Received: by 2002:a17:90a:34ce:: with SMTP id m14mr3666180pjf.176.1602850193354;
        Fri, 16 Oct 2020 05:09:53 -0700 (PDT)
Received: from localhost ([160.16.113.140])
        by smtp.gmail.com with ESMTPSA id n203sm2889839pfd.81.2020.10.16.05.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 05:09:52 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 6/8] staging: qlge: remove mpi_core_to_log which sends coredump to the kernel ring buffer
Date:   Fri, 16 Oct 2020 19:54:05 +0800
Message-Id: <20201016115407.170821-7-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016115407.170821-1-coiby.xu@gmail.com>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink health could be used to get coredump. No need to send so much
data to the kernel ring buffer.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO           |  2 --
 drivers/staging/qlge/qlge.h         |  3 ---
 drivers/staging/qlge/qlge_dbg.c     | 11 -----------
 drivers/staging/qlge/qlge_ethtool.c |  1 -
 drivers/staging/qlge/qlge_main.c    |  2 --
 drivers/staging/qlge/qlge_mpi.c     |  6 ------
 6 files changed, 25 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 5ac55664c3e2..e68c95f47754 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -18,8 +18,6 @@
   of questionable value. In particular, qlge_dbg.c has hundreds of lines of
   code bitrotting away in ifdef land (doesn't compile since commit
   18c49b91777c ("qlge: do vlan cleanup", v3.1-rc1), 8 years ago).
-* triggering an ethtool regdump will hexdump a 176k struct to dmesg depending
-  on some module parameters.
 * the flow control implementation in firmware is buggy (sends a flood of pause
   frames, resets the link, device and driver buffer queues become
   desynchronized), disable it by default
diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 0a470f02b0c6..8552ca7433f5 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2153,7 +2153,6 @@ struct qlge_adapter {
 	u32 port_init;
 	u32 link_status;
 	struct qlge_mpi_coredump *mpi_coredump;
-	u32 core_is_dumped;
 	u32 link_config;
 	u32 led_config;
 	u32 max_frame_size;
@@ -2166,7 +2165,6 @@ struct qlge_adapter {
 	struct delayed_work mpi_work;
 	struct delayed_work mpi_port_cfg_work;
 	struct delayed_work mpi_idc_work;
-	struct delayed_work mpi_core_to_log;
 	struct completion ide_completion;
 	const struct nic_operations *nic_ops;
 	u16 device_id;
@@ -2257,7 +2255,6 @@ int qlge_write_cfg(struct qlge_adapter *qdev, void *ptr, int size, u32 bit,
 void qlge_queue_fw_error(struct qlge_adapter *qdev);
 void qlge_mpi_work(struct work_struct *work);
 void qlge_mpi_reset_work(struct work_struct *work);
-void qlge_mpi_core_to_log(struct work_struct *work);
 int qlge_wait_reg_rdy(struct qlge_adapter *qdev, u32 reg, u32 bit, u32 ebit);
 void qlge_queue_asic_error(struct qlge_adapter *qdev);
 void qlge_set_ethtool_ops(struct net_device *ndev);
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index b0d4ea071f32..5c64d6de3b30 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1313,17 +1313,6 @@ void qlge_get_dump(struct qlge_adapter *qdev, void *buff)
 	}
 }
 
-/* Coredump to messages log file using separate worker thread */
-void qlge_mpi_core_to_log(struct work_struct *work)
-{
-	struct qlge_adapter *qdev =
-		container_of(work, struct qlge_adapter, mpi_core_to_log.work);
-
-	print_hex_dump(KERN_DEBUG, "Core is dumping to log file!\n",
-		       DUMP_PREFIX_OFFSET, 32, 4, qdev->mpi_coredump,
-		       sizeof(*qdev->mpi_coredump), false);
-}
-
 #ifdef QL_REG_DUMP
 static void qlge_dump_intr_states(struct qlge_adapter *qdev)
 {
diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
index 24b079523d5c..3e911f147dfc 100644
--- a/drivers/staging/qlge/qlge_ethtool.c
+++ b/drivers/staging/qlge/qlge_ethtool.c
@@ -617,7 +617,6 @@ static void qlge_get_regs(struct net_device *ndev,
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
 	qlge_get_dump(qdev, p);
-	qdev->core_is_dumped = 0;
 	if (!test_bit(QL_FRC_COREDUMP, &qdev->flags))
 		regs->len = sizeof(struct qlge_mpi_coredump);
 	else
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index c081aa1bb43d..b138109a24a5 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3808,7 +3808,6 @@ static void qlge_cancel_all_work_sync(struct qlge_adapter *qdev)
 	cancel_delayed_work_sync(&qdev->mpi_reset_work);
 	cancel_delayed_work_sync(&qdev->mpi_work);
 	cancel_delayed_work_sync(&qdev->mpi_idc_work);
-	cancel_delayed_work_sync(&qdev->mpi_core_to_log);
 	cancel_delayed_work_sync(&qdev->mpi_port_cfg_work);
 }
 
@@ -4502,7 +4501,6 @@ static int qlge_init_device(struct pci_dev *pdev, struct qlge_adapter *qdev,
 	INIT_DELAYED_WORK(&qdev->mpi_work, qlge_mpi_work);
 	INIT_DELAYED_WORK(&qdev->mpi_port_cfg_work, qlge_mpi_port_cfg_work);
 	INIT_DELAYED_WORK(&qdev->mpi_idc_work, qlge_mpi_idc_work);
-	INIT_DELAYED_WORK(&qdev->mpi_core_to_log, qlge_mpi_core_to_log);
 	init_completion(&qdev->ide_completion);
 	mutex_init(&qdev->mpi_mutex);
 
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index e67d2f8652a3..7dd9e2de30e5 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -1269,11 +1269,5 @@ void qlge_mpi_reset_work(struct work_struct *work)
 		return;
 	}
 
-	if (qdev->mpi_coredump && !qlge_core_dump(qdev, qdev->mpi_coredump)) {
-		netif_err(qdev, drv, qdev->ndev, "Core is dumped!\n");
-		qdev->core_is_dumped = 1;
-		queue_delayed_work(qdev->workqueue,
-				   &qdev->mpi_core_to_log, 5 * HZ);
-	}
 	qlge_soft_reset_mpi_risc(qdev);
 }
-- 
2.28.0

