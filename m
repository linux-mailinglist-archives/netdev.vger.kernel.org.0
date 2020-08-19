Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3FF249750
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgHSH3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgHSHZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:25:07 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4FCC061343
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:26 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l2so20443934wrc.7
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XsnY8YATOoOqBq7gQjoztKCpYLOIPMdc0eJUU1GlCFo=;
        b=E7p5gG+OFcZGnyShYmD7vMGdcWoP4GkBI2rRZx9DVdOEiWJnrcDeLk7llK6cm+Hlik
         6r5mmXWI78YYJP3DKrf/1iUtHHiJN/ULO7zAqzMSpE7MJQDbpYvzS1yZYrtZv6kycisH
         zQ8ejwzemTWd/BU9tENVMVfReSPZ1TL+dcnot52pmlpP2bYjnMoUTE/xS+XfzQhYzFe3
         WzYRIJ+KJDiKG+P2nZhO5HJLMEWRLszQ4c47wFzpGKfpP3Ox1LrAnL4jqXbOtPeIKmsm
         ISIY150cNobgR3r71KxKmerPOkOXAFGhdaT79jpWsL++g6ONYOhjj1EWy/Tdh7td1jja
         nsTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XsnY8YATOoOqBq7gQjoztKCpYLOIPMdc0eJUU1GlCFo=;
        b=Yq6X+S+p5/sOMGl1h+qMiWxGi1UL+HTbmdndk1E2hir0ZF8ZqzHqlvWAy0mn+0kwCr
         XiBDX7PhCloFalYVCfIc/aye53jgVrfGVJNN8RHKwrljDASuRNvd1MO5QKbN3EJIaBUh
         scaC/kzobsnkiYrrvpkCZwXYwNT3OD2pB1l1/P5yIeCjhwxxmxHuE0nGM/Wy3HB6L/Mu
         C/1sqLoOTdiDHITI1wFEAxFg7aiFHQRipmyO53Ni1B8Smpk/H7+dq/KhIzEcJ0jgL7pi
         tVm9R2VvtOYGO55qvgPaYKeAenxFcCZUsCG9DGiBVAfzIrg0ZQPHPIjPwJ7vk2nvQSD/
         mKNA==
X-Gm-Message-State: AOAM533/pET4zhi/RynjFdD7UA3JLNmBf6MJlSnQ+oeTu3C9sht0Aevp
        SKnINKJFCPW6/5p7+49JiV5l+A==
X-Google-Smtp-Source: ABdhPJyE2CZIGQjt5JjYV+73qd7TN6Mh/0NNigM03pejfNcXPi+u1x4JVVQDSz+U5ZrvMpQuZxc7OQ==
X-Received: by 2002:adf:eb89:: with SMTP id t9mr23275239wrn.65.1597821864972;
        Wed, 19 Aug 2020 00:24:24 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:24 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Subject: [PATCH 16/28] wireless: marvell: mwifiex: init: Move 'tos_to_tid_inv' to where it's used
Date:   Wed, 19 Aug 2020 08:23:50 +0100
Message-Id: <20200819072402.3085022-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'tos_to_tid_inv' is only used in 2 of 17 files it's current being
included into.

Fixes the following W=1 kernel build warning(s):

 In file included from drivers/net/wireless/marvell/mwifiex/main.c:23:
 In file included from drivers/net/wireless/marvell/mwifiex/cmdevt.c:26:
 In file included from drivers/net/wireless/marvell/mwifiex/util.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/txrx.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/11n.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/wmm.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/11n_aggr.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/join.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/sta_cmd.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/sta_ioctl.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/sta_event.c:25:
 In file included from drivers/net/wireless/marvell/mwifiex/uap_txrx.c:23:
 In file included from drivers/net/wireless/marvell/mwifiex/sdio.c:27:
 In file included from drivers/net/wireless/marvell/mwifiex/sta_tx.c:25:
 drivers/net/wireless/marvell/mwifiex/wmm.h:41:17: warning: ‘tos_to_tid_inv’ defined but not used [-Wunused-const-variable=]
 41 | static const u8 tos_to_tid_inv[] = {

 NB: Snipped for brevity

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c | 16 ++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/tdls.c | 16 ++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/wmm.h  | 15 ---------------
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 82d69bc3aaaf4..7ffc78b258317 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -25,6 +25,22 @@
 #include "wmm.h"
 #include "11n.h"
 
+/*
+ * This table inverses the tos_to_tid operation to get a priority
+ * which is in sequential order, and can be compared.
+ * Use this to compare the priority of two different TIDs.
+ */
+static const u8 tos_to_tid_inv[] = {
+	0x02,  /* from tos_to_tid[2] = 0 */
+	0x00,  /* from tos_to_tid[0] = 1 */
+	0x01,  /* from tos_to_tid[1] = 2 */
+	0x03,
+	0x04,
+	0x05,
+	0x06,
+	0x07
+};
+
 /*
  * This function adds a BSS priority table to the table list.
  *
diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index 97bb87c3676bb..35c02b149820d 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -27,6 +27,22 @@
 #define TDLS_CONFIRM_FIX_LEN  6
 #define MWIFIEX_TDLS_WMM_INFO_SIZE 7
 
+/*
+ * This table inverses the tos_to_tid operation to get a priority
+ * which is in sequential order, and can be compared.
+ * Use this to compare the priority of two different TIDs.
+ */
+static const u8 tos_to_tid_inv[] = {
+	0x02,  /* from tos_to_tid[2] = 0 */
+	0x00,  /* from tos_to_tid[0] = 1 */
+	0x01,  /* from tos_to_tid[1] = 2 */
+	0x03,
+	0x04,
+	0x05,
+	0x06,
+	0x07
+};
+
 static void mwifiex_restore_tdls_packets(struct mwifiex_private *priv,
 					 const u8 *mac, u8 status)
 {
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.h b/drivers/net/wireless/marvell/mwifiex/wmm.h
index 04d7da95e3078..60bdbb82277a3 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.h
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.h
@@ -33,21 +33,6 @@ enum ieee_types_wmm_ecw_bitmasks {
 
 static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 
-/*
- * This table inverses the tos_to_tid operation to get a priority
- * which is in sequential order, and can be compared.
- * Use this to compare the priority of two different TIDs.
- */
-static const u8 tos_to_tid_inv[] = {
-	0x02,  /* from tos_to_tid[2] = 0 */
-	0x00,  /* from tos_to_tid[0] = 1 */
-	0x01,  /* from tos_to_tid[1] = 2 */
-	0x03,
-	0x04,
-	0x05,
-	0x06,
-	0x07};
-
 /*
  * This function retrieves the TID of the given RA list.
  */
-- 
2.25.1

