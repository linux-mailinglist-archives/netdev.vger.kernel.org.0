Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E9B5E985D
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 06:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbiIZEHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 00:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbiIZEHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 00:07:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3672A971;
        Sun, 25 Sep 2022 21:07:21 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c24so5107724plo.3;
        Sun, 25 Sep 2022 21:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Qm3X/05NS0zu77FG0jv3QAwV3JQ0p1zGs2i7CKJezT4=;
        b=KJzRCgshLV5KwFRGtGFt50Gon47mbHttQ5DvGxx+kFFR1vbf+7DMHE1JEr0E1Q0fbk
         6UaEqXyjbUBUiynebGKjNlxxgvx0qy3nVvoIhgTHmaTIabPEKtdIFyP0Yt21X6pV6z8f
         YQuMpnTz4wuoFK/27xYiuUK1KHgG9rpfYF8JQ6QRnM0YvS9gX7+bkZVo0oAjNCVBKvAC
         gX3gdfau4AuLUtDcRzD8TrEYCVvP+M0L9m4x8Es6ju6xLqOvX1/RTQcMz/zaXN59UVXT
         cLmO9NWscWGb7OdtRla7sbWUfPJeehrNyP54cDv6q5jlKukNcsvkC+BRt8h17Cg3vpyF
         vZnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Qm3X/05NS0zu77FG0jv3QAwV3JQ0p1zGs2i7CKJezT4=;
        b=qFXZb+JSGJr8tSBUUkrJ57PGz4+vyP8yvY517Jz5khDZfPKRfbNSJCy0duzEO5I+Vt
         EQ5OqD3ogLfb53dC5jblGI657JuvtcopSOOrcyuOlR5T3JxyjBi5fm5UeY2uFuqlJi60
         qxSXZuDf+4IqqNcKuLx2tRM6rDQFt2vEFencJX8INF2ASCnAUiTt3xdZ3T8uQJZ4lAm1
         awqWxouRfYIPQLWMcc4QzE9MRmG1Ut9YVbmmWcVuDVRVSGyDK8mAk81yzrPstTzgEw1G
         xIEuE3aJqLXL7A55Zs1XUWErMGQBlQqbIQdsUuGR+qZuNVu6QxzsrGrET2atQRhuDxWM
         tSHA==
X-Gm-Message-State: ACrzQf0HSIdfQQFsVkQ2U94OCnmP954lrjbuZUfFSTi/FOUJfqH5lUOk
        iHWsQEw0CDiBlVuNkwZspJE=
X-Google-Smtp-Source: AMsMyM4fIBGM1+CLjeHyDXW2GQpClYl42xw340YAwjZiZ8hWBZcND7mgTzlW+q94Y5F9ICoTl9Zp5A==
X-Received: by 2002:a17:90a:c70b:b0:200:4366:d047 with SMTP id o11-20020a17090ac70b00b002004366d047mr34806483pjt.240.1664165241100;
        Sun, 25 Sep 2022 21:07:21 -0700 (PDT)
Received: from localhost.localdomain ([2601:601:9100:2c:40bc:2209:ea1d:5052])
        by smtp.googlemail.com with ESMTPSA id y26-20020aa79afa000000b0053ebe7ffddcsm10886015pfp.116.2022.09.25.21.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 21:07:20 -0700 (PDT)
From:   Shane Parslow <shaneparslow808@gmail.com>
To:     shaneparslow808@gmail.com
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: wwan: iosm: Fix 7360 WWAN card control channel mapping
Date:   Sun, 25 Sep 2022 21:05:24 -0700
Message-Id: <20220926040524.4017-1-shaneparslow808@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the control channel mapping for the 7360, which was
previously the same as the 7560.

As shown by the reverse engineering efforts of James Wah [1], the layout
of channels on the 7360 is actually somewhat different from that of the
7560.

A new ipc_chnl_cfg is added specifically for the 7360. The new config
updates channel 7 to be an AT port and removes the mbim interface, as
it does not exist on the 7360. The config is otherwise left the same as
the 7560. ipc_chnl_cfg_get is updated to switch between the two configs.
In ipc_imem, a special case for the mbim port is removed as it no longer
exists in the 7360 ipc_chnl_cfg.

As a result of this, the second userspace AT port now functions whereas
previously it was routed to the trace channel. Modem crashes ("confused
phase", "msg timeout", "PORT open refused") resulting from garbage being
sent to the modem are also fixed.

[1] https://github.com/xmm7360/reversing

Signed-off-by: Shane Parslow <shaneparslow808@gmail.com>
---
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c | 58 ++++++++++++++++++++---
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h |  7 ++-
 drivers/net/wwan/iosm/iosm_ipc_devlink.c  |  3 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 12 ++---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c |  3 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c    |  3 +-
 6 files changed, 68 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
index 128c999e08bb..011bae887f8b 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
@@ -5,6 +5,7 @@
 
 #include <linux/wwan.h>
 
+#include "iosm_ipc_imem.h"
 #include "iosm_ipc_chnl_cfg.h"
 
 /* Max. sizes of a downlink buffers */
@@ -28,10 +29,10 @@
 /* MUX acc backoff 1ms */
 #define IRQ_ACC_BACKOFF_MUX 1000
 
-/* Modem channel configuration table
+/* 7560 modem channel configuration table
  * Always reserve element zero for flash channel.
  */
-static struct ipc_chnl_cfg modem_cfg[] = {
+static struct ipc_chnl_cfg modem_cfg_7560[IPC_MEM_MAX_CHANNELS] = {
 	/* IP Mux */
 	{ IPC_MEM_IP_CHL_ID_0, IPC_MEM_PIPE_0, IPC_MEM_PIPE_1,
 	  IPC_MEM_MAX_TDS_MUX_LITE_UL, IPC_MEM_MAX_TDS_MUX_LITE_DL,
@@ -66,11 +67,56 @@ static struct ipc_chnl_cfg modem_cfg[] = {
 	  IPC_MEM_MAX_DL_FLASH_BUF_SIZE, WWAN_PORT_UNKNOWN },
 };
 
-int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg, int index)
+/* Channel layout for the 7360
+ * Copied from the 7560, and modified based on the reverse
+ * engineering efforts of James Wah
+ */
+static struct ipc_chnl_cfg modem_cfg_7360[IPC_MEM_MAX_CHANNELS] = {
+	/* IP Mux */
+	{ IPC_MEM_IP_CHL_ID_0, IPC_MEM_PIPE_0, IPC_MEM_PIPE_1,
+	  IPC_MEM_MAX_TDS_MUX_LITE_UL, IPC_MEM_MAX_TDS_MUX_LITE_DL,
+	  IPC_MEM_MAX_DL_MUX_LITE_BUF_SIZE, WWAN_PORT_UNKNOWN },
+	/* RPC - 0 */
+	{ IPC_MEM_CTRL_CHL_ID_1, IPC_MEM_PIPE_2, IPC_MEM_PIPE_3,
+	  IPC_MEM_MAX_TDS_RPC, IPC_MEM_MAX_TDS_RPC,
+	  IPC_MEM_MAX_DL_RPC_BUF_SIZE, WWAN_PORT_UNKNOWN },
+	/* Trace? */
+	{ IPC_MEM_CTRL_CHL_ID_2, IPC_MEM_PIPE_4, IPC_MEM_PIPE_5,
+	  IPC_MEM_TDS_TRC, IPC_MEM_TDS_TRC, IPC_MEM_MAX_DL_TRC_BUF_SIZE,
+	  WWAN_PORT_UNKNOWN },
+	/* Trace? */
+	{ IPC_MEM_CTRL_CHL_ID_3, IPC_MEM_PIPE_6, IPC_MEM_PIPE_7,
+	  IPC_MEM_TDS_TRC, IPC_MEM_TDS_TRC, IPC_MEM_MAX_DL_TRC_BUF_SIZE,
+	  WWAN_PORT_UNKNOWN },
+	/* IAT0 */
+	{ IPC_MEM_CTRL_CHL_ID_4, IPC_MEM_PIPE_8, IPC_MEM_PIPE_9,
+	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_DL_AT_BUF_SIZE,
+	  WWAN_PORT_AT },
+	/* Unknown */
+	{ IPC_MEM_CTRL_CHL_ID_5, IPC_MEM_PIPE_10, IPC_MEM_PIPE_11,
+	  IPC_MEM_MAX_TDS_LOOPBACK, IPC_MEM_MAX_TDS_LOOPBACK,
+	  IPC_MEM_MAX_DL_LOOPBACK_SIZE, WWAN_PORT_UNKNOWN },
+	/* Unknown */
+	{ IPC_MEM_CTRL_CHL_ID_6, IPC_MEM_PIPE_12, IPC_MEM_PIPE_13,
+	  IPC_MEM_MAX_TDS_MBIM, IPC_MEM_MAX_TDS_MBIM,
+	  IPC_MEM_MAX_DL_MBIM_BUF_SIZE, WWAN_PORT_UNKNOWN },
+	/* IAT1 */
+	{ IPC_MEM_CTRL_CHL_ID_7, IPC_MEM_PIPE_14, IPC_MEM_PIPE_15,
+	  IPC_MEM_MAX_TDS_AT, IPC_MEM_MAX_TDS_AT,
+	  IPC_MEM_MAX_DL_AT_BUF_SIZE, WWAN_PORT_AT },
+};
+
+int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg,
+		     struct pci_dev *dev, int index)
 {
-	if (index >= ARRAY_SIZE(modem_cfg)) {
-		pr_err("index: %d and array size %zu", index,
-		       ARRAY_SIZE(modem_cfg));
+	struct ipc_chnl_cfg *modem_cfg = modem_cfg_7560;
+
+	if (dev->device == INTEL_CP_DEVICE_7360_ID)
+		modem_cfg = modem_cfg_7360;
+
+	if (index >= IPC_MEM_MAX_CHANNELS) {
+		pr_err("index: %d and array size %d", index,
+		       IPC_MEM_MAX_CHANNELS);
 		return -ECHRNG;
 	}
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h
index e77084e76718..4703c2baf3e1 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h
@@ -6,6 +6,8 @@
 #ifndef IOSM_IPC_CHNL_CFG_H
 #define IOSM_IPC_CHNL_CFG_H
 
+#include <linux/pci.h>
+
 #include "iosm_ipc_mux.h"
 
 /* Number of TDs on the trace channel */
@@ -51,10 +53,11 @@ struct ipc_chnl_cfg {
 /**
  * ipc_chnl_cfg_get - Get pipe configuration.
  * @chnl_cfg:		Array of ipc_chnl_cfg struct
+ * @dev:		PCI device struct of the modem
  * @index:		Channel index (upto MAX_CHANNELS)
  *
  * Return: 0 on success and failure value on error
  */
-int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg, int index);
-
+int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg,
+		      struct pci_dev *dev, int index);
 #endif
diff --git a/drivers/net/wwan/iosm/iosm_ipc_devlink.c b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
index 17da85a8f337..e5dcff9845cc 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_devlink.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_devlink.c
@@ -272,7 +272,8 @@ struct iosm_devlink *ipc_devlink_init(struct iosm_imem *ipc_imem)
 		goto region_create_fail;
 	}
 
-	if (ipc_chnl_cfg_get(&chnl_cfg_flash, IPC_MEM_CTRL_CHL_ID_7) < 0)
+	if (ipc_chnl_cfg_get(&chnl_cfg_flash, ipc_imem->pcie->pci,
+			     IPC_MEM_CTRL_CHL_ID_7) < 0)
 		goto chnl_get_fail;
 
 	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_CTRL,
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 1e6a47976642..98055532e065 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -310,7 +310,9 @@ static void ipc_imem_dl_skb_process(struct iosm_imem *ipc_imem,
 		ipc_pcie_addr_unmap(ipc_imem->pcie, IPC_CB(skb)->len,
 				    IPC_CB(skb)->mapping,
 				    IPC_CB(skb)->direction);
-		if (port_id == IPC_MEM_CTRL_CHL_ID_7)
+		/* 7360: Channel 7 is an AT port, do not fwd to devlink */
+		if (port_id == IPC_MEM_CTRL_CHL_ID_7 &&
+		    ipc_imem->pcie->pci->device != INTEL_CP_DEVICE_7360_ID)
 			ipc_imem_sys_devlink_notify_rx(ipc_imem->ipc_devlink,
 						       skb);
 		else if (ipc_is_trace_channel(ipc_imem, port_id))
@@ -585,13 +587,9 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 		ipc_imem->mux->wwan = ipc_imem->wwan;
 
 	while (ctrl_chl_idx < IPC_MEM_MAX_CHANNELS) {
-		if (!ipc_chnl_cfg_get(&chnl_cfg_port, ctrl_chl_idx)) {
+		if (!ipc_chnl_cfg_get(&chnl_cfg_port, ipc_imem->pcie->pci,
+				      ctrl_chl_idx)) {
 			ipc_imem->ipc_port[ctrl_chl_idx] = NULL;
-			if (ipc_imem->pcie->pci->device == INTEL_CP_DEVICE_7360_ID &&
-			    chnl_cfg_port.wwan_port_type == WWAN_PORT_MBIM) {
-				ctrl_chl_idx++;
-				continue;
-			}
 			if (chnl_cfg_port.wwan_port_type != WWAN_PORT_UNKNOWN) {
 				ipc_imem_channel_init(ipc_imem, IPC_CTYPE_CTRL,
 						      chnl_cfg_port,
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 57304a5adf68..6fd7d4a3c9f7 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -90,7 +90,8 @@ void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
 		return;
 	}
 
-	ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->nr_of_channels);
+	ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->pcie->pci,
+			 ipc_imem->nr_of_channels);
 	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_WWAN, chnl_cfg,
 			      IRQ_MOD_OFF);
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
index eeecfa3d10c5..6012f9099d6a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -137,7 +137,8 @@ struct iosm_trace *ipc_trace_init(struct iosm_imem *ipc_imem)
 	struct ipc_chnl_cfg chnl_cfg = { 0 };
 	struct iosm_trace *ipc_trace;
 
-	ipc_chnl_cfg_get(&chnl_cfg, IPC_MEM_CTRL_CHL_ID_3);
+	ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->pcie->pci,
+			 IPC_MEM_CTRL_CHL_ID_3);
 	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_CTRL, chnl_cfg,
 			      IRQ_MOD_OFF);
 
-- 
2.37.3

