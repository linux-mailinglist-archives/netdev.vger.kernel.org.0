Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB50549C699
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239319AbiAZJjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:39:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:9277 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239260AbiAZJjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 04:39:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643189975; x=1674725975;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=85iCTNId4lPzWBpzYMS8JCGZJAAJPSmPWs4cBOEUnho=;
  b=NT1x2iTM0XAZDcIHfAUE9l9dZytFLiCL/cj9NsOwLiDi+s21uwMjM0z+
   ZCx15S7GDAHlMwII7BJl0XqRwYM5cFHaKUz4dBr7S2IRGirSUbkx8zxMk
   +kTvLs213S8jZYmtIYQkiHnIab0QsZwiNs/8WK4W/YnU8ON/bCEhJS4hB
   TOUv3L270cJ01CJP7Pdh6jmmG4qDA/Zo49b304HyXzm4EjRmPnYPw0kl8
   6bTi3KISu9JeBRbsEI9iBwic3dXyJZpHyAT0Io8zT9zhOxXe7QSXti5Jg
   V+oXt+v3GjY1DqwWZworPY9hStNxMvAs4O2lrICCEWs5ks/xn6LGJdB50
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="332869384"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="332869384"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:39:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="477433100"
Received: from lucas-s2600cw.jf.intel.com ([10.165.21.202])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:39:30 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>,
        Emma Anholt <emma@anholt.net>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>, Petr Mladek <pmladek@suse.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH v2 07/11] drm/amd/display: Use str_yes_no()
Date:   Wed, 26 Jan 2022 01:39:47 -0800
Message-Id: <20220126093951.1470898-8-lucas.demarchi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126093951.1470898-1-lucas.demarchi@intel.com>
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the local yesno() implementation and adopt the str_yes_no() from
linux/string_helpers.h.

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c  | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index 26719efa5396..5ff1076b9130 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/string_helpers.h>
 #include <linux/uaccess.h>
 
 #include "dc.h"
@@ -49,11 +50,6 @@ struct dmub_debugfs_trace_entry {
 	uint32_t param1;
 };
 
-static inline const char *yesno(bool v)
-{
-	return v ? "yes" : "no";
-}
-
 /* parse_write_buffer_into_params - Helper function to parse debugfs write buffer into an array
  *
  * Function takes in attributes passed to debugfs write entry
@@ -853,12 +849,12 @@ static int psr_capability_show(struct seq_file *m, void *data)
 	if (!(link->connector_signal & SIGNAL_TYPE_EDP))
 		return -ENODEV;
 
-	seq_printf(m, "Sink support: %s", yesno(link->dpcd_caps.psr_caps.psr_version != 0));
+	seq_printf(m, "Sink support: %s", str_yes_no(link->dpcd_caps.psr_caps.psr_version != 0));
 	if (link->dpcd_caps.psr_caps.psr_version)
 		seq_printf(m, " [0x%02x]", link->dpcd_caps.psr_caps.psr_version);
 	seq_puts(m, "\n");
 
-	seq_printf(m, "Driver support: %s", yesno(link->psr_settings.psr_feature_enabled));
+	seq_printf(m, "Driver support: %s", str_yes_no(link->psr_settings.psr_feature_enabled));
 	if (link->psr_settings.psr_version)
 		seq_printf(m, " [0x%02x]", link->psr_settings.psr_version);
 	seq_puts(m, "\n");
@@ -1207,8 +1203,8 @@ static int dp_dsc_fec_support_show(struct seq_file *m, void *data)
 	drm_modeset_drop_locks(&ctx);
 	drm_modeset_acquire_fini(&ctx);
 
-	seq_printf(m, "FEC_Sink_Support: %s\n", yesno(is_fec_supported));
-	seq_printf(m, "DSC_Sink_Support: %s\n", yesno(is_dsc_supported));
+	seq_printf(m, "FEC_Sink_Support: %s\n", str_yes_no(is_fec_supported));
+	seq_printf(m, "DSC_Sink_Support: %s\n", str_yes_no(is_dsc_supported));
 
 	return ret;
 }
-- 
2.34.1

