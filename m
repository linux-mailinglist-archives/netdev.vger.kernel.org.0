Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06CDAD45C
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 09:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbfIIH7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 03:59:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:35724 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfIIH7q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 03:59:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 00:59:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,484,1559545200"; 
   d="scan'208";a="335516815"
Received: from pipin.fi.intel.com ([10.237.72.175])
  by orsmga004.jf.intel.com with ESMTP; 09 Sep 2019 00:59:44 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christopher S Hall <christopher.s.hall@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Subject: [PATCH v3 2/2] PTP: add support for one-shot output
Date:   Mon,  9 Sep 2019 10:59:40 +0300
Message-Id: <20190909075940.12843-2-felipe.balbi@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190909075940.12843-1-felipe.balbi@linux.intel.com>
References: <20190909075940.12843-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some controllers allow for a one-shot output pulse, in contrast to
periodic output. Now that we have extensible versions of our IOCTLs, we
can finally make use of the 'flags' field to pass a bit telling driver
that if we want one-shot pulse output.

Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---

Changes since v2:
	- Add _PEROUT_ to bit macro

Changes since v1:
	- remove comment from .flags field

 include/uapi/linux/ptp_clock.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 12911785991b..cbdc0d97b471 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -38,8 +38,8 @@
 /*
  * Bits of the ptp_perout_request.flags field:
  */
-#define PTP_PEROUT_VALID_FLAGS (~0)
-
+#define PTP_PEROUT_ONE_SHOT (1<<0)
+#define PTP_PEROUT_VALID_FLAGS	(~PTP_PEROUT_ONE_SHOT)
 /*
  * struct ptp_clock_time - represents a time value
  *
@@ -77,7 +77,7 @@ struct ptp_perout_request {
 	struct ptp_clock_time start;  /* Absolute start time. */
 	struct ptp_clock_time period; /* Desired period, zero means disable. */
 	unsigned int index;           /* Which channel to configure. */
-	unsigned int flags;           /* Reserved for future use. */
+	unsigned int flags;
 	unsigned int rsv[4];          /* Reserved for future use. */
 };
 
-- 
2.23.0

