Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B324653FE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351911AbhLARgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351898AbhLARgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:36:04 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E69C06175E
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 09:32:42 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id s37so14662665pga.9
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 09:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FzyE9HFngcWzXGJ+JVnIrmxG1xx/EuzgUUTbOa+7gYU=;
        b=lQRoGsMb8BnKx/YWkYkML4540gVv9fz6kmXXHWXRgVHR1T7lPDpydrc52ygvnu27cw
         Nf8oTR/7J0J3QoAKEH+NZZS7HfZqcW3ypo72iyn7g2Ye/tjnp9xEGdmMfZogcpq5E5f5
         DNSRmv5MdgAV+Jc6cAWNQgtYpHYX789vOupvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FzyE9HFngcWzXGJ+JVnIrmxG1xx/EuzgUUTbOa+7gYU=;
        b=PnJr1pZK4H/K8KtQOdpC+sCtCJMyqZiSdf/6KvoVVA+kWWIRsw9AN58tAtMhbwOgdI
         Yj1IqeK897yjyWRqqtfiX+6Aj89zK/rzWsHxSvFVqIObiGuXrhDa6lg2IZAx1ebHhkFr
         w6NKRnzOCL78//0/WxtPB4Zsbq2TGqV/2aMT8YceV1EiRqii7tbzsJaRg7D2NwCG4+0g
         aZdyHhViohJFzN+g/k6aNbcKvjzTqPPGTC8A05dM0aoI52jZzt/kEkv5i+zDrE79z0eg
         9gAO4iDfgDnyQW6u6ka2DjMfCyLsLBL0f23gX9Nop7SEoZbfI02obS3BuIJyxNgljiJi
         Ceqw==
X-Gm-Message-State: AOAM531OUSyhbObn+pwJE3foqhYluCsL7W6SOg42lcNiWbod+XjQvWAa
        9XMoNXKW87MG43Du3Jn3Cojbdw==
X-Google-Smtp-Source: ABdhPJz4A7LJfnLMUj+4iQ5zPOYMTFU15+euUd/GNHT0BiCxqBmAqWC7rBjUyX3tUTSrXDeVa46wbw==
X-Received: by 2002:aa7:8883:0:b0:49f:f87a:95de with SMTP id z3-20020aa78883000000b0049ff87a95demr7319034pfe.53.1638379962272;
        Wed, 01 Dec 2021 09:32:42 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ml24sm191408pjb.16.2021.12.01.09.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:32:41 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Carlos Cobo <luisca@cozybit.com>,
        linux-kernel@vger.kernel.org, libertas-dev@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH 2/2] libertas_tf: Add missing __packed annotations
Date:   Wed,  1 Dec 2021 09:32:34 -0800
Message-Id: <20211201173234.578124-3-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201173234.578124-1-keescook@chromium.org>
References: <20211201173234.578124-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3543; h=from:subject; bh=2tGVFx8Insnm3c0UY7JXrxmXYfUn1BDPwA2uzEQkk94=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhp7Gy5qOMgVEOvMQuG8T64wdYryY5VwpNynjJn43H kbDhSn6JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYaexsgAKCRCJcvTf3G3AJsHwD/ 990Bey9pUtkfjcJomJzp7SfME2jkcVLPDwof+Fbu4OLxOC7pAz2sbGTNpVHkwA/cxz9lwMtPi0akGt QUtMW6QlZJAkiIijvHETej7YIAXMK7XEg5TefmjCUWypw5qVJBrY1BxcL6rlpTUAs8hVfTGHqLGxTq 4BNpysfs5kgjAt4v16mRj42S6SMU11tzNUVVPKVy1iv8LzV02nXfAyIIfHUpjgnQRUGUMJKSi95QPN W/3v0W4vL/95UQA9OPtTkMpXx/5ZGsQ4SJCB4EGPiYMX0aZCdyNM7OWCQnHNKnypP1VrAmHuiYdJze M7I7Q+VQD+rVVaj9DVlL/V/lJdI456tCcVj4ejFEm4LsybKoBtGFMPJo9YOFOu+Mfz8yjmUhYB07+/ xoDAwiQrrsezUhMy+ccbCI6LxlkX3PF9Nfl5xAFW8HAW0YZ3l5HrOg2dnn6+gJskYsHm5Ztd6b/bYy kU5Gl4eJDn9sq1KX3R4U04szWwKlQVqXzaSPP4T4gBaxrtNDsrYLXefofk7E40KJ990RxiThbr4eqx XllVocubnCL1WvKVS4AHGxmQOlK77yqLqJq9ZqdXYtC4biuL5J0v7QYNBzx7VgiSuTth2M+0RZCgK4 J2uUY2bpEPIe45yBdmyhKNG5ZeuN4bdiDPPNTAW0AVji1AWuH83q2Dp2Z5DA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The earlier __packed annotations added in commit d71038c05970 ("libertas:
Fix alignment issues in libertas core") were not duplicated when
libertas_af was added in commit 7670e62c7ed6 ("libertas_tf: header file"),
even though they share several structure definitions. Add the missing
annotations which commit 642a57475b30 ("libertas_tf: Use struct_group()
for memcpy() region") exposed. Quoting the prior libertas fix: "Data
structures that come over the wire from the WLAN firmware must be
packed."

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-mm/202111302102.apaePz2J-lkp@intel.com
Fixes: 642a57475b30 ("libertas_tf: Use struct_group() for memcpy() region")
Fixes: 7670e62c7ed6 ("libertas_tf: header file")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../marvell/libertas_tf/libertas_tf.h         | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h b/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
index b2af2ddb6bc4..631b5da09f86 100644
--- a/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
+++ b/drivers/net/wireless/marvell/libertas_tf/libertas_tf.h
@@ -268,7 +268,7 @@ struct txpd {
 	__le32 tx_packet_location;
 	/* Tx packet length */
 	__le16 tx_packet_length;
-	struct_group(tx_dest_addr,
+	struct_group_attr(tx_dest_addr, __packed,
 		/* First 2 byte of destination MAC address */
 		u8 tx_dest_addr_high[2];
 		/* Last 4 byte of destination MAC address */
@@ -282,7 +282,7 @@ struct txpd {
 	u8 pktdelay_2ms;
 	/* reserved */
 	u8 reserved1;
-};
+} __packed;
 
 /* RxPD Descriptor */
 struct rxpd {
@@ -313,7 +313,7 @@ struct rxpd {
 	/* Pkt Priority */
 	u8 priority;
 	u8 reserved[3];
-};
+} __packed;
 
 struct cmd_header {
 	__le16 command;
@@ -379,14 +379,14 @@ struct cmd_ds_mac_control {
 	struct cmd_header hdr;
 	__le16 action;
 	u16 reserved;
-};
+} __packed;
 
 struct cmd_ds_802_11_mac_address {
 	struct cmd_header hdr;
 
 	__le16 action;
 	uint8_t macadd[ETH_ALEN];
-};
+} __packed;
 
 struct cmd_ds_mac_multicast_addr {
 	struct cmd_header hdr;
@@ -394,27 +394,27 @@ struct cmd_ds_mac_multicast_addr {
 	__le16 action;
 	__le16 nr_of_adrs;
 	u8 maclist[ETH_ALEN * MRVDRV_MAX_MULTICAST_LIST_SIZE];
-};
+} __packed;
 
 struct cmd_ds_set_mode {
 	struct cmd_header hdr;
 
 	__le16 mode;
-};
+} __packed;
 
 struct cmd_ds_set_bssid {
 	struct cmd_header hdr;
 
 	u8 bssid[6];
 	u8 activate;
-};
+} __packed;
 
 struct cmd_ds_802_11_radio_control {
 	struct cmd_header hdr;
 
 	__le16 action;
 	__le16 control;
-};
+} __packed;
 
 
 struct cmd_ds_802_11_rf_channel {
@@ -425,20 +425,20 @@ struct cmd_ds_802_11_rf_channel {
 	__le16 rftype;      /* unused */
 	__le16 reserved;    /* unused */
 	u8 channellist[32]; /* unused */
-};
+} __packed;
 
 struct cmd_ds_set_boot2_ver {
 	struct cmd_header hdr;
 
 	__le16 action;
 	__le16 version;
-};
+} __packed;
 
 struct cmd_ds_802_11_reset {
 	struct cmd_header hdr;
 
 	__le16 action;
-};
+} __packed;
 
 struct cmd_ds_802_11_beacon_control {
 	struct cmd_header hdr;
@@ -446,14 +446,14 @@ struct cmd_ds_802_11_beacon_control {
 	__le16 action;
 	__le16 beacon_enable;
 	__le16 beacon_period;
-};
+} __packed;
 
 struct cmd_ds_802_11_beacon_set {
 	struct cmd_header hdr;
 
 	__le16 len;
 	u8 beacon[MRVL_MAX_BCN_SIZE];
-};
+} __packed;
 
 struct cmd_ctrl_node;
 
-- 
2.30.2

