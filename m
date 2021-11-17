Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408FC4540EF
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 07:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhKQGj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 01:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbhKQGjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 01:39:25 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C57C061570;
        Tue, 16 Nov 2021 22:36:27 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u11so1283030plf.3;
        Tue, 16 Nov 2021 22:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lk2g9E/UqZh2uMhoLR6EkK47x8ZuyfZNR/2euLyi71Y=;
        b=mKTrdafpDhDezv5nTtvQwcErLpJmmsBBzk6i+kGnHq6O05J8gQqq984hvR3eD8nOEc
         1VzD0Vja007MaUAPWwl8Pgm6LfWb6Jf4rNtT6tAEufm7XR/l65qa6XvH9BvEHcrNmEm+
         62WAZmAOAf2gjrJtoLrpjCu+7KFM8s+3AoR8V5hEihZ2C/xQjYjRMf5X7eVqoYTXRe9+
         1kZWgREZgSWfkcF/hluNXdatATVMkSFDgZ8awpEAk0K6e58zb2e62kBt6ZPxN1IFKuUe
         epf9sTRkmeOel+ct0jCgiT2A1vJTN7tYXQ4VQFocgu4cY7F1mt55Oah/QUpRLFsffsA3
         Ka9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lk2g9E/UqZh2uMhoLR6EkK47x8ZuyfZNR/2euLyi71Y=;
        b=jBW4DkrBfDAnLpNUhMdyVXi939GbujJfsNVBGWuYio3rvhag1clYkW0cahM4Dki98p
         yZ6T/T9TcG+WxxpCYssrpmtAvb7emYp6EtsGsdQLefmTZJd1tb3SF2Vf8gmDWOw+78+c
         A1MrTT5gwY+ukMaFYZwAf5KJR14UD4v+ncA/ovg9pBJHGmnxy6hlPXV0OajNtVC8F8qM
         bdKL7zeF4WFrV5UtHoCAAMh6fkY7thrXgJHX0aALz0NaWH5Bfs0ZgbE3fn4WNwMZXJjC
         fE/EezSona4DPTpvbh5vOj3uf8QMu9YaLq7w5ZZ+h7veUOSGekODB1nL84I0DzvKfpBW
         Qs8g==
X-Gm-Message-State: AOAM533ff2eNaJWwOCXE6PCBqFE6xEvyh4+1Y5sqrmGC8QXBZ+PFktQr
        b0uZdoyEIS2nRHATJkC7JVk=
X-Google-Smtp-Source: ABdhPJwM/otgjYa51boTGlRd/bCVd+iUUdLif+7FKr0HaIK6a7VZkY6Y3r5V+VQz67NUBz5e33Fcsw==
X-Received: by 2002:a17:902:b588:b0:143:b732:834 with SMTP id a8-20020a170902b58800b00143b7320834mr39033212pls.22.1637130987270;
        Tue, 16 Nov 2021 22:36:27 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b10sm22225515pfl.200.2021.11.16.22.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 22:36:26 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.guojin@zte.com.cn
To:     luciano.coelho@intel.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        miriam.rachel.korenblit@intel.com, ye.guojin@zte.com.cn,
        johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] iwlwifi: rs: fixup the return value type of iwl_legacy_rate_to_fw_idx()
Date:   Wed, 17 Nov 2021 06:36:21 +0000
Message-Id: <20211117063621.160695-1-ye.guojin@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

This was found by coccicheck:
./drivers/net/wireless/intel/iwlwifi/fw/rs.c, 147, 10-21, WARNING
Unsigned expression compared with zero legacy_rate < 0

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/fw/rs.c     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
index a09081d7ed45..7794cd6d289d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/rs.h
@@ -710,7 +710,7 @@ struct iwl_lq_cmd {
 
 u8 iwl_fw_rate_idx_to_plcp(int idx);
 u32 iwl_new_rate_from_v1(u32 rate_v1);
-u32 iwl_legacy_rate_to_fw_idx(u32 rate_n_flags);
+int iwl_legacy_rate_to_fw_idx(u32 rate_n_flags);
 const struct iwl_rate_mcs_info *iwl_rate_mcs(int idx);
 const char *iwl_rs_pretty_ant(u8 ant);
 const char *iwl_rs_pretty_bw(int bw);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/rs.c b/drivers/net/wireless/intel/iwlwifi/fw/rs.c
index a21c3befd93b..3850881210e6 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/rs.c
@@ -142,7 +142,7 @@ u32 iwl_new_rate_from_v1(u32 rate_v1)
 		}
 	/* if legacy format */
 	} else {
-		u32 legacy_rate = iwl_legacy_rate_to_fw_idx(rate_v1);
+		int legacy_rate = iwl_legacy_rate_to_fw_idx(rate_v1);
 
 		WARN_ON(legacy_rate < 0);
 		rate_v2 |= legacy_rate;
@@ -172,7 +172,7 @@ u32 iwl_new_rate_from_v1(u32 rate_v1)
 }
 IWL_EXPORT_SYMBOL(iwl_new_rate_from_v1);
 
-u32 iwl_legacy_rate_to_fw_idx(u32 rate_n_flags)
+int iwl_legacy_rate_to_fw_idx(u32 rate_n_flags)
 {
 	int rate = rate_n_flags & RATE_LEGACY_RATE_MSK_V1;
 	int idx;
-- 
2.25.1

