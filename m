Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312026A2D8
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731152AbfGPHVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:21:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:64907 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730935AbfGPHVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 03:21:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 00:20:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="194796238"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jul 2019 00:20:56 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
Date:   Tue, 16 Jul 2019 10:20:37 +0300
Message-Id: <20190716072038.8408-5-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When this new flag is set, we can use single-shot output.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 include/uapi/linux/ptp_clock.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 674db7de64f3..439cbdfc3d9b 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -67,7 +67,9 @@ struct ptp_perout_request {
 	struct ptp_clock_time start;  /* Absolute start time. */
 	struct ptp_clock_time period; /* Desired period, zero means disable. */
 	unsigned int index;           /* Which channel to configure. */
-	unsigned int flags;           /* Reserved for future use. */
+
+#define PTP_PEROUT_ONE_SHOT BIT(0)
+	unsigned int flags;           /* Bit 0 -> oneshot output. */
 	unsigned int rsv[4];          /* Reserved for future use. */
 };
 
-- 
2.22.0

