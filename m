Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEE365FF40
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbjAFK7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjAFK7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:59:12 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944566CFF2;
        Fri,  6 Jan 2023 02:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1673002751; x=1704538751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=czBvPkOaTKzYlrTp7htNRXp6MXEfNLCtJhGdaz9BVkI=;
  b=hqYIyiL5AZDuIt9pQBU8/A35HSGNkJZ7QxnVFleO85m0b7VwHAuam/Ka
   3/zpqoU+hlNaFgRkv9XeMsWGvvDLtgA72GRxReKxn9RiYj5oZGw5hKluk
   kZ+Q2EdX84k5Ff0YXONIzUPtHm/wiy+ZuJcWNDigR+6jEcykdG/bXesn6
   bIjHM85yB/mKkfxEM5AF30wZDjv8uAxUHEaICPallU0OYl1f0JuUENKIM
   jA+RfR8LY4A0u/qRQHTv8tgoU1IX4BaWG2SGSIyZ4beCBqpV6/zU+f1BC
   fRlC9RNv+dTCjJm6i55cwag3m7/woQI5MBhvWy/6P2rabB/J/RO6tJNLI
   w==;
X-IronPort-AV: E=Sophos;i="5.96,305,1665439200"; 
   d="scan'208";a="28272863"
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
  bh=czBvPkOaTKzYlrTp7htNRXp6MXEfNLCtJhGdaz9BVkI=;
  b=XQUigQXxv5ynyoISP8af8eDnLner2u0CQtzUDJhYOK9/g/WW5WHGE1A8
   N7cVpnVEkQANhC2ufX+wY/890u/y4Bx8A1qhNyNqXLaYoDrMf6Ju/WdzH
   sztBWbClcYRVVn/+iDjSeQpy+FYmcNbL1e6bXSUO9busdLSX23VBVz7y+
   CHjf6dspRyHtSSXQcx5qU/xP2rjxEnoruUmsQMhUa/LdHsy5UHHM5RvWN
   PvWseUu1Ev09wrFJQreDFs793AiXF37sePP4G7EAaaAfrWJD7pGXsbntG
   xb3q3wy3hOil0vWhcKeicFWEy3gltW6H7tUmNb2FcWZ/f6i0yOf+PDBsc
   g==;
X-IronPort-AV: E=Sophos;i="5.96,305,1665439200"; 
   d="scan'208";a="28272861"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 06 Jan 2023 11:59:05 +0100
Received: from steina-w.tq-net.de (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 9FC58280056;
        Fri,  6 Jan 2023 11:59:05 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH 2/2] ath10k: Add support for QCA9377 hw1.1 usb
Date:   Fri,  6 Jan 2023 11:58:53 +0100
Message-Id: <20230106105853.3484381-3-alexander.stein@ew.tq-group.com>
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

This adds hw_param for QCA9377 hw1.1 usb device.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 28 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  8 ++++++++
 drivers/net/wireless/ath/ath10k/usb.c  |  1 +
 3 files changed, 37 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f69dab55fa36..e67f1a852cd1 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -646,6 +646,34 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.use_fw_tx_credits = true,
 		.delay_unmap_buffer = false,
 	},
+	{
+		.id = QCA9377_HW_1_1_DEV_VERSION,
+		.dev_id = QCA9377_1_1_DEVICE_ID,
+		.bus = ATH10K_BUS_USB,
+		.name = "qca9377 hw1.1 usb",
+		.patch_load_addr = QCA9377_HW_1_1_PATCH_LOAD_ADDR,
+		.uart_pin = 19,
+		.otp_exe_param = 0,
+		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
+		.cal_data_len = 8124,
+		.fw = {
+			.dir = QCA9377_HW_1_1_FW_DIR,
+			.board = QCA9377_HW_1_1_USB_BOARD_DATA_FILE,
+			.board_size = QCA9377_BOARD_DATA_SZ,
+			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
+		},
+		.hw_ops = &qca6174_ops,
+		.hw_clk = qca6174_clk,
+		.target_cpu_freq = 176000000,
+		.decap_align_bytes = 4,
+		.n_cipher_suites = 8,
+		.num_peers = TARGET_QCA9377_HL_NUM_PEERS,
+		.ast_skid_limit = 0x10,
+		.num_wds_entries = 0x20,
+		.uart_pin_workaround = true,
+		.start_once = true,
+	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index ea3b5c5c6c9b..2e934d74d7cc 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -29,6 +29,7 @@ enum ath10k_bus {
 #define QCA9888_2_0_DEVICE_ID	(0x0056)
 #define QCA9984_1_0_DEVICE_ID	(0x0046)
 #define QCA9377_1_0_DEVICE_ID   (0x0042)
+#define QCA9377_1_1_DEVICE_ID   (0x9378)
 #define QCA9887_1_0_DEVICE_ID   (0x0050)
 
 /* QCA988X 1.0 definitions (unsupported) */
@@ -123,6 +124,13 @@ enum qca9377_chip_id_rev {
 #define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
 #define QCA9377_HW_1_0_PATCH_LOAD_ADDR	0x1234
 
+/* QCA9377 1.1 definitions */
+#define QCA9377_HW_1_1_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.1"
+#define QCA9377_HW_1_1_BOARD_DATA_FILE "board.bin"
+#define QCA9377_HW_1_1_SDIO_BOARD_DATA_FILE "board-sdio.bin"
+#define QCA9377_HW_1_1_USB_BOARD_DATA_FILE "board-usb.bin"
+#define QCA9377_HW_1_1_PATCH_LOAD_ADDR	0x1234
+
 /* QCA4019 1.0 definitions */
 #define QCA4019_HW_1_0_DEV_VERSION     0x01000000
 #define QCA4019_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA4019/hw1.0"
diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index b0067af685b1..efb949158aa1 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1107,6 +1107,7 @@ static int ath10k_usb_pm_resume(struct usb_interface *interface)
 /* table of devices that work with this driver */
 static struct usb_device_id ath10k_usb_ids[] = {
 	{USB_DEVICE(0x13b1, 0x0042)}, /* Linksys WUSB6100M */
+	{USB_DEVICE(0x0CF3, 0x9378)}, /* Qualcomm QCA9377-7 */
 	{ /* Terminating entry */ },
 };
 
-- 
2.34.1

