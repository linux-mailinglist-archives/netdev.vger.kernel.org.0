Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE31C468A49
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 10:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhLEKCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 05:02:15 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:44398
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232779AbhLEKCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 05:02:15 -0500
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F0B0740013
        for <netdev@vger.kernel.org>; Sun,  5 Dec 2021 09:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1638698325;
        bh=w6+BoYvnmAnd+GSm1CSG2oy2MCenL4FLdq4APeVFVSU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=YirH2heYguefpEbbKOSS7mRhsNhyxQaZmnwNUITgmKDkeVdBto3C9+1hlcAabfmyr
         nqLsHGruIZ952H9mE3t1eIE2gXi6AVmsxqqk4syJmBwsbv/I54f96IjjHeduMV65E+
         pwhLG/31g89jd3K0J5j46zwjfRqhN2ru4f25xkW1q6mpU19O5PXmbTDE2K8L7mIWvg
         ihE561bLNaN8FLMPzhFhMCilDli1xSia6uaf7fzpFgToFH3RbVmZMV1KXhWXmpJUqp
         MObMlbuXenTERKfVrxGjM+sTThMoULegZb5WvCjjRTBQCT+y/oCsHPR+AskxNiZQcT
         kwiK2c8G6yRIg==
Received: by mail-pf1-f198.google.com with SMTP id i26-20020aa7909a000000b004a4c417bfa8so4747648pfa.23
        for <netdev@vger.kernel.org>; Sun, 05 Dec 2021 01:58:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w6+BoYvnmAnd+GSm1CSG2oy2MCenL4FLdq4APeVFVSU=;
        b=Z0jS7n5Nd5E82c4oA3lS/ME7nxWUpuw6MmqKEhhjU5z99gquymx6qgFNTmfbP9dhpV
         FaaCvICKeQ7rBZsu2rFOkDBbUcJeqGHidZ4gtzIzYGj2lQF0Hwet0NUa5Y1uHOCWIZcQ
         TiGRJwTfkmgOxd2L1jElk6/b9Yo/v+kCxbJpfnyB8B83pp9Fn8PsyRl5Y2l+ncAoxogm
         jPce9OpDlioBCmaHORAlDCGYbdiwaOqeX1qHUOWNy7YqbpzU7pKVpknJ4Iphu3KDdFUg
         B3D0muZ5SLxulhQn/8MKeNeJtq/GNNgNE/ykNl2aMh6ADoDzpPGi05BtLh8pbmnh1PMU
         RWXQ==
X-Gm-Message-State: AOAM531lCb6BJtJxyTQCEfrn5cIPLDWRR3avqzZSgJ7uUbXeWqOO9pvy
        M3f7DRKDZDToZKYNT3ow2CJqHjP4Lq6sF0DVis0otohnaHPdT/xsS/kbwjMYqrV5tzOqMgYKMNg
        hXszL54TaTvZnUsENHeHSIhKEXGhf6ndBMw==
X-Received: by 2002:a17:90b:2309:: with SMTP id mt9mr28922900pjb.213.1638698324297;
        Sun, 05 Dec 2021 01:58:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxrc9ZXCA/OWrksKqJj/Yc/lW+qDW0JLGL6vWbPZBjDotrMYhiJGa9oqA+YnQYbTSwbJxyfPg==
X-Received: by 2002:a17:90b:2309:: with SMTP id mt9mr28922872pjb.213.1638698323970;
        Sun, 05 Dec 2021 01:58:43 -0800 (PST)
Received: from localhost.localdomain (2001-b011-3814-fb66-6609-6116-8fb8-c749.dynamic-ip6.hinet.net. [2001:b011:3814:fb66:6609:6116:8fb8:c749])
        by smtp.gmail.com with ESMTPSA id n16sm7028882pja.46.2021.12.05.01.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 01:58:43 -0800 (PST)
From:   Chris Chiu <chris.chiu@canonical.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH] rtl8xxxu: Improve the A-MPDU retransmission rate with RTS/CTS protection
Date:   Sun,  5 Dec 2021 17:58:36 +0800
Message-Id: <20211205095836.417258-1-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The A-MPDU retransmission rate is always high (> 20%) even in a very
clean environment. However, the vendor driver retransimission rate is
< 10% in the same test bed. The different is the vendor driver starts
the A-MPDU TXOP with initial RTS/CTS handshake which is observed in the
air capture and the TX descriptor. Since there's no related field in
TX descriptor to enable the L-SIG TXOP protection and the duration,
applying the RTS/CTS protection instead helps to lower the retransmission
rate from > 20% to ~12% in the same test setup.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index a42e2081b75f..06d59ffb7444 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4859,7 +4859,7 @@ rtl8xxxu_fill_txdesc_v1(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 	 * rts_rate is zero if RTS/CTS or CTS to SELF are not enabled
 	 */
 	tx_desc->txdw4 |= cpu_to_le32(rts_rate << TXDESC32_RTS_RATE_SHIFT);
-	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
+	if (ampdu_enable || (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS)) {
 		tx_desc->txdw4 |= cpu_to_le32(TXDESC32_RTS_CTS_ENABLE);
 		tx_desc->txdw4 |= cpu_to_le32(TXDESC32_HW_RTS_ENABLE);
 	} else if (rate_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
@@ -4930,7 +4930,7 @@ rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 	/*
 	 * rts_rate is zero if RTS/CTS or CTS to SELF are not enabled
 	 */
-	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
+	if (ampdu_enable || (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS)) {
 		tx_desc40->txdw3 |= cpu_to_le32(TXDESC40_RTS_CTS_ENABLE);
 		tx_desc40->txdw3 |= cpu_to_le32(TXDESC40_HW_RTS_ENABLE);
 	} else if (rate_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
-- 
2.25.1

