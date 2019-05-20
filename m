Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B90238DC
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390491AbfETNyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 09:54:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44808 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390418AbfETNyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 09:54:11 -0400
Received: by mail-io1-f67.google.com with SMTP id f22so11033332iol.11
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 06:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qTfgXH2ZXOT0rZW+kdJ3acNhah3zg+9vblvPOMdBQ14=;
        b=v3cHBs+JVLGbaW7f+X68Q7SNESSu2ea1qt0XE5rwqRRjB1H+pvrtWDxfUH0AEFsQJq
         +l0yHFwkErTYtnhtH/d87kocoecxvwNEuzEn3ZgwG54OEKQbv0vupQIsVRPhY7yvwsrg
         Wepwos5OEehfTrvI6BJ3/HL98x9ItLBsiW4ABMW4s6cvh29x/nQal4rB5atykq3D+fXq
         o2pcQA2VJz1bqrOD16+M33W2hVMyjFGHKcFIAqkJWBAVwu8iMyTEbfFoqlPUfckbLVWB
         VNrr2RSoVbQp421gKP4231PwDa78wGcYfQJlvT3qi89msxZU19CRvpv0TxKB6B20v7/K
         HE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qTfgXH2ZXOT0rZW+kdJ3acNhah3zg+9vblvPOMdBQ14=;
        b=W1/wRmBDd+HilSKzzb5tsrweLJbSKC8MpnH5hyNY7W6fqjSxvv0apMGC4zDPnRKCcr
         +7AvoYEybqmLxuA0F3mZ+uZxjyRtxScJ3ndLAz4T6TvFb0htyZsGc76GC4MlSmIDPMXx
         8GFXJkRgvA4GsPRMxZpynUJ4esXbKwwRvzQOS1AkQ2aLt/u4IGvYGI3P3dZ0v9kTqHJl
         hvCdasfB96DKntR10XG2cQnLbmYf/E7A2rVEYeKhWy3ElpYyhDjj0fznLq56mJSNZW9a
         Gw3lPKRnBmO+NGSaB5mZ8MqG+7zHCT7tGB58BZ1BkAmTI0t6/7YgNghHG1NTvHveMFDq
         SAcg==
X-Gm-Message-State: APjAAAViZMNeJotzAvsI/Hg8JBC4ZGUgUTEpoYy+gmJOME+KU3u0zj2L
        n4U9946wpbnNwk9VU5V06y9Uog==
X-Google-Smtp-Source: APXvYqw+Dh6IdcQx6woJU//JReMZ8LVIygVjAfQCtJfQq3P/b8mcrruZxt3mXsn8gRe41T3YpWrDpA==
X-Received: by 2002:a05:6602:2049:: with SMTP id z9mr14847619iod.46.1558360450147;
        Mon, 20 May 2019 06:54:10 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id n17sm6581185ioa.0.2019.05.20.06.54.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:54:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     arnd@arndb.de, subashab@codeaurora.org, david.brown@linaro.org,
        agross@kernel.org, davem@davemloft.net
Cc:     bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] net: introduce "include/linux/if_rmnet.h"
Date:   Mon, 20 May 2019 08:53:54 -0500
Message-Id: <20190520135354.18628-9-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520135354.18628-1-elder@linaro.org>
References: <20190520135354.18628-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA driver requires some (but not all) symbols defined in
"drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h".  Create a new
public header file "include/linux/if_rmnet.h" and move the needed
definitions there.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  1 +
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 31 -------------
 .../qualcomm/rmnet/rmnet_map_command.c        |  1 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  1 +
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  1 +
 include/linux/if_rmnet.h                      | 45 +++++++++++++++++++
 6 files changed, 49 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/if_rmnet.h

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 5fff6c78ecd5..8e00e14f4ac9 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -18,6 +18,7 @@
 #include <linux/netdev_features.h>
 #include <linux/if_arp.h>
 #include <net/sock.h>
+#include <linux/if_rmnet.h>
 #include "rmnet_private.h"
 #include "rmnet_config.h"
 #include "rmnet_vnd.h"
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 775b98d34e94..d101cabb04c3 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -39,37 +39,6 @@ enum rmnet_map_commands {
 	RMNET_MAP_COMMAND_ENUM_LENGTH
 };
 
-struct rmnet_map_header {
-	u8  cmd_pad_len;	/* RMNET_MAP_* */
-	u8  mux_id;
-	__be16 pkt_len;
-}  __aligned(1);
-
-#define RMNET_MAP_CMD_FMASK		GENMASK(0, 0)   /* 0: data; 1: cmd */
-#define RMNET_MAP_RESERVED_FMASK	GENMASK(1, 1)
-#define RMNET_MAP_PAD_LEN_FMASK		GENMASK(7, 2)
-
-struct rmnet_map_dl_csum_trailer {
-	u8  reserved1;
-	u8  flags;		/* RMNET_MAP_DL_* */
-	__be16 csum_start_offset;
-	__be16 csum_length;
-	__be16 csum_value;
-} __aligned(1);
-
-#define RMNET_MAP_DL_CSUM_VALID_FMASK	GENMASK(0, 0)
-#define RMNET_MAP_DL_RESERVED_FMASK	GENMASK(7, 1)
-
-struct rmnet_map_ul_csum_header {
-	__be16 csum_start_offset;
-	__be16 csum_info;	/* RMNET_MAP_UL_* */
-} __aligned(1);
-
-/* NOTE:  These field masks are defined in CPU byte order */
-#define RMNET_MAP_UL_CSUM_INSERT_FMASK	GENMASK(13, 0)
-#define RMNET_MAP_UL_CSUM_UDP_FMASK	GENMASK(14, 14)   /* 0: IP; 1: UDP */
-#define RMNET_MAP_UL_CSUM_ENABLED_FMASK	GENMASK(15, 15)
-
 #define RMNET_MAP_COMMAND_REQUEST     0
 #define RMNET_MAP_COMMAND_ACK         1
 #define RMNET_MAP_COMMAND_UNSUPPORTED 2
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
index f675f47c3495..6832c5939cae 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/netdevice.h>
+#include <linux/if_rmnet.h>
 #include "rmnet_config.h"
 #include "rmnet_map.h"
 #include "rmnet_private.h"
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 61b7dbab2056..370aee7402e0 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -18,6 +18,7 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
+#include <linux/if_rmnet.h>
 #include "rmnet_config.h"
 #include "rmnet_map.h"
 #include "rmnet_private.h"
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index d11c16aeb19a..6b39d4d8e523 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -17,6 +17,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <net/pkt_sched.h>
+#include <linux/if_rmnet.h>
 #include "rmnet_config.h"
 #include "rmnet_handlers.h"
 #include "rmnet_private.h"
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
new file mode 100644
index 000000000000..ae60472ecc79
--- /dev/null
+++ b/include/linux/if_rmnet.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019 Linaro Ltd.
+ */
+#ifndef _LINUX_IF_RMNET_H_
+#define _LINUX_IF_RMNET_H_
+
+#include <linux/types.h>
+
+/* Header structure that precedes packets in ETH_P_MAP protocol */
+struct rmnet_map_header {
+	u8  cmd_pad_len;	/* RMNET_MAP_* */
+	u8  mux_id;
+	__be16 pkt_len;
+}  __aligned(1);
+
+#define RMNET_MAP_CMD_FMASK		GENMASK(0, 0)   /* 0: data; 1: cmd */
+#define RMNET_MAP_RESERVED_FMASK	GENMASK(1, 1)
+#define RMNET_MAP_PAD_LEN_FMASK		GENMASK(7, 2)
+
+/* Checksum offload metadata header for outbound packets*/
+struct rmnet_map_ul_csum_header {
+	__be16 csum_start_offset;
+	__be16 csum_info;	/* RMNET_MAP_UL_* */
+} __aligned(1);
+
+/* NOTE:  These field masks are defined in CPU byte order */
+#define RMNET_MAP_UL_CSUM_INSERT_FMASK	GENMASK(13, 0)
+#define RMNET_MAP_UL_CSUM_UDP_FMASK	GENMASK(14, 14)   /* 0: IP; 1: UDP */
+#define RMNET_MAP_UL_CSUM_ENABLED_FMASK	GENMASK(15, 15)
+
+/* Checksum offload metadata trailer for inbound packets */
+struct rmnet_map_dl_csum_trailer {
+	u8  reserved1;
+	u8  flags;		/* RMNET_MAP_DL_* */
+	__be16 csum_start_offset;
+	__be16 csum_length;
+	__be16 csum_value;
+} __aligned(1);
+
+#define RMNET_MAP_DL_CSUM_VALID_FMASK	GENMASK(0, 0)
+#define RMNET_MAP_DL_RESERVED_FMASK	GENMASK(7, 1)
+
+#endif /* _LINUX_IF_RMNET_H_ */
-- 
2.20.1

