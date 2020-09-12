Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1174267B27
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 17:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgILPBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 11:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgILOlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:41:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBEDC061757;
        Sat, 12 Sep 2020 07:41:17 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id l17so13307696edq.12;
        Sat, 12 Sep 2020 07:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VEhVokz2dg4GxsD2bpstUHaMDfLVP0RCSgNudMexTKw=;
        b=kJ5KU1U7ChAPIg3R2mzKAWabzK9+JEe9Gn1X+GTjiGB8h94n85MCySMQNqC+1DKUO2
         zFWzGpWZTQtM1cE1S9NYQyU9+GP2zj/ez1KxUjni8+mOwUXreCQudIGQVL0MpCBPYEcd
         P1vNOQk6t+YNC9yG1XoYCGDH3qiiDPvmr0N/8dLwXK3wY6YILFlT7cQi4Q2UcBpE6WRY
         VYB6YBPGN9qlyL/23hzjQ37XV5lURpu7Dw7TuUzxyrOL7kj+FgGRgsRL3/+ru1pIXSYp
         NEHWUTwkTZKECjTeNLuqDuiqIatszYsymyW2Sf39BjpBlBz8zRFekLUCH9KFhFMYl/zR
         rjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VEhVokz2dg4GxsD2bpstUHaMDfLVP0RCSgNudMexTKw=;
        b=ns/GeHlEu/ldOI5+oe+bKP8rDniY9vm53ts3mC0t7amEbl0p6/4SULv4tkwHHgLfCw
         seew9Yn6Ad+6hCW0kEq7mSPFTQxAu0xhd0ABSIp4KajKKolyFW2zZ+249ClN2MyN+gP6
         p7YPwTlU9HiGWdyS7aYntRDDNfKxs3NTRdSMJMaOanBNsJl0WIfMC55f+58dkI2U1wUL
         LR1RF/O1PvWISvSS+EkF7CT5uOfeSt3sNSts89m3hrvArpbgrlwEBHinoVxXPvjep5CG
         ZWxSKzmQrnqh7UAy4grLE2tOnTUToIGK+lP036ATn7Ep/+yF3JlV3Qfa0D6nzcCfqA0c
         f46w==
X-Gm-Message-State: AOAM533kLgMISM4sfQ99Gppr+Zl2QfgmSWCOwHvZ7BQsa2MLSn0iij+Y
        QikDvdvjW1SNtblcBMtbdONXODJess4=
X-Google-Smtp-Source: ABdhPJxYbDJSFH29rghqUpdl55vmD+ft2kDtk3ig7gnhSm1YKKFwsBe/sYwyNOTN6gXgfXkHoWLgZA==
X-Received: by 2002:a50:fc83:: with SMTP id f3mr8388719edq.256.1599921674978;
        Sat, 12 Sep 2020 07:41:14 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id y25sm4842938edv.15.2020.09.12.07.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 07:41:13 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v2 01/14] habanalabs/gaudi: add NIC H/W and registers definitions
Date:   Sat, 12 Sep 2020 17:40:53 +0300
Message-Id: <20200912144106.11799-2-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200912144106.11799-1-oded.gabbay@gmail.com>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add auto-generated header files that describe the NIC registers used by the
driver.
Add also NIC H/W definitions regarding the number of engines, number of
ports, habanalabs MAC OUI, etc

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 .../include/gaudi/asic_reg/gaudi_regs.h       |  26 +-
 .../include/gaudi/asic_reg/nic0_qm0_masks.h   | 800 +++++++++++++++++
 .../include/gaudi/asic_reg/nic0_qm0_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic0_qm1_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic0_qpc0_masks.h  | 500 +++++++++++
 .../include/gaudi/asic_reg/nic0_qpc0_regs.h   | 710 +++++++++++++++
 .../include/gaudi/asic_reg/nic0_qpc1_regs.h   | 710 +++++++++++++++
 .../include/gaudi/asic_reg/nic0_rxb_regs.h    | 508 +++++++++++
 .../include/gaudi/asic_reg/nic0_rxe0_masks.h  | 354 ++++++++
 .../include/gaudi/asic_reg/nic0_rxe0_regs.h   | 158 ++++
 .../include/gaudi/asic_reg/nic0_rxe1_regs.h   | 158 ++++
 .../include/gaudi/asic_reg/nic0_stat_regs.h   | 518 +++++++++++
 .../include/gaudi/asic_reg/nic0_tmr_regs.h    | 184 ++++
 .../include/gaudi/asic_reg/nic0_txe0_masks.h  | 336 +++++++
 .../include/gaudi/asic_reg/nic0_txe0_regs.h   | 264 ++++++
 .../include/gaudi/asic_reg/nic0_txe1_regs.h   | 264 ++++++
 .../include/gaudi/asic_reg/nic0_txs0_masks.h  | 336 +++++++
 .../include/gaudi/asic_reg/nic0_txs0_regs.h   | 214 +++++
 .../include/gaudi/asic_reg/nic0_txs1_regs.h   | 214 +++++
 .../include/gaudi/asic_reg/nic1_qm0_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic1_qm1_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic2_qm0_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic2_qm1_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic3_qm0_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic3_qm1_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic4_qm0_regs.h    | 834 ++++++++++++++++++
 .../include/gaudi/asic_reg/nic4_qm1_regs.h    | 834 ++++++++++++++++++
 drivers/misc/habanalabs/include/gaudi/gaudi.h |  12 +
 .../habanalabs/include/gaudi/gaudi_masks.h    |  15 +
 .../include/hw_ip/nic/nic_general.h           |  13 +
 30 files changed, 14633 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h

diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h
index f92dc53af074..8639fc7357a8 100644
--- a/drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/gaudi_regs.h
@@ -89,7 +89,31 @@
 #include "tpc0_cfg_masks.h"
 #include "psoc_global_conf_masks.h"
 
-#include "psoc_pci_pll_regs.h"
+#include "nic0_qm0_regs.h"
+#include "nic1_qm0_regs.h"
+#include "nic2_qm0_regs.h"
+#include "nic3_qm0_regs.h"
+#include "nic4_qm0_regs.h"
+#include "nic0_qm1_regs.h"
+#include "nic1_qm1_regs.h"
+#include "nic2_qm1_regs.h"
+#include "nic3_qm1_regs.h"
+#include "nic4_qm1_regs.h"
+#include "nic0_txs0_regs.h"
+#include "nic0_txe0_regs.h"
+#include "nic0_qpc0_regs.h"
+#include "nic0_qpc1_regs.h"
+#include "nic0_rxe0_regs.h"
+#include "nic0_rxb_regs.h"
+#include "nic0_tmr_regs.h"
+#include "nic0_stat_regs.h"
+
+#include "nic0_qm0_masks.h"
+#include "nic0_rxe0_masks.h"
+#include "nic0_qpc0_masks.h"
+#include "nic0_txs0_masks.h"
+#include "nic0_txe0_masks.h"
+
 #include "psoc_hbm_pll_regs.h"
 #include "psoc_cpu_pll_regs.h"
 
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
new file mode 100644
index 000000000000..bd37b6452133
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
@@ -0,0 +1,800 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_QM0_MASKS_H_
+#define ASIC_REG_NIC0_QM0_MASKS_H_
+
+/*
+ *****************************************
+ *   NIC0_QM0 (Prototype: QMAN)
+ *****************************************
+ */
+
+/* NIC0_QM0_GLBL_CFG0 */
+#define NIC0_QM0_GLBL_CFG0_PQF_EN_SHIFT                              0
+#define NIC0_QM0_GLBL_CFG0_PQF_EN_MASK                               0xF
+#define NIC0_QM0_GLBL_CFG0_CQF_EN_SHIFT                              4
+#define NIC0_QM0_GLBL_CFG0_CQF_EN_MASK                               0x1F0
+#define NIC0_QM0_GLBL_CFG0_CP_EN_SHIFT                               9
+#define NIC0_QM0_GLBL_CFG0_CP_EN_MASK                                0x3E00
+
+/* NIC0_QM0_GLBL_CFG1 */
+#define NIC0_QM0_GLBL_CFG1_PQF_STOP_SHIFT                            0
+#define NIC0_QM0_GLBL_CFG1_PQF_STOP_MASK                             0xF
+#define NIC0_QM0_GLBL_CFG1_CQF_STOP_SHIFT                            4
+#define NIC0_QM0_GLBL_CFG1_CQF_STOP_MASK                             0x1F0
+#define NIC0_QM0_GLBL_CFG1_CP_STOP_SHIFT                             9
+#define NIC0_QM0_GLBL_CFG1_CP_STOP_MASK                              0x3E00
+#define NIC0_QM0_GLBL_CFG1_PQF_FLUSH_SHIFT                           16
+#define NIC0_QM0_GLBL_CFG1_PQF_FLUSH_MASK                            0xF0000
+#define NIC0_QM0_GLBL_CFG1_CQF_FLUSH_SHIFT                           20
+#define NIC0_QM0_GLBL_CFG1_CQF_FLUSH_MASK                            0x1F00000
+#define NIC0_QM0_GLBL_CFG1_CP_FLUSH_SHIFT                            25
+#define NIC0_QM0_GLBL_CFG1_CP_FLUSH_MASK                             0x3E000000
+
+/* NIC0_QM0_GLBL_PROT */
+#define NIC0_QM0_GLBL_PROT_PQF_SHIFT                                 0
+#define NIC0_QM0_GLBL_PROT_PQF_MASK                                  0xF
+#define NIC0_QM0_GLBL_PROT_CQF_SHIFT                                 4
+#define NIC0_QM0_GLBL_PROT_CQF_MASK                                  0x1F0
+#define NIC0_QM0_GLBL_PROT_CP_SHIFT                                  9
+#define NIC0_QM0_GLBL_PROT_CP_MASK                                   0x3E00
+#define NIC0_QM0_GLBL_PROT_ERR_SHIFT                                 14
+#define NIC0_QM0_GLBL_PROT_ERR_MASK                                  0x4000
+#define NIC0_QM0_GLBL_PROT_ARB_SHIFT                                 15
+#define NIC0_QM0_GLBL_PROT_ARB_MASK                                  0x8000
+
+/* NIC0_QM0_GLBL_ERR_CFG */
+#define NIC0_QM0_GLBL_ERR_CFG_PQF_ERR_MSG_EN_SHIFT                   0
+#define NIC0_QM0_GLBL_ERR_CFG_PQF_ERR_MSG_EN_MASK                    0xF
+#define NIC0_QM0_GLBL_ERR_CFG_CQF_ERR_MSG_EN_SHIFT                   4
+#define NIC0_QM0_GLBL_ERR_CFG_CQF_ERR_MSG_EN_MASK                    0x1F0
+#define NIC0_QM0_GLBL_ERR_CFG_CP_ERR_MSG_EN_SHIFT                    9
+#define NIC0_QM0_GLBL_ERR_CFG_CP_ERR_MSG_EN_MASK                     0x3E00
+#define NIC0_QM0_GLBL_ERR_CFG_PQF_STOP_ON_ERR_SHIFT                  16
+#define NIC0_QM0_GLBL_ERR_CFG_PQF_STOP_ON_ERR_MASK                   0xF0000
+#define NIC0_QM0_GLBL_ERR_CFG_CQF_STOP_ON_ERR_SHIFT                  20
+#define NIC0_QM0_GLBL_ERR_CFG_CQF_STOP_ON_ERR_MASK                   0x1F00000
+#define NIC0_QM0_GLBL_ERR_CFG_CP_STOP_ON_ERR_SHIFT                   25
+#define NIC0_QM0_GLBL_ERR_CFG_CP_STOP_ON_ERR_MASK                    0x3E000000
+#define NIC0_QM0_GLBL_ERR_CFG_ARB_STOP_ON_ERR_SHIFT                  31
+#define NIC0_QM0_GLBL_ERR_CFG_ARB_STOP_ON_ERR_MASK                   0x80000000
+
+/* NIC0_QM0_GLBL_SECURE_PROPS */
+#define NIC0_QM0_GLBL_SECURE_PROPS_0_ASID_SHIFT                      0
+#define NIC0_QM0_GLBL_SECURE_PROPS_0_ASID_MASK                       0x3FF
+#define NIC0_QM0_GLBL_SECURE_PROPS_1_ASID_SHIFT                      0
+#define NIC0_QM0_GLBL_SECURE_PROPS_1_ASID_MASK                       0x3FF
+#define NIC0_QM0_GLBL_SECURE_PROPS_2_ASID_SHIFT                      0
+#define NIC0_QM0_GLBL_SECURE_PROPS_2_ASID_MASK                       0x3FF
+#define NIC0_QM0_GLBL_SECURE_PROPS_3_ASID_SHIFT                      0
+#define NIC0_QM0_GLBL_SECURE_PROPS_3_ASID_MASK                       0x3FF
+#define NIC0_QM0_GLBL_SECURE_PROPS_4_ASID_SHIFT                      0
+#define NIC0_QM0_GLBL_SECURE_PROPS_4_ASID_MASK                       0x3FF
+#define NIC0_QM0_GLBL_SECURE_PROPS_0_MMBP_SHIFT                      10
+#define NIC0_QM0_GLBL_SECURE_PROPS_0_MMBP_MASK                       0x400
+#define NIC0_QM0_GLBL_SECURE_PROPS_1_MMBP_SHIFT                      10
+#define NIC0_QM0_GLBL_SECURE_PROPS_1_MMBP_MASK                       0x400
+#define NIC0_QM0_GLBL_SECURE_PROPS_2_MMBP_SHIFT                      10
+#define NIC0_QM0_GLBL_SECURE_PROPS_2_MMBP_MASK                       0x400
+#define NIC0_QM0_GLBL_SECURE_PROPS_3_MMBP_SHIFT                      10
+#define NIC0_QM0_GLBL_SECURE_PROPS_3_MMBP_MASK                       0x400
+#define NIC0_QM0_GLBL_SECURE_PROPS_4_MMBP_SHIFT                      10
+#define NIC0_QM0_GLBL_SECURE_PROPS_4_MMBP_MASK                       0x400
+
+/* NIC0_QM0_GLBL_NON_SECURE_PROPS */
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_0_ASID_SHIFT                  0
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_0_ASID_MASK                   0x3FF
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_1_ASID_SHIFT                  0
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_1_ASID_MASK                   0x3FF
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_2_ASID_SHIFT                  0
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_2_ASID_MASK                   0x3FF
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_3_ASID_SHIFT                  0
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_3_ASID_MASK                   0x3FF
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_4_ASID_SHIFT                  0
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_4_ASID_MASK                   0x3FF
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_0_MMBP_SHIFT                  10
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_0_MMBP_MASK                   0x400
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_1_MMBP_SHIFT                  10
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_1_MMBP_MASK                   0x400
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_2_MMBP_SHIFT                  10
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_2_MMBP_MASK                   0x400
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_3_MMBP_SHIFT                  10
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_3_MMBP_MASK                   0x400
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_4_MMBP_SHIFT                  10
+#define NIC0_QM0_GLBL_NON_SECURE_PROPS_4_MMBP_MASK                   0x400
+
+/* NIC0_QM0_GLBL_STS0 */
+#define NIC0_QM0_GLBL_STS0_PQF_IDLE_SHIFT                            0
+#define NIC0_QM0_GLBL_STS0_PQF_IDLE_MASK                             0xF
+#define NIC0_QM0_GLBL_STS0_CQF_IDLE_SHIFT                            4
+#define NIC0_QM0_GLBL_STS0_CQF_IDLE_MASK                             0x1F0
+#define NIC0_QM0_GLBL_STS0_CP_IDLE_SHIFT                             9
+#define NIC0_QM0_GLBL_STS0_CP_IDLE_MASK                              0x3E00
+#define NIC0_QM0_GLBL_STS0_PQF_IS_STOP_SHIFT                         16
+#define NIC0_QM0_GLBL_STS0_PQF_IS_STOP_MASK                          0xF0000
+#define NIC0_QM0_GLBL_STS0_CQF_IS_STOP_SHIFT                         20
+#define NIC0_QM0_GLBL_STS0_CQF_IS_STOP_MASK                          0x1F00000
+#define NIC0_QM0_GLBL_STS0_CP_IS_STOP_SHIFT                          25
+#define NIC0_QM0_GLBL_STS0_CP_IS_STOP_MASK                           0x3E000000
+#define NIC0_QM0_GLBL_STS0_ARB_IS_STOP_SHIFT                         31
+#define NIC0_QM0_GLBL_STS0_ARB_IS_STOP_MASK                          0x80000000
+
+/* NIC0_QM0_GLBL_STS1 */
+#define NIC0_QM0_GLBL_STS1_PQF_RD_ERR_SHIFT                          0
+#define NIC0_QM0_GLBL_STS1_PQF_RD_ERR_MASK                           0x1
+#define NIC0_QM0_GLBL_STS1_CQF_RD_ERR_SHIFT                          1
+#define NIC0_QM0_GLBL_STS1_CQF_RD_ERR_MASK                           0x2
+#define NIC0_QM0_GLBL_STS1_CP_RD_ERR_SHIFT                           2
+#define NIC0_QM0_GLBL_STS1_CP_RD_ERR_MASK                            0x4
+#define NIC0_QM0_GLBL_STS1_CP_UNDEF_CMD_ERR_SHIFT                    3
+#define NIC0_QM0_GLBL_STS1_CP_UNDEF_CMD_ERR_MASK                     0x8
+#define NIC0_QM0_GLBL_STS1_CP_STOP_OP_SHIFT                          4
+#define NIC0_QM0_GLBL_STS1_CP_STOP_OP_MASK                           0x10
+#define NIC0_QM0_GLBL_STS1_CP_MSG_WR_ERR_SHIFT                       5
+#define NIC0_QM0_GLBL_STS1_CP_MSG_WR_ERR_MASK                        0x20
+#define NIC0_QM0_GLBL_STS1_CP_WREG_ERR_SHIFT                         6
+#define NIC0_QM0_GLBL_STS1_CP_WREG_ERR_MASK                          0x40
+#define NIC0_QM0_GLBL_STS1_CP_FENCE0_OVF_ERR_SHIFT                   8
+#define NIC0_QM0_GLBL_STS1_CP_FENCE0_OVF_ERR_MASK                    0x100
+#define NIC0_QM0_GLBL_STS1_CP_FENCE1_OVF_ERR_SHIFT                   9
+#define NIC0_QM0_GLBL_STS1_CP_FENCE1_OVF_ERR_MASK                    0x200
+#define NIC0_QM0_GLBL_STS1_CP_FENCE2_OVF_ERR_SHIFT                   10
+#define NIC0_QM0_GLBL_STS1_CP_FENCE2_OVF_ERR_MASK                    0x400
+#define NIC0_QM0_GLBL_STS1_CP_FENCE3_OVF_ERR_SHIFT                   11
+#define NIC0_QM0_GLBL_STS1_CP_FENCE3_OVF_ERR_MASK                    0x800
+#define NIC0_QM0_GLBL_STS1_CP_FENCE0_UDF_ERR_SHIFT                   12
+#define NIC0_QM0_GLBL_STS1_CP_FENCE0_UDF_ERR_MASK                    0x1000
+#define NIC0_QM0_GLBL_STS1_CP_FENCE1_UDF_ERR_SHIFT                   13
+#define NIC0_QM0_GLBL_STS1_CP_FENCE1_UDF_ERR_MASK                    0x2000
+#define NIC0_QM0_GLBL_STS1_CP_FENCE2_UDF_ERR_SHIFT                   14
+#define NIC0_QM0_GLBL_STS1_CP_FENCE2_UDF_ERR_MASK                    0x4000
+#define NIC0_QM0_GLBL_STS1_CP_FENCE3_UDF_ERR_SHIFT                   15
+#define NIC0_QM0_GLBL_STS1_CP_FENCE3_UDF_ERR_MASK                    0x8000
+
+/* NIC0_QM0_GLBL_STS1_4 */
+#define NIC0_QM0_GLBL_STS1_4_CQF_RD_ERR_SHIFT                        1
+#define NIC0_QM0_GLBL_STS1_4_CQF_RD_ERR_MASK                         0x2
+#define NIC0_QM0_GLBL_STS1_4_CP_RD_ERR_SHIFT                         2
+#define NIC0_QM0_GLBL_STS1_4_CP_RD_ERR_MASK                          0x4
+#define NIC0_QM0_GLBL_STS1_4_CP_UNDEF_CMD_ERR_SHIFT                  3
+#define NIC0_QM0_GLBL_STS1_4_CP_UNDEF_CMD_ERR_MASK                   0x8
+#define NIC0_QM0_GLBL_STS1_4_CP_STOP_OP_SHIFT                        4
+#define NIC0_QM0_GLBL_STS1_4_CP_STOP_OP_MASK                         0x10
+#define NIC0_QM0_GLBL_STS1_4_CP_MSG_WR_ERR_SHIFT                     5
+#define NIC0_QM0_GLBL_STS1_4_CP_MSG_WR_ERR_MASK                      0x20
+#define NIC0_QM0_GLBL_STS1_4_CP_WREG_ERR_SHIFT                       6
+#define NIC0_QM0_GLBL_STS1_4_CP_WREG_ERR_MASK                        0x40
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE0_OVF_ERR_SHIFT                 8
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE0_OVF_ERR_MASK                  0x100
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE1_OVF_ERR_SHIFT                 9
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE1_OVF_ERR_MASK                  0x200
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE2_OVF_ERR_SHIFT                 10
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE2_OVF_ERR_MASK                  0x400
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE3_OVF_ERR_SHIFT                 11
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE3_OVF_ERR_MASK                  0x800
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE0_UDF_ERR_SHIFT                 12
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE0_UDF_ERR_MASK                  0x1000
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE1_UDF_ERR_SHIFT                 13
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE1_UDF_ERR_MASK                  0x2000
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE2_UDF_ERR_SHIFT                 14
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE2_UDF_ERR_MASK                  0x4000
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE3_UDF_ERR_SHIFT                 15
+#define NIC0_QM0_GLBL_STS1_4_CP_FENCE3_UDF_ERR_MASK                  0x8000
+
+/* NIC0_QM0_GLBL_MSG_EN */
+#define NIC0_QM0_GLBL_MSG_EN_PQF_RD_ERR_SHIFT                        0
+#define NIC0_QM0_GLBL_MSG_EN_PQF_RD_ERR_MASK                         0x1
+#define NIC0_QM0_GLBL_MSG_EN_CQF_RD_ERR_SHIFT                        1
+#define NIC0_QM0_GLBL_MSG_EN_CQF_RD_ERR_MASK                         0x2
+#define NIC0_QM0_GLBL_MSG_EN_CP_RD_ERR_SHIFT                         2
+#define NIC0_QM0_GLBL_MSG_EN_CP_RD_ERR_MASK                          0x4
+#define NIC0_QM0_GLBL_MSG_EN_CP_UNDEF_CMD_ERR_SHIFT                  3
+#define NIC0_QM0_GLBL_MSG_EN_CP_UNDEF_CMD_ERR_MASK                   0x8
+#define NIC0_QM0_GLBL_MSG_EN_CP_STOP_OP_SHIFT                        4
+#define NIC0_QM0_GLBL_MSG_EN_CP_STOP_OP_MASK                         0x10
+#define NIC0_QM0_GLBL_MSG_EN_CP_MSG_WR_ERR_SHIFT                     5
+#define NIC0_QM0_GLBL_MSG_EN_CP_MSG_WR_ERR_MASK                      0x20
+#define NIC0_QM0_GLBL_MSG_EN_CP_WREG_ERR_SHIFT                       6
+#define NIC0_QM0_GLBL_MSG_EN_CP_WREG_ERR_MASK                        0x40
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE0_OVF_ERR_SHIFT                 8
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE0_OVF_ERR_MASK                  0x100
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE1_OVF_ERR_SHIFT                 9
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE1_OVF_ERR_MASK                  0x200
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE2_OVF_ERR_SHIFT                 10
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE2_OVF_ERR_MASK                  0x400
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE3_OVF_ERR_SHIFT                 11
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE3_OVF_ERR_MASK                  0x800
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE0_UDF_ERR_SHIFT                 12
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE0_UDF_ERR_MASK                  0x1000
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE1_UDF_ERR_SHIFT                 13
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE1_UDF_ERR_MASK                  0x2000
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE2_UDF_ERR_SHIFT                 14
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE2_UDF_ERR_MASK                  0x4000
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE3_UDF_ERR_SHIFT                 15
+#define NIC0_QM0_GLBL_MSG_EN_CP_FENCE3_UDF_ERR_MASK                  0x8000
+
+/* NIC0_QM0_GLBL_MSG_EN_4 */
+#define NIC0_QM0_GLBL_MSG_EN_4_CQF_RD_ERR_SHIFT                      1
+#define NIC0_QM0_GLBL_MSG_EN_4_CQF_RD_ERR_MASK                       0x2
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_RD_ERR_SHIFT                       2
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_RD_ERR_MASK                        0x4
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_UNDEF_CMD_ERR_SHIFT                3
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_UNDEF_CMD_ERR_MASK                 0x8
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_STOP_OP_SHIFT                      4
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_STOP_OP_MASK                       0x10
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_MSG_WR_ERR_SHIFT                   5
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_MSG_WR_ERR_MASK                    0x20
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_WREG_ERR_SHIFT                     6
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_WREG_ERR_MASK                      0x40
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE0_OVF_ERR_SHIFT               8
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE0_OVF_ERR_MASK                0x100
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE1_OVF_ERR_SHIFT               9
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE1_OVF_ERR_MASK                0x200
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE2_OVF_ERR_SHIFT               10
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE2_OVF_ERR_MASK                0x400
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE3_OVF_ERR_SHIFT               11
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE3_OVF_ERR_MASK                0x800
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE0_UDF_ERR_SHIFT               12
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE0_UDF_ERR_MASK                0x1000
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE1_UDF_ERR_SHIFT               13
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE1_UDF_ERR_MASK                0x2000
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE2_UDF_ERR_SHIFT               14
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE2_UDF_ERR_MASK                0x4000
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE3_UDF_ERR_SHIFT               15
+#define NIC0_QM0_GLBL_MSG_EN_4_CP_FENCE3_UDF_ERR_MASK                0x8000
+
+/* NIC0_QM0_PQ_BASE_LO */
+#define NIC0_QM0_PQ_BASE_LO_VAL_SHIFT                                0
+#define NIC0_QM0_PQ_BASE_LO_VAL_MASK                                 0xFFFFFFFF
+
+/* NIC0_QM0_PQ_BASE_HI */
+#define NIC0_QM0_PQ_BASE_HI_VAL_SHIFT                                0
+#define NIC0_QM0_PQ_BASE_HI_VAL_MASK                                 0xFFFFFFFF
+
+/* NIC0_QM0_PQ_SIZE */
+#define NIC0_QM0_PQ_SIZE_VAL_SHIFT                                   0
+#define NIC0_QM0_PQ_SIZE_VAL_MASK                                    0xFFFFFFFF
+
+/* NIC0_QM0_PQ_PI */
+#define NIC0_QM0_PQ_PI_VAL_SHIFT                                     0
+#define NIC0_QM0_PQ_PI_VAL_MASK                                      0xFFFFFFFF
+
+/* NIC0_QM0_PQ_CI */
+#define NIC0_QM0_PQ_CI_VAL_SHIFT                                     0
+#define NIC0_QM0_PQ_CI_VAL_MASK                                      0xFFFFFFFF
+
+/* NIC0_QM0_PQ_CFG0 */
+#define NIC0_QM0_PQ_CFG0_RESERVED_SHIFT                              0
+#define NIC0_QM0_PQ_CFG0_RESERVED_MASK                               0x1
+
+/* NIC0_QM0_PQ_CFG1 */
+#define NIC0_QM0_PQ_CFG1_CREDIT_LIM_SHIFT                            0
+#define NIC0_QM0_PQ_CFG1_CREDIT_LIM_MASK                             0xFFFF
+#define NIC0_QM0_PQ_CFG1_MAX_INFLIGHT_SHIFT                          16
+#define NIC0_QM0_PQ_CFG1_MAX_INFLIGHT_MASK                           0xFFFF0000
+
+/* NIC0_QM0_PQ_ARUSER_31_11 */
+#define NIC0_QM0_PQ_ARUSER_31_11_VAL_SHIFT                           0
+#define NIC0_QM0_PQ_ARUSER_31_11_VAL_MASK                            0x1FFFFF
+
+/* NIC0_QM0_PQ_STS0 */
+#define NIC0_QM0_PQ_STS0_PQ_CREDIT_CNT_SHIFT                         0
+#define NIC0_QM0_PQ_STS0_PQ_CREDIT_CNT_MASK                          0xFFFF
+#define NIC0_QM0_PQ_STS0_PQ_FREE_CNT_SHIFT                           16
+#define NIC0_QM0_PQ_STS0_PQ_FREE_CNT_MASK                            0xFFFF0000
+
+/* NIC0_QM0_PQ_STS1 */
+#define NIC0_QM0_PQ_STS1_PQ_INFLIGHT_CNT_SHIFT                       0
+#define NIC0_QM0_PQ_STS1_PQ_INFLIGHT_CNT_MASK                        0xFFFF
+#define NIC0_QM0_PQ_STS1_PQ_BUF_EMPTY_SHIFT                          30
+#define NIC0_QM0_PQ_STS1_PQ_BUF_EMPTY_MASK                           0x40000000
+#define NIC0_QM0_PQ_STS1_PQ_BUSY_SHIFT                               31
+#define NIC0_QM0_PQ_STS1_PQ_BUSY_MASK                                0x80000000
+
+/* NIC0_QM0_CQ_CFG0 */
+#define NIC0_QM0_CQ_CFG0_RESERVED_SHIFT                              0
+#define NIC0_QM0_CQ_CFG0_RESERVED_MASK                               0x1
+
+/* NIC0_QM0_CQ_CFG1 */
+#define NIC0_QM0_CQ_CFG1_CREDIT_LIM_SHIFT                            0
+#define NIC0_QM0_CQ_CFG1_CREDIT_LIM_MASK                             0xFFFF
+#define NIC0_QM0_CQ_CFG1_MAX_INFLIGHT_SHIFT                          16
+#define NIC0_QM0_CQ_CFG1_MAX_INFLIGHT_MASK                           0xFFFF0000
+
+/* NIC0_QM0_CQ_ARUSER_31_11 */
+#define NIC0_QM0_CQ_ARUSER_31_11_VAL_SHIFT                           0
+#define NIC0_QM0_CQ_ARUSER_31_11_VAL_MASK                            0x1FFFFF
+
+/* NIC0_QM0_CQ_STS0 */
+#define NIC0_QM0_CQ_STS0_CQ_CREDIT_CNT_SHIFT                         0
+#define NIC0_QM0_CQ_STS0_CQ_CREDIT_CNT_MASK                          0xFFFF
+#define NIC0_QM0_CQ_STS0_CQ_FREE_CNT_SHIFT                           16
+#define NIC0_QM0_CQ_STS0_CQ_FREE_CNT_MASK                            0xFFFF0000
+
+/* NIC0_QM0_CQ_STS1 */
+#define NIC0_QM0_CQ_STS1_CQ_INFLIGHT_CNT_SHIFT                       0
+#define NIC0_QM0_CQ_STS1_CQ_INFLIGHT_CNT_MASK                        0xFFFF
+#define NIC0_QM0_CQ_STS1_CQ_BUF_EMPTY_SHIFT                          30
+#define NIC0_QM0_CQ_STS1_CQ_BUF_EMPTY_MASK                           0x40000000
+#define NIC0_QM0_CQ_STS1_CQ_BUSY_SHIFT                               31
+#define NIC0_QM0_CQ_STS1_CQ_BUSY_MASK                                0x80000000
+
+/* NIC0_QM0_CQ_PTR_LO_0 */
+#define NIC0_QM0_CQ_PTR_LO_0_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_LO_0_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_PTR_HI_0 */
+#define NIC0_QM0_CQ_PTR_HI_0_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_HI_0_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_TSIZE_0 */
+#define NIC0_QM0_CQ_TSIZE_0_VAL_SHIFT                                0
+#define NIC0_QM0_CQ_TSIZE_0_VAL_MASK                                 0xFFFFFFFF
+
+/* NIC0_QM0_CQ_CTL_0 */
+#define NIC0_QM0_CQ_CTL_0_RPT_SHIFT                                  0
+#define NIC0_QM0_CQ_CTL_0_RPT_MASK                                   0xFFFF
+#define NIC0_QM0_CQ_CTL_0_CTL_SHIFT                                  16
+#define NIC0_QM0_CQ_CTL_0_CTL_MASK                                   0xFFFF0000
+
+/* NIC0_QM0_CQ_PTR_LO_1 */
+#define NIC0_QM0_CQ_PTR_LO_1_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_LO_1_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_PTR_HI_1 */
+#define NIC0_QM0_CQ_PTR_HI_1_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_HI_1_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_TSIZE_1 */
+#define NIC0_QM0_CQ_TSIZE_1_VAL_SHIFT                                0
+#define NIC0_QM0_CQ_TSIZE_1_VAL_MASK                                 0xFFFFFFFF
+
+/* NIC0_QM0_CQ_CTL_1 */
+#define NIC0_QM0_CQ_CTL_1_RPT_SHIFT                                  0
+#define NIC0_QM0_CQ_CTL_1_RPT_MASK                                   0xFFFF
+#define NIC0_QM0_CQ_CTL_1_CTL_SHIFT                                  16
+#define NIC0_QM0_CQ_CTL_1_CTL_MASK                                   0xFFFF0000
+
+/* NIC0_QM0_CQ_PTR_LO_2 */
+#define NIC0_QM0_CQ_PTR_LO_2_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_LO_2_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_PTR_HI_2 */
+#define NIC0_QM0_CQ_PTR_HI_2_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_HI_2_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_TSIZE_2 */
+#define NIC0_QM0_CQ_TSIZE_2_VAL_SHIFT                                0
+#define NIC0_QM0_CQ_TSIZE_2_VAL_MASK                                 0xFFFFFFFF
+
+/* NIC0_QM0_CQ_CTL_2 */
+#define NIC0_QM0_CQ_CTL_2_RPT_SHIFT                                  0
+#define NIC0_QM0_CQ_CTL_2_RPT_MASK                                   0xFFFF
+#define NIC0_QM0_CQ_CTL_2_CTL_SHIFT                                  16
+#define NIC0_QM0_CQ_CTL_2_CTL_MASK                                   0xFFFF0000
+
+/* NIC0_QM0_CQ_PTR_LO_3 */
+#define NIC0_QM0_CQ_PTR_LO_3_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_LO_3_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_PTR_HI_3 */
+#define NIC0_QM0_CQ_PTR_HI_3_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_HI_3_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_TSIZE_3 */
+#define NIC0_QM0_CQ_TSIZE_3_VAL_SHIFT                                0
+#define NIC0_QM0_CQ_TSIZE_3_VAL_MASK                                 0xFFFFFFFF
+
+/* NIC0_QM0_CQ_CTL_3 */
+#define NIC0_QM0_CQ_CTL_3_RPT_SHIFT                                  0
+#define NIC0_QM0_CQ_CTL_3_RPT_MASK                                   0xFFFF
+#define NIC0_QM0_CQ_CTL_3_CTL_SHIFT                                  16
+#define NIC0_QM0_CQ_CTL_3_CTL_MASK                                   0xFFFF0000
+
+/* NIC0_QM0_CQ_PTR_LO_4 */
+#define NIC0_QM0_CQ_PTR_LO_4_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_LO_4_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_PTR_HI_4 */
+#define NIC0_QM0_CQ_PTR_HI_4_VAL_SHIFT                               0
+#define NIC0_QM0_CQ_PTR_HI_4_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_CQ_TSIZE_4 */
+#define NIC0_QM0_CQ_TSIZE_4_VAL_SHIFT                                0
+#define NIC0_QM0_CQ_TSIZE_4_VAL_MASK                                 0xFFFFFFFF
+
+/* NIC0_QM0_CQ_CTL_4 */
+#define NIC0_QM0_CQ_CTL_4_RPT_SHIFT                                  0
+#define NIC0_QM0_CQ_CTL_4_RPT_MASK                                   0xFFFF
+#define NIC0_QM0_CQ_CTL_4_CTL_SHIFT                                  16
+#define NIC0_QM0_CQ_CTL_4_CTL_MASK                                   0xFFFF0000
+
+/* NIC0_QM0_CQ_PTR_LO_STS */
+#define NIC0_QM0_CQ_PTR_LO_STS_VAL_SHIFT                             0
+#define NIC0_QM0_CQ_PTR_LO_STS_VAL_MASK                              0xFFFFFFFF
+
+/* NIC0_QM0_CQ_PTR_HI_STS */
+#define NIC0_QM0_CQ_PTR_HI_STS_VAL_SHIFT                             0
+#define NIC0_QM0_CQ_PTR_HI_STS_VAL_MASK                              0xFFFFFFFF
+
+/* NIC0_QM0_CQ_TSIZE_STS */
+#define NIC0_QM0_CQ_TSIZE_STS_VAL_SHIFT                              0
+#define NIC0_QM0_CQ_TSIZE_STS_VAL_MASK                               0xFFFFFFFF
+
+/* NIC0_QM0_CQ_CTL_STS */
+#define NIC0_QM0_CQ_CTL_STS_RPT_SHIFT                                0
+#define NIC0_QM0_CQ_CTL_STS_RPT_MASK                                 0xFFFF
+#define NIC0_QM0_CQ_CTL_STS_CTL_SHIFT                                16
+#define NIC0_QM0_CQ_CTL_STS_CTL_MASK                                 0xFFFF0000
+
+/* NIC0_QM0_CQ_IFIFO_CNT */
+#define NIC0_QM0_CQ_IFIFO_CNT_VAL_SHIFT                              0
+#define NIC0_QM0_CQ_IFIFO_CNT_VAL_MASK                               0x3
+
+/* NIC0_QM0_CP_MSG_BASE0_ADDR_LO */
+#define NIC0_QM0_CP_MSG_BASE0_ADDR_LO_VAL_SHIFT                      0
+#define NIC0_QM0_CP_MSG_BASE0_ADDR_LO_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_MSG_BASE0_ADDR_HI */
+#define NIC0_QM0_CP_MSG_BASE0_ADDR_HI_VAL_SHIFT                      0
+#define NIC0_QM0_CP_MSG_BASE0_ADDR_HI_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_MSG_BASE1_ADDR_LO */
+#define NIC0_QM0_CP_MSG_BASE1_ADDR_LO_VAL_SHIFT                      0
+#define NIC0_QM0_CP_MSG_BASE1_ADDR_LO_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_MSG_BASE1_ADDR_HI */
+#define NIC0_QM0_CP_MSG_BASE1_ADDR_HI_VAL_SHIFT                      0
+#define NIC0_QM0_CP_MSG_BASE1_ADDR_HI_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_MSG_BASE2_ADDR_LO */
+#define NIC0_QM0_CP_MSG_BASE2_ADDR_LO_VAL_SHIFT                      0
+#define NIC0_QM0_CP_MSG_BASE2_ADDR_LO_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_MSG_BASE2_ADDR_HI */
+#define NIC0_QM0_CP_MSG_BASE2_ADDR_HI_VAL_SHIFT                      0
+#define NIC0_QM0_CP_MSG_BASE2_ADDR_HI_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_MSG_BASE3_ADDR_LO */
+#define NIC0_QM0_CP_MSG_BASE3_ADDR_LO_VAL_SHIFT                      0
+#define NIC0_QM0_CP_MSG_BASE3_ADDR_LO_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_MSG_BASE3_ADDR_HI */
+#define NIC0_QM0_CP_MSG_BASE3_ADDR_HI_VAL_SHIFT                      0
+#define NIC0_QM0_CP_MSG_BASE3_ADDR_HI_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_LDMA_TSIZE_OFFSET */
+#define NIC0_QM0_CP_LDMA_TSIZE_OFFSET_VAL_SHIFT                      0
+#define NIC0_QM0_CP_LDMA_TSIZE_OFFSET_VAL_MASK                       0xFFFFFFFF
+
+/* NIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET */
+#define NIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_VAL_SHIFT                0
+#define NIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_VAL_MASK                 0xFFFFFFFF
+
+/* NIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET */
+#define NIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_VAL_SHIFT                0
+#define NIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_VAL_MASK                 0xFFFFFFFF
+
+/* NIC0_QM0_CP_FENCE0_RDATA */
+#define NIC0_QM0_CP_FENCE0_RDATA_INC_VAL_SHIFT                       0
+#define NIC0_QM0_CP_FENCE0_RDATA_INC_VAL_MASK                        0xF
+
+/* NIC0_QM0_CP_FENCE1_RDATA */
+#define NIC0_QM0_CP_FENCE1_RDATA_INC_VAL_SHIFT                       0
+#define NIC0_QM0_CP_FENCE1_RDATA_INC_VAL_MASK                        0xF
+
+/* NIC0_QM0_CP_FENCE2_RDATA */
+#define NIC0_QM0_CP_FENCE2_RDATA_INC_VAL_SHIFT                       0
+#define NIC0_QM0_CP_FENCE2_RDATA_INC_VAL_MASK                        0xF
+
+/* NIC0_QM0_CP_FENCE3_RDATA */
+#define NIC0_QM0_CP_FENCE3_RDATA_INC_VAL_SHIFT                       0
+#define NIC0_QM0_CP_FENCE3_RDATA_INC_VAL_MASK                        0xF
+
+/* NIC0_QM0_CP_FENCE0_CNT */
+#define NIC0_QM0_CP_FENCE0_CNT_VAL_SHIFT                             0
+#define NIC0_QM0_CP_FENCE0_CNT_VAL_MASK                              0x3FFF
+
+/* NIC0_QM0_CP_FENCE1_CNT */
+#define NIC0_QM0_CP_FENCE1_CNT_VAL_SHIFT                             0
+#define NIC0_QM0_CP_FENCE1_CNT_VAL_MASK                              0x3FFF
+
+/* NIC0_QM0_CP_FENCE2_CNT */
+#define NIC0_QM0_CP_FENCE2_CNT_VAL_SHIFT                             0
+#define NIC0_QM0_CP_FENCE2_CNT_VAL_MASK                              0x3FFF
+
+/* NIC0_QM0_CP_FENCE3_CNT */
+#define NIC0_QM0_CP_FENCE3_CNT_VAL_SHIFT                             0
+#define NIC0_QM0_CP_FENCE3_CNT_VAL_MASK                              0x3FFF
+
+/* NIC0_QM0_CP_STS */
+#define NIC0_QM0_CP_STS_MSG_INFLIGHT_CNT_SHIFT                       0
+#define NIC0_QM0_CP_STS_MSG_INFLIGHT_CNT_MASK                        0xFFFF
+#define NIC0_QM0_CP_STS_ERDY_SHIFT                                   16
+#define NIC0_QM0_CP_STS_ERDY_MASK                                    0x10000
+#define NIC0_QM0_CP_STS_RRDY_SHIFT                                   17
+#define NIC0_QM0_CP_STS_RRDY_MASK                                    0x20000
+#define NIC0_QM0_CP_STS_MRDY_SHIFT                                   18
+#define NIC0_QM0_CP_STS_MRDY_MASK                                    0x40000
+#define NIC0_QM0_CP_STS_SW_STOP_SHIFT                                19
+#define NIC0_QM0_CP_STS_SW_STOP_MASK                                 0x80000
+#define NIC0_QM0_CP_STS_FENCE_ID_SHIFT                               20
+#define NIC0_QM0_CP_STS_FENCE_ID_MASK                                0x300000
+#define NIC0_QM0_CP_STS_FENCE_IN_PROGRESS_SHIFT                      22
+#define NIC0_QM0_CP_STS_FENCE_IN_PROGRESS_MASK                       0x400000
+
+/* NIC0_QM0_CP_CURRENT_INST_LO */
+#define NIC0_QM0_CP_CURRENT_INST_LO_VAL_SHIFT                        0
+#define NIC0_QM0_CP_CURRENT_INST_LO_VAL_MASK                         0xFFFFFFFF
+
+/* NIC0_QM0_CP_CURRENT_INST_HI */
+#define NIC0_QM0_CP_CURRENT_INST_HI_VAL_SHIFT                        0
+#define NIC0_QM0_CP_CURRENT_INST_HI_VAL_MASK                         0xFFFFFFFF
+
+/* NIC0_QM0_CP_BARRIER_CFG */
+#define NIC0_QM0_CP_BARRIER_CFG_EBGUARD_SHIFT                        0
+#define NIC0_QM0_CP_BARRIER_CFG_EBGUARD_MASK                         0xFFF
+#define NIC0_QM0_CP_BARRIER_CFG_RBGUARD_SHIFT                        16
+#define NIC0_QM0_CP_BARRIER_CFG_RBGUARD_MASK                         0xF0000
+
+/* NIC0_QM0_CP_DBG_0 */
+#define NIC0_QM0_CP_DBG_0_CS_SHIFT                                   0
+#define NIC0_QM0_CP_DBG_0_CS_MASK                                    0xF
+#define NIC0_QM0_CP_DBG_0_EB_CNT_NOT_ZERO_SHIFT                      4
+#define NIC0_QM0_CP_DBG_0_EB_CNT_NOT_ZERO_MASK                       0x10
+#define NIC0_QM0_CP_DBG_0_BULK_CNT_NOT_ZERO_SHIFT                    5
+#define NIC0_QM0_CP_DBG_0_BULK_CNT_NOT_ZERO_MASK                     0x20
+#define NIC0_QM0_CP_DBG_0_MREB_STALL_SHIFT                           6
+#define NIC0_QM0_CP_DBG_0_MREB_STALL_MASK                            0x40
+#define NIC0_QM0_CP_DBG_0_STALL_SHIFT                                7
+#define NIC0_QM0_CP_DBG_0_STALL_MASK                                 0x80
+
+/* NIC0_QM0_CP_ARUSER_31_11 */
+#define NIC0_QM0_CP_ARUSER_31_11_VAL_SHIFT                           0
+#define NIC0_QM0_CP_ARUSER_31_11_VAL_MASK                            0x1FFFFF
+
+/* NIC0_QM0_CP_AWUSER_31_11 */
+#define NIC0_QM0_CP_AWUSER_31_11_VAL_SHIFT                           0
+#define NIC0_QM0_CP_AWUSER_31_11_VAL_MASK                            0x1FFFFF
+
+/* NIC0_QM0_ARB_CFG_0 */
+#define NIC0_QM0_ARB_CFG_0_TYPE_SHIFT                                0
+#define NIC0_QM0_ARB_CFG_0_TYPE_MASK                                 0x1
+#define NIC0_QM0_ARB_CFG_0_IS_MASTER_SHIFT                           4
+#define NIC0_QM0_ARB_CFG_0_IS_MASTER_MASK                            0x10
+#define NIC0_QM0_ARB_CFG_0_EN_SHIFT                                  8
+#define NIC0_QM0_ARB_CFG_0_EN_MASK                                   0x100
+#define NIC0_QM0_ARB_CFG_0_MASK_SHIFT                                12
+#define NIC0_QM0_ARB_CFG_0_MASK_MASK                                 0xF000
+#define NIC0_QM0_ARB_CFG_0_MST_MSG_NOSTALL_SHIFT                     16
+#define NIC0_QM0_ARB_CFG_0_MST_MSG_NOSTALL_MASK                      0x10000
+
+/* NIC0_QM0_ARB_CHOISE_Q_PUSH */
+#define NIC0_QM0_ARB_CHOISE_Q_PUSH_VAL_SHIFT                         0
+#define NIC0_QM0_ARB_CHOISE_Q_PUSH_VAL_MASK                          0x3
+
+/* NIC0_QM0_ARB_WRR_WEIGHT */
+#define NIC0_QM0_ARB_WRR_WEIGHT_VAL_SHIFT                            0
+#define NIC0_QM0_ARB_WRR_WEIGHT_VAL_MASK                             0xFFFFFFFF
+
+/* NIC0_QM0_ARB_CFG_1 */
+#define NIC0_QM0_ARB_CFG_1_CLR_SHIFT                                 0
+#define NIC0_QM0_ARB_CFG_1_CLR_MASK                                  0x1
+
+/* NIC0_QM0_ARB_MST_AVAIL_CRED */
+#define NIC0_QM0_ARB_MST_AVAIL_CRED_VAL_SHIFT                        0
+#define NIC0_QM0_ARB_MST_AVAIL_CRED_VAL_MASK                         0x7F
+
+/* NIC0_QM0_ARB_MST_CRED_INC */
+#define NIC0_QM0_ARB_MST_CRED_INC_VAL_SHIFT                          0
+#define NIC0_QM0_ARB_MST_CRED_INC_VAL_MASK                           0xFFFFFFFF
+
+/* NIC0_QM0_ARB_MST_CHOISE_PUSH_OFST */
+#define NIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_VAL_SHIFT                  0
+#define NIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_VAL_MASK                   0xFFFFFFFF
+
+/* NIC0_QM0_ARB_SLV_MASTER_INC_CRED_OFST */
+#define NIC0_QM0_ARB_SLV_MASTER_INC_CRED_OFST_VAL_SHIFT              0
+#define NIC0_QM0_ARB_SLV_MASTER_INC_CRED_OFST_VAL_MASK               0xFFFFFFFF
+
+/* NIC0_QM0_ARB_MST_SLAVE_EN */
+#define NIC0_QM0_ARB_MST_SLAVE_EN_VAL_SHIFT                          0
+#define NIC0_QM0_ARB_MST_SLAVE_EN_VAL_MASK                           0xFFFFFFFF
+
+/* NIC0_QM0_ARB_MST_QUIET_PER */
+#define NIC0_QM0_ARB_MST_QUIET_PER_VAL_SHIFT                         0
+#define NIC0_QM0_ARB_MST_QUIET_PER_VAL_MASK                          0xFFFFFFFF
+
+/* NIC0_QM0_ARB_SLV_CHOISE_WDT */
+#define NIC0_QM0_ARB_SLV_CHOISE_WDT_VAL_SHIFT                        0
+#define NIC0_QM0_ARB_SLV_CHOISE_WDT_VAL_MASK                         0xFFFFFFFF
+
+/* NIC0_QM0_ARB_SLV_ID */
+#define NIC0_QM0_ARB_SLV_ID_VAL_SHIFT                                0
+#define NIC0_QM0_ARB_SLV_ID_VAL_MASK                                 0x1F
+
+/* NIC0_QM0_ARB_MSG_MAX_INFLIGHT */
+#define NIC0_QM0_ARB_MSG_MAX_INFLIGHT_VAL_SHIFT                      0
+#define NIC0_QM0_ARB_MSG_MAX_INFLIGHT_VAL_MASK                       0x3F
+
+/* NIC0_QM0_ARB_MSG_AWUSER_31_11 */
+#define NIC0_QM0_ARB_MSG_AWUSER_31_11_VAL_SHIFT                      0
+#define NIC0_QM0_ARB_MSG_AWUSER_31_11_VAL_MASK                       0x1FFFFF
+
+/* NIC0_QM0_ARB_MSG_AWUSER_SEC_PROP */
+#define NIC0_QM0_ARB_MSG_AWUSER_SEC_PROP_ASID_SHIFT                  0
+#define NIC0_QM0_ARB_MSG_AWUSER_SEC_PROP_ASID_MASK                   0x3FF
+#define NIC0_QM0_ARB_MSG_AWUSER_SEC_PROP_MMBP_SHIFT                  10
+#define NIC0_QM0_ARB_MSG_AWUSER_SEC_PROP_MMBP_MASK                   0x400
+
+/* NIC0_QM0_ARB_MSG_AWUSER_NON_SEC_PROP */
+#define NIC0_QM0_ARB_MSG_AWUSER_NON_SEC_PROP_ASID_SHIFT              0
+#define NIC0_QM0_ARB_MSG_AWUSER_NON_SEC_PROP_ASID_MASK               0x3FF
+#define NIC0_QM0_ARB_MSG_AWUSER_NON_SEC_PROP_MMBP_SHIFT              10
+#define NIC0_QM0_ARB_MSG_AWUSER_NON_SEC_PROP_MMBP_MASK               0x400
+
+/* NIC0_QM0_ARB_BASE_LO */
+#define NIC0_QM0_ARB_BASE_LO_VAL_SHIFT                               0
+#define NIC0_QM0_ARB_BASE_LO_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_ARB_BASE_HI */
+#define NIC0_QM0_ARB_BASE_HI_VAL_SHIFT                               0
+#define NIC0_QM0_ARB_BASE_HI_VAL_MASK                                0xFFFFFFFF
+
+/* NIC0_QM0_ARB_STATE_STS */
+#define NIC0_QM0_ARB_STATE_STS_VAL_SHIFT                             0
+#define NIC0_QM0_ARB_STATE_STS_VAL_MASK                              0xFFFFFFFF
+
+/* NIC0_QM0_ARB_CHOISE_FULLNESS_STS */
+#define NIC0_QM0_ARB_CHOISE_FULLNESS_STS_VAL_SHIFT                   0
+#define NIC0_QM0_ARB_CHOISE_FULLNESS_STS_VAL_MASK                    0x7F
+
+/* NIC0_QM0_ARB_MSG_STS */
+#define NIC0_QM0_ARB_MSG_STS_FULL_SHIFT                              0
+#define NIC0_QM0_ARB_MSG_STS_FULL_MASK                               0x1
+#define NIC0_QM0_ARB_MSG_STS_NO_INFLIGHT_SHIFT                       1
+#define NIC0_QM0_ARB_MSG_STS_NO_INFLIGHT_MASK                        0x2
+
+/* NIC0_QM0_ARB_SLV_CHOISE_Q_HEAD */
+#define NIC0_QM0_ARB_SLV_CHOISE_Q_HEAD_VAL_SHIFT                     0
+#define NIC0_QM0_ARB_SLV_CHOISE_Q_HEAD_VAL_MASK                      0x3
+
+/* NIC0_QM0_ARB_ERR_CAUSE */
+#define NIC0_QM0_ARB_ERR_CAUSE_CHOISE_OVF_SHIFT                      0
+#define NIC0_QM0_ARB_ERR_CAUSE_CHOISE_OVF_MASK                       0x1
+#define NIC0_QM0_ARB_ERR_CAUSE_CHOISE_WDT_SHIFT                      1
+#define NIC0_QM0_ARB_ERR_CAUSE_CHOISE_WDT_MASK                       0x2
+#define NIC0_QM0_ARB_ERR_CAUSE_AXI_LBW_ERR_SHIFT                     2
+#define NIC0_QM0_ARB_ERR_CAUSE_AXI_LBW_ERR_MASK                      0x4
+
+/* NIC0_QM0_ARB_ERR_MSG_EN */
+#define NIC0_QM0_ARB_ERR_MSG_EN_CHOISE_OVF_SHIFT                     0
+#define NIC0_QM0_ARB_ERR_MSG_EN_CHOISE_OVF_MASK                      0x1
+#define NIC0_QM0_ARB_ERR_MSG_EN_CHOISE_WDT_SHIFT                     1
+#define NIC0_QM0_ARB_ERR_MSG_EN_CHOISE_WDT_MASK                      0x2
+#define NIC0_QM0_ARB_ERR_MSG_EN_AXI_LBW_ERR_SHIFT                    2
+#define NIC0_QM0_ARB_ERR_MSG_EN_AXI_LBW_ERR_MASK                     0x4
+
+/* NIC0_QM0_ARB_ERR_STS_DRP */
+#define NIC0_QM0_ARB_ERR_STS_DRP_VAL_SHIFT                           0
+#define NIC0_QM0_ARB_ERR_STS_DRP_VAL_MASK                            0x3
+
+/* NIC0_QM0_ARB_MST_CRED_STS */
+#define NIC0_QM0_ARB_MST_CRED_STS_VAL_SHIFT                          0
+#define NIC0_QM0_ARB_MST_CRED_STS_VAL_MASK                           0x7F
+
+/* NIC0_QM0_CGM_CFG */
+#define NIC0_QM0_CGM_CFG_IDLE_TH_SHIFT                               0
+#define NIC0_QM0_CGM_CFG_IDLE_TH_MASK                                0xFFF
+#define NIC0_QM0_CGM_CFG_G2F_TH_SHIFT                                16
+#define NIC0_QM0_CGM_CFG_G2F_TH_MASK                                 0xFF0000
+#define NIC0_QM0_CGM_CFG_CP_IDLE_MASK_SHIFT                          24
+#define NIC0_QM0_CGM_CFG_CP_IDLE_MASK_MASK                           0x1F000000
+#define NIC0_QM0_CGM_CFG_EN_SHIFT                                    31
+#define NIC0_QM0_CGM_CFG_EN_MASK                                     0x80000000
+
+/* NIC0_QM0_CGM_STS */
+#define NIC0_QM0_CGM_STS_ST_SHIFT                                    0
+#define NIC0_QM0_CGM_STS_ST_MASK                                     0x3
+#define NIC0_QM0_CGM_STS_CG_SHIFT                                    4
+#define NIC0_QM0_CGM_STS_CG_MASK                                     0x10
+#define NIC0_QM0_CGM_STS_AGENT_IDLE_SHIFT                            8
+#define NIC0_QM0_CGM_STS_AGENT_IDLE_MASK                             0x100
+#define NIC0_QM0_CGM_STS_AXI_IDLE_SHIFT                              9
+#define NIC0_QM0_CGM_STS_AXI_IDLE_MASK                               0x200
+#define NIC0_QM0_CGM_STS_CP_IDLE_SHIFT                               10
+#define NIC0_QM0_CGM_STS_CP_IDLE_MASK                                0x400
+
+/* NIC0_QM0_CGM_CFG1 */
+#define NIC0_QM0_CGM_CFG1_MASK_TH_SHIFT                              0
+#define NIC0_QM0_CGM_CFG1_MASK_TH_MASK                               0xFF
+
+/* NIC0_QM0_LOCAL_RANGE_BASE */
+#define NIC0_QM0_LOCAL_RANGE_BASE_VAL_SHIFT                          0
+#define NIC0_QM0_LOCAL_RANGE_BASE_VAL_MASK                           0xFFFF
+
+/* NIC0_QM0_LOCAL_RANGE_SIZE */
+#define NIC0_QM0_LOCAL_RANGE_SIZE_VAL_SHIFT                          0
+#define NIC0_QM0_LOCAL_RANGE_SIZE_VAL_MASK                           0xFFFF
+
+/* NIC0_QM0_CSMR_STRICT_PRIO_CFG */
+#define NIC0_QM0_CSMR_STRICT_PRIO_CFG_TYPE_SHIFT                     0
+#define NIC0_QM0_CSMR_STRICT_PRIO_CFG_TYPE_MASK                      0x1
+
+/* NIC0_QM0_HBW_RD_RATE_LIM_CFG_1 */
+#define NIC0_QM0_HBW_RD_RATE_LIM_CFG_1_TOUT_SHIFT                    0
+#define NIC0_QM0_HBW_RD_RATE_LIM_CFG_1_TOUT_MASK                     0xFF
+#define NIC0_QM0_HBW_RD_RATE_LIM_CFG_1_EN_SHIFT                      31
+#define NIC0_QM0_HBW_RD_RATE_LIM_CFG_1_EN_MASK                       0x80000000
+
+/* NIC0_QM0_LBW_WR_RATE_LIM_CFG_0 */
+#define NIC0_QM0_LBW_WR_RATE_LIM_CFG_0_RST_TOKEN_SHIFT               0
+#define NIC0_QM0_LBW_WR_RATE_LIM_CFG_0_RST_TOKEN_MASK                0xFF
+#define NIC0_QM0_LBW_WR_RATE_LIM_CFG_0_SAT_SHIFT                     16
+#define NIC0_QM0_LBW_WR_RATE_LIM_CFG_0_SAT_MASK                      0xFF0000
+
+/* NIC0_QM0_LBW_WR_RATE_LIM_CFG_1 */
+#define NIC0_QM0_LBW_WR_RATE_LIM_CFG_1_TOUT_SHIFT                    0
+#define NIC0_QM0_LBW_WR_RATE_LIM_CFG_1_TOUT_MASK                     0xFF
+#define NIC0_QM0_LBW_WR_RATE_LIM_CFG_1_EN_SHIFT                      31
+#define NIC0_QM0_LBW_WR_RATE_LIM_CFG_1_EN_MASK                       0x80000000
+
+/* NIC0_QM0_HBW_RD_RATE_LIM_CFG_0 */
+#define NIC0_QM0_HBW_RD_RATE_LIM_CFG_0_RST_TOKEN_SHIFT               0
+#define NIC0_QM0_HBW_RD_RATE_LIM_CFG_0_RST_TOKEN_MASK                0xFF
+#define NIC0_QM0_HBW_RD_RATE_LIM_CFG_0_SAT_SHIFT                     16
+#define NIC0_QM0_HBW_RD_RATE_LIM_CFG_0_SAT_MASK                      0xFF0000
+
+/* NIC0_QM0_GLBL_AXCACHE */
+#define NIC0_QM0_GLBL_AXCACHE_AR_SHIFT                               0
+#define NIC0_QM0_GLBL_AXCACHE_AR_MASK                                0xF
+#define NIC0_QM0_GLBL_AXCACHE_AW_SHIFT                               16
+#define NIC0_QM0_GLBL_AXCACHE_AW_MASK                                0xF0000
+
+/* NIC0_QM0_IND_GW_APB_CFG */
+#define NIC0_QM0_IND_GW_APB_CFG_ADDR_SHIFT                           0
+#define NIC0_QM0_IND_GW_APB_CFG_ADDR_MASK                            0x7FFFFFFF
+#define NIC0_QM0_IND_GW_APB_CFG_CMD_SHIFT                            31
+#define NIC0_QM0_IND_GW_APB_CFG_CMD_MASK                             0x80000000
+
+/* NIC0_QM0_IND_GW_APB_WDATA */
+#define NIC0_QM0_IND_GW_APB_WDATA_VAL_SHIFT                          0
+#define NIC0_QM0_IND_GW_APB_WDATA_VAL_MASK                           0xFFFFFFFF
+
+/* NIC0_QM0_IND_GW_APB_RDATA */
+#define NIC0_QM0_IND_GW_APB_RDATA_VAL_SHIFT                          0
+#define NIC0_QM0_IND_GW_APB_RDATA_VAL_MASK                           0xFFFFFFFF
+
+/* NIC0_QM0_IND_GW_APB_STATUS */
+#define NIC0_QM0_IND_GW_APB_STATUS_RDY_SHIFT                         0
+#define NIC0_QM0_IND_GW_APB_STATUS_RDY_MASK                          0x1
+#define NIC0_QM0_IND_GW_APB_STATUS_ERR_SHIFT                         1
+#define NIC0_QM0_IND_GW_APB_STATUS_ERR_MASK                          0x2
+
+/* NIC0_QM0_GLBL_ERR_ADDR_LO */
+#define NIC0_QM0_GLBL_ERR_ADDR_LO_VAL_SHIFT                          0
+#define NIC0_QM0_GLBL_ERR_ADDR_LO_VAL_MASK                           0xFFFFFFFF
+
+/* NIC0_QM0_GLBL_ERR_ADDR_HI */
+#define NIC0_QM0_GLBL_ERR_ADDR_HI_VAL_SHIFT                          0
+#define NIC0_QM0_GLBL_ERR_ADDR_HI_VAL_MASK                           0xFFFFFFFF
+
+/* NIC0_QM0_GLBL_ERR_WDATA */
+#define NIC0_QM0_GLBL_ERR_WDATA_VAL_SHIFT                            0
+#define NIC0_QM0_GLBL_ERR_WDATA_VAL_MASK                             0xFFFFFFFF
+
+/* NIC0_QM0_GLBL_MEM_INIT_BUSY */
+#define NIC0_QM0_GLBL_MEM_INIT_BUSY_RBUF_SHIFT                       0
+#define NIC0_QM0_GLBL_MEM_INIT_BUSY_RBUF_MASK                        0xF
+
+#endif /* ASIC_REG_NIC0_QM0_MASKS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
new file mode 100644
index 000000000000..7c97f4041b8e
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_QM0_REGS_H_
+#define ASIC_REG_NIC0_QM0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_QM0 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC0_QM0_GLBL_CFG0                                         0xCE0000
+
+#define mmNIC0_QM0_GLBL_CFG1                                         0xCE0004
+
+#define mmNIC0_QM0_GLBL_PROT                                         0xCE0008
+
+#define mmNIC0_QM0_GLBL_ERR_CFG                                      0xCE000C
+
+#define mmNIC0_QM0_GLBL_SECURE_PROPS_0                               0xCE0010
+
+#define mmNIC0_QM0_GLBL_SECURE_PROPS_1                               0xCE0014
+
+#define mmNIC0_QM0_GLBL_SECURE_PROPS_2                               0xCE0018
+
+#define mmNIC0_QM0_GLBL_SECURE_PROPS_3                               0xCE001C
+
+#define mmNIC0_QM0_GLBL_SECURE_PROPS_4                               0xCE0020
+
+#define mmNIC0_QM0_GLBL_NON_SECURE_PROPS_0                           0xCE0024
+
+#define mmNIC0_QM0_GLBL_NON_SECURE_PROPS_1                           0xCE0028
+
+#define mmNIC0_QM0_GLBL_NON_SECURE_PROPS_2                           0xCE002C
+
+#define mmNIC0_QM0_GLBL_NON_SECURE_PROPS_3                           0xCE0030
+
+#define mmNIC0_QM0_GLBL_NON_SECURE_PROPS_4                           0xCE0034
+
+#define mmNIC0_QM0_GLBL_STS0                                         0xCE0038
+
+#define mmNIC0_QM0_GLBL_STS1_0                                       0xCE0040
+
+#define mmNIC0_QM0_GLBL_STS1_1                                       0xCE0044
+
+#define mmNIC0_QM0_GLBL_STS1_2                                       0xCE0048
+
+#define mmNIC0_QM0_GLBL_STS1_3                                       0xCE004C
+
+#define mmNIC0_QM0_GLBL_STS1_4                                       0xCE0050
+
+#define mmNIC0_QM0_GLBL_MSG_EN_0                                     0xCE0054
+
+#define mmNIC0_QM0_GLBL_MSG_EN_1                                     0xCE0058
+
+#define mmNIC0_QM0_GLBL_MSG_EN_2                                     0xCE005C
+
+#define mmNIC0_QM0_GLBL_MSG_EN_3                                     0xCE0060
+
+#define mmNIC0_QM0_GLBL_MSG_EN_4                                     0xCE0068
+
+#define mmNIC0_QM0_PQ_BASE_LO_0                                      0xCE0070
+
+#define mmNIC0_QM0_PQ_BASE_LO_1                                      0xCE0074
+
+#define mmNIC0_QM0_PQ_BASE_LO_2                                      0xCE0078
+
+#define mmNIC0_QM0_PQ_BASE_LO_3                                      0xCE007C
+
+#define mmNIC0_QM0_PQ_BASE_HI_0                                      0xCE0080
+
+#define mmNIC0_QM0_PQ_BASE_HI_1                                      0xCE0084
+
+#define mmNIC0_QM0_PQ_BASE_HI_2                                      0xCE0088
+
+#define mmNIC0_QM0_PQ_BASE_HI_3                                      0xCE008C
+
+#define mmNIC0_QM0_PQ_SIZE_0                                         0xCE0090
+
+#define mmNIC0_QM0_PQ_SIZE_1                                         0xCE0094
+
+#define mmNIC0_QM0_PQ_SIZE_2                                         0xCE0098
+
+#define mmNIC0_QM0_PQ_SIZE_3                                         0xCE009C
+
+#define mmNIC0_QM0_PQ_PI_0                                           0xCE00A0
+
+#define mmNIC0_QM0_PQ_PI_1                                           0xCE00A4
+
+#define mmNIC0_QM0_PQ_PI_2                                           0xCE00A8
+
+#define mmNIC0_QM0_PQ_PI_3                                           0xCE00AC
+
+#define mmNIC0_QM0_PQ_CI_0                                           0xCE00B0
+
+#define mmNIC0_QM0_PQ_CI_1                                           0xCE00B4
+
+#define mmNIC0_QM0_PQ_CI_2                                           0xCE00B8
+
+#define mmNIC0_QM0_PQ_CI_3                                           0xCE00BC
+
+#define mmNIC0_QM0_PQ_CFG0_0                                         0xCE00C0
+
+#define mmNIC0_QM0_PQ_CFG0_1                                         0xCE00C4
+
+#define mmNIC0_QM0_PQ_CFG0_2                                         0xCE00C8
+
+#define mmNIC0_QM0_PQ_CFG0_3                                         0xCE00CC
+
+#define mmNIC0_QM0_PQ_CFG1_0                                         0xCE00D0
+
+#define mmNIC0_QM0_PQ_CFG1_1                                         0xCE00D4
+
+#define mmNIC0_QM0_PQ_CFG1_2                                         0xCE00D8
+
+#define mmNIC0_QM0_PQ_CFG1_3                                         0xCE00DC
+
+#define mmNIC0_QM0_PQ_ARUSER_31_11_0                                 0xCE00E0
+
+#define mmNIC0_QM0_PQ_ARUSER_31_11_1                                 0xCE00E4
+
+#define mmNIC0_QM0_PQ_ARUSER_31_11_2                                 0xCE00E8
+
+#define mmNIC0_QM0_PQ_ARUSER_31_11_3                                 0xCE00EC
+
+#define mmNIC0_QM0_PQ_STS0_0                                         0xCE00F0
+
+#define mmNIC0_QM0_PQ_STS0_1                                         0xCE00F4
+
+#define mmNIC0_QM0_PQ_STS0_2                                         0xCE00F8
+
+#define mmNIC0_QM0_PQ_STS0_3                                         0xCE00FC
+
+#define mmNIC0_QM0_PQ_STS1_0                                         0xCE0100
+
+#define mmNIC0_QM0_PQ_STS1_1                                         0xCE0104
+
+#define mmNIC0_QM0_PQ_STS1_2                                         0xCE0108
+
+#define mmNIC0_QM0_PQ_STS1_3                                         0xCE010C
+
+#define mmNIC0_QM0_CQ_CFG0_0                                         0xCE0110
+
+#define mmNIC0_QM0_CQ_CFG0_1                                         0xCE0114
+
+#define mmNIC0_QM0_CQ_CFG0_2                                         0xCE0118
+
+#define mmNIC0_QM0_CQ_CFG0_3                                         0xCE011C
+
+#define mmNIC0_QM0_CQ_CFG0_4                                         0xCE0120
+
+#define mmNIC0_QM0_CQ_CFG1_0                                         0xCE0124
+
+#define mmNIC0_QM0_CQ_CFG1_1                                         0xCE0128
+
+#define mmNIC0_QM0_CQ_CFG1_2                                         0xCE012C
+
+#define mmNIC0_QM0_CQ_CFG1_3                                         0xCE0130
+
+#define mmNIC0_QM0_CQ_CFG1_4                                         0xCE0134
+
+#define mmNIC0_QM0_CQ_ARUSER_31_11_0                                 0xCE0138
+
+#define mmNIC0_QM0_CQ_ARUSER_31_11_1                                 0xCE013C
+
+#define mmNIC0_QM0_CQ_ARUSER_31_11_2                                 0xCE0140
+
+#define mmNIC0_QM0_CQ_ARUSER_31_11_3                                 0xCE0144
+
+#define mmNIC0_QM0_CQ_ARUSER_31_11_4                                 0xCE0148
+
+#define mmNIC0_QM0_CQ_STS0_0                                         0xCE014C
+
+#define mmNIC0_QM0_CQ_STS0_1                                         0xCE0150
+
+#define mmNIC0_QM0_CQ_STS0_2                                         0xCE0154
+
+#define mmNIC0_QM0_CQ_STS0_3                                         0xCE0158
+
+#define mmNIC0_QM0_CQ_STS0_4                                         0xCE015C
+
+#define mmNIC0_QM0_CQ_STS1_0                                         0xCE0160
+
+#define mmNIC0_QM0_CQ_STS1_1                                         0xCE0164
+
+#define mmNIC0_QM0_CQ_STS1_2                                         0xCE0168
+
+#define mmNIC0_QM0_CQ_STS1_3                                         0xCE016C
+
+#define mmNIC0_QM0_CQ_STS1_4                                         0xCE0170
+
+#define mmNIC0_QM0_CQ_PTR_LO_0                                       0xCE0174
+
+#define mmNIC0_QM0_CQ_PTR_HI_0                                       0xCE0178
+
+#define mmNIC0_QM0_CQ_TSIZE_0                                        0xCE017C
+
+#define mmNIC0_QM0_CQ_CTL_0                                          0xCE0180
+
+#define mmNIC0_QM0_CQ_PTR_LO_1                                       0xCE0184
+
+#define mmNIC0_QM0_CQ_PTR_HI_1                                       0xCE0188
+
+#define mmNIC0_QM0_CQ_TSIZE_1                                        0xCE018C
+
+#define mmNIC0_QM0_CQ_CTL_1                                          0xCE0190
+
+#define mmNIC0_QM0_CQ_PTR_LO_2                                       0xCE0194
+
+#define mmNIC0_QM0_CQ_PTR_HI_2                                       0xCE0198
+
+#define mmNIC0_QM0_CQ_TSIZE_2                                        0xCE019C
+
+#define mmNIC0_QM0_CQ_CTL_2                                          0xCE01A0
+
+#define mmNIC0_QM0_CQ_PTR_LO_3                                       0xCE01A4
+
+#define mmNIC0_QM0_CQ_PTR_HI_3                                       0xCE01A8
+
+#define mmNIC0_QM0_CQ_TSIZE_3                                        0xCE01AC
+
+#define mmNIC0_QM0_CQ_CTL_3                                          0xCE01B0
+
+#define mmNIC0_QM0_CQ_PTR_LO_4                                       0xCE01B4
+
+#define mmNIC0_QM0_CQ_PTR_HI_4                                       0xCE01B8
+
+#define mmNIC0_QM0_CQ_TSIZE_4                                        0xCE01BC
+
+#define mmNIC0_QM0_CQ_CTL_4                                          0xCE01C0
+
+#define mmNIC0_QM0_CQ_PTR_LO_STS_0                                   0xCE01C4
+
+#define mmNIC0_QM0_CQ_PTR_LO_STS_1                                   0xCE01C8
+
+#define mmNIC0_QM0_CQ_PTR_LO_STS_2                                   0xCE01CC
+
+#define mmNIC0_QM0_CQ_PTR_LO_STS_3                                   0xCE01D0
+
+#define mmNIC0_QM0_CQ_PTR_LO_STS_4                                   0xCE01D4
+
+#define mmNIC0_QM0_CQ_PTR_HI_STS_0                                   0xCE01D8
+
+#define mmNIC0_QM0_CQ_PTR_HI_STS_1                                   0xCE01DC
+
+#define mmNIC0_QM0_CQ_PTR_HI_STS_2                                   0xCE01E0
+
+#define mmNIC0_QM0_CQ_PTR_HI_STS_3                                   0xCE01E4
+
+#define mmNIC0_QM0_CQ_PTR_HI_STS_4                                   0xCE01E8
+
+#define mmNIC0_QM0_CQ_TSIZE_STS_0                                    0xCE01EC
+
+#define mmNIC0_QM0_CQ_TSIZE_STS_1                                    0xCE01F0
+
+#define mmNIC0_QM0_CQ_TSIZE_STS_2                                    0xCE01F4
+
+#define mmNIC0_QM0_CQ_TSIZE_STS_3                                    0xCE01F8
+
+#define mmNIC0_QM0_CQ_TSIZE_STS_4                                    0xCE01FC
+
+#define mmNIC0_QM0_CQ_CTL_STS_0                                      0xCE0200
+
+#define mmNIC0_QM0_CQ_CTL_STS_1                                      0xCE0204
+
+#define mmNIC0_QM0_CQ_CTL_STS_2                                      0xCE0208
+
+#define mmNIC0_QM0_CQ_CTL_STS_3                                      0xCE020C
+
+#define mmNIC0_QM0_CQ_CTL_STS_4                                      0xCE0210
+
+#define mmNIC0_QM0_CQ_IFIFO_CNT_0                                    0xCE0214
+
+#define mmNIC0_QM0_CQ_IFIFO_CNT_1                                    0xCE0218
+
+#define mmNIC0_QM0_CQ_IFIFO_CNT_2                                    0xCE021C
+
+#define mmNIC0_QM0_CQ_IFIFO_CNT_3                                    0xCE0220
+
+#define mmNIC0_QM0_CQ_IFIFO_CNT_4                                    0xCE0224
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_0                            0xCE0228
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_1                            0xCE022C
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_2                            0xCE0230
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_3                            0xCE0234
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_LO_4                            0xCE0238
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_0                            0xCE023C
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_1                            0xCE0240
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_2                            0xCE0244
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_3                            0xCE0248
+
+#define mmNIC0_QM0_CP_MSG_BASE0_ADDR_HI_4                            0xCE024C
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_0                            0xCE0250
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_1                            0xCE0254
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_2                            0xCE0258
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_3                            0xCE025C
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_LO_4                            0xCE0260
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_0                            0xCE0264
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_1                            0xCE0268
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_2                            0xCE026C
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_3                            0xCE0270
+
+#define mmNIC0_QM0_CP_MSG_BASE1_ADDR_HI_4                            0xCE0274
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_0                            0xCE0278
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_1                            0xCE027C
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_2                            0xCE0280
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_3                            0xCE0284
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_LO_4                            0xCE0288
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_0                            0xCE028C
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_1                            0xCE0290
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_2                            0xCE0294
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_3                            0xCE0298
+
+#define mmNIC0_QM0_CP_MSG_BASE2_ADDR_HI_4                            0xCE029C
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_0                            0xCE02A0
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_1                            0xCE02A4
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_2                            0xCE02A8
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_3                            0xCE02AC
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_LO_4                            0xCE02B0
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_0                            0xCE02B4
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_1                            0xCE02B8
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_2                            0xCE02BC
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_3                            0xCE02C0
+
+#define mmNIC0_QM0_CP_MSG_BASE3_ADDR_HI_4                            0xCE02C4
+
+#define mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_0                            0xCE02C8
+
+#define mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_1                            0xCE02CC
+
+#define mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_2                            0xCE02D0
+
+#define mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_3                            0xCE02D4
+
+#define mmNIC0_QM0_CP_LDMA_TSIZE_OFFSET_4                            0xCE02D8
+
+#define mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xCE02E0
+
+#define mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xCE02E4
+
+#define mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xCE02E8
+
+#define mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xCE02EC
+
+#define mmNIC0_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xCE02F0
+
+#define mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xCE02F4
+
+#define mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xCE02F8
+
+#define mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xCE02FC
+
+#define mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xCE0300
+
+#define mmNIC0_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xCE0304
+
+#define mmNIC0_QM0_CP_FENCE0_RDATA_0                                 0xCE0308
+
+#define mmNIC0_QM0_CP_FENCE0_RDATA_1                                 0xCE030C
+
+#define mmNIC0_QM0_CP_FENCE0_RDATA_2                                 0xCE0310
+
+#define mmNIC0_QM0_CP_FENCE0_RDATA_3                                 0xCE0314
+
+#define mmNIC0_QM0_CP_FENCE0_RDATA_4                                 0xCE0318
+
+#define mmNIC0_QM0_CP_FENCE1_RDATA_0                                 0xCE031C
+
+#define mmNIC0_QM0_CP_FENCE1_RDATA_1                                 0xCE0320
+
+#define mmNIC0_QM0_CP_FENCE1_RDATA_2                                 0xCE0324
+
+#define mmNIC0_QM0_CP_FENCE1_RDATA_3                                 0xCE0328
+
+#define mmNIC0_QM0_CP_FENCE1_RDATA_4                                 0xCE032C
+
+#define mmNIC0_QM0_CP_FENCE2_RDATA_0                                 0xCE0330
+
+#define mmNIC0_QM0_CP_FENCE2_RDATA_1                                 0xCE0334
+
+#define mmNIC0_QM0_CP_FENCE2_RDATA_2                                 0xCE0338
+
+#define mmNIC0_QM0_CP_FENCE2_RDATA_3                                 0xCE033C
+
+#define mmNIC0_QM0_CP_FENCE2_RDATA_4                                 0xCE0340
+
+#define mmNIC0_QM0_CP_FENCE3_RDATA_0                                 0xCE0344
+
+#define mmNIC0_QM0_CP_FENCE3_RDATA_1                                 0xCE0348
+
+#define mmNIC0_QM0_CP_FENCE3_RDATA_2                                 0xCE034C
+
+#define mmNIC0_QM0_CP_FENCE3_RDATA_3                                 0xCE0350
+
+#define mmNIC0_QM0_CP_FENCE3_RDATA_4                                 0xCE0354
+
+#define mmNIC0_QM0_CP_FENCE0_CNT_0                                   0xCE0358
+
+#define mmNIC0_QM0_CP_FENCE0_CNT_1                                   0xCE035C
+
+#define mmNIC0_QM0_CP_FENCE0_CNT_2                                   0xCE0360
+
+#define mmNIC0_QM0_CP_FENCE0_CNT_3                                   0xCE0364
+
+#define mmNIC0_QM0_CP_FENCE0_CNT_4                                   0xCE0368
+
+#define mmNIC0_QM0_CP_FENCE1_CNT_0                                   0xCE036C
+
+#define mmNIC0_QM0_CP_FENCE1_CNT_1                                   0xCE0370
+
+#define mmNIC0_QM0_CP_FENCE1_CNT_2                                   0xCE0374
+
+#define mmNIC0_QM0_CP_FENCE1_CNT_3                                   0xCE0378
+
+#define mmNIC0_QM0_CP_FENCE1_CNT_4                                   0xCE037C
+
+#define mmNIC0_QM0_CP_FENCE2_CNT_0                                   0xCE0380
+
+#define mmNIC0_QM0_CP_FENCE2_CNT_1                                   0xCE0384
+
+#define mmNIC0_QM0_CP_FENCE2_CNT_2                                   0xCE0388
+
+#define mmNIC0_QM0_CP_FENCE2_CNT_3                                   0xCE038C
+
+#define mmNIC0_QM0_CP_FENCE2_CNT_4                                   0xCE0390
+
+#define mmNIC0_QM0_CP_FENCE3_CNT_0                                   0xCE0394
+
+#define mmNIC0_QM0_CP_FENCE3_CNT_1                                   0xCE0398
+
+#define mmNIC0_QM0_CP_FENCE3_CNT_2                                   0xCE039C
+
+#define mmNIC0_QM0_CP_FENCE3_CNT_3                                   0xCE03A0
+
+#define mmNIC0_QM0_CP_FENCE3_CNT_4                                   0xCE03A4
+
+#define mmNIC0_QM0_CP_STS_0                                          0xCE03A8
+
+#define mmNIC0_QM0_CP_STS_1                                          0xCE03AC
+
+#define mmNIC0_QM0_CP_STS_2                                          0xCE03B0
+
+#define mmNIC0_QM0_CP_STS_3                                          0xCE03B4
+
+#define mmNIC0_QM0_CP_STS_4                                          0xCE03B8
+
+#define mmNIC0_QM0_CP_CURRENT_INST_LO_0                              0xCE03BC
+
+#define mmNIC0_QM0_CP_CURRENT_INST_LO_1                              0xCE03C0
+
+#define mmNIC0_QM0_CP_CURRENT_INST_LO_2                              0xCE03C4
+
+#define mmNIC0_QM0_CP_CURRENT_INST_LO_3                              0xCE03C8
+
+#define mmNIC0_QM0_CP_CURRENT_INST_LO_4                              0xCE03CC
+
+#define mmNIC0_QM0_CP_CURRENT_INST_HI_0                              0xCE03D0
+
+#define mmNIC0_QM0_CP_CURRENT_INST_HI_1                              0xCE03D4
+
+#define mmNIC0_QM0_CP_CURRENT_INST_HI_2                              0xCE03D8
+
+#define mmNIC0_QM0_CP_CURRENT_INST_HI_3                              0xCE03DC
+
+#define mmNIC0_QM0_CP_CURRENT_INST_HI_4                              0xCE03E0
+
+#define mmNIC0_QM0_CP_BARRIER_CFG_0                                  0xCE03F4
+
+#define mmNIC0_QM0_CP_BARRIER_CFG_1                                  0xCE03F8
+
+#define mmNIC0_QM0_CP_BARRIER_CFG_2                                  0xCE03FC
+
+#define mmNIC0_QM0_CP_BARRIER_CFG_3                                  0xCE0400
+
+#define mmNIC0_QM0_CP_BARRIER_CFG_4                                  0xCE0404
+
+#define mmNIC0_QM0_CP_DBG_0_0                                        0xCE0408
+
+#define mmNIC0_QM0_CP_DBG_0_1                                        0xCE040C
+
+#define mmNIC0_QM0_CP_DBG_0_2                                        0xCE0410
+
+#define mmNIC0_QM0_CP_DBG_0_3                                        0xCE0414
+
+#define mmNIC0_QM0_CP_DBG_0_4                                        0xCE0418
+
+#define mmNIC0_QM0_CP_ARUSER_31_11_0                                 0xCE041C
+
+#define mmNIC0_QM0_CP_ARUSER_31_11_1                                 0xCE0420
+
+#define mmNIC0_QM0_CP_ARUSER_31_11_2                                 0xCE0424
+
+#define mmNIC0_QM0_CP_ARUSER_31_11_3                                 0xCE0428
+
+#define mmNIC0_QM0_CP_ARUSER_31_11_4                                 0xCE042C
+
+#define mmNIC0_QM0_CP_AWUSER_31_11_0                                 0xCE0430
+
+#define mmNIC0_QM0_CP_AWUSER_31_11_1                                 0xCE0434
+
+#define mmNIC0_QM0_CP_AWUSER_31_11_2                                 0xCE0438
+
+#define mmNIC0_QM0_CP_AWUSER_31_11_3                                 0xCE043C
+
+#define mmNIC0_QM0_CP_AWUSER_31_11_4                                 0xCE0440
+
+#define mmNIC0_QM0_ARB_CFG_0                                         0xCE0A00
+
+#define mmNIC0_QM0_ARB_CHOISE_Q_PUSH                                 0xCE0A04
+
+#define mmNIC0_QM0_ARB_WRR_WEIGHT_0                                  0xCE0A08
+
+#define mmNIC0_QM0_ARB_WRR_WEIGHT_1                                  0xCE0A0C
+
+#define mmNIC0_QM0_ARB_WRR_WEIGHT_2                                  0xCE0A10
+
+#define mmNIC0_QM0_ARB_WRR_WEIGHT_3                                  0xCE0A14
+
+#define mmNIC0_QM0_ARB_CFG_1                                         0xCE0A18
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_0                              0xCE0A20
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_1                              0xCE0A24
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_2                              0xCE0A28
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_3                              0xCE0A2C
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_4                              0xCE0A30
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_5                              0xCE0A34
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_6                              0xCE0A38
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_7                              0xCE0A3C
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_8                              0xCE0A40
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_9                              0xCE0A44
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_10                             0xCE0A48
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_11                             0xCE0A4C
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_12                             0xCE0A50
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_13                             0xCE0A54
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_14                             0xCE0A58
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_15                             0xCE0A5C
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_16                             0xCE0A60
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_17                             0xCE0A64
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_18                             0xCE0A68
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_19                             0xCE0A6C
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_20                             0xCE0A70
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_21                             0xCE0A74
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_22                             0xCE0A78
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_23                             0xCE0A7C
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_24                             0xCE0A80
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_25                             0xCE0A84
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_26                             0xCE0A88
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_27                             0xCE0A8C
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_28                             0xCE0A90
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_29                             0xCE0A94
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_30                             0xCE0A98
+
+#define mmNIC0_QM0_ARB_MST_AVAIL_CRED_31                             0xCE0A9C
+
+#define mmNIC0_QM0_ARB_MST_CRED_INC                                  0xCE0AA0
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_0                        0xCE0AA4
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_1                        0xCE0AA8
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_2                        0xCE0AAC
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_3                        0xCE0AB0
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_4                        0xCE0AB4
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_5                        0xCE0AB8
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_6                        0xCE0ABC
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_7                        0xCE0AC0
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_8                        0xCE0AC4
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_9                        0xCE0AC8
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_10                       0xCE0ACC
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_11                       0xCE0AD0
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_12                       0xCE0AD4
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_13                       0xCE0AD8
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_14                       0xCE0ADC
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_15                       0xCE0AE0
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_16                       0xCE0AE4
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_17                       0xCE0AE8
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_18                       0xCE0AEC
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_19                       0xCE0AF0
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_20                       0xCE0AF4
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_21                       0xCE0AF8
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_22                       0xCE0AFC
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_23                       0xCE0B00
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_24                       0xCE0B04
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_25                       0xCE0B08
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_26                       0xCE0B0C
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_27                       0xCE0B10
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_28                       0xCE0B14
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_29                       0xCE0B18
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_30                       0xCE0B1C
+
+#define mmNIC0_QM0_ARB_MST_CHOISE_PUSH_OFST_31                       0xCE0B20
+
+#define mmNIC0_QM0_ARB_SLV_MASTER_INC_CRED_OFST                      0xCE0B28
+
+#define mmNIC0_QM0_ARB_MST_SLAVE_EN                                  0xCE0B2C
+
+#define mmNIC0_QM0_ARB_MST_QUIET_PER                                 0xCE0B34
+
+#define mmNIC0_QM0_ARB_SLV_CHOISE_WDT                                0xCE0B38
+
+#define mmNIC0_QM0_ARB_SLV_ID                                        0xCE0B3C
+
+#define mmNIC0_QM0_ARB_MSG_MAX_INFLIGHT                              0xCE0B44
+
+#define mmNIC0_QM0_ARB_MSG_AWUSER_31_11                              0xCE0B48
+
+#define mmNIC0_QM0_ARB_MSG_AWUSER_SEC_PROP                           0xCE0B4C
+
+#define mmNIC0_QM0_ARB_MSG_AWUSER_NON_SEC_PROP                       0xCE0B50
+
+#define mmNIC0_QM0_ARB_BASE_LO                                       0xCE0B54
+
+#define mmNIC0_QM0_ARB_BASE_HI                                       0xCE0B58
+
+#define mmNIC0_QM0_ARB_STATE_STS                                     0xCE0B80
+
+#define mmNIC0_QM0_ARB_CHOISE_FULLNESS_STS                           0xCE0B84
+
+#define mmNIC0_QM0_ARB_MSG_STS                                       0xCE0B88
+
+#define mmNIC0_QM0_ARB_SLV_CHOISE_Q_HEAD                             0xCE0B8C
+
+#define mmNIC0_QM0_ARB_ERR_CAUSE                                     0xCE0B9C
+
+#define mmNIC0_QM0_ARB_ERR_MSG_EN                                    0xCE0BA0
+
+#define mmNIC0_QM0_ARB_ERR_STS_DRP                                   0xCE0BA8
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_0                                0xCE0BB0
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_1                                0xCE0BB4
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_2                                0xCE0BB8
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_3                                0xCE0BBC
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_4                                0xCE0BC0
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_5                                0xCE0BC4
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_6                                0xCE0BC8
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_7                                0xCE0BCC
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_8                                0xCE0BD0
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_9                                0xCE0BD4
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_10                               0xCE0BD8
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_11                               0xCE0BDC
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_12                               0xCE0BE0
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_13                               0xCE0BE4
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_14                               0xCE0BE8
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_15                               0xCE0BEC
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_16                               0xCE0BF0
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_17                               0xCE0BF4
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_18                               0xCE0BF8
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_19                               0xCE0BFC
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_20                               0xCE0C00
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_21                               0xCE0C04
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_22                               0xCE0C08
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_23                               0xCE0C0C
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_24                               0xCE0C10
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_25                               0xCE0C14
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_26                               0xCE0C18
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_27                               0xCE0C1C
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_28                               0xCE0C20
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_29                               0xCE0C24
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_30                               0xCE0C28
+
+#define mmNIC0_QM0_ARB_MST_CRED_STS_31                               0xCE0C2C
+
+#define mmNIC0_QM0_CGM_CFG                                           0xCE0C70
+
+#define mmNIC0_QM0_CGM_STS                                           0xCE0C74
+
+#define mmNIC0_QM0_CGM_CFG1                                          0xCE0C78
+
+#define mmNIC0_QM0_LOCAL_RANGE_BASE                                  0xCE0C80
+
+#define mmNIC0_QM0_LOCAL_RANGE_SIZE                                  0xCE0C84
+
+#define mmNIC0_QM0_CSMR_STRICT_PRIO_CFG                              0xCE0C90
+
+#define mmNIC0_QM0_HBW_RD_RATE_LIM_CFG_1                             0xCE0C94
+
+#define mmNIC0_QM0_LBW_WR_RATE_LIM_CFG_0                             0xCE0C98
+
+#define mmNIC0_QM0_LBW_WR_RATE_LIM_CFG_1                             0xCE0C9C
+
+#define mmNIC0_QM0_HBW_RD_RATE_LIM_CFG_0                             0xCE0CA0
+
+#define mmNIC0_QM0_GLBL_AXCACHE                                      0xCE0CA4
+
+#define mmNIC0_QM0_IND_GW_APB_CFG                                    0xCE0CB0
+
+#define mmNIC0_QM0_IND_GW_APB_WDATA                                  0xCE0CB4
+
+#define mmNIC0_QM0_IND_GW_APB_RDATA                                  0xCE0CB8
+
+#define mmNIC0_QM0_IND_GW_APB_STATUS                                 0xCE0CBC
+
+#define mmNIC0_QM0_GLBL_ERR_ADDR_LO                                  0xCE0CD0
+
+#define mmNIC0_QM0_GLBL_ERR_ADDR_HI                                  0xCE0CD4
+
+#define mmNIC0_QM0_GLBL_ERR_WDATA                                    0xCE0CD8
+
+#define mmNIC0_QM0_GLBL_MEM_INIT_BUSY                                0xCE0D00
+
+#endif /* ASIC_REG_NIC0_QM0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
new file mode 100644
index 000000000000..fe96c575b5c6
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_QM1_REGS_H_
+#define ASIC_REG_NIC0_QM1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_QM1 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC0_QM1_GLBL_CFG0                                         0xCE2000
+
+#define mmNIC0_QM1_GLBL_CFG1                                         0xCE2004
+
+#define mmNIC0_QM1_GLBL_PROT                                         0xCE2008
+
+#define mmNIC0_QM1_GLBL_ERR_CFG                                      0xCE200C
+
+#define mmNIC0_QM1_GLBL_SECURE_PROPS_0                               0xCE2010
+
+#define mmNIC0_QM1_GLBL_SECURE_PROPS_1                               0xCE2014
+
+#define mmNIC0_QM1_GLBL_SECURE_PROPS_2                               0xCE2018
+
+#define mmNIC0_QM1_GLBL_SECURE_PROPS_3                               0xCE201C
+
+#define mmNIC0_QM1_GLBL_SECURE_PROPS_4                               0xCE2020
+
+#define mmNIC0_QM1_GLBL_NON_SECURE_PROPS_0                           0xCE2024
+
+#define mmNIC0_QM1_GLBL_NON_SECURE_PROPS_1                           0xCE2028
+
+#define mmNIC0_QM1_GLBL_NON_SECURE_PROPS_2                           0xCE202C
+
+#define mmNIC0_QM1_GLBL_NON_SECURE_PROPS_3                           0xCE2030
+
+#define mmNIC0_QM1_GLBL_NON_SECURE_PROPS_4                           0xCE2034
+
+#define mmNIC0_QM1_GLBL_STS0                                         0xCE2038
+
+#define mmNIC0_QM1_GLBL_STS1_0                                       0xCE2040
+
+#define mmNIC0_QM1_GLBL_STS1_1                                       0xCE2044
+
+#define mmNIC0_QM1_GLBL_STS1_2                                       0xCE2048
+
+#define mmNIC0_QM1_GLBL_STS1_3                                       0xCE204C
+
+#define mmNIC0_QM1_GLBL_STS1_4                                       0xCE2050
+
+#define mmNIC0_QM1_GLBL_MSG_EN_0                                     0xCE2054
+
+#define mmNIC0_QM1_GLBL_MSG_EN_1                                     0xCE2058
+
+#define mmNIC0_QM1_GLBL_MSG_EN_2                                     0xCE205C
+
+#define mmNIC0_QM1_GLBL_MSG_EN_3                                     0xCE2060
+
+#define mmNIC0_QM1_GLBL_MSG_EN_4                                     0xCE2068
+
+#define mmNIC0_QM1_PQ_BASE_LO_0                                      0xCE2070
+
+#define mmNIC0_QM1_PQ_BASE_LO_1                                      0xCE2074
+
+#define mmNIC0_QM1_PQ_BASE_LO_2                                      0xCE2078
+
+#define mmNIC0_QM1_PQ_BASE_LO_3                                      0xCE207C
+
+#define mmNIC0_QM1_PQ_BASE_HI_0                                      0xCE2080
+
+#define mmNIC0_QM1_PQ_BASE_HI_1                                      0xCE2084
+
+#define mmNIC0_QM1_PQ_BASE_HI_2                                      0xCE2088
+
+#define mmNIC0_QM1_PQ_BASE_HI_3                                      0xCE208C
+
+#define mmNIC0_QM1_PQ_SIZE_0                                         0xCE2090
+
+#define mmNIC0_QM1_PQ_SIZE_1                                         0xCE2094
+
+#define mmNIC0_QM1_PQ_SIZE_2                                         0xCE2098
+
+#define mmNIC0_QM1_PQ_SIZE_3                                         0xCE209C
+
+#define mmNIC0_QM1_PQ_PI_0                                           0xCE20A0
+
+#define mmNIC0_QM1_PQ_PI_1                                           0xCE20A4
+
+#define mmNIC0_QM1_PQ_PI_2                                           0xCE20A8
+
+#define mmNIC0_QM1_PQ_PI_3                                           0xCE20AC
+
+#define mmNIC0_QM1_PQ_CI_0                                           0xCE20B0
+
+#define mmNIC0_QM1_PQ_CI_1                                           0xCE20B4
+
+#define mmNIC0_QM1_PQ_CI_2                                           0xCE20B8
+
+#define mmNIC0_QM1_PQ_CI_3                                           0xCE20BC
+
+#define mmNIC0_QM1_PQ_CFG0_0                                         0xCE20C0
+
+#define mmNIC0_QM1_PQ_CFG0_1                                         0xCE20C4
+
+#define mmNIC0_QM1_PQ_CFG0_2                                         0xCE20C8
+
+#define mmNIC0_QM1_PQ_CFG0_3                                         0xCE20CC
+
+#define mmNIC0_QM1_PQ_CFG1_0                                         0xCE20D0
+
+#define mmNIC0_QM1_PQ_CFG1_1                                         0xCE20D4
+
+#define mmNIC0_QM1_PQ_CFG1_2                                         0xCE20D8
+
+#define mmNIC0_QM1_PQ_CFG1_3                                         0xCE20DC
+
+#define mmNIC0_QM1_PQ_ARUSER_31_11_0                                 0xCE20E0
+
+#define mmNIC0_QM1_PQ_ARUSER_31_11_1                                 0xCE20E4
+
+#define mmNIC0_QM1_PQ_ARUSER_31_11_2                                 0xCE20E8
+
+#define mmNIC0_QM1_PQ_ARUSER_31_11_3                                 0xCE20EC
+
+#define mmNIC0_QM1_PQ_STS0_0                                         0xCE20F0
+
+#define mmNIC0_QM1_PQ_STS0_1                                         0xCE20F4
+
+#define mmNIC0_QM1_PQ_STS0_2                                         0xCE20F8
+
+#define mmNIC0_QM1_PQ_STS0_3                                         0xCE20FC
+
+#define mmNIC0_QM1_PQ_STS1_0                                         0xCE2100
+
+#define mmNIC0_QM1_PQ_STS1_1                                         0xCE2104
+
+#define mmNIC0_QM1_PQ_STS1_2                                         0xCE2108
+
+#define mmNIC0_QM1_PQ_STS1_3                                         0xCE210C
+
+#define mmNIC0_QM1_CQ_CFG0_0                                         0xCE2110
+
+#define mmNIC0_QM1_CQ_CFG0_1                                         0xCE2114
+
+#define mmNIC0_QM1_CQ_CFG0_2                                         0xCE2118
+
+#define mmNIC0_QM1_CQ_CFG0_3                                         0xCE211C
+
+#define mmNIC0_QM1_CQ_CFG0_4                                         0xCE2120
+
+#define mmNIC0_QM1_CQ_CFG1_0                                         0xCE2124
+
+#define mmNIC0_QM1_CQ_CFG1_1                                         0xCE2128
+
+#define mmNIC0_QM1_CQ_CFG1_2                                         0xCE212C
+
+#define mmNIC0_QM1_CQ_CFG1_3                                         0xCE2130
+
+#define mmNIC0_QM1_CQ_CFG1_4                                         0xCE2134
+
+#define mmNIC0_QM1_CQ_ARUSER_31_11_0                                 0xCE2138
+
+#define mmNIC0_QM1_CQ_ARUSER_31_11_1                                 0xCE213C
+
+#define mmNIC0_QM1_CQ_ARUSER_31_11_2                                 0xCE2140
+
+#define mmNIC0_QM1_CQ_ARUSER_31_11_3                                 0xCE2144
+
+#define mmNIC0_QM1_CQ_ARUSER_31_11_4                                 0xCE2148
+
+#define mmNIC0_QM1_CQ_STS0_0                                         0xCE214C
+
+#define mmNIC0_QM1_CQ_STS0_1                                         0xCE2150
+
+#define mmNIC0_QM1_CQ_STS0_2                                         0xCE2154
+
+#define mmNIC0_QM1_CQ_STS0_3                                         0xCE2158
+
+#define mmNIC0_QM1_CQ_STS0_4                                         0xCE215C
+
+#define mmNIC0_QM1_CQ_STS1_0                                         0xCE2160
+
+#define mmNIC0_QM1_CQ_STS1_1                                         0xCE2164
+
+#define mmNIC0_QM1_CQ_STS1_2                                         0xCE2168
+
+#define mmNIC0_QM1_CQ_STS1_3                                         0xCE216C
+
+#define mmNIC0_QM1_CQ_STS1_4                                         0xCE2170
+
+#define mmNIC0_QM1_CQ_PTR_LO_0                                       0xCE2174
+
+#define mmNIC0_QM1_CQ_PTR_HI_0                                       0xCE2178
+
+#define mmNIC0_QM1_CQ_TSIZE_0                                        0xCE217C
+
+#define mmNIC0_QM1_CQ_CTL_0                                          0xCE2180
+
+#define mmNIC0_QM1_CQ_PTR_LO_1                                       0xCE2184
+
+#define mmNIC0_QM1_CQ_PTR_HI_1                                       0xCE2188
+
+#define mmNIC0_QM1_CQ_TSIZE_1                                        0xCE218C
+
+#define mmNIC0_QM1_CQ_CTL_1                                          0xCE2190
+
+#define mmNIC0_QM1_CQ_PTR_LO_2                                       0xCE2194
+
+#define mmNIC0_QM1_CQ_PTR_HI_2                                       0xCE2198
+
+#define mmNIC0_QM1_CQ_TSIZE_2                                        0xCE219C
+
+#define mmNIC0_QM1_CQ_CTL_2                                          0xCE21A0
+
+#define mmNIC0_QM1_CQ_PTR_LO_3                                       0xCE21A4
+
+#define mmNIC0_QM1_CQ_PTR_HI_3                                       0xCE21A8
+
+#define mmNIC0_QM1_CQ_TSIZE_3                                        0xCE21AC
+
+#define mmNIC0_QM1_CQ_CTL_3                                          0xCE21B0
+
+#define mmNIC0_QM1_CQ_PTR_LO_4                                       0xCE21B4
+
+#define mmNIC0_QM1_CQ_PTR_HI_4                                       0xCE21B8
+
+#define mmNIC0_QM1_CQ_TSIZE_4                                        0xCE21BC
+
+#define mmNIC0_QM1_CQ_CTL_4                                          0xCE21C0
+
+#define mmNIC0_QM1_CQ_PTR_LO_STS_0                                   0xCE21C4
+
+#define mmNIC0_QM1_CQ_PTR_LO_STS_1                                   0xCE21C8
+
+#define mmNIC0_QM1_CQ_PTR_LO_STS_2                                   0xCE21CC
+
+#define mmNIC0_QM1_CQ_PTR_LO_STS_3                                   0xCE21D0
+
+#define mmNIC0_QM1_CQ_PTR_LO_STS_4                                   0xCE21D4
+
+#define mmNIC0_QM1_CQ_PTR_HI_STS_0                                   0xCE21D8
+
+#define mmNIC0_QM1_CQ_PTR_HI_STS_1                                   0xCE21DC
+
+#define mmNIC0_QM1_CQ_PTR_HI_STS_2                                   0xCE21E0
+
+#define mmNIC0_QM1_CQ_PTR_HI_STS_3                                   0xCE21E4
+
+#define mmNIC0_QM1_CQ_PTR_HI_STS_4                                   0xCE21E8
+
+#define mmNIC0_QM1_CQ_TSIZE_STS_0                                    0xCE21EC
+
+#define mmNIC0_QM1_CQ_TSIZE_STS_1                                    0xCE21F0
+
+#define mmNIC0_QM1_CQ_TSIZE_STS_2                                    0xCE21F4
+
+#define mmNIC0_QM1_CQ_TSIZE_STS_3                                    0xCE21F8
+
+#define mmNIC0_QM1_CQ_TSIZE_STS_4                                    0xCE21FC
+
+#define mmNIC0_QM1_CQ_CTL_STS_0                                      0xCE2200
+
+#define mmNIC0_QM1_CQ_CTL_STS_1                                      0xCE2204
+
+#define mmNIC0_QM1_CQ_CTL_STS_2                                      0xCE2208
+
+#define mmNIC0_QM1_CQ_CTL_STS_3                                      0xCE220C
+
+#define mmNIC0_QM1_CQ_CTL_STS_4                                      0xCE2210
+
+#define mmNIC0_QM1_CQ_IFIFO_CNT_0                                    0xCE2214
+
+#define mmNIC0_QM1_CQ_IFIFO_CNT_1                                    0xCE2218
+
+#define mmNIC0_QM1_CQ_IFIFO_CNT_2                                    0xCE221C
+
+#define mmNIC0_QM1_CQ_IFIFO_CNT_3                                    0xCE2220
+
+#define mmNIC0_QM1_CQ_IFIFO_CNT_4                                    0xCE2224
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_0                            0xCE2228
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_1                            0xCE222C
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_2                            0xCE2230
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_3                            0xCE2234
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_LO_4                            0xCE2238
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_0                            0xCE223C
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_1                            0xCE2240
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_2                            0xCE2244
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_3                            0xCE2248
+
+#define mmNIC0_QM1_CP_MSG_BASE0_ADDR_HI_4                            0xCE224C
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_0                            0xCE2250
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_1                            0xCE2254
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_2                            0xCE2258
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_3                            0xCE225C
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_LO_4                            0xCE2260
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_0                            0xCE2264
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_1                            0xCE2268
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_2                            0xCE226C
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_3                            0xCE2270
+
+#define mmNIC0_QM1_CP_MSG_BASE1_ADDR_HI_4                            0xCE2274
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_0                            0xCE2278
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_1                            0xCE227C
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_2                            0xCE2280
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_3                            0xCE2284
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_LO_4                            0xCE2288
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_0                            0xCE228C
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_1                            0xCE2290
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_2                            0xCE2294
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_3                            0xCE2298
+
+#define mmNIC0_QM1_CP_MSG_BASE2_ADDR_HI_4                            0xCE229C
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_0                            0xCE22A0
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_1                            0xCE22A4
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_2                            0xCE22A8
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_3                            0xCE22AC
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_LO_4                            0xCE22B0
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_0                            0xCE22B4
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_1                            0xCE22B8
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_2                            0xCE22BC
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_3                            0xCE22C0
+
+#define mmNIC0_QM1_CP_MSG_BASE3_ADDR_HI_4                            0xCE22C4
+
+#define mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_0                            0xCE22C8
+
+#define mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_1                            0xCE22CC
+
+#define mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_2                            0xCE22D0
+
+#define mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_3                            0xCE22D4
+
+#define mmNIC0_QM1_CP_LDMA_TSIZE_OFFSET_4                            0xCE22D8
+
+#define mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xCE22E0
+
+#define mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xCE22E4
+
+#define mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xCE22E8
+
+#define mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xCE22EC
+
+#define mmNIC0_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xCE22F0
+
+#define mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xCE22F4
+
+#define mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xCE22F8
+
+#define mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xCE22FC
+
+#define mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xCE2300
+
+#define mmNIC0_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xCE2304
+
+#define mmNIC0_QM1_CP_FENCE0_RDATA_0                                 0xCE2308
+
+#define mmNIC0_QM1_CP_FENCE0_RDATA_1                                 0xCE230C
+
+#define mmNIC0_QM1_CP_FENCE0_RDATA_2                                 0xCE2310
+
+#define mmNIC0_QM1_CP_FENCE0_RDATA_3                                 0xCE2314
+
+#define mmNIC0_QM1_CP_FENCE0_RDATA_4                                 0xCE2318
+
+#define mmNIC0_QM1_CP_FENCE1_RDATA_0                                 0xCE231C
+
+#define mmNIC0_QM1_CP_FENCE1_RDATA_1                                 0xCE2320
+
+#define mmNIC0_QM1_CP_FENCE1_RDATA_2                                 0xCE2324
+
+#define mmNIC0_QM1_CP_FENCE1_RDATA_3                                 0xCE2328
+
+#define mmNIC0_QM1_CP_FENCE1_RDATA_4                                 0xCE232C
+
+#define mmNIC0_QM1_CP_FENCE2_RDATA_0                                 0xCE2330
+
+#define mmNIC0_QM1_CP_FENCE2_RDATA_1                                 0xCE2334
+
+#define mmNIC0_QM1_CP_FENCE2_RDATA_2                                 0xCE2338
+
+#define mmNIC0_QM1_CP_FENCE2_RDATA_3                                 0xCE233C
+
+#define mmNIC0_QM1_CP_FENCE2_RDATA_4                                 0xCE2340
+
+#define mmNIC0_QM1_CP_FENCE3_RDATA_0                                 0xCE2344
+
+#define mmNIC0_QM1_CP_FENCE3_RDATA_1                                 0xCE2348
+
+#define mmNIC0_QM1_CP_FENCE3_RDATA_2                                 0xCE234C
+
+#define mmNIC0_QM1_CP_FENCE3_RDATA_3                                 0xCE2350
+
+#define mmNIC0_QM1_CP_FENCE3_RDATA_4                                 0xCE2354
+
+#define mmNIC0_QM1_CP_FENCE0_CNT_0                                   0xCE2358
+
+#define mmNIC0_QM1_CP_FENCE0_CNT_1                                   0xCE235C
+
+#define mmNIC0_QM1_CP_FENCE0_CNT_2                                   0xCE2360
+
+#define mmNIC0_QM1_CP_FENCE0_CNT_3                                   0xCE2364
+
+#define mmNIC0_QM1_CP_FENCE0_CNT_4                                   0xCE2368
+
+#define mmNIC0_QM1_CP_FENCE1_CNT_0                                   0xCE236C
+
+#define mmNIC0_QM1_CP_FENCE1_CNT_1                                   0xCE2370
+
+#define mmNIC0_QM1_CP_FENCE1_CNT_2                                   0xCE2374
+
+#define mmNIC0_QM1_CP_FENCE1_CNT_3                                   0xCE2378
+
+#define mmNIC0_QM1_CP_FENCE1_CNT_4                                   0xCE237C
+
+#define mmNIC0_QM1_CP_FENCE2_CNT_0                                   0xCE2380
+
+#define mmNIC0_QM1_CP_FENCE2_CNT_1                                   0xCE2384
+
+#define mmNIC0_QM1_CP_FENCE2_CNT_2                                   0xCE2388
+
+#define mmNIC0_QM1_CP_FENCE2_CNT_3                                   0xCE238C
+
+#define mmNIC0_QM1_CP_FENCE2_CNT_4                                   0xCE2390
+
+#define mmNIC0_QM1_CP_FENCE3_CNT_0                                   0xCE2394
+
+#define mmNIC0_QM1_CP_FENCE3_CNT_1                                   0xCE2398
+
+#define mmNIC0_QM1_CP_FENCE3_CNT_2                                   0xCE239C
+
+#define mmNIC0_QM1_CP_FENCE3_CNT_3                                   0xCE23A0
+
+#define mmNIC0_QM1_CP_FENCE3_CNT_4                                   0xCE23A4
+
+#define mmNIC0_QM1_CP_STS_0                                          0xCE23A8
+
+#define mmNIC0_QM1_CP_STS_1                                          0xCE23AC
+
+#define mmNIC0_QM1_CP_STS_2                                          0xCE23B0
+
+#define mmNIC0_QM1_CP_STS_3                                          0xCE23B4
+
+#define mmNIC0_QM1_CP_STS_4                                          0xCE23B8
+
+#define mmNIC0_QM1_CP_CURRENT_INST_LO_0                              0xCE23BC
+
+#define mmNIC0_QM1_CP_CURRENT_INST_LO_1                              0xCE23C0
+
+#define mmNIC0_QM1_CP_CURRENT_INST_LO_2                              0xCE23C4
+
+#define mmNIC0_QM1_CP_CURRENT_INST_LO_3                              0xCE23C8
+
+#define mmNIC0_QM1_CP_CURRENT_INST_LO_4                              0xCE23CC
+
+#define mmNIC0_QM1_CP_CURRENT_INST_HI_0                              0xCE23D0
+
+#define mmNIC0_QM1_CP_CURRENT_INST_HI_1                              0xCE23D4
+
+#define mmNIC0_QM1_CP_CURRENT_INST_HI_2                              0xCE23D8
+
+#define mmNIC0_QM1_CP_CURRENT_INST_HI_3                              0xCE23DC
+
+#define mmNIC0_QM1_CP_CURRENT_INST_HI_4                              0xCE23E0
+
+#define mmNIC0_QM1_CP_BARRIER_CFG_0                                  0xCE23F4
+
+#define mmNIC0_QM1_CP_BARRIER_CFG_1                                  0xCE23F8
+
+#define mmNIC0_QM1_CP_BARRIER_CFG_2                                  0xCE23FC
+
+#define mmNIC0_QM1_CP_BARRIER_CFG_3                                  0xCE2400
+
+#define mmNIC0_QM1_CP_BARRIER_CFG_4                                  0xCE2404
+
+#define mmNIC0_QM1_CP_DBG_0_0                                        0xCE2408
+
+#define mmNIC0_QM1_CP_DBG_0_1                                        0xCE240C
+
+#define mmNIC0_QM1_CP_DBG_0_2                                        0xCE2410
+
+#define mmNIC0_QM1_CP_DBG_0_3                                        0xCE2414
+
+#define mmNIC0_QM1_CP_DBG_0_4                                        0xCE2418
+
+#define mmNIC0_QM1_CP_ARUSER_31_11_0                                 0xCE241C
+
+#define mmNIC0_QM1_CP_ARUSER_31_11_1                                 0xCE2420
+
+#define mmNIC0_QM1_CP_ARUSER_31_11_2                                 0xCE2424
+
+#define mmNIC0_QM1_CP_ARUSER_31_11_3                                 0xCE2428
+
+#define mmNIC0_QM1_CP_ARUSER_31_11_4                                 0xCE242C
+
+#define mmNIC0_QM1_CP_AWUSER_31_11_0                                 0xCE2430
+
+#define mmNIC0_QM1_CP_AWUSER_31_11_1                                 0xCE2434
+
+#define mmNIC0_QM1_CP_AWUSER_31_11_2                                 0xCE2438
+
+#define mmNIC0_QM1_CP_AWUSER_31_11_3                                 0xCE243C
+
+#define mmNIC0_QM1_CP_AWUSER_31_11_4                                 0xCE2440
+
+#define mmNIC0_QM1_ARB_CFG_0                                         0xCE2A00
+
+#define mmNIC0_QM1_ARB_CHOISE_Q_PUSH                                 0xCE2A04
+
+#define mmNIC0_QM1_ARB_WRR_WEIGHT_0                                  0xCE2A08
+
+#define mmNIC0_QM1_ARB_WRR_WEIGHT_1                                  0xCE2A0C
+
+#define mmNIC0_QM1_ARB_WRR_WEIGHT_2                                  0xCE2A10
+
+#define mmNIC0_QM1_ARB_WRR_WEIGHT_3                                  0xCE2A14
+
+#define mmNIC0_QM1_ARB_CFG_1                                         0xCE2A18
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_0                              0xCE2A20
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_1                              0xCE2A24
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_2                              0xCE2A28
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_3                              0xCE2A2C
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_4                              0xCE2A30
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_5                              0xCE2A34
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_6                              0xCE2A38
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_7                              0xCE2A3C
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_8                              0xCE2A40
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_9                              0xCE2A44
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_10                             0xCE2A48
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_11                             0xCE2A4C
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_12                             0xCE2A50
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_13                             0xCE2A54
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_14                             0xCE2A58
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_15                             0xCE2A5C
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_16                             0xCE2A60
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_17                             0xCE2A64
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_18                             0xCE2A68
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_19                             0xCE2A6C
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_20                             0xCE2A70
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_21                             0xCE2A74
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_22                             0xCE2A78
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_23                             0xCE2A7C
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_24                             0xCE2A80
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_25                             0xCE2A84
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_26                             0xCE2A88
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_27                             0xCE2A8C
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_28                             0xCE2A90
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_29                             0xCE2A94
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_30                             0xCE2A98
+
+#define mmNIC0_QM1_ARB_MST_AVAIL_CRED_31                             0xCE2A9C
+
+#define mmNIC0_QM1_ARB_MST_CRED_INC                                  0xCE2AA0
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_0                        0xCE2AA4
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_1                        0xCE2AA8
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_2                        0xCE2AAC
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_3                        0xCE2AB0
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_4                        0xCE2AB4
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_5                        0xCE2AB8
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_6                        0xCE2ABC
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_7                        0xCE2AC0
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_8                        0xCE2AC4
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_9                        0xCE2AC8
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_10                       0xCE2ACC
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_11                       0xCE2AD0
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_12                       0xCE2AD4
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_13                       0xCE2AD8
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_14                       0xCE2ADC
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_15                       0xCE2AE0
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_16                       0xCE2AE4
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_17                       0xCE2AE8
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_18                       0xCE2AEC
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_19                       0xCE2AF0
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_20                       0xCE2AF4
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_21                       0xCE2AF8
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_22                       0xCE2AFC
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_23                       0xCE2B00
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_24                       0xCE2B04
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_25                       0xCE2B08
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_26                       0xCE2B0C
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_27                       0xCE2B10
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_28                       0xCE2B14
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_29                       0xCE2B18
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_30                       0xCE2B1C
+
+#define mmNIC0_QM1_ARB_MST_CHOISE_PUSH_OFST_31                       0xCE2B20
+
+#define mmNIC0_QM1_ARB_SLV_MASTER_INC_CRED_OFST                      0xCE2B28
+
+#define mmNIC0_QM1_ARB_MST_SLAVE_EN                                  0xCE2B2C
+
+#define mmNIC0_QM1_ARB_MST_QUIET_PER                                 0xCE2B34
+
+#define mmNIC0_QM1_ARB_SLV_CHOISE_WDT                                0xCE2B38
+
+#define mmNIC0_QM1_ARB_SLV_ID                                        0xCE2B3C
+
+#define mmNIC0_QM1_ARB_MSG_MAX_INFLIGHT                              0xCE2B44
+
+#define mmNIC0_QM1_ARB_MSG_AWUSER_31_11                              0xCE2B48
+
+#define mmNIC0_QM1_ARB_MSG_AWUSER_SEC_PROP                           0xCE2B4C
+
+#define mmNIC0_QM1_ARB_MSG_AWUSER_NON_SEC_PROP                       0xCE2B50
+
+#define mmNIC0_QM1_ARB_BASE_LO                                       0xCE2B54
+
+#define mmNIC0_QM1_ARB_BASE_HI                                       0xCE2B58
+
+#define mmNIC0_QM1_ARB_STATE_STS                                     0xCE2B80
+
+#define mmNIC0_QM1_ARB_CHOISE_FULLNESS_STS                           0xCE2B84
+
+#define mmNIC0_QM1_ARB_MSG_STS                                       0xCE2B88
+
+#define mmNIC0_QM1_ARB_SLV_CHOISE_Q_HEAD                             0xCE2B8C
+
+#define mmNIC0_QM1_ARB_ERR_CAUSE                                     0xCE2B9C
+
+#define mmNIC0_QM1_ARB_ERR_MSG_EN                                    0xCE2BA0
+
+#define mmNIC0_QM1_ARB_ERR_STS_DRP                                   0xCE2BA8
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_0                                0xCE2BB0
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_1                                0xCE2BB4
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_2                                0xCE2BB8
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_3                                0xCE2BBC
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_4                                0xCE2BC0
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_5                                0xCE2BC4
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_6                                0xCE2BC8
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_7                                0xCE2BCC
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_8                                0xCE2BD0
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_9                                0xCE2BD4
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_10                               0xCE2BD8
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_11                               0xCE2BDC
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_12                               0xCE2BE0
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_13                               0xCE2BE4
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_14                               0xCE2BE8
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_15                               0xCE2BEC
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_16                               0xCE2BF0
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_17                               0xCE2BF4
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_18                               0xCE2BF8
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_19                               0xCE2BFC
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_20                               0xCE2C00
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_21                               0xCE2C04
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_22                               0xCE2C08
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_23                               0xCE2C0C
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_24                               0xCE2C10
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_25                               0xCE2C14
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_26                               0xCE2C18
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_27                               0xCE2C1C
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_28                               0xCE2C20
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_29                               0xCE2C24
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_30                               0xCE2C28
+
+#define mmNIC0_QM1_ARB_MST_CRED_STS_31                               0xCE2C2C
+
+#define mmNIC0_QM1_CGM_CFG                                           0xCE2C70
+
+#define mmNIC0_QM1_CGM_STS                                           0xCE2C74
+
+#define mmNIC0_QM1_CGM_CFG1                                          0xCE2C78
+
+#define mmNIC0_QM1_LOCAL_RANGE_BASE                                  0xCE2C80
+
+#define mmNIC0_QM1_LOCAL_RANGE_SIZE                                  0xCE2C84
+
+#define mmNIC0_QM1_CSMR_STRICT_PRIO_CFG                              0xCE2C90
+
+#define mmNIC0_QM1_HBW_RD_RATE_LIM_CFG_1                             0xCE2C94
+
+#define mmNIC0_QM1_LBW_WR_RATE_LIM_CFG_0                             0xCE2C98
+
+#define mmNIC0_QM1_LBW_WR_RATE_LIM_CFG_1                             0xCE2C9C
+
+#define mmNIC0_QM1_HBW_RD_RATE_LIM_CFG_0                             0xCE2CA0
+
+#define mmNIC0_QM1_GLBL_AXCACHE                                      0xCE2CA4
+
+#define mmNIC0_QM1_IND_GW_APB_CFG                                    0xCE2CB0
+
+#define mmNIC0_QM1_IND_GW_APB_WDATA                                  0xCE2CB4
+
+#define mmNIC0_QM1_IND_GW_APB_RDATA                                  0xCE2CB8
+
+#define mmNIC0_QM1_IND_GW_APB_STATUS                                 0xCE2CBC
+
+#define mmNIC0_QM1_GLBL_ERR_ADDR_LO                                  0xCE2CD0
+
+#define mmNIC0_QM1_GLBL_ERR_ADDR_HI                                  0xCE2CD4
+
+#define mmNIC0_QM1_GLBL_ERR_WDATA                                    0xCE2CD8
+
+#define mmNIC0_QM1_GLBL_MEM_INIT_BUSY                                0xCE2D00
+
+#endif /* ASIC_REG_NIC0_QM1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
new file mode 100644
index 000000000000..a6b71a2b9144
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
@@ -0,0 +1,500 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_QPC0_MASKS_H_
+#define ASIC_REG_NIC0_QPC0_MASKS_H_
+
+/*
+ *****************************************
+ *   NIC0_QPC0 (Prototype: NIC_QPC)
+ *****************************************
+ */
+
+/* NIC0_QPC0_REQ_QPC_CACHE_INVALIDATE */
+
+/* NIC0_QPC0_REQ_QPC_CACHE_INV_STATUS */
+#define NIC0_QPC0_REQ_QPC_CACHE_INV_STATUS_INVALIDATE_DONE_SHIFT     0
+#define NIC0_QPC0_REQ_QPC_CACHE_INV_STATUS_INVALIDATE_DONE_MASK      0x1
+#define NIC0_QPC0_REQ_QPC_CACHE_INV_STATUS_CACHE_IDLE_SHIFT          1
+#define NIC0_QPC0_REQ_QPC_CACHE_INV_STATUS_CACHE_IDLE_MASK           0x2
+
+/* NIC0_QPC0_REQ_STATIC_CONFIG */
+#define NIC0_QPC0_REQ_STATIC_CONFIG_PLRU_EVICTION_SHIFT              0
+#define NIC0_QPC0_REQ_STATIC_CONFIG_PLRU_EVICTION_MASK               0x1
+#define NIC0_QPC0_REQ_STATIC_CONFIG_RELEASE_INVALIDATE_SHIFT         1
+#define NIC0_QPC0_REQ_STATIC_CONFIG_RELEASE_INVALIDATE_MASK          0x2
+#define NIC0_QPC0_REQ_STATIC_CONFIG_LINK_LIST_EN_SHIFT               2
+#define NIC0_QPC0_REQ_STATIC_CONFIG_LINK_LIST_EN_MASK                0x4
+#define NIC0_QPC0_REQ_STATIC_CONFIG_TIMER_EN_SHIFT                   3
+#define NIC0_QPC0_REQ_STATIC_CONFIG_TIMER_EN_MASK                    0x8
+#define NIC0_QPC0_REQ_STATIC_CONFIG_QM_PUSH_TO_ERR_FIFO_NON_V_SHIFT  4
+#define NIC0_QPC0_REQ_STATIC_CONFIG_QM_PUSH_TO_ERR_FIFO_NON_V_MASK   0x10
+#define NIC0_QPC0_REQ_STATIC_CONFIG_TX_PUSH_TO_ERR_FIFO_NON_V_SHIFT  5
+#define NIC0_QPC0_REQ_STATIC_CONFIG_TX_PUSH_TO_ERR_FIFO_NON_V_MASK   0x20
+#define NIC0_QPC0_REQ_STATIC_CONFIG_CACHE_STOP_SHIFT                 6
+#define NIC0_QPC0_REQ_STATIC_CONFIG_CACHE_STOP_MASK                  0x40
+#define NIC0_QPC0_REQ_STATIC_CONFIG_INVALIDATE_WRITEBACK_SHIFT       7
+#define NIC0_QPC0_REQ_STATIC_CONFIG_INVALIDATE_WRITEBACK_MASK        0x80
+#define NIC0_QPC0_REQ_STATIC_CONFIG_QM_PUSH_TO_ERROR_SECURITY_SHIFT  8
+#define NIC0_QPC0_REQ_STATIC_CONFIG_QM_PUSH_TO_ERROR_SECURITY_MASK   0x100
+
+/* NIC0_QPC0_REQ_BASE_ADDRESS_49_18 */
+#define NIC0_QPC0_REQ_BASE_ADDRESS_49_18_R_SHIFT                     0
+#define NIC0_QPC0_REQ_BASE_ADDRESS_49_18_R_MASK                      0xFFFFFFFF
+
+/* NIC0_QPC0_REQ_BASE_ADDRESS_17_7 */
+#define NIC0_QPC0_REQ_BASE_ADDRESS_17_7_R_SHIFT                      0
+#define NIC0_QPC0_REQ_BASE_ADDRESS_17_7_R_MASK                       0x7FF
+
+/* NIC0_QPC0_REQ_CLEAN_LINK_LIST */
+
+/* NIC0_QPC0_REQ_ERR_FIFO_PUSH_63_32 */
+#define NIC0_QPC0_REQ_ERR_FIFO_PUSH_63_32_R_SHIFT                    0
+#define NIC0_QPC0_REQ_ERR_FIFO_PUSH_63_32_R_MASK                     0xFFFFFFFF
+
+/* NIC0_QPC0_REQ_ERR_FIFO_PUSH_31_0 */
+#define NIC0_QPC0_REQ_ERR_FIFO_PUSH_31_0_R_SHIFT                     0
+#define NIC0_QPC0_REQ_ERR_FIFO_PUSH_31_0_R_MASK                      0xFFFFFFFF
+
+/* NIC0_QPC0_REQ_ERR_QP_STATE_63_32 */
+#define NIC0_QPC0_REQ_ERR_QP_STATE_63_32_R_SHIFT                     0
+#define NIC0_QPC0_REQ_ERR_QP_STATE_63_32_R_MASK                      0xFFFFFFFF
+
+/* NIC0_QPC0_REQ_ERR_QP_STATE_31_0 */
+#define NIC0_QPC0_REQ_ERR_QP_STATE_31_0_R_SHIFT                      0
+#define NIC0_QPC0_REQ_ERR_QP_STATE_31_0_R_MASK                       0xFFFFFFFF
+
+/* NIC0_QPC0_RETRY_COUNT_MAX */
+#define NIC0_QPC0_RETRY_COUNT_MAX_TIMEOUT_SHIFT                      0
+#define NIC0_QPC0_RETRY_COUNT_MAX_TIMEOUT_MASK                       0xFF
+#define NIC0_QPC0_RETRY_COUNT_MAX_SEQUENCE_ERROR_SHIFT               8
+#define NIC0_QPC0_RETRY_COUNT_MAX_SEQUENCE_ERROR_MASK                0xFF00
+
+/* NIC0_QPC0_AXI_USER */
+#define NIC0_QPC0_AXI_USER_R_SHIFT                                   0
+#define NIC0_QPC0_AXI_USER_R_MASK                                    0xFFFFFFFF
+
+/* NIC0_QPC0_AXI_PROT */
+#define NIC0_QPC0_AXI_PROT_R_SHIFT                                   0
+#define NIC0_QPC0_AXI_PROT_R_MASK                                    0x7
+
+/* NIC0_QPC0_RES_QPC_CACHE_INVALIDATE */
+
+/* NIC0_QPC0_RES_QPC_CACHE_INV_STATUS */
+#define NIC0_QPC0_RES_QPC_CACHE_INV_STATUS_INVALIDATE_DONE_SHIFT     0
+#define NIC0_QPC0_RES_QPC_CACHE_INV_STATUS_INVALIDATE_DONE_MASK      0x1
+#define NIC0_QPC0_RES_QPC_CACHE_INV_STATUS_CACHE_IDLE_SHIFT          1
+#define NIC0_QPC0_RES_QPC_CACHE_INV_STATUS_CACHE_IDLE_MASK           0x2
+
+/* NIC0_QPC0_RES_STATIC_CONFIG */
+#define NIC0_QPC0_RES_STATIC_CONFIG_PLRU_EVICTION_SHIFT              0
+#define NIC0_QPC0_RES_STATIC_CONFIG_PLRU_EVICTION_MASK               0x1
+#define NIC0_QPC0_RES_STATIC_CONFIG_RELEASE_INVALIDATE_SHIFT         1
+#define NIC0_QPC0_RES_STATIC_CONFIG_RELEASE_INVALIDATE_MASK          0x2
+#define NIC0_QPC0_RES_STATIC_CONFIG_LINK_LIST_EN_SHIFT               2
+#define NIC0_QPC0_RES_STATIC_CONFIG_LINK_LIST_EN_MASK                0x4
+#define NIC0_QPC0_RES_STATIC_CONFIG_RX_PUSH_TO_ERR_FIFO_NON_V_SHIFT  3
+#define NIC0_QPC0_RES_STATIC_CONFIG_RX_PUSH_TO_ERR_FIFO_NON_V_MASK   0x8
+#define NIC0_QPC0_RES_STATIC_CONFIG_TX_PUSH_TO_ERR_FIFO_NON_V_SHIFT  4
+#define NIC0_QPC0_RES_STATIC_CONFIG_TX_PUSH_TO_ERR_FIFO_NON_V_MASK   0x10
+#define NIC0_QPC0_RES_STATIC_CONFIG_CACHE_STOP_SHIFT                 5
+#define NIC0_QPC0_RES_STATIC_CONFIG_CACHE_STOP_MASK                  0x20
+#define NIC0_QPC0_RES_STATIC_CONFIG_INVALIDATE_WRITEBACK_SHIFT       6
+#define NIC0_QPC0_RES_STATIC_CONFIG_INVALIDATE_WRITEBACK_MASK        0x40
+
+/* NIC0_QPC0_RES_BASE_ADDRESS_49_18 */
+#define NIC0_QPC0_RES_BASE_ADDRESS_49_18_R_SHIFT                     0
+#define NIC0_QPC0_RES_BASE_ADDRESS_49_18_R_MASK                      0xFFFFFFFF
+
+/* NIC0_QPC0_RES_BASE_ADDRESS_17_7 */
+#define NIC0_QPC0_RES_BASE_ADDRESS_17_7_R_SHIFT                      0
+#define NIC0_QPC0_RES_BASE_ADDRESS_17_7_R_MASK                       0x7FF
+
+/* NIC0_QPC0_RES_CLEAN_LINK_LIST */
+
+/* NIC0_QPC0_ERR_FIFO_WRITE_INDEX */
+#define NIC0_QPC0_ERR_FIFO_WRITE_INDEX_R_SHIFT                       0
+#define NIC0_QPC0_ERR_FIFO_WRITE_INDEX_R_MASK                        0xFFFFFFFF
+
+/* NIC0_QPC0_ERR_FIFO_PRODUCER_INDEX */
+#define NIC0_QPC0_ERR_FIFO_PRODUCER_INDEX_R_SHIFT                    0
+#define NIC0_QPC0_ERR_FIFO_PRODUCER_INDEX_R_MASK                     0xFFFFFFFF
+
+/* NIC0_QPC0_ERR_FIFO_CONSUMER_INDEX */
+#define NIC0_QPC0_ERR_FIFO_CONSUMER_INDEX_R_SHIFT                    0
+#define NIC0_QPC0_ERR_FIFO_CONSUMER_INDEX_R_MASK                     0xFFFFFFFF
+
+/* NIC0_QPC0_ERR_FIFO_MASK */
+#define NIC0_QPC0_ERR_FIFO_MASK_R_SHIFT                              0
+#define NIC0_QPC0_ERR_FIFO_MASK_R_MASK                               0xFFFFFFFF
+
+/* NIC0_QPC0_ERR_FIFO_CREDIT */
+#define NIC0_QPC0_ERR_FIFO_CREDIT_MAX_CREDIT_SHIFT                   0
+#define NIC0_QPC0_ERR_FIFO_CREDIT_MAX_CREDIT_MASK                    0x1F
+#define NIC0_QPC0_ERR_FIFO_CREDIT_FORCE_FULL_SHIFT                   5
+#define NIC0_QPC0_ERR_FIFO_CREDIT_FORCE_FULL_MASK                    0x20
+
+/* NIC0_QPC0_ERR_FIFO_CFG */
+#define NIC0_QPC0_ERR_FIFO_CFG_ENABLE_SHIFT                          0
+#define NIC0_QPC0_ERR_FIFO_CFG_ENABLE_MASK                           0x1
+#define NIC0_QPC0_ERR_FIFO_CFG_WRAPAROUND_EN_SHIFT                   1
+#define NIC0_QPC0_ERR_FIFO_CFG_WRAPAROUND_EN_MASK                    0x2
+#define NIC0_QPC0_ERR_FIFO_CFG_WRAPAROUND_OCCURRED_SHIFT             2
+#define NIC0_QPC0_ERR_FIFO_CFG_WRAPAROUND_OCCURRED_MASK              0x4
+
+/* NIC0_QPC0_ERR_FIFO_INTR_MASK */
+#define NIC0_QPC0_ERR_FIFO_INTR_MASK_R_SHIFT                         0
+#define NIC0_QPC0_ERR_FIFO_INTR_MASK_R_MASK                          0x1
+
+/* NIC0_QPC0_ERR_FIFO_BASE_ADDR_49_18 */
+#define NIC0_QPC0_ERR_FIFO_BASE_ADDR_49_18_R_SHIFT                   0
+#define NIC0_QPC0_ERR_FIFO_BASE_ADDR_49_18_R_MASK                    0xFFFFFFFF
+
+/* NIC0_QPC0_ERR_FIFO_BASE_ADDR_17_7 */
+#define NIC0_QPC0_ERR_FIFO_BASE_ADDR_17_7_R_SHIFT                    7
+#define NIC0_QPC0_ERR_FIFO_BASE_ADDR_17_7_R_MASK                     0x3FF80
+
+/* NIC0_QPC0_GW_BUSY */
+#define NIC0_QPC0_GW_BUSY_R_SHIFT                                    0
+#define NIC0_QPC0_GW_BUSY_R_MASK                                     0x1
+
+/* NIC0_QPC0_GW_CTRL */
+#define NIC0_QPC0_GW_CTRL_QPN_SHIFT                                  0
+#define NIC0_QPC0_GW_CTRL_QPN_MASK                                   0xFFFFFF
+#define NIC0_QPC0_GW_CTRL_REQUESTER_SHIFT                            24
+#define NIC0_QPC0_GW_CTRL_REQUESTER_MASK                             0x1000000
+#define NIC0_QPC0_GW_CTRL_DOORBELL_MASK_SHIFT                        25
+#define NIC0_QPC0_GW_CTRL_DOORBELL_MASK_MASK                         0x2000000
+#define NIC0_QPC0_GW_CTRL_DOORBELL_FORCE_SHIFT                       26
+#define NIC0_QPC0_GW_CTRL_DOORBELL_FORCE_MASK                        0x4000000
+
+/* NIC0_QPC0_GW_DATA */
+#define NIC0_QPC0_GW_DATA_R_SHIFT                                    0
+#define NIC0_QPC0_GW_DATA_R_MASK                                     0xFFFFFFFF
+
+/* NIC0_QPC0_GW_MASK */
+#define NIC0_QPC0_GW_MASK_R_SHIFT                                    0
+#define NIC0_QPC0_GW_MASK_R_MASK                                     0xFFFFFFFF
+
+/* NIC0_QPC0_CC_WINDOW_INC_EN */
+#define NIC0_QPC0_CC_WINDOW_INC_EN_THERSHOLD_SHIFT                   0
+#define NIC0_QPC0_CC_WINDOW_INC_EN_THERSHOLD_MASK                    0x3FFFFF
+
+/* NIC0_QPC0_CC_TICK_WRAP */
+#define NIC0_QPC0_CC_TICK_WRAP_R_SHIFT                               0
+#define NIC0_QPC0_CC_TICK_WRAP_R_MASK                                0xFFFF
+
+/* NIC0_QPC0_CC_ROLLBACK */
+#define NIC0_QPC0_CC_ROLLBACK_MANTISSA_SHIFT                         0
+#define NIC0_QPC0_CC_ROLLBACK_MANTISSA_MASK                          0x3FFFFF
+#define NIC0_QPC0_CC_ROLLBACK_EXPONENT_SHIFT                         22
+#define NIC0_QPC0_CC_ROLLBACK_EXPONENT_MASK                          0x7C00000
+#define NIC0_QPC0_CC_ROLLBACK_HW_EN_SHIFT                            27
+#define NIC0_QPC0_CC_ROLLBACK_HW_EN_MASK                             0x8000000
+#define NIC0_QPC0_CC_ROLLBACK_SW_EN_SHIFT                            28
+#define NIC0_QPC0_CC_ROLLBACK_SW_EN_MASK                             0x10000000
+
+/* NIC0_QPC0_CC_MAX_WINDOW_SIZE */
+#define NIC0_QPC0_CC_MAX_WINDOW_SIZE_R_SHIFT                         0
+#define NIC0_QPC0_CC_MAX_WINDOW_SIZE_R_MASK                          0x3FFFFF
+
+/* NIC0_QPC0_CC_MIN_WINDOW_SIZE */
+#define NIC0_QPC0_CC_MIN_WINDOW_SIZE_R_SHIFT                         0
+#define NIC0_QPC0_CC_MIN_WINDOW_SIZE_R_MASK                          0x3FFFFF
+
+/* NIC0_QPC0_CC_ALPHA_LINEAR */
+#define NIC0_QPC0_CC_ALPHA_LINEAR_MANTISSA_SHIFT                     0
+#define NIC0_QPC0_CC_ALPHA_LINEAR_MANTISSA_MASK                      0x3FFFFF
+#define NIC0_QPC0_CC_ALPHA_LINEAR_EXPONENT_SHIFT                     22
+#define NIC0_QPC0_CC_ALPHA_LINEAR_EXPONENT_MASK                      0x7C00000
+
+/* NIC0_QPC0_CC_ALPHA_LOG */
+#define NIC0_QPC0_CC_ALPHA_LOG_MANTISSA_SHIFT                        0
+#define NIC0_QPC0_CC_ALPHA_LOG_MANTISSA_MASK                         0x3FFFFF
+#define NIC0_QPC0_CC_ALPHA_LOG_EXPONENT_SHIFT                        22
+#define NIC0_QPC0_CC_ALPHA_LOG_EXPONENT_MASK                         0x7C00000
+
+/* NIC0_QPC0_CC_ALPHA_LOG_THRESHOLD */
+#define NIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_R_SHIFT                     0
+#define NIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_R_MASK                      0x1F
+
+/* NIC0_QPC0_CC_WINDOW_INC */
+#define NIC0_QPC0_CC_WINDOW_INC_R_SHIFT                              0
+#define NIC0_QPC0_CC_WINDOW_INC_R_MASK                               0x3FFFFF
+
+/* NIC0_QPC0_CC_WINDOW_IN_THRESHOLD */
+#define NIC0_QPC0_CC_WINDOW_IN_THRESHOLD_R_SHIFT                     0
+#define NIC0_QPC0_CC_WINDOW_IN_THRESHOLD_R_MASK                      0x1FFFFFF
+
+/* NIC0_QPC0_CC_LOG_QPC */
+#define NIC0_QPC0_CC_LOG_QPC_QPN_SHIFT                               0
+#define NIC0_QPC0_CC_LOG_QPC_QPN_MASK                                0xFFFFFF
+#define NIC0_QPC0_CC_LOG_QPC_VALID_SHIFT                             24
+#define NIC0_QPC0_CC_LOG_QPC_VALID_MASK                              0x1000000
+#define NIC0_QPC0_CC_LOG_QPC_READY_SHIFT                             25
+#define NIC0_QPC0_CC_LOG_QPC_READY_MASK                              0x2000000
+
+/* NIC0_QPC0_CC_LOG_TX */
+#define NIC0_QPC0_CC_LOG_TX_TIME_COUNT_SHIFT                         0
+#define NIC0_QPC0_CC_LOG_TX_TIME_COUNT_MASK                          0x1FFFFFF
+#define NIC0_QPC0_CC_LOG_TX_VALID_SHIFT                              25
+#define NIC0_QPC0_CC_LOG_TX_VALID_MASK                               0x2000000
+
+/* NIC0_QPC0_CC_LOG_LATENCY */
+#define NIC0_QPC0_CC_LOG_LATENCY_TIME_COUNT_SHIFT                    0
+#define NIC0_QPC0_CC_LOG_LATENCY_TIME_COUNT_MASK                     0x1FFFFFF
+#define NIC0_QPC0_CC_LOG_LATENCY_VALID_SHIFT                         25
+#define NIC0_QPC0_CC_LOG_LATENCY_VALID_MASK                          0x2000000
+
+/* NIC0_QPC0_CC_LOG_RX */
+#define NIC0_QPC0_CC_LOG_RX_TIME_COUNT_SHIFT                         0
+#define NIC0_QPC0_CC_LOG_RX_TIME_COUNT_MASK                          0x1FFFFFF
+#define NIC0_QPC0_CC_LOG_RX_VALID_SHIFT                              25
+#define NIC0_QPC0_CC_LOG_RX_VALID_MASK                               0x2000000
+
+/* NIC0_QPC0_CC_LOG_WINDOW_SIZE */
+#define NIC0_QPC0_CC_LOG_WINDOW_SIZE_R_SHIFT                         0
+#define NIC0_QPC0_CC_LOG_WINDOW_SIZE_R_MASK                          0x3FFFFF
+
+/* NIC0_QPC0_DBG_COUNT_SELECT */
+#define NIC0_QPC0_DBG_COUNT_SELECT_R_SHIFT                           0
+#define NIC0_QPC0_DBG_COUNT_SELECT_R_MASK                            0x3F
+
+/* NIC0_QPC0_UNSECURED_DOORBELL_QPN */
+#define NIC0_QPC0_UNSECURED_DOORBELL_QPN_QPN_SHIFT                   0
+#define NIC0_QPC0_UNSECURED_DOORBELL_QPN_QPN_MASK                    0xFFFFFF
+#define NIC0_QPC0_UNSECURED_DOORBELL_QPN_BUSY_SHIFT                  31
+#define NIC0_QPC0_UNSECURED_DOORBELL_QPN_BUSY_MASK                   0x80000000
+
+/* NIC0_QPC0_UNSECURED_DOORBELL_PI */
+#define NIC0_QPC0_UNSECURED_DOORBELL_PI_R_SHIFT                      0
+#define NIC0_QPC0_UNSECURED_DOORBELL_PI_R_MASK                       0x3FFFFF
+
+/* NIC0_QPC0_SECURED_DOORBELL_QPN */
+#define NIC0_QPC0_SECURED_DOORBELL_QPN_QPN_SHIFT                     0
+#define NIC0_QPC0_SECURED_DOORBELL_QPN_QPN_MASK                      0xFFFFFF
+#define NIC0_QPC0_SECURED_DOORBELL_QPN_BUSY_SHIFT                    31
+#define NIC0_QPC0_SECURED_DOORBELL_QPN_BUSY_MASK                     0x80000000
+
+/* NIC0_QPC0_SECURED_DOORBELL_PI */
+#define NIC0_QPC0_SECURED_DOORBELL_PI_R_SHIFT                        0
+#define NIC0_QPC0_SECURED_DOORBELL_PI_R_MASK                         0x3FFFFF
+
+/* NIC0_QPC0_PRIVILEGE_DOORBELL_QPN */
+#define NIC0_QPC0_PRIVILEGE_DOORBELL_QPN_QPN_SHIFT                   0
+#define NIC0_QPC0_PRIVILEGE_DOORBELL_QPN_QPN_MASK                    0xFFFFFF
+#define NIC0_QPC0_PRIVILEGE_DOORBELL_QPN_BUSY_SHIFT                  31
+#define NIC0_QPC0_PRIVILEGE_DOORBELL_QPN_BUSY_MASK                   0x80000000
+
+/* NIC0_QPC0_PRIVILEGE_DOORBELL_PI */
+#define NIC0_QPC0_PRIVILEGE_DOORBELL_PI_R_SHIFT                      0
+#define NIC0_QPC0_PRIVILEGE_DOORBELL_PI_R_MASK                       0x3FFFFF
+
+/* NIC0_QPC0_DOORBELL_SECURITY */
+#define NIC0_QPC0_DOORBELL_SECURITY_QMAN_SHIFT                       0
+#define NIC0_QPC0_DOORBELL_SECURITY_QMAN_MASK                        0x3
+#define NIC0_QPC0_DOORBELL_SECURITY_UNSECURED_SHIFT                  2
+#define NIC0_QPC0_DOORBELL_SECURITY_UNSECURED_MASK                   0xC
+#define NIC0_QPC0_DOORBELL_SECURITY_SECURED_SHIFT                    4
+#define NIC0_QPC0_DOORBELL_SECURITY_SECURED_MASK                     0x30
+#define NIC0_QPC0_DOORBELL_SECURITY_PRIVILEGE_SHIFT                  6
+#define NIC0_QPC0_DOORBELL_SECURITY_PRIVILEGE_MASK                   0xC0
+
+/* NIC0_QPC0_DGB_TRIG */
+#define NIC0_QPC0_DGB_TRIG_R_SHIFT                                   0
+#define NIC0_QPC0_DGB_TRIG_R_MASK                                    0x1F
+
+/* NIC0_QPC0_RES_RING0_PI */
+#define NIC0_QPC0_RES_RING0_PI_R_SHIFT                               0
+#define NIC0_QPC0_RES_RING0_PI_R_MASK                                0x3FFFFFFF
+
+/* NIC0_QPC0_RES_RING0_CI */
+#define NIC0_QPC0_RES_RING0_CI_R_SHIFT                               0
+#define NIC0_QPC0_RES_RING0_CI_R_MASK                                0x3FFFFFFF
+
+/* NIC0_QPC0_RES_RING0_CFG */
+#define NIC0_QPC0_RES_RING0_CFG_QPN_SHIFT                            0
+#define NIC0_QPC0_RES_RING0_CFG_QPN_MASK                             0xFFFFFF
+#define NIC0_QPC0_RES_RING0_CFG_WRAPAROUND_SHIFT                     31
+#define NIC0_QPC0_RES_RING0_CFG_WRAPAROUND_MASK                      0x80000000
+
+/* NIC0_QPC0_RES_RING1_PI */
+#define NIC0_QPC0_RES_RING1_PI_R_SHIFT                               0
+#define NIC0_QPC0_RES_RING1_PI_R_MASK                                0x3FFFFFFF
+
+/* NIC0_QPC0_RES_RING1_CI */
+#define NIC0_QPC0_RES_RING1_CI_R_SHIFT                               0
+#define NIC0_QPC0_RES_RING1_CI_R_MASK                                0x3FFFFFFF
+
+/* NIC0_QPC0_RES_RING1_CFG */
+#define NIC0_QPC0_RES_RING1_CFG_QPN_SHIFT                            0
+#define NIC0_QPC0_RES_RING1_CFG_QPN_MASK                             0xFFFFFF
+#define NIC0_QPC0_RES_RING1_CFG_WRAPAROUND_SHIFT                     31
+#define NIC0_QPC0_RES_RING1_CFG_WRAPAROUND_MASK                      0x80000000
+
+/* NIC0_QPC0_RES_RING2_PI */
+#define NIC0_QPC0_RES_RING2_PI_R_SHIFT                               0
+#define NIC0_QPC0_RES_RING2_PI_R_MASK                                0x3FFFFFFF
+
+/* NIC0_QPC0_RES_RING2_CI */
+#define NIC0_QPC0_RES_RING2_CI_R_SHIFT                               0
+#define NIC0_QPC0_RES_RING2_CI_R_MASK                                0x3FFFFFFF
+
+/* NIC0_QPC0_RES_RING2_CFG */
+#define NIC0_QPC0_RES_RING2_CFG_QPN_SHIFT                            0
+#define NIC0_QPC0_RES_RING2_CFG_QPN_MASK                             0xFFFFFF
+#define NIC0_QPC0_RES_RING2_CFG_WRAPAROUND_SHIFT                     24
+#define NIC0_QPC0_RES_RING2_CFG_WRAPAROUND_MASK                      0x1000000
+
+/* NIC0_QPC0_RES_RING3_PI */
+#define NIC0_QPC0_RES_RING3_PI_R_SHIFT                               0
+#define NIC0_QPC0_RES_RING3_PI_R_MASK                                0x3FFFFFFF
+
+/* NIC0_QPC0_RES_RING3_CI */
+#define NIC0_QPC0_RES_RING3_CI_R_SHIFT                               0
+#define NIC0_QPC0_RES_RING3_CI_R_MASK                                0x3FFFFFFF
+
+/* NIC0_QPC0_RES_RING3_CFG */
+#define NIC0_QPC0_RES_RING3_CFG_QPN_SHIFT                            0
+#define NIC0_QPC0_RES_RING3_CFG_QPN_MASK                             0xFFFFFF
+#define NIC0_QPC0_RES_RING3_CFG_WRAPAROUND_SHIFT                     24
+#define NIC0_QPC0_RES_RING3_CFG_WRAPAROUND_MASK                      0x1000000
+
+/* NIC0_QPC0_REQ_RING0_CI */
+#define NIC0_QPC0_REQ_RING0_CI_R_SHIFT                               0
+#define NIC0_QPC0_REQ_RING0_CI_R_MASK                                0x3FFFFF
+
+/* NIC0_QPC0_REQ_RING1_CI */
+#define NIC0_QPC0_REQ_RING1_CI_R_SHIFT                               0
+#define NIC0_QPC0_REQ_RING1_CI_R_MASK                                0x3FFFFF
+
+/* NIC0_QPC0_REQ_RING2_CI */
+#define NIC0_QPC0_REQ_RING2_CI_R_SHIFT                               0
+#define NIC0_QPC0_REQ_RING2_CI_R_MASK                                0x3FFFFF
+
+/* NIC0_QPC0_REQ_RING3_CI */
+#define NIC0_QPC0_REQ_RING3_CI_R_SHIFT                               0
+#define NIC0_QPC0_REQ_RING3_CI_R_MASK                                0x3FFFFF
+
+/* NIC0_QPC0_INTERRUPT_CAUSE */
+#define NIC0_QPC0_INTERRUPT_CAUSE_R_SHIFT                            0
+#define NIC0_QPC0_INTERRUPT_CAUSE_R_MASK                             0x1FF
+
+/* NIC0_QPC0_INTERRUPT_MASK */
+#define NIC0_QPC0_INTERRUPT_MASK_R_SHIFT                             0
+#define NIC0_QPC0_INTERRUPT_MASK_R_MASK                              0x1FF
+
+/* NIC0_QPC0_INTERRUPT_CLR */
+
+/* NIC0_QPC0_INTERRUPT_EN */
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT0_WIRE_EN_SHIFT              0
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT0_WIRE_EN_MASK               0x1
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT0_MSI_EN_SHIFT               1
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT0_MSI_EN_MASK                0x2
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT1_WIRE_EN_SHIFT              2
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT1_WIRE_EN_MASK               0x4
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT1_MSI_EN_SHIFT               3
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT1_MSI_EN_MASK                0x8
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT2_WIRE_EN_SHIFT              4
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT2_WIRE_EN_MASK               0x10
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT2_MSI_EN_SHIFT               5
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT2_MSI_EN_MASK                0x20
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT3_WIRE_EN_SHIFT              6
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT3_WIRE_EN_MASK               0x40
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT3_MSI_EN_SHIFT               7
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT3_MSI_EN_MASK                0x80
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT4_WIRE_EN_SHIFT              8
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT4_WIRE_EN_MASK               0x100
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT4_MSI_EN_SHIFT               9
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT4_MSI_EN_MASK                0x200
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT5_WIRE_EN_SHIFT              10
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT5_WIRE_EN_MASK               0x400
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT5_MSI_EN_SHIFT               11
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT5_MSI_EN_MASK                0x800
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT6_WIRE_EN_SHIFT              12
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT6_WIRE_EN_MASK               0x1000
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT6_MSI_EN_SHIFT               13
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT6_MSI_EN_MASK                0x2000
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT7_WIRE_EN_SHIFT              14
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT7_WIRE_EN_MASK               0x4000
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT7_MSI_EN_SHIFT               15
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT7_MSI_EN_MASK                0x8000
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT8_WIRE_EN_SHIFT              16
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT8_WIRE_EN_MASK               0x10000
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT8_MSI_EN_SHIFT               17
+#define NIC0_QPC0_INTERRUPT_EN_INTERRUPT8_MSI_EN_MASK                0x20000
+
+/* NIC0_QPC0_INTERRUPT_BASE */
+#define NIC0_QPC0_INTERRUPT_BASE_R_SHIFT                             0
+#define NIC0_QPC0_INTERRUPT_BASE_R_MASK                              0x3FFFFFF
+
+/* NIC0_QPC0_INTERRUPT_DATA */
+#define NIC0_QPC0_INTERRUPT_DATA_R_SHIFT                             0
+#define NIC0_QPC0_INTERRUPT_DATA_R_MASK                              0xFFFFFFFF
+
+/* NIC0_QPC0_INTERRUPT_PROT */
+#define NIC0_QPC0_INTERRUPT_PROT_R_SHIFT                             0
+#define NIC0_QPC0_INTERRUPT_PROT_R_MASK                              0x7
+
+/* NIC0_QPC0_INTERRUPT_USER */
+#define NIC0_QPC0_INTERRUPT_USER_R_SHIFT                             0
+#define NIC0_QPC0_INTERRUPT_USER_R_MASK                              0xFFFFFFFF
+
+/* NIC0_QPC0_INTERRUPT_CFG */
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT0_EACH_UPDATE_SHIFT         0
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT0_EACH_UPDATE_MASK          0x1
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT1_EACH_UPDATE_SHIFT         1
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT1_EACH_UPDATE_MASK          0x2
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT2_EACH_UPDATE_SHIFT         2
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT2_EACH_UPDATE_MASK          0x4
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT3_EACH_UPDATE_SHIFT         3
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT3_EACH_UPDATE_MASK          0x8
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT4_EACH_UPDATE_SHIFT         4
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT4_EACH_UPDATE_MASK          0x10
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT5_EACH_UPDATE_SHIFT         5
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT5_EACH_UPDATE_MASK          0x20
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT6_EACH_UPDATE_SHIFT         6
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT6_EACH_UPDATE_MASK          0x40
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT7_EACH_UPDATE_SHIFT         7
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT7_EACH_UPDATE_MASK          0x80
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT8_EACH_UPDATE_SHIFT         8
+#define NIC0_QPC0_INTERRUPT_CFG_INTERRUPT8_EACH_UPDATE_MASK          0x100
+
+/* NIC0_QPC0_INTERRUPT_RESP_ERR_CAUSE */
+#define NIC0_QPC0_INTERRUPT_RESP_ERR_CAUSE_R_SHIFT                   0
+#define NIC0_QPC0_INTERRUPT_RESP_ERR_CAUSE_R_MASK                    0x3F
+
+/* NIC0_QPC0_INTRRRUPT_RESP_ERR_MASK */
+#define NIC0_QPC0_INTRRRUPT_RESP_ERR_MASK_R_SHIFT                    0
+#define NIC0_QPC0_INTRRRUPT_RESP_ERR_MASK_R_MASK                     0x3F
+
+/* NIC0_QPC0_INTERRUPR_RESP_ERR_CLR */
+
+/* NIC0_QPC0_TMR_GW_VALID */
+#define NIC0_QPC0_TMR_GW_VALID_R_SHIFT                               0
+#define NIC0_QPC0_TMR_GW_VALID_R_MASK                                0x1
+
+/* NIC0_QPC0_TMR_GW_DATA0 */
+#define NIC0_QPC0_TMR_GW_DATA0_OPCODE_SHIFT                          0
+#define NIC0_QPC0_TMR_GW_DATA0_OPCODE_MASK                           0x3
+
+/* NIC0_QPC0_TMR_GW_DATA1 */
+#define NIC0_QPC0_TMR_GW_DATA1_QPN_SHIFT                             0
+#define NIC0_QPC0_TMR_GW_DATA1_QPN_MASK                              0xFFFFFF
+#define NIC0_QPC0_TMR_GW_DATA1_TIMER_GRANULARITY_SHIFT               24
+#define NIC0_QPC0_TMR_GW_DATA1_TIMER_GRANULARITY_MASK                0x7F000000
+
+/* NIC0_QPC0_RNR_RETRY_COUNT_EN */
+#define NIC0_QPC0_RNR_RETRY_COUNT_EN_R_SHIFT                         0
+#define NIC0_QPC0_RNR_RETRY_COUNT_EN_R_MASK                          0x1
+
+#endif /* ASIC_REG_NIC0_QPC0_MASKS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
new file mode 100644
index 000000000000..db7aa1903c82
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
@@ -0,0 +1,710 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_QPC0_REGS_H_
+#define ASIC_REG_NIC0_QPC0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_QPC0 (Prototype: NIC_QPC)
+ *****************************************
+ */
+
+#define mmNIC0_QPC0_REQ_QPC_CACHE_INVALIDATE                         0xCE4000
+
+#define mmNIC0_QPC0_REQ_QPC_CACHE_INV_STATUS                         0xCE4004
+
+#define mmNIC0_QPC0_REQ_STATIC_CONFIG                                0xCE4008
+
+#define mmNIC0_QPC0_REQ_BASE_ADDRESS_49_18                           0xCE400C
+
+#define mmNIC0_QPC0_REQ_BASE_ADDRESS_17_7                            0xCE4010
+
+#define mmNIC0_QPC0_REQ_CLEAN_LINK_LIST                              0xCE4014
+
+#define mmNIC0_QPC0_REQ_ERR_FIFO_PUSH_63_32                          0xCE4018
+
+#define mmNIC0_QPC0_REQ_ERR_FIFO_PUSH_31_0                           0xCE401C
+
+#define mmNIC0_QPC0_REQ_ERR_QP_STATE_63_32                           0xCE4020
+
+#define mmNIC0_QPC0_REQ_ERR_QP_STATE_31_0                            0xCE4024
+
+#define mmNIC0_QPC0_RETRY_COUNT_MAX                                  0xCE4028
+
+#define mmNIC0_QPC0_AXI_USER                                         0xCE402C
+
+#define mmNIC0_QPC0_AXI_PROT                                         0xCE4030
+
+#define mmNIC0_QPC0_RES_QPC_CACHE_INVALIDATE                         0xCE4034
+
+#define mmNIC0_QPC0_RES_QPC_CACHE_INV_STATUS                         0xCE4038
+
+#define mmNIC0_QPC0_RES_STATIC_CONFIG                                0xCE403C
+
+#define mmNIC0_QPC0_RES_BASE_ADDRESS_49_18                           0xCE4040
+
+#define mmNIC0_QPC0_RES_BASE_ADDRESS_17_7                            0xCE4044
+
+#define mmNIC0_QPC0_RES_CLEAN_LINK_LIST                              0xCE4048
+
+#define mmNIC0_QPC0_ERR_FIFO_WRITE_INDEX                             0xCE4050
+
+#define mmNIC0_QPC0_ERR_FIFO_PRODUCER_INDEX                          0xCE4054
+
+#define mmNIC0_QPC0_ERR_FIFO_CONSUMER_INDEX                          0xCE4058
+
+#define mmNIC0_QPC0_ERR_FIFO_MASK                                    0xCE405C
+
+#define mmNIC0_QPC0_ERR_FIFO_CREDIT                                  0xCE4060
+
+#define mmNIC0_QPC0_ERR_FIFO_CFG                                     0xCE4064
+
+#define mmNIC0_QPC0_ERR_FIFO_INTR_MASK                               0xCE4068
+
+#define mmNIC0_QPC0_ERR_FIFO_BASE_ADDR_49_18                         0xCE406C
+
+#define mmNIC0_QPC0_ERR_FIFO_BASE_ADDR_17_7                          0xCE4070
+
+#define mmNIC0_QPC0_GW_BUSY                                          0xCE4080
+
+#define mmNIC0_QPC0_GW_CTRL                                          0xCE4084
+
+#define mmNIC0_QPC0_GW_DATA_0                                        0xCE408C
+
+#define mmNIC0_QPC0_GW_DATA_1                                        0xCE4090
+
+#define mmNIC0_QPC0_GW_DATA_2                                        0xCE4094
+
+#define mmNIC0_QPC0_GW_DATA_3                                        0xCE4098
+
+#define mmNIC0_QPC0_GW_DATA_4                                        0xCE409C
+
+#define mmNIC0_QPC0_GW_DATA_5                                        0xCE40A0
+
+#define mmNIC0_QPC0_GW_DATA_6                                        0xCE40A4
+
+#define mmNIC0_QPC0_GW_DATA_7                                        0xCE40A8
+
+#define mmNIC0_QPC0_GW_DATA_8                                        0xCE40AC
+
+#define mmNIC0_QPC0_GW_DATA_9                                        0xCE40B0
+
+#define mmNIC0_QPC0_GW_DATA_10                                       0xCE40B4
+
+#define mmNIC0_QPC0_GW_DATA_11                                       0xCE40B8
+
+#define mmNIC0_QPC0_GW_DATA_12                                       0xCE40BC
+
+#define mmNIC0_QPC0_GW_DATA_13                                       0xCE40C0
+
+#define mmNIC0_QPC0_GW_DATA_14                                       0xCE40C4
+
+#define mmNIC0_QPC0_GW_DATA_15                                       0xCE40C8
+
+#define mmNIC0_QPC0_GW_MASK_0                                        0xCE4124
+
+#define mmNIC0_QPC0_GW_MASK_1                                        0xCE4128
+
+#define mmNIC0_QPC0_GW_MASK_2                                        0xCE412C
+
+#define mmNIC0_QPC0_GW_MASK_3                                        0xCE4130
+
+#define mmNIC0_QPC0_GW_MASK_4                                        0xCE4134
+
+#define mmNIC0_QPC0_GW_MASK_5                                        0xCE4138
+
+#define mmNIC0_QPC0_GW_MASK_6                                        0xCE413C
+
+#define mmNIC0_QPC0_GW_MASK_7                                        0xCE4140
+
+#define mmNIC0_QPC0_GW_MASK_8                                        0xCE4144
+
+#define mmNIC0_QPC0_GW_MASK_9                                        0xCE4148
+
+#define mmNIC0_QPC0_GW_MASK_10                                       0xCE414C
+
+#define mmNIC0_QPC0_GW_MASK_11                                       0xCE4150
+
+#define mmNIC0_QPC0_GW_MASK_12                                       0xCE4154
+
+#define mmNIC0_QPC0_GW_MASK_13                                       0xCE4158
+
+#define mmNIC0_QPC0_GW_MASK_14                                       0xCE415C
+
+#define mmNIC0_QPC0_GW_MASK_15                                       0xCE4160
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_EN                                 0xCE41FC
+
+#define mmNIC0_QPC0_CC_TICK_WRAP                                     0xCE4200
+
+#define mmNIC0_QPC0_CC_ROLLBACK                                      0xCE4204
+
+#define mmNIC0_QPC0_CC_MAX_WINDOW_SIZE                               0xCE4208
+
+#define mmNIC0_QPC0_CC_MIN_WINDOW_SIZE                               0xCE420C
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_0                                0xCE4210
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_1                                0xCE4214
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_2                                0xCE4218
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_3                                0xCE421C
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_4                                0xCE4220
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_5                                0xCE4224
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_6                                0xCE4228
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_7                                0xCE422C
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_8                                0xCE4230
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_9                                0xCE4234
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_10                               0xCE4238
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_11                               0xCE423C
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_12                               0xCE4240
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_13                               0xCE4244
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_14                               0xCE4248
+
+#define mmNIC0_QPC0_CC_ALPHA_LINEAR_15                               0xCE424C
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_0                                   0xCE4250
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_1                                   0xCE4254
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_2                                   0xCE4258
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_3                                   0xCE425C
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_4                                   0xCE4260
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_5                                   0xCE4264
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_6                                   0xCE4268
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_7                                   0xCE426C
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_8                                   0xCE4270
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_9                                   0xCE4274
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_10                                  0xCE4278
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_11                                  0xCE427C
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_12                                  0xCE4280
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_13                                  0xCE4284
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_14                                  0xCE4288
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_15                                  0xCE428C
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_0                         0xCE4290
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_1                         0xCE4294
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_2                         0xCE4298
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_3                         0xCE429C
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_4                         0xCE42A0
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_5                         0xCE42A4
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_6                         0xCE42A8
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_7                         0xCE42AC
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_8                         0xCE42B0
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_9                         0xCE42B4
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_10                        0xCE42B8
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_11                        0xCE42BC
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_12                        0xCE42C0
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_13                        0xCE42C4
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_14                        0xCE42C8
+
+#define mmNIC0_QPC0_CC_ALPHA_LOG_THRESHOLD_15                        0xCE42CC
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_0                                  0xCE42D0
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_1                                  0xCE42D4
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_2                                  0xCE42D8
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_3                                  0xCE42DC
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_4                                  0xCE42E0
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_5                                  0xCE42E4
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_6                                  0xCE42E8
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_7                                  0xCE42EC
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_8                                  0xCE42F0
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_9                                  0xCE42F4
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_10                                 0xCE42F8
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_11                                 0xCE42FC
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_12                                 0xCE4300
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_13                                 0xCE4304
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_14                                 0xCE4308
+
+#define mmNIC0_QPC0_CC_WINDOW_INC_15                                 0xCE430C
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_0                         0xCE4310
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_1                         0xCE4314
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_2                         0xCE4318
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_3                         0xCE431C
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_4                         0xCE4320
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_5                         0xCE4324
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_6                         0xCE4328
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_7                         0xCE432C
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_8                         0xCE4330
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_9                         0xCE4334
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_10                        0xCE4338
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_11                        0xCE433C
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_12                        0xCE4340
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_13                        0xCE4344
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_14                        0xCE4348
+
+#define mmNIC0_QPC0_CC_WINDOW_IN_THRESHOLD_15                        0xCE434C
+
+#define mmNIC0_QPC0_CC_LOG_QPC_0                                     0xCE4350
+
+#define mmNIC0_QPC0_CC_LOG_QPC_1                                     0xCE4354
+
+#define mmNIC0_QPC0_CC_LOG_QPC_2                                     0xCE4358
+
+#define mmNIC0_QPC0_CC_LOG_QPC_3                                     0xCE435C
+
+#define mmNIC0_QPC0_CC_LOG_QPC_4                                     0xCE4360
+
+#define mmNIC0_QPC0_CC_LOG_QPC_5                                     0xCE4364
+
+#define mmNIC0_QPC0_CC_LOG_QPC_6                                     0xCE4368
+
+#define mmNIC0_QPC0_CC_LOG_QPC_7                                     0xCE436C
+
+#define mmNIC0_QPC0_CC_LOG_QPC_8                                     0xCE4370
+
+#define mmNIC0_QPC0_CC_LOG_QPC_9                                     0xCE4374
+
+#define mmNIC0_QPC0_CC_LOG_QPC_10                                    0xCE4378
+
+#define mmNIC0_QPC0_CC_LOG_QPC_11                                    0xCE437C
+
+#define mmNIC0_QPC0_CC_LOG_QPC_12                                    0xCE4380
+
+#define mmNIC0_QPC0_CC_LOG_QPC_13                                    0xCE4384
+
+#define mmNIC0_QPC0_CC_LOG_QPC_14                                    0xCE4388
+
+#define mmNIC0_QPC0_CC_LOG_QPC_15                                    0xCE438C
+
+#define mmNIC0_QPC0_CC_LOG_QPC_16                                    0xCE4390
+
+#define mmNIC0_QPC0_CC_LOG_QPC_17                                    0xCE4394
+
+#define mmNIC0_QPC0_CC_LOG_QPC_18                                    0xCE4398
+
+#define mmNIC0_QPC0_CC_LOG_QPC_19                                    0xCE439C
+
+#define mmNIC0_QPC0_CC_LOG_QPC_20                                    0xCE43A0
+
+#define mmNIC0_QPC0_CC_LOG_QPC_21                                    0xCE43A4
+
+#define mmNIC0_QPC0_CC_LOG_QPC_22                                    0xCE43A8
+
+#define mmNIC0_QPC0_CC_LOG_QPC_23                                    0xCE43AC
+
+#define mmNIC0_QPC0_CC_LOG_QPC_24                                    0xCE43B0
+
+#define mmNIC0_QPC0_CC_LOG_QPC_25                                    0xCE43B4
+
+#define mmNIC0_QPC0_CC_LOG_QPC_26                                    0xCE43B8
+
+#define mmNIC0_QPC0_CC_LOG_QPC_27                                    0xCE43BC
+
+#define mmNIC0_QPC0_CC_LOG_QPC_28                                    0xCE43C0
+
+#define mmNIC0_QPC0_CC_LOG_QPC_29                                    0xCE43C4
+
+#define mmNIC0_QPC0_CC_LOG_QPC_30                                    0xCE43C8
+
+#define mmNIC0_QPC0_CC_LOG_QPC_31                                    0xCE43CC
+
+#define mmNIC0_QPC0_CC_LOG_TX_0                                      0xCE43D0
+
+#define mmNIC0_QPC0_CC_LOG_TX_1                                      0xCE43D4
+
+#define mmNIC0_QPC0_CC_LOG_TX_2                                      0xCE43D8
+
+#define mmNIC0_QPC0_CC_LOG_TX_3                                      0xCE43DC
+
+#define mmNIC0_QPC0_CC_LOG_TX_4                                      0xCE43E0
+
+#define mmNIC0_QPC0_CC_LOG_TX_5                                      0xCE43E4
+
+#define mmNIC0_QPC0_CC_LOG_TX_6                                      0xCE43E8
+
+#define mmNIC0_QPC0_CC_LOG_TX_7                                      0xCE43EC
+
+#define mmNIC0_QPC0_CC_LOG_TX_8                                      0xCE43F0
+
+#define mmNIC0_QPC0_CC_LOG_TX_9                                      0xCE43F4
+
+#define mmNIC0_QPC0_CC_LOG_TX_10                                     0xCE43F8
+
+#define mmNIC0_QPC0_CC_LOG_TX_11                                     0xCE43FC
+
+#define mmNIC0_QPC0_CC_LOG_TX_12                                     0xCE4400
+
+#define mmNIC0_QPC0_CC_LOG_TX_13                                     0xCE4404
+
+#define mmNIC0_QPC0_CC_LOG_TX_14                                     0xCE4408
+
+#define mmNIC0_QPC0_CC_LOG_TX_15                                     0xCE440C
+
+#define mmNIC0_QPC0_CC_LOG_TX_16                                     0xCE4410
+
+#define mmNIC0_QPC0_CC_LOG_TX_17                                     0xCE4414
+
+#define mmNIC0_QPC0_CC_LOG_TX_18                                     0xCE4418
+
+#define mmNIC0_QPC0_CC_LOG_TX_19                                     0xCE441C
+
+#define mmNIC0_QPC0_CC_LOG_TX_20                                     0xCE4420
+
+#define mmNIC0_QPC0_CC_LOG_TX_21                                     0xCE4424
+
+#define mmNIC0_QPC0_CC_LOG_TX_22                                     0xCE4428
+
+#define mmNIC0_QPC0_CC_LOG_TX_23                                     0xCE442C
+
+#define mmNIC0_QPC0_CC_LOG_TX_24                                     0xCE4430
+
+#define mmNIC0_QPC0_CC_LOG_TX_25                                     0xCE4434
+
+#define mmNIC0_QPC0_CC_LOG_TX_26                                     0xCE4438
+
+#define mmNIC0_QPC0_CC_LOG_TX_27                                     0xCE443C
+
+#define mmNIC0_QPC0_CC_LOG_TX_28                                     0xCE4440
+
+#define mmNIC0_QPC0_CC_LOG_TX_29                                     0xCE4444
+
+#define mmNIC0_QPC0_CC_LOG_TX_30                                     0xCE4448
+
+#define mmNIC0_QPC0_CC_LOG_TX_31                                     0xCE444C
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_0                                 0xCE4450
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_1                                 0xCE4454
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_2                                 0xCE4458
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_3                                 0xCE445C
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_4                                 0xCE4460
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_5                                 0xCE4464
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_6                                 0xCE4468
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_7                                 0xCE446C
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_8                                 0xCE4470
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_9                                 0xCE4474
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_10                                0xCE4478
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_11                                0xCE447C
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_12                                0xCE4480
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_13                                0xCE4484
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_14                                0xCE4488
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_15                                0xCE448C
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_16                                0xCE4490
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_17                                0xCE4494
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_18                                0xCE4498
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_19                                0xCE449C
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_20                                0xCE44A0
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_21                                0xCE44A4
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_22                                0xCE44A8
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_23                                0xCE44AC
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_24                                0xCE44B0
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_25                                0xCE44B4
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_26                                0xCE44B8
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_27                                0xCE44BC
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_28                                0xCE44C0
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_29                                0xCE44C4
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_30                                0xCE44C8
+
+#define mmNIC0_QPC0_CC_LOG_LATENCY_31                                0xCE44CC
+
+#define mmNIC0_QPC0_CC_LOG_RX_0                                      0xCE44D0
+
+#define mmNIC0_QPC0_CC_LOG_RX_1                                      0xCE44D4
+
+#define mmNIC0_QPC0_CC_LOG_RX_2                                      0xCE44D8
+
+#define mmNIC0_QPC0_CC_LOG_RX_3                                      0xCE44DC
+
+#define mmNIC0_QPC0_CC_LOG_RX_4                                      0xCE44E0
+
+#define mmNIC0_QPC0_CC_LOG_RX_5                                      0xCE44E4
+
+#define mmNIC0_QPC0_CC_LOG_RX_6                                      0xCE44E8
+
+#define mmNIC0_QPC0_CC_LOG_RX_7                                      0xCE44EC
+
+#define mmNIC0_QPC0_CC_LOG_RX_8                                      0xCE44F0
+
+#define mmNIC0_QPC0_CC_LOG_RX_9                                      0xCE44F4
+
+#define mmNIC0_QPC0_CC_LOG_RX_10                                     0xCE44F8
+
+#define mmNIC0_QPC0_CC_LOG_RX_11                                     0xCE44FC
+
+#define mmNIC0_QPC0_CC_LOG_RX_12                                     0xCE4500
+
+#define mmNIC0_QPC0_CC_LOG_RX_13                                     0xCE4504
+
+#define mmNIC0_QPC0_CC_LOG_RX_14                                     0xCE4508
+
+#define mmNIC0_QPC0_CC_LOG_RX_15                                     0xCE450C
+
+#define mmNIC0_QPC0_CC_LOG_RX_16                                     0xCE4510
+
+#define mmNIC0_QPC0_CC_LOG_RX_17                                     0xCE4514
+
+#define mmNIC0_QPC0_CC_LOG_RX_18                                     0xCE4518
+
+#define mmNIC0_QPC0_CC_LOG_RX_19                                     0xCE451C
+
+#define mmNIC0_QPC0_CC_LOG_RX_20                                     0xCE4520
+
+#define mmNIC0_QPC0_CC_LOG_RX_21                                     0xCE4524
+
+#define mmNIC0_QPC0_CC_LOG_RX_22                                     0xCE4528
+
+#define mmNIC0_QPC0_CC_LOG_RX_23                                     0xCE452C
+
+#define mmNIC0_QPC0_CC_LOG_RX_24                                     0xCE4530
+
+#define mmNIC0_QPC0_CC_LOG_RX_25                                     0xCE4534
+
+#define mmNIC0_QPC0_CC_LOG_RX_26                                     0xCE4538
+
+#define mmNIC0_QPC0_CC_LOG_RX_27                                     0xCE453C
+
+#define mmNIC0_QPC0_CC_LOG_RX_28                                     0xCE4540
+
+#define mmNIC0_QPC0_CC_LOG_RX_29                                     0xCE4544
+
+#define mmNIC0_QPC0_CC_LOG_RX_30                                     0xCE4548
+
+#define mmNIC0_QPC0_CC_LOG_RX_31                                     0xCE454C
+
+#define mmNIC0_QPC0_CC_LOG_WINDOW_SIZE                               0xCE4550
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_0                               0xCE4600
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_1                               0xCE4604
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_2                               0xCE4608
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_3                               0xCE460C
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_4                               0xCE4610
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_5                               0xCE4614
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_6                               0xCE4618
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_7                               0xCE461C
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_8                               0xCE4620
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_9                               0xCE4624
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_10                              0xCE4628
+
+#define mmNIC0_QPC0_DBG_COUNT_SELECT_11                              0xCE462C
+
+#define mmNIC0_QPC0_UNSECURED_DOORBELL_QPN                           0xCE4630
+
+#define mmNIC0_QPC0_UNSECURED_DOORBELL_PI                            0xCE4634
+
+#define mmNIC0_QPC0_SECURED_DOORBELL_QPN                             0xCE4638
+
+#define mmNIC0_QPC0_SECURED_DOORBELL_PI                              0xCE463C
+
+#define mmNIC0_QPC0_PRIVILEGE_DOORBELL_QPN                           0xCE4640
+
+#define mmNIC0_QPC0_PRIVILEGE_DOORBELL_PI                            0xCE4644
+
+#define mmNIC0_QPC0_DOORBELL_SECURITY                                0xCE4648
+
+#define mmNIC0_QPC0_DGB_TRIG                                         0xCE464C
+
+#define mmNIC0_QPC0_RES_RING0_PI                                     0xCE4650
+
+#define mmNIC0_QPC0_RES_RING0_CI                                     0xCE4654
+
+#define mmNIC0_QPC0_RES_RING0_CFG                                    0xCE4658
+
+#define mmNIC0_QPC0_RES_RING1_PI                                     0xCE465C
+
+#define mmNIC0_QPC0_RES_RING1_CI                                     0xCE4660
+
+#define mmNIC0_QPC0_RES_RING1_CFG                                    0xCE4664
+
+#define mmNIC0_QPC0_RES_RING2_PI                                     0xCE4668
+
+#define mmNIC0_QPC0_RES_RING2_CI                                     0xCE466C
+
+#define mmNIC0_QPC0_RES_RING2_CFG                                    0xCE4670
+
+#define mmNIC0_QPC0_RES_RING3_PI                                     0xCE4674
+
+#define mmNIC0_QPC0_RES_RING3_CI                                     0xCE4678
+
+#define mmNIC0_QPC0_RES_RING3_CFG                                    0xCE467C
+
+#define mmNIC0_QPC0_REQ_RING0_CI                                     0xCE4680
+
+#define mmNIC0_QPC0_REQ_RING1_CI                                     0xCE4684
+
+#define mmNIC0_QPC0_REQ_RING2_CI                                     0xCE4688
+
+#define mmNIC0_QPC0_REQ_RING3_CI                                     0xCE468C
+
+#define mmNIC0_QPC0_INTERRUPT_CAUSE                                  0xCE4690
+
+#define mmNIC0_QPC0_INTERRUPT_MASK                                   0xCE4694
+
+#define mmNIC0_QPC0_INTERRUPT_CLR                                    0xCE4698
+
+#define mmNIC0_QPC0_INTERRUPT_EN                                     0xCE469C
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_0                                 0xCE46A0
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_1                                 0xCE46A4
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_2                                 0xCE46A8
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_3                                 0xCE46AC
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_4                                 0xCE46B0
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_5                                 0xCE46B4
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_6                                 0xCE46B8
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_7                                 0xCE46BC
+
+#define mmNIC0_QPC0_INTERRUPT_BASE_8                                 0xCE46C0
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_0                                 0xCE46C4
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_1                                 0xCE46C8
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_2                                 0xCE46CC
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_3                                 0xCE46D0
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_4                                 0xCE46D4
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_5                                 0xCE46D8
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_6                                 0xCE46DC
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_7                                 0xCE46E0
+
+#define mmNIC0_QPC0_INTERRUPT_DATA_8                                 0xCE46E4
+
+#define mmNIC0_QPC0_INTERRUPT_PROT                                   0xCE46E8
+
+#define mmNIC0_QPC0_INTERRUPT_USER                                   0xCE46EC
+
+#define mmNIC0_QPC0_INTERRUPT_CFG                                    0xCE46F0
+
+#define mmNIC0_QPC0_INTERRUPT_RESP_ERR_CAUSE                         0xCE46F4
+
+#define mmNIC0_QPC0_INTRRRUPT_RESP_ERR_MASK                          0xCE46F8
+
+#define mmNIC0_QPC0_INTERRUPR_RESP_ERR_CLR                           0xCE4700
+
+#define mmNIC0_QPC0_TMR_GW_VALID                                     0xCE4704
+
+#define mmNIC0_QPC0_TMR_GW_DATA0                                     0xCE4708
+
+#define mmNIC0_QPC0_TMR_GW_DATA1                                     0xCE470C
+
+#define mmNIC0_QPC0_RNR_RETRY_COUNT_EN                               0xCE4710
+
+#endif /* ASIC_REG_NIC0_QPC0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
new file mode 100644
index 000000000000..6541f8f4b951
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
@@ -0,0 +1,710 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_QPC1_REGS_H_
+#define ASIC_REG_NIC0_QPC1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_QPC1 (Prototype: NIC_QPC)
+ *****************************************
+ */
+
+#define mmNIC0_QPC1_REQ_QPC_CACHE_INVALIDATE                         0xCE5000
+
+#define mmNIC0_QPC1_REQ_QPC_CACHE_INV_STATUS                         0xCE5004
+
+#define mmNIC0_QPC1_REQ_STATIC_CONFIG                                0xCE5008
+
+#define mmNIC0_QPC1_REQ_BASE_ADDRESS_49_18                           0xCE500C
+
+#define mmNIC0_QPC1_REQ_BASE_ADDRESS_17_7                            0xCE5010
+
+#define mmNIC0_QPC1_REQ_CLEAN_LINK_LIST                              0xCE5014
+
+#define mmNIC0_QPC1_REQ_ERR_FIFO_PUSH_63_32                          0xCE5018
+
+#define mmNIC0_QPC1_REQ_ERR_FIFO_PUSH_31_0                           0xCE501C
+
+#define mmNIC0_QPC1_REQ_ERR_QP_STATE_63_32                           0xCE5020
+
+#define mmNIC0_QPC1_REQ_ERR_QP_STATE_31_0                            0xCE5024
+
+#define mmNIC0_QPC1_RETRY_COUNT_MAX                                  0xCE5028
+
+#define mmNIC0_QPC1_AXI_USER                                         0xCE502C
+
+#define mmNIC0_QPC1_AXI_PROT                                         0xCE5030
+
+#define mmNIC0_QPC1_RES_QPC_CACHE_INVALIDATE                         0xCE5034
+
+#define mmNIC0_QPC1_RES_QPC_CACHE_INV_STATUS                         0xCE5038
+
+#define mmNIC0_QPC1_RES_STATIC_CONFIG                                0xCE503C
+
+#define mmNIC0_QPC1_RES_BASE_ADDRESS_49_18                           0xCE5040
+
+#define mmNIC0_QPC1_RES_BASE_ADDRESS_17_7                            0xCE5044
+
+#define mmNIC0_QPC1_RES_CLEAN_LINK_LIST                              0xCE5048
+
+#define mmNIC0_QPC1_ERR_FIFO_WRITE_INDEX                             0xCE5050
+
+#define mmNIC0_QPC1_ERR_FIFO_PRODUCER_INDEX                          0xCE5054
+
+#define mmNIC0_QPC1_ERR_FIFO_CONSUMER_INDEX                          0xCE5058
+
+#define mmNIC0_QPC1_ERR_FIFO_MASK                                    0xCE505C
+
+#define mmNIC0_QPC1_ERR_FIFO_CREDIT                                  0xCE5060
+
+#define mmNIC0_QPC1_ERR_FIFO_CFG                                     0xCE5064
+
+#define mmNIC0_QPC1_ERR_FIFO_INTR_MASK                               0xCE5068
+
+#define mmNIC0_QPC1_ERR_FIFO_BASE_ADDR_49_18                         0xCE506C
+
+#define mmNIC0_QPC1_ERR_FIFO_BASE_ADDR_17_7                          0xCE5070
+
+#define mmNIC0_QPC1_GW_BUSY                                          0xCE5080
+
+#define mmNIC0_QPC1_GW_CTRL                                          0xCE5084
+
+#define mmNIC0_QPC1_GW_DATA_0                                        0xCE508C
+
+#define mmNIC0_QPC1_GW_DATA_1                                        0xCE5090
+
+#define mmNIC0_QPC1_GW_DATA_2                                        0xCE5094
+
+#define mmNIC0_QPC1_GW_DATA_3                                        0xCE5098
+
+#define mmNIC0_QPC1_GW_DATA_4                                        0xCE509C
+
+#define mmNIC0_QPC1_GW_DATA_5                                        0xCE50A0
+
+#define mmNIC0_QPC1_GW_DATA_6                                        0xCE50A4
+
+#define mmNIC0_QPC1_GW_DATA_7                                        0xCE50A8
+
+#define mmNIC0_QPC1_GW_DATA_8                                        0xCE50AC
+
+#define mmNIC0_QPC1_GW_DATA_9                                        0xCE50B0
+
+#define mmNIC0_QPC1_GW_DATA_10                                       0xCE50B4
+
+#define mmNIC0_QPC1_GW_DATA_11                                       0xCE50B8
+
+#define mmNIC0_QPC1_GW_DATA_12                                       0xCE50BC
+
+#define mmNIC0_QPC1_GW_DATA_13                                       0xCE50C0
+
+#define mmNIC0_QPC1_GW_DATA_14                                       0xCE50C4
+
+#define mmNIC0_QPC1_GW_DATA_15                                       0xCE50C8
+
+#define mmNIC0_QPC1_GW_MASK_0                                        0xCE5124
+
+#define mmNIC0_QPC1_GW_MASK_1                                        0xCE5128
+
+#define mmNIC0_QPC1_GW_MASK_2                                        0xCE512C
+
+#define mmNIC0_QPC1_GW_MASK_3                                        0xCE5130
+
+#define mmNIC0_QPC1_GW_MASK_4                                        0xCE5134
+
+#define mmNIC0_QPC1_GW_MASK_5                                        0xCE5138
+
+#define mmNIC0_QPC1_GW_MASK_6                                        0xCE513C
+
+#define mmNIC0_QPC1_GW_MASK_7                                        0xCE5140
+
+#define mmNIC0_QPC1_GW_MASK_8                                        0xCE5144
+
+#define mmNIC0_QPC1_GW_MASK_9                                        0xCE5148
+
+#define mmNIC0_QPC1_GW_MASK_10                                       0xCE514C
+
+#define mmNIC0_QPC1_GW_MASK_11                                       0xCE5150
+
+#define mmNIC0_QPC1_GW_MASK_12                                       0xCE5154
+
+#define mmNIC0_QPC1_GW_MASK_13                                       0xCE5158
+
+#define mmNIC0_QPC1_GW_MASK_14                                       0xCE515C
+
+#define mmNIC0_QPC1_GW_MASK_15                                       0xCE5160
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_EN                                 0xCE51FC
+
+#define mmNIC0_QPC1_CC_TICK_WRAP                                     0xCE5200
+
+#define mmNIC0_QPC1_CC_ROLLBACK                                      0xCE5204
+
+#define mmNIC0_QPC1_CC_MAX_WINDOW_SIZE                               0xCE5208
+
+#define mmNIC0_QPC1_CC_MIN_WINDOW_SIZE                               0xCE520C
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_0                                0xCE5210
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_1                                0xCE5214
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_2                                0xCE5218
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_3                                0xCE521C
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_4                                0xCE5220
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_5                                0xCE5224
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_6                                0xCE5228
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_7                                0xCE522C
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_8                                0xCE5230
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_9                                0xCE5234
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_10                               0xCE5238
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_11                               0xCE523C
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_12                               0xCE5240
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_13                               0xCE5244
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_14                               0xCE5248
+
+#define mmNIC0_QPC1_CC_ALPHA_LINEAR_15                               0xCE524C
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_0                                   0xCE5250
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_1                                   0xCE5254
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_2                                   0xCE5258
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_3                                   0xCE525C
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_4                                   0xCE5260
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_5                                   0xCE5264
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_6                                   0xCE5268
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_7                                   0xCE526C
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_8                                   0xCE5270
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_9                                   0xCE5274
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_10                                  0xCE5278
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_11                                  0xCE527C
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_12                                  0xCE5280
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_13                                  0xCE5284
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_14                                  0xCE5288
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_15                                  0xCE528C
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_0                         0xCE5290
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_1                         0xCE5294
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_2                         0xCE5298
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_3                         0xCE529C
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_4                         0xCE52A0
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_5                         0xCE52A4
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_6                         0xCE52A8
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_7                         0xCE52AC
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_8                         0xCE52B0
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_9                         0xCE52B4
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_10                        0xCE52B8
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_11                        0xCE52BC
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_12                        0xCE52C0
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_13                        0xCE52C4
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_14                        0xCE52C8
+
+#define mmNIC0_QPC1_CC_ALPHA_LOG_THRESHOLD_15                        0xCE52CC
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_0                                  0xCE52D0
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_1                                  0xCE52D4
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_2                                  0xCE52D8
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_3                                  0xCE52DC
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_4                                  0xCE52E0
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_5                                  0xCE52E4
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_6                                  0xCE52E8
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_7                                  0xCE52EC
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_8                                  0xCE52F0
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_9                                  0xCE52F4
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_10                                 0xCE52F8
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_11                                 0xCE52FC
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_12                                 0xCE5300
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_13                                 0xCE5304
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_14                                 0xCE5308
+
+#define mmNIC0_QPC1_CC_WINDOW_INC_15                                 0xCE530C
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_0                         0xCE5310
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_1                         0xCE5314
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_2                         0xCE5318
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_3                         0xCE531C
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_4                         0xCE5320
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_5                         0xCE5324
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_6                         0xCE5328
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_7                         0xCE532C
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_8                         0xCE5330
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_9                         0xCE5334
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_10                        0xCE5338
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_11                        0xCE533C
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_12                        0xCE5340
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_13                        0xCE5344
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_14                        0xCE5348
+
+#define mmNIC0_QPC1_CC_WINDOW_IN_THRESHOLD_15                        0xCE534C
+
+#define mmNIC0_QPC1_CC_LOG_QPC_0                                     0xCE5350
+
+#define mmNIC0_QPC1_CC_LOG_QPC_1                                     0xCE5354
+
+#define mmNIC0_QPC1_CC_LOG_QPC_2                                     0xCE5358
+
+#define mmNIC0_QPC1_CC_LOG_QPC_3                                     0xCE535C
+
+#define mmNIC0_QPC1_CC_LOG_QPC_4                                     0xCE5360
+
+#define mmNIC0_QPC1_CC_LOG_QPC_5                                     0xCE5364
+
+#define mmNIC0_QPC1_CC_LOG_QPC_6                                     0xCE5368
+
+#define mmNIC0_QPC1_CC_LOG_QPC_7                                     0xCE536C
+
+#define mmNIC0_QPC1_CC_LOG_QPC_8                                     0xCE5370
+
+#define mmNIC0_QPC1_CC_LOG_QPC_9                                     0xCE5374
+
+#define mmNIC0_QPC1_CC_LOG_QPC_10                                    0xCE5378
+
+#define mmNIC0_QPC1_CC_LOG_QPC_11                                    0xCE537C
+
+#define mmNIC0_QPC1_CC_LOG_QPC_12                                    0xCE5380
+
+#define mmNIC0_QPC1_CC_LOG_QPC_13                                    0xCE5384
+
+#define mmNIC0_QPC1_CC_LOG_QPC_14                                    0xCE5388
+
+#define mmNIC0_QPC1_CC_LOG_QPC_15                                    0xCE538C
+
+#define mmNIC0_QPC1_CC_LOG_QPC_16                                    0xCE5390
+
+#define mmNIC0_QPC1_CC_LOG_QPC_17                                    0xCE5394
+
+#define mmNIC0_QPC1_CC_LOG_QPC_18                                    0xCE5398
+
+#define mmNIC0_QPC1_CC_LOG_QPC_19                                    0xCE539C
+
+#define mmNIC0_QPC1_CC_LOG_QPC_20                                    0xCE53A0
+
+#define mmNIC0_QPC1_CC_LOG_QPC_21                                    0xCE53A4
+
+#define mmNIC0_QPC1_CC_LOG_QPC_22                                    0xCE53A8
+
+#define mmNIC0_QPC1_CC_LOG_QPC_23                                    0xCE53AC
+
+#define mmNIC0_QPC1_CC_LOG_QPC_24                                    0xCE53B0
+
+#define mmNIC0_QPC1_CC_LOG_QPC_25                                    0xCE53B4
+
+#define mmNIC0_QPC1_CC_LOG_QPC_26                                    0xCE53B8
+
+#define mmNIC0_QPC1_CC_LOG_QPC_27                                    0xCE53BC
+
+#define mmNIC0_QPC1_CC_LOG_QPC_28                                    0xCE53C0
+
+#define mmNIC0_QPC1_CC_LOG_QPC_29                                    0xCE53C4
+
+#define mmNIC0_QPC1_CC_LOG_QPC_30                                    0xCE53C8
+
+#define mmNIC0_QPC1_CC_LOG_QPC_31                                    0xCE53CC
+
+#define mmNIC0_QPC1_CC_LOG_TX_0                                      0xCE53D0
+
+#define mmNIC0_QPC1_CC_LOG_TX_1                                      0xCE53D4
+
+#define mmNIC0_QPC1_CC_LOG_TX_2                                      0xCE53D8
+
+#define mmNIC0_QPC1_CC_LOG_TX_3                                      0xCE53DC
+
+#define mmNIC0_QPC1_CC_LOG_TX_4                                      0xCE53E0
+
+#define mmNIC0_QPC1_CC_LOG_TX_5                                      0xCE53E4
+
+#define mmNIC0_QPC1_CC_LOG_TX_6                                      0xCE53E8
+
+#define mmNIC0_QPC1_CC_LOG_TX_7                                      0xCE53EC
+
+#define mmNIC0_QPC1_CC_LOG_TX_8                                      0xCE53F0
+
+#define mmNIC0_QPC1_CC_LOG_TX_9                                      0xCE53F4
+
+#define mmNIC0_QPC1_CC_LOG_TX_10                                     0xCE53F8
+
+#define mmNIC0_QPC1_CC_LOG_TX_11                                     0xCE53FC
+
+#define mmNIC0_QPC1_CC_LOG_TX_12                                     0xCE5400
+
+#define mmNIC0_QPC1_CC_LOG_TX_13                                     0xCE5404
+
+#define mmNIC0_QPC1_CC_LOG_TX_14                                     0xCE5408
+
+#define mmNIC0_QPC1_CC_LOG_TX_15                                     0xCE540C
+
+#define mmNIC0_QPC1_CC_LOG_TX_16                                     0xCE5410
+
+#define mmNIC0_QPC1_CC_LOG_TX_17                                     0xCE5414
+
+#define mmNIC0_QPC1_CC_LOG_TX_18                                     0xCE5418
+
+#define mmNIC0_QPC1_CC_LOG_TX_19                                     0xCE541C
+
+#define mmNIC0_QPC1_CC_LOG_TX_20                                     0xCE5420
+
+#define mmNIC0_QPC1_CC_LOG_TX_21                                     0xCE5424
+
+#define mmNIC0_QPC1_CC_LOG_TX_22                                     0xCE5428
+
+#define mmNIC0_QPC1_CC_LOG_TX_23                                     0xCE542C
+
+#define mmNIC0_QPC1_CC_LOG_TX_24                                     0xCE5430
+
+#define mmNIC0_QPC1_CC_LOG_TX_25                                     0xCE5434
+
+#define mmNIC0_QPC1_CC_LOG_TX_26                                     0xCE5438
+
+#define mmNIC0_QPC1_CC_LOG_TX_27                                     0xCE543C
+
+#define mmNIC0_QPC1_CC_LOG_TX_28                                     0xCE5440
+
+#define mmNIC0_QPC1_CC_LOG_TX_29                                     0xCE5444
+
+#define mmNIC0_QPC1_CC_LOG_TX_30                                     0xCE5448
+
+#define mmNIC0_QPC1_CC_LOG_TX_31                                     0xCE544C
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_0                                 0xCE5450
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_1                                 0xCE5454
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_2                                 0xCE5458
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_3                                 0xCE545C
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_4                                 0xCE5460
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_5                                 0xCE5464
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_6                                 0xCE5468
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_7                                 0xCE546C
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_8                                 0xCE5470
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_9                                 0xCE5474
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_10                                0xCE5478
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_11                                0xCE547C
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_12                                0xCE5480
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_13                                0xCE5484
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_14                                0xCE5488
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_15                                0xCE548C
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_16                                0xCE5490
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_17                                0xCE5494
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_18                                0xCE5498
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_19                                0xCE549C
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_20                                0xCE54A0
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_21                                0xCE54A4
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_22                                0xCE54A8
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_23                                0xCE54AC
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_24                                0xCE54B0
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_25                                0xCE54B4
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_26                                0xCE54B8
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_27                                0xCE54BC
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_28                                0xCE54C0
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_29                                0xCE54C4
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_30                                0xCE54C8
+
+#define mmNIC0_QPC1_CC_LOG_LATENCY_31                                0xCE54CC
+
+#define mmNIC0_QPC1_CC_LOG_RX_0                                      0xCE54D0
+
+#define mmNIC0_QPC1_CC_LOG_RX_1                                      0xCE54D4
+
+#define mmNIC0_QPC1_CC_LOG_RX_2                                      0xCE54D8
+
+#define mmNIC0_QPC1_CC_LOG_RX_3                                      0xCE54DC
+
+#define mmNIC0_QPC1_CC_LOG_RX_4                                      0xCE54E0
+
+#define mmNIC0_QPC1_CC_LOG_RX_5                                      0xCE54E4
+
+#define mmNIC0_QPC1_CC_LOG_RX_6                                      0xCE54E8
+
+#define mmNIC0_QPC1_CC_LOG_RX_7                                      0xCE54EC
+
+#define mmNIC0_QPC1_CC_LOG_RX_8                                      0xCE54F0
+
+#define mmNIC0_QPC1_CC_LOG_RX_9                                      0xCE54F4
+
+#define mmNIC0_QPC1_CC_LOG_RX_10                                     0xCE54F8
+
+#define mmNIC0_QPC1_CC_LOG_RX_11                                     0xCE54FC
+
+#define mmNIC0_QPC1_CC_LOG_RX_12                                     0xCE5500
+
+#define mmNIC0_QPC1_CC_LOG_RX_13                                     0xCE5504
+
+#define mmNIC0_QPC1_CC_LOG_RX_14                                     0xCE5508
+
+#define mmNIC0_QPC1_CC_LOG_RX_15                                     0xCE550C
+
+#define mmNIC0_QPC1_CC_LOG_RX_16                                     0xCE5510
+
+#define mmNIC0_QPC1_CC_LOG_RX_17                                     0xCE5514
+
+#define mmNIC0_QPC1_CC_LOG_RX_18                                     0xCE5518
+
+#define mmNIC0_QPC1_CC_LOG_RX_19                                     0xCE551C
+
+#define mmNIC0_QPC1_CC_LOG_RX_20                                     0xCE5520
+
+#define mmNIC0_QPC1_CC_LOG_RX_21                                     0xCE5524
+
+#define mmNIC0_QPC1_CC_LOG_RX_22                                     0xCE5528
+
+#define mmNIC0_QPC1_CC_LOG_RX_23                                     0xCE552C
+
+#define mmNIC0_QPC1_CC_LOG_RX_24                                     0xCE5530
+
+#define mmNIC0_QPC1_CC_LOG_RX_25                                     0xCE5534
+
+#define mmNIC0_QPC1_CC_LOG_RX_26                                     0xCE5538
+
+#define mmNIC0_QPC1_CC_LOG_RX_27                                     0xCE553C
+
+#define mmNIC0_QPC1_CC_LOG_RX_28                                     0xCE5540
+
+#define mmNIC0_QPC1_CC_LOG_RX_29                                     0xCE5544
+
+#define mmNIC0_QPC1_CC_LOG_RX_30                                     0xCE5548
+
+#define mmNIC0_QPC1_CC_LOG_RX_31                                     0xCE554C
+
+#define mmNIC0_QPC1_CC_LOG_WINDOW_SIZE                               0xCE5550
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_0                               0xCE5600
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_1                               0xCE5604
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_2                               0xCE5608
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_3                               0xCE560C
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_4                               0xCE5610
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_5                               0xCE5614
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_6                               0xCE5618
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_7                               0xCE561C
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_8                               0xCE5620
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_9                               0xCE5624
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_10                              0xCE5628
+
+#define mmNIC0_QPC1_DBG_COUNT_SELECT_11                              0xCE562C
+
+#define mmNIC0_QPC1_UNSECURED_DOORBELL_QPN                           0xCE5630
+
+#define mmNIC0_QPC1_UNSECURED_DOORBELL_PI                            0xCE5634
+
+#define mmNIC0_QPC1_SECURED_DOORBELL_QPN                             0xCE5638
+
+#define mmNIC0_QPC1_SECURED_DOORBELL_PI                              0xCE563C
+
+#define mmNIC0_QPC1_PRIVILEGE_DOORBELL_QPN                           0xCE5640
+
+#define mmNIC0_QPC1_PRIVILEGE_DOORBELL_PI                            0xCE5644
+
+#define mmNIC0_QPC1_DOORBELL_SECURITY                                0xCE5648
+
+#define mmNIC0_QPC1_DGB_TRIG                                         0xCE564C
+
+#define mmNIC0_QPC1_RES_RING0_PI                                     0xCE5650
+
+#define mmNIC0_QPC1_RES_RING0_CI                                     0xCE5654
+
+#define mmNIC0_QPC1_RES_RING0_CFG                                    0xCE5658
+
+#define mmNIC0_QPC1_RES_RING1_PI                                     0xCE565C
+
+#define mmNIC0_QPC1_RES_RING1_CI                                     0xCE5660
+
+#define mmNIC0_QPC1_RES_RING1_CFG                                    0xCE5664
+
+#define mmNIC0_QPC1_RES_RING2_PI                                     0xCE5668
+
+#define mmNIC0_QPC1_RES_RING2_CI                                     0xCE566C
+
+#define mmNIC0_QPC1_RES_RING2_CFG                                    0xCE5670
+
+#define mmNIC0_QPC1_RES_RING3_PI                                     0xCE5674
+
+#define mmNIC0_QPC1_RES_RING3_CI                                     0xCE5678
+
+#define mmNIC0_QPC1_RES_RING3_CFG                                    0xCE567C
+
+#define mmNIC0_QPC1_REQ_RING0_CI                                     0xCE5680
+
+#define mmNIC0_QPC1_REQ_RING1_CI                                     0xCE5684
+
+#define mmNIC0_QPC1_REQ_RING2_CI                                     0xCE5688
+
+#define mmNIC0_QPC1_REQ_RING3_CI                                     0xCE568C
+
+#define mmNIC0_QPC1_INTERRUPT_CAUSE                                  0xCE5690
+
+#define mmNIC0_QPC1_INTERRUPT_MASK                                   0xCE5694
+
+#define mmNIC0_QPC1_INTERRUPT_CLR                                    0xCE5698
+
+#define mmNIC0_QPC1_INTERRUPT_EN                                     0xCE569C
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_0                                 0xCE56A0
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_1                                 0xCE56A4
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_2                                 0xCE56A8
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_3                                 0xCE56AC
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_4                                 0xCE56B0
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_5                                 0xCE56B4
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_6                                 0xCE56B8
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_7                                 0xCE56BC
+
+#define mmNIC0_QPC1_INTERRUPT_BASE_8                                 0xCE56C0
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_0                                 0xCE56C4
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_1                                 0xCE56C8
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_2                                 0xCE56CC
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_3                                 0xCE56D0
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_4                                 0xCE56D4
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_5                                 0xCE56D8
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_6                                 0xCE56DC
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_7                                 0xCE56E0
+
+#define mmNIC0_QPC1_INTERRUPT_DATA_8                                 0xCE56E4
+
+#define mmNIC0_QPC1_INTERRUPT_PROT                                   0xCE56E8
+
+#define mmNIC0_QPC1_INTERRUPT_USER                                   0xCE56EC
+
+#define mmNIC0_QPC1_INTERRUPT_CFG                                    0xCE56F0
+
+#define mmNIC0_QPC1_INTERRUPT_RESP_ERR_CAUSE                         0xCE56F4
+
+#define mmNIC0_QPC1_INTRRRUPT_RESP_ERR_MASK                          0xCE56F8
+
+#define mmNIC0_QPC1_INTERRUPR_RESP_ERR_CLR                           0xCE5700
+
+#define mmNIC0_QPC1_TMR_GW_VALID                                     0xCE5704
+
+#define mmNIC0_QPC1_TMR_GW_DATA0                                     0xCE5708
+
+#define mmNIC0_QPC1_TMR_GW_DATA1                                     0xCE570C
+
+#define mmNIC0_QPC1_RNR_RETRY_COUNT_EN                               0xCE5710
+
+#endif /* ASIC_REG_NIC0_QPC1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
new file mode 100644
index 000000000000..cf7b2ac41372
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
@@ -0,0 +1,508 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_RXB_REGS_H_
+#define ASIC_REG_NIC0_RXB_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_RXB (Prototype: NIC_RXB_CORE)
+ *****************************************
+ */
+
+#define mmNIC0_RXB_HL_ROCE_CONFIG                                    0xCE8100
+
+#define mmNIC0_RXB_DYNAMIC_CREDITS                                   0xCE8104
+
+#define mmNIC0_RXB_MAX_DYNAMIC                                       0xCE8108
+
+#define mmNIC0_RXB_STATIC_CREDITS_0                                  0xCE810C
+
+#define mmNIC0_RXB_STATIC_CREDITS_1                                  0xCE8110
+
+#define mmNIC0_RXB_STATIC_CREDITS_2                                  0xCE8114
+
+#define mmNIC0_RXB_STATIC_CREDITS_3                                  0xCE8118
+
+#define mmNIC0_RXB_STATIC_CREDITS_4                                  0xCE811C
+
+#define mmNIC0_RXB_STATIC_CREDITS_5                                  0xCE8120
+
+#define mmNIC0_RXB_STATIC_CREDITS_6                                  0xCE8124
+
+#define mmNIC0_RXB_STATIC_CREDITS_7                                  0xCE8128
+
+#define mmNIC0_RXB_STATIC_CREDITS_8                                  0xCE812C
+
+#define mmNIC0_RXB_STATIC_CREDITS_9                                  0xCE8130
+
+#define mmNIC0_RXB_STATIC_CREDITS_10                                 0xCE8134
+
+#define mmNIC0_RXB_STATIC_CREDITS_11                                 0xCE8138
+
+#define mmNIC0_RXB_STATIC_CREDITS_12                                 0xCE813C
+
+#define mmNIC0_RXB_STATIC_CREDITS_13                                 0xCE8140
+
+#define mmNIC0_RXB_STATIC_CREDITS_14                                 0xCE8144
+
+#define mmNIC0_RXB_STATIC_CREDITS_15                                 0xCE8148
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_0                              0xCE814C
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_1                              0xCE8150
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_2                              0xCE8154
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_3                              0xCE8158
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_4                              0xCE815C
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_5                              0xCE8160
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_6                              0xCE8164
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_7                              0xCE8168
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_8                              0xCE816C
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_9                              0xCE8170
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_10                             0xCE8174
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_11                             0xCE8178
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_12                             0xCE817C
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_13                             0xCE8180
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_14                             0xCE8184
+
+#define mmNIC0_RXB_MAX_STATIC_CREDITS_15                             0xCE8188
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_0                                  0xCE818C
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_1                                  0xCE8190
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_2                                  0xCE8194
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_3                                  0xCE8198
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_4                                  0xCE819C
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_5                                  0xCE81A0
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_6                                  0xCE81A4
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_7                                  0xCE81A8
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_8                                  0xCE81AC
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_9                                  0xCE81B0
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_10                                 0xCE81B4
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_11                                 0xCE81B8
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_12                                 0xCE81BC
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_13                                 0xCE81C0
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_14                                 0xCE81C4
+
+#define mmNIC0_RXB_XOFF_THRESHOLD_15                                 0xCE81C8
+
+#define mmNIC0_RXB_XON_THRESHOLD_0                                   0xCE81CC
+
+#define mmNIC0_RXB_XON_THRESHOLD_1                                   0xCE81D0
+
+#define mmNIC0_RXB_XON_THRESHOLD_2                                   0xCE81D4
+
+#define mmNIC0_RXB_XON_THRESHOLD_3                                   0xCE81D8
+
+#define mmNIC0_RXB_XON_THRESHOLD_4                                   0xCE81DC
+
+#define mmNIC0_RXB_XON_THRESHOLD_5                                   0xCE81E0
+
+#define mmNIC0_RXB_XON_THRESHOLD_6                                   0xCE81E4
+
+#define mmNIC0_RXB_XON_THRESHOLD_7                                   0xCE81E8
+
+#define mmNIC0_RXB_XON_THRESHOLD_8                                   0xCE81EC
+
+#define mmNIC0_RXB_XON_THRESHOLD_9                                   0xCE81F0
+
+#define mmNIC0_RXB_XON_THRESHOLD_10                                  0xCE81F4
+
+#define mmNIC0_RXB_XON_THRESHOLD_11                                  0xCE81F8
+
+#define mmNIC0_RXB_XON_THRESHOLD_12                                  0xCE81FC
+
+#define mmNIC0_RXB_XON_THRESHOLD_13                                  0xCE8200
+
+#define mmNIC0_RXB_XON_THRESHOLD_14                                  0xCE8204
+
+#define mmNIC0_RXB_XON_THRESHOLD_15                                  0xCE8208
+
+#define mmNIC0_RXB_DROP_THRESHOLD_0                                  0xCE820C
+
+#define mmNIC0_RXB_DROP_THRESHOLD_1                                  0xCE8210
+
+#define mmNIC0_RXB_DROP_THRESHOLD_2                                  0xCE8214
+
+#define mmNIC0_RXB_DROP_THRESHOLD_3                                  0xCE8218
+
+#define mmNIC0_RXB_DROP_THRESHOLD_4                                  0xCE821C
+
+#define mmNIC0_RXB_DROP_THRESHOLD_5                                  0xCE8220
+
+#define mmNIC0_RXB_DROP_THRESHOLD_6                                  0xCE8224
+
+#define mmNIC0_RXB_DROP_THRESHOLD_7                                  0xCE8228
+
+#define mmNIC0_RXB_DROP_THRESHOLD_8                                  0xCE822C
+
+#define mmNIC0_RXB_DROP_THRESHOLD_9                                  0xCE8230
+
+#define mmNIC0_RXB_DROP_THRESHOLD_10                                 0xCE8234
+
+#define mmNIC0_RXB_DROP_THRESHOLD_11                                 0xCE8238
+
+#define mmNIC0_RXB_DROP_THRESHOLD_12                                 0xCE823C
+
+#define mmNIC0_RXB_DROP_THRESHOLD_13                                 0xCE8240
+
+#define mmNIC0_RXB_DROP_THRESHOLD_14                                 0xCE8244
+
+#define mmNIC0_RXB_DROP_THRESHOLD_15                                 0xCE8248
+
+#define mmNIC0_RXB_PORT_TRUST_LEVEL                                  0xCE824C
+
+#define mmNIC0_RXB_PORT_DEFAULT_PRIO                                 0xCE8250
+
+#define mmNIC0_RXB_DSCP2PRIO_0                                       0xCE8260
+
+#define mmNIC0_RXB_DSCP2PRIO_1                                       0xCE8264
+
+#define mmNIC0_RXB_DSCP2PRIO_2                                       0xCE8268
+
+#define mmNIC0_RXB_DSCP2PRIO_3                                       0xCE826C
+
+#define mmNIC0_RXB_DSCP2PRIO_4                                       0xCE8270
+
+#define mmNIC0_RXB_DSCP2PRIO_5                                       0xCE8274
+
+#define mmNIC0_RXB_DSCP2PRIO_6                                       0xCE8278
+
+#define mmNIC0_RXB_DSCP2PRIO_7                                       0xCE827C
+
+#define mmNIC0_RXB_ICRC_CFG                                          0xCE8280
+
+#define mmNIC0_RXB_LBW_OFFSET_0                                      0xCE8284
+
+#define mmNIC0_RXB_LBW_OFFSET_1                                      0xCE8288
+
+#define mmNIC0_RXB_AXI_AXPROT_PRIV                                   0xCE828C
+
+#define mmNIC0_RXB_AXI_AXPROT_TRUST                                  0xCE8290
+
+#define mmNIC0_RXB_AXI_AXPROT_UNTRUST                                0xCE8294
+
+#define mmNIC0_RXB_AXI_AXUSER_10_0_PRIV                              0xCE8298
+
+#define mmNIC0_RXB_AXI_AXUSER_10_0_TRUST                             0xCE829C
+
+#define mmNIC0_RXB_AXI_AXUSER_10_0_UNTRUST                           0xCE82A0
+
+#define mmNIC0_RXB_AXI_AXUSER_31_11_PRIV                             0xCE82A4
+
+#define mmNIC0_RXB_AXI_AXUSER_31_11_TRUST                            0xCE82A8
+
+#define mmNIC0_RXB_AXI_AXUSER_31_11_UNTRUST                          0xCE82AC
+
+#define mmNIC0_RXB_VLAN_ETHERTYPES                                   0xCE82B0
+
+#define mmNIC0_RXB_TS_RC_MAC_31_0_0                                  0xCE82C0
+
+#define mmNIC0_RXB_TS_RC_MAC_31_0_1                                  0xCE82C4
+
+#define mmNIC0_RXB_TS_RC_MAC_31_0_2                                  0xCE82C8
+
+#define mmNIC0_RXB_TS_RC_MAC_31_0_3                                  0xCE82CC
+
+#define mmNIC0_RXB_TS_RC_MAC_47_32_0                                 0xCE82D0
+
+#define mmNIC0_RXB_TS_RC_MAC_47_32_1                                 0xCE82D4
+
+#define mmNIC0_RXB_TS_RC_MAC_47_32_2                                 0xCE82D8
+
+#define mmNIC0_RXB_TS_RC_MAC_47_32_3                                 0xCE82DC
+
+#define mmNIC0_RXB_TS_RAW0_MAC_31_0_0                                0xCE82E0
+
+#define mmNIC0_RXB_TS_RAW0_MAC_31_0_1                                0xCE82E4
+
+#define mmNIC0_RXB_TS_RAW0_MAC_31_0_2                                0xCE82E8
+
+#define mmNIC0_RXB_TS_RAW0_MAC_31_0_3                                0xCE82EC
+
+#define mmNIC0_RXB_TS_RAW0_MAC_47_32_0                               0xCE82F0
+
+#define mmNIC0_RXB_TS_RAW0_MAC_47_32_1                               0xCE82F4
+
+#define mmNIC0_RXB_TS_RAW0_MAC_47_32_2                               0xCE82F8
+
+#define mmNIC0_RXB_TS_RAW0_MAC_47_32_3                               0xCE82FC
+
+#define mmNIC0_RXB_TS_RAW1_MAC_31_0_0                                0xCE8300
+
+#define mmNIC0_RXB_TS_RAW1_MAC_31_0_1                                0xCE8304
+
+#define mmNIC0_RXB_TS_RAW1_MAC_31_0_2                                0xCE8308
+
+#define mmNIC0_RXB_TS_RAW1_MAC_31_0_3                                0xCE830C
+
+#define mmNIC0_RXB_TS_RAW1_MAC_47_32_0                               0xCE8310
+
+#define mmNIC0_RXB_TS_RAW1_MAC_47_32_1                               0xCE8314
+
+#define mmNIC0_RXB_TS_RAW1_MAC_47_32_2                               0xCE8318
+
+#define mmNIC0_RXB_TS_RAW1_MAC_47_32_3                               0xCE831C
+
+#define mmNIC0_RXB_TS_RC_MAC_31_0_MASK_0                             0xCE8320
+
+#define mmNIC0_RXB_TS_RC_MAC_31_0_MASK_1                             0xCE8324
+
+#define mmNIC0_RXB_TS_RC_MAC_31_0_MASK_2                             0xCE8328
+
+#define mmNIC0_RXB_TS_RC_MAC_31_0_MASK_3                             0xCE832C
+
+#define mmNIC0_RXB_TS_RC_MAC_47_32_MASK_0                            0xCE8330
+
+#define mmNIC0_RXB_TS_RC_MAC_47_32_MASK_1                            0xCE8334
+
+#define mmNIC0_RXB_TS_RC_MAC_47_32_MASK_2                            0xCE8338
+
+#define mmNIC0_RXB_TS_RC_MAC_47_32_MASK_3                            0xCE833C
+
+#define mmNIC0_RXB_TS_RAW0_MAC_31_0_MASK_0                           0xCE8340
+
+#define mmNIC0_RXB_TS_RAW0_MAC_31_0_MASK_1                           0xCE8344
+
+#define mmNIC0_RXB_TS_RAW0_MAC_31_0_MASK_2                           0xCE8348
+
+#define mmNIC0_RXB_TS_RAW0_MAC_31_0_MASK_3                           0xCE834C
+
+#define mmNIC0_RXB_TS_RAW0_MAC_47_32_MASK_0                          0xCE8350
+
+#define mmNIC0_RXB_TS_RAW0_MAC_47_32_MASK_1                          0xCE8354
+
+#define mmNIC0_RXB_TS_RAW0_MAC_47_32_MASK_2                          0xCE8358
+
+#define mmNIC0_RXB_TS_RAW0_MAC_47_32_MASK_3                          0xCE835C
+
+#define mmNIC0_RXB_TS_RAW1_MAC_31_0_MASK_0                           0xCE8360
+
+#define mmNIC0_RXB_TS_RAW1_MAC_31_0_MASK_1                           0xCE8364
+
+#define mmNIC0_RXB_TS_RAW1_MAC_31_0_MASK_2                           0xCE8368
+
+#define mmNIC0_RXB_TS_RAW1_MAC_31_0_MASK_3                           0xCE836C
+
+#define mmNIC0_RXB_TS_RAW1_MAC_47_32_MASK_0                          0xCE8370
+
+#define mmNIC0_RXB_TS_RAW1_MAC_47_32_MASK_1                          0xCE8374
+
+#define mmNIC0_RXB_TS_RAW1_MAC_47_32_MASK_2                          0xCE8378
+
+#define mmNIC0_RXB_TS_RAW1_MAC_47_32_MASK_3                          0xCE837C
+
+#define mmNIC0_RXB_DBG_SPMU_SELECT                                   0xCE8400
+
+#define mmNIC0_RXB_DBG_FREE_LIST                                     0xCE8404
+
+#define mmNIC0_RXB_DBG_ERROR                                         0xCE8408
+
+#define mmNIC0_RXB_DBG_SEI_INTR                                      0xCE840C
+
+#define mmNIC0_RXB_DBG_ENDIANNESS                                    0xCE8410
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_0                                0xCE8480
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_1                                0xCE8484
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_2                                0xCE8488
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_3                                0xCE848C
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_4                                0xCE8490
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_5                                0xCE8494
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_6                                0xCE8498
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_7                                0xCE849C
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_8                                0xCE84A0
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_9                                0xCE84A4
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_10                               0xCE84A8
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_11                               0xCE84AC
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_12                               0xCE84B0
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_13                               0xCE84B4
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_14                               0xCE84B8
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_15                               0xCE84BC
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_16                               0xCE84C0
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_17                               0xCE84C4
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_18                               0xCE84C8
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_19                               0xCE84CC
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_20                               0xCE84D0
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_21                               0xCE84D4
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_22                               0xCE84D8
+
+#define mmNIC0_RXB_DBG_LAST_PARSING_23                               0xCE84DC
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_0                                   0xCE8500
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_1                                   0xCE8504
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_2                                   0xCE8508
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_3                                   0xCE850C
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_4                                   0xCE8510
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_5                                   0xCE8514
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_6                                   0xCE8518
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_7                                   0xCE851C
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_8                                   0xCE8520
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_9                                   0xCE8524
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_10                                  0xCE8528
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_11                                  0xCE852C
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_12                                  0xCE8530
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_13                                  0xCE8534
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_14                                  0xCE8538
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_15                                  0xCE853C
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_16                                  0xCE8540
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_17                                  0xCE8544
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_18                                  0xCE8548
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_19                                  0xCE854C
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_20                                  0xCE8550
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_21                                  0xCE8554
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_22                                  0xCE8558
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_23                                  0xCE855C
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_24                                  0xCE8560
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_25                                  0xCE8564
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_26                                  0xCE8568
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_27                                  0xCE856C
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_28                                  0xCE8570
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_29                                  0xCE8574
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_30                                  0xCE8578
+
+#define mmNIC0_RXB_DBG_LAST_CTRL_31                                  0xCE857C
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_0                                0xCE8580
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_1                                0xCE8584
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_2                                0xCE8588
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_3                                0xCE858C
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_4                                0xCE8590
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_5                                0xCE8594
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_6                                0xCE8598
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_7                                0xCE859C
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_8                                0xCE85A0
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_9                                0xCE85A4
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_10                               0xCE85A8
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_11                               0xCE85AC
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_12                               0xCE85B0
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_13                               0xCE85B4
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_14                               0xCE85B8
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_15                               0xCE85BC
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_16                               0xCE85C0
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_17                               0xCE85C4
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_18                               0xCE85C8
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_19                               0xCE85CC
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_20                               0xCE85D0
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_21                               0xCE85D4
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_22                               0xCE85D8
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_23                               0xCE85DC
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_24                               0xCE85E0
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_25                               0xCE85E4
+
+#define mmNIC0_RXB_DBG_LAST_SCATTER_26                               0xCE85E8
+
+#define mmNIC0_RXB_DBG_LAST_DONE                                     0xCE8600
+
+#endif /* ASIC_REG_NIC0_RXB_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
new file mode 100644
index 000000000000..efc4f7284bde
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
@@ -0,0 +1,354 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_RXE0_MASKS_H_
+#define ASIC_REG_NIC0_RXE0_MASKS_H_
+
+/*
+ *****************************************
+ *   NIC0_RXE0 (Prototype: NIC_RXE)
+ *****************************************
+ */
+
+/* NIC0_RXE0_CONTROL */
+#define NIC0_RXE0_CONTROL_SCATTER_BARRIER_SHIFT                      0
+#define NIC0_RXE0_CONTROL_SCATTER_BARRIER_MASK                       0x1
+#define NIC0_RXE0_CONTROL_IGNORE_RNR_NAK_SHIFT                       1
+#define NIC0_RXE0_CONTROL_IGNORE_RNR_NAK_MASK                        0x2
+#define NIC0_RXE0_CONTROL_SPARE0_SHIFT                               2
+#define NIC0_RXE0_CONTROL_SPARE0_MASK                                0xFFFC
+#define NIC0_RXE0_CONTROL_SPARE1_SHIFT                               16
+#define NIC0_RXE0_CONTROL_SPARE1_MASK                                0xFFFF0000
+
+/* NIC0_RXE0_LBW_BASE_LO */
+#define NIC0_RXE0_LBW_BASE_LO_LBW_BASE_ADDR_LO_SHIFT                 0
+#define NIC0_RXE0_LBW_BASE_LO_LBW_BASE_ADDR_LO_MASK                  0xFFFFFFFF
+
+/* NIC0_RXE0_LBW_BASE_HI */
+#define NIC0_RXE0_LBW_BASE_HI_LBW_BASE_ADDR_HI_SHIFT                 0
+#define NIC0_RXE0_LBW_BASE_HI_LBW_BASE_ADDR_HI_MASK                  0x3FFFF
+#define NIC0_RXE0_LBW_BASE_HI_LBW_LOG_SIZE_SHIFT                     24
+#define NIC0_RXE0_LBW_BASE_HI_LBW_LOG_SIZE_MASK                      0x3F000000
+
+/* NIC0_RXE0_PKT_DROP */
+#define NIC0_RXE0_PKT_DROP_ERR_QP_INVALID_SHIFT                      0
+#define NIC0_RXE0_PKT_DROP_ERR_QP_INVALID_MASK                       0x1
+#define NIC0_RXE0_PKT_DROP_ERR_TS_MISMATCH_SHIFT                     1
+#define NIC0_RXE0_PKT_DROP_ERR_TS_MISMATCH_MASK                      0x2
+#define NIC0_RXE0_PKT_DROP_ERR_CS_INVALID_SHIFT                      2
+#define NIC0_RXE0_PKT_DROP_ERR_CS_INVALID_MASK                       0x4
+#define NIC0_RXE0_PKT_DROP_ERR_REQ_PSN_INVALID_SHIFT                 3
+#define NIC0_RXE0_PKT_DROP_ERR_REQ_PSN_INVALID_MASK                  0x8
+#define NIC0_RXE0_PKT_DROP_ERR_RES_RKEY_INVALID_SHIFT                4
+#define NIC0_RXE0_PKT_DROP_ERR_RES_RKEY_INVALID_MASK                 0x10
+#define NIC0_RXE0_PKT_DROP_ERR_RES_RESYNC_INVALID_SHIFT              5
+#define NIC0_RXE0_PKT_DROP_ERR_RES_RESYNC_INVALID_MASK               0x20
+#define NIC0_RXE0_PKT_DROP_ERR_INV_OPCODE_SHIFT                      6
+#define NIC0_RXE0_PKT_DROP_ERR_INV_OPCODE_MASK                       0x40
+#define NIC0_RXE0_PKT_DROP_ERR_INV_SYNDROME_SHIFT                    7
+#define NIC0_RXE0_PKT_DROP_ERR_INV_SYNDROME_MASK                     0x80
+#define NIC0_RXE0_PKT_DROP_ERR_INV_RAW_SIZE_SHIFT                    8
+#define NIC0_RXE0_PKT_DROP_ERR_INV_RAW_SIZE_MASK                     0x100
+
+/* NIC0_RXE0_RAW_QPN_P0 */
+#define NIC0_RXE0_RAW_QPN_P0_RAW_QPN_P0_SHIFT                        0
+#define NIC0_RXE0_RAW_QPN_P0_RAW_QPN_P0_MASK                         0xFFFFFF
+
+/* NIC0_RXE0_RAW_BASE_LO_P0 */
+#define NIC0_RXE0_RAW_BASE_LO_P0_RAW_BASE_ADDR_LO_P0_SHIFT           0
+#define NIC0_RXE0_RAW_BASE_LO_P0_RAW_BASE_ADDR_LO_P0_MASK            0xFFFFFFFF
+
+/* NIC0_RXE0_RAW_BASE_HI_P0 */
+#define NIC0_RXE0_RAW_BASE_HI_P0_RAW_BASE_ADDR_HI_P0_SHIFT           0
+#define NIC0_RXE0_RAW_BASE_HI_P0_RAW_BASE_ADDR_HI_P0_MASK            0x3FFFF
+#define NIC0_RXE0_RAW_BASE_HI_P0_LOG_RAW_ENTRY_SIZE_P0_SHIFT         18
+#define NIC0_RXE0_RAW_BASE_HI_P0_LOG_RAW_ENTRY_SIZE_P0_MASK          0x3C0000
+#define NIC0_RXE0_RAW_BASE_HI_P0_RAW_REDUC_OP_P0_SHIFT               23
+#define NIC0_RXE0_RAW_BASE_HI_P0_RAW_REDUC_OP_P0_MASK                0xFF800000
+
+/* NIC0_RXE0_RAW_QPN_P1 */
+#define NIC0_RXE0_RAW_QPN_P1_RAW_QPN_P1_SHIFT                        0
+#define NIC0_RXE0_RAW_QPN_P1_RAW_QPN_P1_MASK                         0xFFFFFF
+
+/* NIC0_RXE0_RAW_BASE_LO_P1 */
+#define NIC0_RXE0_RAW_BASE_LO_P1_RAW_BASE_ADDR_LO_P1_SHIFT           0
+#define NIC0_RXE0_RAW_BASE_LO_P1_RAW_BASE_ADDR_LO_P1_MASK            0xFFFFFFFF
+
+/* NIC0_RXE0_RAW_BASE_HI_P1 */
+#define NIC0_RXE0_RAW_BASE_HI_P1_RAW_BASE_ADDR_HI_P1_SHIFT           0
+#define NIC0_RXE0_RAW_BASE_HI_P1_RAW_BASE_ADDR_HI_P1_MASK            0x3FFFF
+#define NIC0_RXE0_RAW_BASE_HI_P1_LOG_RAW_ENTRY_SIZE_P1_SHIFT         18
+#define NIC0_RXE0_RAW_BASE_HI_P1_LOG_RAW_ENTRY_SIZE_P1_MASK          0x3C0000
+#define NIC0_RXE0_RAW_BASE_HI_P1_RAW_REDUC_OP_P1_SHIFT               23
+#define NIC0_RXE0_RAW_BASE_HI_P1_RAW_REDUC_OP_P1_MASK                0xFF800000
+
+/* NIC0_RXE0_RAW_QPN_P2 */
+#define NIC0_RXE0_RAW_QPN_P2_RAW_QPN_P2_SHIFT                        0
+#define NIC0_RXE0_RAW_QPN_P2_RAW_QPN_P2_MASK                         0xFFFFFF
+
+/* NIC0_RXE0_RAW_BASE_LO_P2 */
+#define NIC0_RXE0_RAW_BASE_LO_P2_RAW_BASE_ADDR_LO_P2_SHIFT           0
+#define NIC0_RXE0_RAW_BASE_LO_P2_RAW_BASE_ADDR_LO_P2_MASK            0xFFFFFFFF
+
+/* NIC0_RXE0_RAW_BASE_HI_P2 */
+#define NIC0_RXE0_RAW_BASE_HI_P2_RAW_BASE_ADDR_HI_P2_SHIFT           0
+#define NIC0_RXE0_RAW_BASE_HI_P2_RAW_BASE_ADDR_HI_P2_MASK            0x3FFFF
+#define NIC0_RXE0_RAW_BASE_HI_P2_LOG_RAW_ENTRY_SIZE_P2_SHIFT         18
+#define NIC0_RXE0_RAW_BASE_HI_P2_LOG_RAW_ENTRY_SIZE_P2_MASK          0x3C0000
+#define NIC0_RXE0_RAW_BASE_HI_P2_RAW_REDUC_OP_P2_SHIFT               23
+#define NIC0_RXE0_RAW_BASE_HI_P2_RAW_REDUC_OP_P2_MASK                0xFF800000
+
+/* NIC0_RXE0_RAW_QPN_P3 */
+#define NIC0_RXE0_RAW_QPN_P3_RAW_QPN_P3_SHIFT                        0
+#define NIC0_RXE0_RAW_QPN_P3_RAW_QPN_P3_MASK                         0xFFFFFF
+
+/* NIC0_RXE0_RAW_BASE_LO_P3 */
+#define NIC0_RXE0_RAW_BASE_LO_P3_RAW_BASE_ADDR_LO_P3_SHIFT           0
+#define NIC0_RXE0_RAW_BASE_LO_P3_RAW_BASE_ADDR_LO_P3_MASK            0xFFFFFFFF
+
+/* NIC0_RXE0_RAW_BASE_HI_P3 */
+#define NIC0_RXE0_RAW_BASE_HI_P3_RAW_BASE_ADDR_HI_P3_SHIFT           0
+#define NIC0_RXE0_RAW_BASE_HI_P3_RAW_BASE_ADDR_HI_P3_MASK            0x3FFFF
+#define NIC0_RXE0_RAW_BASE_HI_P3_LOG_RAW_ENTRY_SIZE_P3_SHIFT         18
+#define NIC0_RXE0_RAW_BASE_HI_P3_LOG_RAW_ENTRY_SIZE_P3_MASK          0x3C0000
+#define NIC0_RXE0_RAW_BASE_HI_P3_RAW_REDUC_OP_P3_SHIFT               23
+#define NIC0_RXE0_RAW_BASE_HI_P3_RAW_REDUC_OP_P3_MASK                0xFF800000
+
+/* NIC0_RXE0_DBG_INV_OP_0 */
+#define NIC0_RXE0_DBG_INV_OP_0_DBG_INV_OP_PSN_SHIFT                  0
+#define NIC0_RXE0_DBG_INV_OP_0_DBG_INV_OP_PSN_MASK                   0xFFFFFF
+#define NIC0_RXE0_DBG_INV_OP_0_DBG_INV_OP_LATCHED_SHIFT              31
+#define NIC0_RXE0_DBG_INV_OP_0_DBG_INV_OP_LATCHED_MASK               0x80000000
+
+/* NIC0_RXE0_DBG_INV_OP_1 */
+#define NIC0_RXE0_DBG_INV_OP_1_DBG_INV_OP_QPN_SHIFT                  0
+#define NIC0_RXE0_DBG_INV_OP_1_DBG_INV_OP_QPN_MASK                   0xFFFFFF
+#define NIC0_RXE0_DBG_INV_OP_1_DBG_INV_OP_OPCODE_SHIFT               24
+#define NIC0_RXE0_DBG_INV_OP_1_DBG_INV_OP_OPCODE_MASK                0xFF000000
+
+/* NIC0_RXE0_DBG_AXI_ERR */
+#define NIC0_RXE0_DBG_AXI_ERR_DBG_RRESP_ERR_LATCHED_SHIFT            0
+#define NIC0_RXE0_DBG_AXI_ERR_DBG_RRESP_ERR_LATCHED_MASK             0xFFFF
+#define NIC0_RXE0_DBG_AXI_ERR_DBG_BRESP_ERR_LATCHED_SHIFT            16
+#define NIC0_RXE0_DBG_AXI_ERR_DBG_BRESP_ERR_LATCHED_MASK             0xFFFF0000
+
+/* NIC0_RXE0_ARUSER_HBW_10_0 */
+#define NIC0_RXE0_ARUSER_HBW_10_0_ARUSER_HBW_10_0_SHIFT              0
+#define NIC0_RXE0_ARUSER_HBW_10_0_ARUSER_HBW_10_0_MASK               0x7FF
+
+/* NIC0_RXE0_ARUSER_HBW_31_11 */
+#define NIC0_RXE0_ARUSER_HBW_31_11_ARUSER_HBW_31_11_SHIFT            11
+#define NIC0_RXE0_ARUSER_HBW_31_11_ARUSER_HBW_31_11_MASK             0xFFFFF800
+
+/* NIC0_RXE0_AWUSER_LBW_10_0 */
+#define NIC0_RXE0_AWUSER_LBW_10_0_AWUSER_LBW_10_0_SHIFT              0
+#define NIC0_RXE0_AWUSER_LBW_10_0_AWUSER_LBW_10_0_MASK               0x7FF
+
+/* NIC0_RXE0_AWUSER_LBW_31_11 */
+#define NIC0_RXE0_AWUSER_LBW_31_11_AWUSER_LBW_31_11_SHIFT            11
+#define NIC0_RXE0_AWUSER_LBW_31_11_AWUSER_LBW_31_11_MASK             0xFFFFF800
+
+/* NIC0_RXE0_ARPROT_HBW */
+#define NIC0_RXE0_ARPROT_HBW_ARPROT_HBW_UNSECURED_SHIFT              0
+#define NIC0_RXE0_ARPROT_HBW_ARPROT_HBW_UNSECURED_MASK               0x7
+#define NIC0_RXE0_ARPROT_HBW_ARPROT_HBW_SECURED_SHIFT                4
+#define NIC0_RXE0_ARPROT_HBW_ARPROT_HBW_SECURED_MASK                 0x70
+#define NIC0_RXE0_ARPROT_HBW_ARPROT_HBW_PRIVILEGED_SHIFT             8
+#define NIC0_RXE0_ARPROT_HBW_ARPROT_HBW_PRIVILEGED_MASK              0x700
+
+/* NIC0_RXE0_AWPROT_LBW */
+#define NIC0_RXE0_AWPROT_LBW_AWPROT_LBW_UNSECURED_SHIFT              0
+#define NIC0_RXE0_AWPROT_LBW_AWPROT_LBW_UNSECURED_MASK               0x7
+#define NIC0_RXE0_AWPROT_LBW_AWPROT_LBW_SECURED_SHIFT                4
+#define NIC0_RXE0_AWPROT_LBW_AWPROT_LBW_SECURED_MASK                 0x70
+#define NIC0_RXE0_AWPROT_LBW_AWPROT_LBW_PRIVILEGED_SHIFT             8
+#define NIC0_RXE0_AWPROT_LBW_AWPROT_LBW_PRIVILEGED_MASK              0x700
+
+/* NIC0_RXE0_WIN0_WQ_BASE_LO */
+#define NIC0_RXE0_WIN0_WQ_BASE_LO_WQ_BASE_ADDR_LO_SHIFT              0
+#define NIC0_RXE0_WIN0_WQ_BASE_LO_WQ_BASE_ADDR_LO_MASK               0xFFFFFFFF
+
+/* NIC0_RXE0_WIN0_WQ_BASE_HI */
+#define NIC0_RXE0_WIN0_WQ_BASE_HI_WQ_BASE_ADDR_HI_SHIFT              0
+#define NIC0_RXE0_WIN0_WQ_BASE_HI_WQ_BASE_ADDR_HI_MASK               0x3FFFF
+#define NIC0_RXE0_WIN0_WQ_BASE_HI_LOG_MAX_WQ_SIZE_SHIFT              24
+#define NIC0_RXE0_WIN0_WQ_BASE_HI_LOG_MAX_WQ_SIZE_MASK               0x1F000000
+
+/* NIC0_RXE0_WIN1_WQ_BASE_LO */
+#define NIC0_RXE0_WIN1_WQ_BASE_LO_WQ_BASE_ADDR_LO_SHIFT              0
+#define NIC0_RXE0_WIN1_WQ_BASE_LO_WQ_BASE_ADDR_LO_MASK               0xFFFFFFFF
+
+/* NIC0_RXE0_WIN1_WQ_BASE_HI */
+#define NIC0_RXE0_WIN1_WQ_BASE_HI_WQ_BASE_ADDR_HI_SHIFT              0
+#define NIC0_RXE0_WIN1_WQ_BASE_HI_WQ_BASE_ADDR_HI_MASK               0x3FFFF
+#define NIC0_RXE0_WIN1_WQ_BASE_HI_LOG_MAX_WQ_SIZE_SHIFT              24
+#define NIC0_RXE0_WIN1_WQ_BASE_HI_LOG_MAX_WQ_SIZE_MASK               0x1F000000
+
+/* NIC0_RXE0_WIN2_WQ_BASE_LO */
+#define NIC0_RXE0_WIN2_WQ_BASE_LO_WQ_BASE_ADDR_LO_SHIFT              0
+#define NIC0_RXE0_WIN2_WQ_BASE_LO_WQ_BASE_ADDR_LO_MASK               0xFFFFFFFF
+
+/* NIC0_RXE0_WIN2_WQ_BASE_HI */
+#define NIC0_RXE0_WIN2_WQ_BASE_HI_WQ_BASE_ADDR_HI_SHIFT              0
+#define NIC0_RXE0_WIN2_WQ_BASE_HI_WQ_BASE_ADDR_HI_MASK               0x3FFFF
+#define NIC0_RXE0_WIN2_WQ_BASE_HI_LOG_MAX_WQ_SIZE_SHIFT              24
+#define NIC0_RXE0_WIN2_WQ_BASE_HI_LOG_MAX_WQ_SIZE_MASK               0x1F000000
+
+/* NIC0_RXE0_WIN3_WQ_BASE_LO */
+#define NIC0_RXE0_WIN3_WQ_BASE_LO_WQ_BASE_ADDR_LO_SHIFT              0
+#define NIC0_RXE0_WIN3_WQ_BASE_LO_WQ_BASE_ADDR_LO_MASK               0xFFFFFFFF
+
+/* NIC0_RXE0_WIN3_WQ_BASE_HI */
+#define NIC0_RXE0_WIN3_WQ_BASE_HI_WQ_BASE_ADDR_HI_SHIFT              0
+#define NIC0_RXE0_WIN3_WQ_BASE_HI_WQ_BASE_ADDR_HI_MASK               0x3FFFF
+#define NIC0_RXE0_WIN3_WQ_BASE_HI_LOG_MAX_WQ_SIZE_SHIFT              24
+#define NIC0_RXE0_WIN3_WQ_BASE_HI_LOG_MAX_WQ_SIZE_MASK               0x1F000000
+
+/* NIC0_RXE0_WQ_BASE_WINDOW_SEL */
+#define NIC0_RXE0_WQ_BASE_WINDOW_SEL_WQ_BASE_WINDOW_SEL_SHIFT        0
+#define NIC0_RXE0_WQ_BASE_WINDOW_SEL_WQ_BASE_WINDOW_SEL_MASK         0x1F
+
+/* NIC0_RXE0_SEI_CAUSE */
+#define NIC0_RXE0_SEI_CAUSE_STTS_HBW_RRESP_ERR_SHIFT                 0
+#define NIC0_RXE0_SEI_CAUSE_STTS_HBW_RRESP_ERR_MASK                  0x1
+#define NIC0_RXE0_SEI_CAUSE_STTS_LBW_BRESP_ERR_SHIFT                 1
+#define NIC0_RXE0_SEI_CAUSE_STTS_LBW_BRESP_ERR_MASK                  0x2
+#define NIC0_RXE0_SEI_CAUSE_STTS_HBW_BRESP_ERR_SHIFT                 2
+#define NIC0_RXE0_SEI_CAUSE_STTS_HBW_BRESP_ERR_MASK                  0x4
+
+/* NIC0_RXE0_SEI_MASK */
+#define NIC0_RXE0_SEI_MASK_MASK_HBW_RRESP_ERR_SHIFT                  0
+#define NIC0_RXE0_SEI_MASK_MASK_HBW_RRESP_ERR_MASK                   0x1
+#define NIC0_RXE0_SEI_MASK_MASK_LBW_BRESP_ERR_SHIFT                  1
+#define NIC0_RXE0_SEI_MASK_MASK_LBW_BRESP_ERR_MASK                   0x2
+#define NIC0_RXE0_SEI_MASK_MASK_HBW_BRESP_ERR_SHIFT                  2
+#define NIC0_RXE0_SEI_MASK_MASK_HBW_BRESP_ERR_MASK                   0x4
+
+/* NIC0_RXE0_SPI_CAUSE */
+#define NIC0_RXE0_SPI_CAUSE_STTS_INV_RAW_SIZE_SHIFT                  1
+#define NIC0_RXE0_SPI_CAUSE_STTS_INV_RAW_SIZE_MASK                   0x2
+#define NIC0_RXE0_SPI_CAUSE_STTS_INV_OPCODE_SHIFT                    2
+#define NIC0_RXE0_SPI_CAUSE_STTS_INV_OPCODE_MASK                     0x4
+#define NIC0_RXE0_SPI_CAUSE_STTS_INV_SYNDROME_SHIFT                  3
+#define NIC0_RXE0_SPI_CAUSE_STTS_INV_SYNDROME_MASK                   0x8
+#define NIC0_RXE0_SPI_CAUSE_STTS_BAD_FORMAT_SHIFT                    4
+#define NIC0_RXE0_SPI_CAUSE_STTS_BAD_FORMAT_MASK                     0x10
+#define NIC0_RXE0_SPI_CAUSE_STTS_QP_INVALID_SHIFT                    5
+#define NIC0_RXE0_SPI_CAUSE_STTS_QP_INVALID_MASK                     0x20
+#define NIC0_RXE0_SPI_CAUSE_STTS_TS_MISMATCH_SHIFT                   6
+#define NIC0_RXE0_SPI_CAUSE_STTS_TS_MISMATCH_MASK                    0x40
+#define NIC0_RXE0_SPI_CAUSE_STTS_CS_INVALID_SHIFT                    7
+#define NIC0_RXE0_SPI_CAUSE_STTS_CS_INVALID_MASK                     0x80
+#define NIC0_RXE0_SPI_CAUSE_STTS_REQ_PSN_INVALID_SHIFT               8
+#define NIC0_RXE0_SPI_CAUSE_STTS_REQ_PSN_INVALID_MASK                0x100
+#define NIC0_RXE0_SPI_CAUSE_STTS_RES_RKEY_INVALID_SHIFT              9
+#define NIC0_RXE0_SPI_CAUSE_STTS_RES_RKEY_INVALID_MASK               0x200
+#define NIC0_RXE0_SPI_CAUSE_STTS_RES_RESYNC_INVALID_SHIFT            10
+#define NIC0_RXE0_SPI_CAUSE_STTS_RES_RESYNC_INVALID_MASK             0x400
+
+/* NIC0_RXE0_SPI_MASK */
+#define NIC0_RXE0_SPI_MASK_MASK_INV_RAW_SIZE_SHIFT                   1
+#define NIC0_RXE0_SPI_MASK_MASK_INV_RAW_SIZE_MASK                    0x2
+#define NIC0_RXE0_SPI_MASK_MASK_INV_OPCODE_SHIFT                     2
+#define NIC0_RXE0_SPI_MASK_MASK_INV_OPCODE_MASK                      0x4
+#define NIC0_RXE0_SPI_MASK_MASK_INV_SYNDROME_SHIFT                   3
+#define NIC0_RXE0_SPI_MASK_MASK_INV_SYNDROME_MASK                    0x8
+#define NIC0_RXE0_SPI_MASK_MASK_BAD_FORMAT_SHIFT                     4
+#define NIC0_RXE0_SPI_MASK_MASK_BAD_FORMAT_MASK                      0x10
+#define NIC0_RXE0_SPI_MASK_MASK_QP_INVALID_SHIFT                     5
+#define NIC0_RXE0_SPI_MASK_MASK_QP_INVALID_MASK                      0x20
+#define NIC0_RXE0_SPI_MASK_MASK_TS_MISMATCH_SHIFT                    6
+#define NIC0_RXE0_SPI_MASK_MASK_TS_MISMATCH_MASK                     0x40
+#define NIC0_RXE0_SPI_MASK_MASK_CS_INVALID_SHIFT                     7
+#define NIC0_RXE0_SPI_MASK_MASK_CS_INVALID_MASK                      0x80
+#define NIC0_RXE0_SPI_MASK_MASK_REQ_PSN_INVALID_SHIFT                8
+#define NIC0_RXE0_SPI_MASK_MASK_REQ_PSN_INVALID_MASK                 0x100
+#define NIC0_RXE0_SPI_MASK_MASK_RES_RKEY_INVALID_SHIFT               9
+#define NIC0_RXE0_SPI_MASK_MASK_RES_RKEY_INVALID_MASK                0x200
+#define NIC0_RXE0_SPI_MASK_MASK_RES_RESYNC_INVALID_SHIFT             10
+#define NIC0_RXE0_SPI_MASK_MASK_RES_RESYNC_INVALID_MASK              0x400
+
+/* NIC0_RXE0_CQ_CFG0 */
+#define NIC0_RXE0_CQ_CFG0_ENABLE_SHIFT                               0
+#define NIC0_RXE0_CQ_CFG0_ENABLE_MASK                                0x1
+#define NIC0_RXE0_CQ_CFG0_INTERRUPT_MASK_SHIFT                       8
+#define NIC0_RXE0_CQ_CFG0_INTERRUPT_MASK_MASK                        0x100
+#define NIC0_RXE0_CQ_CFG0_CREDIT_SHIFT                               16
+#define NIC0_RXE0_CQ_CFG0_CREDIT_MASK                                0xF0000
+#define NIC0_RXE0_CQ_CFG0_CREDIT_FORCE_FULL_SHIFT                    21
+#define NIC0_RXE0_CQ_CFG0_CREDIT_FORCE_FULL_MASK                     0x200000
+#define NIC0_RXE0_CQ_CFG0_WRAPAROUND_EN_SHIFT                        22
+#define NIC0_RXE0_CQ_CFG0_WRAPAROUND_EN_MASK                         0x400000
+#define NIC0_RXE0_CQ_CFG0_SOB_CQ_MUTEX_SHIFT                         23
+#define NIC0_RXE0_CQ_CFG0_SOB_CQ_MUTEX_MASK                          0x800000
+#define NIC0_RXE0_CQ_CFG0_CQ_SELECT_SHIFT                            24
+#define NIC0_RXE0_CQ_CFG0_CQ_SELECT_MASK                             0x1F000000
+
+/* NIC0_RXE0_CQ_CFG1 */
+#define NIC0_RXE0_CQ_CFG1_INTERRUPT_EACH_UPDATE_SHIFT                0
+#define NIC0_RXE0_CQ_CFG1_INTERRUPT_EACH_UPDATE_MASK                 0x1
+
+/* NIC0_RXE0_CQ_BASE_ADDR_31_7 */
+#define NIC0_RXE0_CQ_BASE_ADDR_31_7_R_SHIFT                          7
+#define NIC0_RXE0_CQ_BASE_ADDR_31_7_R_MASK                           0xFFFFFF80
+
+/* NIC0_RXE0_CA_BASE_ADDR_49_32 */
+#define NIC0_RXE0_CA_BASE_ADDR_49_32_R_SHIFT                         0
+#define NIC0_RXE0_CA_BASE_ADDR_49_32_R_MASK                          0x3FFFF
+
+/* NIC0_RXE0_CQ_WRITE_INDEX */
+#define NIC0_RXE0_CQ_WRITE_INDEX_R_SHIFT                             0
+#define NIC0_RXE0_CQ_WRITE_INDEX_R_MASK                              0xFFFFFFFF
+
+/* NIC0_RXE0_CQ_PRODUCER_INDEX */
+#define NIC0_RXE0_CQ_PRODUCER_INDEX_R_SHIFT                          0
+#define NIC0_RXE0_CQ_PRODUCER_INDEX_R_MASK                           0xFFFFFFFF
+
+/* NIC0_RXE0_CQ_CONSUMER_INDEX */
+#define NIC0_RXE0_CQ_CONSUMER_INDEX_R_SHIFT                          0
+#define NIC0_RXE0_CQ_CONSUMER_INDEX_R_MASK                           0xFFFFFFFF
+
+/* NIC0_RXE0_CQ_MASK */
+#define NIC0_RXE0_CQ_MASK_R_SHIFT                                    0
+#define NIC0_RXE0_CQ_MASK_R_MASK                                     0xFFFFFFFF
+
+/* NIC0_RXE0_CQ_INTER_MODERATION_EN */
+#define NIC0_RXE0_CQ_INTER_MODERATION_EN_R_SHIFT                     0
+#define NIC0_RXE0_CQ_INTER_MODERATION_EN_R_MASK                      0x1
+
+/* NIC0_RXE0_CQ_INTER_MODERATION_CNT */
+#define NIC0_RXE0_CQ_INTER_MODERATION_CNT_R_SHIFT                    0
+#define NIC0_RXE0_CQ_INTER_MODERATION_CNT_R_MASK                     0xFF
+
+/* NIC0_RXE0_CQ_MSI_CAUSE_CLR */
+
+/* NIC0_RXE0_CQ_MSI_ADDR */
+#define NIC0_RXE0_CQ_MSI_ADDR_R_SHIFT                                0
+#define NIC0_RXE0_CQ_MSI_ADDR_R_MASK                                 0x3FFFFFF
+
+/* NIC0_RXE0_CQ_MSI_DATA */
+#define NIC0_RXE0_CQ_MSI_DATA_R_SHIFT                                0
+#define NIC0_RXE0_CQ_MSI_DATA_R_MASK                                 0xFFFFFFFF
+
+/* NIC0_RXE0_CQ_MSI_TRUSTED */
+#define NIC0_RXE0_CQ_MSI_TRUSTED_R_SHIFT                             0
+#define NIC0_RXE0_CQ_MSI_TRUSTED_R_MASK                              0x3
+
+/* NIC0_RXE0_MSI_CAUSE */
+#define NIC0_RXE0_MSI_CAUSE_R_SHIFT                                  0
+#define NIC0_RXE0_MSI_CAUSE_R_MASK                                   0x3
+
+/* NIC0_RXE0_MSI_CASUE_MASK */
+#define NIC0_RXE0_MSI_CASUE_MASK_R_SHIFT                             0
+#define NIC0_RXE0_MSI_CASUE_MASK_R_MASK                              0x3
+
+#endif /* ASIC_REG_NIC0_RXE0_MASKS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
new file mode 100644
index 000000000000..4ca2147a0790
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
@@ -0,0 +1,158 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_RXE0_REGS_H_
+#define ASIC_REG_NIC0_RXE0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_RXE0 (Prototype: NIC_RXE)
+ *****************************************
+ */
+
+#define mmNIC0_RXE0_CONTROL                                          0xCE9000
+
+#define mmNIC0_RXE0_LBW_BASE_LO                                      0xCE9004
+
+#define mmNIC0_RXE0_LBW_BASE_HI                                      0xCE9008
+
+#define mmNIC0_RXE0_PKT_DROP                                         0xCE900C
+
+#define mmNIC0_RXE0_RAW_QPN_P0_0                                     0xCE9010
+
+#define mmNIC0_RXE0_RAW_QPN_P0_1                                     0xCE9014
+
+#define mmNIC0_RXE0_RAW_BASE_LO_P0_0                                 0xCE9020
+
+#define mmNIC0_RXE0_RAW_BASE_LO_P0_1                                 0xCE9024
+
+#define mmNIC0_RXE0_RAW_BASE_HI_P0_0                                 0xCE9030
+
+#define mmNIC0_RXE0_RAW_BASE_HI_P0_1                                 0xCE9034
+
+#define mmNIC0_RXE0_RAW_QPN_P1_0                                     0xCE9040
+
+#define mmNIC0_RXE0_RAW_QPN_P1_1                                     0xCE9044
+
+#define mmNIC0_RXE0_RAW_BASE_LO_P1_0                                 0xCE9050
+
+#define mmNIC0_RXE0_RAW_BASE_LO_P1_1                                 0xCE9054
+
+#define mmNIC0_RXE0_RAW_BASE_HI_P1_0                                 0xCE9060
+
+#define mmNIC0_RXE0_RAW_BASE_HI_P1_1                                 0xCE9064
+
+#define mmNIC0_RXE0_RAW_QPN_P2_0                                     0xCE9070
+
+#define mmNIC0_RXE0_RAW_QPN_P2_1                                     0xCE9074
+
+#define mmNIC0_RXE0_RAW_BASE_LO_P2_0                                 0xCE9080
+
+#define mmNIC0_RXE0_RAW_BASE_LO_P2_1                                 0xCE9084
+
+#define mmNIC0_RXE0_RAW_BASE_HI_P2_0                                 0xCE9090
+
+#define mmNIC0_RXE0_RAW_BASE_HI_P2_1                                 0xCE9094
+
+#define mmNIC0_RXE0_RAW_QPN_P3_0                                     0xCE90A0
+
+#define mmNIC0_RXE0_RAW_QPN_P3_1                                     0xCE90A4
+
+#define mmNIC0_RXE0_RAW_BASE_LO_P3_0                                 0xCE90B0
+
+#define mmNIC0_RXE0_RAW_BASE_LO_P3_1                                 0xCE90B4
+
+#define mmNIC0_RXE0_RAW_BASE_HI_P3_0                                 0xCE90C0
+
+#define mmNIC0_RXE0_RAW_BASE_HI_P3_1                                 0xCE90C4
+
+#define mmNIC0_RXE0_DBG_INV_OP_0                                     0xCE90D0
+
+#define mmNIC0_RXE0_DBG_INV_OP_1                                     0xCE90D4
+
+#define mmNIC0_RXE0_DBG_AXI_ERR                                      0xCE90D8
+
+#define mmNIC0_RXE0_ARUSER_HBW_10_0                                  0xCE90E0
+
+#define mmNIC0_RXE0_ARUSER_HBW_31_11                                 0xCE90E4
+
+#define mmNIC0_RXE0_AWUSER_LBW_10_0                                  0xCE90E8
+
+#define mmNIC0_RXE0_AWUSER_LBW_31_11                                 0xCE90EC
+
+#define mmNIC0_RXE0_ARPROT_HBW                                       0xCE90F0
+
+#define mmNIC0_RXE0_AWPROT_LBW                                       0xCE90F4
+
+#define mmNIC0_RXE0_WIN0_WQ_BASE_LO                                  0xCE9100
+
+#define mmNIC0_RXE0_WIN0_WQ_BASE_HI                                  0xCE9104
+
+#define mmNIC0_RXE0_WIN1_WQ_BASE_LO                                  0xCE9108
+
+#define mmNIC0_RXE0_WIN1_WQ_BASE_HI                                  0xCE910C
+
+#define mmNIC0_RXE0_WIN2_WQ_BASE_LO                                  0xCE9110
+
+#define mmNIC0_RXE0_WIN2_WQ_BASE_HI                                  0xCE9114
+
+#define mmNIC0_RXE0_WIN3_WQ_BASE_LO                                  0xCE9118
+
+#define mmNIC0_RXE0_WIN3_WQ_BASE_HI                                  0xCE911C
+
+#define mmNIC0_RXE0_WQ_BASE_WINDOW_SEL                               0xCE9120
+
+#define mmNIC0_RXE0_SEI_CAUSE                                        0xCE9140
+
+#define mmNIC0_RXE0_SEI_MASK                                         0xCE9144
+
+#define mmNIC0_RXE0_SPI_CAUSE                                        0xCE9150
+
+#define mmNIC0_RXE0_SPI_MASK                                         0xCE9154
+
+#define mmNIC0_RXE0_CQ_CFG0                                          0xCE9158
+
+#define mmNIC0_RXE0_CQ_CFG1                                          0xCE915C
+
+#define mmNIC0_RXE0_CQ_BASE_ADDR_31_7                                0xCE9160
+
+#define mmNIC0_RXE0_CA_BASE_ADDR_49_32                               0xCE9180
+
+#define mmNIC0_RXE0_CQ_WRITE_INDEX                                   0xCE91A0
+
+#define mmNIC0_RXE0_CQ_PRODUCER_INDEX                                0xCE91C0
+
+#define mmNIC0_RXE0_CQ_CONSUMER_INDEX                                0xCE91E0
+
+#define mmNIC0_RXE0_CQ_MASK                                          0xCE9200
+
+#define mmNIC0_RXE0_CQ_INTER_MODERATION_EN                           0xCE9220
+
+#define mmNIC0_RXE0_CQ_INTER_MODERATION_CNT                          0xCE9240
+
+#define mmNIC0_RXE0_CQ_MSI_CAUSE_CLR                                 0xCE9260
+
+#define mmNIC0_RXE0_CQ_MSI_ADDR_0                                    0xCE9270
+
+#define mmNIC0_RXE0_CQ_MSI_ADDR_1                                    0xCE9274
+
+#define mmNIC0_RXE0_CQ_MSI_DATA_0                                    0xCE92B0
+
+#define mmNIC0_RXE0_CQ_MSI_DATA_1                                    0xCE92B4
+
+#define mmNIC0_RXE0_CQ_MSI_TRUSTED                                   0xCE92F0
+
+#define mmNIC0_RXE0_MSI_CAUSE                                        0xCE92F4
+
+#define mmNIC0_RXE0_MSI_CASUE_MASK                                   0xCE92F8
+
+#endif /* ASIC_REG_NIC0_RXE0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
new file mode 100644
index 000000000000..68cd1c4ef494
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
@@ -0,0 +1,158 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_RXE1_REGS_H_
+#define ASIC_REG_NIC0_RXE1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_RXE1 (Prototype: NIC_RXE)
+ *****************************************
+ */
+
+#define mmNIC0_RXE1_CONTROL                                          0xCEA000
+
+#define mmNIC0_RXE1_LBW_BASE_LO                                      0xCEA004
+
+#define mmNIC0_RXE1_LBW_BASE_HI                                      0xCEA008
+
+#define mmNIC0_RXE1_PKT_DROP                                         0xCEA00C
+
+#define mmNIC0_RXE1_RAW_QPN_P0_0                                     0xCEA010
+
+#define mmNIC0_RXE1_RAW_QPN_P0_1                                     0xCEA014
+
+#define mmNIC0_RXE1_RAW_BASE_LO_P0_0                                 0xCEA020
+
+#define mmNIC0_RXE1_RAW_BASE_LO_P0_1                                 0xCEA024
+
+#define mmNIC0_RXE1_RAW_BASE_HI_P0_0                                 0xCEA030
+
+#define mmNIC0_RXE1_RAW_BASE_HI_P0_1                                 0xCEA034
+
+#define mmNIC0_RXE1_RAW_QPN_P1_0                                     0xCEA040
+
+#define mmNIC0_RXE1_RAW_QPN_P1_1                                     0xCEA044
+
+#define mmNIC0_RXE1_RAW_BASE_LO_P1_0                                 0xCEA050
+
+#define mmNIC0_RXE1_RAW_BASE_LO_P1_1                                 0xCEA054
+
+#define mmNIC0_RXE1_RAW_BASE_HI_P1_0                                 0xCEA060
+
+#define mmNIC0_RXE1_RAW_BASE_HI_P1_1                                 0xCEA064
+
+#define mmNIC0_RXE1_RAW_QPN_P2_0                                     0xCEA070
+
+#define mmNIC0_RXE1_RAW_QPN_P2_1                                     0xCEA074
+
+#define mmNIC0_RXE1_RAW_BASE_LO_P2_0                                 0xCEA080
+
+#define mmNIC0_RXE1_RAW_BASE_LO_P2_1                                 0xCEA084
+
+#define mmNIC0_RXE1_RAW_BASE_HI_P2_0                                 0xCEA090
+
+#define mmNIC0_RXE1_RAW_BASE_HI_P2_1                                 0xCEA094
+
+#define mmNIC0_RXE1_RAW_QPN_P3_0                                     0xCEA0A0
+
+#define mmNIC0_RXE1_RAW_QPN_P3_1                                     0xCEA0A4
+
+#define mmNIC0_RXE1_RAW_BASE_LO_P3_0                                 0xCEA0B0
+
+#define mmNIC0_RXE1_RAW_BASE_LO_P3_1                                 0xCEA0B4
+
+#define mmNIC0_RXE1_RAW_BASE_HI_P3_0                                 0xCEA0C0
+
+#define mmNIC0_RXE1_RAW_BASE_HI_P3_1                                 0xCEA0C4
+
+#define mmNIC0_RXE1_DBG_INV_OP_0                                     0xCEA0D0
+
+#define mmNIC0_RXE1_DBG_INV_OP_1                                     0xCEA0D4
+
+#define mmNIC0_RXE1_DBG_AXI_ERR                                      0xCEA0D8
+
+#define mmNIC0_RXE1_ARUSER_HBW_10_0                                  0xCEA0E0
+
+#define mmNIC0_RXE1_ARUSER_HBW_31_11                                 0xCEA0E4
+
+#define mmNIC0_RXE1_AWUSER_LBW_10_0                                  0xCEA0E8
+
+#define mmNIC0_RXE1_AWUSER_LBW_31_11                                 0xCEA0EC
+
+#define mmNIC0_RXE1_ARPROT_HBW                                       0xCEA0F0
+
+#define mmNIC0_RXE1_AWPROT_LBW                                       0xCEA0F4
+
+#define mmNIC0_RXE1_WIN0_WQ_BASE_LO                                  0xCEA100
+
+#define mmNIC0_RXE1_WIN0_WQ_BASE_HI                                  0xCEA104
+
+#define mmNIC0_RXE1_WIN1_WQ_BASE_LO                                  0xCEA108
+
+#define mmNIC0_RXE1_WIN1_WQ_BASE_HI                                  0xCEA10C
+
+#define mmNIC0_RXE1_WIN2_WQ_BASE_LO                                  0xCEA110
+
+#define mmNIC0_RXE1_WIN2_WQ_BASE_HI                                  0xCEA114
+
+#define mmNIC0_RXE1_WIN3_WQ_BASE_LO                                  0xCEA118
+
+#define mmNIC0_RXE1_WIN3_WQ_BASE_HI                                  0xCEA11C
+
+#define mmNIC0_RXE1_WQ_BASE_WINDOW_SEL                               0xCEA120
+
+#define mmNIC0_RXE1_SEI_CAUSE                                        0xCEA140
+
+#define mmNIC0_RXE1_SEI_MASK                                         0xCEA144
+
+#define mmNIC0_RXE1_SPI_CAUSE                                        0xCEA150
+
+#define mmNIC0_RXE1_SPI_MASK                                         0xCEA154
+
+#define mmNIC0_RXE1_CQ_CFG0                                          0xCEA158
+
+#define mmNIC0_RXE1_CQ_CFG1                                          0xCEA15C
+
+#define mmNIC0_RXE1_CQ_BASE_ADDR_31_7                                0xCEA160
+
+#define mmNIC0_RXE1_CA_BASE_ADDR_49_32                               0xCEA180
+
+#define mmNIC0_RXE1_CQ_WRITE_INDEX                                   0xCEA1A0
+
+#define mmNIC0_RXE1_CQ_PRODUCER_INDEX                                0xCEA1C0
+
+#define mmNIC0_RXE1_CQ_CONSUMER_INDEX                                0xCEA1E0
+
+#define mmNIC0_RXE1_CQ_MASK                                          0xCEA200
+
+#define mmNIC0_RXE1_CQ_INTER_MODERATION_EN                           0xCEA220
+
+#define mmNIC0_RXE1_CQ_INTER_MODERATION_CNT                          0xCEA240
+
+#define mmNIC0_RXE1_CQ_MSI_CAUSE_CLR                                 0xCEA260
+
+#define mmNIC0_RXE1_CQ_MSI_ADDR_0                                    0xCEA270
+
+#define mmNIC0_RXE1_CQ_MSI_ADDR_1                                    0xCEA274
+
+#define mmNIC0_RXE1_CQ_MSI_DATA_0                                    0xCEA2B0
+
+#define mmNIC0_RXE1_CQ_MSI_DATA_1                                    0xCEA2B4
+
+#define mmNIC0_RXE1_CQ_MSI_TRUSTED                                   0xCEA2F0
+
+#define mmNIC0_RXE1_MSI_CAUSE                                        0xCEA2F4
+
+#define mmNIC0_RXE1_MSI_CASUE_MASK                                   0xCEA2F8
+
+#endif /* ASIC_REG_NIC0_RXE1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
new file mode 100644
index 000000000000..85f6eab4c12d
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
@@ -0,0 +1,518 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_STAT_REGS_H_
+#define ASIC_REG_NIC0_STAT_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_STAT (Prototype: NIC_STAT)
+ *****************************************
+ */
+
+#define mmNIC0_STAT_DATA_HI_REG                                      0xCC4000
+
+#define mmNIC0_STAT_STATN_STATUS                                     0xCC4004
+
+#define mmNIC0_STAT_STATN_CONFIG                                     0xCC4008
+
+#define mmNIC0_STAT_STATN_CONTROL                                    0xCC400C
+
+#define mmNIC0_STAT_ETHERSTATSOCTETS                                 0xCC4100
+
+#define mmNIC0_STAT_OCTETSRECEIVEDOK                                 0xCC4104
+
+#define mmNIC0_STAT_AALIGNMENTERRORS                                 0xCC4108
+
+#define mmNIC0_STAT_APAUSEMACCTRLFRAMESRECEIVED                      0xCC410C
+
+#define mmNIC0_STAT_AFRAMETOOLONGERRORS                              0xCC4110
+
+#define mmNIC0_STAT_AINRANGELENGTHERRORS                             0xCC4114
+
+#define mmNIC0_STAT_AFRAMESRECEIVEDOK                                0xCC4118
+
+#define mmNIC0_STAT_VLANRECEIVEDOK                                   0xCC411C
+
+#define mmNIC0_STAT_AFRAMECHECKSEQUENCEERRORS                        0xCC4120
+
+#define mmNIC0_STAT_IFINERRORS                                       0xCC4124
+
+#define mmNIC0_STAT_IFINUCASTPKTS                                    0xCC4128
+
+#define mmNIC0_STAT_IFINMULTICASTPKTS                                0xCC412C
+
+#define mmNIC0_STAT_IFINBROADCASTPKTS                                0xCC4130
+
+#define mmNIC0_STAT_ETHERSTATSDROPEVENTS                             0xCC4134
+
+#define mmNIC0_STAT_ETHERSTATSUNDERSIZEPKTS                          0xCC4138
+
+#define mmNIC0_STAT_ETHERSTATSPKTS                                   0xCC413C
+
+#define mmNIC0_STAT_ETHERSTATSPKTS64OCTETS                           0xCC4140
+
+#define mmNIC0_STAT_ETHERSTATSPKTS65TO127OCTETS                      0xCC4144
+
+#define mmNIC0_STAT_ETHERSTATSPKTS128TO255OCTETS                     0xCC4148
+
+#define mmNIC0_STAT_ETHERSTATSPKTS256TO511OCTETS                     0xCC414C
+
+#define mmNIC0_STAT_ETHERSTATSPKTS512TO1023OCTETS                    0xCC4150
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1024TO1518OCTETS                   0xCC4154
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1519TOMAXOCTETS                    0xCC4158
+
+#define mmNIC0_STAT_ETHERSTATSOVERSIZEPKTS                           0xCC415C
+
+#define mmNIC0_STAT_ETHERSTATSJABBERS                                0xCC4160
+
+#define mmNIC0_STAT_ETHERSTATSFRAGMENTS                              0xCC4164
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_0                       0xCC4168
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_1                       0xCC416C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_2                       0xCC4170
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_3                       0xCC4174
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_4                       0xCC4178
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_5                       0xCC417C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_6                       0xCC4180
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_7                       0xCC4184
+
+#define mmNIC0_STAT_AMACCONTROLFRAMESRECEIVED                        0xCC4188
+
+#define mmNIC0_STAT_ETHERSTATSOCTETS_1                               0xCC418C
+
+#define mmNIC0_STAT_OCTETSRECEIVEDOK_1                               0xCC4190
+
+#define mmNIC0_STAT_AALIGNMENTERRORS_1                               0xCC4194
+
+#define mmNIC0_STAT_APAUSEMACCTRLFRAMESRECEIVED_1                    0xCC4198
+
+#define mmNIC0_STAT_AFRAMETOOLONGERRORS_1                            0xCC419C
+
+#define mmNIC0_STAT_AINRANGELENGTHERRORS_1                           0xCC41A0
+
+#define mmNIC0_STAT_AFRAMESRECEIVEDOK_1                              0xCC41A4
+
+#define mmNIC0_STAT_VLANRECEIVEDOK_1                                 0xCC41A8
+
+#define mmNIC0_STAT_AFRAMECHECKSEQUENCEERRORS_1                      0xCC41AC
+
+#define mmNIC0_STAT_IFINERRORS_1                                     0xCC41B0
+
+#define mmNIC0_STAT_IFINUCASTPKTS_1                                  0xCC41B4
+
+#define mmNIC0_STAT_IFINMULTICASTPKTS_1                              0xCC41B8
+
+#define mmNIC0_STAT_IFINBROADCASTPKTS_1                              0xCC41BC
+
+#define mmNIC0_STAT_ETHERSTATSDROPEVENTS_1                           0xCC41C0
+
+#define mmNIC0_STAT_ETHERSTATSUNDERSIZEPKTS_1                        0xCC41C4
+
+#define mmNIC0_STAT_ETHERSTATSPKTS_1                                 0xCC41C8
+
+#define mmNIC0_STAT_ETHERSTATSPKTS64OCTETS_1                         0xCC41CC
+
+#define mmNIC0_STAT_ETHERSTATSPKTS65TO127OCTETS_1                    0xCC41D0
+
+#define mmNIC0_STAT_ETHERSTATSPKTS128TO255OCTETS_1                   0xCC41D4
+
+#define mmNIC0_STAT_ETHERSTATSPKTS256TO511OCTETS_1                   0xCC41D8
+
+#define mmNIC0_STAT_ETHERSTATSPKTS512TO1023OCTETS_1                  0xCC41DC
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1024TO1518OCTETS_1                 0xCC41E0
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1519TOMAXOCTETS_1                  0xCC41E4
+
+#define mmNIC0_STAT_ETHERSTATSOVERSIZEPKTS_1                         0xCC41E8
+
+#define mmNIC0_STAT_ETHERSTATSJABBERS_1                              0xCC41EC
+
+#define mmNIC0_STAT_ETHERSTATSFRAGMENTS_1                            0xCC41F0
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_0_1                     0xCC41F4
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_1_1                     0xCC41F8
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_2_1                     0xCC41FC
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_3_1                     0xCC4200
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_4_1                     0xCC4204
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_5_1                     0xCC4208
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_6_1                     0xCC420C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_7_1                     0xCC4210
+
+#define mmNIC0_STAT_AMACCONTROLFRAMESRECEIVED_1                      0xCC4214
+
+#define mmNIC0_STAT_ETHERSTATSOCTETS_2                               0xCC4218
+
+#define mmNIC0_STAT_OCTETSRECEIVEDOK_2                               0xCC421C
+
+#define mmNIC0_STAT_AALIGNMENTERRORS_2                               0xCC4220
+
+#define mmNIC0_STAT_APAUSEMACCTRLFRAMESRECEIVED_2                    0xCC4224
+
+#define mmNIC0_STAT_AFRAMETOOLONGERRORS_2                            0xCC4228
+
+#define mmNIC0_STAT_AINRANGELENGTHERRORS_2                           0xCC422C
+
+#define mmNIC0_STAT_AFRAMESRECEIVEDOK_2                              0xCC4230
+
+#define mmNIC0_STAT_VLANRECEIVEDOK_2                                 0xCC4234
+
+#define mmNIC0_STAT_AFRAMECHECKSEQUENCEERRORS_2                      0xCC4238
+
+#define mmNIC0_STAT_IFINERRORS_2                                     0xCC423C
+
+#define mmNIC0_STAT_IFINUCASTPKTS_2                                  0xCC4240
+
+#define mmNIC0_STAT_IFINMULTICASTPKTS_2                              0xCC4244
+
+#define mmNIC0_STAT_IFINBROADCASTPKTS_2                              0xCC4248
+
+#define mmNIC0_STAT_ETHERSTATSDROPEVENTS_2                           0xCC424C
+
+#define mmNIC0_STAT_ETHERSTATSUNDERSIZEPKTS_2                        0xCC4250
+
+#define mmNIC0_STAT_ETHERSTATSPKTS_2                                 0xCC4254
+
+#define mmNIC0_STAT_ETHERSTATSPKTS64OCTETS_2                         0xCC4258
+
+#define mmNIC0_STAT_ETHERSTATSPKTS65TO127OCTETS_2                    0xCC425C
+
+#define mmNIC0_STAT_ETHERSTATSPKTS128TO255OCTETS_2                   0xCC4260
+
+#define mmNIC0_STAT_ETHERSTATSPKTS256TO511OCTETS_2                   0xCC4264
+
+#define mmNIC0_STAT_ETHERSTATSPKTS512TO1023OCTETS_2                  0xCC4268
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1024TO1518OCTETS_2                 0xCC426C
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1519TOMAXOCTETS_2                  0xCC4270
+
+#define mmNIC0_STAT_ETHERSTATSOVERSIZEPKTS_2                         0xCC4274
+
+#define mmNIC0_STAT_ETHERSTATSJABBERS_2                              0xCC4278
+
+#define mmNIC0_STAT_ETHERSTATSFRAGMENTS_2                            0xCC427C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_0_2                     0xCC4280
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_1_2                     0xCC4284
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_2_2                     0xCC4288
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_3_2                     0xCC428C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_4_2                     0xCC4290
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_5_2                     0xCC4294
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_6_2                     0xCC4298
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_7_2                     0xCC429C
+
+#define mmNIC0_STAT_AMACCONTROLFRAMESRECEIVED_2                      0xCC42A0
+
+#define mmNIC0_STAT_ETHERSTATSOCTETS_3                               0xCC42A4
+
+#define mmNIC0_STAT_OCTETSRECEIVEDOK_3                               0xCC42A8
+
+#define mmNIC0_STAT_AALIGNMENTERRORS_3                               0xCC42AC
+
+#define mmNIC0_STAT_APAUSEMACCTRLFRAMESRECEIVED_3                    0xCC42B0
+
+#define mmNIC0_STAT_AFRAMETOOLONGERRORS_3                            0xCC42B4
+
+#define mmNIC0_STAT_AINRANGELENGTHERRORS_3                           0xCC42B8
+
+#define mmNIC0_STAT_AFRAMESRECEIVEDOK_3                              0xCC42BC
+
+#define mmNIC0_STAT_VLANRECEIVEDOK_3                                 0xCC42C0
+
+#define mmNIC0_STAT_AFRAMECHECKSEQUENCEERRORS_3                      0xCC42C4
+
+#define mmNIC0_STAT_IFINERRORS_3                                     0xCC42C8
+
+#define mmNIC0_STAT_IFINUCASTPKTS_3                                  0xCC42CC
+
+#define mmNIC0_STAT_IFINMULTICASTPKTS_3                              0xCC42D0
+
+#define mmNIC0_STAT_IFINBROADCASTPKTS_3                              0xCC42D4
+
+#define mmNIC0_STAT_ETHERSTATSDROPEVENTS_3                           0xCC42D8
+
+#define mmNIC0_STAT_ETHERSTATSUNDERSIZEPKTS_3                        0xCC42DC
+
+#define mmNIC0_STAT_ETHERSTATSPKTS_3                                 0xCC42E0
+
+#define mmNIC0_STAT_ETHERSTATSPKTS64OCTETS_3                         0xCC42E4
+
+#define mmNIC0_STAT_ETHERSTATSPKTS65TO127OCTETS_3                    0xCC42E8
+
+#define mmNIC0_STAT_ETHERSTATSPKTS128TO255OCTETS_3                   0xCC42EC
+
+#define mmNIC0_STAT_ETHERSTATSPKTS256TO511OCTETS_3                   0xCC42F0
+
+#define mmNIC0_STAT_ETHERSTATSPKTS512TO1023OCTETS_3                  0xCC42F4
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1024TO1518OCTETS_3                 0xCC42F8
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1519TOMAXOCTETS_3                  0xCC42FC
+
+#define mmNIC0_STAT_ETHERSTATSOVERSIZEPKTS_3                         0xCC4300
+
+#define mmNIC0_STAT_ETHERSTATSJABBERS_3                              0xCC4304
+
+#define mmNIC0_STAT_ETHERSTATSFRAGMENTS_3                            0xCC4308
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_0_3                     0xCC430C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_1_3                     0xCC4310
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_2_3                     0xCC4314
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_3_3                     0xCC4318
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_4_3                     0xCC431C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_5_3                     0xCC4320
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_6_3                     0xCC4324
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESRECEIVED_7_3                     0xCC4328
+
+#define mmNIC0_STAT_AMACCONTROLFRAMESRECEIVED_3                      0xCC432C
+
+#define mmNIC0_STAT_ETHERSTATSOCTETS_4                               0xCC4330
+
+#define mmNIC0_STAT_OCTETSTRANSMITTEDOK                              0xCC4334
+
+#define mmNIC0_STAT_APAUSEMACCTRLFRAMESTRANSMITTED                   0xCC4338
+
+#define mmNIC0_STAT_AFRAMESTRANSMITTEDOK                             0xCC433C
+
+#define mmNIC0_STAT_VLANTRANSMITTEDOK                                0xCC4340
+
+#define mmNIC0_STAT_IFOUTERRORS                                      0xCC4344
+
+#define mmNIC0_STAT_IFOUTUCASTPKTS                                   0xCC4348
+
+#define mmNIC0_STAT_IFOUTMULTICASTPKTS                               0xCC434C
+
+#define mmNIC0_STAT_IFOUTBROADCASTPKTS                               0xCC4350
+
+#define mmNIC0_STAT_ETHERSTATSPKTS64OCTETS_4                         0xCC4354
+
+#define mmNIC0_STAT_ETHERSTATSPKTS65TO127OCTETS_4                    0xCC4358
+
+#define mmNIC0_STAT_ETHERSTATSPKTS128TO255OCTETS_4                   0xCC435C
+
+#define mmNIC0_STAT_ETHERSTATSPKTS256TO511OCTETS_4                   0xCC4360
+
+#define mmNIC0_STAT_ETHERSTATSPKTS512TO1023OCTETS_4                  0xCC4364
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1024TO1518OCTETS_4                 0xCC4368
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1519TOMAXOCTETS_4                  0xCC436C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_0                    0xCC4370
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_1                    0xCC4374
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_2                    0xCC4378
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_3                    0xCC437C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_4                    0xCC4380
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_5                    0xCC4384
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_6                    0xCC4388
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_7                    0xCC438C
+
+#define mmNIC0_STAT_AMACCONTROLFRAMESTRANSMITTED                     0xCC4390
+
+#define mmNIC0_STAT_ETHERSTATSPKTS_4                                 0xCC4394
+
+#define mmNIC0_STAT_ETHERSTATSOCTETS_5                               0xCC4398
+
+#define mmNIC0_STAT_OCTETSTRANSMITTEDOK_1                            0xCC439C
+
+#define mmNIC0_STAT_APAUSEMACCTRLFRAMESTRANSMITTED_1                 0xCC43A0
+
+#define mmNIC0_STAT_AFRAMESTRANSMITTEDOK_1                           0xCC43A4
+
+#define mmNIC0_STAT_VLANTRANSMITTEDOK_1                              0xCC43A8
+
+#define mmNIC0_STAT_IFOUTERRORS_1                                    0xCC43AC
+
+#define mmNIC0_STAT_IFOUTUCASTPKTS_1                                 0xCC43B0
+
+#define mmNIC0_STAT_IFOUTMULTICASTPKTS_1                             0xCC43B4
+
+#define mmNIC0_STAT_IFOUTBROADCASTPKTS_1                             0xCC43B8
+
+#define mmNIC0_STAT_ETHERSTATSPKTS64OCTETS_5                         0xCC43BC
+
+#define mmNIC0_STAT_ETHERSTATSPKTS65TO127OCTETS_5                    0xCC43C0
+
+#define mmNIC0_STAT_ETHERSTATSPKTS128TO255OCTETS_5                   0xCC43C4
+
+#define mmNIC0_STAT_ETHERSTATSPKTS256TO511OCTETS_5                   0xCC43C8
+
+#define mmNIC0_STAT_ETHERSTATSPKTS512TO1023OCTETS_5                  0xCC43CC
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1024TO1518OCTETS_5                 0xCC43D0
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1519TOMAXOCTETS_5                  0xCC43D4
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_0_1                  0xCC43D8
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_1_1                  0xCC43DC
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_2_1                  0xCC43E0
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_3_1                  0xCC43E4
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_4_1                  0xCC43E8
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_5_1                  0xCC43EC
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_6_1                  0xCC43F0
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_7_1                  0xCC43F4
+
+#define mmNIC0_STAT_AMACCONTROLFRAMESTRANSMITTED_1                   0xCC43F8
+
+#define mmNIC0_STAT_ETHERSTATSPKTS_5                                 0xCC43FC
+
+#define mmNIC0_STAT_ETHERSTATSOCTETS_6                               0xCC4400
+
+#define mmNIC0_STAT_OCTETSTRANSMITTEDOK_2                            0xCC4404
+
+#define mmNIC0_STAT_APAUSEMACCTRLFRAMESTRANSMITTED_2                 0xCC4408
+
+#define mmNIC0_STAT_AFRAMESTRANSMITTEDOK_2                           0xCC440C
+
+#define mmNIC0_STAT_VLANTRANSMITTEDOK_2                              0xCC4410
+
+#define mmNIC0_STAT_IFOUTERRORS_2                                    0xCC4414
+
+#define mmNIC0_STAT_IFOUTUCASTPKTS_2                                 0xCC4418
+
+#define mmNIC0_STAT_IFOUTMULTICASTPKTS_2                             0xCC441C
+
+#define mmNIC0_STAT_IFOUTBROADCASTPKTS_2                             0xCC4420
+
+#define mmNIC0_STAT_ETHERSTATSPKTS64OCTETS_6                         0xCC4424
+
+#define mmNIC0_STAT_ETHERSTATSPKTS65TO127OCTETS_6                    0xCC4428
+
+#define mmNIC0_STAT_ETHERSTATSPKTS128TO255OCTETS_6                   0xCC442C
+
+#define mmNIC0_STAT_ETHERSTATSPKTS256TO511OCTETS_6                   0xCC4430
+
+#define mmNIC0_STAT_ETHERSTATSPKTS512TO1023OCTETS_6                  0xCC4434
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1024TO1518OCTETS_6                 0xCC4438
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1519TOMAXOCTETS_6                  0xCC443C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_0_2                  0xCC4440
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_1_2                  0xCC4444
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_2_2                  0xCC4448
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_3_2                  0xCC444C
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_4_2                  0xCC4450
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_5_2                  0xCC4454
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_6_2                  0xCC4458
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_7_2                  0xCC445C
+
+#define mmNIC0_STAT_AMACCONTROLFRAMESTRANSMITTED_2                   0xCC4460
+
+#define mmNIC0_STAT_ETHERSTATSPKTS_6                                 0xCC4464
+
+#define mmNIC0_STAT_ETHERSTATSOCTETS_7                               0xCC4468
+
+#define mmNIC0_STAT_OCTETSTRANSMITTEDOK_3                            0xCC446C
+
+#define mmNIC0_STAT_APAUSEMACCTRLFRAMESTRANSMITTED_3                 0xCC4470
+
+#define mmNIC0_STAT_AFRAMESTRANSMITTEDOK_3                           0xCC4474
+
+#define mmNIC0_STAT_VLANTRANSMITTEDOK_3                              0xCC4478
+
+#define mmNIC0_STAT_IFOUTERRORS_3                                    0xCC447C
+
+#define mmNIC0_STAT_IFOUTUCASTPKTS_3                                 0xCC4480
+
+#define mmNIC0_STAT_IFOUTMULTICASTPKTS_3                             0xCC4484
+
+#define mmNIC0_STAT_IFOUTBROADCASTPKTS_3                             0xCC4488
+
+#define mmNIC0_STAT_ETHERSTATSPKTS64OCTETS_7                         0xCC448C
+
+#define mmNIC0_STAT_ETHERSTATSPKTS65TO127OCTETS_7                    0xCC4490
+
+#define mmNIC0_STAT_ETHERSTATSPKTS128TO255OCTETS_7                   0xCC4494
+
+#define mmNIC0_STAT_ETHERSTATSPKTS256TO511OCTETS_7                   0xCC4498
+
+#define mmNIC0_STAT_ETHERSTATSPKTS512TO1023OCTETS_7                  0xCC449C
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1024TO1518OCTETS_7                 0xCC44A0
+
+#define mmNIC0_STAT_ETHERSTATSPKTS1519TOMAXOCTETS_7                  0xCC44A4
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_0_3                  0xCC44A8
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_1_3                  0xCC44AC
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_2_3                  0xCC44B0
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_3_3                  0xCC44B4
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_4_3                  0xCC44B8
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_5_3                  0xCC44BC
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_6_3                  0xCC44C0
+
+#define mmNIC0_STAT_ACBFCPAUSEFRAMESTRANSMITTED_7_3                  0xCC44C4
+
+#define mmNIC0_STAT_AMACCONTROLFRAMESTRANSMITTED_3                   0xCC44C8
+
+#define mmNIC0_STAT_ETHERSTATSPKTS_7                                 0xCC44CC
+
+#endif /* ASIC_REG_NIC0_STAT_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
new file mode 100644
index 000000000000..abaa12395969
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_TMR_REGS_H_
+#define ASIC_REG_NIC0_TMR_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_TMR (Prototype: NIC_TMR)
+ *****************************************
+ */
+
+#define mmNIC0_TMR_TMR_PUSH_MASK                                     0xCF5000
+
+#define mmNIC0_TMR_TMR_POP_MASK                                      0xCF5004
+
+#define mmNIC0_TMR_TMR_PUSH_RELEASE_INVALIDATE                       0xCF5008
+
+#define mmNIC0_TMR_TMR_POP_RELEASE_INVALIDATE                        0xCF500C
+
+#define mmNIC0_TMR_TMR_LIST_MEM_READ_MASK                            0xCF5010
+
+#define mmNIC0_TMR_TMR_FIFO_MEM_READ_MASK                            0xCF5014
+
+#define mmNIC0_TMR_TMR_LIST_MEM_WRITE_MASK                           0xCF5018
+
+#define mmNIC0_TMR_TMR_FIFO_MEM_WRITE_MASK                           0xCF501C
+
+#define mmNIC0_TMR_TMR_BASE_ADDRESS_49_18                            0xCF5020
+
+#define mmNIC0_TMR_TMR_BASE_ADDRESS_17_7                             0xCF5024
+
+#define mmNIC0_TMR_TMR_LIST_AXI_USER                                 0xCF5028
+
+#define mmNIC0_TMR_TMR_LIST_AXI_PROT                                 0xCF502C
+
+#define mmNIC0_TMR_TMR_STATE_AXI_USER                                0xCF5030
+
+#define mmNIC0_TMR_TMR_STATE_AXI_PROT                                0xCF5034
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_EN                              0xCF503C
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_FIFO                            0xCF5040
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_31_0                       0xCF5044
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_63_32                      0xCF5048
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_95_64                      0xCF504C
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_127_96                     0xCF5050
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_159_128                    0xCF5054
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_191_160                    0xCF5058
+
+#define mmNIC0_TMR_TMR_SCHEDQ_UPDATE_DESC_216_192                    0xCF505C
+
+#define mmNIC0_TMR_TMR_FORCE_HIT_EN                                  0xCF5060
+
+#define mmNIC0_TMR_TMR_INVALIDATE_LIST                               0xCF5064
+
+#define mmNIC0_TMR_TMR_INVALIDATE_LIST_STAT                          0xCF5068
+
+#define mmNIC0_TMR_TMR_INVALIDATE_FREE                               0xCF506C
+
+#define mmNIC0_TMR_TMR_INVALIDATE_FREE_STAT                          0xCF5070
+
+#define mmNIC0_TMR_TMR_PUSH_PREFETCH_EN                              0xCF5074
+
+#define mmNIC0_TMR_TMR_PUSH_RELEASE_EN                               0xCF5078
+
+#define mmNIC0_TMR_TMR_PUSH_LOCK_EN                                  0xCF507C
+
+#define mmNIC0_TMR_TMR_PUSH_PREFETCH_NEXT_EN                         0xCF5080
+
+#define mmNIC0_TMR_TMR_POP_PREFETCH_EN                               0xCF5084
+
+#define mmNIC0_TMR_TMR_POP_RELEASE_EN                                0xCF5088
+
+#define mmNIC0_TMR_TMR_POP_LOCK_EN                                   0xCF508C
+
+#define mmNIC0_TMR_TMR_POP_PREFETCH_NEXT_EN                          0xCF5090
+
+#define mmNIC0_TMR_TMR_LIST_MASK                                     0xCF5094
+
+#define mmNIC0_TMR_TMR_RELEASE_INCALIDATE                            0xCF5098
+
+#define mmNIC0_TMR_TMR_BASE_ADDRESS_FREE_LIST_49_32                  0xCF509C
+
+#define mmNIC0_TMR_TMR_BASE_ADDRESS_FREE_LIST_31_0                   0xCF50A0
+
+#define mmNIC0_TMR_TMR_FREE_LIST_EN                                  0xCF50A4
+
+#define mmNIC0_TMR_TMR_PUSH_FORCE_HIT_EN                             0xCF50A8
+
+#define mmNIC0_TMR_TMR_PRODUCER_UPDATE_EN                            0xCF50AC
+
+#define mmNIC0_TMR_TMR_PRODUCER_UPDATE                               0xCF50B0
+
+#define mmNIC0_TMR_TMR_CAHE_INVALIDATE                               0xCF50B4
+
+#define mmNIC0_TMR_TMR_CAHE_INVALIDATE_STAT                          0xCF50B8
+
+#define mmNIC0_TMR_TMR_CACHE_CLEAR_LINK_LIST                         0xCF50BC
+
+#define mmNIC0_TMR_TMR_CACHE_CFG                                     0xCF50C0
+
+#define mmNIC0_TMR_TMR_CACHE_BASE_ADDR_49_32                         0xCF50C4
+
+#define mmNIC0_TMR_TMR_CACHE_BASE_ADDR_31_7                          0xCF50C8
+
+#define mmNIC0_TMR_TMR_TIMER_EN                                      0xCF50CC
+
+#define mmNIC0_TMR_TMR_TICK_WRAP                                     0xCF50D0
+
+#define mmNIC0_TMR_TMR_SCAN_TIMER_COMP_47_32                         0xCF50D4
+
+#define mmNIC0_TMR_TMR_SCAN_TIMER_COMP_31_0                          0xCF50D8
+
+#define mmNIC0_TMR_TMR_SCHEDQS_0                                     0xCF50DC
+
+#define mmNIC0_TMR_TMR_SCHEDQS_1                                     0xCF50E0
+
+#define mmNIC0_TMR_TMR_SCHEDQS_2                                     0xCF50E4
+
+#define mmNIC0_TMR_TMR_SCHEDQS_3                                     0xCF50E8
+
+#define mmNIC0_TMR_TMR_CACHES_CFG                                    0xCF50EC
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_0                            0xCF50F0
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_1                            0xCF50F4
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_2                            0xCF50F8
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_3                            0xCF50FC
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_4                            0xCF5100
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_5                            0xCF5104
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_6                            0xCF5108
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_7                            0xCF510C
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_8                            0xCF5110
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_9                            0xCF5114
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_10                           0xCF5118
+
+#define mmNIC0_TMR_TMR_DBG_COUNT_SELECT_11                           0xCF511C
+
+#define mmNIC0_TMR_TMR_POP_CACHE_CREDIT                              0xCF5138
+
+#define mmNIC0_TMR_TMR_PIPE_CREDIT                                   0xCF513C
+
+#define mmNIC0_TMR_TMR_DBG_TRIG                                      0xCF5140
+
+#define mmNIC0_TMR_INTERRUPT_CAUSE                                   0xCF5144
+
+#define mmNIC0_TMR_INTERRUPT_MASK                                    0xCF5148
+
+#define mmNIC0_TMR_INTERRUPT_CLR                                     0xCF514C
+
+#define mmNIC0_TMR_TRM_SLICE_CREDIT                                  0xCF5150
+
+#define mmNIC0_TMR_TMR_AXI_CACHE                                     0xCF5154
+
+#define mmNIC0_TMR_FREE_LIST_PUSH_MASK_EN                            0xCF5158
+
+#define mmNIC0_TMR_FREE_AEMPTY_THRESHOLD                             0xCF515C
+
+#endif /* ASIC_REG_NIC0_TMR_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
new file mode 100644
index 000000000000..679164dad97e
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
@@ -0,0 +1,336 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_TXE0_MASKS_H_
+#define ASIC_REG_NIC0_TXE0_MASKS_H_
+
+/*
+ *****************************************
+ *   NIC0_TXE0 (Prototype: NIC_TXE)
+ *****************************************
+ */
+
+/* NIC0_TXE0_WQE_FETCH_REQ_MASK_31_0 */
+#define NIC0_TXE0_WQE_FETCH_REQ_MASK_31_0_R_SHIFT                    0
+#define NIC0_TXE0_WQE_FETCH_REQ_MASK_31_0_R_MASK                     0xFFFFFFFF
+
+/* NIC0_TXE0_WQE_FETCH_REQ_MASK_47_32 */
+#define NIC0_TXE0_WQE_FETCH_REQ_MASK_47_32_R_SHIFT                   0
+#define NIC0_TXE0_WQE_FETCH_REQ_MASK_47_32_R_MASK                    0xFFFF
+
+/* NIC0_TXE0_LOCAL_WQ_BUFFER_SIZE */
+#define NIC0_TXE0_LOCAL_WQ_BUFFER_SIZE_R_SHIFT                       0
+#define NIC0_TXE0_LOCAL_WQ_BUFFER_SIZE_R_MASK                        0xF
+
+/* NIC0_TXE0_LOCAL_WQ_LINE_SIZE */
+#define NIC0_TXE0_LOCAL_WQ_LINE_SIZE_R_SHIFT                         0
+#define NIC0_TXE0_LOCAL_WQ_LINE_SIZE_R_MASK                          0xF
+
+/* NIC0_TXE0_LOG_MAX_WQ_SIZE */
+#define NIC0_TXE0_LOG_MAX_WQ_SIZE_R_SHIFT                            0
+#define NIC0_TXE0_LOG_MAX_WQ_SIZE_R_MASK                             0x1F
+
+/* NIC0_TXE0_SQ_BASE_ADDRESS_49_32 */
+#define NIC0_TXE0_SQ_BASE_ADDRESS_49_32_R_SHIFT                      0
+#define NIC0_TXE0_SQ_BASE_ADDRESS_49_32_R_MASK                       0x3FFFF
+
+/* NIC0_TXE0_SQ_BASE_ADDRESS_31_0 */
+#define NIC0_TXE0_SQ_BASE_ADDRESS_31_0_R_SHIFT                       0
+#define NIC0_TXE0_SQ_BASE_ADDRESS_31_0_R_MASK                        0xFFFFFFFF
+
+/* NIC0_TXE0_SQ_BASE_ADDRESS_SEL */
+#define NIC0_TXE0_SQ_BASE_ADDRESS_SEL_R_SHIFT                        0
+#define NIC0_TXE0_SQ_BASE_ADDRESS_SEL_R_MASK                         0x1F
+
+/* NIC0_TXE0_ALLOC_CREDIT */
+#define NIC0_TXE0_ALLOC_CREDIT_R_SHIFT                               0
+#define NIC0_TXE0_ALLOC_CREDIT_R_MASK                                0xFF
+
+/* NIC0_TXE0_ALLOC_CREDIT_FORCE_FULL */
+#define NIC0_TXE0_ALLOC_CREDIT_FORCE_FULL_R_SHIFT                    0
+#define NIC0_TXE0_ALLOC_CREDIT_FORCE_FULL_R_MASK                     0x1
+
+/* NIC0_TXE0_READ_CREDIT */
+#define NIC0_TXE0_READ_CREDIT_R_SHIFT                                0
+#define NIC0_TXE0_READ_CREDIT_R_MASK                                 0x7FF
+
+/* NIC0_TXE0_READ_CREDIT_FORCE_FULL */
+#define NIC0_TXE0_READ_CREDIT_FORCE_FULL_R_SHIFT                     0
+#define NIC0_TXE0_READ_CREDIT_FORCE_FULL_R_MASK                      0x1
+
+/* NIC0_TXE0_BURST_ENABLE */
+#define NIC0_TXE0_BURST_ENABLE_R_SHIFT                               0
+#define NIC0_TXE0_BURST_ENABLE_R_MASK                                0x1
+
+/* NIC0_TXE0_WR_INIT_BUSY */
+#define NIC0_TXE0_WR_INIT_BUSY_R_SHIFT                               0
+#define NIC0_TXE0_WR_INIT_BUSY_R_MASK                                0x3
+
+/* NIC0_TXE0_READ_RES_WT_INIT_BUSY */
+#define NIC0_TXE0_READ_RES_WT_INIT_BUSY_R_SHIFT                      0
+#define NIC0_TXE0_READ_RES_WT_INIT_BUSY_R_MASK                       0x1
+
+/* NIC0_TXE0_BTH_TVER */
+#define NIC0_TXE0_BTH_TVER_R_SHIFT                                   0
+#define NIC0_TXE0_BTH_TVER_R_MASK                                    0xF
+
+/* NIC0_TXE0_IPV4_IDENTIFICATION */
+#define NIC0_TXE0_IPV4_IDENTIFICATION_R_SHIFT                        0
+#define NIC0_TXE0_IPV4_IDENTIFICATION_R_MASK                         0xFFFF
+
+/* NIC0_TXE0_IPV4_FLAGS */
+#define NIC0_TXE0_IPV4_FLAGS_R_SHIFT                                 0
+#define NIC0_TXE0_IPV4_FLAGS_R_MASK                                  0x7
+
+/* NIC0_TXE0_PAD */
+#define NIC0_TXE0_PAD_ENABLE_SHIFT                                   0
+#define NIC0_TXE0_PAD_ENABLE_MASK                                    0x1
+#define NIC0_TXE0_PAD_RAW_QP_ENABLE_SHIFT                            1
+#define NIC0_TXE0_PAD_RAW_QP_ENABLE_MASK                             0x2
+
+/* NIC0_TXE0_ADD_PAD_TO_IPV4_LEN */
+#define NIC0_TXE0_ADD_PAD_TO_IPV4_LEN_R_SHIFT                        0
+#define NIC0_TXE0_ADD_PAD_TO_IPV4_LEN_R_MASK                         0x1
+
+/* NIC0_TXE0_ADD_PAD_TO_UDP_LEN */
+#define NIC0_TXE0_ADD_PAD_TO_UDP_LEN_R_SHIFT                         0
+#define NIC0_TXE0_ADD_PAD_TO_UDP_LEN_R_MASK                          0x1
+
+/* NIC0_TXE0_ICRC_EN */
+#define NIC0_TXE0_ICRC_EN_R_SHIFT                                    0
+#define NIC0_TXE0_ICRC_EN_R_MASK                                     0x1
+
+/* NIC0_TXE0_UDP_MASK_S_PORT */
+#define NIC0_TXE0_UDP_MASK_S_PORT_R_SHIFT                            0
+#define NIC0_TXE0_UDP_MASK_S_PORT_R_MASK                             0xFFFF
+
+/* NIC0_TXE0_UDP_CHECKSUM */
+#define NIC0_TXE0_UDP_CHECKSUM_R_SHIFT                               0
+#define NIC0_TXE0_UDP_CHECKSUM_R_MASK                                0xFFFF
+
+/* NIC0_TXE0_UDP_DEST_PORT */
+#define NIC0_TXE0_UDP_DEST_PORT_R_SHIFT                              0
+#define NIC0_TXE0_UDP_DEST_PORT_R_MASK                               0xFFFF
+
+/* NIC0_TXE0_PORT0_MAC_CFG_47_32 */
+#define NIC0_TXE0_PORT0_MAC_CFG_47_32_R_SHIFT                        0
+#define NIC0_TXE0_PORT0_MAC_CFG_47_32_R_MASK                         0xFFFF
+
+/* NIC0_TXE0_PORT0_MAC_CFG_31_0 */
+#define NIC0_TXE0_PORT0_MAC_CFG_31_0_R_SHIFT                         0
+#define NIC0_TXE0_PORT0_MAC_CFG_31_0_R_MASK                          0xFFFFFFFF
+
+/* NIC0_TXE0_PORT1_MAC_CFG_47_32 */
+#define NIC0_TXE0_PORT1_MAC_CFG_47_32_R_SHIFT                        0
+#define NIC0_TXE0_PORT1_MAC_CFG_47_32_R_MASK                         0xFFFF
+
+/* NIC0_TXE0_PORT1_MAC_CFG_31_0 */
+#define NIC0_TXE0_PORT1_MAC_CFG_31_0_R_SHIFT                         0
+#define NIC0_TXE0_PORT1_MAC_CFG_31_0_R_MASK                          0xFFFFFFFF
+
+/* NIC0_TXE0_PRIO_TO_DSCP */
+#define NIC0_TXE0_PRIO_TO_DSCP_PRIO0_SHIFT                           0
+#define NIC0_TXE0_PRIO_TO_DSCP_PRIO0_MASK                            0x3F
+#define NIC0_TXE0_PRIO_TO_DSCP_PRIO1_SHIFT                           8
+#define NIC0_TXE0_PRIO_TO_DSCP_PRIO1_MASK                            0x3F00
+#define NIC0_TXE0_PRIO_TO_DSCP_PRIO2_SHIFT                           16
+#define NIC0_TXE0_PRIO_TO_DSCP_PRIO2_MASK                            0x3F0000
+#define NIC0_TXE0_PRIO_TO_DSCP_PRIO3_SHIFT                           24
+#define NIC0_TXE0_PRIO_TO_DSCP_PRIO3_MASK                            0x3F000000
+
+/* NIC0_TXE0_PRIO_TO_PCP */
+#define NIC0_TXE0_PRIO_TO_PCP_PORT0_PRIO0_SHIFT                      0
+#define NIC0_TXE0_PRIO_TO_PCP_PORT0_PRIO0_MASK                       0x7
+#define NIC0_TXE0_PRIO_TO_PCP_PORT0_PRIO1_SHIFT                      3
+#define NIC0_TXE0_PRIO_TO_PCP_PORT0_PRIO1_MASK                       0x38
+#define NIC0_TXE0_PRIO_TO_PCP_PORT0_PRIO2_SHIFT                      6
+#define NIC0_TXE0_PRIO_TO_PCP_PORT0_PRIO2_MASK                       0x1C0
+#define NIC0_TXE0_PRIO_TO_PCP_PORT0_PRIO3_SHIFT                      9
+#define NIC0_TXE0_PRIO_TO_PCP_PORT0_PRIO3_MASK                       0xE00
+#define NIC0_TXE0_PRIO_TO_PCP_PORT1_PRIO0_SHIFT                      12
+#define NIC0_TXE0_PRIO_TO_PCP_PORT1_PRIO0_MASK                       0x7000
+#define NIC0_TXE0_PRIO_TO_PCP_PORT1_PRIO1_SHIFT                      15
+#define NIC0_TXE0_PRIO_TO_PCP_PORT1_PRIO1_MASK                       0x38000
+#define NIC0_TXE0_PRIO_TO_PCP_PORT1_PRIO2_SHIFT                      18
+#define NIC0_TXE0_PRIO_TO_PCP_PORT1_PRIO2_MASK                       0x1C0000
+#define NIC0_TXE0_PRIO_TO_PCP_PORT1_PRIO3_SHIFT                      21
+#define NIC0_TXE0_PRIO_TO_PCP_PORT1_PRIO3_MASK                       0xE00000
+
+/* NIC0_TXE0_MAC_ETHER_TYPE */
+#define NIC0_TXE0_MAC_ETHER_TYPE_R_SHIFT                             0
+#define NIC0_TXE0_MAC_ETHER_TYPE_R_MASK                              0xFFFF
+
+/* NIC0_TXE0_MAC_ETHER_TYPE_VLAN */
+#define NIC0_TXE0_MAC_ETHER_TYPE_VLAN_R_SHIFT                        0
+#define NIC0_TXE0_MAC_ETHER_TYPE_VLAN_R_MASK                         0xFFFF
+
+/* NIC0_TXE0_ECN_0 */
+#define NIC0_TXE0_ECN_0_R_SHIFT                                      0
+#define NIC0_TXE0_ECN_0_R_MASK                                       0x3
+
+/* NIC0_TXE0_ECN_1 */
+#define NIC0_TXE0_ECN_1_R_SHIFT                                      0
+#define NIC0_TXE0_ECN_1_R_MASK                                       0x3
+
+/* NIC0_TXE0_IPV4_TIME_TO_LIVE_0 */
+#define NIC0_TXE0_IPV4_TIME_TO_LIVE_0_R_SHIFT                        0
+#define NIC0_TXE0_IPV4_TIME_TO_LIVE_0_R_MASK                         0xFF
+
+/* NIC0_TXE0_IPV4_TIME_TO_LIVE_1 */
+#define NIC0_TXE0_IPV4_TIME_TO_LIVE_1_R_SHIFT                        0
+#define NIC0_TXE0_IPV4_TIME_TO_LIVE_1_R_MASK                         0xFF
+
+/* NIC0_TXE0_PRIO_PORT_CREDIT_FORCE */
+#define NIC0_TXE0_PRIO_PORT_CREDIT_FORCE_FORCE_FULL_SHIFT            0
+#define NIC0_TXE0_PRIO_PORT_CREDIT_FORCE_FORCE_FULL_MASK             0xFF
+
+/* NIC0_TXE0_PRIO_PORT_CRDIT */
+#define NIC0_TXE0_PRIO_PORT_CRDIT_R_SHIFT                            0
+#define NIC0_TXE0_PRIO_PORT_CRDIT_R_MASK                             0xFF
+
+/* NIC0_TXE0_WQE_FETCH_TOKEN_EN */
+#define NIC0_TXE0_WQE_FETCH_TOKEN_EN_R_SHIFT                         0
+#define NIC0_TXE0_WQE_FETCH_TOKEN_EN_R_MASK                          0x1
+
+/* NIC0_TXE0_NACK_SYNDROME */
+#define NIC0_TXE0_NACK_SYNDROME_SYNDROME_0_SHIFT                     0
+#define NIC0_TXE0_NACK_SYNDROME_SYNDROME_0_MASK                      0xFF
+#define NIC0_TXE0_NACK_SYNDROME_SYNDROME_1_SHIFT                     8
+#define NIC0_TXE0_NACK_SYNDROME_SYNDROME_1_MASK                      0xFF00
+#define NIC0_TXE0_NACK_SYNDROME_SYNDROME_2_SHIFT                     16
+#define NIC0_TXE0_NACK_SYNDROME_SYNDROME_2_MASK                      0xFF0000
+#define NIC0_TXE0_NACK_SYNDROME_SYNDROME_3_SHIFT                     24
+#define NIC0_TXE0_NACK_SYNDROME_SYNDROME_3_MASK                      0xFF000000
+
+/* NIC0_TXE0_WQE_FETCH_AXI_USER */
+#define NIC0_TXE0_WQE_FETCH_AXI_USER_R_SHIFT                         0
+#define NIC0_TXE0_WQE_FETCH_AXI_USER_R_MASK                          0xFFFFFFFF
+
+/* NIC0_TXE0_WQE_FETCH_AXI_PROT */
+#define NIC0_TXE0_WQE_FETCH_AXI_PROT_PRIVILEGE_SHIFT                 0
+#define NIC0_TXE0_WQE_FETCH_AXI_PROT_PRIVILEGE_MASK                  0x7
+#define NIC0_TXE0_WQE_FETCH_AXI_PROT_SECURED_SHIFT                   3
+#define NIC0_TXE0_WQE_FETCH_AXI_PROT_SECURED_MASK                    0x38
+#define NIC0_TXE0_WQE_FETCH_AXI_PROT_UNSECURED_SHIFT                 6
+#define NIC0_TXE0_WQE_FETCH_AXI_PROT_UNSECURED_MASK                  0x1C0
+
+/* NIC0_TXE0_DATA_FETCH_AXI_USER */
+#define NIC0_TXE0_DATA_FETCH_AXI_USER_R_SHIFT                        0
+#define NIC0_TXE0_DATA_FETCH_AXI_USER_R_MASK                         0xFFFFFFFF
+
+/* NIC0_TXE0_DATA_FETCH_AXI_PROT */
+#define NIC0_TXE0_DATA_FETCH_AXI_PROT_PRIVILEGE_SHIFT                0
+#define NIC0_TXE0_DATA_FETCH_AXI_PROT_PRIVILEGE_MASK                 0x7
+#define NIC0_TXE0_DATA_FETCH_AXI_PROT_SECURED_SHIFT                  3
+#define NIC0_TXE0_DATA_FETCH_AXI_PROT_SECURED_MASK                   0x38
+#define NIC0_TXE0_DATA_FETCH_AXI_PROT_UNSECURED_SHIFT                6
+#define NIC0_TXE0_DATA_FETCH_AXI_PROT_UNSECURED_MASK                 0x1C0
+
+/* NIC0_TXE0_FETCH_OUT_OF_TOKEN */
+#define NIC0_TXE0_FETCH_OUT_OF_TOKEN_R_SHIFT                         0
+#define NIC0_TXE0_FETCH_OUT_OF_TOKEN_R_MASK                          0x7
+
+/* NIC0_TXE0_ECN_COUNT_EN */
+#define NIC0_TXE0_ECN_COUNT_EN_R_SHIFT                               0
+#define NIC0_TXE0_ECN_COUNT_EN_R_MASK                                0x1
+
+/* NIC0_TXE0_INERRUPT_CAUSE */
+#define NIC0_TXE0_INERRUPT_CAUSE_R_SHIFT                             0
+#define NIC0_TXE0_INERRUPT_CAUSE_R_MASK                              0x7F
+
+/* NIC0_TXE0_INTERRUPT_MASK */
+#define NIC0_TXE0_INTERRUPT_MASK_R_SHIFT                             0
+#define NIC0_TXE0_INTERRUPT_MASK_R_MASK                              0x7F
+
+/* NIC0_TXE0_INTERRUPT_CLR */
+
+/* NIC0_TXE0_VLAN_TAG_QPN_OFFSET */
+#define NIC0_TXE0_VLAN_TAG_QPN_OFFSET_R_SHIFT                        0
+#define NIC0_TXE0_VLAN_TAG_QPN_OFFSET_R_MASK                         0x1F
+
+/* NIC0_TXE0_VALN_TAG_CFG */
+#define NIC0_TXE0_VALN_TAG_CFG_TPD_SHIFT                             0
+#define NIC0_TXE0_VALN_TAG_CFG_TPD_MASK                              0xFFFF
+#define NIC0_TXE0_VALN_TAG_CFG_VLAN_ID_SHIFT                         16
+#define NIC0_TXE0_VALN_TAG_CFG_VLAN_ID_MASK                          0xFFF0000
+#define NIC0_TXE0_VALN_TAG_CFG_DEI_SHIFT                             28
+#define NIC0_TXE0_VALN_TAG_CFG_DEI_MASK                              0x10000000
+#define NIC0_TXE0_VALN_TAG_CFG_ENABLE_SHIFT                          31
+#define NIC0_TXE0_VALN_TAG_CFG_ENABLE_MASK                           0x80000000
+
+/* NIC0_TXE0_DBG_TRIG */
+#define NIC0_TXE0_DBG_TRIG_R_SHIFT                                   0
+#define NIC0_TXE0_DBG_TRIG_R_MASK                                    0xF
+
+/* NIC0_TXE0_WQE_PREFETCH_CFG */
+#define NIC0_TXE0_WQE_PREFETCH_CFG_ENABLE_SHIFT                      0
+#define NIC0_TXE0_WQE_PREFETCH_CFG_ENABLE_MASK                       0x1
+#define NIC0_TXE0_WQE_PREFETCH_CFG_ALWAYS_ENABLE_SHIFT               1
+#define NIC0_TXE0_WQE_PREFETCH_CFG_ALWAYS_ENABLE_MASK                0x2
+
+/* NIC0_TXE0_WQE_PREFETCH_INVALIDATE */
+
+/* NIC0_TXE0_SWAP_MEMORY_ENDIANNESS */
+#define NIC0_TXE0_SWAP_MEMORY_ENDIANNESS_RAW_SHIFT                   0
+#define NIC0_TXE0_SWAP_MEMORY_ENDIANNESS_RAW_MASK                    0x1
+#define NIC0_TXE0_SWAP_MEMORY_ENDIANNESS_RDMA_SHIFT                  1
+#define NIC0_TXE0_SWAP_MEMORY_ENDIANNESS_RDMA_MASK                   0x2
+
+/* NIC0_TXE0_WQE_FETCH_SLICE_47_32 */
+#define NIC0_TXE0_WQE_FETCH_SLICE_47_32_R_SHIFT                      0
+#define NIC0_TXE0_WQE_FETCH_SLICE_47_32_R_MASK                       0xFFFF
+
+/* NIC0_TXE0_WQE_FETCH_SLICE_31_0 */
+#define NIC0_TXE0_WQE_FETCH_SLICE_31_0_R_SHIFT                       0
+#define NIC0_TXE0_WQE_FETCH_SLICE_31_0_R_MASK                        0xFFFFFFFF
+
+/* NIC0_TXE0_WQE_EXE_SLICE_47_32 */
+#define NIC0_TXE0_WQE_EXE_SLICE_47_32_R_SHIFT                        0
+#define NIC0_TXE0_WQE_EXE_SLICE_47_32_R_MASK                         0xFFFF
+
+/* NIC0_TXE0_WQE_EXE_SLICE_31_0 */
+#define NIC0_TXE0_WQE_EXE_SLICE_31_0_R_SHIFT                         0
+#define NIC0_TXE0_WQE_EXE_SLICE_31_0_R_MASK                          0xFFFFFFFF
+
+/* NIC0_TXE0_DBG_COUNT_SELECT */
+#define NIC0_TXE0_DBG_COUNT_SELECT_R_SHIFT                           0
+#define NIC0_TXE0_DBG_COUNT_SELECT_R_MASK                            0x1F
+
+/* NIC0_TXE0_BTH_MKEY */
+#define NIC0_TXE0_BTH_MKEY_R_SHIFT                                   0
+#define NIC0_TXE0_BTH_MKEY_R_MASK                                    0xFFFF
+
+/* NIC0_TXE0_WQE_BUFF_FLUSH_SLICE_47_3 */
+#define NIC0_TXE0_WQE_BUFF_FLUSH_SLICE_47_3_R_SHIFT                  0
+#define NIC0_TXE0_WQE_BUFF_FLUSH_SLICE_47_3_R_MASK                   0xFFFF
+
+/* NIC0_TXE0_WQE_BUFF_FLUSH_SLICE_31_0 */
+#define NIC0_TXE0_WQE_BUFF_FLUSH_SLICE_31_0_R_SHIFT                  0
+#define NIC0_TXE0_WQE_BUFF_FLUSH_SLICE_31_0_R_MASK                   0xFFFFFFFF
+
+/* NIC0_TXE0_INTERRUPT_INDEX_MASK_RING */
+#define NIC0_TXE0_INTERRUPT_INDEX_MASK_RING_R_SHIFT                  0
+#define NIC0_TXE0_INTERRUPT_INDEX_MASK_RING_R_MASK                   0x3FFFFF
+
+/* NIC0_TXE0_QPN_RING */
+#define NIC0_TXE0_QPN_RING_R_SHIFT                                   0
+#define NIC0_TXE0_QPN_RING_R_MASK                                    0xFFFFFF
+
+/* NIC0_TXE0_INTERRUPT_EACH_PACKET */
+#define NIC0_TXE0_INTERRUPT_EACH_PACKET_R_SHIFT                      0
+#define NIC0_TXE0_INTERRUPT_EACH_PACKET_R_MASK                       0x1F
+
+/* NIC0_TXE0_EXECUTIN_INDEX_RING */
+#define NIC0_TXE0_EXECUTIN_INDEX_RING_R_SHIFT                        0
+#define NIC0_TXE0_EXECUTIN_INDEX_RING_R_MASK                         0x3FFFFF
+
+#endif /* ASIC_REG_NIC0_TXE0_MASKS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
new file mode 100644
index 000000000000..115d473471d5
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
@@ -0,0 +1,264 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_TXE0_REGS_H_
+#define ASIC_REG_NIC0_TXE0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_TXE0 (Prototype: NIC_TXE)
+ *****************************************
+ */
+
+#define mmNIC0_TXE0_WQE_FETCH_REQ_MASK_31_0                          0xCF2000
+
+#define mmNIC0_TXE0_WQE_FETCH_REQ_MASK_47_32                         0xCF2004
+
+#define mmNIC0_TXE0_LOCAL_WQ_BUFFER_SIZE                             0xCF2008
+
+#define mmNIC0_TXE0_LOCAL_WQ_LINE_SIZE                               0xCF200C
+
+#define mmNIC0_TXE0_LOG_MAX_WQ_SIZE_0                                0xCF2010
+
+#define mmNIC0_TXE0_LOG_MAX_WQ_SIZE_1                                0xCF2014
+
+#define mmNIC0_TXE0_LOG_MAX_WQ_SIZE_2                                0xCF2018
+
+#define mmNIC0_TXE0_LOG_MAX_WQ_SIZE_3                                0xCF201C
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_49_32_0                          0xCF2020
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_49_32_1                          0xCF2024
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_49_32_2                          0xCF2028
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_49_32_3                          0xCF202C
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_31_0_0                           0xCF2030
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_31_0_1                           0xCF2034
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_31_0_2                           0xCF2038
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_31_0_3                           0xCF203C
+
+#define mmNIC0_TXE0_SQ_BASE_ADDRESS_SEL                              0xCF2040
+
+#define mmNIC0_TXE0_ALLOC_CREDIT                                     0xCF2044
+
+#define mmNIC0_TXE0_ALLOC_CREDIT_FORCE_FULL                          0xCF2048
+
+#define mmNIC0_TXE0_READ_CREDIT                                      0xCF204C
+
+#define mmNIC0_TXE0_READ_CREDIT_FORCE_FULL                           0xCF2050
+
+#define mmNIC0_TXE0_BURST_ENABLE                                     0xCF2054
+
+#define mmNIC0_TXE0_WR_INIT_BUSY                                     0xCF2058
+
+#define mmNIC0_TXE0_READ_RES_WT_INIT_BUSY                            0xCF205C
+
+#define mmNIC0_TXE0_BTH_TVER                                         0xCF2060
+
+#define mmNIC0_TXE0_IPV4_IDENTIFICATION                              0xCF2064
+
+#define mmNIC0_TXE0_IPV4_FLAGS                                       0xCF2068
+
+#define mmNIC0_TXE0_PAD                                              0xCF206C
+
+#define mmNIC0_TXE0_ADD_PAD_TO_IPV4_LEN                              0xCF2070
+
+#define mmNIC0_TXE0_ADD_PAD_TO_UDP_LEN                               0xCF2074
+
+#define mmNIC0_TXE0_ICRC_EN                                          0xCF2078
+
+#define mmNIC0_TXE0_UDP_MASK_S_PORT                                  0xCF207C
+
+#define mmNIC0_TXE0_UDP_CHECKSUM                                     0xCF2080
+
+#define mmNIC0_TXE0_UDP_DEST_PORT                                    0xCF2084
+
+#define mmNIC0_TXE0_PORT0_MAC_CFG_47_32                              0xCF2088
+
+#define mmNIC0_TXE0_PORT0_MAC_CFG_31_0                               0xCF208C
+
+#define mmNIC0_TXE0_PORT1_MAC_CFG_47_32                              0xCF2090
+
+#define mmNIC0_TXE0_PORT1_MAC_CFG_31_0                               0xCF2094
+
+#define mmNIC0_TXE0_PRIO_TO_DSCP_0                                   0xCF209C
+
+#define mmNIC0_TXE0_PRIO_TO_DSCP_1                                   0xCF20A0
+
+#define mmNIC0_TXE0_PRIO_TO_PCP                                      0xCF20B0
+
+#define mmNIC0_TXE0_MAC_ETHER_TYPE                                   0xCF20B4
+
+#define mmNIC0_TXE0_MAC_ETHER_TYPE_VLAN                              0xCF20B8
+
+#define mmNIC0_TXE0_ECN_0                                            0xCF20BC
+
+#define mmNIC0_TXE0_ECN_1                                            0xCF20C0
+
+#define mmNIC0_TXE0_IPV4_TIME_TO_LIVE_0                              0xCF20C4
+
+#define mmNIC0_TXE0_IPV4_TIME_TO_LIVE_1                              0xCF20C8
+
+#define mmNIC0_TXE0_PRIO_PORT_CREDIT_FORCE                           0xCF20CC
+
+#define mmNIC0_TXE0_PRIO_PORT_CRDIT_0                                0xCF20D0
+
+#define mmNIC0_TXE0_PRIO_PORT_CRDIT_1                                0xCF20D4
+
+#define mmNIC0_TXE0_PRIO_PORT_CRDIT_2                                0xCF20D8
+
+#define mmNIC0_TXE0_PRIO_PORT_CRDIT_3                                0xCF20DC
+
+#define mmNIC0_TXE0_PRIO_PORT_CRDIT_4                                0xCF20E0
+
+#define mmNIC0_TXE0_PRIO_PORT_CRDIT_5                                0xCF20E4
+
+#define mmNIC0_TXE0_PRIO_PORT_CRDIT_6                                0xCF20E8
+
+#define mmNIC0_TXE0_PRIO_PORT_CRDIT_7                                0xCF20EC
+
+#define mmNIC0_TXE0_WQE_FETCH_TOKEN_EN                               0xCF20F0
+
+#define mmNIC0_TXE0_NACK_SYNDROME                                    0xCF20F4
+
+#define mmNIC0_TXE0_WQE_FETCH_AXI_USER                               0xCF20F8
+
+#define mmNIC0_TXE0_WQE_FETCH_AXI_PROT                               0xCF20FC
+
+#define mmNIC0_TXE0_DATA_FETCH_AXI_USER                              0xCF2100
+
+#define mmNIC0_TXE0_DATA_FETCH_AXI_PROT                              0xCF2104
+
+#define mmNIC0_TXE0_FETCH_OUT_OF_TOKEN                               0xCF2108
+
+#define mmNIC0_TXE0_ECN_COUNT_EN                                     0xCF210C
+
+#define mmNIC0_TXE0_INERRUPT_CAUSE                                   0xCF2110
+
+#define mmNIC0_TXE0_INTERRUPT_MASK                                   0xCF2114
+
+#define mmNIC0_TXE0_INTERRUPT_CLR                                    0xCF2118
+
+#define mmNIC0_TXE0_VLAN_TAG_QPN_OFFSET                              0xCF211C
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_0                                   0xCF2120
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_1                                   0xCF2124
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_2                                   0xCF2128
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_3                                   0xCF212C
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_4                                   0xCF2130
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_5                                   0xCF2134
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_6                                   0xCF2138
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_7                                   0xCF213C
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_8                                   0xCF2140
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_9                                   0xCF2144
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_10                                  0xCF2148
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_11                                  0xCF214C
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_12                                  0xCF2150
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_13                                  0xCF2154
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_14                                  0xCF2158
+
+#define mmNIC0_TXE0_VALN_TAG_CFG_15                                  0xCF215C
+
+#define mmNIC0_TXE0_DBG_TRIG                                         0xCF2160
+
+#define mmNIC0_TXE0_WQE_PREFETCH_CFG                                 0xCF2164
+
+#define mmNIC0_TXE0_WQE_PREFETCH_INVALIDATE                          0xCF2168
+
+#define mmNIC0_TXE0_SWAP_MEMORY_ENDIANNESS                           0xCF216C
+
+#define mmNIC0_TXE0_WQE_FETCH_SLICE_47_32                            0xCF2170
+
+#define mmNIC0_TXE0_WQE_FETCH_SLICE_31_0                             0xCF2174
+
+#define mmNIC0_TXE0_WQE_EXE_SLICE_47_32                              0xCF2178
+
+#define mmNIC0_TXE0_WQE_EXE_SLICE_31_0                               0xCF217C
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_0                               0xCF2180
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_1                               0xCF2184
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_2                               0xCF2188
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_3                               0xCF218C
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_4                               0xCF2190
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_5                               0xCF2194
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_6                               0xCF2198
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_7                               0xCF219C
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_8                               0xCF21A0
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_9                               0xCF21A4
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_10                              0xCF21A8
+
+#define mmNIC0_TXE0_DBG_COUNT_SELECT_11                              0xCF21AC
+
+#define mmNIC0_TXE0_BTH_MKEY                                         0xCF21B0
+
+#define mmNIC0_TXE0_WQE_BUFF_FLUSH_SLICE_47_3                        0xCF21B4
+
+#define mmNIC0_TXE0_WQE_BUFF_FLUSH_SLICE_31_0                        0xCF21B8
+
+#define mmNIC0_TXE0_INTERRUPT_INDEX_MASK_RING_0                      0xCF21BC
+
+#define mmNIC0_TXE0_INTERRUPT_INDEX_MASK_RING_1                      0xCF21C0
+
+#define mmNIC0_TXE0_INTERRUPT_INDEX_MASK_RING_2                      0xCF21C4
+
+#define mmNIC0_TXE0_INTERRUPT_INDEX_MASK_RING_3                      0xCF21C8
+
+#define mmNIC0_TXE0_INTERRUPT_INDEX_MASK_RING_4                      0xCF21CC
+
+#define mmNIC0_TXE0_QPN_RING_0                                       0xCF21D0
+
+#define mmNIC0_TXE0_QPN_RING_1                                       0xCF21D4
+
+#define mmNIC0_TXE0_QPN_RING_2                                       0xCF21D8
+
+#define mmNIC0_TXE0_QPN_RING_3                                       0xCF21DC
+
+#define mmNIC0_TXE0_INTERRUPT_EACH_PACKET                            0xCF21F0
+
+#define mmNIC0_TXE0_EXECUTIN_INDEX_RING_0                            0xCF21F4
+
+#define mmNIC0_TXE0_EXECUTIN_INDEX_RING_1                            0xCF21F8
+
+#define mmNIC0_TXE0_EXECUTIN_INDEX_RING_2                            0xCF21FC
+
+#define mmNIC0_TXE0_EXECUTIN_INDEX_RING_3                            0xCF2200
+
+#endif /* ASIC_REG_NIC0_TXE0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
new file mode 100644
index 000000000000..1c2d45f3afe3
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
@@ -0,0 +1,264 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_TXE1_REGS_H_
+#define ASIC_REG_NIC0_TXE1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_TXE1 (Prototype: NIC_TXE)
+ *****************************************
+ */
+
+#define mmNIC0_TXE1_WQE_FETCH_REQ_MASK_31_0                          0xCF3000
+
+#define mmNIC0_TXE1_WQE_FETCH_REQ_MASK_47_32                         0xCF3004
+
+#define mmNIC0_TXE1_LOCAL_WQ_BUFFER_SIZE                             0xCF3008
+
+#define mmNIC0_TXE1_LOCAL_WQ_LINE_SIZE                               0xCF300C
+
+#define mmNIC0_TXE1_LOG_MAX_WQ_SIZE_0                                0xCF3010
+
+#define mmNIC0_TXE1_LOG_MAX_WQ_SIZE_1                                0xCF3014
+
+#define mmNIC0_TXE1_LOG_MAX_WQ_SIZE_2                                0xCF3018
+
+#define mmNIC0_TXE1_LOG_MAX_WQ_SIZE_3                                0xCF301C
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_49_32_0                          0xCF3020
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_49_32_1                          0xCF3024
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_49_32_2                          0xCF3028
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_49_32_3                          0xCF302C
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_31_0_0                           0xCF3030
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_31_0_1                           0xCF3034
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_31_0_2                           0xCF3038
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_31_0_3                           0xCF303C
+
+#define mmNIC0_TXE1_SQ_BASE_ADDRESS_SEL                              0xCF3040
+
+#define mmNIC0_TXE1_ALLOC_CREDIT                                     0xCF3044
+
+#define mmNIC0_TXE1_ALLOC_CREDIT_FORCE_FULL                          0xCF3048
+
+#define mmNIC0_TXE1_READ_CREDIT                                      0xCF304C
+
+#define mmNIC0_TXE1_READ_CREDIT_FORCE_FULL                           0xCF3050
+
+#define mmNIC0_TXE1_BURST_ENABLE                                     0xCF3054
+
+#define mmNIC0_TXE1_WR_INIT_BUSY                                     0xCF3058
+
+#define mmNIC0_TXE1_READ_RES_WT_INIT_BUSY                            0xCF305C
+
+#define mmNIC0_TXE1_BTH_TVER                                         0xCF3060
+
+#define mmNIC0_TXE1_IPV4_IDENTIFICATION                              0xCF3064
+
+#define mmNIC0_TXE1_IPV4_FLAGS                                       0xCF3068
+
+#define mmNIC0_TXE1_PAD                                              0xCF306C
+
+#define mmNIC0_TXE1_ADD_PAD_TO_IPV4_LEN                              0xCF3070
+
+#define mmNIC0_TXE1_ADD_PAD_TO_UDP_LEN                               0xCF3074
+
+#define mmNIC0_TXE1_ICRC_EN                                          0xCF3078
+
+#define mmNIC0_TXE1_UDP_MASK_S_PORT                                  0xCF307C
+
+#define mmNIC0_TXE1_UDP_CHECKSUM                                     0xCF3080
+
+#define mmNIC0_TXE1_UDP_DEST_PORT                                    0xCF3084
+
+#define mmNIC0_TXE1_PORT0_MAC_CFG_47_32                              0xCF3088
+
+#define mmNIC0_TXE1_PORT0_MAC_CFG_31_0                               0xCF308C
+
+#define mmNIC0_TXE1_PORT1_MAC_CFG_47_32                              0xCF3090
+
+#define mmNIC0_TXE1_PORT1_MAC_CFG_31_0                               0xCF3094
+
+#define mmNIC0_TXE1_PRIO_TO_DSCP_0                                   0xCF309C
+
+#define mmNIC0_TXE1_PRIO_TO_DSCP_1                                   0xCF30A0
+
+#define mmNIC0_TXE1_PRIO_TO_PCP                                      0xCF30B0
+
+#define mmNIC0_TXE1_MAC_ETHER_TYPE                                   0xCF30B4
+
+#define mmNIC0_TXE1_MAC_ETHER_TYPE_VLAN                              0xCF30B8
+
+#define mmNIC0_TXE1_ECN_0                                            0xCF30BC
+
+#define mmNIC0_TXE1_ECN_1                                            0xCF30C0
+
+#define mmNIC0_TXE1_IPV4_TIME_TO_LIVE_0                              0xCF30C4
+
+#define mmNIC0_TXE1_IPV4_TIME_TO_LIVE_1                              0xCF30C8
+
+#define mmNIC0_TXE1_PRIO_PORT_CREDIT_FORCE                           0xCF30CC
+
+#define mmNIC0_TXE1_PRIO_PORT_CRDIT_0                                0xCF30D0
+
+#define mmNIC0_TXE1_PRIO_PORT_CRDIT_1                                0xCF30D4
+
+#define mmNIC0_TXE1_PRIO_PORT_CRDIT_2                                0xCF30D8
+
+#define mmNIC0_TXE1_PRIO_PORT_CRDIT_3                                0xCF30DC
+
+#define mmNIC0_TXE1_PRIO_PORT_CRDIT_4                                0xCF30E0
+
+#define mmNIC0_TXE1_PRIO_PORT_CRDIT_5                                0xCF30E4
+
+#define mmNIC0_TXE1_PRIO_PORT_CRDIT_6                                0xCF30E8
+
+#define mmNIC0_TXE1_PRIO_PORT_CRDIT_7                                0xCF30EC
+
+#define mmNIC0_TXE1_WQE_FETCH_TOKEN_EN                               0xCF30F0
+
+#define mmNIC0_TXE1_NACK_SYNDROME                                    0xCF30F4
+
+#define mmNIC0_TXE1_WQE_FETCH_AXI_USER                               0xCF30F8
+
+#define mmNIC0_TXE1_WQE_FETCH_AXI_PROT                               0xCF30FC
+
+#define mmNIC0_TXE1_DATA_FETCH_AXI_USER                              0xCF3100
+
+#define mmNIC0_TXE1_DATA_FETCH_AXI_PROT                              0xCF3104
+
+#define mmNIC0_TXE1_FETCH_OUT_OF_TOKEN                               0xCF3108
+
+#define mmNIC0_TXE1_ECN_COUNT_EN                                     0xCF310C
+
+#define mmNIC0_TXE1_INERRUPT_CAUSE                                   0xCF3110
+
+#define mmNIC0_TXE1_INTERRUPT_MASK                                   0xCF3114
+
+#define mmNIC0_TXE1_INTERRUPT_CLR                                    0xCF3118
+
+#define mmNIC0_TXE1_VLAN_TAG_QPN_OFFSET                              0xCF311C
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_0                                   0xCF3120
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_1                                   0xCF3124
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_2                                   0xCF3128
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_3                                   0xCF312C
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_4                                   0xCF3130
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_5                                   0xCF3134
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_6                                   0xCF3138
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_7                                   0xCF313C
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_8                                   0xCF3140
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_9                                   0xCF3144
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_10                                  0xCF3148
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_11                                  0xCF314C
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_12                                  0xCF3150
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_13                                  0xCF3154
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_14                                  0xCF3158
+
+#define mmNIC0_TXE1_VALN_TAG_CFG_15                                  0xCF315C
+
+#define mmNIC0_TXE1_DBG_TRIG                                         0xCF3160
+
+#define mmNIC0_TXE1_WQE_PREFETCH_CFG                                 0xCF3164
+
+#define mmNIC0_TXE1_WQE_PREFETCH_INVALIDATE                          0xCF3168
+
+#define mmNIC0_TXE1_SWAP_MEMORY_ENDIANNESS                           0xCF316C
+
+#define mmNIC0_TXE1_WQE_FETCH_SLICE_47_32                            0xCF3170
+
+#define mmNIC0_TXE1_WQE_FETCH_SLICE_31_0                             0xCF3174
+
+#define mmNIC0_TXE1_WQE_EXE_SLICE_47_32                              0xCF3178
+
+#define mmNIC0_TXE1_WQE_EXE_SLICE_31_0                               0xCF317C
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_0                               0xCF3180
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_1                               0xCF3184
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_2                               0xCF3188
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_3                               0xCF318C
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_4                               0xCF3190
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_5                               0xCF3194
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_6                               0xCF3198
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_7                               0xCF319C
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_8                               0xCF31A0
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_9                               0xCF31A4
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_10                              0xCF31A8
+
+#define mmNIC0_TXE1_DBG_COUNT_SELECT_11                              0xCF31AC
+
+#define mmNIC0_TXE1_BTH_MKEY                                         0xCF31B0
+
+#define mmNIC0_TXE1_WQE_BUFF_FLUSH_SLICE_47_3                        0xCF31B4
+
+#define mmNIC0_TXE1_WQE_BUFF_FLUSH_SLICE_31_0                        0xCF31B8
+
+#define mmNIC0_TXE1_INTERRUPT_INDEX_MASK_RING_0                      0xCF31BC
+
+#define mmNIC0_TXE1_INTERRUPT_INDEX_MASK_RING_1                      0xCF31C0
+
+#define mmNIC0_TXE1_INTERRUPT_INDEX_MASK_RING_2                      0xCF31C4
+
+#define mmNIC0_TXE1_INTERRUPT_INDEX_MASK_RING_3                      0xCF31C8
+
+#define mmNIC0_TXE1_INTERRUPT_INDEX_MASK_RING_4                      0xCF31CC
+
+#define mmNIC0_TXE1_QPN_RING_0                                       0xCF31D0
+
+#define mmNIC0_TXE1_QPN_RING_1                                       0xCF31D4
+
+#define mmNIC0_TXE1_QPN_RING_2                                       0xCF31D8
+
+#define mmNIC0_TXE1_QPN_RING_3                                       0xCF31DC
+
+#define mmNIC0_TXE1_INTERRUPT_EACH_PACKET                            0xCF31F0
+
+#define mmNIC0_TXE1_EXECUTIN_INDEX_RING_0                            0xCF31F4
+
+#define mmNIC0_TXE1_EXECUTIN_INDEX_RING_1                            0xCF31F8
+
+#define mmNIC0_TXE1_EXECUTIN_INDEX_RING_2                            0xCF31FC
+
+#define mmNIC0_TXE1_EXECUTIN_INDEX_RING_3                            0xCF3200
+
+#endif /* ASIC_REG_NIC0_TXE1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
new file mode 100644
index 000000000000..457e44ed67df
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
@@ -0,0 +1,336 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_TXS0_MASKS_H_
+#define ASIC_REG_NIC0_TXS0_MASKS_H_
+
+/*
+ *****************************************
+ *   NIC0_TXS0 (Prototype: NIC_TXS)
+ *****************************************
+ */
+
+/* NIC0_TXS0_TMR_SCAN_EN */
+#define NIC0_TXS0_TMR_SCAN_EN_R_SHIFT                                0
+#define NIC0_TXS0_TMR_SCAN_EN_R_MASK                                 0x1
+
+/* NIC0_TXS0_TICK_WRAP */
+#define NIC0_TXS0_TICK_WRAP_R_SHIFT                                  0
+#define NIC0_TXS0_TICK_WRAP_R_MASK                                   0xFFFF
+
+/* NIC0_TXS0_SCAN_TIME_COMPARE_0 */
+#define NIC0_TXS0_SCAN_TIME_COMPARE_0_R_SHIFT                        0
+#define NIC0_TXS0_SCAN_TIME_COMPARE_0_R_MASK                         0xFFFFFFFF
+
+/* NIC0_TXS0_SCAN_TIME_COMPARE_1 */
+#define NIC0_TXS0_SCAN_TIME_COMPARE_1_R_SHIFT                        0
+#define NIC0_TXS0_SCAN_TIME_COMPARE_1_R_MASK                         0xFFFF
+
+/* NIC0_TXS0_SLICE_CREDIT */
+#define NIC0_TXS0_SLICE_CREDIT_R_SHIFT                               0
+#define NIC0_TXS0_SLICE_CREDIT_R_MASK                                0x3F
+
+/* NIC0_TXS0_SLICE_FORCE_FULL */
+#define NIC0_TXS0_SLICE_FORCE_FULL_R_SHIFT                           0
+#define NIC0_TXS0_SLICE_FORCE_FULL_R_MASK                            0x1
+
+/* NIC0_TXS0_FIRST_SCHEDQ_ID */
+#define NIC0_TXS0_FIRST_SCHEDQ_ID_R0_SHIFT                           0
+#define NIC0_TXS0_FIRST_SCHEDQ_ID_R0_MASK                            0xFF
+#define NIC0_TXS0_FIRST_SCHEDQ_ID_R1_SHIFT                           8
+#define NIC0_TXS0_FIRST_SCHEDQ_ID_R1_MASK                            0xFF00
+#define NIC0_TXS0_FIRST_SCHEDQ_ID_R2_SHIFT                           16
+#define NIC0_TXS0_FIRST_SCHEDQ_ID_R2_MASK                            0xFF0000
+#define NIC0_TXS0_FIRST_SCHEDQ_ID_R3_SHIFT                           24
+#define NIC0_TXS0_FIRST_SCHEDQ_ID_R3_MASK                            0xFF000000
+
+/* NIC0_TXS0_LAST_SCHEDQ_ID */
+#define NIC0_TXS0_LAST_SCHEDQ_ID_R0_SHIFT                            0
+#define NIC0_TXS0_LAST_SCHEDQ_ID_R0_MASK                             0xFF
+#define NIC0_TXS0_LAST_SCHEDQ_ID_R1_SHIFT                            8
+#define NIC0_TXS0_LAST_SCHEDQ_ID_R1_MASK                             0xFF00
+#define NIC0_TXS0_LAST_SCHEDQ_ID_R2_SHIFT                            16
+#define NIC0_TXS0_LAST_SCHEDQ_ID_R2_MASK                             0xFF0000
+#define NIC0_TXS0_LAST_SCHEDQ_ID_R3_SHIFT                            24
+#define NIC0_TXS0_LAST_SCHEDQ_ID_R3_MASK                             0xFF000000
+
+/* NIC0_TXS0_PUSH_MASK */
+#define NIC0_TXS0_PUSH_MASK_R_SHIFT                                  0
+#define NIC0_TXS0_PUSH_MASK_R_MASK                                   0x1
+
+/* NIC0_TXS0_POP_MASK */
+#define NIC0_TXS0_POP_MASK_R_SHIFT                                   0
+#define NIC0_TXS0_POP_MASK_R_MASK                                    0x1
+
+/* NIC0_TXS0_PUSH_RELEASE_INVALIDATE */
+#define NIC0_TXS0_PUSH_RELEASE_INVALIDATE_R_SHIFT                    0
+#define NIC0_TXS0_PUSH_RELEASE_INVALIDATE_R_MASK                     0x1
+
+/* NIC0_TXS0_POP_RELEASE_INVALIDATE */
+#define NIC0_TXS0_POP_RELEASE_INVALIDATE_R_SHIFT                     0
+#define NIC0_TXS0_POP_RELEASE_INVALIDATE_R_MASK                      0x1
+
+/* NIC0_TXS0_LIST_MEM_READ_MASK */
+#define NIC0_TXS0_LIST_MEM_READ_MASK_R_SHIFT                         0
+#define NIC0_TXS0_LIST_MEM_READ_MASK_R_MASK                          0x1
+
+/* NIC0_TXS0_FIFO_MEM_READ_MASK */
+#define NIC0_TXS0_FIFO_MEM_READ_MASK_R_SHIFT                         0
+#define NIC0_TXS0_FIFO_MEM_READ_MASK_R_MASK                          0x1
+
+/* NIC0_TXS0_LIST_MEM_WRITE_MASK */
+#define NIC0_TXS0_LIST_MEM_WRITE_MASK_R_SHIFT                        0
+#define NIC0_TXS0_LIST_MEM_WRITE_MASK_R_MASK                         0x1
+
+/* NIC0_TXS0_FIFO_MEM_WRITE_MASK */
+#define NIC0_TXS0_FIFO_MEM_WRITE_MASK_R_SHIFT                        0
+#define NIC0_TXS0_FIFO_MEM_WRITE_MASK_R_MASK                         0x1
+
+/* NIC0_TXS0_BASE_ADDRESS_49_18 */
+#define NIC0_TXS0_BASE_ADDRESS_49_18_R_SHIFT                         0
+#define NIC0_TXS0_BASE_ADDRESS_49_18_R_MASK                          0xFFFFFFFF
+
+/* NIC0_TXS0_BASE_ADDRESS_17_7 */
+#define NIC0_TXS0_BASE_ADDRESS_17_7_R_SHIFT                          0
+#define NIC0_TXS0_BASE_ADDRESS_17_7_R_MASK                           0x7FF
+
+/* NIC0_TXS0_AXI_USER */
+#define NIC0_TXS0_AXI_USER_R_SHIFT                                   0
+#define NIC0_TXS0_AXI_USER_R_MASK                                    0xFFFFFFFF
+
+/* NIC0_TXS0_AXI_PROT */
+#define NIC0_TXS0_AXI_PROT_R_SHIFT                                   0
+#define NIC0_TXS0_AXI_PROT_R_MASK                                    0x7
+
+/* NIC0_TXS0_RATE_LIMIT */
+#define NIC0_TXS0_RATE_LIMIT_ALWAYS_EN_SHIFT                         0
+#define NIC0_TXS0_RATE_LIMIT_ALWAYS_EN_MASK                          0x1
+#define NIC0_TXS0_RATE_LIMIT_IMMEDIATE_SET_SHIFT                     1
+#define NIC0_TXS0_RATE_LIMIT_IMMEDIATE_SET_MASK                      0x2
+
+/* NIC0_TXS0_CACHE_CFG */
+#define NIC0_TXS0_CACHE_CFG_LIST_PLRU_EVICTION_SHIFT                 0
+#define NIC0_TXS0_CACHE_CFG_LIST_PLRU_EVICTION_MASK                  0x1
+#define NIC0_TXS0_CACHE_CFG_LIST_CACHE_STOP_SHIFT                    1
+#define NIC0_TXS0_CACHE_CFG_LIST_CACHE_STOP_MASK                     0x2
+#define NIC0_TXS0_CACHE_CFG_LIST_INV_WRITEBACK_SHIFT                 2
+#define NIC0_TXS0_CACHE_CFG_LIST_INV_WRITEBACK_MASK                  0x4
+#define NIC0_TXS0_CACHE_CFG_FREE_LIST_PLRU_EVICTION_SHIFT            3
+#define NIC0_TXS0_CACHE_CFG_FREE_LIST_PLRU_EVICTION_MASK             0x8
+#define NIC0_TXS0_CACHE_CFG_FREE_LIST_CACHE_STOP_SHIFT               4
+#define NIC0_TXS0_CACHE_CFG_FREE_LIST_CACHE_STOP_MASK                0x10
+#define NIC0_TXS0_CACHE_CFG_FREE_LIST_INV_WRITEBACK_SHIFT            5
+#define NIC0_TXS0_CACHE_CFG_FREE_LIST_INV_WRITEBACK_MASK             0x20
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_EN */
+#define NIC0_TXS0_SCHEDQ_UPDATE_EN_R_SHIFT                           0
+#define NIC0_TXS0_SCHEDQ_UPDATE_EN_R_MASK                            0x1
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_FIFO */
+#define NIC0_TXS0_SCHEDQ_UPDATE_FIFO_R_SHIFT                         0
+#define NIC0_TXS0_SCHEDQ_UPDATE_FIFO_R_MASK                          0xFF
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_DESC_31_0 */
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_31_0_R_SHIFT                    0
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_31_0_R_MASK                     0xFFFFFFFF
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_DESC_63_32 */
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_63_32_R_SHIFT                   0
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_63_32_R_MASK                    0xFFFFFFFF
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_DESC_95_64 */
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_95_64_R_SHIFT                   0
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_95_64_R_MASK                    0xFFFFFFFF
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_DESC_127_96 */
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_127_96_R_SHIFT                  0
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_127_96_R_MASK                   0xFFFFFFFF
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_DESC_159_128 */
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_159_128_R_SHIFT                 0
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_159_128_R_MASK                  0xFFFFFFFF
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_DESC_191_160 */
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_191_160_R_SHIFT                 0
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_191_160_R_MASK                  0xFFFFFFFF
+
+/* NIC0_TXS0_SCHEDQ_UPDATE_DESC_217_192 */
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_217_192_R_SHIFT                 0
+#define NIC0_TXS0_SCHEDQ_UPDATE_DESC_217_192_R_MASK                  0x1FFFFFF
+
+/* NIC0_TXS0_FORCE_HIT_EN */
+#define NIC0_TXS0_FORCE_HIT_EN_R_SHIFT                               0
+#define NIC0_TXS0_FORCE_HIT_EN_R_MASK                                0x1
+
+/* NIC0_TXS0_INVALIDATE_LIST */
+
+/* NIC0_TXS0_INVALIDATE_LIST_STATUS */
+#define NIC0_TXS0_INVALIDATE_LIST_STATUS_INVALIDATE_DONE_SHIFT       0
+#define NIC0_TXS0_INVALIDATE_LIST_STATUS_INVALIDATE_DONE_MASK        0x1
+#define NIC0_TXS0_INVALIDATE_LIST_STATUS_CACHE_IDLE_SHIFT            1
+#define NIC0_TXS0_INVALIDATE_LIST_STATUS_CACHE_IDLE_MASK             0x2
+
+/* NIC0_TXS0_INVALIDATE_FREE_LIST */
+
+/* NIC0_TXS0_INVALIDATE_FREE_LIST_STAT */
+#define NIC0_TXS0_INVALIDATE_FREE_LIST_STAT_INVALIDATE_DONE_SHIFT    0
+#define NIC0_TXS0_INVALIDATE_FREE_LIST_STAT_INVALIDATE_DONE_MASK     0x1
+#define NIC0_TXS0_INVALIDATE_FREE_LIST_STAT_CACHE_IDLE_SHIFT         1
+#define NIC0_TXS0_INVALIDATE_FREE_LIST_STAT_CACHE_IDLE_MASK          0x2
+
+/* NIC0_TXS0_PUSH_PREFETCH_EN */
+#define NIC0_TXS0_PUSH_PREFETCH_EN_R_SHIFT                           0
+#define NIC0_TXS0_PUSH_PREFETCH_EN_R_MASK                            0x1
+
+/* NIC0_TXS0_PUSH_RELEASE_EN */
+#define NIC0_TXS0_PUSH_RELEASE_EN_R_SHIFT                            0
+#define NIC0_TXS0_PUSH_RELEASE_EN_R_MASK                             0x1
+
+/* NIC0_TXS0_PUSH_LOCK_EN */
+#define NIC0_TXS0_PUSH_LOCK_EN_R_SHIFT                               0
+#define NIC0_TXS0_PUSH_LOCK_EN_R_MASK                                0x1
+
+/* NIC0_TXS0_PUSH_PREFETCH_NEXT_EN */
+#define NIC0_TXS0_PUSH_PREFETCH_NEXT_EN_R_SHIFT                      0
+#define NIC0_TXS0_PUSH_PREFETCH_NEXT_EN_R_MASK                       0x1
+
+/* NIC0_TXS0_POP_PREFETCH_EN */
+#define NIC0_TXS0_POP_PREFETCH_EN_R_SHIFT                            0
+#define NIC0_TXS0_POP_PREFETCH_EN_R_MASK                             0x1
+
+/* NIC0_TXS0_POP_RELEASE_EN */
+#define NIC0_TXS0_POP_RELEASE_EN_R_SHIFT                             0
+#define NIC0_TXS0_POP_RELEASE_EN_R_MASK                              0x1
+
+/* NIC0_TXS0_POP_LOCK_EN */
+#define NIC0_TXS0_POP_LOCK_EN_R_SHIFT                                0
+#define NIC0_TXS0_POP_LOCK_EN_R_MASK                                 0x1
+
+/* NIC0_TXS0_POP_PREFETCH_NEXT_EN */
+#define NIC0_TXS0_POP_PREFETCH_NEXT_EN_R_SHIFT                       0
+#define NIC0_TXS0_POP_PREFETCH_NEXT_EN_R_MASK                        0x1
+
+/* NIC0_TXS0_LIST_MASK */
+#define NIC0_TXS0_LIST_MASK_R_SHIFT                                  0
+#define NIC0_TXS0_LIST_MASK_R_MASK                                   0x7FFFFFF
+
+/* NIC0_TXS0_RELEASE_INCALIDATE */
+#define NIC0_TXS0_RELEASE_INCALIDATE_R_SHIFT                         0
+#define NIC0_TXS0_RELEASE_INCALIDATE_R_MASK                          0x1
+
+/* NIC0_TXS0_BASE_ADDRESS_FREE_LIST_49_32 */
+#define NIC0_TXS0_BASE_ADDRESS_FREE_LIST_49_32_R_SHIFT               0
+#define NIC0_TXS0_BASE_ADDRESS_FREE_LIST_49_32_R_MASK                0x3FFFF
+
+/* NIC0_TXS0_BASE_ADDRESS_FREE_LIST_31_0 */
+#define NIC0_TXS0_BASE_ADDRESS_FREE_LIST_31_0_R_SHIFT                0
+#define NIC0_TXS0_BASE_ADDRESS_FREE_LIST_31_0_R_MASK                 0xFFFFFFFF
+
+/* NIC0_TXS0_FREE_LIST_EN */
+#define NIC0_TXS0_FREE_LIST_EN_R_SHIFT                               0
+#define NIC0_TXS0_FREE_LIST_EN_R_MASK                                0x1
+
+/* NIC0_TXS0_PUSH_FORCE_HIT_EN */
+#define NIC0_TXS0_PUSH_FORCE_HIT_EN_R_SHIFT                          0
+#define NIC0_TXS0_PUSH_FORCE_HIT_EN_R_MASK                           0x1
+
+/* NIC0_TXS0_PRODUCER_UPDATE_EN */
+#define NIC0_TXS0_PRODUCER_UPDATE_EN_R_SHIFT                         0
+#define NIC0_TXS0_PRODUCER_UPDATE_EN_R_MASK                          0x1
+
+/* NIC0_TXS0_PRODUCER_UPDATE */
+#define NIC0_TXS0_PRODUCER_UPDATE_R_SHIFT                            0
+#define NIC0_TXS0_PRODUCER_UPDATE_R_MASK                             0xFFFFFFFF
+
+/* NIC0_TXS0_PRIOQ_CREDIT_FORCE */
+#define NIC0_TXS0_PRIOQ_CREDIT_FORCE_FORCE_FULL_SHIFT                0
+#define NIC0_TXS0_PRIOQ_CREDIT_FORCE_FORCE_FULL_MASK                 0xFF
+
+/* NIC0_TXS0_PRIOQ_CREDIT */
+#define NIC0_TXS0_PRIOQ_CREDIT_R_SHIFT                               0
+#define NIC0_TXS0_PRIOQ_CREDIT_R_MASK                                0x3F
+
+/* NIC0_TXS0_DBG_COUNT_SELECT */
+#define NIC0_TXS0_DBG_COUNT_SELECT_R_SHIFT                           0
+#define NIC0_TXS0_DBG_COUNT_SELECT_R_MASK                            0x3F
+
+/* NIC0_TXS0_IGNORE_BURST_EN */
+#define NIC0_TXS0_IGNORE_BURST_EN_R_SHIFT                            0
+#define NIC0_TXS0_IGNORE_BURST_EN_R_MASK                             0x1
+
+/* NIC0_TXS0_IGNORE_BURST_THRESHOLD */
+#define NIC0_TXS0_IGNORE_BURST_THRESHOLD_R_SHIFT                     0
+#define NIC0_TXS0_IGNORE_BURST_THRESHOLD_R_MASK                      0x1FFFFFF
+
+/* NIC0_TXS0_RANDOM_PSUH_CFG */
+#define NIC0_TXS0_RANDOM_PSUH_CFG_BYPASS_SHIFT                       0
+#define NIC0_TXS0_RANDOM_PSUH_CFG_BYPASS_MASK                        0x1
+#define NIC0_TXS0_RANDOM_PSUH_CFG_RATE_LIMIT_EN_SHIFT                1
+#define NIC0_TXS0_RANDOM_PSUH_CFG_RATE_LIMIT_EN_MASK                 0x2
+#define NIC0_TXS0_RANDOM_PSUH_CFG_SATURATION_SHIFT                   2
+#define NIC0_TXS0_RANDOM_PSUH_CFG_SATURATION_MASK                    0x3C
+#define NIC0_TXS0_RANDOM_PSUH_CFG_RST_TOKEN_SHIFT                    6
+#define NIC0_TXS0_RANDOM_PSUH_CFG_RST_TOKEN_MASK                     0x7FFC0
+#define NIC0_TXS0_RANDOM_PSUH_CFG_TIMEOUT_SHIFT                      19
+#define NIC0_TXS0_RANDOM_PSUH_CFG_TIMEOUT_MASK                       0xFFF80000
+
+/* NIC0_TXS0_DBG_HW_EVENT_TRIGER */
+#define NIC0_TXS0_DBG_HW_EVENT_TRIGER_R_SHIFT                        0
+#define NIC0_TXS0_DBG_HW_EVENT_TRIGER_R_MASK                         0x1F
+
+/* NIC0_TXS0_INTERRUPT_CAUSE */
+#define NIC0_TXS0_INTERRUPT_CAUSE_R_SHIFT                            0
+#define NIC0_TXS0_INTERRUPT_CAUSE_R_MASK                             0xF
+
+/* NIC0_TXS0_INTERRUPT_MASK */
+#define NIC0_TXS0_INTERRUPT_MASK_R_SHIFT                             0
+#define NIC0_TXS0_INTERRUPT_MASK_R_MASK                              0xF
+
+/* NIC0_TXS0_INTERRUPT_CLR */
+
+/* NIC0_TXS0_LOAD_SLICE_HIT_EN */
+#define NIC0_TXS0_LOAD_SLICE_HIT_EN_R_SHIFT                          0
+#define NIC0_TXS0_LOAD_SLICE_HIT_EN_R_MASK                           0x1
+
+/* NIC0_TXS0_SLICE_ACTIVE_47_32 */
+#define NIC0_TXS0_SLICE_ACTIVE_47_32_R_SHIFT                         0
+#define NIC0_TXS0_SLICE_ACTIVE_47_32_R_MASK                          0xFFFF
+
+/* NIC0_TXS0_SLICE_ACTIVE_31_0 */
+#define NIC0_TXS0_SLICE_ACTIVE_31_0_R_SHIFT                          0
+#define NIC0_TXS0_SLICE_ACTIVE_31_0_R_MASK                           0xFFFFFFFF
+
+/* NIC0_TXS0_AXI_CACHE */
+#define NIC0_TXS0_AXI_CACHE_R_SHIFT                                  0
+#define NIC0_TXS0_AXI_CACHE_R_MASK                                   0xF
+
+/* NIC0_TXS0_SLICE_GW_ADDR */
+#define NIC0_TXS0_SLICE_GW_ADDR_R_SHIFT                              0
+#define NIC0_TXS0_SLICE_GW_ADDR_R_MASK                               0x3F
+
+/* NIC0_TXS0_SLICE_GW_DATA */
+#define NIC0_TXS0_SLICE_GW_DATA_R_SHIFT                              0
+#define NIC0_TXS0_SLICE_GW_DATA_R_MASK                               0x1FFFFFF
+
+/* NIC0_TXS0_SCANNER_CREDIT_EN */
+#define NIC0_TXS0_SCANNER_CREDIT_EN_R_SHIFT                          0
+#define NIC0_TXS0_SCANNER_CREDIT_EN_R_MASK                           0x3
+
+/* NIC0_TXS0_FREE_LIST_PUSH_MASK_EN */
+#define NIC0_TXS0_FREE_LIST_PUSH_MASK_EN_R_SHIFT                     0
+#define NIC0_TXS0_FREE_LIST_PUSH_MASK_EN_R_MASK                      0x1
+
+/* NIC0_TXS0_FREE_AEMPTY_THRESHOLD */
+#define NIC0_TXS0_FREE_AEMPTY_THRESHOLD_R_SHIFT                      0
+#define NIC0_TXS0_FREE_AEMPTY_THRESHOLD_R_MASK                       0xFFFFFFFF
+
+#endif /* ASIC_REG_NIC0_TXS0_MASKS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
new file mode 100644
index 000000000000..c4b31943287c
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
@@ -0,0 +1,214 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_TXS0_REGS_H_
+#define ASIC_REG_NIC0_TXS0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_TXS0 (Prototype: NIC_TXS)
+ *****************************************
+ */
+
+#define mmNIC0_TXS0_TMR_SCAN_EN                                      0xCF0000
+
+#define mmNIC0_TXS0_TICK_WRAP                                        0xCF0004
+
+#define mmNIC0_TXS0_SCAN_TIME_COMPARE_0                              0xCF0008
+
+#define mmNIC0_TXS0_SCAN_TIME_COMPARE_1                              0xCF000C
+
+#define mmNIC0_TXS0_SLICE_CREDIT                                     0xCF0010
+
+#define mmNIC0_TXS0_SLICE_FORCE_FULL                                 0xCF0014
+
+#define mmNIC0_TXS0_FIRST_SCHEDQ_ID                                  0xCF0018
+
+#define mmNIC0_TXS0_LAST_SCHEDQ_ID                                   0xCF001C
+
+#define mmNIC0_TXS0_PUSH_MASK                                        0xCF0020
+
+#define mmNIC0_TXS0_POP_MASK                                         0xCF0024
+
+#define mmNIC0_TXS0_PUSH_RELEASE_INVALIDATE                          0xCF0028
+
+#define mmNIC0_TXS0_POP_RELEASE_INVALIDATE                           0xCF002C
+
+#define mmNIC0_TXS0_LIST_MEM_READ_MASK                               0xCF0030
+
+#define mmNIC0_TXS0_FIFO_MEM_READ_MASK                               0xCF0034
+
+#define mmNIC0_TXS0_LIST_MEM_WRITE_MASK                              0xCF0038
+
+#define mmNIC0_TXS0_FIFO_MEM_WRITE_MASK                              0xCF003C
+
+#define mmNIC0_TXS0_BASE_ADDRESS_49_18                               0xCF0040
+
+#define mmNIC0_TXS0_BASE_ADDRESS_17_7                                0xCF0044
+
+#define mmNIC0_TXS0_AXI_USER                                         0xCF0048
+
+#define mmNIC0_TXS0_AXI_PROT                                         0xCF004C
+
+#define mmNIC0_TXS0_RATE_LIMIT                                       0xCF0050
+
+#define mmNIC0_TXS0_CACHE_CFG                                        0xCF0054
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_EN                                 0xCF005C
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_FIFO                               0xCF0060
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_31_0                          0xCF0064
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_63_32                         0xCF0068
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_95_64                         0xCF006C
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_127_96                        0xCF0070
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_159_128                       0xCF0074
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_191_160                       0xCF0078
+
+#define mmNIC0_TXS0_SCHEDQ_UPDATE_DESC_217_192                       0xCF007C
+
+#define mmNIC0_TXS0_FORCE_HIT_EN                                     0xCF0080
+
+#define mmNIC0_TXS0_INVALIDATE_LIST                                  0xCF0084
+
+#define mmNIC0_TXS0_INVALIDATE_LIST_STATUS                           0xCF0088
+
+#define mmNIC0_TXS0_INVALIDATE_FREE_LIST                             0xCF008C
+
+#define mmNIC0_TXS0_INVALIDATE_FREE_LIST_STAT                        0xCF0090
+
+#define mmNIC0_TXS0_PUSH_PREFETCH_EN                                 0xCF0094
+
+#define mmNIC0_TXS0_PUSH_RELEASE_EN                                  0xCF0098
+
+#define mmNIC0_TXS0_PUSH_LOCK_EN                                     0xCF009C
+
+#define mmNIC0_TXS0_PUSH_PREFETCH_NEXT_EN                            0xCF00A0
+
+#define mmNIC0_TXS0_POP_PREFETCH_EN                                  0xCF00A4
+
+#define mmNIC0_TXS0_POP_RELEASE_EN                                   0xCF00A8
+
+#define mmNIC0_TXS0_POP_LOCK_EN                                      0xCF00AC
+
+#define mmNIC0_TXS0_POP_PREFETCH_NEXT_EN                             0xCF00B0
+
+#define mmNIC0_TXS0_LIST_MASK                                        0xCF00B4
+
+#define mmNIC0_TXS0_RELEASE_INCALIDATE                               0xCF00B8
+
+#define mmNIC0_TXS0_BASE_ADDRESS_FREE_LIST_49_32                     0xCF00BC
+
+#define mmNIC0_TXS0_BASE_ADDRESS_FREE_LIST_31_0                      0xCF00C0
+
+#define mmNIC0_TXS0_FREE_LIST_EN                                     0xCF00C4
+
+#define mmNIC0_TXS0_PUSH_FORCE_HIT_EN                                0xCF00C8
+
+#define mmNIC0_TXS0_PRODUCER_UPDATE_EN                               0xCF00CC
+
+#define mmNIC0_TXS0_PRODUCER_UPDATE                                  0xCF00D0
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_FORCE                               0xCF00D4
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_0                                   0xCF00D8
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_1                                   0xCF00DC
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_2                                   0xCF00E0
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_3                                   0xCF00E4
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_4                                   0xCF00E8
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_5                                   0xCF00EC
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_6                                   0xCF00F0
+
+#define mmNIC0_TXS0_PRIOQ_CREDIT_7                                   0xCF00F4
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_0                               0xCF00F8
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_1                               0xCF00FC
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_2                               0xCF0100
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_3                               0xCF0104
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_4                               0xCF0108
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_5                               0xCF010C
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_6                               0xCF0110
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_7                               0xCF0114
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_8                               0xCF0118
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_9                               0xCF011C
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_10                              0xCF0120
+
+#define mmNIC0_TXS0_DBG_COUNT_SELECT_11                              0xCF0124
+
+#define mmNIC0_TXS0_IGNORE_BURST_EN                                  0xCF0140
+
+#define mmNIC0_TXS0_IGNORE_BURST_THRESHOLD_0                         0xCF0144
+
+#define mmNIC0_TXS0_IGNORE_BURST_THRESHOLD_1                         0xCF0148
+
+#define mmNIC0_TXS0_IGNORE_BURST_THRESHOLD_2                         0xCF014C
+
+#define mmNIC0_TXS0_IGNORE_BURST_THRESHOLD_3                         0xCF0150
+
+#define mmNIC0_TXS0_IGNORE_BURST_THRESHOLD_4                         0xCF0154
+
+#define mmNIC0_TXS0_IGNORE_BURST_THRESHOLD_5                         0xCF0158
+
+#define mmNIC0_TXS0_IGNORE_BURST_THRESHOLD_6                         0xCF015C
+
+#define mmNIC0_TXS0_IGNORE_BURST_THRESHOLD_7                         0xCF0160
+
+#define mmNIC0_TXS0_RANDOM_PSUH_CFG                                  0xCF0164
+
+#define mmNIC0_TXS0_DBG_HW_EVENT_TRIGER                              0xCF0168
+
+#define mmNIC0_TXS0_INTERRUPT_CAUSE                                  0xCF016C
+
+#define mmNIC0_TXS0_INTERRUPT_MASK                                   0xCF0170
+
+#define mmNIC0_TXS0_INTERRUPT_CLR                                    0xCF0174
+
+#define mmNIC0_TXS0_LOAD_SLICE_HIT_EN                                0xCF0178
+
+#define mmNIC0_TXS0_SLICE_ACTIVE_47_32                               0xCF017C
+
+#define mmNIC0_TXS0_SLICE_ACTIVE_31_0                                0xCF0180
+
+#define mmNIC0_TXS0_AXI_CACHE                                        0xCF0184
+
+#define mmNIC0_TXS0_SLICE_GW_ADDR                                    0xCF0188
+
+#define mmNIC0_TXS0_SLICE_GW_DATA                                    0xCF018C
+
+#define mmNIC0_TXS0_SCANNER_CREDIT_EN                                0xCF0190
+
+#define mmNIC0_TXS0_FREE_LIST_PUSH_MASK_EN                           0xCF0194
+
+#define mmNIC0_TXS0_FREE_AEMPTY_THRESHOLD                            0xCF0198
+
+#endif /* ASIC_REG_NIC0_TXS0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
new file mode 100644
index 000000000000..7a7fb386f239
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
@@ -0,0 +1,214 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC0_TXS1_REGS_H_
+#define ASIC_REG_NIC0_TXS1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC0_TXS1 (Prototype: NIC_TXS)
+ *****************************************
+ */
+
+#define mmNIC0_TXS1_TMR_SCAN_EN                                      0xCF1000
+
+#define mmNIC0_TXS1_TICK_WRAP                                        0xCF1004
+
+#define mmNIC0_TXS1_SCAN_TIME_COMPARE_0                              0xCF1008
+
+#define mmNIC0_TXS1_SCAN_TIME_COMPARE_1                              0xCF100C
+
+#define mmNIC0_TXS1_SLICE_CREDIT                                     0xCF1010
+
+#define mmNIC0_TXS1_SLICE_FORCE_FULL                                 0xCF1014
+
+#define mmNIC0_TXS1_FIRST_SCHEDQ_ID                                  0xCF1018
+
+#define mmNIC0_TXS1_LAST_SCHEDQ_ID                                   0xCF101C
+
+#define mmNIC0_TXS1_PUSH_MASK                                        0xCF1020
+
+#define mmNIC0_TXS1_POP_MASK                                         0xCF1024
+
+#define mmNIC0_TXS1_PUSH_RELEASE_INVALIDATE                          0xCF1028
+
+#define mmNIC0_TXS1_POP_RELEASE_INVALIDATE                           0xCF102C
+
+#define mmNIC0_TXS1_LIST_MEM_READ_MASK                               0xCF1030
+
+#define mmNIC0_TXS1_FIFO_MEM_READ_MASK                               0xCF1034
+
+#define mmNIC0_TXS1_LIST_MEM_WRITE_MASK                              0xCF1038
+
+#define mmNIC0_TXS1_FIFO_MEM_WRITE_MASK                              0xCF103C
+
+#define mmNIC0_TXS1_BASE_ADDRESS_49_18                               0xCF1040
+
+#define mmNIC0_TXS1_BASE_ADDRESS_17_7                                0xCF1044
+
+#define mmNIC0_TXS1_AXI_USER                                         0xCF1048
+
+#define mmNIC0_TXS1_AXI_PROT                                         0xCF104C
+
+#define mmNIC0_TXS1_RATE_LIMIT                                       0xCF1050
+
+#define mmNIC0_TXS1_CACHE_CFG                                        0xCF1054
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_EN                                 0xCF105C
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_FIFO                               0xCF1060
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_DESC_31_0                          0xCF1064
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_DESC_63_32                         0xCF1068
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_DESC_95_64                         0xCF106C
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_DESC_127_96                        0xCF1070
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_DESC_159_128                       0xCF1074
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_DESC_191_160                       0xCF1078
+
+#define mmNIC0_TXS1_SCHEDQ_UPDATE_DESC_217_192                       0xCF107C
+
+#define mmNIC0_TXS1_FORCE_HIT_EN                                     0xCF1080
+
+#define mmNIC0_TXS1_INVALIDATE_LIST                                  0xCF1084
+
+#define mmNIC0_TXS1_INVALIDATE_LIST_STATUS                           0xCF1088
+
+#define mmNIC0_TXS1_INVALIDATE_FREE_LIST                             0xCF108C
+
+#define mmNIC0_TXS1_INVALIDATE_FREE_LIST_STAT                        0xCF1090
+
+#define mmNIC0_TXS1_PUSH_PREFETCH_EN                                 0xCF1094
+
+#define mmNIC0_TXS1_PUSH_RELEASE_EN                                  0xCF1098
+
+#define mmNIC0_TXS1_PUSH_LOCK_EN                                     0xCF109C
+
+#define mmNIC0_TXS1_PUSH_PREFETCH_NEXT_EN                            0xCF10A0
+
+#define mmNIC0_TXS1_POP_PREFETCH_EN                                  0xCF10A4
+
+#define mmNIC0_TXS1_POP_RELEASE_EN                                   0xCF10A8
+
+#define mmNIC0_TXS1_POP_LOCK_EN                                      0xCF10AC
+
+#define mmNIC0_TXS1_POP_PREFETCH_NEXT_EN                             0xCF10B0
+
+#define mmNIC0_TXS1_LIST_MASK                                        0xCF10B4
+
+#define mmNIC0_TXS1_RELEASE_INCALIDATE                               0xCF10B8
+
+#define mmNIC0_TXS1_BASE_ADDRESS_FREE_LIST_49_32                     0xCF10BC
+
+#define mmNIC0_TXS1_BASE_ADDRESS_FREE_LIST_31_0                      0xCF10C0
+
+#define mmNIC0_TXS1_FREE_LIST_EN                                     0xCF10C4
+
+#define mmNIC0_TXS1_PUSH_FORCE_HIT_EN                                0xCF10C8
+
+#define mmNIC0_TXS1_PRODUCER_UPDATE_EN                               0xCF10CC
+
+#define mmNIC0_TXS1_PRODUCER_UPDATE                                  0xCF10D0
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_FORCE                               0xCF10D4
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_0                                   0xCF10D8
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_1                                   0xCF10DC
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_2                                   0xCF10E0
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_3                                   0xCF10E4
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_4                                   0xCF10E8
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_5                                   0xCF10EC
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_6                                   0xCF10F0
+
+#define mmNIC0_TXS1_PRIOQ_CREDIT_7                                   0xCF10F4
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_0                               0xCF10F8
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_1                               0xCF10FC
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_2                               0xCF1100
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_3                               0xCF1104
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_4                               0xCF1108
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_5                               0xCF110C
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_6                               0xCF1110
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_7                               0xCF1114
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_8                               0xCF1118
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_9                               0xCF111C
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_10                              0xCF1120
+
+#define mmNIC0_TXS1_DBG_COUNT_SELECT_11                              0xCF1124
+
+#define mmNIC0_TXS1_IGNORE_BURST_EN                                  0xCF1140
+
+#define mmNIC0_TXS1_IGNORE_BURST_THRESHOLD_0                         0xCF1144
+
+#define mmNIC0_TXS1_IGNORE_BURST_THRESHOLD_1                         0xCF1148
+
+#define mmNIC0_TXS1_IGNORE_BURST_THRESHOLD_2                         0xCF114C
+
+#define mmNIC0_TXS1_IGNORE_BURST_THRESHOLD_3                         0xCF1150
+
+#define mmNIC0_TXS1_IGNORE_BURST_THRESHOLD_4                         0xCF1154
+
+#define mmNIC0_TXS1_IGNORE_BURST_THRESHOLD_5                         0xCF1158
+
+#define mmNIC0_TXS1_IGNORE_BURST_THRESHOLD_6                         0xCF115C
+
+#define mmNIC0_TXS1_IGNORE_BURST_THRESHOLD_7                         0xCF1160
+
+#define mmNIC0_TXS1_RANDOM_PSUH_CFG                                  0xCF1164
+
+#define mmNIC0_TXS1_DBG_HW_EVENT_TRIGER                              0xCF1168
+
+#define mmNIC0_TXS1_INTERRUPT_CAUSE                                  0xCF116C
+
+#define mmNIC0_TXS1_INTERRUPT_MASK                                   0xCF1170
+
+#define mmNIC0_TXS1_INTERRUPT_CLR                                    0xCF1174
+
+#define mmNIC0_TXS1_LOAD_SLICE_HIT_EN                                0xCF1178
+
+#define mmNIC0_TXS1_SLICE_ACTIVE_47_32                               0xCF117C
+
+#define mmNIC0_TXS1_SLICE_ACTIVE_31_0                                0xCF1180
+
+#define mmNIC0_TXS1_AXI_CACHE                                        0xCF1184
+
+#define mmNIC0_TXS1_SLICE_GW_ADDR                                    0xCF1188
+
+#define mmNIC0_TXS1_SLICE_GW_DATA                                    0xCF118C
+
+#define mmNIC0_TXS1_SCANNER_CREDIT_EN                                0xCF1190
+
+#define mmNIC0_TXS1_FREE_LIST_PUSH_MASK_EN                           0xCF1194
+
+#define mmNIC0_TXS1_FREE_AEMPTY_THRESHOLD                            0xCF1198
+
+#endif /* ASIC_REG_NIC0_TXS1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
new file mode 100644
index 000000000000..0d1caf057ad0
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC1_QM0_REGS_H_
+#define ASIC_REG_NIC1_QM0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC1_QM0 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC1_QM0_GLBL_CFG0                                         0xD20000
+
+#define mmNIC1_QM0_GLBL_CFG1                                         0xD20004
+
+#define mmNIC1_QM0_GLBL_PROT                                         0xD20008
+
+#define mmNIC1_QM0_GLBL_ERR_CFG                                      0xD2000C
+
+#define mmNIC1_QM0_GLBL_SECURE_PROPS_0                               0xD20010
+
+#define mmNIC1_QM0_GLBL_SECURE_PROPS_1                               0xD20014
+
+#define mmNIC1_QM0_GLBL_SECURE_PROPS_2                               0xD20018
+
+#define mmNIC1_QM0_GLBL_SECURE_PROPS_3                               0xD2001C
+
+#define mmNIC1_QM0_GLBL_SECURE_PROPS_4                               0xD20020
+
+#define mmNIC1_QM0_GLBL_NON_SECURE_PROPS_0                           0xD20024
+
+#define mmNIC1_QM0_GLBL_NON_SECURE_PROPS_1                           0xD20028
+
+#define mmNIC1_QM0_GLBL_NON_SECURE_PROPS_2                           0xD2002C
+
+#define mmNIC1_QM0_GLBL_NON_SECURE_PROPS_3                           0xD20030
+
+#define mmNIC1_QM0_GLBL_NON_SECURE_PROPS_4                           0xD20034
+
+#define mmNIC1_QM0_GLBL_STS0                                         0xD20038
+
+#define mmNIC1_QM0_GLBL_STS1_0                                       0xD20040
+
+#define mmNIC1_QM0_GLBL_STS1_1                                       0xD20044
+
+#define mmNIC1_QM0_GLBL_STS1_2                                       0xD20048
+
+#define mmNIC1_QM0_GLBL_STS1_3                                       0xD2004C
+
+#define mmNIC1_QM0_GLBL_STS1_4                                       0xD20050
+
+#define mmNIC1_QM0_GLBL_MSG_EN_0                                     0xD20054
+
+#define mmNIC1_QM0_GLBL_MSG_EN_1                                     0xD20058
+
+#define mmNIC1_QM0_GLBL_MSG_EN_2                                     0xD2005C
+
+#define mmNIC1_QM0_GLBL_MSG_EN_3                                     0xD20060
+
+#define mmNIC1_QM0_GLBL_MSG_EN_4                                     0xD20068
+
+#define mmNIC1_QM0_PQ_BASE_LO_0                                      0xD20070
+
+#define mmNIC1_QM0_PQ_BASE_LO_1                                      0xD20074
+
+#define mmNIC1_QM0_PQ_BASE_LO_2                                      0xD20078
+
+#define mmNIC1_QM0_PQ_BASE_LO_3                                      0xD2007C
+
+#define mmNIC1_QM0_PQ_BASE_HI_0                                      0xD20080
+
+#define mmNIC1_QM0_PQ_BASE_HI_1                                      0xD20084
+
+#define mmNIC1_QM0_PQ_BASE_HI_2                                      0xD20088
+
+#define mmNIC1_QM0_PQ_BASE_HI_3                                      0xD2008C
+
+#define mmNIC1_QM0_PQ_SIZE_0                                         0xD20090
+
+#define mmNIC1_QM0_PQ_SIZE_1                                         0xD20094
+
+#define mmNIC1_QM0_PQ_SIZE_2                                         0xD20098
+
+#define mmNIC1_QM0_PQ_SIZE_3                                         0xD2009C
+
+#define mmNIC1_QM0_PQ_PI_0                                           0xD200A0
+
+#define mmNIC1_QM0_PQ_PI_1                                           0xD200A4
+
+#define mmNIC1_QM0_PQ_PI_2                                           0xD200A8
+
+#define mmNIC1_QM0_PQ_PI_3                                           0xD200AC
+
+#define mmNIC1_QM0_PQ_CI_0                                           0xD200B0
+
+#define mmNIC1_QM0_PQ_CI_1                                           0xD200B4
+
+#define mmNIC1_QM0_PQ_CI_2                                           0xD200B8
+
+#define mmNIC1_QM0_PQ_CI_3                                           0xD200BC
+
+#define mmNIC1_QM0_PQ_CFG0_0                                         0xD200C0
+
+#define mmNIC1_QM0_PQ_CFG0_1                                         0xD200C4
+
+#define mmNIC1_QM0_PQ_CFG0_2                                         0xD200C8
+
+#define mmNIC1_QM0_PQ_CFG0_3                                         0xD200CC
+
+#define mmNIC1_QM0_PQ_CFG1_0                                         0xD200D0
+
+#define mmNIC1_QM0_PQ_CFG1_1                                         0xD200D4
+
+#define mmNIC1_QM0_PQ_CFG1_2                                         0xD200D8
+
+#define mmNIC1_QM0_PQ_CFG1_3                                         0xD200DC
+
+#define mmNIC1_QM0_PQ_ARUSER_31_11_0                                 0xD200E0
+
+#define mmNIC1_QM0_PQ_ARUSER_31_11_1                                 0xD200E4
+
+#define mmNIC1_QM0_PQ_ARUSER_31_11_2                                 0xD200E8
+
+#define mmNIC1_QM0_PQ_ARUSER_31_11_3                                 0xD200EC
+
+#define mmNIC1_QM0_PQ_STS0_0                                         0xD200F0
+
+#define mmNIC1_QM0_PQ_STS0_1                                         0xD200F4
+
+#define mmNIC1_QM0_PQ_STS0_2                                         0xD200F8
+
+#define mmNIC1_QM0_PQ_STS0_3                                         0xD200FC
+
+#define mmNIC1_QM0_PQ_STS1_0                                         0xD20100
+
+#define mmNIC1_QM0_PQ_STS1_1                                         0xD20104
+
+#define mmNIC1_QM0_PQ_STS1_2                                         0xD20108
+
+#define mmNIC1_QM0_PQ_STS1_3                                         0xD2010C
+
+#define mmNIC1_QM0_CQ_CFG0_0                                         0xD20110
+
+#define mmNIC1_QM0_CQ_CFG0_1                                         0xD20114
+
+#define mmNIC1_QM0_CQ_CFG0_2                                         0xD20118
+
+#define mmNIC1_QM0_CQ_CFG0_3                                         0xD2011C
+
+#define mmNIC1_QM0_CQ_CFG0_4                                         0xD20120
+
+#define mmNIC1_QM0_CQ_CFG1_0                                         0xD20124
+
+#define mmNIC1_QM0_CQ_CFG1_1                                         0xD20128
+
+#define mmNIC1_QM0_CQ_CFG1_2                                         0xD2012C
+
+#define mmNIC1_QM0_CQ_CFG1_3                                         0xD20130
+
+#define mmNIC1_QM0_CQ_CFG1_4                                         0xD20134
+
+#define mmNIC1_QM0_CQ_ARUSER_31_11_0                                 0xD20138
+
+#define mmNIC1_QM0_CQ_ARUSER_31_11_1                                 0xD2013C
+
+#define mmNIC1_QM0_CQ_ARUSER_31_11_2                                 0xD20140
+
+#define mmNIC1_QM0_CQ_ARUSER_31_11_3                                 0xD20144
+
+#define mmNIC1_QM0_CQ_ARUSER_31_11_4                                 0xD20148
+
+#define mmNIC1_QM0_CQ_STS0_0                                         0xD2014C
+
+#define mmNIC1_QM0_CQ_STS0_1                                         0xD20150
+
+#define mmNIC1_QM0_CQ_STS0_2                                         0xD20154
+
+#define mmNIC1_QM0_CQ_STS0_3                                         0xD20158
+
+#define mmNIC1_QM0_CQ_STS0_4                                         0xD2015C
+
+#define mmNIC1_QM0_CQ_STS1_0                                         0xD20160
+
+#define mmNIC1_QM0_CQ_STS1_1                                         0xD20164
+
+#define mmNIC1_QM0_CQ_STS1_2                                         0xD20168
+
+#define mmNIC1_QM0_CQ_STS1_3                                         0xD2016C
+
+#define mmNIC1_QM0_CQ_STS1_4                                         0xD20170
+
+#define mmNIC1_QM0_CQ_PTR_LO_0                                       0xD20174
+
+#define mmNIC1_QM0_CQ_PTR_HI_0                                       0xD20178
+
+#define mmNIC1_QM0_CQ_TSIZE_0                                        0xD2017C
+
+#define mmNIC1_QM0_CQ_CTL_0                                          0xD20180
+
+#define mmNIC1_QM0_CQ_PTR_LO_1                                       0xD20184
+
+#define mmNIC1_QM0_CQ_PTR_HI_1                                       0xD20188
+
+#define mmNIC1_QM0_CQ_TSIZE_1                                        0xD2018C
+
+#define mmNIC1_QM0_CQ_CTL_1                                          0xD20190
+
+#define mmNIC1_QM0_CQ_PTR_LO_2                                       0xD20194
+
+#define mmNIC1_QM0_CQ_PTR_HI_2                                       0xD20198
+
+#define mmNIC1_QM0_CQ_TSIZE_2                                        0xD2019C
+
+#define mmNIC1_QM0_CQ_CTL_2                                          0xD201A0
+
+#define mmNIC1_QM0_CQ_PTR_LO_3                                       0xD201A4
+
+#define mmNIC1_QM0_CQ_PTR_HI_3                                       0xD201A8
+
+#define mmNIC1_QM0_CQ_TSIZE_3                                        0xD201AC
+
+#define mmNIC1_QM0_CQ_CTL_3                                          0xD201B0
+
+#define mmNIC1_QM0_CQ_PTR_LO_4                                       0xD201B4
+
+#define mmNIC1_QM0_CQ_PTR_HI_4                                       0xD201B8
+
+#define mmNIC1_QM0_CQ_TSIZE_4                                        0xD201BC
+
+#define mmNIC1_QM0_CQ_CTL_4                                          0xD201C0
+
+#define mmNIC1_QM0_CQ_PTR_LO_STS_0                                   0xD201C4
+
+#define mmNIC1_QM0_CQ_PTR_LO_STS_1                                   0xD201C8
+
+#define mmNIC1_QM0_CQ_PTR_LO_STS_2                                   0xD201CC
+
+#define mmNIC1_QM0_CQ_PTR_LO_STS_3                                   0xD201D0
+
+#define mmNIC1_QM0_CQ_PTR_LO_STS_4                                   0xD201D4
+
+#define mmNIC1_QM0_CQ_PTR_HI_STS_0                                   0xD201D8
+
+#define mmNIC1_QM0_CQ_PTR_HI_STS_1                                   0xD201DC
+
+#define mmNIC1_QM0_CQ_PTR_HI_STS_2                                   0xD201E0
+
+#define mmNIC1_QM0_CQ_PTR_HI_STS_3                                   0xD201E4
+
+#define mmNIC1_QM0_CQ_PTR_HI_STS_4                                   0xD201E8
+
+#define mmNIC1_QM0_CQ_TSIZE_STS_0                                    0xD201EC
+
+#define mmNIC1_QM0_CQ_TSIZE_STS_1                                    0xD201F0
+
+#define mmNIC1_QM0_CQ_TSIZE_STS_2                                    0xD201F4
+
+#define mmNIC1_QM0_CQ_TSIZE_STS_3                                    0xD201F8
+
+#define mmNIC1_QM0_CQ_TSIZE_STS_4                                    0xD201FC
+
+#define mmNIC1_QM0_CQ_CTL_STS_0                                      0xD20200
+
+#define mmNIC1_QM0_CQ_CTL_STS_1                                      0xD20204
+
+#define mmNIC1_QM0_CQ_CTL_STS_2                                      0xD20208
+
+#define mmNIC1_QM0_CQ_CTL_STS_3                                      0xD2020C
+
+#define mmNIC1_QM0_CQ_CTL_STS_4                                      0xD20210
+
+#define mmNIC1_QM0_CQ_IFIFO_CNT_0                                    0xD20214
+
+#define mmNIC1_QM0_CQ_IFIFO_CNT_1                                    0xD20218
+
+#define mmNIC1_QM0_CQ_IFIFO_CNT_2                                    0xD2021C
+
+#define mmNIC1_QM0_CQ_IFIFO_CNT_3                                    0xD20220
+
+#define mmNIC1_QM0_CQ_IFIFO_CNT_4                                    0xD20224
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_0                            0xD20228
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_1                            0xD2022C
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_2                            0xD20230
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_3                            0xD20234
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_LO_4                            0xD20238
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_0                            0xD2023C
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_1                            0xD20240
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_2                            0xD20244
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_3                            0xD20248
+
+#define mmNIC1_QM0_CP_MSG_BASE0_ADDR_HI_4                            0xD2024C
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_0                            0xD20250
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_1                            0xD20254
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_2                            0xD20258
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_3                            0xD2025C
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_LO_4                            0xD20260
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_0                            0xD20264
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_1                            0xD20268
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_2                            0xD2026C
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_3                            0xD20270
+
+#define mmNIC1_QM0_CP_MSG_BASE1_ADDR_HI_4                            0xD20274
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_0                            0xD20278
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_1                            0xD2027C
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_2                            0xD20280
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_3                            0xD20284
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_LO_4                            0xD20288
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_0                            0xD2028C
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_1                            0xD20290
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_2                            0xD20294
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_3                            0xD20298
+
+#define mmNIC1_QM0_CP_MSG_BASE2_ADDR_HI_4                            0xD2029C
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_0                            0xD202A0
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_1                            0xD202A4
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_2                            0xD202A8
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_3                            0xD202AC
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_LO_4                            0xD202B0
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_0                            0xD202B4
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_1                            0xD202B8
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_2                            0xD202BC
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_3                            0xD202C0
+
+#define mmNIC1_QM0_CP_MSG_BASE3_ADDR_HI_4                            0xD202C4
+
+#define mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_0                            0xD202C8
+
+#define mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_1                            0xD202CC
+
+#define mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_2                            0xD202D0
+
+#define mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_3                            0xD202D4
+
+#define mmNIC1_QM0_CP_LDMA_TSIZE_OFFSET_4                            0xD202D8
+
+#define mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xD202E0
+
+#define mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xD202E4
+
+#define mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xD202E8
+
+#define mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xD202EC
+
+#define mmNIC1_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xD202F0
+
+#define mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xD202F4
+
+#define mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xD202F8
+
+#define mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xD202FC
+
+#define mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xD20300
+
+#define mmNIC1_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xD20304
+
+#define mmNIC1_QM0_CP_FENCE0_RDATA_0                                 0xD20308
+
+#define mmNIC1_QM0_CP_FENCE0_RDATA_1                                 0xD2030C
+
+#define mmNIC1_QM0_CP_FENCE0_RDATA_2                                 0xD20310
+
+#define mmNIC1_QM0_CP_FENCE0_RDATA_3                                 0xD20314
+
+#define mmNIC1_QM0_CP_FENCE0_RDATA_4                                 0xD20318
+
+#define mmNIC1_QM0_CP_FENCE1_RDATA_0                                 0xD2031C
+
+#define mmNIC1_QM0_CP_FENCE1_RDATA_1                                 0xD20320
+
+#define mmNIC1_QM0_CP_FENCE1_RDATA_2                                 0xD20324
+
+#define mmNIC1_QM0_CP_FENCE1_RDATA_3                                 0xD20328
+
+#define mmNIC1_QM0_CP_FENCE1_RDATA_4                                 0xD2032C
+
+#define mmNIC1_QM0_CP_FENCE2_RDATA_0                                 0xD20330
+
+#define mmNIC1_QM0_CP_FENCE2_RDATA_1                                 0xD20334
+
+#define mmNIC1_QM0_CP_FENCE2_RDATA_2                                 0xD20338
+
+#define mmNIC1_QM0_CP_FENCE2_RDATA_3                                 0xD2033C
+
+#define mmNIC1_QM0_CP_FENCE2_RDATA_4                                 0xD20340
+
+#define mmNIC1_QM0_CP_FENCE3_RDATA_0                                 0xD20344
+
+#define mmNIC1_QM0_CP_FENCE3_RDATA_1                                 0xD20348
+
+#define mmNIC1_QM0_CP_FENCE3_RDATA_2                                 0xD2034C
+
+#define mmNIC1_QM0_CP_FENCE3_RDATA_3                                 0xD20350
+
+#define mmNIC1_QM0_CP_FENCE3_RDATA_4                                 0xD20354
+
+#define mmNIC1_QM0_CP_FENCE0_CNT_0                                   0xD20358
+
+#define mmNIC1_QM0_CP_FENCE0_CNT_1                                   0xD2035C
+
+#define mmNIC1_QM0_CP_FENCE0_CNT_2                                   0xD20360
+
+#define mmNIC1_QM0_CP_FENCE0_CNT_3                                   0xD20364
+
+#define mmNIC1_QM0_CP_FENCE0_CNT_4                                   0xD20368
+
+#define mmNIC1_QM0_CP_FENCE1_CNT_0                                   0xD2036C
+
+#define mmNIC1_QM0_CP_FENCE1_CNT_1                                   0xD20370
+
+#define mmNIC1_QM0_CP_FENCE1_CNT_2                                   0xD20374
+
+#define mmNIC1_QM0_CP_FENCE1_CNT_3                                   0xD20378
+
+#define mmNIC1_QM0_CP_FENCE1_CNT_4                                   0xD2037C
+
+#define mmNIC1_QM0_CP_FENCE2_CNT_0                                   0xD20380
+
+#define mmNIC1_QM0_CP_FENCE2_CNT_1                                   0xD20384
+
+#define mmNIC1_QM0_CP_FENCE2_CNT_2                                   0xD20388
+
+#define mmNIC1_QM0_CP_FENCE2_CNT_3                                   0xD2038C
+
+#define mmNIC1_QM0_CP_FENCE2_CNT_4                                   0xD20390
+
+#define mmNIC1_QM0_CP_FENCE3_CNT_0                                   0xD20394
+
+#define mmNIC1_QM0_CP_FENCE3_CNT_1                                   0xD20398
+
+#define mmNIC1_QM0_CP_FENCE3_CNT_2                                   0xD2039C
+
+#define mmNIC1_QM0_CP_FENCE3_CNT_3                                   0xD203A0
+
+#define mmNIC1_QM0_CP_FENCE3_CNT_4                                   0xD203A4
+
+#define mmNIC1_QM0_CP_STS_0                                          0xD203A8
+
+#define mmNIC1_QM0_CP_STS_1                                          0xD203AC
+
+#define mmNIC1_QM0_CP_STS_2                                          0xD203B0
+
+#define mmNIC1_QM0_CP_STS_3                                          0xD203B4
+
+#define mmNIC1_QM0_CP_STS_4                                          0xD203B8
+
+#define mmNIC1_QM0_CP_CURRENT_INST_LO_0                              0xD203BC
+
+#define mmNIC1_QM0_CP_CURRENT_INST_LO_1                              0xD203C0
+
+#define mmNIC1_QM0_CP_CURRENT_INST_LO_2                              0xD203C4
+
+#define mmNIC1_QM0_CP_CURRENT_INST_LO_3                              0xD203C8
+
+#define mmNIC1_QM0_CP_CURRENT_INST_LO_4                              0xD203CC
+
+#define mmNIC1_QM0_CP_CURRENT_INST_HI_0                              0xD203D0
+
+#define mmNIC1_QM0_CP_CURRENT_INST_HI_1                              0xD203D4
+
+#define mmNIC1_QM0_CP_CURRENT_INST_HI_2                              0xD203D8
+
+#define mmNIC1_QM0_CP_CURRENT_INST_HI_3                              0xD203DC
+
+#define mmNIC1_QM0_CP_CURRENT_INST_HI_4                              0xD203E0
+
+#define mmNIC1_QM0_CP_BARRIER_CFG_0                                  0xD203F4
+
+#define mmNIC1_QM0_CP_BARRIER_CFG_1                                  0xD203F8
+
+#define mmNIC1_QM0_CP_BARRIER_CFG_2                                  0xD203FC
+
+#define mmNIC1_QM0_CP_BARRIER_CFG_3                                  0xD20400
+
+#define mmNIC1_QM0_CP_BARRIER_CFG_4                                  0xD20404
+
+#define mmNIC1_QM0_CP_DBG_0_0                                        0xD20408
+
+#define mmNIC1_QM0_CP_DBG_0_1                                        0xD2040C
+
+#define mmNIC1_QM0_CP_DBG_0_2                                        0xD20410
+
+#define mmNIC1_QM0_CP_DBG_0_3                                        0xD20414
+
+#define mmNIC1_QM0_CP_DBG_0_4                                        0xD20418
+
+#define mmNIC1_QM0_CP_ARUSER_31_11_0                                 0xD2041C
+
+#define mmNIC1_QM0_CP_ARUSER_31_11_1                                 0xD20420
+
+#define mmNIC1_QM0_CP_ARUSER_31_11_2                                 0xD20424
+
+#define mmNIC1_QM0_CP_ARUSER_31_11_3                                 0xD20428
+
+#define mmNIC1_QM0_CP_ARUSER_31_11_4                                 0xD2042C
+
+#define mmNIC1_QM0_CP_AWUSER_31_11_0                                 0xD20430
+
+#define mmNIC1_QM0_CP_AWUSER_31_11_1                                 0xD20434
+
+#define mmNIC1_QM0_CP_AWUSER_31_11_2                                 0xD20438
+
+#define mmNIC1_QM0_CP_AWUSER_31_11_3                                 0xD2043C
+
+#define mmNIC1_QM0_CP_AWUSER_31_11_4                                 0xD20440
+
+#define mmNIC1_QM0_ARB_CFG_0                                         0xD20A00
+
+#define mmNIC1_QM0_ARB_CHOISE_Q_PUSH                                 0xD20A04
+
+#define mmNIC1_QM0_ARB_WRR_WEIGHT_0                                  0xD20A08
+
+#define mmNIC1_QM0_ARB_WRR_WEIGHT_1                                  0xD20A0C
+
+#define mmNIC1_QM0_ARB_WRR_WEIGHT_2                                  0xD20A10
+
+#define mmNIC1_QM0_ARB_WRR_WEIGHT_3                                  0xD20A14
+
+#define mmNIC1_QM0_ARB_CFG_1                                         0xD20A18
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_0                              0xD20A20
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_1                              0xD20A24
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_2                              0xD20A28
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_3                              0xD20A2C
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_4                              0xD20A30
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_5                              0xD20A34
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_6                              0xD20A38
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_7                              0xD20A3C
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_8                              0xD20A40
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_9                              0xD20A44
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_10                             0xD20A48
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_11                             0xD20A4C
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_12                             0xD20A50
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_13                             0xD20A54
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_14                             0xD20A58
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_15                             0xD20A5C
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_16                             0xD20A60
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_17                             0xD20A64
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_18                             0xD20A68
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_19                             0xD20A6C
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_20                             0xD20A70
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_21                             0xD20A74
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_22                             0xD20A78
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_23                             0xD20A7C
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_24                             0xD20A80
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_25                             0xD20A84
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_26                             0xD20A88
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_27                             0xD20A8C
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_28                             0xD20A90
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_29                             0xD20A94
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_30                             0xD20A98
+
+#define mmNIC1_QM0_ARB_MST_AVAIL_CRED_31                             0xD20A9C
+
+#define mmNIC1_QM0_ARB_MST_CRED_INC                                  0xD20AA0
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_0                        0xD20AA4
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_1                        0xD20AA8
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_2                        0xD20AAC
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_3                        0xD20AB0
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_4                        0xD20AB4
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_5                        0xD20AB8
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_6                        0xD20ABC
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_7                        0xD20AC0
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_8                        0xD20AC4
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_9                        0xD20AC8
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_10                       0xD20ACC
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_11                       0xD20AD0
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_12                       0xD20AD4
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_13                       0xD20AD8
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_14                       0xD20ADC
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_15                       0xD20AE0
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_16                       0xD20AE4
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_17                       0xD20AE8
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_18                       0xD20AEC
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_19                       0xD20AF0
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_20                       0xD20AF4
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_21                       0xD20AF8
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_22                       0xD20AFC
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_23                       0xD20B00
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_24                       0xD20B04
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_25                       0xD20B08
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_26                       0xD20B0C
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_27                       0xD20B10
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_28                       0xD20B14
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_29                       0xD20B18
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_30                       0xD20B1C
+
+#define mmNIC1_QM0_ARB_MST_CHOISE_PUSH_OFST_31                       0xD20B20
+
+#define mmNIC1_QM0_ARB_SLV_MASTER_INC_CRED_OFST                      0xD20B28
+
+#define mmNIC1_QM0_ARB_MST_SLAVE_EN                                  0xD20B2C
+
+#define mmNIC1_QM0_ARB_MST_QUIET_PER                                 0xD20B34
+
+#define mmNIC1_QM0_ARB_SLV_CHOISE_WDT                                0xD20B38
+
+#define mmNIC1_QM0_ARB_SLV_ID                                        0xD20B3C
+
+#define mmNIC1_QM0_ARB_MSG_MAX_INFLIGHT                              0xD20B44
+
+#define mmNIC1_QM0_ARB_MSG_AWUSER_31_11                              0xD20B48
+
+#define mmNIC1_QM0_ARB_MSG_AWUSER_SEC_PROP                           0xD20B4C
+
+#define mmNIC1_QM0_ARB_MSG_AWUSER_NON_SEC_PROP                       0xD20B50
+
+#define mmNIC1_QM0_ARB_BASE_LO                                       0xD20B54
+
+#define mmNIC1_QM0_ARB_BASE_HI                                       0xD20B58
+
+#define mmNIC1_QM0_ARB_STATE_STS                                     0xD20B80
+
+#define mmNIC1_QM0_ARB_CHOISE_FULLNESS_STS                           0xD20B84
+
+#define mmNIC1_QM0_ARB_MSG_STS                                       0xD20B88
+
+#define mmNIC1_QM0_ARB_SLV_CHOISE_Q_HEAD                             0xD20B8C
+
+#define mmNIC1_QM0_ARB_ERR_CAUSE                                     0xD20B9C
+
+#define mmNIC1_QM0_ARB_ERR_MSG_EN                                    0xD20BA0
+
+#define mmNIC1_QM0_ARB_ERR_STS_DRP                                   0xD20BA8
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_0                                0xD20BB0
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_1                                0xD20BB4
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_2                                0xD20BB8
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_3                                0xD20BBC
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_4                                0xD20BC0
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_5                                0xD20BC4
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_6                                0xD20BC8
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_7                                0xD20BCC
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_8                                0xD20BD0
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_9                                0xD20BD4
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_10                               0xD20BD8
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_11                               0xD20BDC
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_12                               0xD20BE0
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_13                               0xD20BE4
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_14                               0xD20BE8
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_15                               0xD20BEC
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_16                               0xD20BF0
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_17                               0xD20BF4
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_18                               0xD20BF8
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_19                               0xD20BFC
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_20                               0xD20C00
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_21                               0xD20C04
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_22                               0xD20C08
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_23                               0xD20C0C
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_24                               0xD20C10
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_25                               0xD20C14
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_26                               0xD20C18
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_27                               0xD20C1C
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_28                               0xD20C20
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_29                               0xD20C24
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_30                               0xD20C28
+
+#define mmNIC1_QM0_ARB_MST_CRED_STS_31                               0xD20C2C
+
+#define mmNIC1_QM0_CGM_CFG                                           0xD20C70
+
+#define mmNIC1_QM0_CGM_STS                                           0xD20C74
+
+#define mmNIC1_QM0_CGM_CFG1                                          0xD20C78
+
+#define mmNIC1_QM0_LOCAL_RANGE_BASE                                  0xD20C80
+
+#define mmNIC1_QM0_LOCAL_RANGE_SIZE                                  0xD20C84
+
+#define mmNIC1_QM0_CSMR_STRICT_PRIO_CFG                              0xD20C90
+
+#define mmNIC1_QM0_HBW_RD_RATE_LIM_CFG_1                             0xD20C94
+
+#define mmNIC1_QM0_LBW_WR_RATE_LIM_CFG_0                             0xD20C98
+
+#define mmNIC1_QM0_LBW_WR_RATE_LIM_CFG_1                             0xD20C9C
+
+#define mmNIC1_QM0_HBW_RD_RATE_LIM_CFG_0                             0xD20CA0
+
+#define mmNIC1_QM0_GLBL_AXCACHE                                      0xD20CA4
+
+#define mmNIC1_QM0_IND_GW_APB_CFG                                    0xD20CB0
+
+#define mmNIC1_QM0_IND_GW_APB_WDATA                                  0xD20CB4
+
+#define mmNIC1_QM0_IND_GW_APB_RDATA                                  0xD20CB8
+
+#define mmNIC1_QM0_IND_GW_APB_STATUS                                 0xD20CBC
+
+#define mmNIC1_QM0_GLBL_ERR_ADDR_LO                                  0xD20CD0
+
+#define mmNIC1_QM0_GLBL_ERR_ADDR_HI                                  0xD20CD4
+
+#define mmNIC1_QM0_GLBL_ERR_WDATA                                    0xD20CD8
+
+#define mmNIC1_QM0_GLBL_MEM_INIT_BUSY                                0xD20D00
+
+#endif /* ASIC_REG_NIC1_QM0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
new file mode 100644
index 000000000000..1b115ee6d6f0
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC1_QM1_REGS_H_
+#define ASIC_REG_NIC1_QM1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC1_QM1 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC1_QM1_GLBL_CFG0                                         0xD22000
+
+#define mmNIC1_QM1_GLBL_CFG1                                         0xD22004
+
+#define mmNIC1_QM1_GLBL_PROT                                         0xD22008
+
+#define mmNIC1_QM1_GLBL_ERR_CFG                                      0xD2200C
+
+#define mmNIC1_QM1_GLBL_SECURE_PROPS_0                               0xD22010
+
+#define mmNIC1_QM1_GLBL_SECURE_PROPS_1                               0xD22014
+
+#define mmNIC1_QM1_GLBL_SECURE_PROPS_2                               0xD22018
+
+#define mmNIC1_QM1_GLBL_SECURE_PROPS_3                               0xD2201C
+
+#define mmNIC1_QM1_GLBL_SECURE_PROPS_4                               0xD22020
+
+#define mmNIC1_QM1_GLBL_NON_SECURE_PROPS_0                           0xD22024
+
+#define mmNIC1_QM1_GLBL_NON_SECURE_PROPS_1                           0xD22028
+
+#define mmNIC1_QM1_GLBL_NON_SECURE_PROPS_2                           0xD2202C
+
+#define mmNIC1_QM1_GLBL_NON_SECURE_PROPS_3                           0xD22030
+
+#define mmNIC1_QM1_GLBL_NON_SECURE_PROPS_4                           0xD22034
+
+#define mmNIC1_QM1_GLBL_STS0                                         0xD22038
+
+#define mmNIC1_QM1_GLBL_STS1_0                                       0xD22040
+
+#define mmNIC1_QM1_GLBL_STS1_1                                       0xD22044
+
+#define mmNIC1_QM1_GLBL_STS1_2                                       0xD22048
+
+#define mmNIC1_QM1_GLBL_STS1_3                                       0xD2204C
+
+#define mmNIC1_QM1_GLBL_STS1_4                                       0xD22050
+
+#define mmNIC1_QM1_GLBL_MSG_EN_0                                     0xD22054
+
+#define mmNIC1_QM1_GLBL_MSG_EN_1                                     0xD22058
+
+#define mmNIC1_QM1_GLBL_MSG_EN_2                                     0xD2205C
+
+#define mmNIC1_QM1_GLBL_MSG_EN_3                                     0xD22060
+
+#define mmNIC1_QM1_GLBL_MSG_EN_4                                     0xD22068
+
+#define mmNIC1_QM1_PQ_BASE_LO_0                                      0xD22070
+
+#define mmNIC1_QM1_PQ_BASE_LO_1                                      0xD22074
+
+#define mmNIC1_QM1_PQ_BASE_LO_2                                      0xD22078
+
+#define mmNIC1_QM1_PQ_BASE_LO_3                                      0xD2207C
+
+#define mmNIC1_QM1_PQ_BASE_HI_0                                      0xD22080
+
+#define mmNIC1_QM1_PQ_BASE_HI_1                                      0xD22084
+
+#define mmNIC1_QM1_PQ_BASE_HI_2                                      0xD22088
+
+#define mmNIC1_QM1_PQ_BASE_HI_3                                      0xD2208C
+
+#define mmNIC1_QM1_PQ_SIZE_0                                         0xD22090
+
+#define mmNIC1_QM1_PQ_SIZE_1                                         0xD22094
+
+#define mmNIC1_QM1_PQ_SIZE_2                                         0xD22098
+
+#define mmNIC1_QM1_PQ_SIZE_3                                         0xD2209C
+
+#define mmNIC1_QM1_PQ_PI_0                                           0xD220A0
+
+#define mmNIC1_QM1_PQ_PI_1                                           0xD220A4
+
+#define mmNIC1_QM1_PQ_PI_2                                           0xD220A8
+
+#define mmNIC1_QM1_PQ_PI_3                                           0xD220AC
+
+#define mmNIC1_QM1_PQ_CI_0                                           0xD220B0
+
+#define mmNIC1_QM1_PQ_CI_1                                           0xD220B4
+
+#define mmNIC1_QM1_PQ_CI_2                                           0xD220B8
+
+#define mmNIC1_QM1_PQ_CI_3                                           0xD220BC
+
+#define mmNIC1_QM1_PQ_CFG0_0                                         0xD220C0
+
+#define mmNIC1_QM1_PQ_CFG0_1                                         0xD220C4
+
+#define mmNIC1_QM1_PQ_CFG0_2                                         0xD220C8
+
+#define mmNIC1_QM1_PQ_CFG0_3                                         0xD220CC
+
+#define mmNIC1_QM1_PQ_CFG1_0                                         0xD220D0
+
+#define mmNIC1_QM1_PQ_CFG1_1                                         0xD220D4
+
+#define mmNIC1_QM1_PQ_CFG1_2                                         0xD220D8
+
+#define mmNIC1_QM1_PQ_CFG1_3                                         0xD220DC
+
+#define mmNIC1_QM1_PQ_ARUSER_31_11_0                                 0xD220E0
+
+#define mmNIC1_QM1_PQ_ARUSER_31_11_1                                 0xD220E4
+
+#define mmNIC1_QM1_PQ_ARUSER_31_11_2                                 0xD220E8
+
+#define mmNIC1_QM1_PQ_ARUSER_31_11_3                                 0xD220EC
+
+#define mmNIC1_QM1_PQ_STS0_0                                         0xD220F0
+
+#define mmNIC1_QM1_PQ_STS0_1                                         0xD220F4
+
+#define mmNIC1_QM1_PQ_STS0_2                                         0xD220F8
+
+#define mmNIC1_QM1_PQ_STS0_3                                         0xD220FC
+
+#define mmNIC1_QM1_PQ_STS1_0                                         0xD22100
+
+#define mmNIC1_QM1_PQ_STS1_1                                         0xD22104
+
+#define mmNIC1_QM1_PQ_STS1_2                                         0xD22108
+
+#define mmNIC1_QM1_PQ_STS1_3                                         0xD2210C
+
+#define mmNIC1_QM1_CQ_CFG0_0                                         0xD22110
+
+#define mmNIC1_QM1_CQ_CFG0_1                                         0xD22114
+
+#define mmNIC1_QM1_CQ_CFG0_2                                         0xD22118
+
+#define mmNIC1_QM1_CQ_CFG0_3                                         0xD2211C
+
+#define mmNIC1_QM1_CQ_CFG0_4                                         0xD22120
+
+#define mmNIC1_QM1_CQ_CFG1_0                                         0xD22124
+
+#define mmNIC1_QM1_CQ_CFG1_1                                         0xD22128
+
+#define mmNIC1_QM1_CQ_CFG1_2                                         0xD2212C
+
+#define mmNIC1_QM1_CQ_CFG1_3                                         0xD22130
+
+#define mmNIC1_QM1_CQ_CFG1_4                                         0xD22134
+
+#define mmNIC1_QM1_CQ_ARUSER_31_11_0                                 0xD22138
+
+#define mmNIC1_QM1_CQ_ARUSER_31_11_1                                 0xD2213C
+
+#define mmNIC1_QM1_CQ_ARUSER_31_11_2                                 0xD22140
+
+#define mmNIC1_QM1_CQ_ARUSER_31_11_3                                 0xD22144
+
+#define mmNIC1_QM1_CQ_ARUSER_31_11_4                                 0xD22148
+
+#define mmNIC1_QM1_CQ_STS0_0                                         0xD2214C
+
+#define mmNIC1_QM1_CQ_STS0_1                                         0xD22150
+
+#define mmNIC1_QM1_CQ_STS0_2                                         0xD22154
+
+#define mmNIC1_QM1_CQ_STS0_3                                         0xD22158
+
+#define mmNIC1_QM1_CQ_STS0_4                                         0xD2215C
+
+#define mmNIC1_QM1_CQ_STS1_0                                         0xD22160
+
+#define mmNIC1_QM1_CQ_STS1_1                                         0xD22164
+
+#define mmNIC1_QM1_CQ_STS1_2                                         0xD22168
+
+#define mmNIC1_QM1_CQ_STS1_3                                         0xD2216C
+
+#define mmNIC1_QM1_CQ_STS1_4                                         0xD22170
+
+#define mmNIC1_QM1_CQ_PTR_LO_0                                       0xD22174
+
+#define mmNIC1_QM1_CQ_PTR_HI_0                                       0xD22178
+
+#define mmNIC1_QM1_CQ_TSIZE_0                                        0xD2217C
+
+#define mmNIC1_QM1_CQ_CTL_0                                          0xD22180
+
+#define mmNIC1_QM1_CQ_PTR_LO_1                                       0xD22184
+
+#define mmNIC1_QM1_CQ_PTR_HI_1                                       0xD22188
+
+#define mmNIC1_QM1_CQ_TSIZE_1                                        0xD2218C
+
+#define mmNIC1_QM1_CQ_CTL_1                                          0xD22190
+
+#define mmNIC1_QM1_CQ_PTR_LO_2                                       0xD22194
+
+#define mmNIC1_QM1_CQ_PTR_HI_2                                       0xD22198
+
+#define mmNIC1_QM1_CQ_TSIZE_2                                        0xD2219C
+
+#define mmNIC1_QM1_CQ_CTL_2                                          0xD221A0
+
+#define mmNIC1_QM1_CQ_PTR_LO_3                                       0xD221A4
+
+#define mmNIC1_QM1_CQ_PTR_HI_3                                       0xD221A8
+
+#define mmNIC1_QM1_CQ_TSIZE_3                                        0xD221AC
+
+#define mmNIC1_QM1_CQ_CTL_3                                          0xD221B0
+
+#define mmNIC1_QM1_CQ_PTR_LO_4                                       0xD221B4
+
+#define mmNIC1_QM1_CQ_PTR_HI_4                                       0xD221B8
+
+#define mmNIC1_QM1_CQ_TSIZE_4                                        0xD221BC
+
+#define mmNIC1_QM1_CQ_CTL_4                                          0xD221C0
+
+#define mmNIC1_QM1_CQ_PTR_LO_STS_0                                   0xD221C4
+
+#define mmNIC1_QM1_CQ_PTR_LO_STS_1                                   0xD221C8
+
+#define mmNIC1_QM1_CQ_PTR_LO_STS_2                                   0xD221CC
+
+#define mmNIC1_QM1_CQ_PTR_LO_STS_3                                   0xD221D0
+
+#define mmNIC1_QM1_CQ_PTR_LO_STS_4                                   0xD221D4
+
+#define mmNIC1_QM1_CQ_PTR_HI_STS_0                                   0xD221D8
+
+#define mmNIC1_QM1_CQ_PTR_HI_STS_1                                   0xD221DC
+
+#define mmNIC1_QM1_CQ_PTR_HI_STS_2                                   0xD221E0
+
+#define mmNIC1_QM1_CQ_PTR_HI_STS_3                                   0xD221E4
+
+#define mmNIC1_QM1_CQ_PTR_HI_STS_4                                   0xD221E8
+
+#define mmNIC1_QM1_CQ_TSIZE_STS_0                                    0xD221EC
+
+#define mmNIC1_QM1_CQ_TSIZE_STS_1                                    0xD221F0
+
+#define mmNIC1_QM1_CQ_TSIZE_STS_2                                    0xD221F4
+
+#define mmNIC1_QM1_CQ_TSIZE_STS_3                                    0xD221F8
+
+#define mmNIC1_QM1_CQ_TSIZE_STS_4                                    0xD221FC
+
+#define mmNIC1_QM1_CQ_CTL_STS_0                                      0xD22200
+
+#define mmNIC1_QM1_CQ_CTL_STS_1                                      0xD22204
+
+#define mmNIC1_QM1_CQ_CTL_STS_2                                      0xD22208
+
+#define mmNIC1_QM1_CQ_CTL_STS_3                                      0xD2220C
+
+#define mmNIC1_QM1_CQ_CTL_STS_4                                      0xD22210
+
+#define mmNIC1_QM1_CQ_IFIFO_CNT_0                                    0xD22214
+
+#define mmNIC1_QM1_CQ_IFIFO_CNT_1                                    0xD22218
+
+#define mmNIC1_QM1_CQ_IFIFO_CNT_2                                    0xD2221C
+
+#define mmNIC1_QM1_CQ_IFIFO_CNT_3                                    0xD22220
+
+#define mmNIC1_QM1_CQ_IFIFO_CNT_4                                    0xD22224
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_0                            0xD22228
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_1                            0xD2222C
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_2                            0xD22230
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_3                            0xD22234
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_LO_4                            0xD22238
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_0                            0xD2223C
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_1                            0xD22240
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_2                            0xD22244
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_3                            0xD22248
+
+#define mmNIC1_QM1_CP_MSG_BASE0_ADDR_HI_4                            0xD2224C
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_0                            0xD22250
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_1                            0xD22254
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_2                            0xD22258
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_3                            0xD2225C
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_LO_4                            0xD22260
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_0                            0xD22264
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_1                            0xD22268
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_2                            0xD2226C
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_3                            0xD22270
+
+#define mmNIC1_QM1_CP_MSG_BASE1_ADDR_HI_4                            0xD22274
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_0                            0xD22278
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_1                            0xD2227C
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_2                            0xD22280
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_3                            0xD22284
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_LO_4                            0xD22288
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_0                            0xD2228C
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_1                            0xD22290
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_2                            0xD22294
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_3                            0xD22298
+
+#define mmNIC1_QM1_CP_MSG_BASE2_ADDR_HI_4                            0xD2229C
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_0                            0xD222A0
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_1                            0xD222A4
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_2                            0xD222A8
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_3                            0xD222AC
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_LO_4                            0xD222B0
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_0                            0xD222B4
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_1                            0xD222B8
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_2                            0xD222BC
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_3                            0xD222C0
+
+#define mmNIC1_QM1_CP_MSG_BASE3_ADDR_HI_4                            0xD222C4
+
+#define mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_0                            0xD222C8
+
+#define mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_1                            0xD222CC
+
+#define mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_2                            0xD222D0
+
+#define mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_3                            0xD222D4
+
+#define mmNIC1_QM1_CP_LDMA_TSIZE_OFFSET_4                            0xD222D8
+
+#define mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xD222E0
+
+#define mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xD222E4
+
+#define mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xD222E8
+
+#define mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xD222EC
+
+#define mmNIC1_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xD222F0
+
+#define mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xD222F4
+
+#define mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xD222F8
+
+#define mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xD222FC
+
+#define mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xD22300
+
+#define mmNIC1_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xD22304
+
+#define mmNIC1_QM1_CP_FENCE0_RDATA_0                                 0xD22308
+
+#define mmNIC1_QM1_CP_FENCE0_RDATA_1                                 0xD2230C
+
+#define mmNIC1_QM1_CP_FENCE0_RDATA_2                                 0xD22310
+
+#define mmNIC1_QM1_CP_FENCE0_RDATA_3                                 0xD22314
+
+#define mmNIC1_QM1_CP_FENCE0_RDATA_4                                 0xD22318
+
+#define mmNIC1_QM1_CP_FENCE1_RDATA_0                                 0xD2231C
+
+#define mmNIC1_QM1_CP_FENCE1_RDATA_1                                 0xD22320
+
+#define mmNIC1_QM1_CP_FENCE1_RDATA_2                                 0xD22324
+
+#define mmNIC1_QM1_CP_FENCE1_RDATA_3                                 0xD22328
+
+#define mmNIC1_QM1_CP_FENCE1_RDATA_4                                 0xD2232C
+
+#define mmNIC1_QM1_CP_FENCE2_RDATA_0                                 0xD22330
+
+#define mmNIC1_QM1_CP_FENCE2_RDATA_1                                 0xD22334
+
+#define mmNIC1_QM1_CP_FENCE2_RDATA_2                                 0xD22338
+
+#define mmNIC1_QM1_CP_FENCE2_RDATA_3                                 0xD2233C
+
+#define mmNIC1_QM1_CP_FENCE2_RDATA_4                                 0xD22340
+
+#define mmNIC1_QM1_CP_FENCE3_RDATA_0                                 0xD22344
+
+#define mmNIC1_QM1_CP_FENCE3_RDATA_1                                 0xD22348
+
+#define mmNIC1_QM1_CP_FENCE3_RDATA_2                                 0xD2234C
+
+#define mmNIC1_QM1_CP_FENCE3_RDATA_3                                 0xD22350
+
+#define mmNIC1_QM1_CP_FENCE3_RDATA_4                                 0xD22354
+
+#define mmNIC1_QM1_CP_FENCE0_CNT_0                                   0xD22358
+
+#define mmNIC1_QM1_CP_FENCE0_CNT_1                                   0xD2235C
+
+#define mmNIC1_QM1_CP_FENCE0_CNT_2                                   0xD22360
+
+#define mmNIC1_QM1_CP_FENCE0_CNT_3                                   0xD22364
+
+#define mmNIC1_QM1_CP_FENCE0_CNT_4                                   0xD22368
+
+#define mmNIC1_QM1_CP_FENCE1_CNT_0                                   0xD2236C
+
+#define mmNIC1_QM1_CP_FENCE1_CNT_1                                   0xD22370
+
+#define mmNIC1_QM1_CP_FENCE1_CNT_2                                   0xD22374
+
+#define mmNIC1_QM1_CP_FENCE1_CNT_3                                   0xD22378
+
+#define mmNIC1_QM1_CP_FENCE1_CNT_4                                   0xD2237C
+
+#define mmNIC1_QM1_CP_FENCE2_CNT_0                                   0xD22380
+
+#define mmNIC1_QM1_CP_FENCE2_CNT_1                                   0xD22384
+
+#define mmNIC1_QM1_CP_FENCE2_CNT_2                                   0xD22388
+
+#define mmNIC1_QM1_CP_FENCE2_CNT_3                                   0xD2238C
+
+#define mmNIC1_QM1_CP_FENCE2_CNT_4                                   0xD22390
+
+#define mmNIC1_QM1_CP_FENCE3_CNT_0                                   0xD22394
+
+#define mmNIC1_QM1_CP_FENCE3_CNT_1                                   0xD22398
+
+#define mmNIC1_QM1_CP_FENCE3_CNT_2                                   0xD2239C
+
+#define mmNIC1_QM1_CP_FENCE3_CNT_3                                   0xD223A0
+
+#define mmNIC1_QM1_CP_FENCE3_CNT_4                                   0xD223A4
+
+#define mmNIC1_QM1_CP_STS_0                                          0xD223A8
+
+#define mmNIC1_QM1_CP_STS_1                                          0xD223AC
+
+#define mmNIC1_QM1_CP_STS_2                                          0xD223B0
+
+#define mmNIC1_QM1_CP_STS_3                                          0xD223B4
+
+#define mmNIC1_QM1_CP_STS_4                                          0xD223B8
+
+#define mmNIC1_QM1_CP_CURRENT_INST_LO_0                              0xD223BC
+
+#define mmNIC1_QM1_CP_CURRENT_INST_LO_1                              0xD223C0
+
+#define mmNIC1_QM1_CP_CURRENT_INST_LO_2                              0xD223C4
+
+#define mmNIC1_QM1_CP_CURRENT_INST_LO_3                              0xD223C8
+
+#define mmNIC1_QM1_CP_CURRENT_INST_LO_4                              0xD223CC
+
+#define mmNIC1_QM1_CP_CURRENT_INST_HI_0                              0xD223D0
+
+#define mmNIC1_QM1_CP_CURRENT_INST_HI_1                              0xD223D4
+
+#define mmNIC1_QM1_CP_CURRENT_INST_HI_2                              0xD223D8
+
+#define mmNIC1_QM1_CP_CURRENT_INST_HI_3                              0xD223DC
+
+#define mmNIC1_QM1_CP_CURRENT_INST_HI_4                              0xD223E0
+
+#define mmNIC1_QM1_CP_BARRIER_CFG_0                                  0xD223F4
+
+#define mmNIC1_QM1_CP_BARRIER_CFG_1                                  0xD223F8
+
+#define mmNIC1_QM1_CP_BARRIER_CFG_2                                  0xD223FC
+
+#define mmNIC1_QM1_CP_BARRIER_CFG_3                                  0xD22400
+
+#define mmNIC1_QM1_CP_BARRIER_CFG_4                                  0xD22404
+
+#define mmNIC1_QM1_CP_DBG_0_0                                        0xD22408
+
+#define mmNIC1_QM1_CP_DBG_0_1                                        0xD2240C
+
+#define mmNIC1_QM1_CP_DBG_0_2                                        0xD22410
+
+#define mmNIC1_QM1_CP_DBG_0_3                                        0xD22414
+
+#define mmNIC1_QM1_CP_DBG_0_4                                        0xD22418
+
+#define mmNIC1_QM1_CP_ARUSER_31_11_0                                 0xD2241C
+
+#define mmNIC1_QM1_CP_ARUSER_31_11_1                                 0xD22420
+
+#define mmNIC1_QM1_CP_ARUSER_31_11_2                                 0xD22424
+
+#define mmNIC1_QM1_CP_ARUSER_31_11_3                                 0xD22428
+
+#define mmNIC1_QM1_CP_ARUSER_31_11_4                                 0xD2242C
+
+#define mmNIC1_QM1_CP_AWUSER_31_11_0                                 0xD22430
+
+#define mmNIC1_QM1_CP_AWUSER_31_11_1                                 0xD22434
+
+#define mmNIC1_QM1_CP_AWUSER_31_11_2                                 0xD22438
+
+#define mmNIC1_QM1_CP_AWUSER_31_11_3                                 0xD2243C
+
+#define mmNIC1_QM1_CP_AWUSER_31_11_4                                 0xD22440
+
+#define mmNIC1_QM1_ARB_CFG_0                                         0xD22A00
+
+#define mmNIC1_QM1_ARB_CHOISE_Q_PUSH                                 0xD22A04
+
+#define mmNIC1_QM1_ARB_WRR_WEIGHT_0                                  0xD22A08
+
+#define mmNIC1_QM1_ARB_WRR_WEIGHT_1                                  0xD22A0C
+
+#define mmNIC1_QM1_ARB_WRR_WEIGHT_2                                  0xD22A10
+
+#define mmNIC1_QM1_ARB_WRR_WEIGHT_3                                  0xD22A14
+
+#define mmNIC1_QM1_ARB_CFG_1                                         0xD22A18
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_0                              0xD22A20
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_1                              0xD22A24
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_2                              0xD22A28
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_3                              0xD22A2C
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_4                              0xD22A30
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_5                              0xD22A34
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_6                              0xD22A38
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_7                              0xD22A3C
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_8                              0xD22A40
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_9                              0xD22A44
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_10                             0xD22A48
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_11                             0xD22A4C
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_12                             0xD22A50
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_13                             0xD22A54
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_14                             0xD22A58
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_15                             0xD22A5C
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_16                             0xD22A60
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_17                             0xD22A64
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_18                             0xD22A68
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_19                             0xD22A6C
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_20                             0xD22A70
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_21                             0xD22A74
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_22                             0xD22A78
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_23                             0xD22A7C
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_24                             0xD22A80
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_25                             0xD22A84
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_26                             0xD22A88
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_27                             0xD22A8C
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_28                             0xD22A90
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_29                             0xD22A94
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_30                             0xD22A98
+
+#define mmNIC1_QM1_ARB_MST_AVAIL_CRED_31                             0xD22A9C
+
+#define mmNIC1_QM1_ARB_MST_CRED_INC                                  0xD22AA0
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_0                        0xD22AA4
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_1                        0xD22AA8
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_2                        0xD22AAC
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_3                        0xD22AB0
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_4                        0xD22AB4
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_5                        0xD22AB8
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_6                        0xD22ABC
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_7                        0xD22AC0
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_8                        0xD22AC4
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_9                        0xD22AC8
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_10                       0xD22ACC
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_11                       0xD22AD0
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_12                       0xD22AD4
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_13                       0xD22AD8
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_14                       0xD22ADC
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_15                       0xD22AE0
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_16                       0xD22AE4
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_17                       0xD22AE8
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_18                       0xD22AEC
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_19                       0xD22AF0
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_20                       0xD22AF4
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_21                       0xD22AF8
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_22                       0xD22AFC
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_23                       0xD22B00
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_24                       0xD22B04
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_25                       0xD22B08
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_26                       0xD22B0C
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_27                       0xD22B10
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_28                       0xD22B14
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_29                       0xD22B18
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_30                       0xD22B1C
+
+#define mmNIC1_QM1_ARB_MST_CHOISE_PUSH_OFST_31                       0xD22B20
+
+#define mmNIC1_QM1_ARB_SLV_MASTER_INC_CRED_OFST                      0xD22B28
+
+#define mmNIC1_QM1_ARB_MST_SLAVE_EN                                  0xD22B2C
+
+#define mmNIC1_QM1_ARB_MST_QUIET_PER                                 0xD22B34
+
+#define mmNIC1_QM1_ARB_SLV_CHOISE_WDT                                0xD22B38
+
+#define mmNIC1_QM1_ARB_SLV_ID                                        0xD22B3C
+
+#define mmNIC1_QM1_ARB_MSG_MAX_INFLIGHT                              0xD22B44
+
+#define mmNIC1_QM1_ARB_MSG_AWUSER_31_11                              0xD22B48
+
+#define mmNIC1_QM1_ARB_MSG_AWUSER_SEC_PROP                           0xD22B4C
+
+#define mmNIC1_QM1_ARB_MSG_AWUSER_NON_SEC_PROP                       0xD22B50
+
+#define mmNIC1_QM1_ARB_BASE_LO                                       0xD22B54
+
+#define mmNIC1_QM1_ARB_BASE_HI                                       0xD22B58
+
+#define mmNIC1_QM1_ARB_STATE_STS                                     0xD22B80
+
+#define mmNIC1_QM1_ARB_CHOISE_FULLNESS_STS                           0xD22B84
+
+#define mmNIC1_QM1_ARB_MSG_STS                                       0xD22B88
+
+#define mmNIC1_QM1_ARB_SLV_CHOISE_Q_HEAD                             0xD22B8C
+
+#define mmNIC1_QM1_ARB_ERR_CAUSE                                     0xD22B9C
+
+#define mmNIC1_QM1_ARB_ERR_MSG_EN                                    0xD22BA0
+
+#define mmNIC1_QM1_ARB_ERR_STS_DRP                                   0xD22BA8
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_0                                0xD22BB0
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_1                                0xD22BB4
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_2                                0xD22BB8
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_3                                0xD22BBC
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_4                                0xD22BC0
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_5                                0xD22BC4
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_6                                0xD22BC8
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_7                                0xD22BCC
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_8                                0xD22BD0
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_9                                0xD22BD4
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_10                               0xD22BD8
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_11                               0xD22BDC
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_12                               0xD22BE0
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_13                               0xD22BE4
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_14                               0xD22BE8
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_15                               0xD22BEC
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_16                               0xD22BF0
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_17                               0xD22BF4
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_18                               0xD22BF8
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_19                               0xD22BFC
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_20                               0xD22C00
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_21                               0xD22C04
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_22                               0xD22C08
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_23                               0xD22C0C
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_24                               0xD22C10
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_25                               0xD22C14
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_26                               0xD22C18
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_27                               0xD22C1C
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_28                               0xD22C20
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_29                               0xD22C24
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_30                               0xD22C28
+
+#define mmNIC1_QM1_ARB_MST_CRED_STS_31                               0xD22C2C
+
+#define mmNIC1_QM1_CGM_CFG                                           0xD22C70
+
+#define mmNIC1_QM1_CGM_STS                                           0xD22C74
+
+#define mmNIC1_QM1_CGM_CFG1                                          0xD22C78
+
+#define mmNIC1_QM1_LOCAL_RANGE_BASE                                  0xD22C80
+
+#define mmNIC1_QM1_LOCAL_RANGE_SIZE                                  0xD22C84
+
+#define mmNIC1_QM1_CSMR_STRICT_PRIO_CFG                              0xD22C90
+
+#define mmNIC1_QM1_HBW_RD_RATE_LIM_CFG_1                             0xD22C94
+
+#define mmNIC1_QM1_LBW_WR_RATE_LIM_CFG_0                             0xD22C98
+
+#define mmNIC1_QM1_LBW_WR_RATE_LIM_CFG_1                             0xD22C9C
+
+#define mmNIC1_QM1_HBW_RD_RATE_LIM_CFG_0                             0xD22CA0
+
+#define mmNIC1_QM1_GLBL_AXCACHE                                      0xD22CA4
+
+#define mmNIC1_QM1_IND_GW_APB_CFG                                    0xD22CB0
+
+#define mmNIC1_QM1_IND_GW_APB_WDATA                                  0xD22CB4
+
+#define mmNIC1_QM1_IND_GW_APB_RDATA                                  0xD22CB8
+
+#define mmNIC1_QM1_IND_GW_APB_STATUS                                 0xD22CBC
+
+#define mmNIC1_QM1_GLBL_ERR_ADDR_LO                                  0xD22CD0
+
+#define mmNIC1_QM1_GLBL_ERR_ADDR_HI                                  0xD22CD4
+
+#define mmNIC1_QM1_GLBL_ERR_WDATA                                    0xD22CD8
+
+#define mmNIC1_QM1_GLBL_MEM_INIT_BUSY                                0xD22D00
+
+#endif /* ASIC_REG_NIC1_QM1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
new file mode 100644
index 000000000000..a89116a4586f
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC2_QM0_REGS_H_
+#define ASIC_REG_NIC2_QM0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC2_QM0 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC2_QM0_GLBL_CFG0                                         0xD60000
+
+#define mmNIC2_QM0_GLBL_CFG1                                         0xD60004
+
+#define mmNIC2_QM0_GLBL_PROT                                         0xD60008
+
+#define mmNIC2_QM0_GLBL_ERR_CFG                                      0xD6000C
+
+#define mmNIC2_QM0_GLBL_SECURE_PROPS_0                               0xD60010
+
+#define mmNIC2_QM0_GLBL_SECURE_PROPS_1                               0xD60014
+
+#define mmNIC2_QM0_GLBL_SECURE_PROPS_2                               0xD60018
+
+#define mmNIC2_QM0_GLBL_SECURE_PROPS_3                               0xD6001C
+
+#define mmNIC2_QM0_GLBL_SECURE_PROPS_4                               0xD60020
+
+#define mmNIC2_QM0_GLBL_NON_SECURE_PROPS_0                           0xD60024
+
+#define mmNIC2_QM0_GLBL_NON_SECURE_PROPS_1                           0xD60028
+
+#define mmNIC2_QM0_GLBL_NON_SECURE_PROPS_2                           0xD6002C
+
+#define mmNIC2_QM0_GLBL_NON_SECURE_PROPS_3                           0xD60030
+
+#define mmNIC2_QM0_GLBL_NON_SECURE_PROPS_4                           0xD60034
+
+#define mmNIC2_QM0_GLBL_STS0                                         0xD60038
+
+#define mmNIC2_QM0_GLBL_STS1_0                                       0xD60040
+
+#define mmNIC2_QM0_GLBL_STS1_1                                       0xD60044
+
+#define mmNIC2_QM0_GLBL_STS1_2                                       0xD60048
+
+#define mmNIC2_QM0_GLBL_STS1_3                                       0xD6004C
+
+#define mmNIC2_QM0_GLBL_STS1_4                                       0xD60050
+
+#define mmNIC2_QM0_GLBL_MSG_EN_0                                     0xD60054
+
+#define mmNIC2_QM0_GLBL_MSG_EN_1                                     0xD60058
+
+#define mmNIC2_QM0_GLBL_MSG_EN_2                                     0xD6005C
+
+#define mmNIC2_QM0_GLBL_MSG_EN_3                                     0xD60060
+
+#define mmNIC2_QM0_GLBL_MSG_EN_4                                     0xD60068
+
+#define mmNIC2_QM0_PQ_BASE_LO_0                                      0xD60070
+
+#define mmNIC2_QM0_PQ_BASE_LO_1                                      0xD60074
+
+#define mmNIC2_QM0_PQ_BASE_LO_2                                      0xD60078
+
+#define mmNIC2_QM0_PQ_BASE_LO_3                                      0xD6007C
+
+#define mmNIC2_QM0_PQ_BASE_HI_0                                      0xD60080
+
+#define mmNIC2_QM0_PQ_BASE_HI_1                                      0xD60084
+
+#define mmNIC2_QM0_PQ_BASE_HI_2                                      0xD60088
+
+#define mmNIC2_QM0_PQ_BASE_HI_3                                      0xD6008C
+
+#define mmNIC2_QM0_PQ_SIZE_0                                         0xD60090
+
+#define mmNIC2_QM0_PQ_SIZE_1                                         0xD60094
+
+#define mmNIC2_QM0_PQ_SIZE_2                                         0xD60098
+
+#define mmNIC2_QM0_PQ_SIZE_3                                         0xD6009C
+
+#define mmNIC2_QM0_PQ_PI_0                                           0xD600A0
+
+#define mmNIC2_QM0_PQ_PI_1                                           0xD600A4
+
+#define mmNIC2_QM0_PQ_PI_2                                           0xD600A8
+
+#define mmNIC2_QM0_PQ_PI_3                                           0xD600AC
+
+#define mmNIC2_QM0_PQ_CI_0                                           0xD600B0
+
+#define mmNIC2_QM0_PQ_CI_1                                           0xD600B4
+
+#define mmNIC2_QM0_PQ_CI_2                                           0xD600B8
+
+#define mmNIC2_QM0_PQ_CI_3                                           0xD600BC
+
+#define mmNIC2_QM0_PQ_CFG0_0                                         0xD600C0
+
+#define mmNIC2_QM0_PQ_CFG0_1                                         0xD600C4
+
+#define mmNIC2_QM0_PQ_CFG0_2                                         0xD600C8
+
+#define mmNIC2_QM0_PQ_CFG0_3                                         0xD600CC
+
+#define mmNIC2_QM0_PQ_CFG1_0                                         0xD600D0
+
+#define mmNIC2_QM0_PQ_CFG1_1                                         0xD600D4
+
+#define mmNIC2_QM0_PQ_CFG1_2                                         0xD600D8
+
+#define mmNIC2_QM0_PQ_CFG1_3                                         0xD600DC
+
+#define mmNIC2_QM0_PQ_ARUSER_31_11_0                                 0xD600E0
+
+#define mmNIC2_QM0_PQ_ARUSER_31_11_1                                 0xD600E4
+
+#define mmNIC2_QM0_PQ_ARUSER_31_11_2                                 0xD600E8
+
+#define mmNIC2_QM0_PQ_ARUSER_31_11_3                                 0xD600EC
+
+#define mmNIC2_QM0_PQ_STS0_0                                         0xD600F0
+
+#define mmNIC2_QM0_PQ_STS0_1                                         0xD600F4
+
+#define mmNIC2_QM0_PQ_STS0_2                                         0xD600F8
+
+#define mmNIC2_QM0_PQ_STS0_3                                         0xD600FC
+
+#define mmNIC2_QM0_PQ_STS1_0                                         0xD60100
+
+#define mmNIC2_QM0_PQ_STS1_1                                         0xD60104
+
+#define mmNIC2_QM0_PQ_STS1_2                                         0xD60108
+
+#define mmNIC2_QM0_PQ_STS1_3                                         0xD6010C
+
+#define mmNIC2_QM0_CQ_CFG0_0                                         0xD60110
+
+#define mmNIC2_QM0_CQ_CFG0_1                                         0xD60114
+
+#define mmNIC2_QM0_CQ_CFG0_2                                         0xD60118
+
+#define mmNIC2_QM0_CQ_CFG0_3                                         0xD6011C
+
+#define mmNIC2_QM0_CQ_CFG0_4                                         0xD60120
+
+#define mmNIC2_QM0_CQ_CFG1_0                                         0xD60124
+
+#define mmNIC2_QM0_CQ_CFG1_1                                         0xD60128
+
+#define mmNIC2_QM0_CQ_CFG1_2                                         0xD6012C
+
+#define mmNIC2_QM0_CQ_CFG1_3                                         0xD60130
+
+#define mmNIC2_QM0_CQ_CFG1_4                                         0xD60134
+
+#define mmNIC2_QM0_CQ_ARUSER_31_11_0                                 0xD60138
+
+#define mmNIC2_QM0_CQ_ARUSER_31_11_1                                 0xD6013C
+
+#define mmNIC2_QM0_CQ_ARUSER_31_11_2                                 0xD60140
+
+#define mmNIC2_QM0_CQ_ARUSER_31_11_3                                 0xD60144
+
+#define mmNIC2_QM0_CQ_ARUSER_31_11_4                                 0xD60148
+
+#define mmNIC2_QM0_CQ_STS0_0                                         0xD6014C
+
+#define mmNIC2_QM0_CQ_STS0_1                                         0xD60150
+
+#define mmNIC2_QM0_CQ_STS0_2                                         0xD60154
+
+#define mmNIC2_QM0_CQ_STS0_3                                         0xD60158
+
+#define mmNIC2_QM0_CQ_STS0_4                                         0xD6015C
+
+#define mmNIC2_QM0_CQ_STS1_0                                         0xD60160
+
+#define mmNIC2_QM0_CQ_STS1_1                                         0xD60164
+
+#define mmNIC2_QM0_CQ_STS1_2                                         0xD60168
+
+#define mmNIC2_QM0_CQ_STS1_3                                         0xD6016C
+
+#define mmNIC2_QM0_CQ_STS1_4                                         0xD60170
+
+#define mmNIC2_QM0_CQ_PTR_LO_0                                       0xD60174
+
+#define mmNIC2_QM0_CQ_PTR_HI_0                                       0xD60178
+
+#define mmNIC2_QM0_CQ_TSIZE_0                                        0xD6017C
+
+#define mmNIC2_QM0_CQ_CTL_0                                          0xD60180
+
+#define mmNIC2_QM0_CQ_PTR_LO_1                                       0xD60184
+
+#define mmNIC2_QM0_CQ_PTR_HI_1                                       0xD60188
+
+#define mmNIC2_QM0_CQ_TSIZE_1                                        0xD6018C
+
+#define mmNIC2_QM0_CQ_CTL_1                                          0xD60190
+
+#define mmNIC2_QM0_CQ_PTR_LO_2                                       0xD60194
+
+#define mmNIC2_QM0_CQ_PTR_HI_2                                       0xD60198
+
+#define mmNIC2_QM0_CQ_TSIZE_2                                        0xD6019C
+
+#define mmNIC2_QM0_CQ_CTL_2                                          0xD601A0
+
+#define mmNIC2_QM0_CQ_PTR_LO_3                                       0xD601A4
+
+#define mmNIC2_QM0_CQ_PTR_HI_3                                       0xD601A8
+
+#define mmNIC2_QM0_CQ_TSIZE_3                                        0xD601AC
+
+#define mmNIC2_QM0_CQ_CTL_3                                          0xD601B0
+
+#define mmNIC2_QM0_CQ_PTR_LO_4                                       0xD601B4
+
+#define mmNIC2_QM0_CQ_PTR_HI_4                                       0xD601B8
+
+#define mmNIC2_QM0_CQ_TSIZE_4                                        0xD601BC
+
+#define mmNIC2_QM0_CQ_CTL_4                                          0xD601C0
+
+#define mmNIC2_QM0_CQ_PTR_LO_STS_0                                   0xD601C4
+
+#define mmNIC2_QM0_CQ_PTR_LO_STS_1                                   0xD601C8
+
+#define mmNIC2_QM0_CQ_PTR_LO_STS_2                                   0xD601CC
+
+#define mmNIC2_QM0_CQ_PTR_LO_STS_3                                   0xD601D0
+
+#define mmNIC2_QM0_CQ_PTR_LO_STS_4                                   0xD601D4
+
+#define mmNIC2_QM0_CQ_PTR_HI_STS_0                                   0xD601D8
+
+#define mmNIC2_QM0_CQ_PTR_HI_STS_1                                   0xD601DC
+
+#define mmNIC2_QM0_CQ_PTR_HI_STS_2                                   0xD601E0
+
+#define mmNIC2_QM0_CQ_PTR_HI_STS_3                                   0xD601E4
+
+#define mmNIC2_QM0_CQ_PTR_HI_STS_4                                   0xD601E8
+
+#define mmNIC2_QM0_CQ_TSIZE_STS_0                                    0xD601EC
+
+#define mmNIC2_QM0_CQ_TSIZE_STS_1                                    0xD601F0
+
+#define mmNIC2_QM0_CQ_TSIZE_STS_2                                    0xD601F4
+
+#define mmNIC2_QM0_CQ_TSIZE_STS_3                                    0xD601F8
+
+#define mmNIC2_QM0_CQ_TSIZE_STS_4                                    0xD601FC
+
+#define mmNIC2_QM0_CQ_CTL_STS_0                                      0xD60200
+
+#define mmNIC2_QM0_CQ_CTL_STS_1                                      0xD60204
+
+#define mmNIC2_QM0_CQ_CTL_STS_2                                      0xD60208
+
+#define mmNIC2_QM0_CQ_CTL_STS_3                                      0xD6020C
+
+#define mmNIC2_QM0_CQ_CTL_STS_4                                      0xD60210
+
+#define mmNIC2_QM0_CQ_IFIFO_CNT_0                                    0xD60214
+
+#define mmNIC2_QM0_CQ_IFIFO_CNT_1                                    0xD60218
+
+#define mmNIC2_QM0_CQ_IFIFO_CNT_2                                    0xD6021C
+
+#define mmNIC2_QM0_CQ_IFIFO_CNT_3                                    0xD60220
+
+#define mmNIC2_QM0_CQ_IFIFO_CNT_4                                    0xD60224
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_0                            0xD60228
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_1                            0xD6022C
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_2                            0xD60230
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_3                            0xD60234
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_LO_4                            0xD60238
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_0                            0xD6023C
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_1                            0xD60240
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_2                            0xD60244
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_3                            0xD60248
+
+#define mmNIC2_QM0_CP_MSG_BASE0_ADDR_HI_4                            0xD6024C
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_0                            0xD60250
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_1                            0xD60254
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_2                            0xD60258
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_3                            0xD6025C
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_LO_4                            0xD60260
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_0                            0xD60264
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_1                            0xD60268
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_2                            0xD6026C
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_3                            0xD60270
+
+#define mmNIC2_QM0_CP_MSG_BASE1_ADDR_HI_4                            0xD60274
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_0                            0xD60278
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_1                            0xD6027C
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_2                            0xD60280
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_3                            0xD60284
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_LO_4                            0xD60288
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_0                            0xD6028C
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_1                            0xD60290
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_2                            0xD60294
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_3                            0xD60298
+
+#define mmNIC2_QM0_CP_MSG_BASE2_ADDR_HI_4                            0xD6029C
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_0                            0xD602A0
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_1                            0xD602A4
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_2                            0xD602A8
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_3                            0xD602AC
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_LO_4                            0xD602B0
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_0                            0xD602B4
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_1                            0xD602B8
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_2                            0xD602BC
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_3                            0xD602C0
+
+#define mmNIC2_QM0_CP_MSG_BASE3_ADDR_HI_4                            0xD602C4
+
+#define mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_0                            0xD602C8
+
+#define mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_1                            0xD602CC
+
+#define mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_2                            0xD602D0
+
+#define mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_3                            0xD602D4
+
+#define mmNIC2_QM0_CP_LDMA_TSIZE_OFFSET_4                            0xD602D8
+
+#define mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xD602E0
+
+#define mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xD602E4
+
+#define mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xD602E8
+
+#define mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xD602EC
+
+#define mmNIC2_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xD602F0
+
+#define mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xD602F4
+
+#define mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xD602F8
+
+#define mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xD602FC
+
+#define mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xD60300
+
+#define mmNIC2_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xD60304
+
+#define mmNIC2_QM0_CP_FENCE0_RDATA_0                                 0xD60308
+
+#define mmNIC2_QM0_CP_FENCE0_RDATA_1                                 0xD6030C
+
+#define mmNIC2_QM0_CP_FENCE0_RDATA_2                                 0xD60310
+
+#define mmNIC2_QM0_CP_FENCE0_RDATA_3                                 0xD60314
+
+#define mmNIC2_QM0_CP_FENCE0_RDATA_4                                 0xD60318
+
+#define mmNIC2_QM0_CP_FENCE1_RDATA_0                                 0xD6031C
+
+#define mmNIC2_QM0_CP_FENCE1_RDATA_1                                 0xD60320
+
+#define mmNIC2_QM0_CP_FENCE1_RDATA_2                                 0xD60324
+
+#define mmNIC2_QM0_CP_FENCE1_RDATA_3                                 0xD60328
+
+#define mmNIC2_QM0_CP_FENCE1_RDATA_4                                 0xD6032C
+
+#define mmNIC2_QM0_CP_FENCE2_RDATA_0                                 0xD60330
+
+#define mmNIC2_QM0_CP_FENCE2_RDATA_1                                 0xD60334
+
+#define mmNIC2_QM0_CP_FENCE2_RDATA_2                                 0xD60338
+
+#define mmNIC2_QM0_CP_FENCE2_RDATA_3                                 0xD6033C
+
+#define mmNIC2_QM0_CP_FENCE2_RDATA_4                                 0xD60340
+
+#define mmNIC2_QM0_CP_FENCE3_RDATA_0                                 0xD60344
+
+#define mmNIC2_QM0_CP_FENCE3_RDATA_1                                 0xD60348
+
+#define mmNIC2_QM0_CP_FENCE3_RDATA_2                                 0xD6034C
+
+#define mmNIC2_QM0_CP_FENCE3_RDATA_3                                 0xD60350
+
+#define mmNIC2_QM0_CP_FENCE3_RDATA_4                                 0xD60354
+
+#define mmNIC2_QM0_CP_FENCE0_CNT_0                                   0xD60358
+
+#define mmNIC2_QM0_CP_FENCE0_CNT_1                                   0xD6035C
+
+#define mmNIC2_QM0_CP_FENCE0_CNT_2                                   0xD60360
+
+#define mmNIC2_QM0_CP_FENCE0_CNT_3                                   0xD60364
+
+#define mmNIC2_QM0_CP_FENCE0_CNT_4                                   0xD60368
+
+#define mmNIC2_QM0_CP_FENCE1_CNT_0                                   0xD6036C
+
+#define mmNIC2_QM0_CP_FENCE1_CNT_1                                   0xD60370
+
+#define mmNIC2_QM0_CP_FENCE1_CNT_2                                   0xD60374
+
+#define mmNIC2_QM0_CP_FENCE1_CNT_3                                   0xD60378
+
+#define mmNIC2_QM0_CP_FENCE1_CNT_4                                   0xD6037C
+
+#define mmNIC2_QM0_CP_FENCE2_CNT_0                                   0xD60380
+
+#define mmNIC2_QM0_CP_FENCE2_CNT_1                                   0xD60384
+
+#define mmNIC2_QM0_CP_FENCE2_CNT_2                                   0xD60388
+
+#define mmNIC2_QM0_CP_FENCE2_CNT_3                                   0xD6038C
+
+#define mmNIC2_QM0_CP_FENCE2_CNT_4                                   0xD60390
+
+#define mmNIC2_QM0_CP_FENCE3_CNT_0                                   0xD60394
+
+#define mmNIC2_QM0_CP_FENCE3_CNT_1                                   0xD60398
+
+#define mmNIC2_QM0_CP_FENCE3_CNT_2                                   0xD6039C
+
+#define mmNIC2_QM0_CP_FENCE3_CNT_3                                   0xD603A0
+
+#define mmNIC2_QM0_CP_FENCE3_CNT_4                                   0xD603A4
+
+#define mmNIC2_QM0_CP_STS_0                                          0xD603A8
+
+#define mmNIC2_QM0_CP_STS_1                                          0xD603AC
+
+#define mmNIC2_QM0_CP_STS_2                                          0xD603B0
+
+#define mmNIC2_QM0_CP_STS_3                                          0xD603B4
+
+#define mmNIC2_QM0_CP_STS_4                                          0xD603B8
+
+#define mmNIC2_QM0_CP_CURRENT_INST_LO_0                              0xD603BC
+
+#define mmNIC2_QM0_CP_CURRENT_INST_LO_1                              0xD603C0
+
+#define mmNIC2_QM0_CP_CURRENT_INST_LO_2                              0xD603C4
+
+#define mmNIC2_QM0_CP_CURRENT_INST_LO_3                              0xD603C8
+
+#define mmNIC2_QM0_CP_CURRENT_INST_LO_4                              0xD603CC
+
+#define mmNIC2_QM0_CP_CURRENT_INST_HI_0                              0xD603D0
+
+#define mmNIC2_QM0_CP_CURRENT_INST_HI_1                              0xD603D4
+
+#define mmNIC2_QM0_CP_CURRENT_INST_HI_2                              0xD603D8
+
+#define mmNIC2_QM0_CP_CURRENT_INST_HI_3                              0xD603DC
+
+#define mmNIC2_QM0_CP_CURRENT_INST_HI_4                              0xD603E0
+
+#define mmNIC2_QM0_CP_BARRIER_CFG_0                                  0xD603F4
+
+#define mmNIC2_QM0_CP_BARRIER_CFG_1                                  0xD603F8
+
+#define mmNIC2_QM0_CP_BARRIER_CFG_2                                  0xD603FC
+
+#define mmNIC2_QM0_CP_BARRIER_CFG_3                                  0xD60400
+
+#define mmNIC2_QM0_CP_BARRIER_CFG_4                                  0xD60404
+
+#define mmNIC2_QM0_CP_DBG_0_0                                        0xD60408
+
+#define mmNIC2_QM0_CP_DBG_0_1                                        0xD6040C
+
+#define mmNIC2_QM0_CP_DBG_0_2                                        0xD60410
+
+#define mmNIC2_QM0_CP_DBG_0_3                                        0xD60414
+
+#define mmNIC2_QM0_CP_DBG_0_4                                        0xD60418
+
+#define mmNIC2_QM0_CP_ARUSER_31_11_0                                 0xD6041C
+
+#define mmNIC2_QM0_CP_ARUSER_31_11_1                                 0xD60420
+
+#define mmNIC2_QM0_CP_ARUSER_31_11_2                                 0xD60424
+
+#define mmNIC2_QM0_CP_ARUSER_31_11_3                                 0xD60428
+
+#define mmNIC2_QM0_CP_ARUSER_31_11_4                                 0xD6042C
+
+#define mmNIC2_QM0_CP_AWUSER_31_11_0                                 0xD60430
+
+#define mmNIC2_QM0_CP_AWUSER_31_11_1                                 0xD60434
+
+#define mmNIC2_QM0_CP_AWUSER_31_11_2                                 0xD60438
+
+#define mmNIC2_QM0_CP_AWUSER_31_11_3                                 0xD6043C
+
+#define mmNIC2_QM0_CP_AWUSER_31_11_4                                 0xD60440
+
+#define mmNIC2_QM0_ARB_CFG_0                                         0xD60A00
+
+#define mmNIC2_QM0_ARB_CHOISE_Q_PUSH                                 0xD60A04
+
+#define mmNIC2_QM0_ARB_WRR_WEIGHT_0                                  0xD60A08
+
+#define mmNIC2_QM0_ARB_WRR_WEIGHT_1                                  0xD60A0C
+
+#define mmNIC2_QM0_ARB_WRR_WEIGHT_2                                  0xD60A10
+
+#define mmNIC2_QM0_ARB_WRR_WEIGHT_3                                  0xD60A14
+
+#define mmNIC2_QM0_ARB_CFG_1                                         0xD60A18
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_0                              0xD60A20
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_1                              0xD60A24
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_2                              0xD60A28
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_3                              0xD60A2C
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_4                              0xD60A30
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_5                              0xD60A34
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_6                              0xD60A38
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_7                              0xD60A3C
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_8                              0xD60A40
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_9                              0xD60A44
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_10                             0xD60A48
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_11                             0xD60A4C
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_12                             0xD60A50
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_13                             0xD60A54
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_14                             0xD60A58
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_15                             0xD60A5C
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_16                             0xD60A60
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_17                             0xD60A64
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_18                             0xD60A68
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_19                             0xD60A6C
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_20                             0xD60A70
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_21                             0xD60A74
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_22                             0xD60A78
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_23                             0xD60A7C
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_24                             0xD60A80
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_25                             0xD60A84
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_26                             0xD60A88
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_27                             0xD60A8C
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_28                             0xD60A90
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_29                             0xD60A94
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_30                             0xD60A98
+
+#define mmNIC2_QM0_ARB_MST_AVAIL_CRED_31                             0xD60A9C
+
+#define mmNIC2_QM0_ARB_MST_CRED_INC                                  0xD60AA0
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_0                        0xD60AA4
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_1                        0xD60AA8
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_2                        0xD60AAC
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_3                        0xD60AB0
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_4                        0xD60AB4
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_5                        0xD60AB8
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_6                        0xD60ABC
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_7                        0xD60AC0
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_8                        0xD60AC4
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_9                        0xD60AC8
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_10                       0xD60ACC
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_11                       0xD60AD0
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_12                       0xD60AD4
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_13                       0xD60AD8
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_14                       0xD60ADC
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_15                       0xD60AE0
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_16                       0xD60AE4
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_17                       0xD60AE8
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_18                       0xD60AEC
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_19                       0xD60AF0
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_20                       0xD60AF4
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_21                       0xD60AF8
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_22                       0xD60AFC
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_23                       0xD60B00
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_24                       0xD60B04
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_25                       0xD60B08
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_26                       0xD60B0C
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_27                       0xD60B10
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_28                       0xD60B14
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_29                       0xD60B18
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_30                       0xD60B1C
+
+#define mmNIC2_QM0_ARB_MST_CHOISE_PUSH_OFST_31                       0xD60B20
+
+#define mmNIC2_QM0_ARB_SLV_MASTER_INC_CRED_OFST                      0xD60B28
+
+#define mmNIC2_QM0_ARB_MST_SLAVE_EN                                  0xD60B2C
+
+#define mmNIC2_QM0_ARB_MST_QUIET_PER                                 0xD60B34
+
+#define mmNIC2_QM0_ARB_SLV_CHOISE_WDT                                0xD60B38
+
+#define mmNIC2_QM0_ARB_SLV_ID                                        0xD60B3C
+
+#define mmNIC2_QM0_ARB_MSG_MAX_INFLIGHT                              0xD60B44
+
+#define mmNIC2_QM0_ARB_MSG_AWUSER_31_11                              0xD60B48
+
+#define mmNIC2_QM0_ARB_MSG_AWUSER_SEC_PROP                           0xD60B4C
+
+#define mmNIC2_QM0_ARB_MSG_AWUSER_NON_SEC_PROP                       0xD60B50
+
+#define mmNIC2_QM0_ARB_BASE_LO                                       0xD60B54
+
+#define mmNIC2_QM0_ARB_BASE_HI                                       0xD60B58
+
+#define mmNIC2_QM0_ARB_STATE_STS                                     0xD60B80
+
+#define mmNIC2_QM0_ARB_CHOISE_FULLNESS_STS                           0xD60B84
+
+#define mmNIC2_QM0_ARB_MSG_STS                                       0xD60B88
+
+#define mmNIC2_QM0_ARB_SLV_CHOISE_Q_HEAD                             0xD60B8C
+
+#define mmNIC2_QM0_ARB_ERR_CAUSE                                     0xD60B9C
+
+#define mmNIC2_QM0_ARB_ERR_MSG_EN                                    0xD60BA0
+
+#define mmNIC2_QM0_ARB_ERR_STS_DRP                                   0xD60BA8
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_0                                0xD60BB0
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_1                                0xD60BB4
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_2                                0xD60BB8
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_3                                0xD60BBC
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_4                                0xD60BC0
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_5                                0xD60BC4
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_6                                0xD60BC8
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_7                                0xD60BCC
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_8                                0xD60BD0
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_9                                0xD60BD4
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_10                               0xD60BD8
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_11                               0xD60BDC
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_12                               0xD60BE0
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_13                               0xD60BE4
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_14                               0xD60BE8
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_15                               0xD60BEC
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_16                               0xD60BF0
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_17                               0xD60BF4
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_18                               0xD60BF8
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_19                               0xD60BFC
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_20                               0xD60C00
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_21                               0xD60C04
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_22                               0xD60C08
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_23                               0xD60C0C
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_24                               0xD60C10
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_25                               0xD60C14
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_26                               0xD60C18
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_27                               0xD60C1C
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_28                               0xD60C20
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_29                               0xD60C24
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_30                               0xD60C28
+
+#define mmNIC2_QM0_ARB_MST_CRED_STS_31                               0xD60C2C
+
+#define mmNIC2_QM0_CGM_CFG                                           0xD60C70
+
+#define mmNIC2_QM0_CGM_STS                                           0xD60C74
+
+#define mmNIC2_QM0_CGM_CFG1                                          0xD60C78
+
+#define mmNIC2_QM0_LOCAL_RANGE_BASE                                  0xD60C80
+
+#define mmNIC2_QM0_LOCAL_RANGE_SIZE                                  0xD60C84
+
+#define mmNIC2_QM0_CSMR_STRICT_PRIO_CFG                              0xD60C90
+
+#define mmNIC2_QM0_HBW_RD_RATE_LIM_CFG_1                             0xD60C94
+
+#define mmNIC2_QM0_LBW_WR_RATE_LIM_CFG_0                             0xD60C98
+
+#define mmNIC2_QM0_LBW_WR_RATE_LIM_CFG_1                             0xD60C9C
+
+#define mmNIC2_QM0_HBW_RD_RATE_LIM_CFG_0                             0xD60CA0
+
+#define mmNIC2_QM0_GLBL_AXCACHE                                      0xD60CA4
+
+#define mmNIC2_QM0_IND_GW_APB_CFG                                    0xD60CB0
+
+#define mmNIC2_QM0_IND_GW_APB_WDATA                                  0xD60CB4
+
+#define mmNIC2_QM0_IND_GW_APB_RDATA                                  0xD60CB8
+
+#define mmNIC2_QM0_IND_GW_APB_STATUS                                 0xD60CBC
+
+#define mmNIC2_QM0_GLBL_ERR_ADDR_LO                                  0xD60CD0
+
+#define mmNIC2_QM0_GLBL_ERR_ADDR_HI                                  0xD60CD4
+
+#define mmNIC2_QM0_GLBL_ERR_WDATA                                    0xD60CD8
+
+#define mmNIC2_QM0_GLBL_MEM_INIT_BUSY                                0xD60D00
+
+#endif /* ASIC_REG_NIC2_QM0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
new file mode 100644
index 000000000000..b7f091ddc89c
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC2_QM1_REGS_H_
+#define ASIC_REG_NIC2_QM1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC2_QM1 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC2_QM1_GLBL_CFG0                                         0xD62000
+
+#define mmNIC2_QM1_GLBL_CFG1                                         0xD62004
+
+#define mmNIC2_QM1_GLBL_PROT                                         0xD62008
+
+#define mmNIC2_QM1_GLBL_ERR_CFG                                      0xD6200C
+
+#define mmNIC2_QM1_GLBL_SECURE_PROPS_0                               0xD62010
+
+#define mmNIC2_QM1_GLBL_SECURE_PROPS_1                               0xD62014
+
+#define mmNIC2_QM1_GLBL_SECURE_PROPS_2                               0xD62018
+
+#define mmNIC2_QM1_GLBL_SECURE_PROPS_3                               0xD6201C
+
+#define mmNIC2_QM1_GLBL_SECURE_PROPS_4                               0xD62020
+
+#define mmNIC2_QM1_GLBL_NON_SECURE_PROPS_0                           0xD62024
+
+#define mmNIC2_QM1_GLBL_NON_SECURE_PROPS_1                           0xD62028
+
+#define mmNIC2_QM1_GLBL_NON_SECURE_PROPS_2                           0xD6202C
+
+#define mmNIC2_QM1_GLBL_NON_SECURE_PROPS_3                           0xD62030
+
+#define mmNIC2_QM1_GLBL_NON_SECURE_PROPS_4                           0xD62034
+
+#define mmNIC2_QM1_GLBL_STS0                                         0xD62038
+
+#define mmNIC2_QM1_GLBL_STS1_0                                       0xD62040
+
+#define mmNIC2_QM1_GLBL_STS1_1                                       0xD62044
+
+#define mmNIC2_QM1_GLBL_STS1_2                                       0xD62048
+
+#define mmNIC2_QM1_GLBL_STS1_3                                       0xD6204C
+
+#define mmNIC2_QM1_GLBL_STS1_4                                       0xD62050
+
+#define mmNIC2_QM1_GLBL_MSG_EN_0                                     0xD62054
+
+#define mmNIC2_QM1_GLBL_MSG_EN_1                                     0xD62058
+
+#define mmNIC2_QM1_GLBL_MSG_EN_2                                     0xD6205C
+
+#define mmNIC2_QM1_GLBL_MSG_EN_3                                     0xD62060
+
+#define mmNIC2_QM1_GLBL_MSG_EN_4                                     0xD62068
+
+#define mmNIC2_QM1_PQ_BASE_LO_0                                      0xD62070
+
+#define mmNIC2_QM1_PQ_BASE_LO_1                                      0xD62074
+
+#define mmNIC2_QM1_PQ_BASE_LO_2                                      0xD62078
+
+#define mmNIC2_QM1_PQ_BASE_LO_3                                      0xD6207C
+
+#define mmNIC2_QM1_PQ_BASE_HI_0                                      0xD62080
+
+#define mmNIC2_QM1_PQ_BASE_HI_1                                      0xD62084
+
+#define mmNIC2_QM1_PQ_BASE_HI_2                                      0xD62088
+
+#define mmNIC2_QM1_PQ_BASE_HI_3                                      0xD6208C
+
+#define mmNIC2_QM1_PQ_SIZE_0                                         0xD62090
+
+#define mmNIC2_QM1_PQ_SIZE_1                                         0xD62094
+
+#define mmNIC2_QM1_PQ_SIZE_2                                         0xD62098
+
+#define mmNIC2_QM1_PQ_SIZE_3                                         0xD6209C
+
+#define mmNIC2_QM1_PQ_PI_0                                           0xD620A0
+
+#define mmNIC2_QM1_PQ_PI_1                                           0xD620A4
+
+#define mmNIC2_QM1_PQ_PI_2                                           0xD620A8
+
+#define mmNIC2_QM1_PQ_PI_3                                           0xD620AC
+
+#define mmNIC2_QM1_PQ_CI_0                                           0xD620B0
+
+#define mmNIC2_QM1_PQ_CI_1                                           0xD620B4
+
+#define mmNIC2_QM1_PQ_CI_2                                           0xD620B8
+
+#define mmNIC2_QM1_PQ_CI_3                                           0xD620BC
+
+#define mmNIC2_QM1_PQ_CFG0_0                                         0xD620C0
+
+#define mmNIC2_QM1_PQ_CFG0_1                                         0xD620C4
+
+#define mmNIC2_QM1_PQ_CFG0_2                                         0xD620C8
+
+#define mmNIC2_QM1_PQ_CFG0_3                                         0xD620CC
+
+#define mmNIC2_QM1_PQ_CFG1_0                                         0xD620D0
+
+#define mmNIC2_QM1_PQ_CFG1_1                                         0xD620D4
+
+#define mmNIC2_QM1_PQ_CFG1_2                                         0xD620D8
+
+#define mmNIC2_QM1_PQ_CFG1_3                                         0xD620DC
+
+#define mmNIC2_QM1_PQ_ARUSER_31_11_0                                 0xD620E0
+
+#define mmNIC2_QM1_PQ_ARUSER_31_11_1                                 0xD620E4
+
+#define mmNIC2_QM1_PQ_ARUSER_31_11_2                                 0xD620E8
+
+#define mmNIC2_QM1_PQ_ARUSER_31_11_3                                 0xD620EC
+
+#define mmNIC2_QM1_PQ_STS0_0                                         0xD620F0
+
+#define mmNIC2_QM1_PQ_STS0_1                                         0xD620F4
+
+#define mmNIC2_QM1_PQ_STS0_2                                         0xD620F8
+
+#define mmNIC2_QM1_PQ_STS0_3                                         0xD620FC
+
+#define mmNIC2_QM1_PQ_STS1_0                                         0xD62100
+
+#define mmNIC2_QM1_PQ_STS1_1                                         0xD62104
+
+#define mmNIC2_QM1_PQ_STS1_2                                         0xD62108
+
+#define mmNIC2_QM1_PQ_STS1_3                                         0xD6210C
+
+#define mmNIC2_QM1_CQ_CFG0_0                                         0xD62110
+
+#define mmNIC2_QM1_CQ_CFG0_1                                         0xD62114
+
+#define mmNIC2_QM1_CQ_CFG0_2                                         0xD62118
+
+#define mmNIC2_QM1_CQ_CFG0_3                                         0xD6211C
+
+#define mmNIC2_QM1_CQ_CFG0_4                                         0xD62120
+
+#define mmNIC2_QM1_CQ_CFG1_0                                         0xD62124
+
+#define mmNIC2_QM1_CQ_CFG1_1                                         0xD62128
+
+#define mmNIC2_QM1_CQ_CFG1_2                                         0xD6212C
+
+#define mmNIC2_QM1_CQ_CFG1_3                                         0xD62130
+
+#define mmNIC2_QM1_CQ_CFG1_4                                         0xD62134
+
+#define mmNIC2_QM1_CQ_ARUSER_31_11_0                                 0xD62138
+
+#define mmNIC2_QM1_CQ_ARUSER_31_11_1                                 0xD6213C
+
+#define mmNIC2_QM1_CQ_ARUSER_31_11_2                                 0xD62140
+
+#define mmNIC2_QM1_CQ_ARUSER_31_11_3                                 0xD62144
+
+#define mmNIC2_QM1_CQ_ARUSER_31_11_4                                 0xD62148
+
+#define mmNIC2_QM1_CQ_STS0_0                                         0xD6214C
+
+#define mmNIC2_QM1_CQ_STS0_1                                         0xD62150
+
+#define mmNIC2_QM1_CQ_STS0_2                                         0xD62154
+
+#define mmNIC2_QM1_CQ_STS0_3                                         0xD62158
+
+#define mmNIC2_QM1_CQ_STS0_4                                         0xD6215C
+
+#define mmNIC2_QM1_CQ_STS1_0                                         0xD62160
+
+#define mmNIC2_QM1_CQ_STS1_1                                         0xD62164
+
+#define mmNIC2_QM1_CQ_STS1_2                                         0xD62168
+
+#define mmNIC2_QM1_CQ_STS1_3                                         0xD6216C
+
+#define mmNIC2_QM1_CQ_STS1_4                                         0xD62170
+
+#define mmNIC2_QM1_CQ_PTR_LO_0                                       0xD62174
+
+#define mmNIC2_QM1_CQ_PTR_HI_0                                       0xD62178
+
+#define mmNIC2_QM1_CQ_TSIZE_0                                        0xD6217C
+
+#define mmNIC2_QM1_CQ_CTL_0                                          0xD62180
+
+#define mmNIC2_QM1_CQ_PTR_LO_1                                       0xD62184
+
+#define mmNIC2_QM1_CQ_PTR_HI_1                                       0xD62188
+
+#define mmNIC2_QM1_CQ_TSIZE_1                                        0xD6218C
+
+#define mmNIC2_QM1_CQ_CTL_1                                          0xD62190
+
+#define mmNIC2_QM1_CQ_PTR_LO_2                                       0xD62194
+
+#define mmNIC2_QM1_CQ_PTR_HI_2                                       0xD62198
+
+#define mmNIC2_QM1_CQ_TSIZE_2                                        0xD6219C
+
+#define mmNIC2_QM1_CQ_CTL_2                                          0xD621A0
+
+#define mmNIC2_QM1_CQ_PTR_LO_3                                       0xD621A4
+
+#define mmNIC2_QM1_CQ_PTR_HI_3                                       0xD621A8
+
+#define mmNIC2_QM1_CQ_TSIZE_3                                        0xD621AC
+
+#define mmNIC2_QM1_CQ_CTL_3                                          0xD621B0
+
+#define mmNIC2_QM1_CQ_PTR_LO_4                                       0xD621B4
+
+#define mmNIC2_QM1_CQ_PTR_HI_4                                       0xD621B8
+
+#define mmNIC2_QM1_CQ_TSIZE_4                                        0xD621BC
+
+#define mmNIC2_QM1_CQ_CTL_4                                          0xD621C0
+
+#define mmNIC2_QM1_CQ_PTR_LO_STS_0                                   0xD621C4
+
+#define mmNIC2_QM1_CQ_PTR_LO_STS_1                                   0xD621C8
+
+#define mmNIC2_QM1_CQ_PTR_LO_STS_2                                   0xD621CC
+
+#define mmNIC2_QM1_CQ_PTR_LO_STS_3                                   0xD621D0
+
+#define mmNIC2_QM1_CQ_PTR_LO_STS_4                                   0xD621D4
+
+#define mmNIC2_QM1_CQ_PTR_HI_STS_0                                   0xD621D8
+
+#define mmNIC2_QM1_CQ_PTR_HI_STS_1                                   0xD621DC
+
+#define mmNIC2_QM1_CQ_PTR_HI_STS_2                                   0xD621E0
+
+#define mmNIC2_QM1_CQ_PTR_HI_STS_3                                   0xD621E4
+
+#define mmNIC2_QM1_CQ_PTR_HI_STS_4                                   0xD621E8
+
+#define mmNIC2_QM1_CQ_TSIZE_STS_0                                    0xD621EC
+
+#define mmNIC2_QM1_CQ_TSIZE_STS_1                                    0xD621F0
+
+#define mmNIC2_QM1_CQ_TSIZE_STS_2                                    0xD621F4
+
+#define mmNIC2_QM1_CQ_TSIZE_STS_3                                    0xD621F8
+
+#define mmNIC2_QM1_CQ_TSIZE_STS_4                                    0xD621FC
+
+#define mmNIC2_QM1_CQ_CTL_STS_0                                      0xD62200
+
+#define mmNIC2_QM1_CQ_CTL_STS_1                                      0xD62204
+
+#define mmNIC2_QM1_CQ_CTL_STS_2                                      0xD62208
+
+#define mmNIC2_QM1_CQ_CTL_STS_3                                      0xD6220C
+
+#define mmNIC2_QM1_CQ_CTL_STS_4                                      0xD62210
+
+#define mmNIC2_QM1_CQ_IFIFO_CNT_0                                    0xD62214
+
+#define mmNIC2_QM1_CQ_IFIFO_CNT_1                                    0xD62218
+
+#define mmNIC2_QM1_CQ_IFIFO_CNT_2                                    0xD6221C
+
+#define mmNIC2_QM1_CQ_IFIFO_CNT_3                                    0xD62220
+
+#define mmNIC2_QM1_CQ_IFIFO_CNT_4                                    0xD62224
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_0                            0xD62228
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_1                            0xD6222C
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_2                            0xD62230
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_3                            0xD62234
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_LO_4                            0xD62238
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_0                            0xD6223C
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_1                            0xD62240
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_2                            0xD62244
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_3                            0xD62248
+
+#define mmNIC2_QM1_CP_MSG_BASE0_ADDR_HI_4                            0xD6224C
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_0                            0xD62250
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_1                            0xD62254
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_2                            0xD62258
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_3                            0xD6225C
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_LO_4                            0xD62260
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_0                            0xD62264
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_1                            0xD62268
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_2                            0xD6226C
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_3                            0xD62270
+
+#define mmNIC2_QM1_CP_MSG_BASE1_ADDR_HI_4                            0xD62274
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_0                            0xD62278
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_1                            0xD6227C
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_2                            0xD62280
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_3                            0xD62284
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_LO_4                            0xD62288
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_0                            0xD6228C
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_1                            0xD62290
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_2                            0xD62294
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_3                            0xD62298
+
+#define mmNIC2_QM1_CP_MSG_BASE2_ADDR_HI_4                            0xD6229C
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_0                            0xD622A0
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_1                            0xD622A4
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_2                            0xD622A8
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_3                            0xD622AC
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_LO_4                            0xD622B0
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_0                            0xD622B4
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_1                            0xD622B8
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_2                            0xD622BC
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_3                            0xD622C0
+
+#define mmNIC2_QM1_CP_MSG_BASE3_ADDR_HI_4                            0xD622C4
+
+#define mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_0                            0xD622C8
+
+#define mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_1                            0xD622CC
+
+#define mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_2                            0xD622D0
+
+#define mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_3                            0xD622D4
+
+#define mmNIC2_QM1_CP_LDMA_TSIZE_OFFSET_4                            0xD622D8
+
+#define mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xD622E0
+
+#define mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xD622E4
+
+#define mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xD622E8
+
+#define mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xD622EC
+
+#define mmNIC2_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xD622F0
+
+#define mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xD622F4
+
+#define mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xD622F8
+
+#define mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xD622FC
+
+#define mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xD62300
+
+#define mmNIC2_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xD62304
+
+#define mmNIC2_QM1_CP_FENCE0_RDATA_0                                 0xD62308
+
+#define mmNIC2_QM1_CP_FENCE0_RDATA_1                                 0xD6230C
+
+#define mmNIC2_QM1_CP_FENCE0_RDATA_2                                 0xD62310
+
+#define mmNIC2_QM1_CP_FENCE0_RDATA_3                                 0xD62314
+
+#define mmNIC2_QM1_CP_FENCE0_RDATA_4                                 0xD62318
+
+#define mmNIC2_QM1_CP_FENCE1_RDATA_0                                 0xD6231C
+
+#define mmNIC2_QM1_CP_FENCE1_RDATA_1                                 0xD62320
+
+#define mmNIC2_QM1_CP_FENCE1_RDATA_2                                 0xD62324
+
+#define mmNIC2_QM1_CP_FENCE1_RDATA_3                                 0xD62328
+
+#define mmNIC2_QM1_CP_FENCE1_RDATA_4                                 0xD6232C
+
+#define mmNIC2_QM1_CP_FENCE2_RDATA_0                                 0xD62330
+
+#define mmNIC2_QM1_CP_FENCE2_RDATA_1                                 0xD62334
+
+#define mmNIC2_QM1_CP_FENCE2_RDATA_2                                 0xD62338
+
+#define mmNIC2_QM1_CP_FENCE2_RDATA_3                                 0xD6233C
+
+#define mmNIC2_QM1_CP_FENCE2_RDATA_4                                 0xD62340
+
+#define mmNIC2_QM1_CP_FENCE3_RDATA_0                                 0xD62344
+
+#define mmNIC2_QM1_CP_FENCE3_RDATA_1                                 0xD62348
+
+#define mmNIC2_QM1_CP_FENCE3_RDATA_2                                 0xD6234C
+
+#define mmNIC2_QM1_CP_FENCE3_RDATA_3                                 0xD62350
+
+#define mmNIC2_QM1_CP_FENCE3_RDATA_4                                 0xD62354
+
+#define mmNIC2_QM1_CP_FENCE0_CNT_0                                   0xD62358
+
+#define mmNIC2_QM1_CP_FENCE0_CNT_1                                   0xD6235C
+
+#define mmNIC2_QM1_CP_FENCE0_CNT_2                                   0xD62360
+
+#define mmNIC2_QM1_CP_FENCE0_CNT_3                                   0xD62364
+
+#define mmNIC2_QM1_CP_FENCE0_CNT_4                                   0xD62368
+
+#define mmNIC2_QM1_CP_FENCE1_CNT_0                                   0xD6236C
+
+#define mmNIC2_QM1_CP_FENCE1_CNT_1                                   0xD62370
+
+#define mmNIC2_QM1_CP_FENCE1_CNT_2                                   0xD62374
+
+#define mmNIC2_QM1_CP_FENCE1_CNT_3                                   0xD62378
+
+#define mmNIC2_QM1_CP_FENCE1_CNT_4                                   0xD6237C
+
+#define mmNIC2_QM1_CP_FENCE2_CNT_0                                   0xD62380
+
+#define mmNIC2_QM1_CP_FENCE2_CNT_1                                   0xD62384
+
+#define mmNIC2_QM1_CP_FENCE2_CNT_2                                   0xD62388
+
+#define mmNIC2_QM1_CP_FENCE2_CNT_3                                   0xD6238C
+
+#define mmNIC2_QM1_CP_FENCE2_CNT_4                                   0xD62390
+
+#define mmNIC2_QM1_CP_FENCE3_CNT_0                                   0xD62394
+
+#define mmNIC2_QM1_CP_FENCE3_CNT_1                                   0xD62398
+
+#define mmNIC2_QM1_CP_FENCE3_CNT_2                                   0xD6239C
+
+#define mmNIC2_QM1_CP_FENCE3_CNT_3                                   0xD623A0
+
+#define mmNIC2_QM1_CP_FENCE3_CNT_4                                   0xD623A4
+
+#define mmNIC2_QM1_CP_STS_0                                          0xD623A8
+
+#define mmNIC2_QM1_CP_STS_1                                          0xD623AC
+
+#define mmNIC2_QM1_CP_STS_2                                          0xD623B0
+
+#define mmNIC2_QM1_CP_STS_3                                          0xD623B4
+
+#define mmNIC2_QM1_CP_STS_4                                          0xD623B8
+
+#define mmNIC2_QM1_CP_CURRENT_INST_LO_0                              0xD623BC
+
+#define mmNIC2_QM1_CP_CURRENT_INST_LO_1                              0xD623C0
+
+#define mmNIC2_QM1_CP_CURRENT_INST_LO_2                              0xD623C4
+
+#define mmNIC2_QM1_CP_CURRENT_INST_LO_3                              0xD623C8
+
+#define mmNIC2_QM1_CP_CURRENT_INST_LO_4                              0xD623CC
+
+#define mmNIC2_QM1_CP_CURRENT_INST_HI_0                              0xD623D0
+
+#define mmNIC2_QM1_CP_CURRENT_INST_HI_1                              0xD623D4
+
+#define mmNIC2_QM1_CP_CURRENT_INST_HI_2                              0xD623D8
+
+#define mmNIC2_QM1_CP_CURRENT_INST_HI_3                              0xD623DC
+
+#define mmNIC2_QM1_CP_CURRENT_INST_HI_4                              0xD623E0
+
+#define mmNIC2_QM1_CP_BARRIER_CFG_0                                  0xD623F4
+
+#define mmNIC2_QM1_CP_BARRIER_CFG_1                                  0xD623F8
+
+#define mmNIC2_QM1_CP_BARRIER_CFG_2                                  0xD623FC
+
+#define mmNIC2_QM1_CP_BARRIER_CFG_3                                  0xD62400
+
+#define mmNIC2_QM1_CP_BARRIER_CFG_4                                  0xD62404
+
+#define mmNIC2_QM1_CP_DBG_0_0                                        0xD62408
+
+#define mmNIC2_QM1_CP_DBG_0_1                                        0xD6240C
+
+#define mmNIC2_QM1_CP_DBG_0_2                                        0xD62410
+
+#define mmNIC2_QM1_CP_DBG_0_3                                        0xD62414
+
+#define mmNIC2_QM1_CP_DBG_0_4                                        0xD62418
+
+#define mmNIC2_QM1_CP_ARUSER_31_11_0                                 0xD6241C
+
+#define mmNIC2_QM1_CP_ARUSER_31_11_1                                 0xD62420
+
+#define mmNIC2_QM1_CP_ARUSER_31_11_2                                 0xD62424
+
+#define mmNIC2_QM1_CP_ARUSER_31_11_3                                 0xD62428
+
+#define mmNIC2_QM1_CP_ARUSER_31_11_4                                 0xD6242C
+
+#define mmNIC2_QM1_CP_AWUSER_31_11_0                                 0xD62430
+
+#define mmNIC2_QM1_CP_AWUSER_31_11_1                                 0xD62434
+
+#define mmNIC2_QM1_CP_AWUSER_31_11_2                                 0xD62438
+
+#define mmNIC2_QM1_CP_AWUSER_31_11_3                                 0xD6243C
+
+#define mmNIC2_QM1_CP_AWUSER_31_11_4                                 0xD62440
+
+#define mmNIC2_QM1_ARB_CFG_0                                         0xD62A00
+
+#define mmNIC2_QM1_ARB_CHOISE_Q_PUSH                                 0xD62A04
+
+#define mmNIC2_QM1_ARB_WRR_WEIGHT_0                                  0xD62A08
+
+#define mmNIC2_QM1_ARB_WRR_WEIGHT_1                                  0xD62A0C
+
+#define mmNIC2_QM1_ARB_WRR_WEIGHT_2                                  0xD62A10
+
+#define mmNIC2_QM1_ARB_WRR_WEIGHT_3                                  0xD62A14
+
+#define mmNIC2_QM1_ARB_CFG_1                                         0xD62A18
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_0                              0xD62A20
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_1                              0xD62A24
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_2                              0xD62A28
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_3                              0xD62A2C
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_4                              0xD62A30
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_5                              0xD62A34
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_6                              0xD62A38
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_7                              0xD62A3C
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_8                              0xD62A40
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_9                              0xD62A44
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_10                             0xD62A48
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_11                             0xD62A4C
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_12                             0xD62A50
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_13                             0xD62A54
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_14                             0xD62A58
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_15                             0xD62A5C
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_16                             0xD62A60
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_17                             0xD62A64
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_18                             0xD62A68
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_19                             0xD62A6C
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_20                             0xD62A70
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_21                             0xD62A74
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_22                             0xD62A78
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_23                             0xD62A7C
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_24                             0xD62A80
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_25                             0xD62A84
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_26                             0xD62A88
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_27                             0xD62A8C
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_28                             0xD62A90
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_29                             0xD62A94
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_30                             0xD62A98
+
+#define mmNIC2_QM1_ARB_MST_AVAIL_CRED_31                             0xD62A9C
+
+#define mmNIC2_QM1_ARB_MST_CRED_INC                                  0xD62AA0
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_0                        0xD62AA4
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_1                        0xD62AA8
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_2                        0xD62AAC
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_3                        0xD62AB0
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_4                        0xD62AB4
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_5                        0xD62AB8
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_6                        0xD62ABC
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_7                        0xD62AC0
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_8                        0xD62AC4
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_9                        0xD62AC8
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_10                       0xD62ACC
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_11                       0xD62AD0
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_12                       0xD62AD4
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_13                       0xD62AD8
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_14                       0xD62ADC
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_15                       0xD62AE0
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_16                       0xD62AE4
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_17                       0xD62AE8
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_18                       0xD62AEC
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_19                       0xD62AF0
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_20                       0xD62AF4
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_21                       0xD62AF8
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_22                       0xD62AFC
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_23                       0xD62B00
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_24                       0xD62B04
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_25                       0xD62B08
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_26                       0xD62B0C
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_27                       0xD62B10
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_28                       0xD62B14
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_29                       0xD62B18
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_30                       0xD62B1C
+
+#define mmNIC2_QM1_ARB_MST_CHOISE_PUSH_OFST_31                       0xD62B20
+
+#define mmNIC2_QM1_ARB_SLV_MASTER_INC_CRED_OFST                      0xD62B28
+
+#define mmNIC2_QM1_ARB_MST_SLAVE_EN                                  0xD62B2C
+
+#define mmNIC2_QM1_ARB_MST_QUIET_PER                                 0xD62B34
+
+#define mmNIC2_QM1_ARB_SLV_CHOISE_WDT                                0xD62B38
+
+#define mmNIC2_QM1_ARB_SLV_ID                                        0xD62B3C
+
+#define mmNIC2_QM1_ARB_MSG_MAX_INFLIGHT                              0xD62B44
+
+#define mmNIC2_QM1_ARB_MSG_AWUSER_31_11                              0xD62B48
+
+#define mmNIC2_QM1_ARB_MSG_AWUSER_SEC_PROP                           0xD62B4C
+
+#define mmNIC2_QM1_ARB_MSG_AWUSER_NON_SEC_PROP                       0xD62B50
+
+#define mmNIC2_QM1_ARB_BASE_LO                                       0xD62B54
+
+#define mmNIC2_QM1_ARB_BASE_HI                                       0xD62B58
+
+#define mmNIC2_QM1_ARB_STATE_STS                                     0xD62B80
+
+#define mmNIC2_QM1_ARB_CHOISE_FULLNESS_STS                           0xD62B84
+
+#define mmNIC2_QM1_ARB_MSG_STS                                       0xD62B88
+
+#define mmNIC2_QM1_ARB_SLV_CHOISE_Q_HEAD                             0xD62B8C
+
+#define mmNIC2_QM1_ARB_ERR_CAUSE                                     0xD62B9C
+
+#define mmNIC2_QM1_ARB_ERR_MSG_EN                                    0xD62BA0
+
+#define mmNIC2_QM1_ARB_ERR_STS_DRP                                   0xD62BA8
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_0                                0xD62BB0
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_1                                0xD62BB4
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_2                                0xD62BB8
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_3                                0xD62BBC
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_4                                0xD62BC0
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_5                                0xD62BC4
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_6                                0xD62BC8
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_7                                0xD62BCC
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_8                                0xD62BD0
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_9                                0xD62BD4
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_10                               0xD62BD8
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_11                               0xD62BDC
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_12                               0xD62BE0
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_13                               0xD62BE4
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_14                               0xD62BE8
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_15                               0xD62BEC
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_16                               0xD62BF0
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_17                               0xD62BF4
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_18                               0xD62BF8
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_19                               0xD62BFC
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_20                               0xD62C00
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_21                               0xD62C04
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_22                               0xD62C08
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_23                               0xD62C0C
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_24                               0xD62C10
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_25                               0xD62C14
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_26                               0xD62C18
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_27                               0xD62C1C
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_28                               0xD62C20
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_29                               0xD62C24
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_30                               0xD62C28
+
+#define mmNIC2_QM1_ARB_MST_CRED_STS_31                               0xD62C2C
+
+#define mmNIC2_QM1_CGM_CFG                                           0xD62C70
+
+#define mmNIC2_QM1_CGM_STS                                           0xD62C74
+
+#define mmNIC2_QM1_CGM_CFG1                                          0xD62C78
+
+#define mmNIC2_QM1_LOCAL_RANGE_BASE                                  0xD62C80
+
+#define mmNIC2_QM1_LOCAL_RANGE_SIZE                                  0xD62C84
+
+#define mmNIC2_QM1_CSMR_STRICT_PRIO_CFG                              0xD62C90
+
+#define mmNIC2_QM1_HBW_RD_RATE_LIM_CFG_1                             0xD62C94
+
+#define mmNIC2_QM1_LBW_WR_RATE_LIM_CFG_0                             0xD62C98
+
+#define mmNIC2_QM1_LBW_WR_RATE_LIM_CFG_1                             0xD62C9C
+
+#define mmNIC2_QM1_HBW_RD_RATE_LIM_CFG_0                             0xD62CA0
+
+#define mmNIC2_QM1_GLBL_AXCACHE                                      0xD62CA4
+
+#define mmNIC2_QM1_IND_GW_APB_CFG                                    0xD62CB0
+
+#define mmNIC2_QM1_IND_GW_APB_WDATA                                  0xD62CB4
+
+#define mmNIC2_QM1_IND_GW_APB_RDATA                                  0xD62CB8
+
+#define mmNIC2_QM1_IND_GW_APB_STATUS                                 0xD62CBC
+
+#define mmNIC2_QM1_GLBL_ERR_ADDR_LO                                  0xD62CD0
+
+#define mmNIC2_QM1_GLBL_ERR_ADDR_HI                                  0xD62CD4
+
+#define mmNIC2_QM1_GLBL_ERR_WDATA                                    0xD62CD8
+
+#define mmNIC2_QM1_GLBL_MEM_INIT_BUSY                                0xD62D00
+
+#endif /* ASIC_REG_NIC2_QM1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
new file mode 100644
index 000000000000..4712cc62b009
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC3_QM0_REGS_H_
+#define ASIC_REG_NIC3_QM0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC3_QM0 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC3_QM0_GLBL_CFG0                                         0xDA0000
+
+#define mmNIC3_QM0_GLBL_CFG1                                         0xDA0004
+
+#define mmNIC3_QM0_GLBL_PROT                                         0xDA0008
+
+#define mmNIC3_QM0_GLBL_ERR_CFG                                      0xDA000C
+
+#define mmNIC3_QM0_GLBL_SECURE_PROPS_0                               0xDA0010
+
+#define mmNIC3_QM0_GLBL_SECURE_PROPS_1                               0xDA0014
+
+#define mmNIC3_QM0_GLBL_SECURE_PROPS_2                               0xDA0018
+
+#define mmNIC3_QM0_GLBL_SECURE_PROPS_3                               0xDA001C
+
+#define mmNIC3_QM0_GLBL_SECURE_PROPS_4                               0xDA0020
+
+#define mmNIC3_QM0_GLBL_NON_SECURE_PROPS_0                           0xDA0024
+
+#define mmNIC3_QM0_GLBL_NON_SECURE_PROPS_1                           0xDA0028
+
+#define mmNIC3_QM0_GLBL_NON_SECURE_PROPS_2                           0xDA002C
+
+#define mmNIC3_QM0_GLBL_NON_SECURE_PROPS_3                           0xDA0030
+
+#define mmNIC3_QM0_GLBL_NON_SECURE_PROPS_4                           0xDA0034
+
+#define mmNIC3_QM0_GLBL_STS0                                         0xDA0038
+
+#define mmNIC3_QM0_GLBL_STS1_0                                       0xDA0040
+
+#define mmNIC3_QM0_GLBL_STS1_1                                       0xDA0044
+
+#define mmNIC3_QM0_GLBL_STS1_2                                       0xDA0048
+
+#define mmNIC3_QM0_GLBL_STS1_3                                       0xDA004C
+
+#define mmNIC3_QM0_GLBL_STS1_4                                       0xDA0050
+
+#define mmNIC3_QM0_GLBL_MSG_EN_0                                     0xDA0054
+
+#define mmNIC3_QM0_GLBL_MSG_EN_1                                     0xDA0058
+
+#define mmNIC3_QM0_GLBL_MSG_EN_2                                     0xDA005C
+
+#define mmNIC3_QM0_GLBL_MSG_EN_3                                     0xDA0060
+
+#define mmNIC3_QM0_GLBL_MSG_EN_4                                     0xDA0068
+
+#define mmNIC3_QM0_PQ_BASE_LO_0                                      0xDA0070
+
+#define mmNIC3_QM0_PQ_BASE_LO_1                                      0xDA0074
+
+#define mmNIC3_QM0_PQ_BASE_LO_2                                      0xDA0078
+
+#define mmNIC3_QM0_PQ_BASE_LO_3                                      0xDA007C
+
+#define mmNIC3_QM0_PQ_BASE_HI_0                                      0xDA0080
+
+#define mmNIC3_QM0_PQ_BASE_HI_1                                      0xDA0084
+
+#define mmNIC3_QM0_PQ_BASE_HI_2                                      0xDA0088
+
+#define mmNIC3_QM0_PQ_BASE_HI_3                                      0xDA008C
+
+#define mmNIC3_QM0_PQ_SIZE_0                                         0xDA0090
+
+#define mmNIC3_QM0_PQ_SIZE_1                                         0xDA0094
+
+#define mmNIC3_QM0_PQ_SIZE_2                                         0xDA0098
+
+#define mmNIC3_QM0_PQ_SIZE_3                                         0xDA009C
+
+#define mmNIC3_QM0_PQ_PI_0                                           0xDA00A0
+
+#define mmNIC3_QM0_PQ_PI_1                                           0xDA00A4
+
+#define mmNIC3_QM0_PQ_PI_2                                           0xDA00A8
+
+#define mmNIC3_QM0_PQ_PI_3                                           0xDA00AC
+
+#define mmNIC3_QM0_PQ_CI_0                                           0xDA00B0
+
+#define mmNIC3_QM0_PQ_CI_1                                           0xDA00B4
+
+#define mmNIC3_QM0_PQ_CI_2                                           0xDA00B8
+
+#define mmNIC3_QM0_PQ_CI_3                                           0xDA00BC
+
+#define mmNIC3_QM0_PQ_CFG0_0                                         0xDA00C0
+
+#define mmNIC3_QM0_PQ_CFG0_1                                         0xDA00C4
+
+#define mmNIC3_QM0_PQ_CFG0_2                                         0xDA00C8
+
+#define mmNIC3_QM0_PQ_CFG0_3                                         0xDA00CC
+
+#define mmNIC3_QM0_PQ_CFG1_0                                         0xDA00D0
+
+#define mmNIC3_QM0_PQ_CFG1_1                                         0xDA00D4
+
+#define mmNIC3_QM0_PQ_CFG1_2                                         0xDA00D8
+
+#define mmNIC3_QM0_PQ_CFG1_3                                         0xDA00DC
+
+#define mmNIC3_QM0_PQ_ARUSER_31_11_0                                 0xDA00E0
+
+#define mmNIC3_QM0_PQ_ARUSER_31_11_1                                 0xDA00E4
+
+#define mmNIC3_QM0_PQ_ARUSER_31_11_2                                 0xDA00E8
+
+#define mmNIC3_QM0_PQ_ARUSER_31_11_3                                 0xDA00EC
+
+#define mmNIC3_QM0_PQ_STS0_0                                         0xDA00F0
+
+#define mmNIC3_QM0_PQ_STS0_1                                         0xDA00F4
+
+#define mmNIC3_QM0_PQ_STS0_2                                         0xDA00F8
+
+#define mmNIC3_QM0_PQ_STS0_3                                         0xDA00FC
+
+#define mmNIC3_QM0_PQ_STS1_0                                         0xDA0100
+
+#define mmNIC3_QM0_PQ_STS1_1                                         0xDA0104
+
+#define mmNIC3_QM0_PQ_STS1_2                                         0xDA0108
+
+#define mmNIC3_QM0_PQ_STS1_3                                         0xDA010C
+
+#define mmNIC3_QM0_CQ_CFG0_0                                         0xDA0110
+
+#define mmNIC3_QM0_CQ_CFG0_1                                         0xDA0114
+
+#define mmNIC3_QM0_CQ_CFG0_2                                         0xDA0118
+
+#define mmNIC3_QM0_CQ_CFG0_3                                         0xDA011C
+
+#define mmNIC3_QM0_CQ_CFG0_4                                         0xDA0120
+
+#define mmNIC3_QM0_CQ_CFG1_0                                         0xDA0124
+
+#define mmNIC3_QM0_CQ_CFG1_1                                         0xDA0128
+
+#define mmNIC3_QM0_CQ_CFG1_2                                         0xDA012C
+
+#define mmNIC3_QM0_CQ_CFG1_3                                         0xDA0130
+
+#define mmNIC3_QM0_CQ_CFG1_4                                         0xDA0134
+
+#define mmNIC3_QM0_CQ_ARUSER_31_11_0                                 0xDA0138
+
+#define mmNIC3_QM0_CQ_ARUSER_31_11_1                                 0xDA013C
+
+#define mmNIC3_QM0_CQ_ARUSER_31_11_2                                 0xDA0140
+
+#define mmNIC3_QM0_CQ_ARUSER_31_11_3                                 0xDA0144
+
+#define mmNIC3_QM0_CQ_ARUSER_31_11_4                                 0xDA0148
+
+#define mmNIC3_QM0_CQ_STS0_0                                         0xDA014C
+
+#define mmNIC3_QM0_CQ_STS0_1                                         0xDA0150
+
+#define mmNIC3_QM0_CQ_STS0_2                                         0xDA0154
+
+#define mmNIC3_QM0_CQ_STS0_3                                         0xDA0158
+
+#define mmNIC3_QM0_CQ_STS0_4                                         0xDA015C
+
+#define mmNIC3_QM0_CQ_STS1_0                                         0xDA0160
+
+#define mmNIC3_QM0_CQ_STS1_1                                         0xDA0164
+
+#define mmNIC3_QM0_CQ_STS1_2                                         0xDA0168
+
+#define mmNIC3_QM0_CQ_STS1_3                                         0xDA016C
+
+#define mmNIC3_QM0_CQ_STS1_4                                         0xDA0170
+
+#define mmNIC3_QM0_CQ_PTR_LO_0                                       0xDA0174
+
+#define mmNIC3_QM0_CQ_PTR_HI_0                                       0xDA0178
+
+#define mmNIC3_QM0_CQ_TSIZE_0                                        0xDA017C
+
+#define mmNIC3_QM0_CQ_CTL_0                                          0xDA0180
+
+#define mmNIC3_QM0_CQ_PTR_LO_1                                       0xDA0184
+
+#define mmNIC3_QM0_CQ_PTR_HI_1                                       0xDA0188
+
+#define mmNIC3_QM0_CQ_TSIZE_1                                        0xDA018C
+
+#define mmNIC3_QM0_CQ_CTL_1                                          0xDA0190
+
+#define mmNIC3_QM0_CQ_PTR_LO_2                                       0xDA0194
+
+#define mmNIC3_QM0_CQ_PTR_HI_2                                       0xDA0198
+
+#define mmNIC3_QM0_CQ_TSIZE_2                                        0xDA019C
+
+#define mmNIC3_QM0_CQ_CTL_2                                          0xDA01A0
+
+#define mmNIC3_QM0_CQ_PTR_LO_3                                       0xDA01A4
+
+#define mmNIC3_QM0_CQ_PTR_HI_3                                       0xDA01A8
+
+#define mmNIC3_QM0_CQ_TSIZE_3                                        0xDA01AC
+
+#define mmNIC3_QM0_CQ_CTL_3                                          0xDA01B0
+
+#define mmNIC3_QM0_CQ_PTR_LO_4                                       0xDA01B4
+
+#define mmNIC3_QM0_CQ_PTR_HI_4                                       0xDA01B8
+
+#define mmNIC3_QM0_CQ_TSIZE_4                                        0xDA01BC
+
+#define mmNIC3_QM0_CQ_CTL_4                                          0xDA01C0
+
+#define mmNIC3_QM0_CQ_PTR_LO_STS_0                                   0xDA01C4
+
+#define mmNIC3_QM0_CQ_PTR_LO_STS_1                                   0xDA01C8
+
+#define mmNIC3_QM0_CQ_PTR_LO_STS_2                                   0xDA01CC
+
+#define mmNIC3_QM0_CQ_PTR_LO_STS_3                                   0xDA01D0
+
+#define mmNIC3_QM0_CQ_PTR_LO_STS_4                                   0xDA01D4
+
+#define mmNIC3_QM0_CQ_PTR_HI_STS_0                                   0xDA01D8
+
+#define mmNIC3_QM0_CQ_PTR_HI_STS_1                                   0xDA01DC
+
+#define mmNIC3_QM0_CQ_PTR_HI_STS_2                                   0xDA01E0
+
+#define mmNIC3_QM0_CQ_PTR_HI_STS_3                                   0xDA01E4
+
+#define mmNIC3_QM0_CQ_PTR_HI_STS_4                                   0xDA01E8
+
+#define mmNIC3_QM0_CQ_TSIZE_STS_0                                    0xDA01EC
+
+#define mmNIC3_QM0_CQ_TSIZE_STS_1                                    0xDA01F0
+
+#define mmNIC3_QM0_CQ_TSIZE_STS_2                                    0xDA01F4
+
+#define mmNIC3_QM0_CQ_TSIZE_STS_3                                    0xDA01F8
+
+#define mmNIC3_QM0_CQ_TSIZE_STS_4                                    0xDA01FC
+
+#define mmNIC3_QM0_CQ_CTL_STS_0                                      0xDA0200
+
+#define mmNIC3_QM0_CQ_CTL_STS_1                                      0xDA0204
+
+#define mmNIC3_QM0_CQ_CTL_STS_2                                      0xDA0208
+
+#define mmNIC3_QM0_CQ_CTL_STS_3                                      0xDA020C
+
+#define mmNIC3_QM0_CQ_CTL_STS_4                                      0xDA0210
+
+#define mmNIC3_QM0_CQ_IFIFO_CNT_0                                    0xDA0214
+
+#define mmNIC3_QM0_CQ_IFIFO_CNT_1                                    0xDA0218
+
+#define mmNIC3_QM0_CQ_IFIFO_CNT_2                                    0xDA021C
+
+#define mmNIC3_QM0_CQ_IFIFO_CNT_3                                    0xDA0220
+
+#define mmNIC3_QM0_CQ_IFIFO_CNT_4                                    0xDA0224
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_0                            0xDA0228
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_1                            0xDA022C
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_2                            0xDA0230
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_3                            0xDA0234
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_LO_4                            0xDA0238
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_0                            0xDA023C
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_1                            0xDA0240
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_2                            0xDA0244
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_3                            0xDA0248
+
+#define mmNIC3_QM0_CP_MSG_BASE0_ADDR_HI_4                            0xDA024C
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_0                            0xDA0250
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_1                            0xDA0254
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_2                            0xDA0258
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_3                            0xDA025C
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_LO_4                            0xDA0260
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_0                            0xDA0264
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_1                            0xDA0268
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_2                            0xDA026C
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_3                            0xDA0270
+
+#define mmNIC3_QM0_CP_MSG_BASE1_ADDR_HI_4                            0xDA0274
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_0                            0xDA0278
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_1                            0xDA027C
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_2                            0xDA0280
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_3                            0xDA0284
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_LO_4                            0xDA0288
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_0                            0xDA028C
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_1                            0xDA0290
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_2                            0xDA0294
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_3                            0xDA0298
+
+#define mmNIC3_QM0_CP_MSG_BASE2_ADDR_HI_4                            0xDA029C
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_0                            0xDA02A0
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_1                            0xDA02A4
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_2                            0xDA02A8
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_3                            0xDA02AC
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_LO_4                            0xDA02B0
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_0                            0xDA02B4
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_1                            0xDA02B8
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_2                            0xDA02BC
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_3                            0xDA02C0
+
+#define mmNIC3_QM0_CP_MSG_BASE3_ADDR_HI_4                            0xDA02C4
+
+#define mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_0                            0xDA02C8
+
+#define mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_1                            0xDA02CC
+
+#define mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_2                            0xDA02D0
+
+#define mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_3                            0xDA02D4
+
+#define mmNIC3_QM0_CP_LDMA_TSIZE_OFFSET_4                            0xDA02D8
+
+#define mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xDA02E0
+
+#define mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xDA02E4
+
+#define mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xDA02E8
+
+#define mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xDA02EC
+
+#define mmNIC3_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xDA02F0
+
+#define mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xDA02F4
+
+#define mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xDA02F8
+
+#define mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xDA02FC
+
+#define mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xDA0300
+
+#define mmNIC3_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xDA0304
+
+#define mmNIC3_QM0_CP_FENCE0_RDATA_0                                 0xDA0308
+
+#define mmNIC3_QM0_CP_FENCE0_RDATA_1                                 0xDA030C
+
+#define mmNIC3_QM0_CP_FENCE0_RDATA_2                                 0xDA0310
+
+#define mmNIC3_QM0_CP_FENCE0_RDATA_3                                 0xDA0314
+
+#define mmNIC3_QM0_CP_FENCE0_RDATA_4                                 0xDA0318
+
+#define mmNIC3_QM0_CP_FENCE1_RDATA_0                                 0xDA031C
+
+#define mmNIC3_QM0_CP_FENCE1_RDATA_1                                 0xDA0320
+
+#define mmNIC3_QM0_CP_FENCE1_RDATA_2                                 0xDA0324
+
+#define mmNIC3_QM0_CP_FENCE1_RDATA_3                                 0xDA0328
+
+#define mmNIC3_QM0_CP_FENCE1_RDATA_4                                 0xDA032C
+
+#define mmNIC3_QM0_CP_FENCE2_RDATA_0                                 0xDA0330
+
+#define mmNIC3_QM0_CP_FENCE2_RDATA_1                                 0xDA0334
+
+#define mmNIC3_QM0_CP_FENCE2_RDATA_2                                 0xDA0338
+
+#define mmNIC3_QM0_CP_FENCE2_RDATA_3                                 0xDA033C
+
+#define mmNIC3_QM0_CP_FENCE2_RDATA_4                                 0xDA0340
+
+#define mmNIC3_QM0_CP_FENCE3_RDATA_0                                 0xDA0344
+
+#define mmNIC3_QM0_CP_FENCE3_RDATA_1                                 0xDA0348
+
+#define mmNIC3_QM0_CP_FENCE3_RDATA_2                                 0xDA034C
+
+#define mmNIC3_QM0_CP_FENCE3_RDATA_3                                 0xDA0350
+
+#define mmNIC3_QM0_CP_FENCE3_RDATA_4                                 0xDA0354
+
+#define mmNIC3_QM0_CP_FENCE0_CNT_0                                   0xDA0358
+
+#define mmNIC3_QM0_CP_FENCE0_CNT_1                                   0xDA035C
+
+#define mmNIC3_QM0_CP_FENCE0_CNT_2                                   0xDA0360
+
+#define mmNIC3_QM0_CP_FENCE0_CNT_3                                   0xDA0364
+
+#define mmNIC3_QM0_CP_FENCE0_CNT_4                                   0xDA0368
+
+#define mmNIC3_QM0_CP_FENCE1_CNT_0                                   0xDA036C
+
+#define mmNIC3_QM0_CP_FENCE1_CNT_1                                   0xDA0370
+
+#define mmNIC3_QM0_CP_FENCE1_CNT_2                                   0xDA0374
+
+#define mmNIC3_QM0_CP_FENCE1_CNT_3                                   0xDA0378
+
+#define mmNIC3_QM0_CP_FENCE1_CNT_4                                   0xDA037C
+
+#define mmNIC3_QM0_CP_FENCE2_CNT_0                                   0xDA0380
+
+#define mmNIC3_QM0_CP_FENCE2_CNT_1                                   0xDA0384
+
+#define mmNIC3_QM0_CP_FENCE2_CNT_2                                   0xDA0388
+
+#define mmNIC3_QM0_CP_FENCE2_CNT_3                                   0xDA038C
+
+#define mmNIC3_QM0_CP_FENCE2_CNT_4                                   0xDA0390
+
+#define mmNIC3_QM0_CP_FENCE3_CNT_0                                   0xDA0394
+
+#define mmNIC3_QM0_CP_FENCE3_CNT_1                                   0xDA0398
+
+#define mmNIC3_QM0_CP_FENCE3_CNT_2                                   0xDA039C
+
+#define mmNIC3_QM0_CP_FENCE3_CNT_3                                   0xDA03A0
+
+#define mmNIC3_QM0_CP_FENCE3_CNT_4                                   0xDA03A4
+
+#define mmNIC3_QM0_CP_STS_0                                          0xDA03A8
+
+#define mmNIC3_QM0_CP_STS_1                                          0xDA03AC
+
+#define mmNIC3_QM0_CP_STS_2                                          0xDA03B0
+
+#define mmNIC3_QM0_CP_STS_3                                          0xDA03B4
+
+#define mmNIC3_QM0_CP_STS_4                                          0xDA03B8
+
+#define mmNIC3_QM0_CP_CURRENT_INST_LO_0                              0xDA03BC
+
+#define mmNIC3_QM0_CP_CURRENT_INST_LO_1                              0xDA03C0
+
+#define mmNIC3_QM0_CP_CURRENT_INST_LO_2                              0xDA03C4
+
+#define mmNIC3_QM0_CP_CURRENT_INST_LO_3                              0xDA03C8
+
+#define mmNIC3_QM0_CP_CURRENT_INST_LO_4                              0xDA03CC
+
+#define mmNIC3_QM0_CP_CURRENT_INST_HI_0                              0xDA03D0
+
+#define mmNIC3_QM0_CP_CURRENT_INST_HI_1                              0xDA03D4
+
+#define mmNIC3_QM0_CP_CURRENT_INST_HI_2                              0xDA03D8
+
+#define mmNIC3_QM0_CP_CURRENT_INST_HI_3                              0xDA03DC
+
+#define mmNIC3_QM0_CP_CURRENT_INST_HI_4                              0xDA03E0
+
+#define mmNIC3_QM0_CP_BARRIER_CFG_0                                  0xDA03F4
+
+#define mmNIC3_QM0_CP_BARRIER_CFG_1                                  0xDA03F8
+
+#define mmNIC3_QM0_CP_BARRIER_CFG_2                                  0xDA03FC
+
+#define mmNIC3_QM0_CP_BARRIER_CFG_3                                  0xDA0400
+
+#define mmNIC3_QM0_CP_BARRIER_CFG_4                                  0xDA0404
+
+#define mmNIC3_QM0_CP_DBG_0_0                                        0xDA0408
+
+#define mmNIC3_QM0_CP_DBG_0_1                                        0xDA040C
+
+#define mmNIC3_QM0_CP_DBG_0_2                                        0xDA0410
+
+#define mmNIC3_QM0_CP_DBG_0_3                                        0xDA0414
+
+#define mmNIC3_QM0_CP_DBG_0_4                                        0xDA0418
+
+#define mmNIC3_QM0_CP_ARUSER_31_11_0                                 0xDA041C
+
+#define mmNIC3_QM0_CP_ARUSER_31_11_1                                 0xDA0420
+
+#define mmNIC3_QM0_CP_ARUSER_31_11_2                                 0xDA0424
+
+#define mmNIC3_QM0_CP_ARUSER_31_11_3                                 0xDA0428
+
+#define mmNIC3_QM0_CP_ARUSER_31_11_4                                 0xDA042C
+
+#define mmNIC3_QM0_CP_AWUSER_31_11_0                                 0xDA0430
+
+#define mmNIC3_QM0_CP_AWUSER_31_11_1                                 0xDA0434
+
+#define mmNIC3_QM0_CP_AWUSER_31_11_2                                 0xDA0438
+
+#define mmNIC3_QM0_CP_AWUSER_31_11_3                                 0xDA043C
+
+#define mmNIC3_QM0_CP_AWUSER_31_11_4                                 0xDA0440
+
+#define mmNIC3_QM0_ARB_CFG_0                                         0xDA0A00
+
+#define mmNIC3_QM0_ARB_CHOISE_Q_PUSH                                 0xDA0A04
+
+#define mmNIC3_QM0_ARB_WRR_WEIGHT_0                                  0xDA0A08
+
+#define mmNIC3_QM0_ARB_WRR_WEIGHT_1                                  0xDA0A0C
+
+#define mmNIC3_QM0_ARB_WRR_WEIGHT_2                                  0xDA0A10
+
+#define mmNIC3_QM0_ARB_WRR_WEIGHT_3                                  0xDA0A14
+
+#define mmNIC3_QM0_ARB_CFG_1                                         0xDA0A18
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_0                              0xDA0A20
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_1                              0xDA0A24
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_2                              0xDA0A28
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_3                              0xDA0A2C
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_4                              0xDA0A30
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_5                              0xDA0A34
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_6                              0xDA0A38
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_7                              0xDA0A3C
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_8                              0xDA0A40
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_9                              0xDA0A44
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_10                             0xDA0A48
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_11                             0xDA0A4C
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_12                             0xDA0A50
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_13                             0xDA0A54
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_14                             0xDA0A58
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_15                             0xDA0A5C
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_16                             0xDA0A60
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_17                             0xDA0A64
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_18                             0xDA0A68
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_19                             0xDA0A6C
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_20                             0xDA0A70
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_21                             0xDA0A74
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_22                             0xDA0A78
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_23                             0xDA0A7C
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_24                             0xDA0A80
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_25                             0xDA0A84
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_26                             0xDA0A88
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_27                             0xDA0A8C
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_28                             0xDA0A90
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_29                             0xDA0A94
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_30                             0xDA0A98
+
+#define mmNIC3_QM0_ARB_MST_AVAIL_CRED_31                             0xDA0A9C
+
+#define mmNIC3_QM0_ARB_MST_CRED_INC                                  0xDA0AA0
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_0                        0xDA0AA4
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_1                        0xDA0AA8
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_2                        0xDA0AAC
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_3                        0xDA0AB0
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_4                        0xDA0AB4
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_5                        0xDA0AB8
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_6                        0xDA0ABC
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_7                        0xDA0AC0
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_8                        0xDA0AC4
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_9                        0xDA0AC8
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_10                       0xDA0ACC
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_11                       0xDA0AD0
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_12                       0xDA0AD4
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_13                       0xDA0AD8
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_14                       0xDA0ADC
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_15                       0xDA0AE0
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_16                       0xDA0AE4
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_17                       0xDA0AE8
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_18                       0xDA0AEC
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_19                       0xDA0AF0
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_20                       0xDA0AF4
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_21                       0xDA0AF8
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_22                       0xDA0AFC
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_23                       0xDA0B00
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_24                       0xDA0B04
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_25                       0xDA0B08
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_26                       0xDA0B0C
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_27                       0xDA0B10
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_28                       0xDA0B14
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_29                       0xDA0B18
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_30                       0xDA0B1C
+
+#define mmNIC3_QM0_ARB_MST_CHOISE_PUSH_OFST_31                       0xDA0B20
+
+#define mmNIC3_QM0_ARB_SLV_MASTER_INC_CRED_OFST                      0xDA0B28
+
+#define mmNIC3_QM0_ARB_MST_SLAVE_EN                                  0xDA0B2C
+
+#define mmNIC3_QM0_ARB_MST_QUIET_PER                                 0xDA0B34
+
+#define mmNIC3_QM0_ARB_SLV_CHOISE_WDT                                0xDA0B38
+
+#define mmNIC3_QM0_ARB_SLV_ID                                        0xDA0B3C
+
+#define mmNIC3_QM0_ARB_MSG_MAX_INFLIGHT                              0xDA0B44
+
+#define mmNIC3_QM0_ARB_MSG_AWUSER_31_11                              0xDA0B48
+
+#define mmNIC3_QM0_ARB_MSG_AWUSER_SEC_PROP                           0xDA0B4C
+
+#define mmNIC3_QM0_ARB_MSG_AWUSER_NON_SEC_PROP                       0xDA0B50
+
+#define mmNIC3_QM0_ARB_BASE_LO                                       0xDA0B54
+
+#define mmNIC3_QM0_ARB_BASE_HI                                       0xDA0B58
+
+#define mmNIC3_QM0_ARB_STATE_STS                                     0xDA0B80
+
+#define mmNIC3_QM0_ARB_CHOISE_FULLNESS_STS                           0xDA0B84
+
+#define mmNIC3_QM0_ARB_MSG_STS                                       0xDA0B88
+
+#define mmNIC3_QM0_ARB_SLV_CHOISE_Q_HEAD                             0xDA0B8C
+
+#define mmNIC3_QM0_ARB_ERR_CAUSE                                     0xDA0B9C
+
+#define mmNIC3_QM0_ARB_ERR_MSG_EN                                    0xDA0BA0
+
+#define mmNIC3_QM0_ARB_ERR_STS_DRP                                   0xDA0BA8
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_0                                0xDA0BB0
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_1                                0xDA0BB4
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_2                                0xDA0BB8
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_3                                0xDA0BBC
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_4                                0xDA0BC0
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_5                                0xDA0BC4
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_6                                0xDA0BC8
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_7                                0xDA0BCC
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_8                                0xDA0BD0
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_9                                0xDA0BD4
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_10                               0xDA0BD8
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_11                               0xDA0BDC
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_12                               0xDA0BE0
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_13                               0xDA0BE4
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_14                               0xDA0BE8
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_15                               0xDA0BEC
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_16                               0xDA0BF0
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_17                               0xDA0BF4
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_18                               0xDA0BF8
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_19                               0xDA0BFC
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_20                               0xDA0C00
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_21                               0xDA0C04
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_22                               0xDA0C08
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_23                               0xDA0C0C
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_24                               0xDA0C10
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_25                               0xDA0C14
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_26                               0xDA0C18
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_27                               0xDA0C1C
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_28                               0xDA0C20
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_29                               0xDA0C24
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_30                               0xDA0C28
+
+#define mmNIC3_QM0_ARB_MST_CRED_STS_31                               0xDA0C2C
+
+#define mmNIC3_QM0_CGM_CFG                                           0xDA0C70
+
+#define mmNIC3_QM0_CGM_STS                                           0xDA0C74
+
+#define mmNIC3_QM0_CGM_CFG1                                          0xDA0C78
+
+#define mmNIC3_QM0_LOCAL_RANGE_BASE                                  0xDA0C80
+
+#define mmNIC3_QM0_LOCAL_RANGE_SIZE                                  0xDA0C84
+
+#define mmNIC3_QM0_CSMR_STRICT_PRIO_CFG                              0xDA0C90
+
+#define mmNIC3_QM0_HBW_RD_RATE_LIM_CFG_1                             0xDA0C94
+
+#define mmNIC3_QM0_LBW_WR_RATE_LIM_CFG_0                             0xDA0C98
+
+#define mmNIC3_QM0_LBW_WR_RATE_LIM_CFG_1                             0xDA0C9C
+
+#define mmNIC3_QM0_HBW_RD_RATE_LIM_CFG_0                             0xDA0CA0
+
+#define mmNIC3_QM0_GLBL_AXCACHE                                      0xDA0CA4
+
+#define mmNIC3_QM0_IND_GW_APB_CFG                                    0xDA0CB0
+
+#define mmNIC3_QM0_IND_GW_APB_WDATA                                  0xDA0CB4
+
+#define mmNIC3_QM0_IND_GW_APB_RDATA                                  0xDA0CB8
+
+#define mmNIC3_QM0_IND_GW_APB_STATUS                                 0xDA0CBC
+
+#define mmNIC3_QM0_GLBL_ERR_ADDR_LO                                  0xDA0CD0
+
+#define mmNIC3_QM0_GLBL_ERR_ADDR_HI                                  0xDA0CD4
+
+#define mmNIC3_QM0_GLBL_ERR_WDATA                                    0xDA0CD8
+
+#define mmNIC3_QM0_GLBL_MEM_INIT_BUSY                                0xDA0D00
+
+#endif /* ASIC_REG_NIC3_QM0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
new file mode 100644
index 000000000000..7fa040f65004
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC3_QM1_REGS_H_
+#define ASIC_REG_NIC3_QM1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC3_QM1 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC3_QM1_GLBL_CFG0                                         0xDA2000
+
+#define mmNIC3_QM1_GLBL_CFG1                                         0xDA2004
+
+#define mmNIC3_QM1_GLBL_PROT                                         0xDA2008
+
+#define mmNIC3_QM1_GLBL_ERR_CFG                                      0xDA200C
+
+#define mmNIC3_QM1_GLBL_SECURE_PROPS_0                               0xDA2010
+
+#define mmNIC3_QM1_GLBL_SECURE_PROPS_1                               0xDA2014
+
+#define mmNIC3_QM1_GLBL_SECURE_PROPS_2                               0xDA2018
+
+#define mmNIC3_QM1_GLBL_SECURE_PROPS_3                               0xDA201C
+
+#define mmNIC3_QM1_GLBL_SECURE_PROPS_4                               0xDA2020
+
+#define mmNIC3_QM1_GLBL_NON_SECURE_PROPS_0                           0xDA2024
+
+#define mmNIC3_QM1_GLBL_NON_SECURE_PROPS_1                           0xDA2028
+
+#define mmNIC3_QM1_GLBL_NON_SECURE_PROPS_2                           0xDA202C
+
+#define mmNIC3_QM1_GLBL_NON_SECURE_PROPS_3                           0xDA2030
+
+#define mmNIC3_QM1_GLBL_NON_SECURE_PROPS_4                           0xDA2034
+
+#define mmNIC3_QM1_GLBL_STS0                                         0xDA2038
+
+#define mmNIC3_QM1_GLBL_STS1_0                                       0xDA2040
+
+#define mmNIC3_QM1_GLBL_STS1_1                                       0xDA2044
+
+#define mmNIC3_QM1_GLBL_STS1_2                                       0xDA2048
+
+#define mmNIC3_QM1_GLBL_STS1_3                                       0xDA204C
+
+#define mmNIC3_QM1_GLBL_STS1_4                                       0xDA2050
+
+#define mmNIC3_QM1_GLBL_MSG_EN_0                                     0xDA2054
+
+#define mmNIC3_QM1_GLBL_MSG_EN_1                                     0xDA2058
+
+#define mmNIC3_QM1_GLBL_MSG_EN_2                                     0xDA205C
+
+#define mmNIC3_QM1_GLBL_MSG_EN_3                                     0xDA2060
+
+#define mmNIC3_QM1_GLBL_MSG_EN_4                                     0xDA2068
+
+#define mmNIC3_QM1_PQ_BASE_LO_0                                      0xDA2070
+
+#define mmNIC3_QM1_PQ_BASE_LO_1                                      0xDA2074
+
+#define mmNIC3_QM1_PQ_BASE_LO_2                                      0xDA2078
+
+#define mmNIC3_QM1_PQ_BASE_LO_3                                      0xDA207C
+
+#define mmNIC3_QM1_PQ_BASE_HI_0                                      0xDA2080
+
+#define mmNIC3_QM1_PQ_BASE_HI_1                                      0xDA2084
+
+#define mmNIC3_QM1_PQ_BASE_HI_2                                      0xDA2088
+
+#define mmNIC3_QM1_PQ_BASE_HI_3                                      0xDA208C
+
+#define mmNIC3_QM1_PQ_SIZE_0                                         0xDA2090
+
+#define mmNIC3_QM1_PQ_SIZE_1                                         0xDA2094
+
+#define mmNIC3_QM1_PQ_SIZE_2                                         0xDA2098
+
+#define mmNIC3_QM1_PQ_SIZE_3                                         0xDA209C
+
+#define mmNIC3_QM1_PQ_PI_0                                           0xDA20A0
+
+#define mmNIC3_QM1_PQ_PI_1                                           0xDA20A4
+
+#define mmNIC3_QM1_PQ_PI_2                                           0xDA20A8
+
+#define mmNIC3_QM1_PQ_PI_3                                           0xDA20AC
+
+#define mmNIC3_QM1_PQ_CI_0                                           0xDA20B0
+
+#define mmNIC3_QM1_PQ_CI_1                                           0xDA20B4
+
+#define mmNIC3_QM1_PQ_CI_2                                           0xDA20B8
+
+#define mmNIC3_QM1_PQ_CI_3                                           0xDA20BC
+
+#define mmNIC3_QM1_PQ_CFG0_0                                         0xDA20C0
+
+#define mmNIC3_QM1_PQ_CFG0_1                                         0xDA20C4
+
+#define mmNIC3_QM1_PQ_CFG0_2                                         0xDA20C8
+
+#define mmNIC3_QM1_PQ_CFG0_3                                         0xDA20CC
+
+#define mmNIC3_QM1_PQ_CFG1_0                                         0xDA20D0
+
+#define mmNIC3_QM1_PQ_CFG1_1                                         0xDA20D4
+
+#define mmNIC3_QM1_PQ_CFG1_2                                         0xDA20D8
+
+#define mmNIC3_QM1_PQ_CFG1_3                                         0xDA20DC
+
+#define mmNIC3_QM1_PQ_ARUSER_31_11_0                                 0xDA20E0
+
+#define mmNIC3_QM1_PQ_ARUSER_31_11_1                                 0xDA20E4
+
+#define mmNIC3_QM1_PQ_ARUSER_31_11_2                                 0xDA20E8
+
+#define mmNIC3_QM1_PQ_ARUSER_31_11_3                                 0xDA20EC
+
+#define mmNIC3_QM1_PQ_STS0_0                                         0xDA20F0
+
+#define mmNIC3_QM1_PQ_STS0_1                                         0xDA20F4
+
+#define mmNIC3_QM1_PQ_STS0_2                                         0xDA20F8
+
+#define mmNIC3_QM1_PQ_STS0_3                                         0xDA20FC
+
+#define mmNIC3_QM1_PQ_STS1_0                                         0xDA2100
+
+#define mmNIC3_QM1_PQ_STS1_1                                         0xDA2104
+
+#define mmNIC3_QM1_PQ_STS1_2                                         0xDA2108
+
+#define mmNIC3_QM1_PQ_STS1_3                                         0xDA210C
+
+#define mmNIC3_QM1_CQ_CFG0_0                                         0xDA2110
+
+#define mmNIC3_QM1_CQ_CFG0_1                                         0xDA2114
+
+#define mmNIC3_QM1_CQ_CFG0_2                                         0xDA2118
+
+#define mmNIC3_QM1_CQ_CFG0_3                                         0xDA211C
+
+#define mmNIC3_QM1_CQ_CFG0_4                                         0xDA2120
+
+#define mmNIC3_QM1_CQ_CFG1_0                                         0xDA2124
+
+#define mmNIC3_QM1_CQ_CFG1_1                                         0xDA2128
+
+#define mmNIC3_QM1_CQ_CFG1_2                                         0xDA212C
+
+#define mmNIC3_QM1_CQ_CFG1_3                                         0xDA2130
+
+#define mmNIC3_QM1_CQ_CFG1_4                                         0xDA2134
+
+#define mmNIC3_QM1_CQ_ARUSER_31_11_0                                 0xDA2138
+
+#define mmNIC3_QM1_CQ_ARUSER_31_11_1                                 0xDA213C
+
+#define mmNIC3_QM1_CQ_ARUSER_31_11_2                                 0xDA2140
+
+#define mmNIC3_QM1_CQ_ARUSER_31_11_3                                 0xDA2144
+
+#define mmNIC3_QM1_CQ_ARUSER_31_11_4                                 0xDA2148
+
+#define mmNIC3_QM1_CQ_STS0_0                                         0xDA214C
+
+#define mmNIC3_QM1_CQ_STS0_1                                         0xDA2150
+
+#define mmNIC3_QM1_CQ_STS0_2                                         0xDA2154
+
+#define mmNIC3_QM1_CQ_STS0_3                                         0xDA2158
+
+#define mmNIC3_QM1_CQ_STS0_4                                         0xDA215C
+
+#define mmNIC3_QM1_CQ_STS1_0                                         0xDA2160
+
+#define mmNIC3_QM1_CQ_STS1_1                                         0xDA2164
+
+#define mmNIC3_QM1_CQ_STS1_2                                         0xDA2168
+
+#define mmNIC3_QM1_CQ_STS1_3                                         0xDA216C
+
+#define mmNIC3_QM1_CQ_STS1_4                                         0xDA2170
+
+#define mmNIC3_QM1_CQ_PTR_LO_0                                       0xDA2174
+
+#define mmNIC3_QM1_CQ_PTR_HI_0                                       0xDA2178
+
+#define mmNIC3_QM1_CQ_TSIZE_0                                        0xDA217C
+
+#define mmNIC3_QM1_CQ_CTL_0                                          0xDA2180
+
+#define mmNIC3_QM1_CQ_PTR_LO_1                                       0xDA2184
+
+#define mmNIC3_QM1_CQ_PTR_HI_1                                       0xDA2188
+
+#define mmNIC3_QM1_CQ_TSIZE_1                                        0xDA218C
+
+#define mmNIC3_QM1_CQ_CTL_1                                          0xDA2190
+
+#define mmNIC3_QM1_CQ_PTR_LO_2                                       0xDA2194
+
+#define mmNIC3_QM1_CQ_PTR_HI_2                                       0xDA2198
+
+#define mmNIC3_QM1_CQ_TSIZE_2                                        0xDA219C
+
+#define mmNIC3_QM1_CQ_CTL_2                                          0xDA21A0
+
+#define mmNIC3_QM1_CQ_PTR_LO_3                                       0xDA21A4
+
+#define mmNIC3_QM1_CQ_PTR_HI_3                                       0xDA21A8
+
+#define mmNIC3_QM1_CQ_TSIZE_3                                        0xDA21AC
+
+#define mmNIC3_QM1_CQ_CTL_3                                          0xDA21B0
+
+#define mmNIC3_QM1_CQ_PTR_LO_4                                       0xDA21B4
+
+#define mmNIC3_QM1_CQ_PTR_HI_4                                       0xDA21B8
+
+#define mmNIC3_QM1_CQ_TSIZE_4                                        0xDA21BC
+
+#define mmNIC3_QM1_CQ_CTL_4                                          0xDA21C0
+
+#define mmNIC3_QM1_CQ_PTR_LO_STS_0                                   0xDA21C4
+
+#define mmNIC3_QM1_CQ_PTR_LO_STS_1                                   0xDA21C8
+
+#define mmNIC3_QM1_CQ_PTR_LO_STS_2                                   0xDA21CC
+
+#define mmNIC3_QM1_CQ_PTR_LO_STS_3                                   0xDA21D0
+
+#define mmNIC3_QM1_CQ_PTR_LO_STS_4                                   0xDA21D4
+
+#define mmNIC3_QM1_CQ_PTR_HI_STS_0                                   0xDA21D8
+
+#define mmNIC3_QM1_CQ_PTR_HI_STS_1                                   0xDA21DC
+
+#define mmNIC3_QM1_CQ_PTR_HI_STS_2                                   0xDA21E0
+
+#define mmNIC3_QM1_CQ_PTR_HI_STS_3                                   0xDA21E4
+
+#define mmNIC3_QM1_CQ_PTR_HI_STS_4                                   0xDA21E8
+
+#define mmNIC3_QM1_CQ_TSIZE_STS_0                                    0xDA21EC
+
+#define mmNIC3_QM1_CQ_TSIZE_STS_1                                    0xDA21F0
+
+#define mmNIC3_QM1_CQ_TSIZE_STS_2                                    0xDA21F4
+
+#define mmNIC3_QM1_CQ_TSIZE_STS_3                                    0xDA21F8
+
+#define mmNIC3_QM1_CQ_TSIZE_STS_4                                    0xDA21FC
+
+#define mmNIC3_QM1_CQ_CTL_STS_0                                      0xDA2200
+
+#define mmNIC3_QM1_CQ_CTL_STS_1                                      0xDA2204
+
+#define mmNIC3_QM1_CQ_CTL_STS_2                                      0xDA2208
+
+#define mmNIC3_QM1_CQ_CTL_STS_3                                      0xDA220C
+
+#define mmNIC3_QM1_CQ_CTL_STS_4                                      0xDA2210
+
+#define mmNIC3_QM1_CQ_IFIFO_CNT_0                                    0xDA2214
+
+#define mmNIC3_QM1_CQ_IFIFO_CNT_1                                    0xDA2218
+
+#define mmNIC3_QM1_CQ_IFIFO_CNT_2                                    0xDA221C
+
+#define mmNIC3_QM1_CQ_IFIFO_CNT_3                                    0xDA2220
+
+#define mmNIC3_QM1_CQ_IFIFO_CNT_4                                    0xDA2224
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_0                            0xDA2228
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_1                            0xDA222C
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_2                            0xDA2230
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_3                            0xDA2234
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_LO_4                            0xDA2238
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_0                            0xDA223C
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_1                            0xDA2240
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_2                            0xDA2244
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_3                            0xDA2248
+
+#define mmNIC3_QM1_CP_MSG_BASE0_ADDR_HI_4                            0xDA224C
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_0                            0xDA2250
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_1                            0xDA2254
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_2                            0xDA2258
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_3                            0xDA225C
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_LO_4                            0xDA2260
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_0                            0xDA2264
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_1                            0xDA2268
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_2                            0xDA226C
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_3                            0xDA2270
+
+#define mmNIC3_QM1_CP_MSG_BASE1_ADDR_HI_4                            0xDA2274
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_0                            0xDA2278
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_1                            0xDA227C
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_2                            0xDA2280
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_3                            0xDA2284
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_LO_4                            0xDA2288
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_0                            0xDA228C
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_1                            0xDA2290
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_2                            0xDA2294
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_3                            0xDA2298
+
+#define mmNIC3_QM1_CP_MSG_BASE2_ADDR_HI_4                            0xDA229C
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_0                            0xDA22A0
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_1                            0xDA22A4
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_2                            0xDA22A8
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_3                            0xDA22AC
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_LO_4                            0xDA22B0
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_0                            0xDA22B4
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_1                            0xDA22B8
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_2                            0xDA22BC
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_3                            0xDA22C0
+
+#define mmNIC3_QM1_CP_MSG_BASE3_ADDR_HI_4                            0xDA22C4
+
+#define mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_0                            0xDA22C8
+
+#define mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_1                            0xDA22CC
+
+#define mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_2                            0xDA22D0
+
+#define mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_3                            0xDA22D4
+
+#define mmNIC3_QM1_CP_LDMA_TSIZE_OFFSET_4                            0xDA22D8
+
+#define mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xDA22E0
+
+#define mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xDA22E4
+
+#define mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xDA22E8
+
+#define mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xDA22EC
+
+#define mmNIC3_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xDA22F0
+
+#define mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xDA22F4
+
+#define mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xDA22F8
+
+#define mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xDA22FC
+
+#define mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xDA2300
+
+#define mmNIC3_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xDA2304
+
+#define mmNIC3_QM1_CP_FENCE0_RDATA_0                                 0xDA2308
+
+#define mmNIC3_QM1_CP_FENCE0_RDATA_1                                 0xDA230C
+
+#define mmNIC3_QM1_CP_FENCE0_RDATA_2                                 0xDA2310
+
+#define mmNIC3_QM1_CP_FENCE0_RDATA_3                                 0xDA2314
+
+#define mmNIC3_QM1_CP_FENCE0_RDATA_4                                 0xDA2318
+
+#define mmNIC3_QM1_CP_FENCE1_RDATA_0                                 0xDA231C
+
+#define mmNIC3_QM1_CP_FENCE1_RDATA_1                                 0xDA2320
+
+#define mmNIC3_QM1_CP_FENCE1_RDATA_2                                 0xDA2324
+
+#define mmNIC3_QM1_CP_FENCE1_RDATA_3                                 0xDA2328
+
+#define mmNIC3_QM1_CP_FENCE1_RDATA_4                                 0xDA232C
+
+#define mmNIC3_QM1_CP_FENCE2_RDATA_0                                 0xDA2330
+
+#define mmNIC3_QM1_CP_FENCE2_RDATA_1                                 0xDA2334
+
+#define mmNIC3_QM1_CP_FENCE2_RDATA_2                                 0xDA2338
+
+#define mmNIC3_QM1_CP_FENCE2_RDATA_3                                 0xDA233C
+
+#define mmNIC3_QM1_CP_FENCE2_RDATA_4                                 0xDA2340
+
+#define mmNIC3_QM1_CP_FENCE3_RDATA_0                                 0xDA2344
+
+#define mmNIC3_QM1_CP_FENCE3_RDATA_1                                 0xDA2348
+
+#define mmNIC3_QM1_CP_FENCE3_RDATA_2                                 0xDA234C
+
+#define mmNIC3_QM1_CP_FENCE3_RDATA_3                                 0xDA2350
+
+#define mmNIC3_QM1_CP_FENCE3_RDATA_4                                 0xDA2354
+
+#define mmNIC3_QM1_CP_FENCE0_CNT_0                                   0xDA2358
+
+#define mmNIC3_QM1_CP_FENCE0_CNT_1                                   0xDA235C
+
+#define mmNIC3_QM1_CP_FENCE0_CNT_2                                   0xDA2360
+
+#define mmNIC3_QM1_CP_FENCE0_CNT_3                                   0xDA2364
+
+#define mmNIC3_QM1_CP_FENCE0_CNT_4                                   0xDA2368
+
+#define mmNIC3_QM1_CP_FENCE1_CNT_0                                   0xDA236C
+
+#define mmNIC3_QM1_CP_FENCE1_CNT_1                                   0xDA2370
+
+#define mmNIC3_QM1_CP_FENCE1_CNT_2                                   0xDA2374
+
+#define mmNIC3_QM1_CP_FENCE1_CNT_3                                   0xDA2378
+
+#define mmNIC3_QM1_CP_FENCE1_CNT_4                                   0xDA237C
+
+#define mmNIC3_QM1_CP_FENCE2_CNT_0                                   0xDA2380
+
+#define mmNIC3_QM1_CP_FENCE2_CNT_1                                   0xDA2384
+
+#define mmNIC3_QM1_CP_FENCE2_CNT_2                                   0xDA2388
+
+#define mmNIC3_QM1_CP_FENCE2_CNT_3                                   0xDA238C
+
+#define mmNIC3_QM1_CP_FENCE2_CNT_4                                   0xDA2390
+
+#define mmNIC3_QM1_CP_FENCE3_CNT_0                                   0xDA2394
+
+#define mmNIC3_QM1_CP_FENCE3_CNT_1                                   0xDA2398
+
+#define mmNIC3_QM1_CP_FENCE3_CNT_2                                   0xDA239C
+
+#define mmNIC3_QM1_CP_FENCE3_CNT_3                                   0xDA23A0
+
+#define mmNIC3_QM1_CP_FENCE3_CNT_4                                   0xDA23A4
+
+#define mmNIC3_QM1_CP_STS_0                                          0xDA23A8
+
+#define mmNIC3_QM1_CP_STS_1                                          0xDA23AC
+
+#define mmNIC3_QM1_CP_STS_2                                          0xDA23B0
+
+#define mmNIC3_QM1_CP_STS_3                                          0xDA23B4
+
+#define mmNIC3_QM1_CP_STS_4                                          0xDA23B8
+
+#define mmNIC3_QM1_CP_CURRENT_INST_LO_0                              0xDA23BC
+
+#define mmNIC3_QM1_CP_CURRENT_INST_LO_1                              0xDA23C0
+
+#define mmNIC3_QM1_CP_CURRENT_INST_LO_2                              0xDA23C4
+
+#define mmNIC3_QM1_CP_CURRENT_INST_LO_3                              0xDA23C8
+
+#define mmNIC3_QM1_CP_CURRENT_INST_LO_4                              0xDA23CC
+
+#define mmNIC3_QM1_CP_CURRENT_INST_HI_0                              0xDA23D0
+
+#define mmNIC3_QM1_CP_CURRENT_INST_HI_1                              0xDA23D4
+
+#define mmNIC3_QM1_CP_CURRENT_INST_HI_2                              0xDA23D8
+
+#define mmNIC3_QM1_CP_CURRENT_INST_HI_3                              0xDA23DC
+
+#define mmNIC3_QM1_CP_CURRENT_INST_HI_4                              0xDA23E0
+
+#define mmNIC3_QM1_CP_BARRIER_CFG_0                                  0xDA23F4
+
+#define mmNIC3_QM1_CP_BARRIER_CFG_1                                  0xDA23F8
+
+#define mmNIC3_QM1_CP_BARRIER_CFG_2                                  0xDA23FC
+
+#define mmNIC3_QM1_CP_BARRIER_CFG_3                                  0xDA2400
+
+#define mmNIC3_QM1_CP_BARRIER_CFG_4                                  0xDA2404
+
+#define mmNIC3_QM1_CP_DBG_0_0                                        0xDA2408
+
+#define mmNIC3_QM1_CP_DBG_0_1                                        0xDA240C
+
+#define mmNIC3_QM1_CP_DBG_0_2                                        0xDA2410
+
+#define mmNIC3_QM1_CP_DBG_0_3                                        0xDA2414
+
+#define mmNIC3_QM1_CP_DBG_0_4                                        0xDA2418
+
+#define mmNIC3_QM1_CP_ARUSER_31_11_0                                 0xDA241C
+
+#define mmNIC3_QM1_CP_ARUSER_31_11_1                                 0xDA2420
+
+#define mmNIC3_QM1_CP_ARUSER_31_11_2                                 0xDA2424
+
+#define mmNIC3_QM1_CP_ARUSER_31_11_3                                 0xDA2428
+
+#define mmNIC3_QM1_CP_ARUSER_31_11_4                                 0xDA242C
+
+#define mmNIC3_QM1_CP_AWUSER_31_11_0                                 0xDA2430
+
+#define mmNIC3_QM1_CP_AWUSER_31_11_1                                 0xDA2434
+
+#define mmNIC3_QM1_CP_AWUSER_31_11_2                                 0xDA2438
+
+#define mmNIC3_QM1_CP_AWUSER_31_11_3                                 0xDA243C
+
+#define mmNIC3_QM1_CP_AWUSER_31_11_4                                 0xDA2440
+
+#define mmNIC3_QM1_ARB_CFG_0                                         0xDA2A00
+
+#define mmNIC3_QM1_ARB_CHOISE_Q_PUSH                                 0xDA2A04
+
+#define mmNIC3_QM1_ARB_WRR_WEIGHT_0                                  0xDA2A08
+
+#define mmNIC3_QM1_ARB_WRR_WEIGHT_1                                  0xDA2A0C
+
+#define mmNIC3_QM1_ARB_WRR_WEIGHT_2                                  0xDA2A10
+
+#define mmNIC3_QM1_ARB_WRR_WEIGHT_3                                  0xDA2A14
+
+#define mmNIC3_QM1_ARB_CFG_1                                         0xDA2A18
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_0                              0xDA2A20
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_1                              0xDA2A24
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_2                              0xDA2A28
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_3                              0xDA2A2C
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_4                              0xDA2A30
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_5                              0xDA2A34
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_6                              0xDA2A38
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_7                              0xDA2A3C
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_8                              0xDA2A40
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_9                              0xDA2A44
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_10                             0xDA2A48
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_11                             0xDA2A4C
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_12                             0xDA2A50
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_13                             0xDA2A54
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_14                             0xDA2A58
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_15                             0xDA2A5C
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_16                             0xDA2A60
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_17                             0xDA2A64
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_18                             0xDA2A68
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_19                             0xDA2A6C
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_20                             0xDA2A70
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_21                             0xDA2A74
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_22                             0xDA2A78
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_23                             0xDA2A7C
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_24                             0xDA2A80
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_25                             0xDA2A84
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_26                             0xDA2A88
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_27                             0xDA2A8C
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_28                             0xDA2A90
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_29                             0xDA2A94
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_30                             0xDA2A98
+
+#define mmNIC3_QM1_ARB_MST_AVAIL_CRED_31                             0xDA2A9C
+
+#define mmNIC3_QM1_ARB_MST_CRED_INC                                  0xDA2AA0
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_0                        0xDA2AA4
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_1                        0xDA2AA8
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_2                        0xDA2AAC
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_3                        0xDA2AB0
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_4                        0xDA2AB4
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_5                        0xDA2AB8
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_6                        0xDA2ABC
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_7                        0xDA2AC0
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_8                        0xDA2AC4
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_9                        0xDA2AC8
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_10                       0xDA2ACC
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_11                       0xDA2AD0
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_12                       0xDA2AD4
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_13                       0xDA2AD8
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_14                       0xDA2ADC
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_15                       0xDA2AE0
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_16                       0xDA2AE4
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_17                       0xDA2AE8
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_18                       0xDA2AEC
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_19                       0xDA2AF0
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_20                       0xDA2AF4
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_21                       0xDA2AF8
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_22                       0xDA2AFC
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_23                       0xDA2B00
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_24                       0xDA2B04
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_25                       0xDA2B08
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_26                       0xDA2B0C
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_27                       0xDA2B10
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_28                       0xDA2B14
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_29                       0xDA2B18
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_30                       0xDA2B1C
+
+#define mmNIC3_QM1_ARB_MST_CHOISE_PUSH_OFST_31                       0xDA2B20
+
+#define mmNIC3_QM1_ARB_SLV_MASTER_INC_CRED_OFST                      0xDA2B28
+
+#define mmNIC3_QM1_ARB_MST_SLAVE_EN                                  0xDA2B2C
+
+#define mmNIC3_QM1_ARB_MST_QUIET_PER                                 0xDA2B34
+
+#define mmNIC3_QM1_ARB_SLV_CHOISE_WDT                                0xDA2B38
+
+#define mmNIC3_QM1_ARB_SLV_ID                                        0xDA2B3C
+
+#define mmNIC3_QM1_ARB_MSG_MAX_INFLIGHT                              0xDA2B44
+
+#define mmNIC3_QM1_ARB_MSG_AWUSER_31_11                              0xDA2B48
+
+#define mmNIC3_QM1_ARB_MSG_AWUSER_SEC_PROP                           0xDA2B4C
+
+#define mmNIC3_QM1_ARB_MSG_AWUSER_NON_SEC_PROP                       0xDA2B50
+
+#define mmNIC3_QM1_ARB_BASE_LO                                       0xDA2B54
+
+#define mmNIC3_QM1_ARB_BASE_HI                                       0xDA2B58
+
+#define mmNIC3_QM1_ARB_STATE_STS                                     0xDA2B80
+
+#define mmNIC3_QM1_ARB_CHOISE_FULLNESS_STS                           0xDA2B84
+
+#define mmNIC3_QM1_ARB_MSG_STS                                       0xDA2B88
+
+#define mmNIC3_QM1_ARB_SLV_CHOISE_Q_HEAD                             0xDA2B8C
+
+#define mmNIC3_QM1_ARB_ERR_CAUSE                                     0xDA2B9C
+
+#define mmNIC3_QM1_ARB_ERR_MSG_EN                                    0xDA2BA0
+
+#define mmNIC3_QM1_ARB_ERR_STS_DRP                                   0xDA2BA8
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_0                                0xDA2BB0
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_1                                0xDA2BB4
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_2                                0xDA2BB8
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_3                                0xDA2BBC
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_4                                0xDA2BC0
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_5                                0xDA2BC4
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_6                                0xDA2BC8
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_7                                0xDA2BCC
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_8                                0xDA2BD0
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_9                                0xDA2BD4
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_10                               0xDA2BD8
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_11                               0xDA2BDC
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_12                               0xDA2BE0
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_13                               0xDA2BE4
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_14                               0xDA2BE8
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_15                               0xDA2BEC
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_16                               0xDA2BF0
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_17                               0xDA2BF4
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_18                               0xDA2BF8
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_19                               0xDA2BFC
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_20                               0xDA2C00
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_21                               0xDA2C04
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_22                               0xDA2C08
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_23                               0xDA2C0C
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_24                               0xDA2C10
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_25                               0xDA2C14
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_26                               0xDA2C18
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_27                               0xDA2C1C
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_28                               0xDA2C20
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_29                               0xDA2C24
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_30                               0xDA2C28
+
+#define mmNIC3_QM1_ARB_MST_CRED_STS_31                               0xDA2C2C
+
+#define mmNIC3_QM1_CGM_CFG                                           0xDA2C70
+
+#define mmNIC3_QM1_CGM_STS                                           0xDA2C74
+
+#define mmNIC3_QM1_CGM_CFG1                                          0xDA2C78
+
+#define mmNIC3_QM1_LOCAL_RANGE_BASE                                  0xDA2C80
+
+#define mmNIC3_QM1_LOCAL_RANGE_SIZE                                  0xDA2C84
+
+#define mmNIC3_QM1_CSMR_STRICT_PRIO_CFG                              0xDA2C90
+
+#define mmNIC3_QM1_HBW_RD_RATE_LIM_CFG_1                             0xDA2C94
+
+#define mmNIC3_QM1_LBW_WR_RATE_LIM_CFG_0                             0xDA2C98
+
+#define mmNIC3_QM1_LBW_WR_RATE_LIM_CFG_1                             0xDA2C9C
+
+#define mmNIC3_QM1_HBW_RD_RATE_LIM_CFG_0                             0xDA2CA0
+
+#define mmNIC3_QM1_GLBL_AXCACHE                                      0xDA2CA4
+
+#define mmNIC3_QM1_IND_GW_APB_CFG                                    0xDA2CB0
+
+#define mmNIC3_QM1_IND_GW_APB_WDATA                                  0xDA2CB4
+
+#define mmNIC3_QM1_IND_GW_APB_RDATA                                  0xDA2CB8
+
+#define mmNIC3_QM1_IND_GW_APB_STATUS                                 0xDA2CBC
+
+#define mmNIC3_QM1_GLBL_ERR_ADDR_LO                                  0xDA2CD0
+
+#define mmNIC3_QM1_GLBL_ERR_ADDR_HI                                  0xDA2CD4
+
+#define mmNIC3_QM1_GLBL_ERR_WDATA                                    0xDA2CD8
+
+#define mmNIC3_QM1_GLBL_MEM_INIT_BUSY                                0xDA2D00
+
+#endif /* ASIC_REG_NIC3_QM1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
new file mode 100644
index 000000000000..99d5319672dd
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC4_QM0_REGS_H_
+#define ASIC_REG_NIC4_QM0_REGS_H_
+
+/*
+ *****************************************
+ *   NIC4_QM0 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC4_QM0_GLBL_CFG0                                         0xDE0000
+
+#define mmNIC4_QM0_GLBL_CFG1                                         0xDE0004
+
+#define mmNIC4_QM0_GLBL_PROT                                         0xDE0008
+
+#define mmNIC4_QM0_GLBL_ERR_CFG                                      0xDE000C
+
+#define mmNIC4_QM0_GLBL_SECURE_PROPS_0                               0xDE0010
+
+#define mmNIC4_QM0_GLBL_SECURE_PROPS_1                               0xDE0014
+
+#define mmNIC4_QM0_GLBL_SECURE_PROPS_2                               0xDE0018
+
+#define mmNIC4_QM0_GLBL_SECURE_PROPS_3                               0xDE001C
+
+#define mmNIC4_QM0_GLBL_SECURE_PROPS_4                               0xDE0020
+
+#define mmNIC4_QM0_GLBL_NON_SECURE_PROPS_0                           0xDE0024
+
+#define mmNIC4_QM0_GLBL_NON_SECURE_PROPS_1                           0xDE0028
+
+#define mmNIC4_QM0_GLBL_NON_SECURE_PROPS_2                           0xDE002C
+
+#define mmNIC4_QM0_GLBL_NON_SECURE_PROPS_3                           0xDE0030
+
+#define mmNIC4_QM0_GLBL_NON_SECURE_PROPS_4                           0xDE0034
+
+#define mmNIC4_QM0_GLBL_STS0                                         0xDE0038
+
+#define mmNIC4_QM0_GLBL_STS1_0                                       0xDE0040
+
+#define mmNIC4_QM0_GLBL_STS1_1                                       0xDE0044
+
+#define mmNIC4_QM0_GLBL_STS1_2                                       0xDE0048
+
+#define mmNIC4_QM0_GLBL_STS1_3                                       0xDE004C
+
+#define mmNIC4_QM0_GLBL_STS1_4                                       0xDE0050
+
+#define mmNIC4_QM0_GLBL_MSG_EN_0                                     0xDE0054
+
+#define mmNIC4_QM0_GLBL_MSG_EN_1                                     0xDE0058
+
+#define mmNIC4_QM0_GLBL_MSG_EN_2                                     0xDE005C
+
+#define mmNIC4_QM0_GLBL_MSG_EN_3                                     0xDE0060
+
+#define mmNIC4_QM0_GLBL_MSG_EN_4                                     0xDE0068
+
+#define mmNIC4_QM0_PQ_BASE_LO_0                                      0xDE0070
+
+#define mmNIC4_QM0_PQ_BASE_LO_1                                      0xDE0074
+
+#define mmNIC4_QM0_PQ_BASE_LO_2                                      0xDE0078
+
+#define mmNIC4_QM0_PQ_BASE_LO_3                                      0xDE007C
+
+#define mmNIC4_QM0_PQ_BASE_HI_0                                      0xDE0080
+
+#define mmNIC4_QM0_PQ_BASE_HI_1                                      0xDE0084
+
+#define mmNIC4_QM0_PQ_BASE_HI_2                                      0xDE0088
+
+#define mmNIC4_QM0_PQ_BASE_HI_3                                      0xDE008C
+
+#define mmNIC4_QM0_PQ_SIZE_0                                         0xDE0090
+
+#define mmNIC4_QM0_PQ_SIZE_1                                         0xDE0094
+
+#define mmNIC4_QM0_PQ_SIZE_2                                         0xDE0098
+
+#define mmNIC4_QM0_PQ_SIZE_3                                         0xDE009C
+
+#define mmNIC4_QM0_PQ_PI_0                                           0xDE00A0
+
+#define mmNIC4_QM0_PQ_PI_1                                           0xDE00A4
+
+#define mmNIC4_QM0_PQ_PI_2                                           0xDE00A8
+
+#define mmNIC4_QM0_PQ_PI_3                                           0xDE00AC
+
+#define mmNIC4_QM0_PQ_CI_0                                           0xDE00B0
+
+#define mmNIC4_QM0_PQ_CI_1                                           0xDE00B4
+
+#define mmNIC4_QM0_PQ_CI_2                                           0xDE00B8
+
+#define mmNIC4_QM0_PQ_CI_3                                           0xDE00BC
+
+#define mmNIC4_QM0_PQ_CFG0_0                                         0xDE00C0
+
+#define mmNIC4_QM0_PQ_CFG0_1                                         0xDE00C4
+
+#define mmNIC4_QM0_PQ_CFG0_2                                         0xDE00C8
+
+#define mmNIC4_QM0_PQ_CFG0_3                                         0xDE00CC
+
+#define mmNIC4_QM0_PQ_CFG1_0                                         0xDE00D0
+
+#define mmNIC4_QM0_PQ_CFG1_1                                         0xDE00D4
+
+#define mmNIC4_QM0_PQ_CFG1_2                                         0xDE00D8
+
+#define mmNIC4_QM0_PQ_CFG1_3                                         0xDE00DC
+
+#define mmNIC4_QM0_PQ_ARUSER_31_11_0                                 0xDE00E0
+
+#define mmNIC4_QM0_PQ_ARUSER_31_11_1                                 0xDE00E4
+
+#define mmNIC4_QM0_PQ_ARUSER_31_11_2                                 0xDE00E8
+
+#define mmNIC4_QM0_PQ_ARUSER_31_11_3                                 0xDE00EC
+
+#define mmNIC4_QM0_PQ_STS0_0                                         0xDE00F0
+
+#define mmNIC4_QM0_PQ_STS0_1                                         0xDE00F4
+
+#define mmNIC4_QM0_PQ_STS0_2                                         0xDE00F8
+
+#define mmNIC4_QM0_PQ_STS0_3                                         0xDE00FC
+
+#define mmNIC4_QM0_PQ_STS1_0                                         0xDE0100
+
+#define mmNIC4_QM0_PQ_STS1_1                                         0xDE0104
+
+#define mmNIC4_QM0_PQ_STS1_2                                         0xDE0108
+
+#define mmNIC4_QM0_PQ_STS1_3                                         0xDE010C
+
+#define mmNIC4_QM0_CQ_CFG0_0                                         0xDE0110
+
+#define mmNIC4_QM0_CQ_CFG0_1                                         0xDE0114
+
+#define mmNIC4_QM0_CQ_CFG0_2                                         0xDE0118
+
+#define mmNIC4_QM0_CQ_CFG0_3                                         0xDE011C
+
+#define mmNIC4_QM0_CQ_CFG0_4                                         0xDE0120
+
+#define mmNIC4_QM0_CQ_CFG1_0                                         0xDE0124
+
+#define mmNIC4_QM0_CQ_CFG1_1                                         0xDE0128
+
+#define mmNIC4_QM0_CQ_CFG1_2                                         0xDE012C
+
+#define mmNIC4_QM0_CQ_CFG1_3                                         0xDE0130
+
+#define mmNIC4_QM0_CQ_CFG1_4                                         0xDE0134
+
+#define mmNIC4_QM0_CQ_ARUSER_31_11_0                                 0xDE0138
+
+#define mmNIC4_QM0_CQ_ARUSER_31_11_1                                 0xDE013C
+
+#define mmNIC4_QM0_CQ_ARUSER_31_11_2                                 0xDE0140
+
+#define mmNIC4_QM0_CQ_ARUSER_31_11_3                                 0xDE0144
+
+#define mmNIC4_QM0_CQ_ARUSER_31_11_4                                 0xDE0148
+
+#define mmNIC4_QM0_CQ_STS0_0                                         0xDE014C
+
+#define mmNIC4_QM0_CQ_STS0_1                                         0xDE0150
+
+#define mmNIC4_QM0_CQ_STS0_2                                         0xDE0154
+
+#define mmNIC4_QM0_CQ_STS0_3                                         0xDE0158
+
+#define mmNIC4_QM0_CQ_STS0_4                                         0xDE015C
+
+#define mmNIC4_QM0_CQ_STS1_0                                         0xDE0160
+
+#define mmNIC4_QM0_CQ_STS1_1                                         0xDE0164
+
+#define mmNIC4_QM0_CQ_STS1_2                                         0xDE0168
+
+#define mmNIC4_QM0_CQ_STS1_3                                         0xDE016C
+
+#define mmNIC4_QM0_CQ_STS1_4                                         0xDE0170
+
+#define mmNIC4_QM0_CQ_PTR_LO_0                                       0xDE0174
+
+#define mmNIC4_QM0_CQ_PTR_HI_0                                       0xDE0178
+
+#define mmNIC4_QM0_CQ_TSIZE_0                                        0xDE017C
+
+#define mmNIC4_QM0_CQ_CTL_0                                          0xDE0180
+
+#define mmNIC4_QM0_CQ_PTR_LO_1                                       0xDE0184
+
+#define mmNIC4_QM0_CQ_PTR_HI_1                                       0xDE0188
+
+#define mmNIC4_QM0_CQ_TSIZE_1                                        0xDE018C
+
+#define mmNIC4_QM0_CQ_CTL_1                                          0xDE0190
+
+#define mmNIC4_QM0_CQ_PTR_LO_2                                       0xDE0194
+
+#define mmNIC4_QM0_CQ_PTR_HI_2                                       0xDE0198
+
+#define mmNIC4_QM0_CQ_TSIZE_2                                        0xDE019C
+
+#define mmNIC4_QM0_CQ_CTL_2                                          0xDE01A0
+
+#define mmNIC4_QM0_CQ_PTR_LO_3                                       0xDE01A4
+
+#define mmNIC4_QM0_CQ_PTR_HI_3                                       0xDE01A8
+
+#define mmNIC4_QM0_CQ_TSIZE_3                                        0xDE01AC
+
+#define mmNIC4_QM0_CQ_CTL_3                                          0xDE01B0
+
+#define mmNIC4_QM0_CQ_PTR_LO_4                                       0xDE01B4
+
+#define mmNIC4_QM0_CQ_PTR_HI_4                                       0xDE01B8
+
+#define mmNIC4_QM0_CQ_TSIZE_4                                        0xDE01BC
+
+#define mmNIC4_QM0_CQ_CTL_4                                          0xDE01C0
+
+#define mmNIC4_QM0_CQ_PTR_LO_STS_0                                   0xDE01C4
+
+#define mmNIC4_QM0_CQ_PTR_LO_STS_1                                   0xDE01C8
+
+#define mmNIC4_QM0_CQ_PTR_LO_STS_2                                   0xDE01CC
+
+#define mmNIC4_QM0_CQ_PTR_LO_STS_3                                   0xDE01D0
+
+#define mmNIC4_QM0_CQ_PTR_LO_STS_4                                   0xDE01D4
+
+#define mmNIC4_QM0_CQ_PTR_HI_STS_0                                   0xDE01D8
+
+#define mmNIC4_QM0_CQ_PTR_HI_STS_1                                   0xDE01DC
+
+#define mmNIC4_QM0_CQ_PTR_HI_STS_2                                   0xDE01E0
+
+#define mmNIC4_QM0_CQ_PTR_HI_STS_3                                   0xDE01E4
+
+#define mmNIC4_QM0_CQ_PTR_HI_STS_4                                   0xDE01E8
+
+#define mmNIC4_QM0_CQ_TSIZE_STS_0                                    0xDE01EC
+
+#define mmNIC4_QM0_CQ_TSIZE_STS_1                                    0xDE01F0
+
+#define mmNIC4_QM0_CQ_TSIZE_STS_2                                    0xDE01F4
+
+#define mmNIC4_QM0_CQ_TSIZE_STS_3                                    0xDE01F8
+
+#define mmNIC4_QM0_CQ_TSIZE_STS_4                                    0xDE01FC
+
+#define mmNIC4_QM0_CQ_CTL_STS_0                                      0xDE0200
+
+#define mmNIC4_QM0_CQ_CTL_STS_1                                      0xDE0204
+
+#define mmNIC4_QM0_CQ_CTL_STS_2                                      0xDE0208
+
+#define mmNIC4_QM0_CQ_CTL_STS_3                                      0xDE020C
+
+#define mmNIC4_QM0_CQ_CTL_STS_4                                      0xDE0210
+
+#define mmNIC4_QM0_CQ_IFIFO_CNT_0                                    0xDE0214
+
+#define mmNIC4_QM0_CQ_IFIFO_CNT_1                                    0xDE0218
+
+#define mmNIC4_QM0_CQ_IFIFO_CNT_2                                    0xDE021C
+
+#define mmNIC4_QM0_CQ_IFIFO_CNT_3                                    0xDE0220
+
+#define mmNIC4_QM0_CQ_IFIFO_CNT_4                                    0xDE0224
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_0                            0xDE0228
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_1                            0xDE022C
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_2                            0xDE0230
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_3                            0xDE0234
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_LO_4                            0xDE0238
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_0                            0xDE023C
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_1                            0xDE0240
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_2                            0xDE0244
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_3                            0xDE0248
+
+#define mmNIC4_QM0_CP_MSG_BASE0_ADDR_HI_4                            0xDE024C
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_0                            0xDE0250
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_1                            0xDE0254
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_2                            0xDE0258
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_3                            0xDE025C
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_LO_4                            0xDE0260
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_0                            0xDE0264
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_1                            0xDE0268
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_2                            0xDE026C
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_3                            0xDE0270
+
+#define mmNIC4_QM0_CP_MSG_BASE1_ADDR_HI_4                            0xDE0274
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_0                            0xDE0278
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_1                            0xDE027C
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_2                            0xDE0280
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_3                            0xDE0284
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_LO_4                            0xDE0288
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_0                            0xDE028C
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_1                            0xDE0290
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_2                            0xDE0294
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_3                            0xDE0298
+
+#define mmNIC4_QM0_CP_MSG_BASE2_ADDR_HI_4                            0xDE029C
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_0                            0xDE02A0
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_1                            0xDE02A4
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_2                            0xDE02A8
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_3                            0xDE02AC
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_LO_4                            0xDE02B0
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_0                            0xDE02B4
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_1                            0xDE02B8
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_2                            0xDE02BC
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_3                            0xDE02C0
+
+#define mmNIC4_QM0_CP_MSG_BASE3_ADDR_HI_4                            0xDE02C4
+
+#define mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_0                            0xDE02C8
+
+#define mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_1                            0xDE02CC
+
+#define mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_2                            0xDE02D0
+
+#define mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_3                            0xDE02D4
+
+#define mmNIC4_QM0_CP_LDMA_TSIZE_OFFSET_4                            0xDE02D8
+
+#define mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xDE02E0
+
+#define mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xDE02E4
+
+#define mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xDE02E8
+
+#define mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xDE02EC
+
+#define mmNIC4_QM0_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xDE02F0
+
+#define mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xDE02F4
+
+#define mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xDE02F8
+
+#define mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xDE02FC
+
+#define mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xDE0300
+
+#define mmNIC4_QM0_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xDE0304
+
+#define mmNIC4_QM0_CP_FENCE0_RDATA_0                                 0xDE0308
+
+#define mmNIC4_QM0_CP_FENCE0_RDATA_1                                 0xDE030C
+
+#define mmNIC4_QM0_CP_FENCE0_RDATA_2                                 0xDE0310
+
+#define mmNIC4_QM0_CP_FENCE0_RDATA_3                                 0xDE0314
+
+#define mmNIC4_QM0_CP_FENCE0_RDATA_4                                 0xDE0318
+
+#define mmNIC4_QM0_CP_FENCE1_RDATA_0                                 0xDE031C
+
+#define mmNIC4_QM0_CP_FENCE1_RDATA_1                                 0xDE0320
+
+#define mmNIC4_QM0_CP_FENCE1_RDATA_2                                 0xDE0324
+
+#define mmNIC4_QM0_CP_FENCE1_RDATA_3                                 0xDE0328
+
+#define mmNIC4_QM0_CP_FENCE1_RDATA_4                                 0xDE032C
+
+#define mmNIC4_QM0_CP_FENCE2_RDATA_0                                 0xDE0330
+
+#define mmNIC4_QM0_CP_FENCE2_RDATA_1                                 0xDE0334
+
+#define mmNIC4_QM0_CP_FENCE2_RDATA_2                                 0xDE0338
+
+#define mmNIC4_QM0_CP_FENCE2_RDATA_3                                 0xDE033C
+
+#define mmNIC4_QM0_CP_FENCE2_RDATA_4                                 0xDE0340
+
+#define mmNIC4_QM0_CP_FENCE3_RDATA_0                                 0xDE0344
+
+#define mmNIC4_QM0_CP_FENCE3_RDATA_1                                 0xDE0348
+
+#define mmNIC4_QM0_CP_FENCE3_RDATA_2                                 0xDE034C
+
+#define mmNIC4_QM0_CP_FENCE3_RDATA_3                                 0xDE0350
+
+#define mmNIC4_QM0_CP_FENCE3_RDATA_4                                 0xDE0354
+
+#define mmNIC4_QM0_CP_FENCE0_CNT_0                                   0xDE0358
+
+#define mmNIC4_QM0_CP_FENCE0_CNT_1                                   0xDE035C
+
+#define mmNIC4_QM0_CP_FENCE0_CNT_2                                   0xDE0360
+
+#define mmNIC4_QM0_CP_FENCE0_CNT_3                                   0xDE0364
+
+#define mmNIC4_QM0_CP_FENCE0_CNT_4                                   0xDE0368
+
+#define mmNIC4_QM0_CP_FENCE1_CNT_0                                   0xDE036C
+
+#define mmNIC4_QM0_CP_FENCE1_CNT_1                                   0xDE0370
+
+#define mmNIC4_QM0_CP_FENCE1_CNT_2                                   0xDE0374
+
+#define mmNIC4_QM0_CP_FENCE1_CNT_3                                   0xDE0378
+
+#define mmNIC4_QM0_CP_FENCE1_CNT_4                                   0xDE037C
+
+#define mmNIC4_QM0_CP_FENCE2_CNT_0                                   0xDE0380
+
+#define mmNIC4_QM0_CP_FENCE2_CNT_1                                   0xDE0384
+
+#define mmNIC4_QM0_CP_FENCE2_CNT_2                                   0xDE0388
+
+#define mmNIC4_QM0_CP_FENCE2_CNT_3                                   0xDE038C
+
+#define mmNIC4_QM0_CP_FENCE2_CNT_4                                   0xDE0390
+
+#define mmNIC4_QM0_CP_FENCE3_CNT_0                                   0xDE0394
+
+#define mmNIC4_QM0_CP_FENCE3_CNT_1                                   0xDE0398
+
+#define mmNIC4_QM0_CP_FENCE3_CNT_2                                   0xDE039C
+
+#define mmNIC4_QM0_CP_FENCE3_CNT_3                                   0xDE03A0
+
+#define mmNIC4_QM0_CP_FENCE3_CNT_4                                   0xDE03A4
+
+#define mmNIC4_QM0_CP_STS_0                                          0xDE03A8
+
+#define mmNIC4_QM0_CP_STS_1                                          0xDE03AC
+
+#define mmNIC4_QM0_CP_STS_2                                          0xDE03B0
+
+#define mmNIC4_QM0_CP_STS_3                                          0xDE03B4
+
+#define mmNIC4_QM0_CP_STS_4                                          0xDE03B8
+
+#define mmNIC4_QM0_CP_CURRENT_INST_LO_0                              0xDE03BC
+
+#define mmNIC4_QM0_CP_CURRENT_INST_LO_1                              0xDE03C0
+
+#define mmNIC4_QM0_CP_CURRENT_INST_LO_2                              0xDE03C4
+
+#define mmNIC4_QM0_CP_CURRENT_INST_LO_3                              0xDE03C8
+
+#define mmNIC4_QM0_CP_CURRENT_INST_LO_4                              0xDE03CC
+
+#define mmNIC4_QM0_CP_CURRENT_INST_HI_0                              0xDE03D0
+
+#define mmNIC4_QM0_CP_CURRENT_INST_HI_1                              0xDE03D4
+
+#define mmNIC4_QM0_CP_CURRENT_INST_HI_2                              0xDE03D8
+
+#define mmNIC4_QM0_CP_CURRENT_INST_HI_3                              0xDE03DC
+
+#define mmNIC4_QM0_CP_CURRENT_INST_HI_4                              0xDE03E0
+
+#define mmNIC4_QM0_CP_BARRIER_CFG_0                                  0xDE03F4
+
+#define mmNIC4_QM0_CP_BARRIER_CFG_1                                  0xDE03F8
+
+#define mmNIC4_QM0_CP_BARRIER_CFG_2                                  0xDE03FC
+
+#define mmNIC4_QM0_CP_BARRIER_CFG_3                                  0xDE0400
+
+#define mmNIC4_QM0_CP_BARRIER_CFG_4                                  0xDE0404
+
+#define mmNIC4_QM0_CP_DBG_0_0                                        0xDE0408
+
+#define mmNIC4_QM0_CP_DBG_0_1                                        0xDE040C
+
+#define mmNIC4_QM0_CP_DBG_0_2                                        0xDE0410
+
+#define mmNIC4_QM0_CP_DBG_0_3                                        0xDE0414
+
+#define mmNIC4_QM0_CP_DBG_0_4                                        0xDE0418
+
+#define mmNIC4_QM0_CP_ARUSER_31_11_0                                 0xDE041C
+
+#define mmNIC4_QM0_CP_ARUSER_31_11_1                                 0xDE0420
+
+#define mmNIC4_QM0_CP_ARUSER_31_11_2                                 0xDE0424
+
+#define mmNIC4_QM0_CP_ARUSER_31_11_3                                 0xDE0428
+
+#define mmNIC4_QM0_CP_ARUSER_31_11_4                                 0xDE042C
+
+#define mmNIC4_QM0_CP_AWUSER_31_11_0                                 0xDE0430
+
+#define mmNIC4_QM0_CP_AWUSER_31_11_1                                 0xDE0434
+
+#define mmNIC4_QM0_CP_AWUSER_31_11_2                                 0xDE0438
+
+#define mmNIC4_QM0_CP_AWUSER_31_11_3                                 0xDE043C
+
+#define mmNIC4_QM0_CP_AWUSER_31_11_4                                 0xDE0440
+
+#define mmNIC4_QM0_ARB_CFG_0                                         0xDE0A00
+
+#define mmNIC4_QM0_ARB_CHOISE_Q_PUSH                                 0xDE0A04
+
+#define mmNIC4_QM0_ARB_WRR_WEIGHT_0                                  0xDE0A08
+
+#define mmNIC4_QM0_ARB_WRR_WEIGHT_1                                  0xDE0A0C
+
+#define mmNIC4_QM0_ARB_WRR_WEIGHT_2                                  0xDE0A10
+
+#define mmNIC4_QM0_ARB_WRR_WEIGHT_3                                  0xDE0A14
+
+#define mmNIC4_QM0_ARB_CFG_1                                         0xDE0A18
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_0                              0xDE0A20
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_1                              0xDE0A24
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_2                              0xDE0A28
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_3                              0xDE0A2C
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_4                              0xDE0A30
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_5                              0xDE0A34
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_6                              0xDE0A38
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_7                              0xDE0A3C
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_8                              0xDE0A40
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_9                              0xDE0A44
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_10                             0xDE0A48
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_11                             0xDE0A4C
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_12                             0xDE0A50
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_13                             0xDE0A54
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_14                             0xDE0A58
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_15                             0xDE0A5C
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_16                             0xDE0A60
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_17                             0xDE0A64
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_18                             0xDE0A68
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_19                             0xDE0A6C
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_20                             0xDE0A70
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_21                             0xDE0A74
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_22                             0xDE0A78
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_23                             0xDE0A7C
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_24                             0xDE0A80
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_25                             0xDE0A84
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_26                             0xDE0A88
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_27                             0xDE0A8C
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_28                             0xDE0A90
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_29                             0xDE0A94
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_30                             0xDE0A98
+
+#define mmNIC4_QM0_ARB_MST_AVAIL_CRED_31                             0xDE0A9C
+
+#define mmNIC4_QM0_ARB_MST_CRED_INC                                  0xDE0AA0
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_0                        0xDE0AA4
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_1                        0xDE0AA8
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_2                        0xDE0AAC
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_3                        0xDE0AB0
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_4                        0xDE0AB4
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_5                        0xDE0AB8
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_6                        0xDE0ABC
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_7                        0xDE0AC0
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_8                        0xDE0AC4
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_9                        0xDE0AC8
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_10                       0xDE0ACC
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_11                       0xDE0AD0
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_12                       0xDE0AD4
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_13                       0xDE0AD8
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_14                       0xDE0ADC
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_15                       0xDE0AE0
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_16                       0xDE0AE4
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_17                       0xDE0AE8
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_18                       0xDE0AEC
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_19                       0xDE0AF0
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_20                       0xDE0AF4
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_21                       0xDE0AF8
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_22                       0xDE0AFC
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_23                       0xDE0B00
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_24                       0xDE0B04
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_25                       0xDE0B08
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_26                       0xDE0B0C
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_27                       0xDE0B10
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_28                       0xDE0B14
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_29                       0xDE0B18
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_30                       0xDE0B1C
+
+#define mmNIC4_QM0_ARB_MST_CHOISE_PUSH_OFST_31                       0xDE0B20
+
+#define mmNIC4_QM0_ARB_SLV_MASTER_INC_CRED_OFST                      0xDE0B28
+
+#define mmNIC4_QM0_ARB_MST_SLAVE_EN                                  0xDE0B2C
+
+#define mmNIC4_QM0_ARB_MST_QUIET_PER                                 0xDE0B34
+
+#define mmNIC4_QM0_ARB_SLV_CHOISE_WDT                                0xDE0B38
+
+#define mmNIC4_QM0_ARB_SLV_ID                                        0xDE0B3C
+
+#define mmNIC4_QM0_ARB_MSG_MAX_INFLIGHT                              0xDE0B44
+
+#define mmNIC4_QM0_ARB_MSG_AWUSER_31_11                              0xDE0B48
+
+#define mmNIC4_QM0_ARB_MSG_AWUSER_SEC_PROP                           0xDE0B4C
+
+#define mmNIC4_QM0_ARB_MSG_AWUSER_NON_SEC_PROP                       0xDE0B50
+
+#define mmNIC4_QM0_ARB_BASE_LO                                       0xDE0B54
+
+#define mmNIC4_QM0_ARB_BASE_HI                                       0xDE0B58
+
+#define mmNIC4_QM0_ARB_STATE_STS                                     0xDE0B80
+
+#define mmNIC4_QM0_ARB_CHOISE_FULLNESS_STS                           0xDE0B84
+
+#define mmNIC4_QM0_ARB_MSG_STS                                       0xDE0B88
+
+#define mmNIC4_QM0_ARB_SLV_CHOISE_Q_HEAD                             0xDE0B8C
+
+#define mmNIC4_QM0_ARB_ERR_CAUSE                                     0xDE0B9C
+
+#define mmNIC4_QM0_ARB_ERR_MSG_EN                                    0xDE0BA0
+
+#define mmNIC4_QM0_ARB_ERR_STS_DRP                                   0xDE0BA8
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_0                                0xDE0BB0
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_1                                0xDE0BB4
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_2                                0xDE0BB8
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_3                                0xDE0BBC
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_4                                0xDE0BC0
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_5                                0xDE0BC4
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_6                                0xDE0BC8
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_7                                0xDE0BCC
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_8                                0xDE0BD0
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_9                                0xDE0BD4
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_10                               0xDE0BD8
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_11                               0xDE0BDC
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_12                               0xDE0BE0
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_13                               0xDE0BE4
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_14                               0xDE0BE8
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_15                               0xDE0BEC
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_16                               0xDE0BF0
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_17                               0xDE0BF4
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_18                               0xDE0BF8
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_19                               0xDE0BFC
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_20                               0xDE0C00
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_21                               0xDE0C04
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_22                               0xDE0C08
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_23                               0xDE0C0C
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_24                               0xDE0C10
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_25                               0xDE0C14
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_26                               0xDE0C18
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_27                               0xDE0C1C
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_28                               0xDE0C20
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_29                               0xDE0C24
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_30                               0xDE0C28
+
+#define mmNIC4_QM0_ARB_MST_CRED_STS_31                               0xDE0C2C
+
+#define mmNIC4_QM0_CGM_CFG                                           0xDE0C70
+
+#define mmNIC4_QM0_CGM_STS                                           0xDE0C74
+
+#define mmNIC4_QM0_CGM_CFG1                                          0xDE0C78
+
+#define mmNIC4_QM0_LOCAL_RANGE_BASE                                  0xDE0C80
+
+#define mmNIC4_QM0_LOCAL_RANGE_SIZE                                  0xDE0C84
+
+#define mmNIC4_QM0_CSMR_STRICT_PRIO_CFG                              0xDE0C90
+
+#define mmNIC4_QM0_HBW_RD_RATE_LIM_CFG_1                             0xDE0C94
+
+#define mmNIC4_QM0_LBW_WR_RATE_LIM_CFG_0                             0xDE0C98
+
+#define mmNIC4_QM0_LBW_WR_RATE_LIM_CFG_1                             0xDE0C9C
+
+#define mmNIC4_QM0_HBW_RD_RATE_LIM_CFG_0                             0xDE0CA0
+
+#define mmNIC4_QM0_GLBL_AXCACHE                                      0xDE0CA4
+
+#define mmNIC4_QM0_IND_GW_APB_CFG                                    0xDE0CB0
+
+#define mmNIC4_QM0_IND_GW_APB_WDATA                                  0xDE0CB4
+
+#define mmNIC4_QM0_IND_GW_APB_RDATA                                  0xDE0CB8
+
+#define mmNIC4_QM0_IND_GW_APB_STATUS                                 0xDE0CBC
+
+#define mmNIC4_QM0_GLBL_ERR_ADDR_LO                                  0xDE0CD0
+
+#define mmNIC4_QM0_GLBL_ERR_ADDR_HI                                  0xDE0CD4
+
+#define mmNIC4_QM0_GLBL_ERR_WDATA                                    0xDE0CD8
+
+#define mmNIC4_QM0_GLBL_MEM_INIT_BUSY                                0xDE0D00
+
+#endif /* ASIC_REG_NIC4_QM0_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
new file mode 100644
index 000000000000..34b21b21da52
--- /dev/null
+++ b/drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
@@ -0,0 +1,834 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2018 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+/************************************
+ ** This is an auto-generated file **
+ **       DO NOT EDIT BELOW        **
+ ************************************/
+
+#ifndef ASIC_REG_NIC4_QM1_REGS_H_
+#define ASIC_REG_NIC4_QM1_REGS_H_
+
+/*
+ *****************************************
+ *   NIC4_QM1 (Prototype: QMAN)
+ *****************************************
+ */
+
+#define mmNIC4_QM1_GLBL_CFG0                                         0xDE2000
+
+#define mmNIC4_QM1_GLBL_CFG1                                         0xDE2004
+
+#define mmNIC4_QM1_GLBL_PROT                                         0xDE2008
+
+#define mmNIC4_QM1_GLBL_ERR_CFG                                      0xDE200C
+
+#define mmNIC4_QM1_GLBL_SECURE_PROPS_0                               0xDE2010
+
+#define mmNIC4_QM1_GLBL_SECURE_PROPS_1                               0xDE2014
+
+#define mmNIC4_QM1_GLBL_SECURE_PROPS_2                               0xDE2018
+
+#define mmNIC4_QM1_GLBL_SECURE_PROPS_3                               0xDE201C
+
+#define mmNIC4_QM1_GLBL_SECURE_PROPS_4                               0xDE2020
+
+#define mmNIC4_QM1_GLBL_NON_SECURE_PROPS_0                           0xDE2024
+
+#define mmNIC4_QM1_GLBL_NON_SECURE_PROPS_1                           0xDE2028
+
+#define mmNIC4_QM1_GLBL_NON_SECURE_PROPS_2                           0xDE202C
+
+#define mmNIC4_QM1_GLBL_NON_SECURE_PROPS_3                           0xDE2030
+
+#define mmNIC4_QM1_GLBL_NON_SECURE_PROPS_4                           0xDE2034
+
+#define mmNIC4_QM1_GLBL_STS0                                         0xDE2038
+
+#define mmNIC4_QM1_GLBL_STS1_0                                       0xDE2040
+
+#define mmNIC4_QM1_GLBL_STS1_1                                       0xDE2044
+
+#define mmNIC4_QM1_GLBL_STS1_2                                       0xDE2048
+
+#define mmNIC4_QM1_GLBL_STS1_3                                       0xDE204C
+
+#define mmNIC4_QM1_GLBL_STS1_4                                       0xDE2050
+
+#define mmNIC4_QM1_GLBL_MSG_EN_0                                     0xDE2054
+
+#define mmNIC4_QM1_GLBL_MSG_EN_1                                     0xDE2058
+
+#define mmNIC4_QM1_GLBL_MSG_EN_2                                     0xDE205C
+
+#define mmNIC4_QM1_GLBL_MSG_EN_3                                     0xDE2060
+
+#define mmNIC4_QM1_GLBL_MSG_EN_4                                     0xDE2068
+
+#define mmNIC4_QM1_PQ_BASE_LO_0                                      0xDE2070
+
+#define mmNIC4_QM1_PQ_BASE_LO_1                                      0xDE2074
+
+#define mmNIC4_QM1_PQ_BASE_LO_2                                      0xDE2078
+
+#define mmNIC4_QM1_PQ_BASE_LO_3                                      0xDE207C
+
+#define mmNIC4_QM1_PQ_BASE_HI_0                                      0xDE2080
+
+#define mmNIC4_QM1_PQ_BASE_HI_1                                      0xDE2084
+
+#define mmNIC4_QM1_PQ_BASE_HI_2                                      0xDE2088
+
+#define mmNIC4_QM1_PQ_BASE_HI_3                                      0xDE208C
+
+#define mmNIC4_QM1_PQ_SIZE_0                                         0xDE2090
+
+#define mmNIC4_QM1_PQ_SIZE_1                                         0xDE2094
+
+#define mmNIC4_QM1_PQ_SIZE_2                                         0xDE2098
+
+#define mmNIC4_QM1_PQ_SIZE_3                                         0xDE209C
+
+#define mmNIC4_QM1_PQ_PI_0                                           0xDE20A0
+
+#define mmNIC4_QM1_PQ_PI_1                                           0xDE20A4
+
+#define mmNIC4_QM1_PQ_PI_2                                           0xDE20A8
+
+#define mmNIC4_QM1_PQ_PI_3                                           0xDE20AC
+
+#define mmNIC4_QM1_PQ_CI_0                                           0xDE20B0
+
+#define mmNIC4_QM1_PQ_CI_1                                           0xDE20B4
+
+#define mmNIC4_QM1_PQ_CI_2                                           0xDE20B8
+
+#define mmNIC4_QM1_PQ_CI_3                                           0xDE20BC
+
+#define mmNIC4_QM1_PQ_CFG0_0                                         0xDE20C0
+
+#define mmNIC4_QM1_PQ_CFG0_1                                         0xDE20C4
+
+#define mmNIC4_QM1_PQ_CFG0_2                                         0xDE20C8
+
+#define mmNIC4_QM1_PQ_CFG0_3                                         0xDE20CC
+
+#define mmNIC4_QM1_PQ_CFG1_0                                         0xDE20D0
+
+#define mmNIC4_QM1_PQ_CFG1_1                                         0xDE20D4
+
+#define mmNIC4_QM1_PQ_CFG1_2                                         0xDE20D8
+
+#define mmNIC4_QM1_PQ_CFG1_3                                         0xDE20DC
+
+#define mmNIC4_QM1_PQ_ARUSER_31_11_0                                 0xDE20E0
+
+#define mmNIC4_QM1_PQ_ARUSER_31_11_1                                 0xDE20E4
+
+#define mmNIC4_QM1_PQ_ARUSER_31_11_2                                 0xDE20E8
+
+#define mmNIC4_QM1_PQ_ARUSER_31_11_3                                 0xDE20EC
+
+#define mmNIC4_QM1_PQ_STS0_0                                         0xDE20F0
+
+#define mmNIC4_QM1_PQ_STS0_1                                         0xDE20F4
+
+#define mmNIC4_QM1_PQ_STS0_2                                         0xDE20F8
+
+#define mmNIC4_QM1_PQ_STS0_3                                         0xDE20FC
+
+#define mmNIC4_QM1_PQ_STS1_0                                         0xDE2100
+
+#define mmNIC4_QM1_PQ_STS1_1                                         0xDE2104
+
+#define mmNIC4_QM1_PQ_STS1_2                                         0xDE2108
+
+#define mmNIC4_QM1_PQ_STS1_3                                         0xDE210C
+
+#define mmNIC4_QM1_CQ_CFG0_0                                         0xDE2110
+
+#define mmNIC4_QM1_CQ_CFG0_1                                         0xDE2114
+
+#define mmNIC4_QM1_CQ_CFG0_2                                         0xDE2118
+
+#define mmNIC4_QM1_CQ_CFG0_3                                         0xDE211C
+
+#define mmNIC4_QM1_CQ_CFG0_4                                         0xDE2120
+
+#define mmNIC4_QM1_CQ_CFG1_0                                         0xDE2124
+
+#define mmNIC4_QM1_CQ_CFG1_1                                         0xDE2128
+
+#define mmNIC4_QM1_CQ_CFG1_2                                         0xDE212C
+
+#define mmNIC4_QM1_CQ_CFG1_3                                         0xDE2130
+
+#define mmNIC4_QM1_CQ_CFG1_4                                         0xDE2134
+
+#define mmNIC4_QM1_CQ_ARUSER_31_11_0                                 0xDE2138
+
+#define mmNIC4_QM1_CQ_ARUSER_31_11_1                                 0xDE213C
+
+#define mmNIC4_QM1_CQ_ARUSER_31_11_2                                 0xDE2140
+
+#define mmNIC4_QM1_CQ_ARUSER_31_11_3                                 0xDE2144
+
+#define mmNIC4_QM1_CQ_ARUSER_31_11_4                                 0xDE2148
+
+#define mmNIC4_QM1_CQ_STS0_0                                         0xDE214C
+
+#define mmNIC4_QM1_CQ_STS0_1                                         0xDE2150
+
+#define mmNIC4_QM1_CQ_STS0_2                                         0xDE2154
+
+#define mmNIC4_QM1_CQ_STS0_3                                         0xDE2158
+
+#define mmNIC4_QM1_CQ_STS0_4                                         0xDE215C
+
+#define mmNIC4_QM1_CQ_STS1_0                                         0xDE2160
+
+#define mmNIC4_QM1_CQ_STS1_1                                         0xDE2164
+
+#define mmNIC4_QM1_CQ_STS1_2                                         0xDE2168
+
+#define mmNIC4_QM1_CQ_STS1_3                                         0xDE216C
+
+#define mmNIC4_QM1_CQ_STS1_4                                         0xDE2170
+
+#define mmNIC4_QM1_CQ_PTR_LO_0                                       0xDE2174
+
+#define mmNIC4_QM1_CQ_PTR_HI_0                                       0xDE2178
+
+#define mmNIC4_QM1_CQ_TSIZE_0                                        0xDE217C
+
+#define mmNIC4_QM1_CQ_CTL_0                                          0xDE2180
+
+#define mmNIC4_QM1_CQ_PTR_LO_1                                       0xDE2184
+
+#define mmNIC4_QM1_CQ_PTR_HI_1                                       0xDE2188
+
+#define mmNIC4_QM1_CQ_TSIZE_1                                        0xDE218C
+
+#define mmNIC4_QM1_CQ_CTL_1                                          0xDE2190
+
+#define mmNIC4_QM1_CQ_PTR_LO_2                                       0xDE2194
+
+#define mmNIC4_QM1_CQ_PTR_HI_2                                       0xDE2198
+
+#define mmNIC4_QM1_CQ_TSIZE_2                                        0xDE219C
+
+#define mmNIC4_QM1_CQ_CTL_2                                          0xDE21A0
+
+#define mmNIC4_QM1_CQ_PTR_LO_3                                       0xDE21A4
+
+#define mmNIC4_QM1_CQ_PTR_HI_3                                       0xDE21A8
+
+#define mmNIC4_QM1_CQ_TSIZE_3                                        0xDE21AC
+
+#define mmNIC4_QM1_CQ_CTL_3                                          0xDE21B0
+
+#define mmNIC4_QM1_CQ_PTR_LO_4                                       0xDE21B4
+
+#define mmNIC4_QM1_CQ_PTR_HI_4                                       0xDE21B8
+
+#define mmNIC4_QM1_CQ_TSIZE_4                                        0xDE21BC
+
+#define mmNIC4_QM1_CQ_CTL_4                                          0xDE21C0
+
+#define mmNIC4_QM1_CQ_PTR_LO_STS_0                                   0xDE21C4
+
+#define mmNIC4_QM1_CQ_PTR_LO_STS_1                                   0xDE21C8
+
+#define mmNIC4_QM1_CQ_PTR_LO_STS_2                                   0xDE21CC
+
+#define mmNIC4_QM1_CQ_PTR_LO_STS_3                                   0xDE21D0
+
+#define mmNIC4_QM1_CQ_PTR_LO_STS_4                                   0xDE21D4
+
+#define mmNIC4_QM1_CQ_PTR_HI_STS_0                                   0xDE21D8
+
+#define mmNIC4_QM1_CQ_PTR_HI_STS_1                                   0xDE21DC
+
+#define mmNIC4_QM1_CQ_PTR_HI_STS_2                                   0xDE21E0
+
+#define mmNIC4_QM1_CQ_PTR_HI_STS_3                                   0xDE21E4
+
+#define mmNIC4_QM1_CQ_PTR_HI_STS_4                                   0xDE21E8
+
+#define mmNIC4_QM1_CQ_TSIZE_STS_0                                    0xDE21EC
+
+#define mmNIC4_QM1_CQ_TSIZE_STS_1                                    0xDE21F0
+
+#define mmNIC4_QM1_CQ_TSIZE_STS_2                                    0xDE21F4
+
+#define mmNIC4_QM1_CQ_TSIZE_STS_3                                    0xDE21F8
+
+#define mmNIC4_QM1_CQ_TSIZE_STS_4                                    0xDE21FC
+
+#define mmNIC4_QM1_CQ_CTL_STS_0                                      0xDE2200
+
+#define mmNIC4_QM1_CQ_CTL_STS_1                                      0xDE2204
+
+#define mmNIC4_QM1_CQ_CTL_STS_2                                      0xDE2208
+
+#define mmNIC4_QM1_CQ_CTL_STS_3                                      0xDE220C
+
+#define mmNIC4_QM1_CQ_CTL_STS_4                                      0xDE2210
+
+#define mmNIC4_QM1_CQ_IFIFO_CNT_0                                    0xDE2214
+
+#define mmNIC4_QM1_CQ_IFIFO_CNT_1                                    0xDE2218
+
+#define mmNIC4_QM1_CQ_IFIFO_CNT_2                                    0xDE221C
+
+#define mmNIC4_QM1_CQ_IFIFO_CNT_3                                    0xDE2220
+
+#define mmNIC4_QM1_CQ_IFIFO_CNT_4                                    0xDE2224
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_0                            0xDE2228
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_1                            0xDE222C
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_2                            0xDE2230
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_3                            0xDE2234
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_LO_4                            0xDE2238
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_0                            0xDE223C
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_1                            0xDE2240
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_2                            0xDE2244
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_3                            0xDE2248
+
+#define mmNIC4_QM1_CP_MSG_BASE0_ADDR_HI_4                            0xDE224C
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_0                            0xDE2250
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_1                            0xDE2254
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_2                            0xDE2258
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_3                            0xDE225C
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_LO_4                            0xDE2260
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_0                            0xDE2264
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_1                            0xDE2268
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_2                            0xDE226C
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_3                            0xDE2270
+
+#define mmNIC4_QM1_CP_MSG_BASE1_ADDR_HI_4                            0xDE2274
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_0                            0xDE2278
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_1                            0xDE227C
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_2                            0xDE2280
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_3                            0xDE2284
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_LO_4                            0xDE2288
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_0                            0xDE228C
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_1                            0xDE2290
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_2                            0xDE2294
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_3                            0xDE2298
+
+#define mmNIC4_QM1_CP_MSG_BASE2_ADDR_HI_4                            0xDE229C
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_0                            0xDE22A0
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_1                            0xDE22A4
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_2                            0xDE22A8
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_3                            0xDE22AC
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_LO_4                            0xDE22B0
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_0                            0xDE22B4
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_1                            0xDE22B8
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_2                            0xDE22BC
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_3                            0xDE22C0
+
+#define mmNIC4_QM1_CP_MSG_BASE3_ADDR_HI_4                            0xDE22C4
+
+#define mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_0                            0xDE22C8
+
+#define mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_1                            0xDE22CC
+
+#define mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_2                            0xDE22D0
+
+#define mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_3                            0xDE22D4
+
+#define mmNIC4_QM1_CP_LDMA_TSIZE_OFFSET_4                            0xDE22D8
+
+#define mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_0                      0xDE22E0
+
+#define mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_1                      0xDE22E4
+
+#define mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_2                      0xDE22E8
+
+#define mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_3                      0xDE22EC
+
+#define mmNIC4_QM1_CP_LDMA_SRC_BASE_LO_OFFSET_4                      0xDE22F0
+
+#define mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_0                      0xDE22F4
+
+#define mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_1                      0xDE22F8
+
+#define mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_2                      0xDE22FC
+
+#define mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_3                      0xDE2300
+
+#define mmNIC4_QM1_CP_LDMA_DST_BASE_LO_OFFSET_4                      0xDE2304
+
+#define mmNIC4_QM1_CP_FENCE0_RDATA_0                                 0xDE2308
+
+#define mmNIC4_QM1_CP_FENCE0_RDATA_1                                 0xDE230C
+
+#define mmNIC4_QM1_CP_FENCE0_RDATA_2                                 0xDE2310
+
+#define mmNIC4_QM1_CP_FENCE0_RDATA_3                                 0xDE2314
+
+#define mmNIC4_QM1_CP_FENCE0_RDATA_4                                 0xDE2318
+
+#define mmNIC4_QM1_CP_FENCE1_RDATA_0                                 0xDE231C
+
+#define mmNIC4_QM1_CP_FENCE1_RDATA_1                                 0xDE2320
+
+#define mmNIC4_QM1_CP_FENCE1_RDATA_2                                 0xDE2324
+
+#define mmNIC4_QM1_CP_FENCE1_RDATA_3                                 0xDE2328
+
+#define mmNIC4_QM1_CP_FENCE1_RDATA_4                                 0xDE232C
+
+#define mmNIC4_QM1_CP_FENCE2_RDATA_0                                 0xDE2330
+
+#define mmNIC4_QM1_CP_FENCE2_RDATA_1                                 0xDE2334
+
+#define mmNIC4_QM1_CP_FENCE2_RDATA_2                                 0xDE2338
+
+#define mmNIC4_QM1_CP_FENCE2_RDATA_3                                 0xDE233C
+
+#define mmNIC4_QM1_CP_FENCE2_RDATA_4                                 0xDE2340
+
+#define mmNIC4_QM1_CP_FENCE3_RDATA_0                                 0xDE2344
+
+#define mmNIC4_QM1_CP_FENCE3_RDATA_1                                 0xDE2348
+
+#define mmNIC4_QM1_CP_FENCE3_RDATA_2                                 0xDE234C
+
+#define mmNIC4_QM1_CP_FENCE3_RDATA_3                                 0xDE2350
+
+#define mmNIC4_QM1_CP_FENCE3_RDATA_4                                 0xDE2354
+
+#define mmNIC4_QM1_CP_FENCE0_CNT_0                                   0xDE2358
+
+#define mmNIC4_QM1_CP_FENCE0_CNT_1                                   0xDE235C
+
+#define mmNIC4_QM1_CP_FENCE0_CNT_2                                   0xDE2360
+
+#define mmNIC4_QM1_CP_FENCE0_CNT_3                                   0xDE2364
+
+#define mmNIC4_QM1_CP_FENCE0_CNT_4                                   0xDE2368
+
+#define mmNIC4_QM1_CP_FENCE1_CNT_0                                   0xDE236C
+
+#define mmNIC4_QM1_CP_FENCE1_CNT_1                                   0xDE2370
+
+#define mmNIC4_QM1_CP_FENCE1_CNT_2                                   0xDE2374
+
+#define mmNIC4_QM1_CP_FENCE1_CNT_3                                   0xDE2378
+
+#define mmNIC4_QM1_CP_FENCE1_CNT_4                                   0xDE237C
+
+#define mmNIC4_QM1_CP_FENCE2_CNT_0                                   0xDE2380
+
+#define mmNIC4_QM1_CP_FENCE2_CNT_1                                   0xDE2384
+
+#define mmNIC4_QM1_CP_FENCE2_CNT_2                                   0xDE2388
+
+#define mmNIC4_QM1_CP_FENCE2_CNT_3                                   0xDE238C
+
+#define mmNIC4_QM1_CP_FENCE2_CNT_4                                   0xDE2390
+
+#define mmNIC4_QM1_CP_FENCE3_CNT_0                                   0xDE2394
+
+#define mmNIC4_QM1_CP_FENCE3_CNT_1                                   0xDE2398
+
+#define mmNIC4_QM1_CP_FENCE3_CNT_2                                   0xDE239C
+
+#define mmNIC4_QM1_CP_FENCE3_CNT_3                                   0xDE23A0
+
+#define mmNIC4_QM1_CP_FENCE3_CNT_4                                   0xDE23A4
+
+#define mmNIC4_QM1_CP_STS_0                                          0xDE23A8
+
+#define mmNIC4_QM1_CP_STS_1                                          0xDE23AC
+
+#define mmNIC4_QM1_CP_STS_2                                          0xDE23B0
+
+#define mmNIC4_QM1_CP_STS_3                                          0xDE23B4
+
+#define mmNIC4_QM1_CP_STS_4                                          0xDE23B8
+
+#define mmNIC4_QM1_CP_CURRENT_INST_LO_0                              0xDE23BC
+
+#define mmNIC4_QM1_CP_CURRENT_INST_LO_1                              0xDE23C0
+
+#define mmNIC4_QM1_CP_CURRENT_INST_LO_2                              0xDE23C4
+
+#define mmNIC4_QM1_CP_CURRENT_INST_LO_3                              0xDE23C8
+
+#define mmNIC4_QM1_CP_CURRENT_INST_LO_4                              0xDE23CC
+
+#define mmNIC4_QM1_CP_CURRENT_INST_HI_0                              0xDE23D0
+
+#define mmNIC4_QM1_CP_CURRENT_INST_HI_1                              0xDE23D4
+
+#define mmNIC4_QM1_CP_CURRENT_INST_HI_2                              0xDE23D8
+
+#define mmNIC4_QM1_CP_CURRENT_INST_HI_3                              0xDE23DC
+
+#define mmNIC4_QM1_CP_CURRENT_INST_HI_4                              0xDE23E0
+
+#define mmNIC4_QM1_CP_BARRIER_CFG_0                                  0xDE23F4
+
+#define mmNIC4_QM1_CP_BARRIER_CFG_1                                  0xDE23F8
+
+#define mmNIC4_QM1_CP_BARRIER_CFG_2                                  0xDE23FC
+
+#define mmNIC4_QM1_CP_BARRIER_CFG_3                                  0xDE2400
+
+#define mmNIC4_QM1_CP_BARRIER_CFG_4                                  0xDE2404
+
+#define mmNIC4_QM1_CP_DBG_0_0                                        0xDE2408
+
+#define mmNIC4_QM1_CP_DBG_0_1                                        0xDE240C
+
+#define mmNIC4_QM1_CP_DBG_0_2                                        0xDE2410
+
+#define mmNIC4_QM1_CP_DBG_0_3                                        0xDE2414
+
+#define mmNIC4_QM1_CP_DBG_0_4                                        0xDE2418
+
+#define mmNIC4_QM1_CP_ARUSER_31_11_0                                 0xDE241C
+
+#define mmNIC4_QM1_CP_ARUSER_31_11_1                                 0xDE2420
+
+#define mmNIC4_QM1_CP_ARUSER_31_11_2                                 0xDE2424
+
+#define mmNIC4_QM1_CP_ARUSER_31_11_3                                 0xDE2428
+
+#define mmNIC4_QM1_CP_ARUSER_31_11_4                                 0xDE242C
+
+#define mmNIC4_QM1_CP_AWUSER_31_11_0                                 0xDE2430
+
+#define mmNIC4_QM1_CP_AWUSER_31_11_1                                 0xDE2434
+
+#define mmNIC4_QM1_CP_AWUSER_31_11_2                                 0xDE2438
+
+#define mmNIC4_QM1_CP_AWUSER_31_11_3                                 0xDE243C
+
+#define mmNIC4_QM1_CP_AWUSER_31_11_4                                 0xDE2440
+
+#define mmNIC4_QM1_ARB_CFG_0                                         0xDE2A00
+
+#define mmNIC4_QM1_ARB_CHOISE_Q_PUSH                                 0xDE2A04
+
+#define mmNIC4_QM1_ARB_WRR_WEIGHT_0                                  0xDE2A08
+
+#define mmNIC4_QM1_ARB_WRR_WEIGHT_1                                  0xDE2A0C
+
+#define mmNIC4_QM1_ARB_WRR_WEIGHT_2                                  0xDE2A10
+
+#define mmNIC4_QM1_ARB_WRR_WEIGHT_3                                  0xDE2A14
+
+#define mmNIC4_QM1_ARB_CFG_1                                         0xDE2A18
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_0                              0xDE2A20
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_1                              0xDE2A24
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_2                              0xDE2A28
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_3                              0xDE2A2C
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_4                              0xDE2A30
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_5                              0xDE2A34
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_6                              0xDE2A38
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_7                              0xDE2A3C
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_8                              0xDE2A40
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_9                              0xDE2A44
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_10                             0xDE2A48
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_11                             0xDE2A4C
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_12                             0xDE2A50
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_13                             0xDE2A54
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_14                             0xDE2A58
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_15                             0xDE2A5C
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_16                             0xDE2A60
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_17                             0xDE2A64
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_18                             0xDE2A68
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_19                             0xDE2A6C
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_20                             0xDE2A70
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_21                             0xDE2A74
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_22                             0xDE2A78
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_23                             0xDE2A7C
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_24                             0xDE2A80
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_25                             0xDE2A84
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_26                             0xDE2A88
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_27                             0xDE2A8C
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_28                             0xDE2A90
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_29                             0xDE2A94
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_30                             0xDE2A98
+
+#define mmNIC4_QM1_ARB_MST_AVAIL_CRED_31                             0xDE2A9C
+
+#define mmNIC4_QM1_ARB_MST_CRED_INC                                  0xDE2AA0
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_0                        0xDE2AA4
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_1                        0xDE2AA8
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_2                        0xDE2AAC
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_3                        0xDE2AB0
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_4                        0xDE2AB4
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_5                        0xDE2AB8
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_6                        0xDE2ABC
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_7                        0xDE2AC0
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_8                        0xDE2AC4
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_9                        0xDE2AC8
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_10                       0xDE2ACC
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_11                       0xDE2AD0
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_12                       0xDE2AD4
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_13                       0xDE2AD8
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_14                       0xDE2ADC
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_15                       0xDE2AE0
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_16                       0xDE2AE4
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_17                       0xDE2AE8
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_18                       0xDE2AEC
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_19                       0xDE2AF0
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_20                       0xDE2AF4
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_21                       0xDE2AF8
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_22                       0xDE2AFC
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_23                       0xDE2B00
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_24                       0xDE2B04
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_25                       0xDE2B08
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_26                       0xDE2B0C
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_27                       0xDE2B10
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_28                       0xDE2B14
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_29                       0xDE2B18
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_30                       0xDE2B1C
+
+#define mmNIC4_QM1_ARB_MST_CHOISE_PUSH_OFST_31                       0xDE2B20
+
+#define mmNIC4_QM1_ARB_SLV_MASTER_INC_CRED_OFST                      0xDE2B28
+
+#define mmNIC4_QM1_ARB_MST_SLAVE_EN                                  0xDE2B2C
+
+#define mmNIC4_QM1_ARB_MST_QUIET_PER                                 0xDE2B34
+
+#define mmNIC4_QM1_ARB_SLV_CHOISE_WDT                                0xDE2B38
+
+#define mmNIC4_QM1_ARB_SLV_ID                                        0xDE2B3C
+
+#define mmNIC4_QM1_ARB_MSG_MAX_INFLIGHT                              0xDE2B44
+
+#define mmNIC4_QM1_ARB_MSG_AWUSER_31_11                              0xDE2B48
+
+#define mmNIC4_QM1_ARB_MSG_AWUSER_SEC_PROP                           0xDE2B4C
+
+#define mmNIC4_QM1_ARB_MSG_AWUSER_NON_SEC_PROP                       0xDE2B50
+
+#define mmNIC4_QM1_ARB_BASE_LO                                       0xDE2B54
+
+#define mmNIC4_QM1_ARB_BASE_HI                                       0xDE2B58
+
+#define mmNIC4_QM1_ARB_STATE_STS                                     0xDE2B80
+
+#define mmNIC4_QM1_ARB_CHOISE_FULLNESS_STS                           0xDE2B84
+
+#define mmNIC4_QM1_ARB_MSG_STS                                       0xDE2B88
+
+#define mmNIC4_QM1_ARB_SLV_CHOISE_Q_HEAD                             0xDE2B8C
+
+#define mmNIC4_QM1_ARB_ERR_CAUSE                                     0xDE2B9C
+
+#define mmNIC4_QM1_ARB_ERR_MSG_EN                                    0xDE2BA0
+
+#define mmNIC4_QM1_ARB_ERR_STS_DRP                                   0xDE2BA8
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_0                                0xDE2BB0
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_1                                0xDE2BB4
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_2                                0xDE2BB8
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_3                                0xDE2BBC
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_4                                0xDE2BC0
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_5                                0xDE2BC4
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_6                                0xDE2BC8
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_7                                0xDE2BCC
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_8                                0xDE2BD0
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_9                                0xDE2BD4
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_10                               0xDE2BD8
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_11                               0xDE2BDC
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_12                               0xDE2BE0
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_13                               0xDE2BE4
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_14                               0xDE2BE8
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_15                               0xDE2BEC
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_16                               0xDE2BF0
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_17                               0xDE2BF4
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_18                               0xDE2BF8
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_19                               0xDE2BFC
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_20                               0xDE2C00
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_21                               0xDE2C04
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_22                               0xDE2C08
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_23                               0xDE2C0C
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_24                               0xDE2C10
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_25                               0xDE2C14
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_26                               0xDE2C18
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_27                               0xDE2C1C
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_28                               0xDE2C20
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_29                               0xDE2C24
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_30                               0xDE2C28
+
+#define mmNIC4_QM1_ARB_MST_CRED_STS_31                               0xDE2C2C
+
+#define mmNIC4_QM1_CGM_CFG                                           0xDE2C70
+
+#define mmNIC4_QM1_CGM_STS                                           0xDE2C74
+
+#define mmNIC4_QM1_CGM_CFG1                                          0xDE2C78
+
+#define mmNIC4_QM1_LOCAL_RANGE_BASE                                  0xDE2C80
+
+#define mmNIC4_QM1_LOCAL_RANGE_SIZE                                  0xDE2C84
+
+#define mmNIC4_QM1_CSMR_STRICT_PRIO_CFG                              0xDE2C90
+
+#define mmNIC4_QM1_HBW_RD_RATE_LIM_CFG_1                             0xDE2C94
+
+#define mmNIC4_QM1_LBW_WR_RATE_LIM_CFG_0                             0xDE2C98
+
+#define mmNIC4_QM1_LBW_WR_RATE_LIM_CFG_1                             0xDE2C9C
+
+#define mmNIC4_QM1_HBW_RD_RATE_LIM_CFG_0                             0xDE2CA0
+
+#define mmNIC4_QM1_GLBL_AXCACHE                                      0xDE2CA4
+
+#define mmNIC4_QM1_IND_GW_APB_CFG                                    0xDE2CB0
+
+#define mmNIC4_QM1_IND_GW_APB_WDATA                                  0xDE2CB4
+
+#define mmNIC4_QM1_IND_GW_APB_RDATA                                  0xDE2CB8
+
+#define mmNIC4_QM1_IND_GW_APB_STATUS                                 0xDE2CBC
+
+#define mmNIC4_QM1_GLBL_ERR_ADDR_LO                                  0xDE2CD0
+
+#define mmNIC4_QM1_GLBL_ERR_ADDR_HI                                  0xDE2CD4
+
+#define mmNIC4_QM1_GLBL_ERR_WDATA                                    0xDE2CD8
+
+#define mmNIC4_QM1_GLBL_MEM_INIT_BUSY                                0xDE2D00
+
+#endif /* ASIC_REG_NIC4_QM1_REGS_H_ */
diff --git a/drivers/misc/habanalabs/include/gaudi/gaudi.h b/drivers/misc/habanalabs/include/gaudi/gaudi.h
index f9ea897ae42c..23e146db929c 100644
--- a/drivers/misc/habanalabs/include/gaudi/gaudi.h
+++ b/drivers/misc/habanalabs/include/gaudi/gaudi.h
@@ -54,6 +54,18 @@
 
 #define NIC_NUMBER_OF_ENGINES	(NIC_NUMBER_OF_MACROS * 2)
 
+#define NIC_MAX_NUMBER_OF_PORTS	(NIC_NUMBER_OF_ENGINES * 2)
+
+#define NIC_SEND_WQE_SIZE	32
+
+#define NIC_RECV_WQE_SIZE	8
+
+#define NIC_MAC_NUM_OF_LANES	4
+
+#define NIC_MAC_LANES_START	0
+
+#define NIC_PHY_TX_TAPS_NUM	5
+
 #define NUMBER_OF_IF		8
 
 #define DEVICE_CACHE_LINE_SIZE	128
diff --git a/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h b/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
index 504f3ad711b5..c1951351f142 100644
--- a/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
+++ b/drivers/misc/habanalabs/include/gaudi/gaudi_masks.h
@@ -41,6 +41,11 @@
 	(FIELD_PREP(TPC0_QM_GLBL_CFG0_CQF_EN_MASK, 0x1F)) | \
 	(FIELD_PREP(TPC0_QM_GLBL_CFG0_CP_EN_MASK, 0x1F)))
 
+#define NIC_QMAN_ENABLE		(\
+	(FIELD_PREP(NIC0_QM0_GLBL_CFG0_PQF_EN_MASK, 0xF)) | \
+	(FIELD_PREP(NIC0_QM0_GLBL_CFG0_CQF_EN_MASK, 0xF)) | \
+	(FIELD_PREP(NIC0_QM0_GLBL_CFG0_CP_EN_MASK, 0xF)))
+
 #define QMAN_UPPER_CP_CGM_PWR_GATE_EN	(\
 	(FIELD_PREP(DMA0_QM_CGM_CFG_IDLE_TH_MASK, 0x20)) | \
 	(FIELD_PREP(DMA0_QM_CGM_CFG_G2F_TH_MASK, 0xA)) | \
@@ -93,6 +98,16 @@
 	(FIELD_PREP(MME0_QM_GLBL_ERR_CFG_CQF_STOP_ON_ERR_MASK, 0x1F)) | \
 	(FIELD_PREP(MME0_QM_GLBL_ERR_CFG_CP_STOP_ON_ERR_MASK, 0x1F)))
 
+#define NIC_QMAN_GLBL_ERR_CFG_MSG_EN_MASK	(\
+	(FIELD_PREP(NIC0_QM0_GLBL_ERR_CFG_PQF_ERR_MSG_EN_MASK, 0xF)) | \
+	(FIELD_PREP(NIC0_QM0_GLBL_ERR_CFG_CQF_ERR_MSG_EN_MASK, 0xF)) | \
+	(FIELD_PREP(NIC0_QM0_GLBL_ERR_CFG_CP_ERR_MSG_EN_MASK, 0xF)))
+
+#define NIC_QMAN_GLBL_ERR_CFG_STOP_ON_ERR_EN_MASK	(\
+	(FIELD_PREP(NIC0_QM0_GLBL_ERR_CFG_PQF_STOP_ON_ERR_MASK, 0xF)) | \
+	(FIELD_PREP(NIC0_QM0_GLBL_ERR_CFG_CQF_STOP_ON_ERR_MASK, 0xF)) | \
+	(FIELD_PREP(NIC0_QM0_GLBL_ERR_CFG_CP_STOP_ON_ERR_MASK, 0xF)))
+
 #define QMAN_CGM1_PWR_GATE_EN	(FIELD_PREP(DMA0_QM_CGM_CFG1_MASK_TH_MASK, 0xA))
 
 /* RESET registers configuration */
diff --git a/drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h b/drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h
new file mode 100644
index 000000000000..6f377eb57090
--- /dev/null
+++ b/drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright 2016-2019 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ *
+ */
+
+#ifndef INCLUDE_NIC_GENERAL_H_
+#define INCLUDE_NIC_GENERAL_H_
+
+#define HABANALABS_MAC_OUI_1	0xB0FD0B
+
+#endif /* INCLUDE_NIC_GENERAL_H_ */
-- 
2.17.1

