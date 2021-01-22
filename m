Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B80E2FFA67
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbhAVCfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbhAVCeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 21:34:50 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178ADC061786
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:34:10 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id t17so3192437qtq.2
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 18:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9OyF+mVHzBowT5jqUi6kq26BNOfu/Lyfr/uYmIxESS8=;
        b=e7RWnXHOcw/3PQCB00HU7sxPvSclJhxoYRgoKz0d/dKiS6EqYh7TNYR1er4uolrHLL
         RuqUzCaVpJIW6S9aUgQIHyKHQbf0BQrFavk7waFp400P62cbph6gg/o+VN5k5v/jN4sj
         efXykNCYVKgxzCISlAOs7H1IQIUX0Ac1gBA8Tj8r7UrleYu49wtISkTUR9x+0OBrU+QG
         kSpDS5uzE5qpaRq/rujVXvIPdPEhCTHd/8TDd3H6IWPluP9sSvQxA2XZCth5Oow6Bp09
         YAfRE27YhPtgtejxpYdpNgtyc/b5RJQOprFavaYHL2T/MAEHRNkqJVO3AdU26zQCc9p/
         tYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9OyF+mVHzBowT5jqUi6kq26BNOfu/Lyfr/uYmIxESS8=;
        b=jAEXmsld2EMo3BcxmEt8lnSXyhhQPVVb5pAzKBwjFAcuE9QlLR1hU8uV2Yrue0DYPG
         OxoDt3ddc9qYqSoqQ50SzX7HzUERTKMCb8ZHm9iMfN8nrkRbqprKLD+45IW9Axp+hVvP
         Ec9G2JnuUC6gV27JjWdXboHM9Gkr7hW4+Pp1J/qlvYeEChqXuA5zYcelTYT2AyA7VTBj
         taaue/coIWnVUkdt4QK/RUyT7pSOsI4awVJN6ZQxeVDYsnrncDG+EEdvatNAWmwFaIKT
         h+uWRtyGeCKv7tvWzhIXcc1PcdoSDEvvoOXZuGX/CrY9Gwfwlk9DklzF0cTCJXtGYl/Y
         24tw==
X-Gm-Message-State: AOAM533TwCf1V0bIL61ree+67+3ssuXo3VI6+FkcHHAVURODZ36jQxg/
        7aZ+ZFmdYarBtstZgbqlnd/wLw==
X-Google-Smtp-Source: ABdhPJzMn5NmRbsF8RVmskQp97PXferlsocWp8+O6q4zI4VfwkzFgT8J6fDfp+xrFGVjx1n2vHR0eA==
X-Received: by 2002:a05:622a:1d4:: with SMTP id t20mr2479725qtw.281.1611282849348;
        Thu, 21 Jan 2021 18:34:09 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id m13sm4846025qtu.93.2021.01.21.18.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 18:34:08 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        davem@davemloft.net, kuba@kernel.org, luciano.coelho@intel.com
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org, amitk@kernel.org,
        nathan.errera@intel.com
Subject: [PATCH v2 1/3] iwlwifi: mvm: tt: Replace thermal_notify_framework
Date:   Thu, 21 Jan 2021 21:34:04 -0500
Message-Id: <20210122023406.3500424-2-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210122023406.3500424-1-thara.gopinath@linaro.org>
References: <20210122023406.3500424-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thermal_notify_framework just updates for a single trip point where as
thermal_zone_device_update does other bookkeeping like updating the
temperature of the thermal zone and setting the next trip point etc.
Replace thermal_notify_framework with thermal_zone_device_update as the
later is more thorough.

Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---

v1->v2:
	- Removed net: wireless: intel: from subject header of Patch 1
          in the series as per Kalle Valo and added his Acked-by.

 drivers/net/wireless/intel/iwlwifi/mvm/tt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index 507625f96dd7..a0c6be03903a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -146,8 +146,8 @@ void iwl_mvm_temp_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	if (mvm->tz_device.tzone) {
 		struct iwl_mvm_thermal_device *tz_dev = &mvm->tz_device;
 
-		thermal_notify_framework(tz_dev->tzone,
-					 tz_dev->fw_trips_index[ths_crossed]);
+		thermal_zone_device_update(tz_dev->tzone,
+					   THERMAL_TRIP_VIOLATED);
 	}
 #endif /* CONFIG_THERMAL */
 }
-- 
2.25.1

