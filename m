Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D7B4DD331
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 03:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiCRCoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 22:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231874AbiCRCoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 22:44:21 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01429DA095
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 19:43:00 -0700 (PDT)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 369963F200
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 02:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647571377;
        bh=IsQNvnrYzFlByVho6HFj26Mu5PXAjpXD97Wru1aaDTM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Q/bTcGQrI2ntRSQUP5/O5IB6Pe8MaHpDYBytW0dEBlkf/hp7LbqZQgij08fbYjfDh
         IxJIN5iWSK4ux+eB2LNsIfITmqqQtuvjEdITpRv3R93Mtd7YXoiCoZqOGrEQRUZj26
         UF/JPAXIwdCsreXPTg9/KFbc9injf5kfzQyyEVAVU151q7s0Ks8Wy+lq7TZqCqPzfU
         4vQZoXtynO4Lz/VWdV+kRnjfapQq4c5zqLSWkT6DD/RvnXiwLrK0Fxki7ehcZgmT86
         YMM9Ndhfo/QZtazT4VOR4PvFRlKFvFI53ou4/+hKgP9tVdHfDqaceW8R1/pSMnrCKB
         szbgh9Z3Z3yKA==
Received: by mail-pl1-f198.google.com with SMTP id e13-20020a17090301cd00b00150145346f9so3431705plh.23
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 19:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IsQNvnrYzFlByVho6HFj26Mu5PXAjpXD97Wru1aaDTM=;
        b=uGGIV7Z3K4c1LqnEMSXyQ31cDHJwrncfFdjFFVO2n9TtNHUZu+RGZ6oR1niCtGtz2N
         ojjvt4kASHH9EoNxQmdznMfhFupjH+hNS7e5QvYu80v/ecu+/jQha2u03UTaI3lFLrfY
         N1M73q643frN9iRty5ZZhFuhDNqV3qNVOBz2vD9vyIdRqDXule/yibX6hc4Vnj5EQ5X/
         huLu08gL0wljBtYhXU8Hj2x1WnPqFR7V0FYySaezt9wZQGMVRyNw2Hi8fmtNBsKrOpq/
         eyIJi3ZtMVN436pyqLbp2IhkSeqIamSFanrcFAmz5zjBA8ge3lpLzsvGLKmPeJBFlkHH
         op0A==
X-Gm-Message-State: AOAM530WDilcM6Nqr5MR71crA8sqRQH/ZjWJQf2G7lS0KRWPprZnEGN9
        n9eZcfiVBFQeurOUXvDfUo1vTIYVcr7cBzKWvTGN5X3vtGD4eqFgdW2Ftqw7kg3idNO6iaNSr9E
        nYLq/+u/Mz8IKYE3fAEviMbSqla6Hh26R6g==
X-Received: by 2002:a17:902:be14:b0:14f:ce67:d0a1 with SMTP id r20-20020a170902be1400b0014fce67d0a1mr7647152pls.29.1647571375716;
        Thu, 17 Mar 2022 19:42:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWDlX7R0u3bbFhyd2lD9L026rsWS+K74zpJKVsaJKOqtXpz80a93XUCWWuMOjElFNq5i7sfw==
X-Received: by 2002:a17:902:be14:b0:14f:ce67:d0a1 with SMTP id r20-20020a170902be1400b0014fce67d0a1mr7647141pls.29.1647571375385;
        Thu, 17 Mar 2022 19:42:55 -0700 (PDT)
Received: from localhost.localdomain (2001-b400-e287-a413-5915-32ac-82c3-a966.emome-ip6.hinet.net. [2001:b400:e287:a413:5915:32ac:82c3:a966])
        by smtp.gmail.com with ESMTPSA id v16-20020a056a00149000b004f7ae2cbd3asm8191232pfu.166.2022.03.17.19.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 19:42:55 -0700 (PDT)
From:   Chris Chiu <chris.chiu@canonical.com>
To:     kvalo@kernel.org, Jes.Sorensen@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH v2 1/2] rtl8xxxu: feed antenna information for cfg80211
Date:   Fri, 18 Mar 2022 10:42:15 +0800
Message-Id: <20220318024216.42204-2-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220318024216.42204-1-chris.chiu@canonical.com>
References: <20220318024216.42204-1-chris.chiu@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fill up the available TX/RX antenna so the iw commands can show
correct antenna information for different chips.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 06d59ffb7444..d225a1257530 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1607,6 +1607,7 @@ static void rtl8xxxu_print_chipinfo(struct rtl8xxxu_priv *priv)
 static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
+	struct ieee80211_hw *hw = priv->hw;
 	u32 val32, bonding;
 	u16 val16;
 
@@ -1684,6 +1685,9 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		priv->has_wifi = 1;
 	}
 
+	hw->wiphy->available_antennas_tx = BIT(priv->tx_paths) - 1;
+	hw->wiphy->available_antennas_rx = BIT(priv->rx_paths) - 1;
+
 	switch (priv->rtl_chip) {
 	case RTL8188E:
 	case RTL8192E:
@@ -4282,6 +4286,17 @@ static void rtl8xxxu_cam_write(struct rtl8xxxu_priv *priv,
 	rtl8xxxu_debug = tmp_debug;
 }
 
+static
+int rtl8xxxu_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
+{
+	struct rtl8xxxu_priv *priv = hw->priv;
+
+	*tx_ant = BIT(priv->tx_paths) - 1;
+	*rx_ant = BIT(priv->rx_paths) - 1;
+
+	return 0;
+}
+
 static void rtl8xxxu_sw_scan_start(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif, const u8 *mac)
 {
@@ -6472,6 +6487,7 @@ static const struct ieee80211_ops rtl8xxxu_ops = {
 	.set_key = rtl8xxxu_set_key,
 	.ampdu_action = rtl8xxxu_ampdu_action,
 	.sta_statistics = rtl8xxxu_sta_statistics,
+	.get_antenna = rtl8xxxu_get_antenna,
 };
 
 static int rtl8xxxu_parse_usb(struct rtl8xxxu_priv *priv,
-- 
2.20.1

