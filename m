Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA6C31BAF9
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 15:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBOOYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 09:24:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:15036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230110AbhBOOXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 09:23:53 -0500
IronPort-SDR: pMgS1aanTxG0BuzUDT2Due8M+FBsLOTf9qAd5MWVDhBiEakcCQjIQrk9M+x6+cDhM+G0v2tZz8
 6PAJMJWbT8MQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9895"; a="182823520"
X-IronPort-AV: E=Sophos;i="5.81,180,1610438400"; 
   d="scan'208";a="182823520"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 06:22:06 -0800
IronPort-SDR: gjS+uCy1RooYV8N9lYHIdqLJT2peNhOwkX157krPVoc1icBBrMwSRfcbzevRHxh9+vpd1sj8YJ
 veRJtpYMOhPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,180,1610438400"; 
   d="scan'208";a="580191385"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2021 06:21:56 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 9E9A8220; Mon, 15 Feb 2021 16:21:55 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alex Deucher <alexander.deucher@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        netdev@vger.kernel.org
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/3] string: Move enableddisabled() helper under string.h hood
Date:   Mon, 15 Feb 2021 16:21:37 +0200
Message-Id: <20210215142137.64476-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
References: <20210215142137.64476-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have already an implementation and a lot of code that can benefit
of the enableddisabled() helper. Move it under string.h hood.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_utils.h | 5 -----
 include/linux/string.h            | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
index d2ac357896d4..b05d72b4dd93 100644
--- a/drivers/gpu/drm/i915/i915_utils.h
+++ b/drivers/gpu/drm/i915/i915_utils.h
@@ -409,11 +409,6 @@ wait_remaining_ms_from_jiffies(unsigned long timestamp_jiffies, int to_wait_ms)
 #define MBps(x) KBps(1000 * (x))
 #define GBps(x) ((u64)1000 * MBps((x)))
 
-static inline const char *enableddisabled(bool v)
-{
-	return v ? "enabled" : "disabled";
-}
-
 void add_taint_for_CI(struct drm_i915_private *i915, unsigned int taint);
 static inline void __add_taint_for_CI(unsigned int taint)
 {
diff --git a/include/linux/string.h b/include/linux/string.h
index 2a0589e945d9..25f055aa4c31 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -318,4 +318,9 @@ static inline const char *onoff(bool on)
 	return on ? "on" : "off";
 }
 
+static inline const char *enableddisabled(bool enabled)
+{
+	return enabled ? "enabled" : "disabled";
+}
+
 #endif /* _LINUX_STRING_H_ */
-- 
2.30.0

