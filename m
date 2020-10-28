Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33C629D505
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgJ1V4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbgJ1V4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:56:12 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D59C0613CF;
        Wed, 28 Oct 2020 14:56:12 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id j7so1120239oie.12;
        Wed, 28 Oct 2020 14:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zHdXxs/T9mZg7pnTabmXNYI1gYHQQJ61N4sTHUvcPUk=;
        b=AmUwQcAt1VAGU+7CByHjC1Oes4GGfSweQWXlDbr/CgxxRlilrbYYTenjwbPYHyWEgz
         LHKkymEHL2DocTPL4lE4s+GQ7MnwLW2fbZ8VVqpdXOb7lw036dXA7nGpYVbCDuH1Drc8
         mjDgmgjwN2ET48i7VDJG6QiYUGQHvkY1SH2nnqru/vudIvjqa93+hzscx+Nvsh2a9CrY
         13a7Xjp8UBlCNG7rx9Cjx3h9wI5LXEOHlShiduPrll7YHkterXWu9qvJ04eUO2hO0u1j
         WpgOuzLuGL0Elokp1fJyngH94yqobI2Te7x3nMzibwjr9jD5Kj2aRA3flo0MUczTmrDn
         Y11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zHdXxs/T9mZg7pnTabmXNYI1gYHQQJ61N4sTHUvcPUk=;
        b=KTvV7+WpGvbXzWL9absHP6KSMhSNGXtW6DCLg1fGi+7QG5+RN7YCVQr2wN4L1N40xI
         psj+vHeeJayz6NwfRF9O7laKVtxJg/f+z002BH2WBRLRyscuIRvQyJ8XlZjUBQC7Oo4h
         i/x4wdG5GY7lHd7eNsRtsXKdJhPTmK6yRFESSuD8iOjXiWVC7DZtv6C7lZdXHVLAAtwR
         EMRm3/Uowu2mlBoPVh9zxcEVD5uHlvMUbYPwGGNPqqgu9c4PPumrmknfD5gdfMgMtUqX
         D0MnEAJuNBJzglaTKDdzzriL+XrWSoua0qq6bmdltILYEtAGd3Zj2u3rk37eixsdGc2N
         q9dw==
X-Gm-Message-State: AOAM531RV6PY+mE4hT/JWY2WFDyRbM2P3XGsHAJJnkonp4mCJVbqiY8P
        bEGB6AHtjT7rXhtDa6ddRgoI02VUKCWh5dYb
X-Google-Smtp-Source: ABdhPJxMerd/WVMTl6OAD0Q/nuNJbG+xVQtf6jhUUfBHNGjpniJCbD9kmKMHF4xtAw9wKqE6f/hbuQ==
X-Received: by 2002:a17:90a:5303:: with SMTP id x3mr2781024pjh.188.1603895158254;
        Wed, 28 Oct 2020 07:25:58 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id 194sm6227192pfz.182.2020.10.28.07.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:25:57 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [PATCH 2/3] mwifiex: add allow_ps_mode module parameter
Date:   Wed, 28 Oct 2020 23:24:32 +0900
Message-Id: <20201028142433.18501-3-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201028142433.18501-1-kitakar@gmail.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make the ps_mode (power_save) control easier, this commit adds a new
module parameter allow_ps_mode and set it false (disallowed) by default.

When this parameter is set to false, changing the power_save mode will
be disallowed like the following:

    $ sudo iw dev mlan0 set power_save on
    command failed: Operation not permitted (-1)

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index a6b9dc6700b14..943bc1e8ceaee 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -25,6 +25,11 @@
 static char *reg_alpha2;
 module_param(reg_alpha2, charp, 0);
 
+static bool allow_ps_mode;
+module_param(allow_ps_mode, bool, 0644);
+MODULE_PARM_DESC(allow_ps_mode,
+		 "allow WiFi power management to be enabled. (default: disallowed)");
+
 static const struct ieee80211_iface_limit mwifiex_ap_sta_limits[] = {
 	{
 		.max = MWIFIEX_MAX_BSS_NUM,
@@ -435,6 +440,17 @@ mwifiex_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 
 	ps_mode = enabled;
 
+	/* Allow ps_mode to be enabled only when allow_ps_mode is true */
+	if (ps_mode && !allow_ps_mode) {
+		mwifiex_dbg(priv->adapter, MSG,
+			    "Enabling ps_mode disallowed by modparam\n");
+
+		/* Return -EPERM to inform userspace tools that setting
+		 * power_save to be enabled is not permitted.
+		 */
+		return -EPERM;
+	}
+
 	return mwifiex_drv_set_power(priv, &ps_mode);
 }
 
-- 
2.29.1

