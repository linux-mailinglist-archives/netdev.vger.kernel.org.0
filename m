Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78743688C87
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 02:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjBCBbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 20:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjBCBbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 20:31:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA4517CDE;
        Thu,  2 Feb 2023 17:31:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F6C561D4B;
        Fri,  3 Feb 2023 01:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012D4C433EF;
        Fri,  3 Feb 2023 01:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675387904;
        bh=eZBCsYxAQ094vxqAPJEUqjLU43I7FcP6zY0JCKarkuE=;
        h=Date:From:To:Cc:Subject:From;
        b=oC7z1ScizqDUHyy3rEK627uQ06kUzf54Qne6/BQlL8MrDUFE0a48l2HM2sJxPcYDp
         cwg1KiGlXzpszp1cCpj/oy3Wc2s6GeGnbuMZO9b7LsoQssYl2fGah6SWn6KigFMTr2
         EQV7r13blMHg2W+rAGWD5dGh0NXFG0xMG7s9HiAsRUiEi4FngEwD8inU6Gz4CiZugd
         r9fjxXdlIS/yt4PIAZV2lO4FX2NPP5F+9kU4aokKHdu1x+zSBlS+Ry3C3yiB/CHRsS
         NJdvOJqdQP+EbgSXLFhYI31SOxfO305Yh2mJPWsGko/ApBr6EH2VR2WB5Zcg3P140n
         Zm/DqVDEpg9UA==
Date:   Thu, 2 Feb 2023 19:32:00 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] wifi: mwifiex: Replace one-element arrays with
 flexible-array members
Message-ID: <Y9xkECG3uTZ6T1dN@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One-element arrays are deprecated, and we are replacing them with flexible
array members instead. So, replace one-element arrays with flexible-array
members in multiple structures.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

This results in no differences in binary output.

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/256
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/fw.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index b4f945a549f7..9616bd8b49f1 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -41,7 +41,7 @@ struct mwifiex_fw_header {
 struct mwifiex_fw_data {
 	struct mwifiex_fw_header header;
 	__le32 seq_num;
-	u8 data[1];
+	u8 data[];
 } __packed;
 
 struct mwifiex_fw_dump_header {
@@ -641,7 +641,7 @@ struct mwifiex_ie_types_header {
 
 struct mwifiex_ie_types_data {
 	struct mwifiex_ie_types_header header;
-	u8 data[1];
+	u8 data[];
 } __packed;
 
 #define MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET 0x01
@@ -799,7 +799,7 @@ struct mwifiex_ie_types_rates_param_set {
 
 struct mwifiex_ie_types_ssid_param_set {
 	struct mwifiex_ie_types_header header;
-	u8 ssid[1];
+	u8 ssid[];
 } __packed;
 
 struct mwifiex_ie_types_num_probes {
@@ -907,7 +907,7 @@ struct mwifiex_ie_types_tdls_idle_timeout {
 
 struct mwifiex_ie_types_rsn_param_set {
 	struct mwifiex_ie_types_header header;
-	u8 rsn_ie[1];
+	u8 rsn_ie[];
 } __packed;
 
 #define KEYPARAMSET_FIXED_LEN 6
@@ -1433,7 +1433,7 @@ struct mwifiex_tdls_stop_cs_params {
 
 struct host_cmd_ds_tdls_config {
 	__le16 tdls_action;
-	u8 tdls_data[1];
+	u8 tdls_data[];
 } __packed;
 
 struct mwifiex_chan_desc {
@@ -1574,13 +1574,13 @@ struct ie_body {
 struct host_cmd_ds_802_11_scan {
 	u8 bss_mode;
 	u8 bssid[ETH_ALEN];
-	u8 tlv_buffer[1];
+	u8 tlv_buffer[];
 } __packed;
 
 struct host_cmd_ds_802_11_scan_rsp {
 	__le16 bss_descript_size;
 	u8 number_of_sets;
-	u8 bss_desc_and_tlv_buffer[1];
+	u8 bss_desc_and_tlv_buffer[];
 } __packed;
 
 struct host_cmd_ds_802_11_scan_ext {
@@ -1596,7 +1596,7 @@ struct mwifiex_ie_types_bss_mode {
 struct mwifiex_ie_types_bss_scan_rsp {
 	struct mwifiex_ie_types_header header;
 	u8 bssid[ETH_ALEN];
-	u8 frame_body[1];
+	u8 frame_body[];
 } __packed;
 
 struct mwifiex_ie_types_bss_scan_info {
@@ -1733,7 +1733,7 @@ struct mwifiex_ie_types_local_pwr_constraint {
 
 struct mwifiex_ie_types_wmm_param_set {
 	struct mwifiex_ie_types_header header;
-	u8 wmm_ie[1];
+	u8 wmm_ie[];
 } __packed;
 
 struct mwifiex_ie_types_mgmt_frame {
@@ -1959,7 +1959,7 @@ struct host_cmd_tlv_wep_key {
 	struct mwifiex_ie_types_header header;
 	u8 key_index;
 	u8 is_default;
-	u8 key[1];
+	u8 key[];
 };
 
 struct host_cmd_tlv_auth_type {
-- 
2.34.1

