Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52F4414B92
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbhIVOSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhIVORz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 10:17:55 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C50AC061574;
        Wed, 22 Sep 2021 07:16:25 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id r1so2727418qta.12;
        Wed, 22 Sep 2021 07:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IuXIOcEoJLZm3JHNGPg8RoZZFJipAi9zCbRCXI1CFLE=;
        b=ULd641Oiv+/i7cI8Q/Yn8PvBm7YDEf7KVUnkeQ4VK3WiKgwIfPykRoNewsQTr2PP/y
         7HQyOIQd+RWlJpt+DVpkWk+3QHrraBYva2euDQFQASwfYGBJkiQK1mUgf8hNhN4h4rHJ
         dmM6/sEvP5YB7PZwPV35sNogCKfgXZMXUgRf1janA+efa/kqrGZN7Ulce33nO/+m7crj
         fJnh7jBe8H4x9/lcjWZFXdpptN4dNQ2LBWhC4N0k/JpmYcVNPFvNrF32AN71QtH3FaKC
         IwPZviep9+codxTRfRyWd/8KkZOMS5nUcqfbr8x28tsvMYm8EE4/Xp6H1ree9EeVEAEa
         /lgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IuXIOcEoJLZm3JHNGPg8RoZZFJipAi9zCbRCXI1CFLE=;
        b=Fu0KAdTGmQLv7dZjIDTz3H9hWcR0AniJu7djy2u7Z+FkKdCh1afsDl/rCIxVptvtXC
         MEvWGpMCYs7komKCuRf90SLtkdZM429PhxMtWvSgqK+blay4XwC8+D8CR5nXY4Jdrjgf
         KUDaa/Hhn7Qb0aWWb7p3QkuvCAWZOPirb4Y4iWafSpTyI3sPL2STbX6zgPIFbLjOpwg0
         ov8n/nWAb29A6UbMjiYnYsg5EgLDTlXd5oqm03/HB4OvhvmtOA4cUSs92Y5WF9gfbykq
         gp4V+LauqLOjl+JJpCLIyKmvaHZLlxoXh2l9elS6tnTGUjykhGpZKyvC4yv7a5F9T9V3
         1zbg==
X-Gm-Message-State: AOAM531tnT2jzLIMzVvot04biZ+9lVXpLmhhIFRXR0STAqFebVWdqCQD
        JeRv2xbkvKiUQ37jBsNvFsk/mrwnfZJ1+Q==
X-Google-Smtp-Source: ABdhPJyeaUVIst5XKcgB9ufm77XgKHtZH+7uA7dVm9KtXjXFGvQ4ErNh9WgKtbIlWl3y+PmqAQ7o0Q==
X-Received: by 2002:aed:204b:: with SMTP id 69mr32961757qta.24.1632320183881;
        Wed, 22 Sep 2021 07:16:23 -0700 (PDT)
Received: from localhost.localdomain ([170.84.227.206])
        by smtp.gmail.com with ESMTPSA id w20sm1456275qtj.72.2021.09.22.07.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 07:16:23 -0700 (PDT)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH] mac80211_hwsim: fix incorrect type in initializer
Date:   Wed, 22 Sep 2021 11:16:17 -0300
Message-Id: <20210922141617.189660-1-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This issue was raised by patchwork at:
https://patchwork.kernel.org/project/linux-wireless/patch/20210906175350.13461-1-ramonreisfontes@gmail.com/

Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d36770db1..e31770439 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2997,8 +2997,8 @@ static const struct ieee80211_sband_iftype_data he_capa_6ghz[] = {
 			.capa = IEEE80211_HE_6GHZ_CAP_MIN_MPDU_START |
 			        IEEE80211_HE_6GHZ_CAP_MAX_AMPDU_LEN_EXP |
 			        IEEE80211_HE_6GHZ_CAP_MAX_MPDU_LEN |
-			        IEEE80211_HE_6GHZ_CAP_TX_ANTPAT_CONS |
-			        IEEE80211_HE_6GHZ_CAP_RX_ANTPAT_CONS,
+			        cpu_to_le16(IEEE80211_HE_6GHZ_CAP_TX_ANTPAT_CONS |
+			        IEEE80211_HE_6GHZ_CAP_RX_ANTPAT_CONS),
 		},
 		.he_cap = {
 			.has_he = true,
@@ -3055,8 +3055,8 @@ static const struct ieee80211_sband_iftype_data he_capa_6ghz[] = {
 			.capa = IEEE80211_HE_6GHZ_CAP_MIN_MPDU_START |
 			        IEEE80211_HE_6GHZ_CAP_MAX_AMPDU_LEN_EXP |
 			        IEEE80211_HE_6GHZ_CAP_MAX_MPDU_LEN |
-			        IEEE80211_HE_6GHZ_CAP_TX_ANTPAT_CONS |
-			        IEEE80211_HE_6GHZ_CAP_RX_ANTPAT_CONS,
+			        cpu_to_le16(IEEE80211_HE_6GHZ_CAP_TX_ANTPAT_CONS |
+			        IEEE80211_HE_6GHZ_CAP_RX_ANTPAT_CONS),
 		},
 		.he_cap = {
 			.has_he = true,
-- 
2.25.1

