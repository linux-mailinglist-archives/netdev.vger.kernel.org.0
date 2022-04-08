Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1504F9251
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbiDHJ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbiDHJ5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:57:44 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9FB1C5502;
        Fri,  8 Apr 2022 02:55:41 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id c4so10284308qtx.1;
        Fri, 08 Apr 2022 02:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MxHsvmkk8E+8FpG6AO+OTMlzwh4VkmczYAqMfO0S5aY=;
        b=BjuUx+JN6YPMS4VPTaoGRmF4THiXRmE5dClVXANJdixb00Tmbx9YBz44v7xr2sb/13
         LsbzNJoCfAgPqUlohr+6TaSVVNqSo7rC55YUfi2rarKPR3ezym6sz21lsd8Cexf3unTk
         iWmArqHoI/zthTWFhuEmH533coMXfmKduMUE+EP4aFHb2DOBjXTuWmx/J+cykgsbhfij
         +K+2UM+53MJu5JL/0X0+sFTripwxwLzwKie/EnhqZkC9Ee0i3ycinT8wcvcOw6jJinD0
         WhssIJRDulkEyq3DldPQz7sCjE794etEPc7n8izJvBs8jLMK1gcdbch9lSHtXUAEvBHP
         US9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MxHsvmkk8E+8FpG6AO+OTMlzwh4VkmczYAqMfO0S5aY=;
        b=q+m2h9oTBhvfmXJz0WUAdV6d40AFN2RJzimAF+YXt+KbeUJwOMQ2cgzNIgu/KKSCnv
         ujgTiU4s+JXVf6dmXfIUFcdCWcl15LXK+ynY3iEfrmi9djFL0nO0XJb9Ma0qNfuzzQc9
         twJkd22rnbBtkcFePN0blP+NdZ5rgrpPdOlTUb1d6DMPeHqpB7tKix0cCxBfw9AWFSUe
         /sHL07oNy3VbdsAsITjBv9Yu8+yCAd5BZyD0g5B1W4RCkv+YWeZZf2PHd3lgFfswTm+5
         IiQ1G80kXDw1F1VOI3bfsTvkRh7EHq8RR1+Tm9BD1Irp8kbCixu+7masbZuJi/6RLPCe
         jqCg==
X-Gm-Message-State: AOAM532XCG9zwoRiwZIobvq3YecOooQUGlmvrkU+ROFIcQnyBo8ONErR
        LTCBLmMj8GNonCVNf451WbJ4WYeNkxg=
X-Google-Smtp-Source: ABdhPJzWJ5ni8b38p1rxFytKpgn8pmy+7CSvFE2lehyOcyiuL5HOJcAl+7zIec6Yxf6Sj0fsKsSi9w==
X-Received: by 2002:a05:622a:1308:b0:2e1:e8a9:8aaf with SMTP id v8-20020a05622a130800b002e1e8a98aafmr15320487qtk.282.1649411740330;
        Fri, 08 Apr 2022 02:55:40 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u13-20020a05622a010d00b002e1d653c2e1sm18122546qtw.46.2022.04.08.02.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 02:55:39 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     alexander.deucher@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie
Cc:     daniel@ffwll.ch, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        tvrtko.ursulin@linux.intel.com, lv.ruyi@zte.com.cn,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] drivers: Fix spelling mistake "writting" -> "writing"
Date:   Fri,  8 Apr 2022 09:55:31 +0000
Message-Id: <20220408095531.2495168-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

There are some spelling mistakes in the comments. Fix it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c              | 2 +-
 drivers/gpu/drm/i915/i915_request.c                 | 2 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h                | 4 ++--
 drivers/net/ethernet/toshiba/tc35815.c              | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 4 ++--
 drivers/platform/x86/hp_accel.c                     | 2 +-
 drivers/rtc/rtc-sa1100.c                            | 2 +-
 drivers/scsi/pmcraid.c                              | 4 ++--
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 9426e252d8aa..ce361fce7155 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -7304,7 +7304,7 @@ static void gfx_v10_0_setup_grbm_cam_remapping(struct amdgpu_device *adev)
 		return;
 
 	/* initialize cam_index to 0
-	 * index will auto-inc after each data writting */
+	 * index will auto-inc after each data writing */
 	WREG32_SOC15(GC, 0, mmGRBM_CAM_INDEX, 0);
 
 	switch (adev->ip_versions[GC_HWIP][0]) {
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 582770360ad1..cf79a25cd98a 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -451,7 +451,7 @@ static bool __request_in_flight(const struct i915_request *signal)
 	 * to avoid tearing.]
 	 *
 	 * Note that the read of *execlists->active may race with the promotion
-	 * of execlists->pending[] to execlists->inflight[], overwritting
+	 * of execlists->pending[] to execlists->inflight[], overwriting
 	 * the value at *execlists->active. This is fine. The promotion implies
 	 * that we received an ACK from the HW, and so the context is not
 	 * stuck -- if we do not see ourselves in *active, the inflight status
diff --git a/drivers/net/ethernet/sfc/mcdi_pcol.h b/drivers/net/ethernet/sfc/mcdi_pcol.h
index d3fcbf930dba..ff617b1b38d3 100644
--- a/drivers/net/ethernet/sfc/mcdi_pcol.h
+++ b/drivers/net/ethernet/sfc/mcdi_pcol.h
@@ -73,8 +73,8 @@
  *               \------------------------------ Resync (always set)
  *
  * The client writes it's request into MC shared memory, and rings the
- * doorbell. Each request is completed by either by the MC writting
- * back into shared memory, or by writting out an event.
+ * doorbell. Each request is completed by either by the MC writing
+ * back into shared memory, or by writing out an event.
  *
  * All MCDI commands support completion by shared memory response. Each
  * request may also contain additional data (accounted for by HEADER.LEN),
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index ce38f7515225..1b4c207afb66 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -157,7 +157,7 @@ struct tc35815_regs {
 #define PROM_Read	       0x00004000 /*10:Read operation		     */
 #define PROM_Write	       0x00002000 /*01:Write operation		     */
 #define PROM_Erase	       0x00006000 /*11:Erase operation		     */
-					  /*00:Enable or Disable Writting,   */
+					  /*00:Enable or Disable Writing,    */
 					  /*	  as specified in PROM_Addr. */
 #define PROM_Addr_Ena	       0x00000030 /*11xxxx:PROM Write enable	     */
 					  /*00xxxx:	      disable	     */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index eaba66113328..fbb4941d0da8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -520,7 +520,7 @@ static void _rtl92cu_init_queue_reserved_page(struct ieee80211_hw *hw,
 		 * 2 out-ep. Remainder pages have assigned to High queue */
 		if (outepnum > 1 && txqremaininpage)
 			numhq += txqremaininpage;
-		/* NOTE: This step done before writting REG_RQPN. */
+		/* NOTE: This step done before writing REG_RQPN. */
 		if (ischipn) {
 			if (queue_sel & TX_SELE_NQ)
 				numnq = txqpageunit;
@@ -539,7 +539,7 @@ static void _rtl92cu_init_queue_reserved_page(struct ieee80211_hw *hw,
 			numlq = ischipn ? WMM_CHIP_B_PAGE_NUM_LPQ :
 				WMM_CHIP_A_PAGE_NUM_LPQ;
 		}
-		/* NOTE: This step done before writting REG_RQPN. */
+		/* NOTE: This step done before writing REG_RQPN. */
 		if (ischipn) {
 			if (queue_sel & TX_SELE_NQ)
 				numnq = WMM_CHIP_B_PAGE_NUM_NPQ;
diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index e9f852f7c27f..b59b852a666f 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -122,7 +122,7 @@ static int lis3lv02d_acpi_read(struct lis3lv02d *lis3, int reg, u8 *ret)
 static int lis3lv02d_acpi_write(struct lis3lv02d *lis3, int reg, u8 val)
 {
 	struct acpi_device *dev = lis3->bus_priv;
-	unsigned long long ret; /* Not used when writting */
+	unsigned long long ret; /* Not used when writing */
 	union acpi_object in_obj[2];
 	struct acpi_object_list args = { 2, in_obj };
 
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 1250887e4382..a52a333de8e8 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -231,7 +231,7 @@ int sa1100_rtc_init(struct platform_device *pdev, struct sa1100_rtc *info)
 	 * initialization is unknown and could in principle happen during
 	 * normal processing.
 	 *
-	 * Notice that clearing bit 1 and 0 is accomplished by writting ONES to
+	 * Notice that clearing bit 1 and 0 is accomplished by writing ONES to
 	 * the corresponding bits in RTSR. */
 	writel_relaxed(RTSR_AL | RTSR_HZ, info->rtsr);
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index fd674ed1febe..d7f4680f6106 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -857,7 +857,7 @@ static void _pmcraid_fire_command(struct pmcraid_cmd *cmd)
 	unsigned long lock_flags;
 
 	/* Add this command block to pending cmd pool. We do this prior to
-	 * writting IOARCB to ioarrin because IOA might complete the command
+	 * writing IOARCB to ioarrin because IOA might complete the command
 	 * by the time we are about to add it to the list. Response handler
 	 * (isr/tasklet) looks for cmd block in the pending pending list.
 	 */
@@ -2450,7 +2450,7 @@ static void pmcraid_request_sense(struct pmcraid_cmd *cmd)
 
 	/* request sense might be called as part of error response processing
 	 * which runs in tasklets context. It is possible that mid-layer might
-	 * schedule queuecommand during this time, hence, writting to IOARRIN
+	 * schedule queuecommand during this time, hence, writing to IOARRIN
 	 * must be protect by host_lock
 	 */
 	pmcraid_send_cmd(cmd, pmcraid_erp_done,
-- 
2.25.1


