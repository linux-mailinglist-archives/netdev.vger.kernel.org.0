Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BADC5338B33
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 12:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhCLLJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 06:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbhCLLJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 06:09:16 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DE9C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:09:16 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id l12so4577466wry.2
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 03:09:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D6lQXV61iewTKIv5i4KOkr8EKJzCNFbTLpbymYvdwHU=;
        b=RwobTaYwbQS+lj0odiENE5fNvUZZOxmZSzfVlIdeLeYumq932qYV8X2CWN5yUkPA9E
         /9Ywyr4RCRrFPvVvaSuWPWpWZyBCBxbTRIVqlsSmoCzDw0+wFRgCDdHsCEpatHBmJdqr
         GuNt7JsXwfSrhQKJr/ecX8iAGyk8r12DJqNST43JBtVAzA0Ek3mxsrZVq+GVBgpPI63L
         LGH4E1jAJofw96hVrhN4jdDaY9CCopN//3b4KRFTiw6athMIU8lwoKtx6iYJMR2Wvfsx
         j/2WvUXwTcr0YFr3vCFOVyjInwkZs2ZiRYFV6lGlc6eEKgXuvWxA2nFx9Nx8pkI7rJkO
         swkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D6lQXV61iewTKIv5i4KOkr8EKJzCNFbTLpbymYvdwHU=;
        b=EI2i9QcFhu6QsorOCJDPYhHv/NGOYVzf4X8jC3PKAzZ0Fmftp7obek9m4IX8FaGt3+
         KG8kDFsEQkicZb6BxLCXHiNG2KIdtZhf5xmn4ABadj06VX6OicH/oeofnJM1Hu3PTe2p
         Boa5GOQ6RLYXiq47589PaI/CAoKFKuQezwB/U8+h12aBATfB/9d+Gn0lthddjibL0VzI
         vcur7Odr3N4mvWKVblLE3XC5b/YBIlGFke51ubQL2MLEeR2dWFuNLHi2eYjaKp9A+bq1
         aTavWw5ClVocwJS3dCx5jY3vbm/2cYN6PA6bjQi4elBQRGGqTN0/81g0/4oBQ+RFh2CP
         fJfw==
X-Gm-Message-State: AOAM532a2Leb5zvBs/kI6ve8mon5VLpaf/IiN7EfCT/5IqocG7TFGKwh
        v5JJ0gdYK2ciShlBbHwTTl5lmg==
X-Google-Smtp-Source: ABdhPJwasaqKf97Mz2slYVBHqf9MlRKv71YKNgaCQBZJ8yUWUOzKYm82Yh5qDUGeMUpLrNePoCa74w==
X-Received: by 2002:adf:97d5:: with SMTP id t21mr13311278wrb.139.1615547355144;
        Fri, 12 Mar 2021 03:09:15 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id b65sm1833255wmh.4.2021.03.12.03.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 03:09:14 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>, netdev@vger.kernel.org
Subject: [PATCH 2/4] ptp_pch: Move 'pch_*()' prototypes to shared header
Date:   Fri, 12 Mar 2021 11:09:08 +0000
Message-Id: <20210312110910.2221265-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312110910.2221265-1-lee.jones@linaro.org>
References: <20210312110910.2221265-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/ptp/ptp_pch.c:193:6: warning: no previous prototype for ‘pch_ch_control_write’ [-Wmissing-prototypes]
 drivers/ptp/ptp_pch.c:201:5: warning: no previous prototype for ‘pch_ch_event_read’ [-Wmissing-prototypes]
 drivers/ptp/ptp_pch.c:212:6: warning: no previous prototype for ‘pch_ch_event_write’ [-Wmissing-prototypes]
 drivers/ptp/ptp_pch.c:220:5: warning: no previous prototype for ‘pch_src_uuid_lo_read’ [-Wmissing-prototypes]
 drivers/ptp/ptp_pch.c:231:5: warning: no previous prototype for ‘pch_src_uuid_hi_read’ [-Wmissing-prototypes]
 drivers/ptp/ptp_pch.c:242:5: warning: no previous prototype for ‘pch_rx_snap_read’ [-Wmissing-prototypes]
 drivers/ptp/ptp_pch.c:259:5: warning: no previous prototype for ‘pch_tx_snap_read’ [-Wmissing-prototypes]
 drivers/ptp/ptp_pch.c:300:5: warning: no previous prototype for ‘pch_set_station_address’ [-Wmissing-prototypes]

Cc: Richard Cochran <richardcochran@gmail.com> (maintainer:PTP HARDWARE CLOCK SUPPORT)
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Flavio Suligoi <f.suligoi@asem.it>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe.h   |  8 -------
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  1 +
 drivers/ptp/ptp_pch.c                         |  1 +
 include/linux/ptp_pch.h                       | 22 +++++++++++++++++++
 4 files changed, 24 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/ptp_pch.h

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
index 3ce4899a0417a..a6823c4d355d5 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h
@@ -612,14 +612,6 @@ void pch_gbe_free_tx_resources(struct pch_gbe_adapter *adapter,
 void pch_gbe_free_rx_resources(struct pch_gbe_adapter *adapter,
 			       struct pch_gbe_rx_ring *rx_ring);
 void pch_gbe_update_stats(struct pch_gbe_adapter *adapter);
-void pch_ch_control_write(struct pci_dev *pdev, u32 val);
-u32 pch_ch_event_read(struct pci_dev *pdev);
-void pch_ch_event_write(struct pci_dev *pdev, u32 val);
-u32 pch_src_uuid_lo_read(struct pci_dev *pdev);
-u32 pch_src_uuid_hi_read(struct pci_dev *pdev);
-u64 pch_rx_snap_read(struct pci_dev *pdev);
-u64 pch_tx_snap_read(struct pci_dev *pdev);
-int pch_set_station_address(u8 *addr, struct pci_dev *pdev);
 
 /* pch_gbe_param.c */
 void pch_gbe_check_options(struct pch_gbe_adapter *adapter);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 140cee7c459d0..334af49e5add1 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
 #include <linux/ptp_classify.h>
+#include <linux/ptp_pch.h>
 #include <linux/gpio.h>
 
 #define DRV_VERSION     "1.01"
diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index f7ff7230623e0..fa4417ad02e0c 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/ptp_pch.h>
 #include <linux/slab.h>
 
 #define STATION_ADDR_LEN	20
diff --git a/include/linux/ptp_pch.h b/include/linux/ptp_pch.h
new file mode 100644
index 0000000000000..51818198c2921
--- /dev/null
+++ b/include/linux/ptp_pch.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * PTP PCH
+ *
+ * Copyright 2019 Linaro Ltd.
+ *
+ * Author Lee Jones <lee.jones@linaro.org>
+ */
+
+#ifndef _PTP_PCH_H_
+#define _PTP_PCH_H_
+
+void pch_ch_control_write(struct pci_dev *pdev, u32 val);
+u32  pch_ch_event_read(struct pci_dev *pdev);
+void pch_ch_event_write(struct pci_dev *pdev, u32 val);
+u32  pch_src_uuid_lo_read(struct pci_dev *pdev);
+u32  pch_src_uuid_hi_read(struct pci_dev *pdev);
+u64  pch_rx_snap_read(struct pci_dev *pdev);
+u64  pch_tx_snap_read(struct pci_dev *pdev);
+int  pch_set_station_address(u8 *addr, struct pci_dev *pdev);
+
+#endif /* _PTP_PCH_H_ */
-- 
2.27.0

