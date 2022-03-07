Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904684CFF50
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242658AbiCGNAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 08:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239429AbiCGNAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 08:00:12 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482DF66FB8
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 04:59:16 -0800 (PST)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 30A9F3F1C5
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646657955;
        bh=IsQNvnrYzFlByVho6HFj26Mu5PXAjpXD97Wru1aaDTM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=e4K3khZ0KvNIrWbfam7wS4gDxTYDdMafvGSrIJIL0MMLUl40U1eXpguFdbBKUJCt3
         C6BDr6SVqsApKBOEHNmeqzy/NDbzrxLCzLTd7PSeQUkSFpQK0wWHDUREX3OlLXlfVe
         IE96CfCQhLNdnJ0UF6c7AEdsKijMcfU5ESUNuOUyluRD+WYT0eCWWFgB2vy6U1RjWD
         Lzb21pSRUfqLyI4WMbAvGVE77G0GQSNTLx4RJLf97iSzUjZN4o+pPQZehByd2tCbOr
         Ygb8/w8rIs9vJ8UDzRiGSnyliX5lYjLOtfElo7hxcVk9q4WnQoxkpfu10gHfHa36Nd
         8q+QHLltKjs0Q==
Received: by mail-pj1-f72.google.com with SMTP id l14-20020a17090a660e00b001bf496be6d0so1501894pjj.7
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 04:59:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IsQNvnrYzFlByVho6HFj26Mu5PXAjpXD97Wru1aaDTM=;
        b=zk5wMqrx83dbW3pqqgWP1JCHqKLKOfXDgxVBa2ZYayWz/muMQGVr8Mg3EnPyW16UNz
         GbsbZr4U/cLHwb/ECD3i8Sih4Ys3aSTzpuHELoMjP1TgepkrVacV4U2QLgWNnR4dXxvk
         H+oFk5JFWqsMHDZwufJMoKaLG0VkD72OklNSt4nL/bTY6oCjExqIjWIiyRwXSdOsHBbc
         n6+UrbGmPcC5rDSnniFcuc8rUcBE8SuZgCLwpX5sdPURXHGUfFbskbocXrb7i6GWUDYI
         z+8cgxETt3uUbRYZVR7fF8mcwpFq3NMcbSNBCrKAGJdZPefIVN/ebfSx8bKn35wYQRoj
         r2XQ==
X-Gm-Message-State: AOAM530yNbnSCIx8/klL8Zo/0sd96aA7gV2DIYvKq5G8VITH8lmy1HW4
        FPIR6SryfSNxexjVDq3f3xkrDJCCOLVX7Wv72USTmvyumgUEHnKucNa6kw2L5h74yuqzfUVsFto
        l9pUZYAM9GB0t3eZ8NF9zW7HLt1AUnaB/lg==
X-Received: by 2002:a17:90a:19d5:b0:1bc:a5db:b655 with SMTP id 21-20020a17090a19d500b001bca5dbb655mr25236426pjj.46.1646657953399;
        Mon, 07 Mar 2022 04:59:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeisv63taSGAcKFYoPo3kwY7DTxoY58lBoTyjbrXxgaD5HZdiVOhc/XjBuDTTsNSX4B/Rprg==
X-Received: by 2002:a17:90a:19d5:b0:1bc:a5db:b655 with SMTP id 21-20020a17090a19d500b001bca5dbb655mr25236399pjj.46.1646657953083;
        Mon, 07 Mar 2022 04:59:13 -0800 (PST)
Received: from localhost.localdomain (59-115-216-226.dynamic-ip.hinet.net. [59.115.216.226])
        by smtp.gmail.com with ESMTPSA id oj2-20020a17090b4d8200b001bef79ea006sm17545682pjb.29.2022.03.07.04.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 04:59:12 -0800 (PST)
From:   Chris Chiu <chris.chiu@canonical.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH 1/2] rtl8xxxu: feed antenna information for cfg80211
Date:   Mon,  7 Mar 2022 20:58:51 +0800
Message-Id: <20220307125852.13606-2-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220307125852.13606-1-chris.chiu@canonical.com>
References: <20220307125852.13606-1-chris.chiu@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

