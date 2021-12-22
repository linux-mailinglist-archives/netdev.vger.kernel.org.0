Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7286D47D525
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 17:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343818AbhLVQc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 11:32:56 -0500
Received: from mga04.intel.com ([192.55.52.120]:26260 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241913AbhLVQcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 11:32:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640190774; x=1671726774;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0jBpgX10vStSIFXK437bPzJeyik0oRSAu1eoeyjocR8=;
  b=njHsoqvSVb6OLKXXx0sIokc5i29BC0zcgcvANi0Uap5hfNEvvHidqQDl
   r/JkZkYzR9TQ7RtV2qIn0rMQEXvgra81HOmco6oJtHYrzIKg2CLnr3EY0
   i3OB2M+X3omXq/LdPbvz3Hi2EerIJGu18ewh3gZIfJD1wLby4NGwMeCX/
   t0/79AkxH0hhHkQGfDRQdQv9F3FwpaOFnjHwdwD0OgR/CQ5dXTe5Yu3J1
   hGz58M5YnXq55dH3UdNH3GPmWspxQW3awBdKlSXrnwiu80nl6PXVwil8m
   Kp4U4MRD218GQnzKnZgWB3WsSyJjPXLjJkDGOmsW+/YirW3UtBN27R376
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="239407934"
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="239407934"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 08:32:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,227,1635231600"; 
   d="scan'208";a="521742259"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 22 Dec 2021 08:32:52 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 5BA35FE; Wed, 22 Dec 2021 18:33:00 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] wwan: Replace kernel.h with the necessary inclusions
Date:   Wed, 22 Dec 2021 18:32:56 +0200
Message-Id: <20211222163256.66270-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kernel.h is used in the headers it adds a lot into dependency hell,
especially when there are circular dependencies are involved.

Replace kernel.h inclusion with the list of what is really being used.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/wwan.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index e143c88bf4b0..afb3334ec8c5 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -4,12 +4,9 @@
 #ifndef __WWAN_H
 #define __WWAN_H
 
-#include <linux/device.h>
-#include <linux/kernel.h>
 #include <linux/poll.h>
-#include <linux/skbuff.h>
-#include <linux/netlink.h>
 #include <linux/netdevice.h>
+#include <linux/types.h>
 
 /**
  * enum wwan_port_type - WWAN port types
@@ -37,6 +34,10 @@ enum wwan_port_type {
 	WWAN_PORT_UNKNOWN,
 };
 
+struct device;
+struct file;
+struct netlink_ext_ack;
+struct sk_buff;
 struct wwan_port;
 
 /** struct wwan_port_ops - The WWAN port operations
-- 
2.34.1

