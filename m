Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFF265FF3D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjAFK7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjAFK7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:59:12 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CF66C28D;
        Fri,  6 Jan 2023 02:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1673002750; x=1704538750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u2U+tHYqP9BEtEc5/Z4v3SPrboaPQEo9G90ExFDXKH4=;
  b=iH+liK++1dT+gJRBigTVly6QYWN5z8dEgRlISqYq+4/4pUf6vuqktj4M
   pKVERmbmytE1OkfOhw/NZekiPWx7ChyRkpGYXaD9Ph1KGQ/9skpixTKyh
   MtiDX7iT3TSrrVB2ml+Vp9p2LLzlFfea/USSFbWu70TEMzZFH1bkR+Ixx
   0USdM/QkZWtvSJE4Kb9gEdVokB1k4WAXqzT8aRE/Zjq3D8pJbIkzm933d
   LT6w/26K0NzRiLXJnLqOWpbl7UcdEsi9wn9XN2y3XUb3GHahF7VxllNY2
   zLrZUbVmFSSYD05f8UvC734jNyFdiLMoO2QiiMr9/+ZcYSz5W9g/48Jrr
   A==;
X-IronPort-AV: E=Sophos;i="5.96,305,1665439200"; 
   d="scan'208";a="28272862"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 06 Jan 2023 11:59:05 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 06 Jan 2023 11:59:05 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 06 Jan 2023 11:59:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1673002745; x=1704538745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u2U+tHYqP9BEtEc5/Z4v3SPrboaPQEo9G90ExFDXKH4=;
  b=iKPI3sPcUHr2co92sQ98dTWrRKn5wlzCcrWzIXrfrh/8oVNVfahAq9u/
   +4xazLzP/ONfFOAOEq5FYRJj1qlw85V5h7lBbygJ7WBA0jIZs/6ADDYyn
   pQFkp1p/4CLdXqd48dqDxrl7ESPNJ2JfJFTT5vDrgpPdwXlrCa4v2F/jd
   JJH1K6XzkRQ6zfK3vLzz/J5et9MRejnvxjAvgd4l61idN1bzI9CNwHNVy
   zI96DK9icx1fqwAHpGYu4GgFRrbGCYZcaRPPDccxxJLEcJ9aMnArAQWu9
   hrvx6Jd1HcAWjHLVo5l+rZMj3ddyiW4dFPvfemVn1AGsnUikbKIrHsfKB
   w==;
X-IronPort-AV: E=Sophos;i="5.96,305,1665439200"; 
   d="scan'208";a="28272860"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 06 Jan 2023 11:59:05 +0100
Received: from steina-w.tq-net.de (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 62C00280072;
        Fri,  6 Jan 2023 11:59:05 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: [RFC PATCH 1/2] HACK: ath10k: add start_once support
Date:   Fri,  6 Jan 2023 11:58:52 +0100
Message-Id: <20230106105853.3484381-2-alexander.stein@ew.tq-group.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106105853.3484381-1-alexander.stein@ew.tq-group.com>
References: <20230106105853.3484381-1-alexander.stein@ew.tq-group.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erik Stromdahl <erik.stromdahl@gmail.com>

Add possibility to configure the driver to only start target once.
This can reduce startup time of SDIO devices significantly since
loading the firmware can take a substantial amount of time.

The patch is also necessary for high latency devices in general
since it does not seem to be possible to rerun the BMI phase
(fw upload) without power-cycling the device.

[kvalo: this needs more discussion as it's pretty important to be able to
reset/stop the firmware. with SDIO we should (I hope) to control the target
device power. And on USB it should be possible to reset the device via a
register.]

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
---
This type of patch is floating around everywhere ath10k USB support is used.
I don't have any knowledge about internals, so there is not much I can add here.

I had to add a check for start_once in ath10k_halt() as well, otherwise
interface up after shutting down will timeout.

[  410.212643] usb 1-1.1.2: Failed to submit usb control message: -110
[  410.218961] usb 1-1.1.2: unable to send the bmi data to the device: -110
[  410.225708] usb 1-1.1.2: Unable to read soc register from device: -110
[  411.236646] usb 1-1.1.2: Failed to submit usb control message: -110
[  411.242963] usb 1-1.1.2: unable to send the bmi data to the device: -110
[  411.249703] usb 1-1.1.2: unable to write to the device (-110)
[  411.255479] usb 1-1.1.2: settings HTC version failed
[  411.260476] usb 1-1.1.2: Could not init core: -22

 drivers/net/wireless/ath/ath10k/core.c | 20 ++++++++++++++++----
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 drivers/net/wireless/ath/ath10k/hw.h   |  6 ++++++
 drivers/net/wireless/ath/ath10k/mac.c  |  7 +++++--
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 5eb131ab916f..f69dab55fa36 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2927,6 +2927,9 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	int status;
 	u32 val;
 
+	if (ar->is_started && ar->hw_params.start_once)
+		return 0;
+
 	lockdep_assert_held(&ar->conf_mutex);
 
 	clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
@@ -3231,6 +3234,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		goto err_hif_stop;
 	}
 
+	ar->is_started = true;
+
 	return 0;
 
 err_hif_stop:
@@ -3285,6 +3290,7 @@ void ath10k_core_stop(struct ath10k *ar)
 	ath10k_wmi_detach(ar);
 
 	ar->id.bmi_ids_valid = false;
+	ar->is_started = false;
 }
 EXPORT_SYMBOL(ath10k_core_stop);
 
@@ -3424,12 +3430,18 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_unlock;
 	}
 
-	ath10k_debug_print_boot_info(ar);
-	ath10k_core_stop(ar);
+	/* Leave target running if hw_params.start_once is set */
+	if (ar->hw_params.start_once) {
+		mutex_unlock(&ar->conf_mutex);
+	} else {
+		ath10k_debug_print_boot_info(ar);
+		ath10k_core_stop(ar);
+
+		mutex_unlock(&ar->conf_mutex);
 
-	mutex_unlock(&ar->conf_mutex);
+		ath10k_hif_power_down(ar);
+	}
 
-	ath10k_hif_power_down(ar);
 	return 0;
 
 err_unlock:
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index f5de8ce8fb45..0ef21171db87 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1054,6 +1054,8 @@ struct ath10k {
 	bool nlo_enabled;
 	bool p2p;
 
+	bool is_started;
+
 	struct {
 		enum ath10k_bus bus;
 		const struct ath10k_hif_ops *ops;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 9643031a4427..ea3b5c5c6c9b 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -639,6 +639,12 @@ struct ath10k_hw_params {
 	bool use_fw_tx_credits;
 
 	bool delay_unmap_buffer;
+
+	/* Specifies whether or not the device should be started once.
+	 * If set, the device will be started once by the early fw probe
+	 * and it will not be terminated afterwards.
+	 */
+	bool start_once;
 };
 
 struct htt_resp;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ec8d5b29bc72..c6b84f9bb0e3 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4790,8 +4790,11 @@ void ath10k_halt(struct ath10k *ar)
 	ath10k_scan_finish(ar);
 	ath10k_peer_cleanup_all(ar);
 	ath10k_stop_radar_confirmation(ar);
-	ath10k_core_stop(ar);
-	ath10k_hif_power_down(ar);
+	/* Leave target running if hw_params.start_once is set */
+	if (!ar->hw_params.start_once) {
+		ath10k_core_stop(ar);
+		ath10k_hif_power_down(ar);
+	}
 
 	spin_lock_bh(&ar->data_lock);
 	list_for_each_entry(arvif, &ar->arvifs, list)
-- 
2.34.1

