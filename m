Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD201618861
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 20:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiKCTPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 15:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKCTPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 15:15:01 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305251C417;
        Thu,  3 Nov 2022 12:14:59 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id b2so4459495lfp.6;
        Thu, 03 Nov 2022 12:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0eGNApoF2VicVxV8ehQucDXPmn+EAulQM0sJ4uaThJ8=;
        b=c50WPNtu7Fr07JXcm5DwN6eH4UAxiY/DDz4w7fLQBUuWKDD0wosguqacQkfh+Jj2qR
         birQ4H1gAYKqy7XbtRxmnHh94/FcF2XJJ5iVJFNVT9UQWOqX6eBxsoCZAPhH/iu46nCF
         YstbxeMPvNJRRRprJQ5fkeRuIK5wQu4ZX4GteENCwX9Z7pHamLlUmGgDDvs3Mj0WAxSh
         /YRscwbY1c1xYCWOXh/VuTPJ8PKENLvEZMfCViaob/O8gZaS0dHeLrhNDF2iMg4FU8vw
         wvhZDNmhQhhUtKwRkBQDqhR1fllTpuJQGSVZrfsRXqg6E1N6Dype547UVkTLUGmeYzdn
         4CZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0eGNApoF2VicVxV8ehQucDXPmn+EAulQM0sJ4uaThJ8=;
        b=zCmWnGw/huVpF8Gs6Vh3jIgtI8BJx/95DBsRTS6JenCHBPbw9ZM3aH3kDLb45Oge81
         25wTSWO/VLbPKnbORZz77Hgwr2iZGohN3kM27t+O3Vhrg7b3XYh41L5h6ikwOMpxT9Mj
         ss16/ptgnkAhjG+QhFq+QLBYC6EUz6otd4U3nY/H4ZG4q38ZmWyST0mx9zR/kMSK+LW5
         dhdx94NmANVeTJzLqIcGSCaoNfhtquXRAMrPuqlx8nF4i+LVRXyJHMGH3r+wEgh8UVcn
         YAr+NLArgqOU1t5x0sQDgFHp1MrxqA0w2yEyU37Sb2Jby+OVNXowV4xCqcSn6avEaQSs
         Tc8g==
X-Gm-Message-State: ACrzQf1lFDC0PaBPJMJ3zxLaMoW+IgjOpJHjB9eYDQW+PuIxYeFOp8wE
        pVR82Pzs9vTbihdxm61mqi4=
X-Google-Smtp-Source: AMsMyM5sCd4Zv2qWsNDMbzQdtistRQghBom5eWauECfSrwSuR395X+qAiHE4GMAYmlGxs+avqiHYtQ==
X-Received: by 2002:a05:6512:2350:b0:4a2:4523:cd08 with SMTP id p16-20020a056512235000b004a24523cd08mr13405485lfu.231.1667502897223;
        Thu, 03 Nov 2022 12:14:57 -0700 (PDT)
Received: from firefly (c188-150-77-196.bredband.tele2.se. [188.150.77.196])
        by smtp.gmail.com with ESMTPSA id w16-20020a2e9990000000b0026dffa29989sm201918lji.23.2022.11.03.12.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 12:14:56 -0700 (PDT)
Date:   Thu, 3 Nov 2022 20:14:54 +0100
From:   Linus Probert <linus.probert@gmail.com>
To:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] iwlwifi: fix style warnings in iwl-drv.c
Message-ID: <Y2QTLgWVO2sZMnOb@firefly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running checkpatch on iwl-drv.c produced a series of minor style
warnings. Most of them have been removed. There are some remaining
regarding multiple lines of quoted strings as well as some warnings
where the suggested fix produces a new warning.

Signed-off-by: Linus Probert <linus.probert@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 94 +++++++++-----------
 1 file changed, 42 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index a2203f661321..5bf8b813ad5a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -89,8 +89,7 @@ static struct iwlwifi_opmode_table {
 
 #define IWL_DEFAULT_SCAN_CHANNELS 40
 
-/*
- * struct fw_sec: Just for the image parsing process.
+/* struct fw_sec: Just for the image parsing process.
  * For the fw storage we are using struct fw_desc.
  */
 struct fw_sec {
@@ -109,6 +108,7 @@ static void iwl_free_fw_desc(struct iwl_drv *drv, struct fw_desc *desc)
 static void iwl_free_fw_img(struct iwl_drv *drv, struct fw_img *img)
 {
 	int i;
+
 	for (i = 0; i < img->num_sec; i++)
 		iwl_free_fw_desc(drv, &img->sec[i]);
 	kfree(img->sec);
@@ -216,8 +216,7 @@ struct fw_img_parsing {
 	int sec_counter;
 };
 
-/*
- * struct fw_sec_parsing: to extract fw section and it's offset from tlv
+/* struct fw_sec_parsing: to extract fw section and it's offset from tlv
  */
 struct fw_sec_parsing {
 	__le32 offset;
@@ -256,8 +255,7 @@ struct iwl_firmware_pieces {
 	size_t n_mem_tlv;
 };
 
-/*
- * These functions are just to extract uCode section data from the pieces
+/* These functions are just to extract uCode section data from the pieces
  * structure.
  */
 static struct fw_sec *get_sec(struct iwl_firmware_pieces *pieces,
@@ -324,8 +322,7 @@ static void set_sec_offset(struct iwl_firmware_pieces *pieces,
 	pieces->img[type].sec[sec].offset = offset;
 }
 
-/*
- * Gets uCode section from tlv.
+/* Gets uCode section from tlv.
  */
 static int iwl_store_ucode_sec(struct iwl_firmware_pieces *pieces,
 			       const void *data, enum iwl_ucode_type type,
@@ -365,6 +362,7 @@ static int iwl_set_default_calib(struct iwl_drv *drv, const u8 *data)
 	const struct iwl_tlv_calib_data *def_calib =
 					(const struct iwl_tlv_calib_data *)data;
 	u32 ucode_type = le32_to_cpu(def_calib->ucode_type);
+
 	if (ucode_type >= IWL_UCODE_TYPE_MAX) {
 		IWL_ERR(drv, "Wrong ucode_type %u for default calibration.\n",
 			ucode_type);
@@ -502,14 +500,12 @@ static int iwl_parse_v1_v2_firmware(struct iwl_drv *drv,
 	    get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA) +
 	    get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) +
 	    get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA)) {
-
 		IWL_ERR(drv,
 			"uCode file size %d does not match expected size\n",
 			(int)ucode_raw->size);
 		return -EINVAL;
 	}
 
-
 	set_sec_data(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST, src);
 	src += get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST);
 	set_sec_offset(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST,
@@ -627,10 +623,10 @@ static void iwl_parse_dbg_tlv_assert_tables(struct iwl_drv *drv,
 }
 
 static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
-				const struct firmware *ucode_raw,
-				struct iwl_firmware_pieces *pieces,
-				struct iwl_ucode_capabilities *capa,
-				bool *usniffer_images)
+				  const struct firmware *ucode_raw,
+				  struct iwl_firmware_pieces *pieces,
+				  struct iwl_ucode_capabilities *capa,
+				  bool *usniffer_images)
 {
 	const struct iwl_tlv_ucode_header *ucode = (const void *)ucode_raw->data;
 	const struct iwl_ucode_tlv *tlv;
@@ -753,8 +749,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			/* and a proper number of u32s */
 			if (tlv_len % sizeof(u32))
 				goto invalid_tlv_len;
-			/*
-			 * This driver only reads the first u32 as
+			/* This driver only reads the first u32 as
 			 * right now no more features are defined,
 			 * if that changes then either the driver
 			 * will not work with the new firmware, or
@@ -1290,15 +1285,15 @@ static int validate_sec_sizes(struct iwl_drv *drv,
 			      const struct iwl_cfg *cfg)
 {
 	IWL_DEBUG_INFO(drv, "f/w package hdr runtime inst size = %zd\n",
-		get_sec_size(pieces, IWL_UCODE_REGULAR,
-			     IWL_UCODE_SECTION_INST));
+		       get_sec_size(pieces, IWL_UCODE_REGULAR,
+				    IWL_UCODE_SECTION_INST));
 	IWL_DEBUG_INFO(drv, "f/w package hdr runtime data size = %zd\n",
-		get_sec_size(pieces, IWL_UCODE_REGULAR,
-			     IWL_UCODE_SECTION_DATA));
+		       get_sec_size(pieces, IWL_UCODE_REGULAR,
+				    IWL_UCODE_SECTION_DATA));
 	IWL_DEBUG_INFO(drv, "f/w package hdr init inst size = %zd\n",
-		get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST));
+		       get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST));
 	IWL_DEBUG_INFO(drv, "f/w package hdr init data size = %zd\n",
-		get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA));
+		       get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA));
 
 	/* Verify that uCode images will fit in card's SRAM. */
 	if (get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST) >
@@ -1344,7 +1339,6 @@ _iwl_op_mode_start(struct iwl_drv *drv, struct iwlwifi_opmode_table *op)
 	int retry, max_retry = !!iwlwifi_mod_params.fw_restart * IWL_MAX_INIT_RETRY;
 
 	for (retry = 0; retry <= max_retry; retry++) {
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		drv->dbgfs_op_mode = debugfs_create_dir(op->name,
 							drv->dbgfs_drv);
@@ -1382,8 +1376,7 @@ static void _iwl_op_mode_stop(struct iwl_drv *drv)
 	}
 }
 
-/*
- * iwl_req_fw_callback - callback when firmware was loaded
+/* iwl_req_fw_callback - callback when firmware was loaded
  *
  * If loaded successfully, copies the firmware into buffers
  * for the card to fetch (via DMA).
@@ -1446,8 +1439,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	else
 		api_ver = IWL_UCODE_API(drv->fw.ucode_ver);
 
-	/*
-	 * api_ver should match the api version forming part of the
+	/* api_ver should match the api version forming part of the
 	 * firmware filename ... but we don't check for that and only rely
 	 * on the API version read from firmware header from here on forward
 	 */
@@ -1459,8 +1451,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		goto try_again;
 	}
 
-	/*
-	 * In mvm uCode there is no difference between data and instructions
+	/* In mvm uCode there is no difference between data and instructions
 	 * sections.
 	 */
 	if (fw->type == IWL_FW_DVM && validate_sec_sizes(drv, pieces,
@@ -1517,7 +1508,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 			 * end shift. We now store these values in base_reg,
 			 * and end shift, and when dumping the data we'll
 			 * manipulate it for extracting both the length and
-			 * base address */
+			 * base address
+			 */
 			dest_tlv->base_reg = pieces->dbg_dest_tlv->cfg_reg;
 			dest_tlv->end_shift =
 				pieces->dbg_dest_tlv->size_shift;
@@ -1559,8 +1551,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 
 	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg.trigger_tlv); i++) {
 		if (pieces->dbg_trigger_tlv[i]) {
-			/*
-			 * If the trigger isn't long enough, WARN and exit.
+			/* If the trigger isn't long enough, WARN and exit.
 			 * Someone is trying to debug something and he won't
 			 * be able to catch the bug he is trying to chase.
 			 * We'd better be noisy to be sure he knows what's
@@ -1587,28 +1578,26 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	pieces->dbg_mem_tlv = NULL;
 	drv->fw.dbg.n_mem_tlv = pieces->n_mem_tlv;
 
-	/*
-	 * The (size - 16) / 12 formula is based on the information recorded
+	/* The (size - 16) / 12 formula is based on the information recorded
 	 * for each event, which is of mode 1 (including timestamp) for all
 	 * new microcodes that include this information.
 	 */
 	fw->init_evtlog_ptr = pieces->init_evtlog_ptr;
 	if (pieces->init_evtlog_size)
-		fw->init_evtlog_size = (pieces->init_evtlog_size - 16)/12;
+		fw->init_evtlog_size = (pieces->init_evtlog_size - 16) / 12;
 	else
 		fw->init_evtlog_size =
 			drv->trans->trans_cfg->base_params->max_event_log_size;
 	fw->init_errlog_ptr = pieces->init_errlog_ptr;
 	fw->inst_evtlog_ptr = pieces->inst_evtlog_ptr;
 	if (pieces->inst_evtlog_size)
-		fw->inst_evtlog_size = (pieces->inst_evtlog_size - 16)/12;
+		fw->inst_evtlog_size = (pieces->inst_evtlog_size - 16) / 12;
 	else
 		fw->inst_evtlog_size =
 			drv->trans->trans_cfg->base_params->max_event_log_size;
 	fw->inst_errlog_ptr = pieces->inst_errlog_ptr;
 
-	/*
-	 * figure out the offset of chain noise reset and gain commands
+	/* figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
 	 */
 	if (fw->ucode_capa.standard_phy_calibration_size >
@@ -1652,15 +1641,13 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	}
 	mutex_unlock(&iwlwifi_opmode_table_mtx);
 
-	/*
-	 * Complete the firmware request last so that
+	/* Complete the firmware request last so that
 	 * a driver unbind (stop) doesn't run while we
 	 * are doing the start() above.
 	 */
 	complete(&drv->request_firmware_complete);
 
-	/*
-	 * Load the module last so we don't block anything
+	/* Load the module last so we don't block anything
 	 * else from proceeding if the module fails to load
 	 * or hangs loading.
 	 */
@@ -1750,8 +1737,7 @@ void iwl_drv_stop(struct iwl_drv *drv)
 	iwl_dealloc_ucode(drv);
 
 	mutex_lock(&iwlwifi_opmode_table_mtx);
-	/*
-	 * List is empty (this item wasn't added)
+	/* List is empty (this item wasn't added)
 	 * when firmware loading failed -- in that
 	 * case we can't remove it from any list.
 	 */
@@ -1855,6 +1841,7 @@ static int __init iwl_drv_init(void)
 #endif
 	return err;
 }
+
 module_init(iwl_drv_init);
 
 static void __exit iwl_drv_exit(void)
@@ -1865,6 +1852,7 @@ static void __exit iwl_drv_exit(void)
 	debugfs_remove_recursive(iwl_dbgfs_root);
 #endif
 }
+
 module_exit(iwl_drv_exit);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -1876,7 +1864,8 @@ module_param_named(swcrypto, iwlwifi_mod_params.swcrypto, int, 0444);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, 0444);
 MODULE_PARM_DESC(11n_disable,
-	"disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX");
+		 "disable 11n functionality, bitmap: 1: full,"
+		 "2: disable agg TX, 4: disable agg RX, 8 enable agg TX");
 module_param_named(amsdu_size, iwlwifi_mod_params.amsdu_size, int, 0444);
 MODULE_PARM_DESC(amsdu_size,
 		 "amsdu size 0: 12K for multi Rx queue devices, 2K for AX210 devices, "
@@ -1901,7 +1890,8 @@ static int enable_ini_set(const char *arg, const struct kernel_param *kp)
 	ret = kstrtou32(arg, 0, &new_enable_ini);
 	if (!ret) {
 		if (new_enable_ini > ENABLE_INI) {
-			pr_err("enable_ini cannot be %d, in range 0-16\n", new_enable_ini);
+			pr_err("enable_ini cannot be %d, in range 0-16\n",
+			       new_enable_ini);
 			return -EINVAL;
 		}
 		goto out;
@@ -1922,13 +1912,14 @@ static const struct kernel_param_ops enable_ini_ops = {
 	.set = enable_ini_set
 };
 
-module_param_cb(enable_ini, &enable_ini_ops, &iwlwifi_mod_params.enable_ini, 0644);
+module_param_cb(enable_ini, &enable_ini_ops,
+		&iwlwifi_mod_params.enable_ini, 0644);
 MODULE_PARM_DESC(enable_ini,
-		 "0:disable, 1-15:FW_DBG_PRESET Values, 16:enabled without preset value defined,"
+		 "0:disable, 1-15:FW_DBG_PRESET Values,"
+		 "16:enabled without preset value defined,"
 		 "Debug INI TLV FW debug infrastructure (default: 16)");
 
-/*
- * set bt_coex_active to true, uCode will do kill/defer
+/* set bt_coex_active to true, uCode will do kill/defer
  * every time the priority line is asserted (BT is sending signals on the
  * priority line in the PCIx).
  * set bt_coex_active to false, uCode will ignore the BT activity and
@@ -1968,6 +1959,5 @@ module_param_named(remove_when_gone,
 MODULE_PARM_DESC(remove_when_gone,
 		 "Remove dev from PCIe bus if it is deemed inaccessible (default: false)");
 
-module_param_named(disable_11ax, iwlwifi_mod_params.disable_11ax, bool,
-		   S_IRUGO);
+module_param_named(disable_11ax, iwlwifi_mod_params.disable_11ax, bool, 0444);
 MODULE_PARM_DESC(disable_11ax, "Disable HE capabilities (default: false)");
-- 
2.38.1

