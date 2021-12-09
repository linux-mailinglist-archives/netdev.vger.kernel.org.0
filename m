Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F93346E895
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbhLIMmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:42:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:14664 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230094AbhLIMmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 07:42:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="262192313"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="262192313"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 04:38:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="480324314"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 09 Dec 2021 04:38:28 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 657E7329; Thu,  9 Dec 2021 14:38:34 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        heikki.krogerus@linux.intel.com
Subject: [PATCH v1 1/1] include/linux/unaligned: Replace kernel.h with the necessary inclusions
Date:   Thu,  9 Dec 2021 14:38:23 +0200
Message-Id: <20211209123823.20425-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

The rest of the changes are induced by the above and may not be split.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c | 2 ++
 include/linux/unaligned/packed_struct.h                 | 2 +-
 lib/lz4/lz4defs.h                                       | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c
index 2f3c451148db..2f8908074303 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c
@@ -4,6 +4,8 @@
  */
 
 #include <asm/unaligned.h>
+
+#include <linux/math.h>
 #include <linux/string.h>
 #include <linux/bug.h>
 
diff --git a/include/linux/unaligned/packed_struct.h b/include/linux/unaligned/packed_struct.h
index c0d817de4df2..f4c8eaf4d012 100644
--- a/include/linux/unaligned/packed_struct.h
+++ b/include/linux/unaligned/packed_struct.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_UNALIGNED_PACKED_STRUCT_H
 #define _LINUX_UNALIGNED_PACKED_STRUCT_H
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 
 struct __una_u16 { u16 x; } __packed;
 struct __una_u32 { u32 x; } __packed;
diff --git a/lib/lz4/lz4defs.h b/lib/lz4/lz4defs.h
index 673bd206aa98..330aa539b46e 100644
--- a/lib/lz4/lz4defs.h
+++ b/lib/lz4/lz4defs.h
@@ -36,6 +36,8 @@
  */
 
 #include <asm/unaligned.h>
+
+#include <linux/bitops.h>
 #include <linux/string.h>	 /* memset, memcpy */
 
 #define FORCE_INLINE __always_inline
-- 
2.33.0

