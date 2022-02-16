Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC524B9176
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbiBPTlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:41:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbiBPTle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:41:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D165D2B048B;
        Wed, 16 Feb 2022 11:41:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1647DCE2897;
        Wed, 16 Feb 2022 19:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAECC004E1;
        Wed, 16 Feb 2022 19:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040477;
        bh=YLTs1rxYD+NDyL44mfSduov49e8DI5HZxAayg3QvMQE=;
        h=Date:From:To:Cc:Subject:From;
        b=BfmlLU7WP1j9u4nkIoK+Cz8eLt0BN3rZ1mB/S8Pn2li/IRyue6qYNLm+rRFuZgfo0
         LkUP02ymVqyLKEyHU682FtgKb3qzDEZ5yT6VGOpytmbmwPTEeZDbWZ+/WeVUBpvdQU
         xz3CvsqrF2CT8bN27wdWF5/5HSfoGIHCEFDfZheUqQY/2DFgYFPl/jODhAA8nGlsAB
         NqiFwGSO+bJMy6+KXD4G4sFx1c8nfzC9HGPMrGRvE4t0SzJVt1dlgZaEOiA1iAokMf
         Z4Jmfuny+mPk3ymzZEOEpc/WHIW8HCznVwPAmFUuTV7XGQtQcuApIHqlpPast1slnf
         1vTlM7Mivxgxg==
Date:   Wed, 16 Feb 2022 13:48:57 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ath6kl: Replace zero-length arrays with flexible-array
 members
Message-ID: <20220216194857.GA904059@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members”[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 784940ba4c90..8535784af513 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1637,7 +1637,7 @@ struct bss_bias {
 
 struct bss_bias_info {
 	u8 num_bss;
-	struct bss_bias bss_bias[0];
+	struct bss_bias bss_bias[];
 } __packed;
 
 struct low_rssi_scan_params {
@@ -1720,7 +1720,7 @@ struct wmi_neighbor_info {
 
 struct wmi_neighbor_report_event {
 	u8 num_neighbors;
-	struct wmi_neighbor_info neighbor[0];
+	struct wmi_neighbor_info neighbor[];
 } __packed;
 
 /* TKIP MIC Error Event */
@@ -2051,7 +2051,7 @@ struct wmi_get_keepalive_cmd {
 struct wmi_set_appie_cmd {
 	u8 mgmt_frm_type; /* enum wmi_mgmt_frame_type */
 	u8 ie_len;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 struct wmi_set_ie_cmd {
@@ -2059,7 +2059,7 @@ struct wmi_set_ie_cmd {
 	u8 ie_field;	/* enum wmi_ie_field_type */
 	u8 ie_len;
 	u8 reserved;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* Notify the WSC registration status to the target */
@@ -2127,7 +2127,7 @@ struct wmi_add_wow_pattern_cmd {
 	u8 filter_list_id;
 	u8 filter_size;
 	u8 filter_offset;
-	u8 filter[0];
+	u8 filter[];
 } __packed;
 
 struct wmi_del_wow_pattern_cmd {
@@ -2360,7 +2360,7 @@ struct wmi_send_action_cmd {
 	__le32 freq;
 	__le32 wait;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_send_mgmt_cmd {
@@ -2369,7 +2369,7 @@ struct wmi_send_mgmt_cmd {
 	__le32 wait;
 	__le32 no_cck;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_tx_status_event {
@@ -2389,7 +2389,7 @@ struct wmi_set_appie_extended_cmd {
 	u8 role_id;
 	u8 mgmt_frm_type;
 	u8 ie_len;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 struct wmi_remain_on_chnl_event {
@@ -2406,18 +2406,18 @@ struct wmi_cancel_remain_on_chnl_event {
 struct wmi_rx_action_event {
 	__le32 freq;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_p2p_capabilities_event {
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_p2p_rx_probe_req_event {
 	__le32 freq;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define P2P_FLAG_CAPABILITIES_REQ   (0x00000001)
@@ -2431,7 +2431,7 @@ struct wmi_get_p2p_info {
 struct wmi_p2p_info_event {
 	__le32 info_req_flags;
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_p2p_capabilities {
@@ -2450,7 +2450,7 @@ struct wmi_p2p_probe_response_cmd {
 	__le32 freq;
 	u8 destination_addr[ETH_ALEN];
 	__le16 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /* Extended WMI (WMIX)
-- 
2.27.0

